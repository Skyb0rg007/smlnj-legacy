/*! \file mem-writer.c
 *
 * COPYRIGHT (c) 2019 The Fellowship of SML/NJ (http://www.smlnj.org)
 * All rights reserved.
 *
 * An implementation of the abstract writers on top of memory regions.
 */

#include "ml-base.h"
#include "writer.h"
#include <string.h>

typedef struct buffer {
    Byte_t	*base;
    Byte_t	*next;
    Byte_t	*top;
} wr_buffer_t;

PVT void MemPut (writer_t *wr, Word_t w);
PVT void MemWrite (writer_t *wr, const void *data, Addr_t nbytes);
PVT void MemFlush (writer_t *wr);
PVT off_t MemTell (writer_t *wr);
PVT void MemSeek (writer_t *wr, off_t offset);
PVT void MemFree (writer_t *wr);

#define BufOf(wr)	((wr_buffer_t *)((wr)->data))

/* WR_OpenMem:
 *
 * Open a file for writing, and make a writer for it.
 */
writer_t *WR_OpenMem (Byte_t *data, Addr_t len)
{
    wr_buffer_t	*bp;
    writer_t	*wr;

    bp = NEW_OBJ(wr_buffer_t);
    bp->base	= data;
    bp->next	= data;
    bp->top	= (Byte_t *)(((Addr_t)data) + len);

    wr = NEW_OBJ(writer_t);
    wr->errFlg	= FALSE;
    wr->data	= (void *)bp;
    wr->putWord	= MemPut;
    wr->write	= MemWrite;
    wr->flush	= MemFlush;
    wr->tell	= MemTell;
    wr->seek	= MemSeek;
    wr->free	= MemFree;

    return wr;

} /* end of WR_OpenMem */

/* MemPut:
 */
PVT void MemPut (writer_t *wr, Word_t w)
{
    wr_buffer_t	*bp = BufOf(wr);

    ASSERT(bp->next+WORD_SZB <= bp->top);

    *((Word_t *)(bp->next)) = w;
    bp->next += WORD_SZB;

} /* end of MemPut */

/* MemWrite:
 */
PVT void MemWrite (writer_t *wr, const void *data, Addr_t nbytes)
{
    wr_buffer_t	*bp = BufOf(wr);

    if (wr->errFlg)
	return;

    ASSERT(bp->next+nbytes <= bp->top);

    memcpy (bp->next, data, nbytes);
    bp->next += nbytes;

} /* end of MemWrite */

/* MemFlush:
 */
PVT void MemFlush (writer_t *wr)
{
    wr_buffer_t	*bp = BufOf(wr);

    ASSERT(bp->next <= bp->top);

} /* end of MemFlush */

/* MemTell:
 */
PVT off_t MemTell (writer_t *wr)
{
    Die ("Tell not supported on memory writers");

} /* end of MemTell */

/* MemSeek:
 */
PVT void MemSeek (writer_t *wr, off_t offset)
{
    Die ("Tell not supported on memory writers");

} /* end of MemSeek */

/* MemFree:
 */
PVT void MemFree (writer_t *wr)
{
    wr_buffer_t	*bp = BufOf(wr);

    ASSERT(bp->next == bp->top);

    FREE (BufOf(wr));
    FREE (wr);

} /* end of MemFree */
