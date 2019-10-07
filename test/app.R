library(shiny)
library(leaflet)
# library(rgdal)
library(dplyr)
library(sqldf)
library(shinythemes)
library(geojsonio)


# Fixed Data To All Users: 
# categories: 1. breeds 

source("./helper.R")
# read geo data
source("./read_geodata.R")

# setwd("~/Developer/fall2019-proj2--sec1-grp5")

breeds <- readRDS(file = "../output/breeds.rds")
breeds <- c("All", as.character(breeds))
nyc_zipcodes <- readRDS(file = "../output/nyc-zipcode.rds")


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
            leafletOutput("densitymap", height= 600)
          )
        )
    ),
    
    # 2. Danger zone tab
    tabPanel("Danger Area",
        sidebarLayout(
            # left filters
            sidebarPanel = sidebarPanel(
                titlePanel("Bite Records"),
                
                selectInput("bite_breed", "Breed:", breeds),
                selectInput("bite_gender", "Dog Gender:", c("All", "Male","Female","Unknown")),                 
                dateRangeInput("bite_date", "Bite Date:", start="2000-01-01"),
                
                checkboxInput("showhospital", "Show Hospital")
            ),
            # right panel
            mainPanel = mainPanel(
                # map 
                leafletOutput("dangermap", height = 600),
                # fixed plot
                absolutePanel(id="dangerstats", fixed = TRUE,
                    draggable = FALSE, top = 150, right = 20,
                    width = 200, height = "auto",
                    
                    #titlePanel("Top 5 Bite Dogs!"),
                    selectInput("dangerzip", "ZipCode:", nyc_zipcodes),
                    plotOutput("top5bitedogs", height = 200)
                )                 
            )
        )
    ),
    
    # 3. parks feature
    tabPanel("Walk Dogs",
        sidebarLayout(
            sidebarPanel(

            ),

            mainPanel(
              leafletOutput("parkmap", height = 600)

            )
        )

    )
)


redraw_danger_map <- function(mapobj, density_geo){
    
    qpal <- colorNumeric(
        palette = "YlOrRd", domain = density_geo$density
    )       
    mapobj %>%
    clearShapes() %>%  # clear original polygons    
    addPolygons(
        color = ~qpal(density),
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
        ))   %>%
    clearControls() %>%  # clear original legends
    addLegend("bottomright", pal = qpal, value = ~ density, title = NULL)

}


# datasetL 1. hospital 2. cleaned bite, 3. cleaned license
nyc_dog_bite_df <- readRDS("../output/dog_bite_filtered.rds")
source("./read_hospitals.R")

server <- function(input, output){

    # Section 0: normal plots
    output$top5bitedogs <- renderPlot({
      
    })

    # Section1: maintain a copy of geo data for each user
    user_nyc_zip_geo <- nyc_zip_geo
    user_nyc_bor_geo <- nyc_bor_geo

    # Section2: Add reactive field to filter data

    # 2. bite-tab reactive data
    get_filtered_bite_df <- reactive({
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

    # Section3: set proxy map data for each part
    output$densitymap <- renderLeaflet({
      leaflet()%>%
        addTiles() %>%
        setView(-74.0060,40.7128, 12) %>%
        fitBounds( -74.36, 40.40, -73.2, 41.14)
    })


    
    output$dangermap <- renderLeaflet({

        # initialize danger map 
        filtered_df <- data.frame(get_filtered_bite_df()[, "ZipCode"])
        names(filtered_df) <- "postalCode"
        density_geo <- get_density_geo(filtered_df, nyc_zip_geo, "postalCode")

        m <- leaflet(density_geo) %>%
            addTiles() %>%
            setView(-74.0060,40.7128, 12) %>%
            fitBounds( -74.36, 40.40, -73.2, 41.14)
        redraw_danger_map(m, density_geo)

    })
    output$parkmap <- renderLeaflet({
      leaflet()%>%
        addTiles() %>%
        setView(-74.0060,40.7128, 12) %>%
        fitBounds( -74.36, 40.40, -73.2, 41.14)
    })


    # Section4: User proxy data to redraw map
    # 4.1 danger zone
    observe({
        # prepare density numbers
        filtered_df <- data.frame(get_filtered_bite_df()[, "ZipCode"])
        names(filtered_df) <- "postalCode"
        density_geo <- get_density_geo(filtered_df, nyc_zip_geo, "postalCode")
    
        redraw_danger_map(leafletProxy("dangermap", data = density_geo), density_geo)
        
    })    
    # 4.1 danger zone: check hospital icons
    observe({
        if(input$showhospital){
            leafletProxy("dangermap") %>%
            addMarkers(group = "hospital", data = hospital_df, 
            lng = ~Longitude, lat = ~Latitude, icon = hospital_icon,
            popup = hospital_popup, label = ~as.character(Facility.Name))
        }
        else{
            leafletProxy("dangermap") %>%
            clearMarkers()
        }
    })
    
}
  

shinyApp(ui, server)
