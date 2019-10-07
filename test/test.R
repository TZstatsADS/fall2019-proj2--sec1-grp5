# 
# get_density_geo <- function(dataset_df, geo_data, groupby_col){
#     # 1. group by and count
#     density_df <- dataset_df %>%
#       group_by(dataset_df[[groupby_col]]) %>%
#       tally()
#     # 2. rename the columns for the result
#     names(density_df) <- c(groupby_col, "density")
#     # 3. merge with zipcode
#     geo_data@data <- merge(density_df, geo_data@data, by = groupby_col)
#     print(names(data))
#     return (geo_data)
# }
# 
# 
# col = "postalCode"
# 
# filtered_df <- data.frame(nyc_dog_bite_df[, "ZipCode"])
# names(filtered_df) <- "postalCode"
# density_geo <- get_density_geo(filtered_df, nyc_zip_geo, "postalCode")
# # density_df <- filtered_df %>%
# #   group_by(filtered_df[[col]]) %>%
# #   tally()
# 
# 
# qpal <- colorNumeric(
#   palette = "YlOrRd", domain = density_geo$density
# )
# leaflet(density_geo) %>%
#   addTiles() %>%
#   addPolygons(
#     data = density_geo,
#     color = ~qpal(density),
#     stroke = FALSE, 
#     smoothFactor = 0.3, 
#     fillOpacity = 0.8, 
#     dashArray = 3,
#     label = NULL,
#     highlight = highlightOptions(
#       weight = 5,
#       color = "#ccc",
#       dashArray = "",
#       fillOpacity = 0.9,
#       bringToFront = TRUE
#     ))   %>%
#   addLegend("bottomright", pal = qpal, value = ~ density, title = NULL)


saveRDS(nyc_zip_geo$postalCode, "../output/nyc-zipcode.rds") 
