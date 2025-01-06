from datetime import datetime
import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

from python.util import utils
from python.util.logger_factory import logger


ust_or_release = 'release' 			# Valid values are 'ust' or 'release'
control_id = 9               # Enter an integer that is the ust_control_id or release_control_id



def main(ust_or_release, control_id):
	if ust_or_release.lower() == 'ust':
		utils.delete_all_ust_data(control_id=control_id)
	elif ust_or_release.lower() == 'release':
		utils.delete_all_release_data(control_id=control_id)
	else:
		logger.error('Invalid value "%s" for ust_or_release; valid values are "ust" or "release"', ust_or_release)



if __name__ == '__main__':   
	main(ust_or_release=ust_or_release,
		 control_id=control_id)
