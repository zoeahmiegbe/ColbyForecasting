
# Assignment Script
source("setup.R")
buoys = gom_buoys()
coast = read_coastline()

db = brickman_database()|>
  filter(scenario == "PRESENT", interval == "mon") |>
  read_brickman()

x = read_model_input(scientificname = "Doryteuthis pealeii")
  
result = x |>
  group_by(month) |>
  group_map(
    function(rows,key){
      first = slice(rows,1)
      last= slice(rows, nrow(rows))
      r = bind_rows(first, last)
      cv= slice(db, "month", rows$month[1])
      vals= extract_brickman(cv, r, form = "wide") |>
        select(-.id)
      return(vals)
    }, .keep = TRUE
  ) |>
  bind_rows()
  
print(result)

