package require vtk
package require vtkinteraction

vtkLookupTable lut
    lut SetNumberOfColors 256
    lut SetHueRange 0.0 0.667
    lut Build

vtkStructuredGridReader reader
    reader SetFileName "Data/density.vtk"
    reader Update


vtkExtractGrid extract
    extract SetInputConnection [reader GetOutputPort]
#    extract SetVOI -1000 1000 -1000 1000 7 7
    extract SetVOI  0 56 0 32 7 9
#    extract SetVOI  0 56 0 32 7 7
    extract SetSampleRate 1 1 1
    extract IncludeBoundaryOn
vtkDataSetMapper mapper
    mapper SetInputConnection [extract GetOutputPort]
    mapper SetLookupTable lut
    mapper ScalarVisibilityOn
    eval mapper SetScalarRange [[reader GetOutput] GetScalarRange]
vtkActor actor
    actor SetMapper mapper



vtkExtractGrid extract2
    extract2 SetInputConnection [reader GetOutputPort]
#    extract2 SetVOI -1000 1000 -1000 1000 7 7
    extract2 SetVOI  0 56 15 17 0 24
#    extract2 SetVOI  0 56 16 16 0 24
    extract2 SetSampleRate 1 1 1
    extract2 IncludeBoundaryOn
vtkDataSetMapper mapper2
    mapper2 SetInputConnection [extract2 GetOutputPort]
    mapper2 SetLookupTable lut
    mapper2 ScalarVisibilityOn
    eval mapper2 SetScalarRange [[reader GetOutput] GetScalarRange]
vtkActor actor2
    actor2 SetMapper mapper2

vtkStructuredGridOutlineFilter outline
    outline SetInputConnection [reader GetOutputPort]
vtkPolyDataMapper outlineMapper
    outlineMapper SetInputConnection [outline GetOutputPort]
vtkActor outlineActor
    outlineActor SetMapper outlineMapper

vtkRenderer ren1
vtkRenderWindow renWin
    renWin AddRenderer ren1
vtkRenderWindowInteractor iren
    iren SetRenderWindow renWin

ren1 AddActor outlineActor
ren1 AddActor actor
ren1 AddActor actor2
ren1 SetBackground 0.5 0.5 0.5
renWin SetSize 500 500

iren AddObserver UserEvent {wm deiconify .vtkInteract}
renWin Render

wm withdraw .



