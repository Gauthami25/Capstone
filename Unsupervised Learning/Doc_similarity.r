library(tm)
#install.packages("tm")
library(stringr)
library(wordcloud)
# ONCE: install.packages("Snowball")
## NOTE Snowball is not yet available for R v 3.5.x
## So I cannot use it  - yet...
##library("Snowball")
##set working directory
## ONCE: install.packages("slam")
library(slam)
library(quanteda)
## ONCE: install.packages("quanteda")
## Note - this includes SnowballC
library(SnowballC)
library(arules)
##ONCE: install.packages('proxy')
library(proxy)
library(cluster)
library(stringi)
library(proxy)
library(Matrix)
library(tidytext) # convert DTM to DF
library(plyr) ## for adply
library(ggplot2)
library(factoextra) # for fviz
library(mclust) # for Mclust EM clustering
library(textstem)  ## Needed for lemmatize_strings


library(amap)  ## for Kmeans
library(networkD3)

setwd("/Users/gauthamiaithal/Local_Documents/MS DS/Spring 23/Text Mining/Data Extraction/Reddit/climateChangePOS/cleaned")
NovelsCorpus <- Corpus(DirSource("alt_full_text_corpus"))
(getTransformations()) ## These work with library tm
(ndocs<-length(NovelsCorpus))

NovelsCorpus <- tm_map(NovelsCorpus, content_transformer(tolower))
NovelsCorpus <- tm_map(NovelsCorpus, removePunctuation)


NovelsCorpus <- tm_map(NovelsCorpus, lemmatize_strings)

(summary(NovelsCorpus))  ## This will list the docs in the corpus


Novels_dtm <- DocumentTermMatrix(NovelsCorpus,
                                 control = list(
                                   stopwords = TRUE, ## remove normal stopwords
                                   wordLengths=c(4, 10), ## get rid of words of len 3 or smaller or larger than 15
                                   removePunctuation = TRUE,
                                   removeNumbers = TRUE,
                                   tolower=TRUE,
                                   #stemming = TRUE,
                                   remove_separators = TRUE
                                   #stopwords = MyStopwords,
                                   
                                   #removeWords(MyStopwords),
                                   #bounds = list(global = c(minTermFreq, maxTermFreq))
                                 ))


DTM_mat <- as.matrix(Novels_dtm)
DTM_mat[1:4,1:10]


(WordFreq <- colSums(as.matrix(Novels_dtm)))


(head(WordFreq))
(length(WordFreq))
ord <- order(WordFreq)
(WordFreq[head(ord)])
(WordFreq[tail(ord)])

(Row_Sum_Per_doc <- rowSums((as.matrix(Novels_dtm))))

Novels_M <- as.matrix(Novels_dtm)
Novels_M_N1 <- apply(Novels_M, 1, function(i) round(i/sum(i),3))
Novels_Matrix_Norm <- t(Novels_M_N1)

Novels_DF <- as.data.frame(as.matrix(Novels_dtm))

ncol(Novels_DF)

Novels_DF_From_Matrix_N<-as.data.frame(Novels_Matrix_Norm)
wordcloud(colnames(Novels_M), Novels_M[4, ], max.words = 100)

(head(sort(Novels_M[4,], decreasing = TRUE), n=20))


m  <- Novels_M
m_norm <-Novels_Matrix_Norm
(str(m_norm))

distMatrix_E <- dist(m, method="euclidean")
print(distMatrix_E)

distMatrix_C <- dist(m, method="cosine")
print("cos sim matrix is :\n")
print(distMatrix_C) ##small number is less distant

print("L2 matrix is :\n")
print(distMatrix_E)

distMatrix_C_norm <- dist(m_norm, method="cosine")
print("The norm cos sim matrix is :\n")
print(distMatrix_C_norm)

(distMatrix_Min_2 <- dist(m,method="minkowski", p=2)) 


groups_E <- hclust(distMatrix_E,method="ward.D")
plot(groups_E, cex=0.9, hang=-1, main = "Euclidean")
rect.hclust(groups_E, k=3)

## From the NetworkD3 library
#https://cran.r-project.org/web/packages/networkD3/networkD3.pdf
radialNetwork(as.radialNetwork(groups_E))

## Cosine Similarity
groups_C <- hclust(distMatrix_C,method="ward.D")
plot(groups_C, cex=.7, hang=-30,main = "Cosine Sim")
rect.hclust(groups_C, k=3)

radialNetwork(as.radialNetwork(groups_C))
dendroNetwork(groups_C)



groups_C_n <- hclust(distMatrix_C_norm,method="ward.D")
plot(groups_C_n, cex=0.9, hang=-1,main = "Cosine Sim and Normalized")
rect.hclust(groups_C_n, k=3)

radialNetwork(as.radialNetwork(groups_C))
dendroNetwork(groups_C)


## Cosine Similarity for Normalized Matrix
groups_C_n <- hclust(distMatrix_C_norm,method="ward.D")
plot(groups_C_n, cex=0.9, hang=-1,main = "Cosine Sim and Normalized")
rect.hclust(groups_C_n, k=3)

radialNetwork(as.radialNetwork(groups_C_n))

fviz_dist(distMatrix_C_norm, gradient = list(low = "#00AFBB", 
                                             mid = "white", high = "#FC4E07"))+
  ggtitle("Cosine Sim  - normalized- Based Distance Map")






