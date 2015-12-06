#!/usr/bin/python3
import urllib.request
import urllib.parse
import re
import sys 

textToSearch = " ".join(sys.argv[1:]).strip()
query_string = urllib.parse.urlencode({"search_query" : textToSearch})
html_content = urllib.request.urlopen("http://www.youtube.com/results?" + query_string)
search_results = re.findall(r'href=\"\/watch\?v=(.{11})', html_content.read().decode())
for result in search_results:
    print("http://www.youtube.com/watch?v=" + result)
