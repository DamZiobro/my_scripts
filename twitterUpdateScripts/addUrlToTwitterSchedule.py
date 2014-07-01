#!/usr/bin/python

import sys 
import os 
import contextlib
from urllib import urlencode, urlopen
from mechanize import Browser

def make_tiny(url):
    request_url = ('http://tinyurl.com/api-create.php?' + urlencode({'url':url}))
    with contextlib.closing(urlopen(request_url)) as response:
        return response.read().decode('utf-8')

if(len(sys.argv) != 2 and len(sys.argv) != 3 and len(sys.argv) != 4):
    print "Usage" + sys.argv[0] + "URL [Category] [TitleText]"
    exit(-1)

# =================================================
url = sys.argv[1]
category = "General"
fanpage = "XMementoIT"
outputDirPath = "$HOME/gdrive"
# =================================================

titleText = ""

if(len(sys.argv) == 3):
    category = sys.argv[2]
if(len(sys.argv) == 4):
    titleText = sys.argv[3]
else:
    br = Browser();
    br.open(url)
    titleText = br.title()

tinyurl = make_tiny(url)

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
else:
    suffixText = "#" + category

prefixText += " => " + titleText + " - " + tinyurl + " " + suffixText
outputFile = outputDirPath + "/PostTo" + fanpage + "_" + category + ".txt"

os.system("echo \"" + prefixText + "\" >> " + outputFile)

print ("===> Added to file: " + outputFile)
print ("===> Added text: \"" + prefixText) + "\""


