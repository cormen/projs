package require vtk
package require vtkinteraction


vtkVolume16Reader reader
  reader SetDataDimensions 64 64
  reader SetDataByteOrderToLittleEndian
  reader SetFilePrefix  "Data/headsq/quarter"
  reader SetImageRange 1 93
  reader SetDataSpacing  3.2 3.2 1.5

# An isosurface, or contour value of 500 is known to correspond to the
# skin of the patient. An isosurface, or contour value of 1150 is known
# to correspond to the bone of the patient.

# An outline provides context around the data.
#
vtkOutlineFilter outlineData
  outlineData SetInputConnection [reader GetOutputPort]
vtkPolyDataMapper mapOutline
  mapOutline SetInputConnection [outlineData GetOutputPort]
vtkActor outline
  outline SetMapper mapOutline
  [outline GetProperty] SetColor 0 0 0


# Create transfer mapping scalar value to opacity
vtkPiecewiseFunction opacityTransferFunction
    opacityTransferFunction AddPoint   100   0.0
    opacityTransferFunction AddPoint   700   0.0
    opacityTransferFunction AddPoint   1200   1.0

# Create transfer mapping scalar value to color
vtkColorTransferFunction colorTransferFunction
    colorTransferFunction AddRGBPoint     0.0 0.0 0.0 0.0
    colorTransferFunction AddRGBPoint    1200 1.0 1.0 1.0

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
ren1 SetBackground 1 1 1
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



