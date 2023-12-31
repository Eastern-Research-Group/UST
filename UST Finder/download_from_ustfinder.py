import utils
from logger_factory import logger
from arcgis.gis import GIS
from arcgis.features import FeatureLayer


facilities_layer_url = 'https://services.arcgis.com/cJ9YHowT8TU7DUyn/arcgis/rest/services/UST_Finder_Feature_Layer_2/FeatureServer/0'
facilities_out_fields = 'Facility_ID,Name,Address,City,State,Zip_Code'

usts_layer_url = 'https://services.arcgis.com/cJ9YHowT8TU7DUyn/ArcGIS/rest/services/UST_Finder_Feature_Layer_2/FeatureServer/4'
usts_out_fields = 'State,Facility_ID,Tank_ID,Tank_Status,Capacity'


def get_layer(url):
	gis = GIS() 
	layer = FeatureLayer(url)
	logger.info('layer retrieved from %s', url)
	return layer


def query_layer(layer, out_fields=None, query=None, return_count_only=False):
	if not out_fields:
		out_fields = '*'
	if query:
		results = layer.query(where=query, out_fields=out_fields, return_count_only=return_count_only)
	else:
		results = layer.query(out_fields=out_fields, return_count_only=return_count_only)

	logger.info('query retrieved from layer for out_fields "%s"', out_fields)
	return results


def get_db_cols(data_table, cur=None):
	if not cur:
		conn = utils.connect_db()
		cur = conn.cursor()
	else:
		conn = None

	sql = """select column_name from information_schema.columns
	         where table_schema = 'ust_finder_prod' and table_name = %s
	         order by ordinal_position"""
	cur.execute(sql, (data_table, ))
	rows = cur.fetchall()
	cols = [r[0] for r in rows]

	if conn:
		cur.close()
		conn.close()

	return cols


def get_data(data_table, state=None):
	logger.info('Getting started on downloading %s ....', data_table)

	if state:
		query = "State='" + state + "'"
	else:
		query = None

	if data_table == 'usts':
		layer_url = usts_layer_url
		out_fields = usts_out_fields
	elif data_table == 'facilties':
		layer_url = facilities_layer_url
		out_fields = facilities_out_fields

	layer = get_layer(layer_url)

	conn = utils.connect_db()
	cur = conn.cursor()

	if state:
		sql = f"""select count(*) from ust_finder_prod.{data_table} where "State" = %s"""
		cur.execute(sql, (state,))
		cnt = cur.fetchone()[0]

		results = query_layer(layer, out_fields='State', query=query, return_count_only=True)

		if cnt >= results:
			logger.info('Number of rows in database (%s) >= count from layer (%s) for state %s (%s), no need to continue.', cnt, results, state)
			return

	sql = f"""select distinct "OBJECTID" from ust_finder_prod.{data_table} order by 1"""
	cur.execute(sql)
	rows = cur.fetchall()
	existing_ids = [r[0] for r in rows]

	logger.info('There are %s existing rows that will be ignored', len(existing_ids))

	results = query_layer(layer, out_fields, query=query).features
	total = len(results)
	logger.info('There are %s total results', total)
	logger.info('There are %s results that still need to be downloaded', total - len(existing_ids))

	cols = get_db_cols(data_table)
	placeholders = '('
	for col in cols:
		placeholders = placeholders + '%s,'
	placeholders = placeholders[:-1] + ') '

	i = 1
	for r in results:
		if r.attributes['OBJECTID'] in existing_ids:
			print(r.attributes['OBJECTID'] + ' already in database; skipping')
			continue
		logger.info('Working on %s of %s: OBJECTID %s', i, total - len(existing_ids), r.attributes['OBJECTID'])
		sql = f"""insert into ust_finder_prod.{data_table} values {placeholders} 
				on conflict ("OBJECTID") do nothing"""
		vals = []
		for col in cols:
			vals.append(r.attributes[col])
		try:
			cur.execute(sql, vals)
		except Exception as e:
			logger.error('Unable to insert row for OBJECTID = %s. Error message: %s', r.attributes['OBJECTID'], e)
		i += 1
		if i % 100 == 0:
			conn.commit()
			logger.info('%s database commit', data_table)

	conn.commit()	
	logger.info('Final %s database commit', data_table)	
	cur.close()
	conn.close()

	logger.info('Finished downloading %s!', data_table)

if __name__ == '__main__':   

	states = ['Alabama','Alaska','American Samoa','Arizona','Arkansas','California','Colorado','Commonwealth of the Northern Mariana Islands',
			'Connecticut','Delaware','Florida','Georgia','Guam','Hawaii','Idaho','Illinois','Indiana','Iowa','Kansas','Kentucky','Louisiana',
			'Maine','Maryland','Massachusetts','Michigan','Minnesota','Mississippi','Missouri','Montana','Nebraska','Nevada','New Hampshire',
			'New Jersey','New Mexico','New York','North Carolina','North Dakota','Ohio','Oklahoma','Oregon','Pennsylvania','Puerto Rico',
			'Rhode Island','South Carolina','South Dakota','Tennessee','Texas','U.S. Virgin Islands','Utah','Vermont']

	data_table = 'usts'

	for state in states:
		try:
			get_data(data_table=data_table, state=state)
		except Exception as e:
			logger.error('Error processing %s for state %s: %s', data_table, state, e)


# Alabama
# Alaska
# American Samoa
# Arizona
# Arkansas
# California
# Colorado
# Commonwealth of the Northern Mariana Islands
# Connecticut
# Delaware
# Florida
# Georgia
# Guam
# Hawaii
# Idaho
# Illinois
# Indiana
# Iowa
# Kansas
# Kentucky
# Louisiana
# Maine
# Maryland
# Massachusetts
# Michigan
# Minnesota
# Mississippi
# Missouri
# Montana
# Nebraska
# Nevada
# New Hampshire
# New Jersey
# New Mexico
# New York
# North Carolina
# North Dakota
# Ohio
# Oklahoma
# Oregon
# Pennsylvania
# Puerto Rico
# Rhode Island
# South Carolina
# South Dakota
# Tennessee
# Texas
# U.S. Virgin Islands
# Utah
# Vermont