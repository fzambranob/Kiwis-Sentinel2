# script to run with crontab to update Sentine-2 VIs for the plot with kiwis
# by Francisco Zambrano Bigiarini (frzambra@gmail.com)
# April 2019

dir.main <- '/mnt/discoHemera4TB1/UMayor/Agronomia/PIM/2019-I/Kiwis-Sentinel2/'

require(lubridate)
require(sf)
require(sen2r)

source(file.path(dir.main,'R/updateRawSen2.R'))
source(file.path(dir.main,'R/updateS2Tiff.R'))
source(file.path(dir.main,'R/updatVIs.R'))
source(file.path(dir.main,'R/cropUpdVIs.R'))
source(file.path(dir.main,'R/summIndices.R'))


dir_raw <- '/mnt/discoHemera4TB2/data/rasters/raw/ESA/Sentinel2/OHiggins/2A/'
dir_tiffs <- '/mnt/discoHemera4TB2/data/rasters/Procesados/Sentinel2/GTiff/'
dir_vis <- '/mnt/discoHemera4TB2/data/rasters/Procesados/Sentinel2/VIs/'
dir.data <- 'data/spatial/vectorial/'
dir_cvis <- '/mnt/discoHemera4TB1/UMayor/Agronomia/PIM/2019-I/Kiwis-Sentinel2/data/spatial/VIs/'

indices <- c('NDVI','EVI','Rededge1','NBR','LCI','GVMI',
             'NDII','NDII2','RDI','CARI','NDMI')

pol <- st_read(paste0(file.path(dir.main,'data/spatial/vectorial/','cuarteles_kiwis.gpkg')))
pol <- st_transform(pol,"+proj=utm +zone=19 +south +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 ")

updateRawSen2(pol,dir_raw)
updateS2Tiff(dir_raw,dir_tiffs)
updateVIs(dir_tiffs,dir_vis,indices)

indices <- c('NDVI','EVI','Rededge1','NBR','LCI','GVMI',
             'NDII','NDII2','RDI','CARI','NDMI')

cropUpdVIs(pol,dir_vis,dir_cvis,indices)
