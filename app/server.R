library(shiny)
library(dplyr)
library(leaflet)
library(dplyr)
library(geojsonio)

# load raw data
dog_license_df <- readRDS('../output/cleaned_dog_license.rds')
# cols: "X"  "UniqueID"   "DateOfBite" "Breed"      "Age"        "Gender"     "Borough"    "ZipCode"   
dog_bite_df <- readRDS('../output/cleaned_dog_bite.rds')
hospital_df <- readRDS('../output/cleaned_hospital.rds')

server_nyc_zip_geo <- geojson_read("../data/geo/NYC-Zip-Code.geojson", what = "sp")
server_nyc_nei_geo <- geojson_read("../data/geo/NYC-Neighborhood.geojson", what = "sp")
server_nyc_bor_geo <- geojson_read("../data/geo/NYC-Borough-Boundaries.geojson", what = "sp")
# server_nyc_park_geo <- geojson_read("../data/geo/parks.geojson", what = "sp")


# labels and icons template
hospital_popup <- sprintf(
  "<strong>%s</strong><br/> Phone: %s", 
  hospital_df$Name, hospital_df$Phone
) %>% lapply(htmltools::HTML)

hospital_icon <- makeIcon(
  iconUrl = "https://clarkebenefits.com/wp-content/uploads/2018/07/hospital-icon.png",
  iconWidth = 18,
  iconHeight = 18
)

# independent helper functio
source("./helper.R")

# application-wide helper function

# Add polygons on the 'mapobj', using 'density_geo' Data
# return the processed mapobj
redraw_danger_map <- function(mapobj, density_geo, label_name = NULL){
  
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
      label = paste("Region: ", as.character(density_geo[[label_name]]), " Number: ", as.character(density_geo$density)),
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
# define color function
color.function <- colorRampPalette( c( "#104E8B","#CCCCCC" ) )

server <- function(input, output){
  # load geo data: 1 for each user
  nyc_zip_geo <- server_nyc_zip_geo
  nyc_nei_geo <- server_nyc_nei_geo
  nyc_bor_geo <- server_nyc_bor_geo


  # Section 1: normal plots
  # 1. bite top 5
  get_filtered_zip_bite_df <- reactive({
    filtered_zip_bite_df <- dog_bite_df
    if(input$bite_zip != "All"){
        filtered_zip_bite_df <- filtered_zip_bite_df %>% 
        filter(ZipCode==input$bite_zip) 
    }
    
    return(filtered_zip_bite_df)
  })

  output$zip_top5_bite <- renderPlot({
    # get data
    filtered_zip_bite_df <- get_filtered_zip_bite_df() %>% 
        group_by(Breed) %>% tally()
        names(filtered_zip_bite_df) <- c("Breed", "density")
    # count
    top5_bite_df <- filtered_zip_bite_df[order(filtered_zip_bite_df$density,decreasing = TRUE),][1:5,]
    # color
    color_ramp <- color.function(nrow(top5_bite_df))
    top5_bite_df$color = color_ramp
    barplot(top5_bite_df$density, names.arg = top5_bite_df$Breed, 
        cex.names = 0.7, main = paste("Top 5 Bite Dogs in ", input$bite_zip), 
        col = top5_bite_df$color, las = 2 )
  })

  # 2. density top dogs
  get_area_breed_df <- reactive({
    selected_area_license_df <- dog_license_df
    if(input$density_level == "borough" & input$density_top_bor != "All" ){
        # filter borough
        selected_area_license_df <- selected_area_license_df %>% 
          filter(Borough == input$density_top_bor) 
    }
    else if(input$density_level == "neighborhood" & input$density_top_nei != "All"){
        # filter nei
        selected_area_license_df <- selected_area_license_df %>% 
          filter(GEONAME == input$density_top_nei)
    }
    else if(input$density_level == "zip" & input$density_top_zip != "All"){
        # filter zip
        selected_area_license_df <- selected_area_license_df %>%
        filter(zip == input$density_top_zip) 
        
    }
    return(selected_area_license_df)
  })

  output$densitytopdogs <- renderPlot({
      area_breed_df <- get_area_breed_df() %>%
        group_by(BreedName) %>% tally()
      names(area_breed_df) <- c("Breed", "density")
      top20_bite_df <- area_breed_df[order(area_breed_df$density,decreasing = TRUE),][1:20,]
      color_ramp <- color.function(nrow(top20_bite_df))
      top20_bite_df$color <- color_ramp
      barplot(top20_bite_df$density, names.arg = top20_bite_df$Breed, 
            cex.names = 0.7, main = "Most Popular Dogs", 
            col = top20_bite_df$color ,las = 2 )
  })


  # Section2: Density 
  ## 2.1 reactive data for Density
  switched_density_geo <- reactive({
    switch(input$density_level, "borough" = c("bor", nyc_bor_geo), "zip" = c('zip',nyc_zip_geo), "neighborhood" =c('nei', nyc_nei_geo) )
    # switch(input$density_level, "zip" = c('zip',nyc_zip_geo), "neighborhood" =c('nei', nyc_nei_geo) )
  })
  # filter density reactive data
  get_filtered_density_df <- reactive({
    filtered_density_df <- dog_license_df
    # filter gender
    if(input$density_gender != "All"){
      filtered_density_df <- filtered_density_df %>%
        filter(AnimalGender== input$density_gender)
    }
    # filter breed
    if(input$density_breed != "All"){
      filtered_density_df <- filtered_density_df %>%
        filter(BreedName == input$density_breed)
    }
    # filter date
    filtered_density_df <- filtered_density_df %>%
      filter(LicenseIssuedDate >= input$density_license_issued_date[1] & LicenseIssuedDate <= input$density_license_issued_date[2])
    
    # filter license status
    if(input$density_license_status == 2){ # valid
      filtered_density_df <- filtered_density_df %>%
      filter(Sys.Date() >= LicenseExpiredDate)
    }
    else if(input$density_license_status == 3){
      filtered_density_df <- filtered_density_df %>%
      filter(Sys.Date() < LicenseExpiredDate)
    }
    return(filtered_density_df)

  })

  # 2.2 output for Density
  output$densitymap <- renderLeaflet({
    leaflet()%>%
      addTiles() %>%
      setView(-74.0060,40.7128, 10)

  })
  # 2.3 proxy change for Density
  observe({
    level_name <- switched_density_geo()[[1]]
    level_geo <- switched_density_geo()[[2]]
    
    if(level_name == 'bor'){
        # geo col: boro_name   data col: Borough
        ori_col_name <- "Borough"
        new_col_name <- "boro_name"
    }
    else if(level_name == 'nei'){
        # geo col: GEONAME   data col: GEONAME
      ori_col_name <- "GEONAME"
      new_col_name <- "GEONAME"
    }
    else{
        # geo col: postalCode   data col: ZipCode      
      ori_col_name <- "zip"
      new_col_name <- "postalCode"
    }
    one_col_df <- get_one_col_df(get_filtered_density_df(), ori_col_name, new_col_name)
    density_df <- get_group_count(one_col_df, new_col_name, new_col_name)
    level_geo <- get_density_geo(density_df, level_geo, new_col_name)
    # level_geo@data <- merge(density_df, level_geo@data, by = new_col_name, all.x = TRUE)

    redraw_danger_map(leafletProxy("densitymap", data = level_geo), level_geo, label_name= new_col_name)

  })  

  # Section3. Bite
  # 3.1 bite reactive data
  get_filtered_bite_df <- reactive({
    filtered_bite_df <- dog_bite_df[,]
    # filter bite gender
    if(input$bite_gender != "All"){
      filtered_bite_df <- filtered_bite_df %>%
        filter(Gender== input$bite_gender)
    }
    # filter bite breed
    if(input$bite_breed != "All"){
      filtered_bite_df <- filtered_bite_df %>%
        filter(Breed == input$bite_breed)
    }
    # filter date
    filtered_bite_df <- filtered_bite_df %>%
      filter(DateOfBite >= input$bite_date[1] & DateOfBite <= input$bite_date[2])
    
    return(filtered_bite_df)
  })

  # 3.2 output map
  output$dangermap <- renderLeaflet({
    # initialize danger map 
    one_col_df <- get_one_col_df(dog_bite_df, "ZipCode", "postalCode")
    density_df <- get_group_count(one_col_df, "postalCode", "postalCode")
    
    density_geo <- get_density_geo(density_df, nyc_zip_geo, "postalCode")

    m <- leaflet(density_geo) %>%
      addTiles() %>%
      setView(-74.0060,40.7128, 10)
    
    redraw_danger_map(m, density_geo, label_name = 'postalCode')
  })

  # 3.3 proxy change
  observe({
      # prepare density numbers
    one_col_df <- get_one_col_df(get_filtered_bite_df(), "ZipCode", "postalCode")
    density_df <- get_group_count(one_col_df, "postalCode", "postalCode")
    density_geo <- get_density_geo(density_df, nyc_zip_geo, "postalCode")

    redraw_danger_map(leafletProxy("dangermap", data = density_geo), density_geo, label_name="postalCode")
      
    })    
  observe({
    if(input$showhospital){
      leafletProxy("dangermap") %>%
        addMarkers(group = "hospital", data = hospital_df, 
                  lng = ~Longitude, lat = ~Latitude, icon = hospital_icon,
                  popup = hospital_popup, label = ~as.character(Name))
    }
    else{
      leafletProxy("dangermap") %>%
        clearMarkers()
    }
  })

  # Section3: set proxy map data for each part
  
  output$parkmap <- renderLeaflet({
    leaflet()%>%
      addTiles() %>%
      setView(-74.0060,40.7128, 12)
      
  })
  
  
  # Section4: User proxy data to redraw map
  # 4.1 danger zone
  
  
}
