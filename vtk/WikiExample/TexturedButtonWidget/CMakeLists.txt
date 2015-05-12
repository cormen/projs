
cmake_minimum_required(VERSION 2.8)

PROJECT(TexturedButtonWidget)

find_package(VTK REQUIRED)
include(${VTK_USE_FILE})

add_executable(TexturedButtonWidget MACOSX_BUNDLE TexturedButtonWidget)

if(VTK_LIBRARIES)
  target_link_libraries(TexturedButtonWidget ${VTK_LIBRARIES})
else()
  target_link_libraries(TexturedButtonWidget vtkHybrid vtkWidgets)
endif()
