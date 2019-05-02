# - Find Cpuid
# Find the cpuid compression library and includes
#
#  CPUID_INCLUDE_DIRS - where to find libcpuid.h, etc.
#  CPUID_LIBRARIES   - List of libraries when using cpuid.
#  CPUID_FOUND       - True if cpuid found.

IF(CPUID_USE_STATIC)
  MESSAGE(STATUS "CPUID_USE_STATIC: ON")
ELSE()
  MESSAGE(STATUS "CPUID_USE_STATIC: OFF")
ENDIF(CPUID_USE_STATIC)

FIND_PATH(CPUID_INCLUDE_DIRS libcpuid/libcpuid.h PATHS
  /usr/include
  /opt/local/include
  /usr/local/include
)
IF(CPUID_USE_STATIC)
  SET(CPUID_NAMES ${CPUID_NAMES} libcpuid.a)
ELSE()
  SET(CPUID_NAMES ${CPUID_NAMES} cpuid)
ENDIF()

FIND_LIBRARY(CPUID_LIBRARIES NAMES ${CPUID_NAMES} PATHS
  /usr/local/lib
  /opt/local/lib
  /usr/lib
)

# handle the QUIETLY and REQUIRED arguments and set CPUID_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(Cpuid
                                  REQUIRED_VARS CPUID_LIBRARIES CPUID_INCLUDE_DIRS
                                  VERSION_VAR CPUID_VERSION_STRING)
MARK_AS_ADVANCED(CPUID_INCLUDE_DIRS)
