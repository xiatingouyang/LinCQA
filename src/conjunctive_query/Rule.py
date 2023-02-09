class Rule:

	def __init__(self, head, body):

		self.head = head
		self.body = body

	def __repr__(self):
		body_str = ", ".join(body)
		ret = "{} :- {}.".format(head, body_str)
		return ret
