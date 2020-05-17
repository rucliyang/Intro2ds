

import os
os.chdir("D:\\ml")


################
##  回归分析  ##
################

import pandas as pd
d0 = pd.read_excel('lm.xlsx')

import statsmodels.api as sm
X = d0[['x1', 'x2']]
y = d0['y']
m1 = sm.OLS(y, sm.add_constant(X))
m1.fit().summary()


################
## 主成分分析 ##
################

d1 = pd.read_csv("decathlon.csv")
d1 = d1.drop(['name'], axis=1)

from sklearn.decomposition import PCA
pca1 = PCA(n_components=2)
pca1.fit(d1)
pca1.explained_variance_ratio_




################
##  聚类分析  ##
################

# 层次聚类
import pandas as pd
import scipy.cluster.hierarchy as hcluster

d1 = pd.read_excel("football.xlsx")
d1.index = d1['team']
d1 = d1.drop(['team'], axis=1)

h1 = hcluster.fclusterdata(d1, criterion = 'maxclust', t = 3)
h1


# K-Means 聚类分析（分为两类）
import matplotlib.pyplot as plt
import numpy as np
from sklearn.cluster import KMeans

km1 = KMeans(n_clusters = 2)
km1.fit(d1)

km1.cluster_centers_
km1.labels_


# DBSCAN
d1 = pd.read_csv("cludata.csv")
from sklearn.cluster import DBSCAN
c1 = DBSCAN(eps = 0.5, min_samples = 4)
c1.fit(d1)
c1.labels_

plt.scatter('x', 'y', data = d1[c1.labels_ == 0], c = "red", marker='o', label='0')
plt.scatter('x', 'y', data = d1[c1.labels_ == 1], c = "blue", marker='o', label='1')
plt.show()




##########################
##  LDA分类及性能评价   ##
##########################

import pandas as pd
d1 = pd.read_excel("diabetes.xlsx")
X = d1.drop(['class'], axis=1)
y = d1['class']

from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
m1 = LinearDiscriminantAnalysis()
m1.fit(X, y)
m1.coef_
m1.intercept_
m1.score(X, y)

p1 = m1.predict(X)
from sklearn.metrics import classification_report
print(classification_report(y, p1, labels=['pos', 'neg']))

from sklearn.metrics import roc_auc_score
prob1 = m1.predict_proba(X)
print(roc_auc_score(y, prob1[:,1]))


from sklearn.metrics import roc_curve
import matplotlib.pyplot as plt
fpr, tpr, thresholds = roc_curve(y,prob1[:,1], pos_label = "pos")
plt.plot(fpr,tpr)


from sklearn.model_selection import train_test_split
x_train, x_test, y_train, y_test = train_test_split(X,y, test_size=0.4)
m1.fit(x_train, y_train)
p1 = m1.predict(x_test)
print(classification_report(y_test, p1, labels=['pos', 'neg']))


####################
##  其他分类算法  ##
####################

# 逻辑斯蒂回归
from sklearn.linear_model import LogisticRegression

m2 = LogisticRegression()
m2.fit(X, y)
m2.coef_
m2.intercept_
m2.score(X, y)

x_train, x_test, y_train, y_test = train_test_split(X,y, test_size=0.1)
m2.fit(x_train, y_train)
m2.score(x_test, y_test)


# 决策树
from sklearn.tree import DecisionTreeClassifier
from sklearn.tree import export_graphviz
from sklearn.feature_extraction import DictVectorizer

m3 = DecisionTreeClassifier()
m3.fit(X, y)
m3.score(X, y)

x_train, x_test, y_train, y_test = train_test_split(X,y, test_size=0.1)
m3.fit(x_train, y_train)
m3.score(x_test, y_test)


# 随机森林
from sklearn.ensemble import RandomForestClassifier 
m4 = RandomForestClassifier()
m4.fit(X, y)
m4.score(X, y)

x_train, x_test, y_train, y_test = train_test_split(X,y, test_size=0.1)
m4.fit(x_train, y_train)
m4.score(x_test, y_test)



# SVM
from sklearn.svm import SVC
m5 = SVC()
m5.fit(X, y)
m5.score(X, y)

x_train, x_test, y_train, y_test = train_test_split(X,y, test_size=0.1)
m5.fit(x_train, y_train)
m5.score(x_test, y_test)


