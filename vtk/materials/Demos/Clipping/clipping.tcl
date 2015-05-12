package require vtk
package require vtkinteraction
package require vtktesting

vtkStructuredGridReader reader
    reader SetFileName "Data/density.vtk"
    reader Update

vtkPlane plane
    eval plane SetOrigin [[reader GetOutput] GetCenter]
    plane SetNormal -0.287 0 0.9579

vtkSphere sphere
    eval sphere SetCenter [[reader GetOutput] GetCenter]
    sphere SetRadius 5.0

vtkClipDataSet clip
    clip SetInputConnection [reader GetOutputPort]
    clip SetClipFunction plane
#    clip SetClipFunction sphere
#    clip InsideOutOff
    clip InsideOutOn
vtkDataSetMapper clipMapper
    clipMapper SetInputConnection [clip GetOutputPort]
    eval clipMapper SetScalarRange [[reader GetOutput] GetScalarRange]
vtkActor clipActor
    clipActor SetMapper clipMapper

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

ren1 AddActor clipActor
ren1 AddActor outlineActor

ren1 SetBackground 0.5 0.5 0.5
renWin SetSize 500 500

iren AddObserver UserEvent {wm deiconify .vtkInteract}
renWin Render

wm withdraw .
