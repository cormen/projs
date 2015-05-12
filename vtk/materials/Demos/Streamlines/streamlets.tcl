package require vtk
package require vtkinteraction

vtkStructuredGridReader reader
    reader SetFileName "Data/density.vtk"
    reader Update

vtkPointSource seeds
    seeds SetRadius 3.0
#    eval seeds SetCenter 1.5 0.01 27
    eval seeds SetCenter [[reader GetOutput] GetCenter]
    seeds SetNumberOfPoints 50

vtkLineSource rake
  rake SetPoint1 0 -5.66 23.3
  rake SetPoint2 16.5 5.66 36.2
  rake SetResolution 10

vtkRungeKutta4 integ

vtkStreamTracer streamer
    streamer SetInputConnection  [reader GetOutputPort]
#    streamer SetSourceConnection [rake GetOutputPort]
    streamer SetSourceConnection [seeds GetOutputPort]
    streamer SetMaximumPropagation 100
    streamer SetMaximumPropagationUnitToTimeUnit
    streamer SetInitialIntegrationStepUnitToCellLengthUnit
    streamer SetInitialIntegrationStep 0.1
    streamer SetIntegrationDirectionToBoth
    streamer SetIntegrator integ

vtkConeSource cone
    cone SetResolution 8
vtkGlyph3D cones
    cones SetInputConnection [streamer GetOutputPort]
    cones SetSource [cone GetOutput]
    cones SetScaleFactor 0.1
    cones OrientOff
    cones SetVectorModeToUseVector
vtkPolyDataMapper mapCones
    mapCones SetInputConnection [cones GetOutputPort]
    eval mapCones SetScalarRange [[reader GetOutput] GetScalarRange]
vtkActor conesActor
    conesActor SetMapper mapCones

vtkStructuredGridOutlineFilter outline
    outline SetInputConnection [reader GetOutputPort]
vtkPolyDataMapper mapOutline
    mapOutline SetInputConnection [outline GetOutputPort]
vtkActor outlineActor
    outlineActor SetMapper mapOutline


vtkRenderer ren1
vtkRenderWindow renWin
    renWin AddRenderer ren1
vtkRenderWindowInteractor iren
    iren SetRenderWindow renWin

ren1 AddActor conesActor
ren1 AddActor outlineActor
ren1 SetBackground 0.5 0.5 0.5

renWin SetSize 500 500


iren AddObserver UserEvent {wm deiconify .vtkInteract}
iren Initialize

wm withdraw .

