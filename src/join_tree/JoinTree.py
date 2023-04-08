import sys
sys.path.append("../../")
from src.conjunctive_query.ConjunctiveQuery import *
from src.conjunctive_query.Rule import *
from src.conjunctive_query.Variable import *
from src.conjunctive_query.Atom import *
from src.conjunctive_query.Comparator import *
from src.attack_graph.AttackGraph import *
from src.join_tree.JoinTreeEnumeration import *

def construct_join_tree_from_cq_util(cq, join_tree_adj_list, root_atom_name, parent, seen):
	root_atom = cq.get_atom_by_name(root_atom_name)
	children = []
	for child_atom_name in join_tree_adj_list[root_atom_name]:
		if child_atom_name not in seen:
			child_node = construct_join_tree_from_cq_util(cq, join_tree_adj_list, child_atom_name, parent, seen + [root_atom_name])
			children.append(child_node)
			
	return TreeNode(root_atom, parent, children, cq.schema)


def set_free_variables_to_tree_node(tree_node, cq):

	whole_free_variables = cq.get_head_variables()
	curr_variables = tree_node.get_all_variables()
	free_variables_req = intersect(whole_free_variables, curr_variables)
	tree_node.free_variables = free_variables_req
	for child in tree_node.children:
		set_free_variables_to_tree_node(child, cq)


def set_proj_attributes_to_tree_node(tree_node, cq):

	whole_free_variables = cq.get_head_variables()
	node_atom = tree_node.atom
	for i in range(len(node_atom.variables)):
		var = node_atom.variables[i]
		if var in whole_free_variables:
			attr = node_atom.attributes[i]
			tree_node.proj_attributes.append(attr)


	for child in tree_node.children:
		set_proj_attributes_to_tree_node(child, cq)




def set_parent_node(root_node):
	for child_node in root_node.children:
		child_node.parent = root_node
		set_parent_node(child_node)



def construct_join_tree_from_cq(cq, ppjt_insisted = False):

	all_join_tree_adj_lists = get_all_join_tree_adj_lists(cq)
	if len(all_join_tree_adj_lists) == 0:
		return None

	best_root_node = None

	for join_tree_adj_list in all_join_tree_adj_lists:
		for root_atom_name in join_tree_adj_list:
			root_node = construct_join_tree_from_cq_util(cq, join_tree_adj_list, root_atom_name, None, [])
			set_free_variables_to_tree_node(root_node, cq)
			set_proj_attributes_to_tree_node(root_node, cq)
			set_parent_node(root_node)
			if (not ppjt_insisted) or (ppjt_insisted and root_node.is_ppjt()):
				if root_node.is_better_than(best_root_node):
					best_root_node = root_node
		
	return best_root_node



class TreeNode:

	def __init__(self, _atom, _parent = None, _children = [], schema=None):
		self.atom = _atom 
		self.parent = _parent
		self.children = _children
		self.schema = schema
		self.free_variables = []
		self.proj_attributes = []

	def add_child(self, child_node):
		self.children.append(child_node)
		child_node.parent = self



	def get_height(self):
		if len(self.children) == 0:
			return 0
		else:
			heights = [child.get_height() for child in self.children]
			return max(heights) + 1



	def is_better_than(self, tree_node):
		if not tree_node:
			return True

		return self.get_height() < tree_node.get_height()


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


	def get_all_variables(self):
		all_atoms = self.get_all_atoms()
		ret = []
		for atom in all_atoms:
			variables = atom.get_variables()
			for var in variables:
				if var not in ret:
					ret.append(var)
		return ret


	def get_bad_key_head_atom(self):
		atom_name = self.atom.name 
		head_atom_name = "{}_bad_key".format(atom_name)

		variables = self.atom.get_pk_variables()
		head_atom_attributes = [self.atom.attributes[i] for i in self.atom.pk_positions]

		for child_node in self.children:
			child_good_join_atom = child_node.get_good_join_head_atom()
			for f_var in intersect(child_good_join_atom.variables, child_node.free_variables):
				if f_var not in variables:
					variables.append(f_var)
					# this is hacky... assuming that the proj
					# attribute is already * encoded * in the 
					# variable name
					attr_name = f_var.name.split(".")[1]
		
		for attr in self.proj_attributes:
			if attr not in head_atom_attributes:
				head_atom_attributes.append(attr)


		ret = Atom(head_atom_name, variables)
		ret.attributes = head_atom_attributes
		return ret

	def get_good_join_head_atom(self):
		atom_name = self.atom.name 
		head_atom_name = "{}_good_join".format(atom_name)

		parent_atom = None
		if self.parent:
			parent_atom = self.parent.atom

		variables = []
		head_atom_attributes = []
		if parent_atom:
			variables += self.atom.get_joining_variables(parent_atom)

		for f_var in self.free_variables:
			if f_var not in variables:
				variables.append(f_var)

		ret = Atom(head_atom_name, variables)
		return ret


	def get_rooted_head_atom(self):
		head_atom = Atom("q_{}".format(self.atom.name), self.free_variables)
		return head_atom


	def get_rooted_subquery(self):
		all_atoms = self.get_all_atoms()
		head_atom = self.get_rooted_head_atom()
		cq = ConjunctiveQuery(None, head_atom, all_atoms)
		return cq


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

