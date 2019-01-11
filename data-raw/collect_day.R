
collect_day <- function(day_folder) {
  csv2tsv <- function(file.csv, halt = TRUE) {
    stopifnot(endsWith(file.csv, ".csv"))
    file.tsv <- sub("\\.csv$", ".tsv", file.csv)
    
    if (file.exists(file.tsv)) {
      if (halt) {
        stop(file.tsv, " exists.")
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
    csv2tsv(file.csv)
  }
}

        
