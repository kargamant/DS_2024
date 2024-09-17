import random

from numba import cuda
import numpy as np

def verify(res, b, a):
    return not True in [False in i for i in res==np.dot(b,a)]

def matrix_vector_multiply(matrix, vector, shape):
    result=np.empty_like(matrix)
    for i in range(shape[1]):
        for j in range(shape[0]):
            result[i][j]+=matrix[i][j]*vector[j]
    return result
