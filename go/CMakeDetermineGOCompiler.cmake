if(NOT CMAKE_GO_COMPILER)
  if(NOT $ENV{Go_COMPILER} STREQUAL "")
    get_filename_component(CMAKE_GO_COMPILER_INIT $ENV{Go_COMPILER} PROGRAM PROGRAM_ARGS CMAKE_GO_FLAGS_ENV_INIT)

    if(CMAKE_GO_FLAGS_ENV_INIT)
      set(CMAKE_GO_COMPILER_ARG1 "${CMAKE_GO_FLAGS_ENV_INIT}" CACHE STRING "First argument to GO compiler")
    endif()

    if(NOT EXISTS ${CMAKE_GO_COMPILER_INIT})
      message(SEND_ERROR "Could not find compiler set in environment variable GO_COMPILER:\n$ENV{GO_COMPILER}.")
    endif()

  endif()

  set(GO_BIN_PATH
    $ENV{GOPATH}
    $ENV{GOROOT}
    $ENV{GOROOT}/../bin
    $ENV{GO_COMPILER}
    /usr/bin
    /usr/local/bin
    )

  if(CMAKE_GO_COMPILER_INIT)
    set(CMAKE_GO_COMPILER ${CMAKE_GO_COMPILER_INIT} CACHE PATH "GO Compiler")
  else()
    find_program(CMAKE_GO_COMPILER
      NAMES go
      PATHS ${GO_BIN_PATH}
    )
    EXEC_PROGRAM(${CMAKE_GO_COMPILER} ARGS version OUTPUT_VARIABLE GOLANG_VERSION)
    STRING(REGEX MATCH "go[0-9]+.[0-9]+.[0-9]+[ /A-Za-z0-9]*" VERSION "${GOLANG_VERSION}")
    message("-- The Golang compiler identification is ${VERSION}")
    message("-- Check for working Golang compiler: ${CMAKE_GO_COMPILER}")
  endif()

endif()

mark_as_advanced(CMAKE_GO_COMPILER)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/cmake/go/CMakeGOCompiler.cmake.in
  ${CMAKE_PLATFORM_INFO_DIR}/CMakeGOCompiler.cmake @ONLY)

set(CMAKE_GO_COMPILER_ENV_VAR "GO_COMPILER")
