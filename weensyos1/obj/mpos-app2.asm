
obj/mpos-app2:     file format elf32-i386


Disassembly of section .text:

00200000 <app_printf>:

static void app_printf(const char *format, ...) __attribute__((noinline));

static void
app_printf(const char *format, ...)
{
  200000:	83 ec 0c             	sub    $0xc,%esp
	// That means that after the "asm" instruction (which causes the
	// interrupt), the system call's return value is in the 'pid'
	// variable, and we can just return that value!

	pid_t pid;
	asm volatile("int %1\n"
  200003:	cd 30                	int    $0x30
static void
app_printf(const char *format, ...)
{
	// set default color based on currently running process
	int color = sys_getpid();
	if (color < 0)
  200005:	85 c0                	test   %eax,%eax
  200007:	ba 00 07 00 00       	mov    $0x700,%edx
  20000c:	78 13                	js     200021 <app_printf+0x21>
		color = 0x0700;
	else {
		static const uint8_t col[] = { 0x0E, 0x0F, 0x0C, 0x0A, 0x09 };
		color = col[color % sizeof(col)] << 8;
  20000e:	b9 05 00 00 00       	mov    $0x5,%ecx
  200013:	31 d2                	xor    %edx,%edx
  200015:	f7 f1                	div    %ecx
  200017:	0f b6 92 c4 05 20 00 	movzbl 0x2005c4(%edx),%edx
  20001e:	c1 e2 08             	shl    $0x8,%edx
	}

	va_list val;
	va_start(val, format);
	cursorpos = console_vprintf(cursorpos, color, format, val);
  200021:	8d 44 24 14          	lea    0x14(%esp),%eax
  200025:	50                   	push   %eax
  200026:	ff 74 24 14          	pushl  0x14(%esp)
  20002a:	52                   	push   %edx
  20002b:	ff 35 00 00 06 00    	pushl  0x60000
  200031:	e8 b1 01 00 00       	call   2001e7 <console_vprintf>
  200036:	a3 00 00 06 00       	mov    %eax,0x60000
	va_end(val);
}
  20003b:	83 c4 1c             	add    $0x1c,%esp
  20003e:	c3                   	ret    

0020003f <run_child>:
	sys_exit(0);
}

void
run_child(void)
{
  20003f:	53                   	push   %ebx
  200040:	83 ec 0c             	sub    $0xc,%esp
	int input_counter = counter;
  200043:	8b 1d fc 15 20 00    	mov    0x2015fc,%ebx

	counter++;		/* Note that all "processes" share an address
  200049:	a1 fc 15 20 00       	mov    0x2015fc,%eax
  20004e:	40                   	inc    %eax
  20004f:	a3 fc 15 20 00       	mov    %eax,0x2015fc
	// That means that after the "asm" instruction (which causes the
	// interrupt), the system call's return value is in the 'pid'
	// variable, and we can just return that value!

	pid_t pid;
	asm volatile("int %1\n"
  200054:	cd 30                	int    $0x30
				   space, so this change to 'counter' will be
				   visible to all processes. */

	app_printf("Process %d lives, counter %d!\n",
  200056:	53                   	push   %ebx
  200057:	50                   	push   %eax
  200058:	68 a4 05 20 00       	push   $0x2005a4
  20005d:	e8 9e ff ff ff       	call   200000 <app_printf>
	// the 'int' instruction.
	// You can load other registers with similar syntax; specifically:
	//	"a" = %eax, "b" = %ebx, "c" = %ecx, "d" = %edx,
	//	"S" = %esi, "D" = %edi.

	asm volatile("int %0\n"
  200062:	89 d8                	mov    %ebx,%eax
  200064:	cd 33                	int    $0x33
  200066:	83 c4 10             	add    $0x10,%esp
  200069:	eb fe                	jmp    200069 <run_child+0x2a>

0020006b <start>:

void run_child(void);

void
start(void)
{
  20006b:	53                   	push   %ebx
  20006c:	83 ec 08             	sub    $0x8,%esp
	pid_t p;
	int status;

	counter = 0;
  20006f:	c7 05 fc 15 20 00 00 	movl   $0x0,0x2015fc
  200076:	00 00 00 

	while (counter < 1025) {
  200079:	eb 33                	jmp    2000ae <start+0x43>
sys_fork(void)
{
	// This system call follows the same pattern as sys_getpid().

	pid_t result;
	asm volatile("int %1\n"
  20007b:	cd 31                	int    $0x31

		// Start as many processes as possible, until we fail to start
		// a process or we have started 1025 processes total.
		while (counter + n_started < 1025) {
			p = sys_fork();
			if (p == 0)
  20007d:	83 f8 00             	cmp    $0x0,%eax
  200080:	75 07                	jne    200089 <start+0x1e>
				run_child();
  200082:	e8 b8 ff ff ff       	call   20003f <run_child>
  200087:	eb 03                	jmp    20008c <start+0x21>
			else if (p > 0)
  200089:	7e 10                	jle    20009b <start+0x30>
				n_started++;
  20008b:	43                   	inc    %ebx
	while (counter < 1025) {
		int n_started = 0;

		// Start as many processes as possible, until we fail to start
		// a process or we have started 1025 processes total.
		while (counter + n_started < 1025) {
  20008c:	a1 fc 15 20 00       	mov    0x2015fc,%eax
  200091:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  200094:	3d 00 04 00 00       	cmp    $0x400,%eax
  200099:	7e e0                	jle    20007b <start+0x10>
			else
				break;
		}

		// If we could not start any new processes, give up!
		if (n_started == 0)
  20009b:	85 db                	test   %ebx,%ebx
  20009d:	74 1f                	je     2000be <start+0x53>
  20009f:	ba 02 00 00 00       	mov    $0x2,%edx

static inline int
sys_wait(pid_t pid)
{
	int retval;
	asm volatile("int %1\n"
  2000a4:	89 d0                	mov    %edx,%eax
  2000a6:	cd 34                	int    $0x34
		// We started at least one process, but then could not start
		// any more.
		// That means we ran out of room to start processes.
		// Retrieve old processes' exit status with sys_wait(),
		// to make room for new processes.
		for (p = 2; p < NPROCS; p++) {
  2000a8:	42                   	inc    %edx
  2000a9:	83 fa 10             	cmp    $0x10,%edx
  2000ac:	75 f6                	jne    2000a4 <start+0x39>
	pid_t p;
	int status;

	counter = 0;

	while (counter < 1025) {
  2000ae:	a1 fc 15 20 00       	mov    0x2015fc,%eax
  2000b3:	3d 00 04 00 00       	cmp    $0x400,%eax
  2000b8:	7f 04                	jg     2000be <start+0x53>
  2000ba:	31 db                	xor    %ebx,%ebx
  2000bc:	eb ce                	jmp    20008c <start+0x21>
	// the 'int' instruction.
	// You can load other registers with similar syntax; specifically:
	//	"a" = %eax, "b" = %ebx, "c" = %ecx, "d" = %edx,
	//	"S" = %esi, "D" = %edi.

	asm volatile("int %0\n"
  2000be:	31 c0                	xor    %eax,%eax
  2000c0:	cd 33                	int    $0x33
  2000c2:	eb fe                	jmp    2000c2 <start+0x57>

002000c4 <memcpy>:
 *
 *   We must provide our own implementations of these basic functions. */

void *
memcpy(void *dst, const void *src, size_t n)
{
  2000c4:	56                   	push   %esi
  2000c5:	31 d2                	xor    %edx,%edx
  2000c7:	53                   	push   %ebx
  2000c8:	8b 44 24 0c          	mov    0xc(%esp),%eax
  2000cc:	8b 5c 24 10          	mov    0x10(%esp),%ebx
  2000d0:	8b 74 24 14          	mov    0x14(%esp),%esi
	const char *s = (const char *) src;
	char *d = (char *) dst;
	while (n-- > 0)
  2000d4:	eb 08                	jmp    2000de <memcpy+0x1a>
		*d++ = *s++;
  2000d6:	8a 0c 13             	mov    (%ebx,%edx,1),%cl
  2000d9:	4e                   	dec    %esi
  2000da:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  2000dd:	42                   	inc    %edx
void *
memcpy(void *dst, const void *src, size_t n)
{
	const char *s = (const char *) src;
	char *d = (char *) dst;
	while (n-- > 0)
  2000de:	85 f6                	test   %esi,%esi
  2000e0:	75 f4                	jne    2000d6 <memcpy+0x12>
		*d++ = *s++;
	return dst;
}
  2000e2:	5b                   	pop    %ebx
  2000e3:	5e                   	pop    %esi
  2000e4:	c3                   	ret    

002000e5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  2000e5:	57                   	push   %edi
  2000e6:	56                   	push   %esi
  2000e7:	53                   	push   %ebx
  2000e8:	8b 44 24 10          	mov    0x10(%esp),%eax
  2000ec:	8b 7c 24 14          	mov    0x14(%esp),%edi
  2000f0:	8b 54 24 18          	mov    0x18(%esp),%edx
	const char *s = (const char *) src;
	char *d = (char *) dst;
	if (s < d && s + n > d) {
  2000f4:	39 c7                	cmp    %eax,%edi
  2000f6:	73 26                	jae    20011e <memmove+0x39>
  2000f8:	8d 34 17             	lea    (%edi,%edx,1),%esi
  2000fb:	39 c6                	cmp    %eax,%esi
  2000fd:	76 1f                	jbe    20011e <memmove+0x39>
		s += n, d += n;
  2000ff:	8d 3c 10             	lea    (%eax,%edx,1),%edi
  200102:	31 c9                	xor    %ecx,%ecx
		while (n-- > 0)
  200104:	eb 07                	jmp    20010d <memmove+0x28>
			*--d = *--s;
  200106:	8a 1c 0e             	mov    (%esi,%ecx,1),%bl
  200109:	4a                   	dec    %edx
  20010a:	88 1c 0f             	mov    %bl,(%edi,%ecx,1)
  20010d:	49                   	dec    %ecx
{
	const char *s = (const char *) src;
	char *d = (char *) dst;
	if (s < d && s + n > d) {
		s += n, d += n;
		while (n-- > 0)
  20010e:	85 d2                	test   %edx,%edx
  200110:	75 f4                	jne    200106 <memmove+0x21>
  200112:	eb 10                	jmp    200124 <memmove+0x3f>
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  200114:	8a 1c 0f             	mov    (%edi,%ecx,1),%bl
  200117:	4a                   	dec    %edx
  200118:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
  20011b:	41                   	inc    %ecx
  20011c:	eb 02                	jmp    200120 <memmove+0x3b>
  20011e:	31 c9                	xor    %ecx,%ecx
	if (s < d && s + n > d) {
		s += n, d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  200120:	85 d2                	test   %edx,%edx
  200122:	75 f0                	jne    200114 <memmove+0x2f>
			*d++ = *s++;
	return dst;
}
  200124:	5b                   	pop    %ebx
  200125:	5e                   	pop    %esi
  200126:	5f                   	pop    %edi
  200127:	c3                   	ret    

00200128 <memset>:

void *
memset(void *v, int c, size_t n)
{
  200128:	53                   	push   %ebx
  200129:	8b 44 24 08          	mov    0x8(%esp),%eax
  20012d:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  200131:	8b 4c 24 10          	mov    0x10(%esp),%ecx
	char *p = (char *) v;
  200135:	89 c2                	mov    %eax,%edx
	while (n-- > 0)
  200137:	eb 04                	jmp    20013d <memset+0x15>
		*p++ = c;
  200139:	88 1a                	mov    %bl,(%edx)
  20013b:	49                   	dec    %ecx
  20013c:	42                   	inc    %edx

void *
memset(void *v, int c, size_t n)
{
	char *p = (char *) v;
	while (n-- > 0)
  20013d:	85 c9                	test   %ecx,%ecx
  20013f:	75 f8                	jne    200139 <memset+0x11>
		*p++ = c;
	return v;
}
  200141:	5b                   	pop    %ebx
  200142:	c3                   	ret    

00200143 <strlen>:

size_t
strlen(const char *s)
{
  200143:	8b 54 24 04          	mov    0x4(%esp),%edx
  200147:	31 c0                	xor    %eax,%eax
	size_t n;
	for (n = 0; *s != '\0'; ++s)
  200149:	eb 01                	jmp    20014c <strlen+0x9>
		++n;
  20014b:	40                   	inc    %eax

size_t
strlen(const char *s)
{
	size_t n;
	for (n = 0; *s != '\0'; ++s)
  20014c:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  200150:	75 f9                	jne    20014b <strlen+0x8>
		++n;
	return n;
}
  200152:	c3                   	ret    

00200153 <strnlen>:

size_t
strnlen(const char *s, size_t maxlen)
{
  200153:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  200157:	31 c0                	xor    %eax,%eax
  200159:	8b 54 24 08          	mov    0x8(%esp),%edx
	size_t n;
	for (n = 0; n != maxlen && *s != '\0'; ++s)
  20015d:	eb 01                	jmp    200160 <strnlen+0xd>
		++n;
  20015f:	40                   	inc    %eax

size_t
strnlen(const char *s, size_t maxlen)
{
	size_t n;
	for (n = 0; n != maxlen && *s != '\0'; ++s)
  200160:	39 d0                	cmp    %edx,%eax
  200162:	74 06                	je     20016a <strnlen+0x17>
  200164:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  200168:	75 f5                	jne    20015f <strnlen+0xc>
		++n;
	return n;
}
  20016a:	c3                   	ret    

0020016b <console_putc>:
 *
 *   Print a message onto the console, starting at the given cursor position. */

static uint16_t *
console_putc(uint16_t *cursor, unsigned char c, int color)
{
  20016b:	56                   	push   %esi
	if (cursor >= CONSOLE_END)
  20016c:	3d 9f 8f 0b 00       	cmp    $0xb8f9f,%eax
 *
 *   Print a message onto the console, starting at the given cursor position. */

static uint16_t *
console_putc(uint16_t *cursor, unsigned char c, int color)
{
  200171:	53                   	push   %ebx
  200172:	89 c3                	mov    %eax,%ebx
	if (cursor >= CONSOLE_END)
  200174:	76 05                	jbe    20017b <console_putc+0x10>
  200176:	bb 00 80 0b 00       	mov    $0xb8000,%ebx
		cursor = CONSOLE_BEGIN;
	if (c == '\n') {
  20017b:	80 fa 0a             	cmp    $0xa,%dl
  20017e:	75 2c                	jne    2001ac <console_putc+0x41>
		int pos = (cursor - CONSOLE_BEGIN) % 80;
  200180:	8d 83 00 80 f4 ff    	lea    -0xb8000(%ebx),%eax
  200186:	be 50 00 00 00       	mov    $0x50,%esi
  20018b:	d1 f8                	sar    %eax
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
  20018d:	83 c9 20             	or     $0x20,%ecx
console_putc(uint16_t *cursor, unsigned char c, int color)
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
  200190:	99                   	cltd   
  200191:	f7 fe                	idiv   %esi
  200193:	89 de                	mov    %ebx,%esi
  200195:	89 d0                	mov    %edx,%eax
		for (; pos != 80; pos++)
  200197:	eb 07                	jmp    2001a0 <console_putc+0x35>
			*cursor++ = ' ' | color;
  200199:	66 89 0e             	mov    %cx,(%esi)
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
  20019c:	40                   	inc    %eax
			*cursor++ = ' ' | color;
  20019d:	83 c6 02             	add    $0x2,%esi
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
  2001a0:	83 f8 50             	cmp    $0x50,%eax
  2001a3:	75 f4                	jne    200199 <console_putc+0x2e>
  2001a5:	29 d0                	sub    %edx,%eax
  2001a7:	8d 04 43             	lea    (%ebx,%eax,2),%eax
  2001aa:	eb 0b                	jmp    2001b7 <console_putc+0x4c>
			*cursor++ = ' ' | color;
	} else
		*cursor++ = c | color;
  2001ac:	0f b6 d2             	movzbl %dl,%edx
  2001af:	09 ca                	or     %ecx,%edx
  2001b1:	66 89 13             	mov    %dx,(%ebx)
  2001b4:	8d 43 02             	lea    0x2(%ebx),%eax
	return cursor;
}
  2001b7:	5b                   	pop    %ebx
  2001b8:	5e                   	pop    %esi
  2001b9:	c3                   	ret    

002001ba <fill_numbuf>:
static const char lower_digits[] = "0123456789abcdef";

static char *
fill_numbuf(char *numbuf_end, uint32_t val, int base, const char *digits,
	    int precision)
{
  2001ba:	56                   	push   %esi
  2001bb:	53                   	push   %ebx
  2001bc:	8b 74 24 0c          	mov    0xc(%esp),%esi
	*--numbuf_end = '\0';
  2001c0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  2001c3:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
	if (precision != 0 || val != 0)
  2001c7:	83 7c 24 10 00       	cmpl   $0x0,0x10(%esp)
  2001cc:	75 04                	jne    2001d2 <fill_numbuf+0x18>
  2001ce:	85 d2                	test   %edx,%edx
  2001d0:	74 10                	je     2001e2 <fill_numbuf+0x28>
		do {
			*--numbuf_end = digits[val % base];
  2001d2:	89 d0                	mov    %edx,%eax
  2001d4:	31 d2                	xor    %edx,%edx
  2001d6:	f7 f1                	div    %ecx
  2001d8:	4b                   	dec    %ebx
  2001d9:	8a 14 16             	mov    (%esi,%edx,1),%dl
  2001dc:	88 13                	mov    %dl,(%ebx)
			val /= base;
  2001de:	89 c2                	mov    %eax,%edx
  2001e0:	eb ec                	jmp    2001ce <fill_numbuf+0x14>
		} while (val != 0);
	return numbuf_end;
}
  2001e2:	89 d8                	mov    %ebx,%eax
  2001e4:	5b                   	pop    %ebx
  2001e5:	5e                   	pop    %esi
  2001e6:	c3                   	ret    

002001e7 <console_vprintf>:
#define FLAG_PLUSPOSITIVE	(1<<4)
static const char flag_chars[] = "#0- +";

uint16_t *
console_vprintf(uint16_t *cursor, int color, const char *format, va_list val)
{
  2001e7:	55                   	push   %ebp
  2001e8:	57                   	push   %edi
  2001e9:	56                   	push   %esi
  2001ea:	53                   	push   %ebx
  2001eb:	83 ec 38             	sub    $0x38,%esp
  2001ee:	8b 74 24 4c          	mov    0x4c(%esp),%esi
  2001f2:	8b 7c 24 54          	mov    0x54(%esp),%edi
  2001f6:	8b 5c 24 58          	mov    0x58(%esp),%ebx
	int flags, width, zeros, precision, negative, numeric, len;
#define NUMBUFSIZ 20
	char numbuf[NUMBUFSIZ];
	char *data;

	for (; *format; ++format) {
  2001fa:	e9 60 03 00 00       	jmp    20055f <console_vprintf+0x378>
		if (*format != '%') {
  2001ff:	80 fa 25             	cmp    $0x25,%dl
  200202:	74 13                	je     200217 <console_vprintf+0x30>
			cursor = console_putc(cursor, *format, color);
  200204:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  200208:	0f b6 d2             	movzbl %dl,%edx
  20020b:	89 f0                	mov    %esi,%eax
  20020d:	e8 59 ff ff ff       	call   20016b <console_putc>
  200212:	e9 45 03 00 00       	jmp    20055c <console_vprintf+0x375>
			continue;
		}

		// process flags
		flags = 0;
		for (++format; *format; ++format) {
  200217:	47                   	inc    %edi
  200218:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  20021f:	00 
  200220:	eb 12                	jmp    200234 <console_vprintf+0x4d>
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
				++flagc;
  200222:	41                   	inc    %ecx

		// process flags
		flags = 0;
		for (++format; *format; ++format) {
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
  200223:	8a 11                	mov    (%ecx),%dl
  200225:	84 d2                	test   %dl,%dl
  200227:	74 1a                	je     200243 <console_vprintf+0x5c>
  200229:	89 e8                	mov    %ebp,%eax
  20022b:	38 c2                	cmp    %al,%dl
  20022d:	75 f3                	jne    200222 <console_vprintf+0x3b>
  20022f:	e9 3f 03 00 00       	jmp    200573 <console_vprintf+0x38c>
			continue;
		}

		// process flags
		flags = 0;
		for (++format; *format; ++format) {
  200234:	8a 17                	mov    (%edi),%dl
  200236:	84 d2                	test   %dl,%dl
  200238:	74 0b                	je     200245 <console_vprintf+0x5e>
  20023a:	b9 cc 05 20 00       	mov    $0x2005cc,%ecx
  20023f:	89 d5                	mov    %edx,%ebp
  200241:	eb e0                	jmp    200223 <console_vprintf+0x3c>
  200243:	89 ea                	mov    %ebp,%edx
			flags |= (1 << (flagc - flag_chars));
		}

		// process width
		width = -1;
		if (*format >= '1' && *format <= '9') {
  200245:	8d 42 cf             	lea    -0x31(%edx),%eax
  200248:	3c 08                	cmp    $0x8,%al
  20024a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  200251:	00 
  200252:	76 13                	jbe    200267 <console_vprintf+0x80>
  200254:	eb 1d                	jmp    200273 <console_vprintf+0x8c>
			for (width = 0; *format >= '0' && *format <= '9'; )
				width = 10 * width + *format++ - '0';
  200256:	6b 54 24 0c 0a       	imul   $0xa,0xc(%esp),%edx
  20025b:	0f be c0             	movsbl %al,%eax
  20025e:	47                   	inc    %edi
  20025f:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
  200263:	89 44 24 0c          	mov    %eax,0xc(%esp)
		}

		// process width
		width = -1;
		if (*format >= '1' && *format <= '9') {
			for (width = 0; *format >= '0' && *format <= '9'; )
  200267:	8a 07                	mov    (%edi),%al
  200269:	8d 50 d0             	lea    -0x30(%eax),%edx
  20026c:	80 fa 09             	cmp    $0x9,%dl
  20026f:	76 e5                	jbe    200256 <console_vprintf+0x6f>
  200271:	eb 18                	jmp    20028b <console_vprintf+0xa4>
				width = 10 * width + *format++ - '0';
		} else if (*format == '*') {
  200273:	80 fa 2a             	cmp    $0x2a,%dl
  200276:	c7 44 24 0c ff ff ff 	movl   $0xffffffff,0xc(%esp)
  20027d:	ff 
  20027e:	75 0b                	jne    20028b <console_vprintf+0xa4>
			width = va_arg(val, int);
  200280:	83 c3 04             	add    $0x4,%ebx
			++format;
  200283:	47                   	inc    %edi
		width = -1;
		if (*format >= '1' && *format <= '9') {
			for (width = 0; *format >= '0' && *format <= '9'; )
				width = 10 * width + *format++ - '0';
		} else if (*format == '*') {
			width = va_arg(val, int);
  200284:	8b 53 fc             	mov    -0x4(%ebx),%edx
  200287:	89 54 24 0c          	mov    %edx,0xc(%esp)
			++format;
		}

		// process precision
		precision = -1;
		if (*format == '.') {
  20028b:	83 cd ff             	or     $0xffffffff,%ebp
  20028e:	80 3f 2e             	cmpb   $0x2e,(%edi)
  200291:	75 37                	jne    2002ca <console_vprintf+0xe3>
			++format;
  200293:	47                   	inc    %edi
			if (*format >= '0' && *format <= '9') {
  200294:	31 ed                	xor    %ebp,%ebp
  200296:	8a 07                	mov    (%edi),%al
  200298:	8d 50 d0             	lea    -0x30(%eax),%edx
  20029b:	80 fa 09             	cmp    $0x9,%dl
  20029e:	76 0d                	jbe    2002ad <console_vprintf+0xc6>
  2002a0:	eb 17                	jmp    2002b9 <console_vprintf+0xd2>
				for (precision = 0; *format >= '0' && *format <= '9'; )
					precision = 10 * precision + *format++ - '0';
  2002a2:	6b ed 0a             	imul   $0xa,%ebp,%ebp
  2002a5:	0f be c0             	movsbl %al,%eax
  2002a8:	47                   	inc    %edi
  2002a9:	8d 6c 05 d0          	lea    -0x30(%ebp,%eax,1),%ebp
		// process precision
		precision = -1;
		if (*format == '.') {
			++format;
			if (*format >= '0' && *format <= '9') {
				for (precision = 0; *format >= '0' && *format <= '9'; )
  2002ad:	8a 07                	mov    (%edi),%al
  2002af:	8d 50 d0             	lea    -0x30(%eax),%edx
  2002b2:	80 fa 09             	cmp    $0x9,%dl
  2002b5:	76 eb                	jbe    2002a2 <console_vprintf+0xbb>
  2002b7:	eb 11                	jmp    2002ca <console_vprintf+0xe3>
					precision = 10 * precision + *format++ - '0';
			} else if (*format == '*') {
  2002b9:	3c 2a                	cmp    $0x2a,%al
  2002bb:	75 0b                	jne    2002c8 <console_vprintf+0xe1>
				precision = va_arg(val, int);
  2002bd:	83 c3 04             	add    $0x4,%ebx
				++format;
  2002c0:	47                   	inc    %edi
			++format;
			if (*format >= '0' && *format <= '9') {
				for (precision = 0; *format >= '0' && *format <= '9'; )
					precision = 10 * precision + *format++ - '0';
			} else if (*format == '*') {
				precision = va_arg(val, int);
  2002c1:	8b 6b fc             	mov    -0x4(%ebx),%ebp
				++format;
			}
			if (precision < 0)
  2002c4:	85 ed                	test   %ebp,%ebp
  2002c6:	79 02                	jns    2002ca <console_vprintf+0xe3>
  2002c8:	31 ed                	xor    %ebp,%ebp
		}

		// process main conversion character
		negative = 0;
		numeric = 0;
		switch (*format) {
  2002ca:	8a 07                	mov    (%edi),%al
  2002cc:	3c 64                	cmp    $0x64,%al
  2002ce:	74 34                	je     200304 <console_vprintf+0x11d>
  2002d0:	7f 1d                	jg     2002ef <console_vprintf+0x108>
  2002d2:	3c 58                	cmp    $0x58,%al
  2002d4:	0f 84 a2 00 00 00    	je     20037c <console_vprintf+0x195>
  2002da:	3c 63                	cmp    $0x63,%al
  2002dc:	0f 84 bf 00 00 00    	je     2003a1 <console_vprintf+0x1ba>
  2002e2:	3c 43                	cmp    $0x43,%al
  2002e4:	0f 85 d0 00 00 00    	jne    2003ba <console_vprintf+0x1d3>
  2002ea:	e9 a3 00 00 00       	jmp    200392 <console_vprintf+0x1ab>
  2002ef:	3c 75                	cmp    $0x75,%al
  2002f1:	74 4d                	je     200340 <console_vprintf+0x159>
  2002f3:	3c 78                	cmp    $0x78,%al
  2002f5:	74 5c                	je     200353 <console_vprintf+0x16c>
  2002f7:	3c 73                	cmp    $0x73,%al
  2002f9:	0f 85 bb 00 00 00    	jne    2003ba <console_vprintf+0x1d3>
  2002ff:	e9 86 00 00 00       	jmp    20038a <console_vprintf+0x1a3>
		case 'd': {
			int x = va_arg(val, int);
  200304:	83 c3 04             	add    $0x4,%ebx
  200307:	8b 53 fc             	mov    -0x4(%ebx),%edx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x > 0 ? x : -x, 10, upper_digits, precision);
  20030a:	89 d1                	mov    %edx,%ecx
  20030c:	c1 f9 1f             	sar    $0x1f,%ecx
  20030f:	89 0c 24             	mov    %ecx,(%esp)
  200312:	31 ca                	xor    %ecx,%edx
  200314:	55                   	push   %ebp
  200315:	29 ca                	sub    %ecx,%edx
  200317:	68 d4 05 20 00       	push   $0x2005d4
  20031c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  200321:	8d 44 24 40          	lea    0x40(%esp),%eax
  200325:	e8 90 fe ff ff       	call   2001ba <fill_numbuf>
  20032a:	89 44 24 0c          	mov    %eax,0xc(%esp)
			if (x < 0)
  20032e:	58                   	pop    %eax
  20032f:	5a                   	pop    %edx
  200330:	ba 01 00 00 00       	mov    $0x1,%edx
  200335:	8b 04 24             	mov    (%esp),%eax
  200338:	83 e0 01             	and    $0x1,%eax
  20033b:	e9 a5 00 00 00       	jmp    2003e5 <console_vprintf+0x1fe>
				negative = 1;
			numeric = 1;
			break;
		}
		case 'u': {
			unsigned x = va_arg(val, unsigned);
  200340:	83 c3 04             	add    $0x4,%ebx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 10, upper_digits, precision);
  200343:	b9 0a 00 00 00       	mov    $0xa,%ecx
  200348:	8b 53 fc             	mov    -0x4(%ebx),%edx
  20034b:	55                   	push   %ebp
  20034c:	68 d4 05 20 00       	push   $0x2005d4
  200351:	eb 11                	jmp    200364 <console_vprintf+0x17d>
			numeric = 1;
			break;
		}
		case 'x': {
			unsigned x = va_arg(val, unsigned);
  200353:	83 c3 04             	add    $0x4,%ebx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 16, lower_digits, precision);
  200356:	8b 53 fc             	mov    -0x4(%ebx),%edx
  200359:	55                   	push   %ebp
  20035a:	68 e8 05 20 00       	push   $0x2005e8
  20035f:	b9 10 00 00 00       	mov    $0x10,%ecx
  200364:	8d 44 24 40          	lea    0x40(%esp),%eax
  200368:	e8 4d fe ff ff       	call   2001ba <fill_numbuf>
  20036d:	ba 01 00 00 00       	mov    $0x1,%edx
  200372:	89 44 24 0c          	mov    %eax,0xc(%esp)
  200376:	31 c0                	xor    %eax,%eax
			numeric = 1;
			break;
  200378:	59                   	pop    %ecx
  200379:	59                   	pop    %ecx
  20037a:	eb 69                	jmp    2003e5 <console_vprintf+0x1fe>
		}
		case 'X': {
			unsigned x = va_arg(val, unsigned);
  20037c:	83 c3 04             	add    $0x4,%ebx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 16, upper_digits, precision);
  20037f:	8b 53 fc             	mov    -0x4(%ebx),%edx
  200382:	55                   	push   %ebp
  200383:	68 d4 05 20 00       	push   $0x2005d4
  200388:	eb d5                	jmp    20035f <console_vprintf+0x178>
			numeric = 1;
			break;
		}
		case 's':
			data = va_arg(val, char *);
  20038a:	83 c3 04             	add    $0x4,%ebx
  20038d:	8b 43 fc             	mov    -0x4(%ebx),%eax
  200390:	eb 40                	jmp    2003d2 <console_vprintf+0x1eb>
			break;
		case 'C':
			color = va_arg(val, int);
  200392:	83 c3 04             	add    $0x4,%ebx
  200395:	8b 53 fc             	mov    -0x4(%ebx),%edx
  200398:	89 54 24 50          	mov    %edx,0x50(%esp)
			goto done;
  20039c:	e9 bd 01 00 00       	jmp    20055e <console_vprintf+0x377>
		case 'c':
			data = numbuf;
			numbuf[0] = va_arg(val, int);
  2003a1:	83 c3 04             	add    $0x4,%ebx
  2003a4:	8b 43 fc             	mov    -0x4(%ebx),%eax
			numbuf[1] = '\0';
  2003a7:	8d 4c 24 24          	lea    0x24(%esp),%ecx
  2003ab:	c6 44 24 25 00       	movb   $0x0,0x25(%esp)
  2003b0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
		case 'C':
			color = va_arg(val, int);
			goto done;
		case 'c':
			data = numbuf;
			numbuf[0] = va_arg(val, int);
  2003b4:	88 44 24 24          	mov    %al,0x24(%esp)
  2003b8:	eb 27                	jmp    2003e1 <console_vprintf+0x1fa>
			numbuf[1] = '\0';
			break;
		normal:
		default:
			data = numbuf;
			numbuf[0] = (*format ? *format : '%');
  2003ba:	84 c0                	test   %al,%al
  2003bc:	75 02                	jne    2003c0 <console_vprintf+0x1d9>
  2003be:	b0 25                	mov    $0x25,%al
  2003c0:	88 44 24 24          	mov    %al,0x24(%esp)
			numbuf[1] = '\0';
  2003c4:	c6 44 24 25 00       	movb   $0x0,0x25(%esp)
			if (!*format)
  2003c9:	80 3f 00             	cmpb   $0x0,(%edi)
  2003cc:	74 0a                	je     2003d8 <console_vprintf+0x1f1>
  2003ce:	8d 44 24 24          	lea    0x24(%esp),%eax
  2003d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  2003d6:	eb 09                	jmp    2003e1 <console_vprintf+0x1fa>
				format--;
  2003d8:	8d 54 24 24          	lea    0x24(%esp),%edx
  2003dc:	4f                   	dec    %edi
  2003dd:	89 54 24 04          	mov    %edx,0x4(%esp)
  2003e1:	31 d2                	xor    %edx,%edx
  2003e3:	31 c0                	xor    %eax,%eax
			break;
		}

		if (precision >= 0)
			len = strnlen(data, precision);
  2003e5:	31 c9                	xor    %ecx,%ecx
			if (!*format)
				format--;
			break;
		}

		if (precision >= 0)
  2003e7:	83 fd ff             	cmp    $0xffffffff,%ebp
  2003ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  2003f1:	74 1f                	je     200412 <console_vprintf+0x22b>
  2003f3:	89 04 24             	mov    %eax,(%esp)
  2003f6:	eb 01                	jmp    2003f9 <console_vprintf+0x212>
size_t
strnlen(const char *s, size_t maxlen)
{
	size_t n;
	for (n = 0; n != maxlen && *s != '\0'; ++s)
		++n;
  2003f8:	41                   	inc    %ecx

size_t
strnlen(const char *s, size_t maxlen)
{
	size_t n;
	for (n = 0; n != maxlen && *s != '\0'; ++s)
  2003f9:	39 e9                	cmp    %ebp,%ecx
  2003fb:	74 0a                	je     200407 <console_vprintf+0x220>
  2003fd:	8b 44 24 04          	mov    0x4(%esp),%eax
  200401:	80 3c 08 00          	cmpb   $0x0,(%eax,%ecx,1)
  200405:	75 f1                	jne    2003f8 <console_vprintf+0x211>
  200407:	8b 04 24             	mov    (%esp),%eax
				format--;
			break;
		}

		if (precision >= 0)
			len = strnlen(data, precision);
  20040a:	89 0c 24             	mov    %ecx,(%esp)
  20040d:	eb 1f                	jmp    20042e <console_vprintf+0x247>
size_t
strlen(const char *s)
{
	size_t n;
	for (n = 0; *s != '\0'; ++s)
		++n;
  20040f:	42                   	inc    %edx
  200410:	eb 09                	jmp    20041b <console_vprintf+0x234>
  200412:	89 d1                	mov    %edx,%ecx
  200414:	8b 14 24             	mov    (%esp),%edx
  200417:	89 44 24 08          	mov    %eax,0x8(%esp)

size_t
strlen(const char *s)
{
	size_t n;
	for (n = 0; *s != '\0'; ++s)
  20041b:	8b 44 24 04          	mov    0x4(%esp),%eax
  20041f:	80 3c 10 00          	cmpb   $0x0,(%eax,%edx,1)
  200423:	75 ea                	jne    20040f <console_vprintf+0x228>
  200425:	8b 44 24 08          	mov    0x8(%esp),%eax
  200429:	89 14 24             	mov    %edx,(%esp)
  20042c:	89 ca                	mov    %ecx,%edx

		if (precision >= 0)
			len = strnlen(data, precision);
		else
			len = strlen(data);
		if (numeric && negative)
  20042e:	85 c0                	test   %eax,%eax
  200430:	74 0c                	je     20043e <console_vprintf+0x257>
  200432:	84 d2                	test   %dl,%dl
  200434:	c7 44 24 08 2d 00 00 	movl   $0x2d,0x8(%esp)
  20043b:	00 
  20043c:	75 24                	jne    200462 <console_vprintf+0x27b>
			negative = '-';
		else if (flags & FLAG_PLUSPOSITIVE)
  20043e:	f6 44 24 14 10       	testb  $0x10,0x14(%esp)
  200443:	c7 44 24 08 2b 00 00 	movl   $0x2b,0x8(%esp)
  20044a:	00 
  20044b:	75 15                	jne    200462 <console_vprintf+0x27b>
			negative = '+';
		else if (flags & FLAG_SPACEPOSITIVE)
  20044d:	8b 44 24 14          	mov    0x14(%esp),%eax
  200451:	83 e0 08             	and    $0x8,%eax
  200454:	83 f8 01             	cmp    $0x1,%eax
  200457:	19 c9                	sbb    %ecx,%ecx
  200459:	f7 d1                	not    %ecx
  20045b:	83 e1 20             	and    $0x20,%ecx
  20045e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
			negative = ' ';
		else
			negative = 0;
		if (numeric && precision > len)
  200462:	3b 2c 24             	cmp    (%esp),%ebp
  200465:	7e 0d                	jle    200474 <console_vprintf+0x28d>
  200467:	84 d2                	test   %dl,%dl
  200469:	74 40                	je     2004ab <console_vprintf+0x2c4>
			zeros = precision - len;
  20046b:	2b 2c 24             	sub    (%esp),%ebp
  20046e:	89 6c 24 10          	mov    %ebp,0x10(%esp)
  200472:	eb 3f                	jmp    2004b3 <console_vprintf+0x2cc>
		else if ((flags & (FLAG_ZERO | FLAG_LEFTJUSTIFY)) == FLAG_ZERO
  200474:	84 d2                	test   %dl,%dl
  200476:	74 33                	je     2004ab <console_vprintf+0x2c4>
  200478:	8b 44 24 14          	mov    0x14(%esp),%eax
  20047c:	83 e0 06             	and    $0x6,%eax
  20047f:	83 f8 02             	cmp    $0x2,%eax
  200482:	75 27                	jne    2004ab <console_vprintf+0x2c4>
  200484:	45                   	inc    %ebp
  200485:	75 24                	jne    2004ab <console_vprintf+0x2c4>
			 && numeric && precision < 0
			 && len + !!negative < width)
  200487:	31 c0                	xor    %eax,%eax
			negative = ' ';
		else
			negative = 0;
		if (numeric && precision > len)
			zeros = precision - len;
		else if ((flags & (FLAG_ZERO | FLAG_LEFTJUSTIFY)) == FLAG_ZERO
  200489:	8b 0c 24             	mov    (%esp),%ecx
			 && numeric && precision < 0
			 && len + !!negative < width)
  20048c:	83 7c 24 08 00       	cmpl   $0x0,0x8(%esp)
  200491:	0f 95 c0             	setne  %al
			negative = ' ';
		else
			negative = 0;
		if (numeric && precision > len)
			zeros = precision - len;
		else if ((flags & (FLAG_ZERO | FLAG_LEFTJUSTIFY)) == FLAG_ZERO
  200494:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  200497:	3b 54 24 0c          	cmp    0xc(%esp),%edx
  20049b:	7d 0e                	jge    2004ab <console_vprintf+0x2c4>
			 && numeric && precision < 0
			 && len + !!negative < width)
			zeros = width - len - !!negative;
  20049d:	8b 54 24 0c          	mov    0xc(%esp),%edx
  2004a1:	29 ca                	sub    %ecx,%edx
  2004a3:	29 c2                	sub    %eax,%edx
  2004a5:	89 54 24 10          	mov    %edx,0x10(%esp)
			negative = ' ';
		else
			negative = 0;
		if (numeric && precision > len)
			zeros = precision - len;
		else if ((flags & (FLAG_ZERO | FLAG_LEFTJUSTIFY)) == FLAG_ZERO
  2004a9:	eb 08                	jmp    2004b3 <console_vprintf+0x2cc>
  2004ab:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  2004b2:	00 
			 && numeric && precision < 0
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
  2004b3:	8b 6c 24 0c          	mov    0xc(%esp),%ebp
  2004b7:	31 c0                	xor    %eax,%eax
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  2004b9:	8b 4c 24 14          	mov    0x14(%esp),%ecx
			 && numeric && precision < 0
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
  2004bd:	2b 2c 24             	sub    (%esp),%ebp
  2004c0:	83 7c 24 08 00       	cmpl   $0x0,0x8(%esp)
  2004c5:	0f 95 c0             	setne  %al
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  2004c8:	83 e1 04             	and    $0x4,%ecx
			 && numeric && precision < 0
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
  2004cb:	29 c5                	sub    %eax,%ebp
  2004cd:	89 f0                	mov    %esi,%eax
  2004cf:	2b 6c 24 10          	sub    0x10(%esp),%ebp
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  2004d3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  2004d7:	eb 0f                	jmp    2004e8 <console_vprintf+0x301>
			cursor = console_putc(cursor, ' ', color);
  2004d9:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  2004dd:	ba 20 00 00 00       	mov    $0x20,%edx
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  2004e2:	4d                   	dec    %ebp
			cursor = console_putc(cursor, ' ', color);
  2004e3:	e8 83 fc ff ff       	call   20016b <console_putc>
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  2004e8:	85 ed                	test   %ebp,%ebp
  2004ea:	7e 07                	jle    2004f3 <console_vprintf+0x30c>
  2004ec:	83 7c 24 0c 00       	cmpl   $0x0,0xc(%esp)
  2004f1:	74 e6                	je     2004d9 <console_vprintf+0x2f2>
			cursor = console_putc(cursor, ' ', color);
		if (negative)
  2004f3:	83 7c 24 08 00       	cmpl   $0x0,0x8(%esp)
  2004f8:	89 c6                	mov    %eax,%esi
  2004fa:	74 23                	je     20051f <console_vprintf+0x338>
			cursor = console_putc(cursor, negative, color);
  2004fc:	0f b6 54 24 08       	movzbl 0x8(%esp),%edx
  200501:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  200505:	e8 61 fc ff ff       	call   20016b <console_putc>
  20050a:	89 c6                	mov    %eax,%esi
  20050c:	eb 11                	jmp    20051f <console_vprintf+0x338>
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
  20050e:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  200512:	ba 30 00 00 00       	mov    $0x30,%edx
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
  200517:	4e                   	dec    %esi
			cursor = console_putc(cursor, '0', color);
  200518:	e8 4e fc ff ff       	call   20016b <console_putc>
  20051d:	eb 06                	jmp    200525 <console_vprintf+0x33e>
  20051f:	89 f0                	mov    %esi,%eax
  200521:	8b 74 24 10          	mov    0x10(%esp),%esi
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
  200525:	85 f6                	test   %esi,%esi
  200527:	7f e5                	jg     20050e <console_vprintf+0x327>
  200529:	8b 34 24             	mov    (%esp),%esi
  20052c:	eb 15                	jmp    200543 <console_vprintf+0x35c>
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
			cursor = console_putc(cursor, *data, color);
  20052e:	8b 4c 24 04          	mov    0x4(%esp),%ecx
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
  200532:	4e                   	dec    %esi
			cursor = console_putc(cursor, *data, color);
  200533:	0f b6 11             	movzbl (%ecx),%edx
  200536:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  20053a:	e8 2c fc ff ff       	call   20016b <console_putc>
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
  20053f:	ff 44 24 04          	incl   0x4(%esp)
  200543:	85 f6                	test   %esi,%esi
  200545:	7f e7                	jg     20052e <console_vprintf+0x347>
  200547:	eb 0f                	jmp    200558 <console_vprintf+0x371>
			cursor = console_putc(cursor, *data, color);
		for (; width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
  200549:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  20054d:	ba 20 00 00 00       	mov    $0x20,%edx
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
			cursor = console_putc(cursor, *data, color);
		for (; width > 0; --width)
  200552:	4d                   	dec    %ebp
			cursor = console_putc(cursor, ' ', color);
  200553:	e8 13 fc ff ff       	call   20016b <console_putc>
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
			cursor = console_putc(cursor, *data, color);
		for (; width > 0; --width)
  200558:	85 ed                	test   %ebp,%ebp
  20055a:	7f ed                	jg     200549 <console_vprintf+0x362>
  20055c:	89 c6                	mov    %eax,%esi
	int flags, width, zeros, precision, negative, numeric, len;
#define NUMBUFSIZ 20
	char numbuf[NUMBUFSIZ];
	char *data;

	for (; *format; ++format) {
  20055e:	47                   	inc    %edi
  20055f:	8a 17                	mov    (%edi),%dl
  200561:	84 d2                	test   %dl,%dl
  200563:	0f 85 96 fc ff ff    	jne    2001ff <console_vprintf+0x18>
			cursor = console_putc(cursor, ' ', color);
	done: ;
	}

	return cursor;
}
  200569:	83 c4 38             	add    $0x38,%esp
  20056c:	89 f0                	mov    %esi,%eax
  20056e:	5b                   	pop    %ebx
  20056f:	5e                   	pop    %esi
  200570:	5f                   	pop    %edi
  200571:	5d                   	pop    %ebp
  200572:	c3                   	ret    
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
				++flagc;
			if (*flagc == '\0')
				break;
			flags |= (1 << (flagc - flag_chars));
  200573:	81 e9 cc 05 20 00    	sub    $0x2005cc,%ecx
  200579:	b8 01 00 00 00       	mov    $0x1,%eax
  20057e:	d3 e0                	shl    %cl,%eax
			continue;
		}

		// process flags
		flags = 0;
		for (++format; *format; ++format) {
  200580:	47                   	inc    %edi
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
				++flagc;
			if (*flagc == '\0')
				break;
			flags |= (1 << (flagc - flag_chars));
  200581:	09 44 24 14          	or     %eax,0x14(%esp)
  200585:	e9 aa fc ff ff       	jmp    200234 <console_vprintf+0x4d>

0020058a <console_printf>:
uint16_t *
console_printf(uint16_t *cursor, int color, const char *format, ...)
{
	va_list val;
	va_start(val, format);
	cursor = console_vprintf(cursor, color, format, val);
  20058a:	8d 44 24 10          	lea    0x10(%esp),%eax
  20058e:	50                   	push   %eax
  20058f:	ff 74 24 10          	pushl  0x10(%esp)
  200593:	ff 74 24 10          	pushl  0x10(%esp)
  200597:	ff 74 24 10          	pushl  0x10(%esp)
  20059b:	e8 47 fc ff ff       	call   2001e7 <console_vprintf>
  2005a0:	83 c4 10             	add    $0x10,%esp
	va_end(val);
	return cursor;
}
  2005a3:	c3                   	ret    
