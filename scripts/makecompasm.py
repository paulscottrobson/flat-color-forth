# ***************************************************************************************
# ***************************************************************************************
#
#		Name : 		makecompasm.py
#		Author :	Paul Robson (paul@robsons.org.uk)
#		Date : 		9th December 2018
#		Purpose :	Make composite assembly file for assembler
#
# ***************************************************************************************
# ***************************************************************************************

#
#		Tidy the format.
#
def format(s):
	if s[0] != " ":
		return s
	return "    "+s.strip()

import re,os,sys
print("Building vocabulary assembler file.")
#
#		Get all source
#
source = []
for root,dirs,files in os.walk("sources"):
	for f in files:
		if f[-7:] == ".source":
			for l in open(root+os.sep+f).readlines():
				source.append(l)
#
#		Tidy it up
#
source = [x if x.find("//") < 0 else x[:x.find("//")] for x in source]
source = [x.replace("\t"," ").rstrip() for x in source if x.strip() != ""]
source = [x for x in source if x[0] != ';']
#
#		Split it up into words
#
words = {}
currentWord = None
for w in source:
	if w[0] == "@":
		parts = w.split(" ")
		assert parts[-1] not in words,"Duplicate "+w
		assert parts[0] == "@word" or parts[0] == "@macro",w
		currentWord = parts[-1]
		words[currentWord] = { "type":parts[0][1:],"code":[] }

	else:
		words[currentWord]["code"].append(format(w))
#
#		Generate code.
#
keys = [x for x in words.keys()]
keys.sort()
count = 0
hOut = open("__words.asm","w")
for w in keys:
	hOut.write("; =========== {0} {1} ===========\n\n".format(w,words[w]["type"]))
	scrambled = "_".join(["{0:02x}".format(ord(x)) for x in w])

	if len(words[w]["code"]) == 0:
		print("\tWarning ! '{0}' has no code.".format(w))

	if words[w]["type"] == "macro":
		count += 1
		hOut.write("start_"+scrambled+":\n")
		hOut.write(" call COMUCopyCode\n")
		hOut.write(" db end_{0}-start_{0}-4\n".format(scrambled))
		hOut.write("\n".join(words[w]["code"])+"\n")
		hOut.write("end_"+scrambled+":\n\n")

		
	if words[w]["type"] == "word":
		count += 1
		hOut.write("start_"+scrambled+":\n")
		hOut.write(" call COMUCompileCallToSelf\n")
		hOut.write("\n".join(words[w]["code"])+"\n")
		hOut.write(format(" ret")+"\n\n")

hOut.close()
print("\tBuilt assembly file with {0} words.".format(count))