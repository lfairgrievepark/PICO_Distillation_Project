#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Aug 18 16:08:20 2020

@author: lfairgrievepark12
This is just a quick little script to plot the squished lithium area change over
over time. Note For July 17th images were taken every hour whereas July 31 images
were taken every 10 minutes, leading to different density of data points
"""
import numpy as np
import matplotlib.pyplot as plt

# Import data files with Lithium pixel count and area in mm^2 columns
dataJ17 = np.loadtxt('areadata_July17.csv',delimiter=',')
pixelsJ17=dataJ17[:,0]
areaJ17=dataJ17[:,1]

# Quantify how many images are incorrectly quanitified based on large pixel overcount
falseJ17=sum(i > 100000 for i in pixelsJ17)
print('false positive images for July 17 is %i or %1.2f percent \n' % (falseJ17, falseJ17/len(pixelsJ17)*100))

f = plt.figure(1,figsize=(10,6))
plt.plot(np.arange(0,len(areaJ17)),areaJ17/areaJ17[1]*100-100,'k*',label='July17')
plt.title('Lithium Compression Area Change')
plt.ylabel('Percentage Area Change')
plt.xlabel('Time elapsed (Hours)')
plt.ylim([-2,10])
###############################################################

dataJ31 = np.loadtxt('areadata_July31.csv',delimiter=',')
pixelsJ31=dataJ31[2:,0]
areaJ31=dataJ31[2:,1]

falseJ31=sum(i > 200000 for i in pixelsJ31)
print('false positive images for July 31 is %i or %1.2f percent \n' % (falseJ31, falseJ31/len(pixelsJ31)*100))


plt.plot(np.arange(0,len(areaJ31))/(6),areaJ31/areaJ31[1]*100-100,'r*',label='July31')
plt.legend()
plt.savefig('Lithium_Area_Change.png')


