#ifndef FB_H
#define FB_H
#include <stdint.h>

int fb_init();

void fb_clear(uintptr_t fb, uint32_t color);

void fb_putpixel(uintptr_t fb, uint32_t x, uint32_t y, uint32_t color);

void fb_draw_rect(uintptr_t fb,uint32_t x, uint32_t y, uint32_t w, uint32_t h, uint32_t color);

void fb_putpixel_asm(uintptr_t fb, unsigned int x, unsigned int y, unsigned int color);



#endif
