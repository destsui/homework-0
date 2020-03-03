library(tidyverse)
library(gutenbergr)
library(tidytext)
options(digits = 3)

#search for the book title in the Gutenberg index

book = "Bible"
bookindex <- gutenberg_metadata
booksearch <- str_detect(bookindex$title, book)

#display results, and the total counts

bookindex[which(booksearch),] %>% select(title) 
sum(booksearch, na.rm = TRUE)

#filters search to remove replicates and include only English language.  Can search on other
#parameters such as title, author, etc.

gutenberg_works(str_detect(title, book))

#download based on gutenberg_id number

bookdownload <- gutenberg_download(10)

#view header of book
head(bookdownload)

#unnest words in string into individual rows
RowStringsToWords <- bookdownload  %>% unnest_tokens(words,text, token = "words")

#filtering out common words
words2 <- RowStringsToWords %>% filter (!words %in% stop_words$word)

#filter out numbers
words3 <- words2 %>% filter (!str_detect(words, "\\d"))

#total number of words without common words or digits
length(words3$words)

#words used over 100 times
words3 %>% count(words) %>% filter(n >= 100) %>% arrange(desc(n))

##### Sentiment Analysis

afinn <- get_sentiments("afinn")
1
book_sentiments <- words3 %>% inner_join(afinn, by = c("words" = "word"))

#Count ofPositive words
book_sentiments %>% filter(value > 0) %>% count()

#Table distribution of Sentiment values
table(book_sentiments$value)                      

#top words with a certain sentiment value
book_sentiments %>% filter(value == 4) %>% count(words, sort = TRUE)

