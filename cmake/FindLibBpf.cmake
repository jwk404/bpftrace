# - Try to find libbpf
# Once done this will define
#
#  LIBBPF_FOUND - system has libbpf
#  LIBBPF_INCLUDE_DIRS - the libbpf include directory
#  LIBBPF_LIBRARIES - Link these to use libbpf
#  LIBBPF_DEFINITIONS - Compiler switches required for using libbpf

#if (LIBBPF_LIBRARIES AND LIBBPF_INCLUDE_DIRS)
#  set (LibBpf_FIND_QUIETLY TRUE)
#endif (LIBBPF_LIBRARIES AND LIBBPF_INCLUDE_DIRS)

if (USE_SYSTEM_BPF_BCC)
  find_path (LIBBPF_INCLUDE_DIRS
    NAMES
      bpf/bpf.h
      bpf/btf.h
      bpf/libbpf.h
    PATHS
      ENV CPATH)

  find_library (LIBBPF_LIBRARIES
    NAMES
      bpf
    PATHS
      ENV LIBRARY_PATH
      ENV LD_LIBRARY_PATH)
  set(LIBBPF_ERROR_MESSAGE "Please install the libbpf development package")
else()
  # Use static linking with vendored libbpf
  set(SAVED_CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES})
  set(CMAKE_FIND_LIBRARY_SUFFIXES ".a")
  set(SAVED_CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH})
  set(CMAKE_PREFIX_PATH ${BPF_BCC_PREFIX_PATH})
  find_path (LIBBPF_INCLUDE_DIRS
    NAMES
      bpf/bpf.h
      bpf/btf.h
      bpf/libbpf.h
    NO_CMAKE_SYSTEM_PATH)

  find_library (LIBBPF_LIBRARIES
    NAMES
      bpf
    NO_CMAKE_SYSTEM_PATH)
  set(CMAKE_PREFIX_PATH ${SAVED_CMAKE_PREFIX_PATH})
  set(LIBBPF_ERROR_MESSAGE "Please run ${CMAKE_SOURCE_DIR}/build-libs.sh from the build folder first")
  set(CMAKE_FIND_LIBRARY_SUFFIXES ${SAVED_CMAKE_FIND_LIBRARY_SUFFIXES})
endif()

include (FindPackageHandleStandardArgs)

# handle the QUIETLY and REQUIRED arguments and set LIBBPF_FOUND to TRUE if all listed variables are TRUE
FIND_PACKAGE_HANDLE_STANDARD_ARGS(LibBpf ${LIBBPF_ERROR_MESSAGE}
  LIBBPF_LIBRARIES
  LIBBPF_INCLUDE_DIRS)

mark_as_advanced(LIBBPF_INCLUDE_DIRS LIBBPF_LIBRARIES)

INCLUDE(CheckCXXSourceCompiles)
SET(CMAKE_REQUIRED_INCLUDES ${LIBBPF_INCLUDE_DIRS})
SET(CMAKE_REQUIRED_LIBRARIES ${LIBBPF_LIBRARIES} elf z)

CHECK_CXX_SOURCE_COMPILES("
#include <bpf/bpf.h>

int main(void) {
  DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);

  opts.uprobe_multi.flags = 0;
  return 0;
}
" HAVE_LIBBPF_UPROBE_MULTI)
SET(CMAKE_REQUIRED_INCLUDES)
SET(CMAKE_REQUIRED_LIBRARIES)
