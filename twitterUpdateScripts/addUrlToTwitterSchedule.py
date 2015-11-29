#!/usr/bin/python

import sys 
import os 
import contextlib
from urllib import urlencode, urlopen
from mechanize import Browser

def make_tiny(url):
    """Creates tiny URL from long url using http://tinyrul.com webservice"""
    request_url = ('http://tinyurl.com/api-create.php?' + urlencode({'url':url}))
    with contextlib.closing(urlopen(request_url)) as response:
        return response.read().decode('utf-8')


if(len(sys.argv) < 2 or len(sys.argv) > 5):
    print "Usage " + sys.argv[0] + " URL [Category] [Fanpage,Fanpages] [TitleText]"
    exit(-1)

# =================================================
url = sys.argv[1]
category = "General"
fanpages = ["DamianZiobro"]
outputDirPath = os.getenv("HOME")+ "/.dotfiles";
# =================================================

titleText = ""

if(len(sys.argv) >= 3):
    category = sys.argv[2]
if(len(sys.argv) >= 4):
    fanpages = str(sys.argv[3]).split(",")
if(len(sys.argv) >= 5):
    titleText = sys.argv[4]
else:
    br = Browser();
    br.open(url)
    titleText = br.title()

tinyurl = make_tiny(url)

print "tinyurl: " + str(tinyurl)
print "titleText: " + str(titleText)

prefixText = ""
suffixText = ""
if category == "Library":
    prefixText = "Library of the week"
elif category == "CanDoIt":
    prefixText = "XMementoIT can do it"
elif category == "CVLearning":
    suffixText = "#ComputerVision"
elif category == "CppLearning":
    prefixText = "C++ Learning"
    suffixText = "#cpp"
elif not (category == "General"):
    suffixText = "#" + category

#update google drive
os.system("cd " + outputDirPath + "; grive");
    

prefixText += " => " + str(titleText) + " - " + str(tinyurl) + " " + suffixText

for fanpage in fanpages:
    outputFile = outputDirPath + "/postFiles/PostTo" + fanpage + "_" + category + ".txt"
    os.system("echo \"" + prefixText + "\" >> " + outputFile)

    print ("===> Added to file: " + outputFile)
    print ("===> Added text: \"" + prefixText) + "\""
    print "==============================================="

