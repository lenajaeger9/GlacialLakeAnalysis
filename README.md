# GlacialLakeAnalysis


This script conducts a full analysis of glacial lakes. 
It can be adjusted to any region.
It creates water masks, glacial lake outlines and calculates the area of water bodies based on a chosen index, 
that can be changed easily to the desired indices/threshold/region. 


Before running the example, please make sure to download the data, provided via the Google Drive Link:

https://drive.google.com/drive/folders/12m56mTpx0kghbT4wn4yUlB-kcRzAvp4S?usp=sharing


The Landsat files were downloaded from USGS Earth Explorer (https://earthexplorer.usgs.gov).

Note, that the example provides a good impression on what is feasible with the script. 
It does not claim to be a perfect analysis. Rather, it was the creator's intention to make it easily adaptable to different regions. 

Also, at various points at the script, path names need to be provided.
Please customize them according to your desktop. 
Customization is needed in:
    - line 13,
    - line 28 to 45
    - line 82 to 89
    - line 250 and 
    - line 282 

It is further suggested to keep the folder structure as follows:
data >> landsat >> one folder for Landsat 8 and one for Landsat 5
The two separate folders are due to the differences in bands and renaming. 

If all needed packages are installed and all paths are correctly set, this script runs without error messages.
