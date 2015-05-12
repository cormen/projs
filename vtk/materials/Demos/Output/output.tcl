package require vtk
package require vtkinteraction

vtkStructuredGridReader reader
    reader SetFileName "Data/density.vtk"
    reader Update

vtkPointSource seeds
    seeds SetRadius 1.0
    eval seeds SetCenter 1.5 0.01 27
    seeds SetNumberOfPoints 50

vtkRungeKutta4 integ

vtkStreamTracer streamer
    streamer SetInputConnection  [reader GetOutputPort]
    streamer SetSourceConnection [seeds GetOutputPort]
    streamer SetMaximumPropagation 100
    streamer SetMaximumPropagationUnitToTimeUnit
    streamer SetInitialIntegrationStepUnitToCellLengthUnit
    streamer SetInitialIntegrationStep 0.1
    streamer SetIntegrationDirectionToBoth
    streamer SetIntegrator integ

vtkTubeFilter streamTube
    streamTube SetInputConnection [streamer GetOutputPort]
    streamTube SetRadius 0.01
    streamTube SetNumberOfSides 6
    streamTube SetVaryRadiusToVaryRadiusByScalar
vtkPolyDataMapper mapStreamTube
    mapStreamTube SetInputConnection [streamTube GetOutputPort]
    eval mapStreamTube SetScalarRange \
       [[[[reader GetOutput] GetPointData] GetScalars] GetRange]
vtkActor streamTubeActor
    streamTubeActor SetMapper mapStreamTube

vtkStructuredGridOutlineFilter outline
  outline SetInputConnection [reader GetOutputPort]
vtkPolyDataMapper outlineMapper
  outlineMapper SetInputConnection [outline GetOutputPort]
vtkActor outlineActor
  outlineActor SetMapper outlineMapper 

vtkRenderer ren1
vtkRenderWindow renWin
#    renWin SetAAFrames 4
    renWin PointSmoothingOn
    renWin LineSmoothingOn
    renWin PolygonSmoothingOn
    renWin AddRenderer ren1

vtkRenderWindowInteractor iren
    iren SetRenderWindow renWin

ren1 AddActor streamTubeActor
ren1 AddActor outlineActor 
ren1 SetBackground 0.5 0.5 0.5

renWin SetSize 500 500
#renWin OffScreenRenderingOn


iren AddObserver UserEvent {wm deiconify .vtkInteract}
wm withdraw .

#[ren1 GetActiveCamera] SetPosition -40 0 30
#[ren1 GetActiveCamera] SetFocalPoint 0 0 0
#[ren1 GetActiveCamera] SetViewUp 0 1 0
ren1 ResetCamera
[ren1 GetActiveCamera] Dolly 1.25
ren1 ResetCameraClippingRange
renWin Render

vtkWindowToImageFilter w2if
    w2if SetInput renWin
    w2if Update

vtkRenderLargeImage renderLarge
    renderLarge SetInput ren1
    renderLarge SetMagnification 4


#vtkJPEGWriter writer
#    writer SetInputConnection [w2if GetOutputPort]
#    writer SetFileName "image.jpg"
#    writer SetQuality 100
#    writer Write

#vtkPNGWriter writer
#    writer SetInputConnection [w2if GetOutputPort]
#    writer SetFileName "image.png"
#    writer Write

#vtkPostScriptWriter writer
#    writer SetInputConnection [w2if GetOutputPort]
#    writer SetFileName "image.ps"
#    writer Write

#vtkTIFFWriter writer
#    writer SetInputConnection [w2if GetOutputPort]
#    writer SetFileName "image.tif"
#    writer Write

vtkTIFFWriter writer
    writer SetInputConnection [renderLarge GetOutputPort]
    writer SetFileName "largeimage.tif"
    writer Write

#exit

