import os
import commands
import sys


def getPostAndUpdateFile(postsFile):
    if (not os.path.exists(postsFile)):
        return None
    postText = None
    with open(postsFile, "r+") as f:
        lines = f.readlines()
        if len(lines) == 0:
            postText = lines[0]
            lines.remove(postText)
            f.seek(0)
            f.truncate()
            f.writelines(lines)
            f.close()
            print "Posting text: " + postText
    return postText
    
if __name__ == "__main__":
    section = sys.argv[1]
    fanpage = sys.argv[2]
    griveFolder = "/opt/gdrive/"
    postsFile = griveFolder + "postFiles/PostTo"+fanpage+"_"+section+".txt"
    
    #update post files
    #output = commands.getoutput("cd "+griveFolder+"; grive")
    #print "Grive output:" + str(output)
    
    #get post text
    postText = getPostAndUpdateFile(postsFile)
    if postText == None:
        print ("Nothing to share...")
        sys.exit();

    print postText
    
    #post text to Tweeter
    command = "twidge --config="+os.getenv("HOME")+"/.twidgerc "+fanpage+" update \""+str(postText)+"\""; 
    print command
    status,output = commands.getstatusoutput(command)
    print "Twidge status: " + str(status)
    if status == 0:
        output = "Successfully updated"
    print "Twidge output: " + str(output)
    
    #post test to Facebook -TODO

