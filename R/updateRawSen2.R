# Script function to update 

updateRawSen2 <- function(pol,dir_sent){
  # defining time interval for which the images will be downloaded
  
  dir <- list.files(dir_sent)
  
  #extracting dates 
  dates <- regmatches(dir,regexpr("[0-9]{8}",dir))
  dates <- sort(ymd(dates))
  lastDate <- dates[length(dates)]
  
  #defining 
  time_window <- c(lastDate+1, Sys.Date())
  list <- s2_list(
    spatial_extent=pol,
    time_interval=time_window)
  
  if(length(list)!=0){
    # Downloading sentinel2 data
    s2_download(list,
                outdir=dir_sent)
  }
  
}


