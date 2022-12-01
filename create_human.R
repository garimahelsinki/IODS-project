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
write.csv(human,"C:/Users/Aadhar/Desktop/Uni/Open Data Science/data/human.csv", row.names = FALSE)

##Data Wrangling Assignment 5
##01-12-2022

#Loading human data 
setwd("C:/Users/Aadhar/Desktop/Uni/Open Data Science/data")

library(readr)
human <- read_csv("C:/Users/Aadhar/Desktop/Uni/Open Data Science/data/human.csv",show_col_types = FALSE)

#Mutate the data: transforming GNI to numeric

human$GNIC <- gsub(",","", human$GNIC) %>% as.numeric()

#Excluding unneeded variables:

keep <- c("Country", "SecEd_FtoM", "LFPR_FtoM", "ExpEduYears", "LifeExpectancy", "GNIC", "MMR", "ABR", "RepinParliament")
library(dplyr)
human <- dplyr:: select(human, one_of(keep))

#Removing all rows with missing value
human <- filter(human, complete.cases(human))

#Remove the observations which relate to regions instead of countries.
rownames(human) <- human$Country
n_until <- nrow(human) - 7
human <- human[1:n_until, ]

#Removing country variable
human <- dplyr:: select(human, -Country)

#saving and overwriting previous human data
write.csv(human,"C:/Users/Aadhar/Desktop/Uni/Open Data Science/data/human.csv", row.names = FALSE)

