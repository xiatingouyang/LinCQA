import sys
sys.path.append("../../")
from src.conjunctive_query.ConjunctiveQuery import *
from src.conjunctive_query.Rule import *
from src.conjunctive_query.Variable import *
from src.conjunctive_query.Atom import *
from src.util.prufer import *

    
def is_connected(tree, vertex_set):

    v = vertex_set[0]

    visited = {}
    for u in vertex_set:
        visited[u] = False

    visited[v] = True 


    def dfs_util(v, visited):

        for u in tree[v]:
            if u in vertex_set and not visited[u]:
                visited[u] = True 
                dfs_util(u, visited) 



    dfs_util(v, visited)

    for u in vertex_set:
        if not visited[u]:
            return False
    return True



def is_join_tree(cq, tree, index_to_atom):

    occurring_atoms = {}

    for index in index_to_atom:
        atom = index_to_atom[index]
        for var in atom.get_variables():
            if var.name not in occurring_atoms:
                occurring_atoms[var.name] = []
            occurring_atoms[var.name].append(index)

    for u in tree:
        for v in tree[u]:
            atom1 = index_to_atom[u]
            atom2 = index_to_atom[v]
            if not atom1.is_joining(atom2, cq.get_head_variables()):
                return False


    for var_name in occurring_atoms:
        vertex_set = occurring_atoms[var_name]

        if not is_connected(tree, vertex_set):
            
            return False
    return True


def construct_join_tree_adj_list(tree, index_to_atom):

    tree_adj_list = {}
    for u in tree:
        tree_adj_list[index_to_atom[u].name] = []
        for v in tree[u]:
            tree_adj_list[index_to_atom[u].name].append(index_to_atom[v].name)
    return tree_adj_list




def get_all_join_tree_adj_lists(cq):

    n = len(cq.body)
    index_to_atom = {}

    for i in range(1, n+1):
        index_to_atom[i] = cq.body[i-1]
    
    all_trees = enumerate_all_sequences(n, convert_sequence_to_tree)
    jointrees = []
    for tree in all_trees:
        if is_join_tree(cq, tree, index_to_atom):
            jt = construct_join_tree_adj_list(tree, index_to_atom)
            jointrees.append(jt)


    return jointrees

