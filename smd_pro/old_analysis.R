setwd('~/Desktop/MD_Misc/smd_pro/')

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
  
  ggsave(g, file='~/Google Drive/Documents/Research/SMD_manuscript/MACV_SMD/figures/test_sensitivity.pdf', width=7, height=5)
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
  
  g <- ggplot(boxplot.df, aes(factor(id), y2)) + geom_boxplot()
  g <- g + theme(strip.background=element_blank())
  g <- g + ylab('Max Force')
  g <- g + xlab('Mutant')
  g <- g + theme(panel.border=element_blank(), axis.line=element_line())
  g <- g + theme(axis.title.x = element_text(size=the_pointsize, vjust=0))
  g <- g + theme(axis.text.x = element_text(angle=45, vjust = 1.05, hjust = 1, size=12))
  g <- g + theme(axis.title.y = element_text(angle=90, size=the_pointsize, vjust=.3))
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
  
  ggsave(g, file='~/Google Drive/Documents/Research/SMD_manuscript/MACV_SMD/figures/mutant_comparison_boxplot.pdf', width=7, height=5)
}

interpolation_window <-50

nums <- 0:99
files_wt <- c()
files_ya <- c()
files_ra <- c()
files_ra_ya <- c()
files_na <- c()
files_na_ya <- c()
files_nw <- c()
files_nw_ya <- c()
files_yd <- c()
files_nk <- c()
files_yt <- c()

for(i in nums) {
  if(file.exists(paste("data_wt/distance/distance_", i, ".dat", sep="")))
    distance_wt <- read.table(paste("data_wt/distance/distance_", i, ".dat", sep=""))[, 2]
  if(file.exists(paste("data_ya/distance/distance_", i, ".dat", sep="")))
    distance_ya <- read.table(paste("data_ya/distance/distance_", i, ".dat", sep=""))[, 2]
  if(file.exists(paste("data_ra/distance/distance_", i, ".dat", sep="")))
    distance_ra <- read.table(paste("data_ra/distance/distance_", i, ".dat", sep=""))[, 2]
  if(file.exists(paste("data_ra_ya/distance/distance_", i, ".dat", sep="")))
    distance_ra_ya <- read.table(paste("data_ra_ya/distance/distance_", i, ".dat", sep=""))[, 2]
  if(file.exists(paste("data_na/distance/distance_", i, ".dat", sep="")))
    distance_na <- read.table(paste("data_na/distance/distance_", i, ".dat", sep=""))[, 2]
  if(file.exists(paste("data_na_ya/distance/distance_", i, ".dat", sep="")))
    distance_na_ya <- read.table(paste("data_na_ya/distance/distance_", i, ".dat", sep=""))[, 2]
  if(file.exists(paste("data_nw/distance/distance_", i, ".dat", sep="")))
    distance_nw <- read.table(paste("data_nw/distance/distance_", i, ".dat", sep=""))[, 2]
  if(file.exists(paste("data_nw_ya/distance/distance_", i, ".dat", sep="")))
    distance_nw_ya <- read.table(paste("data_nw_ya/distance/distance_", i, ".dat", sep=""))[, 2]
  if(file.exists(paste("data_yd/distance/distance_", i, ".dat", sep="")))
    distance_yd <- read.table(paste("data_yd/distance/distance_", i, ".dat", sep=""))[, 2]
  if(file.exists(paste("data_nk/distance/distance_", i, ".dat", sep="")))
    distance_nk <- read.table(paste("data_nk/distance/distance_", i, ".dat", sep=""))[, 2]
  if(file.exists(paste("data_yt/distance/distance_", i, ".dat", sep="")))
    distance_yt <- read.table(paste("data_yt/distance/distance_", i, ".dat", sep=""))[, 2]
  
  
  if(max(distance_wt) > 4 & file.exists(paste("data_wt/distance/distance_", i, ".dat", sep="")))
    files_wt <- append(files_wt, i)
  if(max(distance_ya) > 4 & file.exists(paste("data_ya/distance/distance_", i, ".dat", sep="")))
    files_ya <- append(files_ya, i)
  if(max(distance_ra) > 4 & file.exists(paste("data_ra/distance/distance_", i, ".dat", sep="")))
    files_ra <- append(files_ra, i)
  if(max(distance_ra_ya) > 4 & file.exists(paste("data_ra_ya/distance/distance_", i, ".dat", sep="")))
    files_ra_ya <- append(files_ra_ya, i)
  if(max(distance_na) > 4 & file.exists(paste("data_na/distance/distance_", i, ".dat", sep="")))
    files_na <- append(files_na, i)
  if(max(distance_na_ya) > 4 & file.exists(paste("data_na_ya/distance/distance_", i, ".dat", sep="")))
    files_na_ya <- append(files_na_ya, i)
  if(max(distance_nw) > 4 & file.exists(paste("data_nw/distance/distance_", i, ".dat", sep="")))
    files_nw <- append(files_nw, i)
  if(max(distance_nw_ya) > 4 & file.exists(paste("data_nw_ya/distance/distance_", i, ".dat", sep="")))
    files_nw_ya <- append(files_nw_ya, i)
  if(max(distance_yd) > 4 & file.exists(paste("data_yd/distance/distance_", i, ".dat", sep="")))
    files_yd <- append(files_yd, i)
  if(max(distance_nk) > 4 & file.exists(paste("data_nk/distance/distance_", i, ".dat", sep="")))
    files_nk <- append(files_nk, i)
  if(max(distance_yt) > 4 & file.exists(paste("data_yt/distance/distance_", i, ".dat", sep="")))
    files_yt <- append(files_yt, i)
}

sum_wt <- rep(0, length(files_wt))
max_wt <- rep(0, length(files_wt))
interpolated_sum_wt <- rep(0, length(files_wt))
interpolated_max_wt <- rep(0, length(files_wt))
total_distance_wt <- rep(0, length(files_wt))
overall_mean_wt <- rep(0, length(files_wt))

cumsum_wt <- rep(0, 1000)
count <- 1
for(i in files_wt) {
  distance_wt <- read.table(paste("data_wt/distance/distance_", i, ".dat", sep=""))[, 2]
  force_wt <- read.table(paste("data_wt/force/force_", i, ".dat", sep=""))[-1001, 2]
  
  interpolated_vector_wt <- rep(0, (length(force_wt)-2*interpolation_window))
  interpolated_distance_wt <- rep(0, (length(force_wt)-2*interpolation_window))
  
  for(j in (1+interpolation_window):(length(force_wt)-interpolation_window)) {
    interpolated_force_wt <- mean(force_wt[(j-interpolation_window):(j+interpolation_window)])
    interpolated_d_wt <- mean(distance_wt[(j-interpolation_window):(j+interpolation_window)])
    interpolated_vector_wt[j] <- interpolated_force_wt
    interpolated_distance_wt[j] <- interpolated_d_wt
  }
  
  overall_mean_wt[count] <- mean(force_wt)
  sum_wt[count] <- sum(force_wt) # * c(distance_wt[-1], distance_wt[length(distance_wt)]) - distance_wt)
  max_wt[count] <- max(force_wt)
  interpolated_sum_wt[count] <- sum(interpolated_vector_wt) # * c(interpolated_distance_wt[-1], interpolated_distance_wt[length(interpolated_distance_wt)]) - interpolated_distance_wt)
  interpolated_max_wt[count] <- max(interpolated_vector_wt)
  
  cumsum_wt <- cumsum_wt + cumsum(force_wt)
  total_distance_wt[count] <- sum(distance_wt)
  count <- count + 1
}

sum_ya <- rep(0, length(files_ya))
max_ya <- rep(0, length(files_ya))
interpolated_sum_ya <- rep(0, length(files_ya))
interpolated_max_ya <- rep(0, length(files_ya))
total_distance_ya <- rep(0, length(files_ya))
overall_mean_ya <- rep(0, length(files_ya))

cumsum_ya <- rep(0, 1000)

count <- 1
for(i in files_ya) {
  distance_ya <- read.table(paste("data_ya/distance/distance_", i, ".dat", sep=""))[, 2]
  force_ya <- read.table(paste("data_ya/force/force_", i, ".dat", sep=""))[-1001, 2]
  
  interpolated_vector_ya <- rep(0, (length(force_ya)-2*interpolation_window))
  interpolated_distance_ya <- rep(0, (length(force_ya)-2*interpolation_window))
  
  for(j in (1+interpolation_window):(length(force_ya)-interpolation_window)) {
    interpolated_force_ya <- mean(force_ya[(j-interpolation_window):(j+interpolation_window)])
    interpolated_d_ya <- mean(distance_ya[(j-interpolation_window):(j+interpolation_window)])
    interpolated_vector_ya[j] <- interpolated_force_ya
    interpolated_distance_ya[j] <- interpolated_d_ya
  }
  
  overall_mean_ya[count] <- mean(force_ya)
  
  sum_ya[count] <- sum(force_ya) # * c(distance_ya[-1], length(distance_ya)) - distance_ya)
  max_ya[count] <- max(force_ya)
  interpolated_sum_ya[count] <- sum(interpolated_vector_ya) # * c(interpolated_distance_ya[-1], length(interpolated_distance_ya)) - interpolated_distance_ya)
  interpolated_max_ya[count] <- max(interpolated_vector_ya)
  
  cumsum_ya <- cumsum_ya + cumsum(force_ya)
  total_distance_ya[count] <- sum(distance_ya)
  count <- count + 1
}

sum_ra <- rep(0, length(files_ra))
max_ra <- rep(0, length(files_ra))
interpolated_sum_ra <- rep(0, length(files_ra))
interpolated_max_ra <- rep(0, length(files_ra))
total_distance_ra <- rep(0, length(files_ra))
overall_mean_ra <- rep(0, length(files_ra))

cumsum_ra <- rep(0, 1000)

count <- 1
for(i in files_ra) {
  distance_ra <- read.table(paste("data_ra/distance/distance_", i, ".dat", sep=""))[, 2]
  force_ra <- read.table(paste("data_ra/force/force_", i, ".dat", sep=""))[-1001, 2]
  
  interpolated_vector_ra <- rep(0, (length(force_ra)-2*interpolation_window))
  interpolated_distance_ra <- rep(0, (length(force_ra)-2*interpolation_window))
  
  for(j in (1+interpolation_window):(length(force_ra)-interpolation_window)) {
    interpolated_force_ra <- mean(force_ra[(j-interpolation_window):(j+interpolation_window)])
    interpolated_d_ra <- mean(distance_ra[(j-interpolation_window):(j+interpolation_window)])
    interpolated_vector_ra[j] <- interpolated_force_ra
    interpolated_distance_ra[j] <- interpolated_d_ra
  }
  
  overall_mean_ra[count] <- mean(force_ra)
  
  sum_ra[count] <- sum(force_ra) # * c(distance_ra[-1], length(distance_ra)) - distance_ra)
  max_ra[count] <- max(force_ra)
  interpolated_sum_ra[count] <- sum(interpolated_vector_ra) # * c(interpolated_distance_ra[-1], length(interpolated_distance_ra)) - interpolated_distance_ra)
  interpolated_max_ra[count] <- max(interpolated_vector_ra)
  
  cumsum_ra <- cumsum_ra + cumsum(force_ra)
  total_distance_ra[count] <- sum(distance_ra)
  count <- count + 1
}

sum_ra_ya <- rep(0, length(files_ra_ya))
max_ra_ya <- rep(0, length(files_ra_ya))
interpolated_sum_ra_ya <- rep(0, length(files_ra_ya))
interpolated_max_ra_ya <- rep(0, length(files_ra_ya))
total_distance_ra_ya <- rep(0, length(files_ra_ya))
overall_mean_ra_ya <- rep(0, length(files_ra_ya))

cumsum_ra_ya <- rep(0, 1000)

count <- 1
for(i in files_ra_ya) {
  distance_ra_ya <- read.table(paste("data_ra_ya/distance/distance_", i, ".dat", sep=""))[, 2]
  force_ra_ya <- read.table(paste("data_ra_ya/force/force_", i, ".dat", sep=""))[-1001, 2]
  
  interpolated_vector_ra_ya <- rep(0, (length(force_ra_ya)-2*interpolation_window))
  interpolated_distance_ra_ya <- rep(0, (length(force_ra_ya)-2*interpolation_window))
  
  for(j in (1+interpolation_window):(length(force_ra_ya)-interpolation_window)) {
    interpolated_force_ra_ya <- mean(force_ra_ya[(j-interpolation_window):(j+interpolation_window)])
    interpolated_d_ra_ya <- mean(distance_ra_ya[(j-interpolation_window):(j+interpolation_window)])
    interpolated_vector_ra_ya[j] <- interpolated_force_ra_ya
    interpolated_distance_ra_ya[j] <- interpolated_d_ra_ya
  }
  
  overall_mean_ra_ya[count] <- mean(force_ra_ya)
  
  sum_ra_ya[count] <- sum(force_ra_ya) # * c(distance_ra_ya[-1], length(distance_ra_ya)) - distance_ra_ya)
  max_ra_ya[count] <- max(force_ra_ya)
  interpolated_sum_ra_ya[count] <- sum(interpolated_vector_ra_ya) # * c(interpolated_distance_ra_ya[-1], length(interpolated_distance_ra_ya)) - interpolated_distance_ra_ya)
  interpolated_max_ra_ya[count] <- max(interpolated_vector_ra_ya)
  
  cumsum_ra_ya <- cumsum_ra_ya + cumsum(force_ra_ya)
  total_distance_ra_ya[count] <- sum(distance_ra_ya)
  count <- count + 1
}

sum_na <- rep(0, length(files_na))
max_na <- rep(0, length(files_na))
interpolated_sum_na <- rep(0, length(files_na))
interpolated_max_na <- rep(0, length(files_na))
total_distance_na <- rep(0, length(files_na))
overall_mean_na <- rep(0, length(files_na))

cumsum_na <- rep(0, 1000)

count <- 1
for(i in files_na) {
  distance_na <- read.table(paste("data_na/distance/distance_", i, ".dat", sep=""))[, 2]
  force_na <- read.table(paste("data_na/force/force_", i, ".dat", sep=""))[-1001, 2]
  
  interpolated_vector_na <- rep(0, (length(force_na)-2*interpolation_window))
  interpolated_distance_na <- rep(0, (length(force_na)-2*interpolation_window))
  
  for(j in (1+interpolation_window):(length(force_na)-interpolation_window)) {
    interpolated_force_na <- mean(force_na[(j-interpolation_window):(j+interpolation_window)])
    interpolated_d_na <- mean(distance_na[(j-interpolation_window):(j+interpolation_window)])
    interpolated_vector_na[j] <- interpolated_force_na
    interpolated_distance_na[j] <- interpolated_d_na
  }
  
  overall_mean_na[count] <- mean(force_na)
  
  sum_na[count] <- sum(force_na) # * c(distance_na[-1], length(distance_na)) - distance_na)
  max_na[count] <- max(force_na)
  interpolated_sum_na[count] <- sum(interpolated_vector_na) #  * c(interpolated_distance_na[-1], length(interpolated_distance_na)) - interpolated_distance_na)
  interpolated_max_na[count] <- max(interpolated_vector_na)
  
  #cumsum_na <- cumsum_na + cumsum(force_na)
  total_distance_na[count] <- sum(distance_na)
  count <- count + 1
}

sum_na_ya <- rep(0, length(files_na_ya))
max_na_ya <- rep(0, length(files_na_ya))
interpolated_sum_na_ya <- rep(0, length(files_na_ya))
interpolated_max_na_ya <- rep(0, length(files_na_ya))
total_distance_na_ya <- rep(0, length(files_na_ya))
overall_mean_na_ya <- rep(0, length(files_na_ya))

cumsum_na_ya <- rep(0, 1000)

count <- 1
for(i in files_na_ya) {
  distance_na_ya <- read.table(paste("data_na_ya/distance/distance_", i, ".dat", sep=""))[, 2]
  force_na_ya <- read.table(paste("data_na_ya/force/force_", i, ".dat", sep=""))[-1001, 2]
  
  interpolated_vector_na_ya <- rep(0, (length(force_na_ya)-2*interpolation_window))
  interpolated_distance_na_ya <- rep(0, (length(force_na_ya)-2*interpolation_window))
  
  for(j in (1+interpolation_window):(length(force_na_ya)-interpolation_window)) {
    interpolated_force_na_ya <- mean(force_na_ya[(j-interpolation_window):(j+interpolation_window)])
    interpolated_d_na_ya <- mean(distance_na_ya[(j-interpolation_window):(j+interpolation_window)])
    interpolated_vector_na_ya[j] <- interpolated_force_na_ya
    interpolated_distance_na_ya[j] <- interpolated_d_na_ya
  }
  
  overall_mean_na_ya[count] <- mean(force_na_ya)
  
  sum_na_ya[count] <- sum(force_na_ya) #* c(distance_na_ya[-1], length(distance_na_ya)) - distance_na_ya)
  max_na_ya[count] <- max(force_na_ya)
  interpolated_sum_na_ya[count] <- sum(interpolated_vector_na_ya) #  * c(interpolated_distance_na_ya[-1], length(interpolated_distance_na_ya)) - interpolated_distance_na_ya)
  interpolated_max_na_ya[count] <- max(interpolated_vector_na_ya)
  
  cumsum_na_ya <- cumsum_na_ya + cumsum(force_na_ya)
  total_distance_na_ya[count] <- sum(distance_na_ya)
  count <- count + 1
}

sum_nw <- rep(0, length(files_nw))
max_nw <- rep(0, length(files_nw))
interpolated_sum_nw <- rep(0, length(files_nw))
interpolated_max_nw <- rep(0, length(files_nw))
total_distance_nw <- rep(0, length(files_nw))
overall_mean_nw <- rep(0, length(files_nw))

cumsum_nw <- rep(0, 1000)

count <- 1
for(i in files_nw) {
  distance_nw <- read.table(paste("data_nw/distance/distance_", i, ".dat", sep=""))[, 2]
  force_nw <- read.table(paste("data_nw/force/force_", i, ".dat", sep=""))[-1001, 2]
  
  interpolated_vector_nw <- rep(0, (length(force_nw)-2*interpolation_window))
  interpolated_distance_nw <- rep(0, (length(force_nw)-2*interpolation_window))
  
  for(j in (1+interpolation_window):(length(force_nw)-interpolation_window)) {
    interpolated_force_nw <- mean(force_nw[(j-interpolation_window):(j+interpolation_window)])
    interpolated_d_nw <- mean(distance_nw[(j-interpolation_window):(j+interpolation_window)])
    interpolated_vector_nw[j] <- interpolated_force_nw
    interpolated_distance_nw[j] <- interpolated_d_nw
  }
  
  overall_mean_nw[count] <- mean(force_nw)
  
  sum_nw[count] <- sum(force_nw) #* c(distance_nw[-1], length(distance_nw)) - distance_nw)
  max_nw[count] <- max(force_nw)
  interpolated_sum_nw[count] <- sum(interpolated_vector_nw) #  * c(interpolated_distance_nw[-1], length(interpolated_distance_nw)) - interpolated_distance_nw)
  interpolated_max_nw[count] <- max(interpolated_vector_nw)
  
  cumsum_nw <- cumsum_nw + cumsum(force_nw)
  total_distance_nw[count] <- sum(distance_nw)
  count <- count + 1
}

sum_nw_ya <- rep(0, length(files_nw_ya))
max_nw_ya <- rep(0, length(files_nw_ya))
interpolated_sum_nw_ya <- rep(0, length(files_nw_ya))
interpolated_max_nw_ya <- rep(0, length(files_nw_ya))
total_distance_nw_ya <- rep(0, length(files_nw_ya))
overall_mean_nw_ya <- rep(0, length(files_nw_ya))

cumsum_nw_ya <- rep(0, 1000)

count <- 1
for(i in files_nw_ya) {
  distance_nw_ya <- read.table(paste("data_nw_ya/distance/distance_", i, ".dat", sep=""))[, 2]
  force_nw_ya <- read.table(paste("data_nw_ya/force/force_", i, ".dat", sep=""))[-1001, 2]
  
  interpolated_vector_nw_ya <- rep(0, (length(force_nw_ya)-2*interpolation_window))
  interpolated_distance_nw_ya <- rep(0, (length(force_nw_ya)-2*interpolation_window))
  
  for(j in (1+interpolation_window):(length(force_nw_ya)-interpolation_window)) {
    interpolated_force_nw_ya <- mean(force_nw_ya[(j-interpolation_window):(j+interpolation_window)])
    interpolated_d_nw_ya <- mean(distance_nw_ya[(j-interpolation_window):(j+interpolation_window)])
    interpolated_vector_nw_ya[j] <- interpolated_force_nw_ya
    interpolated_distance_nw_ya[j] <- interpolated_d_nw_ya
  }
  
  overall_mean_nw_ya[count] <- mean(force_nw_ya)
  
  sum_nw_ya[count] <- sum(force_nw_ya) #* c(distance_nw_ya[-1], length(distance_nw_ya)) - distance_nw_ya)
  max_nw_ya[count] <- max(force_nw_ya)
  interpolated_sum_nw_ya[count] <- sum(interpolated_vector_nw_ya) #  * c(interpolated_distance_nw_ya[-1], length(interpolated_distance_nw_ya)) - interpolated_distance_nw_ya)
  interpolated_max_nw_ya[count] <- max(interpolated_vector_nw_ya)
  
  cumsum_nw_ya <- cumsum_nw_ya + cumsum(force_nw_ya)
  total_distance_nw_ya[count] <- sum(distance_nw_ya)
  count <- count + 1
}

sum_yd <- rep(0, length(files_yd))
max_yd <- rep(0, length(files_yd))
interpolated_sum_yd <- rep(0, length(files_yd))
interpolated_max_yd <- rep(0, length(files_yd))
total_distance_yd <- rep(0, length(files_yd))
overall_mean_yd <- rep(0, length(files_yd))

cumsum_yd <- rep(0, 1000)

count <- 1
for(i in files_yd) {
  distance_yd <- read.table(paste("data_yd/distance/distance_", i, ".dat", sep=""))[, 2]
  force_yd <- read.table(paste("data_yd/force/force_", i, ".dat", sep=""))[-1001, 2]
  
  interpolated_vector_yd <- rep(0, (length(force_yd)-2*interpolation_window))
  interpolated_distance_yd <- rep(0, (length(force_yd)-2*interpolation_window))
  
  for(j in (1+interpolation_window):(length(force_yd)-interpolation_window)) {
    interpolated_force_yd <- mean(force_yd[(j-interpolation_window):(j+interpolation_window)])
    interpolated_d_yd <- mean(distance_yd[(j-interpolation_window):(j+interpolation_window)])
    interpolated_vector_yd[j] <- interpolated_force_yd
    interpolated_distance_yd[j] <- interpolated_d_yd
  }
  
  overall_mean_yd[count] <- mean(force_yd)
  
  sum_yd[count] <- sum(force_yd) #* c(distance_yd[-1], length(distance_yd)) - distance_yd)
  max_yd[count] <- max(force_yd)
  interpolated_sum_yd[count] <- sum(interpolated_vector_yd) #  * c(interpolated_distance_yd[-1], length(interpolated_distance_yd)) - interpolated_distance_yd)
  interpolated_max_yd[count] <- max(interpolated_vector_yd)
  
  cumsum_yd <- cumsum_yd + cumsum(force_yd)
  total_distance_yd[count] <- sum(distance_yd)
  count <- count + 1
}

sum_nk <- rep(0, length(files_nk))
max_nk <- rep(0, length(files_nk))
interpolated_sum_nk <- rep(0, length(files_nk))
interpolated_max_nk <- rep(0, length(files_nk))
total_distance_nk <- rep(0, length(files_nk))
overall_mean_nk <- rep(0, length(files_nk))

cumsum_nk <- rep(0, 1000)

count <- 1
for(i in files_nk) {
  distance_nk <- read.table(paste("data_nk/distance/distance_", i, ".dat", sep=""))[, 2]
  force_nk <- read.table(paste("data_nk/force/force_", i, ".dat", sep=""))[-1001, 2]
  
  interpolated_vector_nk <- rep(0, (length(force_nk)-2*interpolation_window))
  interpolated_distance_nk <- rep(0, (length(force_nk)-2*interpolation_window))
  
  for(j in (1+interpolation_window):(length(force_nk)-interpolation_window)) {
    interpolated_force_nk <- mean(force_nk[(j-interpolation_window):(j+interpolation_window)])
    interpolated_d_nk <- mean(distance_nk[(j-interpolation_window):(j+interpolation_window)])
    interpolated_vector_nk[j] <- interpolated_force_nk
    interpolated_distance_nk[j] <- interpolated_d_nk
  }
  
  overall_mean_nk[count] <- mean(force_nk)
  
  sum_nk[count] <- sum(force_nk) #* c(distance_nk[-1], length(distance_nk)) - distance_nk)
  max_nk[count] <- max(force_nk)
  interpolated_sum_nk[count] <- sum(interpolated_vector_nk) #  * c(interpolated_distance_nk[-1], length(interpolated_distance_nk)) - interpolated_distance_nk)
  interpolated_max_nk[count] <- max(interpolated_vector_nk)
  
  cumsum_nk <- cumsum_nk + cumsum(force_nk)
  total_distance_nk[count] <- sum(distance_nk)
  count <- count + 1
}

sum_yt <- rep(0, length(files_yt))
max_yt <- rep(0, length(files_yt))
interpolated_sum_yt <- rep(0, length(files_yt))
interpolated_max_yt <- rep(0, length(files_yt))
total_distance_yt <- rep(0, length(files_yt))
overall_mean_yt <- rep(0, length(files_yt))

cumsum_yt <- rep(0, 1000)

count <- 1
for(i in files_yt) {
  distance_yt <- read.table(paste("data_yt/distance/distance_", i, ".dat", sep=""))[, 2]
  force_yt <- read.table(paste("data_yt/force/force_", i, ".dat", sep=""))[-1001, 2]
  
  interpolated_vector_yt <- rep(0, (length(force_yt)-2*interpolation_window))
  interpolated_distance_yt <- rep(0, (length(force_yt)-2*interpolation_window))
  
  for(j in (1+interpolation_window):(length(force_yt)-interpolation_window)) {
    interpolated_force_yt <- mean(force_yt[(j-interpolation_window):(j+interpolation_window)])
    interpolated_d_yt <- mean(distance_yt[(j-interpolation_window):(j+interpolation_window)])
    interpolated_vector_yt[j] <- interpolated_force_yt
    interpolated_distance_yt[j] <- interpolated_d_yt
  }
  
  overall_mean_yt[count] <- mean(force_yt)
  
  sum_yt[count] <- sum(force_yt) #* c(distance_yt[-1], length(distance_yt)) - distance_yt)
  max_yt[count] <- max(force_yt)
  interpolated_sum_yt[count] <- sum(interpolated_vector_yt) #  * c(interpolated_distance_yt[-1], length(interpolated_distance_yt)) - interpolated_distance_yt)
  interpolated_max_yt[count] <- max(interpolated_vector_yt)
  
  #cumsum_yt <- cumsum_yt + cumsum(force_yt)
  total_distance_yt[count] <- sum(distance_yt)
  count <- count + 1
}

# print(t.test(interpolated_max_wt, interpolated_max_ya))
# print(t.test(interpolated_max_wt, interpolated_max_ra))
# print(t.test(interpolated_max_wt, interpolated_max_ra_ya))
# print(t.test(interpolated_max_wt, interpolated_max_na))
# print(t.test(interpolated_max_na, interpolated_max_na_ya))
# print(t.test(interpolated_max_na, interpolated_max_nw))
# print(t.test(interpolated_max_na, interpolated_max_nw_ya))

df <- data.frame(id=c(rep('awt', length(files_wt)), rep('eya', length(files_ya)), 
                      rep('hra', length(files_ra)), rep('kra_ya', length(files_ra_ya)), 
                      rep('bna', length(files_na)), rep('ina_ya', length(files_na_ya)),
                      rep('cnw', length(files_nw)), rep('jnw_ya', length(files_nw_ya)),
                      rep('fyd', length(files_yd)), rep('dnk', length(files_nk)),
                      rep('gyt', length(files_yt)) ), 
                 y1=c(overall_mean_wt, overall_mean_ya, 
                      overall_mean_ra, overall_mean_ra_ya, 
                      overall_mean_na, overall_mean_na_ya,
                      overall_mean_nw, overall_mean_nw_ya,
                      overall_mean_yd, overall_mean_nk,
                      overall_mean_yt), 
                 y2=c(interpolated_max_wt, interpolated_max_ya, 
                      interpolated_max_ra, interpolated_max_ra_ya, 
                      interpolated_max_na, interpolated_max_na_ya,
                      interpolated_max_nw, interpolated_max_nw_ya,
                      interpolated_max_yd, interpolated_max_nk,
                      interpolated_max_yt),
                 y3=c(interpolated_sum_wt, interpolated_sum_ya, 
                      interpolated_sum_ra, interpolated_sum_ra_ya, 
                      interpolated_sum_na, interpolated_sum_na_ya,
                      interpolated_sum_nw, interpolated_sum_nw_ya,
                      interpolated_sum_yd, interpolated_sum_nk,
                      interpolated_sum_yt))

bp.df <- data.frame(id=c(rep('WT', length(files_wt)), rep('N348A', length(files_ya)), 
                      rep('N348K', length(files_ra)), rep('N348W', length(files_ra_ya)), 
                      rep('R111A', length(files_na)), rep('Y211A', length(files_na_ya)),
                      rep('Y211D', length(files_nw)), rep('Y211T', length(files_nw_ya)),
                      rep('N348A/Y211A', length(files_yd)), rep('N348W/Y211A', length(files_nk)),
                      rep('vR111A/Y211A', length(files_yt)) ),
                 y2=c(interpolated_max_wt, interpolated_max_na, 
                      interpolated_max_nk, interpolated_max_nw, 
                      interpolated_max_ra, interpolated_max_ya,
                      interpolated_max_yd, interpolated_max_yt,
                      interpolated_max_na_ya, interpolated_max_nw_ya,
                      interpolated_max_ra_ya))

bp.df$id <- factor(bp.df$id, c('WT', 'N348A', 'N348K', 'N348W', 
                               'R111A', 'N348A/Y211A', 'vR111A/Y211A', 
                               'Y211D', 'Y211T', 'Y211A', 'N348W/Y211A'))
smd.boxplot(bp.df)

fit <- aov(y2 ~ id, data = df)
print(TukeyHSD(fit))

print(pairwise.t.test(df$y3, df$id, p.adjust.method="fdr"))




























# pub_df <- data.frame(id=c('WT','N348A','N348K','N348W','vR111A','Y211A',
#                           'Y211D','Y211T','N348A/Y211A','N348W/Y211A',
#                           'vR111A/Y211A'),
#                      maxforce=c(mean(interpolated_max_wt),
#                                 mean(interpolated_max_na),
#                                 mean(interpolated_max_nk),
#                                 mean(interpolated_max_nw),
#                                 mean(interpolated_max_ra),
#                                 mean(interpolated_max_ya),
#                                 mean(interpolated_max_yd),
#                                 mean(interpolated_max_yt),
#                                 mean(interpolated_max_na_ya),
#                                 mean(interpolated_max_nw_ya),
#                                 mean(interpolated_max_ra_ya)),
#                      maxforcesd=c(sd(interpolated_max_wt),
#                                   sd(interpolated_max_na),
#                                   sd(interpolated_max_nk),
#                                   sd(interpolated_max_nw),
#                                   sd(interpolated_max_ra),
#                                   sd(interpolated_max_ya),
#                                   sd(interpolated_max_yd),
#                                   sd(interpolated_max_yt),
#                                   sd(interpolated_max_na_ya),
#                                   sd(interpolated_max_nw_ya),
#                                   sd(interpolated_max_ra_ya)),
#                      auc=c(mean(interpolated_sum_wt),
#                            mean(interpolated_sum_na),
#                            mean(interpolated_sum_nk),
#                            mean(interpolated_sum_nw),
#                            mean(interpolated_sum_ra),
#                            mean(interpolated_sum_ya),
#                            mean(interpolated_sum_yd),
#                            mean(interpolated_sum_yt),
#                            mean(interpolated_sum_na_ya),
#                            mean(interpolated_sum_nw_ya),
#                            mean(interpolated_sum_ra_ya)),
#                      aucsd=c(sd(interpolated_sum_wt),
#                              sd(interpolated_sum_na),
#                              sd(interpolated_sum_nk),
#                              sd(interpolated_sum_nw),
#                              sd(interpolated_sum_ra),
#                              sd(interpolated_sum_ya),
#                              sd(interpolated_sum_yd),
#                              sd(interpolated_sum_yt),
#                              sd(interpolated_sum_na_ya),
#                              sd(interpolated_sum_nw_ya),
#                              sd(interpolated_sum_ra_ya))
# )

# # Power analysis stuff
# require(samplesize)
# require(pwr)
# 
# m <- c(mean(interpolated_sum_wt), mean(interpolated_sum_nk))
# s <- c(sd(interpolated_sum_wt), sd(interpolated_sum_nk))
# n <- c(length(files_wt),length(files_nk))
# 
# grand.sd <- function(S, M, N) {sqrt(weighted.mean(S^2 + M^2, N) - weighted.mean(M, N)^2)}
# 
# d <- abs(m[1] - m[2])/grand.sd(s, m, n)
# 
# pwr.t2n.test(n1 = n[1], n2 = n[2] , d = d)
# 
# n.ttest(power = 0.5, alpha = 0.05, mean.diff = (m[1] - m[2]), sd1=s[1], sd2=s[2])

# print(t.test(max_wt, max_ya))
# print(t.test(interpolated_sum_wt, interpolated_sum_ya))
# print(t.test(interpolated_max_wt, interpolated_max_ya))

# max_df <- data.frame(id=c(rep('WT', length(files_wt)), rep('Y211A', length(files_ya)), rep('R111A', length(files_ra))), 
#                      force=c(max_wt, max_ya, max_ra))
