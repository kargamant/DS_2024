from matrix_vector_multiply import matrix_vector_multiply, verify
import numpy as np
import random

shape=(5, 5)

#vector
a=np.arange(0, shape[0]).astype(np.float16)

#matrix
b=np.ones((shape[1], shape[0]), dtype=np.float16)

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

b=gen_float_matr(shape, 0.0, 1.0)
res=matrix_vector_multiply(b, a, shape)
print("b:\n", b)
print("a:\n", a)
print("res:\n",res)
print("verify: ", verify(res.astype(np.float16), b, a))

#testing
# results=[]
# for _ in range(0, 100):
#     for i in range(shape[1]):
#         for j in range(shape[0]):
#             b[i][j] = random.uniform(0.0, 1.0)
#     res = matrix_vector_multiply(b.astype(np.float16), a.astype(np.float16), shape)
#     results.append(verify(res, b, a))
# print("testing results: ", results.count(True), " out of ", len(results))