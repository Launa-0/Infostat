library(tidyverse)
library(tidytext)
library(KoNLP)
library(tidyr)
library(tidylo)
library(scales)
library(readr)

raw_no <- readLines("F:/동덕여대/텍마/Textmining_DATA/13대_노태우대통령취임연설문.txt", encoding = "UTF-8")
raw_kim03 <- readLines("F:/동덕여대/텍마/Textmining_DATA/14대_김영삼대통령취임연설문.txt", encoding = "UTF-8")
raw_kim <- readLines("F:/동덕여대/텍마/Textmining_DATA/15대_김대중대통령취임연설문.txt", encoding = "UTF-8")
raw_nomu <- readLines("F:/동덕여대/텍마/Textmining_DATA/16대_노무현대통령취임연설문.txt", encoding = "UTF-8")

#전처리
no <- tibble(value = raw_no) %>% mutate(value=str_replace_all(value, pattern= "[^가-힣]", replacement= " "),value=str_squish(value))
kim03 <- tibble(value = raw_kim03) %>% mutate(value=str_replace_all(value, pattern= "[^가-힣]", replacement= " "),value=str_squish(value))
kim <- tibble(value = raw_kim) %>% mutate(value=str_replace_all(value, pattern= "[^가-힣]", replacement= " "),value=str_squish(value))
nomu <- tibble(value = raw_nomu) %>% mutate(value=str_replace_all(value, pattern= "[^가-힣]", replacement= " "),value=str_squish(value))

#토큰화

no_noun <- no %>% unnest_tokens(input = value,output = word, token = extractNoun)
kim03_noun <- kim03 %>%unnest_tokens(input = value,output = word, token = extractNoun)
kim_noun <- kim %>%unnest_tokens(input = value,output = word, token = extractNoun)
nomu_noun <- nomu %>%unnest_tokens(input = value,output = word, token = extractNoun)

# 단어 빈도 구함
freq_no <- no_noun %>%count(word) %>%filter(str_length(word) > 1) %>%print()
freq_kim03 <- kim03_noun %>%count(word) %>%filter(str_length(word) > 1) %>%print()
freq_kim <- kim_noun %>%count(word) %>%filter(str_length(word) > 1) %>%print()
freq_nomu <- nomu_noun %>%count(word) %>%filter(str_length(word) > 1) %>%print()

# 로그오즈비 구함
freq_noun_no = freq_no %>%
  bind_log_odds(set = president, feature = word, n = n) %>%
  arrange(log_odds_weighted) %>% # 로그오즈비 큰 단어
  print() 

freq_noun_kim03 = freq_kim03 %>%
  bind_log_odds(set = president, feature = word, n = n) %>%
  arrange(log_odds_weighted) %>% # 로그오즈비 큰 단어
  print() 

freq_noun_kim = freq_kim %>%
  bind_log_odds(set = president, feature = word, n = n) %>%
  arrange(log_odds_weighted) %>% # 로그오즈비 큰 단어
  print() 

freq_noun_nomu = freq_nomu %>%
  bind_log_odds(set = president, feature = word, n = n) %>%
  arrange(log_odds_weighted) %>% # 로그오즈비 큰 단어
  print() 

top10_no <- freq_noun_no%>%
  group_by(president) %>%
  slice_max(log_odds_weighted, n = 10, with_ties = F) %>%
  print()

top10_kim03 <- freq_noun_kim03%>%
  group_by(president) %>%
  slice_max(log_odds_weighted, n = 10, with_ties = F) %>%
  print()

top10_kim <- freq_noun_kim%>%
  group_by(president) %>%
  slice_max(log_odds_weighted, n = 10, with_ties = F) %>%
  print()

top10_nomu <- freq_noun_nomu%>%
  group_by(president) %>%
  slice_max(log_odds_weighted, n = 10, with_ties = F) %>%
  print()

library(showtext)
font_add_google(name = "Nanum Gothic", family = "nanumgothic")
showtext_auto()

top10_no %>% ggplot(aes(x = reorder_within(x=word,
                                             by=log_odds_weighted,
                                             within=president),
                          y = log_odds_weighted,
                          fill = president)) +
  geom_col(show.legend = F) +
  coord_flip() +
  facet_wrap(~ president, scales = "free", ncol = 2) +
  scale_x_reordered() +
  labs(x = NULL, y= "ln(OR)") +
  theme(text = element_text(family = "nanumgothic"))

top10_kim03 %>% ggplot(aes(x = reorder_within(x=word,
                                             by=log_odds_weighted,
                                             within=president),
                          y = log_odds_weighted,
                          fill = president)) +
  geom_col(show.legend = F) +
  coord_flip() +
  facet_wrap(~ president, scales = "free", ncol = 2) +
  scale_x_reordered() +
  labs(x = NULL, y= "ln(OR)") +
  theme(text = element_text(family = "nanumgothic"))

top10_kim %>% ggplot(aes(x = reorder_within(x=word,
                                             by=log_odds_weighted,
                                             within=president),
                          y = log_odds_weighted,
                          fill = president)) +
  geom_col(show.legend = F) +
  coord_flip() +
  facet_wrap(~ president, scales = "free", ncol = 2) +
  scale_x_reordered() +
  labs(x = NULL, y= "ln(OR)") +
  theme(text = element_text(family = "nanumgothic"))

top10_nomu %>% ggplot(aes(x = reorder_within(x=word,
                                            by=log_odds_weighted,
                                            within=president),
                         y = log_odds_weighted,
                         fill = president)) +
  geom_col(show.legend = F) +
  coord_flip() +
  facet_wrap(~ president, scales = "free", ncol = 2) +
  scale_x_reordered() +
  labs(x = NULL, y= "ln(OR)") +
  theme(text = element_text(family = "nanumgothic"))


library(tidyverse)
library(tidytext)
library(KoNLP)
library(tidyr)
library(scales)
library(tibble)
library(dplyr)

lee_mb <- readLines("F:/동덕여대/텍마/Textmining_DATA/17대_이명박대통령취임연설문.txt", encoding = "UTF-8") %>%
  paste(collapse = " ") %>%
  as_tibble() %>%
  mutate(president = "이명박")

park_gh <- readLines("F:/동덕여대/텍마/Textmining_DATA/18대_박근혜대통령취임연설문.txt", encoding = "UTF-8") %>%
  paste(collapse = " ") %>%
  as_tibble() %>%
  mutate(president = "박근혜")

moon <- readLines("F:/동덕여대/텍마/Textmining_DATA/19대_문재인대통령취임연설문.txt", encoding = "UTF-8") %>%
  paste(collapse = " ") %>%
  as_tibble() %>%
  mutate(president = "문재인")

yoon_sy <- readLines("F:/동덕여대/텍마/Textmining_DATA/20대_윤석열대통령취임연설문.txt", encoding = "UTF-8") %>%
  paste(collapse = " ") %>%
  as_tibble() %>%
  mutate(president = "윤석열")
bind_data2 <- bind_rows(lee_mb, park_gh, moon, yoon_sy) %>%
  select(president, value) %>%
  mutate(value = str_replace_all(value, "[^가-힣]", " ")) %>%
  mutate(value = str_squish(value)) %>%
  filter(value != "")

noun_data2 <- bind_data2 %>%
  unnest_tokens(input = value, output = word, token = extractNoun)
noun_data2
tfidf <- noun_data2 %>%
  filter(str_length(word) > 1) %>%
  count(president, word, sort = TRUE) %>%
  bind_tf_idf(term = word, document = president, n = n) %>%
  arrange(desc(tf_idf))

plot_tfidf_top10 <- function(tfidf_df, pres) {
  tfidf_df %>%
    filter(president == pres) %>%
    slice_max(tf_idf, n = 10) %>%
    ggplot(aes(x = reorder(word, tf_idf), y = tf_idf)) +
    geom_col(fill = "darkgreen") +
    coord_flip() +
    labs(title = paste(pres, "의 중요 단어 (TF-IDF)"), x = NULL, y = "TF-IDF")
}

plot_tfidf_top10(tfidf, "이명박")
plot_tfidf_top10(tfidf, "박근혜")
plot_tfidf_top10(tfidf, "문재인")
plot_tfidf_top10(tfidf, "윤석열")
