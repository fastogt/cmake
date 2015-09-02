FUNCTION(QUERY_QMAKE VAR RESULT)
    GET_TARGET_PROPERTY(QMAKE_EXECUTABLE Qt5::qmake LOCATION)
    EXEC_PROGRAM(${QMAKE_EXECUTABLE} ARGS "-query ${VAR}" RETURN_VALUE return_code OUTPUT_VARIABLE output )
    IF(NOT return_code)
        FILE(TO_CMAKE_PATH "${output}" output)
        SET(${RESULT} ${output} PARENT_SCOPE)
    ENDIF(NOT return_code)
ENDFUNCTION(QUERY_QMAKE)

FUNCTION(FIND_LIB PATH_WHERE_SEARCH _NAME RESULT)
    STRING(REGEX REPLACE "[(0-9)]+$" "" CLEARNAME ${_NAME})
    STRING(REGEX REPLACE ${CLEARNAME} "" VERSION ${_NAME})
    SET(name_stable "${CMAKE_SHARED_LIBRARY_PREFIX}${_NAME}${CMAKE_SHARED_LIBRARY_SUFFIX}")
    SET(PLUGIN "${PATH_WHERE_SEARCH}/${name_stable}")
    #trying to search lib with suffix 5
    IF(NOT EXISTS ${PLUGIN})
        IF(UNIX)
            SET(PLUGIN "${PATH_WHERE_SEARCH}/${CMAKE_SHARED_LIBRARY_PREFIX}${CLEARNAME}${CMAKE_SHARED_LIBRARY_SUFFIX}.${VERSION}")
        ELSE(UNIX)
            SET(PLUGIN "${PATH_WHERE_SEARCH}/${CLEARNAME}${CMAKE_SHARED_LIBRARY_SUFFIX}")
        ENDIF(UNIX)
    ENDIF()

    IF(EXISTS ${PLUGIN})
        SET(${RESULT} ${PLUGIN} PARENT_SCOPE)
    ENDIF()  
ENDFUNCTION(FIND_LIB)

MACRO(DEPLOY_QT_PLUGIN_HELPER PLUGIN_PATH PATH_WHERE_SEARCH LIB_DIST TYPE)
    GET_FILENAME_COMPONENT(dir ${PLUGIN_PATH} PATH)
    GET_FILENAME_COMPONENT(name ${PLUGIN_PATH} NAME_WE)
    STRING(TOUPPER ${TYPE} _type) 
    IF(${_type} STREQUAL "DEBUG")# try to find debug version of library 
        SET(name_local "${name}${CMAKE_DEBUG_POSTFIX}")
        FIND_LIB(${PATH_WHERE_SEARCH}/${dir} ${name_local} PLUGIN_${TYPE}_${name})
    ENDIF()
    IF(NOT PLUGIN_${TYPE}_${name})
        FIND_LIB(${PATH_WHERE_SEARCH}/${dir} ${name} PLUGIN_${TYPE}_${name})
    ENDIF()

    IF(PLUGIN_${TYPE}_${name})
        GET_FILENAME_COMPONENT(LibWithoutSymLink ${PLUGIN_${TYPE}_${name}} REALPATH)
        GET_FILENAME_COMPONENT(PLUGIN_NAME ${PLUGIN_${TYPE}_${name}} NAME)
        IF(NOT ${PLUGIN_${TYPE}_${name}} STREQUAL ${LibWithoutSymLink})
            MESSAGE(STATUS "Deployng ${PLUGIN} plugin for ${TYPE}, realpath is ${LibWithoutSymLink}, name ${PLUGIN_NAME}")
            INSTALL(FILES ${LibWithoutSymLink} DESTINATION "${LIB_DIST}/${dir}" CONFIGURATIONS ${TYPE} COMPONENT QTPLUGINS RENAME ${PLUGIN_NAME})
        ELSE()
            MESSAGE(STATUS "Deployng ${PLUGIN_${TYPE}_${name}} plugin for ${TYPE}")
            INSTALL(FILES ${PLUGIN_${TYPE}_${name}} DESTINATION "${LIB_DIST}/${dir}" CONFIGURATIONS ${TYPE} COMPONENT QTPLUGINS)
        ENDIF()
    ELSE()
        MESSAGE(STATUS "Could not deploy ${PLUGIN_${name}}, required path: ${PLUGIN_PATH}, plugin for ${TYPE}, search in ${PATH_WHERE_SEARCH},")
    ENDIF()
ENDMACRO(DEPLOY_QT_PLUGIN_HELPER)

MACRO(DEPLOY_QT_PLUGIN PLUGIN_PATH PATH_WHERE_SEARCH LIB_DIST)
    IF(NOT CMAKE_BUILD_TYPE AND CMAKE_CONFIGURATION_TYPES)
        FOREACH(buildconfig ${CMAKE_CONFIGURATION_TYPES})
            DEPLOY_QT_PLUGIN_HELPER(${PLUGIN_PATH} ${PATH_WHERE_SEARCH} ${LIB_DIST} ${buildconfig})
        ENDFOREACH(buildconfig ${CMAKE_CONFIGURATION_TYPES})
    ELSEIF(CMAKE_BUILD_TYPE)
        DEPLOY_QT_PLUGIN_HELPER(${PLUGIN_PATH} ${PATH_WHERE_SEARCH} ${LIB_DIST} ${CMAKE_BUILD_TYPE})
    ENDIF(NOT CMAKE_BUILD_TYPE AND CMAKE_CONFIGURATION_TYPES)
ENDMACRO(DEPLOY_QT_PLUGIN)

MACRO(DETECT_QT)
    FIND_PACKAGE(Qt5Core REQUIRED)
ENDMACRO(DETECT_QT)

MACRO(INTEGRATE_QT)
    QUERY_QMAKE(QT_INSTALL_PLUGINS QT_PLUGINS_DIR)
    QUERY_QMAKE(QT_INSTALL_BINS QT_BINS_DIR)
    QUERY_QMAKE(QT_INSTALL_LIBS QT_LIBS_DIR)

    MESSAGE(STATUS "QT_PLUGINS_DIR=${QT_PLUGINS_DIR}, QT_BINS_DIR=${QT_BINS_DIR}, QT_LIBS_DIR=${QT_LIBS_DIR}")

    SET(USE_QT_DYNAMIC ON)
    SET(QT_COMPONENTS_TO_USE ${ARGV})

    IF(DEVELOPER_BUILD_TESTS)
        SET(QT_COMPONENTS_TO_USE ${QT_COMPONENTS_TO_USE} Qt5Test)
    ENDIF(DEVELOPER_BUILD_TESTS)

    FOREACH(qtComponent ${QT_COMPONENTS_TO_USE})
        IF(NOT ${qtComponent} STREQUAL "Qt5ScriptTools")
            FIND_PACKAGE(${qtComponent} REQUIRED)
        ELSE()
            FIND_PACKAGE(${qtComponent} QUIET)
        ENDIF()

        # Add the include directories for the Qt 5 module to
        # the compile lines.
        INCLUDE_DIRECTORIES(${${qtComponent}_INCLUDE_DIRS})

        # Use the compile definitions defined in the Qt 5 module
        ADD_DEFINITIONS(${${qtComponent}_DEFINITIONS})

        # Add compiler flags for building executables (-fPIE)
        SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${${qtComponent}_EXECUTABLE_COMPILE_FLAGS}")

        #STRING(REGEX REPLACE "Qt5" "" COMPONENT_SHORT_NAME ${qtComponent})
        #set(QT_MODULES_TO_USE ${QT_MODULES_TO_USE} ${COMPONENT_SHORT_NAME})

        IF(${${qtComponent}_FOUND})
            IF(NOT(${qtComponent} STREQUAL "Qt5LinguistTools"))
                STRING(REGEX REPLACE "Qt5" "" componentShortName ${qtComponent})
                SET(QT_LIBRARIES ${QT_LIBRARIES} "Qt5::${componentShortName}")
            ENDIF()
        ENDIF()
    ENDFOREACH(qtComponent ${QT_COMPONENTS_TO_USE})
    SETUP_COMPILER_SETTINGS(${USE_QT_DYNAMIC})
ENDMACRO(INTEGRATE_QT)


##############################################################################

MACRO(INSTALL_QT TARGET_NAME LIB_DIST)
LIST(FIND QT_COMPONENTS_TO_USE "Qt5Xml" QT_XML_INDEX)
IF(NOT ${QT_XML_INDEX} EQUAL -1)
    GET_TARGET_PROPERTY(libLocation ${Qt5Xml_LIBRARIES} LOCATION)
    STRING(REGEX REPLACE "Xml" "XmlPatterns" libLocation ${libLocation})
    QT_ADD_TO_INSTALL(${TARGET_NAME} ${libLocation} "")
ENDIF()
FOREACH(qtComponent ${QT_COMPONENTS_TO_USE} ${QT_DEBUG_COMPONENTS_TO_USE})
    IF(NOT ${qtComponent} STREQUAL "Qt5LinguistTools")
        IF(NOT "${${qtComponent}_LIBRARIES}" STREQUAL "")
            GET_TARGET_PROPERTY(libLocation ${${qtComponent}_LIBRARIES} LOCATION)
            QT_ADD_TO_INSTALL(${TARGET_NAME} ${libLocation} "")
        ELSE(NOT "${${qtComponent}_LIBRARIES}" STREQUAL "")
            MESSAGE("Canont find library ${qtComponent}_LIBRARIES")
        ENDIF(NOT "${${qtComponent}_LIBRARIES}" STREQUAL "")
    ENDIF()
ENDFOREACH(qtComponent ${QT_COMPONENTS_TO_USE} ${QT_DEBUG_COMPONENTS_TO_USE})
IF(UNIX AND NOT APPLE)
    #Qt5XcbQpa
    FIND_LIBRARY(Qt5XcbQpa_LIBRARIES NAMES Qt5XcbQpa PATHS "${QT_LIBS_DIR}" NO_DEFAULT_PATH)
    GET_FILENAME_COMPONENT(LibWithoutSymLink ${Qt5XcbQpa_LIBRARIES} REALPATH)
    QT_ADD_TO_INSTALL(${TARGET_NAME} ${LibWithoutSymLink} "")
ENDIF(UNIX AND NOT APPLE)
MESSAGE(STATUS "Qt libs to install ${DLIBS_TO_COPY_RELEASE}")
IF(MSVC)
    # Visual studio install
    FOREACH(buildconfig ${CMAKE_CONFIGURATION_TYPES})
        IF(${buildconfig} STREQUAL "Debug")
            SET(DLIBS_TO_COPY ${DLIBS_TO_COPY_ALL} ${DLIBS_TO_COPY_DEBUG})
        ELSE()
            SET(DLIBS_TO_COPY ${DLIBS_TO_COPY_ALL} ${DLIBS_TO_COPY_RELEASE})
        ENDIF()
        INSTALL(FILES ${DLIBS_TO_COPY} DESTINATION ${LIB_DIST} CONFIGURATIONS ${buildconfig} COMPONENT QTLIBS)
    ENDFOREACH(buildconfig ${CMAKE_CONFIGURATION_TYPES})
ELSEIF(UNIX OR MINGW)
    # Make install
    STRING(TOUPPER ${CMAKE_BUILD_TYPE} TYPE)
    IF(${TYPE} STREQUAL "DEBUG")
        SET(DLIBS_TO_COPY ${DLIBS_TO_COPY_ALL} ${DLIBS_TO_COPY_DEBUG})
    ELSE()
        SET(DLIBS_TO_COPY ${DLIBS_TO_COPY_ALL} ${DLIBS_TO_COPY_RELEASE})
    ENDIF()
    IF(MINGW)
        INSTALL(FILES ${DLIBS_TO_COPY} DESTINATION ${LIB_DIST} COMPONENT QTLIBS)
    ELSEIF(APPLE)
    ELSE()
    #eliminate symlinks
        FOREACH(dllsToCopy ${DLIBS_TO_COPY})		
            GET_FILENAME_COMPONENT(name ${dllsToCopy} NAME)
            STRING(REGEX REPLACE "[^so]+$" ".5" lnname ${name})
            INSTALL(FILES ${dllsToCopy} DESTINATION ${LIB_DIST} CONFIGURATIONS ${TYPE} COMPONENT QTLIBS RENAME ${lnname} COMPONENT QTLIBS)
        ENDFOREACH(dllsToCopy ${DLIBS_TO_COPY})
    ENDIF()
ENDIF(MSVC)
		
ENDMACRO(INSTALL_QT)

MACRO(QT_ADD_TO_INSTALL TARGET_NAME libLocation copyToSubdirectory)
    SET(libLocation_release ${libLocation})
    SET(REPLACE_PATTERN "/lib/([^/]+)$" "/bin/\\1") # from lib to bin
    IF(NOT EXISTS "${libLocation_release}")
        STRING(REGEX REPLACE ${REPLACE_PATTERN} libLocation_release ${libLocation_release})
    ENDIF()
    IF(EXISTS "${libLocation_release}")
        SET(DLIBS_TO_COPY_RELEASE ${DLIBS_TO_COPY_RELEASE} ${libLocation_release})
        STRING(REGEX REPLACE ${CMAKE_SHARED_LIBRARY_SUFFIX} ${CMAKE_DEBUG_POSTFIX}${CMAKE_SHARED_LIBRARY_SUFFIX} libLocation_debug ${libLocation_release})
        IF(EXISTS "${libLocation_debug}")
            SET(DLIBS_TO_COPY_DEBUG ${DLIBS_TO_COPY_DEBUG} ${libLocation_debug})
        ELSE()
            SET(DLIBS_TO_COPY_DEBUG ${DLIBS_TO_COPY_DEBUG} ${libLocation_release})
        ENDIF()
    ENDIF()
ENDMACRO(QT_ADD_TO_INSTALL)
