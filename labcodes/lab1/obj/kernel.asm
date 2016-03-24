
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 80 fd 10 00       	mov    $0x10fd80,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 ea 10 00 	movl   $0x10ea16,(%esp)
  100027:	e8 f0 33 00 00       	call   10341c <memset>

    cons_init();                // init the console
  10002c:	e8 55 15 00 00       	call   101586 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 c0 35 10 00 	movl   $0x1035c0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 dc 35 10 00 	movl   $0x1035dc,(%esp)
  100046:	e8 d7 02 00 00       	call   100322 <cprintf>

    print_kerninfo();
  10004b:	e8 06 08 00 00       	call   100856 <print_kerninfo>

    grade_backtrace();
  100050:	e8 8b 00 00 00       	call   1000e0 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 08 2a 00 00       	call   102a62 <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 6a 16 00 00       	call   1016c9 <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 e2 17 00 00       	call   101846 <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 10 0d 00 00       	call   100d79 <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 c9 15 00 00       	call   101637 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  10006e:	e8 6d 01 00 00       	call   1001e0 <lab1_switch_test>

    /* do nothing */
    while (1);
  100073:	eb fe                	jmp    100073 <kern_init+0x73>

00100075 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100075:	55                   	push   %ebp
  100076:	89 e5                	mov    %esp,%ebp
  100078:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  10007b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  100082:	00 
  100083:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10008a:	00 
  10008b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100092:	e8 14 0c 00 00       	call   100cab <mon_backtrace>
}
  100097:	c9                   	leave  
  100098:	c3                   	ret    

00100099 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100099:	55                   	push   %ebp
  10009a:	89 e5                	mov    %esp,%ebp
  10009c:	53                   	push   %ebx
  10009d:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000a0:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000a6:	8d 55 08             	lea    0x8(%ebp),%edx
  1000a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1000ac:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000b0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000b4:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000b8:	89 04 24             	mov    %eax,(%esp)
  1000bb:	e8 b5 ff ff ff       	call   100075 <grade_backtrace2>
}
  1000c0:	83 c4 14             	add    $0x14,%esp
  1000c3:	5b                   	pop    %ebx
  1000c4:	5d                   	pop    %ebp
  1000c5:	c3                   	ret    

001000c6 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c6:	55                   	push   %ebp
  1000c7:	89 e5                	mov    %esp,%ebp
  1000c9:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000cc:	8b 45 10             	mov    0x10(%ebp),%eax
  1000cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d6:	89 04 24             	mov    %eax,(%esp)
  1000d9:	e8 bb ff ff ff       	call   100099 <grade_backtrace1>
}
  1000de:	c9                   	leave  
  1000df:	c3                   	ret    

001000e0 <grade_backtrace>:

void
grade_backtrace(void) {
  1000e0:	55                   	push   %ebp
  1000e1:	89 e5                	mov    %esp,%ebp
  1000e3:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e6:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000eb:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000f2:	ff 
  1000f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000fe:	e8 c3 ff ff ff       	call   1000c6 <grade_backtrace0>
}
  100103:	c9                   	leave  
  100104:	c3                   	ret    

00100105 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  10010b:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  10010e:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100111:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100114:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100117:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10011b:	0f b7 c0             	movzwl %ax,%eax
  10011e:	83 e0 03             	and    $0x3,%eax
  100121:	89 c2                	mov    %eax,%edx
  100123:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100128:	89 54 24 08          	mov    %edx,0x8(%esp)
  10012c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100130:	c7 04 24 e1 35 10 00 	movl   $0x1035e1,(%esp)
  100137:	e8 e6 01 00 00       	call   100322 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  10013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100140:	0f b7 d0             	movzwl %ax,%edx
  100143:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100148:	89 54 24 08          	mov    %edx,0x8(%esp)
  10014c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100150:	c7 04 24 ef 35 10 00 	movl   $0x1035ef,(%esp)
  100157:	e8 c6 01 00 00       	call   100322 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  10015c:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100160:	0f b7 d0             	movzwl %ax,%edx
  100163:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100168:	89 54 24 08          	mov    %edx,0x8(%esp)
  10016c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100170:	c7 04 24 fd 35 10 00 	movl   $0x1035fd,(%esp)
  100177:	e8 a6 01 00 00       	call   100322 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  10017c:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100180:	0f b7 d0             	movzwl %ax,%edx
  100183:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100188:	89 54 24 08          	mov    %edx,0x8(%esp)
  10018c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100190:	c7 04 24 0b 36 10 00 	movl   $0x10360b,(%esp)
  100197:	e8 86 01 00 00       	call   100322 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  10019c:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001a0:	0f b7 d0             	movzwl %ax,%edx
  1001a3:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001a8:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b0:	c7 04 24 19 36 10 00 	movl   $0x103619,(%esp)
  1001b7:	e8 66 01 00 00       	call   100322 <cprintf>
    round ++;
  1001bc:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001c1:	83 c0 01             	add    $0x1,%eax
  1001c4:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001c9:	c9                   	leave  
  1001ca:	c3                   	ret    

001001cb <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001cb:	55                   	push   %ebp
  1001cc:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	// My Code starts
	// 转向用户态，用户态的栈上信息要多出SS和ESP，因此需要先把栈顶向下拉出两个字节
	// 然后在产生转向用户态的中断。这样栈上就预先有了两个字，就像用户态一样
	asm volatile (
  1001ce:	83 ec 08             	sub    $0x8,%esp
  1001d1:	cd 78                	int    $0x78
  1001d3:	89 ec                	mov    %ebp,%esp
	    "movl %%ebp, %%esp"  // 完成这个函数的返回
	    : 
	    : "i"(T_SWITCH_TOU)  // 输入的变量，i表示常数
	);
	// My Code ends
}
  1001d5:	5d                   	pop    %ebp
  1001d6:	c3                   	ret    

001001d7 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001d7:	55                   	push   %ebp
  1001d8:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	// My Code starts
	// 转向核心态，则栈上不会多东西，所以不同预先处理栈
	asm volatile (
  1001da:	cd 79                	int    $0x79
  1001dc:	89 ec                	mov    %ebp,%esp
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
	// My Code ends
}
  1001de:	5d                   	pop    %ebp
  1001df:	c3                   	ret    

001001e0 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001e0:	55                   	push   %ebp
  1001e1:	89 e5                	mov    %esp,%ebp
  1001e3:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001e6:	e8 1a ff ff ff       	call   100105 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001eb:	c7 04 24 28 36 10 00 	movl   $0x103628,(%esp)
  1001f2:	e8 2b 01 00 00       	call   100322 <cprintf>
    lab1_switch_to_user();
  1001f7:	e8 cf ff ff ff       	call   1001cb <lab1_switch_to_user>
    lab1_print_cur_status();
  1001fc:	e8 04 ff ff ff       	call   100105 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100201:	c7 04 24 48 36 10 00 	movl   $0x103648,(%esp)
  100208:	e8 15 01 00 00       	call   100322 <cprintf>
    lab1_switch_to_kernel();
  10020d:	e8 c5 ff ff ff       	call   1001d7 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100212:	e8 ee fe ff ff       	call   100105 <lab1_print_cur_status>
}
  100217:	c9                   	leave  
  100218:	c3                   	ret    

00100219 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100219:	55                   	push   %ebp
  10021a:	89 e5                	mov    %esp,%ebp
  10021c:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  10021f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100223:	74 13                	je     100238 <readline+0x1f>
        cprintf("%s", prompt);
  100225:	8b 45 08             	mov    0x8(%ebp),%eax
  100228:	89 44 24 04          	mov    %eax,0x4(%esp)
  10022c:	c7 04 24 67 36 10 00 	movl   $0x103667,(%esp)
  100233:	e8 ea 00 00 00       	call   100322 <cprintf>
    }
    int i = 0, c;
  100238:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  10023f:	e8 66 01 00 00       	call   1003aa <getchar>
  100244:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100247:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10024b:	79 07                	jns    100254 <readline+0x3b>
            return NULL;
  10024d:	b8 00 00 00 00       	mov    $0x0,%eax
  100252:	eb 79                	jmp    1002cd <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100254:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100258:	7e 28                	jle    100282 <readline+0x69>
  10025a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100261:	7f 1f                	jg     100282 <readline+0x69>
            cputchar(c);
  100263:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100266:	89 04 24             	mov    %eax,(%esp)
  100269:	e8 da 00 00 00       	call   100348 <cputchar>
            buf[i ++] = c;
  10026e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100271:	8d 50 01             	lea    0x1(%eax),%edx
  100274:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100277:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10027a:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  100280:	eb 46                	jmp    1002c8 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  100282:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100286:	75 17                	jne    10029f <readline+0x86>
  100288:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10028c:	7e 11                	jle    10029f <readline+0x86>
            cputchar(c);
  10028e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100291:	89 04 24             	mov    %eax,(%esp)
  100294:	e8 af 00 00 00       	call   100348 <cputchar>
            i --;
  100299:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10029d:	eb 29                	jmp    1002c8 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  10029f:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002a3:	74 06                	je     1002ab <readline+0x92>
  1002a5:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002a9:	75 1d                	jne    1002c8 <readline+0xaf>
            cputchar(c);
  1002ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002ae:	89 04 24             	mov    %eax,(%esp)
  1002b1:	e8 92 00 00 00       	call   100348 <cputchar>
            buf[i] = '\0';
  1002b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002b9:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1002be:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002c1:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1002c6:	eb 05                	jmp    1002cd <readline+0xb4>
        }
    }
  1002c8:	e9 72 ff ff ff       	jmp    10023f <readline+0x26>
}
  1002cd:	c9                   	leave  
  1002ce:	c3                   	ret    

001002cf <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002cf:	55                   	push   %ebp
  1002d0:	89 e5                	mov    %esp,%ebp
  1002d2:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1002d8:	89 04 24             	mov    %eax,(%esp)
  1002db:	e8 d2 12 00 00       	call   1015b2 <cons_putc>
    (*cnt) ++;
  1002e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002e3:	8b 00                	mov    (%eax),%eax
  1002e5:	8d 50 01             	lea    0x1(%eax),%edx
  1002e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002eb:	89 10                	mov    %edx,(%eax)
}
  1002ed:	c9                   	leave  
  1002ee:	c3                   	ret    

001002ef <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002ef:	55                   	push   %ebp
  1002f0:	89 e5                	mov    %esp,%ebp
  1002f2:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100303:	8b 45 08             	mov    0x8(%ebp),%eax
  100306:	89 44 24 08          	mov    %eax,0x8(%esp)
  10030a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10030d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100311:	c7 04 24 cf 02 10 00 	movl   $0x1002cf,(%esp)
  100318:	e8 18 29 00 00       	call   102c35 <vprintfmt>
    return cnt;
  10031d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100320:	c9                   	leave  
  100321:	c3                   	ret    

00100322 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100322:	55                   	push   %ebp
  100323:	89 e5                	mov    %esp,%ebp
  100325:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100328:	8d 45 0c             	lea    0xc(%ebp),%eax
  10032b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10032e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100331:	89 44 24 04          	mov    %eax,0x4(%esp)
  100335:	8b 45 08             	mov    0x8(%ebp),%eax
  100338:	89 04 24             	mov    %eax,(%esp)
  10033b:	e8 af ff ff ff       	call   1002ef <vcprintf>
  100340:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100343:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100346:	c9                   	leave  
  100347:	c3                   	ret    

00100348 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100348:	55                   	push   %ebp
  100349:	89 e5                	mov    %esp,%ebp
  10034b:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10034e:	8b 45 08             	mov    0x8(%ebp),%eax
  100351:	89 04 24             	mov    %eax,(%esp)
  100354:	e8 59 12 00 00       	call   1015b2 <cons_putc>
}
  100359:	c9                   	leave  
  10035a:	c3                   	ret    

0010035b <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10035b:	55                   	push   %ebp
  10035c:	89 e5                	mov    %esp,%ebp
  10035e:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100361:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100368:	eb 13                	jmp    10037d <cputs+0x22>
        cputch(c, &cnt);
  10036a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10036e:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100371:	89 54 24 04          	mov    %edx,0x4(%esp)
  100375:	89 04 24             	mov    %eax,(%esp)
  100378:	e8 52 ff ff ff       	call   1002cf <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  10037d:	8b 45 08             	mov    0x8(%ebp),%eax
  100380:	8d 50 01             	lea    0x1(%eax),%edx
  100383:	89 55 08             	mov    %edx,0x8(%ebp)
  100386:	0f b6 00             	movzbl (%eax),%eax
  100389:	88 45 f7             	mov    %al,-0x9(%ebp)
  10038c:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100390:	75 d8                	jne    10036a <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  100392:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100395:	89 44 24 04          	mov    %eax,0x4(%esp)
  100399:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003a0:	e8 2a ff ff ff       	call   1002cf <cputch>
    return cnt;
  1003a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003a8:	c9                   	leave  
  1003a9:	c3                   	ret    

001003aa <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003aa:	55                   	push   %ebp
  1003ab:	89 e5                	mov    %esp,%ebp
  1003ad:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003b0:	e8 26 12 00 00       	call   1015db <cons_getc>
  1003b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003bc:	74 f2                	je     1003b0 <getchar+0x6>
        /* do nothing */;
    return c;
  1003be:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003c1:	c9                   	leave  
  1003c2:	c3                   	ret    

001003c3 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003c3:	55                   	push   %ebp
  1003c4:	89 e5                	mov    %esp,%ebp
  1003c6:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003cc:	8b 00                	mov    (%eax),%eax
  1003ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003d1:	8b 45 10             	mov    0x10(%ebp),%eax
  1003d4:	8b 00                	mov    (%eax),%eax
  1003d6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	// For efficiency, the binsearch is not implemented in a recursive manner
    while (l <= r) {
  1003e0:	e9 d2 00 00 00       	jmp    1004b7 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1003e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1003eb:	01 d0                	add    %edx,%eax
  1003ed:	89 c2                	mov    %eax,%edx
  1003ef:	c1 ea 1f             	shr    $0x1f,%edx
  1003f2:	01 d0                	add    %edx,%eax
  1003f4:	d1 f8                	sar    %eax
  1003f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1003f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1003fc:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003ff:	eb 04                	jmp    100405 <stab_binsearch+0x42>
            m --;
  100401:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
	// For efficiency, the binsearch is not implemented in a recursive manner
    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100405:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100408:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10040b:	7c 1f                	jl     10042c <stab_binsearch+0x69>
  10040d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100410:	89 d0                	mov    %edx,%eax
  100412:	01 c0                	add    %eax,%eax
  100414:	01 d0                	add    %edx,%eax
  100416:	c1 e0 02             	shl    $0x2,%eax
  100419:	89 c2                	mov    %eax,%edx
  10041b:	8b 45 08             	mov    0x8(%ebp),%eax
  10041e:	01 d0                	add    %edx,%eax
  100420:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100424:	0f b6 c0             	movzbl %al,%eax
  100427:	3b 45 14             	cmp    0x14(%ebp),%eax
  10042a:	75 d5                	jne    100401 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  10042c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10042f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100432:	7d 0b                	jge    10043f <stab_binsearch+0x7c>
            l = true_m + 1;
  100434:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100437:	83 c0 01             	add    $0x1,%eax
  10043a:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10043d:	eb 78                	jmp    1004b7 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  10043f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100446:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100449:	89 d0                	mov    %edx,%eax
  10044b:	01 c0                	add    %eax,%eax
  10044d:	01 d0                	add    %edx,%eax
  10044f:	c1 e0 02             	shl    $0x2,%eax
  100452:	89 c2                	mov    %eax,%edx
  100454:	8b 45 08             	mov    0x8(%ebp),%eax
  100457:	01 d0                	add    %edx,%eax
  100459:	8b 40 08             	mov    0x8(%eax),%eax
  10045c:	3b 45 18             	cmp    0x18(%ebp),%eax
  10045f:	73 13                	jae    100474 <stab_binsearch+0xb1>
            *region_left = m;
  100461:	8b 45 0c             	mov    0xc(%ebp),%eax
  100464:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100467:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100469:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10046c:	83 c0 01             	add    $0x1,%eax
  10046f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100472:	eb 43                	jmp    1004b7 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100474:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100477:	89 d0                	mov    %edx,%eax
  100479:	01 c0                	add    %eax,%eax
  10047b:	01 d0                	add    %edx,%eax
  10047d:	c1 e0 02             	shl    $0x2,%eax
  100480:	89 c2                	mov    %eax,%edx
  100482:	8b 45 08             	mov    0x8(%ebp),%eax
  100485:	01 d0                	add    %edx,%eax
  100487:	8b 40 08             	mov    0x8(%eax),%eax
  10048a:	3b 45 18             	cmp    0x18(%ebp),%eax
  10048d:	76 16                	jbe    1004a5 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10048f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100492:	8d 50 ff             	lea    -0x1(%eax),%edx
  100495:	8b 45 10             	mov    0x10(%ebp),%eax
  100498:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10049a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10049d:	83 e8 01             	sub    $0x1,%eax
  1004a0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004a3:	eb 12                	jmp    1004b7 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004ab:	89 10                	mov    %edx,(%eax)
            l = m;
  1004ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004b3:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;
	// For efficiency, the binsearch is not implemented in a recursive manner
    while (l <= r) {
  1004b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004ba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004bd:	0f 8e 22 ff ff ff    	jle    1003e5 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004c7:	75 0f                	jne    1004d8 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004cc:	8b 00                	mov    (%eax),%eax
  1004ce:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004d1:	8b 45 10             	mov    0x10(%ebp),%eax
  1004d4:	89 10                	mov    %edx,(%eax)
  1004d6:	eb 3f                	jmp    100517 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004d8:	8b 45 10             	mov    0x10(%ebp),%eax
  1004db:	8b 00                	mov    (%eax),%eax
  1004dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004e0:	eb 04                	jmp    1004e6 <stab_binsearch+0x123>
  1004e2:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1004e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e9:	8b 00                	mov    (%eax),%eax
  1004eb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004ee:	7d 1f                	jge    10050f <stab_binsearch+0x14c>
  1004f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004f3:	89 d0                	mov    %edx,%eax
  1004f5:	01 c0                	add    %eax,%eax
  1004f7:	01 d0                	add    %edx,%eax
  1004f9:	c1 e0 02             	shl    $0x2,%eax
  1004fc:	89 c2                	mov    %eax,%edx
  1004fe:	8b 45 08             	mov    0x8(%ebp),%eax
  100501:	01 d0                	add    %edx,%eax
  100503:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100507:	0f b6 c0             	movzbl %al,%eax
  10050a:	3b 45 14             	cmp    0x14(%ebp),%eax
  10050d:	75 d3                	jne    1004e2 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  10050f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100512:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100515:	89 10                	mov    %edx,(%eax)
    }
}
  100517:	c9                   	leave  
  100518:	c3                   	ret    

00100519 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100519:	55                   	push   %ebp
  10051a:	89 e5                	mov    %esp,%ebp
  10051c:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  10051f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100522:	c7 00 6c 36 10 00    	movl   $0x10366c,(%eax)
    info->eip_line = 0;
  100528:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100532:	8b 45 0c             	mov    0xc(%ebp),%eax
  100535:	c7 40 08 6c 36 10 00 	movl   $0x10366c,0x8(%eax)
    info->eip_fn_namelen = 9;
  10053c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053f:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100546:	8b 45 0c             	mov    0xc(%ebp),%eax
  100549:	8b 55 08             	mov    0x8(%ebp),%edx
  10054c:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10054f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100552:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100559:	c7 45 f4 ec 3e 10 00 	movl   $0x103eec,-0xc(%ebp)
    stab_end = __STAB_END__;
  100560:	c7 45 f0 28 b7 10 00 	movl   $0x10b728,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100567:	c7 45 ec 29 b7 10 00 	movl   $0x10b729,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10056e:	c7 45 e8 54 d7 10 00 	movl   $0x10d754,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100575:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100578:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10057b:	76 0d                	jbe    10058a <debuginfo_eip+0x71>
  10057d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100580:	83 e8 01             	sub    $0x1,%eax
  100583:	0f b6 00             	movzbl (%eax),%eax
  100586:	84 c0                	test   %al,%al
  100588:	74 0a                	je     100594 <debuginfo_eip+0x7b>
        return -1;
  10058a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10058f:	e9 c0 02 00 00       	jmp    100854 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100594:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10059b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10059e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005a1:	29 c2                	sub    %eax,%edx
  1005a3:	89 d0                	mov    %edx,%eax
  1005a5:	c1 f8 02             	sar    $0x2,%eax
  1005a8:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005ae:	83 e8 01             	sub    $0x1,%eax
  1005b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1005b7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005bb:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005c2:	00 
  1005c3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ca:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005d4:	89 04 24             	mov    %eax,(%esp)
  1005d7:	e8 e7 fd ff ff       	call   1003c3 <stab_binsearch>
    if (lfile == 0)
  1005dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005df:	85 c0                	test   %eax,%eax
  1005e1:	75 0a                	jne    1005ed <debuginfo_eip+0xd4>
        return -1;
  1005e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005e8:	e9 67 02 00 00       	jmp    100854 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1005ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005f0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1005f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1005f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1005f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1005fc:	89 44 24 10          	mov    %eax,0x10(%esp)
  100600:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100607:	00 
  100608:	8d 45 d8             	lea    -0x28(%ebp),%eax
  10060b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10060f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100612:	89 44 24 04          	mov    %eax,0x4(%esp)
  100616:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100619:	89 04 24             	mov    %eax,(%esp)
  10061c:	e8 a2 fd ff ff       	call   1003c3 <stab_binsearch>

    if (lfun <= rfun) {
  100621:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100624:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100627:	39 c2                	cmp    %eax,%edx
  100629:	7f 7c                	jg     1006a7 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10062b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10062e:	89 c2                	mov    %eax,%edx
  100630:	89 d0                	mov    %edx,%eax
  100632:	01 c0                	add    %eax,%eax
  100634:	01 d0                	add    %edx,%eax
  100636:	c1 e0 02             	shl    $0x2,%eax
  100639:	89 c2                	mov    %eax,%edx
  10063b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10063e:	01 d0                	add    %edx,%eax
  100640:	8b 10                	mov    (%eax),%edx
  100642:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100645:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100648:	29 c1                	sub    %eax,%ecx
  10064a:	89 c8                	mov    %ecx,%eax
  10064c:	39 c2                	cmp    %eax,%edx
  10064e:	73 22                	jae    100672 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100650:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100653:	89 c2                	mov    %eax,%edx
  100655:	89 d0                	mov    %edx,%eax
  100657:	01 c0                	add    %eax,%eax
  100659:	01 d0                	add    %edx,%eax
  10065b:	c1 e0 02             	shl    $0x2,%eax
  10065e:	89 c2                	mov    %eax,%edx
  100660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100663:	01 d0                	add    %edx,%eax
  100665:	8b 10                	mov    (%eax),%edx
  100667:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10066a:	01 c2                	add    %eax,%edx
  10066c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10066f:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100672:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100675:	89 c2                	mov    %eax,%edx
  100677:	89 d0                	mov    %edx,%eax
  100679:	01 c0                	add    %eax,%eax
  10067b:	01 d0                	add    %edx,%eax
  10067d:	c1 e0 02             	shl    $0x2,%eax
  100680:	89 c2                	mov    %eax,%edx
  100682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100685:	01 d0                	add    %edx,%eax
  100687:	8b 50 08             	mov    0x8(%eax),%edx
  10068a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10068d:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100690:	8b 45 0c             	mov    0xc(%ebp),%eax
  100693:	8b 40 10             	mov    0x10(%eax),%eax
  100696:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100699:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10069c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10069f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006a2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006a5:	eb 15                	jmp    1006bc <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006aa:	8b 55 08             	mov    0x8(%ebp),%edx
  1006ad:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006b9:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006bf:	8b 40 08             	mov    0x8(%eax),%eax
  1006c2:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006c9:	00 
  1006ca:	89 04 24             	mov    %eax,(%esp)
  1006cd:	e8 be 2b 00 00       	call   103290 <strfind>
  1006d2:	89 c2                	mov    %eax,%edx
  1006d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d7:	8b 40 08             	mov    0x8(%eax),%eax
  1006da:	29 c2                	sub    %eax,%edx
  1006dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006df:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1006e5:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006e9:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1006f0:	00 
  1006f1:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1006f4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006f8:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1006fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100702:	89 04 24             	mov    %eax,(%esp)
  100705:	e8 b9 fc ff ff       	call   1003c3 <stab_binsearch>
    if (lline <= rline) {
  10070a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10070d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100710:	39 c2                	cmp    %eax,%edx
  100712:	7f 24                	jg     100738 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  100714:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100717:	89 c2                	mov    %eax,%edx
  100719:	89 d0                	mov    %edx,%eax
  10071b:	01 c0                	add    %eax,%eax
  10071d:	01 d0                	add    %edx,%eax
  10071f:	c1 e0 02             	shl    $0x2,%eax
  100722:	89 c2                	mov    %eax,%edx
  100724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100727:	01 d0                	add    %edx,%eax
  100729:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10072d:	0f b7 d0             	movzwl %ax,%edx
  100730:	8b 45 0c             	mov    0xc(%ebp),%eax
  100733:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100736:	eb 13                	jmp    10074b <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100738:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10073d:	e9 12 01 00 00       	jmp    100854 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100742:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100745:	83 e8 01             	sub    $0x1,%eax
  100748:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10074b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10074e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100751:	39 c2                	cmp    %eax,%edx
  100753:	7c 56                	jl     1007ab <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  100755:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100758:	89 c2                	mov    %eax,%edx
  10075a:	89 d0                	mov    %edx,%eax
  10075c:	01 c0                	add    %eax,%eax
  10075e:	01 d0                	add    %edx,%eax
  100760:	c1 e0 02             	shl    $0x2,%eax
  100763:	89 c2                	mov    %eax,%edx
  100765:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100768:	01 d0                	add    %edx,%eax
  10076a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10076e:	3c 84                	cmp    $0x84,%al
  100770:	74 39                	je     1007ab <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100772:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100775:	89 c2                	mov    %eax,%edx
  100777:	89 d0                	mov    %edx,%eax
  100779:	01 c0                	add    %eax,%eax
  10077b:	01 d0                	add    %edx,%eax
  10077d:	c1 e0 02             	shl    $0x2,%eax
  100780:	89 c2                	mov    %eax,%edx
  100782:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100785:	01 d0                	add    %edx,%eax
  100787:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10078b:	3c 64                	cmp    $0x64,%al
  10078d:	75 b3                	jne    100742 <debuginfo_eip+0x229>
  10078f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100792:	89 c2                	mov    %eax,%edx
  100794:	89 d0                	mov    %edx,%eax
  100796:	01 c0                	add    %eax,%eax
  100798:	01 d0                	add    %edx,%eax
  10079a:	c1 e0 02             	shl    $0x2,%eax
  10079d:	89 c2                	mov    %eax,%edx
  10079f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007a2:	01 d0                	add    %edx,%eax
  1007a4:	8b 40 08             	mov    0x8(%eax),%eax
  1007a7:	85 c0                	test   %eax,%eax
  1007a9:	74 97                	je     100742 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007ab:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007b1:	39 c2                	cmp    %eax,%edx
  1007b3:	7c 46                	jl     1007fb <debuginfo_eip+0x2e2>
  1007b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007b8:	89 c2                	mov    %eax,%edx
  1007ba:	89 d0                	mov    %edx,%eax
  1007bc:	01 c0                	add    %eax,%eax
  1007be:	01 d0                	add    %edx,%eax
  1007c0:	c1 e0 02             	shl    $0x2,%eax
  1007c3:	89 c2                	mov    %eax,%edx
  1007c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007c8:	01 d0                	add    %edx,%eax
  1007ca:	8b 10                	mov    (%eax),%edx
  1007cc:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007d2:	29 c1                	sub    %eax,%ecx
  1007d4:	89 c8                	mov    %ecx,%eax
  1007d6:	39 c2                	cmp    %eax,%edx
  1007d8:	73 21                	jae    1007fb <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007dd:	89 c2                	mov    %eax,%edx
  1007df:	89 d0                	mov    %edx,%eax
  1007e1:	01 c0                	add    %eax,%eax
  1007e3:	01 d0                	add    %edx,%eax
  1007e5:	c1 e0 02             	shl    $0x2,%eax
  1007e8:	89 c2                	mov    %eax,%edx
  1007ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007ed:	01 d0                	add    %edx,%eax
  1007ef:	8b 10                	mov    (%eax),%edx
  1007f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007f4:	01 c2                	add    %eax,%edx
  1007f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007f9:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007fb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100801:	39 c2                	cmp    %eax,%edx
  100803:	7d 4a                	jge    10084f <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  100805:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100808:	83 c0 01             	add    $0x1,%eax
  10080b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  10080e:	eb 18                	jmp    100828 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100810:	8b 45 0c             	mov    0xc(%ebp),%eax
  100813:	8b 40 14             	mov    0x14(%eax),%eax
  100816:	8d 50 01             	lea    0x1(%eax),%edx
  100819:	8b 45 0c             	mov    0xc(%ebp),%eax
  10081c:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  10081f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100822:	83 c0 01             	add    $0x1,%eax
  100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100828:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10082b:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  10082e:	39 c2                	cmp    %eax,%edx
  100830:	7d 1d                	jge    10084f <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100832:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100835:	89 c2                	mov    %eax,%edx
  100837:	89 d0                	mov    %edx,%eax
  100839:	01 c0                	add    %eax,%eax
  10083b:	01 d0                	add    %edx,%eax
  10083d:	c1 e0 02             	shl    $0x2,%eax
  100840:	89 c2                	mov    %eax,%edx
  100842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100845:	01 d0                	add    %edx,%eax
  100847:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10084b:	3c a0                	cmp    $0xa0,%al
  10084d:	74 c1                	je     100810 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  10084f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100854:	c9                   	leave  
  100855:	c3                   	ret    

00100856 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100856:	55                   	push   %ebp
  100857:	89 e5                	mov    %esp,%ebp
  100859:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10085c:	c7 04 24 76 36 10 00 	movl   $0x103676,(%esp)
  100863:	e8 ba fa ff ff       	call   100322 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100868:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10086f:	00 
  100870:	c7 04 24 8f 36 10 00 	movl   $0x10368f,(%esp)
  100877:	e8 a6 fa ff ff       	call   100322 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10087c:	c7 44 24 04 a5 35 10 	movl   $0x1035a5,0x4(%esp)
  100883:	00 
  100884:	c7 04 24 a7 36 10 00 	movl   $0x1036a7,(%esp)
  10088b:	e8 92 fa ff ff       	call   100322 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100890:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  100897:	00 
  100898:	c7 04 24 bf 36 10 00 	movl   $0x1036bf,(%esp)
  10089f:	e8 7e fa ff ff       	call   100322 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008a4:	c7 44 24 04 80 fd 10 	movl   $0x10fd80,0x4(%esp)
  1008ab:	00 
  1008ac:	c7 04 24 d7 36 10 00 	movl   $0x1036d7,(%esp)
  1008b3:	e8 6a fa ff ff       	call   100322 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008b8:	b8 80 fd 10 00       	mov    $0x10fd80,%eax
  1008bd:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008c3:	b8 00 00 10 00       	mov    $0x100000,%eax
  1008c8:	29 c2                	sub    %eax,%edx
  1008ca:	89 d0                	mov    %edx,%eax
  1008cc:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008d2:	85 c0                	test   %eax,%eax
  1008d4:	0f 48 c2             	cmovs  %edx,%eax
  1008d7:	c1 f8 0a             	sar    $0xa,%eax
  1008da:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008de:	c7 04 24 f0 36 10 00 	movl   $0x1036f0,(%esp)
  1008e5:	e8 38 fa ff ff       	call   100322 <cprintf>
}
  1008ea:	c9                   	leave  
  1008eb:	c3                   	ret    

001008ec <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1008ec:	55                   	push   %ebp
  1008ed:	89 e5                	mov    %esp,%ebp
  1008ef:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1008f5:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1008ff:	89 04 24             	mov    %eax,(%esp)
  100902:	e8 12 fc ff ff       	call   100519 <debuginfo_eip>
  100907:	85 c0                	test   %eax,%eax
  100909:	74 15                	je     100920 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  10090b:	8b 45 08             	mov    0x8(%ebp),%eax
  10090e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100912:	c7 04 24 1a 37 10 00 	movl   $0x10371a,(%esp)
  100919:	e8 04 fa ff ff       	call   100322 <cprintf>
  10091e:	eb 6d                	jmp    10098d <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100920:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100927:	eb 1c                	jmp    100945 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100929:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10092c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10092f:	01 d0                	add    %edx,%eax
  100931:	0f b6 00             	movzbl (%eax),%eax
  100934:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10093a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10093d:	01 ca                	add    %ecx,%edx
  10093f:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100941:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100945:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100948:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10094b:	7f dc                	jg     100929 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  10094d:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100953:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100956:	01 d0                	add    %edx,%eax
  100958:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  10095b:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  10095e:	8b 55 08             	mov    0x8(%ebp),%edx
  100961:	89 d1                	mov    %edx,%ecx
  100963:	29 c1                	sub    %eax,%ecx
  100965:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100968:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10096b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10096f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100975:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100979:	89 54 24 08          	mov    %edx,0x8(%esp)
  10097d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100981:	c7 04 24 36 37 10 00 	movl   $0x103736,(%esp)
  100988:	e8 95 f9 ff ff       	call   100322 <cprintf>
                fnname, eip - info.eip_fn_addr);
		// print file, line, function name and location in the function
    }
}
  10098d:	c9                   	leave  
  10098e:	c3                   	ret    

0010098f <read_eip>:

static __noinline uint32_t
read_eip(void) {
  10098f:	55                   	push   %ebp
  100990:	89 e5                	mov    %esp,%ebp
  100992:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100995:	8b 45 04             	mov    0x4(%ebp),%eax
  100998:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  10099b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10099e:	c9                   	leave  
  10099f:	c3                   	ret    

001009a0 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009a0:	55                   	push   %ebp
  1009a1:	89 e5                	mov    %esp,%ebp
  1009a3:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009a6:	89 e8                	mov    %ebp,%eax
  1009a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  1009ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	// My Code Starts
	uint32_t current_ebp = read_ebp();
  1009ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t current_eip = read_eip();
  1009b1:	e8 d9 ff ff ff       	call   10098f <read_eip>
  1009b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	
	int i;    //  ‘for’ loop initial declarations are not allowed here
	for (i = 0; i < STACKFRAME_DEPTH; i++) {
  1009b9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009c0:	e9 9f 00 00 00       	jmp    100a64 <print_stackframe+0xc4>
		if (current_ebp == 0) {
  1009c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1009c9:	75 05                	jne    1009d0 <print_stackframe+0x30>
			break;
  1009cb:	e9 9e 00 00 00       	jmp    100a6e <print_stackframe+0xce>
		}

		cprintf("ebp:0x%08x eip:0x%08x ", current_ebp, current_eip);
  1009d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009da:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009de:	c7 04 24 48 37 10 00 	movl   $0x103748,(%esp)
  1009e5:	e8 38 f9 ff ff       	call   100322 <cprintf>
		// Cannot use printf, since we're writing a kernel, not an app!
	    
		cprintf("args:");
  1009ea:	c7 04 24 5f 37 10 00 	movl   $0x10375f,(%esp)
  1009f1:	e8 2c f9 ff ff       	call   100322 <cprintf>
		uint32_t *argbase = (uint32_t*)current_ebp + 2;       
  1009f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009f9:	83 c0 08             	add    $0x8,%eax
  1009fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// the first argument is 2 words away, return_address standing in between
		int j;
		for (j = 0; j < 4; j++) {
  1009ff:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a06:	eb 25                	jmp    100a2d <print_stackframe+0x8d>
			cprintf("0x%08x ", argbase[j]);
  100a08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a0b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a15:	01 d0                	add    %edx,%eax
  100a17:	8b 00                	mov    (%eax),%eax
  100a19:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a1d:	c7 04 24 65 37 10 00 	movl   $0x103765,(%esp)
  100a24:	e8 f9 f8 ff ff       	call   100322 <cprintf>
	    
		cprintf("args:");
		uint32_t *argbase = (uint32_t*)current_ebp + 2;       
		// the first argument is 2 words away, return_address standing in between
		int j;
		for (j = 0; j < 4; j++) {
  100a29:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a2d:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a31:	7e d5                	jle    100a08 <print_stackframe+0x68>
			cprintf("0x%08x ", argbase[j]);
		}
		cprintf("\n");
  100a33:	c7 04 24 6d 37 10 00 	movl   $0x10376d,(%esp)
  100a3a:	e8 e3 f8 ff ff       	call   100322 <cprintf>
		print_debuginfo(current_eip - 1);     // eip points to next instruction
  100a3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a42:	83 e8 01             	sub    $0x1,%eax
  100a45:	89 04 24             	mov    %eax,(%esp)
  100a48:	e8 9f fe ff ff       	call   1008ec <print_debuginfo>
		
		// moving to next frame on the stack
		current_eip = *((uint32_t*)current_ebp + 1);    // return address
  100a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a50:	83 c0 04             	add    $0x4,%eax
  100a53:	8b 00                	mov    (%eax),%eax
  100a55:	89 45 f0             	mov    %eax,-0x10(%ebp)
		current_ebp = *((uint32_t*)current_ebp);      // ebp of last frame
  100a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a5b:	8b 00                	mov    (%eax),%eax
  100a5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// My Code Starts
	uint32_t current_ebp = read_ebp();
	uint32_t current_eip = read_eip();
	
	int i;    //  ‘for’ loop initial declarations are not allowed here
	for (i = 0; i < STACKFRAME_DEPTH; i++) {
  100a60:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a64:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a68:	0f 8e 57 ff ff ff    	jle    1009c5 <print_stackframe+0x25>
		// moving to next frame on the stack
		current_eip = *((uint32_t*)current_ebp + 1);    // return address
		current_ebp = *((uint32_t*)current_ebp);      // ebp of last frame
	}
	// My Code Ends
}
  100a6e:	c9                   	leave  
  100a6f:	c3                   	ret    

00100a70 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a70:	55                   	push   %ebp
  100a71:	89 e5                	mov    %esp,%ebp
  100a73:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a76:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a7d:	eb 0c                	jmp    100a8b <parse+0x1b>
            *buf ++ = '\0';
  100a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  100a82:	8d 50 01             	lea    0x1(%eax),%edx
  100a85:	89 55 08             	mov    %edx,0x8(%ebp)
  100a88:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  100a8e:	0f b6 00             	movzbl (%eax),%eax
  100a91:	84 c0                	test   %al,%al
  100a93:	74 1d                	je     100ab2 <parse+0x42>
  100a95:	8b 45 08             	mov    0x8(%ebp),%eax
  100a98:	0f b6 00             	movzbl (%eax),%eax
  100a9b:	0f be c0             	movsbl %al,%eax
  100a9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100aa2:	c7 04 24 f0 37 10 00 	movl   $0x1037f0,(%esp)
  100aa9:	e8 af 27 00 00       	call   10325d <strchr>
  100aae:	85 c0                	test   %eax,%eax
  100ab0:	75 cd                	jne    100a7f <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  100ab5:	0f b6 00             	movzbl (%eax),%eax
  100ab8:	84 c0                	test   %al,%al
  100aba:	75 02                	jne    100abe <parse+0x4e>
            break;
  100abc:	eb 67                	jmp    100b25 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100abe:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ac2:	75 14                	jne    100ad8 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ac4:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100acb:	00 
  100acc:	c7 04 24 f5 37 10 00 	movl   $0x1037f5,(%esp)
  100ad3:	e8 4a f8 ff ff       	call   100322 <cprintf>
        }
        argv[argc ++] = buf;
  100ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100adb:	8d 50 01             	lea    0x1(%eax),%edx
  100ade:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100ae1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ae8:	8b 45 0c             	mov    0xc(%ebp),%eax
  100aeb:	01 c2                	add    %eax,%edx
  100aed:	8b 45 08             	mov    0x8(%ebp),%eax
  100af0:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100af2:	eb 04                	jmp    100af8 <parse+0x88>
            buf ++;
  100af4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100af8:	8b 45 08             	mov    0x8(%ebp),%eax
  100afb:	0f b6 00             	movzbl (%eax),%eax
  100afe:	84 c0                	test   %al,%al
  100b00:	74 1d                	je     100b1f <parse+0xaf>
  100b02:	8b 45 08             	mov    0x8(%ebp),%eax
  100b05:	0f b6 00             	movzbl (%eax),%eax
  100b08:	0f be c0             	movsbl %al,%eax
  100b0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b0f:	c7 04 24 f0 37 10 00 	movl   $0x1037f0,(%esp)
  100b16:	e8 42 27 00 00       	call   10325d <strchr>
  100b1b:	85 c0                	test   %eax,%eax
  100b1d:	74 d5                	je     100af4 <parse+0x84>
            buf ++;
        }
    }
  100b1f:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b20:	e9 66 ff ff ff       	jmp    100a8b <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b28:	c9                   	leave  
  100b29:	c3                   	ret    

00100b2a <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b2a:	55                   	push   %ebp
  100b2b:	89 e5                	mov    %esp,%ebp
  100b2d:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b30:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b33:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b37:	8b 45 08             	mov    0x8(%ebp),%eax
  100b3a:	89 04 24             	mov    %eax,(%esp)
  100b3d:	e8 2e ff ff ff       	call   100a70 <parse>
  100b42:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b45:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b49:	75 0a                	jne    100b55 <runcmd+0x2b>
        return 0;
  100b4b:	b8 00 00 00 00       	mov    $0x0,%eax
  100b50:	e9 85 00 00 00       	jmp    100bda <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b55:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b5c:	eb 5c                	jmp    100bba <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b5e:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b64:	89 d0                	mov    %edx,%eax
  100b66:	01 c0                	add    %eax,%eax
  100b68:	01 d0                	add    %edx,%eax
  100b6a:	c1 e0 02             	shl    $0x2,%eax
  100b6d:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b72:	8b 00                	mov    (%eax),%eax
  100b74:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b78:	89 04 24             	mov    %eax,(%esp)
  100b7b:	e8 3e 26 00 00       	call   1031be <strcmp>
  100b80:	85 c0                	test   %eax,%eax
  100b82:	75 32                	jne    100bb6 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b87:	89 d0                	mov    %edx,%eax
  100b89:	01 c0                	add    %eax,%eax
  100b8b:	01 d0                	add    %edx,%eax
  100b8d:	c1 e0 02             	shl    $0x2,%eax
  100b90:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b95:	8b 40 08             	mov    0x8(%eax),%eax
  100b98:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100b9b:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100b9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  100ba1:	89 54 24 08          	mov    %edx,0x8(%esp)
  100ba5:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100ba8:	83 c2 04             	add    $0x4,%edx
  100bab:	89 54 24 04          	mov    %edx,0x4(%esp)
  100baf:	89 0c 24             	mov    %ecx,(%esp)
  100bb2:	ff d0                	call   *%eax
  100bb4:	eb 24                	jmp    100bda <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bb6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bbd:	83 f8 02             	cmp    $0x2,%eax
  100bc0:	76 9c                	jbe    100b5e <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bc2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bc9:	c7 04 24 13 38 10 00 	movl   $0x103813,(%esp)
  100bd0:	e8 4d f7 ff ff       	call   100322 <cprintf>
    return 0;
  100bd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bda:	c9                   	leave  
  100bdb:	c3                   	ret    

00100bdc <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bdc:	55                   	push   %ebp
  100bdd:	89 e5                	mov    %esp,%ebp
  100bdf:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100be2:	c7 04 24 2c 38 10 00 	movl   $0x10382c,(%esp)
  100be9:	e8 34 f7 ff ff       	call   100322 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bee:	c7 04 24 54 38 10 00 	movl   $0x103854,(%esp)
  100bf5:	e8 28 f7 ff ff       	call   100322 <cprintf>

    if (tf != NULL) {
  100bfa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100bfe:	74 0b                	je     100c0b <kmonitor+0x2f>
        print_trapframe(tf);
  100c00:	8b 45 08             	mov    0x8(%ebp),%eax
  100c03:	89 04 24             	mov    %eax,(%esp)
  100c06:	e8 ef 0d 00 00       	call   1019fa <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c0b:	c7 04 24 79 38 10 00 	movl   $0x103879,(%esp)
  100c12:	e8 02 f6 ff ff       	call   100219 <readline>
  100c17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c1e:	74 18                	je     100c38 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c20:	8b 45 08             	mov    0x8(%ebp),%eax
  100c23:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c2a:	89 04 24             	mov    %eax,(%esp)
  100c2d:	e8 f8 fe ff ff       	call   100b2a <runcmd>
  100c32:	85 c0                	test   %eax,%eax
  100c34:	79 02                	jns    100c38 <kmonitor+0x5c>
                break;
  100c36:	eb 02                	jmp    100c3a <kmonitor+0x5e>
            }
        }
    }
  100c38:	eb d1                	jmp    100c0b <kmonitor+0x2f>
}
  100c3a:	c9                   	leave  
  100c3b:	c3                   	ret    

00100c3c <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c3c:	55                   	push   %ebp
  100c3d:	89 e5                	mov    %esp,%ebp
  100c3f:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c49:	eb 3f                	jmp    100c8a <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c4e:	89 d0                	mov    %edx,%eax
  100c50:	01 c0                	add    %eax,%eax
  100c52:	01 d0                	add    %edx,%eax
  100c54:	c1 e0 02             	shl    $0x2,%eax
  100c57:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c5c:	8b 48 04             	mov    0x4(%eax),%ecx
  100c5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c62:	89 d0                	mov    %edx,%eax
  100c64:	01 c0                	add    %eax,%eax
  100c66:	01 d0                	add    %edx,%eax
  100c68:	c1 e0 02             	shl    $0x2,%eax
  100c6b:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c70:	8b 00                	mov    (%eax),%eax
  100c72:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c76:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c7a:	c7 04 24 7d 38 10 00 	movl   $0x10387d,(%esp)
  100c81:	e8 9c f6 ff ff       	call   100322 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c86:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c8d:	83 f8 02             	cmp    $0x2,%eax
  100c90:	76 b9                	jbe    100c4b <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c97:	c9                   	leave  
  100c98:	c3                   	ret    

00100c99 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c99:	55                   	push   %ebp
  100c9a:	89 e5                	mov    %esp,%ebp
  100c9c:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c9f:	e8 b2 fb ff ff       	call   100856 <print_kerninfo>
    return 0;
  100ca4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ca9:	c9                   	leave  
  100caa:	c3                   	ret    

00100cab <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cab:	55                   	push   %ebp
  100cac:	89 e5                	mov    %esp,%ebp
  100cae:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cb1:	e8 ea fc ff ff       	call   1009a0 <print_stackframe>
    return 0;
  100cb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cbb:	c9                   	leave  
  100cbc:	c3                   	ret    

00100cbd <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100cbd:	55                   	push   %ebp
  100cbe:	89 e5                	mov    %esp,%ebp
  100cc0:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cc3:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  100cc8:	85 c0                	test   %eax,%eax
  100cca:	74 02                	je     100cce <__panic+0x11>
        goto panic_dead;
  100ccc:	eb 48                	jmp    100d16 <__panic+0x59>
    }
    is_panic = 1;
  100cce:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  100cd5:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cd8:	8d 45 14             	lea    0x14(%ebp),%eax
  100cdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cde:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ce1:	89 44 24 08          	mov    %eax,0x8(%esp)
  100ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  100ce8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cec:	c7 04 24 86 38 10 00 	movl   $0x103886,(%esp)
  100cf3:	e8 2a f6 ff ff       	call   100322 <cprintf>
    vcprintf(fmt, ap);
  100cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cfb:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cff:	8b 45 10             	mov    0x10(%ebp),%eax
  100d02:	89 04 24             	mov    %eax,(%esp)
  100d05:	e8 e5 f5 ff ff       	call   1002ef <vcprintf>
    cprintf("\n");
  100d0a:	c7 04 24 a2 38 10 00 	movl   $0x1038a2,(%esp)
  100d11:	e8 0c f6 ff ff       	call   100322 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100d16:	e8 22 09 00 00       	call   10163d <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d1b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d22:	e8 b5 fe ff ff       	call   100bdc <kmonitor>
    }
  100d27:	eb f2                	jmp    100d1b <__panic+0x5e>

00100d29 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d29:	55                   	push   %ebp
  100d2a:	89 e5                	mov    %esp,%ebp
  100d2c:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d2f:	8d 45 14             	lea    0x14(%ebp),%eax
  100d32:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d35:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d38:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  100d3f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d43:	c7 04 24 a4 38 10 00 	movl   $0x1038a4,(%esp)
  100d4a:	e8 d3 f5 ff ff       	call   100322 <cprintf>
    vcprintf(fmt, ap);
  100d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d52:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d56:	8b 45 10             	mov    0x10(%ebp),%eax
  100d59:	89 04 24             	mov    %eax,(%esp)
  100d5c:	e8 8e f5 ff ff       	call   1002ef <vcprintf>
    cprintf("\n");
  100d61:	c7 04 24 a2 38 10 00 	movl   $0x1038a2,(%esp)
  100d68:	e8 b5 f5 ff ff       	call   100322 <cprintf>
    va_end(ap);
}
  100d6d:	c9                   	leave  
  100d6e:	c3                   	ret    

00100d6f <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d6f:	55                   	push   %ebp
  100d70:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d72:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100d77:	5d                   	pop    %ebp
  100d78:	c3                   	ret    

00100d79 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d79:	55                   	push   %ebp
  100d7a:	89 e5                	mov    %esp,%ebp
  100d7c:	83 ec 28             	sub    $0x28,%esp
  100d7f:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d85:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d89:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d8d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d91:	ee                   	out    %al,(%dx)
  100d92:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d98:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d9c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100da0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100da4:	ee                   	out    %al,(%dx)
  100da5:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100dab:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100daf:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100db3:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100db7:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100db8:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100dbf:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dc2:	c7 04 24 c2 38 10 00 	movl   $0x1038c2,(%esp)
  100dc9:	e8 54 f5 ff ff       	call   100322 <cprintf>
    pic_enable(IRQ_TIMER);
  100dce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100dd5:	e8 c1 08 00 00       	call   10169b <pic_enable>
}
  100dda:	c9                   	leave  
  100ddb:	c3                   	ret    

00100ddc <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100ddc:	55                   	push   %ebp
  100ddd:	89 e5                	mov    %esp,%ebp
  100ddf:	83 ec 10             	sub    $0x10,%esp
  100de2:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100de8:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100dec:	89 c2                	mov    %eax,%edx
  100dee:	ec                   	in     (%dx),%al
  100def:	88 45 fd             	mov    %al,-0x3(%ebp)
  100df2:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100df8:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100dfc:	89 c2                	mov    %eax,%edx
  100dfe:	ec                   	in     (%dx),%al
  100dff:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e02:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e08:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e0c:	89 c2                	mov    %eax,%edx
  100e0e:	ec                   	in     (%dx),%al
  100e0f:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e12:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e18:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e1c:	89 c2                	mov    %eax,%edx
  100e1e:	ec                   	in     (%dx),%al
  100e1f:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e22:	c9                   	leave  
  100e23:	c3                   	ret    

00100e24 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e24:	55                   	push   %ebp
  100e25:	89 e5                	mov    %esp,%ebp
  100e27:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e2a:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e34:	0f b7 00             	movzwl (%eax),%eax
  100e37:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e3e:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e46:	0f b7 00             	movzwl (%eax),%eax
  100e49:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e4d:	74 12                	je     100e61 <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e4f:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e56:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e5d:	b4 03 
  100e5f:	eb 13                	jmp    100e74 <cga_init+0x50>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e64:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e68:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e6b:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e72:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e74:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e7b:	0f b7 c0             	movzwl %ax,%eax
  100e7e:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100e82:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e86:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e8a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e8e:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e8f:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e96:	83 c0 01             	add    $0x1,%eax
  100e99:	0f b7 c0             	movzwl %ax,%eax
  100e9c:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ea0:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100ea4:	89 c2                	mov    %eax,%edx
  100ea6:	ec                   	in     (%dx),%al
  100ea7:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100eaa:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100eae:	0f b6 c0             	movzbl %al,%eax
  100eb1:	c1 e0 08             	shl    $0x8,%eax
  100eb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100eb7:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ebe:	0f b7 c0             	movzwl %ax,%eax
  100ec1:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100ec5:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ec9:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ecd:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100ed1:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100ed2:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ed9:	83 c0 01             	add    $0x1,%eax
  100edc:	0f b7 c0             	movzwl %ax,%eax
  100edf:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ee3:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100ee7:	89 c2                	mov    %eax,%edx
  100ee9:	ec                   	in     (%dx),%al
  100eea:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100eed:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ef1:	0f b6 c0             	movzbl %al,%eax
  100ef4:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100ef7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100efa:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f02:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100f08:	c9                   	leave  
  100f09:	c3                   	ret    

00100f0a <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f0a:	55                   	push   %ebp
  100f0b:	89 e5                	mov    %esp,%ebp
  100f0d:	83 ec 48             	sub    $0x48,%esp
  100f10:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f16:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f1a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f1e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f22:	ee                   	out    %al,(%dx)
  100f23:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f29:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f2d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f31:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f35:	ee                   	out    %al,(%dx)
  100f36:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f3c:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f40:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f44:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f48:	ee                   	out    %al,(%dx)
  100f49:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f4f:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f53:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f57:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f5b:	ee                   	out    %al,(%dx)
  100f5c:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100f62:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100f66:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f6a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f6e:	ee                   	out    %al,(%dx)
  100f6f:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100f75:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100f79:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f7d:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f81:	ee                   	out    %al,(%dx)
  100f82:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f88:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100f8c:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f90:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f94:	ee                   	out    %al,(%dx)
  100f95:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f9b:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100f9f:	89 c2                	mov    %eax,%edx
  100fa1:	ec                   	in     (%dx),%al
  100fa2:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100fa5:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fa9:	3c ff                	cmp    $0xff,%al
  100fab:	0f 95 c0             	setne  %al
  100fae:	0f b6 c0             	movzbl %al,%eax
  100fb1:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100fb6:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fbc:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  100fc0:	89 c2                	mov    %eax,%edx
  100fc2:	ec                   	in     (%dx),%al
  100fc3:	88 45 d5             	mov    %al,-0x2b(%ebp)
  100fc6:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  100fcc:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  100fd0:	89 c2                	mov    %eax,%edx
  100fd2:	ec                   	in     (%dx),%al
  100fd3:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fd6:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100fdb:	85 c0                	test   %eax,%eax
  100fdd:	74 0c                	je     100feb <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100fdf:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100fe6:	e8 b0 06 00 00       	call   10169b <pic_enable>
    }
}
  100feb:	c9                   	leave  
  100fec:	c3                   	ret    

00100fed <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fed:	55                   	push   %ebp
  100fee:	89 e5                	mov    %esp,%ebp
  100ff0:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100ff3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100ffa:	eb 09                	jmp    101005 <lpt_putc_sub+0x18>
        delay();
  100ffc:	e8 db fd ff ff       	call   100ddc <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101001:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101005:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  10100b:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10100f:	89 c2                	mov    %eax,%edx
  101011:	ec                   	in     (%dx),%al
  101012:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101015:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101019:	84 c0                	test   %al,%al
  10101b:	78 09                	js     101026 <lpt_putc_sub+0x39>
  10101d:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101024:	7e d6                	jle    100ffc <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  101026:	8b 45 08             	mov    0x8(%ebp),%eax
  101029:	0f b6 c0             	movzbl %al,%eax
  10102c:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101032:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101035:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101039:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10103d:	ee                   	out    %al,(%dx)
  10103e:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101044:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101048:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10104c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101050:	ee                   	out    %al,(%dx)
  101051:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  101057:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  10105b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10105f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101063:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101064:	c9                   	leave  
  101065:	c3                   	ret    

00101066 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101066:	55                   	push   %ebp
  101067:	89 e5                	mov    %esp,%ebp
  101069:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10106c:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101070:	74 0d                	je     10107f <lpt_putc+0x19>
        lpt_putc_sub(c);
  101072:	8b 45 08             	mov    0x8(%ebp),%eax
  101075:	89 04 24             	mov    %eax,(%esp)
  101078:	e8 70 ff ff ff       	call   100fed <lpt_putc_sub>
  10107d:	eb 24                	jmp    1010a3 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  10107f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101086:	e8 62 ff ff ff       	call   100fed <lpt_putc_sub>
        lpt_putc_sub(' ');
  10108b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101092:	e8 56 ff ff ff       	call   100fed <lpt_putc_sub>
        lpt_putc_sub('\b');
  101097:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10109e:	e8 4a ff ff ff       	call   100fed <lpt_putc_sub>
    }
}
  1010a3:	c9                   	leave  
  1010a4:	c3                   	ret    

001010a5 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010a5:	55                   	push   %ebp
  1010a6:	89 e5                	mov    %esp,%ebp
  1010a8:	53                   	push   %ebx
  1010a9:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1010af:	b0 00                	mov    $0x0,%al
  1010b1:	85 c0                	test   %eax,%eax
  1010b3:	75 07                	jne    1010bc <cga_putc+0x17>
        c |= 0x0700;
  1010b5:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1010bf:	0f b6 c0             	movzbl %al,%eax
  1010c2:	83 f8 0a             	cmp    $0xa,%eax
  1010c5:	74 4c                	je     101113 <cga_putc+0x6e>
  1010c7:	83 f8 0d             	cmp    $0xd,%eax
  1010ca:	74 57                	je     101123 <cga_putc+0x7e>
  1010cc:	83 f8 08             	cmp    $0x8,%eax
  1010cf:	0f 85 88 00 00 00    	jne    10115d <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  1010d5:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010dc:	66 85 c0             	test   %ax,%ax
  1010df:	74 30                	je     101111 <cga_putc+0x6c>
            crt_pos --;
  1010e1:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010e8:	83 e8 01             	sub    $0x1,%eax
  1010eb:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010f1:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010f6:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010fd:	0f b7 d2             	movzwl %dx,%edx
  101100:	01 d2                	add    %edx,%edx
  101102:	01 c2                	add    %eax,%edx
  101104:	8b 45 08             	mov    0x8(%ebp),%eax
  101107:	b0 00                	mov    $0x0,%al
  101109:	83 c8 20             	or     $0x20,%eax
  10110c:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  10110f:	eb 72                	jmp    101183 <cga_putc+0xde>
  101111:	eb 70                	jmp    101183 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  101113:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10111a:	83 c0 50             	add    $0x50,%eax
  10111d:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101123:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  10112a:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  101131:	0f b7 c1             	movzwl %cx,%eax
  101134:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  10113a:	c1 e8 10             	shr    $0x10,%eax
  10113d:	89 c2                	mov    %eax,%edx
  10113f:	66 c1 ea 06          	shr    $0x6,%dx
  101143:	89 d0                	mov    %edx,%eax
  101145:	c1 e0 02             	shl    $0x2,%eax
  101148:	01 d0                	add    %edx,%eax
  10114a:	c1 e0 04             	shl    $0x4,%eax
  10114d:	29 c1                	sub    %eax,%ecx
  10114f:	89 ca                	mov    %ecx,%edx
  101151:	89 d8                	mov    %ebx,%eax
  101153:	29 d0                	sub    %edx,%eax
  101155:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  10115b:	eb 26                	jmp    101183 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10115d:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  101163:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10116a:	8d 50 01             	lea    0x1(%eax),%edx
  10116d:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  101174:	0f b7 c0             	movzwl %ax,%eax
  101177:	01 c0                	add    %eax,%eax
  101179:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  10117c:	8b 45 08             	mov    0x8(%ebp),%eax
  10117f:	66 89 02             	mov    %ax,(%edx)
        break;
  101182:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101183:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10118a:	66 3d cf 07          	cmp    $0x7cf,%ax
  10118e:	76 5b                	jbe    1011eb <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101190:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101195:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10119b:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011a0:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011a7:	00 
  1011a8:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011ac:	89 04 24             	mov    %eax,(%esp)
  1011af:	e8 a7 22 00 00       	call   10345b <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011b4:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011bb:	eb 15                	jmp    1011d2 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  1011bd:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011c5:	01 d2                	add    %edx,%edx
  1011c7:	01 d0                	add    %edx,%eax
  1011c9:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011ce:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011d2:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011d9:	7e e2                	jle    1011bd <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1011db:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011e2:	83 e8 50             	sub    $0x50,%eax
  1011e5:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011eb:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011f2:	0f b7 c0             	movzwl %ax,%eax
  1011f5:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1011f9:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  1011fd:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101201:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101205:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101206:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10120d:	66 c1 e8 08          	shr    $0x8,%ax
  101211:	0f b6 c0             	movzbl %al,%eax
  101214:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10121b:	83 c2 01             	add    $0x1,%edx
  10121e:	0f b7 d2             	movzwl %dx,%edx
  101221:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  101225:	88 45 ed             	mov    %al,-0x13(%ebp)
  101228:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10122c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101230:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101231:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101238:	0f b7 c0             	movzwl %ax,%eax
  10123b:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  10123f:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101243:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101247:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10124b:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10124c:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101253:	0f b6 c0             	movzbl %al,%eax
  101256:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10125d:	83 c2 01             	add    $0x1,%edx
  101260:	0f b7 d2             	movzwl %dx,%edx
  101263:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  101267:	88 45 e5             	mov    %al,-0x1b(%ebp)
  10126a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10126e:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101272:	ee                   	out    %al,(%dx)
}
  101273:	83 c4 34             	add    $0x34,%esp
  101276:	5b                   	pop    %ebx
  101277:	5d                   	pop    %ebp
  101278:	c3                   	ret    

00101279 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101279:	55                   	push   %ebp
  10127a:	89 e5                	mov    %esp,%ebp
  10127c:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10127f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101286:	eb 09                	jmp    101291 <serial_putc_sub+0x18>
        delay();
  101288:	e8 4f fb ff ff       	call   100ddc <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10128d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101291:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101297:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10129b:	89 c2                	mov    %eax,%edx
  10129d:	ec                   	in     (%dx),%al
  10129e:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012a1:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012a5:	0f b6 c0             	movzbl %al,%eax
  1012a8:	83 e0 20             	and    $0x20,%eax
  1012ab:	85 c0                	test   %eax,%eax
  1012ad:	75 09                	jne    1012b8 <serial_putc_sub+0x3f>
  1012af:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012b6:	7e d0                	jle    101288 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1012b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1012bb:	0f b6 c0             	movzbl %al,%eax
  1012be:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1012c4:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012c7:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012cb:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012cf:	ee                   	out    %al,(%dx)
}
  1012d0:	c9                   	leave  
  1012d1:	c3                   	ret    

001012d2 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012d2:	55                   	push   %ebp
  1012d3:	89 e5                	mov    %esp,%ebp
  1012d5:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1012d8:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012dc:	74 0d                	je     1012eb <serial_putc+0x19>
        serial_putc_sub(c);
  1012de:	8b 45 08             	mov    0x8(%ebp),%eax
  1012e1:	89 04 24             	mov    %eax,(%esp)
  1012e4:	e8 90 ff ff ff       	call   101279 <serial_putc_sub>
  1012e9:	eb 24                	jmp    10130f <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  1012eb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012f2:	e8 82 ff ff ff       	call   101279 <serial_putc_sub>
        serial_putc_sub(' ');
  1012f7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1012fe:	e8 76 ff ff ff       	call   101279 <serial_putc_sub>
        serial_putc_sub('\b');
  101303:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10130a:	e8 6a ff ff ff       	call   101279 <serial_putc_sub>
    }
}
  10130f:	c9                   	leave  
  101310:	c3                   	ret    

00101311 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101311:	55                   	push   %ebp
  101312:	89 e5                	mov    %esp,%ebp
  101314:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101317:	eb 33                	jmp    10134c <cons_intr+0x3b>
        if (c != 0) {
  101319:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10131d:	74 2d                	je     10134c <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  10131f:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101324:	8d 50 01             	lea    0x1(%eax),%edx
  101327:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  10132d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101330:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101336:	a1 84 f0 10 00       	mov    0x10f084,%eax
  10133b:	3d 00 02 00 00       	cmp    $0x200,%eax
  101340:	75 0a                	jne    10134c <cons_intr+0x3b>
                cons.wpos = 0;
  101342:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  101349:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  10134c:	8b 45 08             	mov    0x8(%ebp),%eax
  10134f:	ff d0                	call   *%eax
  101351:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101354:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101358:	75 bf                	jne    101319 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  10135a:	c9                   	leave  
  10135b:	c3                   	ret    

0010135c <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10135c:	55                   	push   %ebp
  10135d:	89 e5                	mov    %esp,%ebp
  10135f:	83 ec 10             	sub    $0x10,%esp
  101362:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101368:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10136c:	89 c2                	mov    %eax,%edx
  10136e:	ec                   	in     (%dx),%al
  10136f:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101372:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101376:	0f b6 c0             	movzbl %al,%eax
  101379:	83 e0 01             	and    $0x1,%eax
  10137c:	85 c0                	test   %eax,%eax
  10137e:	75 07                	jne    101387 <serial_proc_data+0x2b>
        return -1;
  101380:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101385:	eb 2a                	jmp    1013b1 <serial_proc_data+0x55>
  101387:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10138d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101391:	89 c2                	mov    %eax,%edx
  101393:	ec                   	in     (%dx),%al
  101394:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101397:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10139b:	0f b6 c0             	movzbl %al,%eax
  10139e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013a1:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013a5:	75 07                	jne    1013ae <serial_proc_data+0x52>
        c = '\b';
  1013a7:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013b1:	c9                   	leave  
  1013b2:	c3                   	ret    

001013b3 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013b3:	55                   	push   %ebp
  1013b4:	89 e5                	mov    %esp,%ebp
  1013b6:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1013b9:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  1013be:	85 c0                	test   %eax,%eax
  1013c0:	74 0c                	je     1013ce <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  1013c2:	c7 04 24 5c 13 10 00 	movl   $0x10135c,(%esp)
  1013c9:	e8 43 ff ff ff       	call   101311 <cons_intr>
    }
}
  1013ce:	c9                   	leave  
  1013cf:	c3                   	ret    

001013d0 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013d0:	55                   	push   %ebp
  1013d1:	89 e5                	mov    %esp,%ebp
  1013d3:	83 ec 38             	sub    $0x38,%esp
  1013d6:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013dc:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013e0:	89 c2                	mov    %eax,%edx
  1013e2:	ec                   	in     (%dx),%al
  1013e3:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013e6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013ea:	0f b6 c0             	movzbl %al,%eax
  1013ed:	83 e0 01             	and    $0x1,%eax
  1013f0:	85 c0                	test   %eax,%eax
  1013f2:	75 0a                	jne    1013fe <kbd_proc_data+0x2e>
        return -1;
  1013f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013f9:	e9 59 01 00 00       	jmp    101557 <kbd_proc_data+0x187>
  1013fe:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101404:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101408:	89 c2                	mov    %eax,%edx
  10140a:	ec                   	in     (%dx),%al
  10140b:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10140e:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101412:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101415:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101419:	75 17                	jne    101432 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  10141b:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101420:	83 c8 40             	or     $0x40,%eax
  101423:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101428:	b8 00 00 00 00       	mov    $0x0,%eax
  10142d:	e9 25 01 00 00       	jmp    101557 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101432:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101436:	84 c0                	test   %al,%al
  101438:	79 47                	jns    101481 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10143a:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10143f:	83 e0 40             	and    $0x40,%eax
  101442:	85 c0                	test   %eax,%eax
  101444:	75 09                	jne    10144f <kbd_proc_data+0x7f>
  101446:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10144a:	83 e0 7f             	and    $0x7f,%eax
  10144d:	eb 04                	jmp    101453 <kbd_proc_data+0x83>
  10144f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101453:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101456:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10145a:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101461:	83 c8 40             	or     $0x40,%eax
  101464:	0f b6 c0             	movzbl %al,%eax
  101467:	f7 d0                	not    %eax
  101469:	89 c2                	mov    %eax,%edx
  10146b:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101470:	21 d0                	and    %edx,%eax
  101472:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101477:	b8 00 00 00 00       	mov    $0x0,%eax
  10147c:	e9 d6 00 00 00       	jmp    101557 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  101481:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101486:	83 e0 40             	and    $0x40,%eax
  101489:	85 c0                	test   %eax,%eax
  10148b:	74 11                	je     10149e <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  10148d:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101491:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101496:	83 e0 bf             	and    $0xffffffbf,%eax
  101499:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  10149e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a2:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  1014a9:	0f b6 d0             	movzbl %al,%edx
  1014ac:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014b1:	09 d0                	or     %edx,%eax
  1014b3:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  1014b8:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014bc:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  1014c3:	0f b6 d0             	movzbl %al,%edx
  1014c6:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014cb:	31 d0                	xor    %edx,%eax
  1014cd:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014d2:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014d7:	83 e0 03             	and    $0x3,%eax
  1014da:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014e1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014e5:	01 d0                	add    %edx,%eax
  1014e7:	0f b6 00             	movzbl (%eax),%eax
  1014ea:	0f b6 c0             	movzbl %al,%eax
  1014ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014f0:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014f5:	83 e0 08             	and    $0x8,%eax
  1014f8:	85 c0                	test   %eax,%eax
  1014fa:	74 22                	je     10151e <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014fc:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101500:	7e 0c                	jle    10150e <kbd_proc_data+0x13e>
  101502:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101506:	7f 06                	jg     10150e <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101508:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  10150c:	eb 10                	jmp    10151e <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  10150e:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101512:	7e 0a                	jle    10151e <kbd_proc_data+0x14e>
  101514:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101518:	7f 04                	jg     10151e <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  10151a:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10151e:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101523:	f7 d0                	not    %eax
  101525:	83 e0 06             	and    $0x6,%eax
  101528:	85 c0                	test   %eax,%eax
  10152a:	75 28                	jne    101554 <kbd_proc_data+0x184>
  10152c:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101533:	75 1f                	jne    101554 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101535:	c7 04 24 dd 38 10 00 	movl   $0x1038dd,(%esp)
  10153c:	e8 e1 ed ff ff       	call   100322 <cprintf>
  101541:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101547:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10154b:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10154f:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101553:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101554:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101557:	c9                   	leave  
  101558:	c3                   	ret    

00101559 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101559:	55                   	push   %ebp
  10155a:	89 e5                	mov    %esp,%ebp
  10155c:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  10155f:	c7 04 24 d0 13 10 00 	movl   $0x1013d0,(%esp)
  101566:	e8 a6 fd ff ff       	call   101311 <cons_intr>
}
  10156b:	c9                   	leave  
  10156c:	c3                   	ret    

0010156d <kbd_init>:

static void
kbd_init(void) {
  10156d:	55                   	push   %ebp
  10156e:	89 e5                	mov    %esp,%ebp
  101570:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101573:	e8 e1 ff ff ff       	call   101559 <kbd_intr>
    pic_enable(IRQ_KBD);
  101578:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10157f:	e8 17 01 00 00       	call   10169b <pic_enable>
}
  101584:	c9                   	leave  
  101585:	c3                   	ret    

00101586 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101586:	55                   	push   %ebp
  101587:	89 e5                	mov    %esp,%ebp
  101589:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  10158c:	e8 93 f8 ff ff       	call   100e24 <cga_init>
    serial_init();
  101591:	e8 74 f9 ff ff       	call   100f0a <serial_init>
    kbd_init();
  101596:	e8 d2 ff ff ff       	call   10156d <kbd_init>
    if (!serial_exists) {
  10159b:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  1015a0:	85 c0                	test   %eax,%eax
  1015a2:	75 0c                	jne    1015b0 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015a4:	c7 04 24 e9 38 10 00 	movl   $0x1038e9,(%esp)
  1015ab:	e8 72 ed ff ff       	call   100322 <cprintf>
    }
}
  1015b0:	c9                   	leave  
  1015b1:	c3                   	ret    

001015b2 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015b2:	55                   	push   %ebp
  1015b3:	89 e5                	mov    %esp,%ebp
  1015b5:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  1015b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1015bb:	89 04 24             	mov    %eax,(%esp)
  1015be:	e8 a3 fa ff ff       	call   101066 <lpt_putc>
    cga_putc(c);
  1015c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1015c6:	89 04 24             	mov    %eax,(%esp)
  1015c9:	e8 d7 fa ff ff       	call   1010a5 <cga_putc>
    serial_putc(c);
  1015ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1015d1:	89 04 24             	mov    %eax,(%esp)
  1015d4:	e8 f9 fc ff ff       	call   1012d2 <serial_putc>
}
  1015d9:	c9                   	leave  
  1015da:	c3                   	ret    

001015db <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015db:	55                   	push   %ebp
  1015dc:	89 e5                	mov    %esp,%ebp
  1015de:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015e1:	e8 cd fd ff ff       	call   1013b3 <serial_intr>
    kbd_intr();
  1015e6:	e8 6e ff ff ff       	call   101559 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015eb:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015f1:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015f6:	39 c2                	cmp    %eax,%edx
  1015f8:	74 36                	je     101630 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015fa:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015ff:	8d 50 01             	lea    0x1(%eax),%edx
  101602:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  101608:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  10160f:	0f b6 c0             	movzbl %al,%eax
  101612:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  101615:	a1 80 f0 10 00       	mov    0x10f080,%eax
  10161a:	3d 00 02 00 00       	cmp    $0x200,%eax
  10161f:	75 0a                	jne    10162b <cons_getc+0x50>
            cons.rpos = 0;
  101621:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  101628:	00 00 00 
        }
        return c;
  10162b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10162e:	eb 05                	jmp    101635 <cons_getc+0x5a>
    }
    return 0;
  101630:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101635:	c9                   	leave  
  101636:	c3                   	ret    

00101637 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101637:	55                   	push   %ebp
  101638:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  10163a:	fb                   	sti    
    sti();
}
  10163b:	5d                   	pop    %ebp
  10163c:	c3                   	ret    

0010163d <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  10163d:	55                   	push   %ebp
  10163e:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  101640:	fa                   	cli    
    cli();
}
  101641:	5d                   	pop    %ebp
  101642:	c3                   	ret    

00101643 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101643:	55                   	push   %ebp
  101644:	89 e5                	mov    %esp,%ebp
  101646:	83 ec 14             	sub    $0x14,%esp
  101649:	8b 45 08             	mov    0x8(%ebp),%eax
  10164c:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101650:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101654:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  10165a:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  10165f:	85 c0                	test   %eax,%eax
  101661:	74 36                	je     101699 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101663:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101667:	0f b6 c0             	movzbl %al,%eax
  10166a:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101670:	88 45 fd             	mov    %al,-0x3(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101673:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101677:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10167b:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  10167c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101680:	66 c1 e8 08          	shr    $0x8,%ax
  101684:	0f b6 c0             	movzbl %al,%eax
  101687:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  10168d:	88 45 f9             	mov    %al,-0x7(%ebp)
  101690:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101694:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101698:	ee                   	out    %al,(%dx)
    }
}
  101699:	c9                   	leave  
  10169a:	c3                   	ret    

0010169b <pic_enable>:

void
pic_enable(unsigned int irq) {
  10169b:	55                   	push   %ebp
  10169c:	89 e5                	mov    %esp,%ebp
  10169e:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  1016a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1016a4:	ba 01 00 00 00       	mov    $0x1,%edx
  1016a9:	89 c1                	mov    %eax,%ecx
  1016ab:	d3 e2                	shl    %cl,%edx
  1016ad:	89 d0                	mov    %edx,%eax
  1016af:	f7 d0                	not    %eax
  1016b1:	89 c2                	mov    %eax,%edx
  1016b3:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1016ba:	21 d0                	and    %edx,%eax
  1016bc:	0f b7 c0             	movzwl %ax,%eax
  1016bf:	89 04 24             	mov    %eax,(%esp)
  1016c2:	e8 7c ff ff ff       	call   101643 <pic_setmask>
}
  1016c7:	c9                   	leave  
  1016c8:	c3                   	ret    

001016c9 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016c9:	55                   	push   %ebp
  1016ca:	89 e5                	mov    %esp,%ebp
  1016cc:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1016cf:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016d6:	00 00 00 
  1016d9:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016df:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  1016e3:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016e7:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016eb:	ee                   	out    %al,(%dx)
  1016ec:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016f2:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  1016f6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016fa:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016fe:	ee                   	out    %al,(%dx)
  1016ff:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101705:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  101709:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10170d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101711:	ee                   	out    %al,(%dx)
  101712:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  101718:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  10171c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101720:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101724:	ee                   	out    %al,(%dx)
  101725:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  10172b:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  10172f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101733:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101737:	ee                   	out    %al,(%dx)
  101738:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  10173e:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  101742:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101746:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10174a:	ee                   	out    %al,(%dx)
  10174b:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  101751:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  101755:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101759:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10175d:	ee                   	out    %al,(%dx)
  10175e:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  101764:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  101768:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10176c:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101770:	ee                   	out    %al,(%dx)
  101771:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  101777:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  10177b:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10177f:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101783:	ee                   	out    %al,(%dx)
  101784:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  10178a:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  10178e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101792:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101796:	ee                   	out    %al,(%dx)
  101797:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  10179d:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  1017a1:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  1017a5:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1017a9:	ee                   	out    %al,(%dx)
  1017aa:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1017b0:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  1017b4:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1017b8:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1017bc:	ee                   	out    %al,(%dx)
  1017bd:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  1017c3:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  1017c7:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1017cb:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1017cf:	ee                   	out    %al,(%dx)
  1017d0:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  1017d6:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  1017da:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017de:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017e2:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017e3:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017ea:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017ee:	74 12                	je     101802 <pic_init+0x139>
        pic_setmask(irq_mask);
  1017f0:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017f7:	0f b7 c0             	movzwl %ax,%eax
  1017fa:	89 04 24             	mov    %eax,(%esp)
  1017fd:	e8 41 fe ff ff       	call   101643 <pic_setmask>
    }
}
  101802:	c9                   	leave  
  101803:	c3                   	ret    

00101804 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101804:	55                   	push   %ebp
  101805:	89 e5                	mov    %esp,%ebp
  101807:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10180a:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101811:	00 
  101812:	c7 04 24 20 39 10 00 	movl   $0x103920,(%esp)
  101819:	e8 04 eb ff ff       	call   100322 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  10181e:	c7 04 24 2a 39 10 00 	movl   $0x10392a,(%esp)
  101825:	e8 f8 ea ff ff       	call   100322 <cprintf>
    panic("EOT: kernel seems ok.");
  10182a:	c7 44 24 08 38 39 10 	movl   $0x103938,0x8(%esp)
  101831:	00 
  101832:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  101839:	00 
  10183a:	c7 04 24 4e 39 10 00 	movl   $0x10394e,(%esp)
  101841:	e8 77 f4 ff ff       	call   100cbd <__panic>

00101846 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101846:	55                   	push   %ebp
  101847:	89 e5                	mov    %esp,%ebp
  101849:	83 ec 10             	sub    $0x10,%esp
      */
	// My Code starts
	extern uintptr_t __vectors[];     // declaration code generted by vector.c
	int i;
	// fill in the idt
	for (i = 0; i < 256; i++) {
  10184c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101853:	e9 c3 00 00 00       	jmp    10191b <idt_init+0xd5>
		// not trap, kernel's code/text, offset defined in vector.S, privilege 0
		// macro defined in memlayout.h
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  101858:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10185b:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101862:	89 c2                	mov    %eax,%edx
  101864:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101867:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  10186e:	00 
  10186f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101872:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  101879:	00 08 00 
  10187c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10187f:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101886:	00 
  101887:	83 e2 e0             	and    $0xffffffe0,%edx
  10188a:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101891:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101894:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  10189b:	00 
  10189c:	83 e2 1f             	and    $0x1f,%edx
  10189f:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  1018a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018a9:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018b0:	00 
  1018b1:	83 e2 f0             	and    $0xfffffff0,%edx
  1018b4:	83 ca 0e             	or     $0xe,%edx
  1018b7:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c1:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018c8:	00 
  1018c9:	83 e2 ef             	and    $0xffffffef,%edx
  1018cc:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d6:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018dd:	00 
  1018de:	83 e2 9f             	and    $0xffffff9f,%edx
  1018e1:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018eb:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018f2:	00 
  1018f3:	83 ca 80             	or     $0xffffff80,%edx
  1018f6:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101900:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101907:	c1 e8 10             	shr    $0x10,%eax
  10190a:	89 c2                	mov    %eax,%edx
  10190c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10190f:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  101916:	00 
      */
	// My Code starts
	extern uintptr_t __vectors[];     // declaration code generted by vector.c
	int i;
	// fill in the idt
	for (i = 0; i < 256; i++) {
  101917:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10191b:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  101922:	0f 8e 30 ff ff ff    	jle    101858 <idt_init+0x12>
		// not trap, kernel's code/text, offset defined in vector.S, privilege 0
		// macro defined in memlayout.h
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
	}
	// For challenge 1, need to grant the access to SWITCH_TOKernel in user mode
	SETGATE(idt[T_SWITCH_TOK], 1, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  101928:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  10192d:	66 a3 68 f4 10 00    	mov    %ax,0x10f468
  101933:	66 c7 05 6a f4 10 00 	movw   $0x8,0x10f46a
  10193a:	08 00 
  10193c:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  101943:	83 e0 e0             	and    $0xffffffe0,%eax
  101946:	a2 6c f4 10 00       	mov    %al,0x10f46c
  10194b:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  101952:	83 e0 1f             	and    $0x1f,%eax
  101955:	a2 6c f4 10 00       	mov    %al,0x10f46c
  10195a:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101961:	83 c8 0f             	or     $0xf,%eax
  101964:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101969:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101970:	83 e0 ef             	and    $0xffffffef,%eax
  101973:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101978:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10197f:	83 c8 60             	or     $0x60,%eax
  101982:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101987:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10198e:	83 c8 80             	or     $0xffffff80,%eax
  101991:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101996:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  10199b:	c1 e8 10             	shr    $0x10,%eax
  10199e:	66 a3 6e f4 10 00    	mov    %ax,0x10f46e
  1019a4:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd));
  1019ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1019ae:	0f 01 18             	lidtl  (%eax)
	lidt(&idt_pd);
	// My Code ends
}
  1019b1:	c9                   	leave  
  1019b2:	c3                   	ret    

001019b3 <trapname>:

static const char *
trapname(int trapno) {
  1019b3:	55                   	push   %ebp
  1019b4:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  1019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1019b9:	83 f8 13             	cmp    $0x13,%eax
  1019bc:	77 0c                	ja     1019ca <trapname+0x17>
        return excnames[trapno];
  1019be:	8b 45 08             	mov    0x8(%ebp),%eax
  1019c1:	8b 04 85 a0 3c 10 00 	mov    0x103ca0(,%eax,4),%eax
  1019c8:	eb 18                	jmp    1019e2 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1019ca:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1019ce:	7e 0d                	jle    1019dd <trapname+0x2a>
  1019d0:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1019d4:	7f 07                	jg     1019dd <trapname+0x2a>
        return "Hardware Interrupt";
  1019d6:	b8 5f 39 10 00       	mov    $0x10395f,%eax
  1019db:	eb 05                	jmp    1019e2 <trapname+0x2f>
    }
    return "(unknown trap)";
  1019dd:	b8 72 39 10 00       	mov    $0x103972,%eax
}
  1019e2:	5d                   	pop    %ebp
  1019e3:	c3                   	ret    

001019e4 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  1019e4:	55                   	push   %ebp
  1019e5:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1019e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1019ea:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1019ee:	66 83 f8 08          	cmp    $0x8,%ax
  1019f2:	0f 94 c0             	sete   %al
  1019f5:	0f b6 c0             	movzbl %al,%eax
}
  1019f8:	5d                   	pop    %ebp
  1019f9:	c3                   	ret    

001019fa <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  1019fa:	55                   	push   %ebp
  1019fb:	89 e5                	mov    %esp,%ebp
  1019fd:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a00:	8b 45 08             	mov    0x8(%ebp),%eax
  101a03:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a07:	c7 04 24 b3 39 10 00 	movl   $0x1039b3,(%esp)
  101a0e:	e8 0f e9 ff ff       	call   100322 <cprintf>
    print_regs(&tf->tf_regs);
  101a13:	8b 45 08             	mov    0x8(%ebp),%eax
  101a16:	89 04 24             	mov    %eax,(%esp)
  101a19:	e8 a1 01 00 00       	call   101bbf <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  101a21:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a25:	0f b7 c0             	movzwl %ax,%eax
  101a28:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a2c:	c7 04 24 c4 39 10 00 	movl   $0x1039c4,(%esp)
  101a33:	e8 ea e8 ff ff       	call   100322 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a38:	8b 45 08             	mov    0x8(%ebp),%eax
  101a3b:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a3f:	0f b7 c0             	movzwl %ax,%eax
  101a42:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a46:	c7 04 24 d7 39 10 00 	movl   $0x1039d7,(%esp)
  101a4d:	e8 d0 e8 ff ff       	call   100322 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a52:	8b 45 08             	mov    0x8(%ebp),%eax
  101a55:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a59:	0f b7 c0             	movzwl %ax,%eax
  101a5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a60:	c7 04 24 ea 39 10 00 	movl   $0x1039ea,(%esp)
  101a67:	e8 b6 e8 ff ff       	call   100322 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a6f:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a73:	0f b7 c0             	movzwl %ax,%eax
  101a76:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a7a:	c7 04 24 fd 39 10 00 	movl   $0x1039fd,(%esp)
  101a81:	e8 9c e8 ff ff       	call   100322 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a86:	8b 45 08             	mov    0x8(%ebp),%eax
  101a89:	8b 40 30             	mov    0x30(%eax),%eax
  101a8c:	89 04 24             	mov    %eax,(%esp)
  101a8f:	e8 1f ff ff ff       	call   1019b3 <trapname>
  101a94:	8b 55 08             	mov    0x8(%ebp),%edx
  101a97:	8b 52 30             	mov    0x30(%edx),%edx
  101a9a:	89 44 24 08          	mov    %eax,0x8(%esp)
  101a9e:	89 54 24 04          	mov    %edx,0x4(%esp)
  101aa2:	c7 04 24 10 3a 10 00 	movl   $0x103a10,(%esp)
  101aa9:	e8 74 e8 ff ff       	call   100322 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101aae:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab1:	8b 40 34             	mov    0x34(%eax),%eax
  101ab4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ab8:	c7 04 24 22 3a 10 00 	movl   $0x103a22,(%esp)
  101abf:	e8 5e e8 ff ff       	call   100322 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac7:	8b 40 38             	mov    0x38(%eax),%eax
  101aca:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ace:	c7 04 24 31 3a 10 00 	movl   $0x103a31,(%esp)
  101ad5:	e8 48 e8 ff ff       	call   100322 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101ada:	8b 45 08             	mov    0x8(%ebp),%eax
  101add:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ae1:	0f b7 c0             	movzwl %ax,%eax
  101ae4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ae8:	c7 04 24 40 3a 10 00 	movl   $0x103a40,(%esp)
  101aef:	e8 2e e8 ff ff       	call   100322 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101af4:	8b 45 08             	mov    0x8(%ebp),%eax
  101af7:	8b 40 40             	mov    0x40(%eax),%eax
  101afa:	89 44 24 04          	mov    %eax,0x4(%esp)
  101afe:	c7 04 24 53 3a 10 00 	movl   $0x103a53,(%esp)
  101b05:	e8 18 e8 ff ff       	call   100322 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b0a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b11:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b18:	eb 3e                	jmp    101b58 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b1d:	8b 50 40             	mov    0x40(%eax),%edx
  101b20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b23:	21 d0                	and    %edx,%eax
  101b25:	85 c0                	test   %eax,%eax
  101b27:	74 28                	je     101b51 <print_trapframe+0x157>
  101b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b2c:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b33:	85 c0                	test   %eax,%eax
  101b35:	74 1a                	je     101b51 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b3a:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b41:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b45:	c7 04 24 62 3a 10 00 	movl   $0x103a62,(%esp)
  101b4c:	e8 d1 e7 ff ff       	call   100322 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b51:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b55:	d1 65 f0             	shll   -0x10(%ebp)
  101b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b5b:	83 f8 17             	cmp    $0x17,%eax
  101b5e:	76 ba                	jbe    101b1a <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b60:	8b 45 08             	mov    0x8(%ebp),%eax
  101b63:	8b 40 40             	mov    0x40(%eax),%eax
  101b66:	25 00 30 00 00       	and    $0x3000,%eax
  101b6b:	c1 e8 0c             	shr    $0xc,%eax
  101b6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b72:	c7 04 24 66 3a 10 00 	movl   $0x103a66,(%esp)
  101b79:	e8 a4 e7 ff ff       	call   100322 <cprintf>

    if (!trap_in_kernel(tf)) {
  101b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b81:	89 04 24             	mov    %eax,(%esp)
  101b84:	e8 5b fe ff ff       	call   1019e4 <trap_in_kernel>
  101b89:	85 c0                	test   %eax,%eax
  101b8b:	75 30                	jne    101bbd <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  101b90:	8b 40 44             	mov    0x44(%eax),%eax
  101b93:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b97:	c7 04 24 6f 3a 10 00 	movl   $0x103a6f,(%esp)
  101b9e:	e8 7f e7 ff ff       	call   100322 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba6:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101baa:	0f b7 c0             	movzwl %ax,%eax
  101bad:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bb1:	c7 04 24 7e 3a 10 00 	movl   $0x103a7e,(%esp)
  101bb8:	e8 65 e7 ff ff       	call   100322 <cprintf>
    }
}
  101bbd:	c9                   	leave  
  101bbe:	c3                   	ret    

00101bbf <print_regs>:

void
print_regs(struct pushregs *regs) {
  101bbf:	55                   	push   %ebp
  101bc0:	89 e5                	mov    %esp,%ebp
  101bc2:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc8:	8b 00                	mov    (%eax),%eax
  101bca:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bce:	c7 04 24 91 3a 10 00 	movl   $0x103a91,(%esp)
  101bd5:	e8 48 e7 ff ff       	call   100322 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101bda:	8b 45 08             	mov    0x8(%ebp),%eax
  101bdd:	8b 40 04             	mov    0x4(%eax),%eax
  101be0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be4:	c7 04 24 a0 3a 10 00 	movl   $0x103aa0,(%esp)
  101beb:	e8 32 e7 ff ff       	call   100322 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf3:	8b 40 08             	mov    0x8(%eax),%eax
  101bf6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bfa:	c7 04 24 af 3a 10 00 	movl   $0x103aaf,(%esp)
  101c01:	e8 1c e7 ff ff       	call   100322 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c06:	8b 45 08             	mov    0x8(%ebp),%eax
  101c09:	8b 40 0c             	mov    0xc(%eax),%eax
  101c0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c10:	c7 04 24 be 3a 10 00 	movl   $0x103abe,(%esp)
  101c17:	e8 06 e7 ff ff       	call   100322 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1f:	8b 40 10             	mov    0x10(%eax),%eax
  101c22:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c26:	c7 04 24 cd 3a 10 00 	movl   $0x103acd,(%esp)
  101c2d:	e8 f0 e6 ff ff       	call   100322 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c32:	8b 45 08             	mov    0x8(%ebp),%eax
  101c35:	8b 40 14             	mov    0x14(%eax),%eax
  101c38:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c3c:	c7 04 24 dc 3a 10 00 	movl   $0x103adc,(%esp)
  101c43:	e8 da e6 ff ff       	call   100322 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c48:	8b 45 08             	mov    0x8(%ebp),%eax
  101c4b:	8b 40 18             	mov    0x18(%eax),%eax
  101c4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c52:	c7 04 24 eb 3a 10 00 	movl   $0x103aeb,(%esp)
  101c59:	e8 c4 e6 ff ff       	call   100322 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c61:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c64:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c68:	c7 04 24 fa 3a 10 00 	movl   $0x103afa,(%esp)
  101c6f:	e8 ae e6 ff ff       	call   100322 <cprintf>
}
  101c74:	c9                   	leave  
  101c75:	c3                   	ret    

00101c76 <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c76:	55                   	push   %ebp
  101c77:	89 e5                	mov    %esp,%ebp
  101c79:	57                   	push   %edi
  101c7a:	56                   	push   %esi
  101c7b:	53                   	push   %ebx
  101c7c:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
  101c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  101c82:	8b 40 30             	mov    0x30(%eax),%eax
  101c85:	83 f8 2f             	cmp    $0x2f,%eax
  101c88:	77 21                	ja     101cab <trap_dispatch+0x35>
  101c8a:	83 f8 2e             	cmp    $0x2e,%eax
  101c8d:	0f 83 ec 01 00 00    	jae    101e7f <trap_dispatch+0x209>
  101c93:	83 f8 21             	cmp    $0x21,%eax
  101c96:	0f 84 8a 00 00 00    	je     101d26 <trap_dispatch+0xb0>
  101c9c:	83 f8 24             	cmp    $0x24,%eax
  101c9f:	74 5c                	je     101cfd <trap_dispatch+0x87>
  101ca1:	83 f8 20             	cmp    $0x20,%eax
  101ca4:	74 1c                	je     101cc2 <trap_dispatch+0x4c>
  101ca6:	e9 9c 01 00 00       	jmp    101e47 <trap_dispatch+0x1d1>
  101cab:	83 f8 78             	cmp    $0x78,%eax
  101cae:	0f 84 9b 00 00 00    	je     101d4f <trap_dispatch+0xd9>
  101cb4:	83 f8 79             	cmp    $0x79,%eax
  101cb7:	0f 84 11 01 00 00    	je     101dce <trap_dispatch+0x158>
  101cbd:	e9 85 01 00 00       	jmp    101e47 <trap_dispatch+0x1d1>
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
		// My code starts
		ticks++;
  101cc2:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101cc7:	83 c0 01             	add    $0x1,%eax
  101cca:	a3 08 f9 10 00       	mov    %eax,0x10f908
		if (ticks % TICK_NUM == 0) {
  101ccf:	8b 0d 08 f9 10 00    	mov    0x10f908,%ecx
  101cd5:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101cda:	89 c8                	mov    %ecx,%eax
  101cdc:	f7 e2                	mul    %edx
  101cde:	89 d0                	mov    %edx,%eax
  101ce0:	c1 e8 05             	shr    $0x5,%eax
  101ce3:	6b c0 64             	imul   $0x64,%eax,%eax
  101ce6:	29 c1                	sub    %eax,%ecx
  101ce8:	89 c8                	mov    %ecx,%eax
  101cea:	85 c0                	test   %eax,%eax
  101cec:	75 0a                	jne    101cf8 <trap_dispatch+0x82>
			print_ticks();
  101cee:	e8 11 fb ff ff       	call   101804 <print_ticks>
		}
		// My code ends
        break;
  101cf3:	e9 88 01 00 00       	jmp    101e80 <trap_dispatch+0x20a>
  101cf8:	e9 83 01 00 00       	jmp    101e80 <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101cfd:	e8 d9 f8 ff ff       	call   1015db <cons_getc>
  101d02:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d05:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101d09:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101d0d:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d11:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d15:	c7 04 24 09 3b 10 00 	movl   $0x103b09,(%esp)
  101d1c:	e8 01 e6 ff ff       	call   100322 <cprintf>
        break;
  101d21:	e9 5a 01 00 00       	jmp    101e80 <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d26:	e8 b0 f8 ff ff       	call   1015db <cons_getc>
  101d2b:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d2e:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101d32:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101d36:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d3e:	c7 04 24 1b 3b 10 00 	movl   $0x103b1b,(%esp)
  101d45:	e8 d8 e5 ff ff       	call   100322 <cprintf>
        break;
  101d4a:	e9 31 01 00 00       	jmp    101e80 <trap_dispatch+0x20a>
    //LAB1 CHALLENGE 1 : 2013011413 you should modify below codes.
    case T_SWITCH_TOU:
		// 如果当前不是用户态才转换
		if (tf->tf_cs != USER_CS) {
  101d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  101d52:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d56:	66 83 f8 1b          	cmp    $0x1b,%ax
  101d5a:	74 6d                	je     101dc9 <trap_dispatch+0x153>
			// 构造一个新的Trap帧，首先是改变其中的特权级标志
            switchk2u = *tf;
  101d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  101d5f:	ba 20 f9 10 00       	mov    $0x10f920,%edx
  101d64:	89 c3                	mov    %eax,%ebx
  101d66:	b8 13 00 00 00       	mov    $0x13,%eax
  101d6b:	89 d7                	mov    %edx,%edi
  101d6d:	89 de                	mov    %ebx,%esi
  101d6f:	89 c1                	mov    %eax,%ecx
  101d71:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            switchk2u.tf_cs = USER_CS;
  101d73:	66 c7 05 5c f9 10 00 	movw   $0x1b,0x10f95c
  101d7a:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  101d7c:	66 c7 05 68 f9 10 00 	movw   $0x23,0x10f968
  101d83:	23 00 
  101d85:	0f b7 05 68 f9 10 00 	movzwl 0x10f968,%eax
  101d8c:	66 a3 48 f9 10 00    	mov    %ax,0x10f948
  101d92:	0f b7 05 48 f9 10 00 	movzwl 0x10f948,%eax
  101d99:	66 a3 4c f9 10 00    	mov    %ax,0x10f94c
			
			// 返回的栈的基址，就是除开压入的栈的大小的地址。从trap帧向上找即可。
			// 这里减去的8是SS和ESP对应的8字节
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  101da2:	83 c0 44             	add    $0x44,%eax
  101da5:	a3 64 f9 10 00       	mov    %eax,0x10f964
			
            // FL开头的宏是为了更改EFLAGS的标志位存在的。
			// 这里把IO的权限设置为3，即用户态也能输出
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  101daa:	a1 60 f9 10 00       	mov    0x10f960,%eax
  101daf:	80 cc 30             	or     $0x30,%ah
  101db2:	a3 60 f9 10 00       	mov    %eax,0x10f960
			
            // 用构造的假trap帧替换原来的帧
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101db7:	8b 45 08             	mov    0x8(%ebp),%eax
  101dba:	8d 50 fc             	lea    -0x4(%eax),%edx
  101dbd:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  101dc2:	89 02                	mov    %eax,(%edx)
        } 
		break;
  101dc4:	e9 b7 00 00 00       	jmp    101e80 <trap_dispatch+0x20a>
  101dc9:	e9 b2 00 00 00       	jmp    101e80 <trap_dispatch+0x20a>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
  101dce:	8b 45 08             	mov    0x8(%ebp),%eax
  101dd1:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101dd5:	66 83 f8 08          	cmp    $0x8,%ax
  101dd9:	74 6a                	je     101e45 <trap_dispatch+0x1cf>
			// 完全逆向上面的处理
            tf->tf_cs = KERNEL_CS;
  101ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  101dde:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  101de4:	8b 45 08             	mov    0x8(%ebp),%eax
  101de7:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101ded:	8b 45 08             	mov    0x8(%ebp),%eax
  101df0:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101df4:	8b 45 08             	mov    0x8(%ebp),%eax
  101df7:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  101dfe:	8b 40 40             	mov    0x40(%eax),%eax
  101e01:	80 e4 cf             	and    $0xcf,%ah
  101e04:	89 c2                	mov    %eax,%edx
  101e06:	8b 45 08             	mov    0x8(%ebp),%eax
  101e09:	89 50 40             	mov    %edx,0x40(%eax)
			// 这里伪造一个内核态的trap frame，也就是不含ESP和SS这两项
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  101e0f:	8b 40 44             	mov    0x44(%eax),%eax
  101e12:	83 e8 44             	sub    $0x44,%eax
  101e15:	a3 6c f9 10 00       	mov    %eax,0x10f96c
			// 把伪造的值赋过来
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101e1a:	a1 6c f9 10 00       	mov    0x10f96c,%eax
  101e1f:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  101e26:	00 
  101e27:	8b 55 08             	mov    0x8(%ebp),%edx
  101e2a:	89 54 24 04          	mov    %edx,0x4(%esp)
  101e2e:	89 04 24             	mov    %eax,(%esp)
  101e31:	e8 25 16 00 00       	call   10345b <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101e36:	8b 45 08             	mov    0x8(%ebp),%eax
  101e39:	8d 50 fc             	lea    -0x4(%eax),%edx
  101e3c:	a1 6c f9 10 00       	mov    0x10f96c,%eax
  101e41:	89 02                	mov    %eax,(%edx)
        }
        break;
  101e43:	eb 3b                	jmp    101e80 <trap_dispatch+0x20a>
  101e45:	eb 39                	jmp    101e80 <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101e47:	8b 45 08             	mov    0x8(%ebp),%eax
  101e4a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e4e:	0f b7 c0             	movzwl %ax,%eax
  101e51:	83 e0 03             	and    $0x3,%eax
  101e54:	85 c0                	test   %eax,%eax
  101e56:	75 28                	jne    101e80 <trap_dispatch+0x20a>
            print_trapframe(tf);
  101e58:	8b 45 08             	mov    0x8(%ebp),%eax
  101e5b:	89 04 24             	mov    %eax,(%esp)
  101e5e:	e8 97 fb ff ff       	call   1019fa <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101e63:	c7 44 24 08 2a 3b 10 	movl   $0x103b2a,0x8(%esp)
  101e6a:	00 
  101e6b:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
  101e72:	00 
  101e73:	c7 04 24 4e 39 10 00 	movl   $0x10394e,(%esp)
  101e7a:	e8 3e ee ff ff       	call   100cbd <__panic>
        }
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101e7f:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101e80:	83 c4 2c             	add    $0x2c,%esp
  101e83:	5b                   	pop    %ebx
  101e84:	5e                   	pop    %esi
  101e85:	5f                   	pop    %edi
  101e86:	5d                   	pop    %ebp
  101e87:	c3                   	ret    

00101e88 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101e88:	55                   	push   %ebp
  101e89:	89 e5                	mov    %esp,%ebp
  101e8b:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  101e91:	89 04 24             	mov    %eax,(%esp)
  101e94:	e8 dd fd ff ff       	call   101c76 <trap_dispatch>
}
  101e99:	c9                   	leave  
  101e9a:	c3                   	ret    

00101e9b <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101e9b:	1e                   	push   %ds
    pushl %es
  101e9c:	06                   	push   %es
    pushl %fs
  101e9d:	0f a0                	push   %fs
    pushl %gs
  101e9f:	0f a8                	push   %gs
    pushal
  101ea1:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101ea2:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101ea7:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101ea9:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101eab:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101eac:	e8 d7 ff ff ff       	call   101e88 <trap>

    # pop the pushed stack pointer
    popl %esp
  101eb1:	5c                   	pop    %esp

00101eb2 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101eb2:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101eb3:	0f a9                	pop    %gs
    popl %fs
  101eb5:	0f a1                	pop    %fs
    popl %es
  101eb7:	07                   	pop    %es
    popl %ds
  101eb8:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101eb9:	83 c4 08             	add    $0x8,%esp
    iret
  101ebc:	cf                   	iret   

00101ebd <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101ebd:	6a 00                	push   $0x0
  pushl $0
  101ebf:	6a 00                	push   $0x0
  jmp __alltraps
  101ec1:	e9 d5 ff ff ff       	jmp    101e9b <__alltraps>

00101ec6 <vector1>:
.globl vector1
vector1:
  pushl $0
  101ec6:	6a 00                	push   $0x0
  pushl $1
  101ec8:	6a 01                	push   $0x1
  jmp __alltraps
  101eca:	e9 cc ff ff ff       	jmp    101e9b <__alltraps>

00101ecf <vector2>:
.globl vector2
vector2:
  pushl $0
  101ecf:	6a 00                	push   $0x0
  pushl $2
  101ed1:	6a 02                	push   $0x2
  jmp __alltraps
  101ed3:	e9 c3 ff ff ff       	jmp    101e9b <__alltraps>

00101ed8 <vector3>:
.globl vector3
vector3:
  pushl $0
  101ed8:	6a 00                	push   $0x0
  pushl $3
  101eda:	6a 03                	push   $0x3
  jmp __alltraps
  101edc:	e9 ba ff ff ff       	jmp    101e9b <__alltraps>

00101ee1 <vector4>:
.globl vector4
vector4:
  pushl $0
  101ee1:	6a 00                	push   $0x0
  pushl $4
  101ee3:	6a 04                	push   $0x4
  jmp __alltraps
  101ee5:	e9 b1 ff ff ff       	jmp    101e9b <__alltraps>

00101eea <vector5>:
.globl vector5
vector5:
  pushl $0
  101eea:	6a 00                	push   $0x0
  pushl $5
  101eec:	6a 05                	push   $0x5
  jmp __alltraps
  101eee:	e9 a8 ff ff ff       	jmp    101e9b <__alltraps>

00101ef3 <vector6>:
.globl vector6
vector6:
  pushl $0
  101ef3:	6a 00                	push   $0x0
  pushl $6
  101ef5:	6a 06                	push   $0x6
  jmp __alltraps
  101ef7:	e9 9f ff ff ff       	jmp    101e9b <__alltraps>

00101efc <vector7>:
.globl vector7
vector7:
  pushl $0
  101efc:	6a 00                	push   $0x0
  pushl $7
  101efe:	6a 07                	push   $0x7
  jmp __alltraps
  101f00:	e9 96 ff ff ff       	jmp    101e9b <__alltraps>

00101f05 <vector8>:
.globl vector8
vector8:
  pushl $8
  101f05:	6a 08                	push   $0x8
  jmp __alltraps
  101f07:	e9 8f ff ff ff       	jmp    101e9b <__alltraps>

00101f0c <vector9>:
.globl vector9
vector9:
  pushl $9
  101f0c:	6a 09                	push   $0x9
  jmp __alltraps
  101f0e:	e9 88 ff ff ff       	jmp    101e9b <__alltraps>

00101f13 <vector10>:
.globl vector10
vector10:
  pushl $10
  101f13:	6a 0a                	push   $0xa
  jmp __alltraps
  101f15:	e9 81 ff ff ff       	jmp    101e9b <__alltraps>

00101f1a <vector11>:
.globl vector11
vector11:
  pushl $11
  101f1a:	6a 0b                	push   $0xb
  jmp __alltraps
  101f1c:	e9 7a ff ff ff       	jmp    101e9b <__alltraps>

00101f21 <vector12>:
.globl vector12
vector12:
  pushl $12
  101f21:	6a 0c                	push   $0xc
  jmp __alltraps
  101f23:	e9 73 ff ff ff       	jmp    101e9b <__alltraps>

00101f28 <vector13>:
.globl vector13
vector13:
  pushl $13
  101f28:	6a 0d                	push   $0xd
  jmp __alltraps
  101f2a:	e9 6c ff ff ff       	jmp    101e9b <__alltraps>

00101f2f <vector14>:
.globl vector14
vector14:
  pushl $14
  101f2f:	6a 0e                	push   $0xe
  jmp __alltraps
  101f31:	e9 65 ff ff ff       	jmp    101e9b <__alltraps>

00101f36 <vector15>:
.globl vector15
vector15:
  pushl $0
  101f36:	6a 00                	push   $0x0
  pushl $15
  101f38:	6a 0f                	push   $0xf
  jmp __alltraps
  101f3a:	e9 5c ff ff ff       	jmp    101e9b <__alltraps>

00101f3f <vector16>:
.globl vector16
vector16:
  pushl $0
  101f3f:	6a 00                	push   $0x0
  pushl $16
  101f41:	6a 10                	push   $0x10
  jmp __alltraps
  101f43:	e9 53 ff ff ff       	jmp    101e9b <__alltraps>

00101f48 <vector17>:
.globl vector17
vector17:
  pushl $17
  101f48:	6a 11                	push   $0x11
  jmp __alltraps
  101f4a:	e9 4c ff ff ff       	jmp    101e9b <__alltraps>

00101f4f <vector18>:
.globl vector18
vector18:
  pushl $0
  101f4f:	6a 00                	push   $0x0
  pushl $18
  101f51:	6a 12                	push   $0x12
  jmp __alltraps
  101f53:	e9 43 ff ff ff       	jmp    101e9b <__alltraps>

00101f58 <vector19>:
.globl vector19
vector19:
  pushl $0
  101f58:	6a 00                	push   $0x0
  pushl $19
  101f5a:	6a 13                	push   $0x13
  jmp __alltraps
  101f5c:	e9 3a ff ff ff       	jmp    101e9b <__alltraps>

00101f61 <vector20>:
.globl vector20
vector20:
  pushl $0
  101f61:	6a 00                	push   $0x0
  pushl $20
  101f63:	6a 14                	push   $0x14
  jmp __alltraps
  101f65:	e9 31 ff ff ff       	jmp    101e9b <__alltraps>

00101f6a <vector21>:
.globl vector21
vector21:
  pushl $0
  101f6a:	6a 00                	push   $0x0
  pushl $21
  101f6c:	6a 15                	push   $0x15
  jmp __alltraps
  101f6e:	e9 28 ff ff ff       	jmp    101e9b <__alltraps>

00101f73 <vector22>:
.globl vector22
vector22:
  pushl $0
  101f73:	6a 00                	push   $0x0
  pushl $22
  101f75:	6a 16                	push   $0x16
  jmp __alltraps
  101f77:	e9 1f ff ff ff       	jmp    101e9b <__alltraps>

00101f7c <vector23>:
.globl vector23
vector23:
  pushl $0
  101f7c:	6a 00                	push   $0x0
  pushl $23
  101f7e:	6a 17                	push   $0x17
  jmp __alltraps
  101f80:	e9 16 ff ff ff       	jmp    101e9b <__alltraps>

00101f85 <vector24>:
.globl vector24
vector24:
  pushl $0
  101f85:	6a 00                	push   $0x0
  pushl $24
  101f87:	6a 18                	push   $0x18
  jmp __alltraps
  101f89:	e9 0d ff ff ff       	jmp    101e9b <__alltraps>

00101f8e <vector25>:
.globl vector25
vector25:
  pushl $0
  101f8e:	6a 00                	push   $0x0
  pushl $25
  101f90:	6a 19                	push   $0x19
  jmp __alltraps
  101f92:	e9 04 ff ff ff       	jmp    101e9b <__alltraps>

00101f97 <vector26>:
.globl vector26
vector26:
  pushl $0
  101f97:	6a 00                	push   $0x0
  pushl $26
  101f99:	6a 1a                	push   $0x1a
  jmp __alltraps
  101f9b:	e9 fb fe ff ff       	jmp    101e9b <__alltraps>

00101fa0 <vector27>:
.globl vector27
vector27:
  pushl $0
  101fa0:	6a 00                	push   $0x0
  pushl $27
  101fa2:	6a 1b                	push   $0x1b
  jmp __alltraps
  101fa4:	e9 f2 fe ff ff       	jmp    101e9b <__alltraps>

00101fa9 <vector28>:
.globl vector28
vector28:
  pushl $0
  101fa9:	6a 00                	push   $0x0
  pushl $28
  101fab:	6a 1c                	push   $0x1c
  jmp __alltraps
  101fad:	e9 e9 fe ff ff       	jmp    101e9b <__alltraps>

00101fb2 <vector29>:
.globl vector29
vector29:
  pushl $0
  101fb2:	6a 00                	push   $0x0
  pushl $29
  101fb4:	6a 1d                	push   $0x1d
  jmp __alltraps
  101fb6:	e9 e0 fe ff ff       	jmp    101e9b <__alltraps>

00101fbb <vector30>:
.globl vector30
vector30:
  pushl $0
  101fbb:	6a 00                	push   $0x0
  pushl $30
  101fbd:	6a 1e                	push   $0x1e
  jmp __alltraps
  101fbf:	e9 d7 fe ff ff       	jmp    101e9b <__alltraps>

00101fc4 <vector31>:
.globl vector31
vector31:
  pushl $0
  101fc4:	6a 00                	push   $0x0
  pushl $31
  101fc6:	6a 1f                	push   $0x1f
  jmp __alltraps
  101fc8:	e9 ce fe ff ff       	jmp    101e9b <__alltraps>

00101fcd <vector32>:
.globl vector32
vector32:
  pushl $0
  101fcd:	6a 00                	push   $0x0
  pushl $32
  101fcf:	6a 20                	push   $0x20
  jmp __alltraps
  101fd1:	e9 c5 fe ff ff       	jmp    101e9b <__alltraps>

00101fd6 <vector33>:
.globl vector33
vector33:
  pushl $0
  101fd6:	6a 00                	push   $0x0
  pushl $33
  101fd8:	6a 21                	push   $0x21
  jmp __alltraps
  101fda:	e9 bc fe ff ff       	jmp    101e9b <__alltraps>

00101fdf <vector34>:
.globl vector34
vector34:
  pushl $0
  101fdf:	6a 00                	push   $0x0
  pushl $34
  101fe1:	6a 22                	push   $0x22
  jmp __alltraps
  101fe3:	e9 b3 fe ff ff       	jmp    101e9b <__alltraps>

00101fe8 <vector35>:
.globl vector35
vector35:
  pushl $0
  101fe8:	6a 00                	push   $0x0
  pushl $35
  101fea:	6a 23                	push   $0x23
  jmp __alltraps
  101fec:	e9 aa fe ff ff       	jmp    101e9b <__alltraps>

00101ff1 <vector36>:
.globl vector36
vector36:
  pushl $0
  101ff1:	6a 00                	push   $0x0
  pushl $36
  101ff3:	6a 24                	push   $0x24
  jmp __alltraps
  101ff5:	e9 a1 fe ff ff       	jmp    101e9b <__alltraps>

00101ffa <vector37>:
.globl vector37
vector37:
  pushl $0
  101ffa:	6a 00                	push   $0x0
  pushl $37
  101ffc:	6a 25                	push   $0x25
  jmp __alltraps
  101ffe:	e9 98 fe ff ff       	jmp    101e9b <__alltraps>

00102003 <vector38>:
.globl vector38
vector38:
  pushl $0
  102003:	6a 00                	push   $0x0
  pushl $38
  102005:	6a 26                	push   $0x26
  jmp __alltraps
  102007:	e9 8f fe ff ff       	jmp    101e9b <__alltraps>

0010200c <vector39>:
.globl vector39
vector39:
  pushl $0
  10200c:	6a 00                	push   $0x0
  pushl $39
  10200e:	6a 27                	push   $0x27
  jmp __alltraps
  102010:	e9 86 fe ff ff       	jmp    101e9b <__alltraps>

00102015 <vector40>:
.globl vector40
vector40:
  pushl $0
  102015:	6a 00                	push   $0x0
  pushl $40
  102017:	6a 28                	push   $0x28
  jmp __alltraps
  102019:	e9 7d fe ff ff       	jmp    101e9b <__alltraps>

0010201e <vector41>:
.globl vector41
vector41:
  pushl $0
  10201e:	6a 00                	push   $0x0
  pushl $41
  102020:	6a 29                	push   $0x29
  jmp __alltraps
  102022:	e9 74 fe ff ff       	jmp    101e9b <__alltraps>

00102027 <vector42>:
.globl vector42
vector42:
  pushl $0
  102027:	6a 00                	push   $0x0
  pushl $42
  102029:	6a 2a                	push   $0x2a
  jmp __alltraps
  10202b:	e9 6b fe ff ff       	jmp    101e9b <__alltraps>

00102030 <vector43>:
.globl vector43
vector43:
  pushl $0
  102030:	6a 00                	push   $0x0
  pushl $43
  102032:	6a 2b                	push   $0x2b
  jmp __alltraps
  102034:	e9 62 fe ff ff       	jmp    101e9b <__alltraps>

00102039 <vector44>:
.globl vector44
vector44:
  pushl $0
  102039:	6a 00                	push   $0x0
  pushl $44
  10203b:	6a 2c                	push   $0x2c
  jmp __alltraps
  10203d:	e9 59 fe ff ff       	jmp    101e9b <__alltraps>

00102042 <vector45>:
.globl vector45
vector45:
  pushl $0
  102042:	6a 00                	push   $0x0
  pushl $45
  102044:	6a 2d                	push   $0x2d
  jmp __alltraps
  102046:	e9 50 fe ff ff       	jmp    101e9b <__alltraps>

0010204b <vector46>:
.globl vector46
vector46:
  pushl $0
  10204b:	6a 00                	push   $0x0
  pushl $46
  10204d:	6a 2e                	push   $0x2e
  jmp __alltraps
  10204f:	e9 47 fe ff ff       	jmp    101e9b <__alltraps>

00102054 <vector47>:
.globl vector47
vector47:
  pushl $0
  102054:	6a 00                	push   $0x0
  pushl $47
  102056:	6a 2f                	push   $0x2f
  jmp __alltraps
  102058:	e9 3e fe ff ff       	jmp    101e9b <__alltraps>

0010205d <vector48>:
.globl vector48
vector48:
  pushl $0
  10205d:	6a 00                	push   $0x0
  pushl $48
  10205f:	6a 30                	push   $0x30
  jmp __alltraps
  102061:	e9 35 fe ff ff       	jmp    101e9b <__alltraps>

00102066 <vector49>:
.globl vector49
vector49:
  pushl $0
  102066:	6a 00                	push   $0x0
  pushl $49
  102068:	6a 31                	push   $0x31
  jmp __alltraps
  10206a:	e9 2c fe ff ff       	jmp    101e9b <__alltraps>

0010206f <vector50>:
.globl vector50
vector50:
  pushl $0
  10206f:	6a 00                	push   $0x0
  pushl $50
  102071:	6a 32                	push   $0x32
  jmp __alltraps
  102073:	e9 23 fe ff ff       	jmp    101e9b <__alltraps>

00102078 <vector51>:
.globl vector51
vector51:
  pushl $0
  102078:	6a 00                	push   $0x0
  pushl $51
  10207a:	6a 33                	push   $0x33
  jmp __alltraps
  10207c:	e9 1a fe ff ff       	jmp    101e9b <__alltraps>

00102081 <vector52>:
.globl vector52
vector52:
  pushl $0
  102081:	6a 00                	push   $0x0
  pushl $52
  102083:	6a 34                	push   $0x34
  jmp __alltraps
  102085:	e9 11 fe ff ff       	jmp    101e9b <__alltraps>

0010208a <vector53>:
.globl vector53
vector53:
  pushl $0
  10208a:	6a 00                	push   $0x0
  pushl $53
  10208c:	6a 35                	push   $0x35
  jmp __alltraps
  10208e:	e9 08 fe ff ff       	jmp    101e9b <__alltraps>

00102093 <vector54>:
.globl vector54
vector54:
  pushl $0
  102093:	6a 00                	push   $0x0
  pushl $54
  102095:	6a 36                	push   $0x36
  jmp __alltraps
  102097:	e9 ff fd ff ff       	jmp    101e9b <__alltraps>

0010209c <vector55>:
.globl vector55
vector55:
  pushl $0
  10209c:	6a 00                	push   $0x0
  pushl $55
  10209e:	6a 37                	push   $0x37
  jmp __alltraps
  1020a0:	e9 f6 fd ff ff       	jmp    101e9b <__alltraps>

001020a5 <vector56>:
.globl vector56
vector56:
  pushl $0
  1020a5:	6a 00                	push   $0x0
  pushl $56
  1020a7:	6a 38                	push   $0x38
  jmp __alltraps
  1020a9:	e9 ed fd ff ff       	jmp    101e9b <__alltraps>

001020ae <vector57>:
.globl vector57
vector57:
  pushl $0
  1020ae:	6a 00                	push   $0x0
  pushl $57
  1020b0:	6a 39                	push   $0x39
  jmp __alltraps
  1020b2:	e9 e4 fd ff ff       	jmp    101e9b <__alltraps>

001020b7 <vector58>:
.globl vector58
vector58:
  pushl $0
  1020b7:	6a 00                	push   $0x0
  pushl $58
  1020b9:	6a 3a                	push   $0x3a
  jmp __alltraps
  1020bb:	e9 db fd ff ff       	jmp    101e9b <__alltraps>

001020c0 <vector59>:
.globl vector59
vector59:
  pushl $0
  1020c0:	6a 00                	push   $0x0
  pushl $59
  1020c2:	6a 3b                	push   $0x3b
  jmp __alltraps
  1020c4:	e9 d2 fd ff ff       	jmp    101e9b <__alltraps>

001020c9 <vector60>:
.globl vector60
vector60:
  pushl $0
  1020c9:	6a 00                	push   $0x0
  pushl $60
  1020cb:	6a 3c                	push   $0x3c
  jmp __alltraps
  1020cd:	e9 c9 fd ff ff       	jmp    101e9b <__alltraps>

001020d2 <vector61>:
.globl vector61
vector61:
  pushl $0
  1020d2:	6a 00                	push   $0x0
  pushl $61
  1020d4:	6a 3d                	push   $0x3d
  jmp __alltraps
  1020d6:	e9 c0 fd ff ff       	jmp    101e9b <__alltraps>

001020db <vector62>:
.globl vector62
vector62:
  pushl $0
  1020db:	6a 00                	push   $0x0
  pushl $62
  1020dd:	6a 3e                	push   $0x3e
  jmp __alltraps
  1020df:	e9 b7 fd ff ff       	jmp    101e9b <__alltraps>

001020e4 <vector63>:
.globl vector63
vector63:
  pushl $0
  1020e4:	6a 00                	push   $0x0
  pushl $63
  1020e6:	6a 3f                	push   $0x3f
  jmp __alltraps
  1020e8:	e9 ae fd ff ff       	jmp    101e9b <__alltraps>

001020ed <vector64>:
.globl vector64
vector64:
  pushl $0
  1020ed:	6a 00                	push   $0x0
  pushl $64
  1020ef:	6a 40                	push   $0x40
  jmp __alltraps
  1020f1:	e9 a5 fd ff ff       	jmp    101e9b <__alltraps>

001020f6 <vector65>:
.globl vector65
vector65:
  pushl $0
  1020f6:	6a 00                	push   $0x0
  pushl $65
  1020f8:	6a 41                	push   $0x41
  jmp __alltraps
  1020fa:	e9 9c fd ff ff       	jmp    101e9b <__alltraps>

001020ff <vector66>:
.globl vector66
vector66:
  pushl $0
  1020ff:	6a 00                	push   $0x0
  pushl $66
  102101:	6a 42                	push   $0x42
  jmp __alltraps
  102103:	e9 93 fd ff ff       	jmp    101e9b <__alltraps>

00102108 <vector67>:
.globl vector67
vector67:
  pushl $0
  102108:	6a 00                	push   $0x0
  pushl $67
  10210a:	6a 43                	push   $0x43
  jmp __alltraps
  10210c:	e9 8a fd ff ff       	jmp    101e9b <__alltraps>

00102111 <vector68>:
.globl vector68
vector68:
  pushl $0
  102111:	6a 00                	push   $0x0
  pushl $68
  102113:	6a 44                	push   $0x44
  jmp __alltraps
  102115:	e9 81 fd ff ff       	jmp    101e9b <__alltraps>

0010211a <vector69>:
.globl vector69
vector69:
  pushl $0
  10211a:	6a 00                	push   $0x0
  pushl $69
  10211c:	6a 45                	push   $0x45
  jmp __alltraps
  10211e:	e9 78 fd ff ff       	jmp    101e9b <__alltraps>

00102123 <vector70>:
.globl vector70
vector70:
  pushl $0
  102123:	6a 00                	push   $0x0
  pushl $70
  102125:	6a 46                	push   $0x46
  jmp __alltraps
  102127:	e9 6f fd ff ff       	jmp    101e9b <__alltraps>

0010212c <vector71>:
.globl vector71
vector71:
  pushl $0
  10212c:	6a 00                	push   $0x0
  pushl $71
  10212e:	6a 47                	push   $0x47
  jmp __alltraps
  102130:	e9 66 fd ff ff       	jmp    101e9b <__alltraps>

00102135 <vector72>:
.globl vector72
vector72:
  pushl $0
  102135:	6a 00                	push   $0x0
  pushl $72
  102137:	6a 48                	push   $0x48
  jmp __alltraps
  102139:	e9 5d fd ff ff       	jmp    101e9b <__alltraps>

0010213e <vector73>:
.globl vector73
vector73:
  pushl $0
  10213e:	6a 00                	push   $0x0
  pushl $73
  102140:	6a 49                	push   $0x49
  jmp __alltraps
  102142:	e9 54 fd ff ff       	jmp    101e9b <__alltraps>

00102147 <vector74>:
.globl vector74
vector74:
  pushl $0
  102147:	6a 00                	push   $0x0
  pushl $74
  102149:	6a 4a                	push   $0x4a
  jmp __alltraps
  10214b:	e9 4b fd ff ff       	jmp    101e9b <__alltraps>

00102150 <vector75>:
.globl vector75
vector75:
  pushl $0
  102150:	6a 00                	push   $0x0
  pushl $75
  102152:	6a 4b                	push   $0x4b
  jmp __alltraps
  102154:	e9 42 fd ff ff       	jmp    101e9b <__alltraps>

00102159 <vector76>:
.globl vector76
vector76:
  pushl $0
  102159:	6a 00                	push   $0x0
  pushl $76
  10215b:	6a 4c                	push   $0x4c
  jmp __alltraps
  10215d:	e9 39 fd ff ff       	jmp    101e9b <__alltraps>

00102162 <vector77>:
.globl vector77
vector77:
  pushl $0
  102162:	6a 00                	push   $0x0
  pushl $77
  102164:	6a 4d                	push   $0x4d
  jmp __alltraps
  102166:	e9 30 fd ff ff       	jmp    101e9b <__alltraps>

0010216b <vector78>:
.globl vector78
vector78:
  pushl $0
  10216b:	6a 00                	push   $0x0
  pushl $78
  10216d:	6a 4e                	push   $0x4e
  jmp __alltraps
  10216f:	e9 27 fd ff ff       	jmp    101e9b <__alltraps>

00102174 <vector79>:
.globl vector79
vector79:
  pushl $0
  102174:	6a 00                	push   $0x0
  pushl $79
  102176:	6a 4f                	push   $0x4f
  jmp __alltraps
  102178:	e9 1e fd ff ff       	jmp    101e9b <__alltraps>

0010217d <vector80>:
.globl vector80
vector80:
  pushl $0
  10217d:	6a 00                	push   $0x0
  pushl $80
  10217f:	6a 50                	push   $0x50
  jmp __alltraps
  102181:	e9 15 fd ff ff       	jmp    101e9b <__alltraps>

00102186 <vector81>:
.globl vector81
vector81:
  pushl $0
  102186:	6a 00                	push   $0x0
  pushl $81
  102188:	6a 51                	push   $0x51
  jmp __alltraps
  10218a:	e9 0c fd ff ff       	jmp    101e9b <__alltraps>

0010218f <vector82>:
.globl vector82
vector82:
  pushl $0
  10218f:	6a 00                	push   $0x0
  pushl $82
  102191:	6a 52                	push   $0x52
  jmp __alltraps
  102193:	e9 03 fd ff ff       	jmp    101e9b <__alltraps>

00102198 <vector83>:
.globl vector83
vector83:
  pushl $0
  102198:	6a 00                	push   $0x0
  pushl $83
  10219a:	6a 53                	push   $0x53
  jmp __alltraps
  10219c:	e9 fa fc ff ff       	jmp    101e9b <__alltraps>

001021a1 <vector84>:
.globl vector84
vector84:
  pushl $0
  1021a1:	6a 00                	push   $0x0
  pushl $84
  1021a3:	6a 54                	push   $0x54
  jmp __alltraps
  1021a5:	e9 f1 fc ff ff       	jmp    101e9b <__alltraps>

001021aa <vector85>:
.globl vector85
vector85:
  pushl $0
  1021aa:	6a 00                	push   $0x0
  pushl $85
  1021ac:	6a 55                	push   $0x55
  jmp __alltraps
  1021ae:	e9 e8 fc ff ff       	jmp    101e9b <__alltraps>

001021b3 <vector86>:
.globl vector86
vector86:
  pushl $0
  1021b3:	6a 00                	push   $0x0
  pushl $86
  1021b5:	6a 56                	push   $0x56
  jmp __alltraps
  1021b7:	e9 df fc ff ff       	jmp    101e9b <__alltraps>

001021bc <vector87>:
.globl vector87
vector87:
  pushl $0
  1021bc:	6a 00                	push   $0x0
  pushl $87
  1021be:	6a 57                	push   $0x57
  jmp __alltraps
  1021c0:	e9 d6 fc ff ff       	jmp    101e9b <__alltraps>

001021c5 <vector88>:
.globl vector88
vector88:
  pushl $0
  1021c5:	6a 00                	push   $0x0
  pushl $88
  1021c7:	6a 58                	push   $0x58
  jmp __alltraps
  1021c9:	e9 cd fc ff ff       	jmp    101e9b <__alltraps>

001021ce <vector89>:
.globl vector89
vector89:
  pushl $0
  1021ce:	6a 00                	push   $0x0
  pushl $89
  1021d0:	6a 59                	push   $0x59
  jmp __alltraps
  1021d2:	e9 c4 fc ff ff       	jmp    101e9b <__alltraps>

001021d7 <vector90>:
.globl vector90
vector90:
  pushl $0
  1021d7:	6a 00                	push   $0x0
  pushl $90
  1021d9:	6a 5a                	push   $0x5a
  jmp __alltraps
  1021db:	e9 bb fc ff ff       	jmp    101e9b <__alltraps>

001021e0 <vector91>:
.globl vector91
vector91:
  pushl $0
  1021e0:	6a 00                	push   $0x0
  pushl $91
  1021e2:	6a 5b                	push   $0x5b
  jmp __alltraps
  1021e4:	e9 b2 fc ff ff       	jmp    101e9b <__alltraps>

001021e9 <vector92>:
.globl vector92
vector92:
  pushl $0
  1021e9:	6a 00                	push   $0x0
  pushl $92
  1021eb:	6a 5c                	push   $0x5c
  jmp __alltraps
  1021ed:	e9 a9 fc ff ff       	jmp    101e9b <__alltraps>

001021f2 <vector93>:
.globl vector93
vector93:
  pushl $0
  1021f2:	6a 00                	push   $0x0
  pushl $93
  1021f4:	6a 5d                	push   $0x5d
  jmp __alltraps
  1021f6:	e9 a0 fc ff ff       	jmp    101e9b <__alltraps>

001021fb <vector94>:
.globl vector94
vector94:
  pushl $0
  1021fb:	6a 00                	push   $0x0
  pushl $94
  1021fd:	6a 5e                	push   $0x5e
  jmp __alltraps
  1021ff:	e9 97 fc ff ff       	jmp    101e9b <__alltraps>

00102204 <vector95>:
.globl vector95
vector95:
  pushl $0
  102204:	6a 00                	push   $0x0
  pushl $95
  102206:	6a 5f                	push   $0x5f
  jmp __alltraps
  102208:	e9 8e fc ff ff       	jmp    101e9b <__alltraps>

0010220d <vector96>:
.globl vector96
vector96:
  pushl $0
  10220d:	6a 00                	push   $0x0
  pushl $96
  10220f:	6a 60                	push   $0x60
  jmp __alltraps
  102211:	e9 85 fc ff ff       	jmp    101e9b <__alltraps>

00102216 <vector97>:
.globl vector97
vector97:
  pushl $0
  102216:	6a 00                	push   $0x0
  pushl $97
  102218:	6a 61                	push   $0x61
  jmp __alltraps
  10221a:	e9 7c fc ff ff       	jmp    101e9b <__alltraps>

0010221f <vector98>:
.globl vector98
vector98:
  pushl $0
  10221f:	6a 00                	push   $0x0
  pushl $98
  102221:	6a 62                	push   $0x62
  jmp __alltraps
  102223:	e9 73 fc ff ff       	jmp    101e9b <__alltraps>

00102228 <vector99>:
.globl vector99
vector99:
  pushl $0
  102228:	6a 00                	push   $0x0
  pushl $99
  10222a:	6a 63                	push   $0x63
  jmp __alltraps
  10222c:	e9 6a fc ff ff       	jmp    101e9b <__alltraps>

00102231 <vector100>:
.globl vector100
vector100:
  pushl $0
  102231:	6a 00                	push   $0x0
  pushl $100
  102233:	6a 64                	push   $0x64
  jmp __alltraps
  102235:	e9 61 fc ff ff       	jmp    101e9b <__alltraps>

0010223a <vector101>:
.globl vector101
vector101:
  pushl $0
  10223a:	6a 00                	push   $0x0
  pushl $101
  10223c:	6a 65                	push   $0x65
  jmp __alltraps
  10223e:	e9 58 fc ff ff       	jmp    101e9b <__alltraps>

00102243 <vector102>:
.globl vector102
vector102:
  pushl $0
  102243:	6a 00                	push   $0x0
  pushl $102
  102245:	6a 66                	push   $0x66
  jmp __alltraps
  102247:	e9 4f fc ff ff       	jmp    101e9b <__alltraps>

0010224c <vector103>:
.globl vector103
vector103:
  pushl $0
  10224c:	6a 00                	push   $0x0
  pushl $103
  10224e:	6a 67                	push   $0x67
  jmp __alltraps
  102250:	e9 46 fc ff ff       	jmp    101e9b <__alltraps>

00102255 <vector104>:
.globl vector104
vector104:
  pushl $0
  102255:	6a 00                	push   $0x0
  pushl $104
  102257:	6a 68                	push   $0x68
  jmp __alltraps
  102259:	e9 3d fc ff ff       	jmp    101e9b <__alltraps>

0010225e <vector105>:
.globl vector105
vector105:
  pushl $0
  10225e:	6a 00                	push   $0x0
  pushl $105
  102260:	6a 69                	push   $0x69
  jmp __alltraps
  102262:	e9 34 fc ff ff       	jmp    101e9b <__alltraps>

00102267 <vector106>:
.globl vector106
vector106:
  pushl $0
  102267:	6a 00                	push   $0x0
  pushl $106
  102269:	6a 6a                	push   $0x6a
  jmp __alltraps
  10226b:	e9 2b fc ff ff       	jmp    101e9b <__alltraps>

00102270 <vector107>:
.globl vector107
vector107:
  pushl $0
  102270:	6a 00                	push   $0x0
  pushl $107
  102272:	6a 6b                	push   $0x6b
  jmp __alltraps
  102274:	e9 22 fc ff ff       	jmp    101e9b <__alltraps>

00102279 <vector108>:
.globl vector108
vector108:
  pushl $0
  102279:	6a 00                	push   $0x0
  pushl $108
  10227b:	6a 6c                	push   $0x6c
  jmp __alltraps
  10227d:	e9 19 fc ff ff       	jmp    101e9b <__alltraps>

00102282 <vector109>:
.globl vector109
vector109:
  pushl $0
  102282:	6a 00                	push   $0x0
  pushl $109
  102284:	6a 6d                	push   $0x6d
  jmp __alltraps
  102286:	e9 10 fc ff ff       	jmp    101e9b <__alltraps>

0010228b <vector110>:
.globl vector110
vector110:
  pushl $0
  10228b:	6a 00                	push   $0x0
  pushl $110
  10228d:	6a 6e                	push   $0x6e
  jmp __alltraps
  10228f:	e9 07 fc ff ff       	jmp    101e9b <__alltraps>

00102294 <vector111>:
.globl vector111
vector111:
  pushl $0
  102294:	6a 00                	push   $0x0
  pushl $111
  102296:	6a 6f                	push   $0x6f
  jmp __alltraps
  102298:	e9 fe fb ff ff       	jmp    101e9b <__alltraps>

0010229d <vector112>:
.globl vector112
vector112:
  pushl $0
  10229d:	6a 00                	push   $0x0
  pushl $112
  10229f:	6a 70                	push   $0x70
  jmp __alltraps
  1022a1:	e9 f5 fb ff ff       	jmp    101e9b <__alltraps>

001022a6 <vector113>:
.globl vector113
vector113:
  pushl $0
  1022a6:	6a 00                	push   $0x0
  pushl $113
  1022a8:	6a 71                	push   $0x71
  jmp __alltraps
  1022aa:	e9 ec fb ff ff       	jmp    101e9b <__alltraps>

001022af <vector114>:
.globl vector114
vector114:
  pushl $0
  1022af:	6a 00                	push   $0x0
  pushl $114
  1022b1:	6a 72                	push   $0x72
  jmp __alltraps
  1022b3:	e9 e3 fb ff ff       	jmp    101e9b <__alltraps>

001022b8 <vector115>:
.globl vector115
vector115:
  pushl $0
  1022b8:	6a 00                	push   $0x0
  pushl $115
  1022ba:	6a 73                	push   $0x73
  jmp __alltraps
  1022bc:	e9 da fb ff ff       	jmp    101e9b <__alltraps>

001022c1 <vector116>:
.globl vector116
vector116:
  pushl $0
  1022c1:	6a 00                	push   $0x0
  pushl $116
  1022c3:	6a 74                	push   $0x74
  jmp __alltraps
  1022c5:	e9 d1 fb ff ff       	jmp    101e9b <__alltraps>

001022ca <vector117>:
.globl vector117
vector117:
  pushl $0
  1022ca:	6a 00                	push   $0x0
  pushl $117
  1022cc:	6a 75                	push   $0x75
  jmp __alltraps
  1022ce:	e9 c8 fb ff ff       	jmp    101e9b <__alltraps>

001022d3 <vector118>:
.globl vector118
vector118:
  pushl $0
  1022d3:	6a 00                	push   $0x0
  pushl $118
  1022d5:	6a 76                	push   $0x76
  jmp __alltraps
  1022d7:	e9 bf fb ff ff       	jmp    101e9b <__alltraps>

001022dc <vector119>:
.globl vector119
vector119:
  pushl $0
  1022dc:	6a 00                	push   $0x0
  pushl $119
  1022de:	6a 77                	push   $0x77
  jmp __alltraps
  1022e0:	e9 b6 fb ff ff       	jmp    101e9b <__alltraps>

001022e5 <vector120>:
.globl vector120
vector120:
  pushl $0
  1022e5:	6a 00                	push   $0x0
  pushl $120
  1022e7:	6a 78                	push   $0x78
  jmp __alltraps
  1022e9:	e9 ad fb ff ff       	jmp    101e9b <__alltraps>

001022ee <vector121>:
.globl vector121
vector121:
  pushl $0
  1022ee:	6a 00                	push   $0x0
  pushl $121
  1022f0:	6a 79                	push   $0x79
  jmp __alltraps
  1022f2:	e9 a4 fb ff ff       	jmp    101e9b <__alltraps>

001022f7 <vector122>:
.globl vector122
vector122:
  pushl $0
  1022f7:	6a 00                	push   $0x0
  pushl $122
  1022f9:	6a 7a                	push   $0x7a
  jmp __alltraps
  1022fb:	e9 9b fb ff ff       	jmp    101e9b <__alltraps>

00102300 <vector123>:
.globl vector123
vector123:
  pushl $0
  102300:	6a 00                	push   $0x0
  pushl $123
  102302:	6a 7b                	push   $0x7b
  jmp __alltraps
  102304:	e9 92 fb ff ff       	jmp    101e9b <__alltraps>

00102309 <vector124>:
.globl vector124
vector124:
  pushl $0
  102309:	6a 00                	push   $0x0
  pushl $124
  10230b:	6a 7c                	push   $0x7c
  jmp __alltraps
  10230d:	e9 89 fb ff ff       	jmp    101e9b <__alltraps>

00102312 <vector125>:
.globl vector125
vector125:
  pushl $0
  102312:	6a 00                	push   $0x0
  pushl $125
  102314:	6a 7d                	push   $0x7d
  jmp __alltraps
  102316:	e9 80 fb ff ff       	jmp    101e9b <__alltraps>

0010231b <vector126>:
.globl vector126
vector126:
  pushl $0
  10231b:	6a 00                	push   $0x0
  pushl $126
  10231d:	6a 7e                	push   $0x7e
  jmp __alltraps
  10231f:	e9 77 fb ff ff       	jmp    101e9b <__alltraps>

00102324 <vector127>:
.globl vector127
vector127:
  pushl $0
  102324:	6a 00                	push   $0x0
  pushl $127
  102326:	6a 7f                	push   $0x7f
  jmp __alltraps
  102328:	e9 6e fb ff ff       	jmp    101e9b <__alltraps>

0010232d <vector128>:
.globl vector128
vector128:
  pushl $0
  10232d:	6a 00                	push   $0x0
  pushl $128
  10232f:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102334:	e9 62 fb ff ff       	jmp    101e9b <__alltraps>

00102339 <vector129>:
.globl vector129
vector129:
  pushl $0
  102339:	6a 00                	push   $0x0
  pushl $129
  10233b:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102340:	e9 56 fb ff ff       	jmp    101e9b <__alltraps>

00102345 <vector130>:
.globl vector130
vector130:
  pushl $0
  102345:	6a 00                	push   $0x0
  pushl $130
  102347:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10234c:	e9 4a fb ff ff       	jmp    101e9b <__alltraps>

00102351 <vector131>:
.globl vector131
vector131:
  pushl $0
  102351:	6a 00                	push   $0x0
  pushl $131
  102353:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102358:	e9 3e fb ff ff       	jmp    101e9b <__alltraps>

0010235d <vector132>:
.globl vector132
vector132:
  pushl $0
  10235d:	6a 00                	push   $0x0
  pushl $132
  10235f:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102364:	e9 32 fb ff ff       	jmp    101e9b <__alltraps>

00102369 <vector133>:
.globl vector133
vector133:
  pushl $0
  102369:	6a 00                	push   $0x0
  pushl $133
  10236b:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102370:	e9 26 fb ff ff       	jmp    101e9b <__alltraps>

00102375 <vector134>:
.globl vector134
vector134:
  pushl $0
  102375:	6a 00                	push   $0x0
  pushl $134
  102377:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10237c:	e9 1a fb ff ff       	jmp    101e9b <__alltraps>

00102381 <vector135>:
.globl vector135
vector135:
  pushl $0
  102381:	6a 00                	push   $0x0
  pushl $135
  102383:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102388:	e9 0e fb ff ff       	jmp    101e9b <__alltraps>

0010238d <vector136>:
.globl vector136
vector136:
  pushl $0
  10238d:	6a 00                	push   $0x0
  pushl $136
  10238f:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102394:	e9 02 fb ff ff       	jmp    101e9b <__alltraps>

00102399 <vector137>:
.globl vector137
vector137:
  pushl $0
  102399:	6a 00                	push   $0x0
  pushl $137
  10239b:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1023a0:	e9 f6 fa ff ff       	jmp    101e9b <__alltraps>

001023a5 <vector138>:
.globl vector138
vector138:
  pushl $0
  1023a5:	6a 00                	push   $0x0
  pushl $138
  1023a7:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1023ac:	e9 ea fa ff ff       	jmp    101e9b <__alltraps>

001023b1 <vector139>:
.globl vector139
vector139:
  pushl $0
  1023b1:	6a 00                	push   $0x0
  pushl $139
  1023b3:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1023b8:	e9 de fa ff ff       	jmp    101e9b <__alltraps>

001023bd <vector140>:
.globl vector140
vector140:
  pushl $0
  1023bd:	6a 00                	push   $0x0
  pushl $140
  1023bf:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1023c4:	e9 d2 fa ff ff       	jmp    101e9b <__alltraps>

001023c9 <vector141>:
.globl vector141
vector141:
  pushl $0
  1023c9:	6a 00                	push   $0x0
  pushl $141
  1023cb:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1023d0:	e9 c6 fa ff ff       	jmp    101e9b <__alltraps>

001023d5 <vector142>:
.globl vector142
vector142:
  pushl $0
  1023d5:	6a 00                	push   $0x0
  pushl $142
  1023d7:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1023dc:	e9 ba fa ff ff       	jmp    101e9b <__alltraps>

001023e1 <vector143>:
.globl vector143
vector143:
  pushl $0
  1023e1:	6a 00                	push   $0x0
  pushl $143
  1023e3:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1023e8:	e9 ae fa ff ff       	jmp    101e9b <__alltraps>

001023ed <vector144>:
.globl vector144
vector144:
  pushl $0
  1023ed:	6a 00                	push   $0x0
  pushl $144
  1023ef:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1023f4:	e9 a2 fa ff ff       	jmp    101e9b <__alltraps>

001023f9 <vector145>:
.globl vector145
vector145:
  pushl $0
  1023f9:	6a 00                	push   $0x0
  pushl $145
  1023fb:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102400:	e9 96 fa ff ff       	jmp    101e9b <__alltraps>

00102405 <vector146>:
.globl vector146
vector146:
  pushl $0
  102405:	6a 00                	push   $0x0
  pushl $146
  102407:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10240c:	e9 8a fa ff ff       	jmp    101e9b <__alltraps>

00102411 <vector147>:
.globl vector147
vector147:
  pushl $0
  102411:	6a 00                	push   $0x0
  pushl $147
  102413:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102418:	e9 7e fa ff ff       	jmp    101e9b <__alltraps>

0010241d <vector148>:
.globl vector148
vector148:
  pushl $0
  10241d:	6a 00                	push   $0x0
  pushl $148
  10241f:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102424:	e9 72 fa ff ff       	jmp    101e9b <__alltraps>

00102429 <vector149>:
.globl vector149
vector149:
  pushl $0
  102429:	6a 00                	push   $0x0
  pushl $149
  10242b:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102430:	e9 66 fa ff ff       	jmp    101e9b <__alltraps>

00102435 <vector150>:
.globl vector150
vector150:
  pushl $0
  102435:	6a 00                	push   $0x0
  pushl $150
  102437:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10243c:	e9 5a fa ff ff       	jmp    101e9b <__alltraps>

00102441 <vector151>:
.globl vector151
vector151:
  pushl $0
  102441:	6a 00                	push   $0x0
  pushl $151
  102443:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102448:	e9 4e fa ff ff       	jmp    101e9b <__alltraps>

0010244d <vector152>:
.globl vector152
vector152:
  pushl $0
  10244d:	6a 00                	push   $0x0
  pushl $152
  10244f:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102454:	e9 42 fa ff ff       	jmp    101e9b <__alltraps>

00102459 <vector153>:
.globl vector153
vector153:
  pushl $0
  102459:	6a 00                	push   $0x0
  pushl $153
  10245b:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102460:	e9 36 fa ff ff       	jmp    101e9b <__alltraps>

00102465 <vector154>:
.globl vector154
vector154:
  pushl $0
  102465:	6a 00                	push   $0x0
  pushl $154
  102467:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10246c:	e9 2a fa ff ff       	jmp    101e9b <__alltraps>

00102471 <vector155>:
.globl vector155
vector155:
  pushl $0
  102471:	6a 00                	push   $0x0
  pushl $155
  102473:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102478:	e9 1e fa ff ff       	jmp    101e9b <__alltraps>

0010247d <vector156>:
.globl vector156
vector156:
  pushl $0
  10247d:	6a 00                	push   $0x0
  pushl $156
  10247f:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102484:	e9 12 fa ff ff       	jmp    101e9b <__alltraps>

00102489 <vector157>:
.globl vector157
vector157:
  pushl $0
  102489:	6a 00                	push   $0x0
  pushl $157
  10248b:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102490:	e9 06 fa ff ff       	jmp    101e9b <__alltraps>

00102495 <vector158>:
.globl vector158
vector158:
  pushl $0
  102495:	6a 00                	push   $0x0
  pushl $158
  102497:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10249c:	e9 fa f9 ff ff       	jmp    101e9b <__alltraps>

001024a1 <vector159>:
.globl vector159
vector159:
  pushl $0
  1024a1:	6a 00                	push   $0x0
  pushl $159
  1024a3:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1024a8:	e9 ee f9 ff ff       	jmp    101e9b <__alltraps>

001024ad <vector160>:
.globl vector160
vector160:
  pushl $0
  1024ad:	6a 00                	push   $0x0
  pushl $160
  1024af:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1024b4:	e9 e2 f9 ff ff       	jmp    101e9b <__alltraps>

001024b9 <vector161>:
.globl vector161
vector161:
  pushl $0
  1024b9:	6a 00                	push   $0x0
  pushl $161
  1024bb:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1024c0:	e9 d6 f9 ff ff       	jmp    101e9b <__alltraps>

001024c5 <vector162>:
.globl vector162
vector162:
  pushl $0
  1024c5:	6a 00                	push   $0x0
  pushl $162
  1024c7:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1024cc:	e9 ca f9 ff ff       	jmp    101e9b <__alltraps>

001024d1 <vector163>:
.globl vector163
vector163:
  pushl $0
  1024d1:	6a 00                	push   $0x0
  pushl $163
  1024d3:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1024d8:	e9 be f9 ff ff       	jmp    101e9b <__alltraps>

001024dd <vector164>:
.globl vector164
vector164:
  pushl $0
  1024dd:	6a 00                	push   $0x0
  pushl $164
  1024df:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1024e4:	e9 b2 f9 ff ff       	jmp    101e9b <__alltraps>

001024e9 <vector165>:
.globl vector165
vector165:
  pushl $0
  1024e9:	6a 00                	push   $0x0
  pushl $165
  1024eb:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1024f0:	e9 a6 f9 ff ff       	jmp    101e9b <__alltraps>

001024f5 <vector166>:
.globl vector166
vector166:
  pushl $0
  1024f5:	6a 00                	push   $0x0
  pushl $166
  1024f7:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1024fc:	e9 9a f9 ff ff       	jmp    101e9b <__alltraps>

00102501 <vector167>:
.globl vector167
vector167:
  pushl $0
  102501:	6a 00                	push   $0x0
  pushl $167
  102503:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102508:	e9 8e f9 ff ff       	jmp    101e9b <__alltraps>

0010250d <vector168>:
.globl vector168
vector168:
  pushl $0
  10250d:	6a 00                	push   $0x0
  pushl $168
  10250f:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102514:	e9 82 f9 ff ff       	jmp    101e9b <__alltraps>

00102519 <vector169>:
.globl vector169
vector169:
  pushl $0
  102519:	6a 00                	push   $0x0
  pushl $169
  10251b:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102520:	e9 76 f9 ff ff       	jmp    101e9b <__alltraps>

00102525 <vector170>:
.globl vector170
vector170:
  pushl $0
  102525:	6a 00                	push   $0x0
  pushl $170
  102527:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10252c:	e9 6a f9 ff ff       	jmp    101e9b <__alltraps>

00102531 <vector171>:
.globl vector171
vector171:
  pushl $0
  102531:	6a 00                	push   $0x0
  pushl $171
  102533:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102538:	e9 5e f9 ff ff       	jmp    101e9b <__alltraps>

0010253d <vector172>:
.globl vector172
vector172:
  pushl $0
  10253d:	6a 00                	push   $0x0
  pushl $172
  10253f:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102544:	e9 52 f9 ff ff       	jmp    101e9b <__alltraps>

00102549 <vector173>:
.globl vector173
vector173:
  pushl $0
  102549:	6a 00                	push   $0x0
  pushl $173
  10254b:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102550:	e9 46 f9 ff ff       	jmp    101e9b <__alltraps>

00102555 <vector174>:
.globl vector174
vector174:
  pushl $0
  102555:	6a 00                	push   $0x0
  pushl $174
  102557:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10255c:	e9 3a f9 ff ff       	jmp    101e9b <__alltraps>

00102561 <vector175>:
.globl vector175
vector175:
  pushl $0
  102561:	6a 00                	push   $0x0
  pushl $175
  102563:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102568:	e9 2e f9 ff ff       	jmp    101e9b <__alltraps>

0010256d <vector176>:
.globl vector176
vector176:
  pushl $0
  10256d:	6a 00                	push   $0x0
  pushl $176
  10256f:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102574:	e9 22 f9 ff ff       	jmp    101e9b <__alltraps>

00102579 <vector177>:
.globl vector177
vector177:
  pushl $0
  102579:	6a 00                	push   $0x0
  pushl $177
  10257b:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102580:	e9 16 f9 ff ff       	jmp    101e9b <__alltraps>

00102585 <vector178>:
.globl vector178
vector178:
  pushl $0
  102585:	6a 00                	push   $0x0
  pushl $178
  102587:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10258c:	e9 0a f9 ff ff       	jmp    101e9b <__alltraps>

00102591 <vector179>:
.globl vector179
vector179:
  pushl $0
  102591:	6a 00                	push   $0x0
  pushl $179
  102593:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102598:	e9 fe f8 ff ff       	jmp    101e9b <__alltraps>

0010259d <vector180>:
.globl vector180
vector180:
  pushl $0
  10259d:	6a 00                	push   $0x0
  pushl $180
  10259f:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1025a4:	e9 f2 f8 ff ff       	jmp    101e9b <__alltraps>

001025a9 <vector181>:
.globl vector181
vector181:
  pushl $0
  1025a9:	6a 00                	push   $0x0
  pushl $181
  1025ab:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1025b0:	e9 e6 f8 ff ff       	jmp    101e9b <__alltraps>

001025b5 <vector182>:
.globl vector182
vector182:
  pushl $0
  1025b5:	6a 00                	push   $0x0
  pushl $182
  1025b7:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1025bc:	e9 da f8 ff ff       	jmp    101e9b <__alltraps>

001025c1 <vector183>:
.globl vector183
vector183:
  pushl $0
  1025c1:	6a 00                	push   $0x0
  pushl $183
  1025c3:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1025c8:	e9 ce f8 ff ff       	jmp    101e9b <__alltraps>

001025cd <vector184>:
.globl vector184
vector184:
  pushl $0
  1025cd:	6a 00                	push   $0x0
  pushl $184
  1025cf:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1025d4:	e9 c2 f8 ff ff       	jmp    101e9b <__alltraps>

001025d9 <vector185>:
.globl vector185
vector185:
  pushl $0
  1025d9:	6a 00                	push   $0x0
  pushl $185
  1025db:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1025e0:	e9 b6 f8 ff ff       	jmp    101e9b <__alltraps>

001025e5 <vector186>:
.globl vector186
vector186:
  pushl $0
  1025e5:	6a 00                	push   $0x0
  pushl $186
  1025e7:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1025ec:	e9 aa f8 ff ff       	jmp    101e9b <__alltraps>

001025f1 <vector187>:
.globl vector187
vector187:
  pushl $0
  1025f1:	6a 00                	push   $0x0
  pushl $187
  1025f3:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1025f8:	e9 9e f8 ff ff       	jmp    101e9b <__alltraps>

001025fd <vector188>:
.globl vector188
vector188:
  pushl $0
  1025fd:	6a 00                	push   $0x0
  pushl $188
  1025ff:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102604:	e9 92 f8 ff ff       	jmp    101e9b <__alltraps>

00102609 <vector189>:
.globl vector189
vector189:
  pushl $0
  102609:	6a 00                	push   $0x0
  pushl $189
  10260b:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102610:	e9 86 f8 ff ff       	jmp    101e9b <__alltraps>

00102615 <vector190>:
.globl vector190
vector190:
  pushl $0
  102615:	6a 00                	push   $0x0
  pushl $190
  102617:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10261c:	e9 7a f8 ff ff       	jmp    101e9b <__alltraps>

00102621 <vector191>:
.globl vector191
vector191:
  pushl $0
  102621:	6a 00                	push   $0x0
  pushl $191
  102623:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102628:	e9 6e f8 ff ff       	jmp    101e9b <__alltraps>

0010262d <vector192>:
.globl vector192
vector192:
  pushl $0
  10262d:	6a 00                	push   $0x0
  pushl $192
  10262f:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102634:	e9 62 f8 ff ff       	jmp    101e9b <__alltraps>

00102639 <vector193>:
.globl vector193
vector193:
  pushl $0
  102639:	6a 00                	push   $0x0
  pushl $193
  10263b:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102640:	e9 56 f8 ff ff       	jmp    101e9b <__alltraps>

00102645 <vector194>:
.globl vector194
vector194:
  pushl $0
  102645:	6a 00                	push   $0x0
  pushl $194
  102647:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10264c:	e9 4a f8 ff ff       	jmp    101e9b <__alltraps>

00102651 <vector195>:
.globl vector195
vector195:
  pushl $0
  102651:	6a 00                	push   $0x0
  pushl $195
  102653:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102658:	e9 3e f8 ff ff       	jmp    101e9b <__alltraps>

0010265d <vector196>:
.globl vector196
vector196:
  pushl $0
  10265d:	6a 00                	push   $0x0
  pushl $196
  10265f:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102664:	e9 32 f8 ff ff       	jmp    101e9b <__alltraps>

00102669 <vector197>:
.globl vector197
vector197:
  pushl $0
  102669:	6a 00                	push   $0x0
  pushl $197
  10266b:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102670:	e9 26 f8 ff ff       	jmp    101e9b <__alltraps>

00102675 <vector198>:
.globl vector198
vector198:
  pushl $0
  102675:	6a 00                	push   $0x0
  pushl $198
  102677:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10267c:	e9 1a f8 ff ff       	jmp    101e9b <__alltraps>

00102681 <vector199>:
.globl vector199
vector199:
  pushl $0
  102681:	6a 00                	push   $0x0
  pushl $199
  102683:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102688:	e9 0e f8 ff ff       	jmp    101e9b <__alltraps>

0010268d <vector200>:
.globl vector200
vector200:
  pushl $0
  10268d:	6a 00                	push   $0x0
  pushl $200
  10268f:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102694:	e9 02 f8 ff ff       	jmp    101e9b <__alltraps>

00102699 <vector201>:
.globl vector201
vector201:
  pushl $0
  102699:	6a 00                	push   $0x0
  pushl $201
  10269b:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1026a0:	e9 f6 f7 ff ff       	jmp    101e9b <__alltraps>

001026a5 <vector202>:
.globl vector202
vector202:
  pushl $0
  1026a5:	6a 00                	push   $0x0
  pushl $202
  1026a7:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1026ac:	e9 ea f7 ff ff       	jmp    101e9b <__alltraps>

001026b1 <vector203>:
.globl vector203
vector203:
  pushl $0
  1026b1:	6a 00                	push   $0x0
  pushl $203
  1026b3:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1026b8:	e9 de f7 ff ff       	jmp    101e9b <__alltraps>

001026bd <vector204>:
.globl vector204
vector204:
  pushl $0
  1026bd:	6a 00                	push   $0x0
  pushl $204
  1026bf:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1026c4:	e9 d2 f7 ff ff       	jmp    101e9b <__alltraps>

001026c9 <vector205>:
.globl vector205
vector205:
  pushl $0
  1026c9:	6a 00                	push   $0x0
  pushl $205
  1026cb:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1026d0:	e9 c6 f7 ff ff       	jmp    101e9b <__alltraps>

001026d5 <vector206>:
.globl vector206
vector206:
  pushl $0
  1026d5:	6a 00                	push   $0x0
  pushl $206
  1026d7:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1026dc:	e9 ba f7 ff ff       	jmp    101e9b <__alltraps>

001026e1 <vector207>:
.globl vector207
vector207:
  pushl $0
  1026e1:	6a 00                	push   $0x0
  pushl $207
  1026e3:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1026e8:	e9 ae f7 ff ff       	jmp    101e9b <__alltraps>

001026ed <vector208>:
.globl vector208
vector208:
  pushl $0
  1026ed:	6a 00                	push   $0x0
  pushl $208
  1026ef:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1026f4:	e9 a2 f7 ff ff       	jmp    101e9b <__alltraps>

001026f9 <vector209>:
.globl vector209
vector209:
  pushl $0
  1026f9:	6a 00                	push   $0x0
  pushl $209
  1026fb:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102700:	e9 96 f7 ff ff       	jmp    101e9b <__alltraps>

00102705 <vector210>:
.globl vector210
vector210:
  pushl $0
  102705:	6a 00                	push   $0x0
  pushl $210
  102707:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10270c:	e9 8a f7 ff ff       	jmp    101e9b <__alltraps>

00102711 <vector211>:
.globl vector211
vector211:
  pushl $0
  102711:	6a 00                	push   $0x0
  pushl $211
  102713:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102718:	e9 7e f7 ff ff       	jmp    101e9b <__alltraps>

0010271d <vector212>:
.globl vector212
vector212:
  pushl $0
  10271d:	6a 00                	push   $0x0
  pushl $212
  10271f:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102724:	e9 72 f7 ff ff       	jmp    101e9b <__alltraps>

00102729 <vector213>:
.globl vector213
vector213:
  pushl $0
  102729:	6a 00                	push   $0x0
  pushl $213
  10272b:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102730:	e9 66 f7 ff ff       	jmp    101e9b <__alltraps>

00102735 <vector214>:
.globl vector214
vector214:
  pushl $0
  102735:	6a 00                	push   $0x0
  pushl $214
  102737:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10273c:	e9 5a f7 ff ff       	jmp    101e9b <__alltraps>

00102741 <vector215>:
.globl vector215
vector215:
  pushl $0
  102741:	6a 00                	push   $0x0
  pushl $215
  102743:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102748:	e9 4e f7 ff ff       	jmp    101e9b <__alltraps>

0010274d <vector216>:
.globl vector216
vector216:
  pushl $0
  10274d:	6a 00                	push   $0x0
  pushl $216
  10274f:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102754:	e9 42 f7 ff ff       	jmp    101e9b <__alltraps>

00102759 <vector217>:
.globl vector217
vector217:
  pushl $0
  102759:	6a 00                	push   $0x0
  pushl $217
  10275b:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102760:	e9 36 f7 ff ff       	jmp    101e9b <__alltraps>

00102765 <vector218>:
.globl vector218
vector218:
  pushl $0
  102765:	6a 00                	push   $0x0
  pushl $218
  102767:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10276c:	e9 2a f7 ff ff       	jmp    101e9b <__alltraps>

00102771 <vector219>:
.globl vector219
vector219:
  pushl $0
  102771:	6a 00                	push   $0x0
  pushl $219
  102773:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102778:	e9 1e f7 ff ff       	jmp    101e9b <__alltraps>

0010277d <vector220>:
.globl vector220
vector220:
  pushl $0
  10277d:	6a 00                	push   $0x0
  pushl $220
  10277f:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102784:	e9 12 f7 ff ff       	jmp    101e9b <__alltraps>

00102789 <vector221>:
.globl vector221
vector221:
  pushl $0
  102789:	6a 00                	push   $0x0
  pushl $221
  10278b:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102790:	e9 06 f7 ff ff       	jmp    101e9b <__alltraps>

00102795 <vector222>:
.globl vector222
vector222:
  pushl $0
  102795:	6a 00                	push   $0x0
  pushl $222
  102797:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10279c:	e9 fa f6 ff ff       	jmp    101e9b <__alltraps>

001027a1 <vector223>:
.globl vector223
vector223:
  pushl $0
  1027a1:	6a 00                	push   $0x0
  pushl $223
  1027a3:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1027a8:	e9 ee f6 ff ff       	jmp    101e9b <__alltraps>

001027ad <vector224>:
.globl vector224
vector224:
  pushl $0
  1027ad:	6a 00                	push   $0x0
  pushl $224
  1027af:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1027b4:	e9 e2 f6 ff ff       	jmp    101e9b <__alltraps>

001027b9 <vector225>:
.globl vector225
vector225:
  pushl $0
  1027b9:	6a 00                	push   $0x0
  pushl $225
  1027bb:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1027c0:	e9 d6 f6 ff ff       	jmp    101e9b <__alltraps>

001027c5 <vector226>:
.globl vector226
vector226:
  pushl $0
  1027c5:	6a 00                	push   $0x0
  pushl $226
  1027c7:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1027cc:	e9 ca f6 ff ff       	jmp    101e9b <__alltraps>

001027d1 <vector227>:
.globl vector227
vector227:
  pushl $0
  1027d1:	6a 00                	push   $0x0
  pushl $227
  1027d3:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1027d8:	e9 be f6 ff ff       	jmp    101e9b <__alltraps>

001027dd <vector228>:
.globl vector228
vector228:
  pushl $0
  1027dd:	6a 00                	push   $0x0
  pushl $228
  1027df:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1027e4:	e9 b2 f6 ff ff       	jmp    101e9b <__alltraps>

001027e9 <vector229>:
.globl vector229
vector229:
  pushl $0
  1027e9:	6a 00                	push   $0x0
  pushl $229
  1027eb:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1027f0:	e9 a6 f6 ff ff       	jmp    101e9b <__alltraps>

001027f5 <vector230>:
.globl vector230
vector230:
  pushl $0
  1027f5:	6a 00                	push   $0x0
  pushl $230
  1027f7:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1027fc:	e9 9a f6 ff ff       	jmp    101e9b <__alltraps>

00102801 <vector231>:
.globl vector231
vector231:
  pushl $0
  102801:	6a 00                	push   $0x0
  pushl $231
  102803:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102808:	e9 8e f6 ff ff       	jmp    101e9b <__alltraps>

0010280d <vector232>:
.globl vector232
vector232:
  pushl $0
  10280d:	6a 00                	push   $0x0
  pushl $232
  10280f:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102814:	e9 82 f6 ff ff       	jmp    101e9b <__alltraps>

00102819 <vector233>:
.globl vector233
vector233:
  pushl $0
  102819:	6a 00                	push   $0x0
  pushl $233
  10281b:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102820:	e9 76 f6 ff ff       	jmp    101e9b <__alltraps>

00102825 <vector234>:
.globl vector234
vector234:
  pushl $0
  102825:	6a 00                	push   $0x0
  pushl $234
  102827:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10282c:	e9 6a f6 ff ff       	jmp    101e9b <__alltraps>

00102831 <vector235>:
.globl vector235
vector235:
  pushl $0
  102831:	6a 00                	push   $0x0
  pushl $235
  102833:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102838:	e9 5e f6 ff ff       	jmp    101e9b <__alltraps>

0010283d <vector236>:
.globl vector236
vector236:
  pushl $0
  10283d:	6a 00                	push   $0x0
  pushl $236
  10283f:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102844:	e9 52 f6 ff ff       	jmp    101e9b <__alltraps>

00102849 <vector237>:
.globl vector237
vector237:
  pushl $0
  102849:	6a 00                	push   $0x0
  pushl $237
  10284b:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102850:	e9 46 f6 ff ff       	jmp    101e9b <__alltraps>

00102855 <vector238>:
.globl vector238
vector238:
  pushl $0
  102855:	6a 00                	push   $0x0
  pushl $238
  102857:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10285c:	e9 3a f6 ff ff       	jmp    101e9b <__alltraps>

00102861 <vector239>:
.globl vector239
vector239:
  pushl $0
  102861:	6a 00                	push   $0x0
  pushl $239
  102863:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102868:	e9 2e f6 ff ff       	jmp    101e9b <__alltraps>

0010286d <vector240>:
.globl vector240
vector240:
  pushl $0
  10286d:	6a 00                	push   $0x0
  pushl $240
  10286f:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102874:	e9 22 f6 ff ff       	jmp    101e9b <__alltraps>

00102879 <vector241>:
.globl vector241
vector241:
  pushl $0
  102879:	6a 00                	push   $0x0
  pushl $241
  10287b:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102880:	e9 16 f6 ff ff       	jmp    101e9b <__alltraps>

00102885 <vector242>:
.globl vector242
vector242:
  pushl $0
  102885:	6a 00                	push   $0x0
  pushl $242
  102887:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  10288c:	e9 0a f6 ff ff       	jmp    101e9b <__alltraps>

00102891 <vector243>:
.globl vector243
vector243:
  pushl $0
  102891:	6a 00                	push   $0x0
  pushl $243
  102893:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102898:	e9 fe f5 ff ff       	jmp    101e9b <__alltraps>

0010289d <vector244>:
.globl vector244
vector244:
  pushl $0
  10289d:	6a 00                	push   $0x0
  pushl $244
  10289f:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1028a4:	e9 f2 f5 ff ff       	jmp    101e9b <__alltraps>

001028a9 <vector245>:
.globl vector245
vector245:
  pushl $0
  1028a9:	6a 00                	push   $0x0
  pushl $245
  1028ab:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1028b0:	e9 e6 f5 ff ff       	jmp    101e9b <__alltraps>

001028b5 <vector246>:
.globl vector246
vector246:
  pushl $0
  1028b5:	6a 00                	push   $0x0
  pushl $246
  1028b7:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1028bc:	e9 da f5 ff ff       	jmp    101e9b <__alltraps>

001028c1 <vector247>:
.globl vector247
vector247:
  pushl $0
  1028c1:	6a 00                	push   $0x0
  pushl $247
  1028c3:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1028c8:	e9 ce f5 ff ff       	jmp    101e9b <__alltraps>

001028cd <vector248>:
.globl vector248
vector248:
  pushl $0
  1028cd:	6a 00                	push   $0x0
  pushl $248
  1028cf:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1028d4:	e9 c2 f5 ff ff       	jmp    101e9b <__alltraps>

001028d9 <vector249>:
.globl vector249
vector249:
  pushl $0
  1028d9:	6a 00                	push   $0x0
  pushl $249
  1028db:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1028e0:	e9 b6 f5 ff ff       	jmp    101e9b <__alltraps>

001028e5 <vector250>:
.globl vector250
vector250:
  pushl $0
  1028e5:	6a 00                	push   $0x0
  pushl $250
  1028e7:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1028ec:	e9 aa f5 ff ff       	jmp    101e9b <__alltraps>

001028f1 <vector251>:
.globl vector251
vector251:
  pushl $0
  1028f1:	6a 00                	push   $0x0
  pushl $251
  1028f3:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1028f8:	e9 9e f5 ff ff       	jmp    101e9b <__alltraps>

001028fd <vector252>:
.globl vector252
vector252:
  pushl $0
  1028fd:	6a 00                	push   $0x0
  pushl $252
  1028ff:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102904:	e9 92 f5 ff ff       	jmp    101e9b <__alltraps>

00102909 <vector253>:
.globl vector253
vector253:
  pushl $0
  102909:	6a 00                	push   $0x0
  pushl $253
  10290b:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102910:	e9 86 f5 ff ff       	jmp    101e9b <__alltraps>

00102915 <vector254>:
.globl vector254
vector254:
  pushl $0
  102915:	6a 00                	push   $0x0
  pushl $254
  102917:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  10291c:	e9 7a f5 ff ff       	jmp    101e9b <__alltraps>

00102921 <vector255>:
.globl vector255
vector255:
  pushl $0
  102921:	6a 00                	push   $0x0
  pushl $255
  102923:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102928:	e9 6e f5 ff ff       	jmp    101e9b <__alltraps>

0010292d <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  10292d:	55                   	push   %ebp
  10292e:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102930:	8b 45 08             	mov    0x8(%ebp),%eax
  102933:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102936:	b8 23 00 00 00       	mov    $0x23,%eax
  10293b:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  10293d:	b8 23 00 00 00       	mov    $0x23,%eax
  102942:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102944:	b8 10 00 00 00       	mov    $0x10,%eax
  102949:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  10294b:	b8 10 00 00 00       	mov    $0x10,%eax
  102950:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102952:	b8 10 00 00 00       	mov    $0x10,%eax
  102957:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102959:	ea 60 29 10 00 08 00 	ljmp   $0x8,$0x102960
}
  102960:	5d                   	pop    %ebp
  102961:	c3                   	ret    

00102962 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102962:	55                   	push   %ebp
  102963:	89 e5                	mov    %esp,%ebp
  102965:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102968:	b8 80 f9 10 00       	mov    $0x10f980,%eax
  10296d:	05 00 04 00 00       	add    $0x400,%eax
  102972:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  102977:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  10297e:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102980:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  102987:	68 00 
  102989:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  10298e:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  102994:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102999:	c1 e8 10             	shr    $0x10,%eax
  10299c:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  1029a1:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029a8:	83 e0 f0             	and    $0xfffffff0,%eax
  1029ab:	83 c8 09             	or     $0x9,%eax
  1029ae:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029b3:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029ba:	83 c8 10             	or     $0x10,%eax
  1029bd:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029c2:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029c9:	83 e0 9f             	and    $0xffffff9f,%eax
  1029cc:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029d1:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029d8:	83 c8 80             	or     $0xffffff80,%eax
  1029db:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029e0:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1029e7:	83 e0 f0             	and    $0xfffffff0,%eax
  1029ea:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1029ef:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1029f6:	83 e0 ef             	and    $0xffffffef,%eax
  1029f9:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1029fe:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a05:	83 e0 df             	and    $0xffffffdf,%eax
  102a08:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a0d:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a14:	83 c8 40             	or     $0x40,%eax
  102a17:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a1c:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a23:	83 e0 7f             	and    $0x7f,%eax
  102a26:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a2b:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102a30:	c1 e8 18             	shr    $0x18,%eax
  102a33:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  102a38:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a3f:	83 e0 ef             	and    $0xffffffef,%eax
  102a42:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102a47:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  102a4e:	e8 da fe ff ff       	call   10292d <lgdt>
  102a53:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102a59:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102a5d:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102a60:	c9                   	leave  
  102a61:	c3                   	ret    

00102a62 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102a62:	55                   	push   %ebp
  102a63:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102a65:	e8 f8 fe ff ff       	call   102962 <gdt_init>
}
  102a6a:	5d                   	pop    %ebp
  102a6b:	c3                   	ret    

00102a6c <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102a6c:	55                   	push   %ebp
  102a6d:	89 e5                	mov    %esp,%ebp
  102a6f:	83 ec 58             	sub    $0x58,%esp
  102a72:	8b 45 10             	mov    0x10(%ebp),%eax
  102a75:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102a78:	8b 45 14             	mov    0x14(%ebp),%eax
  102a7b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102a7e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102a81:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102a84:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102a87:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102a8a:	8b 45 18             	mov    0x18(%ebp),%eax
  102a8d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102a90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102a93:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102a96:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102a99:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102a9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102aa2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102aa6:	74 1c                	je     102ac4 <printnum+0x58>
  102aa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102aab:	ba 00 00 00 00       	mov    $0x0,%edx
  102ab0:	f7 75 e4             	divl   -0x1c(%ebp)
  102ab3:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102ab6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ab9:	ba 00 00 00 00       	mov    $0x0,%edx
  102abe:	f7 75 e4             	divl   -0x1c(%ebp)
  102ac1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ac4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ac7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102aca:	f7 75 e4             	divl   -0x1c(%ebp)
  102acd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102ad0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102ad3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ad6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102ad9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102adc:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102adf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102ae2:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102ae5:	8b 45 18             	mov    0x18(%ebp),%eax
  102ae8:	ba 00 00 00 00       	mov    $0x0,%edx
  102aed:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102af0:	77 56                	ja     102b48 <printnum+0xdc>
  102af2:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102af5:	72 05                	jb     102afc <printnum+0x90>
  102af7:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102afa:	77 4c                	ja     102b48 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  102afc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102aff:	8d 50 ff             	lea    -0x1(%eax),%edx
  102b02:	8b 45 20             	mov    0x20(%ebp),%eax
  102b05:	89 44 24 18          	mov    %eax,0x18(%esp)
  102b09:	89 54 24 14          	mov    %edx,0x14(%esp)
  102b0d:	8b 45 18             	mov    0x18(%ebp),%eax
  102b10:	89 44 24 10          	mov    %eax,0x10(%esp)
  102b14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b17:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102b1a:	89 44 24 08          	mov    %eax,0x8(%esp)
  102b1e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102b22:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b25:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b29:	8b 45 08             	mov    0x8(%ebp),%eax
  102b2c:	89 04 24             	mov    %eax,(%esp)
  102b2f:	e8 38 ff ff ff       	call   102a6c <printnum>
  102b34:	eb 1c                	jmp    102b52 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102b36:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b39:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b3d:	8b 45 20             	mov    0x20(%ebp),%eax
  102b40:	89 04 24             	mov    %eax,(%esp)
  102b43:	8b 45 08             	mov    0x8(%ebp),%eax
  102b46:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  102b48:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102b4c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102b50:	7f e4                	jg     102b36 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102b52:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102b55:	05 70 3d 10 00       	add    $0x103d70,%eax
  102b5a:	0f b6 00             	movzbl (%eax),%eax
  102b5d:	0f be c0             	movsbl %al,%eax
  102b60:	8b 55 0c             	mov    0xc(%ebp),%edx
  102b63:	89 54 24 04          	mov    %edx,0x4(%esp)
  102b67:	89 04 24             	mov    %eax,(%esp)
  102b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  102b6d:	ff d0                	call   *%eax
}
  102b6f:	c9                   	leave  
  102b70:	c3                   	ret    

00102b71 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102b71:	55                   	push   %ebp
  102b72:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102b74:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102b78:	7e 14                	jle    102b8e <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  102b7d:	8b 00                	mov    (%eax),%eax
  102b7f:	8d 48 08             	lea    0x8(%eax),%ecx
  102b82:	8b 55 08             	mov    0x8(%ebp),%edx
  102b85:	89 0a                	mov    %ecx,(%edx)
  102b87:	8b 50 04             	mov    0x4(%eax),%edx
  102b8a:	8b 00                	mov    (%eax),%eax
  102b8c:	eb 30                	jmp    102bbe <getuint+0x4d>
    }
    else if (lflag) {
  102b8e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102b92:	74 16                	je     102baa <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102b94:	8b 45 08             	mov    0x8(%ebp),%eax
  102b97:	8b 00                	mov    (%eax),%eax
  102b99:	8d 48 04             	lea    0x4(%eax),%ecx
  102b9c:	8b 55 08             	mov    0x8(%ebp),%edx
  102b9f:	89 0a                	mov    %ecx,(%edx)
  102ba1:	8b 00                	mov    (%eax),%eax
  102ba3:	ba 00 00 00 00       	mov    $0x0,%edx
  102ba8:	eb 14                	jmp    102bbe <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102baa:	8b 45 08             	mov    0x8(%ebp),%eax
  102bad:	8b 00                	mov    (%eax),%eax
  102baf:	8d 48 04             	lea    0x4(%eax),%ecx
  102bb2:	8b 55 08             	mov    0x8(%ebp),%edx
  102bb5:	89 0a                	mov    %ecx,(%edx)
  102bb7:	8b 00                	mov    (%eax),%eax
  102bb9:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102bbe:	5d                   	pop    %ebp
  102bbf:	c3                   	ret    

00102bc0 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102bc0:	55                   	push   %ebp
  102bc1:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102bc3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102bc7:	7e 14                	jle    102bdd <getint+0x1d>
        return va_arg(*ap, long long);
  102bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  102bcc:	8b 00                	mov    (%eax),%eax
  102bce:	8d 48 08             	lea    0x8(%eax),%ecx
  102bd1:	8b 55 08             	mov    0x8(%ebp),%edx
  102bd4:	89 0a                	mov    %ecx,(%edx)
  102bd6:	8b 50 04             	mov    0x4(%eax),%edx
  102bd9:	8b 00                	mov    (%eax),%eax
  102bdb:	eb 28                	jmp    102c05 <getint+0x45>
    }
    else if (lflag) {
  102bdd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102be1:	74 12                	je     102bf5 <getint+0x35>
        return va_arg(*ap, long);
  102be3:	8b 45 08             	mov    0x8(%ebp),%eax
  102be6:	8b 00                	mov    (%eax),%eax
  102be8:	8d 48 04             	lea    0x4(%eax),%ecx
  102beb:	8b 55 08             	mov    0x8(%ebp),%edx
  102bee:	89 0a                	mov    %ecx,(%edx)
  102bf0:	8b 00                	mov    (%eax),%eax
  102bf2:	99                   	cltd   
  102bf3:	eb 10                	jmp    102c05 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  102bf8:	8b 00                	mov    (%eax),%eax
  102bfa:	8d 48 04             	lea    0x4(%eax),%ecx
  102bfd:	8b 55 08             	mov    0x8(%ebp),%edx
  102c00:	89 0a                	mov    %ecx,(%edx)
  102c02:	8b 00                	mov    (%eax),%eax
  102c04:	99                   	cltd   
    }
}
  102c05:	5d                   	pop    %ebp
  102c06:	c3                   	ret    

00102c07 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102c07:	55                   	push   %ebp
  102c08:	89 e5                	mov    %esp,%ebp
  102c0a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102c0d:	8d 45 14             	lea    0x14(%ebp),%eax
  102c10:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c16:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102c1a:	8b 45 10             	mov    0x10(%ebp),%eax
  102c1d:	89 44 24 08          	mov    %eax,0x8(%esp)
  102c21:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c24:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c28:	8b 45 08             	mov    0x8(%ebp),%eax
  102c2b:	89 04 24             	mov    %eax,(%esp)
  102c2e:	e8 02 00 00 00       	call   102c35 <vprintfmt>
    va_end(ap);
}
  102c33:	c9                   	leave  
  102c34:	c3                   	ret    

00102c35 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102c35:	55                   	push   %ebp
  102c36:	89 e5                	mov    %esp,%ebp
  102c38:	56                   	push   %esi
  102c39:	53                   	push   %ebx
  102c3a:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102c3d:	eb 18                	jmp    102c57 <vprintfmt+0x22>
            if (ch == '\0') {
  102c3f:	85 db                	test   %ebx,%ebx
  102c41:	75 05                	jne    102c48 <vprintfmt+0x13>
                return;
  102c43:	e9 d1 03 00 00       	jmp    103019 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  102c48:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c4f:	89 1c 24             	mov    %ebx,(%esp)
  102c52:	8b 45 08             	mov    0x8(%ebp),%eax
  102c55:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102c57:	8b 45 10             	mov    0x10(%ebp),%eax
  102c5a:	8d 50 01             	lea    0x1(%eax),%edx
  102c5d:	89 55 10             	mov    %edx,0x10(%ebp)
  102c60:	0f b6 00             	movzbl (%eax),%eax
  102c63:	0f b6 d8             	movzbl %al,%ebx
  102c66:	83 fb 25             	cmp    $0x25,%ebx
  102c69:	75 d4                	jne    102c3f <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  102c6b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102c6f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102c76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c79:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102c7c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102c83:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102c86:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102c89:	8b 45 10             	mov    0x10(%ebp),%eax
  102c8c:	8d 50 01             	lea    0x1(%eax),%edx
  102c8f:	89 55 10             	mov    %edx,0x10(%ebp)
  102c92:	0f b6 00             	movzbl (%eax),%eax
  102c95:	0f b6 d8             	movzbl %al,%ebx
  102c98:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102c9b:	83 f8 55             	cmp    $0x55,%eax
  102c9e:	0f 87 44 03 00 00    	ja     102fe8 <vprintfmt+0x3b3>
  102ca4:	8b 04 85 94 3d 10 00 	mov    0x103d94(,%eax,4),%eax
  102cab:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102cad:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102cb1:	eb d6                	jmp    102c89 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102cb3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102cb7:	eb d0                	jmp    102c89 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102cb9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102cc0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102cc3:	89 d0                	mov    %edx,%eax
  102cc5:	c1 e0 02             	shl    $0x2,%eax
  102cc8:	01 d0                	add    %edx,%eax
  102cca:	01 c0                	add    %eax,%eax
  102ccc:	01 d8                	add    %ebx,%eax
  102cce:	83 e8 30             	sub    $0x30,%eax
  102cd1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102cd4:	8b 45 10             	mov    0x10(%ebp),%eax
  102cd7:	0f b6 00             	movzbl (%eax),%eax
  102cda:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102cdd:	83 fb 2f             	cmp    $0x2f,%ebx
  102ce0:	7e 0b                	jle    102ced <vprintfmt+0xb8>
  102ce2:	83 fb 39             	cmp    $0x39,%ebx
  102ce5:	7f 06                	jg     102ced <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102ce7:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  102ceb:	eb d3                	jmp    102cc0 <vprintfmt+0x8b>
            goto process_precision;
  102ced:	eb 33                	jmp    102d22 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  102cef:	8b 45 14             	mov    0x14(%ebp),%eax
  102cf2:	8d 50 04             	lea    0x4(%eax),%edx
  102cf5:	89 55 14             	mov    %edx,0x14(%ebp)
  102cf8:	8b 00                	mov    (%eax),%eax
  102cfa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102cfd:	eb 23                	jmp    102d22 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  102cff:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d03:	79 0c                	jns    102d11 <vprintfmt+0xdc>
                width = 0;
  102d05:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102d0c:	e9 78 ff ff ff       	jmp    102c89 <vprintfmt+0x54>
  102d11:	e9 73 ff ff ff       	jmp    102c89 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  102d16:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102d1d:	e9 67 ff ff ff       	jmp    102c89 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  102d22:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d26:	79 12                	jns    102d3a <vprintfmt+0x105>
                width = precision, precision = -1;
  102d28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102d2b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102d2e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102d35:	e9 4f ff ff ff       	jmp    102c89 <vprintfmt+0x54>
  102d3a:	e9 4a ff ff ff       	jmp    102c89 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102d3f:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  102d43:	e9 41 ff ff ff       	jmp    102c89 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102d48:	8b 45 14             	mov    0x14(%ebp),%eax
  102d4b:	8d 50 04             	lea    0x4(%eax),%edx
  102d4e:	89 55 14             	mov    %edx,0x14(%ebp)
  102d51:	8b 00                	mov    (%eax),%eax
  102d53:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d56:	89 54 24 04          	mov    %edx,0x4(%esp)
  102d5a:	89 04 24             	mov    %eax,(%esp)
  102d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  102d60:	ff d0                	call   *%eax
            break;
  102d62:	e9 ac 02 00 00       	jmp    103013 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102d67:	8b 45 14             	mov    0x14(%ebp),%eax
  102d6a:	8d 50 04             	lea    0x4(%eax),%edx
  102d6d:	89 55 14             	mov    %edx,0x14(%ebp)
  102d70:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102d72:	85 db                	test   %ebx,%ebx
  102d74:	79 02                	jns    102d78 <vprintfmt+0x143>
                err = -err;
  102d76:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102d78:	83 fb 06             	cmp    $0x6,%ebx
  102d7b:	7f 0b                	jg     102d88 <vprintfmt+0x153>
  102d7d:	8b 34 9d 54 3d 10 00 	mov    0x103d54(,%ebx,4),%esi
  102d84:	85 f6                	test   %esi,%esi
  102d86:	75 23                	jne    102dab <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  102d88:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102d8c:	c7 44 24 08 81 3d 10 	movl   $0x103d81,0x8(%esp)
  102d93:	00 
  102d94:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d97:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  102d9e:	89 04 24             	mov    %eax,(%esp)
  102da1:	e8 61 fe ff ff       	call   102c07 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102da6:	e9 68 02 00 00       	jmp    103013 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  102dab:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102daf:	c7 44 24 08 8a 3d 10 	movl   $0x103d8a,0x8(%esp)
  102db6:	00 
  102db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dba:	89 44 24 04          	mov    %eax,0x4(%esp)
  102dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  102dc1:	89 04 24             	mov    %eax,(%esp)
  102dc4:	e8 3e fe ff ff       	call   102c07 <printfmt>
            }
            break;
  102dc9:	e9 45 02 00 00       	jmp    103013 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102dce:	8b 45 14             	mov    0x14(%ebp),%eax
  102dd1:	8d 50 04             	lea    0x4(%eax),%edx
  102dd4:	89 55 14             	mov    %edx,0x14(%ebp)
  102dd7:	8b 30                	mov    (%eax),%esi
  102dd9:	85 f6                	test   %esi,%esi
  102ddb:	75 05                	jne    102de2 <vprintfmt+0x1ad>
                p = "(null)";
  102ddd:	be 8d 3d 10 00       	mov    $0x103d8d,%esi
            }
            if (width > 0 && padc != '-') {
  102de2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102de6:	7e 3e                	jle    102e26 <vprintfmt+0x1f1>
  102de8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102dec:	74 38                	je     102e26 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102dee:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  102df1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102df4:	89 44 24 04          	mov    %eax,0x4(%esp)
  102df8:	89 34 24             	mov    %esi,(%esp)
  102dfb:	e8 15 03 00 00       	call   103115 <strnlen>
  102e00:	29 c3                	sub    %eax,%ebx
  102e02:	89 d8                	mov    %ebx,%eax
  102e04:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102e07:	eb 17                	jmp    102e20 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  102e09:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102e0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  102e10:	89 54 24 04          	mov    %edx,0x4(%esp)
  102e14:	89 04 24             	mov    %eax,(%esp)
  102e17:	8b 45 08             	mov    0x8(%ebp),%eax
  102e1a:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  102e1c:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102e20:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102e24:	7f e3                	jg     102e09 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102e26:	eb 38                	jmp    102e60 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  102e28:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102e2c:	74 1f                	je     102e4d <vprintfmt+0x218>
  102e2e:	83 fb 1f             	cmp    $0x1f,%ebx
  102e31:	7e 05                	jle    102e38 <vprintfmt+0x203>
  102e33:	83 fb 7e             	cmp    $0x7e,%ebx
  102e36:	7e 15                	jle    102e4d <vprintfmt+0x218>
                    putch('?', putdat);
  102e38:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e3f:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  102e46:	8b 45 08             	mov    0x8(%ebp),%eax
  102e49:	ff d0                	call   *%eax
  102e4b:	eb 0f                	jmp    102e5c <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  102e4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e50:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e54:	89 1c 24             	mov    %ebx,(%esp)
  102e57:	8b 45 08             	mov    0x8(%ebp),%eax
  102e5a:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102e5c:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102e60:	89 f0                	mov    %esi,%eax
  102e62:	8d 70 01             	lea    0x1(%eax),%esi
  102e65:	0f b6 00             	movzbl (%eax),%eax
  102e68:	0f be d8             	movsbl %al,%ebx
  102e6b:	85 db                	test   %ebx,%ebx
  102e6d:	74 10                	je     102e7f <vprintfmt+0x24a>
  102e6f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102e73:	78 b3                	js     102e28 <vprintfmt+0x1f3>
  102e75:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  102e79:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102e7d:	79 a9                	jns    102e28 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102e7f:	eb 17                	jmp    102e98 <vprintfmt+0x263>
                putch(' ', putdat);
  102e81:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e84:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e88:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  102e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  102e92:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102e94:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102e98:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102e9c:	7f e3                	jg     102e81 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  102e9e:	e9 70 01 00 00       	jmp    103013 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102ea3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ea6:	89 44 24 04          	mov    %eax,0x4(%esp)
  102eaa:	8d 45 14             	lea    0x14(%ebp),%eax
  102ead:	89 04 24             	mov    %eax,(%esp)
  102eb0:	e8 0b fd ff ff       	call   102bc0 <getint>
  102eb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102eb8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102ebb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ebe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102ec1:	85 d2                	test   %edx,%edx
  102ec3:	79 26                	jns    102eeb <vprintfmt+0x2b6>
                putch('-', putdat);
  102ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ec8:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ecc:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  102ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  102ed6:	ff d0                	call   *%eax
                num = -(long long)num;
  102ed8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102edb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102ede:	f7 d8                	neg    %eax
  102ee0:	83 d2 00             	adc    $0x0,%edx
  102ee3:	f7 da                	neg    %edx
  102ee5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ee8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102eeb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102ef2:	e9 a8 00 00 00       	jmp    102f9f <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102ef7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102efa:	89 44 24 04          	mov    %eax,0x4(%esp)
  102efe:	8d 45 14             	lea    0x14(%ebp),%eax
  102f01:	89 04 24             	mov    %eax,(%esp)
  102f04:	e8 68 fc ff ff       	call   102b71 <getuint>
  102f09:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f0c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102f0f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102f16:	e9 84 00 00 00       	jmp    102f9f <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102f1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f22:	8d 45 14             	lea    0x14(%ebp),%eax
  102f25:	89 04 24             	mov    %eax,(%esp)
  102f28:	e8 44 fc ff ff       	call   102b71 <getuint>
  102f2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f30:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102f33:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102f3a:	eb 63                	jmp    102f9f <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  102f3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f3f:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f43:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  102f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  102f4d:	ff d0                	call   *%eax
            putch('x', putdat);
  102f4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f52:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f56:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  102f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  102f60:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102f62:	8b 45 14             	mov    0x14(%ebp),%eax
  102f65:	8d 50 04             	lea    0x4(%eax),%edx
  102f68:	89 55 14             	mov    %edx,0x14(%ebp)
  102f6b:	8b 00                	mov    (%eax),%eax
  102f6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  102f77:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  102f7e:	eb 1f                	jmp    102f9f <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  102f80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f83:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f87:	8d 45 14             	lea    0x14(%ebp),%eax
  102f8a:	89 04 24             	mov    %eax,(%esp)
  102f8d:	e8 df fb ff ff       	call   102b71 <getuint>
  102f92:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f95:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  102f98:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  102f9f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  102fa3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fa6:	89 54 24 18          	mov    %edx,0x18(%esp)
  102faa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102fad:	89 54 24 14          	mov    %edx,0x14(%esp)
  102fb1:	89 44 24 10          	mov    %eax,0x10(%esp)
  102fb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102fbb:	89 44 24 08          	mov    %eax,0x8(%esp)
  102fbf:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102fc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fc6:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fca:	8b 45 08             	mov    0x8(%ebp),%eax
  102fcd:	89 04 24             	mov    %eax,(%esp)
  102fd0:	e8 97 fa ff ff       	call   102a6c <printnum>
            break;
  102fd5:	eb 3c                	jmp    103013 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  102fd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fda:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fde:	89 1c 24             	mov    %ebx,(%esp)
  102fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  102fe4:	ff d0                	call   *%eax
            break;
  102fe6:	eb 2b                	jmp    103013 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  102fe8:	8b 45 0c             	mov    0xc(%ebp),%eax
  102feb:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fef:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  102ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ff9:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  102ffb:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102fff:	eb 04                	jmp    103005 <vprintfmt+0x3d0>
  103001:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103005:	8b 45 10             	mov    0x10(%ebp),%eax
  103008:	83 e8 01             	sub    $0x1,%eax
  10300b:	0f b6 00             	movzbl (%eax),%eax
  10300e:	3c 25                	cmp    $0x25,%al
  103010:	75 ef                	jne    103001 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  103012:	90                   	nop
        }
    }
  103013:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103014:	e9 3e fc ff ff       	jmp    102c57 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  103019:	83 c4 40             	add    $0x40,%esp
  10301c:	5b                   	pop    %ebx
  10301d:	5e                   	pop    %esi
  10301e:	5d                   	pop    %ebp
  10301f:	c3                   	ret    

00103020 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  103020:	55                   	push   %ebp
  103021:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  103023:	8b 45 0c             	mov    0xc(%ebp),%eax
  103026:	8b 40 08             	mov    0x8(%eax),%eax
  103029:	8d 50 01             	lea    0x1(%eax),%edx
  10302c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10302f:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  103032:	8b 45 0c             	mov    0xc(%ebp),%eax
  103035:	8b 10                	mov    (%eax),%edx
  103037:	8b 45 0c             	mov    0xc(%ebp),%eax
  10303a:	8b 40 04             	mov    0x4(%eax),%eax
  10303d:	39 c2                	cmp    %eax,%edx
  10303f:	73 12                	jae    103053 <sprintputch+0x33>
        *b->buf ++ = ch;
  103041:	8b 45 0c             	mov    0xc(%ebp),%eax
  103044:	8b 00                	mov    (%eax),%eax
  103046:	8d 48 01             	lea    0x1(%eax),%ecx
  103049:	8b 55 0c             	mov    0xc(%ebp),%edx
  10304c:	89 0a                	mov    %ecx,(%edx)
  10304e:	8b 55 08             	mov    0x8(%ebp),%edx
  103051:	88 10                	mov    %dl,(%eax)
    }
}
  103053:	5d                   	pop    %ebp
  103054:	c3                   	ret    

00103055 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  103055:	55                   	push   %ebp
  103056:	89 e5                	mov    %esp,%ebp
  103058:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10305b:	8d 45 14             	lea    0x14(%ebp),%eax
  10305e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  103061:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103064:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103068:	8b 45 10             	mov    0x10(%ebp),%eax
  10306b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10306f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103072:	89 44 24 04          	mov    %eax,0x4(%esp)
  103076:	8b 45 08             	mov    0x8(%ebp),%eax
  103079:	89 04 24             	mov    %eax,(%esp)
  10307c:	e8 08 00 00 00       	call   103089 <vsnprintf>
  103081:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  103084:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103087:	c9                   	leave  
  103088:	c3                   	ret    

00103089 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  103089:	55                   	push   %ebp
  10308a:	89 e5                	mov    %esp,%ebp
  10308c:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  10308f:	8b 45 08             	mov    0x8(%ebp),%eax
  103092:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103095:	8b 45 0c             	mov    0xc(%ebp),%eax
  103098:	8d 50 ff             	lea    -0x1(%eax),%edx
  10309b:	8b 45 08             	mov    0x8(%ebp),%eax
  10309e:	01 d0                	add    %edx,%eax
  1030a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1030a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  1030aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1030ae:	74 0a                	je     1030ba <vsnprintf+0x31>
  1030b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1030b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030b6:	39 c2                	cmp    %eax,%edx
  1030b8:	76 07                	jbe    1030c1 <vsnprintf+0x38>
        return -E_INVAL;
  1030ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1030bf:	eb 2a                	jmp    1030eb <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1030c1:	8b 45 14             	mov    0x14(%ebp),%eax
  1030c4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1030c8:	8b 45 10             	mov    0x10(%ebp),%eax
  1030cb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1030cf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1030d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1030d6:	c7 04 24 20 30 10 00 	movl   $0x103020,(%esp)
  1030dd:	e8 53 fb ff ff       	call   102c35 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  1030e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030e5:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1030e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1030eb:	c9                   	leave  
  1030ec:	c3                   	ret    

001030ed <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  1030ed:	55                   	push   %ebp
  1030ee:	89 e5                	mov    %esp,%ebp
  1030f0:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1030f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  1030fa:	eb 04                	jmp    103100 <strlen+0x13>
        cnt ++;
  1030fc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  103100:	8b 45 08             	mov    0x8(%ebp),%eax
  103103:	8d 50 01             	lea    0x1(%eax),%edx
  103106:	89 55 08             	mov    %edx,0x8(%ebp)
  103109:	0f b6 00             	movzbl (%eax),%eax
  10310c:	84 c0                	test   %al,%al
  10310e:	75 ec                	jne    1030fc <strlen+0xf>
        cnt ++;
    }
    return cnt;
  103110:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  103113:	c9                   	leave  
  103114:	c3                   	ret    

00103115 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  103115:	55                   	push   %ebp
  103116:	89 e5                	mov    %esp,%ebp
  103118:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  10311b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  103122:	eb 04                	jmp    103128 <strnlen+0x13>
        cnt ++;
  103124:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  103128:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10312b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10312e:	73 10                	jae    103140 <strnlen+0x2b>
  103130:	8b 45 08             	mov    0x8(%ebp),%eax
  103133:	8d 50 01             	lea    0x1(%eax),%edx
  103136:	89 55 08             	mov    %edx,0x8(%ebp)
  103139:	0f b6 00             	movzbl (%eax),%eax
  10313c:	84 c0                	test   %al,%al
  10313e:	75 e4                	jne    103124 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  103140:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  103143:	c9                   	leave  
  103144:	c3                   	ret    

00103145 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  103145:	55                   	push   %ebp
  103146:	89 e5                	mov    %esp,%ebp
  103148:	57                   	push   %edi
  103149:	56                   	push   %esi
  10314a:	83 ec 20             	sub    $0x20,%esp
  10314d:	8b 45 08             	mov    0x8(%ebp),%eax
  103150:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103153:	8b 45 0c             	mov    0xc(%ebp),%eax
  103156:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  103159:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10315c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10315f:	89 d1                	mov    %edx,%ecx
  103161:	89 c2                	mov    %eax,%edx
  103163:	89 ce                	mov    %ecx,%esi
  103165:	89 d7                	mov    %edx,%edi
  103167:	ac                   	lods   %ds:(%esi),%al
  103168:	aa                   	stos   %al,%es:(%edi)
  103169:	84 c0                	test   %al,%al
  10316b:	75 fa                	jne    103167 <strcpy+0x22>
  10316d:	89 fa                	mov    %edi,%edx
  10316f:	89 f1                	mov    %esi,%ecx
  103171:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103174:	89 55 e8             	mov    %edx,-0x18(%ebp)
  103177:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  10317a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  10317d:	83 c4 20             	add    $0x20,%esp
  103180:	5e                   	pop    %esi
  103181:	5f                   	pop    %edi
  103182:	5d                   	pop    %ebp
  103183:	c3                   	ret    

00103184 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  103184:	55                   	push   %ebp
  103185:	89 e5                	mov    %esp,%ebp
  103187:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  10318a:	8b 45 08             	mov    0x8(%ebp),%eax
  10318d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  103190:	eb 21                	jmp    1031b3 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  103192:	8b 45 0c             	mov    0xc(%ebp),%eax
  103195:	0f b6 10             	movzbl (%eax),%edx
  103198:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10319b:	88 10                	mov    %dl,(%eax)
  10319d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1031a0:	0f b6 00             	movzbl (%eax),%eax
  1031a3:	84 c0                	test   %al,%al
  1031a5:	74 04                	je     1031ab <strncpy+0x27>
            src ++;
  1031a7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  1031ab:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1031af:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  1031b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1031b7:	75 d9                	jne    103192 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  1031b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1031bc:	c9                   	leave  
  1031bd:	c3                   	ret    

001031be <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  1031be:	55                   	push   %ebp
  1031bf:	89 e5                	mov    %esp,%ebp
  1031c1:	57                   	push   %edi
  1031c2:	56                   	push   %esi
  1031c3:	83 ec 20             	sub    $0x20,%esp
  1031c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1031c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1031cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  1031d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1031d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031d8:	89 d1                	mov    %edx,%ecx
  1031da:	89 c2                	mov    %eax,%edx
  1031dc:	89 ce                	mov    %ecx,%esi
  1031de:	89 d7                	mov    %edx,%edi
  1031e0:	ac                   	lods   %ds:(%esi),%al
  1031e1:	ae                   	scas   %es:(%edi),%al
  1031e2:	75 08                	jne    1031ec <strcmp+0x2e>
  1031e4:	84 c0                	test   %al,%al
  1031e6:	75 f8                	jne    1031e0 <strcmp+0x22>
  1031e8:	31 c0                	xor    %eax,%eax
  1031ea:	eb 04                	jmp    1031f0 <strcmp+0x32>
  1031ec:	19 c0                	sbb    %eax,%eax
  1031ee:	0c 01                	or     $0x1,%al
  1031f0:	89 fa                	mov    %edi,%edx
  1031f2:	89 f1                	mov    %esi,%ecx
  1031f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1031f7:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1031fa:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  1031fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  103200:	83 c4 20             	add    $0x20,%esp
  103203:	5e                   	pop    %esi
  103204:	5f                   	pop    %edi
  103205:	5d                   	pop    %ebp
  103206:	c3                   	ret    

00103207 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  103207:	55                   	push   %ebp
  103208:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  10320a:	eb 0c                	jmp    103218 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  10320c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103210:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103214:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  103218:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10321c:	74 1a                	je     103238 <strncmp+0x31>
  10321e:	8b 45 08             	mov    0x8(%ebp),%eax
  103221:	0f b6 00             	movzbl (%eax),%eax
  103224:	84 c0                	test   %al,%al
  103226:	74 10                	je     103238 <strncmp+0x31>
  103228:	8b 45 08             	mov    0x8(%ebp),%eax
  10322b:	0f b6 10             	movzbl (%eax),%edx
  10322e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103231:	0f b6 00             	movzbl (%eax),%eax
  103234:	38 c2                	cmp    %al,%dl
  103236:	74 d4                	je     10320c <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  103238:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10323c:	74 18                	je     103256 <strncmp+0x4f>
  10323e:	8b 45 08             	mov    0x8(%ebp),%eax
  103241:	0f b6 00             	movzbl (%eax),%eax
  103244:	0f b6 d0             	movzbl %al,%edx
  103247:	8b 45 0c             	mov    0xc(%ebp),%eax
  10324a:	0f b6 00             	movzbl (%eax),%eax
  10324d:	0f b6 c0             	movzbl %al,%eax
  103250:	29 c2                	sub    %eax,%edx
  103252:	89 d0                	mov    %edx,%eax
  103254:	eb 05                	jmp    10325b <strncmp+0x54>
  103256:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10325b:	5d                   	pop    %ebp
  10325c:	c3                   	ret    

0010325d <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  10325d:	55                   	push   %ebp
  10325e:	89 e5                	mov    %esp,%ebp
  103260:	83 ec 04             	sub    $0x4,%esp
  103263:	8b 45 0c             	mov    0xc(%ebp),%eax
  103266:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103269:	eb 14                	jmp    10327f <strchr+0x22>
        if (*s == c) {
  10326b:	8b 45 08             	mov    0x8(%ebp),%eax
  10326e:	0f b6 00             	movzbl (%eax),%eax
  103271:	3a 45 fc             	cmp    -0x4(%ebp),%al
  103274:	75 05                	jne    10327b <strchr+0x1e>
            return (char *)s;
  103276:	8b 45 08             	mov    0x8(%ebp),%eax
  103279:	eb 13                	jmp    10328e <strchr+0x31>
        }
        s ++;
  10327b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  10327f:	8b 45 08             	mov    0x8(%ebp),%eax
  103282:	0f b6 00             	movzbl (%eax),%eax
  103285:	84 c0                	test   %al,%al
  103287:	75 e2                	jne    10326b <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  103289:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10328e:	c9                   	leave  
  10328f:	c3                   	ret    

00103290 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  103290:	55                   	push   %ebp
  103291:	89 e5                	mov    %esp,%ebp
  103293:	83 ec 04             	sub    $0x4,%esp
  103296:	8b 45 0c             	mov    0xc(%ebp),%eax
  103299:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  10329c:	eb 11                	jmp    1032af <strfind+0x1f>
        if (*s == c) {
  10329e:	8b 45 08             	mov    0x8(%ebp),%eax
  1032a1:	0f b6 00             	movzbl (%eax),%eax
  1032a4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  1032a7:	75 02                	jne    1032ab <strfind+0x1b>
            break;
  1032a9:	eb 0e                	jmp    1032b9 <strfind+0x29>
        }
        s ++;
  1032ab:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  1032af:	8b 45 08             	mov    0x8(%ebp),%eax
  1032b2:	0f b6 00             	movzbl (%eax),%eax
  1032b5:	84 c0                	test   %al,%al
  1032b7:	75 e5                	jne    10329e <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  1032b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1032bc:	c9                   	leave  
  1032bd:	c3                   	ret    

001032be <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  1032be:	55                   	push   %ebp
  1032bf:	89 e5                	mov    %esp,%ebp
  1032c1:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  1032c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  1032cb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1032d2:	eb 04                	jmp    1032d8 <strtol+0x1a>
        s ++;
  1032d4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1032d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1032db:	0f b6 00             	movzbl (%eax),%eax
  1032de:	3c 20                	cmp    $0x20,%al
  1032e0:	74 f2                	je     1032d4 <strtol+0x16>
  1032e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1032e5:	0f b6 00             	movzbl (%eax),%eax
  1032e8:	3c 09                	cmp    $0x9,%al
  1032ea:	74 e8                	je     1032d4 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  1032ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1032ef:	0f b6 00             	movzbl (%eax),%eax
  1032f2:	3c 2b                	cmp    $0x2b,%al
  1032f4:	75 06                	jne    1032fc <strtol+0x3e>
        s ++;
  1032f6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1032fa:	eb 15                	jmp    103311 <strtol+0x53>
    }
    else if (*s == '-') {
  1032fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1032ff:	0f b6 00             	movzbl (%eax),%eax
  103302:	3c 2d                	cmp    $0x2d,%al
  103304:	75 0b                	jne    103311 <strtol+0x53>
        s ++, neg = 1;
  103306:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10330a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  103311:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103315:	74 06                	je     10331d <strtol+0x5f>
  103317:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  10331b:	75 24                	jne    103341 <strtol+0x83>
  10331d:	8b 45 08             	mov    0x8(%ebp),%eax
  103320:	0f b6 00             	movzbl (%eax),%eax
  103323:	3c 30                	cmp    $0x30,%al
  103325:	75 1a                	jne    103341 <strtol+0x83>
  103327:	8b 45 08             	mov    0x8(%ebp),%eax
  10332a:	83 c0 01             	add    $0x1,%eax
  10332d:	0f b6 00             	movzbl (%eax),%eax
  103330:	3c 78                	cmp    $0x78,%al
  103332:	75 0d                	jne    103341 <strtol+0x83>
        s += 2, base = 16;
  103334:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  103338:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  10333f:	eb 2a                	jmp    10336b <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  103341:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103345:	75 17                	jne    10335e <strtol+0xa0>
  103347:	8b 45 08             	mov    0x8(%ebp),%eax
  10334a:	0f b6 00             	movzbl (%eax),%eax
  10334d:	3c 30                	cmp    $0x30,%al
  10334f:	75 0d                	jne    10335e <strtol+0xa0>
        s ++, base = 8;
  103351:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103355:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  10335c:	eb 0d                	jmp    10336b <strtol+0xad>
    }
    else if (base == 0) {
  10335e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103362:	75 07                	jne    10336b <strtol+0xad>
        base = 10;
  103364:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  10336b:	8b 45 08             	mov    0x8(%ebp),%eax
  10336e:	0f b6 00             	movzbl (%eax),%eax
  103371:	3c 2f                	cmp    $0x2f,%al
  103373:	7e 1b                	jle    103390 <strtol+0xd2>
  103375:	8b 45 08             	mov    0x8(%ebp),%eax
  103378:	0f b6 00             	movzbl (%eax),%eax
  10337b:	3c 39                	cmp    $0x39,%al
  10337d:	7f 11                	jg     103390 <strtol+0xd2>
            dig = *s - '0';
  10337f:	8b 45 08             	mov    0x8(%ebp),%eax
  103382:	0f b6 00             	movzbl (%eax),%eax
  103385:	0f be c0             	movsbl %al,%eax
  103388:	83 e8 30             	sub    $0x30,%eax
  10338b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10338e:	eb 48                	jmp    1033d8 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  103390:	8b 45 08             	mov    0x8(%ebp),%eax
  103393:	0f b6 00             	movzbl (%eax),%eax
  103396:	3c 60                	cmp    $0x60,%al
  103398:	7e 1b                	jle    1033b5 <strtol+0xf7>
  10339a:	8b 45 08             	mov    0x8(%ebp),%eax
  10339d:	0f b6 00             	movzbl (%eax),%eax
  1033a0:	3c 7a                	cmp    $0x7a,%al
  1033a2:	7f 11                	jg     1033b5 <strtol+0xf7>
            dig = *s - 'a' + 10;
  1033a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1033a7:	0f b6 00             	movzbl (%eax),%eax
  1033aa:	0f be c0             	movsbl %al,%eax
  1033ad:	83 e8 57             	sub    $0x57,%eax
  1033b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1033b3:	eb 23                	jmp    1033d8 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  1033b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1033b8:	0f b6 00             	movzbl (%eax),%eax
  1033bb:	3c 40                	cmp    $0x40,%al
  1033bd:	7e 3d                	jle    1033fc <strtol+0x13e>
  1033bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1033c2:	0f b6 00             	movzbl (%eax),%eax
  1033c5:	3c 5a                	cmp    $0x5a,%al
  1033c7:	7f 33                	jg     1033fc <strtol+0x13e>
            dig = *s - 'A' + 10;
  1033c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1033cc:	0f b6 00             	movzbl (%eax),%eax
  1033cf:	0f be c0             	movsbl %al,%eax
  1033d2:	83 e8 37             	sub    $0x37,%eax
  1033d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1033d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033db:	3b 45 10             	cmp    0x10(%ebp),%eax
  1033de:	7c 02                	jl     1033e2 <strtol+0x124>
            break;
  1033e0:	eb 1a                	jmp    1033fc <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  1033e2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1033e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1033e9:	0f af 45 10          	imul   0x10(%ebp),%eax
  1033ed:	89 c2                	mov    %eax,%edx
  1033ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033f2:	01 d0                	add    %edx,%eax
  1033f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  1033f7:	e9 6f ff ff ff       	jmp    10336b <strtol+0xad>

    if (endptr) {
  1033fc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103400:	74 08                	je     10340a <strtol+0x14c>
        *endptr = (char *) s;
  103402:	8b 45 0c             	mov    0xc(%ebp),%eax
  103405:	8b 55 08             	mov    0x8(%ebp),%edx
  103408:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  10340a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  10340e:	74 07                	je     103417 <strtol+0x159>
  103410:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103413:	f7 d8                	neg    %eax
  103415:	eb 03                	jmp    10341a <strtol+0x15c>
  103417:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  10341a:	c9                   	leave  
  10341b:	c3                   	ret    

0010341c <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  10341c:	55                   	push   %ebp
  10341d:	89 e5                	mov    %esp,%ebp
  10341f:	57                   	push   %edi
  103420:	83 ec 24             	sub    $0x24,%esp
  103423:	8b 45 0c             	mov    0xc(%ebp),%eax
  103426:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  103429:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  10342d:	8b 55 08             	mov    0x8(%ebp),%edx
  103430:	89 55 f8             	mov    %edx,-0x8(%ebp)
  103433:	88 45 f7             	mov    %al,-0x9(%ebp)
  103436:	8b 45 10             	mov    0x10(%ebp),%eax
  103439:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  10343c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  10343f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  103443:	8b 55 f8             	mov    -0x8(%ebp),%edx
  103446:	89 d7                	mov    %edx,%edi
  103448:	f3 aa                	rep stos %al,%es:(%edi)
  10344a:	89 fa                	mov    %edi,%edx
  10344c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10344f:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  103452:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  103455:	83 c4 24             	add    $0x24,%esp
  103458:	5f                   	pop    %edi
  103459:	5d                   	pop    %ebp
  10345a:	c3                   	ret    

0010345b <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  10345b:	55                   	push   %ebp
  10345c:	89 e5                	mov    %esp,%ebp
  10345e:	57                   	push   %edi
  10345f:	56                   	push   %esi
  103460:	53                   	push   %ebx
  103461:	83 ec 30             	sub    $0x30,%esp
  103464:	8b 45 08             	mov    0x8(%ebp),%eax
  103467:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10346a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10346d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103470:	8b 45 10             	mov    0x10(%ebp),%eax
  103473:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  103476:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103479:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10347c:	73 42                	jae    1034c0 <memmove+0x65>
  10347e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103481:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103484:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103487:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10348a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10348d:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103490:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103493:	c1 e8 02             	shr    $0x2,%eax
  103496:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  103498:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10349b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10349e:	89 d7                	mov    %edx,%edi
  1034a0:	89 c6                	mov    %eax,%esi
  1034a2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1034a4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1034a7:	83 e1 03             	and    $0x3,%ecx
  1034aa:	74 02                	je     1034ae <memmove+0x53>
  1034ac:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1034ae:	89 f0                	mov    %esi,%eax
  1034b0:	89 fa                	mov    %edi,%edx
  1034b2:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  1034b5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1034b8:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  1034bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1034be:	eb 36                	jmp    1034f6 <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  1034c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034c3:	8d 50 ff             	lea    -0x1(%eax),%edx
  1034c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1034c9:	01 c2                	add    %eax,%edx
  1034cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034ce:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1034d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034d4:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  1034d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034da:	89 c1                	mov    %eax,%ecx
  1034dc:	89 d8                	mov    %ebx,%eax
  1034de:	89 d6                	mov    %edx,%esi
  1034e0:	89 c7                	mov    %eax,%edi
  1034e2:	fd                   	std    
  1034e3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1034e5:	fc                   	cld    
  1034e6:	89 f8                	mov    %edi,%eax
  1034e8:	89 f2                	mov    %esi,%edx
  1034ea:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1034ed:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1034f0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  1034f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1034f6:	83 c4 30             	add    $0x30,%esp
  1034f9:	5b                   	pop    %ebx
  1034fa:	5e                   	pop    %esi
  1034fb:	5f                   	pop    %edi
  1034fc:	5d                   	pop    %ebp
  1034fd:	c3                   	ret    

001034fe <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1034fe:	55                   	push   %ebp
  1034ff:	89 e5                	mov    %esp,%ebp
  103501:	57                   	push   %edi
  103502:	56                   	push   %esi
  103503:	83 ec 20             	sub    $0x20,%esp
  103506:	8b 45 08             	mov    0x8(%ebp),%eax
  103509:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10350c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10350f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103512:	8b 45 10             	mov    0x10(%ebp),%eax
  103515:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103518:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10351b:	c1 e8 02             	shr    $0x2,%eax
  10351e:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  103520:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103523:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103526:	89 d7                	mov    %edx,%edi
  103528:	89 c6                	mov    %eax,%esi
  10352a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10352c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  10352f:	83 e1 03             	and    $0x3,%ecx
  103532:	74 02                	je     103536 <memcpy+0x38>
  103534:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103536:	89 f0                	mov    %esi,%eax
  103538:	89 fa                	mov    %edi,%edx
  10353a:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10353d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  103540:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  103543:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  103546:	83 c4 20             	add    $0x20,%esp
  103549:	5e                   	pop    %esi
  10354a:	5f                   	pop    %edi
  10354b:	5d                   	pop    %ebp
  10354c:	c3                   	ret    

0010354d <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  10354d:	55                   	push   %ebp
  10354e:	89 e5                	mov    %esp,%ebp
  103550:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  103553:	8b 45 08             	mov    0x8(%ebp),%eax
  103556:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  103559:	8b 45 0c             	mov    0xc(%ebp),%eax
  10355c:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  10355f:	eb 30                	jmp    103591 <memcmp+0x44>
        if (*s1 != *s2) {
  103561:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103564:	0f b6 10             	movzbl (%eax),%edx
  103567:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10356a:	0f b6 00             	movzbl (%eax),%eax
  10356d:	38 c2                	cmp    %al,%dl
  10356f:	74 18                	je     103589 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  103571:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103574:	0f b6 00             	movzbl (%eax),%eax
  103577:	0f b6 d0             	movzbl %al,%edx
  10357a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10357d:	0f b6 00             	movzbl (%eax),%eax
  103580:	0f b6 c0             	movzbl %al,%eax
  103583:	29 c2                	sub    %eax,%edx
  103585:	89 d0                	mov    %edx,%eax
  103587:	eb 1a                	jmp    1035a3 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  103589:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10358d:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  103591:	8b 45 10             	mov    0x10(%ebp),%eax
  103594:	8d 50 ff             	lea    -0x1(%eax),%edx
  103597:	89 55 10             	mov    %edx,0x10(%ebp)
  10359a:	85 c0                	test   %eax,%eax
  10359c:	75 c3                	jne    103561 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  10359e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1035a3:	c9                   	leave  
  1035a4:	c3                   	ret    
