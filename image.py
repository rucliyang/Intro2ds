

import os
os.chdir("D:\\nonstruct")


################################
##  图像处理                  ##
################################

from PIL import Image, ImageFilter
lena = Image.open("lena.jpg")
lena.size
lena.show()

# 和数组的转换
import numpy as np
d1 = np.asarray(lena)
img1 = Image.fromarray(d1)

# 图像转换
img2 = img1.resize((200,100))
img3 = img1.rotate(90) # 逆时针旋转90
img4 = img1.transpose(Image.FLIP_LEFT_RIGHT) # 左右翻转
img5 = img1.transpose(Image.FLIP_TOP_BOTTOM) # 上下翻转

img6 = img1.crop((0, 0, 200, 100)) #左上右下

# 矩阵运算
lena1 = Image.fromarray(d1 + 100)
lena2 = Image.fromarray(d1*3)

# 卷积
con1 = ImageFilter.Kernel((3, 3), (4,0,0,0,0,0,0,0,-4), scale = 9)
img7 = lena.filter(con1)





################################
##  使用图像数据进行手写识别  ##
################################

import mxnet as mx
import os
import re
from PIL import Image
import numpy as np

fn = os.listdir("MINIST/train")
y = [eval(re.sub("(^[0-9]*_|\\.jpg$)", "", x)) for x in fn]
y = mx.nd.array(y)

X = mx.nd.zeros((len(fn), 1, 32, 32))
for i in range(len(fn)):
    img0 = Image.open("MINIST/train/" + fn[i])
    img0 = img0.resize((32, 32))
    arr1 = np.asarray(img0)[:,:,1]
    X[i][0] = arr1 / 255


fn = os.listdir("MINIST/test")
y1 = [eval(re.sub("(^[0-9]*_|\\.jpg$)", "", x)) for x in fn]
y1 = mx.nd.array(y1)

X1 = mx.nd.zeros((len(fn), 1, 32, 32))
for i in range(len(fn)):
    img0 = Image.open("MINIST/test/" + fn[i])
    img0 = img0.resize((32, 32))
    arr1 = np.asarray(img0)[:,:,1]
    X1[i][0] = arr1 / 255   


batch_size = 100
train_iter = mx.io.NDArrayIter(X, y, batch_size, shuffle = True)
val_iter = mx.io.NDArrayIter(X1, y1, batch_size, shuffle = True)

data = mx.sym.var("data")
C1 = mx.sym.Convolution(data = data, kernel = (5,5), num_filter = 20)
tanh1 = mx.sym.Activation(data = C1, act_type = "tanh")
S2 = mx.sym.Pooling(data = tanh1, pool_type = "max", kernel = (2, 2), stride = (2, 2))
C3 = mx.sym.Convolution(data = S2, kernel = (5, 5), num_filter = 50)
tanh2 = mx.sym.Activation(data = C3, act_type = "tanh")
S4 = mx.sym.Pooling(data = tanh2, pool_type = "max", kernel = (2, 2), stride = (2, 2))
flatten = mx.sym.flatten(data = S4)
C5 = mx.symbol.FullyConnected(data = flatten, num_hidden = 120)
tanh3 = mx.sym.Activation(data = C5, act_type = "tanh")
F6 = mx.sym.FullyConnected(data = tanh3, num_hidden = 84)
tanh4 = mx.sym.Activation(data = F6, act_type = "tanh")
F7 = mx.sym.FullyConnected(data = tanh4, num_hidden = 10)
lenet = mx.sym.SoftmaxOutput(data = F7, name = "softmax")

ctx = mx.cpu()
import datetime
import logging
logging.getLogger().setLevel(logging.DEBUG) 

m1 = mx.mod.Module(symbol = lenet, context = ctx)

mx.random.seed(0)
t1 = datetime.datetime.now()
m1.fit(train_iter, eval_data = val_iter, optimizer = "sgd", optimizer_params = {'learning_rate':0.05,'momentum': 0.9}, eval_metric = 'acc', num_epoch = 100)
t2 = datetime.datetime.now()
t2 - t1

# datetime.timedelta(seconds=708, microseconds=917126)
# datetime.timedelta(seconds=36, microseconds=231106)

prob1 = m1.predict(val_iter)
p1 = prob1.argmax(axis = 1)
np.mean(p1.asnumpy() == y1.asnumpy())

