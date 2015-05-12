package require vtk
package require vtkinteraction

vtkStructuredGridReader reader
    reader SetFileName "Data/subset.vtk"
    reader Update

vtkContourFilter contour
    contour SetInputConnection [reader GetOutputPort]
    eval contour GenerateValues 10 [[reader GetOutput] GetScalarRange]
#    eval contour GenerateValues 10 .25 .30
vtkPolyDataMapper contourMapper
    contourMapper SetInputConnection [contour GetOutputPort]
    eval contourMapper SetScalarRange [[reader GetOutput] GetScalarRange]
vtkActor contourActor
    contourActor SetMapper contourMapper

vtkStructuredGridOutlineFilter outline
    outline SetInputConnection [reader GetOutputPort]
vtkPolyDataMapper outlineMapper
    outlineMapper SetInputConnection [outline GetOutputPort]
vtkActor outlineActor
    outlineActor SetMapper outlineMapper
    [outlineActor GetProperty] SetColor 0 0 0

vtkRenderer ren1
vtkRenderWindow renWin
    renWin AddRenderer ren1
vtkRenderWindowInteractor iren
    iren SetRenderWindow renWin

ren1 AddActor outlineActor
ren1 AddActor contourActor
ren1 SetBackground 1 1 1
renWin SetSize 500 500

iren AddObserver UserEvent {wm deiconify .vtkInteract}
renWin Render

wm withdraw .



