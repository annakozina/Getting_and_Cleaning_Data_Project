#1 Load data
getwd()
destfile <- "C:/june_project"
setwd(destfile)


list.files()

data<-data.frame(read.csv(file="data.csv", head=TRUE, sep=","))


#2 Total number of steps per day 
StepsPerDay <- data.frame(aggregate(data$steps, by=list(data$date), sum))
StepsPerDay <- setNames(StepsPerDay, c("date", "total_steps"))


## 2 build a histogram
StepsPerDay$date <- as.Date(StepsPerDay$date,format = "%m/%d/%Y")
str(StepsPerDay$date)
library(ggplot2)
library(scales)

ggplot(StepsPerDay, aes(total_steps)) +
  geom_histogram()
