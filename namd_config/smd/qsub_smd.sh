#!/bin/csh

# Create Working Directory
set WDIR = $RESULTS/wt_pro/unique_name
set FDIR = `pwd`

if ( -d $WDIR ) then
  rm -r $WDIR
endif

mkdir -p $WDIR

if ( ! -d $WDIR ) then
  echo $WDIR not created
  exit
endif

cd $WDIR

# Copy Data and Config Files
cp $FDIR/* .

set MPIRUN = /lustre/work/apps/openmpi/bin/mpirun
set NAMD2  = /lustre/work/apps/NAMD_2.9b3_Source/Linux-x86_64-icc/namd2

## qsub << ENDINPUT

echo '#\!/bin/bash' > run.q
echo '#$ -cwd' >> run.q
echo '#$ -V' >> run.q
echo '#$ -S /bin/bash' >> run.q
echo '#$ -N hum_smd' >> run.q
echo '#$ -j y' >> run.q
echo '#$ -o wt_smd.log' >> run.q
echo '#$ -e wt_smd.err' >> run.q
echo '#$ -q normal' >> run.q
echo '#$ -pe fill 60' >> run.q
echo '#$ -P hrothgar\n' >> run.q

echo '# Command to run\n' >> run.q
echo 'unset SGE_ROOT\n' >> run.q

echo 'ldd /lustre/work/apps/NAMD_2.9b3_Source/Linux-x86_64-icc/namd2\n' >> run.q

echo  $MPIRUN -np 60 -machinefile 'machinefile.$JOB_ID' $NAMD2 wt_smd.namd >> run.q

qsub run.q

#ENDINPUT

