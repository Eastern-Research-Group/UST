import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))
from datetime import date
import ntpath

from python.util.logger_factory import logger
from python.util import utils, config


schema = 'public'
object_name = None # If None, will export all tables, views, and functions 


def main():



if __name__ == '__main__':  
	main()