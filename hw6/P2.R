library(shiny)
library(ggplot2)
data(Salaries, package = "carData")

ui <- fluidPage(
  selectInput(
    "y_variable",
    "Choose Variable",
    c("yrs.since.phd", "yrs.service", "salary"),
    "salary"
  ),
  selectInput(
      "x_variable",
      "Horizontal Position",
      c("none", "rank", "sex", "discipline"),
      "rank"
    ),
  radioButtons(
    "grouping_method",
    "Grouping Method",
    c("No Grouping" = "none", "Color"="color", "Facet"="facet"),
    "color"
  ),
  selectInput(
      "grouping_variable",
      "Grouping Variable",
      c("rank", "sex", "discipline"),
      "gender"
    ),
  plotOutput("plot")
)

server <- function(input, output) {
  output$plot <- renderPlot({
    switch(
      input$grouping_method,
      none = ggplot(Salaries) + aes_string(x = input$x_variable, y = input$y_variable) + geom_boxplot(),
      color = ggplot(Salaries) + aes_string(x = input$x_variable, y = input$y_variable, color=input$grouping_variable) + geom_boxplot(),
      facet = ggplot(Salaries) + aes_string(x = input$x_variable, y = input$y_variable) + geom_boxplot() + facet_grid(as.formula(paste("~", input$grouping_variable)))
    )
    # ggplot(Salaries) + aes_string(x = input$x_variable, y=input$y_variable) + geom_boxplot(fill = "blue", alpha = 0.5, color = "blue")
  })
}

shinyApp(ui = ui, server = server)
