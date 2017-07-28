# - Find Snappy 
# Find the snappy compression library and includes
#
#  SNAPPY_INCLUDE_DIR - where to find snappy.h, etc.
#  SNAPPY_LIBRARIES   - List of libraries when using snappy.
#  SNAPPY_FOUND       - True if snappy found.

IF(SNAPPY_USE_STATIC)
  MESSAGE(STATUS "SNAPPY_USE_STATIC: ON")
ELSE()
  MESSAGE(STATUS "SNAPPY_USE_STATIC: OFF")
ENDIF(SNAPPY_USE_STATIC)

FIND_PATH(SNAPPY_INCLUDE_DIR snappy.h PATHS
  ${HT_DEPENDENCY_INCLUDE_DIR}
  /usr/include
  /opt/local/include
  /usr/local/include
)
IF(SNAPPY_USE_STATIC)
  SET(SNAPPY_NAMES ${SNAPPY_NAMES} libsnappy.a)
ELSE()
  SET(SNAPPY_NAMES ${SNAPPY_NAMES} snappy)
ENDIF()

FIND_LIBRARY(SNAPPY_LIBRARIES NAMES ${SNAPPY_NAMES} PATHS
  ${HT_DEPENDENCY_LIB_DIR}
  /usr/local/lib
  /opt/local/lib
  /usr/lib
)

# handle the QUIETLY and REQUIRED arguments and set SNAPPY_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(Snappy
                                  REQUIRED_VARS SNAPPY_LIBRARIES SNAPPY_INCLUDE_DIR
                                  VERSION_VAR SNAPPY_VERSION_STRING)
MARK_AS_ADVANCED(SNAPPY_INCLUDE_DIR)
