
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

shinyUI(fluidPage(

  verticalLayout(
    # Application title
    titlePanel("Lecture Attendance Reports"),
    column(4,
      wellPanel(
        selectInput("term", "Term:", term.options, selected = default.term),
        selectInput("course", "Course:", list()),
        htmlOutput("termSelect"),
        htmlOutput("courseSelect")
      )
    ),
    column(12,
      tabsetPanel(
        tabPanel("Lectures", dataTableOutput("lectureTable")),
        tabPanel("Students", dataTableOutput("studentTable"))
      )
    )
  )

#  sidebarLayout(
#    sidebarPanel(
#    ),
#
#    mainPanel(
#    )
#  )
))
