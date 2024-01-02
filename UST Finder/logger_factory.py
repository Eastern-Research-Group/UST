import logging
import traceback
import sys
import datetime

class LoggerFactory:
    @staticmethod
    def build_logger(name, log_file_path='../log'):
        logger_name = f'{name}_{datetime.datetime.now().strftime("%Y-%m-%d")}'
        logger = logging.getLogger(logger_name)
    
        def handle_exception(type, value, tb):
            formatted_tb = ''
            if tb:
                format_exception = traceback.format_tb(tb)
                for line in format_exception:
                    formatted_tb = formatted_tb + repr(line) + chr(13)
            logger.exception(f'Uncaught exception: {str(type)} | {str(value)} | {formatted_tb}')
   
        formatter = logging.Formatter('%(asctime)s,%(levelname)s,%(message)s', datefmt='%Y-%m-%d %H:%M:%S')
        logger.addHandler(logging.StreamHandler(sys.stdout))
        
        if 'error' in name:
            formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(module)s:%(lineno)s - %(message)s', datefmt='%Y-%m-%d %H:%M:%S')
            sys.excepthook = handle_exception    
        else:
            formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s', datefmt='%Y-%m-%d %H:%M:%S')

        log_file_path = log_file_path + '/' + name + '.log' 
        hdlr = logging.FileHandler(log_file_path, 'a', 'utf-8')
        hdlr.setFormatter(formatter)
        logger.addHandler(hdlr)
        logger.setLevel(logging.DEBUG)

        return logger

logger = LoggerFactory.build_logger('ust')    
error_logger = LoggerFactory.build_logger('error') 

