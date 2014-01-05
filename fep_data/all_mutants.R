all.mutants <- data.frame(id=c('WT','Y211A', 'Y211D', 'Y211T', 'N348A', 'N348K', 'N348W', 'vR111A','211A_348A','211A_348W','211A_111A'), 
                          smd=c(772.00,684.03, 875.44, 861.17, 799.33, 731.36, 732.13, 754.39,762.96,617.21,780.71),
                          auc=c(198794.7,153517.7,234909.3,231078.7,202247.3,179087.5,192043.2,185896.8,173059.2,144705.6,189919.1), 
                          fep=c(0,2.525525,-2.760073,0.875825,-2.149291,3.184248,3.033377,0.4666468,5.203034,8.206784,-2.440771))

smd.points <- function(df) {
  require(ggplot2)
  require(grid)
  
  graphics.off()
  the_pointsize=18
  theme_set(theme_bw(base_size=the_pointsize))
  old_theme <- theme_update(panel.border=element_blank(),
                            axis.line=element_line(),
                            panel.grid.minor=element_blank(),
                            panel.grid.major=element_blank(),
                            panel.background=element_blank(),
                            panel.border=element_blank(),
                            axis.line=element_line())
  
  g <- ggplot(df, aes(x=fep, y=smd)) + geom_point(size=3) + geom_smooth(method=lm)
  g <- g + theme(strip.background=element_blank())
  g <- g + ylab('Interpolated Maximum Force (pN)')
  g <- g + xlab('Free Energy Perturbation (kcal/mol)')
  g <- g + scale_x_continuous(breaks=seq(-10, 10, 2), limits=c(-3.5, 8.5))
  g <- g + scale_y_continuous(breaks=seq(500, 1000, 100), limits=c(550, 900))
  g <- g + theme(panel.border=element_blank(), axis.line=element_line())
  g <- g + theme(axis.title.x = element_text(size=18, vjust=0))
  g <- g + theme(axis.text.x = element_text(size=18))
  g <- g + theme(axis.title.y = element_text(size=18, vjust=0.25))
  g <- g + theme(axis.text.y = element_text(size=18))
  g <- g + theme(axis.line = element_line(colour = 'black', size = 1))
  g <- g + theme(axis.ticks = element_line(colour = 'black', size = 1))
  g <- g + theme(plot.margin=unit(c(1, 1, 1, 1), "lines"))
  g <- g + theme(axis.ticks.margin = unit(0.25, "cm"))
  g <- g + theme(legend.position = "none")
  
  ggsave(g, file='fep_mutants.pdf', width=7, height=5)
  return(g)
}

a <- smd.points(all.mutants)
