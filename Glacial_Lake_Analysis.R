# ------------------------------------------------------------------------------------#
## ---------------------Glacial Lake Area Change Analysis----------------------------##
# ------------------------------------------------------------------------------------#


library(terra)
library(stringr)
library(sf)
library(mapview)
library(ggplot2)
library(dplyr)

source("path/to/file/Functions.R") # Functions document provided via GitHub

getwd()
# setwd()
## --------------------- Data Preparation & Preprocessing ---------------------------##
# ------------------------------------------------------------------------------------#


# ---------- Preparation for Loop

# NOTE: please adjust to own paths
# this script it is foreseen to store the landsat files in a data folder
# within this data folder, two seperate subfolders should contain 1.) Landsat 8 & 9 scenes and 2.) Landsat 1-7 scenes
# BACKGROUND: this is due the different band numbers and designations of the Landsat satellites

# path to data folder
main_path <- "path/to/folder/data/landsat"
# path to Landsat 8 folder
l8_path <- "path/to/folder/data/landsat/L8"
# path to Landsat5 folder
l5_path <- "path/to/folder/data/landsat/L5"

l8_subfolders <- list.dirs(l8_path, recursive = F)
l5_subfolders <- list.dirs(l5_path, recursive = F)

bands_l8 <- c("Aero", "B", "G", "R","NIR", "SWIR1", "SWIR2", "Thermal")
bands_l5 <- c("B", "G", "R", "NIR", "SWIR1", "Thermal", "SWIR2")

# path to where you want to store the processed data (suggested to create a new folder before running)
lsat_path <- "path/to/folder/data/FinalData"

# area of interest (in drive folder AOI are several .gpkg files to try out)
aoi_extent <- st_read("path/to/file/AOI.gpkg")


# Loop to import Landsat scenes, rename bands, crop and stack them and save them in separate folder

# loop for Landsat 8
for (subfolder in l8_subfolders) {
  message(paste0("Preprocessing Landsat scene"))
  stackname <- str_split_i(subfolder, "/", -1)
  date <- str_extract(stackname, "\\d{8}") # pattern for filename
  tif_files <- list.files(path = subfolder, pattern = "B.*.TIF$", full.names = TRUE)
  raster_stack <- rast(tif_files)
  raster_stack_cropped <- crop(raster_stack, aoi_extent)
  names(raster_stack_cropped) <- bands_l8
  writeRaster(raster_stack_cropped, file.path(lsat_path, filename = paste(date, ".tif", sep="")),
              overwrite = TRUE) #format = "GTiff",
}


# loop for Landsat 5
for (subfolder in l5_subfolders) {
  message(paste0("Preprocessing Landsat scene"))
  stackname <- str_split_i(subfolder, "/", -1)
  date <- str_extract(stackname, "\\d{8}") # pattern for filename
  tif_files <- list.files(path = subfolder, pattern = "B.*.TIF$", full.names = TRUE)
  raster_stack <- rast(tif_files)
  raster_stack_cropped <- crop(raster_stack, aoi_extent)
  names(raster_stack_cropped) <- bands_l5
  writeRaster(raster_stack_cropped, file.path(lsat_path, filename = paste(date, ".tif", sep="")),
              overwrite = TRUE) #format = "GTiff",
}


# Overview preprocessed Lsat data
lsat_files <- list.files(lsat_path, full.names = T)
lsat_files

# load individual preprocessed files
lsat_1989 <- rast("path/to/file/data/FinalData/19890824.tif")
lsat_1994 <- rast("path/to/file/data/FinalData/19940721.tif")
lsat_1999 <- rast("path/to/file/data/FinalData/19990804.tif")
lsat_2010 <- rast("path/to/file/data/FinalData/20100818.tif")
lsat_2014 <- rast("path/to/file/data/FinalData/20140712.tif")
lsat_2019 <- rast("path/to/file/data/FinalData/20190710.tif")
lsat_2022 <- rast("path/to/file/data/FinalData/20220702.tif")


# take a first look
viewRGB(as(lsat_1989, "Raster"), r= 5, g= 4, b= 3, maxpixels=58074741) # L5 -> band numbers differ from L8
viewRGB(as(lsat_2022, "Raster"), r= 6, g= 5, b= 4, maxpixels=58074741)


## --------------------- Calculate Indices-------------------------------------------##
# ------------------------------------------------------------------------------------#

## ------------ Calculate NDWI (Normalized Difference Water Index)

# preparation for loop
lsat_list <- list(lsat_1989, lsat_1994, lsat_1999, lsat_2010, lsat_2014, lsat_2019, lsat_2022)
ndwi_list <- list()
ndwi_names <- c("ndwi_1989", "ndwi_1994", "ndwi_1999", "ndwi_2010", "ndwi_2014", "ndwi_2019", "ndwi_2022")

# for loop & rename
for (i in 1:length(lsat_list)) {
  ndwi <- fun_ndwi(lsat_list[[i]]$G, lsat_list[[i]]$NIR)
  ndwi_list[[i]] <- ndwi
}
names(ndwi_list) <- ndwi_names

# visualize
terra::plot(ndwi_list[[1]])
terra::plot(ndwi_list[[3]])
terra::plot(ndwi_list[[5]])
terra::plot(ndwi_list[[7]])
terra::plot(ndwi_list$ndwi_2010)


## ------------ Calculate NDVI (Normalized Difference Vegetation Index)

# preparation for loop
ndvi_list <- list()
ndvi_names <- c("ndvi_1989", "ndvi_1994", "ndvi_1999", "ndvi_2010", "ndvi_2014", "ndvi_2019", "ndvi_2022")

# for loop & rename
for (i in 1:length(lsat_list)) {
  ndvi <- fun_ndvi(lsat_list[[i]]$NIR, lsat_list[[i]]$R)
  ndvi_list[[i]] <- ndvi
}
names(ndvi_list) <- ndvi_names

# visualize
terra::plot(ndvi_list[[1]])
terra::plot(ndvi_list$ndvi_2019)


## ------------ Calculate NDSI (Normalized Difference Snow Index)

# preparation for loop
ndsi_list <- list()
ndsi_names <- c("ndsi_1989", "ndsi_1994", "ndsi_1999", "ndsi_2010", "ndsi_2014", "ndsi_2019", "ndsi_2022")

# for loop & rename
for (i in 1:length(lsat_list)) {
  ndsi <- fun_ndsi(lsat_list[[i]]$G, lsat_list[[i]]$SWIR1)
  ndsi_list[[i]] <- ndsi
}
names(ndsi_list) <- ndsi_names

# visualize
terra::plot(ndsi_list[[1]])
terra::plot(ndsi_list$ndsi_2019)


## ------------ Calculate NDGI (Normalized Difference Glacier Index)

# preparation for loop
ndgi_list <- list()
ndgi_names <- c("ndgi_1989", "ndgi_1994", "ndgi_1999", "ndgi_2010", "ndgi_2014", "ndgi_2019", "ndgi_2022")

# for loop & rename
for (i in 1:length(lsat_list)) {
  ndgi <- fun_ndgi(lsat_list[[i]]$G, lsat_list[[i]]$R)
  ndgi_list[[i]] <- ndgi
}
names(ndgi_list) <- ndgi_names

# visualize
terra::plot(ndgi_list[[1]])
terra::plot(ndgi_list$ndgi_2019)


## ------------ Calculate NDWI_mod (Normalized Difference Water Index Modified)

# preparation for loop
ndwi_mod_list <- list()
ndwi_mod_names <- c("ndwi_m_1989", "ndwi_m_1994", "ndwi_m_1999", "ndwi_m_2010", "ndwi_m_2014", "ndwi_m_2019", "ndwi_m_2022")

# for loop & rename
for (i in 1:length(lsat_list)) {
  ndwi_m <- fun_ndwi_mod(lsat_list[[i]]$G, lsat_list[[i]]$NIR)
  ndwi_mod_list[[i]] <- ndwi_m
}
names(ndwi_mod_list) <- ndwi_mod_names

# visualize
terra::plot(ndwi_mod_list[[1]])
terra::plot(ndwi_mod_list$ndwi_m_2010)




## --------------------- Create Water Mask-------------------------------------------##
# ------------------------------------------------------------------------------------#

# NOTE: Depending on study area and other factors, the threshold can vary; individual assessment
# necessary!!

# water mask derived from NDGI with a threshold of 0.03 (chosen based on previous assessments)
water_mask_ndgi <- list()
water_names <- c("w_1989", "w_1994", "w_1999", "w_2010", "w_2014", "w_2019", "w_2022")

water_mask_ndgi <- lapply(ndgi_list, function(r) {
  mask_r <- r > 0.05 #threshold
  r_masked <- mask_r
  r_masked[r_masked == 0] <- NA # remove NA values, so only water pixels left
  mask(r_masked, mask_r)
})

names(water_mask_ndgi) <- water_names

# have a first look:
terra::plot(water_mask_ndgi$w_2022, col = "blue")




# water mask derived from NDWI with a threshold of 0.3 (chosen based on previous assessments)
water_mask_ndwi <- list()
ndwi_water_names <- c("ndwi_w_1989", "ndwi_w_1994", "ndwi_w_1999", "ndwi_w_2010", "ndwi_w_2014", "ndwi_w_2019", "ndwi_w_2022")

water_mask_ndwi <- lapply(ndwi_list, function(r) {
  mask_r <- r > 0.2 # threshold
  r_masked <- mask_r
  r_masked[r_masked == 0] <- NA # remove NA values, so only water pixels left
  mask(r_masked, mask_r)
})

names(water_mask_ndwi) <- ndwi_water_names

# have a first look:
terra::plot(water_mask_ndwi$ndwi_w_2022, col = "blue")
terra::plot(water_mask_ndwi$ndwi_w_2010, col = "blue")
terra::plot(water_mask_ndwi$ndwi_w_1989, col = "blue")



## Visualization (compare water mask with rgb)

# plotRGB: alpha -> adjust transparency
plotRGB(as(lsat_1989, "Raster"),r= 6, g= 5, b= 4, maxpixels = 58074741,
        stretch = "lin", alpha = 190, axes = F, main = "Water mask assessment 2014")
plot(water_mask_ndwi$ndwi_w_1989, col = "violet", add = T, axes = F) # True = water from water mask


# plot & safe as png
png("WaterMaskAssessment2014.png", width = 800, height = 800, unit = "px") # adjust where to save it

par(mar = c(5, 5, 3, 3))
plotRGB(as(lsat_2014, "Raster"), r = 6, g = 5, b = 4, maxpixels = 58074741,
        stretch = "lin", alpha = 190, axes = T) # only if axes = T ; 'main' is honored
plot(water_mask_ndwi$ndwi_w_2014, col = "violet", add = TRUE, axes = FALSE) # True = water from water mask
title(main = "Water Mask Assessment 2014",
      font.main = 2, col.main = "black", cex.main = 2, family = "Avenir")
legend("topright", legend = "True = water from water mask", fill = "violet", cex = 1)

dev.off()


## --------------------- Create Lake Outlines ----------------------------------------##
# ------------------------------------------------------------------------------------#


polygon_2010 <- as.polygons(water_mask_ndwi$ndwi_w_1989)
plot(polygon_2010)

lake_outlines <- list()
lake_names <- c("l_1989", "l_1994", "l_1999", "l_2010", "l_2014", "l_2019", "l_2022")

for (i in 1:length(water_mask_ndwi)) {
  indi_lake <- as.polygons(water_mask_ndwi[[i]])
  lake_outlines[[i]] <- indi_lake
}

names(lake_outlines) <- lake_names

# create and save plot

png("lake_outlines.png", width = 600, height = 800, unit = "px") # adjust where to save it

plotRGB(lsat_2022, r = 6, g = 5, b = 4)
plot(lake_outlines$l_1989, border = "red", add = T)
plot(lake_outlines$l_1999, border = "blue", add = T)
plot(lake_outlines$l_2022, border = "green", add = T)
title(main = "Glacial lake outline 1989, 1999, 2022",
      font.main = 2, col.main = "white", cex.main = 3, family = "Avenir",
      line = -3)

dev.off()

## --------------------- Calculate Summary of water cells-----------------------------##
# ------------------------------------------------------------------------------------#

water_pixels <- list()
water_pixels_names <- c("1989", "1994", "1999", "2010", "2014", "2019", "2022")

for (i in 1:length(water_mask_ndwi)) {
  water_pixel_indi <- sum(values(water_mask_ndwi[[i]]) == TRUE, na.rm = TRUE)
  water_pixels[[i]] <- water_pixel_indi
}

names(water_pixels) <- water_pixels_names
print(water_pixels$year_1989)

pixels_df <- data.frame(year = water_pixels_names, pixels = unlist(water_pixels))

# add column with area
pixel_area_m <- 900 # Landsat: 30x30 meter
pixel_area_sqkm <- 0.0009
pixels_df$area_m <- pixels_df$pixels * pixel_area_m
pixels_df$area_sqkm <- pixels_df$pixels * pixel_area_sqkm


# Visualize it
par(mar = c(3,3,3,3))
ggplot(pixels_df, aes(x= year, y= area_sqkm)) +
  geom_point() +
  labs(title = "Area of Glacial Lakes Over Time",
       x = "Year",
       y = "Area [km²]") +
  theme(text = element_text(family = "Avenir")) # change according to your paper template


# visualization without first entry (probably outlier)
# --> see line 247-250 --> a lot of snow/ ice area is part of water mask in year 1989
ggplot(pixels_df[-1,], aes(x = year, y = area_sqkm)) +
  geom_point(shape = 15, color = "blue") +
  geom_smooth(method = "lm") +
  labs(title = "Area of Water Over Time",
       x = "Year",
       y = "Area [km²]") +
  theme(plot.title = element_text(size = 16, face = "bold"),
        axis.title = element_text(size = 14),
        text = element_text(family = "Avenir"))