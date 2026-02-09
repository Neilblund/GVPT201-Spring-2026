# Importing combined data from 2025/2026 survey
dataurl<-'https://github.com/Neilblund/GVPT201-Spring-2026/raw/refs/heads/master/Data/inclass_responses_combined.rds'
all_responses<-readRDS(url(dataurl)) # reading the results into R


library(RCPA3)
# We can use boxplotC to get the distribution of a continuous variable across levels of a category:
# Are Spring 2026 students generally in a better mood than Spring 2025?
boxplotC(dv=mood, iv= semester, 
         data=all_responses)

# crosstabC will give us a cross tabulation of a category by another category.
# Here's a comparison of views on which song should have won in 2025 by semester:
crosstabC(dv = best_song2025, iv = semester, data=all_responses)


crosstabC(dv = best_song2025, 
          iv = semester,
          data=all_responses,
          plot.response='all',
          z.palette = 'pastel1'
          )


# More students in 2026 felt there was no
# such thing as bad publicity!
crosstabC(dv = bad_publicity, iv = semester, data=all_responses,
          plot ='mosaic',
          z.palette = 'pastel1'
          )

# More willing to tell a friend they have BO
crosstabC(dv =body_odor, iv = semester, data=all_responses,
          plot ='mosaic',
          z.palette = 'spectral'
)




# When you're finished -----

# Be sure you save scripts when you're finished! In most cases, this is a better
# way to keep track of results than saving the data itself because its more transparent
# and easier to re-use and share (you're also required to submit scripts with your
# homework, so this is just a good idea in general)


# Extra Stuff ------


## Customizing with lattice
# We can use the lattice package to make a nicer looking comparison bar chart
### Step 1. ----

# using table to get a table of song picks by semester
songtable<-table(all_responses$best_song2025, all_responses$semester)
# using prop table to get the proportion of picks for each semester
songtable<-prop.table(songtable, 2)  * 100
# putting the results in a data frame
songdata<-data.frame(songtable)
# re-ordering the song listings from most to least frequent
songdata$Var1<-reorder(songdata$Var1, songdata$Freq)

### Step 2. ----
# increase the left margin around the bar plot so we can fit the full 
# name of each song:
par(mai=c(1,4,1,1))

### Step 3 ---- 
# create a horizontal bar plot from the data using lattice
library(lattice)

barchart( Var1 ~ Freq, group=Var2, data=songdata ,
          auto.key=T
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

song_percent <- all_responses|>                         
  count(best_song2025, semester)|>     # count the number of each response 
  drop_na()|>                          # drop NA responses
  group_by(semester)|>
  mutate(percent = n/sum(n) *100,      # calculate a percent
         best_song2025 = reorder(best_song2025, n) # reorder by the frequency
  )

song_percent                               # Just looking at the result

### Step 2. ----
# Now use ggplot to generate the barplot. GGplot objects are built in separate layers
# and you add layers by using a "+". The first layer provides the data, and the
# geom_.. layers control how the data is presented (as a bar vs. a density plot 
# vs. scatter plot etc.)

ggplot(song_percent, 
       aes(x=best_song2025, y=percent, fill=semester)) +   #specify the x values and the y values
  geom_bar(stat='identity', position='dodge') +                           # make bars
  coord_flip()+                                         # make it horizontal
  labs(x="Song",                                        # add axis labels and a title
       y="percent",
       title='Picks for best song in 2024'
  ) +
  theme_minimal()+
  scale_fill_manual(values=c("#56B4E9", "#E69F00"))
# use a different color scale


