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
library("data.table") # fwrite
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
library("tidyr")
library("ggdist")
library("PupillometryR")
library("loo")

# 137, 138, 139 were excluded due to a technical error in data acquisition
# 58, 106, 124, 128 were excluded because they cheated in the backward condition  
d = df.fr[df.fr$reaction_time > 1 & !(df.fr$subject_ID %in% c(137, 138, 139, 58, 106, 124, 128)), ] %>% group_by(subject_ID, gender, drug) %>% summarise(abs_opt = mean(abs_opt), 
                                                                                                                                                         opt = mean(opt),
                                                                                                                                                         performance = sum(collected_reward),
                                                                                                                                                         performance_mean = mean(collected_reward),
                                                                                                                                                         delay = mean(delay),
                                                                                                                                                         BMI = mean(BMI), 
                                                                                                                                                         age = mean(age), 
                                                                                                                                                         memory_mean_1 = mean(memory_mean_1),
                                                                                                                                                         memory_mean_2 = mean(memory_mean_2),
                                                                                                                                                         memory_mean_diff = mean(memory_mean_diff))

# Plot a correlation between the two timepoints
cor.test(memory_mean_1 ~ memory_mean_2, d, method = 'spearman')

ggplot(d, aes(x = memory_mean_1, y = memory_mean_2)) + 
  geom_point(col = '#712F2F', shape = 16, stroke = 1.1, size = 6, stroke = 1.1, alpha = 0.5) +
  geom_smooth(method=lm,formula = y ~ x, color="#712F2F", fill="#712F2F", size = 3, alpha = 0.5) + 
  theme(legend.position = "top") + theme_bw() + 
  theme(axis.text.x = element_text(color = "grey20", size = 20, hjust = .5, vjust = .5, face = "plain"),
        axis.text.y = element_text(color = "grey20", size = 20, hjust = .5, vjust = .5, face = "plain"),  
        axis.title.x = element_text(color = "grey20", size = 20, hjust = .5, vjust = -3, face = "plain"),
        axis.title.y = element_text(color = "grey20", size = 20,  hjust = .5, vjust = 3, face = "plain"),
        legend.text = element_text(color = "grey20", size = 20,  hjust = .5, vjust = .5, face = "plain"),
        legend.title = element_text(color = "grey20", size = 20,  hjust = .5, vjust = .5, face = "plain")) +
  labs(x = 'Working memory capacity at T0 - 10', y = 'Working memory capacity at T0 + 210') + 
  theme(plot.margin = margin(1, 1, 1, 1, "cm"))

# Difference in WM capacity between two time points
df.for_plotting = pivot_longer(d, cols = c('memory_mean_1', 'memory_mean_2'), names_to = "Time", values_to = "Memory"); df.for_plotting$Time = as.factor(df.for_plotting$Time)

model = lmer(Memory ~ drug*Time + age + gender + BMI + (1|subject_ID), df.for_plotting)
emmeans(model, specs = trt.vs.ctrl ~ drug|Time, adjust = "holm", lmer.df = "satterthwaite", lmerTest.limit = 5000) # no difference at baseline
emmeans(model, specs = pairwise ~ Time|drug, adjust = "holm", lmer.df = "satterthwaite", lmerTest.limit = 5000) # we multiply by 4 all p-values because the sign "|" does not do it automatically here (using "holm" or "none" produces the same result)  

# Plot the results
se <- function(x) sd(x) / sqrt(length(x)) # or we can use std.error()
df.for_plotting = d %>% group_by(drug) %>% summarise(mean = mean(memory_mean_diff), sd = se(memory_mean_diff))

pd = position_jitterdodge(jitter.width = 0.15, dodge.width = 0.6)
ggplot(df.for_plotting, aes(x = drug, y = mean, col = drug)) + 
  geom_errorbar(aes(ymin = mean - sd, ymax = mean + sd), width = 0.1, size = 1.5) +
  geom_line(aes(color = drug), size = 1.5) +
  geom_point(aes(color = drug), size = 3, shape = 21, fill = 'white', stroke = 1.1) +
  theme_bw() + 
  theme(legend.position = 'none', legend.background = element_rect(fill = "transparent"),
        axis.text.x = element_text(color = "grey20", size = 20, hjust = 1, vjust = 1, face = "plain", angle = 45),
        axis.text.y = element_text(color = "grey20", size = 20, hjust = .5, vjust = .5, face = "plain"),  
        axis.title.x = element_text(color = "grey20", size = 20, hjust = .5, vjust = -3, face = "plain"),
        axis.title.y = element_text(color = "grey20", size = 20,  hjust = 1, vjust = 3, face = "plain"),
        legend.text = element_text(color = "grey20", size = 20,  hjust = .5, vjust = .5, face = "plain"),
        legend.title = element_text(color = "grey20", size = 20,  hjust = .5, vjust = .5, face = "plain")) +
  labs(x = 'Drug' , y = 'Difference in working memory capacity') +   
  ylim(-0.5, 1.3) +   theme(plot.margin = margin(1, 1, 1, 1, "cm")) + 
  geom_hline(yintercept = 0) +  
  geom_signif(comparisons = list(c("MPH", "MPH")), annotations = "*", y_position = 0.8, tip_length = 0, color = 'black', textsize = 8) +
  scale_color_manual(values = c('#A0A0A0', '#61A3C9', '#0B7951', '#795C0B')) + scale_x_discrete(labels = c('Placebo', 'MPH', 'Nicotine', 'Reboxetine'))

# Test for correlations between WM metrics and foraging optimality
cor.test(abs_opt ~ memory_mean_1, d, method = 'spearman')
cor.test(abs_opt ~ memory_mean_1, d[d$drug == 'Pla',], method = 'spearman')
cor.test(abs_opt ~ memory_mean_1, d[d$drug == 'MPH',], method = 'spearman')
cor.test(abs_opt ~ memory_mean_1, d[d$drug == 'Nic',], method = 'spearman')
cor.test(abs_opt ~ memory_mean_1, d[d$drug == 'Rebox',], method = 'spearman')

cor.test(abs_opt ~ memory_mean_2, d, method = 'spearman')
cor.test(abs_opt ~ memory_mean_2, d[d$drug == 'Pla',], method = 'spearman')
cor.test(abs_opt ~ memory_mean_2, d[d$drug == 'MPH',], method = 'spearman')
cor.test(abs_opt ~ memory_mean_2, d[d$drug == 'Nic',], method = 'spearman')
cor.test(abs_opt ~ memory_mean_2, d[d$drug == 'Rebox',], method = 'spearman')

cor.test(abs_opt ~ memory_mean_diff, d, method = 'spearman')
cor.test(abs_opt ~ memory_mean_diff, d[d$drug == 'Pla',], method = 'spearman')
cor.test(abs_opt ~ memory_mean_diff, d[d$drug == 'MPH',], method = 'spearman')
cor.test(abs_opt ~ memory_mean_diff, d[d$drug == 'Nic',], method = 'spearman')
cor.test(abs_opt ~ memory_mean_diff, d[d$drug == 'Rebox',], method = 'spearman')
