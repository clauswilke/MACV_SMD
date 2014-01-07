set mol1 [mol new wt_ionized.pdb type pdb waitfor all]

set all [atomselect top "all"]
set sel [atomselect top "name CA and residue 41 to 92"]

$all set beta 0.0
$sel set beta 1.0

$all writepdb restraint.pdb 
