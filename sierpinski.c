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


#include <stdlib.h>
#include "fb.h"

void srand_asm(uint32_t s);
unsigned long pseudo_rand_asm(uint32_t max);

static uint32_t seed =42;


unsigned long pseudo_rand(uint32_t max) {
    seed = (1664525 * seed + 1013904223) % 0xFFFFFFFF;
    return seed % max;
}

void draw_sierpinski(uintptr_t fb) {
	const uint32_t x1 = 0;
	const uint32_t y1 = 480;

	const uint32_t x2 = 640;
	const uint32_t y2 = 480;

	const uint32_t x3 = 320;
	const uint32_t y3 = 0;

	uint32_t xp = 320;
	uint32_t yp = 240;

	while(1) {
	    switch (pseudo_rand_asm(3)) {
		case 0:
			xp = (x1 + xp) /2;
			yp = (y1 + yp) /2;		
		break;
		case 1:
			xp = (x2 + xp) /2;
			yp = (y2 + yp) /2;		
		break;
		case 2:
			xp = (x3 + xp) /2;
			yp = (y3 + yp) /2;		
		break;		
	        default:
		break;
	    }
	    fb_putpixel(fb, xp,yp, 0xFFFFFFFF);
	}
		
	
}
