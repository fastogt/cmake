SET(THREE_PART_VERSION_REGEX "[0-9]+\\.[0-9]+\\.[0-9]+")

# Breaks up a string in the form n1.n2.n3 into three parts and stores
# them in major, minor, and patch.  version should be a value, not a
# variable, while major, minor and patch should be variables.
MACRO(THREE_PART_VERSION_TO_VARS version major minor patch)
  IF(${version} MATCHES ${THREE_PART_VERSION_REGEX})
    STRING(REGEX REPLACE "^([0-9]+)\\.[0-9]+\\.[0-9]+" "\\1" ${major} "${version}")
    STRING(REGEX REPLACE "^[0-9]+\\.([0-9])+\\.[0-9]+" "\\1" ${minor} "${version}")
    STRING(REGEX REPLACE "^[0-9]+\\.[0-9]+\\.([0-9]+)" "\\1" ${patch} "${version}")
  ELSE(${version} MATCHES ${THREE_PART_VERSION_REGEX})
    MESSAGE("MACRO(THREE_PART_VERSION_TO_VARS ${version} ${major} ${minor} ${patch}")
    MESSAGE(FATAL_ERROR "Problem parsing version string, I can't parse it properly.")
  ENDIF(${version} MATCHES ${THREE_PART_VERSION_REGEX})
ENDMACRO(THREE_PART_VERSION_TO_VARS)