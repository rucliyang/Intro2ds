

import os
os.chdir("D:\\ai")

# 读入糖尿病数据
import pandas as pd
d1 = pd.read_excel("diabetes.xlsx")
X = d1.drop(['class'], axis=1)
y = d1['class']

# 神经网络建模
from sklearn.neural_network import MLPClassifier
m1 = MLPClassifier(hidden_layer_sizes=(3,2)) 
m1.fit(X, y)
m1.coefs_
m1.score(X, y)

p1 = m1.predict(X)
from sklearn.metrics import classification_report
print(classification_report(y, p1, labels=['pos', 'neg']))



# MXNet 的基础操作
import mxnet as mx
a = mx.nd.ones((2, 3))
a * 2 + 1

x = mx.nd.ones(12)
y = mx.nd.arange(12)
x.sahpe

x1 = x.reshape((3, 4))
y1 = y.reshape((4, 3))

x1 * x1
mx.nd.dot(x1, y1)

mx.nd.concat(x1, x1, dim = 1)
mx.nd.concat(x1, x1, dim = 0)

y1.slice_axis(axis = 1, begin = 1, end = 3) 

import numpy as np
x2 = mx.nd.array(np.ones((2, 3)))
type(x2)
x3 = x2.asnumpy()
type(x3)


x4 = mx.nd.ones((3,4), ctx = mx.gpu())
x4 + 1


# 深度学习建模
from sklearn.preprocessing import LabelEncoder
X1 = X.values
le1 = LabelEncoder().fit(y.values)
y1 = le1.transform(y.values)

data1 = mx.sym.var("data")
fc1 = mx.sym.FullyConnected(data = data1, num_hidden = 2)
act1 = mx.sym.Activation(data = fc1, act_type = "tanh")
fc2 = mx.sym.FullyConnected(data = act1, num_hidden = 3)
act2 = mx.sym.Activation(fc2, act_type = "tanh")
fc3 = mx.sym.FullyConnected(act2, num_hidden = 2)

mlp = mx.sym.SoftmaxOutput(data = fc3, name = "softmax")


# 开启输出记录
import logging
logging.getLogger().setLevel(logging.DEBUG) 

# 使用 mx.model.FeedForward.create 运行
mx.random.seed(0)
m1 = mx.model.FeedForward.create(mlp, X = X1, y = y1, ctx = mx.cpu(), num_epoch = 200, numpy_batch_size = 5, optimizer='sgd', eval_metric='acc')
from sklearn.metrics import roc_auc_score
prob1 = m1.predict(X1)
roc_auc_score(y1, prob1[:,1])

# 使用 mx.mod.Module 运行
train_iter = mx.io.NDArrayIter(X1, y1, batch_size = 5)
m1 = mx.mod.Module(symbol=mlp, context=mx.cpu())
mx.random.seed(0)
m1.fit(train_iter, optimizer='sgd', optimizer_params={'learning_rate':0.1}, num_epoch=20, eval_metric='acc')
                       
from sklearn.metrics import roc_auc_score
prob1 = m1.predict(train_iter).asnumpy()
roc_auc_score(y1, prob1[:,1])

