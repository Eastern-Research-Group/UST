import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import csv
import json 
import pandas as pd
import requests
import socket
import ssl
import time
from urllib import error, parse, request

from python.util import utils
from python.util.dataset import Dataset 
from python.util.logger_factory import logger
from python.util.export_table import ExportTable


organization_id = 'MI'
api_start_page = None
last_page_table_check = None

ROW_COUNT = 1

init_url = 'https://www.egle.state.mi.us/RIDE/home'
prod_url = f'https://www.egle.state.mi.us/RIDE/api/Location/GetLocationUST?rowCount={ROW_COUNT}&pageNumber='

MAX_URL_TRIES = 3
MAX_TIMEOUT = 10
TIMEOUT_TIME = 300


def get_session():
  s = requests.session()
  return s


def get_html(url, session=None, retry_count=0):
	url = url.replace('#','%23').replace(' ','%20')
	html = ''
	if session:
		try:
			response = session.get(url, timeout=MAX_TIMEOUT)
			return response.text
		except (requests.exceptions.Timeout, requests.exceptions.ReadTimeout) as e:
			logger.warning('Timed out trying to access %s: %s', url, e)
			return
		except Exception as e:
			logger.warning('Unable to access %s: %s', url, e)
			return
	else:
		try:
			context = ssl._create_unverified_context()
			response = urlopen(url, context=context, timeout=MAX_TIMEOUT)
		except error.HTTPError:
			try:
				req = Request(url=url, headers={'User-Agent': 'Mozilla/5.0'})
				response = urlopen(req)
			except error.HTTPError as e:
				raise e
		except error.URLError as e:
			if isinstance(e.reason, socket.timeout):
				logger.warning('Timed out trying to access %s', url)
		except (error.URLError, TimeoutError, ConnectionResetError) as e:
			if retry_count == MAX_URL_TRIES:
				logger.warning('Exceeded MAX_URL_TRIES attempting to access %s', url)
				raise e
			time.sleep(config.TIMEOUT_TIME)
			get_html(url, session=session, retry_count=retry_count + 1)
		except Exception as e:
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
			except:
				pass


	def get_last_page_number(self):
		self.connect_db()
		sql = "select max(api_page_number) from mi_ust.location"
		if self.last_page_table_check:
			sql = sql + f" a join mi_ust.{self.last_page_table_check} b on a.locationid = b.locationid"
		utils.process_sql(self.conn, self.cursor, sql)
		try:
			self.page_number = self.cursor.fetchone()[0] + 1
		except:
			self.page_number = 0
		logger.info('Next page number processed is %s', self.page_number)

		
	def extract_facility_types(self, json, locationid):
		for f in json:
			try:
				facilitytype_id = f['id']
			except:
				facilitytype_id = None 
			try:
				businesstypeid = f['businessTypeId']
			except:
				businesstypeid = None 
			try:
				facilitytype_name = f['name']
			except:
				facilitytype_name = None 
			try:
				isactive = f['isActive']
			except:
				isactive = None 
			try:
				isreserved = f['isreserved']
			except:
				isreserved = None 
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
			try:
				locationreleaseid = r['locationReleaseId']
			except:
				locationreleaseid = None 
			try:
				releasetypeid = r['releaseTypeId']
			except:
				releasetypeid = None 
			try:
				releaselocationid = r['locationId']
			except:
				releaselocationid = None 
			try:
				releaseid = r['releaseId']
			except:
				releaseid = None 
			try:
				releasediscovereddate = r['releaseDiscoveredDate']
			except:
				releasediscovereddate = None 
			try:
				isinstitutionalcontrols = r['isInstitutionalControls']
			except:
				isinstitutionalcontrols = None 
			try:
				isapprovedprojectcompletion = r['isApprovedProjectCompletion']
			except:
				isapprovedprojectcompletion = None 
			try:
				isclosedwithstatefunds = r['isClosedWithStateFunds']
			except:
				isclosedwithstatefunds = None 
			try:
				entrydate = r['entryDate']
			except:
				entrydate = None 
			try:
				reporteddate = r['reportedDate']
			except:
				reporteddate = None 
			try:
				releastypeid = r['releaseType']['releaseTypeId']
			except:
				releastypeid = None 
			try:
				releasetypename = r['releaseType']['name']
			except:
				releasetypename = None 
			try:
				laralocationreleaseid = r['laraLocationReleaseId']
			except:
				laralocationreleaseid = None 
			try:
				haslandresourceuserestrictions = r['hasLandResourceUseRestrictions']
			except:
				haslandresourceuserestrictions = None
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
			try:
				locationtankid = r['locationTankId']
			except:
				locationtankid = None 
			try:
				locationtank_locationid = r['locationId']
			except:
				locationtank_locationid = None 
			try:
				tankstatusid = r['tankStatusId']
			except:
				tankstatusid = None 
			try:
				tankid = r['tankId']
			except:
				tankid = None 
			try:
				capacity = r['capacity']
			except:
				capacity = None 
			try:
				installationdate = r['installationDate']
			except:
				installationdate = None 
			try:
				registrationdate = r['registrationDate']
			except:
				registrationdate = None 
			try:
				tagged = r['tagged']
			except:
				tagged = None 
			try:
				compartments = r['compartments']
			except:
				compartments = None 
			try:
				changeinservice = r['changeInService']
			except:
				changeinservice = None 
			try:
				newinstallchangeorupgrade = r['newInstallChangeOrUpgrade']
			except:
				newinstallchangeorupgrade = None 
			try:
				tankfilledwithinertmaterial = r['tankFilledWithInertMaterial']
			except:
				tankfilledwithinertmaterial = None 
			try:
				tankwasremovedfromground = r['tankWasRemovedFromGround']
			except:
				tankwasremovedfromground = None 
			try:
				tankstatusname = r['tankStatus']['name']
			except:
				tankstatusname = None 
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
			try:
				locationtankstoredsubstanceid = r['locationTankStoredSubstanceId']
			except:
				locationtankstoredsubstanceid = None 	
			try:
				locationtankid = r['locationTankId']
			except:
				locationtankid = None 	
			try:
				storedsubstancetypeid = r['storedSubstanceTypeId']
			except:
				storedsubstancetypeid = None 	
			try:
				substance_name = r['storedSubstanceType']['name']
			except:
				substance_name = None 	
			try:
				isavailableforcoversheetsubmittals = r['storedSubstanceType']['isAvailableForCoverSheetSubmittals']
			except:
				isavailableforcoversheetsubmittals = None 		
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
		try:
			sitename = json['siteName']
		except:
			sitename = None 
		try:
			facilityid = json['facilityId']
		except:
			facilityid = None 
		try:
			latitude = json['latitude']
		except:
			latitude = None 
		try:
			longitude = json['longitude']
		except:
			longitude = None 
		try:
			countyid = json['county']['countyId']
		except:
			countyid = None 
		try:
			county_name = json['county']['name']
		except:
			county_name = None 
		try:
			horizontalcollectionmethodid = json['horizontalCollectionMethod']['horizontalCollectionMethodId']
		except:
			horizontalcollectionmethodid = None 
		try:
			horizontalcollectionmethoddescription = json['horizontalCollectionMethod']['description']
		except:
			horizontalcollectionmethoddescription = None 
		try:
			addressid = json['primaryLocationAddress']['addressId']
		except:
			addressid = None 
		try:
			fulladdress = json['primaryLocationAddress']['fullAddress']
		except:
			fulladdress = None 
		try:
			city = json['primaryLocationAddress']['city']
		except:
			city = None 
		try:
			zipcode = json['primaryLocationAddress']['zipCode']
		except:
			zipcode = None 
		try:
			stateid = json['primaryLocationAddress']['state']['stateId']
		except:
			stateid = None 
		try:
			state_name = json['primaryLocationAddress']['state']['name']
		except:
			state_name = None 
		try:
			townshipid = json['township']['townshipId']
		except:
			townshipid = None 
		try:
			townshipname = json['township']['name']
		except:
			townshipname = None 
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