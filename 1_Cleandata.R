### start load library
library(ngram)
library(tm)
library(stringi)
library(RWeka)
library(dplyr)
library(stringr)
library(sqldf)

### end load library

# start load needed data for functions
cursewords <- readLines("swearWords.txt") ## from http://www.bannedwordlist.com/
# end load needed data for functions

# start load functions

cleanfile <- function(textfile)
{
    f1 <- concatenate(textfile) 
    rm(textfile) 
    f2 <- preprocess(f1,case= "lower", remove.numbers = TRUE) #lower case and remove numbers in one shot 
    f3 <- removeWords(f2,cursewords) # remove curse words removewords
    rm(f1); rm(f2); gc() #remove useless variables to save memory
    f4 <- gsub(pattern = "\\.", replace= " ", f3) # delete all punctuations
    f5 <- gsub("[^[:alpha:]///' ]", "", f4) #remove non- alphabet characters
    rm(f3); rm(f4); gc() 
    f6 <- gsub("â|ã|ð|ÿ|î|ñ|á|ï|à", "", f5) # remove one off foreign characters
    cleanedfile <- stripWhitespace(f6) # remove spaces
    rm(f5); rm(f6); gc()
    return(cleanedfile)
}

## stop words never used
### end load functions




#BLOG
blogfile <- readLines("C:/Users/noeltemena/Documents/Capstone/data/en_US.blogs.txt", skipNul = TRUE) 
cleanfullblog <- cleanfile(blogfile) #1st whole file version
save(cleanfullblog, file = 'cleanfullblog.Rda')
rm(blogfile)
rm(cleanfullblog)
gc()

#TWEETS
twitfile <- readLines("C:/Users/noeltemena/Documents/Capstone/data/en_US.twitter.txt", skipNul = TRUE) 
cleanfulltwit <- cleanfile(twitfile) #1st whole file version
save(cleanfulltwit, file = 'cleanfulltweet.Rda')
rm(twitfile)
rm(cleanfulltwit)#1st whole file version
gc()


#NEWS

newsfile <- readLines("C:/Users/noeltemena/Documents/Capstone/data/en_US.news.txt", skipNul = TRUE)
cleanfullnews <- cleanfile(newsfile) #1st whole file version
save(cleanfullnews, file = 'cleanfullnews.Rda')
rm(newsfile)
rm(cleanfullnews) #1st whole file version
gc()

