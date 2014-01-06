set mol1 [mol new wt_ionized.coor type pdb waitfor all]

set allatoms [atomselect top all]
$allatoms set beta 0
set fixedatom [atomselect top "name CA and segname P1"]
$fixedatom set beta 1
$allatoms set occupancy 0

set smdatom [atomselect top "name CA and segname P2 P3 P4 P5 P6 P7 P8"]

$smdatom set occupancy 1

$allatoms writepdb wt_ionized.ref
