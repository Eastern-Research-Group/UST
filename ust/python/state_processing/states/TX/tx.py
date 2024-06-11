import utils

path = r'C:\Users\erguser\OneDrive - Eastern Research Group\Other Projects\UST\State Data\TX\Originals\\'

tank_filename = 'pst_ust.txt'
compartment_filename = 'pst_ust_comprt.txt'
facility_filename = 'pst_fac.txt'
financial_assurance_filename = 'pst_fin_assur.txt'




class DataLine():
    def __init__(self, string):
        self.string = string 
        self.start_index = 0 

    def get_value(self, num_chars=1):
        val = self.string[self.start_index:self.start_index + num_chars].strip()
        self.start_index = self.start_index + num_chars
        return val


def main(table_name):    
    conn = utils.connect_db()
    cur = conn.cursor()

    sql = """select column_name, column_length 
             from "TX_UST".table_columns where table_name = %s order by column_number"""
    cur.execute(sql, (table_name,))
    columns = cur.fetchall()

    if table_name == 'tanks':
        file_path = path + tank_filename
    elif table_name == 'compartments':
        file_path = path + compartment_filename
    elif table_name == 'facilities':
        file_path = path + facility_filename
    elif table_name == 'financial_assurance':
        file_path = path + financial_assurance_filename
    else:
        print('Unknown table name ' + table_name)
        exit()


    with open(file_path, 'r') as f:
        for line in f:
            s = DataLine(string=line)

            sql = 'insert into "TX_UST".' + table_name + ' values ( '
            for col in columns:
                sql = sql + r'%s,'
            sql = sql[:-1] + ')'

            values = []
            for col in columns:
                values.append(s.get_value(col[1]))

            cur.execute(sql, values)
            conn.commit()

    cur.close()
    conn.close()

if __name__ == '__main__':       
    # main('tanks')
    # main('compartments')
    # main('facilities')
    main('financial_assurance')
