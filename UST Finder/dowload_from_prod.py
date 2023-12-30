import utils
from logger_factory import logger
from arcgis.gis import GIS
from arcgis.features import FeatureLayer


facilities_layer_url = 'https://services.arcgis.com/cJ9YHowT8TU7DUyn/arcgis/rest/services/UST_Finder_Feature_Layer_2/FeatureServer/0'
facilities_out_fields = 'OBJECTID,Facility_ID,Name,Address,City,State,Zip_Code'

usts_layer_url = 'https://services.arcgis.com/cJ9YHowT8TU7DUyn/ArcGIS/rest/services/UST_Finder_Feature_Layer_2/FeatureServer/4'
usts_out_fields = 'OBJECTID,Facility_ID,Tank_ID,Tank_Status,Capacity'


def get_layer(url):
	gis = GIS() 
	layer = FeatureLayer(url)
	logger.info('layer retrieved from %s', url)
	return layer


def query_layer(layer, out_fields=None, query=None):
	if not out_fields:
		out_fields = '*'
	if query:
		results = layer.query(where=query, out_fields=out_fields)
	else:
		results = layer.query(out_fields=out_fields)
	logger.info('query retrieved from layer for out_fields "%s"', out_fields)
	return results


def get_facilities():
	logger.info('Getting started on downloading facilities....')

	conn = utils.connect_db()
	cur = conn.cursor()

	sql = """select distinct "OBJECTID" from ust_finder_prod.facilities order by 1"""
	cur.execute(sql)
	rows = cur.fetchall()
	existing_ids = [r[0] for r in rows]

	logger.info('There are %s existing rows that will be ignored', len(existing_ids))

	layer = get_layer(facilities_layer_url)
	# results = query_layer(layer, out_fields, query="Facility_ID='AL1'").features
	query = "State='Alaska'"
	results = query_layer(layer, facilities_out_fields, query=query).features
	total = len(results)
	logger.info('There are %s total results', total)
	logger.info('There are %s results that still need to be downloaded', total - len(existing_ids))

	i = 1
	for r in results:
		if r.attributes['OBJECTID'] in existing_ids:
			print(r.attributes['OBJECTID'] + ' already in database; skipping')
			continue
		logger.info('Working on %s of %s: OBJECTID %s, Facility ID %s', i, total - len(existing_ids), r.attributes['OBJECTID'], r.attributes['Facility_ID'])
		sql = """insert into ust_finder_prod.facilities values (%s, %s, %s, %s, %s, %s) 
				on conflict ("OBJECTID") do nothing"""
		vals = (r.attributes['OBJECTID'], r.attributes['Facility_ID'], r.attributes['Name'], r.attributes['Address'], r.attributes['City'], r.attributes['State'], r.attributes['Zip_Code'])
		try:
			cur.execute(sql, vals)
		except Exception as e:
			logger.error('Unable to insert row: OBJECTID = %s, Facility_ID = %s, Name = %s, Address = %s, City = %s, State = %s, Zip_Code = %s.', 
				         r.attributes['OBJECTID'], r.attributes['Facility_ID'], r.attributes['Name'], r.attributes['Address'], r.attributes['City'], r.attributes['State'], r.attributes['Zip_Code'])
		i += 1
		if i % 100 == 0:
			conn.commit()
			logger.info('Facilities database commit')

	conn.commit()	
	logger.info('Final Facilities database commit')	
	cur.close()
	conn.close()

	logger.info('Finished downloading facilities!')


def get_usts():
	logger.info('Getting started on downloading USTs....')

	conn = utils.connect_db()
	cur = conn.cursor()

	sql = """select distinct "OBJECTID" from ust_finder_prod.usts order by 1"""
	cur.execute(sql)
	rows = cur.fetchall()
	existing_ids = [r[0] for r in rows]

	logger.info('There are %s existing rows that will be ignored', len(existing_ids))

	layer = get_layer(usts_layer_url)
	# results = query_layer(layer, out_fields, query="Facility_ID='AL1'").features
	results = query_layer(layer, usts_out_fields).features
	total = len(results)
	logger.info('There are %s total results', total)
	logger.info('There are %s results that still need to be downloaded', total - len(existing_ids))

	i = 1
	for r in results:
		if r.attributes['OBJECTID'] in existing_ids:
			print(r.attributes['OBJECTID'] + ' already in database; skipping')
			continue
		logger.info('Working on %s of %s: OBJECTID %s, Facility ID %s, Tank ID %s', i, total - len(existing_ids), r.attributes['OBJECTID'], r.attributes['Facility_ID'], r.attributes['Tank_ID'])
		sql = """insert into ust_finder_prod.usts values (%s, %s, %s, %s, %s) 
				on conflict ("OBJECTID") do nothing"""
		vals = (r.attributes['OBJECTID'], r.attributes['Facility_ID'], r.attributes['Tank_ID'], r.attributes['Tank_Status'], r.attributes['Capacity'])
		try:
			cur.execute(sql, vals)
		except Exception as e:
			logger.error('Unable to insert row: OBJECTID = %s, Facility_ID = %s, Tank_ID = %s, Tank_Status = %s, Capacity = %s', 
				         r.attributes['OBJECTID'], r.attributes['Facility_ID'], r.attributes['Tank_ID'], r.attributes['Tank_Status'], r.attributes['Capacity'])
		i += 1
		if i % 100 == 0:
			conn.commit()
			logger.info('USTs database commit')

	conn.commit()	
	logger.info('Final USTs database commit')	
	cur.close()
	conn.close()

	logger.info('Finished downloading USTs!')

if __name__ == '__main__':   
	get_facilities()

