def sym_or (list): #TODO: are these symor and symAnd traceble in z3 or a diff encoding is better ??
    '''Symbolic or statement'''
    for l in list:
        if l == 1:
            return 1
    return 0

def sym_and(list):
    '''Symbolic and statement'''
    for l in list:
        if l == 0:
            return 0