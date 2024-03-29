import logging
import sys

class LoggerFactory:
    @staticmethod
    def build_logger(name, log_location='../log'):
        logger_name = name + '_logger'
        logger = logging.getLogger(logger_name)
        logger.addHandler(logging.StreamHandler(sys.stdout))
        formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(module)s:%(lineno)s - %(message)s', datefmt='%Y-%m-%d %H:%M:%S')
        log_file_path = log_location + '/' + name + '.log'
        hdlr = logging.FileHandler(log_file_path, 'a', 'utf-8')
        hdlr.setFormatter(formatter)
        logger.addHandler(hdlr)
        logger.setLevel(logging.DEBUG)
        return logger

logger = LoggerFactory.build_logger('ust')