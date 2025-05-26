## base/runtime/c-libs/smlnj-sockets/CMakeLists.txt
##
## COPYRIGHT (c) 2025 Skye Soss
## All rights reserved.
##
## Defines the following public CMake targets:
## - smlnj-sock
##     SML/NJ C library that defines socket functions

add_library(smlnj-sock STATIC
    cfun-list.h
    cfun-proto-list.h
    sock-util.h
    sockets-osdep.h

    # NetDB
    gethostbyaddr.c
    gethostbyname.c
    gethostname.c
    getnetbyaddr.c
    getnetbyname.c
    getprotbyname.c
    getprotbynum.c
    getservbyname.c
    getservbyport.c

    # Control
    ctlBROADCAST.c
    ctlDEBUG.c
    ctlDONTROUTE.c
    ctlKEEPALIVE.c
    ctlLINGER.c
    ctlNODELAY.c
    ctlOOBINLINE.c
    ctlRCVBUF.c
    ctlREUSEADDR.c
    ctlSNDBUF.c
    getATMARK.c
    getERROR.c
    getNREAD.c
    getTYPE.c
    getpeername.c
    getsockname.c
    setNBIO.c

    # Socket
    accept.c
    bind.c
    close.c
    connect.c
    listen.c
    shutdown.c
    socket.c

    # IO
    recv.c
    recvbuf.c
    recvbuffrom.c
    recvfrom.c
    sendbuf.c
    sendbufto.c

    # Miscellaneous
    from-inetaddr.c
    getaddrfamily.c
    inetany.c
    list-addr-families.c
    list-sock-types.c
    to-inetaddr.c

    # Util
    tbl-addr-family.c
    tbl-sock-type.c
    util-mkhostent.c
    util-mknetent.c
    util-mkservent.c
    util-sockopt.c

    smlnj-sock-lib.c
)
if(UNIX)
    target_sources(smlnj-sock PRIVATE
        from-unixaddr.c
        to-unixaddr.c
        socketpair.c
    )
endif()
target_link_libraries(smlnj-sock
    PRIVATE
    sml-clibs
)
