import math
class Vector:
    def __init__(self, *args):
        self.v = tuple(args)

    def __add__(self, other):
        if len(self.v) != len(other.v):
            raise ValueError() #방법 1
            #raise ValueError('벡터의 크기가 서로 달라 + 연산이 불가능') #방법 2
        else:
            rslt=[]
            for i in range(len(self.v)):
                rslt.append(self.v[i]+other.v[i])
            return Vector(*rslt)

    def __sub__(self, other):
        if len(self.v) != len(other.v):
            raise ValueError('벡터의 크기가 서로 달라 - 연산이 불가능')
        else:
            rslt=[]
            for i in range(len(self.v)):
                rslt.append(self.v[i]-other.v[i])
            return Vector(*rslt)

    def __mul__(self, other):
        if len(self.v) != len(other.v):
            raise ValueError('벡터의 크기가 서로 달라 * 연산이 불가능')
        else:
            rslt = 0.0
            for i in range(len(self.v)):
                rslt += self.v[i]*other.v[i]
            return rslt

    def distance(self, other):
        if len(self.v) != len(other.v):
            raise ValueError('벡터의 크기가 서로 달라 거리 계산이 불가능')
        else:
            rslt = 0.0
            for i in range(len(self.v)):
                rslt += math.pow(self.v[i] - other.v[i], 2)
            return format(math.sqrt(rslt), '.4f')

    def norm(self):
        rslt=0.0
        for i in range(len(self.v)):
            rslt += math.pow(self.v[i], 2)
        return format(math.sqrt(rslt), '.4f')

    def __str__(self):
        if(str(self.v) != None):
            return str(self.v)

if __name__=='__main__':
    u1 = Vector(1, 2, 3, 4)
    u2 = Vector(-1, 0, 1, 0)
    u3 = Vector(1, 0, 1)
    u4 = Vector(-1, 0, 1)

    try:
        print(u1 + u2)
    except ValueError: #방법 1
        print(f"벡터의 크기가 서로 달라 + 연산이 불가능")
    #except ValueError as e:  #방법2
        #print(e)

    try:
        print(u1 + u3)
    except ValueError: #방법 1
        print(f"벡터의 크기가 서로 달라 + 연산이 불가능")
    # except ValueError as e:  #방법2
        # print(e)

    try:
        print(u3 - u4)
    except ValueError as e:
        print(e)

    try:
        print(u1 * u2)
    except ValueError as e:
        print(e)

    try:
        print(u1 * u3)
    except ValueError as e:
        print(e)

    try:
        print(u1.distance(u2))
    except ValueError as e:
        print(e)

    try:
        print(u3.distance(u4))
    except ValueError as e:
        print(e)

    print(u1.norm())
    print(u2.norm())
    print(u3.norm())
    print(u4.norm())