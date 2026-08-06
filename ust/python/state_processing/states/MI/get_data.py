import os

import http.client
import json
import pandas as pd
import socket
import ssl
import time
from urllib import error, request

from ust.python.util import utils
from ust.python.util.logger_factory import logger
from ust.python.util.export_table import ExportTable


organization_id = 'MI'
api_start_page = None
last_page_table_check = None

ROW_COUNT = 1

init_url = 'https://www.egle.state.mi.us/RIDE/home'
prod_url = f'https://www.egle.state.mi.us/RIDE/api/Location/GetLocationUST?rowCount={ROW_COUNT}&pageNumber='

MAX_URL_TRIES = 3
MAX_TIMEOUT = 10
TIMEOUT_TIME = 300


def nested_get(data, *keys, default=None):
    current = data
    for key in keys:
        if not isinstance(current, dict):
            return default
        current = current.get(key)
        if current is None:
            return default
    return current


def get_session():
    try:
        import requests
    except ModuleNotFoundError as exc:
        raise ModuleNotFoundError('MI get_data requires the requests package to be installed.') from exc

    s = requests.session()
    return s


def get_html(url, session=None, retry_count=0):
    url = url.replace('#','%23').replace(' ','%20')
    html = ''
    if session:
        import requests

        try:
            response = session.get(url, timeout=MAX_TIMEOUT)
            return response.text
        except (requests.exceptions.Timeout, requests.exceptions.ReadTimeout) as e:
            logger.warning('Timed out trying to access %s: %s', url, e)
            return
        except requests.exceptions.RequestException as e:
            logger.warning('Unable to access %s: %s', url, e)
            return
    else:
        try:
            context = ssl._create_unverified_context()
            response = request.urlopen(url, context=context, timeout=MAX_TIMEOUT)
        except error.HTTPError:
            try:
                req = request.Request(url=url, headers={'User-Agent': 'Mozilla/5.0'})
                response = request.urlopen(req)
            except error.HTTPError as e:
                raise e
        except error.URLError as e:
            if isinstance(e.reason, socket.timeout):
                logger.warning('Timed out trying to access %s', url)
        except (error.URLError, TimeoutError, ConnectionResetError) as e:
            if retry_count == MAX_URL_TRIES:
                logger.warning('Exceeded MAX_URL_TRIES attempting to access %s', url)
                raise e
            time.sleep(TIMEOUT_TIME)
            get_html(url, session=session, retry_count=retry_count + 1)
        except (ssl.SSLError, OSError) as e:
            logger.warning('Error attempting to access %s: %s', url, e)
            raise e
    try:
        html = response.read()
    except (http.client.IncompleteRead, ValueError) as e:
        if retry_count == MAX_URL_TRIES:
            raise e
        get_html(url, session=session, retry_count=retry_count + 1)
    return html


class MiApi:
    session = None 
    conn = None 
    cursor = None 
    page_number = None 

    def __init__(self, organization_id, api_start_page=None, last_page_table_check=None):
        self.organization_id = organization_id
        self.api_start_page = api_start_page
        self.last_page_table_check = last_page_table_check
        self.export_dir = '../../../exports/source_data/' + self.organization_id + '/'
        os.makedirs(self.export_dir, exist_ok=True)
        self.file_name = self.organization_id + '_api_data.csv'
        self.export_path = self.export_dir + self.file_name 


    def prepare(self):
        self.session = get_session()
        html = get_html(init_url, session=self.session)
        if self.api_start_page:
            self.page_number = self.api_start_page
        else:
            self.get_last_page_number()


    def connect_db(self):
        if not self.conn:
            self.conn = utils.connect_db()
            self.cursor = self.conn.cursor()        
            logger.info('Connected to database')


    def disconnect_db(self):        
        if self.conn:
            try:
                self.conn.commit()
                self.cursor.close()
                self.conn.close()
                logger.info('Disconnected from database')
            except (AttributeError, psycopg2.Error):
                pass


    def get_last_page_number(self):
        self.connect_db()
        sql = "select max(api_page_number) from mi_ust.location"
        if self.last_page_table_check:
            sql = sql + f" a join mi_ust.{self.last_page_table_check} b on a.locationid = b.locationid"
        utils.process_sql(self.conn, self.cursor, sql)
        try:
            self.page_number = self.cursor.fetchone()[0] + 1
        except TypeError:
            self.page_number = 0
        logger.info('Next page number processed is %s', self.page_number)

        
    def extract_facility_types(self, json, locationid):
        for f in json:
            facilitytype_id = nested_get(f, 'id')
            businesstypeid = nested_get(f, 'businessTypeId')
            facilitytype_name = nested_get(f, 'name')
            isactive = nested_get(f, 'isActive')
            isreserved = nested_get(f, 'isreserved')
            sql = """insert into mi_ust.facilitytype (locationid, id, businesstypeid, name, isactive, isreserved)
                        values (%s, %s, %s, %s, %s, %s)
                        on conflict (locationid, name) do nothing 
                        returning facilitytype_pk"""
            params = (locationid, facilitytype_id, businesstypeid, facilitytype_name, isactive, isreserved)
            utils.process_sql(self.conn, self.cursor, sql, params, exit_on_fail=False)
            try:
                facilitytype_pk = self.cursor.fetchone()[0]
                self.conn.commit()
                logger.info('Inserted locationid %s, facility type %s (facilitytype_pk = %s)', locationid, facilitytype_name, facilitytype_pk)    
            except TypeError:
                pass


    def extract_location_release(self, json, locationid):
        for r in json:
            locationreleaseid = nested_get(r, 'locationReleaseId')
            releasetypeid = nested_get(r, 'releaseTypeId')
            releaselocationid = nested_get(r, 'locationId')
            releaseid = nested_get(r, 'releaseId')
            releasediscovereddate = nested_get(r, 'releaseDiscoveredDate')
            isinstitutionalcontrols = nested_get(r, 'isInstitutionalControls')
            isapprovedprojectcompletion = nested_get(r, 'isApprovedProjectCompletion')
            isclosedwithstatefunds = nested_get(r, 'isClosedWithStateFunds')
            entrydate = nested_get(r, 'entryDate')
            reporteddate = nested_get(r, 'reportedDate')
            releastypeid = nested_get(r, 'releaseType', 'releaseTypeId')
            releasetypename = nested_get(r, 'releaseType', 'name')
            laralocationreleaseid = nested_get(r, 'laraLocationReleaseId')
            haslandresourceuserestrictions = nested_get(r, 'hasLandResourceUseRestrictions')
            sql = """insert into mi_ust.locationrelease (locationid, locationreleaseid, releasetypeid, releaselocationid, releaseid, releasediscovereddate, 
                            isinstitutionalcontrols, isapprovedprojectcompletion, isclosedwithstatefunds, entrydate, 
                            reporteddate, releastypeid, releasetypename, laralocationreleaseid, haslandresourceuserestrictions)
                        values (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                        on conflict (locationid, locationreleaseid) do nothing
                        returning locationrelease_pk"""
            params = (locationid, locationreleaseid, releasetypeid, releaselocationid, releaseid, releasediscovereddate, 
                            isinstitutionalcontrols, isapprovedprojectcompletion, isclosedwithstatefunds, entrydate, 
                            reporteddate, releastypeid, releasetypename, laralocationreleaseid, haslandresourceuserestrictions)
            utils.process_sql(self.conn, self.cursor, sql, params, exit_on_fail=False)
            try:
                locationrelease_pk = self.cursor.fetchone()[0]
                self.conn.commit()
                logger.info('Inserted locationid %s, locationreleaseid %s (locationrelease_pk = %s)', locationid, locationreleaseid, locationrelease_pk)    
            except TypeError:
                pass


    def extract_location_tank(self, json, locationid):
        for r in json:
            locationtankid = nested_get(r, 'locationTankId')
            locationtank_locationid = nested_get(r, 'locationId')
            tankstatusid = nested_get(r, 'tankStatusId')
            tankid = nested_get(r, 'tankId')
            capacity = nested_get(r, 'capacity')
            installationdate = nested_get(r, 'installationDate')
            registrationdate = nested_get(r, 'registrationDate')
            tagged = nested_get(r, 'tagged')
            compartments = nested_get(r, 'compartments')
            changeinservice = nested_get(r, 'changeInService')
            newinstallchangeorupgrade = nested_get(r, 'newInstallChangeOrUpgrade')
            tankfilledwithinertmaterial = nested_get(r, 'tankFilledWithInertMaterial')
            tankwasremovedfromground = nested_get(r, 'tankWasRemovedFromGround')
            tankstatusname = nested_get(r, 'tankStatus', 'name')
            sql = """insert into mi_ust.locationtank(locationid, locationtankid, locationtank_locationid, tankstatusid, tankid, 
                                capacity, installationdate, registrationdate, tagged, compartments, changeinservice, newinstallchangeorupgrade,
                                tankfilledwithinertmaterial, tankwasremovedfromground, tankstatusname)
                        values (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                        on conflict (locationid, tankid) do nothing
                        returning locationtank_pk"""
            params = (locationid, locationtankid, locationtank_locationid, tankstatusid, tankid, 
                        capacity, installationdate, registrationdate, tagged, compartments, changeinservice, newinstallchangeorupgrade,
                        tankfilledwithinertmaterial, tankwasremovedfromground, tankstatusname)
            utils.process_sql(self.conn, self.cursor, sql, params, exit_on_fail=False)
            try:
                locationtank_pk = self.cursor.fetchone()[0]
                self.conn.commit()
                logger.info('Inserted locationid %s, tankId %s', locationid, tankid)    
                self.extract_location_tank_substance(r['locationTankStoredSubstance'], locationtank_pk)
            except TypeError:
                pass
    

    def extract_location_tank_substance(self, json, locationtank_pk):
        for r in json:
            locationtankstoredsubstanceid = nested_get(r, 'locationTankStoredSubstanceId')
            locationtankid = nested_get(r, 'locationTankId')
            storedsubstancetypeid = nested_get(r, 'storedSubstanceTypeId')
            substance_name = nested_get(r, 'storedSubstanceType', 'name')
            isavailableforcoversheetsubmittals = nested_get(r, 'storedSubstanceType', 'isAvailableForCoverSheetSubmittals')
            sql = """insert into mi_ust.locationtankstoredsubstance (locationtank_pk, locationtankstoredsubstanceid, locationtankid, 
                                storedsubstancetypeid, substance_name, isavailableforcoversheetsubmittals)
                        values (%s, %s, %s, %s, %s, %s)
                        on conflict (locationtank_pk, locationtankstoredsubstanceid) do nothing 
                        returning locationtankstoredsubstance_pk"""
            params = (locationtank_pk, locationtankstoredsubstanceid, locationtankid, 
                        storedsubstancetypeid, substance_name, isavailableforcoversheetsubmittals)
            utils.process_sql(self.conn, self.cursor, sql, params, exit_on_fail=False)
            try:
                locationtankstoredsubstance_pk = self.cursor.fetchone()[0]
                self.conn.commit()
                logger.info('Inserted locationtankstoredsubstance_pk %s, substance_name %s', locationtankstoredsubstance_pk, substance_name)    
            except TypeError:
                pass


    def process_json(self, json):
        locationid = json['locationId']
        sitename = nested_get(json, 'siteName')
        facilityid = nested_get(json, 'facilityId')
        latitude = nested_get(json, 'latitude')
        longitude = nested_get(json, 'longitude')
        countyid = nested_get(json, 'county', 'countyId')
        county_name = nested_get(json, 'county', 'name')
        horizontalcollectionmethodid = nested_get(json, 'horizontalCollectionMethod', 'horizontalCollectionMethodId')
        horizontalcollectionmethoddescription = nested_get(json, 'horizontalCollectionMethod', 'description')
        addressid = nested_get(json, 'primaryLocationAddress', 'addressId')
        fulladdress = nested_get(json, 'primaryLocationAddress', 'fullAddress')
        city = nested_get(json, 'primaryLocationAddress', 'city')
        zipcode = nested_get(json, 'primaryLocationAddress', 'zipCode')
        stateid = nested_get(json, 'primaryLocationAddress', 'state', 'stateId')
        state_name = nested_get(json, 'primaryLocationAddress', 'state', 'name')
        townshipid = nested_get(json, 'township', 'townshipId')
        townshipname = nested_get(json, 'township', 'name')
        api_page_number = self.page_number
        
        sql = """insert into mi_ust.location (locationid, sitename, facilityid, latitude, longitude, countyid, county_name, 
                        horizontalcollectionmethodid, horizontalcollectionmethoddescription, 
                        addressid, fulladdress, city, zipcode, stateid, state_name, townshipid, townshipname, api_page_number)
                    values (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                    on conflict (locationid) do nothing"""
        params = (locationid, sitename, facilityid, latitude, longitude, countyid, county_name, 
                        horizontalcollectionmethodid, horizontalcollectionmethoddescription, 
                        addressid, fulladdress, city, zipcode, stateid, state_name, townshipid, townshipname, api_page_number)
        utils.process_sql(self.conn, self.cursor, sql, params, exit_on_fail=False)
        if self.cursor.rowcount > 0:
            self.conn.commit()
            logger.info('Inserted locationid %s, sitename %s', locationid, sitename)    

        self.extract_facility_types(json['facilityType'], locationid)
        self.extract_location_release(json['locationRelease'], locationid)
        self.extract_location_tank(json['locationTank'], locationid)


    def get_counts(self):
        sql = """select count(*), 'location' as table_name from mi_ust.location union all 
                    select count(*), 'facilitytype' as table_name from mi_ust.facilitytype union all 
                    select count(*), 'locationrelease' as table_name from mi_ust.locationrelease union all 
                    select count(*), 'locationtank' as table_name from mi_ust.locationtank union all  
                    select count(*), 'locationtankstoredsubstance' as table_name from mi_ust.locationtankstoredsubstance"""
        df = pd.read_sql(sql, con=utils.get_engine())    
        utils.pretty_print_df(df)


    def process(self):
        self.connect_db()
        self.prepare()

        found_data = True 
        while found_data:
            logger.info('Page number = %s', self.page_number)
            url = prod_url + str(self.page_number)
            logger.info('Working on URL %s', url)
            html = get_html(url, session=self.session)
            if html:
                j = json.loads(html)
                if not j:
                    logger.info('No more data; exiting...')
                    found_data = False
                    break
                for item in j:
                    self.process_json(item)
            self.page_number += 1

        self.get_counts()
        logger.info('Processing complete')
        self.disconnect_db()


    def export(self):
        self.connect_db()
        schema = f'{self.organization_id.lower()}_ust'
        sql = """select table_name from information_schema.tables 
                 where table_schema = %s and table_type = 'BASE TABLE'
                      and table_name not like 'erg_%%' 
                  order by 1"""
        self.cursor.execute(sql, (schema,))
        table_names = [t[0] for t in self.cursor.fetchall()]
        for table_name in table_names:
            e = ExportTable(schema=schema, table_name=table_name, export_dir=f'C:/Users/erguser/repos/ERG/UST/ust/python/exports/source_data/{self.organization_id}/')
            e.export()
        self.disconnect_db()



def main(organization_id, api_start_page=None, last_page_table_check=None):
    a = MiApi(organization_id=organization_id, api_start_page=api_start_page, last_page_table_check=last_page_table_check)
    # a.process()
    a.export()


if __name__ == '__main__':   
    main(organization_id=organization_id, api_start_page=api_start_page, last_page_table_check=last_page_table_check) 
