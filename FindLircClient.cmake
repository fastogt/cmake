# - Find lirc_client
# Find the native lirc_client includes and library
# This module defines
#  LIRC_CLIENT_INCLUDE_DIR, where to find lirc/lirc_client.h
#  LIRC_CLIENT_LIBRARIES, the libraries needed to use
#  LIRC_CLIENT_FOUND, If false, do not try to use lirc_client

FIND_PATH(LIRC_CLIENT_INCLUDE_DIR lirc/lirc_client.h)
FIND_LIBRARY(LIRC_CLIENT_LIBRARY NAMES lirc_client)

SET(LIRC_CLIENT_LIBRARIES ${LIRC_CLIENT_LIBRARIES} ${LIRC_CLIENT_LIBRARY})

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(LIRC_CLIENT DEFAULT_MSG LIRC_CLIENT_LIBRARIES LIRC_CLIENT_INCLUDE_DIR)
MARK_AS_ADVANCED(LIRC_CLIENT_LIBRARIES LIRC_CLIENT_INCLUDE_DIR)
