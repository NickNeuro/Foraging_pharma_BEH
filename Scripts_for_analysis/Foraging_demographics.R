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
library("plotrix") # std.errr
library("tidyr")
library("MuMIn") # r.squarredGLM
library("sjPlot")
library("emmeans")
library("ggpubr")
library("corrplot")

####################
### Prepare data ###
####################

# Load drug attribution
df.drug = as.data.frame(read_excel("C:/Users/nsidor/Desktop/NEMO_data_analysis/Attribution_drugs.xlsx"))
df.main = as.data.frame(read_excel("C:/Users/nsidor/Desktop/NEMO_data_analysis/Main_session_Data.xlsx")); df.main$`Main ID` = as.numeric(df.main$`Main ID`)
df.scores = as.data.frame(read_excel("C:/Users/nsidor/Desktop/NEMO_data_analysis/Scores.xlsx")); df.scores$Subject = as.numeric(df.scores$Subject)
df.screening = as.data.frame(read_excel("C:/Users/nsidor/Desktop/NEMO_data_analysis/Screening_session_data.xlsx"))

for (s in unique(df.drug$Subject))
{
  temp = df.screening[df.screening$ID == df.main[df.main$`Main ID` == s, 'Screening ID'], 'Age']; df.drug[df.drug$Subject == s, 'age'] = temp[!is.na(temp)]
  temp = df.screening[df.screening$ID == df.main[df.main$`Main ID` == s, 'Screening ID'], 'Gender']; df.drug[df.drug$Subject == s, 'gender'] = temp[!is.na(temp)]
  temp = df.screening[df.screening$ID == df.main[df.main$`Main ID` == s, 'Screening ID'], 'BMI']; df.drug[df.drug$Subject == s, 'BMI'] = temp[!is.na(temp)]
  temp = df.screening[df.screening$ID == df.main[df.main$`Main ID` == s, 'Screening ID'], 'Education']; df.drug[df.drug$Subject == s, 'education'] = temp[!is.na(temp)]
  temp = as.character(df.main[df.main$`Main ID` == s, 'Screening ID']); temp = as.numeric(substr(temp, 2,5))
  df.drug[df.drug$Subject == s, 'ADHD'] = as.numeric(RESULTS[3,temp  + 2])
  df.drug[df.drug$Subject == s, 'STAI'] = as.numeric(RESULTS[8,temp  + 2])
}

df.drug = merge(df.drug, df.scores, by = "Subject")
df.drug$Treatment = as.factor(df.drug$Treatment)
df.drug$Treatment = relevel(df.drug$Treatment, 'Pla')

# Statistical analysis
summary(lm(age ~ Treatment, df.drug)) # no difference

count(df.drug, gender, Treatment) # unbalanced for Reboxetine

chisq.test(df.drug$gender, df.drug$Treatment, correct = FALSE) # no difference
chisq.test(df.drug[df.drug$Treatment %in% c('Pla', 'MPH'), 'gender'], df.drug[df.drug$Treatment %in% c('Pla', 'MPH'), 'Treatment'], correct = FALSE) # no difference
chisq.test(df.drug[df.drug$Treatment %in% c('Pla', 'Nic'), 'gender'], df.drug[df.drug$Treatment %in% c('Pla', 'Nic'), 'Treatment'], correct = FALSE) # no difference
chisq.test(df.drug[df.drug$Treatment %in% c('Pla', 'Rebox'), 'gender'], df.drug[df.drug$Treatment %in% c('Pla', 'Rebox'), 'Treatment'], correct = FALSE) # no difference

summary(lm(BMI ~ Treatment, df.drug)) # no difference

summary(lm(education ~ Treatment, df.drug)) # no difference

summary(lm(ADHD ~ Treatment, df.drug)) # no difference

summary(lm(STAI ~ Treatment, df.drug)) # no difference

# Mean
aggregate(age ~ Treatment, df.drug, FUN = mean) # no difference

aggregate(BMI ~ Treatment, df.drug, FUN = mean) # no difference

aggregate(education ~ Treatment, df.drug, FUN = mean) # no difference

aggregate(ADHD ~ Treatment, df.drug, FUN = mean) # no difference

aggregate(STAI ~ Treatment, df.drug, FUN = mean) # no difference

# SD
aggregate(age ~ Treatment, df.drug, FUN = sd) # no difference

aggregate(BMI ~ Treatment, df.drug, FUN = sd) # no difference

aggregate(education ~ Treatment, df.drug, FUN = sd) # no difference

aggregate(ADHD ~ Treatment, df.drug, FUN = sd) # no difference

aggregate(STAI ~ Treatment, df.drug, FUN = sd) # no difference

