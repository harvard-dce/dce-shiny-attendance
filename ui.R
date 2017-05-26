
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

shinyUI(fluidPage(

  # Application title
  titlePanel("Course Lecture Report"),

  sidebarLayout(
    sidebarPanel(
      selectInput("term", "Term:", term.options, selected = default.term),
      selectInput("course", "Course:", list()),
      htmlOutput("termSelect"),
      htmlOutput("courseSelect")
    ),

    mainPanel(
      tabsetPanel(
        tabPanel("Lectures", dataTableOutput("lectureTable")),
        tabPanel("Students", dataTableOutput("studentTable"))
      )
    )
  )
))
