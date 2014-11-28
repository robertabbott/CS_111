
obj/schedos-kern:     file format elf32-i386


Disassembly of section .text:

00100000 <multiboot>:
  100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
  100006:	00 00                	add    %al,(%eax)
  100008:	fe 4f 52             	decb   0x52(%edi)
  10000b:	e4 bc                	in     $0xbc,%al

0010000c <multiboot_start>:
# The multiboot_start routine sets the stack pointer to the top of the
# SchedOS's kernel stack, then jumps to the 'start' routine in schedos-kern.c.

.globl multiboot_start
multiboot_start:
	movl $0x180000, %esp
  10000c:	bc 00 00 18 00       	mov    $0x180000,%esp
	pushl $0
  100011:	6a 00                	push   $0x0
	popfl
  100013:	9d                   	popf   
	call start
  100014:	e8 4d 01 00 00       	call   100166 <start>
  100019:	90                   	nop

0010001a <clock_int_handler>:
# Interrupt handlers
.align 2

	.globl clock_int_handler
clock_int_handler:
	pushl $0		// error code
  10001a:	6a 00                	push   $0x0
	pushl $32		// trap number
  10001c:	6a 20                	push   $0x20
	jmp _generic_int_handler
  10001e:	eb 40                	jmp    100060 <_generic_int_handler>

00100020 <sys_int48_handler>:

sys_int48_handler:
	pushl $0
  100020:	6a 00                	push   $0x0
	pushl $48
  100022:	6a 30                	push   $0x30
	jmp _generic_int_handler
  100024:	eb 3a                	jmp    100060 <_generic_int_handler>

00100026 <sys_int49_handler>:

sys_int49_handler:
	pushl $0
  100026:	6a 00                	push   $0x0
	pushl $49
  100028:	6a 31                	push   $0x31
	jmp _generic_int_handler
  10002a:	eb 34                	jmp    100060 <_generic_int_handler>

0010002c <sys_int50_handler>:

sys_int50_handler:
	pushl $0
  10002c:	6a 00                	push   $0x0
	pushl $50
  10002e:	6a 32                	push   $0x32
	jmp _generic_int_handler
  100030:	eb 2e                	jmp    100060 <_generic_int_handler>

00100032 <sys_int51_handler>:

sys_int51_handler:
	pushl $0
  100032:	6a 00                	push   $0x0
	pushl $51
  100034:	6a 33                	push   $0x33
	jmp _generic_int_handler
  100036:	eb 28                	jmp    100060 <_generic_int_handler>

00100038 <sys_int52_handler>:

sys_int52_handler:
	pushl $0
  100038:	6a 00                	push   $0x0
	pushl $52
  10003a:	6a 34                	push   $0x34
	jmp _generic_int_handler
  10003c:	eb 22                	jmp    100060 <_generic_int_handler>

0010003e <sys_int53_handler>:

sys_int53_handler:
	pushl $0
  10003e:	6a 00                	push   $0x0
	pushl $53
  100040:	6a 35                	push   $0x35
	jmp _generic_int_handler
  100042:	eb 1c                	jmp    100060 <_generic_int_handler>

00100044 <sys_int54_handler>:

sys_int54_handler:
	pushl $0
  100044:	6a 00                	push   $0x0
	pushl $54
  100046:	6a 36                	push   $0x36
	jmp _generic_int_handler
  100048:	eb 16                	jmp    100060 <_generic_int_handler>

0010004a <sys_int55_handler>:

sys_int55_handler:
	pushl $0
  10004a:	6a 00                	push   $0x0
	pushl $55
  10004c:	6a 37                	push   $0x37
	jmp _generic_int_handler
  10004e:	eb 10                	jmp    100060 <_generic_int_handler>

00100050 <sys_int56_handler>:

sys_int56_handler:
	pushl $0
  100050:	6a 00                	push   $0x0
	pushl $56
  100052:	6a 38                	push   $0x38
	jmp _generic_int_handler
  100054:	eb 0a                	jmp    100060 <_generic_int_handler>

00100056 <sys_int57_handler>:

sys_int57_handler:
	pushl $0
  100056:	6a 00                	push   $0x0
	pushl $57
  100058:	6a 39                	push   $0x39
	jmp _generic_int_handler
  10005a:	eb 04                	jmp    100060 <_generic_int_handler>

0010005c <default_int_handler>:

	.globl default_int_handler
default_int_handler:
	pushl $0
  10005c:	6a 00                	push   $0x0
	jmp _generic_int_handler
  10005e:	eb 00                	jmp    100060 <_generic_int_handler>

00100060 <_generic_int_handler>:
	# When we get here, the processor's interrupt mechanism has
	# pushed the old task status and stack registers onto the kernel stack.
	# Then one of the specific handlers pushed the trap number.
	# Now, we complete the 'registers_t' structure by pushing the extra
	# segment definitions and the general CPU registers.
	pushl %ds
  100060:	1e                   	push   %ds
	pushl %es
  100061:	06                   	push   %es
	pushal
  100062:	60                   	pusha  

	# Load the kernel's data segments into the extra segment registers
	# (although we don't use those extra segments!).
	movl $0x10, %eax
  100063:	b8 10 00 00 00       	mov    $0x10,%eax
	movw %ax, %ds
  100068:	8e d8                	mov    %eax,%ds
	movw %ax, %es
  10006a:	8e c0                	mov    %eax,%es

	# Call the kernel's 'interrupt' function.
	pushl %esp
  10006c:	54                   	push   %esp
	call interrupt
  10006d:	e8 83 00 00 00       	call   1000f5 <interrupt>

00100072 <sys_int_handlers>:
  100072:	20 00                	and    %al,(%eax)
  100074:	10 00                	adc    %al,(%eax)
  100076:	26 00 10             	add    %dl,%es:(%eax)
  100079:	00 2c 00             	add    %ch,(%eax,%eax,1)
  10007c:	10 00                	adc    %al,(%eax)
  10007e:	32 00                	xor    (%eax),%al
  100080:	10 00                	adc    %al,(%eax)
  100082:	38 00                	cmp    %al,(%eax)
  100084:	10 00                	adc    %al,(%eax)
  100086:	3e 00 10             	add    %dl,%ds:(%eax)
  100089:	00 44 00 10          	add    %al,0x10(%eax,%eax,1)
  10008d:	00 4a 00             	add    %cl,0x0(%edx)
  100090:	10 00                	adc    %al,(%eax)
  100092:	50                   	push   %eax
  100093:	00 10                	add    %dl,(%eax)
  100095:	00 56 00             	add    %dl,0x0(%esi)
  100098:	10 00                	adc    %al,(%eax)
  10009a:	90                   	nop
  10009b:	90                   	nop

0010009c <schedule>:
 *
 *****************************************************************************/

void
schedule(void)
{
  10009c:	83 ec 0c             	sub    $0xc,%esp
	pid_t pid = current->p_pid;
  10009f:	a1 4c 76 10 00       	mov    0x10764c,%eax
  1000a4:	8b 10                	mov    (%eax),%edx

	if (scheduling_algorithm == 0)
  1000a6:	a1 50 76 10 00       	mov    0x107650,%eax
  1000ab:	85 c0                	test   %eax,%eax
  1000ad:	75 25                	jne    1000d4 <schedule+0x38>
		while (1) {
			pid = (pid + 1) % NPROCS;
  1000af:	b9 05 00 00 00       	mov    $0x5,%ecx
  1000b4:	8d 42 01             	lea    0x1(%edx),%eax
  1000b7:	99                   	cltd   
  1000b8:	f7 f9                	idiv   %ecx

			// Run the selected process, but skip
			// non-runnable processes.
			// Note that the 'run' function does not return.
			if (proc_array[pid].p_state == P_RUNNABLE)
  1000ba:	6b c2 50             	imul   $0x50,%edx,%eax
  1000bd:	83 b8 9c 6c 10 00 01 	cmpl   $0x1,0x106c9c(%eax)
  1000c4:	75 ee                	jne    1000b4 <schedule+0x18>
				run(&proc_array[pid]);
  1000c6:	83 ec 0c             	sub    $0xc,%esp
  1000c9:	05 54 6c 10 00       	add    $0x106c54,%eax
  1000ce:	50                   	push   %eax
  1000cf:	e8 a5 03 00 00       	call   100479 <run>
		}

	// If we get here, we are running an unknown scheduling algorithm.
	cursorpos = console_printf(cursorpos, 0x100, "\nUnknown scheduling algorithm %d\n", scheduling_algorithm);
  1000d4:	8b 15 00 80 19 00    	mov    0x198000,%edx
  1000da:	50                   	push   %eax
  1000db:	68 38 0a 10 00       	push   $0x100a38
  1000e0:	68 00 01 00 00       	push   $0x100
  1000e5:	52                   	push   %edx
  1000e6:	e8 33 09 00 00       	call   100a1e <console_printf>
  1000eb:	83 c4 10             	add    $0x10,%esp
  1000ee:	a3 00 80 19 00       	mov    %eax,0x198000
  1000f3:	eb fe                	jmp    1000f3 <schedule+0x57>

001000f5 <interrupt>:
 *
 *****************************************************************************/

void
interrupt(registers_t *reg)
{
  1000f5:	57                   	push   %edi
	// Save the current process's register state
	// into its process descriptor
	current->p_registers = *reg;
  1000f6:	a1 4c 76 10 00       	mov    0x10764c,%eax
  1000fb:	b9 11 00 00 00       	mov    $0x11,%ecx
 *
 *****************************************************************************/

void
interrupt(registers_t *reg)
{
  100100:	56                   	push   %esi
  100101:	53                   	push   %ebx
  100102:	8b 5c 24 10          	mov    0x10(%esp),%ebx
	// Save the current process's register state
	// into its process descriptor
	current->p_registers = *reg;
  100106:	8d 78 04             	lea    0x4(%eax),%edi
  100109:	89 de                	mov    %ebx,%esi
  10010b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

	switch (reg->reg_intno) {
  10010d:	8b 53 28             	mov    0x28(%ebx),%edx
  100110:	83 fa 31             	cmp    $0x31,%edx
  100113:	74 1f                	je     100134 <interrupt+0x3f>
  100115:	77 0c                	ja     100123 <interrupt+0x2e>
  100117:	83 fa 20             	cmp    $0x20,%edx
  10011a:	74 43                	je     10015f <interrupt+0x6a>
  10011c:	83 fa 30             	cmp    $0x30,%edx
  10011f:	74 0e                	je     10012f <interrupt+0x3a>
  100121:	eb 41                	jmp    100164 <interrupt+0x6f>
  100123:	83 fa 32             	cmp    $0x32,%edx
  100126:	74 23                	je     10014b <interrupt+0x56>
  100128:	83 fa 33             	cmp    $0x33,%edx
  10012b:	74 29                	je     100156 <interrupt+0x61>
  10012d:	eb 35                	jmp    100164 <interrupt+0x6f>

	case INT_SYS_YIELD:
		// The 'sys_yield' system call asks the kernel to schedule
		// the next process.
		schedule();
  10012f:	e8 68 ff ff ff       	call   10009c <schedule>
		// The application stored its exit status in the %eax register
		// before calling the system call.  The %eax register has
		// changed by now, but we can read the application's value
		// out of the 'reg' argument.
		// (This shows you how to transfer arguments to system calls!)
		current->p_state = P_ZOMBIE;
  100134:	a1 4c 76 10 00       	mov    0x10764c,%eax
		current->p_exit_status = reg->reg_eax;
  100139:	8b 53 1c             	mov    0x1c(%ebx),%edx
		// The application stored its exit status in the %eax register
		// before calling the system call.  The %eax register has
		// changed by now, but we can read the application's value
		// out of the 'reg' argument.
		// (This shows you how to transfer arguments to system calls!)
		current->p_state = P_ZOMBIE;
  10013c:	c7 40 48 03 00 00 00 	movl   $0x3,0x48(%eax)
		current->p_exit_status = reg->reg_eax;
  100143:	89 50 4c             	mov    %edx,0x4c(%eax)
		schedule();
  100146:	e8 51 ff ff ff       	call   10009c <schedule>

	case INT_SYS_USER1:
		// 'sys_user*' are provided for your convenience, in case you
		// want to add a system call.
		/* Your code here (if you want). */
		run(current);
  10014b:	83 ec 0c             	sub    $0xc,%esp
  10014e:	ff 35 4c 76 10 00    	pushl  0x10764c
  100154:	eb 04                	jmp    10015a <interrupt+0x65>

	case INT_SYS_USER2:
		/* Your code here (if you want). */
		run(current);
  100156:	83 ec 0c             	sub    $0xc,%esp
  100159:	50                   	push   %eax
  10015a:	e8 1a 03 00 00       	call   100479 <run>

	case INT_CLOCK:
		// A clock interrupt occurred (so an application exhausted its
		// time quantum).
		// Switch to the next runnable process.
		schedule();
  10015f:	e8 38 ff ff ff       	call   10009c <schedule>
  100164:	eb fe                	jmp    100164 <interrupt+0x6f>

00100166 <start>:
 *
 *****************************************************************************/

void
start(void)
{
  100166:	57                   	push   %edi

	// Initialize process descriptors as empty
	memset(proc_array, 0, sizeof(proc_array));
	for (i = 0; i < NPROCS; i++) {
		proc_array[i].p_pid = i;
		proc_array[i].p_state = P_EMPTY;
  100167:	bf 00 00 30 00       	mov    $0x300000,%edi
 *
 *****************************************************************************/

void
start(void)
{
  10016c:	56                   	push   %esi

	// Initialize process descriptors as empty
	memset(proc_array, 0, sizeof(proc_array));
	for (i = 0; i < NPROCS; i++) {
		proc_array[i].p_pid = i;
		proc_array[i].p_state = P_EMPTY;
  10016d:	31 f6                	xor    %esi,%esi
 *
 *****************************************************************************/

void
start(void)
{
  10016f:	53                   	push   %ebx

	// Initialize process descriptors as empty
	memset(proc_array, 0, sizeof(proc_array));
	for (i = 0; i < NPROCS; i++) {
		proc_array[i].p_pid = i;
		proc_array[i].p_state = P_EMPTY;
  100170:	bb a4 6c 10 00       	mov    $0x106ca4,%ebx
start(void)
{
	int i;

	// Set up hardware (schedos-x86.c)
	segments_init();
  100175:	e8 de 00 00 00       	call   100258 <segments_init>
	interrupt_controller_init(0);
  10017a:	83 ec 0c             	sub    $0xc,%esp
  10017d:	6a 00                	push   $0x0
  10017f:	e8 cf 01 00 00       	call   100353 <interrupt_controller_init>
	console_clear();
  100184:	e8 53 02 00 00       	call   1003dc <console_clear>

	// Initialize process descriptors as empty
	memset(proc_array, 0, sizeof(proc_array));
  100189:	83 c4 0c             	add    $0xc,%esp
  10018c:	68 90 01 00 00       	push   $0x190
  100191:	6a 00                	push   $0x0
  100193:	68 54 6c 10 00       	push   $0x106c54
  100198:	e8 1f 04 00 00       	call   1005bc <memset>
	for (i = 0; i < NPROCS; i++) {
		proc_array[i].p_pid = i;
		proc_array[i].p_state = P_EMPTY;
  10019d:	83 c4 10             	add    $0x10,%esp
	console_clear();

	// Initialize process descriptors as empty
	memset(proc_array, 0, sizeof(proc_array));
	for (i = 0; i < NPROCS; i++) {
		proc_array[i].p_pid = i;
  1001a0:	c7 05 54 6c 10 00 00 	movl   $0x0,0x106c54
  1001a7:	00 00 00 
		proc_array[i].p_state = P_EMPTY;
  1001aa:	c7 05 9c 6c 10 00 00 	movl   $0x0,0x106c9c
  1001b1:	00 00 00 
	console_clear();

	// Initialize process descriptors as empty
	memset(proc_array, 0, sizeof(proc_array));
	for (i = 0; i < NPROCS; i++) {
		proc_array[i].p_pid = i;
  1001b4:	c7 05 a4 6c 10 00 01 	movl   $0x1,0x106ca4
  1001bb:	00 00 00 
		proc_array[i].p_state = P_EMPTY;
  1001be:	c7 05 ec 6c 10 00 00 	movl   $0x0,0x106cec
  1001c5:	00 00 00 
	console_clear();

	// Initialize process descriptors as empty
	memset(proc_array, 0, sizeof(proc_array));
	for (i = 0; i < NPROCS; i++) {
		proc_array[i].p_pid = i;
  1001c8:	c7 05 f4 6c 10 00 02 	movl   $0x2,0x106cf4
  1001cf:	00 00 00 
		proc_array[i].p_state = P_EMPTY;
  1001d2:	c7 05 3c 6d 10 00 00 	movl   $0x0,0x106d3c
  1001d9:	00 00 00 
	console_clear();

	// Initialize process descriptors as empty
	memset(proc_array, 0, sizeof(proc_array));
	for (i = 0; i < NPROCS; i++) {
		proc_array[i].p_pid = i;
  1001dc:	c7 05 44 6d 10 00 03 	movl   $0x3,0x106d44
  1001e3:	00 00 00 
		proc_array[i].p_state = P_EMPTY;
  1001e6:	c7 05 8c 6d 10 00 00 	movl   $0x0,0x106d8c
  1001ed:	00 00 00 
	console_clear();

	// Initialize process descriptors as empty
	memset(proc_array, 0, sizeof(proc_array));
	for (i = 0; i < NPROCS; i++) {
		proc_array[i].p_pid = i;
  1001f0:	c7 05 94 6d 10 00 04 	movl   $0x4,0x106d94
  1001f7:	00 00 00 
		proc_array[i].p_state = P_EMPTY;
  1001fa:	c7 05 dc 6d 10 00 00 	movl   $0x0,0x106ddc
  100201:	00 00 00 
	for (i = 1; i < NPROCS; i++) {
		process_t *proc = &proc_array[i];
		uint32_t stack_ptr = PROC1_START + i * PROC_SIZE;

		// Initialize the process descriptor
		special_registers_init(proc);
  100204:	83 ec 0c             	sub    $0xc,%esp
  100207:	53                   	push   %ebx
  100208:	e8 83 02 00 00       	call   100490 <special_registers_init>

		// Set ESP
		proc->p_registers.reg_esp = stack_ptr;

		// Load process and set EIP, based on ELF image
		program_loader(i - 1, &proc->p_registers.reg_eip);
  10020d:	58                   	pop    %eax
  10020e:	5a                   	pop    %edx
  10020f:	8d 43 34             	lea    0x34(%ebx),%eax

		// Initialize the process descriptor
		special_registers_init(proc);

		// Set ESP
		proc->p_registers.reg_esp = stack_ptr;
  100212:	89 7b 40             	mov    %edi,0x40(%ebx)

		// Load process and set EIP, based on ELF image
		program_loader(i - 1, &proc->p_registers.reg_eip);

		// Mark the process as runnable!
		proc->p_state = P_RUNNABLE;
  100215:	81 c7 00 00 10 00    	add    $0x100000,%edi

		// Set ESP
		proc->p_registers.reg_esp = stack_ptr;

		// Load process and set EIP, based on ELF image
		program_loader(i - 1, &proc->p_registers.reg_eip);
  10021b:	50                   	push   %eax
  10021c:	56                   	push   %esi

		// Mark the process as runnable!
		proc->p_state = P_RUNNABLE;
  10021d:	46                   	inc    %esi

		// Set ESP
		proc->p_registers.reg_esp = stack_ptr;

		// Load process and set EIP, based on ELF image
		program_loader(i - 1, &proc->p_registers.reg_eip);
  10021e:	e8 a9 02 00 00       	call   1004cc <program_loader>
		proc_array[i].p_pid = i;
		proc_array[i].p_state = P_EMPTY;
	}

	// Set up process descriptors (the proc_array[])
	for (i = 1; i < NPROCS; i++) {
  100223:	83 c4 10             	add    $0x10,%esp

		// Load process and set EIP, based on ELF image
		program_loader(i - 1, &proc->p_registers.reg_eip);

		// Mark the process as runnable!
		proc->p_state = P_RUNNABLE;
  100226:	c7 43 48 01 00 00 00 	movl   $0x1,0x48(%ebx)
  10022d:	83 c3 50             	add    $0x50,%ebx
		proc_array[i].p_pid = i;
		proc_array[i].p_state = P_EMPTY;
	}

	// Set up process descriptors (the proc_array[])
	for (i = 1; i < NPROCS; i++) {
  100230:	83 fe 04             	cmp    $0x4,%esi
  100233:	75 cf                	jne    100204 <start+0x9e>

	// Initialize the scheduling algorithm.
	scheduling_algorithm = 0;

	// Switch to the first process.
	run(&proc_array[1]);
  100235:	83 ec 0c             	sub    $0xc,%esp
  100238:	68 a4 6c 10 00       	push   $0x106ca4
		proc->p_state = P_RUNNABLE;
	}

	// Initialize the cursor-position shared variable to point to the
	// console's first character (the upper left).
	cursorpos = (uint16_t *) 0xB8000;
  10023d:	c7 05 00 80 19 00 00 	movl   $0xb8000,0x198000
  100244:	80 0b 00 

	// Initialize the scheduling algorithm.
	scheduling_algorithm = 0;
  100247:	c7 05 50 76 10 00 00 	movl   $0x0,0x107650
  10024e:	00 00 00 

	// Switch to the first process.
	run(&proc_array[1]);
  100251:	e8 23 02 00 00       	call   100479 <run>
  100256:	90                   	nop
  100257:	90                   	nop

00100258 <segments_init>:
segments_init(void)
{
	int i;

	// Set task state segment
	segments[SEGSEL_TASKSTATE >> 3]
  100258:	b8 e4 6d 10 00       	mov    $0x106de4,%eax
	kernel_task_descriptor.ts_ss0 = SEGSEL_KERN_DATA;

	// Set up interrupt descriptor table.
	// Most interrupts are effectively ignored
	for (i = 0; i < sizeof(interrupt_descriptors) / sizeof(gatedescriptor_t); i++)
		SETGATE(interrupt_descriptors[i], 0,
  10025d:	b9 5c 00 10 00       	mov    $0x10005c,%ecx
segments_init(void)
{
	int i;

	// Set task state segment
	segments[SEGSEL_TASKSTATE >> 3]
  100262:	89 c2                	mov    %eax,%edx
  100264:	c1 ea 10             	shr    $0x10,%edx
extern void default_int_handler(void);


void
segments_init(void)
{
  100267:	53                   	push   %ebx
	kernel_task_descriptor.ts_ss0 = SEGSEL_KERN_DATA;

	// Set up interrupt descriptor table.
	// Most interrupts are effectively ignored
	for (i = 0; i < sizeof(interrupt_descriptors) / sizeof(gatedescriptor_t); i++)
		SETGATE(interrupt_descriptors[i], 0,
  100268:	bb 5c 00 10 00       	mov    $0x10005c,%ebx
  10026d:	c1 eb 10             	shr    $0x10,%ebx
segments_init(void)
{
	int i;

	// Set task state segment
	segments[SEGSEL_TASKSTATE >> 3]
  100270:	66 a3 3a 10 10 00    	mov    %ax,0x10103a
  100276:	c1 e8 18             	shr    $0x18,%eax
  100279:	88 15 3c 10 10 00    	mov    %dl,0x10103c
	kernel_task_descriptor.ts_ss0 = SEGSEL_KERN_DATA;

	// Set up interrupt descriptor table.
	// Most interrupts are effectively ignored
	for (i = 0; i < sizeof(interrupt_descriptors) / sizeof(gatedescriptor_t); i++)
		SETGATE(interrupt_descriptors[i], 0,
  10027f:	ba 4c 6e 10 00       	mov    $0x106e4c,%edx
segments_init(void)
{
	int i;

	// Set task state segment
	segments[SEGSEL_TASKSTATE >> 3]
  100284:	a2 3f 10 10 00       	mov    %al,0x10103f
	kernel_task_descriptor.ts_ss0 = SEGSEL_KERN_DATA;

	// Set up interrupt descriptor table.
	// Most interrupts are effectively ignored
	for (i = 0; i < sizeof(interrupt_descriptors) / sizeof(gatedescriptor_t); i++)
		SETGATE(interrupt_descriptors[i], 0,
  100289:	31 c0                	xor    %eax,%eax
segments_init(void)
{
	int i;

	// Set task state segment
	segments[SEGSEL_TASKSTATE >> 3]
  10028b:	66 c7 05 38 10 10 00 	movw   $0x68,0x101038
  100292:	68 00 
  100294:	c6 05 3e 10 10 00 40 	movb   $0x40,0x10103e
		= SEG16(STS_T32A, (uint32_t) &kernel_task_descriptor,
			sizeof(taskstate_t), 0);
	segments[SEGSEL_TASKSTATE >> 3].sd_s = 0;
  10029b:	c6 05 3d 10 10 00 89 	movb   $0x89,0x10103d

	// Set up kernel task descriptor, so we can receive interrupts
	kernel_task_descriptor.ts_esp0 = KERNEL_STACK_TOP;
  1002a2:	c7 05 e8 6d 10 00 00 	movl   $0x180000,0x106de8
  1002a9:	00 18 00 
	kernel_task_descriptor.ts_ss0 = SEGSEL_KERN_DATA;
  1002ac:	66 c7 05 ec 6d 10 00 	movw   $0x10,0x106dec
  1002b3:	10 00 

	// Set up interrupt descriptor table.
	// Most interrupts are effectively ignored
	for (i = 0; i < sizeof(interrupt_descriptors) / sizeof(gatedescriptor_t); i++)
		SETGATE(interrupt_descriptors[i], 0,
  1002b5:	66 89 0c c5 4c 6e 10 	mov    %cx,0x106e4c(,%eax,8)
  1002bc:	00 
  1002bd:	66 c7 44 c2 02 08 00 	movw   $0x8,0x2(%edx,%eax,8)
  1002c4:	c6 44 c2 04 00       	movb   $0x0,0x4(%edx,%eax,8)
  1002c9:	c6 44 c2 05 8e       	movb   $0x8e,0x5(%edx,%eax,8)
  1002ce:	66 89 5c c2 06       	mov    %bx,0x6(%edx,%eax,8)
	kernel_task_descriptor.ts_esp0 = KERNEL_STACK_TOP;
	kernel_task_descriptor.ts_ss0 = SEGSEL_KERN_DATA;

	// Set up interrupt descriptor table.
	// Most interrupts are effectively ignored
	for (i = 0; i < sizeof(interrupt_descriptors) / sizeof(gatedescriptor_t); i++)
  1002d3:	40                   	inc    %eax
  1002d4:	3d 00 01 00 00       	cmp    $0x100,%eax
  1002d9:	75 da                	jne    1002b5 <segments_init+0x5d>
		SETGATE(interrupt_descriptors[i], 0,
			SEGSEL_KERN_CODE, default_int_handler, 0);

	// The clock interrupt gets special handling
	SETGATE(interrupt_descriptors[INT_CLOCK], 0,
  1002db:	b8 1a 00 10 00       	mov    $0x10001a,%eax

	// System calls get special handling.
	// Note that the last argument is '3'.  This means that unprivileged
	// (level-3) applications may generate these interrupts.
	for (i = INT_SYS_YIELD; i < INT_SYS_YIELD + 10; i++)
		SETGATE(interrupt_descriptors[i], 0,
  1002e0:	ba 4c 6e 10 00       	mov    $0x106e4c,%edx
	for (i = 0; i < sizeof(interrupt_descriptors) / sizeof(gatedescriptor_t); i++)
		SETGATE(interrupt_descriptors[i], 0,
			SEGSEL_KERN_CODE, default_int_handler, 0);

	// The clock interrupt gets special handling
	SETGATE(interrupt_descriptors[INT_CLOCK], 0,
  1002e5:	66 a3 4c 6f 10 00    	mov    %ax,0x106f4c
  1002eb:	c1 e8 10             	shr    $0x10,%eax
  1002ee:	66 a3 52 6f 10 00    	mov    %ax,0x106f52
  1002f4:	b8 30 00 00 00       	mov    $0x30,%eax
  1002f9:	66 c7 05 4e 6f 10 00 	movw   $0x8,0x106f4e
  100300:	08 00 
  100302:	c6 05 50 6f 10 00 00 	movb   $0x0,0x106f50
  100309:	c6 05 51 6f 10 00 8e 	movb   $0x8e,0x106f51

	// System calls get special handling.
	// Note that the last argument is '3'.  This means that unprivileged
	// (level-3) applications may generate these interrupts.
	for (i = INT_SYS_YIELD; i < INT_SYS_YIELD + 10; i++)
		SETGATE(interrupt_descriptors[i], 0,
  100310:	8b 0c 85 b2 ff 0f 00 	mov    0xfffb2(,%eax,4),%ecx
  100317:	66 c7 44 c2 02 08 00 	movw   $0x8,0x2(%edx,%eax,8)
  10031e:	66 89 0c c5 4c 6e 10 	mov    %cx,0x106e4c(,%eax,8)
  100325:	00 
  100326:	c1 e9 10             	shr    $0x10,%ecx
  100329:	c6 44 c2 04 00       	movb   $0x0,0x4(%edx,%eax,8)
  10032e:	c6 44 c2 05 ee       	movb   $0xee,0x5(%edx,%eax,8)
  100333:	66 89 4c c2 06       	mov    %cx,0x6(%edx,%eax,8)
		SEGSEL_KERN_CODE, clock_int_handler, 0);

	// System calls get special handling.
	// Note that the last argument is '3'.  This means that unprivileged
	// (level-3) applications may generate these interrupts.
	for (i = INT_SYS_YIELD; i < INT_SYS_YIELD + 10; i++)
  100338:	40                   	inc    %eax
  100339:	83 f8 3a             	cmp    $0x3a,%eax
  10033c:	75 d2                	jne    100310 <segments_init+0xb8>
		SETGATE(interrupt_descriptors[i], 0,
			SEGSEL_KERN_CODE, sys_int_handlers[i - INT_SYS_YIELD], 3);

	// Reload segment pointers
	asm volatile("lgdt global_descriptor_table\n\t"
  10033e:	b0 28                	mov    $0x28,%al
  100340:	0f 01 15 00 10 10 00 	lgdtl  0x101000
  100347:	0f 00 d8             	ltr    %ax
  10034a:	0f 01 1d 08 10 10 00 	lidtl  0x101008
		     "lidt interrupt_descriptor_table"
		     : : "r" ((uint16_t) SEGSEL_TASKSTATE));

	// Convince compiler that all symbols were used
	(void) global_descriptor_table, (void) interrupt_descriptor_table;
}
  100351:	5b                   	pop    %ebx
  100352:	c3                   	ret    

00100353 <interrupt_controller_init>:
#define	TIMER_FREQ	1193182
#define TIMER_DIV(x)	((TIMER_FREQ+(x)/2)/(x))

void
interrupt_controller_init(bool_t allow_clock_interrupt)
{
  100353:	55                   	push   %ebp
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  100354:	b0 ff                	mov    $0xff,%al
  100356:	57                   	push   %edi
  100357:	56                   	push   %esi
  100358:	53                   	push   %ebx
  100359:	bb 21 00 00 00       	mov    $0x21,%ebx
  10035e:	89 da                	mov    %ebx,%edx
  100360:	ee                   	out    %al,(%dx)
  100361:	b9 a1 00 00 00       	mov    $0xa1,%ecx
  100366:	89 ca                	mov    %ecx,%edx
  100368:	ee                   	out    %al,(%dx)
  100369:	be 11 00 00 00       	mov    $0x11,%esi
  10036e:	bf 20 00 00 00       	mov    $0x20,%edi
  100373:	89 f0                	mov    %esi,%eax
  100375:	89 fa                	mov    %edi,%edx
  100377:	ee                   	out    %al,(%dx)
  100378:	b0 20                	mov    $0x20,%al
  10037a:	89 da                	mov    %ebx,%edx
  10037c:	ee                   	out    %al,(%dx)
  10037d:	b0 04                	mov    $0x4,%al
  10037f:	ee                   	out    %al,(%dx)
  100380:	b0 03                	mov    $0x3,%al
  100382:	ee                   	out    %al,(%dx)
  100383:	bd a0 00 00 00       	mov    $0xa0,%ebp
  100388:	89 f0                	mov    %esi,%eax
  10038a:	89 ea                	mov    %ebp,%edx
  10038c:	ee                   	out    %al,(%dx)
  10038d:	b0 28                	mov    $0x28,%al
  10038f:	89 ca                	mov    %ecx,%edx
  100391:	ee                   	out    %al,(%dx)
  100392:	b0 02                	mov    $0x2,%al
  100394:	ee                   	out    %al,(%dx)
  100395:	b0 01                	mov    $0x1,%al
  100397:	ee                   	out    %al,(%dx)
  100398:	b0 68                	mov    $0x68,%al
  10039a:	89 fa                	mov    %edi,%edx
  10039c:	ee                   	out    %al,(%dx)
  10039d:	be 0a 00 00 00       	mov    $0xa,%esi
  1003a2:	89 f0                	mov    %esi,%eax
  1003a4:	ee                   	out    %al,(%dx)
  1003a5:	b0 68                	mov    $0x68,%al
  1003a7:	89 ea                	mov    %ebp,%edx
  1003a9:	ee                   	out    %al,(%dx)
  1003aa:	89 f0                	mov    %esi,%eax
  1003ac:	ee                   	out    %al,(%dx)

	outb(IO_PIC2, 0x68);               /* OCW3 */
	outb(IO_PIC2, 0x0a);               /* OCW3 */

	// mask all interrupts again, except possibly for clock interrupt
	outb(IO_PIC1+1, (allow_clock_interrupt ? 0xFE : 0xFF));
  1003ad:	83 7c 24 14 01       	cmpl   $0x1,0x14(%esp)
  1003b2:	89 da                	mov    %ebx,%edx
  1003b4:	19 c0                	sbb    %eax,%eax
  1003b6:	f7 d0                	not    %eax
  1003b8:	05 ff 00 00 00       	add    $0xff,%eax
  1003bd:	ee                   	out    %al,(%dx)
  1003be:	b0 ff                	mov    $0xff,%al
  1003c0:	89 ca                	mov    %ecx,%edx
  1003c2:	ee                   	out    %al,(%dx)
	outb(IO_PIC2+1, 0xFF);

	// if the clock interrupt is allowed, initialize the clock
	if (allow_clock_interrupt) {
  1003c3:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
  1003c8:	74 0d                	je     1003d7 <interrupt_controller_init+0x84>
  1003ca:	b2 43                	mov    $0x43,%dl
  1003cc:	b0 34                	mov    $0x34,%al
  1003ce:	ee                   	out    %al,(%dx)
  1003cf:	b0 9c                	mov    $0x9c,%al
  1003d1:	b2 40                	mov    $0x40,%dl
  1003d3:	ee                   	out    %al,(%dx)
  1003d4:	b0 2e                	mov    $0x2e,%al
  1003d6:	ee                   	out    %al,(%dx)
		outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
		outb(IO_TIMER1, TIMER_DIV(HZ) % 256);
		outb(IO_TIMER1, TIMER_DIV(HZ) / 256);
	}
}
  1003d7:	5b                   	pop    %ebx
  1003d8:	5e                   	pop    %esi
  1003d9:	5f                   	pop    %edi
  1003da:	5d                   	pop    %ebp
  1003db:	c3                   	ret    

001003dc <console_clear>:
 *
 *****************************************************************************/

void
console_clear(void)
{
  1003dc:	56                   	push   %esi
	int i;
	cursorpos = (uint16_t *) 0xB8000;
  1003dd:	31 c0                	xor    %eax,%eax
 *
 *****************************************************************************/

void
console_clear(void)
{
  1003df:	53                   	push   %ebx
	int i;
	cursorpos = (uint16_t *) 0xB8000;
  1003e0:	c7 05 00 80 19 00 00 	movl   $0xb8000,0x198000
  1003e7:	80 0b 00 

	for (i = 0; i < 80 * 25; i++)
		cursorpos[i] = ' ' | 0x0700;
  1003ea:	8b 15 00 80 19 00    	mov    0x198000,%edx
  1003f0:	66 c7 04 02 20 07    	movw   $0x720,(%edx,%eax,1)
  1003f6:	83 c0 02             	add    $0x2,%eax
console_clear(void)
{
	int i;
	cursorpos = (uint16_t *) 0xB8000;

	for (i = 0; i < 80 * 25; i++)
  1003f9:	3d a0 0f 00 00       	cmp    $0xfa0,%eax
  1003fe:	75 ea                	jne    1003ea <console_clear+0xe>
  100400:	be d4 03 00 00       	mov    $0x3d4,%esi
  100405:	b0 0e                	mov    $0xe,%al
  100407:	89 f2                	mov    %esi,%edx
  100409:	ee                   	out    %al,(%dx)
  10040a:	31 c9                	xor    %ecx,%ecx
  10040c:	bb d5 03 00 00       	mov    $0x3d5,%ebx
  100411:	88 c8                	mov    %cl,%al
  100413:	89 da                	mov    %ebx,%edx
  100415:	ee                   	out    %al,(%dx)
  100416:	b0 0f                	mov    $0xf,%al
  100418:	89 f2                	mov    %esi,%edx
  10041a:	ee                   	out    %al,(%dx)
  10041b:	88 c8                	mov    %cl,%al
  10041d:	89 da                	mov    %ebx,%edx
  10041f:	ee                   	out    %al,(%dx)
		cursorpos[i] = ' ' | 0x0700;
	outb(0x3D4, 14);
	outb(0x3D5, 0 / 256);
	outb(0x3D4, 15);
	outb(0x3D5, 0 % 256);
}
  100420:	5b                   	pop    %ebx
  100421:	5e                   	pop    %esi
  100422:	c3                   	ret    

00100423 <console_read_digit>:

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  100423:	ba 64 00 00 00       	mov    $0x64,%edx
  100428:	ec                   	in     (%dx),%al
int
console_read_digit(void)
{
	uint8_t data;

	if ((inb(KBSTATP) & KBS_DIB) == 0)
  100429:	a8 01                	test   $0x1,%al
  10042b:	74 45                	je     100472 <console_read_digit+0x4f>
  10042d:	b2 60                	mov    $0x60,%dl
  10042f:	ec                   	in     (%dx),%al
		return -1;

	data = inb(KBDATAP);
	if (data >= 0x02 && data <= 0x0A)
  100430:	8d 50 fe             	lea    -0x2(%eax),%edx
  100433:	80 fa 08             	cmp    $0x8,%dl
  100436:	77 05                	ja     10043d <console_read_digit+0x1a>
		return data - 0x02 + 1;
  100438:	0f b6 c0             	movzbl %al,%eax
  10043b:	48                   	dec    %eax
  10043c:	c3                   	ret    
	else if (data == 0x0B)
  10043d:	3c 0b                	cmp    $0xb,%al
  10043f:	74 35                	je     100476 <console_read_digit+0x53>
		return 0;
	else if (data >= 0x47 && data <= 0x49)
  100441:	8d 50 b9             	lea    -0x47(%eax),%edx
  100444:	80 fa 02             	cmp    $0x2,%dl
  100447:	77 07                	ja     100450 <console_read_digit+0x2d>
		return data - 0x47 + 7;
  100449:	0f b6 c0             	movzbl %al,%eax
  10044c:	83 e8 40             	sub    $0x40,%eax
  10044f:	c3                   	ret    
	else if (data >= 0x4B && data <= 0x4D)
  100450:	8d 50 b5             	lea    -0x4b(%eax),%edx
  100453:	80 fa 02             	cmp    $0x2,%dl
  100456:	77 07                	ja     10045f <console_read_digit+0x3c>
		return data - 0x4B + 4;
  100458:	0f b6 c0             	movzbl %al,%eax
  10045b:	83 e8 47             	sub    $0x47,%eax
  10045e:	c3                   	ret    
	else if (data >= 0x4F && data <= 0x51)
  10045f:	8d 50 b1             	lea    -0x4f(%eax),%edx
  100462:	80 fa 02             	cmp    $0x2,%dl
  100465:	77 07                	ja     10046e <console_read_digit+0x4b>
		return data - 0x4F + 1;
  100467:	0f b6 c0             	movzbl %al,%eax
  10046a:	83 e8 4e             	sub    $0x4e,%eax
  10046d:	c3                   	ret    
	else if (data == 0x53)
  10046e:	3c 53                	cmp    $0x53,%al
  100470:	74 04                	je     100476 <console_read_digit+0x53>
  100472:	83 c8 ff             	or     $0xffffffff,%eax
  100475:	c3                   	ret    
  100476:	31 c0                	xor    %eax,%eax
		return 0;
	else
		return -1;
}
  100478:	c3                   	ret    

00100479 <run>:
 *
 *****************************************************************************/

void
run(process_t *proc)
{
  100479:	8b 44 24 04          	mov    0x4(%esp),%eax
	current = proc;
  10047d:	a3 4c 76 10 00       	mov    %eax,0x10764c

	asm volatile("movl %0,%%esp\n\t"
  100482:	83 c0 04             	add    $0x4,%eax
  100485:	89 c4                	mov    %eax,%esp
  100487:	61                   	popa   
  100488:	07                   	pop    %es
  100489:	1f                   	pop    %ds
  10048a:	83 c4 08             	add    $0x8,%esp
  10048d:	cf                   	iret   
  10048e:	eb fe                	jmp    10048e <run+0x15>

00100490 <special_registers_init>:
 *
 *****************************************************************************/

void
special_registers_init(process_t *proc)
{
  100490:	53                   	push   %ebx
  100491:	83 ec 0c             	sub    $0xc,%esp
  100494:	8b 5c 24 14          	mov    0x14(%esp),%ebx
	memset(&proc->p_registers, 0, sizeof(registers_t));
  100498:	6a 44                	push   $0x44
  10049a:	6a 00                	push   $0x0
  10049c:	8d 43 04             	lea    0x4(%ebx),%eax
  10049f:	50                   	push   %eax
  1004a0:	e8 17 01 00 00       	call   1005bc <memset>
	proc->p_registers.reg_cs = SEGSEL_APP_CODE | 3;
  1004a5:	66 c7 43 38 1b 00    	movw   $0x1b,0x38(%ebx)
	proc->p_registers.reg_ds = SEGSEL_APP_DATA | 3;
  1004ab:	66 c7 43 28 23 00    	movw   $0x23,0x28(%ebx)
	proc->p_registers.reg_es = SEGSEL_APP_DATA | 3;
  1004b1:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	proc->p_registers.reg_ss = SEGSEL_APP_DATA | 3;
  1004b7:	66 c7 43 44 23 00    	movw   $0x23,0x44(%ebx)
	// Enable interrupts
	proc->p_registers.reg_eflags = EFLAGS_IF;
  1004bd:	c7 43 3c 00 02 00 00 	movl   $0x200,0x3c(%ebx)
}
  1004c4:	83 c4 18             	add    $0x18,%esp
  1004c7:	5b                   	pop    %ebx
  1004c8:	c3                   	ret    
  1004c9:	90                   	nop
  1004ca:	90                   	nop
  1004cb:	90                   	nop

001004cc <program_loader>:
		    uint32_t filesz, uint32_t memsz);
static void loader_panic(void);

void
program_loader(int program_id, uint32_t *entry_point)
{
  1004cc:	55                   	push   %ebp
  1004cd:	57                   	push   %edi
  1004ce:	56                   	push   %esi
  1004cf:	53                   	push   %ebx
  1004d0:	83 ec 1c             	sub    $0x1c,%esp
  1004d3:	8b 44 24 30          	mov    0x30(%esp),%eax
	struct Proghdr *ph, *eph;
	struct Elf *elf_header;
	int nprograms = sizeof(ramimages) / sizeof(ramimages[0]);

	if (program_id < 0 || program_id >= nprograms)
  1004d7:	83 f8 03             	cmp    $0x3,%eax
  1004da:	7f 04                	jg     1004e0 <program_loader+0x14>
  1004dc:	85 c0                	test   %eax,%eax
  1004de:	79 02                	jns    1004e2 <program_loader+0x16>
  1004e0:	eb fe                	jmp    1004e0 <program_loader+0x14>
		loader_panic();

	// is this a valid ELF?
	elf_header = (struct Elf *) ramimages[program_id].begin;
  1004e2:	8b 34 c5 40 10 10 00 	mov    0x101040(,%eax,8),%esi
	if (elf_header->e_magic != ELF_MAGIC)
  1004e9:	81 3e 7f 45 4c 46    	cmpl   $0x464c457f,(%esi)
  1004ef:	74 02                	je     1004f3 <program_loader+0x27>
  1004f1:	eb fe                	jmp    1004f1 <program_loader+0x25>
		loader_panic();

	// load each program segment (ignores ph flags)
	ph = (struct Proghdr*) ((const uint8_t *) elf_header + elf_header->e_phoff);
  1004f3:	8b 5e 1c             	mov    0x1c(%esi),%ebx
	eph = ph + elf_header->e_phnum;
  1004f6:	0f b7 6e 2c          	movzwl 0x2c(%esi),%ebp
	elf_header = (struct Elf *) ramimages[program_id].begin;
	if (elf_header->e_magic != ELF_MAGIC)
		loader_panic();

	// load each program segment (ignores ph flags)
	ph = (struct Proghdr*) ((const uint8_t *) elf_header + elf_header->e_phoff);
  1004fa:	01 f3                	add    %esi,%ebx
	eph = ph + elf_header->e_phnum;
  1004fc:	c1 e5 05             	shl    $0x5,%ebp
  1004ff:	8d 2c 2b             	lea    (%ebx,%ebp,1),%ebp
	for (; ph < eph; ph++)
  100502:	eb 3f                	jmp    100543 <program_loader+0x77>
		if (ph->p_type == ELF_PROG_LOAD)
  100504:	83 3b 01             	cmpl   $0x1,(%ebx)
  100507:	75 37                	jne    100540 <program_loader+0x74>
			copyseg((void *) ph->p_va,
  100509:	8b 43 08             	mov    0x8(%ebx),%eax
// then clear the memory from 'va+filesz' up to 'va+memsz' (set it to 0).
static void
copyseg(void *dst, const uint8_t *src, uint32_t filesz, uint32_t memsz)
{
	uint32_t va = (uint32_t) dst;
	uint32_t end_va = va + filesz;
  10050c:	8b 7b 10             	mov    0x10(%ebx),%edi
	memsz += va;
  10050f:	8b 53 14             	mov    0x14(%ebx),%edx
// then clear the memory from 'va+filesz' up to 'va+memsz' (set it to 0).
static void
copyseg(void *dst, const uint8_t *src, uint32_t filesz, uint32_t memsz)
{
	uint32_t va = (uint32_t) dst;
	uint32_t end_va = va + filesz;
  100512:	01 c7                	add    %eax,%edi
	memsz += va;
  100514:	01 c2                	add    %eax,%edx
	va &= ~(PAGESIZE - 1);		// round to page boundary
  100516:	25 00 f0 ff ff       	and    $0xfffff000,%eax
static void
copyseg(void *dst, const uint8_t *src, uint32_t filesz, uint32_t memsz)
{
	uint32_t va = (uint32_t) dst;
	uint32_t end_va = va + filesz;
	memsz += va;
  10051b:	89 54 24 0c          	mov    %edx,0xc(%esp)
	va &= ~(PAGESIZE - 1);		// round to page boundary

	// copy data
	memcpy((uint8_t *) va, src, end_va - va);
  10051f:	52                   	push   %edx
  100520:	89 fa                	mov    %edi,%edx
  100522:	29 c2                	sub    %eax,%edx
  100524:	52                   	push   %edx
  100525:	8b 53 04             	mov    0x4(%ebx),%edx
  100528:	01 f2                	add    %esi,%edx
  10052a:	52                   	push   %edx
  10052b:	50                   	push   %eax
  10052c:	e8 27 00 00 00       	call   100558 <memcpy>
  100531:	83 c4 10             	add    $0x10,%esp
  100534:	eb 04                	jmp    10053a <program_loader+0x6e>

	// clear bss segment
	while (end_va < memsz)
		*((uint8_t *) end_va++) = 0;
  100536:	c6 07 00             	movb   $0x0,(%edi)
  100539:	47                   	inc    %edi

	// copy data
	memcpy((uint8_t *) va, src, end_va - va);

	// clear bss segment
	while (end_va < memsz)
  10053a:	3b 7c 24 0c          	cmp    0xc(%esp),%edi
  10053e:	72 f6                	jb     100536 <program_loader+0x6a>
		loader_panic();

	// load each program segment (ignores ph flags)
	ph = (struct Proghdr*) ((const uint8_t *) elf_header + elf_header->e_phoff);
	eph = ph + elf_header->e_phnum;
	for (; ph < eph; ph++)
  100540:	83 c3 20             	add    $0x20,%ebx
  100543:	39 eb                	cmp    %ebp,%ebx
  100545:	72 bd                	jb     100504 <program_loader+0x38>
			copyseg((void *) ph->p_va,
				(const uint8_t *) elf_header + ph->p_offset,
				ph->p_filesz, ph->p_memsz);

	// store the entry point from the ELF header
	*entry_point = elf_header->e_entry;
  100547:	8b 56 18             	mov    0x18(%esi),%edx
  10054a:	8b 44 24 34          	mov    0x34(%esp),%eax
  10054e:	89 10                	mov    %edx,(%eax)
}
  100550:	83 c4 1c             	add    $0x1c,%esp
  100553:	5b                   	pop    %ebx
  100554:	5e                   	pop    %esi
  100555:	5f                   	pop    %edi
  100556:	5d                   	pop    %ebp
  100557:	c3                   	ret    

00100558 <memcpy>:
 *
 *   We must provide our own implementations of these basic functions. */

void *
memcpy(void *dst, const void *src, size_t n)
{
  100558:	56                   	push   %esi
  100559:	31 d2                	xor    %edx,%edx
  10055b:	53                   	push   %ebx
  10055c:	8b 44 24 0c          	mov    0xc(%esp),%eax
  100560:	8b 5c 24 10          	mov    0x10(%esp),%ebx
  100564:	8b 74 24 14          	mov    0x14(%esp),%esi
	const char *s = (const char *) src;
	char *d = (char *) dst;
	while (n-- > 0)
  100568:	eb 08                	jmp    100572 <memcpy+0x1a>
		*d++ = *s++;
  10056a:	8a 0c 13             	mov    (%ebx,%edx,1),%cl
  10056d:	4e                   	dec    %esi
  10056e:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  100571:	42                   	inc    %edx
void *
memcpy(void *dst, const void *src, size_t n)
{
	const char *s = (const char *) src;
	char *d = (char *) dst;
	while (n-- > 0)
  100572:	85 f6                	test   %esi,%esi
  100574:	75 f4                	jne    10056a <memcpy+0x12>
		*d++ = *s++;
	return dst;
}
  100576:	5b                   	pop    %ebx
  100577:	5e                   	pop    %esi
  100578:	c3                   	ret    

00100579 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  100579:	57                   	push   %edi
  10057a:	56                   	push   %esi
  10057b:	53                   	push   %ebx
  10057c:	8b 44 24 10          	mov    0x10(%esp),%eax
  100580:	8b 7c 24 14          	mov    0x14(%esp),%edi
  100584:	8b 54 24 18          	mov    0x18(%esp),%edx
	const char *s = (const char *) src;
	char *d = (char *) dst;
	if (s < d && s + n > d) {
  100588:	39 c7                	cmp    %eax,%edi
  10058a:	73 26                	jae    1005b2 <memmove+0x39>
  10058c:	8d 34 17             	lea    (%edi,%edx,1),%esi
  10058f:	39 c6                	cmp    %eax,%esi
  100591:	76 1f                	jbe    1005b2 <memmove+0x39>
		s += n, d += n;
  100593:	8d 3c 10             	lea    (%eax,%edx,1),%edi
  100596:	31 c9                	xor    %ecx,%ecx
		while (n-- > 0)
  100598:	eb 07                	jmp    1005a1 <memmove+0x28>
			*--d = *--s;
  10059a:	8a 1c 0e             	mov    (%esi,%ecx,1),%bl
  10059d:	4a                   	dec    %edx
  10059e:	88 1c 0f             	mov    %bl,(%edi,%ecx,1)
  1005a1:	49                   	dec    %ecx
{
	const char *s = (const char *) src;
	char *d = (char *) dst;
	if (s < d && s + n > d) {
		s += n, d += n;
		while (n-- > 0)
  1005a2:	85 d2                	test   %edx,%edx
  1005a4:	75 f4                	jne    10059a <memmove+0x21>
  1005a6:	eb 10                	jmp    1005b8 <memmove+0x3f>
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  1005a8:	8a 1c 0f             	mov    (%edi,%ecx,1),%bl
  1005ab:	4a                   	dec    %edx
  1005ac:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
  1005af:	41                   	inc    %ecx
  1005b0:	eb 02                	jmp    1005b4 <memmove+0x3b>
  1005b2:	31 c9                	xor    %ecx,%ecx
	if (s < d && s + n > d) {
		s += n, d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  1005b4:	85 d2                	test   %edx,%edx
  1005b6:	75 f0                	jne    1005a8 <memmove+0x2f>
			*d++ = *s++;
	return dst;
}
  1005b8:	5b                   	pop    %ebx
  1005b9:	5e                   	pop    %esi
  1005ba:	5f                   	pop    %edi
  1005bb:	c3                   	ret    

001005bc <memset>:

void *
memset(void *v, int c, size_t n)
{
  1005bc:	53                   	push   %ebx
  1005bd:	8b 44 24 08          	mov    0x8(%esp),%eax
  1005c1:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  1005c5:	8b 4c 24 10          	mov    0x10(%esp),%ecx
	char *p = (char *) v;
  1005c9:	89 c2                	mov    %eax,%edx
	while (n-- > 0)
  1005cb:	eb 04                	jmp    1005d1 <memset+0x15>
		*p++ = c;
  1005cd:	88 1a                	mov    %bl,(%edx)
  1005cf:	49                   	dec    %ecx
  1005d0:	42                   	inc    %edx

void *
memset(void *v, int c, size_t n)
{
	char *p = (char *) v;
	while (n-- > 0)
  1005d1:	85 c9                	test   %ecx,%ecx
  1005d3:	75 f8                	jne    1005cd <memset+0x11>
		*p++ = c;
	return v;
}
  1005d5:	5b                   	pop    %ebx
  1005d6:	c3                   	ret    

001005d7 <strlen>:

size_t
strlen(const char *s)
{
  1005d7:	8b 54 24 04          	mov    0x4(%esp),%edx
  1005db:	31 c0                	xor    %eax,%eax
	size_t n;
	for (n = 0; *s != '\0'; ++s)
  1005dd:	eb 01                	jmp    1005e0 <strlen+0x9>
		++n;
  1005df:	40                   	inc    %eax

size_t
strlen(const char *s)
{
	size_t n;
	for (n = 0; *s != '\0'; ++s)
  1005e0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  1005e4:	75 f9                	jne    1005df <strlen+0x8>
		++n;
	return n;
}
  1005e6:	c3                   	ret    

001005e7 <strnlen>:

size_t
strnlen(const char *s, size_t maxlen)
{
  1005e7:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  1005eb:	31 c0                	xor    %eax,%eax
  1005ed:	8b 54 24 08          	mov    0x8(%esp),%edx
	size_t n;
	for (n = 0; n != maxlen && *s != '\0'; ++s)
  1005f1:	eb 01                	jmp    1005f4 <strnlen+0xd>
		++n;
  1005f3:	40                   	inc    %eax

size_t
strnlen(const char *s, size_t maxlen)
{
	size_t n;
	for (n = 0; n != maxlen && *s != '\0'; ++s)
  1005f4:	39 d0                	cmp    %edx,%eax
  1005f6:	74 06                	je     1005fe <strnlen+0x17>
  1005f8:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  1005fc:	75 f5                	jne    1005f3 <strnlen+0xc>
		++n;
	return n;
}
  1005fe:	c3                   	ret    

001005ff <console_putc>:
 *
 *   Print a message onto the console, starting at the given cursor position. */

static uint16_t *
console_putc(uint16_t *cursor, unsigned char c, int color)
{
  1005ff:	56                   	push   %esi
	if (cursor >= CONSOLE_END)
  100600:	3d 9f 8f 0b 00       	cmp    $0xb8f9f,%eax
 *
 *   Print a message onto the console, starting at the given cursor position. */

static uint16_t *
console_putc(uint16_t *cursor, unsigned char c, int color)
{
  100605:	53                   	push   %ebx
  100606:	89 c3                	mov    %eax,%ebx
	if (cursor >= CONSOLE_END)
  100608:	76 05                	jbe    10060f <console_putc+0x10>
  10060a:	bb 00 80 0b 00       	mov    $0xb8000,%ebx
		cursor = CONSOLE_BEGIN;
	if (c == '\n') {
  10060f:	80 fa 0a             	cmp    $0xa,%dl
  100612:	75 2c                	jne    100640 <console_putc+0x41>
		int pos = (cursor - CONSOLE_BEGIN) % 80;
  100614:	8d 83 00 80 f4 ff    	lea    -0xb8000(%ebx),%eax
  10061a:	be 50 00 00 00       	mov    $0x50,%esi
  10061f:	d1 f8                	sar    %eax
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
  100621:	83 c9 20             	or     $0x20,%ecx
console_putc(uint16_t *cursor, unsigned char c, int color)
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
  100624:	99                   	cltd   
  100625:	f7 fe                	idiv   %esi
  100627:	89 de                	mov    %ebx,%esi
  100629:	89 d0                	mov    %edx,%eax
		for (; pos != 80; pos++)
  10062b:	eb 07                	jmp    100634 <console_putc+0x35>
			*cursor++ = ' ' | color;
  10062d:	66 89 0e             	mov    %cx,(%esi)
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
  100630:	40                   	inc    %eax
			*cursor++ = ' ' | color;
  100631:	83 c6 02             	add    $0x2,%esi
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
  100634:	83 f8 50             	cmp    $0x50,%eax
  100637:	75 f4                	jne    10062d <console_putc+0x2e>
  100639:	29 d0                	sub    %edx,%eax
  10063b:	8d 04 43             	lea    (%ebx,%eax,2),%eax
  10063e:	eb 0b                	jmp    10064b <console_putc+0x4c>
			*cursor++ = ' ' | color;
	} else
		*cursor++ = c | color;
  100640:	0f b6 d2             	movzbl %dl,%edx
  100643:	09 ca                	or     %ecx,%edx
  100645:	66 89 13             	mov    %dx,(%ebx)
  100648:	8d 43 02             	lea    0x2(%ebx),%eax
	return cursor;
}
  10064b:	5b                   	pop    %ebx
  10064c:	5e                   	pop    %esi
  10064d:	c3                   	ret    

0010064e <fill_numbuf>:
static const char lower_digits[] = "0123456789abcdef";

static char *
fill_numbuf(char *numbuf_end, uint32_t val, int base, const char *digits,
	    int precision)
{
  10064e:	56                   	push   %esi
  10064f:	53                   	push   %ebx
  100650:	8b 74 24 0c          	mov    0xc(%esp),%esi
	*--numbuf_end = '\0';
  100654:	8d 58 ff             	lea    -0x1(%eax),%ebx
  100657:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
	if (precision != 0 || val != 0)
  10065b:	83 7c 24 10 00       	cmpl   $0x0,0x10(%esp)
  100660:	75 04                	jne    100666 <fill_numbuf+0x18>
  100662:	85 d2                	test   %edx,%edx
  100664:	74 10                	je     100676 <fill_numbuf+0x28>
		do {
			*--numbuf_end = digits[val % base];
  100666:	89 d0                	mov    %edx,%eax
  100668:	31 d2                	xor    %edx,%edx
  10066a:	f7 f1                	div    %ecx
  10066c:	4b                   	dec    %ebx
  10066d:	8a 14 16             	mov    (%esi,%edx,1),%dl
  100670:	88 13                	mov    %dl,(%ebx)
			val /= base;
  100672:	89 c2                	mov    %eax,%edx
  100674:	eb ec                	jmp    100662 <fill_numbuf+0x14>
		} while (val != 0);
	return numbuf_end;
}
  100676:	89 d8                	mov    %ebx,%eax
  100678:	5b                   	pop    %ebx
  100679:	5e                   	pop    %esi
  10067a:	c3                   	ret    

0010067b <console_vprintf>:
#define FLAG_PLUSPOSITIVE	(1<<4)
static const char flag_chars[] = "#0- +";

uint16_t *
console_vprintf(uint16_t *cursor, int color, const char *format, va_list val)
{
  10067b:	55                   	push   %ebp
  10067c:	57                   	push   %edi
  10067d:	56                   	push   %esi
  10067e:	53                   	push   %ebx
  10067f:	83 ec 38             	sub    $0x38,%esp
  100682:	8b 74 24 4c          	mov    0x4c(%esp),%esi
  100686:	8b 7c 24 54          	mov    0x54(%esp),%edi
  10068a:	8b 5c 24 58          	mov    0x58(%esp),%ebx
	int flags, width, zeros, precision, negative, numeric, len;
#define NUMBUFSIZ 20
	char numbuf[NUMBUFSIZ];
	char *data;

	for (; *format; ++format) {
  10068e:	e9 60 03 00 00       	jmp    1009f3 <console_vprintf+0x378>
		if (*format != '%') {
  100693:	80 fa 25             	cmp    $0x25,%dl
  100696:	74 13                	je     1006ab <console_vprintf+0x30>
			cursor = console_putc(cursor, *format, color);
  100698:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  10069c:	0f b6 d2             	movzbl %dl,%edx
  10069f:	89 f0                	mov    %esi,%eax
  1006a1:	e8 59 ff ff ff       	call   1005ff <console_putc>
  1006a6:	e9 45 03 00 00       	jmp    1009f0 <console_vprintf+0x375>
			continue;
		}

		// process flags
		flags = 0;
		for (++format; *format; ++format) {
  1006ab:	47                   	inc    %edi
  1006ac:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  1006b3:	00 
  1006b4:	eb 12                	jmp    1006c8 <console_vprintf+0x4d>
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
				++flagc;
  1006b6:	41                   	inc    %ecx

		// process flags
		flags = 0;
		for (++format; *format; ++format) {
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
  1006b7:	8a 11                	mov    (%ecx),%dl
  1006b9:	84 d2                	test   %dl,%dl
  1006bb:	74 1a                	je     1006d7 <console_vprintf+0x5c>
  1006bd:	89 e8                	mov    %ebp,%eax
  1006bf:	38 c2                	cmp    %al,%dl
  1006c1:	75 f3                	jne    1006b6 <console_vprintf+0x3b>
  1006c3:	e9 3f 03 00 00       	jmp    100a07 <console_vprintf+0x38c>
			continue;
		}

		// process flags
		flags = 0;
		for (++format; *format; ++format) {
  1006c8:	8a 17                	mov    (%edi),%dl
  1006ca:	84 d2                	test   %dl,%dl
  1006cc:	74 0b                	je     1006d9 <console_vprintf+0x5e>
  1006ce:	b9 5c 0a 10 00       	mov    $0x100a5c,%ecx
  1006d3:	89 d5                	mov    %edx,%ebp
  1006d5:	eb e0                	jmp    1006b7 <console_vprintf+0x3c>
  1006d7:	89 ea                	mov    %ebp,%edx
			flags |= (1 << (flagc - flag_chars));
		}

		// process width
		width = -1;
		if (*format >= '1' && *format <= '9') {
  1006d9:	8d 42 cf             	lea    -0x31(%edx),%eax
  1006dc:	3c 08                	cmp    $0x8,%al
  1006de:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1006e5:	00 
  1006e6:	76 13                	jbe    1006fb <console_vprintf+0x80>
  1006e8:	eb 1d                	jmp    100707 <console_vprintf+0x8c>
			for (width = 0; *format >= '0' && *format <= '9'; )
				width = 10 * width + *format++ - '0';
  1006ea:	6b 54 24 0c 0a       	imul   $0xa,0xc(%esp),%edx
  1006ef:	0f be c0             	movsbl %al,%eax
  1006f2:	47                   	inc    %edi
  1006f3:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
  1006f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
		}

		// process width
		width = -1;
		if (*format >= '1' && *format <= '9') {
			for (width = 0; *format >= '0' && *format <= '9'; )
  1006fb:	8a 07                	mov    (%edi),%al
  1006fd:	8d 50 d0             	lea    -0x30(%eax),%edx
  100700:	80 fa 09             	cmp    $0x9,%dl
  100703:	76 e5                	jbe    1006ea <console_vprintf+0x6f>
  100705:	eb 18                	jmp    10071f <console_vprintf+0xa4>
				width = 10 * width + *format++ - '0';
		} else if (*format == '*') {
  100707:	80 fa 2a             	cmp    $0x2a,%dl
  10070a:	c7 44 24 0c ff ff ff 	movl   $0xffffffff,0xc(%esp)
  100711:	ff 
  100712:	75 0b                	jne    10071f <console_vprintf+0xa4>
			width = va_arg(val, int);
  100714:	83 c3 04             	add    $0x4,%ebx
			++format;
  100717:	47                   	inc    %edi
		width = -1;
		if (*format >= '1' && *format <= '9') {
			for (width = 0; *format >= '0' && *format <= '9'; )
				width = 10 * width + *format++ - '0';
		} else if (*format == '*') {
			width = va_arg(val, int);
  100718:	8b 53 fc             	mov    -0x4(%ebx),%edx
  10071b:	89 54 24 0c          	mov    %edx,0xc(%esp)
			++format;
		}

		// process precision
		precision = -1;
		if (*format == '.') {
  10071f:	83 cd ff             	or     $0xffffffff,%ebp
  100722:	80 3f 2e             	cmpb   $0x2e,(%edi)
  100725:	75 37                	jne    10075e <console_vprintf+0xe3>
			++format;
  100727:	47                   	inc    %edi
			if (*format >= '0' && *format <= '9') {
  100728:	31 ed                	xor    %ebp,%ebp
  10072a:	8a 07                	mov    (%edi),%al
  10072c:	8d 50 d0             	lea    -0x30(%eax),%edx
  10072f:	80 fa 09             	cmp    $0x9,%dl
  100732:	76 0d                	jbe    100741 <console_vprintf+0xc6>
  100734:	eb 17                	jmp    10074d <console_vprintf+0xd2>
				for (precision = 0; *format >= '0' && *format <= '9'; )
					precision = 10 * precision + *format++ - '0';
  100736:	6b ed 0a             	imul   $0xa,%ebp,%ebp
  100739:	0f be c0             	movsbl %al,%eax
  10073c:	47                   	inc    %edi
  10073d:	8d 6c 05 d0          	lea    -0x30(%ebp,%eax,1),%ebp
		// process precision
		precision = -1;
		if (*format == '.') {
			++format;
			if (*format >= '0' && *format <= '9') {
				for (precision = 0; *format >= '0' && *format <= '9'; )
  100741:	8a 07                	mov    (%edi),%al
  100743:	8d 50 d0             	lea    -0x30(%eax),%edx
  100746:	80 fa 09             	cmp    $0x9,%dl
  100749:	76 eb                	jbe    100736 <console_vprintf+0xbb>
  10074b:	eb 11                	jmp    10075e <console_vprintf+0xe3>
					precision = 10 * precision + *format++ - '0';
			} else if (*format == '*') {
  10074d:	3c 2a                	cmp    $0x2a,%al
  10074f:	75 0b                	jne    10075c <console_vprintf+0xe1>
				precision = va_arg(val, int);
  100751:	83 c3 04             	add    $0x4,%ebx
				++format;
  100754:	47                   	inc    %edi
			++format;
			if (*format >= '0' && *format <= '9') {
				for (precision = 0; *format >= '0' && *format <= '9'; )
					precision = 10 * precision + *format++ - '0';
			} else if (*format == '*') {
				precision = va_arg(val, int);
  100755:	8b 6b fc             	mov    -0x4(%ebx),%ebp
				++format;
			}
			if (precision < 0)
  100758:	85 ed                	test   %ebp,%ebp
  10075a:	79 02                	jns    10075e <console_vprintf+0xe3>
  10075c:	31 ed                	xor    %ebp,%ebp
		}

		// process main conversion character
		negative = 0;
		numeric = 0;
		switch (*format) {
  10075e:	8a 07                	mov    (%edi),%al
  100760:	3c 64                	cmp    $0x64,%al
  100762:	74 34                	je     100798 <console_vprintf+0x11d>
  100764:	7f 1d                	jg     100783 <console_vprintf+0x108>
  100766:	3c 58                	cmp    $0x58,%al
  100768:	0f 84 a2 00 00 00    	je     100810 <console_vprintf+0x195>
  10076e:	3c 63                	cmp    $0x63,%al
  100770:	0f 84 bf 00 00 00    	je     100835 <console_vprintf+0x1ba>
  100776:	3c 43                	cmp    $0x43,%al
  100778:	0f 85 d0 00 00 00    	jne    10084e <console_vprintf+0x1d3>
  10077e:	e9 a3 00 00 00       	jmp    100826 <console_vprintf+0x1ab>
  100783:	3c 75                	cmp    $0x75,%al
  100785:	74 4d                	je     1007d4 <console_vprintf+0x159>
  100787:	3c 78                	cmp    $0x78,%al
  100789:	74 5c                	je     1007e7 <console_vprintf+0x16c>
  10078b:	3c 73                	cmp    $0x73,%al
  10078d:	0f 85 bb 00 00 00    	jne    10084e <console_vprintf+0x1d3>
  100793:	e9 86 00 00 00       	jmp    10081e <console_vprintf+0x1a3>
		case 'd': {
			int x = va_arg(val, int);
  100798:	83 c3 04             	add    $0x4,%ebx
  10079b:	8b 53 fc             	mov    -0x4(%ebx),%edx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x > 0 ? x : -x, 10, upper_digits, precision);
  10079e:	89 d1                	mov    %edx,%ecx
  1007a0:	c1 f9 1f             	sar    $0x1f,%ecx
  1007a3:	89 0c 24             	mov    %ecx,(%esp)
  1007a6:	31 ca                	xor    %ecx,%edx
  1007a8:	55                   	push   %ebp
  1007a9:	29 ca                	sub    %ecx,%edx
  1007ab:	68 64 0a 10 00       	push   $0x100a64
  1007b0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  1007b5:	8d 44 24 40          	lea    0x40(%esp),%eax
  1007b9:	e8 90 fe ff ff       	call   10064e <fill_numbuf>
  1007be:	89 44 24 0c          	mov    %eax,0xc(%esp)
			if (x < 0)
  1007c2:	58                   	pop    %eax
  1007c3:	5a                   	pop    %edx
  1007c4:	ba 01 00 00 00       	mov    $0x1,%edx
  1007c9:	8b 04 24             	mov    (%esp),%eax
  1007cc:	83 e0 01             	and    $0x1,%eax
  1007cf:	e9 a5 00 00 00       	jmp    100879 <console_vprintf+0x1fe>
				negative = 1;
			numeric = 1;
			break;
		}
		case 'u': {
			unsigned x = va_arg(val, unsigned);
  1007d4:	83 c3 04             	add    $0x4,%ebx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 10, upper_digits, precision);
  1007d7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  1007dc:	8b 53 fc             	mov    -0x4(%ebx),%edx
  1007df:	55                   	push   %ebp
  1007e0:	68 64 0a 10 00       	push   $0x100a64
  1007e5:	eb 11                	jmp    1007f8 <console_vprintf+0x17d>
			numeric = 1;
			break;
		}
		case 'x': {
			unsigned x = va_arg(val, unsigned);
  1007e7:	83 c3 04             	add    $0x4,%ebx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 16, lower_digits, precision);
  1007ea:	8b 53 fc             	mov    -0x4(%ebx),%edx
  1007ed:	55                   	push   %ebp
  1007ee:	68 78 0a 10 00       	push   $0x100a78
  1007f3:	b9 10 00 00 00       	mov    $0x10,%ecx
  1007f8:	8d 44 24 40          	lea    0x40(%esp),%eax
  1007fc:	e8 4d fe ff ff       	call   10064e <fill_numbuf>
  100801:	ba 01 00 00 00       	mov    $0x1,%edx
  100806:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10080a:	31 c0                	xor    %eax,%eax
			numeric = 1;
			break;
  10080c:	59                   	pop    %ecx
  10080d:	59                   	pop    %ecx
  10080e:	eb 69                	jmp    100879 <console_vprintf+0x1fe>
		}
		case 'X': {
			unsigned x = va_arg(val, unsigned);
  100810:	83 c3 04             	add    $0x4,%ebx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 16, upper_digits, precision);
  100813:	8b 53 fc             	mov    -0x4(%ebx),%edx
  100816:	55                   	push   %ebp
  100817:	68 64 0a 10 00       	push   $0x100a64
  10081c:	eb d5                	jmp    1007f3 <console_vprintf+0x178>
			numeric = 1;
			break;
		}
		case 's':
			data = va_arg(val, char *);
  10081e:	83 c3 04             	add    $0x4,%ebx
  100821:	8b 43 fc             	mov    -0x4(%ebx),%eax
  100824:	eb 40                	jmp    100866 <console_vprintf+0x1eb>
			break;
		case 'C':
			color = va_arg(val, int);
  100826:	83 c3 04             	add    $0x4,%ebx
  100829:	8b 53 fc             	mov    -0x4(%ebx),%edx
  10082c:	89 54 24 50          	mov    %edx,0x50(%esp)
			goto done;
  100830:	e9 bd 01 00 00       	jmp    1009f2 <console_vprintf+0x377>
		case 'c':
			data = numbuf;
			numbuf[0] = va_arg(val, int);
  100835:	83 c3 04             	add    $0x4,%ebx
  100838:	8b 43 fc             	mov    -0x4(%ebx),%eax
			numbuf[1] = '\0';
  10083b:	8d 4c 24 24          	lea    0x24(%esp),%ecx
  10083f:	c6 44 24 25 00       	movb   $0x0,0x25(%esp)
  100844:	89 4c 24 04          	mov    %ecx,0x4(%esp)
		case 'C':
			color = va_arg(val, int);
			goto done;
		case 'c':
			data = numbuf;
			numbuf[0] = va_arg(val, int);
  100848:	88 44 24 24          	mov    %al,0x24(%esp)
  10084c:	eb 27                	jmp    100875 <console_vprintf+0x1fa>
			numbuf[1] = '\0';
			break;
		normal:
		default:
			data = numbuf;
			numbuf[0] = (*format ? *format : '%');
  10084e:	84 c0                	test   %al,%al
  100850:	75 02                	jne    100854 <console_vprintf+0x1d9>
  100852:	b0 25                	mov    $0x25,%al
  100854:	88 44 24 24          	mov    %al,0x24(%esp)
			numbuf[1] = '\0';
  100858:	c6 44 24 25 00       	movb   $0x0,0x25(%esp)
			if (!*format)
  10085d:	80 3f 00             	cmpb   $0x0,(%edi)
  100860:	74 0a                	je     10086c <console_vprintf+0x1f1>
  100862:	8d 44 24 24          	lea    0x24(%esp),%eax
  100866:	89 44 24 04          	mov    %eax,0x4(%esp)
  10086a:	eb 09                	jmp    100875 <console_vprintf+0x1fa>
				format--;
  10086c:	8d 54 24 24          	lea    0x24(%esp),%edx
  100870:	4f                   	dec    %edi
  100871:	89 54 24 04          	mov    %edx,0x4(%esp)
  100875:	31 d2                	xor    %edx,%edx
  100877:	31 c0                	xor    %eax,%eax
			break;
		}

		if (precision >= 0)
			len = strnlen(data, precision);
  100879:	31 c9                	xor    %ecx,%ecx
			if (!*format)
				format--;
			break;
		}

		if (precision >= 0)
  10087b:	83 fd ff             	cmp    $0xffffffff,%ebp
  10087e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100885:	74 1f                	je     1008a6 <console_vprintf+0x22b>
  100887:	89 04 24             	mov    %eax,(%esp)
  10088a:	eb 01                	jmp    10088d <console_vprintf+0x212>
size_t
strnlen(const char *s, size_t maxlen)
{
	size_t n;
	for (n = 0; n != maxlen && *s != '\0'; ++s)
		++n;
  10088c:	41                   	inc    %ecx

size_t
strnlen(const char *s, size_t maxlen)
{
	size_t n;
	for (n = 0; n != maxlen && *s != '\0'; ++s)
  10088d:	39 e9                	cmp    %ebp,%ecx
  10088f:	74 0a                	je     10089b <console_vprintf+0x220>
  100891:	8b 44 24 04          	mov    0x4(%esp),%eax
  100895:	80 3c 08 00          	cmpb   $0x0,(%eax,%ecx,1)
  100899:	75 f1                	jne    10088c <console_vprintf+0x211>
  10089b:	8b 04 24             	mov    (%esp),%eax
				format--;
			break;
		}

		if (precision >= 0)
			len = strnlen(data, precision);
  10089e:	89 0c 24             	mov    %ecx,(%esp)
  1008a1:	eb 1f                	jmp    1008c2 <console_vprintf+0x247>
size_t
strlen(const char *s)
{
	size_t n;
	for (n = 0; *s != '\0'; ++s)
		++n;
  1008a3:	42                   	inc    %edx
  1008a4:	eb 09                	jmp    1008af <console_vprintf+0x234>
  1008a6:	89 d1                	mov    %edx,%ecx
  1008a8:	8b 14 24             	mov    (%esp),%edx
  1008ab:	89 44 24 08          	mov    %eax,0x8(%esp)

size_t
strlen(const char *s)
{
	size_t n;
	for (n = 0; *s != '\0'; ++s)
  1008af:	8b 44 24 04          	mov    0x4(%esp),%eax
  1008b3:	80 3c 10 00          	cmpb   $0x0,(%eax,%edx,1)
  1008b7:	75 ea                	jne    1008a3 <console_vprintf+0x228>
  1008b9:	8b 44 24 08          	mov    0x8(%esp),%eax
  1008bd:	89 14 24             	mov    %edx,(%esp)
  1008c0:	89 ca                	mov    %ecx,%edx

		if (precision >= 0)
			len = strnlen(data, precision);
		else
			len = strlen(data);
		if (numeric && negative)
  1008c2:	85 c0                	test   %eax,%eax
  1008c4:	74 0c                	je     1008d2 <console_vprintf+0x257>
  1008c6:	84 d2                	test   %dl,%dl
  1008c8:	c7 44 24 08 2d 00 00 	movl   $0x2d,0x8(%esp)
  1008cf:	00 
  1008d0:	75 24                	jne    1008f6 <console_vprintf+0x27b>
			negative = '-';
		else if (flags & FLAG_PLUSPOSITIVE)
  1008d2:	f6 44 24 14 10       	testb  $0x10,0x14(%esp)
  1008d7:	c7 44 24 08 2b 00 00 	movl   $0x2b,0x8(%esp)
  1008de:	00 
  1008df:	75 15                	jne    1008f6 <console_vprintf+0x27b>
			negative = '+';
		else if (flags & FLAG_SPACEPOSITIVE)
  1008e1:	8b 44 24 14          	mov    0x14(%esp),%eax
  1008e5:	83 e0 08             	and    $0x8,%eax
  1008e8:	83 f8 01             	cmp    $0x1,%eax
  1008eb:	19 c9                	sbb    %ecx,%ecx
  1008ed:	f7 d1                	not    %ecx
  1008ef:	83 e1 20             	and    $0x20,%ecx
  1008f2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
			negative = ' ';
		else
			negative = 0;
		if (numeric && precision > len)
  1008f6:	3b 2c 24             	cmp    (%esp),%ebp
  1008f9:	7e 0d                	jle    100908 <console_vprintf+0x28d>
  1008fb:	84 d2                	test   %dl,%dl
  1008fd:	74 40                	je     10093f <console_vprintf+0x2c4>
			zeros = precision - len;
  1008ff:	2b 2c 24             	sub    (%esp),%ebp
  100902:	89 6c 24 10          	mov    %ebp,0x10(%esp)
  100906:	eb 3f                	jmp    100947 <console_vprintf+0x2cc>
		else if ((flags & (FLAG_ZERO | FLAG_LEFTJUSTIFY)) == FLAG_ZERO
  100908:	84 d2                	test   %dl,%dl
  10090a:	74 33                	je     10093f <console_vprintf+0x2c4>
  10090c:	8b 44 24 14          	mov    0x14(%esp),%eax
  100910:	83 e0 06             	and    $0x6,%eax
  100913:	83 f8 02             	cmp    $0x2,%eax
  100916:	75 27                	jne    10093f <console_vprintf+0x2c4>
  100918:	45                   	inc    %ebp
  100919:	75 24                	jne    10093f <console_vprintf+0x2c4>
			 && numeric && precision < 0
			 && len + !!negative < width)
  10091b:	31 c0                	xor    %eax,%eax
			negative = ' ';
		else
			negative = 0;
		if (numeric && precision > len)
			zeros = precision - len;
		else if ((flags & (FLAG_ZERO | FLAG_LEFTJUSTIFY)) == FLAG_ZERO
  10091d:	8b 0c 24             	mov    (%esp),%ecx
			 && numeric && precision < 0
			 && len + !!negative < width)
  100920:	83 7c 24 08 00       	cmpl   $0x0,0x8(%esp)
  100925:	0f 95 c0             	setne  %al
			negative = ' ';
		else
			negative = 0;
		if (numeric && precision > len)
			zeros = precision - len;
		else if ((flags & (FLAG_ZERO | FLAG_LEFTJUSTIFY)) == FLAG_ZERO
  100928:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  10092b:	3b 54 24 0c          	cmp    0xc(%esp),%edx
  10092f:	7d 0e                	jge    10093f <console_vprintf+0x2c4>
			 && numeric && precision < 0
			 && len + !!negative < width)
			zeros = width - len - !!negative;
  100931:	8b 54 24 0c          	mov    0xc(%esp),%edx
  100935:	29 ca                	sub    %ecx,%edx
  100937:	29 c2                	sub    %eax,%edx
  100939:	89 54 24 10          	mov    %edx,0x10(%esp)
			negative = ' ';
		else
			negative = 0;
		if (numeric && precision > len)
			zeros = precision - len;
		else if ((flags & (FLAG_ZERO | FLAG_LEFTJUSTIFY)) == FLAG_ZERO
  10093d:	eb 08                	jmp    100947 <console_vprintf+0x2cc>
  10093f:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  100946:	00 
			 && numeric && precision < 0
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
  100947:	8b 6c 24 0c          	mov    0xc(%esp),%ebp
  10094b:	31 c0                	xor    %eax,%eax
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  10094d:	8b 4c 24 14          	mov    0x14(%esp),%ecx
			 && numeric && precision < 0
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
  100951:	2b 2c 24             	sub    (%esp),%ebp
  100954:	83 7c 24 08 00       	cmpl   $0x0,0x8(%esp)
  100959:	0f 95 c0             	setne  %al
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  10095c:	83 e1 04             	and    $0x4,%ecx
			 && numeric && precision < 0
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
  10095f:	29 c5                	sub    %eax,%ebp
  100961:	89 f0                	mov    %esi,%eax
  100963:	2b 6c 24 10          	sub    0x10(%esp),%ebp
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  100967:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  10096b:	eb 0f                	jmp    10097c <console_vprintf+0x301>
			cursor = console_putc(cursor, ' ', color);
  10096d:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  100971:	ba 20 00 00 00       	mov    $0x20,%edx
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  100976:	4d                   	dec    %ebp
			cursor = console_putc(cursor, ' ', color);
  100977:	e8 83 fc ff ff       	call   1005ff <console_putc>
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  10097c:	85 ed                	test   %ebp,%ebp
  10097e:	7e 07                	jle    100987 <console_vprintf+0x30c>
  100980:	83 7c 24 0c 00       	cmpl   $0x0,0xc(%esp)
  100985:	74 e6                	je     10096d <console_vprintf+0x2f2>
			cursor = console_putc(cursor, ' ', color);
		if (negative)
  100987:	83 7c 24 08 00       	cmpl   $0x0,0x8(%esp)
  10098c:	89 c6                	mov    %eax,%esi
  10098e:	74 23                	je     1009b3 <console_vprintf+0x338>
			cursor = console_putc(cursor, negative, color);
  100990:	0f b6 54 24 08       	movzbl 0x8(%esp),%edx
  100995:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  100999:	e8 61 fc ff ff       	call   1005ff <console_putc>
  10099e:	89 c6                	mov    %eax,%esi
  1009a0:	eb 11                	jmp    1009b3 <console_vprintf+0x338>
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
  1009a2:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  1009a6:	ba 30 00 00 00       	mov    $0x30,%edx
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
  1009ab:	4e                   	dec    %esi
			cursor = console_putc(cursor, '0', color);
  1009ac:	e8 4e fc ff ff       	call   1005ff <console_putc>
  1009b1:	eb 06                	jmp    1009b9 <console_vprintf+0x33e>
  1009b3:	89 f0                	mov    %esi,%eax
  1009b5:	8b 74 24 10          	mov    0x10(%esp),%esi
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
  1009b9:	85 f6                	test   %esi,%esi
  1009bb:	7f e5                	jg     1009a2 <console_vprintf+0x327>
  1009bd:	8b 34 24             	mov    (%esp),%esi
  1009c0:	eb 15                	jmp    1009d7 <console_vprintf+0x35c>
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
			cursor = console_putc(cursor, *data, color);
  1009c2:	8b 4c 24 04          	mov    0x4(%esp),%ecx
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
  1009c6:	4e                   	dec    %esi
			cursor = console_putc(cursor, *data, color);
  1009c7:	0f b6 11             	movzbl (%ecx),%edx
  1009ca:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  1009ce:	e8 2c fc ff ff       	call   1005ff <console_putc>
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
  1009d3:	ff 44 24 04          	incl   0x4(%esp)
  1009d7:	85 f6                	test   %esi,%esi
  1009d9:	7f e7                	jg     1009c2 <console_vprintf+0x347>
  1009db:	eb 0f                	jmp    1009ec <console_vprintf+0x371>
			cursor = console_putc(cursor, *data, color);
		for (; width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
  1009dd:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  1009e1:	ba 20 00 00 00       	mov    $0x20,%edx
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
			cursor = console_putc(cursor, *data, color);
		for (; width > 0; --width)
  1009e6:	4d                   	dec    %ebp
			cursor = console_putc(cursor, ' ', color);
  1009e7:	e8 13 fc ff ff       	call   1005ff <console_putc>
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
			cursor = console_putc(cursor, *data, color);
		for (; width > 0; --width)
  1009ec:	85 ed                	test   %ebp,%ebp
  1009ee:	7f ed                	jg     1009dd <console_vprintf+0x362>
  1009f0:	89 c6                	mov    %eax,%esi
	int flags, width, zeros, precision, negative, numeric, len;
#define NUMBUFSIZ 20
	char numbuf[NUMBUFSIZ];
	char *data;

	for (; *format; ++format) {
  1009f2:	47                   	inc    %edi
  1009f3:	8a 17                	mov    (%edi),%dl
  1009f5:	84 d2                	test   %dl,%dl
  1009f7:	0f 85 96 fc ff ff    	jne    100693 <console_vprintf+0x18>
			cursor = console_putc(cursor, ' ', color);
	done: ;
	}

	return cursor;
}
  1009fd:	83 c4 38             	add    $0x38,%esp
  100a00:	89 f0                	mov    %esi,%eax
  100a02:	5b                   	pop    %ebx
  100a03:	5e                   	pop    %esi
  100a04:	5f                   	pop    %edi
  100a05:	5d                   	pop    %ebp
  100a06:	c3                   	ret    
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
				++flagc;
			if (*flagc == '\0')
				break;
			flags |= (1 << (flagc - flag_chars));
  100a07:	81 e9 5c 0a 10 00    	sub    $0x100a5c,%ecx
  100a0d:	b8 01 00 00 00       	mov    $0x1,%eax
  100a12:	d3 e0                	shl    %cl,%eax
			continue;
		}

		// process flags
		flags = 0;
		for (++format; *format; ++format) {
  100a14:	47                   	inc    %edi
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
				++flagc;
			if (*flagc == '\0')
				break;
			flags |= (1 << (flagc - flag_chars));
  100a15:	09 44 24 14          	or     %eax,0x14(%esp)
  100a19:	e9 aa fc ff ff       	jmp    1006c8 <console_vprintf+0x4d>

00100a1e <console_printf>:
uint16_t *
console_printf(uint16_t *cursor, int color, const char *format, ...)
{
	va_list val;
	va_start(val, format);
	cursor = console_vprintf(cursor, color, format, val);
  100a1e:	8d 44 24 10          	lea    0x10(%esp),%eax
  100a22:	50                   	push   %eax
  100a23:	ff 74 24 10          	pushl  0x10(%esp)
  100a27:	ff 74 24 10          	pushl  0x10(%esp)
  100a2b:	ff 74 24 10          	pushl  0x10(%esp)
  100a2f:	e8 47 fc ff ff       	call   10067b <console_vprintf>
  100a34:	83 c4 10             	add    $0x10,%esp
	va_end(val);
	return cursor;
}
  100a37:	c3                   	ret    
