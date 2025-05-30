import sys
import os
sys.path = [os.path.join(os.path.dirname(__file__), "..", "..")] + sys.path
from ust.python.util.logger_factory import logger
from ust.python.util import utils, config
from ust.python.util import utils
import psycopg2.errors


def update_col_name(cur, view_name, column_names):
	sql = f'alter view {view_name} rename "{column_names[0]}" to "{column_names[1]}"'
	try:
		cur.execute(sql)
	except psycopg2.errors.UndefinedColumn as e:
		pass

def update_col_names(organization_id, ust_or_lust, view_name=None):
	conn = utils.connect_db()
	cur = conn.cursor()

	if view_name:
		view_name = '"' + utils.get_schema_name(organization_id, ust_or_lust) + '".' + view_name
	else:
		view_name = utils.get_view_name(organization_id, ust_or_lust)

	logger.info('Updating %s', view_name)

	if ust_or_lust.lower() == 'ust':
		update_col_name(cur, view_name, ('FacilityOwnerOperatorName','FacilityOperatorCompanyName'))
		update_col_name(cur, view_name, ('NumberofCompartments','NumberOfCompartments'))
		update_col_name(cur, view_name, ('CertofInstallation','CertOfInstallation'))
		update_col_name(cur, view_name, ('TankCorrosionProtectionSacrificialAnodes','TankCorrosionProtectionSacrificialAnode'))
		update_col_name(cur, view_name, ('TankCorrosionProtectionAnodesInstalledOrRetrofitted','TankCorrosionProtectionAnodeInstalledOrRetrofitted'))
		update_col_name(cur, view_name, ('PipingCorrosionProtectionSacrificialAnodes','PipingCorrosionProtectionSacrificialAnode'))
		update_col_name(cur, view_name, ('PipingCorrosionProtectionAnodesInstalledOrRetrofitted','PipingCorrosionProtectionAnodeInstalledOrRetrofitted'))
		update_col_name(cur, view_name, ('ElectronicLineLeakDetection','ElectronicLineLeak'))
		update_col_name(cur, view_name, ('MechanicalLineLeakDetection','MechanicalLineLeakDetection'))
		update_col_name(cur, view_name, ('AmericanSafeSuction','AmericanSuction'))
		update_col_name(cur, view_name, ('PipingUDCForEveryDispenser','PipingUDC'))
		update_col_name(cur, view_name, ('AutomaticShutoffDevice','FlowShutoffDevice'))
		update_col_name(cur, view_name, ('OverfillAlarm','HighLevelAlarm'))
	elif ust_or_lust.lower() == 'lust':
		update_col_name(cur, view_name, ('RemediationStrategy1','CorrectiveActionStrategy1'))
		update_col_name(cur, view_name, ('RemediationStrategy2','CorrectiveActionStrategy2'))
		update_col_name(cur, view_name, ('RemediationStrategy3','CorrectiveActionStrategy3'))
		update_col_name(cur, view_name, ('RemediationStrategy1StartDate','CorrectiveActionStrategy1StartDate'))
		update_col_name(cur, view_name, ('RemediationStrategy2StartDate','CorrectiveActionStrategy2StartDate'))
		update_col_name(cur, view_name, ('RemediationStrategy3StartDate','CorrectiveActionStrategy3StartDate'))

	cur.close()
	conn.close()

	logger.info('Column names updated in %s', view_name)


def new_column_names_view(view_name, ust_or_lust):
	conn = utils.connect_db()
	cur = conn.cursor()

	sql = "select table_schema from information_schema.tables where table_name = %s"
	cur.execute(sql, (view_name,))
	rows = [r[0] for r in cur.fetchall()]
	for row in rows:
		i = row.find('_')
		organization_id = row[:i]
		update_col_names(organization_id, ust_or_lust, view_name)
		logger.info('Updated "%s_%s".%s', organization_id, ust_or_lust.upper(), view_name)

	cur.close()
	conn.close()


def new_column_names_all_organization_ids(ust_or_lust):
	view_name = 'v_' + ust_or_lust.lower() + '_base'
	new_column_names_view(view_name, ust_or_lust)
	view_name = 'v_' + ust_or_lust.lower() 
	new_column_names_view(view_name, ust_or_lust)


def main(organization_id, ust_or_lust):
	update_col_names(organization_id, ust_or_lust)

	schema = utils.get_schema_name(organization_id, ust_or_lust)
	new_view_name = '"' + schema + '".v_' + ust_or_lust.lower() 

	base_view_name = 'v_' + ust_or_lust.lower() + '_base' 
	logger.info('Gathering view information for %s', base_view_name)
	base_cols = utils.get_view_info(organization_id, ust_or_lust, base_view_name)
	from_sql = base_cols[1]
	base_aliases = base_cols[0].keys()
	
	conn = utils.connect_db()
	cur = conn.cursor()
	
	sql = """select column_name, data_type
			 from information_schema.columns 
			 where table_schema = 'public' and table_name = %s 
			 and column_name not in ('id','control_id','organization_id')
			 order by ordinal_position"""
	cur.execute(sql, (ust_or_lust,))
	rows = cur.fetchall()

	view_sql = 'create view ' + new_view_name + ' as select distinct '
	for row in rows:
		column_name = row[0]
		data_type = row[1]
		if column_name in base_aliases:
			col_def = base_cols[0][column_name]
			if '::' in col_def:
				view_sql = view_sql + col_def + ' as "' + column_name + '",\n'
			else:
				view_sql = view_sql + col_def + '::' + data_type + ' as "' + column_name + '",\n'
		else:
			view_sql = view_sql + 'null::' + data_type + ' as "' + column_name + '",\n'
	view_sql = view_sql[:-2] + '\n' + from_sql

	try:
		cur.execute('drop view ' + new_view_name)
		logger.info('Dropped %s', new_view_name)
	except psycopg2.errors.UndefinedTable:
		pass

	cur.execute(view_sql)
	logger.info('Created %s', new_view_name)

	cur.close()
	conn.close()


if __name__ == '__main__':   
	organization_id = 'TRUSTD'
	ust_or_lust = 'ust'
	update_col_names(organization_id, ust_or_lust)
