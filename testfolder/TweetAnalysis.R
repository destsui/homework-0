library(tidyverse)
library(ggplot2)
library(lubridate)
library(tidyr)
library(scales)
library(tidytext)
install.packages("textdata")
library(textdata)
set.seed(1)

library(dslabs)
data("trump_tweets")

campaign_tweets <- trump_tweets %>% 
  extract(source, "source", "Twitter for (.*)") %>%
  filter(source %in% c("Android", "iPhone") &
           created_at >= ymd("2015-06-17") & 
           created_at < ymd("2016-11-08")) %>%
  filter(!is_retweet) %>%
  arrange(created_at)

pattern <- "([^A-Za-z\\d#@']|'(?![A-Za-z\\d#@]))"

tweet_words <- campaign_tweets %>% 
  mutate(text = str_replace_all(text, "https://t.co/[A-Za-z\\d]+|&amp;", ""))  %>%
  unnest_tokens(word, text, token = "regex", pattern = pattern) %>%
  filter(!word %in% stop_words$word &
           !str_detect(word, "^\\d+$")) %>%
  mutate(word = str_replace(word, "^'", ""))

head(tweet_words)

nrc <- get_sentiments("nrc") %>%
  select(word, sentiment)

sentiments
get_sentiments("nrc")
1
