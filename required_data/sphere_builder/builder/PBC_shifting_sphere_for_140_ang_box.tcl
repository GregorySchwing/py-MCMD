#**********************************
#This code centers the sphere in the center of the VMD box, so we can view it properly
#**********************************

set all [atomselect top all]
pbc set {140 140 140} -all
#pbc wrap -sel "all" -center com -centersel "index 0 to 8060" -shiftcenter {70 70 70} -all

$all moveby {70 70 70} 


$all writepdb 10_ang_sphere.pdb
$all writepsf 10_ang_sphere.psf
#**********************************
#**********************************
