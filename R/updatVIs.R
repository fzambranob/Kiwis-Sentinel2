# Function script to update Vegettion Indices from Sentinel-2
# by Francisco Zambrano Bigiarini (frzambra@gmail.com)
# April 2019

updateVIs <- function(dir_tiffs,dir_vis,indices){
  require(tidyverse)
  
  if (identical(list.files(dir_vis),character(0))){
    indices %>% 
      map(function(index){
        dir.create(paste0(dir_vis,index))
      })
  }
  
  indices %>%  
    map(function(vis){
      dirs <- list.files(paste0(dir_vis,vis))
      dates <- regmatches(dirs,regexpr("[0-9]{8}",dirs))
      
      if (length(dirs) == 0){
        out <- data.frame(index=vis,dates=NA)
      } else {
        out <- data.frame(index=rep(vis,length(dates)),dates=dates)
      }
      return(out)
    }) %>% reduce(rbind) %>% 
    group_by(index) %>% 
    summarize(n=n(),lastDate=sort(dates)[length(dates)]) %>% 
    mutate(lastDate=as.character(lastDate))-> resumen
  
  if (is.na(unique(resumen[,3]))) {
    currFiles <- list.files(dir_tiffs)
    s2_calcindices(file.path(dir_tiffs,currFiles),outdir = dir_vis,indices=indices)
  } else if (length(unique(resumen[,2]))==1 & length(unique(resumen[,3]))==1){
    currFiles <- list.files(dir_tiffs)
    lastDate <- as.numeric(resumen[1,3])
    dates <- as.numeric(regmatches(currFiles,regexpr("[0-9]{8}",currFiles)))
    ids <- which(dates>lastDate)
    s2_calcindices(file.path(dir_tiffs,currFiles[ids]),outdir = dir_vis,indices=indices)
  } else {
    stop('The number of files per VIs are not equal')
  }
  
}



  
  
  
  
  