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

	.set HEIGHT, 480
	.set WIDTH, 640
	
	.data
		.align 4
	        //       XMIN, XMAX, YMIN, YMAX
		LIMITS:	 .double -2.0, 1.0, -1.5, 1.5 
	
	.text
		.global draw_mandel_brot_asm
		.align 2


draw_mandel_brot_asm:
	str lr,[sp,#-16]! 
	mov w18, w0  // Save framebuffer
	ldr x1, =LIMITS
	
	ldp d0, d1, [x1], #16	
	ldp d2, d3, [x1]

	mov w7, 0 // Height counter Py
loop_height:	
	mov w6, 0 // Width counter Px
loop_width:
	fsub d15, d1, d0 // (x0 = xmax -xmin)
	scvtf d16, w6
	fmul d15,d15, d16 // (xmax - xmin) * px
	mov w16, #WIDTH
	scvtf d16, w16
	fdiv d15, d15, d16 //(xmax - xmin) * px / WIDTH
	fadd d15, d15, d0 // + xmin

	fsub d14, d3, d2 // (y0 = ymax -ymin)
	scvtf d17, w7
	fmul d14, d14, d17 // (ymax - ymin) * py
	mov w17, #HEIGHT
	scvtf d17, w17
	fdiv d14, d14, d17
	fadd d14, d14, d2

	mov x13, #1000  // max iter
	//mov w12,#0
	//scvtf d12, w12  // x

	fmov d12, xzr  // x
	mov w11,#0
	scvtf d11, w11  // y
	
	
loop_iter:
	fmul d10,d12,d12 //x*x
	fmul d9,d11,d11 //y*y

	// d8 == xtemp
	fsub d8, d10, d9 // (x*x) - (y*y)
	fadd d8, d8, d15 //  (x*x) - (y*y) +x0	

	fadd d10, d10, d9 // (x*x) + (y*y)


	fmov d9, #4.0
	fcmp d10, d9    // (x*x) + (y*y) <= 4.0
	b.gt bail_out
	fmul d11,d11, d12    // y = x*y
	fmov d7, #2.0  // temp reg
	fmul d11, d11,d7 // y = 2*x*y
	fadd d11, d11, d14 // +y0
	fmov d12, d8 // x= xtmp
	sub x13, x13,1
	cmp x13, #0	
	b.ne loop_iter
	mov w3, #0x00000000  // se color for fb_putpixel to black if iter max	
	b b2
bail_out:
        mov w3, #0xFFFFFFFF // color for fb_putpixel

b2:	
	// Put pixel
	mov w0, w18 // Restore framebuffer
        mov w1, w6  // px 
        mov w2, w7  // py
	bl fb_putpixel_asm	

	// Inter loop (px) 
	add w6,w6,1
	cmp w6, #WIDTH
	b.ne loop_width	

	// Outer loop (py) 	
	add w7, w7,1
	cmp w7, #HEIGHT
	b.ne loop_height

	ldr lr,[sp], #16
	ret
	
