package require autopsf
package require solvate
package require autoionize
package require Orient

namespace import Orient::orient

mol load pdb wt.pdb

set sel [atomselect top "all"]
set I [draw principalaxes $sel]

set A [orient $sel [lindex $I 2] {0 0 1}]
$sel move $A
set I [draw principalaxes $sel]

set A [orient $sel [lindex $I 2] {0.1 0 1}]
$sel move $A
set I [draw principalaxes $sel]

$sel writepdb wt_oriented.pdb

autopsf wt_oriented.pdb
solvate wt_autopsf.psf wt_autopsf.pdb -o wt_solvate -s WT -b 2.4 -x 5 -y 5 -z 5 +x 5 +y 5 +z 20

autoionize -psf wt_solvate.psf -pdb wt_solvate.pdb -o wt_ionized -sc 0.15

