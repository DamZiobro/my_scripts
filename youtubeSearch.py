#!/usr/bin/python 

import urllib, json
import sys 

inp = urllib.urlopen(r'http://gdata.youtube.com/feeds/api/videos?q=rodowicz+rozmowa+przez+ocean&max-results=1&alt=json&orderby=viewCount')
resp = json.load(inp)
inp.close()
first = resp['feed']['entry'][0]
print first['title'] # video title
print first['link'][0]['href'] #url
