# 准备工作
setwd("D:\\viscode") #确定数据的读取路径，需要先把整个viscode文件夹放在D盘
library(tmcn)
library(readxl)

# 1.基础统计图形

plot(1, 1, pch = "o") #图形设备示例

df1 <- read_excel("cellphone.xlsx") #读取数据集

df2 <- df1[df1$MSales > 0 & df1$Comments > 0, ] #取MSales和Comments大于0的数据
df2$MSales <- log(df2$MSales) #对MSales取对数
df2$Comments <- log(df2$Comments) #对Comments取对数

# 画出散点图并保存成pdf
pdf(file = "vis_plot1.pdf", width=8, height=5)
plot(MSales ~ Comments, data = df2) 
dev.off()

# 在散点图基础上加坐标轴名称和标题
pdf(file = "vis_plot2.pdf", width=8, height=5)
plot(MSales ~ Comments, data = df2,
	main = "Test",
	xlab = "X",
	ylab = "Y")
dev.off()

# 修改点的颜色和形状
pdf(file = "vis_plot3.pdf", width=8, height=5)
plot(MSales ~ Comments, data = df2[1:20, ],
	col = "red", #红色 
	pch = 19, #圆点
	cex = 1) #大小为默认值的1倍
dev.off()

# 修改线型
pdf(file = "vis_plot4.pdf", width=8, height=5)
plot(MSales ~ Comments, data = df2[1:20, ],
	type = "l", #确定画线图 
	lty = 2, #线型
	lwd = 2, #宽度
	col = "red") #颜色
dev.off()

pdf(file = "vis_plot5.pdf", width=8, height=5)
plot(MSales ~ Comments, 
	data = df2[df2$Place %in% c("广东 广州", "浙江 杭州"), ][1:20,],
	col = factor(Place), #根据Place变量确定点的颜色 
	pch = 19)
dev.off()

pdf(file = "vis_plot6.pdf", width=8, height=5, family="GB1")
plot(MSales ~ Comments, 
	data = df2[df2$Place %in% c("广东 广州", "浙江 杭州"), ][1:20,],
	col = factor(Place), pch = 19)
# 加上图例
legend(0, 6, legend = c("广州", "杭州"), col = c(1, 2), pch = 19)	
dev.off()

pdf(file = "vis_plot7.pdf", width=8, height=5, family="GB1")
plot(MSales ~ Comments, 
	data = df2[df2$Place %in% c("广东 广州", "浙江 杭州"), ][1:20,],
	col = factor(Place), pch = 19)
legend(0, 6, legend = c("广州", "杭州"), col = c(1, 2), pch = 19)	
# 加上文字
text(1, 2, expression(paste(mu, "=100, ", sigma, "=15")))
dev.off()

# ggplot示例
library(ggplot2)
p <- ggplot(mtcars, aes(x = mpg, y = wt))
print(p) # 只显示画布

# 确定几何对象（点图）
p <- p + geom_point()
print(p) # 显示散点图

# 叠加图层（拟合曲线）
p <- p + geom_smooth(method = "loess")
print(p) # 在散点图基础上呈现拟合曲线

# 2.可视化与数据分析

df3 <- df2[df2$Place %in% c("广东 广州", "浙江 杭州"), ]

# 单变量的分布

# 画出连续型变量MSales的直方图
pdf(file = "vis_ana1.pdf", width=8, height=5)
hist(df2[['MSales']], breaks = 20, main = "", xlab = "")
dev.off()

# 画出离散型变量Place的条形图
pdf(file = "vis_ana2.pdf", width=8, height=5, family="GB1")
dffreq <- table(df3[['Place']])
barplot(dffreq)
dev.off()

# 画出离散型变量Place的饼图
pdf(file = "vis_ana3.pdf", width=8, height=5, family="GB1")
pie(dffreq)
dev.off()

# 两变量的关系

# 两个连续变量的关系：散点图

# 连续变量和离散变量的关系
# 画出变量MSales在不同Place组中的箱线图
pdf(file = "vis_ana4.pdf", width=8, height=5, family="GB1")
boxplot(MSales ~ Place, data = df3)
dev.off()

# 两个离散变量的关系
# 画出马赛克图
pdf(file = "vis_ana5.pdf", width=8, height=5, family="GB1")
df3$Freq <- 1
tab3 <- xtabs(Freq ~ Protection + Place, data = df3)
plot(tab3, main = "")
dev.off()

# 多变量的关系
d1 <- read_excel("football.xlsx", sheet = "数据统计")
d2 <- d1[, 3:11] #取第三个到第十一个变量
pdf(file = "vis_ana6.pdf", width=8, height=6, family="GB1")
library(corrplot)
corr1 <- cor(d2) #得到d2数据集的相关阵
corrplot(corr1) #画出相关矩阵图
dev.off()
