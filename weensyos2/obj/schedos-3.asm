
obj/schedos-3:     file format elf32-i386


Disassembly of section .text:

00400000 <start>:
#define PRINTCHAR	('1' | 0x0C00)
#endif

void
start(void)
{
  400000:	31 c0                	xor    %eax,%eax
	int i;

	for (i = 0; i < RUNCOUNT; i++) {
		// Write characters to the console, yielding after each one.
		*cursorpos++ = PRINTCHAR;
  400002:	8b 15 00 80 19 00    	mov    0x198000,%edx
  400008:	66 c7 02 33 09       	movw   $0x933,(%edx)
  40000d:	83 c2 02             	add    $0x2,%edx
  400010:	89 15 00 80 19 00    	mov    %edx,0x198000
sys_yield(void)
{
	// We call a system call by causing an interrupt with the 'int'
	// instruction.  In weensyos, the type of system call is indicated
	// by the interrupt number -- here, INT_SYS_YIELD.
	asm volatile("int %0\n"
  400016:	cd 30                	int    $0x30
void
start(void)
{
	int i;

	for (i = 0; i < RUNCOUNT; i++) {
  400018:	40                   	inc    %eax
  400019:	3d 40 01 00 00       	cmp    $0x140,%eax
  40001e:	75 e2                	jne    400002 <start+0x2>
  400020:	cd 30                	int    $0x30
  400022:	eb fc                	jmp    400020 <start+0x20>
