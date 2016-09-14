library(shiny)
library(markdown)

shinyUI(navbarPage(title = "Distribution of the mean of the exponential distribution",
    tabPanel("App",
        sidebarPanel(
            textInput(inputId="lambda", label = "Lambda value"),
            sliderInput(inputId="n", label = "Choose N", min = 1, max = 100, value = 50, step = 1),
            actionButton("compute", "Compute!"),
            numericInput('sim', 'Number of simulations', 200, min = 1, max = 2500, step = 100)
        ),
        mainPanel(
            plotOutput('hist'),
            tableOutput('table')
         )
    ),
    tabPanel("Description",
             mainPanel(
                 includeMarkdown("description.Rmd")
             )
    )
))