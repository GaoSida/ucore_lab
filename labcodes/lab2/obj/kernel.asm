
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 70 11 00 	lgdtl  0x117018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba 68 89 11 c0       	mov    $0xc0118968,%edx
c0100035:	b8 36 7a 11 c0       	mov    $0xc0117a36,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 36 7a 11 c0 	movl   $0xc0117a36,(%esp)
c0100051:	e8 25 5c 00 00       	call   c0105c7b <memset>

    cons_init();                // init the console
c0100056:	e8 82 15 00 00       	call   c01015dd <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 20 5e 10 c0 	movl   $0xc0105e20,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 3c 5e 10 c0 	movl   $0xc0105e3c,(%esp)
c0100070:	e8 c7 02 00 00       	call   c010033c <cprintf>

    print_kerninfo();
c0100075:	e8 f6 07 00 00       	call   c0100870 <print_kerninfo>

    grade_backtrace();
c010007a:	e8 86 00 00 00       	call   c0100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 a7 42 00 00       	call   c010432b <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 bd 16 00 00       	call   c0101746 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 35 18 00 00       	call   c01018c3 <idt_init>

    clock_init();               // init clock interrupt
c010008e:	e8 00 0d 00 00       	call   c0100d93 <clock_init>
    intr_enable();              // enable irq interrupt
c0100093:	e8 1c 16 00 00       	call   c01016b4 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c0100098:	eb fe                	jmp    c0100098 <kern_init+0x6e>

c010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c010009a:	55                   	push   %ebp
c010009b:	89 e5                	mov    %esp,%ebp
c010009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000a7:	00 
c01000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000af:	00 
c01000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000b7:	e8 09 0c 00 00       	call   c0100cc5 <mon_backtrace>
}
c01000bc:	c9                   	leave  
c01000bd:	c3                   	ret    

c01000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000be:	55                   	push   %ebp
c01000bf:	89 e5                	mov    %esp,%ebp
c01000c1:	53                   	push   %ebx
c01000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000cb:	8d 55 08             	lea    0x8(%ebp),%edx
c01000ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000dd:	89 04 24             	mov    %eax,(%esp)
c01000e0:	e8 b5 ff ff ff       	call   c010009a <grade_backtrace2>
}
c01000e5:	83 c4 14             	add    $0x14,%esp
c01000e8:	5b                   	pop    %ebx
c01000e9:	5d                   	pop    %ebp
c01000ea:	c3                   	ret    

c01000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000eb:	55                   	push   %ebp
c01000ec:	89 e5                	mov    %esp,%ebp
c01000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01000f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01000fb:	89 04 24             	mov    %eax,(%esp)
c01000fe:	e8 bb ff ff ff       	call   c01000be <grade_backtrace1>
}
c0100103:	c9                   	leave  
c0100104:	c3                   	ret    

c0100105 <grade_backtrace>:

void
grade_backtrace(void) {
c0100105:	55                   	push   %ebp
c0100106:	89 e5                	mov    %esp,%ebp
c0100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010010b:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c0100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100117:	ff 
c0100118:	89 44 24 04          	mov    %eax,0x4(%esp)
c010011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100123:	e8 c3 ff ff ff       	call   c01000eb <grade_backtrace0>
}
c0100128:	c9                   	leave  
c0100129:	c3                   	ret    

c010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010012a:	55                   	push   %ebp
c010012b:	89 e5                	mov    %esp,%ebp
c010012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100140:	0f b7 c0             	movzwl %ax,%eax
c0100143:	83 e0 03             	and    $0x3,%eax
c0100146:	89 c2                	mov    %eax,%edx
c0100148:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010014d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100151:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100155:	c7 04 24 41 5e 10 c0 	movl   $0xc0105e41,(%esp)
c010015c:	e8 db 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100165:	0f b7 d0             	movzwl %ax,%edx
c0100168:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010016d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100171:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100175:	c7 04 24 4f 5e 10 c0 	movl   $0xc0105e4f,(%esp)
c010017c:	e8 bb 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100185:	0f b7 d0             	movzwl %ax,%edx
c0100188:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010018d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100191:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100195:	c7 04 24 5d 5e 10 c0 	movl   $0xc0105e5d,(%esp)
c010019c:	e8 9b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001a5:	0f b7 d0             	movzwl %ax,%edx
c01001a8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b5:	c7 04 24 6b 5e 10 c0 	movl   $0xc0105e6b,(%esp)
c01001bc:	e8 7b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001c5:	0f b7 d0             	movzwl %ax,%edx
c01001c8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d5:	c7 04 24 79 5e 10 c0 	movl   $0xc0105e79,(%esp)
c01001dc:	e8 5b 01 00 00       	call   c010033c <cprintf>
    round ++;
c01001e1:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001e6:	83 c0 01             	add    $0x1,%eax
c01001e9:	a3 40 7a 11 c0       	mov    %eax,0xc0117a40
}
c01001ee:	c9                   	leave  
c01001ef:	c3                   	ret    

c01001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001f0:	55                   	push   %ebp
c01001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001f3:	5d                   	pop    %ebp
c01001f4:	c3                   	ret    

c01001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001f5:	55                   	push   %ebp
c01001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001f8:	5d                   	pop    %ebp
c01001f9:	c3                   	ret    

c01001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001fa:	55                   	push   %ebp
c01001fb:	89 e5                	mov    %esp,%ebp
c01001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100200:	e8 25 ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100205:	c7 04 24 88 5e 10 c0 	movl   $0xc0105e88,(%esp)
c010020c:	e8 2b 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_user();
c0100211:	e8 da ff ff ff       	call   c01001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100216:	e8 0f ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010021b:	c7 04 24 a8 5e 10 c0 	movl   $0xc0105ea8,(%esp)
c0100222:	e8 15 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_kernel();
c0100227:	e8 c9 ff ff ff       	call   c01001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010022c:	e8 f9 fe ff ff       	call   c010012a <lab1_print_cur_status>
}
c0100231:	c9                   	leave  
c0100232:	c3                   	ret    

c0100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100233:	55                   	push   %ebp
c0100234:	89 e5                	mov    %esp,%ebp
c0100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010023d:	74 13                	je     c0100252 <readline+0x1f>
        cprintf("%s", prompt);
c010023f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100242:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100246:	c7 04 24 c7 5e 10 c0 	movl   $0xc0105ec7,(%esp)
c010024d:	e8 ea 00 00 00       	call   c010033c <cprintf>
    }
    int i = 0, c;
c0100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100259:	e8 66 01 00 00       	call   c01003c4 <getchar>
c010025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100265:	79 07                	jns    c010026e <readline+0x3b>
            return NULL;
c0100267:	b8 00 00 00 00       	mov    $0x0,%eax
c010026c:	eb 79                	jmp    c01002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100272:	7e 28                	jle    c010029c <readline+0x69>
c0100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010027b:	7f 1f                	jg     c010029c <readline+0x69>
            cputchar(c);
c010027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100280:	89 04 24             	mov    %eax,(%esp)
c0100283:	e8 da 00 00 00       	call   c0100362 <cputchar>
            buf[i ++] = c;
c0100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010028b:	8d 50 01             	lea    0x1(%eax),%edx
c010028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100294:	88 90 60 7a 11 c0    	mov    %dl,-0x3fee85a0(%eax)
c010029a:	eb 46                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c010029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002a0:	75 17                	jne    c01002b9 <readline+0x86>
c01002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002a6:	7e 11                	jle    c01002b9 <readline+0x86>
            cputchar(c);
c01002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ab:	89 04 24             	mov    %eax,(%esp)
c01002ae:	e8 af 00 00 00       	call   c0100362 <cputchar>
            i --;
c01002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002b7:	eb 29                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002bd:	74 06                	je     c01002c5 <readline+0x92>
c01002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002c3:	75 1d                	jne    c01002e2 <readline+0xaf>
            cputchar(c);
c01002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002c8:	89 04 24             	mov    %eax,(%esp)
c01002cb:	e8 92 00 00 00       	call   c0100362 <cputchar>
            buf[i] = '\0';
c01002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002d3:	05 60 7a 11 c0       	add    $0xc0117a60,%eax
c01002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002db:	b8 60 7a 11 c0       	mov    $0xc0117a60,%eax
c01002e0:	eb 05                	jmp    c01002e7 <readline+0xb4>
        }
    }
c01002e2:	e9 72 ff ff ff       	jmp    c0100259 <readline+0x26>
}
c01002e7:	c9                   	leave  
c01002e8:	c3                   	ret    

c01002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002e9:	55                   	push   %ebp
c01002ea:	89 e5                	mov    %esp,%ebp
c01002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01002f2:	89 04 24             	mov    %eax,(%esp)
c01002f5:	e8 0f 13 00 00       	call   c0101609 <cons_putc>
    (*cnt) ++;
c01002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01002fd:	8b 00                	mov    (%eax),%eax
c01002ff:	8d 50 01             	lea    0x1(%eax),%edx
c0100302:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100305:	89 10                	mov    %edx,(%eax)
}
c0100307:	c9                   	leave  
c0100308:	c3                   	ret    

c0100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100309:	55                   	push   %ebp
c010030a:	89 e5                	mov    %esp,%ebp
c010030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100316:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010031d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100320:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100327:	89 44 24 04          	mov    %eax,0x4(%esp)
c010032b:	c7 04 24 e9 02 10 c0 	movl   $0xc01002e9,(%esp)
c0100332:	e8 5d 51 00 00       	call   c0105494 <vprintfmt>
    return cnt;
c0100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010033a:	c9                   	leave  
c010033b:	c3                   	ret    

c010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010033c:	55                   	push   %ebp
c010033d:	89 e5                	mov    %esp,%ebp
c010033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100342:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010034b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010034f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100352:	89 04 24             	mov    %eax,(%esp)
c0100355:	e8 af ff ff ff       	call   c0100309 <vcprintf>
c010035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100360:	c9                   	leave  
c0100361:	c3                   	ret    

c0100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100362:	55                   	push   %ebp
c0100363:	89 e5                	mov    %esp,%ebp
c0100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100368:	8b 45 08             	mov    0x8(%ebp),%eax
c010036b:	89 04 24             	mov    %eax,(%esp)
c010036e:	e8 96 12 00 00       	call   c0101609 <cons_putc>
}
c0100373:	c9                   	leave  
c0100374:	c3                   	ret    

c0100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100375:	55                   	push   %ebp
c0100376:	89 e5                	mov    %esp,%ebp
c0100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100382:	eb 13                	jmp    c0100397 <cputs+0x22>
        cputch(c, &cnt);
c0100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
c010038b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010038f:	89 04 24             	mov    %eax,(%esp)
c0100392:	e8 52 ff ff ff       	call   c01002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c0100397:	8b 45 08             	mov    0x8(%ebp),%eax
c010039a:	8d 50 01             	lea    0x1(%eax),%edx
c010039d:	89 55 08             	mov    %edx,0x8(%ebp)
c01003a0:	0f b6 00             	movzbl (%eax),%eax
c01003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003aa:	75 d8                	jne    c0100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003ba:	e8 2a ff ff ff       	call   c01002e9 <cputch>
    return cnt;
c01003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003c2:	c9                   	leave  
c01003c3:	c3                   	ret    

c01003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003c4:	55                   	push   %ebp
c01003c5:	89 e5                	mov    %esp,%ebp
c01003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003ca:	e8 76 12 00 00       	call   c0101645 <cons_getc>
c01003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003d6:	74 f2                	je     c01003ca <getchar+0x6>
        /* do nothing */;
    return c;
c01003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003db:	c9                   	leave  
c01003dc:	c3                   	ret    

c01003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003dd:	55                   	push   %ebp
c01003de:	89 e5                	mov    %esp,%ebp
c01003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003e6:	8b 00                	mov    (%eax),%eax
c01003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01003ee:	8b 00                	mov    (%eax),%eax
c01003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01003fa:	e9 d2 00 00 00       	jmp    c01004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100405:	01 d0                	add    %edx,%eax
c0100407:	89 c2                	mov    %eax,%edx
c0100409:	c1 ea 1f             	shr    $0x1f,%edx
c010040c:	01 d0                	add    %edx,%eax
c010040e:	d1 f8                	sar    %eax
c0100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100419:	eb 04                	jmp    c010041f <stab_binsearch+0x42>
            m --;
c010041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100425:	7c 1f                	jl     c0100446 <stab_binsearch+0x69>
c0100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010042a:	89 d0                	mov    %edx,%eax
c010042c:	01 c0                	add    %eax,%eax
c010042e:	01 d0                	add    %edx,%eax
c0100430:	c1 e0 02             	shl    $0x2,%eax
c0100433:	89 c2                	mov    %eax,%edx
c0100435:	8b 45 08             	mov    0x8(%ebp),%eax
c0100438:	01 d0                	add    %edx,%eax
c010043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010043e:	0f b6 c0             	movzbl %al,%eax
c0100441:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100444:	75 d5                	jne    c010041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010044c:	7d 0b                	jge    c0100459 <stab_binsearch+0x7c>
            l = true_m + 1;
c010044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100451:	83 c0 01             	add    $0x1,%eax
c0100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100457:	eb 78                	jmp    c01004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100463:	89 d0                	mov    %edx,%eax
c0100465:	01 c0                	add    %eax,%eax
c0100467:	01 d0                	add    %edx,%eax
c0100469:	c1 e0 02             	shl    $0x2,%eax
c010046c:	89 c2                	mov    %eax,%edx
c010046e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100471:	01 d0                	add    %edx,%eax
c0100473:	8b 40 08             	mov    0x8(%eax),%eax
c0100476:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100479:	73 13                	jae    c010048e <stab_binsearch+0xb1>
            *region_left = m;
c010047b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100486:	83 c0 01             	add    $0x1,%eax
c0100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010048c:	eb 43                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100491:	89 d0                	mov    %edx,%eax
c0100493:	01 c0                	add    %eax,%eax
c0100495:	01 d0                	add    %edx,%eax
c0100497:	c1 e0 02             	shl    $0x2,%eax
c010049a:	89 c2                	mov    %eax,%edx
c010049c:	8b 45 08             	mov    0x8(%ebp),%eax
c010049f:	01 d0                	add    %edx,%eax
c01004a1:	8b 40 08             	mov    0x8(%eax),%eax
c01004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004a7:	76 16                	jbe    c01004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004af:	8b 45 10             	mov    0x10(%ebp),%eax
c01004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004b7:	83 e8 01             	sub    $0x1,%eax
c01004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004bd:	eb 12                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004c5:	89 10                	mov    %edx,(%eax)
            l = m;
c01004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004d7:	0f 8e 22 ff ff ff    	jle    c01003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004e1:	75 0f                	jne    c01004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004e6:	8b 00                	mov    (%eax),%eax
c01004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01004ee:	89 10                	mov    %edx,(%eax)
c01004f0:	eb 3f                	jmp    c0100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01004f2:	8b 45 10             	mov    0x10(%ebp),%eax
c01004f5:	8b 00                	mov    (%eax),%eax
c01004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01004fa:	eb 04                	jmp    c0100500 <stab_binsearch+0x123>
c01004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c0100500:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100503:	8b 00                	mov    (%eax),%eax
c0100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100508:	7d 1f                	jge    c0100529 <stab_binsearch+0x14c>
c010050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010050d:	89 d0                	mov    %edx,%eax
c010050f:	01 c0                	add    %eax,%eax
c0100511:	01 d0                	add    %edx,%eax
c0100513:	c1 e0 02             	shl    $0x2,%eax
c0100516:	89 c2                	mov    %eax,%edx
c0100518:	8b 45 08             	mov    0x8(%ebp),%eax
c010051b:	01 d0                	add    %edx,%eax
c010051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100521:	0f b6 c0             	movzbl %al,%eax
c0100524:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100527:	75 d3                	jne    c01004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100529:	8b 45 0c             	mov    0xc(%ebp),%eax
c010052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010052f:	89 10                	mov    %edx,(%eax)
    }
}
c0100531:	c9                   	leave  
c0100532:	c3                   	ret    

c0100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100533:	55                   	push   %ebp
c0100534:	89 e5                	mov    %esp,%ebp
c0100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100539:	8b 45 0c             	mov    0xc(%ebp),%eax
c010053c:	c7 00 cc 5e 10 c0    	movl   $0xc0105ecc,(%eax)
    info->eip_line = 0;
c0100542:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010054c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054f:	c7 40 08 cc 5e 10 c0 	movl   $0xc0105ecc,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100556:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100560:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100563:	8b 55 08             	mov    0x8(%ebp),%edx
c0100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100569:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100573:	c7 45 f4 20 71 10 c0 	movl   $0xc0107120,-0xc(%ebp)
    stab_end = __STAB_END__;
c010057a:	c7 45 f0 18 1b 11 c0 	movl   $0xc0111b18,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100581:	c7 45 ec 19 1b 11 c0 	movl   $0xc0111b19,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100588:	c7 45 e8 7b 45 11 c0 	movl   $0xc011457b,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100595:	76 0d                	jbe    c01005a4 <debuginfo_eip+0x71>
c0100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010059a:	83 e8 01             	sub    $0x1,%eax
c010059d:	0f b6 00             	movzbl (%eax),%eax
c01005a0:	84 c0                	test   %al,%al
c01005a2:	74 0a                	je     c01005ae <debuginfo_eip+0x7b>
        return -1;
c01005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005a9:	e9 c0 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005bb:	29 c2                	sub    %eax,%edx
c01005bd:	89 d0                	mov    %edx,%eax
c01005bf:	c1 f8 02             	sar    $0x2,%eax
c01005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005c8:	83 e8 01             	sub    $0x1,%eax
c01005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005dc:	00 
c01005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005ee:	89 04 24             	mov    %eax,(%esp)
c01005f1:	e8 e7 fd ff ff       	call   c01003dd <stab_binsearch>
    if (lfile == 0)
c01005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005f9:	85 c0                	test   %eax,%eax
c01005fb:	75 0a                	jne    c0100607 <debuginfo_eip+0xd4>
        return -1;
c01005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100602:	e9 67 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100613:	8b 45 08             	mov    0x8(%ebp),%eax
c0100616:	89 44 24 10          	mov    %eax,0x10(%esp)
c010061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100621:	00 
c0100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100625:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010062c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100633:	89 04 24             	mov    %eax,(%esp)
c0100636:	e8 a2 fd ff ff       	call   c01003dd <stab_binsearch>

    if (lfun <= rfun) {
c010063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100641:	39 c2                	cmp    %eax,%edx
c0100643:	7f 7c                	jg     c01006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100648:	89 c2                	mov    %eax,%edx
c010064a:	89 d0                	mov    %edx,%eax
c010064c:	01 c0                	add    %eax,%eax
c010064e:	01 d0                	add    %edx,%eax
c0100650:	c1 e0 02             	shl    $0x2,%eax
c0100653:	89 c2                	mov    %eax,%edx
c0100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100658:	01 d0                	add    %edx,%eax
c010065a:	8b 10                	mov    (%eax),%edx
c010065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100662:	29 c1                	sub    %eax,%ecx
c0100664:	89 c8                	mov    %ecx,%eax
c0100666:	39 c2                	cmp    %eax,%edx
c0100668:	73 22                	jae    c010068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010066d:	89 c2                	mov    %eax,%edx
c010066f:	89 d0                	mov    %edx,%eax
c0100671:	01 c0                	add    %eax,%eax
c0100673:	01 d0                	add    %edx,%eax
c0100675:	c1 e0 02             	shl    $0x2,%eax
c0100678:	89 c2                	mov    %eax,%edx
c010067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010067d:	01 d0                	add    %edx,%eax
c010067f:	8b 10                	mov    (%eax),%edx
c0100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100684:	01 c2                	add    %eax,%edx
c0100686:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010068f:	89 c2                	mov    %eax,%edx
c0100691:	89 d0                	mov    %edx,%eax
c0100693:	01 c0                	add    %eax,%eax
c0100695:	01 d0                	add    %edx,%eax
c0100697:	c1 e0 02             	shl    $0x2,%eax
c010069a:	89 c2                	mov    %eax,%edx
c010069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010069f:	01 d0                	add    %edx,%eax
c01006a1:	8b 50 08             	mov    0x8(%eax),%edx
c01006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006ad:	8b 40 10             	mov    0x10(%eax),%eax
c01006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006bf:	eb 15                	jmp    c01006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c4:	8b 55 08             	mov    0x8(%ebp),%edx
c01006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d9:	8b 40 08             	mov    0x8(%eax),%eax
c01006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006e3:	00 
c01006e4:	89 04 24             	mov    %eax,(%esp)
c01006e7:	e8 03 54 00 00       	call   c0105aef <strfind>
c01006ec:	89 c2                	mov    %eax,%edx
c01006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f1:	8b 40 08             	mov    0x8(%eax),%eax
c01006f4:	29 c2                	sub    %eax,%edx
c01006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01006fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c010070a:	00 
c010070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010070e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100715:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010071c:	89 04 24             	mov    %eax,(%esp)
c010071f:	e8 b9 fc ff ff       	call   c01003dd <stab_binsearch>
    if (lline <= rline) {
c0100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010072a:	39 c2                	cmp    %eax,%edx
c010072c:	7f 24                	jg     c0100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100731:	89 c2                	mov    %eax,%edx
c0100733:	89 d0                	mov    %edx,%eax
c0100735:	01 c0                	add    %eax,%eax
c0100737:	01 d0                	add    %edx,%eax
c0100739:	c1 e0 02             	shl    $0x2,%eax
c010073c:	89 c2                	mov    %eax,%edx
c010073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100741:	01 d0                	add    %edx,%eax
c0100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100747:	0f b7 d0             	movzwl %ax,%edx
c010074a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100750:	eb 13                	jmp    c0100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100757:	e9 12 01 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010075f:	83 e8 01             	sub    $0x1,%eax
c0100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010076b:	39 c2                	cmp    %eax,%edx
c010076d:	7c 56                	jl     c01007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100772:	89 c2                	mov    %eax,%edx
c0100774:	89 d0                	mov    %edx,%eax
c0100776:	01 c0                	add    %eax,%eax
c0100778:	01 d0                	add    %edx,%eax
c010077a:	c1 e0 02             	shl    $0x2,%eax
c010077d:	89 c2                	mov    %eax,%edx
c010077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100782:	01 d0                	add    %edx,%eax
c0100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100788:	3c 84                	cmp    $0x84,%al
c010078a:	74 39                	je     c01007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010078f:	89 c2                	mov    %eax,%edx
c0100791:	89 d0                	mov    %edx,%eax
c0100793:	01 c0                	add    %eax,%eax
c0100795:	01 d0                	add    %edx,%eax
c0100797:	c1 e0 02             	shl    $0x2,%eax
c010079a:	89 c2                	mov    %eax,%edx
c010079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010079f:	01 d0                	add    %edx,%eax
c01007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007a5:	3c 64                	cmp    $0x64,%al
c01007a7:	75 b3                	jne    c010075c <debuginfo_eip+0x229>
c01007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007ac:	89 c2                	mov    %eax,%edx
c01007ae:	89 d0                	mov    %edx,%eax
c01007b0:	01 c0                	add    %eax,%eax
c01007b2:	01 d0                	add    %edx,%eax
c01007b4:	c1 e0 02             	shl    $0x2,%eax
c01007b7:	89 c2                	mov    %eax,%edx
c01007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007bc:	01 d0                	add    %edx,%eax
c01007be:	8b 40 08             	mov    0x8(%eax),%eax
c01007c1:	85 c0                	test   %eax,%eax
c01007c3:	74 97                	je     c010075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007cb:	39 c2                	cmp    %eax,%edx
c01007cd:	7c 46                	jl     c0100815 <debuginfo_eip+0x2e2>
c01007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007d2:	89 c2                	mov    %eax,%edx
c01007d4:	89 d0                	mov    %edx,%eax
c01007d6:	01 c0                	add    %eax,%eax
c01007d8:	01 d0                	add    %edx,%eax
c01007da:	c1 e0 02             	shl    $0x2,%eax
c01007dd:	89 c2                	mov    %eax,%edx
c01007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007e2:	01 d0                	add    %edx,%eax
c01007e4:	8b 10                	mov    (%eax),%edx
c01007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007ec:	29 c1                	sub    %eax,%ecx
c01007ee:	89 c8                	mov    %ecx,%eax
c01007f0:	39 c2                	cmp    %eax,%edx
c01007f2:	73 21                	jae    c0100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007f7:	89 c2                	mov    %eax,%edx
c01007f9:	89 d0                	mov    %edx,%eax
c01007fb:	01 c0                	add    %eax,%eax
c01007fd:	01 d0                	add    %edx,%eax
c01007ff:	c1 e0 02             	shl    $0x2,%eax
c0100802:	89 c2                	mov    %eax,%edx
c0100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100807:	01 d0                	add    %edx,%eax
c0100809:	8b 10                	mov    (%eax),%edx
c010080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010080e:	01 c2                	add    %eax,%edx
c0100810:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010081b:	39 c2                	cmp    %eax,%edx
c010081d:	7d 4a                	jge    c0100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100822:	83 c0 01             	add    $0x1,%eax
c0100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100828:	eb 18                	jmp    c0100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c010082a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010082d:	8b 40 14             	mov    0x14(%eax),%eax
c0100830:	8d 50 01             	lea    0x1(%eax),%edx
c0100833:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010083c:	83 c0 01             	add    $0x1,%eax
c010083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100848:	39 c2                	cmp    %eax,%edx
c010084a:	7d 1d                	jge    c0100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084f:	89 c2                	mov    %eax,%edx
c0100851:	89 d0                	mov    %edx,%eax
c0100853:	01 c0                	add    %eax,%eax
c0100855:	01 d0                	add    %edx,%eax
c0100857:	c1 e0 02             	shl    $0x2,%eax
c010085a:	89 c2                	mov    %eax,%edx
c010085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010085f:	01 d0                	add    %edx,%eax
c0100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100865:	3c a0                	cmp    $0xa0,%al
c0100867:	74 c1                	je     c010082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010086e:	c9                   	leave  
c010086f:	c3                   	ret    

c0100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100870:	55                   	push   %ebp
c0100871:	89 e5                	mov    %esp,%ebp
c0100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100876:	c7 04 24 d6 5e 10 c0 	movl   $0xc0105ed6,(%esp)
c010087d:	e8 ba fa ff ff       	call   c010033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100882:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100889:	c0 
c010088a:	c7 04 24 ef 5e 10 c0 	movl   $0xc0105eef,(%esp)
c0100891:	e8 a6 fa ff ff       	call   c010033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100896:	c7 44 24 04 04 5e 10 	movl   $0xc0105e04,0x4(%esp)
c010089d:	c0 
c010089e:	c7 04 24 07 5f 10 c0 	movl   $0xc0105f07,(%esp)
c01008a5:	e8 92 fa ff ff       	call   c010033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008aa:	c7 44 24 04 36 7a 11 	movl   $0xc0117a36,0x4(%esp)
c01008b1:	c0 
c01008b2:	c7 04 24 1f 5f 10 c0 	movl   $0xc0105f1f,(%esp)
c01008b9:	e8 7e fa ff ff       	call   c010033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008be:	c7 44 24 04 68 89 11 	movl   $0xc0118968,0x4(%esp)
c01008c5:	c0 
c01008c6:	c7 04 24 37 5f 10 c0 	movl   $0xc0105f37,(%esp)
c01008cd:	e8 6a fa ff ff       	call   c010033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008d2:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c01008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008dd:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008e2:	29 c2                	sub    %eax,%edx
c01008e4:	89 d0                	mov    %edx,%eax
c01008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ec:	85 c0                	test   %eax,%eax
c01008ee:	0f 48 c2             	cmovs  %edx,%eax
c01008f1:	c1 f8 0a             	sar    $0xa,%eax
c01008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01008f8:	c7 04 24 50 5f 10 c0 	movl   $0xc0105f50,(%esp)
c01008ff:	e8 38 fa ff ff       	call   c010033c <cprintf>
}
c0100904:	c9                   	leave  
c0100905:	c3                   	ret    

c0100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100906:	55                   	push   %ebp
c0100907:	89 e5                	mov    %esp,%ebp
c0100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100912:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100916:	8b 45 08             	mov    0x8(%ebp),%eax
c0100919:	89 04 24             	mov    %eax,(%esp)
c010091c:	e8 12 fc ff ff       	call   c0100533 <debuginfo_eip>
c0100921:	85 c0                	test   %eax,%eax
c0100923:	74 15                	je     c010093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100925:	8b 45 08             	mov    0x8(%ebp),%eax
c0100928:	89 44 24 04          	mov    %eax,0x4(%esp)
c010092c:	c7 04 24 7a 5f 10 c0 	movl   $0xc0105f7a,(%esp)
c0100933:	e8 04 fa ff ff       	call   c010033c <cprintf>
c0100938:	eb 6d                	jmp    c01009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100941:	eb 1c                	jmp    c010095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100949:	01 d0                	add    %edx,%eax
c010094b:	0f b6 00             	movzbl (%eax),%eax
c010094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100957:	01 ca                	add    %ecx,%edx
c0100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100965:	7f dc                	jg     c0100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c010096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100970:	01 d0                	add    %edx,%eax
c0100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100978:	8b 55 08             	mov    0x8(%ebp),%edx
c010097b:	89 d1                	mov    %edx,%ecx
c010097d:	29 c1                	sub    %eax,%ecx
c010097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100993:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100997:	89 44 24 04          	mov    %eax,0x4(%esp)
c010099b:	c7 04 24 96 5f 10 c0 	movl   $0xc0105f96,(%esp)
c01009a2:	e8 95 f9 ff ff       	call   c010033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009a7:	c9                   	leave  
c01009a8:	c3                   	ret    

c01009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009a9:	55                   	push   %ebp
c01009aa:	89 e5                	mov    %esp,%ebp
c01009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009af:	8b 45 04             	mov    0x4(%ebp),%eax
c01009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009b8:	c9                   	leave  
c01009b9:	c3                   	ret    

c01009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009ba:	55                   	push   %ebp
c01009bb:	89 e5                	mov    %esp,%ebp
c01009bd:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009c0:	89 e8                	mov    %ebp,%eax
c01009c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c01009c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	// My Code Starts
	uint32_t current_ebp = read_ebp();
c01009c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t current_eip = read_eip();
c01009cb:	e8 d9 ff ff ff       	call   c01009a9 <read_eip>
c01009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	
	int i;    //  ‘for’ loop initial declarations are not allowed here
	for (i = 0; i < STACKFRAME_DEPTH; i++) {
c01009d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009da:	e9 9f 00 00 00       	jmp    c0100a7e <print_stackframe+0xc4>
		if (current_ebp == 0) {
c01009df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01009e3:	75 05                	jne    c01009ea <print_stackframe+0x30>
			break;
c01009e5:	e9 9e 00 00 00       	jmp    c0100a88 <print_stackframe+0xce>
		}

		cprintf("ebp:0x%08x eip:0x%08x ", current_ebp, current_eip);
c01009ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009ed:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009f8:	c7 04 24 a8 5f 10 c0 	movl   $0xc0105fa8,(%esp)
c01009ff:	e8 38 f9 ff ff       	call   c010033c <cprintf>
		// Cannot use printf, since we're writing a kernel, not an app!
	    
		cprintf("args:");
c0100a04:	c7 04 24 bf 5f 10 c0 	movl   $0xc0105fbf,(%esp)
c0100a0b:	e8 2c f9 ff ff       	call   c010033c <cprintf>
		uint32_t *argbase = (uint32_t*)current_ebp + 2;       
c0100a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a13:	83 c0 08             	add    $0x8,%eax
c0100a16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// the first argument is 2 words away, return_address standing in between
		int j;
		for (j = 0; j < 4; j++) {
c0100a19:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a20:	eb 25                	jmp    c0100a47 <print_stackframe+0x8d>
			cprintf("0x%08x ", argbase[j]);
c0100a22:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a25:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a2f:	01 d0                	add    %edx,%eax
c0100a31:	8b 00                	mov    (%eax),%eax
c0100a33:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a37:	c7 04 24 c5 5f 10 c0 	movl   $0xc0105fc5,(%esp)
c0100a3e:	e8 f9 f8 ff ff       	call   c010033c <cprintf>
	    
		cprintf("args:");
		uint32_t *argbase = (uint32_t*)current_ebp + 2;       
		// the first argument is 2 words away, return_address standing in between
		int j;
		for (j = 0; j < 4; j++) {
c0100a43:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a47:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a4b:	7e d5                	jle    c0100a22 <print_stackframe+0x68>
			cprintf("0x%08x ", argbase[j]);
		}
		cprintf("\n");
c0100a4d:	c7 04 24 cd 5f 10 c0 	movl   $0xc0105fcd,(%esp)
c0100a54:	e8 e3 f8 ff ff       	call   c010033c <cprintf>
		print_debuginfo(current_eip - 1);     // eip points to next instruction
c0100a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a5c:	83 e8 01             	sub    $0x1,%eax
c0100a5f:	89 04 24             	mov    %eax,(%esp)
c0100a62:	e8 9f fe ff ff       	call   c0100906 <print_debuginfo>
		
		// moving to next frame on the stack
		current_eip = *((uint32_t*)current_ebp + 1);    // return address
c0100a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a6a:	83 c0 04             	add    $0x4,%eax
c0100a6d:	8b 00                	mov    (%eax),%eax
c0100a6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		current_ebp = *((uint32_t*)current_ebp);      // ebp of last frame
c0100a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a75:	8b 00                	mov    (%eax),%eax
c0100a77:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// My Code Starts
	uint32_t current_ebp = read_ebp();
	uint32_t current_eip = read_eip();
	
	int i;    //  ‘for’ loop initial declarations are not allowed here
	for (i = 0; i < STACKFRAME_DEPTH; i++) {
c0100a7a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a7e:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a82:	0f 8e 57 ff ff ff    	jle    c01009df <print_stackframe+0x25>
		// moving to next frame on the stack
		current_eip = *((uint32_t*)current_ebp + 1);    // return address
		current_ebp = *((uint32_t*)current_ebp);      // ebp of last frame
	}
	// My Code Ends
}
c0100a88:	c9                   	leave  
c0100a89:	c3                   	ret    

c0100a8a <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a8a:	55                   	push   %ebp
c0100a8b:	89 e5                	mov    %esp,%ebp
c0100a8d:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a97:	eb 0c                	jmp    c0100aa5 <parse+0x1b>
            *buf ++ = '\0';
c0100a99:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a9c:	8d 50 01             	lea    0x1(%eax),%edx
c0100a9f:	89 55 08             	mov    %edx,0x8(%ebp)
c0100aa2:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100aa5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa8:	0f b6 00             	movzbl (%eax),%eax
c0100aab:	84 c0                	test   %al,%al
c0100aad:	74 1d                	je     c0100acc <parse+0x42>
c0100aaf:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ab2:	0f b6 00             	movzbl (%eax),%eax
c0100ab5:	0f be c0             	movsbl %al,%eax
c0100ab8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100abc:	c7 04 24 50 60 10 c0 	movl   $0xc0106050,(%esp)
c0100ac3:	e8 f4 4f 00 00       	call   c0105abc <strchr>
c0100ac8:	85 c0                	test   %eax,%eax
c0100aca:	75 cd                	jne    c0100a99 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100acc:	8b 45 08             	mov    0x8(%ebp),%eax
c0100acf:	0f b6 00             	movzbl (%eax),%eax
c0100ad2:	84 c0                	test   %al,%al
c0100ad4:	75 02                	jne    c0100ad8 <parse+0x4e>
            break;
c0100ad6:	eb 67                	jmp    c0100b3f <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ad8:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100adc:	75 14                	jne    c0100af2 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ade:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100ae5:	00 
c0100ae6:	c7 04 24 55 60 10 c0 	movl   $0xc0106055,(%esp)
c0100aed:	e8 4a f8 ff ff       	call   c010033c <cprintf>
        }
        argv[argc ++] = buf;
c0100af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100af5:	8d 50 01             	lea    0x1(%eax),%edx
c0100af8:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100afb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b02:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b05:	01 c2                	add    %eax,%edx
c0100b07:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b0a:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b0c:	eb 04                	jmp    c0100b12 <parse+0x88>
            buf ++;
c0100b0e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b12:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b15:	0f b6 00             	movzbl (%eax),%eax
c0100b18:	84 c0                	test   %al,%al
c0100b1a:	74 1d                	je     c0100b39 <parse+0xaf>
c0100b1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b1f:	0f b6 00             	movzbl (%eax),%eax
c0100b22:	0f be c0             	movsbl %al,%eax
c0100b25:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b29:	c7 04 24 50 60 10 c0 	movl   $0xc0106050,(%esp)
c0100b30:	e8 87 4f 00 00       	call   c0105abc <strchr>
c0100b35:	85 c0                	test   %eax,%eax
c0100b37:	74 d5                	je     c0100b0e <parse+0x84>
            buf ++;
        }
    }
c0100b39:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b3a:	e9 66 ff ff ff       	jmp    c0100aa5 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b42:	c9                   	leave  
c0100b43:	c3                   	ret    

c0100b44 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b44:	55                   	push   %ebp
c0100b45:	89 e5                	mov    %esp,%ebp
c0100b47:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b4a:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b4d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b51:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b54:	89 04 24             	mov    %eax,(%esp)
c0100b57:	e8 2e ff ff ff       	call   c0100a8a <parse>
c0100b5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b5f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b63:	75 0a                	jne    c0100b6f <runcmd+0x2b>
        return 0;
c0100b65:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b6a:	e9 85 00 00 00       	jmp    c0100bf4 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b6f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b76:	eb 5c                	jmp    c0100bd4 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b78:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b7e:	89 d0                	mov    %edx,%eax
c0100b80:	01 c0                	add    %eax,%eax
c0100b82:	01 d0                	add    %edx,%eax
c0100b84:	c1 e0 02             	shl    $0x2,%eax
c0100b87:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100b8c:	8b 00                	mov    (%eax),%eax
c0100b8e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b92:	89 04 24             	mov    %eax,(%esp)
c0100b95:	e8 83 4e 00 00       	call   c0105a1d <strcmp>
c0100b9a:	85 c0                	test   %eax,%eax
c0100b9c:	75 32                	jne    c0100bd0 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100ba1:	89 d0                	mov    %edx,%eax
c0100ba3:	01 c0                	add    %eax,%eax
c0100ba5:	01 d0                	add    %edx,%eax
c0100ba7:	c1 e0 02             	shl    $0x2,%eax
c0100baa:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100baf:	8b 40 08             	mov    0x8(%eax),%eax
c0100bb2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100bb5:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100bb8:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100bbb:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bbf:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bc2:	83 c2 04             	add    $0x4,%edx
c0100bc5:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bc9:	89 0c 24             	mov    %ecx,(%esp)
c0100bcc:	ff d0                	call   *%eax
c0100bce:	eb 24                	jmp    c0100bf4 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bd0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bd7:	83 f8 02             	cmp    $0x2,%eax
c0100bda:	76 9c                	jbe    c0100b78 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bdc:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bdf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100be3:	c7 04 24 73 60 10 c0 	movl   $0xc0106073,(%esp)
c0100bea:	e8 4d f7 ff ff       	call   c010033c <cprintf>
    return 0;
c0100bef:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bf4:	c9                   	leave  
c0100bf5:	c3                   	ret    

c0100bf6 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bf6:	55                   	push   %ebp
c0100bf7:	89 e5                	mov    %esp,%ebp
c0100bf9:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100bfc:	c7 04 24 8c 60 10 c0 	movl   $0xc010608c,(%esp)
c0100c03:	e8 34 f7 ff ff       	call   c010033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c08:	c7 04 24 b4 60 10 c0 	movl   $0xc01060b4,(%esp)
c0100c0f:	e8 28 f7 ff ff       	call   c010033c <cprintf>

    if (tf != NULL) {
c0100c14:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c18:	74 0b                	je     c0100c25 <kmonitor+0x2f>
        print_trapframe(tf);
c0100c1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c1d:	89 04 24             	mov    %eax,(%esp)
c0100c20:	e8 52 0e 00 00       	call   c0101a77 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c25:	c7 04 24 d9 60 10 c0 	movl   $0xc01060d9,(%esp)
c0100c2c:	e8 02 f6 ff ff       	call   c0100233 <readline>
c0100c31:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c38:	74 18                	je     c0100c52 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c3d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c44:	89 04 24             	mov    %eax,(%esp)
c0100c47:	e8 f8 fe ff ff       	call   c0100b44 <runcmd>
c0100c4c:	85 c0                	test   %eax,%eax
c0100c4e:	79 02                	jns    c0100c52 <kmonitor+0x5c>
                break;
c0100c50:	eb 02                	jmp    c0100c54 <kmonitor+0x5e>
            }
        }
    }
c0100c52:	eb d1                	jmp    c0100c25 <kmonitor+0x2f>
}
c0100c54:	c9                   	leave  
c0100c55:	c3                   	ret    

c0100c56 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c56:	55                   	push   %ebp
c0100c57:	89 e5                	mov    %esp,%ebp
c0100c59:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c5c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c63:	eb 3f                	jmp    c0100ca4 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c65:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c68:	89 d0                	mov    %edx,%eax
c0100c6a:	01 c0                	add    %eax,%eax
c0100c6c:	01 d0                	add    %edx,%eax
c0100c6e:	c1 e0 02             	shl    $0x2,%eax
c0100c71:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c76:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c79:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c7c:	89 d0                	mov    %edx,%eax
c0100c7e:	01 c0                	add    %eax,%eax
c0100c80:	01 d0                	add    %edx,%eax
c0100c82:	c1 e0 02             	shl    $0x2,%eax
c0100c85:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c8a:	8b 00                	mov    (%eax),%eax
c0100c8c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c90:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c94:	c7 04 24 dd 60 10 c0 	movl   $0xc01060dd,(%esp)
c0100c9b:	e8 9c f6 ff ff       	call   c010033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100ca0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ca7:	83 f8 02             	cmp    $0x2,%eax
c0100caa:	76 b9                	jbe    c0100c65 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100cac:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cb1:	c9                   	leave  
c0100cb2:	c3                   	ret    

c0100cb3 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100cb3:	55                   	push   %ebp
c0100cb4:	89 e5                	mov    %esp,%ebp
c0100cb6:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cb9:	e8 b2 fb ff ff       	call   c0100870 <print_kerninfo>
    return 0;
c0100cbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cc3:	c9                   	leave  
c0100cc4:	c3                   	ret    

c0100cc5 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cc5:	55                   	push   %ebp
c0100cc6:	89 e5                	mov    %esp,%ebp
c0100cc8:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100ccb:	e8 ea fc ff ff       	call   c01009ba <print_stackframe>
    return 0;
c0100cd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cd5:	c9                   	leave  
c0100cd6:	c3                   	ret    

c0100cd7 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cd7:	55                   	push   %ebp
c0100cd8:	89 e5                	mov    %esp,%ebp
c0100cda:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100cdd:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
c0100ce2:	85 c0                	test   %eax,%eax
c0100ce4:	74 02                	je     c0100ce8 <__panic+0x11>
        goto panic_dead;
c0100ce6:	eb 48                	jmp    c0100d30 <__panic+0x59>
    }
    is_panic = 1;
c0100ce8:	c7 05 60 7e 11 c0 01 	movl   $0x1,0xc0117e60
c0100cef:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100cf2:	8d 45 14             	lea    0x14(%ebp),%eax
c0100cf5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100cf8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100cfb:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100cff:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d02:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d06:	c7 04 24 e6 60 10 c0 	movl   $0xc01060e6,(%esp)
c0100d0d:	e8 2a f6 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d15:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d19:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d1c:	89 04 24             	mov    %eax,(%esp)
c0100d1f:	e8 e5 f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d24:	c7 04 24 02 61 10 c0 	movl   $0xc0106102,(%esp)
c0100d2b:	e8 0c f6 ff ff       	call   c010033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d30:	e8 85 09 00 00       	call   c01016ba <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d35:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d3c:	e8 b5 fe ff ff       	call   c0100bf6 <kmonitor>
    }
c0100d41:	eb f2                	jmp    c0100d35 <__panic+0x5e>

c0100d43 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d43:	55                   	push   %ebp
c0100d44:	89 e5                	mov    %esp,%ebp
c0100d46:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d49:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d52:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d56:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d59:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d5d:	c7 04 24 04 61 10 c0 	movl   $0xc0106104,(%esp)
c0100d64:	e8 d3 f5 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d6c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d70:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d73:	89 04 24             	mov    %eax,(%esp)
c0100d76:	e8 8e f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d7b:	c7 04 24 02 61 10 c0 	movl   $0xc0106102,(%esp)
c0100d82:	e8 b5 f5 ff ff       	call   c010033c <cprintf>
    va_end(ap);
}
c0100d87:	c9                   	leave  
c0100d88:	c3                   	ret    

c0100d89 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d89:	55                   	push   %ebp
c0100d8a:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d8c:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
}
c0100d91:	5d                   	pop    %ebp
c0100d92:	c3                   	ret    

c0100d93 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d93:	55                   	push   %ebp
c0100d94:	89 e5                	mov    %esp,%ebp
c0100d96:	83 ec 28             	sub    $0x28,%esp
c0100d99:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d9f:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100da3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100da7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100dab:	ee                   	out    %al,(%dx)
c0100dac:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100db2:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100db6:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100dba:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dbe:	ee                   	out    %al,(%dx)
c0100dbf:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100dc5:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100dc9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dcd:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dd1:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dd2:	c7 05 4c 89 11 c0 00 	movl   $0x0,0xc011894c
c0100dd9:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100ddc:	c7 04 24 22 61 10 c0 	movl   $0xc0106122,(%esp)
c0100de3:	e8 54 f5 ff ff       	call   c010033c <cprintf>
    pic_enable(IRQ_TIMER);
c0100de8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100def:	e8 24 09 00 00       	call   c0101718 <pic_enable>
}
c0100df4:	c9                   	leave  
c0100df5:	c3                   	ret    

c0100df6 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100df6:	55                   	push   %ebp
c0100df7:	89 e5                	mov    %esp,%ebp
c0100df9:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100dfc:	9c                   	pushf  
c0100dfd:	58                   	pop    %eax
c0100dfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e04:	25 00 02 00 00       	and    $0x200,%eax
c0100e09:	85 c0                	test   %eax,%eax
c0100e0b:	74 0c                	je     c0100e19 <__intr_save+0x23>
        intr_disable();
c0100e0d:	e8 a8 08 00 00       	call   c01016ba <intr_disable>
        return 1;
c0100e12:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e17:	eb 05                	jmp    c0100e1e <__intr_save+0x28>
    }
    return 0;
c0100e19:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e1e:	c9                   	leave  
c0100e1f:	c3                   	ret    

c0100e20 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e20:	55                   	push   %ebp
c0100e21:	89 e5                	mov    %esp,%ebp
c0100e23:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e26:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e2a:	74 05                	je     c0100e31 <__intr_restore+0x11>
        intr_enable();
c0100e2c:	e8 83 08 00 00       	call   c01016b4 <intr_enable>
    }
}
c0100e31:	c9                   	leave  
c0100e32:	c3                   	ret    

c0100e33 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e33:	55                   	push   %ebp
c0100e34:	89 e5                	mov    %esp,%ebp
c0100e36:	83 ec 10             	sub    $0x10,%esp
c0100e39:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e3f:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e43:	89 c2                	mov    %eax,%edx
c0100e45:	ec                   	in     (%dx),%al
c0100e46:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e49:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e4f:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e53:	89 c2                	mov    %eax,%edx
c0100e55:	ec                   	in     (%dx),%al
c0100e56:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e59:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e5f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e63:	89 c2                	mov    %eax,%edx
c0100e65:	ec                   	in     (%dx),%al
c0100e66:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e69:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e6f:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e73:	89 c2                	mov    %eax,%edx
c0100e75:	ec                   	in     (%dx),%al
c0100e76:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e79:	c9                   	leave  
c0100e7a:	c3                   	ret    

c0100e7b <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e7b:	55                   	push   %ebp
c0100e7c:	89 e5                	mov    %esp,%ebp
c0100e7e:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e81:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e88:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e8b:	0f b7 00             	movzwl (%eax),%eax
c0100e8e:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e92:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e95:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e9d:	0f b7 00             	movzwl (%eax),%eax
c0100ea0:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100ea4:	74 12                	je     c0100eb8 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100ea6:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100ead:	66 c7 05 86 7e 11 c0 	movw   $0x3b4,0xc0117e86
c0100eb4:	b4 03 
c0100eb6:	eb 13                	jmp    c0100ecb <cga_init+0x50>
    } else {
        *cp = was;
c0100eb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ebb:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ebf:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100ec2:	66 c7 05 86 7e 11 c0 	movw   $0x3d4,0xc0117e86
c0100ec9:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ecb:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ed2:	0f b7 c0             	movzwl %ax,%eax
c0100ed5:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ed9:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100edd:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ee1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100ee5:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ee6:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100eed:	83 c0 01             	add    $0x1,%eax
c0100ef0:	0f b7 c0             	movzwl %ax,%eax
c0100ef3:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ef7:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100efb:	89 c2                	mov    %eax,%edx
c0100efd:	ec                   	in     (%dx),%al
c0100efe:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100f01:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f05:	0f b6 c0             	movzbl %al,%eax
c0100f08:	c1 e0 08             	shl    $0x8,%eax
c0100f0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f0e:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f15:	0f b7 c0             	movzwl %ax,%eax
c0100f18:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f1c:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f20:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f24:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f28:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f29:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f30:	83 c0 01             	add    $0x1,%eax
c0100f33:	0f b7 c0             	movzwl %ax,%eax
c0100f36:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f3a:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f3e:	89 c2                	mov    %eax,%edx
c0100f40:	ec                   	in     (%dx),%al
c0100f41:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f44:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f48:	0f b6 c0             	movzbl %al,%eax
c0100f4b:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f51:	a3 80 7e 11 c0       	mov    %eax,0xc0117e80
    crt_pos = pos;
c0100f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f59:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
}
c0100f5f:	c9                   	leave  
c0100f60:	c3                   	ret    

c0100f61 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f61:	55                   	push   %ebp
c0100f62:	89 e5                	mov    %esp,%ebp
c0100f64:	83 ec 48             	sub    $0x48,%esp
c0100f67:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f6d:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f71:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f75:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f79:	ee                   	out    %al,(%dx)
c0100f7a:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f80:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f84:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f88:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f8c:	ee                   	out    %al,(%dx)
c0100f8d:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f93:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f97:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f9b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f9f:	ee                   	out    %al,(%dx)
c0100fa0:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fa6:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100faa:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fae:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fb2:	ee                   	out    %al,(%dx)
c0100fb3:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fb9:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fbd:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fc1:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fc5:	ee                   	out    %al,(%dx)
c0100fc6:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fcc:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fd0:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fd4:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fd8:	ee                   	out    %al,(%dx)
c0100fd9:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fdf:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fe3:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fe7:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100feb:	ee                   	out    %al,(%dx)
c0100fec:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ff2:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100ff6:	89 c2                	mov    %eax,%edx
c0100ff8:	ec                   	in     (%dx),%al
c0100ff9:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0100ffc:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101000:	3c ff                	cmp    $0xff,%al
c0101002:	0f 95 c0             	setne  %al
c0101005:	0f b6 c0             	movzbl %al,%eax
c0101008:	a3 88 7e 11 c0       	mov    %eax,0xc0117e88
c010100d:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101013:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0101017:	89 c2                	mov    %eax,%edx
c0101019:	ec                   	in     (%dx),%al
c010101a:	88 45 d5             	mov    %al,-0x2b(%ebp)
c010101d:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101023:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0101027:	89 c2                	mov    %eax,%edx
c0101029:	ec                   	in     (%dx),%al
c010102a:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010102d:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0101032:	85 c0                	test   %eax,%eax
c0101034:	74 0c                	je     c0101042 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0101036:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010103d:	e8 d6 06 00 00       	call   c0101718 <pic_enable>
    }
}
c0101042:	c9                   	leave  
c0101043:	c3                   	ret    

c0101044 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101044:	55                   	push   %ebp
c0101045:	89 e5                	mov    %esp,%ebp
c0101047:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010104a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101051:	eb 09                	jmp    c010105c <lpt_putc_sub+0x18>
        delay();
c0101053:	e8 db fd ff ff       	call   c0100e33 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101058:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010105c:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101062:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101066:	89 c2                	mov    %eax,%edx
c0101068:	ec                   	in     (%dx),%al
c0101069:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010106c:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101070:	84 c0                	test   %al,%al
c0101072:	78 09                	js     c010107d <lpt_putc_sub+0x39>
c0101074:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010107b:	7e d6                	jle    c0101053 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c010107d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101080:	0f b6 c0             	movzbl %al,%eax
c0101083:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c0101089:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010108c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101090:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101094:	ee                   	out    %al,(%dx)
c0101095:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c010109b:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c010109f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010a3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010a7:	ee                   	out    %al,(%dx)
c01010a8:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010ae:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010b2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010b6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010ba:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010bb:	c9                   	leave  
c01010bc:	c3                   	ret    

c01010bd <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010bd:	55                   	push   %ebp
c01010be:	89 e5                	mov    %esp,%ebp
c01010c0:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010c3:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010c7:	74 0d                	je     c01010d6 <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01010cc:	89 04 24             	mov    %eax,(%esp)
c01010cf:	e8 70 ff ff ff       	call   c0101044 <lpt_putc_sub>
c01010d4:	eb 24                	jmp    c01010fa <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010d6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010dd:	e8 62 ff ff ff       	call   c0101044 <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010e2:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010e9:	e8 56 ff ff ff       	call   c0101044 <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010ee:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010f5:	e8 4a ff ff ff       	call   c0101044 <lpt_putc_sub>
    }
}
c01010fa:	c9                   	leave  
c01010fb:	c3                   	ret    

c01010fc <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010fc:	55                   	push   %ebp
c01010fd:	89 e5                	mov    %esp,%ebp
c01010ff:	53                   	push   %ebx
c0101100:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101103:	8b 45 08             	mov    0x8(%ebp),%eax
c0101106:	b0 00                	mov    $0x0,%al
c0101108:	85 c0                	test   %eax,%eax
c010110a:	75 07                	jne    c0101113 <cga_putc+0x17>
        c |= 0x0700;
c010110c:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101113:	8b 45 08             	mov    0x8(%ebp),%eax
c0101116:	0f b6 c0             	movzbl %al,%eax
c0101119:	83 f8 0a             	cmp    $0xa,%eax
c010111c:	74 4c                	je     c010116a <cga_putc+0x6e>
c010111e:	83 f8 0d             	cmp    $0xd,%eax
c0101121:	74 57                	je     c010117a <cga_putc+0x7e>
c0101123:	83 f8 08             	cmp    $0x8,%eax
c0101126:	0f 85 88 00 00 00    	jne    c01011b4 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c010112c:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101133:	66 85 c0             	test   %ax,%ax
c0101136:	74 30                	je     c0101168 <cga_putc+0x6c>
            crt_pos --;
c0101138:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010113f:	83 e8 01             	sub    $0x1,%eax
c0101142:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101148:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c010114d:	0f b7 15 84 7e 11 c0 	movzwl 0xc0117e84,%edx
c0101154:	0f b7 d2             	movzwl %dx,%edx
c0101157:	01 d2                	add    %edx,%edx
c0101159:	01 c2                	add    %eax,%edx
c010115b:	8b 45 08             	mov    0x8(%ebp),%eax
c010115e:	b0 00                	mov    $0x0,%al
c0101160:	83 c8 20             	or     $0x20,%eax
c0101163:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101166:	eb 72                	jmp    c01011da <cga_putc+0xde>
c0101168:	eb 70                	jmp    c01011da <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c010116a:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101171:	83 c0 50             	add    $0x50,%eax
c0101174:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c010117a:	0f b7 1d 84 7e 11 c0 	movzwl 0xc0117e84,%ebx
c0101181:	0f b7 0d 84 7e 11 c0 	movzwl 0xc0117e84,%ecx
c0101188:	0f b7 c1             	movzwl %cx,%eax
c010118b:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101191:	c1 e8 10             	shr    $0x10,%eax
c0101194:	89 c2                	mov    %eax,%edx
c0101196:	66 c1 ea 06          	shr    $0x6,%dx
c010119a:	89 d0                	mov    %edx,%eax
c010119c:	c1 e0 02             	shl    $0x2,%eax
c010119f:	01 d0                	add    %edx,%eax
c01011a1:	c1 e0 04             	shl    $0x4,%eax
c01011a4:	29 c1                	sub    %eax,%ecx
c01011a6:	89 ca                	mov    %ecx,%edx
c01011a8:	89 d8                	mov    %ebx,%eax
c01011aa:	29 d0                	sub    %edx,%eax
c01011ac:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
        break;
c01011b2:	eb 26                	jmp    c01011da <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011b4:	8b 0d 80 7e 11 c0    	mov    0xc0117e80,%ecx
c01011ba:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011c1:	8d 50 01             	lea    0x1(%eax),%edx
c01011c4:	66 89 15 84 7e 11 c0 	mov    %dx,0xc0117e84
c01011cb:	0f b7 c0             	movzwl %ax,%eax
c01011ce:	01 c0                	add    %eax,%eax
c01011d0:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01011d6:	66 89 02             	mov    %ax,(%edx)
        break;
c01011d9:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011da:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011e1:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011e5:	76 5b                	jbe    c0101242 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011e7:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011ec:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011f2:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011f7:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01011fe:	00 
c01011ff:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101203:	89 04 24             	mov    %eax,(%esp)
c0101206:	e8 af 4a 00 00       	call   c0105cba <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010120b:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101212:	eb 15                	jmp    c0101229 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101214:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101219:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010121c:	01 d2                	add    %edx,%edx
c010121e:	01 d0                	add    %edx,%eax
c0101220:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101225:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101229:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101230:	7e e2                	jle    c0101214 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101232:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101239:	83 e8 50             	sub    $0x50,%eax
c010123c:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101242:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0101249:	0f b7 c0             	movzwl %ax,%eax
c010124c:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101250:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101254:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101258:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010125c:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c010125d:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101264:	66 c1 e8 08          	shr    $0x8,%ax
c0101268:	0f b6 c0             	movzbl %al,%eax
c010126b:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c0101272:	83 c2 01             	add    $0x1,%edx
c0101275:	0f b7 d2             	movzwl %dx,%edx
c0101278:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c010127c:	88 45 ed             	mov    %al,-0x13(%ebp)
c010127f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101283:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101287:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101288:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c010128f:	0f b7 c0             	movzwl %ax,%eax
c0101292:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0101296:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c010129a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010129e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012a2:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01012a3:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01012aa:	0f b6 c0             	movzbl %al,%eax
c01012ad:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c01012b4:	83 c2 01             	add    $0x1,%edx
c01012b7:	0f b7 d2             	movzwl %dx,%edx
c01012ba:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012be:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012c1:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012c5:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012c9:	ee                   	out    %al,(%dx)
}
c01012ca:	83 c4 34             	add    $0x34,%esp
c01012cd:	5b                   	pop    %ebx
c01012ce:	5d                   	pop    %ebp
c01012cf:	c3                   	ret    

c01012d0 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012d0:	55                   	push   %ebp
c01012d1:	89 e5                	mov    %esp,%ebp
c01012d3:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012dd:	eb 09                	jmp    c01012e8 <serial_putc_sub+0x18>
        delay();
c01012df:	e8 4f fb ff ff       	call   c0100e33 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012e4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012e8:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012ee:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012f2:	89 c2                	mov    %eax,%edx
c01012f4:	ec                   	in     (%dx),%al
c01012f5:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012f8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012fc:	0f b6 c0             	movzbl %al,%eax
c01012ff:	83 e0 20             	and    $0x20,%eax
c0101302:	85 c0                	test   %eax,%eax
c0101304:	75 09                	jne    c010130f <serial_putc_sub+0x3f>
c0101306:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010130d:	7e d0                	jle    c01012df <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c010130f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101312:	0f b6 c0             	movzbl %al,%eax
c0101315:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c010131b:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010131e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101322:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101326:	ee                   	out    %al,(%dx)
}
c0101327:	c9                   	leave  
c0101328:	c3                   	ret    

c0101329 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101329:	55                   	push   %ebp
c010132a:	89 e5                	mov    %esp,%ebp
c010132c:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010132f:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101333:	74 0d                	je     c0101342 <serial_putc+0x19>
        serial_putc_sub(c);
c0101335:	8b 45 08             	mov    0x8(%ebp),%eax
c0101338:	89 04 24             	mov    %eax,(%esp)
c010133b:	e8 90 ff ff ff       	call   c01012d0 <serial_putc_sub>
c0101340:	eb 24                	jmp    c0101366 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101342:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101349:	e8 82 ff ff ff       	call   c01012d0 <serial_putc_sub>
        serial_putc_sub(' ');
c010134e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101355:	e8 76 ff ff ff       	call   c01012d0 <serial_putc_sub>
        serial_putc_sub('\b');
c010135a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101361:	e8 6a ff ff ff       	call   c01012d0 <serial_putc_sub>
    }
}
c0101366:	c9                   	leave  
c0101367:	c3                   	ret    

c0101368 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101368:	55                   	push   %ebp
c0101369:	89 e5                	mov    %esp,%ebp
c010136b:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c010136e:	eb 33                	jmp    c01013a3 <cons_intr+0x3b>
        if (c != 0) {
c0101370:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101374:	74 2d                	je     c01013a3 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101376:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c010137b:	8d 50 01             	lea    0x1(%eax),%edx
c010137e:	89 15 a4 80 11 c0    	mov    %edx,0xc01180a4
c0101384:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101387:	88 90 a0 7e 11 c0    	mov    %dl,-0x3fee8160(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c010138d:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101392:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101397:	75 0a                	jne    c01013a3 <cons_intr+0x3b>
                cons.wpos = 0;
c0101399:	c7 05 a4 80 11 c0 00 	movl   $0x0,0xc01180a4
c01013a0:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c01013a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01013a6:	ff d0                	call   *%eax
c01013a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013ab:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013af:	75 bf                	jne    c0101370 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013b1:	c9                   	leave  
c01013b2:	c3                   	ret    

c01013b3 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013b3:	55                   	push   %ebp
c01013b4:	89 e5                	mov    %esp,%ebp
c01013b6:	83 ec 10             	sub    $0x10,%esp
c01013b9:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013bf:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013c3:	89 c2                	mov    %eax,%edx
c01013c5:	ec                   	in     (%dx),%al
c01013c6:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013c9:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013cd:	0f b6 c0             	movzbl %al,%eax
c01013d0:	83 e0 01             	and    $0x1,%eax
c01013d3:	85 c0                	test   %eax,%eax
c01013d5:	75 07                	jne    c01013de <serial_proc_data+0x2b>
        return -1;
c01013d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013dc:	eb 2a                	jmp    c0101408 <serial_proc_data+0x55>
c01013de:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013e4:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013e8:	89 c2                	mov    %eax,%edx
c01013ea:	ec                   	in     (%dx),%al
c01013eb:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013ee:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013f2:	0f b6 c0             	movzbl %al,%eax
c01013f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013f8:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013fc:	75 07                	jne    c0101405 <serial_proc_data+0x52>
        c = '\b';
c01013fe:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c0101405:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101408:	c9                   	leave  
c0101409:	c3                   	ret    

c010140a <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c010140a:	55                   	push   %ebp
c010140b:	89 e5                	mov    %esp,%ebp
c010140d:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101410:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0101415:	85 c0                	test   %eax,%eax
c0101417:	74 0c                	je     c0101425 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101419:	c7 04 24 b3 13 10 c0 	movl   $0xc01013b3,(%esp)
c0101420:	e8 43 ff ff ff       	call   c0101368 <cons_intr>
    }
}
c0101425:	c9                   	leave  
c0101426:	c3                   	ret    

c0101427 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101427:	55                   	push   %ebp
c0101428:	89 e5                	mov    %esp,%ebp
c010142a:	83 ec 38             	sub    $0x38,%esp
c010142d:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101433:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101437:	89 c2                	mov    %eax,%edx
c0101439:	ec                   	in     (%dx),%al
c010143a:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c010143d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101441:	0f b6 c0             	movzbl %al,%eax
c0101444:	83 e0 01             	and    $0x1,%eax
c0101447:	85 c0                	test   %eax,%eax
c0101449:	75 0a                	jne    c0101455 <kbd_proc_data+0x2e>
        return -1;
c010144b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101450:	e9 59 01 00 00       	jmp    c01015ae <kbd_proc_data+0x187>
c0101455:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010145b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010145f:	89 c2                	mov    %eax,%edx
c0101461:	ec                   	in     (%dx),%al
c0101462:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101465:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101469:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c010146c:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101470:	75 17                	jne    c0101489 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101472:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101477:	83 c8 40             	or     $0x40,%eax
c010147a:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c010147f:	b8 00 00 00 00       	mov    $0x0,%eax
c0101484:	e9 25 01 00 00       	jmp    c01015ae <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c0101489:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010148d:	84 c0                	test   %al,%al
c010148f:	79 47                	jns    c01014d8 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101491:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101496:	83 e0 40             	and    $0x40,%eax
c0101499:	85 c0                	test   %eax,%eax
c010149b:	75 09                	jne    c01014a6 <kbd_proc_data+0x7f>
c010149d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a1:	83 e0 7f             	and    $0x7f,%eax
c01014a4:	eb 04                	jmp    c01014aa <kbd_proc_data+0x83>
c01014a6:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014aa:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014ad:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014b1:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014b8:	83 c8 40             	or     $0x40,%eax
c01014bb:	0f b6 c0             	movzbl %al,%eax
c01014be:	f7 d0                	not    %eax
c01014c0:	89 c2                	mov    %eax,%edx
c01014c2:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014c7:	21 d0                	and    %edx,%eax
c01014c9:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c01014ce:	b8 00 00 00 00       	mov    $0x0,%eax
c01014d3:	e9 d6 00 00 00       	jmp    c01015ae <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014d8:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014dd:	83 e0 40             	and    $0x40,%eax
c01014e0:	85 c0                	test   %eax,%eax
c01014e2:	74 11                	je     c01014f5 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014e4:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014e8:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014ed:	83 e0 bf             	and    $0xffffffbf,%eax
c01014f0:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    }

    shift |= shiftcode[data];
c01014f5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014f9:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c0101500:	0f b6 d0             	movzbl %al,%edx
c0101503:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101508:	09 d0                	or     %edx,%eax
c010150a:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    shift ^= togglecode[data];
c010150f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101513:	0f b6 80 60 71 11 c0 	movzbl -0x3fee8ea0(%eax),%eax
c010151a:	0f b6 d0             	movzbl %al,%edx
c010151d:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101522:	31 d0                	xor    %edx,%eax
c0101524:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8

    c = charcode[shift & (CTL | SHIFT)][data];
c0101529:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010152e:	83 e0 03             	and    $0x3,%eax
c0101531:	8b 14 85 60 75 11 c0 	mov    -0x3fee8aa0(,%eax,4),%edx
c0101538:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010153c:	01 d0                	add    %edx,%eax
c010153e:	0f b6 00             	movzbl (%eax),%eax
c0101541:	0f b6 c0             	movzbl %al,%eax
c0101544:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101547:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010154c:	83 e0 08             	and    $0x8,%eax
c010154f:	85 c0                	test   %eax,%eax
c0101551:	74 22                	je     c0101575 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101553:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101557:	7e 0c                	jle    c0101565 <kbd_proc_data+0x13e>
c0101559:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c010155d:	7f 06                	jg     c0101565 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c010155f:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101563:	eb 10                	jmp    c0101575 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101565:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101569:	7e 0a                	jle    c0101575 <kbd_proc_data+0x14e>
c010156b:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c010156f:	7f 04                	jg     c0101575 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101571:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101575:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010157a:	f7 d0                	not    %eax
c010157c:	83 e0 06             	and    $0x6,%eax
c010157f:	85 c0                	test   %eax,%eax
c0101581:	75 28                	jne    c01015ab <kbd_proc_data+0x184>
c0101583:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c010158a:	75 1f                	jne    c01015ab <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c010158c:	c7 04 24 3d 61 10 c0 	movl   $0xc010613d,(%esp)
c0101593:	e8 a4 ed ff ff       	call   c010033c <cprintf>
c0101598:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c010159e:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01015a2:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01015a6:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01015aa:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015ae:	c9                   	leave  
c01015af:	c3                   	ret    

c01015b0 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015b0:	55                   	push   %ebp
c01015b1:	89 e5                	mov    %esp,%ebp
c01015b3:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015b6:	c7 04 24 27 14 10 c0 	movl   $0xc0101427,(%esp)
c01015bd:	e8 a6 fd ff ff       	call   c0101368 <cons_intr>
}
c01015c2:	c9                   	leave  
c01015c3:	c3                   	ret    

c01015c4 <kbd_init>:

static void
kbd_init(void) {
c01015c4:	55                   	push   %ebp
c01015c5:	89 e5                	mov    %esp,%ebp
c01015c7:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015ca:	e8 e1 ff ff ff       	call   c01015b0 <kbd_intr>
    pic_enable(IRQ_KBD);
c01015cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015d6:	e8 3d 01 00 00       	call   c0101718 <pic_enable>
}
c01015db:	c9                   	leave  
c01015dc:	c3                   	ret    

c01015dd <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015dd:	55                   	push   %ebp
c01015de:	89 e5                	mov    %esp,%ebp
c01015e0:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015e3:	e8 93 f8 ff ff       	call   c0100e7b <cga_init>
    serial_init();
c01015e8:	e8 74 f9 ff ff       	call   c0100f61 <serial_init>
    kbd_init();
c01015ed:	e8 d2 ff ff ff       	call   c01015c4 <kbd_init>
    if (!serial_exists) {
c01015f2:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c01015f7:	85 c0                	test   %eax,%eax
c01015f9:	75 0c                	jne    c0101607 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01015fb:	c7 04 24 49 61 10 c0 	movl   $0xc0106149,(%esp)
c0101602:	e8 35 ed ff ff       	call   c010033c <cprintf>
    }
}
c0101607:	c9                   	leave  
c0101608:	c3                   	ret    

c0101609 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101609:	55                   	push   %ebp
c010160a:	89 e5                	mov    %esp,%ebp
c010160c:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c010160f:	e8 e2 f7 ff ff       	call   c0100df6 <__intr_save>
c0101614:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101617:	8b 45 08             	mov    0x8(%ebp),%eax
c010161a:	89 04 24             	mov    %eax,(%esp)
c010161d:	e8 9b fa ff ff       	call   c01010bd <lpt_putc>
        cga_putc(c);
c0101622:	8b 45 08             	mov    0x8(%ebp),%eax
c0101625:	89 04 24             	mov    %eax,(%esp)
c0101628:	e8 cf fa ff ff       	call   c01010fc <cga_putc>
        serial_putc(c);
c010162d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101630:	89 04 24             	mov    %eax,(%esp)
c0101633:	e8 f1 fc ff ff       	call   c0101329 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101638:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010163b:	89 04 24             	mov    %eax,(%esp)
c010163e:	e8 dd f7 ff ff       	call   c0100e20 <__intr_restore>
}
c0101643:	c9                   	leave  
c0101644:	c3                   	ret    

c0101645 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101645:	55                   	push   %ebp
c0101646:	89 e5                	mov    %esp,%ebp
c0101648:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c010164b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101652:	e8 9f f7 ff ff       	call   c0100df6 <__intr_save>
c0101657:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c010165a:	e8 ab fd ff ff       	call   c010140a <serial_intr>
        kbd_intr();
c010165f:	e8 4c ff ff ff       	call   c01015b0 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101664:	8b 15 a0 80 11 c0    	mov    0xc01180a0,%edx
c010166a:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c010166f:	39 c2                	cmp    %eax,%edx
c0101671:	74 31                	je     c01016a4 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101673:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101678:	8d 50 01             	lea    0x1(%eax),%edx
c010167b:	89 15 a0 80 11 c0    	mov    %edx,0xc01180a0
c0101681:	0f b6 80 a0 7e 11 c0 	movzbl -0x3fee8160(%eax),%eax
c0101688:	0f b6 c0             	movzbl %al,%eax
c010168b:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c010168e:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101693:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101698:	75 0a                	jne    c01016a4 <cons_getc+0x5f>
                cons.rpos = 0;
c010169a:	c7 05 a0 80 11 c0 00 	movl   $0x0,0xc01180a0
c01016a1:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01016a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01016a7:	89 04 24             	mov    %eax,(%esp)
c01016aa:	e8 71 f7 ff ff       	call   c0100e20 <__intr_restore>
    return c;
c01016af:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016b2:	c9                   	leave  
c01016b3:	c3                   	ret    

c01016b4 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01016b4:	55                   	push   %ebp
c01016b5:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c01016b7:	fb                   	sti    
    sti();
}
c01016b8:	5d                   	pop    %ebp
c01016b9:	c3                   	ret    

c01016ba <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01016ba:	55                   	push   %ebp
c01016bb:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c01016bd:	fa                   	cli    
    cli();
}
c01016be:	5d                   	pop    %ebp
c01016bf:	c3                   	ret    

c01016c0 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016c0:	55                   	push   %ebp
c01016c1:	89 e5                	mov    %esp,%ebp
c01016c3:	83 ec 14             	sub    $0x14,%esp
c01016c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01016c9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016cd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016d1:	66 a3 70 75 11 c0    	mov    %ax,0xc0117570
    if (did_init) {
c01016d7:	a1 ac 80 11 c0       	mov    0xc01180ac,%eax
c01016dc:	85 c0                	test   %eax,%eax
c01016de:	74 36                	je     c0101716 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016e0:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016e4:	0f b6 c0             	movzbl %al,%eax
c01016e7:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016ed:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01016f0:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01016f4:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016f8:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016f9:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016fd:	66 c1 e8 08          	shr    $0x8,%ax
c0101701:	0f b6 c0             	movzbl %al,%eax
c0101704:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c010170a:	88 45 f9             	mov    %al,-0x7(%ebp)
c010170d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101711:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101715:	ee                   	out    %al,(%dx)
    }
}
c0101716:	c9                   	leave  
c0101717:	c3                   	ret    

c0101718 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101718:	55                   	push   %ebp
c0101719:	89 e5                	mov    %esp,%ebp
c010171b:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c010171e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101721:	ba 01 00 00 00       	mov    $0x1,%edx
c0101726:	89 c1                	mov    %eax,%ecx
c0101728:	d3 e2                	shl    %cl,%edx
c010172a:	89 d0                	mov    %edx,%eax
c010172c:	f7 d0                	not    %eax
c010172e:	89 c2                	mov    %eax,%edx
c0101730:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101737:	21 d0                	and    %edx,%eax
c0101739:	0f b7 c0             	movzwl %ax,%eax
c010173c:	89 04 24             	mov    %eax,(%esp)
c010173f:	e8 7c ff ff ff       	call   c01016c0 <pic_setmask>
}
c0101744:	c9                   	leave  
c0101745:	c3                   	ret    

c0101746 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101746:	55                   	push   %ebp
c0101747:	89 e5                	mov    %esp,%ebp
c0101749:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c010174c:	c7 05 ac 80 11 c0 01 	movl   $0x1,0xc01180ac
c0101753:	00 00 00 
c0101756:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c010175c:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101760:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101764:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101768:	ee                   	out    %al,(%dx)
c0101769:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c010176f:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101773:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101777:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010177b:	ee                   	out    %al,(%dx)
c010177c:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101782:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c0101786:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010178a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010178e:	ee                   	out    %al,(%dx)
c010178f:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c0101795:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c0101799:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010179d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01017a1:	ee                   	out    %al,(%dx)
c01017a2:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c01017a8:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c01017ac:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01017b0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017b4:	ee                   	out    %al,(%dx)
c01017b5:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c01017bb:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c01017bf:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017c3:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017c7:	ee                   	out    %al,(%dx)
c01017c8:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c01017ce:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c01017d2:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017d6:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017da:	ee                   	out    %al,(%dx)
c01017db:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c01017e1:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c01017e5:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017e9:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017ed:	ee                   	out    %al,(%dx)
c01017ee:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c01017f4:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c01017f8:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017fc:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101800:	ee                   	out    %al,(%dx)
c0101801:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c0101807:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c010180b:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010180f:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101813:	ee                   	out    %al,(%dx)
c0101814:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c010181a:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c010181e:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101822:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101826:	ee                   	out    %al,(%dx)
c0101827:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c010182d:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c0101831:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101835:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101839:	ee                   	out    %al,(%dx)
c010183a:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c0101840:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c0101844:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101848:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c010184c:	ee                   	out    %al,(%dx)
c010184d:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c0101853:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c0101857:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c010185b:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c010185f:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101860:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101867:	66 83 f8 ff          	cmp    $0xffff,%ax
c010186b:	74 12                	je     c010187f <pic_init+0x139>
        pic_setmask(irq_mask);
c010186d:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101874:	0f b7 c0             	movzwl %ax,%eax
c0101877:	89 04 24             	mov    %eax,(%esp)
c010187a:	e8 41 fe ff ff       	call   c01016c0 <pic_setmask>
    }
}
c010187f:	c9                   	leave  
c0101880:	c3                   	ret    

c0101881 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101881:	55                   	push   %ebp
c0101882:	89 e5                	mov    %esp,%ebp
c0101884:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0101887:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c010188e:	00 
c010188f:	c7 04 24 80 61 10 c0 	movl   $0xc0106180,(%esp)
c0101896:	e8 a1 ea ff ff       	call   c010033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c010189b:	c7 04 24 8a 61 10 c0 	movl   $0xc010618a,(%esp)
c01018a2:	e8 95 ea ff ff       	call   c010033c <cprintf>
    panic("EOT: kernel seems ok.");
c01018a7:	c7 44 24 08 98 61 10 	movl   $0xc0106198,0x8(%esp)
c01018ae:	c0 
c01018af:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
c01018b6:	00 
c01018b7:	c7 04 24 ae 61 10 c0 	movl   $0xc01061ae,(%esp)
c01018be:	e8 14 f4 ff ff       	call   c0100cd7 <__panic>

c01018c3 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01018c3:	55                   	push   %ebp
c01018c4:	89 e5                	mov    %esp,%ebp
c01018c6:	83 ec 10             	sub    $0x10,%esp
      */
	// My Code starts
	extern uintptr_t __vectors[];     // declaration code generted by vector.c
	int i;
	// fill in the idt
	for (i = 0; i < 256; i++) {
c01018c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018d0:	e9 c3 00 00 00       	jmp    c0101998 <idt_init+0xd5>
		// not trap, kernel's code/text, offset defined in vector.S, privilege 0
		// macro defined in memlayout.h
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01018d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018d8:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c01018df:	89 c2                	mov    %eax,%edx
c01018e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018e4:	66 89 14 c5 c0 80 11 	mov    %dx,-0x3fee7f40(,%eax,8)
c01018eb:	c0 
c01018ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018ef:	66 c7 04 c5 c2 80 11 	movw   $0x8,-0x3fee7f3e(,%eax,8)
c01018f6:	c0 08 00 
c01018f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018fc:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c0101903:	c0 
c0101904:	83 e2 e0             	and    $0xffffffe0,%edx
c0101907:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c010190e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101911:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c0101918:	c0 
c0101919:	83 e2 1f             	and    $0x1f,%edx
c010191c:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c0101923:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101926:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010192d:	c0 
c010192e:	83 e2 f0             	and    $0xfffffff0,%edx
c0101931:	83 ca 0e             	or     $0xe,%edx
c0101934:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c010193b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010193e:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101945:	c0 
c0101946:	83 e2 ef             	and    $0xffffffef,%edx
c0101949:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101950:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101953:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010195a:	c0 
c010195b:	83 e2 9f             	and    $0xffffff9f,%edx
c010195e:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101965:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101968:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010196f:	c0 
c0101970:	83 ca 80             	or     $0xffffff80,%edx
c0101973:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c010197a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010197d:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c0101984:	c1 e8 10             	shr    $0x10,%eax
c0101987:	89 c2                	mov    %eax,%edx
c0101989:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010198c:	66 89 14 c5 c6 80 11 	mov    %dx,-0x3fee7f3a(,%eax,8)
c0101993:	c0 
      */
	// My Code starts
	extern uintptr_t __vectors[];     // declaration code generted by vector.c
	int i;
	// fill in the idt
	for (i = 0; i < 256; i++) {
c0101994:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101998:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c010199f:	0f 8e 30 ff ff ff    	jle    c01018d5 <idt_init+0x12>
		// not trap, kernel's code/text, offset defined in vector.S, privilege 0
		// macro defined in memlayout.h
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
	}
	// For challenge 1, need to grant the access to SWITCH_TOKernel in user mode
	SETGATE(idt[T_SWITCH_TOK], 1, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c01019a5:	a1 e4 77 11 c0       	mov    0xc01177e4,%eax
c01019aa:	66 a3 88 84 11 c0    	mov    %ax,0xc0118488
c01019b0:	66 c7 05 8a 84 11 c0 	movw   $0x8,0xc011848a
c01019b7:	08 00 
c01019b9:	0f b6 05 8c 84 11 c0 	movzbl 0xc011848c,%eax
c01019c0:	83 e0 e0             	and    $0xffffffe0,%eax
c01019c3:	a2 8c 84 11 c0       	mov    %al,0xc011848c
c01019c8:	0f b6 05 8c 84 11 c0 	movzbl 0xc011848c,%eax
c01019cf:	83 e0 1f             	and    $0x1f,%eax
c01019d2:	a2 8c 84 11 c0       	mov    %al,0xc011848c
c01019d7:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019de:	83 c8 0f             	or     $0xf,%eax
c01019e1:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019e6:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019ed:	83 e0 ef             	and    $0xffffffef,%eax
c01019f0:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019f5:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019fc:	83 c8 60             	or     $0x60,%eax
c01019ff:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c0101a04:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c0101a0b:	83 c8 80             	or     $0xffffff80,%eax
c0101a0e:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c0101a13:	a1 e4 77 11 c0       	mov    0xc01177e4,%eax
c0101a18:	c1 e8 10             	shr    $0x10,%eax
c0101a1b:	66 a3 8e 84 11 c0    	mov    %ax,0xc011848e
c0101a21:	c7 45 f8 80 75 11 c0 	movl   $0xc0117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101a28:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101a2b:	0f 01 18             	lidtl  (%eax)
	lidt(&idt_pd);
	// My Code ends
}
c0101a2e:	c9                   	leave  
c0101a2f:	c3                   	ret    

c0101a30 <trapname>:

static const char *
trapname(int trapno) {
c0101a30:	55                   	push   %ebp
c0101a31:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101a33:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a36:	83 f8 13             	cmp    $0x13,%eax
c0101a39:	77 0c                	ja     c0101a47 <trapname+0x17>
        return excnames[trapno];
c0101a3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a3e:	8b 04 85 00 65 10 c0 	mov    -0x3fef9b00(,%eax,4),%eax
c0101a45:	eb 18                	jmp    c0101a5f <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a47:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a4b:	7e 0d                	jle    c0101a5a <trapname+0x2a>
c0101a4d:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a51:	7f 07                	jg     c0101a5a <trapname+0x2a>
        return "Hardware Interrupt";
c0101a53:	b8 bf 61 10 c0       	mov    $0xc01061bf,%eax
c0101a58:	eb 05                	jmp    c0101a5f <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a5a:	b8 d2 61 10 c0       	mov    $0xc01061d2,%eax
}
c0101a5f:	5d                   	pop    %ebp
c0101a60:	c3                   	ret    

c0101a61 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101a61:	55                   	push   %ebp
c0101a62:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101a64:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a67:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101a6b:	66 83 f8 08          	cmp    $0x8,%ax
c0101a6f:	0f 94 c0             	sete   %al
c0101a72:	0f b6 c0             	movzbl %al,%eax
}
c0101a75:	5d                   	pop    %ebp
c0101a76:	c3                   	ret    

c0101a77 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101a77:	55                   	push   %ebp
c0101a78:	89 e5                	mov    %esp,%ebp
c0101a7a:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101a7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a80:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a84:	c7 04 24 13 62 10 c0 	movl   $0xc0106213,(%esp)
c0101a8b:	e8 ac e8 ff ff       	call   c010033c <cprintf>
    print_regs(&tf->tf_regs);
c0101a90:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a93:	89 04 24             	mov    %eax,(%esp)
c0101a96:	e8 a1 01 00 00       	call   c0101c3c <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101a9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a9e:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101aa2:	0f b7 c0             	movzwl %ax,%eax
c0101aa5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101aa9:	c7 04 24 24 62 10 c0 	movl   $0xc0106224,(%esp)
c0101ab0:	e8 87 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101ab5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab8:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101abc:	0f b7 c0             	movzwl %ax,%eax
c0101abf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ac3:	c7 04 24 37 62 10 c0 	movl   $0xc0106237,(%esp)
c0101aca:	e8 6d e8 ff ff       	call   c010033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101acf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ad2:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101ad6:	0f b7 c0             	movzwl %ax,%eax
c0101ad9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101add:	c7 04 24 4a 62 10 c0 	movl   $0xc010624a,(%esp)
c0101ae4:	e8 53 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101ae9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aec:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101af0:	0f b7 c0             	movzwl %ax,%eax
c0101af3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101af7:	c7 04 24 5d 62 10 c0 	movl   $0xc010625d,(%esp)
c0101afe:	e8 39 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101b03:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b06:	8b 40 30             	mov    0x30(%eax),%eax
c0101b09:	89 04 24             	mov    %eax,(%esp)
c0101b0c:	e8 1f ff ff ff       	call   c0101a30 <trapname>
c0101b11:	8b 55 08             	mov    0x8(%ebp),%edx
c0101b14:	8b 52 30             	mov    0x30(%edx),%edx
c0101b17:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101b1b:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101b1f:	c7 04 24 70 62 10 c0 	movl   $0xc0106270,(%esp)
c0101b26:	e8 11 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101b2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b2e:	8b 40 34             	mov    0x34(%eax),%eax
c0101b31:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b35:	c7 04 24 82 62 10 c0 	movl   $0xc0106282,(%esp)
c0101b3c:	e8 fb e7 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b41:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b44:	8b 40 38             	mov    0x38(%eax),%eax
c0101b47:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b4b:	c7 04 24 91 62 10 c0 	movl   $0xc0106291,(%esp)
c0101b52:	e8 e5 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b57:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b5a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b5e:	0f b7 c0             	movzwl %ax,%eax
c0101b61:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b65:	c7 04 24 a0 62 10 c0 	movl   $0xc01062a0,(%esp)
c0101b6c:	e8 cb e7 ff ff       	call   c010033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b71:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b74:	8b 40 40             	mov    0x40(%eax),%eax
c0101b77:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b7b:	c7 04 24 b3 62 10 c0 	movl   $0xc01062b3,(%esp)
c0101b82:	e8 b5 e7 ff ff       	call   c010033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b87:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b8e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101b95:	eb 3e                	jmp    c0101bd5 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101b97:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b9a:	8b 50 40             	mov    0x40(%eax),%edx
c0101b9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101ba0:	21 d0                	and    %edx,%eax
c0101ba2:	85 c0                	test   %eax,%eax
c0101ba4:	74 28                	je     c0101bce <print_trapframe+0x157>
c0101ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ba9:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101bb0:	85 c0                	test   %eax,%eax
c0101bb2:	74 1a                	je     c0101bce <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bb7:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101bbe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bc2:	c7 04 24 c2 62 10 c0 	movl   $0xc01062c2,(%esp)
c0101bc9:	e8 6e e7 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101bce:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101bd2:	d1 65 f0             	shll   -0x10(%ebp)
c0101bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bd8:	83 f8 17             	cmp    $0x17,%eax
c0101bdb:	76 ba                	jbe    c0101b97 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101bdd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101be0:	8b 40 40             	mov    0x40(%eax),%eax
c0101be3:	25 00 30 00 00       	and    $0x3000,%eax
c0101be8:	c1 e8 0c             	shr    $0xc,%eax
c0101beb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bef:	c7 04 24 c6 62 10 c0 	movl   $0xc01062c6,(%esp)
c0101bf6:	e8 41 e7 ff ff       	call   c010033c <cprintf>

    if (!trap_in_kernel(tf)) {
c0101bfb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bfe:	89 04 24             	mov    %eax,(%esp)
c0101c01:	e8 5b fe ff ff       	call   c0101a61 <trap_in_kernel>
c0101c06:	85 c0                	test   %eax,%eax
c0101c08:	75 30                	jne    c0101c3a <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101c0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c0d:	8b 40 44             	mov    0x44(%eax),%eax
c0101c10:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c14:	c7 04 24 cf 62 10 c0 	movl   $0xc01062cf,(%esp)
c0101c1b:	e8 1c e7 ff ff       	call   c010033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101c20:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c23:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101c27:	0f b7 c0             	movzwl %ax,%eax
c0101c2a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c2e:	c7 04 24 de 62 10 c0 	movl   $0xc01062de,(%esp)
c0101c35:	e8 02 e7 ff ff       	call   c010033c <cprintf>
    }
}
c0101c3a:	c9                   	leave  
c0101c3b:	c3                   	ret    

c0101c3c <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101c3c:	55                   	push   %ebp
c0101c3d:	89 e5                	mov    %esp,%ebp
c0101c3f:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101c42:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c45:	8b 00                	mov    (%eax),%eax
c0101c47:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c4b:	c7 04 24 f1 62 10 c0 	movl   $0xc01062f1,(%esp)
c0101c52:	e8 e5 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c57:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c5a:	8b 40 04             	mov    0x4(%eax),%eax
c0101c5d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c61:	c7 04 24 00 63 10 c0 	movl   $0xc0106300,(%esp)
c0101c68:	e8 cf e6 ff ff       	call   c010033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c70:	8b 40 08             	mov    0x8(%eax),%eax
c0101c73:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c77:	c7 04 24 0f 63 10 c0 	movl   $0xc010630f,(%esp)
c0101c7e:	e8 b9 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c83:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c86:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c89:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c8d:	c7 04 24 1e 63 10 c0 	movl   $0xc010631e,(%esp)
c0101c94:	e8 a3 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101c99:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c9c:	8b 40 10             	mov    0x10(%eax),%eax
c0101c9f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ca3:	c7 04 24 2d 63 10 c0 	movl   $0xc010632d,(%esp)
c0101caa:	e8 8d e6 ff ff       	call   c010033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101caf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cb2:	8b 40 14             	mov    0x14(%eax),%eax
c0101cb5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cb9:	c7 04 24 3c 63 10 c0 	movl   $0xc010633c,(%esp)
c0101cc0:	e8 77 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101cc5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cc8:	8b 40 18             	mov    0x18(%eax),%eax
c0101ccb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ccf:	c7 04 24 4b 63 10 c0 	movl   $0xc010634b,(%esp)
c0101cd6:	e8 61 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101cdb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cde:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101ce1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ce5:	c7 04 24 5a 63 10 c0 	movl   $0xc010635a,(%esp)
c0101cec:	e8 4b e6 ff ff       	call   c010033c <cprintf>
}
c0101cf1:	c9                   	leave  
c0101cf2:	c3                   	ret    

c0101cf3 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101cf3:	55                   	push   %ebp
c0101cf4:	89 e5                	mov    %esp,%ebp
c0101cf6:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101cf9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cfc:	8b 40 30             	mov    0x30(%eax),%eax
c0101cff:	83 f8 2f             	cmp    $0x2f,%eax
c0101d02:	77 21                	ja     c0101d25 <trap_dispatch+0x32>
c0101d04:	83 f8 2e             	cmp    $0x2e,%eax
c0101d07:	0f 83 04 01 00 00    	jae    c0101e11 <trap_dispatch+0x11e>
c0101d0d:	83 f8 21             	cmp    $0x21,%eax
c0101d10:	0f 84 81 00 00 00    	je     c0101d97 <trap_dispatch+0xa4>
c0101d16:	83 f8 24             	cmp    $0x24,%eax
c0101d19:	74 56                	je     c0101d71 <trap_dispatch+0x7e>
c0101d1b:	83 f8 20             	cmp    $0x20,%eax
c0101d1e:	74 16                	je     c0101d36 <trap_dispatch+0x43>
c0101d20:	e9 b4 00 00 00       	jmp    c0101dd9 <trap_dispatch+0xe6>
c0101d25:	83 e8 78             	sub    $0x78,%eax
c0101d28:	83 f8 01             	cmp    $0x1,%eax
c0101d2b:	0f 87 a8 00 00 00    	ja     c0101dd9 <trap_dispatch+0xe6>
c0101d31:	e9 87 00 00 00       	jmp    c0101dbd <trap_dispatch+0xca>
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
		// My code starts
		ticks++;
c0101d36:	a1 4c 89 11 c0       	mov    0xc011894c,%eax
c0101d3b:	83 c0 01             	add    $0x1,%eax
c0101d3e:	a3 4c 89 11 c0       	mov    %eax,0xc011894c
		if (ticks % TICK_NUM == 0) {
c0101d43:	8b 0d 4c 89 11 c0    	mov    0xc011894c,%ecx
c0101d49:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101d4e:	89 c8                	mov    %ecx,%eax
c0101d50:	f7 e2                	mul    %edx
c0101d52:	89 d0                	mov    %edx,%eax
c0101d54:	c1 e8 05             	shr    $0x5,%eax
c0101d57:	6b c0 64             	imul   $0x64,%eax,%eax
c0101d5a:	29 c1                	sub    %eax,%ecx
c0101d5c:	89 c8                	mov    %ecx,%eax
c0101d5e:	85 c0                	test   %eax,%eax
c0101d60:	75 0a                	jne    c0101d6c <trap_dispatch+0x79>
			print_ticks();
c0101d62:	e8 1a fb ff ff       	call   c0101881 <print_ticks>
		}
		// My code ends
        break;
c0101d67:	e9 a6 00 00 00       	jmp    c0101e12 <trap_dispatch+0x11f>
c0101d6c:	e9 a1 00 00 00       	jmp    c0101e12 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101d71:	e8 cf f8 ff ff       	call   c0101645 <cons_getc>
c0101d76:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101d79:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d7d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d81:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101d85:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d89:	c7 04 24 69 63 10 c0 	movl   $0xc0106369,(%esp)
c0101d90:	e8 a7 e5 ff ff       	call   c010033c <cprintf>
        break;
c0101d95:	eb 7b                	jmp    c0101e12 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101d97:	e8 a9 f8 ff ff       	call   c0101645 <cons_getc>
c0101d9c:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101d9f:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101da3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101da7:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101dab:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101daf:	c7 04 24 7b 63 10 c0 	movl   $0xc010637b,(%esp)
c0101db6:	e8 81 e5 ff ff       	call   c010033c <cprintf>
        break;
c0101dbb:	eb 55                	jmp    c0101e12 <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101dbd:	c7 44 24 08 8a 63 10 	movl   $0xc010638a,0x8(%esp)
c0101dc4:	c0 
c0101dc5:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
c0101dcc:	00 
c0101dcd:	c7 04 24 ae 61 10 c0 	movl   $0xc01061ae,(%esp)
c0101dd4:	e8 fe ee ff ff       	call   c0100cd7 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101dd9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ddc:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101de0:	0f b7 c0             	movzwl %ax,%eax
c0101de3:	83 e0 03             	and    $0x3,%eax
c0101de6:	85 c0                	test   %eax,%eax
c0101de8:	75 28                	jne    c0101e12 <trap_dispatch+0x11f>
            print_trapframe(tf);
c0101dea:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ded:	89 04 24             	mov    %eax,(%esp)
c0101df0:	e8 82 fc ff ff       	call   c0101a77 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101df5:	c7 44 24 08 9a 63 10 	movl   $0xc010639a,0x8(%esp)
c0101dfc:	c0 
c0101dfd:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c0101e04:	00 
c0101e05:	c7 04 24 ae 61 10 c0 	movl   $0xc01061ae,(%esp)
c0101e0c:	e8 c6 ee ff ff       	call   c0100cd7 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101e11:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101e12:	c9                   	leave  
c0101e13:	c3                   	ret    

c0101e14 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101e14:	55                   	push   %ebp
c0101e15:	89 e5                	mov    %esp,%ebp
c0101e17:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101e1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e1d:	89 04 24             	mov    %eax,(%esp)
c0101e20:	e8 ce fe ff ff       	call   c0101cf3 <trap_dispatch>
}
c0101e25:	c9                   	leave  
c0101e26:	c3                   	ret    

c0101e27 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101e27:	1e                   	push   %ds
    pushl %es
c0101e28:	06                   	push   %es
    pushl %fs
c0101e29:	0f a0                	push   %fs
    pushl %gs
c0101e2b:	0f a8                	push   %gs
    pushal
c0101e2d:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101e2e:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101e33:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101e35:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101e37:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101e38:	e8 d7 ff ff ff       	call   c0101e14 <trap>

    # pop the pushed stack pointer
    popl %esp
c0101e3d:	5c                   	pop    %esp

c0101e3e <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101e3e:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101e3f:	0f a9                	pop    %gs
    popl %fs
c0101e41:	0f a1                	pop    %fs
    popl %es
c0101e43:	07                   	pop    %es
    popl %ds
c0101e44:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101e45:	83 c4 08             	add    $0x8,%esp
    iret
c0101e48:	cf                   	iret   

c0101e49 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101e49:	6a 00                	push   $0x0
  pushl $0
c0101e4b:	6a 00                	push   $0x0
  jmp __alltraps
c0101e4d:	e9 d5 ff ff ff       	jmp    c0101e27 <__alltraps>

c0101e52 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101e52:	6a 00                	push   $0x0
  pushl $1
c0101e54:	6a 01                	push   $0x1
  jmp __alltraps
c0101e56:	e9 cc ff ff ff       	jmp    c0101e27 <__alltraps>

c0101e5b <vector2>:
.globl vector2
vector2:
  pushl $0
c0101e5b:	6a 00                	push   $0x0
  pushl $2
c0101e5d:	6a 02                	push   $0x2
  jmp __alltraps
c0101e5f:	e9 c3 ff ff ff       	jmp    c0101e27 <__alltraps>

c0101e64 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101e64:	6a 00                	push   $0x0
  pushl $3
c0101e66:	6a 03                	push   $0x3
  jmp __alltraps
c0101e68:	e9 ba ff ff ff       	jmp    c0101e27 <__alltraps>

c0101e6d <vector4>:
.globl vector4
vector4:
  pushl $0
c0101e6d:	6a 00                	push   $0x0
  pushl $4
c0101e6f:	6a 04                	push   $0x4
  jmp __alltraps
c0101e71:	e9 b1 ff ff ff       	jmp    c0101e27 <__alltraps>

c0101e76 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101e76:	6a 00                	push   $0x0
  pushl $5
c0101e78:	6a 05                	push   $0x5
  jmp __alltraps
c0101e7a:	e9 a8 ff ff ff       	jmp    c0101e27 <__alltraps>

c0101e7f <vector6>:
.globl vector6
vector6:
  pushl $0
c0101e7f:	6a 00                	push   $0x0
  pushl $6
c0101e81:	6a 06                	push   $0x6
  jmp __alltraps
c0101e83:	e9 9f ff ff ff       	jmp    c0101e27 <__alltraps>

c0101e88 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101e88:	6a 00                	push   $0x0
  pushl $7
c0101e8a:	6a 07                	push   $0x7
  jmp __alltraps
c0101e8c:	e9 96 ff ff ff       	jmp    c0101e27 <__alltraps>

c0101e91 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101e91:	6a 08                	push   $0x8
  jmp __alltraps
c0101e93:	e9 8f ff ff ff       	jmp    c0101e27 <__alltraps>

c0101e98 <vector9>:
.globl vector9
vector9:
  pushl $9
c0101e98:	6a 09                	push   $0x9
  jmp __alltraps
c0101e9a:	e9 88 ff ff ff       	jmp    c0101e27 <__alltraps>

c0101e9f <vector10>:
.globl vector10
vector10:
  pushl $10
c0101e9f:	6a 0a                	push   $0xa
  jmp __alltraps
c0101ea1:	e9 81 ff ff ff       	jmp    c0101e27 <__alltraps>

c0101ea6 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101ea6:	6a 0b                	push   $0xb
  jmp __alltraps
c0101ea8:	e9 7a ff ff ff       	jmp    c0101e27 <__alltraps>

c0101ead <vector12>:
.globl vector12
vector12:
  pushl $12
c0101ead:	6a 0c                	push   $0xc
  jmp __alltraps
c0101eaf:	e9 73 ff ff ff       	jmp    c0101e27 <__alltraps>

c0101eb4 <vector13>:
.globl vector13
vector13:
  pushl $13
c0101eb4:	6a 0d                	push   $0xd
  jmp __alltraps
c0101eb6:	e9 6c ff ff ff       	jmp    c0101e27 <__alltraps>

c0101ebb <vector14>:
.globl vector14
vector14:
  pushl $14
c0101ebb:	6a 0e                	push   $0xe
  jmp __alltraps
c0101ebd:	e9 65 ff ff ff       	jmp    c0101e27 <__alltraps>

c0101ec2 <vector15>:
.globl vector15
vector15:
  pushl $0
c0101ec2:	6a 00                	push   $0x0
  pushl $15
c0101ec4:	6a 0f                	push   $0xf
  jmp __alltraps
c0101ec6:	e9 5c ff ff ff       	jmp    c0101e27 <__alltraps>

c0101ecb <vector16>:
.globl vector16
vector16:
  pushl $0
c0101ecb:	6a 00                	push   $0x0
  pushl $16
c0101ecd:	6a 10                	push   $0x10
  jmp __alltraps
c0101ecf:	e9 53 ff ff ff       	jmp    c0101e27 <__alltraps>

c0101ed4 <vector17>:
.globl vector17
vector17:
  pushl $17
c0101ed4:	6a 11                	push   $0x11
  jmp __alltraps
c0101ed6:	e9 4c ff ff ff       	jmp    c0101e27 <__alltraps>

c0101edb <vector18>:
.globl vector18
vector18:
  pushl $0
c0101edb:	6a 00                	push   $0x0
  pushl $18
c0101edd:	6a 12                	push   $0x12
  jmp __alltraps
c0101edf:	e9 43 ff ff ff       	jmp    c0101e27 <__alltraps>

c0101ee4 <vector19>:
.globl vector19
vector19:
  pushl $0
c0101ee4:	6a 00                	push   $0x0
  pushl $19
c0101ee6:	6a 13                	push   $0x13
  jmp __alltraps
c0101ee8:	e9 3a ff ff ff       	jmp    c0101e27 <__alltraps>

c0101eed <vector20>:
.globl vector20
vector20:
  pushl $0
c0101eed:	6a 00                	push   $0x0
  pushl $20
c0101eef:	6a 14                	push   $0x14
  jmp __alltraps
c0101ef1:	e9 31 ff ff ff       	jmp    c0101e27 <__alltraps>

c0101ef6 <vector21>:
.globl vector21
vector21:
  pushl $0
c0101ef6:	6a 00                	push   $0x0
  pushl $21
c0101ef8:	6a 15                	push   $0x15
  jmp __alltraps
c0101efa:	e9 28 ff ff ff       	jmp    c0101e27 <__alltraps>

c0101eff <vector22>:
.globl vector22
vector22:
  pushl $0
c0101eff:	6a 00                	push   $0x0
  pushl $22
c0101f01:	6a 16                	push   $0x16
  jmp __alltraps
c0101f03:	e9 1f ff ff ff       	jmp    c0101e27 <__alltraps>

c0101f08 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101f08:	6a 00                	push   $0x0
  pushl $23
c0101f0a:	6a 17                	push   $0x17
  jmp __alltraps
c0101f0c:	e9 16 ff ff ff       	jmp    c0101e27 <__alltraps>

c0101f11 <vector24>:
.globl vector24
vector24:
  pushl $0
c0101f11:	6a 00                	push   $0x0
  pushl $24
c0101f13:	6a 18                	push   $0x18
  jmp __alltraps
c0101f15:	e9 0d ff ff ff       	jmp    c0101e27 <__alltraps>

c0101f1a <vector25>:
.globl vector25
vector25:
  pushl $0
c0101f1a:	6a 00                	push   $0x0
  pushl $25
c0101f1c:	6a 19                	push   $0x19
  jmp __alltraps
c0101f1e:	e9 04 ff ff ff       	jmp    c0101e27 <__alltraps>

c0101f23 <vector26>:
.globl vector26
vector26:
  pushl $0
c0101f23:	6a 00                	push   $0x0
  pushl $26
c0101f25:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101f27:	e9 fb fe ff ff       	jmp    c0101e27 <__alltraps>

c0101f2c <vector27>:
.globl vector27
vector27:
  pushl $0
c0101f2c:	6a 00                	push   $0x0
  pushl $27
c0101f2e:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101f30:	e9 f2 fe ff ff       	jmp    c0101e27 <__alltraps>

c0101f35 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101f35:	6a 00                	push   $0x0
  pushl $28
c0101f37:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101f39:	e9 e9 fe ff ff       	jmp    c0101e27 <__alltraps>

c0101f3e <vector29>:
.globl vector29
vector29:
  pushl $0
c0101f3e:	6a 00                	push   $0x0
  pushl $29
c0101f40:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101f42:	e9 e0 fe ff ff       	jmp    c0101e27 <__alltraps>

c0101f47 <vector30>:
.globl vector30
vector30:
  pushl $0
c0101f47:	6a 00                	push   $0x0
  pushl $30
c0101f49:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101f4b:	e9 d7 fe ff ff       	jmp    c0101e27 <__alltraps>

c0101f50 <vector31>:
.globl vector31
vector31:
  pushl $0
c0101f50:	6a 00                	push   $0x0
  pushl $31
c0101f52:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101f54:	e9 ce fe ff ff       	jmp    c0101e27 <__alltraps>

c0101f59 <vector32>:
.globl vector32
vector32:
  pushl $0
c0101f59:	6a 00                	push   $0x0
  pushl $32
c0101f5b:	6a 20                	push   $0x20
  jmp __alltraps
c0101f5d:	e9 c5 fe ff ff       	jmp    c0101e27 <__alltraps>

c0101f62 <vector33>:
.globl vector33
vector33:
  pushl $0
c0101f62:	6a 00                	push   $0x0
  pushl $33
c0101f64:	6a 21                	push   $0x21
  jmp __alltraps
c0101f66:	e9 bc fe ff ff       	jmp    c0101e27 <__alltraps>

c0101f6b <vector34>:
.globl vector34
vector34:
  pushl $0
c0101f6b:	6a 00                	push   $0x0
  pushl $34
c0101f6d:	6a 22                	push   $0x22
  jmp __alltraps
c0101f6f:	e9 b3 fe ff ff       	jmp    c0101e27 <__alltraps>

c0101f74 <vector35>:
.globl vector35
vector35:
  pushl $0
c0101f74:	6a 00                	push   $0x0
  pushl $35
c0101f76:	6a 23                	push   $0x23
  jmp __alltraps
c0101f78:	e9 aa fe ff ff       	jmp    c0101e27 <__alltraps>

c0101f7d <vector36>:
.globl vector36
vector36:
  pushl $0
c0101f7d:	6a 00                	push   $0x0
  pushl $36
c0101f7f:	6a 24                	push   $0x24
  jmp __alltraps
c0101f81:	e9 a1 fe ff ff       	jmp    c0101e27 <__alltraps>

c0101f86 <vector37>:
.globl vector37
vector37:
  pushl $0
c0101f86:	6a 00                	push   $0x0
  pushl $37
c0101f88:	6a 25                	push   $0x25
  jmp __alltraps
c0101f8a:	e9 98 fe ff ff       	jmp    c0101e27 <__alltraps>

c0101f8f <vector38>:
.globl vector38
vector38:
  pushl $0
c0101f8f:	6a 00                	push   $0x0
  pushl $38
c0101f91:	6a 26                	push   $0x26
  jmp __alltraps
c0101f93:	e9 8f fe ff ff       	jmp    c0101e27 <__alltraps>

c0101f98 <vector39>:
.globl vector39
vector39:
  pushl $0
c0101f98:	6a 00                	push   $0x0
  pushl $39
c0101f9a:	6a 27                	push   $0x27
  jmp __alltraps
c0101f9c:	e9 86 fe ff ff       	jmp    c0101e27 <__alltraps>

c0101fa1 <vector40>:
.globl vector40
vector40:
  pushl $0
c0101fa1:	6a 00                	push   $0x0
  pushl $40
c0101fa3:	6a 28                	push   $0x28
  jmp __alltraps
c0101fa5:	e9 7d fe ff ff       	jmp    c0101e27 <__alltraps>

c0101faa <vector41>:
.globl vector41
vector41:
  pushl $0
c0101faa:	6a 00                	push   $0x0
  pushl $41
c0101fac:	6a 29                	push   $0x29
  jmp __alltraps
c0101fae:	e9 74 fe ff ff       	jmp    c0101e27 <__alltraps>

c0101fb3 <vector42>:
.globl vector42
vector42:
  pushl $0
c0101fb3:	6a 00                	push   $0x0
  pushl $42
c0101fb5:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101fb7:	e9 6b fe ff ff       	jmp    c0101e27 <__alltraps>

c0101fbc <vector43>:
.globl vector43
vector43:
  pushl $0
c0101fbc:	6a 00                	push   $0x0
  pushl $43
c0101fbe:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101fc0:	e9 62 fe ff ff       	jmp    c0101e27 <__alltraps>

c0101fc5 <vector44>:
.globl vector44
vector44:
  pushl $0
c0101fc5:	6a 00                	push   $0x0
  pushl $44
c0101fc7:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101fc9:	e9 59 fe ff ff       	jmp    c0101e27 <__alltraps>

c0101fce <vector45>:
.globl vector45
vector45:
  pushl $0
c0101fce:	6a 00                	push   $0x0
  pushl $45
c0101fd0:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101fd2:	e9 50 fe ff ff       	jmp    c0101e27 <__alltraps>

c0101fd7 <vector46>:
.globl vector46
vector46:
  pushl $0
c0101fd7:	6a 00                	push   $0x0
  pushl $46
c0101fd9:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101fdb:	e9 47 fe ff ff       	jmp    c0101e27 <__alltraps>

c0101fe0 <vector47>:
.globl vector47
vector47:
  pushl $0
c0101fe0:	6a 00                	push   $0x0
  pushl $47
c0101fe2:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101fe4:	e9 3e fe ff ff       	jmp    c0101e27 <__alltraps>

c0101fe9 <vector48>:
.globl vector48
vector48:
  pushl $0
c0101fe9:	6a 00                	push   $0x0
  pushl $48
c0101feb:	6a 30                	push   $0x30
  jmp __alltraps
c0101fed:	e9 35 fe ff ff       	jmp    c0101e27 <__alltraps>

c0101ff2 <vector49>:
.globl vector49
vector49:
  pushl $0
c0101ff2:	6a 00                	push   $0x0
  pushl $49
c0101ff4:	6a 31                	push   $0x31
  jmp __alltraps
c0101ff6:	e9 2c fe ff ff       	jmp    c0101e27 <__alltraps>

c0101ffb <vector50>:
.globl vector50
vector50:
  pushl $0
c0101ffb:	6a 00                	push   $0x0
  pushl $50
c0101ffd:	6a 32                	push   $0x32
  jmp __alltraps
c0101fff:	e9 23 fe ff ff       	jmp    c0101e27 <__alltraps>

c0102004 <vector51>:
.globl vector51
vector51:
  pushl $0
c0102004:	6a 00                	push   $0x0
  pushl $51
c0102006:	6a 33                	push   $0x33
  jmp __alltraps
c0102008:	e9 1a fe ff ff       	jmp    c0101e27 <__alltraps>

c010200d <vector52>:
.globl vector52
vector52:
  pushl $0
c010200d:	6a 00                	push   $0x0
  pushl $52
c010200f:	6a 34                	push   $0x34
  jmp __alltraps
c0102011:	e9 11 fe ff ff       	jmp    c0101e27 <__alltraps>

c0102016 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102016:	6a 00                	push   $0x0
  pushl $53
c0102018:	6a 35                	push   $0x35
  jmp __alltraps
c010201a:	e9 08 fe ff ff       	jmp    c0101e27 <__alltraps>

c010201f <vector54>:
.globl vector54
vector54:
  pushl $0
c010201f:	6a 00                	push   $0x0
  pushl $54
c0102021:	6a 36                	push   $0x36
  jmp __alltraps
c0102023:	e9 ff fd ff ff       	jmp    c0101e27 <__alltraps>

c0102028 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102028:	6a 00                	push   $0x0
  pushl $55
c010202a:	6a 37                	push   $0x37
  jmp __alltraps
c010202c:	e9 f6 fd ff ff       	jmp    c0101e27 <__alltraps>

c0102031 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102031:	6a 00                	push   $0x0
  pushl $56
c0102033:	6a 38                	push   $0x38
  jmp __alltraps
c0102035:	e9 ed fd ff ff       	jmp    c0101e27 <__alltraps>

c010203a <vector57>:
.globl vector57
vector57:
  pushl $0
c010203a:	6a 00                	push   $0x0
  pushl $57
c010203c:	6a 39                	push   $0x39
  jmp __alltraps
c010203e:	e9 e4 fd ff ff       	jmp    c0101e27 <__alltraps>

c0102043 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102043:	6a 00                	push   $0x0
  pushl $58
c0102045:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102047:	e9 db fd ff ff       	jmp    c0101e27 <__alltraps>

c010204c <vector59>:
.globl vector59
vector59:
  pushl $0
c010204c:	6a 00                	push   $0x0
  pushl $59
c010204e:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102050:	e9 d2 fd ff ff       	jmp    c0101e27 <__alltraps>

c0102055 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102055:	6a 00                	push   $0x0
  pushl $60
c0102057:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102059:	e9 c9 fd ff ff       	jmp    c0101e27 <__alltraps>

c010205e <vector61>:
.globl vector61
vector61:
  pushl $0
c010205e:	6a 00                	push   $0x0
  pushl $61
c0102060:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102062:	e9 c0 fd ff ff       	jmp    c0101e27 <__alltraps>

c0102067 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102067:	6a 00                	push   $0x0
  pushl $62
c0102069:	6a 3e                	push   $0x3e
  jmp __alltraps
c010206b:	e9 b7 fd ff ff       	jmp    c0101e27 <__alltraps>

c0102070 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102070:	6a 00                	push   $0x0
  pushl $63
c0102072:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102074:	e9 ae fd ff ff       	jmp    c0101e27 <__alltraps>

c0102079 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102079:	6a 00                	push   $0x0
  pushl $64
c010207b:	6a 40                	push   $0x40
  jmp __alltraps
c010207d:	e9 a5 fd ff ff       	jmp    c0101e27 <__alltraps>

c0102082 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102082:	6a 00                	push   $0x0
  pushl $65
c0102084:	6a 41                	push   $0x41
  jmp __alltraps
c0102086:	e9 9c fd ff ff       	jmp    c0101e27 <__alltraps>

c010208b <vector66>:
.globl vector66
vector66:
  pushl $0
c010208b:	6a 00                	push   $0x0
  pushl $66
c010208d:	6a 42                	push   $0x42
  jmp __alltraps
c010208f:	e9 93 fd ff ff       	jmp    c0101e27 <__alltraps>

c0102094 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102094:	6a 00                	push   $0x0
  pushl $67
c0102096:	6a 43                	push   $0x43
  jmp __alltraps
c0102098:	e9 8a fd ff ff       	jmp    c0101e27 <__alltraps>

c010209d <vector68>:
.globl vector68
vector68:
  pushl $0
c010209d:	6a 00                	push   $0x0
  pushl $68
c010209f:	6a 44                	push   $0x44
  jmp __alltraps
c01020a1:	e9 81 fd ff ff       	jmp    c0101e27 <__alltraps>

c01020a6 <vector69>:
.globl vector69
vector69:
  pushl $0
c01020a6:	6a 00                	push   $0x0
  pushl $69
c01020a8:	6a 45                	push   $0x45
  jmp __alltraps
c01020aa:	e9 78 fd ff ff       	jmp    c0101e27 <__alltraps>

c01020af <vector70>:
.globl vector70
vector70:
  pushl $0
c01020af:	6a 00                	push   $0x0
  pushl $70
c01020b1:	6a 46                	push   $0x46
  jmp __alltraps
c01020b3:	e9 6f fd ff ff       	jmp    c0101e27 <__alltraps>

c01020b8 <vector71>:
.globl vector71
vector71:
  pushl $0
c01020b8:	6a 00                	push   $0x0
  pushl $71
c01020ba:	6a 47                	push   $0x47
  jmp __alltraps
c01020bc:	e9 66 fd ff ff       	jmp    c0101e27 <__alltraps>

c01020c1 <vector72>:
.globl vector72
vector72:
  pushl $0
c01020c1:	6a 00                	push   $0x0
  pushl $72
c01020c3:	6a 48                	push   $0x48
  jmp __alltraps
c01020c5:	e9 5d fd ff ff       	jmp    c0101e27 <__alltraps>

c01020ca <vector73>:
.globl vector73
vector73:
  pushl $0
c01020ca:	6a 00                	push   $0x0
  pushl $73
c01020cc:	6a 49                	push   $0x49
  jmp __alltraps
c01020ce:	e9 54 fd ff ff       	jmp    c0101e27 <__alltraps>

c01020d3 <vector74>:
.globl vector74
vector74:
  pushl $0
c01020d3:	6a 00                	push   $0x0
  pushl $74
c01020d5:	6a 4a                	push   $0x4a
  jmp __alltraps
c01020d7:	e9 4b fd ff ff       	jmp    c0101e27 <__alltraps>

c01020dc <vector75>:
.globl vector75
vector75:
  pushl $0
c01020dc:	6a 00                	push   $0x0
  pushl $75
c01020de:	6a 4b                	push   $0x4b
  jmp __alltraps
c01020e0:	e9 42 fd ff ff       	jmp    c0101e27 <__alltraps>

c01020e5 <vector76>:
.globl vector76
vector76:
  pushl $0
c01020e5:	6a 00                	push   $0x0
  pushl $76
c01020e7:	6a 4c                	push   $0x4c
  jmp __alltraps
c01020e9:	e9 39 fd ff ff       	jmp    c0101e27 <__alltraps>

c01020ee <vector77>:
.globl vector77
vector77:
  pushl $0
c01020ee:	6a 00                	push   $0x0
  pushl $77
c01020f0:	6a 4d                	push   $0x4d
  jmp __alltraps
c01020f2:	e9 30 fd ff ff       	jmp    c0101e27 <__alltraps>

c01020f7 <vector78>:
.globl vector78
vector78:
  pushl $0
c01020f7:	6a 00                	push   $0x0
  pushl $78
c01020f9:	6a 4e                	push   $0x4e
  jmp __alltraps
c01020fb:	e9 27 fd ff ff       	jmp    c0101e27 <__alltraps>

c0102100 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102100:	6a 00                	push   $0x0
  pushl $79
c0102102:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102104:	e9 1e fd ff ff       	jmp    c0101e27 <__alltraps>

c0102109 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102109:	6a 00                	push   $0x0
  pushl $80
c010210b:	6a 50                	push   $0x50
  jmp __alltraps
c010210d:	e9 15 fd ff ff       	jmp    c0101e27 <__alltraps>

c0102112 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102112:	6a 00                	push   $0x0
  pushl $81
c0102114:	6a 51                	push   $0x51
  jmp __alltraps
c0102116:	e9 0c fd ff ff       	jmp    c0101e27 <__alltraps>

c010211b <vector82>:
.globl vector82
vector82:
  pushl $0
c010211b:	6a 00                	push   $0x0
  pushl $82
c010211d:	6a 52                	push   $0x52
  jmp __alltraps
c010211f:	e9 03 fd ff ff       	jmp    c0101e27 <__alltraps>

c0102124 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102124:	6a 00                	push   $0x0
  pushl $83
c0102126:	6a 53                	push   $0x53
  jmp __alltraps
c0102128:	e9 fa fc ff ff       	jmp    c0101e27 <__alltraps>

c010212d <vector84>:
.globl vector84
vector84:
  pushl $0
c010212d:	6a 00                	push   $0x0
  pushl $84
c010212f:	6a 54                	push   $0x54
  jmp __alltraps
c0102131:	e9 f1 fc ff ff       	jmp    c0101e27 <__alltraps>

c0102136 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102136:	6a 00                	push   $0x0
  pushl $85
c0102138:	6a 55                	push   $0x55
  jmp __alltraps
c010213a:	e9 e8 fc ff ff       	jmp    c0101e27 <__alltraps>

c010213f <vector86>:
.globl vector86
vector86:
  pushl $0
c010213f:	6a 00                	push   $0x0
  pushl $86
c0102141:	6a 56                	push   $0x56
  jmp __alltraps
c0102143:	e9 df fc ff ff       	jmp    c0101e27 <__alltraps>

c0102148 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102148:	6a 00                	push   $0x0
  pushl $87
c010214a:	6a 57                	push   $0x57
  jmp __alltraps
c010214c:	e9 d6 fc ff ff       	jmp    c0101e27 <__alltraps>

c0102151 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102151:	6a 00                	push   $0x0
  pushl $88
c0102153:	6a 58                	push   $0x58
  jmp __alltraps
c0102155:	e9 cd fc ff ff       	jmp    c0101e27 <__alltraps>

c010215a <vector89>:
.globl vector89
vector89:
  pushl $0
c010215a:	6a 00                	push   $0x0
  pushl $89
c010215c:	6a 59                	push   $0x59
  jmp __alltraps
c010215e:	e9 c4 fc ff ff       	jmp    c0101e27 <__alltraps>

c0102163 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102163:	6a 00                	push   $0x0
  pushl $90
c0102165:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102167:	e9 bb fc ff ff       	jmp    c0101e27 <__alltraps>

c010216c <vector91>:
.globl vector91
vector91:
  pushl $0
c010216c:	6a 00                	push   $0x0
  pushl $91
c010216e:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102170:	e9 b2 fc ff ff       	jmp    c0101e27 <__alltraps>

c0102175 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102175:	6a 00                	push   $0x0
  pushl $92
c0102177:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102179:	e9 a9 fc ff ff       	jmp    c0101e27 <__alltraps>

c010217e <vector93>:
.globl vector93
vector93:
  pushl $0
c010217e:	6a 00                	push   $0x0
  pushl $93
c0102180:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102182:	e9 a0 fc ff ff       	jmp    c0101e27 <__alltraps>

c0102187 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102187:	6a 00                	push   $0x0
  pushl $94
c0102189:	6a 5e                	push   $0x5e
  jmp __alltraps
c010218b:	e9 97 fc ff ff       	jmp    c0101e27 <__alltraps>

c0102190 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102190:	6a 00                	push   $0x0
  pushl $95
c0102192:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102194:	e9 8e fc ff ff       	jmp    c0101e27 <__alltraps>

c0102199 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102199:	6a 00                	push   $0x0
  pushl $96
c010219b:	6a 60                	push   $0x60
  jmp __alltraps
c010219d:	e9 85 fc ff ff       	jmp    c0101e27 <__alltraps>

c01021a2 <vector97>:
.globl vector97
vector97:
  pushl $0
c01021a2:	6a 00                	push   $0x0
  pushl $97
c01021a4:	6a 61                	push   $0x61
  jmp __alltraps
c01021a6:	e9 7c fc ff ff       	jmp    c0101e27 <__alltraps>

c01021ab <vector98>:
.globl vector98
vector98:
  pushl $0
c01021ab:	6a 00                	push   $0x0
  pushl $98
c01021ad:	6a 62                	push   $0x62
  jmp __alltraps
c01021af:	e9 73 fc ff ff       	jmp    c0101e27 <__alltraps>

c01021b4 <vector99>:
.globl vector99
vector99:
  pushl $0
c01021b4:	6a 00                	push   $0x0
  pushl $99
c01021b6:	6a 63                	push   $0x63
  jmp __alltraps
c01021b8:	e9 6a fc ff ff       	jmp    c0101e27 <__alltraps>

c01021bd <vector100>:
.globl vector100
vector100:
  pushl $0
c01021bd:	6a 00                	push   $0x0
  pushl $100
c01021bf:	6a 64                	push   $0x64
  jmp __alltraps
c01021c1:	e9 61 fc ff ff       	jmp    c0101e27 <__alltraps>

c01021c6 <vector101>:
.globl vector101
vector101:
  pushl $0
c01021c6:	6a 00                	push   $0x0
  pushl $101
c01021c8:	6a 65                	push   $0x65
  jmp __alltraps
c01021ca:	e9 58 fc ff ff       	jmp    c0101e27 <__alltraps>

c01021cf <vector102>:
.globl vector102
vector102:
  pushl $0
c01021cf:	6a 00                	push   $0x0
  pushl $102
c01021d1:	6a 66                	push   $0x66
  jmp __alltraps
c01021d3:	e9 4f fc ff ff       	jmp    c0101e27 <__alltraps>

c01021d8 <vector103>:
.globl vector103
vector103:
  pushl $0
c01021d8:	6a 00                	push   $0x0
  pushl $103
c01021da:	6a 67                	push   $0x67
  jmp __alltraps
c01021dc:	e9 46 fc ff ff       	jmp    c0101e27 <__alltraps>

c01021e1 <vector104>:
.globl vector104
vector104:
  pushl $0
c01021e1:	6a 00                	push   $0x0
  pushl $104
c01021e3:	6a 68                	push   $0x68
  jmp __alltraps
c01021e5:	e9 3d fc ff ff       	jmp    c0101e27 <__alltraps>

c01021ea <vector105>:
.globl vector105
vector105:
  pushl $0
c01021ea:	6a 00                	push   $0x0
  pushl $105
c01021ec:	6a 69                	push   $0x69
  jmp __alltraps
c01021ee:	e9 34 fc ff ff       	jmp    c0101e27 <__alltraps>

c01021f3 <vector106>:
.globl vector106
vector106:
  pushl $0
c01021f3:	6a 00                	push   $0x0
  pushl $106
c01021f5:	6a 6a                	push   $0x6a
  jmp __alltraps
c01021f7:	e9 2b fc ff ff       	jmp    c0101e27 <__alltraps>

c01021fc <vector107>:
.globl vector107
vector107:
  pushl $0
c01021fc:	6a 00                	push   $0x0
  pushl $107
c01021fe:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102200:	e9 22 fc ff ff       	jmp    c0101e27 <__alltraps>

c0102205 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102205:	6a 00                	push   $0x0
  pushl $108
c0102207:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102209:	e9 19 fc ff ff       	jmp    c0101e27 <__alltraps>

c010220e <vector109>:
.globl vector109
vector109:
  pushl $0
c010220e:	6a 00                	push   $0x0
  pushl $109
c0102210:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102212:	e9 10 fc ff ff       	jmp    c0101e27 <__alltraps>

c0102217 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102217:	6a 00                	push   $0x0
  pushl $110
c0102219:	6a 6e                	push   $0x6e
  jmp __alltraps
c010221b:	e9 07 fc ff ff       	jmp    c0101e27 <__alltraps>

c0102220 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102220:	6a 00                	push   $0x0
  pushl $111
c0102222:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102224:	e9 fe fb ff ff       	jmp    c0101e27 <__alltraps>

c0102229 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102229:	6a 00                	push   $0x0
  pushl $112
c010222b:	6a 70                	push   $0x70
  jmp __alltraps
c010222d:	e9 f5 fb ff ff       	jmp    c0101e27 <__alltraps>

c0102232 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102232:	6a 00                	push   $0x0
  pushl $113
c0102234:	6a 71                	push   $0x71
  jmp __alltraps
c0102236:	e9 ec fb ff ff       	jmp    c0101e27 <__alltraps>

c010223b <vector114>:
.globl vector114
vector114:
  pushl $0
c010223b:	6a 00                	push   $0x0
  pushl $114
c010223d:	6a 72                	push   $0x72
  jmp __alltraps
c010223f:	e9 e3 fb ff ff       	jmp    c0101e27 <__alltraps>

c0102244 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102244:	6a 00                	push   $0x0
  pushl $115
c0102246:	6a 73                	push   $0x73
  jmp __alltraps
c0102248:	e9 da fb ff ff       	jmp    c0101e27 <__alltraps>

c010224d <vector116>:
.globl vector116
vector116:
  pushl $0
c010224d:	6a 00                	push   $0x0
  pushl $116
c010224f:	6a 74                	push   $0x74
  jmp __alltraps
c0102251:	e9 d1 fb ff ff       	jmp    c0101e27 <__alltraps>

c0102256 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102256:	6a 00                	push   $0x0
  pushl $117
c0102258:	6a 75                	push   $0x75
  jmp __alltraps
c010225a:	e9 c8 fb ff ff       	jmp    c0101e27 <__alltraps>

c010225f <vector118>:
.globl vector118
vector118:
  pushl $0
c010225f:	6a 00                	push   $0x0
  pushl $118
c0102261:	6a 76                	push   $0x76
  jmp __alltraps
c0102263:	e9 bf fb ff ff       	jmp    c0101e27 <__alltraps>

c0102268 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102268:	6a 00                	push   $0x0
  pushl $119
c010226a:	6a 77                	push   $0x77
  jmp __alltraps
c010226c:	e9 b6 fb ff ff       	jmp    c0101e27 <__alltraps>

c0102271 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102271:	6a 00                	push   $0x0
  pushl $120
c0102273:	6a 78                	push   $0x78
  jmp __alltraps
c0102275:	e9 ad fb ff ff       	jmp    c0101e27 <__alltraps>

c010227a <vector121>:
.globl vector121
vector121:
  pushl $0
c010227a:	6a 00                	push   $0x0
  pushl $121
c010227c:	6a 79                	push   $0x79
  jmp __alltraps
c010227e:	e9 a4 fb ff ff       	jmp    c0101e27 <__alltraps>

c0102283 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102283:	6a 00                	push   $0x0
  pushl $122
c0102285:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102287:	e9 9b fb ff ff       	jmp    c0101e27 <__alltraps>

c010228c <vector123>:
.globl vector123
vector123:
  pushl $0
c010228c:	6a 00                	push   $0x0
  pushl $123
c010228e:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102290:	e9 92 fb ff ff       	jmp    c0101e27 <__alltraps>

c0102295 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102295:	6a 00                	push   $0x0
  pushl $124
c0102297:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102299:	e9 89 fb ff ff       	jmp    c0101e27 <__alltraps>

c010229e <vector125>:
.globl vector125
vector125:
  pushl $0
c010229e:	6a 00                	push   $0x0
  pushl $125
c01022a0:	6a 7d                	push   $0x7d
  jmp __alltraps
c01022a2:	e9 80 fb ff ff       	jmp    c0101e27 <__alltraps>

c01022a7 <vector126>:
.globl vector126
vector126:
  pushl $0
c01022a7:	6a 00                	push   $0x0
  pushl $126
c01022a9:	6a 7e                	push   $0x7e
  jmp __alltraps
c01022ab:	e9 77 fb ff ff       	jmp    c0101e27 <__alltraps>

c01022b0 <vector127>:
.globl vector127
vector127:
  pushl $0
c01022b0:	6a 00                	push   $0x0
  pushl $127
c01022b2:	6a 7f                	push   $0x7f
  jmp __alltraps
c01022b4:	e9 6e fb ff ff       	jmp    c0101e27 <__alltraps>

c01022b9 <vector128>:
.globl vector128
vector128:
  pushl $0
c01022b9:	6a 00                	push   $0x0
  pushl $128
c01022bb:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c01022c0:	e9 62 fb ff ff       	jmp    c0101e27 <__alltraps>

c01022c5 <vector129>:
.globl vector129
vector129:
  pushl $0
c01022c5:	6a 00                	push   $0x0
  pushl $129
c01022c7:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c01022cc:	e9 56 fb ff ff       	jmp    c0101e27 <__alltraps>

c01022d1 <vector130>:
.globl vector130
vector130:
  pushl $0
c01022d1:	6a 00                	push   $0x0
  pushl $130
c01022d3:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c01022d8:	e9 4a fb ff ff       	jmp    c0101e27 <__alltraps>

c01022dd <vector131>:
.globl vector131
vector131:
  pushl $0
c01022dd:	6a 00                	push   $0x0
  pushl $131
c01022df:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c01022e4:	e9 3e fb ff ff       	jmp    c0101e27 <__alltraps>

c01022e9 <vector132>:
.globl vector132
vector132:
  pushl $0
c01022e9:	6a 00                	push   $0x0
  pushl $132
c01022eb:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c01022f0:	e9 32 fb ff ff       	jmp    c0101e27 <__alltraps>

c01022f5 <vector133>:
.globl vector133
vector133:
  pushl $0
c01022f5:	6a 00                	push   $0x0
  pushl $133
c01022f7:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c01022fc:	e9 26 fb ff ff       	jmp    c0101e27 <__alltraps>

c0102301 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102301:	6a 00                	push   $0x0
  pushl $134
c0102303:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102308:	e9 1a fb ff ff       	jmp    c0101e27 <__alltraps>

c010230d <vector135>:
.globl vector135
vector135:
  pushl $0
c010230d:	6a 00                	push   $0x0
  pushl $135
c010230f:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102314:	e9 0e fb ff ff       	jmp    c0101e27 <__alltraps>

c0102319 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102319:	6a 00                	push   $0x0
  pushl $136
c010231b:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102320:	e9 02 fb ff ff       	jmp    c0101e27 <__alltraps>

c0102325 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102325:	6a 00                	push   $0x0
  pushl $137
c0102327:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c010232c:	e9 f6 fa ff ff       	jmp    c0101e27 <__alltraps>

c0102331 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102331:	6a 00                	push   $0x0
  pushl $138
c0102333:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102338:	e9 ea fa ff ff       	jmp    c0101e27 <__alltraps>

c010233d <vector139>:
.globl vector139
vector139:
  pushl $0
c010233d:	6a 00                	push   $0x0
  pushl $139
c010233f:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102344:	e9 de fa ff ff       	jmp    c0101e27 <__alltraps>

c0102349 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102349:	6a 00                	push   $0x0
  pushl $140
c010234b:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102350:	e9 d2 fa ff ff       	jmp    c0101e27 <__alltraps>

c0102355 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102355:	6a 00                	push   $0x0
  pushl $141
c0102357:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c010235c:	e9 c6 fa ff ff       	jmp    c0101e27 <__alltraps>

c0102361 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102361:	6a 00                	push   $0x0
  pushl $142
c0102363:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102368:	e9 ba fa ff ff       	jmp    c0101e27 <__alltraps>

c010236d <vector143>:
.globl vector143
vector143:
  pushl $0
c010236d:	6a 00                	push   $0x0
  pushl $143
c010236f:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102374:	e9 ae fa ff ff       	jmp    c0101e27 <__alltraps>

c0102379 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102379:	6a 00                	push   $0x0
  pushl $144
c010237b:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102380:	e9 a2 fa ff ff       	jmp    c0101e27 <__alltraps>

c0102385 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102385:	6a 00                	push   $0x0
  pushl $145
c0102387:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c010238c:	e9 96 fa ff ff       	jmp    c0101e27 <__alltraps>

c0102391 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102391:	6a 00                	push   $0x0
  pushl $146
c0102393:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102398:	e9 8a fa ff ff       	jmp    c0101e27 <__alltraps>

c010239d <vector147>:
.globl vector147
vector147:
  pushl $0
c010239d:	6a 00                	push   $0x0
  pushl $147
c010239f:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c01023a4:	e9 7e fa ff ff       	jmp    c0101e27 <__alltraps>

c01023a9 <vector148>:
.globl vector148
vector148:
  pushl $0
c01023a9:	6a 00                	push   $0x0
  pushl $148
c01023ab:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c01023b0:	e9 72 fa ff ff       	jmp    c0101e27 <__alltraps>

c01023b5 <vector149>:
.globl vector149
vector149:
  pushl $0
c01023b5:	6a 00                	push   $0x0
  pushl $149
c01023b7:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c01023bc:	e9 66 fa ff ff       	jmp    c0101e27 <__alltraps>

c01023c1 <vector150>:
.globl vector150
vector150:
  pushl $0
c01023c1:	6a 00                	push   $0x0
  pushl $150
c01023c3:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c01023c8:	e9 5a fa ff ff       	jmp    c0101e27 <__alltraps>

c01023cd <vector151>:
.globl vector151
vector151:
  pushl $0
c01023cd:	6a 00                	push   $0x0
  pushl $151
c01023cf:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c01023d4:	e9 4e fa ff ff       	jmp    c0101e27 <__alltraps>

c01023d9 <vector152>:
.globl vector152
vector152:
  pushl $0
c01023d9:	6a 00                	push   $0x0
  pushl $152
c01023db:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c01023e0:	e9 42 fa ff ff       	jmp    c0101e27 <__alltraps>

c01023e5 <vector153>:
.globl vector153
vector153:
  pushl $0
c01023e5:	6a 00                	push   $0x0
  pushl $153
c01023e7:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c01023ec:	e9 36 fa ff ff       	jmp    c0101e27 <__alltraps>

c01023f1 <vector154>:
.globl vector154
vector154:
  pushl $0
c01023f1:	6a 00                	push   $0x0
  pushl $154
c01023f3:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c01023f8:	e9 2a fa ff ff       	jmp    c0101e27 <__alltraps>

c01023fd <vector155>:
.globl vector155
vector155:
  pushl $0
c01023fd:	6a 00                	push   $0x0
  pushl $155
c01023ff:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102404:	e9 1e fa ff ff       	jmp    c0101e27 <__alltraps>

c0102409 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102409:	6a 00                	push   $0x0
  pushl $156
c010240b:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102410:	e9 12 fa ff ff       	jmp    c0101e27 <__alltraps>

c0102415 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102415:	6a 00                	push   $0x0
  pushl $157
c0102417:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c010241c:	e9 06 fa ff ff       	jmp    c0101e27 <__alltraps>

c0102421 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102421:	6a 00                	push   $0x0
  pushl $158
c0102423:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102428:	e9 fa f9 ff ff       	jmp    c0101e27 <__alltraps>

c010242d <vector159>:
.globl vector159
vector159:
  pushl $0
c010242d:	6a 00                	push   $0x0
  pushl $159
c010242f:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102434:	e9 ee f9 ff ff       	jmp    c0101e27 <__alltraps>

c0102439 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102439:	6a 00                	push   $0x0
  pushl $160
c010243b:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102440:	e9 e2 f9 ff ff       	jmp    c0101e27 <__alltraps>

c0102445 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102445:	6a 00                	push   $0x0
  pushl $161
c0102447:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c010244c:	e9 d6 f9 ff ff       	jmp    c0101e27 <__alltraps>

c0102451 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102451:	6a 00                	push   $0x0
  pushl $162
c0102453:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102458:	e9 ca f9 ff ff       	jmp    c0101e27 <__alltraps>

c010245d <vector163>:
.globl vector163
vector163:
  pushl $0
c010245d:	6a 00                	push   $0x0
  pushl $163
c010245f:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102464:	e9 be f9 ff ff       	jmp    c0101e27 <__alltraps>

c0102469 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102469:	6a 00                	push   $0x0
  pushl $164
c010246b:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102470:	e9 b2 f9 ff ff       	jmp    c0101e27 <__alltraps>

c0102475 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102475:	6a 00                	push   $0x0
  pushl $165
c0102477:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c010247c:	e9 a6 f9 ff ff       	jmp    c0101e27 <__alltraps>

c0102481 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102481:	6a 00                	push   $0x0
  pushl $166
c0102483:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102488:	e9 9a f9 ff ff       	jmp    c0101e27 <__alltraps>

c010248d <vector167>:
.globl vector167
vector167:
  pushl $0
c010248d:	6a 00                	push   $0x0
  pushl $167
c010248f:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102494:	e9 8e f9 ff ff       	jmp    c0101e27 <__alltraps>

c0102499 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102499:	6a 00                	push   $0x0
  pushl $168
c010249b:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c01024a0:	e9 82 f9 ff ff       	jmp    c0101e27 <__alltraps>

c01024a5 <vector169>:
.globl vector169
vector169:
  pushl $0
c01024a5:	6a 00                	push   $0x0
  pushl $169
c01024a7:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c01024ac:	e9 76 f9 ff ff       	jmp    c0101e27 <__alltraps>

c01024b1 <vector170>:
.globl vector170
vector170:
  pushl $0
c01024b1:	6a 00                	push   $0x0
  pushl $170
c01024b3:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c01024b8:	e9 6a f9 ff ff       	jmp    c0101e27 <__alltraps>

c01024bd <vector171>:
.globl vector171
vector171:
  pushl $0
c01024bd:	6a 00                	push   $0x0
  pushl $171
c01024bf:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c01024c4:	e9 5e f9 ff ff       	jmp    c0101e27 <__alltraps>

c01024c9 <vector172>:
.globl vector172
vector172:
  pushl $0
c01024c9:	6a 00                	push   $0x0
  pushl $172
c01024cb:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c01024d0:	e9 52 f9 ff ff       	jmp    c0101e27 <__alltraps>

c01024d5 <vector173>:
.globl vector173
vector173:
  pushl $0
c01024d5:	6a 00                	push   $0x0
  pushl $173
c01024d7:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c01024dc:	e9 46 f9 ff ff       	jmp    c0101e27 <__alltraps>

c01024e1 <vector174>:
.globl vector174
vector174:
  pushl $0
c01024e1:	6a 00                	push   $0x0
  pushl $174
c01024e3:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c01024e8:	e9 3a f9 ff ff       	jmp    c0101e27 <__alltraps>

c01024ed <vector175>:
.globl vector175
vector175:
  pushl $0
c01024ed:	6a 00                	push   $0x0
  pushl $175
c01024ef:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c01024f4:	e9 2e f9 ff ff       	jmp    c0101e27 <__alltraps>

c01024f9 <vector176>:
.globl vector176
vector176:
  pushl $0
c01024f9:	6a 00                	push   $0x0
  pushl $176
c01024fb:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102500:	e9 22 f9 ff ff       	jmp    c0101e27 <__alltraps>

c0102505 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102505:	6a 00                	push   $0x0
  pushl $177
c0102507:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c010250c:	e9 16 f9 ff ff       	jmp    c0101e27 <__alltraps>

c0102511 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102511:	6a 00                	push   $0x0
  pushl $178
c0102513:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102518:	e9 0a f9 ff ff       	jmp    c0101e27 <__alltraps>

c010251d <vector179>:
.globl vector179
vector179:
  pushl $0
c010251d:	6a 00                	push   $0x0
  pushl $179
c010251f:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102524:	e9 fe f8 ff ff       	jmp    c0101e27 <__alltraps>

c0102529 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102529:	6a 00                	push   $0x0
  pushl $180
c010252b:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102530:	e9 f2 f8 ff ff       	jmp    c0101e27 <__alltraps>

c0102535 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102535:	6a 00                	push   $0x0
  pushl $181
c0102537:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c010253c:	e9 e6 f8 ff ff       	jmp    c0101e27 <__alltraps>

c0102541 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102541:	6a 00                	push   $0x0
  pushl $182
c0102543:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102548:	e9 da f8 ff ff       	jmp    c0101e27 <__alltraps>

c010254d <vector183>:
.globl vector183
vector183:
  pushl $0
c010254d:	6a 00                	push   $0x0
  pushl $183
c010254f:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102554:	e9 ce f8 ff ff       	jmp    c0101e27 <__alltraps>

c0102559 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102559:	6a 00                	push   $0x0
  pushl $184
c010255b:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102560:	e9 c2 f8 ff ff       	jmp    c0101e27 <__alltraps>

c0102565 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102565:	6a 00                	push   $0x0
  pushl $185
c0102567:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c010256c:	e9 b6 f8 ff ff       	jmp    c0101e27 <__alltraps>

c0102571 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102571:	6a 00                	push   $0x0
  pushl $186
c0102573:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102578:	e9 aa f8 ff ff       	jmp    c0101e27 <__alltraps>

c010257d <vector187>:
.globl vector187
vector187:
  pushl $0
c010257d:	6a 00                	push   $0x0
  pushl $187
c010257f:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102584:	e9 9e f8 ff ff       	jmp    c0101e27 <__alltraps>

c0102589 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102589:	6a 00                	push   $0x0
  pushl $188
c010258b:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102590:	e9 92 f8 ff ff       	jmp    c0101e27 <__alltraps>

c0102595 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102595:	6a 00                	push   $0x0
  pushl $189
c0102597:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c010259c:	e9 86 f8 ff ff       	jmp    c0101e27 <__alltraps>

c01025a1 <vector190>:
.globl vector190
vector190:
  pushl $0
c01025a1:	6a 00                	push   $0x0
  pushl $190
c01025a3:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01025a8:	e9 7a f8 ff ff       	jmp    c0101e27 <__alltraps>

c01025ad <vector191>:
.globl vector191
vector191:
  pushl $0
c01025ad:	6a 00                	push   $0x0
  pushl $191
c01025af:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c01025b4:	e9 6e f8 ff ff       	jmp    c0101e27 <__alltraps>

c01025b9 <vector192>:
.globl vector192
vector192:
  pushl $0
c01025b9:	6a 00                	push   $0x0
  pushl $192
c01025bb:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c01025c0:	e9 62 f8 ff ff       	jmp    c0101e27 <__alltraps>

c01025c5 <vector193>:
.globl vector193
vector193:
  pushl $0
c01025c5:	6a 00                	push   $0x0
  pushl $193
c01025c7:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c01025cc:	e9 56 f8 ff ff       	jmp    c0101e27 <__alltraps>

c01025d1 <vector194>:
.globl vector194
vector194:
  pushl $0
c01025d1:	6a 00                	push   $0x0
  pushl $194
c01025d3:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c01025d8:	e9 4a f8 ff ff       	jmp    c0101e27 <__alltraps>

c01025dd <vector195>:
.globl vector195
vector195:
  pushl $0
c01025dd:	6a 00                	push   $0x0
  pushl $195
c01025df:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c01025e4:	e9 3e f8 ff ff       	jmp    c0101e27 <__alltraps>

c01025e9 <vector196>:
.globl vector196
vector196:
  pushl $0
c01025e9:	6a 00                	push   $0x0
  pushl $196
c01025eb:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c01025f0:	e9 32 f8 ff ff       	jmp    c0101e27 <__alltraps>

c01025f5 <vector197>:
.globl vector197
vector197:
  pushl $0
c01025f5:	6a 00                	push   $0x0
  pushl $197
c01025f7:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c01025fc:	e9 26 f8 ff ff       	jmp    c0101e27 <__alltraps>

c0102601 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102601:	6a 00                	push   $0x0
  pushl $198
c0102603:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102608:	e9 1a f8 ff ff       	jmp    c0101e27 <__alltraps>

c010260d <vector199>:
.globl vector199
vector199:
  pushl $0
c010260d:	6a 00                	push   $0x0
  pushl $199
c010260f:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102614:	e9 0e f8 ff ff       	jmp    c0101e27 <__alltraps>

c0102619 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102619:	6a 00                	push   $0x0
  pushl $200
c010261b:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102620:	e9 02 f8 ff ff       	jmp    c0101e27 <__alltraps>

c0102625 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102625:	6a 00                	push   $0x0
  pushl $201
c0102627:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c010262c:	e9 f6 f7 ff ff       	jmp    c0101e27 <__alltraps>

c0102631 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102631:	6a 00                	push   $0x0
  pushl $202
c0102633:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102638:	e9 ea f7 ff ff       	jmp    c0101e27 <__alltraps>

c010263d <vector203>:
.globl vector203
vector203:
  pushl $0
c010263d:	6a 00                	push   $0x0
  pushl $203
c010263f:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102644:	e9 de f7 ff ff       	jmp    c0101e27 <__alltraps>

c0102649 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102649:	6a 00                	push   $0x0
  pushl $204
c010264b:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102650:	e9 d2 f7 ff ff       	jmp    c0101e27 <__alltraps>

c0102655 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102655:	6a 00                	push   $0x0
  pushl $205
c0102657:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c010265c:	e9 c6 f7 ff ff       	jmp    c0101e27 <__alltraps>

c0102661 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102661:	6a 00                	push   $0x0
  pushl $206
c0102663:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102668:	e9 ba f7 ff ff       	jmp    c0101e27 <__alltraps>

c010266d <vector207>:
.globl vector207
vector207:
  pushl $0
c010266d:	6a 00                	push   $0x0
  pushl $207
c010266f:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102674:	e9 ae f7 ff ff       	jmp    c0101e27 <__alltraps>

c0102679 <vector208>:
.globl vector208
vector208:
  pushl $0
c0102679:	6a 00                	push   $0x0
  pushl $208
c010267b:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102680:	e9 a2 f7 ff ff       	jmp    c0101e27 <__alltraps>

c0102685 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102685:	6a 00                	push   $0x0
  pushl $209
c0102687:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c010268c:	e9 96 f7 ff ff       	jmp    c0101e27 <__alltraps>

c0102691 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102691:	6a 00                	push   $0x0
  pushl $210
c0102693:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102698:	e9 8a f7 ff ff       	jmp    c0101e27 <__alltraps>

c010269d <vector211>:
.globl vector211
vector211:
  pushl $0
c010269d:	6a 00                	push   $0x0
  pushl $211
c010269f:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01026a4:	e9 7e f7 ff ff       	jmp    c0101e27 <__alltraps>

c01026a9 <vector212>:
.globl vector212
vector212:
  pushl $0
c01026a9:	6a 00                	push   $0x0
  pushl $212
c01026ab:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01026b0:	e9 72 f7 ff ff       	jmp    c0101e27 <__alltraps>

c01026b5 <vector213>:
.globl vector213
vector213:
  pushl $0
c01026b5:	6a 00                	push   $0x0
  pushl $213
c01026b7:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01026bc:	e9 66 f7 ff ff       	jmp    c0101e27 <__alltraps>

c01026c1 <vector214>:
.globl vector214
vector214:
  pushl $0
c01026c1:	6a 00                	push   $0x0
  pushl $214
c01026c3:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c01026c8:	e9 5a f7 ff ff       	jmp    c0101e27 <__alltraps>

c01026cd <vector215>:
.globl vector215
vector215:
  pushl $0
c01026cd:	6a 00                	push   $0x0
  pushl $215
c01026cf:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01026d4:	e9 4e f7 ff ff       	jmp    c0101e27 <__alltraps>

c01026d9 <vector216>:
.globl vector216
vector216:
  pushl $0
c01026d9:	6a 00                	push   $0x0
  pushl $216
c01026db:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01026e0:	e9 42 f7 ff ff       	jmp    c0101e27 <__alltraps>

c01026e5 <vector217>:
.globl vector217
vector217:
  pushl $0
c01026e5:	6a 00                	push   $0x0
  pushl $217
c01026e7:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01026ec:	e9 36 f7 ff ff       	jmp    c0101e27 <__alltraps>

c01026f1 <vector218>:
.globl vector218
vector218:
  pushl $0
c01026f1:	6a 00                	push   $0x0
  pushl $218
c01026f3:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c01026f8:	e9 2a f7 ff ff       	jmp    c0101e27 <__alltraps>

c01026fd <vector219>:
.globl vector219
vector219:
  pushl $0
c01026fd:	6a 00                	push   $0x0
  pushl $219
c01026ff:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102704:	e9 1e f7 ff ff       	jmp    c0101e27 <__alltraps>

c0102709 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102709:	6a 00                	push   $0x0
  pushl $220
c010270b:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102710:	e9 12 f7 ff ff       	jmp    c0101e27 <__alltraps>

c0102715 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102715:	6a 00                	push   $0x0
  pushl $221
c0102717:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c010271c:	e9 06 f7 ff ff       	jmp    c0101e27 <__alltraps>

c0102721 <vector222>:
.globl vector222
vector222:
  pushl $0
c0102721:	6a 00                	push   $0x0
  pushl $222
c0102723:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102728:	e9 fa f6 ff ff       	jmp    c0101e27 <__alltraps>

c010272d <vector223>:
.globl vector223
vector223:
  pushl $0
c010272d:	6a 00                	push   $0x0
  pushl $223
c010272f:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102734:	e9 ee f6 ff ff       	jmp    c0101e27 <__alltraps>

c0102739 <vector224>:
.globl vector224
vector224:
  pushl $0
c0102739:	6a 00                	push   $0x0
  pushl $224
c010273b:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102740:	e9 e2 f6 ff ff       	jmp    c0101e27 <__alltraps>

c0102745 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102745:	6a 00                	push   $0x0
  pushl $225
c0102747:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c010274c:	e9 d6 f6 ff ff       	jmp    c0101e27 <__alltraps>

c0102751 <vector226>:
.globl vector226
vector226:
  pushl $0
c0102751:	6a 00                	push   $0x0
  pushl $226
c0102753:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102758:	e9 ca f6 ff ff       	jmp    c0101e27 <__alltraps>

c010275d <vector227>:
.globl vector227
vector227:
  pushl $0
c010275d:	6a 00                	push   $0x0
  pushl $227
c010275f:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0102764:	e9 be f6 ff ff       	jmp    c0101e27 <__alltraps>

c0102769 <vector228>:
.globl vector228
vector228:
  pushl $0
c0102769:	6a 00                	push   $0x0
  pushl $228
c010276b:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102770:	e9 b2 f6 ff ff       	jmp    c0101e27 <__alltraps>

c0102775 <vector229>:
.globl vector229
vector229:
  pushl $0
c0102775:	6a 00                	push   $0x0
  pushl $229
c0102777:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c010277c:	e9 a6 f6 ff ff       	jmp    c0101e27 <__alltraps>

c0102781 <vector230>:
.globl vector230
vector230:
  pushl $0
c0102781:	6a 00                	push   $0x0
  pushl $230
c0102783:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102788:	e9 9a f6 ff ff       	jmp    c0101e27 <__alltraps>

c010278d <vector231>:
.globl vector231
vector231:
  pushl $0
c010278d:	6a 00                	push   $0x0
  pushl $231
c010278f:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0102794:	e9 8e f6 ff ff       	jmp    c0101e27 <__alltraps>

c0102799 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102799:	6a 00                	push   $0x0
  pushl $232
c010279b:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01027a0:	e9 82 f6 ff ff       	jmp    c0101e27 <__alltraps>

c01027a5 <vector233>:
.globl vector233
vector233:
  pushl $0
c01027a5:	6a 00                	push   $0x0
  pushl $233
c01027a7:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01027ac:	e9 76 f6 ff ff       	jmp    c0101e27 <__alltraps>

c01027b1 <vector234>:
.globl vector234
vector234:
  pushl $0
c01027b1:	6a 00                	push   $0x0
  pushl $234
c01027b3:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01027b8:	e9 6a f6 ff ff       	jmp    c0101e27 <__alltraps>

c01027bd <vector235>:
.globl vector235
vector235:
  pushl $0
c01027bd:	6a 00                	push   $0x0
  pushl $235
c01027bf:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01027c4:	e9 5e f6 ff ff       	jmp    c0101e27 <__alltraps>

c01027c9 <vector236>:
.globl vector236
vector236:
  pushl $0
c01027c9:	6a 00                	push   $0x0
  pushl $236
c01027cb:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01027d0:	e9 52 f6 ff ff       	jmp    c0101e27 <__alltraps>

c01027d5 <vector237>:
.globl vector237
vector237:
  pushl $0
c01027d5:	6a 00                	push   $0x0
  pushl $237
c01027d7:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01027dc:	e9 46 f6 ff ff       	jmp    c0101e27 <__alltraps>

c01027e1 <vector238>:
.globl vector238
vector238:
  pushl $0
c01027e1:	6a 00                	push   $0x0
  pushl $238
c01027e3:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01027e8:	e9 3a f6 ff ff       	jmp    c0101e27 <__alltraps>

c01027ed <vector239>:
.globl vector239
vector239:
  pushl $0
c01027ed:	6a 00                	push   $0x0
  pushl $239
c01027ef:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01027f4:	e9 2e f6 ff ff       	jmp    c0101e27 <__alltraps>

c01027f9 <vector240>:
.globl vector240
vector240:
  pushl $0
c01027f9:	6a 00                	push   $0x0
  pushl $240
c01027fb:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102800:	e9 22 f6 ff ff       	jmp    c0101e27 <__alltraps>

c0102805 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102805:	6a 00                	push   $0x0
  pushl $241
c0102807:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c010280c:	e9 16 f6 ff ff       	jmp    c0101e27 <__alltraps>

c0102811 <vector242>:
.globl vector242
vector242:
  pushl $0
c0102811:	6a 00                	push   $0x0
  pushl $242
c0102813:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102818:	e9 0a f6 ff ff       	jmp    c0101e27 <__alltraps>

c010281d <vector243>:
.globl vector243
vector243:
  pushl $0
c010281d:	6a 00                	push   $0x0
  pushl $243
c010281f:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102824:	e9 fe f5 ff ff       	jmp    c0101e27 <__alltraps>

c0102829 <vector244>:
.globl vector244
vector244:
  pushl $0
c0102829:	6a 00                	push   $0x0
  pushl $244
c010282b:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102830:	e9 f2 f5 ff ff       	jmp    c0101e27 <__alltraps>

c0102835 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102835:	6a 00                	push   $0x0
  pushl $245
c0102837:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c010283c:	e9 e6 f5 ff ff       	jmp    c0101e27 <__alltraps>

c0102841 <vector246>:
.globl vector246
vector246:
  pushl $0
c0102841:	6a 00                	push   $0x0
  pushl $246
c0102843:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102848:	e9 da f5 ff ff       	jmp    c0101e27 <__alltraps>

c010284d <vector247>:
.globl vector247
vector247:
  pushl $0
c010284d:	6a 00                	push   $0x0
  pushl $247
c010284f:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102854:	e9 ce f5 ff ff       	jmp    c0101e27 <__alltraps>

c0102859 <vector248>:
.globl vector248
vector248:
  pushl $0
c0102859:	6a 00                	push   $0x0
  pushl $248
c010285b:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0102860:	e9 c2 f5 ff ff       	jmp    c0101e27 <__alltraps>

c0102865 <vector249>:
.globl vector249
vector249:
  pushl $0
c0102865:	6a 00                	push   $0x0
  pushl $249
c0102867:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c010286c:	e9 b6 f5 ff ff       	jmp    c0101e27 <__alltraps>

c0102871 <vector250>:
.globl vector250
vector250:
  pushl $0
c0102871:	6a 00                	push   $0x0
  pushl $250
c0102873:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102878:	e9 aa f5 ff ff       	jmp    c0101e27 <__alltraps>

c010287d <vector251>:
.globl vector251
vector251:
  pushl $0
c010287d:	6a 00                	push   $0x0
  pushl $251
c010287f:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0102884:	e9 9e f5 ff ff       	jmp    c0101e27 <__alltraps>

c0102889 <vector252>:
.globl vector252
vector252:
  pushl $0
c0102889:	6a 00                	push   $0x0
  pushl $252
c010288b:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102890:	e9 92 f5 ff ff       	jmp    c0101e27 <__alltraps>

c0102895 <vector253>:
.globl vector253
vector253:
  pushl $0
c0102895:	6a 00                	push   $0x0
  pushl $253
c0102897:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c010289c:	e9 86 f5 ff ff       	jmp    c0101e27 <__alltraps>

c01028a1 <vector254>:
.globl vector254
vector254:
  pushl $0
c01028a1:	6a 00                	push   $0x0
  pushl $254
c01028a3:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01028a8:	e9 7a f5 ff ff       	jmp    c0101e27 <__alltraps>

c01028ad <vector255>:
.globl vector255
vector255:
  pushl $0
c01028ad:	6a 00                	push   $0x0
  pushl $255
c01028af:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01028b4:	e9 6e f5 ff ff       	jmp    c0101e27 <__alltraps>

c01028b9 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01028b9:	55                   	push   %ebp
c01028ba:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01028bc:	8b 55 08             	mov    0x8(%ebp),%edx
c01028bf:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c01028c4:	29 c2                	sub    %eax,%edx
c01028c6:	89 d0                	mov    %edx,%eax
c01028c8:	c1 f8 02             	sar    $0x2,%eax
c01028cb:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01028d1:	5d                   	pop    %ebp
c01028d2:	c3                   	ret    

c01028d3 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01028d3:	55                   	push   %ebp
c01028d4:	89 e5                	mov    %esp,%ebp
c01028d6:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01028d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01028dc:	89 04 24             	mov    %eax,(%esp)
c01028df:	e8 d5 ff ff ff       	call   c01028b9 <page2ppn>
c01028e4:	c1 e0 0c             	shl    $0xc,%eax
}
c01028e7:	c9                   	leave  
c01028e8:	c3                   	ret    

c01028e9 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c01028e9:	55                   	push   %ebp
c01028ea:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01028ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01028ef:	8b 00                	mov    (%eax),%eax
}
c01028f1:	5d                   	pop    %ebp
c01028f2:	c3                   	ret    

c01028f3 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01028f3:	55                   	push   %ebp
c01028f4:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01028f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01028f9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01028fc:	89 10                	mov    %edx,(%eax)
}
c01028fe:	5d                   	pop    %ebp
c01028ff:	c3                   	ret    

c0102900 <default_init>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

// 初始化，不涉及探测可用空间的任务，只是准备好一个空的数据结构
static void
default_init(void) {
c0102900:	55                   	push   %ebp
c0102901:	89 e5                	mov    %esp,%ebp
c0102903:	83 ec 10             	sub    $0x10,%esp
c0102906:	c7 45 fc 50 89 11 c0 	movl   $0xc0118950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010290d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102910:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102913:	89 50 04             	mov    %edx,0x4(%eax)
c0102916:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102919:	8b 50 04             	mov    0x4(%eax),%edx
c010291c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010291f:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0102921:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c0102928:	00 00 00 
}
c010292b:	c9                   	leave  
c010292c:	c3                   	ret    

c010292d <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c010292d:	55                   	push   %ebp
c010292e:	89 e5                	mov    %esp,%ebp
c0102930:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c0102933:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102937:	75 24                	jne    c010295d <default_init_memmap+0x30>
c0102939:	c7 44 24 0c 50 65 10 	movl   $0xc0106550,0xc(%esp)
c0102940:	c0 
c0102941:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c0102948:	c0 
c0102949:	c7 44 24 04 47 00 00 	movl   $0x47,0x4(%esp)
c0102950:	00 
c0102951:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0102958:	e8 7a e3 ff ff       	call   c0100cd7 <__panic>
    struct Page *p = base;
c010295d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102960:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102963:	e9 96 00 00 00       	jmp    c01029fe <default_init_memmap+0xd1>
		// 初始化这一块的每一页
        assert(PageReserved(p));   // 之前已经设为了reserved
c0102968:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010296b:	83 c0 04             	add    $0x4,%eax
c010296e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102975:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102978:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010297b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010297e:	0f a3 10             	bt     %edx,(%eax)
c0102981:	19 c0                	sbb    %eax,%eax
c0102983:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0102986:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010298a:	0f 95 c0             	setne  %al
c010298d:	0f b6 c0             	movzbl %al,%eax
c0102990:	85 c0                	test   %eax,%eax
c0102992:	75 24                	jne    c01029b8 <default_init_memmap+0x8b>
c0102994:	c7 44 24 0c 81 65 10 	movl   $0xc0106581,0xc(%esp)
c010299b:	c0 
c010299c:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c01029a3:	c0 
c01029a4:	c7 44 24 04 4b 00 00 	movl   $0x4b,0x4(%esp)
c01029ab:	00 
c01029ac:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c01029b3:	e8 1f e3 ff ff       	call   c0100cd7 <__panic>
        p->flags = p->property = 0;
c01029b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029bb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c01029c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029c5:	8b 50 08             	mov    0x8(%eax),%edx
c01029c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029cb:	89 50 04             	mov    %edx,0x4(%eax)
		SetPageProperty(p);   // 把该页设置为valid
c01029ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029d1:	83 c0 04             	add    $0x4,%eax
c01029d4:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c01029db:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01029de:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01029e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01029e4:	0f ab 10             	bts    %edx,(%eax)
        set_page_ref(p, 0);   // 引用计数设置为0
c01029e7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01029ee:	00 
c01029ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029f2:	89 04 24             	mov    %eax,(%esp)
c01029f5:	e8 f9 fe ff ff       	call   c01028f3 <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c01029fa:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c01029fe:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a01:	89 d0                	mov    %edx,%eax
c0102a03:	c1 e0 02             	shl    $0x2,%eax
c0102a06:	01 d0                	add    %edx,%eax
c0102a08:	c1 e0 02             	shl    $0x2,%eax
c0102a0b:	89 c2                	mov    %eax,%edx
c0102a0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a10:	01 d0                	add    %edx,%eax
c0102a12:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102a15:	0f 85 4d ff ff ff    	jne    c0102968 <default_init_memmap+0x3b>
        p->flags = p->property = 0;
		SetPageProperty(p);   // 把该页设置为valid
        set_page_ref(p, 0);   // 引用计数设置为0
    }
	// 只有第一页要设置空闲页号为n
    base->property = n;
c0102a1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a1e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a21:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102a24:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a27:	83 c0 04             	add    $0x4,%eax
c0102a2a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
c0102a31:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0102a34:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102a37:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102a3a:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c0102a3d:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c0102a43:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102a46:	01 d0                	add    %edx,%eax
c0102a48:	a3 58 89 11 c0       	mov    %eax,0xc0118958
    list_add(&free_list, &(base->page_link));  // 向后顺序加，按地址递增
c0102a4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a50:	83 c0 0c             	add    $0xc,%eax
c0102a53:	c7 45 d4 50 89 11 c0 	movl   $0xc0118950,-0x2c(%ebp)
c0102a5a:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102a5d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102a60:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0102a63:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102a66:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102a69:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102a6c:	8b 40 04             	mov    0x4(%eax),%eax
c0102a6f:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102a72:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0102a75:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102a78:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0102a7b:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102a7e:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102a81:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102a84:	89 10                	mov    %edx,(%eax)
c0102a86:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102a89:	8b 10                	mov    (%eax),%edx
c0102a8b:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102a8e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102a91:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102a94:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102a97:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102a9a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102a9d:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102aa0:	89 10                	mov    %edx,(%eax)
}
c0102aa2:	c9                   	leave  
c0102aa3:	c3                   	ret    

c0102aa4 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0102aa4:	55                   	push   %ebp
c0102aa5:	89 e5                	mov    %esp,%ebp
c0102aa7:	83 ec 68             	sub    $0x68,%esp
	// 边界判断，避免错误
    assert(n > 0);
c0102aaa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102aae:	75 24                	jne    c0102ad4 <default_alloc_pages+0x30>
c0102ab0:	c7 44 24 0c 50 65 10 	movl   $0xc0106550,0xc(%esp)
c0102ab7:	c0 
c0102ab8:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c0102abf:	c0 
c0102ac0:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0102ac7:	00 
c0102ac8:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0102acf:	e8 03 e2 ff ff       	call   c0100cd7 <__panic>
    if (n > nr_free) {
c0102ad4:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102ad9:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102adc:	73 0a                	jae    c0102ae8 <default_alloc_pages+0x44>
        return NULL;
c0102ade:	b8 00 00 00 00       	mov    $0x0,%eax
c0102ae3:	e9 6a 01 00 00       	jmp    c0102c52 <default_alloc_pages+0x1ae>
    }
    struct Page *page = NULL;   // 命中的结果
c0102ae8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	// 遍历空闲空间链表
    list_entry_t *le = &free_list;
c0102aef:	c7 45 f0 50 89 11 c0 	movl   $0xc0118950,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0102af6:	eb 1c                	jmp    c0102b14 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c0102af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102afb:	83 e8 0c             	sub    $0xc,%eax
c0102afe:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (p->property >= n) {
c0102b01:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102b04:	8b 40 08             	mov    0x8(%eax),%eax
c0102b07:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102b0a:	72 08                	jb     c0102b14 <default_alloc_pages+0x70>
            page = p;
c0102b0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102b0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0102b12:	eb 18                	jmp    c0102b2c <default_alloc_pages+0x88>
c0102b14:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102b17:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102b1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102b1d:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;
    }
    struct Page *page = NULL;   // 命中的结果
	// 遍历空闲空间链表
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0102b20:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102b23:	81 7d f0 50 89 11 c0 	cmpl   $0xc0118950,-0x10(%ebp)
c0102b2a:	75 cc                	jne    c0102af8 <default_alloc_pages+0x54>
            page = p;
            break;
        }
    }
	// 若命中，分配之
    if (page != NULL) {
c0102b2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102b30:	0f 84 19 01 00 00    	je     c0102c4f <default_alloc_pages+0x1ab>
		// 首先把已经分配的n块设为不可用
		struct Page *current_page = page;
c0102b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b39:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for (; current_page != page + n; current_page++) {
c0102b3c:	eb 36                	jmp    c0102b74 <default_alloc_pages+0xd0>
			ClearPageProperty(current_page);
c0102b3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102b41:	83 c0 04             	add    $0x4,%eax
c0102b44:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
c0102b4b:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102b4e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102b51:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102b54:	0f b3 10             	btr    %edx,(%eax)
			ClearPageReserved(current_page);   // 释放时检查
c0102b57:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102b5a:	83 c0 04             	add    $0x4,%eax
c0102b5d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
c0102b64:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102b67:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102b6a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102b6d:	0f b3 10             	btr    %edx,(%eax)
    }
	// 若命中，分配之
    if (page != NULL) {
		// 首先把已经分配的n块设为不可用
		struct Page *current_page = page;
		for (; current_page != page + n; current_page++) {
c0102b70:	83 45 ec 14          	addl   $0x14,-0x14(%ebp)
c0102b74:	8b 55 08             	mov    0x8(%ebp),%edx
c0102b77:	89 d0                	mov    %edx,%eax
c0102b79:	c1 e0 02             	shl    $0x2,%eax
c0102b7c:	01 d0                	add    %edx,%eax
c0102b7e:	c1 e0 02             	shl    $0x2,%eax
c0102b81:	89 c2                	mov    %eax,%edx
c0102b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b86:	01 d0                	add    %edx,%eax
c0102b88:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0102b8b:	75 b1                	jne    c0102b3e <default_alloc_pages+0x9a>
			ClearPageProperty(current_page);
			ClearPageReserved(current_page);   // 释放时检查
		}
        if (page->property > n) {
c0102b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b90:	8b 40 08             	mov    0x8(%eax),%eax
c0102b93:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102b96:	76 7f                	jbe    c0102c17 <default_alloc_pages+0x173>
            struct Page *p = page + n;    // 剩下那块的首地址
c0102b98:	8b 55 08             	mov    0x8(%ebp),%edx
c0102b9b:	89 d0                	mov    %edx,%eax
c0102b9d:	c1 e0 02             	shl    $0x2,%eax
c0102ba0:	01 d0                	add    %edx,%eax
c0102ba2:	c1 e0 02             	shl    $0x2,%eax
c0102ba5:	89 c2                	mov    %eax,%edx
c0102ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102baa:	01 d0                	add    %edx,%eax
c0102bac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            p->property = page->property - n;
c0102baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bb2:	8b 40 08             	mov    0x8(%eax),%eax
c0102bb5:	2b 45 08             	sub    0x8(%ebp),%eax
c0102bb8:	89 c2                	mov    %eax,%edx
c0102bba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102bbd:	89 50 08             	mov    %edx,0x8(%eax)
			// 这一块插在分配出去的那块之后
            list_add(&(page->page_link), &(p->page_link));
c0102bc0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102bc3:	83 c0 0c             	add    $0xc,%eax
c0102bc6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102bc9:	83 c2 0c             	add    $0xc,%edx
c0102bcc:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0102bcf:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102bd2:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102bd5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0102bd8:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102bdb:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102bde:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102be1:	8b 40 04             	mov    0x4(%eax),%eax
c0102be4:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102be7:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0102bea:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102bed:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0102bf0:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102bf3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102bf6:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102bf9:	89 10                	mov    %edx,(%eax)
c0102bfb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102bfe:	8b 10                	mov    (%eax),%edx
c0102c00:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102c03:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102c06:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102c09:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102c0c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102c0f:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102c12:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102c15:	89 10                	mov    %edx,(%eax)
		}
		list_del(&(page->page_link));
c0102c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c1a:	83 c0 0c             	add    $0xc,%eax
c0102c1d:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102c20:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102c23:	8b 40 04             	mov    0x4(%eax),%eax
c0102c26:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102c29:	8b 12                	mov    (%edx),%edx
c0102c2b:	89 55 ac             	mov    %edx,-0x54(%ebp)
c0102c2e:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102c31:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102c34:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102c37:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102c3a:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102c3d:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0102c40:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
c0102c42:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102c47:	2b 45 08             	sub    0x8(%ebp),%eax
c0102c4a:	a3 58 89 11 c0       	mov    %eax,0xc0118958
    }
    return page;
c0102c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102c52:	c9                   	leave  
c0102c53:	c3                   	ret    

c0102c54 <default_free_pages>:
    nr_free += n;
    return;
}
*/
static void
default_free_pages(struct Page *base, size_t n) {
c0102c54:	55                   	push   %ebp
c0102c55:	89 e5                	mov    %esp,%ebp
c0102c57:	83 ec 68             	sub    $0x68,%esp
	assert(n > 0);
c0102c5a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102c5e:	75 24                	jne    c0102c84 <default_free_pages+0x30>
c0102c60:	c7 44 24 0c 50 65 10 	movl   $0xc0106550,0xc(%esp)
c0102c67:	c0 
c0102c68:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c0102c6f:	c0 
c0102c70:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
c0102c77:	00 
c0102c78:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0102c7f:	e8 53 e0 ff ff       	call   c0100cd7 <__panic>
	
	base->flags = 0;
c0102c84:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c87:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	base->property = n;
c0102c8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c91:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102c94:	89 50 08             	mov    %edx,0x8(%eax)
	ClearPageReserved(base);
c0102c97:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c9a:	83 c0 04             	add    $0x4,%eax
c0102c9d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102ca4:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0102ca7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102caa:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102cad:	0f b3 10             	btr    %edx,(%eax)
	SetPageProperty(base);
c0102cb0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cb3:	83 c0 04             	add    $0x4,%eax
c0102cb6:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0102cbd:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102cc0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102cc3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102cc6:	0f ab 10             	bts    %edx,(%eax)
	set_page_ref(base, 0);
c0102cc9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102cd0:	00 
c0102cd1:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cd4:	89 04 24             	mov    %eax,(%esp)
c0102cd7:	e8 17 fc ff ff       	call   c01028f3 <set_page_ref>

	struct Page * p;
	list_entry_t *le = &free_list;
c0102cdc:	c7 45 f0 50 89 11 c0 	movl   $0xc0118950,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0102ce3:	eb 24                	jmp    c0102d09 <default_free_pages+0xb5>
        p = le2page(le, page_link);
c0102ce5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ce8:	83 e8 0c             	sub    $0xc,%eax
c0102ceb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(p >= base + n) {
c0102cee:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102cf1:	89 d0                	mov    %edx,%eax
c0102cf3:	c1 e0 02             	shl    $0x2,%eax
c0102cf6:	01 d0                	add    %edx,%eax
c0102cf8:	c1 e0 02             	shl    $0x2,%eax
c0102cfb:	89 c2                	mov    %eax,%edx
c0102cfd:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d00:	01 d0                	add    %edx,%eax
c0102d02:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102d05:	77 02                	ja     c0102d09 <default_free_pages+0xb5>
			break;
c0102d07:	eb 18                	jmp    c0102d21 <default_free_pages+0xcd>
c0102d09:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d0c:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102d0f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102d12:	8b 40 04             	mov    0x4(%eax),%eax
	SetPageProperty(base);
	set_page_ref(base, 0);

	struct Page * p;
	list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0102d15:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102d18:	81 7d f0 50 89 11 c0 	cmpl   $0xc0118950,-0x10(%ebp)
c0102d1f:	75 c4                	jne    c0102ce5 <default_free_pages+0x91>
        p = le2page(le, page_link);
		if(p >= base + n) {
			break;
		}
	}
	list_add_before(le,&(base->page_link));
c0102d21:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d24:	8d 50 0c             	lea    0xc(%eax),%edx
c0102d27:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d2a:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0102d2d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102d30:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102d33:	8b 00                	mov    (%eax),%eax
c0102d35:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102d38:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0102d3b:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0102d3e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102d41:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102d44:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102d47:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102d4a:	89 10                	mov    %edx,(%eax)
c0102d4c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102d4f:	8b 10                	mov    (%eax),%edx
c0102d51:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102d54:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102d57:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102d5a:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102d5d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102d60:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102d63:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102d66:	89 10                	mov    %edx,(%eax)
    if (base + n == p) {
c0102d68:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d6b:	89 d0                	mov    %edx,%eax
c0102d6d:	c1 e0 02             	shl    $0x2,%eax
c0102d70:	01 d0                	add    %edx,%eax
c0102d72:	c1 e0 02             	shl    $0x2,%eax
c0102d75:	89 c2                	mov    %eax,%edx
c0102d77:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d7a:	01 d0                	add    %edx,%eax
c0102d7c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102d7f:	75 49                	jne    c0102dca <default_free_pages+0x176>
        base->property += p->property;
c0102d81:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d84:	8b 50 08             	mov    0x8(%eax),%edx
c0102d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d8a:	8b 40 08             	mov    0x8(%eax),%eax
c0102d8d:	01 c2                	add    %eax,%edx
c0102d8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d92:	89 50 08             	mov    %edx,0x8(%eax)
		p->property = 0;
c0102d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d98:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		list_del(&(p->page_link));
c0102d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102da2:	83 c0 0c             	add    $0xc,%eax
c0102da5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102da8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102dab:	8b 40 04             	mov    0x4(%eax),%eax
c0102dae:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102db1:	8b 12                	mov    (%edx),%edx
c0102db3:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0102db6:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102db9:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102dbc:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102dbf:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102dc2:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102dc5:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102dc8:	89 10                	mov    %edx,(%eax)
    }
	le = list_prev(&(base->page_link));
c0102dca:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dcd:	83 c0 0c             	add    $0xc,%eax
c0102dd0:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0102dd3:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102dd6:	8b 00                	mov    (%eax),%eax
c0102dd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	p = le2page(le,page_link);
c0102ddb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102dde:	83 e8 0c             	sub    $0xc,%eax
c0102de1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p + p->property == base) {
c0102de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102de7:	8b 50 08             	mov    0x8(%eax),%edx
c0102dea:	89 d0                	mov    %edx,%eax
c0102dec:	c1 e0 02             	shl    $0x2,%eax
c0102def:	01 d0                	add    %edx,%eax
c0102df1:	c1 e0 02             	shl    $0x2,%eax
c0102df4:	89 c2                	mov    %eax,%edx
c0102df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102df9:	01 d0                	add    %edx,%eax
c0102dfb:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102dfe:	75 49                	jne    c0102e49 <default_free_pages+0x1f5>
        p->property += base->property;
c0102e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e03:	8b 50 08             	mov    0x8(%eax),%edx
c0102e06:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e09:	8b 40 08             	mov    0x8(%eax),%eax
c0102e0c:	01 c2                	add    %eax,%edx
c0102e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e11:	89 50 08             	mov    %edx,0x8(%eax)
		base->property = 0;
c0102e14:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e17:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		list_del(&(base->page_link));
c0102e1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e21:	83 c0 0c             	add    $0xc,%eax
c0102e24:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102e27:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102e2a:	8b 40 04             	mov    0x4(%eax),%eax
c0102e2d:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102e30:	8b 12                	mov    (%edx),%edx
c0102e32:	89 55 b0             	mov    %edx,-0x50(%ebp)
c0102e35:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102e38:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102e3b:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0102e3e:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102e41:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102e44:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102e47:	89 10                	mov    %edx,(%eax)
    }
    nr_free += n;
c0102e49:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c0102e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102e52:	01 d0                	add    %edx,%eax
c0102e54:	a3 58 89 11 c0       	mov    %eax,0xc0118958
	return ;
c0102e59:	90                   	nop
}
c0102e5a:	c9                   	leave  
c0102e5b:	c3                   	ret    

c0102e5c <default_nr_free_pages>:



static size_t
default_nr_free_pages(void) {
c0102e5c:	55                   	push   %ebp
c0102e5d:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102e5f:	a1 58 89 11 c0       	mov    0xc0118958,%eax
}
c0102e64:	5d                   	pop    %ebp
c0102e65:	c3                   	ret    

c0102e66 <basic_check>:

static void
basic_check(void) {
c0102e66:	55                   	push   %ebp
c0102e67:	89 e5                	mov    %esp,%ebp
c0102e69:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102e6c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e76:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102e79:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e7c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102e7f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102e86:	e8 90 0e 00 00       	call   c0103d1b <alloc_pages>
c0102e8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102e8e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102e92:	75 24                	jne    c0102eb8 <basic_check+0x52>
c0102e94:	c7 44 24 0c 91 65 10 	movl   $0xc0106591,0xc(%esp)
c0102e9b:	c0 
c0102e9c:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c0102ea3:	c0 
c0102ea4:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c0102eab:	00 
c0102eac:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0102eb3:	e8 1f de ff ff       	call   c0100cd7 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102eb8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102ebf:	e8 57 0e 00 00       	call   c0103d1b <alloc_pages>
c0102ec4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102ec7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102ecb:	75 24                	jne    c0102ef1 <basic_check+0x8b>
c0102ecd:	c7 44 24 0c ad 65 10 	movl   $0xc01065ad,0xc(%esp)
c0102ed4:	c0 
c0102ed5:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c0102edc:	c0 
c0102edd:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0102ee4:	00 
c0102ee5:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0102eec:	e8 e6 dd ff ff       	call   c0100cd7 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102ef1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102ef8:	e8 1e 0e 00 00       	call   c0103d1b <alloc_pages>
c0102efd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102f00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102f04:	75 24                	jne    c0102f2a <basic_check+0xc4>
c0102f06:	c7 44 24 0c c9 65 10 	movl   $0xc01065c9,0xc(%esp)
c0102f0d:	c0 
c0102f0e:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c0102f15:	c0 
c0102f16:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0102f1d:	00 
c0102f1e:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0102f25:	e8 ad dd ff ff       	call   c0100cd7 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0102f2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f2d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102f30:	74 10                	je     c0102f42 <basic_check+0xdc>
c0102f32:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f35:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102f38:	74 08                	je     c0102f42 <basic_check+0xdc>
c0102f3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f3d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102f40:	75 24                	jne    c0102f66 <basic_check+0x100>
c0102f42:	c7 44 24 0c e8 65 10 	movl   $0xc01065e8,0xc(%esp)
c0102f49:	c0 
c0102f4a:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c0102f51:	c0 
c0102f52:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c0102f59:	00 
c0102f5a:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0102f61:	e8 71 dd ff ff       	call   c0100cd7 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0102f66:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f69:	89 04 24             	mov    %eax,(%esp)
c0102f6c:	e8 78 f9 ff ff       	call   c01028e9 <page_ref>
c0102f71:	85 c0                	test   %eax,%eax
c0102f73:	75 1e                	jne    c0102f93 <basic_check+0x12d>
c0102f75:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f78:	89 04 24             	mov    %eax,(%esp)
c0102f7b:	e8 69 f9 ff ff       	call   c01028e9 <page_ref>
c0102f80:	85 c0                	test   %eax,%eax
c0102f82:	75 0f                	jne    c0102f93 <basic_check+0x12d>
c0102f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f87:	89 04 24             	mov    %eax,(%esp)
c0102f8a:	e8 5a f9 ff ff       	call   c01028e9 <page_ref>
c0102f8f:	85 c0                	test   %eax,%eax
c0102f91:	74 24                	je     c0102fb7 <basic_check+0x151>
c0102f93:	c7 44 24 0c 0c 66 10 	movl   $0xc010660c,0xc(%esp)
c0102f9a:	c0 
c0102f9b:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c0102fa2:	c0 
c0102fa3:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
c0102faa:	00 
c0102fab:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0102fb2:	e8 20 dd ff ff       	call   c0100cd7 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0102fb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102fba:	89 04 24             	mov    %eax,(%esp)
c0102fbd:	e8 11 f9 ff ff       	call   c01028d3 <page2pa>
c0102fc2:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102fc8:	c1 e2 0c             	shl    $0xc,%edx
c0102fcb:	39 d0                	cmp    %edx,%eax
c0102fcd:	72 24                	jb     c0102ff3 <basic_check+0x18d>
c0102fcf:	c7 44 24 0c 48 66 10 	movl   $0xc0106648,0xc(%esp)
c0102fd6:	c0 
c0102fd7:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c0102fde:	c0 
c0102fdf:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c0102fe6:	00 
c0102fe7:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0102fee:	e8 e4 dc ff ff       	call   c0100cd7 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0102ff3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ff6:	89 04 24             	mov    %eax,(%esp)
c0102ff9:	e8 d5 f8 ff ff       	call   c01028d3 <page2pa>
c0102ffe:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0103004:	c1 e2 0c             	shl    $0xc,%edx
c0103007:	39 d0                	cmp    %edx,%eax
c0103009:	72 24                	jb     c010302f <basic_check+0x1c9>
c010300b:	c7 44 24 0c 65 66 10 	movl   $0xc0106665,0xc(%esp)
c0103012:	c0 
c0103013:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c010301a:	c0 
c010301b:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0103022:	00 
c0103023:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c010302a:	e8 a8 dc ff ff       	call   c0100cd7 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c010302f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103032:	89 04 24             	mov    %eax,(%esp)
c0103035:	e8 99 f8 ff ff       	call   c01028d3 <page2pa>
c010303a:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0103040:	c1 e2 0c             	shl    $0xc,%edx
c0103043:	39 d0                	cmp    %edx,%eax
c0103045:	72 24                	jb     c010306b <basic_check+0x205>
c0103047:	c7 44 24 0c 82 66 10 	movl   $0xc0106682,0xc(%esp)
c010304e:	c0 
c010304f:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c0103056:	c0 
c0103057:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c010305e:	00 
c010305f:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0103066:	e8 6c dc ff ff       	call   c0100cd7 <__panic>

    list_entry_t free_list_store = free_list;
c010306b:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0103070:	8b 15 54 89 11 c0    	mov    0xc0118954,%edx
c0103076:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103079:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010307c:	c7 45 e0 50 89 11 c0 	movl   $0xc0118950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103083:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103086:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103089:	89 50 04             	mov    %edx,0x4(%eax)
c010308c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010308f:	8b 50 04             	mov    0x4(%eax),%edx
c0103092:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103095:	89 10                	mov    %edx,(%eax)
c0103097:	c7 45 dc 50 89 11 c0 	movl   $0xc0118950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c010309e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01030a1:	8b 40 04             	mov    0x4(%eax),%eax
c01030a4:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01030a7:	0f 94 c0             	sete   %al
c01030aa:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01030ad:	85 c0                	test   %eax,%eax
c01030af:	75 24                	jne    c01030d5 <basic_check+0x26f>
c01030b1:	c7 44 24 0c 9f 66 10 	movl   $0xc010669f,0xc(%esp)
c01030b8:	c0 
c01030b9:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c01030c0:	c0 
c01030c1:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c01030c8:	00 
c01030c9:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c01030d0:	e8 02 dc ff ff       	call   c0100cd7 <__panic>

    unsigned int nr_free_store = nr_free;
c01030d5:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c01030da:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c01030dd:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c01030e4:	00 00 00 

    assert(alloc_page() == NULL);
c01030e7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01030ee:	e8 28 0c 00 00       	call   c0103d1b <alloc_pages>
c01030f3:	85 c0                	test   %eax,%eax
c01030f5:	74 24                	je     c010311b <basic_check+0x2b5>
c01030f7:	c7 44 24 0c b6 66 10 	movl   $0xc01066b6,0xc(%esp)
c01030fe:	c0 
c01030ff:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c0103106:	c0 
c0103107:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c010310e:	00 
c010310f:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0103116:	e8 bc db ff ff       	call   c0100cd7 <__panic>

    free_page(p0);
c010311b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103122:	00 
c0103123:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103126:	89 04 24             	mov    %eax,(%esp)
c0103129:	e8 25 0c 00 00       	call   c0103d53 <free_pages>
    free_page(p1);
c010312e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103135:	00 
c0103136:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103139:	89 04 24             	mov    %eax,(%esp)
c010313c:	e8 12 0c 00 00       	call   c0103d53 <free_pages>
    free_page(p2);
c0103141:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103148:	00 
c0103149:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010314c:	89 04 24             	mov    %eax,(%esp)
c010314f:	e8 ff 0b 00 00       	call   c0103d53 <free_pages>
    assert(nr_free == 3);
c0103154:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103159:	83 f8 03             	cmp    $0x3,%eax
c010315c:	74 24                	je     c0103182 <basic_check+0x31c>
c010315e:	c7 44 24 0c cb 66 10 	movl   $0xc01066cb,0xc(%esp)
c0103165:	c0 
c0103166:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c010316d:	c0 
c010316e:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c0103175:	00 
c0103176:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c010317d:	e8 55 db ff ff       	call   c0100cd7 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103182:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103189:	e8 8d 0b 00 00       	call   c0103d1b <alloc_pages>
c010318e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103191:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103195:	75 24                	jne    c01031bb <basic_check+0x355>
c0103197:	c7 44 24 0c 91 65 10 	movl   $0xc0106591,0xc(%esp)
c010319e:	c0 
c010319f:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c01031a6:	c0 
c01031a7:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
c01031ae:	00 
c01031af:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c01031b6:	e8 1c db ff ff       	call   c0100cd7 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01031bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031c2:	e8 54 0b 00 00       	call   c0103d1b <alloc_pages>
c01031c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01031ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01031ce:	75 24                	jne    c01031f4 <basic_check+0x38e>
c01031d0:	c7 44 24 0c ad 65 10 	movl   $0xc01065ad,0xc(%esp)
c01031d7:	c0 
c01031d8:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c01031df:	c0 
c01031e0:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c01031e7:	00 
c01031e8:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c01031ef:	e8 e3 da ff ff       	call   c0100cd7 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01031f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031fb:	e8 1b 0b 00 00       	call   c0103d1b <alloc_pages>
c0103200:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103203:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103207:	75 24                	jne    c010322d <basic_check+0x3c7>
c0103209:	c7 44 24 0c c9 65 10 	movl   $0xc01065c9,0xc(%esp)
c0103210:	c0 
c0103211:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c0103218:	c0 
c0103219:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c0103220:	00 
c0103221:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0103228:	e8 aa da ff ff       	call   c0100cd7 <__panic>

    assert(alloc_page() == NULL);
c010322d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103234:	e8 e2 0a 00 00       	call   c0103d1b <alloc_pages>
c0103239:	85 c0                	test   %eax,%eax
c010323b:	74 24                	je     c0103261 <basic_check+0x3fb>
c010323d:	c7 44 24 0c b6 66 10 	movl   $0xc01066b6,0xc(%esp)
c0103244:	c0 
c0103245:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c010324c:	c0 
c010324d:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
c0103254:	00 
c0103255:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c010325c:	e8 76 da ff ff       	call   c0100cd7 <__panic>

    free_page(p0);
c0103261:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103268:	00 
c0103269:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010326c:	89 04 24             	mov    %eax,(%esp)
c010326f:	e8 df 0a 00 00       	call   c0103d53 <free_pages>
c0103274:	c7 45 d8 50 89 11 c0 	movl   $0xc0118950,-0x28(%ebp)
c010327b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010327e:	8b 40 04             	mov    0x4(%eax),%eax
c0103281:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103284:	0f 94 c0             	sete   %al
c0103287:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c010328a:	85 c0                	test   %eax,%eax
c010328c:	74 24                	je     c01032b2 <basic_check+0x44c>
c010328e:	c7 44 24 0c d8 66 10 	movl   $0xc01066d8,0xc(%esp)
c0103295:	c0 
c0103296:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c010329d:	c0 
c010329e:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c01032a5:	00 
c01032a6:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c01032ad:	e8 25 da ff ff       	call   c0100cd7 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c01032b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032b9:	e8 5d 0a 00 00       	call   c0103d1b <alloc_pages>
c01032be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01032c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01032c4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01032c7:	74 24                	je     c01032ed <basic_check+0x487>
c01032c9:	c7 44 24 0c f0 66 10 	movl   $0xc01066f0,0xc(%esp)
c01032d0:	c0 
c01032d1:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c01032d8:	c0 
c01032d9:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c01032e0:	00 
c01032e1:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c01032e8:	e8 ea d9 ff ff       	call   c0100cd7 <__panic>
    assert(alloc_page() == NULL);
c01032ed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032f4:	e8 22 0a 00 00       	call   c0103d1b <alloc_pages>
c01032f9:	85 c0                	test   %eax,%eax
c01032fb:	74 24                	je     c0103321 <basic_check+0x4bb>
c01032fd:	c7 44 24 0c b6 66 10 	movl   $0xc01066b6,0xc(%esp)
c0103304:	c0 
c0103305:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c010330c:	c0 
c010330d:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c0103314:	00 
c0103315:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c010331c:	e8 b6 d9 ff ff       	call   c0100cd7 <__panic>

    assert(nr_free == 0);
c0103321:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103326:	85 c0                	test   %eax,%eax
c0103328:	74 24                	je     c010334e <basic_check+0x4e8>
c010332a:	c7 44 24 0c 09 67 10 	movl   $0xc0106709,0xc(%esp)
c0103331:	c0 
c0103332:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c0103339:	c0 
c010333a:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0103341:	00 
c0103342:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0103349:	e8 89 d9 ff ff       	call   c0100cd7 <__panic>
    free_list = free_list_store;
c010334e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103351:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103354:	a3 50 89 11 c0       	mov    %eax,0xc0118950
c0103359:	89 15 54 89 11 c0    	mov    %edx,0xc0118954
    nr_free = nr_free_store;
c010335f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103362:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    free_page(p);
c0103367:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010336e:	00 
c010336f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103372:	89 04 24             	mov    %eax,(%esp)
c0103375:	e8 d9 09 00 00       	call   c0103d53 <free_pages>
    free_page(p1);
c010337a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103381:	00 
c0103382:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103385:	89 04 24             	mov    %eax,(%esp)
c0103388:	e8 c6 09 00 00       	call   c0103d53 <free_pages>
    free_page(p2);
c010338d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103394:	00 
c0103395:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103398:	89 04 24             	mov    %eax,(%esp)
c010339b:	e8 b3 09 00 00       	call   c0103d53 <free_pages>
}
c01033a0:	c9                   	leave  
c01033a1:	c3                   	ret    

c01033a2 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c01033a2:	55                   	push   %ebp
c01033a3:	89 e5                	mov    %esp,%ebp
c01033a5:	53                   	push   %ebx
c01033a6:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c01033ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01033b3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c01033ba:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01033c1:	eb 6b                	jmp    c010342e <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c01033c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033c6:	83 e8 0c             	sub    $0xc,%eax
c01033c9:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c01033cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033cf:	83 c0 04             	add    $0x4,%eax
c01033d2:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01033d9:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01033dc:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01033df:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01033e2:	0f a3 10             	bt     %edx,(%eax)
c01033e5:	19 c0                	sbb    %eax,%eax
c01033e7:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c01033ea:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c01033ee:	0f 95 c0             	setne  %al
c01033f1:	0f b6 c0             	movzbl %al,%eax
c01033f4:	85 c0                	test   %eax,%eax
c01033f6:	75 24                	jne    c010341c <default_check+0x7a>
c01033f8:	c7 44 24 0c 16 67 10 	movl   $0xc0106716,0xc(%esp)
c01033ff:	c0 
c0103400:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c0103407:	c0 
c0103408:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c010340f:	00 
c0103410:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0103417:	e8 bb d8 ff ff       	call   c0100cd7 <__panic>
        count ++, total += p->property;
c010341c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103420:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103423:	8b 50 08             	mov    0x8(%eax),%edx
c0103426:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103429:	01 d0                	add    %edx,%eax
c010342b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010342e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103431:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103434:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103437:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c010343a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010343d:	81 7d ec 50 89 11 c0 	cmpl   $0xc0118950,-0x14(%ebp)
c0103444:	0f 85 79 ff ff ff    	jne    c01033c3 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c010344a:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c010344d:	e8 33 09 00 00       	call   c0103d85 <nr_free_pages>
c0103452:	39 c3                	cmp    %eax,%ebx
c0103454:	74 24                	je     c010347a <default_check+0xd8>
c0103456:	c7 44 24 0c 26 67 10 	movl   $0xc0106726,0xc(%esp)
c010345d:	c0 
c010345e:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c0103465:	c0 
c0103466:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c010346d:	00 
c010346e:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0103475:	e8 5d d8 ff ff       	call   c0100cd7 <__panic>

    basic_check();
c010347a:	e8 e7 f9 ff ff       	call   c0102e66 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c010347f:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103486:	e8 90 08 00 00       	call   c0103d1b <alloc_pages>
c010348b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c010348e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103492:	75 24                	jne    c01034b8 <default_check+0x116>
c0103494:	c7 44 24 0c 3f 67 10 	movl   $0xc010673f,0xc(%esp)
c010349b:	c0 
c010349c:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c01034a3:	c0 
c01034a4:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c01034ab:	00 
c01034ac:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c01034b3:	e8 1f d8 ff ff       	call   c0100cd7 <__panic>
    assert(!PageProperty(p0));
c01034b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01034bb:	83 c0 04             	add    $0x4,%eax
c01034be:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01034c5:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01034c8:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01034cb:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01034ce:	0f a3 10             	bt     %edx,(%eax)
c01034d1:	19 c0                	sbb    %eax,%eax
c01034d3:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c01034d6:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01034da:	0f 95 c0             	setne  %al
c01034dd:	0f b6 c0             	movzbl %al,%eax
c01034e0:	85 c0                	test   %eax,%eax
c01034e2:	74 24                	je     c0103508 <default_check+0x166>
c01034e4:	c7 44 24 0c 4a 67 10 	movl   $0xc010674a,0xc(%esp)
c01034eb:	c0 
c01034ec:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c01034f3:	c0 
c01034f4:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
c01034fb:	00 
c01034fc:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0103503:	e8 cf d7 ff ff       	call   c0100cd7 <__panic>

    list_entry_t free_list_store = free_list;
c0103508:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c010350d:	8b 15 54 89 11 c0    	mov    0xc0118954,%edx
c0103513:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103516:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103519:	c7 45 b4 50 89 11 c0 	movl   $0xc0118950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103520:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103523:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103526:	89 50 04             	mov    %edx,0x4(%eax)
c0103529:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010352c:	8b 50 04             	mov    0x4(%eax),%edx
c010352f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103532:	89 10                	mov    %edx,(%eax)
c0103534:	c7 45 b0 50 89 11 c0 	movl   $0xc0118950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c010353b:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010353e:	8b 40 04             	mov    0x4(%eax),%eax
c0103541:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0103544:	0f 94 c0             	sete   %al
c0103547:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010354a:	85 c0                	test   %eax,%eax
c010354c:	75 24                	jne    c0103572 <default_check+0x1d0>
c010354e:	c7 44 24 0c 9f 66 10 	movl   $0xc010669f,0xc(%esp)
c0103555:	c0 
c0103556:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c010355d:	c0 
c010355e:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
c0103565:	00 
c0103566:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c010356d:	e8 65 d7 ff ff       	call   c0100cd7 <__panic>
    assert(alloc_page() == NULL);
c0103572:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103579:	e8 9d 07 00 00       	call   c0103d1b <alloc_pages>
c010357e:	85 c0                	test   %eax,%eax
c0103580:	74 24                	je     c01035a6 <default_check+0x204>
c0103582:	c7 44 24 0c b6 66 10 	movl   $0xc01066b6,0xc(%esp)
c0103589:	c0 
c010358a:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c0103591:	c0 
c0103592:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
c0103599:	00 
c010359a:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c01035a1:	e8 31 d7 ff ff       	call   c0100cd7 <__panic>

    unsigned int nr_free_store = nr_free;
c01035a6:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c01035ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c01035ae:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c01035b5:	00 00 00 

    free_pages(p0 + 2, 3);
c01035b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035bb:	83 c0 28             	add    $0x28,%eax
c01035be:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01035c5:	00 
c01035c6:	89 04 24             	mov    %eax,(%esp)
c01035c9:	e8 85 07 00 00       	call   c0103d53 <free_pages>
    assert(alloc_pages(4) == NULL);
c01035ce:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01035d5:	e8 41 07 00 00       	call   c0103d1b <alloc_pages>
c01035da:	85 c0                	test   %eax,%eax
c01035dc:	74 24                	je     c0103602 <default_check+0x260>
c01035de:	c7 44 24 0c 5c 67 10 	movl   $0xc010675c,0xc(%esp)
c01035e5:	c0 
c01035e6:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c01035ed:	c0 
c01035ee:	c7 44 24 04 25 01 00 	movl   $0x125,0x4(%esp)
c01035f5:	00 
c01035f6:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c01035fd:	e8 d5 d6 ff ff       	call   c0100cd7 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0103602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103605:	83 c0 28             	add    $0x28,%eax
c0103608:	83 c0 04             	add    $0x4,%eax
c010360b:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103612:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103615:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103618:	8b 55 ac             	mov    -0x54(%ebp),%edx
c010361b:	0f a3 10             	bt     %edx,(%eax)
c010361e:	19 c0                	sbb    %eax,%eax
c0103620:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103623:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103627:	0f 95 c0             	setne  %al
c010362a:	0f b6 c0             	movzbl %al,%eax
c010362d:	85 c0                	test   %eax,%eax
c010362f:	74 0e                	je     c010363f <default_check+0x29d>
c0103631:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103634:	83 c0 28             	add    $0x28,%eax
c0103637:	8b 40 08             	mov    0x8(%eax),%eax
c010363a:	83 f8 03             	cmp    $0x3,%eax
c010363d:	74 24                	je     c0103663 <default_check+0x2c1>
c010363f:	c7 44 24 0c 74 67 10 	movl   $0xc0106774,0xc(%esp)
c0103646:	c0 
c0103647:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c010364e:	c0 
c010364f:	c7 44 24 04 26 01 00 	movl   $0x126,0x4(%esp)
c0103656:	00 
c0103657:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c010365e:	e8 74 d6 ff ff       	call   c0100cd7 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103663:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c010366a:	e8 ac 06 00 00       	call   c0103d1b <alloc_pages>
c010366f:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103672:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103676:	75 24                	jne    c010369c <default_check+0x2fa>
c0103678:	c7 44 24 0c a0 67 10 	movl   $0xc01067a0,0xc(%esp)
c010367f:	c0 
c0103680:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c0103687:	c0 
c0103688:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
c010368f:	00 
c0103690:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0103697:	e8 3b d6 ff ff       	call   c0100cd7 <__panic>
    assert(alloc_page() == NULL);
c010369c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01036a3:	e8 73 06 00 00       	call   c0103d1b <alloc_pages>
c01036a8:	85 c0                	test   %eax,%eax
c01036aa:	74 24                	je     c01036d0 <default_check+0x32e>
c01036ac:	c7 44 24 0c b6 66 10 	movl   $0xc01066b6,0xc(%esp)
c01036b3:	c0 
c01036b4:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c01036bb:	c0 
c01036bc:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
c01036c3:	00 
c01036c4:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c01036cb:	e8 07 d6 ff ff       	call   c0100cd7 <__panic>
    assert(p0 + 2 == p1);
c01036d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036d3:	83 c0 28             	add    $0x28,%eax
c01036d6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01036d9:	74 24                	je     c01036ff <default_check+0x35d>
c01036db:	c7 44 24 0c be 67 10 	movl   $0xc01067be,0xc(%esp)
c01036e2:	c0 
c01036e3:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c01036ea:	c0 
c01036eb:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
c01036f2:	00 
c01036f3:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c01036fa:	e8 d8 d5 ff ff       	call   c0100cd7 <__panic>

    p2 = p0 + 1;
c01036ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103702:	83 c0 14             	add    $0x14,%eax
c0103705:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c0103708:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010370f:	00 
c0103710:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103713:	89 04 24             	mov    %eax,(%esp)
c0103716:	e8 38 06 00 00       	call   c0103d53 <free_pages>
    free_pages(p1, 3);
c010371b:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103722:	00 
c0103723:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103726:	89 04 24             	mov    %eax,(%esp)
c0103729:	e8 25 06 00 00       	call   c0103d53 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c010372e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103731:	83 c0 04             	add    $0x4,%eax
c0103734:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c010373b:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010373e:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103741:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103744:	0f a3 10             	bt     %edx,(%eax)
c0103747:	19 c0                	sbb    %eax,%eax
c0103749:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c010374c:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0103750:	0f 95 c0             	setne  %al
c0103753:	0f b6 c0             	movzbl %al,%eax
c0103756:	85 c0                	test   %eax,%eax
c0103758:	74 0b                	je     c0103765 <default_check+0x3c3>
c010375a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010375d:	8b 40 08             	mov    0x8(%eax),%eax
c0103760:	83 f8 01             	cmp    $0x1,%eax
c0103763:	74 24                	je     c0103789 <default_check+0x3e7>
c0103765:	c7 44 24 0c cc 67 10 	movl   $0xc01067cc,0xc(%esp)
c010376c:	c0 
c010376d:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c0103774:	c0 
c0103775:	c7 44 24 04 2e 01 00 	movl   $0x12e,0x4(%esp)
c010377c:	00 
c010377d:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0103784:	e8 4e d5 ff ff       	call   c0100cd7 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0103789:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010378c:	83 c0 04             	add    $0x4,%eax
c010378f:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0103796:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103799:	8b 45 90             	mov    -0x70(%ebp),%eax
c010379c:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010379f:	0f a3 10             	bt     %edx,(%eax)
c01037a2:	19 c0                	sbb    %eax,%eax
c01037a4:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c01037a7:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01037ab:	0f 95 c0             	setne  %al
c01037ae:	0f b6 c0             	movzbl %al,%eax
c01037b1:	85 c0                	test   %eax,%eax
c01037b3:	74 0b                	je     c01037c0 <default_check+0x41e>
c01037b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01037b8:	8b 40 08             	mov    0x8(%eax),%eax
c01037bb:	83 f8 03             	cmp    $0x3,%eax
c01037be:	74 24                	je     c01037e4 <default_check+0x442>
c01037c0:	c7 44 24 0c f4 67 10 	movl   $0xc01067f4,0xc(%esp)
c01037c7:	c0 
c01037c8:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c01037cf:	c0 
c01037d0:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
c01037d7:	00 
c01037d8:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c01037df:	e8 f3 d4 ff ff       	call   c0100cd7 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01037e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01037eb:	e8 2b 05 00 00       	call   c0103d1b <alloc_pages>
c01037f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01037f3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01037f6:	83 e8 14             	sub    $0x14,%eax
c01037f9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01037fc:	74 24                	je     c0103822 <default_check+0x480>
c01037fe:	c7 44 24 0c 1a 68 10 	movl   $0xc010681a,0xc(%esp)
c0103805:	c0 
c0103806:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c010380d:	c0 
c010380e:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
c0103815:	00 
c0103816:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c010381d:	e8 b5 d4 ff ff       	call   c0100cd7 <__panic>
    free_page(p0);
c0103822:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103829:	00 
c010382a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010382d:	89 04 24             	mov    %eax,(%esp)
c0103830:	e8 1e 05 00 00       	call   c0103d53 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0103835:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c010383c:	e8 da 04 00 00       	call   c0103d1b <alloc_pages>
c0103841:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103844:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103847:	83 c0 14             	add    $0x14,%eax
c010384a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010384d:	74 24                	je     c0103873 <default_check+0x4d1>
c010384f:	c7 44 24 0c 38 68 10 	movl   $0xc0106838,0xc(%esp)
c0103856:	c0 
c0103857:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c010385e:	c0 
c010385f:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
c0103866:	00 
c0103867:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c010386e:	e8 64 d4 ff ff       	call   c0100cd7 <__panic>

    free_pages(p0, 2);
c0103873:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c010387a:	00 
c010387b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010387e:	89 04 24             	mov    %eax,(%esp)
c0103881:	e8 cd 04 00 00       	call   c0103d53 <free_pages>
    free_page(p2);
c0103886:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010388d:	00 
c010388e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103891:	89 04 24             	mov    %eax,(%esp)
c0103894:	e8 ba 04 00 00       	call   c0103d53 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0103899:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01038a0:	e8 76 04 00 00       	call   c0103d1b <alloc_pages>
c01038a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01038a8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01038ac:	75 24                	jne    c01038d2 <default_check+0x530>
c01038ae:	c7 44 24 0c 58 68 10 	movl   $0xc0106858,0xc(%esp)
c01038b5:	c0 
c01038b6:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c01038bd:	c0 
c01038be:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c01038c5:	00 
c01038c6:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c01038cd:	e8 05 d4 ff ff       	call   c0100cd7 <__panic>
    assert(alloc_page() == NULL);
c01038d2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01038d9:	e8 3d 04 00 00       	call   c0103d1b <alloc_pages>
c01038de:	85 c0                	test   %eax,%eax
c01038e0:	74 24                	je     c0103906 <default_check+0x564>
c01038e2:	c7 44 24 0c b6 66 10 	movl   $0xc01066b6,0xc(%esp)
c01038e9:	c0 
c01038ea:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c01038f1:	c0 
c01038f2:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
c01038f9:	00 
c01038fa:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0103901:	e8 d1 d3 ff ff       	call   c0100cd7 <__panic>

    assert(nr_free == 0);
c0103906:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c010390b:	85 c0                	test   %eax,%eax
c010390d:	74 24                	je     c0103933 <default_check+0x591>
c010390f:	c7 44 24 0c 09 67 10 	movl   $0xc0106709,0xc(%esp)
c0103916:	c0 
c0103917:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c010391e:	c0 
c010391f:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
c0103926:	00 
c0103927:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c010392e:	e8 a4 d3 ff ff       	call   c0100cd7 <__panic>
    nr_free = nr_free_store;
c0103933:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103936:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    free_list = free_list_store;
c010393b:	8b 45 80             	mov    -0x80(%ebp),%eax
c010393e:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103941:	a3 50 89 11 c0       	mov    %eax,0xc0118950
c0103946:	89 15 54 89 11 c0    	mov    %edx,0xc0118954
    free_pages(p0, 5);
c010394c:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0103953:	00 
c0103954:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103957:	89 04 24             	mov    %eax,(%esp)
c010395a:	e8 f4 03 00 00       	call   c0103d53 <free_pages>

    le = &free_list;
c010395f:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103966:	eb 1d                	jmp    c0103985 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c0103968:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010396b:	83 e8 0c             	sub    $0xc,%eax
c010396e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0103971:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0103975:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103978:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010397b:	8b 40 08             	mov    0x8(%eax),%eax
c010397e:	29 c2                	sub    %eax,%edx
c0103980:	89 d0                	mov    %edx,%eax
c0103982:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103985:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103988:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010398b:	8b 45 88             	mov    -0x78(%ebp),%eax
c010398e:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103991:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103994:	81 7d ec 50 89 11 c0 	cmpl   $0xc0118950,-0x14(%ebp)
c010399b:	75 cb                	jne    c0103968 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c010399d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01039a1:	74 24                	je     c01039c7 <default_check+0x625>
c01039a3:	c7 44 24 0c 76 68 10 	movl   $0xc0106876,0xc(%esp)
c01039aa:	c0 
c01039ab:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c01039b2:	c0 
c01039b3:	c7 44 24 04 46 01 00 	movl   $0x146,0x4(%esp)
c01039ba:	00 
c01039bb:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c01039c2:	e8 10 d3 ff ff       	call   c0100cd7 <__panic>
    assert(total == 0);
c01039c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01039cb:	74 24                	je     c01039f1 <default_check+0x64f>
c01039cd:	c7 44 24 0c 81 68 10 	movl   $0xc0106881,0xc(%esp)
c01039d4:	c0 
c01039d5:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c01039dc:	c0 
c01039dd:	c7 44 24 04 47 01 00 	movl   $0x147,0x4(%esp)
c01039e4:	00 
c01039e5:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c01039ec:	e8 e6 d2 ff ff       	call   c0100cd7 <__panic>
}
c01039f1:	81 c4 94 00 00 00    	add    $0x94,%esp
c01039f7:	5b                   	pop    %ebx
c01039f8:	5d                   	pop    %ebp
c01039f9:	c3                   	ret    

c01039fa <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01039fa:	55                   	push   %ebp
c01039fb:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01039fd:	8b 55 08             	mov    0x8(%ebp),%edx
c0103a00:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0103a05:	29 c2                	sub    %eax,%edx
c0103a07:	89 d0                	mov    %edx,%eax
c0103a09:	c1 f8 02             	sar    $0x2,%eax
c0103a0c:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103a12:	5d                   	pop    %ebp
c0103a13:	c3                   	ret    

c0103a14 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103a14:	55                   	push   %ebp
c0103a15:	89 e5                	mov    %esp,%ebp
c0103a17:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103a1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a1d:	89 04 24             	mov    %eax,(%esp)
c0103a20:	e8 d5 ff ff ff       	call   c01039fa <page2ppn>
c0103a25:	c1 e0 0c             	shl    $0xc,%eax
}
c0103a28:	c9                   	leave  
c0103a29:	c3                   	ret    

c0103a2a <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0103a2a:	55                   	push   %ebp
c0103a2b:	89 e5                	mov    %esp,%ebp
c0103a2d:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103a30:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a33:	c1 e8 0c             	shr    $0xc,%eax
c0103a36:	89 c2                	mov    %eax,%edx
c0103a38:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103a3d:	39 c2                	cmp    %eax,%edx
c0103a3f:	72 1c                	jb     c0103a5d <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103a41:	c7 44 24 08 bc 68 10 	movl   $0xc01068bc,0x8(%esp)
c0103a48:	c0 
c0103a49:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0103a50:	00 
c0103a51:	c7 04 24 db 68 10 c0 	movl   $0xc01068db,(%esp)
c0103a58:	e8 7a d2 ff ff       	call   c0100cd7 <__panic>
    }
    return &pages[PPN(pa)];
c0103a5d:	8b 0d 64 89 11 c0    	mov    0xc0118964,%ecx
c0103a63:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a66:	c1 e8 0c             	shr    $0xc,%eax
c0103a69:	89 c2                	mov    %eax,%edx
c0103a6b:	89 d0                	mov    %edx,%eax
c0103a6d:	c1 e0 02             	shl    $0x2,%eax
c0103a70:	01 d0                	add    %edx,%eax
c0103a72:	c1 e0 02             	shl    $0x2,%eax
c0103a75:	01 c8                	add    %ecx,%eax
}
c0103a77:	c9                   	leave  
c0103a78:	c3                   	ret    

c0103a79 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0103a79:	55                   	push   %ebp
c0103a7a:	89 e5                	mov    %esp,%ebp
c0103a7c:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103a7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a82:	89 04 24             	mov    %eax,(%esp)
c0103a85:	e8 8a ff ff ff       	call   c0103a14 <page2pa>
c0103a8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a90:	c1 e8 0c             	shr    $0xc,%eax
c0103a93:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a96:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103a9b:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103a9e:	72 23                	jb     c0103ac3 <page2kva+0x4a>
c0103aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103aa3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103aa7:	c7 44 24 08 ec 68 10 	movl   $0xc01068ec,0x8(%esp)
c0103aae:	c0 
c0103aaf:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103ab6:	00 
c0103ab7:	c7 04 24 db 68 10 c0 	movl   $0xc01068db,(%esp)
c0103abe:	e8 14 d2 ff ff       	call   c0100cd7 <__panic>
c0103ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ac6:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103acb:	c9                   	leave  
c0103acc:	c3                   	ret    

c0103acd <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0103acd:	55                   	push   %ebp
c0103ace:	89 e5                	mov    %esp,%ebp
c0103ad0:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103ad3:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ad6:	83 e0 01             	and    $0x1,%eax
c0103ad9:	85 c0                	test   %eax,%eax
c0103adb:	75 1c                	jne    c0103af9 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103add:	c7 44 24 08 10 69 10 	movl   $0xc0106910,0x8(%esp)
c0103ae4:	c0 
c0103ae5:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103aec:	00 
c0103aed:	c7 04 24 db 68 10 c0 	movl   $0xc01068db,(%esp)
c0103af4:	e8 de d1 ff ff       	call   c0100cd7 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0103af9:	8b 45 08             	mov    0x8(%ebp),%eax
c0103afc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103b01:	89 04 24             	mov    %eax,(%esp)
c0103b04:	e8 21 ff ff ff       	call   c0103a2a <pa2page>
}
c0103b09:	c9                   	leave  
c0103b0a:	c3                   	ret    

c0103b0b <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0103b0b:	55                   	push   %ebp
c0103b0c:	89 e5                	mov    %esp,%ebp
c0103b0e:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0103b11:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b14:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103b19:	89 04 24             	mov    %eax,(%esp)
c0103b1c:	e8 09 ff ff ff       	call   c0103a2a <pa2page>
}
c0103b21:	c9                   	leave  
c0103b22:	c3                   	ret    

c0103b23 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0103b23:	55                   	push   %ebp
c0103b24:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103b26:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b29:	8b 00                	mov    (%eax),%eax
}
c0103b2b:	5d                   	pop    %ebp
c0103b2c:	c3                   	ret    

c0103b2d <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
c0103b2d:	55                   	push   %ebp
c0103b2e:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103b30:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b33:	8b 00                	mov    (%eax),%eax
c0103b35:	8d 50 01             	lea    0x1(%eax),%edx
c0103b38:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b3b:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103b3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b40:	8b 00                	mov    (%eax),%eax
}
c0103b42:	5d                   	pop    %ebp
c0103b43:	c3                   	ret    

c0103b44 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103b44:	55                   	push   %ebp
c0103b45:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103b47:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b4a:	8b 00                	mov    (%eax),%eax
c0103b4c:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103b4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b52:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103b54:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b57:	8b 00                	mov    (%eax),%eax
}
c0103b59:	5d                   	pop    %ebp
c0103b5a:	c3                   	ret    

c0103b5b <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0103b5b:	55                   	push   %ebp
c0103b5c:	89 e5                	mov    %esp,%ebp
c0103b5e:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103b61:	9c                   	pushf  
c0103b62:	58                   	pop    %eax
c0103b63:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103b69:	25 00 02 00 00       	and    $0x200,%eax
c0103b6e:	85 c0                	test   %eax,%eax
c0103b70:	74 0c                	je     c0103b7e <__intr_save+0x23>
        intr_disable();
c0103b72:	e8 43 db ff ff       	call   c01016ba <intr_disable>
        return 1;
c0103b77:	b8 01 00 00 00       	mov    $0x1,%eax
c0103b7c:	eb 05                	jmp    c0103b83 <__intr_save+0x28>
    }
    return 0;
c0103b7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103b83:	c9                   	leave  
c0103b84:	c3                   	ret    

c0103b85 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0103b85:	55                   	push   %ebp
c0103b86:	89 e5                	mov    %esp,%ebp
c0103b88:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103b8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103b8f:	74 05                	je     c0103b96 <__intr_restore+0x11>
        intr_enable();
c0103b91:	e8 1e db ff ff       	call   c01016b4 <intr_enable>
    }
}
c0103b96:	c9                   	leave  
c0103b97:	c3                   	ret    

c0103b98 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103b98:	55                   	push   %ebp
c0103b99:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103b9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b9e:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103ba1:	b8 23 00 00 00       	mov    $0x23,%eax
c0103ba6:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103ba8:	b8 23 00 00 00       	mov    $0x23,%eax
c0103bad:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103baf:	b8 10 00 00 00       	mov    $0x10,%eax
c0103bb4:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103bb6:	b8 10 00 00 00       	mov    $0x10,%eax
c0103bbb:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103bbd:	b8 10 00 00 00       	mov    $0x10,%eax
c0103bc2:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103bc4:	ea cb 3b 10 c0 08 00 	ljmp   $0x8,$0xc0103bcb
}
c0103bcb:	5d                   	pop    %ebp
c0103bcc:	c3                   	ret    

c0103bcd <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103bcd:	55                   	push   %ebp
c0103bce:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103bd0:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bd3:	a3 e4 88 11 c0       	mov    %eax,0xc01188e4
}
c0103bd8:	5d                   	pop    %ebp
c0103bd9:	c3                   	ret    

c0103bda <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103bda:	55                   	push   %ebp
c0103bdb:	89 e5                	mov    %esp,%ebp
c0103bdd:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103be0:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0103be5:	89 04 24             	mov    %eax,(%esp)
c0103be8:	e8 e0 ff ff ff       	call   c0103bcd <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103bed:	66 c7 05 e8 88 11 c0 	movw   $0x10,0xc01188e8
c0103bf4:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103bf6:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0103bfd:	68 00 
c0103bff:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103c04:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0103c0a:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103c0f:	c1 e8 10             	shr    $0x10,%eax
c0103c12:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0103c17:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c1e:	83 e0 f0             	and    $0xfffffff0,%eax
c0103c21:	83 c8 09             	or     $0x9,%eax
c0103c24:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c29:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c30:	83 e0 ef             	and    $0xffffffef,%eax
c0103c33:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c38:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c3f:	83 e0 9f             	and    $0xffffff9f,%eax
c0103c42:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c47:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c4e:	83 c8 80             	or     $0xffffff80,%eax
c0103c51:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c56:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c5d:	83 e0 f0             	and    $0xfffffff0,%eax
c0103c60:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c65:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c6c:	83 e0 ef             	and    $0xffffffef,%eax
c0103c6f:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c74:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c7b:	83 e0 df             	and    $0xffffffdf,%eax
c0103c7e:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c83:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c8a:	83 c8 40             	or     $0x40,%eax
c0103c8d:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c92:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c99:	83 e0 7f             	and    $0x7f,%eax
c0103c9c:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103ca1:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103ca6:	c1 e8 18             	shr    $0x18,%eax
c0103ca9:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103cae:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c0103cb5:	e8 de fe ff ff       	call   c0103b98 <lgdt>
c0103cba:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103cc0:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103cc4:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103cc7:	c9                   	leave  
c0103cc8:	c3                   	ret    

c0103cc9 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103cc9:	55                   	push   %ebp
c0103cca:	89 e5                	mov    %esp,%ebp
c0103ccc:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103ccf:	c7 05 5c 89 11 c0 a0 	movl   $0xc01068a0,0xc011895c
c0103cd6:	68 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103cd9:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103cde:	8b 00                	mov    (%eax),%eax
c0103ce0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103ce4:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c0103ceb:	e8 4c c6 ff ff       	call   c010033c <cprintf>
    pmm_manager->init();
c0103cf0:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103cf5:	8b 40 04             	mov    0x4(%eax),%eax
c0103cf8:	ff d0                	call   *%eax
}
c0103cfa:	c9                   	leave  
c0103cfb:	c3                   	ret    

c0103cfc <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103cfc:	55                   	push   %ebp
c0103cfd:	89 e5                	mov    %esp,%ebp
c0103cff:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103d02:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d07:	8b 40 08             	mov    0x8(%eax),%eax
c0103d0a:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103d0d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103d11:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d14:	89 14 24             	mov    %edx,(%esp)
c0103d17:	ff d0                	call   *%eax
}
c0103d19:	c9                   	leave  
c0103d1a:	c3                   	ret    

c0103d1b <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103d1b:	55                   	push   %ebp
c0103d1c:	89 e5                	mov    %esp,%ebp
c0103d1e:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103d21:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103d28:	e8 2e fe ff ff       	call   c0103b5b <__intr_save>
c0103d2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103d30:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d35:	8b 40 0c             	mov    0xc(%eax),%eax
c0103d38:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d3b:	89 14 24             	mov    %edx,(%esp)
c0103d3e:	ff d0                	call   *%eax
c0103d40:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103d43:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d46:	89 04 24             	mov    %eax,(%esp)
c0103d49:	e8 37 fe ff ff       	call   c0103b85 <__intr_restore>
    return page;
c0103d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103d51:	c9                   	leave  
c0103d52:	c3                   	ret    

c0103d53 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103d53:	55                   	push   %ebp
c0103d54:	89 e5                	mov    %esp,%ebp
c0103d56:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103d59:	e8 fd fd ff ff       	call   c0103b5b <__intr_save>
c0103d5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103d61:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d66:	8b 40 10             	mov    0x10(%eax),%eax
c0103d69:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103d6c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103d70:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d73:	89 14 24             	mov    %edx,(%esp)
c0103d76:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d7b:	89 04 24             	mov    %eax,(%esp)
c0103d7e:	e8 02 fe ff ff       	call   c0103b85 <__intr_restore>
}
c0103d83:	c9                   	leave  
c0103d84:	c3                   	ret    

c0103d85 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103d85:	55                   	push   %ebp
c0103d86:	89 e5                	mov    %esp,%ebp
c0103d88:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103d8b:	e8 cb fd ff ff       	call   c0103b5b <__intr_save>
c0103d90:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103d93:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d98:	8b 40 14             	mov    0x14(%eax),%eax
c0103d9b:	ff d0                	call   *%eax
c0103d9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103da3:	89 04 24             	mov    %eax,(%esp)
c0103da6:	e8 da fd ff ff       	call   c0103b85 <__intr_restore>
    return ret;
c0103dab:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103dae:	c9                   	leave  
c0103daf:	c3                   	ret    

c0103db0 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103db0:	55                   	push   %ebp
c0103db1:	89 e5                	mov    %esp,%ebp
c0103db3:	57                   	push   %edi
c0103db4:	56                   	push   %esi
c0103db5:	53                   	push   %ebx
c0103db6:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103dbc:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103dc3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103dca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103dd1:	c7 04 24 53 69 10 c0 	movl   $0xc0106953,(%esp)
c0103dd8:	e8 5f c5 ff ff       	call   c010033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103ddd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103de4:	e9 15 01 00 00       	jmp    c0103efe <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103de9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103dec:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103def:	89 d0                	mov    %edx,%eax
c0103df1:	c1 e0 02             	shl    $0x2,%eax
c0103df4:	01 d0                	add    %edx,%eax
c0103df6:	c1 e0 02             	shl    $0x2,%eax
c0103df9:	01 c8                	add    %ecx,%eax
c0103dfb:	8b 50 08             	mov    0x8(%eax),%edx
c0103dfe:	8b 40 04             	mov    0x4(%eax),%eax
c0103e01:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103e04:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103e07:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e0a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e0d:	89 d0                	mov    %edx,%eax
c0103e0f:	c1 e0 02             	shl    $0x2,%eax
c0103e12:	01 d0                	add    %edx,%eax
c0103e14:	c1 e0 02             	shl    $0x2,%eax
c0103e17:	01 c8                	add    %ecx,%eax
c0103e19:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103e1c:	8b 58 10             	mov    0x10(%eax),%ebx
c0103e1f:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103e22:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103e25:	01 c8                	add    %ecx,%eax
c0103e27:	11 da                	adc    %ebx,%edx
c0103e29:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103e2c:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103e2f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e32:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e35:	89 d0                	mov    %edx,%eax
c0103e37:	c1 e0 02             	shl    $0x2,%eax
c0103e3a:	01 d0                	add    %edx,%eax
c0103e3c:	c1 e0 02             	shl    $0x2,%eax
c0103e3f:	01 c8                	add    %ecx,%eax
c0103e41:	83 c0 14             	add    $0x14,%eax
c0103e44:	8b 00                	mov    (%eax),%eax
c0103e46:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0103e4c:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103e4f:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103e52:	83 c0 ff             	add    $0xffffffff,%eax
c0103e55:	83 d2 ff             	adc    $0xffffffff,%edx
c0103e58:	89 c6                	mov    %eax,%esi
c0103e5a:	89 d7                	mov    %edx,%edi
c0103e5c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e5f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e62:	89 d0                	mov    %edx,%eax
c0103e64:	c1 e0 02             	shl    $0x2,%eax
c0103e67:	01 d0                	add    %edx,%eax
c0103e69:	c1 e0 02             	shl    $0x2,%eax
c0103e6c:	01 c8                	add    %ecx,%eax
c0103e6e:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103e71:	8b 58 10             	mov    0x10(%eax),%ebx
c0103e74:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0103e7a:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0103e7e:	89 74 24 14          	mov    %esi,0x14(%esp)
c0103e82:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0103e86:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103e89:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103e8c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103e90:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103e94:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103e98:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0103e9c:	c7 04 24 60 69 10 c0 	movl   $0xc0106960,(%esp)
c0103ea3:	e8 94 c4 ff ff       	call   c010033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103ea8:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103eab:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103eae:	89 d0                	mov    %edx,%eax
c0103eb0:	c1 e0 02             	shl    $0x2,%eax
c0103eb3:	01 d0                	add    %edx,%eax
c0103eb5:	c1 e0 02             	shl    $0x2,%eax
c0103eb8:	01 c8                	add    %ecx,%eax
c0103eba:	83 c0 14             	add    $0x14,%eax
c0103ebd:	8b 00                	mov    (%eax),%eax
c0103ebf:	83 f8 01             	cmp    $0x1,%eax
c0103ec2:	75 36                	jne    c0103efa <page_init+0x14a>
			// ARM: not reserved
            if (maxpa < end && begin < KMEMSIZE) {
c0103ec4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103ec7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103eca:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103ecd:	77 2b                	ja     c0103efa <page_init+0x14a>
c0103ecf:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103ed2:	72 05                	jb     c0103ed9 <page_init+0x129>
c0103ed4:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0103ed7:	73 21                	jae    c0103efa <page_init+0x14a>
c0103ed9:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103edd:	77 1b                	ja     c0103efa <page_init+0x14a>
c0103edf:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103ee3:	72 09                	jb     c0103eee <page_init+0x13e>
c0103ee5:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0103eec:	77 0c                	ja     c0103efa <page_init+0x14a>
                maxpa = end;
c0103eee:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103ef1:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103ef4:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103ef7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103efa:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103efe:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103f01:	8b 00                	mov    (%eax),%eax
c0103f03:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103f06:	0f 8f dd fe ff ff    	jg     c0103de9 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0103f0c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103f10:	72 1d                	jb     c0103f2f <page_init+0x17f>
c0103f12:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103f16:	77 09                	ja     c0103f21 <page_init+0x171>
c0103f18:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0103f1f:	76 0e                	jbe    c0103f2f <page_init+0x17f>
        maxpa = KMEMSIZE;
c0103f21:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0103f28:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];   // 此end为kernel的结尾，也正是可分配的内存页的开始
	// 按照看到的最大物理地址，计算出页数
    npage = maxpa / PGSIZE;
c0103f2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103f32:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103f35:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103f39:	c1 ea 0c             	shr    $0xc,%edx
c0103f3c:	a3 c0 88 11 c0       	mov    %eax,0xc01188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0103f41:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0103f48:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c0103f4d:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103f50:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103f53:	01 d0                	add    %edx,%eax
c0103f55:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103f58:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103f5b:	ba 00 00 00 00       	mov    $0x0,%edx
c0103f60:	f7 75 ac             	divl   -0x54(%ebp)
c0103f63:	89 d0                	mov    %edx,%eax
c0103f65:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0103f68:	29 c2                	sub    %eax,%edx
c0103f6a:	89 d0                	mov    %edx,%eax
c0103f6c:	a3 64 89 11 c0       	mov    %eax,0xc0118964
	// cprintf("maxpa: %08llx, end: %08llx, npage: %08llx, pages: %08llx \n",
	//		maxpa, (uint64_t)&end, (uint64_t)npage, (uint64_t)pages);
	// 这里的end地址是带0xC偏移的，因为现在的ucore正运行在段机制下
	
	// 先把所有页设置为reserved，后面再说（init memmap的时候会assert这一点）
    for (i = 0; i < npage; i ++) {
c0103f71:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103f78:	eb 2f                	jmp    c0103fa9 <page_init+0x1f9>
        SetPageReserved(pages + i);
c0103f7a:	8b 0d 64 89 11 c0    	mov    0xc0118964,%ecx
c0103f80:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f83:	89 d0                	mov    %edx,%eax
c0103f85:	c1 e0 02             	shl    $0x2,%eax
c0103f88:	01 d0                	add    %edx,%eax
c0103f8a:	c1 e0 02             	shl    $0x2,%eax
c0103f8d:	01 c8                	add    %ecx,%eax
c0103f8f:	83 c0 04             	add    $0x4,%eax
c0103f92:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0103f99:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103f9c:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103f9f:	8b 55 90             	mov    -0x70(%ebp),%edx
c0103fa2:	0f ab 10             	bts    %edx,(%eax)
	// cprintf("maxpa: %08llx, end: %08llx, npage: %08llx, pages: %08llx \n",
	//		maxpa, (uint64_t)&end, (uint64_t)npage, (uint64_t)pages);
	// 这里的end地址是带0xC偏移的，因为现在的ucore正运行在段机制下
	
	// 先把所有页设置为reserved，后面再说（init memmap的时候会assert这一点）
    for (i = 0; i < npage; i ++) {
c0103fa5:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103fa9:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103fac:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103fb1:	39 c2                	cmp    %eax,%edx
c0103fb3:	72 c5                	jb     c0103f7a <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);  // pages的结尾地址,转换成了物理地址(-0xC0000000)
c0103fb5:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0103fbb:	89 d0                	mov    %edx,%eax
c0103fbd:	c1 e0 02             	shl    $0x2,%eax
c0103fc0:	01 d0                	add    %edx,%eax
c0103fc2:	c1 e0 02             	shl    $0x2,%eax
c0103fc5:	89 c2                	mov    %eax,%edx
c0103fc7:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0103fcc:	01 d0                	add    %edx,%eax
c0103fce:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0103fd1:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0103fd8:	77 23                	ja     c0103ffd <page_init+0x24d>
c0103fda:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103fdd:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103fe1:	c7 44 24 08 90 69 10 	movl   $0xc0106990,0x8(%esp)
c0103fe8:	c0 
c0103fe9:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c0103ff0:	00 
c0103ff1:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0103ff8:	e8 da cc ff ff       	call   c0100cd7 <__panic>
c0103ffd:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104000:	05 00 00 00 40       	add    $0x40000000,%eax
c0104005:	89 45 a0             	mov    %eax,-0x60(%ebp)
	// 我们能分配的页地址在页表之后
    for (i = 0; i < memmap->nr_map; i ++) {
c0104008:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010400f:	e9 74 01 00 00       	jmp    c0104188 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104014:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104017:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010401a:	89 d0                	mov    %edx,%eax
c010401c:	c1 e0 02             	shl    $0x2,%eax
c010401f:	01 d0                	add    %edx,%eax
c0104021:	c1 e0 02             	shl    $0x2,%eax
c0104024:	01 c8                	add    %ecx,%eax
c0104026:	8b 50 08             	mov    0x8(%eax),%edx
c0104029:	8b 40 04             	mov    0x4(%eax),%eax
c010402c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010402f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104032:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104035:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104038:	89 d0                	mov    %edx,%eax
c010403a:	c1 e0 02             	shl    $0x2,%eax
c010403d:	01 d0                	add    %edx,%eax
c010403f:	c1 e0 02             	shl    $0x2,%eax
c0104042:	01 c8                	add    %ecx,%eax
c0104044:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104047:	8b 58 10             	mov    0x10(%eax),%ebx
c010404a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010404d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104050:	01 c8                	add    %ecx,%eax
c0104052:	11 da                	adc    %ebx,%edx
c0104054:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104057:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c010405a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010405d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104060:	89 d0                	mov    %edx,%eax
c0104062:	c1 e0 02             	shl    $0x2,%eax
c0104065:	01 d0                	add    %edx,%eax
c0104067:	c1 e0 02             	shl    $0x2,%eax
c010406a:	01 c8                	add    %ecx,%eax
c010406c:	83 c0 14             	add    $0x14,%eax
c010406f:	8b 00                	mov    (%eax),%eax
c0104071:	83 f8 01             	cmp    $0x1,%eax
c0104074:	0f 85 0a 01 00 00    	jne    c0104184 <page_init+0x3d4>
            if (begin < freemem) {
c010407a:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010407d:	ba 00 00 00 00       	mov    $0x0,%edx
c0104082:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104085:	72 17                	jb     c010409e <page_init+0x2ee>
c0104087:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010408a:	77 05                	ja     c0104091 <page_init+0x2e1>
c010408c:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c010408f:	76 0d                	jbe    c010409e <page_init+0x2ee>
                begin = freemem;
c0104091:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104094:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104097:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
				// cprintf("begin: %08llx, freemem: %08llx \n", begin, (uint64_t)freemem);
            }
            if (end > KMEMSIZE) {
c010409e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01040a2:	72 1d                	jb     c01040c1 <page_init+0x311>
c01040a4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01040a8:	77 09                	ja     c01040b3 <page_init+0x303>
c01040aa:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c01040b1:	76 0e                	jbe    c01040c1 <page_init+0x311>
                end = KMEMSIZE;
c01040b3:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c01040ba:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c01040c1:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01040c4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01040c7:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01040ca:	0f 87 b4 00 00 00    	ja     c0104184 <page_init+0x3d4>
c01040d0:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01040d3:	72 09                	jb     c01040de <page_init+0x32e>
c01040d5:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01040d8:	0f 83 a6 00 00 00    	jae    c0104184 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c01040de:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c01040e5:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01040e8:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01040eb:	01 d0                	add    %edx,%eax
c01040ed:	83 e8 01             	sub    $0x1,%eax
c01040f0:	89 45 98             	mov    %eax,-0x68(%ebp)
c01040f3:	8b 45 98             	mov    -0x68(%ebp),%eax
c01040f6:	ba 00 00 00 00       	mov    $0x0,%edx
c01040fb:	f7 75 9c             	divl   -0x64(%ebp)
c01040fe:	89 d0                	mov    %edx,%eax
c0104100:	8b 55 98             	mov    -0x68(%ebp),%edx
c0104103:	29 c2                	sub    %eax,%edx
c0104105:	89 d0                	mov    %edx,%eax
c0104107:	ba 00 00 00 00       	mov    $0x0,%edx
c010410c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010410f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0104112:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104115:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0104118:	8b 45 94             	mov    -0x6c(%ebp),%eax
c010411b:	ba 00 00 00 00       	mov    $0x0,%edx
c0104120:	89 c7                	mov    %eax,%edi
c0104122:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0104128:	89 7d 80             	mov    %edi,-0x80(%ebp)
c010412b:	89 d0                	mov    %edx,%eax
c010412d:	83 e0 00             	and    $0x0,%eax
c0104130:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104133:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104136:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104139:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010413c:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c010413f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104142:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104145:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104148:	77 3a                	ja     c0104184 <page_init+0x3d4>
c010414a:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010414d:	72 05                	jb     c0104154 <page_init+0x3a4>
c010414f:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104152:	73 30                	jae    c0104184 <page_init+0x3d4>
					// 传入的第一个参数是pages数组中的对应项
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0104154:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0104157:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c010415a:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010415d:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104160:	29 c8                	sub    %ecx,%eax
c0104162:	19 da                	sbb    %ebx,%edx
c0104164:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104168:	c1 ea 0c             	shr    $0xc,%edx
c010416b:	89 c3                	mov    %eax,%ebx
c010416d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104170:	89 04 24             	mov    %eax,(%esp)
c0104173:	e8 b2 f8 ff ff       	call   c0103a2a <pa2page>
c0104178:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c010417c:	89 04 24             	mov    %eax,(%esp)
c010417f:	e8 78 fb ff ff       	call   c0103cfc <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);  // pages的结尾地址,转换成了物理地址(-0xC0000000)
	// 我们能分配的页地址在页表之后
    for (i = 0; i < memmap->nr_map; i ++) {
c0104184:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104188:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010418b:	8b 00                	mov    (%eax),%eax
c010418d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104190:	0f 8f 7e fe ff ff    	jg     c0104014 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0104196:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c010419c:	5b                   	pop    %ebx
c010419d:	5e                   	pop    %esi
c010419e:	5f                   	pop    %edi
c010419f:	5d                   	pop    %ebp
c01041a0:	c3                   	ret    

c01041a1 <enable_paging>:

static void
enable_paging(void) {
c01041a1:	55                   	push   %ebp
c01041a2:	89 e5                	mov    %esp,%ebp
c01041a4:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c01041a7:	a1 60 89 11 c0       	mov    0xc0118960,%eax
c01041ac:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c01041af:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01041b2:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c01041b5:	0f 20 c0             	mov    %cr0,%eax
c01041b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c01041bb:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c01041be:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c01041c1:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c01041c8:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c01041cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01041cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c01041d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01041d5:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c01041d8:	c9                   	leave  
c01041d9:	c3                   	ret    

c01041da <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c01041da:	55                   	push   %ebp
c01041db:	89 e5                	mov    %esp,%ebp
c01041dd:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c01041e0:	8b 45 14             	mov    0x14(%ebp),%eax
c01041e3:	8b 55 0c             	mov    0xc(%ebp),%edx
c01041e6:	31 d0                	xor    %edx,%eax
c01041e8:	25 ff 0f 00 00       	and    $0xfff,%eax
c01041ed:	85 c0                	test   %eax,%eax
c01041ef:	74 24                	je     c0104215 <boot_map_segment+0x3b>
c01041f1:	c7 44 24 0c c2 69 10 	movl   $0xc01069c2,0xc(%esp)
c01041f8:	c0 
c01041f9:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104200:	c0 
c0104201:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c0104208:	00 
c0104209:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104210:	e8 c2 ca ff ff       	call   c0100cd7 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0104215:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c010421c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010421f:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104224:	89 c2                	mov    %eax,%edx
c0104226:	8b 45 10             	mov    0x10(%ebp),%eax
c0104229:	01 c2                	add    %eax,%edx
c010422b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010422e:	01 d0                	add    %edx,%eax
c0104230:	83 e8 01             	sub    $0x1,%eax
c0104233:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104236:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104239:	ba 00 00 00 00       	mov    $0x0,%edx
c010423e:	f7 75 f0             	divl   -0x10(%ebp)
c0104241:	89 d0                	mov    %edx,%eax
c0104243:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104246:	29 c2                	sub    %eax,%edx
c0104248:	89 d0                	mov    %edx,%eax
c010424a:	c1 e8 0c             	shr    $0xc,%eax
c010424d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104250:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104253:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104256:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104259:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010425e:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104261:	8b 45 14             	mov    0x14(%ebp),%eax
c0104264:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104267:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010426a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010426f:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104272:	eb 6b                	jmp    c01042df <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0104274:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010427b:	00 
c010427c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010427f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104283:	8b 45 08             	mov    0x8(%ebp),%eax
c0104286:	89 04 24             	mov    %eax,(%esp)
c0104289:	e8 cc 01 00 00       	call   c010445a <get_pte>
c010428e:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104291:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104295:	75 24                	jne    c01042bb <boot_map_segment+0xe1>
c0104297:	c7 44 24 0c ee 69 10 	movl   $0xc01069ee,0xc(%esp)
c010429e:	c0 
c010429f:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c01042a6:	c0 
c01042a7:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c01042ae:	00 
c01042af:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c01042b6:	e8 1c ca ff ff       	call   c0100cd7 <__panic>
        *ptep = pa | PTE_P | perm;
c01042bb:	8b 45 18             	mov    0x18(%ebp),%eax
c01042be:	8b 55 14             	mov    0x14(%ebp),%edx
c01042c1:	09 d0                	or     %edx,%eax
c01042c3:	83 c8 01             	or     $0x1,%eax
c01042c6:	89 c2                	mov    %eax,%edx
c01042c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01042cb:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01042cd:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01042d1:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01042d8:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01042df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01042e3:	75 8f                	jne    c0104274 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c01042e5:	c9                   	leave  
c01042e6:	c3                   	ret    

c01042e7 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01042e7:	55                   	push   %ebp
c01042e8:	89 e5                	mov    %esp,%ebp
c01042ea:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c01042ed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01042f4:	e8 22 fa ff ff       	call   c0103d1b <alloc_pages>
c01042f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01042fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104300:	75 1c                	jne    c010431e <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0104302:	c7 44 24 08 fb 69 10 	movl   $0xc01069fb,0x8(%esp)
c0104309:	c0 
c010430a:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
c0104311:	00 
c0104312:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104319:	e8 b9 c9 ff ff       	call   c0100cd7 <__panic>
    }
    return page2kva(p);
c010431e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104321:	89 04 24             	mov    %eax,(%esp)
c0104324:	e8 50 f7 ff ff       	call   c0103a79 <page2kva>
}
c0104329:	c9                   	leave  
c010432a:	c3                   	ret    

c010432b <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c010432b:	55                   	push   %ebp
c010432c:	89 e5                	mov    %esp,%ebp
c010432e:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104331:	e8 93 f9 ff ff       	call   c0103cc9 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0104336:	e8 75 fa ff ff       	call   c0103db0 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c010433b:	e8 d7 02 00 00       	call   c0104617 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0104340:	e8 a2 ff ff ff       	call   c01042e7 <boot_alloc_page>
c0104345:	a3 c4 88 11 c0       	mov    %eax,0xc01188c4
    memset(boot_pgdir, 0, PGSIZE);
c010434a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010434f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104356:	00 
c0104357:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010435e:	00 
c010435f:	89 04 24             	mov    %eax,(%esp)
c0104362:	e8 14 19 00 00       	call   c0105c7b <memset>
    boot_cr3 = PADDR(boot_pgdir);
c0104367:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010436c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010436f:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104376:	77 23                	ja     c010439b <pmm_init+0x70>
c0104378:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010437b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010437f:	c7 44 24 08 90 69 10 	movl   $0xc0106990,0x8(%esp)
c0104386:	c0 
c0104387:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c010438e:	00 
c010438f:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104396:	e8 3c c9 ff ff       	call   c0100cd7 <__panic>
c010439b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010439e:	05 00 00 00 40       	add    $0x40000000,%eax
c01043a3:	a3 60 89 11 c0       	mov    %eax,0xc0118960

    check_pgdir();
c01043a8:	e8 88 02 00 00       	call   c0104635 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01043ad:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01043b2:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c01043b8:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01043bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01043c0:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01043c7:	77 23                	ja     c01043ec <pmm_init+0xc1>
c01043c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043cc:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01043d0:	c7 44 24 08 90 69 10 	movl   $0xc0106990,0x8(%esp)
c01043d7:	c0 
c01043d8:	c7 44 24 04 40 01 00 	movl   $0x140,0x4(%esp)
c01043df:	00 
c01043e0:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c01043e7:	e8 eb c8 ff ff       	call   c0100cd7 <__panic>
c01043ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043ef:	05 00 00 00 40       	add    $0x40000000,%eax
c01043f4:	83 c8 03             	or     $0x3,%eax
c01043f7:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01043f9:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01043fe:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0104405:	00 
c0104406:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010440d:	00 
c010440e:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0104415:	38 
c0104416:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c010441d:	c0 
c010441e:	89 04 24             	mov    %eax,(%esp)
c0104421:	e8 b4 fd ff ff       	call   c01041da <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c0104426:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010442b:	8b 15 c4 88 11 c0    	mov    0xc01188c4,%edx
c0104431:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c0104437:	89 10                	mov    %edx,(%eax)

    enable_paging();
c0104439:	e8 63 fd ff ff       	call   c01041a1 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c010443e:	e8 97 f7 ff ff       	call   c0103bda <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0104443:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104448:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c010444e:	e8 7d 08 00 00       	call   c0104cd0 <check_boot_pgdir>

    print_pgdir();
c0104453:	e8 05 0d 00 00       	call   c010515d <print_pgdir>

}
c0104458:	c9                   	leave  
c0104459:	c3                   	ret    

c010445a <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c010445a:	55                   	push   %ebp
c010445b:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
c010445d:	5d                   	pop    %ebp
c010445e:	c3                   	ret    

c010445f <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c010445f:	55                   	push   %ebp
c0104460:	89 e5                	mov    %esp,%ebp
c0104462:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104465:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010446c:	00 
c010446d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104470:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104474:	8b 45 08             	mov    0x8(%ebp),%eax
c0104477:	89 04 24             	mov    %eax,(%esp)
c010447a:	e8 db ff ff ff       	call   c010445a <get_pte>
c010447f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0104482:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104486:	74 08                	je     c0104490 <get_page+0x31>
        *ptep_store = ptep;
c0104488:	8b 45 10             	mov    0x10(%ebp),%eax
c010448b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010448e:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0104490:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104494:	74 1b                	je     c01044b1 <get_page+0x52>
c0104496:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104499:	8b 00                	mov    (%eax),%eax
c010449b:	83 e0 01             	and    $0x1,%eax
c010449e:	85 c0                	test   %eax,%eax
c01044a0:	74 0f                	je     c01044b1 <get_page+0x52>
        return pte2page(*ptep);
c01044a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044a5:	8b 00                	mov    (%eax),%eax
c01044a7:	89 04 24             	mov    %eax,(%esp)
c01044aa:	e8 1e f6 ff ff       	call   c0103acd <pte2page>
c01044af:	eb 05                	jmp    c01044b6 <get_page+0x57>
    }
    return NULL;
c01044b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01044b6:	c9                   	leave  
c01044b7:	c3                   	ret    

c01044b8 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01044b8:	55                   	push   %ebp
c01044b9:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
c01044bb:	5d                   	pop    %ebp
c01044bc:	c3                   	ret    

c01044bd <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01044bd:	55                   	push   %ebp
c01044be:	89 e5                	mov    %esp,%ebp
c01044c0:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01044c3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01044ca:	00 
c01044cb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044ce:	89 44 24 04          	mov    %eax,0x4(%esp)
c01044d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01044d5:	89 04 24             	mov    %eax,(%esp)
c01044d8:	e8 7d ff ff ff       	call   c010445a <get_pte>
c01044dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
c01044e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01044e4:	74 19                	je     c01044ff <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c01044e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01044e9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01044ed:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044f0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01044f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01044f7:	89 04 24             	mov    %eax,(%esp)
c01044fa:	e8 b9 ff ff ff       	call   c01044b8 <page_remove_pte>
    }
}
c01044ff:	c9                   	leave  
c0104500:	c3                   	ret    

c0104501 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0104501:	55                   	push   %ebp
c0104502:	89 e5                	mov    %esp,%ebp
c0104504:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0104507:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010450e:	00 
c010450f:	8b 45 10             	mov    0x10(%ebp),%eax
c0104512:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104516:	8b 45 08             	mov    0x8(%ebp),%eax
c0104519:	89 04 24             	mov    %eax,(%esp)
c010451c:	e8 39 ff ff ff       	call   c010445a <get_pte>
c0104521:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0104524:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104528:	75 0a                	jne    c0104534 <page_insert+0x33>
        return -E_NO_MEM;
c010452a:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c010452f:	e9 84 00 00 00       	jmp    c01045b8 <page_insert+0xb7>
    }
    page_ref_inc(page);
c0104534:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104537:	89 04 24             	mov    %eax,(%esp)
c010453a:	e8 ee f5 ff ff       	call   c0103b2d <page_ref_inc>
    if (*ptep & PTE_P) {
c010453f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104542:	8b 00                	mov    (%eax),%eax
c0104544:	83 e0 01             	and    $0x1,%eax
c0104547:	85 c0                	test   %eax,%eax
c0104549:	74 3e                	je     c0104589 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c010454b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010454e:	8b 00                	mov    (%eax),%eax
c0104550:	89 04 24             	mov    %eax,(%esp)
c0104553:	e8 75 f5 ff ff       	call   c0103acd <pte2page>
c0104558:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c010455b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010455e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104561:	75 0d                	jne    c0104570 <page_insert+0x6f>
            page_ref_dec(page);
c0104563:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104566:	89 04 24             	mov    %eax,(%esp)
c0104569:	e8 d6 f5 ff ff       	call   c0103b44 <page_ref_dec>
c010456e:	eb 19                	jmp    c0104589 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0104570:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104573:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104577:	8b 45 10             	mov    0x10(%ebp),%eax
c010457a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010457e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104581:	89 04 24             	mov    %eax,(%esp)
c0104584:	e8 2f ff ff ff       	call   c01044b8 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0104589:	8b 45 0c             	mov    0xc(%ebp),%eax
c010458c:	89 04 24             	mov    %eax,(%esp)
c010458f:	e8 80 f4 ff ff       	call   c0103a14 <page2pa>
c0104594:	0b 45 14             	or     0x14(%ebp),%eax
c0104597:	83 c8 01             	or     $0x1,%eax
c010459a:	89 c2                	mov    %eax,%edx
c010459c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010459f:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01045a1:	8b 45 10             	mov    0x10(%ebp),%eax
c01045a4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01045a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01045ab:	89 04 24             	mov    %eax,(%esp)
c01045ae:	e8 07 00 00 00       	call   c01045ba <tlb_invalidate>
    return 0;
c01045b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01045b8:	c9                   	leave  
c01045b9:	c3                   	ret    

c01045ba <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01045ba:	55                   	push   %ebp
c01045bb:	89 e5                	mov    %esp,%ebp
c01045bd:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01045c0:	0f 20 d8             	mov    %cr3,%eax
c01045c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01045c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c01045c9:	89 c2                	mov    %eax,%edx
c01045cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01045ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01045d1:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01045d8:	77 23                	ja     c01045fd <tlb_invalidate+0x43>
c01045da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045dd:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01045e1:	c7 44 24 08 90 69 10 	movl   $0xc0106990,0x8(%esp)
c01045e8:	c0 
c01045e9:	c7 44 24 04 e0 01 00 	movl   $0x1e0,0x4(%esp)
c01045f0:	00 
c01045f1:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c01045f8:	e8 da c6 ff ff       	call   c0100cd7 <__panic>
c01045fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104600:	05 00 00 00 40       	add    $0x40000000,%eax
c0104605:	39 c2                	cmp    %eax,%edx
c0104607:	75 0c                	jne    c0104615 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c0104609:	8b 45 0c             	mov    0xc(%ebp),%eax
c010460c:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c010460f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104612:	0f 01 38             	invlpg (%eax)
    }
}
c0104615:	c9                   	leave  
c0104616:	c3                   	ret    

c0104617 <check_alloc_page>:

static void
check_alloc_page(void) {
c0104617:	55                   	push   %ebp
c0104618:	89 e5                	mov    %esp,%ebp
c010461a:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c010461d:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0104622:	8b 40 18             	mov    0x18(%eax),%eax
c0104625:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0104627:	c7 04 24 14 6a 10 c0 	movl   $0xc0106a14,(%esp)
c010462e:	e8 09 bd ff ff       	call   c010033c <cprintf>
}
c0104633:	c9                   	leave  
c0104634:	c3                   	ret    

c0104635 <check_pgdir>:

static void
check_pgdir(void) {
c0104635:	55                   	push   %ebp
c0104636:	89 e5                	mov    %esp,%ebp
c0104638:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c010463b:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104640:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0104645:	76 24                	jbe    c010466b <check_pgdir+0x36>
c0104647:	c7 44 24 0c 33 6a 10 	movl   $0xc0106a33,0xc(%esp)
c010464e:	c0 
c010464f:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104656:	c0 
c0104657:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
c010465e:	00 
c010465f:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104666:	e8 6c c6 ff ff       	call   c0100cd7 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c010466b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104670:	85 c0                	test   %eax,%eax
c0104672:	74 0e                	je     c0104682 <check_pgdir+0x4d>
c0104674:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104679:	25 ff 0f 00 00       	and    $0xfff,%eax
c010467e:	85 c0                	test   %eax,%eax
c0104680:	74 24                	je     c01046a6 <check_pgdir+0x71>
c0104682:	c7 44 24 0c 50 6a 10 	movl   $0xc0106a50,0xc(%esp)
c0104689:	c0 
c010468a:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104691:	c0 
c0104692:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
c0104699:	00 
c010469a:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c01046a1:	e8 31 c6 ff ff       	call   c0100cd7 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01046a6:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01046ab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01046b2:	00 
c01046b3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01046ba:	00 
c01046bb:	89 04 24             	mov    %eax,(%esp)
c01046be:	e8 9c fd ff ff       	call   c010445f <get_page>
c01046c3:	85 c0                	test   %eax,%eax
c01046c5:	74 24                	je     c01046eb <check_pgdir+0xb6>
c01046c7:	c7 44 24 0c 88 6a 10 	movl   $0xc0106a88,0xc(%esp)
c01046ce:	c0 
c01046cf:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c01046d6:	c0 
c01046d7:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
c01046de:	00 
c01046df:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c01046e6:	e8 ec c5 ff ff       	call   c0100cd7 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01046eb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01046f2:	e8 24 f6 ff ff       	call   c0103d1b <alloc_pages>
c01046f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01046fa:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01046ff:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104706:	00 
c0104707:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010470e:	00 
c010470f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104712:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104716:	89 04 24             	mov    %eax,(%esp)
c0104719:	e8 e3 fd ff ff       	call   c0104501 <page_insert>
c010471e:	85 c0                	test   %eax,%eax
c0104720:	74 24                	je     c0104746 <check_pgdir+0x111>
c0104722:	c7 44 24 0c b0 6a 10 	movl   $0xc0106ab0,0xc(%esp)
c0104729:	c0 
c010472a:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104731:	c0 
c0104732:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
c0104739:	00 
c010473a:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104741:	e8 91 c5 ff ff       	call   c0100cd7 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0104746:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010474b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104752:	00 
c0104753:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010475a:	00 
c010475b:	89 04 24             	mov    %eax,(%esp)
c010475e:	e8 f7 fc ff ff       	call   c010445a <get_pte>
c0104763:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104766:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010476a:	75 24                	jne    c0104790 <check_pgdir+0x15b>
c010476c:	c7 44 24 0c dc 6a 10 	movl   $0xc0106adc,0xc(%esp)
c0104773:	c0 
c0104774:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c010477b:	c0 
c010477c:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
c0104783:	00 
c0104784:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c010478b:	e8 47 c5 ff ff       	call   c0100cd7 <__panic>
    assert(pte2page(*ptep) == p1);
c0104790:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104793:	8b 00                	mov    (%eax),%eax
c0104795:	89 04 24             	mov    %eax,(%esp)
c0104798:	e8 30 f3 ff ff       	call   c0103acd <pte2page>
c010479d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01047a0:	74 24                	je     c01047c6 <check_pgdir+0x191>
c01047a2:	c7 44 24 0c 09 6b 10 	movl   $0xc0106b09,0xc(%esp)
c01047a9:	c0 
c01047aa:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c01047b1:	c0 
c01047b2:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c01047b9:	00 
c01047ba:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c01047c1:	e8 11 c5 ff ff       	call   c0100cd7 <__panic>
    assert(page_ref(p1) == 1);
c01047c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047c9:	89 04 24             	mov    %eax,(%esp)
c01047cc:	e8 52 f3 ff ff       	call   c0103b23 <page_ref>
c01047d1:	83 f8 01             	cmp    $0x1,%eax
c01047d4:	74 24                	je     c01047fa <check_pgdir+0x1c5>
c01047d6:	c7 44 24 0c 1f 6b 10 	movl   $0xc0106b1f,0xc(%esp)
c01047dd:	c0 
c01047de:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c01047e5:	c0 
c01047e6:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
c01047ed:	00 
c01047ee:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c01047f5:	e8 dd c4 ff ff       	call   c0100cd7 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c01047fa:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01047ff:	8b 00                	mov    (%eax),%eax
c0104801:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104806:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104809:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010480c:	c1 e8 0c             	shr    $0xc,%eax
c010480f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104812:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104817:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c010481a:	72 23                	jb     c010483f <check_pgdir+0x20a>
c010481c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010481f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104823:	c7 44 24 08 ec 68 10 	movl   $0xc01068ec,0x8(%esp)
c010482a:	c0 
c010482b:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
c0104832:	00 
c0104833:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c010483a:	e8 98 c4 ff ff       	call   c0100cd7 <__panic>
c010483f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104842:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104847:	83 c0 04             	add    $0x4,%eax
c010484a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c010484d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104852:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104859:	00 
c010485a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104861:	00 
c0104862:	89 04 24             	mov    %eax,(%esp)
c0104865:	e8 f0 fb ff ff       	call   c010445a <get_pte>
c010486a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010486d:	74 24                	je     c0104893 <check_pgdir+0x25e>
c010486f:	c7 44 24 0c 34 6b 10 	movl   $0xc0106b34,0xc(%esp)
c0104876:	c0 
c0104877:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c010487e:	c0 
c010487f:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
c0104886:	00 
c0104887:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c010488e:	e8 44 c4 ff ff       	call   c0100cd7 <__panic>

    p2 = alloc_page();
c0104893:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010489a:	e8 7c f4 ff ff       	call   c0103d1b <alloc_pages>
c010489f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c01048a2:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01048a7:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c01048ae:	00 
c01048af:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01048b6:	00 
c01048b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01048ba:	89 54 24 04          	mov    %edx,0x4(%esp)
c01048be:	89 04 24             	mov    %eax,(%esp)
c01048c1:	e8 3b fc ff ff       	call   c0104501 <page_insert>
c01048c6:	85 c0                	test   %eax,%eax
c01048c8:	74 24                	je     c01048ee <check_pgdir+0x2b9>
c01048ca:	c7 44 24 0c 5c 6b 10 	movl   $0xc0106b5c,0xc(%esp)
c01048d1:	c0 
c01048d2:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c01048d9:	c0 
c01048da:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
c01048e1:	00 
c01048e2:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c01048e9:	e8 e9 c3 ff ff       	call   c0100cd7 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01048ee:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01048f3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01048fa:	00 
c01048fb:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104902:	00 
c0104903:	89 04 24             	mov    %eax,(%esp)
c0104906:	e8 4f fb ff ff       	call   c010445a <get_pte>
c010490b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010490e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104912:	75 24                	jne    c0104938 <check_pgdir+0x303>
c0104914:	c7 44 24 0c 94 6b 10 	movl   $0xc0106b94,0xc(%esp)
c010491b:	c0 
c010491c:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104923:	c0 
c0104924:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c010492b:	00 
c010492c:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104933:	e8 9f c3 ff ff       	call   c0100cd7 <__panic>
    assert(*ptep & PTE_U);
c0104938:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010493b:	8b 00                	mov    (%eax),%eax
c010493d:	83 e0 04             	and    $0x4,%eax
c0104940:	85 c0                	test   %eax,%eax
c0104942:	75 24                	jne    c0104968 <check_pgdir+0x333>
c0104944:	c7 44 24 0c c4 6b 10 	movl   $0xc0106bc4,0xc(%esp)
c010494b:	c0 
c010494c:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104953:	c0 
c0104954:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c010495b:	00 
c010495c:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104963:	e8 6f c3 ff ff       	call   c0100cd7 <__panic>
    assert(*ptep & PTE_W);
c0104968:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010496b:	8b 00                	mov    (%eax),%eax
c010496d:	83 e0 02             	and    $0x2,%eax
c0104970:	85 c0                	test   %eax,%eax
c0104972:	75 24                	jne    c0104998 <check_pgdir+0x363>
c0104974:	c7 44 24 0c d2 6b 10 	movl   $0xc0106bd2,0xc(%esp)
c010497b:	c0 
c010497c:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104983:	c0 
c0104984:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
c010498b:	00 
c010498c:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104993:	e8 3f c3 ff ff       	call   c0100cd7 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104998:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010499d:	8b 00                	mov    (%eax),%eax
c010499f:	83 e0 04             	and    $0x4,%eax
c01049a2:	85 c0                	test   %eax,%eax
c01049a4:	75 24                	jne    c01049ca <check_pgdir+0x395>
c01049a6:	c7 44 24 0c e0 6b 10 	movl   $0xc0106be0,0xc(%esp)
c01049ad:	c0 
c01049ae:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c01049b5:	c0 
c01049b6:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
c01049bd:	00 
c01049be:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c01049c5:	e8 0d c3 ff ff       	call   c0100cd7 <__panic>
    assert(page_ref(p2) == 1);
c01049ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01049cd:	89 04 24             	mov    %eax,(%esp)
c01049d0:	e8 4e f1 ff ff       	call   c0103b23 <page_ref>
c01049d5:	83 f8 01             	cmp    $0x1,%eax
c01049d8:	74 24                	je     c01049fe <check_pgdir+0x3c9>
c01049da:	c7 44 24 0c f6 6b 10 	movl   $0xc0106bf6,0xc(%esp)
c01049e1:	c0 
c01049e2:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c01049e9:	c0 
c01049ea:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c01049f1:	00 
c01049f2:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c01049f9:	e8 d9 c2 ff ff       	call   c0100cd7 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c01049fe:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104a03:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104a0a:	00 
c0104a0b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104a12:	00 
c0104a13:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104a16:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104a1a:	89 04 24             	mov    %eax,(%esp)
c0104a1d:	e8 df fa ff ff       	call   c0104501 <page_insert>
c0104a22:	85 c0                	test   %eax,%eax
c0104a24:	74 24                	je     c0104a4a <check_pgdir+0x415>
c0104a26:	c7 44 24 0c 08 6c 10 	movl   $0xc0106c08,0xc(%esp)
c0104a2d:	c0 
c0104a2e:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104a35:	c0 
c0104a36:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c0104a3d:	00 
c0104a3e:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104a45:	e8 8d c2 ff ff       	call   c0100cd7 <__panic>
    assert(page_ref(p1) == 2);
c0104a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a4d:	89 04 24             	mov    %eax,(%esp)
c0104a50:	e8 ce f0 ff ff       	call   c0103b23 <page_ref>
c0104a55:	83 f8 02             	cmp    $0x2,%eax
c0104a58:	74 24                	je     c0104a7e <check_pgdir+0x449>
c0104a5a:	c7 44 24 0c 34 6c 10 	movl   $0xc0106c34,0xc(%esp)
c0104a61:	c0 
c0104a62:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104a69:	c0 
c0104a6a:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
c0104a71:	00 
c0104a72:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104a79:	e8 59 c2 ff ff       	call   c0100cd7 <__panic>
    assert(page_ref(p2) == 0);
c0104a7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104a81:	89 04 24             	mov    %eax,(%esp)
c0104a84:	e8 9a f0 ff ff       	call   c0103b23 <page_ref>
c0104a89:	85 c0                	test   %eax,%eax
c0104a8b:	74 24                	je     c0104ab1 <check_pgdir+0x47c>
c0104a8d:	c7 44 24 0c 46 6c 10 	movl   $0xc0106c46,0xc(%esp)
c0104a94:	c0 
c0104a95:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104a9c:	c0 
c0104a9d:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0104aa4:	00 
c0104aa5:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104aac:	e8 26 c2 ff ff       	call   c0100cd7 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104ab1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104ab6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104abd:	00 
c0104abe:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104ac5:	00 
c0104ac6:	89 04 24             	mov    %eax,(%esp)
c0104ac9:	e8 8c f9 ff ff       	call   c010445a <get_pte>
c0104ace:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ad1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104ad5:	75 24                	jne    c0104afb <check_pgdir+0x4c6>
c0104ad7:	c7 44 24 0c 94 6b 10 	movl   $0xc0106b94,0xc(%esp)
c0104ade:	c0 
c0104adf:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104ae6:	c0 
c0104ae7:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
c0104aee:	00 
c0104aef:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104af6:	e8 dc c1 ff ff       	call   c0100cd7 <__panic>
    assert(pte2page(*ptep) == p1);
c0104afb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104afe:	8b 00                	mov    (%eax),%eax
c0104b00:	89 04 24             	mov    %eax,(%esp)
c0104b03:	e8 c5 ef ff ff       	call   c0103acd <pte2page>
c0104b08:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104b0b:	74 24                	je     c0104b31 <check_pgdir+0x4fc>
c0104b0d:	c7 44 24 0c 09 6b 10 	movl   $0xc0106b09,0xc(%esp)
c0104b14:	c0 
c0104b15:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104b1c:	c0 
c0104b1d:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0104b24:	00 
c0104b25:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104b2c:	e8 a6 c1 ff ff       	call   c0100cd7 <__panic>
    assert((*ptep & PTE_U) == 0);
c0104b31:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b34:	8b 00                	mov    (%eax),%eax
c0104b36:	83 e0 04             	and    $0x4,%eax
c0104b39:	85 c0                	test   %eax,%eax
c0104b3b:	74 24                	je     c0104b61 <check_pgdir+0x52c>
c0104b3d:	c7 44 24 0c 58 6c 10 	movl   $0xc0106c58,0xc(%esp)
c0104b44:	c0 
c0104b45:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104b4c:	c0 
c0104b4d:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c0104b54:	00 
c0104b55:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104b5c:	e8 76 c1 ff ff       	call   c0100cd7 <__panic>

    page_remove(boot_pgdir, 0x0);
c0104b61:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104b66:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104b6d:	00 
c0104b6e:	89 04 24             	mov    %eax,(%esp)
c0104b71:	e8 47 f9 ff ff       	call   c01044bd <page_remove>
    assert(page_ref(p1) == 1);
c0104b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b79:	89 04 24             	mov    %eax,(%esp)
c0104b7c:	e8 a2 ef ff ff       	call   c0103b23 <page_ref>
c0104b81:	83 f8 01             	cmp    $0x1,%eax
c0104b84:	74 24                	je     c0104baa <check_pgdir+0x575>
c0104b86:	c7 44 24 0c 1f 6b 10 	movl   $0xc0106b1f,0xc(%esp)
c0104b8d:	c0 
c0104b8e:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104b95:	c0 
c0104b96:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0104b9d:	00 
c0104b9e:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104ba5:	e8 2d c1 ff ff       	call   c0100cd7 <__panic>
    assert(page_ref(p2) == 0);
c0104baa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104bad:	89 04 24             	mov    %eax,(%esp)
c0104bb0:	e8 6e ef ff ff       	call   c0103b23 <page_ref>
c0104bb5:	85 c0                	test   %eax,%eax
c0104bb7:	74 24                	je     c0104bdd <check_pgdir+0x5a8>
c0104bb9:	c7 44 24 0c 46 6c 10 	movl   $0xc0106c46,0xc(%esp)
c0104bc0:	c0 
c0104bc1:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104bc8:	c0 
c0104bc9:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0104bd0:	00 
c0104bd1:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104bd8:	e8 fa c0 ff ff       	call   c0100cd7 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104bdd:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104be2:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104be9:	00 
c0104bea:	89 04 24             	mov    %eax,(%esp)
c0104bed:	e8 cb f8 ff ff       	call   c01044bd <page_remove>
    assert(page_ref(p1) == 0);
c0104bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bf5:	89 04 24             	mov    %eax,(%esp)
c0104bf8:	e8 26 ef ff ff       	call   c0103b23 <page_ref>
c0104bfd:	85 c0                	test   %eax,%eax
c0104bff:	74 24                	je     c0104c25 <check_pgdir+0x5f0>
c0104c01:	c7 44 24 0c 6d 6c 10 	movl   $0xc0106c6d,0xc(%esp)
c0104c08:	c0 
c0104c09:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104c10:	c0 
c0104c11:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c0104c18:	00 
c0104c19:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104c20:	e8 b2 c0 ff ff       	call   c0100cd7 <__panic>
    assert(page_ref(p2) == 0);
c0104c25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c28:	89 04 24             	mov    %eax,(%esp)
c0104c2b:	e8 f3 ee ff ff       	call   c0103b23 <page_ref>
c0104c30:	85 c0                	test   %eax,%eax
c0104c32:	74 24                	je     c0104c58 <check_pgdir+0x623>
c0104c34:	c7 44 24 0c 46 6c 10 	movl   $0xc0106c46,0xc(%esp)
c0104c3b:	c0 
c0104c3c:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104c43:	c0 
c0104c44:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c0104c4b:	00 
c0104c4c:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104c53:	e8 7f c0 ff ff       	call   c0100cd7 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0104c58:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104c5d:	8b 00                	mov    (%eax),%eax
c0104c5f:	89 04 24             	mov    %eax,(%esp)
c0104c62:	e8 a4 ee ff ff       	call   c0103b0b <pde2page>
c0104c67:	89 04 24             	mov    %eax,(%esp)
c0104c6a:	e8 b4 ee ff ff       	call   c0103b23 <page_ref>
c0104c6f:	83 f8 01             	cmp    $0x1,%eax
c0104c72:	74 24                	je     c0104c98 <check_pgdir+0x663>
c0104c74:	c7 44 24 0c 80 6c 10 	movl   $0xc0106c80,0xc(%esp)
c0104c7b:	c0 
c0104c7c:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104c83:	c0 
c0104c84:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0104c8b:	00 
c0104c8c:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104c93:	e8 3f c0 ff ff       	call   c0100cd7 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0104c98:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104c9d:	8b 00                	mov    (%eax),%eax
c0104c9f:	89 04 24             	mov    %eax,(%esp)
c0104ca2:	e8 64 ee ff ff       	call   c0103b0b <pde2page>
c0104ca7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104cae:	00 
c0104caf:	89 04 24             	mov    %eax,(%esp)
c0104cb2:	e8 9c f0 ff ff       	call   c0103d53 <free_pages>
    boot_pgdir[0] = 0;
c0104cb7:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104cbc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104cc2:	c7 04 24 a7 6c 10 c0 	movl   $0xc0106ca7,(%esp)
c0104cc9:	e8 6e b6 ff ff       	call   c010033c <cprintf>
}
c0104cce:	c9                   	leave  
c0104ccf:	c3                   	ret    

c0104cd0 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104cd0:	55                   	push   %ebp
c0104cd1:	89 e5                	mov    %esp,%ebp
c0104cd3:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104cd6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104cdd:	e9 ca 00 00 00       	jmp    c0104dac <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ce5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ce8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ceb:	c1 e8 0c             	shr    $0xc,%eax
c0104cee:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104cf1:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104cf6:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104cf9:	72 23                	jb     c0104d1e <check_boot_pgdir+0x4e>
c0104cfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cfe:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104d02:	c7 44 24 08 ec 68 10 	movl   $0xc01068ec,0x8(%esp)
c0104d09:	c0 
c0104d0a:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
c0104d11:	00 
c0104d12:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104d19:	e8 b9 bf ff ff       	call   c0100cd7 <__panic>
c0104d1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d21:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104d26:	89 c2                	mov    %eax,%edx
c0104d28:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104d2d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104d34:	00 
c0104d35:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104d39:	89 04 24             	mov    %eax,(%esp)
c0104d3c:	e8 19 f7 ff ff       	call   c010445a <get_pte>
c0104d41:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104d44:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104d48:	75 24                	jne    c0104d6e <check_boot_pgdir+0x9e>
c0104d4a:	c7 44 24 0c c4 6c 10 	movl   $0xc0106cc4,0xc(%esp)
c0104d51:	c0 
c0104d52:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104d59:	c0 
c0104d5a:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
c0104d61:	00 
c0104d62:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104d69:	e8 69 bf ff ff       	call   c0100cd7 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104d6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104d71:	8b 00                	mov    (%eax),%eax
c0104d73:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104d78:	89 c2                	mov    %eax,%edx
c0104d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d7d:	39 c2                	cmp    %eax,%edx
c0104d7f:	74 24                	je     c0104da5 <check_boot_pgdir+0xd5>
c0104d81:	c7 44 24 0c 01 6d 10 	movl   $0xc0106d01,0xc(%esp)
c0104d88:	c0 
c0104d89:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104d90:	c0 
c0104d91:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
c0104d98:	00 
c0104d99:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104da0:	e8 32 bf ff ff       	call   c0100cd7 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104da5:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104dac:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104daf:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104db4:	39 c2                	cmp    %eax,%edx
c0104db6:	0f 82 26 ff ff ff    	jb     c0104ce2 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104dbc:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104dc1:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104dc6:	8b 00                	mov    (%eax),%eax
c0104dc8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104dcd:	89 c2                	mov    %eax,%edx
c0104dcf:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104dd4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104dd7:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0104dde:	77 23                	ja     c0104e03 <check_boot_pgdir+0x133>
c0104de0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104de3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104de7:	c7 44 24 08 90 69 10 	movl   $0xc0106990,0x8(%esp)
c0104dee:	c0 
c0104def:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c0104df6:	00 
c0104df7:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104dfe:	e8 d4 be ff ff       	call   c0100cd7 <__panic>
c0104e03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e06:	05 00 00 00 40       	add    $0x40000000,%eax
c0104e0b:	39 c2                	cmp    %eax,%edx
c0104e0d:	74 24                	je     c0104e33 <check_boot_pgdir+0x163>
c0104e0f:	c7 44 24 0c 18 6d 10 	movl   $0xc0106d18,0xc(%esp)
c0104e16:	c0 
c0104e17:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104e1e:	c0 
c0104e1f:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c0104e26:	00 
c0104e27:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104e2e:	e8 a4 be ff ff       	call   c0100cd7 <__panic>

    assert(boot_pgdir[0] == 0);
c0104e33:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104e38:	8b 00                	mov    (%eax),%eax
c0104e3a:	85 c0                	test   %eax,%eax
c0104e3c:	74 24                	je     c0104e62 <check_boot_pgdir+0x192>
c0104e3e:	c7 44 24 0c 4c 6d 10 	movl   $0xc0106d4c,0xc(%esp)
c0104e45:	c0 
c0104e46:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104e4d:	c0 
c0104e4e:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
c0104e55:	00 
c0104e56:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104e5d:	e8 75 be ff ff       	call   c0100cd7 <__panic>

    struct Page *p;
    p = alloc_page();
c0104e62:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104e69:	e8 ad ee ff ff       	call   c0103d1b <alloc_pages>
c0104e6e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0104e71:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104e76:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104e7d:	00 
c0104e7e:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0104e85:	00 
c0104e86:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104e89:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104e8d:	89 04 24             	mov    %eax,(%esp)
c0104e90:	e8 6c f6 ff ff       	call   c0104501 <page_insert>
c0104e95:	85 c0                	test   %eax,%eax
c0104e97:	74 24                	je     c0104ebd <check_boot_pgdir+0x1ed>
c0104e99:	c7 44 24 0c 60 6d 10 	movl   $0xc0106d60,0xc(%esp)
c0104ea0:	c0 
c0104ea1:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104ea8:	c0 
c0104ea9:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
c0104eb0:	00 
c0104eb1:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104eb8:	e8 1a be ff ff       	call   c0100cd7 <__panic>
    assert(page_ref(p) == 1);
c0104ebd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104ec0:	89 04 24             	mov    %eax,(%esp)
c0104ec3:	e8 5b ec ff ff       	call   c0103b23 <page_ref>
c0104ec8:	83 f8 01             	cmp    $0x1,%eax
c0104ecb:	74 24                	je     c0104ef1 <check_boot_pgdir+0x221>
c0104ecd:	c7 44 24 0c 8e 6d 10 	movl   $0xc0106d8e,0xc(%esp)
c0104ed4:	c0 
c0104ed5:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104edc:	c0 
c0104edd:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
c0104ee4:	00 
c0104ee5:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104eec:	e8 e6 bd ff ff       	call   c0100cd7 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0104ef1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104ef6:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104efd:	00 
c0104efe:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0104f05:	00 
c0104f06:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104f09:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104f0d:	89 04 24             	mov    %eax,(%esp)
c0104f10:	e8 ec f5 ff ff       	call   c0104501 <page_insert>
c0104f15:	85 c0                	test   %eax,%eax
c0104f17:	74 24                	je     c0104f3d <check_boot_pgdir+0x26d>
c0104f19:	c7 44 24 0c a0 6d 10 	movl   $0xc0106da0,0xc(%esp)
c0104f20:	c0 
c0104f21:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104f28:	c0 
c0104f29:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c0104f30:	00 
c0104f31:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104f38:	e8 9a bd ff ff       	call   c0100cd7 <__panic>
    assert(page_ref(p) == 2);
c0104f3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104f40:	89 04 24             	mov    %eax,(%esp)
c0104f43:	e8 db eb ff ff       	call   c0103b23 <page_ref>
c0104f48:	83 f8 02             	cmp    $0x2,%eax
c0104f4b:	74 24                	je     c0104f71 <check_boot_pgdir+0x2a1>
c0104f4d:	c7 44 24 0c d7 6d 10 	movl   $0xc0106dd7,0xc(%esp)
c0104f54:	c0 
c0104f55:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104f5c:	c0 
c0104f5d:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c0104f64:	00 
c0104f65:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104f6c:	e8 66 bd ff ff       	call   c0100cd7 <__panic>

    const char *str = "ucore: Hello world!!";
c0104f71:	c7 45 dc e8 6d 10 c0 	movl   $0xc0106de8,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0104f78:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104f7b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104f7f:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104f86:	e8 19 0a 00 00       	call   c01059a4 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0104f8b:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0104f92:	00 
c0104f93:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104f9a:	e8 7e 0a 00 00       	call   c0105a1d <strcmp>
c0104f9f:	85 c0                	test   %eax,%eax
c0104fa1:	74 24                	je     c0104fc7 <check_boot_pgdir+0x2f7>
c0104fa3:	c7 44 24 0c 00 6e 10 	movl   $0xc0106e00,0xc(%esp)
c0104faa:	c0 
c0104fab:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104fb2:	c0 
c0104fb3:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
c0104fba:	00 
c0104fbb:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104fc2:	e8 10 bd ff ff       	call   c0100cd7 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0104fc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104fca:	89 04 24             	mov    %eax,(%esp)
c0104fcd:	e8 a7 ea ff ff       	call   c0103a79 <page2kva>
c0104fd2:	05 00 01 00 00       	add    $0x100,%eax
c0104fd7:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0104fda:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104fe1:	e8 66 09 00 00       	call   c010594c <strlen>
c0104fe6:	85 c0                	test   %eax,%eax
c0104fe8:	74 24                	je     c010500e <check_boot_pgdir+0x33e>
c0104fea:	c7 44 24 0c 38 6e 10 	movl   $0xc0106e38,0xc(%esp)
c0104ff1:	c0 
c0104ff2:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104ff9:	c0 
c0104ffa:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
c0105001:	00 
c0105002:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0105009:	e8 c9 bc ff ff       	call   c0100cd7 <__panic>

    free_page(p);
c010500e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105015:	00 
c0105016:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105019:	89 04 24             	mov    %eax,(%esp)
c010501c:	e8 32 ed ff ff       	call   c0103d53 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0105021:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105026:	8b 00                	mov    (%eax),%eax
c0105028:	89 04 24             	mov    %eax,(%esp)
c010502b:	e8 db ea ff ff       	call   c0103b0b <pde2page>
c0105030:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105037:	00 
c0105038:	89 04 24             	mov    %eax,(%esp)
c010503b:	e8 13 ed ff ff       	call   c0103d53 <free_pages>
    boot_pgdir[0] = 0;
c0105040:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105045:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c010504b:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c0105052:	e8 e5 b2 ff ff       	call   c010033c <cprintf>
}
c0105057:	c9                   	leave  
c0105058:	c3                   	ret    

c0105059 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0105059:	55                   	push   %ebp
c010505a:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c010505c:	8b 45 08             	mov    0x8(%ebp),%eax
c010505f:	83 e0 04             	and    $0x4,%eax
c0105062:	85 c0                	test   %eax,%eax
c0105064:	74 07                	je     c010506d <perm2str+0x14>
c0105066:	b8 75 00 00 00       	mov    $0x75,%eax
c010506b:	eb 05                	jmp    c0105072 <perm2str+0x19>
c010506d:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105072:	a2 48 89 11 c0       	mov    %al,0xc0118948
    str[1] = 'r';
c0105077:	c6 05 49 89 11 c0 72 	movb   $0x72,0xc0118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c010507e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105081:	83 e0 02             	and    $0x2,%eax
c0105084:	85 c0                	test   %eax,%eax
c0105086:	74 07                	je     c010508f <perm2str+0x36>
c0105088:	b8 77 00 00 00       	mov    $0x77,%eax
c010508d:	eb 05                	jmp    c0105094 <perm2str+0x3b>
c010508f:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105094:	a2 4a 89 11 c0       	mov    %al,0xc011894a
    str[3] = '\0';
c0105099:	c6 05 4b 89 11 c0 00 	movb   $0x0,0xc011894b
    return str;
c01050a0:	b8 48 89 11 c0       	mov    $0xc0118948,%eax
}
c01050a5:	5d                   	pop    %ebp
c01050a6:	c3                   	ret    

c01050a7 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c01050a7:	55                   	push   %ebp
c01050a8:	89 e5                	mov    %esp,%ebp
c01050aa:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c01050ad:	8b 45 10             	mov    0x10(%ebp),%eax
c01050b0:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01050b3:	72 0a                	jb     c01050bf <get_pgtable_items+0x18>
        return 0;
c01050b5:	b8 00 00 00 00       	mov    $0x0,%eax
c01050ba:	e9 9c 00 00 00       	jmp    c010515b <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c01050bf:	eb 04                	jmp    c01050c5 <get_pgtable_items+0x1e>
        start ++;
c01050c1:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c01050c5:	8b 45 10             	mov    0x10(%ebp),%eax
c01050c8:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01050cb:	73 18                	jae    c01050e5 <get_pgtable_items+0x3e>
c01050cd:	8b 45 10             	mov    0x10(%ebp),%eax
c01050d0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01050d7:	8b 45 14             	mov    0x14(%ebp),%eax
c01050da:	01 d0                	add    %edx,%eax
c01050dc:	8b 00                	mov    (%eax),%eax
c01050de:	83 e0 01             	and    $0x1,%eax
c01050e1:	85 c0                	test   %eax,%eax
c01050e3:	74 dc                	je     c01050c1 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c01050e5:	8b 45 10             	mov    0x10(%ebp),%eax
c01050e8:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01050eb:	73 69                	jae    c0105156 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c01050ed:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c01050f1:	74 08                	je     c01050fb <get_pgtable_items+0x54>
            *left_store = start;
c01050f3:	8b 45 18             	mov    0x18(%ebp),%eax
c01050f6:	8b 55 10             	mov    0x10(%ebp),%edx
c01050f9:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c01050fb:	8b 45 10             	mov    0x10(%ebp),%eax
c01050fe:	8d 50 01             	lea    0x1(%eax),%edx
c0105101:	89 55 10             	mov    %edx,0x10(%ebp)
c0105104:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010510b:	8b 45 14             	mov    0x14(%ebp),%eax
c010510e:	01 d0                	add    %edx,%eax
c0105110:	8b 00                	mov    (%eax),%eax
c0105112:	83 e0 07             	and    $0x7,%eax
c0105115:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105118:	eb 04                	jmp    c010511e <get_pgtable_items+0x77>
            start ++;
c010511a:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c010511e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105121:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105124:	73 1d                	jae    c0105143 <get_pgtable_items+0x9c>
c0105126:	8b 45 10             	mov    0x10(%ebp),%eax
c0105129:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105130:	8b 45 14             	mov    0x14(%ebp),%eax
c0105133:	01 d0                	add    %edx,%eax
c0105135:	8b 00                	mov    (%eax),%eax
c0105137:	83 e0 07             	and    $0x7,%eax
c010513a:	89 c2                	mov    %eax,%edx
c010513c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010513f:	39 c2                	cmp    %eax,%edx
c0105141:	74 d7                	je     c010511a <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c0105143:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105147:	74 08                	je     c0105151 <get_pgtable_items+0xaa>
            *right_store = start;
c0105149:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010514c:	8b 55 10             	mov    0x10(%ebp),%edx
c010514f:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0105151:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105154:	eb 05                	jmp    c010515b <get_pgtable_items+0xb4>
    }
    return 0;
c0105156:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010515b:	c9                   	leave  
c010515c:	c3                   	ret    

c010515d <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c010515d:	55                   	push   %ebp
c010515e:	89 e5                	mov    %esp,%ebp
c0105160:	57                   	push   %edi
c0105161:	56                   	push   %esi
c0105162:	53                   	push   %ebx
c0105163:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0105166:	c7 04 24 7c 6e 10 c0 	movl   $0xc0106e7c,(%esp)
c010516d:	e8 ca b1 ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
c0105172:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105179:	e9 fa 00 00 00       	jmp    c0105278 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010517e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105181:	89 04 24             	mov    %eax,(%esp)
c0105184:	e8 d0 fe ff ff       	call   c0105059 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0105189:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010518c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010518f:	29 d1                	sub    %edx,%ecx
c0105191:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105193:	89 d6                	mov    %edx,%esi
c0105195:	c1 e6 16             	shl    $0x16,%esi
c0105198:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010519b:	89 d3                	mov    %edx,%ebx
c010519d:	c1 e3 16             	shl    $0x16,%ebx
c01051a0:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01051a3:	89 d1                	mov    %edx,%ecx
c01051a5:	c1 e1 16             	shl    $0x16,%ecx
c01051a8:	8b 7d dc             	mov    -0x24(%ebp),%edi
c01051ab:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01051ae:	29 d7                	sub    %edx,%edi
c01051b0:	89 fa                	mov    %edi,%edx
c01051b2:	89 44 24 14          	mov    %eax,0x14(%esp)
c01051b6:	89 74 24 10          	mov    %esi,0x10(%esp)
c01051ba:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01051be:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01051c2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01051c6:	c7 04 24 ad 6e 10 c0 	movl   $0xc0106ead,(%esp)
c01051cd:	e8 6a b1 ff ff       	call   c010033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c01051d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01051d5:	c1 e0 0a             	shl    $0xa,%eax
c01051d8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01051db:	eb 54                	jmp    c0105231 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01051dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01051e0:	89 04 24             	mov    %eax,(%esp)
c01051e3:	e8 71 fe ff ff       	call   c0105059 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c01051e8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01051eb:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01051ee:	29 d1                	sub    %edx,%ecx
c01051f0:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01051f2:	89 d6                	mov    %edx,%esi
c01051f4:	c1 e6 0c             	shl    $0xc,%esi
c01051f7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01051fa:	89 d3                	mov    %edx,%ebx
c01051fc:	c1 e3 0c             	shl    $0xc,%ebx
c01051ff:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105202:	c1 e2 0c             	shl    $0xc,%edx
c0105205:	89 d1                	mov    %edx,%ecx
c0105207:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c010520a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010520d:	29 d7                	sub    %edx,%edi
c010520f:	89 fa                	mov    %edi,%edx
c0105211:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105215:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105219:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010521d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105221:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105225:	c7 04 24 cc 6e 10 c0 	movl   $0xc0106ecc,(%esp)
c010522c:	e8 0b b1 ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105231:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c0105236:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105239:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010523c:	89 ce                	mov    %ecx,%esi
c010523e:	c1 e6 0a             	shl    $0xa,%esi
c0105241:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0105244:	89 cb                	mov    %ecx,%ebx
c0105246:	c1 e3 0a             	shl    $0xa,%ebx
c0105249:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c010524c:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105250:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c0105253:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105257:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010525b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010525f:	89 74 24 04          	mov    %esi,0x4(%esp)
c0105263:	89 1c 24             	mov    %ebx,(%esp)
c0105266:	e8 3c fe ff ff       	call   c01050a7 <get_pgtable_items>
c010526b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010526e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105272:	0f 85 65 ff ff ff    	jne    c01051dd <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105278:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c010527d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105280:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c0105283:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105287:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c010528a:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010528e:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105292:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105296:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c010529d:	00 
c010529e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01052a5:	e8 fd fd ff ff       	call   c01050a7 <get_pgtable_items>
c01052aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01052ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01052b1:	0f 85 c7 fe ff ff    	jne    c010517e <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01052b7:	c7 04 24 f0 6e 10 c0 	movl   $0xc0106ef0,(%esp)
c01052be:	e8 79 b0 ff ff       	call   c010033c <cprintf>
}
c01052c3:	83 c4 4c             	add    $0x4c,%esp
c01052c6:	5b                   	pop    %ebx
c01052c7:	5e                   	pop    %esi
c01052c8:	5f                   	pop    %edi
c01052c9:	5d                   	pop    %ebp
c01052ca:	c3                   	ret    

c01052cb <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01052cb:	55                   	push   %ebp
c01052cc:	89 e5                	mov    %esp,%ebp
c01052ce:	83 ec 58             	sub    $0x58,%esp
c01052d1:	8b 45 10             	mov    0x10(%ebp),%eax
c01052d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01052d7:	8b 45 14             	mov    0x14(%ebp),%eax
c01052da:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c01052dd:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01052e0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01052e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01052e6:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01052e9:	8b 45 18             	mov    0x18(%ebp),%eax
c01052ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01052ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01052f2:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01052f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01052f8:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01052fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01052fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105301:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105305:	74 1c                	je     c0105323 <printnum+0x58>
c0105307:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010530a:	ba 00 00 00 00       	mov    $0x0,%edx
c010530f:	f7 75 e4             	divl   -0x1c(%ebp)
c0105312:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105315:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105318:	ba 00 00 00 00       	mov    $0x0,%edx
c010531d:	f7 75 e4             	divl   -0x1c(%ebp)
c0105320:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105323:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105326:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105329:	f7 75 e4             	divl   -0x1c(%ebp)
c010532c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010532f:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105332:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105335:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105338:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010533b:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010533e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105341:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0105344:	8b 45 18             	mov    0x18(%ebp),%eax
c0105347:	ba 00 00 00 00       	mov    $0x0,%edx
c010534c:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010534f:	77 56                	ja     c01053a7 <printnum+0xdc>
c0105351:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105354:	72 05                	jb     c010535b <printnum+0x90>
c0105356:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0105359:	77 4c                	ja     c01053a7 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c010535b:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010535e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105361:	8b 45 20             	mov    0x20(%ebp),%eax
c0105364:	89 44 24 18          	mov    %eax,0x18(%esp)
c0105368:	89 54 24 14          	mov    %edx,0x14(%esp)
c010536c:	8b 45 18             	mov    0x18(%ebp),%eax
c010536f:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105373:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105376:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105379:	89 44 24 08          	mov    %eax,0x8(%esp)
c010537d:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105381:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105384:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105388:	8b 45 08             	mov    0x8(%ebp),%eax
c010538b:	89 04 24             	mov    %eax,(%esp)
c010538e:	e8 38 ff ff ff       	call   c01052cb <printnum>
c0105393:	eb 1c                	jmp    c01053b1 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0105395:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105398:	89 44 24 04          	mov    %eax,0x4(%esp)
c010539c:	8b 45 20             	mov    0x20(%ebp),%eax
c010539f:	89 04 24             	mov    %eax,(%esp)
c01053a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01053a5:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c01053a7:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c01053ab:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01053af:	7f e4                	jg     c0105395 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01053b1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01053b4:	05 a4 6f 10 c0       	add    $0xc0106fa4,%eax
c01053b9:	0f b6 00             	movzbl (%eax),%eax
c01053bc:	0f be c0             	movsbl %al,%eax
c01053bf:	8b 55 0c             	mov    0xc(%ebp),%edx
c01053c2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01053c6:	89 04 24             	mov    %eax,(%esp)
c01053c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01053cc:	ff d0                	call   *%eax
}
c01053ce:	c9                   	leave  
c01053cf:	c3                   	ret    

c01053d0 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01053d0:	55                   	push   %ebp
c01053d1:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01053d3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01053d7:	7e 14                	jle    c01053ed <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01053d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01053dc:	8b 00                	mov    (%eax),%eax
c01053de:	8d 48 08             	lea    0x8(%eax),%ecx
c01053e1:	8b 55 08             	mov    0x8(%ebp),%edx
c01053e4:	89 0a                	mov    %ecx,(%edx)
c01053e6:	8b 50 04             	mov    0x4(%eax),%edx
c01053e9:	8b 00                	mov    (%eax),%eax
c01053eb:	eb 30                	jmp    c010541d <getuint+0x4d>
    }
    else if (lflag) {
c01053ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01053f1:	74 16                	je     c0105409 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c01053f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01053f6:	8b 00                	mov    (%eax),%eax
c01053f8:	8d 48 04             	lea    0x4(%eax),%ecx
c01053fb:	8b 55 08             	mov    0x8(%ebp),%edx
c01053fe:	89 0a                	mov    %ecx,(%edx)
c0105400:	8b 00                	mov    (%eax),%eax
c0105402:	ba 00 00 00 00       	mov    $0x0,%edx
c0105407:	eb 14                	jmp    c010541d <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105409:	8b 45 08             	mov    0x8(%ebp),%eax
c010540c:	8b 00                	mov    (%eax),%eax
c010540e:	8d 48 04             	lea    0x4(%eax),%ecx
c0105411:	8b 55 08             	mov    0x8(%ebp),%edx
c0105414:	89 0a                	mov    %ecx,(%edx)
c0105416:	8b 00                	mov    (%eax),%eax
c0105418:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c010541d:	5d                   	pop    %ebp
c010541e:	c3                   	ret    

c010541f <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c010541f:	55                   	push   %ebp
c0105420:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105422:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105426:	7e 14                	jle    c010543c <getint+0x1d>
        return va_arg(*ap, long long);
c0105428:	8b 45 08             	mov    0x8(%ebp),%eax
c010542b:	8b 00                	mov    (%eax),%eax
c010542d:	8d 48 08             	lea    0x8(%eax),%ecx
c0105430:	8b 55 08             	mov    0x8(%ebp),%edx
c0105433:	89 0a                	mov    %ecx,(%edx)
c0105435:	8b 50 04             	mov    0x4(%eax),%edx
c0105438:	8b 00                	mov    (%eax),%eax
c010543a:	eb 28                	jmp    c0105464 <getint+0x45>
    }
    else if (lflag) {
c010543c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105440:	74 12                	je     c0105454 <getint+0x35>
        return va_arg(*ap, long);
c0105442:	8b 45 08             	mov    0x8(%ebp),%eax
c0105445:	8b 00                	mov    (%eax),%eax
c0105447:	8d 48 04             	lea    0x4(%eax),%ecx
c010544a:	8b 55 08             	mov    0x8(%ebp),%edx
c010544d:	89 0a                	mov    %ecx,(%edx)
c010544f:	8b 00                	mov    (%eax),%eax
c0105451:	99                   	cltd   
c0105452:	eb 10                	jmp    c0105464 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0105454:	8b 45 08             	mov    0x8(%ebp),%eax
c0105457:	8b 00                	mov    (%eax),%eax
c0105459:	8d 48 04             	lea    0x4(%eax),%ecx
c010545c:	8b 55 08             	mov    0x8(%ebp),%edx
c010545f:	89 0a                	mov    %ecx,(%edx)
c0105461:	8b 00                	mov    (%eax),%eax
c0105463:	99                   	cltd   
    }
}
c0105464:	5d                   	pop    %ebp
c0105465:	c3                   	ret    

c0105466 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0105466:	55                   	push   %ebp
c0105467:	89 e5                	mov    %esp,%ebp
c0105469:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c010546c:	8d 45 14             	lea    0x14(%ebp),%eax
c010546f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0105472:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105475:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105479:	8b 45 10             	mov    0x10(%ebp),%eax
c010547c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105480:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105483:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105487:	8b 45 08             	mov    0x8(%ebp),%eax
c010548a:	89 04 24             	mov    %eax,(%esp)
c010548d:	e8 02 00 00 00       	call   c0105494 <vprintfmt>
    va_end(ap);
}
c0105492:	c9                   	leave  
c0105493:	c3                   	ret    

c0105494 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0105494:	55                   	push   %ebp
c0105495:	89 e5                	mov    %esp,%ebp
c0105497:	56                   	push   %esi
c0105498:	53                   	push   %ebx
c0105499:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010549c:	eb 18                	jmp    c01054b6 <vprintfmt+0x22>
            if (ch == '\0') {
c010549e:	85 db                	test   %ebx,%ebx
c01054a0:	75 05                	jne    c01054a7 <vprintfmt+0x13>
                return;
c01054a2:	e9 d1 03 00 00       	jmp    c0105878 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c01054a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054aa:	89 44 24 04          	mov    %eax,0x4(%esp)
c01054ae:	89 1c 24             	mov    %ebx,(%esp)
c01054b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01054b4:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01054b6:	8b 45 10             	mov    0x10(%ebp),%eax
c01054b9:	8d 50 01             	lea    0x1(%eax),%edx
c01054bc:	89 55 10             	mov    %edx,0x10(%ebp)
c01054bf:	0f b6 00             	movzbl (%eax),%eax
c01054c2:	0f b6 d8             	movzbl %al,%ebx
c01054c5:	83 fb 25             	cmp    $0x25,%ebx
c01054c8:	75 d4                	jne    c010549e <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c01054ca:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c01054ce:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c01054d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01054d8:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01054db:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01054e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01054e5:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01054e8:	8b 45 10             	mov    0x10(%ebp),%eax
c01054eb:	8d 50 01             	lea    0x1(%eax),%edx
c01054ee:	89 55 10             	mov    %edx,0x10(%ebp)
c01054f1:	0f b6 00             	movzbl (%eax),%eax
c01054f4:	0f b6 d8             	movzbl %al,%ebx
c01054f7:	8d 43 dd             	lea    -0x23(%ebx),%eax
c01054fa:	83 f8 55             	cmp    $0x55,%eax
c01054fd:	0f 87 44 03 00 00    	ja     c0105847 <vprintfmt+0x3b3>
c0105503:	8b 04 85 c8 6f 10 c0 	mov    -0x3fef9038(,%eax,4),%eax
c010550a:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c010550c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105510:	eb d6                	jmp    c01054e8 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105512:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105516:	eb d0                	jmp    c01054e8 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105518:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c010551f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105522:	89 d0                	mov    %edx,%eax
c0105524:	c1 e0 02             	shl    $0x2,%eax
c0105527:	01 d0                	add    %edx,%eax
c0105529:	01 c0                	add    %eax,%eax
c010552b:	01 d8                	add    %ebx,%eax
c010552d:	83 e8 30             	sub    $0x30,%eax
c0105530:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105533:	8b 45 10             	mov    0x10(%ebp),%eax
c0105536:	0f b6 00             	movzbl (%eax),%eax
c0105539:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c010553c:	83 fb 2f             	cmp    $0x2f,%ebx
c010553f:	7e 0b                	jle    c010554c <vprintfmt+0xb8>
c0105541:	83 fb 39             	cmp    $0x39,%ebx
c0105544:	7f 06                	jg     c010554c <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105546:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c010554a:	eb d3                	jmp    c010551f <vprintfmt+0x8b>
            goto process_precision;
c010554c:	eb 33                	jmp    c0105581 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c010554e:	8b 45 14             	mov    0x14(%ebp),%eax
c0105551:	8d 50 04             	lea    0x4(%eax),%edx
c0105554:	89 55 14             	mov    %edx,0x14(%ebp)
c0105557:	8b 00                	mov    (%eax),%eax
c0105559:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c010555c:	eb 23                	jmp    c0105581 <vprintfmt+0xed>

        case '.':
            if (width < 0)
c010555e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105562:	79 0c                	jns    c0105570 <vprintfmt+0xdc>
                width = 0;
c0105564:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c010556b:	e9 78 ff ff ff       	jmp    c01054e8 <vprintfmt+0x54>
c0105570:	e9 73 ff ff ff       	jmp    c01054e8 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c0105575:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c010557c:	e9 67 ff ff ff       	jmp    c01054e8 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c0105581:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105585:	79 12                	jns    c0105599 <vprintfmt+0x105>
                width = precision, precision = -1;
c0105587:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010558a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010558d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0105594:	e9 4f ff ff ff       	jmp    c01054e8 <vprintfmt+0x54>
c0105599:	e9 4a ff ff ff       	jmp    c01054e8 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c010559e:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c01055a2:	e9 41 ff ff ff       	jmp    c01054e8 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01055a7:	8b 45 14             	mov    0x14(%ebp),%eax
c01055aa:	8d 50 04             	lea    0x4(%eax),%edx
c01055ad:	89 55 14             	mov    %edx,0x14(%ebp)
c01055b0:	8b 00                	mov    (%eax),%eax
c01055b2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01055b5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01055b9:	89 04 24             	mov    %eax,(%esp)
c01055bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01055bf:	ff d0                	call   *%eax
            break;
c01055c1:	e9 ac 02 00 00       	jmp    c0105872 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01055c6:	8b 45 14             	mov    0x14(%ebp),%eax
c01055c9:	8d 50 04             	lea    0x4(%eax),%edx
c01055cc:	89 55 14             	mov    %edx,0x14(%ebp)
c01055cf:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c01055d1:	85 db                	test   %ebx,%ebx
c01055d3:	79 02                	jns    c01055d7 <vprintfmt+0x143>
                err = -err;
c01055d5:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c01055d7:	83 fb 06             	cmp    $0x6,%ebx
c01055da:	7f 0b                	jg     c01055e7 <vprintfmt+0x153>
c01055dc:	8b 34 9d 88 6f 10 c0 	mov    -0x3fef9078(,%ebx,4),%esi
c01055e3:	85 f6                	test   %esi,%esi
c01055e5:	75 23                	jne    c010560a <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c01055e7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01055eb:	c7 44 24 08 b5 6f 10 	movl   $0xc0106fb5,0x8(%esp)
c01055f2:	c0 
c01055f3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01055fd:	89 04 24             	mov    %eax,(%esp)
c0105600:	e8 61 fe ff ff       	call   c0105466 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105605:	e9 68 02 00 00       	jmp    c0105872 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c010560a:	89 74 24 0c          	mov    %esi,0xc(%esp)
c010560e:	c7 44 24 08 be 6f 10 	movl   $0xc0106fbe,0x8(%esp)
c0105615:	c0 
c0105616:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105619:	89 44 24 04          	mov    %eax,0x4(%esp)
c010561d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105620:	89 04 24             	mov    %eax,(%esp)
c0105623:	e8 3e fe ff ff       	call   c0105466 <printfmt>
            }
            break;
c0105628:	e9 45 02 00 00       	jmp    c0105872 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c010562d:	8b 45 14             	mov    0x14(%ebp),%eax
c0105630:	8d 50 04             	lea    0x4(%eax),%edx
c0105633:	89 55 14             	mov    %edx,0x14(%ebp)
c0105636:	8b 30                	mov    (%eax),%esi
c0105638:	85 f6                	test   %esi,%esi
c010563a:	75 05                	jne    c0105641 <vprintfmt+0x1ad>
                p = "(null)";
c010563c:	be c1 6f 10 c0       	mov    $0xc0106fc1,%esi
            }
            if (width > 0 && padc != '-') {
c0105641:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105645:	7e 3e                	jle    c0105685 <vprintfmt+0x1f1>
c0105647:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c010564b:	74 38                	je     c0105685 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c010564d:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c0105650:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105653:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105657:	89 34 24             	mov    %esi,(%esp)
c010565a:	e8 15 03 00 00       	call   c0105974 <strnlen>
c010565f:	29 c3                	sub    %eax,%ebx
c0105661:	89 d8                	mov    %ebx,%eax
c0105663:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105666:	eb 17                	jmp    c010567f <vprintfmt+0x1eb>
                    putch(padc, putdat);
c0105668:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c010566c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010566f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105673:	89 04 24             	mov    %eax,(%esp)
c0105676:	8b 45 08             	mov    0x8(%ebp),%eax
c0105679:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c010567b:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010567f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105683:	7f e3                	jg     c0105668 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105685:	eb 38                	jmp    c01056bf <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c0105687:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010568b:	74 1f                	je     c01056ac <vprintfmt+0x218>
c010568d:	83 fb 1f             	cmp    $0x1f,%ebx
c0105690:	7e 05                	jle    c0105697 <vprintfmt+0x203>
c0105692:	83 fb 7e             	cmp    $0x7e,%ebx
c0105695:	7e 15                	jle    c01056ac <vprintfmt+0x218>
                    putch('?', putdat);
c0105697:	8b 45 0c             	mov    0xc(%ebp),%eax
c010569a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010569e:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c01056a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01056a8:	ff d0                	call   *%eax
c01056aa:	eb 0f                	jmp    c01056bb <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c01056ac:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056b3:	89 1c 24             	mov    %ebx,(%esp)
c01056b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01056b9:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01056bb:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01056bf:	89 f0                	mov    %esi,%eax
c01056c1:	8d 70 01             	lea    0x1(%eax),%esi
c01056c4:	0f b6 00             	movzbl (%eax),%eax
c01056c7:	0f be d8             	movsbl %al,%ebx
c01056ca:	85 db                	test   %ebx,%ebx
c01056cc:	74 10                	je     c01056de <vprintfmt+0x24a>
c01056ce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01056d2:	78 b3                	js     c0105687 <vprintfmt+0x1f3>
c01056d4:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c01056d8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01056dc:	79 a9                	jns    c0105687 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01056de:	eb 17                	jmp    c01056f7 <vprintfmt+0x263>
                putch(' ', putdat);
c01056e0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056e3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056e7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01056ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01056f1:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01056f3:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01056f7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01056fb:	7f e3                	jg     c01056e0 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c01056fd:	e9 70 01 00 00       	jmp    c0105872 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105702:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105705:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105709:	8d 45 14             	lea    0x14(%ebp),%eax
c010570c:	89 04 24             	mov    %eax,(%esp)
c010570f:	e8 0b fd ff ff       	call   c010541f <getint>
c0105714:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105717:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c010571a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010571d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105720:	85 d2                	test   %edx,%edx
c0105722:	79 26                	jns    c010574a <vprintfmt+0x2b6>
                putch('-', putdat);
c0105724:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105727:	89 44 24 04          	mov    %eax,0x4(%esp)
c010572b:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105732:	8b 45 08             	mov    0x8(%ebp),%eax
c0105735:	ff d0                	call   *%eax
                num = -(long long)num;
c0105737:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010573a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010573d:	f7 d8                	neg    %eax
c010573f:	83 d2 00             	adc    $0x0,%edx
c0105742:	f7 da                	neg    %edx
c0105744:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105747:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c010574a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105751:	e9 a8 00 00 00       	jmp    c01057fe <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105756:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105759:	89 44 24 04          	mov    %eax,0x4(%esp)
c010575d:	8d 45 14             	lea    0x14(%ebp),%eax
c0105760:	89 04 24             	mov    %eax,(%esp)
c0105763:	e8 68 fc ff ff       	call   c01053d0 <getuint>
c0105768:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010576b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c010576e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105775:	e9 84 00 00 00       	jmp    c01057fe <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c010577a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010577d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105781:	8d 45 14             	lea    0x14(%ebp),%eax
c0105784:	89 04 24             	mov    %eax,(%esp)
c0105787:	e8 44 fc ff ff       	call   c01053d0 <getuint>
c010578c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010578f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105792:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105799:	eb 63                	jmp    c01057fe <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c010579b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010579e:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057a2:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c01057a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01057ac:	ff d0                	call   *%eax
            putch('x', putdat);
c01057ae:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057b5:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c01057bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01057bf:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c01057c1:	8b 45 14             	mov    0x14(%ebp),%eax
c01057c4:	8d 50 04             	lea    0x4(%eax),%edx
c01057c7:	89 55 14             	mov    %edx,0x14(%ebp)
c01057ca:	8b 00                	mov    (%eax),%eax
c01057cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01057cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c01057d6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c01057dd:	eb 1f                	jmp    c01057fe <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c01057df:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01057e2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057e6:	8d 45 14             	lea    0x14(%ebp),%eax
c01057e9:	89 04 24             	mov    %eax,(%esp)
c01057ec:	e8 df fb ff ff       	call   c01053d0 <getuint>
c01057f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01057f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c01057f7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c01057fe:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105802:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105805:	89 54 24 18          	mov    %edx,0x18(%esp)
c0105809:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010580c:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105810:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105814:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105817:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010581a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010581e:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105822:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105825:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105829:	8b 45 08             	mov    0x8(%ebp),%eax
c010582c:	89 04 24             	mov    %eax,(%esp)
c010582f:	e8 97 fa ff ff       	call   c01052cb <printnum>
            break;
c0105834:	eb 3c                	jmp    c0105872 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105836:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105839:	89 44 24 04          	mov    %eax,0x4(%esp)
c010583d:	89 1c 24             	mov    %ebx,(%esp)
c0105840:	8b 45 08             	mov    0x8(%ebp),%eax
c0105843:	ff d0                	call   *%eax
            break;
c0105845:	eb 2b                	jmp    c0105872 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105847:	8b 45 0c             	mov    0xc(%ebp),%eax
c010584a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010584e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0105855:	8b 45 08             	mov    0x8(%ebp),%eax
c0105858:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c010585a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010585e:	eb 04                	jmp    c0105864 <vprintfmt+0x3d0>
c0105860:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105864:	8b 45 10             	mov    0x10(%ebp),%eax
c0105867:	83 e8 01             	sub    $0x1,%eax
c010586a:	0f b6 00             	movzbl (%eax),%eax
c010586d:	3c 25                	cmp    $0x25,%al
c010586f:	75 ef                	jne    c0105860 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c0105871:	90                   	nop
        }
    }
c0105872:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105873:	e9 3e fc ff ff       	jmp    c01054b6 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0105878:	83 c4 40             	add    $0x40,%esp
c010587b:	5b                   	pop    %ebx
c010587c:	5e                   	pop    %esi
c010587d:	5d                   	pop    %ebp
c010587e:	c3                   	ret    

c010587f <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c010587f:	55                   	push   %ebp
c0105880:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105882:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105885:	8b 40 08             	mov    0x8(%eax),%eax
c0105888:	8d 50 01             	lea    0x1(%eax),%edx
c010588b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010588e:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105891:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105894:	8b 10                	mov    (%eax),%edx
c0105896:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105899:	8b 40 04             	mov    0x4(%eax),%eax
c010589c:	39 c2                	cmp    %eax,%edx
c010589e:	73 12                	jae    c01058b2 <sprintputch+0x33>
        *b->buf ++ = ch;
c01058a0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058a3:	8b 00                	mov    (%eax),%eax
c01058a5:	8d 48 01             	lea    0x1(%eax),%ecx
c01058a8:	8b 55 0c             	mov    0xc(%ebp),%edx
c01058ab:	89 0a                	mov    %ecx,(%edx)
c01058ad:	8b 55 08             	mov    0x8(%ebp),%edx
c01058b0:	88 10                	mov    %dl,(%eax)
    }
}
c01058b2:	5d                   	pop    %ebp
c01058b3:	c3                   	ret    

c01058b4 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c01058b4:	55                   	push   %ebp
c01058b5:	89 e5                	mov    %esp,%ebp
c01058b7:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01058ba:	8d 45 14             	lea    0x14(%ebp),%eax
c01058bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c01058c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01058c7:	8b 45 10             	mov    0x10(%ebp),%eax
c01058ca:	89 44 24 08          	mov    %eax,0x8(%esp)
c01058ce:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01058d8:	89 04 24             	mov    %eax,(%esp)
c01058db:	e8 08 00 00 00       	call   c01058e8 <vsnprintf>
c01058e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01058e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01058e6:	c9                   	leave  
c01058e7:	c3                   	ret    

c01058e8 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c01058e8:	55                   	push   %ebp
c01058e9:	89 e5                	mov    %esp,%ebp
c01058eb:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c01058ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01058f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01058f4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058f7:	8d 50 ff             	lea    -0x1(%eax),%edx
c01058fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01058fd:	01 d0                	add    %edx,%eax
c01058ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105902:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105909:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010590d:	74 0a                	je     c0105919 <vsnprintf+0x31>
c010590f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105912:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105915:	39 c2                	cmp    %eax,%edx
c0105917:	76 07                	jbe    c0105920 <vsnprintf+0x38>
        return -E_INVAL;
c0105919:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c010591e:	eb 2a                	jmp    c010594a <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105920:	8b 45 14             	mov    0x14(%ebp),%eax
c0105923:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105927:	8b 45 10             	mov    0x10(%ebp),%eax
c010592a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010592e:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105931:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105935:	c7 04 24 7f 58 10 c0 	movl   $0xc010587f,(%esp)
c010593c:	e8 53 fb ff ff       	call   c0105494 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105941:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105944:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105947:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010594a:	c9                   	leave  
c010594b:	c3                   	ret    

c010594c <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c010594c:	55                   	push   %ebp
c010594d:	89 e5                	mov    %esp,%ebp
c010594f:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105952:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105959:	eb 04                	jmp    c010595f <strlen+0x13>
        cnt ++;
c010595b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c010595f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105962:	8d 50 01             	lea    0x1(%eax),%edx
c0105965:	89 55 08             	mov    %edx,0x8(%ebp)
c0105968:	0f b6 00             	movzbl (%eax),%eax
c010596b:	84 c0                	test   %al,%al
c010596d:	75 ec                	jne    c010595b <strlen+0xf>
        cnt ++;
    }
    return cnt;
c010596f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105972:	c9                   	leave  
c0105973:	c3                   	ret    

c0105974 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105974:	55                   	push   %ebp
c0105975:	89 e5                	mov    %esp,%ebp
c0105977:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010597a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105981:	eb 04                	jmp    c0105987 <strnlen+0x13>
        cnt ++;
c0105983:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0105987:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010598a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010598d:	73 10                	jae    c010599f <strnlen+0x2b>
c010598f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105992:	8d 50 01             	lea    0x1(%eax),%edx
c0105995:	89 55 08             	mov    %edx,0x8(%ebp)
c0105998:	0f b6 00             	movzbl (%eax),%eax
c010599b:	84 c0                	test   %al,%al
c010599d:	75 e4                	jne    c0105983 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c010599f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01059a2:	c9                   	leave  
c01059a3:	c3                   	ret    

c01059a4 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c01059a4:	55                   	push   %ebp
c01059a5:	89 e5                	mov    %esp,%ebp
c01059a7:	57                   	push   %edi
c01059a8:	56                   	push   %esi
c01059a9:	83 ec 20             	sub    $0x20,%esp
c01059ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01059af:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01059b2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c01059b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01059bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059be:	89 d1                	mov    %edx,%ecx
c01059c0:	89 c2                	mov    %eax,%edx
c01059c2:	89 ce                	mov    %ecx,%esi
c01059c4:	89 d7                	mov    %edx,%edi
c01059c6:	ac                   	lods   %ds:(%esi),%al
c01059c7:	aa                   	stos   %al,%es:(%edi)
c01059c8:	84 c0                	test   %al,%al
c01059ca:	75 fa                	jne    c01059c6 <strcpy+0x22>
c01059cc:	89 fa                	mov    %edi,%edx
c01059ce:	89 f1                	mov    %esi,%ecx
c01059d0:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01059d3:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01059d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c01059d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c01059dc:	83 c4 20             	add    $0x20,%esp
c01059df:	5e                   	pop    %esi
c01059e0:	5f                   	pop    %edi
c01059e1:	5d                   	pop    %ebp
c01059e2:	c3                   	ret    

c01059e3 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c01059e3:	55                   	push   %ebp
c01059e4:	89 e5                	mov    %esp,%ebp
c01059e6:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c01059e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01059ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c01059ef:	eb 21                	jmp    c0105a12 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c01059f1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059f4:	0f b6 10             	movzbl (%eax),%edx
c01059f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01059fa:	88 10                	mov    %dl,(%eax)
c01059fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01059ff:	0f b6 00             	movzbl (%eax),%eax
c0105a02:	84 c0                	test   %al,%al
c0105a04:	74 04                	je     c0105a0a <strncpy+0x27>
            src ++;
c0105a06:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105a0a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105a0e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0105a12:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105a16:	75 d9                	jne    c01059f1 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105a18:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105a1b:	c9                   	leave  
c0105a1c:	c3                   	ret    

c0105a1d <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105a1d:	55                   	push   %ebp
c0105a1e:	89 e5                	mov    %esp,%ebp
c0105a20:	57                   	push   %edi
c0105a21:	56                   	push   %esi
c0105a22:	83 ec 20             	sub    $0x20,%esp
c0105a25:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a28:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105a2b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0105a31:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a34:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a37:	89 d1                	mov    %edx,%ecx
c0105a39:	89 c2                	mov    %eax,%edx
c0105a3b:	89 ce                	mov    %ecx,%esi
c0105a3d:	89 d7                	mov    %edx,%edi
c0105a3f:	ac                   	lods   %ds:(%esi),%al
c0105a40:	ae                   	scas   %es:(%edi),%al
c0105a41:	75 08                	jne    c0105a4b <strcmp+0x2e>
c0105a43:	84 c0                	test   %al,%al
c0105a45:	75 f8                	jne    c0105a3f <strcmp+0x22>
c0105a47:	31 c0                	xor    %eax,%eax
c0105a49:	eb 04                	jmp    c0105a4f <strcmp+0x32>
c0105a4b:	19 c0                	sbb    %eax,%eax
c0105a4d:	0c 01                	or     $0x1,%al
c0105a4f:	89 fa                	mov    %edi,%edx
c0105a51:	89 f1                	mov    %esi,%ecx
c0105a53:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105a56:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105a59:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105a5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105a5f:	83 c4 20             	add    $0x20,%esp
c0105a62:	5e                   	pop    %esi
c0105a63:	5f                   	pop    %edi
c0105a64:	5d                   	pop    %ebp
c0105a65:	c3                   	ret    

c0105a66 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105a66:	55                   	push   %ebp
c0105a67:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105a69:	eb 0c                	jmp    c0105a77 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105a6b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105a6f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105a73:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105a77:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105a7b:	74 1a                	je     c0105a97 <strncmp+0x31>
c0105a7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a80:	0f b6 00             	movzbl (%eax),%eax
c0105a83:	84 c0                	test   %al,%al
c0105a85:	74 10                	je     c0105a97 <strncmp+0x31>
c0105a87:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a8a:	0f b6 10             	movzbl (%eax),%edx
c0105a8d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a90:	0f b6 00             	movzbl (%eax),%eax
c0105a93:	38 c2                	cmp    %al,%dl
c0105a95:	74 d4                	je     c0105a6b <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105a97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105a9b:	74 18                	je     c0105ab5 <strncmp+0x4f>
c0105a9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aa0:	0f b6 00             	movzbl (%eax),%eax
c0105aa3:	0f b6 d0             	movzbl %al,%edx
c0105aa6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105aa9:	0f b6 00             	movzbl (%eax),%eax
c0105aac:	0f b6 c0             	movzbl %al,%eax
c0105aaf:	29 c2                	sub    %eax,%edx
c0105ab1:	89 d0                	mov    %edx,%eax
c0105ab3:	eb 05                	jmp    c0105aba <strncmp+0x54>
c0105ab5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105aba:	5d                   	pop    %ebp
c0105abb:	c3                   	ret    

c0105abc <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105abc:	55                   	push   %ebp
c0105abd:	89 e5                	mov    %esp,%ebp
c0105abf:	83 ec 04             	sub    $0x4,%esp
c0105ac2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ac5:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105ac8:	eb 14                	jmp    c0105ade <strchr+0x22>
        if (*s == c) {
c0105aca:	8b 45 08             	mov    0x8(%ebp),%eax
c0105acd:	0f b6 00             	movzbl (%eax),%eax
c0105ad0:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105ad3:	75 05                	jne    c0105ada <strchr+0x1e>
            return (char *)s;
c0105ad5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ad8:	eb 13                	jmp    c0105aed <strchr+0x31>
        }
        s ++;
c0105ada:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105ade:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ae1:	0f b6 00             	movzbl (%eax),%eax
c0105ae4:	84 c0                	test   %al,%al
c0105ae6:	75 e2                	jne    c0105aca <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105ae8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105aed:	c9                   	leave  
c0105aee:	c3                   	ret    

c0105aef <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105aef:	55                   	push   %ebp
c0105af0:	89 e5                	mov    %esp,%ebp
c0105af2:	83 ec 04             	sub    $0x4,%esp
c0105af5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105af8:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105afb:	eb 11                	jmp    c0105b0e <strfind+0x1f>
        if (*s == c) {
c0105afd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b00:	0f b6 00             	movzbl (%eax),%eax
c0105b03:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105b06:	75 02                	jne    c0105b0a <strfind+0x1b>
            break;
c0105b08:	eb 0e                	jmp    c0105b18 <strfind+0x29>
        }
        s ++;
c0105b0a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105b0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b11:	0f b6 00             	movzbl (%eax),%eax
c0105b14:	84 c0                	test   %al,%al
c0105b16:	75 e5                	jne    c0105afd <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0105b18:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105b1b:	c9                   	leave  
c0105b1c:	c3                   	ret    

c0105b1d <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105b1d:	55                   	push   %ebp
c0105b1e:	89 e5                	mov    %esp,%ebp
c0105b20:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105b23:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105b2a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105b31:	eb 04                	jmp    c0105b37 <strtol+0x1a>
        s ++;
c0105b33:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105b37:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b3a:	0f b6 00             	movzbl (%eax),%eax
c0105b3d:	3c 20                	cmp    $0x20,%al
c0105b3f:	74 f2                	je     c0105b33 <strtol+0x16>
c0105b41:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b44:	0f b6 00             	movzbl (%eax),%eax
c0105b47:	3c 09                	cmp    $0x9,%al
c0105b49:	74 e8                	je     c0105b33 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105b4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b4e:	0f b6 00             	movzbl (%eax),%eax
c0105b51:	3c 2b                	cmp    $0x2b,%al
c0105b53:	75 06                	jne    c0105b5b <strtol+0x3e>
        s ++;
c0105b55:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105b59:	eb 15                	jmp    c0105b70 <strtol+0x53>
    }
    else if (*s == '-') {
c0105b5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b5e:	0f b6 00             	movzbl (%eax),%eax
c0105b61:	3c 2d                	cmp    $0x2d,%al
c0105b63:	75 0b                	jne    c0105b70 <strtol+0x53>
        s ++, neg = 1;
c0105b65:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105b69:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105b70:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b74:	74 06                	je     c0105b7c <strtol+0x5f>
c0105b76:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105b7a:	75 24                	jne    c0105ba0 <strtol+0x83>
c0105b7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b7f:	0f b6 00             	movzbl (%eax),%eax
c0105b82:	3c 30                	cmp    $0x30,%al
c0105b84:	75 1a                	jne    c0105ba0 <strtol+0x83>
c0105b86:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b89:	83 c0 01             	add    $0x1,%eax
c0105b8c:	0f b6 00             	movzbl (%eax),%eax
c0105b8f:	3c 78                	cmp    $0x78,%al
c0105b91:	75 0d                	jne    c0105ba0 <strtol+0x83>
        s += 2, base = 16;
c0105b93:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105b97:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105b9e:	eb 2a                	jmp    c0105bca <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105ba0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105ba4:	75 17                	jne    c0105bbd <strtol+0xa0>
c0105ba6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ba9:	0f b6 00             	movzbl (%eax),%eax
c0105bac:	3c 30                	cmp    $0x30,%al
c0105bae:	75 0d                	jne    c0105bbd <strtol+0xa0>
        s ++, base = 8;
c0105bb0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105bb4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105bbb:	eb 0d                	jmp    c0105bca <strtol+0xad>
    }
    else if (base == 0) {
c0105bbd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105bc1:	75 07                	jne    c0105bca <strtol+0xad>
        base = 10;
c0105bc3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105bca:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bcd:	0f b6 00             	movzbl (%eax),%eax
c0105bd0:	3c 2f                	cmp    $0x2f,%al
c0105bd2:	7e 1b                	jle    c0105bef <strtol+0xd2>
c0105bd4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bd7:	0f b6 00             	movzbl (%eax),%eax
c0105bda:	3c 39                	cmp    $0x39,%al
c0105bdc:	7f 11                	jg     c0105bef <strtol+0xd2>
            dig = *s - '0';
c0105bde:	8b 45 08             	mov    0x8(%ebp),%eax
c0105be1:	0f b6 00             	movzbl (%eax),%eax
c0105be4:	0f be c0             	movsbl %al,%eax
c0105be7:	83 e8 30             	sub    $0x30,%eax
c0105bea:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105bed:	eb 48                	jmp    c0105c37 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105bef:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bf2:	0f b6 00             	movzbl (%eax),%eax
c0105bf5:	3c 60                	cmp    $0x60,%al
c0105bf7:	7e 1b                	jle    c0105c14 <strtol+0xf7>
c0105bf9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bfc:	0f b6 00             	movzbl (%eax),%eax
c0105bff:	3c 7a                	cmp    $0x7a,%al
c0105c01:	7f 11                	jg     c0105c14 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105c03:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c06:	0f b6 00             	movzbl (%eax),%eax
c0105c09:	0f be c0             	movsbl %al,%eax
c0105c0c:	83 e8 57             	sub    $0x57,%eax
c0105c0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105c12:	eb 23                	jmp    c0105c37 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105c14:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c17:	0f b6 00             	movzbl (%eax),%eax
c0105c1a:	3c 40                	cmp    $0x40,%al
c0105c1c:	7e 3d                	jle    c0105c5b <strtol+0x13e>
c0105c1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c21:	0f b6 00             	movzbl (%eax),%eax
c0105c24:	3c 5a                	cmp    $0x5a,%al
c0105c26:	7f 33                	jg     c0105c5b <strtol+0x13e>
            dig = *s - 'A' + 10;
c0105c28:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c2b:	0f b6 00             	movzbl (%eax),%eax
c0105c2e:	0f be c0             	movsbl %al,%eax
c0105c31:	83 e8 37             	sub    $0x37,%eax
c0105c34:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c3a:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105c3d:	7c 02                	jl     c0105c41 <strtol+0x124>
            break;
c0105c3f:	eb 1a                	jmp    c0105c5b <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0105c41:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105c45:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105c48:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105c4c:	89 c2                	mov    %eax,%edx
c0105c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c51:	01 d0                	add    %edx,%eax
c0105c53:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0105c56:	e9 6f ff ff ff       	jmp    c0105bca <strtol+0xad>

    if (endptr) {
c0105c5b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105c5f:	74 08                	je     c0105c69 <strtol+0x14c>
        *endptr = (char *) s;
c0105c61:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c64:	8b 55 08             	mov    0x8(%ebp),%edx
c0105c67:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105c69:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105c6d:	74 07                	je     c0105c76 <strtol+0x159>
c0105c6f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105c72:	f7 d8                	neg    %eax
c0105c74:	eb 03                	jmp    c0105c79 <strtol+0x15c>
c0105c76:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105c79:	c9                   	leave  
c0105c7a:	c3                   	ret    

c0105c7b <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105c7b:	55                   	push   %ebp
c0105c7c:	89 e5                	mov    %esp,%ebp
c0105c7e:	57                   	push   %edi
c0105c7f:	83 ec 24             	sub    $0x24,%esp
c0105c82:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c85:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105c88:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105c8c:	8b 55 08             	mov    0x8(%ebp),%edx
c0105c8f:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105c92:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105c95:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c98:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105c9b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105c9e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105ca2:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105ca5:	89 d7                	mov    %edx,%edi
c0105ca7:	f3 aa                	rep stos %al,%es:(%edi)
c0105ca9:	89 fa                	mov    %edi,%edx
c0105cab:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105cae:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105cb1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105cb4:	83 c4 24             	add    $0x24,%esp
c0105cb7:	5f                   	pop    %edi
c0105cb8:	5d                   	pop    %ebp
c0105cb9:	c3                   	ret    

c0105cba <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105cba:	55                   	push   %ebp
c0105cbb:	89 e5                	mov    %esp,%ebp
c0105cbd:	57                   	push   %edi
c0105cbe:	56                   	push   %esi
c0105cbf:	53                   	push   %ebx
c0105cc0:	83 ec 30             	sub    $0x30,%esp
c0105cc3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105cc9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ccc:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105ccf:	8b 45 10             	mov    0x10(%ebp),%eax
c0105cd2:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105cd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105cd8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105cdb:	73 42                	jae    c0105d1f <memmove+0x65>
c0105cdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ce0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105ce3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ce6:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105ce9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105cec:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105cef:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105cf2:	c1 e8 02             	shr    $0x2,%eax
c0105cf5:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105cf7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105cfa:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105cfd:	89 d7                	mov    %edx,%edi
c0105cff:	89 c6                	mov    %eax,%esi
c0105d01:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105d03:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105d06:	83 e1 03             	and    $0x3,%ecx
c0105d09:	74 02                	je     c0105d0d <memmove+0x53>
c0105d0b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105d0d:	89 f0                	mov    %esi,%eax
c0105d0f:	89 fa                	mov    %edi,%edx
c0105d11:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105d14:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105d17:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105d1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105d1d:	eb 36                	jmp    c0105d55 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105d1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105d22:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105d25:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d28:	01 c2                	add    %eax,%edx
c0105d2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105d2d:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105d30:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d33:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0105d36:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105d39:	89 c1                	mov    %eax,%ecx
c0105d3b:	89 d8                	mov    %ebx,%eax
c0105d3d:	89 d6                	mov    %edx,%esi
c0105d3f:	89 c7                	mov    %eax,%edi
c0105d41:	fd                   	std    
c0105d42:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105d44:	fc                   	cld    
c0105d45:	89 f8                	mov    %edi,%eax
c0105d47:	89 f2                	mov    %esi,%edx
c0105d49:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105d4c:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105d4f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0105d52:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105d55:	83 c4 30             	add    $0x30,%esp
c0105d58:	5b                   	pop    %ebx
c0105d59:	5e                   	pop    %esi
c0105d5a:	5f                   	pop    %edi
c0105d5b:	5d                   	pop    %ebp
c0105d5c:	c3                   	ret    

c0105d5d <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105d5d:	55                   	push   %ebp
c0105d5e:	89 e5                	mov    %esp,%ebp
c0105d60:	57                   	push   %edi
c0105d61:	56                   	push   %esi
c0105d62:	83 ec 20             	sub    $0x20,%esp
c0105d65:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d68:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d71:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d74:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105d77:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d7a:	c1 e8 02             	shr    $0x2,%eax
c0105d7d:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105d7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105d82:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d85:	89 d7                	mov    %edx,%edi
c0105d87:	89 c6                	mov    %eax,%esi
c0105d89:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105d8b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105d8e:	83 e1 03             	and    $0x3,%ecx
c0105d91:	74 02                	je     c0105d95 <memcpy+0x38>
c0105d93:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105d95:	89 f0                	mov    %esi,%eax
c0105d97:	89 fa                	mov    %edi,%edx
c0105d99:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105d9c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105d9f:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105da5:	83 c4 20             	add    $0x20,%esp
c0105da8:	5e                   	pop    %esi
c0105da9:	5f                   	pop    %edi
c0105daa:	5d                   	pop    %ebp
c0105dab:	c3                   	ret    

c0105dac <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105dac:	55                   	push   %ebp
c0105dad:	89 e5                	mov    %esp,%ebp
c0105daf:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105db2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105db5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105db8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105dbb:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105dbe:	eb 30                	jmp    c0105df0 <memcmp+0x44>
        if (*s1 != *s2) {
c0105dc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105dc3:	0f b6 10             	movzbl (%eax),%edx
c0105dc6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105dc9:	0f b6 00             	movzbl (%eax),%eax
c0105dcc:	38 c2                	cmp    %al,%dl
c0105dce:	74 18                	je     c0105de8 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105dd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105dd3:	0f b6 00             	movzbl (%eax),%eax
c0105dd6:	0f b6 d0             	movzbl %al,%edx
c0105dd9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105ddc:	0f b6 00             	movzbl (%eax),%eax
c0105ddf:	0f b6 c0             	movzbl %al,%eax
c0105de2:	29 c2                	sub    %eax,%edx
c0105de4:	89 d0                	mov    %edx,%eax
c0105de6:	eb 1a                	jmp    c0105e02 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0105de8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105dec:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0105df0:	8b 45 10             	mov    0x10(%ebp),%eax
c0105df3:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105df6:	89 55 10             	mov    %edx,0x10(%ebp)
c0105df9:	85 c0                	test   %eax,%eax
c0105dfb:	75 c3                	jne    c0105dc0 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0105dfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105e02:	c9                   	leave  
c0105e03:	c3                   	ret    
