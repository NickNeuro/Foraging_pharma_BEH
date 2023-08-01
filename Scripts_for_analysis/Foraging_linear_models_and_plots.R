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
library("plotrix") # std.error
library("igraph") # for Bayesian model
library("brms") # for Bayesian model
library("MuMIn") # r.squarredGLM
library("sjPlot")
library("sjmisc")
library("emmeans")
library("broom.mixed")
library("jtools")
library("ggforce") # geom_link2
library("stargazer") # plot a table
library("ggpubr") # ggarrange
library("mblm") # non parametric regression
library("grid") # grobTree
library("MASS") # rlm
library("sfsmisc") # p-values for rlm
library("ggdist")
library("PupillometryR")
library("loo")

####################
### Prepare data ###
####################

# Add the plotting function
source('../Foraging_plotting_function.R')

###################################################################################################################
################################################# Residency times #################################################
###################################################################################################################

# Residency time in terms of current and average reward rates 
bayesian_model = brm(reaction_time_z ~ 1 + field * environment + age_z + gender + delay_s_z + (1|subject_ID) + (1|subject_ID:field) + (1|subject_ID:environment) + (1|subject_ID:environment:field), data = df.fr, warmup = 1000, iter = 3000, chains = 4, control = list(adapt_delta = 0.97), cores = 1, refresh = 1, silent = FALSE) 

summary(bayesian_model) # investigate convergence - all R_hat must be below 1.01
loo(bayesian_model) # investigate convergence - Pareto k values must be < 0.7
plot(bayesian_model) # investigate convergence - all distributions should have a Gaussian shape

emmeans(bayesian_model, pairwise ~ field)
emmeans(bayesian_model, trt.vs.ctrl ~ environment)

# Residency time in terms of current and average reward rates & drug group 
bayesian_model = brm(reaction_time_z ~ 1 + field * environment * drug + age_z + gender + delay_s_z + (1|subject_ID) + (1|subject_ID:field) + (1|subject_ID:environment) + (1|subject_ID:environment:field), data = df.fr, warmup = 1000, iter = 3000, chains = 4, control = list(adapt_delta = 0.97), cores = 1, refresh = 1, silent = FALSE) 

summary(bayesian_model)
loo(bayesian_model)
plot(bayesian_model)

emmeans(bayesian_model, trt.vs.ctrl ~ drug) # infer the drug effects compared to placebo
hypothesis(bayesian_model, "drugMPH = 0") # infer the drug effect and get the BF
hypothesis(bayesian_model, "drugNic = 0") # infer the drug effect and get the BF
hypothesis(bayesian_model, "drugRebox = 0") # infer the drug effect and get the BF

# Robustness against covariates
model_1 = brm(reaction_time_z ~ 1 + field * environment * drug + age_z + gender + delay_s_z + (1|subject_ID) + (1|subject_ID:field) + (1|subject_ID:environment) + (1|subject_ID:environment:field), data = df.fr, warmup = 1000, iter = 3000, chains = 4, control = list(adapt_delta = 0.97), cores = 1, refresh = 1, silent = FALSE) 
loo(model_1)

model_2 = brm(reaction_time_z ~ 1 + field * environment * drug + age_z + gender + delay_s_z + Weight_z + (1|subject_ID) + (1|subject_ID:field) + (1|subject_ID:environment) + (1|subject_ID:environment:field), data = df.fr, warmup = 1000, iter = 3000, chains = 4, control = list(adapt_delta = 0.97), cores = 1, refresh = 1, silent = FALSE) 
loo(model_2)

model_3 = brm(reaction_time_z ~ 1 + field * environment * drug + age_z + gender + delay_s_z + Height_z + (1|subject_ID) + (1|subject_ID:field) + (1|subject_ID:environment) + (1|subject_ID:environment:field), data = df.fr, warmup = 1000, iter = 3000, chains = 4, control = list(adapt_delta = 0.97), cores = 1, refresh = 1, silent = FALSE) 
loo(model_3)

model_4 = brm(reaction_time_z ~ 1 + field * environment * drug + age_z + gender + delay_s_z + BMI_z + (1|subject_ID) + (1|subject_ID:field) + (1|subject_ID:environment) + (1|subject_ID:environment:field), data = df.fr, warmup = 1000, iter = 3000, chains = 4, control = list(adapt_delta = 0.97), cores = 1, refresh = 1, silent = FALSE) 
loo(model_4)

model_5 = brm(reaction_time_z ~ 1 + field * environment * drug + age_z + gender + delay_s_z + education_z + (1|subject_ID) + (1|subject_ID:field) + (1|subject_ID:environment) + (1|subject_ID:environment:field), data = df.fr, warmup = 1000, iter = 3000, chains = 4, control = list(adapt_delta = 0.97), cores = 1, refresh = 1, silent = FALSE) 
loo(model_5)

model_6 = brm(reaction_time_z ~ 1 + field * environment * drug + age_z + gender + delay_s_z + first_z + (1|subject_ID) + (1|subject_ID:field) + (1|subject_ID:environment) + (1|subject_ID:environment:field), data = df.fr, warmup = 1000, iter = 3000, chains = 4, control = list(adapt_delta = 0.97), cores = 1, refresh = 1, silent = FALSE) 
loo(model_6)

model_7 = brm(reaction_time_z ~ 1 + field * environment * drug + age_z + gender + delay_s_z + second_z + (1|subject_ID) + (1|subject_ID:field) + (1|subject_ID:environment) + (1|subject_ID:environment:field), data = df.fr, warmup = 1000, iter = 3000, chains = 4, control = list(adapt_delta = 0.97), cores = 1, refresh = 1, silent = FALSE) 
loo(model_7)

################
### Plotting ###
################

# We initiate the variables needed for computation
S.low = 32.5; S.medium = 45; S.high = 57.5

g.low = c(); g.medium = c(); g.high = c();
timeline = seq(0, 120, 0.05)
for (time in timeline) { g.low = c(g.low, S.low*exp(-0.075*time)); g.medium = c(g.medium, S.medium*exp(-0.075*time)); g.high = c(g.high, S.high*exp(-0.075*time)) }

# We perform the computation 
background = readMat('C:/Users/nsidor/OneDrive - Universität Zürich UZH/Nicotine_enhances_foraging_optimality/Scripts/SNS_BEH_FR_set_S00001_1.mat')
background.high = background$richReward[,1]; background.medium = background$richReward[,2]; background.low = background$richReward[,4]

r_poor = c()
for (i in 1:2401) { r_poor = c(r_poor, (0.2*background.high[i] + 0.3*background.medium[i] + 0.5*background.low[i])/(6 + timeline[i])) }

r_rich = c()
for (i in 1:2401) { r_rich = c(r_rich, (0.5*background.high[i] + 0.3*background.medium[i] + 0.2*background.low[i])/(6 + timeline[i])) }

optimal.high.rich = timeline[which.min(abs(g.high - r_rich[which.max(r_rich)]))] 
optimal.medium.rich = timeline[which.min(abs(g.medium - r_rich[which.max(r_rich)]))] 
optimal.low.rich = timeline[which.min(abs(g.low - r_rich[which.max(r_rich)]))]
optimal.high.poor = timeline[which.min(abs(g.high - r_poor[which.max(r_poor)]))] 
optimal.medium.poor = timeline[which.min(abs(g.medium - r_poor[which.max(r_poor)]))] 
optimal.low.poor = timeline[which.min(abs(g.low - r_poor[which.max(r_poor)]))] 

# For displaying the optimal timing
optimal.data = data.frame(c(optimal.high.rich, optimal.medium.rich, optimal.low.rich, optimal.high.poor, optimal.medium.poor, optimal.low.poor),
                          c('high', 'medium', 'low', 'high', 'medium', 'low'),
                          c('rich', 'rich', 'rich', 'poor', 'poor', 'poor'))
colnames(optimal.data) = c('optimal_time', 'field', 'environment')
optimal.data$field = relevel(as.factor(optimal.data$field), 'medium'); optimal.data$field = relevel(as.factor(optimal.data$field), 'low'); 

# Figure 2A: General plot - all participants pooled together
se <- function(x) sd(x) / sqrt(length(x)) # or we can use std.error()
df.for_plotting = df.fr %>% group_by(field, environment, subject_ID) %>% summarise(reaction_time = mean(reaction_time))
df.for_plotting = df.for_plotting %>% group_by(field, environment) %>% summarise(mean = mean(reaction_time), sd = se(reaction_time))

df.for_plotting$field = relevel(as.factor(df.for_plotting$field), 'medium'); df.for_plotting$field = relevel(as.factor(df.for_plotting$field), 'low'); 
df.for_jitter = df.fr %>% group_by(field, environment, subject_ID) %>% summarise(mean = mean(reaction_time))
df.for_jitter$field = relevel(as.factor(df.for_jitter$field), 'medium'); df.for_jitter$field = relevel(as.factor(df.for_jitter$field), 'low'); 

plot_2A = plotting_function(df.for_plotting, df.for_jitter, optimal.data, TRUE, 'Patch', 'Residency time [s]', 0, 40) 
  
# Figure 3A: By drug group
se <- function(x) sd(x) / sqrt(length(x)) # or we can use std.error()
drugs = c('Pla', 'MPH', 'Nic', 'Rebox'); drugs_full = c('Placebo', 'Methylphenidate', 'Nicotine', 'Reboxetine'); drug_plots = list()

for (dd in 1:4)
{
  drug = drugs[dd]
  
  df.for_plotting = df.fr[df.fr$drug == drug,] %>% group_by(field, environment, subject_ID) %>% summarise(reaction_time = mean(reaction_time))
  df.for_plotting = df.for_plotting %>% group_by(field, environment) %>% summarise(mean = mean(reaction_time), sd = se(reaction_time))
  
  df.for_plotting$field = relevel(as.factor(df.for_plotting$field), 'medium'); df.for_plotting$field = relevel(as.factor(df.for_plotting$field), 'low'); 
  df.for_jitter = df.fr[df.fr$drug == drug,] %>% group_by(field, environment, subject_ID) %>% summarise(mean = mean(reaction_time))
  df.for_jitter$field = relevel(as.factor(df.for_jitter$field), 'medium'); df.for_jitter$field = relevel(as.factor(df.for_jitter$field), 'low'); 
  
  # grob = grobTree(textGrob(drugs_full[[dd]], x = 0.5,  y = 0.95, hjust = 0, gp = gpar(col = "black", fontsize = 18, fontface = "italic")))
  pd = position_jitterdodge(jitter.width = 0.2, dodge.width = 0.7)
  
  drug_plots[[dd]] = plotting_function(df.for_plotting, df.for_jitter, optimal.data, TRUE, 'Patch', 'Residency time [s]', 0, 40)   
  # annotation_custom(grob) +
  # if (dd == 1) { drug_plots[[dd]] = drug_plots[[dd]] + theme(plot.margin = margin(0, 0.3, 1, 0, "cm")) } # uncomment to see the labels
  if (dd == 1) { drug_plots[[dd]] = drug_plots[[dd]] + theme(plot.margin = margin(0, 0.3, 1, 0, "cm"), legend.position = 'none', axis.title.y = element_blank(), axis.text.y = element_blank()) } # comment to see the labels
  if (dd > 1) { drug_plots[[dd]] = drug_plots[[dd]] + theme(plot.margin = margin(0, 0.3, 1, 0, "cm"), legend.position = 'none', axis.title.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank()) }
}
ggarrange(drug_plots[[1]], drug_plots[[2]], drug_plots[[3]], drug_plots[[4]], ncol = 4, nrow = 1) + theme(plot.margin = margin(0, 0, 0, 0.5, "cm"))

####################################################################################################################### 
################################################# Current reward rate ################################################# 
####################################################################################################################### 

# Current reward rate upon leaving in terms of patch and environment types 
bayesian_model = brm(rew_rate_z ~ 1 + field * environment + age_z + gender + delay_s_z + (1|subject_ID) + (1|subject_ID:field) + (1|subject_ID:environment) + (1|subject_ID:environment:field), data = df.fr, warmup = 1000, iter = 3000, chains = 4, control = list(adapt_delta = 0.97), cores = 1, refresh = 1, silent = FALSE) 

summary(bayesian_model) # investigate convergence - all R_hat must be below 1.01
loo(bayesian_model) # investigate convergence - Pareto k values must be < 0.7
plot(bayesian_model) # investigate convergence - all distributions should have a Gaussian shape

emmeans(bayesian_model, pairwise ~ field)
emmeans(bayesian_model, pairwise ~ field | environment)
emmeans(bayesian_model, trt.vs.ctrl ~ environment)

# Current reward rate upon leaving in terms of patch and environment types & drug group 
bayesian_model = brm(rew_rate_z ~ 1 + field * environment * drug + age_z + gender + delay_s_z + (1|subject_ID) + (1|subject_ID:field) + (1|subject_ID:environment) + (1|subject_ID:environment:field), data = df.fr, warmup = 1000, iter = 3000, chains = 4, control = list(adapt_delta = 0.97), cores = 1, refresh = 1, silent = FALSE) 

summary(bayesian_model)
loo(bayesian_model)
plot(bayesian_model)

emmeans(bayesian_model, trt.vs.ctrl ~ drug) # infer the drug effects compared to placebo
hypothesis(bayesian_model, "drugMPH = 0") # infer the drug effect and get the BF
hypothesis(bayesian_model, "drugNic = 0") # infer the drug effect and get the BF
hypothesis(bayesian_model, "drugRebox = 0") # infer the drug effect and get the BF

# Robustness against covariates
model_1 = brm(rew_rate_z ~ 1 + field * environment + age_z + gender + delay_s_z + (1|subject_ID) + (1|subject_ID:field) + (1|subject_ID:environment) + (1|subject_ID:environment:field), data = df.fr, warmup = 1000, iter = 3000, chains = 4, control = list(adapt_delta = 0.97), cores = 1, refresh = 1, silent = FALSE) 
loo(model_1)

model_2 = brm(rew_rate_z ~ 1 + field * environment + age_z + gender + delay_s_z + Weight_z + (1|subject_ID) + (1|subject_ID:field) + (1|subject_ID:environment) + (1|subject_ID:environment:field), data = df.fr, warmup = 1000, iter = 3000, chains = 4, control = list(adapt_delta = 0.97), cores = 1, refresh = 1, silent = FALSE) 
loo(model_2)

model_3 = brm(rew_rate_z ~ 1 + field * environment + age_z + gender + delay_s_z + Height_z + (1|subject_ID) + (1|subject_ID:field) + (1|subject_ID:environment) + (1|subject_ID:environment:field), data = df.fr, warmup = 1000, iter = 3000, chains = 4, control = list(adapt_delta = 0.97), cores = 1, refresh = 1, silent = FALSE) 
loo(model_3)

model_4 = brm(rew_rate_z ~ 1 + field * environment + age_z + gender + delay_s_z + BMI_z + (1|subject_ID) + (1|subject_ID:field) + (1|subject_ID:environment) + (1|subject_ID:environment:field), data = df.fr, warmup = 1000, iter = 3000, chains = 4, control = list(adapt_delta = 0.97), cores = 1, refresh = 1, silent = FALSE) 
loo(model_4)

model_5 = brm(rew_rate_z ~ 1 + field * environment + age_z + gender + delay_s_z + education_z + (1|subject_ID) + (1|subject_ID:field) + (1|subject_ID:environment) + (1|subject_ID:environment:field), data = df.fr, warmup = 1000, iter = 3000, chains = 4, control = list(adapt_delta = 0.97), cores = 1, refresh = 1, silent = FALSE) 
loo(model_5)

model_6 = brm(rew_rate_z ~ 1 + field * environment + age_z + gender + delay_s_z + first_z + (1|subject_ID) + (1|subject_ID:field) + (1|subject_ID:environment) + (1|subject_ID:environment:field), data = df.fr, warmup = 1000, iter = 3000, chains = 4, control = list(adapt_delta = 0.97), cores = 1, refresh = 1, silent = FALSE) 
loo(model_6)

model_7 = brm(rew_rate_z ~ 1 + field * environment + age_z + gender + delay_s_z + second_z + (1|subject_ID) + (1|subject_ID:field) + (1|subject_ID:environment) + (1|subject_ID:environment:field), data = df.fr, warmup = 1000, iter = 3000, chains = 4, control = list(adapt_delta = 0.97), cores = 1, refresh = 1, silent = FALSE) 
loo(model_7)


################
### Plotting ###
################

background = readMat('C:/Users/nsidor/Desktop/SNS_BEH_FR_set_S00001_1.mat')
background.high = background$richReward[,1]; background.medium = background$richReward[,2]; background.low = background$richReward[,4]

r_poor = c()
for (i in 1:2401) { r_poor = c(r_poor, (0.2*background.high[i] + 0.3*background.medium[i] + 0.5*background.low[i])/(6 + timeline[i])) }

r_rich = c()
for (i in 1:2401) { r_rich = c(r_rich, (0.5*background.high[i] + 0.3*background.medium[i] + 0.2*background.low[i])/(6 + timeline[i])) }

optimal.data = data.frame(c(r_rich[which.max(r_rich)], r_rich[which.max(r_rich)], r_rich[which.max(r_rich)], r_poor[which.max(r_poor)], r_poor[which.max(r_poor)], r_poor[which.max(r_poor)]),
                          c('high', 'medium', 'low', 'high', 'medium', 'low'),
                          c('rich', 'rich', 'rich', 'poor', 'poor', 'poor'))
colnames(optimal.data) = c('optimal_time', 'field', 'environment')
optimal.data$field = relevel(as.factor(optimal.data$field), 'medium'); optimal.data$field = relevel(as.factor(optimal.data$field), 'low'); 

# Figure 2B: General plot - all participants pooled together
se <- function(x) sd(x) / sqrt(length(x)) # or we can use std.error()
df.for_plotting = df.fr %>% group_by(field, environment, subject_ID) %>% summarise(rew_rate = mean(rew_rate))
df.for_plotting = df.for_plotting %>% group_by(field, environment) %>% summarise(mean = mean(rew_rate), sd = se(rew_rate))

df.for_plotting$field = relevel(as.factor(df.for_plotting$field), 'medium'); df.for_plotting$field = relevel(as.factor(df.for_plotting$field), 'low'); 
df.for_jitter = df.fr %>% group_by(field, environment, subject_ID) %>% summarise(mean = mean(rew_rate))

plot_2B = plotting_function(df.for_plotting, df.for_jitter, optimal.data, TRUE, 'Patch', 'Reward rate upon leaving [milk drops/s]', 2, 35) 

# Figure 3B: By drug group
se <- function(x) sd(x) / sqrt(length(x)) # or we can use std.error()
drugs = c('Pla', 'MPH', 'Nic', 'Rebox'); drugs_full = c('Placebo', 'Methylphenidate', 'Nicotine', 'Reboxetine'); drug_plots = list()

for (dd in 1:4)
{
  drug = drugs[dd]
  df.for_plotting = df.fr[df.fr$drug == drug,] %>% group_by(field, environment, subject_ID) %>% summarise(rew_rate = mean(rew_rate))
  df.for_plotting = df.for_plotting %>% group_by(field, environment) %>% summarise(mean = mean(rew_rate), sd = se(rew_rate))
  
  df.for_plotting$field = relevel(as.factor(df.for_plotting$field), 'medium'); df.for_plotting$field = relevel(as.factor(df.for_plotting$field), 'low'); 
  df.for_jitter = df.fr[df.fr$drug == drug,] %>% group_by(field, environment, subject_ID) %>% summarise(mean = mean(rew_rate))
  
  grob = grobTree(textGrob(drugs_full[[dd]], x = 0.5,  y = 0.95, hjust = 0, gp = gpar(col = "black", fontsize = 18, fontface = "italic")))
  pd = position_jitterdodge(jitter.width = 0.2, dodge.width = 0.7)
  
  drug_plots[[dd]] = plotting_function(df.for_plotting, df.for_jitter, optimal.data, TRUE, 'Field', 'Reward rate upon leaving [milk drops/s]', 2, 35) 
  # annotation_custom(grob) +
  # if (dd == 1) { drug_plots[[dd]] = drug_plots[[dd]] + theme(plot.margin = margin(0, 0.3, 1, 0, "cm")) } # uncomment to see the labels
  if (dd == 1) { drug_plots[[dd]] = drug_plots[[dd]] + theme(plot.margin = margin(0, 0.3, 1, 0, "cm"), legend.position = 'none', axis.title.y = element_blank(), axis.text.y = element_blank()) } # comment to see the labels
  if (dd > 1) { drug_plots[[dd]] = drug_plots[[dd]] + theme(plot.margin = margin(0, 0.3, 1, 0, "cm"), legend.position = 'none', axis.title.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank()) }
}
ggarrange(drug_plots[[1]], drug_plots[[2]], drug_plots[[3]], drug_plots[[4]], ncol = 4, nrow = 1) + theme(plot.margin = margin(0, 0, 0, 0.5, "cm"))

################################################################################################################ 
################################################# Optimal time ################################################# 
################################################################################################################ 

bayesian_model = brm(abs_opt_s_z ~ 1 + field * environment * drug + age_z + gender + delay_s_z + (1|subject_ID) + (1|subject_ID:field) + (1|subject_ID:environment) + (1|subject_ID:field:environment), data = df.fr, warmup = 1000, iter  = 3000, chains = 4, control = list(adapt_delta = 0.97), cores = 1, refresh = 1) 

summary(bayesian_model) # investigate convergence - all R_hat must be below 1.01
loo(bayesian_model) # investigate convergence - Pareto k values must be < 0.7
plot(bayesian_model) # investigate convergence - all distributions should have a Gaussian shape

emmeans(bayesian_model, trt.vs.ctrl ~ drug) # infer the drug effects compared to placebo
hypothesis(bayesian_model, "drugMPH = 0") # infer the drug effect and get the BF
hypothesis(bayesian_model, "drugNic = 0") # infer the drug effect and get the BF
hypothesis(bayesian_model, "drugRebox = 0") # infer the drug effect and get the BF

# Robustness against covariates
model_1 = brm(abs_opt_s_z ~ 1 + field * environment * drug + age_z + gender + delay_s_z + (1|subject_ID) + (1|subject_ID:field) + (1|subject_ID:environment) + (1|subject_ID:environment:field), data = df.fr, warmup = 1000, iter = 3000, chains = 4, control = list(adapt_delta = 0.97), cores = 1, refresh = 1, silent = FALSE) 
loo(model_1)

model_2 = brm(abs_opt_s_z ~ 1 + field * environment * drug + age_z + gender + delay_s_z + Weight_z + (1|subject_ID) + (1|subject_ID:field) + (1|subject_ID:environment) + (1|subject_ID:environment:field), data = df.fr, warmup = 1000, iter = 3000, chains = 4, control = list(adapt_delta = 0.97), cores = 1, refresh = 1, silent = FALSE) 
loo(model_2)

model_3 = brm(abs_opt_s_z ~ 1 + field * environment * drug + age_z + gender + delay_s_z + Height_z + (1|subject_ID) + (1|subject_ID:field) + (1|subject_ID:environment) + (1|subject_ID:environment:field), data = df.fr, warmup = 1000, iter = 3000, chains = 4, control = list(adapt_delta = 0.97), cores = 1, refresh = 1, silent = FALSE) 
loo(model_3)

model_4 = brm(abs_opt_s_z ~ 1 + field * environment * drug + age_z + gender + delay_s_z + BMI_z + (1|subject_ID) + (1|subject_ID:field) + (1|subject_ID:environment) + (1|subject_ID:environment:field), data = df.fr, warmup = 1000, iter = 3000, chains = 4, control = list(adapt_delta = 0.97), cores = 1, refresh = 1, silent = FALSE) 
loo(model_4)

model_5 = brm(abs_opt_s_z ~ 1 + field * environment * drug + age_z + gender + delay_s_z + education_z + (1|subject_ID) + (1|subject_ID:field) + (1|subject_ID:environment) + (1|subject_ID:environment:field), data = df.fr, warmup = 1000, iter = 3000, chains = 4, control = list(adapt_delta = 0.97), cores = 1, refresh = 1, silent = FALSE) 
loo(model_5)

model_6 = brm(abs_opt_s_z ~ 1 + field * environment * drug + age_z + gender + delay_s_z + first_z + (1|subject_ID) + (1|subject_ID:field) + (1|subject_ID:environment) + (1|subject_ID:environment:field), data = df.fr, warmup = 1000, iter = 3000, chains = 4, control = list(adapt_delta = 0.97), cores = 1, refresh = 1, silent = FALSE) 
loo(model_6)

model_7 = brm(abs_opt_s_z ~ 1 + field * environment * drug + age_z + gender + delay_s_z + second_z + (1|subject_ID) + (1|subject_ID:field) + (1|subject_ID:environment) + (1|subject_ID:environment:field), data = df.fr, warmup = 1000, iter = 3000, chains = 4, control = list(adapt_delta = 0.97), cores = 1, refresh = 1, silent = FALSE) 
loo(model_7)

################
### Plotting ###
################

# Figure 2C: General plot - all participants pooled together
se <- function(x) sd(x) / sqrt(length(x)) # or we can use std.error()
df.for_plotting = df.fr %>% group_by(field, environment, subject_ID) %>% summarise(abs_opt = mean(abs_opt))
df.for_plotting = df.for_plotting %>% group_by(field, environment) %>% summarise(mean = mean(abs_opt), sd = se(abs_opt))

df.for_plotting$field = relevel(as.factor(df.for_plotting$field), 'medium'); df.for_plotting$field = relevel(as.factor(df.for_plotting$field), 'low'); 
df.for_jitter = df.fr %>% group_by(field, environment, subject_ID) %>% summarise(mean = mean(abs_opt))
df.for_jitter$field = relevel(as.factor(df.for_jitter$field), 'medium'); df.for_jitter$field = relevel(as.factor(df.for_jitter$field), 'low'); 

plot_2C = plotting_function(df.for_plotting, df.for_jitter, optimal.data, FALSE, 'Patch', 'Absolute deviation from optimality [s]', 0, 20) 

# Figure 3C: By drug group
se <- function(x) sd(x) / sqrt(length(x)) # or we can use std.error()
drugs = c('Pla', 'MPH', 'Nic', 'Rebox'); drugs_full = c('Placebo', 'Methylphenidate', 'Nicotine', 'Reboxetine'); drug_plots = list()

for (dd in 1:4)
{
  drug = drugs[dd]
  df.for_plotting = df.fr[df.fr$drug == drug,] %>% group_by(field, environment, subject_ID) %>% summarise(abs_opt = mean(abs_opt))
  df.for_plotting = df.for_plotting %>% group_by(field, environment) %>% summarise(mean = mean(abs_opt), sd = se(abs_opt))
  
  df.for_plotting$field = relevel(as.factor(df.for_plotting$field), 'medium'); df.for_plotting$field = relevel(as.factor(df.for_plotting$field), 'low'); 
  df.for_jitter = df.fr[df.fr$drug == drug,] %>% group_by(field, environment, subject_ID) %>% summarise(mean = mean(abs_opt))
  df.for_jitter$field = relevel(as.factor(df.for_jitter$field), 'medium'); df.for_jitter$field = relevel(as.factor(df.for_jitter$field), 'low'); 
  
  grob = grobTree(textGrob(drugs_full[[dd]], x = 0.5,  y = 0.95, hjust = 0, gp = gpar(col = "black", fontsize = 18, fontface = "italic")))
  pd = position_jitterdodge(jitter.width = 0.2, dodge.width = 0.7)
  
  drug_plots[[dd]] = plotting_function(df.for_plotting, df.for_jitter, optimal.data, FALSE, 'Patch', 'Absolute deviation from optimality [s]', 0, 20) 
  # annotation_custom(grob) +
  # if (dd == 1) { drug_plots[[dd]] = drug_plots[[dd]] + theme(plot.margin = margin(0, 0.3, 1, 0, "cm")) } # uncomment to see the labels
  if (dd == 1) { drug_plots[[dd]] = drug_plots[[dd]] + theme(plot.margin = margin(0, 0.3, 1, 0, "cm"), legend.position = 'none', axis.title.y = element_blank(), axis.text.y = element_blank()) } # comment to see the labels
  if (dd > 1) { drug_plots[[dd]] = drug_plots[[dd]] + theme(plot.margin = margin(0, 0.3, 1, 0, "cm"), legend.position = 'none', axis.title.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank()) }
}
ggarrange(drug_plots[[1]], drug_plots[[2]], drug_plots[[3]], drug_plots[[4]], ncol = 4, nrow = 1) + theme(plot.margin = margin(0, 0, 0, 0.5, "cm"))

# Figure 2D: Performance as function of deviation from optimality
df.for_plotting = df.fr %>% group_by(subject_ID) %>% summarise(performance_sum = sum(collected_reward)/1000, performance_mean = mean(collected_reward), opt = mean(opt), abs_opt = mean(abs_opt))

plot_2D = ggplot(df.for_plotting, aes(x = log(abs_opt), y = (performance_sum))) + 
          geom_point(col = '#016F91', fill = '#016F91', shape = 21, stroke = 1.1, size = 5, alpha = 0.3) +
          geom_smooth(method=lm,formula = y ~ x + I(x^2), color="#016F91", fill="#016F91", size = 1.5, alpha = 0.5) + 
               theme(legend.position = "top") + theme_bw() + 
               theme(axis.text.x = element_text(color = "grey20", size = 20, hjust = .5, vjust = .5, face = "plain"),
                     axis.text.y = element_text(color = "grey20", size = 20, hjust = .5, vjust = .5, face = "plain"),  
                     axis.title.x = element_text(color = "grey20", size = 20, hjust = .5, vjust = -3, face = "plain"),
                     axis.title.y = element_text(color = "grey20", size = 20,  hjust = .5, vjust = 3, face = "plain"),
                     legend.text = element_text(color = "grey20", size = 20,  hjust = .5, vjust = .5, face = "plain"),
                     legend.title = element_text(color = "grey20", size = 20,  hjust = .5, vjust = .5, face = "plain")) +
               labs(x = 'Absolute deviation from optimal time [s]', y = expression(paste('Collected reward [milk drops *', 10^4, ']', sep = ''))) + 
               theme(plot.margin = margin(0.5, 1, 0.5, 0.5, "cm"))

#############
### Delay ###  
#############

df.for_delay = df.fr %>% group_by(subject_ID, drug, gender) %>% summarise(delay = mean(delay), age = mean(age), performance = sum(collected_reward), opt = mean(opt), abs_opt = mean(abs_opt),
                                                                          Weight = mean(Weight), Height = mean(Height), BMI = mean(BMI), education = mean(education), first = mean(first), second = mean(second))
df.for_delay$delay_s_z = zscore(sqrt(df.for_delay$delay))
df.for_delay$age_z = zscore(df.for_delay$age)
df.for_delay$performance_z = zscore(df.for_delay$performance)

bayesian_model = brm(delay_s_z ~ drug + age_z + gender, df.for_delay, warmup = 1000, iter = 3000, chains = 4, control = list(adapt_delta = 0.97), cores = 1, refresh = 1, silent = FALSE)

summary(bayesian_model) # investigate convergence - all R_hat must be below 1.01
loo(bayesian_model) # investigate convergence - Pareto k values must be < 0.7
plot(bayesian_model) # investigate convergence - all distributions should have a Gaussian shape

emmeans(bayesian_model, trt.vs.ctrl ~ drug) # infer the drug effects compared to placebo
hypothesis(bayesian_model, "drugMPH = 0") # infer the drug effect and get the BF
hypothesis(bayesian_model, "drugNic = 0") # infer the drug effect and get the BF
hypothesis(bayesian_model, "drugRebox = 0") # infer the drug effect and get the BF

# Robustness against covariates
model_1 = brm(delay_s_z ~ drug + age_z + gender, data = df.for_delay, warmup = 1000, iter = 3000, chains = 4, control = list(adapt_delta = 0.97), cores = 1, refresh = 1, silent = FALSE) 
loo(model_1)

model_2 = brm(delay_s_z ~ drug + age_z + gender + Weight_z, data = df.for_delay, warmup = 1000, iter = 3000, chains = 4, control = list(adapt_delta = 0.97), cores = 1, refresh = 1, silent = FALSE) 
loo(model_2)

model_3 = brm(delay_s_z ~ drug + age_z + gender + Height_z, data = df.for_delay, warmup = 1000, iter = 3000, chains = 4, control = list(adapt_delta = 0.97), cores = 1, refresh = 1, silent = FALSE) 
loo(model_3)

model_4 = brm(delay_s_z ~ drug + age_z + gender + BMI_z, data = df.for_delay, warmup = 1000, iter = 3000, chains = 4, control = list(adapt_delta = 0.97), cores = 1, refresh = 1, silent = FALSE) 
loo(model_4)

model_5 = brm(delay_s_z ~ drug + age_z + gender + education_z, data = df.for_delay, warmup = 1000, iter = 3000, chains = 4, control = list(adapt_delta = 0.97), cores = 1, refresh = 1, silent = FALSE) 
loo(model_5)

model_6 = brm(delay_s_z ~ drug + age_z + gender + first_z, data = df.for_delay, warmup = 1000, iter = 3000, chains = 4, control = list(adapt_delta = 0.97), cores = 1, refresh = 1, silent = FALSE) 
loo(model_6)

model_7 = brm(delay_s_z ~ drug + age_z + gender + second_z, data = df.for_delay, warmup = 1000, iter = 3000, chains = 4, control = list(adapt_delta = 0.97), cores = 1, refresh = 1, silent = FALSE) 
loo(model_7)

# Figure 3D 
pd = position_jitterdodge(jitter.width = 0.5, dodge.width = 0.1)
ggplot(df.for_delay, aes(x = drug, y = delay, color = drug)) + 
  geom_boxplot(outlier.shape = NA, size = 1, width = 0.3) + 
  geom_point(aes(group = drug, fill = drug, color = drug), size = 3, shape = 21, stroke = 1.5, position = pd, alpha = 0.2) +
  scale_color_manual(values = c("#016F91","#016F91", "#016F91", "#016F91")) +
  scale_fill_manual(values = c("#016F91","#016F91", "#016F91", "#016F91")) +
  theme_bw() + 
  theme(legend.position = 'none', legend.background = element_rect(fill = "transparent"),
        axis.text.x = element_text(color = "grey20", size = 20, hjust = 1, vjust = 1, face = "plain", angle = 45),
        axis.text.y = element_text(color = "grey20", size = 20, hjust = .5, vjust = .5, face = "plain"),  
        axis.title.x = element_text(color = "grey20", size = 20, hjust = .5, vjust = -3, face = "plain"),
        axis.title.y = element_text(color = "grey20", size = 20,  hjust = .5, vjust = 3, face = "plain"),
        legend.text = element_text(color = "grey20", size = 20,  hjust = .5, vjust = .5, face = "plain"),
        legend.title = element_text(color = "grey20", size = 20,  hjust = .5, vjust = .5, face = "plain")) +
  labs(x = 'Drug', y = 'Initiation time [s]') + ylim(0, 2.6) +
  scale_x_discrete(labels = c('Placebo', 'MPH', 'Nicotine', 'Reboxetine')) +
  theme(plot.margin = margin(1, 1, 1, 1, "cm")) + 
  geom_flat_violin(df.for_delay, mapping = aes(x = drug, y = delay, fill = drug), trim = FALSE, width = 0.5, scale = 'width', adjust = 1.5, alpha = 0.3, position = position_nudge(x = 0.25, y = 0)) + 
  geom_signif(comparisons = list(c("Pla", "Nic")), annotations = "*", y_position = 2.3, tip_length = 0.01, color = 'black', textsize = 8) 

# Figure 3E
cor.test(delay_s_z ~ performance, df.for_delay[!(df.for_delay$subject_ID %in% c(14)), ], method = 'spearman'); # we ran it as a non-parametric correlation because of the distribution   
summary(lm(delay_s_z ~ performance_z, df.for_delay[!(df.for_delay$subject_ID %in% c(14)), ])) # here we confirm the result of the correlation (but Pearson not Spearman)
# Note: we remove the participant #14 because she could not fully finish her rich environment due to a technical error. If we include this participant, it will make the correlation even higher  

ggplot(df.for_delay[!(df.for_delay$subject_ID %in% c(14)), ], aes(x = delay, y = performance)) + 
       geom_point(col = '#016F91', fill = '#016F91', shape = 21, stroke = 1.1, size = 6, alpha = 0.3) +
       geom_smooth(method=lm, color="#016F91", fill="#016F91", size = 3, alpha = 0.5) + 
       theme(legend.position = "top") + theme_bw() + 
       theme(axis.text.x = element_text(color = "grey20", size = 20, hjust = .5, vjust = .5, face = "plain"),
             axis.text.y = element_text(color = "grey20", size = 20, hjust = .5, vjust = .5, face = "plain"),  
             axis.title.x = element_text(color = "grey20", size = 20, hjust = .5, vjust = -3, face = "plain"),
             axis.title.y = element_text(color = "grey20", size = 20,  hjust = .5, vjust = 3, face = "plain"),
             legend.text = element_text(color = "grey20", size = 20,  hjust = .5, vjust = .5, face = "plain"),
             legend.title = element_text(color = "grey20", size = 20,  hjust = .5, vjust = .5, face = "plain")) +
       labs(x = 'Initiation time [s]', y = expression(paste('Collected reward [milk drops *', 10^4, ']', sep = ''))) + 
       theme(plot.margin = margin(1, 1, 1, 1, "cm"))

