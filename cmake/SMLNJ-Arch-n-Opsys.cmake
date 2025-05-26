## cmake/SMLNJ-Arch-n-Opsys.cmake
##
## COPYRIGHT (c) 2025 Skye Soss
## All rights reserved.
##
## Determine the architecture and operating system.
## The logic in this file should match that of `config/_arch-n-opsys`
## This module sets the following variables:
##   SML_SIZE - The executable pointer size. Either 32 or 64.
##   SML_OPSYS - The operating system.
##      aix, darwin, sunos, solaris, linux, freebsd, openbsd, netbsd, windows, cygwin
##   SML_ARCH - The architecture
##      sparc, x86, x86_64, ppc, ppc64
##   SML_HEAP_SUFFIX - The heap suffix.
##      Normally $ARCH-$OPSYS, but is sometimes different.
##   SML_BOOT_ARCHIVE - The name of the bootfile.
##      boot.<arch>-unix or boot.<arch>-win32
##
## Note: If SML_OPSYS, SML_ARCH, and SML_HEAP_SUFFIX are all defined already,
## this module will not redefine them.
## If you are having trouble getting the right values set,
## pass them in as CMake variables, for example:
## $ cmake -S . -B _build \
##     -DSML_OPSYS=linux \
##     -DSML_ARCH=amd64 \
##     -DSML_HEAP_SUFFIX=amd64-unix \
##     -DSML_BOOT_ARCHIVE=boot.amd64-unix

# SML_SIZE - 32 or 64
if(NOT DEFINED SML_SIZE)
    math(EXPR SML_SIZE "${CMAKE_SIZEOF_VOID_P} * 8")
    if(NOT SML_SIZE EQUAL 32 AND NOT SML_SIZE EQUAL 64)
        message(FATAL_ERROR "Invalid pointer size of ${CMAKE_SIZEOF_VOID_P} bytes")
    endif()
endif()

if(NOT DEFINED SML_OPSYS
        OR NOT DEFINED SML_ARCH
        OR NOT DEFINED SML_HEAP_SUFFIX
        OR NOT DEFINED SML_BOOT_ARCHIVE)

    message(CHECK_START "Determining SML_OPSYS, SML_ARCH, SML_HEAP_SUFFIX")
    list(APPEND CMAKE_MESSAGE_INDENT "  ")

    message(VERBOSE "CMAKE_SYSTEM_NAME      = ${CMAKE_SYSTEM_NAME}")
    message(VERBOSE "CMAKE_SYSTEM_VERSION   = ${CMAKE_SYSTEM_VERSION}")
    message(VERBOSE "CMAKE_SYSTEM_PROCESSOR = ${CMAKE_SYSTEM_PROCESSOR}")
    message(VERBOSE "CMAKE_SIZEOF_VOID_P    = ${CMAKE_SIZEOF_VOID_P}")

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
    if(NOT SML_OPSYS OR NOT SML_ARCH OR NOT SML_HEAP_SUFFIX)
        message(FATAL_ERROR "Unable to properly set architecture variables")
    endif()

    list(POP_BACK CMAKE_MESSAGE_INDENT)
endif()

