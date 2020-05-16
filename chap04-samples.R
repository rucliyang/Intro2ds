rm(list = ls())

# R代码：用CV来选模型

#模型1：全模型
#模型2：只考虑两个协变量：crim + nox

set.seed ( 1 )

# 验证集方法
library ( MASS )
data ( Boston )
dim ( Boston )
attach(Boston)
T <- 10
err1 <- rep ( 0 , T )
for ( i in 1 : T ) {
  train2 <- sample ( 506 , 506 / 2 )
  lmfit2 <- lm ( medv ~. , data = Boston , subset = train2 )
  pred2 <- predict ( lmfit2 , Boston [ - train2 , ] )
  err1 [ i ] <- mean ( ( medv [ - train2 ] - pred2 ) ^ 2 )
}
detach ( Boston )
mean(err1)


attach(Boston)
T <- 10
err2 <- rep ( 0 , T )
for ( i in 1 : T ) {
  train2 <- sample ( 506 , 506 / 2 )
  lmfit2 <- lm ( medv ~ crim + nox , data = Boston , subset = train2 )
  pred2 <- predict ( lmfit2 , Boston [ - train2 , ] )
  err2 [ i ] <- mean ( ( medv [ - train2 ] - pred2 ) ^ 2 )
}
detach ( Boston )
mean(err2)



cv.err1 <- rep ( 0 , 506 )
attach ( Boston )
for ( i in 1 : dim(Boston)[1] ) {
  train <- Boston[-i,]
  lmfit <- lm ( medv ~. , data = train )
  pred <- predict ( lmfit , Boston [ i , ] )
  cv.err1 [ i ] <- mean ( ( medv [ i ] - pred ) ^ 2 )
}
detach ( Boston )
mean(cv.err1)

cv.err2 <- rep ( 0 , 506 )
attach ( Boston )
for ( i in 1 : dim(Boston)[1] ) {
  train <- Boston[-i,]
  lmfit <- lm ( medv ~ crim + nox , data = train )
  pred <- predict ( lmfit , Boston [ i , ] )
  cv.err2 [ i ] <- mean ( ( medv [ i ] - pred ) ^ 2 )
}
detach ( Boston )
mean(cv.err2)


# K折交叉验证法
K <- 10
n <- dim(Boston)[1]
n/10
n.set <- c(rep(51, 9), n - 51*9)
reorder <- sample(1:n, n, replace = FALSE)
index.list <- list()
for(k in 1:K){
  index.list <- c(index.list, list(reorder[c(1, cumsum(n.set)[-10]+1)[k] : cumsum(n.set)[k]]) )
}


i <- 1
err3 <- rep(0, K)
for ( i in 1 : K ) {
  test <- index.list[[i]]
  train <- c(1:n)[-test]
  lmfit3 <- lm ( medv ~. , data = Boston, subset = train )
  err3 [ i ] <- mean((Boston$medv[test] -  predict ( lmfit3 , Boston [ test , ] ))^2)
}
mean(err3)

##选模型
err4 <- rep(0, K)
for ( i in 1 : K ) {
  test <- index.list[[i]]
  train <- c(1:n)[-test]
  lmfit3 <- lm ( medv ~ crim + nox , data = Boston, subset = train )
  err4 [ i ] <- mean((Boston$medv[test] -  predict ( lmfit3 , Boston [ test , ] ))^2)
}
mean(err4)



#### 课后思考： 请用CV选择出最好的模型


