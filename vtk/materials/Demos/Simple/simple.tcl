package require vtk

#Create Window and Renderer
vtkRenderWindow renWin
   renWin SetSize 500 500

vtkRenderer ren1
   ren1 SetBackground 0.0 0.0 1.0
   
renWin AddRenderer ren1
renWin Render

#Supress the tk window
wm withdraw .



