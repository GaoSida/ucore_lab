
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
c0100051:	e8 17 5d 00 00       	call   c0105d6d <memset>

    cons_init();                // init the console
c0100056:	e8 71 15 00 00       	call   c01015cc <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 00 5f 10 c0 	movl   $0xc0105f00,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 1c 5f 10 c0 	movl   $0xc0105f1c,(%esp)
c0100070:	e8 c7 02 00 00       	call   c010033c <cprintf>

    print_kerninfo();
c0100075:	e8 f6 07 00 00       	call   c0100870 <print_kerninfo>

    grade_backtrace();
c010007a:	e8 86 00 00 00       	call   c0100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 0a 42 00 00       	call   c010428e <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 ac 16 00 00       	call   c0101735 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 24 18 00 00       	call   c01018b2 <idt_init>

    clock_init();               // init clock interrupt
c010008e:	e8 ef 0c 00 00       	call   c0100d82 <clock_init>
    intr_enable();              // enable irq interrupt
c0100093:	e8 0b 16 00 00       	call   c01016a3 <intr_enable>
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
c01000b7:	e8 f8 0b 00 00       	call   c0100cb4 <mon_backtrace>
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
c0100155:	c7 04 24 21 5f 10 c0 	movl   $0xc0105f21,(%esp)
c010015c:	e8 db 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100165:	0f b7 d0             	movzwl %ax,%edx
c0100168:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010016d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100171:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100175:	c7 04 24 2f 5f 10 c0 	movl   $0xc0105f2f,(%esp)
c010017c:	e8 bb 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100185:	0f b7 d0             	movzwl %ax,%edx
c0100188:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010018d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100191:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100195:	c7 04 24 3d 5f 10 c0 	movl   $0xc0105f3d,(%esp)
c010019c:	e8 9b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001a5:	0f b7 d0             	movzwl %ax,%edx
c01001a8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b5:	c7 04 24 4b 5f 10 c0 	movl   $0xc0105f4b,(%esp)
c01001bc:	e8 7b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001c5:	0f b7 d0             	movzwl %ax,%edx
c01001c8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d5:	c7 04 24 59 5f 10 c0 	movl   $0xc0105f59,(%esp)
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
c0100205:	c7 04 24 68 5f 10 c0 	movl   $0xc0105f68,(%esp)
c010020c:	e8 2b 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_user();
c0100211:	e8 da ff ff ff       	call   c01001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100216:	e8 0f ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010021b:	c7 04 24 88 5f 10 c0 	movl   $0xc0105f88,(%esp)
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
c0100246:	c7 04 24 a7 5f 10 c0 	movl   $0xc0105fa7,(%esp)
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
c01002f5:	e8 fe 12 00 00       	call   c01015f8 <cons_putc>
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
c0100332:	e8 4f 52 00 00       	call   c0105586 <vprintfmt>
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
c010036e:	e8 85 12 00 00       	call   c01015f8 <cons_putc>
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
c01003ca:	e8 65 12 00 00       	call   c0101634 <cons_getc>
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
c010053c:	c7 00 ac 5f 10 c0    	movl   $0xc0105fac,(%eax)
    info->eip_line = 0;
c0100542:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010054c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054f:	c7 40 08 ac 5f 10 c0 	movl   $0xc0105fac,0x8(%eax)
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
c0100573:	c7 45 f4 10 72 10 c0 	movl   $0xc0107210,-0xc(%ebp)
    stab_end = __STAB_END__;
c010057a:	c7 45 f0 30 1e 11 c0 	movl   $0xc0111e30,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100581:	c7 45 ec 31 1e 11 c0 	movl   $0xc0111e31,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100588:	c7 45 e8 82 48 11 c0 	movl   $0xc0114882,-0x18(%ebp)

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
c01006e7:	e8 f5 54 00 00       	call   c0105be1 <strfind>
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
c0100876:	c7 04 24 b6 5f 10 c0 	movl   $0xc0105fb6,(%esp)
c010087d:	e8 ba fa ff ff       	call   c010033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100882:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100889:	c0 
c010088a:	c7 04 24 cf 5f 10 c0 	movl   $0xc0105fcf,(%esp)
c0100891:	e8 a6 fa ff ff       	call   c010033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100896:	c7 44 24 04 f6 5e 10 	movl   $0xc0105ef6,0x4(%esp)
c010089d:	c0 
c010089e:	c7 04 24 e7 5f 10 c0 	movl   $0xc0105fe7,(%esp)
c01008a5:	e8 92 fa ff ff       	call   c010033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008aa:	c7 44 24 04 36 7a 11 	movl   $0xc0117a36,0x4(%esp)
c01008b1:	c0 
c01008b2:	c7 04 24 ff 5f 10 c0 	movl   $0xc0105fff,(%esp)
c01008b9:	e8 7e fa ff ff       	call   c010033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008be:	c7 44 24 04 68 89 11 	movl   $0xc0118968,0x4(%esp)
c01008c5:	c0 
c01008c6:	c7 04 24 17 60 10 c0 	movl   $0xc0106017,(%esp)
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
c01008f8:	c7 04 24 30 60 10 c0 	movl   $0xc0106030,(%esp)
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
c010092c:	c7 04 24 5a 60 10 c0 	movl   $0xc010605a,(%esp)
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
c010099b:	c7 04 24 76 60 10 c0 	movl   $0xc0106076,(%esp)
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
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
c01009c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01009cb:	e8 d9 ff ff ff       	call   c01009a9 <read_eip>
c01009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c01009d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009da:	e9 88 00 00 00       	jmp    c0100a67 <print_stackframe+0xad>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c01009df:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009e2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009e9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009ed:	c7 04 24 88 60 10 c0 	movl   $0xc0106088,(%esp)
c01009f4:	e8 43 f9 ff ff       	call   c010033c <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
c01009f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009fc:	83 c0 08             	add    $0x8,%eax
c01009ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
c0100a02:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a09:	eb 25                	jmp    c0100a30 <print_stackframe+0x76>
            cprintf("0x%08x ", args[j]);
c0100a0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a0e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a18:	01 d0                	add    %edx,%eax
c0100a1a:	8b 00                	mov    (%eax),%eax
c0100a1c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a20:	c7 04 24 a4 60 10 c0 	movl   $0xc01060a4,(%esp)
c0100a27:	e8 10 f9 ff ff       	call   c010033c <cprintf>

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
        uint32_t *args = (uint32_t *)ebp + 2;
        for (j = 0; j < 4; j ++) {
c0100a2c:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a30:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a34:	7e d5                	jle    c0100a0b <print_stackframe+0x51>
            cprintf("0x%08x ", args[j]);
        }
        cprintf("\n");
c0100a36:	c7 04 24 ac 60 10 c0 	movl   $0xc01060ac,(%esp)
c0100a3d:	e8 fa f8 ff ff       	call   c010033c <cprintf>
        print_debuginfo(eip - 1);
c0100a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a45:	83 e8 01             	sub    $0x1,%eax
c0100a48:	89 04 24             	mov    %eax,(%esp)
c0100a4b:	e8 b6 fe ff ff       	call   c0100906 <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
c0100a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a53:	83 c0 04             	add    $0x4,%eax
c0100a56:	8b 00                	mov    (%eax),%eax
c0100a58:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a5e:	8b 00                	mov    (%eax),%eax
c0100a60:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100a63:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a6b:	74 0a                	je     c0100a77 <print_stackframe+0xbd>
c0100a6d:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a71:	0f 8e 68 ff ff ff    	jle    c01009df <print_stackframe+0x25>
        cprintf("\n");
        print_debuginfo(eip - 1);
        eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
    }
}
c0100a77:	c9                   	leave  
c0100a78:	c3                   	ret    

c0100a79 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a79:	55                   	push   %ebp
c0100a7a:	89 e5                	mov    %esp,%ebp
c0100a7c:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a86:	eb 0c                	jmp    c0100a94 <parse+0x1b>
            *buf ++ = '\0';
c0100a88:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a8b:	8d 50 01             	lea    0x1(%eax),%edx
c0100a8e:	89 55 08             	mov    %edx,0x8(%ebp)
c0100a91:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a94:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a97:	0f b6 00             	movzbl (%eax),%eax
c0100a9a:	84 c0                	test   %al,%al
c0100a9c:	74 1d                	je     c0100abb <parse+0x42>
c0100a9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa1:	0f b6 00             	movzbl (%eax),%eax
c0100aa4:	0f be c0             	movsbl %al,%eax
c0100aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100aab:	c7 04 24 30 61 10 c0 	movl   $0xc0106130,(%esp)
c0100ab2:	e8 f7 50 00 00       	call   c0105bae <strchr>
c0100ab7:	85 c0                	test   %eax,%eax
c0100ab9:	75 cd                	jne    c0100a88 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100abb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100abe:	0f b6 00             	movzbl (%eax),%eax
c0100ac1:	84 c0                	test   %al,%al
c0100ac3:	75 02                	jne    c0100ac7 <parse+0x4e>
            break;
c0100ac5:	eb 67                	jmp    c0100b2e <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ac7:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100acb:	75 14                	jne    c0100ae1 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100acd:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100ad4:	00 
c0100ad5:	c7 04 24 35 61 10 c0 	movl   $0xc0106135,(%esp)
c0100adc:	e8 5b f8 ff ff       	call   c010033c <cprintf>
        }
        argv[argc ++] = buf;
c0100ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ae4:	8d 50 01             	lea    0x1(%eax),%edx
c0100ae7:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100aea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100af1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100af4:	01 c2                	add    %eax,%edx
c0100af6:	8b 45 08             	mov    0x8(%ebp),%eax
c0100af9:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100afb:	eb 04                	jmp    c0100b01 <parse+0x88>
            buf ++;
c0100afd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b01:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b04:	0f b6 00             	movzbl (%eax),%eax
c0100b07:	84 c0                	test   %al,%al
c0100b09:	74 1d                	je     c0100b28 <parse+0xaf>
c0100b0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b0e:	0f b6 00             	movzbl (%eax),%eax
c0100b11:	0f be c0             	movsbl %al,%eax
c0100b14:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b18:	c7 04 24 30 61 10 c0 	movl   $0xc0106130,(%esp)
c0100b1f:	e8 8a 50 00 00       	call   c0105bae <strchr>
c0100b24:	85 c0                	test   %eax,%eax
c0100b26:	74 d5                	je     c0100afd <parse+0x84>
            buf ++;
        }
    }
c0100b28:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b29:	e9 66 ff ff ff       	jmp    c0100a94 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b31:	c9                   	leave  
c0100b32:	c3                   	ret    

c0100b33 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b33:	55                   	push   %ebp
c0100b34:	89 e5                	mov    %esp,%ebp
c0100b36:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b39:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b3c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b40:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b43:	89 04 24             	mov    %eax,(%esp)
c0100b46:	e8 2e ff ff ff       	call   c0100a79 <parse>
c0100b4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b4e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b52:	75 0a                	jne    c0100b5e <runcmd+0x2b>
        return 0;
c0100b54:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b59:	e9 85 00 00 00       	jmp    c0100be3 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b65:	eb 5c                	jmp    c0100bc3 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b67:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b6d:	89 d0                	mov    %edx,%eax
c0100b6f:	01 c0                	add    %eax,%eax
c0100b71:	01 d0                	add    %edx,%eax
c0100b73:	c1 e0 02             	shl    $0x2,%eax
c0100b76:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100b7b:	8b 00                	mov    (%eax),%eax
c0100b7d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b81:	89 04 24             	mov    %eax,(%esp)
c0100b84:	e8 86 4f 00 00       	call   c0105b0f <strcmp>
c0100b89:	85 c0                	test   %eax,%eax
c0100b8b:	75 32                	jne    c0100bbf <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b90:	89 d0                	mov    %edx,%eax
c0100b92:	01 c0                	add    %eax,%eax
c0100b94:	01 d0                	add    %edx,%eax
c0100b96:	c1 e0 02             	shl    $0x2,%eax
c0100b99:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100b9e:	8b 40 08             	mov    0x8(%eax),%eax
c0100ba1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100ba4:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100ba7:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100baa:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bae:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bb1:	83 c2 04             	add    $0x4,%edx
c0100bb4:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bb8:	89 0c 24             	mov    %ecx,(%esp)
c0100bbb:	ff d0                	call   *%eax
c0100bbd:	eb 24                	jmp    c0100be3 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bbf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bc6:	83 f8 02             	cmp    $0x2,%eax
c0100bc9:	76 9c                	jbe    c0100b67 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bcb:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bce:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bd2:	c7 04 24 53 61 10 c0 	movl   $0xc0106153,(%esp)
c0100bd9:	e8 5e f7 ff ff       	call   c010033c <cprintf>
    return 0;
c0100bde:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100be3:	c9                   	leave  
c0100be4:	c3                   	ret    

c0100be5 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100be5:	55                   	push   %ebp
c0100be6:	89 e5                	mov    %esp,%ebp
c0100be8:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100beb:	c7 04 24 6c 61 10 c0 	movl   $0xc010616c,(%esp)
c0100bf2:	e8 45 f7 ff ff       	call   c010033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100bf7:	c7 04 24 94 61 10 c0 	movl   $0xc0106194,(%esp)
c0100bfe:	e8 39 f7 ff ff       	call   c010033c <cprintf>

    if (tf != NULL) {
c0100c03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c07:	74 0b                	je     c0100c14 <kmonitor+0x2f>
        print_trapframe(tf);
c0100c09:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c0c:	89 04 24             	mov    %eax,(%esp)
c0100c0f:	e8 d7 0d 00 00       	call   c01019eb <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c14:	c7 04 24 b9 61 10 c0 	movl   $0xc01061b9,(%esp)
c0100c1b:	e8 13 f6 ff ff       	call   c0100233 <readline>
c0100c20:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c27:	74 18                	je     c0100c41 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c29:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c2c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c33:	89 04 24             	mov    %eax,(%esp)
c0100c36:	e8 f8 fe ff ff       	call   c0100b33 <runcmd>
c0100c3b:	85 c0                	test   %eax,%eax
c0100c3d:	79 02                	jns    c0100c41 <kmonitor+0x5c>
                break;
c0100c3f:	eb 02                	jmp    c0100c43 <kmonitor+0x5e>
            }
        }
    }
c0100c41:	eb d1                	jmp    c0100c14 <kmonitor+0x2f>
}
c0100c43:	c9                   	leave  
c0100c44:	c3                   	ret    

c0100c45 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c45:	55                   	push   %ebp
c0100c46:	89 e5                	mov    %esp,%ebp
c0100c48:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c52:	eb 3f                	jmp    c0100c93 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c54:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c57:	89 d0                	mov    %edx,%eax
c0100c59:	01 c0                	add    %eax,%eax
c0100c5b:	01 d0                	add    %edx,%eax
c0100c5d:	c1 e0 02             	shl    $0x2,%eax
c0100c60:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c65:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c68:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c6b:	89 d0                	mov    %edx,%eax
c0100c6d:	01 c0                	add    %eax,%eax
c0100c6f:	01 d0                	add    %edx,%eax
c0100c71:	c1 e0 02             	shl    $0x2,%eax
c0100c74:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c79:	8b 00                	mov    (%eax),%eax
c0100c7b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c7f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c83:	c7 04 24 bd 61 10 c0 	movl   $0xc01061bd,(%esp)
c0100c8a:	e8 ad f6 ff ff       	call   c010033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c8f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c96:	83 f8 02             	cmp    $0x2,%eax
c0100c99:	76 b9                	jbe    c0100c54 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100c9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ca0:	c9                   	leave  
c0100ca1:	c3                   	ret    

c0100ca2 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100ca2:	55                   	push   %ebp
c0100ca3:	89 e5                	mov    %esp,%ebp
c0100ca5:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100ca8:	e8 c3 fb ff ff       	call   c0100870 <print_kerninfo>
    return 0;
c0100cad:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cb2:	c9                   	leave  
c0100cb3:	c3                   	ret    

c0100cb4 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cb4:	55                   	push   %ebp
c0100cb5:	89 e5                	mov    %esp,%ebp
c0100cb7:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cba:	e8 fb fc ff ff       	call   c01009ba <print_stackframe>
    return 0;
c0100cbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cc4:	c9                   	leave  
c0100cc5:	c3                   	ret    

c0100cc6 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cc6:	55                   	push   %ebp
c0100cc7:	89 e5                	mov    %esp,%ebp
c0100cc9:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100ccc:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
c0100cd1:	85 c0                	test   %eax,%eax
c0100cd3:	74 02                	je     c0100cd7 <__panic+0x11>
        goto panic_dead;
c0100cd5:	eb 48                	jmp    c0100d1f <__panic+0x59>
    }
    is_panic = 1;
c0100cd7:	c7 05 60 7e 11 c0 01 	movl   $0x1,0xc0117e60
c0100cde:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100ce1:	8d 45 14             	lea    0x14(%ebp),%eax
c0100ce4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100ce7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100cea:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100cee:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cf1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cf5:	c7 04 24 c6 61 10 c0 	movl   $0xc01061c6,(%esp)
c0100cfc:	e8 3b f6 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d04:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d08:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d0b:	89 04 24             	mov    %eax,(%esp)
c0100d0e:	e8 f6 f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d13:	c7 04 24 e2 61 10 c0 	movl   $0xc01061e2,(%esp)
c0100d1a:	e8 1d f6 ff ff       	call   c010033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d1f:	e8 85 09 00 00       	call   c01016a9 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d24:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d2b:	e8 b5 fe ff ff       	call   c0100be5 <kmonitor>
    }
c0100d30:	eb f2                	jmp    c0100d24 <__panic+0x5e>

c0100d32 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d32:	55                   	push   %ebp
c0100d33:	89 e5                	mov    %esp,%ebp
c0100d35:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d38:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d3e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d41:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d45:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d48:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d4c:	c7 04 24 e4 61 10 c0 	movl   $0xc01061e4,(%esp)
c0100d53:	e8 e4 f5 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d5b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d5f:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d62:	89 04 24             	mov    %eax,(%esp)
c0100d65:	e8 9f f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d6a:	c7 04 24 e2 61 10 c0 	movl   $0xc01061e2,(%esp)
c0100d71:	e8 c6 f5 ff ff       	call   c010033c <cprintf>
    va_end(ap);
}
c0100d76:	c9                   	leave  
c0100d77:	c3                   	ret    

c0100d78 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d78:	55                   	push   %ebp
c0100d79:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d7b:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
}
c0100d80:	5d                   	pop    %ebp
c0100d81:	c3                   	ret    

c0100d82 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d82:	55                   	push   %ebp
c0100d83:	89 e5                	mov    %esp,%ebp
c0100d85:	83 ec 28             	sub    $0x28,%esp
c0100d88:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d8e:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d92:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100d96:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100d9a:	ee                   	out    %al,(%dx)
c0100d9b:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100da1:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100da5:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100da9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dad:	ee                   	out    %al,(%dx)
c0100dae:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100db4:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100db8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dbc:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dc0:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dc1:	c7 05 4c 89 11 c0 00 	movl   $0x0,0xc011894c
c0100dc8:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100dcb:	c7 04 24 02 62 10 c0 	movl   $0xc0106202,(%esp)
c0100dd2:	e8 65 f5 ff ff       	call   c010033c <cprintf>
    pic_enable(IRQ_TIMER);
c0100dd7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100dde:	e8 24 09 00 00       	call   c0101707 <pic_enable>
}
c0100de3:	c9                   	leave  
c0100de4:	c3                   	ret    

c0100de5 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100de5:	55                   	push   %ebp
c0100de6:	89 e5                	mov    %esp,%ebp
c0100de8:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100deb:	9c                   	pushf  
c0100dec:	58                   	pop    %eax
c0100ded:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100df3:	25 00 02 00 00       	and    $0x200,%eax
c0100df8:	85 c0                	test   %eax,%eax
c0100dfa:	74 0c                	je     c0100e08 <__intr_save+0x23>
        intr_disable();
c0100dfc:	e8 a8 08 00 00       	call   c01016a9 <intr_disable>
        return 1;
c0100e01:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e06:	eb 05                	jmp    c0100e0d <__intr_save+0x28>
    }
    return 0;
c0100e08:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e0d:	c9                   	leave  
c0100e0e:	c3                   	ret    

c0100e0f <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e0f:	55                   	push   %ebp
c0100e10:	89 e5                	mov    %esp,%ebp
c0100e12:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e19:	74 05                	je     c0100e20 <__intr_restore+0x11>
        intr_enable();
c0100e1b:	e8 83 08 00 00       	call   c01016a3 <intr_enable>
    }
}
c0100e20:	c9                   	leave  
c0100e21:	c3                   	ret    

c0100e22 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e22:	55                   	push   %ebp
c0100e23:	89 e5                	mov    %esp,%ebp
c0100e25:	83 ec 10             	sub    $0x10,%esp
c0100e28:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e2e:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e32:	89 c2                	mov    %eax,%edx
c0100e34:	ec                   	in     (%dx),%al
c0100e35:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e38:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e3e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e42:	89 c2                	mov    %eax,%edx
c0100e44:	ec                   	in     (%dx),%al
c0100e45:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e48:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e4e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e52:	89 c2                	mov    %eax,%edx
c0100e54:	ec                   	in     (%dx),%al
c0100e55:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e58:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e5e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e62:	89 c2                	mov    %eax,%edx
c0100e64:	ec                   	in     (%dx),%al
c0100e65:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e68:	c9                   	leave  
c0100e69:	c3                   	ret    

c0100e6a <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e6a:	55                   	push   %ebp
c0100e6b:	89 e5                	mov    %esp,%ebp
c0100e6d:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e70:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e77:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e7a:	0f b7 00             	movzwl (%eax),%eax
c0100e7d:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e81:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e84:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e89:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e8c:	0f b7 00             	movzwl (%eax),%eax
c0100e8f:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100e93:	74 12                	je     c0100ea7 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e95:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100e9c:	66 c7 05 86 7e 11 c0 	movw   $0x3b4,0xc0117e86
c0100ea3:	b4 03 
c0100ea5:	eb 13                	jmp    c0100eba <cga_init+0x50>
    } else {
        *cp = was;
c0100ea7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eaa:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100eae:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100eb1:	66 c7 05 86 7e 11 c0 	movw   $0x3d4,0xc0117e86
c0100eb8:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100eba:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ec1:	0f b7 c0             	movzwl %ax,%eax
c0100ec4:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ec8:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ecc:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ed0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100ed4:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ed5:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100edc:	83 c0 01             	add    $0x1,%eax
c0100edf:	0f b7 c0             	movzwl %ax,%eax
c0100ee2:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ee6:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100eea:	89 c2                	mov    %eax,%edx
c0100eec:	ec                   	in     (%dx),%al
c0100eed:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100ef0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100ef4:	0f b6 c0             	movzbl %al,%eax
c0100ef7:	c1 e0 08             	shl    $0x8,%eax
c0100efa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100efd:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f04:	0f b7 c0             	movzwl %ax,%eax
c0100f07:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f0b:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f0f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f13:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f17:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f18:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f1f:	83 c0 01             	add    $0x1,%eax
c0100f22:	0f b7 c0             	movzwl %ax,%eax
c0100f25:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f29:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f2d:	89 c2                	mov    %eax,%edx
c0100f2f:	ec                   	in     (%dx),%al
c0100f30:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f33:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f37:	0f b6 c0             	movzbl %al,%eax
c0100f3a:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f40:	a3 80 7e 11 c0       	mov    %eax,0xc0117e80
    crt_pos = pos;
c0100f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f48:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
}
c0100f4e:	c9                   	leave  
c0100f4f:	c3                   	ret    

c0100f50 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f50:	55                   	push   %ebp
c0100f51:	89 e5                	mov    %esp,%ebp
c0100f53:	83 ec 48             	sub    $0x48,%esp
c0100f56:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f5c:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f60:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f64:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f68:	ee                   	out    %al,(%dx)
c0100f69:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f6f:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f73:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f77:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f7b:	ee                   	out    %al,(%dx)
c0100f7c:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f82:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f86:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f8a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f8e:	ee                   	out    %al,(%dx)
c0100f8f:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100f95:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100f99:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f9d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fa1:	ee                   	out    %al,(%dx)
c0100fa2:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fa8:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fac:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fb0:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fb4:	ee                   	out    %al,(%dx)
c0100fb5:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fbb:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fbf:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fc3:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fc7:	ee                   	out    %al,(%dx)
c0100fc8:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fce:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fd2:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fd6:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100fda:	ee                   	out    %al,(%dx)
c0100fdb:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fe1:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100fe5:	89 c2                	mov    %eax,%edx
c0100fe7:	ec                   	in     (%dx),%al
c0100fe8:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0100feb:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100fef:	3c ff                	cmp    $0xff,%al
c0100ff1:	0f 95 c0             	setne  %al
c0100ff4:	0f b6 c0             	movzbl %al,%eax
c0100ff7:	a3 88 7e 11 c0       	mov    %eax,0xc0117e88
c0100ffc:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101002:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0101006:	89 c2                	mov    %eax,%edx
c0101008:	ec                   	in     (%dx),%al
c0101009:	88 45 d5             	mov    %al,-0x2b(%ebp)
c010100c:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101012:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0101016:	89 c2                	mov    %eax,%edx
c0101018:	ec                   	in     (%dx),%al
c0101019:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010101c:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0101021:	85 c0                	test   %eax,%eax
c0101023:	74 0c                	je     c0101031 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0101025:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010102c:	e8 d6 06 00 00       	call   c0101707 <pic_enable>
    }
}
c0101031:	c9                   	leave  
c0101032:	c3                   	ret    

c0101033 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101033:	55                   	push   %ebp
c0101034:	89 e5                	mov    %esp,%ebp
c0101036:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101039:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101040:	eb 09                	jmp    c010104b <lpt_putc_sub+0x18>
        delay();
c0101042:	e8 db fd ff ff       	call   c0100e22 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101047:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010104b:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101051:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101055:	89 c2                	mov    %eax,%edx
c0101057:	ec                   	in     (%dx),%al
c0101058:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010105b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010105f:	84 c0                	test   %al,%al
c0101061:	78 09                	js     c010106c <lpt_putc_sub+0x39>
c0101063:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010106a:	7e d6                	jle    c0101042 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c010106c:	8b 45 08             	mov    0x8(%ebp),%eax
c010106f:	0f b6 c0             	movzbl %al,%eax
c0101072:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c0101078:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010107b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010107f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101083:	ee                   	out    %al,(%dx)
c0101084:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c010108a:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c010108e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101092:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101096:	ee                   	out    %al,(%dx)
c0101097:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c010109d:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010a1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010a5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010a9:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010aa:	c9                   	leave  
c01010ab:	c3                   	ret    

c01010ac <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010ac:	55                   	push   %ebp
c01010ad:	89 e5                	mov    %esp,%ebp
c01010af:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010b2:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010b6:	74 0d                	je     c01010c5 <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01010bb:	89 04 24             	mov    %eax,(%esp)
c01010be:	e8 70 ff ff ff       	call   c0101033 <lpt_putc_sub>
c01010c3:	eb 24                	jmp    c01010e9 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010c5:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010cc:	e8 62 ff ff ff       	call   c0101033 <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010d1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010d8:	e8 56 ff ff ff       	call   c0101033 <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010dd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010e4:	e8 4a ff ff ff       	call   c0101033 <lpt_putc_sub>
    }
}
c01010e9:	c9                   	leave  
c01010ea:	c3                   	ret    

c01010eb <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010eb:	55                   	push   %ebp
c01010ec:	89 e5                	mov    %esp,%ebp
c01010ee:	53                   	push   %ebx
c01010ef:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01010f5:	b0 00                	mov    $0x0,%al
c01010f7:	85 c0                	test   %eax,%eax
c01010f9:	75 07                	jne    c0101102 <cga_putc+0x17>
        c |= 0x0700;
c01010fb:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101102:	8b 45 08             	mov    0x8(%ebp),%eax
c0101105:	0f b6 c0             	movzbl %al,%eax
c0101108:	83 f8 0a             	cmp    $0xa,%eax
c010110b:	74 4c                	je     c0101159 <cga_putc+0x6e>
c010110d:	83 f8 0d             	cmp    $0xd,%eax
c0101110:	74 57                	je     c0101169 <cga_putc+0x7e>
c0101112:	83 f8 08             	cmp    $0x8,%eax
c0101115:	0f 85 88 00 00 00    	jne    c01011a3 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c010111b:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101122:	66 85 c0             	test   %ax,%ax
c0101125:	74 30                	je     c0101157 <cga_putc+0x6c>
            crt_pos --;
c0101127:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010112e:	83 e8 01             	sub    $0x1,%eax
c0101131:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101137:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c010113c:	0f b7 15 84 7e 11 c0 	movzwl 0xc0117e84,%edx
c0101143:	0f b7 d2             	movzwl %dx,%edx
c0101146:	01 d2                	add    %edx,%edx
c0101148:	01 c2                	add    %eax,%edx
c010114a:	8b 45 08             	mov    0x8(%ebp),%eax
c010114d:	b0 00                	mov    $0x0,%al
c010114f:	83 c8 20             	or     $0x20,%eax
c0101152:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101155:	eb 72                	jmp    c01011c9 <cga_putc+0xde>
c0101157:	eb 70                	jmp    c01011c9 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101159:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101160:	83 c0 50             	add    $0x50,%eax
c0101163:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101169:	0f b7 1d 84 7e 11 c0 	movzwl 0xc0117e84,%ebx
c0101170:	0f b7 0d 84 7e 11 c0 	movzwl 0xc0117e84,%ecx
c0101177:	0f b7 c1             	movzwl %cx,%eax
c010117a:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101180:	c1 e8 10             	shr    $0x10,%eax
c0101183:	89 c2                	mov    %eax,%edx
c0101185:	66 c1 ea 06          	shr    $0x6,%dx
c0101189:	89 d0                	mov    %edx,%eax
c010118b:	c1 e0 02             	shl    $0x2,%eax
c010118e:	01 d0                	add    %edx,%eax
c0101190:	c1 e0 04             	shl    $0x4,%eax
c0101193:	29 c1                	sub    %eax,%ecx
c0101195:	89 ca                	mov    %ecx,%edx
c0101197:	89 d8                	mov    %ebx,%eax
c0101199:	29 d0                	sub    %edx,%eax
c010119b:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
        break;
c01011a1:	eb 26                	jmp    c01011c9 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011a3:	8b 0d 80 7e 11 c0    	mov    0xc0117e80,%ecx
c01011a9:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011b0:	8d 50 01             	lea    0x1(%eax),%edx
c01011b3:	66 89 15 84 7e 11 c0 	mov    %dx,0xc0117e84
c01011ba:	0f b7 c0             	movzwl %ax,%eax
c01011bd:	01 c0                	add    %eax,%eax
c01011bf:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01011c5:	66 89 02             	mov    %ax,(%edx)
        break;
c01011c8:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011c9:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011d0:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011d4:	76 5b                	jbe    c0101231 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011d6:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011db:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011e1:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011e6:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01011ed:	00 
c01011ee:	89 54 24 04          	mov    %edx,0x4(%esp)
c01011f2:	89 04 24             	mov    %eax,(%esp)
c01011f5:	e8 b2 4b 00 00       	call   c0105dac <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01011fa:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101201:	eb 15                	jmp    c0101218 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101203:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101208:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010120b:	01 d2                	add    %edx,%edx
c010120d:	01 d0                	add    %edx,%eax
c010120f:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101214:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101218:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010121f:	7e e2                	jle    c0101203 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101221:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101228:	83 e8 50             	sub    $0x50,%eax
c010122b:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101231:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0101238:	0f b7 c0             	movzwl %ax,%eax
c010123b:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c010123f:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101243:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101247:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010124b:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c010124c:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101253:	66 c1 e8 08          	shr    $0x8,%ax
c0101257:	0f b6 c0             	movzbl %al,%eax
c010125a:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c0101261:	83 c2 01             	add    $0x1,%edx
c0101264:	0f b7 d2             	movzwl %dx,%edx
c0101267:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c010126b:	88 45 ed             	mov    %al,-0x13(%ebp)
c010126e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101272:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101276:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101277:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c010127e:	0f b7 c0             	movzwl %ax,%eax
c0101281:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0101285:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c0101289:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010128d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101291:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c0101292:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101299:	0f b6 c0             	movzbl %al,%eax
c010129c:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c01012a3:	83 c2 01             	add    $0x1,%edx
c01012a6:	0f b7 d2             	movzwl %dx,%edx
c01012a9:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012ad:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012b0:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012b4:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012b8:	ee                   	out    %al,(%dx)
}
c01012b9:	83 c4 34             	add    $0x34,%esp
c01012bc:	5b                   	pop    %ebx
c01012bd:	5d                   	pop    %ebp
c01012be:	c3                   	ret    

c01012bf <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012bf:	55                   	push   %ebp
c01012c0:	89 e5                	mov    %esp,%ebp
c01012c2:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012cc:	eb 09                	jmp    c01012d7 <serial_putc_sub+0x18>
        delay();
c01012ce:	e8 4f fb ff ff       	call   c0100e22 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012d3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012d7:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012dd:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012e1:	89 c2                	mov    %eax,%edx
c01012e3:	ec                   	in     (%dx),%al
c01012e4:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012e7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012eb:	0f b6 c0             	movzbl %al,%eax
c01012ee:	83 e0 20             	and    $0x20,%eax
c01012f1:	85 c0                	test   %eax,%eax
c01012f3:	75 09                	jne    c01012fe <serial_putc_sub+0x3f>
c01012f5:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01012fc:	7e d0                	jle    c01012ce <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c01012fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0101301:	0f b6 c0             	movzbl %al,%eax
c0101304:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c010130a:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010130d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101311:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101315:	ee                   	out    %al,(%dx)
}
c0101316:	c9                   	leave  
c0101317:	c3                   	ret    

c0101318 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101318:	55                   	push   %ebp
c0101319:	89 e5                	mov    %esp,%ebp
c010131b:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010131e:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101322:	74 0d                	je     c0101331 <serial_putc+0x19>
        serial_putc_sub(c);
c0101324:	8b 45 08             	mov    0x8(%ebp),%eax
c0101327:	89 04 24             	mov    %eax,(%esp)
c010132a:	e8 90 ff ff ff       	call   c01012bf <serial_putc_sub>
c010132f:	eb 24                	jmp    c0101355 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101331:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101338:	e8 82 ff ff ff       	call   c01012bf <serial_putc_sub>
        serial_putc_sub(' ');
c010133d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101344:	e8 76 ff ff ff       	call   c01012bf <serial_putc_sub>
        serial_putc_sub('\b');
c0101349:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101350:	e8 6a ff ff ff       	call   c01012bf <serial_putc_sub>
    }
}
c0101355:	c9                   	leave  
c0101356:	c3                   	ret    

c0101357 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101357:	55                   	push   %ebp
c0101358:	89 e5                	mov    %esp,%ebp
c010135a:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c010135d:	eb 33                	jmp    c0101392 <cons_intr+0x3b>
        if (c != 0) {
c010135f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101363:	74 2d                	je     c0101392 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101365:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c010136a:	8d 50 01             	lea    0x1(%eax),%edx
c010136d:	89 15 a4 80 11 c0    	mov    %edx,0xc01180a4
c0101373:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101376:	88 90 a0 7e 11 c0    	mov    %dl,-0x3fee8160(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c010137c:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101381:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101386:	75 0a                	jne    c0101392 <cons_intr+0x3b>
                cons.wpos = 0;
c0101388:	c7 05 a4 80 11 c0 00 	movl   $0x0,0xc01180a4
c010138f:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c0101392:	8b 45 08             	mov    0x8(%ebp),%eax
c0101395:	ff d0                	call   *%eax
c0101397:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010139a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c010139e:	75 bf                	jne    c010135f <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013a0:	c9                   	leave  
c01013a1:	c3                   	ret    

c01013a2 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013a2:	55                   	push   %ebp
c01013a3:	89 e5                	mov    %esp,%ebp
c01013a5:	83 ec 10             	sub    $0x10,%esp
c01013a8:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013ae:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013b2:	89 c2                	mov    %eax,%edx
c01013b4:	ec                   	in     (%dx),%al
c01013b5:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013b8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013bc:	0f b6 c0             	movzbl %al,%eax
c01013bf:	83 e0 01             	and    $0x1,%eax
c01013c2:	85 c0                	test   %eax,%eax
c01013c4:	75 07                	jne    c01013cd <serial_proc_data+0x2b>
        return -1;
c01013c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013cb:	eb 2a                	jmp    c01013f7 <serial_proc_data+0x55>
c01013cd:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013d3:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013d7:	89 c2                	mov    %eax,%edx
c01013d9:	ec                   	in     (%dx),%al
c01013da:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013dd:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013e1:	0f b6 c0             	movzbl %al,%eax
c01013e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013e7:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013eb:	75 07                	jne    c01013f4 <serial_proc_data+0x52>
        c = '\b';
c01013ed:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01013f7:	c9                   	leave  
c01013f8:	c3                   	ret    

c01013f9 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01013f9:	55                   	push   %ebp
c01013fa:	89 e5                	mov    %esp,%ebp
c01013fc:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c01013ff:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0101404:	85 c0                	test   %eax,%eax
c0101406:	74 0c                	je     c0101414 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101408:	c7 04 24 a2 13 10 c0 	movl   $0xc01013a2,(%esp)
c010140f:	e8 43 ff ff ff       	call   c0101357 <cons_intr>
    }
}
c0101414:	c9                   	leave  
c0101415:	c3                   	ret    

c0101416 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101416:	55                   	push   %ebp
c0101417:	89 e5                	mov    %esp,%ebp
c0101419:	83 ec 38             	sub    $0x38,%esp
c010141c:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101422:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101426:	89 c2                	mov    %eax,%edx
c0101428:	ec                   	in     (%dx),%al
c0101429:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c010142c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101430:	0f b6 c0             	movzbl %al,%eax
c0101433:	83 e0 01             	and    $0x1,%eax
c0101436:	85 c0                	test   %eax,%eax
c0101438:	75 0a                	jne    c0101444 <kbd_proc_data+0x2e>
        return -1;
c010143a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010143f:	e9 59 01 00 00       	jmp    c010159d <kbd_proc_data+0x187>
c0101444:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010144a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010144e:	89 c2                	mov    %eax,%edx
c0101450:	ec                   	in     (%dx),%al
c0101451:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101454:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101458:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c010145b:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c010145f:	75 17                	jne    c0101478 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101461:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101466:	83 c8 40             	or     $0x40,%eax
c0101469:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c010146e:	b8 00 00 00 00       	mov    $0x0,%eax
c0101473:	e9 25 01 00 00       	jmp    c010159d <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c0101478:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010147c:	84 c0                	test   %al,%al
c010147e:	79 47                	jns    c01014c7 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101480:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101485:	83 e0 40             	and    $0x40,%eax
c0101488:	85 c0                	test   %eax,%eax
c010148a:	75 09                	jne    c0101495 <kbd_proc_data+0x7f>
c010148c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101490:	83 e0 7f             	and    $0x7f,%eax
c0101493:	eb 04                	jmp    c0101499 <kbd_proc_data+0x83>
c0101495:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101499:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c010149c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a0:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014a7:	83 c8 40             	or     $0x40,%eax
c01014aa:	0f b6 c0             	movzbl %al,%eax
c01014ad:	f7 d0                	not    %eax
c01014af:	89 c2                	mov    %eax,%edx
c01014b1:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014b6:	21 d0                	and    %edx,%eax
c01014b8:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c01014bd:	b8 00 00 00 00       	mov    $0x0,%eax
c01014c2:	e9 d6 00 00 00       	jmp    c010159d <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014c7:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014cc:	83 e0 40             	and    $0x40,%eax
c01014cf:	85 c0                	test   %eax,%eax
c01014d1:	74 11                	je     c01014e4 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014d3:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014d7:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014dc:	83 e0 bf             	and    $0xffffffbf,%eax
c01014df:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    }

    shift |= shiftcode[data];
c01014e4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014e8:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014ef:	0f b6 d0             	movzbl %al,%edx
c01014f2:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014f7:	09 d0                	or     %edx,%eax
c01014f9:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    shift ^= togglecode[data];
c01014fe:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101502:	0f b6 80 60 71 11 c0 	movzbl -0x3fee8ea0(%eax),%eax
c0101509:	0f b6 d0             	movzbl %al,%edx
c010150c:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101511:	31 d0                	xor    %edx,%eax
c0101513:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8

    c = charcode[shift & (CTL | SHIFT)][data];
c0101518:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010151d:	83 e0 03             	and    $0x3,%eax
c0101520:	8b 14 85 60 75 11 c0 	mov    -0x3fee8aa0(,%eax,4),%edx
c0101527:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010152b:	01 d0                	add    %edx,%eax
c010152d:	0f b6 00             	movzbl (%eax),%eax
c0101530:	0f b6 c0             	movzbl %al,%eax
c0101533:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101536:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010153b:	83 e0 08             	and    $0x8,%eax
c010153e:	85 c0                	test   %eax,%eax
c0101540:	74 22                	je     c0101564 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101542:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101546:	7e 0c                	jle    c0101554 <kbd_proc_data+0x13e>
c0101548:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c010154c:	7f 06                	jg     c0101554 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c010154e:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101552:	eb 10                	jmp    c0101564 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101554:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101558:	7e 0a                	jle    c0101564 <kbd_proc_data+0x14e>
c010155a:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c010155e:	7f 04                	jg     c0101564 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101560:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101564:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101569:	f7 d0                	not    %eax
c010156b:	83 e0 06             	and    $0x6,%eax
c010156e:	85 c0                	test   %eax,%eax
c0101570:	75 28                	jne    c010159a <kbd_proc_data+0x184>
c0101572:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101579:	75 1f                	jne    c010159a <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c010157b:	c7 04 24 1d 62 10 c0 	movl   $0xc010621d,(%esp)
c0101582:	e8 b5 ed ff ff       	call   c010033c <cprintf>
c0101587:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c010158d:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101591:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101595:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c0101599:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c010159a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010159d:	c9                   	leave  
c010159e:	c3                   	ret    

c010159f <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c010159f:	55                   	push   %ebp
c01015a0:	89 e5                	mov    %esp,%ebp
c01015a2:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015a5:	c7 04 24 16 14 10 c0 	movl   $0xc0101416,(%esp)
c01015ac:	e8 a6 fd ff ff       	call   c0101357 <cons_intr>
}
c01015b1:	c9                   	leave  
c01015b2:	c3                   	ret    

c01015b3 <kbd_init>:

static void
kbd_init(void) {
c01015b3:	55                   	push   %ebp
c01015b4:	89 e5                	mov    %esp,%ebp
c01015b6:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015b9:	e8 e1 ff ff ff       	call   c010159f <kbd_intr>
    pic_enable(IRQ_KBD);
c01015be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015c5:	e8 3d 01 00 00       	call   c0101707 <pic_enable>
}
c01015ca:	c9                   	leave  
c01015cb:	c3                   	ret    

c01015cc <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015cc:	55                   	push   %ebp
c01015cd:	89 e5                	mov    %esp,%ebp
c01015cf:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015d2:	e8 93 f8 ff ff       	call   c0100e6a <cga_init>
    serial_init();
c01015d7:	e8 74 f9 ff ff       	call   c0100f50 <serial_init>
    kbd_init();
c01015dc:	e8 d2 ff ff ff       	call   c01015b3 <kbd_init>
    if (!serial_exists) {
c01015e1:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c01015e6:	85 c0                	test   %eax,%eax
c01015e8:	75 0c                	jne    c01015f6 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01015ea:	c7 04 24 29 62 10 c0 	movl   $0xc0106229,(%esp)
c01015f1:	e8 46 ed ff ff       	call   c010033c <cprintf>
    }
}
c01015f6:	c9                   	leave  
c01015f7:	c3                   	ret    

c01015f8 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01015f8:	55                   	push   %ebp
c01015f9:	89 e5                	mov    %esp,%ebp
c01015fb:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01015fe:	e8 e2 f7 ff ff       	call   c0100de5 <__intr_save>
c0101603:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101606:	8b 45 08             	mov    0x8(%ebp),%eax
c0101609:	89 04 24             	mov    %eax,(%esp)
c010160c:	e8 9b fa ff ff       	call   c01010ac <lpt_putc>
        cga_putc(c);
c0101611:	8b 45 08             	mov    0x8(%ebp),%eax
c0101614:	89 04 24             	mov    %eax,(%esp)
c0101617:	e8 cf fa ff ff       	call   c01010eb <cga_putc>
        serial_putc(c);
c010161c:	8b 45 08             	mov    0x8(%ebp),%eax
c010161f:	89 04 24             	mov    %eax,(%esp)
c0101622:	e8 f1 fc ff ff       	call   c0101318 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101627:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010162a:	89 04 24             	mov    %eax,(%esp)
c010162d:	e8 dd f7 ff ff       	call   c0100e0f <__intr_restore>
}
c0101632:	c9                   	leave  
c0101633:	c3                   	ret    

c0101634 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101634:	55                   	push   %ebp
c0101635:	89 e5                	mov    %esp,%ebp
c0101637:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c010163a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101641:	e8 9f f7 ff ff       	call   c0100de5 <__intr_save>
c0101646:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101649:	e8 ab fd ff ff       	call   c01013f9 <serial_intr>
        kbd_intr();
c010164e:	e8 4c ff ff ff       	call   c010159f <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101653:	8b 15 a0 80 11 c0    	mov    0xc01180a0,%edx
c0101659:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c010165e:	39 c2                	cmp    %eax,%edx
c0101660:	74 31                	je     c0101693 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101662:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101667:	8d 50 01             	lea    0x1(%eax),%edx
c010166a:	89 15 a0 80 11 c0    	mov    %edx,0xc01180a0
c0101670:	0f b6 80 a0 7e 11 c0 	movzbl -0x3fee8160(%eax),%eax
c0101677:	0f b6 c0             	movzbl %al,%eax
c010167a:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c010167d:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101682:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101687:	75 0a                	jne    c0101693 <cons_getc+0x5f>
                cons.rpos = 0;
c0101689:	c7 05 a0 80 11 c0 00 	movl   $0x0,0xc01180a0
c0101690:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101693:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101696:	89 04 24             	mov    %eax,(%esp)
c0101699:	e8 71 f7 ff ff       	call   c0100e0f <__intr_restore>
    return c;
c010169e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016a1:	c9                   	leave  
c01016a2:	c3                   	ret    

c01016a3 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01016a3:	55                   	push   %ebp
c01016a4:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c01016a6:	fb                   	sti    
    sti();
}
c01016a7:	5d                   	pop    %ebp
c01016a8:	c3                   	ret    

c01016a9 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01016a9:	55                   	push   %ebp
c01016aa:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c01016ac:	fa                   	cli    
    cli();
}
c01016ad:	5d                   	pop    %ebp
c01016ae:	c3                   	ret    

c01016af <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016af:	55                   	push   %ebp
c01016b0:	89 e5                	mov    %esp,%ebp
c01016b2:	83 ec 14             	sub    $0x14,%esp
c01016b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01016b8:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016bc:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016c0:	66 a3 70 75 11 c0    	mov    %ax,0xc0117570
    if (did_init) {
c01016c6:	a1 ac 80 11 c0       	mov    0xc01180ac,%eax
c01016cb:	85 c0                	test   %eax,%eax
c01016cd:	74 36                	je     c0101705 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016cf:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016d3:	0f b6 c0             	movzbl %al,%eax
c01016d6:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016dc:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01016df:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01016e3:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016e7:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016e8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016ec:	66 c1 e8 08          	shr    $0x8,%ax
c01016f0:	0f b6 c0             	movzbl %al,%eax
c01016f3:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c01016f9:	88 45 f9             	mov    %al,-0x7(%ebp)
c01016fc:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101700:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101704:	ee                   	out    %al,(%dx)
    }
}
c0101705:	c9                   	leave  
c0101706:	c3                   	ret    

c0101707 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101707:	55                   	push   %ebp
c0101708:	89 e5                	mov    %esp,%ebp
c010170a:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c010170d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101710:	ba 01 00 00 00       	mov    $0x1,%edx
c0101715:	89 c1                	mov    %eax,%ecx
c0101717:	d3 e2                	shl    %cl,%edx
c0101719:	89 d0                	mov    %edx,%eax
c010171b:	f7 d0                	not    %eax
c010171d:	89 c2                	mov    %eax,%edx
c010171f:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101726:	21 d0                	and    %edx,%eax
c0101728:	0f b7 c0             	movzwl %ax,%eax
c010172b:	89 04 24             	mov    %eax,(%esp)
c010172e:	e8 7c ff ff ff       	call   c01016af <pic_setmask>
}
c0101733:	c9                   	leave  
c0101734:	c3                   	ret    

c0101735 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101735:	55                   	push   %ebp
c0101736:	89 e5                	mov    %esp,%ebp
c0101738:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c010173b:	c7 05 ac 80 11 c0 01 	movl   $0x1,0xc01180ac
c0101742:	00 00 00 
c0101745:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c010174b:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c010174f:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101753:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101757:	ee                   	out    %al,(%dx)
c0101758:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c010175e:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101762:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101766:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010176a:	ee                   	out    %al,(%dx)
c010176b:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101771:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c0101775:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101779:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010177d:	ee                   	out    %al,(%dx)
c010177e:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c0101784:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c0101788:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010178c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101790:	ee                   	out    %al,(%dx)
c0101791:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c0101797:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c010179b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010179f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017a3:	ee                   	out    %al,(%dx)
c01017a4:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c01017aa:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c01017ae:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017b2:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017b6:	ee                   	out    %al,(%dx)
c01017b7:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c01017bd:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c01017c1:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017c5:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017c9:	ee                   	out    %al,(%dx)
c01017ca:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c01017d0:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c01017d4:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017d8:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017dc:	ee                   	out    %al,(%dx)
c01017dd:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c01017e3:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c01017e7:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017eb:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01017ef:	ee                   	out    %al,(%dx)
c01017f0:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c01017f6:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c01017fa:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c01017fe:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101802:	ee                   	out    %al,(%dx)
c0101803:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c0101809:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c010180d:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101811:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101815:	ee                   	out    %al,(%dx)
c0101816:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c010181c:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c0101820:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101824:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101828:	ee                   	out    %al,(%dx)
c0101829:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c010182f:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c0101833:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101837:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c010183b:	ee                   	out    %al,(%dx)
c010183c:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c0101842:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c0101846:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c010184a:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c010184e:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c010184f:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101856:	66 83 f8 ff          	cmp    $0xffff,%ax
c010185a:	74 12                	je     c010186e <pic_init+0x139>
        pic_setmask(irq_mask);
c010185c:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101863:	0f b7 c0             	movzwl %ax,%eax
c0101866:	89 04 24             	mov    %eax,(%esp)
c0101869:	e8 41 fe ff ff       	call   c01016af <pic_setmask>
    }
}
c010186e:	c9                   	leave  
c010186f:	c3                   	ret    

c0101870 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101870:	55                   	push   %ebp
c0101871:	89 e5                	mov    %esp,%ebp
c0101873:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0101876:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c010187d:	00 
c010187e:	c7 04 24 60 62 10 c0 	movl   $0xc0106260,(%esp)
c0101885:	e8 b2 ea ff ff       	call   c010033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c010188a:	c7 04 24 6a 62 10 c0 	movl   $0xc010626a,(%esp)
c0101891:	e8 a6 ea ff ff       	call   c010033c <cprintf>
    panic("EOT: kernel seems ok.");
c0101896:	c7 44 24 08 78 62 10 	movl   $0xc0106278,0x8(%esp)
c010189d:	c0 
c010189e:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
c01018a5:	00 
c01018a6:	c7 04 24 8e 62 10 c0 	movl   $0xc010628e,(%esp)
c01018ad:	e8 14 f4 ff ff       	call   c0100cc6 <__panic>

c01018b2 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01018b2:	55                   	push   %ebp
c01018b3:	89 e5                	mov    %esp,%ebp
c01018b5:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c01018b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018bf:	e9 c3 00 00 00       	jmp    c0101987 <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01018c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018c7:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c01018ce:	89 c2                	mov    %eax,%edx
c01018d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018d3:	66 89 14 c5 c0 80 11 	mov    %dx,-0x3fee7f40(,%eax,8)
c01018da:	c0 
c01018db:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018de:	66 c7 04 c5 c2 80 11 	movw   $0x8,-0x3fee7f3e(,%eax,8)
c01018e5:	c0 08 00 
c01018e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018eb:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018f2:	c0 
c01018f3:	83 e2 e0             	and    $0xffffffe0,%edx
c01018f6:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01018fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101900:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c0101907:	c0 
c0101908:	83 e2 1f             	and    $0x1f,%edx
c010190b:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c0101912:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101915:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010191c:	c0 
c010191d:	83 e2 f0             	and    $0xfffffff0,%edx
c0101920:	83 ca 0e             	or     $0xe,%edx
c0101923:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c010192a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010192d:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101934:	c0 
c0101935:	83 e2 ef             	and    $0xffffffef,%edx
c0101938:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c010193f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101942:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101949:	c0 
c010194a:	83 e2 9f             	and    $0xffffff9f,%edx
c010194d:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101954:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101957:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010195e:	c0 
c010195f:	83 ca 80             	or     $0xffffff80,%edx
c0101962:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101969:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010196c:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c0101973:	c1 e8 10             	shr    $0x10,%eax
c0101976:	89 c2                	mov    %eax,%edx
c0101978:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010197b:	66 89 14 c5 c6 80 11 	mov    %dx,-0x3fee7f3a(,%eax,8)
c0101982:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c0101983:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101987:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010198a:	3d ff 00 00 00       	cmp    $0xff,%eax
c010198f:	0f 86 2f ff ff ff    	jbe    c01018c4 <idt_init+0x12>
c0101995:	c7 45 f8 80 75 11 c0 	movl   $0xc0117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c010199c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010199f:	0f 01 18             	lidtl  (%eax)
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
    lidt(&idt_pd);
}
c01019a2:	c9                   	leave  
c01019a3:	c3                   	ret    

c01019a4 <trapname>:

static const char *
trapname(int trapno) {
c01019a4:	55                   	push   %ebp
c01019a5:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c01019a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01019aa:	83 f8 13             	cmp    $0x13,%eax
c01019ad:	77 0c                	ja     c01019bb <trapname+0x17>
        return excnames[trapno];
c01019af:	8b 45 08             	mov    0x8(%ebp),%eax
c01019b2:	8b 04 85 e0 65 10 c0 	mov    -0x3fef9a20(,%eax,4),%eax
c01019b9:	eb 18                	jmp    c01019d3 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c01019bb:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c01019bf:	7e 0d                	jle    c01019ce <trapname+0x2a>
c01019c1:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c01019c5:	7f 07                	jg     c01019ce <trapname+0x2a>
        return "Hardware Interrupt";
c01019c7:	b8 9f 62 10 c0       	mov    $0xc010629f,%eax
c01019cc:	eb 05                	jmp    c01019d3 <trapname+0x2f>
    }
    return "(unknown trap)";
c01019ce:	b8 b2 62 10 c0       	mov    $0xc01062b2,%eax
}
c01019d3:	5d                   	pop    %ebp
c01019d4:	c3                   	ret    

c01019d5 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c01019d5:	55                   	push   %ebp
c01019d6:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c01019d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01019db:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01019df:	66 83 f8 08          	cmp    $0x8,%ax
c01019e3:	0f 94 c0             	sete   %al
c01019e6:	0f b6 c0             	movzbl %al,%eax
}
c01019e9:	5d                   	pop    %ebp
c01019ea:	c3                   	ret    

c01019eb <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c01019eb:	55                   	push   %ebp
c01019ec:	89 e5                	mov    %esp,%ebp
c01019ee:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c01019f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01019f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019f8:	c7 04 24 f3 62 10 c0 	movl   $0xc01062f3,(%esp)
c01019ff:	e8 38 e9 ff ff       	call   c010033c <cprintf>
    print_regs(&tf->tf_regs);
c0101a04:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a07:	89 04 24             	mov    %eax,(%esp)
c0101a0a:	e8 a1 01 00 00       	call   c0101bb0 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101a0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a12:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101a16:	0f b7 c0             	movzwl %ax,%eax
c0101a19:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a1d:	c7 04 24 04 63 10 c0 	movl   $0xc0106304,(%esp)
c0101a24:	e8 13 e9 ff ff       	call   c010033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101a29:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a2c:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101a30:	0f b7 c0             	movzwl %ax,%eax
c0101a33:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a37:	c7 04 24 17 63 10 c0 	movl   $0xc0106317,(%esp)
c0101a3e:	e8 f9 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101a43:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a46:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101a4a:	0f b7 c0             	movzwl %ax,%eax
c0101a4d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a51:	c7 04 24 2a 63 10 c0 	movl   $0xc010632a,(%esp)
c0101a58:	e8 df e8 ff ff       	call   c010033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101a5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a60:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101a64:	0f b7 c0             	movzwl %ax,%eax
c0101a67:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a6b:	c7 04 24 3d 63 10 c0 	movl   $0xc010633d,(%esp)
c0101a72:	e8 c5 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101a77:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a7a:	8b 40 30             	mov    0x30(%eax),%eax
c0101a7d:	89 04 24             	mov    %eax,(%esp)
c0101a80:	e8 1f ff ff ff       	call   c01019a4 <trapname>
c0101a85:	8b 55 08             	mov    0x8(%ebp),%edx
c0101a88:	8b 52 30             	mov    0x30(%edx),%edx
c0101a8b:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101a8f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101a93:	c7 04 24 50 63 10 c0 	movl   $0xc0106350,(%esp)
c0101a9a:	e8 9d e8 ff ff       	call   c010033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101a9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aa2:	8b 40 34             	mov    0x34(%eax),%eax
c0101aa5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101aa9:	c7 04 24 62 63 10 c0 	movl   $0xc0106362,(%esp)
c0101ab0:	e8 87 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101ab5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab8:	8b 40 38             	mov    0x38(%eax),%eax
c0101abb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101abf:	c7 04 24 71 63 10 c0 	movl   $0xc0106371,(%esp)
c0101ac6:	e8 71 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101acb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ace:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101ad2:	0f b7 c0             	movzwl %ax,%eax
c0101ad5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ad9:	c7 04 24 80 63 10 c0 	movl   $0xc0106380,(%esp)
c0101ae0:	e8 57 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101ae5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ae8:	8b 40 40             	mov    0x40(%eax),%eax
c0101aeb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101aef:	c7 04 24 93 63 10 c0 	movl   $0xc0106393,(%esp)
c0101af6:	e8 41 e8 ff ff       	call   c010033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101afb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b02:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101b09:	eb 3e                	jmp    c0101b49 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101b0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b0e:	8b 50 40             	mov    0x40(%eax),%edx
c0101b11:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101b14:	21 d0                	and    %edx,%eax
c0101b16:	85 c0                	test   %eax,%eax
c0101b18:	74 28                	je     c0101b42 <print_trapframe+0x157>
c0101b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b1d:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101b24:	85 c0                	test   %eax,%eax
c0101b26:	74 1a                	je     c0101b42 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b2b:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101b32:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b36:	c7 04 24 a2 63 10 c0 	movl   $0xc01063a2,(%esp)
c0101b3d:	e8 fa e7 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b42:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101b46:	d1 65 f0             	shll   -0x10(%ebp)
c0101b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b4c:	83 f8 17             	cmp    $0x17,%eax
c0101b4f:	76 ba                	jbe    c0101b0b <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101b51:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b54:	8b 40 40             	mov    0x40(%eax),%eax
c0101b57:	25 00 30 00 00       	and    $0x3000,%eax
c0101b5c:	c1 e8 0c             	shr    $0xc,%eax
c0101b5f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b63:	c7 04 24 a6 63 10 c0 	movl   $0xc01063a6,(%esp)
c0101b6a:	e8 cd e7 ff ff       	call   c010033c <cprintf>

    if (!trap_in_kernel(tf)) {
c0101b6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b72:	89 04 24             	mov    %eax,(%esp)
c0101b75:	e8 5b fe ff ff       	call   c01019d5 <trap_in_kernel>
c0101b7a:	85 c0                	test   %eax,%eax
c0101b7c:	75 30                	jne    c0101bae <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101b7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b81:	8b 40 44             	mov    0x44(%eax),%eax
c0101b84:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b88:	c7 04 24 af 63 10 c0 	movl   $0xc01063af,(%esp)
c0101b8f:	e8 a8 e7 ff ff       	call   c010033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101b94:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b97:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101b9b:	0f b7 c0             	movzwl %ax,%eax
c0101b9e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ba2:	c7 04 24 be 63 10 c0 	movl   $0xc01063be,(%esp)
c0101ba9:	e8 8e e7 ff ff       	call   c010033c <cprintf>
    }
}
c0101bae:	c9                   	leave  
c0101baf:	c3                   	ret    

c0101bb0 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101bb0:	55                   	push   %ebp
c0101bb1:	89 e5                	mov    %esp,%ebp
c0101bb3:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101bb6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bb9:	8b 00                	mov    (%eax),%eax
c0101bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bbf:	c7 04 24 d1 63 10 c0 	movl   $0xc01063d1,(%esp)
c0101bc6:	e8 71 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101bcb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bce:	8b 40 04             	mov    0x4(%eax),%eax
c0101bd1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bd5:	c7 04 24 e0 63 10 c0 	movl   $0xc01063e0,(%esp)
c0101bdc:	e8 5b e7 ff ff       	call   c010033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101be1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101be4:	8b 40 08             	mov    0x8(%eax),%eax
c0101be7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101beb:	c7 04 24 ef 63 10 c0 	movl   $0xc01063ef,(%esp)
c0101bf2:	e8 45 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101bf7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bfa:	8b 40 0c             	mov    0xc(%eax),%eax
c0101bfd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c01:	c7 04 24 fe 63 10 c0 	movl   $0xc01063fe,(%esp)
c0101c08:	e8 2f e7 ff ff       	call   c010033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101c0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c10:	8b 40 10             	mov    0x10(%eax),%eax
c0101c13:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c17:	c7 04 24 0d 64 10 c0 	movl   $0xc010640d,(%esp)
c0101c1e:	e8 19 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101c23:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c26:	8b 40 14             	mov    0x14(%eax),%eax
c0101c29:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c2d:	c7 04 24 1c 64 10 c0 	movl   $0xc010641c,(%esp)
c0101c34:	e8 03 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101c39:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c3c:	8b 40 18             	mov    0x18(%eax),%eax
c0101c3f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c43:	c7 04 24 2b 64 10 c0 	movl   $0xc010642b,(%esp)
c0101c4a:	e8 ed e6 ff ff       	call   c010033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101c4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c52:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101c55:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c59:	c7 04 24 3a 64 10 c0 	movl   $0xc010643a,(%esp)
c0101c60:	e8 d7 e6 ff ff       	call   c010033c <cprintf>
}
c0101c65:	c9                   	leave  
c0101c66:	c3                   	ret    

c0101c67 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101c67:	55                   	push   %ebp
c0101c68:	89 e5                	mov    %esp,%ebp
c0101c6a:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101c6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c70:	8b 40 30             	mov    0x30(%eax),%eax
c0101c73:	83 f8 2f             	cmp    $0x2f,%eax
c0101c76:	77 21                	ja     c0101c99 <trap_dispatch+0x32>
c0101c78:	83 f8 2e             	cmp    $0x2e,%eax
c0101c7b:	0f 83 04 01 00 00    	jae    c0101d85 <trap_dispatch+0x11e>
c0101c81:	83 f8 21             	cmp    $0x21,%eax
c0101c84:	0f 84 81 00 00 00    	je     c0101d0b <trap_dispatch+0xa4>
c0101c8a:	83 f8 24             	cmp    $0x24,%eax
c0101c8d:	74 56                	je     c0101ce5 <trap_dispatch+0x7e>
c0101c8f:	83 f8 20             	cmp    $0x20,%eax
c0101c92:	74 16                	je     c0101caa <trap_dispatch+0x43>
c0101c94:	e9 b4 00 00 00       	jmp    c0101d4d <trap_dispatch+0xe6>
c0101c99:	83 e8 78             	sub    $0x78,%eax
c0101c9c:	83 f8 01             	cmp    $0x1,%eax
c0101c9f:	0f 87 a8 00 00 00    	ja     c0101d4d <trap_dispatch+0xe6>
c0101ca5:	e9 87 00 00 00       	jmp    c0101d31 <trap_dispatch+0xca>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c0101caa:	a1 4c 89 11 c0       	mov    0xc011894c,%eax
c0101caf:	83 c0 01             	add    $0x1,%eax
c0101cb2:	a3 4c 89 11 c0       	mov    %eax,0xc011894c
        if (ticks % TICK_NUM == 0) {
c0101cb7:	8b 0d 4c 89 11 c0    	mov    0xc011894c,%ecx
c0101cbd:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101cc2:	89 c8                	mov    %ecx,%eax
c0101cc4:	f7 e2                	mul    %edx
c0101cc6:	89 d0                	mov    %edx,%eax
c0101cc8:	c1 e8 05             	shr    $0x5,%eax
c0101ccb:	6b c0 64             	imul   $0x64,%eax,%eax
c0101cce:	29 c1                	sub    %eax,%ecx
c0101cd0:	89 c8                	mov    %ecx,%eax
c0101cd2:	85 c0                	test   %eax,%eax
c0101cd4:	75 0a                	jne    c0101ce0 <trap_dispatch+0x79>
            print_ticks();
c0101cd6:	e8 95 fb ff ff       	call   c0101870 <print_ticks>
        }
        break;
c0101cdb:	e9 a6 00 00 00       	jmp    c0101d86 <trap_dispatch+0x11f>
c0101ce0:	e9 a1 00 00 00       	jmp    c0101d86 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101ce5:	e8 4a f9 ff ff       	call   c0101634 <cons_getc>
c0101cea:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101ced:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101cf1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101cf5:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101cf9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cfd:	c7 04 24 49 64 10 c0 	movl   $0xc0106449,(%esp)
c0101d04:	e8 33 e6 ff ff       	call   c010033c <cprintf>
        break;
c0101d09:	eb 7b                	jmp    c0101d86 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101d0b:	e8 24 f9 ff ff       	call   c0101634 <cons_getc>
c0101d10:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101d13:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d17:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d1b:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101d1f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d23:	c7 04 24 5b 64 10 c0 	movl   $0xc010645b,(%esp)
c0101d2a:	e8 0d e6 ff ff       	call   c010033c <cprintf>
        break;
c0101d2f:	eb 55                	jmp    c0101d86 <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101d31:	c7 44 24 08 6a 64 10 	movl   $0xc010646a,0x8(%esp)
c0101d38:	c0 
c0101d39:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
c0101d40:	00 
c0101d41:	c7 04 24 8e 62 10 c0 	movl   $0xc010628e,(%esp)
c0101d48:	e8 79 ef ff ff       	call   c0100cc6 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101d4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d50:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101d54:	0f b7 c0             	movzwl %ax,%eax
c0101d57:	83 e0 03             	and    $0x3,%eax
c0101d5a:	85 c0                	test   %eax,%eax
c0101d5c:	75 28                	jne    c0101d86 <trap_dispatch+0x11f>
            print_trapframe(tf);
c0101d5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d61:	89 04 24             	mov    %eax,(%esp)
c0101d64:	e8 82 fc ff ff       	call   c01019eb <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101d69:	c7 44 24 08 7a 64 10 	movl   $0xc010647a,0x8(%esp)
c0101d70:	c0 
c0101d71:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c0101d78:	00 
c0101d79:	c7 04 24 8e 62 10 c0 	movl   $0xc010628e,(%esp)
c0101d80:	e8 41 ef ff ff       	call   c0100cc6 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101d85:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101d86:	c9                   	leave  
c0101d87:	c3                   	ret    

c0101d88 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101d88:	55                   	push   %ebp
c0101d89:	89 e5                	mov    %esp,%ebp
c0101d8b:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101d8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d91:	89 04 24             	mov    %eax,(%esp)
c0101d94:	e8 ce fe ff ff       	call   c0101c67 <trap_dispatch>
}
c0101d99:	c9                   	leave  
c0101d9a:	c3                   	ret    

c0101d9b <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101d9b:	1e                   	push   %ds
    pushl %es
c0101d9c:	06                   	push   %es
    pushl %fs
c0101d9d:	0f a0                	push   %fs
    pushl %gs
c0101d9f:	0f a8                	push   %gs
    pushal
c0101da1:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101da2:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101da7:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101da9:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101dab:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101dac:	e8 d7 ff ff ff       	call   c0101d88 <trap>

    # pop the pushed stack pointer
    popl %esp
c0101db1:	5c                   	pop    %esp

c0101db2 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101db2:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101db3:	0f a9                	pop    %gs
    popl %fs
c0101db5:	0f a1                	pop    %fs
    popl %es
c0101db7:	07                   	pop    %es
    popl %ds
c0101db8:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101db9:	83 c4 08             	add    $0x8,%esp
    iret
c0101dbc:	cf                   	iret   

c0101dbd <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101dbd:	6a 00                	push   $0x0
  pushl $0
c0101dbf:	6a 00                	push   $0x0
  jmp __alltraps
c0101dc1:	e9 d5 ff ff ff       	jmp    c0101d9b <__alltraps>

c0101dc6 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101dc6:	6a 00                	push   $0x0
  pushl $1
c0101dc8:	6a 01                	push   $0x1
  jmp __alltraps
c0101dca:	e9 cc ff ff ff       	jmp    c0101d9b <__alltraps>

c0101dcf <vector2>:
.globl vector2
vector2:
  pushl $0
c0101dcf:	6a 00                	push   $0x0
  pushl $2
c0101dd1:	6a 02                	push   $0x2
  jmp __alltraps
c0101dd3:	e9 c3 ff ff ff       	jmp    c0101d9b <__alltraps>

c0101dd8 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101dd8:	6a 00                	push   $0x0
  pushl $3
c0101dda:	6a 03                	push   $0x3
  jmp __alltraps
c0101ddc:	e9 ba ff ff ff       	jmp    c0101d9b <__alltraps>

c0101de1 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101de1:	6a 00                	push   $0x0
  pushl $4
c0101de3:	6a 04                	push   $0x4
  jmp __alltraps
c0101de5:	e9 b1 ff ff ff       	jmp    c0101d9b <__alltraps>

c0101dea <vector5>:
.globl vector5
vector5:
  pushl $0
c0101dea:	6a 00                	push   $0x0
  pushl $5
c0101dec:	6a 05                	push   $0x5
  jmp __alltraps
c0101dee:	e9 a8 ff ff ff       	jmp    c0101d9b <__alltraps>

c0101df3 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101df3:	6a 00                	push   $0x0
  pushl $6
c0101df5:	6a 06                	push   $0x6
  jmp __alltraps
c0101df7:	e9 9f ff ff ff       	jmp    c0101d9b <__alltraps>

c0101dfc <vector7>:
.globl vector7
vector7:
  pushl $0
c0101dfc:	6a 00                	push   $0x0
  pushl $7
c0101dfe:	6a 07                	push   $0x7
  jmp __alltraps
c0101e00:	e9 96 ff ff ff       	jmp    c0101d9b <__alltraps>

c0101e05 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101e05:	6a 08                	push   $0x8
  jmp __alltraps
c0101e07:	e9 8f ff ff ff       	jmp    c0101d9b <__alltraps>

c0101e0c <vector9>:
.globl vector9
vector9:
  pushl $9
c0101e0c:	6a 09                	push   $0x9
  jmp __alltraps
c0101e0e:	e9 88 ff ff ff       	jmp    c0101d9b <__alltraps>

c0101e13 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101e13:	6a 0a                	push   $0xa
  jmp __alltraps
c0101e15:	e9 81 ff ff ff       	jmp    c0101d9b <__alltraps>

c0101e1a <vector11>:
.globl vector11
vector11:
  pushl $11
c0101e1a:	6a 0b                	push   $0xb
  jmp __alltraps
c0101e1c:	e9 7a ff ff ff       	jmp    c0101d9b <__alltraps>

c0101e21 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101e21:	6a 0c                	push   $0xc
  jmp __alltraps
c0101e23:	e9 73 ff ff ff       	jmp    c0101d9b <__alltraps>

c0101e28 <vector13>:
.globl vector13
vector13:
  pushl $13
c0101e28:	6a 0d                	push   $0xd
  jmp __alltraps
c0101e2a:	e9 6c ff ff ff       	jmp    c0101d9b <__alltraps>

c0101e2f <vector14>:
.globl vector14
vector14:
  pushl $14
c0101e2f:	6a 0e                	push   $0xe
  jmp __alltraps
c0101e31:	e9 65 ff ff ff       	jmp    c0101d9b <__alltraps>

c0101e36 <vector15>:
.globl vector15
vector15:
  pushl $0
c0101e36:	6a 00                	push   $0x0
  pushl $15
c0101e38:	6a 0f                	push   $0xf
  jmp __alltraps
c0101e3a:	e9 5c ff ff ff       	jmp    c0101d9b <__alltraps>

c0101e3f <vector16>:
.globl vector16
vector16:
  pushl $0
c0101e3f:	6a 00                	push   $0x0
  pushl $16
c0101e41:	6a 10                	push   $0x10
  jmp __alltraps
c0101e43:	e9 53 ff ff ff       	jmp    c0101d9b <__alltraps>

c0101e48 <vector17>:
.globl vector17
vector17:
  pushl $17
c0101e48:	6a 11                	push   $0x11
  jmp __alltraps
c0101e4a:	e9 4c ff ff ff       	jmp    c0101d9b <__alltraps>

c0101e4f <vector18>:
.globl vector18
vector18:
  pushl $0
c0101e4f:	6a 00                	push   $0x0
  pushl $18
c0101e51:	6a 12                	push   $0x12
  jmp __alltraps
c0101e53:	e9 43 ff ff ff       	jmp    c0101d9b <__alltraps>

c0101e58 <vector19>:
.globl vector19
vector19:
  pushl $0
c0101e58:	6a 00                	push   $0x0
  pushl $19
c0101e5a:	6a 13                	push   $0x13
  jmp __alltraps
c0101e5c:	e9 3a ff ff ff       	jmp    c0101d9b <__alltraps>

c0101e61 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101e61:	6a 00                	push   $0x0
  pushl $20
c0101e63:	6a 14                	push   $0x14
  jmp __alltraps
c0101e65:	e9 31 ff ff ff       	jmp    c0101d9b <__alltraps>

c0101e6a <vector21>:
.globl vector21
vector21:
  pushl $0
c0101e6a:	6a 00                	push   $0x0
  pushl $21
c0101e6c:	6a 15                	push   $0x15
  jmp __alltraps
c0101e6e:	e9 28 ff ff ff       	jmp    c0101d9b <__alltraps>

c0101e73 <vector22>:
.globl vector22
vector22:
  pushl $0
c0101e73:	6a 00                	push   $0x0
  pushl $22
c0101e75:	6a 16                	push   $0x16
  jmp __alltraps
c0101e77:	e9 1f ff ff ff       	jmp    c0101d9b <__alltraps>

c0101e7c <vector23>:
.globl vector23
vector23:
  pushl $0
c0101e7c:	6a 00                	push   $0x0
  pushl $23
c0101e7e:	6a 17                	push   $0x17
  jmp __alltraps
c0101e80:	e9 16 ff ff ff       	jmp    c0101d9b <__alltraps>

c0101e85 <vector24>:
.globl vector24
vector24:
  pushl $0
c0101e85:	6a 00                	push   $0x0
  pushl $24
c0101e87:	6a 18                	push   $0x18
  jmp __alltraps
c0101e89:	e9 0d ff ff ff       	jmp    c0101d9b <__alltraps>

c0101e8e <vector25>:
.globl vector25
vector25:
  pushl $0
c0101e8e:	6a 00                	push   $0x0
  pushl $25
c0101e90:	6a 19                	push   $0x19
  jmp __alltraps
c0101e92:	e9 04 ff ff ff       	jmp    c0101d9b <__alltraps>

c0101e97 <vector26>:
.globl vector26
vector26:
  pushl $0
c0101e97:	6a 00                	push   $0x0
  pushl $26
c0101e99:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101e9b:	e9 fb fe ff ff       	jmp    c0101d9b <__alltraps>

c0101ea0 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101ea0:	6a 00                	push   $0x0
  pushl $27
c0101ea2:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101ea4:	e9 f2 fe ff ff       	jmp    c0101d9b <__alltraps>

c0101ea9 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101ea9:	6a 00                	push   $0x0
  pushl $28
c0101eab:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101ead:	e9 e9 fe ff ff       	jmp    c0101d9b <__alltraps>

c0101eb2 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101eb2:	6a 00                	push   $0x0
  pushl $29
c0101eb4:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101eb6:	e9 e0 fe ff ff       	jmp    c0101d9b <__alltraps>

c0101ebb <vector30>:
.globl vector30
vector30:
  pushl $0
c0101ebb:	6a 00                	push   $0x0
  pushl $30
c0101ebd:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101ebf:	e9 d7 fe ff ff       	jmp    c0101d9b <__alltraps>

c0101ec4 <vector31>:
.globl vector31
vector31:
  pushl $0
c0101ec4:	6a 00                	push   $0x0
  pushl $31
c0101ec6:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101ec8:	e9 ce fe ff ff       	jmp    c0101d9b <__alltraps>

c0101ecd <vector32>:
.globl vector32
vector32:
  pushl $0
c0101ecd:	6a 00                	push   $0x0
  pushl $32
c0101ecf:	6a 20                	push   $0x20
  jmp __alltraps
c0101ed1:	e9 c5 fe ff ff       	jmp    c0101d9b <__alltraps>

c0101ed6 <vector33>:
.globl vector33
vector33:
  pushl $0
c0101ed6:	6a 00                	push   $0x0
  pushl $33
c0101ed8:	6a 21                	push   $0x21
  jmp __alltraps
c0101eda:	e9 bc fe ff ff       	jmp    c0101d9b <__alltraps>

c0101edf <vector34>:
.globl vector34
vector34:
  pushl $0
c0101edf:	6a 00                	push   $0x0
  pushl $34
c0101ee1:	6a 22                	push   $0x22
  jmp __alltraps
c0101ee3:	e9 b3 fe ff ff       	jmp    c0101d9b <__alltraps>

c0101ee8 <vector35>:
.globl vector35
vector35:
  pushl $0
c0101ee8:	6a 00                	push   $0x0
  pushl $35
c0101eea:	6a 23                	push   $0x23
  jmp __alltraps
c0101eec:	e9 aa fe ff ff       	jmp    c0101d9b <__alltraps>

c0101ef1 <vector36>:
.globl vector36
vector36:
  pushl $0
c0101ef1:	6a 00                	push   $0x0
  pushl $36
c0101ef3:	6a 24                	push   $0x24
  jmp __alltraps
c0101ef5:	e9 a1 fe ff ff       	jmp    c0101d9b <__alltraps>

c0101efa <vector37>:
.globl vector37
vector37:
  pushl $0
c0101efa:	6a 00                	push   $0x0
  pushl $37
c0101efc:	6a 25                	push   $0x25
  jmp __alltraps
c0101efe:	e9 98 fe ff ff       	jmp    c0101d9b <__alltraps>

c0101f03 <vector38>:
.globl vector38
vector38:
  pushl $0
c0101f03:	6a 00                	push   $0x0
  pushl $38
c0101f05:	6a 26                	push   $0x26
  jmp __alltraps
c0101f07:	e9 8f fe ff ff       	jmp    c0101d9b <__alltraps>

c0101f0c <vector39>:
.globl vector39
vector39:
  pushl $0
c0101f0c:	6a 00                	push   $0x0
  pushl $39
c0101f0e:	6a 27                	push   $0x27
  jmp __alltraps
c0101f10:	e9 86 fe ff ff       	jmp    c0101d9b <__alltraps>

c0101f15 <vector40>:
.globl vector40
vector40:
  pushl $0
c0101f15:	6a 00                	push   $0x0
  pushl $40
c0101f17:	6a 28                	push   $0x28
  jmp __alltraps
c0101f19:	e9 7d fe ff ff       	jmp    c0101d9b <__alltraps>

c0101f1e <vector41>:
.globl vector41
vector41:
  pushl $0
c0101f1e:	6a 00                	push   $0x0
  pushl $41
c0101f20:	6a 29                	push   $0x29
  jmp __alltraps
c0101f22:	e9 74 fe ff ff       	jmp    c0101d9b <__alltraps>

c0101f27 <vector42>:
.globl vector42
vector42:
  pushl $0
c0101f27:	6a 00                	push   $0x0
  pushl $42
c0101f29:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101f2b:	e9 6b fe ff ff       	jmp    c0101d9b <__alltraps>

c0101f30 <vector43>:
.globl vector43
vector43:
  pushl $0
c0101f30:	6a 00                	push   $0x0
  pushl $43
c0101f32:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101f34:	e9 62 fe ff ff       	jmp    c0101d9b <__alltraps>

c0101f39 <vector44>:
.globl vector44
vector44:
  pushl $0
c0101f39:	6a 00                	push   $0x0
  pushl $44
c0101f3b:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101f3d:	e9 59 fe ff ff       	jmp    c0101d9b <__alltraps>

c0101f42 <vector45>:
.globl vector45
vector45:
  pushl $0
c0101f42:	6a 00                	push   $0x0
  pushl $45
c0101f44:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101f46:	e9 50 fe ff ff       	jmp    c0101d9b <__alltraps>

c0101f4b <vector46>:
.globl vector46
vector46:
  pushl $0
c0101f4b:	6a 00                	push   $0x0
  pushl $46
c0101f4d:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101f4f:	e9 47 fe ff ff       	jmp    c0101d9b <__alltraps>

c0101f54 <vector47>:
.globl vector47
vector47:
  pushl $0
c0101f54:	6a 00                	push   $0x0
  pushl $47
c0101f56:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101f58:	e9 3e fe ff ff       	jmp    c0101d9b <__alltraps>

c0101f5d <vector48>:
.globl vector48
vector48:
  pushl $0
c0101f5d:	6a 00                	push   $0x0
  pushl $48
c0101f5f:	6a 30                	push   $0x30
  jmp __alltraps
c0101f61:	e9 35 fe ff ff       	jmp    c0101d9b <__alltraps>

c0101f66 <vector49>:
.globl vector49
vector49:
  pushl $0
c0101f66:	6a 00                	push   $0x0
  pushl $49
c0101f68:	6a 31                	push   $0x31
  jmp __alltraps
c0101f6a:	e9 2c fe ff ff       	jmp    c0101d9b <__alltraps>

c0101f6f <vector50>:
.globl vector50
vector50:
  pushl $0
c0101f6f:	6a 00                	push   $0x0
  pushl $50
c0101f71:	6a 32                	push   $0x32
  jmp __alltraps
c0101f73:	e9 23 fe ff ff       	jmp    c0101d9b <__alltraps>

c0101f78 <vector51>:
.globl vector51
vector51:
  pushl $0
c0101f78:	6a 00                	push   $0x0
  pushl $51
c0101f7a:	6a 33                	push   $0x33
  jmp __alltraps
c0101f7c:	e9 1a fe ff ff       	jmp    c0101d9b <__alltraps>

c0101f81 <vector52>:
.globl vector52
vector52:
  pushl $0
c0101f81:	6a 00                	push   $0x0
  pushl $52
c0101f83:	6a 34                	push   $0x34
  jmp __alltraps
c0101f85:	e9 11 fe ff ff       	jmp    c0101d9b <__alltraps>

c0101f8a <vector53>:
.globl vector53
vector53:
  pushl $0
c0101f8a:	6a 00                	push   $0x0
  pushl $53
c0101f8c:	6a 35                	push   $0x35
  jmp __alltraps
c0101f8e:	e9 08 fe ff ff       	jmp    c0101d9b <__alltraps>

c0101f93 <vector54>:
.globl vector54
vector54:
  pushl $0
c0101f93:	6a 00                	push   $0x0
  pushl $54
c0101f95:	6a 36                	push   $0x36
  jmp __alltraps
c0101f97:	e9 ff fd ff ff       	jmp    c0101d9b <__alltraps>

c0101f9c <vector55>:
.globl vector55
vector55:
  pushl $0
c0101f9c:	6a 00                	push   $0x0
  pushl $55
c0101f9e:	6a 37                	push   $0x37
  jmp __alltraps
c0101fa0:	e9 f6 fd ff ff       	jmp    c0101d9b <__alltraps>

c0101fa5 <vector56>:
.globl vector56
vector56:
  pushl $0
c0101fa5:	6a 00                	push   $0x0
  pushl $56
c0101fa7:	6a 38                	push   $0x38
  jmp __alltraps
c0101fa9:	e9 ed fd ff ff       	jmp    c0101d9b <__alltraps>

c0101fae <vector57>:
.globl vector57
vector57:
  pushl $0
c0101fae:	6a 00                	push   $0x0
  pushl $57
c0101fb0:	6a 39                	push   $0x39
  jmp __alltraps
c0101fb2:	e9 e4 fd ff ff       	jmp    c0101d9b <__alltraps>

c0101fb7 <vector58>:
.globl vector58
vector58:
  pushl $0
c0101fb7:	6a 00                	push   $0x0
  pushl $58
c0101fb9:	6a 3a                	push   $0x3a
  jmp __alltraps
c0101fbb:	e9 db fd ff ff       	jmp    c0101d9b <__alltraps>

c0101fc0 <vector59>:
.globl vector59
vector59:
  pushl $0
c0101fc0:	6a 00                	push   $0x0
  pushl $59
c0101fc2:	6a 3b                	push   $0x3b
  jmp __alltraps
c0101fc4:	e9 d2 fd ff ff       	jmp    c0101d9b <__alltraps>

c0101fc9 <vector60>:
.globl vector60
vector60:
  pushl $0
c0101fc9:	6a 00                	push   $0x0
  pushl $60
c0101fcb:	6a 3c                	push   $0x3c
  jmp __alltraps
c0101fcd:	e9 c9 fd ff ff       	jmp    c0101d9b <__alltraps>

c0101fd2 <vector61>:
.globl vector61
vector61:
  pushl $0
c0101fd2:	6a 00                	push   $0x0
  pushl $61
c0101fd4:	6a 3d                	push   $0x3d
  jmp __alltraps
c0101fd6:	e9 c0 fd ff ff       	jmp    c0101d9b <__alltraps>

c0101fdb <vector62>:
.globl vector62
vector62:
  pushl $0
c0101fdb:	6a 00                	push   $0x0
  pushl $62
c0101fdd:	6a 3e                	push   $0x3e
  jmp __alltraps
c0101fdf:	e9 b7 fd ff ff       	jmp    c0101d9b <__alltraps>

c0101fe4 <vector63>:
.globl vector63
vector63:
  pushl $0
c0101fe4:	6a 00                	push   $0x0
  pushl $63
c0101fe6:	6a 3f                	push   $0x3f
  jmp __alltraps
c0101fe8:	e9 ae fd ff ff       	jmp    c0101d9b <__alltraps>

c0101fed <vector64>:
.globl vector64
vector64:
  pushl $0
c0101fed:	6a 00                	push   $0x0
  pushl $64
c0101fef:	6a 40                	push   $0x40
  jmp __alltraps
c0101ff1:	e9 a5 fd ff ff       	jmp    c0101d9b <__alltraps>

c0101ff6 <vector65>:
.globl vector65
vector65:
  pushl $0
c0101ff6:	6a 00                	push   $0x0
  pushl $65
c0101ff8:	6a 41                	push   $0x41
  jmp __alltraps
c0101ffa:	e9 9c fd ff ff       	jmp    c0101d9b <__alltraps>

c0101fff <vector66>:
.globl vector66
vector66:
  pushl $0
c0101fff:	6a 00                	push   $0x0
  pushl $66
c0102001:	6a 42                	push   $0x42
  jmp __alltraps
c0102003:	e9 93 fd ff ff       	jmp    c0101d9b <__alltraps>

c0102008 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102008:	6a 00                	push   $0x0
  pushl $67
c010200a:	6a 43                	push   $0x43
  jmp __alltraps
c010200c:	e9 8a fd ff ff       	jmp    c0101d9b <__alltraps>

c0102011 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102011:	6a 00                	push   $0x0
  pushl $68
c0102013:	6a 44                	push   $0x44
  jmp __alltraps
c0102015:	e9 81 fd ff ff       	jmp    c0101d9b <__alltraps>

c010201a <vector69>:
.globl vector69
vector69:
  pushl $0
c010201a:	6a 00                	push   $0x0
  pushl $69
c010201c:	6a 45                	push   $0x45
  jmp __alltraps
c010201e:	e9 78 fd ff ff       	jmp    c0101d9b <__alltraps>

c0102023 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102023:	6a 00                	push   $0x0
  pushl $70
c0102025:	6a 46                	push   $0x46
  jmp __alltraps
c0102027:	e9 6f fd ff ff       	jmp    c0101d9b <__alltraps>

c010202c <vector71>:
.globl vector71
vector71:
  pushl $0
c010202c:	6a 00                	push   $0x0
  pushl $71
c010202e:	6a 47                	push   $0x47
  jmp __alltraps
c0102030:	e9 66 fd ff ff       	jmp    c0101d9b <__alltraps>

c0102035 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102035:	6a 00                	push   $0x0
  pushl $72
c0102037:	6a 48                	push   $0x48
  jmp __alltraps
c0102039:	e9 5d fd ff ff       	jmp    c0101d9b <__alltraps>

c010203e <vector73>:
.globl vector73
vector73:
  pushl $0
c010203e:	6a 00                	push   $0x0
  pushl $73
c0102040:	6a 49                	push   $0x49
  jmp __alltraps
c0102042:	e9 54 fd ff ff       	jmp    c0101d9b <__alltraps>

c0102047 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102047:	6a 00                	push   $0x0
  pushl $74
c0102049:	6a 4a                	push   $0x4a
  jmp __alltraps
c010204b:	e9 4b fd ff ff       	jmp    c0101d9b <__alltraps>

c0102050 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102050:	6a 00                	push   $0x0
  pushl $75
c0102052:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102054:	e9 42 fd ff ff       	jmp    c0101d9b <__alltraps>

c0102059 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102059:	6a 00                	push   $0x0
  pushl $76
c010205b:	6a 4c                	push   $0x4c
  jmp __alltraps
c010205d:	e9 39 fd ff ff       	jmp    c0101d9b <__alltraps>

c0102062 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102062:	6a 00                	push   $0x0
  pushl $77
c0102064:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102066:	e9 30 fd ff ff       	jmp    c0101d9b <__alltraps>

c010206b <vector78>:
.globl vector78
vector78:
  pushl $0
c010206b:	6a 00                	push   $0x0
  pushl $78
c010206d:	6a 4e                	push   $0x4e
  jmp __alltraps
c010206f:	e9 27 fd ff ff       	jmp    c0101d9b <__alltraps>

c0102074 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102074:	6a 00                	push   $0x0
  pushl $79
c0102076:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102078:	e9 1e fd ff ff       	jmp    c0101d9b <__alltraps>

c010207d <vector80>:
.globl vector80
vector80:
  pushl $0
c010207d:	6a 00                	push   $0x0
  pushl $80
c010207f:	6a 50                	push   $0x50
  jmp __alltraps
c0102081:	e9 15 fd ff ff       	jmp    c0101d9b <__alltraps>

c0102086 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102086:	6a 00                	push   $0x0
  pushl $81
c0102088:	6a 51                	push   $0x51
  jmp __alltraps
c010208a:	e9 0c fd ff ff       	jmp    c0101d9b <__alltraps>

c010208f <vector82>:
.globl vector82
vector82:
  pushl $0
c010208f:	6a 00                	push   $0x0
  pushl $82
c0102091:	6a 52                	push   $0x52
  jmp __alltraps
c0102093:	e9 03 fd ff ff       	jmp    c0101d9b <__alltraps>

c0102098 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102098:	6a 00                	push   $0x0
  pushl $83
c010209a:	6a 53                	push   $0x53
  jmp __alltraps
c010209c:	e9 fa fc ff ff       	jmp    c0101d9b <__alltraps>

c01020a1 <vector84>:
.globl vector84
vector84:
  pushl $0
c01020a1:	6a 00                	push   $0x0
  pushl $84
c01020a3:	6a 54                	push   $0x54
  jmp __alltraps
c01020a5:	e9 f1 fc ff ff       	jmp    c0101d9b <__alltraps>

c01020aa <vector85>:
.globl vector85
vector85:
  pushl $0
c01020aa:	6a 00                	push   $0x0
  pushl $85
c01020ac:	6a 55                	push   $0x55
  jmp __alltraps
c01020ae:	e9 e8 fc ff ff       	jmp    c0101d9b <__alltraps>

c01020b3 <vector86>:
.globl vector86
vector86:
  pushl $0
c01020b3:	6a 00                	push   $0x0
  pushl $86
c01020b5:	6a 56                	push   $0x56
  jmp __alltraps
c01020b7:	e9 df fc ff ff       	jmp    c0101d9b <__alltraps>

c01020bc <vector87>:
.globl vector87
vector87:
  pushl $0
c01020bc:	6a 00                	push   $0x0
  pushl $87
c01020be:	6a 57                	push   $0x57
  jmp __alltraps
c01020c0:	e9 d6 fc ff ff       	jmp    c0101d9b <__alltraps>

c01020c5 <vector88>:
.globl vector88
vector88:
  pushl $0
c01020c5:	6a 00                	push   $0x0
  pushl $88
c01020c7:	6a 58                	push   $0x58
  jmp __alltraps
c01020c9:	e9 cd fc ff ff       	jmp    c0101d9b <__alltraps>

c01020ce <vector89>:
.globl vector89
vector89:
  pushl $0
c01020ce:	6a 00                	push   $0x0
  pushl $89
c01020d0:	6a 59                	push   $0x59
  jmp __alltraps
c01020d2:	e9 c4 fc ff ff       	jmp    c0101d9b <__alltraps>

c01020d7 <vector90>:
.globl vector90
vector90:
  pushl $0
c01020d7:	6a 00                	push   $0x0
  pushl $90
c01020d9:	6a 5a                	push   $0x5a
  jmp __alltraps
c01020db:	e9 bb fc ff ff       	jmp    c0101d9b <__alltraps>

c01020e0 <vector91>:
.globl vector91
vector91:
  pushl $0
c01020e0:	6a 00                	push   $0x0
  pushl $91
c01020e2:	6a 5b                	push   $0x5b
  jmp __alltraps
c01020e4:	e9 b2 fc ff ff       	jmp    c0101d9b <__alltraps>

c01020e9 <vector92>:
.globl vector92
vector92:
  pushl $0
c01020e9:	6a 00                	push   $0x0
  pushl $92
c01020eb:	6a 5c                	push   $0x5c
  jmp __alltraps
c01020ed:	e9 a9 fc ff ff       	jmp    c0101d9b <__alltraps>

c01020f2 <vector93>:
.globl vector93
vector93:
  pushl $0
c01020f2:	6a 00                	push   $0x0
  pushl $93
c01020f4:	6a 5d                	push   $0x5d
  jmp __alltraps
c01020f6:	e9 a0 fc ff ff       	jmp    c0101d9b <__alltraps>

c01020fb <vector94>:
.globl vector94
vector94:
  pushl $0
c01020fb:	6a 00                	push   $0x0
  pushl $94
c01020fd:	6a 5e                	push   $0x5e
  jmp __alltraps
c01020ff:	e9 97 fc ff ff       	jmp    c0101d9b <__alltraps>

c0102104 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102104:	6a 00                	push   $0x0
  pushl $95
c0102106:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102108:	e9 8e fc ff ff       	jmp    c0101d9b <__alltraps>

c010210d <vector96>:
.globl vector96
vector96:
  pushl $0
c010210d:	6a 00                	push   $0x0
  pushl $96
c010210f:	6a 60                	push   $0x60
  jmp __alltraps
c0102111:	e9 85 fc ff ff       	jmp    c0101d9b <__alltraps>

c0102116 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102116:	6a 00                	push   $0x0
  pushl $97
c0102118:	6a 61                	push   $0x61
  jmp __alltraps
c010211a:	e9 7c fc ff ff       	jmp    c0101d9b <__alltraps>

c010211f <vector98>:
.globl vector98
vector98:
  pushl $0
c010211f:	6a 00                	push   $0x0
  pushl $98
c0102121:	6a 62                	push   $0x62
  jmp __alltraps
c0102123:	e9 73 fc ff ff       	jmp    c0101d9b <__alltraps>

c0102128 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102128:	6a 00                	push   $0x0
  pushl $99
c010212a:	6a 63                	push   $0x63
  jmp __alltraps
c010212c:	e9 6a fc ff ff       	jmp    c0101d9b <__alltraps>

c0102131 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102131:	6a 00                	push   $0x0
  pushl $100
c0102133:	6a 64                	push   $0x64
  jmp __alltraps
c0102135:	e9 61 fc ff ff       	jmp    c0101d9b <__alltraps>

c010213a <vector101>:
.globl vector101
vector101:
  pushl $0
c010213a:	6a 00                	push   $0x0
  pushl $101
c010213c:	6a 65                	push   $0x65
  jmp __alltraps
c010213e:	e9 58 fc ff ff       	jmp    c0101d9b <__alltraps>

c0102143 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102143:	6a 00                	push   $0x0
  pushl $102
c0102145:	6a 66                	push   $0x66
  jmp __alltraps
c0102147:	e9 4f fc ff ff       	jmp    c0101d9b <__alltraps>

c010214c <vector103>:
.globl vector103
vector103:
  pushl $0
c010214c:	6a 00                	push   $0x0
  pushl $103
c010214e:	6a 67                	push   $0x67
  jmp __alltraps
c0102150:	e9 46 fc ff ff       	jmp    c0101d9b <__alltraps>

c0102155 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102155:	6a 00                	push   $0x0
  pushl $104
c0102157:	6a 68                	push   $0x68
  jmp __alltraps
c0102159:	e9 3d fc ff ff       	jmp    c0101d9b <__alltraps>

c010215e <vector105>:
.globl vector105
vector105:
  pushl $0
c010215e:	6a 00                	push   $0x0
  pushl $105
c0102160:	6a 69                	push   $0x69
  jmp __alltraps
c0102162:	e9 34 fc ff ff       	jmp    c0101d9b <__alltraps>

c0102167 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102167:	6a 00                	push   $0x0
  pushl $106
c0102169:	6a 6a                	push   $0x6a
  jmp __alltraps
c010216b:	e9 2b fc ff ff       	jmp    c0101d9b <__alltraps>

c0102170 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102170:	6a 00                	push   $0x0
  pushl $107
c0102172:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102174:	e9 22 fc ff ff       	jmp    c0101d9b <__alltraps>

c0102179 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102179:	6a 00                	push   $0x0
  pushl $108
c010217b:	6a 6c                	push   $0x6c
  jmp __alltraps
c010217d:	e9 19 fc ff ff       	jmp    c0101d9b <__alltraps>

c0102182 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102182:	6a 00                	push   $0x0
  pushl $109
c0102184:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102186:	e9 10 fc ff ff       	jmp    c0101d9b <__alltraps>

c010218b <vector110>:
.globl vector110
vector110:
  pushl $0
c010218b:	6a 00                	push   $0x0
  pushl $110
c010218d:	6a 6e                	push   $0x6e
  jmp __alltraps
c010218f:	e9 07 fc ff ff       	jmp    c0101d9b <__alltraps>

c0102194 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102194:	6a 00                	push   $0x0
  pushl $111
c0102196:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102198:	e9 fe fb ff ff       	jmp    c0101d9b <__alltraps>

c010219d <vector112>:
.globl vector112
vector112:
  pushl $0
c010219d:	6a 00                	push   $0x0
  pushl $112
c010219f:	6a 70                	push   $0x70
  jmp __alltraps
c01021a1:	e9 f5 fb ff ff       	jmp    c0101d9b <__alltraps>

c01021a6 <vector113>:
.globl vector113
vector113:
  pushl $0
c01021a6:	6a 00                	push   $0x0
  pushl $113
c01021a8:	6a 71                	push   $0x71
  jmp __alltraps
c01021aa:	e9 ec fb ff ff       	jmp    c0101d9b <__alltraps>

c01021af <vector114>:
.globl vector114
vector114:
  pushl $0
c01021af:	6a 00                	push   $0x0
  pushl $114
c01021b1:	6a 72                	push   $0x72
  jmp __alltraps
c01021b3:	e9 e3 fb ff ff       	jmp    c0101d9b <__alltraps>

c01021b8 <vector115>:
.globl vector115
vector115:
  pushl $0
c01021b8:	6a 00                	push   $0x0
  pushl $115
c01021ba:	6a 73                	push   $0x73
  jmp __alltraps
c01021bc:	e9 da fb ff ff       	jmp    c0101d9b <__alltraps>

c01021c1 <vector116>:
.globl vector116
vector116:
  pushl $0
c01021c1:	6a 00                	push   $0x0
  pushl $116
c01021c3:	6a 74                	push   $0x74
  jmp __alltraps
c01021c5:	e9 d1 fb ff ff       	jmp    c0101d9b <__alltraps>

c01021ca <vector117>:
.globl vector117
vector117:
  pushl $0
c01021ca:	6a 00                	push   $0x0
  pushl $117
c01021cc:	6a 75                	push   $0x75
  jmp __alltraps
c01021ce:	e9 c8 fb ff ff       	jmp    c0101d9b <__alltraps>

c01021d3 <vector118>:
.globl vector118
vector118:
  pushl $0
c01021d3:	6a 00                	push   $0x0
  pushl $118
c01021d5:	6a 76                	push   $0x76
  jmp __alltraps
c01021d7:	e9 bf fb ff ff       	jmp    c0101d9b <__alltraps>

c01021dc <vector119>:
.globl vector119
vector119:
  pushl $0
c01021dc:	6a 00                	push   $0x0
  pushl $119
c01021de:	6a 77                	push   $0x77
  jmp __alltraps
c01021e0:	e9 b6 fb ff ff       	jmp    c0101d9b <__alltraps>

c01021e5 <vector120>:
.globl vector120
vector120:
  pushl $0
c01021e5:	6a 00                	push   $0x0
  pushl $120
c01021e7:	6a 78                	push   $0x78
  jmp __alltraps
c01021e9:	e9 ad fb ff ff       	jmp    c0101d9b <__alltraps>

c01021ee <vector121>:
.globl vector121
vector121:
  pushl $0
c01021ee:	6a 00                	push   $0x0
  pushl $121
c01021f0:	6a 79                	push   $0x79
  jmp __alltraps
c01021f2:	e9 a4 fb ff ff       	jmp    c0101d9b <__alltraps>

c01021f7 <vector122>:
.globl vector122
vector122:
  pushl $0
c01021f7:	6a 00                	push   $0x0
  pushl $122
c01021f9:	6a 7a                	push   $0x7a
  jmp __alltraps
c01021fb:	e9 9b fb ff ff       	jmp    c0101d9b <__alltraps>

c0102200 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102200:	6a 00                	push   $0x0
  pushl $123
c0102202:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102204:	e9 92 fb ff ff       	jmp    c0101d9b <__alltraps>

c0102209 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102209:	6a 00                	push   $0x0
  pushl $124
c010220b:	6a 7c                	push   $0x7c
  jmp __alltraps
c010220d:	e9 89 fb ff ff       	jmp    c0101d9b <__alltraps>

c0102212 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102212:	6a 00                	push   $0x0
  pushl $125
c0102214:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102216:	e9 80 fb ff ff       	jmp    c0101d9b <__alltraps>

c010221b <vector126>:
.globl vector126
vector126:
  pushl $0
c010221b:	6a 00                	push   $0x0
  pushl $126
c010221d:	6a 7e                	push   $0x7e
  jmp __alltraps
c010221f:	e9 77 fb ff ff       	jmp    c0101d9b <__alltraps>

c0102224 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102224:	6a 00                	push   $0x0
  pushl $127
c0102226:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102228:	e9 6e fb ff ff       	jmp    c0101d9b <__alltraps>

c010222d <vector128>:
.globl vector128
vector128:
  pushl $0
c010222d:	6a 00                	push   $0x0
  pushl $128
c010222f:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102234:	e9 62 fb ff ff       	jmp    c0101d9b <__alltraps>

c0102239 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102239:	6a 00                	push   $0x0
  pushl $129
c010223b:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102240:	e9 56 fb ff ff       	jmp    c0101d9b <__alltraps>

c0102245 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102245:	6a 00                	push   $0x0
  pushl $130
c0102247:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c010224c:	e9 4a fb ff ff       	jmp    c0101d9b <__alltraps>

c0102251 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102251:	6a 00                	push   $0x0
  pushl $131
c0102253:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102258:	e9 3e fb ff ff       	jmp    c0101d9b <__alltraps>

c010225d <vector132>:
.globl vector132
vector132:
  pushl $0
c010225d:	6a 00                	push   $0x0
  pushl $132
c010225f:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102264:	e9 32 fb ff ff       	jmp    c0101d9b <__alltraps>

c0102269 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102269:	6a 00                	push   $0x0
  pushl $133
c010226b:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102270:	e9 26 fb ff ff       	jmp    c0101d9b <__alltraps>

c0102275 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102275:	6a 00                	push   $0x0
  pushl $134
c0102277:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c010227c:	e9 1a fb ff ff       	jmp    c0101d9b <__alltraps>

c0102281 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102281:	6a 00                	push   $0x0
  pushl $135
c0102283:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102288:	e9 0e fb ff ff       	jmp    c0101d9b <__alltraps>

c010228d <vector136>:
.globl vector136
vector136:
  pushl $0
c010228d:	6a 00                	push   $0x0
  pushl $136
c010228f:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102294:	e9 02 fb ff ff       	jmp    c0101d9b <__alltraps>

c0102299 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102299:	6a 00                	push   $0x0
  pushl $137
c010229b:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c01022a0:	e9 f6 fa ff ff       	jmp    c0101d9b <__alltraps>

c01022a5 <vector138>:
.globl vector138
vector138:
  pushl $0
c01022a5:	6a 00                	push   $0x0
  pushl $138
c01022a7:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c01022ac:	e9 ea fa ff ff       	jmp    c0101d9b <__alltraps>

c01022b1 <vector139>:
.globl vector139
vector139:
  pushl $0
c01022b1:	6a 00                	push   $0x0
  pushl $139
c01022b3:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c01022b8:	e9 de fa ff ff       	jmp    c0101d9b <__alltraps>

c01022bd <vector140>:
.globl vector140
vector140:
  pushl $0
c01022bd:	6a 00                	push   $0x0
  pushl $140
c01022bf:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c01022c4:	e9 d2 fa ff ff       	jmp    c0101d9b <__alltraps>

c01022c9 <vector141>:
.globl vector141
vector141:
  pushl $0
c01022c9:	6a 00                	push   $0x0
  pushl $141
c01022cb:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c01022d0:	e9 c6 fa ff ff       	jmp    c0101d9b <__alltraps>

c01022d5 <vector142>:
.globl vector142
vector142:
  pushl $0
c01022d5:	6a 00                	push   $0x0
  pushl $142
c01022d7:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01022dc:	e9 ba fa ff ff       	jmp    c0101d9b <__alltraps>

c01022e1 <vector143>:
.globl vector143
vector143:
  pushl $0
c01022e1:	6a 00                	push   $0x0
  pushl $143
c01022e3:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01022e8:	e9 ae fa ff ff       	jmp    c0101d9b <__alltraps>

c01022ed <vector144>:
.globl vector144
vector144:
  pushl $0
c01022ed:	6a 00                	push   $0x0
  pushl $144
c01022ef:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01022f4:	e9 a2 fa ff ff       	jmp    c0101d9b <__alltraps>

c01022f9 <vector145>:
.globl vector145
vector145:
  pushl $0
c01022f9:	6a 00                	push   $0x0
  pushl $145
c01022fb:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102300:	e9 96 fa ff ff       	jmp    c0101d9b <__alltraps>

c0102305 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102305:	6a 00                	push   $0x0
  pushl $146
c0102307:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c010230c:	e9 8a fa ff ff       	jmp    c0101d9b <__alltraps>

c0102311 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102311:	6a 00                	push   $0x0
  pushl $147
c0102313:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102318:	e9 7e fa ff ff       	jmp    c0101d9b <__alltraps>

c010231d <vector148>:
.globl vector148
vector148:
  pushl $0
c010231d:	6a 00                	push   $0x0
  pushl $148
c010231f:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102324:	e9 72 fa ff ff       	jmp    c0101d9b <__alltraps>

c0102329 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102329:	6a 00                	push   $0x0
  pushl $149
c010232b:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102330:	e9 66 fa ff ff       	jmp    c0101d9b <__alltraps>

c0102335 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102335:	6a 00                	push   $0x0
  pushl $150
c0102337:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c010233c:	e9 5a fa ff ff       	jmp    c0101d9b <__alltraps>

c0102341 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102341:	6a 00                	push   $0x0
  pushl $151
c0102343:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102348:	e9 4e fa ff ff       	jmp    c0101d9b <__alltraps>

c010234d <vector152>:
.globl vector152
vector152:
  pushl $0
c010234d:	6a 00                	push   $0x0
  pushl $152
c010234f:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102354:	e9 42 fa ff ff       	jmp    c0101d9b <__alltraps>

c0102359 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102359:	6a 00                	push   $0x0
  pushl $153
c010235b:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102360:	e9 36 fa ff ff       	jmp    c0101d9b <__alltraps>

c0102365 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102365:	6a 00                	push   $0x0
  pushl $154
c0102367:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c010236c:	e9 2a fa ff ff       	jmp    c0101d9b <__alltraps>

c0102371 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102371:	6a 00                	push   $0x0
  pushl $155
c0102373:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102378:	e9 1e fa ff ff       	jmp    c0101d9b <__alltraps>

c010237d <vector156>:
.globl vector156
vector156:
  pushl $0
c010237d:	6a 00                	push   $0x0
  pushl $156
c010237f:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102384:	e9 12 fa ff ff       	jmp    c0101d9b <__alltraps>

c0102389 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102389:	6a 00                	push   $0x0
  pushl $157
c010238b:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102390:	e9 06 fa ff ff       	jmp    c0101d9b <__alltraps>

c0102395 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102395:	6a 00                	push   $0x0
  pushl $158
c0102397:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c010239c:	e9 fa f9 ff ff       	jmp    c0101d9b <__alltraps>

c01023a1 <vector159>:
.globl vector159
vector159:
  pushl $0
c01023a1:	6a 00                	push   $0x0
  pushl $159
c01023a3:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c01023a8:	e9 ee f9 ff ff       	jmp    c0101d9b <__alltraps>

c01023ad <vector160>:
.globl vector160
vector160:
  pushl $0
c01023ad:	6a 00                	push   $0x0
  pushl $160
c01023af:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c01023b4:	e9 e2 f9 ff ff       	jmp    c0101d9b <__alltraps>

c01023b9 <vector161>:
.globl vector161
vector161:
  pushl $0
c01023b9:	6a 00                	push   $0x0
  pushl $161
c01023bb:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c01023c0:	e9 d6 f9 ff ff       	jmp    c0101d9b <__alltraps>

c01023c5 <vector162>:
.globl vector162
vector162:
  pushl $0
c01023c5:	6a 00                	push   $0x0
  pushl $162
c01023c7:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c01023cc:	e9 ca f9 ff ff       	jmp    c0101d9b <__alltraps>

c01023d1 <vector163>:
.globl vector163
vector163:
  pushl $0
c01023d1:	6a 00                	push   $0x0
  pushl $163
c01023d3:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01023d8:	e9 be f9 ff ff       	jmp    c0101d9b <__alltraps>

c01023dd <vector164>:
.globl vector164
vector164:
  pushl $0
c01023dd:	6a 00                	push   $0x0
  pushl $164
c01023df:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01023e4:	e9 b2 f9 ff ff       	jmp    c0101d9b <__alltraps>

c01023e9 <vector165>:
.globl vector165
vector165:
  pushl $0
c01023e9:	6a 00                	push   $0x0
  pushl $165
c01023eb:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01023f0:	e9 a6 f9 ff ff       	jmp    c0101d9b <__alltraps>

c01023f5 <vector166>:
.globl vector166
vector166:
  pushl $0
c01023f5:	6a 00                	push   $0x0
  pushl $166
c01023f7:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c01023fc:	e9 9a f9 ff ff       	jmp    c0101d9b <__alltraps>

c0102401 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102401:	6a 00                	push   $0x0
  pushl $167
c0102403:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102408:	e9 8e f9 ff ff       	jmp    c0101d9b <__alltraps>

c010240d <vector168>:
.globl vector168
vector168:
  pushl $0
c010240d:	6a 00                	push   $0x0
  pushl $168
c010240f:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102414:	e9 82 f9 ff ff       	jmp    c0101d9b <__alltraps>

c0102419 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102419:	6a 00                	push   $0x0
  pushl $169
c010241b:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102420:	e9 76 f9 ff ff       	jmp    c0101d9b <__alltraps>

c0102425 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102425:	6a 00                	push   $0x0
  pushl $170
c0102427:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c010242c:	e9 6a f9 ff ff       	jmp    c0101d9b <__alltraps>

c0102431 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102431:	6a 00                	push   $0x0
  pushl $171
c0102433:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102438:	e9 5e f9 ff ff       	jmp    c0101d9b <__alltraps>

c010243d <vector172>:
.globl vector172
vector172:
  pushl $0
c010243d:	6a 00                	push   $0x0
  pushl $172
c010243f:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102444:	e9 52 f9 ff ff       	jmp    c0101d9b <__alltraps>

c0102449 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102449:	6a 00                	push   $0x0
  pushl $173
c010244b:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102450:	e9 46 f9 ff ff       	jmp    c0101d9b <__alltraps>

c0102455 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102455:	6a 00                	push   $0x0
  pushl $174
c0102457:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c010245c:	e9 3a f9 ff ff       	jmp    c0101d9b <__alltraps>

c0102461 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102461:	6a 00                	push   $0x0
  pushl $175
c0102463:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102468:	e9 2e f9 ff ff       	jmp    c0101d9b <__alltraps>

c010246d <vector176>:
.globl vector176
vector176:
  pushl $0
c010246d:	6a 00                	push   $0x0
  pushl $176
c010246f:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102474:	e9 22 f9 ff ff       	jmp    c0101d9b <__alltraps>

c0102479 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102479:	6a 00                	push   $0x0
  pushl $177
c010247b:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102480:	e9 16 f9 ff ff       	jmp    c0101d9b <__alltraps>

c0102485 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102485:	6a 00                	push   $0x0
  pushl $178
c0102487:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c010248c:	e9 0a f9 ff ff       	jmp    c0101d9b <__alltraps>

c0102491 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102491:	6a 00                	push   $0x0
  pushl $179
c0102493:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102498:	e9 fe f8 ff ff       	jmp    c0101d9b <__alltraps>

c010249d <vector180>:
.globl vector180
vector180:
  pushl $0
c010249d:	6a 00                	push   $0x0
  pushl $180
c010249f:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c01024a4:	e9 f2 f8 ff ff       	jmp    c0101d9b <__alltraps>

c01024a9 <vector181>:
.globl vector181
vector181:
  pushl $0
c01024a9:	6a 00                	push   $0x0
  pushl $181
c01024ab:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c01024b0:	e9 e6 f8 ff ff       	jmp    c0101d9b <__alltraps>

c01024b5 <vector182>:
.globl vector182
vector182:
  pushl $0
c01024b5:	6a 00                	push   $0x0
  pushl $182
c01024b7:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c01024bc:	e9 da f8 ff ff       	jmp    c0101d9b <__alltraps>

c01024c1 <vector183>:
.globl vector183
vector183:
  pushl $0
c01024c1:	6a 00                	push   $0x0
  pushl $183
c01024c3:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c01024c8:	e9 ce f8 ff ff       	jmp    c0101d9b <__alltraps>

c01024cd <vector184>:
.globl vector184
vector184:
  pushl $0
c01024cd:	6a 00                	push   $0x0
  pushl $184
c01024cf:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c01024d4:	e9 c2 f8 ff ff       	jmp    c0101d9b <__alltraps>

c01024d9 <vector185>:
.globl vector185
vector185:
  pushl $0
c01024d9:	6a 00                	push   $0x0
  pushl $185
c01024db:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01024e0:	e9 b6 f8 ff ff       	jmp    c0101d9b <__alltraps>

c01024e5 <vector186>:
.globl vector186
vector186:
  pushl $0
c01024e5:	6a 00                	push   $0x0
  pushl $186
c01024e7:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01024ec:	e9 aa f8 ff ff       	jmp    c0101d9b <__alltraps>

c01024f1 <vector187>:
.globl vector187
vector187:
  pushl $0
c01024f1:	6a 00                	push   $0x0
  pushl $187
c01024f3:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01024f8:	e9 9e f8 ff ff       	jmp    c0101d9b <__alltraps>

c01024fd <vector188>:
.globl vector188
vector188:
  pushl $0
c01024fd:	6a 00                	push   $0x0
  pushl $188
c01024ff:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102504:	e9 92 f8 ff ff       	jmp    c0101d9b <__alltraps>

c0102509 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102509:	6a 00                	push   $0x0
  pushl $189
c010250b:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102510:	e9 86 f8 ff ff       	jmp    c0101d9b <__alltraps>

c0102515 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102515:	6a 00                	push   $0x0
  pushl $190
c0102517:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c010251c:	e9 7a f8 ff ff       	jmp    c0101d9b <__alltraps>

c0102521 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102521:	6a 00                	push   $0x0
  pushl $191
c0102523:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102528:	e9 6e f8 ff ff       	jmp    c0101d9b <__alltraps>

c010252d <vector192>:
.globl vector192
vector192:
  pushl $0
c010252d:	6a 00                	push   $0x0
  pushl $192
c010252f:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102534:	e9 62 f8 ff ff       	jmp    c0101d9b <__alltraps>

c0102539 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102539:	6a 00                	push   $0x0
  pushl $193
c010253b:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102540:	e9 56 f8 ff ff       	jmp    c0101d9b <__alltraps>

c0102545 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102545:	6a 00                	push   $0x0
  pushl $194
c0102547:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c010254c:	e9 4a f8 ff ff       	jmp    c0101d9b <__alltraps>

c0102551 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102551:	6a 00                	push   $0x0
  pushl $195
c0102553:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102558:	e9 3e f8 ff ff       	jmp    c0101d9b <__alltraps>

c010255d <vector196>:
.globl vector196
vector196:
  pushl $0
c010255d:	6a 00                	push   $0x0
  pushl $196
c010255f:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102564:	e9 32 f8 ff ff       	jmp    c0101d9b <__alltraps>

c0102569 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102569:	6a 00                	push   $0x0
  pushl $197
c010256b:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102570:	e9 26 f8 ff ff       	jmp    c0101d9b <__alltraps>

c0102575 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102575:	6a 00                	push   $0x0
  pushl $198
c0102577:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c010257c:	e9 1a f8 ff ff       	jmp    c0101d9b <__alltraps>

c0102581 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102581:	6a 00                	push   $0x0
  pushl $199
c0102583:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102588:	e9 0e f8 ff ff       	jmp    c0101d9b <__alltraps>

c010258d <vector200>:
.globl vector200
vector200:
  pushl $0
c010258d:	6a 00                	push   $0x0
  pushl $200
c010258f:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102594:	e9 02 f8 ff ff       	jmp    c0101d9b <__alltraps>

c0102599 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102599:	6a 00                	push   $0x0
  pushl $201
c010259b:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01025a0:	e9 f6 f7 ff ff       	jmp    c0101d9b <__alltraps>

c01025a5 <vector202>:
.globl vector202
vector202:
  pushl $0
c01025a5:	6a 00                	push   $0x0
  pushl $202
c01025a7:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c01025ac:	e9 ea f7 ff ff       	jmp    c0101d9b <__alltraps>

c01025b1 <vector203>:
.globl vector203
vector203:
  pushl $0
c01025b1:	6a 00                	push   $0x0
  pushl $203
c01025b3:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c01025b8:	e9 de f7 ff ff       	jmp    c0101d9b <__alltraps>

c01025bd <vector204>:
.globl vector204
vector204:
  pushl $0
c01025bd:	6a 00                	push   $0x0
  pushl $204
c01025bf:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c01025c4:	e9 d2 f7 ff ff       	jmp    c0101d9b <__alltraps>

c01025c9 <vector205>:
.globl vector205
vector205:
  pushl $0
c01025c9:	6a 00                	push   $0x0
  pushl $205
c01025cb:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c01025d0:	e9 c6 f7 ff ff       	jmp    c0101d9b <__alltraps>

c01025d5 <vector206>:
.globl vector206
vector206:
  pushl $0
c01025d5:	6a 00                	push   $0x0
  pushl $206
c01025d7:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01025dc:	e9 ba f7 ff ff       	jmp    c0101d9b <__alltraps>

c01025e1 <vector207>:
.globl vector207
vector207:
  pushl $0
c01025e1:	6a 00                	push   $0x0
  pushl $207
c01025e3:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01025e8:	e9 ae f7 ff ff       	jmp    c0101d9b <__alltraps>

c01025ed <vector208>:
.globl vector208
vector208:
  pushl $0
c01025ed:	6a 00                	push   $0x0
  pushl $208
c01025ef:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01025f4:	e9 a2 f7 ff ff       	jmp    c0101d9b <__alltraps>

c01025f9 <vector209>:
.globl vector209
vector209:
  pushl $0
c01025f9:	6a 00                	push   $0x0
  pushl $209
c01025fb:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102600:	e9 96 f7 ff ff       	jmp    c0101d9b <__alltraps>

c0102605 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102605:	6a 00                	push   $0x0
  pushl $210
c0102607:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c010260c:	e9 8a f7 ff ff       	jmp    c0101d9b <__alltraps>

c0102611 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102611:	6a 00                	push   $0x0
  pushl $211
c0102613:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102618:	e9 7e f7 ff ff       	jmp    c0101d9b <__alltraps>

c010261d <vector212>:
.globl vector212
vector212:
  pushl $0
c010261d:	6a 00                	push   $0x0
  pushl $212
c010261f:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102624:	e9 72 f7 ff ff       	jmp    c0101d9b <__alltraps>

c0102629 <vector213>:
.globl vector213
vector213:
  pushl $0
c0102629:	6a 00                	push   $0x0
  pushl $213
c010262b:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102630:	e9 66 f7 ff ff       	jmp    c0101d9b <__alltraps>

c0102635 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102635:	6a 00                	push   $0x0
  pushl $214
c0102637:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c010263c:	e9 5a f7 ff ff       	jmp    c0101d9b <__alltraps>

c0102641 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102641:	6a 00                	push   $0x0
  pushl $215
c0102643:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102648:	e9 4e f7 ff ff       	jmp    c0101d9b <__alltraps>

c010264d <vector216>:
.globl vector216
vector216:
  pushl $0
c010264d:	6a 00                	push   $0x0
  pushl $216
c010264f:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102654:	e9 42 f7 ff ff       	jmp    c0101d9b <__alltraps>

c0102659 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102659:	6a 00                	push   $0x0
  pushl $217
c010265b:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102660:	e9 36 f7 ff ff       	jmp    c0101d9b <__alltraps>

c0102665 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102665:	6a 00                	push   $0x0
  pushl $218
c0102667:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c010266c:	e9 2a f7 ff ff       	jmp    c0101d9b <__alltraps>

c0102671 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102671:	6a 00                	push   $0x0
  pushl $219
c0102673:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102678:	e9 1e f7 ff ff       	jmp    c0101d9b <__alltraps>

c010267d <vector220>:
.globl vector220
vector220:
  pushl $0
c010267d:	6a 00                	push   $0x0
  pushl $220
c010267f:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102684:	e9 12 f7 ff ff       	jmp    c0101d9b <__alltraps>

c0102689 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102689:	6a 00                	push   $0x0
  pushl $221
c010268b:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102690:	e9 06 f7 ff ff       	jmp    c0101d9b <__alltraps>

c0102695 <vector222>:
.globl vector222
vector222:
  pushl $0
c0102695:	6a 00                	push   $0x0
  pushl $222
c0102697:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c010269c:	e9 fa f6 ff ff       	jmp    c0101d9b <__alltraps>

c01026a1 <vector223>:
.globl vector223
vector223:
  pushl $0
c01026a1:	6a 00                	push   $0x0
  pushl $223
c01026a3:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01026a8:	e9 ee f6 ff ff       	jmp    c0101d9b <__alltraps>

c01026ad <vector224>:
.globl vector224
vector224:
  pushl $0
c01026ad:	6a 00                	push   $0x0
  pushl $224
c01026af:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01026b4:	e9 e2 f6 ff ff       	jmp    c0101d9b <__alltraps>

c01026b9 <vector225>:
.globl vector225
vector225:
  pushl $0
c01026b9:	6a 00                	push   $0x0
  pushl $225
c01026bb:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01026c0:	e9 d6 f6 ff ff       	jmp    c0101d9b <__alltraps>

c01026c5 <vector226>:
.globl vector226
vector226:
  pushl $0
c01026c5:	6a 00                	push   $0x0
  pushl $226
c01026c7:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01026cc:	e9 ca f6 ff ff       	jmp    c0101d9b <__alltraps>

c01026d1 <vector227>:
.globl vector227
vector227:
  pushl $0
c01026d1:	6a 00                	push   $0x0
  pushl $227
c01026d3:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01026d8:	e9 be f6 ff ff       	jmp    c0101d9b <__alltraps>

c01026dd <vector228>:
.globl vector228
vector228:
  pushl $0
c01026dd:	6a 00                	push   $0x0
  pushl $228
c01026df:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01026e4:	e9 b2 f6 ff ff       	jmp    c0101d9b <__alltraps>

c01026e9 <vector229>:
.globl vector229
vector229:
  pushl $0
c01026e9:	6a 00                	push   $0x0
  pushl $229
c01026eb:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01026f0:	e9 a6 f6 ff ff       	jmp    c0101d9b <__alltraps>

c01026f5 <vector230>:
.globl vector230
vector230:
  pushl $0
c01026f5:	6a 00                	push   $0x0
  pushl $230
c01026f7:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01026fc:	e9 9a f6 ff ff       	jmp    c0101d9b <__alltraps>

c0102701 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102701:	6a 00                	push   $0x0
  pushl $231
c0102703:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0102708:	e9 8e f6 ff ff       	jmp    c0101d9b <__alltraps>

c010270d <vector232>:
.globl vector232
vector232:
  pushl $0
c010270d:	6a 00                	push   $0x0
  pushl $232
c010270f:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102714:	e9 82 f6 ff ff       	jmp    c0101d9b <__alltraps>

c0102719 <vector233>:
.globl vector233
vector233:
  pushl $0
c0102719:	6a 00                	push   $0x0
  pushl $233
c010271b:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102720:	e9 76 f6 ff ff       	jmp    c0101d9b <__alltraps>

c0102725 <vector234>:
.globl vector234
vector234:
  pushl $0
c0102725:	6a 00                	push   $0x0
  pushl $234
c0102727:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c010272c:	e9 6a f6 ff ff       	jmp    c0101d9b <__alltraps>

c0102731 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102731:	6a 00                	push   $0x0
  pushl $235
c0102733:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102738:	e9 5e f6 ff ff       	jmp    c0101d9b <__alltraps>

c010273d <vector236>:
.globl vector236
vector236:
  pushl $0
c010273d:	6a 00                	push   $0x0
  pushl $236
c010273f:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102744:	e9 52 f6 ff ff       	jmp    c0101d9b <__alltraps>

c0102749 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102749:	6a 00                	push   $0x0
  pushl $237
c010274b:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102750:	e9 46 f6 ff ff       	jmp    c0101d9b <__alltraps>

c0102755 <vector238>:
.globl vector238
vector238:
  pushl $0
c0102755:	6a 00                	push   $0x0
  pushl $238
c0102757:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c010275c:	e9 3a f6 ff ff       	jmp    c0101d9b <__alltraps>

c0102761 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102761:	6a 00                	push   $0x0
  pushl $239
c0102763:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102768:	e9 2e f6 ff ff       	jmp    c0101d9b <__alltraps>

c010276d <vector240>:
.globl vector240
vector240:
  pushl $0
c010276d:	6a 00                	push   $0x0
  pushl $240
c010276f:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102774:	e9 22 f6 ff ff       	jmp    c0101d9b <__alltraps>

c0102779 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102779:	6a 00                	push   $0x0
  pushl $241
c010277b:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102780:	e9 16 f6 ff ff       	jmp    c0101d9b <__alltraps>

c0102785 <vector242>:
.globl vector242
vector242:
  pushl $0
c0102785:	6a 00                	push   $0x0
  pushl $242
c0102787:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c010278c:	e9 0a f6 ff ff       	jmp    c0101d9b <__alltraps>

c0102791 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102791:	6a 00                	push   $0x0
  pushl $243
c0102793:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102798:	e9 fe f5 ff ff       	jmp    c0101d9b <__alltraps>

c010279d <vector244>:
.globl vector244
vector244:
  pushl $0
c010279d:	6a 00                	push   $0x0
  pushl $244
c010279f:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01027a4:	e9 f2 f5 ff ff       	jmp    c0101d9b <__alltraps>

c01027a9 <vector245>:
.globl vector245
vector245:
  pushl $0
c01027a9:	6a 00                	push   $0x0
  pushl $245
c01027ab:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01027b0:	e9 e6 f5 ff ff       	jmp    c0101d9b <__alltraps>

c01027b5 <vector246>:
.globl vector246
vector246:
  pushl $0
c01027b5:	6a 00                	push   $0x0
  pushl $246
c01027b7:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01027bc:	e9 da f5 ff ff       	jmp    c0101d9b <__alltraps>

c01027c1 <vector247>:
.globl vector247
vector247:
  pushl $0
c01027c1:	6a 00                	push   $0x0
  pushl $247
c01027c3:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01027c8:	e9 ce f5 ff ff       	jmp    c0101d9b <__alltraps>

c01027cd <vector248>:
.globl vector248
vector248:
  pushl $0
c01027cd:	6a 00                	push   $0x0
  pushl $248
c01027cf:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01027d4:	e9 c2 f5 ff ff       	jmp    c0101d9b <__alltraps>

c01027d9 <vector249>:
.globl vector249
vector249:
  pushl $0
c01027d9:	6a 00                	push   $0x0
  pushl $249
c01027db:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01027e0:	e9 b6 f5 ff ff       	jmp    c0101d9b <__alltraps>

c01027e5 <vector250>:
.globl vector250
vector250:
  pushl $0
c01027e5:	6a 00                	push   $0x0
  pushl $250
c01027e7:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01027ec:	e9 aa f5 ff ff       	jmp    c0101d9b <__alltraps>

c01027f1 <vector251>:
.globl vector251
vector251:
  pushl $0
c01027f1:	6a 00                	push   $0x0
  pushl $251
c01027f3:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01027f8:	e9 9e f5 ff ff       	jmp    c0101d9b <__alltraps>

c01027fd <vector252>:
.globl vector252
vector252:
  pushl $0
c01027fd:	6a 00                	push   $0x0
  pushl $252
c01027ff:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102804:	e9 92 f5 ff ff       	jmp    c0101d9b <__alltraps>

c0102809 <vector253>:
.globl vector253
vector253:
  pushl $0
c0102809:	6a 00                	push   $0x0
  pushl $253
c010280b:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102810:	e9 86 f5 ff ff       	jmp    c0101d9b <__alltraps>

c0102815 <vector254>:
.globl vector254
vector254:
  pushl $0
c0102815:	6a 00                	push   $0x0
  pushl $254
c0102817:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c010281c:	e9 7a f5 ff ff       	jmp    c0101d9b <__alltraps>

c0102821 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102821:	6a 00                	push   $0x0
  pushl $255
c0102823:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102828:	e9 6e f5 ff ff       	jmp    c0101d9b <__alltraps>

c010282d <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010282d:	55                   	push   %ebp
c010282e:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102830:	8b 55 08             	mov    0x8(%ebp),%edx
c0102833:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0102838:	29 c2                	sub    %eax,%edx
c010283a:	89 d0                	mov    %edx,%eax
c010283c:	c1 f8 02             	sar    $0x2,%eax
c010283f:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102845:	5d                   	pop    %ebp
c0102846:	c3                   	ret    

c0102847 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102847:	55                   	push   %ebp
c0102848:	89 e5                	mov    %esp,%ebp
c010284a:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010284d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102850:	89 04 24             	mov    %eax,(%esp)
c0102853:	e8 d5 ff ff ff       	call   c010282d <page2ppn>
c0102858:	c1 e0 0c             	shl    $0xc,%eax
}
c010285b:	c9                   	leave  
c010285c:	c3                   	ret    

c010285d <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c010285d:	55                   	push   %ebp
c010285e:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102860:	8b 45 08             	mov    0x8(%ebp),%eax
c0102863:	8b 00                	mov    (%eax),%eax
}
c0102865:	5d                   	pop    %ebp
c0102866:	c3                   	ret    

c0102867 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102867:	55                   	push   %ebp
c0102868:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c010286a:	8b 45 08             	mov    0x8(%ebp),%eax
c010286d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102870:	89 10                	mov    %edx,(%eax)
}
c0102872:	5d                   	pop    %ebp
c0102873:	c3                   	ret    

c0102874 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0102874:	55                   	push   %ebp
c0102875:	89 e5                	mov    %esp,%ebp
c0102877:	83 ec 10             	sub    $0x10,%esp
c010287a:	c7 45 fc 50 89 11 c0 	movl   $0xc0118950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0102881:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102884:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102887:	89 50 04             	mov    %edx,0x4(%eax)
c010288a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010288d:	8b 50 04             	mov    0x4(%eax),%edx
c0102890:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102893:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0102895:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c010289c:	00 00 00 
}
c010289f:	c9                   	leave  
c01028a0:	c3                   	ret    

c01028a1 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c01028a1:	55                   	push   %ebp
c01028a2:	89 e5                	mov    %esp,%ebp
c01028a4:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c01028a7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01028ab:	75 24                	jne    c01028d1 <default_init_memmap+0x30>
c01028ad:	c7 44 24 0c 30 66 10 	movl   $0xc0106630,0xc(%esp)
c01028b4:	c0 
c01028b5:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c01028bc:	c0 
c01028bd:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c01028c4:	00 
c01028c5:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c01028cc:	e8 f5 e3 ff ff       	call   c0100cc6 <__panic>
    struct Page *p = base;
c01028d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01028d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01028d7:	e9 dc 00 00 00       	jmp    c01029b8 <default_init_memmap+0x117>
        assert(PageReserved(p));
c01028dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028df:	83 c0 04             	add    $0x4,%eax
c01028e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01028e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01028ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01028ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01028f2:	0f a3 10             	bt     %edx,(%eax)
c01028f5:	19 c0                	sbb    %eax,%eax
c01028f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01028fa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01028fe:	0f 95 c0             	setne  %al
c0102901:	0f b6 c0             	movzbl %al,%eax
c0102904:	85 c0                	test   %eax,%eax
c0102906:	75 24                	jne    c010292c <default_init_memmap+0x8b>
c0102908:	c7 44 24 0c 61 66 10 	movl   $0xc0106661,0xc(%esp)
c010290f:	c0 
c0102910:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c0102917:	c0 
c0102918:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c010291f:	00 
c0102920:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c0102927:	e8 9a e3 ff ff       	call   c0100cc6 <__panic>
        p->flags = 0;
c010292c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010292f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        SetPageProperty(p);
c0102936:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102939:	83 c0 04             	add    $0x4,%eax
c010293c:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0102943:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102946:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102949:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010294c:	0f ab 10             	bts    %edx,(%eax)
        p->property = 0;
c010294f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102952:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0);
c0102959:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102960:	00 
c0102961:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102964:	89 04 24             	mov    %eax,(%esp)
c0102967:	e8 fb fe ff ff       	call   c0102867 <set_page_ref>
        list_add_before(&free_list, &(p->page_link));
c010296c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010296f:	83 c0 0c             	add    $0xc,%eax
c0102972:	c7 45 dc 50 89 11 c0 	movl   $0xc0118950,-0x24(%ebp)
c0102979:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c010297c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010297f:	8b 00                	mov    (%eax),%eax
c0102981:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102984:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102987:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010298a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010298d:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102990:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102993:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102996:	89 10                	mov    %edx,(%eax)
c0102998:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010299b:	8b 10                	mov    (%eax),%edx
c010299d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01029a0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01029a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01029a6:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01029a9:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01029ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01029af:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01029b2:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c01029b4:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c01029b8:	8b 55 0c             	mov    0xc(%ebp),%edx
c01029bb:	89 d0                	mov    %edx,%eax
c01029bd:	c1 e0 02             	shl    $0x2,%eax
c01029c0:	01 d0                	add    %edx,%eax
c01029c2:	c1 e0 02             	shl    $0x2,%eax
c01029c5:	89 c2                	mov    %eax,%edx
c01029c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01029ca:	01 d0                	add    %edx,%eax
c01029cc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01029cf:	0f 85 07 ff ff ff    	jne    c01028dc <default_init_memmap+0x3b>
        SetPageProperty(p);
        p->property = 0;
        set_page_ref(p, 0);
        list_add_before(&free_list, &(p->page_link));
    }
    nr_free += n;
c01029d5:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c01029db:	8b 45 0c             	mov    0xc(%ebp),%eax
c01029de:	01 d0                	add    %edx,%eax
c01029e0:	a3 58 89 11 c0       	mov    %eax,0xc0118958
    //first block
    base->property = n;
c01029e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01029e8:	8b 55 0c             	mov    0xc(%ebp),%edx
c01029eb:	89 50 08             	mov    %edx,0x8(%eax)
}
c01029ee:	c9                   	leave  
c01029ef:	c3                   	ret    

c01029f0 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c01029f0:	55                   	push   %ebp
c01029f1:	89 e5                	mov    %esp,%ebp
c01029f3:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c01029f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01029fa:	75 24                	jne    c0102a20 <default_alloc_pages+0x30>
c01029fc:	c7 44 24 0c 30 66 10 	movl   $0xc0106630,0xc(%esp)
c0102a03:	c0 
c0102a04:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c0102a0b:	c0 
c0102a0c:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
c0102a13:	00 
c0102a14:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c0102a1b:	e8 a6 e2 ff ff       	call   c0100cc6 <__panic>
    if (n > nr_free) {
c0102a20:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102a25:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102a28:	73 0a                	jae    c0102a34 <default_alloc_pages+0x44>
        return NULL;
c0102a2a:	b8 00 00 00 00       	mov    $0x0,%eax
c0102a2f:	e9 37 01 00 00       	jmp    c0102b6b <default_alloc_pages+0x17b>
    }
    list_entry_t *le, *len;
    le = &free_list;
c0102a34:	c7 45 f4 50 89 11 c0 	movl   $0xc0118950,-0xc(%ebp)

    while((le=list_next(le)) != &free_list) {
c0102a3b:	e9 0a 01 00 00       	jmp    c0102b4a <default_alloc_pages+0x15a>
      struct Page *p = le2page(le, page_link);
c0102a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a43:	83 e8 0c             	sub    $0xc,%eax
c0102a46:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(p->property >= n){
c0102a49:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102a4c:	8b 40 08             	mov    0x8(%eax),%eax
c0102a4f:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102a52:	0f 82 f2 00 00 00    	jb     c0102b4a <default_alloc_pages+0x15a>
        int i;
        for(i=0;i<n;i++){
c0102a58:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102a5f:	eb 7c                	jmp    c0102add <default_alloc_pages+0xed>
c0102a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a64:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102a67:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102a6a:	8b 40 04             	mov    0x4(%eax),%eax
          len = list_next(le);
c0102a6d:	89 45 e8             	mov    %eax,-0x18(%ebp)
          struct Page *pp = le2page(le, page_link);
c0102a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a73:	83 e8 0c             	sub    $0xc,%eax
c0102a76:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          SetPageReserved(pp);
c0102a79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102a7c:	83 c0 04             	add    $0x4,%eax
c0102a7f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102a86:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0102a89:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102a8c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102a8f:	0f ab 10             	bts    %edx,(%eax)
          ClearPageProperty(pp);
c0102a92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102a95:	83 c0 04             	add    $0x4,%eax
c0102a98:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0102a9f:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102aa2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102aa5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102aa8:	0f b3 10             	btr    %edx,(%eax)
c0102aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102aae:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102ab1:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102ab4:	8b 40 04             	mov    0x4(%eax),%eax
c0102ab7:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102aba:	8b 12                	mov    (%edx),%edx
c0102abc:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0102abf:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102ac2:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102ac5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102ac8:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102acb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102ace:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102ad1:	89 10                	mov    %edx,(%eax)
          list_del(le);
          le = len;
c0102ad3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102ad6:	89 45 f4             	mov    %eax,-0xc(%ebp)

    while((le=list_next(le)) != &free_list) {
      struct Page *p = le2page(le, page_link);
      if(p->property >= n){
        int i;
        for(i=0;i<n;i++){
c0102ad9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c0102add:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ae0:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102ae3:	0f 82 78 ff ff ff    	jb     c0102a61 <default_alloc_pages+0x71>
          SetPageReserved(pp);
          ClearPageProperty(pp);
          list_del(le);
          le = len;
        }
        if(p->property>n){
c0102ae9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102aec:	8b 40 08             	mov    0x8(%eax),%eax
c0102aef:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102af2:	76 12                	jbe    c0102b06 <default_alloc_pages+0x116>
          (le2page(le,page_link))->property = p->property - n;
c0102af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102af7:	8d 50 f4             	lea    -0xc(%eax),%edx
c0102afa:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102afd:	8b 40 08             	mov    0x8(%eax),%eax
c0102b00:	2b 45 08             	sub    0x8(%ebp),%eax
c0102b03:	89 42 08             	mov    %eax,0x8(%edx)
        }
        ClearPageProperty(p);
c0102b06:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102b09:	83 c0 04             	add    $0x4,%eax
c0102b0c:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0102b13:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0102b16:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102b19:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102b1c:	0f b3 10             	btr    %edx,(%eax)
        SetPageReserved(p);
c0102b1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102b22:	83 c0 04             	add    $0x4,%eax
c0102b25:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
c0102b2c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102b2f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102b32:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102b35:	0f ab 10             	bts    %edx,(%eax)
        nr_free -= n;
c0102b38:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102b3d:	2b 45 08             	sub    0x8(%ebp),%eax
c0102b40:	a3 58 89 11 c0       	mov    %eax,0xc0118958
        return p;
c0102b45:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102b48:	eb 21                	jmp    c0102b6b <default_alloc_pages+0x17b>
c0102b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b4d:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102b50:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102b53:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;
    }
    list_entry_t *le, *len;
    le = &free_list;

    while((le=list_next(le)) != &free_list) {
c0102b56:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102b59:	81 7d f4 50 89 11 c0 	cmpl   $0xc0118950,-0xc(%ebp)
c0102b60:	0f 85 da fe ff ff    	jne    c0102a40 <default_alloc_pages+0x50>
        SetPageReserved(p);
        nr_free -= n;
        return p;
      }
    }
    return NULL;
c0102b66:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102b6b:	c9                   	leave  
c0102b6c:	c3                   	ret    

c0102b6d <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102b6d:	55                   	push   %ebp
c0102b6e:	89 e5                	mov    %esp,%ebp
c0102b70:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0102b73:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102b77:	75 24                	jne    c0102b9d <default_free_pages+0x30>
c0102b79:	c7 44 24 0c 30 66 10 	movl   $0xc0106630,0xc(%esp)
c0102b80:	c0 
c0102b81:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c0102b88:	c0 
c0102b89:	c7 44 24 04 78 00 00 	movl   $0x78,0x4(%esp)
c0102b90:	00 
c0102b91:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c0102b98:	e8 29 e1 ff ff       	call   c0100cc6 <__panic>
    assert(PageReserved(base));
c0102b9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ba0:	83 c0 04             	add    $0x4,%eax
c0102ba3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102baa:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102bad:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102bb0:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102bb3:	0f a3 10             	bt     %edx,(%eax)
c0102bb6:	19 c0                	sbb    %eax,%eax
c0102bb8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0102bbb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102bbf:	0f 95 c0             	setne  %al
c0102bc2:	0f b6 c0             	movzbl %al,%eax
c0102bc5:	85 c0                	test   %eax,%eax
c0102bc7:	75 24                	jne    c0102bed <default_free_pages+0x80>
c0102bc9:	c7 44 24 0c 71 66 10 	movl   $0xc0106671,0xc(%esp)
c0102bd0:	c0 
c0102bd1:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c0102bd8:	c0 
c0102bd9:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
c0102be0:	00 
c0102be1:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c0102be8:	e8 d9 e0 ff ff       	call   c0100cc6 <__panic>

    list_entry_t *le = &free_list;
c0102bed:	c7 45 f4 50 89 11 c0 	movl   $0xc0118950,-0xc(%ebp)
    struct Page * p;
    while((le=list_next(le)) != &free_list) {
c0102bf4:	eb 13                	jmp    c0102c09 <default_free_pages+0x9c>
      p = le2page(le, page_link);
c0102bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bf9:	83 e8 0c             	sub    $0xc,%eax
c0102bfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(p>base){
c0102bff:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102c02:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102c05:	76 02                	jbe    c0102c09 <default_free_pages+0x9c>
        break;
c0102c07:	eb 18                	jmp    c0102c21 <default_free_pages+0xb4>
c0102c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c0c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102c0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102c12:	8b 40 04             	mov    0x4(%eax),%eax
    assert(n > 0);
    assert(PageReserved(base));

    list_entry_t *le = &free_list;
    struct Page * p;
    while((le=list_next(le)) != &free_list) {
c0102c15:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102c18:	81 7d f4 50 89 11 c0 	cmpl   $0xc0118950,-0xc(%ebp)
c0102c1f:	75 d5                	jne    c0102bf6 <default_free_pages+0x89>
      if(p>base){
        break;
      }
    }
    //list_add_before(le, base->page_link);
    for(p=base;p<base+n;p++){
c0102c21:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c24:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102c27:	eb 4b                	jmp    c0102c74 <default_free_pages+0x107>
      list_add_before(le, &(p->page_link));
c0102c29:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102c2c:	8d 50 0c             	lea    0xc(%eax),%edx
c0102c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c32:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0102c35:	89 55 d8             	mov    %edx,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102c38:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102c3b:	8b 00                	mov    (%eax),%eax
c0102c3d:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102c40:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102c43:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102c46:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102c49:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102c4c:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102c4f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102c52:	89 10                	mov    %edx,(%eax)
c0102c54:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102c57:	8b 10                	mov    (%eax),%edx
c0102c59:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102c5c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102c5f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102c62:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102c65:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102c68:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102c6b:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102c6e:	89 10                	mov    %edx,(%eax)
      if(p>base){
        break;
      }
    }
    //list_add_before(le, base->page_link);
    for(p=base;p<base+n;p++){
c0102c70:	83 45 f0 14          	addl   $0x14,-0x10(%ebp)
c0102c74:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102c77:	89 d0                	mov    %edx,%eax
c0102c79:	c1 e0 02             	shl    $0x2,%eax
c0102c7c:	01 d0                	add    %edx,%eax
c0102c7e:	c1 e0 02             	shl    $0x2,%eax
c0102c81:	89 c2                	mov    %eax,%edx
c0102c83:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c86:	01 d0                	add    %edx,%eax
c0102c88:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102c8b:	77 9c                	ja     c0102c29 <default_free_pages+0xbc>
      list_add_before(le, &(p->page_link));
    }
    base->flags = 0;
c0102c8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c90:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    set_page_ref(base, 0);
c0102c97:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102c9e:	00 
c0102c9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ca2:	89 04 24             	mov    %eax,(%esp)
c0102ca5:	e8 bd fb ff ff       	call   c0102867 <set_page_ref>
    ClearPageProperty(base);
c0102caa:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cad:	83 c0 04             	add    $0x4,%eax
c0102cb0:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0102cb7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102cba:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102cbd:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102cc0:	0f b3 10             	btr    %edx,(%eax)
    SetPageProperty(base);
c0102cc3:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cc6:	83 c0 04             	add    $0x4,%eax
c0102cc9:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0102cd0:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102cd3:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102cd6:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102cd9:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;
c0102cdc:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cdf:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102ce2:	89 50 08             	mov    %edx,0x8(%eax)
    
    p = le2page(le,page_link) ;
c0102ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ce8:	83 e8 0c             	sub    $0xc,%eax
c0102ceb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if( base+n == p ){
c0102cee:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102cf1:	89 d0                	mov    %edx,%eax
c0102cf3:	c1 e0 02             	shl    $0x2,%eax
c0102cf6:	01 d0                	add    %edx,%eax
c0102cf8:	c1 e0 02             	shl    $0x2,%eax
c0102cfb:	89 c2                	mov    %eax,%edx
c0102cfd:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d00:	01 d0                	add    %edx,%eax
c0102d02:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102d05:	75 1e                	jne    c0102d25 <default_free_pages+0x1b8>
      base->property += p->property;
c0102d07:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d0a:	8b 50 08             	mov    0x8(%eax),%edx
c0102d0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d10:	8b 40 08             	mov    0x8(%eax),%eax
c0102d13:	01 c2                	add    %eax,%edx
c0102d15:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d18:	89 50 08             	mov    %edx,0x8(%eax)
      p->property = 0;
c0102d1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d1e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }
    le = list_prev(&(base->page_link));
c0102d25:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d28:	83 c0 0c             	add    $0xc,%eax
c0102d2b:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0102d2e:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102d31:	8b 00                	mov    (%eax),%eax
c0102d33:	89 45 f4             	mov    %eax,-0xc(%ebp)
    p = le2page(le, page_link);
c0102d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d39:	83 e8 0c             	sub    $0xc,%eax
c0102d3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(le!=&free_list && p==base-1){
c0102d3f:	81 7d f4 50 89 11 c0 	cmpl   $0xc0118950,-0xc(%ebp)
c0102d46:	74 57                	je     c0102d9f <default_free_pages+0x232>
c0102d48:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d4b:	83 e8 14             	sub    $0x14,%eax
c0102d4e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102d51:	75 4c                	jne    c0102d9f <default_free_pages+0x232>
      while(le!=&free_list){
c0102d53:	eb 41                	jmp    c0102d96 <default_free_pages+0x229>
        if(p->property){
c0102d55:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d58:	8b 40 08             	mov    0x8(%eax),%eax
c0102d5b:	85 c0                	test   %eax,%eax
c0102d5d:	74 20                	je     c0102d7f <default_free_pages+0x212>
          p->property += base->property;
c0102d5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d62:	8b 50 08             	mov    0x8(%eax),%edx
c0102d65:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d68:	8b 40 08             	mov    0x8(%eax),%eax
c0102d6b:	01 c2                	add    %eax,%edx
c0102d6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d70:	89 50 08             	mov    %edx,0x8(%eax)
          base->property = 0;
c0102d73:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d76:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
          break;
c0102d7d:	eb 20                	jmp    c0102d9f <default_free_pages+0x232>
c0102d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d82:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0102d85:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102d88:	8b 00                	mov    (%eax),%eax
        }
        le = list_prev(le);
c0102d8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = le2page(le,page_link);
c0102d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d90:	83 e8 0c             	sub    $0xc,%eax
c0102d93:	89 45 f0             	mov    %eax,-0x10(%ebp)
      p->property = 0;
    }
    le = list_prev(&(base->page_link));
    p = le2page(le, page_link);
    if(le!=&free_list && p==base-1){
      while(le!=&free_list){
c0102d96:	81 7d f4 50 89 11 c0 	cmpl   $0xc0118950,-0xc(%ebp)
c0102d9d:	75 b6                	jne    c0102d55 <default_free_pages+0x1e8>
        le = list_prev(le);
        p = le2page(le,page_link);
      }
    }

    nr_free += n;
c0102d9f:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c0102da5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102da8:	01 d0                	add    %edx,%eax
c0102daa:	a3 58 89 11 c0       	mov    %eax,0xc0118958
    return ;
c0102daf:	90                   	nop
}
c0102db0:	c9                   	leave  
c0102db1:	c3                   	ret    

c0102db2 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0102db2:	55                   	push   %ebp
c0102db3:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102db5:	a1 58 89 11 c0       	mov    0xc0118958,%eax
}
c0102dba:	5d                   	pop    %ebp
c0102dbb:	c3                   	ret    

c0102dbc <basic_check>:

static void
basic_check(void) {
c0102dbc:	55                   	push   %ebp
c0102dbd:	89 e5                	mov    %esp,%ebp
c0102dbf:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102dc2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102dcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102dd2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102dd5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102ddc:	e8 9d 0e 00 00       	call   c0103c7e <alloc_pages>
c0102de1:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102de4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102de8:	75 24                	jne    c0102e0e <basic_check+0x52>
c0102dea:	c7 44 24 0c 84 66 10 	movl   $0xc0106684,0xc(%esp)
c0102df1:	c0 
c0102df2:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c0102df9:	c0 
c0102dfa:	c7 44 24 04 ad 00 00 	movl   $0xad,0x4(%esp)
c0102e01:	00 
c0102e02:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c0102e09:	e8 b8 de ff ff       	call   c0100cc6 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102e0e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102e15:	e8 64 0e 00 00       	call   c0103c7e <alloc_pages>
c0102e1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102e1d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102e21:	75 24                	jne    c0102e47 <basic_check+0x8b>
c0102e23:	c7 44 24 0c a0 66 10 	movl   $0xc01066a0,0xc(%esp)
c0102e2a:	c0 
c0102e2b:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c0102e32:	c0 
c0102e33:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
c0102e3a:	00 
c0102e3b:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c0102e42:	e8 7f de ff ff       	call   c0100cc6 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102e47:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102e4e:	e8 2b 0e 00 00       	call   c0103c7e <alloc_pages>
c0102e53:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102e56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102e5a:	75 24                	jne    c0102e80 <basic_check+0xc4>
c0102e5c:	c7 44 24 0c bc 66 10 	movl   $0xc01066bc,0xc(%esp)
c0102e63:	c0 
c0102e64:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c0102e6b:	c0 
c0102e6c:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
c0102e73:	00 
c0102e74:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c0102e7b:	e8 46 de ff ff       	call   c0100cc6 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0102e80:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102e83:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102e86:	74 10                	je     c0102e98 <basic_check+0xdc>
c0102e88:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102e8b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102e8e:	74 08                	je     c0102e98 <basic_check+0xdc>
c0102e90:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e93:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102e96:	75 24                	jne    c0102ebc <basic_check+0x100>
c0102e98:	c7 44 24 0c d8 66 10 	movl   $0xc01066d8,0xc(%esp)
c0102e9f:	c0 
c0102ea0:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c0102ea7:	c0 
c0102ea8:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
c0102eaf:	00 
c0102eb0:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c0102eb7:	e8 0a de ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0102ebc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ebf:	89 04 24             	mov    %eax,(%esp)
c0102ec2:	e8 96 f9 ff ff       	call   c010285d <page_ref>
c0102ec7:	85 c0                	test   %eax,%eax
c0102ec9:	75 1e                	jne    c0102ee9 <basic_check+0x12d>
c0102ecb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ece:	89 04 24             	mov    %eax,(%esp)
c0102ed1:	e8 87 f9 ff ff       	call   c010285d <page_ref>
c0102ed6:	85 c0                	test   %eax,%eax
c0102ed8:	75 0f                	jne    c0102ee9 <basic_check+0x12d>
c0102eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102edd:	89 04 24             	mov    %eax,(%esp)
c0102ee0:	e8 78 f9 ff ff       	call   c010285d <page_ref>
c0102ee5:	85 c0                	test   %eax,%eax
c0102ee7:	74 24                	je     c0102f0d <basic_check+0x151>
c0102ee9:	c7 44 24 0c fc 66 10 	movl   $0xc01066fc,0xc(%esp)
c0102ef0:	c0 
c0102ef1:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c0102ef8:	c0 
c0102ef9:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c0102f00:	00 
c0102f01:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c0102f08:	e8 b9 dd ff ff       	call   c0100cc6 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0102f0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f10:	89 04 24             	mov    %eax,(%esp)
c0102f13:	e8 2f f9 ff ff       	call   c0102847 <page2pa>
c0102f18:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102f1e:	c1 e2 0c             	shl    $0xc,%edx
c0102f21:	39 d0                	cmp    %edx,%eax
c0102f23:	72 24                	jb     c0102f49 <basic_check+0x18d>
c0102f25:	c7 44 24 0c 38 67 10 	movl   $0xc0106738,0xc(%esp)
c0102f2c:	c0 
c0102f2d:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c0102f34:	c0 
c0102f35:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
c0102f3c:	00 
c0102f3d:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c0102f44:	e8 7d dd ff ff       	call   c0100cc6 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0102f49:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f4c:	89 04 24             	mov    %eax,(%esp)
c0102f4f:	e8 f3 f8 ff ff       	call   c0102847 <page2pa>
c0102f54:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102f5a:	c1 e2 0c             	shl    $0xc,%edx
c0102f5d:	39 d0                	cmp    %edx,%eax
c0102f5f:	72 24                	jb     c0102f85 <basic_check+0x1c9>
c0102f61:	c7 44 24 0c 55 67 10 	movl   $0xc0106755,0xc(%esp)
c0102f68:	c0 
c0102f69:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c0102f70:	c0 
c0102f71:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
c0102f78:	00 
c0102f79:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c0102f80:	e8 41 dd ff ff       	call   c0100cc6 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0102f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f88:	89 04 24             	mov    %eax,(%esp)
c0102f8b:	e8 b7 f8 ff ff       	call   c0102847 <page2pa>
c0102f90:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102f96:	c1 e2 0c             	shl    $0xc,%edx
c0102f99:	39 d0                	cmp    %edx,%eax
c0102f9b:	72 24                	jb     c0102fc1 <basic_check+0x205>
c0102f9d:	c7 44 24 0c 72 67 10 	movl   $0xc0106772,0xc(%esp)
c0102fa4:	c0 
c0102fa5:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c0102fac:	c0 
c0102fad:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c0102fb4:	00 
c0102fb5:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c0102fbc:	e8 05 dd ff ff       	call   c0100cc6 <__panic>

    list_entry_t free_list_store = free_list;
c0102fc1:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102fc6:	8b 15 54 89 11 c0    	mov    0xc0118954,%edx
c0102fcc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102fcf:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102fd2:	c7 45 e0 50 89 11 c0 	movl   $0xc0118950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0102fd9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102fdc:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102fdf:	89 50 04             	mov    %edx,0x4(%eax)
c0102fe2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102fe5:	8b 50 04             	mov    0x4(%eax),%edx
c0102fe8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102feb:	89 10                	mov    %edx,(%eax)
c0102fed:	c7 45 dc 50 89 11 c0 	movl   $0xc0118950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0102ff4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102ff7:	8b 40 04             	mov    0x4(%eax),%eax
c0102ffa:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0102ffd:	0f 94 c0             	sete   %al
c0103000:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103003:	85 c0                	test   %eax,%eax
c0103005:	75 24                	jne    c010302b <basic_check+0x26f>
c0103007:	c7 44 24 0c 8f 67 10 	movl   $0xc010678f,0xc(%esp)
c010300e:	c0 
c010300f:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c0103016:	c0 
c0103017:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c010301e:	00 
c010301f:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c0103026:	e8 9b dc ff ff       	call   c0100cc6 <__panic>

    unsigned int nr_free_store = nr_free;
c010302b:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103030:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103033:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c010303a:	00 00 00 

    assert(alloc_page() == NULL);
c010303d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103044:	e8 35 0c 00 00       	call   c0103c7e <alloc_pages>
c0103049:	85 c0                	test   %eax,%eax
c010304b:	74 24                	je     c0103071 <basic_check+0x2b5>
c010304d:	c7 44 24 0c a6 67 10 	movl   $0xc01067a6,0xc(%esp)
c0103054:	c0 
c0103055:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c010305c:	c0 
c010305d:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c0103064:	00 
c0103065:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c010306c:	e8 55 dc ff ff       	call   c0100cc6 <__panic>

    free_page(p0);
c0103071:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103078:	00 
c0103079:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010307c:	89 04 24             	mov    %eax,(%esp)
c010307f:	e8 32 0c 00 00       	call   c0103cb6 <free_pages>
    free_page(p1);
c0103084:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010308b:	00 
c010308c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010308f:	89 04 24             	mov    %eax,(%esp)
c0103092:	e8 1f 0c 00 00       	call   c0103cb6 <free_pages>
    free_page(p2);
c0103097:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010309e:	00 
c010309f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01030a2:	89 04 24             	mov    %eax,(%esp)
c01030a5:	e8 0c 0c 00 00       	call   c0103cb6 <free_pages>
    assert(nr_free == 3);
c01030aa:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c01030af:	83 f8 03             	cmp    $0x3,%eax
c01030b2:	74 24                	je     c01030d8 <basic_check+0x31c>
c01030b4:	c7 44 24 0c bb 67 10 	movl   $0xc01067bb,0xc(%esp)
c01030bb:	c0 
c01030bc:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c01030c3:	c0 
c01030c4:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c01030cb:	00 
c01030cc:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c01030d3:	e8 ee db ff ff       	call   c0100cc6 <__panic>

    assert((p0 = alloc_page()) != NULL);
c01030d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01030df:	e8 9a 0b 00 00       	call   c0103c7e <alloc_pages>
c01030e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01030e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01030eb:	75 24                	jne    c0103111 <basic_check+0x355>
c01030ed:	c7 44 24 0c 84 66 10 	movl   $0xc0106684,0xc(%esp)
c01030f4:	c0 
c01030f5:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c01030fc:	c0 
c01030fd:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c0103104:	00 
c0103105:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c010310c:	e8 b5 db ff ff       	call   c0100cc6 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103111:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103118:	e8 61 0b 00 00       	call   c0103c7e <alloc_pages>
c010311d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103120:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103124:	75 24                	jne    c010314a <basic_check+0x38e>
c0103126:	c7 44 24 0c a0 66 10 	movl   $0xc01066a0,0xc(%esp)
c010312d:	c0 
c010312e:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c0103135:	c0 
c0103136:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c010313d:	00 
c010313e:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c0103145:	e8 7c db ff ff       	call   c0100cc6 <__panic>
    assert((p2 = alloc_page()) != NULL);
c010314a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103151:	e8 28 0b 00 00       	call   c0103c7e <alloc_pages>
c0103156:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103159:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010315d:	75 24                	jne    c0103183 <basic_check+0x3c7>
c010315f:	c7 44 24 0c bc 66 10 	movl   $0xc01066bc,0xc(%esp)
c0103166:	c0 
c0103167:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c010316e:	c0 
c010316f:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
c0103176:	00 
c0103177:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c010317e:	e8 43 db ff ff       	call   c0100cc6 <__panic>

    assert(alloc_page() == NULL);
c0103183:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010318a:	e8 ef 0a 00 00       	call   c0103c7e <alloc_pages>
c010318f:	85 c0                	test   %eax,%eax
c0103191:	74 24                	je     c01031b7 <basic_check+0x3fb>
c0103193:	c7 44 24 0c a6 67 10 	movl   $0xc01067a6,0xc(%esp)
c010319a:	c0 
c010319b:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c01031a2:	c0 
c01031a3:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c01031aa:	00 
c01031ab:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c01031b2:	e8 0f db ff ff       	call   c0100cc6 <__panic>

    free_page(p0);
c01031b7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01031be:	00 
c01031bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01031c2:	89 04 24             	mov    %eax,(%esp)
c01031c5:	e8 ec 0a 00 00       	call   c0103cb6 <free_pages>
c01031ca:	c7 45 d8 50 89 11 c0 	movl   $0xc0118950,-0x28(%ebp)
c01031d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01031d4:	8b 40 04             	mov    0x4(%eax),%eax
c01031d7:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c01031da:	0f 94 c0             	sete   %al
c01031dd:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c01031e0:	85 c0                	test   %eax,%eax
c01031e2:	74 24                	je     c0103208 <basic_check+0x44c>
c01031e4:	c7 44 24 0c c8 67 10 	movl   $0xc01067c8,0xc(%esp)
c01031eb:	c0 
c01031ec:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c01031f3:	c0 
c01031f4:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
c01031fb:	00 
c01031fc:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c0103203:	e8 be da ff ff       	call   c0100cc6 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103208:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010320f:	e8 6a 0a 00 00       	call   c0103c7e <alloc_pages>
c0103214:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103217:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010321a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010321d:	74 24                	je     c0103243 <basic_check+0x487>
c010321f:	c7 44 24 0c e0 67 10 	movl   $0xc01067e0,0xc(%esp)
c0103226:	c0 
c0103227:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c010322e:	c0 
c010322f:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c0103236:	00 
c0103237:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c010323e:	e8 83 da ff ff       	call   c0100cc6 <__panic>
    assert(alloc_page() == NULL);
c0103243:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010324a:	e8 2f 0a 00 00       	call   c0103c7e <alloc_pages>
c010324f:	85 c0                	test   %eax,%eax
c0103251:	74 24                	je     c0103277 <basic_check+0x4bb>
c0103253:	c7 44 24 0c a6 67 10 	movl   $0xc01067a6,0xc(%esp)
c010325a:	c0 
c010325b:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c0103262:	c0 
c0103263:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c010326a:	00 
c010326b:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c0103272:	e8 4f da ff ff       	call   c0100cc6 <__panic>

    assert(nr_free == 0);
c0103277:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c010327c:	85 c0                	test   %eax,%eax
c010327e:	74 24                	je     c01032a4 <basic_check+0x4e8>
c0103280:	c7 44 24 0c f9 67 10 	movl   $0xc01067f9,0xc(%esp)
c0103287:	c0 
c0103288:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c010328f:	c0 
c0103290:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c0103297:	00 
c0103298:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c010329f:	e8 22 da ff ff       	call   c0100cc6 <__panic>
    free_list = free_list_store;
c01032a4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01032a7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01032aa:	a3 50 89 11 c0       	mov    %eax,0xc0118950
c01032af:	89 15 54 89 11 c0    	mov    %edx,0xc0118954
    nr_free = nr_free_store;
c01032b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01032b8:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    free_page(p);
c01032bd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01032c4:	00 
c01032c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01032c8:	89 04 24             	mov    %eax,(%esp)
c01032cb:	e8 e6 09 00 00       	call   c0103cb6 <free_pages>
    free_page(p1);
c01032d0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01032d7:	00 
c01032d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01032db:	89 04 24             	mov    %eax,(%esp)
c01032de:	e8 d3 09 00 00       	call   c0103cb6 <free_pages>
    free_page(p2);
c01032e3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01032ea:	00 
c01032eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032ee:	89 04 24             	mov    %eax,(%esp)
c01032f1:	e8 c0 09 00 00       	call   c0103cb6 <free_pages>
}
c01032f6:	c9                   	leave  
c01032f7:	c3                   	ret    

c01032f8 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c01032f8:	55                   	push   %ebp
c01032f9:	89 e5                	mov    %esp,%ebp
c01032fb:	53                   	push   %ebx
c01032fc:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0103302:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103309:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103310:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103317:	eb 6b                	jmp    c0103384 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0103319:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010331c:	83 e8 0c             	sub    $0xc,%eax
c010331f:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103322:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103325:	83 c0 04             	add    $0x4,%eax
c0103328:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c010332f:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103332:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103335:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103338:	0f a3 10             	bt     %edx,(%eax)
c010333b:	19 c0                	sbb    %eax,%eax
c010333d:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103340:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103344:	0f 95 c0             	setne  %al
c0103347:	0f b6 c0             	movzbl %al,%eax
c010334a:	85 c0                	test   %eax,%eax
c010334c:	75 24                	jne    c0103372 <default_check+0x7a>
c010334e:	c7 44 24 0c 06 68 10 	movl   $0xc0106806,0xc(%esp)
c0103355:	c0 
c0103356:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c010335d:	c0 
c010335e:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c0103365:	00 
c0103366:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c010336d:	e8 54 d9 ff ff       	call   c0100cc6 <__panic>
        count ++, total += p->property;
c0103372:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103376:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103379:	8b 50 08             	mov    0x8(%eax),%edx
c010337c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010337f:	01 d0                	add    %edx,%eax
c0103381:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103384:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103387:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010338a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010338d:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103390:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103393:	81 7d ec 50 89 11 c0 	cmpl   $0xc0118950,-0x14(%ebp)
c010339a:	0f 85 79 ff ff ff    	jne    c0103319 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c01033a0:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c01033a3:	e8 40 09 00 00       	call   c0103ce8 <nr_free_pages>
c01033a8:	39 c3                	cmp    %eax,%ebx
c01033aa:	74 24                	je     c01033d0 <default_check+0xd8>
c01033ac:	c7 44 24 0c 16 68 10 	movl   $0xc0106816,0xc(%esp)
c01033b3:	c0 
c01033b4:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c01033bb:	c0 
c01033bc:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c01033c3:	00 
c01033c4:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c01033cb:	e8 f6 d8 ff ff       	call   c0100cc6 <__panic>

    basic_check();
c01033d0:	e8 e7 f9 ff ff       	call   c0102dbc <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c01033d5:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01033dc:	e8 9d 08 00 00       	call   c0103c7e <alloc_pages>
c01033e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c01033e4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01033e8:	75 24                	jne    c010340e <default_check+0x116>
c01033ea:	c7 44 24 0c 2f 68 10 	movl   $0xc010682f,0xc(%esp)
c01033f1:	c0 
c01033f2:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c01033f9:	c0 
c01033fa:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c0103401:	00 
c0103402:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c0103409:	e8 b8 d8 ff ff       	call   c0100cc6 <__panic>
    assert(!PageProperty(p0));
c010340e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103411:	83 c0 04             	add    $0x4,%eax
c0103414:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c010341b:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010341e:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103421:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103424:	0f a3 10             	bt     %edx,(%eax)
c0103427:	19 c0                	sbb    %eax,%eax
c0103429:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c010342c:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103430:	0f 95 c0             	setne  %al
c0103433:	0f b6 c0             	movzbl %al,%eax
c0103436:	85 c0                	test   %eax,%eax
c0103438:	74 24                	je     c010345e <default_check+0x166>
c010343a:	c7 44 24 0c 3a 68 10 	movl   $0xc010683a,0xc(%esp)
c0103441:	c0 
c0103442:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c0103449:	c0 
c010344a:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
c0103451:	00 
c0103452:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c0103459:	e8 68 d8 ff ff       	call   c0100cc6 <__panic>

    list_entry_t free_list_store = free_list;
c010345e:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0103463:	8b 15 54 89 11 c0    	mov    0xc0118954,%edx
c0103469:	89 45 80             	mov    %eax,-0x80(%ebp)
c010346c:	89 55 84             	mov    %edx,-0x7c(%ebp)
c010346f:	c7 45 b4 50 89 11 c0 	movl   $0xc0118950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103476:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103479:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010347c:	89 50 04             	mov    %edx,0x4(%eax)
c010347f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103482:	8b 50 04             	mov    0x4(%eax),%edx
c0103485:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103488:	89 10                	mov    %edx,(%eax)
c010348a:	c7 45 b0 50 89 11 c0 	movl   $0xc0118950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103491:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103494:	8b 40 04             	mov    0x4(%eax),%eax
c0103497:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c010349a:	0f 94 c0             	sete   %al
c010349d:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01034a0:	85 c0                	test   %eax,%eax
c01034a2:	75 24                	jne    c01034c8 <default_check+0x1d0>
c01034a4:	c7 44 24 0c 8f 67 10 	movl   $0xc010678f,0xc(%esp)
c01034ab:	c0 
c01034ac:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c01034b3:	c0 
c01034b4:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c01034bb:	00 
c01034bc:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c01034c3:	e8 fe d7 ff ff       	call   c0100cc6 <__panic>
    assert(alloc_page() == NULL);
c01034c8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01034cf:	e8 aa 07 00 00       	call   c0103c7e <alloc_pages>
c01034d4:	85 c0                	test   %eax,%eax
c01034d6:	74 24                	je     c01034fc <default_check+0x204>
c01034d8:	c7 44 24 0c a6 67 10 	movl   $0xc01067a6,0xc(%esp)
c01034df:	c0 
c01034e0:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c01034e7:	c0 
c01034e8:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c01034ef:	00 
c01034f0:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c01034f7:	e8 ca d7 ff ff       	call   c0100cc6 <__panic>

    unsigned int nr_free_store = nr_free;
c01034fc:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103501:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0103504:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c010350b:	00 00 00 

    free_pages(p0 + 2, 3);
c010350e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103511:	83 c0 28             	add    $0x28,%eax
c0103514:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c010351b:	00 
c010351c:	89 04 24             	mov    %eax,(%esp)
c010351f:	e8 92 07 00 00       	call   c0103cb6 <free_pages>
    assert(alloc_pages(4) == NULL);
c0103524:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010352b:	e8 4e 07 00 00       	call   c0103c7e <alloc_pages>
c0103530:	85 c0                	test   %eax,%eax
c0103532:	74 24                	je     c0103558 <default_check+0x260>
c0103534:	c7 44 24 0c 4c 68 10 	movl   $0xc010684c,0xc(%esp)
c010353b:	c0 
c010353c:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c0103543:	c0 
c0103544:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c010354b:	00 
c010354c:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c0103553:	e8 6e d7 ff ff       	call   c0100cc6 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0103558:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010355b:	83 c0 28             	add    $0x28,%eax
c010355e:	83 c0 04             	add    $0x4,%eax
c0103561:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103568:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010356b:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010356e:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103571:	0f a3 10             	bt     %edx,(%eax)
c0103574:	19 c0                	sbb    %eax,%eax
c0103576:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103579:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c010357d:	0f 95 c0             	setne  %al
c0103580:	0f b6 c0             	movzbl %al,%eax
c0103583:	85 c0                	test   %eax,%eax
c0103585:	74 0e                	je     c0103595 <default_check+0x29d>
c0103587:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010358a:	83 c0 28             	add    $0x28,%eax
c010358d:	8b 40 08             	mov    0x8(%eax),%eax
c0103590:	83 f8 03             	cmp    $0x3,%eax
c0103593:	74 24                	je     c01035b9 <default_check+0x2c1>
c0103595:	c7 44 24 0c 64 68 10 	movl   $0xc0106864,0xc(%esp)
c010359c:	c0 
c010359d:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c01035a4:	c0 
c01035a5:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c01035ac:	00 
c01035ad:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c01035b4:	e8 0d d7 ff ff       	call   c0100cc6 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c01035b9:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c01035c0:	e8 b9 06 00 00       	call   c0103c7e <alloc_pages>
c01035c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01035c8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01035cc:	75 24                	jne    c01035f2 <default_check+0x2fa>
c01035ce:	c7 44 24 0c 90 68 10 	movl   $0xc0106890,0xc(%esp)
c01035d5:	c0 
c01035d6:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c01035dd:	c0 
c01035de:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c01035e5:	00 
c01035e6:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c01035ed:	e8 d4 d6 ff ff       	call   c0100cc6 <__panic>
    assert(alloc_page() == NULL);
c01035f2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01035f9:	e8 80 06 00 00       	call   c0103c7e <alloc_pages>
c01035fe:	85 c0                	test   %eax,%eax
c0103600:	74 24                	je     c0103626 <default_check+0x32e>
c0103602:	c7 44 24 0c a6 67 10 	movl   $0xc01067a6,0xc(%esp)
c0103609:	c0 
c010360a:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c0103611:	c0 
c0103612:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0103619:	00 
c010361a:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c0103621:	e8 a0 d6 ff ff       	call   c0100cc6 <__panic>
    assert(p0 + 2 == p1);
c0103626:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103629:	83 c0 28             	add    $0x28,%eax
c010362c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c010362f:	74 24                	je     c0103655 <default_check+0x35d>
c0103631:	c7 44 24 0c ae 68 10 	movl   $0xc01068ae,0xc(%esp)
c0103638:	c0 
c0103639:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c0103640:	c0 
c0103641:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c0103648:	00 
c0103649:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c0103650:	e8 71 d6 ff ff       	call   c0100cc6 <__panic>

    p2 = p0 + 1;
c0103655:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103658:	83 c0 14             	add    $0x14,%eax
c010365b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c010365e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103665:	00 
c0103666:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103669:	89 04 24             	mov    %eax,(%esp)
c010366c:	e8 45 06 00 00       	call   c0103cb6 <free_pages>
    free_pages(p1, 3);
c0103671:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103678:	00 
c0103679:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010367c:	89 04 24             	mov    %eax,(%esp)
c010367f:	e8 32 06 00 00       	call   c0103cb6 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0103684:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103687:	83 c0 04             	add    $0x4,%eax
c010368a:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0103691:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103694:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103697:	8b 55 a0             	mov    -0x60(%ebp),%edx
c010369a:	0f a3 10             	bt     %edx,(%eax)
c010369d:	19 c0                	sbb    %eax,%eax
c010369f:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c01036a2:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c01036a6:	0f 95 c0             	setne  %al
c01036a9:	0f b6 c0             	movzbl %al,%eax
c01036ac:	85 c0                	test   %eax,%eax
c01036ae:	74 0b                	je     c01036bb <default_check+0x3c3>
c01036b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036b3:	8b 40 08             	mov    0x8(%eax),%eax
c01036b6:	83 f8 01             	cmp    $0x1,%eax
c01036b9:	74 24                	je     c01036df <default_check+0x3e7>
c01036bb:	c7 44 24 0c bc 68 10 	movl   $0xc01068bc,0xc(%esp)
c01036c2:	c0 
c01036c3:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c01036ca:	c0 
c01036cb:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c01036d2:	00 
c01036d3:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c01036da:	e8 e7 d5 ff ff       	call   c0100cc6 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c01036df:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01036e2:	83 c0 04             	add    $0x4,%eax
c01036e5:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c01036ec:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01036ef:	8b 45 90             	mov    -0x70(%ebp),%eax
c01036f2:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01036f5:	0f a3 10             	bt     %edx,(%eax)
c01036f8:	19 c0                	sbb    %eax,%eax
c01036fa:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c01036fd:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0103701:	0f 95 c0             	setne  %al
c0103704:	0f b6 c0             	movzbl %al,%eax
c0103707:	85 c0                	test   %eax,%eax
c0103709:	74 0b                	je     c0103716 <default_check+0x41e>
c010370b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010370e:	8b 40 08             	mov    0x8(%eax),%eax
c0103711:	83 f8 03             	cmp    $0x3,%eax
c0103714:	74 24                	je     c010373a <default_check+0x442>
c0103716:	c7 44 24 0c e4 68 10 	movl   $0xc01068e4,0xc(%esp)
c010371d:	c0 
c010371e:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c0103725:	c0 
c0103726:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c010372d:	00 
c010372e:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c0103735:	e8 8c d5 ff ff       	call   c0100cc6 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c010373a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103741:	e8 38 05 00 00       	call   c0103c7e <alloc_pages>
c0103746:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103749:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010374c:	83 e8 14             	sub    $0x14,%eax
c010374f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103752:	74 24                	je     c0103778 <default_check+0x480>
c0103754:	c7 44 24 0c 0a 69 10 	movl   $0xc010690a,0xc(%esp)
c010375b:	c0 
c010375c:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c0103763:	c0 
c0103764:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c010376b:	00 
c010376c:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c0103773:	e8 4e d5 ff ff       	call   c0100cc6 <__panic>
    free_page(p0);
c0103778:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010377f:	00 
c0103780:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103783:	89 04 24             	mov    %eax,(%esp)
c0103786:	e8 2b 05 00 00       	call   c0103cb6 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c010378b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0103792:	e8 e7 04 00 00       	call   c0103c7e <alloc_pages>
c0103797:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010379a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010379d:	83 c0 14             	add    $0x14,%eax
c01037a0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01037a3:	74 24                	je     c01037c9 <default_check+0x4d1>
c01037a5:	c7 44 24 0c 28 69 10 	movl   $0xc0106928,0xc(%esp)
c01037ac:	c0 
c01037ad:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c01037b4:	c0 
c01037b5:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
c01037bc:	00 
c01037bd:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c01037c4:	e8 fd d4 ff ff       	call   c0100cc6 <__panic>

    free_pages(p0, 2);
c01037c9:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c01037d0:	00 
c01037d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01037d4:	89 04 24             	mov    %eax,(%esp)
c01037d7:	e8 da 04 00 00       	call   c0103cb6 <free_pages>
    free_page(p2);
c01037dc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01037e3:	00 
c01037e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01037e7:	89 04 24             	mov    %eax,(%esp)
c01037ea:	e8 c7 04 00 00       	call   c0103cb6 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c01037ef:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01037f6:	e8 83 04 00 00       	call   c0103c7e <alloc_pages>
c01037fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01037fe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103802:	75 24                	jne    c0103828 <default_check+0x530>
c0103804:	c7 44 24 0c 48 69 10 	movl   $0xc0106948,0xc(%esp)
c010380b:	c0 
c010380c:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c0103813:	c0 
c0103814:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
c010381b:	00 
c010381c:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c0103823:	e8 9e d4 ff ff       	call   c0100cc6 <__panic>
    assert(alloc_page() == NULL);
c0103828:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010382f:	e8 4a 04 00 00       	call   c0103c7e <alloc_pages>
c0103834:	85 c0                	test   %eax,%eax
c0103836:	74 24                	je     c010385c <default_check+0x564>
c0103838:	c7 44 24 0c a6 67 10 	movl   $0xc01067a6,0xc(%esp)
c010383f:	c0 
c0103840:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c0103847:	c0 
c0103848:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c010384f:	00 
c0103850:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c0103857:	e8 6a d4 ff ff       	call   c0100cc6 <__panic>

    assert(nr_free == 0);
c010385c:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103861:	85 c0                	test   %eax,%eax
c0103863:	74 24                	je     c0103889 <default_check+0x591>
c0103865:	c7 44 24 0c f9 67 10 	movl   $0xc01067f9,0xc(%esp)
c010386c:	c0 
c010386d:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c0103874:	c0 
c0103875:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c010387c:	00 
c010387d:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c0103884:	e8 3d d4 ff ff       	call   c0100cc6 <__panic>
    nr_free = nr_free_store;
c0103889:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010388c:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    free_list = free_list_store;
c0103891:	8b 45 80             	mov    -0x80(%ebp),%eax
c0103894:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103897:	a3 50 89 11 c0       	mov    %eax,0xc0118950
c010389c:	89 15 54 89 11 c0    	mov    %edx,0xc0118954
    free_pages(p0, 5);
c01038a2:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c01038a9:	00 
c01038aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01038ad:	89 04 24             	mov    %eax,(%esp)
c01038b0:	e8 01 04 00 00       	call   c0103cb6 <free_pages>

    le = &free_list;
c01038b5:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01038bc:	eb 1d                	jmp    c01038db <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c01038be:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01038c1:	83 e8 0c             	sub    $0xc,%eax
c01038c4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c01038c7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01038cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01038ce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01038d1:	8b 40 08             	mov    0x8(%eax),%eax
c01038d4:	29 c2                	sub    %eax,%edx
c01038d6:	89 d0                	mov    %edx,%eax
c01038d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01038db:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01038de:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01038e1:	8b 45 88             	mov    -0x78(%ebp),%eax
c01038e4:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01038e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01038ea:	81 7d ec 50 89 11 c0 	cmpl   $0xc0118950,-0x14(%ebp)
c01038f1:	75 cb                	jne    c01038be <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c01038f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01038f7:	74 24                	je     c010391d <default_check+0x625>
c01038f9:	c7 44 24 0c 66 69 10 	movl   $0xc0106966,0xc(%esp)
c0103900:	c0 
c0103901:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c0103908:	c0 
c0103909:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c0103910:	00 
c0103911:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c0103918:	e8 a9 d3 ff ff       	call   c0100cc6 <__panic>
    assert(total == 0);
c010391d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103921:	74 24                	je     c0103947 <default_check+0x64f>
c0103923:	c7 44 24 0c 71 69 10 	movl   $0xc0106971,0xc(%esp)
c010392a:	c0 
c010392b:	c7 44 24 08 36 66 10 	movl   $0xc0106636,0x8(%esp)
c0103932:	c0 
c0103933:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
c010393a:	00 
c010393b:	c7 04 24 4b 66 10 c0 	movl   $0xc010664b,(%esp)
c0103942:	e8 7f d3 ff ff       	call   c0100cc6 <__panic>
}
c0103947:	81 c4 94 00 00 00    	add    $0x94,%esp
c010394d:	5b                   	pop    %ebx
c010394e:	5d                   	pop    %ebp
c010394f:	c3                   	ret    

c0103950 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103950:	55                   	push   %ebp
c0103951:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103953:	8b 55 08             	mov    0x8(%ebp),%edx
c0103956:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c010395b:	29 c2                	sub    %eax,%edx
c010395d:	89 d0                	mov    %edx,%eax
c010395f:	c1 f8 02             	sar    $0x2,%eax
c0103962:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103968:	5d                   	pop    %ebp
c0103969:	c3                   	ret    

c010396a <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010396a:	55                   	push   %ebp
c010396b:	89 e5                	mov    %esp,%ebp
c010396d:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103970:	8b 45 08             	mov    0x8(%ebp),%eax
c0103973:	89 04 24             	mov    %eax,(%esp)
c0103976:	e8 d5 ff ff ff       	call   c0103950 <page2ppn>
c010397b:	c1 e0 0c             	shl    $0xc,%eax
}
c010397e:	c9                   	leave  
c010397f:	c3                   	ret    

c0103980 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0103980:	55                   	push   %ebp
c0103981:	89 e5                	mov    %esp,%ebp
c0103983:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103986:	8b 45 08             	mov    0x8(%ebp),%eax
c0103989:	c1 e8 0c             	shr    $0xc,%eax
c010398c:	89 c2                	mov    %eax,%edx
c010398e:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103993:	39 c2                	cmp    %eax,%edx
c0103995:	72 1c                	jb     c01039b3 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103997:	c7 44 24 08 ac 69 10 	movl   $0xc01069ac,0x8(%esp)
c010399e:	c0 
c010399f:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c01039a6:	00 
c01039a7:	c7 04 24 cb 69 10 c0 	movl   $0xc01069cb,(%esp)
c01039ae:	e8 13 d3 ff ff       	call   c0100cc6 <__panic>
    }
    return &pages[PPN(pa)];
c01039b3:	8b 0d 64 89 11 c0    	mov    0xc0118964,%ecx
c01039b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01039bc:	c1 e8 0c             	shr    $0xc,%eax
c01039bf:	89 c2                	mov    %eax,%edx
c01039c1:	89 d0                	mov    %edx,%eax
c01039c3:	c1 e0 02             	shl    $0x2,%eax
c01039c6:	01 d0                	add    %edx,%eax
c01039c8:	c1 e0 02             	shl    $0x2,%eax
c01039cb:	01 c8                	add    %ecx,%eax
}
c01039cd:	c9                   	leave  
c01039ce:	c3                   	ret    

c01039cf <page2kva>:

static inline void *
page2kva(struct Page *page) {
c01039cf:	55                   	push   %ebp
c01039d0:	89 e5                	mov    %esp,%ebp
c01039d2:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c01039d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01039d8:	89 04 24             	mov    %eax,(%esp)
c01039db:	e8 8a ff ff ff       	call   c010396a <page2pa>
c01039e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01039e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039e6:	c1 e8 0c             	shr    $0xc,%eax
c01039e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01039ec:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01039f1:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01039f4:	72 23                	jb     c0103a19 <page2kva+0x4a>
c01039f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039f9:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01039fd:	c7 44 24 08 dc 69 10 	movl   $0xc01069dc,0x8(%esp)
c0103a04:	c0 
c0103a05:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103a0c:	00 
c0103a0d:	c7 04 24 cb 69 10 c0 	movl   $0xc01069cb,(%esp)
c0103a14:	e8 ad d2 ff ff       	call   c0100cc6 <__panic>
c0103a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a1c:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103a21:	c9                   	leave  
c0103a22:	c3                   	ret    

c0103a23 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0103a23:	55                   	push   %ebp
c0103a24:	89 e5                	mov    %esp,%ebp
c0103a26:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103a29:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a2c:	83 e0 01             	and    $0x1,%eax
c0103a2f:	85 c0                	test   %eax,%eax
c0103a31:	75 1c                	jne    c0103a4f <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103a33:	c7 44 24 08 00 6a 10 	movl   $0xc0106a00,0x8(%esp)
c0103a3a:	c0 
c0103a3b:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103a42:	00 
c0103a43:	c7 04 24 cb 69 10 c0 	movl   $0xc01069cb,(%esp)
c0103a4a:	e8 77 d2 ff ff       	call   c0100cc6 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0103a4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a52:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103a57:	89 04 24             	mov    %eax,(%esp)
c0103a5a:	e8 21 ff ff ff       	call   c0103980 <pa2page>
}
c0103a5f:	c9                   	leave  
c0103a60:	c3                   	ret    

c0103a61 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0103a61:	55                   	push   %ebp
c0103a62:	89 e5                	mov    %esp,%ebp
c0103a64:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0103a67:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a6a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103a6f:	89 04 24             	mov    %eax,(%esp)
c0103a72:	e8 09 ff ff ff       	call   c0103980 <pa2page>
}
c0103a77:	c9                   	leave  
c0103a78:	c3                   	ret    

c0103a79 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0103a79:	55                   	push   %ebp
c0103a7a:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103a7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a7f:	8b 00                	mov    (%eax),%eax
}
c0103a81:	5d                   	pop    %ebp
c0103a82:	c3                   	ret    

c0103a83 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103a83:	55                   	push   %ebp
c0103a84:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103a86:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a89:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103a8c:	89 10                	mov    %edx,(%eax)
}
c0103a8e:	5d                   	pop    %ebp
c0103a8f:	c3                   	ret    

c0103a90 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0103a90:	55                   	push   %ebp
c0103a91:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103a93:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a96:	8b 00                	mov    (%eax),%eax
c0103a98:	8d 50 01             	lea    0x1(%eax),%edx
c0103a9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a9e:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103aa0:	8b 45 08             	mov    0x8(%ebp),%eax
c0103aa3:	8b 00                	mov    (%eax),%eax
}
c0103aa5:	5d                   	pop    %ebp
c0103aa6:	c3                   	ret    

c0103aa7 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103aa7:	55                   	push   %ebp
c0103aa8:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103aaa:	8b 45 08             	mov    0x8(%ebp),%eax
c0103aad:	8b 00                	mov    (%eax),%eax
c0103aaf:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103ab2:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ab5:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103ab7:	8b 45 08             	mov    0x8(%ebp),%eax
c0103aba:	8b 00                	mov    (%eax),%eax
}
c0103abc:	5d                   	pop    %ebp
c0103abd:	c3                   	ret    

c0103abe <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0103abe:	55                   	push   %ebp
c0103abf:	89 e5                	mov    %esp,%ebp
c0103ac1:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103ac4:	9c                   	pushf  
c0103ac5:	58                   	pop    %eax
c0103ac6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103acc:	25 00 02 00 00       	and    $0x200,%eax
c0103ad1:	85 c0                	test   %eax,%eax
c0103ad3:	74 0c                	je     c0103ae1 <__intr_save+0x23>
        intr_disable();
c0103ad5:	e8 cf db ff ff       	call   c01016a9 <intr_disable>
        return 1;
c0103ada:	b8 01 00 00 00       	mov    $0x1,%eax
c0103adf:	eb 05                	jmp    c0103ae6 <__intr_save+0x28>
    }
    return 0;
c0103ae1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103ae6:	c9                   	leave  
c0103ae7:	c3                   	ret    

c0103ae8 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0103ae8:	55                   	push   %ebp
c0103ae9:	89 e5                	mov    %esp,%ebp
c0103aeb:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103aee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103af2:	74 05                	je     c0103af9 <__intr_restore+0x11>
        intr_enable();
c0103af4:	e8 aa db ff ff       	call   c01016a3 <intr_enable>
    }
}
c0103af9:	c9                   	leave  
c0103afa:	c3                   	ret    

c0103afb <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103afb:	55                   	push   %ebp
c0103afc:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103afe:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b01:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103b04:	b8 23 00 00 00       	mov    $0x23,%eax
c0103b09:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103b0b:	b8 23 00 00 00       	mov    $0x23,%eax
c0103b10:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103b12:	b8 10 00 00 00       	mov    $0x10,%eax
c0103b17:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103b19:	b8 10 00 00 00       	mov    $0x10,%eax
c0103b1e:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103b20:	b8 10 00 00 00       	mov    $0x10,%eax
c0103b25:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103b27:	ea 2e 3b 10 c0 08 00 	ljmp   $0x8,$0xc0103b2e
}
c0103b2e:	5d                   	pop    %ebp
c0103b2f:	c3                   	ret    

c0103b30 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103b30:	55                   	push   %ebp
c0103b31:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103b33:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b36:	a3 e4 88 11 c0       	mov    %eax,0xc01188e4
}
c0103b3b:	5d                   	pop    %ebp
c0103b3c:	c3                   	ret    

c0103b3d <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103b3d:	55                   	push   %ebp
c0103b3e:	89 e5                	mov    %esp,%ebp
c0103b40:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103b43:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0103b48:	89 04 24             	mov    %eax,(%esp)
c0103b4b:	e8 e0 ff ff ff       	call   c0103b30 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103b50:	66 c7 05 e8 88 11 c0 	movw   $0x10,0xc01188e8
c0103b57:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103b59:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0103b60:	68 00 
c0103b62:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103b67:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0103b6d:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103b72:	c1 e8 10             	shr    $0x10,%eax
c0103b75:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0103b7a:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103b81:	83 e0 f0             	and    $0xfffffff0,%eax
c0103b84:	83 c8 09             	or     $0x9,%eax
c0103b87:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103b8c:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103b93:	83 e0 ef             	and    $0xffffffef,%eax
c0103b96:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103b9b:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103ba2:	83 e0 9f             	and    $0xffffff9f,%eax
c0103ba5:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103baa:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103bb1:	83 c8 80             	or     $0xffffff80,%eax
c0103bb4:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103bb9:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103bc0:	83 e0 f0             	and    $0xfffffff0,%eax
c0103bc3:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103bc8:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103bcf:	83 e0 ef             	and    $0xffffffef,%eax
c0103bd2:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103bd7:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103bde:	83 e0 df             	and    $0xffffffdf,%eax
c0103be1:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103be6:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103bed:	83 c8 40             	or     $0x40,%eax
c0103bf0:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103bf5:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103bfc:	83 e0 7f             	and    $0x7f,%eax
c0103bff:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c04:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103c09:	c1 e8 18             	shr    $0x18,%eax
c0103c0c:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103c11:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c0103c18:	e8 de fe ff ff       	call   c0103afb <lgdt>
c0103c1d:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103c23:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103c27:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103c2a:	c9                   	leave  
c0103c2b:	c3                   	ret    

c0103c2c <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103c2c:	55                   	push   %ebp
c0103c2d:	89 e5                	mov    %esp,%ebp
c0103c2f:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103c32:	c7 05 5c 89 11 c0 90 	movl   $0xc0106990,0xc011895c
c0103c39:	69 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103c3c:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103c41:	8b 00                	mov    (%eax),%eax
c0103c43:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103c47:	c7 04 24 2c 6a 10 c0 	movl   $0xc0106a2c,(%esp)
c0103c4e:	e8 e9 c6 ff ff       	call   c010033c <cprintf>
    pmm_manager->init();
c0103c53:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103c58:	8b 40 04             	mov    0x4(%eax),%eax
c0103c5b:	ff d0                	call   *%eax
}
c0103c5d:	c9                   	leave  
c0103c5e:	c3                   	ret    

c0103c5f <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103c5f:	55                   	push   %ebp
c0103c60:	89 e5                	mov    %esp,%ebp
c0103c62:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103c65:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103c6a:	8b 40 08             	mov    0x8(%eax),%eax
c0103c6d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103c70:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103c74:	8b 55 08             	mov    0x8(%ebp),%edx
c0103c77:	89 14 24             	mov    %edx,(%esp)
c0103c7a:	ff d0                	call   *%eax
}
c0103c7c:	c9                   	leave  
c0103c7d:	c3                   	ret    

c0103c7e <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103c7e:	55                   	push   %ebp
c0103c7f:	89 e5                	mov    %esp,%ebp
c0103c81:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103c84:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103c8b:	e8 2e fe ff ff       	call   c0103abe <__intr_save>
c0103c90:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103c93:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103c98:	8b 40 0c             	mov    0xc(%eax),%eax
c0103c9b:	8b 55 08             	mov    0x8(%ebp),%edx
c0103c9e:	89 14 24             	mov    %edx,(%esp)
c0103ca1:	ff d0                	call   *%eax
c0103ca3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103ca6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ca9:	89 04 24             	mov    %eax,(%esp)
c0103cac:	e8 37 fe ff ff       	call   c0103ae8 <__intr_restore>
    return page;
c0103cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103cb4:	c9                   	leave  
c0103cb5:	c3                   	ret    

c0103cb6 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103cb6:	55                   	push   %ebp
c0103cb7:	89 e5                	mov    %esp,%ebp
c0103cb9:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103cbc:	e8 fd fd ff ff       	call   c0103abe <__intr_save>
c0103cc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103cc4:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103cc9:	8b 40 10             	mov    0x10(%eax),%eax
c0103ccc:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103ccf:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103cd3:	8b 55 08             	mov    0x8(%ebp),%edx
c0103cd6:	89 14 24             	mov    %edx,(%esp)
c0103cd9:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cde:	89 04 24             	mov    %eax,(%esp)
c0103ce1:	e8 02 fe ff ff       	call   c0103ae8 <__intr_restore>
}
c0103ce6:	c9                   	leave  
c0103ce7:	c3                   	ret    

c0103ce8 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103ce8:	55                   	push   %ebp
c0103ce9:	89 e5                	mov    %esp,%ebp
c0103ceb:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103cee:	e8 cb fd ff ff       	call   c0103abe <__intr_save>
c0103cf3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103cf6:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103cfb:	8b 40 14             	mov    0x14(%eax),%eax
c0103cfe:	ff d0                	call   *%eax
c0103d00:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d06:	89 04 24             	mov    %eax,(%esp)
c0103d09:	e8 da fd ff ff       	call   c0103ae8 <__intr_restore>
    return ret;
c0103d0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103d11:	c9                   	leave  
c0103d12:	c3                   	ret    

c0103d13 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103d13:	55                   	push   %ebp
c0103d14:	89 e5                	mov    %esp,%ebp
c0103d16:	57                   	push   %edi
c0103d17:	56                   	push   %esi
c0103d18:	53                   	push   %ebx
c0103d19:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103d1f:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103d26:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103d2d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103d34:	c7 04 24 43 6a 10 c0 	movl   $0xc0106a43,(%esp)
c0103d3b:	e8 fc c5 ff ff       	call   c010033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103d40:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103d47:	e9 15 01 00 00       	jmp    c0103e61 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103d4c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103d4f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103d52:	89 d0                	mov    %edx,%eax
c0103d54:	c1 e0 02             	shl    $0x2,%eax
c0103d57:	01 d0                	add    %edx,%eax
c0103d59:	c1 e0 02             	shl    $0x2,%eax
c0103d5c:	01 c8                	add    %ecx,%eax
c0103d5e:	8b 50 08             	mov    0x8(%eax),%edx
c0103d61:	8b 40 04             	mov    0x4(%eax),%eax
c0103d64:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103d67:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103d6a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103d6d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103d70:	89 d0                	mov    %edx,%eax
c0103d72:	c1 e0 02             	shl    $0x2,%eax
c0103d75:	01 d0                	add    %edx,%eax
c0103d77:	c1 e0 02             	shl    $0x2,%eax
c0103d7a:	01 c8                	add    %ecx,%eax
c0103d7c:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103d7f:	8b 58 10             	mov    0x10(%eax),%ebx
c0103d82:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103d85:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103d88:	01 c8                	add    %ecx,%eax
c0103d8a:	11 da                	adc    %ebx,%edx
c0103d8c:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103d8f:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103d92:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103d95:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103d98:	89 d0                	mov    %edx,%eax
c0103d9a:	c1 e0 02             	shl    $0x2,%eax
c0103d9d:	01 d0                	add    %edx,%eax
c0103d9f:	c1 e0 02             	shl    $0x2,%eax
c0103da2:	01 c8                	add    %ecx,%eax
c0103da4:	83 c0 14             	add    $0x14,%eax
c0103da7:	8b 00                	mov    (%eax),%eax
c0103da9:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0103daf:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103db2:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103db5:	83 c0 ff             	add    $0xffffffff,%eax
c0103db8:	83 d2 ff             	adc    $0xffffffff,%edx
c0103dbb:	89 c6                	mov    %eax,%esi
c0103dbd:	89 d7                	mov    %edx,%edi
c0103dbf:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103dc2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103dc5:	89 d0                	mov    %edx,%eax
c0103dc7:	c1 e0 02             	shl    $0x2,%eax
c0103dca:	01 d0                	add    %edx,%eax
c0103dcc:	c1 e0 02             	shl    $0x2,%eax
c0103dcf:	01 c8                	add    %ecx,%eax
c0103dd1:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103dd4:	8b 58 10             	mov    0x10(%eax),%ebx
c0103dd7:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0103ddd:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0103de1:	89 74 24 14          	mov    %esi,0x14(%esp)
c0103de5:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0103de9:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103dec:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103def:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103df3:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103df7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103dfb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0103dff:	c7 04 24 50 6a 10 c0 	movl   $0xc0106a50,(%esp)
c0103e06:	e8 31 c5 ff ff       	call   c010033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103e0b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e0e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e11:	89 d0                	mov    %edx,%eax
c0103e13:	c1 e0 02             	shl    $0x2,%eax
c0103e16:	01 d0                	add    %edx,%eax
c0103e18:	c1 e0 02             	shl    $0x2,%eax
c0103e1b:	01 c8                	add    %ecx,%eax
c0103e1d:	83 c0 14             	add    $0x14,%eax
c0103e20:	8b 00                	mov    (%eax),%eax
c0103e22:	83 f8 01             	cmp    $0x1,%eax
c0103e25:	75 36                	jne    c0103e5d <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0103e27:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103e2a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103e2d:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103e30:	77 2b                	ja     c0103e5d <page_init+0x14a>
c0103e32:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103e35:	72 05                	jb     c0103e3c <page_init+0x129>
c0103e37:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0103e3a:	73 21                	jae    c0103e5d <page_init+0x14a>
c0103e3c:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103e40:	77 1b                	ja     c0103e5d <page_init+0x14a>
c0103e42:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103e46:	72 09                	jb     c0103e51 <page_init+0x13e>
c0103e48:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0103e4f:	77 0c                	ja     c0103e5d <page_init+0x14a>
                maxpa = end;
c0103e51:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103e54:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103e57:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103e5a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103e5d:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103e61:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103e64:	8b 00                	mov    (%eax),%eax
c0103e66:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103e69:	0f 8f dd fe ff ff    	jg     c0103d4c <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0103e6f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103e73:	72 1d                	jb     c0103e92 <page_init+0x17f>
c0103e75:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103e79:	77 09                	ja     c0103e84 <page_init+0x171>
c0103e7b:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0103e82:	76 0e                	jbe    c0103e92 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0103e84:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0103e8b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0103e92:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103e95:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103e98:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103e9c:	c1 ea 0c             	shr    $0xc,%edx
c0103e9f:	a3 c0 88 11 c0       	mov    %eax,0xc01188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0103ea4:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0103eab:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c0103eb0:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103eb3:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103eb6:	01 d0                	add    %edx,%eax
c0103eb8:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103ebb:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103ebe:	ba 00 00 00 00       	mov    $0x0,%edx
c0103ec3:	f7 75 ac             	divl   -0x54(%ebp)
c0103ec6:	89 d0                	mov    %edx,%eax
c0103ec8:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0103ecb:	29 c2                	sub    %eax,%edx
c0103ecd:	89 d0                	mov    %edx,%eax
c0103ecf:	a3 64 89 11 c0       	mov    %eax,0xc0118964

    for (i = 0; i < npage; i ++) {
c0103ed4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103edb:	eb 2f                	jmp    c0103f0c <page_init+0x1f9>
        SetPageReserved(pages + i);
c0103edd:	8b 0d 64 89 11 c0    	mov    0xc0118964,%ecx
c0103ee3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ee6:	89 d0                	mov    %edx,%eax
c0103ee8:	c1 e0 02             	shl    $0x2,%eax
c0103eeb:	01 d0                	add    %edx,%eax
c0103eed:	c1 e0 02             	shl    $0x2,%eax
c0103ef0:	01 c8                	add    %ecx,%eax
c0103ef2:	83 c0 04             	add    $0x4,%eax
c0103ef5:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0103efc:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103eff:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103f02:	8b 55 90             	mov    -0x70(%ebp),%edx
c0103f05:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0103f08:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103f0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f0f:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103f14:	39 c2                	cmp    %eax,%edx
c0103f16:	72 c5                	jb     c0103edd <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0103f18:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0103f1e:	89 d0                	mov    %edx,%eax
c0103f20:	c1 e0 02             	shl    $0x2,%eax
c0103f23:	01 d0                	add    %edx,%eax
c0103f25:	c1 e0 02             	shl    $0x2,%eax
c0103f28:	89 c2                	mov    %eax,%edx
c0103f2a:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0103f2f:	01 d0                	add    %edx,%eax
c0103f31:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0103f34:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0103f3b:	77 23                	ja     c0103f60 <page_init+0x24d>
c0103f3d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103f40:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103f44:	c7 44 24 08 80 6a 10 	movl   $0xc0106a80,0x8(%esp)
c0103f4b:	c0 
c0103f4c:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0103f53:	00 
c0103f54:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c0103f5b:	e8 66 cd ff ff       	call   c0100cc6 <__panic>
c0103f60:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103f63:	05 00 00 00 40       	add    $0x40000000,%eax
c0103f68:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0103f6b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103f72:	e9 74 01 00 00       	jmp    c01040eb <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103f77:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103f7a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f7d:	89 d0                	mov    %edx,%eax
c0103f7f:	c1 e0 02             	shl    $0x2,%eax
c0103f82:	01 d0                	add    %edx,%eax
c0103f84:	c1 e0 02             	shl    $0x2,%eax
c0103f87:	01 c8                	add    %ecx,%eax
c0103f89:	8b 50 08             	mov    0x8(%eax),%edx
c0103f8c:	8b 40 04             	mov    0x4(%eax),%eax
c0103f8f:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103f92:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103f95:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103f98:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f9b:	89 d0                	mov    %edx,%eax
c0103f9d:	c1 e0 02             	shl    $0x2,%eax
c0103fa0:	01 d0                	add    %edx,%eax
c0103fa2:	c1 e0 02             	shl    $0x2,%eax
c0103fa5:	01 c8                	add    %ecx,%eax
c0103fa7:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103faa:	8b 58 10             	mov    0x10(%eax),%ebx
c0103fad:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103fb0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103fb3:	01 c8                	add    %ecx,%eax
c0103fb5:	11 da                	adc    %ebx,%edx
c0103fb7:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0103fba:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0103fbd:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103fc0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103fc3:	89 d0                	mov    %edx,%eax
c0103fc5:	c1 e0 02             	shl    $0x2,%eax
c0103fc8:	01 d0                	add    %edx,%eax
c0103fca:	c1 e0 02             	shl    $0x2,%eax
c0103fcd:	01 c8                	add    %ecx,%eax
c0103fcf:	83 c0 14             	add    $0x14,%eax
c0103fd2:	8b 00                	mov    (%eax),%eax
c0103fd4:	83 f8 01             	cmp    $0x1,%eax
c0103fd7:	0f 85 0a 01 00 00    	jne    c01040e7 <page_init+0x3d4>
            if (begin < freemem) {
c0103fdd:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103fe0:	ba 00 00 00 00       	mov    $0x0,%edx
c0103fe5:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0103fe8:	72 17                	jb     c0104001 <page_init+0x2ee>
c0103fea:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0103fed:	77 05                	ja     c0103ff4 <page_init+0x2e1>
c0103fef:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0103ff2:	76 0d                	jbe    c0104001 <page_init+0x2ee>
                begin = freemem;
c0103ff4:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103ff7:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103ffa:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0104001:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104005:	72 1d                	jb     c0104024 <page_init+0x311>
c0104007:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010400b:	77 09                	ja     c0104016 <page_init+0x303>
c010400d:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0104014:	76 0e                	jbe    c0104024 <page_init+0x311>
                end = KMEMSIZE;
c0104016:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c010401d:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0104024:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104027:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010402a:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010402d:	0f 87 b4 00 00 00    	ja     c01040e7 <page_init+0x3d4>
c0104033:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104036:	72 09                	jb     c0104041 <page_init+0x32e>
c0104038:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010403b:	0f 83 a6 00 00 00    	jae    c01040e7 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c0104041:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0104048:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010404b:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010404e:	01 d0                	add    %edx,%eax
c0104050:	83 e8 01             	sub    $0x1,%eax
c0104053:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104056:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104059:	ba 00 00 00 00       	mov    $0x0,%edx
c010405e:	f7 75 9c             	divl   -0x64(%ebp)
c0104061:	89 d0                	mov    %edx,%eax
c0104063:	8b 55 98             	mov    -0x68(%ebp),%edx
c0104066:	29 c2                	sub    %eax,%edx
c0104068:	89 d0                	mov    %edx,%eax
c010406a:	ba 00 00 00 00       	mov    $0x0,%edx
c010406f:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104072:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0104075:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104078:	89 45 94             	mov    %eax,-0x6c(%ebp)
c010407b:	8b 45 94             	mov    -0x6c(%ebp),%eax
c010407e:	ba 00 00 00 00       	mov    $0x0,%edx
c0104083:	89 c7                	mov    %eax,%edi
c0104085:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c010408b:	89 7d 80             	mov    %edi,-0x80(%ebp)
c010408e:	89 d0                	mov    %edx,%eax
c0104090:	83 e0 00             	and    $0x0,%eax
c0104093:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104096:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104099:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010409c:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010409f:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c01040a2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01040a5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01040a8:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01040ab:	77 3a                	ja     c01040e7 <page_init+0x3d4>
c01040ad:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01040b0:	72 05                	jb     c01040b7 <page_init+0x3a4>
c01040b2:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01040b5:	73 30                	jae    c01040e7 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01040b7:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c01040ba:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c01040bd:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01040c0:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01040c3:	29 c8                	sub    %ecx,%eax
c01040c5:	19 da                	sbb    %ebx,%edx
c01040c7:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01040cb:	c1 ea 0c             	shr    $0xc,%edx
c01040ce:	89 c3                	mov    %eax,%ebx
c01040d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01040d3:	89 04 24             	mov    %eax,(%esp)
c01040d6:	e8 a5 f8 ff ff       	call   c0103980 <pa2page>
c01040db:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01040df:	89 04 24             	mov    %eax,(%esp)
c01040e2:	e8 78 fb ff ff       	call   c0103c5f <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c01040e7:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01040eb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01040ee:	8b 00                	mov    (%eax),%eax
c01040f0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01040f3:	0f 8f 7e fe ff ff    	jg     c0103f77 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c01040f9:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c01040ff:	5b                   	pop    %ebx
c0104100:	5e                   	pop    %esi
c0104101:	5f                   	pop    %edi
c0104102:	5d                   	pop    %ebp
c0104103:	c3                   	ret    

c0104104 <enable_paging>:

static void
enable_paging(void) {
c0104104:	55                   	push   %ebp
c0104105:	89 e5                	mov    %esp,%ebp
c0104107:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c010410a:	a1 60 89 11 c0       	mov    0xc0118960,%eax
c010410f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0104112:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0104115:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c0104118:	0f 20 c0             	mov    %cr0,%eax
c010411b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c010411e:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0104121:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c0104124:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c010412b:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c010412f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104132:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c0104135:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104138:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c010413b:	c9                   	leave  
c010413c:	c3                   	ret    

c010413d <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c010413d:	55                   	push   %ebp
c010413e:	89 e5                	mov    %esp,%ebp
c0104140:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0104143:	8b 45 14             	mov    0x14(%ebp),%eax
c0104146:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104149:	31 d0                	xor    %edx,%eax
c010414b:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104150:	85 c0                	test   %eax,%eax
c0104152:	74 24                	je     c0104178 <boot_map_segment+0x3b>
c0104154:	c7 44 24 0c b2 6a 10 	movl   $0xc0106ab2,0xc(%esp)
c010415b:	c0 
c010415c:	c7 44 24 08 c9 6a 10 	movl   $0xc0106ac9,0x8(%esp)
c0104163:	c0 
c0104164:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c010416b:	00 
c010416c:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c0104173:	e8 4e cb ff ff       	call   c0100cc6 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0104178:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c010417f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104182:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104187:	89 c2                	mov    %eax,%edx
c0104189:	8b 45 10             	mov    0x10(%ebp),%eax
c010418c:	01 c2                	add    %eax,%edx
c010418e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104191:	01 d0                	add    %edx,%eax
c0104193:	83 e8 01             	sub    $0x1,%eax
c0104196:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104199:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010419c:	ba 00 00 00 00       	mov    $0x0,%edx
c01041a1:	f7 75 f0             	divl   -0x10(%ebp)
c01041a4:	89 d0                	mov    %edx,%eax
c01041a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01041a9:	29 c2                	sub    %eax,%edx
c01041ab:	89 d0                	mov    %edx,%eax
c01041ad:	c1 e8 0c             	shr    $0xc,%eax
c01041b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01041b3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01041b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01041b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01041bc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01041c1:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01041c4:	8b 45 14             	mov    0x14(%ebp),%eax
c01041c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01041ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01041cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01041d2:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01041d5:	eb 6b                	jmp    c0104242 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01041d7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01041de:	00 
c01041df:	8b 45 0c             	mov    0xc(%ebp),%eax
c01041e2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01041e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01041e9:	89 04 24             	mov    %eax,(%esp)
c01041ec:	e8 cc 01 00 00       	call   c01043bd <get_pte>
c01041f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01041f4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01041f8:	75 24                	jne    c010421e <boot_map_segment+0xe1>
c01041fa:	c7 44 24 0c de 6a 10 	movl   $0xc0106ade,0xc(%esp)
c0104201:	c0 
c0104202:	c7 44 24 08 c9 6a 10 	movl   $0xc0106ac9,0x8(%esp)
c0104209:	c0 
c010420a:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0104211:	00 
c0104212:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c0104219:	e8 a8 ca ff ff       	call   c0100cc6 <__panic>
        *ptep = pa | PTE_P | perm;
c010421e:	8b 45 18             	mov    0x18(%ebp),%eax
c0104221:	8b 55 14             	mov    0x14(%ebp),%edx
c0104224:	09 d0                	or     %edx,%eax
c0104226:	83 c8 01             	or     $0x1,%eax
c0104229:	89 c2                	mov    %eax,%edx
c010422b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010422e:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104230:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104234:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c010423b:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0104242:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104246:	75 8f                	jne    c01041d7 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0104248:	c9                   	leave  
c0104249:	c3                   	ret    

c010424a <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c010424a:	55                   	push   %ebp
c010424b:	89 e5                	mov    %esp,%ebp
c010424d:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0104250:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104257:	e8 22 fa ff ff       	call   c0103c7e <alloc_pages>
c010425c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c010425f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104263:	75 1c                	jne    c0104281 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0104265:	c7 44 24 08 eb 6a 10 	movl   $0xc0106aeb,0x8(%esp)
c010426c:	c0 
c010426d:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c0104274:	00 
c0104275:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c010427c:	e8 45 ca ff ff       	call   c0100cc6 <__panic>
    }
    return page2kva(p);
c0104281:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104284:	89 04 24             	mov    %eax,(%esp)
c0104287:	e8 43 f7 ff ff       	call   c01039cf <page2kva>
}
c010428c:	c9                   	leave  
c010428d:	c3                   	ret    

c010428e <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c010428e:	55                   	push   %ebp
c010428f:	89 e5                	mov    %esp,%ebp
c0104291:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104294:	e8 93 f9 ff ff       	call   c0103c2c <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0104299:	e8 75 fa ff ff       	call   c0103d13 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c010429e:	e8 66 04 00 00       	call   c0104709 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c01042a3:	e8 a2 ff ff ff       	call   c010424a <boot_alloc_page>
c01042a8:	a3 c4 88 11 c0       	mov    %eax,0xc01188c4
    memset(boot_pgdir, 0, PGSIZE);
c01042ad:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01042b2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01042b9:	00 
c01042ba:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01042c1:	00 
c01042c2:	89 04 24             	mov    %eax,(%esp)
c01042c5:	e8 a3 1a 00 00       	call   c0105d6d <memset>
    boot_cr3 = PADDR(boot_pgdir);
c01042ca:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01042cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01042d2:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01042d9:	77 23                	ja     c01042fe <pmm_init+0x70>
c01042db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042de:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01042e2:	c7 44 24 08 80 6a 10 	movl   $0xc0106a80,0x8(%esp)
c01042e9:	c0 
c01042ea:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c01042f1:	00 
c01042f2:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c01042f9:	e8 c8 c9 ff ff       	call   c0100cc6 <__panic>
c01042fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104301:	05 00 00 00 40       	add    $0x40000000,%eax
c0104306:	a3 60 89 11 c0       	mov    %eax,0xc0118960

    check_pgdir();
c010430b:	e8 17 04 00 00       	call   c0104727 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0104310:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104315:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c010431b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104320:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104323:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010432a:	77 23                	ja     c010434f <pmm_init+0xc1>
c010432c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010432f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104333:	c7 44 24 08 80 6a 10 	movl   $0xc0106a80,0x8(%esp)
c010433a:	c0 
c010433b:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c0104342:	00 
c0104343:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c010434a:	e8 77 c9 ff ff       	call   c0100cc6 <__panic>
c010434f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104352:	05 00 00 00 40       	add    $0x40000000,%eax
c0104357:	83 c8 03             	or     $0x3,%eax
c010435a:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c010435c:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104361:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0104368:	00 
c0104369:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104370:	00 
c0104371:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0104378:	38 
c0104379:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0104380:	c0 
c0104381:	89 04 24             	mov    %eax,(%esp)
c0104384:	e8 b4 fd ff ff       	call   c010413d <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c0104389:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010438e:	8b 15 c4 88 11 c0    	mov    0xc01188c4,%edx
c0104394:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c010439a:	89 10                	mov    %edx,(%eax)

    enable_paging();
c010439c:	e8 63 fd ff ff       	call   c0104104 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01043a1:	e8 97 f7 ff ff       	call   c0103b3d <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c01043a6:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01043ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01043b1:	e8 0c 0a 00 00       	call   c0104dc2 <check_boot_pgdir>

    print_pgdir();
c01043b6:	e8 94 0e 00 00       	call   c010524f <print_pgdir>

}
c01043bb:	c9                   	leave  
c01043bc:	c3                   	ret    

c01043bd <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01043bd:	55                   	push   %ebp
c01043be:	89 e5                	mov    %esp,%ebp
c01043c0:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
c01043c3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01043c6:	c1 e8 16             	shr    $0x16,%eax
c01043c9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01043d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01043d3:	01 d0                	add    %edx,%eax
c01043d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
c01043d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043db:	8b 00                	mov    (%eax),%eax
c01043dd:	83 e0 01             	and    $0x1,%eax
c01043e0:	85 c0                	test   %eax,%eax
c01043e2:	0f 85 af 00 00 00    	jne    c0104497 <get_pte+0xda>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
c01043e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01043ec:	74 15                	je     c0104403 <get_pte+0x46>
c01043ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01043f5:	e8 84 f8 ff ff       	call   c0103c7e <alloc_pages>
c01043fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01043fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104401:	75 0a                	jne    c010440d <get_pte+0x50>
            return NULL;
c0104403:	b8 00 00 00 00       	mov    $0x0,%eax
c0104408:	e9 e6 00 00 00       	jmp    c01044f3 <get_pte+0x136>
        }
        set_page_ref(page, 1);
c010440d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104414:	00 
c0104415:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104418:	89 04 24             	mov    %eax,(%esp)
c010441b:	e8 63 f6 ff ff       	call   c0103a83 <set_page_ref>
        uintptr_t pa = page2pa(page);
c0104420:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104423:	89 04 24             	mov    %eax,(%esp)
c0104426:	e8 3f f5 ff ff       	call   c010396a <page2pa>
c010442b:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
c010442e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104431:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104434:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104437:	c1 e8 0c             	shr    $0xc,%eax
c010443a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010443d:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104442:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104445:	72 23                	jb     c010446a <get_pte+0xad>
c0104447:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010444a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010444e:	c7 44 24 08 dc 69 10 	movl   $0xc01069dc,0x8(%esp)
c0104455:	c0 
c0104456:	c7 44 24 04 87 01 00 	movl   $0x187,0x4(%esp)
c010445d:	00 
c010445e:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c0104465:	e8 5c c8 ff ff       	call   c0100cc6 <__panic>
c010446a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010446d:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104472:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104479:	00 
c010447a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104481:	00 
c0104482:	89 04 24             	mov    %eax,(%esp)
c0104485:	e8 e3 18 00 00       	call   c0105d6d <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c010448a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010448d:	83 c8 07             	or     $0x7,%eax
c0104490:	89 c2                	mov    %eax,%edx
c0104492:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104495:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c0104497:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010449a:	8b 00                	mov    (%eax),%eax
c010449c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01044a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01044a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01044a7:	c1 e8 0c             	shr    $0xc,%eax
c01044aa:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01044ad:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01044b2:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01044b5:	72 23                	jb     c01044da <get_pte+0x11d>
c01044b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01044ba:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01044be:	c7 44 24 08 dc 69 10 	movl   $0xc01069dc,0x8(%esp)
c01044c5:	c0 
c01044c6:	c7 44 24 04 8a 01 00 	movl   $0x18a,0x4(%esp)
c01044cd:	00 
c01044ce:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c01044d5:	e8 ec c7 ff ff       	call   c0100cc6 <__panic>
c01044da:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01044dd:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01044e2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01044e5:	c1 ea 0c             	shr    $0xc,%edx
c01044e8:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c01044ee:	c1 e2 02             	shl    $0x2,%edx
c01044f1:	01 d0                	add    %edx,%eax
}
c01044f3:	c9                   	leave  
c01044f4:	c3                   	ret    

c01044f5 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01044f5:	55                   	push   %ebp
c01044f6:	89 e5                	mov    %esp,%ebp
c01044f8:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01044fb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104502:	00 
c0104503:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104506:	89 44 24 04          	mov    %eax,0x4(%esp)
c010450a:	8b 45 08             	mov    0x8(%ebp),%eax
c010450d:	89 04 24             	mov    %eax,(%esp)
c0104510:	e8 a8 fe ff ff       	call   c01043bd <get_pte>
c0104515:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0104518:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010451c:	74 08                	je     c0104526 <get_page+0x31>
        *ptep_store = ptep;
c010451e:	8b 45 10             	mov    0x10(%ebp),%eax
c0104521:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104524:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0104526:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010452a:	74 1b                	je     c0104547 <get_page+0x52>
c010452c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010452f:	8b 00                	mov    (%eax),%eax
c0104531:	83 e0 01             	and    $0x1,%eax
c0104534:	85 c0                	test   %eax,%eax
c0104536:	74 0f                	je     c0104547 <get_page+0x52>
        return pte2page(*ptep);
c0104538:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010453b:	8b 00                	mov    (%eax),%eax
c010453d:	89 04 24             	mov    %eax,(%esp)
c0104540:	e8 de f4 ff ff       	call   c0103a23 <pte2page>
c0104545:	eb 05                	jmp    c010454c <get_page+0x57>
    }
    return NULL;
c0104547:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010454c:	c9                   	leave  
c010454d:	c3                   	ret    

c010454e <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c010454e:	55                   	push   %ebp
c010454f:	89 e5                	mov    %esp,%ebp
c0104551:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
c0104554:	8b 45 10             	mov    0x10(%ebp),%eax
c0104557:	8b 00                	mov    (%eax),%eax
c0104559:	83 e0 01             	and    $0x1,%eax
c010455c:	85 c0                	test   %eax,%eax
c010455e:	74 4d                	je     c01045ad <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep);
c0104560:	8b 45 10             	mov    0x10(%ebp),%eax
c0104563:	8b 00                	mov    (%eax),%eax
c0104565:	89 04 24             	mov    %eax,(%esp)
c0104568:	e8 b6 f4 ff ff       	call   c0103a23 <pte2page>
c010456d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {
c0104570:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104573:	89 04 24             	mov    %eax,(%esp)
c0104576:	e8 2c f5 ff ff       	call   c0103aa7 <page_ref_dec>
c010457b:	85 c0                	test   %eax,%eax
c010457d:	75 13                	jne    c0104592 <page_remove_pte+0x44>
            free_page(page);
c010457f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104586:	00 
c0104587:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010458a:	89 04 24             	mov    %eax,(%esp)
c010458d:	e8 24 f7 ff ff       	call   c0103cb6 <free_pages>
        }
        *ptep = 0;
c0104592:	8b 45 10             	mov    0x10(%ebp),%eax
c0104595:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c010459b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010459e:	89 44 24 04          	mov    %eax,0x4(%esp)
c01045a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01045a5:	89 04 24             	mov    %eax,(%esp)
c01045a8:	e8 ff 00 00 00       	call   c01046ac <tlb_invalidate>
    }
}
c01045ad:	c9                   	leave  
c01045ae:	c3                   	ret    

c01045af <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01045af:	55                   	push   %ebp
c01045b0:	89 e5                	mov    %esp,%ebp
c01045b2:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01045b5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01045bc:	00 
c01045bd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01045c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01045c7:	89 04 24             	mov    %eax,(%esp)
c01045ca:	e8 ee fd ff ff       	call   c01043bd <get_pte>
c01045cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c01045d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01045d6:	74 19                	je     c01045f1 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c01045d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045db:	89 44 24 08          	mov    %eax,0x8(%esp)
c01045df:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045e2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01045e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01045e9:	89 04 24             	mov    %eax,(%esp)
c01045ec:	e8 5d ff ff ff       	call   c010454e <page_remove_pte>
    }
}
c01045f1:	c9                   	leave  
c01045f2:	c3                   	ret    

c01045f3 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c01045f3:	55                   	push   %ebp
c01045f4:	89 e5                	mov    %esp,%ebp
c01045f6:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c01045f9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104600:	00 
c0104601:	8b 45 10             	mov    0x10(%ebp),%eax
c0104604:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104608:	8b 45 08             	mov    0x8(%ebp),%eax
c010460b:	89 04 24             	mov    %eax,(%esp)
c010460e:	e8 aa fd ff ff       	call   c01043bd <get_pte>
c0104613:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0104616:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010461a:	75 0a                	jne    c0104626 <page_insert+0x33>
        return -E_NO_MEM;
c010461c:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0104621:	e9 84 00 00 00       	jmp    c01046aa <page_insert+0xb7>
    }
    page_ref_inc(page);
c0104626:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104629:	89 04 24             	mov    %eax,(%esp)
c010462c:	e8 5f f4 ff ff       	call   c0103a90 <page_ref_inc>
    if (*ptep & PTE_P) {
c0104631:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104634:	8b 00                	mov    (%eax),%eax
c0104636:	83 e0 01             	and    $0x1,%eax
c0104639:	85 c0                	test   %eax,%eax
c010463b:	74 3e                	je     c010467b <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c010463d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104640:	8b 00                	mov    (%eax),%eax
c0104642:	89 04 24             	mov    %eax,(%esp)
c0104645:	e8 d9 f3 ff ff       	call   c0103a23 <pte2page>
c010464a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c010464d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104650:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104653:	75 0d                	jne    c0104662 <page_insert+0x6f>
            page_ref_dec(page);
c0104655:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104658:	89 04 24             	mov    %eax,(%esp)
c010465b:	e8 47 f4 ff ff       	call   c0103aa7 <page_ref_dec>
c0104660:	eb 19                	jmp    c010467b <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0104662:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104665:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104669:	8b 45 10             	mov    0x10(%ebp),%eax
c010466c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104670:	8b 45 08             	mov    0x8(%ebp),%eax
c0104673:	89 04 24             	mov    %eax,(%esp)
c0104676:	e8 d3 fe ff ff       	call   c010454e <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c010467b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010467e:	89 04 24             	mov    %eax,(%esp)
c0104681:	e8 e4 f2 ff ff       	call   c010396a <page2pa>
c0104686:	0b 45 14             	or     0x14(%ebp),%eax
c0104689:	83 c8 01             	or     $0x1,%eax
c010468c:	89 c2                	mov    %eax,%edx
c010468e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104691:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0104693:	8b 45 10             	mov    0x10(%ebp),%eax
c0104696:	89 44 24 04          	mov    %eax,0x4(%esp)
c010469a:	8b 45 08             	mov    0x8(%ebp),%eax
c010469d:	89 04 24             	mov    %eax,(%esp)
c01046a0:	e8 07 00 00 00       	call   c01046ac <tlb_invalidate>
    return 0;
c01046a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01046aa:	c9                   	leave  
c01046ab:	c3                   	ret    

c01046ac <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01046ac:	55                   	push   %ebp
c01046ad:	89 e5                	mov    %esp,%ebp
c01046af:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01046b2:	0f 20 d8             	mov    %cr3,%eax
c01046b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01046b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c01046bb:	89 c2                	mov    %eax,%edx
c01046bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01046c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01046c3:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01046ca:	77 23                	ja     c01046ef <tlb_invalidate+0x43>
c01046cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01046d3:	c7 44 24 08 80 6a 10 	movl   $0xc0106a80,0x8(%esp)
c01046da:	c0 
c01046db:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
c01046e2:	00 
c01046e3:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c01046ea:	e8 d7 c5 ff ff       	call   c0100cc6 <__panic>
c01046ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046f2:	05 00 00 00 40       	add    $0x40000000,%eax
c01046f7:	39 c2                	cmp    %eax,%edx
c01046f9:	75 0c                	jne    c0104707 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c01046fb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0104701:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104704:	0f 01 38             	invlpg (%eax)
    }
}
c0104707:	c9                   	leave  
c0104708:	c3                   	ret    

c0104709 <check_alloc_page>:

static void
check_alloc_page(void) {
c0104709:	55                   	push   %ebp
c010470a:	89 e5                	mov    %esp,%ebp
c010470c:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c010470f:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0104714:	8b 40 18             	mov    0x18(%eax),%eax
c0104717:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0104719:	c7 04 24 04 6b 10 c0 	movl   $0xc0106b04,(%esp)
c0104720:	e8 17 bc ff ff       	call   c010033c <cprintf>
}
c0104725:	c9                   	leave  
c0104726:	c3                   	ret    

c0104727 <check_pgdir>:

static void
check_pgdir(void) {
c0104727:	55                   	push   %ebp
c0104728:	89 e5                	mov    %esp,%ebp
c010472a:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c010472d:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104732:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0104737:	76 24                	jbe    c010475d <check_pgdir+0x36>
c0104739:	c7 44 24 0c 23 6b 10 	movl   $0xc0106b23,0xc(%esp)
c0104740:	c0 
c0104741:	c7 44 24 08 c9 6a 10 	movl   $0xc0106ac9,0x8(%esp)
c0104748:	c0 
c0104749:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
c0104750:	00 
c0104751:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c0104758:	e8 69 c5 ff ff       	call   c0100cc6 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c010475d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104762:	85 c0                	test   %eax,%eax
c0104764:	74 0e                	je     c0104774 <check_pgdir+0x4d>
c0104766:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010476b:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104770:	85 c0                	test   %eax,%eax
c0104772:	74 24                	je     c0104798 <check_pgdir+0x71>
c0104774:	c7 44 24 0c 40 6b 10 	movl   $0xc0106b40,0xc(%esp)
c010477b:	c0 
c010477c:	c7 44 24 08 c9 6a 10 	movl   $0xc0106ac9,0x8(%esp)
c0104783:	c0 
c0104784:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
c010478b:	00 
c010478c:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c0104793:	e8 2e c5 ff ff       	call   c0100cc6 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0104798:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010479d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01047a4:	00 
c01047a5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01047ac:	00 
c01047ad:	89 04 24             	mov    %eax,(%esp)
c01047b0:	e8 40 fd ff ff       	call   c01044f5 <get_page>
c01047b5:	85 c0                	test   %eax,%eax
c01047b7:	74 24                	je     c01047dd <check_pgdir+0xb6>
c01047b9:	c7 44 24 0c 78 6b 10 	movl   $0xc0106b78,0xc(%esp)
c01047c0:	c0 
c01047c1:	c7 44 24 08 c9 6a 10 	movl   $0xc0106ac9,0x8(%esp)
c01047c8:	c0 
c01047c9:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
c01047d0:	00 
c01047d1:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c01047d8:	e8 e9 c4 ff ff       	call   c0100cc6 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01047dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01047e4:	e8 95 f4 ff ff       	call   c0103c7e <alloc_pages>
c01047e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01047ec:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01047f1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01047f8:	00 
c01047f9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104800:	00 
c0104801:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104804:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104808:	89 04 24             	mov    %eax,(%esp)
c010480b:	e8 e3 fd ff ff       	call   c01045f3 <page_insert>
c0104810:	85 c0                	test   %eax,%eax
c0104812:	74 24                	je     c0104838 <check_pgdir+0x111>
c0104814:	c7 44 24 0c a0 6b 10 	movl   $0xc0106ba0,0xc(%esp)
c010481b:	c0 
c010481c:	c7 44 24 08 c9 6a 10 	movl   $0xc0106ac9,0x8(%esp)
c0104823:	c0 
c0104824:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c010482b:	00 
c010482c:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c0104833:	e8 8e c4 ff ff       	call   c0100cc6 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0104838:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010483d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104844:	00 
c0104845:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010484c:	00 
c010484d:	89 04 24             	mov    %eax,(%esp)
c0104850:	e8 68 fb ff ff       	call   c01043bd <get_pte>
c0104855:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104858:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010485c:	75 24                	jne    c0104882 <check_pgdir+0x15b>
c010485e:	c7 44 24 0c cc 6b 10 	movl   $0xc0106bcc,0xc(%esp)
c0104865:	c0 
c0104866:	c7 44 24 08 c9 6a 10 	movl   $0xc0106ac9,0x8(%esp)
c010486d:	c0 
c010486e:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
c0104875:	00 
c0104876:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c010487d:	e8 44 c4 ff ff       	call   c0100cc6 <__panic>
    assert(pte2page(*ptep) == p1);
c0104882:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104885:	8b 00                	mov    (%eax),%eax
c0104887:	89 04 24             	mov    %eax,(%esp)
c010488a:	e8 94 f1 ff ff       	call   c0103a23 <pte2page>
c010488f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104892:	74 24                	je     c01048b8 <check_pgdir+0x191>
c0104894:	c7 44 24 0c f9 6b 10 	movl   $0xc0106bf9,0xc(%esp)
c010489b:	c0 
c010489c:	c7 44 24 08 c9 6a 10 	movl   $0xc0106ac9,0x8(%esp)
c01048a3:	c0 
c01048a4:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c01048ab:	00 
c01048ac:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c01048b3:	e8 0e c4 ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p1) == 1);
c01048b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048bb:	89 04 24             	mov    %eax,(%esp)
c01048be:	e8 b6 f1 ff ff       	call   c0103a79 <page_ref>
c01048c3:	83 f8 01             	cmp    $0x1,%eax
c01048c6:	74 24                	je     c01048ec <check_pgdir+0x1c5>
c01048c8:	c7 44 24 0c 0f 6c 10 	movl   $0xc0106c0f,0xc(%esp)
c01048cf:	c0 
c01048d0:	c7 44 24 08 c9 6a 10 	movl   $0xc0106ac9,0x8(%esp)
c01048d7:	c0 
c01048d8:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c01048df:	00 
c01048e0:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c01048e7:	e8 da c3 ff ff       	call   c0100cc6 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c01048ec:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01048f1:	8b 00                	mov    (%eax),%eax
c01048f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01048f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01048fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01048fe:	c1 e8 0c             	shr    $0xc,%eax
c0104901:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104904:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104909:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c010490c:	72 23                	jb     c0104931 <check_pgdir+0x20a>
c010490e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104911:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104915:	c7 44 24 08 dc 69 10 	movl   $0xc01069dc,0x8(%esp)
c010491c:	c0 
c010491d:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
c0104924:	00 
c0104925:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c010492c:	e8 95 c3 ff ff       	call   c0100cc6 <__panic>
c0104931:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104934:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104939:	83 c0 04             	add    $0x4,%eax
c010493c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c010493f:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104944:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010494b:	00 
c010494c:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104953:	00 
c0104954:	89 04 24             	mov    %eax,(%esp)
c0104957:	e8 61 fa ff ff       	call   c01043bd <get_pte>
c010495c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010495f:	74 24                	je     c0104985 <check_pgdir+0x25e>
c0104961:	c7 44 24 0c 24 6c 10 	movl   $0xc0106c24,0xc(%esp)
c0104968:	c0 
c0104969:	c7 44 24 08 c9 6a 10 	movl   $0xc0106ac9,0x8(%esp)
c0104970:	c0 
c0104971:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0104978:	00 
c0104979:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c0104980:	e8 41 c3 ff ff       	call   c0100cc6 <__panic>

    p2 = alloc_page();
c0104985:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010498c:	e8 ed f2 ff ff       	call   c0103c7e <alloc_pages>
c0104991:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0104994:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104999:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c01049a0:	00 
c01049a1:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01049a8:	00 
c01049a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01049ac:	89 54 24 04          	mov    %edx,0x4(%esp)
c01049b0:	89 04 24             	mov    %eax,(%esp)
c01049b3:	e8 3b fc ff ff       	call   c01045f3 <page_insert>
c01049b8:	85 c0                	test   %eax,%eax
c01049ba:	74 24                	je     c01049e0 <check_pgdir+0x2b9>
c01049bc:	c7 44 24 0c 4c 6c 10 	movl   $0xc0106c4c,0xc(%esp)
c01049c3:	c0 
c01049c4:	c7 44 24 08 c9 6a 10 	movl   $0xc0106ac9,0x8(%esp)
c01049cb:	c0 
c01049cc:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c01049d3:	00 
c01049d4:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c01049db:	e8 e6 c2 ff ff       	call   c0100cc6 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01049e0:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01049e5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01049ec:	00 
c01049ed:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01049f4:	00 
c01049f5:	89 04 24             	mov    %eax,(%esp)
c01049f8:	e8 c0 f9 ff ff       	call   c01043bd <get_pte>
c01049fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a00:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104a04:	75 24                	jne    c0104a2a <check_pgdir+0x303>
c0104a06:	c7 44 24 0c 84 6c 10 	movl   $0xc0106c84,0xc(%esp)
c0104a0d:	c0 
c0104a0e:	c7 44 24 08 c9 6a 10 	movl   $0xc0106ac9,0x8(%esp)
c0104a15:	c0 
c0104a16:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c0104a1d:	00 
c0104a1e:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c0104a25:	e8 9c c2 ff ff       	call   c0100cc6 <__panic>
    assert(*ptep & PTE_U);
c0104a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a2d:	8b 00                	mov    (%eax),%eax
c0104a2f:	83 e0 04             	and    $0x4,%eax
c0104a32:	85 c0                	test   %eax,%eax
c0104a34:	75 24                	jne    c0104a5a <check_pgdir+0x333>
c0104a36:	c7 44 24 0c b4 6c 10 	movl   $0xc0106cb4,0xc(%esp)
c0104a3d:	c0 
c0104a3e:	c7 44 24 08 c9 6a 10 	movl   $0xc0106ac9,0x8(%esp)
c0104a45:	c0 
c0104a46:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c0104a4d:	00 
c0104a4e:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c0104a55:	e8 6c c2 ff ff       	call   c0100cc6 <__panic>
    assert(*ptep & PTE_W);
c0104a5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a5d:	8b 00                	mov    (%eax),%eax
c0104a5f:	83 e0 02             	and    $0x2,%eax
c0104a62:	85 c0                	test   %eax,%eax
c0104a64:	75 24                	jne    c0104a8a <check_pgdir+0x363>
c0104a66:	c7 44 24 0c c2 6c 10 	movl   $0xc0106cc2,0xc(%esp)
c0104a6d:	c0 
c0104a6e:	c7 44 24 08 c9 6a 10 	movl   $0xc0106ac9,0x8(%esp)
c0104a75:	c0 
c0104a76:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0104a7d:	00 
c0104a7e:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c0104a85:	e8 3c c2 ff ff       	call   c0100cc6 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104a8a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104a8f:	8b 00                	mov    (%eax),%eax
c0104a91:	83 e0 04             	and    $0x4,%eax
c0104a94:	85 c0                	test   %eax,%eax
c0104a96:	75 24                	jne    c0104abc <check_pgdir+0x395>
c0104a98:	c7 44 24 0c d0 6c 10 	movl   $0xc0106cd0,0xc(%esp)
c0104a9f:	c0 
c0104aa0:	c7 44 24 08 c9 6a 10 	movl   $0xc0106ac9,0x8(%esp)
c0104aa7:	c0 
c0104aa8:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0104aaf:	00 
c0104ab0:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c0104ab7:	e8 0a c2 ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p2) == 1);
c0104abc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104abf:	89 04 24             	mov    %eax,(%esp)
c0104ac2:	e8 b2 ef ff ff       	call   c0103a79 <page_ref>
c0104ac7:	83 f8 01             	cmp    $0x1,%eax
c0104aca:	74 24                	je     c0104af0 <check_pgdir+0x3c9>
c0104acc:	c7 44 24 0c e6 6c 10 	movl   $0xc0106ce6,0xc(%esp)
c0104ad3:	c0 
c0104ad4:	c7 44 24 08 c9 6a 10 	movl   $0xc0106ac9,0x8(%esp)
c0104adb:	c0 
c0104adc:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0104ae3:	00 
c0104ae4:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c0104aeb:	e8 d6 c1 ff ff       	call   c0100cc6 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104af0:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104af5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104afc:	00 
c0104afd:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104b04:	00 
c0104b05:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104b08:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104b0c:	89 04 24             	mov    %eax,(%esp)
c0104b0f:	e8 df fa ff ff       	call   c01045f3 <page_insert>
c0104b14:	85 c0                	test   %eax,%eax
c0104b16:	74 24                	je     c0104b3c <check_pgdir+0x415>
c0104b18:	c7 44 24 0c f8 6c 10 	movl   $0xc0106cf8,0xc(%esp)
c0104b1f:	c0 
c0104b20:	c7 44 24 08 c9 6a 10 	movl   $0xc0106ac9,0x8(%esp)
c0104b27:	c0 
c0104b28:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c0104b2f:	00 
c0104b30:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c0104b37:	e8 8a c1 ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p1) == 2);
c0104b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b3f:	89 04 24             	mov    %eax,(%esp)
c0104b42:	e8 32 ef ff ff       	call   c0103a79 <page_ref>
c0104b47:	83 f8 02             	cmp    $0x2,%eax
c0104b4a:	74 24                	je     c0104b70 <check_pgdir+0x449>
c0104b4c:	c7 44 24 0c 24 6d 10 	movl   $0xc0106d24,0xc(%esp)
c0104b53:	c0 
c0104b54:	c7 44 24 08 c9 6a 10 	movl   $0xc0106ac9,0x8(%esp)
c0104b5b:	c0 
c0104b5c:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c0104b63:	00 
c0104b64:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c0104b6b:	e8 56 c1 ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p2) == 0);
c0104b70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b73:	89 04 24             	mov    %eax,(%esp)
c0104b76:	e8 fe ee ff ff       	call   c0103a79 <page_ref>
c0104b7b:	85 c0                	test   %eax,%eax
c0104b7d:	74 24                	je     c0104ba3 <check_pgdir+0x47c>
c0104b7f:	c7 44 24 0c 36 6d 10 	movl   $0xc0106d36,0xc(%esp)
c0104b86:	c0 
c0104b87:	c7 44 24 08 c9 6a 10 	movl   $0xc0106ac9,0x8(%esp)
c0104b8e:	c0 
c0104b8f:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
c0104b96:	00 
c0104b97:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c0104b9e:	e8 23 c1 ff ff       	call   c0100cc6 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104ba3:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104ba8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104baf:	00 
c0104bb0:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104bb7:	00 
c0104bb8:	89 04 24             	mov    %eax,(%esp)
c0104bbb:	e8 fd f7 ff ff       	call   c01043bd <get_pte>
c0104bc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104bc3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104bc7:	75 24                	jne    c0104bed <check_pgdir+0x4c6>
c0104bc9:	c7 44 24 0c 84 6c 10 	movl   $0xc0106c84,0xc(%esp)
c0104bd0:	c0 
c0104bd1:	c7 44 24 08 c9 6a 10 	movl   $0xc0106ac9,0x8(%esp)
c0104bd8:	c0 
c0104bd9:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0104be0:	00 
c0104be1:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c0104be8:	e8 d9 c0 ff ff       	call   c0100cc6 <__panic>
    assert(pte2page(*ptep) == p1);
c0104bed:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104bf0:	8b 00                	mov    (%eax),%eax
c0104bf2:	89 04 24             	mov    %eax,(%esp)
c0104bf5:	e8 29 ee ff ff       	call   c0103a23 <pte2page>
c0104bfa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104bfd:	74 24                	je     c0104c23 <check_pgdir+0x4fc>
c0104bff:	c7 44 24 0c f9 6b 10 	movl   $0xc0106bf9,0xc(%esp)
c0104c06:	c0 
c0104c07:	c7 44 24 08 c9 6a 10 	movl   $0xc0106ac9,0x8(%esp)
c0104c0e:	c0 
c0104c0f:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
c0104c16:	00 
c0104c17:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c0104c1e:	e8 a3 c0 ff ff       	call   c0100cc6 <__panic>
    assert((*ptep & PTE_U) == 0);
c0104c23:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c26:	8b 00                	mov    (%eax),%eax
c0104c28:	83 e0 04             	and    $0x4,%eax
c0104c2b:	85 c0                	test   %eax,%eax
c0104c2d:	74 24                	je     c0104c53 <check_pgdir+0x52c>
c0104c2f:	c7 44 24 0c 48 6d 10 	movl   $0xc0106d48,0xc(%esp)
c0104c36:	c0 
c0104c37:	c7 44 24 08 c9 6a 10 	movl   $0xc0106ac9,0x8(%esp)
c0104c3e:	c0 
c0104c3f:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c0104c46:	00 
c0104c47:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c0104c4e:	e8 73 c0 ff ff       	call   c0100cc6 <__panic>

    page_remove(boot_pgdir, 0x0);
c0104c53:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104c58:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104c5f:	00 
c0104c60:	89 04 24             	mov    %eax,(%esp)
c0104c63:	e8 47 f9 ff ff       	call   c01045af <page_remove>
    assert(page_ref(p1) == 1);
c0104c68:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c6b:	89 04 24             	mov    %eax,(%esp)
c0104c6e:	e8 06 ee ff ff       	call   c0103a79 <page_ref>
c0104c73:	83 f8 01             	cmp    $0x1,%eax
c0104c76:	74 24                	je     c0104c9c <check_pgdir+0x575>
c0104c78:	c7 44 24 0c 0f 6c 10 	movl   $0xc0106c0f,0xc(%esp)
c0104c7f:	c0 
c0104c80:	c7 44 24 08 c9 6a 10 	movl   $0xc0106ac9,0x8(%esp)
c0104c87:	c0 
c0104c88:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c0104c8f:	00 
c0104c90:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c0104c97:	e8 2a c0 ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p2) == 0);
c0104c9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c9f:	89 04 24             	mov    %eax,(%esp)
c0104ca2:	e8 d2 ed ff ff       	call   c0103a79 <page_ref>
c0104ca7:	85 c0                	test   %eax,%eax
c0104ca9:	74 24                	je     c0104ccf <check_pgdir+0x5a8>
c0104cab:	c7 44 24 0c 36 6d 10 	movl   $0xc0106d36,0xc(%esp)
c0104cb2:	c0 
c0104cb3:	c7 44 24 08 c9 6a 10 	movl   $0xc0106ac9,0x8(%esp)
c0104cba:	c0 
c0104cbb:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
c0104cc2:	00 
c0104cc3:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c0104cca:	e8 f7 bf ff ff       	call   c0100cc6 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104ccf:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104cd4:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104cdb:	00 
c0104cdc:	89 04 24             	mov    %eax,(%esp)
c0104cdf:	e8 cb f8 ff ff       	call   c01045af <page_remove>
    assert(page_ref(p1) == 0);
c0104ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ce7:	89 04 24             	mov    %eax,(%esp)
c0104cea:	e8 8a ed ff ff       	call   c0103a79 <page_ref>
c0104cef:	85 c0                	test   %eax,%eax
c0104cf1:	74 24                	je     c0104d17 <check_pgdir+0x5f0>
c0104cf3:	c7 44 24 0c 5d 6d 10 	movl   $0xc0106d5d,0xc(%esp)
c0104cfa:	c0 
c0104cfb:	c7 44 24 08 c9 6a 10 	movl   $0xc0106ac9,0x8(%esp)
c0104d02:	c0 
c0104d03:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c0104d0a:	00 
c0104d0b:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c0104d12:	e8 af bf ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p2) == 0);
c0104d17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d1a:	89 04 24             	mov    %eax,(%esp)
c0104d1d:	e8 57 ed ff ff       	call   c0103a79 <page_ref>
c0104d22:	85 c0                	test   %eax,%eax
c0104d24:	74 24                	je     c0104d4a <check_pgdir+0x623>
c0104d26:	c7 44 24 0c 36 6d 10 	movl   $0xc0106d36,0xc(%esp)
c0104d2d:	c0 
c0104d2e:	c7 44 24 08 c9 6a 10 	movl   $0xc0106ac9,0x8(%esp)
c0104d35:	c0 
c0104d36:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c0104d3d:	00 
c0104d3e:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c0104d45:	e8 7c bf ff ff       	call   c0100cc6 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0104d4a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104d4f:	8b 00                	mov    (%eax),%eax
c0104d51:	89 04 24             	mov    %eax,(%esp)
c0104d54:	e8 08 ed ff ff       	call   c0103a61 <pde2page>
c0104d59:	89 04 24             	mov    %eax,(%esp)
c0104d5c:	e8 18 ed ff ff       	call   c0103a79 <page_ref>
c0104d61:	83 f8 01             	cmp    $0x1,%eax
c0104d64:	74 24                	je     c0104d8a <check_pgdir+0x663>
c0104d66:	c7 44 24 0c 70 6d 10 	movl   $0xc0106d70,0xc(%esp)
c0104d6d:	c0 
c0104d6e:	c7 44 24 08 c9 6a 10 	movl   $0xc0106ac9,0x8(%esp)
c0104d75:	c0 
c0104d76:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
c0104d7d:	00 
c0104d7e:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c0104d85:	e8 3c bf ff ff       	call   c0100cc6 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0104d8a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104d8f:	8b 00                	mov    (%eax),%eax
c0104d91:	89 04 24             	mov    %eax,(%esp)
c0104d94:	e8 c8 ec ff ff       	call   c0103a61 <pde2page>
c0104d99:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104da0:	00 
c0104da1:	89 04 24             	mov    %eax,(%esp)
c0104da4:	e8 0d ef ff ff       	call   c0103cb6 <free_pages>
    boot_pgdir[0] = 0;
c0104da9:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104dae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104db4:	c7 04 24 97 6d 10 c0 	movl   $0xc0106d97,(%esp)
c0104dbb:	e8 7c b5 ff ff       	call   c010033c <cprintf>
}
c0104dc0:	c9                   	leave  
c0104dc1:	c3                   	ret    

c0104dc2 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104dc2:	55                   	push   %ebp
c0104dc3:	89 e5                	mov    %esp,%ebp
c0104dc5:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104dc8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104dcf:	e9 ca 00 00 00       	jmp    c0104e9e <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104dd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104dda:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ddd:	c1 e8 0c             	shr    $0xc,%eax
c0104de0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104de3:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104de8:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104deb:	72 23                	jb     c0104e10 <check_boot_pgdir+0x4e>
c0104ded:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104df0:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104df4:	c7 44 24 08 dc 69 10 	movl   $0xc01069dc,0x8(%esp)
c0104dfb:	c0 
c0104dfc:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c0104e03:	00 
c0104e04:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c0104e0b:	e8 b6 be ff ff       	call   c0100cc6 <__panic>
c0104e10:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e13:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104e18:	89 c2                	mov    %eax,%edx
c0104e1a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104e1f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104e26:	00 
c0104e27:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104e2b:	89 04 24             	mov    %eax,(%esp)
c0104e2e:	e8 8a f5 ff ff       	call   c01043bd <get_pte>
c0104e33:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104e36:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104e3a:	75 24                	jne    c0104e60 <check_boot_pgdir+0x9e>
c0104e3c:	c7 44 24 0c b4 6d 10 	movl   $0xc0106db4,0xc(%esp)
c0104e43:	c0 
c0104e44:	c7 44 24 08 c9 6a 10 	movl   $0xc0106ac9,0x8(%esp)
c0104e4b:	c0 
c0104e4c:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c0104e53:	00 
c0104e54:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c0104e5b:	e8 66 be ff ff       	call   c0100cc6 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104e60:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104e63:	8b 00                	mov    (%eax),%eax
c0104e65:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104e6a:	89 c2                	mov    %eax,%edx
c0104e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e6f:	39 c2                	cmp    %eax,%edx
c0104e71:	74 24                	je     c0104e97 <check_boot_pgdir+0xd5>
c0104e73:	c7 44 24 0c f1 6d 10 	movl   $0xc0106df1,0xc(%esp)
c0104e7a:	c0 
c0104e7b:	c7 44 24 08 c9 6a 10 	movl   $0xc0106ac9,0x8(%esp)
c0104e82:	c0 
c0104e83:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c0104e8a:	00 
c0104e8b:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c0104e92:	e8 2f be ff ff       	call   c0100cc6 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104e97:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104e9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104ea1:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104ea6:	39 c2                	cmp    %eax,%edx
c0104ea8:	0f 82 26 ff ff ff    	jb     c0104dd4 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104eae:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104eb3:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104eb8:	8b 00                	mov    (%eax),%eax
c0104eba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104ebf:	89 c2                	mov    %eax,%edx
c0104ec1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104ec6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104ec9:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0104ed0:	77 23                	ja     c0104ef5 <check_boot_pgdir+0x133>
c0104ed2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ed5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104ed9:	c7 44 24 08 80 6a 10 	movl   $0xc0106a80,0x8(%esp)
c0104ee0:	c0 
c0104ee1:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c0104ee8:	00 
c0104ee9:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c0104ef0:	e8 d1 bd ff ff       	call   c0100cc6 <__panic>
c0104ef5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ef8:	05 00 00 00 40       	add    $0x40000000,%eax
c0104efd:	39 c2                	cmp    %eax,%edx
c0104eff:	74 24                	je     c0104f25 <check_boot_pgdir+0x163>
c0104f01:	c7 44 24 0c 08 6e 10 	movl   $0xc0106e08,0xc(%esp)
c0104f08:	c0 
c0104f09:	c7 44 24 08 c9 6a 10 	movl   $0xc0106ac9,0x8(%esp)
c0104f10:	c0 
c0104f11:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c0104f18:	00 
c0104f19:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c0104f20:	e8 a1 bd ff ff       	call   c0100cc6 <__panic>

    assert(boot_pgdir[0] == 0);
c0104f25:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104f2a:	8b 00                	mov    (%eax),%eax
c0104f2c:	85 c0                	test   %eax,%eax
c0104f2e:	74 24                	je     c0104f54 <check_boot_pgdir+0x192>
c0104f30:	c7 44 24 0c 3c 6e 10 	movl   $0xc0106e3c,0xc(%esp)
c0104f37:	c0 
c0104f38:	c7 44 24 08 c9 6a 10 	movl   $0xc0106ac9,0x8(%esp)
c0104f3f:	c0 
c0104f40:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
c0104f47:	00 
c0104f48:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c0104f4f:	e8 72 bd ff ff       	call   c0100cc6 <__panic>

    struct Page *p;
    p = alloc_page();
c0104f54:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104f5b:	e8 1e ed ff ff       	call   c0103c7e <alloc_pages>
c0104f60:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0104f63:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104f68:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104f6f:	00 
c0104f70:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0104f77:	00 
c0104f78:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104f7b:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104f7f:	89 04 24             	mov    %eax,(%esp)
c0104f82:	e8 6c f6 ff ff       	call   c01045f3 <page_insert>
c0104f87:	85 c0                	test   %eax,%eax
c0104f89:	74 24                	je     c0104faf <check_boot_pgdir+0x1ed>
c0104f8b:	c7 44 24 0c 50 6e 10 	movl   $0xc0106e50,0xc(%esp)
c0104f92:	c0 
c0104f93:	c7 44 24 08 c9 6a 10 	movl   $0xc0106ac9,0x8(%esp)
c0104f9a:	c0 
c0104f9b:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
c0104fa2:	00 
c0104fa3:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c0104faa:	e8 17 bd ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p) == 1);
c0104faf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104fb2:	89 04 24             	mov    %eax,(%esp)
c0104fb5:	e8 bf ea ff ff       	call   c0103a79 <page_ref>
c0104fba:	83 f8 01             	cmp    $0x1,%eax
c0104fbd:	74 24                	je     c0104fe3 <check_boot_pgdir+0x221>
c0104fbf:	c7 44 24 0c 7e 6e 10 	movl   $0xc0106e7e,0xc(%esp)
c0104fc6:	c0 
c0104fc7:	c7 44 24 08 c9 6a 10 	movl   $0xc0106ac9,0x8(%esp)
c0104fce:	c0 
c0104fcf:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
c0104fd6:	00 
c0104fd7:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c0104fde:	e8 e3 bc ff ff       	call   c0100cc6 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0104fe3:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104fe8:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104fef:	00 
c0104ff0:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0104ff7:	00 
c0104ff8:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104ffb:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104fff:	89 04 24             	mov    %eax,(%esp)
c0105002:	e8 ec f5 ff ff       	call   c01045f3 <page_insert>
c0105007:	85 c0                	test   %eax,%eax
c0105009:	74 24                	je     c010502f <check_boot_pgdir+0x26d>
c010500b:	c7 44 24 0c 90 6e 10 	movl   $0xc0106e90,0xc(%esp)
c0105012:	c0 
c0105013:	c7 44 24 08 c9 6a 10 	movl   $0xc0106ac9,0x8(%esp)
c010501a:	c0 
c010501b:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
c0105022:	00 
c0105023:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c010502a:	e8 97 bc ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p) == 2);
c010502f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105032:	89 04 24             	mov    %eax,(%esp)
c0105035:	e8 3f ea ff ff       	call   c0103a79 <page_ref>
c010503a:	83 f8 02             	cmp    $0x2,%eax
c010503d:	74 24                	je     c0105063 <check_boot_pgdir+0x2a1>
c010503f:	c7 44 24 0c c7 6e 10 	movl   $0xc0106ec7,0xc(%esp)
c0105046:	c0 
c0105047:	c7 44 24 08 c9 6a 10 	movl   $0xc0106ac9,0x8(%esp)
c010504e:	c0 
c010504f:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
c0105056:	00 
c0105057:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c010505e:	e8 63 bc ff ff       	call   c0100cc6 <__panic>

    const char *str = "ucore: Hello world!!";
c0105063:	c7 45 dc d8 6e 10 c0 	movl   $0xc0106ed8,-0x24(%ebp)
    strcpy((void *)0x100, str);
c010506a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010506d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105071:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105078:	e8 19 0a 00 00       	call   c0105a96 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c010507d:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0105084:	00 
c0105085:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010508c:	e8 7e 0a 00 00       	call   c0105b0f <strcmp>
c0105091:	85 c0                	test   %eax,%eax
c0105093:	74 24                	je     c01050b9 <check_boot_pgdir+0x2f7>
c0105095:	c7 44 24 0c f0 6e 10 	movl   $0xc0106ef0,0xc(%esp)
c010509c:	c0 
c010509d:	c7 44 24 08 c9 6a 10 	movl   $0xc0106ac9,0x8(%esp)
c01050a4:	c0 
c01050a5:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
c01050ac:	00 
c01050ad:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c01050b4:	e8 0d bc ff ff       	call   c0100cc6 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c01050b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01050bc:	89 04 24             	mov    %eax,(%esp)
c01050bf:	e8 0b e9 ff ff       	call   c01039cf <page2kva>
c01050c4:	05 00 01 00 00       	add    $0x100,%eax
c01050c9:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c01050cc:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01050d3:	e8 66 09 00 00       	call   c0105a3e <strlen>
c01050d8:	85 c0                	test   %eax,%eax
c01050da:	74 24                	je     c0105100 <check_boot_pgdir+0x33e>
c01050dc:	c7 44 24 0c 28 6f 10 	movl   $0xc0106f28,0xc(%esp)
c01050e3:	c0 
c01050e4:	c7 44 24 08 c9 6a 10 	movl   $0xc0106ac9,0x8(%esp)
c01050eb:	c0 
c01050ec:	c7 44 24 04 40 02 00 	movl   $0x240,0x4(%esp)
c01050f3:	00 
c01050f4:	c7 04 24 a4 6a 10 c0 	movl   $0xc0106aa4,(%esp)
c01050fb:	e8 c6 bb ff ff       	call   c0100cc6 <__panic>

    free_page(p);
c0105100:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105107:	00 
c0105108:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010510b:	89 04 24             	mov    %eax,(%esp)
c010510e:	e8 a3 eb ff ff       	call   c0103cb6 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0105113:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105118:	8b 00                	mov    (%eax),%eax
c010511a:	89 04 24             	mov    %eax,(%esp)
c010511d:	e8 3f e9 ff ff       	call   c0103a61 <pde2page>
c0105122:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105129:	00 
c010512a:	89 04 24             	mov    %eax,(%esp)
c010512d:	e8 84 eb ff ff       	call   c0103cb6 <free_pages>
    boot_pgdir[0] = 0;
c0105132:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105137:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c010513d:	c7 04 24 4c 6f 10 c0 	movl   $0xc0106f4c,(%esp)
c0105144:	e8 f3 b1 ff ff       	call   c010033c <cprintf>
}
c0105149:	c9                   	leave  
c010514a:	c3                   	ret    

c010514b <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c010514b:	55                   	push   %ebp
c010514c:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c010514e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105151:	83 e0 04             	and    $0x4,%eax
c0105154:	85 c0                	test   %eax,%eax
c0105156:	74 07                	je     c010515f <perm2str+0x14>
c0105158:	b8 75 00 00 00       	mov    $0x75,%eax
c010515d:	eb 05                	jmp    c0105164 <perm2str+0x19>
c010515f:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105164:	a2 48 89 11 c0       	mov    %al,0xc0118948
    str[1] = 'r';
c0105169:	c6 05 49 89 11 c0 72 	movb   $0x72,0xc0118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0105170:	8b 45 08             	mov    0x8(%ebp),%eax
c0105173:	83 e0 02             	and    $0x2,%eax
c0105176:	85 c0                	test   %eax,%eax
c0105178:	74 07                	je     c0105181 <perm2str+0x36>
c010517a:	b8 77 00 00 00       	mov    $0x77,%eax
c010517f:	eb 05                	jmp    c0105186 <perm2str+0x3b>
c0105181:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105186:	a2 4a 89 11 c0       	mov    %al,0xc011894a
    str[3] = '\0';
c010518b:	c6 05 4b 89 11 c0 00 	movb   $0x0,0xc011894b
    return str;
c0105192:	b8 48 89 11 c0       	mov    $0xc0118948,%eax
}
c0105197:	5d                   	pop    %ebp
c0105198:	c3                   	ret    

c0105199 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0105199:	55                   	push   %ebp
c010519a:	89 e5                	mov    %esp,%ebp
c010519c:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c010519f:	8b 45 10             	mov    0x10(%ebp),%eax
c01051a2:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01051a5:	72 0a                	jb     c01051b1 <get_pgtable_items+0x18>
        return 0;
c01051a7:	b8 00 00 00 00       	mov    $0x0,%eax
c01051ac:	e9 9c 00 00 00       	jmp    c010524d <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c01051b1:	eb 04                	jmp    c01051b7 <get_pgtable_items+0x1e>
        start ++;
c01051b3:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c01051b7:	8b 45 10             	mov    0x10(%ebp),%eax
c01051ba:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01051bd:	73 18                	jae    c01051d7 <get_pgtable_items+0x3e>
c01051bf:	8b 45 10             	mov    0x10(%ebp),%eax
c01051c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01051c9:	8b 45 14             	mov    0x14(%ebp),%eax
c01051cc:	01 d0                	add    %edx,%eax
c01051ce:	8b 00                	mov    (%eax),%eax
c01051d0:	83 e0 01             	and    $0x1,%eax
c01051d3:	85 c0                	test   %eax,%eax
c01051d5:	74 dc                	je     c01051b3 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c01051d7:	8b 45 10             	mov    0x10(%ebp),%eax
c01051da:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01051dd:	73 69                	jae    c0105248 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c01051df:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c01051e3:	74 08                	je     c01051ed <get_pgtable_items+0x54>
            *left_store = start;
c01051e5:	8b 45 18             	mov    0x18(%ebp),%eax
c01051e8:	8b 55 10             	mov    0x10(%ebp),%edx
c01051eb:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c01051ed:	8b 45 10             	mov    0x10(%ebp),%eax
c01051f0:	8d 50 01             	lea    0x1(%eax),%edx
c01051f3:	89 55 10             	mov    %edx,0x10(%ebp)
c01051f6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01051fd:	8b 45 14             	mov    0x14(%ebp),%eax
c0105200:	01 d0                	add    %edx,%eax
c0105202:	8b 00                	mov    (%eax),%eax
c0105204:	83 e0 07             	and    $0x7,%eax
c0105207:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c010520a:	eb 04                	jmp    c0105210 <get_pgtable_items+0x77>
            start ++;
c010520c:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105210:	8b 45 10             	mov    0x10(%ebp),%eax
c0105213:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105216:	73 1d                	jae    c0105235 <get_pgtable_items+0x9c>
c0105218:	8b 45 10             	mov    0x10(%ebp),%eax
c010521b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105222:	8b 45 14             	mov    0x14(%ebp),%eax
c0105225:	01 d0                	add    %edx,%eax
c0105227:	8b 00                	mov    (%eax),%eax
c0105229:	83 e0 07             	and    $0x7,%eax
c010522c:	89 c2                	mov    %eax,%edx
c010522e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105231:	39 c2                	cmp    %eax,%edx
c0105233:	74 d7                	je     c010520c <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c0105235:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105239:	74 08                	je     c0105243 <get_pgtable_items+0xaa>
            *right_store = start;
c010523b:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010523e:	8b 55 10             	mov    0x10(%ebp),%edx
c0105241:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0105243:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105246:	eb 05                	jmp    c010524d <get_pgtable_items+0xb4>
    }
    return 0;
c0105248:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010524d:	c9                   	leave  
c010524e:	c3                   	ret    

c010524f <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c010524f:	55                   	push   %ebp
c0105250:	89 e5                	mov    %esp,%ebp
c0105252:	57                   	push   %edi
c0105253:	56                   	push   %esi
c0105254:	53                   	push   %ebx
c0105255:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0105258:	c7 04 24 6c 6f 10 c0 	movl   $0xc0106f6c,(%esp)
c010525f:	e8 d8 b0 ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
c0105264:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010526b:	e9 fa 00 00 00       	jmp    c010536a <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105270:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105273:	89 04 24             	mov    %eax,(%esp)
c0105276:	e8 d0 fe ff ff       	call   c010514b <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c010527b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010527e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105281:	29 d1                	sub    %edx,%ecx
c0105283:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105285:	89 d6                	mov    %edx,%esi
c0105287:	c1 e6 16             	shl    $0x16,%esi
c010528a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010528d:	89 d3                	mov    %edx,%ebx
c010528f:	c1 e3 16             	shl    $0x16,%ebx
c0105292:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105295:	89 d1                	mov    %edx,%ecx
c0105297:	c1 e1 16             	shl    $0x16,%ecx
c010529a:	8b 7d dc             	mov    -0x24(%ebp),%edi
c010529d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01052a0:	29 d7                	sub    %edx,%edi
c01052a2:	89 fa                	mov    %edi,%edx
c01052a4:	89 44 24 14          	mov    %eax,0x14(%esp)
c01052a8:	89 74 24 10          	mov    %esi,0x10(%esp)
c01052ac:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01052b0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01052b4:	89 54 24 04          	mov    %edx,0x4(%esp)
c01052b8:	c7 04 24 9d 6f 10 c0 	movl   $0xc0106f9d,(%esp)
c01052bf:	e8 78 b0 ff ff       	call   c010033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c01052c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01052c7:	c1 e0 0a             	shl    $0xa,%eax
c01052ca:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01052cd:	eb 54                	jmp    c0105323 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01052cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01052d2:	89 04 24             	mov    %eax,(%esp)
c01052d5:	e8 71 fe ff ff       	call   c010514b <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c01052da:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01052dd:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01052e0:	29 d1                	sub    %edx,%ecx
c01052e2:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01052e4:	89 d6                	mov    %edx,%esi
c01052e6:	c1 e6 0c             	shl    $0xc,%esi
c01052e9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01052ec:	89 d3                	mov    %edx,%ebx
c01052ee:	c1 e3 0c             	shl    $0xc,%ebx
c01052f1:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01052f4:	c1 e2 0c             	shl    $0xc,%edx
c01052f7:	89 d1                	mov    %edx,%ecx
c01052f9:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c01052fc:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01052ff:	29 d7                	sub    %edx,%edi
c0105301:	89 fa                	mov    %edi,%edx
c0105303:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105307:	89 74 24 10          	mov    %esi,0x10(%esp)
c010530b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010530f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105313:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105317:	c7 04 24 bc 6f 10 c0 	movl   $0xc0106fbc,(%esp)
c010531e:	e8 19 b0 ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105323:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c0105328:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010532b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010532e:	89 ce                	mov    %ecx,%esi
c0105330:	c1 e6 0a             	shl    $0xa,%esi
c0105333:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0105336:	89 cb                	mov    %ecx,%ebx
c0105338:	c1 e3 0a             	shl    $0xa,%ebx
c010533b:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c010533e:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105342:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c0105345:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105349:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010534d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105351:	89 74 24 04          	mov    %esi,0x4(%esp)
c0105355:	89 1c 24             	mov    %ebx,(%esp)
c0105358:	e8 3c fe ff ff       	call   c0105199 <get_pgtable_items>
c010535d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105360:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105364:	0f 85 65 ff ff ff    	jne    c01052cf <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010536a:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c010536f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105372:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c0105375:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105379:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c010537c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105380:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105384:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105388:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c010538f:	00 
c0105390:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0105397:	e8 fd fd ff ff       	call   c0105199 <get_pgtable_items>
c010539c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010539f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01053a3:	0f 85 c7 fe ff ff    	jne    c0105270 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01053a9:	c7 04 24 e0 6f 10 c0 	movl   $0xc0106fe0,(%esp)
c01053b0:	e8 87 af ff ff       	call   c010033c <cprintf>
}
c01053b5:	83 c4 4c             	add    $0x4c,%esp
c01053b8:	5b                   	pop    %ebx
c01053b9:	5e                   	pop    %esi
c01053ba:	5f                   	pop    %edi
c01053bb:	5d                   	pop    %ebp
c01053bc:	c3                   	ret    

c01053bd <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01053bd:	55                   	push   %ebp
c01053be:	89 e5                	mov    %esp,%ebp
c01053c0:	83 ec 58             	sub    $0x58,%esp
c01053c3:	8b 45 10             	mov    0x10(%ebp),%eax
c01053c6:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01053c9:	8b 45 14             	mov    0x14(%ebp),%eax
c01053cc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c01053cf:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01053d2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01053d5:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01053d8:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01053db:	8b 45 18             	mov    0x18(%ebp),%eax
c01053de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01053e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01053e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01053e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01053ea:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01053ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01053f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01053f7:	74 1c                	je     c0105415 <printnum+0x58>
c01053f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053fc:	ba 00 00 00 00       	mov    $0x0,%edx
c0105401:	f7 75 e4             	divl   -0x1c(%ebp)
c0105404:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105407:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010540a:	ba 00 00 00 00       	mov    $0x0,%edx
c010540f:	f7 75 e4             	divl   -0x1c(%ebp)
c0105412:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105415:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105418:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010541b:	f7 75 e4             	divl   -0x1c(%ebp)
c010541e:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105421:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105424:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105427:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010542a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010542d:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0105430:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105433:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0105436:	8b 45 18             	mov    0x18(%ebp),%eax
c0105439:	ba 00 00 00 00       	mov    $0x0,%edx
c010543e:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105441:	77 56                	ja     c0105499 <printnum+0xdc>
c0105443:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105446:	72 05                	jb     c010544d <printnum+0x90>
c0105448:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c010544b:	77 4c                	ja     c0105499 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c010544d:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105450:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105453:	8b 45 20             	mov    0x20(%ebp),%eax
c0105456:	89 44 24 18          	mov    %eax,0x18(%esp)
c010545a:	89 54 24 14          	mov    %edx,0x14(%esp)
c010545e:	8b 45 18             	mov    0x18(%ebp),%eax
c0105461:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105465:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105468:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010546b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010546f:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105473:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105476:	89 44 24 04          	mov    %eax,0x4(%esp)
c010547a:	8b 45 08             	mov    0x8(%ebp),%eax
c010547d:	89 04 24             	mov    %eax,(%esp)
c0105480:	e8 38 ff ff ff       	call   c01053bd <printnum>
c0105485:	eb 1c                	jmp    c01054a3 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0105487:	8b 45 0c             	mov    0xc(%ebp),%eax
c010548a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010548e:	8b 45 20             	mov    0x20(%ebp),%eax
c0105491:	89 04 24             	mov    %eax,(%esp)
c0105494:	8b 45 08             	mov    0x8(%ebp),%eax
c0105497:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c0105499:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c010549d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01054a1:	7f e4                	jg     c0105487 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01054a3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01054a6:	05 94 70 10 c0       	add    $0xc0107094,%eax
c01054ab:	0f b6 00             	movzbl (%eax),%eax
c01054ae:	0f be c0             	movsbl %al,%eax
c01054b1:	8b 55 0c             	mov    0xc(%ebp),%edx
c01054b4:	89 54 24 04          	mov    %edx,0x4(%esp)
c01054b8:	89 04 24             	mov    %eax,(%esp)
c01054bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01054be:	ff d0                	call   *%eax
}
c01054c0:	c9                   	leave  
c01054c1:	c3                   	ret    

c01054c2 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01054c2:	55                   	push   %ebp
c01054c3:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01054c5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01054c9:	7e 14                	jle    c01054df <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01054cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01054ce:	8b 00                	mov    (%eax),%eax
c01054d0:	8d 48 08             	lea    0x8(%eax),%ecx
c01054d3:	8b 55 08             	mov    0x8(%ebp),%edx
c01054d6:	89 0a                	mov    %ecx,(%edx)
c01054d8:	8b 50 04             	mov    0x4(%eax),%edx
c01054db:	8b 00                	mov    (%eax),%eax
c01054dd:	eb 30                	jmp    c010550f <getuint+0x4d>
    }
    else if (lflag) {
c01054df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01054e3:	74 16                	je     c01054fb <getuint+0x39>
        return va_arg(*ap, unsigned long);
c01054e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01054e8:	8b 00                	mov    (%eax),%eax
c01054ea:	8d 48 04             	lea    0x4(%eax),%ecx
c01054ed:	8b 55 08             	mov    0x8(%ebp),%edx
c01054f0:	89 0a                	mov    %ecx,(%edx)
c01054f2:	8b 00                	mov    (%eax),%eax
c01054f4:	ba 00 00 00 00       	mov    $0x0,%edx
c01054f9:	eb 14                	jmp    c010550f <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c01054fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01054fe:	8b 00                	mov    (%eax),%eax
c0105500:	8d 48 04             	lea    0x4(%eax),%ecx
c0105503:	8b 55 08             	mov    0x8(%ebp),%edx
c0105506:	89 0a                	mov    %ecx,(%edx)
c0105508:	8b 00                	mov    (%eax),%eax
c010550a:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c010550f:	5d                   	pop    %ebp
c0105510:	c3                   	ret    

c0105511 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0105511:	55                   	push   %ebp
c0105512:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105514:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105518:	7e 14                	jle    c010552e <getint+0x1d>
        return va_arg(*ap, long long);
c010551a:	8b 45 08             	mov    0x8(%ebp),%eax
c010551d:	8b 00                	mov    (%eax),%eax
c010551f:	8d 48 08             	lea    0x8(%eax),%ecx
c0105522:	8b 55 08             	mov    0x8(%ebp),%edx
c0105525:	89 0a                	mov    %ecx,(%edx)
c0105527:	8b 50 04             	mov    0x4(%eax),%edx
c010552a:	8b 00                	mov    (%eax),%eax
c010552c:	eb 28                	jmp    c0105556 <getint+0x45>
    }
    else if (lflag) {
c010552e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105532:	74 12                	je     c0105546 <getint+0x35>
        return va_arg(*ap, long);
c0105534:	8b 45 08             	mov    0x8(%ebp),%eax
c0105537:	8b 00                	mov    (%eax),%eax
c0105539:	8d 48 04             	lea    0x4(%eax),%ecx
c010553c:	8b 55 08             	mov    0x8(%ebp),%edx
c010553f:	89 0a                	mov    %ecx,(%edx)
c0105541:	8b 00                	mov    (%eax),%eax
c0105543:	99                   	cltd   
c0105544:	eb 10                	jmp    c0105556 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0105546:	8b 45 08             	mov    0x8(%ebp),%eax
c0105549:	8b 00                	mov    (%eax),%eax
c010554b:	8d 48 04             	lea    0x4(%eax),%ecx
c010554e:	8b 55 08             	mov    0x8(%ebp),%edx
c0105551:	89 0a                	mov    %ecx,(%edx)
c0105553:	8b 00                	mov    (%eax),%eax
c0105555:	99                   	cltd   
    }
}
c0105556:	5d                   	pop    %ebp
c0105557:	c3                   	ret    

c0105558 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0105558:	55                   	push   %ebp
c0105559:	89 e5                	mov    %esp,%ebp
c010555b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c010555e:	8d 45 14             	lea    0x14(%ebp),%eax
c0105561:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0105564:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105567:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010556b:	8b 45 10             	mov    0x10(%ebp),%eax
c010556e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105572:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105575:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105579:	8b 45 08             	mov    0x8(%ebp),%eax
c010557c:	89 04 24             	mov    %eax,(%esp)
c010557f:	e8 02 00 00 00       	call   c0105586 <vprintfmt>
    va_end(ap);
}
c0105584:	c9                   	leave  
c0105585:	c3                   	ret    

c0105586 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0105586:	55                   	push   %ebp
c0105587:	89 e5                	mov    %esp,%ebp
c0105589:	56                   	push   %esi
c010558a:	53                   	push   %ebx
c010558b:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010558e:	eb 18                	jmp    c01055a8 <vprintfmt+0x22>
            if (ch == '\0') {
c0105590:	85 db                	test   %ebx,%ebx
c0105592:	75 05                	jne    c0105599 <vprintfmt+0x13>
                return;
c0105594:	e9 d1 03 00 00       	jmp    c010596a <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c0105599:	8b 45 0c             	mov    0xc(%ebp),%eax
c010559c:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055a0:	89 1c 24             	mov    %ebx,(%esp)
c01055a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01055a6:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01055a8:	8b 45 10             	mov    0x10(%ebp),%eax
c01055ab:	8d 50 01             	lea    0x1(%eax),%edx
c01055ae:	89 55 10             	mov    %edx,0x10(%ebp)
c01055b1:	0f b6 00             	movzbl (%eax),%eax
c01055b4:	0f b6 d8             	movzbl %al,%ebx
c01055b7:	83 fb 25             	cmp    $0x25,%ebx
c01055ba:	75 d4                	jne    c0105590 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c01055bc:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c01055c0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c01055c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01055ca:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01055cd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01055d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01055d7:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01055da:	8b 45 10             	mov    0x10(%ebp),%eax
c01055dd:	8d 50 01             	lea    0x1(%eax),%edx
c01055e0:	89 55 10             	mov    %edx,0x10(%ebp)
c01055e3:	0f b6 00             	movzbl (%eax),%eax
c01055e6:	0f b6 d8             	movzbl %al,%ebx
c01055e9:	8d 43 dd             	lea    -0x23(%ebx),%eax
c01055ec:	83 f8 55             	cmp    $0x55,%eax
c01055ef:	0f 87 44 03 00 00    	ja     c0105939 <vprintfmt+0x3b3>
c01055f5:	8b 04 85 b8 70 10 c0 	mov    -0x3fef8f48(,%eax,4),%eax
c01055fc:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c01055fe:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105602:	eb d6                	jmp    c01055da <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105604:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105608:	eb d0                	jmp    c01055da <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010560a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105611:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105614:	89 d0                	mov    %edx,%eax
c0105616:	c1 e0 02             	shl    $0x2,%eax
c0105619:	01 d0                	add    %edx,%eax
c010561b:	01 c0                	add    %eax,%eax
c010561d:	01 d8                	add    %ebx,%eax
c010561f:	83 e8 30             	sub    $0x30,%eax
c0105622:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105625:	8b 45 10             	mov    0x10(%ebp),%eax
c0105628:	0f b6 00             	movzbl (%eax),%eax
c010562b:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c010562e:	83 fb 2f             	cmp    $0x2f,%ebx
c0105631:	7e 0b                	jle    c010563e <vprintfmt+0xb8>
c0105633:	83 fb 39             	cmp    $0x39,%ebx
c0105636:	7f 06                	jg     c010563e <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105638:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c010563c:	eb d3                	jmp    c0105611 <vprintfmt+0x8b>
            goto process_precision;
c010563e:	eb 33                	jmp    c0105673 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c0105640:	8b 45 14             	mov    0x14(%ebp),%eax
c0105643:	8d 50 04             	lea    0x4(%eax),%edx
c0105646:	89 55 14             	mov    %edx,0x14(%ebp)
c0105649:	8b 00                	mov    (%eax),%eax
c010564b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c010564e:	eb 23                	jmp    c0105673 <vprintfmt+0xed>

        case '.':
            if (width < 0)
c0105650:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105654:	79 0c                	jns    c0105662 <vprintfmt+0xdc>
                width = 0;
c0105656:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c010565d:	e9 78 ff ff ff       	jmp    c01055da <vprintfmt+0x54>
c0105662:	e9 73 ff ff ff       	jmp    c01055da <vprintfmt+0x54>

        case '#':
            altflag = 1;
c0105667:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c010566e:	e9 67 ff ff ff       	jmp    c01055da <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c0105673:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105677:	79 12                	jns    c010568b <vprintfmt+0x105>
                width = precision, precision = -1;
c0105679:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010567c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010567f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0105686:	e9 4f ff ff ff       	jmp    c01055da <vprintfmt+0x54>
c010568b:	e9 4a ff ff ff       	jmp    c01055da <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105690:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c0105694:	e9 41 ff ff ff       	jmp    c01055da <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0105699:	8b 45 14             	mov    0x14(%ebp),%eax
c010569c:	8d 50 04             	lea    0x4(%eax),%edx
c010569f:	89 55 14             	mov    %edx,0x14(%ebp)
c01056a2:	8b 00                	mov    (%eax),%eax
c01056a4:	8b 55 0c             	mov    0xc(%ebp),%edx
c01056a7:	89 54 24 04          	mov    %edx,0x4(%esp)
c01056ab:	89 04 24             	mov    %eax,(%esp)
c01056ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01056b1:	ff d0                	call   *%eax
            break;
c01056b3:	e9 ac 02 00 00       	jmp    c0105964 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01056b8:	8b 45 14             	mov    0x14(%ebp),%eax
c01056bb:	8d 50 04             	lea    0x4(%eax),%edx
c01056be:	89 55 14             	mov    %edx,0x14(%ebp)
c01056c1:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c01056c3:	85 db                	test   %ebx,%ebx
c01056c5:	79 02                	jns    c01056c9 <vprintfmt+0x143>
                err = -err;
c01056c7:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c01056c9:	83 fb 06             	cmp    $0x6,%ebx
c01056cc:	7f 0b                	jg     c01056d9 <vprintfmt+0x153>
c01056ce:	8b 34 9d 78 70 10 c0 	mov    -0x3fef8f88(,%ebx,4),%esi
c01056d5:	85 f6                	test   %esi,%esi
c01056d7:	75 23                	jne    c01056fc <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c01056d9:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01056dd:	c7 44 24 08 a5 70 10 	movl   $0xc01070a5,0x8(%esp)
c01056e4:	c0 
c01056e5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056e8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01056ef:	89 04 24             	mov    %eax,(%esp)
c01056f2:	e8 61 fe ff ff       	call   c0105558 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c01056f7:	e9 68 02 00 00       	jmp    c0105964 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c01056fc:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105700:	c7 44 24 08 ae 70 10 	movl   $0xc01070ae,0x8(%esp)
c0105707:	c0 
c0105708:	8b 45 0c             	mov    0xc(%ebp),%eax
c010570b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010570f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105712:	89 04 24             	mov    %eax,(%esp)
c0105715:	e8 3e fe ff ff       	call   c0105558 <printfmt>
            }
            break;
c010571a:	e9 45 02 00 00       	jmp    c0105964 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c010571f:	8b 45 14             	mov    0x14(%ebp),%eax
c0105722:	8d 50 04             	lea    0x4(%eax),%edx
c0105725:	89 55 14             	mov    %edx,0x14(%ebp)
c0105728:	8b 30                	mov    (%eax),%esi
c010572a:	85 f6                	test   %esi,%esi
c010572c:	75 05                	jne    c0105733 <vprintfmt+0x1ad>
                p = "(null)";
c010572e:	be b1 70 10 c0       	mov    $0xc01070b1,%esi
            }
            if (width > 0 && padc != '-') {
c0105733:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105737:	7e 3e                	jle    c0105777 <vprintfmt+0x1f1>
c0105739:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c010573d:	74 38                	je     c0105777 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c010573f:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c0105742:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105745:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105749:	89 34 24             	mov    %esi,(%esp)
c010574c:	e8 15 03 00 00       	call   c0105a66 <strnlen>
c0105751:	29 c3                	sub    %eax,%ebx
c0105753:	89 d8                	mov    %ebx,%eax
c0105755:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105758:	eb 17                	jmp    c0105771 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c010575a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c010575e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105761:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105765:	89 04 24             	mov    %eax,(%esp)
c0105768:	8b 45 08             	mov    0x8(%ebp),%eax
c010576b:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c010576d:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105771:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105775:	7f e3                	jg     c010575a <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105777:	eb 38                	jmp    c01057b1 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c0105779:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010577d:	74 1f                	je     c010579e <vprintfmt+0x218>
c010577f:	83 fb 1f             	cmp    $0x1f,%ebx
c0105782:	7e 05                	jle    c0105789 <vprintfmt+0x203>
c0105784:	83 fb 7e             	cmp    $0x7e,%ebx
c0105787:	7e 15                	jle    c010579e <vprintfmt+0x218>
                    putch('?', putdat);
c0105789:	8b 45 0c             	mov    0xc(%ebp),%eax
c010578c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105790:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0105797:	8b 45 08             	mov    0x8(%ebp),%eax
c010579a:	ff d0                	call   *%eax
c010579c:	eb 0f                	jmp    c01057ad <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c010579e:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057a1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057a5:	89 1c 24             	mov    %ebx,(%esp)
c01057a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01057ab:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01057ad:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01057b1:	89 f0                	mov    %esi,%eax
c01057b3:	8d 70 01             	lea    0x1(%eax),%esi
c01057b6:	0f b6 00             	movzbl (%eax),%eax
c01057b9:	0f be d8             	movsbl %al,%ebx
c01057bc:	85 db                	test   %ebx,%ebx
c01057be:	74 10                	je     c01057d0 <vprintfmt+0x24a>
c01057c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01057c4:	78 b3                	js     c0105779 <vprintfmt+0x1f3>
c01057c6:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c01057ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01057ce:	79 a9                	jns    c0105779 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01057d0:	eb 17                	jmp    c01057e9 <vprintfmt+0x263>
                putch(' ', putdat);
c01057d2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057d5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057d9:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01057e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01057e3:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01057e5:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01057e9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01057ed:	7f e3                	jg     c01057d2 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c01057ef:	e9 70 01 00 00       	jmp    c0105964 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c01057f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01057f7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057fb:	8d 45 14             	lea    0x14(%ebp),%eax
c01057fe:	89 04 24             	mov    %eax,(%esp)
c0105801:	e8 0b fd ff ff       	call   c0105511 <getint>
c0105806:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105809:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c010580c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010580f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105812:	85 d2                	test   %edx,%edx
c0105814:	79 26                	jns    c010583c <vprintfmt+0x2b6>
                putch('-', putdat);
c0105816:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105819:	89 44 24 04          	mov    %eax,0x4(%esp)
c010581d:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105824:	8b 45 08             	mov    0x8(%ebp),%eax
c0105827:	ff d0                	call   *%eax
                num = -(long long)num;
c0105829:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010582c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010582f:	f7 d8                	neg    %eax
c0105831:	83 d2 00             	adc    $0x0,%edx
c0105834:	f7 da                	neg    %edx
c0105836:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105839:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c010583c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105843:	e9 a8 00 00 00       	jmp    c01058f0 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105848:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010584b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010584f:	8d 45 14             	lea    0x14(%ebp),%eax
c0105852:	89 04 24             	mov    %eax,(%esp)
c0105855:	e8 68 fc ff ff       	call   c01054c2 <getuint>
c010585a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010585d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105860:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105867:	e9 84 00 00 00       	jmp    c01058f0 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c010586c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010586f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105873:	8d 45 14             	lea    0x14(%ebp),%eax
c0105876:	89 04 24             	mov    %eax,(%esp)
c0105879:	e8 44 fc ff ff       	call   c01054c2 <getuint>
c010587e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105881:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105884:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c010588b:	eb 63                	jmp    c01058f0 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c010588d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105890:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105894:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c010589b:	8b 45 08             	mov    0x8(%ebp),%eax
c010589e:	ff d0                	call   *%eax
            putch('x', putdat);
c01058a0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058a3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058a7:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c01058ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01058b1:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c01058b3:	8b 45 14             	mov    0x14(%ebp),%eax
c01058b6:	8d 50 04             	lea    0x4(%eax),%edx
c01058b9:	89 55 14             	mov    %edx,0x14(%ebp)
c01058bc:	8b 00                	mov    (%eax),%eax
c01058be:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c01058c8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c01058cf:	eb 1f                	jmp    c01058f0 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c01058d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01058d4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058d8:	8d 45 14             	lea    0x14(%ebp),%eax
c01058db:	89 04 24             	mov    %eax,(%esp)
c01058de:	e8 df fb ff ff       	call   c01054c2 <getuint>
c01058e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058e6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c01058e9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c01058f0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c01058f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01058f7:	89 54 24 18          	mov    %edx,0x18(%esp)
c01058fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01058fe:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105902:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105906:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105909:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010590c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105910:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105914:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105917:	89 44 24 04          	mov    %eax,0x4(%esp)
c010591b:	8b 45 08             	mov    0x8(%ebp),%eax
c010591e:	89 04 24             	mov    %eax,(%esp)
c0105921:	e8 97 fa ff ff       	call   c01053bd <printnum>
            break;
c0105926:	eb 3c                	jmp    c0105964 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105928:	8b 45 0c             	mov    0xc(%ebp),%eax
c010592b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010592f:	89 1c 24             	mov    %ebx,(%esp)
c0105932:	8b 45 08             	mov    0x8(%ebp),%eax
c0105935:	ff d0                	call   *%eax
            break;
c0105937:	eb 2b                	jmp    c0105964 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105939:	8b 45 0c             	mov    0xc(%ebp),%eax
c010593c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105940:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0105947:	8b 45 08             	mov    0x8(%ebp),%eax
c010594a:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c010594c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105950:	eb 04                	jmp    c0105956 <vprintfmt+0x3d0>
c0105952:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105956:	8b 45 10             	mov    0x10(%ebp),%eax
c0105959:	83 e8 01             	sub    $0x1,%eax
c010595c:	0f b6 00             	movzbl (%eax),%eax
c010595f:	3c 25                	cmp    $0x25,%al
c0105961:	75 ef                	jne    c0105952 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c0105963:	90                   	nop
        }
    }
c0105964:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105965:	e9 3e fc ff ff       	jmp    c01055a8 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c010596a:	83 c4 40             	add    $0x40,%esp
c010596d:	5b                   	pop    %ebx
c010596e:	5e                   	pop    %esi
c010596f:	5d                   	pop    %ebp
c0105970:	c3                   	ret    

c0105971 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105971:	55                   	push   %ebp
c0105972:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105974:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105977:	8b 40 08             	mov    0x8(%eax),%eax
c010597a:	8d 50 01             	lea    0x1(%eax),%edx
c010597d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105980:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105983:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105986:	8b 10                	mov    (%eax),%edx
c0105988:	8b 45 0c             	mov    0xc(%ebp),%eax
c010598b:	8b 40 04             	mov    0x4(%eax),%eax
c010598e:	39 c2                	cmp    %eax,%edx
c0105990:	73 12                	jae    c01059a4 <sprintputch+0x33>
        *b->buf ++ = ch;
c0105992:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105995:	8b 00                	mov    (%eax),%eax
c0105997:	8d 48 01             	lea    0x1(%eax),%ecx
c010599a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010599d:	89 0a                	mov    %ecx,(%edx)
c010599f:	8b 55 08             	mov    0x8(%ebp),%edx
c01059a2:	88 10                	mov    %dl,(%eax)
    }
}
c01059a4:	5d                   	pop    %ebp
c01059a5:	c3                   	ret    

c01059a6 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c01059a6:	55                   	push   %ebp
c01059a7:	89 e5                	mov    %esp,%ebp
c01059a9:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01059ac:	8d 45 14             	lea    0x14(%ebp),%eax
c01059af:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c01059b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01059b5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01059b9:	8b 45 10             	mov    0x10(%ebp),%eax
c01059bc:	89 44 24 08          	mov    %eax,0x8(%esp)
c01059c0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059c3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01059ca:	89 04 24             	mov    %eax,(%esp)
c01059cd:	e8 08 00 00 00       	call   c01059da <vsnprintf>
c01059d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01059d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01059d8:	c9                   	leave  
c01059d9:	c3                   	ret    

c01059da <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c01059da:	55                   	push   %ebp
c01059db:	89 e5                	mov    %esp,%ebp
c01059dd:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c01059e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01059e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01059e6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059e9:	8d 50 ff             	lea    -0x1(%eax),%edx
c01059ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01059ef:	01 d0                	add    %edx,%eax
c01059f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01059f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c01059fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01059ff:	74 0a                	je     c0105a0b <vsnprintf+0x31>
c0105a01:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105a04:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a07:	39 c2                	cmp    %eax,%edx
c0105a09:	76 07                	jbe    c0105a12 <vsnprintf+0x38>
        return -E_INVAL;
c0105a0b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105a10:	eb 2a                	jmp    c0105a3c <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105a12:	8b 45 14             	mov    0x14(%ebp),%eax
c0105a15:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105a19:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a1c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a20:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105a23:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a27:	c7 04 24 71 59 10 c0 	movl   $0xc0105971,(%esp)
c0105a2e:	e8 53 fb ff ff       	call   c0105586 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105a33:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105a36:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105a3c:	c9                   	leave  
c0105a3d:	c3                   	ret    

c0105a3e <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105a3e:	55                   	push   %ebp
c0105a3f:	89 e5                	mov    %esp,%ebp
c0105a41:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105a44:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105a4b:	eb 04                	jmp    c0105a51 <strlen+0x13>
        cnt ++;
c0105a4d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0105a51:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a54:	8d 50 01             	lea    0x1(%eax),%edx
c0105a57:	89 55 08             	mov    %edx,0x8(%ebp)
c0105a5a:	0f b6 00             	movzbl (%eax),%eax
c0105a5d:	84 c0                	test   %al,%al
c0105a5f:	75 ec                	jne    c0105a4d <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0105a61:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105a64:	c9                   	leave  
c0105a65:	c3                   	ret    

c0105a66 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105a66:	55                   	push   %ebp
c0105a67:	89 e5                	mov    %esp,%ebp
c0105a69:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105a6c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105a73:	eb 04                	jmp    c0105a79 <strnlen+0x13>
        cnt ++;
c0105a75:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0105a79:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105a7c:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105a7f:	73 10                	jae    c0105a91 <strnlen+0x2b>
c0105a81:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a84:	8d 50 01             	lea    0x1(%eax),%edx
c0105a87:	89 55 08             	mov    %edx,0x8(%ebp)
c0105a8a:	0f b6 00             	movzbl (%eax),%eax
c0105a8d:	84 c0                	test   %al,%al
c0105a8f:	75 e4                	jne    c0105a75 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0105a91:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105a94:	c9                   	leave  
c0105a95:	c3                   	ret    

c0105a96 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105a96:	55                   	push   %ebp
c0105a97:	89 e5                	mov    %esp,%ebp
c0105a99:	57                   	push   %edi
c0105a9a:	56                   	push   %esi
c0105a9b:	83 ec 20             	sub    $0x20,%esp
c0105a9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105aa4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105aa7:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105aaa:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ab0:	89 d1                	mov    %edx,%ecx
c0105ab2:	89 c2                	mov    %eax,%edx
c0105ab4:	89 ce                	mov    %ecx,%esi
c0105ab6:	89 d7                	mov    %edx,%edi
c0105ab8:	ac                   	lods   %ds:(%esi),%al
c0105ab9:	aa                   	stos   %al,%es:(%edi)
c0105aba:	84 c0                	test   %al,%al
c0105abc:	75 fa                	jne    c0105ab8 <strcpy+0x22>
c0105abe:	89 fa                	mov    %edi,%edx
c0105ac0:	89 f1                	mov    %esi,%ecx
c0105ac2:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105ac5:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105ac8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105ace:	83 c4 20             	add    $0x20,%esp
c0105ad1:	5e                   	pop    %esi
c0105ad2:	5f                   	pop    %edi
c0105ad3:	5d                   	pop    %ebp
c0105ad4:	c3                   	ret    

c0105ad5 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105ad5:	55                   	push   %ebp
c0105ad6:	89 e5                	mov    %esp,%ebp
c0105ad8:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105adb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ade:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105ae1:	eb 21                	jmp    c0105b04 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105ae3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ae6:	0f b6 10             	movzbl (%eax),%edx
c0105ae9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105aec:	88 10                	mov    %dl,(%eax)
c0105aee:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105af1:	0f b6 00             	movzbl (%eax),%eax
c0105af4:	84 c0                	test   %al,%al
c0105af6:	74 04                	je     c0105afc <strncpy+0x27>
            src ++;
c0105af8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105afc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105b00:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0105b04:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b08:	75 d9                	jne    c0105ae3 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105b0a:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105b0d:	c9                   	leave  
c0105b0e:	c3                   	ret    

c0105b0f <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105b0f:	55                   	push   %ebp
c0105b10:	89 e5                	mov    %esp,%ebp
c0105b12:	57                   	push   %edi
c0105b13:	56                   	push   %esi
c0105b14:	83 ec 20             	sub    $0x20,%esp
c0105b17:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105b1d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b20:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0105b23:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b29:	89 d1                	mov    %edx,%ecx
c0105b2b:	89 c2                	mov    %eax,%edx
c0105b2d:	89 ce                	mov    %ecx,%esi
c0105b2f:	89 d7                	mov    %edx,%edi
c0105b31:	ac                   	lods   %ds:(%esi),%al
c0105b32:	ae                   	scas   %es:(%edi),%al
c0105b33:	75 08                	jne    c0105b3d <strcmp+0x2e>
c0105b35:	84 c0                	test   %al,%al
c0105b37:	75 f8                	jne    c0105b31 <strcmp+0x22>
c0105b39:	31 c0                	xor    %eax,%eax
c0105b3b:	eb 04                	jmp    c0105b41 <strcmp+0x32>
c0105b3d:	19 c0                	sbb    %eax,%eax
c0105b3f:	0c 01                	or     $0x1,%al
c0105b41:	89 fa                	mov    %edi,%edx
c0105b43:	89 f1                	mov    %esi,%ecx
c0105b45:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105b48:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105b4b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105b4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105b51:	83 c4 20             	add    $0x20,%esp
c0105b54:	5e                   	pop    %esi
c0105b55:	5f                   	pop    %edi
c0105b56:	5d                   	pop    %ebp
c0105b57:	c3                   	ret    

c0105b58 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105b58:	55                   	push   %ebp
c0105b59:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105b5b:	eb 0c                	jmp    c0105b69 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105b5d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105b61:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105b65:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105b69:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b6d:	74 1a                	je     c0105b89 <strncmp+0x31>
c0105b6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b72:	0f b6 00             	movzbl (%eax),%eax
c0105b75:	84 c0                	test   %al,%al
c0105b77:	74 10                	je     c0105b89 <strncmp+0x31>
c0105b79:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b7c:	0f b6 10             	movzbl (%eax),%edx
c0105b7f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b82:	0f b6 00             	movzbl (%eax),%eax
c0105b85:	38 c2                	cmp    %al,%dl
c0105b87:	74 d4                	je     c0105b5d <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105b89:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b8d:	74 18                	je     c0105ba7 <strncmp+0x4f>
c0105b8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b92:	0f b6 00             	movzbl (%eax),%eax
c0105b95:	0f b6 d0             	movzbl %al,%edx
c0105b98:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b9b:	0f b6 00             	movzbl (%eax),%eax
c0105b9e:	0f b6 c0             	movzbl %al,%eax
c0105ba1:	29 c2                	sub    %eax,%edx
c0105ba3:	89 d0                	mov    %edx,%eax
c0105ba5:	eb 05                	jmp    c0105bac <strncmp+0x54>
c0105ba7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105bac:	5d                   	pop    %ebp
c0105bad:	c3                   	ret    

c0105bae <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105bae:	55                   	push   %ebp
c0105baf:	89 e5                	mov    %esp,%ebp
c0105bb1:	83 ec 04             	sub    $0x4,%esp
c0105bb4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bb7:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105bba:	eb 14                	jmp    c0105bd0 <strchr+0x22>
        if (*s == c) {
c0105bbc:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bbf:	0f b6 00             	movzbl (%eax),%eax
c0105bc2:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105bc5:	75 05                	jne    c0105bcc <strchr+0x1e>
            return (char *)s;
c0105bc7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bca:	eb 13                	jmp    c0105bdf <strchr+0x31>
        }
        s ++;
c0105bcc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105bd0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bd3:	0f b6 00             	movzbl (%eax),%eax
c0105bd6:	84 c0                	test   %al,%al
c0105bd8:	75 e2                	jne    c0105bbc <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105bda:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105bdf:	c9                   	leave  
c0105be0:	c3                   	ret    

c0105be1 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105be1:	55                   	push   %ebp
c0105be2:	89 e5                	mov    %esp,%ebp
c0105be4:	83 ec 04             	sub    $0x4,%esp
c0105be7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bea:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105bed:	eb 11                	jmp    c0105c00 <strfind+0x1f>
        if (*s == c) {
c0105bef:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bf2:	0f b6 00             	movzbl (%eax),%eax
c0105bf5:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105bf8:	75 02                	jne    c0105bfc <strfind+0x1b>
            break;
c0105bfa:	eb 0e                	jmp    c0105c0a <strfind+0x29>
        }
        s ++;
c0105bfc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105c00:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c03:	0f b6 00             	movzbl (%eax),%eax
c0105c06:	84 c0                	test   %al,%al
c0105c08:	75 e5                	jne    c0105bef <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0105c0a:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105c0d:	c9                   	leave  
c0105c0e:	c3                   	ret    

c0105c0f <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105c0f:	55                   	push   %ebp
c0105c10:	89 e5                	mov    %esp,%ebp
c0105c12:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105c15:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105c1c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105c23:	eb 04                	jmp    c0105c29 <strtol+0x1a>
        s ++;
c0105c25:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105c29:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c2c:	0f b6 00             	movzbl (%eax),%eax
c0105c2f:	3c 20                	cmp    $0x20,%al
c0105c31:	74 f2                	je     c0105c25 <strtol+0x16>
c0105c33:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c36:	0f b6 00             	movzbl (%eax),%eax
c0105c39:	3c 09                	cmp    $0x9,%al
c0105c3b:	74 e8                	je     c0105c25 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105c3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c40:	0f b6 00             	movzbl (%eax),%eax
c0105c43:	3c 2b                	cmp    $0x2b,%al
c0105c45:	75 06                	jne    c0105c4d <strtol+0x3e>
        s ++;
c0105c47:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105c4b:	eb 15                	jmp    c0105c62 <strtol+0x53>
    }
    else if (*s == '-') {
c0105c4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c50:	0f b6 00             	movzbl (%eax),%eax
c0105c53:	3c 2d                	cmp    $0x2d,%al
c0105c55:	75 0b                	jne    c0105c62 <strtol+0x53>
        s ++, neg = 1;
c0105c57:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105c5b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105c62:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c66:	74 06                	je     c0105c6e <strtol+0x5f>
c0105c68:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105c6c:	75 24                	jne    c0105c92 <strtol+0x83>
c0105c6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c71:	0f b6 00             	movzbl (%eax),%eax
c0105c74:	3c 30                	cmp    $0x30,%al
c0105c76:	75 1a                	jne    c0105c92 <strtol+0x83>
c0105c78:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c7b:	83 c0 01             	add    $0x1,%eax
c0105c7e:	0f b6 00             	movzbl (%eax),%eax
c0105c81:	3c 78                	cmp    $0x78,%al
c0105c83:	75 0d                	jne    c0105c92 <strtol+0x83>
        s += 2, base = 16;
c0105c85:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105c89:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105c90:	eb 2a                	jmp    c0105cbc <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105c92:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c96:	75 17                	jne    c0105caf <strtol+0xa0>
c0105c98:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c9b:	0f b6 00             	movzbl (%eax),%eax
c0105c9e:	3c 30                	cmp    $0x30,%al
c0105ca0:	75 0d                	jne    c0105caf <strtol+0xa0>
        s ++, base = 8;
c0105ca2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105ca6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105cad:	eb 0d                	jmp    c0105cbc <strtol+0xad>
    }
    else if (base == 0) {
c0105caf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105cb3:	75 07                	jne    c0105cbc <strtol+0xad>
        base = 10;
c0105cb5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105cbc:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cbf:	0f b6 00             	movzbl (%eax),%eax
c0105cc2:	3c 2f                	cmp    $0x2f,%al
c0105cc4:	7e 1b                	jle    c0105ce1 <strtol+0xd2>
c0105cc6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cc9:	0f b6 00             	movzbl (%eax),%eax
c0105ccc:	3c 39                	cmp    $0x39,%al
c0105cce:	7f 11                	jg     c0105ce1 <strtol+0xd2>
            dig = *s - '0';
c0105cd0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cd3:	0f b6 00             	movzbl (%eax),%eax
c0105cd6:	0f be c0             	movsbl %al,%eax
c0105cd9:	83 e8 30             	sub    $0x30,%eax
c0105cdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105cdf:	eb 48                	jmp    c0105d29 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105ce1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ce4:	0f b6 00             	movzbl (%eax),%eax
c0105ce7:	3c 60                	cmp    $0x60,%al
c0105ce9:	7e 1b                	jle    c0105d06 <strtol+0xf7>
c0105ceb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cee:	0f b6 00             	movzbl (%eax),%eax
c0105cf1:	3c 7a                	cmp    $0x7a,%al
c0105cf3:	7f 11                	jg     c0105d06 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105cf5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cf8:	0f b6 00             	movzbl (%eax),%eax
c0105cfb:	0f be c0             	movsbl %al,%eax
c0105cfe:	83 e8 57             	sub    $0x57,%eax
c0105d01:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d04:	eb 23                	jmp    c0105d29 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105d06:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d09:	0f b6 00             	movzbl (%eax),%eax
c0105d0c:	3c 40                	cmp    $0x40,%al
c0105d0e:	7e 3d                	jle    c0105d4d <strtol+0x13e>
c0105d10:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d13:	0f b6 00             	movzbl (%eax),%eax
c0105d16:	3c 5a                	cmp    $0x5a,%al
c0105d18:	7f 33                	jg     c0105d4d <strtol+0x13e>
            dig = *s - 'A' + 10;
c0105d1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d1d:	0f b6 00             	movzbl (%eax),%eax
c0105d20:	0f be c0             	movsbl %al,%eax
c0105d23:	83 e8 37             	sub    $0x37,%eax
c0105d26:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d2c:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105d2f:	7c 02                	jl     c0105d33 <strtol+0x124>
            break;
c0105d31:	eb 1a                	jmp    c0105d4d <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0105d33:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105d37:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105d3a:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105d3e:	89 c2                	mov    %eax,%edx
c0105d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d43:	01 d0                	add    %edx,%eax
c0105d45:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0105d48:	e9 6f ff ff ff       	jmp    c0105cbc <strtol+0xad>

    if (endptr) {
c0105d4d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105d51:	74 08                	je     c0105d5b <strtol+0x14c>
        *endptr = (char *) s;
c0105d53:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d56:	8b 55 08             	mov    0x8(%ebp),%edx
c0105d59:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105d5b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105d5f:	74 07                	je     c0105d68 <strtol+0x159>
c0105d61:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105d64:	f7 d8                	neg    %eax
c0105d66:	eb 03                	jmp    c0105d6b <strtol+0x15c>
c0105d68:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105d6b:	c9                   	leave  
c0105d6c:	c3                   	ret    

c0105d6d <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105d6d:	55                   	push   %ebp
c0105d6e:	89 e5                	mov    %esp,%ebp
c0105d70:	57                   	push   %edi
c0105d71:	83 ec 24             	sub    $0x24,%esp
c0105d74:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d77:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105d7a:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105d7e:	8b 55 08             	mov    0x8(%ebp),%edx
c0105d81:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105d84:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105d87:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105d8d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105d90:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105d94:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105d97:	89 d7                	mov    %edx,%edi
c0105d99:	f3 aa                	rep stos %al,%es:(%edi)
c0105d9b:	89 fa                	mov    %edi,%edx
c0105d9d:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105da0:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105da3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105da6:	83 c4 24             	add    $0x24,%esp
c0105da9:	5f                   	pop    %edi
c0105daa:	5d                   	pop    %ebp
c0105dab:	c3                   	ret    

c0105dac <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105dac:	55                   	push   %ebp
c0105dad:	89 e5                	mov    %esp,%ebp
c0105daf:	57                   	push   %edi
c0105db0:	56                   	push   %esi
c0105db1:	53                   	push   %ebx
c0105db2:	83 ec 30             	sub    $0x30,%esp
c0105db5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105db8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105dbe:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105dc1:	8b 45 10             	mov    0x10(%ebp),%eax
c0105dc4:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105dc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105dca:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105dcd:	73 42                	jae    c0105e11 <memmove+0x65>
c0105dcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105dd2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105dd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105dd8:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105ddb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105dde:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105de1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105de4:	c1 e8 02             	shr    $0x2,%eax
c0105de7:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105de9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105dec:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105def:	89 d7                	mov    %edx,%edi
c0105df1:	89 c6                	mov    %eax,%esi
c0105df3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105df5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105df8:	83 e1 03             	and    $0x3,%ecx
c0105dfb:	74 02                	je     c0105dff <memmove+0x53>
c0105dfd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105dff:	89 f0                	mov    %esi,%eax
c0105e01:	89 fa                	mov    %edi,%edx
c0105e03:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105e06:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105e09:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105e0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105e0f:	eb 36                	jmp    c0105e47 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105e11:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e14:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105e17:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e1a:	01 c2                	add    %eax,%edx
c0105e1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e1f:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105e22:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e25:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0105e28:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e2b:	89 c1                	mov    %eax,%ecx
c0105e2d:	89 d8                	mov    %ebx,%eax
c0105e2f:	89 d6                	mov    %edx,%esi
c0105e31:	89 c7                	mov    %eax,%edi
c0105e33:	fd                   	std    
c0105e34:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105e36:	fc                   	cld    
c0105e37:	89 f8                	mov    %edi,%eax
c0105e39:	89 f2                	mov    %esi,%edx
c0105e3b:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105e3e:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105e41:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0105e44:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105e47:	83 c4 30             	add    $0x30,%esp
c0105e4a:	5b                   	pop    %ebx
c0105e4b:	5e                   	pop    %esi
c0105e4c:	5f                   	pop    %edi
c0105e4d:	5d                   	pop    %ebp
c0105e4e:	c3                   	ret    

c0105e4f <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105e4f:	55                   	push   %ebp
c0105e50:	89 e5                	mov    %esp,%ebp
c0105e52:	57                   	push   %edi
c0105e53:	56                   	push   %esi
c0105e54:	83 ec 20             	sub    $0x20,%esp
c0105e57:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105e5d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e60:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105e63:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e66:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105e69:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e6c:	c1 e8 02             	shr    $0x2,%eax
c0105e6f:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105e71:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105e74:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e77:	89 d7                	mov    %edx,%edi
c0105e79:	89 c6                	mov    %eax,%esi
c0105e7b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105e7d:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105e80:	83 e1 03             	and    $0x3,%ecx
c0105e83:	74 02                	je     c0105e87 <memcpy+0x38>
c0105e85:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105e87:	89 f0                	mov    %esi,%eax
c0105e89:	89 fa                	mov    %edi,%edx
c0105e8b:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105e8e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105e91:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105e97:	83 c4 20             	add    $0x20,%esp
c0105e9a:	5e                   	pop    %esi
c0105e9b:	5f                   	pop    %edi
c0105e9c:	5d                   	pop    %ebp
c0105e9d:	c3                   	ret    

c0105e9e <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105e9e:	55                   	push   %ebp
c0105e9f:	89 e5                	mov    %esp,%ebp
c0105ea1:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105ea4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ea7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105eaa:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ead:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105eb0:	eb 30                	jmp    c0105ee2 <memcmp+0x44>
        if (*s1 != *s2) {
c0105eb2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105eb5:	0f b6 10             	movzbl (%eax),%edx
c0105eb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105ebb:	0f b6 00             	movzbl (%eax),%eax
c0105ebe:	38 c2                	cmp    %al,%dl
c0105ec0:	74 18                	je     c0105eda <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105ec2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105ec5:	0f b6 00             	movzbl (%eax),%eax
c0105ec8:	0f b6 d0             	movzbl %al,%edx
c0105ecb:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105ece:	0f b6 00             	movzbl (%eax),%eax
c0105ed1:	0f b6 c0             	movzbl %al,%eax
c0105ed4:	29 c2                	sub    %eax,%edx
c0105ed6:	89 d0                	mov    %edx,%eax
c0105ed8:	eb 1a                	jmp    c0105ef4 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0105eda:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105ede:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0105ee2:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ee5:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105ee8:	89 55 10             	mov    %edx,0x10(%ebp)
c0105eeb:	85 c0                	test   %eax,%eax
c0105eed:	75 c3                	jne    c0105eb2 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0105eef:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105ef4:	c9                   	leave  
c0105ef5:	c3                   	ret    
