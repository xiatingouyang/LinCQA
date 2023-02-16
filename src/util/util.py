def is_subset(a, b):
	for x in a:
		if x not in b:
			return False
	return True

def intersect(a, b):
	ret = []
	for x in a:
		if x in b and x not in ret:
			ret.append(x)
	return x

def union(a, b):
	ret = []
	for x in a:
		if x not in ret:
			ret.append(x)
	for x in b:
		if x not in ret:
			ret.append(x)
	return ret 

def setminus(a, b):
	ret = []
	for x in a:
		if x not in b and x not in ret:
			ret.append(x)
	return ret
