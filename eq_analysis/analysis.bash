#!/bin/bash

for i in {1..20};
do
  folder=run_$i;
  
  mkdir $folder;
  cd $folder;

  calculate_structural_quantities.py ../../$folder/mt_ionized.pdb ../../$folder/mt_ionized.dcd 5 1005 1

  cd ../;
done
