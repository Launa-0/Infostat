library(dplyr) 
library(stringr)
raw_park <- readLines("F:/동덕여대/텍마/Textmining_DATA/speech_park.txt", encoding = "UTF-8")
park <- raw_park %>% str_squish() %>% as_tibble() %>% filter(value != "") %>% mutate(president = "park")
# 연속된 공백 제거  # as.tibble()과 동일 # 빈 행 제거 # 새로운 변수 park 생성

bind <- bind_rows(park) %>% # bind_rows{dplyr}
  select(president, value) %>%
  mutate(value=str_replace_all(value, pattern= "[^가-힣]", replacement= " "),
         value=str_squish(value)) %>% # 한글만 남기기
  filter(value != "")  # 빈 행 제거
head(bind)
tail(bind)

library(tidytext)
library(KoNLP)
library(ggplot2)

#명사 추출
noun <- bind %>%
  unnest_tokens(input = value,
                output = word,
                token = extractNoun) %>% print()  #띄어쓰기 기준 토큰화

#명사추출
freq_noun <- noun %>%
  filter(str_length(word) > 1) %>% # 두 글자 이상 추출
  count(president, word, sort=TRUE) %>% # 연설문 및 단어 별 정렬 후 빈도 계산
  print() 

top20 <- freq_noun %>%
  group_by(president) %>% # president별로 분리
  slice_max(n, n = 20) %>% print() # n의 값에 대해 집단 별 상위 10개 추출

top20 %>% ggplot(aes(x = reorder(word, n), y = n, fill = president)) +
  geom_col() +
  coord_flip() +
  facet_wrap(~ president) + # y축이 하나로 통일됨
  labs(x="단어(명사)", y="단어 수")

library(showtext)
font_add_google(name = "Nanum Gothic", family = "nanumgothic")

top20 %>% ggplot(aes(x = reorder(word, n), y = n, fill = president)) +
  geom_col() +
  coord_flip() +
  facet_wrap(~ president) + # y축이 하나로 통일됨
  labs(x="단어(명사)", y="단어 수") +
  theme(text = element_text(family = "nanumgothic"))

showtext_auto()
library(ggwordcloud)
freq_noun %>%
  ggplot(aes(label = word, size = n,
             color = factor(sample.int(n=10,
                                       size=NROW(freq_noun2), replace = TRUE)))) + # 색 지정
  facet_wrap(~ president, scales = "free", ncol = 2) +
  geom_text_wordcloud(seed = 1234, family = "nanumgothic") +
  scale_radius(limits = c(10, NA), # 최소, 최대 단어 빈도 지정
               range = c(3, 15)) + # 글자 크기 범위 지정 최소 3, 최대 15
  theme_minimal() 

park2<-raw_park %>% str_squish()
text_tbl <- tibble(text = park2)
sentences <- bind_rows(park) %>% #문장 기준 토큰 
  unnest_tokens(input = value, output = sentence, token = "sentences") %>%print()
speech_sentence %>%
  filter(president == "park" & str_detect(string=sentence, pattern="경제제")) %>%
  print(n=Inf)
