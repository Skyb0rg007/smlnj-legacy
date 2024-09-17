cmake_minimum_required(VERSION 3.29 FATAL_ERROR)
project(smlnj
    VERSION 110.99.5.1
    DESCRIPTION "Compiler for the Standard ML '97 language"
    HOMEPAGE_URL "smlnj.org"
    LANGUAGES C ASM
)

include(GNUInstallDirs)

find_program(SMLNJ_EXE sml REQUIRED)

math(EXPR SML_SIZE "${CMAKE_SIZEOF_VOID_P} * 8")
if(NOT SML_SIZE EQUAL 32 AND NOT SML_SIZE EQUAL 64)
    message(FATAL_ERROR "Invalid SML_SIZE")
endif()
message(STATUS "Building SML/NJ with ${SML_SIZE}-bit pointers")

# TODO: make this a cache variable
if(LINUX)
    set(SML_OPSYS "linux")
else()
    message(FATAL_ERROR "nyi")
endif()

# TODO: calculate this
set(SML_TARGET "AMD64")

# Determine arch and operating system
# TODO: Implement this for more systems
if(CMAKE_SYSTEM_PROCESSOR STREQUAL "x86_64")
    set(SML_ARCH "x86_64")
else()
    message(FATAL_ERROR "nyi")
endif()
set(SML_HEAP_OPSYS "${SML_ARCH}-${SML_OPSYS}")

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

add_subdirectory(base/runtime)
