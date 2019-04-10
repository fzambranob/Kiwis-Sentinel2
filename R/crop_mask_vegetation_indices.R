# Script to crop/mask vegetation indices for a plot of Kiwis in San Fernando, Chile
# Francisco Zambrano Bigiarini (frzambra@gmail.com)
# March 2019

library(raster)
library(sf)
library(tidyverse)

dir.data <- '/mnt/discoHemera4TB1/UMayor/Agronomia/PIM/2019-I/estres_hidrico_kiwis/data/spatial/vectorial/'
in.vis <- '/mnt/discoHemera4TB2/data/rasters/Procesados/Sentinel2/VIs/'
out.vis <- '/mnt/discoHemera4TB1/UMayor/Agronomia/PIM/2019-I/estres_hidrico_kiwis/data/spatial/VIs/'

pol <- st_read(paste0(dir.data,'cuarteles_kiwis.gpkg'))
pts <- st_read(paste0(dir.data,'puntos_de_muestreo.gpkg'))

pol <- st_transform(pol,as.character(crs(ndvi)))
pts <- st_transform(pts,as.character(crs(ndvi)))

indices <- list.files(in.vis)

indices %>% 
  map(function(index){
    dir.create(paste0(out.vis,index))
    lf <- list.files(paste0(in.vis,index))
    vi <- stack(paste0(in.vis,index,'/',lf[grep('_2018|_2019',lf)]))
    vi <- subset(vi,sort(substr(names(vi),7,14),index.return=TRUE)$ix)
    viC <- crop(vi,pol)
    viM <- mask(viC,pol)
    writeRaster(viM,paste0(out.vis,index,'/'),bylayer=TRUE,suffix='names',format='GTiff')
  })