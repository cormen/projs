package require vtk
package require vtkinteraction

vtkStructuredGridReader reader
    reader SetFileName "Data/density.vtk"
    reader Update

vtkPlane plane
vtkPlaneWidget planeWidget
    planeWidget SetInput [reader GetOutput]
    eval planeWidget SetOrigin [[reader GetOutput] GetCenter]
    planeWidget NormalToXAxisOn
    planeWidget SetRepresentationToOutline
    planeWidget PlaceWidget
    planeWidget GetPlane plane

vtkClipDataSet clip
    clip SetInputConnection [reader GetOutputPort]
    clip SetClipFunction plane
    clip InsideOutOn
vtkDataSetMapper clipMapper
    clipMapper SetInputConnection [clip GetOutputPort]
    eval clipMapper SetScalarRange [[reader GetOutput] GetScalarRange]
vtkLODActor clipActor
    clipActor SetMapper clipMapper
    clipActor VisibilityOn

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


planeWidget SetInteractor iren
planeWidget SetKeyPressActivationValue "x"
planeWidget AddObserver EndInteractionEvent myCallback

ren1 AddActor clipActor
ren1 AddActor outlineActor

ren1 SetBackground 0.5 0.5 0.5
renWin SetSize 500 500

iren AddObserver UserEvent {wm deiconify .vtkInteract}
iren Initialize
#renWin Render

wm withdraw .

proc myCallback {} {
    planeWidget GetPlane plane
    clipActor VisibilityOn
}


