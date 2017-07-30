#.rst:
# FindBZip2
# ---------
#
# Try to find BZip2
#
# Once done this will define
#
# ::
#
#   BZIP2_FOUND - system has BZip2
#   BZIP2_INCLUDE_DIR - the BZip2 include directory
#   BZIP2_LIBRARIES - Link these to use BZip2
#   BZIP2_NEED_PREFIX - this is set if the functions are prefixed with BZ2_
#   BZIP2_VERSION_STRING - the version of BZip2 found (since CMake 2.8.8)

#=============================================================================
# Copyright 2006-2012 Kitware, Inc.
# Copyright 2006 Alexander Neundorf <neundorf@kde.org>
# Copyright 2012 Rolf Eike Beer <eike@sf-mail.de>
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of CMake, substitute the full
#  License text for the above reference.)

IF(BZIP2_USE_STATIC)
  MESSAGE(STATUS "BZIP2_USE_STATIC: ON")
ELSE()
  MESSAGE(STATUS "BZIP2_USE_STATIC: OFF")
ENDIF(BZIP2_USE_STATIC)

SET(_BZIP2_PATHS PATHS "[HKEY_LOCAL_MACHINE\\SOFTWARE\\GnuWin32\\Bzip2;InstallPath]")

FIND_PATH(BZIP2_INCLUDE_DIR bzlib.h ${_BZIP2_PATHS} PATH_SUFFIXES include)

IF(BZIP2_USE_STATIC)
  FIND_LIBRARY(BZIP2_LIBRARY NAMES libbz2.a libbzip2.a ${_BZIP2_PATHS} PATH_SUFFIXES lib)
  SET(BZIP2_LIBRARIES ${BZIP2_LIBRARY})
ELSE()
  FIND_LIBRARY(BZIP2_LIBRARY NAMES bz2 bzip2 ${_BZIP2_PATHS} PATH_SUFFIXES lib)
  SET(BZIP2_LIBRARIES ${BZIP2_LIBRARY})
ENDIF(BZIP2_USE_STATIC)

IF(BZIP2_INCLUDE_DIR AND EXISTS "${BZIP2_INCLUDE_DIR}/bzlib.h")
  FILE(STRINGS "${BZIP2_INCLUDE_DIR}/bzlib.h" BZLIB_H REGEX "bzip2/libbzip2 version [0-9]+\\.[^ ]+ of [0-9]+ ")
  STRING(REGEX REPLACE ".* bzip2/libbzip2 version ([0-9]+\\.[^ ]+) of [0-9]+ .*" "\\1" BZIP2_VERSION_STRING "${BZLIB_H}")
ENDIF()

# handle the QUIETLY and REQUIRED arguments and set BZip2_FOUND to TRUE if
# all listed variables are TRUE
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(BZip2
                                  REQUIRED_VARS BZIP2_LIBRARIES BZIP2_INCLUDE_DIR
                                  VERSION_VAR BZIP2_VERSION_STRING)

IF(BZIP2_FOUND)
  INCLUDE(CheckLibraryExists)
  CHECK_LIBRARY_EXISTS("${BZIP2_LIBRARIES}" BZ2_bzCompressInit "" BZIP2_NEED_PREFIX)
ENDIF()

MARK_AS_ADVANCED(BZIP2_INCLUDE_DIR)
