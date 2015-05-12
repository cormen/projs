package require vtk
package require vtkinteraction

vtkLookupTable lut
    lut SetNumberOfColors 256
    lut SetHueRange 0.0 0.667
#    lut SetHueRange 0.0 1.0
#    lut SetHueRange 0.667 0.0
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



