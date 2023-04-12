import sys
sys.path.append("../../")

from src.attack_graph.AttackGraph import *


class FORewriter:

	def __init__(self):
		print("initialized FO rewriter")

	def rewrite_as_sql(self, cq):
		return ("rewriting as sql")

	def rewrite_as_datalog(self, cq):
		return ("rewriting as datalog")

	def rewrite(self, cq, is_rewrite_as_sql = True, output_dir = ""):
		ret = ""
		if is_rewrite_as_sql:
			ret = self.rewrite_as_sql(cq)
		else:
			ret = self.rewrite_as_datalog(cq)

		if output_dir:
			output_file = open(output_dir, "w")
			print(ret, file = output_file)
			output_file.close()
		else:
			print(ret)

	def is_rewritable(self, cq):
		return self.is_fo(cq)

	def is_fo(self, cq):
		if not cq.is_self_join_free():
			print("Currently can only support sjf CQs")
			return False

		bcq = cq.booleanize()
		ag = AttackGraph(bcq)
		ret = ag.is_acyclic()
		return ret
