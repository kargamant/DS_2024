import random

from numba import cuda
import numpy as np

def verify(res, b, a):
    return not False in [i for i in res==np.dot(b,a)]

def matrix_vector_multiply(matrix, vector, shape):
    result=np.empty_like(vector)
    for i in range(len(vector)):
        result[i]=0
        for j in range(shape[0]):
            result[i]+=matrix[i][j]*vector[j]
            #print(result)
    return result
