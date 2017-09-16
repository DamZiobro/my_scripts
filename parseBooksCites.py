#! /usr/bin/env python3
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
"""
Parse booksCites.txt file
"""

import configparser
import os
import random

BOOKS_CITES_FILE = str(os.getenv("POSTFILES_DIR")) +"/booksCites.txt"

if __name__ == "__main__":    
    try:
        config = configparser.ConfigParser(allow_no_value=True)
        config.read(BOOKS_CITES_FILE)
        allbooks = [section for section in config.sections()]
        allcites = []
        for book in allbooks:
            for cite in list(dict(config[book].items()).keys()):
                allcites.append([cite,book])
        #print (allcites)
        selectedDict = random.choice(allcites)
        selectedCite = selectedDict[0]
        selectedBook = selectedDict[1]
        #print (selectedCite)

        #remove first 2 chars ('- ')
        selectedCite = selectedCite[2:]
        #remove char '.' if applied at the end
        if (selectedCite[-1] == '.'):
            selectedCite = selectedCite[:-1]
        #make sure first letter is uppercase
        selectedCite = selectedCite[0].upper() + selectedCite[1:]

        print("\x1B[3m\"%s\"\x1B[23m   %s" % (selectedCite, selectedBook))
    except FileNotFoundError:
        print("ERROR: cannot open booksCites file from this location:" + BOOKS_CITES_FILE)

