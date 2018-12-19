library(tidyverse)
library(shiny)
library(ggplot2)
library(plotly)
library(wordcloud2)
library(flexdashboard)

data <- read.csv("new.csv")
artist <- read.csv("artist.csv")

server <- function(input, output) {
  sliderValues <- reactive({
    
    data.frame(
      Name = c("Year Range"),
      Value = as.character(c(paste(input$range, collapse = " ")),
                           stringsAsFactors = FALSE)
      
    )})
  
  # General Genre Trend Plot
  output$plot1 <- renderPlotly({
    data1 <- data %>%
      filter(broad_genre != "" &
               broad_genre != "unknown") %>%
      group_by(year, broad_genre) %>%
      summarise(count = n()) %>%
      ungroup() %>%
      group_by(year) %>%
      mutate(percent = count/sum(count))
    
    p1 <- ggplot(data1, aes(x = year, y = percent, color = broad_genre)) + 
      geom_line(alpha = 1) +
      xlab("Year") + ylab("Popularity (from 0 to 1)") +
      scale_x_continuous(breaks = data1$year) +
      scale_colour_hue(name="Genre", l=30) +
      theme(panel.background = element_blank())
    
    p1 <- p1 + theme(panel.background = element_blank())
    ggplotly(p1)
    
  })
  
  
  # General Artist Word Cloud
  
  output$plot2 <- renderWordcloud2({
    freq <- table(unlist(data[,c("artist1", "artist2","artist3","artist4","artist5",
                                 "artist6","artist7","artist8")]))
    
    result <- data.frame(word = sprintf("%s", as.character(names(freq))),
                         freq = as.double(freq)) 
    # Top 100 artists
    result <- result %>%
      filter(word != "") %>%
      arrange(desc(freq)) %>%
      slice(1:100)
    
    wordcloud2(result,  size = 0.5, fontFamily = "Avenir", color = "random-dark",  rotateRatio = 0)
  })
  
  # Link
  output$artistBox <- renderInfoBox({
    
    artist_link <- artist[artist$artist==input$s1,]
    uri <- toString(artist_link$wiki_uri)
    
    text_uri <- a("Wikidata Page", href = uri )
    
    infoBox(
      "Artist", paste0(input$s1), icon = icon("list"),
      color = "purple",
      text_uri)
  })
  
  
  
  #Gauge1
  output$gauge1 <- renderGauge({
    artist_energy <- data %>%
      filter(artist1 == input$s1 | 
               artist2 == input$s1 | 
               artist3 == input$s1 | 
               artist4 == input$s1 | 
               artist5 == input$s1 | 
               artist6 == input$s1 | 
               artist7 == input$s1 | 
               artist8 == input$s1) %>%
      mutate(avg_ene = ((mean(energy) - min(data$energy)) / (max(data$energy) - min(data$energy))))
    gauge(round(artist_energy$avg_ene[1:1] * 100, digits = 1), min = 0, max = 100, symbol = '%',
          gaugeSectors(success = c(100, 6), warning = c(5,1), 
                       danger = c(0, 1), colors = c("#CC6699")))
  })
  
  output$gauge2 <- renderGauge({
    artist_liveness <- data %>%
      filter(artist1 == input$s1 | 
               artist2 == input$s1 | 
               artist3 == input$s1 | 
               artist4 == input$s1 | 
               artist5 == input$s1 | 
               artist6 == input$s1 | 
               artist7 == input$s1 | 
               artist8 == input$s1) %>%
      mutate(avg_liv = ((mean(liveness) - min(data$liveness)) / (max(data$liveness) - min(data$liveness))))
    gauge(round(artist_liveness$avg_liv[1:1] * 100, digits = 1), min = 0, max = 100, symbol = '%',
          gaugeSectors(success = c(100, 6), warning = c(5,1), 
                       danger = c(0, 1), colors = c("#CC6699")))
  })
  
  output$gauge3 <- renderGauge({
    artist_speechiness <- data %>%
      filter(artist1 == input$s1 | 
               artist2 == input$s1 | 
               artist3 == input$s1 | 
               artist4 == input$s1 | 
               artist5 == input$s1 | 
               artist6 == input$s1 | 
               artist7 == input$s1 | 
               artist8 == input$s1) %>%
      mutate(avg_spe = ((mean(speechiness) - min(data$speechiness)) / (max(data$speechiness) - min(data$speechiness))))
    gauge(round(artist_speechiness$avg_spe[1:1] * 100, digits = 1), min = 0, max = 100, symbol = '%', 
          gaugeSectors(success = c(100, 6), warning = c(5,1), 
                       danger = c(0, 1), colors = c("#CC6699")))
  })
  
  output$gauge4 <- renderGauge({
    artist_acoustic <- data %>%
      filter(artist1 == input$s1 | 
               artist2 == input$s1 | 
               artist3 == input$s1 | 
               artist4 == input$s1 | 
               artist5 == input$s1 | 
               artist6 == input$s1 | 
               artist7 == input$s1 | 
               artist8 == input$s1) %>%
      mutate(avg_aco = ((mean(acousticness) - min(data$acousticness)) / (max(data$acousticness) - min(data$acousticness))))
    gauge(round(artist_acoustic$avg_aco[1:1] * 100, digits = 1), min = 0, max = 100, symbol = '%', 
          gaugeSectors(success = c(100, 6), warning = c(5,1), 
                       danger = c(0, 1), colors = c("#CC6699")))
  })
  
  output$gauge5 <- renderGauge({
    artist_instrumental <- data %>%
      filter(artist1 == input$s1 | 
               artist2 == input$s1 | 
               artist3 == input$s1 | 
               artist4 == input$s1 | 
               artist5 == input$s1 | 
               artist6 == input$s1 | 
               artist7 == input$s1 | 
               artist8 == input$s1) %>%
      mutate(avg_ins = ((mean(instrumentalness) - min(data$instrumentalness)) / (max(data$instrumentalness) - min(data$instrumentalness))))
    gauge(round(artist_instrumental$avg_ins[1:1] * 100, digits = 1), min = 0, max = 100, symbol = '%',
          gaugeSectors(success = c(100, 6), warning = c(5,1), 
                       danger = c(0, 1), colors = c("#CC6699")))
  })
  
  output$gauge6 <- renderGauge({
    artist_dance <- data %>%
      filter(artist1 == input$s1 | 
               artist2 == input$s1 | 
               artist3 == input$s1 | 
               artist4 == input$s1 | 
               artist5 == input$s1 | 
               artist6 == input$s1 | 
               artist7 == input$s1 | 
               artist8 == input$s1) %>%
      mutate(avg_dan = ((mean(danceability) - min(data$danceability)) / (max(data$danceability) - min(data$danceability))))
    gauge(round(artist_dance$avg_dan[1:1] * 100, digits = 1), min = 0, max = 100, symbol = '%',
          gaugeSectors(success = c(100, 6), warning = c(5,1), 
                       danger = c(0, 1), colors = c("#CC6699")))
  })
  
  output$gauge7 <- renderGauge({
    artist_loudness <- data %>%
      filter(artist1 == input$s1 | 
               artist2 == input$s1 | 
               artist3 == input$s1 | 
               artist4 == input$s1 | 
               artist5 == input$s1 | 
               artist6 == input$s1 | 
               artist7 == input$s1 | 
               artist8 == input$s1) %>%
      mutate(avg_lou = ((mean(loudness) - min(data$loudness)) / (max(data$loudness) - min(data$loudness))))
    gauge(round(artist_loudness$avg_lou[1:1] * 100, digits = 1), min = 0, max = 100, symbol = '%',
          gaugeSectors(success = c(100, 6), warning = c(5,1), 
                       danger = c(0, 1), colors = c("#CC6699")))
  })
  
  output$gauge8 <- renderGauge({
    artist_valence <- data %>%
      filter(artist1 == input$s1 | 
               artist2 == input$s1 | 
               artist3 == input$s1 | 
               artist4 == input$s1 | 
               artist5 == input$s1 | 
               artist6 == input$s1 | 
               artist7 == input$s1 | 
               artist8 == input$s1) %>%
      mutate(avg_val = ((mean(valence) - min(data$valence)) / (max(data$valence) - min(data$valence))))
    gauge(round(artist_valence$avg_val[1:1] * 100, digits = 1), min = 0, max = 100, symbol = '%',
          gaugeSectors(success = c(100, 6), warning = c(5,1), 
                       danger = c(0, 1), colors = c("#CC6699")))
  })
  
  output$song <- renderTable({
    data %>%
      filter(artist1 == input$s1 | 
               artist2 == input$s1 | 
               artist3 == input$s1 | 
               artist4 == input$s1 | 
               artist5 == input$s1 | 
               artist6 == input$s1 | 
               artist7 == input$s1 | 
               artist8 == input$s1) %>%
      select(date, title, rank) %>%
      arrange(desc(date))
  })
  
  output$bubble <- renderPlotly({
    rank_info <- data %>%
      filter(artist1 == input$s1 | 
               artist2 == input$s1 | 
               artist3 == input$s1 | 
               artist4 == input$s1 | 
               artist5 == input$s1 | 
               artist6 == input$s1 | 
               artist7 == input$s1 | 
               artist8 == input$s1) %>%
      mutate(year_month = format(as.Date(new_date), "%Y-%m"))
      
    p <- plot_ly(rank_info, x = ~year_month, y = ~(101-rank), text = ~title, color=~broad_genre, type = 'scatter', mode = 'markers',
                 marker = list(size = ~(101-peak_pos), opacity = 0.5)) %>%
      layout(xaxis = list(title = "Year & Month"),
             yaxis = list(title = "Popularity"))
    ggplotly(p)
  })
}