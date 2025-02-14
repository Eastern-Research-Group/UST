import glob
import ntpath
import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import pandas as pd

from python.state_processing.export_template import Template
from python.util import config, utils
from python.util.dataset import Dataset
from python.util.emailer import Emailer 
from python.util.logger_factory import logger


ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = 0                  # Enter an integer that is the ust_control_id or release_control_id
send_email = True				# Boolean; defaults to True. If True, will use Outlook to automatically email the generated file for ERG review. 

# These variables can usually be left unset. This script will generate an Excel file in the appropriate state folder in the repo under /ust/python/exports/mapping.
# This file directory and its contents are excluded from pushes to the repo by .gitignore.
export_file_path = None
export_file_dir = None
export_file_name = None


class SubstanceMapping:
	def __init__(self, dataset, send_email=True):
		self.dataset = dataset
		self.send_email = send_email
		self.export_exists = False 
		

	def check_for_substance_mapping(self):
		conn = utils.connect_db()
		cur = conn.cursor()
		sql = f"""select count(*) from public.v_{self.dataset.ust_or_release}_element_mapping 
			         where {self.dataset.ust_or_release}_control_id = %s and epa_column_name = 'substance_id'
			         and epa_value is not null"""
		utils.process_sql(conn, cur, sql, params=(self.dataset.control_id,))
		cnt = cur.fetchone()[0]
		cur.close()
		conn.close()
		if cnt > 0:
			return True
		else:
			return False 

	def export(self):
		if self.check_for_substance_mapping():
			self.wb = Template(self.dataset, data_only=True, template_only=True, substance_mapping_only=True)
			logger.info('Exported %s to %s', self.dataset.export_file_name, self.dataset.export_file_dir)
			self.export_exists = True
		else:
			logger.info('No substance mapping found for %s_control_id %s in public.%s_element_value_mapping; nothing to export', self.dataset.ust_or_release, self.dataset.control_id, self.dataset.ust_or_release, )
			self.export_exists = False 


	def email(self):
		if self.send_email and self.export_exists:	
			greeting_name = utils.get_first_name_from_erg_email(config.hazsub_email)
			outlook_info = utils.get_outlook_info()
			if outlook_info:
				sender_name = outlook_info['first_name']
				sender_email = outlook_info['email']
			else:
				sender_name = ''
				sender_email = ''
				
			email_body = f"""Hi {greeting_name},

Attached please find the substance mapping for {self.dataset.organization_id} {utils.get_pretty_ust_or_release(self.dataset.ust_or_release)} for review by a chemical expert. Please make any suggested changes in the "ERG Reviewer Comments" column and send this spreadsheet back to both Victoria and me.

Thank you,
{sender_name}
{sender_email}
"""
			emailer = Emailer(recipient=config.hazsub_email,
				cc=config.hazsub_email,
				bcc=None,
				subject=f'Substance mapping for {self.dataset.organization_id} {utils.get_pretty_ust_or_release(self.dataset.ust_or_release)}',
				body=email_body,
				attachment_path=os.path.abspath(self.dataset.export_file_path))
			emailer.email()
		elif self.send_email:
			logger.warning('Nothing to email because no export file was created.')
			return 
		


def main(ust_or_release, control_id=None, send_email=True, export_file_name=None, export_file_dir=None, export_file_path=None):
	dataset = Dataset(ust_or_release=ust_or_release,
				 	  control_id=control_id, 
				 	  base_file_name='substance_mapping_' + utils.get_timestamp_str() + '.xlsx',
					  export_file_name=export_file_name,
					  export_file_dir=export_file_dir,
					  export_file_path=export_file_path)

	template = SubstanceMapping(dataset=dataset)
	template.export()
	if send_email:
		template.email()


if __name__ == '__main__':   
	main(ust_or_release=ust_or_release,
		 control_id=control_id, 
		 send_email=send_email,
		 export_file_name=export_file_name,
		 export_file_dir=export_file_dir,
		 export_file_path=export_file_path)