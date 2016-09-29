tissues = c("brain",  "intestine", "liver" , "kidney","muscle")
timepoints = c("12", "24", "48", "72")
shinyUI(fluidPage(
  
  
  titlePanel("Fasting Datasets"),
  
  sidebarLayout(
    sidebarPanel( 
      h3("Options:"),
      textInput("gene", label = "Gene", value = "SGK"),
      radioButtons("x_var", label= "Plot by", choices = c("tissue", "timepoint")),
      fluidRow(
        
        column(5, checkboxGroupInput("whichTissues", label ="Tissues", choices = tissues, selected = tissues) ),
      
        column(3, checkboxGroupInput("whichTimepoints", label ="Timepoints", choices = timepoints, selected = timepoints))
        
      )
      
      
                  ),
     

    mainPanel(
      textOutput("text1"),
      plotOutput("plot")
      
      
      )
  )
  
))