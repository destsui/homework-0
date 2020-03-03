library(rvest)
library(tidyverse)
library(dslabs)
library(dplyr)

url <- "http://en.wikipedia.org/wiki/Murder_in_the_United_States_by_state"
h <- read_html(url)
class(h)
h

tab <- h %>% html_nodes("table")
tab <- tab[[2]]
tab <- tab %>% html_table
class(tab)

tab <- tab %>% setNames(c("state", "popultion", "total", "murders", "gun_murders", "gun_ownership", "total_rate", "murder_rate", "gun_murderrate"))
head(tab)

url2 <- "https://web.archive.org/web/20181024132313/http://www.stevetheump.com/Payrolls.htm"
h <- read_html(url2)
nodes <- h %>% html_nodes("table") 
nodes
html_text(nodes[[19]])
tab_1 <- html_table(nodes[[10]])
tab_2 <- html_table(nodes[[19]])
tab_1 <- tab_1 %>% select(2:4)
tab_2 <- tab_2[-1,]
tab_2 <- tab_2 %>% setNames(c("Team", "Payroll", "Average"))
class(tab_1)
tab_1
tab_2
full_join(tab_1, tab_2, by = "Team")
