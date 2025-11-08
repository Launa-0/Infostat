library(tidyverse)    # readr, dplyr, stringr 등  
library(tidytext)     # unnest_tokens, cast_dtm  
library(KoNLP)        # extractNoun  
install.packages("topicmodels", dependencies = TRUE) 
library(topicmodels)
# 1) devtools 설치
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}

# 2) GitHub에서 ldatuning 설치
devtools::install_github("nikita-moor/ldatuning")
library(ldatuning)    # FindTopicsNumber  
library(ggplot2)      # 시각화  

roh <- read_csv("F:/동덕여대/텍마/Textmining_DATA/speeches_roh.csv")  


# 문장 기준 토큰화
sentences <- roh %>%
  unnest_tokens(input = content,
                output = sentence,
                token = "sentences")
sentences

# 1) 한글만 남기고 공백 정리
clean_sent <- sentences %>%
  mutate(sentence = str_replace_all(sentence, "[^가-힣]", " "),
         sentence = str_squish(sentence))
clean_sent

# 2) 명사 추출
nouns <- clean_sent %>%
  unnest_tokens(input  = sentence,
                output = word,
                token  = extractNoun,
                drop   = FALSE) %>%
  filter(str_length(word) > 1)
nouns 

freq <- nouns %>%distinct(document = row_number(), word, .keep_all = TRUE) %>%  # 문서 내 중복 제거
  count(word, sort = TRUE)

low_freq <- freq %>%filter(n <= 100)

stopword <- c("들이","하다","하게","하면","해서","이번","하네",
              "해요","이것","니들","하기","하지","한거","해주",
              "그것","어디","여기","까지","이거","하신","만큼")

clean_terms <- low_freq %>%
  filter(!word %in% stopword)

# 1) 문서별 단어 빈도
count_word_doc <- nouns %>%
  filter(word %in% clean_terms$word) %>%
  count(document = row_number(), word, sort = TRUE)

# 2) DTM 생성
dtm <- count_word_doc %>%
  cast_dtm(document, term = word, value = n)

if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}

# 2) GitHub에서 ldatuning 설치
devtools::install_github("nikita-moor/ldatuning")

# 3) 로드
library(ldatuning)

# 이제야 FindTopicsNumber() 사용 가능
results <- FindTopicsNumber(
  dtm,
  topics       = 2:20,
  metrics      = c("Griffiths2004"),
  method       = "Gibbs",
  control      = list(seed = 1234),
  mc.cores     = 1,
  verbose      = TRUE
)

# 여러 토픽 수에 대해 모델 평가
models <- FindTopicsNumber(dtm,
                           topics       = 2:20,
                           metrics      = c("Griffiths2004"),
                           method       = "Gibbs",
                           control      = list(seed = 1234),
                           return_models= TRUE)

# 결과 확인
FindTopicsNumber_plot(models)

optimal_9 <- models %>%
  filter(topics == 9) %>%
  pull(LDA_model) %>%
  .[[1]]

# β 추출
term_topic <- tidy(optimal_9, matrix = "beta")

# 상위 10개 단어
top_terms <- term_topic %>%
  group_by(topic) %>%
  slice_max(beta, n = 10, with_ties = FALSE)

# 시각화
ggplot(top_terms, aes(x = reorder_within(term, beta, topic),
                      y = beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free_y") +
  coord_flip() +
  scale_x_reordered() +
  labs(x = NULL, y = "Beta") 

# γ 추출
doc_topic <- tidy(optimal_9, matrix = "gamma") %>%
  mutate(document = as.integer(document))

# 문서별 최다 γ 토픽
doc_class <- doc_topic %>%
  group_by(document) %>%
  slice_max(gamma, n = 1, with_ties = FALSE)

doc_class %>%
  count(topic, name = "doc_count") %>%
  arrange(desc(doc_count))

# 1) 최대 문서 토픽 번호
top_topic <- doc_class %>%
  count(topic) %>%
  slice_max(n, n = 1) %>%
  pull(topic)

# 2) 해당 토픽 문서와 γ 값 결합
roh_with_topic <- roh %>%
  mutate(document = row_number()) %>%
  inner_join(doc_class, by = "document")

# 3) γ 내림차순 정렬 후 내용 출력
roh_with_topic %>%
  filter(topic == top_topic) %>%
  arrange(desc(gamma)) %>%
  select(document, gamma, content) %>%
  print(n = 20)
roh_with_topic 
