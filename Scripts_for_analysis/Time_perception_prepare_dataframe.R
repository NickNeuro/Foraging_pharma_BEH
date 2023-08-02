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
library("data.table") # fwrite

# Upload .xlsx files
df.time = as.data.frame(read_excel('../Time_perception_dataframe.xlsx'))
df.time$environment = as.factor(df.time$environment); df.time$environment = relevel(df.time$environment, 'constant')
df.time$session_type = as.factor(df.time$session_type); df.time$session_type = relevel(df.time$session_type, 'scrn')
df.time$subject_ID = as.factor(df.time$subject_ID)
df.time$drug = as.factor(df.time$drug)
df.time$drug = relevel(df.time$drug, "Pla")

# Check the data frame
which(!(1:160 %in% unique(df.time$subject_ID))) # 60 (Rebox, data from screening session (10154) are missing) / 71 (MPH, design from screening session (10061) is missing)

smallRT = row.names(df.time[df.time$reaction_time < 1, ]) # keep those for whom it was a strategy
df.time[as.numeric(smallRT), c(1, 2, 3, 4, 5, 6, 7)]
# Subject 75 (Pla) - more than 50% of missed trials in both sessions
# Subject 77 (Pla) - all trials missed in the main session
# Subject 84 (MPH) - all trials missed in the screening session
# Subject 90 (MPH) - half of trials missed in the main session

df.time = df.time[!(df.time$subject_ID %in% c(75, 77, 84, 90)), ]
row.names(df.time) = 1:nrow(df.time)

# Eliminate trials with a small RT
smallRT = row.names(df.time[df.time$reaction_time < 1 &
                              df.time$timing_to_leave > 2, ]) # we keep those who had to indicate the time within 2 seconds
df.time = df.time[-as.numeric(smallRT), ]
row.names(df.time) = 1:nrow(df.time)

df.time$reaction_time_z = zscore(df.time$reaction_time) # we z-score the variables to have comparable effect sizes between various continuous dependent variables. Note: using raw values does not impact significance of the results    
df.time$age_z = zscore(df.time$age)
df.time$timing_to_leave_z = zscore(df.time$timing_to_leave)
df.time$difference_z = zscore(df.time$difference)
df.time$delay_s_z = zscore(sqrt(df.time$delay)) # reminder: delay is how we call initiation times in our scripts (for shortness)
df.time$BMI_z = zscore(df.time$BMI) 
