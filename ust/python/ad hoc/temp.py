import os
from pathlib import Path
import sys
ROOT_PATH = Path(__file__).parent.parent.parent
sys.path.append(os.path.join(ROOT_PATH, ''))

from python.util import utils

print('blah\nblah')

str = 'blah\nblah'.encode("unicode_escape").decode("utf-8")
print(str)

