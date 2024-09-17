import random

from numba import cuda
import numpy as np

shape=(2048, 2048)

#vector
a=np.arange(0, shape[0])

#matrix
b=np.ones((shape[1], shape[0]), dtype=np.float32)
for i in range(shape[1]):
    for j in range(shape[0]):
        b[i][j]=random.uniform(0.0, 1.0)