library("readxl") # Read .xlsx files
library("lme4") # Regression linear model
library("lmerTest") # Regression linear model
library("plyr") # Count function
library("effects") # Graphs for linear models
library("multcomp")
library("mosaic") # zscores
library("ggplot2") # Graphs 
library("Hmisc") # Describe function
library("R.matlab")
library("memisc")

# Upload .xlsx files
df.fr = as.data.frame(read_excel('../Foraging_dataframe.xlsx'))
df.fr$environment = as.factor(df.fr$environment)
df.fr$field = as.factor(df.fr$field)
df.fr$field = relevel(df.fr$field, "high") # highest point
df.fr$environment = relevel(df.fr$environment, "poor") # highest point
df.fr$subject_ID = as.factor(df.fr$subject_ID)
df.fr$drug = as.factor(df.fr$drug)
df.fr$drug = relevel(df.fr$drug, "Pla")

# Eliminate trials with a small RT
smallRT = row.names(df.fr[df.fr$reaction_time < 1,]) # we remove those who had too small reaction times to make sure that we do not consider a mistake in finger movement
df.fr[as.numeric(smallRT),] # we make sure that this was not a strategy for anyone (someone who would have such short times at least in 50% of their non-high yield trials)
df.fr = df.fr[-as.numeric(smallRT),]
row.names(df.fr) = 1:nrow(df.fr)

df.fr$reaction_time_z = zscore(df.fr$reaction_time) # we z-score the variables to have comparable effect sizes between various continuous dependent variables. Note: using raw values does not impact significance of the results    
df.fr$rew_rate_z = zscore(df.fr$rew_rate) # we z-score the variables to have comparable effect sizes between various continuous dependent variables. Note: using raw values does not impact significance of the results    
df.fr$age_z = zscore(df.fr$age)
df.fr$abs_opt_s_z = zscore(sqrt(df.fr$abs_opt))
df.fr$opt_z = zscore(df.fr$opt)
df.fr$delay_s_z = zscore(sqrt(df.fr$delay)) # reminder: delay is how we call initiation times in our scripts (for shortness)
df.fr$Weight_z = zscore(df.fr$Weight) 
df.fr$Height_z = zscore(df.fr$Height) 
df.fr$BMI_z = zscore(df.fr$BMI) 
df.fr$education_z = zscore(df.fr$education) 
df.fr$first_z = zscore(df.fr$first) # reminder: first and second are the times when the first and second substances were administered
df.fr$second_z = zscore(df.fr$second) 
