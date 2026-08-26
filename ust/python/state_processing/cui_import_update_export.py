

from ust.python.state_processing.cui_import import CuiImport
from ust.python.state_processing.cui_update import CuiUpdate
from ust.python.state_processing.export_template import Template
from ust.python.util import utils
from ust.python.util.dataset import Dataset

schema = ''                      # Enter the schema name
upload_file_path = r""             # Path to CUI check spreadsheet.  


class Cui:
    def __init__(self, 
                 schema,
                 upload_file_path):
        self.schema = schema
        self.upload_file_path = upload_file_path 
        self.ust_or_release = self.get_ust_or_release()
        self.organization_id = self.get_organization()
        self.control_id = utils.get_control_id(self.ust_or_release, self.organization_id)
        self.print_self()


    def print_self(self):
        print('schema = ' + self.schema)
        print('upload_file_path = ' + self.upload_file_path)
        print('ust_or_release = ' + self.ust_or_release)
        print('organization_id = ' + self.organization_id)
        print('control_id = ' + str(self.control_id))


    def get_ust_or_release(self):
        i = self.schema.find('_') + 1
        return self.schema[i:]


    def get_organization(self):
        i = self.schema.find('_')
        return self.schema[:i].upper()


    def process(self):
        CuiImport(schema=self.schema, upload_file_path=self.upload_file_path)
        CuiUpdate(ust_or_release=self.ust_or_release, control_id=self.control_id).process()
        dataset = Dataset(ust_or_release=self.ust_or_release,
                          control_id=self.control_id, 
                          base_file_name='template_' + utils.get_timestamp_str() + '.xlsx')
        Template(dataset=dataset, data_only=False, template_only=False)


def main(schema, 
          upload_file_path=None):
    Cui(schema=schema, upload_file_path=upload_file_path).process()


if __name__ == '__main__':   
    main(schema=schema,
          upload_file_path=upload_file_path)        
