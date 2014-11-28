
obj/schedos-4:     file format elf32-i386


Disassembly of section .text:

00500000 <start>:
#define PRINTCHAR	('1' | 0x0C00)
#endif

void
start(void)
{
  500000:	31 c0                	xor    %eax,%eax
	int i;

	for (i = 0; i < RUNCOUNT; i++) {
		// Write characters to the console, yielding after each one.
		*cursorpos++ = PRINTCHAR;
  500002:	8b 15 00 80 19 00    	mov    0x198000,%edx
  500008:	66 c7 02 34 0e       	movw   $0xe34,(%edx)
  50000d:	83 c2 02             	add    $0x2,%edx
  500010:	89 15 00 80 19 00    	mov    %edx,0x198000
sys_yield(void)
{
	// We call a system call by causing an interrupt with the 'int'
	// instruction.  In weensyos, the type of system call is indicated
	// by the interrupt number -- here, INT_SYS_YIELD.
	asm volatile("int %0\n"
  500016:	cd 30                	int    $0x30
void
start(void)
{
	int i;

	for (i = 0; i < RUNCOUNT; i++) {
  500018:	40                   	inc    %eax
  500019:	3d 40 01 00 00       	cmp    $0x140,%eax
  50001e:	75 e2                	jne    500002 <start+0x2>
  500020:	cd 30                	int    $0x30
  500022:	eb fc                	jmp    500020 <start+0x20>
