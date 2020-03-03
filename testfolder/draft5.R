data(brexit_polls)
head(brexit_polls)

library(lubridate)
library(tidyr)

month = month(brexit_polls$startdate)
month4 <- month == 4
month4
sum(month4)
sum(round_date(brexit_polls$enddate, unit="weeks") == "2016-06-12")
count(weekdays(brexit_polls$enddate))
?count

data(movielens)
names(movielens)
head(movielens$timestamp)
movielens$hour <- hour(as_datetime(movielens$timestamp))
movielens
head(movielens)
hour <- movielens %>% group_by(hour) %>% summarise(n())
hour
which.max(hour[2,])
max(hour$`n()`)
which(hour$`n()`==7011)
hour[21,]
