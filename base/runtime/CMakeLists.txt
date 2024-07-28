
# include(CheckTypeSize)

# ## Generate ml-sizes.h
# block(SCOPE_FOR VARIABLES)
#     if(${SML_SIZE} EQUAL 32)
#         set(WORD_SZB 4)
#         set(LOG_BYTES_PER_WORD 2)
#     else()
#         set(WORD_SZB 8)
#         set(LOG_BYTES_PER_WORD 3)
#     endif()
#     math(EXPR LOG_BITS_PER_WORD "${LOG_BYTES_PER_WORD} + 3")
#     math(EXPR WORD_SZB "1 << ${LOG_BYTES_PER_WORD}")
#     math(EXPR BITS_PER_WORD "8 * ${WORD_SZB}")
#     set(ADDR_SZB ${CMAKE_SIZEOF_VOID_P})

#     check_type_size("short"     SHORT_SIZE BUILTIN_TYPES_ONLY)
#     check_type_size("int"       INT_SIZE   BUILTIN_TYPES_ONLY)
#     check_type_size("long"      LONG_SIZE  BUILTIN_TYPES_ONLY)
#     check_type_size("long long" LLONG_SIZE BUILTIN_TYPES_ONLY)
#     check_type_size("double"    REALD_SZB  BUILTIN_TYPES_ONLY)

#     if(SHORT_SIZE EQUAL 2)
#         set(INT16 "short")
#     else()
#         message(FATAL_ERROR "No 16-bit integer type (sizeof(short) = ${SHORT_SIZE})")
#     endif()
#     if(INT_SIZE EQUAL 4)
#         set(INT32 "int")
#     elseif(LONG_SIZE EQUAL 4)
#         set(INT32 "long")
#     else()
#         message(FATAL_ERROR "No 32-bit integer type")
#     endif()
#     if(LONG_SIZE EQUAL 8)
#         set(INT64 "long")
#     elseif(LLONG_SIZE EQUAL 8)
#         set(INT64 "long long")
#     else()
#         message(FATAL_ERROR "No 64-bit integer type")
#     endif()

#     if(CMAKE_C_BYTE_ORDER STREQUAL "BIG_ENDIAN")
#         set(BYTE_ORDER_BIG ON)
#     elseif(CMAKE_C_BYTE_ORDER STREQUAL "LITTLE_ENDIAN")
#         set(BYTE_ORDER_LITTLE ON)
#     else()
#         message(FATAL_ERROR "Invalid endian")
#     endif()

#     configure_file(
#         include/ml-sizes.h.in
#         ${CMAKE_CURRENT_BINARY_DIR}/include/ml-sizes.h)
# endblock()

# ## Generate ml-regmask.h
# block(SCOPE_FOR VARIABLES)
#     set(CALLEESAVE 3) # TODO
#     set(FLOAT_CALLEESAVE 0)
#     math(EXPR FUN_MASK "((1 << (${CALLEESAVE} + 4)) - 1)" OUTPUT_FORMAT HEXADECIMAL)
#     if(CALLEESAVE GREATER 0)
#         math(EXPR RET_MASK "((1 << (${CALLEESAVE} + 4)) - 0x10 + 0xc)" OUTPUT_FORMAT HEXADECIMAL)
#     else()
#         set(RET_MASK 0xd)
#     endif()
#     set(CONT_MASK ${FUN_MASK})
#     set(EXN_MASK ${FUN_MASK})

#     configure_file(
#         include/ml-regmask.h.in
#         ${CMAKE_CURRENT_BINARY_DIR}/include/ml-regmask.h)
# endblock()

# ## Generate system-signals.h
# # XXX
# block(SCOPE_FOR VARIABLES)
#     set(NUM_SYSTEM_SIGS 0)
#     set(MIN_SYSTEM_SIG 0)
#     set(MAX_SYSTEM_SIG 0)
#     set(NUM_SIGS 0)
#     set(SIGMAP_SZ 1)
#     set(SIGNAL_DEFINITIONS "")

#     configure_file(
#         include/system-signals.h.in
#         ${CMAKE_CURRENT_BINARY_DIR}/include/system-signals.h)
# endblock()

# Target for defines
add_library(sml-runtime INTERFACE)
target_include_directories(sml-runtime
    INTERFACE
    include
)
target_compile_features(sml-runtime
    INTERFACE
    c_std_99
)
# TODO: determine these programatically
target_compile_definitions(sml-runtime
    INTERFACE
    OPSYS_UNIX
    OPSYS_LINUX
    ARCH_AMD64
    SIZE_64
    GNU_ASSEMBLER
    DLOPEN
    INDIRECT_CFUNC
    _GNU_SOURCE
)

add_subdirectory(config)
add_subdirectory(memory)
add_subdirectory(c-libs)
add_subdirectory(gc)
add_subdirectory(mp)
add_subdirectory(mach-dep)

add_library(sml-prim STATIC
    objs/prim.s
)
target_link_libraries(sml-prim
    PRIVATE
    sml-runtime
    runtime-generated
)

add_subdirectory(kernel)

# add_executable(runtime
#     kernel/main.c
# )

