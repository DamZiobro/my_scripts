#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2013 damian <damian@damian-desktop>
#

"""
Getting youtube videos to selected Mp3
"""

import re
import urllib, json
import sys 

def getYoutubeUrl(splitWords):
    """docstring for getYoutubeUrl"""
    questionString = ""
    for word in splitWords:
        questionString +=word+"+"
    #remove last character
    questionString = questionString[:-1]

    inp = urllib.urlopen(r'http://gdata.youtube.com/feeds/api/videos?q='+questionString+'&max-results=1&alt=json')
    resp = json.load(inp)
    inp.close()
    try:
        first = resp['feed']['entry'][0]
        print first['title'] # video title
        return first['link'][0]['href'].split('&')[0] 
    except: 
        return None


def splitLineToYoutubeQuesion(line):
    """docstring for splitLineToYoutubeQuesion"""
    splitWords = re.split(' - | ', line);
    return splitWords


def readSongsFromFile(file):
    songsLines = None
    with open(file) as f:
        songsLines = f.readlines();
    return songsLines


songsLines = readSongsFromFile(sys.argv[1])
areAnyNotDownloaded = 0

for song in songsLines:
    splitWords = splitLineToYoutubeQuesion(song)
    print splitWords

    youtubeUrl = getYoutubeUrl(splitWords)
    if not youtubeUrl == None:
        youtubeToMp3 youtubeUrl
    else:
        areAnyNotDownloaded = 1;
        notDownloadedFile = open("notDownloaded.txt", "a");
        notDownloadedFile.write(song);
        notDownloadedFile.close()

if not areAnyNotDownloaded == 0:
    print "\n\n WARNING! SOME SONGS HAS NOT BEEN DOWNLOADED. \n SEe notDownloadedFile.txt file for details...\n\n"
else:
    print "\n\n ALL SONGS DOWNLOADED SUCCESSFULLY\n\n"


