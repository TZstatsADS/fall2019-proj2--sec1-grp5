
# count the dataset_df's 'groupby_col', then merge with geo_data
# return a new geo_data with an additional count column
get_density_geo <- function(dataset_df, geo_data, groupby_col){
  # 1. group by and count
  density_df <- dataset_df %>%
    group_by(dataset_df[[groupby_col]]) %>%
    tally()
  # 2. rename the columns for the result
  names(density_df) <- c(groupby_col, "density")
  # 3. merge with zipcode
  geo_data@data <- merge(density_df, geo_data@data, by = groupby_col)
  return (geo_data)
}