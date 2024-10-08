from datetime import date
import ntpath
import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import openpyxl as op
from openpyxl.styles import Alignment, Font, PatternFill
from openpyxl.styles.borders import Border, Side

from python.state_processing import element_mapping_to_excel
from python.util import utils, config
from python.util.dataset import Dataset 
from python.util.logger_factory import logger


ust_or_release = 'ust' 			# Valid values are 'ust' or 'release'
control_id = 0                  # Enter an integer that is the ust_control_id or release_control_id
all_data = True                 # Boolean, defaults to True. If True will export all source data tables; if False will only export those references in ust_element_mapping or release_element_mapping.
tables_to_exclude = []          # Python list of strings; defaults to empty list. Populate with table names in the organization schema that should be excluded from the export. (NOTE: ERG-created tables will not be exported regardless of the values in this list.)


class SourceData:
	wb = None     

	def __init__(self, 
				 dataset,
				 data_only=False,
				 template_only=False):
		self.dataset = dataset
		self.data_only = data_only		