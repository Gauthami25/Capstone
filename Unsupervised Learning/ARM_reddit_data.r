# Load packages
library(networkD3)
library(arules)
library(ROAuth)
library(jsonlite)
# library(rjson)
library(tokenizers)
library(tidyverse)
library(plyr)
library(dplyr)
library(ggplot2)
#install.packages("syuzhet")  
## for sentiment analysis
library(syuzhet)
library(stringr)
library(arulesViz)
library(igraph)
# Reading in the original Dataset

redditFile = "/Users/gauthamiaithal/Local_Documents/MS DS/Spring 23/Text Mining/Data Extraction/Reddit/climateChangePOS/cleaned/Cleaned_Sustainable_development.csv"
df = read.csv(redditFile, stringsAsFactors = F, na.strings=c("","NA"))

TransactionredditFile = "RedditResults.csv"

Trans = file(TransactionredditFile)
Tokens = tokenizers::tokenize_words(df$Post[1], stopwords = stopwords::stopwords("en"), lowercase = TRUE, 
                                    strip_punct = TRUE, strip_numeric = TRUE, simplify = TRUE)


cat(unlist(str_squish(Tokens)), "\n", file = Trans, sep = ",")
close(Trans)

Trans = file(TransactionredditFile, open="a" )
for(i in 2:nrow(df)){
  Tokens = tokenizers::tokenize_words(df$Post[i], stopwords = stopwords::stopwords("en"), lowercase = TRUE, 
                                      strip_punct = TRUE, strip_numeric = TRUE, simplify = TRUE)
  cat(unlist(str_squish(Tokens)), "\n", file = Trans, sep = ",")
  
}
close(Trans)

redditDF = read.csv(TransactionredditFile, header = FALSE, sep= ",")
head(redditDF)

(str(redditDF))

redditDF = redditDF %>%
  mutate_all(as.character)
(str(redditDF))


## Cleaning with grepl
myDF = NULL
for(i in 1:ncol(redditDF)){
  MyList = c()
  MyList = c(MyList, grepl("[[:digit:]]", redditDF[[i]]))
  myDF = cbind(myDF, MyList)
}

## For all true replace with blank

redditDF[myDF] <- ""
(redditDF)


## More cleaning
myDF = NULL
myDF2 = NULL
myDF3 = NULL

for(i in 1:ncol(redditDF)){
  MyList = c()
  MyList = c(MyList, grepl("[[:digit:]]", redditDF[[i]]))
  
  MyList2 = c()
  MyList2 = c(MyList, grepl("[A-Z]{4,}", redditDF[[i]]))
  
  MyList3 = c()
  MyList3 = c(MyList, grepl("[A-Z]{12,}", redditDF[[i]]))
  
  
  myDF = cbind(myDF, MyList)
  myDF2 = cbind(myDF, MyList2)
  myDF3 = cbind(myDF, MyList3)
  
}

redditDF[myDF] <- ""
redditDF[!myDF2] <- ""
redditDF[myDF] <- ""
(redditDF)


head(redditDF, 10)


write.table(redditDF, file = "updated_redditFile.csv", col.names = FALSE, row.names = FALSE, sep= ",")
redditTrans = read.transactions("updated_redditFile.csv", sep = ",", format("basket"), rm.duplicates = TRUE)


redditTrans_rules = arules::apriori(redditTrans, parameter = list(support=.01, conf= 0.15, minlen= 2))

sortedRules_conf = sort(redditTrans_rules, by="confidence", decreasing = TRUE)
sortedRules_sup = sort(redditTrans_rules, by="support", decreasing = TRUE)

## Support visualization

plot(sortedRules_sup[1:25], method = "graph", engine = 'interactive', shading = "confidence")


