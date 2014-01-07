#!/bin/bash

for i in {1..20};
do
  results="run_${i}"

  cp qsub_eq.sh qsub_eq_current.sh

  sed -i 's/unique_name/'$results'/g' qsub_eq_current.sh

  ./qsub_eq_current.sh
done
