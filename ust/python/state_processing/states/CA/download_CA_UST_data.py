import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import mechanicalsoup

from python.util.logger_factory import logger
from python.util import utils, config


login_url = 'https://cersregulator.calepa.ca.gov/Account/SignIn?ReturnUrl=%2f'
login_name = 'renaemyers'
login_pword = 'XXXX'


def login(browser):
	browser.open(login_url)
	# print(browser.page)
	browser.select_form() 
	# browser.form.print_summary()
	browser['UserName'] = login_name
	# browser.launch_browser()
	response = browser.submit_selected()
	# print(response.text)
	browser.select_form() 
	# browser.form.print_summary()
	browser['Password'] = login_pword
	response = browser.submit_selected()
	# print(response.text)
	# print(browser.url)
	return browser 


def get_factank_report(browser):
	browser.follow_link('Reports')
	browser.follow_link('USTDataDownloadFacilityTank')
	return browser


def login_report_browser():
	browser = mechanicalsoup.StatefulBrowser()
	browser = login(browser)
	browser = get_factank_report(browser)
	return browser

def get_all_regulators(browser):
	soup = browser.page.find(id='RegulatorID').find_all('option')
	values = [o['value'] for o in soup if o['value']]
	logger.info('There are %s regulator reports to download', len(values))
	return values


def download_regulator_report(browser, regulator_id):
	logger.info('Working on RegulatorID %s', regulator_id)
	browser.select_form()
	browser['RegulatorID'] = regulator_id
	# browser.form.print_summary()
	response = browser.submit_selected()
	file_name = 'data_files/' + str(regulator_id) + '.xlsx'
	with open(file_name, 'wb') as f:
		f.write(response.content)
	logger.info('Downloaded %s', file_name)


def main():
	browser = login_report_browser()
	regulators = get_all_regulators(browser)
	# regulators = [1003, 1004]
	for regulator_id in regulators:
		browser = login_report_browser()
		download_regulator_report(browser, regulator_id)
	logger.info('Finished downloading CA data; find data files in ../data_files and run script to upload to database')
		
	
if __name__ == '__main__':       
	main()

