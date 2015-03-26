#!/usr/bin/python 

import os
import commands
import sys

DEBUG=False 

def log(s):
    if(DEBUG):
        print s

def getPostAndUpdateFile(postsFile, isCrawling = 0):
    if (not os.path.exists(postsFile)):
        return None
    postText = None
    with open(postsFile, "r+") as f:
        lines = f.readlines()
        if len(lines) != 0:
            postText = lines[0]
            lines.remove(postText)
            f.seek(0)
            f.truncate()
            f.writelines(lines)
            if (isCrawling != 0):
                f.write(postText)
            f.close()
            log("Posting text: " + postText)
    return postText
    
if __name__ == "__main__":

    section = sys.argv[1]
    fanpage = sys.argv[2]
    isCrawling = 0;
    if len(sys.argv) == 4:
        isCrawling = int(sys.argv[3])
        
    griveFolder = "/opt/gdrive/"
    postsFile = griveFolder + "postFiles/PostTo"+fanpage+"_"+section+".txt"
    
    #update post files
    #output = commands.getoutput("cd "+griveFolder+"; grive")
    #print "Grive output:" + str(output)
    
    #get post text
    postText = getPostAndUpdateFile(postsFile, isCrawling)
    if postText == None:
        log("Nothing to share...")
        sys.exit();

    log(postText)
    
    #post text to Tweeter
    command = "twidge --config="+os.getenv("HOME")+"/.twidgerc"+fanpage+" update \""+str(postText)+"\""; 
    log(command) 
    status,output = commands.getstatusoutput(command)
    log("Twidge status: " + str(status))
    if status == 0:
        output = "Successfully updated"
    else:
        print ("Twidge command: " + command)
        print ("Twidge outuput: " + str(output))
    log("Twidge output: " + str(output))
    
    #post test to Facebook -TODO

