import sys
sys.path.append("../../")
from src.conjunctive_query.Rule import *
from src.conjunctive_query.Variable import *
from src.conjunctive_query.Atom import *
from src.conjunctive_query.Comparator import *
from src.util.util import *


class AttackGraph:

	def __init__(self, cq):

		self.cq = cq 
		self.relation_names = [atom.name for atom in cq.body]
		self.attacks = {}
		
		if not cq.is_boolean():
			print("Attack graph only for BCQs")
			return None

		closures = {}

		fds = []
		for atom in cq.body:
			lhs = atom.get_pk_variables(include_constant = False)
			rhs = atom.get_nonkey_variables(include_constant = False)
			fds.append((lhs, rhs))

		for atom in cq.body:

			fds = []
			for atom2 in cq.body:
				if atom2 != atom:
					lhs = atom2.get_pk_variables(include_constant = False)
					rhs = atom2.get_nonkey_variables(include_constant = False)
					fds.append((lhs, rhs))

			closures[atom.name] = self.compute_closure(atom, cq, fds)
			self.attacks[atom.name] = []
			
			queue = [atom]
			while queue:
				node = queue.pop(0)

				found_new = False
				for node2 in cq.body:
					if node2 == atom:
						continue
					joining_var = node.get_joining_variables(node2)
					if len(setminus(joining_var, closures[atom.name])) > 0 and \
							 node2.name not in self.attacks[atom.name]:
						queue.append(node2)
						self.attacks[atom.name].append(node2.name)
						found_new = True

				if not found_new:
					break

			# print(closures)
		


	def __repr__(self):
		ret = ""
		for u in self.attacks:
			if len(self.attacks[u]) == 0:
				ret += "{} -> \n".format(u)
			for v in self.attacks[u]:
				ret += "{} -> {}\n".format(u, v)
		return ret 


	def compute_closure(self, atom, cq, fds):
		
		ret = atom.get_pk_variables(include_constant = False)
		
		growing = True 
		while growing:
			growing = False
			for fd in fds:
				lhs, rhs = fd  
				if is_subset(lhs, ret):
					new_ret = union(ret, rhs)
					if len(new_ret) > len(ret):
						ret = new_ret
						growing = True

		return ret


	def is_acyclic(self):

		for s in self.attacks:

			queue = [s]
			visited = []

			while queue:
				u = queue.pop(0)
				visited.append(u)

				for v in self.attacks[u]:
					if v in visited:
						return False
					queue.append(v)

		return True




	def get_unattacked_atom(self):
		in_deg = {}
		for u in self.attacks:
			in_deg[u] = 0

		for u in self.attacks:
			for v in self.attacks[u]:
				in_deg[v] += 1

		ret = []
		for u in self.attacks:
			if in_deg[u] == 0:
				ret.append(self.cq.get_atom_by_name(u))
		return ret
