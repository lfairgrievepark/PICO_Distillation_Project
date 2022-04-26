#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Mar 21 22:33:46 2022

@author: lfairgrievepark12
"""
# Source for first func https://thispointer.com/python-how-to-get-list-of-files-in-directory-and-sub-directories/
# Source for second func https://stackoverflow.com/questions/753190/programmatically-generate-video-or-animated-gif-in-python

import os
import imageio

def getListOfFiles(dirName):
    # create a list of file and sub directories 
    # names in the given directory 
    listOfFile = os.listdir(dirName)
    allFiles = list()
    # Iterate over all the entries
    for entry in listOfFile:
        # Create full path
        fullPath = os.path.join(dirName, entry)
        # If entry is a directory then get the list of files in this directory 
        if os.path.isdir(fullPath):
            allFiles = allFiles + getListOfFiles(fullPath)
        else:
            allFiles.append(fullPath)
                
    return allFiles


'''
July31Files = getListOfFiles('July31_Images/')


images = []
for filename in July31Files:
    images.append(imageio.imread(filename))
imageio.mimsave('July31.gif', images)
'''


def gifmaker(Foldername):
    images = []
    for file_name in sorted(os.listdir(Foldername)):
        if file_name.endswith('.png'):
            file_path = os.path.join(Foldername, file_name)
            images.append(imageio.imread(file_path))
    imageio.mimsave(Foldername[:-7]+'.gif', images)
    
gifmaker('July31_Images')
gifmaker('July17_Images')
    
