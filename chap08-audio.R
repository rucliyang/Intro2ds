
setwd("D:\\nonstruct")
library(tuneR)


# 读音频文件
x <- readMP3("beibei.mp3")
x

# 绘图
plot(x)


# 写音频文件
writeWave(x, "beibei.wav")


# 短时傅里叶变换
library(seewave) 
d1 <- spectro(x, wl = 512)


# 提取LFCC
m1 <- melfcc(x)
dim(m1)

image(m1)

