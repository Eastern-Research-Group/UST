import glob
import ntpath
import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import pandas as pd

from python.state_processing.control_table_summary import Summary
from python.state_processing.export_template import Template
from python.state_processing.qa_check import QualityCheck
from python.util import utils, config
from python.util.dataset import Dataset 
from python.util.logger_factory import logger
from python.util.peer_review import PeerReview


ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = 0                  # Enter an integer that is the ust_control_id or release_control_id
organization_id = ''            # Optional; if control_id = 0 or None, will find the most recent control_id


class ReviewMaterials:
	def __init__(self, ust_or_release, control_id=0, organization_id=None ):
		self.ust_or_release = ust_or_release
		self.control_id = control_id
		self.organization_id = organization_id
		if not self.control_id or self.control_id == 0:
			if not self.organization_id:
				logger.warning('Either control_id or organization_id must be passed; exiting...')
				exit()
			self.control_id = utils.get_control_id(self.ust_or_release, self.organization_id)


	def export_control_summary(self):
		dataset = Dataset(ust_or_release=self.ust_or_release,
		              control_id=self.control_id,
		              base_file_name='control_summary_' + utils.get_timestamp_str() + '.xlsx')
		Summary(dataset=dataset)


	def export_qa(self):
		dataset = Dataset(ust_or_release=self.ust_or_release,
					  control_id=self.control_id, 
					  base_file_name='QAQC_' + utils.get_timestamp_str() + '.xlsx')
		QualityCheck(dataset=dataset)



	def export_template(self):
		dataset = Dataset(ust_or_release=self.ust_or_release,
						  control_id=self.control_id, 
						  base_file_name='template_' + utils.get_timestamp_str() + '.xlsx')
		Template(dataset=dataset)


	def export_all(self):
		self.export_control_summary()
		self.export_qa()
		self.export_template()


	def peer_review(self):
		dataset = Dataset(ust_or_release=self.ust_or_release,
				 	  control_id=self.control_id, 
				 	  base_file_name='peer_review.sql')
		PeerReview(dataset=dataset, display_bad_data=False, overwrite_existing=False)



def main(ust_or_release, control_id=None, organization_id=None):
	review = ReviewMaterials(ust_or_release=ust_or_release, control_id=control_id, organization_id=organization_id)
	review.peer_review()
	review.export_all()	


if __name__ == '__main__':   
	main(ust_or_release=ust_or_release,
		 control_id=control_id,
		 organization_id=organization_id)		