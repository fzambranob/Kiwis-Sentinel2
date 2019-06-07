# Script for data wrangling of sensor zim
# by Francisco Zambrano Bigiarini (frzambra@gmail.com)
# April 2019

dir <- 'data/measures/turgorPressure/'

data <- read.csv(file.path(dir,'zim_20190201_to_20190530.csv'))

colNames <- paste0(substr(names(data)[2:34],1,1),'.',regmatches(names(data),regexpr("[0-9]{4}.[0-9]{1}",names(data))))

names(data)[2:dim(data)[2]] <- colNames

names(data)[1] <- 'time'

library(lubridate)

data$time <- with_tz(ymd_hms(data$time,tz = "GMT"),'America/La_Paz')

#dates sentinel-2 data

datesS2 <- seq(ymd_hms('2018-02-08 12:00:00',tz='America/La_Paz'),
               ymd_hms('2019-05-30 12:00:00',tz='America/La_Paz'),by = '5 day')

# subset of the data just for pressure

dataY <- data[,c(1,grep('^Y.',names(data)))]

library(tidyverse)

dataY %>% gather(sensor,potencial,-time) %>% 
  group_by(sensor,time=floor_date(time, "1 hour")) %>%
  summarize(potencial=mean(potencial,na.rm=TRUE)) %>% 
  ggplot(.,aes(time,potencial)) + geom_point() +
  facet_wrap(~sensor)

dataY %>% gather(sensor,potencial,-time) %>% 
  group_by(sensor,time=floor_date(time, "1 hour")) %>%
  summarize(potencial=mean(potencial,na.rm=TRUE)) %>% 
  spread(sensor,potencial) %>% 
  select(c(1,2,4,6,9,12,15,18,20,22,25,28,29)) -> dataY

dataY %>% gather(sensor,potencial,-time) %>% 
  ggplot(.,aes(time,potencial)) + geom_line() +
  facet_wrap(~sensor)

dataY %>% gather(sensor,potencial,-time) %>% 
  filter(sensor=='Y.1004.1') %>% 
  ggplot(.,aes(time,potencial)) + geom_point() + geom_line()
  
#extracting turgor pressure at 12:00pm each five days
dataY %>% gather(sensor,potencial,-time) %>% 
  filter(time%in%datesS2) %>% 
  ggplot(.,aes(sensor,potencial)) + geom_boxplot() 

dataY %>% gather(sensor,potencial,-time) %>% 
  filter(time%in%datesS2) %>% 
  ggplot(.,aes(time,potencial,colour=sensor)) + geom_point() + geom_line() +
  facet_wrap(~sensor)



  

