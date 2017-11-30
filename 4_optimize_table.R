library(sqldf)
library(data.table)
library(dplyr)

load('word2.Rda') # 2794579 rows
word2c <- word2 %>% filter(count > 3) %>% arrange(desc(count))
setDT(word2c)
save(word2c, file = "word2c.Rda")

load('word3.Rda') #4,612,510 rows
word3c <- word3 %>% filter(count > 3) %>% arrange(desc(count))
setDT(word3c)
save(word3c, file = "word3c.Rda")

load("word4a.Rda")
load("word4b.Rda")
word4_1 <- word4a %>% filter(count > 3) %>% arrange(desc(count))
word4_2 <- word4b %>% filter(count > 3) %>% arrange(desc(count))
word4c <- rbind(word4_1,word4_2)
word4c <- word4c %>% arrange(desc(count))
setDT(word4c)
save(word4c, file = "word4c.Rda")

load("word5c.Rda")
setDT(word5c)
save(word5c, file = "word5c.Rda")


load("word6.Rda")
word6c <- word6 %>% filter(count > 3) %>% arrange(desc(count))
setDT(word6c)
save(word6c, file = "word6c.Rda")
gc()

load("word7.Rda")
word7c <- word7 %>% filter(count > 3) %>% arrange(desc(count))
setDT(word7c)
save(word7c, file = "word7c.Rda")
gc()
