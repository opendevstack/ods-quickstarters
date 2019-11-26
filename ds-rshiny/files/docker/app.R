options(java.parameters = c("-Xss2560k", "-Xmx4g"))

library(DBI)
library(rJava)
library(RJDBC)
library(shiny)
library(shinythemes)
library(d3heatmap)
library(ggplot2)
library(reshape2)

# ================================================= UI PART =======================================================
ui <- fluidPage(
    # Application title
  titlePanel("Hello Shiny!"),
  
  # Sidebar with a slider input for number of observations
  sidebarLayout(
    sidebarPanel(
      sliderInput("obs", 
                  "Number of observations:", 
                  min = 1, 
                  max = 1000, 
                  value = 500)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
)

# ====================================== SERVER PART =======================================================
server <- function(input, output) {

    # Expression that generates a plot of the distribution. The expression
  # is wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should be automatically 
  #     re-executed when inputs change
  #  2) Its output type is a plot 
  #
  output$distPlot <- renderPlot({
        
    # generate an rnorm distribution and plot it
    dist <- rnorm(input$obs)
    hist(dist)
  })
  
}


shinyApp(ui, server)