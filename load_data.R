library(googlesheets4)

URL = "https://docs.google.com/spreadsheets/d/18OMJ9RZphp0flKn2Cym7HjDogvbS4a5ETTiIYmx9Sko/edit?gid=0#gid=0"

results <- read_sheet(URL, sheet = "Results")
decks   <- read_sheet(URL, sheet = "Decklists")
