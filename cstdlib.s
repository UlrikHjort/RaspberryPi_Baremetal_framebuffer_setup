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

	.data
     seed_local:      .word   42  

    .text
    .global srand_asm
    .global pseudo_rand_asm

// void srand_asm(uint64_t s)
srand_asm:	
	adrp x0, seed_local
	add  x1, x1, :lo12:seed_local
	str  w0, [x1]
	ret

pseudo_rand_asm:
    // arguments:
    // max: w0
    // returns: w0 (result)

    // load &seed_local into x1
    adrp x1, seed_local
    add  x1, x1, :lo12:seed_local

    // load current seed_local value
    ldr w2, [x1]            // w2 = seed_local

	// multiply by 1664525
	movz w3, #(1664525 & 0xFFFF)           // lower 16 bits
	movk w3, #(1664525 >> 16), lsl #16    // upper bits
	

    mul  w2, w2, w3         // w2 = seed_local * 1664525

    // add 1013904223
    mov  w3, #1013904223 & 0xFFFF
    movk w3, #(1013904223 >> 16), lsl #16
    add  w2, w2, w3         // w2 = w2 + 1013904223

    // seed_local is already 32 bits, no need to modulo
    str  w2, [x1]           // save updated seed_local

    // compute seed_local % max
    udiv w3, w2, w0         // w3 = seed_local / max
    msub w0, w3, w0, w2     // w0 = seed_local - (seed_local/max)*max
                            // ==> w0 = seed_local % max

    ret

