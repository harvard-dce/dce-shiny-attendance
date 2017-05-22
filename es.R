
make_query <- function(q) {
  elasticsearchr::query(q)
}

for_everything <- function() {
  make_query('{ "match_all": {} }')
}

by_term <- function(year_term) {
  year_term <- str_split(year_term, "-")
  year <- year_term[[1]][1]
  term <- year_term[[1]][2]
  make_query(
    str_interp('{
      "bool": {
        "must": [
             { "term": { "year": "${year}" }},
             { "term": { "term": "${term}" }}
        ]
      }
    }')
  )
}

by_series <- function(series) {
  make_query(
    str_interp('{
      "term": {
        "series": "${series}"
      }
    }')
  )
}

episodes_by_term <- function(year_term) {
  elastic(es_host, "episodes") %search% by_term(year_term)
}

episodes_by_series <- function(series, year_term) {
  elastic(es_host, "episodes") %search% (by_term(year_term) + by_series(series))
}

