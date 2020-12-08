library(shiny)
library(ggplot2)

ui<-fluidPage(
  sliderInput("num","Number of observations", min=10,max=1000,value=499),
  radioButtons(
    "dist",
    "Distribution",
    choices = c("Normal"="norm", "Uniform"="uni", "Exponential"="exp"),
    selected = "exp"
  ),
  radioButtons(
    "plot_type",
    "Plot Type",
    choices = c("Histogram" = "hist", "Density plot" = "density"),
    selected = "hist"
  ),
  plotOutput("plot")
)

server<-function(input, output) {
  # 如何创建一个动态的函数变量?
  all_reactives <- reactiveValues()
  observe({
    dist_func = switch(input$dist,
    norm = rnorm,
    uni = runif,
    exp = rexp
    )
    all_reactives$plot_func <- switch(input$plot_type,
        hist = geom_histogram,
        density = geom_density
        )
    all_reactives$data <- dist_func(input$num)
  })
  
  
  output$plot <- renderPlot({
    ggplot(data.frame(value = all_reactives$data)) + aes(x = value) + all_reactives$plot_func(fill = "blue", alpha = 0.5, color = "blue")
  })
}

shinyApp(ui=ui,server=server)
