# Script to manage vectorial data with sf
# by Francisco Zambrano Bigiarini (frzambra@gmail.com)
# May 2019

dir.vec <- '/mnt/discoHemera4TB1/UMayor/Agronomia/PIM/2019-I/Kiwis-Sentinel2/data/spatial/vectorial/'
dir.vi <- '/mnt/discoHemera4TB1/UMayor/Agronomia/PIM/2019-I/Kiwis-Sentinel2/data/spatial/VIs/'
library(sf)
library(raster)
library(lubridate)

ptos1 <- st_read(file.path(dir.vec,'puntos_muestreo _inicio/puntos_de_muestreo.gpkg'))
ptos2 <- st_read(file.path(dir.vec,'puntos_cosecha/puntos_muestreo_cosecha.shp'))

ptosJ <- st_join(ptos1,ptos2,join=st_is_within_distance,dist=5)
ptosJ <- st_transform(ptosJ,32719)

# Extracting EVI
daysclouds <- c(1:6,8,11,14,15,19,23,24,25,32,48,49,50,52:55) #days with clouds

evi <- stack(list.files(file.path(dir.vi,'EVI'),pattern='*.tif$',full.names=TRUE)[-daysclouds])

dataEVI <- data.frame(t(raster::extract(evi,ptosJ)))

names(dataEVI) <- as.character(ptosJ$name)
dataEVI$time <- ymd(unlist(regmatches(row.names(dataEVI),gregexpr('[0-9]{8}',row.names(dataEVI)))))
  
library(tidyverse)

dataEVI %>% gather(punto,valor,-time) %>% 
  ggplot(.,aes(time,valor)) + geom_point() +
  facet_wrap(~punto,scale='free')

dataEVI %>% gather(punto,valor,-time) %>% 
  ggplot(.,aes(time,valor,group=time)) + geom_boxplot() 
  
