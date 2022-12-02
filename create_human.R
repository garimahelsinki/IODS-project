#Garima Singh
#24-11-2022
#Data Wrangling Assignment 4 (Data Wrangling Assignment 5 below)

## Reading the two data sets

setwd("C:/Users/Aadhar/Desktop/Uni/Open Data Science/data")

library(tidyverse)

library(readr)

hd <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
gii <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")

#Exploring Data Sets

str(hd)
head(hd)

str(gii)
head(gii)

#Renaming the variables with (shorter) descriptive names

colnames(hd) <- c("HDIRank","Country","HDI","LifeExpectancy","ExpEduYears","MeanEduYears","GNIC","GNIC_minus_HDIRank")
colnames(gii) <- c("GIIRank","Country","GII","MMR","ABR","RepinParliament","SecEd_F","SecEd_M","LFPR_F","LFPR_M")

#Mutating the “Gender inequality” data and create two new variables

#1.Ratio of Female and Male populations with secondary education in each country. (i.e. edu2F / edu2M).

gii <- mutate(gii, SecEd_FtoM = SecEd_F / SecEd_M)

#2.Ratio of labor force participation of females and males in each country (i.e. labF / labM)

gii <- mutate(gii, LFPR_FtoM = LFPR_F / LFPR_M)

#Join together the two datasets using the variable Country as the identifier.

human <- inner_join(hd, gii, by = "Country", suffix=c(".hd",".gii"))
str(human)
head(human)

view(human)

## Saving the data as human
#write.csv(human,"C:/Users/Aadhar/Desktop/Uni/Open Data Science/data/human.csv", row.names = FALSE)

##Data Wrangling Assignment 5
##01-12-2022

#Loading human data 

# Change GNI variable to numeric.
# access the stringr package
library(stringr)

# look at the structure of the gross national income column in 'human'
str(human$GNIC)

# remove the commas from GNI and print out a numeric version of it
human$GNIC <- str_replace(human$GNIC, pattern=",", replace ="") %>% as.numeric


## Exclude unneeded variables. Keep equivalents to "Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F"

# List columns in human
colnames(human)

keepVariables <- c("Country", "SecEd_FtoM", "LFPR_FtoM", "ExpEduYears", "LifeExpectancy", "GNIC", "MMR", "ABR", "RepinParliament")
human <- select(human, one_of(keepVariables))


## Remove countries with missing values
# filter out all rows with NA values
human <- filter(human, complete.cases(human))


## Remove region observations at the end of the dataframe
# look at the last 10 observations of human
tail(human, n = 10)

# define the last indice we want to keep
last <- nrow(human) - 7

# choose everything until the last 7 observations
human <- human[1:last, ]


## Define rownames as the country names. One should end up with 155 observations and 8 variables.
# add countries as rownames
rownames(human) <- human$Country

# Remove the country variable
human <- select(human, -Country)

# Save as .csv file
write.csv(human,"C:/Users/Aadhar/Desktop/Uni/Open Data Science/data/human.csv", row.names = FALSE)

