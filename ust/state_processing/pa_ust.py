import sys
import os
sys.path = [os.path.join(os.path.dirname(__file__), "..", "..")] + sys.path
from ust.util.logger_factory import logger
from ust.util import config, utils
# import pandas as pd
from urllib import error
from urllib.request import urlopen, Request
from selenium.webdriver.common.by import By
from bs4 import BeautifulSoup
import time


tank_component_url = 'http://cedatareporting.pa.gov/ReportServer/Pages/ReportViewer.aspx?/Public/DEP/Tanks/SSRS/Tank_Component_Sub&rs:Command=Render&P_OTHER_ID=XXX'

def get_data(soup):
	pass

def main():
	conn = utils.connect_db(config.db_name)
	cur = conn.cursor()

	sql = """select facility_id from pa_ust.active_tanks 
			where facility_id not in 
				(select facility_id from pa_ust.active_tank_components)
			order by 1"""
	cur.execute(sql)
	rows = cur.fetchall()
	for row in rows:
		facility_id = row[0]
		logger.info('Working on facility_id %s', facility_id)
		url = tank_component_url.replace('XXX',facility_id)
		driver = utils.get_selenium_driver(url)
		html = driver.page_source
		num_pages = int(driver.find_element(By.ID, 'ReportViewerControl_ctl05_ctl00_TotalPages').text)
		# i = 1
		# while i < num_pages:
		# 	print(i)
		# 	next_page_button = driver.find_element(By.ID, 'ReportViewerControl_ctl05_ctl00_Next_ctl00_ctl00')
		# 	next_page_button.click()
		# 	time.sleep(3)
		# 	i += 1


		soup = BeautifulSoup(html, features='html.parser')
		# num_pages = soup.find_all("span", attrs={'id':'ReportViewerControl_ctl05_ctl00_TotalPages'})
		div = soup.find('div', attrs={'id':'VisibleReportContentReportViewerControl_ctl09'})
		table = soup.find_all('table')[2]
		print(table)

		driver.close()	

		exit()

# facility_id
# primary_facility_name
# seq_number
# tank_code
# tank_system_component
# tank_component
# date_begin



	cur.close()
	conn.close()





if __name__ == '__main__':       
	main()