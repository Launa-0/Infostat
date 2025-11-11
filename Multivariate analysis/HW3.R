library(tidyverse)
library(corrplot)

DF<-read_csv("C:/Users/USER/Downloads/survey5.csv",na=".")
X<-DF%>%select(starts_with('x'))
apply(is.na(X),2,sum)

X<-na.omit(X)
dim(X)

R<-cor(X)
corrplot(R,method='ellipse')

X<-X%>%mutate(x04=5-x04)
R<-cor(X)
corrplot(R,method='ellipse')

##크론바흐 알파 0.6이상
library(psych)
alpha(X%>%select(x01:x06))
alpha(X%>%select(x07:x12))
alpha(X%>%select(x13:x18))
#안좋은 질문= 신뢰도 낮은 질문
#습관(1~7)=x02 (음식 천천히)
#청결(8~...)=x08 (손톱발톱)
#사고=x13,,x14 (신호등)/(난간)

##요인
KMO(X)
cortest.bartlett(R,n=nrow(X))

#회전전
#주성분 분석을 통해 요인 추출
Mpca<-principal(X,nfactors = 3,rotate='none')
Mpca

#h2: 공통성분산/ u2: 유일성 분산
#h가 클수록 좋음
Mpc<-principal(X,nfactors = 3) #,rotate='varimax'
Mpc

biplot(Mpc)
print(Mpc$loadings,cutoff = 0.5)

fa.diagram(Mpc,simple=FALSE,cut=0.3,digit=3)
