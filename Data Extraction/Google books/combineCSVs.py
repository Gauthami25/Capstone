# import pandas as pd
# import glob
# import os

# path = r"/Users/gauthamiaithal/Local_Documents/MS DS/Spring 23/Text Mining/Relevant Repos/google-books-collector-main/" # use your path

# # deleting output if it already exists
# file = 'output.csv'
# if(os.path.exists(file) and os.path.isfile(file)):
#   os.remove(file)
#   print("file deleted")


# # merging the files
# joined_files = os.path.join(path, "*.csv")
  
# # A list of all joined files is returned
# joined_list = glob.glob(joined_files)
  
# # Finally, the files are joined
# df = pd.concat(map(pd.read_csv, joined_list), ignore_index=True)

# df_deduplicated = df.drop_duplicates()

# df_deduplicated = df_deduplicated[['TITLE', 'AUTHOR', 'PUBLISHER', 'DESCRIPTION']]

# df_deduplicated.to_csv("output.csv", index= False)


import pandas as pd
import glob
import os

path = r"/Users/gauthamiaithal/Local_Documents/MS DS/Spring 23/Text Mining/Data Extraction/Google books/google-books-collector-main/" # use your path

# deleting output if it already exists
file = 'Combined_Google_Books_data.csv'
if(os.path.exists(file) and os.path.isfile(file)):
  os.remove(file)
  print("file deleted")



# Adding labels to each csv

# merging the files
joined_files = os.path.join(path, "*.csv")

# A list of all joined files is returned
joined_list = glob.glob(joined_files)
  
for f in joined_list:
  df = pd.read_csv(f)
  print(f.split('/')[-1].rstrip('.csv'))
  df['Label'] = f.split('/')[-1].rstrip('.csv')
  df.to_csv(f.split('/')[-1].rstrip('.csv') + '.csv', index = False)

# Finally, the files are joined
df = pd.concat(map(pd.read_csv, joined_list), ignore_index=True)

df_deduplicated = df.drop_duplicates()

df_deduplicated = df_deduplicated[['TITLE', 'AUTHOR', 'PUBLISHER', 'DESCRIPTION', 'Label']]

df_deduplicated.to_csv(file, index= False)



          

