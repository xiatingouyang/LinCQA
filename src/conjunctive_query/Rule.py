class Rule:

	def __init__(self, head, body):

		self.head = head
		self.body = body

	def __repr__(self):
		body_str = ", ".join([atom.__repr__() for atom in self.body])
		ret = "{} :- {}.".format(self.head, body_str)
		return ret
