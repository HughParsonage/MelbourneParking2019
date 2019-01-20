
  
  provide.dir(the_dir <- paste0("data-raw/2019", "/", month(Now), "/", yday(Now)))
  url <- "https://data.melbourne.vic.gov.au/api/views/vh2v-4nfs/rows.csv?accessType=DOWNLOAD"
  res <<- download.file(url, 
                       mode = "wb",
                       cacheOK = FALSE,
                       destfile = paste0(the_dir, "/", HourMin(Now), ".csv"),
                       quiet = TRUE)



