# Project 2: Shiny App Development Version 2.0

### [Project Description](doc/project2_desc.md)

![screenshot](doc/screenshot2.png)

In this second project of GR5243 Applied Data Science, we develop a version 2.0 of an *Exploratory Data Analysis and Visualization* shiny app on a topic of your choice using [NYC Open Data](https://opendata.cityofnewyork.us/) or U.S. government open data released on the [data.gov](https://data.gov/) website. See [Project 2 Description](doc/project2_desc.md) for more details.  

The **learning goals** for this project is:

- business intelligence for data science
- study legacy codes and further development
- data cleaning
- data visualization
- systems development/design life cycle
- shiny app/shiny server

*The above general statement about project 2 can be removed once you are finished with your project. It is optional.

## Project Title Lorem ipsum dolor sit amet
Term: Fall 2019

+ Team: Section1 Group5
+ **Projec title**: + Team members
	+ Syed Ahsan Bukhari (sab2302)
	+ Haofeng Chen (hc2962)
	+ Qichao Chen (qc2254)
	+ Yanling Dai (yd2456)
	+ Yifan Yang (yy2955)

+ **Project summary**: Dog has been an important partner for many people’s daily life. Dogs are so beloved that owners often consider them as their own children and name them according to their unique personalities. According to the New York City Economic Development Corporation, there are around 600,000 dogs in NYC. Therefore, in this project, we are interested to look deeper into the dog population in NYC. The target users for our shiny app are pet retailers, dog lovers, and non-dog lovers. More specifically, for a pet retailer opening a new store in NYC, they may interest to see the dog density in each area of the city and find the store locations which are surrounded by numerous of dog owners. In addition, by looking at the dog breed distribution in the associated area, a local pet retailer could decide its store inventories to meet the needs of the popular dog breed in its regions. On the other hand, for the individual user, if you are a dog lover that recently move to New York, you may want to move to a dog-friendly neighborhood so that it will suit for you and your dog, and the dog density information on our app can help you on such decisions. For non-dog lovers, you may try to avoid walking in dog-dense areas. Also, our danger zone provides information for non-dog lovers about dog bite incidents information for each area and the associated dog bite statistic by breed. Non-dog lovers may also want to pay attention to those danger areas and dangerous breeds.

+ **Contribution statement**: ([default](doc/a_note_on_contributions.md)) All team members contributed equally in all stages of this project. All team members approve our work presented in this GitHub repository including this contributions statement. 

1. Data Exploration & Cleaning - Bukhari, Syed Ahsan sab2302@columbia.edu
- Updated Breed Name and made top 20 of 70% data
- Updated Data Types ( like date, numeric etc)
- Added Longitude, Latitude, City, County
- Few additional column for analysis like Age, Expiry year etc
- converted clean dataset copy as "RDS" - which will be used for app. 
- App Testing: Data Quality and Projection accuracy  
 
2. Shiny app Developer - Chen, Haofeng hc2962@columbia.edu
- Mapped the data’s zip code to the associated boroughs, districts and geocode
- Developed the density page of the shiny app 
- Write the project report
- Provide guidance on the project ppt. 
 
3. Prototype Design - Chen, Qichao qc2254@columbia.edu
Cleaned the dataset and updated population density column
Mainly developed prototype of the density page 
 
4. Documentation & Presentation - Dai, Yanling yd2456@columbia.edu
Developed slides and the data story.
Give the presentation.
 
5. Lead Shiny app Developer - Yang, Yifan yy2955@columbia.edu
Collect most datasets and geographical files
Do the final cleaning before applying data to the application
Build shiny app application: density, danger zone, park

On our first group meeting on October 2, 2019, we discussed the following topics:
1.	Potential visualization topics for our shiny app
2.	Added 3 more datasets to the projects. 
3.	Basic layout of the Shiny app
4.	Task assignment for each group member 

On our second group meeting on October 6, 2019, we discussed the following topics:
1.	Updates on everyone’s progress
2.	Problems that each group member faced so far and feasible solutions for those problems
3.	Share ideas on the UI design
4.	Assign the remaining tasks to each group member 

On our third group meeting on October 8, 2019, we discussed the following topics:
1.	Presented the project’s progress and the current bugs we experienced
2.	Discuss each group member’s contribution 
3.	Briefly went through the presentation slides.  


Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
├── app/
├── lib/
├── data/
├── doc/
└── output/
```

Please see each subfolder for a README file.

