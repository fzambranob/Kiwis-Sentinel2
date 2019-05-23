# Script to extract VIs values in points
# by Francisco Zambrano Bigiarini (frzambra@gmail.com)
# April 2019

in.vis <- 'data/spatial/VIs/'
in.gpkg <- 'data/spatial/vectorial/'

indices <- list.files(in.vis)

library(stars)
library(sf)
library(purrr)
library(lubridate)
library(tidyverse)

pts <- st_read(file.path(in.gpkg,'puntos_de_muestreo.gpkg'))
pts <- st_transform(pts,"+proj=utm +zone=19 +south +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0")

data <- indices %>% 
  map(function(index) {
    lf <- list.files(paste0(in.vis,index),pattern='*.tif$',full.names=TRUE)
    ind <- sort(as.numeric(regmatches(lf,regexpr("[0-9]{8}",lf))),index.return=TRUE)
    new_list <- lf[ind$ix]
    dates <- ymd(ind$x)
    vi <- read_stars(new_list,along='time')
    vi <- st_set_dimensions(vi,'time',values= dates)
    final <- as.data.frame(st_join(pts,st_as_sf(st_as_stars(vi[pts]))))
    final <- as.data.frame(t(final[,c(-1,-53)]))
    names(final) <- names
    final$index <- index
    final$time <- dates
    return(final)
  }) %>% 
  reduce(rbind)

#summarizing for all the points

data %>% select(-`Hilera 3`) %>%  gather(sensor,value,-time,-index) %>% 
  ggplot(.,aes(sensor,value,fill=sensor)) +
  geom_boxplot() 

  
#Extracting VIs in the trees with Zim sensor
dataZim <- data[,39:45]

dataZim %>% gather(sensor,value,-time,-index) %>% 
  ggplot(.,aes(time,pressure,colour=sensor)) +
  geom_point()+geom_line() +
  facet_grid(index~sensor,scale='free')

dataZim %>% gather(sensor,value,-time,-index) %>% 
  ggplot(.,aes(sensor,value,fill=sensor)) +
  geom_boxplot()
