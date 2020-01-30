# Script function to update 

updateRawSen2 <- function(pol,dir_sent,time_interval=c(as.Date("2018-08-01"), Sys.Date())){
  # defining time interval for which the images will be downloaded
  
  require(sen2r)
  dir <- list.files(dir_sent)
  
  #extracting dates 
  dates <- regmatches(dir,regexpr("[0-9]{8}",dir))
  dates <- sort(dates)
  
  #defining

  list <- s2_list(
    spatial_extent=pol,time_interval=time_interval)
  datesS2 <- substr(attr(list,'names'),12,19)
  
  indLeft <- which(is.na(match(datesS2,dates)))
  
  

  if(length(list)!=0){
    # Downloading sentinel2 data
    s2_download(list[indLeft],
                outdir=dir_sent)
  }
  
}


