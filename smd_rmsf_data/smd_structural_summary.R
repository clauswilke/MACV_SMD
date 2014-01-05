setwd('~/Desktop/MACV_SMD/smd_rmsf_data/data/')

files <- list.files()

atoms <- dim(read.table(paste(files[1])))[1]

rmsf.data <- data.frame(matrix(ncol = length(files), nrow=atoms))

colnames(rmsf.data) <- files

for(file in files){
  rmsf.data[[file]] <- read.table(paste(file))[,1]
}

smd.rmsf <- rowMeans(rmsf.data)
eq.rmsf <- read.table('../eq_wt_rmsf.dat')[,1]

pdf('../rmsf_comparison.pdf', width=12, height=11, useDingbats=F)
par(mgp=c(5.5,1.5,0))
par(mar=c(7,8,1,1))
par(oma=c(0,0,0,0))

plot(eq.rmsf[1:160],
     type='l', 
     lwd=3,
     ylim=c(0.4, 2.2),
     xlim=c(0, 165),
     xlab='Index',
     ylab='RMSF (Angstroms)',
     axes=F,
     xaxt="n",
     yaxt="n",
     cex.lab=3)

axis(1,
     col.axis="black",
     at=seq(0,350,25),
     line=1.0,
     lwd=4,
     tck=0.01,
     cex.axis=3)

axis(2,
     col.axis='black',
     at=c(seq(0.4,20,0.4)),
     line=-.6,
     lwd=4,
     tck=0.01,
     las=1,
     cex.axis=3)

lines(smd.rmsf[1:160], col='red', lwd='3')
dev.off()
