# - Find Snappy 
# Find the snappy compression library and includes
#
#  SNAPPY_INCLUDE_DIR - where to find snappy.h, etc.
#  SNAPPY_LIBRARIES   - List of libraries when using snappy.
#  SNAPPY_FOUND       - True if snappy found.

find_path(SNAPPY_INCLUDE_DIR snappy.h NO_DEFAULT_PATH PATHS
  ${HT_DEPENDENCY_INCLUDE_DIR}
  /usr/include
  /opt/local/include
  /usr/local/include
)

set(SNAPPY_NAMES ${SNAPPY_NAMES} snappy)
find_library(SNAPPY_LIBRARY NAMES ${SNAPPY_NAMES} NO_DEFAULT_PATH PATHS
    ${HT_DEPENDENCY_LIB_DIR}
    /usr/local/lib
    /opt/local/lib
    /usr/lib
    )

if (SNAPPY_INCLUDE_DIR AND SNAPPY_LIBRARY)
  set(SNAPPY_FOUND TRUE)
  set( SNAPPY_LIBRARIES ${SNAPPY_LIBRARY} )
else ()
  set(SNAPPY_FOUND FALSE)
  set( SNAPPY_LIBRARIES )
endif ()

if (SNAPPY_FOUND)
  message(STATUS "Found Snappy: ${SNAPPY_LIBRARY}")
else ()
  message(STATUS "Not Found Snappy: ${SNAPPY_LIBRARY}")
  if (SNAPPY_FIND_REQUIRED)
    message(STATUS "Looked for Snappy libraries named ${SNAPPY_NAMES}.")
    message(FATAL_ERROR "Could NOT find Snappy library")
  endif ()
endif ()

mark_as_advanced(SNAPPY_LIBRARY SNAPPY_INCLUDE_DIR)

