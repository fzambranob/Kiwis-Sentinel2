# Script to visualiza sentinel 2 data
# by Francisco Zambrano Bigiarini (frzambra@gmail.com)
# Febraury 2019

dir.tiff <- '/mnt/discoHemera4TB2/data/rasters/Procesados/Sentinel2/GTiff/'
dir.vis <- '/mnt/discoHemera4TB2/data/rasters/Procesados/Sentinel2/VIs/'

library(RStoolbox)
library(raster)

#palette 
breaks <- seq(0, 1, by=0.001)
cols <- colorRampPalette(c("red", "yellow", "darkgreen"))(length(breaks)-1)

sen <- stack(list.files(dir.tiff,full.names=TRUE)[6])
ndvi <- stack(list.files(paste0(dir.vis,'NDVI'),full.names=TRUE)[6])
nbr <- stack(list.files(paste0(dir.vis,'NBR'),full.names=TRUE)[6])
rededge <- stack(list.files(paste0(dir.vis,'Rededge1'),full.names=TRUE)[6])
  
plot(sen,1)
ext<- drawExtent()
senC <- crop(sen,ext)
ndviC <- crop(ndvi,ext)
nbrC <- crop(nbr,ext)
rededgeC <- crop(rededge,ext)
  
ggRGB(senC,4,3,2) + 
  labs(title="Sentinel 2 true color composite from Sentinel 2B",
       subtitle="O'Higgins region, Chile. February 3th, 2019.")+
  theme_minimal() +
  theme(axis.title = element_blank())
ggsave('Sen3Feb_RGB_Sn_Fernando.png',scale=1.2)

ndviC[ndviC>10000] <- NA
ndviC[ndviC<0] <- NA
ggR(ndviC*0.0001, geom_raster = TRUE) +
  labs(title="NDVI from Sentinel 2B",
       subtitle="O'Higgins region, Chile February 3th, 2019")+
  scale_fill_gradientn(name = "NDVI", colours = cols,breaks=seq(-0.75,1,0.2)) +
  theme_void()
ggsave('Sen3Feb_NDVI_Sn_Fernando.png',scale=1.2)

nbrC[nbrC>10000] <- NA
nbrC[nbrC<-3000] <- NA
ggR(nbrC*0.0001, geom_raster = TRUE) +
  labs(title="NBR index from Sentinel 2B",
       subtitle="O'Higgins region, Chile February 3th, 2019")+
  scale_fill_gradientn(name = "NBR", colours = cols,breaks=seq(-0.75,1,0.2)) +
  theme_void()
ggsave('Sen3Feb_NBR_Sn_Fernando.png',scale=1.2)

#rededgeC[rededgeC>10000] <- NA
ggR(rededgeC*0.0001, geom_raster = TRUE) +
  labs(title="Rededge1 index from Sentinel 2B",
       subtitle="O'Higgins region, Chile February 3th, 2019")+
  scale_fill_gradientn(name = "Rededge1", colours = cols,breaks=seq(-0.5,3.5,0.3)) +
  theme_void()
ggsave('Sen3Feb_rededge_Sn_Fernando.png',scale=1.2)
