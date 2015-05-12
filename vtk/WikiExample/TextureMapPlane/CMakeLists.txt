
cmake_minimum_required(VERSION 2.8)

PROJECT(TextureMapPlane)

find_package(VTK REQUIRED)
include(${VTK_USE_FILE})

add_executable(TextureMapPlane MACOSX_BUNDLE TextureMapPlane)

if(VTK_LIBRARIES)
  target_link_libraries(TextureMapPlane ${VTK_LIBRARIES})
else()
  target_link_libraries(TextureMapPlane vtkHybrid vtkWidgets)
endif()
