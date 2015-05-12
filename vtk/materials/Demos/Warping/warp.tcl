package require vtk
package require vtkinteraction

vtkStructuredGridReader reader
    reader SetFileName "Data/density.vtk"
    reader Update

vtkStructuredGridGeometryFilter plane
    plane SetInputConnection [reader GetOutputPort]
    plane SetExtent 10 10 1 100 1 100
vtkStructuredGridGeometryFilter plane2
    plane2 SetInputConnection [reader GetOutputPort]
    plane2 SetExtent 30 30 1 100 1 100
vtkStructuredGridGeometryFilter plane3
    plane3 SetInputConnection [reader GetOutputPort]
    plane3 SetExtent 45 45 1 100 1 100

vtkAppendPolyData appendF
    appendF AddInputConnection [plane GetOutputPort]
    appendF AddInputConnection [plane2 GetOutputPort]
    appendF AddInputConnection [plane3 GetOutputPort]
vtkWarpScalar warp
    warp SetInputConnection [appendF GetOutputPort]
    warp UseNormalOn
    warp SetNormal 1.0 0.0 0.0
    warp SetScaleFactor 5.0
vtkPolyDataNormals normals
    normals SetInputConnection [warp GetOutputPort]
    normals SetFeatureAngle 60
vtkPolyDataMapper planeMapper
    planeMapper SetInputConnection [normals GetOutputPort]
    eval planeMapper SetScalarRange [[reader GetOutput] GetScalarRange]
vtkActor planeActor
    planeActor SetMapper planeMapper

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
ren1 AddActor planeActor
ren1 SetBackground 0.5 0.5 0.5

renWin SetSize 500 500

iren AddObserver UserEvent {wm deiconify .vtkInteract}
renWin Render

wm withdraw .



