# Importing combined data from the survey we took in class earlier in the semester:
dataurl<-'https://github.com/Neilblund/GVPT201-Spring-2026/raw/refs/heads/master/Data/inclass_responses_combined.rds'
all_responses<-readRDS(url(dataurl)) # reading the results into R


library(RCPA3)

# is there are relationship between mood and pets, after controlling for semester?
# The DV here is (approximately) an interval-level variable, so we use
# compmeansC:

compmeansC(dv = mood,          # DV
           iv = pets,          # IV: Do you have pets?
           z = semester,       # Control: semester
           data=all_responses, 
           plot='line')        # line plot (instead of default bar)

# Does having a big family make you more willing to tell someone they have B.O.,
# controlling for age?
# The DV here is categorical, so we use crosstabC. IV and control are originally
# interval-level, but they've been collapsed into dichotomous variables for this 
# example:

crosstabC(dv =body_odor, 
          iv = siblings_cat,     # IV: 
          z = agecat,            # control: age in 2 categories
          data=all_responses,
          plot = 'line',        # show a line plot
          plot.response = "Yes" # plot the "Yes" responses (we have to pick one)
          )



