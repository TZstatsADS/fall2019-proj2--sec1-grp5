
# Merge the density value into the 'geo_data' and return the new one
get_density_geo <- function(dataset_df, geo_data, col_name){

  merged_df <- merge(geo_data@data, dataset_df,by = col_name, all.x = TRUE)
  # clean NA data
  merged_df[is.na(merged_df)] <- 0

  geo_data$density <- merged_df[match(geo_data@data[[col_name]], merged_df[[col_name]]), ][['density']]

  return(geo_data)
}

# create a new dataframe using 'original_col' column of 'data_df'
# and rename this column to 'renamed_col'
# return the dataframe 
get_one_col_df <- function(data_df, original_col, renamed_col){
  one_col_df <- data.frame(data_df[, original_col])
  names(one_col_df) <- renamed_col
  return(one_col_df)
}



# rename a single column, from 'original_name' to 'new_name'
# no return, the change is in place
rename_column_name <- function(dataset_df, original_name, new_name){
  names(dataset_df)[names(dataset_df) == original_name] <- new_name
}

# count the number of rows of 'dataset_df' group by 'by_col_name' 
# then rename the result columnnames to ('new_col_name', density)
# return the renamed dataframe
get_group_count <- function(dataset_df, by_col_name, new_col_name){
  density_df <- dataset_df %>%
    group_by(dataset_df[[by_col_name]]) %>%
    tally()
  names(density_df) <- c(new_col_name, "density")
  return(density_df)
}



