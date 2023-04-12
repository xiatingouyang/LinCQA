import sys
sys.path.append("../../")

from src.fo_rewriter.FORewriter import *
from src.conjunctive_query.ConjunctiveQuery import *
from src.join_tree.JoinTree import *
from src.util.util import *


class LinCQARewriter(FORewriter):

	def __init__(self):
		pass


	def is_rewritable(self, cq):
		if not self.is_fo(cq):
			return False
		return True


	def rewrite_as_datalog(self, cq):
		return ("TODO lincqa datalog")


	def is_ground_joining_required(self, tree_node):
		bad_key_head_atom = tree_node.get_bad_key_head_atom()
		if len(bad_key_head_atom.variables) > len(tree_node.atom.pk_positions):
			return True
		return False		

	def get_ground_joining_sql_components(self, tree_node, ground_atom):
		bad_key_head_atom = tree_node.get_bad_key_head_atom()


		sql_select_list = ["{}.{}".format(tree_node.atom.name, attr) for attr in tree_node.atom.get_pk_attributes()]
		sql_from_str = tree_node.atom.name
		sql_where_list = []
		if len(bad_key_head_atom.variables) == len(tree_node.atom.pk_positions):
			return sql_select_list, sql_from_str, sql_where_list

		sql_from_str = "{}, CANDIDATE C".format(tree_node.atom.name)
		for attr in bad_key_head_atom.attributes:
			join_clause = "{}.{} = C.{}".format(tree_node.atom.name, attr, attr)
			sql_where_list.append(join_clause)
		# 	print(tree_node.atom)
		# 	print(attr)
		# input()

		return sql_select_list, sql_from_str, sql_where_list

	
	def get_self_pruning_repeated_var_sql(self, tree_node, cq, ground_atom):
		atom = tree_node.atom
		n = len(atom.variables)
		repeated_var_pruning_sql = ""

		self_joining_repeated_pruning_clauses = []
		for i in range(n):
			vi = atom.variables[i]
			if vi.is_constant:
				continue
			for j in range(i+1, n):
				vj = atom.variables[j]
				if vj.is_constant:
					continue

				if vi == vj:
					clause = "{}.{} <> {}.{}".format(atom.name, atom.attributes[i], atom.name, atom.attributes[j])
					self_joining_repeated_pruning_clauses.append(clause)

		if len(self_joining_repeated_pruning_clauses) == 0:
			return repeated_var_pruning_sql


		bad_key_head_atom = tree_node.get_bad_key_head_atom()
		bad_key_view_name = bad_key_head_atom.name

		sql_select_list, sql_from_str, sql_where_list = self.get_ground_joining_sql_components(tree_node, ground_atom)
		
		sql_select_str = ", ".join(sql_select_list)
		sql_where_str = " AND ".join(sql_where_list)

		sql_repeated_clause = " OR ".join(self_joining_repeated_pruning_clauses)

		if sql_where_str:
			repeated_var_pruning_sql = """
--- repeated var for {}

SELECT {}
FROM {}
WHERE ({}) AND ({})
				""".format(atom.name, sql_select_str, sql_from_str, sql_where_str, sql_repeated_clause)

		else:
			repeated_var_pruning_sql = """
--- repeated var for {}

SELECT {}
FROM {}
WHERE {}
				""".format(atom.name, sql_select_str, sql_from_str, sql_repeated_clause)

		return repeated_var_pruning_sql

	def get_self_pruning_constant_sql(self, tree_node, cq, ground_atom):
		atom = tree_node.atom
		constant_pruning_sql = ""

		if len(atom.comparators) == 0:
			return constant_pruning_sql

		sql_constant_clause_list = []
		for comp in atom.comparators:
			neg_com = comp.negate()
			sql_constant_clause_list.append(neg_com.__repr__())

		
		bad_key_head_atom = tree_node.get_bad_key_head_atom()
		bad_key_view_name = bad_key_head_atom.name

		sql_select_list, sql_from_str, sql_where_list = self.get_ground_joining_sql_components(tree_node, ground_atom)
		
		sql_select_str = ", ".join(sql_select_list)
		sql_where_str = " AND ".join(sql_where_list)

		sql_constant_clause = " OR ".join(sql_constant_clause_list)

		if sql_where_str:
			constant_pruning_sql = """
--- constant for {}

SELECT {}
FROM {}
WHERE ({}) AND ({})
				""".format(atom.name, sql_select_str, sql_from_str, sql_where_str, sql_constant_clause)

		else:
			constant_pruning_sql = """
--- constant for {}

SELECT {}
FROM {}
WHERE {}
				""".format(atom.name, sql_select_str, sql_from_str, sql_constant_clause)
		return constant_pruning_sql


	def get_self_pruning_free_var_sql(self, tree_node, cq, ground_atom):
		atom = tree_node.atom

		bad_key_head_atom = tree_node.get_bad_key_head_atom()
		bad_key_view_name = bad_key_head_atom.name

		# free var sql
		free_var_pruning_sql = "free var"
		return free_var_pruning_sql


	def get_self_pruning_sqls(self, tree_node, cq, ground_atom):
		sqls = []
		
		# repeated var pruning
		repeated_var_pruning_sql = self.get_self_pruning_repeated_var_sql(tree_node, cq, ground_atom)
		if repeated_var_pruning_sql:
			sqls.append(repeated_var_pruning_sql)

		# constant pruning
		constant_pruning_sql = self.get_self_pruning_constant_sql(tree_node, cq, ground_atom)
		if constant_pruning_sql:
			sqls.append(constant_pruning_sql)
		
		# free_var pruning
		free_var_pruning_sql = self.get_self_pruning_free_var_sql(tree_node, cq, ground_atom)
		if free_var_pruning_sql:
			sqls.append(free_var_pruning_sql)
		

		return sqls

	def get_pair_pruning_sql(self, tree_node, cq, ground_atom):

		atom = tree_node.atom
		bad_key_head_atom = tree_node.get_bad_key_head_atom()
		bad_key_view_name = bad_key_head_atom.name
		

		sql = "pair pruning"
		sql = ""
		return sql


	def get_ground_sql(self, cq):
		if cq.is_boolean():
			return [], None
		


		# produce the proj_attr_str
		ground_variables = []
		atom_attributes = []
		proj_attr_list = []
		for atom in cq.body:
			table_name = atom.name
			pk_attributes = atom.get_pk_attributes()
			for attr in pk_attributes:
				proj_attr = "{}.{}".format(table_name, attr).lower()
				ground_variables.append(Variable(proj_attr))
				atom_attributes.append(attr)
				proj_attr_list.append(proj_attr)

		for var in cq.get_head_variables():
			if var.name.lower() not in proj_attr_list:
				proj_attr_list.append(var.name)
				ground_variables.append(Variable(var.name))
				atom_attributes.append(var.name.split(".")[1])
					
		
		proj_attr_str = ", ".join(proj_attr_list)

		# produce the table_str
		table_list = [atom.name for atom in cq.body]
		table_str = ", ".join(table_list)
		

		# produce the where_clause_str
		where_clause_list = []
		for atom in cq.body:
			comps = atom.comparators
			for comp in comps:
				where_clause_list.append(comp.__repr__())

		n = len(cq.body)
		for i in range(n):
			for j in range(i+1, n):
				atom_i = cq.body[i]
				atom_j = cq.body[j]
				clauses = atom_i.get_joining_clauses(atom_j)
				where_clause_list += clauses

		where_clause_str = " AND ".join(where_clause_list)


		sql = """
CANDIDATE AS (
	SELECT {}
	FROM {}
	WHERE {}
		)
		""".format(proj_attr_str, table_str, where_clause_str)

		ground_atom = Atom("ground", ground_variables)
		ground_atom.attributes = atom_attributes

		return [sql], ground_atom

	
	def get_good_join_sql(self, tree_node, cq, ground_atom):
		atom = tree_node.atom
		good_join_head_atom = tree_node.get_good_join_head_atom()
		good_join_view_name = good_join_head_atom.name
		

		sql = """
{} AS (
good join
)
		""".format(good_join_view_name)
		return sql



	def get_main_sql(self, bcq):
		sql = "get main select"
		return [sql]




	def get_lincqa_sql_from_ppjt(self, tree_node, cq, ground_atom):

		sqls = []
		for child_node in tree_node.children:
			sqls += self.get_lincqa_sql_from_ppjt(child_node, cq, ground_atom)

		curr_sqls = self.get_self_pruning_sqls(tree_node, cq, ground_atom)

		pair_pruning_sql = self.get_pair_pruning_sql(tree_node, cq, ground_atom)
		if pair_pruning_sql:
			curr_sqls.append(pair_pruning_sql)



		curr_sql_unioned = "\n\nUNION ALL\n\n".join(curr_sqls)
		atom = tree_node.atom
		bad_key_head_atom = tree_node.get_bad_key_head_atom()
		bad_key_view_name = bad_key_head_atom.name
		
		sql = """
{} AS (
{}
)
			""".format(bad_key_view_name, curr_sql_unioned)

		good_join_sql = self.get_good_join_sql(tree_node, cq, ground_atom)
		sqls.append(sql)
		sqls.append(good_join_sql)
		
		return sqls

	def rewrite_as_sql(self, cq):
		if not self.is_rewritable(cq):
			print("LinCQA not applicable - not in PPJT")
			return None
		
		cq_components = decompose_query(cq)
		
		ret_sqls = []
		ground_sqls, ground_atom = self.get_ground_sql(cq)
		ret_sqls += ground_sqls
			
		for cq_cc in cq_components:

			join_tree_root = construct_join_tree_from_cq(cq_cc, ppjt_insisted = True)
			ret_sqls += self.get_lincqa_sql_from_ppjt(join_tree_root, cq_cc, ground_atom)
		
		ret_sqls += self.get_main_sql(cq)
		ret_sql = "\n\n".join(ret_sqls)

		return ret_sql

