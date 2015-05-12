
cmake_minimum_required(VERSION 2.8)

PROJECT(BackgroundTexture)

find_package(VTK REQUIRED)
include(${VTK_USE_FILE})

add_executable(BackgroundTexture MACOSX_BUNDLE BackgroundTexture)

if(VTK_LIBRARIES)
  target_link_libraries(BackgroundTexture ${VTK_LIBRARIES})
else()
  target_link_libraries(BackgroundTexture vtkHybrid vtkWidgets)
endif()
