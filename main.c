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


#include <stdint.h>
#include <stddef.h>
#include "fb.h"
#include "mandelbrot.h"
#include "sierpinski.h"

extern void draw_mandel_brot_asm(uintptr_t fb);


void main() {


    unsigned int fb = fb_init();    
    if (!fb) {

        while (1); 
    }
#if defined(SIERPINSKI)
    draw_sierpinski_asm(fb);
#elif defined(MANDELBROT) 
    draw_mandel_brot_asm(fb);   
#endif

    while (1);
}
