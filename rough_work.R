
play_rates %>% 
  arrange(desc(PLAY_RATE))

play_rates %>% 
  filter(PLAY_RATE >= 1)

archetypes <- results %>% 
  group_by(ARCHETYPE) %>% 
  summarise(N = n(),
            WINS = sum(W),
            LOSSES = sum(L),
            TIES = sum(T),
            WIN_RATE = WINS / (WINS + LOSSES + TIES))

name <- "Golbat"
set <- "PHF"
num <- "32"

play_rates %>% 
  filter(
    CUBE_CARD_NAME == name,
    CUBE_CARD_SET == set,
    CUBE_CARD_SET_NUM == num
  )

card_summary <- decks %>% 
  filter(
    CARD_NAME == name,
    CARD_SET == set,
    SET_NUMBER == num
  ) %>% 
  left_join(results %>% 
    select(DECK_ID, PLAYER_ID, WINS = W, LOSSES = L, TIES = T,
           ARCHETYPE)  
  )



src <- cube %>% 
  filter(
    CUBE_CARD_NAME == name,
    CUBE_CARD_SET == set,
    CUBE_CARD_SET_NUM == num
  ) %>% 
  select(IMAGE) %>% 
  distinct() %>% 
  pull(IMAGE)
src

