# from fileinput import filename
import pandas as pd
from sklearn.feature_extraction.text import CountVectorizer


# filename= '/Users/gauthamiaithal/Local_Documents/MS DS/Spring 23/Text Mining/Data Extraction/Reddit/climateChangeNEG/combined/Cleaned_Combined_climate_NEG_data.csv'
filename = '/Users/gauthamiaithal/Local_Documents/MS DS/Spring 23/Text Mining/Data Extraction/Reddit/climateChangePOS/combined/Cleaned_Combined_climate_POS_data.csv'
BBC_DF=pd.read_csv(filename, error_bad_lines=False)
new_df = BBC_DF.applymap(lambda x: x.strip() if isinstance(x, str) else x)
new_df.head()
# print(BBC_DF.head())
# iterating the columns 
# for col in BBC_DF.columns: 
#     print(col) 
    
# print(BBC_DF["Post"])

### Tokenize and Vectorize the Headlines
## Create the list of headlines
HeadlineLIST=[]
for next1 in BBC_DF["Post"]:
    HeadlineLIST.append(next1)

# print("The headline list is")
# print(HeadlineLIST)

### Vectorize
#https://scikit-learn.org/stable/modules/generated/sklearn.feature_extraction.text.CountVectorizer.html
MyCountV=CountVectorizer(
        input="content", 
        lowercase=True, 
        stop_words = "english"
        )
 
MyDTM = MyCountV.fit_transform(HeadlineLIST)  # create a sparse matrix
print(type(MyDTM))
#vocab is a vocabulary list
vocab = MyCountV.get_feature_names_out()  # change to a list
# print(list(vocab)[10:20])

MyDTM = MyDTM.toarray()  # convert to a regular array
# print(type(MyDTM))

ColumnNames=MyCountV.get_feature_names_out()
MyDTM_DF=pd.DataFrame(MyDTM,columns=ColumnNames)
print(MyDTM_DF)


from sklearn.decomposition import NMF, LatentDirichletAllocation, TruncatedSVD
from sklearn.feature_extraction.text import CountVectorizer
#######

#MyVectLDA_DH=CountVectorizer(input='filename')
##path="C:\\Users\\profa\\Documents\\Python Scripts\\TextMining\\DATA\\SmallTextDocs"
#Vect_DH = MyVectLDA_DH.fit_transform(ListOfCompleteFiles)
#ColumnNamesLDA_DH=MyVectLDA_DH.get_feature_names()
#CorpusDF_DH=pd.DataFrame(Vect_DH.toarray(),columns=ColumnNamesLDA_DH)
#print(CorpusDF_DH)

######

num_topics = 7

lda_model_DH = LatentDirichletAllocation(n_components=num_topics, 
                                         max_iter=100, learning_method='online')
#lda_model = LatentDirichletAllocation(n_components=NUM_TOPICS, max_iter=10, learning_method='online')
LDA_DH_Model = lda_model_DH.fit_transform(MyDTM_DF)


print("SIZE: ", LDA_DH_Model.shape)  # (NO_DOCUMENTS, NO_TOPICS)

# Let's see how the first document in the corpus looks like in
## different topic spaces
print("First headline...")
print(LDA_DH_Model[0])
print("Sixth headline...")
print(LDA_DH_Model[5])

#print(lda_model_DH.components_)


## implement a print function 
## REF: https://nlpforhackers.io/topic-modeling/
def print_topics(model, vectorizer, top_n=10):
    for idx, topic in enumerate(model.components_):
        print("Topic:  ", idx)
      
        print([(vectorizer.get_feature_names_out()[i], topic[i])
                        for i in topic.argsort()[:-top_n - 1:-1]])
                        ## gets top n elements in decreasing order
    

####### call the function above with our model and CountV
print_topics(lda_model_DH, MyCountV, 15)



## Print LDA using print function from above
########## Other Notes ####################
#import pyLDAvis.sklearn as LDAvis
#import pyLDAvis
#import pyLDAvis.gensim 
## conda install -c conda-forge pyldavis
#pyLDAvis.enable_notebook() ## not using notebook
#panel = LDAvis.prepare(lda_model_DH, MyDTM_DF, MyCountV, mds='tsne')
#pyLDAvis.show(panel)
#panel = pyLDAvis.gensim.prepare(lda_model_DH, MyDTM, MyCountV, mds='tsne')
#pyLDAvis.show(panel)
##########################################################################

import matplotlib.pyplot as plt
import numpy as np

word_topic = np.array(lda_model_DH.components_)
#print(word_topic)
word_topic = word_topic.transpose()

num_top_words = 15
vocab_array = np.asarray(vocab)

#fontsize_base = 70 / np.max(word_topic) # font size for word with largest share in corpus
fontsize_base = 20

for t in range(num_topics):
    plt.subplot(1, num_topics, t + 1)  # plot numbering starts with 1
    plt.ylim(0, num_top_words + 0.5)  # stretch the y-axis to accommodate the words
    plt.xticks([])  # remove x-axis markings ('ticks')
    plt.yticks([]) # remove y-axis markings ('ticks')
    plt.title('Topic #{}'.format(t))
    top_words_idx = np.argsort(word_topic[:,t])[::-1]  # descending order
    top_words_idx = top_words_idx[:num_top_words]
    top_words = vocab_array[top_words_idx]
    top_words_shares = word_topic[top_words_idx, t]
    for i, (word, share) in enumerate(zip(top_words, top_words_shares)):
        plt.text(0.3, num_top_words-i-0.5, word, fontsize=fontsize_base)
                 ##fontsize_base*share)

plt.tight_layout()
plt.show()




