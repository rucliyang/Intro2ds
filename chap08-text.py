

import os
os.chdir("D:\\nonstruct")

# 中文分词
import jieba
jieba.lcut("结合成分子时")


# 读取数据
import pandas as pd
d1 = pd.read_excel("hupu.xlsx")
d1.head()


# 分词
c1 = [' '.join(jieba.cut(d1['content'][i])) for i in range(d1.shape[0])]
c1[0]


# 创建TDM矩阵
from sklearn.feature_extraction.text import CountVectorizer
v1 = CountVectorizer()
a1 = v1.fit_transform(c1)
a1.shape
tdm1 = pd.DataFrame(a1.toarray().T, index = v1.get_feature_names())
tdm1.head()


# 创建训练集
X = tdm1.T
X.head()

y = d1['class']
y.shape


# 计算 TF-IDF
from sklearn.feature_extraction.text import TfidfTransformer  
tf1 = TfidfTransformer()  
tfidf1 = tf1.fit_transform(X).toarray()


# 特征筛选
from sklearn.feature_selection import chi2
from sklearn.feature_selection import SelectKBest
sk1 = SelectKBest(chi2, k=20)
sk1.fit_transform(X,y)
f1 = sk1.get_support(True)
list(X.columns[f1])

X1 = X[list(X.columns[f1])]
X1.head()


# 分类模型
from sklearn.linear_model import LogisticRegression
m1 = LogisticRegression()
m1.fit(X1, y)
m1.coef_
m1.score(X1, y)

p1 = m1.predict(X1)
from sklearn.metrics import classification_report
print(classification_report(y, p1, labels=['B', 'F']))

from sklearn.metrics import roc_auc_score
prob1 = m1.predict_proba(X1)
print(roc_auc_score(y, prob1[:,1]))

from sklearn.metrics import roc_curve
import matplotlib.pyplot as plt
fpr, tpr, thresholds = roc_curve(y,prob1[:,1], pos_label = "F")
plt.plot(fpr,tpr)
plt.show()



# 句法分析
from nltk.parse import stanford

nlp1 = stanford.StanfordParser(r"D:/Software/stanfordnlp/stanford-corenlp-3.6.0.jar",r"D:/Software/stanfordnlp/stanford-corenlp-3.6.0-models.jar",r"D:/Software/stanfordnlp/chinesePCFG.ser.gz")
out = nlp1.parse("代码结束了")
list(out)


