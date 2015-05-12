package require vtk
package require vtkinteraction

vtkStructuredGridReader reader
    reader SetFileName "Data/density.vtk"
    reader Update

vtkLineSource rake
  rake SetPoint1 15 -5 32
  rake SetPoint2 15 5 32
  rake SetResolution 21
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

#
# The ruled surface filter stiches together lines with triangle strips.
# Note the SetOnRatio method. It turns on every other strip that
# the filter generates (only when multiple lines are input).
#
vtkRuledSurfaceFilter scalarSurface
  scalarSurface SetInputConnection [streamer GetOutputPort]
  scalarSurface SetOffset 0 
  scalarSurface SetOnRatio 2 
  scalarSurface PassLinesOn
  scalarSurface SetRuledModeToPointWalk
  scalarSurface SetDistanceFactor 30 
vtkPolyDataMapper mapper
  mapper SetInputConnection [scalarSurface GetOutputPort]
  eval mapper SetScalarRange [[reader GetOutput] GetScalarRange]
vtkActor actor
  actor SetMapper mapper 

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

ren1 AddActor actor 
ren1 AddActor outlineActor 
ren1 SetBackground 0.5 0.5 0.5

renWin SetSize 500 500

iren AddObserver UserEvent {wm deiconify .vtkInteract}
iren Initialize

wm withdraw .

