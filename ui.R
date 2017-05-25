
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

shinyUI(fluidPage(

  # Application title
  titlePanel("Course Lecture Report"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      selectInput("term", "Term:", term.options, selected = default.term),
      selectInput("course", "Course:", list()),
      htmlOutput("termSelect"),
      htmlOutput("courseSelect")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      h3("clientData values"),
      dataTableOutput("lectureTable"),
      verbatimTextOutput("reqdata"),
      verbatimTextOutput("clientdataText")
    )
  )
))
