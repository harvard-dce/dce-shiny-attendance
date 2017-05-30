library(dotenv)

env <- function(key, default=NA) {
  val <- Sys.getenv(key)
  if (val == "" && !is.na(default)) {
    val <- default
  }
  val
}

es.host <- env("ES_HOST", 'http://localhost:9200')
es.episode.index <- env("ES_EPISODE_INDEX", 'episodes')
default.term <- env("DEFAULT_TERM", "2017-02")
default.tz <- "America/New_York"

term.options <- c(
  "Spring 2017" = "2017-02",
  "Fall 2016" = "2017-01"
)

lecture.fields <- c("title", "available", "duration", "attendance")
student.fields <- c("name", "huid", "status", "reg_level", "attendance")
