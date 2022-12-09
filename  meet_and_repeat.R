#Garima Singh
#08-12-2022
#Data Wrangling for Assignment 6

## Setting working directory and reading packages

setwd("C:/Users/Aadhar/Desktop/Uni/Open Data Science/data")

library(tidyverse)

library(readr)

#1. Load the data sets (BPRS and RATS)
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", header = TRUE, sep  =" ")
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header = TRUE, sep  ='\t')

#check their variable names, view the data contents and structures, and create some brief summaries of the variables 

#Check Variable names
names(BPRS)
names(RATS)
#View content and structure
str(BPRS)
str(RATS)
# Create summary
summary(BPRS)
summary(RATS)


#2.Convert the categorical variables of both data sets to factors.
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)
RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)


#3. Convert the data sets to long form. Add a week variable to BPRS and a Time variable to RATS.

# Convert to long form
BPRSL <-  pivot_longer(BPRS, cols=-c(treatment,subject),names_to = "weeks",values_to = "bprs") %>% arrange(weeks)

# Extract the week number
BPRSL <-  BPRSL %>%
  mutate(week = as.integer(substr(weeks, 5, 5)))


# Adding time variable to RATS
RATSL <- RATS %>%
  gather(key = WD, value = Weight, -ID, -Group) %>%
  mutate(Time = as.integer(substr(WD,3,4)))


#4.look at the new data sets and compare them with their wide form versions

#names
names(BPRSL)
names(RATSL)
#Content and structure of datasets
str(BPRSL)
str(RATSL)
# summaries of the variables
summary(BPRSL)
summary(RATSL)

