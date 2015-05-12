package require vtk
package require vtkinteraction

vtkStructuredGridReader reader
    reader SetFileName "Data/density.vtk"
    reader Update

vtkContourFilter iso
    iso SetInputConnection [reader GetOutputPort]
    iso SetValue 0 0.197813
vtkPolyDataMapper isoMapper
    isoMapper SetInputConnection [iso GetOutputPort]
    isoMapper ScalarVisibilityOn
    isoMapper SetScalarRange 0 390
    isoMapper SetScalarModeToUsePointFieldData
    isoMapper ColorByArrayComponent "Momentum" 0
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

##########################################
##Animation

[ren1 GetActiveCamera] SetPosition 6.48 -45.12 38.37
[ren1 GetActiveCamera] SetFocalPoint 8.26 0.0 29.76
[ren1 GetActiveCamera] SetViewUp 0 0 1

vtkWindowToImageFilter w2if
    w2if SetInput renWin
    w2if Update

set size 120
set minIso 0.197813
set maxIso 0.710419
set currentIso $minIso
set difference [expr "$maxIso - $minIso"]
set increment [expr "$difference / $size"]

iso SetValue 0 $currentIso

vtkJPEGWriter writer
    writer SetInputConnection [w2if GetOutputPort]
    writer SetFileName "movie.0000.jpg"
    writer SetQuality 100
    writer Write

for {set i 1} {$i <= $size} {incr i} {
    set currentIso [expr "$currentIso + $increment"]
    iso SetValue 0 $currentIso
    renWin Render

    w2if Modified

    if {$i < 10} {
        writer SetFileName "movie.000$i.jpg"
        writer Write
    } elseif {$i < 100} {
        writer SetFileName "movie.00$i.jpg"
        writer Write
    } elseif {$i < 1000} {
        writer SetFileName "movie.0$i.jpg"
        writer Write
    } else {
        writer SetFileName "movie.$i.jpg"
        writer Write
    }
}

wm withdraw .


