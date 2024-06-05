import sys
import os
sys.path = [os.path.join(os.path.dirname(__file__), "..", "..")] + sys.path
from ust.util.logger_factory import logger
from ust.util import config, utils
import pandas as pd
from urllib import error
from urllib.request import urlopen, Request
from selenium.webdriver.common.by import By
import selenium.common.exceptions
from bs4 import BeautifulSoup
from io import StringIO
import time


tank_component_url = 'http://cedatareporting.pa.gov/ReportServer/Pages/ReportViewer.aspx?/Public/DEP/Tanks/SSRS/Tank_Component_Sub&rs:Command=Render&P_OTHER_ID=XXX'

def extract_data_table(soup):
	for element in soup.find_all(['div','span']):
		element.unwrap()

	# tags = soup.find_all(['table','td','tr'])
	# for tag in tags:
	# 	for attribute in ['class','id','name','style','rowspan','colspan','valign']:
	# 		del tag[attribute]

	# for table in soup.find_all('table', attrs={'title': ['First Page','Next Page','Last Page','Previous Page','Refresh']}):
	# 	table.extract()
	# for element in soup.find_all(['input','option','a','img']):
	# 	element.extract()

	tables = []
	for table in soup.find_all('table'):
		if 'FACILITY ID' in table.find('td').text:
			tables.append(table)
	# print(table)
	try:
		table = tables[1]
	except:
		return pd.DataFrame()
	tags = table.find_all(['table','td','tr'])
	for tag in tags:
		for attribute in ['class','id','name','style','rowspan','colspan','valign']:
			del tag[attribute]
	df = pd.read_html(StringIO(table.prettify()))[0]
	df.dropna(inplace=True)
	new_header = df.iloc[0]
	df = df[1:]
	df.columns = new_header
	df.columns = df.columns.str.lower()
	df.columns = df.columns.str.replace(' ', '_')
	pd.set_option('display.max_columns', None)
	pd.set_option('display.max_rows', None)
	# print(df)
	return df


def save_unfound_facility(facility_id):
	conn = utils.connect_db(config.db_name)
	cur = conn.cursor()	

	logger.info('No tank component data found for %s', facility_id)
	sql2 = "insert into pa_ust.facilities_without_tank_info values (%s) on conflict do nothing"
	cur.execute(sql2, (facility_id,))
	conn.commit()

	cur.close()
	conn.close()



def main():
	conn = utils.connect_db(config.db_name)
	cur = conn.cursor()
	engine = utils.get_engine(schema='pa_ust')    

	# sql = """select facility_id from pa_ust.active_tanks 
	# 		where facility_id not in 
	# 			(select facility_id from pa_ust.active_tank_components)
	# 		and facility_id not in 
	# 			(select facility_id from pa_ust.facilities_without_tank_info)				
	# 		order by 1"""
	sql = """select other_id from pa_ust.tanks 
			where other_id not in 
				(select facility_id from pa_ust.active_tank_components)
			and other_id not in 
				(select facility_id from pa_ust.facilities_without_tank_info)				
			order by 1"""

	cur.execute(sql)
	rows = cur.fetchall()
	for row in rows:
		facility_id = row[0]
		logger.info('Working on facility_id %s', facility_id)
		url = tank_component_url.replace('XXX',facility_id)
		try:
			driver = utils.get_selenium_driver(url)
		except selenium.common.exceptions.TimeoutException:    
			logger.info('Website timed out so sleeping 2 minutes')
			time.sleep(120)
			driver = utils.get_selenium_driver(url)
		html = driver.page_source
		num_pages = int(driver.find_element(By.ID, 'ReportViewerControl_ctl05_ctl00_TotalPages').text)
		i = 1
		while i <= num_pages:
			logger.info('Working on page %s of %s', i, num_pages)
			html = driver.page_source
			soup = BeautifulSoup(html, features='html.parser')
			df = extract_data_table(soup)
			if df.empty:
				save_unfound_facility(facility_id)
				i = num_pages + 1
				continue
			else:
				df.to_sql('active_tank_components', engine, if_exists='append', index=False)
				logger.info('Wrote page %s to database', i)

			next_page_button = driver.find_element(By.ID, 'ReportViewerControl_ctl05_ctl00_Next_ctl00_ctl00')
			try:
				next_page_button.click()
			except:
				pass
			time.sleep(3)
			i += 1


	driver.close()	
	cur.close()
	conn.close()


if __name__ == '__main__':       
	main()