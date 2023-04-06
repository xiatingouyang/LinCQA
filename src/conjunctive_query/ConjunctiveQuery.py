import sys
sys.path.append("../../")
from src.conjunctive_query.Rule import *
from src.conjunctive_query.Variable import *
from src.conjunctive_query.Atom import *
from src.conjunctive_query.Comparator import *


def parse(sql):
    sql = sql.replace("distinct", "")
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

    free_vars = free_vars_temp


    joining_vars_temp = join_line.split("and")
    joining_vars = []
    for jv in joining_vars_temp:
        if "=" in jv or ">" in jv or "<" in jv or "<=" in jv or ">=" in jv:
            joining_vars.append(jv.replace(" ", ""))
        elif "like" in jv:
            joining_vars.append(jv)

    return atom_names, free_vars, joining_vars




class ConjunctiveQuery(Rule):

    def __init__(self, schema_obj=None, head_atom=None, q_body=None):
        self.schema = schema_obj
        self.head = head_atom
        self.body = q_body


    def is_boolean(self):
        return self.head == None
    

    def is_self_join_free(self):
        names = []
        for atom in self.body:
            if atom.name not in names:
                names.append(atom.name)
            else:
                return False
        return True



    def get_atom_by_name(self, atom_name):
        for atom in self.body:
            if atom.name == atom_name:
                return atom 
        return None


    def read_from_dir(self, input_sql_dir_str,schema_obj=None):
        sql_file = open(input_sql_dir_str, "r")
        sql_str = sql_file.read()
        sql_file.close()


        query_name = "Q"
        # uncomment below for Q{i} for each {i}.sql
        # query_name = "Q"+input_sql_dir_str.split("/")[-1].split(".")[0] 
        
        sql_str_lower = sql_str.lower().replace("\n", "")

        atom_names, free_vars, joining_vars = parse(sql_str_lower)

        schema_json = schema_obj.schema
        attr_mapping = {}
        for table in atom_names:
            for attr in schema_json[table]["attributes"]:
                full_attr = "{}.{}".format(table, attr).lower()
                attr_mapping[full_attr] = full_attr

        cnt = 0 
        var_to_display = free_vars.copy()


        comparators_dict = {}

        for joining_var in joining_vars:

            operators = ["=", "<", ">", "<=", ">=", "like"]
            operator = None
            for op in operators:
                if op in joining_var:
                    operator = op
            if not operator:
                continue


            arg1, arg2 = joining_var.split(operator)
            var1 = arg1.lower().replace(" ", "")
            var2 = arg2.lower().replace(" ", "")
            # if "." in var1:
            #     var1 = arg1.split(".")[1]
            # if "." in var2:
            #     var2 = arg2.split(".")[1]
            if "." not in var1 or  "." not in var2 or "=" not in joining_var:
                if var1.isnumeric() or '"' in var1 or "%" in var1:
                    comparators_dict[var2] = []
                    comparators_dict[var2].append([operator, var1])
                    var_to_display.append(var2)
                elif var2.isnumeric() or '"' in var2 or "%" in var2:
                    comparators_dict[var1] = []
                    comparators_dict[var1].append([operator, var2])
                    var_to_display.append(var1)
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


        q_free = [
                    Variable(attr_mapping[free_var].upper()) 
                    for free_var in free_vars 
                        if free_var in attr_mapping
                ]
        head_atom = Atom(query_name, q_free)


        q_body = []
        dummy_index = 0
        for table in atom_names:
            body = []
            index = 0
            comparators = []
            for attr in schema_json[table]["attributes"]:
                var_root = "{}.{}".format(table, attr).lower() 
                is_constant = False

                while var_root != attr_mapping[var_root]:
                    var_root = attr_mapping[var_root]
                    if var_root not in attr_mapping:
                        is_constant = True
                        break

                if var_root in var_to_display:
                    if var_root in comparators_dict:
                        lhs = var_root
                        for filters in comparators_dict[lhs]:
                            op, rhs = filters
                            comp = get_comparator(lhs, op, rhs)
                            comparators.append(comp)

                    var = Variable(var_root.upper(), is_constant)
                else:
                    var = Variable("Z_{}".format(dummy_index))
                    dummy_index += 1
                body.append(var)                
                index += 1 

            atom = Atom(table, body, schema_json[table]["key"], schema_json[table]["attributes"], negated=False, comparators=comparators)
            q_body.append(atom)

        self.schema = schema_obj
        self.head = head_atom
        self.body = q_body

    def booleanize(self):

        old_head_vars = self.head.variables
        new_body = []
        new_comparators = []
        for atom in self.body:
            new_variables = []
            for var in atom.variables:
                if var in old_head_vars:
                    new_var = var.copy()
                    new_var.set_is_constant(True)
                    new_variables.append(new_var)
                else:
                    new_variables.append(var)

            new_atom = Atom(
                    atom.name, 
                    new_variables, 
                    pk_positions=atom.pk_positions, 
                    attributes=atom.attributes, 
                    negated=atom.negated, 
                    comparators=new_comparators
                    )

            new_body.append(new_atom)

        # new_head_atom = Atom(self.head.name, [])
        new_cq = ConjunctiveQuery(self.schema, None, new_body)
        return new_cq
