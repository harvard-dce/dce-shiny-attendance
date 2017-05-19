
make_query <- function(q) {
  elasticsearchr::query(q)
}

for_everything <- make_query('{ "match_all": {} }')

episodes_by_term <- function(year_term) {
  year_term <- str_split(year_term, "-")
  year <- year_term[[1]][1]
  term <- year_term[[1]][2]
  by_term <- make_query(
    str_interp('{
      "bool": {
        "must": [
             { "term": { "year": "${year}" }},
             { "term": { "term": "${term}" }}        
        ]
      }    
    }')
  )
  elastic(es_host, "episodes") %search% by_term
}

