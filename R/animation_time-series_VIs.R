# Script to create an animation with the time-series of VIs
# by Francisco Zambrano Bigiarini (frzambra@gmail.com)
# October 2019

library(stars)
library(lubridate)
library(viridis)
library(ggplot2)
library(raster)
library(tidyverse)

indices <- c('NDVI','EVI','Rededge1','NBR','LCI','GVMI',
             'NDII','NDII2','RDI','CARI','NDMI')

n <- 11
index <- indices[n]

list <- list.files(file.path('data/spatial/VIs/',index),pattern='.tif$',full.names=TRUE)
ind <- sort(as.numeric(regmatches(list,regexpr("[0-9]{8}",list))),index.return=TRUE)
new_list <- list[ind$ix]
dates <- ymd(ind$x)

daysclouds <- c(1:6,8,11,14,15,19,23,24,25,32,48,49,50,52:55,79:80,84:85) #days with clouds
vi <- stack(new_list[-daysclouds])
pol <- st_read('data/spatial/vectorial/cuarteles_kiwis.gpkg')
pol <- st_transform(pol,"+proj=utm +zone=19 +south +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0 ")
viC <- crop(vi,pol)*10e-5

aux<- subset(viC,1)
aux[] <- NA
auxs <- stack(lapply(1:40, function(i) aux)) 
names(auxs) <- format(seq.Date(ymd(20191021),length.out=40,by=5),"%Y%m%d")
viC <- stack(viC, auxs)
viCP <- rasterToPoints(viC)
viCP <- as.data.frame(viCP)
viCP %>% gather(index,value,-x,-y) -> data

data$dates <- ymd(regmatches(data$index,regexpr('[0-9]{8}',data$index)))
data$month <- as.numeric(format(data$dates,'%m'))

#animation map
library(gganimate)
map1 <- data %>% filter(dates >= "2018-09-01" & dates <= "2019-05-30") %>% 
  ggplot(.) + geom_tile(aes(x,y,fill=value)) +
  coord_equal() +
  #facet_wrap(~time,ncol=10) +
  theme_void() +
  scale_fill_gradient2(indices[n],low="red", mid="yellow",high="darkgreen",midpoint=0,na.value="transparent") +
  theme(strip.text = element_text(size=5),
        legend.position = 'bottom',legend.text = element_text(size=5))+
  transition_time(dates) +
  labs(title = "Date: {frame_time}")

map2 <- data %>% filter(dates >= "2019-09-01" & dates <= "2020-05-30") %>% 
  ggplot(.) + geom_tile(aes(x,y,fill=value)) +
  coord_equal() +
  #facet_wrap(~time,ncol=10) +
  theme_void() +
  scale_fill_gradient2(indices[n],low="red", mid="yellow",high="darkgreen",midpoint=0,na.value="transparent") +
  theme(strip.text = element_text(size=5),
        legend.position = 'bottom',legend.text = element_text(size=5))+
  transition_time(dates) +
  labs(title = "Date: {frame_time}")

map1_gif <- gganimate::animate(map1,width=240,height=240)
map2_gif <- gganimate::animate(map2,width=240,height=240)

data %>% filter(dates >= "2018-09-01" & dates <= "2019-05-30") %>% mutate(Season="2018-2019") -> dataS1
data %>% filter(dates >= "2019-09-01" & dates <= "2020-05-30") %>% mutate(Season="2019-2020") -> dataS2

dataS1$dates <- dataS1$dates + years(1)
dataJ <- rbind(dataS1,dataS2)

ts <- dataJ %>% group_by(dates,Season) %>% summarise(value=mean(value,na.rm=TRUE)) %>% mutate(Season = as.factor(Season)) %>% 
ggplot(.,aes(as.POSIXct(dates),value,colour=Season)) + 
  geom_line() + geom_point() +
  scale_x_datetime(date_breaks='1 month',date_label ='%d-%m')+
  labs(y=index)+
  theme_minimal()+
  theme(axis.title.x = element_blank())+
  transition_reveal(dates) 

ts_gif <- gganimate::animate(ts,width=480,height=240)

map1_mgif<-image_read(map1_gif)
map2_mgif<-image_read(map2_gif)
ts_mgif<-image_read(ts_gif)

new_gif <- image_append(c(map1_mgif[1], map2_mgif[1],ts_mgif[1]))

for(i in 2:100){
  combined <- image_append(c(map1_mgif[i], map2_mgif[i],ts_mgif[i]))
  new_gif<-c(new_gif,combined)
}

image_write(new_gif, paste0('gifs/',indices[n],'_animation.gif'))

