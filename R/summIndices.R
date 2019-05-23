summIndices <- function(indices,dir){
  indices %>%  
    map(function(vis){
      dirs <- list.files(paste0(dir,vis),pattern='*.tif$')
      dates <- regmatches(dirs,regexpr("[0-9]{8}",dirs))
      if(length(dates)==0) {return(0)} else {
        return(data.frame(index=rep(vis,length(dates)),dates=dates))
      }
    }) %>% reduce(rbind) -> res1 
  
  if (res1[1,1]==0){
    return(0)
  } else {
    res1 %>% 
      group_by(index) %>% 
      summarize(n=n(),lastDate=sort(dates)[length(dates)]) %>% 
      mutate(lastDate=as.character(lastDate))-> resumen
    
    return(resumen)
  }
}
