# Script to analyze quality data for Kiwis
# by Francisco Zambrano Bigiarini (frzambra@gmail.com)
# May 2019

library(tidyverse)

# Quality data
data <- read.csv2("measures/quality/quality_kiwis_measures.csv")

names(data) <- c('cod','muestra','submuestra','peso_freso','cal_ecua','cal_lon','firmeza','brix')

data$cod <- gsub(' ','',data$cod,fixed=TRUE)


# Leaf water potential
data <- read.csv("data/measures/potential/sholander.csv",dec=',')
saveRDS(data,'data/rds/data_cholander.rds')

library(lubridate)
data$Fecha <- dmy(data$Fecha)

ggplot(data,aes(Fecha,Mediciones,colour=codigo)) + geom_point() + geom_line() +facet_wrap(~codigo)

ggplot(data,aes(as.factor(Fecha),Mediciones)) + geom_boxplot()

ggplot(data,aes(as.factor(codigo),Mediciones)) + geom_boxplot()
