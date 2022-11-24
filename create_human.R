#Garima Singh
#24-11-2022
#Data Wrangling Assignment 4

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
