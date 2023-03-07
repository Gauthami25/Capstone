library(wordcloud)
library(tm)
library(slam)
library(quanteda)
library(SnowballC)
library(arules)
library(proxy)
# setwd("/Users/gauthamiaithal/Downloads")
setwd("/Users/gauthamiaithal/Local_Documents/MS DS/Spring 23/Text Mining/Data Extraction/Reddit/naturalCalamitiesData/cleaned")

TheCorpus <- Corpus(DirSource("corpus"))
CleanCorpus <- tm_map(TheCorpus, removePunctuation)
CleanCorpus <- tm_map(CleanCorpus, removeWords, stopwords("english"))
CleanCorpus <- tm_map(CleanCorpus, content_transformer(tolower))

(Cdataframe <- data.frame(text=sapply(CleanCorpus, identity), stringsAsFactors=F))
                          
(MyTDM <- TermDocumentMatrix(CleanCorpus))
(MyDTM2 <- DocumentTermMatrix(CleanCorpus))
(findFreqTerms(MyDTM2, 3))
findAssocs(MyDTM2, 'coffee', 0.20)
findAssocs(MyDTM2, 'dog', 0.20)
findAssocs(MyDTM2, 'hiking', 0.20)
# adtm.df<-as.data.frame(as.matrix(adtm))
(CleanDF <- as.data.frame(as.matrix(MyTDM)))
(CleanDF2 <- as.data.frame(as.matrix(MyDTM2)))
(CleanDFScale2 <- scale(CleanDF2))

(CleanDFScale <- scale(CleanDF))
(d_TDM_E <- dist(CleanDFScale,method="euclidean"))
(d_TDM_M <- dist(CleanDFScale,method="minkowski", p=1))
(d_TDM_M3 <- dist(CleanDFScale,method="minkowski", p=3))


library(stylo)
(d_TDM_C <- stylo::dist.cosine(CleanDFScale))

fit_TD1 <- hclust(d_TDM_E, method="ward.D2")
plot(fit_TD1)


fit_TD2 <- hclust(d_TDM_M, method="ward.D2")
plot(fit_TD2)

(d_DT_C <- stylo::dist.cosine(CleanDFScale2))
fit_DT4 <- hclust(d_DT_C, method="ward.D2")
plot(fit_DT4)

k <- 3 
(kmeansResult <- kmeans(MyDTM2, k)) 
(kmeansResult$cluster)
plot(kmeansResult$cluster)


library("factoextra")

(MyDF<-as.data.frame(as.matrix(MyDTM2), stringsAsFactors=False))
factoextra::fviz_nbclust(MyDF, kmeans, method='silhouette', k.max=5)


inspect(MyDTM2)

(fviz_cluster(kmeansResult, data = MyDTM2,
              ellipse.type = "convex",
              #ellipse.type = "concave",
              palette = "jco",
              axes = c(1, 4), # num axes = num docs (num rows)
              ggtheme = theme_minimal()))


