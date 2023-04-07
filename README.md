# GlacialLakeAnalysis
*** 
## General Information
This script conducts a full analysis of glacial lakes. 
It can be adjusted to any region.
It creates water masks, glacial lake outlines and calculates the area of water bodies based on a chosen index, 
that can be changed easily to the desired indices/threshold/region. 

*** 
## Instructions

### Data
Unfortunately it was not possible to directly download data in the script, as the ```RStoolbox``` and ```GetSpatialData``` packages could not be used.
Therefore, alternatively the needed Data is provided via Google Drive.
So before running the example, please make sure to download the data:

https://drive.google.com/drive/folders/12m56mTpx0kghbT4wn4yUlB-kcRzAvp4S?usp=sharing

The Landsat files were downloaded from USGS Earth Explorer (https://earthexplorer.usgs.gov).

### Scripts
Out of the three provided scripts, the ```Glacial_Lake_Analysis.R``` file is the main script for the analysis. The Functions document is needed for calculating indices (NDWI/NDSI/NDVI).
The ```LagunaParon.R``` is an illustration how a single glacial lake can be analyzed, the methodology however is similar to the main script. 

At various points at the script, path names need to be provided.
Please customize them according to your desktop. 

Customization is needed in:
* line 13,
* line 28 to 45
* line 82 to 89 
* line 250 and 
* line 282 

It is further suggested to keep the folder structure as follows:
![suggested folder structure](https://github.com/lenajaeger9/GlacialLakeAnalysis/blob/main/screenshot.png)

The two separate Landsat folders are due to the differences in bands and renaming.
If all needed packages are installed and all paths are correctly set, this script runs without error messages.

*** 
## Results
Main outputs and advantages of the script are the easy calculation of indices for large numbers of Landsat scenes, the creation of a water mask (binary), the visualization of glacial lake outlines over time and the calculation glacial lake area change.
![Result: Water Mask Assessment (2014)](https://github.com/lenajaeger9/GlacialLakeAnalysis/blob/main/WaterMaskAssessment2014.png)
* Exemplary result of the produced Water Mask of the year 2014. 
![Result: Lake Outlines](https://github.com/lenajaeger9/GlacialLakeAnalysis/blob/main/lake_outlines.png)
* Exemplary result of the produced Lake Outlines. 

*** 
## Discussion 
Note, that the example provides a good impression on what is feasible with the script. 
It does not claim to be a perfect analysis. Rather, it was the intention to make it easily adaptable to different regions. 
