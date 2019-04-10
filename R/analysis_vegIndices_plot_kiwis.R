# Script to analyze vegetation indices for a plot of Kiwis in San Fernando, Chile
# Francisco Zambrano Bigiarini (frzambra@gmail.com)
# March 2019

library(raster)
library(tidyverse)
library(lubridate)

in.vis <- '/mnt/discoHemera4TB1/UMayor/Agronomia/PIM/2019-I/estres_hidrico_kiwis/data/spatial/VIs/'

indices <- list.files(in.vis)

data <- indices %>% 
  map(function(index) {
    lf <- list.files(paste0(in.vis,index),full.names=TRUE)
    vi <- stack(lf)
    vals <- cellStats(vi,'mean')
    return(vals)
    }) %>% 
  reduce(cbind)

data <- as.data.frame(data)
names(data) <- indices
data$date <- ymd(substr(row.names(data),9,16))

data %>% dplyr::select(-NDII2) %>% gather(indice,valor,-date) %>% 
  ggplot(.,aes(as.POSIXct(date),valor)) + 
  geom_point() + geom_line() +
  geom_smooth()+
  scale_x_datetime(breaks='15 days',date_labels = "%d-%b") +
  facet_wrap(~indice,scales='free',nrow=2) + 
  labs(title='Índices vegetacionales temporada 2018-2019. Sentinel-2 (2A/2B)',
       subtitle =' Cuartel de Kiwis, Liceo Agrícola, San Fernando',
       y='Valor índice')+
  theme_minimal() +
  theme(axis.text.x = element_text(angle=90),axis.title.x = element_blank())
ggsave('Variacion_temporal_indices_kiwis.png',scale=1.5,width=10,height=4)
