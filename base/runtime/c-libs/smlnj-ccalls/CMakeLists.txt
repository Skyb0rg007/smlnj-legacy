
add_library(smlnj-ccalls STATIC
    cfun-list.h
    cfun-proto-list.h
    c-calls.h

    c-calls-fns.c
    c-calls-lib.c
    c-calls.c
    cutil.c
    c-entry.asm
)
set_source_files_properties(
    c-entry.asm
    PROPERTIES COMPILE_DEFINITIONS _ASM_
)
target_link_libraries(smlnj-ccalls
    PRIVATE
    sml-clibs
)
