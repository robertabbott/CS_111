#include "schedos-app.h"
#include "x86sync.h"
#include "schedos.h"
/*****************************************************************************
 * schedos-1
 *
 *   This tiny application prints red "1"s to the console.
 *   It yields the CPU to the kernel after each "1" using the sys_yield()
 *   system call.  This lets the kernel (schedos-kern.c) pick another
 *   application to run, if it wants.
 *
 *   The other schedos-* processes simply #include this file after defining
 *   PRINTCHAR appropriately.
 *
 *****************************************************************************/

#ifndef PRINTCHAR
#define PRINTCHAR	('1' | 0x0C00)
#endif

//global_lock = (uint32_t *) 0xB8004;


void
start(void)
{
	int i;
  sys_set_priority(10);	// set process priority
	sys_set_share(7);		// set process share
	sys_yield();

	for (i = 0; i < RUNCOUNT; i++) {
    // if value == 1 locked else use atomic_swap to set it and lock it
    //sys_acquire_lock(&global_lock);

    // sys_print_char is system call for ex6
    sys_print_char((int) PRINTCHAR);
		// *cursorpos++ = PRINTCHAR;

    //sys_release_lock(&global_lock);
		sys_yield();
	}

	// Yield forever.
	sys_exit(0);
}
