if (NOT DEEPSTREAM_SDK_PATH)
	set(DEEPSTREAM_SDK_PATH "/opt/nvidia/deepstream")
endif()

file(GLOB DEEPSTREAM_VERSIONED_DIRS "${DEEPSTREAM_SDK_PATH}/deepstream-*")
find_path(DeepStream_INCLUDE_DIR nvdsinfer.h HINTS ${DEEPSTREAM_VERSIONED_DIRS} PATH_SUFFIXES "sources/includes")

find_library(DeepStream_LIBRARY NAMES nvds_infer HINTS ${DEEPSTREAM_VERSIONED_DIRS} PATH_SUFFIXES lib)

if(DeepStream_INCLUDE_DIR AND EXISTS "${DeepStream_INCLUDE_DIR}/nvds_version.h")
	file(STRINGS "${DeepStream_INCLUDE_DIR}/nvds_version.h" deepstream_version_strs REGEX "^#define NVDS_VERSION.*")

	set(VERSIONS "")
	foreach(version_str ${deepstream_version_strs})
		string(REGEX MATCH "[0-9]" version_part "${version_str}")
		list(APPEND VERSIONS ${version_part})
	endforeach()
	string(REPLACE ";" "." DeepStream_VERSION_STRING "${VERSIONS}")
	unset(VERSIONS)
	unset(deepstream_version_strs)
endif()


include(FindPackageHandleStandardArgs)

FIND_PACKAGE_HANDLE_STANDARD_ARGS(DeepStream REQUIRED_VARS DeepStream_INCLUDE_DIR DeepStream_LIBRARY VERSION_VAR DeepStream_VERSION_STRING)

if (DeepStream_FOUND)
	set(DeepStream_INCLUDE_DIRS ${DeepStream_INCLUDE_DIR})
	set(DeepStream_LIBRARIES ${DeepStream_LIBRARY})

	if (NOT TARGET DeepStream::DeepStream)
		add_library(DeepStream::DeepStream UNKNOWN IMPORTED)
		set_target_properties(DeepStream::DeepStream PROPERTIES
			INTERFACE_INCLUDE_DIRECTORIES "${DeepStream_INCLUDE_DIRS}"
			IMPORTED_LOCATION "${DeepStream_LIBRARIES}")
	endif()
endif()

mark_as_advanced(DeepStream_INCLUDE_DIR DeepStream_LIBRARY)
