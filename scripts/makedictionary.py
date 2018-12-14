# ***************************************************************************************
# ***************************************************************************************
#
#		Name : 		makedictionary.py
#		Author :	Paul Robson (paul@robsons.org.uk)
#		Date : 		7th December 2018
#		Purpose :	Get labels from import.list and add to dictionary.
#
# ***************************************************************************************
# ***************************************************************************************

import re,imagelib
from labels import *

print("Importing core words into dictionary.")
#
#		Read labels
#
image = imagelib.ColorForthImage()
labels = LabelExtractor("boot.lst").getLabels()
count = 0
#
#		Add each pair to the dictionary
#
words = [x for x in labels.keys() if x[:6] == "start_"]
words.sort()
for w in words:
	name = "".join([chr(int(x,16)) for x in w[6:].split("_")])
	#print(w,name)
	assert name[-2:] == ":m" or name[-2:] == ":f"
	isCommands = name[-1] == "m"
	name = name[:-2]
	#print(name,labels[w],isCommands)
	image.addDictionary(name,image.getCodePage(),labels[w],isCommands)
	count += 1
image.save()
print("\tImported {0} words.".format(count))
