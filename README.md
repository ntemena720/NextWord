# NextWord

Next word is a Shiny app that predicts the next word a user will type. It uses NLP to build the prediction model file and backoff algorithm to search for the next word. Link to see the app in action: https://noeltemena.shinyapps.io/ShinyWord/


![Predict Next Word](https://github.com/ntemena720/NextWord/blob/master/nextword.PNG)

There are 6 files on this repository:

1) NextWord_documentation.html: an HTML file with no R codes that describes steps on efficiently cleaning data files and building an ngram model without running out of memeory. This also includes what function/package/algorithm to use for quick word search. Click to read: https://cdn.rawgit.com/ntemena720/NextWord/4a1d0960/NextWord_documentation.html

2) ngram.html: exploratory data analysis done on the data source used for the next word app. This document was done before I performed NLP on the dataset. Click to read https://rpubs.com/noeltemena/ngram

3) 1_cleandata.R: source file for cleaning the source files from a collection of blogs,tweets and news. I purposesly not used the dplyr pipe on Cleanfile function to prevent memory crash while processing millions of data row. 

4) 2_Tokenize.RR: source files for building the ngram model files

5) 3_mergetables.R: source file for merging ngram model files. Merge function inlduces adding word frequency from the intersect word from the 2 word data frame.

6) 4_optimize_table.R: source file for combining same ngram files from the 3 data source files (blog,news and tweets).

7) 5_searchword.R: This is kind of a sandbox file to test and determine the fastest nextword query function between dplyr filter & sqldf. 

8) app.R: source file for Shiny app using sqldf to search the next "predicted" word.



