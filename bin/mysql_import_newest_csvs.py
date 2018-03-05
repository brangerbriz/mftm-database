import os
import re
import mysql.connector

def main():

    folder = '../data/csv/'
    files = [file for file in os.listdir(folder) if re.match('^\d{4}_.+\.csv$', file)]
    if len(files) > 0:
        files = sorted(files, reverse=True)[0:5]

    cnx = mysql.connector.connect(user='root', password='bbpwn123',
                                  host='127.0.0.1',
                                  database='messages_from_the_mines')
    cursor = cnx.cursor()

    query_template = """LOAD DATA LOCAL INFILE '{file}'  
                      INTO TABLE `{table}` 
                      FIELDS TERMINATED BY ',' 
                      OPTIONALLY ENCLOSED BY '\"' IGNORE 1 LINES;"""

    queries = []

    for file in files:
        table = re.sub('^\d{4}_', '', file).replace('.csv', '')
        file = os.path.join(folder, file)

        queries.append(query_template.format(file=file, table=table))
        if table in ['coinbase_messages', 'address_messages', 'op_return_address_messages']:
            queries.append(query_template.format(file=file, table='{}_unique'.format(table)))

    for query in queries:
        try:
            print(query)
            cursor.execute(query)
            cnx.commit()
        except mysql.connector.Error as err:
            print("MySQL error: {}".format(err))
            continue

    cursor.close()
    cnx.close()

if __name__ == '__main__':
    main()