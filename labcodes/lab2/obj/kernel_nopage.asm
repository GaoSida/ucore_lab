
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 70 11 40 	lgdtl  0x40117018
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 02 00 00 00       	call   10002a <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>

0010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002a:	55                   	push   %ebp
  10002b:	89 e5                	mov    %esp,%ebp
  10002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100030:	ba 68 89 11 00       	mov    $0x118968,%edx
  100035:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100049:	00 
  10004a:	c7 04 24 36 7a 11 00 	movl   $0x117a36,(%esp)
  100051:	e8 25 5c 00 00       	call   105c7b <memset>

    cons_init();                // init the console
  100056:	e8 82 15 00 00       	call   1015dd <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10005b:	c7 45 f4 20 5e 10 00 	movl   $0x105e20,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100065:	89 44 24 04          	mov    %eax,0x4(%esp)
  100069:	c7 04 24 3c 5e 10 00 	movl   $0x105e3c,(%esp)
  100070:	e8 c7 02 00 00       	call   10033c <cprintf>

    print_kerninfo();
  100075:	e8 f6 07 00 00       	call   100870 <print_kerninfo>

    grade_backtrace();
  10007a:	e8 86 00 00 00       	call   100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007f:	e8 a7 42 00 00       	call   10432b <pmm_init>

    pic_init();                 // init interrupt controller
  100084:	e8 bd 16 00 00       	call   101746 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100089:	e8 35 18 00 00       	call   1018c3 <idt_init>

    clock_init();               // init clock interrupt
  10008e:	e8 00 0d 00 00       	call   100d93 <clock_init>
    intr_enable();              // enable irq interrupt
  100093:	e8 1c 16 00 00       	call   1016b4 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  100098:	eb fe                	jmp    100098 <kern_init+0x6e>

0010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10009a:	55                   	push   %ebp
  10009b:	89 e5                	mov    %esp,%ebp
  10009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000a7:	00 
  1000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000af:	00 
  1000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000b7:	e8 09 0c 00 00       	call   100cc5 <mon_backtrace>
}
  1000bc:	c9                   	leave  
  1000bd:	c3                   	ret    

001000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000be:	55                   	push   %ebp
  1000bf:	89 e5                	mov    %esp,%ebp
  1000c1:	53                   	push   %ebx
  1000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000cb:	8d 55 08             	lea    0x8(%ebp),%edx
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000dd:	89 04 24             	mov    %eax,(%esp)
  1000e0:	e8 b5 ff ff ff       	call   10009a <grade_backtrace2>
}
  1000e5:	83 c4 14             	add    $0x14,%esp
  1000e8:	5b                   	pop    %ebx
  1000e9:	5d                   	pop    %ebp
  1000ea:	c3                   	ret    

001000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000eb:	55                   	push   %ebp
  1000ec:	89 e5                	mov    %esp,%ebp
  1000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1000fb:	89 04 24             	mov    %eax,(%esp)
  1000fe:	e8 bb ff ff ff       	call   1000be <grade_backtrace1>
}
  100103:	c9                   	leave  
  100104:	c3                   	ret    

00100105 <grade_backtrace>:

void
grade_backtrace(void) {
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10010b:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100117:	ff 
  100118:	89 44 24 04          	mov    %eax,0x4(%esp)
  10011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100123:	e8 c3 ff ff ff       	call   1000eb <grade_backtrace0>
}
  100128:	c9                   	leave  
  100129:	c3                   	ret    

0010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10012a:	55                   	push   %ebp
  10012b:	89 e5                	mov    %esp,%ebp
  10012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100140:	0f b7 c0             	movzwl %ax,%eax
  100143:	83 e0 03             	and    $0x3,%eax
  100146:	89 c2                	mov    %eax,%edx
  100148:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10014d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100151:	89 44 24 04          	mov    %eax,0x4(%esp)
  100155:	c7 04 24 41 5e 10 00 	movl   $0x105e41,(%esp)
  10015c:	e8 db 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100165:	0f b7 d0             	movzwl %ax,%edx
  100168:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10016d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100171:	89 44 24 04          	mov    %eax,0x4(%esp)
  100175:	c7 04 24 4f 5e 10 00 	movl   $0x105e4f,(%esp)
  10017c:	e8 bb 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100185:	0f b7 d0             	movzwl %ax,%edx
  100188:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10018d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100191:	89 44 24 04          	mov    %eax,0x4(%esp)
  100195:	c7 04 24 5d 5e 10 00 	movl   $0x105e5d,(%esp)
  10019c:	e8 9b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001a5:	0f b7 d0             	movzwl %ax,%edx
  1001a8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b5:	c7 04 24 6b 5e 10 00 	movl   $0x105e6b,(%esp)
  1001bc:	e8 7b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001c5:	0f b7 d0             	movzwl %ax,%edx
  1001c8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d5:	c7 04 24 79 5e 10 00 	movl   $0x105e79,(%esp)
  1001dc:	e8 5b 01 00 00       	call   10033c <cprintf>
    round ++;
  1001e1:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001e6:	83 c0 01             	add    $0x1,%eax
  1001e9:	a3 40 7a 11 00       	mov    %eax,0x117a40
}
  1001ee:	c9                   	leave  
  1001ef:	c3                   	ret    

001001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001f3:	5d                   	pop    %ebp
  1001f4:	c3                   	ret    

001001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001f5:	55                   	push   %ebp
  1001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001f8:	5d                   	pop    %ebp
  1001f9:	c3                   	ret    

001001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001fa:	55                   	push   %ebp
  1001fb:	89 e5                	mov    %esp,%ebp
  1001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100200:	e8 25 ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100205:	c7 04 24 88 5e 10 00 	movl   $0x105e88,(%esp)
  10020c:	e8 2b 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_user();
  100211:	e8 da ff ff ff       	call   1001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
  100216:	e8 0f ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10021b:	c7 04 24 a8 5e 10 00 	movl   $0x105ea8,(%esp)
  100222:	e8 15 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_kernel();
  100227:	e8 c9 ff ff ff       	call   1001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10022c:	e8 f9 fe ff ff       	call   10012a <lab1_print_cur_status>
}
  100231:	c9                   	leave  
  100232:	c3                   	ret    

00100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100233:	55                   	push   %ebp
  100234:	89 e5                	mov    %esp,%ebp
  100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10023d:	74 13                	je     100252 <readline+0x1f>
        cprintf("%s", prompt);
  10023f:	8b 45 08             	mov    0x8(%ebp),%eax
  100242:	89 44 24 04          	mov    %eax,0x4(%esp)
  100246:	c7 04 24 c7 5e 10 00 	movl   $0x105ec7,(%esp)
  10024d:	e8 ea 00 00 00       	call   10033c <cprintf>
    }
    int i = 0, c;
  100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100259:	e8 66 01 00 00       	call   1003c4 <getchar>
  10025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100265:	79 07                	jns    10026e <readline+0x3b>
            return NULL;
  100267:	b8 00 00 00 00       	mov    $0x0,%eax
  10026c:	eb 79                	jmp    1002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100272:	7e 28                	jle    10029c <readline+0x69>
  100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10027b:	7f 1f                	jg     10029c <readline+0x69>
            cputchar(c);
  10027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100280:	89 04 24             	mov    %eax,(%esp)
  100283:	e8 da 00 00 00       	call   100362 <cputchar>
            buf[i ++] = c;
  100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10028b:	8d 50 01             	lea    0x1(%eax),%edx
  10028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100294:	88 90 60 7a 11 00    	mov    %dl,0x117a60(%eax)
  10029a:	eb 46                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  10029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002a0:	75 17                	jne    1002b9 <readline+0x86>
  1002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002a6:	7e 11                	jle    1002b9 <readline+0x86>
            cputchar(c);
  1002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002ab:	89 04 24             	mov    %eax,(%esp)
  1002ae:	e8 af 00 00 00       	call   100362 <cputchar>
            i --;
  1002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1002b7:	eb 29                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  1002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002bd:	74 06                	je     1002c5 <readline+0x92>
  1002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002c3:	75 1d                	jne    1002e2 <readline+0xaf>
            cputchar(c);
  1002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002c8:	89 04 24             	mov    %eax,(%esp)
  1002cb:	e8 92 00 00 00       	call   100362 <cputchar>
            buf[i] = '\0';
  1002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002d3:	05 60 7a 11 00       	add    $0x117a60,%eax
  1002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002db:	b8 60 7a 11 00       	mov    $0x117a60,%eax
  1002e0:	eb 05                	jmp    1002e7 <readline+0xb4>
        }
    }
  1002e2:	e9 72 ff ff ff       	jmp    100259 <readline+0x26>
}
  1002e7:	c9                   	leave  
  1002e8:	c3                   	ret    

001002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002e9:	55                   	push   %ebp
  1002ea:	89 e5                	mov    %esp,%ebp
  1002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f2:	89 04 24             	mov    %eax,(%esp)
  1002f5:	e8 0f 13 00 00       	call   101609 <cons_putc>
    (*cnt) ++;
  1002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002fd:	8b 00                	mov    (%eax),%eax
  1002ff:	8d 50 01             	lea    0x1(%eax),%edx
  100302:	8b 45 0c             	mov    0xc(%ebp),%eax
  100305:	89 10                	mov    %edx,(%eax)
}
  100307:	c9                   	leave  
  100308:	c3                   	ret    

00100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100309:	55                   	push   %ebp
  10030a:	89 e5                	mov    %esp,%ebp
  10030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100316:	8b 45 0c             	mov    0xc(%ebp),%eax
  100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10031d:	8b 45 08             	mov    0x8(%ebp),%eax
  100320:	89 44 24 08          	mov    %eax,0x8(%esp)
  100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100327:	89 44 24 04          	mov    %eax,0x4(%esp)
  10032b:	c7 04 24 e9 02 10 00 	movl   $0x1002e9,(%esp)
  100332:	e8 5d 51 00 00       	call   105494 <vprintfmt>
    return cnt;
  100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10033a:	c9                   	leave  
  10033b:	c3                   	ret    

0010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10033c:	55                   	push   %ebp
  10033d:	89 e5                	mov    %esp,%ebp
  10033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100342:	8d 45 0c             	lea    0xc(%ebp),%eax
  100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10034b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10034f:	8b 45 08             	mov    0x8(%ebp),%eax
  100352:	89 04 24             	mov    %eax,(%esp)
  100355:	e8 af ff ff ff       	call   100309 <vcprintf>
  10035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100360:	c9                   	leave  
  100361:	c3                   	ret    

00100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100362:	55                   	push   %ebp
  100363:	89 e5                	mov    %esp,%ebp
  100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100368:	8b 45 08             	mov    0x8(%ebp),%eax
  10036b:	89 04 24             	mov    %eax,(%esp)
  10036e:	e8 96 12 00 00       	call   101609 <cons_putc>
}
  100373:	c9                   	leave  
  100374:	c3                   	ret    

00100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100375:	55                   	push   %ebp
  100376:	89 e5                	mov    %esp,%ebp
  100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100382:	eb 13                	jmp    100397 <cputs+0x22>
        cputch(c, &cnt);
  100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
  10038b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10038f:	89 04 24             	mov    %eax,(%esp)
  100392:	e8 52 ff ff ff       	call   1002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  100397:	8b 45 08             	mov    0x8(%ebp),%eax
  10039a:	8d 50 01             	lea    0x1(%eax),%edx
  10039d:	89 55 08             	mov    %edx,0x8(%ebp)
  1003a0:	0f b6 00             	movzbl (%eax),%eax
  1003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003aa:	75 d8                	jne    100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003ba:	e8 2a ff ff ff       	call   1002e9 <cputch>
    return cnt;
  1003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003c2:	c9                   	leave  
  1003c3:	c3                   	ret    

001003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003c4:	55                   	push   %ebp
  1003c5:	89 e5                	mov    %esp,%ebp
  1003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003ca:	e8 76 12 00 00       	call   101645 <cons_getc>
  1003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003d6:	74 f2                	je     1003ca <getchar+0x6>
        /* do nothing */;
    return c;
  1003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003db:	c9                   	leave  
  1003dc:	c3                   	ret    

001003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003dd:	55                   	push   %ebp
  1003de:	89 e5                	mov    %esp,%ebp
  1003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003e6:	8b 00                	mov    (%eax),%eax
  1003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1003ee:	8b 00                	mov    (%eax),%eax
  1003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003fa:	e9 d2 00 00 00       	jmp    1004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100405:	01 d0                	add    %edx,%eax
  100407:	89 c2                	mov    %eax,%edx
  100409:	c1 ea 1f             	shr    $0x1f,%edx
  10040c:	01 d0                	add    %edx,%eax
  10040e:	d1 f8                	sar    %eax
  100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100419:	eb 04                	jmp    10041f <stab_binsearch+0x42>
            m --;
  10041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100425:	7c 1f                	jl     100446 <stab_binsearch+0x69>
  100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10042a:	89 d0                	mov    %edx,%eax
  10042c:	01 c0                	add    %eax,%eax
  10042e:	01 d0                	add    %edx,%eax
  100430:	c1 e0 02             	shl    $0x2,%eax
  100433:	89 c2                	mov    %eax,%edx
  100435:	8b 45 08             	mov    0x8(%ebp),%eax
  100438:	01 d0                	add    %edx,%eax
  10043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10043e:	0f b6 c0             	movzbl %al,%eax
  100441:	3b 45 14             	cmp    0x14(%ebp),%eax
  100444:	75 d5                	jne    10041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10044c:	7d 0b                	jge    100459 <stab_binsearch+0x7c>
            l = true_m + 1;
  10044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100451:	83 c0 01             	add    $0x1,%eax
  100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100457:	eb 78                	jmp    1004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100463:	89 d0                	mov    %edx,%eax
  100465:	01 c0                	add    %eax,%eax
  100467:	01 d0                	add    %edx,%eax
  100469:	c1 e0 02             	shl    $0x2,%eax
  10046c:	89 c2                	mov    %eax,%edx
  10046e:	8b 45 08             	mov    0x8(%ebp),%eax
  100471:	01 d0                	add    %edx,%eax
  100473:	8b 40 08             	mov    0x8(%eax),%eax
  100476:	3b 45 18             	cmp    0x18(%ebp),%eax
  100479:	73 13                	jae    10048e <stab_binsearch+0xb1>
            *region_left = m;
  10047b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100486:	83 c0 01             	add    $0x1,%eax
  100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10048c:	eb 43                	jmp    1004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100491:	89 d0                	mov    %edx,%eax
  100493:	01 c0                	add    %eax,%eax
  100495:	01 d0                	add    %edx,%eax
  100497:	c1 e0 02             	shl    $0x2,%eax
  10049a:	89 c2                	mov    %eax,%edx
  10049c:	8b 45 08             	mov    0x8(%ebp),%eax
  10049f:	01 d0                	add    %edx,%eax
  1004a1:	8b 40 08             	mov    0x8(%eax),%eax
  1004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004a7:	76 16                	jbe    1004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
  1004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004af:	8b 45 10             	mov    0x10(%ebp),%eax
  1004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b7:	83 e8 01             	sub    $0x1,%eax
  1004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004bd:	eb 12                	jmp    1004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004c5:	89 10                	mov    %edx,(%eax)
            l = m;
  1004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004d7:	0f 8e 22 ff ff ff    	jle    1003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004e1:	75 0f                	jne    1004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e6:	8b 00                	mov    (%eax),%eax
  1004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1004ee:	89 10                	mov    %edx,(%eax)
  1004f0:	eb 3f                	jmp    100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004f2:	8b 45 10             	mov    0x10(%ebp),%eax
  1004f5:	8b 00                	mov    (%eax),%eax
  1004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004fa:	eb 04                	jmp    100500 <stab_binsearch+0x123>
  1004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100500:	8b 45 0c             	mov    0xc(%ebp),%eax
  100503:	8b 00                	mov    (%eax),%eax
  100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100508:	7d 1f                	jge    100529 <stab_binsearch+0x14c>
  10050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10050d:	89 d0                	mov    %edx,%eax
  10050f:	01 c0                	add    %eax,%eax
  100511:	01 d0                	add    %edx,%eax
  100513:	c1 e0 02             	shl    $0x2,%eax
  100516:	89 c2                	mov    %eax,%edx
  100518:	8b 45 08             	mov    0x8(%ebp),%eax
  10051b:	01 d0                	add    %edx,%eax
  10051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100521:	0f b6 c0             	movzbl %al,%eax
  100524:	3b 45 14             	cmp    0x14(%ebp),%eax
  100527:	75 d3                	jne    1004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  100529:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10052f:	89 10                	mov    %edx,(%eax)
    }
}
  100531:	c9                   	leave  
  100532:	c3                   	ret    

00100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100533:	55                   	push   %ebp
  100534:	89 e5                	mov    %esp,%ebp
  100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100539:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053c:	c7 00 cc 5e 10 00    	movl   $0x105ecc,(%eax)
    info->eip_line = 0;
  100542:	8b 45 0c             	mov    0xc(%ebp),%eax
  100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10054c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10054f:	c7 40 08 cc 5e 10 00 	movl   $0x105ecc,0x8(%eax)
    info->eip_fn_namelen = 9;
  100556:	8b 45 0c             	mov    0xc(%ebp),%eax
  100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100560:	8b 45 0c             	mov    0xc(%ebp),%eax
  100563:	8b 55 08             	mov    0x8(%ebp),%edx
  100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100569:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100573:	c7 45 f4 20 71 10 00 	movl   $0x107120,-0xc(%ebp)
    stab_end = __STAB_END__;
  10057a:	c7 45 f0 18 1b 11 00 	movl   $0x111b18,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100581:	c7 45 ec 19 1b 11 00 	movl   $0x111b19,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100588:	c7 45 e8 7b 45 11 00 	movl   $0x11457b,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100595:	76 0d                	jbe    1005a4 <debuginfo_eip+0x71>
  100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10059a:	83 e8 01             	sub    $0x1,%eax
  10059d:	0f b6 00             	movzbl (%eax),%eax
  1005a0:	84 c0                	test   %al,%al
  1005a2:	74 0a                	je     1005ae <debuginfo_eip+0x7b>
        return -1;
  1005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005a9:	e9 c0 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005bb:	29 c2                	sub    %eax,%edx
  1005bd:	89 d0                	mov    %edx,%eax
  1005bf:	c1 f8 02             	sar    $0x2,%eax
  1005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005c8:	83 e8 01             	sub    $0x1,%eax
  1005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005dc:	00 
  1005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005ee:	89 04 24             	mov    %eax,(%esp)
  1005f1:	e8 e7 fd ff ff       	call   1003dd <stab_binsearch>
    if (lfile == 0)
  1005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005f9:	85 c0                	test   %eax,%eax
  1005fb:	75 0a                	jne    100607 <debuginfo_eip+0xd4>
        return -1;
  1005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100602:	e9 67 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100613:	8b 45 08             	mov    0x8(%ebp),%eax
  100616:	89 44 24 10          	mov    %eax,0x10(%esp)
  10061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100621:	00 
  100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100625:	89 44 24 08          	mov    %eax,0x8(%esp)
  100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10062c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100633:	89 04 24             	mov    %eax,(%esp)
  100636:	e8 a2 fd ff ff       	call   1003dd <stab_binsearch>

    if (lfun <= rfun) {
  10063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100641:	39 c2                	cmp    %eax,%edx
  100643:	7f 7c                	jg     1006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100648:	89 c2                	mov    %eax,%edx
  10064a:	89 d0                	mov    %edx,%eax
  10064c:	01 c0                	add    %eax,%eax
  10064e:	01 d0                	add    %edx,%eax
  100650:	c1 e0 02             	shl    $0x2,%eax
  100653:	89 c2                	mov    %eax,%edx
  100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100658:	01 d0                	add    %edx,%eax
  10065a:	8b 10                	mov    (%eax),%edx
  10065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100662:	29 c1                	sub    %eax,%ecx
  100664:	89 c8                	mov    %ecx,%eax
  100666:	39 c2                	cmp    %eax,%edx
  100668:	73 22                	jae    10068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10066d:	89 c2                	mov    %eax,%edx
  10066f:	89 d0                	mov    %edx,%eax
  100671:	01 c0                	add    %eax,%eax
  100673:	01 d0                	add    %edx,%eax
  100675:	c1 e0 02             	shl    $0x2,%eax
  100678:	89 c2                	mov    %eax,%edx
  10067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10067d:	01 d0                	add    %edx,%eax
  10067f:	8b 10                	mov    (%eax),%edx
  100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100684:	01 c2                	add    %eax,%edx
  100686:	8b 45 0c             	mov    0xc(%ebp),%eax
  100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068f:	89 c2                	mov    %eax,%edx
  100691:	89 d0                	mov    %edx,%eax
  100693:	01 c0                	add    %eax,%eax
  100695:	01 d0                	add    %edx,%eax
  100697:	c1 e0 02             	shl    $0x2,%eax
  10069a:	89 c2                	mov    %eax,%edx
  10069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10069f:	01 d0                	add    %edx,%eax
  1006a1:	8b 50 08             	mov    0x8(%eax),%edx
  1006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ad:	8b 40 10             	mov    0x10(%eax),%eax
  1006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006bf:	eb 15                	jmp    1006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c4:	8b 55 08             	mov    0x8(%ebp),%edx
  1006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d9:	8b 40 08             	mov    0x8(%eax),%eax
  1006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006e3:	00 
  1006e4:	89 04 24             	mov    %eax,(%esp)
  1006e7:	e8 03 54 00 00       	call   105aef <strfind>
  1006ec:	89 c2                	mov    %eax,%edx
  1006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f1:	8b 40 08             	mov    0x8(%eax),%eax
  1006f4:	29 c2                	sub    %eax,%edx
  1006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
  100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  10070a:	00 
  10070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10070e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100715:	89 44 24 04          	mov    %eax,0x4(%esp)
  100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10071c:	89 04 24             	mov    %eax,(%esp)
  10071f:	e8 b9 fc ff ff       	call   1003dd <stab_binsearch>
    if (lline <= rline) {
  100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10072a:	39 c2                	cmp    %eax,%edx
  10072c:	7f 24                	jg     100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  10072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100731:	89 c2                	mov    %eax,%edx
  100733:	89 d0                	mov    %edx,%eax
  100735:	01 c0                	add    %eax,%eax
  100737:	01 d0                	add    %edx,%eax
  100739:	c1 e0 02             	shl    $0x2,%eax
  10073c:	89 c2                	mov    %eax,%edx
  10073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100741:	01 d0                	add    %edx,%eax
  100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100747:	0f b7 d0             	movzwl %ax,%edx
  10074a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100750:	eb 13                	jmp    100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100757:	e9 12 01 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10075f:	83 e8 01             	sub    $0x1,%eax
  100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10076b:	39 c2                	cmp    %eax,%edx
  10076d:	7c 56                	jl     1007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  10076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100772:	89 c2                	mov    %eax,%edx
  100774:	89 d0                	mov    %edx,%eax
  100776:	01 c0                	add    %eax,%eax
  100778:	01 d0                	add    %edx,%eax
  10077a:	c1 e0 02             	shl    $0x2,%eax
  10077d:	89 c2                	mov    %eax,%edx
  10077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100782:	01 d0                	add    %edx,%eax
  100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100788:	3c 84                	cmp    $0x84,%al
  10078a:	74 39                	je     1007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10078f:	89 c2                	mov    %eax,%edx
  100791:	89 d0                	mov    %edx,%eax
  100793:	01 c0                	add    %eax,%eax
  100795:	01 d0                	add    %edx,%eax
  100797:	c1 e0 02             	shl    $0x2,%eax
  10079a:	89 c2                	mov    %eax,%edx
  10079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10079f:	01 d0                	add    %edx,%eax
  1007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007a5:	3c 64                	cmp    $0x64,%al
  1007a7:	75 b3                	jne    10075c <debuginfo_eip+0x229>
  1007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007ac:	89 c2                	mov    %eax,%edx
  1007ae:	89 d0                	mov    %edx,%eax
  1007b0:	01 c0                	add    %eax,%eax
  1007b2:	01 d0                	add    %edx,%eax
  1007b4:	c1 e0 02             	shl    $0x2,%eax
  1007b7:	89 c2                	mov    %eax,%edx
  1007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007bc:	01 d0                	add    %edx,%eax
  1007be:	8b 40 08             	mov    0x8(%eax),%eax
  1007c1:	85 c0                	test   %eax,%eax
  1007c3:	74 97                	je     10075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007cb:	39 c2                	cmp    %eax,%edx
  1007cd:	7c 46                	jl     100815 <debuginfo_eip+0x2e2>
  1007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007d2:	89 c2                	mov    %eax,%edx
  1007d4:	89 d0                	mov    %edx,%eax
  1007d6:	01 c0                	add    %eax,%eax
  1007d8:	01 d0                	add    %edx,%eax
  1007da:	c1 e0 02             	shl    $0x2,%eax
  1007dd:	89 c2                	mov    %eax,%edx
  1007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e2:	01 d0                	add    %edx,%eax
  1007e4:	8b 10                	mov    (%eax),%edx
  1007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007ec:	29 c1                	sub    %eax,%ecx
  1007ee:	89 c8                	mov    %ecx,%eax
  1007f0:	39 c2                	cmp    %eax,%edx
  1007f2:	73 21                	jae    100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f7:	89 c2                	mov    %eax,%edx
  1007f9:	89 d0                	mov    %edx,%eax
  1007fb:	01 c0                	add    %eax,%eax
  1007fd:	01 d0                	add    %edx,%eax
  1007ff:	c1 e0 02             	shl    $0x2,%eax
  100802:	89 c2                	mov    %eax,%edx
  100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100807:	01 d0                	add    %edx,%eax
  100809:	8b 10                	mov    (%eax),%edx
  10080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10080e:	01 c2                	add    %eax,%edx
  100810:	8b 45 0c             	mov    0xc(%ebp),%eax
  100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10081b:	39 c2                	cmp    %eax,%edx
  10081d:	7d 4a                	jge    100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  10081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100822:	83 c0 01             	add    $0x1,%eax
  100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100828:	eb 18                	jmp    100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  10082a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10082d:	8b 40 14             	mov    0x14(%eax),%eax
  100830:	8d 50 01             	lea    0x1(%eax),%edx
  100833:	8b 45 0c             	mov    0xc(%ebp),%eax
  100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10083c:	83 c0 01             	add    $0x1,%eax
  10083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  100848:	39 c2                	cmp    %eax,%edx
  10084a:	7d 1d                	jge    100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10084f:	89 c2                	mov    %eax,%edx
  100851:	89 d0                	mov    %edx,%eax
  100853:	01 c0                	add    %eax,%eax
  100855:	01 d0                	add    %edx,%eax
  100857:	c1 e0 02             	shl    $0x2,%eax
  10085a:	89 c2                	mov    %eax,%edx
  10085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10085f:	01 d0                	add    %edx,%eax
  100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100865:	3c a0                	cmp    $0xa0,%al
  100867:	74 c1                	je     10082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10086e:	c9                   	leave  
  10086f:	c3                   	ret    

00100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100870:	55                   	push   %ebp
  100871:	89 e5                	mov    %esp,%ebp
  100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100876:	c7 04 24 d6 5e 10 00 	movl   $0x105ed6,(%esp)
  10087d:	e8 ba fa ff ff       	call   10033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100882:	c7 44 24 04 2a 00 10 	movl   $0x10002a,0x4(%esp)
  100889:	00 
  10088a:	c7 04 24 ef 5e 10 00 	movl   $0x105eef,(%esp)
  100891:	e8 a6 fa ff ff       	call   10033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100896:	c7 44 24 04 04 5e 10 	movl   $0x105e04,0x4(%esp)
  10089d:	00 
  10089e:	c7 04 24 07 5f 10 00 	movl   $0x105f07,(%esp)
  1008a5:	e8 92 fa ff ff       	call   10033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008aa:	c7 44 24 04 36 7a 11 	movl   $0x117a36,0x4(%esp)
  1008b1:	00 
  1008b2:	c7 04 24 1f 5f 10 00 	movl   $0x105f1f,(%esp)
  1008b9:	e8 7e fa ff ff       	call   10033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008be:	c7 44 24 04 68 89 11 	movl   $0x118968,0x4(%esp)
  1008c5:	00 
  1008c6:	c7 04 24 37 5f 10 00 	movl   $0x105f37,(%esp)
  1008cd:	e8 6a fa ff ff       	call   10033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008d2:	b8 68 89 11 00       	mov    $0x118968,%eax
  1008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008dd:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1008e2:	29 c2                	sub    %eax,%edx
  1008e4:	89 d0                	mov    %edx,%eax
  1008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008ec:	85 c0                	test   %eax,%eax
  1008ee:	0f 48 c2             	cmovs  %edx,%eax
  1008f1:	c1 f8 0a             	sar    $0xa,%eax
  1008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008f8:	c7 04 24 50 5f 10 00 	movl   $0x105f50,(%esp)
  1008ff:	e8 38 fa ff ff       	call   10033c <cprintf>
}
  100904:	c9                   	leave  
  100905:	c3                   	ret    

00100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100906:	55                   	push   %ebp
  100907:	89 e5                	mov    %esp,%ebp
  100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100912:	89 44 24 04          	mov    %eax,0x4(%esp)
  100916:	8b 45 08             	mov    0x8(%ebp),%eax
  100919:	89 04 24             	mov    %eax,(%esp)
  10091c:	e8 12 fc ff ff       	call   100533 <debuginfo_eip>
  100921:	85 c0                	test   %eax,%eax
  100923:	74 15                	je     10093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100925:	8b 45 08             	mov    0x8(%ebp),%eax
  100928:	89 44 24 04          	mov    %eax,0x4(%esp)
  10092c:	c7 04 24 7a 5f 10 00 	movl   $0x105f7a,(%esp)
  100933:	e8 04 fa ff ff       	call   10033c <cprintf>
  100938:	eb 6d                	jmp    1009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100941:	eb 1c                	jmp    10095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100949:	01 d0                	add    %edx,%eax
  10094b:	0f b6 00             	movzbl (%eax),%eax
  10094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100957:	01 ca                	add    %ecx,%edx
  100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100965:	7f dc                	jg     100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  10096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100970:	01 d0                	add    %edx,%eax
  100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100978:	8b 55 08             	mov    0x8(%ebp),%edx
  10097b:	89 d1                	mov    %edx,%ecx
  10097d:	29 c1                	sub    %eax,%ecx
  10097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100993:	89 54 24 08          	mov    %edx,0x8(%esp)
  100997:	89 44 24 04          	mov    %eax,0x4(%esp)
  10099b:	c7 04 24 96 5f 10 00 	movl   $0x105f96,(%esp)
  1009a2:	e8 95 f9 ff ff       	call   10033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  1009a7:	c9                   	leave  
  1009a8:	c3                   	ret    

001009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009a9:	55                   	push   %ebp
  1009aa:	89 e5                	mov    %esp,%ebp
  1009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009af:	8b 45 04             	mov    0x4(%ebp),%eax
  1009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009b8:	c9                   	leave  
  1009b9:	c3                   	ret    

001009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009ba:	55                   	push   %ebp
  1009bb:	89 e5                	mov    %esp,%ebp
  1009bd:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009c0:	89 e8                	mov    %ebp,%eax
  1009c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  1009c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	// My Code Starts
	uint32_t current_ebp = read_ebp();
  1009c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t current_eip = read_eip();
  1009cb:	e8 d9 ff ff ff       	call   1009a9 <read_eip>
  1009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	
	int i;    //  ‘for’ loop initial declarations are not allowed here
	for (i = 0; i < STACKFRAME_DEPTH; i++) {
  1009d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009da:	e9 9f 00 00 00       	jmp    100a7e <print_stackframe+0xc4>
		if (current_ebp == 0) {
  1009df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1009e3:	75 05                	jne    1009ea <print_stackframe+0x30>
			break;
  1009e5:	e9 9e 00 00 00       	jmp    100a88 <print_stackframe+0xce>
		}

		cprintf("ebp:0x%08x eip:0x%08x ", current_ebp, current_eip);
  1009ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009ed:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009f8:	c7 04 24 a8 5f 10 00 	movl   $0x105fa8,(%esp)
  1009ff:	e8 38 f9 ff ff       	call   10033c <cprintf>
		// Cannot use printf, since we're writing a kernel, not an app!
	    
		cprintf("args:");
  100a04:	c7 04 24 bf 5f 10 00 	movl   $0x105fbf,(%esp)
  100a0b:	e8 2c f9 ff ff       	call   10033c <cprintf>
		uint32_t *argbase = (uint32_t*)current_ebp + 2;       
  100a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a13:	83 c0 08             	add    $0x8,%eax
  100a16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// the first argument is 2 words away, return_address standing in between
		int j;
		for (j = 0; j < 4; j++) {
  100a19:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a20:	eb 25                	jmp    100a47 <print_stackframe+0x8d>
			cprintf("0x%08x ", argbase[j]);
  100a22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a25:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a2f:	01 d0                	add    %edx,%eax
  100a31:	8b 00                	mov    (%eax),%eax
  100a33:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a37:	c7 04 24 c5 5f 10 00 	movl   $0x105fc5,(%esp)
  100a3e:	e8 f9 f8 ff ff       	call   10033c <cprintf>
	    
		cprintf("args:");
		uint32_t *argbase = (uint32_t*)current_ebp + 2;       
		// the first argument is 2 words away, return_address standing in between
		int j;
		for (j = 0; j < 4; j++) {
  100a43:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a47:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a4b:	7e d5                	jle    100a22 <print_stackframe+0x68>
			cprintf("0x%08x ", argbase[j]);
		}
		cprintf("\n");
  100a4d:	c7 04 24 cd 5f 10 00 	movl   $0x105fcd,(%esp)
  100a54:	e8 e3 f8 ff ff       	call   10033c <cprintf>
		print_debuginfo(current_eip - 1);     // eip points to next instruction
  100a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a5c:	83 e8 01             	sub    $0x1,%eax
  100a5f:	89 04 24             	mov    %eax,(%esp)
  100a62:	e8 9f fe ff ff       	call   100906 <print_debuginfo>
		
		// moving to next frame on the stack
		current_eip = *((uint32_t*)current_ebp + 1);    // return address
  100a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a6a:	83 c0 04             	add    $0x4,%eax
  100a6d:	8b 00                	mov    (%eax),%eax
  100a6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		current_ebp = *((uint32_t*)current_ebp);      // ebp of last frame
  100a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a75:	8b 00                	mov    (%eax),%eax
  100a77:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// My Code Starts
	uint32_t current_ebp = read_ebp();
	uint32_t current_eip = read_eip();
	
	int i;    //  ‘for’ loop initial declarations are not allowed here
	for (i = 0; i < STACKFRAME_DEPTH; i++) {
  100a7a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a7e:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a82:	0f 8e 57 ff ff ff    	jle    1009df <print_stackframe+0x25>
		// moving to next frame on the stack
		current_eip = *((uint32_t*)current_ebp + 1);    // return address
		current_ebp = *((uint32_t*)current_ebp);      // ebp of last frame
	}
	// My Code Ends
}
  100a88:	c9                   	leave  
  100a89:	c3                   	ret    

00100a8a <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a8a:	55                   	push   %ebp
  100a8b:	89 e5                	mov    %esp,%ebp
  100a8d:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a97:	eb 0c                	jmp    100aa5 <parse+0x1b>
            *buf ++ = '\0';
  100a99:	8b 45 08             	mov    0x8(%ebp),%eax
  100a9c:	8d 50 01             	lea    0x1(%eax),%edx
  100a9f:	89 55 08             	mov    %edx,0x8(%ebp)
  100aa2:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa8:	0f b6 00             	movzbl (%eax),%eax
  100aab:	84 c0                	test   %al,%al
  100aad:	74 1d                	je     100acc <parse+0x42>
  100aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  100ab2:	0f b6 00             	movzbl (%eax),%eax
  100ab5:	0f be c0             	movsbl %al,%eax
  100ab8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100abc:	c7 04 24 50 60 10 00 	movl   $0x106050,(%esp)
  100ac3:	e8 f4 4f 00 00       	call   105abc <strchr>
  100ac8:	85 c0                	test   %eax,%eax
  100aca:	75 cd                	jne    100a99 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100acc:	8b 45 08             	mov    0x8(%ebp),%eax
  100acf:	0f b6 00             	movzbl (%eax),%eax
  100ad2:	84 c0                	test   %al,%al
  100ad4:	75 02                	jne    100ad8 <parse+0x4e>
            break;
  100ad6:	eb 67                	jmp    100b3f <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100ad8:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100adc:	75 14                	jne    100af2 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ade:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ae5:	00 
  100ae6:	c7 04 24 55 60 10 00 	movl   $0x106055,(%esp)
  100aed:	e8 4a f8 ff ff       	call   10033c <cprintf>
        }
        argv[argc ++] = buf;
  100af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100af5:	8d 50 01             	lea    0x1(%eax),%edx
  100af8:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100afb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b02:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b05:	01 c2                	add    %eax,%edx
  100b07:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0a:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b0c:	eb 04                	jmp    100b12 <parse+0x88>
            buf ++;
  100b0e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b12:	8b 45 08             	mov    0x8(%ebp),%eax
  100b15:	0f b6 00             	movzbl (%eax),%eax
  100b18:	84 c0                	test   %al,%al
  100b1a:	74 1d                	je     100b39 <parse+0xaf>
  100b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  100b1f:	0f b6 00             	movzbl (%eax),%eax
  100b22:	0f be c0             	movsbl %al,%eax
  100b25:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b29:	c7 04 24 50 60 10 00 	movl   $0x106050,(%esp)
  100b30:	e8 87 4f 00 00       	call   105abc <strchr>
  100b35:	85 c0                	test   %eax,%eax
  100b37:	74 d5                	je     100b0e <parse+0x84>
            buf ++;
        }
    }
  100b39:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b3a:	e9 66 ff ff ff       	jmp    100aa5 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b42:	c9                   	leave  
  100b43:	c3                   	ret    

00100b44 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b44:	55                   	push   %ebp
  100b45:	89 e5                	mov    %esp,%ebp
  100b47:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b4a:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b51:	8b 45 08             	mov    0x8(%ebp),%eax
  100b54:	89 04 24             	mov    %eax,(%esp)
  100b57:	e8 2e ff ff ff       	call   100a8a <parse>
  100b5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b5f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b63:	75 0a                	jne    100b6f <runcmd+0x2b>
        return 0;
  100b65:	b8 00 00 00 00       	mov    $0x0,%eax
  100b6a:	e9 85 00 00 00       	jmp    100bf4 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b6f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b76:	eb 5c                	jmp    100bd4 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b78:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b7e:	89 d0                	mov    %edx,%eax
  100b80:	01 c0                	add    %eax,%eax
  100b82:	01 d0                	add    %edx,%eax
  100b84:	c1 e0 02             	shl    $0x2,%eax
  100b87:	05 20 70 11 00       	add    $0x117020,%eax
  100b8c:	8b 00                	mov    (%eax),%eax
  100b8e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b92:	89 04 24             	mov    %eax,(%esp)
  100b95:	e8 83 4e 00 00       	call   105a1d <strcmp>
  100b9a:	85 c0                	test   %eax,%eax
  100b9c:	75 32                	jne    100bd0 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100ba1:	89 d0                	mov    %edx,%eax
  100ba3:	01 c0                	add    %eax,%eax
  100ba5:	01 d0                	add    %edx,%eax
  100ba7:	c1 e0 02             	shl    $0x2,%eax
  100baa:	05 20 70 11 00       	add    $0x117020,%eax
  100baf:	8b 40 08             	mov    0x8(%eax),%eax
  100bb2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100bb5:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100bb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  100bbb:	89 54 24 08          	mov    %edx,0x8(%esp)
  100bbf:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100bc2:	83 c2 04             	add    $0x4,%edx
  100bc5:	89 54 24 04          	mov    %edx,0x4(%esp)
  100bc9:	89 0c 24             	mov    %ecx,(%esp)
  100bcc:	ff d0                	call   *%eax
  100bce:	eb 24                	jmp    100bf4 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bd0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bd7:	83 f8 02             	cmp    $0x2,%eax
  100bda:	76 9c                	jbe    100b78 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bdc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bdf:	89 44 24 04          	mov    %eax,0x4(%esp)
  100be3:	c7 04 24 73 60 10 00 	movl   $0x106073,(%esp)
  100bea:	e8 4d f7 ff ff       	call   10033c <cprintf>
    return 0;
  100bef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bf4:	c9                   	leave  
  100bf5:	c3                   	ret    

00100bf6 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bf6:	55                   	push   %ebp
  100bf7:	89 e5                	mov    %esp,%ebp
  100bf9:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bfc:	c7 04 24 8c 60 10 00 	movl   $0x10608c,(%esp)
  100c03:	e8 34 f7 ff ff       	call   10033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100c08:	c7 04 24 b4 60 10 00 	movl   $0x1060b4,(%esp)
  100c0f:	e8 28 f7 ff ff       	call   10033c <cprintf>

    if (tf != NULL) {
  100c14:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c18:	74 0b                	je     100c25 <kmonitor+0x2f>
        print_trapframe(tf);
  100c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  100c1d:	89 04 24             	mov    %eax,(%esp)
  100c20:	e8 52 0e 00 00       	call   101a77 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c25:	c7 04 24 d9 60 10 00 	movl   $0x1060d9,(%esp)
  100c2c:	e8 02 f6 ff ff       	call   100233 <readline>
  100c31:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c38:	74 18                	je     100c52 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  100c3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c44:	89 04 24             	mov    %eax,(%esp)
  100c47:	e8 f8 fe ff ff       	call   100b44 <runcmd>
  100c4c:	85 c0                	test   %eax,%eax
  100c4e:	79 02                	jns    100c52 <kmonitor+0x5c>
                break;
  100c50:	eb 02                	jmp    100c54 <kmonitor+0x5e>
            }
        }
    }
  100c52:	eb d1                	jmp    100c25 <kmonitor+0x2f>
}
  100c54:	c9                   	leave  
  100c55:	c3                   	ret    

00100c56 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c56:	55                   	push   %ebp
  100c57:	89 e5                	mov    %esp,%ebp
  100c59:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c5c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c63:	eb 3f                	jmp    100ca4 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c68:	89 d0                	mov    %edx,%eax
  100c6a:	01 c0                	add    %eax,%eax
  100c6c:	01 d0                	add    %edx,%eax
  100c6e:	c1 e0 02             	shl    $0x2,%eax
  100c71:	05 20 70 11 00       	add    $0x117020,%eax
  100c76:	8b 48 04             	mov    0x4(%eax),%ecx
  100c79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c7c:	89 d0                	mov    %edx,%eax
  100c7e:	01 c0                	add    %eax,%eax
  100c80:	01 d0                	add    %edx,%eax
  100c82:	c1 e0 02             	shl    $0x2,%eax
  100c85:	05 20 70 11 00       	add    $0x117020,%eax
  100c8a:	8b 00                	mov    (%eax),%eax
  100c8c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c90:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c94:	c7 04 24 dd 60 10 00 	movl   $0x1060dd,(%esp)
  100c9b:	e8 9c f6 ff ff       	call   10033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100ca0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ca7:	83 f8 02             	cmp    $0x2,%eax
  100caa:	76 b9                	jbe    100c65 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100cac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cb1:	c9                   	leave  
  100cb2:	c3                   	ret    

00100cb3 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100cb3:	55                   	push   %ebp
  100cb4:	89 e5                	mov    %esp,%ebp
  100cb6:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100cb9:	e8 b2 fb ff ff       	call   100870 <print_kerninfo>
    return 0;
  100cbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cc3:	c9                   	leave  
  100cc4:	c3                   	ret    

00100cc5 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cc5:	55                   	push   %ebp
  100cc6:	89 e5                	mov    %esp,%ebp
  100cc8:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100ccb:	e8 ea fc ff ff       	call   1009ba <print_stackframe>
    return 0;
  100cd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cd5:	c9                   	leave  
  100cd6:	c3                   	ret    

00100cd7 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100cd7:	55                   	push   %ebp
  100cd8:	89 e5                	mov    %esp,%ebp
  100cda:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cdd:	a1 60 7e 11 00       	mov    0x117e60,%eax
  100ce2:	85 c0                	test   %eax,%eax
  100ce4:	74 02                	je     100ce8 <__panic+0x11>
        goto panic_dead;
  100ce6:	eb 48                	jmp    100d30 <__panic+0x59>
    }
    is_panic = 1;
  100ce8:	c7 05 60 7e 11 00 01 	movl   $0x1,0x117e60
  100cef:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cf2:	8d 45 14             	lea    0x14(%ebp),%eax
  100cf5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cfb:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cff:	8b 45 08             	mov    0x8(%ebp),%eax
  100d02:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d06:	c7 04 24 e6 60 10 00 	movl   $0x1060e6,(%esp)
  100d0d:	e8 2a f6 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d15:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d19:	8b 45 10             	mov    0x10(%ebp),%eax
  100d1c:	89 04 24             	mov    %eax,(%esp)
  100d1f:	e8 e5 f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d24:	c7 04 24 02 61 10 00 	movl   $0x106102,(%esp)
  100d2b:	e8 0c f6 ff ff       	call   10033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100d30:	e8 85 09 00 00       	call   1016ba <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d35:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d3c:	e8 b5 fe ff ff       	call   100bf6 <kmonitor>
    }
  100d41:	eb f2                	jmp    100d35 <__panic+0x5e>

00100d43 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d43:	55                   	push   %ebp
  100d44:	89 e5                	mov    %esp,%ebp
  100d46:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d49:	8d 45 14             	lea    0x14(%ebp),%eax
  100d4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d52:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d56:	8b 45 08             	mov    0x8(%ebp),%eax
  100d59:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d5d:	c7 04 24 04 61 10 00 	movl   $0x106104,(%esp)
  100d64:	e8 d3 f5 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d70:	8b 45 10             	mov    0x10(%ebp),%eax
  100d73:	89 04 24             	mov    %eax,(%esp)
  100d76:	e8 8e f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d7b:	c7 04 24 02 61 10 00 	movl   $0x106102,(%esp)
  100d82:	e8 b5 f5 ff ff       	call   10033c <cprintf>
    va_end(ap);
}
  100d87:	c9                   	leave  
  100d88:	c3                   	ret    

00100d89 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d89:	55                   	push   %ebp
  100d8a:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d8c:	a1 60 7e 11 00       	mov    0x117e60,%eax
}
  100d91:	5d                   	pop    %ebp
  100d92:	c3                   	ret    

00100d93 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d93:	55                   	push   %ebp
  100d94:	89 e5                	mov    %esp,%ebp
  100d96:	83 ec 28             	sub    $0x28,%esp
  100d99:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d9f:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100da3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100da7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100dab:	ee                   	out    %al,(%dx)
  100dac:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100db2:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100db6:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100dba:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dbe:	ee                   	out    %al,(%dx)
  100dbf:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100dc5:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100dc9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dcd:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dd1:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dd2:	c7 05 4c 89 11 00 00 	movl   $0x0,0x11894c
  100dd9:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100ddc:	c7 04 24 22 61 10 00 	movl   $0x106122,(%esp)
  100de3:	e8 54 f5 ff ff       	call   10033c <cprintf>
    pic_enable(IRQ_TIMER);
  100de8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100def:	e8 24 09 00 00       	call   101718 <pic_enable>
}
  100df4:	c9                   	leave  
  100df5:	c3                   	ret    

00100df6 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100df6:	55                   	push   %ebp
  100df7:	89 e5                	mov    %esp,%ebp
  100df9:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100dfc:	9c                   	pushf  
  100dfd:	58                   	pop    %eax
  100dfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100e04:	25 00 02 00 00       	and    $0x200,%eax
  100e09:	85 c0                	test   %eax,%eax
  100e0b:	74 0c                	je     100e19 <__intr_save+0x23>
        intr_disable();
  100e0d:	e8 a8 08 00 00       	call   1016ba <intr_disable>
        return 1;
  100e12:	b8 01 00 00 00       	mov    $0x1,%eax
  100e17:	eb 05                	jmp    100e1e <__intr_save+0x28>
    }
    return 0;
  100e19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e1e:	c9                   	leave  
  100e1f:	c3                   	ret    

00100e20 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e20:	55                   	push   %ebp
  100e21:	89 e5                	mov    %esp,%ebp
  100e23:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e26:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e2a:	74 05                	je     100e31 <__intr_restore+0x11>
        intr_enable();
  100e2c:	e8 83 08 00 00       	call   1016b4 <intr_enable>
    }
}
  100e31:	c9                   	leave  
  100e32:	c3                   	ret    

00100e33 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e33:	55                   	push   %ebp
  100e34:	89 e5                	mov    %esp,%ebp
  100e36:	83 ec 10             	sub    $0x10,%esp
  100e39:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e3f:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e43:	89 c2                	mov    %eax,%edx
  100e45:	ec                   	in     (%dx),%al
  100e46:	88 45 fd             	mov    %al,-0x3(%ebp)
  100e49:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e4f:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e53:	89 c2                	mov    %eax,%edx
  100e55:	ec                   	in     (%dx),%al
  100e56:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e59:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e5f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e63:	89 c2                	mov    %eax,%edx
  100e65:	ec                   	in     (%dx),%al
  100e66:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e69:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e6f:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e73:	89 c2                	mov    %eax,%edx
  100e75:	ec                   	in     (%dx),%al
  100e76:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e79:	c9                   	leave  
  100e7a:	c3                   	ret    

00100e7b <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e7b:	55                   	push   %ebp
  100e7c:	89 e5                	mov    %esp,%ebp
  100e7e:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e81:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e8b:	0f b7 00             	movzwl (%eax),%eax
  100e8e:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e95:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e9d:	0f b7 00             	movzwl (%eax),%eax
  100ea0:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100ea4:	74 12                	je     100eb8 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100ea6:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100ead:	66 c7 05 86 7e 11 00 	movw   $0x3b4,0x117e86
  100eb4:	b4 03 
  100eb6:	eb 13                	jmp    100ecb <cga_init+0x50>
    } else {
        *cp = was;
  100eb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ebb:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100ebf:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100ec2:	66 c7 05 86 7e 11 00 	movw   $0x3d4,0x117e86
  100ec9:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100ecb:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ed2:	0f b7 c0             	movzwl %ax,%eax
  100ed5:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100ed9:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100edd:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ee1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100ee5:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100ee6:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100eed:	83 c0 01             	add    $0x1,%eax
  100ef0:	0f b7 c0             	movzwl %ax,%eax
  100ef3:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ef7:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100efb:	89 c2                	mov    %eax,%edx
  100efd:	ec                   	in     (%dx),%al
  100efe:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100f01:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f05:	0f b6 c0             	movzbl %al,%eax
  100f08:	c1 e0 08             	shl    $0x8,%eax
  100f0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f0e:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f15:	0f b7 c0             	movzwl %ax,%eax
  100f18:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100f1c:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f20:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f24:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f28:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f29:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f30:	83 c0 01             	add    $0x1,%eax
  100f33:	0f b7 c0             	movzwl %ax,%eax
  100f36:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f3a:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f3e:	89 c2                	mov    %eax,%edx
  100f40:	ec                   	in     (%dx),%al
  100f41:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100f44:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f48:	0f b6 c0             	movzbl %al,%eax
  100f4b:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f51:	a3 80 7e 11 00       	mov    %eax,0x117e80
    crt_pos = pos;
  100f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f59:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
}
  100f5f:	c9                   	leave  
  100f60:	c3                   	ret    

00100f61 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f61:	55                   	push   %ebp
  100f62:	89 e5                	mov    %esp,%ebp
  100f64:	83 ec 48             	sub    $0x48,%esp
  100f67:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f6d:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f71:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f75:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f79:	ee                   	out    %al,(%dx)
  100f7a:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f80:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f84:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f88:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f8c:	ee                   	out    %al,(%dx)
  100f8d:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f93:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f97:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f9b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f9f:	ee                   	out    %al,(%dx)
  100fa0:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fa6:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100faa:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100fae:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fb2:	ee                   	out    %al,(%dx)
  100fb3:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100fb9:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100fbd:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fc1:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fc5:	ee                   	out    %al,(%dx)
  100fc6:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100fcc:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100fd0:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fd4:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fd8:	ee                   	out    %al,(%dx)
  100fd9:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fdf:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100fe3:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fe7:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100feb:	ee                   	out    %al,(%dx)
  100fec:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ff2:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100ff6:	89 c2                	mov    %eax,%edx
  100ff8:	ec                   	in     (%dx),%al
  100ff9:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100ffc:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  101000:	3c ff                	cmp    $0xff,%al
  101002:	0f 95 c0             	setne  %al
  101005:	0f b6 c0             	movzbl %al,%eax
  101008:	a3 88 7e 11 00       	mov    %eax,0x117e88
  10100d:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101013:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  101017:	89 c2                	mov    %eax,%edx
  101019:	ec                   	in     (%dx),%al
  10101a:	88 45 d5             	mov    %al,-0x2b(%ebp)
  10101d:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  101023:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  101027:	89 c2                	mov    %eax,%edx
  101029:	ec                   	in     (%dx),%al
  10102a:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  10102d:	a1 88 7e 11 00       	mov    0x117e88,%eax
  101032:	85 c0                	test   %eax,%eax
  101034:	74 0c                	je     101042 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  101036:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10103d:	e8 d6 06 00 00       	call   101718 <pic_enable>
    }
}
  101042:	c9                   	leave  
  101043:	c3                   	ret    

00101044 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101044:	55                   	push   %ebp
  101045:	89 e5                	mov    %esp,%ebp
  101047:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10104a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101051:	eb 09                	jmp    10105c <lpt_putc_sub+0x18>
        delay();
  101053:	e8 db fd ff ff       	call   100e33 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101058:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10105c:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101062:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101066:	89 c2                	mov    %eax,%edx
  101068:	ec                   	in     (%dx),%al
  101069:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10106c:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101070:	84 c0                	test   %al,%al
  101072:	78 09                	js     10107d <lpt_putc_sub+0x39>
  101074:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10107b:	7e d6                	jle    101053 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  10107d:	8b 45 08             	mov    0x8(%ebp),%eax
  101080:	0f b6 c0             	movzbl %al,%eax
  101083:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101089:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10108c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101090:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101094:	ee                   	out    %al,(%dx)
  101095:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  10109b:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  10109f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010a3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010a7:	ee                   	out    %al,(%dx)
  1010a8:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  1010ae:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  1010b2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010b6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010ba:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010bb:	c9                   	leave  
  1010bc:	c3                   	ret    

001010bd <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010bd:	55                   	push   %ebp
  1010be:	89 e5                	mov    %esp,%ebp
  1010c0:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010c3:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010c7:	74 0d                	je     1010d6 <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1010cc:	89 04 24             	mov    %eax,(%esp)
  1010cf:	e8 70 ff ff ff       	call   101044 <lpt_putc_sub>
  1010d4:	eb 24                	jmp    1010fa <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  1010d6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010dd:	e8 62 ff ff ff       	call   101044 <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010e2:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010e9:	e8 56 ff ff ff       	call   101044 <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010ee:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010f5:	e8 4a ff ff ff       	call   101044 <lpt_putc_sub>
    }
}
  1010fa:	c9                   	leave  
  1010fb:	c3                   	ret    

001010fc <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010fc:	55                   	push   %ebp
  1010fd:	89 e5                	mov    %esp,%ebp
  1010ff:	53                   	push   %ebx
  101100:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101103:	8b 45 08             	mov    0x8(%ebp),%eax
  101106:	b0 00                	mov    $0x0,%al
  101108:	85 c0                	test   %eax,%eax
  10110a:	75 07                	jne    101113 <cga_putc+0x17>
        c |= 0x0700;
  10110c:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101113:	8b 45 08             	mov    0x8(%ebp),%eax
  101116:	0f b6 c0             	movzbl %al,%eax
  101119:	83 f8 0a             	cmp    $0xa,%eax
  10111c:	74 4c                	je     10116a <cga_putc+0x6e>
  10111e:	83 f8 0d             	cmp    $0xd,%eax
  101121:	74 57                	je     10117a <cga_putc+0x7e>
  101123:	83 f8 08             	cmp    $0x8,%eax
  101126:	0f 85 88 00 00 00    	jne    1011b4 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  10112c:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101133:	66 85 c0             	test   %ax,%ax
  101136:	74 30                	je     101168 <cga_putc+0x6c>
            crt_pos --;
  101138:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10113f:	83 e8 01             	sub    $0x1,%eax
  101142:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101148:	a1 80 7e 11 00       	mov    0x117e80,%eax
  10114d:	0f b7 15 84 7e 11 00 	movzwl 0x117e84,%edx
  101154:	0f b7 d2             	movzwl %dx,%edx
  101157:	01 d2                	add    %edx,%edx
  101159:	01 c2                	add    %eax,%edx
  10115b:	8b 45 08             	mov    0x8(%ebp),%eax
  10115e:	b0 00                	mov    $0x0,%al
  101160:	83 c8 20             	or     $0x20,%eax
  101163:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101166:	eb 72                	jmp    1011da <cga_putc+0xde>
  101168:	eb 70                	jmp    1011da <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  10116a:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101171:	83 c0 50             	add    $0x50,%eax
  101174:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  10117a:	0f b7 1d 84 7e 11 00 	movzwl 0x117e84,%ebx
  101181:	0f b7 0d 84 7e 11 00 	movzwl 0x117e84,%ecx
  101188:	0f b7 c1             	movzwl %cx,%eax
  10118b:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101191:	c1 e8 10             	shr    $0x10,%eax
  101194:	89 c2                	mov    %eax,%edx
  101196:	66 c1 ea 06          	shr    $0x6,%dx
  10119a:	89 d0                	mov    %edx,%eax
  10119c:	c1 e0 02             	shl    $0x2,%eax
  10119f:	01 d0                	add    %edx,%eax
  1011a1:	c1 e0 04             	shl    $0x4,%eax
  1011a4:	29 c1                	sub    %eax,%ecx
  1011a6:	89 ca                	mov    %ecx,%edx
  1011a8:	89 d8                	mov    %ebx,%eax
  1011aa:	29 d0                	sub    %edx,%eax
  1011ac:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
        break;
  1011b2:	eb 26                	jmp    1011da <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011b4:	8b 0d 80 7e 11 00    	mov    0x117e80,%ecx
  1011ba:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011c1:	8d 50 01             	lea    0x1(%eax),%edx
  1011c4:	66 89 15 84 7e 11 00 	mov    %dx,0x117e84
  1011cb:	0f b7 c0             	movzwl %ax,%eax
  1011ce:	01 c0                	add    %eax,%eax
  1011d0:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1011d6:	66 89 02             	mov    %ax,(%edx)
        break;
  1011d9:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011da:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011e1:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011e5:	76 5b                	jbe    101242 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011e7:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011ec:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011f2:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011f7:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011fe:	00 
  1011ff:	89 54 24 04          	mov    %edx,0x4(%esp)
  101203:	89 04 24             	mov    %eax,(%esp)
  101206:	e8 af 4a 00 00       	call   105cba <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10120b:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101212:	eb 15                	jmp    101229 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  101214:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101219:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10121c:	01 d2                	add    %edx,%edx
  10121e:	01 d0                	add    %edx,%eax
  101220:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101225:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101229:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101230:	7e e2                	jle    101214 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  101232:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101239:	83 e8 50             	sub    $0x50,%eax
  10123c:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101242:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  101249:	0f b7 c0             	movzwl %ax,%eax
  10124c:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  101250:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  101254:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101258:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10125c:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  10125d:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101264:	66 c1 e8 08          	shr    $0x8,%ax
  101268:	0f b6 c0             	movzbl %al,%eax
  10126b:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  101272:	83 c2 01             	add    $0x1,%edx
  101275:	0f b7 d2             	movzwl %dx,%edx
  101278:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  10127c:	88 45 ed             	mov    %al,-0x13(%ebp)
  10127f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101283:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101287:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101288:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  10128f:	0f b7 c0             	movzwl %ax,%eax
  101292:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101296:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  10129a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10129e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1012a2:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  1012a3:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1012aa:	0f b6 c0             	movzbl %al,%eax
  1012ad:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  1012b4:	83 c2 01             	add    $0x1,%edx
  1012b7:	0f b7 d2             	movzwl %dx,%edx
  1012ba:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  1012be:	88 45 e5             	mov    %al,-0x1b(%ebp)
  1012c1:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012c5:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012c9:	ee                   	out    %al,(%dx)
}
  1012ca:	83 c4 34             	add    $0x34,%esp
  1012cd:	5b                   	pop    %ebx
  1012ce:	5d                   	pop    %ebp
  1012cf:	c3                   	ret    

001012d0 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012d0:	55                   	push   %ebp
  1012d1:	89 e5                	mov    %esp,%ebp
  1012d3:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012dd:	eb 09                	jmp    1012e8 <serial_putc_sub+0x18>
        delay();
  1012df:	e8 4f fb ff ff       	call   100e33 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012e4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012e8:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012ee:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012f2:	89 c2                	mov    %eax,%edx
  1012f4:	ec                   	in     (%dx),%al
  1012f5:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012f8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012fc:	0f b6 c0             	movzbl %al,%eax
  1012ff:	83 e0 20             	and    $0x20,%eax
  101302:	85 c0                	test   %eax,%eax
  101304:	75 09                	jne    10130f <serial_putc_sub+0x3f>
  101306:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10130d:	7e d0                	jle    1012df <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  10130f:	8b 45 08             	mov    0x8(%ebp),%eax
  101312:	0f b6 c0             	movzbl %al,%eax
  101315:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10131b:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10131e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101322:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101326:	ee                   	out    %al,(%dx)
}
  101327:	c9                   	leave  
  101328:	c3                   	ret    

00101329 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101329:	55                   	push   %ebp
  10132a:	89 e5                	mov    %esp,%ebp
  10132c:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10132f:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101333:	74 0d                	je     101342 <serial_putc+0x19>
        serial_putc_sub(c);
  101335:	8b 45 08             	mov    0x8(%ebp),%eax
  101338:	89 04 24             	mov    %eax,(%esp)
  10133b:	e8 90 ff ff ff       	call   1012d0 <serial_putc_sub>
  101340:	eb 24                	jmp    101366 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  101342:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101349:	e8 82 ff ff ff       	call   1012d0 <serial_putc_sub>
        serial_putc_sub(' ');
  10134e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101355:	e8 76 ff ff ff       	call   1012d0 <serial_putc_sub>
        serial_putc_sub('\b');
  10135a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101361:	e8 6a ff ff ff       	call   1012d0 <serial_putc_sub>
    }
}
  101366:	c9                   	leave  
  101367:	c3                   	ret    

00101368 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101368:	55                   	push   %ebp
  101369:	89 e5                	mov    %esp,%ebp
  10136b:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  10136e:	eb 33                	jmp    1013a3 <cons_intr+0x3b>
        if (c != 0) {
  101370:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101374:	74 2d                	je     1013a3 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101376:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  10137b:	8d 50 01             	lea    0x1(%eax),%edx
  10137e:	89 15 a4 80 11 00    	mov    %edx,0x1180a4
  101384:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101387:	88 90 a0 7e 11 00    	mov    %dl,0x117ea0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10138d:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101392:	3d 00 02 00 00       	cmp    $0x200,%eax
  101397:	75 0a                	jne    1013a3 <cons_intr+0x3b>
                cons.wpos = 0;
  101399:	c7 05 a4 80 11 00 00 	movl   $0x0,0x1180a4
  1013a0:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  1013a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1013a6:	ff d0                	call   *%eax
  1013a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1013ab:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013af:	75 bf                	jne    101370 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  1013b1:	c9                   	leave  
  1013b2:	c3                   	ret    

001013b3 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013b3:	55                   	push   %ebp
  1013b4:	89 e5                	mov    %esp,%ebp
  1013b6:	83 ec 10             	sub    $0x10,%esp
  1013b9:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013bf:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013c3:	89 c2                	mov    %eax,%edx
  1013c5:	ec                   	in     (%dx),%al
  1013c6:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013c9:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013cd:	0f b6 c0             	movzbl %al,%eax
  1013d0:	83 e0 01             	and    $0x1,%eax
  1013d3:	85 c0                	test   %eax,%eax
  1013d5:	75 07                	jne    1013de <serial_proc_data+0x2b>
        return -1;
  1013d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013dc:	eb 2a                	jmp    101408 <serial_proc_data+0x55>
  1013de:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013e4:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013e8:	89 c2                	mov    %eax,%edx
  1013ea:	ec                   	in     (%dx),%al
  1013eb:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013ee:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013f2:	0f b6 c0             	movzbl %al,%eax
  1013f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013f8:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013fc:	75 07                	jne    101405 <serial_proc_data+0x52>
        c = '\b';
  1013fe:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101405:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101408:	c9                   	leave  
  101409:	c3                   	ret    

0010140a <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  10140a:	55                   	push   %ebp
  10140b:	89 e5                	mov    %esp,%ebp
  10140d:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101410:	a1 88 7e 11 00       	mov    0x117e88,%eax
  101415:	85 c0                	test   %eax,%eax
  101417:	74 0c                	je     101425 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101419:	c7 04 24 b3 13 10 00 	movl   $0x1013b3,(%esp)
  101420:	e8 43 ff ff ff       	call   101368 <cons_intr>
    }
}
  101425:	c9                   	leave  
  101426:	c3                   	ret    

00101427 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101427:	55                   	push   %ebp
  101428:	89 e5                	mov    %esp,%ebp
  10142a:	83 ec 38             	sub    $0x38,%esp
  10142d:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101433:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101437:	89 c2                	mov    %eax,%edx
  101439:	ec                   	in     (%dx),%al
  10143a:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  10143d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101441:	0f b6 c0             	movzbl %al,%eax
  101444:	83 e0 01             	and    $0x1,%eax
  101447:	85 c0                	test   %eax,%eax
  101449:	75 0a                	jne    101455 <kbd_proc_data+0x2e>
        return -1;
  10144b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101450:	e9 59 01 00 00       	jmp    1015ae <kbd_proc_data+0x187>
  101455:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10145b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10145f:	89 c2                	mov    %eax,%edx
  101461:	ec                   	in     (%dx),%al
  101462:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101465:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101469:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  10146c:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101470:	75 17                	jne    101489 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101472:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101477:	83 c8 40             	or     $0x40,%eax
  10147a:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  10147f:	b8 00 00 00 00       	mov    $0x0,%eax
  101484:	e9 25 01 00 00       	jmp    1015ae <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101489:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10148d:	84 c0                	test   %al,%al
  10148f:	79 47                	jns    1014d8 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101491:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101496:	83 e0 40             	and    $0x40,%eax
  101499:	85 c0                	test   %eax,%eax
  10149b:	75 09                	jne    1014a6 <kbd_proc_data+0x7f>
  10149d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a1:	83 e0 7f             	and    $0x7f,%eax
  1014a4:	eb 04                	jmp    1014aa <kbd_proc_data+0x83>
  1014a6:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014aa:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1014ad:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014b1:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014b8:	83 c8 40             	or     $0x40,%eax
  1014bb:	0f b6 c0             	movzbl %al,%eax
  1014be:	f7 d0                	not    %eax
  1014c0:	89 c2                	mov    %eax,%edx
  1014c2:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014c7:	21 d0                	and    %edx,%eax
  1014c9:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  1014ce:	b8 00 00 00 00       	mov    $0x0,%eax
  1014d3:	e9 d6 00 00 00       	jmp    1015ae <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1014d8:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014dd:	83 e0 40             	and    $0x40,%eax
  1014e0:	85 c0                	test   %eax,%eax
  1014e2:	74 11                	je     1014f5 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014e4:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014e8:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014ed:	83 e0 bf             	and    $0xffffffbf,%eax
  1014f0:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    }

    shift |= shiftcode[data];
  1014f5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014f9:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  101500:	0f b6 d0             	movzbl %al,%edx
  101503:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101508:	09 d0                	or     %edx,%eax
  10150a:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    shift ^= togglecode[data];
  10150f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101513:	0f b6 80 60 71 11 00 	movzbl 0x117160(%eax),%eax
  10151a:	0f b6 d0             	movzbl %al,%edx
  10151d:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101522:	31 d0                	xor    %edx,%eax
  101524:	a3 a8 80 11 00       	mov    %eax,0x1180a8

    c = charcode[shift & (CTL | SHIFT)][data];
  101529:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10152e:	83 e0 03             	and    $0x3,%eax
  101531:	8b 14 85 60 75 11 00 	mov    0x117560(,%eax,4),%edx
  101538:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10153c:	01 d0                	add    %edx,%eax
  10153e:	0f b6 00             	movzbl (%eax),%eax
  101541:	0f b6 c0             	movzbl %al,%eax
  101544:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101547:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10154c:	83 e0 08             	and    $0x8,%eax
  10154f:	85 c0                	test   %eax,%eax
  101551:	74 22                	je     101575 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  101553:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101557:	7e 0c                	jle    101565 <kbd_proc_data+0x13e>
  101559:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  10155d:	7f 06                	jg     101565 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  10155f:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101563:	eb 10                	jmp    101575 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  101565:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101569:	7e 0a                	jle    101575 <kbd_proc_data+0x14e>
  10156b:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  10156f:	7f 04                	jg     101575 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101571:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101575:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10157a:	f7 d0                	not    %eax
  10157c:	83 e0 06             	and    $0x6,%eax
  10157f:	85 c0                	test   %eax,%eax
  101581:	75 28                	jne    1015ab <kbd_proc_data+0x184>
  101583:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10158a:	75 1f                	jne    1015ab <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  10158c:	c7 04 24 3d 61 10 00 	movl   $0x10613d,(%esp)
  101593:	e8 a4 ed ff ff       	call   10033c <cprintf>
  101598:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10159e:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1015a2:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1015a6:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  1015aa:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1015ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015ae:	c9                   	leave  
  1015af:	c3                   	ret    

001015b0 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015b0:	55                   	push   %ebp
  1015b1:	89 e5                	mov    %esp,%ebp
  1015b3:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015b6:	c7 04 24 27 14 10 00 	movl   $0x101427,(%esp)
  1015bd:	e8 a6 fd ff ff       	call   101368 <cons_intr>
}
  1015c2:	c9                   	leave  
  1015c3:	c3                   	ret    

001015c4 <kbd_init>:

static void
kbd_init(void) {
  1015c4:	55                   	push   %ebp
  1015c5:	89 e5                	mov    %esp,%ebp
  1015c7:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015ca:	e8 e1 ff ff ff       	call   1015b0 <kbd_intr>
    pic_enable(IRQ_KBD);
  1015cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015d6:	e8 3d 01 00 00       	call   101718 <pic_enable>
}
  1015db:	c9                   	leave  
  1015dc:	c3                   	ret    

001015dd <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015dd:	55                   	push   %ebp
  1015de:	89 e5                	mov    %esp,%ebp
  1015e0:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015e3:	e8 93 f8 ff ff       	call   100e7b <cga_init>
    serial_init();
  1015e8:	e8 74 f9 ff ff       	call   100f61 <serial_init>
    kbd_init();
  1015ed:	e8 d2 ff ff ff       	call   1015c4 <kbd_init>
    if (!serial_exists) {
  1015f2:	a1 88 7e 11 00       	mov    0x117e88,%eax
  1015f7:	85 c0                	test   %eax,%eax
  1015f9:	75 0c                	jne    101607 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015fb:	c7 04 24 49 61 10 00 	movl   $0x106149,(%esp)
  101602:	e8 35 ed ff ff       	call   10033c <cprintf>
    }
}
  101607:	c9                   	leave  
  101608:	c3                   	ret    

00101609 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101609:	55                   	push   %ebp
  10160a:	89 e5                	mov    %esp,%ebp
  10160c:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  10160f:	e8 e2 f7 ff ff       	call   100df6 <__intr_save>
  101614:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  101617:	8b 45 08             	mov    0x8(%ebp),%eax
  10161a:	89 04 24             	mov    %eax,(%esp)
  10161d:	e8 9b fa ff ff       	call   1010bd <lpt_putc>
        cga_putc(c);
  101622:	8b 45 08             	mov    0x8(%ebp),%eax
  101625:	89 04 24             	mov    %eax,(%esp)
  101628:	e8 cf fa ff ff       	call   1010fc <cga_putc>
        serial_putc(c);
  10162d:	8b 45 08             	mov    0x8(%ebp),%eax
  101630:	89 04 24             	mov    %eax,(%esp)
  101633:	e8 f1 fc ff ff       	call   101329 <serial_putc>
    }
    local_intr_restore(intr_flag);
  101638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10163b:	89 04 24             	mov    %eax,(%esp)
  10163e:	e8 dd f7 ff ff       	call   100e20 <__intr_restore>
}
  101643:	c9                   	leave  
  101644:	c3                   	ret    

00101645 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101645:	55                   	push   %ebp
  101646:	89 e5                	mov    %esp,%ebp
  101648:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  10164b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101652:	e8 9f f7 ff ff       	call   100df6 <__intr_save>
  101657:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  10165a:	e8 ab fd ff ff       	call   10140a <serial_intr>
        kbd_intr();
  10165f:	e8 4c ff ff ff       	call   1015b0 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101664:	8b 15 a0 80 11 00    	mov    0x1180a0,%edx
  10166a:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  10166f:	39 c2                	cmp    %eax,%edx
  101671:	74 31                	je     1016a4 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  101673:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101678:	8d 50 01             	lea    0x1(%eax),%edx
  10167b:	89 15 a0 80 11 00    	mov    %edx,0x1180a0
  101681:	0f b6 80 a0 7e 11 00 	movzbl 0x117ea0(%eax),%eax
  101688:	0f b6 c0             	movzbl %al,%eax
  10168b:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  10168e:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101693:	3d 00 02 00 00       	cmp    $0x200,%eax
  101698:	75 0a                	jne    1016a4 <cons_getc+0x5f>
                cons.rpos = 0;
  10169a:	c7 05 a0 80 11 00 00 	movl   $0x0,0x1180a0
  1016a1:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  1016a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1016a7:	89 04 24             	mov    %eax,(%esp)
  1016aa:	e8 71 f7 ff ff       	call   100e20 <__intr_restore>
    return c;
  1016af:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016b2:	c9                   	leave  
  1016b3:	c3                   	ret    

001016b4 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1016b4:	55                   	push   %ebp
  1016b5:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  1016b7:	fb                   	sti    
    sti();
}
  1016b8:	5d                   	pop    %ebp
  1016b9:	c3                   	ret    

001016ba <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1016ba:	55                   	push   %ebp
  1016bb:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  1016bd:	fa                   	cli    
    cli();
}
  1016be:	5d                   	pop    %ebp
  1016bf:	c3                   	ret    

001016c0 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016c0:	55                   	push   %ebp
  1016c1:	89 e5                	mov    %esp,%ebp
  1016c3:	83 ec 14             	sub    $0x14,%esp
  1016c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1016c9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016cd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016d1:	66 a3 70 75 11 00    	mov    %ax,0x117570
    if (did_init) {
  1016d7:	a1 ac 80 11 00       	mov    0x1180ac,%eax
  1016dc:	85 c0                	test   %eax,%eax
  1016de:	74 36                	je     101716 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016e0:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016e4:	0f b6 c0             	movzbl %al,%eax
  1016e7:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016ed:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1016f0:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016f4:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016f8:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016f9:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016fd:	66 c1 e8 08          	shr    $0x8,%ax
  101701:	0f b6 c0             	movzbl %al,%eax
  101704:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  10170a:	88 45 f9             	mov    %al,-0x7(%ebp)
  10170d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101711:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101715:	ee                   	out    %al,(%dx)
    }
}
  101716:	c9                   	leave  
  101717:	c3                   	ret    

00101718 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101718:	55                   	push   %ebp
  101719:	89 e5                	mov    %esp,%ebp
  10171b:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10171e:	8b 45 08             	mov    0x8(%ebp),%eax
  101721:	ba 01 00 00 00       	mov    $0x1,%edx
  101726:	89 c1                	mov    %eax,%ecx
  101728:	d3 e2                	shl    %cl,%edx
  10172a:	89 d0                	mov    %edx,%eax
  10172c:	f7 d0                	not    %eax
  10172e:	89 c2                	mov    %eax,%edx
  101730:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101737:	21 d0                	and    %edx,%eax
  101739:	0f b7 c0             	movzwl %ax,%eax
  10173c:	89 04 24             	mov    %eax,(%esp)
  10173f:	e8 7c ff ff ff       	call   1016c0 <pic_setmask>
}
  101744:	c9                   	leave  
  101745:	c3                   	ret    

00101746 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101746:	55                   	push   %ebp
  101747:	89 e5                	mov    %esp,%ebp
  101749:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  10174c:	c7 05 ac 80 11 00 01 	movl   $0x1,0x1180ac
  101753:	00 00 00 
  101756:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  10175c:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  101760:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101764:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101768:	ee                   	out    %al,(%dx)
  101769:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  10176f:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  101773:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101777:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10177b:	ee                   	out    %al,(%dx)
  10177c:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101782:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  101786:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10178a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10178e:	ee                   	out    %al,(%dx)
  10178f:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  101795:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  101799:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10179d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1017a1:	ee                   	out    %al,(%dx)
  1017a2:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  1017a8:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  1017ac:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1017b0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017b4:	ee                   	out    %al,(%dx)
  1017b5:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  1017bb:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  1017bf:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017c3:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017c7:	ee                   	out    %al,(%dx)
  1017c8:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1017ce:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  1017d2:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017d6:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017da:	ee                   	out    %al,(%dx)
  1017db:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  1017e1:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  1017e5:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017e9:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017ed:	ee                   	out    %al,(%dx)
  1017ee:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  1017f4:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  1017f8:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017fc:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101800:	ee                   	out    %al,(%dx)
  101801:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  101807:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  10180b:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10180f:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101813:	ee                   	out    %al,(%dx)
  101814:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  10181a:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  10181e:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101822:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101826:	ee                   	out    %al,(%dx)
  101827:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10182d:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  101831:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101835:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101839:	ee                   	out    %al,(%dx)
  10183a:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  101840:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  101844:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101848:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  10184c:	ee                   	out    %al,(%dx)
  10184d:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  101853:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  101857:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  10185b:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  10185f:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101860:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101867:	66 83 f8 ff          	cmp    $0xffff,%ax
  10186b:	74 12                	je     10187f <pic_init+0x139>
        pic_setmask(irq_mask);
  10186d:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101874:	0f b7 c0             	movzwl %ax,%eax
  101877:	89 04 24             	mov    %eax,(%esp)
  10187a:	e8 41 fe ff ff       	call   1016c0 <pic_setmask>
    }
}
  10187f:	c9                   	leave  
  101880:	c3                   	ret    

00101881 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101881:	55                   	push   %ebp
  101882:	89 e5                	mov    %esp,%ebp
  101884:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101887:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  10188e:	00 
  10188f:	c7 04 24 80 61 10 00 	movl   $0x106180,(%esp)
  101896:	e8 a1 ea ff ff       	call   10033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  10189b:	c7 04 24 8a 61 10 00 	movl   $0x10618a,(%esp)
  1018a2:	e8 95 ea ff ff       	call   10033c <cprintf>
    panic("EOT: kernel seems ok.");
  1018a7:	c7 44 24 08 98 61 10 	movl   $0x106198,0x8(%esp)
  1018ae:	00 
  1018af:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  1018b6:	00 
  1018b7:	c7 04 24 ae 61 10 00 	movl   $0x1061ae,(%esp)
  1018be:	e8 14 f4 ff ff       	call   100cd7 <__panic>

001018c3 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018c3:	55                   	push   %ebp
  1018c4:	89 e5                	mov    %esp,%ebp
  1018c6:	83 ec 10             	sub    $0x10,%esp
      */
	// My Code starts
	extern uintptr_t __vectors[];     // declaration code generted by vector.c
	int i;
	// fill in the idt
	for (i = 0; i < 256; i++) {
  1018c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018d0:	e9 c3 00 00 00       	jmp    101998 <idt_init+0xd5>
		// not trap, kernel's code/text, offset defined in vector.S, privilege 0
		// macro defined in memlayout.h
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1018d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d8:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  1018df:	89 c2                	mov    %eax,%edx
  1018e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e4:	66 89 14 c5 c0 80 11 	mov    %dx,0x1180c0(,%eax,8)
  1018eb:	00 
  1018ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ef:	66 c7 04 c5 c2 80 11 	movw   $0x8,0x1180c2(,%eax,8)
  1018f6:	00 08 00 
  1018f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018fc:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  101903:	00 
  101904:	83 e2 e0             	and    $0xffffffe0,%edx
  101907:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  10190e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101911:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  101918:	00 
  101919:	83 e2 1f             	and    $0x1f,%edx
  10191c:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  101923:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101926:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10192d:	00 
  10192e:	83 e2 f0             	and    $0xfffffff0,%edx
  101931:	83 ca 0e             	or     $0xe,%edx
  101934:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10193b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10193e:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101945:	00 
  101946:	83 e2 ef             	and    $0xffffffef,%edx
  101949:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101950:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101953:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10195a:	00 
  10195b:	83 e2 9f             	and    $0xffffff9f,%edx
  10195e:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101965:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101968:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10196f:	00 
  101970:	83 ca 80             	or     $0xffffff80,%edx
  101973:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10197a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10197d:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  101984:	c1 e8 10             	shr    $0x10,%eax
  101987:	89 c2                	mov    %eax,%edx
  101989:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10198c:	66 89 14 c5 c6 80 11 	mov    %dx,0x1180c6(,%eax,8)
  101993:	00 
      */
	// My Code starts
	extern uintptr_t __vectors[];     // declaration code generted by vector.c
	int i;
	// fill in the idt
	for (i = 0; i < 256; i++) {
  101994:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101998:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  10199f:	0f 8e 30 ff ff ff    	jle    1018d5 <idt_init+0x12>
		// not trap, kernel's code/text, offset defined in vector.S, privilege 0
		// macro defined in memlayout.h
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
	}
	// For challenge 1, need to grant the access to SWITCH_TOKernel in user mode
	SETGATE(idt[T_SWITCH_TOK], 1, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  1019a5:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  1019aa:	66 a3 88 84 11 00    	mov    %ax,0x118488
  1019b0:	66 c7 05 8a 84 11 00 	movw   $0x8,0x11848a
  1019b7:	08 00 
  1019b9:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  1019c0:	83 e0 e0             	and    $0xffffffe0,%eax
  1019c3:	a2 8c 84 11 00       	mov    %al,0x11848c
  1019c8:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  1019cf:	83 e0 1f             	and    $0x1f,%eax
  1019d2:	a2 8c 84 11 00       	mov    %al,0x11848c
  1019d7:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019de:	83 c8 0f             	or     $0xf,%eax
  1019e1:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019e6:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019ed:	83 e0 ef             	and    $0xffffffef,%eax
  1019f0:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019f5:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019fc:	83 c8 60             	or     $0x60,%eax
  1019ff:	a2 8d 84 11 00       	mov    %al,0x11848d
  101a04:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  101a0b:	83 c8 80             	or     $0xffffff80,%eax
  101a0e:	a2 8d 84 11 00       	mov    %al,0x11848d
  101a13:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  101a18:	c1 e8 10             	shr    $0x10,%eax
  101a1b:	66 a3 8e 84 11 00    	mov    %ax,0x11848e
  101a21:	c7 45 f8 80 75 11 00 	movl   $0x117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101a28:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a2b:	0f 01 18             	lidtl  (%eax)
	lidt(&idt_pd);
	// My Code ends
}
  101a2e:	c9                   	leave  
  101a2f:	c3                   	ret    

00101a30 <trapname>:

static const char *
trapname(int trapno) {
  101a30:	55                   	push   %ebp
  101a31:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a33:	8b 45 08             	mov    0x8(%ebp),%eax
  101a36:	83 f8 13             	cmp    $0x13,%eax
  101a39:	77 0c                	ja     101a47 <trapname+0x17>
        return excnames[trapno];
  101a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a3e:	8b 04 85 00 65 10 00 	mov    0x106500(,%eax,4),%eax
  101a45:	eb 18                	jmp    101a5f <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a47:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a4b:	7e 0d                	jle    101a5a <trapname+0x2a>
  101a4d:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a51:	7f 07                	jg     101a5a <trapname+0x2a>
        return "Hardware Interrupt";
  101a53:	b8 bf 61 10 00       	mov    $0x1061bf,%eax
  101a58:	eb 05                	jmp    101a5f <trapname+0x2f>
    }
    return "(unknown trap)";
  101a5a:	b8 d2 61 10 00       	mov    $0x1061d2,%eax
}
  101a5f:	5d                   	pop    %ebp
  101a60:	c3                   	ret    

00101a61 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a61:	55                   	push   %ebp
  101a62:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a64:	8b 45 08             	mov    0x8(%ebp),%eax
  101a67:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a6b:	66 83 f8 08          	cmp    $0x8,%ax
  101a6f:	0f 94 c0             	sete   %al
  101a72:	0f b6 c0             	movzbl %al,%eax
}
  101a75:	5d                   	pop    %ebp
  101a76:	c3                   	ret    

00101a77 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a77:	55                   	push   %ebp
  101a78:	89 e5                	mov    %esp,%ebp
  101a7a:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a80:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a84:	c7 04 24 13 62 10 00 	movl   $0x106213,(%esp)
  101a8b:	e8 ac e8 ff ff       	call   10033c <cprintf>
    print_regs(&tf->tf_regs);
  101a90:	8b 45 08             	mov    0x8(%ebp),%eax
  101a93:	89 04 24             	mov    %eax,(%esp)
  101a96:	e8 a1 01 00 00       	call   101c3c <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a9e:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101aa2:	0f b7 c0             	movzwl %ax,%eax
  101aa5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aa9:	c7 04 24 24 62 10 00 	movl   $0x106224,(%esp)
  101ab0:	e8 87 e8 ff ff       	call   10033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab8:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101abc:	0f b7 c0             	movzwl %ax,%eax
  101abf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ac3:	c7 04 24 37 62 10 00 	movl   $0x106237,(%esp)
  101aca:	e8 6d e8 ff ff       	call   10033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101acf:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad2:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101ad6:	0f b7 c0             	movzwl %ax,%eax
  101ad9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101add:	c7 04 24 4a 62 10 00 	movl   $0x10624a,(%esp)
  101ae4:	e8 53 e8 ff ff       	call   10033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  101aec:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101af0:	0f b7 c0             	movzwl %ax,%eax
  101af3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101af7:	c7 04 24 5d 62 10 00 	movl   $0x10625d,(%esp)
  101afe:	e8 39 e8 ff ff       	call   10033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b03:	8b 45 08             	mov    0x8(%ebp),%eax
  101b06:	8b 40 30             	mov    0x30(%eax),%eax
  101b09:	89 04 24             	mov    %eax,(%esp)
  101b0c:	e8 1f ff ff ff       	call   101a30 <trapname>
  101b11:	8b 55 08             	mov    0x8(%ebp),%edx
  101b14:	8b 52 30             	mov    0x30(%edx),%edx
  101b17:	89 44 24 08          	mov    %eax,0x8(%esp)
  101b1b:	89 54 24 04          	mov    %edx,0x4(%esp)
  101b1f:	c7 04 24 70 62 10 00 	movl   $0x106270,(%esp)
  101b26:	e8 11 e8 ff ff       	call   10033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b2e:	8b 40 34             	mov    0x34(%eax),%eax
  101b31:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b35:	c7 04 24 82 62 10 00 	movl   $0x106282,(%esp)
  101b3c:	e8 fb e7 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b41:	8b 45 08             	mov    0x8(%ebp),%eax
  101b44:	8b 40 38             	mov    0x38(%eax),%eax
  101b47:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b4b:	c7 04 24 91 62 10 00 	movl   $0x106291,(%esp)
  101b52:	e8 e5 e7 ff ff       	call   10033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b57:	8b 45 08             	mov    0x8(%ebp),%eax
  101b5a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b5e:	0f b7 c0             	movzwl %ax,%eax
  101b61:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b65:	c7 04 24 a0 62 10 00 	movl   $0x1062a0,(%esp)
  101b6c:	e8 cb e7 ff ff       	call   10033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b71:	8b 45 08             	mov    0x8(%ebp),%eax
  101b74:	8b 40 40             	mov    0x40(%eax),%eax
  101b77:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b7b:	c7 04 24 b3 62 10 00 	movl   $0x1062b3,(%esp)
  101b82:	e8 b5 e7 ff ff       	call   10033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b87:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b8e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b95:	eb 3e                	jmp    101bd5 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b97:	8b 45 08             	mov    0x8(%ebp),%eax
  101b9a:	8b 50 40             	mov    0x40(%eax),%edx
  101b9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101ba0:	21 d0                	and    %edx,%eax
  101ba2:	85 c0                	test   %eax,%eax
  101ba4:	74 28                	je     101bce <print_trapframe+0x157>
  101ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ba9:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101bb0:	85 c0                	test   %eax,%eax
  101bb2:	74 1a                	je     101bce <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bb7:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101bbe:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc2:	c7 04 24 c2 62 10 00 	movl   $0x1062c2,(%esp)
  101bc9:	e8 6e e7 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bce:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101bd2:	d1 65 f0             	shll   -0x10(%ebp)
  101bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bd8:	83 f8 17             	cmp    $0x17,%eax
  101bdb:	76 ba                	jbe    101b97 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  101be0:	8b 40 40             	mov    0x40(%eax),%eax
  101be3:	25 00 30 00 00       	and    $0x3000,%eax
  101be8:	c1 e8 0c             	shr    $0xc,%eax
  101beb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bef:	c7 04 24 c6 62 10 00 	movl   $0x1062c6,(%esp)
  101bf6:	e8 41 e7 ff ff       	call   10033c <cprintf>

    if (!trap_in_kernel(tf)) {
  101bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bfe:	89 04 24             	mov    %eax,(%esp)
  101c01:	e8 5b fe ff ff       	call   101a61 <trap_in_kernel>
  101c06:	85 c0                	test   %eax,%eax
  101c08:	75 30                	jne    101c3a <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c0d:	8b 40 44             	mov    0x44(%eax),%eax
  101c10:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c14:	c7 04 24 cf 62 10 00 	movl   $0x1062cf,(%esp)
  101c1b:	e8 1c e7 ff ff       	call   10033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c20:	8b 45 08             	mov    0x8(%ebp),%eax
  101c23:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c27:	0f b7 c0             	movzwl %ax,%eax
  101c2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c2e:	c7 04 24 de 62 10 00 	movl   $0x1062de,(%esp)
  101c35:	e8 02 e7 ff ff       	call   10033c <cprintf>
    }
}
  101c3a:	c9                   	leave  
  101c3b:	c3                   	ret    

00101c3c <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c3c:	55                   	push   %ebp
  101c3d:	89 e5                	mov    %esp,%ebp
  101c3f:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c42:	8b 45 08             	mov    0x8(%ebp),%eax
  101c45:	8b 00                	mov    (%eax),%eax
  101c47:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c4b:	c7 04 24 f1 62 10 00 	movl   $0x1062f1,(%esp)
  101c52:	e8 e5 e6 ff ff       	call   10033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c57:	8b 45 08             	mov    0x8(%ebp),%eax
  101c5a:	8b 40 04             	mov    0x4(%eax),%eax
  101c5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c61:	c7 04 24 00 63 10 00 	movl   $0x106300,(%esp)
  101c68:	e8 cf e6 ff ff       	call   10033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c70:	8b 40 08             	mov    0x8(%eax),%eax
  101c73:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c77:	c7 04 24 0f 63 10 00 	movl   $0x10630f,(%esp)
  101c7e:	e8 b9 e6 ff ff       	call   10033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c83:	8b 45 08             	mov    0x8(%ebp),%eax
  101c86:	8b 40 0c             	mov    0xc(%eax),%eax
  101c89:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c8d:	c7 04 24 1e 63 10 00 	movl   $0x10631e,(%esp)
  101c94:	e8 a3 e6 ff ff       	call   10033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c99:	8b 45 08             	mov    0x8(%ebp),%eax
  101c9c:	8b 40 10             	mov    0x10(%eax),%eax
  101c9f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ca3:	c7 04 24 2d 63 10 00 	movl   $0x10632d,(%esp)
  101caa:	e8 8d e6 ff ff       	call   10033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101caf:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb2:	8b 40 14             	mov    0x14(%eax),%eax
  101cb5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cb9:	c7 04 24 3c 63 10 00 	movl   $0x10633c,(%esp)
  101cc0:	e8 77 e6 ff ff       	call   10033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  101cc8:	8b 40 18             	mov    0x18(%eax),%eax
  101ccb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ccf:	c7 04 24 4b 63 10 00 	movl   $0x10634b,(%esp)
  101cd6:	e8 61 e6 ff ff       	call   10033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  101cde:	8b 40 1c             	mov    0x1c(%eax),%eax
  101ce1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ce5:	c7 04 24 5a 63 10 00 	movl   $0x10635a,(%esp)
  101cec:	e8 4b e6 ff ff       	call   10033c <cprintf>
}
  101cf1:	c9                   	leave  
  101cf2:	c3                   	ret    

00101cf3 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101cf3:	55                   	push   %ebp
  101cf4:	89 e5                	mov    %esp,%ebp
  101cf6:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  101cfc:	8b 40 30             	mov    0x30(%eax),%eax
  101cff:	83 f8 2f             	cmp    $0x2f,%eax
  101d02:	77 21                	ja     101d25 <trap_dispatch+0x32>
  101d04:	83 f8 2e             	cmp    $0x2e,%eax
  101d07:	0f 83 04 01 00 00    	jae    101e11 <trap_dispatch+0x11e>
  101d0d:	83 f8 21             	cmp    $0x21,%eax
  101d10:	0f 84 81 00 00 00    	je     101d97 <trap_dispatch+0xa4>
  101d16:	83 f8 24             	cmp    $0x24,%eax
  101d19:	74 56                	je     101d71 <trap_dispatch+0x7e>
  101d1b:	83 f8 20             	cmp    $0x20,%eax
  101d1e:	74 16                	je     101d36 <trap_dispatch+0x43>
  101d20:	e9 b4 00 00 00       	jmp    101dd9 <trap_dispatch+0xe6>
  101d25:	83 e8 78             	sub    $0x78,%eax
  101d28:	83 f8 01             	cmp    $0x1,%eax
  101d2b:	0f 87 a8 00 00 00    	ja     101dd9 <trap_dispatch+0xe6>
  101d31:	e9 87 00 00 00       	jmp    101dbd <trap_dispatch+0xca>
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
		// My code starts
		ticks++;
  101d36:	a1 4c 89 11 00       	mov    0x11894c,%eax
  101d3b:	83 c0 01             	add    $0x1,%eax
  101d3e:	a3 4c 89 11 00       	mov    %eax,0x11894c
		if (ticks % TICK_NUM == 0) {
  101d43:	8b 0d 4c 89 11 00    	mov    0x11894c,%ecx
  101d49:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d4e:	89 c8                	mov    %ecx,%eax
  101d50:	f7 e2                	mul    %edx
  101d52:	89 d0                	mov    %edx,%eax
  101d54:	c1 e8 05             	shr    $0x5,%eax
  101d57:	6b c0 64             	imul   $0x64,%eax,%eax
  101d5a:	29 c1                	sub    %eax,%ecx
  101d5c:	89 c8                	mov    %ecx,%eax
  101d5e:	85 c0                	test   %eax,%eax
  101d60:	75 0a                	jne    101d6c <trap_dispatch+0x79>
			print_ticks();
  101d62:	e8 1a fb ff ff       	call   101881 <print_ticks>
		}
		// My code ends
        break;
  101d67:	e9 a6 00 00 00       	jmp    101e12 <trap_dispatch+0x11f>
  101d6c:	e9 a1 00 00 00       	jmp    101e12 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d71:	e8 cf f8 ff ff       	call   101645 <cons_getc>
  101d76:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d79:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d7d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d81:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d85:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d89:	c7 04 24 69 63 10 00 	movl   $0x106369,(%esp)
  101d90:	e8 a7 e5 ff ff       	call   10033c <cprintf>
        break;
  101d95:	eb 7b                	jmp    101e12 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d97:	e8 a9 f8 ff ff       	call   101645 <cons_getc>
  101d9c:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d9f:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101da3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101da7:	89 54 24 08          	mov    %edx,0x8(%esp)
  101dab:	89 44 24 04          	mov    %eax,0x4(%esp)
  101daf:	c7 04 24 7b 63 10 00 	movl   $0x10637b,(%esp)
  101db6:	e8 81 e5 ff ff       	call   10033c <cprintf>
        break;
  101dbb:	eb 55                	jmp    101e12 <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101dbd:	c7 44 24 08 8a 63 10 	movl   $0x10638a,0x8(%esp)
  101dc4:	00 
  101dc5:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
  101dcc:	00 
  101dcd:	c7 04 24 ae 61 10 00 	movl   $0x1061ae,(%esp)
  101dd4:	e8 fe ee ff ff       	call   100cd7 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  101ddc:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101de0:	0f b7 c0             	movzwl %ax,%eax
  101de3:	83 e0 03             	and    $0x3,%eax
  101de6:	85 c0                	test   %eax,%eax
  101de8:	75 28                	jne    101e12 <trap_dispatch+0x11f>
            print_trapframe(tf);
  101dea:	8b 45 08             	mov    0x8(%ebp),%eax
  101ded:	89 04 24             	mov    %eax,(%esp)
  101df0:	e8 82 fc ff ff       	call   101a77 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101df5:	c7 44 24 08 9a 63 10 	movl   $0x10639a,0x8(%esp)
  101dfc:	00 
  101dfd:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
  101e04:	00 
  101e05:	c7 04 24 ae 61 10 00 	movl   $0x1061ae,(%esp)
  101e0c:	e8 c6 ee ff ff       	call   100cd7 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101e11:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101e12:	c9                   	leave  
  101e13:	c3                   	ret    

00101e14 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101e14:	55                   	push   %ebp
  101e15:	89 e5                	mov    %esp,%ebp
  101e17:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  101e1d:	89 04 24             	mov    %eax,(%esp)
  101e20:	e8 ce fe ff ff       	call   101cf3 <trap_dispatch>
}
  101e25:	c9                   	leave  
  101e26:	c3                   	ret    

00101e27 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101e27:	1e                   	push   %ds
    pushl %es
  101e28:	06                   	push   %es
    pushl %fs
  101e29:	0f a0                	push   %fs
    pushl %gs
  101e2b:	0f a8                	push   %gs
    pushal
  101e2d:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101e2e:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101e33:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101e35:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101e37:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101e38:	e8 d7 ff ff ff       	call   101e14 <trap>

    # pop the pushed stack pointer
    popl %esp
  101e3d:	5c                   	pop    %esp

00101e3e <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101e3e:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101e3f:	0f a9                	pop    %gs
    popl %fs
  101e41:	0f a1                	pop    %fs
    popl %es
  101e43:	07                   	pop    %es
    popl %ds
  101e44:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101e45:	83 c4 08             	add    $0x8,%esp
    iret
  101e48:	cf                   	iret   

00101e49 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101e49:	6a 00                	push   $0x0
  pushl $0
  101e4b:	6a 00                	push   $0x0
  jmp __alltraps
  101e4d:	e9 d5 ff ff ff       	jmp    101e27 <__alltraps>

00101e52 <vector1>:
.globl vector1
vector1:
  pushl $0
  101e52:	6a 00                	push   $0x0
  pushl $1
  101e54:	6a 01                	push   $0x1
  jmp __alltraps
  101e56:	e9 cc ff ff ff       	jmp    101e27 <__alltraps>

00101e5b <vector2>:
.globl vector2
vector2:
  pushl $0
  101e5b:	6a 00                	push   $0x0
  pushl $2
  101e5d:	6a 02                	push   $0x2
  jmp __alltraps
  101e5f:	e9 c3 ff ff ff       	jmp    101e27 <__alltraps>

00101e64 <vector3>:
.globl vector3
vector3:
  pushl $0
  101e64:	6a 00                	push   $0x0
  pushl $3
  101e66:	6a 03                	push   $0x3
  jmp __alltraps
  101e68:	e9 ba ff ff ff       	jmp    101e27 <__alltraps>

00101e6d <vector4>:
.globl vector4
vector4:
  pushl $0
  101e6d:	6a 00                	push   $0x0
  pushl $4
  101e6f:	6a 04                	push   $0x4
  jmp __alltraps
  101e71:	e9 b1 ff ff ff       	jmp    101e27 <__alltraps>

00101e76 <vector5>:
.globl vector5
vector5:
  pushl $0
  101e76:	6a 00                	push   $0x0
  pushl $5
  101e78:	6a 05                	push   $0x5
  jmp __alltraps
  101e7a:	e9 a8 ff ff ff       	jmp    101e27 <__alltraps>

00101e7f <vector6>:
.globl vector6
vector6:
  pushl $0
  101e7f:	6a 00                	push   $0x0
  pushl $6
  101e81:	6a 06                	push   $0x6
  jmp __alltraps
  101e83:	e9 9f ff ff ff       	jmp    101e27 <__alltraps>

00101e88 <vector7>:
.globl vector7
vector7:
  pushl $0
  101e88:	6a 00                	push   $0x0
  pushl $7
  101e8a:	6a 07                	push   $0x7
  jmp __alltraps
  101e8c:	e9 96 ff ff ff       	jmp    101e27 <__alltraps>

00101e91 <vector8>:
.globl vector8
vector8:
  pushl $8
  101e91:	6a 08                	push   $0x8
  jmp __alltraps
  101e93:	e9 8f ff ff ff       	jmp    101e27 <__alltraps>

00101e98 <vector9>:
.globl vector9
vector9:
  pushl $9
  101e98:	6a 09                	push   $0x9
  jmp __alltraps
  101e9a:	e9 88 ff ff ff       	jmp    101e27 <__alltraps>

00101e9f <vector10>:
.globl vector10
vector10:
  pushl $10
  101e9f:	6a 0a                	push   $0xa
  jmp __alltraps
  101ea1:	e9 81 ff ff ff       	jmp    101e27 <__alltraps>

00101ea6 <vector11>:
.globl vector11
vector11:
  pushl $11
  101ea6:	6a 0b                	push   $0xb
  jmp __alltraps
  101ea8:	e9 7a ff ff ff       	jmp    101e27 <__alltraps>

00101ead <vector12>:
.globl vector12
vector12:
  pushl $12
  101ead:	6a 0c                	push   $0xc
  jmp __alltraps
  101eaf:	e9 73 ff ff ff       	jmp    101e27 <__alltraps>

00101eb4 <vector13>:
.globl vector13
vector13:
  pushl $13
  101eb4:	6a 0d                	push   $0xd
  jmp __alltraps
  101eb6:	e9 6c ff ff ff       	jmp    101e27 <__alltraps>

00101ebb <vector14>:
.globl vector14
vector14:
  pushl $14
  101ebb:	6a 0e                	push   $0xe
  jmp __alltraps
  101ebd:	e9 65 ff ff ff       	jmp    101e27 <__alltraps>

00101ec2 <vector15>:
.globl vector15
vector15:
  pushl $0
  101ec2:	6a 00                	push   $0x0
  pushl $15
  101ec4:	6a 0f                	push   $0xf
  jmp __alltraps
  101ec6:	e9 5c ff ff ff       	jmp    101e27 <__alltraps>

00101ecb <vector16>:
.globl vector16
vector16:
  pushl $0
  101ecb:	6a 00                	push   $0x0
  pushl $16
  101ecd:	6a 10                	push   $0x10
  jmp __alltraps
  101ecf:	e9 53 ff ff ff       	jmp    101e27 <__alltraps>

00101ed4 <vector17>:
.globl vector17
vector17:
  pushl $17
  101ed4:	6a 11                	push   $0x11
  jmp __alltraps
  101ed6:	e9 4c ff ff ff       	jmp    101e27 <__alltraps>

00101edb <vector18>:
.globl vector18
vector18:
  pushl $0
  101edb:	6a 00                	push   $0x0
  pushl $18
  101edd:	6a 12                	push   $0x12
  jmp __alltraps
  101edf:	e9 43 ff ff ff       	jmp    101e27 <__alltraps>

00101ee4 <vector19>:
.globl vector19
vector19:
  pushl $0
  101ee4:	6a 00                	push   $0x0
  pushl $19
  101ee6:	6a 13                	push   $0x13
  jmp __alltraps
  101ee8:	e9 3a ff ff ff       	jmp    101e27 <__alltraps>

00101eed <vector20>:
.globl vector20
vector20:
  pushl $0
  101eed:	6a 00                	push   $0x0
  pushl $20
  101eef:	6a 14                	push   $0x14
  jmp __alltraps
  101ef1:	e9 31 ff ff ff       	jmp    101e27 <__alltraps>

00101ef6 <vector21>:
.globl vector21
vector21:
  pushl $0
  101ef6:	6a 00                	push   $0x0
  pushl $21
  101ef8:	6a 15                	push   $0x15
  jmp __alltraps
  101efa:	e9 28 ff ff ff       	jmp    101e27 <__alltraps>

00101eff <vector22>:
.globl vector22
vector22:
  pushl $0
  101eff:	6a 00                	push   $0x0
  pushl $22
  101f01:	6a 16                	push   $0x16
  jmp __alltraps
  101f03:	e9 1f ff ff ff       	jmp    101e27 <__alltraps>

00101f08 <vector23>:
.globl vector23
vector23:
  pushl $0
  101f08:	6a 00                	push   $0x0
  pushl $23
  101f0a:	6a 17                	push   $0x17
  jmp __alltraps
  101f0c:	e9 16 ff ff ff       	jmp    101e27 <__alltraps>

00101f11 <vector24>:
.globl vector24
vector24:
  pushl $0
  101f11:	6a 00                	push   $0x0
  pushl $24
  101f13:	6a 18                	push   $0x18
  jmp __alltraps
  101f15:	e9 0d ff ff ff       	jmp    101e27 <__alltraps>

00101f1a <vector25>:
.globl vector25
vector25:
  pushl $0
  101f1a:	6a 00                	push   $0x0
  pushl $25
  101f1c:	6a 19                	push   $0x19
  jmp __alltraps
  101f1e:	e9 04 ff ff ff       	jmp    101e27 <__alltraps>

00101f23 <vector26>:
.globl vector26
vector26:
  pushl $0
  101f23:	6a 00                	push   $0x0
  pushl $26
  101f25:	6a 1a                	push   $0x1a
  jmp __alltraps
  101f27:	e9 fb fe ff ff       	jmp    101e27 <__alltraps>

00101f2c <vector27>:
.globl vector27
vector27:
  pushl $0
  101f2c:	6a 00                	push   $0x0
  pushl $27
  101f2e:	6a 1b                	push   $0x1b
  jmp __alltraps
  101f30:	e9 f2 fe ff ff       	jmp    101e27 <__alltraps>

00101f35 <vector28>:
.globl vector28
vector28:
  pushl $0
  101f35:	6a 00                	push   $0x0
  pushl $28
  101f37:	6a 1c                	push   $0x1c
  jmp __alltraps
  101f39:	e9 e9 fe ff ff       	jmp    101e27 <__alltraps>

00101f3e <vector29>:
.globl vector29
vector29:
  pushl $0
  101f3e:	6a 00                	push   $0x0
  pushl $29
  101f40:	6a 1d                	push   $0x1d
  jmp __alltraps
  101f42:	e9 e0 fe ff ff       	jmp    101e27 <__alltraps>

00101f47 <vector30>:
.globl vector30
vector30:
  pushl $0
  101f47:	6a 00                	push   $0x0
  pushl $30
  101f49:	6a 1e                	push   $0x1e
  jmp __alltraps
  101f4b:	e9 d7 fe ff ff       	jmp    101e27 <__alltraps>

00101f50 <vector31>:
.globl vector31
vector31:
  pushl $0
  101f50:	6a 00                	push   $0x0
  pushl $31
  101f52:	6a 1f                	push   $0x1f
  jmp __alltraps
  101f54:	e9 ce fe ff ff       	jmp    101e27 <__alltraps>

00101f59 <vector32>:
.globl vector32
vector32:
  pushl $0
  101f59:	6a 00                	push   $0x0
  pushl $32
  101f5b:	6a 20                	push   $0x20
  jmp __alltraps
  101f5d:	e9 c5 fe ff ff       	jmp    101e27 <__alltraps>

00101f62 <vector33>:
.globl vector33
vector33:
  pushl $0
  101f62:	6a 00                	push   $0x0
  pushl $33
  101f64:	6a 21                	push   $0x21
  jmp __alltraps
  101f66:	e9 bc fe ff ff       	jmp    101e27 <__alltraps>

00101f6b <vector34>:
.globl vector34
vector34:
  pushl $0
  101f6b:	6a 00                	push   $0x0
  pushl $34
  101f6d:	6a 22                	push   $0x22
  jmp __alltraps
  101f6f:	e9 b3 fe ff ff       	jmp    101e27 <__alltraps>

00101f74 <vector35>:
.globl vector35
vector35:
  pushl $0
  101f74:	6a 00                	push   $0x0
  pushl $35
  101f76:	6a 23                	push   $0x23
  jmp __alltraps
  101f78:	e9 aa fe ff ff       	jmp    101e27 <__alltraps>

00101f7d <vector36>:
.globl vector36
vector36:
  pushl $0
  101f7d:	6a 00                	push   $0x0
  pushl $36
  101f7f:	6a 24                	push   $0x24
  jmp __alltraps
  101f81:	e9 a1 fe ff ff       	jmp    101e27 <__alltraps>

00101f86 <vector37>:
.globl vector37
vector37:
  pushl $0
  101f86:	6a 00                	push   $0x0
  pushl $37
  101f88:	6a 25                	push   $0x25
  jmp __alltraps
  101f8a:	e9 98 fe ff ff       	jmp    101e27 <__alltraps>

00101f8f <vector38>:
.globl vector38
vector38:
  pushl $0
  101f8f:	6a 00                	push   $0x0
  pushl $38
  101f91:	6a 26                	push   $0x26
  jmp __alltraps
  101f93:	e9 8f fe ff ff       	jmp    101e27 <__alltraps>

00101f98 <vector39>:
.globl vector39
vector39:
  pushl $0
  101f98:	6a 00                	push   $0x0
  pushl $39
  101f9a:	6a 27                	push   $0x27
  jmp __alltraps
  101f9c:	e9 86 fe ff ff       	jmp    101e27 <__alltraps>

00101fa1 <vector40>:
.globl vector40
vector40:
  pushl $0
  101fa1:	6a 00                	push   $0x0
  pushl $40
  101fa3:	6a 28                	push   $0x28
  jmp __alltraps
  101fa5:	e9 7d fe ff ff       	jmp    101e27 <__alltraps>

00101faa <vector41>:
.globl vector41
vector41:
  pushl $0
  101faa:	6a 00                	push   $0x0
  pushl $41
  101fac:	6a 29                	push   $0x29
  jmp __alltraps
  101fae:	e9 74 fe ff ff       	jmp    101e27 <__alltraps>

00101fb3 <vector42>:
.globl vector42
vector42:
  pushl $0
  101fb3:	6a 00                	push   $0x0
  pushl $42
  101fb5:	6a 2a                	push   $0x2a
  jmp __alltraps
  101fb7:	e9 6b fe ff ff       	jmp    101e27 <__alltraps>

00101fbc <vector43>:
.globl vector43
vector43:
  pushl $0
  101fbc:	6a 00                	push   $0x0
  pushl $43
  101fbe:	6a 2b                	push   $0x2b
  jmp __alltraps
  101fc0:	e9 62 fe ff ff       	jmp    101e27 <__alltraps>

00101fc5 <vector44>:
.globl vector44
vector44:
  pushl $0
  101fc5:	6a 00                	push   $0x0
  pushl $44
  101fc7:	6a 2c                	push   $0x2c
  jmp __alltraps
  101fc9:	e9 59 fe ff ff       	jmp    101e27 <__alltraps>

00101fce <vector45>:
.globl vector45
vector45:
  pushl $0
  101fce:	6a 00                	push   $0x0
  pushl $45
  101fd0:	6a 2d                	push   $0x2d
  jmp __alltraps
  101fd2:	e9 50 fe ff ff       	jmp    101e27 <__alltraps>

00101fd7 <vector46>:
.globl vector46
vector46:
  pushl $0
  101fd7:	6a 00                	push   $0x0
  pushl $46
  101fd9:	6a 2e                	push   $0x2e
  jmp __alltraps
  101fdb:	e9 47 fe ff ff       	jmp    101e27 <__alltraps>

00101fe0 <vector47>:
.globl vector47
vector47:
  pushl $0
  101fe0:	6a 00                	push   $0x0
  pushl $47
  101fe2:	6a 2f                	push   $0x2f
  jmp __alltraps
  101fe4:	e9 3e fe ff ff       	jmp    101e27 <__alltraps>

00101fe9 <vector48>:
.globl vector48
vector48:
  pushl $0
  101fe9:	6a 00                	push   $0x0
  pushl $48
  101feb:	6a 30                	push   $0x30
  jmp __alltraps
  101fed:	e9 35 fe ff ff       	jmp    101e27 <__alltraps>

00101ff2 <vector49>:
.globl vector49
vector49:
  pushl $0
  101ff2:	6a 00                	push   $0x0
  pushl $49
  101ff4:	6a 31                	push   $0x31
  jmp __alltraps
  101ff6:	e9 2c fe ff ff       	jmp    101e27 <__alltraps>

00101ffb <vector50>:
.globl vector50
vector50:
  pushl $0
  101ffb:	6a 00                	push   $0x0
  pushl $50
  101ffd:	6a 32                	push   $0x32
  jmp __alltraps
  101fff:	e9 23 fe ff ff       	jmp    101e27 <__alltraps>

00102004 <vector51>:
.globl vector51
vector51:
  pushl $0
  102004:	6a 00                	push   $0x0
  pushl $51
  102006:	6a 33                	push   $0x33
  jmp __alltraps
  102008:	e9 1a fe ff ff       	jmp    101e27 <__alltraps>

0010200d <vector52>:
.globl vector52
vector52:
  pushl $0
  10200d:	6a 00                	push   $0x0
  pushl $52
  10200f:	6a 34                	push   $0x34
  jmp __alltraps
  102011:	e9 11 fe ff ff       	jmp    101e27 <__alltraps>

00102016 <vector53>:
.globl vector53
vector53:
  pushl $0
  102016:	6a 00                	push   $0x0
  pushl $53
  102018:	6a 35                	push   $0x35
  jmp __alltraps
  10201a:	e9 08 fe ff ff       	jmp    101e27 <__alltraps>

0010201f <vector54>:
.globl vector54
vector54:
  pushl $0
  10201f:	6a 00                	push   $0x0
  pushl $54
  102021:	6a 36                	push   $0x36
  jmp __alltraps
  102023:	e9 ff fd ff ff       	jmp    101e27 <__alltraps>

00102028 <vector55>:
.globl vector55
vector55:
  pushl $0
  102028:	6a 00                	push   $0x0
  pushl $55
  10202a:	6a 37                	push   $0x37
  jmp __alltraps
  10202c:	e9 f6 fd ff ff       	jmp    101e27 <__alltraps>

00102031 <vector56>:
.globl vector56
vector56:
  pushl $0
  102031:	6a 00                	push   $0x0
  pushl $56
  102033:	6a 38                	push   $0x38
  jmp __alltraps
  102035:	e9 ed fd ff ff       	jmp    101e27 <__alltraps>

0010203a <vector57>:
.globl vector57
vector57:
  pushl $0
  10203a:	6a 00                	push   $0x0
  pushl $57
  10203c:	6a 39                	push   $0x39
  jmp __alltraps
  10203e:	e9 e4 fd ff ff       	jmp    101e27 <__alltraps>

00102043 <vector58>:
.globl vector58
vector58:
  pushl $0
  102043:	6a 00                	push   $0x0
  pushl $58
  102045:	6a 3a                	push   $0x3a
  jmp __alltraps
  102047:	e9 db fd ff ff       	jmp    101e27 <__alltraps>

0010204c <vector59>:
.globl vector59
vector59:
  pushl $0
  10204c:	6a 00                	push   $0x0
  pushl $59
  10204e:	6a 3b                	push   $0x3b
  jmp __alltraps
  102050:	e9 d2 fd ff ff       	jmp    101e27 <__alltraps>

00102055 <vector60>:
.globl vector60
vector60:
  pushl $0
  102055:	6a 00                	push   $0x0
  pushl $60
  102057:	6a 3c                	push   $0x3c
  jmp __alltraps
  102059:	e9 c9 fd ff ff       	jmp    101e27 <__alltraps>

0010205e <vector61>:
.globl vector61
vector61:
  pushl $0
  10205e:	6a 00                	push   $0x0
  pushl $61
  102060:	6a 3d                	push   $0x3d
  jmp __alltraps
  102062:	e9 c0 fd ff ff       	jmp    101e27 <__alltraps>

00102067 <vector62>:
.globl vector62
vector62:
  pushl $0
  102067:	6a 00                	push   $0x0
  pushl $62
  102069:	6a 3e                	push   $0x3e
  jmp __alltraps
  10206b:	e9 b7 fd ff ff       	jmp    101e27 <__alltraps>

00102070 <vector63>:
.globl vector63
vector63:
  pushl $0
  102070:	6a 00                	push   $0x0
  pushl $63
  102072:	6a 3f                	push   $0x3f
  jmp __alltraps
  102074:	e9 ae fd ff ff       	jmp    101e27 <__alltraps>

00102079 <vector64>:
.globl vector64
vector64:
  pushl $0
  102079:	6a 00                	push   $0x0
  pushl $64
  10207b:	6a 40                	push   $0x40
  jmp __alltraps
  10207d:	e9 a5 fd ff ff       	jmp    101e27 <__alltraps>

00102082 <vector65>:
.globl vector65
vector65:
  pushl $0
  102082:	6a 00                	push   $0x0
  pushl $65
  102084:	6a 41                	push   $0x41
  jmp __alltraps
  102086:	e9 9c fd ff ff       	jmp    101e27 <__alltraps>

0010208b <vector66>:
.globl vector66
vector66:
  pushl $0
  10208b:	6a 00                	push   $0x0
  pushl $66
  10208d:	6a 42                	push   $0x42
  jmp __alltraps
  10208f:	e9 93 fd ff ff       	jmp    101e27 <__alltraps>

00102094 <vector67>:
.globl vector67
vector67:
  pushl $0
  102094:	6a 00                	push   $0x0
  pushl $67
  102096:	6a 43                	push   $0x43
  jmp __alltraps
  102098:	e9 8a fd ff ff       	jmp    101e27 <__alltraps>

0010209d <vector68>:
.globl vector68
vector68:
  pushl $0
  10209d:	6a 00                	push   $0x0
  pushl $68
  10209f:	6a 44                	push   $0x44
  jmp __alltraps
  1020a1:	e9 81 fd ff ff       	jmp    101e27 <__alltraps>

001020a6 <vector69>:
.globl vector69
vector69:
  pushl $0
  1020a6:	6a 00                	push   $0x0
  pushl $69
  1020a8:	6a 45                	push   $0x45
  jmp __alltraps
  1020aa:	e9 78 fd ff ff       	jmp    101e27 <__alltraps>

001020af <vector70>:
.globl vector70
vector70:
  pushl $0
  1020af:	6a 00                	push   $0x0
  pushl $70
  1020b1:	6a 46                	push   $0x46
  jmp __alltraps
  1020b3:	e9 6f fd ff ff       	jmp    101e27 <__alltraps>

001020b8 <vector71>:
.globl vector71
vector71:
  pushl $0
  1020b8:	6a 00                	push   $0x0
  pushl $71
  1020ba:	6a 47                	push   $0x47
  jmp __alltraps
  1020bc:	e9 66 fd ff ff       	jmp    101e27 <__alltraps>

001020c1 <vector72>:
.globl vector72
vector72:
  pushl $0
  1020c1:	6a 00                	push   $0x0
  pushl $72
  1020c3:	6a 48                	push   $0x48
  jmp __alltraps
  1020c5:	e9 5d fd ff ff       	jmp    101e27 <__alltraps>

001020ca <vector73>:
.globl vector73
vector73:
  pushl $0
  1020ca:	6a 00                	push   $0x0
  pushl $73
  1020cc:	6a 49                	push   $0x49
  jmp __alltraps
  1020ce:	e9 54 fd ff ff       	jmp    101e27 <__alltraps>

001020d3 <vector74>:
.globl vector74
vector74:
  pushl $0
  1020d3:	6a 00                	push   $0x0
  pushl $74
  1020d5:	6a 4a                	push   $0x4a
  jmp __alltraps
  1020d7:	e9 4b fd ff ff       	jmp    101e27 <__alltraps>

001020dc <vector75>:
.globl vector75
vector75:
  pushl $0
  1020dc:	6a 00                	push   $0x0
  pushl $75
  1020de:	6a 4b                	push   $0x4b
  jmp __alltraps
  1020e0:	e9 42 fd ff ff       	jmp    101e27 <__alltraps>

001020e5 <vector76>:
.globl vector76
vector76:
  pushl $0
  1020e5:	6a 00                	push   $0x0
  pushl $76
  1020e7:	6a 4c                	push   $0x4c
  jmp __alltraps
  1020e9:	e9 39 fd ff ff       	jmp    101e27 <__alltraps>

001020ee <vector77>:
.globl vector77
vector77:
  pushl $0
  1020ee:	6a 00                	push   $0x0
  pushl $77
  1020f0:	6a 4d                	push   $0x4d
  jmp __alltraps
  1020f2:	e9 30 fd ff ff       	jmp    101e27 <__alltraps>

001020f7 <vector78>:
.globl vector78
vector78:
  pushl $0
  1020f7:	6a 00                	push   $0x0
  pushl $78
  1020f9:	6a 4e                	push   $0x4e
  jmp __alltraps
  1020fb:	e9 27 fd ff ff       	jmp    101e27 <__alltraps>

00102100 <vector79>:
.globl vector79
vector79:
  pushl $0
  102100:	6a 00                	push   $0x0
  pushl $79
  102102:	6a 4f                	push   $0x4f
  jmp __alltraps
  102104:	e9 1e fd ff ff       	jmp    101e27 <__alltraps>

00102109 <vector80>:
.globl vector80
vector80:
  pushl $0
  102109:	6a 00                	push   $0x0
  pushl $80
  10210b:	6a 50                	push   $0x50
  jmp __alltraps
  10210d:	e9 15 fd ff ff       	jmp    101e27 <__alltraps>

00102112 <vector81>:
.globl vector81
vector81:
  pushl $0
  102112:	6a 00                	push   $0x0
  pushl $81
  102114:	6a 51                	push   $0x51
  jmp __alltraps
  102116:	e9 0c fd ff ff       	jmp    101e27 <__alltraps>

0010211b <vector82>:
.globl vector82
vector82:
  pushl $0
  10211b:	6a 00                	push   $0x0
  pushl $82
  10211d:	6a 52                	push   $0x52
  jmp __alltraps
  10211f:	e9 03 fd ff ff       	jmp    101e27 <__alltraps>

00102124 <vector83>:
.globl vector83
vector83:
  pushl $0
  102124:	6a 00                	push   $0x0
  pushl $83
  102126:	6a 53                	push   $0x53
  jmp __alltraps
  102128:	e9 fa fc ff ff       	jmp    101e27 <__alltraps>

0010212d <vector84>:
.globl vector84
vector84:
  pushl $0
  10212d:	6a 00                	push   $0x0
  pushl $84
  10212f:	6a 54                	push   $0x54
  jmp __alltraps
  102131:	e9 f1 fc ff ff       	jmp    101e27 <__alltraps>

00102136 <vector85>:
.globl vector85
vector85:
  pushl $0
  102136:	6a 00                	push   $0x0
  pushl $85
  102138:	6a 55                	push   $0x55
  jmp __alltraps
  10213a:	e9 e8 fc ff ff       	jmp    101e27 <__alltraps>

0010213f <vector86>:
.globl vector86
vector86:
  pushl $0
  10213f:	6a 00                	push   $0x0
  pushl $86
  102141:	6a 56                	push   $0x56
  jmp __alltraps
  102143:	e9 df fc ff ff       	jmp    101e27 <__alltraps>

00102148 <vector87>:
.globl vector87
vector87:
  pushl $0
  102148:	6a 00                	push   $0x0
  pushl $87
  10214a:	6a 57                	push   $0x57
  jmp __alltraps
  10214c:	e9 d6 fc ff ff       	jmp    101e27 <__alltraps>

00102151 <vector88>:
.globl vector88
vector88:
  pushl $0
  102151:	6a 00                	push   $0x0
  pushl $88
  102153:	6a 58                	push   $0x58
  jmp __alltraps
  102155:	e9 cd fc ff ff       	jmp    101e27 <__alltraps>

0010215a <vector89>:
.globl vector89
vector89:
  pushl $0
  10215a:	6a 00                	push   $0x0
  pushl $89
  10215c:	6a 59                	push   $0x59
  jmp __alltraps
  10215e:	e9 c4 fc ff ff       	jmp    101e27 <__alltraps>

00102163 <vector90>:
.globl vector90
vector90:
  pushl $0
  102163:	6a 00                	push   $0x0
  pushl $90
  102165:	6a 5a                	push   $0x5a
  jmp __alltraps
  102167:	e9 bb fc ff ff       	jmp    101e27 <__alltraps>

0010216c <vector91>:
.globl vector91
vector91:
  pushl $0
  10216c:	6a 00                	push   $0x0
  pushl $91
  10216e:	6a 5b                	push   $0x5b
  jmp __alltraps
  102170:	e9 b2 fc ff ff       	jmp    101e27 <__alltraps>

00102175 <vector92>:
.globl vector92
vector92:
  pushl $0
  102175:	6a 00                	push   $0x0
  pushl $92
  102177:	6a 5c                	push   $0x5c
  jmp __alltraps
  102179:	e9 a9 fc ff ff       	jmp    101e27 <__alltraps>

0010217e <vector93>:
.globl vector93
vector93:
  pushl $0
  10217e:	6a 00                	push   $0x0
  pushl $93
  102180:	6a 5d                	push   $0x5d
  jmp __alltraps
  102182:	e9 a0 fc ff ff       	jmp    101e27 <__alltraps>

00102187 <vector94>:
.globl vector94
vector94:
  pushl $0
  102187:	6a 00                	push   $0x0
  pushl $94
  102189:	6a 5e                	push   $0x5e
  jmp __alltraps
  10218b:	e9 97 fc ff ff       	jmp    101e27 <__alltraps>

00102190 <vector95>:
.globl vector95
vector95:
  pushl $0
  102190:	6a 00                	push   $0x0
  pushl $95
  102192:	6a 5f                	push   $0x5f
  jmp __alltraps
  102194:	e9 8e fc ff ff       	jmp    101e27 <__alltraps>

00102199 <vector96>:
.globl vector96
vector96:
  pushl $0
  102199:	6a 00                	push   $0x0
  pushl $96
  10219b:	6a 60                	push   $0x60
  jmp __alltraps
  10219d:	e9 85 fc ff ff       	jmp    101e27 <__alltraps>

001021a2 <vector97>:
.globl vector97
vector97:
  pushl $0
  1021a2:	6a 00                	push   $0x0
  pushl $97
  1021a4:	6a 61                	push   $0x61
  jmp __alltraps
  1021a6:	e9 7c fc ff ff       	jmp    101e27 <__alltraps>

001021ab <vector98>:
.globl vector98
vector98:
  pushl $0
  1021ab:	6a 00                	push   $0x0
  pushl $98
  1021ad:	6a 62                	push   $0x62
  jmp __alltraps
  1021af:	e9 73 fc ff ff       	jmp    101e27 <__alltraps>

001021b4 <vector99>:
.globl vector99
vector99:
  pushl $0
  1021b4:	6a 00                	push   $0x0
  pushl $99
  1021b6:	6a 63                	push   $0x63
  jmp __alltraps
  1021b8:	e9 6a fc ff ff       	jmp    101e27 <__alltraps>

001021bd <vector100>:
.globl vector100
vector100:
  pushl $0
  1021bd:	6a 00                	push   $0x0
  pushl $100
  1021bf:	6a 64                	push   $0x64
  jmp __alltraps
  1021c1:	e9 61 fc ff ff       	jmp    101e27 <__alltraps>

001021c6 <vector101>:
.globl vector101
vector101:
  pushl $0
  1021c6:	6a 00                	push   $0x0
  pushl $101
  1021c8:	6a 65                	push   $0x65
  jmp __alltraps
  1021ca:	e9 58 fc ff ff       	jmp    101e27 <__alltraps>

001021cf <vector102>:
.globl vector102
vector102:
  pushl $0
  1021cf:	6a 00                	push   $0x0
  pushl $102
  1021d1:	6a 66                	push   $0x66
  jmp __alltraps
  1021d3:	e9 4f fc ff ff       	jmp    101e27 <__alltraps>

001021d8 <vector103>:
.globl vector103
vector103:
  pushl $0
  1021d8:	6a 00                	push   $0x0
  pushl $103
  1021da:	6a 67                	push   $0x67
  jmp __alltraps
  1021dc:	e9 46 fc ff ff       	jmp    101e27 <__alltraps>

001021e1 <vector104>:
.globl vector104
vector104:
  pushl $0
  1021e1:	6a 00                	push   $0x0
  pushl $104
  1021e3:	6a 68                	push   $0x68
  jmp __alltraps
  1021e5:	e9 3d fc ff ff       	jmp    101e27 <__alltraps>

001021ea <vector105>:
.globl vector105
vector105:
  pushl $0
  1021ea:	6a 00                	push   $0x0
  pushl $105
  1021ec:	6a 69                	push   $0x69
  jmp __alltraps
  1021ee:	e9 34 fc ff ff       	jmp    101e27 <__alltraps>

001021f3 <vector106>:
.globl vector106
vector106:
  pushl $0
  1021f3:	6a 00                	push   $0x0
  pushl $106
  1021f5:	6a 6a                	push   $0x6a
  jmp __alltraps
  1021f7:	e9 2b fc ff ff       	jmp    101e27 <__alltraps>

001021fc <vector107>:
.globl vector107
vector107:
  pushl $0
  1021fc:	6a 00                	push   $0x0
  pushl $107
  1021fe:	6a 6b                	push   $0x6b
  jmp __alltraps
  102200:	e9 22 fc ff ff       	jmp    101e27 <__alltraps>

00102205 <vector108>:
.globl vector108
vector108:
  pushl $0
  102205:	6a 00                	push   $0x0
  pushl $108
  102207:	6a 6c                	push   $0x6c
  jmp __alltraps
  102209:	e9 19 fc ff ff       	jmp    101e27 <__alltraps>

0010220e <vector109>:
.globl vector109
vector109:
  pushl $0
  10220e:	6a 00                	push   $0x0
  pushl $109
  102210:	6a 6d                	push   $0x6d
  jmp __alltraps
  102212:	e9 10 fc ff ff       	jmp    101e27 <__alltraps>

00102217 <vector110>:
.globl vector110
vector110:
  pushl $0
  102217:	6a 00                	push   $0x0
  pushl $110
  102219:	6a 6e                	push   $0x6e
  jmp __alltraps
  10221b:	e9 07 fc ff ff       	jmp    101e27 <__alltraps>

00102220 <vector111>:
.globl vector111
vector111:
  pushl $0
  102220:	6a 00                	push   $0x0
  pushl $111
  102222:	6a 6f                	push   $0x6f
  jmp __alltraps
  102224:	e9 fe fb ff ff       	jmp    101e27 <__alltraps>

00102229 <vector112>:
.globl vector112
vector112:
  pushl $0
  102229:	6a 00                	push   $0x0
  pushl $112
  10222b:	6a 70                	push   $0x70
  jmp __alltraps
  10222d:	e9 f5 fb ff ff       	jmp    101e27 <__alltraps>

00102232 <vector113>:
.globl vector113
vector113:
  pushl $0
  102232:	6a 00                	push   $0x0
  pushl $113
  102234:	6a 71                	push   $0x71
  jmp __alltraps
  102236:	e9 ec fb ff ff       	jmp    101e27 <__alltraps>

0010223b <vector114>:
.globl vector114
vector114:
  pushl $0
  10223b:	6a 00                	push   $0x0
  pushl $114
  10223d:	6a 72                	push   $0x72
  jmp __alltraps
  10223f:	e9 e3 fb ff ff       	jmp    101e27 <__alltraps>

00102244 <vector115>:
.globl vector115
vector115:
  pushl $0
  102244:	6a 00                	push   $0x0
  pushl $115
  102246:	6a 73                	push   $0x73
  jmp __alltraps
  102248:	e9 da fb ff ff       	jmp    101e27 <__alltraps>

0010224d <vector116>:
.globl vector116
vector116:
  pushl $0
  10224d:	6a 00                	push   $0x0
  pushl $116
  10224f:	6a 74                	push   $0x74
  jmp __alltraps
  102251:	e9 d1 fb ff ff       	jmp    101e27 <__alltraps>

00102256 <vector117>:
.globl vector117
vector117:
  pushl $0
  102256:	6a 00                	push   $0x0
  pushl $117
  102258:	6a 75                	push   $0x75
  jmp __alltraps
  10225a:	e9 c8 fb ff ff       	jmp    101e27 <__alltraps>

0010225f <vector118>:
.globl vector118
vector118:
  pushl $0
  10225f:	6a 00                	push   $0x0
  pushl $118
  102261:	6a 76                	push   $0x76
  jmp __alltraps
  102263:	e9 bf fb ff ff       	jmp    101e27 <__alltraps>

00102268 <vector119>:
.globl vector119
vector119:
  pushl $0
  102268:	6a 00                	push   $0x0
  pushl $119
  10226a:	6a 77                	push   $0x77
  jmp __alltraps
  10226c:	e9 b6 fb ff ff       	jmp    101e27 <__alltraps>

00102271 <vector120>:
.globl vector120
vector120:
  pushl $0
  102271:	6a 00                	push   $0x0
  pushl $120
  102273:	6a 78                	push   $0x78
  jmp __alltraps
  102275:	e9 ad fb ff ff       	jmp    101e27 <__alltraps>

0010227a <vector121>:
.globl vector121
vector121:
  pushl $0
  10227a:	6a 00                	push   $0x0
  pushl $121
  10227c:	6a 79                	push   $0x79
  jmp __alltraps
  10227e:	e9 a4 fb ff ff       	jmp    101e27 <__alltraps>

00102283 <vector122>:
.globl vector122
vector122:
  pushl $0
  102283:	6a 00                	push   $0x0
  pushl $122
  102285:	6a 7a                	push   $0x7a
  jmp __alltraps
  102287:	e9 9b fb ff ff       	jmp    101e27 <__alltraps>

0010228c <vector123>:
.globl vector123
vector123:
  pushl $0
  10228c:	6a 00                	push   $0x0
  pushl $123
  10228e:	6a 7b                	push   $0x7b
  jmp __alltraps
  102290:	e9 92 fb ff ff       	jmp    101e27 <__alltraps>

00102295 <vector124>:
.globl vector124
vector124:
  pushl $0
  102295:	6a 00                	push   $0x0
  pushl $124
  102297:	6a 7c                	push   $0x7c
  jmp __alltraps
  102299:	e9 89 fb ff ff       	jmp    101e27 <__alltraps>

0010229e <vector125>:
.globl vector125
vector125:
  pushl $0
  10229e:	6a 00                	push   $0x0
  pushl $125
  1022a0:	6a 7d                	push   $0x7d
  jmp __alltraps
  1022a2:	e9 80 fb ff ff       	jmp    101e27 <__alltraps>

001022a7 <vector126>:
.globl vector126
vector126:
  pushl $0
  1022a7:	6a 00                	push   $0x0
  pushl $126
  1022a9:	6a 7e                	push   $0x7e
  jmp __alltraps
  1022ab:	e9 77 fb ff ff       	jmp    101e27 <__alltraps>

001022b0 <vector127>:
.globl vector127
vector127:
  pushl $0
  1022b0:	6a 00                	push   $0x0
  pushl $127
  1022b2:	6a 7f                	push   $0x7f
  jmp __alltraps
  1022b4:	e9 6e fb ff ff       	jmp    101e27 <__alltraps>

001022b9 <vector128>:
.globl vector128
vector128:
  pushl $0
  1022b9:	6a 00                	push   $0x0
  pushl $128
  1022bb:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1022c0:	e9 62 fb ff ff       	jmp    101e27 <__alltraps>

001022c5 <vector129>:
.globl vector129
vector129:
  pushl $0
  1022c5:	6a 00                	push   $0x0
  pushl $129
  1022c7:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1022cc:	e9 56 fb ff ff       	jmp    101e27 <__alltraps>

001022d1 <vector130>:
.globl vector130
vector130:
  pushl $0
  1022d1:	6a 00                	push   $0x0
  pushl $130
  1022d3:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1022d8:	e9 4a fb ff ff       	jmp    101e27 <__alltraps>

001022dd <vector131>:
.globl vector131
vector131:
  pushl $0
  1022dd:	6a 00                	push   $0x0
  pushl $131
  1022df:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1022e4:	e9 3e fb ff ff       	jmp    101e27 <__alltraps>

001022e9 <vector132>:
.globl vector132
vector132:
  pushl $0
  1022e9:	6a 00                	push   $0x0
  pushl $132
  1022eb:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1022f0:	e9 32 fb ff ff       	jmp    101e27 <__alltraps>

001022f5 <vector133>:
.globl vector133
vector133:
  pushl $0
  1022f5:	6a 00                	push   $0x0
  pushl $133
  1022f7:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1022fc:	e9 26 fb ff ff       	jmp    101e27 <__alltraps>

00102301 <vector134>:
.globl vector134
vector134:
  pushl $0
  102301:	6a 00                	push   $0x0
  pushl $134
  102303:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102308:	e9 1a fb ff ff       	jmp    101e27 <__alltraps>

0010230d <vector135>:
.globl vector135
vector135:
  pushl $0
  10230d:	6a 00                	push   $0x0
  pushl $135
  10230f:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102314:	e9 0e fb ff ff       	jmp    101e27 <__alltraps>

00102319 <vector136>:
.globl vector136
vector136:
  pushl $0
  102319:	6a 00                	push   $0x0
  pushl $136
  10231b:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102320:	e9 02 fb ff ff       	jmp    101e27 <__alltraps>

00102325 <vector137>:
.globl vector137
vector137:
  pushl $0
  102325:	6a 00                	push   $0x0
  pushl $137
  102327:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  10232c:	e9 f6 fa ff ff       	jmp    101e27 <__alltraps>

00102331 <vector138>:
.globl vector138
vector138:
  pushl $0
  102331:	6a 00                	push   $0x0
  pushl $138
  102333:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102338:	e9 ea fa ff ff       	jmp    101e27 <__alltraps>

0010233d <vector139>:
.globl vector139
vector139:
  pushl $0
  10233d:	6a 00                	push   $0x0
  pushl $139
  10233f:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102344:	e9 de fa ff ff       	jmp    101e27 <__alltraps>

00102349 <vector140>:
.globl vector140
vector140:
  pushl $0
  102349:	6a 00                	push   $0x0
  pushl $140
  10234b:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102350:	e9 d2 fa ff ff       	jmp    101e27 <__alltraps>

00102355 <vector141>:
.globl vector141
vector141:
  pushl $0
  102355:	6a 00                	push   $0x0
  pushl $141
  102357:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10235c:	e9 c6 fa ff ff       	jmp    101e27 <__alltraps>

00102361 <vector142>:
.globl vector142
vector142:
  pushl $0
  102361:	6a 00                	push   $0x0
  pushl $142
  102363:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102368:	e9 ba fa ff ff       	jmp    101e27 <__alltraps>

0010236d <vector143>:
.globl vector143
vector143:
  pushl $0
  10236d:	6a 00                	push   $0x0
  pushl $143
  10236f:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102374:	e9 ae fa ff ff       	jmp    101e27 <__alltraps>

00102379 <vector144>:
.globl vector144
vector144:
  pushl $0
  102379:	6a 00                	push   $0x0
  pushl $144
  10237b:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102380:	e9 a2 fa ff ff       	jmp    101e27 <__alltraps>

00102385 <vector145>:
.globl vector145
vector145:
  pushl $0
  102385:	6a 00                	push   $0x0
  pushl $145
  102387:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  10238c:	e9 96 fa ff ff       	jmp    101e27 <__alltraps>

00102391 <vector146>:
.globl vector146
vector146:
  pushl $0
  102391:	6a 00                	push   $0x0
  pushl $146
  102393:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102398:	e9 8a fa ff ff       	jmp    101e27 <__alltraps>

0010239d <vector147>:
.globl vector147
vector147:
  pushl $0
  10239d:	6a 00                	push   $0x0
  pushl $147
  10239f:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1023a4:	e9 7e fa ff ff       	jmp    101e27 <__alltraps>

001023a9 <vector148>:
.globl vector148
vector148:
  pushl $0
  1023a9:	6a 00                	push   $0x0
  pushl $148
  1023ab:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1023b0:	e9 72 fa ff ff       	jmp    101e27 <__alltraps>

001023b5 <vector149>:
.globl vector149
vector149:
  pushl $0
  1023b5:	6a 00                	push   $0x0
  pushl $149
  1023b7:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1023bc:	e9 66 fa ff ff       	jmp    101e27 <__alltraps>

001023c1 <vector150>:
.globl vector150
vector150:
  pushl $0
  1023c1:	6a 00                	push   $0x0
  pushl $150
  1023c3:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1023c8:	e9 5a fa ff ff       	jmp    101e27 <__alltraps>

001023cd <vector151>:
.globl vector151
vector151:
  pushl $0
  1023cd:	6a 00                	push   $0x0
  pushl $151
  1023cf:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1023d4:	e9 4e fa ff ff       	jmp    101e27 <__alltraps>

001023d9 <vector152>:
.globl vector152
vector152:
  pushl $0
  1023d9:	6a 00                	push   $0x0
  pushl $152
  1023db:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1023e0:	e9 42 fa ff ff       	jmp    101e27 <__alltraps>

001023e5 <vector153>:
.globl vector153
vector153:
  pushl $0
  1023e5:	6a 00                	push   $0x0
  pushl $153
  1023e7:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1023ec:	e9 36 fa ff ff       	jmp    101e27 <__alltraps>

001023f1 <vector154>:
.globl vector154
vector154:
  pushl $0
  1023f1:	6a 00                	push   $0x0
  pushl $154
  1023f3:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1023f8:	e9 2a fa ff ff       	jmp    101e27 <__alltraps>

001023fd <vector155>:
.globl vector155
vector155:
  pushl $0
  1023fd:	6a 00                	push   $0x0
  pushl $155
  1023ff:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102404:	e9 1e fa ff ff       	jmp    101e27 <__alltraps>

00102409 <vector156>:
.globl vector156
vector156:
  pushl $0
  102409:	6a 00                	push   $0x0
  pushl $156
  10240b:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102410:	e9 12 fa ff ff       	jmp    101e27 <__alltraps>

00102415 <vector157>:
.globl vector157
vector157:
  pushl $0
  102415:	6a 00                	push   $0x0
  pushl $157
  102417:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  10241c:	e9 06 fa ff ff       	jmp    101e27 <__alltraps>

00102421 <vector158>:
.globl vector158
vector158:
  pushl $0
  102421:	6a 00                	push   $0x0
  pushl $158
  102423:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102428:	e9 fa f9 ff ff       	jmp    101e27 <__alltraps>

0010242d <vector159>:
.globl vector159
vector159:
  pushl $0
  10242d:	6a 00                	push   $0x0
  pushl $159
  10242f:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102434:	e9 ee f9 ff ff       	jmp    101e27 <__alltraps>

00102439 <vector160>:
.globl vector160
vector160:
  pushl $0
  102439:	6a 00                	push   $0x0
  pushl $160
  10243b:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102440:	e9 e2 f9 ff ff       	jmp    101e27 <__alltraps>

00102445 <vector161>:
.globl vector161
vector161:
  pushl $0
  102445:	6a 00                	push   $0x0
  pushl $161
  102447:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10244c:	e9 d6 f9 ff ff       	jmp    101e27 <__alltraps>

00102451 <vector162>:
.globl vector162
vector162:
  pushl $0
  102451:	6a 00                	push   $0x0
  pushl $162
  102453:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102458:	e9 ca f9 ff ff       	jmp    101e27 <__alltraps>

0010245d <vector163>:
.globl vector163
vector163:
  pushl $0
  10245d:	6a 00                	push   $0x0
  pushl $163
  10245f:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102464:	e9 be f9 ff ff       	jmp    101e27 <__alltraps>

00102469 <vector164>:
.globl vector164
vector164:
  pushl $0
  102469:	6a 00                	push   $0x0
  pushl $164
  10246b:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102470:	e9 b2 f9 ff ff       	jmp    101e27 <__alltraps>

00102475 <vector165>:
.globl vector165
vector165:
  pushl $0
  102475:	6a 00                	push   $0x0
  pushl $165
  102477:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  10247c:	e9 a6 f9 ff ff       	jmp    101e27 <__alltraps>

00102481 <vector166>:
.globl vector166
vector166:
  pushl $0
  102481:	6a 00                	push   $0x0
  pushl $166
  102483:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102488:	e9 9a f9 ff ff       	jmp    101e27 <__alltraps>

0010248d <vector167>:
.globl vector167
vector167:
  pushl $0
  10248d:	6a 00                	push   $0x0
  pushl $167
  10248f:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102494:	e9 8e f9 ff ff       	jmp    101e27 <__alltraps>

00102499 <vector168>:
.globl vector168
vector168:
  pushl $0
  102499:	6a 00                	push   $0x0
  pushl $168
  10249b:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1024a0:	e9 82 f9 ff ff       	jmp    101e27 <__alltraps>

001024a5 <vector169>:
.globl vector169
vector169:
  pushl $0
  1024a5:	6a 00                	push   $0x0
  pushl $169
  1024a7:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1024ac:	e9 76 f9 ff ff       	jmp    101e27 <__alltraps>

001024b1 <vector170>:
.globl vector170
vector170:
  pushl $0
  1024b1:	6a 00                	push   $0x0
  pushl $170
  1024b3:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1024b8:	e9 6a f9 ff ff       	jmp    101e27 <__alltraps>

001024bd <vector171>:
.globl vector171
vector171:
  pushl $0
  1024bd:	6a 00                	push   $0x0
  pushl $171
  1024bf:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1024c4:	e9 5e f9 ff ff       	jmp    101e27 <__alltraps>

001024c9 <vector172>:
.globl vector172
vector172:
  pushl $0
  1024c9:	6a 00                	push   $0x0
  pushl $172
  1024cb:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1024d0:	e9 52 f9 ff ff       	jmp    101e27 <__alltraps>

001024d5 <vector173>:
.globl vector173
vector173:
  pushl $0
  1024d5:	6a 00                	push   $0x0
  pushl $173
  1024d7:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1024dc:	e9 46 f9 ff ff       	jmp    101e27 <__alltraps>

001024e1 <vector174>:
.globl vector174
vector174:
  pushl $0
  1024e1:	6a 00                	push   $0x0
  pushl $174
  1024e3:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1024e8:	e9 3a f9 ff ff       	jmp    101e27 <__alltraps>

001024ed <vector175>:
.globl vector175
vector175:
  pushl $0
  1024ed:	6a 00                	push   $0x0
  pushl $175
  1024ef:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1024f4:	e9 2e f9 ff ff       	jmp    101e27 <__alltraps>

001024f9 <vector176>:
.globl vector176
vector176:
  pushl $0
  1024f9:	6a 00                	push   $0x0
  pushl $176
  1024fb:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102500:	e9 22 f9 ff ff       	jmp    101e27 <__alltraps>

00102505 <vector177>:
.globl vector177
vector177:
  pushl $0
  102505:	6a 00                	push   $0x0
  pushl $177
  102507:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  10250c:	e9 16 f9 ff ff       	jmp    101e27 <__alltraps>

00102511 <vector178>:
.globl vector178
vector178:
  pushl $0
  102511:	6a 00                	push   $0x0
  pushl $178
  102513:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102518:	e9 0a f9 ff ff       	jmp    101e27 <__alltraps>

0010251d <vector179>:
.globl vector179
vector179:
  pushl $0
  10251d:	6a 00                	push   $0x0
  pushl $179
  10251f:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102524:	e9 fe f8 ff ff       	jmp    101e27 <__alltraps>

00102529 <vector180>:
.globl vector180
vector180:
  pushl $0
  102529:	6a 00                	push   $0x0
  pushl $180
  10252b:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102530:	e9 f2 f8 ff ff       	jmp    101e27 <__alltraps>

00102535 <vector181>:
.globl vector181
vector181:
  pushl $0
  102535:	6a 00                	push   $0x0
  pushl $181
  102537:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10253c:	e9 e6 f8 ff ff       	jmp    101e27 <__alltraps>

00102541 <vector182>:
.globl vector182
vector182:
  pushl $0
  102541:	6a 00                	push   $0x0
  pushl $182
  102543:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102548:	e9 da f8 ff ff       	jmp    101e27 <__alltraps>

0010254d <vector183>:
.globl vector183
vector183:
  pushl $0
  10254d:	6a 00                	push   $0x0
  pushl $183
  10254f:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102554:	e9 ce f8 ff ff       	jmp    101e27 <__alltraps>

00102559 <vector184>:
.globl vector184
vector184:
  pushl $0
  102559:	6a 00                	push   $0x0
  pushl $184
  10255b:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102560:	e9 c2 f8 ff ff       	jmp    101e27 <__alltraps>

00102565 <vector185>:
.globl vector185
vector185:
  pushl $0
  102565:	6a 00                	push   $0x0
  pushl $185
  102567:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10256c:	e9 b6 f8 ff ff       	jmp    101e27 <__alltraps>

00102571 <vector186>:
.globl vector186
vector186:
  pushl $0
  102571:	6a 00                	push   $0x0
  pushl $186
  102573:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102578:	e9 aa f8 ff ff       	jmp    101e27 <__alltraps>

0010257d <vector187>:
.globl vector187
vector187:
  pushl $0
  10257d:	6a 00                	push   $0x0
  pushl $187
  10257f:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102584:	e9 9e f8 ff ff       	jmp    101e27 <__alltraps>

00102589 <vector188>:
.globl vector188
vector188:
  pushl $0
  102589:	6a 00                	push   $0x0
  pushl $188
  10258b:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102590:	e9 92 f8 ff ff       	jmp    101e27 <__alltraps>

00102595 <vector189>:
.globl vector189
vector189:
  pushl $0
  102595:	6a 00                	push   $0x0
  pushl $189
  102597:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  10259c:	e9 86 f8 ff ff       	jmp    101e27 <__alltraps>

001025a1 <vector190>:
.globl vector190
vector190:
  pushl $0
  1025a1:	6a 00                	push   $0x0
  pushl $190
  1025a3:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1025a8:	e9 7a f8 ff ff       	jmp    101e27 <__alltraps>

001025ad <vector191>:
.globl vector191
vector191:
  pushl $0
  1025ad:	6a 00                	push   $0x0
  pushl $191
  1025af:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1025b4:	e9 6e f8 ff ff       	jmp    101e27 <__alltraps>

001025b9 <vector192>:
.globl vector192
vector192:
  pushl $0
  1025b9:	6a 00                	push   $0x0
  pushl $192
  1025bb:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1025c0:	e9 62 f8 ff ff       	jmp    101e27 <__alltraps>

001025c5 <vector193>:
.globl vector193
vector193:
  pushl $0
  1025c5:	6a 00                	push   $0x0
  pushl $193
  1025c7:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1025cc:	e9 56 f8 ff ff       	jmp    101e27 <__alltraps>

001025d1 <vector194>:
.globl vector194
vector194:
  pushl $0
  1025d1:	6a 00                	push   $0x0
  pushl $194
  1025d3:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1025d8:	e9 4a f8 ff ff       	jmp    101e27 <__alltraps>

001025dd <vector195>:
.globl vector195
vector195:
  pushl $0
  1025dd:	6a 00                	push   $0x0
  pushl $195
  1025df:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1025e4:	e9 3e f8 ff ff       	jmp    101e27 <__alltraps>

001025e9 <vector196>:
.globl vector196
vector196:
  pushl $0
  1025e9:	6a 00                	push   $0x0
  pushl $196
  1025eb:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1025f0:	e9 32 f8 ff ff       	jmp    101e27 <__alltraps>

001025f5 <vector197>:
.globl vector197
vector197:
  pushl $0
  1025f5:	6a 00                	push   $0x0
  pushl $197
  1025f7:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1025fc:	e9 26 f8 ff ff       	jmp    101e27 <__alltraps>

00102601 <vector198>:
.globl vector198
vector198:
  pushl $0
  102601:	6a 00                	push   $0x0
  pushl $198
  102603:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102608:	e9 1a f8 ff ff       	jmp    101e27 <__alltraps>

0010260d <vector199>:
.globl vector199
vector199:
  pushl $0
  10260d:	6a 00                	push   $0x0
  pushl $199
  10260f:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102614:	e9 0e f8 ff ff       	jmp    101e27 <__alltraps>

00102619 <vector200>:
.globl vector200
vector200:
  pushl $0
  102619:	6a 00                	push   $0x0
  pushl $200
  10261b:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102620:	e9 02 f8 ff ff       	jmp    101e27 <__alltraps>

00102625 <vector201>:
.globl vector201
vector201:
  pushl $0
  102625:	6a 00                	push   $0x0
  pushl $201
  102627:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  10262c:	e9 f6 f7 ff ff       	jmp    101e27 <__alltraps>

00102631 <vector202>:
.globl vector202
vector202:
  pushl $0
  102631:	6a 00                	push   $0x0
  pushl $202
  102633:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102638:	e9 ea f7 ff ff       	jmp    101e27 <__alltraps>

0010263d <vector203>:
.globl vector203
vector203:
  pushl $0
  10263d:	6a 00                	push   $0x0
  pushl $203
  10263f:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102644:	e9 de f7 ff ff       	jmp    101e27 <__alltraps>

00102649 <vector204>:
.globl vector204
vector204:
  pushl $0
  102649:	6a 00                	push   $0x0
  pushl $204
  10264b:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102650:	e9 d2 f7 ff ff       	jmp    101e27 <__alltraps>

00102655 <vector205>:
.globl vector205
vector205:
  pushl $0
  102655:	6a 00                	push   $0x0
  pushl $205
  102657:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10265c:	e9 c6 f7 ff ff       	jmp    101e27 <__alltraps>

00102661 <vector206>:
.globl vector206
vector206:
  pushl $0
  102661:	6a 00                	push   $0x0
  pushl $206
  102663:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102668:	e9 ba f7 ff ff       	jmp    101e27 <__alltraps>

0010266d <vector207>:
.globl vector207
vector207:
  pushl $0
  10266d:	6a 00                	push   $0x0
  pushl $207
  10266f:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102674:	e9 ae f7 ff ff       	jmp    101e27 <__alltraps>

00102679 <vector208>:
.globl vector208
vector208:
  pushl $0
  102679:	6a 00                	push   $0x0
  pushl $208
  10267b:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102680:	e9 a2 f7 ff ff       	jmp    101e27 <__alltraps>

00102685 <vector209>:
.globl vector209
vector209:
  pushl $0
  102685:	6a 00                	push   $0x0
  pushl $209
  102687:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  10268c:	e9 96 f7 ff ff       	jmp    101e27 <__alltraps>

00102691 <vector210>:
.globl vector210
vector210:
  pushl $0
  102691:	6a 00                	push   $0x0
  pushl $210
  102693:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102698:	e9 8a f7 ff ff       	jmp    101e27 <__alltraps>

0010269d <vector211>:
.globl vector211
vector211:
  pushl $0
  10269d:	6a 00                	push   $0x0
  pushl $211
  10269f:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1026a4:	e9 7e f7 ff ff       	jmp    101e27 <__alltraps>

001026a9 <vector212>:
.globl vector212
vector212:
  pushl $0
  1026a9:	6a 00                	push   $0x0
  pushl $212
  1026ab:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1026b0:	e9 72 f7 ff ff       	jmp    101e27 <__alltraps>

001026b5 <vector213>:
.globl vector213
vector213:
  pushl $0
  1026b5:	6a 00                	push   $0x0
  pushl $213
  1026b7:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1026bc:	e9 66 f7 ff ff       	jmp    101e27 <__alltraps>

001026c1 <vector214>:
.globl vector214
vector214:
  pushl $0
  1026c1:	6a 00                	push   $0x0
  pushl $214
  1026c3:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1026c8:	e9 5a f7 ff ff       	jmp    101e27 <__alltraps>

001026cd <vector215>:
.globl vector215
vector215:
  pushl $0
  1026cd:	6a 00                	push   $0x0
  pushl $215
  1026cf:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1026d4:	e9 4e f7 ff ff       	jmp    101e27 <__alltraps>

001026d9 <vector216>:
.globl vector216
vector216:
  pushl $0
  1026d9:	6a 00                	push   $0x0
  pushl $216
  1026db:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1026e0:	e9 42 f7 ff ff       	jmp    101e27 <__alltraps>

001026e5 <vector217>:
.globl vector217
vector217:
  pushl $0
  1026e5:	6a 00                	push   $0x0
  pushl $217
  1026e7:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1026ec:	e9 36 f7 ff ff       	jmp    101e27 <__alltraps>

001026f1 <vector218>:
.globl vector218
vector218:
  pushl $0
  1026f1:	6a 00                	push   $0x0
  pushl $218
  1026f3:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1026f8:	e9 2a f7 ff ff       	jmp    101e27 <__alltraps>

001026fd <vector219>:
.globl vector219
vector219:
  pushl $0
  1026fd:	6a 00                	push   $0x0
  pushl $219
  1026ff:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102704:	e9 1e f7 ff ff       	jmp    101e27 <__alltraps>

00102709 <vector220>:
.globl vector220
vector220:
  pushl $0
  102709:	6a 00                	push   $0x0
  pushl $220
  10270b:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102710:	e9 12 f7 ff ff       	jmp    101e27 <__alltraps>

00102715 <vector221>:
.globl vector221
vector221:
  pushl $0
  102715:	6a 00                	push   $0x0
  pushl $221
  102717:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  10271c:	e9 06 f7 ff ff       	jmp    101e27 <__alltraps>

00102721 <vector222>:
.globl vector222
vector222:
  pushl $0
  102721:	6a 00                	push   $0x0
  pushl $222
  102723:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102728:	e9 fa f6 ff ff       	jmp    101e27 <__alltraps>

0010272d <vector223>:
.globl vector223
vector223:
  pushl $0
  10272d:	6a 00                	push   $0x0
  pushl $223
  10272f:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102734:	e9 ee f6 ff ff       	jmp    101e27 <__alltraps>

00102739 <vector224>:
.globl vector224
vector224:
  pushl $0
  102739:	6a 00                	push   $0x0
  pushl $224
  10273b:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102740:	e9 e2 f6 ff ff       	jmp    101e27 <__alltraps>

00102745 <vector225>:
.globl vector225
vector225:
  pushl $0
  102745:	6a 00                	push   $0x0
  pushl $225
  102747:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10274c:	e9 d6 f6 ff ff       	jmp    101e27 <__alltraps>

00102751 <vector226>:
.globl vector226
vector226:
  pushl $0
  102751:	6a 00                	push   $0x0
  pushl $226
  102753:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102758:	e9 ca f6 ff ff       	jmp    101e27 <__alltraps>

0010275d <vector227>:
.globl vector227
vector227:
  pushl $0
  10275d:	6a 00                	push   $0x0
  pushl $227
  10275f:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102764:	e9 be f6 ff ff       	jmp    101e27 <__alltraps>

00102769 <vector228>:
.globl vector228
vector228:
  pushl $0
  102769:	6a 00                	push   $0x0
  pushl $228
  10276b:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102770:	e9 b2 f6 ff ff       	jmp    101e27 <__alltraps>

00102775 <vector229>:
.globl vector229
vector229:
  pushl $0
  102775:	6a 00                	push   $0x0
  pushl $229
  102777:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  10277c:	e9 a6 f6 ff ff       	jmp    101e27 <__alltraps>

00102781 <vector230>:
.globl vector230
vector230:
  pushl $0
  102781:	6a 00                	push   $0x0
  pushl $230
  102783:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102788:	e9 9a f6 ff ff       	jmp    101e27 <__alltraps>

0010278d <vector231>:
.globl vector231
vector231:
  pushl $0
  10278d:	6a 00                	push   $0x0
  pushl $231
  10278f:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102794:	e9 8e f6 ff ff       	jmp    101e27 <__alltraps>

00102799 <vector232>:
.globl vector232
vector232:
  pushl $0
  102799:	6a 00                	push   $0x0
  pushl $232
  10279b:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1027a0:	e9 82 f6 ff ff       	jmp    101e27 <__alltraps>

001027a5 <vector233>:
.globl vector233
vector233:
  pushl $0
  1027a5:	6a 00                	push   $0x0
  pushl $233
  1027a7:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1027ac:	e9 76 f6 ff ff       	jmp    101e27 <__alltraps>

001027b1 <vector234>:
.globl vector234
vector234:
  pushl $0
  1027b1:	6a 00                	push   $0x0
  pushl $234
  1027b3:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1027b8:	e9 6a f6 ff ff       	jmp    101e27 <__alltraps>

001027bd <vector235>:
.globl vector235
vector235:
  pushl $0
  1027bd:	6a 00                	push   $0x0
  pushl $235
  1027bf:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1027c4:	e9 5e f6 ff ff       	jmp    101e27 <__alltraps>

001027c9 <vector236>:
.globl vector236
vector236:
  pushl $0
  1027c9:	6a 00                	push   $0x0
  pushl $236
  1027cb:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1027d0:	e9 52 f6 ff ff       	jmp    101e27 <__alltraps>

001027d5 <vector237>:
.globl vector237
vector237:
  pushl $0
  1027d5:	6a 00                	push   $0x0
  pushl $237
  1027d7:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1027dc:	e9 46 f6 ff ff       	jmp    101e27 <__alltraps>

001027e1 <vector238>:
.globl vector238
vector238:
  pushl $0
  1027e1:	6a 00                	push   $0x0
  pushl $238
  1027e3:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1027e8:	e9 3a f6 ff ff       	jmp    101e27 <__alltraps>

001027ed <vector239>:
.globl vector239
vector239:
  pushl $0
  1027ed:	6a 00                	push   $0x0
  pushl $239
  1027ef:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1027f4:	e9 2e f6 ff ff       	jmp    101e27 <__alltraps>

001027f9 <vector240>:
.globl vector240
vector240:
  pushl $0
  1027f9:	6a 00                	push   $0x0
  pushl $240
  1027fb:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102800:	e9 22 f6 ff ff       	jmp    101e27 <__alltraps>

00102805 <vector241>:
.globl vector241
vector241:
  pushl $0
  102805:	6a 00                	push   $0x0
  pushl $241
  102807:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  10280c:	e9 16 f6 ff ff       	jmp    101e27 <__alltraps>

00102811 <vector242>:
.globl vector242
vector242:
  pushl $0
  102811:	6a 00                	push   $0x0
  pushl $242
  102813:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102818:	e9 0a f6 ff ff       	jmp    101e27 <__alltraps>

0010281d <vector243>:
.globl vector243
vector243:
  pushl $0
  10281d:	6a 00                	push   $0x0
  pushl $243
  10281f:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102824:	e9 fe f5 ff ff       	jmp    101e27 <__alltraps>

00102829 <vector244>:
.globl vector244
vector244:
  pushl $0
  102829:	6a 00                	push   $0x0
  pushl $244
  10282b:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102830:	e9 f2 f5 ff ff       	jmp    101e27 <__alltraps>

00102835 <vector245>:
.globl vector245
vector245:
  pushl $0
  102835:	6a 00                	push   $0x0
  pushl $245
  102837:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  10283c:	e9 e6 f5 ff ff       	jmp    101e27 <__alltraps>

00102841 <vector246>:
.globl vector246
vector246:
  pushl $0
  102841:	6a 00                	push   $0x0
  pushl $246
  102843:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102848:	e9 da f5 ff ff       	jmp    101e27 <__alltraps>

0010284d <vector247>:
.globl vector247
vector247:
  pushl $0
  10284d:	6a 00                	push   $0x0
  pushl $247
  10284f:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102854:	e9 ce f5 ff ff       	jmp    101e27 <__alltraps>

00102859 <vector248>:
.globl vector248
vector248:
  pushl $0
  102859:	6a 00                	push   $0x0
  pushl $248
  10285b:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102860:	e9 c2 f5 ff ff       	jmp    101e27 <__alltraps>

00102865 <vector249>:
.globl vector249
vector249:
  pushl $0
  102865:	6a 00                	push   $0x0
  pushl $249
  102867:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  10286c:	e9 b6 f5 ff ff       	jmp    101e27 <__alltraps>

00102871 <vector250>:
.globl vector250
vector250:
  pushl $0
  102871:	6a 00                	push   $0x0
  pushl $250
  102873:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102878:	e9 aa f5 ff ff       	jmp    101e27 <__alltraps>

0010287d <vector251>:
.globl vector251
vector251:
  pushl $0
  10287d:	6a 00                	push   $0x0
  pushl $251
  10287f:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102884:	e9 9e f5 ff ff       	jmp    101e27 <__alltraps>

00102889 <vector252>:
.globl vector252
vector252:
  pushl $0
  102889:	6a 00                	push   $0x0
  pushl $252
  10288b:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102890:	e9 92 f5 ff ff       	jmp    101e27 <__alltraps>

00102895 <vector253>:
.globl vector253
vector253:
  pushl $0
  102895:	6a 00                	push   $0x0
  pushl $253
  102897:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  10289c:	e9 86 f5 ff ff       	jmp    101e27 <__alltraps>

001028a1 <vector254>:
.globl vector254
vector254:
  pushl $0
  1028a1:	6a 00                	push   $0x0
  pushl $254
  1028a3:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1028a8:	e9 7a f5 ff ff       	jmp    101e27 <__alltraps>

001028ad <vector255>:
.globl vector255
vector255:
  pushl $0
  1028ad:	6a 00                	push   $0x0
  pushl $255
  1028af:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1028b4:	e9 6e f5 ff ff       	jmp    101e27 <__alltraps>

001028b9 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  1028b9:	55                   	push   %ebp
  1028ba:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1028bc:	8b 55 08             	mov    0x8(%ebp),%edx
  1028bf:	a1 64 89 11 00       	mov    0x118964,%eax
  1028c4:	29 c2                	sub    %eax,%edx
  1028c6:	89 d0                	mov    %edx,%eax
  1028c8:	c1 f8 02             	sar    $0x2,%eax
  1028cb:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1028d1:	5d                   	pop    %ebp
  1028d2:	c3                   	ret    

001028d3 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  1028d3:	55                   	push   %ebp
  1028d4:	89 e5                	mov    %esp,%ebp
  1028d6:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1028d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1028dc:	89 04 24             	mov    %eax,(%esp)
  1028df:	e8 d5 ff ff ff       	call   1028b9 <page2ppn>
  1028e4:	c1 e0 0c             	shl    $0xc,%eax
}
  1028e7:	c9                   	leave  
  1028e8:	c3                   	ret    

001028e9 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  1028e9:	55                   	push   %ebp
  1028ea:	89 e5                	mov    %esp,%ebp
    return page->ref;
  1028ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1028ef:	8b 00                	mov    (%eax),%eax
}
  1028f1:	5d                   	pop    %ebp
  1028f2:	c3                   	ret    

001028f3 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  1028f3:	55                   	push   %ebp
  1028f4:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  1028f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1028f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1028fc:	89 10                	mov    %edx,(%eax)
}
  1028fe:	5d                   	pop    %ebp
  1028ff:	c3                   	ret    

00102900 <default_init>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

// 初始化，不涉及探测可用空间的任务，只是准备好一个空的数据结构
static void
default_init(void) {
  102900:	55                   	push   %ebp
  102901:	89 e5                	mov    %esp,%ebp
  102903:	83 ec 10             	sub    $0x10,%esp
  102906:	c7 45 fc 50 89 11 00 	movl   $0x118950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  10290d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102910:	8b 55 fc             	mov    -0x4(%ebp),%edx
  102913:	89 50 04             	mov    %edx,0x4(%eax)
  102916:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102919:	8b 50 04             	mov    0x4(%eax),%edx
  10291c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10291f:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  102921:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  102928:	00 00 00 
}
  10292b:	c9                   	leave  
  10292c:	c3                   	ret    

0010292d <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  10292d:	55                   	push   %ebp
  10292e:	89 e5                	mov    %esp,%ebp
  102930:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  102933:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102937:	75 24                	jne    10295d <default_init_memmap+0x30>
  102939:	c7 44 24 0c 50 65 10 	movl   $0x106550,0xc(%esp)
  102940:	00 
  102941:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  102948:	00 
  102949:	c7 44 24 04 47 00 00 	movl   $0x47,0x4(%esp)
  102950:	00 
  102951:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  102958:	e8 7a e3 ff ff       	call   100cd7 <__panic>
    struct Page *p = base;
  10295d:	8b 45 08             	mov    0x8(%ebp),%eax
  102960:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  102963:	e9 96 00 00 00       	jmp    1029fe <default_init_memmap+0xd1>
		// 初始化这一块的每一页
        assert(PageReserved(p));   // 之前已经设为了reserved
  102968:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10296b:	83 c0 04             	add    $0x4,%eax
  10296e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102975:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102978:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10297b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10297e:	0f a3 10             	bt     %edx,(%eax)
  102981:	19 c0                	sbb    %eax,%eax
  102983:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  102986:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10298a:	0f 95 c0             	setne  %al
  10298d:	0f b6 c0             	movzbl %al,%eax
  102990:	85 c0                	test   %eax,%eax
  102992:	75 24                	jne    1029b8 <default_init_memmap+0x8b>
  102994:	c7 44 24 0c 81 65 10 	movl   $0x106581,0xc(%esp)
  10299b:	00 
  10299c:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  1029a3:	00 
  1029a4:	c7 44 24 04 4b 00 00 	movl   $0x4b,0x4(%esp)
  1029ab:	00 
  1029ac:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  1029b3:	e8 1f e3 ff ff       	call   100cd7 <__panic>
        p->flags = p->property = 0;
  1029b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029bb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  1029c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029c5:	8b 50 08             	mov    0x8(%eax),%edx
  1029c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029cb:	89 50 04             	mov    %edx,0x4(%eax)
		SetPageProperty(p);   // 把该页设置为valid
  1029ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029d1:	83 c0 04             	add    $0x4,%eax
  1029d4:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  1029db:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1029de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1029e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1029e4:	0f ab 10             	bts    %edx,(%eax)
        set_page_ref(p, 0);   // 引用计数设置为0
  1029e7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1029ee:	00 
  1029ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029f2:	89 04 24             	mov    %eax,(%esp)
  1029f5:	e8 f9 fe ff ff       	call   1028f3 <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  1029fa:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  1029fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a01:	89 d0                	mov    %edx,%eax
  102a03:	c1 e0 02             	shl    $0x2,%eax
  102a06:	01 d0                	add    %edx,%eax
  102a08:	c1 e0 02             	shl    $0x2,%eax
  102a0b:	89 c2                	mov    %eax,%edx
  102a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  102a10:	01 d0                	add    %edx,%eax
  102a12:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102a15:	0f 85 4d ff ff ff    	jne    102968 <default_init_memmap+0x3b>
        p->flags = p->property = 0;
		SetPageProperty(p);   // 把该页设置为valid
        set_page_ref(p, 0);   // 引用计数设置为0
    }
	// 只有第一页要设置空闲页号为n
    base->property = n;
  102a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  102a1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a21:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  102a24:	8b 45 08             	mov    0x8(%ebp),%eax
  102a27:	83 c0 04             	add    $0x4,%eax
  102a2a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
  102a31:	89 45 d8             	mov    %eax,-0x28(%ebp)
  102a34:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102a37:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102a3a:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
  102a3d:	8b 15 58 89 11 00    	mov    0x118958,%edx
  102a43:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a46:	01 d0                	add    %edx,%eax
  102a48:	a3 58 89 11 00       	mov    %eax,0x118958
    list_add(&free_list, &(base->page_link));  // 向后顺序加，按地址递增
  102a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  102a50:	83 c0 0c             	add    $0xc,%eax
  102a53:	c7 45 d4 50 89 11 00 	movl   $0x118950,-0x2c(%ebp)
  102a5a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102a5d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102a60:	89 45 cc             	mov    %eax,-0x34(%ebp)
  102a63:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102a66:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  102a69:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102a6c:	8b 40 04             	mov    0x4(%eax),%eax
  102a6f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102a72:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  102a75:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102a78:	89 55 c0             	mov    %edx,-0x40(%ebp)
  102a7b:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102a7e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102a81:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102a84:	89 10                	mov    %edx,(%eax)
  102a86:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102a89:	8b 10                	mov    (%eax),%edx
  102a8b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102a8e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102a91:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102a94:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102a97:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102a9a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102a9d:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102aa0:	89 10                	mov    %edx,(%eax)
}
  102aa2:	c9                   	leave  
  102aa3:	c3                   	ret    

00102aa4 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  102aa4:	55                   	push   %ebp
  102aa5:	89 e5                	mov    %esp,%ebp
  102aa7:	83 ec 68             	sub    $0x68,%esp
	// 边界判断，避免错误
    assert(n > 0);
  102aaa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102aae:	75 24                	jne    102ad4 <default_alloc_pages+0x30>
  102ab0:	c7 44 24 0c 50 65 10 	movl   $0x106550,0xc(%esp)
  102ab7:	00 
  102ab8:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  102abf:	00 
  102ac0:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  102ac7:	00 
  102ac8:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  102acf:	e8 03 e2 ff ff       	call   100cd7 <__panic>
    if (n > nr_free) {
  102ad4:	a1 58 89 11 00       	mov    0x118958,%eax
  102ad9:	3b 45 08             	cmp    0x8(%ebp),%eax
  102adc:	73 0a                	jae    102ae8 <default_alloc_pages+0x44>
        return NULL;
  102ade:	b8 00 00 00 00       	mov    $0x0,%eax
  102ae3:	e9 6a 01 00 00       	jmp    102c52 <default_alloc_pages+0x1ae>
    }
    struct Page *page = NULL;   // 命中的结果
  102ae8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	// 遍历空闲空间链表
    list_entry_t *le = &free_list;
  102aef:	c7 45 f0 50 89 11 00 	movl   $0x118950,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  102af6:	eb 1c                	jmp    102b14 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
  102af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102afb:	83 e8 0c             	sub    $0xc,%eax
  102afe:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (p->property >= n) {
  102b01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b04:	8b 40 08             	mov    0x8(%eax),%eax
  102b07:	3b 45 08             	cmp    0x8(%ebp),%eax
  102b0a:	72 08                	jb     102b14 <default_alloc_pages+0x70>
            page = p;
  102b0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  102b12:	eb 18                	jmp    102b2c <default_alloc_pages+0x88>
  102b14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b17:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102b1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b1d:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;
    }
    struct Page *page = NULL;   // 命中的结果
	// 遍历空闲空间链表
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  102b20:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102b23:	81 7d f0 50 89 11 00 	cmpl   $0x118950,-0x10(%ebp)
  102b2a:	75 cc                	jne    102af8 <default_alloc_pages+0x54>
            page = p;
            break;
        }
    }
	// 若命中，分配之
    if (page != NULL) {
  102b2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102b30:	0f 84 19 01 00 00    	je     102c4f <default_alloc_pages+0x1ab>
		// 首先把已经分配的n块设为不可用
		struct Page *current_page = page;
  102b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b39:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for (; current_page != page + n; current_page++) {
  102b3c:	eb 36                	jmp    102b74 <default_alloc_pages+0xd0>
			ClearPageProperty(current_page);
  102b3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b41:	83 c0 04             	add    $0x4,%eax
  102b44:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
  102b4b:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102b4e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102b51:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102b54:	0f b3 10             	btr    %edx,(%eax)
			ClearPageReserved(current_page);   // 释放时检查
  102b57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b5a:	83 c0 04             	add    $0x4,%eax
  102b5d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  102b64:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102b67:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102b6a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102b6d:	0f b3 10             	btr    %edx,(%eax)
    }
	// 若命中，分配之
    if (page != NULL) {
		// 首先把已经分配的n块设为不可用
		struct Page *current_page = page;
		for (; current_page != page + n; current_page++) {
  102b70:	83 45 ec 14          	addl   $0x14,-0x14(%ebp)
  102b74:	8b 55 08             	mov    0x8(%ebp),%edx
  102b77:	89 d0                	mov    %edx,%eax
  102b79:	c1 e0 02             	shl    $0x2,%eax
  102b7c:	01 d0                	add    %edx,%eax
  102b7e:	c1 e0 02             	shl    $0x2,%eax
  102b81:	89 c2                	mov    %eax,%edx
  102b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b86:	01 d0                	add    %edx,%eax
  102b88:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102b8b:	75 b1                	jne    102b3e <default_alloc_pages+0x9a>
			ClearPageProperty(current_page);
			ClearPageReserved(current_page);   // 释放时检查
		}
        if (page->property > n) {
  102b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b90:	8b 40 08             	mov    0x8(%eax),%eax
  102b93:	3b 45 08             	cmp    0x8(%ebp),%eax
  102b96:	76 7f                	jbe    102c17 <default_alloc_pages+0x173>
            struct Page *p = page + n;    // 剩下那块的首地址
  102b98:	8b 55 08             	mov    0x8(%ebp),%edx
  102b9b:	89 d0                	mov    %edx,%eax
  102b9d:	c1 e0 02             	shl    $0x2,%eax
  102ba0:	01 d0                	add    %edx,%eax
  102ba2:	c1 e0 02             	shl    $0x2,%eax
  102ba5:	89 c2                	mov    %eax,%edx
  102ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102baa:	01 d0                	add    %edx,%eax
  102bac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            p->property = page->property - n;
  102baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bb2:	8b 40 08             	mov    0x8(%eax),%eax
  102bb5:	2b 45 08             	sub    0x8(%ebp),%eax
  102bb8:	89 c2                	mov    %eax,%edx
  102bba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102bbd:	89 50 08             	mov    %edx,0x8(%eax)
			// 这一块插在分配出去的那块之后
            list_add(&(page->page_link), &(p->page_link));
  102bc0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102bc3:	83 c0 0c             	add    $0xc,%eax
  102bc6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102bc9:	83 c2 0c             	add    $0xc,%edx
  102bcc:	89 55 cc             	mov    %edx,-0x34(%ebp)
  102bcf:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102bd2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102bd5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  102bd8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102bdb:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  102bde:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102be1:	8b 40 04             	mov    0x4(%eax),%eax
  102be4:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102be7:	89 55 bc             	mov    %edx,-0x44(%ebp)
  102bea:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102bed:	89 55 b8             	mov    %edx,-0x48(%ebp)
  102bf0:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102bf3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102bf6:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102bf9:	89 10                	mov    %edx,(%eax)
  102bfb:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102bfe:	8b 10                	mov    (%eax),%edx
  102c00:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102c03:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102c06:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102c09:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102c0c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102c0f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102c12:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102c15:	89 10                	mov    %edx,(%eax)
		}
		list_del(&(page->page_link));
  102c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c1a:	83 c0 0c             	add    $0xc,%eax
  102c1d:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102c20:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102c23:	8b 40 04             	mov    0x4(%eax),%eax
  102c26:	8b 55 b0             	mov    -0x50(%ebp),%edx
  102c29:	8b 12                	mov    (%edx),%edx
  102c2b:	89 55 ac             	mov    %edx,-0x54(%ebp)
  102c2e:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102c31:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102c34:	8b 55 a8             	mov    -0x58(%ebp),%edx
  102c37:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102c3a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102c3d:	8b 55 ac             	mov    -0x54(%ebp),%edx
  102c40:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
  102c42:	a1 58 89 11 00       	mov    0x118958,%eax
  102c47:	2b 45 08             	sub    0x8(%ebp),%eax
  102c4a:	a3 58 89 11 00       	mov    %eax,0x118958
    }
    return page;
  102c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102c52:	c9                   	leave  
  102c53:	c3                   	ret    

00102c54 <default_free_pages>:
    nr_free += n;
    return;
}
*/
static void
default_free_pages(struct Page *base, size_t n) {
  102c54:	55                   	push   %ebp
  102c55:	89 e5                	mov    %esp,%ebp
  102c57:	83 ec 68             	sub    $0x68,%esp
	assert(n > 0);
  102c5a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102c5e:	75 24                	jne    102c84 <default_free_pages+0x30>
  102c60:	c7 44 24 0c 50 65 10 	movl   $0x106550,0xc(%esp)
  102c67:	00 
  102c68:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  102c6f:	00 
  102c70:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
  102c77:	00 
  102c78:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  102c7f:	e8 53 e0 ff ff       	call   100cd7 <__panic>
	
	base->flags = 0;
  102c84:	8b 45 08             	mov    0x8(%ebp),%eax
  102c87:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	base->property = n;
  102c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  102c91:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c94:	89 50 08             	mov    %edx,0x8(%eax)
	ClearPageReserved(base);
  102c97:	8b 45 08             	mov    0x8(%ebp),%eax
  102c9a:	83 c0 04             	add    $0x4,%eax
  102c9d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  102ca4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102ca7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102caa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102cad:	0f b3 10             	btr    %edx,(%eax)
	SetPageProperty(base);
  102cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  102cb3:	83 c0 04             	add    $0x4,%eax
  102cb6:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  102cbd:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102cc0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102cc3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102cc6:	0f ab 10             	bts    %edx,(%eax)
	set_page_ref(base, 0);
  102cc9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102cd0:	00 
  102cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  102cd4:	89 04 24             	mov    %eax,(%esp)
  102cd7:	e8 17 fc ff ff       	call   1028f3 <set_page_ref>

	struct Page * p;
	list_entry_t *le = &free_list;
  102cdc:	c7 45 f0 50 89 11 00 	movl   $0x118950,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  102ce3:	eb 24                	jmp    102d09 <default_free_pages+0xb5>
        p = le2page(le, page_link);
  102ce5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ce8:	83 e8 0c             	sub    $0xc,%eax
  102ceb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(p >= base + n) {
  102cee:	8b 55 0c             	mov    0xc(%ebp),%edx
  102cf1:	89 d0                	mov    %edx,%eax
  102cf3:	c1 e0 02             	shl    $0x2,%eax
  102cf6:	01 d0                	add    %edx,%eax
  102cf8:	c1 e0 02             	shl    $0x2,%eax
  102cfb:	89 c2                	mov    %eax,%edx
  102cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  102d00:	01 d0                	add    %edx,%eax
  102d02:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102d05:	77 02                	ja     102d09 <default_free_pages+0xb5>
			break;
  102d07:	eb 18                	jmp    102d21 <default_free_pages+0xcd>
  102d09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d0c:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102d0f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102d12:	8b 40 04             	mov    0x4(%eax),%eax
	SetPageProperty(base);
	set_page_ref(base, 0);

	struct Page * p;
	list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  102d15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d18:	81 7d f0 50 89 11 00 	cmpl   $0x118950,-0x10(%ebp)
  102d1f:	75 c4                	jne    102ce5 <default_free_pages+0x91>
        p = le2page(le, page_link);
		if(p >= base + n) {
			break;
		}
	}
	list_add_before(le,&(base->page_link));
  102d21:	8b 45 08             	mov    0x8(%ebp),%eax
  102d24:	8d 50 0c             	lea    0xc(%eax),%edx
  102d27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d2a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  102d2d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102d30:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102d33:	8b 00                	mov    (%eax),%eax
  102d35:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102d38:	89 55 d0             	mov    %edx,-0x30(%ebp)
  102d3b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  102d3e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102d41:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102d44:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102d47:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102d4a:	89 10                	mov    %edx,(%eax)
  102d4c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102d4f:	8b 10                	mov    (%eax),%edx
  102d51:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102d54:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102d57:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102d5a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102d5d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102d60:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102d63:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102d66:	89 10                	mov    %edx,(%eax)
    if (base + n == p) {
  102d68:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d6b:	89 d0                	mov    %edx,%eax
  102d6d:	c1 e0 02             	shl    $0x2,%eax
  102d70:	01 d0                	add    %edx,%eax
  102d72:	c1 e0 02             	shl    $0x2,%eax
  102d75:	89 c2                	mov    %eax,%edx
  102d77:	8b 45 08             	mov    0x8(%ebp),%eax
  102d7a:	01 d0                	add    %edx,%eax
  102d7c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102d7f:	75 49                	jne    102dca <default_free_pages+0x176>
        base->property += p->property;
  102d81:	8b 45 08             	mov    0x8(%ebp),%eax
  102d84:	8b 50 08             	mov    0x8(%eax),%edx
  102d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d8a:	8b 40 08             	mov    0x8(%eax),%eax
  102d8d:	01 c2                	add    %eax,%edx
  102d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  102d92:	89 50 08             	mov    %edx,0x8(%eax)
		p->property = 0;
  102d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d98:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		list_del(&(p->page_link));
  102d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102da2:	83 c0 0c             	add    $0xc,%eax
  102da5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102da8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102dab:	8b 40 04             	mov    0x4(%eax),%eax
  102dae:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102db1:	8b 12                	mov    (%edx),%edx
  102db3:	89 55 c0             	mov    %edx,-0x40(%ebp)
  102db6:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102db9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102dbc:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102dbf:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102dc2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102dc5:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102dc8:	89 10                	mov    %edx,(%eax)
    }
	le = list_prev(&(base->page_link));
  102dca:	8b 45 08             	mov    0x8(%ebp),%eax
  102dcd:	83 c0 0c             	add    $0xc,%eax
  102dd0:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
  102dd3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102dd6:	8b 00                	mov    (%eax),%eax
  102dd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	p = le2page(le,page_link);
  102ddb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102dde:	83 e8 0c             	sub    $0xc,%eax
  102de1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p + p->property == base) {
  102de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102de7:	8b 50 08             	mov    0x8(%eax),%edx
  102dea:	89 d0                	mov    %edx,%eax
  102dec:	c1 e0 02             	shl    $0x2,%eax
  102def:	01 d0                	add    %edx,%eax
  102df1:	c1 e0 02             	shl    $0x2,%eax
  102df4:	89 c2                	mov    %eax,%edx
  102df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102df9:	01 d0                	add    %edx,%eax
  102dfb:	3b 45 08             	cmp    0x8(%ebp),%eax
  102dfe:	75 49                	jne    102e49 <default_free_pages+0x1f5>
        p->property += base->property;
  102e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e03:	8b 50 08             	mov    0x8(%eax),%edx
  102e06:	8b 45 08             	mov    0x8(%ebp),%eax
  102e09:	8b 40 08             	mov    0x8(%eax),%eax
  102e0c:	01 c2                	add    %eax,%edx
  102e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e11:	89 50 08             	mov    %edx,0x8(%eax)
		base->property = 0;
  102e14:	8b 45 08             	mov    0x8(%ebp),%eax
  102e17:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		list_del(&(base->page_link));
  102e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  102e21:	83 c0 0c             	add    $0xc,%eax
  102e24:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102e27:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102e2a:	8b 40 04             	mov    0x4(%eax),%eax
  102e2d:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102e30:	8b 12                	mov    (%edx),%edx
  102e32:	89 55 b0             	mov    %edx,-0x50(%ebp)
  102e35:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102e38:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102e3b:	8b 55 ac             	mov    -0x54(%ebp),%edx
  102e3e:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102e41:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102e44:	8b 55 b0             	mov    -0x50(%ebp),%edx
  102e47:	89 10                	mov    %edx,(%eax)
    }
    nr_free += n;
  102e49:	8b 15 58 89 11 00    	mov    0x118958,%edx
  102e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e52:	01 d0                	add    %edx,%eax
  102e54:	a3 58 89 11 00       	mov    %eax,0x118958
	return ;
  102e59:	90                   	nop
}
  102e5a:	c9                   	leave  
  102e5b:	c3                   	ret    

00102e5c <default_nr_free_pages>:



static size_t
default_nr_free_pages(void) {
  102e5c:	55                   	push   %ebp
  102e5d:	89 e5                	mov    %esp,%ebp
    return nr_free;
  102e5f:	a1 58 89 11 00       	mov    0x118958,%eax
}
  102e64:	5d                   	pop    %ebp
  102e65:	c3                   	ret    

00102e66 <basic_check>:

static void
basic_check(void) {
  102e66:	55                   	push   %ebp
  102e67:	89 e5                	mov    %esp,%ebp
  102e69:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  102e6c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e76:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e7c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  102e7f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102e86:	e8 90 0e 00 00       	call   103d1b <alloc_pages>
  102e8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102e8e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  102e92:	75 24                	jne    102eb8 <basic_check+0x52>
  102e94:	c7 44 24 0c 91 65 10 	movl   $0x106591,0xc(%esp)
  102e9b:	00 
  102e9c:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  102ea3:	00 
  102ea4:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
  102eab:	00 
  102eac:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  102eb3:	e8 1f de ff ff       	call   100cd7 <__panic>
    assert((p1 = alloc_page()) != NULL);
  102eb8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102ebf:	e8 57 0e 00 00       	call   103d1b <alloc_pages>
  102ec4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ec7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102ecb:	75 24                	jne    102ef1 <basic_check+0x8b>
  102ecd:	c7 44 24 0c ad 65 10 	movl   $0x1065ad,0xc(%esp)
  102ed4:	00 
  102ed5:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  102edc:	00 
  102edd:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  102ee4:	00 
  102ee5:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  102eec:	e8 e6 dd ff ff       	call   100cd7 <__panic>
    assert((p2 = alloc_page()) != NULL);
  102ef1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102ef8:	e8 1e 0e 00 00       	call   103d1b <alloc_pages>
  102efd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102f04:	75 24                	jne    102f2a <basic_check+0xc4>
  102f06:	c7 44 24 0c c9 65 10 	movl   $0x1065c9,0xc(%esp)
  102f0d:	00 
  102f0e:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  102f15:	00 
  102f16:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  102f1d:	00 
  102f1e:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  102f25:	e8 ad dd ff ff       	call   100cd7 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  102f2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f2d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102f30:	74 10                	je     102f42 <basic_check+0xdc>
  102f32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f35:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102f38:	74 08                	je     102f42 <basic_check+0xdc>
  102f3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f3d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102f40:	75 24                	jne    102f66 <basic_check+0x100>
  102f42:	c7 44 24 0c e8 65 10 	movl   $0x1065e8,0xc(%esp)
  102f49:	00 
  102f4a:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  102f51:	00 
  102f52:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
  102f59:	00 
  102f5a:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  102f61:	e8 71 dd ff ff       	call   100cd7 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  102f66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f69:	89 04 24             	mov    %eax,(%esp)
  102f6c:	e8 78 f9 ff ff       	call   1028e9 <page_ref>
  102f71:	85 c0                	test   %eax,%eax
  102f73:	75 1e                	jne    102f93 <basic_check+0x12d>
  102f75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f78:	89 04 24             	mov    %eax,(%esp)
  102f7b:	e8 69 f9 ff ff       	call   1028e9 <page_ref>
  102f80:	85 c0                	test   %eax,%eax
  102f82:	75 0f                	jne    102f93 <basic_check+0x12d>
  102f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f87:	89 04 24             	mov    %eax,(%esp)
  102f8a:	e8 5a f9 ff ff       	call   1028e9 <page_ref>
  102f8f:	85 c0                	test   %eax,%eax
  102f91:	74 24                	je     102fb7 <basic_check+0x151>
  102f93:	c7 44 24 0c 0c 66 10 	movl   $0x10660c,0xc(%esp)
  102f9a:	00 
  102f9b:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  102fa2:	00 
  102fa3:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
  102faa:	00 
  102fab:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  102fb2:	e8 20 dd ff ff       	call   100cd7 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  102fb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fba:	89 04 24             	mov    %eax,(%esp)
  102fbd:	e8 11 f9 ff ff       	call   1028d3 <page2pa>
  102fc2:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102fc8:	c1 e2 0c             	shl    $0xc,%edx
  102fcb:	39 d0                	cmp    %edx,%eax
  102fcd:	72 24                	jb     102ff3 <basic_check+0x18d>
  102fcf:	c7 44 24 0c 48 66 10 	movl   $0x106648,0xc(%esp)
  102fd6:	00 
  102fd7:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  102fde:	00 
  102fdf:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
  102fe6:	00 
  102fe7:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  102fee:	e8 e4 dc ff ff       	call   100cd7 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  102ff3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ff6:	89 04 24             	mov    %eax,(%esp)
  102ff9:	e8 d5 f8 ff ff       	call   1028d3 <page2pa>
  102ffe:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  103004:	c1 e2 0c             	shl    $0xc,%edx
  103007:	39 d0                	cmp    %edx,%eax
  103009:	72 24                	jb     10302f <basic_check+0x1c9>
  10300b:	c7 44 24 0c 65 66 10 	movl   $0x106665,0xc(%esp)
  103012:	00 
  103013:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  10301a:	00 
  10301b:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  103022:	00 
  103023:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  10302a:	e8 a8 dc ff ff       	call   100cd7 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  10302f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103032:	89 04 24             	mov    %eax,(%esp)
  103035:	e8 99 f8 ff ff       	call   1028d3 <page2pa>
  10303a:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  103040:	c1 e2 0c             	shl    $0xc,%edx
  103043:	39 d0                	cmp    %edx,%eax
  103045:	72 24                	jb     10306b <basic_check+0x205>
  103047:	c7 44 24 0c 82 66 10 	movl   $0x106682,0xc(%esp)
  10304e:	00 
  10304f:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  103056:	00 
  103057:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
  10305e:	00 
  10305f:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  103066:	e8 6c dc ff ff       	call   100cd7 <__panic>

    list_entry_t free_list_store = free_list;
  10306b:	a1 50 89 11 00       	mov    0x118950,%eax
  103070:	8b 15 54 89 11 00    	mov    0x118954,%edx
  103076:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103079:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10307c:	c7 45 e0 50 89 11 00 	movl   $0x118950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  103083:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103086:	8b 55 e0             	mov    -0x20(%ebp),%edx
  103089:	89 50 04             	mov    %edx,0x4(%eax)
  10308c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10308f:	8b 50 04             	mov    0x4(%eax),%edx
  103092:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103095:	89 10                	mov    %edx,(%eax)
  103097:	c7 45 dc 50 89 11 00 	movl   $0x118950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  10309e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1030a1:	8b 40 04             	mov    0x4(%eax),%eax
  1030a4:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1030a7:	0f 94 c0             	sete   %al
  1030aa:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1030ad:	85 c0                	test   %eax,%eax
  1030af:	75 24                	jne    1030d5 <basic_check+0x26f>
  1030b1:	c7 44 24 0c 9f 66 10 	movl   $0x10669f,0xc(%esp)
  1030b8:	00 
  1030b9:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  1030c0:	00 
  1030c1:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
  1030c8:	00 
  1030c9:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  1030d0:	e8 02 dc ff ff       	call   100cd7 <__panic>

    unsigned int nr_free_store = nr_free;
  1030d5:	a1 58 89 11 00       	mov    0x118958,%eax
  1030da:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  1030dd:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  1030e4:	00 00 00 

    assert(alloc_page() == NULL);
  1030e7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1030ee:	e8 28 0c 00 00       	call   103d1b <alloc_pages>
  1030f3:	85 c0                	test   %eax,%eax
  1030f5:	74 24                	je     10311b <basic_check+0x2b5>
  1030f7:	c7 44 24 0c b6 66 10 	movl   $0x1066b6,0xc(%esp)
  1030fe:	00 
  1030ff:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  103106:	00 
  103107:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
  10310e:	00 
  10310f:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  103116:	e8 bc db ff ff       	call   100cd7 <__panic>

    free_page(p0);
  10311b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103122:	00 
  103123:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103126:	89 04 24             	mov    %eax,(%esp)
  103129:	e8 25 0c 00 00       	call   103d53 <free_pages>
    free_page(p1);
  10312e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103135:	00 
  103136:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103139:	89 04 24             	mov    %eax,(%esp)
  10313c:	e8 12 0c 00 00       	call   103d53 <free_pages>
    free_page(p2);
  103141:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103148:	00 
  103149:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10314c:	89 04 24             	mov    %eax,(%esp)
  10314f:	e8 ff 0b 00 00       	call   103d53 <free_pages>
    assert(nr_free == 3);
  103154:	a1 58 89 11 00       	mov    0x118958,%eax
  103159:	83 f8 03             	cmp    $0x3,%eax
  10315c:	74 24                	je     103182 <basic_check+0x31c>
  10315e:	c7 44 24 0c cb 66 10 	movl   $0x1066cb,0xc(%esp)
  103165:	00 
  103166:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  10316d:	00 
  10316e:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
  103175:	00 
  103176:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  10317d:	e8 55 db ff ff       	call   100cd7 <__panic>

    assert((p0 = alloc_page()) != NULL);
  103182:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103189:	e8 8d 0b 00 00       	call   103d1b <alloc_pages>
  10318e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103191:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  103195:	75 24                	jne    1031bb <basic_check+0x355>
  103197:	c7 44 24 0c 91 65 10 	movl   $0x106591,0xc(%esp)
  10319e:	00 
  10319f:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  1031a6:	00 
  1031a7:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
  1031ae:	00 
  1031af:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  1031b6:	e8 1c db ff ff       	call   100cd7 <__panic>
    assert((p1 = alloc_page()) != NULL);
  1031bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1031c2:	e8 54 0b 00 00       	call   103d1b <alloc_pages>
  1031c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1031ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1031ce:	75 24                	jne    1031f4 <basic_check+0x38e>
  1031d0:	c7 44 24 0c ad 65 10 	movl   $0x1065ad,0xc(%esp)
  1031d7:	00 
  1031d8:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  1031df:	00 
  1031e0:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
  1031e7:	00 
  1031e8:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  1031ef:	e8 e3 da ff ff       	call   100cd7 <__panic>
    assert((p2 = alloc_page()) != NULL);
  1031f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1031fb:	e8 1b 0b 00 00       	call   103d1b <alloc_pages>
  103200:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103203:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103207:	75 24                	jne    10322d <basic_check+0x3c7>
  103209:	c7 44 24 0c c9 65 10 	movl   $0x1065c9,0xc(%esp)
  103210:	00 
  103211:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  103218:	00 
  103219:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
  103220:	00 
  103221:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  103228:	e8 aa da ff ff       	call   100cd7 <__panic>

    assert(alloc_page() == NULL);
  10322d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103234:	e8 e2 0a 00 00       	call   103d1b <alloc_pages>
  103239:	85 c0                	test   %eax,%eax
  10323b:	74 24                	je     103261 <basic_check+0x3fb>
  10323d:	c7 44 24 0c b6 66 10 	movl   $0x1066b6,0xc(%esp)
  103244:	00 
  103245:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  10324c:	00 
  10324d:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
  103254:	00 
  103255:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  10325c:	e8 76 da ff ff       	call   100cd7 <__panic>

    free_page(p0);
  103261:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103268:	00 
  103269:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10326c:	89 04 24             	mov    %eax,(%esp)
  10326f:	e8 df 0a 00 00       	call   103d53 <free_pages>
  103274:	c7 45 d8 50 89 11 00 	movl   $0x118950,-0x28(%ebp)
  10327b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10327e:	8b 40 04             	mov    0x4(%eax),%eax
  103281:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  103284:	0f 94 c0             	sete   %al
  103287:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  10328a:	85 c0                	test   %eax,%eax
  10328c:	74 24                	je     1032b2 <basic_check+0x44c>
  10328e:	c7 44 24 0c d8 66 10 	movl   $0x1066d8,0xc(%esp)
  103295:	00 
  103296:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  10329d:	00 
  10329e:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  1032a5:	00 
  1032a6:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  1032ad:	e8 25 da ff ff       	call   100cd7 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  1032b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032b9:	e8 5d 0a 00 00       	call   103d1b <alloc_pages>
  1032be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1032c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1032c4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1032c7:	74 24                	je     1032ed <basic_check+0x487>
  1032c9:	c7 44 24 0c f0 66 10 	movl   $0x1066f0,0xc(%esp)
  1032d0:	00 
  1032d1:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  1032d8:	00 
  1032d9:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
  1032e0:	00 
  1032e1:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  1032e8:	e8 ea d9 ff ff       	call   100cd7 <__panic>
    assert(alloc_page() == NULL);
  1032ed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032f4:	e8 22 0a 00 00       	call   103d1b <alloc_pages>
  1032f9:	85 c0                	test   %eax,%eax
  1032fb:	74 24                	je     103321 <basic_check+0x4bb>
  1032fd:	c7 44 24 0c b6 66 10 	movl   $0x1066b6,0xc(%esp)
  103304:	00 
  103305:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  10330c:	00 
  10330d:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
  103314:	00 
  103315:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  10331c:	e8 b6 d9 ff ff       	call   100cd7 <__panic>

    assert(nr_free == 0);
  103321:	a1 58 89 11 00       	mov    0x118958,%eax
  103326:	85 c0                	test   %eax,%eax
  103328:	74 24                	je     10334e <basic_check+0x4e8>
  10332a:	c7 44 24 0c 09 67 10 	movl   $0x106709,0xc(%esp)
  103331:	00 
  103332:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  103339:	00 
  10333a:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  103341:	00 
  103342:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  103349:	e8 89 d9 ff ff       	call   100cd7 <__panic>
    free_list = free_list_store;
  10334e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103351:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103354:	a3 50 89 11 00       	mov    %eax,0x118950
  103359:	89 15 54 89 11 00    	mov    %edx,0x118954
    nr_free = nr_free_store;
  10335f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103362:	a3 58 89 11 00       	mov    %eax,0x118958

    free_page(p);
  103367:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10336e:	00 
  10336f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103372:	89 04 24             	mov    %eax,(%esp)
  103375:	e8 d9 09 00 00       	call   103d53 <free_pages>
    free_page(p1);
  10337a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103381:	00 
  103382:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103385:	89 04 24             	mov    %eax,(%esp)
  103388:	e8 c6 09 00 00       	call   103d53 <free_pages>
    free_page(p2);
  10338d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103394:	00 
  103395:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103398:	89 04 24             	mov    %eax,(%esp)
  10339b:	e8 b3 09 00 00       	call   103d53 <free_pages>
}
  1033a0:	c9                   	leave  
  1033a1:	c3                   	ret    

001033a2 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  1033a2:	55                   	push   %ebp
  1033a3:	89 e5                	mov    %esp,%ebp
  1033a5:	53                   	push   %ebx
  1033a6:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  1033ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1033b3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  1033ba:	c7 45 ec 50 89 11 00 	movl   $0x118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1033c1:	eb 6b                	jmp    10342e <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  1033c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033c6:	83 e8 0c             	sub    $0xc,%eax
  1033c9:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  1033cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033cf:	83 c0 04             	add    $0x4,%eax
  1033d2:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  1033d9:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1033dc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1033df:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1033e2:	0f a3 10             	bt     %edx,(%eax)
  1033e5:	19 c0                	sbb    %eax,%eax
  1033e7:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  1033ea:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  1033ee:	0f 95 c0             	setne  %al
  1033f1:	0f b6 c0             	movzbl %al,%eax
  1033f4:	85 c0                	test   %eax,%eax
  1033f6:	75 24                	jne    10341c <default_check+0x7a>
  1033f8:	c7 44 24 0c 16 67 10 	movl   $0x106716,0xc(%esp)
  1033ff:	00 
  103400:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  103407:	00 
  103408:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
  10340f:	00 
  103410:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  103417:	e8 bb d8 ff ff       	call   100cd7 <__panic>
        count ++, total += p->property;
  10341c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  103420:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103423:	8b 50 08             	mov    0x8(%eax),%edx
  103426:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103429:	01 d0                	add    %edx,%eax
  10342b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10342e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103431:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103434:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103437:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  10343a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10343d:	81 7d ec 50 89 11 00 	cmpl   $0x118950,-0x14(%ebp)
  103444:	0f 85 79 ff ff ff    	jne    1033c3 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  10344a:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  10344d:	e8 33 09 00 00       	call   103d85 <nr_free_pages>
  103452:	39 c3                	cmp    %eax,%ebx
  103454:	74 24                	je     10347a <default_check+0xd8>
  103456:	c7 44 24 0c 26 67 10 	movl   $0x106726,0xc(%esp)
  10345d:	00 
  10345e:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  103465:	00 
  103466:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
  10346d:	00 
  10346e:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  103475:	e8 5d d8 ff ff       	call   100cd7 <__panic>

    basic_check();
  10347a:	e8 e7 f9 ff ff       	call   102e66 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  10347f:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103486:	e8 90 08 00 00       	call   103d1b <alloc_pages>
  10348b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  10348e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103492:	75 24                	jne    1034b8 <default_check+0x116>
  103494:	c7 44 24 0c 3f 67 10 	movl   $0x10673f,0xc(%esp)
  10349b:	00 
  10349c:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  1034a3:	00 
  1034a4:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
  1034ab:	00 
  1034ac:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  1034b3:	e8 1f d8 ff ff       	call   100cd7 <__panic>
    assert(!PageProperty(p0));
  1034b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1034bb:	83 c0 04             	add    $0x4,%eax
  1034be:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  1034c5:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1034c8:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1034cb:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1034ce:	0f a3 10             	bt     %edx,(%eax)
  1034d1:	19 c0                	sbb    %eax,%eax
  1034d3:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  1034d6:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  1034da:	0f 95 c0             	setne  %al
  1034dd:	0f b6 c0             	movzbl %al,%eax
  1034e0:	85 c0                	test   %eax,%eax
  1034e2:	74 24                	je     103508 <default_check+0x166>
  1034e4:	c7 44 24 0c 4a 67 10 	movl   $0x10674a,0xc(%esp)
  1034eb:	00 
  1034ec:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  1034f3:	00 
  1034f4:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
  1034fb:	00 
  1034fc:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  103503:	e8 cf d7 ff ff       	call   100cd7 <__panic>

    list_entry_t free_list_store = free_list;
  103508:	a1 50 89 11 00       	mov    0x118950,%eax
  10350d:	8b 15 54 89 11 00    	mov    0x118954,%edx
  103513:	89 45 80             	mov    %eax,-0x80(%ebp)
  103516:	89 55 84             	mov    %edx,-0x7c(%ebp)
  103519:	c7 45 b4 50 89 11 00 	movl   $0x118950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  103520:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103523:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103526:	89 50 04             	mov    %edx,0x4(%eax)
  103529:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10352c:	8b 50 04             	mov    0x4(%eax),%edx
  10352f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103532:	89 10                	mov    %edx,(%eax)
  103534:	c7 45 b0 50 89 11 00 	movl   $0x118950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  10353b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10353e:	8b 40 04             	mov    0x4(%eax),%eax
  103541:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  103544:	0f 94 c0             	sete   %al
  103547:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10354a:	85 c0                	test   %eax,%eax
  10354c:	75 24                	jne    103572 <default_check+0x1d0>
  10354e:	c7 44 24 0c 9f 66 10 	movl   $0x10669f,0xc(%esp)
  103555:	00 
  103556:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  10355d:	00 
  10355e:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
  103565:	00 
  103566:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  10356d:	e8 65 d7 ff ff       	call   100cd7 <__panic>
    assert(alloc_page() == NULL);
  103572:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103579:	e8 9d 07 00 00       	call   103d1b <alloc_pages>
  10357e:	85 c0                	test   %eax,%eax
  103580:	74 24                	je     1035a6 <default_check+0x204>
  103582:	c7 44 24 0c b6 66 10 	movl   $0x1066b6,0xc(%esp)
  103589:	00 
  10358a:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  103591:	00 
  103592:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
  103599:	00 
  10359a:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  1035a1:	e8 31 d7 ff ff       	call   100cd7 <__panic>

    unsigned int nr_free_store = nr_free;
  1035a6:	a1 58 89 11 00       	mov    0x118958,%eax
  1035ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  1035ae:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  1035b5:	00 00 00 

    free_pages(p0 + 2, 3);
  1035b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035bb:	83 c0 28             	add    $0x28,%eax
  1035be:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1035c5:	00 
  1035c6:	89 04 24             	mov    %eax,(%esp)
  1035c9:	e8 85 07 00 00       	call   103d53 <free_pages>
    assert(alloc_pages(4) == NULL);
  1035ce:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1035d5:	e8 41 07 00 00       	call   103d1b <alloc_pages>
  1035da:	85 c0                	test   %eax,%eax
  1035dc:	74 24                	je     103602 <default_check+0x260>
  1035de:	c7 44 24 0c 5c 67 10 	movl   $0x10675c,0xc(%esp)
  1035e5:	00 
  1035e6:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  1035ed:	00 
  1035ee:	c7 44 24 04 25 01 00 	movl   $0x125,0x4(%esp)
  1035f5:	00 
  1035f6:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  1035fd:	e8 d5 d6 ff ff       	call   100cd7 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  103602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103605:	83 c0 28             	add    $0x28,%eax
  103608:	83 c0 04             	add    $0x4,%eax
  10360b:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  103612:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103615:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103618:	8b 55 ac             	mov    -0x54(%ebp),%edx
  10361b:	0f a3 10             	bt     %edx,(%eax)
  10361e:	19 c0                	sbb    %eax,%eax
  103620:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  103623:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  103627:	0f 95 c0             	setne  %al
  10362a:	0f b6 c0             	movzbl %al,%eax
  10362d:	85 c0                	test   %eax,%eax
  10362f:	74 0e                	je     10363f <default_check+0x29d>
  103631:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103634:	83 c0 28             	add    $0x28,%eax
  103637:	8b 40 08             	mov    0x8(%eax),%eax
  10363a:	83 f8 03             	cmp    $0x3,%eax
  10363d:	74 24                	je     103663 <default_check+0x2c1>
  10363f:	c7 44 24 0c 74 67 10 	movl   $0x106774,0xc(%esp)
  103646:	00 
  103647:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  10364e:	00 
  10364f:	c7 44 24 04 26 01 00 	movl   $0x126,0x4(%esp)
  103656:	00 
  103657:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  10365e:	e8 74 d6 ff ff       	call   100cd7 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  103663:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  10366a:	e8 ac 06 00 00       	call   103d1b <alloc_pages>
  10366f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103672:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103676:	75 24                	jne    10369c <default_check+0x2fa>
  103678:	c7 44 24 0c a0 67 10 	movl   $0x1067a0,0xc(%esp)
  10367f:	00 
  103680:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  103687:	00 
  103688:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
  10368f:	00 
  103690:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  103697:	e8 3b d6 ff ff       	call   100cd7 <__panic>
    assert(alloc_page() == NULL);
  10369c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1036a3:	e8 73 06 00 00       	call   103d1b <alloc_pages>
  1036a8:	85 c0                	test   %eax,%eax
  1036aa:	74 24                	je     1036d0 <default_check+0x32e>
  1036ac:	c7 44 24 0c b6 66 10 	movl   $0x1066b6,0xc(%esp)
  1036b3:	00 
  1036b4:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  1036bb:	00 
  1036bc:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
  1036c3:	00 
  1036c4:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  1036cb:	e8 07 d6 ff ff       	call   100cd7 <__panic>
    assert(p0 + 2 == p1);
  1036d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036d3:	83 c0 28             	add    $0x28,%eax
  1036d6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  1036d9:	74 24                	je     1036ff <default_check+0x35d>
  1036db:	c7 44 24 0c be 67 10 	movl   $0x1067be,0xc(%esp)
  1036e2:	00 
  1036e3:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  1036ea:	00 
  1036eb:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
  1036f2:	00 
  1036f3:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  1036fa:	e8 d8 d5 ff ff       	call   100cd7 <__panic>

    p2 = p0 + 1;
  1036ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103702:	83 c0 14             	add    $0x14,%eax
  103705:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  103708:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10370f:	00 
  103710:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103713:	89 04 24             	mov    %eax,(%esp)
  103716:	e8 38 06 00 00       	call   103d53 <free_pages>
    free_pages(p1, 3);
  10371b:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  103722:	00 
  103723:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103726:	89 04 24             	mov    %eax,(%esp)
  103729:	e8 25 06 00 00       	call   103d53 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  10372e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103731:	83 c0 04             	add    $0x4,%eax
  103734:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  10373b:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10373e:	8b 45 9c             	mov    -0x64(%ebp),%eax
  103741:	8b 55 a0             	mov    -0x60(%ebp),%edx
  103744:	0f a3 10             	bt     %edx,(%eax)
  103747:	19 c0                	sbb    %eax,%eax
  103749:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  10374c:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  103750:	0f 95 c0             	setne  %al
  103753:	0f b6 c0             	movzbl %al,%eax
  103756:	85 c0                	test   %eax,%eax
  103758:	74 0b                	je     103765 <default_check+0x3c3>
  10375a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10375d:	8b 40 08             	mov    0x8(%eax),%eax
  103760:	83 f8 01             	cmp    $0x1,%eax
  103763:	74 24                	je     103789 <default_check+0x3e7>
  103765:	c7 44 24 0c cc 67 10 	movl   $0x1067cc,0xc(%esp)
  10376c:	00 
  10376d:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  103774:	00 
  103775:	c7 44 24 04 2e 01 00 	movl   $0x12e,0x4(%esp)
  10377c:	00 
  10377d:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  103784:	e8 4e d5 ff ff       	call   100cd7 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  103789:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10378c:	83 c0 04             	add    $0x4,%eax
  10378f:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  103796:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103799:	8b 45 90             	mov    -0x70(%ebp),%eax
  10379c:	8b 55 94             	mov    -0x6c(%ebp),%edx
  10379f:	0f a3 10             	bt     %edx,(%eax)
  1037a2:	19 c0                	sbb    %eax,%eax
  1037a4:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  1037a7:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  1037ab:	0f 95 c0             	setne  %al
  1037ae:	0f b6 c0             	movzbl %al,%eax
  1037b1:	85 c0                	test   %eax,%eax
  1037b3:	74 0b                	je     1037c0 <default_check+0x41e>
  1037b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1037b8:	8b 40 08             	mov    0x8(%eax),%eax
  1037bb:	83 f8 03             	cmp    $0x3,%eax
  1037be:	74 24                	je     1037e4 <default_check+0x442>
  1037c0:	c7 44 24 0c f4 67 10 	movl   $0x1067f4,0xc(%esp)
  1037c7:	00 
  1037c8:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  1037cf:	00 
  1037d0:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
  1037d7:	00 
  1037d8:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  1037df:	e8 f3 d4 ff ff       	call   100cd7 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  1037e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1037eb:	e8 2b 05 00 00       	call   103d1b <alloc_pages>
  1037f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1037f3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1037f6:	83 e8 14             	sub    $0x14,%eax
  1037f9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1037fc:	74 24                	je     103822 <default_check+0x480>
  1037fe:	c7 44 24 0c 1a 68 10 	movl   $0x10681a,0xc(%esp)
  103805:	00 
  103806:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  10380d:	00 
  10380e:	c7 44 24 04 31 01 00 	movl   $0x131,0x4(%esp)
  103815:	00 
  103816:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  10381d:	e8 b5 d4 ff ff       	call   100cd7 <__panic>
    free_page(p0);
  103822:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103829:	00 
  10382a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10382d:	89 04 24             	mov    %eax,(%esp)
  103830:	e8 1e 05 00 00       	call   103d53 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  103835:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10383c:	e8 da 04 00 00       	call   103d1b <alloc_pages>
  103841:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103844:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103847:	83 c0 14             	add    $0x14,%eax
  10384a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10384d:	74 24                	je     103873 <default_check+0x4d1>
  10384f:	c7 44 24 0c 38 68 10 	movl   $0x106838,0xc(%esp)
  103856:	00 
  103857:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  10385e:	00 
  10385f:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
  103866:	00 
  103867:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  10386e:	e8 64 d4 ff ff       	call   100cd7 <__panic>

    free_pages(p0, 2);
  103873:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10387a:	00 
  10387b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10387e:	89 04 24             	mov    %eax,(%esp)
  103881:	e8 cd 04 00 00       	call   103d53 <free_pages>
    free_page(p2);
  103886:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10388d:	00 
  10388e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103891:	89 04 24             	mov    %eax,(%esp)
  103894:	e8 ba 04 00 00       	call   103d53 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  103899:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  1038a0:	e8 76 04 00 00       	call   103d1b <alloc_pages>
  1038a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1038a8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1038ac:	75 24                	jne    1038d2 <default_check+0x530>
  1038ae:	c7 44 24 0c 58 68 10 	movl   $0x106858,0xc(%esp)
  1038b5:	00 
  1038b6:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  1038bd:	00 
  1038be:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  1038c5:	00 
  1038c6:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  1038cd:	e8 05 d4 ff ff       	call   100cd7 <__panic>
    assert(alloc_page() == NULL);
  1038d2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1038d9:	e8 3d 04 00 00       	call   103d1b <alloc_pages>
  1038de:	85 c0                	test   %eax,%eax
  1038e0:	74 24                	je     103906 <default_check+0x564>
  1038e2:	c7 44 24 0c b6 66 10 	movl   $0x1066b6,0xc(%esp)
  1038e9:	00 
  1038ea:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  1038f1:	00 
  1038f2:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
  1038f9:	00 
  1038fa:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  103901:	e8 d1 d3 ff ff       	call   100cd7 <__panic>

    assert(nr_free == 0);
  103906:	a1 58 89 11 00       	mov    0x118958,%eax
  10390b:	85 c0                	test   %eax,%eax
  10390d:	74 24                	je     103933 <default_check+0x591>
  10390f:	c7 44 24 0c 09 67 10 	movl   $0x106709,0xc(%esp)
  103916:	00 
  103917:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  10391e:	00 
  10391f:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
  103926:	00 
  103927:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  10392e:	e8 a4 d3 ff ff       	call   100cd7 <__panic>
    nr_free = nr_free_store;
  103933:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103936:	a3 58 89 11 00       	mov    %eax,0x118958

    free_list = free_list_store;
  10393b:	8b 45 80             	mov    -0x80(%ebp),%eax
  10393e:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103941:	a3 50 89 11 00       	mov    %eax,0x118950
  103946:	89 15 54 89 11 00    	mov    %edx,0x118954
    free_pages(p0, 5);
  10394c:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  103953:	00 
  103954:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103957:	89 04 24             	mov    %eax,(%esp)
  10395a:	e8 f4 03 00 00       	call   103d53 <free_pages>

    le = &free_list;
  10395f:	c7 45 ec 50 89 11 00 	movl   $0x118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103966:	eb 1d                	jmp    103985 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
  103968:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10396b:	83 e8 0c             	sub    $0xc,%eax
  10396e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  103971:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  103975:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103978:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10397b:	8b 40 08             	mov    0x8(%eax),%eax
  10397e:	29 c2                	sub    %eax,%edx
  103980:	89 d0                	mov    %edx,%eax
  103982:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103985:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103988:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  10398b:	8b 45 88             	mov    -0x78(%ebp),%eax
  10398e:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  103991:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103994:	81 7d ec 50 89 11 00 	cmpl   $0x118950,-0x14(%ebp)
  10399b:	75 cb                	jne    103968 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  10399d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1039a1:	74 24                	je     1039c7 <default_check+0x625>
  1039a3:	c7 44 24 0c 76 68 10 	movl   $0x106876,0xc(%esp)
  1039aa:	00 
  1039ab:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  1039b2:	00 
  1039b3:	c7 44 24 04 46 01 00 	movl   $0x146,0x4(%esp)
  1039ba:	00 
  1039bb:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  1039c2:	e8 10 d3 ff ff       	call   100cd7 <__panic>
    assert(total == 0);
  1039c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1039cb:	74 24                	je     1039f1 <default_check+0x64f>
  1039cd:	c7 44 24 0c 81 68 10 	movl   $0x106881,0xc(%esp)
  1039d4:	00 
  1039d5:	c7 44 24 08 56 65 10 	movl   $0x106556,0x8(%esp)
  1039dc:	00 
  1039dd:	c7 44 24 04 47 01 00 	movl   $0x147,0x4(%esp)
  1039e4:	00 
  1039e5:	c7 04 24 6b 65 10 00 	movl   $0x10656b,(%esp)
  1039ec:	e8 e6 d2 ff ff       	call   100cd7 <__panic>
}
  1039f1:	81 c4 94 00 00 00    	add    $0x94,%esp
  1039f7:	5b                   	pop    %ebx
  1039f8:	5d                   	pop    %ebp
  1039f9:	c3                   	ret    

001039fa <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  1039fa:	55                   	push   %ebp
  1039fb:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1039fd:	8b 55 08             	mov    0x8(%ebp),%edx
  103a00:	a1 64 89 11 00       	mov    0x118964,%eax
  103a05:	29 c2                	sub    %eax,%edx
  103a07:	89 d0                	mov    %edx,%eax
  103a09:	c1 f8 02             	sar    $0x2,%eax
  103a0c:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  103a12:	5d                   	pop    %ebp
  103a13:	c3                   	ret    

00103a14 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  103a14:	55                   	push   %ebp
  103a15:	89 e5                	mov    %esp,%ebp
  103a17:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  103a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  103a1d:	89 04 24             	mov    %eax,(%esp)
  103a20:	e8 d5 ff ff ff       	call   1039fa <page2ppn>
  103a25:	c1 e0 0c             	shl    $0xc,%eax
}
  103a28:	c9                   	leave  
  103a29:	c3                   	ret    

00103a2a <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  103a2a:	55                   	push   %ebp
  103a2b:	89 e5                	mov    %esp,%ebp
  103a2d:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  103a30:	8b 45 08             	mov    0x8(%ebp),%eax
  103a33:	c1 e8 0c             	shr    $0xc,%eax
  103a36:	89 c2                	mov    %eax,%edx
  103a38:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103a3d:	39 c2                	cmp    %eax,%edx
  103a3f:	72 1c                	jb     103a5d <pa2page+0x33>
        panic("pa2page called with invalid pa");
  103a41:	c7 44 24 08 bc 68 10 	movl   $0x1068bc,0x8(%esp)
  103a48:	00 
  103a49:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  103a50:	00 
  103a51:	c7 04 24 db 68 10 00 	movl   $0x1068db,(%esp)
  103a58:	e8 7a d2 ff ff       	call   100cd7 <__panic>
    }
    return &pages[PPN(pa)];
  103a5d:	8b 0d 64 89 11 00    	mov    0x118964,%ecx
  103a63:	8b 45 08             	mov    0x8(%ebp),%eax
  103a66:	c1 e8 0c             	shr    $0xc,%eax
  103a69:	89 c2                	mov    %eax,%edx
  103a6b:	89 d0                	mov    %edx,%eax
  103a6d:	c1 e0 02             	shl    $0x2,%eax
  103a70:	01 d0                	add    %edx,%eax
  103a72:	c1 e0 02             	shl    $0x2,%eax
  103a75:	01 c8                	add    %ecx,%eax
}
  103a77:	c9                   	leave  
  103a78:	c3                   	ret    

00103a79 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  103a79:	55                   	push   %ebp
  103a7a:	89 e5                	mov    %esp,%ebp
  103a7c:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  103a82:	89 04 24             	mov    %eax,(%esp)
  103a85:	e8 8a ff ff ff       	call   103a14 <page2pa>
  103a8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a90:	c1 e8 0c             	shr    $0xc,%eax
  103a93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103a96:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103a9b:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103a9e:	72 23                	jb     103ac3 <page2kva+0x4a>
  103aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103aa3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103aa7:	c7 44 24 08 ec 68 10 	movl   $0x1068ec,0x8(%esp)
  103aae:	00 
  103aaf:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103ab6:	00 
  103ab7:	c7 04 24 db 68 10 00 	movl   $0x1068db,(%esp)
  103abe:	e8 14 d2 ff ff       	call   100cd7 <__panic>
  103ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ac6:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103acb:	c9                   	leave  
  103acc:	c3                   	ret    

00103acd <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  103acd:	55                   	push   %ebp
  103ace:	89 e5                	mov    %esp,%ebp
  103ad0:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  103ad6:	83 e0 01             	and    $0x1,%eax
  103ad9:	85 c0                	test   %eax,%eax
  103adb:	75 1c                	jne    103af9 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103add:	c7 44 24 08 10 69 10 	movl   $0x106910,0x8(%esp)
  103ae4:	00 
  103ae5:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103aec:	00 
  103aed:	c7 04 24 db 68 10 00 	movl   $0x1068db,(%esp)
  103af4:	e8 de d1 ff ff       	call   100cd7 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  103af9:	8b 45 08             	mov    0x8(%ebp),%eax
  103afc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103b01:	89 04 24             	mov    %eax,(%esp)
  103b04:	e8 21 ff ff ff       	call   103a2a <pa2page>
}
  103b09:	c9                   	leave  
  103b0a:	c3                   	ret    

00103b0b <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  103b0b:	55                   	push   %ebp
  103b0c:	89 e5                	mov    %esp,%ebp
  103b0e:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  103b11:	8b 45 08             	mov    0x8(%ebp),%eax
  103b14:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103b19:	89 04 24             	mov    %eax,(%esp)
  103b1c:	e8 09 ff ff ff       	call   103a2a <pa2page>
}
  103b21:	c9                   	leave  
  103b22:	c3                   	ret    

00103b23 <page_ref>:

static inline int
page_ref(struct Page *page) {
  103b23:	55                   	push   %ebp
  103b24:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103b26:	8b 45 08             	mov    0x8(%ebp),%eax
  103b29:	8b 00                	mov    (%eax),%eax
}
  103b2b:	5d                   	pop    %ebp
  103b2c:	c3                   	ret    

00103b2d <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
  103b2d:	55                   	push   %ebp
  103b2e:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103b30:	8b 45 08             	mov    0x8(%ebp),%eax
  103b33:	8b 00                	mov    (%eax),%eax
  103b35:	8d 50 01             	lea    0x1(%eax),%edx
  103b38:	8b 45 08             	mov    0x8(%ebp),%eax
  103b3b:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  103b40:	8b 00                	mov    (%eax),%eax
}
  103b42:	5d                   	pop    %ebp
  103b43:	c3                   	ret    

00103b44 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103b44:	55                   	push   %ebp
  103b45:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103b47:	8b 45 08             	mov    0x8(%ebp),%eax
  103b4a:	8b 00                	mov    (%eax),%eax
  103b4c:	8d 50 ff             	lea    -0x1(%eax),%edx
  103b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  103b52:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103b54:	8b 45 08             	mov    0x8(%ebp),%eax
  103b57:	8b 00                	mov    (%eax),%eax
}
  103b59:	5d                   	pop    %ebp
  103b5a:	c3                   	ret    

00103b5b <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  103b5b:	55                   	push   %ebp
  103b5c:	89 e5                	mov    %esp,%ebp
  103b5e:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103b61:	9c                   	pushf  
  103b62:	58                   	pop    %eax
  103b63:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103b69:	25 00 02 00 00       	and    $0x200,%eax
  103b6e:	85 c0                	test   %eax,%eax
  103b70:	74 0c                	je     103b7e <__intr_save+0x23>
        intr_disable();
  103b72:	e8 43 db ff ff       	call   1016ba <intr_disable>
        return 1;
  103b77:	b8 01 00 00 00       	mov    $0x1,%eax
  103b7c:	eb 05                	jmp    103b83 <__intr_save+0x28>
    }
    return 0;
  103b7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103b83:	c9                   	leave  
  103b84:	c3                   	ret    

00103b85 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  103b85:	55                   	push   %ebp
  103b86:	89 e5                	mov    %esp,%ebp
  103b88:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103b8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103b8f:	74 05                	je     103b96 <__intr_restore+0x11>
        intr_enable();
  103b91:	e8 1e db ff ff       	call   1016b4 <intr_enable>
    }
}
  103b96:	c9                   	leave  
  103b97:	c3                   	ret    

00103b98 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103b98:	55                   	push   %ebp
  103b99:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  103b9e:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103ba1:	b8 23 00 00 00       	mov    $0x23,%eax
  103ba6:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103ba8:	b8 23 00 00 00       	mov    $0x23,%eax
  103bad:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103baf:	b8 10 00 00 00       	mov    $0x10,%eax
  103bb4:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103bb6:	b8 10 00 00 00       	mov    $0x10,%eax
  103bbb:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103bbd:	b8 10 00 00 00       	mov    $0x10,%eax
  103bc2:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103bc4:	ea cb 3b 10 00 08 00 	ljmp   $0x8,$0x103bcb
}
  103bcb:	5d                   	pop    %ebp
  103bcc:	c3                   	ret    

00103bcd <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103bcd:	55                   	push   %ebp
  103bce:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  103bd3:	a3 e4 88 11 00       	mov    %eax,0x1188e4
}
  103bd8:	5d                   	pop    %ebp
  103bd9:	c3                   	ret    

00103bda <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103bda:	55                   	push   %ebp
  103bdb:	89 e5                	mov    %esp,%ebp
  103bdd:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103be0:	b8 00 70 11 00       	mov    $0x117000,%eax
  103be5:	89 04 24             	mov    %eax,(%esp)
  103be8:	e8 e0 ff ff ff       	call   103bcd <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103bed:	66 c7 05 e8 88 11 00 	movw   $0x10,0x1188e8
  103bf4:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103bf6:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  103bfd:	68 00 
  103bff:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103c04:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  103c0a:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103c0f:	c1 e8 10             	shr    $0x10,%eax
  103c12:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  103c17:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103c1e:	83 e0 f0             	and    $0xfffffff0,%eax
  103c21:	83 c8 09             	or     $0x9,%eax
  103c24:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103c29:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103c30:	83 e0 ef             	and    $0xffffffef,%eax
  103c33:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103c38:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103c3f:	83 e0 9f             	and    $0xffffff9f,%eax
  103c42:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103c47:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103c4e:	83 c8 80             	or     $0xffffff80,%eax
  103c51:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103c56:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c5d:	83 e0 f0             	and    $0xfffffff0,%eax
  103c60:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c65:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c6c:	83 e0 ef             	and    $0xffffffef,%eax
  103c6f:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c74:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c7b:	83 e0 df             	and    $0xffffffdf,%eax
  103c7e:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c83:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c8a:	83 c8 40             	or     $0x40,%eax
  103c8d:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c92:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c99:	83 e0 7f             	and    $0x7f,%eax
  103c9c:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103ca1:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103ca6:	c1 e8 18             	shr    $0x18,%eax
  103ca9:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103cae:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  103cb5:	e8 de fe ff ff       	call   103b98 <lgdt>
  103cba:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103cc0:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103cc4:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  103cc7:	c9                   	leave  
  103cc8:	c3                   	ret    

00103cc9 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103cc9:	55                   	push   %ebp
  103cca:	89 e5                	mov    %esp,%ebp
  103ccc:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103ccf:	c7 05 5c 89 11 00 a0 	movl   $0x1068a0,0x11895c
  103cd6:	68 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103cd9:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103cde:	8b 00                	mov    (%eax),%eax
  103ce0:	89 44 24 04          	mov    %eax,0x4(%esp)
  103ce4:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  103ceb:	e8 4c c6 ff ff       	call   10033c <cprintf>
    pmm_manager->init();
  103cf0:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103cf5:	8b 40 04             	mov    0x4(%eax),%eax
  103cf8:	ff d0                	call   *%eax
}
  103cfa:	c9                   	leave  
  103cfb:	c3                   	ret    

00103cfc <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103cfc:	55                   	push   %ebp
  103cfd:	89 e5                	mov    %esp,%ebp
  103cff:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103d02:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103d07:	8b 40 08             	mov    0x8(%eax),%eax
  103d0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  103d0d:	89 54 24 04          	mov    %edx,0x4(%esp)
  103d11:	8b 55 08             	mov    0x8(%ebp),%edx
  103d14:	89 14 24             	mov    %edx,(%esp)
  103d17:	ff d0                	call   *%eax
}
  103d19:	c9                   	leave  
  103d1a:	c3                   	ret    

00103d1b <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103d1b:	55                   	push   %ebp
  103d1c:	89 e5                	mov    %esp,%ebp
  103d1e:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103d21:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103d28:	e8 2e fe ff ff       	call   103b5b <__intr_save>
  103d2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103d30:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103d35:	8b 40 0c             	mov    0xc(%eax),%eax
  103d38:	8b 55 08             	mov    0x8(%ebp),%edx
  103d3b:	89 14 24             	mov    %edx,(%esp)
  103d3e:	ff d0                	call   *%eax
  103d40:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103d43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103d46:	89 04 24             	mov    %eax,(%esp)
  103d49:	e8 37 fe ff ff       	call   103b85 <__intr_restore>
    return page;
  103d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103d51:	c9                   	leave  
  103d52:	c3                   	ret    

00103d53 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103d53:	55                   	push   %ebp
  103d54:	89 e5                	mov    %esp,%ebp
  103d56:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103d59:	e8 fd fd ff ff       	call   103b5b <__intr_save>
  103d5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103d61:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103d66:	8b 40 10             	mov    0x10(%eax),%eax
  103d69:	8b 55 0c             	mov    0xc(%ebp),%edx
  103d6c:	89 54 24 04          	mov    %edx,0x4(%esp)
  103d70:	8b 55 08             	mov    0x8(%ebp),%edx
  103d73:	89 14 24             	mov    %edx,(%esp)
  103d76:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d7b:	89 04 24             	mov    %eax,(%esp)
  103d7e:	e8 02 fe ff ff       	call   103b85 <__intr_restore>
}
  103d83:	c9                   	leave  
  103d84:	c3                   	ret    

00103d85 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103d85:	55                   	push   %ebp
  103d86:	89 e5                	mov    %esp,%ebp
  103d88:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103d8b:	e8 cb fd ff ff       	call   103b5b <__intr_save>
  103d90:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103d93:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103d98:	8b 40 14             	mov    0x14(%eax),%eax
  103d9b:	ff d0                	call   *%eax
  103d9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103da3:	89 04 24             	mov    %eax,(%esp)
  103da6:	e8 da fd ff ff       	call   103b85 <__intr_restore>
    return ret;
  103dab:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103dae:	c9                   	leave  
  103daf:	c3                   	ret    

00103db0 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  103db0:	55                   	push   %ebp
  103db1:	89 e5                	mov    %esp,%ebp
  103db3:	57                   	push   %edi
  103db4:	56                   	push   %esi
  103db5:	53                   	push   %ebx
  103db6:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  103dbc:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  103dc3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103dca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  103dd1:	c7 04 24 53 69 10 00 	movl   $0x106953,(%esp)
  103dd8:	e8 5f c5 ff ff       	call   10033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103ddd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103de4:	e9 15 01 00 00       	jmp    103efe <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103de9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103dec:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103def:	89 d0                	mov    %edx,%eax
  103df1:	c1 e0 02             	shl    $0x2,%eax
  103df4:	01 d0                	add    %edx,%eax
  103df6:	c1 e0 02             	shl    $0x2,%eax
  103df9:	01 c8                	add    %ecx,%eax
  103dfb:	8b 50 08             	mov    0x8(%eax),%edx
  103dfe:	8b 40 04             	mov    0x4(%eax),%eax
  103e01:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103e04:	89 55 bc             	mov    %edx,-0x44(%ebp)
  103e07:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e0a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e0d:	89 d0                	mov    %edx,%eax
  103e0f:	c1 e0 02             	shl    $0x2,%eax
  103e12:	01 d0                	add    %edx,%eax
  103e14:	c1 e0 02             	shl    $0x2,%eax
  103e17:	01 c8                	add    %ecx,%eax
  103e19:	8b 48 0c             	mov    0xc(%eax),%ecx
  103e1c:	8b 58 10             	mov    0x10(%eax),%ebx
  103e1f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103e22:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103e25:	01 c8                	add    %ecx,%eax
  103e27:	11 da                	adc    %ebx,%edx
  103e29:	89 45 b0             	mov    %eax,-0x50(%ebp)
  103e2c:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  103e2f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e32:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e35:	89 d0                	mov    %edx,%eax
  103e37:	c1 e0 02             	shl    $0x2,%eax
  103e3a:	01 d0                	add    %edx,%eax
  103e3c:	c1 e0 02             	shl    $0x2,%eax
  103e3f:	01 c8                	add    %ecx,%eax
  103e41:	83 c0 14             	add    $0x14,%eax
  103e44:	8b 00                	mov    (%eax),%eax
  103e46:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  103e4c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103e4f:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103e52:	83 c0 ff             	add    $0xffffffff,%eax
  103e55:	83 d2 ff             	adc    $0xffffffff,%edx
  103e58:	89 c6                	mov    %eax,%esi
  103e5a:	89 d7                	mov    %edx,%edi
  103e5c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e5f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e62:	89 d0                	mov    %edx,%eax
  103e64:	c1 e0 02             	shl    $0x2,%eax
  103e67:	01 d0                	add    %edx,%eax
  103e69:	c1 e0 02             	shl    $0x2,%eax
  103e6c:	01 c8                	add    %ecx,%eax
  103e6e:	8b 48 0c             	mov    0xc(%eax),%ecx
  103e71:	8b 58 10             	mov    0x10(%eax),%ebx
  103e74:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  103e7a:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  103e7e:	89 74 24 14          	mov    %esi,0x14(%esp)
  103e82:	89 7c 24 18          	mov    %edi,0x18(%esp)
  103e86:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103e89:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103e8c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103e90:	89 54 24 10          	mov    %edx,0x10(%esp)
  103e94:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103e98:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103e9c:	c7 04 24 60 69 10 00 	movl   $0x106960,(%esp)
  103ea3:	e8 94 c4 ff ff       	call   10033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  103ea8:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103eab:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103eae:	89 d0                	mov    %edx,%eax
  103eb0:	c1 e0 02             	shl    $0x2,%eax
  103eb3:	01 d0                	add    %edx,%eax
  103eb5:	c1 e0 02             	shl    $0x2,%eax
  103eb8:	01 c8                	add    %ecx,%eax
  103eba:	83 c0 14             	add    $0x14,%eax
  103ebd:	8b 00                	mov    (%eax),%eax
  103ebf:	83 f8 01             	cmp    $0x1,%eax
  103ec2:	75 36                	jne    103efa <page_init+0x14a>
			// ARM: not reserved
            if (maxpa < end && begin < KMEMSIZE) {
  103ec4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103ec7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103eca:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103ecd:	77 2b                	ja     103efa <page_init+0x14a>
  103ecf:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103ed2:	72 05                	jb     103ed9 <page_init+0x129>
  103ed4:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  103ed7:	73 21                	jae    103efa <page_init+0x14a>
  103ed9:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103edd:	77 1b                	ja     103efa <page_init+0x14a>
  103edf:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103ee3:	72 09                	jb     103eee <page_init+0x13e>
  103ee5:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  103eec:	77 0c                	ja     103efa <page_init+0x14a>
                maxpa = end;
  103eee:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103ef1:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103ef4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103ef7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103efa:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103efe:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103f01:	8b 00                	mov    (%eax),%eax
  103f03:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103f06:	0f 8f dd fe ff ff    	jg     103de9 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  103f0c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103f10:	72 1d                	jb     103f2f <page_init+0x17f>
  103f12:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103f16:	77 09                	ja     103f21 <page_init+0x171>
  103f18:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  103f1f:	76 0e                	jbe    103f2f <page_init+0x17f>
        maxpa = KMEMSIZE;
  103f21:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  103f28:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];   // 此end为kernel的结尾，也正是可分配的内存页的开始
	// 按照看到的最大物理地址，计算出页数
    npage = maxpa / PGSIZE;
  103f2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103f32:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103f35:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103f39:	c1 ea 0c             	shr    $0xc,%edx
  103f3c:	a3 c0 88 11 00       	mov    %eax,0x1188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  103f41:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  103f48:	b8 68 89 11 00       	mov    $0x118968,%eax
  103f4d:	8d 50 ff             	lea    -0x1(%eax),%edx
  103f50:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103f53:	01 d0                	add    %edx,%eax
  103f55:	89 45 a8             	mov    %eax,-0x58(%ebp)
  103f58:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103f5b:	ba 00 00 00 00       	mov    $0x0,%edx
  103f60:	f7 75 ac             	divl   -0x54(%ebp)
  103f63:	89 d0                	mov    %edx,%eax
  103f65:	8b 55 a8             	mov    -0x58(%ebp),%edx
  103f68:	29 c2                	sub    %eax,%edx
  103f6a:	89 d0                	mov    %edx,%eax
  103f6c:	a3 64 89 11 00       	mov    %eax,0x118964
	// cprintf("maxpa: %08llx, end: %08llx, npage: %08llx, pages: %08llx \n",
	//		maxpa, (uint64_t)&end, (uint64_t)npage, (uint64_t)pages);
	// 这里的end地址是带0xC偏移的，因为现在的ucore正运行在段机制下
	
	// 先把所有页设置为reserved，后面再说（init memmap的时候会assert这一点）
    for (i = 0; i < npage; i ++) {
  103f71:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103f78:	eb 2f                	jmp    103fa9 <page_init+0x1f9>
        SetPageReserved(pages + i);
  103f7a:	8b 0d 64 89 11 00    	mov    0x118964,%ecx
  103f80:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f83:	89 d0                	mov    %edx,%eax
  103f85:	c1 e0 02             	shl    $0x2,%eax
  103f88:	01 d0                	add    %edx,%eax
  103f8a:	c1 e0 02             	shl    $0x2,%eax
  103f8d:	01 c8                	add    %ecx,%eax
  103f8f:	83 c0 04             	add    $0x4,%eax
  103f92:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  103f99:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103f9c:	8b 45 8c             	mov    -0x74(%ebp),%eax
  103f9f:	8b 55 90             	mov    -0x70(%ebp),%edx
  103fa2:	0f ab 10             	bts    %edx,(%eax)
	// cprintf("maxpa: %08llx, end: %08llx, npage: %08llx, pages: %08llx \n",
	//		maxpa, (uint64_t)&end, (uint64_t)npage, (uint64_t)pages);
	// 这里的end地址是带0xC偏移的，因为现在的ucore正运行在段机制下
	
	// 先把所有页设置为reserved，后面再说（init memmap的时候会assert这一点）
    for (i = 0; i < npage; i ++) {
  103fa5:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103fa9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103fac:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103fb1:	39 c2                	cmp    %eax,%edx
  103fb3:	72 c5                	jb     103f7a <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);  // pages的结尾地址,转换成了物理地址(-0xC0000000)
  103fb5:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  103fbb:	89 d0                	mov    %edx,%eax
  103fbd:	c1 e0 02             	shl    $0x2,%eax
  103fc0:	01 d0                	add    %edx,%eax
  103fc2:	c1 e0 02             	shl    $0x2,%eax
  103fc5:	89 c2                	mov    %eax,%edx
  103fc7:	a1 64 89 11 00       	mov    0x118964,%eax
  103fcc:	01 d0                	add    %edx,%eax
  103fce:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  103fd1:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  103fd8:	77 23                	ja     103ffd <page_init+0x24d>
  103fda:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103fdd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103fe1:	c7 44 24 08 90 69 10 	movl   $0x106990,0x8(%esp)
  103fe8:	00 
  103fe9:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
  103ff0:	00 
  103ff1:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  103ff8:	e8 da cc ff ff       	call   100cd7 <__panic>
  103ffd:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104000:	05 00 00 00 40       	add    $0x40000000,%eax
  104005:	89 45 a0             	mov    %eax,-0x60(%ebp)
	// 我们能分配的页地址在页表之后
    for (i = 0; i < memmap->nr_map; i ++) {
  104008:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10400f:	e9 74 01 00 00       	jmp    104188 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  104014:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104017:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10401a:	89 d0                	mov    %edx,%eax
  10401c:	c1 e0 02             	shl    $0x2,%eax
  10401f:	01 d0                	add    %edx,%eax
  104021:	c1 e0 02             	shl    $0x2,%eax
  104024:	01 c8                	add    %ecx,%eax
  104026:	8b 50 08             	mov    0x8(%eax),%edx
  104029:	8b 40 04             	mov    0x4(%eax),%eax
  10402c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10402f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104032:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104035:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104038:	89 d0                	mov    %edx,%eax
  10403a:	c1 e0 02             	shl    $0x2,%eax
  10403d:	01 d0                	add    %edx,%eax
  10403f:	c1 e0 02             	shl    $0x2,%eax
  104042:	01 c8                	add    %ecx,%eax
  104044:	8b 48 0c             	mov    0xc(%eax),%ecx
  104047:	8b 58 10             	mov    0x10(%eax),%ebx
  10404a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10404d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104050:	01 c8                	add    %ecx,%eax
  104052:	11 da                	adc    %ebx,%edx
  104054:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104057:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  10405a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10405d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104060:	89 d0                	mov    %edx,%eax
  104062:	c1 e0 02             	shl    $0x2,%eax
  104065:	01 d0                	add    %edx,%eax
  104067:	c1 e0 02             	shl    $0x2,%eax
  10406a:	01 c8                	add    %ecx,%eax
  10406c:	83 c0 14             	add    $0x14,%eax
  10406f:	8b 00                	mov    (%eax),%eax
  104071:	83 f8 01             	cmp    $0x1,%eax
  104074:	0f 85 0a 01 00 00    	jne    104184 <page_init+0x3d4>
            if (begin < freemem) {
  10407a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  10407d:	ba 00 00 00 00       	mov    $0x0,%edx
  104082:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  104085:	72 17                	jb     10409e <page_init+0x2ee>
  104087:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10408a:	77 05                	ja     104091 <page_init+0x2e1>
  10408c:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  10408f:	76 0d                	jbe    10409e <page_init+0x2ee>
                begin = freemem;
  104091:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104094:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104097:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
				// cprintf("begin: %08llx, freemem: %08llx \n", begin, (uint64_t)freemem);
            }
            if (end > KMEMSIZE) {
  10409e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  1040a2:	72 1d                	jb     1040c1 <page_init+0x311>
  1040a4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  1040a8:	77 09                	ja     1040b3 <page_init+0x303>
  1040aa:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  1040b1:	76 0e                	jbe    1040c1 <page_init+0x311>
                end = KMEMSIZE;
  1040b3:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  1040ba:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  1040c1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1040c4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1040c7:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1040ca:	0f 87 b4 00 00 00    	ja     104184 <page_init+0x3d4>
  1040d0:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1040d3:	72 09                	jb     1040de <page_init+0x32e>
  1040d5:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1040d8:	0f 83 a6 00 00 00    	jae    104184 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
  1040de:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  1040e5:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1040e8:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1040eb:	01 d0                	add    %edx,%eax
  1040ed:	83 e8 01             	sub    $0x1,%eax
  1040f0:	89 45 98             	mov    %eax,-0x68(%ebp)
  1040f3:	8b 45 98             	mov    -0x68(%ebp),%eax
  1040f6:	ba 00 00 00 00       	mov    $0x0,%edx
  1040fb:	f7 75 9c             	divl   -0x64(%ebp)
  1040fe:	89 d0                	mov    %edx,%eax
  104100:	8b 55 98             	mov    -0x68(%ebp),%edx
  104103:	29 c2                	sub    %eax,%edx
  104105:	89 d0                	mov    %edx,%eax
  104107:	ba 00 00 00 00       	mov    $0x0,%edx
  10410c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10410f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  104112:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104115:	89 45 94             	mov    %eax,-0x6c(%ebp)
  104118:	8b 45 94             	mov    -0x6c(%ebp),%eax
  10411b:	ba 00 00 00 00       	mov    $0x0,%edx
  104120:	89 c7                	mov    %eax,%edi
  104122:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  104128:	89 7d 80             	mov    %edi,-0x80(%ebp)
  10412b:	89 d0                	mov    %edx,%eax
  10412d:	83 e0 00             	and    $0x0,%eax
  104130:	89 45 84             	mov    %eax,-0x7c(%ebp)
  104133:	8b 45 80             	mov    -0x80(%ebp),%eax
  104136:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104139:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10413c:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  10413f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104142:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104145:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104148:	77 3a                	ja     104184 <page_init+0x3d4>
  10414a:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10414d:	72 05                	jb     104154 <page_init+0x3a4>
  10414f:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  104152:	73 30                	jae    104184 <page_init+0x3d4>
					// 传入的第一个参数是pages数组中的对应项
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  104154:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  104157:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  10415a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10415d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104160:	29 c8                	sub    %ecx,%eax
  104162:	19 da                	sbb    %ebx,%edx
  104164:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  104168:	c1 ea 0c             	shr    $0xc,%edx
  10416b:	89 c3                	mov    %eax,%ebx
  10416d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104170:	89 04 24             	mov    %eax,(%esp)
  104173:	e8 b2 f8 ff ff       	call   103a2a <pa2page>
  104178:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10417c:	89 04 24             	mov    %eax,(%esp)
  10417f:	e8 78 fb ff ff       	call   103cfc <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);  // pages的结尾地址,转换成了物理地址(-0xC0000000)
	// 我们能分配的页地址在页表之后
    for (i = 0; i < memmap->nr_map; i ++) {
  104184:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  104188:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10418b:	8b 00                	mov    (%eax),%eax
  10418d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  104190:	0f 8f 7e fe ff ff    	jg     104014 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  104196:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  10419c:	5b                   	pop    %ebx
  10419d:	5e                   	pop    %esi
  10419e:	5f                   	pop    %edi
  10419f:	5d                   	pop    %ebp
  1041a0:	c3                   	ret    

001041a1 <enable_paging>:

static void
enable_paging(void) {
  1041a1:	55                   	push   %ebp
  1041a2:	89 e5                	mov    %esp,%ebp
  1041a4:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  1041a7:	a1 60 89 11 00       	mov    0x118960,%eax
  1041ac:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  1041af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1041b2:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  1041b5:	0f 20 c0             	mov    %cr0,%eax
  1041b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  1041bb:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  1041be:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  1041c1:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  1041c8:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
  1041cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1041cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  1041d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1041d5:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  1041d8:	c9                   	leave  
  1041d9:	c3                   	ret    

001041da <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  1041da:	55                   	push   %ebp
  1041db:	89 e5                	mov    %esp,%ebp
  1041dd:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  1041e0:	8b 45 14             	mov    0x14(%ebp),%eax
  1041e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  1041e6:	31 d0                	xor    %edx,%eax
  1041e8:	25 ff 0f 00 00       	and    $0xfff,%eax
  1041ed:	85 c0                	test   %eax,%eax
  1041ef:	74 24                	je     104215 <boot_map_segment+0x3b>
  1041f1:	c7 44 24 0c c2 69 10 	movl   $0x1069c2,0xc(%esp)
  1041f8:	00 
  1041f9:	c7 44 24 08 d9 69 10 	movl   $0x1069d9,0x8(%esp)
  104200:	00 
  104201:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  104208:	00 
  104209:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  104210:	e8 c2 ca ff ff       	call   100cd7 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  104215:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  10421c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10421f:	25 ff 0f 00 00       	and    $0xfff,%eax
  104224:	89 c2                	mov    %eax,%edx
  104226:	8b 45 10             	mov    0x10(%ebp),%eax
  104229:	01 c2                	add    %eax,%edx
  10422b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10422e:	01 d0                	add    %edx,%eax
  104230:	83 e8 01             	sub    $0x1,%eax
  104233:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104236:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104239:	ba 00 00 00 00       	mov    $0x0,%edx
  10423e:	f7 75 f0             	divl   -0x10(%ebp)
  104241:	89 d0                	mov    %edx,%eax
  104243:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104246:	29 c2                	sub    %eax,%edx
  104248:	89 d0                	mov    %edx,%eax
  10424a:	c1 e8 0c             	shr    $0xc,%eax
  10424d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  104250:	8b 45 0c             	mov    0xc(%ebp),%eax
  104253:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104256:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104259:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10425e:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  104261:	8b 45 14             	mov    0x14(%ebp),%eax
  104264:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104267:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10426a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10426f:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  104272:	eb 6b                	jmp    1042df <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  104274:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10427b:	00 
  10427c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10427f:	89 44 24 04          	mov    %eax,0x4(%esp)
  104283:	8b 45 08             	mov    0x8(%ebp),%eax
  104286:	89 04 24             	mov    %eax,(%esp)
  104289:	e8 cc 01 00 00       	call   10445a <get_pte>
  10428e:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  104291:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  104295:	75 24                	jne    1042bb <boot_map_segment+0xe1>
  104297:	c7 44 24 0c ee 69 10 	movl   $0x1069ee,0xc(%esp)
  10429e:	00 
  10429f:	c7 44 24 08 d9 69 10 	movl   $0x1069d9,0x8(%esp)
  1042a6:	00 
  1042a7:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
  1042ae:	00 
  1042af:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  1042b6:	e8 1c ca ff ff       	call   100cd7 <__panic>
        *ptep = pa | PTE_P | perm;
  1042bb:	8b 45 18             	mov    0x18(%ebp),%eax
  1042be:	8b 55 14             	mov    0x14(%ebp),%edx
  1042c1:	09 d0                	or     %edx,%eax
  1042c3:	83 c8 01             	or     $0x1,%eax
  1042c6:	89 c2                	mov    %eax,%edx
  1042c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1042cb:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1042cd:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1042d1:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  1042d8:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  1042df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1042e3:	75 8f                	jne    104274 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  1042e5:	c9                   	leave  
  1042e6:	c3                   	ret    

001042e7 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  1042e7:	55                   	push   %ebp
  1042e8:	89 e5                	mov    %esp,%ebp
  1042ea:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  1042ed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1042f4:	e8 22 fa ff ff       	call   103d1b <alloc_pages>
  1042f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  1042fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104300:	75 1c                	jne    10431e <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  104302:	c7 44 24 08 fb 69 10 	movl   $0x1069fb,0x8(%esp)
  104309:	00 
  10430a:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
  104311:	00 
  104312:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  104319:	e8 b9 c9 ff ff       	call   100cd7 <__panic>
    }
    return page2kva(p);
  10431e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104321:	89 04 24             	mov    %eax,(%esp)
  104324:	e8 50 f7 ff ff       	call   103a79 <page2kva>
}
  104329:	c9                   	leave  
  10432a:	c3                   	ret    

0010432b <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  10432b:	55                   	push   %ebp
  10432c:	89 e5                	mov    %esp,%ebp
  10432e:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  104331:	e8 93 f9 ff ff       	call   103cc9 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  104336:	e8 75 fa ff ff       	call   103db0 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  10433b:	e8 d7 02 00 00       	call   104617 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  104340:	e8 a2 ff ff ff       	call   1042e7 <boot_alloc_page>
  104345:	a3 c4 88 11 00       	mov    %eax,0x1188c4
    memset(boot_pgdir, 0, PGSIZE);
  10434a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10434f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104356:	00 
  104357:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10435e:	00 
  10435f:	89 04 24             	mov    %eax,(%esp)
  104362:	e8 14 19 00 00       	call   105c7b <memset>
    boot_cr3 = PADDR(boot_pgdir);
  104367:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10436c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10436f:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104376:	77 23                	ja     10439b <pmm_init+0x70>
  104378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10437b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10437f:	c7 44 24 08 90 69 10 	movl   $0x106990,0x8(%esp)
  104386:	00 
  104387:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  10438e:	00 
  10438f:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  104396:	e8 3c c9 ff ff       	call   100cd7 <__panic>
  10439b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10439e:	05 00 00 00 40       	add    $0x40000000,%eax
  1043a3:	a3 60 89 11 00       	mov    %eax,0x118960

    check_pgdir();
  1043a8:	e8 88 02 00 00       	call   104635 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  1043ad:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1043b2:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  1043b8:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1043bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1043c0:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1043c7:	77 23                	ja     1043ec <pmm_init+0xc1>
  1043c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1043cc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1043d0:	c7 44 24 08 90 69 10 	movl   $0x106990,0x8(%esp)
  1043d7:	00 
  1043d8:	c7 44 24 04 40 01 00 	movl   $0x140,0x4(%esp)
  1043df:	00 
  1043e0:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  1043e7:	e8 eb c8 ff ff       	call   100cd7 <__panic>
  1043ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1043ef:	05 00 00 00 40       	add    $0x40000000,%eax
  1043f4:	83 c8 03             	or     $0x3,%eax
  1043f7:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  1043f9:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1043fe:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  104405:	00 
  104406:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10440d:	00 
  10440e:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  104415:	38 
  104416:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  10441d:	c0 
  10441e:	89 04 24             	mov    %eax,(%esp)
  104421:	e8 b4 fd ff ff       	call   1041da <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  104426:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10442b:	8b 15 c4 88 11 00    	mov    0x1188c4,%edx
  104431:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  104437:	89 10                	mov    %edx,(%eax)

    enable_paging();
  104439:	e8 63 fd ff ff       	call   1041a1 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  10443e:	e8 97 f7 ff ff       	call   103bda <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  104443:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104448:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  10444e:	e8 7d 08 00 00       	call   104cd0 <check_boot_pgdir>

    print_pgdir();
  104453:	e8 05 0d 00 00       	call   10515d <print_pgdir>

}
  104458:	c9                   	leave  
  104459:	c3                   	ret    

0010445a <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  10445a:	55                   	push   %ebp
  10445b:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
  10445d:	5d                   	pop    %ebp
  10445e:	c3                   	ret    

0010445f <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  10445f:	55                   	push   %ebp
  104460:	89 e5                	mov    %esp,%ebp
  104462:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  104465:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10446c:	00 
  10446d:	8b 45 0c             	mov    0xc(%ebp),%eax
  104470:	89 44 24 04          	mov    %eax,0x4(%esp)
  104474:	8b 45 08             	mov    0x8(%ebp),%eax
  104477:	89 04 24             	mov    %eax,(%esp)
  10447a:	e8 db ff ff ff       	call   10445a <get_pte>
  10447f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  104482:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  104486:	74 08                	je     104490 <get_page+0x31>
        *ptep_store = ptep;
  104488:	8b 45 10             	mov    0x10(%ebp),%eax
  10448b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10448e:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  104490:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104494:	74 1b                	je     1044b1 <get_page+0x52>
  104496:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104499:	8b 00                	mov    (%eax),%eax
  10449b:	83 e0 01             	and    $0x1,%eax
  10449e:	85 c0                	test   %eax,%eax
  1044a0:	74 0f                	je     1044b1 <get_page+0x52>
        return pte2page(*ptep);
  1044a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044a5:	8b 00                	mov    (%eax),%eax
  1044a7:	89 04 24             	mov    %eax,(%esp)
  1044aa:	e8 1e f6 ff ff       	call   103acd <pte2page>
  1044af:	eb 05                	jmp    1044b6 <get_page+0x57>
    }
    return NULL;
  1044b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1044b6:	c9                   	leave  
  1044b7:	c3                   	ret    

001044b8 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1044b8:	55                   	push   %ebp
  1044b9:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
  1044bb:	5d                   	pop    %ebp
  1044bc:	c3                   	ret    

001044bd <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  1044bd:	55                   	push   %ebp
  1044be:	89 e5                	mov    %esp,%ebp
  1044c0:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1044c3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1044ca:	00 
  1044cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1044ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  1044d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1044d5:	89 04 24             	mov    %eax,(%esp)
  1044d8:	e8 7d ff ff ff       	call   10445a <get_pte>
  1044dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
  1044e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1044e4:	74 19                	je     1044ff <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  1044e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1044e9:	89 44 24 08          	mov    %eax,0x8(%esp)
  1044ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  1044f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1044f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1044f7:	89 04 24             	mov    %eax,(%esp)
  1044fa:	e8 b9 ff ff ff       	call   1044b8 <page_remove_pte>
    }
}
  1044ff:	c9                   	leave  
  104500:	c3                   	ret    

00104501 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  104501:	55                   	push   %ebp
  104502:	89 e5                	mov    %esp,%ebp
  104504:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  104507:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10450e:	00 
  10450f:	8b 45 10             	mov    0x10(%ebp),%eax
  104512:	89 44 24 04          	mov    %eax,0x4(%esp)
  104516:	8b 45 08             	mov    0x8(%ebp),%eax
  104519:	89 04 24             	mov    %eax,(%esp)
  10451c:	e8 39 ff ff ff       	call   10445a <get_pte>
  104521:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  104524:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104528:	75 0a                	jne    104534 <page_insert+0x33>
        return -E_NO_MEM;
  10452a:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  10452f:	e9 84 00 00 00       	jmp    1045b8 <page_insert+0xb7>
    }
    page_ref_inc(page);
  104534:	8b 45 0c             	mov    0xc(%ebp),%eax
  104537:	89 04 24             	mov    %eax,(%esp)
  10453a:	e8 ee f5 ff ff       	call   103b2d <page_ref_inc>
    if (*ptep & PTE_P) {
  10453f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104542:	8b 00                	mov    (%eax),%eax
  104544:	83 e0 01             	and    $0x1,%eax
  104547:	85 c0                	test   %eax,%eax
  104549:	74 3e                	je     104589 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  10454b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10454e:	8b 00                	mov    (%eax),%eax
  104550:	89 04 24             	mov    %eax,(%esp)
  104553:	e8 75 f5 ff ff       	call   103acd <pte2page>
  104558:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  10455b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10455e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104561:	75 0d                	jne    104570 <page_insert+0x6f>
            page_ref_dec(page);
  104563:	8b 45 0c             	mov    0xc(%ebp),%eax
  104566:	89 04 24             	mov    %eax,(%esp)
  104569:	e8 d6 f5 ff ff       	call   103b44 <page_ref_dec>
  10456e:	eb 19                	jmp    104589 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  104570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104573:	89 44 24 08          	mov    %eax,0x8(%esp)
  104577:	8b 45 10             	mov    0x10(%ebp),%eax
  10457a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10457e:	8b 45 08             	mov    0x8(%ebp),%eax
  104581:	89 04 24             	mov    %eax,(%esp)
  104584:	e8 2f ff ff ff       	call   1044b8 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  104589:	8b 45 0c             	mov    0xc(%ebp),%eax
  10458c:	89 04 24             	mov    %eax,(%esp)
  10458f:	e8 80 f4 ff ff       	call   103a14 <page2pa>
  104594:	0b 45 14             	or     0x14(%ebp),%eax
  104597:	83 c8 01             	or     $0x1,%eax
  10459a:	89 c2                	mov    %eax,%edx
  10459c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10459f:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  1045a1:	8b 45 10             	mov    0x10(%ebp),%eax
  1045a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1045a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1045ab:	89 04 24             	mov    %eax,(%esp)
  1045ae:	e8 07 00 00 00       	call   1045ba <tlb_invalidate>
    return 0;
  1045b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1045b8:	c9                   	leave  
  1045b9:	c3                   	ret    

001045ba <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  1045ba:	55                   	push   %ebp
  1045bb:	89 e5                	mov    %esp,%ebp
  1045bd:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  1045c0:	0f 20 d8             	mov    %cr3,%eax
  1045c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  1045c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  1045c9:	89 c2                	mov    %eax,%edx
  1045cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1045ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1045d1:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1045d8:	77 23                	ja     1045fd <tlb_invalidate+0x43>
  1045da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045dd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1045e1:	c7 44 24 08 90 69 10 	movl   $0x106990,0x8(%esp)
  1045e8:	00 
  1045e9:	c7 44 24 04 e0 01 00 	movl   $0x1e0,0x4(%esp)
  1045f0:	00 
  1045f1:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  1045f8:	e8 da c6 ff ff       	call   100cd7 <__panic>
  1045fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104600:	05 00 00 00 40       	add    $0x40000000,%eax
  104605:	39 c2                	cmp    %eax,%edx
  104607:	75 0c                	jne    104615 <tlb_invalidate+0x5b>
        invlpg((void *)la);
  104609:	8b 45 0c             	mov    0xc(%ebp),%eax
  10460c:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  10460f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104612:	0f 01 38             	invlpg (%eax)
    }
}
  104615:	c9                   	leave  
  104616:	c3                   	ret    

00104617 <check_alloc_page>:

static void
check_alloc_page(void) {
  104617:	55                   	push   %ebp
  104618:	89 e5                	mov    %esp,%ebp
  10461a:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  10461d:	a1 5c 89 11 00       	mov    0x11895c,%eax
  104622:	8b 40 18             	mov    0x18(%eax),%eax
  104625:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  104627:	c7 04 24 14 6a 10 00 	movl   $0x106a14,(%esp)
  10462e:	e8 09 bd ff ff       	call   10033c <cprintf>
}
  104633:	c9                   	leave  
  104634:	c3                   	ret    

00104635 <check_pgdir>:

static void
check_pgdir(void) {
  104635:	55                   	push   %ebp
  104636:	89 e5                	mov    %esp,%ebp
  104638:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  10463b:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104640:	3d 00 80 03 00       	cmp    $0x38000,%eax
  104645:	76 24                	jbe    10466b <check_pgdir+0x36>
  104647:	c7 44 24 0c 33 6a 10 	movl   $0x106a33,0xc(%esp)
  10464e:	00 
  10464f:	c7 44 24 08 d9 69 10 	movl   $0x1069d9,0x8(%esp)
  104656:	00 
  104657:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
  10465e:	00 
  10465f:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  104666:	e8 6c c6 ff ff       	call   100cd7 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  10466b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104670:	85 c0                	test   %eax,%eax
  104672:	74 0e                	je     104682 <check_pgdir+0x4d>
  104674:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104679:	25 ff 0f 00 00       	and    $0xfff,%eax
  10467e:	85 c0                	test   %eax,%eax
  104680:	74 24                	je     1046a6 <check_pgdir+0x71>
  104682:	c7 44 24 0c 50 6a 10 	movl   $0x106a50,0xc(%esp)
  104689:	00 
  10468a:	c7 44 24 08 d9 69 10 	movl   $0x1069d9,0x8(%esp)
  104691:	00 
  104692:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
  104699:	00 
  10469a:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  1046a1:	e8 31 c6 ff ff       	call   100cd7 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  1046a6:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1046ab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1046b2:	00 
  1046b3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1046ba:	00 
  1046bb:	89 04 24             	mov    %eax,(%esp)
  1046be:	e8 9c fd ff ff       	call   10445f <get_page>
  1046c3:	85 c0                	test   %eax,%eax
  1046c5:	74 24                	je     1046eb <check_pgdir+0xb6>
  1046c7:	c7 44 24 0c 88 6a 10 	movl   $0x106a88,0xc(%esp)
  1046ce:	00 
  1046cf:	c7 44 24 08 d9 69 10 	movl   $0x1069d9,0x8(%esp)
  1046d6:	00 
  1046d7:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
  1046de:	00 
  1046df:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  1046e6:	e8 ec c5 ff ff       	call   100cd7 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  1046eb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1046f2:	e8 24 f6 ff ff       	call   103d1b <alloc_pages>
  1046f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  1046fa:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1046ff:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104706:	00 
  104707:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10470e:	00 
  10470f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104712:	89 54 24 04          	mov    %edx,0x4(%esp)
  104716:	89 04 24             	mov    %eax,(%esp)
  104719:	e8 e3 fd ff ff       	call   104501 <page_insert>
  10471e:	85 c0                	test   %eax,%eax
  104720:	74 24                	je     104746 <check_pgdir+0x111>
  104722:	c7 44 24 0c b0 6a 10 	movl   $0x106ab0,0xc(%esp)
  104729:	00 
  10472a:	c7 44 24 08 d9 69 10 	movl   $0x1069d9,0x8(%esp)
  104731:	00 
  104732:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
  104739:	00 
  10473a:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  104741:	e8 91 c5 ff ff       	call   100cd7 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  104746:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10474b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104752:	00 
  104753:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10475a:	00 
  10475b:	89 04 24             	mov    %eax,(%esp)
  10475e:	e8 f7 fc ff ff       	call   10445a <get_pte>
  104763:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104766:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10476a:	75 24                	jne    104790 <check_pgdir+0x15b>
  10476c:	c7 44 24 0c dc 6a 10 	movl   $0x106adc,0xc(%esp)
  104773:	00 
  104774:	c7 44 24 08 d9 69 10 	movl   $0x1069d9,0x8(%esp)
  10477b:	00 
  10477c:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
  104783:	00 
  104784:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  10478b:	e8 47 c5 ff ff       	call   100cd7 <__panic>
    assert(pte2page(*ptep) == p1);
  104790:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104793:	8b 00                	mov    (%eax),%eax
  104795:	89 04 24             	mov    %eax,(%esp)
  104798:	e8 30 f3 ff ff       	call   103acd <pte2page>
  10479d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1047a0:	74 24                	je     1047c6 <check_pgdir+0x191>
  1047a2:	c7 44 24 0c 09 6b 10 	movl   $0x106b09,0xc(%esp)
  1047a9:	00 
  1047aa:	c7 44 24 08 d9 69 10 	movl   $0x1069d9,0x8(%esp)
  1047b1:	00 
  1047b2:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  1047b9:	00 
  1047ba:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  1047c1:	e8 11 c5 ff ff       	call   100cd7 <__panic>
    assert(page_ref(p1) == 1);
  1047c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047c9:	89 04 24             	mov    %eax,(%esp)
  1047cc:	e8 52 f3 ff ff       	call   103b23 <page_ref>
  1047d1:	83 f8 01             	cmp    $0x1,%eax
  1047d4:	74 24                	je     1047fa <check_pgdir+0x1c5>
  1047d6:	c7 44 24 0c 1f 6b 10 	movl   $0x106b1f,0xc(%esp)
  1047dd:	00 
  1047de:	c7 44 24 08 d9 69 10 	movl   $0x1069d9,0x8(%esp)
  1047e5:	00 
  1047e6:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
  1047ed:	00 
  1047ee:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  1047f5:	e8 dd c4 ff ff       	call   100cd7 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  1047fa:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1047ff:	8b 00                	mov    (%eax),%eax
  104801:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104806:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104809:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10480c:	c1 e8 0c             	shr    $0xc,%eax
  10480f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104812:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104817:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  10481a:	72 23                	jb     10483f <check_pgdir+0x20a>
  10481c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10481f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104823:	c7 44 24 08 ec 68 10 	movl   $0x1068ec,0x8(%esp)
  10482a:	00 
  10482b:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
  104832:	00 
  104833:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  10483a:	e8 98 c4 ff ff       	call   100cd7 <__panic>
  10483f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104842:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104847:	83 c0 04             	add    $0x4,%eax
  10484a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  10484d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104852:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104859:	00 
  10485a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104861:	00 
  104862:	89 04 24             	mov    %eax,(%esp)
  104865:	e8 f0 fb ff ff       	call   10445a <get_pte>
  10486a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  10486d:	74 24                	je     104893 <check_pgdir+0x25e>
  10486f:	c7 44 24 0c 34 6b 10 	movl   $0x106b34,0xc(%esp)
  104876:	00 
  104877:	c7 44 24 08 d9 69 10 	movl   $0x1069d9,0x8(%esp)
  10487e:	00 
  10487f:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
  104886:	00 
  104887:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  10488e:	e8 44 c4 ff ff       	call   100cd7 <__panic>

    p2 = alloc_page();
  104893:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10489a:	e8 7c f4 ff ff       	call   103d1b <alloc_pages>
  10489f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  1048a2:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1048a7:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  1048ae:	00 
  1048af:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1048b6:	00 
  1048b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1048ba:	89 54 24 04          	mov    %edx,0x4(%esp)
  1048be:	89 04 24             	mov    %eax,(%esp)
  1048c1:	e8 3b fc ff ff       	call   104501 <page_insert>
  1048c6:	85 c0                	test   %eax,%eax
  1048c8:	74 24                	je     1048ee <check_pgdir+0x2b9>
  1048ca:	c7 44 24 0c 5c 6b 10 	movl   $0x106b5c,0xc(%esp)
  1048d1:	00 
  1048d2:	c7 44 24 08 d9 69 10 	movl   $0x1069d9,0x8(%esp)
  1048d9:	00 
  1048da:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
  1048e1:	00 
  1048e2:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  1048e9:	e8 e9 c3 ff ff       	call   100cd7 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  1048ee:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1048f3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1048fa:	00 
  1048fb:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104902:	00 
  104903:	89 04 24             	mov    %eax,(%esp)
  104906:	e8 4f fb ff ff       	call   10445a <get_pte>
  10490b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10490e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104912:	75 24                	jne    104938 <check_pgdir+0x303>
  104914:	c7 44 24 0c 94 6b 10 	movl   $0x106b94,0xc(%esp)
  10491b:	00 
  10491c:	c7 44 24 08 d9 69 10 	movl   $0x1069d9,0x8(%esp)
  104923:	00 
  104924:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
  10492b:	00 
  10492c:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  104933:	e8 9f c3 ff ff       	call   100cd7 <__panic>
    assert(*ptep & PTE_U);
  104938:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10493b:	8b 00                	mov    (%eax),%eax
  10493d:	83 e0 04             	and    $0x4,%eax
  104940:	85 c0                	test   %eax,%eax
  104942:	75 24                	jne    104968 <check_pgdir+0x333>
  104944:	c7 44 24 0c c4 6b 10 	movl   $0x106bc4,0xc(%esp)
  10494b:	00 
  10494c:	c7 44 24 08 d9 69 10 	movl   $0x1069d9,0x8(%esp)
  104953:	00 
  104954:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  10495b:	00 
  10495c:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  104963:	e8 6f c3 ff ff       	call   100cd7 <__panic>
    assert(*ptep & PTE_W);
  104968:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10496b:	8b 00                	mov    (%eax),%eax
  10496d:	83 e0 02             	and    $0x2,%eax
  104970:	85 c0                	test   %eax,%eax
  104972:	75 24                	jne    104998 <check_pgdir+0x363>
  104974:	c7 44 24 0c d2 6b 10 	movl   $0x106bd2,0xc(%esp)
  10497b:	00 
  10497c:	c7 44 24 08 d9 69 10 	movl   $0x1069d9,0x8(%esp)
  104983:	00 
  104984:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
  10498b:	00 
  10498c:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  104993:	e8 3f c3 ff ff       	call   100cd7 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104998:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10499d:	8b 00                	mov    (%eax),%eax
  10499f:	83 e0 04             	and    $0x4,%eax
  1049a2:	85 c0                	test   %eax,%eax
  1049a4:	75 24                	jne    1049ca <check_pgdir+0x395>
  1049a6:	c7 44 24 0c e0 6b 10 	movl   $0x106be0,0xc(%esp)
  1049ad:	00 
  1049ae:	c7 44 24 08 d9 69 10 	movl   $0x1069d9,0x8(%esp)
  1049b5:	00 
  1049b6:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  1049bd:	00 
  1049be:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  1049c5:	e8 0d c3 ff ff       	call   100cd7 <__panic>
    assert(page_ref(p2) == 1);
  1049ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1049cd:	89 04 24             	mov    %eax,(%esp)
  1049d0:	e8 4e f1 ff ff       	call   103b23 <page_ref>
  1049d5:	83 f8 01             	cmp    $0x1,%eax
  1049d8:	74 24                	je     1049fe <check_pgdir+0x3c9>
  1049da:	c7 44 24 0c f6 6b 10 	movl   $0x106bf6,0xc(%esp)
  1049e1:	00 
  1049e2:	c7 44 24 08 d9 69 10 	movl   $0x1069d9,0x8(%esp)
  1049e9:	00 
  1049ea:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  1049f1:	00 
  1049f2:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  1049f9:	e8 d9 c2 ff ff       	call   100cd7 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  1049fe:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104a03:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104a0a:	00 
  104a0b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104a12:	00 
  104a13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104a16:	89 54 24 04          	mov    %edx,0x4(%esp)
  104a1a:	89 04 24             	mov    %eax,(%esp)
  104a1d:	e8 df fa ff ff       	call   104501 <page_insert>
  104a22:	85 c0                	test   %eax,%eax
  104a24:	74 24                	je     104a4a <check_pgdir+0x415>
  104a26:	c7 44 24 0c 08 6c 10 	movl   $0x106c08,0xc(%esp)
  104a2d:	00 
  104a2e:	c7 44 24 08 d9 69 10 	movl   $0x1069d9,0x8(%esp)
  104a35:	00 
  104a36:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
  104a3d:	00 
  104a3e:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  104a45:	e8 8d c2 ff ff       	call   100cd7 <__panic>
    assert(page_ref(p1) == 2);
  104a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a4d:	89 04 24             	mov    %eax,(%esp)
  104a50:	e8 ce f0 ff ff       	call   103b23 <page_ref>
  104a55:	83 f8 02             	cmp    $0x2,%eax
  104a58:	74 24                	je     104a7e <check_pgdir+0x449>
  104a5a:	c7 44 24 0c 34 6c 10 	movl   $0x106c34,0xc(%esp)
  104a61:	00 
  104a62:	c7 44 24 08 d9 69 10 	movl   $0x1069d9,0x8(%esp)
  104a69:	00 
  104a6a:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
  104a71:	00 
  104a72:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  104a79:	e8 59 c2 ff ff       	call   100cd7 <__panic>
    assert(page_ref(p2) == 0);
  104a7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104a81:	89 04 24             	mov    %eax,(%esp)
  104a84:	e8 9a f0 ff ff       	call   103b23 <page_ref>
  104a89:	85 c0                	test   %eax,%eax
  104a8b:	74 24                	je     104ab1 <check_pgdir+0x47c>
  104a8d:	c7 44 24 0c 46 6c 10 	movl   $0x106c46,0xc(%esp)
  104a94:	00 
  104a95:	c7 44 24 08 d9 69 10 	movl   $0x1069d9,0x8(%esp)
  104a9c:	00 
  104a9d:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  104aa4:	00 
  104aa5:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  104aac:	e8 26 c2 ff ff       	call   100cd7 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104ab1:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104ab6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104abd:	00 
  104abe:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104ac5:	00 
  104ac6:	89 04 24             	mov    %eax,(%esp)
  104ac9:	e8 8c f9 ff ff       	call   10445a <get_pte>
  104ace:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104ad1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104ad5:	75 24                	jne    104afb <check_pgdir+0x4c6>
  104ad7:	c7 44 24 0c 94 6b 10 	movl   $0x106b94,0xc(%esp)
  104ade:	00 
  104adf:	c7 44 24 08 d9 69 10 	movl   $0x1069d9,0x8(%esp)
  104ae6:	00 
  104ae7:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
  104aee:	00 
  104aef:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  104af6:	e8 dc c1 ff ff       	call   100cd7 <__panic>
    assert(pte2page(*ptep) == p1);
  104afb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104afe:	8b 00                	mov    (%eax),%eax
  104b00:	89 04 24             	mov    %eax,(%esp)
  104b03:	e8 c5 ef ff ff       	call   103acd <pte2page>
  104b08:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104b0b:	74 24                	je     104b31 <check_pgdir+0x4fc>
  104b0d:	c7 44 24 0c 09 6b 10 	movl   $0x106b09,0xc(%esp)
  104b14:	00 
  104b15:	c7 44 24 08 d9 69 10 	movl   $0x1069d9,0x8(%esp)
  104b1c:	00 
  104b1d:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  104b24:	00 
  104b25:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  104b2c:	e8 a6 c1 ff ff       	call   100cd7 <__panic>
    assert((*ptep & PTE_U) == 0);
  104b31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b34:	8b 00                	mov    (%eax),%eax
  104b36:	83 e0 04             	and    $0x4,%eax
  104b39:	85 c0                	test   %eax,%eax
  104b3b:	74 24                	je     104b61 <check_pgdir+0x52c>
  104b3d:	c7 44 24 0c 58 6c 10 	movl   $0x106c58,0xc(%esp)
  104b44:	00 
  104b45:	c7 44 24 08 d9 69 10 	movl   $0x1069d9,0x8(%esp)
  104b4c:	00 
  104b4d:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
  104b54:	00 
  104b55:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  104b5c:	e8 76 c1 ff ff       	call   100cd7 <__panic>

    page_remove(boot_pgdir, 0x0);
  104b61:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104b66:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104b6d:	00 
  104b6e:	89 04 24             	mov    %eax,(%esp)
  104b71:	e8 47 f9 ff ff       	call   1044bd <page_remove>
    assert(page_ref(p1) == 1);
  104b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b79:	89 04 24             	mov    %eax,(%esp)
  104b7c:	e8 a2 ef ff ff       	call   103b23 <page_ref>
  104b81:	83 f8 01             	cmp    $0x1,%eax
  104b84:	74 24                	je     104baa <check_pgdir+0x575>
  104b86:	c7 44 24 0c 1f 6b 10 	movl   $0x106b1f,0xc(%esp)
  104b8d:	00 
  104b8e:	c7 44 24 08 d9 69 10 	movl   $0x1069d9,0x8(%esp)
  104b95:	00 
  104b96:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  104b9d:	00 
  104b9e:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  104ba5:	e8 2d c1 ff ff       	call   100cd7 <__panic>
    assert(page_ref(p2) == 0);
  104baa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104bad:	89 04 24             	mov    %eax,(%esp)
  104bb0:	e8 6e ef ff ff       	call   103b23 <page_ref>
  104bb5:	85 c0                	test   %eax,%eax
  104bb7:	74 24                	je     104bdd <check_pgdir+0x5a8>
  104bb9:	c7 44 24 0c 46 6c 10 	movl   $0x106c46,0xc(%esp)
  104bc0:	00 
  104bc1:	c7 44 24 08 d9 69 10 	movl   $0x1069d9,0x8(%esp)
  104bc8:	00 
  104bc9:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
  104bd0:	00 
  104bd1:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  104bd8:	e8 fa c0 ff ff       	call   100cd7 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104bdd:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104be2:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104be9:	00 
  104bea:	89 04 24             	mov    %eax,(%esp)
  104bed:	e8 cb f8 ff ff       	call   1044bd <page_remove>
    assert(page_ref(p1) == 0);
  104bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104bf5:	89 04 24             	mov    %eax,(%esp)
  104bf8:	e8 26 ef ff ff       	call   103b23 <page_ref>
  104bfd:	85 c0                	test   %eax,%eax
  104bff:	74 24                	je     104c25 <check_pgdir+0x5f0>
  104c01:	c7 44 24 0c 6d 6c 10 	movl   $0x106c6d,0xc(%esp)
  104c08:	00 
  104c09:	c7 44 24 08 d9 69 10 	movl   $0x1069d9,0x8(%esp)
  104c10:	00 
  104c11:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
  104c18:	00 
  104c19:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  104c20:	e8 b2 c0 ff ff       	call   100cd7 <__panic>
    assert(page_ref(p2) == 0);
  104c25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c28:	89 04 24             	mov    %eax,(%esp)
  104c2b:	e8 f3 ee ff ff       	call   103b23 <page_ref>
  104c30:	85 c0                	test   %eax,%eax
  104c32:	74 24                	je     104c58 <check_pgdir+0x623>
  104c34:	c7 44 24 0c 46 6c 10 	movl   $0x106c46,0xc(%esp)
  104c3b:	00 
  104c3c:	c7 44 24 08 d9 69 10 	movl   $0x1069d9,0x8(%esp)
  104c43:	00 
  104c44:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
  104c4b:	00 
  104c4c:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  104c53:	e8 7f c0 ff ff       	call   100cd7 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  104c58:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104c5d:	8b 00                	mov    (%eax),%eax
  104c5f:	89 04 24             	mov    %eax,(%esp)
  104c62:	e8 a4 ee ff ff       	call   103b0b <pde2page>
  104c67:	89 04 24             	mov    %eax,(%esp)
  104c6a:	e8 b4 ee ff ff       	call   103b23 <page_ref>
  104c6f:	83 f8 01             	cmp    $0x1,%eax
  104c72:	74 24                	je     104c98 <check_pgdir+0x663>
  104c74:	c7 44 24 0c 80 6c 10 	movl   $0x106c80,0xc(%esp)
  104c7b:	00 
  104c7c:	c7 44 24 08 d9 69 10 	movl   $0x1069d9,0x8(%esp)
  104c83:	00 
  104c84:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  104c8b:	00 
  104c8c:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  104c93:	e8 3f c0 ff ff       	call   100cd7 <__panic>
    free_page(pde2page(boot_pgdir[0]));
  104c98:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104c9d:	8b 00                	mov    (%eax),%eax
  104c9f:	89 04 24             	mov    %eax,(%esp)
  104ca2:	e8 64 ee ff ff       	call   103b0b <pde2page>
  104ca7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104cae:	00 
  104caf:	89 04 24             	mov    %eax,(%esp)
  104cb2:	e8 9c f0 ff ff       	call   103d53 <free_pages>
    boot_pgdir[0] = 0;
  104cb7:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104cbc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  104cc2:	c7 04 24 a7 6c 10 00 	movl   $0x106ca7,(%esp)
  104cc9:	e8 6e b6 ff ff       	call   10033c <cprintf>
}
  104cce:	c9                   	leave  
  104ccf:	c3                   	ret    

00104cd0 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  104cd0:	55                   	push   %ebp
  104cd1:	89 e5                	mov    %esp,%ebp
  104cd3:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104cd6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104cdd:	e9 ca 00 00 00       	jmp    104dac <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  104ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ce5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104ce8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ceb:	c1 e8 0c             	shr    $0xc,%eax
  104cee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104cf1:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104cf6:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104cf9:	72 23                	jb     104d1e <check_boot_pgdir+0x4e>
  104cfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104cfe:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104d02:	c7 44 24 08 ec 68 10 	movl   $0x1068ec,0x8(%esp)
  104d09:	00 
  104d0a:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
  104d11:	00 
  104d12:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  104d19:	e8 b9 bf ff ff       	call   100cd7 <__panic>
  104d1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d21:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104d26:	89 c2                	mov    %eax,%edx
  104d28:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104d2d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104d34:	00 
  104d35:	89 54 24 04          	mov    %edx,0x4(%esp)
  104d39:	89 04 24             	mov    %eax,(%esp)
  104d3c:	e8 19 f7 ff ff       	call   10445a <get_pte>
  104d41:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104d44:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104d48:	75 24                	jne    104d6e <check_boot_pgdir+0x9e>
  104d4a:	c7 44 24 0c c4 6c 10 	movl   $0x106cc4,0xc(%esp)
  104d51:	00 
  104d52:	c7 44 24 08 d9 69 10 	movl   $0x1069d9,0x8(%esp)
  104d59:	00 
  104d5a:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
  104d61:	00 
  104d62:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  104d69:	e8 69 bf ff ff       	call   100cd7 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  104d6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104d71:	8b 00                	mov    (%eax),%eax
  104d73:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104d78:	89 c2                	mov    %eax,%edx
  104d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d7d:	39 c2                	cmp    %eax,%edx
  104d7f:	74 24                	je     104da5 <check_boot_pgdir+0xd5>
  104d81:	c7 44 24 0c 01 6d 10 	movl   $0x106d01,0xc(%esp)
  104d88:	00 
  104d89:	c7 44 24 08 d9 69 10 	movl   $0x1069d9,0x8(%esp)
  104d90:	00 
  104d91:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
  104d98:	00 
  104d99:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  104da0:	e8 32 bf ff ff       	call   100cd7 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104da5:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  104dac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104daf:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104db4:	39 c2                	cmp    %eax,%edx
  104db6:	0f 82 26 ff ff ff    	jb     104ce2 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  104dbc:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104dc1:	05 ac 0f 00 00       	add    $0xfac,%eax
  104dc6:	8b 00                	mov    (%eax),%eax
  104dc8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104dcd:	89 c2                	mov    %eax,%edx
  104dcf:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104dd4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104dd7:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  104dde:	77 23                	ja     104e03 <check_boot_pgdir+0x133>
  104de0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104de3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104de7:	c7 44 24 08 90 69 10 	movl   $0x106990,0x8(%esp)
  104dee:	00 
  104def:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
  104df6:	00 
  104df7:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  104dfe:	e8 d4 be ff ff       	call   100cd7 <__panic>
  104e03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e06:	05 00 00 00 40       	add    $0x40000000,%eax
  104e0b:	39 c2                	cmp    %eax,%edx
  104e0d:	74 24                	je     104e33 <check_boot_pgdir+0x163>
  104e0f:	c7 44 24 0c 18 6d 10 	movl   $0x106d18,0xc(%esp)
  104e16:	00 
  104e17:	c7 44 24 08 d9 69 10 	movl   $0x1069d9,0x8(%esp)
  104e1e:	00 
  104e1f:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
  104e26:	00 
  104e27:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  104e2e:	e8 a4 be ff ff       	call   100cd7 <__panic>

    assert(boot_pgdir[0] == 0);
  104e33:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104e38:	8b 00                	mov    (%eax),%eax
  104e3a:	85 c0                	test   %eax,%eax
  104e3c:	74 24                	je     104e62 <check_boot_pgdir+0x192>
  104e3e:	c7 44 24 0c 4c 6d 10 	movl   $0x106d4c,0xc(%esp)
  104e45:	00 
  104e46:	c7 44 24 08 d9 69 10 	movl   $0x1069d9,0x8(%esp)
  104e4d:	00 
  104e4e:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
  104e55:	00 
  104e56:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  104e5d:	e8 75 be ff ff       	call   100cd7 <__panic>

    struct Page *p;
    p = alloc_page();
  104e62:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104e69:	e8 ad ee ff ff       	call   103d1b <alloc_pages>
  104e6e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  104e71:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104e76:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104e7d:	00 
  104e7e:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  104e85:	00 
  104e86:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104e89:	89 54 24 04          	mov    %edx,0x4(%esp)
  104e8d:	89 04 24             	mov    %eax,(%esp)
  104e90:	e8 6c f6 ff ff       	call   104501 <page_insert>
  104e95:	85 c0                	test   %eax,%eax
  104e97:	74 24                	je     104ebd <check_boot_pgdir+0x1ed>
  104e99:	c7 44 24 0c 60 6d 10 	movl   $0x106d60,0xc(%esp)
  104ea0:	00 
  104ea1:	c7 44 24 08 d9 69 10 	movl   $0x1069d9,0x8(%esp)
  104ea8:	00 
  104ea9:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
  104eb0:	00 
  104eb1:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  104eb8:	e8 1a be ff ff       	call   100cd7 <__panic>
    assert(page_ref(p) == 1);
  104ebd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104ec0:	89 04 24             	mov    %eax,(%esp)
  104ec3:	e8 5b ec ff ff       	call   103b23 <page_ref>
  104ec8:	83 f8 01             	cmp    $0x1,%eax
  104ecb:	74 24                	je     104ef1 <check_boot_pgdir+0x221>
  104ecd:	c7 44 24 0c 8e 6d 10 	movl   $0x106d8e,0xc(%esp)
  104ed4:	00 
  104ed5:	c7 44 24 08 d9 69 10 	movl   $0x1069d9,0x8(%esp)
  104edc:	00 
  104edd:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
  104ee4:	00 
  104ee5:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  104eec:	e8 e6 bd ff ff       	call   100cd7 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  104ef1:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104ef6:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104efd:	00 
  104efe:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  104f05:	00 
  104f06:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104f09:	89 54 24 04          	mov    %edx,0x4(%esp)
  104f0d:	89 04 24             	mov    %eax,(%esp)
  104f10:	e8 ec f5 ff ff       	call   104501 <page_insert>
  104f15:	85 c0                	test   %eax,%eax
  104f17:	74 24                	je     104f3d <check_boot_pgdir+0x26d>
  104f19:	c7 44 24 0c a0 6d 10 	movl   $0x106da0,0xc(%esp)
  104f20:	00 
  104f21:	c7 44 24 08 d9 69 10 	movl   $0x1069d9,0x8(%esp)
  104f28:	00 
  104f29:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
  104f30:	00 
  104f31:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  104f38:	e8 9a bd ff ff       	call   100cd7 <__panic>
    assert(page_ref(p) == 2);
  104f3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104f40:	89 04 24             	mov    %eax,(%esp)
  104f43:	e8 db eb ff ff       	call   103b23 <page_ref>
  104f48:	83 f8 02             	cmp    $0x2,%eax
  104f4b:	74 24                	je     104f71 <check_boot_pgdir+0x2a1>
  104f4d:	c7 44 24 0c d7 6d 10 	movl   $0x106dd7,0xc(%esp)
  104f54:	00 
  104f55:	c7 44 24 08 d9 69 10 	movl   $0x1069d9,0x8(%esp)
  104f5c:	00 
  104f5d:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
  104f64:	00 
  104f65:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  104f6c:	e8 66 bd ff ff       	call   100cd7 <__panic>

    const char *str = "ucore: Hello world!!";
  104f71:	c7 45 dc e8 6d 10 00 	movl   $0x106de8,-0x24(%ebp)
    strcpy((void *)0x100, str);
  104f78:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104f7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  104f7f:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104f86:	e8 19 0a 00 00       	call   1059a4 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  104f8b:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  104f92:	00 
  104f93:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104f9a:	e8 7e 0a 00 00       	call   105a1d <strcmp>
  104f9f:	85 c0                	test   %eax,%eax
  104fa1:	74 24                	je     104fc7 <check_boot_pgdir+0x2f7>
  104fa3:	c7 44 24 0c 00 6e 10 	movl   $0x106e00,0xc(%esp)
  104faa:	00 
  104fab:	c7 44 24 08 d9 69 10 	movl   $0x1069d9,0x8(%esp)
  104fb2:	00 
  104fb3:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
  104fba:	00 
  104fbb:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  104fc2:	e8 10 bd ff ff       	call   100cd7 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  104fc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104fca:	89 04 24             	mov    %eax,(%esp)
  104fcd:	e8 a7 ea ff ff       	call   103a79 <page2kva>
  104fd2:	05 00 01 00 00       	add    $0x100,%eax
  104fd7:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  104fda:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104fe1:	e8 66 09 00 00       	call   10594c <strlen>
  104fe6:	85 c0                	test   %eax,%eax
  104fe8:	74 24                	je     10500e <check_boot_pgdir+0x33e>
  104fea:	c7 44 24 0c 38 6e 10 	movl   $0x106e38,0xc(%esp)
  104ff1:	00 
  104ff2:	c7 44 24 08 d9 69 10 	movl   $0x1069d9,0x8(%esp)
  104ff9:	00 
  104ffa:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
  105001:	00 
  105002:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  105009:	e8 c9 bc ff ff       	call   100cd7 <__panic>

    free_page(p);
  10500e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105015:	00 
  105016:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105019:	89 04 24             	mov    %eax,(%esp)
  10501c:	e8 32 ed ff ff       	call   103d53 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  105021:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105026:	8b 00                	mov    (%eax),%eax
  105028:	89 04 24             	mov    %eax,(%esp)
  10502b:	e8 db ea ff ff       	call   103b0b <pde2page>
  105030:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105037:	00 
  105038:	89 04 24             	mov    %eax,(%esp)
  10503b:	e8 13 ed ff ff       	call   103d53 <free_pages>
    boot_pgdir[0] = 0;
  105040:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105045:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  10504b:	c7 04 24 5c 6e 10 00 	movl   $0x106e5c,(%esp)
  105052:	e8 e5 b2 ff ff       	call   10033c <cprintf>
}
  105057:	c9                   	leave  
  105058:	c3                   	ret    

00105059 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  105059:	55                   	push   %ebp
  10505a:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  10505c:	8b 45 08             	mov    0x8(%ebp),%eax
  10505f:	83 e0 04             	and    $0x4,%eax
  105062:	85 c0                	test   %eax,%eax
  105064:	74 07                	je     10506d <perm2str+0x14>
  105066:	b8 75 00 00 00       	mov    $0x75,%eax
  10506b:	eb 05                	jmp    105072 <perm2str+0x19>
  10506d:	b8 2d 00 00 00       	mov    $0x2d,%eax
  105072:	a2 48 89 11 00       	mov    %al,0x118948
    str[1] = 'r';
  105077:	c6 05 49 89 11 00 72 	movb   $0x72,0x118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
  10507e:	8b 45 08             	mov    0x8(%ebp),%eax
  105081:	83 e0 02             	and    $0x2,%eax
  105084:	85 c0                	test   %eax,%eax
  105086:	74 07                	je     10508f <perm2str+0x36>
  105088:	b8 77 00 00 00       	mov    $0x77,%eax
  10508d:	eb 05                	jmp    105094 <perm2str+0x3b>
  10508f:	b8 2d 00 00 00       	mov    $0x2d,%eax
  105094:	a2 4a 89 11 00       	mov    %al,0x11894a
    str[3] = '\0';
  105099:	c6 05 4b 89 11 00 00 	movb   $0x0,0x11894b
    return str;
  1050a0:	b8 48 89 11 00       	mov    $0x118948,%eax
}
  1050a5:	5d                   	pop    %ebp
  1050a6:	c3                   	ret    

001050a7 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  1050a7:	55                   	push   %ebp
  1050a8:	89 e5                	mov    %esp,%ebp
  1050aa:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  1050ad:	8b 45 10             	mov    0x10(%ebp),%eax
  1050b0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1050b3:	72 0a                	jb     1050bf <get_pgtable_items+0x18>
        return 0;
  1050b5:	b8 00 00 00 00       	mov    $0x0,%eax
  1050ba:	e9 9c 00 00 00       	jmp    10515b <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  1050bf:	eb 04                	jmp    1050c5 <get_pgtable_items+0x1e>
        start ++;
  1050c1:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  1050c5:	8b 45 10             	mov    0x10(%ebp),%eax
  1050c8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1050cb:	73 18                	jae    1050e5 <get_pgtable_items+0x3e>
  1050cd:	8b 45 10             	mov    0x10(%ebp),%eax
  1050d0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1050d7:	8b 45 14             	mov    0x14(%ebp),%eax
  1050da:	01 d0                	add    %edx,%eax
  1050dc:	8b 00                	mov    (%eax),%eax
  1050de:	83 e0 01             	and    $0x1,%eax
  1050e1:	85 c0                	test   %eax,%eax
  1050e3:	74 dc                	je     1050c1 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
  1050e5:	8b 45 10             	mov    0x10(%ebp),%eax
  1050e8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1050eb:	73 69                	jae    105156 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  1050ed:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  1050f1:	74 08                	je     1050fb <get_pgtable_items+0x54>
            *left_store = start;
  1050f3:	8b 45 18             	mov    0x18(%ebp),%eax
  1050f6:	8b 55 10             	mov    0x10(%ebp),%edx
  1050f9:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  1050fb:	8b 45 10             	mov    0x10(%ebp),%eax
  1050fe:	8d 50 01             	lea    0x1(%eax),%edx
  105101:	89 55 10             	mov    %edx,0x10(%ebp)
  105104:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10510b:	8b 45 14             	mov    0x14(%ebp),%eax
  10510e:	01 d0                	add    %edx,%eax
  105110:	8b 00                	mov    (%eax),%eax
  105112:	83 e0 07             	and    $0x7,%eax
  105115:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  105118:	eb 04                	jmp    10511e <get_pgtable_items+0x77>
            start ++;
  10511a:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  10511e:	8b 45 10             	mov    0x10(%ebp),%eax
  105121:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105124:	73 1d                	jae    105143 <get_pgtable_items+0x9c>
  105126:	8b 45 10             	mov    0x10(%ebp),%eax
  105129:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105130:	8b 45 14             	mov    0x14(%ebp),%eax
  105133:	01 d0                	add    %edx,%eax
  105135:	8b 00                	mov    (%eax),%eax
  105137:	83 e0 07             	and    $0x7,%eax
  10513a:	89 c2                	mov    %eax,%edx
  10513c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10513f:	39 c2                	cmp    %eax,%edx
  105141:	74 d7                	je     10511a <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
  105143:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105147:	74 08                	je     105151 <get_pgtable_items+0xaa>
            *right_store = start;
  105149:	8b 45 1c             	mov    0x1c(%ebp),%eax
  10514c:	8b 55 10             	mov    0x10(%ebp),%edx
  10514f:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  105151:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105154:	eb 05                	jmp    10515b <get_pgtable_items+0xb4>
    }
    return 0;
  105156:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10515b:	c9                   	leave  
  10515c:	c3                   	ret    

0010515d <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  10515d:	55                   	push   %ebp
  10515e:	89 e5                	mov    %esp,%ebp
  105160:	57                   	push   %edi
  105161:	56                   	push   %esi
  105162:	53                   	push   %ebx
  105163:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  105166:	c7 04 24 7c 6e 10 00 	movl   $0x106e7c,(%esp)
  10516d:	e8 ca b1 ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
  105172:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105179:	e9 fa 00 00 00       	jmp    105278 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  10517e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105181:	89 04 24             	mov    %eax,(%esp)
  105184:	e8 d0 fe ff ff       	call   105059 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  105189:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10518c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10518f:	29 d1                	sub    %edx,%ecx
  105191:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  105193:	89 d6                	mov    %edx,%esi
  105195:	c1 e6 16             	shl    $0x16,%esi
  105198:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10519b:	89 d3                	mov    %edx,%ebx
  10519d:	c1 e3 16             	shl    $0x16,%ebx
  1051a0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1051a3:	89 d1                	mov    %edx,%ecx
  1051a5:	c1 e1 16             	shl    $0x16,%ecx
  1051a8:	8b 7d dc             	mov    -0x24(%ebp),%edi
  1051ab:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1051ae:	29 d7                	sub    %edx,%edi
  1051b0:	89 fa                	mov    %edi,%edx
  1051b2:	89 44 24 14          	mov    %eax,0x14(%esp)
  1051b6:	89 74 24 10          	mov    %esi,0x10(%esp)
  1051ba:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1051be:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1051c2:	89 54 24 04          	mov    %edx,0x4(%esp)
  1051c6:	c7 04 24 ad 6e 10 00 	movl   $0x106ead,(%esp)
  1051cd:	e8 6a b1 ff ff       	call   10033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  1051d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1051d5:	c1 e0 0a             	shl    $0xa,%eax
  1051d8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1051db:	eb 54                	jmp    105231 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1051dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1051e0:	89 04 24             	mov    %eax,(%esp)
  1051e3:	e8 71 fe ff ff       	call   105059 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  1051e8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1051eb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1051ee:	29 d1                	sub    %edx,%ecx
  1051f0:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1051f2:	89 d6                	mov    %edx,%esi
  1051f4:	c1 e6 0c             	shl    $0xc,%esi
  1051f7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1051fa:	89 d3                	mov    %edx,%ebx
  1051fc:	c1 e3 0c             	shl    $0xc,%ebx
  1051ff:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105202:	c1 e2 0c             	shl    $0xc,%edx
  105205:	89 d1                	mov    %edx,%ecx
  105207:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  10520a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10520d:	29 d7                	sub    %edx,%edi
  10520f:	89 fa                	mov    %edi,%edx
  105211:	89 44 24 14          	mov    %eax,0x14(%esp)
  105215:	89 74 24 10          	mov    %esi,0x10(%esp)
  105219:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10521d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  105221:	89 54 24 04          	mov    %edx,0x4(%esp)
  105225:	c7 04 24 cc 6e 10 00 	movl   $0x106ecc,(%esp)
  10522c:	e8 0b b1 ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  105231:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  105236:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105239:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10523c:	89 ce                	mov    %ecx,%esi
  10523e:	c1 e6 0a             	shl    $0xa,%esi
  105241:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  105244:	89 cb                	mov    %ecx,%ebx
  105246:	c1 e3 0a             	shl    $0xa,%ebx
  105249:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  10524c:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  105250:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  105253:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  105257:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10525b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10525f:	89 74 24 04          	mov    %esi,0x4(%esp)
  105263:	89 1c 24             	mov    %ebx,(%esp)
  105266:	e8 3c fe ff ff       	call   1050a7 <get_pgtable_items>
  10526b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10526e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105272:	0f 85 65 ff ff ff    	jne    1051dd <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105278:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  10527d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105280:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  105283:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  105287:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  10528a:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10528e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105292:	89 44 24 08          	mov    %eax,0x8(%esp)
  105296:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  10529d:	00 
  10529e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1052a5:	e8 fd fd ff ff       	call   1050a7 <get_pgtable_items>
  1052aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1052ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1052b1:	0f 85 c7 fe ff ff    	jne    10517e <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  1052b7:	c7 04 24 f0 6e 10 00 	movl   $0x106ef0,(%esp)
  1052be:	e8 79 b0 ff ff       	call   10033c <cprintf>
}
  1052c3:	83 c4 4c             	add    $0x4c,%esp
  1052c6:	5b                   	pop    %ebx
  1052c7:	5e                   	pop    %esi
  1052c8:	5f                   	pop    %edi
  1052c9:	5d                   	pop    %ebp
  1052ca:	c3                   	ret    

001052cb <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1052cb:	55                   	push   %ebp
  1052cc:	89 e5                	mov    %esp,%ebp
  1052ce:	83 ec 58             	sub    $0x58,%esp
  1052d1:	8b 45 10             	mov    0x10(%ebp),%eax
  1052d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1052d7:	8b 45 14             	mov    0x14(%ebp),%eax
  1052da:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1052dd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1052e0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1052e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1052e6:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1052e9:	8b 45 18             	mov    0x18(%ebp),%eax
  1052ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1052ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1052f2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1052f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1052f8:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1052fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1052fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105301:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105305:	74 1c                	je     105323 <printnum+0x58>
  105307:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10530a:	ba 00 00 00 00       	mov    $0x0,%edx
  10530f:	f7 75 e4             	divl   -0x1c(%ebp)
  105312:	89 55 f4             	mov    %edx,-0xc(%ebp)
  105315:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105318:	ba 00 00 00 00       	mov    $0x0,%edx
  10531d:	f7 75 e4             	divl   -0x1c(%ebp)
  105320:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105323:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105326:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105329:	f7 75 e4             	divl   -0x1c(%ebp)
  10532c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10532f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  105332:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105335:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105338:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10533b:	89 55 ec             	mov    %edx,-0x14(%ebp)
  10533e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105341:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  105344:	8b 45 18             	mov    0x18(%ebp),%eax
  105347:	ba 00 00 00 00       	mov    $0x0,%edx
  10534c:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10534f:	77 56                	ja     1053a7 <printnum+0xdc>
  105351:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  105354:	72 05                	jb     10535b <printnum+0x90>
  105356:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  105359:	77 4c                	ja     1053a7 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  10535b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  10535e:	8d 50 ff             	lea    -0x1(%eax),%edx
  105361:	8b 45 20             	mov    0x20(%ebp),%eax
  105364:	89 44 24 18          	mov    %eax,0x18(%esp)
  105368:	89 54 24 14          	mov    %edx,0x14(%esp)
  10536c:	8b 45 18             	mov    0x18(%ebp),%eax
  10536f:	89 44 24 10          	mov    %eax,0x10(%esp)
  105373:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105376:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105379:	89 44 24 08          	mov    %eax,0x8(%esp)
  10537d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105381:	8b 45 0c             	mov    0xc(%ebp),%eax
  105384:	89 44 24 04          	mov    %eax,0x4(%esp)
  105388:	8b 45 08             	mov    0x8(%ebp),%eax
  10538b:	89 04 24             	mov    %eax,(%esp)
  10538e:	e8 38 ff ff ff       	call   1052cb <printnum>
  105393:	eb 1c                	jmp    1053b1 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  105395:	8b 45 0c             	mov    0xc(%ebp),%eax
  105398:	89 44 24 04          	mov    %eax,0x4(%esp)
  10539c:	8b 45 20             	mov    0x20(%ebp),%eax
  10539f:	89 04 24             	mov    %eax,(%esp)
  1053a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1053a5:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  1053a7:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  1053ab:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1053af:	7f e4                	jg     105395 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  1053b1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1053b4:	05 a4 6f 10 00       	add    $0x106fa4,%eax
  1053b9:	0f b6 00             	movzbl (%eax),%eax
  1053bc:	0f be c0             	movsbl %al,%eax
  1053bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  1053c2:	89 54 24 04          	mov    %edx,0x4(%esp)
  1053c6:	89 04 24             	mov    %eax,(%esp)
  1053c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1053cc:	ff d0                	call   *%eax
}
  1053ce:	c9                   	leave  
  1053cf:	c3                   	ret    

001053d0 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1053d0:	55                   	push   %ebp
  1053d1:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1053d3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1053d7:	7e 14                	jle    1053ed <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  1053d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1053dc:	8b 00                	mov    (%eax),%eax
  1053de:	8d 48 08             	lea    0x8(%eax),%ecx
  1053e1:	8b 55 08             	mov    0x8(%ebp),%edx
  1053e4:	89 0a                	mov    %ecx,(%edx)
  1053e6:	8b 50 04             	mov    0x4(%eax),%edx
  1053e9:	8b 00                	mov    (%eax),%eax
  1053eb:	eb 30                	jmp    10541d <getuint+0x4d>
    }
    else if (lflag) {
  1053ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1053f1:	74 16                	je     105409 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  1053f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1053f6:	8b 00                	mov    (%eax),%eax
  1053f8:	8d 48 04             	lea    0x4(%eax),%ecx
  1053fb:	8b 55 08             	mov    0x8(%ebp),%edx
  1053fe:	89 0a                	mov    %ecx,(%edx)
  105400:	8b 00                	mov    (%eax),%eax
  105402:	ba 00 00 00 00       	mov    $0x0,%edx
  105407:	eb 14                	jmp    10541d <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  105409:	8b 45 08             	mov    0x8(%ebp),%eax
  10540c:	8b 00                	mov    (%eax),%eax
  10540e:	8d 48 04             	lea    0x4(%eax),%ecx
  105411:	8b 55 08             	mov    0x8(%ebp),%edx
  105414:	89 0a                	mov    %ecx,(%edx)
  105416:	8b 00                	mov    (%eax),%eax
  105418:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  10541d:	5d                   	pop    %ebp
  10541e:	c3                   	ret    

0010541f <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  10541f:	55                   	push   %ebp
  105420:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105422:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105426:	7e 14                	jle    10543c <getint+0x1d>
        return va_arg(*ap, long long);
  105428:	8b 45 08             	mov    0x8(%ebp),%eax
  10542b:	8b 00                	mov    (%eax),%eax
  10542d:	8d 48 08             	lea    0x8(%eax),%ecx
  105430:	8b 55 08             	mov    0x8(%ebp),%edx
  105433:	89 0a                	mov    %ecx,(%edx)
  105435:	8b 50 04             	mov    0x4(%eax),%edx
  105438:	8b 00                	mov    (%eax),%eax
  10543a:	eb 28                	jmp    105464 <getint+0x45>
    }
    else if (lflag) {
  10543c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105440:	74 12                	je     105454 <getint+0x35>
        return va_arg(*ap, long);
  105442:	8b 45 08             	mov    0x8(%ebp),%eax
  105445:	8b 00                	mov    (%eax),%eax
  105447:	8d 48 04             	lea    0x4(%eax),%ecx
  10544a:	8b 55 08             	mov    0x8(%ebp),%edx
  10544d:	89 0a                	mov    %ecx,(%edx)
  10544f:	8b 00                	mov    (%eax),%eax
  105451:	99                   	cltd   
  105452:	eb 10                	jmp    105464 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  105454:	8b 45 08             	mov    0x8(%ebp),%eax
  105457:	8b 00                	mov    (%eax),%eax
  105459:	8d 48 04             	lea    0x4(%eax),%ecx
  10545c:	8b 55 08             	mov    0x8(%ebp),%edx
  10545f:	89 0a                	mov    %ecx,(%edx)
  105461:	8b 00                	mov    (%eax),%eax
  105463:	99                   	cltd   
    }
}
  105464:	5d                   	pop    %ebp
  105465:	c3                   	ret    

00105466 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  105466:	55                   	push   %ebp
  105467:	89 e5                	mov    %esp,%ebp
  105469:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  10546c:	8d 45 14             	lea    0x14(%ebp),%eax
  10546f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  105472:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105475:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105479:	8b 45 10             	mov    0x10(%ebp),%eax
  10547c:	89 44 24 08          	mov    %eax,0x8(%esp)
  105480:	8b 45 0c             	mov    0xc(%ebp),%eax
  105483:	89 44 24 04          	mov    %eax,0x4(%esp)
  105487:	8b 45 08             	mov    0x8(%ebp),%eax
  10548a:	89 04 24             	mov    %eax,(%esp)
  10548d:	e8 02 00 00 00       	call   105494 <vprintfmt>
    va_end(ap);
}
  105492:	c9                   	leave  
  105493:	c3                   	ret    

00105494 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  105494:	55                   	push   %ebp
  105495:	89 e5                	mov    %esp,%ebp
  105497:	56                   	push   %esi
  105498:	53                   	push   %ebx
  105499:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10549c:	eb 18                	jmp    1054b6 <vprintfmt+0x22>
            if (ch == '\0') {
  10549e:	85 db                	test   %ebx,%ebx
  1054a0:	75 05                	jne    1054a7 <vprintfmt+0x13>
                return;
  1054a2:	e9 d1 03 00 00       	jmp    105878 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  1054a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1054aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054ae:	89 1c 24             	mov    %ebx,(%esp)
  1054b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1054b4:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1054b6:	8b 45 10             	mov    0x10(%ebp),%eax
  1054b9:	8d 50 01             	lea    0x1(%eax),%edx
  1054bc:	89 55 10             	mov    %edx,0x10(%ebp)
  1054bf:	0f b6 00             	movzbl (%eax),%eax
  1054c2:	0f b6 d8             	movzbl %al,%ebx
  1054c5:	83 fb 25             	cmp    $0x25,%ebx
  1054c8:	75 d4                	jne    10549e <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  1054ca:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  1054ce:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  1054d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1054d8:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  1054db:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1054e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1054e5:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  1054e8:	8b 45 10             	mov    0x10(%ebp),%eax
  1054eb:	8d 50 01             	lea    0x1(%eax),%edx
  1054ee:	89 55 10             	mov    %edx,0x10(%ebp)
  1054f1:	0f b6 00             	movzbl (%eax),%eax
  1054f4:	0f b6 d8             	movzbl %al,%ebx
  1054f7:	8d 43 dd             	lea    -0x23(%ebx),%eax
  1054fa:	83 f8 55             	cmp    $0x55,%eax
  1054fd:	0f 87 44 03 00 00    	ja     105847 <vprintfmt+0x3b3>
  105503:	8b 04 85 c8 6f 10 00 	mov    0x106fc8(,%eax,4),%eax
  10550a:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  10550c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105510:	eb d6                	jmp    1054e8 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  105512:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105516:	eb d0                	jmp    1054e8 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105518:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  10551f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105522:	89 d0                	mov    %edx,%eax
  105524:	c1 e0 02             	shl    $0x2,%eax
  105527:	01 d0                	add    %edx,%eax
  105529:	01 c0                	add    %eax,%eax
  10552b:	01 d8                	add    %ebx,%eax
  10552d:	83 e8 30             	sub    $0x30,%eax
  105530:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  105533:	8b 45 10             	mov    0x10(%ebp),%eax
  105536:	0f b6 00             	movzbl (%eax),%eax
  105539:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  10553c:	83 fb 2f             	cmp    $0x2f,%ebx
  10553f:	7e 0b                	jle    10554c <vprintfmt+0xb8>
  105541:	83 fb 39             	cmp    $0x39,%ebx
  105544:	7f 06                	jg     10554c <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105546:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  10554a:	eb d3                	jmp    10551f <vprintfmt+0x8b>
            goto process_precision;
  10554c:	eb 33                	jmp    105581 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  10554e:	8b 45 14             	mov    0x14(%ebp),%eax
  105551:	8d 50 04             	lea    0x4(%eax),%edx
  105554:	89 55 14             	mov    %edx,0x14(%ebp)
  105557:	8b 00                	mov    (%eax),%eax
  105559:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  10555c:	eb 23                	jmp    105581 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  10555e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105562:	79 0c                	jns    105570 <vprintfmt+0xdc>
                width = 0;
  105564:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  10556b:	e9 78 ff ff ff       	jmp    1054e8 <vprintfmt+0x54>
  105570:	e9 73 ff ff ff       	jmp    1054e8 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  105575:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  10557c:	e9 67 ff ff ff       	jmp    1054e8 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  105581:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105585:	79 12                	jns    105599 <vprintfmt+0x105>
                width = precision, precision = -1;
  105587:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10558a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10558d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  105594:	e9 4f ff ff ff       	jmp    1054e8 <vprintfmt+0x54>
  105599:	e9 4a ff ff ff       	jmp    1054e8 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  10559e:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  1055a2:	e9 41 ff ff ff       	jmp    1054e8 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1055a7:	8b 45 14             	mov    0x14(%ebp),%eax
  1055aa:	8d 50 04             	lea    0x4(%eax),%edx
  1055ad:	89 55 14             	mov    %edx,0x14(%ebp)
  1055b0:	8b 00                	mov    (%eax),%eax
  1055b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  1055b5:	89 54 24 04          	mov    %edx,0x4(%esp)
  1055b9:	89 04 24             	mov    %eax,(%esp)
  1055bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1055bf:	ff d0                	call   *%eax
            break;
  1055c1:	e9 ac 02 00 00       	jmp    105872 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  1055c6:	8b 45 14             	mov    0x14(%ebp),%eax
  1055c9:	8d 50 04             	lea    0x4(%eax),%edx
  1055cc:	89 55 14             	mov    %edx,0x14(%ebp)
  1055cf:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  1055d1:	85 db                	test   %ebx,%ebx
  1055d3:	79 02                	jns    1055d7 <vprintfmt+0x143>
                err = -err;
  1055d5:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  1055d7:	83 fb 06             	cmp    $0x6,%ebx
  1055da:	7f 0b                	jg     1055e7 <vprintfmt+0x153>
  1055dc:	8b 34 9d 88 6f 10 00 	mov    0x106f88(,%ebx,4),%esi
  1055e3:	85 f6                	test   %esi,%esi
  1055e5:	75 23                	jne    10560a <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  1055e7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1055eb:	c7 44 24 08 b5 6f 10 	movl   $0x106fb5,0x8(%esp)
  1055f2:	00 
  1055f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1055fd:	89 04 24             	mov    %eax,(%esp)
  105600:	e8 61 fe ff ff       	call   105466 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105605:	e9 68 02 00 00       	jmp    105872 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  10560a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  10560e:	c7 44 24 08 be 6f 10 	movl   $0x106fbe,0x8(%esp)
  105615:	00 
  105616:	8b 45 0c             	mov    0xc(%ebp),%eax
  105619:	89 44 24 04          	mov    %eax,0x4(%esp)
  10561d:	8b 45 08             	mov    0x8(%ebp),%eax
  105620:	89 04 24             	mov    %eax,(%esp)
  105623:	e8 3e fe ff ff       	call   105466 <printfmt>
            }
            break;
  105628:	e9 45 02 00 00       	jmp    105872 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  10562d:	8b 45 14             	mov    0x14(%ebp),%eax
  105630:	8d 50 04             	lea    0x4(%eax),%edx
  105633:	89 55 14             	mov    %edx,0x14(%ebp)
  105636:	8b 30                	mov    (%eax),%esi
  105638:	85 f6                	test   %esi,%esi
  10563a:	75 05                	jne    105641 <vprintfmt+0x1ad>
                p = "(null)";
  10563c:	be c1 6f 10 00       	mov    $0x106fc1,%esi
            }
            if (width > 0 && padc != '-') {
  105641:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105645:	7e 3e                	jle    105685 <vprintfmt+0x1f1>
  105647:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  10564b:	74 38                	je     105685 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  10564d:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  105650:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105653:	89 44 24 04          	mov    %eax,0x4(%esp)
  105657:	89 34 24             	mov    %esi,(%esp)
  10565a:	e8 15 03 00 00       	call   105974 <strnlen>
  10565f:	29 c3                	sub    %eax,%ebx
  105661:	89 d8                	mov    %ebx,%eax
  105663:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105666:	eb 17                	jmp    10567f <vprintfmt+0x1eb>
                    putch(padc, putdat);
  105668:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  10566c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10566f:	89 54 24 04          	mov    %edx,0x4(%esp)
  105673:	89 04 24             	mov    %eax,(%esp)
  105676:	8b 45 08             	mov    0x8(%ebp),%eax
  105679:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  10567b:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10567f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105683:	7f e3                	jg     105668 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105685:	eb 38                	jmp    1056bf <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  105687:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10568b:	74 1f                	je     1056ac <vprintfmt+0x218>
  10568d:	83 fb 1f             	cmp    $0x1f,%ebx
  105690:	7e 05                	jle    105697 <vprintfmt+0x203>
  105692:	83 fb 7e             	cmp    $0x7e,%ebx
  105695:	7e 15                	jle    1056ac <vprintfmt+0x218>
                    putch('?', putdat);
  105697:	8b 45 0c             	mov    0xc(%ebp),%eax
  10569a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10569e:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  1056a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1056a8:	ff d0                	call   *%eax
  1056aa:	eb 0f                	jmp    1056bb <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  1056ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056b3:	89 1c 24             	mov    %ebx,(%esp)
  1056b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1056b9:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1056bb:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1056bf:	89 f0                	mov    %esi,%eax
  1056c1:	8d 70 01             	lea    0x1(%eax),%esi
  1056c4:	0f b6 00             	movzbl (%eax),%eax
  1056c7:	0f be d8             	movsbl %al,%ebx
  1056ca:	85 db                	test   %ebx,%ebx
  1056cc:	74 10                	je     1056de <vprintfmt+0x24a>
  1056ce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1056d2:	78 b3                	js     105687 <vprintfmt+0x1f3>
  1056d4:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  1056d8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1056dc:	79 a9                	jns    105687 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  1056de:	eb 17                	jmp    1056f7 <vprintfmt+0x263>
                putch(' ', putdat);
  1056e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056e7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1056ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1056f1:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  1056f3:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1056f7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1056fb:	7f e3                	jg     1056e0 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  1056fd:	e9 70 01 00 00       	jmp    105872 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105702:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105705:	89 44 24 04          	mov    %eax,0x4(%esp)
  105709:	8d 45 14             	lea    0x14(%ebp),%eax
  10570c:	89 04 24             	mov    %eax,(%esp)
  10570f:	e8 0b fd ff ff       	call   10541f <getint>
  105714:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105717:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  10571a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10571d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105720:	85 d2                	test   %edx,%edx
  105722:	79 26                	jns    10574a <vprintfmt+0x2b6>
                putch('-', putdat);
  105724:	8b 45 0c             	mov    0xc(%ebp),%eax
  105727:	89 44 24 04          	mov    %eax,0x4(%esp)
  10572b:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  105732:	8b 45 08             	mov    0x8(%ebp),%eax
  105735:	ff d0                	call   *%eax
                num = -(long long)num;
  105737:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10573a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10573d:	f7 d8                	neg    %eax
  10573f:	83 d2 00             	adc    $0x0,%edx
  105742:	f7 da                	neg    %edx
  105744:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105747:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  10574a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105751:	e9 a8 00 00 00       	jmp    1057fe <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  105756:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105759:	89 44 24 04          	mov    %eax,0x4(%esp)
  10575d:	8d 45 14             	lea    0x14(%ebp),%eax
  105760:	89 04 24             	mov    %eax,(%esp)
  105763:	e8 68 fc ff ff       	call   1053d0 <getuint>
  105768:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10576b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  10576e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105775:	e9 84 00 00 00       	jmp    1057fe <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  10577a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10577d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105781:	8d 45 14             	lea    0x14(%ebp),%eax
  105784:	89 04 24             	mov    %eax,(%esp)
  105787:	e8 44 fc ff ff       	call   1053d0 <getuint>
  10578c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10578f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105792:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105799:	eb 63                	jmp    1057fe <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  10579b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10579e:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057a2:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  1057a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1057ac:	ff d0                	call   *%eax
            putch('x', putdat);
  1057ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057b5:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  1057bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1057bf:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  1057c1:	8b 45 14             	mov    0x14(%ebp),%eax
  1057c4:	8d 50 04             	lea    0x4(%eax),%edx
  1057c7:	89 55 14             	mov    %edx,0x14(%ebp)
  1057ca:	8b 00                	mov    (%eax),%eax
  1057cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1057cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  1057d6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  1057dd:	eb 1f                	jmp    1057fe <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  1057df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1057e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057e6:	8d 45 14             	lea    0x14(%ebp),%eax
  1057e9:	89 04 24             	mov    %eax,(%esp)
  1057ec:	e8 df fb ff ff       	call   1053d0 <getuint>
  1057f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1057f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  1057f7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  1057fe:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105802:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105805:	89 54 24 18          	mov    %edx,0x18(%esp)
  105809:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10580c:	89 54 24 14          	mov    %edx,0x14(%esp)
  105810:	89 44 24 10          	mov    %eax,0x10(%esp)
  105814:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105817:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10581a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10581e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105822:	8b 45 0c             	mov    0xc(%ebp),%eax
  105825:	89 44 24 04          	mov    %eax,0x4(%esp)
  105829:	8b 45 08             	mov    0x8(%ebp),%eax
  10582c:	89 04 24             	mov    %eax,(%esp)
  10582f:	e8 97 fa ff ff       	call   1052cb <printnum>
            break;
  105834:	eb 3c                	jmp    105872 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105836:	8b 45 0c             	mov    0xc(%ebp),%eax
  105839:	89 44 24 04          	mov    %eax,0x4(%esp)
  10583d:	89 1c 24             	mov    %ebx,(%esp)
  105840:	8b 45 08             	mov    0x8(%ebp),%eax
  105843:	ff d0                	call   *%eax
            break;
  105845:	eb 2b                	jmp    105872 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105847:	8b 45 0c             	mov    0xc(%ebp),%eax
  10584a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10584e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  105855:	8b 45 08             	mov    0x8(%ebp),%eax
  105858:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  10585a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10585e:	eb 04                	jmp    105864 <vprintfmt+0x3d0>
  105860:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105864:	8b 45 10             	mov    0x10(%ebp),%eax
  105867:	83 e8 01             	sub    $0x1,%eax
  10586a:	0f b6 00             	movzbl (%eax),%eax
  10586d:	3c 25                	cmp    $0x25,%al
  10586f:	75 ef                	jne    105860 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  105871:	90                   	nop
        }
    }
  105872:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105873:	e9 3e fc ff ff       	jmp    1054b6 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  105878:	83 c4 40             	add    $0x40,%esp
  10587b:	5b                   	pop    %ebx
  10587c:	5e                   	pop    %esi
  10587d:	5d                   	pop    %ebp
  10587e:	c3                   	ret    

0010587f <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  10587f:	55                   	push   %ebp
  105880:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105882:	8b 45 0c             	mov    0xc(%ebp),%eax
  105885:	8b 40 08             	mov    0x8(%eax),%eax
  105888:	8d 50 01             	lea    0x1(%eax),%edx
  10588b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10588e:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105891:	8b 45 0c             	mov    0xc(%ebp),%eax
  105894:	8b 10                	mov    (%eax),%edx
  105896:	8b 45 0c             	mov    0xc(%ebp),%eax
  105899:	8b 40 04             	mov    0x4(%eax),%eax
  10589c:	39 c2                	cmp    %eax,%edx
  10589e:	73 12                	jae    1058b2 <sprintputch+0x33>
        *b->buf ++ = ch;
  1058a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058a3:	8b 00                	mov    (%eax),%eax
  1058a5:	8d 48 01             	lea    0x1(%eax),%ecx
  1058a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  1058ab:	89 0a                	mov    %ecx,(%edx)
  1058ad:	8b 55 08             	mov    0x8(%ebp),%edx
  1058b0:	88 10                	mov    %dl,(%eax)
    }
}
  1058b2:	5d                   	pop    %ebp
  1058b3:	c3                   	ret    

001058b4 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  1058b4:	55                   	push   %ebp
  1058b5:	89 e5                	mov    %esp,%ebp
  1058b7:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1058ba:	8d 45 14             	lea    0x14(%ebp),%eax
  1058bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  1058c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1058c7:	8b 45 10             	mov    0x10(%ebp),%eax
  1058ca:	89 44 24 08          	mov    %eax,0x8(%esp)
  1058ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1058d8:	89 04 24             	mov    %eax,(%esp)
  1058db:	e8 08 00 00 00       	call   1058e8 <vsnprintf>
  1058e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1058e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1058e6:	c9                   	leave  
  1058e7:	c3                   	ret    

001058e8 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  1058e8:	55                   	push   %ebp
  1058e9:	89 e5                	mov    %esp,%ebp
  1058eb:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  1058ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1058f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1058f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058f7:	8d 50 ff             	lea    -0x1(%eax),%edx
  1058fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1058fd:	01 d0                	add    %edx,%eax
  1058ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105902:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105909:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10590d:	74 0a                	je     105919 <vsnprintf+0x31>
  10590f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105912:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105915:	39 c2                	cmp    %eax,%edx
  105917:	76 07                	jbe    105920 <vsnprintf+0x38>
        return -E_INVAL;
  105919:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  10591e:	eb 2a                	jmp    10594a <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105920:	8b 45 14             	mov    0x14(%ebp),%eax
  105923:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105927:	8b 45 10             	mov    0x10(%ebp),%eax
  10592a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10592e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105931:	89 44 24 04          	mov    %eax,0x4(%esp)
  105935:	c7 04 24 7f 58 10 00 	movl   $0x10587f,(%esp)
  10593c:	e8 53 fb ff ff       	call   105494 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105941:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105944:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105947:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10594a:	c9                   	leave  
  10594b:	c3                   	ret    

0010594c <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  10594c:	55                   	push   %ebp
  10594d:	89 e5                	mov    %esp,%ebp
  10594f:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105952:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105959:	eb 04                	jmp    10595f <strlen+0x13>
        cnt ++;
  10595b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  10595f:	8b 45 08             	mov    0x8(%ebp),%eax
  105962:	8d 50 01             	lea    0x1(%eax),%edx
  105965:	89 55 08             	mov    %edx,0x8(%ebp)
  105968:	0f b6 00             	movzbl (%eax),%eax
  10596b:	84 c0                	test   %al,%al
  10596d:	75 ec                	jne    10595b <strlen+0xf>
        cnt ++;
    }
    return cnt;
  10596f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105972:	c9                   	leave  
  105973:	c3                   	ret    

00105974 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105974:	55                   	push   %ebp
  105975:	89 e5                	mov    %esp,%ebp
  105977:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  10597a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105981:	eb 04                	jmp    105987 <strnlen+0x13>
        cnt ++;
  105983:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  105987:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10598a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10598d:	73 10                	jae    10599f <strnlen+0x2b>
  10598f:	8b 45 08             	mov    0x8(%ebp),%eax
  105992:	8d 50 01             	lea    0x1(%eax),%edx
  105995:	89 55 08             	mov    %edx,0x8(%ebp)
  105998:	0f b6 00             	movzbl (%eax),%eax
  10599b:	84 c0                	test   %al,%al
  10599d:	75 e4                	jne    105983 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  10599f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1059a2:	c9                   	leave  
  1059a3:	c3                   	ret    

001059a4 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  1059a4:	55                   	push   %ebp
  1059a5:	89 e5                	mov    %esp,%ebp
  1059a7:	57                   	push   %edi
  1059a8:	56                   	push   %esi
  1059a9:	83 ec 20             	sub    $0x20,%esp
  1059ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1059af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1059b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  1059b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1059bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1059be:	89 d1                	mov    %edx,%ecx
  1059c0:	89 c2                	mov    %eax,%edx
  1059c2:	89 ce                	mov    %ecx,%esi
  1059c4:	89 d7                	mov    %edx,%edi
  1059c6:	ac                   	lods   %ds:(%esi),%al
  1059c7:	aa                   	stos   %al,%es:(%edi)
  1059c8:	84 c0                	test   %al,%al
  1059ca:	75 fa                	jne    1059c6 <strcpy+0x22>
  1059cc:	89 fa                	mov    %edi,%edx
  1059ce:	89 f1                	mov    %esi,%ecx
  1059d0:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1059d3:	89 55 e8             	mov    %edx,-0x18(%ebp)
  1059d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  1059d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  1059dc:	83 c4 20             	add    $0x20,%esp
  1059df:	5e                   	pop    %esi
  1059e0:	5f                   	pop    %edi
  1059e1:	5d                   	pop    %ebp
  1059e2:	c3                   	ret    

001059e3 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  1059e3:	55                   	push   %ebp
  1059e4:	89 e5                	mov    %esp,%ebp
  1059e6:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  1059e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1059ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  1059ef:	eb 21                	jmp    105a12 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  1059f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059f4:	0f b6 10             	movzbl (%eax),%edx
  1059f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1059fa:	88 10                	mov    %dl,(%eax)
  1059fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1059ff:	0f b6 00             	movzbl (%eax),%eax
  105a02:	84 c0                	test   %al,%al
  105a04:	74 04                	je     105a0a <strncpy+0x27>
            src ++;
  105a06:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105a0a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105a0e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  105a12:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105a16:	75 d9                	jne    1059f1 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  105a18:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105a1b:	c9                   	leave  
  105a1c:	c3                   	ret    

00105a1d <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105a1d:	55                   	push   %ebp
  105a1e:	89 e5                	mov    %esp,%ebp
  105a20:	57                   	push   %edi
  105a21:	56                   	push   %esi
  105a22:	83 ec 20             	sub    $0x20,%esp
  105a25:	8b 45 08             	mov    0x8(%ebp),%eax
  105a28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105a2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  105a31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105a34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a37:	89 d1                	mov    %edx,%ecx
  105a39:	89 c2                	mov    %eax,%edx
  105a3b:	89 ce                	mov    %ecx,%esi
  105a3d:	89 d7                	mov    %edx,%edi
  105a3f:	ac                   	lods   %ds:(%esi),%al
  105a40:	ae                   	scas   %es:(%edi),%al
  105a41:	75 08                	jne    105a4b <strcmp+0x2e>
  105a43:	84 c0                	test   %al,%al
  105a45:	75 f8                	jne    105a3f <strcmp+0x22>
  105a47:	31 c0                	xor    %eax,%eax
  105a49:	eb 04                	jmp    105a4f <strcmp+0x32>
  105a4b:	19 c0                	sbb    %eax,%eax
  105a4d:	0c 01                	or     $0x1,%al
  105a4f:	89 fa                	mov    %edi,%edx
  105a51:	89 f1                	mov    %esi,%ecx
  105a53:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105a56:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105a59:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  105a5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105a5f:	83 c4 20             	add    $0x20,%esp
  105a62:	5e                   	pop    %esi
  105a63:	5f                   	pop    %edi
  105a64:	5d                   	pop    %ebp
  105a65:	c3                   	ret    

00105a66 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105a66:	55                   	push   %ebp
  105a67:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105a69:	eb 0c                	jmp    105a77 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105a6b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105a6f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105a73:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105a77:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105a7b:	74 1a                	je     105a97 <strncmp+0x31>
  105a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  105a80:	0f b6 00             	movzbl (%eax),%eax
  105a83:	84 c0                	test   %al,%al
  105a85:	74 10                	je     105a97 <strncmp+0x31>
  105a87:	8b 45 08             	mov    0x8(%ebp),%eax
  105a8a:	0f b6 10             	movzbl (%eax),%edx
  105a8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a90:	0f b6 00             	movzbl (%eax),%eax
  105a93:	38 c2                	cmp    %al,%dl
  105a95:	74 d4                	je     105a6b <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105a97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105a9b:	74 18                	je     105ab5 <strncmp+0x4f>
  105a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  105aa0:	0f b6 00             	movzbl (%eax),%eax
  105aa3:	0f b6 d0             	movzbl %al,%edx
  105aa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  105aa9:	0f b6 00             	movzbl (%eax),%eax
  105aac:	0f b6 c0             	movzbl %al,%eax
  105aaf:	29 c2                	sub    %eax,%edx
  105ab1:	89 d0                	mov    %edx,%eax
  105ab3:	eb 05                	jmp    105aba <strncmp+0x54>
  105ab5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105aba:	5d                   	pop    %ebp
  105abb:	c3                   	ret    

00105abc <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105abc:	55                   	push   %ebp
  105abd:	89 e5                	mov    %esp,%ebp
  105abf:	83 ec 04             	sub    $0x4,%esp
  105ac2:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ac5:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105ac8:	eb 14                	jmp    105ade <strchr+0x22>
        if (*s == c) {
  105aca:	8b 45 08             	mov    0x8(%ebp),%eax
  105acd:	0f b6 00             	movzbl (%eax),%eax
  105ad0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105ad3:	75 05                	jne    105ada <strchr+0x1e>
            return (char *)s;
  105ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  105ad8:	eb 13                	jmp    105aed <strchr+0x31>
        }
        s ++;
  105ada:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  105ade:	8b 45 08             	mov    0x8(%ebp),%eax
  105ae1:	0f b6 00             	movzbl (%eax),%eax
  105ae4:	84 c0                	test   %al,%al
  105ae6:	75 e2                	jne    105aca <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105ae8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105aed:	c9                   	leave  
  105aee:	c3                   	ret    

00105aef <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105aef:	55                   	push   %ebp
  105af0:	89 e5                	mov    %esp,%ebp
  105af2:	83 ec 04             	sub    $0x4,%esp
  105af5:	8b 45 0c             	mov    0xc(%ebp),%eax
  105af8:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105afb:	eb 11                	jmp    105b0e <strfind+0x1f>
        if (*s == c) {
  105afd:	8b 45 08             	mov    0x8(%ebp),%eax
  105b00:	0f b6 00             	movzbl (%eax),%eax
  105b03:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105b06:	75 02                	jne    105b0a <strfind+0x1b>
            break;
  105b08:	eb 0e                	jmp    105b18 <strfind+0x29>
        }
        s ++;
  105b0a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  105b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  105b11:	0f b6 00             	movzbl (%eax),%eax
  105b14:	84 c0                	test   %al,%al
  105b16:	75 e5                	jne    105afd <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  105b18:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105b1b:	c9                   	leave  
  105b1c:	c3                   	ret    

00105b1d <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105b1d:	55                   	push   %ebp
  105b1e:	89 e5                	mov    %esp,%ebp
  105b20:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105b23:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105b2a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105b31:	eb 04                	jmp    105b37 <strtol+0x1a>
        s ++;
  105b33:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105b37:	8b 45 08             	mov    0x8(%ebp),%eax
  105b3a:	0f b6 00             	movzbl (%eax),%eax
  105b3d:	3c 20                	cmp    $0x20,%al
  105b3f:	74 f2                	je     105b33 <strtol+0x16>
  105b41:	8b 45 08             	mov    0x8(%ebp),%eax
  105b44:	0f b6 00             	movzbl (%eax),%eax
  105b47:	3c 09                	cmp    $0x9,%al
  105b49:	74 e8                	je     105b33 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  105b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  105b4e:	0f b6 00             	movzbl (%eax),%eax
  105b51:	3c 2b                	cmp    $0x2b,%al
  105b53:	75 06                	jne    105b5b <strtol+0x3e>
        s ++;
  105b55:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105b59:	eb 15                	jmp    105b70 <strtol+0x53>
    }
    else if (*s == '-') {
  105b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  105b5e:	0f b6 00             	movzbl (%eax),%eax
  105b61:	3c 2d                	cmp    $0x2d,%al
  105b63:	75 0b                	jne    105b70 <strtol+0x53>
        s ++, neg = 1;
  105b65:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105b69:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105b70:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105b74:	74 06                	je     105b7c <strtol+0x5f>
  105b76:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105b7a:	75 24                	jne    105ba0 <strtol+0x83>
  105b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  105b7f:	0f b6 00             	movzbl (%eax),%eax
  105b82:	3c 30                	cmp    $0x30,%al
  105b84:	75 1a                	jne    105ba0 <strtol+0x83>
  105b86:	8b 45 08             	mov    0x8(%ebp),%eax
  105b89:	83 c0 01             	add    $0x1,%eax
  105b8c:	0f b6 00             	movzbl (%eax),%eax
  105b8f:	3c 78                	cmp    $0x78,%al
  105b91:	75 0d                	jne    105ba0 <strtol+0x83>
        s += 2, base = 16;
  105b93:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105b97:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105b9e:	eb 2a                	jmp    105bca <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  105ba0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105ba4:	75 17                	jne    105bbd <strtol+0xa0>
  105ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  105ba9:	0f b6 00             	movzbl (%eax),%eax
  105bac:	3c 30                	cmp    $0x30,%al
  105bae:	75 0d                	jne    105bbd <strtol+0xa0>
        s ++, base = 8;
  105bb0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105bb4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105bbb:	eb 0d                	jmp    105bca <strtol+0xad>
    }
    else if (base == 0) {
  105bbd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105bc1:	75 07                	jne    105bca <strtol+0xad>
        base = 10;
  105bc3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105bca:	8b 45 08             	mov    0x8(%ebp),%eax
  105bcd:	0f b6 00             	movzbl (%eax),%eax
  105bd0:	3c 2f                	cmp    $0x2f,%al
  105bd2:	7e 1b                	jle    105bef <strtol+0xd2>
  105bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  105bd7:	0f b6 00             	movzbl (%eax),%eax
  105bda:	3c 39                	cmp    $0x39,%al
  105bdc:	7f 11                	jg     105bef <strtol+0xd2>
            dig = *s - '0';
  105bde:	8b 45 08             	mov    0x8(%ebp),%eax
  105be1:	0f b6 00             	movzbl (%eax),%eax
  105be4:	0f be c0             	movsbl %al,%eax
  105be7:	83 e8 30             	sub    $0x30,%eax
  105bea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105bed:	eb 48                	jmp    105c37 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105bef:	8b 45 08             	mov    0x8(%ebp),%eax
  105bf2:	0f b6 00             	movzbl (%eax),%eax
  105bf5:	3c 60                	cmp    $0x60,%al
  105bf7:	7e 1b                	jle    105c14 <strtol+0xf7>
  105bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  105bfc:	0f b6 00             	movzbl (%eax),%eax
  105bff:	3c 7a                	cmp    $0x7a,%al
  105c01:	7f 11                	jg     105c14 <strtol+0xf7>
            dig = *s - 'a' + 10;
  105c03:	8b 45 08             	mov    0x8(%ebp),%eax
  105c06:	0f b6 00             	movzbl (%eax),%eax
  105c09:	0f be c0             	movsbl %al,%eax
  105c0c:	83 e8 57             	sub    $0x57,%eax
  105c0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105c12:	eb 23                	jmp    105c37 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105c14:	8b 45 08             	mov    0x8(%ebp),%eax
  105c17:	0f b6 00             	movzbl (%eax),%eax
  105c1a:	3c 40                	cmp    $0x40,%al
  105c1c:	7e 3d                	jle    105c5b <strtol+0x13e>
  105c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  105c21:	0f b6 00             	movzbl (%eax),%eax
  105c24:	3c 5a                	cmp    $0x5a,%al
  105c26:	7f 33                	jg     105c5b <strtol+0x13e>
            dig = *s - 'A' + 10;
  105c28:	8b 45 08             	mov    0x8(%ebp),%eax
  105c2b:	0f b6 00             	movzbl (%eax),%eax
  105c2e:	0f be c0             	movsbl %al,%eax
  105c31:	83 e8 37             	sub    $0x37,%eax
  105c34:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105c3a:	3b 45 10             	cmp    0x10(%ebp),%eax
  105c3d:	7c 02                	jl     105c41 <strtol+0x124>
            break;
  105c3f:	eb 1a                	jmp    105c5b <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  105c41:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105c45:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105c48:	0f af 45 10          	imul   0x10(%ebp),%eax
  105c4c:	89 c2                	mov    %eax,%edx
  105c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105c51:	01 d0                	add    %edx,%eax
  105c53:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  105c56:	e9 6f ff ff ff       	jmp    105bca <strtol+0xad>

    if (endptr) {
  105c5b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105c5f:	74 08                	je     105c69 <strtol+0x14c>
        *endptr = (char *) s;
  105c61:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c64:	8b 55 08             	mov    0x8(%ebp),%edx
  105c67:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105c69:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105c6d:	74 07                	je     105c76 <strtol+0x159>
  105c6f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105c72:	f7 d8                	neg    %eax
  105c74:	eb 03                	jmp    105c79 <strtol+0x15c>
  105c76:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105c79:	c9                   	leave  
  105c7a:	c3                   	ret    

00105c7b <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105c7b:	55                   	push   %ebp
  105c7c:	89 e5                	mov    %esp,%ebp
  105c7e:	57                   	push   %edi
  105c7f:	83 ec 24             	sub    $0x24,%esp
  105c82:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c85:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105c88:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  105c8c:	8b 55 08             	mov    0x8(%ebp),%edx
  105c8f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  105c92:	88 45 f7             	mov    %al,-0x9(%ebp)
  105c95:	8b 45 10             	mov    0x10(%ebp),%eax
  105c98:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105c9b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105c9e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105ca2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105ca5:	89 d7                	mov    %edx,%edi
  105ca7:	f3 aa                	rep stos %al,%es:(%edi)
  105ca9:	89 fa                	mov    %edi,%edx
  105cab:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105cae:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105cb1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105cb4:	83 c4 24             	add    $0x24,%esp
  105cb7:	5f                   	pop    %edi
  105cb8:	5d                   	pop    %ebp
  105cb9:	c3                   	ret    

00105cba <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105cba:	55                   	push   %ebp
  105cbb:	89 e5                	mov    %esp,%ebp
  105cbd:	57                   	push   %edi
  105cbe:	56                   	push   %esi
  105cbf:	53                   	push   %ebx
  105cc0:	83 ec 30             	sub    $0x30,%esp
  105cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  105cc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105cc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ccc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105ccf:	8b 45 10             	mov    0x10(%ebp),%eax
  105cd2:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105cd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105cd8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105cdb:	73 42                	jae    105d1f <memmove+0x65>
  105cdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ce0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105ce3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105ce6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105ce9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105cec:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105cef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105cf2:	c1 e8 02             	shr    $0x2,%eax
  105cf5:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105cf7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105cfa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105cfd:	89 d7                	mov    %edx,%edi
  105cff:	89 c6                	mov    %eax,%esi
  105d01:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105d03:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105d06:	83 e1 03             	and    $0x3,%ecx
  105d09:	74 02                	je     105d0d <memmove+0x53>
  105d0b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105d0d:	89 f0                	mov    %esi,%eax
  105d0f:	89 fa                	mov    %edi,%edx
  105d11:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105d14:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105d17:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105d1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105d1d:	eb 36                	jmp    105d55 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105d1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105d22:	8d 50 ff             	lea    -0x1(%eax),%edx
  105d25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105d28:	01 c2                	add    %eax,%edx
  105d2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105d2d:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105d30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d33:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  105d36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105d39:	89 c1                	mov    %eax,%ecx
  105d3b:	89 d8                	mov    %ebx,%eax
  105d3d:	89 d6                	mov    %edx,%esi
  105d3f:	89 c7                	mov    %eax,%edi
  105d41:	fd                   	std    
  105d42:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105d44:	fc                   	cld    
  105d45:	89 f8                	mov    %edi,%eax
  105d47:	89 f2                	mov    %esi,%edx
  105d49:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105d4c:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105d4f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  105d52:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105d55:	83 c4 30             	add    $0x30,%esp
  105d58:	5b                   	pop    %ebx
  105d59:	5e                   	pop    %esi
  105d5a:	5f                   	pop    %edi
  105d5b:	5d                   	pop    %ebp
  105d5c:	c3                   	ret    

00105d5d <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105d5d:	55                   	push   %ebp
  105d5e:	89 e5                	mov    %esp,%ebp
  105d60:	57                   	push   %edi
  105d61:	56                   	push   %esi
  105d62:	83 ec 20             	sub    $0x20,%esp
  105d65:	8b 45 08             	mov    0x8(%ebp),%eax
  105d68:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105d71:	8b 45 10             	mov    0x10(%ebp),%eax
  105d74:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105d77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105d7a:	c1 e8 02             	shr    $0x2,%eax
  105d7d:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105d7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105d82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d85:	89 d7                	mov    %edx,%edi
  105d87:	89 c6                	mov    %eax,%esi
  105d89:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105d8b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105d8e:	83 e1 03             	and    $0x3,%ecx
  105d91:	74 02                	je     105d95 <memcpy+0x38>
  105d93:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105d95:	89 f0                	mov    %esi,%eax
  105d97:	89 fa                	mov    %edi,%edx
  105d99:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105d9c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105d9f:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105da5:	83 c4 20             	add    $0x20,%esp
  105da8:	5e                   	pop    %esi
  105da9:	5f                   	pop    %edi
  105daa:	5d                   	pop    %ebp
  105dab:	c3                   	ret    

00105dac <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105dac:	55                   	push   %ebp
  105dad:	89 e5                	mov    %esp,%ebp
  105daf:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105db2:	8b 45 08             	mov    0x8(%ebp),%eax
  105db5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105db8:	8b 45 0c             	mov    0xc(%ebp),%eax
  105dbb:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105dbe:	eb 30                	jmp    105df0 <memcmp+0x44>
        if (*s1 != *s2) {
  105dc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105dc3:	0f b6 10             	movzbl (%eax),%edx
  105dc6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105dc9:	0f b6 00             	movzbl (%eax),%eax
  105dcc:	38 c2                	cmp    %al,%dl
  105dce:	74 18                	je     105de8 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105dd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105dd3:	0f b6 00             	movzbl (%eax),%eax
  105dd6:	0f b6 d0             	movzbl %al,%edx
  105dd9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105ddc:	0f b6 00             	movzbl (%eax),%eax
  105ddf:	0f b6 c0             	movzbl %al,%eax
  105de2:	29 c2                	sub    %eax,%edx
  105de4:	89 d0                	mov    %edx,%eax
  105de6:	eb 1a                	jmp    105e02 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  105de8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105dec:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  105df0:	8b 45 10             	mov    0x10(%ebp),%eax
  105df3:	8d 50 ff             	lea    -0x1(%eax),%edx
  105df6:	89 55 10             	mov    %edx,0x10(%ebp)
  105df9:	85 c0                	test   %eax,%eax
  105dfb:	75 c3                	jne    105dc0 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  105dfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105e02:	c9                   	leave  
  105e03:	c3                   	ret    
