library(googlesheets4)
library(tidyverse)

URL = "https://docs.google.com/spreadsheets/d/18OMJ9RZphp0flKn2Cym7HjDogvbS4a5ETTiIYmx9Sko/edit?gid=0#gid=0"

results <- read_sheet(URL, sheet = "Results")
decks   <- read_sheet(URL, sheet = "Decklists")
cube    <- read_sheet(URL, sheet = "Cube")

cube <- cube %>% 
  mutate(CUBE_CARD_SET_NUM = unlist(CUBE_CARD_SET_NUM))

decks <- decks %>% 
  mutate(SET_NUMBER = unlist(SET_NUMBER))

path <- fs::dir_create(fs::path("cache", Sys.time()))
write_csv(results, fs::path(path, "results.csv"))
write_csv(decks, fs::path(path, "decks.csv"))
write_csv(cube, fs::path(path, "cube.csv"))


