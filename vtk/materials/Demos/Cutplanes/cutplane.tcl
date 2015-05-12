package require vtk
package require vtkinteraction

vtkStructuredGridReader reader
    reader SetFileName "Data/density.vtk"
    reader Update

vtkPlane plane
    eval plane SetOrigin [[reader GetOutput] GetCenter]
    plane SetNormal -0.287 0 0.9579
#    plane SetNormal 1 0 0
#    plane SetNormal 0 1 0
#    plane SetNormal 0 0 1
vtkCutter planeCut
    planeCut SetInputConnection [reader GetOutputPort]
    planeCut SetCutFunction plane
vtkPolyDataMapper cutMapper
    cutMapper SetInputConnection [planeCut GetOutputPort]
    eval cutMapper SetScalarRange \
      [[[[reader GetOutput] GetPointData] GetScalars] GetRange]
vtkActor cutActor
    cutActor SetMapper cutMapper

vtkStructuredGridGeometryFilter compPlane
    compPlane SetInputConnection [reader GetOutputPort]
    compPlane SetExtent 0 56 0 32 7 7
vtkPolyDataMapper planeMapper
    planeMapper SetInputConnection [compPlane GetOutputPort]
    planeMapper ScalarVisibilityOff
vtkActor planeActor
    planeActor SetMapper planeMapper
    [planeActor GetProperty] SetRepresentationToWireframe
    [planeActor GetProperty] SetColor 0 0 0

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
ren1 AddActor planeActor
ren1 AddActor cutActor

ren1 SetBackground 0.5 0.5 0.5
renWin SetSize 500 500

iren Initialize

iren AddObserver UserEvent {wm deiconify .vtkInteract}

wm withdraw .



