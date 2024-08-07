##copy and paste from Google Colab
##see https://colab.research.google.com/drive/1H5LY_m4FBGn0WeQ3eHl1pknbF-TeiY-B?usp=sharing
## Mark Reuter
## mark.reuter@googlemail.com


import csv

with open('/content/sample_data/text-to-audio-Sheets.csv', 'r') as file:
    reader = csv.reader(file)
    textToAudio = list(reader)
print(type(textToAudio))

#print each element
for i in textToAudio:
  print(i)

#install gradio_client library
!pip install gradio_client #Jupyter/Colab syntax

#make a small version of list (for testing)
textToAudioShort = textToAudio[:5]
print(textToAudioShort)
print(type(textToAudioShort))

import time #use time library to add a pause
from gradio_client import Client

client = Client("haoheliu/audioldm-text-to-audio-generation")

#create a function to generate output
# 1 argument - the text propmpt
def textToAudioFunc(text):
  result = client.predict(
		text=text,
		negative_prompt="low quality, average quality",
		duration=5,
		guidance_scale=3.5,
		random_seed=45,
		n_candidates=3,
		api_name="/text2audio")
  return result

##optional, test without a loop
#audio = textToAudioFunc("an old dusty ride cymbal being hit with a key")
#audio = textToAudioFunc(textToAudio[0])
#print(audio)

##create a dictionary to match input to output
audioDict = {}

for i in textToAudio:
	key = i[0]  # Extract the first element (assuming it's a string)
	print(key)
	audio = textToAudioFunc(key)
    #add to dictionary
	audioDict[key] = str(audio)
	time.sleep(10) #sleep for 10 seconds so we don't anger the API Gods

import os
print(audioDict)
print(audioDict.keys())
print(audioDict.values())

#write dictionary to csv file
with open('/content/sample_data/dict.csv', 'w') as csv_file:
    writer = csv.writer(csv_file)
    for key, value in audioDict.items():
       writer.writerow([key, value])

##end
