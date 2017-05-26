
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

shinyServer(function(input, output, session) {

  attendance <- read.csv("./data/attendance.csv")
  rollcall <- read.csv("./data/rollcall.csv")
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

      # get the episodes for this course
      lectures <- dplyr::filter(episodes$episodes,
                                series == input$course,
                                is.na(available) == F,
                                grepl("L", type)
                                )

      output$lectureTable <- renderDataTable({
        # prune to columns we want
        lectureTable <- dplyr::select(lectures, one_of(lecture.fields))
        # rearrange the columns
        lectureTable <- lectureTable[lecture.fields]
        # order by title
        lectureTable <- lectureTable[order(lectureTable$start),]
      })

      # get the student list for this course
      students <- dplyr::filter(rollcall,
                                series == input$course,
                                reg_level != "S"
                                )

      output$studentTable <- renderDataTable({
        # create column contining full name
        studentTable <- dplyr::mutate(students, name = paste(first_name, mi, last_name))
        # order by last name
        studentTable <- studentTable[order(studentTable$last_name),]
        # prune to the columns we want
        select(studentTable, one_of(student.fields))
      })
    }
  }, ignoreNULL = T, ignoreInit = T)

})
