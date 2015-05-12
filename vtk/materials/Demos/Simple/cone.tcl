package require vtk

#Create a Cone
vtkConeSource cone
   cone SetResolution 100

vtkPolyDataMapper coneMapper
   coneMapper SetInput [cone GetOutput]

vtkActor coneActor
   coneActor SetMapper coneMapper
   [coneActor GetProperty] SetColor 1.0 0.0 0.0


#Create Window and Renderer
vtkRenderWindow renWin
   renWin SetSize 500 500

vtkRenderer ren1
   ren1 SetBackground 0.0 0.0 0.0
   

ren1 AddActor coneActor
renWin AddRenderer ren1
renWin Render


#Supress the tk window
wm withdraw .


