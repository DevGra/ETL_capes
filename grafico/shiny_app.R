library(shiny)

# ------------------------  ESTRUTURA BASICA ----------------------------------
#ui <- fluidPage()
ui <- fluidPage("Teste de página")
server <- function(input, output) {
  
}
shinyApp(ui = ui, server = server)
# ------------------------- -------------- ------------------------------

# ------------ EXEMPLO FUNÇÃO INPUT --------------------
#ui <- fluidPage()
ui <- fluidPage(
  sliderInput(inputId = "num",
              label = "Choose a number",
              value = 25, min = 1, max = 100),
  plotOutput("hist")
  )
server <- function(input, output) {
  output$hist <- renderPlot({
    hist(rnorm(input$num)) # pego o vaor da variavel de entrada inputId
  })
}
shinyApp(ui = ui, server = server)
# ------------------------------------------------------------------------

# ------ 2 inputs e mudando o titulo do grafico de saida

ui <- fluidPage(
  sliderInput(inputId = "num",
              label = "Choose a number",
              value = 25, min = 1, max = 100),
  textInput(inputId = "title",
            label = "write a title",
            value = "Texto a ser mudado"),
  plotOutput("hist")
)
server <- function(input, output) {
  output$hist <- renderPlot({
    hist(rnorm(input$num), main = input$title) # pego o vaor da variavel de entrada inputId
  })
}
shinyApp(ui = ui, server = server)





