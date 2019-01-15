library(data.table)
library(hutils)
latlon_by_bayid <-
  fread("data-raw/2019/1/11/000000.csv", select = c("bay_id", "lat", "lon"), key = "bay_id")

stopifnot(has_unique_key(latlon_by_bayid))

provide.dir("data-raw/meta")

fwrite(latlon_by_bayid, "data-raw/meta/latlon_by_bayid.tsv", sep = "\t")
