library(tidyverse)
library(readr)
library(tidytext)
library(textdata)
library(ggplot2)

bts <- read_csv("F:/동덕여대/텍마/Textmining_DATA/news_comment_BTS.csv")

# 행 번호 추가
bts <- bts %>%
  mutate(id = row_number()) %>%
  filter(!is.na(reply)) # NA 제거

# 감정 사전 로드
sent_dic <- read_delim('F:/동덕여대/텍마/Textmining_DATA/SentiWord_Dict.txt', delim= '\t', col_names=c( "word", "polarity"))
# 댓글 토큰화
word_comment <- bts %>%
  unnest_tokens(input = reply, output = word, token = "words")

# 감정 점수 부여
word_score <- word_comment %>%
  left_join(sent_dic, by = c("word" = "word")) %>%
  filter(!is.na(polarity)) %>%
  group_by(id) %>%
  summarise(sentiment = sum(polarity)) %>%
  right_join(bts, by = "id") %>%
  mutate(sentiment = ifelse(is.na(sentiment), 0, sentiment),
         label = ifelse(sentiment > 0, "긍정", 
                        ifelse(sentiment < 0, "부정", "중립")))

word_score %>%
  count(label) %>%
  ggplot(aes(x = label, y = n, fill = label)) +
  geom_col() +
  labs(title = "감정 범주별 댓글 수", x = "감정", y = "댓글 수")

word_comment_score <- word_comment %>%
  left_join(word_score %>% select(id, label), by = "id") %>%
  count(label, word, sort = TRUE)

word_comment_score %>% 
  group_by(label) %>%
  slice_max(n, n = 10) # 상위 10개 단어

# 긍정 vs 부정만 필터링
log_rr_input <- word_comment_score %>%
  filter(label %in% c("긍정", "부정")) %>%
  group_by(label) %>%
  mutate(total = sum(n)) %>%
  ungroup()

# 단어별 로그 RR 계산
log_rr <- log_rr_input %>%
  pivot_wider(names_from = label, values_from = n, values_fill = 1) %>%
  mutate(rr_pos = log2((긍정 / sum(긍정)) / (부정 / sum(부정))),
         rr_neg = log2((부정 / sum(부정)) / (긍정 / sum(긍정))))

# 상위 단어 10개씩 추출
top_pos <- log_rr %>% slice_max(rr_pos, n = 10)
top_neg <- log_rr %>% slice_max(rr_neg, n = 10)

top_pos %>%
  ggplot(aes(x = reorder(word, rr_pos), y = rr_pos)) +
  geom_col(fill = "skyblue") +
  coord_flip() +
  labs(title = "긍정 댓글에 자주 사용된 단어", x = "단어", y = "로그 RR")

top_neg %>%
  ggplot(aes(x = reorder(word, rr_neg), y = rr_neg)) +
  geom_col(fill = "salmon") +
  coord_flip() +
  labs(title = "부정 댓글에 자주 사용된 단어", x = "단어", y = "로그 RR")

# 긍정 댓글에서 가장 많이 나온 단어
top_word <- word_comment_score %>%
  filter(label == "긍정") %>%
  slice_max(n, n = 1) %>%
  pull(word)

top_word 

# 해당 단어 포함 긍정 댓글 중 감정 점수 높은 순 정렬
word_score %>%
  filter(label == "긍정", str_detect(reply, top_word)) %>%
  arrange(desc(sentiment)) %>%
  select(sentiment, reply) %>%
  head(10)
