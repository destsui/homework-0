library(dslabs)
library(readr)
library(readxl)
library(tidyverse)
install.packages("Lahman")
library(Lahman)
Batting

top <- Batting %>% filter(yearID==2016) %>% arrange(desc(HR)) %>% slice(1:10)
top

top %>% as_tibble()

Master %>% as_tibble()

top %>% left_join(Master) %>% select(playerID, nameFirst, nameLast, HR)

head(Salaries)

head(AwardsPlayers)
top %>% left_join(AwardsPlayers) %>% select(playerID, yearID, HR, awardID)
head(AwardsPlayers)
AwardsPlayers
tmp <- AwardsPlayers %>% arrange(desc(playerID)) %>% filter(yearID == 2016)
tmp <- spread(tmp, key = awardID, value = awardID) 
tmp <- spread(tmp, key = lgID, value = lgID)
tmp <- spread(tmp, key = notes, value = notes)      
tmp
head(AwardsPlayers)
tmp <- unique(AwardsPlayers) 
head(tmp)
nrow(AwardsPlayers)

players <- distinct(AwardsPlayers, playerID, .keep_all=TRUE) %>% filter(yearID ==2016) %>% select(playerID, yearID)
players
setdiff(players, top)
head(players)
top <- top %>% select(playerID, yearID)

intersect(players, top)

players <- AwardsPlayers %>% filter(yearID==2016) %>% distinct(playerID, .keep_all=TRUE) %>% select(playerID, yearID)

distinct(AwardsPlayers, playerID, .keep_all=TRUE) %>% filter(yearID ==2016) %>% select(playerID, yearID)
