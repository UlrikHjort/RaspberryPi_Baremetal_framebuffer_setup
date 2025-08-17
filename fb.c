/**************************************************************************
--                      Raspberry Pi Framebuffer
-- 
--           Copyright (C) 2025 By Ulrik Hørlyk Hjort
--
--  This Program is Free Software; You Can Redistribute It and/or
--  Modify It Under The Terms of The GNU General Public License
--  As Published By The Free Software Foundation; Either Version 2
--  of The License, or (at Your Option) Any Later Version.
--
--  This Program is Distributed in The Hope That It Will Be Useful,
--  But WITHOUT ANY WARRANTY; Without Even The Implied Warranty of
--  MERCHANTABILITY or FITNESS for A PARTICULAR PURPOSE.  See The
--  GNU General Public License for More Details.
--
-- You Should Have Received A Copy of The GNU General Public License
-- Along with This Program; if not, See <Http://Www.Gnu.Org/Licenses/>.
***************************************************************************/


#include "fb.h"
#include "mailbox.h"
volatile unsigned int __attribute__((aligned(16))) mbox[36];

static uint32_t fb_width = 0, fb_height = 0, fb_pitch = 0;

extern void fb_putpixel_asm(uintptr_t fb, unsigned int x, unsigned int y, unsigned int color);

int fb_init() {
    mbox[0] = 35*4;
    mbox[1] = 0; // request

    mbox[2] = 0x48003; mbox[3] = 8; mbox[4] = 8; mbox[5] = 640; mbox[6] = 480;         // set phy wh
    mbox[7] = 0x48004; mbox[8] = 8; mbox[9] = 8; mbox[10] = 640; mbox[11] = 480;       // set virt wh
    mbox[12]= 0x48005; mbox[13]= 4; mbox[14]= 4; mbox[15]= 32;                        // set depth
    mbox[16]= 0x48009; mbox[17]= 8; mbox[18]= 8; mbox[19]= 0; mbox[20]= 0;            // set offset
    mbox[21]= 0x40001; mbox[22]= 8; mbox[23]= 8; mbox[24]= 16; mbox[25]= 0;           // alloc fb
    mbox[26]= 0;                                                                      // end tag

    unsigned int addr = (unsigned int)((unsigned long)mbox);
    mailbox_write(addr, 8);
    mailbox_read(8);

    return mbox[24]; // framebuffer pointer
}





void fb_clear(uintptr_t fb, uint32_t color) {
    unsigned int *ptr = (unsigned int*)(fb & 0x3FFFFFFF);	
    for (uint32_t y = 0; y < fb_height; ++y) {
        for (uint32_t x = 0; x < fb_width; ++x) {
            ptr[y * fb_pitch + x] = color;
        }
    }
}

void fb_putpixel(uintptr_t fb, uint32_t x, uint32_t y, uint32_t color) {
	unsigned int *ptr = (unsigned int*)(fb & 0x3FFFFFFF);
    ptr[y * 640 + x] = color;
}

void fb_draw_rect(uintptr_t fb,uint32_t x, uint32_t y, uint32_t w, uint32_t h, uint32_t color) {
    for (uint32_t i = 0; i < h; ++i) {
        for (uint32_t j = 0; j < w; ++j) {
		fb_putpixel_asm(fb, x + j, y + i, color);
        }
    }
}

