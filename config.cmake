CMAKE_MINIMUM_REQUIRED(VERSION 3.16 FATAL_ERROR) # CMP0054

# os
IF(CMAKE_SYSTEM_NAME MATCHES "Linux")
  SET(OS_LINUX ON)
  SET(OS_POSIX ON)
  ADD_DEFINITIONS(-DOS_LINUX -DOS_POSIX)
ELSEIF(CMAKE_SYSTEM_NAME MATCHES "Darwin")
  SET(OS_MACOSX ON)
  SET(OS_POSIX ON)
  ADD_DEFINITIONS(-DOS_MACOSX -DOS_POSIX)
ELSEIF(CMAKE_SYSTEM_NAME MATCHES "Windows")
  SET(OS_WINDOWS ON)
  SET(OS_WIN ON)
  ADD_DEFINITIONS(-D_WIN32 -DOS_WIN -DOS_WINDOWS)
ELSEIF(CMAKE_SYSTEM_NAME MATCHES "MSYS")
  SET(OS_WINDOWS ON)
  SET(OS_WIN ON)
  ADD_DEFINITIONS(-D_WIN32 -DOS_WIN -DOS_WINDOWS)
ELSEIF(CMAKE_SYSTEM_NAME MATCHES "FreeBSD")
  SET(OS_FREEBSD ON)
  SET(OS_POSIX ON)
  ADD_DEFINITIONS(-DOS_FREEBSD -DOS_POSIX)
ELSEIF(CMAKE_SYSTEM_NAME MATCHES "Android")
  SET(OS_ANDROID ON)
  SET(OS_POSIX ON)
  ADD_DEFINITIONS(-DOS_ANDROID -DOS_POSIX -DANDROID -DJabber)
ELSEIF(CMAKE_SYSTEM_NAME MATCHES "BlackBerry")
  SET(OS_BLACKBERRY ON)
  SET(OS_POSIX ON)
  ADD_DEFINITIONS(-DOS_BLACKBERRY -DOS_POSIX)
ELSEIF(CMAKE_SYSTEM_NAME MATCHES "iOS")
  SET(OS_IOS ON)
  SET(OS_POSIX ON)
  ADD_DEFINITIONS(-DOS_IOS -DOS_POSIX)
ELSEIF(CMAKE_SYSTEM_NAME MATCHES "WindowsPhone")
  SET(OS_WINPHONE ON)
  ADD_DEFINITIONS(-DOS_WINPHONE
    -D_CRT_NONSTDC_NO_DEPRECATE
    -D_CRT_SECURE_NO_DEPRECATE
    -D_CRT_NON_CONFORMING_SWPRINTFS
    -D_XKEYCHECK_H
    -DGOOGLE_PROTOBUF_NO_THREAD_SAFETY
    -D_SCL_SECURE_NO_WARNINGS
  )
ELSE()
  MESSAGE(FATAL_ERROR "Not supported OS: ${CMAKE_SYSTEM_NAME}")
ENDIF(CMAKE_SYSTEM_NAME MATCHES "Linux")

# platform
# PLATFORM_ARCH_NAME (human readable)
# PLATFORM_ARCH_FULL_NAME (human readable package name)
# PLATFORM_PACKAGE_ARCH_NAME (deb -s) package specific
STRING(TOLOWER ${CMAKE_SYSTEM_PROCESSOR} CMAKE_SYSTEM_PROCESSOR_LOWERCASE)
IF(CMAKE_SYSTEM_PROCESSOR_LOWERCASE MATCHES "arm" OR CMAKE_SYSTEM_PROCESSOR_LOWERCASE MATCHES "aarch64" OR CMAKE_SYSTEM_PROCESSOR_LOWERCASE MATCHES "arm64")
  #ADD_DEFINITIONS(-mfloat-abi=softfp -mfpu=neon)
  SET(PLATFORM_ARM ON)
  IF(OS_ANDROID)
    SET(PLATFORM_ARCH_NAME ${ANDROID_NDK_ABI_NAME})
    SET(PLATFORM_ARCH_FULL_NAME ${CMAKE_SYSTEM_PROCESSOR_LOWERCASE})
    SET(PLATFORM_PACKAGE_ARCH_NAME ${ANDROID_NDK_ABI_NAME})
  ELSEIF(OS_IOS)
    SET(PLATFORM_ARCH_NAME ${CMAKE_SYSTEM_PROCESSOR_LOWERCASE})
    SET(PLATFORM_ARCH_FULL_NAME ${CMAKE_SYSTEM_PROCESSOR_LOWERCASE})
    SET(PLATFORM_PACKAGE_ARCH_NAME ${CMAKE_SYSTEM_PROCESSOR_LOWERCASE})
  ELSEIF(OS_MACOSX)
    SET(PLATFORM_ARCH_NAME ${CMAKE_SYSTEM_PROCESSOR_LOWERCASE})
    SET(PLATFORM_ARCH_FULL_NAME ${CMAKE_SYSTEM_PROCESSOR_LOWERCASE})
    SET(PLATFORM_PACKAGE_ARCH_NAME ${CMAKE_SYSTEM_PROCESSOR_LOWERCASE})
  ELSE(OS_ANDROID)
    IF(CMAKE_SYSTEM_PROCESSOR_LOWERCASE MATCHES "aarch64")
      SET(PLATFORM_ARCH_NAME "arm64")
      SET(PLATFORM_ARCH_FULL_NAME "arm64")
      SET(PLATFORM_PACKAGE_ARCH_NAME "arm64")
      ADD_DEFINITIONS(-DPLATFORM_ARM64)
    ELSE(CMAKE_SYSTEM_PROCESSOR_LOWERCASE MATCHES "aarch64")
      SET(PLATFORM_ARCH_NAME "arm")
      SET(PLATFORM_ARCH_FULL_NAME "armhf")
      SET(PLATFORM_PACKAGE_ARCH_NAME "armhf")
      ADD_DEFINITIONS(-DPLATFORM_ARM32)
    ENDIF(CMAKE_SYSTEM_PROCESSOR_LOWERCASE MATCHES "aarch64")
  ENDIF(OS_ANDROID)
  ADD_DEFINITIONS(-DPLATFORM_ARM)
ELSEIF(CMAKE_SYSTEM_PROCESSOR_LOWERCASE MATCHES "x86_64" OR CMAKE_SYSTEM_PROCESSOR_LOWERCASE MATCHES "amd64")
  IF(CMAKE_SIZEOF_VOID_P MATCHES 8)
    SET(PLATFORM_X86_64 ON)
    SET(PLATFORM_ARCH_NAME "x86_64")
    SET(PLATFORM_ARCH_FULL_NAME "x86_64")
    SET(PLATFORM_PACKAGE_ARCH_NAME "amd64")
    ADD_DEFINITIONS(-DPLATFORM_X86_64 -DPLATFORM_X64)
  ELSEIF(CMAKE_SIZEOF_VOID_P MATCHES 4)
    SET(PLATFORM_I386 ON)
    SET(PLATFORM_ARCH_NAME "i386")
    SET(PLATFORM_ARCH_FULL_NAME "i386")
    SET(PLATFORM_PACKAGE_ARCH_NAME "i386")
    ADD_DEFINITIONS(-DPLATFORM_I386 -DPLATFORM_X86)
  ELSE()
    MESSAGE(FATAL_ERROR "Not handled void pinter size: ${CMAKE_SIZEOF_VOID_P}")
  ENDIF(CMAKE_SIZEOF_VOID_P MATCHES 8)
ELSEIF(CMAKE_SYSTEM_PROCESSOR_LOWERCASE MATCHES "i686")
  SET(PLATFORM_I386 ON)
  SET(PLATFORM_ARCH_NAME "i386")
  SET(PLATFORM_ARCH_FULL_NAME "i386")
  SET(PLATFORM_PACKAGE_ARCH_NAME "i386")
  ADD_DEFINITIONS(-DPLATFORM_I386 -DPLATFORM_X86)
ELSE(CMAKE_SYSTEM_PROCESSOR_LOWERCASE MATCHES "arm" OR CMAKE_SYSTEM_PROCESSOR_LOWERCASE MATCHES "aarch64" OR CMAKE_SYSTEM_PROCESSOR_LOWERCASE MATCHES "arm64")
  MESSAGE(FATAL_ERROR "Not supported platform: ${CMAKE_SYSTEM_PROCESSOR}")
ENDIF(CMAKE_SYSTEM_PROCESSOR_LOWERCASE MATCHES "arm" OR CMAKE_SYSTEM_PROCESSOR_LOWERCASE MATCHES "aarch64" OR CMAKE_SYSTEM_PROCESSOR_LOWERCASE MATCHES "arm64")

ADD_DEFINITIONS(-DPLATFORM_ARCH_NAME="${PLATFORM_ARCH_NAME}"
  -DPLATFORM_ARCH_FULL_NAME="${PLATFORM_ARCH_FULL_NAME}"
)

IF(OS_MACOSX)
  IF(PLATFORM_X86_64)
    SET(CMAKE_OSX_ARCHITECTURES x86_64)
  ELSEIF(PLATFORM_I386)
    SET(CMAKE_OSX_ARCHITECTURES i386)
  ELSEIF(PLATFORM_ARM)
    SET(CMAKE_OSX_ARCHITECTURES ${CMAKE_SYSTEM_PROCESSOR_LOWERCASE})
  ELSE(OS_MACOSX)
    MESSAGE(FATAL_ERROR "Unknown platform: ${PLATFORM_ARCH_NAME}")
  ENDIF(PLATFORM_X86_64)
ENDIF(OS_MACOSX)

# compiler
IF(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
  SET(CMAKE_COMPILER_IS_CLANGCXX 1)
ENDIF(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")

INCLUDE(VersionMacros)
THREE_PART_VERSION_TO_VARS(${CMAKE_CXX_COMPILER_VERSION} CMAKE_CXX_COMPILER_VERSION_MAJOR CMAKE_CXX_COMPILER_VERSION_MINOR CMAKE_CXX_COMPILER_VERSION_PATCH)
MATH(EXPR COMPILER_CXX_VERSION "(${CMAKE_CXX_COMPILER_VERSION_MAJOR}<<16) | (${CMAKE_CXX_COMPILER_VERSION_MINOR}<<8) | (${CMAKE_CXX_COMPILER_VERSION_PATCH})")
IF(CMAKE_COMPILER_IS_CLANGCXX)
  ADD_DEFINITIONS(-DCOMPILER_CLANG -DCOMPILER_CLANG_VERSION=${COMPILER_CXX_VERSION})
ELSEIF(CMAKE_COMPILER_IS_GNUCXX)
  ADD_DEFINITIONS(-DCOMPILER_GCC -DCOMPILER_GCC_VERSION=${COMPILER_CXX_VERSION})
  IF(MINGW)
    ADD_DEFINITIONS(-DCOMPILER_MINGW)
  ENDIF(MINGW)
  IF(CMAKE_CXX_COMPILER_VERSION VERSION_LESS 4.9.2 OR CMAKE_CXX_COMPILER_VERSION VERSION_EQUAL 4.9.2)
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
  ENDIF(CMAKE_CXX_COMPILER_VERSION VERSION_LESS 4.9.2 OR CMAKE_CXX_COMPILER_VERSION VERSION_EQUAL 4.9.2)
ELSEIF(CMAKE_CXX_COMPILER_ID STREQUAL Intel)
  ADD_DEFINITIONS(-DCOMPILER_INTEL -DCOMPILER_INTEL_VERSION=${COMPILER_CXX_VERSION})
ELSEIF(CMAKE_CXX_COMPILER_ID STREQUAL MSVC)
  ADD_DEFINITIONS(-DCOMPILER_MSVC -DCOMPILER_MICROSOFT -DCOMPILER_MSVC_VERSION=${COMPILER_CXX_VERSION})
ELSE()
  MESSAGE(FATAL_ERROR "Not supported compiler id: ${CMAKE_CXX_COMPILER_ID}")
ENDIF(CMAKE_COMPILER_IS_CLANGCXX)

#patching PKG_CONFIG_PATH on windows (msys2)
IF(MINGW)
  IF(CMAKE_SIZEOF_VOID_P EQUAL 8)
    SET(ENV{PKG_CONFIG_PATH} "$ENV{PKG_CONFIG_PATH}:/mingw64/lib/pkgconfig")
  ELSEIF(CMAKE_SIZEOF_VOID_P EQUAL 4)
    SET(ENV{PKG_CONFIG_PATH} "$ENV{PKG_CONFIG_PATH}:/mingw32/lib/pkgconfig")
  ENDIF(CMAKE_SIZEOF_VOID_P EQUAL 8)
ENDIF(MINGW)

FIND_PACKAGE(Threads)

#  CMAKE_THREAD_LIBS_INIT     - the thread library
#  CMAKE_USE_SPROC_INIT       - are we using sproc?
#  CMAKE_USE_WIN32_THREADS_INIT - using WIN32 threads?
#  CMAKE_USE_PTHREADS_INIT    - are we using pthreads
#  CMAKE_HP_PTHREADS_INIT     - are we using hp pthreads

IF(CMAKE_USE_PTHREADS_INIT)
  SET(USE_PTHREAD ON)
  ADD_DEFINITIONS(-DHAVE_PTHREAD)
ELSEIF(CMAKE_USE_WIN32_THREADS_INIT)
  SET(USE_WINTHREAD ON)
  ADD_DEFINITIONS(-DHAVE_WINTHREAD)
ENDIF(CMAKE_USE_PTHREADS_INIT)

MESSAGE(STATUS "CMAKE_SYSTEM_NAME:" ${CMAKE_SYSTEM_NAME})
MESSAGE(STATUS "PLATFORM_ARCH_NAME:" ${PLATFORM_ARCH_NAME})
MESSAGE(STATUS "CMAKE_SYSTEM_PROCESSOR: ${CMAKE_SYSTEM_PROCESSOR}")
MESSAGE(STATUS "CMAKE_HOST_SYSTEM_PROCESSOR: ${CMAKE_HOST_SYSTEM_PROCESSOR}") # cross compiling
MESSAGE(STATUS "CMAKE_SYSTEM: ${CMAKE_SYSTEM}")
MESSAGE(STATUS "CMAKE_CXX_COMPILER_ID: ${CMAKE_CXX_COMPILER_ID}")
MESSAGE(STATUS "CMAKE_USE_PTHREADS_INIT : ${CMAKE_USE_PTHREADS_INIT}")

##################### Libraries search ###################
IF(PLATFORM_X86_64)
  SET_PROPERTY(GLOBAL PROPERTY FIND_LIBRARY_USE_LIB64_PATHS 1)
ELSEIF(PLATFORM_I386)
  SET_PROPERTY(GLOBAL PROPERTY FIND_LIBRARY_USE_LIB64_PATHS 0)
ELSEIF(PLATFORM_ARM)
ELSE()
  MESSAGE(FATAL_ERROR "Unknown platform: ${PLATFORM_ARCH_NAME}")
ENDIF(PLATFORM_X86_64)

IF(CMAKE_BUILD_TYPE)
  STRING(TOUPPER ${CMAKE_BUILD_TYPE} CMAKE_BUILD_TYPE_STABLE)
  MESSAGE(STATUS "CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE_STABLE}")
ENDIF(CMAKE_BUILD_TYPE)

SET(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_LIST_DIR}/")

SET(RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/build/bin)
SET(LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/build/lib)

# Output directory in which to build RUNTIME target files.
SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${RUNTIME_OUTPUT_DIRECTORY})
# Output directory in which to build LIBRARY target files
SET(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${LIBRARY_OUTPUT_DIRECTORY})
# Output directory in which to build ARCHIVE target files.
SET(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${LIBRARY_OUTPUT_DIRECTORY})

INCLUDE(projecthelper)
INCLUDE(utils)

FIND_PACKAGE(BZip2)
IF(BZIP2_FOUND)
  ADD_DEFINITIONS(-DHAVE_BZIP2)
ENDIF(BZIP2_FOUND)

FIND_PACKAGE(ZLIB)
IF(ZLIB_FOUND)
  ADD_DEFINITIONS(-DHAVE_ZLIB)
ENDIF(ZLIB_FOUND)

FIND_PACKAGE(LZ4)
IF(LZ4_FOUND)
  ADD_DEFINITIONS(-DHAVE_LZ4)
ENDIF(LZ4_FOUND)

FIND_PACKAGE(Snappy)
IF(SNAPPY_FOUND)
  ADD_DEFINITIONS(-DHAVE_SNAPPY)
ENDIF(SNAPPY_FOUND)

IF(QT_ENABLED)
  INCLUDE(${CMAKE_CURRENT_LIST_DIR}/integrate-qt.cmake)
  ADD_DEFINITIONS(-DQT_ENABLED)
ENDIF(QT_ENABLED)

IF(DEVELOPER_ENABLE_TESTS)
  INCLUDE(testing)
  SETUP_TESTING()
ENDIF(DEVELOPER_ENABLE_TESTS)

IF(DEVELOPER_CHECK_STYLE)
  SET(CMAKE_EXPORT_COMPILE_COMMANDS ON)
ENDIF(DEVELOPER_CHECK_STYLE)
