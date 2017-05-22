
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

shinyServer(function(input, output, session) {

  episodes <- episodes_by_term(default_term)

  generateCourseChoices <- function(term) {
    courses <- dplyr::distinct(episodes, series, course)
    courses <- courses[order(courses$course),]
    with(courses, split(series, course))
  }

  cdata <- session$clientData

  # episodes <- reactiveValues(episodes=episodes_by_term(default_term))
  #
  # observeEvent(input$term, {
  #   episodes$episodes <- episodes_by_term(input$term)
  # }, ignoreInit = T)
  #
  # observe({
  #   output$courseSelect <- renderUI({
  #     courses <- dplyr::distinct(episodes$episodes, series, course)
  #     courses <- courses[order(courses$course),]
  #     courseChoices <- with(courses, split(series, course))
  #     selectInput("course", "Course:", courseChoices)
  #   })
  # })


  output$courseSelect <- renderUI({
    courseChoices <- generateCourseChoices(default_term)
    selectInput("course", "Course:", courseChoices)
  })

  observe({
    courseChoices <- generateCourseChoices(input$term)
    isolate({
      updateSelectInput(session, "course", choices=courseChoices)
    })
  })

  observeEvent(input$course, {
    output$lectureTable <- renderDataTable({
      lectures <- episodes_by_series(input$course, input$term)
      lectures[order(lectures$title),]
    })
  })

  output$reqdata <- renderText({
    ls(env=session$request)
  })

  output$clientdataText <- renderText({
    cnames <- names(cdata)

    allvalues <- lapply(cnames, function(name) {
      paste(name, cdata[[name]], sep=" = ")
    })
    paste(allvalues, collapse = "\n")
  })

})
