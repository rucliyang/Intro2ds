
import os
os.chdir("D:\\nonstruct")


# 读音频文件
import librosa
x, sr = librosa.load("beibei.mp3", sr = 44100, mono = False)
x.shape
sr


# 绘图
import matplotlib.pyplot as plt
import librosa.display
librosa.display.waveplot(x, sr = sr)
plt.show()


# 写音频文件
librosa.output.write_wav("beibei.wav", x, sr)


# 短时傅里叶变换
d1 = librosa.stft(x, n_fft = 512)


# 提取LFCC
m1 = librosa.feature.mfcc(x, sr, n_mfcc=12)
m1.shape

librosa.display.specshow(m1, sr = sr, x_axis = "time")
plt.show()












