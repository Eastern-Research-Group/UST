from datetime import datetime
import os
from pathlib import Path
import sys  
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

import logging


class LoggerFactory:
    @staticmethod
    def build_logger(name, log_location=str(ROOT_PATH) + '/python/log'):
        Path(log_location).mkdir(parents=True, exist_ok=True)
        logger_name = f'{log_location}/{name}_log_{datetime.now().strftime("%Y-%m-%d")}.log'
        logger = logging.getLogger(logger_name)

        def handle_exception(type, value, tb):
            formatted_tb = ''
            if tb:
                format_exception = traceback.format_tb(tb)
                for line in format_exception:
                    formatted_tb = formatted_tb + repr(line) + chr(13)            
            logger.exception(f'Uncaught exception: {str(type)} | {str(value)} | {formatted_tb}')

        logger.addHandler(logging.StreamHandler(sys.stdout))
        formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(module)s.%(funcName)s:%(lineno)s - %(message)s', datefmt='%Y-%m-%d %H:%M:%S')
        log_file_path = log_location + '/' + name + '.log'
        hdlr = logging.FileHandler(log_file_path, 'a', 'utf-8')
        hdlr.setFormatter(formatter)
        logger.addHandler(hdlr)

        if 'error' in name:
            formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(module)s:%(lineno)s - %(message)s', datefmt='%Y-%m-%d %H:%M:%S')
            sys.excepthook = handle_exception    
        else:
            formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s', datefmt='%Y-%m-%d %H:%M:%S')

        logger.setLevel(logging.DEBUG)
        return logger

logger = LoggerFactory.build_logger('ust')
error_logger = LoggerFactory.build_logger('error')