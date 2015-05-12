package require vtk
package require vtkinteraction

vtkPolyDataReader hawaii
    hawaii SetFileName "Data/honolulu.vtk"
    hawaii Update
vtkElevationFilter elevation
    elevation SetInput [hawaii GetOutput]
    elevation SetLowPoint 0 0 0
    elevation SetHighPoint 0 0 1000
    elevation SetScalarRange 0 1000

vtkLookupTable lut
lut SetHueRange 0.7 0

vtkDataSetMapper hawaiiMapper
    hawaiiMapper SetInput [elevation GetOutput]
    hawaiiMapper SetScalarRange 0 1000
    hawaiiMapper SetLookupTable lut
    hawaiiMapper ImmediateModeRenderingOn

vtkActor hawaiiActor
    hawaiiActor SetMapper hawaiiMapper

vtkRenderer ren1
vtkRenderWindow renWin
    renWin AddRenderer ren1
vtkRenderWindowInteractor iren
    iren SetRenderWindow renWin

ren1 AddActor hawaiiActor
renWin SetSize 500 500
#renWin DoubleBufferOff
ren1 SetBackground 0.0 0.0 0.0

iren AddObserver UserEvent {wm deiconify .vtkInteract}
renWin Render

#renWin SetFileName "hawaii.tcl.ppm"
#renWin SaveImageAsPPM

wm withdraw .


