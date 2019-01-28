library(magrittr)
library(hutils)
library(data.table)
collect_day <- function(day_folder = NULL, on_hit = c("stop", "skip", "overwrite")) {
  if (is.null(day_folder)) {
    Today <- format(Sys.Date() - 1, "%Y/%m/%d")
    Today <- gsub("/0", "/", Today, fixed = TRUE)
    day_folder <- paste0("data-raw/", Today)
    stopifnot(dir.exists(day_folder))
  }
  on_hit <- match.arg(on_hit)
  csv2tsv <- function(file.csv, halt = TRUE, skip = TRUE) {
    stopifnot(endsWith(file.csv, ".csv"))
    file.tsv <- sub("\\.csv$", ".tsv", file.csv)
    
    if (file.exists(file.tsv)) {
      if (halt) {
        stop(file.tsv, " exists.")
      } else if (skip) {
        return(NULL)
      }
    } else {
      fread(file.csv, select = c("bay_id", "status")) %>%
        .[, .(Time = as.character(file.mtime(file.csv)),
              Occupied = as.integer(status != "Unoccupied"),
              bay_id)] %>%
        setkey(bay_id) %>%
        fwrite(file.tsv, sep = "\t")
    }
  }
  stopifnot(dir.exists(day_folder))
  files.csv <- dir(path = day_folder,
                   pattern = "\\.csv$",
                   full.names = TRUE)
  for (file.csv in files.csv) {
    switch(on_hit, 
           "stop" = csv2tsv(file.csv, halt = TRUE),
           "skip" = csv2tsv(file.csv, halt = FALSE, skip = TRUE),
           "overwrite" = csv2tsv(file.csv, halt = FALSE, skip = FALSE),
           csv2tsv(file.csv))
  }
  return(day_folder)
}
library(withr)
divide_into_hour_folders <- function(folder) {
  with_dir(folder,
           {
             files.tsv <- dir(pattern = "\\.tsv")
             for (hr in formatC(0:24, flag = "0", width = 2)) {
               if (dir.exists(paste0("H", hr))) {
                 break
               }
               provide.dir(paste0("H", hr))
               for (file.tsv in files.tsv[startsWith(files.tsv, hr)]) {
                 if (!file.rename(file.tsv, paste0("H", hr, "/", file.tsv))) {
                   stop(file.tsv)
                 }
               }
             }
             
           })
}
# divide_into_hour_folders(collect_day("data-raw/2019/1/25"))
divide_into_hour_folders(collect_day())

        
