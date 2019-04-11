summIndices <- function(indices,dir){
  indices %>%  
    map(function(vis){
      dirs <- list.files(paste0(dir,vis),pattern='*.tif$')
      dates <- regmatches(dirs,regexpr("[0-9]{8}",dirs))
      return(data.frame(index=rep(vis,length(dates)),dates=dates))
    }) %>% reduce(rbind) %>% 
    group_by(index) %>% 
    summarize(n=n(),lastDate=sort(dates)[length(dates)]) %>% 
    mutate(lastDate=as.character(lastDate))-> resumen
  return(resumen)
}
