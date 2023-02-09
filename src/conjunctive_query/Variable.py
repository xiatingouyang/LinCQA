class Variable:

	def __init__(self, name="_", is_constant=False):
		self.name = name
		self.is_constant = is_constant

	def __eq__(self, var):
		return self.name == var.name and self.is_constant == var.is_constant

	def __repr__(self):
		return self.name

	def is_wildcard(self):
		return self.name == "_"
