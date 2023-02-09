import sys
sys.path.append("../../")

from src.fo_rewriter.FORewriter import *


class LinCQARewriter(FORewriter):

	def __init__(self):
		print("initialized LinCQA rewriter")

	def rewrite_as_sql(self, cq):
		return ("TODO lincqa sql")

	def rewrite_as_datalog(self, cq):
		return ("TODO lincqa datalog")

	def is_rewritable(self, cq):
		return self.is_fo(cq)

