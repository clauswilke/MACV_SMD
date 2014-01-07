SMD Pipeline

System setup
1. The SMD pipeline begins by making a mutation in the pdb.  We used pymol for this purpose, but in principle even a text editor could be used.  For this project, all of the mutations performed in the manuscript are provided in the structures folder.  The 3KAS.pdb is the full length parent structure.  Each structure with the word 'mini' in it is a reduced structure as in the paper. The mutant names should be otherwise fairly obvious from the paper.

2. To model the system, one would select the starting structure.  Then, that structure would be copied to the system_setup folder.  As the model_setup.tcl script is written, required the name of the structure file to be 'wt.pdb'.  Assuming the VMD Orient package requirements and VMD itself are installed, one needs to only run the following command model the system:

./execute_vmd.sh model_setup.tcl

3. The final oriented, solvated, neutralized, and ionized system will be called wt_ionized.pdb and the connectivity will be called wt_ionized.psf.

Equilibration
4. To equilibrate the generated system, one should move the wt_ionized.pdb and wt_ionized.psf files to the equilibration folder.

5. Next, the following commands should be run to generate the constraint and fixed backbone reference files:

./execute_vmd.sh set_constraints.tcl
./execute_vmd.sh set_fixed_back.tcl

This generate the restraint.pdb and fixed_back.ref files

6. Then, one should run the following command to get the system dimensions and center of mass:

./execute_vmd.sh get_dimensions.tcl

The output looks a little obscure, but the desire output will be near the bottom.  It will have three floating point number each with their own line followed by three space delimited floating numbers on a single line.  The three numbers arranged vertically are the x, y, and z box lengths, and the three horizontally arranged numbers are the x, y, and z coordinates of the system's center of mass.

7. To actually make this run on a particular cluster will require extensive editing of the qsub_eq.sh file (unless you are using Texas Tech's hrothgar cluster).  To run equilibration, one would simply use the following command:

./job.sh

Pulling
8. After equilibration, one should copy all 20 of the generated run_* folders into the smd folder.

9. Again, using this pipeline will require editing qsub_smd.sh in a manner similar to the qsub_eq.sh file.

10. Finally, to run SMD, one will run the following command:

python go.py

Post processing

11. The amount of data generated should be very large so moving it into the directory with the post processing scripts will likely be impractical.  Thus, copy the post_processing.py and process.sh files into the smd working directory.

12. Make directories within the smd working directory called "data/force" and "data/distance".  To run processing in place, run the following command.

./process.sh

13. The final force and distance data should be copied back to the data directories for later analysis.

14. After this step, the data has been provided along with the all_analysis.R script that will analyze it in one step and output most of the figures.
