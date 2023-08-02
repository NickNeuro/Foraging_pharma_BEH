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
library("brms") # for Bayesian model
library("MuMIn") # r.squarredGLM
library("sjPlot")
library("emmeans")
library("tidyr")
library("corrplot")
library("BayesFactor")
library("loo")
library("PupillometryR")
library("ggsignif")

####################
### Prepare data ###
####################

# Sanity check
df_for_plotting = data.frame(c(df.time[df.time$session_type == 'scrn', 'timing_to_leave'], df.time[df.time$session_type == 'scrn', 'reaction_time']), c(rep('Goal', nrow(df.time[df.time$session_type == 'scrn',])), rep('RT', nrow(df.time[df.time$session_type == 'scrn',]))))
colnames(df_for_plotting) = c('Time', 'Condition')
ggplot(df_for_plotting, aes(Time, fill = Condition)) + geom_density(alpha = 0.2) + scale_fill_manual(values = c("darkcyan","darkseagreen4")) + theme_bw() + theme(axis.text.x = element_text(color = "grey20", size = 20, hjust = .5, vjust = .5, face = "plain"), axis.text.y = element_text(color = "grey20", size = 20, hjust = 1, vjust = 0, face = "plain"), axis.title.x = element_text(color = "grey20", size = 20, hjust = .5, vjust = 0, face = "plain"), axis.title.y = element_text(color = "grey20", size = 20,  hjust = .5, vjust = .5, face = "plain"), legend.text = element_text(color = "grey20", size = 20,  hjust = .5, vjust = .5, face = "plain"), legend.title = element_text(color = "grey20", size = 20,  hjust = .5, vjust = .5, face = "plain"))

df_for_plotting = data.frame(c(df.time[df.time$session_type == 'main', 'timing_to_leave'], df.time[df.time$session_type == 'main', 'reaction_time']), c(rep('Goal', nrow(df.time[df.time$session_type == 'main',])), rep('RT', nrow(df.time[df.time$session_type == 'main',]))))
colnames(df_for_plotting) = c('Time', 'Condition')
ggplot(df_for_plotting, aes(Time, fill = Condition)) + geom_density(alpha = 0.2) + scale_fill_manual(values = c("darkcyan","darkseagreen4")) + theme_bw() + theme(axis.text.x = element_text(color = "grey20", size = 20, hjust = .5, vjust = .5, face = "plain"), axis.text.y = element_text(color = "grey20", size = 20, hjust = 1, vjust = 0, face = "plain"), axis.title.x = element_text(color = "grey20", size = 20, hjust = .5, vjust = 0, face = "plain"), axis.title.y = element_text(color = "grey20", size = 20,  hjust = .5, vjust = .5, face = "plain"), legend.text = element_text(color = "grey20", size = 20,  hjust = .5, vjust = .5, face = "plain"), legend.title = element_text(color = "grey20", size = 20,  hjust = .5, vjust = .5, face = "plain"))

max(df.time[df.time$session_type == 'scrn', 'reaction_time'])
max(df.time[df.time$session_type == 'main', 'reaction_time'])

####################################
### Correlation between sessions ###
####################################
df.time_one_per_subject = aggregate(x = c((df.time$difference)), by = list(df.time$session_type, df.time$drug, df.time$subject_ID), FUN = mean); colnames(df.time_one_per_subject) = c('session_type', 'drug', 'subject_ID', 'difference')
df.time_one_per_subject = spread(df.time_one_per_subject, key = session_type, value = difference)

mean(df.time_one_per_subject$scrn)
mean(df.time_one_per_subject$main)

ggplot(df.time_one_per_subject, aes(x = scrn, y = main)) + 
  geom_point(col = '#712F2F', shape = 16, stroke = 1.1, size = 6, stroke = 1.1, alpha = 0.5) +
  geom_smooth(method=lm,formula = y ~ x, color="#712F2F", fill="#712F2F", size = 3, alpha = 0.5) + 
  theme(legend.position = "top") + theme_bw() + 
  theme(axis.text.x = element_text(color = "grey20", size = 20, hjust = .5, vjust = .5, face = "plain"),
        axis.text.y = element_text(color = "grey20", size = 20, hjust = .5, vjust = .5, face = "plain"),  
        axis.title.x = element_text(color = "grey20", size = 20, hjust = .5, vjust = -3, face = "plain"),
        axis.title.y = element_text(color = "grey20", size = 20,  hjust = .5, vjust = 3, face = "plain"),
        legend.text = element_text(color = "grey20", size = 20,  hjust = .5, vjust = .5, face = "plain"),
        legend.title = element_text(color = "grey20", size = 20,  hjust = .5, vjust = .5, face = "plain")) +
  labs(x = 'Difference in Screening session [s]', y = expression(paste('Difference in Main session [s]', sep = ''))) + 
  theme(plot.margin = margin(1, 1, 1, 1, "cm"))

cor.test(scrn ~ main, df.time_one_per_subject)
cor.test(scrn ~ main, df.time_one_per_subject[df.time_one_per_subject$drug == 'Pla',]) # highest correlation => not surprising because we'll see later that there was no change in this group
cor.test(scrn ~ main, df.time_one_per_subject[df.time_one_per_subject$drug == 'MPH',]) # smallest correlation of all => indeed, we'll see later that they've got an improvement
cor.test(scrn ~ main, df.time_one_per_subject[df.time_one_per_subject$drug == 'Nic',]) # second smallest of all => indeed, we'll see later that they've got an improvement
cor.test(scrn ~ main, df.time_one_per_subject[df.time_one_per_subject$drug == 'Rebox',]) # highest correlation between drug groups but still less than under placebo 

########################################
### Correlation with the target time ###
########################################

ggplot(df.time, aes(x = timing_to_leave, y = reaction_time, group = session_type, color = session_type)) + 
  geom_point(aes(col = session_type), shape = 16, stroke = 1.1, size = 6, stroke = 1.1, alpha = 0.2) +
  geom_smooth(method=lm,formula = y ~ x, aes(color=session_type), size = 3, alpha = 0.5) + 
  theme(legend.position = "top") + theme_bw() + 
  theme(axis.text.x = element_text(color = "grey20", size = 20, hjust = .5, vjust = .5, face = "plain"),
        axis.text.y = element_text(color = "grey20", size = 20, hjust = .5, vjust = .5, face = "plain"),  
        axis.title.x = element_text(color = "grey20", size = 20, hjust = .5, vjust = -3, face = "plain"),
        axis.title.y = element_text(color = "grey20", size = 20,  hjust = .5, vjust = 3, face = "plain"),
        legend.text = element_text(color = "grey20", size = 20,  hjust = .5, vjust = .5, face = "plain"),
        legend.title = element_text(color = "grey20", size = 20,  hjust = .5, vjust = .5, face = "plain")) +
  labs(color = 'Drug condition', x = 'Target time [s]', y = 'Estimated time [s]') + 
  theme(plot.margin = margin(1, 1, 1, 1, "cm")) + 
  scale_color_manual(labels = c('OFF', 'ON'), values = c('#009999', '#954C28')) 
  
cor.test(timing_to_leave ~ reaction_time, df.time[df.time$session_type == 'scrn',])
cor.test(timing_to_leave ~ reaction_time, df.time[df.time$session_type == 'scrn' & df.time$drug == 'Pla',]) # 0.71
cor.test(timing_to_leave ~ reaction_time, df.time[df.time$session_type == 'scrn' & df.time$drug == 'MPH',]) # also 0.71 like the placebo group => expected as it is an OFF-drug session
cor.test(timing_to_leave ~ reaction_time, df.time[df.time$session_type == 'scrn' & df.time$drug == 'Nic',]) # again 0.71 like the placebo group => expected as it is an OFF-drug session 
cor.test(timing_to_leave ~ reaction_time, df.time[df.time$session_type == 'scrn' & df.time$drug == 'Rebox',]) # interestingly, this time we have only 0.68

cor.test(timing_to_leave ~ reaction_time, df.time[df.time$session_type == 'main',])
cor.test(timing_to_leave ~ reaction_time, df.time[df.time$session_type == 'main' & df.time$drug == 'Pla',]) # 0.75
cor.test(timing_to_leave ~ reaction_time, df.time[df.time$session_type == 'main' & df.time$drug == 'MPH',]) # 0.77 => higher than placebo
cor.test(timing_to_leave ~ reaction_time, df.time[df.time$session_type == 'main' & df.time$drug == 'Nic',]) # 0.76 => higher than placebo 
cor.test(timing_to_leave ~ reaction_time, df.time[df.time$session_type == 'main' & df.time$drug == 'Rebox',]) # 0.71 => interestingly, still worse than placebo

#######################################
### Drug effect in the main session ###
#######################################

# Main analysis
bayesian_model = brm(difference_z ~ environment * session_type * drug + age_z + gender + delay_s_z + (1|subject_ID) + (1|subject_ID:session_type) + (1|subject_ID:environment) + (1|subject_ID:session_type:environment), data = df.time, warmup = 1000, iter = 3000, chains = 4, control = list(adapt_delta = 0.97), cores = 1, refresh = 1, silent = FALSE); 

summary(bayesian_model) # investigate convergence
loo(bayesian_model) # investigate convergence
plot(bayesian_model) # investigate convergence

emmeans(bayesian_model, trt.vs.ctrl ~ drug | session_type) # between-session drug effects
emmeans(bayesian_model, list(pairwise ~ session_type | drug)) # within-subject drug effects   

# Robustness against time covariate -> the previous result is robust
bayesian_model = brm(difference_z ~ timing_to_leave_z + environment * session_type * drug + age_z + gender + delay_s_z + (1|subject_ID) + (1|subject_ID:session_type) + (1|subject_ID:environment) + (1|subject_ID:session_type:environment), data = df.time, warmup = 1000, iter = 3000, chains = 4, control = list(adapt_delta = 0.97), cores = 1, refresh = 1, silent = FALSE); 

summary(bayesian_model) # investigate convergence
loo(bayesian_model) # investigate convergence
plot(bayesian_model) # investigate convergence

emmeans(bayesian_model, trt.vs.ctrl ~ drug | session_type) # between-session drug effects
emmeans(bayesian_model, list(pairwise ~ session_type | drug)) # within-subject drug effects   

# Figure 4A
df.time_one_per_subject = aggregate(x = c((df.time$difference)), by = list(df.time$session_type, df.time$drug, df.time$subject_ID), FUN = mean); colnames(df.time_one_per_subject) = c('session_type', 'drug', 'subject_ID', 'difference')

pd = position_jitterdodge(jitter.width = 0.1, dodge.width = 0.2)
ggplot(df.time_one_per_subject, aes(x = interaction(session_type, drug), y = difference, color = interaction(session_type, drug))) + 
  geom_boxplot(outlier.shape = NA, size = 1, width = 0.3) + 
  geom_point(aes(group = subject_ID, fill = session_type, color = interaction(session_type, drug)), size = 3, shape = 21, stroke = 1.5, position = pd, alpha = 0.2) +
  geom_line(aes(group = subject_ID, color = 'red'), position = pd) +
  scale_color_manual(values = c("#016F91","#016F91", "#016F91", "#016F91", 
                                "gray68",
                                "cornsilk4","cornsilk4", "cornsilk4", "cornsilk4")) +
  scale_fill_manual(values = c("cornsilk4","#016F91")) +
  theme_bw() + 
  theme(legend.position = 'none', legend.background = element_rect(fill = "transparent"),
        axis.text.x = element_text(color = "grey20", size = 20, hjust = 1, vjust = 1, face = "plain", angle = 45),
        axis.text.y = element_text(color = "grey20", size = 20, hjust = .5, vjust = .5, face = "plain"),  
        axis.title.x = element_text(color = "grey20", size = 20, hjust = .5, vjust = -3, face = "plain"),
        axis.title.y = element_text(color = "grey20", size = 20,  hjust = .5, vjust = 3, face = "plain"),
        legend.text = element_text(color = "grey20", size = 20,  hjust = .5, vjust = .5, face = "plain"),
        legend.title = element_text(color = "grey20", size = 20,  hjust = .5, vjust = .5, face = "plain")) +
  labs(x = 'Drug x Session', y = 'Difference from target time [s]') + ylim(-9, 8) +
  scale_x_discrete(breaks = c("main.Pla", "main.MPH", "main.Nic", "main.Rebox"), labels = c('Placebo', 'MPH', 'Nicotine', 'Reboxetine')) +
  theme(plot.margin = margin(1, 1, 1, 1, "cm")) + 
  geom_flat_violin(df.time_one_per_subject, mapping = aes(fill = session_type, color = interaction(session_type, drug)), width = 0.5, trim = FALSE, scale = 'width', adjust = 1.5, alpha = 0.3, position = position_nudge(x = 0.25, y = 0)) + 
  geom_signif(comparisons = list(c("scrn.MPH", "main.MPH")), annotations = "**", y_position = 2.5, tip_length = 0.01, color = 'black', textsize = 8) + 
  geom_signif(comparisons = list(c("scrn.Nic", "main.Nic")), annotations = "**", y_position = 2.5, tip_length = 0.01, color = 'black', textsize = 8) +
  geom_signif(comparisons = list(c("main.Pla", "main.MPH")), annotations = "n.s.", y_position = 4, tip_length = 0.01, color = 'black', textsize = 5) + 
  geom_signif(comparisons = list(c("main.Pla", "main.Nic")), annotations = "n.s.", y_position = 4.8, tip_length = 0.01, color = 'black', textsize = 5) +
  geom_signif(comparisons = list(c("main.Pla", "main.Rebox")), annotations = "n.s.", y_position = 5.6, tip_length = 0.01, color = 'black', textsize = 5) 

#######################
### Effect of delay ###
#######################
df.time[df.time$delay > 10, c('subject_ID', 'environment', 'difference', 'session_type', 'drug', 'trials', 'delay')]
# Most of the long delays were before the first trial => when people were reading the instructions

df.time_delay = df.time %>% group_by(subject_ID, session_type) %>% summarise(delay = mean(delay, na.rm = TRUE))
mean.scrn = mean(df.time_delay[df.time_delay$session_type == 'scrn', 'delay'][[1]], na.rm = TRUE); sd.scrn = sd(df.time_delay[df.time_delay$session_type == 'scrn', 'delay'][[1]], na.rm = TRUE)
df.time_delay[df.time_delay$session_type == 'scrn' & df.time_delay$delay > mean.scrn + 3*sd.scrn,  ]
mean.main = mean(df.time_delay[df.time_delay$session_type == 'main', 'delay'][[1]], na.rm = TRUE); sd.main = sd(df.time_delay[df.time_delay$session_type == 'main', 'delay'][[1]], na.rm = TRUE)
df.time_delay[df.time_delay$session_type == 'main' & df.time_delay$delay > mean.main + 3*sd.main,  ]

# Let's see the evolution of the delay
df.time_delay = df.time %>% group_by(trials, session_type) %>% summarise(delay.mean = mean(delay, na.rm = TRUE), delay.sd = std.error(delay, na.rm = TRUE))
ggplot(df.time_delay, aes(x = trials, y = delay.mean, group = session_type)) + geom_line(aes(color = session_type), size = 2) + geom_ribbon(aes(ymin = delay.mean - qt(0.975, df = 160 - 1)*delay.sd, ymax = delay.mean + qt(0.975, df = 160 - 1)*delay.sd, fill = session_type), alpha = 0.3) + scale_color_manual(values = c("darkorange4","azure4")) + scale_fill_manual(values = c("darkorange4","azure4")) + theme_bw() + theme(axis.text.x = element_text(color = "grey20", size = 20, hjust = .5, vjust = .5, face = "plain"), axis.text.y = element_text(color = "grey20", size = 20, hjust = 1, vjust = 0, face = "plain"), axis.title.x = element_text(color = "grey20", size = 20, hjust = .5, vjust = 0, face = "plain"), axis.title.y = element_text(color = "grey20", size = 20,  hjust = .5, vjust = .5, face = "plain"), legend.text = element_text(color = "grey20", size = 20,  hjust = .5, vjust = .5, face = "plain"), legend.title = element_text(color = "grey20", size = 20,  hjust = .5, vjust = .5, face = "plain"))

df.for_delay = df.time[df.time$trials > 1, ] %>% group_by(subject_ID, session_type, drug, gender) %>% summarise(delay = mean(delay), age = mean(age))
df.for_delay$age_z = zscore(df.for_delay$age) 
df.for_delay$delay_s_z = zscore(sqrt(df.for_delay$delay), na.rm = TRUE)

bayesian_model = brm(delay_s_z ~ session_type * drug + age_z + gender + (1|subject_ID), data = df.for_delay, warmup = 1000, iter = 3000, chains = 4, control = list(adapt_delta = 0.97), cores = 1, refresh = 1, silent = FALSE)

summary(bayesian_model) # investigate convergence
loo(bayesian_model) # investigate convergence
plot(bayesian_model) # investigate convergence

emmeans(bayesian_model, trt.vs.ctrl ~ drug | session_type) # between-session drug effects
emmeans(bayesian_model, list(pairwise ~ session_type | drug)) # within-subject drug effects   

# Figure 4B
df.time_one_per_subject = aggregate(x = c((df.time[df.time$trials != 1, 'delay'])), by = list(df.time[df.time$trials != 1, 'session_type'], df.time[df.time$trials != 1, 'drug'], df.time[df.time$trials != 1, 'subject_ID']), FUN = mean); colnames(df.time_one_per_subject) = c('session_type', 'drug', 'subject_ID', 'delay')
pd = position_jitterdodge(jitter.width = 0.1, dodge.width = 0.2)
ggplot(df.time_one_per_subject, aes(x = interaction(session_type, drug), y = delay, color = interaction(session_type, drug))) + 
  geom_boxplot(outlier.shape = NA, size = 1, width = 0.3) + 
  geom_point(aes(group = subject_ID, fill = session_type, color = interaction(session_type, drug)), size = 3, shape = 21, stroke = 1.5, position = pd, alpha = 0.2) +
  geom_line(aes(group = subject_ID, color = 'red'), position = pd) +
  scale_color_manual(values = c("#016F91","#016F91", "#016F91", "#016F91", 
                                "gray68",
                                "cornsilk4","cornsilk4", "cornsilk4", "cornsilk4")) +
  scale_fill_manual(values = c("cornsilk4","#016F91")) +
  theme_bw() + 
  theme(legend.position = 'none', legend.background = element_rect(fill = "transparent"),
        axis.text.x = element_text(color = "grey20", size = 20, hjust = 1, vjust = 1, face = "plain", angle = 45),
        axis.text.y = element_text(color = "grey20", size = 20, hjust = .5, vjust = .5, face = "plain"),  
        axis.title.x = element_text(color = "grey20", size = 20, hjust = .5, vjust = -3, face = "plain"),
        axis.title.y = element_text(color = "grey20", size = 20,  hjust = .5, vjust = 3, face = "plain"),
        legend.text = element_text(color = "grey20", size = 20,  hjust = .5, vjust = .5, face = "plain"),
        legend.title = element_text(color = "grey20", size = 20,  hjust = .5, vjust = .5, face = "plain")) +
  labs(x = 'Drug x Session', y = 'Initiation time [s]') + ylim(0, 10) +
  scale_x_discrete(breaks=c("main.Pla", "main.MPH", "main.Nic", "main.Rebox"), labels = c('Placebo', 'MPH', 'Nicotine', 'Reboxetine')) +
  theme(plot.margin = margin(1, 1, 1, 1, "cm")) + 
  geom_flat_violin(df.time_one_per_subject, mapping = aes(fill = session_type, color = interaction(session_type, drug)), width = 0.5, trim = FALSE, scale = 'width', adjust = 1.5, alpha = 0.3, position = position_nudge(x = 0.25, y = 0)) +   
  geom_signif(comparisons = list(c("scrn.Pla", "main.Pla")), annotations = "**", y_position = 7, tip_length = 0.01, color = 'black', textsize = 8) + 
  geom_signif(comparisons = list(c("scrn.Nic", "main.Nic")), annotations = "**", y_position = 7, tip_length = 0.01, color = 'black', textsize = 8) +
  geom_signif(comparisons = list(c("scrn.Rebox", "main.Rebox")), annotations = "**", y_position = 7, tip_length = 0.01, color = 'black', textsize = 8) +  
  geom_signif(comparisons = list(c("main.Pla", "main.MPH")), annotations = "*", y_position = 7.5, tip_length = 0.01, color = 'black', textsize = 8) + 
  geom_signif(comparisons = list(c("main.Pla", "main.Nic")), annotations = "n.s.", y_position = 8.5, tip_length = 0.01, color = 'black', textsize = 5) +
  geom_signif(comparisons = list(c("main.Pla", "main.Rebox")), annotations = "n.s.", y_position = 9, tip_length = 0.01, color = 'black', textsize = 5) 
