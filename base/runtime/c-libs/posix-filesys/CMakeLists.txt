
add_library(posix-filesys STATIC
    cfun-list.h
    cfun-proto-list.h
    ${CMAKE_CURRENT_BINARY_DIR}/ml_pathconf.h

    access.c
    chdir.c
    chmod.c
    chown.c
    closedir.c
    fchmod.c
    fchown.c
    ftruncate.c
    getcwd.c
    link.c
    mkdir.c
    mkfifo.c
    opendir.c
    openf.c
    osval.c
    pathconf.c
    posix-filesys-lib.c
    readdir.c
    readlink.c
    rename.c
    rewinddir.c
    rmdir.c
    stat.c
    symlink.c
    umask.c
    unlink.c
    utime.c
)
target_link_libraries(posix-filesys
    PRIVATE
    sml-clibs
)
target_include_directories(posix-filesys
    PRIVATE
    ${CMAKE_CURRENT_BINARY_DIR}
)

# TODO: Implement this in CMake
add_custom_command(
    OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/ml_pathconf.h"
    COMMAND 
    ${CMAKE_COMMAND} -E env VERSION=${PROJECT_VERSION}
        "${CMAKE_CURRENT_SOURCE_DIR}/../../config/gen-posix-names.sh" "_PC_" "ml_pathconf.h"
    WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
)
