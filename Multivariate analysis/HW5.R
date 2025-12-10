# 거리행렬 입력
eurocities <- read.csv(text='
city,berlin,london,madrid,moscow,paris,rome,stockhlom,warsaw
berlin,0,NA,NA,NA,NA,NA,NA,NA
london,583,0,NA,NA,NA,NA,NA,NA
madrid,1165,785,0,NA,NA,NA,NA,NA
moscow,1006,1564,2147,0,NA,NA,NA,NA
paris,548,214,655,1554,0,NA,NA,NA
rome,737,895,851,1483,690,0,NA,NA
stockholm,528,942,1653,716,1003,1245,0,NA
warsaw,322,905,1427,721,852,820,494,0
')
# dist로 변환
Deuro <- stats::as.dist(eurocities[,-1], diag=TRUE)
Deuro

library(MASS)
# configuration, Coordinate 추출/시각화 
Mpcoa  <- cmdscale(Deuro, k=2, eig=TRUE) # x.ret=TRUE면 B(doubly centered dist)반환 
Mpcoa

Eta <- Mpcoa$points
plot(Eta, main='CMDS in k=2')
abline(v=0, h=0, lty=2)
text(Eta, label=rownames(Eta), pos=4)

Msammon <- sammon(Deuro)

plot(Msammon$points, main='Sammon mapping in k=2')
abline(v=0, h=0, lty=2)
text(Msammon$points, labels = rownames(Msammon$points), pos=2)

Spcoa <- Shepard(Deuro, x=Mpcoa$points)
Spcoa

plot(Spcoa, xlab='Input dist', ylab='Output dist by PcoA')
lines(Spcoa$x, Spcoa$yf, type = 'S') # tmp$yf는  isotonic regression 추정값

cor(Spcoa$x, Spcoa$y)

cor(Spcoa$x, Spcoa$y, method='spearman')

Ssammon <- Shepard(Deuro, x=Msammon$points)
Ssammon

plot(Ssammon, xlab='Input dist', ylab='Output dist by Sammon mapping')
lines(Ssammon$x, Ssammon$yf, type = 'S') # $yf는  isotonic regression 추정값 

cor(Ssammon$x, Ssammon$y)

cor(Ssammon$x, Ssammon$y, method='spearman')

Mpcoa$eig

# GOF1 확인 (주의:아이겐값의 절대값을 사용하므로 음수부분은 무시하고 양수부분만 볼 것) 
eigval <- abs(Mpcoa$eig) 
prop   <- eigval/sum(eigval) 
cumul  <- cumsum(eigval)/sum(eigval)
round(data.frame(eigval, prop, cumul),6)

# GOF2 확인 (주의:아이겐값의 절대값을 사용하므로 음수부분은 무시하고 양수부분만 볼 것)
eigval <- ifelse(Mpcoa$eig>0, Mpcoa$eig, 0) 
prop   <- eigval/sum(eigval) 
cumul  <- cumsum(eigval)/sum(eigval)
round(data.frame(eigval, prop, cumul),6)

DF <- read.csv(text='
sports,box,basket,golf,swim,ski,baseball,pingpong,hockey,handball,track,bowling,tennis,football
box,0,,,,,,,,,,,,
basket,3.85,0,,,,,,,,,,,
golf,4.33,4.88,0,,,,,,,,,,
swim,3.8,4.05,3.73,0,,,,,,,,,
ski,3.81,3.81,3.56,2.84,0,,,,,,,,
baseball,4.12,3.15,3.83,4.16,3.6,0,,,,,,,
pingpong,3.74,3.56,3.61,3.67,2.72,3.41,0,,,,,,
hockey,3.85,2.58,5.11,4.02,4.17,3.49,4.27,0,,,,,
handball,3.41,3.24,3.92,3.25,2.8,3.34,2.58,3.52,0,,,,
track,3.81,3.36,3.88,3.2,2.84,3.37,3.06,3.72,2.75,0,,,
bowling,4.07,4.23,2.72,3.75,2.89,3.32,2.87,4.58,3.13,3.26,0,,
tennis,3.49,3.32,3.59,3.19,2.82,3.25,2.54,3.58,2.33,2.72,2.85,0,
football,3.86,2.51,5.15,4.38,4.41,3.43,4.35,2.2,3.68,3.84,4.67,3.69,0
')

# DF를 dist객체로 변환
Dsports <- stats::as.dist(DF[,-1], diag=TRUE)
Dsports

library(MASS)
# Nonmetric MDS
Misomds <- isoMDS(Dsports, k=2)

Misomds$stress # 최종 스트레스(%) = 8.388% = 0.08388 => Fair, Good

Misomds$points  # points[,1], points[,2]

plot(Misomds$points, pch=1, xlab='Dim 1',ylab='Dim 2')
abline(v=0,h=0,lty=2)   # 참조선 추가
text(Misomds$points, pos=3,labels=rownames(Misomds$points))

# Shepard Nonmetric MDS
Sisomds <- Shepard(Dsports, x=Misomds$points)
# Mshepard$x : (input) distances 
# Mshepard$y : (output) distances 

# observed vs fitted dissimilarity
plot(Sisomds, xlab='Input dissimil', ylab='Output dissimil by isomds')
lines(Sisomds$x, Sisomds$yf, type='S') # $yf는  isotonic regression 추정값 

cor(Sisomds$x, Sisomds$y)

cor(Sisomds$x, Sisomds$y, method='spearman')

Msammon <- sammon(Dsports)

plot(Msammon$points)
text(Msammon$points, labels = rownames(Msammon$points), pos=2)
abline(v=0, h=0, lty=2)


# Shepard Nonmetric MDS
Ssammon <- Shepard(Dsports, x=Msammon$points)

plot(Ssammon, xlab='Input dissimil', ylab='Output dissimil by Sammon mapping(MDS)')
lines(Ssammon$x, Ssammon$yf, type='S') # $yf는  isotonic regression 추정값  

cor(Ssammon$x, Ssammon$y)
cor(Ssammon$x, Ssammon$y, method='spearman')

# STEP1: 군집수 결정
library(NbClust)
library(factoextra) # fviz_nbclust