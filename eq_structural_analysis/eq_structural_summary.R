setwd('~/MolecularDynamics/3kas_hrothgar_eq/')

list.dirs <- function(path=".", pattern=NULL, all.dirs=FALSE,
                      full.names=FALSE, ignore.case=FALSE) {
  
  all <- list.files(path, pattern, all.dirs,
                    full.names, recursive=FALSE, ignore.case)
  all[file.info(all)$isdir]
}

folders <- list.dirs()
folders <- folders[-8]
folders <- folders[-10]

frames <- dim(read.table(paste(folders[1],'/structural_analysis/rmsd_mean.txt',sep='')))[1]
atoms <- dim(read.table(paste(folders[1],'/structural_analysis/rmsf_mean.txt',sep='')))[1]
rmsd.data <- data.frame(matrix(ncol = length(folders), nrow=frames))
rmsf.data <- data.frame(matrix(ncol = length(folders), nrow=atoms))
colnames(rmsd.data) <- folders
colnames(rmsf.data) <- folders

for(folder in folders){
  rmsd.data[[folder]] <- read.table(paste(folder,'/structural_analysis/rmsd_mean.txt',sep=''))[,1]
  rmsf.data[[folder]] <- read.table(paste(folder,'/structural_analysis/rmsf_mean.txt',sep=''))[,1]
}

pdf('structural_analysis/rmsds.pdf', width=12, height=11, useDingbats=F)
par(mgp=c(5.5,1.5,0))
par(mar=c(7,8,1,1))
par(oma=c(0,0,0,0))

plot(rmsd.data[,1],
     type='l', 
     lwd=3,
     ylim=c(0.6, 1.5),
     xlab='Frames',
     ylab='RMSD (Angstroms)',
     axes=F,
     xaxt="n",
     yaxt="n",
     cex.lab=3)

axis(1,
     col.axis="black",
     lwd=4,
     at=seq(0,2000,200),
     line=1.0,
     tck=0.01,
     cex.axis=3)

axis(2,
     col.axis='black',
     at=c(0.6, 0.8, 1.0, 1.2, 1.4, 1.6),
     lwd=4,
     line=-.6,
     tck=0.01,
     las=1,
     cex.axis=3)

lines(rmsd.data[,2], col='red', lwd='3')
lines(rmsd.data[,3], col='blue', lwd='3')
lines(rmsd.data[,4], col='darkcyan', lwd='3')
lines(rmsd.data[,5], col='forestgreen', lwd='3')
lines(rmsd.data[,6], col='purple', lwd='3')
lines(rmsd.data[,7], col='orange', lwd='3')
lines(rmsd.data[,8], col='brown', lwd='3')
lines(rmsd.data[,9], col='coral', lwd='3')
lines(rmsd.data[,10], col='darkblue', lwd='3')
lines(rmsd.data[,11], col='darkred', lwd='3')
dev.off()

pdf('structural_analysis/rmsfs.pdf', width=12, height=11, useDingbats=F)
par(mgp=c(5.5,1.5,0))
par(mar=c(7,8,1,1))
par(oma=c(0,0,0,0))

plot(rmsf.data[,1],
     type='l', 
     lwd=3,
     ylim=c(0.4, 2.9),
     xlim=c(0, 315),
     xlab='Index',
     ylab='RMSF (Angstroms)',
     axes=F,
     xaxt="n",
     yaxt="n",
     cex.lab=3)

axis(1,
     col.axis="black",
     at=seq(0,350,50),
     line=1.0,
     lwd=4,
     tck=0.01,
     cex.axis=3)

axis(2,
     col.axis='black',
     at=c(seq(0.4,10,0.4)),
     line=-.6,
     lwd=4,
     tck=0.01,
     las=1,
     cex.axis=3)

lines(rmsf.data[,2], col='red', lwd='3')
lines(rmsf.data[,3], col='blue', lwd='3')
lines(rmsf.data[,4], col='darkcyan', lwd='3')
lines(rmsf.data[,5], col='forestgreen', lwd='3')
lines(rmsf.data[,6], col='purple', lwd='3')
lines(rmsf.data[,7], col='orange', lwd='3')
lines(rmsf.data[,8], col='brown', lwd='3')
lines(rmsf.data[,9], col='coral', lwd='3')
lines(rmsf.data[,10], col='darkblue', lwd='3')
lines(rmsf.data[,11], col='darkred', lwd='3')
dev.off()
