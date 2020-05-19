

setwd("D:\\nonstruct")

# 中文分词
library(Rwordseg)
setAnalyzer("jiebaR")
segmentCN("结合成分子时")


# 读取数据
library(readxl)
d1 <- read_excel("hupu.xlsx")
head(d1)


# 分词
c1 = segmentCN(d1$content, returnType = "tm")
c1[1]


# 创建TDM矩阵
library(tmcn)
library(tm)
tdm1 <- createTDM(c1)
inspect(tdm1)


# 创建训练集
X <- as.data.frame(t(as.matrix(tdm1)))
X[1:5, 1:6]

y <- factor(d1$class)
length(y)


# 计算 TF-IDF
library(tm)
tfidf1 <- weightTfIdf(tdm1)
inspect(tfidf1)


# 特征筛选
sk1 <- SelectKBest(X, y, method = "chi2", k = 20)
f1 <- unique(unlist(lapply(sk1, "[[", "word")))
f1

X1 <- X[, f1]
head(X1)


# 分类模型
library(caret)
m1 <- train(X1, y, method = "glm", family = "binomial")
m1$results

summary(m1$finalModel)

p1 <- predict(m1, newdata = X1)
confusionMatrix(y, p1, positive = "F")

prob1 <- predict(m1, newdata = X1, type = "prob")$F
library(pROC)
roc1 <- roc(y, prob1)
plot(roc1, print.auc = TRUE, print.thres = TRUE)



# 句法分析
library(coreNLP)
initCoreNLP("D:/Software/stanfordnlp", type = "chinese",  mem = "2g")

out <- annotateString("代码结束了")
Encoding(out$parse) <- "UTF-8"
cat(getParse(out))


