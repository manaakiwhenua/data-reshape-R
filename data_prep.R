library(tidyverse)
library(data.table)

#Set up the correct path to data files
DATA_DIR <- "CSV files"

file_list <- list.files(path=DATA_DIR, pattern = "*.csv", full.names =TRUE)
final_data <- data_frame()

#A function which takes as a parameter the desired compound variable to be extracted and 
get_compound_values <- function(compound_variable){
  for (i in seq_along(file_list)) {
    filename = file_list[[i]]
    
    # Read data in from a sample file
    data1 <- read.csv(file = filename, skip = 8, header = TRUE, stringsAsFactors = FALSE)
    # Filter out name of the compound and desired value (compound_variable)
    data1 <- data1 %>% select(Name, compound_variable)
    # Transpose: columns become rows 
    data1 <- data.table::transpose(data1)
    # Set column names to be names of the compounds (this is a little bit of tidy up)
    colnames(data1) <- data1[1,]
    data1<- data1[-1, ]
    
    # A rather ugly way of getting the sample (file) id -- needs cleaning up
    sampleN <-  read.table(file = filename,header = F,nrows = 1)
    rownames(data1) <- paste(sampleN[2],sampleN[3])
    
    #Merge (append) compound values as the loop reads and processes each sample file
    if (nrow(final_data) == 0){
      final_data <- cbind(rownames=rownames(data1), data1 )
    }else{
      final_data <- merge(x= final_data,  y=cbind(rownames=rownames(data1), data1 ), all=TRUE) 
    }
  }
  # Write out the result into a csv file
  colnames(final_data)[1] <- "sample_ID" 
  write_csv(final_data, file=paste("results_",compound_variable,".csv", sep="") )
}

# Run the function with desired compound variables
get_compound_values("Peak.Height")
get_compound_values("Peak.Area")




