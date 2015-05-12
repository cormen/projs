#!/usr/bin/env python
from vtk import *

renWin = vtkRenderWindow()
renWin.SetSize(600,300)
iren = vtk.vtkRenderWindowInteractor()
iren.SetRenderWindow(renWin)
 
ren1 = vtkRenderer()
ren1.SetViewport(0.0, 0.0, 0.5, 1.0)
ren1.SetBackground(0.8, 0.4, 0.2)
renWin.AddRenderer(ren1)
ren2 = vtkRenderer()
ren2.SetViewport(0.5, 0.0, 1.0, 1.0)
ren2.SetBackground(0.1, 0.2, 0.4)
renWin.AddRenderer(ren2)

iren.Initialize()
renWin.Render()
iren.Start()
