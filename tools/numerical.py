
def floaty(str):
    # check if last character is question mark
    # TODO: where is this issue coming from, is this trimming impacting neg the values
    if str[-1] == '?':
        return float(str[:-1])
    return float(str)

def slope(x1, x2, y1, y2):
    return (y2 - y1) / (x2 - x1)

def bias(x1, x2, y1, y2):
    return y1 - slope(x1, x2, y1, y2) * x1

