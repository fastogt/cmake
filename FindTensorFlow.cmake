FIND_PATH(TENSORFLOW_INCLUDE_DIRS NAMES tensorflow/c PATHS
    /usr/include
    /opt/local/include
    /usr/local/include
)

FIND_LIBRARY(TENSORFLOW_LIBRARIES NAMES tensorflow PATHS
    /usr/local/lib
    /opt/local/lib
    /usr/lib
)

# handle the QUIETLY and REQUIRED arguments and set LZ4_FOUND to TRUE if
# all listed variables are TRUE
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(tensorflow
                                  REQUIRED_VARS TENSORFLOW_LIBRARIES TENSORFLOW_INCLUDE_DIRS
                                  VERSION_VAR TENSORFLOW_VERSION_STRING)
MARK_AS_ADVANCED(TENSORFLOW_INCLUDE_DIRS)
