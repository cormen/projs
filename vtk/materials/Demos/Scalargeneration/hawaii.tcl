package require vtk
package require vtkinteraction

vtkPolyDataReader hawaii
    hawaii SetFileName "Data/honolulu.vtk"
    hawaii Update

vtkPolyDataMapper hawaiiMapper
    hawaiiMapper SetInput [hawaii GetOutput]

vtkActor hawaiiActor
    hawaiiActor SetMapper hawaiiMapper

vtkRenderer ren1
vtkRenderWindow renWin
    renWin AddRenderer ren1
vtkRenderWindowInteractor iren
    iren SetRenderWindow renWin

ren1 AddActor hawaiiActor
renWin SetSize 1000 1000
ren1 SetBackground 0.0 0.0 0.0

iren AddObserver UserEvent {wm deiconify .vtkInteract}
renWin Render

#renWin SetFileName "hawaii.tcl.ppm"
#renWin SaveImageAsPPM

wm withdraw .


