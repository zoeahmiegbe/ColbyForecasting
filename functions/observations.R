
read_observations = function(scientificname = "Doryteuthis pealeii",
                             minimum_year = 1970, 
                             drop_na= c("eventDate","individualCount"),
                             ...){
  
  #' Read raw OBIS data and then filter it
  #' 
  #' @param scientificname chr, the name of the species to read
  #' @param minimum_year num, the earliest year of observation to accept or 
  #'   set to NULL to skip
  #' @param ... other arguments passed to `read_obis()`
  #' @return a filtered table of observations
  
  # Happy coding!
  
  # read in the raw data
  x = read_obis(scientificname, ...) |>
    dplyr::mutate(month = factor(month, levels = month.abb))
  
  # if the user provided a non-NULL filter by year
  if (!is.null(minimum_year)) {
    x <- x |> filter(year >= minimum_year)
  }
  
  # Optional NA removal by column name
  #similar to log_me in read_brickman()
  if(!is.null(drop_na)) {
    for(col in drop_na) {
      x <- x |> filter(!is.na(.data[[col]]))
    }
  }
  
  #Geometry
  
  db_mask <- brickman_database() |> filter(scenario == "STATIC", var == "mask")
  mask <- read_brickman(db_mask)
  hitOrMiss <- extract_brickman(mask, x)
  x <- x |> filter(!is.na(hitOrMiss$value))
  
  
  return(x)
}
