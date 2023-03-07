##############################################################


###################################################
##
## LDA for Topic Modeling
##
###################################################
import requests
import json
import re
import pandas as pd
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.decomposition import NMF, LatentDirichletAllocation, TruncatedSVD

import os





#########################################
## Try sklean LDA with DOG and HIKE data
## CREATE THE DATA YOU NEED by understanding the code
##########################################



all_file_names = []

path="/Users/gauthamiaithal/Local_Documents/MS DS/Spring 23/Text Mining/Data Extraction/Reddit/climateChangePOS/cleaned/alt_full_text_corpus/"


#print("calling os...")
#print(os.listdir(path))
FileNameList=os.listdir(path)
print(FileNameList)

ListOfCompleteFiles=[]

for name in os.listdir(path):
    # print(path+ "\\" + name)
    next1=path + name
    ListOfCompleteFiles.append(next1)
#print("DONE...")
print("full list...")
print(ListOfCompleteFiles)


MyVectLDA_DH=CountVectorizer(input='filename', stop_words="english")
##path="C:\\Users\\profa\\Documents\\Python Scripts\\TextMining\\DATA\\SmallTextDocs"
Vect_DH = MyVectLDA_DH.fit_transform(ListOfCompleteFiles)
ColumnNamesLDA_DH=MyVectLDA_DH.get_feature_names_out()
CorpusDF_DH=pd.DataFrame(Vect_DH.toarray(),columns=ColumnNamesLDA_DH)
# print(CorpusDF_DH)


lda_model_DH = LatentDirichletAllocation(n_components=2, max_iter=100, learning_method='online')
#lda_model = LatentDirichletAllocation(n_components=NUM_TOPICS, max_iter=10, learning_method='online')
LDA_DH_Model = lda_model_DH.fit_transform(Vect_DH)

print("SIZE: ", LDA_DH_Model.shape)  # (NO_DOCUMENTS, NO_TOPICS)

# Let's see how the first document in the corpus looks like in
## different topic spaces
# print("First Doc in Dog and Hike data...")
# print(LDA_DH_Model[0])
# print("Seventh Doc in DOg Hike...")
# print(LDA_DH_Model[6])
# print("List of prob: ")
# print(LDA_DH_Model)




####################################################
##
## VISUALIZATION
##
####################################################
# =============================================================================


import warnings
warnings.filterwarnings("ignore", category=DeprecationWarning)

import pyLDAvis.sklearn as LDAvis
import pyLDAvis


# ## conda install -c conda-forge pyldavis
# pyLDAvis.enable_notebook() ## not using notebook

#print(lda_model_DH.components_)
#print(Vect_DH)
#print(MyVectLDA_DH)

## GOT IT!!

panel = LDAvis.prepare(lda_model_DH, Vect_DH, MyVectLDA_DH, mds='tsne')

pyLDAvis.save_html(panel, "Climate_change.html")





