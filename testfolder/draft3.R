library(rvest)
library(tidyverse)
library(dslabs)
library(dplyr)

url <- "https://en.wikipedia.org/w/index.php?title=Opinion_polling_for_the_United_Kingdom_European_Union_membership_referendum&oldid=896735054"
h <- read_html(url)

tab <- h %>% html_nodes("table")
polls <- tab[[5]] %>% html_table(fill = TRUE)
head(polls)

polls$Remain
head(polls)
polls <- setNames(polls, c("dates", "remain", "leave", "undecided", "lead", "samplesize", "pollster", "poll_type", "notes"))
head(polls)

remains <- str_detect(polls$remain, "%")
as.numeric(str_remove(polls$remain,"%"))

parse_number(polls$remain)

remains
class(polls$remain)
str_remove(polls$remain, "%")/100
sum(remain)
polls$dates
class(polls$dates)
