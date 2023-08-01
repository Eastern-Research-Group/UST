from logger_factory import logger
import utils
import config

import pandas as pd



def main(ust_or_lust, organization_id=None, control_id=None):
	if organization_id:
		file_path = config.local_ust_path + organization_id.upper() + '/'
		file_name = organization_id.upper() + '_' + ust_or_lust.upper() + '_for_geoprocessing-' + utils.get_today_string() + '.csv'
	else:
		file_path = config.local_ust_path + 'Geocoding/'
		file_name = ust_or_lust.upper() + '_for_geoprocessing-' + utils.get_today_string() + '.csv'
	path = file_path + file_name
	
	if organization_id and not control_id:
		control_id = utils.get_control_id(ust_or_lust, organization_id)

	location_table = 'ust_facilities'
	location_column = 'ust_facilities_id'
	if ust_or_lust.lower() == 'lust':
		location_table = 'lust_locations'
		location_column = 'lust_location_id'

	sql = "select * from " + location_table + " where "
	if organization_id:
		sql = sql + " organization_id = '" + organization_id + "' and control_id = " + str(control_id) + ' and '
	sql = sql + location_column + " not in (select " + location_column + ' from ' + ust_or_lust.lower() + "_geocode)"
	df = pd.read_sql(sql, utils.get_engine(schema='public'))
	df.to_csv(file_path + file_name, index=False)
	logger.info('Exported %s rows to %s at %s for geoprocessing.', len(df), file_name, file_path)


if __name__ == '__main__':   
	organization_id = None
	ust_or_lust = 'lust'
	main(ust_or_lust, organization_id)