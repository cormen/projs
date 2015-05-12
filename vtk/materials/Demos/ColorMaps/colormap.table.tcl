package require vtk
package require vtkinteraction

vtkLookupTable lut
    lut SetNumberOfColors 256
    lut SetHueRange 0.0 0.667
    lut Build

vtkStructuredGridReader reader
    reader SetFileName "Data/subset.vtk"
    reader Update
vtkDataSetMapper mapper
    mapper SetInputConnection [reader GetOutputPort]
    mapper SetLookupTable lut
    eval mapper SetScalarRange [[reader GetOutput] GetScalarRange]
vtkActor actor
    actor SetMapper mapper

set red   {1.0 0.0 0.0}
set green {0.0 1.0 0.0}
set blue  {0.0 0.0 1.0}
set black {0.0 0.0 0.0}
set white {1.0 1.0 1.0}
set alpha 1

#for {set i 0} {$i<16} {incr i 1} {
#    eval lut SetTableValue [expr $i*16] $red $alpha
#    eval lut SetTableValue [expr $i*16+1] $green $alpha
#    eval lut SetTableValue [expr $i*16+2] $blue $alpha
#    eval lut SetTableValue [expr $i*16+3] $black $alpha

#    eval lut SetTableValue [expr $i*16]   $black $alpha
#    eval lut SetTableValue [expr $i*16+1] $black $alpha
#    eval lut SetTableValue [expr $i*16+2] $black $alpha
#    eval lut SetTableValue [expr $i*16+3] $black $alpha
#}

for {set i 0} {$i<63} {incr i 1} {
#    eval lut SetTableValue $i $black 0.0
    eval lut SetTableValue $i $black $alpha
#    eval lut SetTableValue $i $white $alpha
}

vtkRenderer ren1
vtkRenderWindow renWin
    renWin AddRenderer ren1
vtkRenderWindowInteractor iren
    iren SetRenderWindow renWin

ren1 AddActor actor
ren1 SetBackground 0.5 0.5 0.5
renWin SetSize 500 500

iren AddObserver UserEvent {wm deiconify .vtkInteract}
renWin Render

wm withdraw .



