import sys
sys.path.append("../../")

from src.fo_rewriter.FORewriter import *
from src.conjunctive_query.ConjunctiveQuery import *
from src.conjunctive_query.JoinTree import *


class LinCQARewriter(FORewriter):

	def __init__(self):
		print("initialized LinCQA rewriter")

	def rewrite_as_datalog(self, cq):
		return ("TODO lincqa datalog")

	


	def get_self_pruning_sql(self, tree_node, bcq):

		return "{} - self-pruning".format(tree_node.atom)

	def get_pair_pruning_sql(self, tree_node, bcq):

		return "{} - pair-pruning".format(tree_node.atom)


	def get_ground_sql(self, bcq):
		sql = "get ground rule"
		
		return [sql]

	def get_main_sql(self, bcq):
		sql = "get main join"
		return [sql]



	def get_lincqa_sql_from_ppjt(self, tree_node, bcq):

		sqls = []
		for child_node in tree_node.children:
			sqls += self.get_lincqa_sql_from_ppjt(child_node, bcq)


		sqls.append(self.get_self_pruning_sql(tree_node, bcq))
		sqls.append(self.get_pair_pruning_sql(tree_node, bcq))


		return sqls

	def rewrite_as_sql(self, cq):
		if not self.is_rewritable(cq):
			print("LinCQA not applicable - not in PPJT")
			return None
		
		bcq = cq.booleanize()

		join_tree_adj_list, root_atom_name = get_a_join_tree_adj_list(bcq, ppjt_insisted = False)
		join_tree_root = construct_join_tree_from_cq(bcq, join_tree_adj_list, root_atom_name)

		ret_sqls = []

		ret_sqls += self.get_ground_sql(bcq)
		ret_sqls += self.get_lincqa_sql_from_ppjt(join_tree_root, bcq)
		ret_sqls += self.get_main_sql(bcq)


		ret_sql = "\n\n".join(ret_sqls)

		return ret_sql


	def is_rewritable(self, cq):
		if not self.is_fo(cq):
			return False
		return True

