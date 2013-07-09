setwd("~/Desktop/data")

for(i in 0:50) {
  distance <- read.table(paste("distances/distance_", i, ".dat", sep=""))[2]
  #force <- read.table(paste("forces/force_", i, ".dat", sep=""))[2]
}