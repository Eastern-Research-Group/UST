import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))
from datetime import datetime

from python.util.logger_factory import logger
from python.util import utils
from python.util.dataset import Dataset 

ust_or_release = 'release' # valid values are 'ust' or 'release'
control_id = 5
only_incomplete = False # Set to true to restrict the output to EPA columns that have not yet been value mapped

export_file_path = None
export_file_dir = None
export_file_name = None


class ValueMapper:
	value_mapping_sql = '------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n'
	organization_compartment_flag = None 
	
	def __init__(self, 
				 dataset, 
				 only_incomplete=False):
		self.dataset = dataset
		self.only_incomplete = only_incomplete
	