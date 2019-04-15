# Script function to convert 2a for .SAFE to GTiff
# by Francisco Zambrano Bigiarini (frzambra@gmail.com)
# April 2019

updateS2Tiff <- function(dir_raw,dir_tiff){
  require(sen2r)
  require(purrr)
  
  list_raw <- list.files(dir_raw)
  list_tiff <- list.files(dir_tiff)
  
  dates_raw <- regmatches(list_raw,regexpr("[0-9]{8}",list_raw))
  dates_tiff <- regmatches(list_tiff,regexpr("[0-9]{8}",list_tiff))
  ids <- which(is.na(match(dates_raw,dates_tiff)))
  
  if (length(ids)!=0){
    paste0(dir_raw,list_raw[ids]) %>%
      map(function(x) s2_translate(x,outdir=dir_tiff,format="GTiff"))
  }
  
}


