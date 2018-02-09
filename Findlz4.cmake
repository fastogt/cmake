# - Find lz4
# Find the lz4 compression library and includes
#
#  LZ4_INCLUDE_DIRS - where to find lz4.h, etc.
#  LZ4_LIBRARIES   - List of libraries when using lz4.
#  LZ4_FOUND       - True if lz4 found.

IF(LZ4_USE_STATIC)
  MESSAGE(STATUS "LZ4_USE_STATIC: ON")
ELSE()
  MESSAGE(STATUS "LZ4_USE_STATIC: OFF")
ENDIF(LZ4_USE_STATIC)

FIND_PATH(LZ4_INCLUDE_DIRS lz4.h PATHS
  /usr/include
  /opt/local/include
  /usr/local/include
)
IF(LZ4_USE_STATIC)
  SET(LZ4_NAMES ${LZ4_NAMES} liblz4.a)
ELSE()
  SET(LZ4_NAMES ${LZ4_NAMES} lz4)
ENDIF()

FIND_LIBRARY(LZ4_LIBRARIES NAMES ${LZ4_NAMES} PATHS
  /usr/local/lib
  /opt/local/lib
  /usr/lib
)

# handle the QUIETLY and REQUIRED arguments and set LZ4_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(lz4
                                  REQUIRED_VARS LZ4_LIBRARIES LZ4_INCLUDE_DIRS
                                  VERSION_VAR LZ4_VERSION_STRING)
MARK_AS_ADVANCED(LZ4_INCLUDE_DIRS)
