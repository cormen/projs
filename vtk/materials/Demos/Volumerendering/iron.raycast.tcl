package require vtk
package require vtkinteraction

vtkStructuredPointsReader reader
    reader SetFileName "Data/ironProt.vtk"

vtkPiecewiseFunction opacityTransferFunction
    opacityTransferFunction AddPoint  0   0.0
    opacityTransferFunction AddPoint  255  1.0

vtkColorTransferFunction colorTransferFunction
    colorTransferFunction AddRGBPoint      0.0 0.0 0.0 1.0
    colorTransferFunction AddRGBPoint    128.0 0.0 1.0 0.0
    colorTransferFunction AddRGBPoint    255.0 1.0 0.0 0.0

vtkVolumeProperty volumeProperty
    volumeProperty SetColor colorTransferFunction
    volumeProperty SetScalarOpacity opacityTransferFunction
    volumeProperty ShadeOn
    volumeProperty SetInterpolationTypeToLinear

vtkVolumeRayCastCompositeFunction  compositeFunction
vtkVolumeRayCastMapper volumeMapper
    volumeMapper SetVolumeRayCastFunction compositeFunction
    volumeMapper SetInputConnection [reader GetOutputPort]

vtkVolume volume
    volume SetMapper volumeMapper
    volume SetProperty volumeProperty

vtkRenderer ren1
vtkRenderWindow renWin
    renWin AddRenderer ren1
vtkRenderWindowInteractor iren
    iren SetRenderWindow renWin

ren1 AddVolume volume
ren1 SetBackground 0.5 0.5 0.5
renWin SetSize 500 500
renWin Render

proc TkCheckAbort {} {
  set foo [renWin GetEventPending]
  if {$foo != 0} {renWin SetAbortRender 1}
}
renWin AddObserver AbortCheckEvent {TkCheckAbort}

iren AddObserver UserEvent {wm deiconify .vtkInteract}
iren Initialize

wm withdraw .



