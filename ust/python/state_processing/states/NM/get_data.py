import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import csv
import json 
from urllib.request import urlopen
import pandas as pd

from python.util import utils
from python.util.dataset import Dataset 
from python.util.logger_factory import logger


organization_id = 'NM'

api_key = '1TRZQ82GYAlRoYxoNqszhUblvThdjDVY'
api_secrte = 'RlITZLxOMuPKFstm'
api_products = ['Waste Community Prod','Waste Partners Prod','Waste Public Prod']


url_prefix = 'https://prxy.env.nm.gov'

tank_info_code_url = url_prefix + '/tank-info-code/'
tank_detail_code_url = url_prefix + '/tank-detail-code/'
tank_info_url = url_prefix + '/tank-info/'
tank_detail_url = url_prefix + '/tank-details/'

# tank_urls = [tank_info_url, tank_info_code_url, tank_detail_code_url]
tank_urls = [tank_info_url]

release_info_url = url_prefix + '/release-info/'
release_detail_url = url_prefix + '/release-detail/'
release_incident_type_url = url_prefix + '/release-incident-type/'
release_incident_type_def_url = url_prefix + '/release-incident-type-def/'

release_urls = [release_info_url]

url_var = '?apikey='

tank_info_path = r'C:\Users\erguser\repos\ERG\UST\ust\python\exports\source_data\NM\NM_tank-info_2025-05-12.csv'
tank_detail_path = r'C:\Users\erguser\repos\ERG\UST\ust\python\exports\source_data\NM\NM_tank-details_2025-05-12.csv'
release_info_path = r'C:\Users\erguser\repos\ERG\UST\ust\python\exports\source_data\NM\NM_release-info_2025-05-13.csv'
release_detail_path = r'C:\Users\erguser\repos\ERG\UST\ust\python\exports\source_data\NM\NM_release-detail_2025-05-13.csv'


class NmApi:
	json = None 
	csv_file = None  
	file_name = None 
	export_path = None 
	ids = None 

	def __init__(self, organization_id, api_key, url_prefix):
		self.organization_id = organization_id
		self.api_key = api_key
		self.url_prefix = url_prefix
		self.export_dir = '../../../exports/source_data/' + self.organization_id + '/'
		os.makedirs(self.export_dir, exist_ok=True)


	def get_file_name(self, url):
		url = url.replace(url_prefix + '/','')
		i = url.find('/')
		file_name = url[:i]
		file_name = self.organization_id + '_' + file_name + '_' + utils.get_today_string() + '.csv'
		logger.info('File name is %s', file_name)
		return file_name 


	def get_json_data(self, url):
		try: 
			with urlopen(url) as u:
				self.json = json.load(u)
		except Exception as e:
			logger.error('Unable to download data from URL %s; skipping.', url)
			return
		logger.info('Downloaded JSON data from %s', url)
		self.json = self.json['result']['out_cur']


	def get_first_obj(self, json):
		return json[0]


	def get_csv_headers(self, obj):
		return [k for k in obj.keys()]


	def get_values(self, obj):
		return [v for v in obj.values()]


	def open_csv(self):
		obj = self.get_first_obj(self.json)
		headers = self.get_csv_headers(obj)	
		if 'release-detail' in self.export_path and 'RELEASE_ID' not in headers:
			headers.insert(0, 'RELEASE_ID')	
		with open(self.export_path, 'w', newline='') as f:
			writer = csv.writer(f)
			writer.writerow(headers)
			logger.info('Opened %s', self.export_path)


	def save_json_to_csv(self):
		with open(self.export_path, 'a', newline='') as f:
			writer = csv.writer(f)
			for obj in self.json:
				writer.writerow(self.get_values(obj))
	

	def set_path(self, url):
		self.file_name = self.get_file_name(url)
		self.export_path = self.export_dir + self.file_name 		


	def process_url(self, url):
		self.set_path(url)
		self.get_json_data(url)
		self.open_csv()
		self.save_json_to_csv()
		logger.info('Wrote JSON to %s', self.export_path)


	def process_detail_data(self, detail_url):
		if 'tank' in detail_url:
			param_var = 'tank_id'
		elif 'release' in detail_url:
			param_var = 'release_id'
		url_base = detail_url + url_var + self.api_key + '&' + param_var + '='

		with open(self.export_path, 'a', newline='') as f:
			writer = csv.writer(f)
			for id in self.ids:
				url = url_base + str(id)
				logger.info('Working on URL %s', url)
				self.get_json_data(url)
				for obj in self.json:
					values = self.get_values(obj)
					if param_var == 'release_id':
						values.insert(0, id)
					writer.writerow(values)


	def process_details(self, detail_url, info_path):
		self.set_path(detail_url)
		df = pd.read_csv(info_path)
		self.ids = list(df.iloc[:, 0].unique())
		if 'tank' in detail_url:
			param_var = 'tank_id'
		elif 'release' in detail_url:
			param_var = 'release_id'
		url = detail_url + url_var + self.api_key + '&' + param_var + '=' + str(self.ids[0])
		logger.info('Working on URL %s', url)
		self.get_json_data(url)
		self.open_csv()
		self.process_detail_data(detail_url)


	def process_tank_urls(self):
		for u in tank_urls:
			url = u + url_var + self.api_key 
			logger.info('Working on URL %s', url)
			self.process_url(url)
			if u == tank_info_url:
				info_file_path = self.export_path
		self.process_details(tank_detail_url, info_file_path)


	def process_release_urls(self):
		for u in release_urls:
			url = u + url_var + self.api_key 
			logger.info('Working on URL %s', url)
			self.process_url(url)
			if u == release_info_url:
				info_file_path = self.export_path
		self.process_details(release_detail_url, info_file_path)


	def process(self):
		self.process_tank_urls()
		self.process_release_urls()


	def	process_missing_ids(self, info_path, detail_path):
		info = pd.read_csv(info_path)
		id_col_name = info.columns[0]
		info_ids = list(info[id_col_name].unique())
		logger.info('There are %s info IDs', len(info_ids))
		detail = pd.read_csv(detail_path)
		detail_ids = list(detail[id_col_name].unique())
		logger.info('There are %s detail IDs', len(detail_ids))
		self.ids = [i for i in info_ids if i not in detail_ids]
		print(self.ids)
		logger.info('%s IDs exist in the info file but not the detail file; will try processing each one more time.', len(self.ids))
		self.export_path = detail_path
		logger.info('export_path set to %s', detail_path)
		if 'tank' in info_path:
			detail_url = tank_detail_url 
		elif 'release' in info_path:
			detail_url = release_detail_url
		self.process_detail_data(detail_url)





def main(organization_id, api_key, url_prefix):
	a = NmApi(organization_id=organization_id, api_key=api_key, url_prefix=url_prefix)
	# a.process()
	# a.process_missing_ids(tank_info_path, tank_detail_path)
	# a.process_details(release_detail_url, release_info_path)
	a.process_missing_ids(release_info_path, release_detail_path)


if __name__ == '__main__':   
	main(organization_id=organization_id, api_key=api_key, url_prefix=url_prefix) 