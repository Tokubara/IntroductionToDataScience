library(shiny)
ui <- fluidPage(
  actionButton("unif","Uniform"),
  actionButton("norm", "Normal"),
  plotOutput("hist")
)

server <- function(input, output) {
  rv=list(data=runif(100))
  rv$title = "Normal Distribution"
  observeEvent(input$unif, {rv$data = runif(100) 
  rv$title = "Uniform Distribution"})
  observeEvent(input$norm, {rv$data = rnorm(100)
  rv$title = "Normal Distribution"})
  output$hist = renderPlot(hist(rv$data, main=paste("Histogram of",rv$title)))
}

shinyApp(ui = ui, server = server)