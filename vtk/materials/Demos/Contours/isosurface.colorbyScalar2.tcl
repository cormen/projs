package require vtk
package require vtkinteraction

vtkStructuredGridReader reader
    reader SetFileName "Data/velocityMag.vtk"
    reader Update

vtkContourFilter iso
    iso SetInputConnection [reader GetOutputPort]
    iso SetValue 0 .26
#    iso SetValue 0 .30
#    iso SetValue 0 .51
#    iso SetValue 0 .61
vtkPolyDataMapper isoMapper
    isoMapper SetInputConnection [iso GetOutputPort]
    isoMapper ScalarVisibilityOn
    isoMapper SetScalarRange 0 779
    isoMapper SetScalarModeToUsePointFieldData
    isoMapper ColorByArrayComponent "VelocityMagnitude" 0


vtkActor isoActor
    isoActor SetMapper isoMapper

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
ren1 AddActor isoActor
ren1 SetBackground 0.5 0.5 0.5
renWin SetSize 500 500

iren AddObserver UserEvent {wm deiconify .vtkInteract}
renWin Render

wm withdraw .


