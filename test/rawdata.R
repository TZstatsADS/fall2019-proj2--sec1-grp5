library(geojsonio)

RAW_DATA_DIR = "~/Developer/fall2019-proj2--sec1-grp5/data/geo"

# load the NYC zipcode data
nyc_zip_geo <- geojson_read( file.path(RAW_DATA_DIR, "NYC-Zip-Code.geojson"), what = "sp")

nyc_dis_geo <- geojson_read( file.path(RAW_DATA_DIR, "NYC-Community-Districts.geojson"), what = "sp")


nyc_neighbor_geo <- geojson_read( file.path(RAW_DATA_DIR, "NYC-Neighborhood.geojson"), what = "sp")


nyc_bor_geo <- geojson_read( file.path(RAW_DATA_DIR, "NYC-Borough-Boundaries.geojson"), what = "sp")
