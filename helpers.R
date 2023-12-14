getSaveTime <- function() {
  saveTime <- (now() - ymd_hms("2020-04-01 0:0:0")) %>% 
    as.duration %>% 
    round %>%
    as.character %>%
    gsub("s.*", "", .)
  return(saveTime)
}

getReadableSaveTime <- function() {
  saveTime <- now() %>%
    as.character() %>% 
    gsub("^..|:|-", "", .) %>% 
    gsub(" ", "_", .)
  return(saveTime)
}