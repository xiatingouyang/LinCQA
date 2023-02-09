class Atom:

	def __init__(self, name, variables, pk_positions, negated=False):
		self.name = name
		self.variables = variables
		self.pk_positions = pk_positions
		self.negated = negated

	def get_arity(self):
		return len(self.variables)


	def __repr__(self):
		var_str_list = []
		n = self.get_arity()

		for i in range(n):
			if i in self.pk_positions:
				var_str_list.append("[{}]".format(self.variables[i]))
			else:
				var_str_list.append("{}".format(self.variables[i]))

		atom_str = "{}({})".format(self.name, ", ".join(var_str_list))
		if self.negated:
			ret = "!{}".format(atom_str)
		else:
			ret = atom_str
		return ret


	def get_variables(self):
		ret = []
		for var in variables:
			if not var.is_constant() and var not in ret:
				ret.append(var)
		return ret 

	def get_pk_variables(self):
		ret = []
		for pk_index in self.pk_positions:
			var = self.variables[pk_index]
			if var not in ret:
				ret.append(var)
		return ret

	def get_nonkey_variables(self):
		ret = []
		arity = len(self.variables)
		for i in range(arity):
			if i not in self.pk_positions:
				var = self.variables[i]
				if var not in ret:
					ret.append(var)
		return ret
