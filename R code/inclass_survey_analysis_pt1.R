# don't worry about this section! Just importing the data
dataurl<-'https://github.com/Neilblund/GVPT201-Spring-2026/raw/refs/heads/master/Data/inclass_responses.rds'
responses<-readRDS(url(dataurl)) # reading the results into R


# Part 1####################################################################

library(RCPA3) # importing the workbook R package

## View() ----
# View data using the View() function, or just click the data set in 
# the environment window
View(responses) # Will bring up the data viewer. 

## Accessing columns ----
# Use the $ notation to access a specific column from a data set. For instance,
# I could access the "age" column from the "responses" data set by running:
responses$age

## mean() ----
mean(responses$age) # This will calculate the average of a specific column

## help()----
# the help(x) will bring up the documentation for a function. Here's how I would
# bring up the help file for the mean function:
help(mean)


## mean() with optional arguments ---- According to the documentation, mean()
#has an optional argument that I can use to ignore NA values when calculating
#the mean. The syntax is: mean(x, na.rm=TRUE)

mean(responses$age, na.rm=T)

## describeC---------------------------------------------------------------------
# describeC is a RCPA3 function that will generate descriptive statistics. The 
# stats generated will be different depending on the type of variable you're working
# with. 

#So interval variables will produce stuff like mean, median, standard deviation etc.

describeC(responses$mood)

# While categorical variables will only report things like the number of missing
# and unique values and the mode:
describeC(responses$astrology)


## freqC() ----
# This is a function from the RCPA3 package that will generate a table with percents
# and a barplot automatically for a categorical variable:

freqC(responses$body_odor)

# An alternative way to write this function that avoids the $ notation:
freqC(x=astrology, data=responses)
