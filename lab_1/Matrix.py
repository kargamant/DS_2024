
class Matrix:
    def __init__(self, r, c, v):
        self.r=r
        self.c=c
        self.__matr=[[v for _ in range(0, c)] for _ in range(0, r)]
    def show(self):
        for i in self.__matr:
            for j in i:
                print(j, end="")
            print()
    def __mul__(self, other):
        pass

m=Matrix(5, 5, 1)