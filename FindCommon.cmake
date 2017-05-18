# FindCommon.cmake - Try to find the common library
# Once done this will define
#
#  COMMON_FOUND - System has common
#  COMMON_INCLUDE_DIR - The common include directory
#  COMMON_LIBRARIES - The libraries needed to use common

FIND_PATH(COMMON_INCLUDE_DIR NAMES macros.h
   HINTS
   /usr
   /usr/local
   /opt
   PATH_SUFFIXES common
)

FIND_LIBRARY(COMMON_BASE_LIBRARY NAMES common
   HINTS
   /usr
   /usr/local
   /opt
)

FIND_LIBRARY(COMMON_QT_LIBRARY NAMES common_qt
   HINTS
   /usr
   /usr/local
   /opt
)

SET(COMMON_LIBRARIES ${COMMON_LIBRARIES} ${COMMON_BASE_LIBRARY})

IF(COMMON_QT_LIBRARY)
  SET(COMMON_LIBRARIES ${COMMON_LIBRARIES} ${COMMON_QT_LIBRARY})
ENDIF(COMMON_QT_LIBRARY)

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(common DEFAULT_MSG COMMON_LIBRARIES COMMON_INCLUDE_DIR)

MARK_AS_ADVANCED(COMMON_INCLUDE_DIR COMMON_LIBRARIES)

