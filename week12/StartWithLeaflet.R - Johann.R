Johann Weber Destailleur


### GETTING STARTED WITH LEAFLET

# Try to work through down this script, observing what happens in the plotting pane. There are three
# initial example exercises, followed by a few questions and 5 tasks. 

# Review favorite backgrounds in:
# https://leaflet-extras.github.io/leaflet-providers/preview/
# beware that some need extra options specified

# To install Leaflet package, run this command at your R prompt:
install.packages("leaflet")
install.packages("htmlwidget")
install.packages("googlesheets4")

# Activate the library
library(tidyverse)
library(leaflet)
library(htmlwidgets) # not essential, only needed for saving the map as .html
library(googlesheets4)
########## Example 1: create a Leaflet map of Europe with addAwesomeMarkers() 

# Learn to create a map by plotting three point markers, called Robin, Jakub and Jannes.



########################################  TASK NUMBER ONE


# Task 1: Create a Danish equivalent of AUSmap with Esri layers, 
# but call it DANmap. You will need it layer as a background for Danish data points.
# Create a basic base map
l_dan <- leaflet() %>%   # assign the base location to an object
  setView(10.110445, 56.172740, zoom = 13)

# Now, prepare to select backgrounds by grabbing their names
esri <- grep("^Esri", providers, value = TRUE)

# Select backgrounds from among provider tiles. To view the options, 
# go to https://leaflet-extras.github.io/leaflet-providers/preview/
# Run the following three lines together!
for (provider in esri) {
  l_dan <- l_dan %>% addProviderTiles(provider, group = provider)
}

l_dan
# Map of Denmark
# We make a layered map out of the components above and write it to 
# an object called AUSmap
DANmap <- l_dan %>%
  addLayersControl(baseGroups = names(esri),
                   options = layersControlOptions(collapsed = FALSE)) %>%
  addMiniMap(tiles = esri[[1]], toggleDisplay = TRUE,
             position = "bottomright") %>%
  addMeasure(
    position = "bottomleft",
    primaryLengthUnit = "meters",
    primaryAreaUnit = "sqmeters",
    activeColor = "#3D535D",
    completedColor = "#7D4479") %>% 
  htmlwidgets::onRender("
                        function(el, x) {
                        var myMap = this;
                        myMap.on('baselayerchange',
                        function (e) {
                        myMap.minimap.changeLayer(L.tileLayer.provider(e.name));
                        })
                        }") %>% 
  addControl("", position = "topright")

# run this to see your product
DANmap

########## SAVE THE FINAL PRODUCT

# Save map as a html document (optional, replacement of pushing the export button)
# only works in root

# We will also need this widget to make pretty maps:

saveWidget(DANmap, "DANmap.html", selfcontained = TRUE)


########################################
######################################## ADD DATA TO LEAFLET

# Before you can proceed to Task 2, you need to learn about coordinate creation. 
# In this section you will manually create machine-readable spatial
# data from GoogleMaps, load these into R, and display them in Leaflet with addMarkers(): 

### First, go to https://bit.ly/CreateCoordinates1
### Enter the coordinates of your favorite leisure places in Denmark 
      # extracting them from the URL in googlemaps, adding name and type of monument.
      # Remember to copy the coordinates as a string, as just two decimal numbers separated by comma. 

# Caveats: Do NOT edit the grey columns! They populate automatically!

### Second, read the sheet into R. You will need gmail login information. 
  # IMPORTANT: watch the console, it may ask you to authenticate or put in the number 
  # that corresponds to the account you wish to use.

# Libraries
library(tidyverse)
library(googlesheets4)
library(leaflet)

# If you experience difficulty with your read_sheet() function (it is erroring out), 
# uncomment and run the following function:
gs4_deauth()  # run this line and then rerun the read_sheet() function below

# Read in the Google sheet you've edited
places <- read_sheet("https://docs.google.com/spreadsheets/d/1PlxsPElZML8LZKyXbqdAYeQCDIvDps2McZx1cTVWSzI/edit?gid=148633452#gid=148633452",
                     col_types = "cccnncnc",   # check that you have the right number and type of columns
                     range = "DAM2025")  # select the correct worksheet name

glimpse(places)  
places <- places %>% 
  filter(!is.na(Longitude)) %>% 
  filter(!is.na(Latitude))
places
# Question 3: are the Latitude and Longitude columns present? 
# Do they contain numeric decimal degrees?



# If your coordinates look good, see how you can use addMarkers() function to
# load them in a basic map. Run the lines below and check: are any points missing? Why?
leaflet() %>% 
  addTiles() %>% 
  addMarkers(lng = places$Longitude, 
             lat = places$Latitude,
             popup = paste(places$Description,
                           "<br>", places$Type))
# Now that you have learned how to load points from a googlesheet to a basic leaflet map, 
# apply the know-how to YOUR DANmap object. 

########################################
######################################## TASK TWO


# Task 2: Read in the googlesheet data you and your colleagues created
# into your DANmap object (with 11 background layers you created in Task 1).

#Already done in task 1

######################################## TASK THREE

# Task 3: Can you cluster the points in Leaflet?
# Hint: Google "clustering options in Leaflet in R"

# Solution
leaflet(data = places) %>%
  addTiles() %>%
  addMarkers(~Longitude, ~Latitude, clusterOptions = markerClusterOptions())

Chatgpt helped me plot the points together into groups

######################################## TASK FOUR

# Task 4: Look at the two maps (with and without clustering) and consider what
# each is good for and what not.

Clustering makes it easier to see that irs data, but makes the overall overview better


######################################## TASK FIVE

# Task 5: Find out how to display the notes and classifications column in the map. 
# Hint: Check online help in sites such as 
# https://r-charts.com/spatial/interactive-maps-leaflet/#popup

DANmapwow <- leaflet(data = places) %>%
  addTiles() %>%
  addMarkers(lng = ~Longitude, lat = ~Latitude,
             popup = ~paste("Description: ", Description, 
                            "<br>", "Type: ", Type, 
                            "<br>", "Notes: ", Notes))

saveWidget(DANmapwow, "DANmapwow.html", selfcontained = TRUE)

######################################## CONGRATULATIONS - YOUR ARE DONE :)