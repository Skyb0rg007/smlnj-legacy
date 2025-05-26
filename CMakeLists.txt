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
## $ # Configure the build directory
## $ cmake -S . -B _build
## $ # Build the SML/NJ compiler
## $ cmake --build _build --target smlnj

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

find_program(SMLNJ_EXE sml REQUIRED)

# SML_SIZE - 32 or 64
math(EXPR SML_SIZE "${CMAKE_SIZEOF_VOID_P} * 8")
if(NOT SML_SIZE EQUAL 32 AND NOT SML_SIZE EQUAL 64)
    message(FATAL_ERROR "Invalid pointer size of ${CMAKE_SIZEOF_VOID_P} bytes")
endif()
message(STATUS "Building SML/NJ with ${SML_SIZE}-bit pointers")

### arch-n-opsys #############################################################
# Compute SML_OPSYS, SML_ARCH, SML_HEAP_SUFFIX

message(STATUS "Determining SML_OPSYS, SML_ARCH, SML_HEAP_SUFFIX")
message(STATUS "CMAKE_SYSTEM_NAME      = ${CMAKE_SYSTEM_NAME}")
message(STATUS "CMAKE_SYSTEM_VERSION   = ${CMAKE_SYSTEM_VERSION}")
message(STATUS "CMAKE_SYSTEM_PROCESSOR = ${CMAKE_SYSTEM_PROCESSOR}")
message(STATUS "CMAKE_SIZEOF_VOID_P    = ${CMAKE_SIZEOF_VOID_P}")

macro(pick_arch arch32 arch64)
    if(CMAKE_SIZEOF_VOID_P EQUAL 4)
        set(SML_ARCH "${arch32}")
    elseif(CMAKE_SIZEOF_VOID_P EQUAL 8)
        set(SML_ARCH "${arch64}")
    else()
        message(FATAL_ERROR "Invalid pointer size of ${CMAKE_SIZEOF_VOID_P} bytes")
    endif()
    set(SML_HEAP_SUFFIX "${SML_ARCH}-${SML_OPSYS}")
endmacro()

if(CMAKE_SYSTEM_NAME STREQUAL "AIX")
    set(SML_OPSYS "aix")
    pick_arch("ppc" "ppc64")

elseif(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    set(SML_OPSYS "darwin")
    if(CMAKE_SYSTEM_PROCESSOR STREQUAL "powerpc")
        pick_arch("ppc" "ppc64")
        if(NOT CMAKE_SYSTEM_VERSION MATCHES "^(8|9|10)")
            message(FATAL_ERROR "Darwin powerpc unsupported version ${CMAKE_SYSTEM_VERSION}")
        endif()
    elseif(CMAKE_SYSTEM_PROCESSOR STREQUAL "i386")
        pick_arch("x86" "amd64")
        if(CMAKE_SYSTEM_VERSION MATCHES "^9")
            set(SML_HEAP_SUFFIX "${SML_ARCH}-darwinz")
        elseif(CMAKE_SYSTEM_VERSION MATCHES "^(19|20|21|22|23|24)"
                AND CMAKE_SIZEOF_VOID_P EQUAL 4)
            message(FATAL_ERROR "${CMAKE_SYSTEM} only supports 64-bit executables")
        elseif(NOT CMAKE_SYSTEM_VERSION MATCHES "^1[0-8]")
            message(FATAL_ERROR "${CMAKE_SYSTEM} unsupported")
        endif()
    elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "^arm")
        message(FATAL_ERROR "Native ARM is not supported -- reconfigure with CMAKE_APPLE_SILICON_PROCESSOR set to \"x86_64\"")
    else()
        message(FATAL_ERROR "Darwin with unsupported processor ${CMAKE_SYSTEM_PROCESSOR}")
    endif()

elseif(CMAKE_SYSTEM_NAME STREQUAL "SunOS")
    if(CMAKE_SYSTEM_VERSION MATCHES "^4\\.")
        set(SML_OPSYS "sunos")
        if(CMAKE_SYSTEM_PROCESSOR STREQUAL "sparc")
            set(SML_ARCH "sparc")
        else()
            message(FATAL_ERROR "${CMAKE_SYSTEM} with unsupported architecture ${CMAKE_SYSTEM_PROCESSOR}")
        endif()
    elseif(CMAKE_SYSTEM_VERSION MATCHES "^5\\.")
        set(SML_OPSYS "solaris")
        if(CMAKE_SYSTEM_PROCESSOR STREQUAL "sparc")
            set(SML_ARCH "sparc")
        elseif(CMAKE_SYSTEM_PROCESSOR MATCH "86$")
            set(SML_ARCH "x86")
        else()
            message(FATAL_ERROR "${CMAKE_SYSTEM} with unsupported architecture ${CMAKE_SYSTEM_PROCESSOR}")
        endif()
    else()
        message(FATAL_ERROR "SunOS with unsupported version ${CMAKE_SYSTEM_VERSION}")
    endif()
    set(SML_HEAP_SUFFIX "${SML_ARCH}-${SML_OPSYS}")

elseif(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    set(SML_OPSYS "linux")
    if(CMAKE_SYSTEM_PROCESSOR STREQUAL "x86_64")
        pick_arch("x86" "amd64")
    elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "86$")
        pick_arch("x86" "amd64")
        if(NOT CMAKE_SYSTEM_VERSION MATCHES "^[3456]\.")
            message(FATAL_ERROR "Linux ${CMAKE_SYSTEM_PROCESSOR} with unsupported version ${CMAKE_SYSTEM_VERSION}")
        endif()
    elseif(CMAKE_SYSTEM_PROCESSOR STREQUAL "ppc")
        pick_arch("ppc" "ppc64")
        # TODO: osfmach
    endif()

elseif(CMAKE_SYSTEM_NAME STREQUAL "FreeBSD")
    set(SML_OPSYS "freebsd")
    if(CMAKE_SYSTEM_PROCESSOR STREQUAL "x86_64"
            OR CMAKE_SYSTEM_PROCESSOR STREQUAL "amd64")
        pick_arch("x86" "amd64")
    elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "86$")
        set(SML_ARCH "x86")
    else()
        message(FATAL_ERROR "FreeBSD with unsupported processor ${CMAKE_SYSTEM_PROCESSOR}")
    endif()
    set(SML_HEAP_SUFFIX "${SML_ARCH}-bsd")

elseif(CMAKE_SYSTEM_NAME STREQUAL "OpenBSD")
    set(SML_OPSYS "openbsd")
    if(CMAKE_SYSTEM_PROCESSOR STREQUAL "x86_64")
        pick_arch("x86" "amd64")
    elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "86$")
        set(SML_ARCH "x86")
    elseif(CMAKE_SYSTEM_PROCESSOR STREQUAL "powerpc")
        set(SML_ARCH "ppc")
    else()
        message(FATAL_ERROR "OpenBSD with unsupported processor ${CMAKE_SYSTEM_PROCESSOR}")
    endif()
    set(SML_HEAP_SUFFIX "${SML_ARCH}-bsd")

elseif(CMAKE_SYSTEM_NAME STREQUAL "NetBSD")
    set(SML_OPSYS "netbsd")
    if(NOT CMAKE_SYSTEM_VERSION MATCHES "^[12]\\.")
        message(FATAL_ERROR "NetBSD with unsupported version ${CMAKE_SYSTEM_VERSION}")
    endif()
    if(CMAKE_SYSTEM_PROCESSOR STREQUAL "x86_64")
        pick_arch("x86" "amd64")
    elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "86$")
        set(SML_ARCH "x86")
    elseif(CMAKE_SYSTEM_PROCESSOR STREQUAL "powerpc")
        set(SML_ARCH "ppc")
    elseif(CMAKE_SYSTEM_PROCESSOR STREQUAL "sparc")
        set(SML_ARCH "sparc")
    else()
        message(FATAL_ERROR "${CMAKE_SYSTEM} with unsupported processor ${CMAKE_SYSTEM_PROCESSOR}")
    endif()
    set(SML_HEAP_SUFFIX "${SML_ARCH}-bsd")

elseif(CMAKE_SYSTEM_NAME STREQUAL "Windows")
    set(SML_OPSYS "win32")
    set(SML_ARCH "x86")
    set(SML_HEAP_SUFFIX "x86-win32")
    if(NOT CMAKE_SIZEOF_VOID_P EQUAL 4)
        message(FATAL_ERROR "${CMAKE_SYSTEM} is only supported with 32-bit executables")
    endif()

elseif(CMAKE_SYSTEM_NAME STREQUAL "CYGWIN")
    if(DEFINED ENV{SMLNJ_WINDOWS_RUNTIME}
            AND NOT $ENV{SMLNJ_WINDOWS_RUNTIME} STREQUAL "")
        set(SML_OPSYS "win32")
    else()
        set(SML_OPSYS "cygwin")
    endif()
    pick_arch("x86" "amd64")

else()
    message(FATAL_ERROR "Unsupported system ${CMAKE_SYSTEM_NAME}")
endif()

if(UNIX)
    set(SML_BOOT_ARCHIVE "boot.${SML_ARCH}-unix")
elseif(WIN32)
    set(SML_BOOT_ARCHIVE "boot.${SML_ARCH}-win32")
else()
    message(FATAL_ERROR "Unsupported system ${CMAKE_SYSTEM}: neither UNIX nor WIN32")
endif()

message(STATUS "SML_OPSYS       = ${SML_OPSYS}")
message(STATUS "SML_ARCH        = ${SML_ARCH}")
message(STATUS "SML_HEAP_SUFFIX = ${SML_HEAP_SUFFIX}")
message(STATUS "BOOT_ARCHIVE    = ${SML_BOOT_ARCHIVE}")
if(NOT SML_OPSYS OR NOT SML_ARCH OR NOT SML_HEAP_SUFFIX)
    message(FATAL_ERROR "Unable to properly set architecture variables")
endif()

##############################################################################

# TODO: calculate this
set(SML_TARGET "AMD64")

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

## Boot files
# TODO: Move to a separate file
# TODO: The FetchContent_Declare calls should also be version-dependent
FetchContent_Declare(
    boot.amd64-unix
    URL https://smlnj.cs.uchicago.edu/dist/working/${PROJECT_VERSION}/boot.amd64-unix.tgz
    URL_HASH SHA256=b9d2dec5a4a77be7caf3badc1166ae4cbd912fb7b22c041c9459477f5df8f064
    TLS_VERIFY true
)
FetchContent_Declare(
    boot.ppc-unix
    URL https://smlnj.cs.uchicago.edu/dist/working/${PROJECT_VERSION}/boot.ppc-unix.tgz
    URL_HASH SHA256=4e165002979fbd9d93e034b9a23f81186744dadf35648d8ff82a4b966e6eacfa
    TLS_VERIFY true
)
FetchContent_Declare(
    boot.sparc-unix
    URL https://smlnj.cs.uchicago.edu/dist/working/${PROJECT_VERSION}/boot.sparc-unix.tgz
    URL_HASH SHA256=d4d71fdade73b234d6f79623d3cca4f5cf2dad966216b70dbe07024b1e49312d
    TLS_VERIFY true
)
FetchContent_Declare(
    boot.x86-unix
    URL https://smlnj.cs.uchicago.edu/dist/working/${PROJECT_VERSION}/boot.x86-unix.tgz
    URL_HASH SHA256=a4d3d6d7699cd7b41c2eafaf83c97c9d8985384cba55b7420254531703972ffa
    TLS_VERIFY true
)
FetchContent_Declare(
    boot.x86-win32
    URL https://smlnj.cs.uchicago.edu/dist/working/${PROJECT_VERSION}/boot.x86-win32.tgz
    URL_HASH SHA256=e783ff41f19b219aa00b24eb3f02c43b3ae75d56a562a69699143a5bedb9f021
    TLS_VERIFY true
)

# Download the boot file necessary to bootstrap the system
FetchContent_MakeAvailable("${SML_BOOT_ARCHIVE}")

##

add_subdirectory(base/runtime)

##

cmake_path(GET "${SML_BOOT_ARCHIVE}_SOURCE_DIR"
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
        "@SMLalloc=512k"
    DEPENDS
        "${boot_archive_parent_dir}/preloads.standard"
    WORKING_DIRECTORY
        "${${SML_BOOT_ARCHIVE}_SOURCE_DIR}"
)

add_custom_target(
    sml-heap
    ALL
    DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/sml.${SML_HEAP_SUFFIX}"
)
