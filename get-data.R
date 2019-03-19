### Download and unzip dataset
setwd("~/Documents/R Projects/Coursera/reproducible research/Project1")
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# Unzip dataSet to /data directory
unzip(zipfile="./data/Dataset.zip",exdir="./data")
### End download and unzip

# read data into dataframe
a_data <-  read.csv("./data/activity.csv", header=TRUE)

activity_data <- na.omit(a_data)