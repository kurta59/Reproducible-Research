---
title: "Activity Monitoring"
author: "Kurt C Anderson"
date: "March 19, 2019"
output: 
  html_document:
    keep_md: true
---



This report makes use of data from a personal activity monitoring device. The devices collect data at 5 minute intervals throughout the day. The data consists of two months collected from anonymous individuals, during the months of October and November, 2012. 
Each observation includes the number of steps taken in 5 minute intervals each day.

## 1. Loading and preprocessing the data
### Download and unzip dataset

```r
## setwd("~/Documents/R Projects/Coursera/reproducible research/Project1")
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# Unzip dataSet to /data directory
unzip(zipfile="./data/Dataset.zip",exdir="./data")
```

#### Read data
#### The count of rows is below

```r
a_data <-  read.csv("./data/activity.csv", header=TRUE)
dim(a_data)
```

```
## [1] 17568     3
```

## 2.  What is mean total number of steps taken per day?
### Summary statistics including Mean and Median

```r
summary(a_data$steps)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##    0.00    0.00    0.00   37.38   12.00  806.00    2304
```

### Sums steps per date

```r
stepsByDay <- aggregate(steps~date, a_data, sum)
```


#### Histogram of the total steps taken each day

```r
hist(stepsByDay$steps, main="Histogram for Steps Taken", xlab="Steps", col="blue")
```

![](figures/unnamed-chunk-5-1.png)<!-- -->

#### Calculate the mean and median total number of steps taken per day

```r
mean(stepsByDay$steps, na.rm=TRUE)
```

```
## [1] 10766.19
```

```r
median(stepsByDay$steps, na.rm=TRUE)
```

```
## [1] 10765
```

## 3. Average daily activity pattern?
#### Sum Steps and Plot steps taken by intervals

```r
stepsSumInt <- aggregate(steps~interval, a_data, FUN=sum)
plot(stepsSumInt$interval, stepsSumInt$steps, type="l", xlab="Interval", ylab="Sum of Steps")
```

![](figures/unnamed-chunk-7-1.png)<!-- -->

#### The interval with max steps

```r
stepsSumInt[which.max(stepsSumInt$steps), 1]
```

```
## [1] 835
```

## 4. Imputing missing values
#### The count of rows with NA is TRUE value

```r
table(is.na(a_data))
```

```
## 
## FALSE  TRUE 
## 50400  2304
```

#### A strategy of filling in missing values

```r
# Use mean of each interval
stepsMean <- aggregate(steps~interval, a_data, FUN=mean)
a_data_new <- merge(x=a_data, y=stepsMean, by="interval")
a_data_new$steps <- ifelse(is.na(a_data_new$steps.x), a_data_new$steps.y, a_data_new$steps.x)
a_data_complete <- select(a_data_new, steps, date, interval)
```

#### New dataset is complete with no NA

```r
table(is.na(a_data_complete))
```

```
## 
## FALSE 
## 52704
```

#### Histogram comparing raw data with NA and Histogram with imputed values for NA

```r
stepsByDayNew <- aggregate(steps~date, a_data_new, sum)

par(mfrow=c(1,2))
hist(stepsByDayNew$steps, main="Steps Taken per Day \n Raw Data Including NA", xlab="Steps", col="green", ylim=c(0,40))
hist(stepsByDay$steps, main="Steps Taken per Day \nImputed NA Values", xlab="Steps", col="blue", ylim=c(0,40))
```

![](figures/unnamed-chunk-12-1.png)<!-- -->

## 5. Are there differences in activity patterns between weekdays and weekends?
#### Create a new factor variable in the dataset with two levels -- "weekday" and "weekend" 

```r
#add new factor named day
a_data_complete$day <- ifelse(is.weekend(a_data_complete$date), "weekend", "weekday")
stepsByInt <- aggregate(steps~interval + day, a_data_complete, mean)
```

#### Make a panel plotwith time series type="l"

```r
xyplot(stepsByInt$steps~stepsByInt$interval|stepsByInt$day, type="l", layout=c(1,2), main="Steps by Interval", xlab="Interval", ylab="Steps")
```

![](figures/unnamed-chunk-14-1.png)<!-- -->
