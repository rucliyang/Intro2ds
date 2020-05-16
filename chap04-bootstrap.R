
n <- 20

Y <- rnorm(n, 0, 1)

data <- NULL

B <- 10
Ybar.b <- NULL
for(b in 1: B){
  Y.b <- sample(Y, n, replace = TRUE)

  Ybar.b <- c(Ybar.b, mean(Y.b))
}

Ybar.density <- density(Ybar.b)

data <- cbind(Ybar.density$x, Ybar.density$y, rep(B, length(Ybar.density$y)))


B <- 20
Ybar.b <- NULL
for(b in 1: B){
  Y.b <- sample(Y, n, replace = TRUE)

  Ybar.b <- c(Ybar.b, mean(Y.b))
}

Ybar.density <- density(Ybar.b)

data <- rbind(data, cbind(Ybar.density$x, Ybar.density$y, rep(B, length(Ybar.density$y))))




B <- 50
Ybar.b <- NULL
for(b in 1: B){
  Y.b <- sample(Y, n, replace = TRUE)

  Ybar.b <- c(Ybar.b, mean(Y.b))
}

Ybar.density <- density(Ybar.b)

data <- rbind(data, cbind(Ybar.density$x, Ybar.density$y, rep(B, length(Ybar.density$y))))


B <- 100
Ybar.b <- NULL
for(b in 1: B){
  Y.b <- sample(Y, n, replace = TRUE)

  Ybar.b <- c(Ybar.b, mean(Y.b))
}

Ybar.density <- density(Ybar.b)

data <- rbind(data, cbind(Ybar.density$x, Ybar.density$y, rep(B, length(Ybar.density$y))))

Ybar.density <- density(Y)

data <- rbind(data, cbind(seq(from = -1, to= 1, length.out = 1000), dnorm(seq(from = -1, to= 1, length.out = 1000), mean = 0, sd = sqrt(1/n)), rep(0, 1000)))

colnames(data) <- c("y.bar", "density", "B")

data <- as.data.frame(data)

data$B <- as.character(data$B)

data$B[data$B == "0"] <- "True"

data$B <- factor(data$B, levels = c("True", "10", "20", "50", "100"))


library(ggplot2)

ggplot(data, mapping = aes(x = y.bar, y = density, group = B, color = B)) + geom_line() + labs(title = "n = 20") + theme(plot.title = element_text(hjust = 0.5))






n <- 50

Y <- rnorm(n, 0, 1)

data <- NULL

B <- 10
Ybar.b <- NULL
for(b in 1: B){
  Y.b <- sample(Y, n, replace = TRUE)

  Ybar.b <- c(Ybar.b, mean(Y.b))
}

Ybar.density <- density(Ybar.b)

data <- cbind(Ybar.density$x, Ybar.density$y, rep(B, length(Ybar.density$y)))


B <- 20
Ybar.b <- NULL
for(b in 1: B){
  Y.b <- sample(Y, n, replace = TRUE)

  Ybar.b <- c(Ybar.b, mean(Y.b))
}

Ybar.density <- density(Ybar.b)

data <- rbind(data, cbind(Ybar.density$x, Ybar.density$y, rep(B, length(Ybar.density$y))))




B <- 50
Ybar.b <- NULL
for(b in 1: B){
  Y.b <- sample(Y, n, replace = TRUE)

  Ybar.b <- c(Ybar.b, mean(Y.b))
}

Ybar.density <- density(Ybar.b)

data <- rbind(data, cbind(Ybar.density$x, Ybar.density$y, rep(B, length(Ybar.density$y))))


B <- 100
Ybar.b <- NULL
for(b in 1: B){
  Y.b <- sample(Y, n, replace = TRUE)

  Ybar.b <- c(Ybar.b, mean(Y.b))
}

Ybar.density <- density(Ybar.b)

data <- rbind(data, cbind(Ybar.density$x, Ybar.density$y, rep(B, length(Ybar.density$y))))

Ybar.density <- density(Y)

data <- rbind(data, cbind(seq(from = -1, to= 1, length.out = 1000), dnorm(seq(from = -1, to= 1, length.out = 1000), mean = 0, sd = sqrt(1/n)), rep(0, 1000)))

colnames(data) <- c("y.bar", "density", "B")

data <- as.data.frame(data)

data$B <- as.character(data$B)

data$B[data$B == "0"] <- "True"

data$B <- factor(data$B, levels = c("True", "10", "20", "50", "100"))


library(ggplot2)

ggplot(data, mapping = aes(x = y.bar, y = density, group = B, color = B)) + geom_line() + labs(title = "n = 50") + theme(plot.title = element_text(hjust = 0.5))




n <- 100

Y <- rnorm(n, 0, 1)

data <- NULL

B <- 10
Ybar.b <- NULL
for(b in 1: B){
  Y.b <- sample(Y, n, replace = TRUE)

  Ybar.b <- c(Ybar.b, mean(Y.b))
}

Ybar.density <- density(Ybar.b)

data <- cbind(Ybar.density$x, Ybar.density$y, rep(B, length(Ybar.density$y)))


B <- 20
Ybar.b <- NULL
for(b in 1: B){
  Y.b <- sample(Y, n, replace = TRUE)

  Ybar.b <- c(Ybar.b, mean(Y.b))
}

Ybar.density <- density(Ybar.b)

data <- rbind(data, cbind(Ybar.density$x, Ybar.density$y, rep(B, length(Ybar.density$y))))




B <- 50
Ybar.b <- NULL
for(b in 1: B){
  Y.b <- sample(Y, n, replace = TRUE)

  Ybar.b <- c(Ybar.b, mean(Y.b))
}

Ybar.density <- density(Ybar.b)

data <- rbind(data, cbind(Ybar.density$x, Ybar.density$y, rep(B, length(Ybar.density$y))))


B <- 100
Ybar.b <- NULL
for(b in 1: B){
  Y.b <- sample(Y, n, replace = TRUE)

  Ybar.b <- c(Ybar.b, mean(Y.b))
}

Ybar.density <- density(Ybar.b)

data <- rbind(data, cbind(Ybar.density$x, Ybar.density$y, rep(B, length(Ybar.density$y))))

Ybar.density <- density(Y)

data <- rbind(data, cbind(seq(from = -1, to= 1, length.out = 1000), dnorm(seq(from = -1, to= 1, length.out = 1000), mean = 0, sd = sqrt(1/n)), rep(0, 1000)))

colnames(data) <- c("y.bar", "density", "B")

data <- as.data.frame(data)

data$B <- as.character(data$B)

data$B[data$B == "0"] <- "True"

data$B <- factor(data$B, levels = c("True", "10", "20", "50", "100"))


library(ggplot2)

ggplot(data, mapping = aes(x = y.bar, y = density, group = B, color = B)) + geom_line() + labs(title = "n = 100") + theme(plot.title = element_text(hjust = 0.5))

