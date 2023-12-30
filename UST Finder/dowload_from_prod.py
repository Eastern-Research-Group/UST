import utils
from logger_factory import logger
from arcgis.gis import GIS
from arcgis.features import FeatureLayer


facilities_layer_url = 'https://services.arcgis.com/cJ9YHowT8TU7DUyn/arcgis/rest/services/UST_Finder_Feature_Layer_2/FeatureServer/0'
facilities_out_fields = 'Facility_ID,Name,Address,City,State,Zip_Code'


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
	logger.info('Getting started....')

	conn = utils.connect_db()
	cur = conn.cursor()

	sql = """select distinct "Facility_ID" from ust_finder_prod.facilities order by 1"""
	cur.execute(sql)
	rows = cur.fetchall()
	existing_ids = [r[0] for r in rows]

	logger.info('There are %s existing Facility IDs that will be ignored', len(existing_ids))

	layer = get_layer(facilities_layer_url)
	# results = query_layer(layer, out_fields, query="Facility_ID='AL1'").features
	results = query_layer(layer, facilities_out_fields).features
	total = len(results)
	logger.info('There are %s total results', total)
	logger.info('There are %s results that still need to be downloaded', total - len(existing_ids))

	i = 1
	for r in results:
		if r.attributes['Facility_ID'] in existing_ids:
			continue
		logger.info('Working on %s of %s: Facility ID %s', i, total, r.attributes['Facility_ID'])
		sql = """insert into ust_finder_prod.facilities values (%s, %s, %s, %s, %s, %s) 
				on conflict ("Facility_ID") do nothing"""
		vals = (r.attributes['Facility_ID'], r.attributes['Name'], r.attributes['Address'], r.attributes['City'], r.attributes['State'], r.attributes['Zip_Code'])
		try:
			cur.execute(sql, vals)
		except Exception as e:
			logger.error('Unable to insert row: Facility_ID = %s, Name = %s, Address = %s, City = %s, State = %s, Zip_Code = %s.', 
				         r.attributes['Facility_ID'], r.attributes['Name'], r.attributes['Address'], r.attributes['City'], r.attributes['State'], r.attributes['Zip_Code'])
		i += 1
		if i % 100 == 0:
			conn.commit()
			logger.info('Database commit')

	conn.commit()	
	logger.info('Final database commit')	
	cur.close()
	conn.close()

	logger.info('Done!')

if __name__ == '__main__':   
	get_facilities()

