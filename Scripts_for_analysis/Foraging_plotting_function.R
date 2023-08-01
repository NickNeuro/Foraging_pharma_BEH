plotting_function = function(df.for_plotting, df.for_jitter, optimal.data, optimal_yes, x_legend, y_legend, x_lim, y_lim) 
{
  pd = position_jitterdodge(jitter.width = 0.15, dodge.width = 0.6)
  ggplot(df.for_plotting, aes(x = field, y = mean, col = environment, group = environment)) + 
    theme_bw() + 
    # theme(legend.position = c(0.2,0.9), legend.background = element_rect(fill = "transparent")) + 
    theme(legend.position = 'none') +
    theme(axis.text.x = element_text(color = "grey20", size = 20, hjust = .5, vjust = .5, face = "plain"),
          axis.text.y = element_text(color = "grey20", size = 20, hjust = .5, vjust = .5, face = "plain"),  
          axis.title.x = element_text(color = "grey20", size = 20, hjust = .5, vjust = -3, face = "plain"),
          axis.title.y = element_text(color = "grey20", size = 20,  hjust = .5, vjust = 3, face = "plain"),
          legend.text = element_text(color = "grey20", size = 20,  hjust = .5, vjust = .5, face = "plain"),
          legend.title = element_text(color = "grey20", size = 20,  hjust = .5, vjust = .5, face = "plain")) +
    labs(x = x_legend, y = y_legend) +   
    ylim(x_lim, y_lim) + 
    theme(plot.margin = margin(t = 0.5, r = 0.5, b = 0.5, l = 0.5, "cm")) +
    geom_flat_violin(df.for_jitter[df.for_jitter$environment == 'poor',], mapping = aes(x = field, y = mean, group = field, fill = 'green'), width = 0.5, trim = FALSE, scale = 'width', adjust = 1, alpha = 0.3, position = position_nudge(x = 0.35, y = 0)) +
    geom_flat_violin(df.for_jitter[df.for_jitter$environment == 'rich',], mapping = aes(x = field, y = mean, group = field, fill = 'red'), width = 0.5, trim = FALSE, scale = 'width', adjust = 1, alpha = 0.3, position = position_nudge(x = 0.25, y = 0)) +
    geom_point(data = df.for_jitter, mapping = aes(x = field, y = mean, col = environment), size = 1, stroke = 1.5, position = pd, alpha = 0.3) +
    geom_errorbar(aes(ymin = mean - sd, ymax = mean + sd), width = 0.1, size = 1.5) +
    geom_line(aes(color = environment), size = 1.5) +
    geom_point(aes(color = environment), size = 3, shape = 21, fill = 'white', stroke = 1.1) +
    { if(optimal_yes) geom_point(data = optimal.data, mapping = aes(x = field, y = optimal_time, col = environment), size = 5) } +
    { if(optimal_yes) geom_line(data = optimal.data, aes(x = field, y = optimal_time, col = environment), size = 1.5, linetype = "dashed") }  +
    scale_color_manual(values = c('#228B22', '#B9A104')) + scale_fill_manual(values = c('#228B22', '#B9A104')) 
}
