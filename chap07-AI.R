ï»?

setwd("D:\\ai")

# è¯»å…¥ç³–å°¿ç—…æ•°æ?
library(readxl)
d1 <- read_excel("diabetes.xlsx")
X <- d1[, names(d1) != "class"]
y <- factor(d1$class)


# ç¥žç»ç½‘ç»œå»ºæ¨¡
library(RSNNS)
library(caret)
m1 <- train(X, y, method = "mlp", size = c(3, 2))
weightMatrix(m1$finalModel)

p1 <- predict(m1, newdata = X)
confusionMatrix(y, p1, positive = "pos")

prob1 <- predict(m1, newdata = X, type = "prob")$pos
library(pROC)
roc1 <- roc(y, prob1)
roc1
plot(roc1, print.auc = TRUE, print.thres = TRUE)


# ä½¿ç”¨ neuralnet åŒ?
library(neuralnet)
m1 <- neuralnet(class~pregnant+glucose+pressure+triceps+insulin+mass+pedigree+age, d1, hidden=c(2, 2))
m1$result.matrix

plot(m1)

prob1 <- compute(m1, d1[, 1:8])$net.result[, 2]
library(pROC)
roc1 <- roc(y, prob1)
roc1
plot(roc1, print.auc = TRUE, print.thres = TRUE)

p1 <- factor(c("neg", "pos")[as.numeric(prob1 > 0.419) + 1])
confusionMatrix(y, p1, positive = "pos")



# MXNet çš„åŸºç¡€æ“ä½œ

#cran <- getOption("repos")
#cran["dmlc"] <- "https://apache-mxnet.s3-accelerate.dualstack.amazonaws.com/R/CRAN/"
#options(repos = cran)
#install.packages("mxnet")

library(mxnet)
a <- mx.nd.zeros(c(2, 3))
a * 2 + 1

x = mx.nd.ones(12)
y <- mx.nd.array(0:11)
dim(x)

x1 <- mx.nd.reshape(x, c(3, 4))
y1 <- mx.nd.reshape(y, c(4, 3))

x1 * x1
mx.nd.dot(x1, y1)

mx.nd.concat(list(x1, x1), dim = 1)
mx.nd.concat(list(x1, x1), dim = 0)

mx.nd.slice.axis(y1, axis = 1, begin = 1, end = 3)  #å‰é—­åŽå¼€

x2 <- mx.nd.array(matrix(1:6, 2, 3))
class(x2)
x3 <- as.array(x2)
class(x3)


x4 <- mx.nd.ones(c(3, 4), ctx = mx.gpu())
x4


# æ·±åº¦å­¦ä¹ å»ºæ¨¡
X1 <- as.matrix(X)
y1 <- as.numeric(y) - 1

#m1 <- mx.mlp(X1, y1, hidden_node= c(2, 3), out_node=2, out_activation="softmax", num.round=20, array.batch.size=15, learning.rate=0.1, momentum=0.9, eval.metric = mx.metric.accuracy)

data1 <- mx.symbol.Variable("data")
fc1 <- mx.symbol.FullyConnected(data = data1, num_hidden = 2, name = "fc1")
act1 <- mx.symbol.Activation(data = fc1, act_type = "tanh", name = "act1")
fc2 <- mx.symbol.FullyConnected(data = act1, num_hidden = 3, name = "fc2")
act2 <- mx.symbol.Activation(data = fc2, act_type = "tanh", name = "act2")
fc3 <- mx.symbol.FullyConnected(data = act2, num_hidden = 2, name = "fc3")
mlp <- mx.symbol.SoftmaxOutput(data = fc3, name = "softmax")

graph.viz(mlp, direction = "LR", type = "vis")

mx.set.seed(0)
m1 <- mx.model.FeedForward.create(mlp, X = X1, y = y1, ctx = mx.cpu(), num.round=200, array.batch.size=5, learning.rate=0.1, optimizer = "sgd", eval.metric = mx.metric.accuracy)

prob1 = predict(m1, X1)[2, ]
library(pROC)
roc1 <- roc(y1, prob1)
roc1
plot(roc1, print.auc = TRUE, print.thres = TRUE)

library(caret)
p1 <- factor(c("neg", "pos")[as.numeric(prob1 > 0.5) + 1])
confusionMatrix(y, p1, positive = "pos")




	
	
