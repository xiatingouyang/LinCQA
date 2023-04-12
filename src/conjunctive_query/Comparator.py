


class Comparator:

	def __init__(self, lhs, rhs):
		self.lhs = lhs
		self.rhs = rhs

	def negate(self):
		return None



class Equal(Comparator):

	def negate(self):
		return NotEqual(self.lhs, self.rhs)

	def __repr__(self):
		return "{} = {}".format(self.lhs, self.rhs)



class NotEqual(Comparator):

	def negate(self):
		return Equal(self.lhs, self.rhs)

	def __repr__(self):
		return "{} <> {}".format(self.lhs, self.rhs)


class LessThan(Comparator):

	def negate(self):
		return GreaterThanEq(self.lhs, self.rhs)

	def __repr__(self):
		return "{} < {}".format(self.lhs, self.rhs)


class GreaterThan(Comparator):

	def negate(self):
		return LessThanEq(self.lhs, self.rhs)

	def __repr__(self):
		return "{} > {}".format(self.lhs, self.rhs)


class LessThanEq(Comparator):

	def negate(self):
		return GreaterThan(self.lhs, self.rhs)

	def __repr__(self):
		return "{} <= {}".format(self.lhs, self.rhs)


class GreaterThanEq(Comparator):

	def negate(self):
		return LessThan(self.lhs, self.rhs)

	def __repr__(self):
		return "{} >= {}".format(self.lhs, self.rhs)


class Like(Comparator):
	
	def negate(self):
		return NotLike(self.lhs, self.rhs)

	def __repr__(self):
		return "{} LIKE {}".format(self.lhs, self.rhs)


class NotLike(Comparator):
	
	def negate(self):
		return Like(self.lhs, self.rhs)

	def __repr__(self):
		return "{} NOT LIKE {}".format(self.lhs, self.rhs)


def get_comparator(lhs, op, rhs):
	if op == "=":
		return Equal(lhs, rhs)
	elif op == "<>":
		return NotEqual(lhs, rhs)
	elif op == "<":
		return LessThan(lhs, rhs)
	elif op == ">":
		return GreaterThan(lhs, rhs)
	elif op == "<=":
		return LessThanEq(lhs, rhs)
	elif op == ">=":
		return GreaterThanEq(lhs, rhs)
	elif op == "like":
		return Like(lhs, rhs)
	return None
