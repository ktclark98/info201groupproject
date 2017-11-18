# <center> INFO 201 Final Project </center>
<center> Kateka Seth, Katie Clark, Larissa Ho, and Tabitha Anderson </center>

#### **GitHub Link**
https://github.com/ktclark98/info201groupproject

#### **Project Description - [API Link](http://apiv3.iucnredlist.org/api/v3/docs#general)**
###### ***Dataset Information***
The dataset we are working with is from the IUCN Red List of Threatened Species. This organization is recognized for having the most comprehensive approach for evaluating plants and animals species in regards to their conservation status. Additionally, this dataset has a wide range of information ranging from location, historical components, and level of threat. The information is being accessed through the IUCN Red List API.
###### ***Target Audience***
 Our target audience for this project are environmentalists and people who have a deep appreciation for animals. We hope the information provided will provide them a baseline for understanding endangered species that are in particular interests to them and to learn about the actions they can take to help protect these species.
###### ***Questions for Investigation***
From our dataset, an audience member can learn a variety of information about endangered species. Specifically, they will be able to investigate the following questions and areas of focus:
  - What animals in a nearby region are considered endangered? How endangered are they (critically or not)?
    - From API: look into the Species by Country component
  - What actions can one take to help conserve a specific species?
    - From API: look into the Conversation Measures component
  - How many species in the world are considered endangered? How many are endangered in a particular region?
  - How has endangered species (count, danger level, etc.) changed over time?
    - From API: look into Historical Assessment component
  - Specific information on one species that the viewer is particularly interested in (i.e. habitat, region, how to help, etc.). By allowing a user to search a specific species and pull info about it (location, level of endangerment, etc.)
    - From API: look into Species Narrative Information component

#### **Technical Description**
  - Final Production Format:
    - Shiny app
  - How will you be reading in your data?
    - We will be using the IUCN Red List API to obtain the dataset
  - What types of data-wrangling (reshaping, reformatting, etc.) will you need to do to your data?
    - The API allows us to pull out a lot of information of endangered animals based on country, species, threats, and even historical assessment of a species. Most of the data-wrangling will be choosing which columns of the data frame we want to show off.
    - We also expect to stitch certain pieces from different endpoints together into one data frame that fully summarizes a species since the information for one specie can be scattered across various endpoint.
  - What (major/new) libraries will be used in this project?
    - We might use `rredlist` package which is a package in R created for this API
    - If we use spatial data we might need to use `R-ArcGIS` in order to get the maps to work
  - Anticipated Challenges:
    - Getting all the relevant API endpoints, since we expect to be using a lot of endpoints to get all the necessary data
    - Narrowing down the data that we actually want to use as there is a large amount available from the API
    - Working with spatial data in order to map habitat of a species if we decide to use the spatial data
