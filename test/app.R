library(shiny)
library(leaflet)
# library(rgdal)
library(dplyr)
library(sqldf)
library(shinythemes)
library(geojsonio)

# RAW_DATA_DIR = "~/Developer/fall2019-proj2--sec1-grp5/data/geo"


setwd("~/Developer/fall2019-proj2--sec1-grp5")
# 1. get necessary data
nyc_zip_geo <- geojson_read("data/geo/NYC-Zip-Code.geojson", what = "sp")

breeds <- readRDS(file = "output/breeds.rds")
breeds <- c("All", as.character(breeds))

nyc_dog_bite_df <- readRDS("output/dog_bite_filtered.rds")
hospital_df <- read.csv("data/hospitals.csv")

# 2. prepare prompts
hospital_popup <- sprintf(
  "<strong>%s</strong><br/> Location: %s", 
  hospital_df$Facility.Name, hospital_df$Location.1
) %>% lapply(htmltools::HTML)

hospital_icon <- makeIcon(
  iconUrl = "https://clarkebenefits.com/wp-content/uploads/2018/07/hospital-icon.png",
  iconWidth = 18,
  iconHeight = 18
)



# UI Part
ui <- navbarPage( "Love Dogs!",
    theme = shinytheme("darkly"),
    # navbar other parameters
    id="navbar",
    selected = "Density",
    
    
    # 1. Density tab
    tabPanel("Density",
             
        sidebarLayout(
          sidebarPanel = sidebarPanel(
            titlePanel("Dog Density"),
            
            selectInput("densitylevel", "Level:", c("Borough" = "borough", "District" = "district", "Zip Code Region" = "zip")),
            
            selectInput("breed", "Breed:", breeds),
            selectInput("gender", "Dog Gender:", c("All" = "all", "Male" = "male",  "Female" = "female")),
            sliderInput("birthYear", "Birth Year", 10,1000, 500 ),  # TODO
            dateRangeInput("license_issued_date", "License Issued Date"),
            radioButtons("license_status", "License Status", choices = c("All" = 1, "Valid" = 2, "Expired" = 3), selected = 1, inline = TRUE)
          ),
          
          mainPanel = mainPanel(
            leafletOutput("densityMap")
          )
        )
    ),
    
    # 2. Danger zone tab
    tabPanel("Danger Area",
             sidebarLayout(
               sidebarPanel = sidebarPanel(
                 titlePanel("Bite Records"),
                 
                 selectInput("bite_breed", "Breed:", breeds),
                 selectInput("bite_gender", "Dog Gender:", c("All", "Male","Female","Unknown")),                 
                 dateRangeInput("bite_date", "Bite Date:", start="2000-01-01"),
                 
                 checkboxInput("showhospital", "Show Hospital")
               ),
               
               mainPanel = mainPanel(
                 leafletOutput("bitemap", height = 500),
                 textOutput("test")
                 
               )
             )
    ),
    
    # 3. parks feature
    tabPanel("Walk Dogs",
         sidebarLayout(
           sidebarPanel = sidebarPanel(
             
           ),
           
           mainPanel = mainPanel(
                leafletOutput("map")
             
           )
         )
    )
)





redraw_density <- function(map_proxy, dataset_geo, density_col_name, bins = c(0,100, 500, 1000, 2000, 5000, Inf), labels = NULL){
  # set color 
  pal <- colorBin("YlOrRd", domain = dataset_geo[[density_col_name]], bins = bins)
  
  # create map
  m <- map_proxy %>%
    
  
  return(m)
}

server <- function(input, output){
  
  # bite-tab reactive data
  filtered_bite_df <- reactive({
    filtered_bite_df <- nyc_dog_bite_df[,]
    # 1. filter data
    # 1.1 filter bite gender
    if(input$bite_gender != "All"){
      filtered_bite_df <- filtered_bite_df %>%
        filter(Gender== input$bite_gender)
    }
    # 1.2 filter bite breed
    if(input$bite_breed != "All"){
      filtered_bite_df <- filtered_bite_df %>%
        filter(Breed == input$bite_breed)
    }
    # 1.3 filter date
    filtered_bite_df <- filtered_bite_df %>%
      filter(DateOfBite >= input$bite_date[1] & DateOfBite <= input$bite_date[2])
    
    # return(nrow(filtered_bite_df))
    return(filtered_bite_df)
    })
  

  output$test <- renderText({
    
  })
  
  # label format for zip code map
  zip_level_labels <- sprintf(
    "<strong>Zip Code: %s</strong><br/> Number: %s", 
    nyc_zip_geo$postalCode, nyc_zip_geo$density
  ) %>% lapply(htmltools::HTML)
  
  # basic map object
  output$bitemap <- renderLeaflet({
    leaflet(nyc_dog_bite_df) %>%
      addTiles() %>%
      setView(-74.0060,40.7128, 12) %>%
      fitBounds( -74.36, 40.40, -73.2, 41.14)
  })
  
  
  # danger zone: filter
  observe({
    filtered_data <- filtered_bite_df()
    # 1. group count
    bite_density_df <- filtered_data %>%
      group_by("ZipCode") %>%
      tally()
    names(bite_density_df) <- c("postalCode", "density")
    # 2. merge with zipcode
    nyc_zip_geo@data <- merge(bite_density_df, nyc_zip_geo@data, by.x = "postalCode", by.y="postalCode")
    
    # 3. add new polys
    bins <- c(0,100, 500, 1000, 2000, 5000, Inf)
    pal <- colorBin("YlOrRd", domain = nyc_zip_geo[["density"]], bins = bins)
    
    leafletProxy("bitemap", data = nyc_zip_geo)  %>%
      clearShapes() %>%
      addPolygons( 
        fillColor = ~pal(nyc_zip_geo[["density"]]),
        stroke = FALSE, 
        smoothFactor = 0.3, 
        fillOpacity = 0.8, 
        dashArray = 3,
        label = NULL,
        highlight = highlightOptions(
          weight = 5,
          color = "#ccc",
          dashArray = "",
          fillOpacity = 0.9,
          bringToFront = TRUE
        ))  %>%
      clearControls() %>%
      addLegend(pal = pal, values  = ~nyc_zip_geo[["density"]], 
                opacity = 0.7, title = NULL, position = "bottomright")

  })
  # danger zone: check hospital icons
  observe({
    if(input$showhospital){
      leafletProxy("bitemap") %>%
        addMarkers(group = "hospital", data = hospital_df, lng = ~Longitude, lat = ~Latitude, icon = hospital_icon,
                   popup = hospital_popup, label = ~as.character(Facility.Name))
    }
    else{
      leafletProxy("bitemap") %>%
        clearMarkers()
    }
  })
}

shinyApp(ui, server)
