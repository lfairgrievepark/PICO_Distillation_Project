#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jul 24 14:03:20 2020

@author: lfairgrievepark12
Version 1.0 - the purpose of this script is to organize an image
into lithium/non lithium pixels and count them. Using a reference
of pixels/area, the surface area of lithium should be quantified
"""

import numpy as np
import os
from PIL import Image
import cv2



def quantifier(snap, thresh,crop_coord):
    # snap: Name of image file
    # Thresh: range(x,255) for some 0<x<255. x is the value that determines
    # if an image is categorized as white (lithium edge) or black(lithium)
    # and must be high enough that an unbroken white ring is made
    # around the lithium in most imaging cases, while also being low enough to
    # not read true lithium pixels as non lithium
    img = Image.open(snap).convert('L')# Converting image to greyscale
    img = img.crop(crop_coord) #Cropping to relevant area
    original = np.array(img) # Original image for reference
    original = Image.fromarray(original, 'L')
    #original.show()
    #img = img.filter(ImageFilter.SHARPEN)
    #img = ndi.gaussian_filter(img,sigma=3) # Applying gaussian filter
    #img = Image.fromarray(img, 'L')
    res = Image.new(img.mode, img.size)
    width, height = img.size
    
    # This for loop serves to organize pixels - can be altered, but generally
    # any pixel in a lithium metal intensity range gets sent to black and
    # any other pixel gets sent to white
    for i in range(0, width):
        for j in range(0, height):
            pixel = img.getpixel((i,j))
            a = pixel                                   

            a = 0 if a in thresh else 255

            res.putpixel((i,j),(a))                        # LA
    
    # Generating our new binary image and saving it as an intermediarystep
    updated = np.array(res)
    updated = Image.fromarray(updated, 'L')
    nameA = snap.split('.')[0]+'A.'+'png' 
    updated.save(nameA,'png')
    updated = cv2.imread(nameA, 0)
    
    # Identifying connected components
    num_labels, labels_im = cv2.connectedComponents(updated,connectivity=4)
    
    # Giving each mapped component a unique hue for visualizing
    label_hue = np.uint8(110*labels_im/np.max(labels_im))
    blank_ch = 255*np.ones_like(label_hue)
    labeled_img = cv2.merge([label_hue, blank_ch, blank_ch])

    # cvt to BGR for display
    labeled_img = cv2.cvtColor(labeled_img, cv2.COLOR_HSV2BGR)

    # setting the background label to black
    labeled_img[label_hue==0] = 0
    
    # Saving image and counting pixels by assuming center of img is part of
    # lithium label
    labeled_img = Image.fromarray(labeled_img, 'RGB')
    pix = labeled_img.load()[width/2,height/2]
    cnr = 0
    for i in range(height):
        for j in range(width):
            if((labeled_img.getpixel((j,i))) == pix):
                cnr+=1# Counting number of lithium pixels
    name = snap.split('.')[0]+'B.'+'png' # Generating new name for updated image
    labeled_img.save(name,'png')
    # Get rid of intermediary image
    os.remove(nameA)
    
    return (cnr) # return images and black pixel count

def img_analysis(Foldername,Num_photos,thresh,crop_coord):
    # Num photos: Number of photos to be analyzed
    # Thresh: See func quantifier
    data = np.zeros((Num_photos,2))
    # Defining area in mm^2 of first image based on unsquished lithium
    # based on measured area, used to calculate subsequent areas
    data[0][1]=6.35**2*3.1514
    # Applying quantifier to each image sequentially and saving data
    for i in range(1,Num_photos):
        if i<10 :
            cnr = quantifier(Foldername+'/Snap_00'+str(i)+'.jpg',range(thresh ,255),crop_coord)
            data[i-1][0]=cnr
            data[i-1][1]=data[i-1][0]/data[0][0]*data[0][1]
            print('Img00'+str(i)+' pixels: '+str(cnr))
        if i>9 and i<100:
            cnr = quantifier(Foldername+'/Snap_0'+str(i)+'.jpg',range(thresh ,255),crop_coord)
            data[i-1][0]=cnr
            data[i-1][1]=data[i-1][0]/data[0][0]*data[0][1]
            print('Img0'+str(i)+' pixels: '+str(cnr))
        if i>99 and i<1000:
            cnr = quantifier(Foldername+'/Snap_'+str(i)+'.jpg',range(thresh ,255),crop_coord)
            data[i-1][0]=cnr
            data[i-1][1]=data[i-1][0]/data[0][0]*data[0][1]
            print('Img'+str(i)+' pixels: '+str(cnr))
    return(data)
            
#For July 31 use values 266,75
#For July 17 use alues 95,160, (500,300,1000,9000)
data = img_analysis('July31_Images',266,75,(900, 500, 1700, 1300))
np.savetxt("areadata_July31.csv", data, delimiter=",")





