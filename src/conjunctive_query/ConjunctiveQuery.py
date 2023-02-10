import sys
sys.path.append("../../")
from src.conjunctive_query.Rule import *
from src.conjunctive_query.Variable import *
from src.conjunctive_query.Atom import *


def parse(sql):

    select_line = sql.split("select")[1]
    from_line = select_line.split("from")[1]
    select_line = select_line.split("from")[0]


    debris = from_line.split("where")
    from_line = debris[0]
    join_line = ""

    if len(debris) > 1:
        join_line = debris[1]

    select_line = select_line.replace(" ", "")
    from_line = from_line.replace(" ", "")
    # join_line = join_line.replace(" ", "")


    atom_names = from_line.split(",")
    free_vars_temp = select_line.split(",")

    free_vars = []
    for free_var in free_vars_temp:
        if "." in free_var:
            free_vars.append(free_var.split(".")[1])
        else:
            free_vars.append(free_var)


    joining_vars_temp = join_line.split("and")
    joining_vars = []
    for jv in joining_vars_temp:
        joining_vars.append(jv.replace(" ", ""))

    return atom_names, free_vars, joining_vars




class ConjunctiveQuery(Rule):

    def __init__(self, input_sql_dir_str, schema_obj):

        self.schema = schema_obj
        sql_file = open(input_sql_dir_str, "r")
        sql_str = sql_file.read()
        sql_file.close()


        query_name = "Q"
        # uncomment below for Q{i} for each {i}.sql
        # query_name = "Q"+input_sql_dir_str.split("/")[-1].split(".")[0] 
        
        sql_str_lower = sql_str.lower().replace("\n", "")

        atom_names, free_vars, joining_vars = parse(sql_str_lower)

        self.head = None
        self.body = []

        # print(sql_str_lower)
        # print(atom_names, free_vars, joining_vars)

        schema_json = schema_obj.schema
        attr_mapping = {}
        for table in atom_names:
            for attr in schema_json[table]["attributes"]:
                attr_mapping[attr.lower()] = attr.lower()

        cnt = 0 
        var_to_display = free_vars.copy()

        for joining_var in joining_vars:
            if "=" not in joining_var:
                continue
            arg1, arg2 = joining_var.split("=")
            var1 = arg1
            var2 = arg2
            if "." in var1:
                var1 = arg1.split(".")[1]
            if "." in var2:
                var2 = arg2.split(".")[1]

            if var1.isnumeric():
                attr_mapping[var2] = var1
                var_to_display.append(var1)
            elif var2.isnumeric():
                attr_mapping[var1] = var2 
                var_to_display.append(var2)
            else:
                var1_root = var1 
                var2_root = var2 
                var_to_display.append(var1)
                var_to_display.append(var2)
                while var1_root != attr_mapping[var1_root]:
                    var1_root = attr_mapping[var1_root]
                while var2_root != attr_mapping[var2_root]:
                    var2_root = attr_mapping[var2_root]

                attr_mapping[var1_root] = var2


        q_free = [Variable(attr_mapping[free_var].upper()) for free_var in free_vars if free_var in attr_mapping]

        head_atom = Atom(query_name, q_free)
        self.head = head_atom


        q_body = []

        for table in atom_names:
            body = []
            index = 0
            for attr in schema_json[table]["attributes"]:
                var_root = attr.lower() 
                is_constant = False
                while var_root != attr_mapping[var_root]:
                    var_root = attr_mapping[var_root]
                    if var_root not in attr_mapping:
                        is_constant = True
                        break

                if var_root in var_to_display:    
                    var = Variable(var_root.upper(), is_constant)
                else:
                    var = Variable()
                body.append(var)                
                index += 1 

            atom = Atom(table, body, schema_json[table]["key"], schema_json[table]["attributes"])
            q_body.append(atom)

        self.body = q_body


    

