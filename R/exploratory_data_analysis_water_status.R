# Script to analyze quality data for Kiwis
# by Francisco Zambrano Bigiarini (frzambra@gmail.com)
# May 2019

dir <- '/mnt/discoHemera4TB1/UMayor/Agronomia/PIM/2019-I/Kiwis-Sentinel2/data/'

library(tidyverse)

# Quality data
data <- read.csv2(file.path(dir,"measures/quality/quality_kiwis_measures.csv"))

names(data) <- c('cod','muestra','submuestra','peso_freso','cal_ecua','cal_lon','firmeza','brix')

data$cod <- gsub(' ','',data$cod,fixed=TRUE)


# Leaf water potential
data <- read.csv2(file.path(dir,"measures/potential/sholander.csv"),sep=',')
library(lubridate)
data$Fecha <- dmy(data$Fecha)

ggplot(data,aes(Fecha,Mediciones,colour=codigo)) + geom_point() + geom_line() +facet_wrap(~codigo)

ggplot(data,aes(as.factor(Fecha),Mediciones)) + geom_boxplot()

ggplot(data,aes(as.factor(codigo),Mediciones)) + geom_boxplot()
