## CMakeLists.txt
##
## COPYRIGHT (c) 2025 Skye Soss
## All rights reserved.
##
## CMake build system for the legacy SML/NJ compiler
## Note that this build script is not as configurable as it could be,
## since it must be compatible with the shell-based build system.
##   
## To build, run:
## $ cmake -S . -B _build
## $ cmake --build _build --target sml-heap

cmake_minimum_required(VERSION 3.29 FATAL_ERROR)
file(READ "${CMAKE_CURRENT_LIST_DIR}/config/version" config_version)
string(STRIP "${config_version}" SMLNJ_VERSION)
project(smlnj
    VERSION "${SMLNJ_VERSION}"
    DESCRIPTION "Compiler for the Standard ML '97 programming language"
    HOMEPAGE_URL "https://smlnj.org"
    LANGUAGES C ASM
)

include(GNUInstallDirs)
include(FetchContent)

# If `sml` can be found, we can potentially skip the bootstrap process
# TODO
find_program(SMLNJ_EXE sml)

# Computes SML_SIZE, SML_OPSYS, SML_ARCH, SML_HEAP_SUFFIX
include(cmake/SMLNJ-Arch-n-Opsys.cmake)

# Declares bootfiles
include(cmake/SMLNJ-Bootfiles.cmake)

message(STATUS "Building SML/NJ with ${SML_SIZE}-bit pointers")

##############################################################################

# TODO: determine this via code generation
set(GLOBALS_HAVE_UNDERSCORE OFF)

list(APPEND SML_AUTOLOADS
    ### BASICS ###

    # The SML Basis library
    "$smlnj/basis/basis.cm"

    # The Compilation Manager (structure CM)
    "$smlnj/cm.cm"

    # The "Util" portion of the SML/NJ Library
    "$smlnj/smlnj-lib/smlnj-lib.cm"

    ### ADDITIONAL LIBRARIES ###

    # The "Pretty-Printing" portion of the SML/NJ Library
    #"$smlnj/smlnj-lib/pp-lib.cm"

    # The "Configurable Controls" portion of the SML/NJ Library
    #"$smlnj/smlnj-lib/controls-lib.cm"

    # The "HTML3" portion of the SML/NJ Library
    #"$smlnj/smlnj-lib/html-lib.cm"

    ### FOR SML/NJ COMPILER HACKERS ###

    # The Visible Compiler (collection of structures)
    "$smlnj/compiler.cm"

    # The Visible Compiler (old style: structure Compiler)
    #"$smlnj/compiler/compiler.cm"

    # If you don't autoload the old-style visible compiler above, then
    # you should make a minimal version of it available so that
    # Compiler.version as well as Compiler.achitecture are available:
    "$smlnj/compiler/minimal.cm"

    # The Bootstrap Compilation Manager (structure CMB)
    #"$smlnj/cmb.cm"

    # Cross-compiler version of CMB for alpha, hppa, ppc, sparc, x86 on unix, macos, win32
    #"$smlnj/cmb/alpha32-unix.cm"
    #"$smlnj/cmb/hppa-unix.cm"
    #"$smlnj/cmb/ppc-macos.cm"
    #"$smlnj/cmb/ppc-unix.cm"
    #"$smlnj/cmb/sparc-unix.cm"
    #"$smlnj/cmb/x86-unix.cm"
    #"$smlnj/cmb/x86-win32.cm"

    # All cross-compiler versions of CMB at once
    #"$smlnj/compiler/all.cm"
)

set(SML_DEFAULT_ALLOC "512k")

if(APPLE)
    # Assembler options, check to see if this is still needed in CMake
endif()

##

add_subdirectory(base/runtime runtime)

## TODO: Move this to a subdirectory for bootstrapping

set(bootfile "${SML_BOOT_ARCHIVE}.${PROJECT_VERSION}")
FetchContent_MakeAvailable("${bootfile}")

cmake_path(GET "${bootfile}_SOURCE_DIR"
    PARENT_PATH boot_archive_parent_dir
)

# TODO: preloads.standard should be configurable
add_custom_command(
    OUTPUT
        "${boot_archive_parent_dir}/preloads.standard"
    COMMAND
        ${CMAKE_COMMAND} -E copy
        "${CMAKE_SOURCE_DIR}/config/preloads"
        "${boot_archive_parent_dir}/preloads.standard"
)

# TODO: Move this to a "bootstrap" subdirectory
add_custom_command(
    OUTPUT
        "${CMAKE_CURRENT_BINARY_DIR}/sml.${SML_HEAP_SUFFIX}"
    COMMAND $<TARGET_FILE:kernel>
        "-${SML_SIZE}"
        "@SMLboot=BOOTLIST"
        "@SMLheap=${CMAKE_CURRENT_BINARY_DIR}/sml"
        "@SMLalloc=${SML_DEFAULT_ALLOC}"
    VERBATIM
    DEPENDS
        "${boot_archive_parent_dir}/preloads.standard"
    WORKING_DIRECTORY
        "${${bootfile}_SOURCE_DIR}"
)

add_custom_target(
    sml-heap
    ALL
    DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/sml.${SML_HEAP_SUFFIX}"
)

file(GENERATE OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/bin/sml"
    CONTENT "\
#!/bin/sh
exec '$<TARGET_FILE:kernel>' @SMLcmdname=\"$0\" \
@SMLload='${CMAKE_CURRENT_BINARY_DIR}/sml.${SML_HEAP_SUFFIX}' \
@SMLalloc=${SML_DEFAULT_ALLOC} \
\"$@\"\n\
"
    FILE_PERMISSIONS OWNER_EXECUTE OWNER_READ
)

file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/lib")

file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/lib/pathconfig" [[
SMLNJ-BASIS SMLNJ-BASIS
SMLNJ-LIB SMLNJ-LIB
SMLNJ-ML-YACC-LIB SMLNJ-ML-YACC-LIB
SMLNJ-MLRISC SMLNJ-MLRISC
compiler compiler
dir-tool.cm dir-tool.cm
make-tool.cm make-tool.cm
noweb-tool.cm noweb-tool.cm
nw-ext.cm nw-ext.cm
pgraph.cm pgraph.cm
pickle-lib.cm pickle-lib.cm
shell-tool.cm shell-tool.cm
smlnj smlnj
]])

set(BINDIR "${CMAKE_CURRENT_BINARY_DIR}/bin")
set(LIBDIR "${CMAKE_CURRENT_BINARY_DIR}/lib")
set(SIZE "${SML_SIZE}")
set(CMDIRARC ".cm")
configure_file(
    "${PROJECT_SOURCE_DIR}/config/_ml-build"
    "${CMAKE_CURRENT_BINARY_DIR}/bin/ml-build"
    FILE_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE
)

add_custom_target(
    sml-install
    COMMAND
        ${CMAKE_COMMAND} -E copy_directory
            "${${bootfile}_SOURCE_DIR}/SMLNJ-BASIS"
            "${${bootfile}_SOURCE_DIR}/SMLNJ-LIB"
            "${${bootfile}_SOURCE_DIR}/SMLNJ-ML-YACC-LIB"
            "${${bootfile}_SOURCE_DIR}/SMLNJ-MLRISC"
            "${${bootfile}_SOURCE_DIR}/compiler"
            "${${bootfile}_SOURCE_DIR}/dir-tool.cm"
            "${${bootfile}_SOURCE_DIR}/make-tool.cm"
            "${${bootfile}_SOURCE_DIR}/noweb-tool.cm"
            "${${bootfile}_SOURCE_DIR}/nw-ext.cm"
            "${${bootfile}_SOURCE_DIR}/pgraph.cm"
            "${${bootfile}_SOURCE_DIR}/pickle-lib.cm"
            "${${bootfile}_SOURCE_DIR}/shell-tool.cm"
            "${${bootfile}_SOURCE_DIR}/smlnj"
            "${CMAKE_CURRENT_BINARY_DIR}/lib"
    COMMAND
        ${CMAKE_COMMAND} -E env
        "ROOT=${PROJECT_SOURCE_DIR}"
        "INSTALLDIR=${CMAKE_CURRENT_BINARY_DIR}"
        "CONFIGDIR=${PROJECT_SOURCE_DIR}/config"
        "BINDIR=${CMAKE_CURRENT_BINARY_DIR}/bin"
        "${CMAKE_CURRENT_BINARY_DIR}/bin/sml"
        -m "$smlnj/installer.cm"
    VERBATIM
    DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/sml.${SML_HEAP_SUFFIX}"
)
