# # 
# # get_density_geo <- function(dataset_df, geo_data, groupby_col){
# #     # 1. group by and count
# #     density_df <- dataset_df %>%
# #       group_by(dataset_df[[groupby_col]]) %>%
# #       tally()
# #     # 2. rename the columns for the result
# #     names(density_df) <- c(groupby_col, "density")
# #     # 3. merge with zipcode
# #     geo_data@data <- merge(density_df, geo_data@data, by = groupby_col)
# #     print(names(data))
# #     return (geo_data)
# # }
# # 
# # 
# # col = "postalCode"
# # 
# # filtered_df <- data.frame(nyc_dog_bite_df[, "ZipCode"])
# # names(filtered_df) <- "postalCode"
# # density_geo <- get_density_geo(filtered_df, nyc_zip_geo, "postalCode")
# # # density_df <- filtered_df %>%
# # #   group_by(filtered_df[[col]]) %>%
# # #   tally()
# # 
# # 
# # qpal <- colorNumeric(
# #   palette = "YlOrRd", domain = density_geo$density
# # )
# # leaflet(density_geo) %>%
# #   addTiles() %>%
# #   addPolygons(
# #     data = density_geo,
# #     color = ~qpal(density),
# #     stroke = FALSE, 
# #     smoothFactor = 0.3, 
# #     fillOpacity = 0.8, 
# #     dashArray = 3,
# #     label = NULL,
# #     highlight = highlightOptions(
# #       weight = 5,
# #       color = "#ccc",
# #       dashArray = "",
# #       fillOpacity = 0.9,
# #       bringToFront = TRUE
# #     ))   %>%
# #   addLegend("bottomright", pal = qpal, value = ~ density, title = NULL)
# 
# 
# # saveRDS(nyc_zip_geo$postalCode, "../output/clean_data/") 
# 
# breed <-  c('Pug', 'Unknown', 'Crossbreed', 'Shih Tzu', 'Pit Bull', 'Chihuahua',
#              'Maltese', 'Labrador Retriever', 'Bulldog', 'German Shepherd',
#              'Pomeranian', 'Havanese', 'Beagle', 'Golden Retriever',
#              'Cocker Spaniel', 'Shiba Inu', 'Cavalier King Charles Spaniel', 'Hound',
#              'Siberian Husky', 'Poodle, Toy', 'Poodle, Miniature', 'Bichon Frise',
#              'Boxer', 'Poodle', 'Australian Shepherd', 'Schnauzer, Miniature',
#              'Labradoodle', 'Poodle, Standard', 'Miniature Pinscher', 'Goldendoodle',
#              'Dachshund', 'Lhasa Apso', 'Dachshund Smooth Coat', 'Morkie',
#              'Rottweiler', 'Pekingese', 'Miniature Schnauzer',
#              'Dachshund Smooth Coat Miniature', 'Maltipoo', 'Pointer', 'Papillon',
#              'Border Collie', 'Australian Cattledog', 'Brussels Griffon',
#              'American Eskimo dog', 'Dachshund, Long Haired Miniature',
#              'Shetland Sheepdog', 'Doberman Pinscher', 'American Bully',
#              'Welsh Corgi, Pembroke')
# 
# saveRDS(breed, 'output/breeds.rds')
# 
# # cleaned_dogs_df <- readRDS("output/clean_data/NYC_Dog_filter_cleaned.rds")
# 
# neighbor<- c('East Harlem', 'Southeast Bronx', 'Greenwich Village and Soho',
#              'Upper East Side', 'Upper West Side', 'Northwest Brooklyn',
#              'Gramercy Park and Murray Hill', 'Lower East Side', 'Sunset Park',
#              'Inwood and Washington Heights', 'Kingsbridge and Riverdale',
#              'Central Brooklyn', 'South Shore', 'Chelsea and Clinton',
#              'Southwest Brooklyn', 'East New York and New Lots', 'Borough Park',
#              'Southern Brooklyn', 'Canarsie and Flatlands', 'Northeast Queens',
#              'Lower Manhattan', 'Bronx Park and Fordham', 'Northwest Queens',
#              'West Central Queens', 'High Bridge and Morrisania', 'Jamaica',
#              'Northeast Bronx', 'Central Bronx', 'Greenpoint',
#              'Hunts Point and Mott Haven', 'West Queens',
#              'Bushwick and Williamsburg', 'Central Harlem',
#              'Stapleton and St. George', 'Mid-Island', 'Central Queens',
#              'Rockaways', 'North Queens', 'Southwest Queens',
#              'Southeast Queens', 'Flatbush', 'Port Richmond')
# saveRDS(neighbor, 'output/neighborhood.rds')
# 
# borough <- c('Manhattan', 'Bronx', 'Brooklyn', 'Staten Island', 'Queens')
# saveRDS(borough, 'output/borough.rds')
# 
# 
# nyc_zip <- readRDS('output/select_items/nyc_zipcode.rds')
# print(nyc_zip)
# 
# library(geojsonio)
# 
# RAW_DATA_DIR = "~/Developer/fall2019-proj2--sec1-grp5/data/geo"
# 
# nyc_zip_geo <- geojson_read( file.path(RAW_DATA_DIR, "NYC-Zip-Code.geojson"), what = "sp")
# 
# write.csv(nyc_zip, 'nyc-zip.csv')
# 
#cleaned_dog_bite_df <- read.csv("./output/cleaned_dog_bite.csv", stringsAsFactors = FALSE)
#names(cleaned_dog_bite_df)
library(geojsonio)
library(leaflet)
# nyc_bor_geo <- geojson_read("data/geo/NYC-Borough-Boundaries.geojson", what = "sp")
# print(nrow(nyc_bor_geo@data))
# 
# a <- data.frame(boro_name = c('Bronx', 'Staten Island', 'Brooklyn', 'Queens', 'Manhattan'), density = c(10,20,30,40,50))
# b = 'density'
# 
# 
# nyc_bor_geo$density <- a[b]
# 
# 
# pal <- colorNumeric(
#   palette = "YlOrRd",
#   domain = nyc_bor_geo$density
# )
# 
# 
# leaflet(nyc_bor_geo) %>%
#   addTiles() %>%
#   setView(lng=-73.98928, lat =40.75074 , zoom =10)%>%
#   addPolygons(
#     color = ~pal(density)
#     )
# 
# nyc_bor_geo@density <- apply()
# 
# leaflet(nyc_bor_geo) %>%
#   addTiles() %>%
#   setView(lng=-73.98928, lat =40.75074 , zoom =10)%>%
#   addProviderTiles("Esri") %>%
#   addPolygons(
#     stroke = T, weight=1,
#     fillOpacity = 0.95,
#     label = ~boro_name,
#   )


a = data.frame(title = c('a','b','c','d'))
b = data.frame(title = c('d','b','c','a'), value = c(1,2,3,4))
match(a, b)
