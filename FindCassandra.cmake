# Find the cassandra library.
#
# This module defines
#  CASSANDRA_FOUND             - True if CASSANDRA was found.
#  CASSANDRA_INCLUDE_DIRS      - Include directories for CASSANDRA headers.
#  CASSANDRA_LIBRARIES         - Libraries for CASSANDRA.
#
# To specify an additional directory to search, set CASSANDRA_ROOT.
#
# Copyright (c) 2010, Ewen Cheslack-Postava
# Based on FindSQLite3.cmake by:
#  Copyright (c) 2006, Jaroslaw Staniek, <js@iidea.pl>
#  Extended by Siddhartha Chaudhuri, 2008.
#
# Redistribution and use is allowed according to the terms of the BSD license.
#

FIND_PATH(CASSANDRA_INCLUDE_DIRS cassandra.h HINTS /usr /usr/local /opt PATH_SUFFIXES include)
FIND_LIBRARY(CASSANDRA_LIBRARIES NAMES cassandra HINTS /usr /usr/local /opt)

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(Casandra DEFAULT_MSG CASSANDRA_LIBRARIES CASSANDRA_INCLUDE_DIRS)
MARK_AS_ADVANCED(CASSANDRA_INCLUDE_DIRS CASSANDRA_LIBRARIES CASSANDRA_DEFINITIONS)
