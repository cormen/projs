package require vtk
package require vtkinteraction

vtkLookupTable lut
    lut SetNumberOfColors 256
    lut SetHueRange 0.0 0.667
    lut Build

vtkStructuredGridReader reader
    reader SetFileName "Data/density.vtk"
    reader Update

vtkHedgeHog hhog
   hhog SetInput [reader GetOutput]
   hhog SetScaleFactor 0.001
vtkPolyDataMapper hhogMapper
    hhogMapper SetInput [hhog GetOutput]
    hhogMapper SetLookupTable lut
    hhogMapper ScalarVisibilityOn
    eval hhogMapper SetScalarRange [[reader GetOutput] GetScalarRange]
vtkActor hhogActor
    hhogActor SetMapper hhogMapper

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
ren1 AddActor hhogActor
ren1 SetBackground 0.5 0.5 0.5
renWin SetSize 500 500

iren AddObserver UserEvent {wm deiconify .vtkInteract}
renWin Render

wm withdraw .
