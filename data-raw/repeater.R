Parking20190109 <- 
  lapply(dir(path = "~/MelbourneParking2019/data-raw/2019/1/9",
             pattern = "\\.tsv$",
             full.names = TRUE),
         fread) %>%
  rbindlist

fwrite()

fwrite(Parking20190109[order(bay_id, Now), 
                       .(bay_id,
                         Occupied = as.integer(status == "Present"),
                         Time = Now)],
       tempf <- tempfile(fileext = ".tsv"),
       sep = "\t")

do_fread <- function(file.ctsv) {
  o <- fread(file.ctsv, select = c("bay_id", "st_marker_id", "lat", "lon"))
  o[, File := sub("\\.(c|t)sv$", "", basename(file.ctsv))]
  o
}

Parking20190110_mtime <-
  lapply(dir(path = "~/MelbourneParking2019/data-raw/2019/1/10",
             pattern = "\\.(t|c)sv$",
             full.names = TRUE),
         do_fread) %>%
  rbindlist(use.names = TRUE,
            fill = TRUE)


