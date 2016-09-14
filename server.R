library(shiny)
library(ggplot2)

shinyServer(
    function(input, output) {
        #get inputs
        lambda <- eventReactive(
            input$compute,
            as.numeric(input$lambda)
        )
        
        n <- eventReactive(
            input$compute,
            as.numeric(input$n)
        )
        #generate data
        data <- reactive({
            input$compute
            data <- matrix(rexp(n()*2500, lambda()), 2500)
            data <- apply(data,1,mean)
        })
        #compute theoretical means
        theoMean = reactive({1/lambda()})
        theoSD = reactive({1/(sqrt(n())*lambda())})
            
        #compute (partial) data means
        means <- reactive({data.frame(x = sample(t(data()), as.numeric(input$sim)))})
        
        #generate plot
        g <- reactive({ggplot(means()) + geom_histogram(aes(x = x, y = ..density..), bins = 25) + 
                stat_function(fun = dnorm, colour = "red", args = list(mean = theoMean(), sd = theoSD()))})
        
        #create outputs
        output$hist <- renderPlot({g()})
        output$table <- renderTable({
            compare <- data.frame("mean" = c(theoMean(), mean(means()$x)), 
                                  "sd" = c(theoSD(),sd(means()$x)))
            rownames(compare) <- c("Theoretical","Actual")
            round(compare, digits = 6)
            },
            digits = 6)
    }
)