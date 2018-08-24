---
title: 'Reproducible Research: Peer Assessment 1'
author: "Kozina Anna"
date: "August 9, 2018"
output:
  html_document:
    keep_md: yes
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Introduction

It is now possible to collect a large amount of data about personal movement using activity monitoring devices such as a Fitbit, Nike Fuelband, or Jawbone Up. These type of devices are part of the "quantified self" movement - a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. But these data remain under-utilized both because the raw data are hard to obtain and there is a lack of statistical methods and software for processing and interpreting the data.

This assignment makes use of data from a personal activity monitoring device. This device collects data at 5 minute intervals through out the day. The data consists of two months of data from an anonymous individual collected during the months of October and November, 2012 and include the number of steps taken in 5 minute intervals each day.

Dataset "Activity monitoring data"]
<https://www.coursera.org/learn/reproducible-research/peer/gYyPt/course-project->

## Assignment
This assignment will be described in multiple parts. You will need to write a report that answers the questions detailed below. Ultimately, you will need to complete the entire assignment in a single R markdown document that can be processed by knitr and be transformed into an HTML file.
Throughout your report make sure you always include the code that you used to generate the output you present. When writing code chunks in the R markdown document, always use \color{red}{\verb|echo = TRUE|}echo=TRUE so that someone else will be able to read the code. This assignment will be evaluated via peer assessment so it is essential that your peer evaluators be able to review the code for your analysis.
Fork/clone the GitHub repository created for this assignment. You will submit this assignment by pushing your completed files into your forked repository on GitHub. The assignment submission will consist of the URL to your GitHub repository and the SHA-1 commit ID for your repository state.

## Main tasks and questions:

#### 1. Loading and preprocessing the data

#### 2. What is mean total number of steps taken per day?

#### 3. What is the average daily activity pattern?

#### 4. Imputing missing values?

#### 5. Are there differences in activity patterns between weekdays and weekends?

## 1. Loading and preprocessing the data

```{r, echo=TRUE, message=FALSE}
getwd()
destfile <- "C:/june_project"
setwd(destfile)
data <- read.csv(file="data.csv", head=TRUE, sep=",")
list.files()
summary(data)
```

## 2. What is mean total number of steps taken per day?

#### 2.1 histogram of number of steps taken per day 

```{r, echo=TRUE, message=FALSE}
StepsPerDay <- aggregate(data$steps, by=list(data$date), sum)
StepsPerDay <- setNames(StepsPerDay, c("date", "TotalSteps"))
StepsPerDay$date <- as.Date(StepsPerDay$date,format = "%m/%d/%Y")
str(StepsPerDay$date)
library(ggplot2)
library(scales)
ggplot(StepsPerDay, aes(TotalSteps)) +
  geom_histogram()+
  ggtitle("Total number of steps per day")+
  theme(plot.title = element_text(hjust = 0.5))
ggsave("TotalSteps.png")
```

#### 2.2 Mean and median number of steps taken each day 

```{r, echo=TRUE, message=FALSE}

summary(StepsPerDay$TotalSteps)
ggplot(StepsPerDay, aes(x=StepsPerDay$date, y=StepsPerDay$TotalSteps)) + geom_boxplot(alpha=0.4)+
  ggtitle("Median number of steps per day")+
  theme(plot.title = element_text(hjust = 0.5))
ggsave("Mean.png")
```

## 3. What is the average daily activity pattern?
#### Time series plot

`````{r, echo=TRUE, message=FALSE}
library(dplyr) 
StepsMean <- data  %>%  
  group_by(interval) %>% summarize(Mean = mean(steps, na.rm = TRUE))
as.factor(StepsMean$interval)
seq <- seq(from=as.POSIXct("2018-01-01 00:00:00, tz=UTC"), to=as.POSIXct("2018-01-01 24:00:00 , tz=UTC"), length.out=288)
time <-format(seq, format="%H-%M")
frame <-data.frame(StepsMean, time)

ggplot(frame, aes(x = frame$interval, y = frame$Mean))+geom_line()+
  ggtitle("Time series of the 5-minute interval")+
  theme(plot.title = element_text(hjust = 0.5))+
  xlab("Intervals")+
  ylab("Average number of steps")
ggsave("TimeSeries.png")
```

#### Maximum steps taken (time of the day)

`````{r, echo=TRUE, message=FALSE}
filter(frame, frame$Mean == max(frame$Mean))
```
## 4. Imputing missing values
####total number of missing values:

`````{r, echo=TRUE, message=FALSE}
summary(data)

```
#### The strategy to fill up the missing value would be a kNN method and the package for this purpose 
#### is VIM


```{r, echo=TRUE, message=FALSE}

if(!require(VIM)){
  install.packages("haven")
  library(haven)
}

if(!require(VIM)){
  install.packages("VIM")
  library(VIM)
}

data <- kNN(data, variable = "steps")
```

#### Histogram of number of steps taken per day 

```{r, echo=TRUE, message=FALSE}

StepsPerDay <- aggregate(data$steps, by=list(data$date), sum)
StepsPerDay <- setNames(StepsPerDay, c("date", "TotalSteps"))
StepsPerDay$date <- as.Date(StepsPerDay$date,format = "%m/%d/%Y")
str(StepsPerDay$date)
library(ggplot2)
library(scales)
ggplot(StepsPerDay, aes(TotalSteps)) +
  geom_histogram()+
  ggtitle("Total number of steps per day")+
  theme(plot.title = element_text(hjust = 0.5))+
  xlab("Steps")
ggsave("StepsPerDayKnn.png")
```
#### Mean and median number of steps taken each day 
```{r}
summary(StepsPerDay$TotalSteps)
```

## 5. Are there differences in activity patterns between weekdays and weekends?
```{r, echo=TRUE, message=FALSE}
data[,"weekday"]<-NA
str(data)
data$date <- as.Date(data$date, format = "%m/%d/%Y")
data$weekday <- weekdays(data$date, abbreviate = FALSE) 
data$weekday1 <- as.numeric(format(data$date, format = "%u"))
data$weekday <- as.factor(data$weekday)
str(data)

fun1 <- function(x){
  if (x>=6){
    y <- "Weekend"  
  } else {
    y <- "Weekday"    
  }
  return(y)
}
data$weekday3 <- as.factor(data$weekday3 <- sapply(data$weekday1, fun1))
str(data$weekday3) 
```

#### Time series plot
```{r, echo=TRUE, message=FALSE}
library(dplyr) 
weekday <- data %>%  
  group_by(weekday3, interval) %>% summarize(Mean = mean(steps, na.rm = TRUE))
str(weekday)

#temp <- tidyr::spread(weekday, weekday3, Mean)

ggplot(weekday, aes(x = weekday$interval, y = weekday$Mean, colour=weekday3))+ 
  geom_line()+
  facet_grid(weekday3~.)+
  ggtitle("Average daily steps by weekday/weekend")+
  theme(plot.title = element_text(hjust = 0.5))+
  xlab("Interval")+
  ylab("Average number of steps")
ggsave("WeekdayWeekend.png")
```




