Bare metal frambuffer setup for Raspberry PI 3 (works for 4 as well, set target to raspi4 in makefile).

Usage: Select fractal to be drawn in framebuffer:
   make DEFS=-DMANDELBROT
 or
   make DEFS=-DSIERPINSKI

   kernel image generated. 'make run'  to test run it in qemu (qemu-system-aarch64 version 10.0.50 required)
  
  
