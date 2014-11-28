
obj/mpos-kern:     file format elf32-i386


Disassembly of section .text:

00100000 <multiboot>:
  100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
  100006:	00 00                	add    %al,(%eax)
  100008:	fe 4f 52             	decb   0x52(%edi)
  10000b:	e4 bc                	in     $0xbc,%al

0010000c <multiboot_start>:
# The multiboot_start routine sets the stack pointer to the top of the
# MiniprocOS's kernel stack, then jumps to the 'start' routine in mpos-kern.c.

.globl multiboot_start
multiboot_start:
	movl $0x200000, %esp
  10000c:	bc 00 00 20 00       	mov    $0x200000,%esp
	pushl $0
  100011:	6a 00                	push   $0x0
	popfl
  100013:	9d                   	popf   
	call start
  100014:	e8 15 02 00 00       	call   10022e <start>
  100019:	90                   	nop

0010001a <sys_int48_handler>:

# Interrupt handlers
.align 2

sys_int48_handler:
	pushl $0
  10001a:	6a 00                	push   $0x0
	pushl $48
  10001c:	6a 30                	push   $0x30
	jmp _generic_int_handler
  10001e:	eb 3a                	jmp    10005a <_generic_int_handler>

00100020 <sys_int49_handler>:

sys_int49_handler:
	pushl $0
  100020:	6a 00                	push   $0x0
	pushl $49
  100022:	6a 31                	push   $0x31
	jmp _generic_int_handler
  100024:	eb 34                	jmp    10005a <_generic_int_handler>

00100026 <sys_int50_handler>:

sys_int50_handler:
	pushl $0
  100026:	6a 00                	push   $0x0
	pushl $50
  100028:	6a 32                	push   $0x32
	jmp _generic_int_handler
  10002a:	eb 2e                	jmp    10005a <_generic_int_handler>

0010002c <sys_int51_handler>:

sys_int51_handler:
	pushl $0
  10002c:	6a 00                	push   $0x0
	pushl $51
  10002e:	6a 33                	push   $0x33
	jmp _generic_int_handler
  100030:	eb 28                	jmp    10005a <_generic_int_handler>

00100032 <sys_int52_handler>:

sys_int52_handler:
	pushl $0
  100032:	6a 00                	push   $0x0
	pushl $52
  100034:	6a 34                	push   $0x34
	jmp _generic_int_handler
  100036:	eb 22                	jmp    10005a <_generic_int_handler>

00100038 <sys_int53_handler>:

sys_int53_handler:
	pushl $0
  100038:	6a 00                	push   $0x0
	pushl $53
  10003a:	6a 35                	push   $0x35
	jmp _generic_int_handler
  10003c:	eb 1c                	jmp    10005a <_generic_int_handler>

0010003e <sys_int54_handler>:

sys_int54_handler:
	pushl $0
  10003e:	6a 00                	push   $0x0
	pushl $54
  100040:	6a 36                	push   $0x36
	jmp _generic_int_handler
  100042:	eb 16                	jmp    10005a <_generic_int_handler>

00100044 <sys_int55_handler>:

sys_int55_handler:
	pushl $0
  100044:	6a 00                	push   $0x0
	pushl $55
  100046:	6a 37                	push   $0x37
	jmp _generic_int_handler
  100048:	eb 10                	jmp    10005a <_generic_int_handler>

0010004a <sys_int56_handler>:

sys_int56_handler:
	pushl $0
  10004a:	6a 00                	push   $0x0
	pushl $56
  10004c:	6a 38                	push   $0x38
	jmp _generic_int_handler
  10004e:	eb 0a                	jmp    10005a <_generic_int_handler>

00100050 <sys_int57_handler>:

sys_int57_handler:
	pushl $0
  100050:	6a 00                	push   $0x0
	pushl $57
  100052:	6a 39                	push   $0x39
	jmp _generic_int_handler
  100054:	eb 04                	jmp    10005a <_generic_int_handler>

00100056 <default_int_handler>:

	.globl default_int_handler
default_int_handler:
	pushl $0
  100056:	6a 00                	push   $0x0
	jmp _generic_int_handler
  100058:	eb 00                	jmp    10005a <_generic_int_handler>

0010005a <_generic_int_handler>:
	# When we get here, the processor's interrupt mechanism has
	# pushed the old task status and stack registers onto the kernel stack.
	# Then one of the specific handlers pushed the interrupt number.
	# Now, we complete the 'registers_t' structure by pushing the extra
	# segment definitions and the general CPU registers.
	pushl %ds
  10005a:	1e                   	push   %ds
	pushl %es
  10005b:	06                   	push   %es
	pushal
  10005c:	60                   	pusha  

	# Call the kernel's 'interrupt' function.
	pushl %esp
  10005d:	54                   	push   %esp
	call interrupt
  10005e:	e8 5e 00 00 00       	call   1000c1 <interrupt>

00100063 <sys_int_handlers>:
  100063:	1a 00                	sbb    (%eax),%al
  100065:	10 00                	adc    %al,(%eax)
  100067:	20 00                	and    %al,(%eax)
  100069:	10 00                	adc    %al,(%eax)
  10006b:	26 00 10             	add    %dl,%es:(%eax)
  10006e:	00 2c 00             	add    %ch,(%eax,%eax,1)
  100071:	10 00                	adc    %al,(%eax)
  100073:	32 00                	xor    (%eax),%al
  100075:	10 00                	adc    %al,(%eax)
  100077:	38 00                	cmp    %al,(%eax)
  100079:	10 00                	adc    %al,(%eax)
  10007b:	3e 00 10             	add    %dl,%ds:(%eax)
  10007e:	00 44 00 10          	add    %al,0x10(%eax,%eax,1)
  100082:	00 4a 00             	add    %cl,0x0(%edx)
  100085:	10 00                	adc    %al,(%eax)
  100087:	50                   	push   %eax
  100088:	00 10                	add    %dl,(%eax)
  10008a:	00 90 83 ec 0c a1    	add    %dl,-0x5ef3137d(%eax)

0010008c <schedule>:
 *
 *****************************************************************************/

void
schedule(void)
{
  10008c:	83 ec 0c             	sub    $0xc,%esp
	pid_t pid = current->p_pid;
  10008f:	a1 a4 9f 10 00       	mov    0x109fa4,%eax
	while (1) {
		pid = (pid + 1) % NPROCS;
  100094:	b9 10 00 00 00       	mov    $0x10,%ecx
 *****************************************************************************/

void
schedule(void)
{
	pid_t pid = current->p_pid;
  100099:	8b 10                	mov    (%eax),%edx
	while (1) {
		pid = (pid + 1) % NPROCS;
  10009b:	8d 42 01             	lea    0x1(%edx),%eax
  10009e:	99                   	cltd   
  10009f:	f7 f9                	idiv   %ecx
		if (proc_array[pid].p_state == P_RUNNABLE && proc_array[pid].p_waiting == 0)
  1000a1:	6b c2 54             	imul   $0x54,%edx,%eax
  1000a4:	83 b8 44 92 10 00 01 	cmpl   $0x1,0x109244(%eax)
  1000ab:	75 ee                	jne    10009b <schedule+0xf>
  1000ad:	05 fc 91 10 00       	add    $0x1091fc,%eax
  1000b2:	83 78 50 00          	cmpl   $0x0,0x50(%eax)
  1000b6:	75 e3                	jne    10009b <schedule+0xf>
			run(&proc_array[pid]);
  1000b8:	83 ec 0c             	sub    $0xc,%esp
  1000bb:	50                   	push   %eax
  1000bc:	e8 8f 03 00 00       	call   100450 <run>

001000c1 <interrupt>:

static pid_t do_fork(process_t *parent);

void
interrupt(registers_t *reg)
{
  1000c1:	55                   	push   %ebp
	// the application's state on the kernel's stack, then jumping to
	// kernel assembly code (in mpos-int.S, for your information).
	// That code saves more registers on the kernel's stack, then calls
	// interrupt().  The first thing we must do, then, is copy the saved
	// registers into the 'current' process descriptor.
	current->p_registers = *reg;
  1000c2:	b9 11 00 00 00       	mov    $0x11,%ecx

static pid_t do_fork(process_t *parent);

void
interrupt(registers_t *reg)
{
  1000c7:	57                   	push   %edi
  1000c8:	56                   	push   %esi
  1000c9:	53                   	push   %ebx
  1000ca:	83 ec 1c             	sub    $0x1c,%esp
	// the application's state on the kernel's stack, then jumping to
	// kernel assembly code (in mpos-int.S, for your information).
	// That code saves more registers on the kernel's stack, then calls
	// interrupt().  The first thing we must do, then, is copy the saved
	// registers into the 'current' process descriptor.
	current->p_registers = *reg;
  1000cd:	8b 1d a4 9f 10 00    	mov    0x109fa4,%ebx

static pid_t do_fork(process_t *parent);

void
interrupt(registers_t *reg)
{
  1000d3:	8b 44 24 30          	mov    0x30(%esp),%eax
	// the application's state on the kernel's stack, then jumping to
	// kernel assembly code (in mpos-int.S, for your information).
	// That code saves more registers on the kernel's stack, then calls
	// interrupt().  The first thing we must do, then, is copy the saved
	// registers into the 'current' process descriptor.
	current->p_registers = *reg;
  1000d7:	8d 7b 04             	lea    0x4(%ebx),%edi
  1000da:	89 c6                	mov    %eax,%esi
  1000dc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

	switch (reg->reg_intno) {
  1000de:	8b 40 28             	mov    0x28(%eax),%eax
  1000e1:	83 e8 30             	sub    $0x30,%eax
  1000e4:	83 f8 04             	cmp    $0x4,%eax
  1000e7:	0f 87 3f 01 00 00    	ja     10022c <interrupt+0x16b>
  1000ed:	ff 24 85 08 0a 10 00 	jmp    *0x100a08(,%eax,4)
		// The 'sys_getpid' system call returns the current
		// process's process ID.  System calls return results to user
		// code by putting those results in a register.  Like Linux,
		// we use %eax for system call return values.  The code is
		// surprisingly simple:
		current->p_registers.reg_eax = current->p_pid;
  1000f4:	8b 03                	mov    (%ebx),%eax
		run(current);
  1000f6:	83 ec 0c             	sub    $0xc,%esp
		// The 'sys_getpid' system call returns the current
		// process's process ID.  System calls return results to user
		// code by putting those results in a register.  Like Linux,
		// we use %eax for system call return values.  The code is
		// surprisingly simple:
		current->p_registers.reg_eax = current->p_pid;
  1000f9:	89 43 20             	mov    %eax,0x20(%ebx)
		run(current);
  1000fc:	53                   	push   %ebx
  1000fd:	e9 93 00 00 00       	jmp    100195 <interrupt+0xd4>
  100102:	b8 98 92 10 00       	mov    $0x109298,%eax
  100107:	ba 01 00 00 00       	mov    $0x1,%edx
	// YOUR CODE HERE!
	// First, find an empty process descriptor.  If there is no empty
	//   process descriptor, return -1.  Remember not to use proc_array[0].
  int i;
	for (i = 1; i < NPROCS; i++) {
		if ( proc_array[i].p_state == P_EMPTY) {
  10010c:	83 38 00             	cmpl   $0x0,(%eax)
  10010f:	75 6c                	jne    10017d <interrupt+0xbc>
      // Then, initialize that process descriptor as a running process
      //   by copying the parent process's registers and stack into the
      //   child.  Copying the registers is simple: they are stored in the
      //   process descriptor in the 'p_registers' field.
      proc_array[i].p_registers = parent->p_registers;
  100111:	6b ea 54             	imul   $0x54,%edx,%ebp
  100114:	b9 11 00 00 00       	mov    $0x11,%ecx
  100119:	8d 73 04             	lea    0x4(%ebx),%esi
  10011c:	8d 85 fc 91 10 00    	lea    0x1091fc(%ebp),%eax
  100122:	89 c7                	mov    %eax,%edi
  100124:	83 c7 04             	add    $0x4,%edi
  100127:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	uint32_t src_stack_bottom, src_stack_top;
	uint32_t dest_stack_bottom, dest_stack_top;

	// YOUR CODE HERE!

  src_stack_top = (src->p_pid - 1) * PROC_STACK_SIZE + PROC1_STACK_ADDR;
  100129:	8b 0b                	mov    (%ebx),%ecx
		if ( proc_array[i].p_state == P_EMPTY) {
      // Then, initialize that process descriptor as a running process
      //   by copying the parent process's registers and stack into the
      //   child.  Copying the registers is simple: they are stored in the
      //   process descriptor in the 'p_registers' field.
      proc_array[i].p_registers = parent->p_registers;
  10012b:	89 44 24 0c          	mov    %eax,0xc(%esp)

	// YOUR CODE HERE!

  src_stack_top = (src->p_pid - 1) * PROC_STACK_SIZE + PROC1_STACK_ADDR;
	src_stack_bottom = src->p_registers.reg_esp;
  dest_stack_top = (dest->p_pid - 1) * PROC_STACK_SIZE + PROC1_STACK_ADDR;
  10012f:	8b 85 fc 91 10 00    	mov    0x1091fc(%ebp),%eax
  dest_stack_bottom = dest_stack_top - (src_stack_top - src_stack_bottom);
  100135:	8b 73 40             	mov    0x40(%ebx),%esi
	uint32_t src_stack_bottom, src_stack_top;
	uint32_t dest_stack_bottom, dest_stack_top;

	// YOUR CODE HERE!

  src_stack_top = (src->p_pid - 1) * PROC_STACK_SIZE + PROC1_STACK_ADDR;
  100138:	83 c1 09             	add    $0x9,%ecx
  10013b:	c1 e1 12             	shl    $0x12,%ecx
	src_stack_bottom = src->p_registers.reg_esp;
  dest_stack_top = (dest->p_pid - 1) * PROC_STACK_SIZE + PROC1_STACK_ADDR;
  10013e:	83 c0 09             	add    $0x9,%eax
  dest_stack_bottom = dest_stack_top - (src_stack_top - src_stack_bottom);

	// YOUR CODE HERE: memcpy the stack and set dest->p_registers.reg_esp
	/* memcpy( (void*)dest_stack_top, (void*)src_stack_top, (src_stack_top-src_stack_bottom)); */
	memcpy ( (void*)dest_stack_top, (void*)src_stack_top, PROC_STACK_SIZE );
  100141:	57                   	push   %edi
  100142:	68 00 00 04 00       	push   $0x40000
  100147:	51                   	push   %ecx

	// YOUR CODE HERE!

  src_stack_top = (src->p_pid - 1) * PROC_STACK_SIZE + PROC1_STACK_ADDR;
	src_stack_bottom = src->p_registers.reg_esp;
  dest_stack_top = (dest->p_pid - 1) * PROC_STACK_SIZE + PROC1_STACK_ADDR;
  100148:	c1 e0 12             	shl    $0x12,%eax
  dest_stack_bottom = dest_stack_top - (src_stack_top - src_stack_bottom);

	// YOUR CODE HERE: memcpy the stack and set dest->p_registers.reg_esp
	/* memcpy( (void*)dest_stack_top, (void*)src_stack_top, (src_stack_top-src_stack_bottom)); */
	memcpy ( (void*)dest_stack_top, (void*)src_stack_top, PROC_STACK_SIZE );
  10014b:	50                   	push   %eax
	// YOUR CODE HERE!

  src_stack_top = (src->p_pid - 1) * PROC_STACK_SIZE + PROC1_STACK_ADDR;
	src_stack_bottom = src->p_registers.reg_esp;
  dest_stack_top = (dest->p_pid - 1) * PROC_STACK_SIZE + PROC1_STACK_ADDR;
  dest_stack_bottom = dest_stack_top - (src_stack_top - src_stack_bottom);
  10014c:	01 c6                	add    %eax,%esi
  10014e:	29 ce                	sub    %ecx,%esi

	// YOUR CODE HERE: memcpy the stack and set dest->p_registers.reg_esp
	/* memcpy( (void*)dest_stack_top, (void*)src_stack_top, (src_stack_top-src_stack_bottom)); */
	memcpy ( (void*)dest_stack_top, (void*)src_stack_top, PROC_STACK_SIZE );
  100150:	89 54 24 18          	mov    %edx,0x18(%esp)
  100154:	e8 cf 03 00 00       	call   100528 <memcpy>
  dest->p_registers.reg_esp = dest_stack_bottom;
  100159:	8b 44 24 1c          	mov    0x1c(%esp),%eax
      //   * ???????    There is one other difference.  What is it?  (Hint:
      //                What should sys_fork() return to the child process?)
      proc_array[i].p_registers.reg_eax = 0;

      // You need to set one other process descriptor field as well.
      proc_array[i].p_state = P_RUNNABLE;
  10015d:	83 c4 10             	add    $0x10,%esp
      //                should arrange this.
      copy_stack(&proc_array[i], parent);

      //   * ???????    There is one other difference.  What is it?  (Hint:
      //                What should sys_fork() return to the child process?)
      proc_array[i].p_registers.reg_eax = 0;
  100160:	c7 85 1c 92 10 00 00 	movl   $0x0,0x10921c(%ebp)
  100167:	00 00 00 
  10016a:	8b 54 24 08          	mov    0x8(%esp),%edx

      // You need to set one other process descriptor field as well.
      proc_array[i].p_state = P_RUNNABLE;
  10016e:	c7 85 44 92 10 00 01 	movl   $0x1,0x109244(%ebp)
  100175:	00 00 00 
  dest_stack_bottom = dest_stack_top - (src_stack_top - src_stack_bottom);

	// YOUR CODE HERE: memcpy the stack and set dest->p_registers.reg_esp
	/* memcpy( (void*)dest_stack_top, (void*)src_stack_top, (src_stack_top-src_stack_bottom)); */
	memcpy ( (void*)dest_stack_top, (void*)src_stack_top, PROC_STACK_SIZE );
  dest->p_registers.reg_esp = dest_stack_bottom;
  100178:	89 70 40             	mov    %esi,0x40(%eax)
  10017b:	eb 0c                	jmp    100189 <interrupt+0xc8>
{
	// YOUR CODE HERE!
	// First, find an empty process descriptor.  If there is no empty
	//   process descriptor, return -1.  Remember not to use proc_array[0].
  int i;
	for (i = 1; i < NPROCS; i++) {
  10017d:	42                   	inc    %edx
  10017e:	83 c0 54             	add    $0x54,%eax
  100181:	83 fa 10             	cmp    $0x10,%edx
  100184:	75 86                	jne    10010c <interrupt+0x4b>
  100186:	83 ca ff             	or     $0xffffffff,%edx
		run(current);

	case INT_SYS_FORK:
		// The 'sys_fork' system call should create a new process.
		// You will have to complete the do_fork() function!
		current->p_registers.reg_eax = do_fork(current);
  100189:	89 53 20             	mov    %edx,0x20(%ebx)
		run(current);
  10018c:	83 ec 0c             	sub    $0xc,%esp
  10018f:	ff 35 a4 9f 10 00    	pushl  0x109fa4
  100195:	e8 b6 02 00 00       	call   100450 <run>
	case INT_SYS_YIELD:
		// The 'sys_yield' system call asks the kernel to schedule a
		// different process.  (MiniprocOS is cooperatively
		// scheduled, so we need a special system call to do this.)
		// The schedule() function picks another process and runs it.
		schedule();
  10019a:	e8 ed fe ff ff       	call   10008c <schedule>
		// non-runnable.
		// The process stored its exit status in the %eax register
		// before calling the system call.  The %eax REGISTER has
		// changed by now, but we can read the APPLICATION's setting
		// for this register out of 'current->p_registers'.
		current->p_state = P_ZOMBIE;
  10019f:	8b 15 a4 9f 10 00    	mov    0x109fa4,%edx
		current->p_exit_status = current->p_registers.reg_eax;
  1001a5:	8b 42 20             	mov    0x20(%edx),%eax

    int i;
    for (i = 0; i < NPROCS; i++) {
      if (proc_array[i].p_waiting == current->p_pid) {
  1001a8:	8b 0a                	mov    (%edx),%ecx
		// non-runnable.
		// The process stored its exit status in the %eax register
		// before calling the system call.  The %eax REGISTER has
		// changed by now, but we can read the APPLICATION's setting
		// for this register out of 'current->p_registers'.
		current->p_state = P_ZOMBIE;
  1001aa:	c7 42 48 03 00 00 00 	movl   $0x3,0x48(%edx)
		current->p_exit_status = current->p_registers.reg_eax;
  1001b1:	89 42 4c             	mov    %eax,0x4c(%edx)

    int i;
    for (i = 0; i < NPROCS; i++) {
      if (proc_array[i].p_waiting == current->p_pid) {
  1001b4:	31 c0                	xor    %eax,%eax
  1001b6:	39 88 4c 92 10 00    	cmp    %ecx,0x10924c(%eax)
  1001bc:	75 13                	jne    1001d1 <interrupt+0x110>
        proc_array[i].p_waiting = 0;
        proc_array[i].p_registers.reg_eax = current->p_registers.reg_eax;
  1001be:	8b 5a 20             	mov    0x20(%edx),%ebx
		current->p_exit_status = current->p_registers.reg_eax;

    int i;
    for (i = 0; i < NPROCS; i++) {
      if (proc_array[i].p_waiting == current->p_pid) {
        proc_array[i].p_waiting = 0;
  1001c1:	c7 80 4c 92 10 00 00 	movl   $0x0,0x10924c(%eax)
  1001c8:	00 00 00 
        proc_array[i].p_registers.reg_eax = current->p_registers.reg_eax;
  1001cb:	89 98 1c 92 10 00    	mov    %ebx,0x10921c(%eax)
  1001d1:	83 c0 54             	add    $0x54,%eax
		// for this register out of 'current->p_registers'.
		current->p_state = P_ZOMBIE;
		current->p_exit_status = current->p_registers.reg_eax;

    int i;
    for (i = 0; i < NPROCS; i++) {
  1001d4:	3d 40 05 00 00       	cmp    $0x540,%eax
  1001d9:	75 db                	jne    1001b6 <interrupt+0xf5>
        proc_array[i].p_waiting = 0;
        proc_array[i].p_registers.reg_eax = current->p_registers.reg_eax;
      }
    }

		schedule();
  1001db:	e8 ac fe ff ff       	call   10008c <schedule>
		// * A process that doesn't exist (p_state == P_EMPTY).
		// (In the Unix operating system, only process P's parent
		// can call sys_wait(P).  In MiniprocOS, we allow ANY
		// process to call sys_wait(P).)

		pid_t p = current->p_registers.reg_eax;
  1001e0:	a1 a4 9f 10 00       	mov    0x109fa4,%eax
  1001e5:	8b 50 20             	mov    0x20(%eax),%edx
		if (p <= 0 || p >= NPROCS || p == current->p_pid
  1001e8:	8d 4a ff             	lea    -0x1(%edx),%ecx
  1001eb:	83 f9 0e             	cmp    $0xe,%ecx
  1001ee:	77 14                	ja     100204 <interrupt+0x143>
  1001f0:	3b 10                	cmp    (%eax),%edx
  1001f2:	74 10                	je     100204 <interrupt+0x143>
		    || proc_array[p].p_state == P_EMPTY)
  1001f4:	6b da 54             	imul   $0x54,%edx,%ebx
  1001f7:	8d 8b 04 92 10 00    	lea    0x109204(%ebx),%ecx
  1001fd:	8b 71 40             	mov    0x40(%ecx),%esi
		// (In the Unix operating system, only process P's parent
		// can call sys_wait(P).  In MiniprocOS, we allow ANY
		// process to call sys_wait(P).)

		pid_t p = current->p_registers.reg_eax;
		if (p <= 0 || p >= NPROCS || p == current->p_pid
  100200:	85 f6                	test   %esi,%esi
  100202:	75 09                	jne    10020d <interrupt+0x14c>
		    || proc_array[p].p_state == P_EMPTY)
			current->p_registers.reg_eax = -1;
  100204:	c7 40 20 ff ff ff ff 	movl   $0xffffffff,0x20(%eax)
		// (In the Unix operating system, only process P's parent
		// can call sys_wait(P).  In MiniprocOS, we allow ANY
		// process to call sys_wait(P).)

		pid_t p = current->p_registers.reg_eax;
		if (p <= 0 || p >= NPROCS || p == current->p_pid
  10020b:	eb 1a                	jmp    100227 <interrupt+0x166>
		    || proc_array[p].p_state == P_EMPTY)
			current->p_registers.reg_eax = -1;
    else if (proc_array[p].p_state == P_ZOMBIE) {
  10020d:	83 fe 03             	cmp    $0x3,%esi
  100210:	75 12                	jne    100224 <interrupt+0x163>
      current->p_registers.reg_eax = proc_array[p].p_exit_status;
  100212:	8b 93 48 92 10 00    	mov    0x109248(%ebx),%edx
      proc_array[p].p_state = P_EMPTY;
  100218:	c7 41 40 00 00 00 00 	movl   $0x0,0x40(%ecx)
		pid_t p = current->p_registers.reg_eax;
		if (p <= 0 || p >= NPROCS || p == current->p_pid
		    || proc_array[p].p_state == P_EMPTY)
			current->p_registers.reg_eax = -1;
    else if (proc_array[p].p_state == P_ZOMBIE) {
      current->p_registers.reg_eax = proc_array[p].p_exit_status;
  10021f:	89 50 20             	mov    %edx,0x20(%eax)
  100222:	eb 03                	jmp    100227 <interrupt+0x166>
      proc_array[p].p_state = P_EMPTY;
    }
		else
      current->p_waiting = p;
  100224:	89 50 50             	mov    %edx,0x50(%eax)
		schedule();
  100227:	e8 60 fe ff ff       	call   10008c <schedule>
  10022c:	eb fe                	jmp    10022c <interrupt+0x16b>

0010022e <start>:
 *
 *****************************************************************************/

void
start(void)
{
  10022e:	53                   	push   %ebx
  10022f:	83 ec 0c             	sub    $0xc,%esp
	const char *s;
	int whichprocess;
	pid_t i;

	// Initialize process descriptors as empty
	memset(proc_array, 0, sizeof(proc_array));
  100232:	68 40 05 00 00       	push   $0x540
  100237:	6a 00                	push   $0x0
  100239:	68 fc 91 10 00       	push   $0x1091fc
  10023e:	e8 49 03 00 00       	call   10058c <memset>
  100243:	b8 fc 91 10 00       	mov    $0x1091fc,%eax
  100248:	31 d2                	xor    %edx,%edx
  10024a:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < NPROCS; i++) {
		proc_array[i].p_pid = i;
  10024d:	89 10                	mov    %edx,(%eax)
	int whichprocess;
	pid_t i;

	// Initialize process descriptors as empty
	memset(proc_array, 0, sizeof(proc_array));
	for (i = 0; i < NPROCS; i++) {
  10024f:	42                   	inc    %edx
		proc_array[i].p_pid = i;
		proc_array[i].p_state = P_EMPTY;
  100250:	c7 40 48 00 00 00 00 	movl   $0x0,0x48(%eax)
		proc_array[i].p_waiting = 0;
  100257:	c7 40 50 00 00 00 00 	movl   $0x0,0x50(%eax)
	int whichprocess;
	pid_t i;

	// Initialize process descriptors as empty
	memset(proc_array, 0, sizeof(proc_array));
	for (i = 0; i < NPROCS; i++) {
  10025e:	83 c0 54             	add    $0x54,%eax
  100261:	83 fa 10             	cmp    $0x10,%edx
  100264:	75 e7                	jne    10024d <start+0x1f>
		proc_array[i].p_state = P_EMPTY;
		proc_array[i].p_waiting = 0;
	}

	// The first process has process ID 1.
	current = &proc_array[1];
  100266:	c7 05 a4 9f 10 00 50 	movl   $0x109250,0x109fa4
  10026d:	92 10 00 

	// Set up x86 hardware, and initialize the first process's
	// special registers.  This only needs to be done once, at boot time.
	// All other processes' special registers can be copied from the
	// first process.
	segments_init();
  100270:	e8 73 00 00 00       	call   1002e8 <segments_init>
	special_registers_init(current);
  100275:	83 ec 0c             	sub    $0xc,%esp
  100278:	ff 35 a4 9f 10 00    	pushl  0x109fa4
  10027e:	e8 e4 01 00 00       	call   100467 <special_registers_init>

	// Erase the console, and initialize the cursor-position shared
	// variable to point to its upper left.
	console_clear();
  100283:	e8 2f 01 00 00       	call   1003b7 <console_clear>

	// Figure out which program to run.
	cursorpos = console_printf(cursorpos, 0x0700, "Type '1' to run mpos-app, or '2' to run mpos-app2.");
  100288:	83 c4 0c             	add    $0xc,%esp
  10028b:	68 1c 0a 10 00       	push   $0x100a1c
  100290:	68 00 07 00 00       	push   $0x700
  100295:	ff 35 00 00 06 00    	pushl  0x60000
  10029b:	e8 4e 07 00 00       	call   1009ee <console_printf>
  1002a0:	83 c4 10             	add    $0x10,%esp
  1002a3:	a3 00 00 06 00       	mov    %eax,0x60000
	do {
		whichprocess = console_read_digit();
  1002a8:	e8 4d 01 00 00       	call   1003fa <console_read_digit>
	} while (whichprocess != 1 && whichprocess != 2);
  1002ad:	8d 58 ff             	lea    -0x1(%eax),%ebx
  1002b0:	83 fb 01             	cmp    $0x1,%ebx
  1002b3:	77 f3                	ja     1002a8 <start+0x7a>
	console_clear();
  1002b5:	e8 fd 00 00 00       	call   1003b7 <console_clear>

	// Load the process application code and data into memory.
	// Store its entry point into the first process's EIP
	// (instruction pointer).
	program_loader(whichprocess - 1, &current->p_registers.reg_eip);
  1002ba:	50                   	push   %eax
  1002bb:	50                   	push   %eax
  1002bc:	a1 a4 9f 10 00       	mov    0x109fa4,%eax
  1002c1:	83 c0 34             	add    $0x34,%eax
  1002c4:	50                   	push   %eax
  1002c5:	53                   	push   %ebx
  1002c6:	e8 d1 01 00 00       	call   10049c <program_loader>

	// Set the main process's stack pointer, ESP.
	current->p_registers.reg_esp = PROC1_STACK_ADDR + PROC_STACK_SIZE;
  1002cb:	a1 a4 9f 10 00       	mov    0x109fa4,%eax
  1002d0:	c7 40 40 00 00 2c 00 	movl   $0x2c0000,0x40(%eax)

	// Mark the process as runnable!
	current->p_state = P_RUNNABLE;
  1002d7:	c7 40 48 01 00 00 00 	movl   $0x1,0x48(%eax)

	// Switch to the main process using run().
	run(current);
  1002de:	89 04 24             	mov    %eax,(%esp)
  1002e1:	e8 6a 01 00 00       	call   100450 <run>
  1002e6:	90                   	nop
  1002e7:	90                   	nop

001002e8 <segments_init>:
segments_init(void)
{
	int i;

	// Set task state segment
	segments[SEGSEL_TASKSTATE >> 3]
  1002e8:	b8 3c 97 10 00       	mov    $0x10973c,%eax
	kernel_task_descriptor.ts_ss0 = SEGSEL_KERN_DATA;

	// Set up interrupt descriptor table.
	// Most interrupts are effectively ignored
	for (i = 0; i < sizeof(interrupt_descriptors) / sizeof(gatedescriptor_t); i++)
		SETGATE(interrupt_descriptors[i], 0,
  1002ed:	b9 56 00 10 00       	mov    $0x100056,%ecx
segments_init(void)
{
	int i;

	// Set task state segment
	segments[SEGSEL_TASKSTATE >> 3]
  1002f2:	89 c2                	mov    %eax,%edx
  1002f4:	c1 ea 10             	shr    $0x10,%edx
extern void default_int_handler(void);


void
segments_init(void)
{
  1002f7:	53                   	push   %ebx
	kernel_task_descriptor.ts_ss0 = SEGSEL_KERN_DATA;

	// Set up interrupt descriptor table.
	// Most interrupts are effectively ignored
	for (i = 0; i < sizeof(interrupt_descriptors) / sizeof(gatedescriptor_t); i++)
		SETGATE(interrupt_descriptors[i], 0,
  1002f8:	bb 56 00 10 00       	mov    $0x100056,%ebx
  1002fd:	c1 eb 10             	shr    $0x10,%ebx
segments_init(void)
{
	int i;

	// Set task state segment
	segments[SEGSEL_TASKSTATE >> 3]
  100300:	66 a3 ba 1a 10 00    	mov    %ax,0x101aba
  100306:	c1 e8 18             	shr    $0x18,%eax
  100309:	88 15 bc 1a 10 00    	mov    %dl,0x101abc
	kernel_task_descriptor.ts_ss0 = SEGSEL_KERN_DATA;

	// Set up interrupt descriptor table.
	// Most interrupts are effectively ignored
	for (i = 0; i < sizeof(interrupt_descriptors) / sizeof(gatedescriptor_t); i++)
		SETGATE(interrupt_descriptors[i], 0,
  10030f:	ba a4 97 10 00       	mov    $0x1097a4,%edx
segments_init(void)
{
	int i;

	// Set task state segment
	segments[SEGSEL_TASKSTATE >> 3]
  100314:	a2 bf 1a 10 00       	mov    %al,0x101abf
	kernel_task_descriptor.ts_ss0 = SEGSEL_KERN_DATA;

	// Set up interrupt descriptor table.
	// Most interrupts are effectively ignored
	for (i = 0; i < sizeof(interrupt_descriptors) / sizeof(gatedescriptor_t); i++)
		SETGATE(interrupt_descriptors[i], 0,
  100319:	31 c0                	xor    %eax,%eax
segments_init(void)
{
	int i;

	// Set task state segment
	segments[SEGSEL_TASKSTATE >> 3]
  10031b:	66 c7 05 b8 1a 10 00 	movw   $0x68,0x101ab8
  100322:	68 00 
  100324:	c6 05 be 1a 10 00 40 	movb   $0x40,0x101abe
		= SEG16(STS_T32A, (uint32_t) &kernel_task_descriptor,
			sizeof(taskstate_t), 0);
	segments[SEGSEL_TASKSTATE >> 3].sd_s = 0;
  10032b:	c6 05 bd 1a 10 00 89 	movb   $0x89,0x101abd

	// Set up kernel task descriptor, so we can receive interrupts
	kernel_task_descriptor.ts_esp0 = KERNEL_STACK_TOP;
  100332:	c7 05 40 97 10 00 00 	movl   $0x80000,0x109740
  100339:	00 08 00 
	kernel_task_descriptor.ts_ss0 = SEGSEL_KERN_DATA;
  10033c:	66 c7 05 44 97 10 00 	movw   $0x10,0x109744
  100343:	10 00 

	// Set up interrupt descriptor table.
	// Most interrupts are effectively ignored
	for (i = 0; i < sizeof(interrupt_descriptors) / sizeof(gatedescriptor_t); i++)
		SETGATE(interrupt_descriptors[i], 0,
  100345:	66 89 0c c5 a4 97 10 	mov    %cx,0x1097a4(,%eax,8)
  10034c:	00 
  10034d:	66 c7 44 c2 02 08 00 	movw   $0x8,0x2(%edx,%eax,8)
  100354:	c6 44 c2 04 00       	movb   $0x0,0x4(%edx,%eax,8)
  100359:	c6 44 c2 05 8e       	movb   $0x8e,0x5(%edx,%eax,8)
  10035e:	66 89 5c c2 06       	mov    %bx,0x6(%edx,%eax,8)
	kernel_task_descriptor.ts_esp0 = KERNEL_STACK_TOP;
	kernel_task_descriptor.ts_ss0 = SEGSEL_KERN_DATA;

	// Set up interrupt descriptor table.
	// Most interrupts are effectively ignored
	for (i = 0; i < sizeof(interrupt_descriptors) / sizeof(gatedescriptor_t); i++)
  100363:	40                   	inc    %eax
  100364:	3d 00 01 00 00       	cmp    $0x100,%eax
  100369:	75 da                	jne    100345 <segments_init+0x5d>
  10036b:	66 b8 30 00          	mov    $0x30,%ax

	// System calls get special handling.
	// Note that the last argument is '3'.  This means that unprivileged
	// (level-3) applications may generate these interrupts.
	for (i = INT_SYS_GETPID; i < INT_SYS_GETPID + 10; i++)
		SETGATE(interrupt_descriptors[i], 0,
  10036f:	ba a4 97 10 00       	mov    $0x1097a4,%edx
  100374:	8b 0c 85 a3 ff 0f 00 	mov    0xfffa3(,%eax,4),%ecx
  10037b:	66 c7 44 c2 02 08 00 	movw   $0x8,0x2(%edx,%eax,8)
  100382:	66 89 0c c5 a4 97 10 	mov    %cx,0x1097a4(,%eax,8)
  100389:	00 
  10038a:	c1 e9 10             	shr    $0x10,%ecx
  10038d:	c6 44 c2 04 00       	movb   $0x0,0x4(%edx,%eax,8)
  100392:	c6 44 c2 05 ee       	movb   $0xee,0x5(%edx,%eax,8)
  100397:	66 89 4c c2 06       	mov    %cx,0x6(%edx,%eax,8)
			SEGSEL_KERN_CODE, default_int_handler, 0);

	// System calls get special handling.
	// Note that the last argument is '3'.  This means that unprivileged
	// (level-3) applications may generate these interrupts.
	for (i = INT_SYS_GETPID; i < INT_SYS_GETPID + 10; i++)
  10039c:	40                   	inc    %eax
  10039d:	83 f8 3a             	cmp    $0x3a,%eax
  1003a0:	75 d2                	jne    100374 <segments_init+0x8c>
		SETGATE(interrupt_descriptors[i], 0,
			SEGSEL_KERN_CODE, sys_int_handlers[i - INT_SYS_GETPID], 3);

	// Reload segment pointers
	asm volatile("lgdt global_descriptor_table\n\t"
  1003a2:	b0 28                	mov    $0x28,%al
  1003a4:	0f 01 15 80 1a 10 00 	lgdtl  0x101a80
  1003ab:	0f 00 d8             	ltr    %ax
  1003ae:	0f 01 1d 88 1a 10 00 	lidtl  0x101a88
		     "lidt interrupt_descriptor_table"
		     : : "r" ((uint16_t) SEGSEL_TASKSTATE));

	// Convince compiler that all symbols were used
	(void) global_descriptor_table, (void) interrupt_descriptor_table;
}
  1003b5:	5b                   	pop    %ebx
  1003b6:	c3                   	ret    

001003b7 <console_clear>:
 *
 *****************************************************************************/

void
console_clear(void)
{
  1003b7:	56                   	push   %esi
	int i;
	cursorpos = (uint16_t *) 0xB8000;
  1003b8:	31 c0                	xor    %eax,%eax
 *
 *****************************************************************************/

void
console_clear(void)
{
  1003ba:	53                   	push   %ebx
	int i;
	cursorpos = (uint16_t *) 0xB8000;
  1003bb:	c7 05 00 00 06 00 00 	movl   $0xb8000,0x60000
  1003c2:	80 0b 00 

	for (i = 0; i < 80 * 25; i++)
		cursorpos[i] = ' ' | 0x0700;
  1003c5:	66 c7 84 00 00 80 0b 	movw   $0x720,0xb8000(%eax,%eax,1)
  1003cc:	00 20 07 
console_clear(void)
{
	int i;
	cursorpos = (uint16_t *) 0xB8000;

	for (i = 0; i < 80 * 25; i++)
  1003cf:	40                   	inc    %eax
  1003d0:	3d d0 07 00 00       	cmp    $0x7d0,%eax
  1003d5:	75 ee                	jne    1003c5 <console_clear+0xe>
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  1003d7:	be d4 03 00 00       	mov    $0x3d4,%esi
  1003dc:	b0 0e                	mov    $0xe,%al
  1003de:	89 f2                	mov    %esi,%edx
  1003e0:	ee                   	out    %al,(%dx)
  1003e1:	31 c9                	xor    %ecx,%ecx
  1003e3:	bb d5 03 00 00       	mov    $0x3d5,%ebx
  1003e8:	88 c8                	mov    %cl,%al
  1003ea:	89 da                	mov    %ebx,%edx
  1003ec:	ee                   	out    %al,(%dx)
  1003ed:	b0 0f                	mov    $0xf,%al
  1003ef:	89 f2                	mov    %esi,%edx
  1003f1:	ee                   	out    %al,(%dx)
  1003f2:	88 c8                	mov    %cl,%al
  1003f4:	89 da                	mov    %ebx,%edx
  1003f6:	ee                   	out    %al,(%dx)
		cursorpos[i] = ' ' | 0x0700;
	outb(0x3D4, 14);
	outb(0x3D5, 0 / 256);
	outb(0x3D4, 15);
	outb(0x3D5, 0 % 256);
}
  1003f7:	5b                   	pop    %ebx
  1003f8:	5e                   	pop    %esi
  1003f9:	c3                   	ret    

001003fa <console_read_digit>:

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  1003fa:	ba 64 00 00 00       	mov    $0x64,%edx
  1003ff:	ec                   	in     (%dx),%al
int
console_read_digit(void)
{
	uint8_t data;

	if ((inb(KBSTATP) & KBS_DIB) == 0)
  100400:	a8 01                	test   $0x1,%al
  100402:	74 45                	je     100449 <console_read_digit+0x4f>
  100404:	b2 60                	mov    $0x60,%dl
  100406:	ec                   	in     (%dx),%al
		return -1;

	data = inb(KBDATAP);
	if (data >= 0x02 && data <= 0x0A)
  100407:	8d 50 fe             	lea    -0x2(%eax),%edx
  10040a:	80 fa 08             	cmp    $0x8,%dl
  10040d:	77 05                	ja     100414 <console_read_digit+0x1a>
		return data - 0x02 + 1;
  10040f:	0f b6 c0             	movzbl %al,%eax
  100412:	48                   	dec    %eax
  100413:	c3                   	ret    
	else if (data == 0x0B)
  100414:	3c 0b                	cmp    $0xb,%al
  100416:	74 35                	je     10044d <console_read_digit+0x53>
		return 0;
	else if (data >= 0x47 && data <= 0x49)
  100418:	8d 50 b9             	lea    -0x47(%eax),%edx
  10041b:	80 fa 02             	cmp    $0x2,%dl
  10041e:	77 07                	ja     100427 <console_read_digit+0x2d>
		return data - 0x47 + 7;
  100420:	0f b6 c0             	movzbl %al,%eax
  100423:	83 e8 40             	sub    $0x40,%eax
  100426:	c3                   	ret    
	else if (data >= 0x4B && data <= 0x4D)
  100427:	8d 50 b5             	lea    -0x4b(%eax),%edx
  10042a:	80 fa 02             	cmp    $0x2,%dl
  10042d:	77 07                	ja     100436 <console_read_digit+0x3c>
		return data - 0x4B + 4;
  10042f:	0f b6 c0             	movzbl %al,%eax
  100432:	83 e8 47             	sub    $0x47,%eax
  100435:	c3                   	ret    
	else if (data >= 0x4F && data <= 0x51)
  100436:	8d 50 b1             	lea    -0x4f(%eax),%edx
  100439:	80 fa 02             	cmp    $0x2,%dl
  10043c:	77 07                	ja     100445 <console_read_digit+0x4b>
		return data - 0x4F + 1;
  10043e:	0f b6 c0             	movzbl %al,%eax
  100441:	83 e8 4e             	sub    $0x4e,%eax
  100444:	c3                   	ret    
	else if (data == 0x53)
  100445:	3c 53                	cmp    $0x53,%al
  100447:	74 04                	je     10044d <console_read_digit+0x53>
  100449:	83 c8 ff             	or     $0xffffffff,%eax
  10044c:	c3                   	ret    
  10044d:	31 c0                	xor    %eax,%eax
		return 0;
	else
		return -1;
}
  10044f:	c3                   	ret    

00100450 <run>:
 *
 *****************************************************************************/

void
run(process_t *proc)
{
  100450:	8b 44 24 04          	mov    0x4(%esp),%eax
	current = proc;
  100454:	a3 a4 9f 10 00       	mov    %eax,0x109fa4

	asm volatile("movl %0,%%esp\n\t"
  100459:	83 c0 04             	add    $0x4,%eax
  10045c:	89 c4                	mov    %eax,%esp
  10045e:	61                   	popa   
  10045f:	07                   	pop    %es
  100460:	1f                   	pop    %ds
  100461:	83 c4 08             	add    $0x8,%esp
  100464:	cf                   	iret   
  100465:	eb fe                	jmp    100465 <run+0x15>

00100467 <special_registers_init>:
 *
 *****************************************************************************/

void
special_registers_init(process_t *proc)
{
  100467:	53                   	push   %ebx
  100468:	83 ec 0c             	sub    $0xc,%esp
  10046b:	8b 5c 24 14          	mov    0x14(%esp),%ebx
	memset(&proc->p_registers, 0, sizeof(registers_t));
  10046f:	6a 44                	push   $0x44
  100471:	6a 00                	push   $0x0
  100473:	8d 43 04             	lea    0x4(%ebx),%eax
  100476:	50                   	push   %eax
  100477:	e8 10 01 00 00       	call   10058c <memset>
	proc->p_registers.reg_cs = SEGSEL_APP_CODE | 3;
  10047c:	66 c7 43 38 1b 00    	movw   $0x1b,0x38(%ebx)
	proc->p_registers.reg_ds = SEGSEL_APP_DATA | 3;
  100482:	66 c7 43 28 23 00    	movw   $0x23,0x28(%ebx)
	proc->p_registers.reg_es = SEGSEL_APP_DATA | 3;
  100488:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	proc->p_registers.reg_ss = SEGSEL_APP_DATA | 3;
  10048e:	66 c7 43 44 23 00    	movw   $0x23,0x44(%ebx)
}
  100494:	83 c4 18             	add    $0x18,%esp
  100497:	5b                   	pop    %ebx
  100498:	c3                   	ret    
  100499:	90                   	nop
  10049a:	90                   	nop
  10049b:	90                   	nop

0010049c <program_loader>:
		    uint32_t filesz, uint32_t memsz);
static void loader_panic(void);

void
program_loader(int program_id, uint32_t *entry_point)
{
  10049c:	55                   	push   %ebp
  10049d:	57                   	push   %edi
  10049e:	56                   	push   %esi
  10049f:	53                   	push   %ebx
  1004a0:	83 ec 1c             	sub    $0x1c,%esp
  1004a3:	8b 44 24 30          	mov    0x30(%esp),%eax
	struct Proghdr *ph, *eph;
	struct Elf *elf_header;
	int nprograms = sizeof(ramimages) / sizeof(ramimages[0]);

	if (program_id < 0 || program_id >= nprograms)
  1004a7:	83 f8 01             	cmp    $0x1,%eax
  1004aa:	7f 04                	jg     1004b0 <program_loader+0x14>
  1004ac:	85 c0                	test   %eax,%eax
  1004ae:	79 02                	jns    1004b2 <program_loader+0x16>
  1004b0:	eb fe                	jmp    1004b0 <program_loader+0x14>
		loader_panic();

	// is this a valid ELF?
	elf_header = (struct Elf *) ramimages[program_id].begin;
  1004b2:	8b 34 c5 c0 1a 10 00 	mov    0x101ac0(,%eax,8),%esi
	if (elf_header->e_magic != ELF_MAGIC)
  1004b9:	81 3e 7f 45 4c 46    	cmpl   $0x464c457f,(%esi)
  1004bf:	74 02                	je     1004c3 <program_loader+0x27>
  1004c1:	eb fe                	jmp    1004c1 <program_loader+0x25>
		loader_panic();

	// load each program segment (ignores ph flags)
	ph = (struct Proghdr*) ((const uint8_t *) elf_header + elf_header->e_phoff);
  1004c3:	8b 5e 1c             	mov    0x1c(%esi),%ebx
	eph = ph + elf_header->e_phnum;
  1004c6:	0f b7 6e 2c          	movzwl 0x2c(%esi),%ebp
	elf_header = (struct Elf *) ramimages[program_id].begin;
	if (elf_header->e_magic != ELF_MAGIC)
		loader_panic();

	// load each program segment (ignores ph flags)
	ph = (struct Proghdr*) ((const uint8_t *) elf_header + elf_header->e_phoff);
  1004ca:	01 f3                	add    %esi,%ebx
	eph = ph + elf_header->e_phnum;
  1004cc:	c1 e5 05             	shl    $0x5,%ebp
  1004cf:	8d 2c 2b             	lea    (%ebx,%ebp,1),%ebp
	for (; ph < eph; ph++)
  1004d2:	eb 3f                	jmp    100513 <program_loader+0x77>
		if (ph->p_type == ELF_PROG_LOAD)
  1004d4:	83 3b 01             	cmpl   $0x1,(%ebx)
  1004d7:	75 37                	jne    100510 <program_loader+0x74>
			copyseg((void *) ph->p_va,
  1004d9:	8b 43 08             	mov    0x8(%ebx),%eax
// then clear the memory from 'va+filesz' up to 'va+memsz' (set it to 0).
static void
copyseg(void *dst, const uint8_t *src, uint32_t filesz, uint32_t memsz)
{
	uint32_t va = (uint32_t) dst;
	uint32_t end_va = va + filesz;
  1004dc:	8b 7b 10             	mov    0x10(%ebx),%edi
	memsz += va;
  1004df:	8b 53 14             	mov    0x14(%ebx),%edx
// then clear the memory from 'va+filesz' up to 'va+memsz' (set it to 0).
static void
copyseg(void *dst, const uint8_t *src, uint32_t filesz, uint32_t memsz)
{
	uint32_t va = (uint32_t) dst;
	uint32_t end_va = va + filesz;
  1004e2:	01 c7                	add    %eax,%edi
	memsz += va;
  1004e4:	01 c2                	add    %eax,%edx
	va &= ~(PAGESIZE - 1);		// round to page boundary
  1004e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
static void
copyseg(void *dst, const uint8_t *src, uint32_t filesz, uint32_t memsz)
{
	uint32_t va = (uint32_t) dst;
	uint32_t end_va = va + filesz;
	memsz += va;
  1004eb:	89 54 24 0c          	mov    %edx,0xc(%esp)
	va &= ~(PAGESIZE - 1);		// round to page boundary

	// copy data
	memcpy((uint8_t *) va, src, end_va - va);
  1004ef:	52                   	push   %edx
  1004f0:	89 fa                	mov    %edi,%edx
  1004f2:	29 c2                	sub    %eax,%edx
  1004f4:	52                   	push   %edx
  1004f5:	8b 53 04             	mov    0x4(%ebx),%edx
  1004f8:	01 f2                	add    %esi,%edx
  1004fa:	52                   	push   %edx
  1004fb:	50                   	push   %eax
  1004fc:	e8 27 00 00 00       	call   100528 <memcpy>
  100501:	83 c4 10             	add    $0x10,%esp
  100504:	eb 04                	jmp    10050a <program_loader+0x6e>

	// clear bss segment
	while (end_va < memsz)
		*((uint8_t *) end_va++) = 0;
  100506:	c6 07 00             	movb   $0x0,(%edi)
  100509:	47                   	inc    %edi

	// copy data
	memcpy((uint8_t *) va, src, end_va - va);

	// clear bss segment
	while (end_va < memsz)
  10050a:	3b 7c 24 0c          	cmp    0xc(%esp),%edi
  10050e:	72 f6                	jb     100506 <program_loader+0x6a>
		loader_panic();

	// load each program segment (ignores ph flags)
	ph = (struct Proghdr*) ((const uint8_t *) elf_header + elf_header->e_phoff);
	eph = ph + elf_header->e_phnum;
	for (; ph < eph; ph++)
  100510:	83 c3 20             	add    $0x20,%ebx
  100513:	39 eb                	cmp    %ebp,%ebx
  100515:	72 bd                	jb     1004d4 <program_loader+0x38>
			copyseg((void *) ph->p_va,
				(const uint8_t *) elf_header + ph->p_offset,
				ph->p_filesz, ph->p_memsz);

	// store the entry point from the ELF header
	*entry_point = elf_header->e_entry;
  100517:	8b 56 18             	mov    0x18(%esi),%edx
  10051a:	8b 44 24 34          	mov    0x34(%esp),%eax
  10051e:	89 10                	mov    %edx,(%eax)
}
  100520:	83 c4 1c             	add    $0x1c,%esp
  100523:	5b                   	pop    %ebx
  100524:	5e                   	pop    %esi
  100525:	5f                   	pop    %edi
  100526:	5d                   	pop    %ebp
  100527:	c3                   	ret    

00100528 <memcpy>:
 *
 *   We must provide our own implementations of these basic functions. */

void *
memcpy(void *dst, const void *src, size_t n)
{
  100528:	56                   	push   %esi
  100529:	31 d2                	xor    %edx,%edx
  10052b:	53                   	push   %ebx
  10052c:	8b 44 24 0c          	mov    0xc(%esp),%eax
  100530:	8b 5c 24 10          	mov    0x10(%esp),%ebx
  100534:	8b 74 24 14          	mov    0x14(%esp),%esi
	const char *s = (const char *) src;
	char *d = (char *) dst;
	while (n-- > 0)
  100538:	eb 08                	jmp    100542 <memcpy+0x1a>
		*d++ = *s++;
  10053a:	8a 0c 13             	mov    (%ebx,%edx,1),%cl
  10053d:	4e                   	dec    %esi
  10053e:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  100541:	42                   	inc    %edx
void *
memcpy(void *dst, const void *src, size_t n)
{
	const char *s = (const char *) src;
	char *d = (char *) dst;
	while (n-- > 0)
  100542:	85 f6                	test   %esi,%esi
  100544:	75 f4                	jne    10053a <memcpy+0x12>
		*d++ = *s++;
	return dst;
}
  100546:	5b                   	pop    %ebx
  100547:	5e                   	pop    %esi
  100548:	c3                   	ret    

00100549 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  100549:	57                   	push   %edi
  10054a:	56                   	push   %esi
  10054b:	53                   	push   %ebx
  10054c:	8b 44 24 10          	mov    0x10(%esp),%eax
  100550:	8b 7c 24 14          	mov    0x14(%esp),%edi
  100554:	8b 54 24 18          	mov    0x18(%esp),%edx
	const char *s = (const char *) src;
	char *d = (char *) dst;
	if (s < d && s + n > d) {
  100558:	39 c7                	cmp    %eax,%edi
  10055a:	73 26                	jae    100582 <memmove+0x39>
  10055c:	8d 34 17             	lea    (%edi,%edx,1),%esi
  10055f:	39 c6                	cmp    %eax,%esi
  100561:	76 1f                	jbe    100582 <memmove+0x39>
		s += n, d += n;
  100563:	8d 3c 10             	lea    (%eax,%edx,1),%edi
  100566:	31 c9                	xor    %ecx,%ecx
		while (n-- > 0)
  100568:	eb 07                	jmp    100571 <memmove+0x28>
			*--d = *--s;
  10056a:	8a 1c 0e             	mov    (%esi,%ecx,1),%bl
  10056d:	4a                   	dec    %edx
  10056e:	88 1c 0f             	mov    %bl,(%edi,%ecx,1)
  100571:	49                   	dec    %ecx
{
	const char *s = (const char *) src;
	char *d = (char *) dst;
	if (s < d && s + n > d) {
		s += n, d += n;
		while (n-- > 0)
  100572:	85 d2                	test   %edx,%edx
  100574:	75 f4                	jne    10056a <memmove+0x21>
  100576:	eb 10                	jmp    100588 <memmove+0x3f>
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  100578:	8a 1c 0f             	mov    (%edi,%ecx,1),%bl
  10057b:	4a                   	dec    %edx
  10057c:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
  10057f:	41                   	inc    %ecx
  100580:	eb 02                	jmp    100584 <memmove+0x3b>
  100582:	31 c9                	xor    %ecx,%ecx
	if (s < d && s + n > d) {
		s += n, d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  100584:	85 d2                	test   %edx,%edx
  100586:	75 f0                	jne    100578 <memmove+0x2f>
			*d++ = *s++;
	return dst;
}
  100588:	5b                   	pop    %ebx
  100589:	5e                   	pop    %esi
  10058a:	5f                   	pop    %edi
  10058b:	c3                   	ret    

0010058c <memset>:

void *
memset(void *v, int c, size_t n)
{
  10058c:	53                   	push   %ebx
  10058d:	8b 44 24 08          	mov    0x8(%esp),%eax
  100591:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  100595:	8b 4c 24 10          	mov    0x10(%esp),%ecx
	char *p = (char *) v;
  100599:	89 c2                	mov    %eax,%edx
	while (n-- > 0)
  10059b:	eb 04                	jmp    1005a1 <memset+0x15>
		*p++ = c;
  10059d:	88 1a                	mov    %bl,(%edx)
  10059f:	49                   	dec    %ecx
  1005a0:	42                   	inc    %edx

void *
memset(void *v, int c, size_t n)
{
	char *p = (char *) v;
	while (n-- > 0)
  1005a1:	85 c9                	test   %ecx,%ecx
  1005a3:	75 f8                	jne    10059d <memset+0x11>
		*p++ = c;
	return v;
}
  1005a5:	5b                   	pop    %ebx
  1005a6:	c3                   	ret    

001005a7 <strlen>:

size_t
strlen(const char *s)
{
  1005a7:	8b 54 24 04          	mov    0x4(%esp),%edx
  1005ab:	31 c0                	xor    %eax,%eax
	size_t n;
	for (n = 0; *s != '\0'; ++s)
  1005ad:	eb 01                	jmp    1005b0 <strlen+0x9>
		++n;
  1005af:	40                   	inc    %eax

size_t
strlen(const char *s)
{
	size_t n;
	for (n = 0; *s != '\0'; ++s)
  1005b0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  1005b4:	75 f9                	jne    1005af <strlen+0x8>
		++n;
	return n;
}
  1005b6:	c3                   	ret    

001005b7 <strnlen>:

size_t
strnlen(const char *s, size_t maxlen)
{
  1005b7:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  1005bb:	31 c0                	xor    %eax,%eax
  1005bd:	8b 54 24 08          	mov    0x8(%esp),%edx
	size_t n;
	for (n = 0; n != maxlen && *s != '\0'; ++s)
  1005c1:	eb 01                	jmp    1005c4 <strnlen+0xd>
		++n;
  1005c3:	40                   	inc    %eax

size_t
strnlen(const char *s, size_t maxlen)
{
	size_t n;
	for (n = 0; n != maxlen && *s != '\0'; ++s)
  1005c4:	39 d0                	cmp    %edx,%eax
  1005c6:	74 06                	je     1005ce <strnlen+0x17>
  1005c8:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  1005cc:	75 f5                	jne    1005c3 <strnlen+0xc>
		++n;
	return n;
}
  1005ce:	c3                   	ret    

001005cf <console_putc>:
 *
 *   Print a message onto the console, starting at the given cursor position. */

static uint16_t *
console_putc(uint16_t *cursor, unsigned char c, int color)
{
  1005cf:	56                   	push   %esi
	if (cursor >= CONSOLE_END)
  1005d0:	3d 9f 8f 0b 00       	cmp    $0xb8f9f,%eax
 *
 *   Print a message onto the console, starting at the given cursor position. */

static uint16_t *
console_putc(uint16_t *cursor, unsigned char c, int color)
{
  1005d5:	53                   	push   %ebx
  1005d6:	89 c3                	mov    %eax,%ebx
	if (cursor >= CONSOLE_END)
  1005d8:	76 05                	jbe    1005df <console_putc+0x10>
  1005da:	bb 00 80 0b 00       	mov    $0xb8000,%ebx
		cursor = CONSOLE_BEGIN;
	if (c == '\n') {
  1005df:	80 fa 0a             	cmp    $0xa,%dl
  1005e2:	75 2c                	jne    100610 <console_putc+0x41>
		int pos = (cursor - CONSOLE_BEGIN) % 80;
  1005e4:	8d 83 00 80 f4 ff    	lea    -0xb8000(%ebx),%eax
  1005ea:	be 50 00 00 00       	mov    $0x50,%esi
  1005ef:	d1 f8                	sar    %eax
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
  1005f1:	83 c9 20             	or     $0x20,%ecx
console_putc(uint16_t *cursor, unsigned char c, int color)
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
  1005f4:	99                   	cltd   
  1005f5:	f7 fe                	idiv   %esi
  1005f7:	89 de                	mov    %ebx,%esi
  1005f9:	89 d0                	mov    %edx,%eax
		for (; pos != 80; pos++)
  1005fb:	eb 07                	jmp    100604 <console_putc+0x35>
			*cursor++ = ' ' | color;
  1005fd:	66 89 0e             	mov    %cx,(%esi)
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
  100600:	40                   	inc    %eax
			*cursor++ = ' ' | color;
  100601:	83 c6 02             	add    $0x2,%esi
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
  100604:	83 f8 50             	cmp    $0x50,%eax
  100607:	75 f4                	jne    1005fd <console_putc+0x2e>
  100609:	29 d0                	sub    %edx,%eax
  10060b:	8d 04 43             	lea    (%ebx,%eax,2),%eax
  10060e:	eb 0b                	jmp    10061b <console_putc+0x4c>
			*cursor++ = ' ' | color;
	} else
		*cursor++ = c | color;
  100610:	0f b6 d2             	movzbl %dl,%edx
  100613:	09 ca                	or     %ecx,%edx
  100615:	66 89 13             	mov    %dx,(%ebx)
  100618:	8d 43 02             	lea    0x2(%ebx),%eax
	return cursor;
}
  10061b:	5b                   	pop    %ebx
  10061c:	5e                   	pop    %esi
  10061d:	c3                   	ret    

0010061e <fill_numbuf>:
static const char lower_digits[] = "0123456789abcdef";

static char *
fill_numbuf(char *numbuf_end, uint32_t val, int base, const char *digits,
	    int precision)
{
  10061e:	56                   	push   %esi
  10061f:	53                   	push   %ebx
  100620:	8b 74 24 0c          	mov    0xc(%esp),%esi
	*--numbuf_end = '\0';
  100624:	8d 58 ff             	lea    -0x1(%eax),%ebx
  100627:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
	if (precision != 0 || val != 0)
  10062b:	83 7c 24 10 00       	cmpl   $0x0,0x10(%esp)
  100630:	75 04                	jne    100636 <fill_numbuf+0x18>
  100632:	85 d2                	test   %edx,%edx
  100634:	74 10                	je     100646 <fill_numbuf+0x28>
		do {
			*--numbuf_end = digits[val % base];
  100636:	89 d0                	mov    %edx,%eax
  100638:	31 d2                	xor    %edx,%edx
  10063a:	f7 f1                	div    %ecx
  10063c:	4b                   	dec    %ebx
  10063d:	8a 14 16             	mov    (%esi,%edx,1),%dl
  100640:	88 13                	mov    %dl,(%ebx)
			val /= base;
  100642:	89 c2                	mov    %eax,%edx
  100644:	eb ec                	jmp    100632 <fill_numbuf+0x14>
		} while (val != 0);
	return numbuf_end;
}
  100646:	89 d8                	mov    %ebx,%eax
  100648:	5b                   	pop    %ebx
  100649:	5e                   	pop    %esi
  10064a:	c3                   	ret    

0010064b <console_vprintf>:
#define FLAG_PLUSPOSITIVE	(1<<4)
static const char flag_chars[] = "#0- +";

uint16_t *
console_vprintf(uint16_t *cursor, int color, const char *format, va_list val)
{
  10064b:	55                   	push   %ebp
  10064c:	57                   	push   %edi
  10064d:	56                   	push   %esi
  10064e:	53                   	push   %ebx
  10064f:	83 ec 38             	sub    $0x38,%esp
  100652:	8b 74 24 4c          	mov    0x4c(%esp),%esi
  100656:	8b 7c 24 54          	mov    0x54(%esp),%edi
  10065a:	8b 5c 24 58          	mov    0x58(%esp),%ebx
	int flags, width, zeros, precision, negative, numeric, len;
#define NUMBUFSIZ 20
	char numbuf[NUMBUFSIZ];
	char *data;

	for (; *format; ++format) {
  10065e:	e9 60 03 00 00       	jmp    1009c3 <console_vprintf+0x378>
		if (*format != '%') {
  100663:	80 fa 25             	cmp    $0x25,%dl
  100666:	74 13                	je     10067b <console_vprintf+0x30>
			cursor = console_putc(cursor, *format, color);
  100668:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  10066c:	0f b6 d2             	movzbl %dl,%edx
  10066f:	89 f0                	mov    %esi,%eax
  100671:	e8 59 ff ff ff       	call   1005cf <console_putc>
  100676:	e9 45 03 00 00       	jmp    1009c0 <console_vprintf+0x375>
			continue;
		}

		// process flags
		flags = 0;
		for (++format; *format; ++format) {
  10067b:	47                   	inc    %edi
  10067c:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  100683:	00 
  100684:	eb 12                	jmp    100698 <console_vprintf+0x4d>
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
				++flagc;
  100686:	41                   	inc    %ecx

		// process flags
		flags = 0;
		for (++format; *format; ++format) {
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
  100687:	8a 11                	mov    (%ecx),%dl
  100689:	84 d2                	test   %dl,%dl
  10068b:	74 1a                	je     1006a7 <console_vprintf+0x5c>
  10068d:	89 e8                	mov    %ebp,%eax
  10068f:	38 c2                	cmp    %al,%dl
  100691:	75 f3                	jne    100686 <console_vprintf+0x3b>
  100693:	e9 3f 03 00 00       	jmp    1009d7 <console_vprintf+0x38c>
			continue;
		}

		// process flags
		flags = 0;
		for (++format; *format; ++format) {
  100698:	8a 17                	mov    (%edi),%dl
  10069a:	84 d2                	test   %dl,%dl
  10069c:	74 0b                	je     1006a9 <console_vprintf+0x5e>
  10069e:	b9 50 0a 10 00       	mov    $0x100a50,%ecx
  1006a3:	89 d5                	mov    %edx,%ebp
  1006a5:	eb e0                	jmp    100687 <console_vprintf+0x3c>
  1006a7:	89 ea                	mov    %ebp,%edx
			flags |= (1 << (flagc - flag_chars));
		}

		// process width
		width = -1;
		if (*format >= '1' && *format <= '9') {
  1006a9:	8d 42 cf             	lea    -0x31(%edx),%eax
  1006ac:	3c 08                	cmp    $0x8,%al
  1006ae:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1006b5:	00 
  1006b6:	76 13                	jbe    1006cb <console_vprintf+0x80>
  1006b8:	eb 1d                	jmp    1006d7 <console_vprintf+0x8c>
			for (width = 0; *format >= '0' && *format <= '9'; )
				width = 10 * width + *format++ - '0';
  1006ba:	6b 54 24 0c 0a       	imul   $0xa,0xc(%esp),%edx
  1006bf:	0f be c0             	movsbl %al,%eax
  1006c2:	47                   	inc    %edi
  1006c3:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
  1006c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
		}

		// process width
		width = -1;
		if (*format >= '1' && *format <= '9') {
			for (width = 0; *format >= '0' && *format <= '9'; )
  1006cb:	8a 07                	mov    (%edi),%al
  1006cd:	8d 50 d0             	lea    -0x30(%eax),%edx
  1006d0:	80 fa 09             	cmp    $0x9,%dl
  1006d3:	76 e5                	jbe    1006ba <console_vprintf+0x6f>
  1006d5:	eb 18                	jmp    1006ef <console_vprintf+0xa4>
				width = 10 * width + *format++ - '0';
		} else if (*format == '*') {
  1006d7:	80 fa 2a             	cmp    $0x2a,%dl
  1006da:	c7 44 24 0c ff ff ff 	movl   $0xffffffff,0xc(%esp)
  1006e1:	ff 
  1006e2:	75 0b                	jne    1006ef <console_vprintf+0xa4>
			width = va_arg(val, int);
  1006e4:	83 c3 04             	add    $0x4,%ebx
			++format;
  1006e7:	47                   	inc    %edi
		width = -1;
		if (*format >= '1' && *format <= '9') {
			for (width = 0; *format >= '0' && *format <= '9'; )
				width = 10 * width + *format++ - '0';
		} else if (*format == '*') {
			width = va_arg(val, int);
  1006e8:	8b 53 fc             	mov    -0x4(%ebx),%edx
  1006eb:	89 54 24 0c          	mov    %edx,0xc(%esp)
			++format;
		}

		// process precision
		precision = -1;
		if (*format == '.') {
  1006ef:	83 cd ff             	or     $0xffffffff,%ebp
  1006f2:	80 3f 2e             	cmpb   $0x2e,(%edi)
  1006f5:	75 37                	jne    10072e <console_vprintf+0xe3>
			++format;
  1006f7:	47                   	inc    %edi
			if (*format >= '0' && *format <= '9') {
  1006f8:	31 ed                	xor    %ebp,%ebp
  1006fa:	8a 07                	mov    (%edi),%al
  1006fc:	8d 50 d0             	lea    -0x30(%eax),%edx
  1006ff:	80 fa 09             	cmp    $0x9,%dl
  100702:	76 0d                	jbe    100711 <console_vprintf+0xc6>
  100704:	eb 17                	jmp    10071d <console_vprintf+0xd2>
				for (precision = 0; *format >= '0' && *format <= '9'; )
					precision = 10 * precision + *format++ - '0';
  100706:	6b ed 0a             	imul   $0xa,%ebp,%ebp
  100709:	0f be c0             	movsbl %al,%eax
  10070c:	47                   	inc    %edi
  10070d:	8d 6c 05 d0          	lea    -0x30(%ebp,%eax,1),%ebp
		// process precision
		precision = -1;
		if (*format == '.') {
			++format;
			if (*format >= '0' && *format <= '9') {
				for (precision = 0; *format >= '0' && *format <= '9'; )
  100711:	8a 07                	mov    (%edi),%al
  100713:	8d 50 d0             	lea    -0x30(%eax),%edx
  100716:	80 fa 09             	cmp    $0x9,%dl
  100719:	76 eb                	jbe    100706 <console_vprintf+0xbb>
  10071b:	eb 11                	jmp    10072e <console_vprintf+0xe3>
					precision = 10 * precision + *format++ - '0';
			} else if (*format == '*') {
  10071d:	3c 2a                	cmp    $0x2a,%al
  10071f:	75 0b                	jne    10072c <console_vprintf+0xe1>
				precision = va_arg(val, int);
  100721:	83 c3 04             	add    $0x4,%ebx
				++format;
  100724:	47                   	inc    %edi
			++format;
			if (*format >= '0' && *format <= '9') {
				for (precision = 0; *format >= '0' && *format <= '9'; )
					precision = 10 * precision + *format++ - '0';
			} else if (*format == '*') {
				precision = va_arg(val, int);
  100725:	8b 6b fc             	mov    -0x4(%ebx),%ebp
				++format;
			}
			if (precision < 0)
  100728:	85 ed                	test   %ebp,%ebp
  10072a:	79 02                	jns    10072e <console_vprintf+0xe3>
  10072c:	31 ed                	xor    %ebp,%ebp
		}

		// process main conversion character
		negative = 0;
		numeric = 0;
		switch (*format) {
  10072e:	8a 07                	mov    (%edi),%al
  100730:	3c 64                	cmp    $0x64,%al
  100732:	74 34                	je     100768 <console_vprintf+0x11d>
  100734:	7f 1d                	jg     100753 <console_vprintf+0x108>
  100736:	3c 58                	cmp    $0x58,%al
  100738:	0f 84 a2 00 00 00    	je     1007e0 <console_vprintf+0x195>
  10073e:	3c 63                	cmp    $0x63,%al
  100740:	0f 84 bf 00 00 00    	je     100805 <console_vprintf+0x1ba>
  100746:	3c 43                	cmp    $0x43,%al
  100748:	0f 85 d0 00 00 00    	jne    10081e <console_vprintf+0x1d3>
  10074e:	e9 a3 00 00 00       	jmp    1007f6 <console_vprintf+0x1ab>
  100753:	3c 75                	cmp    $0x75,%al
  100755:	74 4d                	je     1007a4 <console_vprintf+0x159>
  100757:	3c 78                	cmp    $0x78,%al
  100759:	74 5c                	je     1007b7 <console_vprintf+0x16c>
  10075b:	3c 73                	cmp    $0x73,%al
  10075d:	0f 85 bb 00 00 00    	jne    10081e <console_vprintf+0x1d3>
  100763:	e9 86 00 00 00       	jmp    1007ee <console_vprintf+0x1a3>
		case 'd': {
			int x = va_arg(val, int);
  100768:	83 c3 04             	add    $0x4,%ebx
  10076b:	8b 53 fc             	mov    -0x4(%ebx),%edx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x > 0 ? x : -x, 10, upper_digits, precision);
  10076e:	89 d1                	mov    %edx,%ecx
  100770:	c1 f9 1f             	sar    $0x1f,%ecx
  100773:	89 0c 24             	mov    %ecx,(%esp)
  100776:	31 ca                	xor    %ecx,%edx
  100778:	55                   	push   %ebp
  100779:	29 ca                	sub    %ecx,%edx
  10077b:	68 58 0a 10 00       	push   $0x100a58
  100780:	b9 0a 00 00 00       	mov    $0xa,%ecx
  100785:	8d 44 24 40          	lea    0x40(%esp),%eax
  100789:	e8 90 fe ff ff       	call   10061e <fill_numbuf>
  10078e:	89 44 24 0c          	mov    %eax,0xc(%esp)
			if (x < 0)
  100792:	58                   	pop    %eax
  100793:	5a                   	pop    %edx
  100794:	ba 01 00 00 00       	mov    $0x1,%edx
  100799:	8b 04 24             	mov    (%esp),%eax
  10079c:	83 e0 01             	and    $0x1,%eax
  10079f:	e9 a5 00 00 00       	jmp    100849 <console_vprintf+0x1fe>
				negative = 1;
			numeric = 1;
			break;
		}
		case 'u': {
			unsigned x = va_arg(val, unsigned);
  1007a4:	83 c3 04             	add    $0x4,%ebx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 10, upper_digits, precision);
  1007a7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  1007ac:	8b 53 fc             	mov    -0x4(%ebx),%edx
  1007af:	55                   	push   %ebp
  1007b0:	68 58 0a 10 00       	push   $0x100a58
  1007b5:	eb 11                	jmp    1007c8 <console_vprintf+0x17d>
			numeric = 1;
			break;
		}
		case 'x': {
			unsigned x = va_arg(val, unsigned);
  1007b7:	83 c3 04             	add    $0x4,%ebx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 16, lower_digits, precision);
  1007ba:	8b 53 fc             	mov    -0x4(%ebx),%edx
  1007bd:	55                   	push   %ebp
  1007be:	68 6c 0a 10 00       	push   $0x100a6c
  1007c3:	b9 10 00 00 00       	mov    $0x10,%ecx
  1007c8:	8d 44 24 40          	lea    0x40(%esp),%eax
  1007cc:	e8 4d fe ff ff       	call   10061e <fill_numbuf>
  1007d1:	ba 01 00 00 00       	mov    $0x1,%edx
  1007d6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1007da:	31 c0                	xor    %eax,%eax
			numeric = 1;
			break;
  1007dc:	59                   	pop    %ecx
  1007dd:	59                   	pop    %ecx
  1007de:	eb 69                	jmp    100849 <console_vprintf+0x1fe>
		}
		case 'X': {
			unsigned x = va_arg(val, unsigned);
  1007e0:	83 c3 04             	add    $0x4,%ebx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 16, upper_digits, precision);
  1007e3:	8b 53 fc             	mov    -0x4(%ebx),%edx
  1007e6:	55                   	push   %ebp
  1007e7:	68 58 0a 10 00       	push   $0x100a58
  1007ec:	eb d5                	jmp    1007c3 <console_vprintf+0x178>
			numeric = 1;
			break;
		}
		case 's':
			data = va_arg(val, char *);
  1007ee:	83 c3 04             	add    $0x4,%ebx
  1007f1:	8b 43 fc             	mov    -0x4(%ebx),%eax
  1007f4:	eb 40                	jmp    100836 <console_vprintf+0x1eb>
			break;
		case 'C':
			color = va_arg(val, int);
  1007f6:	83 c3 04             	add    $0x4,%ebx
  1007f9:	8b 53 fc             	mov    -0x4(%ebx),%edx
  1007fc:	89 54 24 50          	mov    %edx,0x50(%esp)
			goto done;
  100800:	e9 bd 01 00 00       	jmp    1009c2 <console_vprintf+0x377>
		case 'c':
			data = numbuf;
			numbuf[0] = va_arg(val, int);
  100805:	83 c3 04             	add    $0x4,%ebx
  100808:	8b 43 fc             	mov    -0x4(%ebx),%eax
			numbuf[1] = '\0';
  10080b:	8d 4c 24 24          	lea    0x24(%esp),%ecx
  10080f:	c6 44 24 25 00       	movb   $0x0,0x25(%esp)
  100814:	89 4c 24 04          	mov    %ecx,0x4(%esp)
		case 'C':
			color = va_arg(val, int);
			goto done;
		case 'c':
			data = numbuf;
			numbuf[0] = va_arg(val, int);
  100818:	88 44 24 24          	mov    %al,0x24(%esp)
  10081c:	eb 27                	jmp    100845 <console_vprintf+0x1fa>
			numbuf[1] = '\0';
			break;
		normal:
		default:
			data = numbuf;
			numbuf[0] = (*format ? *format : '%');
  10081e:	84 c0                	test   %al,%al
  100820:	75 02                	jne    100824 <console_vprintf+0x1d9>
  100822:	b0 25                	mov    $0x25,%al
  100824:	88 44 24 24          	mov    %al,0x24(%esp)
			numbuf[1] = '\0';
  100828:	c6 44 24 25 00       	movb   $0x0,0x25(%esp)
			if (!*format)
  10082d:	80 3f 00             	cmpb   $0x0,(%edi)
  100830:	74 0a                	je     10083c <console_vprintf+0x1f1>
  100832:	8d 44 24 24          	lea    0x24(%esp),%eax
  100836:	89 44 24 04          	mov    %eax,0x4(%esp)
  10083a:	eb 09                	jmp    100845 <console_vprintf+0x1fa>
				format--;
  10083c:	8d 54 24 24          	lea    0x24(%esp),%edx
  100840:	4f                   	dec    %edi
  100841:	89 54 24 04          	mov    %edx,0x4(%esp)
  100845:	31 d2                	xor    %edx,%edx
  100847:	31 c0                	xor    %eax,%eax
			break;
		}

		if (precision >= 0)
			len = strnlen(data, precision);
  100849:	31 c9                	xor    %ecx,%ecx
			if (!*format)
				format--;
			break;
		}

		if (precision >= 0)
  10084b:	83 fd ff             	cmp    $0xffffffff,%ebp
  10084e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100855:	74 1f                	je     100876 <console_vprintf+0x22b>
  100857:	89 04 24             	mov    %eax,(%esp)
  10085a:	eb 01                	jmp    10085d <console_vprintf+0x212>
size_t
strnlen(const char *s, size_t maxlen)
{
	size_t n;
	for (n = 0; n != maxlen && *s != '\0'; ++s)
		++n;
  10085c:	41                   	inc    %ecx

size_t
strnlen(const char *s, size_t maxlen)
{
	size_t n;
	for (n = 0; n != maxlen && *s != '\0'; ++s)
  10085d:	39 e9                	cmp    %ebp,%ecx
  10085f:	74 0a                	je     10086b <console_vprintf+0x220>
  100861:	8b 44 24 04          	mov    0x4(%esp),%eax
  100865:	80 3c 08 00          	cmpb   $0x0,(%eax,%ecx,1)
  100869:	75 f1                	jne    10085c <console_vprintf+0x211>
  10086b:	8b 04 24             	mov    (%esp),%eax
				format--;
			break;
		}

		if (precision >= 0)
			len = strnlen(data, precision);
  10086e:	89 0c 24             	mov    %ecx,(%esp)
  100871:	eb 1f                	jmp    100892 <console_vprintf+0x247>
size_t
strlen(const char *s)
{
	size_t n;
	for (n = 0; *s != '\0'; ++s)
		++n;
  100873:	42                   	inc    %edx
  100874:	eb 09                	jmp    10087f <console_vprintf+0x234>
  100876:	89 d1                	mov    %edx,%ecx
  100878:	8b 14 24             	mov    (%esp),%edx
  10087b:	89 44 24 08          	mov    %eax,0x8(%esp)

size_t
strlen(const char *s)
{
	size_t n;
	for (n = 0; *s != '\0'; ++s)
  10087f:	8b 44 24 04          	mov    0x4(%esp),%eax
  100883:	80 3c 10 00          	cmpb   $0x0,(%eax,%edx,1)
  100887:	75 ea                	jne    100873 <console_vprintf+0x228>
  100889:	8b 44 24 08          	mov    0x8(%esp),%eax
  10088d:	89 14 24             	mov    %edx,(%esp)
  100890:	89 ca                	mov    %ecx,%edx

		if (precision >= 0)
			len = strnlen(data, precision);
		else
			len = strlen(data);
		if (numeric && negative)
  100892:	85 c0                	test   %eax,%eax
  100894:	74 0c                	je     1008a2 <console_vprintf+0x257>
  100896:	84 d2                	test   %dl,%dl
  100898:	c7 44 24 08 2d 00 00 	movl   $0x2d,0x8(%esp)
  10089f:	00 
  1008a0:	75 24                	jne    1008c6 <console_vprintf+0x27b>
			negative = '-';
		else if (flags & FLAG_PLUSPOSITIVE)
  1008a2:	f6 44 24 14 10       	testb  $0x10,0x14(%esp)
  1008a7:	c7 44 24 08 2b 00 00 	movl   $0x2b,0x8(%esp)
  1008ae:	00 
  1008af:	75 15                	jne    1008c6 <console_vprintf+0x27b>
			negative = '+';
		else if (flags & FLAG_SPACEPOSITIVE)
  1008b1:	8b 44 24 14          	mov    0x14(%esp),%eax
  1008b5:	83 e0 08             	and    $0x8,%eax
  1008b8:	83 f8 01             	cmp    $0x1,%eax
  1008bb:	19 c9                	sbb    %ecx,%ecx
  1008bd:	f7 d1                	not    %ecx
  1008bf:	83 e1 20             	and    $0x20,%ecx
  1008c2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
			negative = ' ';
		else
			negative = 0;
		if (numeric && precision > len)
  1008c6:	3b 2c 24             	cmp    (%esp),%ebp
  1008c9:	7e 0d                	jle    1008d8 <console_vprintf+0x28d>
  1008cb:	84 d2                	test   %dl,%dl
  1008cd:	74 40                	je     10090f <console_vprintf+0x2c4>
			zeros = precision - len;
  1008cf:	2b 2c 24             	sub    (%esp),%ebp
  1008d2:	89 6c 24 10          	mov    %ebp,0x10(%esp)
  1008d6:	eb 3f                	jmp    100917 <console_vprintf+0x2cc>
		else if ((flags & (FLAG_ZERO | FLAG_LEFTJUSTIFY)) == FLAG_ZERO
  1008d8:	84 d2                	test   %dl,%dl
  1008da:	74 33                	je     10090f <console_vprintf+0x2c4>
  1008dc:	8b 44 24 14          	mov    0x14(%esp),%eax
  1008e0:	83 e0 06             	and    $0x6,%eax
  1008e3:	83 f8 02             	cmp    $0x2,%eax
  1008e6:	75 27                	jne    10090f <console_vprintf+0x2c4>
  1008e8:	45                   	inc    %ebp
  1008e9:	75 24                	jne    10090f <console_vprintf+0x2c4>
			 && numeric && precision < 0
			 && len + !!negative < width)
  1008eb:	31 c0                	xor    %eax,%eax
			negative = ' ';
		else
			negative = 0;
		if (numeric && precision > len)
			zeros = precision - len;
		else if ((flags & (FLAG_ZERO | FLAG_LEFTJUSTIFY)) == FLAG_ZERO
  1008ed:	8b 0c 24             	mov    (%esp),%ecx
			 && numeric && precision < 0
			 && len + !!negative < width)
  1008f0:	83 7c 24 08 00       	cmpl   $0x0,0x8(%esp)
  1008f5:	0f 95 c0             	setne  %al
			negative = ' ';
		else
			negative = 0;
		if (numeric && precision > len)
			zeros = precision - len;
		else if ((flags & (FLAG_ZERO | FLAG_LEFTJUSTIFY)) == FLAG_ZERO
  1008f8:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  1008fb:	3b 54 24 0c          	cmp    0xc(%esp),%edx
  1008ff:	7d 0e                	jge    10090f <console_vprintf+0x2c4>
			 && numeric && precision < 0
			 && len + !!negative < width)
			zeros = width - len - !!negative;
  100901:	8b 54 24 0c          	mov    0xc(%esp),%edx
  100905:	29 ca                	sub    %ecx,%edx
  100907:	29 c2                	sub    %eax,%edx
  100909:	89 54 24 10          	mov    %edx,0x10(%esp)
			negative = ' ';
		else
			negative = 0;
		if (numeric && precision > len)
			zeros = precision - len;
		else if ((flags & (FLAG_ZERO | FLAG_LEFTJUSTIFY)) == FLAG_ZERO
  10090d:	eb 08                	jmp    100917 <console_vprintf+0x2cc>
  10090f:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  100916:	00 
			 && numeric && precision < 0
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
  100917:	8b 6c 24 0c          	mov    0xc(%esp),%ebp
  10091b:	31 c0                	xor    %eax,%eax
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  10091d:	8b 4c 24 14          	mov    0x14(%esp),%ecx
			 && numeric && precision < 0
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
  100921:	2b 2c 24             	sub    (%esp),%ebp
  100924:	83 7c 24 08 00       	cmpl   $0x0,0x8(%esp)
  100929:	0f 95 c0             	setne  %al
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  10092c:	83 e1 04             	and    $0x4,%ecx
			 && numeric && precision < 0
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
  10092f:	29 c5                	sub    %eax,%ebp
  100931:	89 f0                	mov    %esi,%eax
  100933:	2b 6c 24 10          	sub    0x10(%esp),%ebp
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  100937:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  10093b:	eb 0f                	jmp    10094c <console_vprintf+0x301>
			cursor = console_putc(cursor, ' ', color);
  10093d:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  100941:	ba 20 00 00 00       	mov    $0x20,%edx
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  100946:	4d                   	dec    %ebp
			cursor = console_putc(cursor, ' ', color);
  100947:	e8 83 fc ff ff       	call   1005cf <console_putc>
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  10094c:	85 ed                	test   %ebp,%ebp
  10094e:	7e 07                	jle    100957 <console_vprintf+0x30c>
  100950:	83 7c 24 0c 00       	cmpl   $0x0,0xc(%esp)
  100955:	74 e6                	je     10093d <console_vprintf+0x2f2>
			cursor = console_putc(cursor, ' ', color);
		if (negative)
  100957:	83 7c 24 08 00       	cmpl   $0x0,0x8(%esp)
  10095c:	89 c6                	mov    %eax,%esi
  10095e:	74 23                	je     100983 <console_vprintf+0x338>
			cursor = console_putc(cursor, negative, color);
  100960:	0f b6 54 24 08       	movzbl 0x8(%esp),%edx
  100965:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  100969:	e8 61 fc ff ff       	call   1005cf <console_putc>
  10096e:	89 c6                	mov    %eax,%esi
  100970:	eb 11                	jmp    100983 <console_vprintf+0x338>
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
  100972:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  100976:	ba 30 00 00 00       	mov    $0x30,%edx
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
  10097b:	4e                   	dec    %esi
			cursor = console_putc(cursor, '0', color);
  10097c:	e8 4e fc ff ff       	call   1005cf <console_putc>
  100981:	eb 06                	jmp    100989 <console_vprintf+0x33e>
  100983:	89 f0                	mov    %esi,%eax
  100985:	8b 74 24 10          	mov    0x10(%esp),%esi
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
  100989:	85 f6                	test   %esi,%esi
  10098b:	7f e5                	jg     100972 <console_vprintf+0x327>
  10098d:	8b 34 24             	mov    (%esp),%esi
  100990:	eb 15                	jmp    1009a7 <console_vprintf+0x35c>
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
			cursor = console_putc(cursor, *data, color);
  100992:	8b 4c 24 04          	mov    0x4(%esp),%ecx
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
  100996:	4e                   	dec    %esi
			cursor = console_putc(cursor, *data, color);
  100997:	0f b6 11             	movzbl (%ecx),%edx
  10099a:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  10099e:	e8 2c fc ff ff       	call   1005cf <console_putc>
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
  1009a3:	ff 44 24 04          	incl   0x4(%esp)
  1009a7:	85 f6                	test   %esi,%esi
  1009a9:	7f e7                	jg     100992 <console_vprintf+0x347>
  1009ab:	eb 0f                	jmp    1009bc <console_vprintf+0x371>
			cursor = console_putc(cursor, *data, color);
		for (; width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
  1009ad:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  1009b1:	ba 20 00 00 00       	mov    $0x20,%edx
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
			cursor = console_putc(cursor, *data, color);
		for (; width > 0; --width)
  1009b6:	4d                   	dec    %ebp
			cursor = console_putc(cursor, ' ', color);
  1009b7:	e8 13 fc ff ff       	call   1005cf <console_putc>
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
			cursor = console_putc(cursor, *data, color);
		for (; width > 0; --width)
  1009bc:	85 ed                	test   %ebp,%ebp
  1009be:	7f ed                	jg     1009ad <console_vprintf+0x362>
  1009c0:	89 c6                	mov    %eax,%esi
	int flags, width, zeros, precision, negative, numeric, len;
#define NUMBUFSIZ 20
	char numbuf[NUMBUFSIZ];
	char *data;

	for (; *format; ++format) {
  1009c2:	47                   	inc    %edi
  1009c3:	8a 17                	mov    (%edi),%dl
  1009c5:	84 d2                	test   %dl,%dl
  1009c7:	0f 85 96 fc ff ff    	jne    100663 <console_vprintf+0x18>
			cursor = console_putc(cursor, ' ', color);
	done: ;
	}

	return cursor;
}
  1009cd:	83 c4 38             	add    $0x38,%esp
  1009d0:	89 f0                	mov    %esi,%eax
  1009d2:	5b                   	pop    %ebx
  1009d3:	5e                   	pop    %esi
  1009d4:	5f                   	pop    %edi
  1009d5:	5d                   	pop    %ebp
  1009d6:	c3                   	ret    
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
				++flagc;
			if (*flagc == '\0')
				break;
			flags |= (1 << (flagc - flag_chars));
  1009d7:	81 e9 50 0a 10 00    	sub    $0x100a50,%ecx
  1009dd:	b8 01 00 00 00       	mov    $0x1,%eax
  1009e2:	d3 e0                	shl    %cl,%eax
			continue;
		}

		// process flags
		flags = 0;
		for (++format; *format; ++format) {
  1009e4:	47                   	inc    %edi
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
				++flagc;
			if (*flagc == '\0')
				break;
			flags |= (1 << (flagc - flag_chars));
  1009e5:	09 44 24 14          	or     %eax,0x14(%esp)
  1009e9:	e9 aa fc ff ff       	jmp    100698 <console_vprintf+0x4d>

001009ee <console_printf>:
uint16_t *
console_printf(uint16_t *cursor, int color, const char *format, ...)
{
	va_list val;
	va_start(val, format);
	cursor = console_vprintf(cursor, color, format, val);
  1009ee:	8d 44 24 10          	lea    0x10(%esp),%eax
  1009f2:	50                   	push   %eax
  1009f3:	ff 74 24 10          	pushl  0x10(%esp)
  1009f7:	ff 74 24 10          	pushl  0x10(%esp)
  1009fb:	ff 74 24 10          	pushl  0x10(%esp)
  1009ff:	e8 47 fc ff ff       	call   10064b <console_vprintf>
  100a04:	83 c4 10             	add    $0x10,%esp
	va_end(val);
	return cursor;
}
  100a07:	c3                   	ret    
