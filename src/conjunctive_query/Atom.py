class Atom:

	def __init__(self, name, variables, pk_positions=[], attributes=None, negated=False, comparators=[]):
		self.name = name
		self.variables = variables
		self.pk_positions = pk_positions
		if attributes:
			self.attributes = attributes
		else:
			self.attributes = ["A{}".format(i) for i in range(1, len(self.variables) + 1)]
		self.negated = negated
		self.comparators = comparators

	def get_arity(self):
		return len(self.variables)


	def set_pk_positions(pk_positions):
		self.pk_positions = pk_positions
	

	def __repr__(self):
		var_str_list = []
		n = self.get_arity()

		for i in range(n):
			if i in self.pk_positions:
				var_str_list.append("[{}]".format(self.variables[i]))
			else:
				var_str_list.append("{}".format(self.variables[i]))

		atom_str = "{}({})".format(self.name, ", ".join(var_str_list))
		if self.comparators:
			comp_str = ", ".join([comp.__repr__() for comp in self.comparators])
			atom_str = "{}, {}".format(atom_str, comp_str)	
		if self.negated:
			ret = "!{}".format(atom_str)
		else:
			ret = atom_str
		return ret


	def get_variables(self):
		ret = []
		for var in self.variables:
			if not var.is_constant and var not in ret:
				ret.append(var)
		return ret 

	def get_pk_variables(self, include_constant = True):
		ret = []
		for pk_index in self.pk_positions:
			var = self.variables[pk_index]
			if var not in ret:
				if include_constant:
					ret.append(var)
				else:
					if not var.is_constant:
						ret.append(var)
		return ret

	def get_nonkey_variables(self, include_constant = True):
		ret = []
		arity = len(self.variables)
		for i in range(arity):
			if i not in self.pk_positions:
				var = self.variables[i]
				if include_constant:
					ret.append(var)
				else:
					if not var.is_constant:
						ret.append(var)
		return ret


	def get_sql_joining_attributes(self, atom2):
		n1 = self.get_arity()
		n2 = atom2.get_arity()

		attr_joining_dict = {}

		for i in range(n1):
			for j in range(n2):

				vi = self.get_variables[i]
				vj = self.get_variables[j]

				if vi == vj:
					if  vi.name not in attr_joining_dict:
						attr_joining_dict[vi.name] = []
					if self.attributes[i] not in attr_joining_dict[vi.name]:
						attr_joining_dict[vi.name].append("{}.{}".format(self.name, self.attributes[i]))
					if atom2.attributes[j] not in attr_joining_dict[vi.name]:
						attr_joining_dict[vi.name].append("{}.{}".format(atom2.name, atom2.attributes[j]))

		return attr_joining_dict

	def get_joining_variables(self, atom):
		ret = []
		for vi in self.get_variables():
			for vj in atom.get_variables():
				if not vi.is_constant and not vj.is_constant and vi == vj and vi not in ret:
					ret.append(vi)
		return ret


	def is_joining(self, atom):
		ret = self.get_joining_variables(atom)
		return len(ret) > 0
