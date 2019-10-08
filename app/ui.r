library(shiny)
library(leaflet)
library(shinythemes)

# Select items
breed_names <- readRDS('../output/select_items/breeds.rds')
nyc_zipcode <- readRDS('../output/select_items/nyc_zipcode.rds')
# neighborhood_names <- readRDS('../output/select_items/neighborhood.rds')
# borough <- readRDS('../output/select_items/borough.rds')

breed_names <- c('All', breed_names)
nyc_zipcode <- c('All', nyc_zipcode)
# neighborhood_names <- c('All', neighborhood_names)
# borough <- c('All', borough)


# UI Part
ui <- navbarPage( "Love Dogs!",
                  theme = shinytheme("darkly"),
                  id="navbar",
                  selected = "Density",
                  
                  
                  # 1. Density tab
                  tabPanel("Density",
                           sidebarLayout(
                             sidebarPanel = sidebarPanel(
                               titlePanel("Dog Density"),
                               
                               selectInput("density_level", "Level:", c("Borough" = "borough", "Neighborhood" = "neighborhood", "Zip Code Region" = "zip"), selected = 'zip'),
                               
                               selectInput("density_breed", "Breed:", breed_names),
                               selectInput("density_gender", "Dog Gender:", c("All" = "All", "Male" = "M",  "Female" = "F")),
                               
                               dateRangeInput("density_license_issued_date", "License Issued Date:", start="2014-09-01"),
                               radioButtons("density_license_status", "License Status:", choices = c("All" = 1, "Valid" = 2, "Expired" = 3), selected = 1, inline = TRUE)
                             ),
                             
                             mainPanel = mainPanel(
                               leafletOutput("densitymap", height= 700)
                             )
                           )
                  ),
                  
                  # 2. Danger zone tab
                  tabPanel("Danger Area",
                           sidebarLayout(
                             sidebarPanel = sidebarPanel(
                              titlePanel("Bite Records"),
                              
                              selectInput("bite_breed", "Breed:", breed_names),
                              selectInput("bite_gender", "Dog Gender:", c("All" = "All", "Male" = "M",  "Female" = "F")),                 
                              
                              dateRangeInput("bite_date", "Bite Date:", start="2000-01-01"),
                              
                              checkboxInput("showhospital", "Show Hospital:")
                             ),
                             # right panel
                             mainPanel = mainPanel(
                                includeCSS("./css/fixedpanel.css"),
                               # map 
                               leafletOutput("dangermap", height = 700),
                               # fixed plot
                               
                                absolutePanel(id="dangerstats", fixed = FALSE,
                                            class ="panel-fixed",
                                             draggable = FALSE, top = 30, right = 20,
                                             width = 300, height = "auto",
                                             
                                             #titlePanel("Top 5 Bite Dogs!"),
                                             selectInput("bite_zip", "ZipCode:", nyc_zipcode),
                                             plotOutput("zip_top5_bite", height = 350)
                               
                               )                 
                             )
                           )
                  )
                  # ,
                  
                  # # 3. parks feature
                  # tabPanel("Walk Dogs",
                  #          sidebarLayout(
                  #            sidebarPanel(
                               
                  #            ),
                             
                  #            mainPanel(
                  #              leafletOutput("parkmap", height = 600)
                               
                  #            )
                  #          )
                           
                  # )
)
