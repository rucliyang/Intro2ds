
library(readxl)
setwd("D:\\ml")

################
##  回归分析  ##
################

d0 <- read_excel("lm.xlsx")

m1 <- lm(y ~ x1 + x2, data = d0)
summary(m1)


lm1 <- lm(y~x, data = d0)
lm2 <- lm(y~x+0, data = d0)
sum1 <- summary(lm1)
sum2 <- summary(lm2)
abline(a = sum1$coefficients[1, 1], b = sum1$coefficients[2, 1])

plot(lm1)


################
## 主成分分析 ##
################

d1 <- read.csv("decathlon.csv")
rownames(d1) <- d1$name
d1$name <- NULL
head(d1)

# 使用内置函数
pca1 <- princomp(d1)
summary(pca1)
screeplot(pca1, type = "line")

# 直接FactoMineR包
library(FactoMineR)
pca2 <- PCA(d1, quanti.sup = 11:12)
summary(pca2)




################
##  聚类分析  ##
################

# 层次聚类
d1 <- read_excel("football.xlsx")
rownames(d1) <- d1$team
d1$team <- NULL
dist1 <- dist(d1)

h1 <- hclust(dist1, method = "average")
grp <- cutree(h1, k = 3)
plot(h1, hang = 0.1)

library(Cairo)
library(showtext)
font.add("yahei", "msyh.ttc")
CairoPDF(file = "ml_hclust.pdf", family="yahei", width = 12, height = 6)
plot(h1, hang = 0.1, family="yahei")
dev.off()

# K-Means 聚类分析（分为两类）
library(cluster)
km1 <- pam(d1, 3)
# 查看聚类结果
km1
plot(km1, which.plots = 1)

library(factoextra)
fviz_cluster(km1)

# 由机器来确定类别个数
library(fpc)
kmeansruns(iris[, 1:4], krange = 2:10, critout = TRUE, runs = 2, criterion = "asw")


# DBSCAN
d1 <- read.csv("cludata.csv")
plot(y~x, data = d1)

# 尝试 K-means 聚类并作图
c1 <- pam(d1, k = 2)
plot(y~x, data = d1, col = c1$clustering, pch = 16, main = "kmeans")

# 尝试 DBSCAN 聚类并作图
library(fpc)
c2 <- dbscan(d1, eps = 0.5, MinPts = 4)
plot(y~x, data = d1, col = c2$cluster, pch = 16, main = "dbscan")




##########################
##  LDA分类及性能评价   ##
##########################

library(readxl)
d1 <- read_excel("diabetes.xlsx")
X <- d1[, names(d1) != "class"]
y <- factor(d1$class)

library(caret)
library(MASS)
m1 <- train(X, y, method = "lda")
m1$results

confusionMatrix(m1)

p1 <- predict(m1, newdata = X)
confusionMatrix(y, p1, positive = "pos")


prob1 <- predict(m1, newdata = X, type = "prob")$pos
library(pROC)
roc1 <- roc(y, prob1)
roc1
plot(roc1, print.auc = TRUE, print.thres = TRUE)


trainid <- createDataPartition(1:nrow(d1), 1, p=0.4)[[1]]
m1 <- train(X[trainid,], y[trainid], method = "lda")
p1 <- predict(m1, newdata = X[-trainid,])
confusionMatrix(y[-trainid], p1, positive = "pos")



####################
##  其他分类算法  ##
####################

# 逻辑斯蒂回归
library(LogicReg)
m2 <- train(X, y, method = "glm", family = "binomial")
m2$results

p2 <- predict(m2, newdata = X)
confusionMatrix(y, p2, positive = "pos")

prob2 <- predict(m2, newdata = X, type = "prob")$pos
roc2 <- roc(y, prob2)
plot(roc2, print.auc = TRUE, print.thres = TRUE)


# 决策树
library(rpart)
m3 <- train(X, y, method = "rpart")
m3$results

library(rpart.plot)
rpart.plot.version1(m3$finalModel)

p3 <- predict(m3, newdata = X)
confusionMatrix(y, p3, positive = "pos")

prob3 <- predict(m3, newdata = X, type = "prob")$pos
roc3 <- roc(y, prob3)
plot(roc3, print.auc = TRUE, print.thres = TRUE)


# 随机森林

library(randomForest)
m4 <- train(X, y, method = "rf")
m4$results

p4 <- predict(m4, newdata = X)
confusionMatrix(y, p4, positive = "pos")

prob4 <- predict(m4, newdata = X, type = "prob")$pos
roc4 <- roc(y, prob4)
plot(roc4, print.auc = TRUE, print.thres = TRUE)



# SVM

library(e1071)
m5 <- train(X, y, method = "svmLinear2", probability = TRUE)
m5$results

p5 <- predict(m5, newdata = X)
confusionMatrix(y, p5, positive = "pos")

prob5 <- predict(m5, newdata = X, type = "prob")$pos
roc5 <- roc(y, prob5)
plot(roc5, print.auc = TRUE, print.thres = TRUE)




