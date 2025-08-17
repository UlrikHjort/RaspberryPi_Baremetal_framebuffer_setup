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
#ifndef FB_H
#define FB_H
#include <stdint.h>

int fb_init();

void fb_clear(uintptr_t fb, uint32_t color);

void fb_putpixel(uintptr_t fb, uint32_t x, uint32_t y, uint32_t color);

void fb_draw_rect(uintptr_t fb,uint32_t x, uint32_t y, uint32_t w, uint32_t h, uint32_t color);

void fb_putpixel_asm(uintptr_t fb, unsigned int x, unsigned int y, unsigned int color);



#endif
