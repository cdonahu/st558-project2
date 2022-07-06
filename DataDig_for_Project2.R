
library(tidyverse)
library(readr)
data <- readr::read_csv(file = "/Users/danekorver/Documents/st558/st558-project2/OnlineNewsPopularity.csv",show_col_types = FALSE)

#Goal: try to predict the number of shares using predictive models
str(attributes(data))
summary(data)

#Split into training/test set (70/30 split)
#indices to split on
train <- sample(1:nrow(data), size = nrow(data)*0.7)
test <- dplyr::setdiff(1:nrow(data), train)
#subset
dataTrain <- data[train, ]
dataTest <- data[test, ]

#trying to create a contingency table, although not worth anything
table(data$shares,data$data_channel_is_lifestyle,data$data_channel_is_entertainment, 
      data$data_channel_is_bus,data$data_channel_is_socmed,data$data_channel_is_tech,
      data$data_channel_is_world)

#create a graph 
#number of shares on y axis by data channel category
