	.file	"StageC.c"
 # GNU C23 (Rev8, Built by MSYS2 project) version 15.2.0 (x86_64-w64-mingw32)
 #	compiled by GNU C version 15.2.0, GMP version 6.3.0, MPFR version 4.2.2, MPC version 1.3.1, isl version isl-0.27-GMP

 # GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
 # options passed: -mtune=generic -march=nocona -O2
	.text
	.p2align 4
	.def	now_ns;	.scl	3;	.type	32;	.endef
	.seh_proc	now_ns
now_ns:
	subq	$56, %rsp	 #,
	.seh_stackalloc	56
	.seh_endprologue
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	movl	ready.1(%rip), %eax	 # ready,
	testl	%eax, %eax	 #
	je	.L4	 #,
.L2:
 # timing.h:26:       QueryPerformanceCounter(&count);
	leaq	40(%rsp), %rcx	 #, tmp113
	call	*__imp_QueryPerformanceCounter(%rip)	 #
 # timing.h:28:       uint64_t f = (uint64_t)freq.QuadPart, c = (uint64_t)count.QuadPart;
	movq	freq.0(%rip), %r8	 # freq.QuadPart, f
	movq	40(%rsp), %rax	 # count.QuadPart, count.QuadPart
	xorl	%edx, %edx	 # tmp116
	divq	%r8	 # f
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	imulq	$1000000000, %rax, %rcx	 #, count.QuadPart, _5
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	imulq	$1000000000, %rdx, %rax	 #, tmp116, _7
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	xorl	%edx, %edx	 # tmp122
	divq	%r8	 # f
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	addq	%rcx, %rax	 # _5, _16
 # timing.h:30:   }
	addq	$56, %rsp	 #,
	ret	
	.p2align 4,,10
	.p2align 3
.L4:
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	leaq	freq.0(%rip), %rcx	 #,
	call	*__imp_QueryPerformanceFrequency(%rip)	 #
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	movl	$1, ready.1(%rip)	 #, ready
	jmp	.L2	 #
	.seh_endproc
	.section .rdata,"dr"
.LC2:
	.ascii "../DATABASE/stress_full.csv\0"
.LC3:
	.ascii "../DATABASE/dev_1M.csv\0"
.LC4:
	.ascii "../DATABASE/test20.csv\0"
.LC5:
	.ascii "naive\0"
.LC6:
	.ascii "running-sum\0"
.LC7:
	.ascii " (still holding 1 BTC)\0"
.LC8:
	.ascii "\0"
.LC9:
	.ascii "test\0"
.LC10:
	.ascii "dev\0"
.LC11:
	.ascii "stress\0"
	.align 8
.LC12:
	.ascii "Unknown file '%s' (use test, dev or stress)\12\0"
.LC13:
	.ascii "Speed must be >= 0\0"
.LC14:
	.ascii "-r\0"
.LC15:
	.ascii "Rival time must be > 0\0"
	.align 8
.LC18:
	.ascii "Usage: %s [-f test|dev|stress] [-s SPEED] [-m MINUTES] [-n] [-c] [-l] [-q] [-o FILE] [-r US]\12\0"
.LC19:
	.ascii "rb\0"
.LC20:
	.ascii "Could not open %s\12\0"
.LC22:
	.ascii "malloc of %lld trades failed\12\0"
.LC23:
	.ascii "r\0"
	.align 8
.LC24:
	.ascii "Not enough trades (%lld) for the long window (%d)\12\0"
	.align 8
.LC28:
	.ascii "Stage C replay: %s, windows %d/%d, %s SMA, speed %s\12\0"
.LC29:
	.ascii "paced\0"
	.align 8
.LC31:
	.ascii "Trades loaded: %lld (malloc %.1f MB)   load time %.3f s\12\0"
	.align 8
.LC32:
	.ascii "Replaying %lld trades covering %.1f s of market time\0"
.LC33:
	.ascii " at %gx (about %.1f s)\0"
.LC34:
	.ascii "\12\0"
	.align 8
.LC35:
	.ascii "[led.h] No built-in LED on this computer. Printing instead.\0"
	.align 8
.LC36:
	.ascii "Out of memory for the signal log\0"
.LC38:
	.ascii "OFF\0"
.LC39:
	.ascii "RED\0"
.LC40:
	.ascii "[LED %s %s]\12\0"
.LC41:
	.ascii "ON\0"
.LC42:
	.ascii "GREEN\0"
	.align 8
.LC43:
	.ascii "\15  replayed %5.1f%%  | lag %9.3f ms | BUY %lld SELL %lld | P&L %.2f   \0"
.LC44:
	.ascii "\15%79s\15\0"
.LC45:
	.ascii "\12--- Replay results ---\0"
.LC46:
	.ascii "Trades replayed      : %lld\12\0"
	.align 8
.LC47:
	.ascii "Signals              : %lld BUY, %lld SELL\12\0"
.LC48:
	.ascii "Final VWAP           : %.8f\12\0"
.LC49:
	.ascii "Wall time            : %.3f s\0"
.LC50:
	.ascii "   (ideal %.3f s)\0"
	.align 8
.LC51:
	.ascii "Processing per trade : avg %.1f ns, worst %.3f us\12\0"
	.align 8
.LC52:
	.ascii "Latency per trade    : avg %.3f us, worst %.3f us\12\0"
	.align 8
.LC53:
	.ascii "Lag behind replay    : worst %.3f ms, at end %.3f ms\12\0"
	.align 8
.LC54:
	.ascii "Rival bot (R = %.2f us): P&L %.2f USDT, races won %lld, lost %lld%s\12\0"
.LC55:
	.ascii "\12--- Memory ---\0"
	.align 8
.LC56:
	.ascii "malloc array (exact fit) : %.1f MB for %lld trades\12\0"
	.align 8
.LC57:
	.ascii "Stage B fixed array      : %.1f MB reserved (MAX_TRADES = %d)\12\0"
.LC58:
	.ascii "w\0"
	.align 8
.LC59:
	.ascii "trade_index,ts_us,price_fx,side,proc_ns,latency_ns\12\0"
.LC60:
	.ascii "\12Wrote %lld signals to %s\12\0"
.LC61:
	.ascii "%lld,%lld,%lld,%d,%llu,%llu\12\0"
.LC62:
	.ascii "unpaced\0"
.LC63:
	.ascii "BUY\0"
.LC64:
	.ascii "\33[32m\0"
	.align 8
.LC65:
	.ascii "%s%-4s trade %-8lld price %.2f  latency %.2f us%s\12\0"
.LC66:
	.ascii "\33[0m\0"
.LC67:
	.ascii "SELL\0"
.LC68:
	.ascii "\33[31m\0"
	.section	.text.startup,"x"
	.p2align 4
	.globl	main
	.def	main;	.scl	2;	.type	32;	.endef
	.seh_proc	main
main:
	pushq	%r15	 #
	.seh_pushreg	%r15
	pushq	%r14	 #
	.seh_pushreg	%r14
	pushq	%r13	 #
	.seh_pushreg	%r13
	pushq	%r12	 #
	.seh_pushreg	%r12
	pushq	%rbp	 #
	.seh_pushreg	%rbp
	pushq	%rdi	 #
	.seh_pushreg	%rdi
	pushq	%rsi	 #
	.seh_pushreg	%rsi
	pushq	%rbx	 #
	.seh_pushreg	%rbx
	subq	$312, %rsp	 #,
	.seh_stackalloc	312
	movups	%xmm6, 208(%rsp)	 #,
	.seh_savexmm	%xmm6, 208
	movups	%xmm7, 224(%rsp)	 #,
	.seh_savexmm	%xmm7, 224
	movups	%xmm8, 240(%rsp)	 #,
	.seh_savexmm	%xmm8, 240
	movups	%xmm9, 256(%rsp)	 #,
	.seh_savexmm	%xmm9, 256
	movups	%xmm10, 272(%rsp)	 #,
	.seh_savexmm	%xmm10, 272
	movups	%xmm11, 288(%rsp)	 #,
	.seh_savexmm	%xmm11, 288
	.seh_endprologue
 # StageC.c:288: {
	movl	%ecx, %ebp	 # argc, argc
	movq	%rdx, %r12	 # argv, argv
	call	__main	 #
 # StageC.c:296:     for (int a = 1; a < argc; a++) {
	cmpl	$1, %ebp	 #, argc
	jle	.L144	 #,
 # StageC.c:290:     double speed = 1000.0;
	movsd	.LC1(%rip), %xmm8	 #, tmp1081
 # StageC.c:292:     int use_colour = 0, use_led = 0, quiet = 0;
	movl	$0, 116(%rsp)	 #, %sfp
 # StageC.c:289:     const char *path = STRESS_PATH;
	leaq	.LC2(%rip), %rbx	 #, path
 # StageC.c:296:     for (int a = 1; a < argc; a++) {
	movl	$1, %esi	 #, a
 # StageC.c:292:     int use_colour = 0, use_led = 0, quiet = 0;
	movl	$0, 112(%rsp)	 #, %sfp
 # StageC.c:293:     int is_test = 0;
	xorl	%r15d, %r15d	 # is_test
 # StageC.c:291:     double max_minutes = 0.0;       /* 0 = whole file */
	pxor	%xmm7, %xmm7	 # max_minutes
 # StageC.c:304:                 path = STRESS_PATH;
	movq	%rbx, %rdi	 # path, path
 # StageC.c:292:     int use_colour = 0, use_led = 0, quiet = 0;
	movl	$0, 88(%rsp)	 #, %sfp
 # StageC.c:290:     double speed = 1000.0;
	movapd	%xmm8, %xmm6	 # tmp1081, speed
 # StageC.c:304:                 path = STRESS_PATH;
	movq	%r12, 392(%rsp)	 # argv, argv
	movl	%ebp, %r12d	 # argc, argc
	movq	392(%rsp), %rbp	 # argv, argv
	.p2align 4
	.p2align 3
.L30:
 # StageC.c:297:         if (strcmp(argv[a], "-f") == 0 && a + 1 < argc) {
	movslq	%esi, %r13	 # a, _1
 # StageC.c:297:         if (strcmp(argv[a], "-f") == 0 && a + 1 < argc) {
	movq	0(%rbp,%r13,8), %rcx	 # *_3, _4
	movzbl	(%rcx), %eax	 # MEM <char[1:3]> [(void *)_4], MEM <char[1:3]> [(void *)_4]
	cmpl	$45, %eax	 #, MEM <char[1:3]> [(void *)_4]
	je	.L227	 #,
.L24:
 # StageC.c:324:         } else if (strcmp(argv[a], "-r") == 0 && a + 1 < argc) {
	leaq	.LC14(%rip), %rdx	 #,
	call	strcmp	 #
 # StageC.c:324:         } else if (strcmp(argv[a], "-r") == 0 && a + 1 < argc) {
	testl	%eax, %eax	 # _36
	jne	.L25	 #,
 # StageC.c:324:         } else if (strcmp(argv[a], "-r") == 0 && a + 1 < argc) {
	addl	$1, %esi	 #, a
 # StageC.c:324:         } else if (strcmp(argv[a], "-r") == 0 && a + 1 < argc) {
	cmpl	%r12d, %esi	 # argc, a
	jge	.L25	 #,
 # StageC.c:325:             double r_us = atof(argv[++a]);
	movq	8(%rbp,%r13,8), %rcx	 # *_40, *_40
	call	atof	 #
 # StageC.c:326:             if (r_us <= 0.0) { printf("Rival time must be > 0\n"); return 1; }
	pxor	%xmm1, %xmm1	 # tmp555
	comisd	%xmm0, %xmm1	 # r_us, tmp555
	jnb	.L228	 #,
 # StageC.c:327:             rival_ns = (uint64_t)(r_us * 1000.0 + 0.5);
	mulsd	%xmm8, %xmm0	 # tmp1081, _42
 # StageC.c:327:             rival_ns = (uint64_t)(r_us * 1000.0 + 0.5);
	movsd	.LC17(%rip), %xmm1	 #, tmp561
 # StageC.c:327:             rival_ns = (uint64_t)(r_us * 1000.0 + 0.5);
	addsd	.LC16(%rip), %xmm0	 #, _43
 # StageC.c:327:             rival_ns = (uint64_t)(r_us * 1000.0 + 0.5);
	comisd	%xmm1, %xmm0	 # tmp561, _43
	jb	.L229	 #,
	subsd	%xmm1, %xmm0	 # tmp561, tmp563
	cvttsd2siq	%xmm0, %rax	 # tmp563, tmp565
	movq	%rax, rival_ns(%rip)	 # tmp565, rival_ns
	btcq	$63, rival_ns(%rip)	 #, rival_ns
 # StageC.c:324:         } else if (strcmp(argv[a], "-r") == 0 && a + 1 < argc) {
	jmp	.L10	 #
	.p2align 4,,10
	.p2align 3
.L227:
 # StageC.c:297:         if (strcmp(argv[a], "-f") == 0 && a + 1 < argc) {
	movzbl	1(%rcx), %edx	 # MEM <char[1:3]> [(void *)_4], MEM <char[1:3]> [(void *)_4]
	cmpl	$102, %edx	 #, MEM <char[1:3]> [(void *)_4]
	je	.L230	 #,
.L8:
 # StageC.c:309:         } else if (strcmp(argv[a], "-s") == 0 && a + 1 < argc) {
	cmpl	$45, %eax	 #, MEM <char[1:3]> [(void *)_4]
	jne	.L24	 #,
	cmpb	$115, 1(%rcx)	 #, MEM <char[1:3]> [(void *)_4]
	jne	.L13	 #,
 # StageC.c:309:         } else if (strcmp(argv[a], "-s") == 0 && a + 1 < argc) {
	cmpb	$0, 2(%rcx)	 #, MEM <char[1:3]> [(void *)_4]
	jne	.L13	 #,
 # StageC.c:309:         } else if (strcmp(argv[a], "-s") == 0 && a + 1 < argc) {
	leal	1(%rsi), %r14d	 #, _15
 # StageC.c:309:         } else if (strcmp(argv[a], "-s") == 0 && a + 1 < argc) {
	cmpl	%r12d, %r14d	 # argc, _15
	jge	.L14	 #,
 # StageC.c:310:             speed = atof(argv[++a]);
	movq	8(%rbp,%r13,8), %rcx	 # *_18, *_18
	call	atof	 #
	movapd	%xmm0, %xmm6	 # speed, speed
 # StageC.c:311:             if (speed < 0.0) { printf("Speed must be >= 0\n"); return 1; }
	pxor	%xmm0, %xmm0	 # tmp530
	comisd	%xmm6, %xmm0	 # speed, tmp530
	ja	.L231	 #,
 # StageC.c:310:             speed = atof(argv[++a]);
	movl	%r14d, %esi	 # _15, a
 # StageC.c:296:     for (int a = 1; a < argc; a++) {
	addl	$1, %esi	 #, a
 # StageC.c:296:     for (int a = 1; a < argc; a++) {
	cmpl	%esi, %r12d	 # a, argc
	jg	.L30	 #,
 # StageC.c:333:     if (is_test) {
	testl	%r15d, %r15d	 # is_test
	je	.L6	 #,
.L236:
 # StageC.c:334:         short_win = TEST_SHORT;
	movl	$3, short_win(%rip)	 #, short_win
 # StageC.c:335:         long_win = TEST_LONG;
	movl	$5, long_win(%rip)	 #, long_win
.L6:
 # StageC.c:244:     HANDLE h = GetStdHandle(STD_OUTPUT_HANDLE);
	movl	$-11, %ecx	 #,
	call	*__imp_GetStdHandle(%rip)	 #
 # StageC.c:245:     DWORD mode = 0;
	movl	$0, 200(%rsp)	 #, MEM[(long unsigned int *)_743]
 # StageC.c:244:     HANDLE h = GetStdHandle(STD_OUTPUT_HANDLE);
	movq	%rax, %rdi	 #, h
 # StageC.c:246:     if (h != INVALID_HANDLE_VALUE && GetConsoleMode(h, &mode)) {
	cmpq	$-1, %rax	 #, h
	je	.L34	 #,
 # StageC.c:246:     if (h != INVALID_HANDLE_VALUE && GetConsoleMode(h, &mode)) {
	leaq	200(%rsp), %rdx	 #,
	movq	%rax, %rcx	 # h,
	call	*__imp_GetConsoleMode(%rip)	 #
 # StageC.c:246:     if (h != INVALID_HANDLE_VALUE && GetConsoleMode(h, &mode)) {
	testl	%eax, %eax	 # _359
	jne	.L232	 #,
.L34:
 # StageC.c:340:     uint64_t load_start = now_ns();
	call	now_ns	 #
 # StageC.c:112:     FILE *fp = fopen(path, "rb");
	leaq	.LC19(%rip), %rdx	 #,
	movq	%rbx, %rcx	 # path,
 # StageC.c:340:     uint64_t load_start = now_ns();
	movq	%rax, 72(%rsp)	 #, %sfp
 # StageC.c:112:     FILE *fp = fopen(path, "rb");
	call	fopen	 #
	movq	%rax, %rbp	 #, fp
 # StageC.c:113:     if (fp == NULL) return -1;
	testq	%rax, %rax	 # fp
	je	.L233	 #,
 # StageC.c:120:             if (buf[k] == '\n') lines++;
	movl	$168430090, %eax	 #, tmp1156
	movapd	%xmm8, %xmm11	 # tmp1081, tmp1081
 # StageC.c:117:     size_t n, last = '\n';
	movl	$10, %esi	 #, last
 # StageC.c:116:     long long lines = 0;
	xorl	%r14d, %r14d	 # lines
 # StageC.c:120:             if (buf[k] == '\n') lines++;
	movd	%eax, %xmm9	 # tmp1156, tmp1156
	movapd	%xmm7, %xmm10	 # max_minutes, max_minutes
	movapd	%xmm6, %xmm8	 # speed, speed
	leaq	buf.2(%rip), %rdi	 #, tmp1091
	pshufd	$0, %xmm9, %xmm9	 # tmp1156, tmp1157
	.p2align 4
	.p2align 3
.L36:
 # StageC.c:118:     while ((n = fread(buf, 1, sizeof buf, fp)) > 0) {
	movq	%rdi, %rcx	 # tmp1091,
	movq	%rbp, %r9	 # fp,
	movl	$1048576, %r8d	 #,
	movl	$1, %edx	 #,
	call	fread	 #
	movq	%rax, %rcx	 #, n
 # StageC.c:118:     while ((n = fread(buf, 1, sizeof buf, fp)) > 0) {
	testq	%rax, %rax	 # n
	je	.L234	 #,
	leaq	-1(%rcx), %rax	 #, _301
	cmpq	$14, %rax	 #, _301
	jbe	.L153	 #,
	movq	%rcx, %rax	 # n, k
	leaq	buf.2(%rip), %rdx	 #, ivtmp.225
	pxor	%xmm0, %xmm0	 # vect_lines_652.180
	andq	$-16, %rax	 #, k
	leaq	(%rdi,%rax), %r8	 #, _481
	.p2align 4
	.p2align 3
.L39:
 # StageC.c:120:             if (buf[k] == '\n') lines++;
	movdqa	%xmm9, %xmm1	 # tmp1157, tmp584
	pxor	%xmm4, %xmm4	 # tmp587
	addq	$16, %rdx	 #, ivtmp.225
	pcmpeqb	-16(%rdx), %xmm1	 # MEM <vector(16) char> [(char *)_752], tmp584
	pcmpgtb	%xmm1, %xmm4	 # tmp584, tmp587
	movdqa	%xmm1, %xmm2	 # tmp584, tmp588
	punpcklbw	%xmm4, %xmm2	 # tmp587, tmp588
	punpckhbw	%xmm4, %xmm1	 # tmp587, tmp592
	movdqa	%xmm2, %xmm4	 # tmp588, tmp595
	movdqa	%xmm2, %xmm5	 # tmp588, tmp596
	movdqa	%xmm1, %xmm6	 # tmp592, tmp603
	psraw	$15, %xmm4	 #, tmp595
	psraw	$15, %xmm6	 #, tmp603
	punpcklwd	%xmm4, %xmm5	 # tmp595, tmp596
	punpckhwd	%xmm4, %xmm2	 # tmp595, tmp600
	movdqa	%xmm1, %xmm4	 # tmp592, tmp604
	punpcklwd	%xmm6, %xmm4	 # tmp603, tmp604
	punpckhwd	%xmm6, %xmm1	 # tmp603, tmp608
	movdqa	%xmm5, %xmm6	 # tmp596, tmp612
	psrad	$31, %xmm6	 #, tmp612
	movdqa	%xmm5, %xmm7	 # tmp596, tmp613
	punpckldq	%xmm6, %xmm7	 # tmp612, tmp613
	punpckhdq	%xmm6, %xmm5	 # tmp612, tmp618
	movdqa	%xmm2, %xmm6	 # tmp600, tmp623
	psubq	%xmm7, %xmm0	 # tmp613, vect__622.181
	psubq	%xmm5, %xmm0	 # tmp618, vect__622.181
	movdqa	%xmm2, %xmm5	 # tmp600, tmp622
	psrad	$31, %xmm5	 #, tmp622
	punpckldq	%xmm5, %xmm6	 # tmp622, tmp623
	punpckhdq	%xmm5, %xmm2	 # tmp622, tmp628
	movdqa	%xmm4, %xmm5	 # tmp604, tmp632
	psubq	%xmm6, %xmm0	 # tmp623, vect__622.181
	psrad	$31, %xmm5	 #, tmp632
	psubq	%xmm2, %xmm0	 # tmp628, vect__622.181
	movdqa	%xmm4, %xmm2	 # tmp604, tmp633
	punpckldq	%xmm5, %xmm2	 # tmp632, tmp633
	psubq	%xmm2, %xmm0	 # tmp633, vect__622.181
	movdqa	%xmm4, %xmm2	 # tmp604, tmp638
	movdqa	%xmm1, %xmm4	 # tmp608, tmp643
	punpckhdq	%xmm5, %xmm2	 # tmp632, tmp638
	psubq	%xmm2, %xmm0	 # tmp638, vect__622.181
	movdqa	%xmm1, %xmm2	 # tmp608, tmp642
	psrad	$31, %xmm2	 #, tmp642
	punpckldq	%xmm2, %xmm4	 # tmp642, tmp643
	punpckhdq	%xmm2, %xmm1	 # tmp642, tmp648
	psubq	%xmm4, %xmm0	 # tmp643, vect__622.181
	psubq	%xmm1, %xmm0	 # tmp648, vect_lines_652.180
	cmpq	%r8, %rdx	 # _481, ivtmp.225
	jne	.L39	 #,
	movdqa	%xmm0, %xmm1	 # vect_lines_652.180, tmp652
	psrldq	$8, %xmm1	 #, tmp652
	paddq	%xmm1, %xmm0	 # tmp652, tmp650
	movq	%xmm0, %rdx	 # tmp650, tmp649
	addq	%rdx, %r14	 # tmp649, lines
	cmpq	%rax, %rcx	 # k, n
	je	.L40	 #,
	.p2align 5
	.p2align 4
	.p2align 3
.L42:
	cmpb	$10, (%rdi,%rax)	 #, MEM[(char *)&buf + k_499 * 1]
	jne	.L43	 #,
 # StageC.c:120:             if (buf[k] == '\n') lines++;
	addq	$1, %r14	 #, lines
.L43:
 # StageC.c:119:         for (size_t k = 0; k < n; k++) {
	addq	$1, %rax	 #, k
 # StageC.c:119:         for (size_t k = 0; k < n; k++) {
	cmpq	%rcx, %rax	 # n, k
	jb	.L42	 #,
.L40:
 # StageC.c:122:         last = (unsigned char)buf[n - 1];
	movzbl	-1(%rdi,%rcx), %esi	 # buf[_301], last
	jmp	.L36	 #
	.p2align 4,,10
	.p2align 3
.L230:
 # StageC.c:297:         if (strcmp(argv[a], "-f") == 0 && a + 1 < argc) {
	cmpb	$0, 2(%rcx)	 #, MEM <char[1:3]> [(void *)_4]
	jne	.L8	 #,
 # StageC.c:297:         if (strcmp(argv[a], "-f") == 0 && a + 1 < argc) {
	leal	1(%rsi), %r14d	 #, _6
 # StageC.c:297:         if (strcmp(argv[a], "-f") == 0 && a + 1 < argc) {
	cmpl	%r12d, %r14d	 # argc, _6
	jge	.L9	 #,
 # StageC.c:299:             if (strcmp(argv[a], "test") == 0) {
	movq	8(%rbp,%r13,8), %rbx	 # *_9, _10
	leaq	.LC9(%rip), %rdx	 #,
	movq	%rbx, %rcx	 # _10,
	call	strcmp	 #
 # StageC.c:299:             if (strcmp(argv[a], "test") == 0) {
	testl	%eax, %eax	 # _11
	je	.L145	 #,
 # StageC.c:301:             } else if (strcmp(argv[a], "dev") == 0) {
	leaq	.LC10(%rip), %rdx	 #,
	movq	%rbx, %rcx	 # _10,
	call	strcmp	 #
 # StageC.c:301:             } else if (strcmp(argv[a], "dev") == 0) {
	testl	%eax, %eax	 # _12
	je	.L146	 #,
 # StageC.c:303:             } else if (strcmp(argv[a], "stress") == 0) {
	leaq	.LC11(%rip), %rdx	 #,
	movq	%rbx, %rcx	 # _10,
	call	strcmp	 #
 # StageC.c:303:             } else if (strcmp(argv[a], "stress") == 0) {
	testl	%eax, %eax	 # _13
	jne	.L235	 #,
 # StageC.c:298:             a++;
	movl	%r14d, %esi	 # _6, a
 # StageC.c:304:                 path = STRESS_PATH;
	movq	%rdi, %rbx	 # path, path
	.p2align 4
	.p2align 3
.L10:
 # StageC.c:296:     for (int a = 1; a < argc; a++) {
	addl	$1, %esi	 #, a
 # StageC.c:296:     for (int a = 1; a < argc; a++) {
	cmpl	%esi, %r12d	 # a, argc
	jg	.L30	 #,
 # StageC.c:333:     if (is_test) {
	testl	%r15d, %r15d	 # is_test
	jne	.L236	 #,
	jmp	.L6	 #
	.p2align 4,,10
	.p2align 3
.L9:
 # StageC.c:309:         } else if (strcmp(argv[a], "-s") == 0 && a + 1 < argc) {
	cmpl	$115, %edx	 #, MEM <char[1:3]> [(void *)_4]
	jne	.L13	 #,
.L14:
 # StageC.c:314:         } else if (strcmp(argv[a], "-n") == 0) {
	cmpl	$45, %eax	 #, MEM <char[1:3]> [(void *)_4]
	jne	.L24	 #,
	cmpb	$110, 1(%rcx)	 #, MEM <char[1:3]> [(void *)_4]
	jne	.L19	 #,
 # StageC.c:314:         } else if (strcmp(argv[a], "-n") == 0) {
	cmpb	$0, 2(%rcx)	 #, MEM <char[1:3]> [(void *)_4]
	jne	.L19	 #,
 # StageC.c:315:             naive_mode = 1;
	movl	$1, naive_mode(%rip)	 #, naive_mode
	jmp	.L10	 #
	.p2align 4,,10
	.p2align 3
.L13:
 # StageC.c:312:         } else if (strcmp(argv[a], "-m") == 0 && a + 1 < argc) {
	cmpl	$45, %eax	 #, MEM <char[1:3]> [(void *)_4]
	jne	.L24	 #,
	cmpb	$109, 1(%rcx)	 #, MEM <char[1:3]> [(void *)_4]
	jne	.L14	 #,
 # StageC.c:312:         } else if (strcmp(argv[a], "-m") == 0 && a + 1 < argc) {
	cmpb	$0, 2(%rcx)	 #, MEM <char[1:3]> [(void *)_4]
	jne	.L14	 #,
 # StageC.c:312:         } else if (strcmp(argv[a], "-m") == 0 && a + 1 < argc) {
	leal	1(%rsi), %r14d	 #, _21
 # StageC.c:312:         } else if (strcmp(argv[a], "-m") == 0 && a + 1 < argc) {
	cmpl	%r12d, %r14d	 # argc, _21
	jge	.L14	 #,
 # StageC.c:313:             max_minutes = atof(argv[++a]);
	movq	8(%rbp,%r13,8), %rcx	 # *_24, *_24
 # StageC.c:313:             max_minutes = atof(argv[++a]);
	movl	%r14d, %esi	 # _21, a
 # StageC.c:313:             max_minutes = atof(argv[++a]);
	call	atof	 #
	movapd	%xmm0, %xmm7	 # max_minutes, max_minutes
 # StageC.c:313:             max_minutes = atof(argv[++a]);
	jmp	.L10	 #
	.p2align 4,,10
	.p2align 3
.L19:
 # StageC.c:316:         } else if (strcmp(argv[a], "-c") == 0) {
	cmpl	$45, %eax	 #, MEM <char[1:3]> [(void *)_4]
	jne	.L24	 #,
	cmpb	$99, 1(%rcx)	 #, MEM <char[1:3]> [(void *)_4]
	jne	.L172	 #,
 # StageC.c:316:         } else if (strcmp(argv[a], "-c") == 0) {
	cmpb	$0, 2(%rcx)	 #, MEM <char[1:3]> [(void *)_4]
	jne	.L172	 #,
 # StageC.c:317:             use_colour = 1;
	movl	$1, 88(%rsp)	 #, %sfp
	jmp	.L10	 #
	.p2align 4,,10
	.p2align 3
.L145:
 # StageC.c:298:             a++;
	movl	%r14d, %esi	 # _6, a
 # StageC.c:300:                 path = TEST_PATH; is_test = 1;
	movl	$1, %r15d	 #, is_test
 # StageC.c:300:                 path = TEST_PATH; is_test = 1;
	leaq	.LC4(%rip), %rbx	 #, path
	jmp	.L10	 #
	.p2align 4,,10
	.p2align 3
.L146:
 # StageC.c:298:             a++;
	movl	%r14d, %esi	 # _6, a
 # StageC.c:302:                 path = DEV_PATH;
	leaq	.LC3(%rip), %rbx	 #, path
	jmp	.L10	 #
	.p2align 4,,10
	.p2align 3
.L172:
 # StageC.c:318:         } else if (strcmp(argv[a], "-l") == 0) {
	cmpl	$45, %eax	 #, MEM <char[1:3]> [(void *)_4]
	jne	.L24	 #,
	cmpb	$108, 1(%rcx)	 #, MEM <char[1:3]> [(void *)_4]
	je	.L237	 #,
.L173:
 # StageC.c:320:         } else if (strcmp(argv[a], "-q") == 0) {
	cmpl	$45, %eax	 #, MEM <char[1:3]> [(void *)_4]
	jne	.L24	 #,
	cmpb	$113, 1(%rcx)	 #, MEM <char[1:3]> [(void *)_4]
	je	.L238	 #,
.L174:
 # StageC.c:322:         } else if (strcmp(argv[a], "-o") == 0 && a + 1 < argc) {
	cmpl	$45, %eax	 #, MEM <char[1:3]> [(void *)_4]
	jne	.L24	 #,
	cmpb	$111, 1(%rcx)	 #, MEM <char[1:3]> [(void *)_4]
	jne	.L24	 #,
 # StageC.c:322:         } else if (strcmp(argv[a], "-o") == 0 && a + 1 < argc) {
	cmpb	$0, 2(%rcx)	 #, MEM <char[1:3]> [(void *)_4]
	jne	.L24	 #,
 # StageC.c:322:         } else if (strcmp(argv[a], "-o") == 0 && a + 1 < argc) {
	addl	$1, %esi	 #, a
 # StageC.c:322:         } else if (strcmp(argv[a], "-o") == 0 && a + 1 < argc) {
	cmpl	%r12d, %esi	 # argc, a
	jl	.L239	 #,
.L25:
 # StageC.c:329:             printf("Usage: %s [-f test|dev|stress] [-s SPEED] [-m MINUTES] [-n] [-c] [-l] [-q] [-o FILE] [-r US]\n", argv[0]);
	movq	0(%rbp), %rdx	 # *argv_322(D),
	leaq	.LC18(%rip), %rcx	 #,
	call	printf	 #
.L11:
 # StageC.c:307:                 return 1;
	movl	$1, %eax	 #, <retval>
.L5:
 # StageC.c:482: }
	movups	208(%rsp), %xmm6	 #,
	movups	224(%rsp), %xmm7	 #,
	movups	240(%rsp), %xmm8	 #,
	movups	256(%rsp), %xmm9	 #,
	movups	272(%rsp), %xmm10	 #,
	movups	288(%rsp), %xmm11	 #,
	addq	$312, %rsp	 #,
	popq	%rbx	 #
	popq	%rsi	 #
	popq	%rdi	 #
	popq	%rbp	 #
	popq	%r12	 #
	popq	%r13	 #
	popq	%r14	 #
	popq	%r15	 #
	ret	
	.p2align 4,,10
	.p2align 3
.L237:
 # StageC.c:318:         } else if (strcmp(argv[a], "-l") == 0) {
	cmpb	$0, 2(%rcx)	 #, MEM <char[1:3]> [(void *)_4]
	jne	.L173	 #,
 # StageC.c:319:             use_led = 1;
	movl	$1, 112(%rsp)	 #, %sfp
	jmp	.L10	 #
	.p2align 4,,10
	.p2align 3
.L234:
 # StageC.c:124:     fclose(fp);
	movq	%rbp, %rcx	 # fp,
	movapd	%xmm8, %xmm6	 # speed, speed
	movapd	%xmm10, %xmm7	 # max_minutes, max_minutes
	call	fclose	 #
 # StageC.c:125:     if (last != '\n') lines++;      /* final line without a newline */
	xorl	%eax, %eax	 # tmp1099
	cmpq	$10, %rsi	 #, last
 # StageC.c:124:     fclose(fp);
	movapd	%xmm11, %xmm8	 # tmp1081, tmp1081
 # StageC.c:125:     if (last != '\n') lines++;      /* final line without a newline */
	setne	%al	 #, tmp1099
	addq	%rax, %r14	 # tmp1099, lines
 # StageC.c:137:     trades = malloc((size_t)lines * sizeof(Trade));
	movq	%r14, %rcx	 # lines, _343
	salq	$5, %rcx	 #, _343
 # StageC.c:137:     trades = malloc((size_t)lines * sizeof(Trade));
	call	malloc	 #
 # StageC.c:137:     trades = malloc((size_t)lines * sizeof(Trade));
	movq	%rax, trades(%rip)	 # tmp1179, trades
 # StageC.c:138:     if (trades == NULL) {
	testq	%rax, %rax	 # tmp1179
	je	.L240	 #,
 # StageC.c:143:     FILE *fp = fopen(path, "r");
	leaq	.LC23(%rip), %rdx	 #,
	movq	%rbx, %rcx	 # path,
	call	fopen	 #
	movq	%rax, %r12	 #, fp
 # StageC.c:144:     if (fp == NULL) return -1;
	testq	%rax, %rax	 # fp
	je	.L37	 #,
 # StageC.c:146:     long long n = 0;
	xorl	%r15d, %r15d	 # n
	leaq	184(%rsp), %rbp	 #, tmp1082
	leaq	180(%rsp), %rdi	 #, tmp1080
 # StageC.c:149:     while (n < lines && read_trade_fixed(fp, &ts, &price, &qty, &is_buy)) {
	testq	%r14, %r14	 # lines
	jne	.L48	 #,
	jmp	.L49	 #
	.p2align 4,,10
	.p2align 3
.L50:
 # StageC.c:150:         trades[n].ts_us = ts;
	movq	184(%rsp), %xmm0	 # ts, _630
 # StageC.c:150:         trades[n].ts_us = ts;
	movq	%r15, %rax	 # n, _456
 # StageC.c:150:         trades[n].ts_us = ts;
	movhps	192(%rsp), %xmm0	 # price, _630
 # StageC.c:154:         n++;
	addq	$1, %r15	 #, n
 # StageC.c:150:         trades[n].ts_us = ts;
	salq	$5, %rax	 #, _456
	addq	trades(%rip), %rax	 # trades, _350
 # StageC.c:150:         trades[n].ts_us = ts;
	movups	%xmm0, (%rax)	 # _630, MEM <vector(2) long long int> [(long long int *)_350]
 # StageC.c:152:         trades[n].qty = qty;
	movq	200(%rsp), %rdx	 # MEM[(long long int *)_743], MEM[(long long int *)_743]
	movq	%rdx, 16(%rax)	 # MEM[(long long int *)_743], _350->qty
 # StageC.c:153:         trades[n].is_buy = is_buy;
	movl	180(%rsp), %edx	 # is_buy, is_buy
	movl	%edx, 24(%rax)	 # is_buy, _350->is_buy
 # StageC.c:149:     while (n < lines && read_trade_fixed(fp, &ts, &price, &qty, &is_buy)) {
	cmpq	%r15, %r14	 # n, lines
	je	.L49	 #,
.L48:
 # StageC.c:149:     while (n < lines && read_trade_fixed(fp, &ts, &price, &qty, &is_buy)) {
	movq	%rdi, 32(%rsp)	 # tmp1080,
	leaq	200(%rsp), %r9	 #,
	movq	%rbp, %rdx	 # tmp1082,
	movq	%r12, %rcx	 # fp,
	leaq	192(%rsp), %r8	 #,
	call	read_trade_fixed	 #
 # StageC.c:149:     while (n < lines && read_trade_fixed(fp, &ts, &price, &qty, &is_buy)) {
	testl	%eax, %eax	 # _356
	jne	.L50	 #,
	movq	%r15, %r14	 # n, lines
.L49:
 # StageC.c:156:     fclose(fp);
	movq	%r12, %rcx	 # fp,
	call	fclose	 #
.L47:
 # StageC.c:341:     trade_count = load_trades(path);
	movq	%r14, trade_count(%rip)	 # lines, trade_count
 # StageC.c:342:     double load_s = (now_ns() - load_start) / 1e9;
	call	now_ns	 #
 # StageC.c:343:     if (trade_count < 0) return 1;
	movq	trade_count(%rip), %rdi	 # trade_count, replay_n
	movq	%rdi, 64(%rsp)	 # replay_n, %sfp
 # StageC.c:343:     if (trade_count < 0) return 1;
	testq	%rdi, %rdi	 # replay_n
	js	.L11	 #,
 # StageC.c:344:     if (trade_count < long_win) {
	movslq	long_win(%rip), %rdx	 # long_win,
	movq	%rdx, %r9	 #,
 # StageC.c:344:     if (trade_count < long_win) {
	cmpq	%rdx, %rdi	 # _52, replay_n
	jl	.L241	 #,
 # StageC.c:342:     double load_s = (now_ns() - load_start) / 1e9;
	subq	72(%rsp), %rax	 # %sfp, _48
	js	.L52	 #,
	pxor	%xmm3, %xmm3	 # _49
	cvtsi2sdq	%rax, %xmm3	 # _48, _49
.L53:
 # StageC.c:351:     if (max_minutes > 0.0) {
	pxor	%xmm0, %xmm0	 # tmp679
 # StageC.c:354:         while (k < trade_count && trades[k].ts_us - trades[0].ts_us <= limit_us) k++;
	movq	trades(%rip), %rcx	 # trades, pretmp_780
 # StageC.c:342:     double load_s = (now_ns() - load_start) / 1e9;
	divsd	.LC25(%rip), %xmm3	 #, load_s
 # StageC.c:351:     if (max_minutes > 0.0) {
	comisd	%xmm0, %xmm7	 # tmp679, max_minutes
 # StageC.c:354:         while (k < trade_count && trades[k].ts_us - trades[0].ts_us <= limit_us) k++;
	movq	(%rcx), %r8	 # pretmp_780->ts_us, pretmp_781
 # StageC.c:351:     if (max_minutes > 0.0) {
	jbe	.L222	 #,
 # StageC.c:354:         while (k < trade_count && trades[k].ts_us - trades[0].ts_us <= limit_us) k++;
	cmpq	$0, 64(%rsp)	 #, %sfp
	je	.L222	 #,
 # StageC.c:352:         long long limit_us = (long long)(max_minutes * 60.0 * 1e6);
	mulsd	.LC26(%rip), %xmm7	 #, _53
	movq	64(%rsp), %r11	 # %sfp, replay_n
 # StageC.c:353:         long long k = 0;
	xorl	%eax, %eax	 # k
 # StageC.c:352:         long long limit_us = (long long)(max_minutes * 60.0 * 1e6);
	movsd	.LC27(%rip), %xmm9	 #, tmp1087
	mulsd	%xmm9, %xmm7	 # tmp1087, _54
 # StageC.c:352:         long long limit_us = (long long)(max_minutes * 60.0 * 1e6);
	cvttsd2siq	%xmm7, %r10	 # _54, limit_us
	jmp	.L56	 #
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L57:
 # StageC.c:354:         while (k < trade_count && trades[k].ts_us - trades[0].ts_us <= limit_us) k++;
	addq	$1, %rax	 #, k
 # StageC.c:354:         while (k < trade_count && trades[k].ts_us - trades[0].ts_us <= limit_us) k++;
	cmpq	%rax, %r11	 # k, replay_n
	je	.L54	 #,
.L56:
 # StageC.c:354:         while (k < trade_count && trades[k].ts_us - trades[0].ts_us <= limit_us) k++;
	movq	%rax, %rdx	 # k, _417
	salq	$5, %rdx	 #, _417
 # StageC.c:354:         while (k < trade_count && trades[k].ts_us - trades[0].ts_us <= limit_us) k++;
	movq	(%rcx,%rdx), %rdx	 # MEM[(long long int *)pretmp_780 + _417 * 1], MEM[(long long int *)pretmp_780 + _417 * 1]
	subq	%r8, %rdx	 # pretmp_781, _61
 # StageC.c:354:         while (k < trade_count && trades[k].ts_us - trades[0].ts_us <= limit_us) k++;
	cmpq	%r10, %rdx	 # limit_us, _61
	jle	.L57	 #,
 # StageC.c:355:         replay_n = k;
	movq	%rax, 64(%rsp)	 # k, %sfp
.L54:
 # StageC.c:357:     double market_span_s = (trades[replay_n - 1].ts_us - trades[0].ts_us) / 1e6;
	movq	64(%rsp), %rax	 # %sfp, tmp688
 # StageC.c:357:     double market_span_s = (trades[replay_n - 1].ts_us - trades[0].ts_us) / 1e6;
	pxor	%xmm0, %xmm0	 # _69
 # StageC.c:357:     double market_span_s = (trades[replay_n - 1].ts_us - trades[0].ts_us) / 1e6;
	salq	$5, %rax	 #, tmp688
 # StageC.c:357:     double market_span_s = (trades[replay_n - 1].ts_us - trades[0].ts_us) / 1e6;
	movq	-32(%rax,%rcx), %rax	 # _65->ts_us, _65->ts_us
	subq	%r8, %rax	 # pretmp_781, _68
 # StageC.c:359:     printf("Stage C replay: %s, windows %d/%d, %s SMA, speed %s\n",
	movl	short_win(%rip), %r8d	 # short_win, pretmp_777
 # StageC.c:357:     double market_span_s = (trades[replay_n - 1].ts_us - trades[0].ts_us) / 1e6;
	cvtsi2sdq	%rax, %xmm0	 # _68, _69
 # StageC.c:357:     double market_span_s = (trades[replay_n - 1].ts_us - trades[0].ts_us) / 1e6;
	divsd	%xmm9, %xmm0	 # tmp1087, _69
 # StageC.c:360:            path, short_win, long_win, naive_mode ? "naive" : "running-sum",
	movl	naive_mode(%rip), %eax	 # naive_mode, pretmp_776
 # StageC.c:357:     double market_span_s = (trades[replay_n - 1].ts_us - trades[0].ts_us) / 1e6;
	movq	%xmm0, %r13	 # _69, market_span_s
 # StageC.c:359:     printf("Stage C replay: %s, windows %d/%d, %s SMA, speed %s\n",
	pxor	%xmm0, %xmm0	 # tmp694
	ucomisd	%xmm0, %xmm6	 # tmp694, speed
	jp	.L168	 #,
	je	.L58	 #,
.L168:
 # StageC.c:359:     printf("Stage C replay: %s, windows %d/%d, %s SMA, speed %s\n",
	testl	%eax, %eax	 # pretmp_776
	jne	.L155	 #,
 # StageC.c:359:     printf("Stage C replay: %s, windows %d/%d, %s SMA, speed %s\n",
	leaq	.LC6(%rip), %rax	 #, iftmp.13_217
.L60:
 # StageC.c:359:     printf("Stage C replay: %s, windows %d/%d, %s SMA, speed %s\n",
	leaq	.LC29(%rip), %rdi	 #, tmp1311
	movq	%rax, 32(%rsp)	 # iftmp.13_217,
	movq	%rbx, %rdx	 # path,
	leaq	.LC28(%rip), %rcx	 #,
	movq	%rdi, 40(%rsp)	 # tmp1311,
	movsd	%xmm3, 72(%rsp)	 # load_s, %sfp
	call	printf	 #
 # StageC.c:363:            trade_count, trade_count * sizeof(Trade) / 1048576.0, load_s);
	movq	trade_count(%rip), %rdx	 # trade_count, trade_count.17_72
 # StageC.c:362:     printf("Trades loaded: %lld (malloc %.1f MB)   load time %.3f s\n",
	movsd	72(%rsp), %xmm3	 # %sfp, load_s
	movq	%rdx, %rax	 # trade_count.17_72, _74
	salq	$5, %rax	 #, _74
	js	.L61	 #,
	pxor	%xmm2, %xmm2	 # _75
	cvtsi2sdq	%rax, %xmm2	 # _74, _75
.L62:
	movsd	.LC30(%rip), %xmm7	 #, tmp1088
	movq	%xmm3, %r9	 # load_s,
	leaq	.LC31(%rip), %rcx	 #,
	mulsd	%xmm7, %xmm2	 # tmp1088, _75
	movapd	%xmm7, %xmm10	 # tmp1088, tmp1088
	movq	%xmm2, %r8	 # _75, _76
	call	printf	 #
 # StageC.c:364:     printf("Replaying %lld trades covering %.1f s of market time", replay_n, market_span_s);
	movq	64(%rsp), %rdx	 # %sfp,
	movq	%r13, %r8	 # market_span_s,
	movq	%r13, %xmm2	 # market_span_s,
	leaq	.LC32(%rip), %rcx	 #,
	call	printf	 #
 # StageC.c:365:     if (speed > 0.0) printf(" at %gx (about %.1f s)", speed, market_span_s / speed);
	pxor	%xmm0, %xmm0	 # tmp716
	comisd	%xmm0, %xmm6	 # tmp716, speed
	jbe	.L63	 #,
 # StageC.c:365:     if (speed > 0.0) printf(" at %gx (about %.1f s)", speed, market_span_s / speed);
	movq	%r13, %xmm3	 # market_span_s, _77
	movapd	%xmm6, %xmm1	 # speed,
	movq	%xmm6, %rdx	 # speed,
	divsd	%xmm6, %xmm3	 # speed, _77
	leaq	.LC33(%rip), %rcx	 #,
	movq	%xmm3, %r8	 # _77, _77
	movapd	%xmm3, %xmm2	 # _77,
	call	printf	 #
	jmp	.L63	 #
.L153:
 # StageC.c:119:         for (size_t k = 0; k < n; k++) {
	xorl	%eax, %eax	 # k
	jmp	.L42	 #
.L238:
 # StageC.c:320:         } else if (strcmp(argv[a], "-q") == 0) {
	cmpb	$0, 2(%rcx)	 #, MEM <char[1:3]> [(void *)_4]
	jne	.L174	 #,
 # StageC.c:321:             quiet = 1;
	movl	$1, 116(%rsp)	 #, %sfp
	jmp	.L10	 #
.L229:
 # StageC.c:327:             rival_ns = (uint64_t)(r_us * 1000.0 + 0.5);
	cvttsd2siq	%xmm0, %rax	 # _43, tmp562
	movq	%rax, rival_ns(%rip)	 # tmp562, rival_ns
	jmp	.L10	 #
.L239:
 # StageC.c:323:             log_path = argv[++a];
	movq	8(%rbp,%r13,8), %rax	 # *_34, *_34
	movq	%rax, log_path(%rip)	 # *_34, log_path
	jmp	.L10	 #
.L58:
 # StageC.c:359:     printf("Stage C replay: %s, windows %d/%d, %s SMA, speed %s\n",
	testl	%eax, %eax	 # pretmp_776
	jne	.L139	 #,
 # StageC.c:359:     printf("Stage C replay: %s, windows %d/%d, %s SMA, speed %s\n",
	leaq	.LC62(%rip), %rax	 #, tmp1401
	movsd	%xmm3, 72(%rsp)	 # load_s, %sfp
	movq	%rax, 40(%rsp)	 # tmp1401,
	leaq	.LC6(%rip), %rax	 #, tmp1402
.L226:
	movq	%rax, 32(%rsp)	 # tmp1402,
	movq	%rbx, %rdx	 # path,
	leaq	.LC28(%rip), %rcx	 #,
	call	printf	 #
 # StageC.c:363:            trade_count, trade_count * sizeof(Trade) / 1048576.0, load_s);
	movq	trade_count(%rip), %rdx	 # trade_count, trade_count.17_564
 # StageC.c:362:     printf("Trades loaded: %lld (malloc %.1f MB)   load time %.3f s\n",
	movsd	72(%rsp), %xmm3	 # %sfp, load_s
	movq	%rdx, %rax	 # trade_count.17_564, _734
	salq	$5, %rax	 #, _734
	js	.L141	 #,
	pxor	%xmm2, %xmm2	 # _62
	cvtsi2sdq	%rax, %xmm2	 # _734, _62
.L142:
	movsd	.LC30(%rip), %xmm7	 #, tmp1088
	leaq	.LC31(%rip), %rcx	 #,
	movq	%xmm3, %r9	 # load_s,
	mulsd	%xmm7, %xmm2	 # tmp1088, _62
	movapd	%xmm7, %xmm10	 # tmp1088, tmp1088
	movq	%xmm2, %r8	 # _62, _778
	call	printf	 #
 # StageC.c:364:     printf("Replaying %lld trades covering %.1f s of market time", replay_n, market_span_s);
	movq	64(%rsp), %rdx	 # %sfp,
	movq	%r13, %r8	 # market_span_s,
	movq	%r13, %xmm2	 # market_span_s,
	leaq	.LC32(%rip), %rcx	 #,
	call	printf	 #
.L63:
 # StageC.c:366:     printf("\n\n");
	leaq	.LC34(%rip), %rcx	 #,
	call	puts	 #
 # StageC.c:368:     if (use_led) led_init();
	cmpl	$0, 112(%rsp)	 #, %sfp
	jne	.L242	 #,
 # StageC.c:369:     rival_init(&rival);
	leaq	rival(%rip), %rax	 #, tmp1085
	movq	%rax, %rcx	 # tmp1085,
	movq	%rax, 144(%rsp)	 # tmp1085, %sfp
	call	rival_init	 #
 # StageC.c:376:     long long ts0 = trades[0].ts_us;
	movq	trades(%rip), %rax	 # trades, trades
	movq	(%rax), %rax	 # trades.20_522->ts_us, ts0
	movq	%rax, 168(%rsp)	 # ts0, %sfp
 # StageC.c:378:     uint64_t t_start = now_ns();
	call	now_ns	 #
	movq	%rax, 160(%rsp)	 # t_start, %sfp
 # StageC.c:381:     for (long long i = 0; i < replay_n; i++) {
	cmpq	$0, 64(%rsp)	 #, %sfp
	je	.L135	 #,
.L223:
 # StageC.c:372:     unsigned long long lat_sum = 0, lat_max = 0;
	xorl	%r14d, %r14d	 #
 # StageC.c:379:     uint64_t next_status = t_start + 1000000000ULL;
	addq	$1000000000, %rax	 #, next_status
 # timing.h:32:   static inline void sleep_ms(int ms) { Sleep((DWORD)ms); }
	movq	%r13, %xmm11	 # market_span_s, market_span_s
 # StageC.c:359:     printf("Stage C replay: %s, windows %d/%d, %s SMA, speed %s\n",
	xorl	%ebp, %ebp	 # ivtmp.204
 # StageC.c:372:     unsigned long long lat_sum = 0, lat_max = 0;
	movq	%r14, 96(%rsp)	 #, %sfp
	movq	__imp_QueryPerformanceCounter(%rip), %rdi	 #, tmp1092
	leaq	200(%rsp), %rsi	 #, tmp1084
 # timing.h:32:   static inline void sleep_ms(int ms) { Sleep((DWORD)ms); }
	xorl	%r13d, %r13d	 # ivtmp.206
 # StageC.c:379:     uint64_t next_status = t_start + 1000000000ULL;
	movq	%rax, 136(%rsp)	 # next_status, %sfp
 # StageC.c:387:             release = t_start + (uint64_t)((double)gap_us * 1000.0 / speed);
	movsd	.LC17(%rip), %xmm7	 #, tmp1149
 # StageC.c:372:     unsigned long long lat_sum = 0, lat_max = 0;
	movq	%r14, 80(%rsp)	 #, %sfp
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	movq	__imp_QueryPerformanceFrequency(%rip), %r15	 #, tmp1150
 # StageC.c:372:     unsigned long long lat_sum = 0, lat_max = 0;
	movq	%r14, 128(%rsp)	 #, %sfp
 # StageC.c:372:     unsigned long long lat_sum = 0, lat_max = 0;
	movq	%r14, 72(%rsp)	 #, %sfp
	movq	%r14, 120(%rsp)	 #, %sfp
	.p2align 4
	.p2align 3
.L110:
 # StageC.c:384:         if (speed > 0.0) {
	pxor	%xmm0, %xmm0	 # tmp729
	comisd	%xmm0, %xmm6	 # tmp729, speed
	jbe	.L217	 #,
 # StageC.c:385:             long long gap_us = trades[i].ts_us - ts0;
	movq	trades(%rip), %rax	 # trades, trades
 # StageC.c:386:             if (gap_us < 0) gap_us = 0;
	movl	$0, %edx	 #, tmp1209
 # StageC.c:387:             release = t_start + (uint64_t)((double)gap_us * 1000.0 / speed);
	pxor	%xmm0, %xmm0	 # _84
 # StageC.c:385:             long long gap_us = trades[i].ts_us - ts0;
	movq	(%rax,%r13), %rax	 # _82->ts_us, _82->ts_us
	subq	168(%rsp), %rax	 # %sfp, gap_us_294
 # StageC.c:386:             if (gap_us < 0) gap_us = 0;
	cmovs	%rdx, %rax	 # gap_us_294,, tmp1209, gap_us_294
 # StageC.c:387:             release = t_start + (uint64_t)((double)gap_us * 1000.0 / speed);
	cvtsi2sdq	%rax, %xmm0	 # gap_us_294, _84
 # StageC.c:387:             release = t_start + (uint64_t)((double)gap_us * 1000.0 / speed);
	mulsd	%xmm8, %xmm0	 # tmp1081, _85
 # StageC.c:387:             release = t_start + (uint64_t)((double)gap_us * 1000.0 / speed);
	divsd	%xmm6, %xmm0	 # speed, _86
 # StageC.c:387:             release = t_start + (uint64_t)((double)gap_us * 1000.0 / speed);
	comisd	%xmm7, %xmm0	 # tmp1149, _86
	jnb	.L69	 #,
	cvttsd2siq	%xmm0, %rbx	 # _86, _87
.L70:
 # StageC.c:387:             release = t_start + (uint64_t)((double)gap_us * 1000.0 / speed);
	addq	160(%rsp), %rbx	 # %sfp, release
	jmp	.L73	 #
	.p2align 4,,10
	.p2align 3
.L71:
 # timing.h:26:       QueryPerformanceCounter(&count);
	movq	%rsi, %rcx	 # tmp1084,
	call	*%rdi	 # tmp1092
 # timing.h:28:       uint64_t f = (uint64_t)freq.QuadPart, c = (uint64_t)count.QuadPart;
	movq	freq.0(%rip), %r8	 # freq.QuadPart, f
	movq	200(%rsp), %rax	 # MEM[(union _LARGE_INTEGER *)_743].QuadPart, MEM[(union _LARGE_INTEGER *)_743].QuadPart
	xorl	%edx, %edx	 # tmp747
	divq	%r8	 # f
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	imulq	$1000000000, %rax, %rcx	 #, MEM[(union _LARGE_INTEGER *)_743].QuadPart, _389
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	imulq	$1000000000, %rdx, %rax	 #, tmp747, _391
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	xorl	%edx, %edx	 # tmp752
	divq	%r8	 # f
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	addq	%rcx, %rax	 # _389, _393
 # StageC.c:233:         if (now >= target) return;
	cmpq	%rbx, %rax	 # release, _393
	jnb	.L72	 #,
 # StageC.c:234:         uint64_t remaining = target - now;
	movq	%rbx, %rdx	 # release, remaining
	subq	%rax, %rdx	 # _393, remaining
 # StageC.c:235:         if (remaining > SLEEP_MARGIN_NS + 1000000ULL) {
	cmpq	$21000000, %rdx	 #, remaining
	ja	.L243	 #,
.L73:
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	movl	ready.1(%rip), %r12d	 # ready,
	testl	%r12d, %r12d	 #
	jne	.L71	 #,
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	leaq	freq.0(%rip), %rcx	 #,
	call	*%r15	 # tmp1150
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	movl	$1, ready.1(%rip)	 #, ready
	jmp	.L71	 #
.L222:
	movsd	.LC27(%rip), %xmm9	 #, tmp1087
	jmp	.L54	 #
.L232:
 # StageC.c:247:         SetConsoleMode(h, mode | 0x0004);   /* ENABLE_VIRTUAL_TERMINAL_PROCESSING */
	movl	200(%rsp), %edx	 # MEM[(long unsigned int *)_743], _361
 # StageC.c:247:         SetConsoleMode(h, mode | 0x0004);   /* ENABLE_VIRTUAL_TERMINAL_PROCESSING */
	movq	%rdi, %rcx	 # h,
 # StageC.c:247:         SetConsoleMode(h, mode | 0x0004);   /* ENABLE_VIRTUAL_TERMINAL_PROCESSING */
	orl	$4, %edx	 #, _361
 # StageC.c:247:         SetConsoleMode(h, mode | 0x0004);   /* ENABLE_VIRTUAL_TERMINAL_PROCESSING */
	call	*__imp_SetConsoleMode(%rip)	 #
	jmp	.L34	 #
.L139:
 # StageC.c:359:     printf("Stage C replay: %s, windows %d/%d, %s SMA, speed %s\n",
	leaq	.LC62(%rip), %rax	 #, tmp1391
	movsd	%xmm3, 72(%rsp)	 # load_s, %sfp
	movq	%rax, 40(%rsp)	 # tmp1391,
	leaq	.LC5(%rip), %rax	 #, tmp1392
	jmp	.L226	 #
.L155:
 # StageC.c:359:     printf("Stage C replay: %s, windows %d/%d, %s SMA, speed %s\n",
	leaq	.LC5(%rip), %rax	 #, iftmp.13_217
	jmp	.L60	 #
.L241:
 # StageC.c:345:         printf("Not enough trades (%lld) for the long window (%d)\n", trade_count, long_win);
	movl	%edx, %r8d	 # long_win.1_51,
	leaq	.LC24(%rip), %rcx	 #,
	movq	%rdi, %rdx	 # replay_n,
	call	printf	 #
 # StageC.c:346:         return 1;
	jmp	.L11	 #
	.p2align 4,,10
	.p2align 3
.L217:
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	movl	ready.1(%rip), %ebx	 # ready,
	testl	%ebx, %ebx	 #
	je	.L244	 #,
.L75:
 # timing.h:26:       QueryPerformanceCounter(&count);
	movq	%rsi, %rcx	 # tmp1084,
	call	*%rdi	 # tmp1092
 # timing.h:28:       uint64_t f = (uint64_t)freq.QuadPart, c = (uint64_t)count.QuadPart;
	movq	freq.0(%rip), %r8	 # freq.QuadPart, f
	movq	200(%rsp), %rax	 # MEM[(union _LARGE_INTEGER *)_743].QuadPart, MEM[(union _LARGE_INTEGER *)_743].QuadPart
	xorl	%edx, %edx	 # tmp765
	divq	%r8	 # f
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	imulq	$1000000000, %rax, %rcx	 #, MEM[(union _LARGE_INTEGER *)_743].QuadPart, _400
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	imulq	$1000000000, %rdx, %rax	 #, tmp765, _402
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	xorl	%edx, %edx	 # tmp770
	divq	%r8	 # f
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	leaq	(%rax,%rcx), %rbx	 #, release
.L72:
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	movl	ready.1(%rip), %r11d	 # ready,
	testl	%r11d, %r11d	 #
	je	.L245	 #,
.L76:
 # timing.h:26:       QueryPerformanceCounter(&count);
	movq	%rsi, %rcx	 # tmp1084,
	call	*%rdi	 # tmp1092
 # timing.h:28:       uint64_t f = (uint64_t)freq.QuadPart, c = (uint64_t)count.QuadPart;
	movq	freq.0(%rip), %rcx	 # freq.QuadPart, f
	xorl	%edx, %edx	 # tmp777
	movq	200(%rsp), %rax	 # MEM[(union _LARGE_INTEGER *)_743].QuadPart, MEM[(union _LARGE_INTEGER *)_743].QuadPart
 # StageC.c:187:     long long p = trades[i].price;
	movq	trades(%rip), %r8	 # trades, trades.80_416
 # StageC.c:193:     if (naive_mode) {
	movl	naive_mode(%rip), %r10d	 # naive_mode,
	divq	%rcx	 # f
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	imulq	$1000000000, %rax, %r12	 #, tmp776, _495
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	imulq	$1000000000, %rdx, %rax	 #, tmp777, _497
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	xorl	%edx, %edx	 # tmp781
	divq	%rcx	 # f
	movq	%rax, %r14	 # _497, _498
 # StageC.c:187:     long long p = trades[i].price;
	leaq	(%r8,%r13), %rax	 #, ivtmp.195
 # StageC.c:187:     long long p = trades[i].price;
	movq	8(%rax), %rdx	 # _419->price, p
 # StageC.c:188:     long long q = trades[i].qty;
	movq	16(%rax), %rcx	 # _419->qty, q
 # StageC.c:191:     total_q += q;
	addq	%rcx, total_q(%rip)	 # q, total_q
 # StageC.c:190:     total_pq += p * q;
	movq	%rdx, %r9	 # p, _422
	imulq	%rcx, %r9	 # q, _422
 # StageC.c:190:     total_pq += p * q;
	addq	%r9, total_pq(%rip)	 # _422, total_pq
 # StageC.c:194:         if (i >= short_win - 1) {
	movslq	short_win(%rip), %r9	 # short_win,
 # StageC.c:193:     if (naive_mode) {
	testl	%r10d, %r10d	 #
	je	.L77	 #,
 # StageC.c:194:         if (i >= short_win - 1) {
	leal	-1(%r9), %edx	 #, _429
	movslq	%edx, %rdx	 # _429, _430
 # StageC.c:194:         if (i >= short_win - 1) {
	cmpq	%rbp, %rdx	 # ivtmp.204, _430
	jg	.L78	 #,
 # StageC.c:196:             for (int k = 0; k < short_win; k++) s += trades[i - k].price;
	testl	%r9d, %r9d	 # pretmp_771
	jle	.L156	 #,
	movslq	%r9d, %rcx	 # pretmp_771, _314
	movq	%r8, %r10	 # trades.80_416, _727
	movq	%rax, %rdx	 # ivtmp.195, ivtmp.201
	salq	$5, %rcx	 #, _302
	subq	%rcx, %r10	 # _302, _727
 # StageC.c:195:             long long s = 0;
	xorl	%ecx, %ecx	 # s
	addq	%r13, %r10	 # ivtmp.206, _367
	.p2align 4
	.p2align 4
	.p2align 3
.L80:
 # StageC.c:196:             for (int k = 0; k < short_win; k++) s += trades[i - k].price;
	addq	8(%rdx), %rcx	 # MEM[(long long int *)_636 + 8B], s
 # StageC.c:196:             for (int k = 0; k < short_win; k++) s += trades[i - k].price;
	subq	$32, %rdx	 #, ivtmp.201
	cmpq	%rdx, %r10	 # ivtmp.201, _367
	jne	.L80	 #,
.L79:
 # StageC.c:197:             short_sum = s;
	movq	%rcx, short_sum(%rip)	 # s, short_sum
.L78:
 # StageC.c:199:         if (i >= long_win - 1) {
	movslq	long_win(%rip), %rdx	 # long_win,
	leal	-1(%rdx), %ecx	 #, _442
	movslq	%ecx, %rcx	 # _442, _443
 # StageC.c:199:         if (i >= long_win - 1) {
	cmpq	%rbp, %rcx	 # ivtmp.204, _443
	jg	.L88	 #,
 # StageC.c:201:             for (int k = 0; k < long_win; k++) s += trades[i - k].price;
	testl	%edx, %edx	 # long_win.90_441
	jle	.L157	 #,
	movq	%rdx, %rcx	 # _467, _377
	salq	$5, %rcx	 #, _377
	subq	%rcx, %r8	 # _377, _726
 # StageC.c:200:             long long s = 0;
	xorl	%ecx, %ecx	 # s
	addq	%r13, %r8	 # ivtmp.206, _366
	.p2align 4
	.p2align 4
	.p2align 3
.L84:
 # StageC.c:201:             for (int k = 0; k < long_win; k++) s += trades[i - k].price;
	addq	8(%rax), %rcx	 # MEM[(long long int *)_55 + 8B], s
 # StageC.c:201:             for (int k = 0; k < long_win; k++) s += trades[i - k].price;
	subq	$32, %rax	 #, ivtmp.195
	cmpq	%rax, %r8	 # ivtmp.195, _366
	jne	.L84	 #,
.L83:
 # StageC.c:202:             long_sum = s;
	movq	%rcx, long_sum(%rip)	 # s, long_sum
 # StageC.c:213:         long long d = short_sum * long_win - long_sum * short_win;
	movq	%rdx, %rax	 # _467, _467
.L85:
	imulq	short_sum(%rip), %rax	 # short_sum, _479
 # StageC.c:214:         if (have_prev) {
	movl	have_prev(%rip), %r11d	 # have_prev, signal
 # StageC.c:213:         long long d = short_sum * long_win - long_sum * short_win;
	imulq	%rcx, %r9	 # s, _483
 # StageC.c:213:         long long d = short_sum * long_win - long_sum * short_win;
	subq	%r9, %rax	 # _483, d
 # StageC.c:214:         if (have_prev) {
	testl	%r11d, %r11d	 # signal
	je	.L89	 #,
 # StageC.c:215:             if (prev_d <= 0 && d > 0) signal = 1;
	movq	prev_d(%rip), %rdx	 # prev_d, prev_d.109_486
 # StageC.c:215:             if (prev_d <= 0 && d > 0) signal = 1;
	testq	%rdx, %rdx	 # prev_d.109_486
	jle	.L246	 #,
.L90:
 # StageC.c:216:             else if (prev_d >= 0 && d < 0) signal = -1;
	movq	%rax, %rcx	 # d, tmp1336
	sarq	$63, %rcx	 #, tmp1336
	movq	%rcx, %r11	 # tmp1336, signal
.L89:
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	movl	ready.1(%rip), %r8d	 # ready,
 # StageC.c:218:         prev_d = d;
	movq	%rax, prev_d(%rip)	 # d, prev_d
 # StageC.c:219:         have_prev = 1;
	movl	$1, have_prev(%rip)	 #, have_prev
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	testl	%r8d, %r8d	 #
	je	.L247	 #,
.L91:
	movl	%r11d, 104(%rsp)	 # signal, %sfp
 # timing.h:26:       QueryPerformanceCounter(&count);
	movq	%rsi, %rcx	 # tmp1084,
	call	*%rdi	 # tmp1092
 # timing.h:28:       uint64_t f = (uint64_t)freq.QuadPart, c = (uint64_t)count.QuadPart;
	movq	freq.0(%rip), %r8	 # freq.QuadPart, f
	xorl	%edx, %edx	 # tmp822
 # StageC.c:409:         if (signal != 0) {
	movl	104(%rsp), %r11d	 # %sfp, signal
	movq	200(%rsp), %rax	 # MEM[(union _LARGE_INTEGER *)_743].QuadPart, MEM[(union _LARGE_INTEGER *)_743].QuadPart
	divq	%r8	 # f
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	imulq	$1000000000, %rax, %rcx	 #, MEM[(union _LARGE_INTEGER *)_743].QuadPart, _411
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	imulq	$1000000000, %rdx, %rax	 #, tmp822, _413
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	xorl	%edx, %edx	 # tmp827
	divq	%r8	 # f
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	leaq	(%rax,%rcx), %r10	 #, _415
 # StageC.c:398:         uint64_t proc_ns = decided - before;
	movq	%r10, %rax	 # _415, _638
	subq	%r14, %rax	 # _498, _638
	subq	%r12, %rax	 # _495, _638
 # StageC.c:399:         uint64_t latency_ns = decided - release;
	movq	%r10, %r12	 # _415, latency_ns
 # StageC.c:398:         uint64_t proc_ns = decided - before;
	movq	%rax, %r14	 # _638, proc_ns
 # StageC.c:399:         uint64_t latency_ns = decided - release;
	subq	%rbx, %r12	 # release, latency_ns
 # StageC.c:409:         if (signal != 0) {
	testl	%r11d, %r11d	 # signal
	jne	.L92	 #,
	addq	$1, %rbp	 #, ivtmp.204
.L93:
 # StageC.c:403:         if (latency_ns > lat_max) lat_max = latency_ns;
	movq	72(%rsp), %rax	 # %sfp, lat_max
 # StageC.c:402:         lat_sum += latency_ns;
	addq	%r12, 120(%rsp)	 # lag_ns, %sfp
 # StageC.c:420:         if (!quiet && decided >= next_status) {
	movl	116(%rsp), %ecx	 # %sfp,
 # StageC.c:403:         if (latency_ns > lat_max) lat_max = latency_ns;
	cmpq	%r12, %rax	 # lag_ns, lat_max
	cmovb	%r12, %rax	 # lat_max,, lag_ns, lat_max
 # StageC.c:404:         proc_sum += proc_ns;
	addq	%r14, 128(%rsp)	 # proc_ns, %sfp
 # StageC.c:403:         if (latency_ns > lat_max) lat_max = latency_ns;
	movq	%rax, 72(%rsp)	 # lat_max, %sfp
 # StageC.c:405:         if (proc_ns > proc_max) proc_max = proc_ns;
	movq	80(%rsp), %rax	 # %sfp, proc_max
	cmpq	%r14, %rax	 # proc_ns, proc_max
	cmovnb	%rax, %r14	 # proc_max,, proc_ns
 # StageC.c:406:         if (lag_ns > lag_max_ns) lag_max_ns = lag_ns;
	movq	96(%rsp), %rax	 # %sfp, lag_max_ns
	cmpq	%r12, %rax	 # lag_ns, lag_max_ns
 # StageC.c:405:         if (proc_ns > proc_max) proc_max = proc_ns;
	movq	%r14, 80(%rsp)	 # proc_ns, %sfp
 # StageC.c:406:         if (lag_ns > lag_max_ns) lag_max_ns = lag_ns;
	cmovl	%r12, %rax	 # lag_max_ns,, lag_ns, lag_max_ns
	movq	%rax, 96(%rsp)	 # lag_max_ns, %sfp
 # StageC.c:420:         if (!quiet && decided >= next_status) {
	testl	%ecx, %ecx	 #
	jne	.L109	 #,
	cmpq	136(%rsp), %r10	 # %sfp, _415
	jb	.L109	 #,
 # StageC.c:421:             printf("\r  replayed %5.1f%%  | lag %9.3f ms | BUY %lld SELL %lld | P&L %.2f   ",
	movq	144(%rsp), %rcx	 # %sfp,
	movq	%r10, 104(%rsp)	 # _415, %sfp
	call	rival_pnl	 #
 # StageC.c:421:             printf("\r  replayed %5.1f%%  | lag %9.3f ms | BUY %lld SELL %lld | P&L %.2f   ",
	pxor	%xmm1, %xmm1	 # _116
 # StageC.c:421:             printf("\r  replayed %5.1f%%  | lag %9.3f ms | BUY %lld SELL %lld | P&L %.2f   ",
	pxor	%xmm2, %xmm2	 # _121
	cvtsi2sdq	64(%rsp), %xmm2	 # %sfp, _121
 # StageC.c:421:             printf("\r  replayed %5.1f%%  | lag %9.3f ms | BUY %lld SELL %lld | P&L %.2f   ",
	cvtsi2sdq	%r12, %xmm1	 # lag_ns, _116
	divsd	%xmm9, %xmm1	 # tmp1087, _116
 # StageC.c:421:             printf("\r  replayed %5.1f%%  | lag %9.3f ms | BUY %lld SELL %lld | P&L %.2f   ",
	movq	sell_count(%rip), %rax	 # sell_count, sell_count
	movq	buy_count(%rip), %r9	 # buy_count,
	movsd	%xmm0, 40(%rsp)	 # _113,
	leaq	.LC43(%rip), %rcx	 #,
	movq	%rax, 32(%rsp)	 # sell_count,
 # StageC.c:421:             printf("\r  replayed %5.1f%%  | lag %9.3f ms | BUY %lld SELL %lld | P&L %.2f   ",
	movq	%xmm1, %r8	 # _116, _117
 # StageC.c:422:                    100.0 * (i + 1) / replay_n, lag_ns / 1e6, buy_count, sell_count,
	pxor	%xmm1, %xmm1	 # _119
	cvtsi2sdq	%rbp, %xmm1	 # ivtmp.204, _119
	mulsd	.LC37(%rip), %xmm1	 #, _120
 # StageC.c:421:             printf("\r  replayed %5.1f%%  | lag %9.3f ms | BUY %lld SELL %lld | P&L %.2f   ",
	divsd	%xmm2, %xmm1	 # _121, _122
	movq	%r8, %xmm2	 # _117,
	movq	%xmm1, %rdx	 # _122,
	call	printf	 #
 # StageC.c:424:             fflush(stdout);
	movl	$1, %ecx	 #,
	call	*__imp___acrt_iob_func(%rip)	 #
 # StageC.c:424:             fflush(stdout);
	movq	%rax, %rcx	 # _123,
	call	fflush	 #
 # StageC.c:425:             next_status = decided + 1000000000ULL;
	movq	104(%rsp), %r10	 # %sfp, _415
	leaq	1000000000(%r10), %rax	 #, next_status
	movq	%rax, 136(%rsp)	 # next_status, %sfp
.L109:
 # StageC.c:381:     for (long long i = 0; i < replay_n; i++) {
	addq	$32, %r13	 #, ivtmp.206
	cmpq	%rbp, 64(%rsp)	 # ivtmp.204, %sfp
	jg	.L110	 #,
 # StageC.c:429:     uint64_t t_end = now_ns();
	call	now_ns	 #
	movq	%xmm11, %r13	 # market_span_s, market_span_s
	movq	%rax, %rbx	 # t_end, t_end
 # StageC.c:430:     if (use_led) {
	cmpl	$0, 112(%rsp)	 #, %sfp
	jne	.L134	 #,
.L111:
 # StageC.c:435:     if (!quiet) printf("\r%79s\r", "");
	cmpl	$0, 116(%rsp)	 #, %sfp
	je	.L248	 #,
.L112:
 # StageC.c:438:     double wall_s = (t_end - t_start) / 1e9;
	subq	160(%rsp), %rbx	 # %sfp, _124
	js	.L113	 #,
	pxor	%xmm7, %xmm7	 # _125
	cvtsi2sdq	%rbx, %xmm7	 # _124, _125
.L114:
 # StageC.c:439:     double final_vwap = total_q > 0 ? (double)total_pq / (double)total_q / SCALE_P : 0.0;
	movq	total_q(%rip), %rax	 # total_q, total_q.36_126
 # StageC.c:439:     double final_vwap = total_q > 0 ? (double)total_pq / (double)total_q / SCALE_P : 0.0;
	pxor	%xmm1, %xmm1	 # final_vwap
 # StageC.c:438:     double wall_s = (t_end - t_start) / 1e9;
	divsd	.LC25(%rip), %xmm7	 #, wall_s
 # StageC.c:439:     double final_vwap = total_q > 0 ? (double)total_pq / (double)total_q / SCALE_P : 0.0;
	testq	%rax, %rax	 # total_q.36_126
	jle	.L115	 #,
 # StageC.c:439:     double final_vwap = total_q > 0 ? (double)total_pq / (double)total_q / SCALE_P : 0.0;
	pxor	%xmm0, %xmm0	 # _129
 # StageC.c:439:     double final_vwap = total_q > 0 ? (double)total_pq / (double)total_q / SCALE_P : 0.0;
	pxor	%xmm1, %xmm1	 # _128
	cvtsi2sdq	total_pq(%rip), %xmm1	 # total_pq, _128
 # StageC.c:439:     double final_vwap = total_q > 0 ? (double)total_pq / (double)total_q / SCALE_P : 0.0;
	cvtsi2sdq	%rax, %xmm0	 # total_q.36_126, _129
 # StageC.c:439:     double final_vwap = total_q > 0 ? (double)total_pq / (double)total_q / SCALE_P : 0.0;
	divsd	%xmm0, %xmm1	 # _129, _130
 # StageC.c:439:     double final_vwap = total_q > 0 ? (double)total_pq / (double)total_q / SCALE_P : 0.0;
	divsd	.LC37(%rip), %xmm1	 #, final_vwap
.L115:
 # StageC.c:441:     printf("\n--- Replay results ---\n");
	leaq	.LC45(%rip), %rcx	 #,
	movsd	%xmm1, 88(%rsp)	 # final_vwap, %sfp
	call	puts	 #
 # StageC.c:442:     printf("Trades replayed      : %lld\n", replay_n);
	movq	64(%rsp), %rdx	 # %sfp,
	leaq	.LC46(%rip), %rcx	 #,
	call	printf	 #
 # StageC.c:443:     printf("Signals              : %lld BUY, %lld SELL\n", buy_count, sell_count);
	movq	sell_count(%rip), %r8	 # sell_count,
	movq	buy_count(%rip), %rdx	 # buy_count,
	leaq	.LC47(%rip), %rcx	 #,
	call	printf	 #
 # StageC.c:444:     printf("Final VWAP           : %.8f\n", final_vwap);
	movsd	88(%rsp), %xmm1	 # %sfp, final_vwap
	leaq	.LC48(%rip), %rcx	 #,
	movq	%xmm1, %rdx	 # final_vwap,
	call	printf	 #
 # StageC.c:445:     printf("Wall time            : %.3f s", wall_s);
	movapd	%xmm7, %xmm1	 # wall_s,
	movq	%xmm7, %rdx	 # wall_s,
	leaq	.LC49(%rip), %rcx	 #,
	call	printf	 #
 # StageC.c:446:     if (speed > 0.0) printf("   (ideal %.3f s)", market_span_s / speed);
	pxor	%xmm0, %xmm0	 # tmp913
	comisd	%xmm0, %xmm6	 # tmp913, speed
	jbe	.L116	 #,
 # StageC.c:446:     if (speed > 0.0) printf("   (ideal %.3f s)", market_span_s / speed);
	movq	%r13, %xmm1	 # market_span_s, market_span_s
	leaq	.LC50(%rip), %rcx	 #,
	divsd	%xmm6, %xmm1	 # speed, market_span_s
	movq	%xmm1, %rdx	 # _133,
	call	printf	 #
.L116:
 # StageC.c:447:     printf("\n");
	movl	$10, %ecx	 #,
 # StageC.c:448:     printf("Processing per trade : avg %.1f ns, worst %.3f us\n",
	pxor	%xmm6, %xmm6	 # _137
 # StageC.c:447:     printf("\n");
	call	putchar	 #
 # StageC.c:448:     printf("Processing per trade : avg %.1f ns, worst %.3f us\n",
	movq	80(%rsp), %rax	 # %sfp, proc_max
	cvtsi2sdq	64(%rsp), %xmm6	 # %sfp, _137
	testq	%rax, %rax	 # proc_max
	js	.L118	 #,
	pxor	%xmm2, %xmm2	 # _134
	cvtsi2sdq	%rax, %xmm2	 # proc_max, _134
.L119:
	divsd	%xmm8, %xmm2	 # tmp1081, _134
 # StageC.c:449:            (double)proc_sum / replay_n, proc_max / 1000.0);
	movq	128(%rsp), %rax	 # %sfp, proc_sum
 # StageC.c:448:     printf("Processing per trade : avg %.1f ns, worst %.3f us\n",
	movq	%xmm2, %r8	 # _134, _135
 # StageC.c:449:            (double)proc_sum / replay_n, proc_max / 1000.0);
	testq	%rax, %rax	 # proc_sum
	js	.L120	 #,
	pxor	%xmm1, %xmm1	 # _136
	cvtsi2sdq	%rax, %xmm1	 # proc_sum, _136
.L121:
 # StageC.c:448:     printf("Processing per trade : avg %.1f ns, worst %.3f us\n",
	divsd	%xmm6, %xmm1	 # _137, _138
	movq	%r8, %xmm2	 # _135,
	leaq	.LC51(%rip), %rcx	 #,
	movq	%xmm1, %rdx	 # _138,
	call	printf	 #
 # StageC.c:450:     printf("Latency per trade    : avg %.3f us, worst %.3f us\n",
	movq	72(%rsp), %rax	 # %sfp, lat_max
	testq	%rax, %rax	 # lat_max
	js	.L122	 #,
	pxor	%xmm2, %xmm2	 # _139
	cvtsi2sdq	%rax, %xmm2	 # lat_max, _139
.L123:
	divsd	%xmm8, %xmm2	 # tmp1081, _139
 # StageC.c:451:            (double)lat_sum / replay_n / 1000.0, lat_max / 1000.0);
	movq	120(%rsp), %rax	 # %sfp, lat_sum
 # StageC.c:450:     printf("Latency per trade    : avg %.3f us, worst %.3f us\n",
	movq	%xmm2, %r8	 # _139, _140
 # StageC.c:451:            (double)lat_sum / replay_n / 1000.0, lat_max / 1000.0);
	testq	%rax, %rax	 # lat_sum
	js	.L124	 #,
	pxor	%xmm1, %xmm1	 # _141
	cvtsi2sdq	%rax, %xmm1	 # lat_sum, _141
.L125:
 # StageC.c:451:            (double)lat_sum / replay_n / 1000.0, lat_max / 1000.0);
	divsd	%xmm6, %xmm1	 # _137, _143
 # StageC.c:450:     printf("Latency per trade    : avg %.3f us, worst %.3f us\n",
	movq	%r8, %xmm2	 # _140,
	leaq	.LC52(%rip), %rcx	 #,
	divsd	%xmm8, %xmm1	 # tmp1081, _144
	movq	%xmm1, %rdx	 # _144,
	call	printf	 #
 # StageC.c:452:     printf("Lag behind replay    : worst %.3f ms, at end %.3f ms\n",
	pxor	%xmm0, %xmm0	 # _145
	pxor	%xmm1, %xmm1	 # _147
	cvtsi2sdq	96(%rsp), %xmm1	 # %sfp, _147
	cvtsi2sdq	%r12, %xmm0	 # lag_ns, _145
	divsd	%xmm9, %xmm1	 # tmp1087, _148
	leaq	.LC53(%rip), %rcx	 #,
	divsd	%xmm9, %xmm0	 # tmp1087, _145
	movq	%xmm1, %rdx	 # _148,
	movq	%xmm0, %r8	 # _145, _146
	movapd	%xmm0, %xmm2	 # _146,
	call	printf	 #
 # StageC.c:454:     printf("Rival bot (R = %.2f us): P&L %.2f USDT, races won %lld, lost %lld%s\n",
	cmpl	$0, 8+rival(%rip)	 #, rival.holding
	je	.L163	 #,
 # StageC.c:454:     printf("Rival bot (R = %.2f us): P&L %.2f USDT, races won %lld, lost %lld%s\n",
	leaq	.LC7(%rip), %rdi	 #, iftmp.41_219
.L126:
 # StageC.c:454:     printf("Rival bot (R = %.2f us): P&L %.2f USDT, races won %lld, lost %lld%s\n",
	movq	144(%rsp), %rcx	 # %sfp,
	movq	40+rival(%rip), %rsi	 # rival.races_lost, _150
	movq	32+rival(%rip), %rbx	 # rival.races_won, _151
	call	rival_pnl	 #
 # StageC.c:454:     printf("Rival bot (R = %.2f us): P&L %.2f USDT, races won %lld, lost %lld%s\n",
	movq	rival_ns(%rip), %rax	 # rival_ns, rival_ns
 # StageC.c:454:     printf("Rival bot (R = %.2f us): P&L %.2f USDT, races won %lld, lost %lld%s\n",
	movq	%xmm0, %r8	 #, _152
 # StageC.c:454:     printf("Rival bot (R = %.2f us): P&L %.2f USDT, races won %lld, lost %lld%s\n",
	testq	%rax, %rax	 # rival_ns
	js	.L127	 #,
	pxor	%xmm1, %xmm1	 # _154
	cvtsi2sdq	%rax, %xmm1	 # rival_ns, _154
.L128:
	divsd	%xmm8, %xmm1	 # tmp1081, _155
	movq	%rdi, 40(%rsp)	 # iftmp.41_219,
	movq	%r8, %xmm2	 # _152,
	movq	%rbx, %r9	 # _151,
	movq	%rsi, 32(%rsp)	 # _150,
	leaq	.LC54(%rip), %rcx	 #,
	movq	%xmm1, %rdx	 # _155,
	call	printf	 #
 # StageC.c:458:     printf("\n--- Memory ---\n");
	leaq	.LC55(%rip), %rcx	 #,
	call	puts	 #
 # StageC.c:459:     printf("malloc array (exact fit) : %.1f MB for %lld trades\n",
	movq	trade_count(%rip), %r8	 # trade_count, trade_count.43_156
	movq	%r8, %rax	 # trade_count.43_156, _159
	salq	$5, %rax	 #, _159
	js	.L129	 #,
	pxor	%xmm1, %xmm1	 # _160
	cvtsi2sdq	%rax, %xmm1	 # _159, _160
.L130:
	mulsd	%xmm10, %xmm1	 # tmp1088, _161
	leaq	.LC56(%rip), %rcx	 #,
	movq	%xmm1, %rdx	 # _161,
	call	printf	 #
 # StageC.c:461:     printf("Stage B fixed array      : %.1f MB reserved (MAX_TRADES = %d)\n",
	movsd	.LC69(%rip), %xmm1	 #,
	movl	$10000000, %r8d	 #,
	movabsq	$0x407312d000000000, %rdx	 #,
	leaq	.LC57(%rip), %rcx	 #,
	call	printf	 #
 # StageC.c:466:     FILE *log = fopen(log_path, "w");
	movq	log_path(%rip), %rcx	 # log_path,
	leaq	.LC58(%rip), %rdx	 #,
	call	fopen	 #
	movq	%rax, %rsi	 #, log
 # StageC.c:467:     if (log != NULL) {
	testq	%rax, %rax	 # log
	je	.L131	 #,
 # StageC.c:468:         fprintf(log, "trade_index,ts_us,price_fx,side,proc_ns,latency_ns\n");
	movq	%rax, %r9	 # log,
	movl	$51, %r8d	 #,
	movl	$1, %edx	 #,
 # StageC.c:469:         for (long long s = 0; s < sig_count; s++) {
	xorl	%ebx, %ebx	 # s
 # StageC.c:468:         fprintf(log, "trade_index,ts_us,price_fx,side,proc_ns,latency_ns\n");
	leaq	.LC59(%rip), %rcx	 #,
	call	fwrite	 #
 # StageC.c:469:         for (long long s = 0; s < sig_count; s++) {
	cmpq	$0, sig_count(%rip)	 #, sig_count
	jle	.L133	 #,
	.p2align 4
	.p2align 3
.L132:
 # StageC.c:470:             long long ti = sig_log[s].trade_index;
	movq	%rbx, %rax	 # s, _535
 # StageC.c:469:         for (long long s = 0; s < sig_count; s++) {
	addq	$1, %rbx	 #, s
 # StageC.c:470:             long long ti = sig_log[s].trade_index;
	salq	$5, %rax	 #, _535
	addq	sig_log(%rip), %rax	 # sig_log, _166
 # StageC.c:470:             long long ti = sig_log[s].trade_index;
	movq	(%rax), %r8	 # _166->trade_index, ti
 # StageC.c:471:             fprintf(log, "%lld,%lld,%lld,%d,%llu,%llu\n", ti, trades[ti].ts_us,
	movq	24(%rax), %rcx	 # _166->latency_ns, _166->latency_ns
 # StageC.c:472:                     trades[ti].price, sig_log[s].side, sig_log[s].proc_ns,
	movq	%r8, %rdx	 # ti, _175
	salq	$5, %rdx	 #, _175
	addq	trades(%rip), %rdx	 # trades, _176
 # StageC.c:471:             fprintf(log, "%lld,%lld,%lld,%d,%llu,%llu\n", ti, trades[ti].ts_us,
	movq	(%rdx), %r9	 # _176->ts_us, _176->ts_us
	movq	%rcx, 56(%rsp)	 # _166->latency_ns,
	movq	16(%rax), %rcx	 # _166->proc_ns, _166->proc_ns
	movq	%rcx, 48(%rsp)	 # _166->proc_ns,
	movl	8(%rax), %eax	 # _166->side, _166->side
	movq	%rsi, %rcx	 # log,
	movl	%eax, 40(%rsp)	 # _166->side,
	movq	8(%rdx), %rax	 # _176->price, _176->price
	leaq	.LC61(%rip), %rdx	 #,
	movq	%rax, 32(%rsp)	 # _176->price,
	call	fprintf	 #
 # StageC.c:469:         for (long long s = 0; s < sig_count; s++) {
	cmpq	%rbx, sig_count(%rip)	 # s, sig_count
	jg	.L132	 #,
.L133:
 # StageC.c:475:         fclose(log);
	movq	%rsi, %rcx	 # log,
	call	fclose	 #
 # StageC.c:476:         printf("\nWrote %lld signals to %s\n", sig_count, log_path);
	movq	log_path(%rip), %r8	 # log_path,
	movq	sig_count(%rip), %rdx	 # sig_count,
	leaq	.LC60(%rip), %rcx	 #,
	call	printf	 #
.L131:
 # StageC.c:479:     free(sig_log);
	movq	sig_log(%rip), %rcx	 # sig_log,
	call	free	 #
 # StageC.c:480:     free(trades);
	movq	trades(%rip), %rcx	 # trades,
	call	free	 #
 # StageC.c:481:     return 0;
	xorl	%eax, %eax	 # <retval>
	jmp	.L5	 #
	.p2align 4,,10
	.p2align 3
.L243:
 # StageC.c:236:             sleep_ms((int)((remaining - SLEEP_MARGIN_NS) / 1000000ULL));
	movabsq	$4835703278458516699, %rax	 #, remaining
	mulq	%rdx	 # remaining
	shrq	$18, %rdx	 #, _380
 # timing.h:32:   static inline void sleep_ms(int ms) { Sleep((DWORD)ms); }
	leal	-20(%rdx), %ecx	 #, _381
	call	*__imp_Sleep(%rip)	 #
 # timing.h:32:   static inline void sleep_ms(int ms) { Sleep((DWORD)ms); }
	jmp	.L73	 #
	.p2align 4,,10
	.p2align 3
.L77:
 # StageC.c:205:         short_sum += p;
	movq	short_sum(%rip), %rax	 # short_sum, _455
	addq	%rdx, %rax	 # p, _455
	movq	%rax, short_sum(%rip)	 # _455, short_sum
 # StageC.c:206:         if (i >= short_win) short_sum -= trades[i - short_win].price;
	cmpq	%rbp, %r9	 # ivtmp.204, _457
	jg	.L86	 #,
 # StageC.c:206:         if (i >= short_win) short_sum -= trades[i - short_win].price;
	movq	%rbp, %rcx	 # ivtmp.204, _458
	subq	%r9, %rcx	 # _457, _458
 # StageC.c:206:         if (i >= short_win) short_sum -= trades[i - short_win].price;
	salq	$5, %rcx	 #, tmp801
 # StageC.c:206:         if (i >= short_win) short_sum -= trades[i - short_win].price;
	subq	8(%r8,%rcx), %rax	 # _461->price, _463
	movq	%rax, short_sum(%rip)	 # _463, short_sum
.L86:
 # StageC.c:208:         if (i >= long_win) long_sum -= trades[i - long_win].price;
	movslq	long_win(%rip), %rax	 # long_win,
 # StageC.c:207:         long_sum += p;
	addq	long_sum(%rip), %rdx	 # long_sum, _465
	movq	%rdx, long_sum(%rip)	 # _465, long_sum
 # StageC.c:208:         if (i >= long_win) long_sum -= trades[i - long_win].price;
	movq	%rax, %rcx	 #,
 # StageC.c:208:         if (i >= long_win) long_sum -= trades[i - long_win].price;
	cmpq	%rbp, %rax	 # ivtmp.204, _467
	jg	.L87	 #,
 # StageC.c:208:         if (i >= long_win) long_sum -= trades[i - long_win].price;
	movq	%rbp, %r10	 # ivtmp.204, _468
	subq	%rax, %r10	 # _467, _468
 # StageC.c:208:         if (i >= long_win) long_sum -= trades[i - long_win].price;
	salq	$5, %r10	 #, tmp807
 # StageC.c:208:         if (i >= long_win) long_sum -= trades[i - long_win].price;
	subq	8(%r8,%r10), %rdx	 # _471->price, _473
	movq	%rdx, long_sum(%rip)	 # _473, long_sum
.L87:
 # StageC.c:212:     if (i >= long_win - 1) {
	subl	$1, %ecx	 #, _475
	movslq	%ecx, %rcx	 # _475, _476
 # StageC.c:212:     if (i >= long_win - 1) {
	cmpq	%rbp, %rcx	 # ivtmp.204, _476
	jg	.L88	 #,
 # StageC.c:213:         long long d = short_sum * long_win - long_sum * short_win;
	movq	long_sum(%rip), %rcx	 # long_sum, s
	jmp	.L85	 #
	.p2align 4,,10
	.p2align 3
.L92:
 # StageC.c:410:             if (signal == 1) buy_count++; else sell_count++;
	cmpl	$1, %r11d	 #, signal
	je	.L249	 #,
 # StageC.c:410:             if (signal == 1) buy_count++; else sell_count++;
	addq	$1, sell_count(%rip)	 #, sell_count
.L95:
 # StageC.c:254:     if (sig_count == sig_cap) {
	movq	sig_count(%rip), %rbx	 # sig_count, sig_count.111_500
 # StageC.c:254:     if (sig_count == sig_cap) {
	cmpq	sig_cap(%rip), %rbx	 # sig_cap, sig_count.111_500
	je	.L250	 #,
.L96:
 # StageC.c:263:     sig_log[sig_count].trade_index = i;
	movq	%rbx, %rax	 # sig_count.111_500, _510
 # StageC.c:267:     sig_count++;
	addq	$1, %rbx	 #, tmp836
 # StageC.c:413:             rival_on_signal(&rival, signal, trades[i].price,
	movq	rival_ns(%rip), %rdx	 # rival_ns, rival_ns.25_92
 # StageC.c:263:     sig_log[sig_count].trade_index = i;
	salq	$5, %rax	 #, _510
	addq	sig_log(%rip), %rax	 # sig_log, _511
 # StageC.c:267:     sig_count++;
	movq	%rbx, sig_count(%rip)	 # tmp836, sig_count
 # StageC.c:263:     sig_log[sig_count].trade_index = i;
	movq	%rbp, (%rax)	 # ivtmp.204, _511->trade_index
 # StageC.c:414:                             (i + 1 < trade_count) ? trades[i + 1].price : trades[i].price,
	addq	$1, %rbp	 #, ivtmp.204
 # StageC.c:413:             rival_on_signal(&rival, signal, trades[i].price,
	cmpq	trade_count(%rip), %rbp	 # trade_count, ivtmp.204
 # StageC.c:264:     sig_log[sig_count].side = side;
	movl	%r11d, 8(%rax)	 # signal, _511->side
 # StageC.c:265:     sig_log[sig_count].proc_ns = proc_ns;
	movq	%r14, 16(%rax)	 # proc_ns, _511->proc_ns
 # StageC.c:266:     sig_log[sig_count].latency_ns = latency_ns;
	movq	%r12, 24(%rax)	 # latency_ns, _511->latency_ns
 # StageC.c:414:                             (i + 1 < trade_count) ? trades[i + 1].price : trades[i].price,
	movq	trades(%rip), %rax	 # trades, pretmp_768
 # StageC.c:413:             rival_on_signal(&rival, signal, trades[i].price,
	movq	8(%rax,%r13), %r8	 # _769->price, pretmp_770
	movq	%r8, %r9	 # pretmp_770, iftmp.26_218
 # StageC.c:413:             rival_on_signal(&rival, signal, trades[i].price,
	jge	.L99	 #,
 # StageC.c:413:             rival_on_signal(&rival, signal, trades[i].price,
	movq	40(%rax,%r13), %r9	 # _99->price, iftmp.26_218
.L99:
 # StageC.c:413:             rival_on_signal(&rival, signal, trades[i].price,
	movq	%rdx, 40(%rsp)	 # rival_ns.25_92,
	movq	144(%rsp), %rcx	 # %sfp,
	movl	%r11d, %edx	 # signal,
	movq	%r14, 32(%rsp)	 # proc_ns,
	movq	%r10, 152(%rsp)	 # _415, %sfp
	movl	%r11d, 104(%rsp)	 # signal, %sfp
	call	rival_on_signal	 #
 # StageC.c:416:             if (use_colour || use_led) show_signal(signal, i, latency_ns, use_colour, use_led);
	movl	88(%rsp), %eax	 # %sfp, tmp1211
	orl	112(%rsp), %eax	 # %sfp, tmp1211
	movl	104(%rsp), %r11d	 # %sfp, signal
	movq	152(%rsp), %r10	 # %sfp, _415
	je	.L93	 #,
 # StageC.c:276:     if (use_colour) {
	cmpl	$0, 88(%rsp)	 #, %sfp
	jne	.L101	 #,
 # StageC.c:282:         if (side == 1) { led_off(LED_RED);   led_on(LED_GREEN); }
	subl	$1, %r11d	 #, signal
	je	.L102	 #,
.L103:
 # led.h:74:     printf("[LED %s %s]\n", led_name[led], on ? "ON" : "OFF");
	leaq	.LC38(%rip), %r8	 #,
	leaq	.LC42(%rip), %rdx	 #,
	movq	%r10, 104(%rsp)	 # _415, %sfp
	leaq	.LC40(%rip), %rcx	 #,
	call	printf	 #
	leaq	.LC41(%rip), %r8	 #,
	leaq	.LC39(%rip), %rdx	 #,
	leaq	.LC40(%rip), %rcx	 #,
	call	printf	 #
	movq	104(%rsp), %r10	 # %sfp, _415
 # led.h:77: static inline void led_on(int led)  { led_set(led, 1); }
	jmp	.L93	 #
	.p2align 4,,10
	.p2align 3
.L88:
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	movl	ready.1(%rip), %r8d	 # ready,
 # StageC.c:211:     int signal = 0;
	xorl	%r11d, %r11d	 # signal
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	testl	%r8d, %r8d	 #
	jne	.L91	 #,
.L247:
	movl	%r11d, 104(%rsp)	 # signal, %sfp
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	leaq	freq.0(%rip), %rcx	 #,
	call	*__imp_QueryPerformanceFrequency(%rip)	 #
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	movl	104(%rsp), %r11d	 # %sfp, signal
	movl	$1, ready.1(%rip)	 #, ready
	jmp	.L91	 #
	.p2align 4,,10
	.p2align 3
.L245:
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	leaq	freq.0(%rip), %rcx	 #,
	call	*%r15	 # tmp1150
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	movl	$1, ready.1(%rip)	 #, ready
	jmp	.L76	 #
	.p2align 4,,10
	.p2align 3
.L69:
 # StageC.c:387:             release = t_start + (uint64_t)((double)gap_us * 1000.0 / speed);
	subsd	%xmm7, %xmm0	 # tmp1149, tmp739
	cvttsd2siq	%xmm0, %rbx	 # tmp739, _87
	btcq	$63, %rbx	 #, _87
	jmp	.L70	 #
.L249:
 # StageC.c:410:             if (signal == 1) buy_count++; else sell_count++;
	addq	$1, buy_count(%rip)	 #, buy_count
	jmp	.L95	 #
.L250:
 # StageC.c:255:         sig_cap = sig_cap ? sig_cap * 2 : 65536;
	testq	%rbx, %rbx	 # sig_count.111_500
	movl	$65536, %eax	 #, tmp1107
	leaq	(%rbx,%rbx), %rdx	 #, iftmp.113_502
 # StageC.c:256:         SignalRecord *bigger = realloc(sig_log, (size_t)sig_cap * sizeof(SignalRecord));
	movq	sig_log(%rip), %rcx	 # sig_log,
 # StageC.c:255:         sig_cap = sig_cap ? sig_cap * 2 : 65536;
	cmove	%rax, %rdx	 # iftmp.113_502,, tmp1107, iftmp.113_503
	movl	%r11d, 152(%rsp)	 # signal, %sfp
	movq	%r10, 104(%rsp)	 # _415, %sfp
 # StageC.c:255:         sig_cap = sig_cap ? sig_cap * 2 : 65536;
	movq	%rdx, sig_cap(%rip)	 # iftmp.113_503, sig_cap
 # StageC.c:256:         SignalRecord *bigger = realloc(sig_log, (size_t)sig_cap * sizeof(SignalRecord));
	salq	$5, %rdx	 #, _505
 # StageC.c:256:         SignalRecord *bigger = realloc(sig_log, (size_t)sig_cap * sizeof(SignalRecord));
	call	realloc	 #
 # StageC.c:257:         if (bigger == NULL) {
	movq	104(%rsp), %r10	 # %sfp, _415
	movl	152(%rsp), %r11d	 # %sfp, signal
	testq	%rax, %rax	 # bigger
	je	.L251	 #,
 # StageC.c:261:         sig_log = bigger;
	movq	%rax, sig_log(%rip)	 # bigger, sig_log
	jmp	.L96	 #
.L244:
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	leaq	freq.0(%rip), %rcx	 #,
	call	*__imp_QueryPerformanceFrequency(%rip)	 #
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	movl	$1, ready.1(%rip)	 #, ready
	jmp	.L75	 #
.L246:
 # StageC.c:215:             if (prev_d <= 0 && d > 0) signal = 1;
	movl	$1, %r11d	 #, signal
 # StageC.c:215:             if (prev_d <= 0 && d > 0) signal = 1;
	testq	%rax, %rax	 # d
	jg	.L89	 #,
 # StageC.c:211:     int signal = 0;
	xorl	%r11d, %r11d	 # signal
 # StageC.c:216:             else if (prev_d >= 0 && d < 0) signal = -1;
	testq	%rdx, %rdx	 # prev_d.109_486
	jne	.L89	 #,
	jmp	.L90	 #
.L101:
 # StageC.c:275:     double price = (double)trades[i].price / SCALE_P;
	movq	trades(%rip), %rax	 # trades, trades
 # StageC.c:275:     double price = (double)trades[i].price / SCALE_P;
	pxor	%xmm1, %xmm1	 # _518
	cvtsi2sdq	8(%rax,%r13), %xmm1	 # _516->price, _518
 # StageC.c:275:     double price = (double)trades[i].price / SCALE_P;
	divsd	.LC37(%rip), %xmm1	 #, price
 # StageC.c:277:         printf("%s%-4s trade %-8lld price %.2f  latency %.2f us%s\n",
	testq	%r12, %r12	 # latency_ns
	js	.L104	 #,
	pxor	%xmm0, %xmm0	 # _520
	cvtsi2sdq	%r12, %xmm0	 # latency_ns, _520
.L105:
	divsd	%xmm8, %xmm0	 # tmp1081, _521
	subl	$1, %r11d	 #, signal
	je	.L252	 #,
 # StageC.c:277:         printf("%s%-4s trade %-8lld price %.2f  latency %.2f us%s\n",
	leaq	.LC66(%rip), %rax	 #, tmp1399
	movsd	%xmm0, 40(%rsp)	 # _521,
	movq	%rbp, %r9	 # ivtmp.204,
	leaq	.LC67(%rip), %r8	 #,
	movq	%rax, 48(%rsp)	 # tmp1399,
	leaq	.LC68(%rip), %rdx	 #,
	leaq	.LC65(%rip), %rcx	 #,
	movsd	%xmm1, 32(%rsp)	 # price,
	movq	%r10, 104(%rsp)	 # _415, %sfp
	call	printf	 #
 # StageC.c:281:     if (use_led) {
	cmpl	$0, 112(%rsp)	 #, %sfp
	movq	104(%rsp), %r10	 # %sfp, _415
	je	.L93	 #,
	jmp	.L103	 #
.L163:
 # StageC.c:454:     printf("Rival bot (R = %.2f us): P&L %.2f USDT, races won %lld, lost %lld%s\n",
	leaq	.LC8(%rip), %rdi	 #, iftmp.41_219
	jmp	.L126	 #
.L124:
 # StageC.c:451:            (double)lat_sum / replay_n / 1000.0, lat_max / 1000.0);
	movq	120(%rsp), %rdi	 # %sfp, lat_sum
	pxor	%xmm1, %xmm1	 # tmp947
	movq	%rdi, %rax	 # lat_sum, tmp948
	andl	$1, %edi	 #, lat_sum
	shrq	%rax	 # tmp948
	orq	%rdi, %rax	 # lat_sum, tmp948
	cvtsi2sdq	%rax, %xmm1	 # tmp948, tmp947
	addsd	%xmm1, %xmm1	 # tmp947, _141
	jmp	.L125	 #
.L52:
 # StageC.c:342:     double load_s = (now_ns() - load_start) / 1e9;
	movq	%rax, %rdx	 # _48, tmp676
	andl	$1, %eax	 #, tmp677
	pxor	%xmm3, %xmm3	 # tmp675
	shrq	%rdx	 # tmp676
	orq	%rax, %rdx	 # tmp677, tmp676
	cvtsi2sdq	%rdx, %xmm3	 # tmp676, tmp675
	addsd	%xmm3, %xmm3	 # tmp675, _49
	jmp	.L53	 #
.L122:
 # StageC.c:450:     printf("Latency per trade    : avg %.3f us, worst %.3f us\n",
	movq	72(%rsp), %rdi	 # %sfp, lat_max
	pxor	%xmm2, %xmm2	 # tmp938
	movq	%rdi, %rax	 # lat_max, tmp939
	andl	$1, %edi	 #, lat_max
	shrq	%rax	 # tmp939
	orq	%rdi, %rax	 # lat_max, tmp939
	cvtsi2sdq	%rax, %xmm2	 # tmp939, tmp938
	addsd	%xmm2, %xmm2	 # tmp938, _139
	jmp	.L123	 #
.L120:
 # StageC.c:449:            (double)proc_sum / replay_n, proc_max / 1000.0);
	movq	128(%rsp), %rdi	 # %sfp, proc_sum
	pxor	%xmm1, %xmm1	 # tmp929
	movq	%rdi, %rax	 # proc_sum, tmp930
	andl	$1, %edi	 #, proc_sum
	shrq	%rax	 # tmp930
	orq	%rdi, %rax	 # proc_sum, tmp930
	cvtsi2sdq	%rax, %xmm1	 # tmp930, tmp929
	addsd	%xmm1, %xmm1	 # tmp929, _136
	jmp	.L121	 #
.L118:
 # StageC.c:448:     printf("Processing per trade : avg %.1f ns, worst %.3f us\n",
	movq	80(%rsp), %rdi	 # %sfp, proc_max
	pxor	%xmm2, %xmm2	 # tmp920
	movq	%rdi, %rax	 # proc_max, tmp921
	andl	$1, %edi	 #, proc_max
	shrq	%rax	 # tmp921
	orq	%rdi, %rax	 # proc_max, tmp921
	cvtsi2sdq	%rax, %xmm2	 # tmp921, tmp920
	addsd	%xmm2, %xmm2	 # tmp920, _134
	jmp	.L119	 #
.L113:
 # StageC.c:438:     double wall_s = (t_end - t_start) / 1e9;
	movq	%rbx, %rax	 # _124, tmp893
	andl	$1, %ebx	 #, tmp894
	pxor	%xmm7, %xmm7	 # tmp892
	shrq	%rax	 # tmp893
	orq	%rbx, %rax	 # tmp894, tmp893
	cvtsi2sdq	%rax, %xmm7	 # tmp893, tmp892
	addsd	%xmm7, %xmm7	 # tmp892, _125
	jmp	.L114	 #
.L129:
 # StageC.c:459:     printf("malloc array (exact fit) : %.1f MB for %lld trades\n",
	shrq	%rax	 # tmp992
	pxor	%xmm1, %xmm1	 # tmp991
	cvtsi2sdq	%rax, %xmm1	 # tmp992, tmp991
	addsd	%xmm1, %xmm1	 # tmp991, _160
	jmp	.L130	 #
.L127:
 # StageC.c:454:     printf("Rival bot (R = %.2f us): P&L %.2f USDT, races won %lld, lost %lld%s\n",
	movq	%rax, %rdx	 # rival_ns, tmp980
	andl	$1, %eax	 #, tmp981
	pxor	%xmm1, %xmm1	 # tmp979
	shrq	%rdx	 # tmp980
	orq	%rax, %rdx	 # tmp981, tmp980
	cvtsi2sdq	%rdx, %xmm1	 # tmp980, tmp979
	addsd	%xmm1, %xmm1	 # tmp979, _154
	jmp	.L128	 #
.L242:
 # led.h:56:     printf("[led.h] No built-in LED on this computer. Printing instead.\n");
	leaq	.LC35(%rip), %rcx	 #,
	call	puts	 #
 # StageC.c:369:     rival_init(&rival);
	leaq	rival(%rip), %rax	 #, tmp1085
	movq	%rax, %rcx	 # tmp1085,
	movq	%rax, 144(%rsp)	 # tmp1085, %sfp
	call	rival_init	 #
 # StageC.c:376:     long long ts0 = trades[0].ts_us;
	movq	trades(%rip), %rax	 # trades, trades
	movq	(%rax), %rax	 # trades.20_106->ts_us, ts0
	movq	%rax, 168(%rsp)	 # ts0, %sfp
 # StageC.c:378:     uint64_t t_start = now_ns();
	call	now_ns	 #
	movq	%rax, 160(%rsp)	 # t_start, %sfp
 # StageC.c:381:     for (long long i = 0; i < replay_n; i++) {
	cmpq	$0, 64(%rsp)	 #, %sfp
	jne	.L223	 #,
 # StageC.c:429:     uint64_t t_end = now_ns();
	call	now_ns	 #
 # StageC.c:372:     unsigned long long lat_sum = 0, lat_max = 0;
	xorl	%edx, %edx	 #
 # StageC.c:375:     long long lag_ns = 0;
	xorl	%r12d, %r12d	 # lag_ns
 # StageC.c:372:     unsigned long long lat_sum = 0, lat_max = 0;
	movq	%rdx, 96(%rsp)	 #, %sfp
 # StageC.c:429:     uint64_t t_end = now_ns();
	movq	%rax, %rbx	 # t_end, t_end
 # StageC.c:372:     unsigned long long lat_sum = 0, lat_max = 0;
	movq	%rdx, 80(%rsp)	 #, %sfp
	movq	%rdx, 128(%rsp)	 #, %sfp
 # StageC.c:372:     unsigned long long lat_sum = 0, lat_max = 0;
	movq	%rdx, 72(%rsp)	 #, %sfp
	movq	%rdx, 120(%rsp)	 #, %sfp
.L134:
 # led.h:74:     printf("[LED %s %s]\n", led_name[led], on ? "ON" : "OFF");
	leaq	.LC38(%rip), %r8	 #,
	leaq	.LC42(%rip), %rdx	 #,
	leaq	.LC40(%rip), %rcx	 #,
	call	printf	 #
	leaq	.LC38(%rip), %r8	 #,
	leaq	.LC39(%rip), %rdx	 #,
	leaq	.LC40(%rip), %rcx	 #,
	call	printf	 #
 # led.h:78: static inline void led_off(int led) { led_set(led, 0); }
	jmp	.L111	 #
.L248:
 # StageC.c:435:     if (!quiet) printf("\r%79s\r", "");
	leaq	.LC8(%rip), %rdx	 #,
	leaq	.LC44(%rip), %rcx	 #,
	call	printf	 #
	jmp	.L112	 #
.L104:
 # StageC.c:277:         printf("%s%-4s trade %-8lld price %.2f  latency %.2f us%s\n",
	movq	%r12, %rax	 # latency_ns, tmp844
	movq	%r12, %rdx	 # latency_ns, tmp845
	pxor	%xmm0, %xmm0	 # tmp843
	shrq	%rax	 # tmp844
	andl	$1, %edx	 #, tmp845
	orq	%rdx, %rax	 # tmp845, tmp844
	cvtsi2sdq	%rax, %xmm0	 # tmp844, tmp843
	addsd	%xmm0, %xmm0	 # tmp843, _520
	jmp	.L105	 #
.L252:
 # StageC.c:277:         printf("%s%-4s trade %-8lld price %.2f  latency %.2f us%s\n",
	leaq	.LC66(%rip), %rax	 #, tmp1397
	movsd	%xmm0, 40(%rsp)	 # _521,
	movq	%rbp, %r9	 # ivtmp.204,
	leaq	.LC63(%rip), %r8	 #,
	movq	%rax, 48(%rsp)	 # tmp1397,
	leaq	.LC64(%rip), %rdx	 #,
	leaq	.LC65(%rip), %rcx	 #,
	movsd	%xmm1, 32(%rsp)	 # price,
	movq	%r10, 104(%rsp)	 # _415, %sfp
	call	printf	 #
 # StageC.c:281:     if (use_led) {
	cmpl	$0, 112(%rsp)	 #, %sfp
	movq	104(%rsp), %r10	 # %sfp, _415
	je	.L93	 #,
.L102:
 # led.h:74:     printf("[LED %s %s]\n", led_name[led], on ? "ON" : "OFF");
	leaq	.LC38(%rip), %r8	 #,
	leaq	.LC39(%rip), %rdx	 #,
	movq	%r10, 104(%rsp)	 # _415, %sfp
	leaq	.LC40(%rip), %rcx	 #,
	call	printf	 #
	leaq	.LC41(%rip), %r8	 #,
	leaq	.LC42(%rip), %rdx	 #,
	leaq	.LC40(%rip), %rcx	 #,
	call	printf	 #
 # led.h:77: static inline void led_on(int led)  { led_set(led, 1); }
	movq	104(%rsp), %r10	 # %sfp, _415
	jmp	.L93	 #
.L157:
 # StageC.c:200:             long long s = 0;
	xorl	%ecx, %ecx	 # s
	jmp	.L83	 #
.L156:
 # StageC.c:195:             long long s = 0;
	xorl	%ecx, %ecx	 # s
	jmp	.L79	 #
.L231:
 # StageC.c:311:             if (speed < 0.0) { printf("Speed must be >= 0\n"); return 1; }
	leaq	.LC13(%rip), %rcx	 #,
	call	puts	 #
 # StageC.c:311:             if (speed < 0.0) { printf("Speed must be >= 0\n"); return 1; }
	jmp	.L11	 #
.L61:
 # StageC.c:362:     printf("Trades loaded: %lld (malloc %.1f MB)   load time %.3f s\n",
	shrq	%rax	 # tmp704
	pxor	%xmm2, %xmm2	 # tmp703
	cvtsi2sdq	%rax, %xmm2	 # tmp704, tmp703
	addsd	%xmm2, %xmm2	 # tmp703, _75
	jmp	.L62	 #
.L141:
	shrq	%rax	 # tmp1063
	pxor	%xmm2, %xmm2	 # tmp1062
	cvtsi2sdq	%rax, %xmm2	 # tmp1063, tmp1062
	addsd	%xmm2, %xmm2	 # tmp1062, _62
	jmp	.L142	 #
.L235:
 # StageC.c:306:                 printf("Unknown file '%s' (use test, dev or stress)\n", argv[a]);
	movq	%rbx, %rdx	 # _10,
	leaq	.LC12(%rip), %rcx	 #,
	call	printf	 #
 # StageC.c:307:                 return 1;
	jmp	.L11	 #
.L135:
 # StageC.c:429:     uint64_t t_end = now_ns();
	call	now_ns	 #
 # StageC.c:375:     long long lag_ns = 0;
	xorl	%r12d, %r12d	 # lag_ns
 # StageC.c:429:     uint64_t t_end = now_ns();
	movq	%rax, %rbx	 # t_end, t_end
 # StageC.c:372:     unsigned long long lat_sum = 0, lat_max = 0;
	xorl	%eax, %eax	 #
	movq	%rax, 96(%rsp)	 #, %sfp
	movq	%rax, 80(%rsp)	 #, %sfp
	movq	%rax, 128(%rsp)	 #, %sfp
 # StageC.c:372:     unsigned long long lat_sum = 0, lat_max = 0;
	movq	%rax, 72(%rsp)	 #, %sfp
	movq	%rax, 120(%rsp)	 #, %sfp
	jmp	.L111	 #
.L144:
 # StageC.c:292:     int use_colour = 0, use_led = 0, quiet = 0;
	xorl	%r15d, %r15d	 #
 # StageC.c:289:     const char *path = STRESS_PATH;
	leaq	.LC2(%rip), %rbx	 #, path
 # StageC.c:291:     double max_minutes = 0.0;       /* 0 = whole file */
	pxor	%xmm7, %xmm7	 # max_minutes
 # StageC.c:292:     int use_colour = 0, use_led = 0, quiet = 0;
	xorl	%eax, %eax	 #
 # StageC.c:290:     double speed = 1000.0;
	movsd	.LC1(%rip), %xmm8	 #, tmp1081
 # StageC.c:292:     int use_colour = 0, use_led = 0, quiet = 0;
	movl	%r15d, 116(%rsp)	 #, %sfp
	movl	%r15d, 112(%rsp)	 #, %sfp
 # StageC.c:292:     int use_colour = 0, use_led = 0, quiet = 0;
	movl	%eax, 88(%rsp)	 #, %sfp
 # StageC.c:290:     double speed = 1000.0;
	movapd	%xmm8, %xmm6	 # tmp1081, speed
	jmp	.L6	 #
.L228:
 # StageC.c:326:             if (r_us <= 0.0) { printf("Rival time must be > 0\n"); return 1; }
	leaq	.LC15(%rip), %rcx	 #,
	call	puts	 #
 # StageC.c:326:             if (r_us <= 0.0) { printf("Rival time must be > 0\n"); return 1; }
	jmp	.L11	 #
.L233:
 # StageC.c:134:         printf("Could not open %s\n", path);
	movq	%rbx, %rdx	 # path,
	leaq	.LC20(%rip), %rcx	 #,
	call	printf	 #
.L37:
 # StageC.c:135:         return -1;
	movq	$-1, %r14	 #, lines
	jmp	.L47	 #
.L251:
 # StageC.c:258:             printf("Out of memory for the signal log\n");
	leaq	.LC36(%rip), %rcx	 #,
	call	puts	 #
 # StageC.c:259:             exit(1);
	movl	$1, %ecx	 #,
	call	exit	 #
.L240:
 # StageC.c:139:         printf("malloc of %lld trades failed\n", lines);
	movq	%r14, %rdx	 # lines,
	leaq	.LC22(%rip), %rcx	 #,
	call	printf	 #
 # StageC.c:140:         return -1;
	jmp	.L37	 #
	.seh_endproc
.lcomm freq.0,8,8
.lcomm ready.1,4,4
.lcomm buf.2,1048576,32
.lcomm sell_count,8,8
.lcomm buy_count,8,8
.lcomm sig_cap,8,8
.lcomm sig_count,8,8
.lcomm sig_log,8,8
	.section .rdata,"dr"
.LC71:
	.ascii "signals_log.csv\0"
	.data
	.align 8
log_path:
	.quad	.LC71
	.align 8
rival_ns:
	.quad	1000
.lcomm rival,48,32
.lcomm total_q,8,8
.lcomm total_pq,8,8
.lcomm have_prev,4,4
.lcomm prev_d,8,8
.lcomm long_sum,8,8
.lcomm short_sum,8,8
.lcomm naive_mode,4,4
	.align 4
long_win:
	.long	200
	.align 4
short_win:
	.long	40
.lcomm trade_count,8,8
.lcomm trades,8,8
	.section .rdata,"dr"
	.align 8
.LC1:
	.long	0
	.long	1083129856
	.align 8
.LC16:
	.long	0
	.long	1071644672
	.align 8
.LC17:
	.long	0
	.long	1138753536
	.align 8
.LC25:
	.long	0
	.long	1104006501
	.align 8
.LC26:
	.long	0
	.long	1078853632
	.align 8
.LC27:
	.long	0
	.long	1093567616
	.align 8
.LC30:
	.long	0
	.long	1051721728
	.align 8
.LC37:
	.long	0
	.long	1079574528
	.align 8
.LC69:
	.long	0
	.long	1081283280
	.def	__main;	.scl	2;	.type	32;	.endef
	.ident	"GCC: (Rev8, Built by MSYS2 project) 15.2.0"
	.def	strcmp;	.scl	2;	.type	32;	.endef
	.def	atof;	.scl	2;	.type	32;	.endef
	.def	fopen;	.scl	2;	.type	32;	.endef
	.def	fread;	.scl	2;	.type	32;	.endef
	.def	printf;	.scl	2;	.type	32;	.endef
	.def	fclose;	.scl	2;	.type	32;	.endef
	.def	malloc;	.scl	2;	.type	32;	.endef
	.def	read_trade_fixed;	.scl	2;	.type	32;	.endef
	.def	puts;	.scl	2;	.type	32;	.endef
	.def	rival_init;	.scl	2;	.type	32;	.endef
	.def	rival_pnl;	.scl	2;	.type	32;	.endef
	.def	fflush;	.scl	2;	.type	32;	.endef
	.def	putchar;	.scl	2;	.type	32;	.endef
	.def	fwrite;	.scl	2;	.type	32;	.endef
	.def	fprintf;	.scl	2;	.type	32;	.endef
	.def	free;	.scl	2;	.type	32;	.endef
	.def	rival_on_signal;	.scl	2;	.type	32;	.endef
	.def	realloc;	.scl	2;	.type	32;	.endef
	.def	exit;	.scl	2;	.type	32;	.endef
