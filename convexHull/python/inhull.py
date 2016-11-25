from sklearn.svm.libsvm import predict


def in_hull(p, hull):
    """
    Test if points in `p` are in `hull`

    `p` should be a `NxK` coordinates of `N` points in `K` dimensions
    `hull` is either a scipy.spatial.Delaunay object or the `MxK` array of the
    coordinates of `M` points in `K`dimensions for which Delaunay triangulation
    will be computed
    """
    from scipy.spatial import Delaunay
    from scipy.spatial import ConvexHull
    if not isinstance(hull,Delaunay):
        hull = Delaunay(hull)
    tic = time.time()
    tmp = time.time()
    result = hull.find_simplex(p)>=0
    toc = time.time()
    timediff = toc - 2*tmp + tic
    print hull.convex_hull
    print ("elasped time is %s\n"%timediff)
    return result 

import numpy as np
import time
from numpy import *
f = open("predictedResults", "a")
# test = np.random.rand(20,3)
# cloud  = np.random.rand(50,3)
# test=np.array([[0, 0, 0], [0.5, 0.5, 0.5], [1, 0, 2]])
# cloud = np.array([[0, 0, 0], [0, 0, 1], [0, 1, 0], [1, 0, 0], [1, 1, 0], [1, 0, 1], [0, 1, 1], [1, 1, 1]])

#cloud = loadtxt("defang.train.vector.afterPCA")
test = loadtxt("defang.predict.vector.afterPCA")
ground = loadtxt("defang.predict.label.bak")
#cloud = loadtxt("unihull.txt")
cloud = loadtxt("defang.train.vector.afterPCA")
# print  test
# print cloud
predict = in_hull(test,cloud)
result = np.zeros((100,1))
sum = 0
falspos = 0
falsneg = 0
bothin = 0
bothout = 0
for index in range(0,100):
    if predict[index] == False:
        result[index] = -1
    else:
        result[index] = 1
    if result[index] == ground[index]:
        sum+=1
    if result[index] == 1 and ground[index] == -1:
        falspos +=1
    if result[index] == -1 and ground[index] == 1:
            falsneg += 1
    if result[index] == 1 and ground[index] == 1:
        bothin += 1
    if result[index] == -1 and ground[index] == -1:
        bothout += 1


for item in result:
    f.write(str(item))
    f.write('\n')
f.close()
print("false positive is %d\n"%falspos)
print("false negative is %d\n"%falsneg)
print ("both in hull is %d\n"%bothin)
print ("both outside hull is %d\n"%bothout)
print ("correct is %d\n"%sum)
