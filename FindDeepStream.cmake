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

set(DeepStream_LIBRARY_NAMES
	libnvbufsurface.so
	libnvds_infer.so
	libnvds_msgconv.so
	libnvbufsurftransform.so
	libnvds_amqp_proto.so
	libnvds_inferutils.so
	libnvds_nvdcf.so
	libnvds_azure_edge_proto.so
	libnvds_kafka_proto.so
	libnvds_nvtxhelper.so
	libnvds_azure_proto.so
	libnvds_logger.so
	libnvds_csvparser.so
	libnvds_meta.so
	libnvds_osd.so
	libnvdsgst_helper.so
	libnvds_mot_iou.so
	libnvds_utils.so
	libnvdsgst_meta.so
	libnvds_mot_klt.so
	)

if (DeepStream_FOUND)
	set(DeepStream_INCLUDE_DIRS ${DeepStream_INCLUDE_DIR})

	get_filename_component(DeepStream_LIBRARY_DIR ${DeepStream_LIBRARY} DIRECTORY)
	string(REGEX REPLACE "([^;]+)" "${DeepStream_LIBRARY_DIR}/\\1" DeepStream_LIBRARIES "${DeepStream_LIBRARY_NAMES}")

	if (NOT TARGET DeepStream::DeepStream)
		add_library(DeepStream::DeepStream INTERFACE IMPORTED)
		set_target_properties(DeepStream::DeepStream PROPERTIES
			INTERFACE_INCLUDE_DIRECTORIES "${DeepStream_INCLUDE_DIRS}"
			INTERFACE_LINK_LIBRARIES "${DeepStream_LIBRARIES}"
			)
	endif()
endif()

mark_as_advanced(DeepStream_INCLUDE_DIR DeepStream_LIBRARY)
