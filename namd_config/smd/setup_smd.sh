  smd_conf="wt_smd.namd"
  pull_directory="run_unique";
  smd_set="set_fixed_atom.tcl";
  qsub_file="qsub_smd_current.sh";  

  if [ -d "$pull_directory" ]; then
    
    if [ -f $pull_directory/$qsub_file ]; then
      rm $pull_directory/$qsub_file
    fi
    
    if [ -f $pull_directory/$smd_conf ]; then
      rm $pull_directory/$smd_conf
    fi
    
    if [ -f $pull_directory/$smd_set ]; then
      rm $pull_directory/$smd_set
    fi    

    cp $smd_conf  $pull_directory
    cp $qsub_file $pull_directory
    cp $smd_set   $pull_directory
    
    cd $pull_directory;

    sh execute_vmd.sh $smd_set

    ./$qsub_file;

    cd ../; 
  fi
