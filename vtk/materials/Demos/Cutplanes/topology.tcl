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
    extract SetVOI -1000 1000 -1000 1000 7 10
    extract SetSampleRate 1 1 1
    extract IncludeBoundaryOn
vtkExtractEdges edge
    edge SetInputConnection [extract GetOutputPort]
vtkPolyDataMapper mapEdges
    mapEdges SetInputConnection [edge GetOutputPort]
    eval mapEdges SetScalarRange \
      [[[[reader GetOutput] GetPointData] GetScalars] GetRange]
#    mapEdges ScalarVisibilityOff
vtkActor edgeActor
    edgeActor SetMapper mapEdges


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
ren1 AddActor edgeActor
ren1 SetBackground 0.5 0.5 0.5
renWin SetSize 500 500

iren AddObserver UserEvent {wm deiconify .vtkInteract}
renWin Render

wm withdraw .



