################################################################################
# don't worry about this section! Just importing the data and doing some formatting!
source('https://raw.githubusercontent.com/Neilblund/GVPT-201-Site/refs/heads/main/R%20code/gsheet_import.R')

responses<-readRDS("responses.rds") # reading in a saved copy of the results


################################################################################

# Stuff below here is more relevant -----
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


## mean() with optional arguments ----
# According to the documentation, mean() has an optional argument that I can use
# to ignore NA values when calculating the mean. The syntax is: mean(x, na.rm=TRUE)

mean(responses$age, na.rm=T)


# Part 2 ---------------------------------

## hist() and histC() ----
## These functions will generate histograms. hist() is the basic function:
hist(responses$age)

## histC() will print a frequency table and do some additional automatic 
# formatting, but its otherwise the same:
histC(responses$age)



# note that we can also use the data = argument for this function, which lets 
# us avoid using the $ notation. 
histC(x=age, data=responses)




## boxplot() ----
# will return a boxplot for one or more variables
boxplot(responses$mood)



# We can also use the ~ symbol to create separate boxplots for different groups.
# for instance, here's how we could compare the happiness levels of pet owners
# vs. non pet owners
boxplot(mood ~ pets, 
        data=responses)


## table() ----
# table is a simple command for getting the frequencies of a categorical variable

table(responses$body_odor)

## freqC() ----
# This is a function from the RCPA3 package that will generate a table with percents
# and a barplot automatically for a categorical variable:

freqC(responses$body_odor)

# This function also takes an optional data = argument, so we can avoid using the
# $ notation if we want to.
freqC(x=body_odor, data=responses)


# Bad publicity
# compare to yougov poll with similar wording but slightly different response options:
# https://today.yougov.com/topics/society/survey-results/daily/2023/07/11/4c5da/3
freqC(x=bad_publicity, data=responses) 


# Number of siblings

freqC(x=num_siblings, data=responses)

# Views on astrology

freqC(x=astrology, data=responses,
      main = "Astrology views"  # changing the title
) 

# best song: 
# The song titles here are a little bit too long, and so they run off the page
# when we use them here. 
# The "rowlabs" argument allows us to specify alternate labels for each bar. 
# To make this work, you want to make a vector: c(...) and put the new names
# in quotation marks. The order MUST match the order of the original bar plot, 
# so the best way to ensure this is to run the freqC function normally first, and
# then write the new row labels in the same order 

freqC(x=best_song, data=responses,
      rowlabs = c("Texas Hold 'Em", 
                  "Birds Of A Feather",
                  "Good Luck, Babe!",
                  "Not Like Us",
                  "Die With a Smile",
                  "Please Please Please",
                  "A Bar Song (Tipsy)",
                  "Fortnight"
                  )
      
      )


# body odor

freqC(x=body_odor, data=responses,
      xlab='Response'
      )


# describeC---------------------------------------------------------------------
# describeC is a RCPA3 function that will generate descriptive statistics. The 
# stats generated will be different depending on the type of variable you're working
# with. 

#So interval variables will produce stuff like mean, median, standard deviation etc.

describeC(responses$mood)

# While categorical variables will only report things like the number of missing
# and unique values and the mode:
describeC(responses$astrology)


# When you're finished -----

# Be sure you save scripts when you're finished! In most cases, this is a better
# way to keep track of results than saving the data itself because its more transparent
# and easier to re-use and share (you're also required to submit scripts with your
# homework, so this is just a good idea in general)


# Extra Stuff ------


## Customizing a bar plot ----
# R's built-in bar plot function allows you to do a little more customization
# compared to freqC. For instance, I want to make a horizontal bar plot to
# display the responses to the "best song" question, and I want to sort the bars
# according to the most frequent responses. Here's how I can do this:

### Step 1. ----
# get a frequency table, calculate the proportions with prop.table(),
# then convert to a percentage by multiplying by 100, and then sort from lowest
# to highest

best_song_table <- sort(prop.table(table(responses$best_song))) * 100



### Step 2. ----
# increase the left margin around the bar plot so we can fit the full 
# name of each song:
par(mai=c(1,4,1,1))

### Step 3 ---- 
# create a horizontal bar plot from the data
barplot(
  best_song_table,
  las=2,                                            # makes the text horizontal
  horiz=TRUE,                                       # makes the bars horizontal
  col='lightblue',                                  # makes the bars light blue
  main = "Picks for 2024 song of the year",         # add a title
  xlab='percent'                                    # add an x-axis label
)


## Using tidyverse packages----
# The tidyverse is a set of R packages for data analysis with a shared grammar.
# There's a bit of a learning curve for picking them up, but they can be much 
# easier to use for more complicated operations compared to base R. An in-depth
# intro is outside the scope of this class, but you can find lots of good introductions
# online. 
# Here's a good starting place for learning ggplot: 
# https://ggplot2.tidyverse.org/articles/ggplot2.html
# And heres' a good general intro to using the tidyverse:
# https://r4ds.hadley.nz/




### Step 1. ----

# As usual, you would want to install the tidyverse first by running:
# install.packages("tidyverse")

# then load it by running:
library(tidyverse)


### Step 2. ----
# Use dplyr functions to calculate the proportion of respondents with each song

# Note the |> operator just pipes the result of the previous command to the next
# function. 

song_percent <- responses|>
  drop_na()|>                              # drop NA responses
  count(best_song)|>                       # count the number of each response
  mutate(percent = n/sum(n) *100,          # calculate a percent
         best_song = reorder(best_song, n) # reorder by the frequency
         )

song_percent                               # Just looking at the result

### Step 2. ----
# Now use ggplot to generate the barplot. GGplot objects are built in separate layers
# and you add layers by using a "+". The first layer provides the data, and the
# geom_.. layers control how the data is presented (as a bar vs. a density plot 
# vs. scatter plot etc.)

ggplot(song_percent, 
       aes(x=best_song, y=percent, fill=best_song)) +   #specify the x values and the y values
  geom_bar(stat='identity') +                           # make bars
  coord_flip()+                                         # make it horizontal
  labs(x="Song",                                        # add axis labels and a title
       y="percent",
       title='Picks for best song in 2024'
       ) +
  theme_minimal() +                                     # use the minimalist theme
  scale_fill_viridis_d(option = "plasma", guide='none') # use a different color scale
  








