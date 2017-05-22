
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

shinyServer(function(input, output, session) {

  cdata <- session$clientData

  episodes <- reactiveValues(episodes=episodes_by_term(default_term))

  observeEvent(input$term, {
    episodes$episodes <- episodes_by_term(input$term)
  }, ignoreInit = T)

  observe({
    output$courseSelect <- renderUI({
      courses <- dplyr::distinct(episodes$episodes, series, course)
      courses <- courses[order(courses$course),]
      courseChoices <- with(courses, split(series, course))
      selectInput("course", "Course:", courseChoices)
    })
  })

  observe({
    output$lectureTable <- renderDataTable({
      lectures <- dplyr::filter(episodes$episodes, series == input$course)
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
