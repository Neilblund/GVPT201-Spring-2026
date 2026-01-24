# A. Calculating the actual population mean and SD -----

## 1. Calculate the mean of c(1, 2, 3, 4, 5, 6)



## 2. Subtract this mean from each element and square the result



## 3. Sum the squared deviations and divide by the total number of observations


## 4. Take the square root of this value


#  B. Calculating the SD from one sample -----


## How close is our estimated standard deviation to the actual standard deviation?



# C. Examining the sampling distribution -----

library(googlesheets4)
# reading the sheet
sheet<-read_sheet('https://docs.google.com/spreadsheets/d/185A4Z1NON9VHEFS6C4ruh_DzzFHmcaiVbT1JQclH1sA/edit?usp=sharing')

# making one long vector from all the samples
die_rolls<-sheet[,2:ncol(sheet)]|>unlist()|>unname()

# What does the distribution of rolls look like? 



# How many rolls are within two standard deviations of the actual population mean?




#D. Simulating it on your own ----


# You can actually do this entirely within R:

# the sample function randomly samples from a vector: 
sample(1:6, replace=T, size=30)

# replicate runs a function N times, so this will give you 10 means from 
# rolling 30 six-sided die:

replicate(n=10, expr= mean(sample(1:6, replace=T, size=30)))


# now do it 1000 times and plot

simulated_rolls<-replicate(n=1000, expr= mean(sample(1:6, replace=T, size=30)))


hist(simulated_rolls)









