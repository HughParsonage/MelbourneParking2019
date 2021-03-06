library(data.table)
library(hutils)
HourMin <- function(Time) {
  paste0(formatC(hour(Time), width = 2, flag = "0"),
         formatC(minute(Time), width = 2, flag = "0"),
         formatC(second(Time), width = 2, flag = "0"))
}

backoff <- -1
lock_key <- as.character(sample(1e7:1e8, size = 1L))
writeChar(lock_key, "fetch_lock", n = 8L)  # See if another program has spawned

repeat ({
  if (file.exists("fetch_killer")) {
    break
  }
  Now <- Sys.time()
  do_break <- FALSE
  while (second(Now) %% 15L) {
    if (file.exists("fetch_killer") || 
        readChar("fetch_lock", n = 8L) != lock_key) {
      do_break <- TRUE # need to break out of both
      break
    }
    Sys.sleep(2 ^ backoff)
    Now <- Sys.time()
  }
  if (do_break) {
    break
  }
  # source a file so we can modify it as required
  source("data-raw/fetch.R")
  
  if (res) {
    cat(paste0(the_dir, "/", HourMin(Now), ".csv"), "failed.",
        file = "data-raw/fetch_log.txt",
        append = TRUE)
    backoff <<- backoff + 1
  }
})
