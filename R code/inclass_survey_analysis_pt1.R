# don't worry about this section! Just importing the data
dataurl<-'https://github.com/Neilblund/GVPT201-Spring-2026/raw/refs/heads/master/Data/inclass_responses.rds'
responses<-readRDS(url(dataurl)) # reading the results into R


# Part 1####################################################################

library(RCPA3) # importing the workbook R package

## View() ----
# View data using the View() function, or just click the data set in 
# the environment window
# View(responses) # Will bring up the data viewer. 

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


## mean() with optional arguments ---- 

# According to the documentation, mean()
# has an optional argument that I can use to ignore NA values when calculating
# the mean. The syntax is: mean(x, na.rm=TRUE)

mean(responses$age, na.rm=T)

## describeC()------------------------------------------------------------------
# describeC is a RCPA3 function that will generate descriptive statistics. The 
# stats generated will be different depending on the type of variable you're working
# with. 
# Interval variables will produce stuff like mean, median, standard deviation etc.

describeC(responses$mood)

# I can do the same function without the $ notation like this:
describeC( x=mood, data = responses)

# While categorical variables will only report things like the number of missing
# and unique values and the mode:
describeC(responses$astrology)

# as the note indicates, I can specify that this is a ordinal variable with 
# as.ordered(). Doing this will give me some additional descriptive stats:
describeC(as.ordered(responses$astrology))

# I can also list multiple variables here. 
describeC(list(mood,age, num_siblings,  as.ordered(astrology)), data=responses)


## histC() ---------------------------------------------------------------------
# histC will prouce histograms and descriptive stats for a continuous variable.

# for instance, here's the distribution of moods among students in Spring 2026:
histC(responses$mood)

# or ages (note the skew)
histC(responses$age)


# We can make some additional aesthetic changes to these plots as well:
histC(responses$mood,
      main = "Overall Mood", # change the title
      xlab = "Mood",         # change the x-axis label
      bar.col ='blue'        # change the bar color
)


## freqC() ---------------------------------------------------------------------
# This is a function from the RCPA3 package that will generate a table with percents
# and a barplot automatically for a categorical variable:

freqC(responses$body_odor)

# An alternative way to write this function that avoids the $ notation:
freqC(x=astrology, data=responses)


# long row labels can cause problems for displaying results
freqC(x=best_song2026, data =responses)

### labeling rows ----
# I can use the rowlabs argument to give new names to each bar. 
# Make sure your new row names are in quotes and follow the same order as the
# original table!
freqC(x=best_song2026, 
      rowlabs = c("DtMF",
                  "Wildflower",
                  "Anxiety",
                  "Golden",
                  "Luther",
                  "Abracadabra",
                  "APT",
                  "Manchild"),
      data =responses)

### Frequency plot of bad_publicity responses ----
# compare to yougov poll with similar wording but slightly different response options:
# https://today.yougov.com/topics/society/survey-results/daily/2023/07/11/4c5da/3
freqC(x=bad_publicity, data=responses) 

