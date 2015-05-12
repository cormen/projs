package require vtk
package require vtkinteraction

vtkStructuredGridReader reader
    reader SetFileName "Data/density.vtk"
    reader Update

vtkLineSource rake
  rake SetPoint1 0 -5.66 23.3
  rake SetPoint2 16.5 5.66 36.2
  rake SetResolution 100
vtkPolyDataMapper rakeMapper
  rakeMapper SetInputConnection [rake GetOutputPort]
vtkActor rakeActor
  rakeActor SetMapper rakeMapper

vtkRungeKutta4 integ

vtkStreamTracer streamer
    streamer SetInputConnection  [reader GetOutputPort]
    streamer SetSourceConnection [rake GetOutputPort]
    streamer SetMaximumPropagation 100
    streamer SetMaximumPropagationUnitToTimeUnit
    streamer SetInitialIntegrationStepUnitToCellLengthUnit
    streamer SetInitialIntegrationStep 0.1
    streamer SetIntegrationDirectionToBoth
    streamer SetIntegrator integ

vtkTubeFilter streamTube
    streamTube SetInputConnection [streamer GetOutputPort]
    streamTube SetRadius 0.05
    streamTube SetNumberOfSides 6
    streamTube SetVaryRadiusToVaryRadiusOff
vtkPolyDataMapper mapStreamTube
    mapStreamTube SetInputConnection [streamTube GetOutputPort]
    eval mapStreamTube SetScalarRange \
       [[[[reader GetOutput] GetPointData] GetScalars] GetRange]
vtkActor streamTubeActor
    streamTubeActor SetMapper mapStreamTube
    [streamTubeActor GetProperty] BackfaceCullingOn

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

ren1 AddActor rakeActor 
ren1 AddActor streamTubeActor
ren1 AddActor outlineActor 
ren1 SetBackground 0.5 0.5 0.5

renWin SetSize 500 500

iren AddObserver UserEvent {wm deiconify .vtkInteract}
iren Initialize

wm withdraw .

