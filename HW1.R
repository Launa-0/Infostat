#직사각행렬을 복원
X<-matrix(c(2,3,
            3,2,
            7,1), byrow=TRUE, nc=2)
svdX <- svd(X)
U<-svdX$u
D<-diag(svdX$d)
V<-svdX$v

X1<-D[1,1] * U[,1] %*% t(V[,1])
X2 <- D[2,2] * U[,2] %*% t(V[,2])
cbind(X, X1, X2, X1+X2)

#정사각행렬을 복원
XTX <- t(X) %*% X
eigXTX <- eigen(XTX)
L <- diag(eigXTX$values)
V <- eigXTX$vectors

XTX1  <- L[1,1] * V[,1] %*% t(V[,1])
XTX2 <- L[2,2] * V[,2] %*% t(V[,2])
cbind(XTX, XTX1, XTX2, XTX1+XTX2)

#iris 주성분 분석
#4차원 데이터를 2차원이나 3차원 데이터로
library(tidyverse)
DF <- read.csv("C:/Users/USER/Downloads/iris.csv")
DF <- DF %>% rename (SL= SepalLength, SW=  SepalWidth, PL= PetalLength, PW= PetalWidth)
DF$Species <- factor(case_match(DF$Species, 'setosa'~'set','versicolor'~'vers','virginica'~'virg'))
head(DF)

#prcomp는 비지도학습, 변수들을 다 쓰면 된다, center True는 중심화시키라, scale True는 정규화
MprcompZ <- prcomp(~SL+SW+PL+PW, data=DF, center=  TRUE, scale= TRUE)
MprcompZ
#람다1 = 1.7의 제곱, 람다2= 0.9의 제곱
#prop은 분산 설명량
summary(MprcompZ)
plot(MprcompZ)
biplot(MprcompZ)

DF<-read.csv("C:/Users/USER/Downloads/crime.csv")
head(DF)
X<- DF %>% dplyr :: select(murder,rape,robbery, assault,burglary, larceny, auto)
row.names(X) <-DF$state
head(X)
MprcompZ <- prcomp(X, center=TRUE, scale=TRUE)
summary(MprcompZ)
plot(MprcompZ)
MprcompZ$rotation
#v1: 평균 비 범죄율
#v2: 재산범과 폭력범의 차이
MprcompZ$X
plot.MP