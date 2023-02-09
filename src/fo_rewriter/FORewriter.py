class FORewriter:

	def __init__(self):
		print("initialized FO rewriter")

	def rewrite_as_sql(self, cq):
		print("rewriting as sql")

	def rewrite_as_datalog(self, cq):
		print("rewriting as datalog")

	def rewrite(self, cq, is_rewrite_as_sql = True):
		if is_rewrite_as_sql:
			self.rewrite_as_sql(cq)
		else:
			self.rewrite_as_datalog(cq)

	def is_rewritable(self, cq):
		return self.is_fo(cq)

	def is_fo(self, cq):
		return True
	