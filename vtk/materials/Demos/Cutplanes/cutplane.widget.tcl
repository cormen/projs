package require vtk
package require vtkinteraction

vtkStructuredGridReader reader
    reader SetFileName "Data/density.vtk"
    reader Update

vtkPlaneWidget planeWidget
    planeWidget SetInput [reader GetOutput]
    eval planeWidget SetOrigin [[reader GetOutput] GetCenter]
    planeWidget NormalToXAxisOn
    planeWidget SetResolution 20
    planeWidget SetRepresentationToOutline
    planeWidget PlaceWidget
vtkPolyData plane
    planeWidget GetPolyData plane

vtkProbeFilter probe
    probe SetInput plane
    probe SetSource [reader GetOutput]

vtkPolyDataMapper contourMapper
    contourMapper SetInputConnection [probe GetOutputPort]
    eval contourMapper SetScalarRange [[reader GetOutput] GetScalarRange]
vtkActor contourActor
    contourActor SetMapper contourMapper
    contourActor VisibilityOff

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
planeWidget AddObserver EnableEvent BeginInteraction
planeWidget AddObserver StartInteractionEvent BeginInteraction
planeWidget AddObserver InteractionEvent ProbeData

ren1 AddActor outlineActor
ren1 AddActor contourActor

ren1 SetBackground 0.5 0.5 0.5
renWin SetSize 500 500

iren AddObserver UserEvent {wm deiconify .vtkInteract}
renWin Render

wm withdraw .

# Actually generate contour lines.
proc BeginInteraction {} {
    planeWidget GetPolyData plane
    contourActor VisibilityOn
}

proc ProbeData {} {
    planeWidget GetPolyData plane
}

