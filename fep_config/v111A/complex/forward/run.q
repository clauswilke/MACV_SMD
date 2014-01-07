#!/bin/bash
#$ -cwd
#$ -V
#$ -S /bin/bash
#$ -N fep_pro
#$ -o 111A.log
#$ -e 111A.err
#$ -q normal
#$ -pe 12way 96
#$ -l h_rt=24:00:00
#$ -A A-bio7
env
ldd /opt/apps/intel11_1/mvapich2_1_6/namd/2.9/bin/namd2
/opt/apps/intel11_1/mvapich2_1_6/namd/2.9/bin/charmrun +p 96 /opt/apps/intel11_1/mvapich2_1_6/namd/2.9/bin/namd2 forward-on.namd
