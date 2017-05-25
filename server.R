
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

shinyServer(function(input, output, session) {

  attendance <- read.csv("./data/attendance.csv")
  episodes <- reactiveValues(episodes = list())

  observeEvent(input$term, {
    episodes$episodes <- episodesByTerm(input$term)
  })

  observe({
    courses <- dplyr::distinct(episodes$episodes, series, course)
    courses <- courses[order(courses$course),]
    choices <- c(list("Select A Course" = ""), with(courses, split(series, course)))
    isolate({
      updateSelectInput(session, "course", choices=choices)
    })
  })

  observeEvent(input$course, {
    if (input$course != "") {
      browser()
      output$lectureTable <- renderDataTable({
        lectures <- dplyr::filter(episodes$episodes, series == input$course)
        lectures <- dplyr::select(lectures, one_of(lecture.fields))
        lectures[order(lectures$title),]
      })
    }
  }, ignoreNULL = T, ignoreInit = T)

})
