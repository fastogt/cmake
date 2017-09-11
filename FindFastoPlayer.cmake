# FindCommon.cmake - Try to find the player library
# Once done this will define
#
#  PLAYER_FOUND - System has player
#  PLAYER_INCLUDE_DIR - The player include directory
#  PLAYER_LIBRARIES - The libraries needed to use player

FIND_PATH(PLAYER_INCLUDE_DIR NAMES player/types.h
 HINTS /usr /usr/local /opt PATH_SUFFIXES include
)

FIND_LIBRARY(PLAYER_MEDIA_LIBRARY NAMES fastoplayer_media
 HINTS /usr /usr/local /opt
)

FIND_LIBRARY(PLAYER_LIBRARY NAMES fastoplayer
 HINTS /usr /usr/local /opt
)

SET(PLAYER_LIBRARIES ${PLAYER_LIBRARIES} ${PLAYER_MEDIA_LIBRARY})

IF(PLAYER_LIBRARY)
  SET(PLAYER_LIBRARIES ${PLAYER_LIBRARIES} ${PLAYER_LIBRARY})
ENDIF(PLAYER_LIBRARY)

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(common DEFAULT_MSG PLAYER_LIBRARIES PLAYER_INCLUDE_DIR)
MARK_AS_ADVANCED(PLAYER_INCLUDE_DIR PLAYER_LIBRARIES)

