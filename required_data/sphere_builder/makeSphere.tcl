set r 50
set ratio [expr (sqrt(5)+1)*0.5]

package require psfgen
topology toppar_dum_noble_gases.str
segment GAS {
    auto none
    first NONE
    last NONE
    for {set res 1} {$res < [expr round($M_PI * pow($r,2) * 16 / 9 / sqrt(3))]} {incr res} {
        residue $res NE1
    }
}
writepsf sphere.psf
writepdb sphere.pdb
resetpsf
 
mol load psf sphere.psf pdb sphere.pdb
set all [atomselect top all]
set max [$all num]
for {set i 0} {$i<$max} {incr i} {
    set atom [atomselect top "index $i"]
    set theta [expr 2 * $M_PI * $i / $ratio]
    set phi [expr acos(1 - 2*($i+0.5)/$max)]
    $atom set x [expr cos($theta)*sin($phi)*$r]
    $atom set y [expr sin($theta)*sin($phi)*$r]
    $atom set z [expr cos($phi)*$r]
    $atom delete
}

$all writepdb sphere.pdb
$all delete
mol delete top
 
package require solvate
solvate sphere.psf sphere.pdb -minmax [list [vecscale $r {-1 -1 -1}] [vecscale $r {1 1 1}]]
 
mol load psf solvate.psf pdb solvate.pdb
set delO [atomselect top "oxygen and (x^2+y^2+z^2)>2500"]
set delseg [$delO get segid]
set delres [$delO get resid]
$delO delete
mol delete top
 
readpsf solvate.psf pdb solvate.pdb
foreach seg $delseg res $delres {delatom $seg $res}


writepsf drop.psf
writepdb drop.pdb


