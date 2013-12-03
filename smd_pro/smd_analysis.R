rm(list = ls())

setwd('~/Google Drive/Documents/Biochem/Research/SMD_manuscript/MACV_SMD/smd_pro/')

diff.plot <- function(diff.df) {
  require(ggplot2)
  require(grid)
  
  graphics.off()
  the_pointsize=22
  theme_set(theme_bw(base_size=the_pointsize))
  old_theme <- theme_update(panel.border=element_blank(),
                            axis.line=element_line(),
                            panel.grid.minor=element_blank(),
                            panel.grid.major=element_blank(),
                            panel.background=element_blank(),
                            panel.border=element_blank(),
                            axis.line=element_line())
  
  g <- ggplot(rbind(diff.df[diff.df$id=='awt', ], diff.df[diff.df$id=='jnw_ya', ], diff.df[diff.df$id=='fyd', ]), 
              aes(y2, fill = id)) + 
    geom_density(alpha = 0.2, size=1) +  #+ 
    theme(strip.background=element_blank()) +
    ylab('Density') +
    xlab('Interpolated Max Force (pN)') +
    scale_x_continuous(breaks=seq(100, 1300, 200), limits=c(50, 1350)) +
    theme(panel.border=element_blank(), axis.line=element_line()) +
    theme(axis.title.x = element_text(size=the_pointsize, vjust=-.2)) +
    theme(axis.title.y = element_text(angle=90, size=the_pointsize, vjust=.3)) +
    theme(axis.line = element_line(colour = 'black', size = 1)) +
    theme(axis.ticks = element_line(colour = 'black', size = 1)) +
    theme(plot.margin=unit(c(1, 1, 1, 1), "lines")) +
    theme(axis.ticks.margin = unit(0.15, "cm")) +
    theme(legend.position = "none")
  
  ggsave(g, file='../figures/test_sensitivity.pdf', width=7, height=5)
}


smd.boxplot <- function(boxplot.df) {
  require(ggplot2)
  require(grid)
  
  graphics.off()
  the_pointsize=20
  theme_set(theme_bw(base_size=the_pointsize))
  old_theme <- theme_update(panel.border=element_blank(),
                            axis.line=element_line(),
                            panel.grid.minor=element_blank(),
                            panel.grid.major=element_blank(),
                            panel.background=element_blank(),
                            panel.border=element_blank(),
                            axis.line=element_line())
  
  g <- ggplot(boxplot.df, aes(factor(id), y1)) + geom_boxplot()
  g <- g + theme(strip.background=element_blank())
  g <- g + ylab('Distribution of Max Force (pN)')
  g <- g + xlab('Mutant')
  g <- g + theme(panel.border=element_blank(), axis.line=element_line())
  g <- g + theme(axis.title.x = element_text(size=18, vjust=0))
  g <- g + theme(axis.text.x = element_text(angle=45, vjust = 1.05, hjust = 1, size=12))
  g <- g + theme(axis.title.y = element_text(angle=90, size=18, vjust=.3))
  g <- g + theme(axis.text.y = element_text(size=12))
  g <- g + theme(axis.line = element_line(colour = 'black', size = 1))
  g <- g + theme(axis.ticks = element_line(colour = 'black', size = 1))
  g <- g + theme(plot.margin=unit(c(1, 1, 1, 1), "lines"))
  g <- g + theme(axis.ticks.margin = unit(0.15, "cm"))
  g <- g + theme(legend.position = "none")
  g <- g + geom_text(aes(8, 1300, label="*"), colour='black', size=8)
  g <- g + geom_text(aes(9, 1300, label="*"), colour='black', size=8)
  g <- g + geom_text(aes(10, 1300, label="*"), colour='black', size=8)
  g <- g + geom_text(aes(11, 1300, label="*"), colour='black', size=8)
  
  ggsave(g, file='../figures/mutant_comparison_boxplot.pdf', width=7, height=5)
}

require(plyr)
#require(pwr)

import.data <- function(complex) {
  for(i in 0:49) {
    
    min.distance = 5
    
    ## Grab all data and put it into a data frame
    if(file.exists(paste("data_", complex, "/force/force_", i, ".dat", sep="")) && !exists("data.tmp")) {
      force_tmp <- read.table(paste("data_", complex, "/force/force_", i, ".dat", sep=""))
      distance_tmp <- read.table(paste("data_", complex, "/distance/distance_", i, ".dat", sep=""))
      
      data <- data.frame(distance = distance_tmp[, 2], force = force_tmp[-dim(force_tmp)[1], 2])
      
      if(max(data$distance) < min.distance)
        next
      
      smoothed <- smooth.spline(data$distance, data$force)
      new.points <- data.frame(predict(smoothed, seq(0, min.distance, length=250)))
      
      data.tmp <- cbind(new.points, run=rep(i, length(new.points[, 1])))
    }
    else if(file.exists(paste("data_", complex, "/force/force_", i, ".dat", sep=""))) {
      force_tmp <- read.table(paste("data_", complex, "/force/force_", i, ".dat", sep=""))
      distance_tmp <- read.table(paste("data_", complex, "/distance/distance_", i, ".dat", sep=""))
      
      data <- data.frame(distance = distance_tmp[, 2], force = force_tmp[-dim(force_tmp)[1], 2])
      
      if(max(data$distance) < min.distance)
        next
      
      smoothed <- smooth.spline(data$distance, data$force)
      new.points <- data.frame(predict(smoothed, seq(0, min.distance, length=250)))
      
      temp <- cbind(new.points, run=rep(i, length(new.points[, 1])))
      data.tmp <- rbind(data.tmp, temp)
    }
    print(complex)
    print(i)
  }
  
  return(data.tmp)
  rm(data.tmp)
}

wt <- import.data("wt")
ya <- import.data("ya")
yd <- import.data("yd")
yt <- import.data("yt")
na <- import.data("na")
nw <- import.data("nw")
nk <- import.data("nk")
ra <- import.data("ra")
na.ya <- import.data("na_ya")
nw.ya <- import.data("nw_ya")
ra.ya <- import.data("ra_ya")
nw.ya <- import.data("nw_ya")
ra.ya <- import.data("ra_ya")

wt.old <- import.data("wt_old")
na.old <- import.data("na_old")

max.wt <- aggregate(wt$y, by=list(wt$run), FUN=max)
max.ya <- aggregate(ya$y, by=list(ya$run), FUN=max)
max.yd <- aggregate(yd$y, by=list(yd$run), FUN=max)
max.yt <- aggregate(yt$y, by=list(yt$run), FUN=max)
max.na <- aggregate(na$y, by=list(na$run), FUN=max)
max.nw <- aggregate(nw$y, by=list(nw$run), FUN=max)
max.nk <- aggregate(nk$y, by=list(nk$run), FUN=max)
max.ra <- aggregate(ra$y, by=list(ra$run), FUN=max)
max.na.ya <- aggregate(na.ya$y, by=list(na.ya$run), FUN=max)
max.nw.ya <- aggregate(nw.ya$y, by=list(nw.ya$run), FUN=max)
max.ra.ya <- aggregate(ra.ya$y, by=list(ra.ya$run), FUN=max)

max.wt.old <- aggregate(wt.old$y, by=list(wt.old$run), FUN=max)
max.na.old <- aggregate(na.old$y, by=list(na.old$run), FUN=max)

sum.wt <- aggregate(wt$y, by=list(wt$run), FUN=sum)
sum.ya <- aggregate(ya$y, by=list(ya$run), FUN=sum)
sum.yd <- aggregate(yd$y, by=list(yd$run), FUN=sum)
sum.yt <- aggregate(yt$y, by=list(yt$run), FUN=sum)
sum.na <- aggregate(na$y, by=list(na$run), FUN=sum)
sum.nw <- aggregate(nw$y, by=list(nw$run), FUN=sum)
sum.nk <- aggregate(nk$y, by=list(nk$run), FUN=sum)
sum.ra <- aggregate(ra$y, by=list(ra$run), FUN=sum)
sum.na.ya <- aggregate(na.ya$y, by=list(na.ya$run), FUN=sum)
sum.nw.ya <- aggregate(nw.ya$y, by=list(nw.ya$run), FUN=sum)
sum.ra.ya <- aggregate(ra.ya$y, by=list(ra.ya$run), FUN=sum)

split.force.wt <- data.frame(split(wt$y, wt$run))
split.force.ya <- data.frame(split(ya$y, ya$run))
split.force.yd <- data.frame(split(yd$y, yd$run))
split.force.yt <- data.frame(split(yt$y, yt$run))
split.force.na <- data.frame(split(na$y, na$run))
split.force.nw <- data.frame(split(nw$y, nw$run))
split.force.nk <- data.frame(split(nk$y, nk$run))
split.force.ra <- data.frame(split(ra$y, ra$run))
split.force.na.ya <- data.frame(split(na.ya$y, na.ya$run))
split.force.nw.ya <- data.frame(split(nw.ya$y, nw.ya$run))
split.force.ra.ya <- data.frame(split(ra.ya$y, ra.ya$run))

df <- data.frame(id=c(rep('WT', length(max.wt[, 1])), rep('N348A', length(max.na[, 1])), 
                      rep('N348K', length(max.nk[, 1])), rep('N348W', length(max.nw[, 1])), 
                      rep('R111A', length(max.ra[, 1])), rep('N348A/Y211A', length(max.na.ya[, 1])),
                      rep('vR111A/Y211A', length(max.ra.ya[, 1])), rep('Y211D', length(max.yd[, 1])),
                      rep('Y211T', length(max.yt[, 1])), rep('Y211A', length(max.ya[, 1])),
                      rep('N348W/Y211A', length(max.nw.ya[, 1])) ), 
                 y1=c(max.wt$x, max.na$x, 
                      max.nk$x, max.nw$x,
                      max.ra$x, max.na.ya$x,
                      max.ra.ya$x, max.yd$x,
                      max.yt$x, max.ya$x,
                      max.nw.ya$x),
                 y2=c(sum.wt$x, sum.na$x, 
                      sum.nk$x, sum.nw$x,
                      sum.ra$x, sum.na.ya$x,
                      sum.ra.ya$x, sum.yd$x,
                      sum.yt$x, sum.ya$x,
                      sum.nw.ya$x))

df$id <- factor(df$id, c('WT', 'N348A', 'N348K', 'N348W', 
                         'R111A', 'N348A/Y211A', 'vR111A/Y211A', 
                         'Y211D', 'Y211T', 'Y211A', 'N348W/Y211A'))

smd.boxplot(df)


#fit <- aov(y1 + y2 ~ id, data = df)
#print(TukeyHSD(fit))


#print(pairwise.t.test(scale(df$y1) + scale(df$y2), df$id, p.adjust.method="fdr"))


