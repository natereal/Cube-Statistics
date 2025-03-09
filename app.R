library(shiny)
library(DT)

source("analysis.R")

ui <- fluidPage(

    titlePanel("Cube Statistics"),

    sidebarLayout(
        sidebarPanel(
          selectInput("name",
                      "Card Name:",
                      unique(cube$CUBE_CARD_NAME),
                      selected = "Golbat"),
          selectInput("set",
                      "Set Abbreviation:",
                      unique(cube$CUBE_CARD_SET),
                      selected = "PHF"),
          selectInput("num",
                      "Set Number:",
                      sort(unique(cube$CUBE_CARD_SET_NUM)),
                      selected = "32")
        ),

        mainPanel(
          tabsetPanel(
            id = 'dataset',
            tabPanel("play_rates", DT::dataTableOutput("tbl_play_rates")),
            tabPanel("archetypes", DT::dataTableOutput("tbl_arch")),
            tabPanel("card_summary", 
              br(),
              fluidRow(
                column(4, 
                      htmlOutput("image"),
                      textOutput("times_played"),
                      textOutput("win_rate")),
                column(6,
                  DT::dataTableOutput("tbl_arches_played"),
                  DT::dataTableOutput("tbl_players")
                )
              )
            )
          )
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  
    card_summary <- reactive({
      decks %>% 
        filter(
          CARD_NAME == input$name,
          CARD_SET == input$set,
          SET_NUMBER == input$num
        ) %>% 
        left_join(results %>% 
                    select(DECK_ID, PLAYER_ID, WINS = W, LOSSES = L, TIES = T,
                           ARCHETYPE)  
        )
    })
    
    # card_summary <- card_summary_react()
  
    output$tbl_play_rates <- DT::renderDT({
      play_rates %>% 
        select(-FIRST_CARD_KEY) %>% 
        rename(NAME = CUBE_CARD_NAME,
               SET = CUBE_CARD_SET,
               NUM = CUBE_CARD_SET_NUM) %>% 
      DT::datatable()
    })
    
    output$tbl_arch <- DT::renderDT({
      archetypes %>% 
        DT::datatable()
    })
    
    # output$image <- renderImage({
    #   list(src = "./images/golbat.png")
    # }, deleteFile = FALSE)
    
    
    output$image <- renderText({
      
      src <- cube %>% 
        filter(
          CUBE_CARD_NAME == input$name,
          CUBE_CARD_SET == input$set,
          CUBE_CARD_SET_NUM == input$num
        ) %>% 
        select(IMAGE) %>% 
        distinct() %>% 
        pull(IMAGE)
      
      c('<img src="',src,'">')
    })
    
    
    output$times_played <- renderText({
      times_played <- nrow(card_summary())
      paste0("Times played: ", times_played)
    })


    output$win_rate <- renderText({
      
      win <- sum(card_summary()$WINS)
      loss <- sum(card_summary()$LOSSES)
      ties <- sum(card_summary()$TIES)
      win_rate <- round(win * 100 / (win + loss + ties), 2)
      
      paste0("Win Rate: ", win_rate, "%")
    })


    output$tbl_arches_played <- DT::renderDT({
      
    arches_played <- card_summary() %>%
      select(ARCHETYPE) %>%
      group_by(ARCHETYPE) %>%
      summarise('Times Played' = n())
      
      arches_played
    })


    output$tbl_players <- DT::renderDT({
      
      players <- card_summary() %>%
      select(Player = PLAYER_ID) %>%
      group_by(Player) %>%
      summarise('Times Played' = n())
      players
    })

}

# Run the application 
shinyApp(ui = ui, server = server)
