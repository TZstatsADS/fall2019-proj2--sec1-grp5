nyc_dog_bite_df %>%
  group_by(ZipCode) %>%
  tally()
