library(tidyverse)
library(data.table)


DATA_DIR <- "CSV files"

file_list <- list.files(path=DATA_DIR, pattern = "*.csv", full.names =TRUE)
data_list <- vector("list", "length" = length(file_list))
final_data <-data_frame()


for (i in seq_along(file_list)) {
  filename = file_list[[i]]
  
  # Read data in
  data1 <- read.csv(file = filename, skip = 8, header = TRUE, stringsAsFactors = FALSE)
  # Select name of the compound and desired value (Peak Height)
  data1 <- data1 %>% select(Name, Peak.Height)
  # Transpose: columns become rows
  data1 <- data.table::transpose(data1)
  # Set column names to be names of the compounds
  colnames(data1) <- data1[1,]
  data1<- data1[-1, ]
  #Set the row name to correspond to the sample ID
  rownames(data1)<- colnames(read.csv(file = filename, stringsAsFactors = FALSE, sep = '\t' ))
  # Add year to data_list
  data_list[[i]] <- data1
  final_data <- merge(final_data, data1, all=TRUE) 
}




