#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(data.table)
library(sqldf)
library(ngram)
library(qdap)
library(stringr)
library(shinythemes)
library(DT)
#library(htmltools)
load("word2c.Rda")
load("word3c.Rda")
load("word4c.Rda")
#load("word5c.Rda")
#### app feature
q1 <- ("There are three kinds of lies: lies, damned lies, and statistics.")
q2 <- ("USA Today has come out with a new survey--apparently three out of every four people make up 75% of the population.")
q3 <- ("The factory of the future will have only two employees, a man, and a dog.  The man will be there to feed the dog.  The dog will be there to keep the man from touching the equipment.")
q4 <- ("For a list of all the ways technology has failed to improve the quality of life, please press three.")
q5 <- ("Give a man a fish, and he will eat for a day. Give a man Twitter, and he will forget to eat and starve to death.")
q6 <- ("I can prove anything by statistics except the truth")
qlist <- list(q1,q2,q3,q4,q5,q6)
## app feature
options(DT.options = list(pageLength = 5, language = list(search = 'Filter:')))


#####  start predict the next word function
getnextword <- function(wordframe, keyword)
{ 
    result.frame <- data.frame(Predicted_Word = character(),Score=numeric(), stringsAsFactors = FALSE) 
    row_num <- nrow(wordframe)
    if (row_num > 5) {row_num <- 5} # if results are many just take the top 10 rows
    for (i in 1:row_num)
    {
        wordlist <- strsplit(wordframe[i,1], " ") # index the word in the data frame
        for(ii in 1:length(wordlist[[1]])) # index word and pick the next word
        {
            if (wordlist[[1]][ii] == keyword)
            { 
                nextword <- wordlist[[1]][ii + 1]
            }
        }
        freq <- wordframe[i,2] # get the word count
        result.frame[i,] <- c(nextword,freq)
    }
    colnames( result.frame ) <- c( "Predicted Word", "Score" )  
    result.frame <- result.frame[complete.cases(result.frame), ]
    return(result.frame)
}
#### end predict the next word function
#### start backoff function
backoff <-function(wholeinput)
{
    #word4 <- word(wholeinput, -4:-1) #5c model
    word3 <- word(wholeinput, -3:-1) #4c model
    word2 <- word(wholeinput, -2:-1) #3c model
    word1 <- word(wholeinput, -1) #2c model
    for (i in 3:1)
    {
        if (!any(is.na(get(paste0("word",i)))))
        { 
            searchword <- concatenate(get(paste0(paste0("word",i))))
            backtable <- sqldf(paste0("select * from word", i + 1,"c where word like '",searchword , " %' "))
            if (nrow(backtable) > 0 )
            {
                return(backtable) # return data table with results
            } 
        } 
    } # end loop
    backtable <- data.table(PredictedWord = character(0), Score = numeric(0)) #no word found make empty data table
    return(backtable) # after 4 loops no result return empty table
}
### end of backoff function

# Define UI for application that draws a histogram
ui <- fluidPage(
    theme = shinytheme("simplex"),   #cerulean, lumen shinythemes::themeSelector()
    h1("Next Word Predictor App"),
    h5("This word predicting application uses 2-4 Ngram model taken from a collection of blogs,tweets and news."),
    h5("Quanteda, Ngram and Data Frame package were used to clean the files and build the model."),
    h5("Backoff algorithm was used for predicting the next word while score is based from tabulated word combination frequency."), 
    h4(" ------------------------------------------------------------------------------------------------------------------- "),
    h3("Enter a word"),
    textInput("userword", label= "" ,value = "", width = '50%'),
    mainPanel(uiOutput("appStatus"),dataTableOutput("dataTable"))
)

server <- function(input, output) 
{
    wordTable <- function() 
    { 
       startTime <- Sys.time()
       userinput <- input$userword
       userinput <- gsub("\\'", "", userinput) # check for sql injection
       userinput <- tolower(Trim(clean(userinput)))
       lastword <- word(userinput, -1)
       wordGram <- wordcount(userinput)
       if (wordGram == 0)
       {
            appstatus <- paste0('"',sample(qlist,1,6),'"')
            output$appStatus <- renderText({ HTML(paste0('<br/><br/><b><font size="3">',appstatus,'</font></b><br/><br/><br/><br/>'))}) 
            mytable <- data.table(PredictedWord = character(0), Score = numeric(0))
       } 
       else
       { 
            if (wordGram < 4)
            { # word count is less 5
                vartable <- sqldf(paste0("select * from word",  wordGram +1, "c where word like  '",userinput , " %' "))
                if (nrow(vartable) > 0 ) 
                {# start standard search no backoff
                  mytable <-getnextword(vartable, lastword)
                  colnames( mytable ) <- c( "PredictedWord", "Score" )
                  appstatus <- paste('Next predicted word is: <font color= "blue"> ', toupper(mytable[1,1]))
                  output$appStatus <- renderText({ HTML(paste0('<br/><br/><b><font size="3">',appstatus,'</font></b><br/><br/><br/><br/>'))}) 
                } 
                else # end of standard search no backoff
                {  #start of backoff method
                   vartable <- backoff(userinput)
                  if (nrow(vartable) > 0 ) 
                  {
                    mytable <-getnextword(vartable, lastword)
                    colnames( mytable ) <- c("PredictedWord", "Score" )
                    appstatus <- paste('Next predicted word is: <font color= "blue"> ', toupper(mytable[1,1]))
                    output$appStatus <- renderText({ HTML(paste0('<br/><br/><b><font size="3">',appstatus,'</font></b><br/><br/><br/><br/>'))}) 
                  } 
                  else  
                  {       
                    appstatus <- "No predicted word found."
                    output$appStatus <- renderText({ HTML(paste0('<br/><br/><b><font size="3">',appstatus,'</font></b><br/><br/><br/><br/>'))})
                    mytable <- data.table(PredictedWord = character(0), Score = numeric(0))
                  }
                }   # end of backoff method    
            } 
            else # word count is more than 5
            {   
                vartable <- backoff(userinput)
                if (nrow(vartable) > 0 ) 
                {
                    mytable <-getnextword(vartable, lastword)
                    colnames( mytable ) <- c("PredictedWord", "Score" )
                    appstatus <- paste('Next predicted word is: <font color= "blue"> ', toupper(mytable[1,1]))
                    output$appStatus <- renderText({ HTML(paste0('<br/><br/><b><font size="3">',appstatus,'</font></b><br/><br/><br/><br/>'))}) 
                    } 
                else  
                {       
                    appstatus <- "No predicted word found."
                    output$appStatus <- renderText({ HTML(paste0('<br/><br/><b><font size="3">',appstatus,'</font></b><br/><br/><br/><br/>'))}) 
                    mytable <- data.table(PredictedWord = character(0), Score = numeric(0))
                }
            }
       } #end ngram search       
       #output$appStatus <- renderText({ HTML(paste0('<br/><br/><b><font size="3">',appstatus,'</font></b><br/><br/><br/><br/>'))}) 
       mytable <- datatable(mytable, options = list(dom = 't')) # show simple table
       return(mytable)
    } #word table function 
       
       output$dataTable = renderDataTable(wordTable()) 
       
       
} #shiny server function

# Run the application 
shinyApp(ui = ui, server = server)

