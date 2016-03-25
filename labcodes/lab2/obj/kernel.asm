
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
c0100051:	e8 2b 5c 00 00       	call   c0105c81 <memset>

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
c010007f:	e8 ad 42 00 00       	call   c0104331 <pmm_init>

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
c0100332:	e8 63 51 00 00       	call   c010549a <vprintfmt>
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
c010057a:	c7 45 f0 3c 1b 11 c0 	movl   $0xc0111b3c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100581:	c7 45 ec 3d 1b 11 c0 	movl   $0xc0111b3d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100588:	c7 45 e8 9f 45 11 c0 	movl   $0xc011459f,-0x18(%ebp)

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
c01006e7:	e8 09 54 00 00       	call   c0105af5 <strfind>
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
c0100896:	c7 44 24 04 0a 5e 10 	movl   $0xc0105e0a,0x4(%esp)
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
c0100ac3:	e8 fa 4f 00 00       	call   c0105ac2 <strchr>
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
c0100b30:	e8 8d 4f 00 00       	call   c0105ac2 <strchr>
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
c0100b95:	e8 89 4e 00 00       	call   c0105a23 <strcmp>
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
c0101206:	e8 b5 4a 00 00       	call   c0105cc0 <memmove>
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
			ClearPageReserved(current_page);
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
			ClearPageReserved(current_page);
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
c0102c70:	c7 44 24 04 7e 00 00 	movl   $0x7e,0x4(%esp)
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
	SetPageReserved(base);
c0102c97:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c9a:	83 c0 04             	add    $0x4,%eax
c0102c9d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102ca4:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102ca7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102caa:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102cad:	0f ab 10             	bts    %edx,(%eax)
	SetPageProperty(base);
c0102cb0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cb3:	83 c0 04             	add    $0x4,%eax
c0102cb6:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0102cbd:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102cc0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102cc3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102cc6:	0f ab 10             	bts    %edx,(%eax)
	set_page_ref(base, 0);
c0102cc9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102cd0:	00 
c0102cd1:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cd4:	89 04 24             	mov    %eax,(%esp)
c0102cd7:	e8 17 fc ff ff       	call   c01028f3 <set_page_ref>
c0102cdc:	c7 45 dc 50 89 11 c0 	movl   $0xc0118950,-0x24(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102ce3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102ce6:	8b 40 04             	mov    0x4(%eax),%eax
	

	// 遍历链表寻求找插入位置
    list_entry_t *le = list_next(&free_list);
c0102ce9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    struct Page *p;
    while (le != &free_list) {
c0102cec:	eb 33                	jmp    c0102d21 <default_free_pages+0xcd>
        p = le2page(le, page_link);
c0102cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cf1:	83 e8 0c             	sub    $0xc,%eax
c0102cf4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		// 这次遍历首先要找到刚好在base块后面的那一个空闲页
		if (p >= base + n) {
c0102cf7:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102cfa:	89 d0                	mov    %edx,%eax
c0102cfc:	c1 e0 02             	shl    $0x2,%eax
c0102cff:	01 d0                	add    %edx,%eax
c0102d01:	c1 e0 02             	shl    $0x2,%eax
c0102d04:	89 c2                	mov    %eax,%edx
c0102d06:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d09:	01 d0                	add    %edx,%eax
c0102d0b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102d0e:	77 02                	ja     c0102d12 <default_free_pages+0xbe>
			break;
c0102d10:	eb 18                	jmp    c0102d2a <default_free_pages+0xd6>
c0102d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d15:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0102d18:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102d1b:	8b 40 04             	mov    0x4(%eax),%eax
		}
		le = list_next(le);
c0102d1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	

	// 遍历链表寻求找插入位置
    list_entry_t *le = list_next(&free_list);
    struct Page *p;
    while (le != &free_list) {
c0102d21:	81 7d f4 50 89 11 c0 	cmpl   $0xc0118950,-0xc(%ebp)
c0102d28:	75 c4                	jne    c0102cee <default_free_pages+0x9a>
		}
		le = list_next(le);
	}

	// 当前的le就是链表的下一项
	list_add_before(le, &(base->page_link));
c0102d2a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d2d:	8d 50 0c             	lea    0xc(%eax),%edx
c0102d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d33:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0102d36:	89 55 d0             	mov    %edx,-0x30(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102d39:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102d3c:	8b 00                	mov    (%eax),%eax
c0102d3e:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102d41:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0102d44:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102d47:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102d4a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102d4d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102d50:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102d53:	89 10                	mov    %edx,(%eax)
c0102d55:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102d58:	8b 10                	mov    (%eax),%edx
c0102d5a:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102d5d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102d60:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102d63:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102d66:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102d69:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102d6c:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102d6f:	89 10                	mov    %edx,(%eax)

	// 向后合并
    if (base + base->property == p) {
c0102d71:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d74:	8b 50 08             	mov    0x8(%eax),%edx
c0102d77:	89 d0                	mov    %edx,%eax
c0102d79:	c1 e0 02             	shl    $0x2,%eax
c0102d7c:	01 d0                	add    %edx,%eax
c0102d7e:	c1 e0 02             	shl    $0x2,%eax
c0102d81:	89 c2                	mov    %eax,%edx
c0102d83:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d86:	01 d0                	add    %edx,%eax
c0102d88:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102d8b:	75 49                	jne    c0102dd6 <default_free_pages+0x182>
        base->property += p->property;
c0102d8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d90:	8b 50 08             	mov    0x8(%eax),%edx
c0102d93:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d96:	8b 40 08             	mov    0x8(%eax),%eax
c0102d99:	01 c2                	add    %eax,%edx
c0102d9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d9e:	89 50 08             	mov    %edx,0x8(%eax)
		p->property = 0;
c0102da1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102da4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        list_del(&(p->page_link));
c0102dab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102dae:	83 c0 0c             	add    $0xc,%eax
c0102db1:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102db4:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102db7:	8b 40 04             	mov    0x4(%eax),%eax
c0102dba:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102dbd:	8b 12                	mov    (%edx),%edx
c0102dbf:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0102dc2:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102dc5:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102dc8:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102dcb:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102dce:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102dd1:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102dd4:	89 10                	mov    %edx,(%eax)
    }
    // 向前合并
	p = le2page(list_prev(&(base->page_link)), page_link);
c0102dd6:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dd9:	83 c0 0c             	add    $0xc,%eax
c0102ddc:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0102ddf:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102de2:	8b 00                	mov    (%eax),%eax
c0102de4:	83 e8 0c             	sub    $0xc,%eax
c0102de7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (p + p->property == base) {
c0102dea:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ded:	8b 50 08             	mov    0x8(%eax),%edx
c0102df0:	89 d0                	mov    %edx,%eax
c0102df2:	c1 e0 02             	shl    $0x2,%eax
c0102df5:	01 d0                	add    %edx,%eax
c0102df7:	c1 e0 02             	shl    $0x2,%eax
c0102dfa:	89 c2                	mov    %eax,%edx
c0102dfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102dff:	01 d0                	add    %edx,%eax
c0102e01:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102e04:	75 49                	jne    c0102e4f <default_free_pages+0x1fb>
        p->property += base->property;
c0102e06:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e09:	8b 50 08             	mov    0x8(%eax),%edx
c0102e0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e0f:	8b 40 08             	mov    0x8(%eax),%eax
c0102e12:	01 c2                	add    %eax,%edx
c0102e14:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e17:	89 50 08             	mov    %edx,0x8(%eax)
        base->property = 0;
c0102e1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e1d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        list_del(&(base->page_link));
c0102e24:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e27:	83 c0 0c             	add    $0xc,%eax
c0102e2a:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102e2d:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102e30:	8b 40 04             	mov    0x4(%eax),%eax
c0102e33:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102e36:	8b 12                	mov    (%edx),%edx
c0102e38:	89 55 ac             	mov    %edx,-0x54(%ebp)
c0102e3b:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102e3e:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102e41:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102e44:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102e47:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102e4a:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0102e4d:	89 10                	mov    %edx,(%eax)
    }

    nr_free += n;
c0102e4f:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c0102e55:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102e58:	01 d0                	add    %edx,%eax
c0102e5a:	a3 58 89 11 c0       	mov    %eax,0xc0118958
    return;
c0102e5f:	90                   	nop
}
c0102e60:	c9                   	leave  
c0102e61:	c3                   	ret    

c0102e62 <default_nr_free_pages>:
    return;
}
*/

static size_t
default_nr_free_pages(void) {
c0102e62:	55                   	push   %ebp
c0102e63:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102e65:	a1 58 89 11 c0       	mov    0xc0118958,%eax
}
c0102e6a:	5d                   	pop    %ebp
c0102e6b:	c3                   	ret    

c0102e6c <basic_check>:

static void
basic_check(void) {
c0102e6c:	55                   	push   %ebp
c0102e6d:	89 e5                	mov    %esp,%ebp
c0102e6f:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102e72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102e7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e82:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102e85:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102e8c:	e8 90 0e 00 00       	call   c0103d21 <alloc_pages>
c0102e91:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102e94:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102e98:	75 24                	jne    c0102ebe <basic_check+0x52>
c0102e9a:	c7 44 24 0c 91 65 10 	movl   $0xc0106591,0xc(%esp)
c0102ea1:	c0 
c0102ea2:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c0102ea9:	c0 
c0102eaa:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
c0102eb1:	00 
c0102eb2:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0102eb9:	e8 19 de ff ff       	call   c0100cd7 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102ebe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102ec5:	e8 57 0e 00 00       	call   c0103d21 <alloc_pages>
c0102eca:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102ecd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102ed1:	75 24                	jne    c0102ef7 <basic_check+0x8b>
c0102ed3:	c7 44 24 0c ad 65 10 	movl   $0xc01065ad,0xc(%esp)
c0102eda:	c0 
c0102edb:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c0102ee2:	c0 
c0102ee3:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c0102eea:	00 
c0102eeb:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0102ef2:	e8 e0 dd ff ff       	call   c0100cd7 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102ef7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102efe:	e8 1e 0e 00 00       	call   c0103d21 <alloc_pages>
c0102f03:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102f06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102f0a:	75 24                	jne    c0102f30 <basic_check+0xc4>
c0102f0c:	c7 44 24 0c c9 65 10 	movl   $0xc01065c9,0xc(%esp)
c0102f13:	c0 
c0102f14:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c0102f1b:	c0 
c0102f1c:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0102f23:	00 
c0102f24:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0102f2b:	e8 a7 dd ff ff       	call   c0100cd7 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0102f30:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f33:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102f36:	74 10                	je     c0102f48 <basic_check+0xdc>
c0102f38:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f3b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102f3e:	74 08                	je     c0102f48 <basic_check+0xdc>
c0102f40:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f43:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102f46:	75 24                	jne    c0102f6c <basic_check+0x100>
c0102f48:	c7 44 24 0c e8 65 10 	movl   $0xc01065e8,0xc(%esp)
c0102f4f:	c0 
c0102f50:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c0102f57:	c0 
c0102f58:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c0102f5f:	00 
c0102f60:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0102f67:	e8 6b dd ff ff       	call   c0100cd7 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0102f6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f6f:	89 04 24             	mov    %eax,(%esp)
c0102f72:	e8 72 f9 ff ff       	call   c01028e9 <page_ref>
c0102f77:	85 c0                	test   %eax,%eax
c0102f79:	75 1e                	jne    c0102f99 <basic_check+0x12d>
c0102f7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f7e:	89 04 24             	mov    %eax,(%esp)
c0102f81:	e8 63 f9 ff ff       	call   c01028e9 <page_ref>
c0102f86:	85 c0                	test   %eax,%eax
c0102f88:	75 0f                	jne    c0102f99 <basic_check+0x12d>
c0102f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f8d:	89 04 24             	mov    %eax,(%esp)
c0102f90:	e8 54 f9 ff ff       	call   c01028e9 <page_ref>
c0102f95:	85 c0                	test   %eax,%eax
c0102f97:	74 24                	je     c0102fbd <basic_check+0x151>
c0102f99:	c7 44 24 0c 0c 66 10 	movl   $0xc010660c,0xc(%esp)
c0102fa0:	c0 
c0102fa1:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c0102fa8:	c0 
c0102fa9:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
c0102fb0:	00 
c0102fb1:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0102fb8:	e8 1a dd ff ff       	call   c0100cd7 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0102fbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102fc0:	89 04 24             	mov    %eax,(%esp)
c0102fc3:	e8 0b f9 ff ff       	call   c01028d3 <page2pa>
c0102fc8:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102fce:	c1 e2 0c             	shl    $0xc,%edx
c0102fd1:	39 d0                	cmp    %edx,%eax
c0102fd3:	72 24                	jb     c0102ff9 <basic_check+0x18d>
c0102fd5:	c7 44 24 0c 48 66 10 	movl   $0xc0106648,0xc(%esp)
c0102fdc:	c0 
c0102fdd:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c0102fe4:	c0 
c0102fe5:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0102fec:	00 
c0102fed:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0102ff4:	e8 de dc ff ff       	call   c0100cd7 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0102ff9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ffc:	89 04 24             	mov    %eax,(%esp)
c0102fff:	e8 cf f8 ff ff       	call   c01028d3 <page2pa>
c0103004:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c010300a:	c1 e2 0c             	shl    $0xc,%edx
c010300d:	39 d0                	cmp    %edx,%eax
c010300f:	72 24                	jb     c0103035 <basic_check+0x1c9>
c0103011:	c7 44 24 0c 65 66 10 	movl   $0xc0106665,0xc(%esp)
c0103018:	c0 
c0103019:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c0103020:	c0 
c0103021:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c0103028:	00 
c0103029:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0103030:	e8 a2 dc ff ff       	call   c0100cd7 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0103035:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103038:	89 04 24             	mov    %eax,(%esp)
c010303b:	e8 93 f8 ff ff       	call   c01028d3 <page2pa>
c0103040:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0103046:	c1 e2 0c             	shl    $0xc,%edx
c0103049:	39 d0                	cmp    %edx,%eax
c010304b:	72 24                	jb     c0103071 <basic_check+0x205>
c010304d:	c7 44 24 0c 82 66 10 	movl   $0xc0106682,0xc(%esp)
c0103054:	c0 
c0103055:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c010305c:	c0 
c010305d:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c0103064:	00 
c0103065:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c010306c:	e8 66 dc ff ff       	call   c0100cd7 <__panic>

    list_entry_t free_list_store = free_list;
c0103071:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0103076:	8b 15 54 89 11 c0    	mov    0xc0118954,%edx
c010307c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010307f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103082:	c7 45 e0 50 89 11 c0 	movl   $0xc0118950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103089:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010308c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010308f:	89 50 04             	mov    %edx,0x4(%eax)
c0103092:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103095:	8b 50 04             	mov    0x4(%eax),%edx
c0103098:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010309b:	89 10                	mov    %edx,(%eax)
c010309d:	c7 45 dc 50 89 11 c0 	movl   $0xc0118950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01030a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01030a7:	8b 40 04             	mov    0x4(%eax),%eax
c01030aa:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01030ad:	0f 94 c0             	sete   %al
c01030b0:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01030b3:	85 c0                	test   %eax,%eax
c01030b5:	75 24                	jne    c01030db <basic_check+0x26f>
c01030b7:	c7 44 24 0c 9f 66 10 	movl   $0xc010669f,0xc(%esp)
c01030be:	c0 
c01030bf:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c01030c6:	c0 
c01030c7:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
c01030ce:	00 
c01030cf:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c01030d6:	e8 fc db ff ff       	call   c0100cd7 <__panic>

    unsigned int nr_free_store = nr_free;
c01030db:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c01030e0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c01030e3:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c01030ea:	00 00 00 

    assert(alloc_page() == NULL);
c01030ed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01030f4:	e8 28 0c 00 00       	call   c0103d21 <alloc_pages>
c01030f9:	85 c0                	test   %eax,%eax
c01030fb:	74 24                	je     c0103121 <basic_check+0x2b5>
c01030fd:	c7 44 24 0c b6 66 10 	movl   $0xc01066b6,0xc(%esp)
c0103104:	c0 
c0103105:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c010310c:	c0 
c010310d:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c0103114:	00 
c0103115:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c010311c:	e8 b6 db ff ff       	call   c0100cd7 <__panic>

    free_page(p0);
c0103121:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103128:	00 
c0103129:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010312c:	89 04 24             	mov    %eax,(%esp)
c010312f:	e8 25 0c 00 00       	call   c0103d59 <free_pages>
    free_page(p1);
c0103134:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010313b:	00 
c010313c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010313f:	89 04 24             	mov    %eax,(%esp)
c0103142:	e8 12 0c 00 00       	call   c0103d59 <free_pages>
    free_page(p2);
c0103147:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010314e:	00 
c010314f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103152:	89 04 24             	mov    %eax,(%esp)
c0103155:	e8 ff 0b 00 00       	call   c0103d59 <free_pages>
    assert(nr_free == 3);
c010315a:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c010315f:	83 f8 03             	cmp    $0x3,%eax
c0103162:	74 24                	je     c0103188 <basic_check+0x31c>
c0103164:	c7 44 24 0c cb 66 10 	movl   $0xc01066cb,0xc(%esp)
c010316b:	c0 
c010316c:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c0103173:	c0 
c0103174:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
c010317b:	00 
c010317c:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0103183:	e8 4f db ff ff       	call   c0100cd7 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103188:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010318f:	e8 8d 0b 00 00       	call   c0103d21 <alloc_pages>
c0103194:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103197:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010319b:	75 24                	jne    c01031c1 <basic_check+0x355>
c010319d:	c7 44 24 0c 91 65 10 	movl   $0xc0106591,0xc(%esp)
c01031a4:	c0 
c01031a5:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c01031ac:	c0 
c01031ad:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c01031b4:	00 
c01031b5:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c01031bc:	e8 16 db ff ff       	call   c0100cd7 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01031c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031c8:	e8 54 0b 00 00       	call   c0103d21 <alloc_pages>
c01031cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01031d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01031d4:	75 24                	jne    c01031fa <basic_check+0x38e>
c01031d6:	c7 44 24 0c ad 65 10 	movl   $0xc01065ad,0xc(%esp)
c01031dd:	c0 
c01031de:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c01031e5:	c0 
c01031e6:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c01031ed:	00 
c01031ee:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c01031f5:	e8 dd da ff ff       	call   c0100cd7 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01031fa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103201:	e8 1b 0b 00 00       	call   c0103d21 <alloc_pages>
c0103206:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103209:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010320d:	75 24                	jne    c0103233 <basic_check+0x3c7>
c010320f:	c7 44 24 0c c9 65 10 	movl   $0xc01065c9,0xc(%esp)
c0103216:	c0 
c0103217:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c010321e:	c0 
c010321f:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0103226:	00 
c0103227:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c010322e:	e8 a4 da ff ff       	call   c0100cd7 <__panic>

    assert(alloc_page() == NULL);
c0103233:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010323a:	e8 e2 0a 00 00       	call   c0103d21 <alloc_pages>
c010323f:	85 c0                	test   %eax,%eax
c0103241:	74 24                	je     c0103267 <basic_check+0x3fb>
c0103243:	c7 44 24 0c b6 66 10 	movl   $0xc01066b6,0xc(%esp)
c010324a:	c0 
c010324b:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c0103252:	c0 
c0103253:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c010325a:	00 
c010325b:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0103262:	e8 70 da ff ff       	call   c0100cd7 <__panic>

    free_page(p0);
c0103267:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010326e:	00 
c010326f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103272:	89 04 24             	mov    %eax,(%esp)
c0103275:	e8 df 0a 00 00       	call   c0103d59 <free_pages>
c010327a:	c7 45 d8 50 89 11 c0 	movl   $0xc0118950,-0x28(%ebp)
c0103281:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103284:	8b 40 04             	mov    0x4(%eax),%eax
c0103287:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c010328a:	0f 94 c0             	sete   %al
c010328d:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103290:	85 c0                	test   %eax,%eax
c0103292:	74 24                	je     c01032b8 <basic_check+0x44c>
c0103294:	c7 44 24 0c d8 66 10 	movl   $0xc01066d8,0xc(%esp)
c010329b:	c0 
c010329c:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c01032a3:	c0 
c01032a4:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c01032ab:	00 
c01032ac:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c01032b3:	e8 1f da ff ff       	call   c0100cd7 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c01032b8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032bf:	e8 5d 0a 00 00       	call   c0103d21 <alloc_pages>
c01032c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01032c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01032ca:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01032cd:	74 24                	je     c01032f3 <basic_check+0x487>
c01032cf:	c7 44 24 0c f0 66 10 	movl   $0xc01066f0,0xc(%esp)
c01032d6:	c0 
c01032d7:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c01032de:	c0 
c01032df:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c01032e6:	00 
c01032e7:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c01032ee:	e8 e4 d9 ff ff       	call   c0100cd7 <__panic>
    assert(alloc_page() == NULL);
c01032f3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032fa:	e8 22 0a 00 00       	call   c0103d21 <alloc_pages>
c01032ff:	85 c0                	test   %eax,%eax
c0103301:	74 24                	je     c0103327 <basic_check+0x4bb>
c0103303:	c7 44 24 0c b6 66 10 	movl   $0xc01066b6,0xc(%esp)
c010330a:	c0 
c010330b:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c0103312:	c0 
c0103313:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c010331a:	00 
c010331b:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0103322:	e8 b0 d9 ff ff       	call   c0100cd7 <__panic>

    assert(nr_free == 0);
c0103327:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c010332c:	85 c0                	test   %eax,%eax
c010332e:	74 24                	je     c0103354 <basic_check+0x4e8>
c0103330:	c7 44 24 0c 09 67 10 	movl   $0xc0106709,0xc(%esp)
c0103337:	c0 
c0103338:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c010333f:	c0 
c0103340:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
c0103347:	00 
c0103348:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c010334f:	e8 83 d9 ff ff       	call   c0100cd7 <__panic>
    free_list = free_list_store;
c0103354:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103357:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010335a:	a3 50 89 11 c0       	mov    %eax,0xc0118950
c010335f:	89 15 54 89 11 c0    	mov    %edx,0xc0118954
    nr_free = nr_free_store;
c0103365:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103368:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    free_page(p);
c010336d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103374:	00 
c0103375:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103378:	89 04 24             	mov    %eax,(%esp)
c010337b:	e8 d9 09 00 00       	call   c0103d59 <free_pages>
    free_page(p1);
c0103380:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103387:	00 
c0103388:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010338b:	89 04 24             	mov    %eax,(%esp)
c010338e:	e8 c6 09 00 00       	call   c0103d59 <free_pages>
    free_page(p2);
c0103393:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010339a:	00 
c010339b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010339e:	89 04 24             	mov    %eax,(%esp)
c01033a1:	e8 b3 09 00 00       	call   c0103d59 <free_pages>
}
c01033a6:	c9                   	leave  
c01033a7:	c3                   	ret    

c01033a8 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c01033a8:	55                   	push   %ebp
c01033a9:	89 e5                	mov    %esp,%ebp
c01033ab:	53                   	push   %ebx
c01033ac:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c01033b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01033b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c01033c0:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01033c7:	eb 6b                	jmp    c0103434 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c01033c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033cc:	83 e8 0c             	sub    $0xc,%eax
c01033cf:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c01033d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033d5:	83 c0 04             	add    $0x4,%eax
c01033d8:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01033df:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01033e2:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01033e5:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01033e8:	0f a3 10             	bt     %edx,(%eax)
c01033eb:	19 c0                	sbb    %eax,%eax
c01033ed:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c01033f0:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c01033f4:	0f 95 c0             	setne  %al
c01033f7:	0f b6 c0             	movzbl %al,%eax
c01033fa:	85 c0                	test   %eax,%eax
c01033fc:	75 24                	jne    c0103422 <default_check+0x7a>
c01033fe:	c7 44 24 0c 16 67 10 	movl   $0xc0106716,0xc(%esp)
c0103405:	c0 
c0103406:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c010340d:	c0 
c010340e:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c0103415:	00 
c0103416:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c010341d:	e8 b5 d8 ff ff       	call   c0100cd7 <__panic>
        count ++, total += p->property;
c0103422:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103426:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103429:	8b 50 08             	mov    0x8(%eax),%edx
c010342c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010342f:	01 d0                	add    %edx,%eax
c0103431:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103434:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103437:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010343a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010343d:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103440:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103443:	81 7d ec 50 89 11 c0 	cmpl   $0xc0118950,-0x14(%ebp)
c010344a:	0f 85 79 ff ff ff    	jne    c01033c9 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0103450:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0103453:	e8 33 09 00 00       	call   c0103d8b <nr_free_pages>
c0103458:	39 c3                	cmp    %eax,%ebx
c010345a:	74 24                	je     c0103480 <default_check+0xd8>
c010345c:	c7 44 24 0c 26 67 10 	movl   $0xc0106726,0xc(%esp)
c0103463:	c0 
c0103464:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c010346b:	c0 
c010346c:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
c0103473:	00 
c0103474:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c010347b:	e8 57 d8 ff ff       	call   c0100cd7 <__panic>

    basic_check();
c0103480:	e8 e7 f9 ff ff       	call   c0102e6c <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103485:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010348c:	e8 90 08 00 00       	call   c0103d21 <alloc_pages>
c0103491:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0103494:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103498:	75 24                	jne    c01034be <default_check+0x116>
c010349a:	c7 44 24 0c 3f 67 10 	movl   $0xc010673f,0xc(%esp)
c01034a1:	c0 
c01034a2:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c01034a9:	c0 
c01034aa:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
c01034b1:	00 
c01034b2:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c01034b9:	e8 19 d8 ff ff       	call   c0100cd7 <__panic>
    assert(!PageProperty(p0));
c01034be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01034c1:	83 c0 04             	add    $0x4,%eax
c01034c4:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01034cb:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01034ce:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01034d1:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01034d4:	0f a3 10             	bt     %edx,(%eax)
c01034d7:	19 c0                	sbb    %eax,%eax
c01034d9:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c01034dc:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01034e0:	0f 95 c0             	setne  %al
c01034e3:	0f b6 c0             	movzbl %al,%eax
c01034e6:	85 c0                	test   %eax,%eax
c01034e8:	74 24                	je     c010350e <default_check+0x166>
c01034ea:	c7 44 24 0c 4a 67 10 	movl   $0xc010674a,0xc(%esp)
c01034f1:	c0 
c01034f2:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c01034f9:	c0 
c01034fa:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
c0103501:	00 
c0103502:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0103509:	e8 c9 d7 ff ff       	call   c0100cd7 <__panic>

    list_entry_t free_list_store = free_list;
c010350e:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0103513:	8b 15 54 89 11 c0    	mov    0xc0118954,%edx
c0103519:	89 45 80             	mov    %eax,-0x80(%ebp)
c010351c:	89 55 84             	mov    %edx,-0x7c(%ebp)
c010351f:	c7 45 b4 50 89 11 c0 	movl   $0xc0118950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103526:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103529:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010352c:	89 50 04             	mov    %edx,0x4(%eax)
c010352f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103532:	8b 50 04             	mov    0x4(%eax),%edx
c0103535:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103538:	89 10                	mov    %edx,(%eax)
c010353a:	c7 45 b0 50 89 11 c0 	movl   $0xc0118950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103541:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103544:	8b 40 04             	mov    0x4(%eax),%eax
c0103547:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c010354a:	0f 94 c0             	sete   %al
c010354d:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103550:	85 c0                	test   %eax,%eax
c0103552:	75 24                	jne    c0103578 <default_check+0x1d0>
c0103554:	c7 44 24 0c 9f 66 10 	movl   $0xc010669f,0xc(%esp)
c010355b:	c0 
c010355c:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c0103563:	c0 
c0103564:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c010356b:	00 
c010356c:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0103573:	e8 5f d7 ff ff       	call   c0100cd7 <__panic>
    assert(alloc_page() == NULL);
c0103578:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010357f:	e8 9d 07 00 00       	call   c0103d21 <alloc_pages>
c0103584:	85 c0                	test   %eax,%eax
c0103586:	74 24                	je     c01035ac <default_check+0x204>
c0103588:	c7 44 24 0c b6 66 10 	movl   $0xc01066b6,0xc(%esp)
c010358f:	c0 
c0103590:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c0103597:	c0 
c0103598:	c7 44 24 04 25 01 00 	movl   $0x125,0x4(%esp)
c010359f:	00 
c01035a0:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c01035a7:	e8 2b d7 ff ff       	call   c0100cd7 <__panic>

    unsigned int nr_free_store = nr_free;
c01035ac:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c01035b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c01035b4:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c01035bb:	00 00 00 

    free_pages(p0 + 2, 3);
c01035be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035c1:	83 c0 28             	add    $0x28,%eax
c01035c4:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01035cb:	00 
c01035cc:	89 04 24             	mov    %eax,(%esp)
c01035cf:	e8 85 07 00 00       	call   c0103d59 <free_pages>
    assert(alloc_pages(4) == NULL);
c01035d4:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01035db:	e8 41 07 00 00       	call   c0103d21 <alloc_pages>
c01035e0:	85 c0                	test   %eax,%eax
c01035e2:	74 24                	je     c0103608 <default_check+0x260>
c01035e4:	c7 44 24 0c 5c 67 10 	movl   $0xc010675c,0xc(%esp)
c01035eb:	c0 
c01035ec:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c01035f3:	c0 
c01035f4:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
c01035fb:	00 
c01035fc:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0103603:	e8 cf d6 ff ff       	call   c0100cd7 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0103608:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010360b:	83 c0 28             	add    $0x28,%eax
c010360e:	83 c0 04             	add    $0x4,%eax
c0103611:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103618:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010361b:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010361e:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103621:	0f a3 10             	bt     %edx,(%eax)
c0103624:	19 c0                	sbb    %eax,%eax
c0103626:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103629:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c010362d:	0f 95 c0             	setne  %al
c0103630:	0f b6 c0             	movzbl %al,%eax
c0103633:	85 c0                	test   %eax,%eax
c0103635:	74 0e                	je     c0103645 <default_check+0x29d>
c0103637:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010363a:	83 c0 28             	add    $0x28,%eax
c010363d:	8b 40 08             	mov    0x8(%eax),%eax
c0103640:	83 f8 03             	cmp    $0x3,%eax
c0103643:	74 24                	je     c0103669 <default_check+0x2c1>
c0103645:	c7 44 24 0c 74 67 10 	movl   $0xc0106774,0xc(%esp)
c010364c:	c0 
c010364d:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c0103654:	c0 
c0103655:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c010365c:	00 
c010365d:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0103664:	e8 6e d6 ff ff       	call   c0100cd7 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103669:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0103670:	e8 ac 06 00 00       	call   c0103d21 <alloc_pages>
c0103675:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103678:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010367c:	75 24                	jne    c01036a2 <default_check+0x2fa>
c010367e:	c7 44 24 0c a0 67 10 	movl   $0xc01067a0,0xc(%esp)
c0103685:	c0 
c0103686:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c010368d:	c0 
c010368e:	c7 44 24 04 2d 01 00 	movl   $0x12d,0x4(%esp)
c0103695:	00 
c0103696:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c010369d:	e8 35 d6 ff ff       	call   c0100cd7 <__panic>
    assert(alloc_page() == NULL);
c01036a2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01036a9:	e8 73 06 00 00       	call   c0103d21 <alloc_pages>
c01036ae:	85 c0                	test   %eax,%eax
c01036b0:	74 24                	je     c01036d6 <default_check+0x32e>
c01036b2:	c7 44 24 0c b6 66 10 	movl   $0xc01066b6,0xc(%esp)
c01036b9:	c0 
c01036ba:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c01036c1:	c0 
c01036c2:	c7 44 24 04 2e 01 00 	movl   $0x12e,0x4(%esp)
c01036c9:	00 
c01036ca:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c01036d1:	e8 01 d6 ff ff       	call   c0100cd7 <__panic>
    assert(p0 + 2 == p1);
c01036d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036d9:	83 c0 28             	add    $0x28,%eax
c01036dc:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01036df:	74 24                	je     c0103705 <default_check+0x35d>
c01036e1:	c7 44 24 0c be 67 10 	movl   $0xc01067be,0xc(%esp)
c01036e8:	c0 
c01036e9:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c01036f0:	c0 
c01036f1:	c7 44 24 04 2f 01 00 	movl   $0x12f,0x4(%esp)
c01036f8:	00 
c01036f9:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0103700:	e8 d2 d5 ff ff       	call   c0100cd7 <__panic>

    p2 = p0 + 1;
c0103705:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103708:	83 c0 14             	add    $0x14,%eax
c010370b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c010370e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103715:	00 
c0103716:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103719:	89 04 24             	mov    %eax,(%esp)
c010371c:	e8 38 06 00 00       	call   c0103d59 <free_pages>
    free_pages(p1, 3);
c0103721:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103728:	00 
c0103729:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010372c:	89 04 24             	mov    %eax,(%esp)
c010372f:	e8 25 06 00 00       	call   c0103d59 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0103734:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103737:	83 c0 04             	add    $0x4,%eax
c010373a:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0103741:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103744:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103747:	8b 55 a0             	mov    -0x60(%ebp),%edx
c010374a:	0f a3 10             	bt     %edx,(%eax)
c010374d:	19 c0                	sbb    %eax,%eax
c010374f:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0103752:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0103756:	0f 95 c0             	setne  %al
c0103759:	0f b6 c0             	movzbl %al,%eax
c010375c:	85 c0                	test   %eax,%eax
c010375e:	74 0b                	je     c010376b <default_check+0x3c3>
c0103760:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103763:	8b 40 08             	mov    0x8(%eax),%eax
c0103766:	83 f8 01             	cmp    $0x1,%eax
c0103769:	74 24                	je     c010378f <default_check+0x3e7>
c010376b:	c7 44 24 0c cc 67 10 	movl   $0xc01067cc,0xc(%esp)
c0103772:	c0 
c0103773:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c010377a:	c0 
c010377b:	c7 44 24 04 34 01 00 	movl   $0x134,0x4(%esp)
c0103782:	00 
c0103783:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c010378a:	e8 48 d5 ff ff       	call   c0100cd7 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c010378f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103792:	83 c0 04             	add    $0x4,%eax
c0103795:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c010379c:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010379f:	8b 45 90             	mov    -0x70(%ebp),%eax
c01037a2:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01037a5:	0f a3 10             	bt     %edx,(%eax)
c01037a8:	19 c0                	sbb    %eax,%eax
c01037aa:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c01037ad:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01037b1:	0f 95 c0             	setne  %al
c01037b4:	0f b6 c0             	movzbl %al,%eax
c01037b7:	85 c0                	test   %eax,%eax
c01037b9:	74 0b                	je     c01037c6 <default_check+0x41e>
c01037bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01037be:	8b 40 08             	mov    0x8(%eax),%eax
c01037c1:	83 f8 03             	cmp    $0x3,%eax
c01037c4:	74 24                	je     c01037ea <default_check+0x442>
c01037c6:	c7 44 24 0c f4 67 10 	movl   $0xc01067f4,0xc(%esp)
c01037cd:	c0 
c01037ce:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c01037d5:	c0 
c01037d6:	c7 44 24 04 35 01 00 	movl   $0x135,0x4(%esp)
c01037dd:	00 
c01037de:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c01037e5:	e8 ed d4 ff ff       	call   c0100cd7 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01037ea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01037f1:	e8 2b 05 00 00       	call   c0103d21 <alloc_pages>
c01037f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01037f9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01037fc:	83 e8 14             	sub    $0x14,%eax
c01037ff:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103802:	74 24                	je     c0103828 <default_check+0x480>
c0103804:	c7 44 24 0c 1a 68 10 	movl   $0xc010681a,0xc(%esp)
c010380b:	c0 
c010380c:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c0103813:	c0 
c0103814:	c7 44 24 04 37 01 00 	movl   $0x137,0x4(%esp)
c010381b:	00 
c010381c:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0103823:	e8 af d4 ff ff       	call   c0100cd7 <__panic>
    free_page(p0);
c0103828:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010382f:	00 
c0103830:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103833:	89 04 24             	mov    %eax,(%esp)
c0103836:	e8 1e 05 00 00       	call   c0103d59 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c010383b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0103842:	e8 da 04 00 00       	call   c0103d21 <alloc_pages>
c0103847:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010384a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010384d:	83 c0 14             	add    $0x14,%eax
c0103850:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103853:	74 24                	je     c0103879 <default_check+0x4d1>
c0103855:	c7 44 24 0c 38 68 10 	movl   $0xc0106838,0xc(%esp)
c010385c:	c0 
c010385d:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c0103864:	c0 
c0103865:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
c010386c:	00 
c010386d:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0103874:	e8 5e d4 ff ff       	call   c0100cd7 <__panic>

    free_pages(p0, 2);
c0103879:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0103880:	00 
c0103881:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103884:	89 04 24             	mov    %eax,(%esp)
c0103887:	e8 cd 04 00 00       	call   c0103d59 <free_pages>
    free_page(p2);
c010388c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103893:	00 
c0103894:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103897:	89 04 24             	mov    %eax,(%esp)
c010389a:	e8 ba 04 00 00       	call   c0103d59 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c010389f:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01038a6:	e8 76 04 00 00       	call   c0103d21 <alloc_pages>
c01038ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01038ae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01038b2:	75 24                	jne    c01038d8 <default_check+0x530>
c01038b4:	c7 44 24 0c 58 68 10 	movl   $0xc0106858,0xc(%esp)
c01038bb:	c0 
c01038bc:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c01038c3:	c0 
c01038c4:	c7 44 24 04 3e 01 00 	movl   $0x13e,0x4(%esp)
c01038cb:	00 
c01038cc:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c01038d3:	e8 ff d3 ff ff       	call   c0100cd7 <__panic>
    assert(alloc_page() == NULL);
c01038d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01038df:	e8 3d 04 00 00       	call   c0103d21 <alloc_pages>
c01038e4:	85 c0                	test   %eax,%eax
c01038e6:	74 24                	je     c010390c <default_check+0x564>
c01038e8:	c7 44 24 0c b6 66 10 	movl   $0xc01066b6,0xc(%esp)
c01038ef:	c0 
c01038f0:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c01038f7:	c0 
c01038f8:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
c01038ff:	00 
c0103900:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0103907:	e8 cb d3 ff ff       	call   c0100cd7 <__panic>

    assert(nr_free == 0);
c010390c:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103911:	85 c0                	test   %eax,%eax
c0103913:	74 24                	je     c0103939 <default_check+0x591>
c0103915:	c7 44 24 0c 09 67 10 	movl   $0xc0106709,0xc(%esp)
c010391c:	c0 
c010391d:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c0103924:	c0 
c0103925:	c7 44 24 04 41 01 00 	movl   $0x141,0x4(%esp)
c010392c:	00 
c010392d:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c0103934:	e8 9e d3 ff ff       	call   c0100cd7 <__panic>
    nr_free = nr_free_store;
c0103939:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010393c:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    free_list = free_list_store;
c0103941:	8b 45 80             	mov    -0x80(%ebp),%eax
c0103944:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103947:	a3 50 89 11 c0       	mov    %eax,0xc0118950
c010394c:	89 15 54 89 11 c0    	mov    %edx,0xc0118954
    free_pages(p0, 5);
c0103952:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0103959:	00 
c010395a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010395d:	89 04 24             	mov    %eax,(%esp)
c0103960:	e8 f4 03 00 00       	call   c0103d59 <free_pages>

    le = &free_list;
c0103965:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010396c:	eb 1d                	jmp    c010398b <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c010396e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103971:	83 e8 0c             	sub    $0xc,%eax
c0103974:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0103977:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010397b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010397e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103981:	8b 40 08             	mov    0x8(%eax),%eax
c0103984:	29 c2                	sub    %eax,%edx
c0103986:	89 d0                	mov    %edx,%eax
c0103988:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010398b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010398e:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103991:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103994:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103997:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010399a:	81 7d ec 50 89 11 c0 	cmpl   $0xc0118950,-0x14(%ebp)
c01039a1:	75 cb                	jne    c010396e <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c01039a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01039a7:	74 24                	je     c01039cd <default_check+0x625>
c01039a9:	c7 44 24 0c 76 68 10 	movl   $0xc0106876,0xc(%esp)
c01039b0:	c0 
c01039b1:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c01039b8:	c0 
c01039b9:	c7 44 24 04 4c 01 00 	movl   $0x14c,0x4(%esp)
c01039c0:	00 
c01039c1:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c01039c8:	e8 0a d3 ff ff       	call   c0100cd7 <__panic>
    assert(total == 0);
c01039cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01039d1:	74 24                	je     c01039f7 <default_check+0x64f>
c01039d3:	c7 44 24 0c 81 68 10 	movl   $0xc0106881,0xc(%esp)
c01039da:	c0 
c01039db:	c7 44 24 08 56 65 10 	movl   $0xc0106556,0x8(%esp)
c01039e2:	c0 
c01039e3:	c7 44 24 04 4d 01 00 	movl   $0x14d,0x4(%esp)
c01039ea:	00 
c01039eb:	c7 04 24 6b 65 10 c0 	movl   $0xc010656b,(%esp)
c01039f2:	e8 e0 d2 ff ff       	call   c0100cd7 <__panic>
}
c01039f7:	81 c4 94 00 00 00    	add    $0x94,%esp
c01039fd:	5b                   	pop    %ebx
c01039fe:	5d                   	pop    %ebp
c01039ff:	c3                   	ret    

c0103a00 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103a00:	55                   	push   %ebp
c0103a01:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103a03:	8b 55 08             	mov    0x8(%ebp),%edx
c0103a06:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0103a0b:	29 c2                	sub    %eax,%edx
c0103a0d:	89 d0                	mov    %edx,%eax
c0103a0f:	c1 f8 02             	sar    $0x2,%eax
c0103a12:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103a18:	5d                   	pop    %ebp
c0103a19:	c3                   	ret    

c0103a1a <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103a1a:	55                   	push   %ebp
c0103a1b:	89 e5                	mov    %esp,%ebp
c0103a1d:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103a20:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a23:	89 04 24             	mov    %eax,(%esp)
c0103a26:	e8 d5 ff ff ff       	call   c0103a00 <page2ppn>
c0103a2b:	c1 e0 0c             	shl    $0xc,%eax
}
c0103a2e:	c9                   	leave  
c0103a2f:	c3                   	ret    

c0103a30 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0103a30:	55                   	push   %ebp
c0103a31:	89 e5                	mov    %esp,%ebp
c0103a33:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103a36:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a39:	c1 e8 0c             	shr    $0xc,%eax
c0103a3c:	89 c2                	mov    %eax,%edx
c0103a3e:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103a43:	39 c2                	cmp    %eax,%edx
c0103a45:	72 1c                	jb     c0103a63 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103a47:	c7 44 24 08 bc 68 10 	movl   $0xc01068bc,0x8(%esp)
c0103a4e:	c0 
c0103a4f:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0103a56:	00 
c0103a57:	c7 04 24 db 68 10 c0 	movl   $0xc01068db,(%esp)
c0103a5e:	e8 74 d2 ff ff       	call   c0100cd7 <__panic>
    }
    return &pages[PPN(pa)];
c0103a63:	8b 0d 64 89 11 c0    	mov    0xc0118964,%ecx
c0103a69:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a6c:	c1 e8 0c             	shr    $0xc,%eax
c0103a6f:	89 c2                	mov    %eax,%edx
c0103a71:	89 d0                	mov    %edx,%eax
c0103a73:	c1 e0 02             	shl    $0x2,%eax
c0103a76:	01 d0                	add    %edx,%eax
c0103a78:	c1 e0 02             	shl    $0x2,%eax
c0103a7b:	01 c8                	add    %ecx,%eax
}
c0103a7d:	c9                   	leave  
c0103a7e:	c3                   	ret    

c0103a7f <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0103a7f:	55                   	push   %ebp
c0103a80:	89 e5                	mov    %esp,%ebp
c0103a82:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103a85:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a88:	89 04 24             	mov    %eax,(%esp)
c0103a8b:	e8 8a ff ff ff       	call   c0103a1a <page2pa>
c0103a90:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a96:	c1 e8 0c             	shr    $0xc,%eax
c0103a99:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a9c:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103aa1:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103aa4:	72 23                	jb     c0103ac9 <page2kva+0x4a>
c0103aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103aa9:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103aad:	c7 44 24 08 ec 68 10 	movl   $0xc01068ec,0x8(%esp)
c0103ab4:	c0 
c0103ab5:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103abc:	00 
c0103abd:	c7 04 24 db 68 10 c0 	movl   $0xc01068db,(%esp)
c0103ac4:	e8 0e d2 ff ff       	call   c0100cd7 <__panic>
c0103ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103acc:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103ad1:	c9                   	leave  
c0103ad2:	c3                   	ret    

c0103ad3 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0103ad3:	55                   	push   %ebp
c0103ad4:	89 e5                	mov    %esp,%ebp
c0103ad6:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103ad9:	8b 45 08             	mov    0x8(%ebp),%eax
c0103adc:	83 e0 01             	and    $0x1,%eax
c0103adf:	85 c0                	test   %eax,%eax
c0103ae1:	75 1c                	jne    c0103aff <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103ae3:	c7 44 24 08 10 69 10 	movl   $0xc0106910,0x8(%esp)
c0103aea:	c0 
c0103aeb:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103af2:	00 
c0103af3:	c7 04 24 db 68 10 c0 	movl   $0xc01068db,(%esp)
c0103afa:	e8 d8 d1 ff ff       	call   c0100cd7 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0103aff:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b02:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103b07:	89 04 24             	mov    %eax,(%esp)
c0103b0a:	e8 21 ff ff ff       	call   c0103a30 <pa2page>
}
c0103b0f:	c9                   	leave  
c0103b10:	c3                   	ret    

c0103b11 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0103b11:	55                   	push   %ebp
c0103b12:	89 e5                	mov    %esp,%ebp
c0103b14:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0103b17:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b1a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103b1f:	89 04 24             	mov    %eax,(%esp)
c0103b22:	e8 09 ff ff ff       	call   c0103a30 <pa2page>
}
c0103b27:	c9                   	leave  
c0103b28:	c3                   	ret    

c0103b29 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0103b29:	55                   	push   %ebp
c0103b2a:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103b2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b2f:	8b 00                	mov    (%eax),%eax
}
c0103b31:	5d                   	pop    %ebp
c0103b32:	c3                   	ret    

c0103b33 <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
c0103b33:	55                   	push   %ebp
c0103b34:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103b36:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b39:	8b 00                	mov    (%eax),%eax
c0103b3b:	8d 50 01             	lea    0x1(%eax),%edx
c0103b3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b41:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103b43:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b46:	8b 00                	mov    (%eax),%eax
}
c0103b48:	5d                   	pop    %ebp
c0103b49:	c3                   	ret    

c0103b4a <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103b4a:	55                   	push   %ebp
c0103b4b:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103b4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b50:	8b 00                	mov    (%eax),%eax
c0103b52:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103b55:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b58:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103b5a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b5d:	8b 00                	mov    (%eax),%eax
}
c0103b5f:	5d                   	pop    %ebp
c0103b60:	c3                   	ret    

c0103b61 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0103b61:	55                   	push   %ebp
c0103b62:	89 e5                	mov    %esp,%ebp
c0103b64:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103b67:	9c                   	pushf  
c0103b68:	58                   	pop    %eax
c0103b69:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103b6f:	25 00 02 00 00       	and    $0x200,%eax
c0103b74:	85 c0                	test   %eax,%eax
c0103b76:	74 0c                	je     c0103b84 <__intr_save+0x23>
        intr_disable();
c0103b78:	e8 3d db ff ff       	call   c01016ba <intr_disable>
        return 1;
c0103b7d:	b8 01 00 00 00       	mov    $0x1,%eax
c0103b82:	eb 05                	jmp    c0103b89 <__intr_save+0x28>
    }
    return 0;
c0103b84:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103b89:	c9                   	leave  
c0103b8a:	c3                   	ret    

c0103b8b <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0103b8b:	55                   	push   %ebp
c0103b8c:	89 e5                	mov    %esp,%ebp
c0103b8e:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103b91:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103b95:	74 05                	je     c0103b9c <__intr_restore+0x11>
        intr_enable();
c0103b97:	e8 18 db ff ff       	call   c01016b4 <intr_enable>
    }
}
c0103b9c:	c9                   	leave  
c0103b9d:	c3                   	ret    

c0103b9e <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103b9e:	55                   	push   %ebp
c0103b9f:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103ba1:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ba4:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103ba7:	b8 23 00 00 00       	mov    $0x23,%eax
c0103bac:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103bae:	b8 23 00 00 00       	mov    $0x23,%eax
c0103bb3:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103bb5:	b8 10 00 00 00       	mov    $0x10,%eax
c0103bba:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103bbc:	b8 10 00 00 00       	mov    $0x10,%eax
c0103bc1:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103bc3:	b8 10 00 00 00       	mov    $0x10,%eax
c0103bc8:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103bca:	ea d1 3b 10 c0 08 00 	ljmp   $0x8,$0xc0103bd1
}
c0103bd1:	5d                   	pop    %ebp
c0103bd2:	c3                   	ret    

c0103bd3 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103bd3:	55                   	push   %ebp
c0103bd4:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103bd6:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bd9:	a3 e4 88 11 c0       	mov    %eax,0xc01188e4
}
c0103bde:	5d                   	pop    %ebp
c0103bdf:	c3                   	ret    

c0103be0 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103be0:	55                   	push   %ebp
c0103be1:	89 e5                	mov    %esp,%ebp
c0103be3:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103be6:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0103beb:	89 04 24             	mov    %eax,(%esp)
c0103bee:	e8 e0 ff ff ff       	call   c0103bd3 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103bf3:	66 c7 05 e8 88 11 c0 	movw   $0x10,0xc01188e8
c0103bfa:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103bfc:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0103c03:	68 00 
c0103c05:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103c0a:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0103c10:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103c15:	c1 e8 10             	shr    $0x10,%eax
c0103c18:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0103c1d:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c24:	83 e0 f0             	and    $0xfffffff0,%eax
c0103c27:	83 c8 09             	or     $0x9,%eax
c0103c2a:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c2f:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c36:	83 e0 ef             	and    $0xffffffef,%eax
c0103c39:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c3e:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c45:	83 e0 9f             	and    $0xffffff9f,%eax
c0103c48:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c4d:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c54:	83 c8 80             	or     $0xffffff80,%eax
c0103c57:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c5c:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c63:	83 e0 f0             	and    $0xfffffff0,%eax
c0103c66:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c6b:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c72:	83 e0 ef             	and    $0xffffffef,%eax
c0103c75:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c7a:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c81:	83 e0 df             	and    $0xffffffdf,%eax
c0103c84:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c89:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c90:	83 c8 40             	or     $0x40,%eax
c0103c93:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c98:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c9f:	83 e0 7f             	and    $0x7f,%eax
c0103ca2:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103ca7:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103cac:	c1 e8 18             	shr    $0x18,%eax
c0103caf:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103cb4:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c0103cbb:	e8 de fe ff ff       	call   c0103b9e <lgdt>
c0103cc0:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103cc6:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103cca:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103ccd:	c9                   	leave  
c0103cce:	c3                   	ret    

c0103ccf <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103ccf:	55                   	push   %ebp
c0103cd0:	89 e5                	mov    %esp,%ebp
c0103cd2:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103cd5:	c7 05 5c 89 11 c0 a0 	movl   $0xc01068a0,0xc011895c
c0103cdc:	68 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103cdf:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103ce4:	8b 00                	mov    (%eax),%eax
c0103ce6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103cea:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c0103cf1:	e8 46 c6 ff ff       	call   c010033c <cprintf>
    pmm_manager->init();
c0103cf6:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103cfb:	8b 40 04             	mov    0x4(%eax),%eax
c0103cfe:	ff d0                	call   *%eax
}
c0103d00:	c9                   	leave  
c0103d01:	c3                   	ret    

c0103d02 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103d02:	55                   	push   %ebp
c0103d03:	89 e5                	mov    %esp,%ebp
c0103d05:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103d08:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d0d:	8b 40 08             	mov    0x8(%eax),%eax
c0103d10:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103d13:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103d17:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d1a:	89 14 24             	mov    %edx,(%esp)
c0103d1d:	ff d0                	call   *%eax
}
c0103d1f:	c9                   	leave  
c0103d20:	c3                   	ret    

c0103d21 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103d21:	55                   	push   %ebp
c0103d22:	89 e5                	mov    %esp,%ebp
c0103d24:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103d27:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103d2e:	e8 2e fe ff ff       	call   c0103b61 <__intr_save>
c0103d33:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103d36:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d3b:	8b 40 0c             	mov    0xc(%eax),%eax
c0103d3e:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d41:	89 14 24             	mov    %edx,(%esp)
c0103d44:	ff d0                	call   *%eax
c0103d46:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103d49:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d4c:	89 04 24             	mov    %eax,(%esp)
c0103d4f:	e8 37 fe ff ff       	call   c0103b8b <__intr_restore>
    return page;
c0103d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103d57:	c9                   	leave  
c0103d58:	c3                   	ret    

c0103d59 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103d59:	55                   	push   %ebp
c0103d5a:	89 e5                	mov    %esp,%ebp
c0103d5c:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103d5f:	e8 fd fd ff ff       	call   c0103b61 <__intr_save>
c0103d64:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103d67:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d6c:	8b 40 10             	mov    0x10(%eax),%eax
c0103d6f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103d72:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103d76:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d79:	89 14 24             	mov    %edx,(%esp)
c0103d7c:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d81:	89 04 24             	mov    %eax,(%esp)
c0103d84:	e8 02 fe ff ff       	call   c0103b8b <__intr_restore>
}
c0103d89:	c9                   	leave  
c0103d8a:	c3                   	ret    

c0103d8b <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103d8b:	55                   	push   %ebp
c0103d8c:	89 e5                	mov    %esp,%ebp
c0103d8e:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103d91:	e8 cb fd ff ff       	call   c0103b61 <__intr_save>
c0103d96:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103d99:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d9e:	8b 40 14             	mov    0x14(%eax),%eax
c0103da1:	ff d0                	call   *%eax
c0103da3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103da9:	89 04 24             	mov    %eax,(%esp)
c0103dac:	e8 da fd ff ff       	call   c0103b8b <__intr_restore>
    return ret;
c0103db1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103db4:	c9                   	leave  
c0103db5:	c3                   	ret    

c0103db6 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103db6:	55                   	push   %ebp
c0103db7:	89 e5                	mov    %esp,%ebp
c0103db9:	57                   	push   %edi
c0103dba:	56                   	push   %esi
c0103dbb:	53                   	push   %ebx
c0103dbc:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103dc2:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103dc9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103dd0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103dd7:	c7 04 24 53 69 10 c0 	movl   $0xc0106953,(%esp)
c0103dde:	e8 59 c5 ff ff       	call   c010033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103de3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103dea:	e9 15 01 00 00       	jmp    c0103f04 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103def:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103df2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103df5:	89 d0                	mov    %edx,%eax
c0103df7:	c1 e0 02             	shl    $0x2,%eax
c0103dfa:	01 d0                	add    %edx,%eax
c0103dfc:	c1 e0 02             	shl    $0x2,%eax
c0103dff:	01 c8                	add    %ecx,%eax
c0103e01:	8b 50 08             	mov    0x8(%eax),%edx
c0103e04:	8b 40 04             	mov    0x4(%eax),%eax
c0103e07:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103e0a:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103e0d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e10:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e13:	89 d0                	mov    %edx,%eax
c0103e15:	c1 e0 02             	shl    $0x2,%eax
c0103e18:	01 d0                	add    %edx,%eax
c0103e1a:	c1 e0 02             	shl    $0x2,%eax
c0103e1d:	01 c8                	add    %ecx,%eax
c0103e1f:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103e22:	8b 58 10             	mov    0x10(%eax),%ebx
c0103e25:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103e28:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103e2b:	01 c8                	add    %ecx,%eax
c0103e2d:	11 da                	adc    %ebx,%edx
c0103e2f:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103e32:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103e35:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e38:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e3b:	89 d0                	mov    %edx,%eax
c0103e3d:	c1 e0 02             	shl    $0x2,%eax
c0103e40:	01 d0                	add    %edx,%eax
c0103e42:	c1 e0 02             	shl    $0x2,%eax
c0103e45:	01 c8                	add    %ecx,%eax
c0103e47:	83 c0 14             	add    $0x14,%eax
c0103e4a:	8b 00                	mov    (%eax),%eax
c0103e4c:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0103e52:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103e55:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103e58:	83 c0 ff             	add    $0xffffffff,%eax
c0103e5b:	83 d2 ff             	adc    $0xffffffff,%edx
c0103e5e:	89 c6                	mov    %eax,%esi
c0103e60:	89 d7                	mov    %edx,%edi
c0103e62:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e65:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e68:	89 d0                	mov    %edx,%eax
c0103e6a:	c1 e0 02             	shl    $0x2,%eax
c0103e6d:	01 d0                	add    %edx,%eax
c0103e6f:	c1 e0 02             	shl    $0x2,%eax
c0103e72:	01 c8                	add    %ecx,%eax
c0103e74:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103e77:	8b 58 10             	mov    0x10(%eax),%ebx
c0103e7a:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0103e80:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0103e84:	89 74 24 14          	mov    %esi,0x14(%esp)
c0103e88:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0103e8c:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103e8f:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103e92:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103e96:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103e9a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103e9e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0103ea2:	c7 04 24 60 69 10 c0 	movl   $0xc0106960,(%esp)
c0103ea9:	e8 8e c4 ff ff       	call   c010033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103eae:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103eb1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103eb4:	89 d0                	mov    %edx,%eax
c0103eb6:	c1 e0 02             	shl    $0x2,%eax
c0103eb9:	01 d0                	add    %edx,%eax
c0103ebb:	c1 e0 02             	shl    $0x2,%eax
c0103ebe:	01 c8                	add    %ecx,%eax
c0103ec0:	83 c0 14             	add    $0x14,%eax
c0103ec3:	8b 00                	mov    (%eax),%eax
c0103ec5:	83 f8 01             	cmp    $0x1,%eax
c0103ec8:	75 36                	jne    c0103f00 <page_init+0x14a>
			// ARM: not reserved
            if (maxpa < end && begin < KMEMSIZE) {
c0103eca:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103ecd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103ed0:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103ed3:	77 2b                	ja     c0103f00 <page_init+0x14a>
c0103ed5:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103ed8:	72 05                	jb     c0103edf <page_init+0x129>
c0103eda:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0103edd:	73 21                	jae    c0103f00 <page_init+0x14a>
c0103edf:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103ee3:	77 1b                	ja     c0103f00 <page_init+0x14a>
c0103ee5:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103ee9:	72 09                	jb     c0103ef4 <page_init+0x13e>
c0103eeb:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0103ef2:	77 0c                	ja     c0103f00 <page_init+0x14a>
                maxpa = end;
c0103ef4:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103ef7:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103efa:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103efd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103f00:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103f04:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103f07:	8b 00                	mov    (%eax),%eax
c0103f09:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103f0c:	0f 8f dd fe ff ff    	jg     c0103def <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0103f12:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103f16:	72 1d                	jb     c0103f35 <page_init+0x17f>
c0103f18:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103f1c:	77 09                	ja     c0103f27 <page_init+0x171>
c0103f1e:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0103f25:	76 0e                	jbe    c0103f35 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0103f27:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0103f2e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];   // 此end为kernel的结尾，也正是可分配的内存页的开始
	// 按照看到的最大物理地址，计算出页数
    npage = maxpa / PGSIZE;
c0103f35:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103f38:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103f3b:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103f3f:	c1 ea 0c             	shr    $0xc,%edx
c0103f42:	a3 c0 88 11 c0       	mov    %eax,0xc01188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0103f47:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0103f4e:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c0103f53:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103f56:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103f59:	01 d0                	add    %edx,%eax
c0103f5b:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103f5e:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103f61:	ba 00 00 00 00       	mov    $0x0,%edx
c0103f66:	f7 75 ac             	divl   -0x54(%ebp)
c0103f69:	89 d0                	mov    %edx,%eax
c0103f6b:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0103f6e:	29 c2                	sub    %eax,%edx
c0103f70:	89 d0                	mov    %edx,%eax
c0103f72:	a3 64 89 11 c0       	mov    %eax,0xc0118964
	// cprintf("maxpa: %08llx, end: %08llx, npage: %08llx, pages: %08llx \n",
	//		maxpa, (uint64_t)&end, (uint64_t)npage, (uint64_t)pages);
	// 这里的end地址是带0xC偏移的，因为现在的ucore正运行在段机制下
	
	// 先把所有页设置为reserved，后面再说（init memmap的时候会assert这一点）
    for (i = 0; i < npage; i ++) {
c0103f77:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103f7e:	eb 2f                	jmp    c0103faf <page_init+0x1f9>
        SetPageReserved(pages + i);
c0103f80:	8b 0d 64 89 11 c0    	mov    0xc0118964,%ecx
c0103f86:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f89:	89 d0                	mov    %edx,%eax
c0103f8b:	c1 e0 02             	shl    $0x2,%eax
c0103f8e:	01 d0                	add    %edx,%eax
c0103f90:	c1 e0 02             	shl    $0x2,%eax
c0103f93:	01 c8                	add    %ecx,%eax
c0103f95:	83 c0 04             	add    $0x4,%eax
c0103f98:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0103f9f:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103fa2:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103fa5:	8b 55 90             	mov    -0x70(%ebp),%edx
c0103fa8:	0f ab 10             	bts    %edx,(%eax)
	// cprintf("maxpa: %08llx, end: %08llx, npage: %08llx, pages: %08llx \n",
	//		maxpa, (uint64_t)&end, (uint64_t)npage, (uint64_t)pages);
	// 这里的end地址是带0xC偏移的，因为现在的ucore正运行在段机制下
	
	// 先把所有页设置为reserved，后面再说（init memmap的时候会assert这一点）
    for (i = 0; i < npage; i ++) {
c0103fab:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103faf:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103fb2:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103fb7:	39 c2                	cmp    %eax,%edx
c0103fb9:	72 c5                	jb     c0103f80 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);  // pages的结尾地址,转换成了物理地址(-0xC0000000)
c0103fbb:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0103fc1:	89 d0                	mov    %edx,%eax
c0103fc3:	c1 e0 02             	shl    $0x2,%eax
c0103fc6:	01 d0                	add    %edx,%eax
c0103fc8:	c1 e0 02             	shl    $0x2,%eax
c0103fcb:	89 c2                	mov    %eax,%edx
c0103fcd:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0103fd2:	01 d0                	add    %edx,%eax
c0103fd4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0103fd7:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0103fde:	77 23                	ja     c0104003 <page_init+0x24d>
c0103fe0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103fe3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103fe7:	c7 44 24 08 90 69 10 	movl   $0xc0106990,0x8(%esp)
c0103fee:	c0 
c0103fef:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c0103ff6:	00 
c0103ff7:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0103ffe:	e8 d4 cc ff ff       	call   c0100cd7 <__panic>
c0104003:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104006:	05 00 00 00 40       	add    $0x40000000,%eax
c010400b:	89 45 a0             	mov    %eax,-0x60(%ebp)
	// 我们能分配的页地址在页表之后
    for (i = 0; i < memmap->nr_map; i ++) {
c010400e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104015:	e9 74 01 00 00       	jmp    c010418e <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010401a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010401d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104020:	89 d0                	mov    %edx,%eax
c0104022:	c1 e0 02             	shl    $0x2,%eax
c0104025:	01 d0                	add    %edx,%eax
c0104027:	c1 e0 02             	shl    $0x2,%eax
c010402a:	01 c8                	add    %ecx,%eax
c010402c:	8b 50 08             	mov    0x8(%eax),%edx
c010402f:	8b 40 04             	mov    0x4(%eax),%eax
c0104032:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104035:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104038:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010403b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010403e:	89 d0                	mov    %edx,%eax
c0104040:	c1 e0 02             	shl    $0x2,%eax
c0104043:	01 d0                	add    %edx,%eax
c0104045:	c1 e0 02             	shl    $0x2,%eax
c0104048:	01 c8                	add    %ecx,%eax
c010404a:	8b 48 0c             	mov    0xc(%eax),%ecx
c010404d:	8b 58 10             	mov    0x10(%eax),%ebx
c0104050:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104053:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104056:	01 c8                	add    %ecx,%eax
c0104058:	11 da                	adc    %ebx,%edx
c010405a:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010405d:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0104060:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104063:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104066:	89 d0                	mov    %edx,%eax
c0104068:	c1 e0 02             	shl    $0x2,%eax
c010406b:	01 d0                	add    %edx,%eax
c010406d:	c1 e0 02             	shl    $0x2,%eax
c0104070:	01 c8                	add    %ecx,%eax
c0104072:	83 c0 14             	add    $0x14,%eax
c0104075:	8b 00                	mov    (%eax),%eax
c0104077:	83 f8 01             	cmp    $0x1,%eax
c010407a:	0f 85 0a 01 00 00    	jne    c010418a <page_init+0x3d4>
            if (begin < freemem) {
c0104080:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104083:	ba 00 00 00 00       	mov    $0x0,%edx
c0104088:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010408b:	72 17                	jb     c01040a4 <page_init+0x2ee>
c010408d:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104090:	77 05                	ja     c0104097 <page_init+0x2e1>
c0104092:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0104095:	76 0d                	jbe    c01040a4 <page_init+0x2ee>
                begin = freemem;
c0104097:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010409a:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010409d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
				// cprintf("begin: %08llx, freemem: %08llx \n", begin, (uint64_t)freemem);
            }
            if (end > KMEMSIZE) {
c01040a4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01040a8:	72 1d                	jb     c01040c7 <page_init+0x311>
c01040aa:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01040ae:	77 09                	ja     c01040b9 <page_init+0x303>
c01040b0:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c01040b7:	76 0e                	jbe    c01040c7 <page_init+0x311>
                end = KMEMSIZE;
c01040b9:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c01040c0:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c01040c7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01040ca:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01040cd:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01040d0:	0f 87 b4 00 00 00    	ja     c010418a <page_init+0x3d4>
c01040d6:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01040d9:	72 09                	jb     c01040e4 <page_init+0x32e>
c01040db:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01040de:	0f 83 a6 00 00 00    	jae    c010418a <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c01040e4:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c01040eb:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01040ee:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01040f1:	01 d0                	add    %edx,%eax
c01040f3:	83 e8 01             	sub    $0x1,%eax
c01040f6:	89 45 98             	mov    %eax,-0x68(%ebp)
c01040f9:	8b 45 98             	mov    -0x68(%ebp),%eax
c01040fc:	ba 00 00 00 00       	mov    $0x0,%edx
c0104101:	f7 75 9c             	divl   -0x64(%ebp)
c0104104:	89 d0                	mov    %edx,%eax
c0104106:	8b 55 98             	mov    -0x68(%ebp),%edx
c0104109:	29 c2                	sub    %eax,%edx
c010410b:	89 d0                	mov    %edx,%eax
c010410d:	ba 00 00 00 00       	mov    $0x0,%edx
c0104112:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104115:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0104118:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010411b:	89 45 94             	mov    %eax,-0x6c(%ebp)
c010411e:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104121:	ba 00 00 00 00       	mov    $0x0,%edx
c0104126:	89 c7                	mov    %eax,%edi
c0104128:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c010412e:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0104131:	89 d0                	mov    %edx,%eax
c0104133:	83 e0 00             	and    $0x0,%eax
c0104136:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104139:	8b 45 80             	mov    -0x80(%ebp),%eax
c010413c:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010413f:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104142:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0104145:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104148:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010414b:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010414e:	77 3a                	ja     c010418a <page_init+0x3d4>
c0104150:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104153:	72 05                	jb     c010415a <page_init+0x3a4>
c0104155:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104158:	73 30                	jae    c010418a <page_init+0x3d4>
					// 传入的第一个参数是pages数组中的对应项
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c010415a:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c010415d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c0104160:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104163:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104166:	29 c8                	sub    %ecx,%eax
c0104168:	19 da                	sbb    %ebx,%edx
c010416a:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010416e:	c1 ea 0c             	shr    $0xc,%edx
c0104171:	89 c3                	mov    %eax,%ebx
c0104173:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104176:	89 04 24             	mov    %eax,(%esp)
c0104179:	e8 b2 f8 ff ff       	call   c0103a30 <pa2page>
c010417e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104182:	89 04 24             	mov    %eax,(%esp)
c0104185:	e8 78 fb ff ff       	call   c0103d02 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);  // pages的结尾地址,转换成了物理地址(-0xC0000000)
	// 我们能分配的页地址在页表之后
    for (i = 0; i < memmap->nr_map; i ++) {
c010418a:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010418e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104191:	8b 00                	mov    (%eax),%eax
c0104193:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104196:	0f 8f 7e fe ff ff    	jg     c010401a <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c010419c:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c01041a2:	5b                   	pop    %ebx
c01041a3:	5e                   	pop    %esi
c01041a4:	5f                   	pop    %edi
c01041a5:	5d                   	pop    %ebp
c01041a6:	c3                   	ret    

c01041a7 <enable_paging>:

static void
enable_paging(void) {
c01041a7:	55                   	push   %ebp
c01041a8:	89 e5                	mov    %esp,%ebp
c01041aa:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c01041ad:	a1 60 89 11 c0       	mov    0xc0118960,%eax
c01041b2:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c01041b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01041b8:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c01041bb:	0f 20 c0             	mov    %cr0,%eax
c01041be:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c01041c1:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c01041c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c01041c7:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c01041ce:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c01041d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01041d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c01041d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01041db:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c01041de:	c9                   	leave  
c01041df:	c3                   	ret    

c01041e0 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c01041e0:	55                   	push   %ebp
c01041e1:	89 e5                	mov    %esp,%ebp
c01041e3:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c01041e6:	8b 45 14             	mov    0x14(%ebp),%eax
c01041e9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01041ec:	31 d0                	xor    %edx,%eax
c01041ee:	25 ff 0f 00 00       	and    $0xfff,%eax
c01041f3:	85 c0                	test   %eax,%eax
c01041f5:	74 24                	je     c010421b <boot_map_segment+0x3b>
c01041f7:	c7 44 24 0c c2 69 10 	movl   $0xc01069c2,0xc(%esp)
c01041fe:	c0 
c01041ff:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104206:	c0 
c0104207:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c010420e:	00 
c010420f:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104216:	e8 bc ca ff ff       	call   c0100cd7 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c010421b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0104222:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104225:	25 ff 0f 00 00       	and    $0xfff,%eax
c010422a:	89 c2                	mov    %eax,%edx
c010422c:	8b 45 10             	mov    0x10(%ebp),%eax
c010422f:	01 c2                	add    %eax,%edx
c0104231:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104234:	01 d0                	add    %edx,%eax
c0104236:	83 e8 01             	sub    $0x1,%eax
c0104239:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010423c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010423f:	ba 00 00 00 00       	mov    $0x0,%edx
c0104244:	f7 75 f0             	divl   -0x10(%ebp)
c0104247:	89 d0                	mov    %edx,%eax
c0104249:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010424c:	29 c2                	sub    %eax,%edx
c010424e:	89 d0                	mov    %edx,%eax
c0104250:	c1 e8 0c             	shr    $0xc,%eax
c0104253:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104256:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104259:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010425c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010425f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104264:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104267:	8b 45 14             	mov    0x14(%ebp),%eax
c010426a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010426d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104270:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104275:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104278:	eb 6b                	jmp    c01042e5 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c010427a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104281:	00 
c0104282:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104285:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104289:	8b 45 08             	mov    0x8(%ebp),%eax
c010428c:	89 04 24             	mov    %eax,(%esp)
c010428f:	e8 cc 01 00 00       	call   c0104460 <get_pte>
c0104294:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104297:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010429b:	75 24                	jne    c01042c1 <boot_map_segment+0xe1>
c010429d:	c7 44 24 0c ee 69 10 	movl   $0xc01069ee,0xc(%esp)
c01042a4:	c0 
c01042a5:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c01042ac:	c0 
c01042ad:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c01042b4:	00 
c01042b5:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c01042bc:	e8 16 ca ff ff       	call   c0100cd7 <__panic>
        *ptep = pa | PTE_P | perm;
c01042c1:	8b 45 18             	mov    0x18(%ebp),%eax
c01042c4:	8b 55 14             	mov    0x14(%ebp),%edx
c01042c7:	09 d0                	or     %edx,%eax
c01042c9:	83 c8 01             	or     $0x1,%eax
c01042cc:	89 c2                	mov    %eax,%edx
c01042ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01042d1:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01042d3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01042d7:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01042de:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01042e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01042e9:	75 8f                	jne    c010427a <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c01042eb:	c9                   	leave  
c01042ec:	c3                   	ret    

c01042ed <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01042ed:	55                   	push   %ebp
c01042ee:	89 e5                	mov    %esp,%ebp
c01042f0:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c01042f3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01042fa:	e8 22 fa ff ff       	call   c0103d21 <alloc_pages>
c01042ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0104302:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104306:	75 1c                	jne    c0104324 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0104308:	c7 44 24 08 fb 69 10 	movl   $0xc01069fb,0x8(%esp)
c010430f:	c0 
c0104310:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
c0104317:	00 
c0104318:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c010431f:	e8 b3 c9 ff ff       	call   c0100cd7 <__panic>
    }
    return page2kva(p);
c0104324:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104327:	89 04 24             	mov    %eax,(%esp)
c010432a:	e8 50 f7 ff ff       	call   c0103a7f <page2kva>
}
c010432f:	c9                   	leave  
c0104330:	c3                   	ret    

c0104331 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0104331:	55                   	push   %ebp
c0104332:	89 e5                	mov    %esp,%ebp
c0104334:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104337:	e8 93 f9 ff ff       	call   c0103ccf <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010433c:	e8 75 fa ff ff       	call   c0103db6 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0104341:	e8 d7 02 00 00       	call   c010461d <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0104346:	e8 a2 ff ff ff       	call   c01042ed <boot_alloc_page>
c010434b:	a3 c4 88 11 c0       	mov    %eax,0xc01188c4
    memset(boot_pgdir, 0, PGSIZE);
c0104350:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104355:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010435c:	00 
c010435d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104364:	00 
c0104365:	89 04 24             	mov    %eax,(%esp)
c0104368:	e8 14 19 00 00       	call   c0105c81 <memset>
    boot_cr3 = PADDR(boot_pgdir);
c010436d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104372:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104375:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010437c:	77 23                	ja     c01043a1 <pmm_init+0x70>
c010437e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104381:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104385:	c7 44 24 08 90 69 10 	movl   $0xc0106990,0x8(%esp)
c010438c:	c0 
c010438d:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c0104394:	00 
c0104395:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c010439c:	e8 36 c9 ff ff       	call   c0100cd7 <__panic>
c01043a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043a4:	05 00 00 00 40       	add    $0x40000000,%eax
c01043a9:	a3 60 89 11 c0       	mov    %eax,0xc0118960

    check_pgdir();
c01043ae:	e8 88 02 00 00       	call   c010463b <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01043b3:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01043b8:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c01043be:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01043c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01043c6:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01043cd:	77 23                	ja     c01043f2 <pmm_init+0xc1>
c01043cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043d2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01043d6:	c7 44 24 08 90 69 10 	movl   $0xc0106990,0x8(%esp)
c01043dd:	c0 
c01043de:	c7 44 24 04 40 01 00 	movl   $0x140,0x4(%esp)
c01043e5:	00 
c01043e6:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c01043ed:	e8 e5 c8 ff ff       	call   c0100cd7 <__panic>
c01043f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043f5:	05 00 00 00 40       	add    $0x40000000,%eax
c01043fa:	83 c8 03             	or     $0x3,%eax
c01043fd:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01043ff:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104404:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c010440b:	00 
c010440c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104413:	00 
c0104414:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c010441b:	38 
c010441c:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0104423:	c0 
c0104424:	89 04 24             	mov    %eax,(%esp)
c0104427:	e8 b4 fd ff ff       	call   c01041e0 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c010442c:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104431:	8b 15 c4 88 11 c0    	mov    0xc01188c4,%edx
c0104437:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c010443d:	89 10                	mov    %edx,(%eax)

    enable_paging();
c010443f:	e8 63 fd ff ff       	call   c01041a7 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0104444:	e8 97 f7 ff ff       	call   c0103be0 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0104449:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010444e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0104454:	e8 7d 08 00 00       	call   c0104cd6 <check_boot_pgdir>

    print_pgdir();
c0104459:	e8 05 0d 00 00       	call   c0105163 <print_pgdir>

}
c010445e:	c9                   	leave  
c010445f:	c3                   	ret    

c0104460 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0104460:	55                   	push   %ebp
c0104461:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
c0104463:	5d                   	pop    %ebp
c0104464:	c3                   	ret    

c0104465 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0104465:	55                   	push   %ebp
c0104466:	89 e5                	mov    %esp,%ebp
c0104468:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010446b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104472:	00 
c0104473:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104476:	89 44 24 04          	mov    %eax,0x4(%esp)
c010447a:	8b 45 08             	mov    0x8(%ebp),%eax
c010447d:	89 04 24             	mov    %eax,(%esp)
c0104480:	e8 db ff ff ff       	call   c0104460 <get_pte>
c0104485:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0104488:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010448c:	74 08                	je     c0104496 <get_page+0x31>
        *ptep_store = ptep;
c010448e:	8b 45 10             	mov    0x10(%ebp),%eax
c0104491:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104494:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0104496:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010449a:	74 1b                	je     c01044b7 <get_page+0x52>
c010449c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010449f:	8b 00                	mov    (%eax),%eax
c01044a1:	83 e0 01             	and    $0x1,%eax
c01044a4:	85 c0                	test   %eax,%eax
c01044a6:	74 0f                	je     c01044b7 <get_page+0x52>
        return pte2page(*ptep);
c01044a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044ab:	8b 00                	mov    (%eax),%eax
c01044ad:	89 04 24             	mov    %eax,(%esp)
c01044b0:	e8 1e f6 ff ff       	call   c0103ad3 <pte2page>
c01044b5:	eb 05                	jmp    c01044bc <get_page+0x57>
    }
    return NULL;
c01044b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01044bc:	c9                   	leave  
c01044bd:	c3                   	ret    

c01044be <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01044be:	55                   	push   %ebp
c01044bf:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
c01044c1:	5d                   	pop    %ebp
c01044c2:	c3                   	ret    

c01044c3 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01044c3:	55                   	push   %ebp
c01044c4:	89 e5                	mov    %esp,%ebp
c01044c6:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01044c9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01044d0:	00 
c01044d1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044d4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01044d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01044db:	89 04 24             	mov    %eax,(%esp)
c01044de:	e8 7d ff ff ff       	call   c0104460 <get_pte>
c01044e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
c01044e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01044ea:	74 19                	je     c0104505 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c01044ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01044ef:	89 44 24 08          	mov    %eax,0x8(%esp)
c01044f3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01044fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01044fd:	89 04 24             	mov    %eax,(%esp)
c0104500:	e8 b9 ff ff ff       	call   c01044be <page_remove_pte>
    }
}
c0104505:	c9                   	leave  
c0104506:	c3                   	ret    

c0104507 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0104507:	55                   	push   %ebp
c0104508:	89 e5                	mov    %esp,%ebp
c010450a:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c010450d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104514:	00 
c0104515:	8b 45 10             	mov    0x10(%ebp),%eax
c0104518:	89 44 24 04          	mov    %eax,0x4(%esp)
c010451c:	8b 45 08             	mov    0x8(%ebp),%eax
c010451f:	89 04 24             	mov    %eax,(%esp)
c0104522:	e8 39 ff ff ff       	call   c0104460 <get_pte>
c0104527:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c010452a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010452e:	75 0a                	jne    c010453a <page_insert+0x33>
        return -E_NO_MEM;
c0104530:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0104535:	e9 84 00 00 00       	jmp    c01045be <page_insert+0xb7>
    }
    page_ref_inc(page);
c010453a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010453d:	89 04 24             	mov    %eax,(%esp)
c0104540:	e8 ee f5 ff ff       	call   c0103b33 <page_ref_inc>
    if (*ptep & PTE_P) {
c0104545:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104548:	8b 00                	mov    (%eax),%eax
c010454a:	83 e0 01             	and    $0x1,%eax
c010454d:	85 c0                	test   %eax,%eax
c010454f:	74 3e                	je     c010458f <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0104551:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104554:	8b 00                	mov    (%eax),%eax
c0104556:	89 04 24             	mov    %eax,(%esp)
c0104559:	e8 75 f5 ff ff       	call   c0103ad3 <pte2page>
c010455e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0104561:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104564:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104567:	75 0d                	jne    c0104576 <page_insert+0x6f>
            page_ref_dec(page);
c0104569:	8b 45 0c             	mov    0xc(%ebp),%eax
c010456c:	89 04 24             	mov    %eax,(%esp)
c010456f:	e8 d6 f5 ff ff       	call   c0103b4a <page_ref_dec>
c0104574:	eb 19                	jmp    c010458f <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0104576:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104579:	89 44 24 08          	mov    %eax,0x8(%esp)
c010457d:	8b 45 10             	mov    0x10(%ebp),%eax
c0104580:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104584:	8b 45 08             	mov    0x8(%ebp),%eax
c0104587:	89 04 24             	mov    %eax,(%esp)
c010458a:	e8 2f ff ff ff       	call   c01044be <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c010458f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104592:	89 04 24             	mov    %eax,(%esp)
c0104595:	e8 80 f4 ff ff       	call   c0103a1a <page2pa>
c010459a:	0b 45 14             	or     0x14(%ebp),%eax
c010459d:	83 c8 01             	or     $0x1,%eax
c01045a0:	89 c2                	mov    %eax,%edx
c01045a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045a5:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01045a7:	8b 45 10             	mov    0x10(%ebp),%eax
c01045aa:	89 44 24 04          	mov    %eax,0x4(%esp)
c01045ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01045b1:	89 04 24             	mov    %eax,(%esp)
c01045b4:	e8 07 00 00 00       	call   c01045c0 <tlb_invalidate>
    return 0;
c01045b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01045be:	c9                   	leave  
c01045bf:	c3                   	ret    

c01045c0 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01045c0:	55                   	push   %ebp
c01045c1:	89 e5                	mov    %esp,%ebp
c01045c3:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01045c6:	0f 20 d8             	mov    %cr3,%eax
c01045c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01045cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c01045cf:	89 c2                	mov    %eax,%edx
c01045d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01045d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01045d7:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01045de:	77 23                	ja     c0104603 <tlb_invalidate+0x43>
c01045e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01045e7:	c7 44 24 08 90 69 10 	movl   $0xc0106990,0x8(%esp)
c01045ee:	c0 
c01045ef:	c7 44 24 04 e0 01 00 	movl   $0x1e0,0x4(%esp)
c01045f6:	00 
c01045f7:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c01045fe:	e8 d4 c6 ff ff       	call   c0100cd7 <__panic>
c0104603:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104606:	05 00 00 00 40       	add    $0x40000000,%eax
c010460b:	39 c2                	cmp    %eax,%edx
c010460d:	75 0c                	jne    c010461b <tlb_invalidate+0x5b>
        invlpg((void *)la);
c010460f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104612:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0104615:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104618:	0f 01 38             	invlpg (%eax)
    }
}
c010461b:	c9                   	leave  
c010461c:	c3                   	ret    

c010461d <check_alloc_page>:

static void
check_alloc_page(void) {
c010461d:	55                   	push   %ebp
c010461e:	89 e5                	mov    %esp,%ebp
c0104620:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0104623:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0104628:	8b 40 18             	mov    0x18(%eax),%eax
c010462b:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c010462d:	c7 04 24 14 6a 10 c0 	movl   $0xc0106a14,(%esp)
c0104634:	e8 03 bd ff ff       	call   c010033c <cprintf>
}
c0104639:	c9                   	leave  
c010463a:	c3                   	ret    

c010463b <check_pgdir>:

static void
check_pgdir(void) {
c010463b:	55                   	push   %ebp
c010463c:	89 e5                	mov    %esp,%ebp
c010463e:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0104641:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104646:	3d 00 80 03 00       	cmp    $0x38000,%eax
c010464b:	76 24                	jbe    c0104671 <check_pgdir+0x36>
c010464d:	c7 44 24 0c 33 6a 10 	movl   $0xc0106a33,0xc(%esp)
c0104654:	c0 
c0104655:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c010465c:	c0 
c010465d:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
c0104664:	00 
c0104665:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c010466c:	e8 66 c6 ff ff       	call   c0100cd7 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0104671:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104676:	85 c0                	test   %eax,%eax
c0104678:	74 0e                	je     c0104688 <check_pgdir+0x4d>
c010467a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010467f:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104684:	85 c0                	test   %eax,%eax
c0104686:	74 24                	je     c01046ac <check_pgdir+0x71>
c0104688:	c7 44 24 0c 50 6a 10 	movl   $0xc0106a50,0xc(%esp)
c010468f:	c0 
c0104690:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104697:	c0 
c0104698:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
c010469f:	00 
c01046a0:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c01046a7:	e8 2b c6 ff ff       	call   c0100cd7 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01046ac:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01046b1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01046b8:	00 
c01046b9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01046c0:	00 
c01046c1:	89 04 24             	mov    %eax,(%esp)
c01046c4:	e8 9c fd ff ff       	call   c0104465 <get_page>
c01046c9:	85 c0                	test   %eax,%eax
c01046cb:	74 24                	je     c01046f1 <check_pgdir+0xb6>
c01046cd:	c7 44 24 0c 88 6a 10 	movl   $0xc0106a88,0xc(%esp)
c01046d4:	c0 
c01046d5:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c01046dc:	c0 
c01046dd:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
c01046e4:	00 
c01046e5:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c01046ec:	e8 e6 c5 ff ff       	call   c0100cd7 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01046f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01046f8:	e8 24 f6 ff ff       	call   c0103d21 <alloc_pages>
c01046fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0104700:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104705:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010470c:	00 
c010470d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104714:	00 
c0104715:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104718:	89 54 24 04          	mov    %edx,0x4(%esp)
c010471c:	89 04 24             	mov    %eax,(%esp)
c010471f:	e8 e3 fd ff ff       	call   c0104507 <page_insert>
c0104724:	85 c0                	test   %eax,%eax
c0104726:	74 24                	je     c010474c <check_pgdir+0x111>
c0104728:	c7 44 24 0c b0 6a 10 	movl   $0xc0106ab0,0xc(%esp)
c010472f:	c0 
c0104730:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104737:	c0 
c0104738:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
c010473f:	00 
c0104740:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104747:	e8 8b c5 ff ff       	call   c0100cd7 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c010474c:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104751:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104758:	00 
c0104759:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104760:	00 
c0104761:	89 04 24             	mov    %eax,(%esp)
c0104764:	e8 f7 fc ff ff       	call   c0104460 <get_pte>
c0104769:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010476c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104770:	75 24                	jne    c0104796 <check_pgdir+0x15b>
c0104772:	c7 44 24 0c dc 6a 10 	movl   $0xc0106adc,0xc(%esp)
c0104779:	c0 
c010477a:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104781:	c0 
c0104782:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
c0104789:	00 
c010478a:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104791:	e8 41 c5 ff ff       	call   c0100cd7 <__panic>
    assert(pte2page(*ptep) == p1);
c0104796:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104799:	8b 00                	mov    (%eax),%eax
c010479b:	89 04 24             	mov    %eax,(%esp)
c010479e:	e8 30 f3 ff ff       	call   c0103ad3 <pte2page>
c01047a3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01047a6:	74 24                	je     c01047cc <check_pgdir+0x191>
c01047a8:	c7 44 24 0c 09 6b 10 	movl   $0xc0106b09,0xc(%esp)
c01047af:	c0 
c01047b0:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c01047b7:	c0 
c01047b8:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c01047bf:	00 
c01047c0:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c01047c7:	e8 0b c5 ff ff       	call   c0100cd7 <__panic>
    assert(page_ref(p1) == 1);
c01047cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047cf:	89 04 24             	mov    %eax,(%esp)
c01047d2:	e8 52 f3 ff ff       	call   c0103b29 <page_ref>
c01047d7:	83 f8 01             	cmp    $0x1,%eax
c01047da:	74 24                	je     c0104800 <check_pgdir+0x1c5>
c01047dc:	c7 44 24 0c 1f 6b 10 	movl   $0xc0106b1f,0xc(%esp)
c01047e3:	c0 
c01047e4:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c01047eb:	c0 
c01047ec:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
c01047f3:	00 
c01047f4:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c01047fb:	e8 d7 c4 ff ff       	call   c0100cd7 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0104800:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104805:	8b 00                	mov    (%eax),%eax
c0104807:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010480c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010480f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104812:	c1 e8 0c             	shr    $0xc,%eax
c0104815:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104818:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c010481d:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104820:	72 23                	jb     c0104845 <check_pgdir+0x20a>
c0104822:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104825:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104829:	c7 44 24 08 ec 68 10 	movl   $0xc01068ec,0x8(%esp)
c0104830:	c0 
c0104831:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
c0104838:	00 
c0104839:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104840:	e8 92 c4 ff ff       	call   c0100cd7 <__panic>
c0104845:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104848:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010484d:	83 c0 04             	add    $0x4,%eax
c0104850:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0104853:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104858:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010485f:	00 
c0104860:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104867:	00 
c0104868:	89 04 24             	mov    %eax,(%esp)
c010486b:	e8 f0 fb ff ff       	call   c0104460 <get_pte>
c0104870:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104873:	74 24                	je     c0104899 <check_pgdir+0x25e>
c0104875:	c7 44 24 0c 34 6b 10 	movl   $0xc0106b34,0xc(%esp)
c010487c:	c0 
c010487d:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104884:	c0 
c0104885:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
c010488c:	00 
c010488d:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104894:	e8 3e c4 ff ff       	call   c0100cd7 <__panic>

    p2 = alloc_page();
c0104899:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01048a0:	e8 7c f4 ff ff       	call   c0103d21 <alloc_pages>
c01048a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c01048a8:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01048ad:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c01048b4:	00 
c01048b5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01048bc:	00 
c01048bd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01048c0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01048c4:	89 04 24             	mov    %eax,(%esp)
c01048c7:	e8 3b fc ff ff       	call   c0104507 <page_insert>
c01048cc:	85 c0                	test   %eax,%eax
c01048ce:	74 24                	je     c01048f4 <check_pgdir+0x2b9>
c01048d0:	c7 44 24 0c 5c 6b 10 	movl   $0xc0106b5c,0xc(%esp)
c01048d7:	c0 
c01048d8:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c01048df:	c0 
c01048e0:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
c01048e7:	00 
c01048e8:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c01048ef:	e8 e3 c3 ff ff       	call   c0100cd7 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01048f4:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01048f9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104900:	00 
c0104901:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104908:	00 
c0104909:	89 04 24             	mov    %eax,(%esp)
c010490c:	e8 4f fb ff ff       	call   c0104460 <get_pte>
c0104911:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104914:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104918:	75 24                	jne    c010493e <check_pgdir+0x303>
c010491a:	c7 44 24 0c 94 6b 10 	movl   $0xc0106b94,0xc(%esp)
c0104921:	c0 
c0104922:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104929:	c0 
c010492a:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c0104931:	00 
c0104932:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104939:	e8 99 c3 ff ff       	call   c0100cd7 <__panic>
    assert(*ptep & PTE_U);
c010493e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104941:	8b 00                	mov    (%eax),%eax
c0104943:	83 e0 04             	and    $0x4,%eax
c0104946:	85 c0                	test   %eax,%eax
c0104948:	75 24                	jne    c010496e <check_pgdir+0x333>
c010494a:	c7 44 24 0c c4 6b 10 	movl   $0xc0106bc4,0xc(%esp)
c0104951:	c0 
c0104952:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104959:	c0 
c010495a:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c0104961:	00 
c0104962:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104969:	e8 69 c3 ff ff       	call   c0100cd7 <__panic>
    assert(*ptep & PTE_W);
c010496e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104971:	8b 00                	mov    (%eax),%eax
c0104973:	83 e0 02             	and    $0x2,%eax
c0104976:	85 c0                	test   %eax,%eax
c0104978:	75 24                	jne    c010499e <check_pgdir+0x363>
c010497a:	c7 44 24 0c d2 6b 10 	movl   $0xc0106bd2,0xc(%esp)
c0104981:	c0 
c0104982:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104989:	c0 
c010498a:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
c0104991:	00 
c0104992:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104999:	e8 39 c3 ff ff       	call   c0100cd7 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c010499e:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01049a3:	8b 00                	mov    (%eax),%eax
c01049a5:	83 e0 04             	and    $0x4,%eax
c01049a8:	85 c0                	test   %eax,%eax
c01049aa:	75 24                	jne    c01049d0 <check_pgdir+0x395>
c01049ac:	c7 44 24 0c e0 6b 10 	movl   $0xc0106be0,0xc(%esp)
c01049b3:	c0 
c01049b4:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c01049bb:	c0 
c01049bc:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
c01049c3:	00 
c01049c4:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c01049cb:	e8 07 c3 ff ff       	call   c0100cd7 <__panic>
    assert(page_ref(p2) == 1);
c01049d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01049d3:	89 04 24             	mov    %eax,(%esp)
c01049d6:	e8 4e f1 ff ff       	call   c0103b29 <page_ref>
c01049db:	83 f8 01             	cmp    $0x1,%eax
c01049de:	74 24                	je     c0104a04 <check_pgdir+0x3c9>
c01049e0:	c7 44 24 0c f6 6b 10 	movl   $0xc0106bf6,0xc(%esp)
c01049e7:	c0 
c01049e8:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c01049ef:	c0 
c01049f0:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c01049f7:	00 
c01049f8:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c01049ff:	e8 d3 c2 ff ff       	call   c0100cd7 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104a04:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104a09:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104a10:	00 
c0104a11:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104a18:	00 
c0104a19:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104a1c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104a20:	89 04 24             	mov    %eax,(%esp)
c0104a23:	e8 df fa ff ff       	call   c0104507 <page_insert>
c0104a28:	85 c0                	test   %eax,%eax
c0104a2a:	74 24                	je     c0104a50 <check_pgdir+0x415>
c0104a2c:	c7 44 24 0c 08 6c 10 	movl   $0xc0106c08,0xc(%esp)
c0104a33:	c0 
c0104a34:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104a3b:	c0 
c0104a3c:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c0104a43:	00 
c0104a44:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104a4b:	e8 87 c2 ff ff       	call   c0100cd7 <__panic>
    assert(page_ref(p1) == 2);
c0104a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a53:	89 04 24             	mov    %eax,(%esp)
c0104a56:	e8 ce f0 ff ff       	call   c0103b29 <page_ref>
c0104a5b:	83 f8 02             	cmp    $0x2,%eax
c0104a5e:	74 24                	je     c0104a84 <check_pgdir+0x449>
c0104a60:	c7 44 24 0c 34 6c 10 	movl   $0xc0106c34,0xc(%esp)
c0104a67:	c0 
c0104a68:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104a6f:	c0 
c0104a70:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
c0104a77:	00 
c0104a78:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104a7f:	e8 53 c2 ff ff       	call   c0100cd7 <__panic>
    assert(page_ref(p2) == 0);
c0104a84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104a87:	89 04 24             	mov    %eax,(%esp)
c0104a8a:	e8 9a f0 ff ff       	call   c0103b29 <page_ref>
c0104a8f:	85 c0                	test   %eax,%eax
c0104a91:	74 24                	je     c0104ab7 <check_pgdir+0x47c>
c0104a93:	c7 44 24 0c 46 6c 10 	movl   $0xc0106c46,0xc(%esp)
c0104a9a:	c0 
c0104a9b:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104aa2:	c0 
c0104aa3:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0104aaa:	00 
c0104aab:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104ab2:	e8 20 c2 ff ff       	call   c0100cd7 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104ab7:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104abc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104ac3:	00 
c0104ac4:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104acb:	00 
c0104acc:	89 04 24             	mov    %eax,(%esp)
c0104acf:	e8 8c f9 ff ff       	call   c0104460 <get_pte>
c0104ad4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ad7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104adb:	75 24                	jne    c0104b01 <check_pgdir+0x4c6>
c0104add:	c7 44 24 0c 94 6b 10 	movl   $0xc0106b94,0xc(%esp)
c0104ae4:	c0 
c0104ae5:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104aec:	c0 
c0104aed:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
c0104af4:	00 
c0104af5:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104afc:	e8 d6 c1 ff ff       	call   c0100cd7 <__panic>
    assert(pte2page(*ptep) == p1);
c0104b01:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b04:	8b 00                	mov    (%eax),%eax
c0104b06:	89 04 24             	mov    %eax,(%esp)
c0104b09:	e8 c5 ef ff ff       	call   c0103ad3 <pte2page>
c0104b0e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104b11:	74 24                	je     c0104b37 <check_pgdir+0x4fc>
c0104b13:	c7 44 24 0c 09 6b 10 	movl   $0xc0106b09,0xc(%esp)
c0104b1a:	c0 
c0104b1b:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104b22:	c0 
c0104b23:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0104b2a:	00 
c0104b2b:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104b32:	e8 a0 c1 ff ff       	call   c0100cd7 <__panic>
    assert((*ptep & PTE_U) == 0);
c0104b37:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b3a:	8b 00                	mov    (%eax),%eax
c0104b3c:	83 e0 04             	and    $0x4,%eax
c0104b3f:	85 c0                	test   %eax,%eax
c0104b41:	74 24                	je     c0104b67 <check_pgdir+0x52c>
c0104b43:	c7 44 24 0c 58 6c 10 	movl   $0xc0106c58,0xc(%esp)
c0104b4a:	c0 
c0104b4b:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104b52:	c0 
c0104b53:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c0104b5a:	00 
c0104b5b:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104b62:	e8 70 c1 ff ff       	call   c0100cd7 <__panic>

    page_remove(boot_pgdir, 0x0);
c0104b67:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104b6c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104b73:	00 
c0104b74:	89 04 24             	mov    %eax,(%esp)
c0104b77:	e8 47 f9 ff ff       	call   c01044c3 <page_remove>
    assert(page_ref(p1) == 1);
c0104b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b7f:	89 04 24             	mov    %eax,(%esp)
c0104b82:	e8 a2 ef ff ff       	call   c0103b29 <page_ref>
c0104b87:	83 f8 01             	cmp    $0x1,%eax
c0104b8a:	74 24                	je     c0104bb0 <check_pgdir+0x575>
c0104b8c:	c7 44 24 0c 1f 6b 10 	movl   $0xc0106b1f,0xc(%esp)
c0104b93:	c0 
c0104b94:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104b9b:	c0 
c0104b9c:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0104ba3:	00 
c0104ba4:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104bab:	e8 27 c1 ff ff       	call   c0100cd7 <__panic>
    assert(page_ref(p2) == 0);
c0104bb0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104bb3:	89 04 24             	mov    %eax,(%esp)
c0104bb6:	e8 6e ef ff ff       	call   c0103b29 <page_ref>
c0104bbb:	85 c0                	test   %eax,%eax
c0104bbd:	74 24                	je     c0104be3 <check_pgdir+0x5a8>
c0104bbf:	c7 44 24 0c 46 6c 10 	movl   $0xc0106c46,0xc(%esp)
c0104bc6:	c0 
c0104bc7:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104bce:	c0 
c0104bcf:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0104bd6:	00 
c0104bd7:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104bde:	e8 f4 c0 ff ff       	call   c0100cd7 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104be3:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104be8:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104bef:	00 
c0104bf0:	89 04 24             	mov    %eax,(%esp)
c0104bf3:	e8 cb f8 ff ff       	call   c01044c3 <page_remove>
    assert(page_ref(p1) == 0);
c0104bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bfb:	89 04 24             	mov    %eax,(%esp)
c0104bfe:	e8 26 ef ff ff       	call   c0103b29 <page_ref>
c0104c03:	85 c0                	test   %eax,%eax
c0104c05:	74 24                	je     c0104c2b <check_pgdir+0x5f0>
c0104c07:	c7 44 24 0c 6d 6c 10 	movl   $0xc0106c6d,0xc(%esp)
c0104c0e:	c0 
c0104c0f:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104c16:	c0 
c0104c17:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c0104c1e:	00 
c0104c1f:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104c26:	e8 ac c0 ff ff       	call   c0100cd7 <__panic>
    assert(page_ref(p2) == 0);
c0104c2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c2e:	89 04 24             	mov    %eax,(%esp)
c0104c31:	e8 f3 ee ff ff       	call   c0103b29 <page_ref>
c0104c36:	85 c0                	test   %eax,%eax
c0104c38:	74 24                	je     c0104c5e <check_pgdir+0x623>
c0104c3a:	c7 44 24 0c 46 6c 10 	movl   $0xc0106c46,0xc(%esp)
c0104c41:	c0 
c0104c42:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104c49:	c0 
c0104c4a:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c0104c51:	00 
c0104c52:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104c59:	e8 79 c0 ff ff       	call   c0100cd7 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0104c5e:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104c63:	8b 00                	mov    (%eax),%eax
c0104c65:	89 04 24             	mov    %eax,(%esp)
c0104c68:	e8 a4 ee ff ff       	call   c0103b11 <pde2page>
c0104c6d:	89 04 24             	mov    %eax,(%esp)
c0104c70:	e8 b4 ee ff ff       	call   c0103b29 <page_ref>
c0104c75:	83 f8 01             	cmp    $0x1,%eax
c0104c78:	74 24                	je     c0104c9e <check_pgdir+0x663>
c0104c7a:	c7 44 24 0c 80 6c 10 	movl   $0xc0106c80,0xc(%esp)
c0104c81:	c0 
c0104c82:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104c89:	c0 
c0104c8a:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0104c91:	00 
c0104c92:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104c99:	e8 39 c0 ff ff       	call   c0100cd7 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0104c9e:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104ca3:	8b 00                	mov    (%eax),%eax
c0104ca5:	89 04 24             	mov    %eax,(%esp)
c0104ca8:	e8 64 ee ff ff       	call   c0103b11 <pde2page>
c0104cad:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104cb4:	00 
c0104cb5:	89 04 24             	mov    %eax,(%esp)
c0104cb8:	e8 9c f0 ff ff       	call   c0103d59 <free_pages>
    boot_pgdir[0] = 0;
c0104cbd:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104cc2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104cc8:	c7 04 24 a7 6c 10 c0 	movl   $0xc0106ca7,(%esp)
c0104ccf:	e8 68 b6 ff ff       	call   c010033c <cprintf>
}
c0104cd4:	c9                   	leave  
c0104cd5:	c3                   	ret    

c0104cd6 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104cd6:	55                   	push   %ebp
c0104cd7:	89 e5                	mov    %esp,%ebp
c0104cd9:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104cdc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104ce3:	e9 ca 00 00 00       	jmp    c0104db2 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ceb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104cee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cf1:	c1 e8 0c             	shr    $0xc,%eax
c0104cf4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104cf7:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104cfc:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104cff:	72 23                	jb     c0104d24 <check_boot_pgdir+0x4e>
c0104d01:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d04:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104d08:	c7 44 24 08 ec 68 10 	movl   $0xc01068ec,0x8(%esp)
c0104d0f:	c0 
c0104d10:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
c0104d17:	00 
c0104d18:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104d1f:	e8 b3 bf ff ff       	call   c0100cd7 <__panic>
c0104d24:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d27:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104d2c:	89 c2                	mov    %eax,%edx
c0104d2e:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104d33:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104d3a:	00 
c0104d3b:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104d3f:	89 04 24             	mov    %eax,(%esp)
c0104d42:	e8 19 f7 ff ff       	call   c0104460 <get_pte>
c0104d47:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104d4a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104d4e:	75 24                	jne    c0104d74 <check_boot_pgdir+0x9e>
c0104d50:	c7 44 24 0c c4 6c 10 	movl   $0xc0106cc4,0xc(%esp)
c0104d57:	c0 
c0104d58:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104d5f:	c0 
c0104d60:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
c0104d67:	00 
c0104d68:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104d6f:	e8 63 bf ff ff       	call   c0100cd7 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104d74:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104d77:	8b 00                	mov    (%eax),%eax
c0104d79:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104d7e:	89 c2                	mov    %eax,%edx
c0104d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d83:	39 c2                	cmp    %eax,%edx
c0104d85:	74 24                	je     c0104dab <check_boot_pgdir+0xd5>
c0104d87:	c7 44 24 0c 01 6d 10 	movl   $0xc0106d01,0xc(%esp)
c0104d8e:	c0 
c0104d8f:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104d96:	c0 
c0104d97:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
c0104d9e:	00 
c0104d9f:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104da6:	e8 2c bf ff ff       	call   c0100cd7 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104dab:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104db2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104db5:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104dba:	39 c2                	cmp    %eax,%edx
c0104dbc:	0f 82 26 ff ff ff    	jb     c0104ce8 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104dc2:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104dc7:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104dcc:	8b 00                	mov    (%eax),%eax
c0104dce:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104dd3:	89 c2                	mov    %eax,%edx
c0104dd5:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104dda:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104ddd:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0104de4:	77 23                	ja     c0104e09 <check_boot_pgdir+0x133>
c0104de6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104de9:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104ded:	c7 44 24 08 90 69 10 	movl   $0xc0106990,0x8(%esp)
c0104df4:	c0 
c0104df5:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c0104dfc:	00 
c0104dfd:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104e04:	e8 ce be ff ff       	call   c0100cd7 <__panic>
c0104e09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e0c:	05 00 00 00 40       	add    $0x40000000,%eax
c0104e11:	39 c2                	cmp    %eax,%edx
c0104e13:	74 24                	je     c0104e39 <check_boot_pgdir+0x163>
c0104e15:	c7 44 24 0c 18 6d 10 	movl   $0xc0106d18,0xc(%esp)
c0104e1c:	c0 
c0104e1d:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104e24:	c0 
c0104e25:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c0104e2c:	00 
c0104e2d:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104e34:	e8 9e be ff ff       	call   c0100cd7 <__panic>

    assert(boot_pgdir[0] == 0);
c0104e39:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104e3e:	8b 00                	mov    (%eax),%eax
c0104e40:	85 c0                	test   %eax,%eax
c0104e42:	74 24                	je     c0104e68 <check_boot_pgdir+0x192>
c0104e44:	c7 44 24 0c 4c 6d 10 	movl   $0xc0106d4c,0xc(%esp)
c0104e4b:	c0 
c0104e4c:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104e53:	c0 
c0104e54:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
c0104e5b:	00 
c0104e5c:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104e63:	e8 6f be ff ff       	call   c0100cd7 <__panic>

    struct Page *p;
    p = alloc_page();
c0104e68:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104e6f:	e8 ad ee ff ff       	call   c0103d21 <alloc_pages>
c0104e74:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0104e77:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104e7c:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104e83:	00 
c0104e84:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0104e8b:	00 
c0104e8c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104e8f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104e93:	89 04 24             	mov    %eax,(%esp)
c0104e96:	e8 6c f6 ff ff       	call   c0104507 <page_insert>
c0104e9b:	85 c0                	test   %eax,%eax
c0104e9d:	74 24                	je     c0104ec3 <check_boot_pgdir+0x1ed>
c0104e9f:	c7 44 24 0c 60 6d 10 	movl   $0xc0106d60,0xc(%esp)
c0104ea6:	c0 
c0104ea7:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104eae:	c0 
c0104eaf:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
c0104eb6:	00 
c0104eb7:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104ebe:	e8 14 be ff ff       	call   c0100cd7 <__panic>
    assert(page_ref(p) == 1);
c0104ec3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104ec6:	89 04 24             	mov    %eax,(%esp)
c0104ec9:	e8 5b ec ff ff       	call   c0103b29 <page_ref>
c0104ece:	83 f8 01             	cmp    $0x1,%eax
c0104ed1:	74 24                	je     c0104ef7 <check_boot_pgdir+0x221>
c0104ed3:	c7 44 24 0c 8e 6d 10 	movl   $0xc0106d8e,0xc(%esp)
c0104eda:	c0 
c0104edb:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104ee2:	c0 
c0104ee3:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
c0104eea:	00 
c0104eeb:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104ef2:	e8 e0 bd ff ff       	call   c0100cd7 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0104ef7:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104efc:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104f03:	00 
c0104f04:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0104f0b:	00 
c0104f0c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104f0f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104f13:	89 04 24             	mov    %eax,(%esp)
c0104f16:	e8 ec f5 ff ff       	call   c0104507 <page_insert>
c0104f1b:	85 c0                	test   %eax,%eax
c0104f1d:	74 24                	je     c0104f43 <check_boot_pgdir+0x26d>
c0104f1f:	c7 44 24 0c a0 6d 10 	movl   $0xc0106da0,0xc(%esp)
c0104f26:	c0 
c0104f27:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104f2e:	c0 
c0104f2f:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c0104f36:	00 
c0104f37:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104f3e:	e8 94 bd ff ff       	call   c0100cd7 <__panic>
    assert(page_ref(p) == 2);
c0104f43:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104f46:	89 04 24             	mov    %eax,(%esp)
c0104f49:	e8 db eb ff ff       	call   c0103b29 <page_ref>
c0104f4e:	83 f8 02             	cmp    $0x2,%eax
c0104f51:	74 24                	je     c0104f77 <check_boot_pgdir+0x2a1>
c0104f53:	c7 44 24 0c d7 6d 10 	movl   $0xc0106dd7,0xc(%esp)
c0104f5a:	c0 
c0104f5b:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104f62:	c0 
c0104f63:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c0104f6a:	00 
c0104f6b:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104f72:	e8 60 bd ff ff       	call   c0100cd7 <__panic>

    const char *str = "ucore: Hello world!!";
c0104f77:	c7 45 dc e8 6d 10 c0 	movl   $0xc0106de8,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0104f7e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104f81:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104f85:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104f8c:	e8 19 0a 00 00       	call   c01059aa <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0104f91:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0104f98:	00 
c0104f99:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104fa0:	e8 7e 0a 00 00       	call   c0105a23 <strcmp>
c0104fa5:	85 c0                	test   %eax,%eax
c0104fa7:	74 24                	je     c0104fcd <check_boot_pgdir+0x2f7>
c0104fa9:	c7 44 24 0c 00 6e 10 	movl   $0xc0106e00,0xc(%esp)
c0104fb0:	c0 
c0104fb1:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104fb8:	c0 
c0104fb9:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
c0104fc0:	00 
c0104fc1:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c0104fc8:	e8 0a bd ff ff       	call   c0100cd7 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0104fcd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104fd0:	89 04 24             	mov    %eax,(%esp)
c0104fd3:	e8 a7 ea ff ff       	call   c0103a7f <page2kva>
c0104fd8:	05 00 01 00 00       	add    $0x100,%eax
c0104fdd:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0104fe0:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104fe7:	e8 66 09 00 00       	call   c0105952 <strlen>
c0104fec:	85 c0                	test   %eax,%eax
c0104fee:	74 24                	je     c0105014 <check_boot_pgdir+0x33e>
c0104ff0:	c7 44 24 0c 38 6e 10 	movl   $0xc0106e38,0xc(%esp)
c0104ff7:	c0 
c0104ff8:	c7 44 24 08 d9 69 10 	movl   $0xc01069d9,0x8(%esp)
c0104fff:	c0 
c0105000:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
c0105007:	00 
c0105008:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c010500f:	e8 c3 bc ff ff       	call   c0100cd7 <__panic>

    free_page(p);
c0105014:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010501b:	00 
c010501c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010501f:	89 04 24             	mov    %eax,(%esp)
c0105022:	e8 32 ed ff ff       	call   c0103d59 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0105027:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010502c:	8b 00                	mov    (%eax),%eax
c010502e:	89 04 24             	mov    %eax,(%esp)
c0105031:	e8 db ea ff ff       	call   c0103b11 <pde2page>
c0105036:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010503d:	00 
c010503e:	89 04 24             	mov    %eax,(%esp)
c0105041:	e8 13 ed ff ff       	call   c0103d59 <free_pages>
    boot_pgdir[0] = 0;
c0105046:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010504b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0105051:	c7 04 24 5c 6e 10 c0 	movl   $0xc0106e5c,(%esp)
c0105058:	e8 df b2 ff ff       	call   c010033c <cprintf>
}
c010505d:	c9                   	leave  
c010505e:	c3                   	ret    

c010505f <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c010505f:	55                   	push   %ebp
c0105060:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0105062:	8b 45 08             	mov    0x8(%ebp),%eax
c0105065:	83 e0 04             	and    $0x4,%eax
c0105068:	85 c0                	test   %eax,%eax
c010506a:	74 07                	je     c0105073 <perm2str+0x14>
c010506c:	b8 75 00 00 00       	mov    $0x75,%eax
c0105071:	eb 05                	jmp    c0105078 <perm2str+0x19>
c0105073:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105078:	a2 48 89 11 c0       	mov    %al,0xc0118948
    str[1] = 'r';
c010507d:	c6 05 49 89 11 c0 72 	movb   $0x72,0xc0118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0105084:	8b 45 08             	mov    0x8(%ebp),%eax
c0105087:	83 e0 02             	and    $0x2,%eax
c010508a:	85 c0                	test   %eax,%eax
c010508c:	74 07                	je     c0105095 <perm2str+0x36>
c010508e:	b8 77 00 00 00       	mov    $0x77,%eax
c0105093:	eb 05                	jmp    c010509a <perm2str+0x3b>
c0105095:	b8 2d 00 00 00       	mov    $0x2d,%eax
c010509a:	a2 4a 89 11 c0       	mov    %al,0xc011894a
    str[3] = '\0';
c010509f:	c6 05 4b 89 11 c0 00 	movb   $0x0,0xc011894b
    return str;
c01050a6:	b8 48 89 11 c0       	mov    $0xc0118948,%eax
}
c01050ab:	5d                   	pop    %ebp
c01050ac:	c3                   	ret    

c01050ad <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c01050ad:	55                   	push   %ebp
c01050ae:	89 e5                	mov    %esp,%ebp
c01050b0:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c01050b3:	8b 45 10             	mov    0x10(%ebp),%eax
c01050b6:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01050b9:	72 0a                	jb     c01050c5 <get_pgtable_items+0x18>
        return 0;
c01050bb:	b8 00 00 00 00       	mov    $0x0,%eax
c01050c0:	e9 9c 00 00 00       	jmp    c0105161 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c01050c5:	eb 04                	jmp    c01050cb <get_pgtable_items+0x1e>
        start ++;
c01050c7:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c01050cb:	8b 45 10             	mov    0x10(%ebp),%eax
c01050ce:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01050d1:	73 18                	jae    c01050eb <get_pgtable_items+0x3e>
c01050d3:	8b 45 10             	mov    0x10(%ebp),%eax
c01050d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01050dd:	8b 45 14             	mov    0x14(%ebp),%eax
c01050e0:	01 d0                	add    %edx,%eax
c01050e2:	8b 00                	mov    (%eax),%eax
c01050e4:	83 e0 01             	and    $0x1,%eax
c01050e7:	85 c0                	test   %eax,%eax
c01050e9:	74 dc                	je     c01050c7 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c01050eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01050ee:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01050f1:	73 69                	jae    c010515c <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c01050f3:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c01050f7:	74 08                	je     c0105101 <get_pgtable_items+0x54>
            *left_store = start;
c01050f9:	8b 45 18             	mov    0x18(%ebp),%eax
c01050fc:	8b 55 10             	mov    0x10(%ebp),%edx
c01050ff:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0105101:	8b 45 10             	mov    0x10(%ebp),%eax
c0105104:	8d 50 01             	lea    0x1(%eax),%edx
c0105107:	89 55 10             	mov    %edx,0x10(%ebp)
c010510a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105111:	8b 45 14             	mov    0x14(%ebp),%eax
c0105114:	01 d0                	add    %edx,%eax
c0105116:	8b 00                	mov    (%eax),%eax
c0105118:	83 e0 07             	and    $0x7,%eax
c010511b:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c010511e:	eb 04                	jmp    c0105124 <get_pgtable_items+0x77>
            start ++;
c0105120:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105124:	8b 45 10             	mov    0x10(%ebp),%eax
c0105127:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010512a:	73 1d                	jae    c0105149 <get_pgtable_items+0x9c>
c010512c:	8b 45 10             	mov    0x10(%ebp),%eax
c010512f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105136:	8b 45 14             	mov    0x14(%ebp),%eax
c0105139:	01 d0                	add    %edx,%eax
c010513b:	8b 00                	mov    (%eax),%eax
c010513d:	83 e0 07             	and    $0x7,%eax
c0105140:	89 c2                	mov    %eax,%edx
c0105142:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105145:	39 c2                	cmp    %eax,%edx
c0105147:	74 d7                	je     c0105120 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c0105149:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010514d:	74 08                	je     c0105157 <get_pgtable_items+0xaa>
            *right_store = start;
c010514f:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105152:	8b 55 10             	mov    0x10(%ebp),%edx
c0105155:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0105157:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010515a:	eb 05                	jmp    c0105161 <get_pgtable_items+0xb4>
    }
    return 0;
c010515c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105161:	c9                   	leave  
c0105162:	c3                   	ret    

c0105163 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0105163:	55                   	push   %ebp
c0105164:	89 e5                	mov    %esp,%ebp
c0105166:	57                   	push   %edi
c0105167:	56                   	push   %esi
c0105168:	53                   	push   %ebx
c0105169:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c010516c:	c7 04 24 7c 6e 10 c0 	movl   $0xc0106e7c,(%esp)
c0105173:	e8 c4 b1 ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
c0105178:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010517f:	e9 fa 00 00 00       	jmp    c010527e <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105184:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105187:	89 04 24             	mov    %eax,(%esp)
c010518a:	e8 d0 fe ff ff       	call   c010505f <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c010518f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105192:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105195:	29 d1                	sub    %edx,%ecx
c0105197:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105199:	89 d6                	mov    %edx,%esi
c010519b:	c1 e6 16             	shl    $0x16,%esi
c010519e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01051a1:	89 d3                	mov    %edx,%ebx
c01051a3:	c1 e3 16             	shl    $0x16,%ebx
c01051a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01051a9:	89 d1                	mov    %edx,%ecx
c01051ab:	c1 e1 16             	shl    $0x16,%ecx
c01051ae:	8b 7d dc             	mov    -0x24(%ebp),%edi
c01051b1:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01051b4:	29 d7                	sub    %edx,%edi
c01051b6:	89 fa                	mov    %edi,%edx
c01051b8:	89 44 24 14          	mov    %eax,0x14(%esp)
c01051bc:	89 74 24 10          	mov    %esi,0x10(%esp)
c01051c0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01051c4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01051c8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01051cc:	c7 04 24 ad 6e 10 c0 	movl   $0xc0106ead,(%esp)
c01051d3:	e8 64 b1 ff ff       	call   c010033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c01051d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01051db:	c1 e0 0a             	shl    $0xa,%eax
c01051de:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01051e1:	eb 54                	jmp    c0105237 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01051e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01051e6:	89 04 24             	mov    %eax,(%esp)
c01051e9:	e8 71 fe ff ff       	call   c010505f <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c01051ee:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01051f1:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01051f4:	29 d1                	sub    %edx,%ecx
c01051f6:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01051f8:	89 d6                	mov    %edx,%esi
c01051fa:	c1 e6 0c             	shl    $0xc,%esi
c01051fd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105200:	89 d3                	mov    %edx,%ebx
c0105202:	c1 e3 0c             	shl    $0xc,%ebx
c0105205:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105208:	c1 e2 0c             	shl    $0xc,%edx
c010520b:	89 d1                	mov    %edx,%ecx
c010520d:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0105210:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105213:	29 d7                	sub    %edx,%edi
c0105215:	89 fa                	mov    %edi,%edx
c0105217:	89 44 24 14          	mov    %eax,0x14(%esp)
c010521b:	89 74 24 10          	mov    %esi,0x10(%esp)
c010521f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105223:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105227:	89 54 24 04          	mov    %edx,0x4(%esp)
c010522b:	c7 04 24 cc 6e 10 c0 	movl   $0xc0106ecc,(%esp)
c0105232:	e8 05 b1 ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105237:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c010523c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010523f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105242:	89 ce                	mov    %ecx,%esi
c0105244:	c1 e6 0a             	shl    $0xa,%esi
c0105247:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c010524a:	89 cb                	mov    %ecx,%ebx
c010524c:	c1 e3 0a             	shl    $0xa,%ebx
c010524f:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0105252:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105256:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c0105259:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010525d:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105261:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105265:	89 74 24 04          	mov    %esi,0x4(%esp)
c0105269:	89 1c 24             	mov    %ebx,(%esp)
c010526c:	e8 3c fe ff ff       	call   c01050ad <get_pgtable_items>
c0105271:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105274:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105278:	0f 85 65 ff ff ff    	jne    c01051e3 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010527e:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0105283:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105286:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c0105289:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c010528d:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0105290:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105294:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105298:	89 44 24 08          	mov    %eax,0x8(%esp)
c010529c:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c01052a3:	00 
c01052a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01052ab:	e8 fd fd ff ff       	call   c01050ad <get_pgtable_items>
c01052b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01052b3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01052b7:	0f 85 c7 fe ff ff    	jne    c0105184 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01052bd:	c7 04 24 f0 6e 10 c0 	movl   $0xc0106ef0,(%esp)
c01052c4:	e8 73 b0 ff ff       	call   c010033c <cprintf>
}
c01052c9:	83 c4 4c             	add    $0x4c,%esp
c01052cc:	5b                   	pop    %ebx
c01052cd:	5e                   	pop    %esi
c01052ce:	5f                   	pop    %edi
c01052cf:	5d                   	pop    %ebp
c01052d0:	c3                   	ret    

c01052d1 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01052d1:	55                   	push   %ebp
c01052d2:	89 e5                	mov    %esp,%ebp
c01052d4:	83 ec 58             	sub    $0x58,%esp
c01052d7:	8b 45 10             	mov    0x10(%ebp),%eax
c01052da:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01052dd:	8b 45 14             	mov    0x14(%ebp),%eax
c01052e0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c01052e3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01052e6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01052e9:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01052ec:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01052ef:	8b 45 18             	mov    0x18(%ebp),%eax
c01052f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01052f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01052f8:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01052fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01052fe:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0105301:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105304:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105307:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010530b:	74 1c                	je     c0105329 <printnum+0x58>
c010530d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105310:	ba 00 00 00 00       	mov    $0x0,%edx
c0105315:	f7 75 e4             	divl   -0x1c(%ebp)
c0105318:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010531b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010531e:	ba 00 00 00 00       	mov    $0x0,%edx
c0105323:	f7 75 e4             	divl   -0x1c(%ebp)
c0105326:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105329:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010532c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010532f:	f7 75 e4             	divl   -0x1c(%ebp)
c0105332:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105335:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105338:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010533b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010533e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105341:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0105344:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105347:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c010534a:	8b 45 18             	mov    0x18(%ebp),%eax
c010534d:	ba 00 00 00 00       	mov    $0x0,%edx
c0105352:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105355:	77 56                	ja     c01053ad <printnum+0xdc>
c0105357:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010535a:	72 05                	jb     c0105361 <printnum+0x90>
c010535c:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c010535f:	77 4c                	ja     c01053ad <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c0105361:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105364:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105367:	8b 45 20             	mov    0x20(%ebp),%eax
c010536a:	89 44 24 18          	mov    %eax,0x18(%esp)
c010536e:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105372:	8b 45 18             	mov    0x18(%ebp),%eax
c0105375:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105379:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010537c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010537f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105383:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105387:	8b 45 0c             	mov    0xc(%ebp),%eax
c010538a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010538e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105391:	89 04 24             	mov    %eax,(%esp)
c0105394:	e8 38 ff ff ff       	call   c01052d1 <printnum>
c0105399:	eb 1c                	jmp    c01053b7 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c010539b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010539e:	89 44 24 04          	mov    %eax,0x4(%esp)
c01053a2:	8b 45 20             	mov    0x20(%ebp),%eax
c01053a5:	89 04 24             	mov    %eax,(%esp)
c01053a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01053ab:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c01053ad:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c01053b1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01053b5:	7f e4                	jg     c010539b <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01053b7:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01053ba:	05 a4 6f 10 c0       	add    $0xc0106fa4,%eax
c01053bf:	0f b6 00             	movzbl (%eax),%eax
c01053c2:	0f be c0             	movsbl %al,%eax
c01053c5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01053c8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01053cc:	89 04 24             	mov    %eax,(%esp)
c01053cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01053d2:	ff d0                	call   *%eax
}
c01053d4:	c9                   	leave  
c01053d5:	c3                   	ret    

c01053d6 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01053d6:	55                   	push   %ebp
c01053d7:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01053d9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01053dd:	7e 14                	jle    c01053f3 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01053df:	8b 45 08             	mov    0x8(%ebp),%eax
c01053e2:	8b 00                	mov    (%eax),%eax
c01053e4:	8d 48 08             	lea    0x8(%eax),%ecx
c01053e7:	8b 55 08             	mov    0x8(%ebp),%edx
c01053ea:	89 0a                	mov    %ecx,(%edx)
c01053ec:	8b 50 04             	mov    0x4(%eax),%edx
c01053ef:	8b 00                	mov    (%eax),%eax
c01053f1:	eb 30                	jmp    c0105423 <getuint+0x4d>
    }
    else if (lflag) {
c01053f3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01053f7:	74 16                	je     c010540f <getuint+0x39>
        return va_arg(*ap, unsigned long);
c01053f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01053fc:	8b 00                	mov    (%eax),%eax
c01053fe:	8d 48 04             	lea    0x4(%eax),%ecx
c0105401:	8b 55 08             	mov    0x8(%ebp),%edx
c0105404:	89 0a                	mov    %ecx,(%edx)
c0105406:	8b 00                	mov    (%eax),%eax
c0105408:	ba 00 00 00 00       	mov    $0x0,%edx
c010540d:	eb 14                	jmp    c0105423 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c010540f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105412:	8b 00                	mov    (%eax),%eax
c0105414:	8d 48 04             	lea    0x4(%eax),%ecx
c0105417:	8b 55 08             	mov    0x8(%ebp),%edx
c010541a:	89 0a                	mov    %ecx,(%edx)
c010541c:	8b 00                	mov    (%eax),%eax
c010541e:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105423:	5d                   	pop    %ebp
c0105424:	c3                   	ret    

c0105425 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0105425:	55                   	push   %ebp
c0105426:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105428:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010542c:	7e 14                	jle    c0105442 <getint+0x1d>
        return va_arg(*ap, long long);
c010542e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105431:	8b 00                	mov    (%eax),%eax
c0105433:	8d 48 08             	lea    0x8(%eax),%ecx
c0105436:	8b 55 08             	mov    0x8(%ebp),%edx
c0105439:	89 0a                	mov    %ecx,(%edx)
c010543b:	8b 50 04             	mov    0x4(%eax),%edx
c010543e:	8b 00                	mov    (%eax),%eax
c0105440:	eb 28                	jmp    c010546a <getint+0x45>
    }
    else if (lflag) {
c0105442:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105446:	74 12                	je     c010545a <getint+0x35>
        return va_arg(*ap, long);
c0105448:	8b 45 08             	mov    0x8(%ebp),%eax
c010544b:	8b 00                	mov    (%eax),%eax
c010544d:	8d 48 04             	lea    0x4(%eax),%ecx
c0105450:	8b 55 08             	mov    0x8(%ebp),%edx
c0105453:	89 0a                	mov    %ecx,(%edx)
c0105455:	8b 00                	mov    (%eax),%eax
c0105457:	99                   	cltd   
c0105458:	eb 10                	jmp    c010546a <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c010545a:	8b 45 08             	mov    0x8(%ebp),%eax
c010545d:	8b 00                	mov    (%eax),%eax
c010545f:	8d 48 04             	lea    0x4(%eax),%ecx
c0105462:	8b 55 08             	mov    0x8(%ebp),%edx
c0105465:	89 0a                	mov    %ecx,(%edx)
c0105467:	8b 00                	mov    (%eax),%eax
c0105469:	99                   	cltd   
    }
}
c010546a:	5d                   	pop    %ebp
c010546b:	c3                   	ret    

c010546c <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c010546c:	55                   	push   %ebp
c010546d:	89 e5                	mov    %esp,%ebp
c010546f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0105472:	8d 45 14             	lea    0x14(%ebp),%eax
c0105475:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0105478:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010547b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010547f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105482:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105486:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105489:	89 44 24 04          	mov    %eax,0x4(%esp)
c010548d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105490:	89 04 24             	mov    %eax,(%esp)
c0105493:	e8 02 00 00 00       	call   c010549a <vprintfmt>
    va_end(ap);
}
c0105498:	c9                   	leave  
c0105499:	c3                   	ret    

c010549a <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c010549a:	55                   	push   %ebp
c010549b:	89 e5                	mov    %esp,%ebp
c010549d:	56                   	push   %esi
c010549e:	53                   	push   %ebx
c010549f:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01054a2:	eb 18                	jmp    c01054bc <vprintfmt+0x22>
            if (ch == '\0') {
c01054a4:	85 db                	test   %ebx,%ebx
c01054a6:	75 05                	jne    c01054ad <vprintfmt+0x13>
                return;
c01054a8:	e9 d1 03 00 00       	jmp    c010587e <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c01054ad:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054b0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01054b4:	89 1c 24             	mov    %ebx,(%esp)
c01054b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01054ba:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01054bc:	8b 45 10             	mov    0x10(%ebp),%eax
c01054bf:	8d 50 01             	lea    0x1(%eax),%edx
c01054c2:	89 55 10             	mov    %edx,0x10(%ebp)
c01054c5:	0f b6 00             	movzbl (%eax),%eax
c01054c8:	0f b6 d8             	movzbl %al,%ebx
c01054cb:	83 fb 25             	cmp    $0x25,%ebx
c01054ce:	75 d4                	jne    c01054a4 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c01054d0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c01054d4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c01054db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01054de:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01054e1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01054e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01054eb:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01054ee:	8b 45 10             	mov    0x10(%ebp),%eax
c01054f1:	8d 50 01             	lea    0x1(%eax),%edx
c01054f4:	89 55 10             	mov    %edx,0x10(%ebp)
c01054f7:	0f b6 00             	movzbl (%eax),%eax
c01054fa:	0f b6 d8             	movzbl %al,%ebx
c01054fd:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105500:	83 f8 55             	cmp    $0x55,%eax
c0105503:	0f 87 44 03 00 00    	ja     c010584d <vprintfmt+0x3b3>
c0105509:	8b 04 85 c8 6f 10 c0 	mov    -0x3fef9038(,%eax,4),%eax
c0105510:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105512:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105516:	eb d6                	jmp    c01054ee <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105518:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c010551c:	eb d0                	jmp    c01054ee <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010551e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105525:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105528:	89 d0                	mov    %edx,%eax
c010552a:	c1 e0 02             	shl    $0x2,%eax
c010552d:	01 d0                	add    %edx,%eax
c010552f:	01 c0                	add    %eax,%eax
c0105531:	01 d8                	add    %ebx,%eax
c0105533:	83 e8 30             	sub    $0x30,%eax
c0105536:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105539:	8b 45 10             	mov    0x10(%ebp),%eax
c010553c:	0f b6 00             	movzbl (%eax),%eax
c010553f:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0105542:	83 fb 2f             	cmp    $0x2f,%ebx
c0105545:	7e 0b                	jle    c0105552 <vprintfmt+0xb8>
c0105547:	83 fb 39             	cmp    $0x39,%ebx
c010554a:	7f 06                	jg     c0105552 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010554c:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c0105550:	eb d3                	jmp    c0105525 <vprintfmt+0x8b>
            goto process_precision;
c0105552:	eb 33                	jmp    c0105587 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c0105554:	8b 45 14             	mov    0x14(%ebp),%eax
c0105557:	8d 50 04             	lea    0x4(%eax),%edx
c010555a:	89 55 14             	mov    %edx,0x14(%ebp)
c010555d:	8b 00                	mov    (%eax),%eax
c010555f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0105562:	eb 23                	jmp    c0105587 <vprintfmt+0xed>

        case '.':
            if (width < 0)
c0105564:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105568:	79 0c                	jns    c0105576 <vprintfmt+0xdc>
                width = 0;
c010556a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0105571:	e9 78 ff ff ff       	jmp    c01054ee <vprintfmt+0x54>
c0105576:	e9 73 ff ff ff       	jmp    c01054ee <vprintfmt+0x54>

        case '#':
            altflag = 1;
c010557b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0105582:	e9 67 ff ff ff       	jmp    c01054ee <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c0105587:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010558b:	79 12                	jns    c010559f <vprintfmt+0x105>
                width = precision, precision = -1;
c010558d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105590:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105593:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c010559a:	e9 4f ff ff ff       	jmp    c01054ee <vprintfmt+0x54>
c010559f:	e9 4a ff ff ff       	jmp    c01054ee <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01055a4:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c01055a8:	e9 41 ff ff ff       	jmp    c01054ee <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01055ad:	8b 45 14             	mov    0x14(%ebp),%eax
c01055b0:	8d 50 04             	lea    0x4(%eax),%edx
c01055b3:	89 55 14             	mov    %edx,0x14(%ebp)
c01055b6:	8b 00                	mov    (%eax),%eax
c01055b8:	8b 55 0c             	mov    0xc(%ebp),%edx
c01055bb:	89 54 24 04          	mov    %edx,0x4(%esp)
c01055bf:	89 04 24             	mov    %eax,(%esp)
c01055c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01055c5:	ff d0                	call   *%eax
            break;
c01055c7:	e9 ac 02 00 00       	jmp    c0105878 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01055cc:	8b 45 14             	mov    0x14(%ebp),%eax
c01055cf:	8d 50 04             	lea    0x4(%eax),%edx
c01055d2:	89 55 14             	mov    %edx,0x14(%ebp)
c01055d5:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c01055d7:	85 db                	test   %ebx,%ebx
c01055d9:	79 02                	jns    c01055dd <vprintfmt+0x143>
                err = -err;
c01055db:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c01055dd:	83 fb 06             	cmp    $0x6,%ebx
c01055e0:	7f 0b                	jg     c01055ed <vprintfmt+0x153>
c01055e2:	8b 34 9d 88 6f 10 c0 	mov    -0x3fef9078(,%ebx,4),%esi
c01055e9:	85 f6                	test   %esi,%esi
c01055eb:	75 23                	jne    c0105610 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c01055ed:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01055f1:	c7 44 24 08 b5 6f 10 	movl   $0xc0106fb5,0x8(%esp)
c01055f8:	c0 
c01055f9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055fc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105600:	8b 45 08             	mov    0x8(%ebp),%eax
c0105603:	89 04 24             	mov    %eax,(%esp)
c0105606:	e8 61 fe ff ff       	call   c010546c <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c010560b:	e9 68 02 00 00       	jmp    c0105878 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0105610:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105614:	c7 44 24 08 be 6f 10 	movl   $0xc0106fbe,0x8(%esp)
c010561b:	c0 
c010561c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010561f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105623:	8b 45 08             	mov    0x8(%ebp),%eax
c0105626:	89 04 24             	mov    %eax,(%esp)
c0105629:	e8 3e fe ff ff       	call   c010546c <printfmt>
            }
            break;
c010562e:	e9 45 02 00 00       	jmp    c0105878 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105633:	8b 45 14             	mov    0x14(%ebp),%eax
c0105636:	8d 50 04             	lea    0x4(%eax),%edx
c0105639:	89 55 14             	mov    %edx,0x14(%ebp)
c010563c:	8b 30                	mov    (%eax),%esi
c010563e:	85 f6                	test   %esi,%esi
c0105640:	75 05                	jne    c0105647 <vprintfmt+0x1ad>
                p = "(null)";
c0105642:	be c1 6f 10 c0       	mov    $0xc0106fc1,%esi
            }
            if (width > 0 && padc != '-') {
c0105647:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010564b:	7e 3e                	jle    c010568b <vprintfmt+0x1f1>
c010564d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105651:	74 38                	je     c010568b <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105653:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c0105656:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105659:	89 44 24 04          	mov    %eax,0x4(%esp)
c010565d:	89 34 24             	mov    %esi,(%esp)
c0105660:	e8 15 03 00 00       	call   c010597a <strnlen>
c0105665:	29 c3                	sub    %eax,%ebx
c0105667:	89 d8                	mov    %ebx,%eax
c0105669:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010566c:	eb 17                	jmp    c0105685 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c010566e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0105672:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105675:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105679:	89 04 24             	mov    %eax,(%esp)
c010567c:	8b 45 08             	mov    0x8(%ebp),%eax
c010567f:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105681:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105685:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105689:	7f e3                	jg     c010566e <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010568b:	eb 38                	jmp    c01056c5 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c010568d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105691:	74 1f                	je     c01056b2 <vprintfmt+0x218>
c0105693:	83 fb 1f             	cmp    $0x1f,%ebx
c0105696:	7e 05                	jle    c010569d <vprintfmt+0x203>
c0105698:	83 fb 7e             	cmp    $0x7e,%ebx
c010569b:	7e 15                	jle    c01056b2 <vprintfmt+0x218>
                    putch('?', putdat);
c010569d:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056a0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056a4:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c01056ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01056ae:	ff d0                	call   *%eax
c01056b0:	eb 0f                	jmp    c01056c1 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c01056b2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056b5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056b9:	89 1c 24             	mov    %ebx,(%esp)
c01056bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01056bf:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01056c1:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01056c5:	89 f0                	mov    %esi,%eax
c01056c7:	8d 70 01             	lea    0x1(%eax),%esi
c01056ca:	0f b6 00             	movzbl (%eax),%eax
c01056cd:	0f be d8             	movsbl %al,%ebx
c01056d0:	85 db                	test   %ebx,%ebx
c01056d2:	74 10                	je     c01056e4 <vprintfmt+0x24a>
c01056d4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01056d8:	78 b3                	js     c010568d <vprintfmt+0x1f3>
c01056da:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c01056de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01056e2:	79 a9                	jns    c010568d <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01056e4:	eb 17                	jmp    c01056fd <vprintfmt+0x263>
                putch(' ', putdat);
c01056e6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056e9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056ed:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01056f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01056f7:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01056f9:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01056fd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105701:	7f e3                	jg     c01056e6 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c0105703:	e9 70 01 00 00       	jmp    c0105878 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105708:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010570b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010570f:	8d 45 14             	lea    0x14(%ebp),%eax
c0105712:	89 04 24             	mov    %eax,(%esp)
c0105715:	e8 0b fd ff ff       	call   c0105425 <getint>
c010571a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010571d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105720:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105723:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105726:	85 d2                	test   %edx,%edx
c0105728:	79 26                	jns    c0105750 <vprintfmt+0x2b6>
                putch('-', putdat);
c010572a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010572d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105731:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105738:	8b 45 08             	mov    0x8(%ebp),%eax
c010573b:	ff d0                	call   *%eax
                num = -(long long)num;
c010573d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105740:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105743:	f7 d8                	neg    %eax
c0105745:	83 d2 00             	adc    $0x0,%edx
c0105748:	f7 da                	neg    %edx
c010574a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010574d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105750:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105757:	e9 a8 00 00 00       	jmp    c0105804 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c010575c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010575f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105763:	8d 45 14             	lea    0x14(%ebp),%eax
c0105766:	89 04 24             	mov    %eax,(%esp)
c0105769:	e8 68 fc ff ff       	call   c01053d6 <getuint>
c010576e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105771:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105774:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010577b:	e9 84 00 00 00       	jmp    c0105804 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105780:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105783:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105787:	8d 45 14             	lea    0x14(%ebp),%eax
c010578a:	89 04 24             	mov    %eax,(%esp)
c010578d:	e8 44 fc ff ff       	call   c01053d6 <getuint>
c0105792:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105795:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105798:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c010579f:	eb 63                	jmp    c0105804 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c01057a1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057a4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057a8:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c01057af:	8b 45 08             	mov    0x8(%ebp),%eax
c01057b2:	ff d0                	call   *%eax
            putch('x', putdat);
c01057b4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057b7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057bb:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c01057c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01057c5:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c01057c7:	8b 45 14             	mov    0x14(%ebp),%eax
c01057ca:	8d 50 04             	lea    0x4(%eax),%edx
c01057cd:	89 55 14             	mov    %edx,0x14(%ebp)
c01057d0:	8b 00                	mov    (%eax),%eax
c01057d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01057d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c01057dc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c01057e3:	eb 1f                	jmp    c0105804 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c01057e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01057e8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057ec:	8d 45 14             	lea    0x14(%ebp),%eax
c01057ef:	89 04 24             	mov    %eax,(%esp)
c01057f2:	e8 df fb ff ff       	call   c01053d6 <getuint>
c01057f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01057fa:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c01057fd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105804:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105808:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010580b:	89 54 24 18          	mov    %edx,0x18(%esp)
c010580f:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105812:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105816:	89 44 24 10          	mov    %eax,0x10(%esp)
c010581a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010581d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105820:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105824:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105828:	8b 45 0c             	mov    0xc(%ebp),%eax
c010582b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010582f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105832:	89 04 24             	mov    %eax,(%esp)
c0105835:	e8 97 fa ff ff       	call   c01052d1 <printnum>
            break;
c010583a:	eb 3c                	jmp    c0105878 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c010583c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010583f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105843:	89 1c 24             	mov    %ebx,(%esp)
c0105846:	8b 45 08             	mov    0x8(%ebp),%eax
c0105849:	ff d0                	call   *%eax
            break;
c010584b:	eb 2b                	jmp    c0105878 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c010584d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105850:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105854:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c010585b:	8b 45 08             	mov    0x8(%ebp),%eax
c010585e:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105860:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105864:	eb 04                	jmp    c010586a <vprintfmt+0x3d0>
c0105866:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010586a:	8b 45 10             	mov    0x10(%ebp),%eax
c010586d:	83 e8 01             	sub    $0x1,%eax
c0105870:	0f b6 00             	movzbl (%eax),%eax
c0105873:	3c 25                	cmp    $0x25,%al
c0105875:	75 ef                	jne    c0105866 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c0105877:	90                   	nop
        }
    }
c0105878:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105879:	e9 3e fc ff ff       	jmp    c01054bc <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c010587e:	83 c4 40             	add    $0x40,%esp
c0105881:	5b                   	pop    %ebx
c0105882:	5e                   	pop    %esi
c0105883:	5d                   	pop    %ebp
c0105884:	c3                   	ret    

c0105885 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105885:	55                   	push   %ebp
c0105886:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105888:	8b 45 0c             	mov    0xc(%ebp),%eax
c010588b:	8b 40 08             	mov    0x8(%eax),%eax
c010588e:	8d 50 01             	lea    0x1(%eax),%edx
c0105891:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105894:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105897:	8b 45 0c             	mov    0xc(%ebp),%eax
c010589a:	8b 10                	mov    (%eax),%edx
c010589c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010589f:	8b 40 04             	mov    0x4(%eax),%eax
c01058a2:	39 c2                	cmp    %eax,%edx
c01058a4:	73 12                	jae    c01058b8 <sprintputch+0x33>
        *b->buf ++ = ch;
c01058a6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058a9:	8b 00                	mov    (%eax),%eax
c01058ab:	8d 48 01             	lea    0x1(%eax),%ecx
c01058ae:	8b 55 0c             	mov    0xc(%ebp),%edx
c01058b1:	89 0a                	mov    %ecx,(%edx)
c01058b3:	8b 55 08             	mov    0x8(%ebp),%edx
c01058b6:	88 10                	mov    %dl,(%eax)
    }
}
c01058b8:	5d                   	pop    %ebp
c01058b9:	c3                   	ret    

c01058ba <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c01058ba:	55                   	push   %ebp
c01058bb:	89 e5                	mov    %esp,%ebp
c01058bd:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01058c0:	8d 45 14             	lea    0x14(%ebp),%eax
c01058c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c01058c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058c9:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01058cd:	8b 45 10             	mov    0x10(%ebp),%eax
c01058d0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01058d4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058d7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058db:	8b 45 08             	mov    0x8(%ebp),%eax
c01058de:	89 04 24             	mov    %eax,(%esp)
c01058e1:	e8 08 00 00 00       	call   c01058ee <vsnprintf>
c01058e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01058e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01058ec:	c9                   	leave  
c01058ed:	c3                   	ret    

c01058ee <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c01058ee:	55                   	push   %ebp
c01058ef:	89 e5                	mov    %esp,%ebp
c01058f1:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c01058f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01058f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01058fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058fd:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105900:	8b 45 08             	mov    0x8(%ebp),%eax
c0105903:	01 d0                	add    %edx,%eax
c0105905:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105908:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c010590f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105913:	74 0a                	je     c010591f <vsnprintf+0x31>
c0105915:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105918:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010591b:	39 c2                	cmp    %eax,%edx
c010591d:	76 07                	jbe    c0105926 <vsnprintf+0x38>
        return -E_INVAL;
c010591f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105924:	eb 2a                	jmp    c0105950 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105926:	8b 45 14             	mov    0x14(%ebp),%eax
c0105929:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010592d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105930:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105934:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105937:	89 44 24 04          	mov    %eax,0x4(%esp)
c010593b:	c7 04 24 85 58 10 c0 	movl   $0xc0105885,(%esp)
c0105942:	e8 53 fb ff ff       	call   c010549a <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105947:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010594a:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c010594d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105950:	c9                   	leave  
c0105951:	c3                   	ret    

c0105952 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105952:	55                   	push   %ebp
c0105953:	89 e5                	mov    %esp,%ebp
c0105955:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105958:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c010595f:	eb 04                	jmp    c0105965 <strlen+0x13>
        cnt ++;
c0105961:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0105965:	8b 45 08             	mov    0x8(%ebp),%eax
c0105968:	8d 50 01             	lea    0x1(%eax),%edx
c010596b:	89 55 08             	mov    %edx,0x8(%ebp)
c010596e:	0f b6 00             	movzbl (%eax),%eax
c0105971:	84 c0                	test   %al,%al
c0105973:	75 ec                	jne    c0105961 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0105975:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105978:	c9                   	leave  
c0105979:	c3                   	ret    

c010597a <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c010597a:	55                   	push   %ebp
c010597b:	89 e5                	mov    %esp,%ebp
c010597d:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105980:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105987:	eb 04                	jmp    c010598d <strnlen+0x13>
        cnt ++;
c0105989:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c010598d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105990:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105993:	73 10                	jae    c01059a5 <strnlen+0x2b>
c0105995:	8b 45 08             	mov    0x8(%ebp),%eax
c0105998:	8d 50 01             	lea    0x1(%eax),%edx
c010599b:	89 55 08             	mov    %edx,0x8(%ebp)
c010599e:	0f b6 00             	movzbl (%eax),%eax
c01059a1:	84 c0                	test   %al,%al
c01059a3:	75 e4                	jne    c0105989 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c01059a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01059a8:	c9                   	leave  
c01059a9:	c3                   	ret    

c01059aa <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c01059aa:	55                   	push   %ebp
c01059ab:	89 e5                	mov    %esp,%ebp
c01059ad:	57                   	push   %edi
c01059ae:	56                   	push   %esi
c01059af:	83 ec 20             	sub    $0x20,%esp
c01059b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01059b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01059b8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c01059be:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01059c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059c4:	89 d1                	mov    %edx,%ecx
c01059c6:	89 c2                	mov    %eax,%edx
c01059c8:	89 ce                	mov    %ecx,%esi
c01059ca:	89 d7                	mov    %edx,%edi
c01059cc:	ac                   	lods   %ds:(%esi),%al
c01059cd:	aa                   	stos   %al,%es:(%edi)
c01059ce:	84 c0                	test   %al,%al
c01059d0:	75 fa                	jne    c01059cc <strcpy+0x22>
c01059d2:	89 fa                	mov    %edi,%edx
c01059d4:	89 f1                	mov    %esi,%ecx
c01059d6:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01059d9:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01059dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c01059df:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c01059e2:	83 c4 20             	add    $0x20,%esp
c01059e5:	5e                   	pop    %esi
c01059e6:	5f                   	pop    %edi
c01059e7:	5d                   	pop    %ebp
c01059e8:	c3                   	ret    

c01059e9 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c01059e9:	55                   	push   %ebp
c01059ea:	89 e5                	mov    %esp,%ebp
c01059ec:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c01059ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01059f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c01059f5:	eb 21                	jmp    c0105a18 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c01059f7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059fa:	0f b6 10             	movzbl (%eax),%edx
c01059fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105a00:	88 10                	mov    %dl,(%eax)
c0105a02:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105a05:	0f b6 00             	movzbl (%eax),%eax
c0105a08:	84 c0                	test   %al,%al
c0105a0a:	74 04                	je     c0105a10 <strncpy+0x27>
            src ++;
c0105a0c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105a10:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105a14:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0105a18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105a1c:	75 d9                	jne    c01059f7 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105a1e:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105a21:	c9                   	leave  
c0105a22:	c3                   	ret    

c0105a23 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105a23:	55                   	push   %ebp
c0105a24:	89 e5                	mov    %esp,%ebp
c0105a26:	57                   	push   %edi
c0105a27:	56                   	push   %esi
c0105a28:	83 ec 20             	sub    $0x20,%esp
c0105a2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105a31:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a34:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0105a37:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a3d:	89 d1                	mov    %edx,%ecx
c0105a3f:	89 c2                	mov    %eax,%edx
c0105a41:	89 ce                	mov    %ecx,%esi
c0105a43:	89 d7                	mov    %edx,%edi
c0105a45:	ac                   	lods   %ds:(%esi),%al
c0105a46:	ae                   	scas   %es:(%edi),%al
c0105a47:	75 08                	jne    c0105a51 <strcmp+0x2e>
c0105a49:	84 c0                	test   %al,%al
c0105a4b:	75 f8                	jne    c0105a45 <strcmp+0x22>
c0105a4d:	31 c0                	xor    %eax,%eax
c0105a4f:	eb 04                	jmp    c0105a55 <strcmp+0x32>
c0105a51:	19 c0                	sbb    %eax,%eax
c0105a53:	0c 01                	or     $0x1,%al
c0105a55:	89 fa                	mov    %edi,%edx
c0105a57:	89 f1                	mov    %esi,%ecx
c0105a59:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105a5c:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105a5f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105a62:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105a65:	83 c4 20             	add    $0x20,%esp
c0105a68:	5e                   	pop    %esi
c0105a69:	5f                   	pop    %edi
c0105a6a:	5d                   	pop    %ebp
c0105a6b:	c3                   	ret    

c0105a6c <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105a6c:	55                   	push   %ebp
c0105a6d:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105a6f:	eb 0c                	jmp    c0105a7d <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105a71:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105a75:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105a79:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105a7d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105a81:	74 1a                	je     c0105a9d <strncmp+0x31>
c0105a83:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a86:	0f b6 00             	movzbl (%eax),%eax
c0105a89:	84 c0                	test   %al,%al
c0105a8b:	74 10                	je     c0105a9d <strncmp+0x31>
c0105a8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a90:	0f b6 10             	movzbl (%eax),%edx
c0105a93:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a96:	0f b6 00             	movzbl (%eax),%eax
c0105a99:	38 c2                	cmp    %al,%dl
c0105a9b:	74 d4                	je     c0105a71 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105a9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105aa1:	74 18                	je     c0105abb <strncmp+0x4f>
c0105aa3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aa6:	0f b6 00             	movzbl (%eax),%eax
c0105aa9:	0f b6 d0             	movzbl %al,%edx
c0105aac:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105aaf:	0f b6 00             	movzbl (%eax),%eax
c0105ab2:	0f b6 c0             	movzbl %al,%eax
c0105ab5:	29 c2                	sub    %eax,%edx
c0105ab7:	89 d0                	mov    %edx,%eax
c0105ab9:	eb 05                	jmp    c0105ac0 <strncmp+0x54>
c0105abb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105ac0:	5d                   	pop    %ebp
c0105ac1:	c3                   	ret    

c0105ac2 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105ac2:	55                   	push   %ebp
c0105ac3:	89 e5                	mov    %esp,%ebp
c0105ac5:	83 ec 04             	sub    $0x4,%esp
c0105ac8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105acb:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105ace:	eb 14                	jmp    c0105ae4 <strchr+0x22>
        if (*s == c) {
c0105ad0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ad3:	0f b6 00             	movzbl (%eax),%eax
c0105ad6:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105ad9:	75 05                	jne    c0105ae0 <strchr+0x1e>
            return (char *)s;
c0105adb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ade:	eb 13                	jmp    c0105af3 <strchr+0x31>
        }
        s ++;
c0105ae0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105ae4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ae7:	0f b6 00             	movzbl (%eax),%eax
c0105aea:	84 c0                	test   %al,%al
c0105aec:	75 e2                	jne    c0105ad0 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105aee:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105af3:	c9                   	leave  
c0105af4:	c3                   	ret    

c0105af5 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105af5:	55                   	push   %ebp
c0105af6:	89 e5                	mov    %esp,%ebp
c0105af8:	83 ec 04             	sub    $0x4,%esp
c0105afb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105afe:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105b01:	eb 11                	jmp    c0105b14 <strfind+0x1f>
        if (*s == c) {
c0105b03:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b06:	0f b6 00             	movzbl (%eax),%eax
c0105b09:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105b0c:	75 02                	jne    c0105b10 <strfind+0x1b>
            break;
c0105b0e:	eb 0e                	jmp    c0105b1e <strfind+0x29>
        }
        s ++;
c0105b10:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105b14:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b17:	0f b6 00             	movzbl (%eax),%eax
c0105b1a:	84 c0                	test   %al,%al
c0105b1c:	75 e5                	jne    c0105b03 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0105b1e:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105b21:	c9                   	leave  
c0105b22:	c3                   	ret    

c0105b23 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105b23:	55                   	push   %ebp
c0105b24:	89 e5                	mov    %esp,%ebp
c0105b26:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105b29:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105b30:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105b37:	eb 04                	jmp    c0105b3d <strtol+0x1a>
        s ++;
c0105b39:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105b3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b40:	0f b6 00             	movzbl (%eax),%eax
c0105b43:	3c 20                	cmp    $0x20,%al
c0105b45:	74 f2                	je     c0105b39 <strtol+0x16>
c0105b47:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b4a:	0f b6 00             	movzbl (%eax),%eax
c0105b4d:	3c 09                	cmp    $0x9,%al
c0105b4f:	74 e8                	je     c0105b39 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105b51:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b54:	0f b6 00             	movzbl (%eax),%eax
c0105b57:	3c 2b                	cmp    $0x2b,%al
c0105b59:	75 06                	jne    c0105b61 <strtol+0x3e>
        s ++;
c0105b5b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105b5f:	eb 15                	jmp    c0105b76 <strtol+0x53>
    }
    else if (*s == '-') {
c0105b61:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b64:	0f b6 00             	movzbl (%eax),%eax
c0105b67:	3c 2d                	cmp    $0x2d,%al
c0105b69:	75 0b                	jne    c0105b76 <strtol+0x53>
        s ++, neg = 1;
c0105b6b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105b6f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105b76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b7a:	74 06                	je     c0105b82 <strtol+0x5f>
c0105b7c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105b80:	75 24                	jne    c0105ba6 <strtol+0x83>
c0105b82:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b85:	0f b6 00             	movzbl (%eax),%eax
c0105b88:	3c 30                	cmp    $0x30,%al
c0105b8a:	75 1a                	jne    c0105ba6 <strtol+0x83>
c0105b8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b8f:	83 c0 01             	add    $0x1,%eax
c0105b92:	0f b6 00             	movzbl (%eax),%eax
c0105b95:	3c 78                	cmp    $0x78,%al
c0105b97:	75 0d                	jne    c0105ba6 <strtol+0x83>
        s += 2, base = 16;
c0105b99:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105b9d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105ba4:	eb 2a                	jmp    c0105bd0 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105ba6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105baa:	75 17                	jne    c0105bc3 <strtol+0xa0>
c0105bac:	8b 45 08             	mov    0x8(%ebp),%eax
c0105baf:	0f b6 00             	movzbl (%eax),%eax
c0105bb2:	3c 30                	cmp    $0x30,%al
c0105bb4:	75 0d                	jne    c0105bc3 <strtol+0xa0>
        s ++, base = 8;
c0105bb6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105bba:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105bc1:	eb 0d                	jmp    c0105bd0 <strtol+0xad>
    }
    else if (base == 0) {
c0105bc3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105bc7:	75 07                	jne    c0105bd0 <strtol+0xad>
        base = 10;
c0105bc9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105bd0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bd3:	0f b6 00             	movzbl (%eax),%eax
c0105bd6:	3c 2f                	cmp    $0x2f,%al
c0105bd8:	7e 1b                	jle    c0105bf5 <strtol+0xd2>
c0105bda:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bdd:	0f b6 00             	movzbl (%eax),%eax
c0105be0:	3c 39                	cmp    $0x39,%al
c0105be2:	7f 11                	jg     c0105bf5 <strtol+0xd2>
            dig = *s - '0';
c0105be4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105be7:	0f b6 00             	movzbl (%eax),%eax
c0105bea:	0f be c0             	movsbl %al,%eax
c0105bed:	83 e8 30             	sub    $0x30,%eax
c0105bf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105bf3:	eb 48                	jmp    c0105c3d <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105bf5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bf8:	0f b6 00             	movzbl (%eax),%eax
c0105bfb:	3c 60                	cmp    $0x60,%al
c0105bfd:	7e 1b                	jle    c0105c1a <strtol+0xf7>
c0105bff:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c02:	0f b6 00             	movzbl (%eax),%eax
c0105c05:	3c 7a                	cmp    $0x7a,%al
c0105c07:	7f 11                	jg     c0105c1a <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105c09:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c0c:	0f b6 00             	movzbl (%eax),%eax
c0105c0f:	0f be c0             	movsbl %al,%eax
c0105c12:	83 e8 57             	sub    $0x57,%eax
c0105c15:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105c18:	eb 23                	jmp    c0105c3d <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105c1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c1d:	0f b6 00             	movzbl (%eax),%eax
c0105c20:	3c 40                	cmp    $0x40,%al
c0105c22:	7e 3d                	jle    c0105c61 <strtol+0x13e>
c0105c24:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c27:	0f b6 00             	movzbl (%eax),%eax
c0105c2a:	3c 5a                	cmp    $0x5a,%al
c0105c2c:	7f 33                	jg     c0105c61 <strtol+0x13e>
            dig = *s - 'A' + 10;
c0105c2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c31:	0f b6 00             	movzbl (%eax),%eax
c0105c34:	0f be c0             	movsbl %al,%eax
c0105c37:	83 e8 37             	sub    $0x37,%eax
c0105c3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c40:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105c43:	7c 02                	jl     c0105c47 <strtol+0x124>
            break;
c0105c45:	eb 1a                	jmp    c0105c61 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0105c47:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105c4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105c4e:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105c52:	89 c2                	mov    %eax,%edx
c0105c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c57:	01 d0                	add    %edx,%eax
c0105c59:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0105c5c:	e9 6f ff ff ff       	jmp    c0105bd0 <strtol+0xad>

    if (endptr) {
c0105c61:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105c65:	74 08                	je     c0105c6f <strtol+0x14c>
        *endptr = (char *) s;
c0105c67:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c6a:	8b 55 08             	mov    0x8(%ebp),%edx
c0105c6d:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105c6f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105c73:	74 07                	je     c0105c7c <strtol+0x159>
c0105c75:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105c78:	f7 d8                	neg    %eax
c0105c7a:	eb 03                	jmp    c0105c7f <strtol+0x15c>
c0105c7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105c7f:	c9                   	leave  
c0105c80:	c3                   	ret    

c0105c81 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105c81:	55                   	push   %ebp
c0105c82:	89 e5                	mov    %esp,%ebp
c0105c84:	57                   	push   %edi
c0105c85:	83 ec 24             	sub    $0x24,%esp
c0105c88:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c8b:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105c8e:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105c92:	8b 55 08             	mov    0x8(%ebp),%edx
c0105c95:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105c98:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105c9b:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105ca1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105ca4:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105ca8:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105cab:	89 d7                	mov    %edx,%edi
c0105cad:	f3 aa                	rep stos %al,%es:(%edi)
c0105caf:	89 fa                	mov    %edi,%edx
c0105cb1:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105cb4:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105cb7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105cba:	83 c4 24             	add    $0x24,%esp
c0105cbd:	5f                   	pop    %edi
c0105cbe:	5d                   	pop    %ebp
c0105cbf:	c3                   	ret    

c0105cc0 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105cc0:	55                   	push   %ebp
c0105cc1:	89 e5                	mov    %esp,%ebp
c0105cc3:	57                   	push   %edi
c0105cc4:	56                   	push   %esi
c0105cc5:	53                   	push   %ebx
c0105cc6:	83 ec 30             	sub    $0x30,%esp
c0105cc9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ccc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ccf:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cd2:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105cd5:	8b 45 10             	mov    0x10(%ebp),%eax
c0105cd8:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105cdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105cde:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105ce1:	73 42                	jae    c0105d25 <memmove+0x65>
c0105ce3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ce6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105ce9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105cec:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105cef:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105cf2:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105cf5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105cf8:	c1 e8 02             	shr    $0x2,%eax
c0105cfb:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105cfd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105d00:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105d03:	89 d7                	mov    %edx,%edi
c0105d05:	89 c6                	mov    %eax,%esi
c0105d07:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105d09:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105d0c:	83 e1 03             	and    $0x3,%ecx
c0105d0f:	74 02                	je     c0105d13 <memmove+0x53>
c0105d11:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105d13:	89 f0                	mov    %esi,%eax
c0105d15:	89 fa                	mov    %edi,%edx
c0105d17:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105d1a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105d1d:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105d20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105d23:	eb 36                	jmp    c0105d5b <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105d25:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105d28:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105d2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d2e:	01 c2                	add    %eax,%edx
c0105d30:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105d33:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105d36:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d39:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0105d3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105d3f:	89 c1                	mov    %eax,%ecx
c0105d41:	89 d8                	mov    %ebx,%eax
c0105d43:	89 d6                	mov    %edx,%esi
c0105d45:	89 c7                	mov    %eax,%edi
c0105d47:	fd                   	std    
c0105d48:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105d4a:	fc                   	cld    
c0105d4b:	89 f8                	mov    %edi,%eax
c0105d4d:	89 f2                	mov    %esi,%edx
c0105d4f:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105d52:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105d55:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0105d58:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105d5b:	83 c4 30             	add    $0x30,%esp
c0105d5e:	5b                   	pop    %ebx
c0105d5f:	5e                   	pop    %esi
c0105d60:	5f                   	pop    %edi
c0105d61:	5d                   	pop    %ebp
c0105d62:	c3                   	ret    

c0105d63 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105d63:	55                   	push   %ebp
c0105d64:	89 e5                	mov    %esp,%ebp
c0105d66:	57                   	push   %edi
c0105d67:	56                   	push   %esi
c0105d68:	83 ec 20             	sub    $0x20,%esp
c0105d6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d71:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d74:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d77:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105d7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d80:	c1 e8 02             	shr    $0x2,%eax
c0105d83:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105d85:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105d88:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d8b:	89 d7                	mov    %edx,%edi
c0105d8d:	89 c6                	mov    %eax,%esi
c0105d8f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105d91:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105d94:	83 e1 03             	and    $0x3,%ecx
c0105d97:	74 02                	je     c0105d9b <memcpy+0x38>
c0105d99:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105d9b:	89 f0                	mov    %esi,%eax
c0105d9d:	89 fa                	mov    %edi,%edx
c0105d9f:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105da2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105da5:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105dab:	83 c4 20             	add    $0x20,%esp
c0105dae:	5e                   	pop    %esi
c0105daf:	5f                   	pop    %edi
c0105db0:	5d                   	pop    %ebp
c0105db1:	c3                   	ret    

c0105db2 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105db2:	55                   	push   %ebp
c0105db3:	89 e5                	mov    %esp,%ebp
c0105db5:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105db8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dbb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105dbe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105dc1:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105dc4:	eb 30                	jmp    c0105df6 <memcmp+0x44>
        if (*s1 != *s2) {
c0105dc6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105dc9:	0f b6 10             	movzbl (%eax),%edx
c0105dcc:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105dcf:	0f b6 00             	movzbl (%eax),%eax
c0105dd2:	38 c2                	cmp    %al,%dl
c0105dd4:	74 18                	je     c0105dee <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105dd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105dd9:	0f b6 00             	movzbl (%eax),%eax
c0105ddc:	0f b6 d0             	movzbl %al,%edx
c0105ddf:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105de2:	0f b6 00             	movzbl (%eax),%eax
c0105de5:	0f b6 c0             	movzbl %al,%eax
c0105de8:	29 c2                	sub    %eax,%edx
c0105dea:	89 d0                	mov    %edx,%eax
c0105dec:	eb 1a                	jmp    c0105e08 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0105dee:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105df2:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0105df6:	8b 45 10             	mov    0x10(%ebp),%eax
c0105df9:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105dfc:	89 55 10             	mov    %edx,0x10(%ebp)
c0105dff:	85 c0                	test   %eax,%eax
c0105e01:	75 c3                	jne    c0105dc6 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0105e03:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105e08:	c9                   	leave  
c0105e09:	c3                   	ret    
