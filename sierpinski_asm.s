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
	
	// Initial points for the triangle
	.set PX1, 0
	.set PY1, 480

	.set PX2, 640
	.set PY2, 480

	.set PX3, 320
	.set PY3, 0	
	

	.text
        .global draw_sierpinski_asm
        .align 2

	
draw_sierpinski_asm_consts: // fb in r0
	mov w15, w0 // Save fb
	mov w13, #320
	mov w14, #240

main_loop1:	
	mov w0, #3
	bl pseudo_rand_asm
	cmp w0, #1
	b.lt L1	
	b.eq L2
	bl L3			

L1:
	add w13, w13, #PX1
	add w14, w14, #PY1
	bl plot

L2:
	add w13, w13, #PX2
	add w14, w14, #PY2
	bl plot

L3:
	add w13, w13, #PX3
	add w14, w14, #PY3
	bl plot	


plot:
	mov w0, w15 // restore fb
	lsr W13, W13, #1
	lsr W14, W14, #1		
	mov w1, w13
	mov w2, w14
	mov w3, #0xFFFFFFFF			
	bl fb_putpixel_asm
	bl main_loop1
	ret



	
draw_sierpinski_asm_table: // fb in r0
	mov w9, w0 // Save fb
	mov w13, #320
	mov w14, #240

main_loop_table:	
	mov w0, #3
	bl pseudo_rand_asm

	uxtw    x1, w0                   // move random index to x1
	adr     x0, points_table         // x0 = base address

	lsl     x2, x1, #3               // x2 = index × 8
	add     x3, x0, x2              // x3 = base + offset
	ldp     w15, w16, [x3]          // load PX,PY

	add     w13, w13, w15
	add     w14, w14, w16

	bl plot_table		
		
plot_table:
	mov w0, w9 // restore fb
	lsr W13, W13, #1
	lsr W14, W14, #1		
	mov w1, w13
	mov w2, w14
	mov w3, #0xFFFFFFFF			
	bl fb_putpixel_asm
	bl main_loop_table
	ret


draw_sierpinski_asm: // fb in r0
	bl draw_sierpinski_asm_table
	
	
	
	.section .rodata
points_table:
	.word PX1, PY1
	.word PX2, PY2
	.word PX3, PY3
