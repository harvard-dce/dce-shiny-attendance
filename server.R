
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

shinyServer(function(input, output, session) {

  attendance <- read.csv("./data/attendance.csv")
  rollcall <- read.csv("./data/rollcall.csv", stringsAsFactors = F)
  episodes <- reactiveValues(episodes = list())

  lectureAttendance <- function(series.id, mp.id) {
    students <- filter(rollcall, series == series.id & reg_level != "S")
    attended <- filter(attendance, mpid == mp.id & huid %in% students$huid)
    paste(nrow(attended), "of", nrow(students))
  }

  studentAttendance <- function(lectures, student.id) {
    attended <- filter(attendance, huid == student.id & mpid %in% lectures$mpid)
    paste(nrow(attended), "of", nrow(lectures))
  }

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
                                series == input$course &
                                is.na(available) == F &
                                grepl("L", type)
                                )
      # format duration, available date, and add attendance column
      lectures <- mutate(lectures,
                             available = with_tz(ymd_hms(available, tz = default.tz)),
                             duration = paste(as.integer((duration / 1000) / 60), "m", sep = "")
                             )

      output$lectureTable <- renderDataTable({
        # generate the attendance column
        lectureTable <- lectures %>% rowwise() %>% mutate(attendance = lectureAttendance(input$course, mpid))
        # prune to columns we want
        lectureTable <- dplyr::select(lectureTable, one_of(lecture.fields))
        # rearrange the columns
        lectureTable <- lectureTable[lecture.fields]
        # order by title
        lectureTable <- lectureTable[order(lectureTable$available),]
      })

      # get the student list for this course
      students <- dplyr::filter(rollcall, series == input$course & reg_level != "S")

      output$studentTable <- renderDataTable({
        studentTable <- students %>% rowwise() %>% mutate(attendance = studentAttendance(lectures, huid))
        # create column contining full name
        studentTable <- dplyr::mutate(studentTable, name = paste(first_name, mi, last_name))
        # order by last name
        studentTable <- studentTable[order(studentTable$last_name),]
        # prune to the columns we want
        studentTable <- select(studentTable, one_of(student.fields))
      })
    }
  }, ignoreNULL = T, ignoreInit = T)

})
