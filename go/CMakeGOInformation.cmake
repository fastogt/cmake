if(NOT CMAKE_GO_COMPILE_OBJECT)
  set(CMAKE_GO_COMPILE_OBJECT "go tool compile -l -N -o <OBJECT> <SOURCE> ")
endif()

if(NOT CMAKE_GO_LINK_EXECUTABLE)
  set(CMAKE_GO_LINK_EXECUTABLE "go tool link -o <TARGET> <OBJECTS>  ")
endif()
