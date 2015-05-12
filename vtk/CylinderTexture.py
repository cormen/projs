#!/usr/bin/env python
 
##
# This example shows how to apply an vtkImageData texture to an cylinder 
# vtkPolyData object.
# Note: Input jpg file can be located in the VTKData repository.
#
# @author JBallesteros
##
 
import vtk
 
jpegfile = "masonry-wide.jpg"
 
# Create a render window
ren = vtk.vtkRenderer()
renWin = vtk.vtkRenderWindow()
renWin.AddRenderer(ren)
renWin.SetSize(480,480)
iren = vtk.vtkRenderWindowInteractor()
iren.SetRenderWindow(renWin)
 
# Generate an cylinder polydata
cylinder = vtk.vtkCylinderSource()
cylinder.SetHeight(8)
cylinder.SetRadius(4)
cylinder.SetResolution(12)
 
# Read the image data from a file
reader = vtk.vtkJPEGReader()
reader.SetFileName(jpegfile)
 
# Create texture object
texture = vtk.vtkTexture()
if vtk.VTK_MAJOR_VERSION <= 5:
    texture.SetInput(reader.GetOutput())
else:
    texture.SetInputConnection(reader.GetOutputPort())
 
# Map texture coordinates
map_to_cylinder = vtk.vtkTextureMapToCylinder()
if vtk.VTK_MAJOR_VERSION <= 5:
    map_to_cylinder.SetInput(cylinder.GetOutput())
else:
    map_to_cylinder.SetInputConnection(cylinder.GetOutputPort())
map_to_cylinder.PreventSeamOn()
 
# Create mapper and set the mapped texture as input
mapper = vtk.vtkPolyDataMapper()
if vtk.VTK_MAJOR_VERSION <= 5:
    mapper.SetInput(map_to_cylinder.GetOutput())
else:
    mapper.SetInputConnection(map_to_cylinder.GetOutputPort())
 
# Create actor and set the mapper and the texture
actor = vtk.vtkActor()
actor.SetMapper(mapper)
actor.SetTexture(texture)
 
ren.AddActor(actor)
 
iren.Initialize()
renWin.Render()
iren.Start()
