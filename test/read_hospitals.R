
# 1. read hospital data
hospital_df <- read.csv("../data/hospitals.csv")

# 2. prepare object for popup and icon
hospital_popup <- sprintf(
  "<strong>%s</strong><br/> Location: %s", 
  hospital_df$Facility.Name, hospital_df$Location.1
) %>% lapply(htmltools::HTML)

hospital_icon <- makeIcon(
  iconUrl = "https://clarkebenefits.com/wp-content/uploads/2018/07/hospital-icon.png",
  iconWidth = 18,
  iconHeight = 18
)
