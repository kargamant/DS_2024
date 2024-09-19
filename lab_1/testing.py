from matrix_vector_multiply import matrix_vector_multiply, verify
import numpy as np
import random

shape=(5, 5)

#vector
a=np.arange(0, shape[0]).astype(np.int32)

def gen_int_matr(shape, start, end):
    b=np.empty(shape, dtype=np.int16)
    for i in range(shape[1]):
        for j in range(shape[0]):
            b[i][j]=random.randint(start, end)
    return b

def gen_float_matr(shape, start, end):
    b=np.empty(shape, dtype=np.float16)
    for i in range(shape[1]):
        for j in range(shape[0]):
            b[i][j]=random.uniform(start, end)
    return b

#testing
results=[]
for _ in range(0, 10000):
    b=gen_int_matr(shape, 0, 500)
    res = matrix_vector_multiply(b, a, shape)
    results.append(verify(res, b, a))
    if results[-1]==False:
        print("b:\n", b)
        print("a:\n", a)
        print("res:\n", res)
        print("dot: \n", np.dot(b, a))
print("testing results: ", results.count(True), " out of ", len(results))