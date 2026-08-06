
from ust.python.util import utils
from ust.python.util.dataset import Dataset
from ust.python.util.logger_factory import logger


ust_or_release = 'ust'             # Valid values are 'ust' or 'release'
control_id = 0                        # Enter an integer that is the ust_control_id or release_control_id
organization_id = ''            # Optional; if control_id = 0 or None, will find the most recent control_id
views_to_export = None          # Optional; if None, will export all data population views in the schema. 

# These variables can usually be left unset. This script will generate an Excel file in the appropriate state folder in the repo under /ust/sql/states.
# This file directory and its contents are excluded from pushes to the repo by .gitignore.
export_file_path = None
export_file_dir = None
export_file_name = None


class ViewDdl:
    conn = None 
    cur = None 
    vsql = '' 

    def __init__(self, dataset, views_to_export=None):
        self.dataset = dataset
        self.views_to_export = views_to_export


    def connect_db(self):
        self.conn = utils.connect_db()
        self.cur = self.conn.cursor()
        logger.info('Connected to database')
        

    def disconnect_db(self):
        self.cur.close()
        self.conn.close()
        logger.info('Disconnected from database')


    def get_view_names(self):
        sql = f"select view_name from public.{self.dataset.ust_or_release}_template_data_tables order by sort_order"
        utils.process_sql(self.conn, self.cur, sql)
        rows = self.cur.fetchall()
        views = [r[0] for r in rows]
        return views 


    def set_views(self):
        if not self.views_to_export:
            sql = f"""select a.table_name as view_name 
                        from information_schema.tables a join public.{self.dataset.ust_or_release}_template_data_tables b on a.table_name = b.view_name 
                        where a.table_schema = %s
                        order by b.sort_order"""
            utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.schema,))
            rows = self.cur.fetchall()        
            self.views_to_export = [r[0] for r in rows]


    def get_sql(self):
        sql = f"""select a.view_name, public.get_view_def(a.view_name, %s) as view_ddl 
                from public.{self.dataset.ust_or_release}_template_data_tables a join information_schema.tables b on a.view_name = b.table_name 
                where b.table_schema = %s
                order by sort_order"""
        utils.process_sql(self.conn, self.cur, sql, params=(self.dataset.schema, self.dataset.schema))
        rows = self.cur.fetchall()
        for row in rows:
            view_name = row[0]
            view_ddl = row[1]
            self.vsql = self.vsql + '\n\n\n/*********** ' + view_name + ' ***********/\n'
            self.vsql = self.vsql + f'\n\n--View definition for {self.dataset.schema}.{view_name}:\n'
            self.vsql = self.vsql + view_ddl + ';\n\n'


    def write_sql(self):
        with open(self.dataset.export_file_path, 'w', encoding='utf-8') as f:
            f.write(self.vsql)
        logger.info('\nView DDL exported to %s', self.dataset.export_file_path)


    def process(self):
        self.connect_db()
        self.set_views()
        if not self.views_to_export:
            logger.warning('No %s template views found in schema %s; exiting.', self.dataset.ust_or_release, self.dataset.schema)
            logger.info('Views this script looks for: %s', self.get_view_names())
            self.disconnect_db()
            exit()
        self.get_sql()
        self.disconnect_db()
        self.write_sql()


def main(ust_or_release, control_id=None, organization_id=None, views_to_export=None):
    if not control_id and not organization_id:
        logger.error('Please pass either control_id or organization_id')
        exit()
    elif not control_id:
        control_id = utils.get_control_id(ust_or_release, organization_id)

    dataset = Dataset(ust_or_release=ust_or_release,
                       control_id=control_id, 
                       base_file_name='view_ddl.sql',
                      export_file_name=export_file_name,
                      export_file_dir=export_file_dir,
                      export_file_path=export_file_path)

    ddl = ViewDdl(dataset=dataset, views_to_export=views_to_export)
    ddl.process()


if __name__ == '__main__':   
    main(ust_or_release=ust_or_release,
         control_id=control_id, 
         organization_id=organization_id,
         views_to_export=views_to_export)
