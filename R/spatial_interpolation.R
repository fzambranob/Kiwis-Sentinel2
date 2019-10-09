# Script o make spatila interpolation for data measuerd on kiwis
# by Francisco Zambrano
# July 2018

library(gstat)
library(sp)    
library(sf)
library(raster)
library(tidyverse)

dataSCH <- readRDS('data/rds/data_scholander.rds')
dataSCH %>% group_by(Fecha) %>% drop_na() %>%  summarize(n())
data <- dataSCH %>% drop_na() %>%filter(Fecha=='10-03-2019')

pts <- st_read('data/spatial/vectorial/puntosMuestreo/puntosmuestreo.shp')
pol <- st_read('data/spatial/vectorial/cuarteles_kiwis.gpkg')

pts <- left_join(pts,data,by=c('descrip' = 'codigo'))

pts <- as(pts, 'Spatial')

# Create an empty grid where n is the total number of cells
grd              <- as.data.frame(spsample(pts, "regular", n=50000))
names(grd)       <- c("X", "Y")
coordinates(grd) <- c("X", "Y")
gridded(grd)     <- TRUE  # Create SpatialPixel object
fullgrid(grd)    <- TRUE  # Create SpatialGrid object

proj4string(grd) <- proj4string(pts)

# Interpolate the grid cells using a power value of 2 (idp=2.0)
pts@data <- pts@data[c(-23,-25),]
pts@coords <- pts@coords[c(-23,-25),]

# Create an empty grid where n is the total number of cells
grd              <- as.data.frame(spsample(pts, "regular", n=50000))
names(grd)       <- c("X", "Y")
coordinates(grd) <- c("X", "Y")
gridded(grd)     <- TRUE  # Create SpatialPixel object
fullgrid(grd)    <- TRUE  # Create SpatialGrid object

proj4string(grd) <- proj4string(pts)


idw <- gstat::idw(Mediciones ~ 1, pts, newdata=grd, idp=2.0,na.action=na.omit)
