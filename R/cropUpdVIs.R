# Function script to crop and update VIs
# by Francisco Zambrano Bigiarini (frzambra@gmail.com)
# April 2019

cropUpdVIs <- function(pol,dir_vis,dir_cvis,indices){
  
  require(purrr)
  res_vis <- summIndices(indices,dir_vis)
  res_cvis <- summIndices(indices,dir_cvis)
  
  if(res_cvis==0){
    lastDate_cvis <- "20170101"
  } else if(length(unique(res_vis[,2]))==1 & length(unique(res_vis[,3]))==1 &
            length(unique(res_cvis[,2]))==1 & length(unique(res_cvis[,3]))==1){
    
    lastDate_cvis <- as.numeric(res_cvis[1,3])
    
  } else {stop('error in the number of files')}
  
  pol <- st_transform(pol,"+proj=utm +zone=19 +south +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0")
  
  indices %>% 
    map(function(index){
      dir.create(paste0(dir_cvis,index))
      lf <- list.files(paste0(dir_vis,index))
      dates_vis <- as.numeric(regmatches(lf,regexpr("[0-9]{8}",lf)))
      ids <- which(dates_vis > lastDate_cvis)
      vi <- stack(paste0(dir_vis,index,'/',lf[ids]))
      vi <- subset(vi,sort(substr(names(vi),7,14),index.return=TRUE)$ix)
      viC <- crop(vi,pol)
      viM <- mask(viC,pol)
      writeRaster(viM,paste0(dir_cvis,index,'/',names(viM)),bylayer=TRUE,suffix='names',format='GTiff')
    })
}
  
  

  