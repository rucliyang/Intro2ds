

setwd("D:\\nonstruct")


################################
##  图像处理                  ##
################################

library(EBImage)
lena <- readImage("lena.jpg")
dim(lena)
display(lena)

# 和数组的转换
d1 <- as.array(lena)
dim(d1)
img1 <- Image(d1[, , 1])

# 图像转换
img2 <- resize(img1, 200, 100)
img3 <- rotate(img1, 90) # 顺时针旋转90
img4 <- flop (img1) # 左右翻转
img5 <- flip (img1) # 上下翻转

img6 <- img1[1:200, 1:100] #左到右、上到下

# 矩阵运算
lena1 <- lena + 0.5
lena2 <- 3 * lena

# 卷积
con1 <- matrix(c(4,0,0,0,0,0,0,0,-4), 3, 3)
img7 <- filter2(img1, con1)




################################
##  使用图像数据进行手写识别  ##
################################

setwd("D:\\Storage\\Nutstore\\Book\\rucds\\work\\nonstruct")
library(mxnet)
library(EBImage)

fn <- list.files("MINIST/train")
y <- as.numeric(gsub("(^[0-9]*_|\\.jpg$)", "", fn))
X <- array(0, dim = c(32, 32, 1, length(fn)))
for (i in seq_along(fn)) {
	img0 <- readImage(file.path("MINIST/train", fn[i]))
	img0 <- resize(img0, 32, 32)
	arr1 <- as.array(img0)[, , 1]
	X[, , 1, i] <- arr1
}

fn <- list.files("MINIST/test")
y1 <- as.numeric(gsub("(^[0-9]*_|\\.jpg$)", "", fn))
X1 <- array(0, dim = c(32, 32, 1, length(fn)))
for (i in seq_along(fn)) {
	img0 <- readImage(file.path("MINIST/test", fn[i]))
	img0 <- resize(img0, 32, 32)
	arr1 <- as.array(img0)[, , 1]
	X1[, , 1, i] <- arr1
}

train_iter = list(data = X, label = y)
val_iter = list(data = X1, label = y1)

# 建立 CNN 模型
data <- mx.symbol.Variable("data")
C1 <- mx.symbol.Convolution(data = data, kernel = c(5,5), num_filter = 20)
tanh1 <- mx.symbol.Activation(data = C1, act_type = "tanh")
S2 <- mx.symbol.Pooling(data  = tanh1, pool_type = "max", kernel = c(2, 2), stride = c(2, 2))
C3 <- mx.symbol.Convolution(data = S2, kernel = c(5, 5), num_filter = 50)
tanh2 <- mx.symbol.Activation(data = C3, act_type = "tanh")
S4 <- mx.symbol.Pooling(data = tanh2, pool_type = "max", kernel = c(2, 2), stride = c(2, 2))
flatten <- mx.symbol.Flatten(data = S4)
C5 <- mx.symbol.FullyConnected(data = flatten, num_hidden = 120)
tanh3 <- mx.symbol.Activation(data = C5, act_type = "tanh")
F6 <- mx.symbol.FullyConnected(data = tanh3, num_hidden = 84)
tanh4 <- mx.symbol.Activation(data = F6, act_type = "tanh")
F7 <- mx.symbol.FullyConnected(data = tanh4, num_hidden = 10)
lenet <- mx.symbol.SoftmaxOutput(data = F7, name = "softmax")


# 可视化
graph.viz(lenet, direction = "LR")

ctx = mx.gpu()

# 基于 CPU 运行模型
mx.set.seed(0)
t1 <- Sys.time()
m1 <- mx.model.FeedForward.create(lenet, X = X, y = y, ctx = ctx, num.round = 100, array.batch.size = 100, learning.rate = 0.05, momentum=  0.9, eval.metric = mx.metric.accuracy, eval.data = val_iter)
t2 <- Sys.time()
t2 - t1

# Time difference of 10.83941 mins
# Time difference of 35.35645 secs

# 预测
prob1 <- predict(m1, X = X1)
p1 <- apply(prob1, 2, which.max) - 1
sum(p1 == y1) / length(p1)
table(p1, y1)



