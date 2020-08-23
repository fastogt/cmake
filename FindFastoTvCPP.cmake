# FindFastoTvCPP.cmake - Try to find the player library
# Once done this will define
#
#  FASTOTV_CPP_FOUND - System has player
#  FASTOTV_CPP_INCLUDE_DIR - The player include directory
#  FASTOTV_CPP_LIBRARIES - The libraries needed to use player

FIND_PATH(FASTOTV_CPP_INCLUDE_DIRS NAMES fastotv/config.h
 HINTS /usr /usr/local /opt PATH_SUFFIXES include
)

FIND_LIBRARY(FASTOTV_CPP_LIBRARY NAMES fastotv_cpp
 HINTS /usr /usr/local /opt
)

SET(FASTOTV_CPP_LIBRARIES ${FASTOTV_CPP_LIBRARIES} ${FASTOTV_CPP_LIBRARY})

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(fastotv_cpp DEFAULT_MSG FASTOTV_CPP_LIBRARIES FASTOTV_CPP_INCLUDE_DIRS)
MARK_AS_ADVANCED(FASTOTV_CPP_INCLUDE_DIRS FASTOTV_CPP_LIBRARIES)

