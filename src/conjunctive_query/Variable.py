class Variable:

	def __init__(self, name="_", is_constant=False):
		self.name = name
		self.is_constant = is_constant

	def __eq__(self, var):
		return self.name.lower() == var.name.lower() and self.is_constant == var.is_constant

	def __repr__(self):
		if self.is_constant:
			return "<{}>".format(self.name)
		return self.name

	def copy(self):
		return Variable(self.name, self.is_constant)

	def is_wildcard(self):
		return self.name == "_"


	def set_is_constant(self, is_constant):
		self.is_constant = is_constant
