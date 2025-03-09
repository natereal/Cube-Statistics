library(tidyverse)

NUM_SESSIONS_HELD = 4

data_path = "cache/2025-03-09 01:04:18/"
results <- read_csv(fs::path(data_path, "results.csv"))
decks   <- read_csv(fs::path(data_path, "decks.csv"))
cube    <- read_csv(fs::path(data_path, "cube.csv"))


cube

join <- decks %>% 
  select(-DECK_ID, -NUM_COPIES) %>% 
  distinct() %>% 
  mutate(DECK_ROW_ID = row_number()) %>% 
  left_join(cube %>% 
    select(CARD_KEY:CUBE_CARD_SET_NUM), by = c(
    "CARD_NAME" = "CUBE_CARD_NAME", 
    "CARD_SET" = "CUBE_CARD_SET",
    "SET_NUMBER" = "CUBE_CARD_SET_NUM")) 

join %>% 
  filter(is.na(CARD_KEY)) %>% 
  view()

cube

decks %>% 
  left_join(results %>% 
   select(DECK_ID, W, L)
  )

times_played <- decks %>% 
  left_join(results %>% 
              select(DECK_ID, W, L)
  ) %>% 
  group_by(CARD_NAME, CARD_SET, SET_NUMBER) %>% 
  summarise(N = n(), WINS = sum(W), LOSS = sum(L))

# play_rates <- cube %>% 
#   left_join(times_played, by = c(
#     "CUBE_CARD_NAME"    = "CARD_NAME",  
#     "CUBE_CARD_SET"     = "CARD_SET",   
#     "CUBE_CARD_SET_NUM" = "SET_NUMBER" 
#   ))
# 
# play_rates %>% 
#   select(1:4, N) %>% 
#   arrange(desc(N))

play_rates <- cube %>% 
  select(1:4) %>% 
  group_by(CUBE_CARD_NAME, CUBE_CARD_SET, CUBE_CARD_SET_NUM) %>% 
  summarise(
    FIRST_CARD_KEY = first(CARD_KEY),
    COPIES_IN_CUBE = n()) %>% 
  left_join(times_played, by = c(
    "CUBE_CARD_NAME"    = "CARD_NAME",  
    "CUBE_CARD_SET"     = "CARD_SET",   
    "CUBE_CARD_SET_NUM" = "SET_NUMBER" 
  )) %>% 
  mutate(
    PLAY_RATE = if_else(is.na(N), 0, N / (COPIES_IN_CUBE * NUM_SESSIONS_HELD)),
    WIN_RATE = WINS / (WINS + LOSS)
  )

play_rates %>% 
  arrange(desc(N))

archetypes <- results %>% 
  group_by(ARCHETYPE) %>% 
  summarise(N = n(),
            WINS = sum(W),
            LOSSES = sum(L),
            TIES = sum(T),
            WIN_RATE = WINS / (WINS + LOSSES + TIES))
