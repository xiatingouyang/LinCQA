import sys
sys.path.append("../../")


def parse(sql, schema):

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




class ConjunctiveQuery:

	def __init__(self, input_sql_dir_str, schema):

		self.schema = schema
		sql_file = open(input_sql_dir_str, "r")
		sql_str = sql_file.read()
		sql_file.close()

		sql_str_lower = sql_str.lower().replace("\n", "")

		atom_names, free_vars, joining_vars = parse(sql_str_lower, schema)
		print(atom_names, free_vars, joining_vars)

		
		

		
# def construct_cq_from_sql(sqlfilename, schemafile):
#     print("****************************")
#     try:
#         f = open(schemafile)
#     except FileNotFoundError:
#         print("File {} not found.".format(schemafile))
#         return None

#     try:
#         file = open(sqlfilename, "r")
#     except FileNotFoundError:
#         print("File {} not found.".format(sqlfilename)) 
#         return None

#     schema = json.load(f)
    
#     sql = file.readline()[:-1]
#     sql = sql.lower()
#     file.close()
    
#     print(sql)
#     atom_names, free_vars, joining_vars = parse(sql)

#     # print(atom_names)
#     # print(free_vars)
#     # print(joining_vars)


#     attr_mapping = {}
#     for table in atom_names:
#         for attr in schema[table]["attributes"]:
#             attr_mapping[attr] = attr

#     cnt = 0 
#     for joining_var in joining_vars:
#         if "=" not in joining_var:
#             continue



#         arg1, arg2 = joining_var.split("=")
#         var1 = arg1
#         var2 = arg2
#         if "." in var1:
#             var1 = arg1.split(".")[1]
#         if "." in var2:
#             var2 = arg2.split(".")[1]

#         if var1.isnumeric():
#             attr_mapping[var2] = var1
#         elif var2.isnumeric():
#             attr_mapping[var1] = var2 
#         else:
#             var1_root = var1 
#             var2_root = var2 

#             while var1_root != attr_mapping[var1_root]:
#                 var1_root = attr_mapping[var1_root]
#             while var2_root != attr_mapping[var2_root]:
#                 var2_root = attr_mapping[var2_root]

#             attr_mapping[var1_root] = var2

#     for attr in attr_mapping:
#         if attr != attr_mapping[attr]:
#             print(attr, "=", attr_mapping[attr])

#     # input()


#     q_free = [Variable(attr_mapping[free_var].upper()) for free_var in free_vars if free_var in attr_mapping]
#     q_body = []

#     for table in atom_names:
#         body = []
#         index = 0
        

#         for attr in schema[table]["attributes"]:
#             var_root = attr 
#             is_constant = False
#             while var_root != attr_mapping[var_root]:
#                 var_root = attr_mapping[var_root]
#                 if var_root not in attr_mapping:
#                     is_constant = True
#                     break

                
#             var = Variable(var_root.upper())
#             if is_constant:
#                 var = Constant(var_root)

#             if index in schema[table]["key"]:
#                 body.append(PrimaryKey(var))
#             else:
#                 body.append(var)
            
#             index += 1 

#         atom = Atom(table, body)

#         q_body.append(atom)

#     q = ConjunctiveQuery(free_variables = q_free, body_atoms = q_body)
    
#     return q


