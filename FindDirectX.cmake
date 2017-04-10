# - Find DirectX SDK installation
# Find the DirectX includes and library
# This module defines
#  DirectX_INCLUDE_DIRS, where to find d3d9.h, etc.
#  DirectX_LIBRARIES, libraries to link against to use DirectX.
#  DirectX_FOUND, If false, do not try to use DirectX.
#  DirectX_ROOT_DIR, directory where DirectX was installed.

IF (CMAKE_SIZEOF_VOID_P MATCHES 8)
  SET(MSYS_POSTFIX "mingw64/x86_64-w64-mingw32")
ELSE ()
  SET(MSYS_POSTFIX "mingw32/i686-w64-mingw32")
ENDIF ()

FIND_PATH(DirectX_INCLUDE_DIRS d3d9.h PATHS "$ENV{MSYS_ROOT}/${MSYS_POSTFIX}"
  "$ENV{PROGRAMFILES}/Microsoft DirectX SDK*" PATH_SUFFIXES include
)

GET_FILENAME_COMPONENT(DirectX_ROOT_DIR "${DirectX_INCLUDE_DIRS}/.." ABSOLUTE)
SET(DirectX_LIBRARY_PATHS "${DirectX_ROOT_DIR}/Lib")

FIND_LIBRARY(DirectX_D3D9_LIBRARY d3d9 ${DirectX_LIBRARY_PATHS} NO_DEFAULT_PATH)
FIND_LIBRARY(DirectX_D3DX9_LIBRARY d3dx9 ${DirectX_LIBRARY_PATHS} NO_DEFAULT_PATH)
SET(DirectX_LIBRARIES ${DirectX_D3D9_LIBRARY} ${DirectX_D3DX9_LIBRARY})

# handle the QUIETLY and REQUIRED arguments and set DirectX_FOUND to TRUE if all listed variables are TRUE
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(DirectX DEFAULT_MSG DirectX_ROOT_DIR DirectX_LIBRARIES DirectX_INCLUDE_DIRS)
MARK_AS_ADVANCED(DirectX_INCLUDE_DIRS DirectX_D3D9_LIBRARY DirectX_D3DX9_LIBRARY)
