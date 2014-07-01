#! /usr/bin/env python
# -*- coding: utf-8 -*-

import sys 
import os 
import ntpath 
import re

changesDirectory = {
    "GstPad \* pad, GstObject \* parent" : "GstPad * pad",
    "#include <gst/glib-compat-private.h>*\n?" : "", 
    "g_rec_mutex_clear" : "g_static_rec_mutex_free",
    "g_mutex_clear" : "g_mutex_free",
}

if(len(sys.argv) != 3):
    print("ERROR: usage " + sys.argv[0] + " [inputGstreamerFile] [outputPatchFile]");
    exit(-1)

inputFile = sys.argv[1]
tmpFile = "/tmp/" + ntpath.basename(inputFile) + ".tmp"
patchFile = "/tmp/"+sys.argv[2]

#FIXME COMMENT LATER 
os.system("./restoreCleanPlugins")

#print "Copying " + inputFile + " to " + tmpFile
#os.system("cp " + inputFile + " " + tmpFile) 

inputTmpFile = open(inputFile)
fileLines = inputTmpFile.readlines()
outputTmpFile = open(tmpFile, "w") 


for line in fileLines:
    for key,value in changesDirectory.iteritems():
        line = re.sub(key, value, line)
    outputTmpFile.write(line);
outputTmpFile.close();
    
print "Making patch file: " + patchFile
os.system("diff -ur " + inputFile + " " + tmpFile + " > " + patchFile) 


#change tmpFile name to input file name
patchTmpFile = open(patchFile)
patchFileLines = patchTmpFile.readlines()
patchTmpFile = open(patchFile, "w") 
for line in patchFileLines:
    line = re.sub(tmpFile, inputFile, line)
    #FIXME COMMENT LATER
    line = re.sub("gst-plugins-bad-0.10.23/", "", line)
    patchTmpFile.write(line);
patchTmpFile.close();

#checking if file is empty 
if(os.path.getsize(patchFile) > 0):
    print "\n   Changes saved to patch....\n"
    #FIXME COMMENT LATER
    #output = os.popen("echo " + ntpath.basename(patchFile) + " >> series-0.10.23")
    #print "   Patch put to series file"
    output = os.popen("mv " + patchFile + " patches")
    print "   Patch moved to patches directory"

else:
    print "\n   WARNING! NO CHANGES - EMPTY PATCH CREATED...\n" 

