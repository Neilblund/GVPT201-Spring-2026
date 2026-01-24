# Pilot Analysis Script 
# Press Ctrl + Shift + O to open a table of contents for this script
# 
#_______________________________________________________________________________

#0. Import data ----
# Use code in this section to import the data into Rstudio
rm(list=ls())
library(RCPA3)
# this string is just a link to a web page that holds the data: 
loc <- url('https://github.com/Neilblund/GVPT-201-Site/raw/refs/heads/main/Rdata/pilot_fmted.rds')

# readRDS() reads the data from the URL into R and assign it to an object called
# "pilot"

pilot<-readRDS(loc)


# You can view a codebook with descriptive statistics by running this code: 
descriptives<-Hmisc::describe(pilot)
Hmisc::html(descriptives)

#1. TikTok ban -----

# how many respondents said they supported the effort to ban or force the sale of
# TikTok?
# To answer this, we can just use a basic frequency table:
freqC(Q8, data=pilot)

## Making an ordered factor----

# Q8 is already arranged from Strongly Opposed to Strongly Support, but its
# currently not being treated as an ordinal variable, which will mean functions
# like freqC will not give us a cumulative percentage. To fix this, we can use
# the ordered(x) function to create a new ordered version of this variable:

pilot$tiktok_ordered <- ordered(pilot$Q8)

freqC(tiktok_ordered, data=pilot)

# now describeC provides the median and modal value as well: 
describeC(tiktok_ordered, data=pilot)

## Adding a variable label ----

# We can assign a new label to this variable with Hmisc::label(x)
# print the current label: 
Hmisc::label(pilot$tiktok_ordered) 

# Assign a new label: 
Hmisc::label(pilot$tiktok_ordered)  <- "Support/Oppose banning or forcing the sale of TikTok"

# the main advantage is that it the label is automatically printed when we make
# tables like this:
freqC(tiktok_ordered, data=pilot)

#2. Social Media views ----

# How many people view social media use as having a negative effect on politics? 
# We'll also recode this to an  ordered factor
pilot$sm_views <- ordered(pilot$Q52)
Hmisc::label(pilot$sm_views) <-" View on social media's impact on American politics"


freqC(sm_views, data=pilot)



#3. TikTok ban and social media views ----
# Do people support the TikTok ban because of concerns about social media's
# impact on society? We'll make both variables dichotomous to simplify our
# analysis and avoid the problem of small frequencies:


## Recoding the variables as dichotomous ----#
# Set up a vector of new labels with the same length and ordering as the original 
# labels, then pass that vector to the "labels = " argument of the factor() func

neg_pos <- c("Negative", "Negative", 
             "Not negative","Not negative", "Not negative")
pilot$sm_negative <- factor(pilot$Q52, 
                            ordered =TRUE,
                            labels = neg_pos)

opp_sup <- c("Opposed","Opposed", "Opposed",
             "Not opposed", "Not opposed", "Not opposed", "Not opposed")

pilot$tiktok_ban <- factor(pilot$Q8, 
                           ordered = TRUE,
                           labels = opp_sup
)

## After recoding, we can check our results to make sure everything lines up:
table(pilot$tiktok_ban)
table(pilot$Q8)

# OR try unique(dataframe[,c("oldvar", "newvar")]):
unique(pilot[,c("tiktok_ban", "Q8")])

## getting a crosstab ---
# Is there a relationship here? 
crosstabC(dv = tiktok_ban,   
          iv = sm_negative, 
          data=pilot, 
          compact =TRUE  # turns off printing the frequencies 
          
          )

# (remember to read across the values of the IV to calculate an effect)

## Controlling for social media usage----
# Is there a relationship here? perhaps the reason for the observed relationship
# Maybe people who don't use social media are both more likely to think it is
# harmful and more likely to support banning it?

# We can use answer to Q50 to explore this. We'll collapse this to dichotomous
# as well:

pilot$daily_sm <- factor(pilot$Q50 == "Daily", 
                         ordered =TRUE,
                         labels = c("Less than every day", "Every day")
)


# 

crosstabC(dv = tiktok_ban, 
          iv = sm_negative, 
          z  = daily_sm,
          data=pilot,
          plot = FALSE,
          compact =TRUE
          
)



#4. Cutting a variable ----
# We can use transformC to cut a numeric variable into a smaller number of responses
# For instance, here's how we would change the 0-100 feeling thermometer score for 
# supporting expanding the Supreme Court and make it into a ordinal measure:

pilot$expand_scotus<-transformC(type='cut',               # use this option to cut a number into groups
                                data=pilot,             # the data set 
                                x=Q34_5,                # the variable we're cutting
                                cut = c(20,40,60,80),   # the cutoff points
                                confirm=F)              # this turns off a prompt that asks us to confirm before executing the command

# then we can add descriptive labels to each level of this new ordered variable:
levels(pilot$expand_scotus) <- c("Strongly Disagree", "Disagree", "Neutral", "Agree", "Strongly Agree")

# get the frequency distribution
freqC(pilot$expand_scotus)


#5. Making a dummy based on multiple responses ----
# what if I wanted to create a dummy to represent respondents who
# voted in 2024 and intended to vote in 2028? 

# I can use a set of logical statements separated by an ampersand:
# The code below returns TRUE if and only if Q14 AND Q18 both have values of "Yes":
pilot$vote24_28_dummy <- as.numeric(pilot$Q14 == "Yes" & pilot$Q18 == "Yes")

freqC(pilot$vote24_28_dummy)

# Another example: what if I wanted to get all of the respondents who were not
# white OR hispanic. I could use the logical | operator here, which means
# "return TRUE if either of these logical statements are true."

pilot$non_white_or_hispanic <- as.numeric(pilot$Q2 != "White or Caucasian" | pilot$Q3 =="Yes")

freqC(pilot$non_white_or_hispanic)


#6. Extra Code##################################################################
# You don't need this for this assignment! But it might be handy later on.

## Making an additive index ----
# Feeling thermometer variables are already numeric, so you can easily convert
# these to and additive index by simply adding them together (or averaging):

# make a vector containing the names of the columns you want to use:
spend_questions<-c("Q36_1", "Q36_2", "Q36_3", "Q36_4", "Q36_5", "Q36_6", "Q36_7")

# using subsetting to see the first 10 rows of the spending question response:
pilot[1:10,spend_questions]

total_spend <-  rowMeans(pilot[,spend_questions], na.rm=T)

# view a histogram: 
hist(total_spend, 
     xlab='Average spending thermometer',  # change axis label
     main='') # remove title

# You can also mean-center each variable and divide by its standard deviation. 
# This would allow you to combine numeric variables even if they have different
# scalings:
total_spend_scaled <-rowMeans(scale(pilot[,spend_questions]), na.rm=T)


hist(total_spend_scaled, 
     xlab ='Average spending thermometer (Scaled)', # change axis label
     main = '' # remove title
     )

# You can also create additive indices from ordered factors if you convert them
# to numeric variables first (and make sure they all have the same "direction")

trust_questions<-data.frame(
  'trust_fed' = as.numeric(pilot$Q49_1), 
  'trust_relig' = as.numeric(pilot$Q49_2), 
  'trust_media' = as.numeric(pilot$Q49_3), 
  'trust_pol' = as.numeric(pilot$Q49_4), 
  'trust_fam' = as.numeric(pilot$Q49_5)
  )

trust_total <- rowSums(trust_questions)

hist(trust_total, 
     xlab='Additive index of social trust', 
     main=''
     )

# Note that the additive index has a more normal distribution than an individual 
# question. We would also expect it to have higher reliability if the scale is 
# a good one.


## Using a regular expression----
# What if I want to create a dummy variable that includes anyone who listed "Asian" 
# as their race/ethnic identity, including people who identify as multiracial? 
# One quick and easy way to do this grepl. grepl will search for a string of text
# and return TRUE for all values that match that string.

# So this command will return TRUE for any responses that include the text "Asian", including
# respondents who picked "Asian" + some other race: 
pilot$asian_dummy <- grepl("Asian", pilot$Q2)

# Take a look at the results and compare to the original responses on Q2:

table(pilot$Q2, pilot$asian_dummy)


