import glob
import ntpath
import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import pandas as pd

from python.state_processing.find_unregulated import Unregulated
from python.state_processing.export_all_review_materials import ReviewMaterials
from python.state_processing.populate_epa_data_tables import Populate
from python.util import utils, config
from python.util.dataset import Dataset 
from python.util.logger_factory import logger


ust_or_release = '' 			# Valid values are 'ust' or 'release'
control_id = 0                 # Enter an integer that is the ust_control_id or release_control_id
organization_id = ''            # Optional; if control_id = 0 or None, will find the most recent control_id

exclude_unregulated = False     # Set to True if you have not yet excluded unregulated tanks/facilities/releases from the views. Leave as False if already done.
repopulate = True 				# Set to True to delete existing data from EPA data tables (if necessary) and re-import from views. Set to False if this is not necessary. 
reexport = False 				# Set to True to re-export all review materials (control summary, QAQC, and populated template). Set to False if you don't want to create the exports. 
do_peer_review = False 			# Set to True to run the peer review Python script or False to skip. 


class Redo:
	review = None

	def __init__(self, dataset, exclude_unregulated=True, repopulate=True, reexport=True, do_peer_review=True):
		self.dataset = dataset
		self.exclude_unregulated = exclude_unregulated
		self.repopulate = repopulate
		self.reexport = reexport
		self.do_peer_review = do_peer_review


	def unregulated(self):
		Unregulated(self.dataset, drop_existing=True).execute()


	def populate(self):
		Populate(self.dataset, delete_existing=True).execute()


	def export(self):
		self.review = ReviewMaterials(ust_or_release=self.dataset.ust_or_release, control_id=self.dataset.control_id, organization_id=self.dataset.organization_id)
		self.review.export_all()		


	def peer_review(self):
		if not self.review:
			self.review = ReviewMaterials(ust_or_release=self.dataset.ust_or_release, control_id=self.dataset.control_id, organization_id=self.dataset.organization_id)
		self.review.peer_review()


	def execute(self):
		if self.exclude_unregulated:
			self.unregulated()
		if self.repopulate:
			self.populate()
		if self.reexport:
			self.export()
		if self.do_peer_review:
			self.peer_review()



def main(ust_or_release, control_id=0, organization_id=None, exclude_unregulated=True, repopulate=True, reexport=True, do_peer_review=True):
	if not control_id or control_id == 0:
		control_id = utils.get_control_id(ust_or_release, organization_id)

	dataset = Dataset(ust_or_release=ust_or_release,
				 	  control_id=control_id,
				 	  requires_export=False)

	redo = Redo(dataset, exclude_unregulated=exclude_unregulated, repopulate=repopulate, reexport=reexport, do_peer_review=do_peer_review)
	redo.execute()


if __name__ == '__main__':   
	main(ust_or_release=ust_or_release,
		 control_id=control_id,
		 organization_id=organization_id,
		 exclude_unregulated=exclude_unregulated,
		 repopulate=repopulate,
		 reexport=reexport,
		 do_peer_review=do_peer_review)
