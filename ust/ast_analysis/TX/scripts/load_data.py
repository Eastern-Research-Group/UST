import psycopg2
from config import load_config


def insert_vendor(xml_content):
    #sql = """INSERT INTO tx_ust.tx_tier2_analysis_facility(xml_content)
    #         VALUES(%s);"""
    sql = """INSERT INTO tx_ust.tx_tier2_analysis_contact(xml_content)
             VALUES(%s);"""
    config = load_config()

    try:
        with  psycopg2.connect(**config) as conn:
            with  conn.cursor() as cur:
                # execute the INSERT statement
                cur.execute(sql, (xml_content,))
                # commit the changes to the database
                conn.commit()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)

file_path = r"C:\Users\JChilton\OneDrive - Eastern Research Group\Desktop\UST\Texas\Analysis\data\contacts.txt"
#file_path = r"C:\Users\JChilton\OneDrive - Eastern Research Group\Desktop\UST\Texas\Analysis\fac\facility4.txt"

with open(file_path, 'r', encoding="utf8") as file:
	file_content = file.read()

if __name__ == '__main__':
    insert_vendor(file_content)