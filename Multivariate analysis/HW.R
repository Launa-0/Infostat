library(tidyverse)
library(factoextra)
library(ggpubr)

IRIS <- read.csv("C:/Users/USER/Downloads/iris.csv")
IRIS <- IRIS %>% mutate(Species=factor(Species))
IRIS <- IRIS %>%
  dplyr::rename(SL=SepalLength, SW=SepalWidth, PL=PetalLength, PW=PetalWidth)

Z<-scale(IRIS[,1:4])

Mprcomp <- prcomp(IRIS[,1:4], center=TRUE, scale=TRUE) # on R
summary(Mprcomp)

# Embedding(Eta)
Eta <- data.frame(Mprcomp$x[,1:3]) # PC scores and yh
head(Eta)

#
library(cluster)

#hclust: 거리 행렬이 있어야만 쓸수 있다
DZ <- dist(Z)
DZ

Mh<-hclust(DZ,method='single') #average, complete, ward, ward2
Mh
names(Mh)
plot(Mh,hang=-1)
rect.hclust(Mh,k=3)

Mhc <- factoextra::hcut(Z, k=3, hf_cunc='hclust', hc_method='single') 
fviz_dend(Mh, k=3, palette='lancet', rect=TRUE) 

yhsing <- Mhc$cluster # (or) cutree(Mhc, k=3)
Sil <- cluster::silhouette(yhsing, dist=DZ)
summary(Sil) 

plot(Sil)

imisc <- which(Sil[, 'sil_width'] < 0) #또는 (1:nrow(IRIS))[Sil[,'sil_width']<0]
imisc

Sil[imisc,] # 불확실한 개체의 실루엣 점수

fviz_silhouette(Mhc) # (or) fviz_silhouette(Sil) 실루엣 객체 시각화

# 군집결과 시각화. single linakge은 실질적으로 2개 군집과 1개 이상치 군집 형성
Eta$yhsing <- factor(yhsing)
ggplot(Eta, aes(x=PC1, y=PC2, col=yhsing, shape=yhsing)) + geom_point()

fviz_cluster(list(data=Z, cluster=yhsing))

Ehsing <- eclust(Z, FUNcluster='hclust', k=3, hc_metric='euclidean', hc_method='single')
fviz_dend(Ehsing)
fviz_silhouette(Ehsing)

DZ <- dist(Z)
Mh <- hclust(DZ, method='ward.D2')
plot(Mh, hang=-1) # K=2 or 3. 동일크기 편향있음
# 군집이 병합되기까지 긴 거리가 필요한 지점에서 K결정(수직선 길이가 긴 지점)
rect.hclust(Mh, k=3)

# 예측값 저장
yhward <- cutree(Mh, k=3) # 숫자로 저장해야 silhouette 가능
# 실루엣으로 군집타당성 확인. hclust는 D를 계산해야하므로 추가 부담없음
Sil <- silhouette(yhward, dist=DZ)
# 군집1 (크기 49, 평균실루엣폭 0.63)
# 군집2 (크기 30, 평균실루엣폭 0.44)


# 군집3 (크기 71, 평균실루엣 0.32)
summary(Sil) 

plot(Sil) # 실루엣 객체(nx3, {cluster, neighbor, sil_width}) 시각화

imisc <- (1:nrow(IRIS))[Sil[,'sil_width']<0] # 오분류 가능성 높은 개체
IRIS[imisc,] # 불확실한 개체

Eta$yhward <- factor(yhward)
ggplot(Eta, aes(x=PC1, y=PC2, col=yhward, shape=yhward)) + geom_point()

#hclust,kmeans -> eclust


Mkm3 <- kmeans(Z, c=3) # Mkm3$size, Mkm3$centers
Mkm3$centers
c(Mkm3$totss, Mkm3$tot.withinss, Mkm3$betweenss) # SStot = SSwithin + SSbetw

# 예측값 저장
yhkm3 <- Mkm3$cluster
# 실루엣으로 군집타당성 확인. kmeans만 사용시 계산해야 함
Sil <- silhouette(yhkm3, dist=DZ)
# 군집1 (크기 47, 평균실루엣폭 0.347)
# 군집2 (크기 50, 평균실루엣폭 0.636)
# 군집3 (크기 53, 평균실루엣폭 0.393)
summary(Sil) # 전체 평균실루엣폭 0.45995

# K결정
#fviz_nbclust: 적절한 k를 구하는 함수
# fviz_nbclust(data, FUNclust:함수이름그대로 사용)
g1 <- fviz_nbclust(Z, kmeans, method='sil') # k vs avgsil
g2 <- fviz_nbclust(Z, kmeans, method='wss') # k vs wss (elbow)
g3 <- fviz_nbclust(Z, kmeans, method='gap') # k vs gap (최대값 1-SE: firstSEmax)
cGap <- clusGap(Z, kmeans, K.max=10) # gap객체 생성
g4 <- fviz_gap_stat(cGap, maxSE=list(method='globalmax', SE.factor=1)) # k vs gap (최대값)
ggpubr::ggarrange(g1, g2, g3, g4, nrow=2, ncol=2)

MK<-kmeans(Z,centers=3)
names(MK)
MK$cluster

fviz_nbclust(Z,kmeans,method='wss')
fviz_nbclust(Z,kmeans,method='sil')
fviz_nbclust(Z,kmeans,method='gap')

Ekm3 <- eclust(Z, 'kmeans', k=3) 
yhkm3<-Ekm3$cluster
fviz_silhouette(Ekm3)

library(mclust)
Mmc<-Mclust(Z)
plot(Mmc,what='BIC')
plot(Mmc,what='class')
plot(Mmc,what='uncertain')
plot(Mmc, what='density')

summary(Mmc, parameters=TRUE) 

Mmc3 <- Mclust(Z, G=3) # 군집수 지정
summary(Mmc3, parameters=TRUE)

plot(Mmc3, what='BIC', main='G vs BIC with modelName') 
plot(Mmc3, what='classification', main='pairs with label') # M$classification
plot(Mmc3, what='uncertainty', main='pairs with uncertainty') # M$uncertainty 
plot(Mmc3, what='density', main='pairs with density') 
plot(Mmc3$uncertainty, type='h')

Mmc3DR <- MclustDR(Mmc3)
summary(Mmc3DR)
plot(Mmc3DR, what='contour')

g1 <- fviz_cluster(Mmc) # PCA plot what='class'와 동일
g2 <- fviz_mclust(Mmc) # what='class'. PCA plot. BIC결정
g3 <- fviz_mclust(Mmc, what='BIC') 
g4 <- fviz_mclust(Mmc, what='uncertain')
ggpubr::ggarrange(g1, g2, g3, g4, nrow=2, ncol=2)

library(meanShiftR)
Mms <- meanShiftR::meanShift(Z) # bandwidth=rep(1, ncol(Z))
yhms <- Mms$assignment
Eta$yhms <- factor(yhms)
ggplot(Eta, aes(x=PC1, y=PC2, col=yhms, shape=yhms)) +
  # geom_point() +
  geom_text(label=yhms) 

library(dbscan) # fpc::dbscan과 다름. fpc 사용
log(nrow(Z)) # MinPts=3
dbscan::kNNdistplot(Z, k=3) # knee => 1.25
abline(h=1.25, lty=2)


set.seed(1234)

Mdb <- fpc::dbscan(Z, eps=1.25, MinPts=3) # 아래 참조
Mdb
yhdb <- Mdb$cluster
Eta$yhdb <- factor(yhdb)
ggplot(Eta, aes(x=PC1, y=PC2, col=yhdb, shape=yhdb)) +
  # geom_point() +
  geom_text(label=yhdb) 

library(Rtsne)
# 중복제거해야 함. iris에 중복있음
ii <- !duplicated(Z)
ZZ <- Z[ii,]
Mtsne <- Rtsne(ZZ, dims=3)
# Embedding
WK <- data.frame(Mtsne$Y, yhkm3=factor(yhkm3[ii]))
head(WK)

library(plotly)
plot_ly(x=~X1, y=~X2, z=~X3, data=WK,
        color=~yhkm3, symbol=~yhkm3, size=1,
        text=~yhkm3)


hclust()
