	.file	"StageA+.c"
 # GNU C23 (Rev8, Built by MSYS2 project) version 15.2.0 (x86_64-w64-mingw32)
 #	compiled by GNU C version 15.2.0, GMP version 6.3.0, MPFR version 4.2.2, MPC version 1.3.1, isl version isl-0.27-GMP

 # GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
 # options passed: -mtune=generic -march=nocona -O2
	.text
	.p2align 4
	.def	fast_parse_double;	.scl	3;	.type	32;	.endef
	.seh_proc	fast_parse_double
fast_parse_double:
	.seh_endprologue
 # StageA+.c:31: static int fast_parse_double(const char **cursor, double *result) {
	movq	%rdx, %r10	 # result, result
 # StageA+.c:32:     const char *p = *cursor;
	movq	(%rcx), %rdx	 # *cursor_31(D), p
 # StageA+.c:31: static int fast_parse_double(const char **cursor, double *result) {
	movq	%rcx, %r9	 # cursor, cursor
 # StageA+.c:38:     while (*p >= '0' && *p <= '9') {
	movzbl	(%rdx), %eax	 # *p_32, _5
 # StageA+.c:38:     while (*p >= '0' && *p <= '9') {
	leal	-48(%rax), %ecx	 #, _56
	cmpb	$9, %cl	 #, _56
	ja	.L2	 #,
	movsd	.LC2(%rip), %xmm2	 #, tmp143
 # StageA+.c:33:     double whole = 0.0;
	pxor	%xmm0, %xmm0	 # whole
	.p2align 6
	.p2align 4
	.p2align 3
.L3:
 # StageA+.c:39:         whole = whole * 10.0 + (*p - '0');
	mulsd	%xmm2, %xmm0	 # tmp143, _1
 # StageA+.c:39:         whole = whole * 10.0 + (*p - '0');
	subl	$48, %eax	 #, _67
	pxor	%xmm1, %xmm1	 # _4
	movq	%rdx, %rcx	 # p, p
	movsbl	%al, %eax	 # _67, _67
 # StageA+.c:40:         p++;
	addq	$1, %rdx	 #, p
 # StageA+.c:39:         whole = whole * 10.0 + (*p - '0');
	cvtsi2sdl	%eax, %xmm1	 # _67, _4
 # StageA+.c:38:     while (*p >= '0' && *p <= '9') {
	movzbl	(%rdx), %eax	 # MEM[(const char *)p_42], _5
 # StageA+.c:38:     while (*p >= '0' && *p <= '9') {
	leal	-48(%rax), %r8d	 #, _7
 # StageA+.c:39:         whole = whole * 10.0 + (*p - '0');
	addsd	%xmm1, %xmm0	 # _4, whole
 # StageA+.c:38:     while (*p >= '0' && *p <= '9') {
	cmpb	$9, %r8b	 #, _7
	jbe	.L3	 #,
	pxor	%xmm1, %xmm1	 # _80
 # StageA+.c:44:     if (*p == '.') {
	cmpb	$46, %al	 #, _5
	je	.L17	 #,
.L7:
 # StageA+.c:56:     *result = whole + fraction / scale;
	addsd	%xmm1, %xmm0	 # _80, _16
 # StageA+.c:58:     return 1;
	movl	$1, %ecx	 #, <retval>
 # StageA+.c:56:     *result = whole + fraction / scale;
	movsd	%xmm0, (%r10)	 # _16, *result_38(D)
 # StageA+.c:57:     *cursor = p;
	movq	%rdx, (%r9)	 # p, *cursor_31(D)
.L1:
 # StageA+.c:59: }
	movl	%ecx, %eax	 # <retval>,
	ret	
	.p2align 4,,10
	.p2align 3
.L17:
 # StageA+.c:46:         while (*p >= '0' && *p <= '9') {
	movzbl	1(%rdx), %eax	 # MEM[(const char *)p_42 + 1B], _12
 # StageA+.c:45:         p++;
	addq	$2, %rcx	 #, p
 # StageA+.c:46:         while (*p >= '0' && *p <= '9') {
	leal	-48(%rax), %edx	 #, _50
	cmpb	$9, %dl	 #, _50
	ja	.L12	 #,
.L6:
 # StageA+.c:35:     double scale = 1.0;
	movsd	.LC1(%rip), %xmm3	 #, scale
 # StageA+.c:34:     double fraction = 0.0;
	pxor	%xmm1, %xmm1	 # fraction
	.p2align 6
	.p2align 4
	.p2align 3
.L8:
 # StageA+.c:47:             fraction = fraction * 10.0 + (*p - '0');
	mulsd	%xmm2, %xmm1	 # tmp143, _8
 # StageA+.c:47:             fraction = fraction * 10.0 + (*p - '0');
	subl	$48, %eax	 #, _43
	pxor	%xmm4, %xmm4	 # _11
 # StageA+.c:49:             p++;
	addq	$1, %rcx	 #, p
 # StageA+.c:48:             scale *= 10.0;
	mulsd	%xmm2, %xmm3	 # tmp143, scale
 # StageA+.c:47:             fraction = fraction * 10.0 + (*p - '0');
	movsbl	%al, %eax	 # _43, _43
	cvtsi2sdl	%eax, %xmm4	 # _43, _11
 # StageA+.c:46:         while (*p >= '0' && *p <= '9') {
	movzbl	(%rcx), %eax	 # MEM[(const char *)p_36], _12
 # StageA+.c:46:         while (*p >= '0' && *p <= '9') {
	leal	-48(%rax), %edx	 #, _14
 # StageA+.c:47:             fraction = fraction * 10.0 + (*p - '0');
	addsd	%xmm4, %xmm1	 # _11, fraction
 # StageA+.c:46:         while (*p >= '0' && *p <= '9') {
	cmpb	$9, %dl	 #, _14
	jbe	.L8	 #,
 # StageA+.c:56:     *result = whole + fraction / scale;
	divsd	%xmm3, %xmm1	 # scale, _80
	movq	%rcx, %rdx	 # p, p
	jmp	.L7	 #
	.p2align 4,,10
	.p2align 3
.L2:
 # StageA+.c:54:     if (digits == 0) return 0;
	xorl	%ecx, %ecx	 # <retval>
 # StageA+.c:44:     if (*p == '.') {
	cmpb	$46, %al	 #, _5
	jne	.L1	 #,
 # StageA+.c:46:         while (*p >= '0' && *p <= '9') {
	movzbl	1(%rdx), %eax	 # MEM[(const char *)p_32 + 1B], _12
 # StageA+.c:46:         while (*p >= '0' && *p <= '9') {
	leal	-48(%rax), %r8d	 #, _46
	cmpb	$9, %r8b	 #, _46
	ja	.L1	 #,
	movsd	.LC2(%rip), %xmm2	 #, tmp143
 # StageA+.c:45:         p++;
	leaq	1(%rdx), %rcx	 #, p
 # StageA+.c:33:     double whole = 0.0;
	pxor	%xmm0, %xmm0	 # whole
	jmp	.L6	 #
.L12:
 # StageA+.c:45:         p++;
	movq	%rcx, %rdx	 # p, p
	jmp	.L7	 #
	.seh_endproc
	.p2align 4
	.def	fast_parse_fixed;	.scl	3;	.type	32;	.endef
	.seh_proc	fast_parse_fixed
fast_parse_fixed:
	pushq	%rbx	 #
	.seh_pushreg	%rbx
	.seh_endprologue
 # StageA+.c:112: static int fast_parse_fixed(const char **cursor, int decimals, long long *result) {
	movq	%rcx, %r10	 # cursor, cursor
 # StageA+.c:113:     const char *p = *cursor;
	movq	(%rcx), %rcx	 # *cursor_33(D), p
 # StageA+.c:112: static int fast_parse_fixed(const char **cursor, int decimals, long long *result) {
	movl	%edx, %r11d	 # decimals, decimals
 # StageA+.c:118:     while (*p >= '0' && *p <= '9') {
	movzbl	(%rcx), %eax	 # *p_34, _5
 # StageA+.c:118:     while (*p >= '0' && *p <= '9') {
	leal	-48(%rax), %edx	 #, _63
	cmpb	$9, %dl	 #, _63
	ja	.L19	 #,
 # StageA+.c:114:     long long value = 0;
	xorl	%edx, %edx	 # value
	.p2align 6
	.p2align 4
	.p2align 3
.L20:
 # StageA+.c:119:         value = value * 10 + (*p - '0');
	subl	$48, %eax	 #, _77
	movq	%rcx, %rbx	 # p, p
 # StageA+.c:119:         value = value * 10 + (*p - '0');
	leaq	(%rdx,%rdx,4), %rdx	 #, _1
 # StageA+.c:120:         p++;
	addq	$1, %rcx	 #, p
 # StageA+.c:119:         value = value * 10 + (*p - '0');
	movsbq	%al, %rax	 # _77, _4
 # StageA+.c:119:         value = value * 10 + (*p - '0');
	leaq	(%rax,%rdx,2), %rdx	 #, value
 # StageA+.c:118:     while (*p >= '0' && *p <= '9') {
	movzbl	(%rcx), %eax	 # MEM[(const char *)p_47], _5
 # StageA+.c:118:     while (*p >= '0' && *p <= '9') {
	leal	-48(%rax), %r9d	 #, _7
	cmpb	$9, %r9b	 #, _7
	jbe	.L20	 #,
 # StageA+.c:116:     int frac = 0;
	xorl	%r9d, %r9d	 # frac
 # StageA+.c:124:     if (*p == '.') {
	cmpb	$46, %al	 #, _5
	je	.L37	 #,
	.p2align 4
	.p2align 4
	.p2align 3
.L28:
 # StageA+.c:139:         value *= 10;
	leaq	(%rdx,%rdx,4), %rdx	 #, value_44
 # StageA+.c:140:         frac++;
	addl	$1, %r9d	 #, frac
 # StageA+.c:139:         value *= 10;
	addq	%rdx, %rdx	 # value
 # StageA+.c:138:     while (frac < decimals) {               /* pad if fewer decimals were given */
	cmpl	%r9d, %r11d	 # frac, decimals
	jg	.L28	 #,
.L27:
 # StageA+.c:143:     *result = value;
	movq	%rdx, (%r8)	 # value, *result_41(D)
 # StageA+.c:145:     return 1;
	movl	$1, %edx	 #, <retval>
 # StageA+.c:144:     *cursor = p;
	movq	%rcx, (%r10)	 # p, *cursor_33(D)
.L18:
 # StageA+.c:146: }
	movl	%edx, %eax	 # <retval>,
	popq	%rbx	 #
	ret	
	.p2align 4,,10
	.p2align 3
.L37:
 # StageA+.c:126:         while (*p >= '0' && *p <= '9') {
	movzbl	1(%rcx), %eax	 # MEM[(const char *)p_47 + 1B], _10
 # StageA+.c:125:         p++;
	addq	$2, %rbx	 #, p
 # StageA+.c:126:         while (*p >= '0' && *p <= '9') {
	leal	-48(%rax), %ecx	 #, _60
	cmpb	$9, %cl	 #, _60
	ja	.L32	 #,
.L23:
 # StageA+.c:125:         p++;
	movq	%rbx, %rcx	 # p, p
 # StageA+.c:116:     int frac = 0;
	xorl	%r9d, %r9d	 # frac
	.p2align 6
	.p2align 4
	.p2align 3
.L26:
 # StageA+.c:127:             if (frac < decimals) {          /* keep only 'decimals' digits */
	cmpl	%r11d, %r9d	 # decimals, frac
	jge	.L25	 #,
 # StageA+.c:128:                 value = value * 10 + (*p - '0');
	subl	$48, %eax	 #, _28
 # StageA+.c:128:                 value = value * 10 + (*p - '0');
	leaq	(%rdx,%rdx,4), %rdx	 #, _29
 # StageA+.c:129:                 frac++;
	addl	$1, %r9d	 #, frac
 # StageA+.c:128:                 value = value * 10 + (*p - '0');
	movsbq	%al, %rax	 # _28, _27
 # StageA+.c:128:                 value = value * 10 + (*p - '0');
	leaq	(%rax,%rdx,2), %rdx	 #, value
.L25:
 # StageA+.c:126:         while (*p >= '0' && *p <= '9') {
	movzbl	1(%rcx), %eax	 # MEM[(const char *)p_21], _10
 # StageA+.c:131:             p++;
	addq	$1, %rcx	 #, p
 # StageA+.c:126:         while (*p >= '0' && *p <= '9') {
	leal	-48(%rax), %ebx	 #, _17
	cmpb	$9, %bl	 #, _17
	jbe	.L26	 #,
 # StageA+.c:138:     while (frac < decimals) {               /* pad if fewer decimals were given */
	cmpl	%r11d, %r9d	 # decimals, frac
	jl	.L28	 #,
	jmp	.L27	 #
	.p2align 4,,10
	.p2align 3
.L19:
 # StageA+.c:136:     if (digits == 0) return 0;
	xorl	%edx, %edx	 # <retval>
 # StageA+.c:124:     if (*p == '.') {
	cmpb	$46, %al	 #, _5
	jne	.L18	 #,
 # StageA+.c:126:         while (*p >= '0' && *p <= '9') {
	movzbl	1(%rcx), %eax	 # MEM[(const char *)p_34 + 1B], _10
 # StageA+.c:126:         while (*p >= '0' && *p <= '9') {
	leal	-48(%rax), %r9d	 #, _16
	cmpb	$9, %r9b	 #, _16
	ja	.L18	 #,
 # StageA+.c:125:         p++;
	leaq	1(%rcx), %rbx	 #, p
 # StageA+.c:114:     long long value = 0;
	xorl	%edx, %edx	 # value
	jmp	.L23	 #
.L32:
 # StageA+.c:125:         p++;
	movq	%rbx, %rcx	 # p, p
	jmp	.L28	 #
	.seh_endproc
	.p2align 4
	.globl	read_trade
	.def	read_trade;	.scl	2;	.type	32;	.endef
	.seh_proc	read_trade
read_trade:
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
	subq	$344, %rsp	 #,
	.seh_stackalloc	344
	.seh_endprologue
 # StageA+.c:61: int read_trade(FILE *fp, long long *ts, double *price, double *qty, int *is_buy) {
	movq	%rcx, %rsi	 # fp, fp
	leaq	80(%rsp), %rbx	 #, tmp170
 # StageA+.c:74:         if (!fast_parse_double(&end, &parsed_price) || *end != ',') continue;
	leaq	56(%rsp), %rdi	 #, tmp172
 # StageA+.c:61: int read_trade(FILE *fp, long long *ts, double *price, double *qty, int *is_buy) {
	movq	%r8, %r14	 # price, price
	movq	%rdx, 424(%rsp)	 # ts, ts
 # StageA+.c:80:         if (!fast_parse_double(&end, &parsed_qty) || *end != ',') continue;
	leaq	72(%rsp), %r13	 #, tmp173
 # StageA+.c:61: int read_trade(FILE *fp, long long *ts, double *price, double *qty, int *is_buy) {
	movq	%r9, 440(%rsp)	 # qty, qty
	.p2align 4
	.p2align 3
.L39:
 # StageA+.c:64:     while (fgets(line, sizeof line, fp) != NULL) {
	movq	%rsi, %r8	 # fp,
	movl	$256, %edx	 #,
	movq	%rbx, %rcx	 # tmp170,
	call	fgets	 #
 # StageA+.c:64:     while (fgets(line, sizeof line, fp) != NULL) {
	testq	%rax, %rax	 # _17
	je	.L67	 #,
 # StageA+.c:7:     char *comma = strchr(p, ',');
	movl	$44, %edx	 #,
	movq	%rbx, %rcx	 # tmp170,
	call	strchr	 #
 # StageA+.c:8:     if (comma == NULL) return NULL;
	testq	%rax, %rax	 # comma
	je	.L39	 #,
 # StageA+.c:9:     return comma + 1;
	leaq	1(%rax), %r11	 #, _55
 # StageA+.c:74:         if (!fast_parse_double(&end, &parsed_price) || *end != ',') continue;
	leaq	64(%rsp), %rdx	 #,
	movq	%rdi, %rcx	 # tmp172,
 # StageA+.c:73:         end = p;
	movq	%r11, 56(%rsp)	 # _55, end
 # StageA+.c:74:         if (!fast_parse_double(&end, &parsed_price) || *end != ',') continue;
	call	fast_parse_double	 #
 # StageA+.c:74:         if (!fast_parse_double(&end, &parsed_price) || *end != ',') continue;
	testl	%eax, %eax	 # _1
	je	.L39	 #,
 # StageA+.c:74:         if (!fast_parse_double(&end, &parsed_price) || *end != ',') continue;
	movq	56(%rsp), %rax	 # end, end
 # StageA+.c:74:         if (!fast_parse_double(&end, &parsed_price) || *end != ',') continue;
	cmpb	$44, (%rax)	 #, *end.0_2
	jne	.L39	 #,
 # StageA+.c:7:     char *comma = strchr(p, ',');
	movl	$44, %edx	 #,
	movq	%r11, %rcx	 # _55,
	call	strchr	 #
 # StageA+.c:8:     if (comma == NULL) return NULL;
	testq	%rax, %rax	 # comma
	je	.L39	 #,
 # StageA+.c:9:     return comma + 1;
	leaq	1(%rax), %r11	 #, _58
 # StageA+.c:80:         if (!fast_parse_double(&end, &parsed_qty) || *end != ',') continue;
	movq	%r13, %rdx	 # tmp173,
	movq	%rdi, %rcx	 # tmp172,
 # StageA+.c:79:         end = p;
	movq	%r11, 56(%rsp)	 # _58, end
 # StageA+.c:80:         if (!fast_parse_double(&end, &parsed_qty) || *end != ',') continue;
	call	fast_parse_double	 #
	movl	%eax, %ebp	 # <retval>, <retval>
 # StageA+.c:80:         if (!fast_parse_double(&end, &parsed_qty) || *end != ',') continue;
	testl	%eax, %eax	 # <retval>
	je	.L39	 #,
 # StageA+.c:80:         if (!fast_parse_double(&end, &parsed_qty) || *end != ',') continue;
	movq	56(%rsp), %rax	 # end, end
 # StageA+.c:80:         if (!fast_parse_double(&end, &parsed_qty) || *end != ',') continue;
	cmpb	$44, (%rax)	 #, *end.1_5
	jne	.L39	 #,
 # StageA+.c:7:     char *comma = strchr(p, ',');
	movl	$44, %edx	 #,
	movq	%r11, %rcx	 # _58,
	call	strchr	 #
 # StageA+.c:8:     if (comma == NULL) return NULL;
	testq	%rax, %rax	 # comma
	je	.L39	 #,
 # StageA+.c:7:     char *comma = strchr(p, ',');
	movl	$44, %edx	 #,
 # StageA+.c:9:     return comma + 1;
	leaq	1(%rax), %rcx	 #, _61
 # StageA+.c:7:     char *comma = strchr(p, ',');
	call	strchr	 #
	movq	%rax, %rdx	 #, comma
 # StageA+.c:8:     if (comma == NULL) return NULL;
	testq	%rax, %rax	 # comma
	je	.L39	 #,
 # StageA+.c:16:     if (*p < '0' || *p > '9') return 0;
	movzbl	1(%rax), %eax	 # MEM[(const char *)comma_63 + 1B], _70
 # StageA+.c:16:     if (*p < '0' || *p > '9') return 0;
	leal	-48(%rax), %ecx	 #, _69
 # StageA+.c:16:     if (*p < '0' || *p > '9') return 0;
	cmpb	$9, %cl	 #, _69
	ja	.L39	 #,
 # StageA+.c:9:     return comma + 1;
	leaq	1(%rdx), %rcx	 #, _64
 # StageA+.c:20:         if (value > (LLONG_MAX - digit) / 10) return 0;
	movq	%r13, %rdx	 # tmp173, tmp173
	movl	%ebp, %r15d	 # <retval>, <retval>
	movq	%rdi, %r13	 # tmp172, tmp172
 # StageA+.c:14:     long long value = 0;
	xorl	%r8d, %r8d	 # value
 # StageA+.c:20:         if (value > (LLONG_MAX - digit) / 10) return 0;
	movq	%rbx, %rdi	 # tmp170, tmp170
	movq	%rcx, %rbp	 # _64, _64
	movq	%rdx, %rbx	 # tmp173, tmp173
 # StageA+.c:20:         if (value > (LLONG_MAX - digit) / 10) return 0;
	movabsq	$9223372036854775807, %r11	 #, tmp148
 # StageA+.c:20:         if (value > (LLONG_MAX - digit) / 10) return 0;
	movabsq	$-3689348814741910323, %r10	 #, tmp151
	jmp	.L41	 #
	.p2align 6
	.p2align 4,,10
	.p2align 3
.L69:
 # StageA+.c:22:         value = value * 10 + digit;
	leaq	(%r8,%r8,4), %rax	 #, _77
 # StageA+.c:23:         p++;
	addq	$1, %rcx	 #, p
 # StageA+.c:22:         value = value * 10 + digit;
	leaq	(%r9,%rax,2), %r8	 #, value
 # StageA+.c:18:     while (*p >= '0' && *p <= '9') {
	movzbl	(%rcx), %eax	 # MEM[(const char *)p_80], _70
 # StageA+.c:18:     while (*p >= '0' && *p <= '9') {
	leal	-48(%rax), %edx	 #, _82
	cmpb	$9, %dl	 #, _82
	ja	.L68	 #,
.L41:
 # StageA+.c:20:         if (value > (LLONG_MAX - digit) / 10) return 0;
	leal	-48(%rax), %r9d	 #, _13
	movq	%r11, %rdx	 # tmp148, _74
	movsbq	%r9b, %r9	 # _13, _73
	subq	%r9, %rdx	 # _73, _74
 # StageA+.c:20:         if (value > (LLONG_MAX - digit) / 10) return 0;
	movq	%rdx, %rax	 # _74, _74
	mulq	%r10	 # tmp151
	shrq	$3, %rdx	 #, _75
 # StageA+.c:20:         if (value > (LLONG_MAX - digit) / 10) return 0;
	cmpq	%r8, %rdx	 # value, _75
	jge	.L69	 #,
	movq	%rbx, %rax	 # tmp173, tmp173
	movq	%rdi, %rbx	 # tmp170, tmp170
	movq	%r13, %rdi	 # tmp172, tmp172
	movq	%rax, %r13	 # tmp173, tmp173
	jmp	.L39	 #
	.p2align 4,,10
	.p2align 3
.L67:
 # StageA+.c:101:     return 0;
	xorl	%ebp, %ebp	 # <retval>
.L38:
 # StageA+.c:102: }
	movl	%ebp, %eax	 # <retval>,
	addq	$344, %rsp	 #,
	popq	%rbx	 #
	popq	%rsi	 #
	popq	%rdi	 #
	popq	%rbp	 #
	popq	%r12	 #
	popq	%r13	 #
	popq	%r14	 #
	popq	%r15	 #
	ret	
.L68:
 # StageA+.c:88:         if (!fast_parse_ll(&end, &parsed_ts) || *end != ',') continue;
	movq	%rbx, %rdx	 # tmp173, tmp173
	movq	%rbp, %rcx	 # _64, _64
	movq	%rdi, %rbx	 # tmp170, tmp170
	movl	%r15d, %ebp	 # <retval>, <retval>
	movq	%r13, %rdi	 # tmp172, tmp172
	movq	%rdx, %r13	 # tmp173, tmp173
	cmpb	$44, %al	 #, _70
	jne	.L39	 #,
 # StageA+.c:7:     char *comma = strchr(p, ',');
	movl	$44, %edx	 #,
	movq	%r8, 40(%rsp)	 # value, %sfp
	call	strchr	 #
 # StageA+.c:8:     if (comma == NULL) return NULL;
	testq	%rax, %rax	 # comma
	je	.L39	 #,
 # StageA+.c:93:         *price = parsed_price;
	movsd	64(%rsp), %xmm0	 # parsed_price, parsed_price
 # StageA+.c:96:         *is_buy = (*p == 'F' || *p == 'f') ? 1 : 0;
	movzbl	1(%rax), %eax	 # MEM[(char *)comma_84 + 1B], MEM[(char *)comma_84 + 1B]
	xorl	%edx, %edx	 # _89
 # StageA+.c:94:         *qty = parsed_qty;
	movq	440(%rsp), %rsi	 # qty, tmp213
 # StageA+.c:93:         *price = parsed_price;
	movq	40(%rsp), %r8	 # %sfp, value
	movsd	%xmm0, (%r14)	 # parsed_price, *price_36(D)
 # StageA+.c:94:         *qty = parsed_qty;
	movsd	72(%rsp), %xmm0	 # parsed_qty, parsed_qty
 # StageA+.c:96:         *is_buy = (*p == 'F' || *p == 'f') ? 1 : 0;
	andl	$-33, %eax	 #, _90
	cmpb	$70, %al	 #, _90
 # StageA+.c:96:         *is_buy = (*p == 'F' || *p == 'f') ? 1 : 0;
	movq	448(%rsp), %rax	 # is_buy, is_buy
 # StageA+.c:94:         *qty = parsed_qty;
	movsd	%xmm0, (%rsi)	 # parsed_qty, *qty_38(D)
 # StageA+.c:95:         *ts = parsed_ts;
	movq	424(%rsp), %rsi	 # ts, tmp214
 # StageA+.c:96:         *is_buy = (*p == 'F' || *p == 'f') ? 1 : 0;
	sete	%dl	 #, _89
 # StageA+.c:95:         *ts = parsed_ts;
	movq	%r8, (%rsi)	 # value, *ts_40(D)
 # StageA+.c:96:         *is_buy = (*p == 'F' || *p == 'f') ? 1 : 0;
	movl	%edx, (%rax)	 # _89, *is_buy_43(D)
	jmp	.L38	 #
	.seh_endproc
	.p2align 4
	.globl	read_trade_fixed
	.def	read_trade_fixed;	.scl	2;	.type	32;	.endef
	.seh_proc	read_trade_fixed
read_trade_fixed:
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
	subq	$344, %rsp	 #,
	.seh_stackalloc	344
	.seh_endprologue
 # StageA+.c:167:         if (!fast_parse_fixed(&end, QTY_DECIMALS, &parsed_qty) || *end != ',') continue;
	leaq	72(%rsp), %rax	 #, tmp173
 # StageA+.c:149:                      long long *qty_fx, int *is_buy) {
	movq	%rcx, %rsi	 # fp, fp
	movq	%rdx, %r15	 # ts, ts
	movq	%r8, %r14	 # price_fx, price_fx
	movq	%r9, 440(%rsp)	 # qty_fx, qty_fx
 # StageA+.c:167:         if (!fast_parse_fixed(&end, QTY_DECIMALS, &parsed_qty) || *end != ',') continue;
	movq	%rax, 40(%rsp)	 # tmp173, %sfp
	.p2align 4
	.p2align 3
.L71:
 # StageA+.c:152:     while (fgets(line, sizeof line, fp) != NULL) {
	movq	%rsi, %r8	 # fp,
	movl	$256, %edx	 #,
	leaq	80(%rsp), %rcx	 #,
	call	fgets	 #
 # StageA+.c:152:     while (fgets(line, sizeof line, fp) != NULL) {
	testq	%rax, %rax	 # _17
	je	.L99	 #,
 # StageA+.c:7:     char *comma = strchr(p, ',');
	movl	$44, %edx	 #,
	leaq	80(%rsp), %rcx	 #,
	call	strchr	 #
 # StageA+.c:8:     if (comma == NULL) return NULL;
	testq	%rax, %rax	 # comma
	je	.L71	 #,
 # StageA+.c:9:     return comma + 1;
	leaq	1(%rax), %rbp	 #, _55
 # StageA+.c:161:         if (!fast_parse_fixed(&end, PRICE_DECIMALS, &parsed_price) || *end != ',') continue;
	leaq	64(%rsp), %r8	 #,
	movl	$2, %edx	 #,
	leaq	56(%rsp), %rcx	 #,
 # StageA+.c:160:         end = p;
	movq	%rbp, 56(%rsp)	 # _55, end
 # StageA+.c:161:         if (!fast_parse_fixed(&end, PRICE_DECIMALS, &parsed_price) || *end != ',') continue;
	call	fast_parse_fixed	 #
 # StageA+.c:161:         if (!fast_parse_fixed(&end, PRICE_DECIMALS, &parsed_price) || *end != ',') continue;
	testl	%eax, %eax	 # _1
	je	.L71	 #,
 # StageA+.c:161:         if (!fast_parse_fixed(&end, PRICE_DECIMALS, &parsed_price) || *end != ',') continue;
	movq	56(%rsp), %rax	 # end, end
 # StageA+.c:161:         if (!fast_parse_fixed(&end, PRICE_DECIMALS, &parsed_price) || *end != ',') continue;
	cmpb	$44, (%rax)	 #, *end.6_2
	jne	.L71	 #,
 # StageA+.c:7:     char *comma = strchr(p, ',');
	movl	$44, %edx	 #,
	movq	%rbp, %rcx	 # _55,
	call	strchr	 #
 # StageA+.c:8:     if (comma == NULL) return NULL;
	testq	%rax, %rax	 # comma
	je	.L71	 #,
 # StageA+.c:167:         if (!fast_parse_fixed(&end, QTY_DECIMALS, &parsed_qty) || *end != ',') continue;
	movq	40(%rsp), %r8	 # %sfp,
 # StageA+.c:9:     return comma + 1;
	leaq	1(%rax), %r13	 #, _58
 # StageA+.c:167:         if (!fast_parse_fixed(&end, QTY_DECIMALS, &parsed_qty) || *end != ',') continue;
	movl	$5, %edx	 #,
	leaq	56(%rsp), %rcx	 #,
 # StageA+.c:166:         end = p;
	movq	%r13, 56(%rsp)	 # _58, end
 # StageA+.c:167:         if (!fast_parse_fixed(&end, QTY_DECIMALS, &parsed_qty) || *end != ',') continue;
	call	fast_parse_fixed	 #
	movl	%eax, %ebp	 # <retval>, <retval>
 # StageA+.c:167:         if (!fast_parse_fixed(&end, QTY_DECIMALS, &parsed_qty) || *end != ',') continue;
	testl	%eax, %eax	 # <retval>
	je	.L71	 #,
 # StageA+.c:167:         if (!fast_parse_fixed(&end, QTY_DECIMALS, &parsed_qty) || *end != ',') continue;
	movq	56(%rsp), %rax	 # end, end
 # StageA+.c:167:         if (!fast_parse_fixed(&end, QTY_DECIMALS, &parsed_qty) || *end != ',') continue;
	cmpb	$44, (%rax)	 #, *end.7_5
	jne	.L71	 #,
 # StageA+.c:7:     char *comma = strchr(p, ',');
	movl	$44, %edx	 #,
	movq	%r13, %rcx	 # _58,
	call	strchr	 #
 # StageA+.c:8:     if (comma == NULL) return NULL;
	testq	%rax, %rax	 # comma
	je	.L71	 #,
 # StageA+.c:9:     return comma + 1;
	leaq	1(%rax), %rcx	 #, _61
 # StageA+.c:7:     char *comma = strchr(p, ',');
	movl	$44, %edx	 #,
	call	strchr	 #
 # StageA+.c:8:     if (comma == NULL) return NULL;
	testq	%rax, %rax	 # comma
	je	.L71	 #,
 # StageA+.c:16:     if (*p < '0' || *p > '9') return 0;
	movzbl	1(%rax), %ecx	 # MEM[(const char *)comma_63 + 1B], _70
 # StageA+.c:16:     if (*p < '0' || *p > '9') return 0;
	leal	-48(%rcx), %edx	 #, _69
 # StageA+.c:16:     if (*p < '0' || *p > '9') return 0;
	cmpb	$9, %dl	 #, _69
	ja	.L71	 #,
 # StageA+.c:9:     return comma + 1;
	leaq	1(%rax), %r11	 #, _64
 # StageA+.c:14:     long long value = 0;
	xorl	%r13d, %r13d	 # value
 # StageA+.c:20:         if (value > (LLONG_MAX - digit) / 10) return 0;
	movabsq	$9223372036854775807, %r10	 #, tmp148
 # StageA+.c:20:         if (value > (LLONG_MAX - digit) / 10) return 0;
	movabsq	$-3689348814741910323, %r9	 #, tmp151
 # StageA+.c:13:     const char *p = *cursor;
	movq	%r11, %r8	 # _64, p
	.p2align 6
	.p2align 4
	.p2align 3
.L73:
 # StageA+.c:20:         if (value > (LLONG_MAX - digit) / 10) return 0;
	subl	$48, %ecx	 #, _13
	movq	%r10, %rdx	 # tmp148, _74
	movsbq	%cl, %rcx	 # _13, _73
	subq	%rcx, %rdx	 # _73, _74
 # StageA+.c:20:         if (value > (LLONG_MAX - digit) / 10) return 0;
	movq	%rdx, %rax	 # _74, _74
	mulq	%r9	 # tmp151
	shrq	$3, %rdx	 #, _75
 # StageA+.c:20:         if (value > (LLONG_MAX - digit) / 10) return 0;
	cmpq	%r13, %rdx	 # value, _75
	jl	.L71	 #,
 # StageA+.c:22:         value = value * 10 + digit;
	leaq	0(%r13,%r13,4), %rax	 #, _77
 # StageA+.c:23:         p++;
	addq	$1, %r8	 #, p
 # StageA+.c:22:         value = value * 10 + digit;
	leaq	(%rcx,%rax,2), %r13	 #, value
 # StageA+.c:18:     while (*p >= '0' && *p <= '9') {
	movzbl	(%r8), %ecx	 # MEM[(const char *)p_80], _70
 # StageA+.c:18:     while (*p >= '0' && *p <= '9') {
	leal	-48(%rcx), %eax	 #, _82
	cmpb	$9, %al	 #, _82
	jbe	.L73	 #,
 # StageA+.c:175:         if (!fast_parse_ll(&end, &parsed_ts) || *end != ',') continue;
	cmpb	$44, %cl	 #, _70
	jne	.L71	 #,
 # StageA+.c:7:     char *comma = strchr(p, ',');
	movl	$44, %edx	 #,
	movq	%r11, %rcx	 # _64,
	call	strchr	 #
 # StageA+.c:8:     if (comma == NULL) return NULL;
	testq	%rax, %rax	 # comma
	je	.L71	 #,
 # StageA+.c:180:         *price_fx = parsed_price;
	movq	64(%rsp), %rdx	 # parsed_price, parsed_price
 # StageA+.c:183:         *is_buy = (*p == 'F' || *p == 'f') ? 1 : 0;
	movzbl	1(%rax), %eax	 # MEM[(char *)comma_84 + 1B], MEM[(char *)comma_84 + 1B]
 # StageA+.c:181:         *qty_fx = parsed_qty;
	movq	440(%rsp), %rsi	 # qty_fx, tmp211
 # StageA+.c:180:         *price_fx = parsed_price;
	movq	%rdx, (%r14)	 # parsed_price, *price_fx_36(D)
 # StageA+.c:181:         *qty_fx = parsed_qty;
	movq	72(%rsp), %rdx	 # parsed_qty, parsed_qty
 # StageA+.c:183:         *is_buy = (*p == 'F' || *p == 'f') ? 1 : 0;
	andl	$-33, %eax	 #, _90
 # StageA+.c:181:         *qty_fx = parsed_qty;
	movq	%rdx, (%rsi)	 # parsed_qty, *qty_fx_38(D)
 # StageA+.c:183:         *is_buy = (*p == 'F' || *p == 'f') ? 1 : 0;
	xorl	%edx, %edx	 # _89
	cmpb	$70, %al	 #, _90
 # StageA+.c:183:         *is_buy = (*p == 'F' || *p == 'f') ? 1 : 0;
	movq	448(%rsp), %rax	 # is_buy, is_buy
 # StageA+.c:183:         *is_buy = (*p == 'F' || *p == 'f') ? 1 : 0;
	sete	%dl	 #, _89
 # StageA+.c:182:         *ts = parsed_ts;
	movq	%r13, (%r15)	 # value, *ts_40(D)
 # StageA+.c:183:         *is_buy = (*p == 'F' || *p == 'f') ? 1 : 0;
	movl	%edx, (%rax)	 # _89, *is_buy_43(D)
	jmp	.L70	 #
	.p2align 4,,10
	.p2align 3
.L99:
 # StageA+.c:186:     return 0;
	xorl	%ebp, %ebp	 # <retval>
.L70:
 # StageA+.c:187: }
	movl	%ebp, %eax	 # <retval>,
	addq	$344, %rsp	 #,
	popq	%rbx	 #
	popq	%rsi	 #
	popq	%rdi	 #
	popq	%rbp	 #
	popq	%r12	 #
	popq	%r13	 #
	popq	%r14	 #
	popq	%r15	 #
	ret	
	.seh_endproc
	.section .rdata,"dr"
	.align 8
.LC1:
	.long	0
	.long	1072693248
	.align 8
.LC2:
	.long	0
	.long	1076101120
	.ident	"GCC: (Rev8, Built by MSYS2 project) 15.2.0"
	.def	fgets;	.scl	2;	.type	32;	.endef
	.def	strchr;	.scl	2;	.type	32;	.endef
