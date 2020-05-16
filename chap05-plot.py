
# 设置工作路径
import os
os.getcwd()
os.chdir("D:\\viscode")

# 读入数据
import pandas as pd
import math
df1 = pd.read_csv("cellphone.csv")
df2 = df1[df1["MSales"] > 0][df1["Comments"] > 0] #取MSales和Comments大于0的数据
df2["MSales"] = df2["MSales"].apply(math.log) #对MSales取对数
df2["Comments"] = df2["Comments"].apply(math.log) #对Comments取对数

# 1.基础统计图形
# 基础绘图（散点图）
import matplotlib.pyplot as plt
plt.plot(df1['MSales'], df1['Comments'], color = "red") #指定颜色为红色
plt.show()

# 添加图形元素的方式
fig = plt.figure()
ax = fig.add_subplot(111)
ax.set(xlim=[0, 5000], ylim=[0, 5000], title="Example",
    ylabel="Y-Axis", xlabel="X-Axis") #添加坐标轴名称和标题
plt.plot(df1['MSales'], df1['Comments'])
plt.show()

# 参数和属性
plt.scatter('MSales', 'Comments', data = df2)
plt.show()

plt.scatter(df2['MSales'], df2['Comments'])
#添加坐标轴名称和标题
plt.title("Test")
plt.xlabel("MSales")
plt.ylabel("Comments")
plt.show()

# 点参数
plt.scatter('MSales', 'Comments', data = df2[1:20],
    color = "red", #颜色
    marker = "+", #点型
    s = 200) #大小
plt.show()

plt.scatter('MSales', 'Comments', data = df2[1:20],
    color = "red", #颜色
    marker = "o", #点型
    s = 100) #大小
plt.show()

# 线参数
plt.plot('MSales', 'Comments', data = df2[1:20],
  linestyle = "-", #线型 
  linewidth = 1,  #宽度
  color = "red", #颜色
  marker = "o") #点型
plt.show()

# 图例
plt.scatter('MSales', 'Comments', 
    data = df2[df2['Place'] == '广东 广州'][1:20],
    color = "red", marker = "o", label = "广州")
plt.scatter('MSales', 'Comments', 
    data = df2[df2['Place'] == '浙江 杭州'][1:20],
    color = "blue", marker = "o", label = "杭州")

plt.rcParams['font.sans-serif']=['SimHei']
plt.rcParams['axes.unicode_minus'] = False
plt.legend(loc = "upper left")
plt.show()


# 文字说明
plt.plot([1,2,3])
plt.text(1, 2, r'$\mu=100, \sigma=15$')
plt.show()

plt.plot([1,2,3])
plt.annotate('test', xy=(1, 2), xytext=(1.5, 2.2),
    arrowprops = dict(facecolor = 'black', shrink = 0.05))
plt.show()
			

# ggplot示例
import ggplot as gg
p = gg.ggplot(df2, aes(x='MSales', y='Comments'))
p = p + geom_point()
print(p)

# 2.可视化与数据分析
# 简单数据分析
import numpy as np 
df3 = df1[df1['Place'] == '广东 广州'].append(df1[df1['Place'] == '浙江 杭州'])

np.mean(df3['MSales']) #求MSales变量均值
np.std(df3['MSales']) #求MSales变量标准差
np.median(df3['MSales']) #求MSales变量中位数
np.percentile(df3['MSales'], 25) #求MSales变量分位数

df3.groupby(by='Place').count() #根据Place分组，计算频数
df3.groupby(by='Place').mean() #根据Place分组，计算均值

# 单变量的分布
# 画出连续型变量MSales的直方图
plt.hist(df1['MSales'], bins = 50, density=True, histtype='bar')
plt.show()

plt.hist(df2['MSales'], bins=20, density=True, histtype='bar')
plt.show()

# 画出离散型变量Place的条形图和饼图
dffreq = df3.groupby(by='Place').count()['Summary'] #频数分布表

#fig, (ax1, ax2) = plt.subplots(1, 2, sharex=False, sharey=False)
plt.bar(np.arange(len(dffreq)), dffreq, color='lightblue', align='center') #条形图
ax2.pie(dffreq, labels = dffreq.index) #饼图
plt.show()

# 两变量的关系

# 两个连续变量的关系：散点图

# 连续变量和离散变量的关系
# 画出变量MSales在不同Place组中的箱线图
v1 = df3[df3['Place'] == '广东 广州']['MSales']
v2 = df3[df3['Place'] == '浙江 杭州']['MSales']
plt.boxplot((v1, v2), labels=('广州','杭州'))
plt.show()

# 两个离散变量的关系
# 画出马赛克图
from statsmodels.graphics.mosaicplot import mosaic
mosaic(df3, ['Place', 'Protection'])
plt.show()


