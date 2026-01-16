#Assignment Script 1
#Use the Brickman tutorial to extract data from the location of
#Buoy M01 for RCP4.5 in 2055.
#Extract monthly SST and make a plot of SST (y-axis)
#as a function of month (x-axis)

source("setup.R")

# load the buoys, the coastline and the database of covariate data
buoys = gom_buoys()
coast = read_coastline()
db = brickman_database()

# filter the buoys to pull out just M01
buoys = buoys |> 
  filter(id == "M01")  # note the double '=='

# filter the database
db = db |> 
  filter(scenario == "RCP45", year == 2055, interval == "mon")

# read the covariates
covars = read_brickman(db)

# extract the variables from the covars at buoy MO1
x = extract_brickman(covars, buoys, form = "wide")

x = x |>
  mutate(month = factor(month, levels = month.abb))

# now make a plot of SST as a function of month
ggplot(data = x,
       mapping = aes(x = month, y = SST)) +
        geom_point() + 
        geom_line(group = 1) +
        labs(y = "Sea Surface Temperature (C)",
        title = "Monthly SST at Buoy M01 (RCP4.5, 2055)"
       )
