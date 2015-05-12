
cmake_minimum_required(VERSION 2.8)

PROJECT(TextureMapQuad)

find_package(VTK REQUIRED)
include(${VTK_USE_FILE})

add_executable(TextureMapQuad MACOSX_BUNDLE TextureMapQuad)

if(VTK_LIBRARIES)
  target_link_libraries(TextureMapQuad ${VTK_LIBRARIES})
else()
  target_link_libraries(TextureMapQuad vtkHybrid vtkWidgets)
endif()
