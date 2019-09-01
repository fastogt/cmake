# - Find NCSDK
# Find the NCSDK library and includes
#
#  NCSDK_INCLUDE_DIRS - where to find bzlib.h, etc.
#  NCSDK_LIBRARIES   - List of libraries when using NCSDK.
#  NCSDK_FOUND       - True if NCSDK found.

FIND_PATH(NCSDK_INCLUDE_DIRS mvnc.h PATH_SUFFIXES include)

FIND_LIBRARY(NCSDK_LIBRARIES NAMES mvnc PATH_SUFFIXES lib)

# handle the QUIETLY and REQUIRED arguments and set NCSDK_FOUND to TRUE if
# all listed variables are TRUE
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(NCSDK
                                  REQUIRED_VARS NCSDK_LIBRARIES NCSDK_INCLUDE_DIRS
                                  VERSION_VAR NCSDK_VERSION_STRING)

IF(NCSDK_FOUND)
  INCLUDE(CheckLibraryExists)
  CHECK_LIBRARY_EXISTS("${NCSDK_LIBRARIES}" ncGlobalSetOption "" NCSDK_NEED_PREFIX)
ENDIF()

MARK_AS_ADVANCED(NCSDK_INCLUDE_DIR)
