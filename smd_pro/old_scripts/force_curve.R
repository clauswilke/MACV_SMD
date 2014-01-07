rm(list = ls())

require(plyr)

scatter.plot <- function(df, name, axes, centers.mclust) {
  require(ggplot2)
  require(grid)
  
  graphics.off()
  the_pointsize=26
  theme_set(theme_bw(base_size=the_pointsize))
  old_theme <- theme_update(panel.border=element_blank(),
                            axis.line=element_line(),
                            panel.grid.minor=element_blank(),
                            panel.grid.major=element_blank(),
                            panel.background=element_blank(),
                            panel.border=element_blank(),
                            axis.line=element_line())
  
  #print(centers.mclust)
  g <- ggplot()
  g <- g + geom_point(data=df, aes(x=distance, y=force), size=2.5)
  
  g <- g + theme(strip.background=element_blank())
  g <- g + ylab("Force")
  g <- g + xlab("Distance (Angstrom")
  g <- g + scale_y_continuous(limits=c(-1, 1))
  g <- g + scale_x_continuous(limits=c(-1, 1))
  g <- g + theme(panel.border = element_blank(), axis.line = element_line())
  g <- g + theme(axis.title.x = element_text(size=the_pointsize, vjust=-.2))
  g <- g + theme(axis.title.y = element_text(angle=90, size=the_pointsize, vjust=.3))
  g <- g + theme(axis.line = element_line(colour = 'black', size = 1))
  g <- g + theme(axis.ticks = element_line(colour = 'black', size = 1))
  g <- g + theme(plot.margin=unit(c(1, 1, 1, 1), "lines"))
  g <- g + theme(axis.ticks.margin = unit(0.15, "cm"))
  g <- g + theme(legend.position = "none") 
  ggsave(g, file=name, width=7, height=5)
}

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
  
  g <- ggplot(rbind(diff.df[diff.df$id=='WT', ], diff.df[diff.df$id=='N348W/Y211A', ], diff.df[diff.df$id=='Y211D', ]), 
              aes(y1, fill = id)) + 
    geom_density(alpha = 0.2, size=1) +
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
  
  ggsave(g, file='~/Desktop/MACV_SMD/figures/test_sensitivity.pdf', width=7, height=5)
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
  
  ggsave(g, file='~/Desktop/MACV_SMD/figures/mutant_comparison_boxplot.pdf', width=7, height=5)
}

setwd('~/Desktop/MACV_SMD/smd_pro/')

interpolation_window <-50

get.data <- function(folder) {
  print(paste("Starting", folder))
  
  files <- list.files(paste(folder,"/distance",sep=''))
  
  frames = length(read.table(paste(folder,"/distance/distance_1.dat",sep=''))[,2])
  print(frames)
  
  force.data <- c()
  distance.data <- c()
  id.data <- c()
  
  for(file in 1:length(files)){
    force.file <- paste("force_",file,sep='')
    distance.file <- paste("force_",file,sep='')
    
    force.data.tmp <- read.table(paste(folder,"/force/force_",file-1,".dat",sep=''))[,2]
    distance.data.tmp <- read.table(paste(folder,"/distance/distance_",file-1,".dat",sep=''))[,2]
    
    if(!length(force.data.tmp) == length(distance.data.tmp))
      force.data.tmp = force.data.tmp[-length(force.data.tmp)]
    
    if(!length(force.data.tmp) == length(distance.data.tmp)) {
      print(paste("Skipping ", force.file, " and ", distance.file, sep=''))
      next
    }
    
    smoothed <- smooth.spline(distance.data.tmp, force.data.tmp)
    distance.data.tmp <- seq(0, max(distance.data.tmp), length=frames)
    force.data.tmp <- data.frame(predict(smoothed, distance.data.tmp))[,2]
    
    force.data <- c(force.data, force.data.tmp)
    distance.data <- c(distance.data, distance.data.tmp)
    id.data <- c(id.data, rep(file, frames))
  }
  
  final.data <- data.frame(id=id.data, force=force.data, distance=distance.data)
  return(final.data)
}

folders <- list.files(pattern="data_*")

na <- get.data(folders[1])
na.old <- get.data(folders[2])
na.ya <- get.data(folders[3])
nk <- get.data(folders[4])
nw <- get.data(folders[5])
nw.ya <- get.data(folders[6])
ra <- get.data(folders[7])
ra.ya <- get.data(folders[8])
wt <- get.data(folders[9])
wt.old <- get.data(folders[10])
ya <- get.data(folders[11])
yd <- get.data(folders[12])
yt <- get.data(folders[13])

max.wt <- aggregate(wt$force, by=list(wt$id), FUN=max)
max.ya <- aggregate(ya$force, by=list(ya$id), FUN=max)
max.yd <- aggregate(yd$force, by=list(yd$id), FUN=max)
max.yt <- aggregate(yt$force, by=list(yt$id), FUN=max)
max.na <- aggregate(na$force, by=list(na$id), FUN=max)
max.nw <- aggregate(nw$force, by=list(nw$id), FUN=max)
max.nk <- aggregate(nk$force, by=list(nk$id), FUN=max)
max.ra <- aggregate(ra$force, by=list(ra$id), FUN=max)
max.na.ya <- aggregate(na.ya$force, by=list(na.ya$id), FUN=max)
max.nw.ya <- aggregate(nw.ya$force, by=list(nw.ya$id), FUN=max)
max.ra.ya <- aggregate(ra.ya$force, by=list(ra.ya$id), FUN=max)

max.wt.old <- aggregate(wt.old$force, by=list(wt.old$id), FUN=max)
max.na.old <- aggregate(na.old$force, by=list(na.old$id), FUN=max)

sum.wt <- aggregate(wt$force, by=list(wt$id), FUN=sum)
sum.ya <- aggregate(ya$force, by=list(ya$id), FUN=sum)
sum.yd <- aggregate(yd$force, by=list(yd$id), FUN=sum)
sum.yt <- aggregate(yt$force, by=list(yt$id), FUN=sum)
sum.na <- aggregate(na$force, by=list(na$id), FUN=sum)
sum.nw <- aggregate(nw$force, by=list(nw$id), FUN=sum)
sum.nk <- aggregate(nk$force, by=list(nk$id), FUN=sum)
sum.ra <- aggregate(ra$force, by=list(ra$id), FUN=sum)
sum.na.ya <- aggregate(na.ya$force, by=list(na.ya$id), FUN=sum)
sum.nw.ya <- aggregate(nw.ya$force, by=list(nw.ya$id), FUN=sum)
sum.ra.ya <- aggregate(ra.ya$force, by=list(ra.ya$id), FUN=sum)

split.force.wt <- data.frame(split(wt$force, wt$id))
split.force.ya <- data.frame(split(ya$force, ya$id))
split.force.yd <- data.frame(split(yd$force, yd$id))
split.force.yt <- data.frame(split(yt$force, yt$id))
split.force.na <- data.frame(split(na$force, na$id))
split.force.nw <- data.frame(split(nw$force, nw$id))
split.force.nk <- data.frame(split(nk$force, nk$id))
split.force.ra <- data.frame(split(ra$force, ra$id))
split.force.na.ya <- data.frame(split(na.ya$force, na.ya$id))
split.force.nw.ya <- data.frame(split(nw.ya$force, nw.ya$id))
split.force.ra.ya <- data.frame(split(ra.ya$force, ra.ya$id))

df <- data.frame(id=c(rep('WT', length(max.wt[, 1])), rep('N348A', length(max.na[, 1])), 
                      rep('N348W', length(max.nw[, 1])), rep('N348K', length(max.nk[, 1])), 
                      rep('R111A', length(max.ra[, 1])), rep('N348A/Y211A', length(max.na.ya[, 1])),
                      rep('vR111A/Y211A', length(max.ra.ya[, 1])), rep('Y211D', length(max.yd[, 1])),
                      rep('Y211T', length(max.yt[, 1])), rep('Y211A', length(max.ya[, 1])),
                      rep('N348W/Y211A', length(max.nw.ya[, 1])) ), 
                 y1=c(max.wt$x, max.na$x, 
                      max.nw$x, max.nk$x,
                      max.ra$x, max.na.ya$x,
                      max.ra.ya$x, max.yd$x,
                      max.yt$x, max.ya$x,
                      max.nw.ya$x),
                 y2=c(sum.wt$x, sum.na$x, 
                      sum.nw$x, sum.nk$x,
                      sum.ra$x, sum.na.ya$x,
                      sum.ra.ya$x, sum.yd$x,
                      sum.yt$x, sum.ya$x,
                      sum.nw.ya$x))

df$id <- factor(df$id, c('WT', 'N348A', 'N348W', 'N348K', 
                         'R111A', 'N348A/Y211A', 'vR111A/Y211A', 
                         'Y211D', 'Y211T', 'Y211A', 'N348W/Y211A'))

smd.boxplot(df)
diff.plot(df)

print(pairwise.t.test(scale(df$y2), df$id, p.adjust.method="fdr"))

ddply(df, .(id), colwise(mean))
ddply(df, .(id), colwise(sd))


#FEP comparison
all.mutants <- data.frame(id=c('WT','Y211A', 'Y211D', 'Y211T', 'N348A', 'N348K', 'N348W', 'vR111A','211A_348A','211A_348W','211A_111A'), 
                          smd=c(734.4856, 654.1138, 825.2586, 806.8593, 748.5217, 697.3642, 705.0707, 713.8081, 703.7027, 594.9044, 741.0642),
                          auc=c(145460, 108090.0, 158878.7, 167110.7, 133913.9, 136886.0, 141084.4, 136103.2, 113464.2, 108984.2, 130070.6), 
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
  
  ggsave(g, file='~/Desktop/MACV_SMD/figures/fep_mutants.pdf', width=7, height=5)
  return(g)
}

smd.points(all.mutants)


