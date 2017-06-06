
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

shinyUI(fluidPage(

  verticalLayout(
    # Application title
    titlePanel("Lecture Attendance Reports"),
    fluidRow(
      column(6,
          selectInput("term", "Term:", term.options, selected = default.term)
      ),
      column(6,
          selectInput("course", "Course:", list())
      )
    ),
    column(12,
      tabsetPanel(
        tabPanel("Lectures",
                 tags$head(tags$style( HTML(' .tab-content {margin-top: 20px;}'))),
                 dataTableOutput("lectureTable")
                 ),
        tabPanel("Students",
                 tags$head(tags$style( HTML(' .tab-content {margin-top: 20px;}'))),
                 dataTableOutput("studentTable")
                 )
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
