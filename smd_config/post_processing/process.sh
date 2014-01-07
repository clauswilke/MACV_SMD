#!/bin/sh

for i in {0..49};
do
  FOL=run_$i
  if [ -d $FOL ]; 
  then
    SCP=post_processing.py
    cp $SCP $FOL
     
    cd $FOL
    
    python $SCP

    cp force*dat ../data/force/force_$i.dat
    cp distance*dat ../data/distance/distance_$i.dat

    cd ../
  fi
done
