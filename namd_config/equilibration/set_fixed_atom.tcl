            set mol1 [mol new wt_ionized.coor type pdb waitfor all]

            set allatoms [atomselect top all]
            $allatoms set beta 0
            set fixedatom [atomselect top "name CA and residue 1 58 73 to 83 96 136 137 138 161"]
            $fixedatom set beta 1
            $allatoms set occupancy 0

            set smdatom [atomselect top "name CA and residue 163 to 318"]

            $smdatom set occupancy 1

            $allatoms writepdb wt_ionized.ref
