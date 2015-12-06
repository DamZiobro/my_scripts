#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2015 damian <damian@damian-desktop>
#
# Distributed under terms of the MIT license.

"""
Chrome selenium hello world
"""

import os, time
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.keys import Keys

chrome_options = Options()
chrome_options.add_argument("--disable-sync")
driver = webdriver.Chrome(executable_path=os.getenv("SELENIUM_CHROME_DRIVER_PATH"), chrome_options=chrome_options)
youtube_link = 'https://www.youtube.com/watch?v=BHjg6cTxmrQ'
driver.get(youtube_link)


