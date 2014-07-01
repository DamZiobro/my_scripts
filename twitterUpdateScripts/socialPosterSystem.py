#/usr/bin/python 

import os
import commands
import sys

def getPostAndUpdateFile(file):
    fileLines = open(postsFile).readlines()
    postText = fileLines[0]
    print "Posting text: " + postText
    
    #remove posted line and save to file
    fileLines.remove(postText)
    file = open(postsFile,"w")
    file.writelines(fileLines)
    file.close()
        
    return postText


if __name__ == "__main__":
    section = sys.argv[1]
    fanpage = sys.argv[2]
    griveFolder = os.getenv("HOME")+"/gdrive/"
    postsFile = griveFolder + "PostTo"+fanpage+"_"+section+".txt"
    
    #update post files
    #output = commands.getoutput("cd "+griveFolder+"; grive")
    #print "Grive output:" + str(output)
    
    #get post text
    postText = getPostAndUpdateFile(file)
    print postText
    
    #post text to Tweeter
    status,output = commands.getstatusoutput("twidge update \""+str(postText)+"\"")
    print "Twidge status: " + str(status)
    if status == 0:
        output = "Successfully updated"
    print "Twidge output: " + str(output)
    
    #post test to Facebook -TODO

