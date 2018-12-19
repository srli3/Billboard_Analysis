library(shiny)
library(shinydashboard)
library(shinythemes)
library(plotly)
library(wordcloud2)
library(dashboardthemes)
library(flexdashboard)

# Header
header <- dashboardHeader(title = "Billboard HOT 100")

data <- read.csv("new.csv") 

# Sidebar
sidebar <-dashboardSidebar(
  sidebarMenu( id = "tabs",
               menuItem("Home", tabName = "Home", icon = icon("home")),
               menuItem("Artists", tabName = "Artists", icon = icon("users")),
               menuItem("Theme Source", icon = icon("file-code-o"),
                        href = 'https://github.com/nik01010/dashboardthemes')
               
  )
)


# Body
body <- dashboardBody(
  shinyDashboardThemes(
    theme = "poor_mans_flatly"
  ),
  tabItems(
    tabItem(tabName = "Home",
            h3("Information Overview"),
            fluidRow( infoBox(7367, "Records", icon = icon("database"), width = 3, color = "purple"),
                      infoBox(1737, "Artists", icon = icon("users"), width = 3, color = "blue"),
                      infoBox(7050, "Songs", icon = icon("music"), width = 3, color = "red"),
                      infoBox(6, "Genres", icon = icon("headphones-alt"), width = 3, color = "yellow") 
            ),
            fluidRow( box(title = "Genre Popularity Trend from 2000 to 2017", 
                          status = "primary",
                          plotlyOutput("plot1", height = 350), width = 12)),
            fluidRow( box(title = "Top 100 Popular Artists",
                          status = "warning",
                          wordcloud2Output("plot2", height = 320), width = 7))
    ),
    
    tabItem(tabName = "Artists",
            h2("Artist Information"),
            fluidRow(box(title = "Select Artist", status = "primary",
                         selectizeInput(
                           's1', 'Search or Select the Artist Name',
                           choices = unique(unlist(data[6:13]))
                         )),
                     infoBoxOutput("artistBox")
                     ),
            fluidRow(box(gaugeOutput("gauge1", height = 110),width=3,title="Energy", status = "success"),
                     box(gaugeOutput("gauge2", height = 110),width=3,title="Liveness", status = "warning"),
                     box(gaugeOutput("gauge3", height = 110),width=3,title="Tempo"),
                     box(gaugeOutput("gauge4", height = 110),width=3,title="Speechiness", status = "danger")
                     ),
            fluidRow(box(gaugeOutput("gauge5", height = 110),width=3,title="Instrumentalness", status = "success"),
                     box(gaugeOutput("gauge6", height = 110),width=3,title="Danceability", status = "warning"),
                     box(gaugeOutput("gauge7", height = 110),width=3,title="Loudness"),
                     box(gaugeOutput("gauge8", height = 110),width=3,title="Valence", status = "danger")
            ),
            fluidRow(box(title = "Songs on Billboard", tableOutput('song'), width = 4, collapsible = TRUE ),
                     box(title = "Popularity by Time", plotlyOutput("bubble"), width = 8))
            
    )
                       
)
)
dashboardPage(
  header,
  sidebar,
  body
)
