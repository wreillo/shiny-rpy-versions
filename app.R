library(shiny)
library(DT)
library(qpcR)

ui <- fluidPage(
    
    titlePanel("R & Python: available versions"),
    
    sidebarLayout(
        sidebarPanel(width = 3,
            shiny::actionButton("button", "Update")
        ),
        
        mainPanel(
           DT::dataTableOutput("versionsTable")
        )
    )
)

server <- function(input, output) {
    
    # Render DT table
    output$versionsTable <- DT::renderDT(
        versionData(), options = list(
            initComplete = JS(
                "function(settings, json) {",
                "$('body').css({'font-family': 'Calibri'});",
                "}"
            ),
            columnDefs = list(list(className = 'dt-center', targets = "_all"))
        ),rownames=F)
    
    # get R and Python versions from directories in /opt/...
    versionData <- reactive({ 
        input$button
        R <- system("ls /opt/R",intern = T)
        Python <- system("ls /opt/python",intern = T)
        avail.versions <- data.frame(qpcR:::cbind.na(R, Python))
    })

}

shinyApp(ui = ui, server = server)
