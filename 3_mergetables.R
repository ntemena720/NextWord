library(sqldf)
library(data.table)
mergewords <- function(df1,df2)
{
    overlap <- intersect(df1$word,df2$word)
    if (length(overlap) == 0)
    {
        mergeDF <- rbind(df1,df2)
    } else 
    {    
        df1[df1$word %in% overlap,2] <- df1[df1$word %in% overlap,2]+ df2[df2$word %in% overlap,2]
        mergeDF <- rbind(df1,df2[-(which(df2$word %in% overlap,1)),])
    }
    mergeDF <- setDT(mergeDF)
    return(mergeDF)
    
}

############################
load('dfnews3.rda')
dfnews3 <- dffile
rm(dffile)
load('dftweet3.rda')
dftweet3 <- dffile
rm(dffile)
gc(reset = TRUE)
mergedf3 <- mergewords(dfnews3,dftweet3)
uniquewords <- unique(setDT(mergedf3), by = 'word')
rm(dfnews3)
rm(dftweet3)

load('dfblog3.rda')
dfblog3 <- dffile
rm(dffile)
gc()
word3 <- mergewords(mergedf3,dfblog3)
uniquewords <- unique(setDT(word3), by = 'word')

save(word3, file = "word3.Rda")


