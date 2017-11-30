library(sqldf)
library(data.table)
library(dplyr)

gc(reset=T)
answer <- searchword(wordinput)
head(answer,5) 
gc()

### comparing dplyr and sqldf 

load('word3c.Rda')
userinput = "love"
class(word3c)
system.time (result <- filter(word3c, grepl("^love", word3c$word) )) # data table 3-ngram 3.41sec  3.41sec
rm(result)
setDF(word3c)
gc()
class(word3c)
system.time (result <- filter(word3c, grepl("^love", word3c$word) )) #$data frame 3.55sec  3.37sec 1416902 rows
rm(result)
setDT(word3c)
gc()
class(word3c)
system.time(result <- sqldf("select * from word3c where word like  'love%'")) #data table 1.43sec  1.25sec
rm(result)
setDF(word3c)
gc()
class(word3c)
system.time(result <- sqldf("select * from word3c where word like  'love%'")) #data frame 1.30sec  1.25sec


### line below is what was used for testing the the next word query

load("word2a.Rda")
load("word2b.Rda")
load("word3a.Rda")
load("word3b.Rda")
load("word4a.Rda")
load("word4b.Rda")
load("word5a.Rda")
load("word5b.Rda")



searchword <- function(userinput)
{    
###word2
wordtable <- data.frame(word=character(),count=double())
startTime <- Sys.time()
result1 <-sqldf(paste0("select * from word2a where word like  '",userinput , "%'"))
if (length(result1[,1]) > 0 )
{
    print(result1[1,1]) 
    wordtable <- result1
    
} 
result2 <- sqldf(paste0("select * from word2b where word like  '",userinput , "%'"))
if (length(result2[,1]) > 0)
    {
        print(result2[1,1]) 
        wordtable <- result2
        
    }

##word3

result3 <- sqldf(paste0("select * from word3a where word like  '",userinput , "%'"))
if (length(result3[,1]) > 0)
{
    print(result3[1,1])  
    wordtable <- rbind(wordtable,result3)
}
result4 <- sqldf(paste0("select * from word3b where word like  '",userinput , "%'"))
if (length(result4[,1]) > 0)
    {
        print(result4[1,1])
        wordtable <- rbind(wordtable,result4)
        
    } 
 
##word4
result5 <- sqldf(paste0("select * from word4a where word like  '",userinput , "%'"))
if (length(result5[,1]) > 0)
{
    print(result5[1,1])  
    wordtable <- rbind(wordtable,result5)
}  
result6 <- sqldf(paste0("select * from word4b where word like  '",userinput , "%'"))
    if (length(result6[,1]) > 0)
    {
        print(result6[1,1])
        wordtable <- rbind(wordtable,result6)
        
    }

##word5
result7 <- sqldf(paste0("select * from word5a where word like  '",userinput , "%'"))
if (length(result7[,1]) > 0)
{
    print(result7[1,1])  
    wordtable <- rbind(wordtable,result7)
}  
result8 <- sqldf(paste0("select * from word5b where word like  '",userinput , "%'"))
if (length(result8[,1]) > 0)
    {
        print(result8[1,1]) 
        wordtable <- rbind(wordtable,result8)
} 


##word6
result9 <- sqldf(paste0("select * from word6a where word like  '",userinput , "%'"))
if (length(result9[,1]) > 0)
{
    print(result9[1,1])  
    wordtable <- rbind(wordtable,result9)
}  
result10 <- sqldf(paste0("select * from word6b where word like  '",userinput , "%'"))
if (length(result10[,1]) > 0)
{
    print(result10[1,1]) 
    wordtable <- rbind(wordtable,result10)
} 

##word7
result11 <- sqldf(paste0("select * from word7a where word like  '",userinput , "%'"))
if (length(result11[,1]) > 0)
{
    print(result11[1,1])  
    wordtable <- rbind(wordtable,result11)
}  
result12 <- sqldf(paste0("select * from word7b where word like  '",userinput , "%'"))
if (length(result12[,1]) > 0)
{
    print(result12[1,1]) 
    wordtable <- rbind(wordtable,result12)
} 
 
print(round(as.double(difftime(Sys.time(), startTime,u="secs")), digits = 2))
returnValue(wordtable)
}
########################################33


