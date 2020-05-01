library(tidyverse)
library(pdftools)
library(stringr)
options(digits = 3)    # report 3 significant digits

fn <- system.file("extdata", "RD-Mortality-Report_2015-18-180531.pdf", package="dslabs")
system("cmd.exe", input = paste("start", fn))

#Extract and Trim PDF file.  Split rows by \n
txt <- pdf_text(fn)
x <- str_split(txt[9],"\n")
class(x)
length(x)
x
s <- x[[1]]
class(s)
s <- str_trim(s)

#Find Header Row
s[which(str_detect(s, "^SEP"))]

#Split up the header row to columns
header_index <- s[[2]]
tmp <- str_split(header_index, "\\s+", simplify = TRUE)
month <- tmp[1]
header <- tmp[-1]
tail_index <- s[[35]]

#Remove rows before header, after tail, and with only one digit number
n <- str_count(s, "\\d+")
sum(n==1)
which(n==1)
s2 <- s[-c(1,2,6,9,35,36,37,38,39,40)]

#Remove all text not a digit or space
s3 <- str_remove_all(s2, "[^\\d\\s]")

#Convert to dataframe
s4 <- str_split_fixed(s3, "\\s+", n=6)[,1:5]

tab <- s4 %>% as_data_frame() %>% setNames(c("day",header)) %>% mutate_all(as.numeric)
tab <- tab %>% gather(year, deaths, -day) %>% mutate(deaths = as.numeric(deaths))

#Graph it
tab  %>% filter(year<2018) %>% ggplot(aes(day,deaths, color = year)) + geom_line() +geom_point()


                