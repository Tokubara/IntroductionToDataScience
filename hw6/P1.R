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
  dist_func <- rexp
  # 如何创建一个动态的函数变量?
  data<-reactive(dist_func(input$num))
  output$plot <- renderPlot(ggplot(data.frame(data = data())) + aes(x = data) + geom_histogram(fill = "blue", alpha = 0.5))
}

shinyApp(ui=ui,server=server)
