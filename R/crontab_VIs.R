# script to run with crontab to update Sentine-2 VIs for the plot with kiwis
# by Francisco Zambrano Bigiarini (frzambra@gmail.com)
# April 2019

dir_raw <- '/mnt/discoHemera4TB2/data/rasters/raw/Sentinel2/OHiggins/2A'
dir_tiffs <- '/mnt/discoHemera4TB2/data/rasters/Procesados/Sentinel2/GTiff/'
dir_vis <- '/mnt/discoHemera4TB2/data/rasters/Procesados/Sentinel2/VIs/'
indices <- c('NDVI','EVI','Rededge1','NBR','LCI','GVMI',
             'NDII','NDII2','RDI','CARI','NDMI')

updateS2Tiff(dir_raw,dir_tiff)
updateVIs(dir_tiffs,dir_vis,indices)

dir.data <- 'data/spatial/vectorial/'
dir_cvis <- '/mnt/discoHemera4TB1/UMayor/Agronomia/PIM/2019-I/Kiwis-Sentinel2/data/spatial/VIs/'
dir_vis <- '/mnt/discoHemera4TB2/data/rasters/Procesados/Sentinel2/VIs/'

pol <- st_read(paste0(dir.data,'cuarteles_kiwis.gpkg'))
pol <- st_transform(pol,as.character(crs(ndvi)))

indices <- c('NDVI','EVI','Rededge1','NBR','LCI','GVMI',
             'NDII','NDII2','RDI','CARI','NDMI')

cropUpdVIs(pol,dir_vis,dir_cvis,indices)