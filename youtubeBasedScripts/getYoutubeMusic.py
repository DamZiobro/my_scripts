#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2013 damian <damian@damian-desktop>
#

"""
Getting youtube videos to selected Mp3
"""

import os, re
import urllib, json
import sys 
import requests

def getYoutubeUrl(splitWords):
    """docstring for getYoutubeUrl"""
    questionString = ""
    for word in splitWords:
        questionString +=word+"+"
    #remove last character
    questionString = questionString[:-1]

    API_KEY=os.getenv("YOUTUBE_API_KEY")

    url=r'https://www.googleapis.com/youtube/v3/search?q='+questionString+'&max-results=1&alt=json&part=id&key='+API_KEY
    r = requests.get(url)
    print "URL: " + url
    #print "r.text: " + str(r.text)
    resp = json.loads(r.text)
    try:
        first = resp['items'][0]['id']
        #print first
        return "https://www.youtube.com/watch?v="+unicode(first['videoId'])
    except: 
        return None


def splitLineToYoutubeQuesion(line):
    """docstring for splitLineToYoutubeQuesion"""
    splitWords = re.split(' - | ', line.rstrip());
    return splitWords


def readSongsFromFile(file):
    songsLines = None
    with open(file) as f:
        songsLines = f.readlines();
    return songsLines

import sys
reload(sys)
sys.setdefaultencoding('utf-8')

songsLines = readSongsFromFile(sys.argv[1])
areAnyNotDownloaded = 0

for song in songsLines:
    splitWords = splitLineToYoutubeQuesion(song)
    print splitWords

    youtubeUrl = getYoutubeUrl(splitWords)
    print "youtubeURL: " + youtubeUrl
    if not youtubeUrl == None:
        out = song.replace(' ', "_").replace('-', "_").rstrip() + ".%\(ext\)s"
        cmd = "youtube-dl --extract-audio --audio-format mp3 -o " + out + " " + youtubeUrl 
        print "CMD: " + cmd
        os.system(cmd);
    else:
        areAnyNotDownloaded = 1;
        notDownloadedFile = open("notDownloaded.txt", "a");
        notDownloadedFile.write(song);
        notDownloadedFile.close()

if not areAnyNotDownloaded == 0:
    print "\n\n WARNING! SOME SONGS HAS NOT BEEN DOWNLOADED. \n SEe notDownloadedFile.txt file for details...\n\n"
else:
    print "\n\n ALL SONGS DOWNLOADED SUCCESSFULLY\n\n"


