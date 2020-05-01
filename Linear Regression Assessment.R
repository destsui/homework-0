library(dslabs)
library(tidyverse)
library(ggplot2)
library(broom)
library(Lahman)

Teams_small <- Teams %>% 
  filter(yearID %in% 1961:2001) %>% 
  mutate(avg_attendance = attendance/G,
         BB = BB / G, 
         singles = (H - X2B - X3B - HR) / G, 
         doubles = X2B / G, 
         triples = X3B / G, 
         HR = HR / G,
         R = R / G)

#Get Regression Coefficients

Teams_small %>% 
  lm(avg_attendance ~ R, data = .) %>%
  tidy()

Teams_small %>% 
  lm(avg_attendance ~ HR, data = .) %>%
  tidy()

Teams_small %>% 
  lm(avg_attendance ~ W, data = .) %>%
  tidy()

Teams_small %>% 
  lm(avg_attendance ~ W, data = .) %>%
  tidy()

Teams_small %>% 
  lm(avg_attendance ~ yearID, data = .) %>%
  tidy()

#Get Correlation Coefficients

Teams_small %>% 
  summarize(r = cor(W, R)) %>% pull(r)

Teams_small %>% 
  summarize(r = cor(W, HR)) %>% pull(r)

#Create Stratas and get regression by strata

Teams_small_strata <- Teams_small %>% 
  mutate(strata_w = round(W/10)) %>%
  filter(strata_w >= 5 & strata_w <= 10)

Teams_small_strata %>% 
  filter(strata_w == 8) %>%
  count()

Strata_slopes <- Teams_small_strata %>%
  group_by(strata_w) %>%
  do(tidy(lm(avg_attendance~HR, data = .))) %>%
  ungroup() 
  
#Find Strata with the largest regression slope

Strata_slopes %>%
  filter(term == "HR") %>%
  arrange(desc(term))

#plot with strata HR 5, add best fit curve

Teams_small_strata %>% 
  filter(strata_w == 5) %>%
  ggplot(aes(HR, avg_attendance)) + geom_point() + geom_smooth(method = "lm")
  

#### MULTIVARIATE REGRESSSION

Team_small_multi <- Teams_small %>%
  do(tidy(lm(avg_attendance ~ R + HR + W + yearID, data = .)))

model <- lm(avg_attendance ~ R + HR + W + yearID, data = Teams_small)

#Predict average attendance with new model

R <-5
HR <- 1.2
W <-80
yearID <- 2002

df <- data.frame(R, HR, W, yearID)

predict(model,newdata = df)

#Compare predicated models attendance with actual attendance

Predicted_teams <- Teams %>%
  filter(yearID == '2002') %>%
  mutate(predict_attendance = predict(model, newdata = .))

#Correlation between predicted attendance and actual attendance in 2002

Teams2002 <- Teams %>%
  filter(yearID %in% 2002) %>% 
  mutate(avg_attendance = attendance/G,
         BB = BB / G, 
         singles = (H - X2B - X3B - HR) / G, 
         doubles = X2B / G, 
         triples = X3B / G, 
         HR = HR / G,
         R = R / G) %>%
  mutate(predicted_attendance = predict(model, newdata = .))

Teams2002 %>% 
  summarize(r = cor(attendance, predicted_attendance))

#Plotting predicted vs actaul attendance

Teams2002 %>%
  ggplot(aes(attendance, predicted_attendance)) + geom_point() +geom_smooth(method = "lm")


