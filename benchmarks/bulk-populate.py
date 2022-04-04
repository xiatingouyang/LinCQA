import pyodbc 
import json
from cavsat_prepare import *
from os.path import exists
import sys

# Some other example server values are
# server = 'localhost\sqlexpress' # for a named instance
# server = 'myserver,port' # to specify an alternate port

def connect_db(db_name):
        server = 'localhost' 
        database = db_name
        username = 'SA' 
        password = 'cqa2022!' 
        cnxn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER='+server+';DATABASE='+database+';UID='+username+';PWD='+ password)
        cursor = cnxn.cursor()

        return cnxn, cursor

def insert_table(cnxn, cursor, table_name, attributes, input_dir, key_arity):

        path_to_file = "{}/{}.csv".format(input_dir, table_name)
        if not exists(path_to_file):
            print("File not found: {}".format(path_to_file))
            return False

        attrs_in_creation = list()
        if " " in attributes[0]:
            attrs_in_creation = attributes
        else:
        
            for i in range(len(attributes)):
                attr = attributes[i]
                if i in key_arity:
                    attrs_in_creation.append(attr + " INT NOT NULL")
                else:
                    attrs_in_creation.append(attr + " INT")

        attrs_in_creation_string = ", ".join(attrs_in_creation)
        create_table_sql = "if not exists (select * from sysobjects where name='{}' and xtype='U') CREATE TABLE {} ({})".format(
                                                table_name,
                                                table_name,
                                                attrs_in_creation_string)

        print(create_table_sql)
        cursor.execute(create_table_sql).rowcount
        cnxn.commit()

        bulk_insert_sql = """
        BULK INSERT {}
                    FROM '{}/{}.csv'
                    WITH
                    (
                    FIRSTROW = 1,
                    FIELDTERMINATOR = ',', 
                    ROWTERMINATOR = '\n',
                    MAXERRORS = 1000000
                    )
        """.format(table_name, input_dir, table_name)

        print(bulk_insert_sql)
        count = cursor.execute(bulk_insert_sql).rowcount
        print(count)
        cnxn.commit()
        return True

def main():


        if len(sys.argv) < 3:
            print("Usage: python3 bulk-populkate.py <path to schema.json> <path to dbinfo.json>")
            return
        schema_location = sys.argv[1]
        dbinfo_location = sys.argv[2]


        f = open(schema_location)
        schema = json.load(f)
        dbinfo_f = open(dbinfo_location)
        dbinfo = json.load(dbinfo_f)
        proj_dir = dbinfo["proj_dir"]
        for db_name in dbinfo["databases"]:
                cnxn, cursor = connect_db(db_name)
                # add cavsat constraint table
                constraint_sql = constraint_table_sql()
                cursor.execute(constraint_sql).rowcount
                cnxn.commit()
                input_dir = "{}/{}".format(proj_dir, dbinfo["databases"][db_name])
                for table_name in schema:
                        attributes = schema[table_name]["attributes"]
                        key_arity = schema[table_name]["key"]
                        ret = insert_table(cnxn, cursor, table_name, attributes, input_dir, key_arity)
                        if not ret:
                            continue

			##  cavsat statements
                        if len(key_arity) == 1 and key_arity[0] == -1:
                            continue

                        primary_key_lists = []
                        for i in range(len(schema[table_name]["attributes"])):
                            if i in key_arity:
                                primary_key_lists.append(schema[table_name]["attributes"][i])
                        # primary_key_lists = schema[table_name]["attributes"][:key_arity]



                        cavsat_sqls = get_cavsat_prepare_sqls(table_name, primary_key_lists)
                        for cavsat_sql in cavsat_sqls:
                            print(cavsat_sql)
                            cursor.execute(cavsat_sql).rowcount
                            cnxn.commit()

if __name__ == "__main__":
        main()


