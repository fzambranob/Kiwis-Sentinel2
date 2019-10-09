# Script to merge measurements data
# by Francisco Zambrano Bigiarini (frzambra@gmail.com)
# July 2019

library(tidyverse)
dataZIM <- readRDS('data/rds/data_turgor.rds')
dataSCH <- readRDS('data/rds/data_scholander.rds')
dataVI <- readRDS('data/rds/data_indices_arboles.rds')

dataZIM$ZIM <- substr(dataZIM$sensor,3,6)
codigoZIM <- read.csv('data/measures/turgorPressure/arbol_zim_codigo.csv')
codigoZIM$ZIM <-  c('1008','1004','1007','1005','1006')
dataZIM <- left_join(dataZIM,codigoZIM,by='ZIM') %>% select(-ZIM,-sensor)
dataZIM$time <- as.Date(dataZIM$time)

dataZIM %>% group_by(time,arbol) %>% 
  summarize(turgor=mean(turgor,na.rm=TRUE)) -> dataZIM

dataZIM %>% ggplot(.,aes(arbol,turgor))+ geom_boxplot() +
  geom_jitter() +
  theme_minimal()

dataZIM %>% ggplot(.,aes(time,turgor,colour=arbol,shape=arbol))+ geom_point() + geom_line()+
  theme_minimal()

dataVI$time <- substr(rownames(dataVI),1,10)

dataVI %>% gather(arbol,valor,-time,-index) -> dataVI
dataVI$time <- ymd(dataVI$time)
dataSCH$Fecha <- dmy(dataSCH$Fecha)

#joining scholander with VIs
data2 <- left_join(dataVI,dataSCH,by=c('arbol' = 'codigo','time' = 'Fecha'))

#joining data2 with ZIM

data3 <- left_join(data2,dataZIM,by=c('arbol' ,'time'))

data4 <- data3 %>% filter(time < "2019-04-15")
data3 %>% group_by(index) %>% 
  do(fit=lm(Mediciones~valor,data=.)) ->lmFits

data3 %>% filter(complete.cases(.)) %>% 
  filter(index %in% c('EVI','NBR','NDII')) %>% 
  group_by(index,arbol) %>% 
  do(fit=lm(Mediciones~valor,data=.)) ->lmFits

library(broom)
tidy(lmFits,fit)

#para todos los arboles
data3 %>% group_by(index) %>% 
  summarize(cor=cor(Mediciones,valor,use='complete.obs'))

#por arbol
data3 %>%  filter(complete.cases(.)) %>% 
  filter(index %in% c('EVI','NBR','NDII')) %>% 
  group_by(index,arbol) %>%
  summarize(cor=cor(Mediciones,valor,use='complete.obs'))

#para todos los arboles
data4 %>% group_by(index) %>% 
  summarize(cor=cor(turgor,valor,use='complete.obs'))

#por arbol
data4 %>% filter(complete.cases(.)) %>% 
  filter(index %in% c('EVI','NBR','NDII')) %>% 
  group_by(index,arbol) %>%
  summarize(cor=cor(turgor,valor,use='complete.obs'))

data4 %>% group_by(index) %>% 
  summarize(cor=cor(turgor,-Mediciones,use='complete.obs'))

library(broom)
tidy(lmFits,fit) %>% print(n=40)

# exploratory analysis
library(ggjoy)
data3 %>% filter(index %in% c('EVI','NDII','NBR')) %>%  
  ggplot(.,aes(x=index,y=valor)) +
  geom_boxplot() +
  labs(x='Índice',y='valor') +
  theme_minimal()

data3 %>% select(valor,Mediciones,turgor) %>%  gather(variables,valores) %>% 
  ggplot(.,aes(x=variables,y=valores)) +
  geom_boxplot() +
  labs(x='Índice',y='valor') +
  theme_minimal()


#para todos los arboles
data3 %>% filter(index %in% c('EVI','NDII','NBR'))  %>%  ggplot(.,aes(Mediciones,valor)) + geom_point() + geom_smooth(method='lm',se=FALSE)+
  facet_wrap(~index+arbol,scale='free') +
  labs(x='Potencial xilemático (bar)',y='Valor índice') +
  theme_minimal()

data4 %>% filter(index %in% c('EVI','NDII','NBR')) %>%  ggplot(.,aes(turgor,valor)) + geom_point() + geom_smooth(method='lm',se=FALSE)+
  facet_wrap(~index)+
  labs(x='Potencial de turgor(Kpa)',y='Valor índice') +
  theme_minimal()

# por árbol
data4 %>% filter(index %in% c('EVI','NDII','NBR')) %>% filter(complete.cases(.)) %>%  ggplot(.,aes(turgor,valor)) + geom_point() + geom_smooth(method='lm',se=FALSE)+
  facet_grid(index~arbol)+
  labs(x='Potencial de turgor(Kpa)',y='Valor índice') +
  theme_minimal()

data3 %>% ggplot(.,aes(turgor,valor)) + geom_point() + geom_smooth(method='lm',se=FALSE)+
  facet_wrap(~index,scale='free')
