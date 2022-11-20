#Garima Singh
#21-11-2022

## Reading the two data sets

setwd("C:/Users/Aadhar/Desktop/Uni/Open Data Science/data")

library(tidyverse)

library(readr)
math <- read.csv("C:/Users/Aadhar/Desktop/Uni/Open Data Science/student/student-mat.csv", sep=";", header=TRUE)
por <- read.csv("C:/Users/Aadhar/Desktop/Uni/Open Data Science/student/student-por.csv", sep=";", header=TRUE)

str(math)

head(math)

str(por)
head(por)

# look at the column names of both data sets
colnames(math); colnames(por)

## Joining the Data

# access the dplyr package
library(dplyr)

# give the columns that vary in the two data sets
free_cols <- c("failures","paid","absences","G1","G2","G3")

# the rest of the columns are common identifiers used for joining the data sets
join_cols <- setdiff(colnames(por), free_cols)

# join the two data sets by the selected identifiers
math_por <- inner_join(math, por, by = join_cols, suffix= c(".math", ".por"))

# look at the column names of the joined data set
col(math_por)

# glimpse at the joined data set

glimpse(math_por)

##Getting rid of duplicate data

# print out the column names of 'math_por'
math_por

# create a new data frame with only the joined columns
alc <- select(math_por, all_of(join_cols))

# print out the columns not used for joining (those that varied in the two data sets)
join_cols

# for every column name not used for joining...
for(col_name in free_cols) {
  # select two columns from 'math_por' with the same original name
  two_cols <- select(math_por, starts_with(col_name))
  # select the first column vector of those two columns
  first_col <- select(two_cols, 1)[[1]]
  
  # then, enter the if-else structure!
  # if that first column vector is numeric...
  if(is.numeric(first_col)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[col_name] <- round(rowMeans(two_cols))
  } else { # else (if the first column vector was not numeric)...
    # add the first column vector to the alc data frame
    alc[col_name] <- first_col
  }
}

# glimpse at the new combined data
glimpse(alc)

## Taking the average to create new coloumn alc_use

# access the tidyverse packages dplyr and ggplot2
library(dplyr); library(ggplot2)

# define a new column alc_use by combining weekday and weekend alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# initialize a plot of alcohol use
g1 <- ggplot(data = alc, aes(x = alc_use))

# define the plot as a bar plot and draw it
g1 + geom_bar()

# define a new logical column 'high_use'
alc <- mutate(alc, high_use = alc_use > 2)

# initialize a plot of 'high_use'
g2 <- ggplot(data = alc, aes(x = high_use))

# draw a bar plot of high_use by sex
g2 + geom_bar() + facet_wrap("sex") + aes(fill = high_use)

## Glimpse at the new data
glimpse(alc)

## Saving the data as alc
write.csv(alc,"C:/Users/Aadhar/Desktop/Uni/Open Data Science/data/alc.csv", row.names = FALSE)
