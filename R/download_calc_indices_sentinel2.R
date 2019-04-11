#!/usr/bin/env Rscript
# script to download sentinel2 data
# by Francisco Zambrano (frzambra@gmail.com)
# January 2019

library(sen2r)
library(sf)
library(tidyverse)
library(lubridate)

# where is the spatial polygon
dir.data <- '../data/spatial/vectorial/'
dir.sent <- '/mnt/discoHemera4TB2/data/rasters/raw/Sentinel2/OHiggins/2A/'
out.tiff <- '/mnt/discoHemera4TB2/data/rasters/Procesados/Sentinel2/GTiff/'
out.vis <- '/mnt/discoHemera4TB2/data/rasters/Procesados/Sentinel2/VIs/'

#loading spatial features for the location in which the sentinel2 data is required
#.gpkg is a geopackage extension

pol <- st_read(paste0(dir.data,'cuarteles_kiwis.gpkg'))

# defining time interval for which the images will be downloaded

dir <- list.files(dir.sent)

#extracting dates 
dates <- regmatches(dir,regexpr("[0-9]{8}",dir))
dates <- sort(ymd(dates))
lastDate <- dates[length(dates)]

#defining 
time_window <- c(lastDate+1, Sys.Date())
list <- s2_list(
  spatial_extent=pol,
  time_interval=time_window)

# Downloading sentinel2 data
s2_download(list,
            outdir=dir.sent)

# #in case for level 1LC
# paste0(dir.sent,list) %>%
#   map(function(x) sen2cor(x,outdir=out.tiff))

#for level 2A
paste0(dir.sent,names(list)) %>%
  map(function(x) s2_translate(x,outdir=out.tiff,format="GTiff"))

#Calculating vegetation indices from Sentinel2 data
lf <- list.files(out.tiff,pattern='*.tif$',full.names=TRUE)
indices <- c('NDVI','EVI','Rededge1','NBR','LCI','GVMI',
             'NDII','NDII2','RDI','CARI','NDMI')
s2_calcindices(lf,outdir = out.vis,indices=indices)
