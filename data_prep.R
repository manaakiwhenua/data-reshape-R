library(tidyverse)
library(data.table)

DATA_DIR <- "CSV files"

#Read in all files
data_filenames <- list.files(path=DATA_DIR, pattern = "*.cvs")


data1 <- read.csv(file = "CSV files/V3.1-1.csv", skip = 8, header = TRUE, stringsAsFactors = FALSE)
data1 <- data1 %>% select(Name, Peak.Height)
data1 <- data.table::transpose(data1)
colnames(data1) <- data1[1,]
data1<- data1[-1, ]

data2 <- read.csv(file = "CSV files/V3.1-2.csv", skip = 8, header = TRUE, stringsAsFactors = FALSE)
data2 <- data2 %>% select(Name, Peak.Height)
data2 <- data.table::transpose(data2)
colnames(data2) <- data2[1,]
data2 <- data2[-1, ]


#Joining
final_data <- list(data1, data2) %>% reduce(full_join)


