import sys
sys.path.append("../../")
from src.conjunctive_query.ConjunctiveQuery import *
from src.conjunctive_query.Rule import *
from src.conjunctive_query.Variable import *
from src.conjunctive_query.Atom import *
from src.conjunctive_query.Comparator import *
from src.attack_graph.AttackGraph import *


def construct_join_tree_from_cq_util(cq, join_tree_adj_list, root_atom_name, parent, seen):
	root_atom = cq.get_atom_by_name(root_atom_name)
	children = []
	for child_atom_name in join_tree_adj_list[root_atom_name]:
		if child_atom_name not in seen:
			child_node = construct_join_tree_from_cq_util(cq, join_tree_adj_list, child_atom_name, parent, seen + [root_atom_name])
			children.append(child_node)
			
	return TreeNode(root_atom, parent, children, cq.schema)



def construct_join_tree_from_cq(cq, join_tree_adj_list, root_atom_name):
	return construct_join_tree_from_cq_util(cq, join_tree_adj_list, root_atom_name, None, [])
	



def get_a_join_tree_adj_list(cq, ppjt_insisted=False):

	join_tree_adj_list = {"r_1" : ["r_2"], "r_2" : ["r_1", "r_7"], "r_7" : ["r_2"]}
	root_atom_name = "r_1"	
	return join_tree_adj_list, root_atom_name





class TreeNode:

	def __init__(self, _atom, _parent = None, _children = [], schema=None):
		self.atom = _atom 
		self.parent = _parent
		self.children = _children
		self.schema = schema


	def add_child(self, child_node):
		self.children.append(child_node)
		child_node.parent = self


	def __repr__(self):		
		curr_str = self.atom.__repr__()
		child_reprs = [child.__repr__() for child in self.children]
		child_reprs_str = ", ".join(child_reprs)
		return "{} [{}]".format(curr_str, child_reprs_str)


	def get_all_atoms(self):
		ret = [self.atom]
		for child in self.children:
			ret += child.get_all_atoms()
		return ret


	def is_ppjt(self):
		all_atoms = self.get_all_atoms()
		cq = ConjunctiveQuery(None, None, all_atoms)
		ag = AttackGraph(cq)

		unattacked_atoms = ag.get_unattacked_atom()
		if self.atom not in unattacked_atoms:
			return False

		for child in self.children:
			if not child.is_ppjt():
				return False
		return True

