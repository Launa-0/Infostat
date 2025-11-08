rm(list=ls())
library(tidyverse)
library(lsa)
library(LSAfun)
library(wordcloud)
library(plotrix)
library(tm)

#예제 3: mindscale
#X는 n*p 행렬 = UDV를 X^로 근사= UDV' (n*m)(m*m)(m*p)/ m은 토픽의 수
DC <- read.csv("C:/Users/USER/Downloads/News-wikipedia-DFE.csv")
dim(DC)
head(DC)
ctrl <- list(removeNumbers=TRUE, #숫자 없애기
             removePunctuation=TRUE,  #구둣점 없애기
             wordLengths=c(3, Inf), #3글자 미만  지우기
             stopwords=stopwords('en'))  # stopwords=c('바보','어디')->부정어, 조사, a/an/the와 같은

TD <- TermDocumentMatrix(Corpus(VectorSource(DC$newdescp)), control=ctrl)
c(nTerms(TD), nDocs(TD))

TD #1억 칸중  3만개만 사용
library(slam)
wrdfrq <- sort(row_sums(TD), decreasing=TRUE)
wrd1000 <- wrdfrq[1:1000]
wordcloud(names(wrd1000), wrd1000, min.freq=500)

TDM <- as.matrix(TD[names(wrd1000),])
TDM <- lw_bintf(TDM) * gw_idf(TDM)  # TFIDF로 변환
Mlsa <- lsa(TDM, dims=30) 
c(dim(Mlsa$tk), length(Mlsa$sk), dim(Mlsa$dk)) 

library(GPArotation)
#성분= 잠재변수
#성분의 해석을 쉽게 하는게 목적 => 계수들이 0이 많이 나오면 좋다
Urot <- Varimax(Mlsa$tk)$loadings #주성분 게수를 저장
colnames(Urot) <- paste0('topic', sprintf('%02d', 1:30))
round(Urot[1:5, 1:8], 2) #-0.03said+0.00ppl+.....
for(topic in 1:ncol(Urot)){
  cat('Topic ', topic, '\n')
  imp <- order(abs(Urot[,topic]), decreasing=TRUE)
  print(Urot[imp[1:5], topic])
}

Urot <- as_tibble(Urot, rownames='term')
tidy_lsa <- pivot_longer(Urot, 
                         cols=starts_with('topic'), 
                         names_to='topic', 
                         values_to='Uir')

# 계수절대값 크기순 5개 단어
top_terms <- tidy_lsa %>% 
  group_by(topic) %>% 
  top_n(5, abs(Uir)) %>% 
  ungroup() %>% 
  arrange(topic, -abs(Uir))
top_terms
#표가 나왔을때 뭘 봐야할지 알아야 한다

tail(top_terms)

top_terms %>% filter(grepl('topic0', topic)) %>%
  mutate(term = reorder(term, Uir)) %>%
  group_by(topic, term) %>%
  arrange(desc(Uir)) %>%
  ungroup() %>%
  mutate(term=factor(paste(term, topic, sep='__'), 
                     levels=rev(paste(term, topic, sep='__')))) %>%
  ggplot(aes(term, Uir, fill=as.factor(topic))) +
  geom_col(show.legend = FALSE) +
  coord_flip() +
  scale_x_discrete(labels = function(x) gsub('__.+$', '', x)) +
  labs(title='Top words in LSA topic 01-09', x=NULL, y=expression(Uir)) +
  facet_wrap(~ topic, ncol=3, scales='free')
#안의 계수가 음수가 안나오게

A <- TDM %*% Mlsa$dk 
# cosine(t(A)) : A0 <- normalize(A, 1); Rtrm <- A0 %*% t(A0) 와 동일
Rtrm <- lsa::cosine(t(A))   #코싸인 유사도
heatmap(Rtrm[1:20, 1:20]) #1000*1000 행렬

# 유사단어: korea와 유사한 단어 5개
sort(Rtrm['korea',], decreasing=TRUE)[1:5]
LSAfun::Cosine('korea', 'missile', tvectors=TDMh)
LSAfun::multicos(c('hamas','israel','gaza'), tvectors=TDMh)
# 특정단어의 유사어 조회 및 시각화 
LSAfun::neighbors('korea', n=10,  tvectors=TDMh)

LSAfun::plot_neighbors(
  'korea',            # 조회어 
  n = 10,             # number of neighbors
  tvectors = TDMh,    # matrix space
  method   = 'MDS',   # PCA or MDS (차원축소)
  dims = 2)           # number of dimensions
#doc space: 기사간 유사도 계산
B <- t(Mlsa$tk) %*% TDM
# cosine(B) : B0 <- normalize(B, 2); Rdoc <- t(B0) %*% B0 와 동일
Rdoc <- lsa::cosine(B)   
heatmap(Rdoc[1:30, 1:30])

# 유사문서: (1,18), (72,99)
str_sub(DC$newdescp[1], 1, 100)
str_sub(DC$newdescp[18], 1, 100)

#문서간 유사도
Rdoc[1,18] #상관계수와 유사도는 다르다

