.file	"rival.c" # Source file name for symbol/debug metadata
 # GNU C23 (Rev8, Built by MSYS2 project) version 15.2.0 (x86_64-w64-mingw32) # Compiler version and Windows x64 target
 #	compiled by GNU C version 15.2.0, GMP version 6.3.0, MPFR version 4.2.2, MPC version 1.3.1, isl version isl-0.27-GMP # Build dependency versions

 # GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072 # Garbage-collection heuristic parameters
 # options passed: -mtune=generic -march=nocona -O2 # Optimization and baseline x86-64 flags
	.text # Switch to executable code section
	.p2align 4 # Align next symbol to a 16-byte boundary
	.globl	rival_init # Export rival_init globally
	.def	rival_init;	.scl	2;	.type	32;	.endef # COFF symbol attributes: external (2), function (32)
	.seh_proc	rival_init # Begin Windows x64 SEH unwind metadata for rival_init
rival_init: # Entry point of rival_init(RivalBot *r) where r is in %rcx
	.seh_endprologue # Mark end of prologue (no stack frame allocated)
 # rival.c:8:     r->buys = r->sells = 0;
	pxor	%xmm0, %xmm0	 # tmp99 — Zero 128-bit register %xmm0
 # rival.c:6:     r->pnl_fx = 0;
	movq	$0, (%rcx)	 #, r_2(D)->pnl_fx — Store 64-bit 0 at r->pnl_fx (offset +0)
 # rival.c:7:     r->holding = 0;
	movl	$0, 8(%rcx)	 #, r_2(D)->holding — Store 32-bit 0 at r->holding (offset +8)
 # rival.c:8:     r->buys = r->sells = 0;
	movups	%xmm0, 16(%rcx)	 # tmp99, MEM <vector(2) long long int> [(long long int *)r_2(D) + 16B] — Zero 16 bytes at offset +16 (buys, sells)
	movups	%xmm0, 32(%rcx)	 # tmp99, MEM <vector(2) long long int> [(long long int *)r_2(D) + 32B] — Zero 16 bytes at offset +32 (races_won, races_lost)
 # rival.c:10: }
	ret	 # Return to caller
	.seh_endproc # End SEH metadata for rival_init
	.p2align 4 # Align next function to 16 bytes
	.globl	rival_on_signal # Export rival_on_signal globally
	.def	rival_on_signal;	.scl	2;	.type	32;	.endef # COFF function attributes
	.seh_proc	rival_on_signal # Begin SEH metadata for rival_on_signal
rival_on_signal: # Args: %rcx=r, %edx=side, %r8=price_now_fx, %r9=price_next_fx, 40(%rsp)=reaction_ns, 48(%rsp)=rival_ns
	.seh_endprologue # End prologue (no stack frame allocated)
 # rival.c:18:     if (side == 1 && r->holding) return;
	cmpl	$1, %edx	 #, side — Check if side == 1 (buy)
	je	.L15	 #, — Jump to buy handling if side == 1
 # rival.c:19:     if (side == -1 && !r->holding) return;
	cmpl	$-1, %edx	 #, side — Check if side == -1 (sell)
	je	.L7	 #, — Jump to sell handling if side == -1
 # rival.c:23:     long long fill = we_win ? price_now_fx : price_next_fx;
	movq	48(%rsp), %rax	 # rival_ns, tmp127 — Load rival_ns from stack into %rax
	cmpq	%rax, 40(%rsp)	 # tmp127, reaction_ns — Compare reaction_ns against rival_ns
	jb	.L16	 #, — If reaction_ns < rival_ns (unsigned), we win -> .L16
.L8: # Rival wins path (for sell)
 # rival.c:25:     if (we_win) r->races_won++; else r->races_lost++;
	addq	$1, 40(%rcx)	 #, r_20(D)->races_lost — Increment r->races_lost (offset +40)
 # rival.c:23:     long long fill = we_win ? price_now_fx : price_next_fx;
	movq	%r9, %r8	 # price_next_fx, price_now_fx — Select price_next_fx (%r9) as fill price in %r8
.L9: # Execute sell update
 # rival.c:32:         r->pnl_fx += fill;
	addq	%r8, (%rcx)	 # price_now_fx, r_20(D)->pnl_fx — Add fill price to r->pnl_fx (offset +0)
 # rival.c:34:         r->sells++;
	addq	$1, 24(%rcx)	 #, r_20(D)->sells — Increment r->sells (offset +24)
 # rival.c:33:         r->holding = 0;
	movl	$0, 8(%rcx)	 #, r_20(D)->holding — Clear r->holding = 0 (offset +8)
.L3: # Common return label
 # rival.c:36: }
	ret	 # Return to caller
	.p2align 4,,10 # Align loop/branch target up to 16 bytes (skip if >10 bytes needed)
	.p2align 3 # Prefer 8-byte alignment
.L7: # Sell guard check
 # rival.c:19:     if (side == -1 && !r->holding) return;
	movl	8(%rcx), %eax	 # r_20(D)->holding, — Load r->holding into %eax
	testl	%eax, %eax	 # — Test if r->holding == 0
	je	.L3	 #, — Return early if not holding a position
 # rival.c:23:     long long fill = we_win ? price_now_fx : price_next_fx;
	movq	48(%rsp), %rax	 # rival_ns, tmp127 — Load rival_ns
	cmpq	%rax, 40(%rsp)	 # tmp127, reaction_ns — Compare reaction_ns vs rival_ns
	jnb	.L8	 #, — If reaction_ns >= rival_ns, rival wins -> .L8
.L16: # We win path (for sell)
 # rival.c:25:     if (we_win) r->races_won++; else r->races_lost++;
	addq	$1, 32(%rcx)	 #, r_20(D)->races_won — Increment r->races_won (offset +32)
	jmp	.L9	 # — Proceed to sell accounting (%r8 already holds price_now_fx)
	.p2align 4,,10 # Align target up to 16 bytes
	.p2align 3 # Prefer 8-byte alignment
.L15: # Buy guard check
 # rival.c:18:     if (side == 1 && r->holding) return;
	movl	8(%rcx), %edx	 # r_20(D)->holding, — Load r->holding into %edx
	testl	%edx, %edx	 # — Test if r->holding != 0
	jne	.L3	 #, — Return early if already holding
 # rival.c:23:     long long fill = we_win ? price_now_fx : price_next_fx;
	movq	48(%rsp), %rax	 # rival_ns, tmp128 — Load rival_ns
	cmpq	%rax, 40(%rsp)	 # tmp128, reaction_ns — Compare reaction_ns vs rival_ns
	jb	.L17	 #, — If reaction_ns < rival_ns, we win -> .L17
 # rival.c:25:     if (we_win) r->races_won++; else r->races_lost++;
	addq	$1, 40(%rcx)	 #, r_20(D)->races_lost — Rival won buy race: r->races_lost++
 # rival.c:23:     long long fill = we_win ? price_now_fx : price_next_fx;
	movq	%r9, %r8	 # price_next_fx, price_now_fx — Select price_next_fx (%r9) as fill price
.L12: # Execute buy update
 # rival.c:28:         r->pnl_fx -= fill;
	subq	%r8, (%rcx)	 # price_now_fx, r_20(D)->pnl_fx — Subtract fill price from r->pnl_fx
 # rival.c:30:         r->buys++;
	addq	$1, 16(%rcx)	 #, r_20(D)->buys — Increment r->buys (offset +16)
 # rival.c:29:         r->holding = 1;
	movl	$1, 8(%rcx)	 #, r_20(D)->holding — Set r->holding = 1
 # rival.c:36: }
	ret	 # Return to caller
	.p2align 4,,10 # Align target up to 16 bytes
	.p2align 3 # Prefer 8-byte alignment
.L17: # We win path (for buy)
 # rival.c:25:     if (we_win) r->races_won++; else r->races_lost++;
	addq	$1, 32(%rcx)	 #, r_20(D)->races_won — Increment r->races_won
	jmp	.L12	 # — Proceed to buy accounting (%r8 already holds price_now_fx)
	.seh_endproc # End SEH metadata for rival_on_signal
	.p2align 4 # Align rival_pnl to 16 bytes
	.globl	rival_pnl # Export rival_pnl globally
	.def	rival_pnl;	.scl	2;	.type	32;	.endef # COFF function attributes
	.seh_proc	rival_pnl # Begin SEH metadata for rival_pnl
rival_pnl: # Entry point of rival_pnl(const RivalBot *r) where r is in %rcx
	.seh_endprologue # End prologue
 # rival.c:40:     return (double)r->pnl_fx / (double)RIVAL_PRICE_SCALE;
	pxor	%xmm0, %xmm0	 # _2 — Clear %xmm0 before scalar int-to-double conversion
	cvtsi2sdq	(%rcx), %xmm0	 # r_4(D)->pnl_fx, _2 — Convert 64-bit r->pnl_fx to double in %xmm0
 # rival.c:40:     return (double)r->pnl_fx / (double)RIVAL_PRICE_SCALE;
	divsd	.LC0(%rip), %xmm0	 #, _5 — Divide %xmm0 by scale factor 100.0 at .LC0
 # rival.c:41: }
	ret	 # Return double in %xmm0
	.seh_endproc # End SEH metadata for rival_pnl
	.section .rdata,"dr" # Read-only data section (discardable/read-only)
	.align 8 # 8-byte alignment for IEEE-754 double
.LC0: # Constant 100.0 (0x4059000000000000 in little-endian 32-bit words)
	.long	0 # Low 32 bits of 100.0 double
	.long	1079574528 # High 32 bits of 100.0 double (0x40590000)
	.ident	"GCC: (Rev8, Built by MSYS2 project) 15.2.0" # Compiler identification string
```[cite: 1]

---

### 2. `StageA+_O2.s` (Annotated)

```assembly
	.file	"StageA+.c" # Source file name
 # GNU C23 (Rev8, Built by MSYS2 project) version 15.2.0 (x86_64-w64-mingw32) # Compiler and target ABI
 #	compiled by GNU C version 15.2.0, GMP version 6.3.0, MPFR version 4.2.2, MPC version 1.3.1, isl version isl-0.27-GMP # Build info

 # GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072 # GC parameters
 # options passed: -mtune=generic -march=nocona -O2 # Optimization flags
	.text # Code section
	.p2align 4 # 16-byte alignment
	.def	fast_parse_double;	.scl	3;	.type	32;	.endef # Static (internal) function symbol
	.seh_proc	fast_parse_double # Begin SEH metadata
fast_parse_double: # Args: %rcx=cursor (const char **), %rdx=result (double *)
	.seh_endprologue # End prologue
 # StageA+.c:31: static int fast_parse_double(const char **cursor, double *result) {
	movq	%rdx, %r10	 # result, result — Save result pointer in %r10
 # StageA+.c:32:     const char *p = *cursor;
	movq	(%rcx), %rdx	 # *cursor_31(D), p — Load input cursor p = *cursor into %rdx
 # StageA+.c:31: static int fast_parse_double(const char **cursor, double *result) {
	movq	%rcx, %r9	 # cursor, cursor — Save cursor pointer in %r9
 # StageA+.c:38:     while (*p >= '0' && *p <= '9') {
	movzbl	(%rdx), %eax	 # *p_32, _5 — Zero-extend *p into %eax
 # StageA+.c:38:     while (*p >= '0' && *p <= '9') {
	leal	-48(%rax), %ecx	 #, _56 — Compute *p - '0' ('0' == 48)
	cmpb	$9, %cl	 #, _56 — Unsigned check: >9 means not a digit
	ja	.L2	 #, — Jump to .L2 if first char is not '0'..'9'
	movsd	.LC2(%rip), %xmm2	 #, tmp143 — Load 10.0 constant into %xmm2
 # StageA+.c:33:     double whole = 0.0;
	pxor	%xmm0, %xmm0	 # whole — Initialize whole = 0.0
	.p2align 6 # Align loop to 64 bytes
	.p2align 4 # 16-byte alignment
	.p2align 3 # 8-byte alignment
.L3: # Integer-part digit loop
 # StageA+.c:39:         whole = whole * 10.0 + (*p - '0');
	mulsd	%xmm2, %xmm0	 # tmp143, _1 — whole *= 10.0
 # StageA+.c:39:         whole = whole * 10.0 + (*p - '0');
	subl	$48, %eax	 #, _67 — digit = *p - '0'
	pxor	%xmm1, %xmm1	 # _4 — Clear %xmm1 before int-to-double conversion
	movq	%rdx, %rcx	 # p, p — Keep previous pointer in %rcx
	movsbl	%al, %eax	 # _67, _67 — Sign-extend byte digit to 32-bit int
 # StageA+.c:40:         p++;
	addq	$1, %rdx	 #, p — Advance p++
 # StageA+.c:39:         whole = whole * 10.0 + (*p - '0');
	cvtsi2sdl	%eax, %xmm1	 # _67, _4 — Convert digit to double in %xmm1
 # StageA+.c:38:     while (*p >= '0' && *p <= '9') {
	movzbl	(%rdx), %eax	 # MEM[(const char *)p_42], _5 — Load next character *p
 # StageA+.c:38:     while (*p >= '0' && *p <= '9') {
	leal	-48(%rax), %r8d	 #, _7 — Compute *p - '0'
 # StageA+.c:39:         whole = whole * 10.0 + (*p - '0');
	addsd	%xmm1, %xmm0	 # _4, whole — whole += (double)digit
 # StageA+.c:38:     while (*p >= '0' && *p <= '9') {
	cmpb	$9, %r8b	 #, _7 — Check if next char is in '0'..'9'
	jbe	.L3	 #, — Loop while digit
	pxor	%xmm1, %xmm1	 # _80 — Default fractional contribution = 0.0
 # StageA+.c:44:     if (*p == '.') {
	cmpb	$46, %al	 #, _5 — Check if *p == '.' (ASCII 46)
	je	.L17	 #, — Jump to decimal handling if '.'
.L7: # Finalize result
 # StageA+.c:56:     *result = whole + fraction / scale;
	addsd	%xmm1, %xmm0	 # _80, _16 — result_val = whole + (fraction / scale)
 # StageA+.c:58:     return 1;
	movl	$1, %ecx	 #, <retval> — Set return value = 1 (success)
 # StageA+.c:56:     *result = whole + fraction / scale;
	movsd	%xmm0, (%r10)	 # _16, *result_38(D) — Store parsed double into *result
 # StageA+.c:57:     *cursor = p;
	movq	%rdx, (%r9)	 # p, *cursor_31(D) — Update *cursor = p
.L1: # Function exit
 # StageA+.c:59: }
	movl	%ecx, %eax	 # <retval>, — Move return code into %eax
	ret	 # Return to caller
	.p2align 4,,10 # Alignment hint
	.p2align 3 # 8-byte alignment
.L17: # Decimal point seen after whole digits
 # StageA+.c:46:         while (*p >= '0' && *p <= '9') {
	movzbl	1(%rdx), %eax	 # MEM[(const char *)p_42 + 1B], _12 — Look ahead at character after '.'
 # StageA+.c:45:         p++;
	addq	$2, %rcx	 #, p — Advance cursor past '.' and first fractional char position
 # StageA+.c:46:         while (*p >= '0' && *p <= '9') {
	leal	-48(%rax), %edx	 #, _50 — Check if lookahead char is a digit
	cmpb	$9, %dl	 #, _50 — Unsigned check <= 9
	ja	.L12	 #, — Jump to .L12 if no fractional digits follow '.'
.L6: # Initialize fractional parsing
 # StageA+.c:35:     double scale = 1.0;
	movsd	.LC1(%rip), %xmm3	 #, scale — Load scale = 1.0 (.LC1) into %xmm3
 # StageA+.c:34:     double fraction = 0.0;
	pxor	%xmm1, %xmm1	 # fraction — Initialize fraction = 0.0 in %xmm1
	.p2align 6 # 64-byte loop alignment
	.p2align 4 # 16-byte alignment
	.p2align 3 # 8-byte alignment
.L8: # Fractional digit loop
 # StageA+.c:47:             fraction = fraction * 10.0 + (*p - '0');
	mulsd	%xmm2, %xmm1	 # tmp143, _8 — fraction *= 10.0
 # StageA+.c:47:             fraction = fraction * 10.0 + (*p - '0');
	subl	$48, %eax	 #, _43 — digit = *p - '0'
	pxor	%xmm4, %xmm4	 # _11 — Clear %xmm4 for int-to-double conversion
 # StageA+.c:49:             p++;
	addq	$1, %rcx	 #, p — Advance pointer p++
 # StageA+.c:48:             scale *= 10.0;
	mulsd	%xmm2, %xmm3	 # tmp143, scale — scale *= 10.0
 # StageA+.c:47:             fraction = fraction * 10.0 + (*p - '0');
	movsbl	%al, %eax	 # _43, _43 — Sign-extend digit to 32-bit int
	cvtsi2sdl	%eax, %xmm4	 # _43, _11 — Convert digit to double in %xmm4
 # StageA+.c:46:         while (*p >= '0' && *p <= '9') {
	movzbl	(%rcx), %eax	 # MEM[(const char *)p_36], _12 — Load next fractional character
 # StageA+.c:46:         while (*p >= '0' && *p <= '9') {
	leal	-48(%rax), %edx	 #, _14 — Check *p - '0'
 # StageA+.c:47:             fraction = fraction * 10.0 + (*p - '0');
	addsd	%xmm4, %xmm1	 # _11, fraction — fraction += (double)digit
 # StageA+.c:46:         while (*p >= '0' && *p <= '9') {
	cmpb	$9, %dl	 #, _14 — Loop if character is in '0'..'9'
	jbe	.L8	 #, — Continue fractional loop
 # StageA+.c:56:     *result = whole + fraction / scale;
	divsd	%xmm3, %xmm1	 # scale, _80 — Compute fraction / scale in %xmm1
	movq	%rcx, %rdx	 # p, p — Update final cursor pointer in %rdx
	jmp	.L7	 # — Combine with whole and store result
	.p2align 4,,10 # Alignment hint
	.p2align 3 # 8-byte alignment
.L2: # No leading integer digits path
 # StageA+.c:54:     if (digits == 0) return 0;
	xorl	%ecx, %ecx	 # <retval> — Default return code = 0 (failure)
 # StageA+.c:44:     if (*p == '.') {
	cmpb	$46, %al	 #, _5 — Check if *p == '.' (leading decimal like ".5")
	jne	.L1	 #, — Return 0 if not '.'
 # StageA+.c:46:         while (*p >= '0' && *p <= '9') {
	movzbl	1(%rdx), %eax	 # MEM[(const char *)p_32 + 1B], _12 — Check char after '.'
 # StageA+.c:46:         while (*p >= '0' && *p <= '9') {
	leal	-48(%rax), %r8d	 #, _46 — Check if digit
	cmpb	$9, %r8b	 #, _46 — Unsigned check <= 9
	ja	.L1	 #, — Return 0 if '.' is not followed by a digit
	movsd	.LC2(%rip), %xmm2	 #, tmp143 — Load 10.0 into %xmm2
 # StageA+.c:45:         p++;
	leaq	1(%rdx), %rcx	 #, p — Point %rcx to first fractional digit
 # StageA+.c:33:     double whole = 0.0;
	pxor	%xmm0, %xmm0	 # whole — whole = 0.0
	jmp	.L6	 # — Enter fractional parsing loop
.L12: # Trailing dot with no fractional digits
 # StageA+.c:45:         p++;
	movq	%rcx, %rdx	 # p, p — Advance pointer past '.'
	jmp	.L7	 # — Store whole result (%xmm1 already 0.0)
	.seh_endproc # End SEH metadata for fast_parse_double
	.p2align 4 # 16-byte alignment
	.def	fast_parse_fixed;	.scl	3;	.type	32;	.endef # Static function fast_parse_fixed
	.seh_proc	fast_parse_fixed # Begin SEH metadata
fast_parse_fixed: # Args: %rcx=cursor, %edx=decimals, %r8=result (long long *)
	pushq	%rbx	 # — Save callee-saved register %rbx
	.seh_pushreg	%rbx # Record push of %rbx for SEH
	.seh_endprologue # End prologue
 # StageA+.c:112: static int fast_parse_fixed(const char **cursor, int decimals, long long *result) {
	movq	%rcx, %r10	 # cursor, cursor — Save cursor pointer in %r10
 # StageA+.c:113:     const char *p = *cursor;
	movq	(%rcx), %rcx	 # *cursor_33(D), p — Load p = *cursor into %rcx
 # StageA+.c:112: static int fast_parse_fixed(const char **cursor, int decimals, long long *result) {
	movl	%edx, %r11d	 # decimals, decimals — Save decimals count in %r11d
 # StageA+.c:118:     while (*p >= '0' && *p <= '9') {
	movzbl	(%rcx), %eax	 # *p_34, _5 — Load *p into %eax
 # StageA+.c:118:     while (*p >= '0' && *p <= '9') {
	leal	-48(%rax), %edx	 #, _63 — *p - '0'
	cmpb	$9, %dl	 #, _63 — Check if digit
	ja	.L19	 #, — Jump to .L19 if not starting with digit
 # StageA+.c:114:     long long value = 0;
	xorl	%edx, %edx	 # value — Initialize 64-bit fixed-point accumulator value = 0
	.p2align 6 # 64-byte loop alignment
	.p2align 4 # 16-byte alignment
	.p2align 3 # 8-byte alignment
.L20: # Integer digit accumulation loop
 # StageA+.c:119:         value = value * 10 + (*p - '0');
	subl	$48, %eax	 #, _77 — digit = *p - '0'
	movq	%rcx, %rbx	 # p, p — Save cursor position in %rbx
 # StageA+.c:119:         value = value * 10 + (*p - '0');
	leaq	(%rdx,%rdx,4), %rdx	 #, _1 — value = value * 5
 # StageA+.c:120:         p++;
	addq	$1, %rcx	 #, p — Advance p++
 # StageA+.c:119:         value = value * 10 + (*p - '0');
	movsbq	%al, %rax	 # _77, _4 — Sign-extend digit to 64-bit
 # StageA+.c:119:         value = value * 10 + (*p - '0');
	leaq	(%rax,%rdx,2), %rdx	 #, value — value = digit + 2 * (value * 5) = value * 10 + digit
 # StageA+.c:118:     while (*p >= '0' && *p <= '9') {
	movzbl	(%rcx), %eax	 # MEM[(const char *)p_47], _5 — Load next character *p
 # StageA+.c:118:     while (*p >= '0' && *p <= '9') {
	leal	-48(%rax), %r9d	 #, _7 — Check *p - '0'
	cmpb	$9, %r9b	 #, _7 — Loop while digit
	jbe	.L20	 #, — Continue integer digit loop
 # StageA+.c:116:     int frac = 0;
	xorl	%r9d, %r9d	 # frac — Initialize fractional digit counter frac = 0
 # StageA+.c:124:     if (*p == '.') {
	cmpb	$46, %al	 #, _5 — Check if *p == '.'
	je	.L37	 #, — Jump to decimal handling if '.'
	.p2align 4 # 16-byte alignment
	.p2align 4 # 16-byte alignment
	.p2align 3 # 8-byte alignment
.L28: # Pad remaining fractional places with * 10
 # StageA+.c:139:         value *= 10;
	leaq	(%rdx,%rdx,4), %rdx	 #, value_44 — value *= 5
 # StageA+.c:140:         frac++;
	addl	$1, %r9d	 #, frac — frac++
 # StageA+.c:139:         value *= 10;
	addq	%rdx, %rdx	 # value — value *= 2 (total * 10)
 # StageA+.c:138:     while (frac < decimals) {               /* pad if fewer decimals were given */
	cmpl	%r9d, %r11d	 # frac, decimals — Compare decimals with frac
	jg	.L28	 #, — Loop while frac < decimals
.L27: # Store parsed fixed-point integer and cursor
 # StageA+.c:143:     *result = value;
	movq	%rdx, (%r8)	 # value, *result_41(D) — Store 64-bit value into *result
 # StageA+.c:145:     return 1;
	movl	$1, %edx	 #, <retval> — Set return code = 1
 # StageA+.c:144:     *cursor = p;
	movq	%rcx, (%r10)	 # p, *cursor_33(D) — Update *cursor = p
.L18: # Function exit
 # StageA+.c:146: }
	movl	%edx, %eax	 # <retval>, — Return code in %eax
	popq	%rbx	 # — Restore %rbx
	ret	 # Return to caller
	.p2align 4,,10 # Alignment hint
	.p2align 3 # 8-byte alignment
.L37: # Decimal point reached after integer digits
 # StageA+.c:126:         while (*p >= '0' && *p <= '9') {
	movzbl	1(%rcx), %eax	 # MEM[(const char *)p_47 + 1B], _10 — Peek char after '.'
 # StageA+.c:125:         p++;
	addq	$2, %rbx	 #, p — Advance saved pointer past '.' + 1
 # StageA+.c:126:         while (*p >= '0' && *p <= '9') {
	leal	-48(%rax), %ecx	 #, _60 — Check if digit
	cmpb	$9, %cl	 #, _60 — Unsigned check <= 9
	ja	.L32	 #, — Jump if not a digit
.L23: # Start fractional digit loop
 # StageA+.c:125:         p++;
	movq	%rbx, %rcx	 # p, p — Set active pointer %rcx to fractional digit
 # StageA+.c:116:     int frac = 0;
	xorl	%r9d, %r9d	 # frac — frac = 0
	.p2align 6 # 64-byte loop alignment
	.p2align 4 # 16-byte alignment
	.p2align 3 # 8-byte alignment
.L26: # Fractional digit loop (up to `decimals` digits)
 # StageA+.c:127:             if (frac < decimals) {          /* keep only 'decimals' digits */
	cmpl	%r11d, %r9d	 # decimals, frac — Check if frac < decimals
	jge	.L25	 #, — Skip accumulation if already kept `decimals` digits
 # StageA+.c:128:                 value = value * 10 + (*p - '0');
	subl	$48, %eax	 #, _28 — digit = *p - '0'
 # StageA+.c:128:                 value = value * 10 + (*p - '0');
	leaq	(%rdx,%rdx,4), %rdx	 #, _29 — value * 5
 # StageA+.c:129:                 frac++;
	addl	$1, %r9d	 #, frac — frac++
 # StageA+.c:128:                 value = value * 10 + (*p - '0');
	movsbq	%al, %rax	 # _28, _27 — Sign-extend digit
 # StageA+.c:128:                 value = value * 10 + (*p - '0');
	leaq	(%rax,%rdx,2), %rdx	 #, value — value = value * 10 + digit
.L25: # Advance and test next fractional char
 # StageA+.c:126:         while (*p >= '0' && *p <= '9') {
	movzbl	1(%rcx), %eax	 # MEM[(const char *)p_21], _10 — Load next char
 # StageA+.c:131:             p++;
	addq	$1, %rcx	 #, p — p++
 # StageA+.c:126:         while (*p >= '0' && *p <= '9') {
	leal	-48(%rax), %ebx	 #, _17 — Check if digit
	cmpb	$9, %bl	 #, _17 — Loop while digit
	jbe	.L26	 #, — Continue fractional loop
 # StageA+.c:138:     while (frac < decimals) {               /* pad if fewer decimals were given */
	cmpl	%r9d, %r11d	 # frac, decimals — Check if padding needed
	jl	.L28	 #, — Pad zeros if frac < decimals
	jmp	.L27	 # — Otherwise finish and store
	.p2align 4,,10 # Alignment hint
	.p2align 3 # 8-byte alignment
.L19: # No integer digits at start
 # StageA+.c:136:     if (digits == 0) return 0;
	xorl	%edx, %edx	 # <retval> — Default return = 0
 # StageA+.c:124:     if (*p == '.') {
	cmpb	$46, %al	 #, _5 — Check for leading '.'
	jne	.L18	 #, — Return 0 if not '.'
 # StageA+.c:126:         while (*p >= '0' && *p <= '9') {
	movzbl	1(%rcx), %eax	 # MEM[(const char *)p_34 + 1B], _10 — Peek after '.'
 # StageA+.c:126:         while (*p >= '0' && *p <= '9') {
	leal	-48(%rax), %r9d	 #, _16 — Check if digit
	cmpb	$9, %r9b	 #, _16 — Unsigned check <= 9
	ja	.L18	 #, — Return 0 if invalid
 # StageA+.c:125:         p++;
	leaq	1(%rcx), %rbx	 #, p — Point %rbx to first fractional digit
 # StageA+.c:114:     long long value = 0;
	xorl	%edx, %edx	 # value — value = 0
	jmp	.L23	 # — Begin fractional digit loop
.L32: # Dot followed by non-digit
 # StageA+.c:125:         p++;
	movq	%rbx, %rcx	 # p, p — Advance pointer
	jmp	.L28	 # — Pad any remaining decimal places
	.seh_endproc # End SEH metadata for fast_parse_fixed
	.p2align 4 # 16-byte alignment
	.globl	read_trade # Export read_trade globally
	.def	read_trade;	.scl	2;	.type	32;	.endef # COFF function attributes
	.seh_proc	read_trade # Begin SEH metadata for read_trade
read_trade: # Args: %rcx=fp, %rdx=ts, %r8=price, %r9=qty, stack=is_buy
	pushq	%r15	 # — Save non-volatile registers
	.seh_pushreg	%r15 # SEH push record
	pushq	%r14	 # — Save %r14
	.seh_pushreg	%r14 # SEH push record
	pushq	%r13	 # — Save %r13
	.seh_pushreg	%r13 # SEH push record
	pushq	%r12	 # — Save %r12
	.seh_pushreg	%r12 # SEH push record
	pushq	%rbp	 # — Save %rbp
	.seh_pushreg	%rbp # SEH push record
	pushq	%rdi	 # — Save %rdi
	.seh_pushreg	%rdi # SEH push record
	pushq	%rsi	 # — Save %rsi
	.seh_pushreg	%rsi # SEH push record
	pushq	%rbx	 # — Save %rbx
	.seh_pushreg	%rbx # SEH push record
	subq	$344, %rsp	 #, — Allocate 344-byte stack frame (line buf + scratch + shadow space)
	.seh_stackalloc	344 # Record stack allocation for SEH
	.seh_endprologue # End prologue
 # StageA+.c:61: int read_trade(FILE *fp, long long *ts, double *price, double *qty, int *is_buy) {
	movq	%rcx, %rsi	 # fp, fp — Save FILE *fp in %rsi
	leaq	80(%rsp), %rbx	 #, tmp170 — %rbx = &line[0] at 80(%rsp)
 # StageA+.c:74:         if (!fast_parse_double(&end, &parsed_price) || *end != ',') continue;
	leaq	56(%rsp), %rdi	 #, tmp172 — %rdi = &end at 56(%rsp)
 # StageA+.c:61: int read_trade(FILE *fp, long long *ts, double *price, double *qty, int *is_buy) {
	movq	%r8, %r14	 # price, price — Save price pointer in %r14
	movq	%rdx, 424(%rsp)	 # ts, ts — Spill ts pointer to stack
 # StageA+.c:80:         if (!fast_parse_double(&end, &parsed_qty) || *end != ',') continue;
	leaq	72(%rsp), %r13	 #, tmp173 — %r13 = &parsed_qty at 72(%rsp)
 # StageA+.c:61: int read_trade(FILE *fp, long long *ts, double *price, double *qty, int *is_buy) {
	movq	%r9, 440(%rsp)	 # qty, qty — Spill qty pointer to stack
	.p2align 4 # Loop alignment
	.p2align 3 # 8-byte alignment
.L39: # Main line-reading loop
 # StageA+.c:64:     while (fgets(line, sizeof line, fp) != NULL) {
	movq	%rsi, %r8	 # fp, — Arg 3: fp
	movl	$256, %edx	 #, — Arg 2: sizeof(line) = 256
	movq	%rbx, %rcx	 # tmp170, — Arg 1: line buffer
	call	fgets	 # — Read next line from stream
 # StageA+.c:64:     while (fgets(line, sizeof line, fp) != NULL) {
	testq	%rax, %rax	 # _17 — Check if fgets returned NULL (EOF/error)
	je	.L67	 #, — Exit with 0 if NULL
 # StageA+.c:7:     char *comma = strchr(p, ',');
	movl	$44, %edx	 #, — Arg 2: ',' (ASCII 44)
	movq	%rbx, %rcx	 # tmp170, — Arg 1: line
	call	strchr	 # — Find first comma
 # StageA+.c:8:     if (comma == NULL) return NULL;
	testq	%rax, %rax	 # comma — Check if comma found
	je	.L39	 #, — Skip malformed line
 # StageA+.c:9:     return comma + 1;
	leaq	1(%rax), %r11	 #, _55 — Advance pointer to character after comma
 # StageA+.c:74:         if (!fast_parse_double(&end, &parsed_price) || *end != ',') continue;
	leaq	64(%rsp), %rdx	 #, — &parsed_price at 64(%rsp)
	movq	%rdi, %rcx	 # tmp172, — &end
 # StageA+.c:73:         end = p;
	movq	%r11, 56(%rsp)	 # _55, end — end = p
 # StageA+.c:74:         if (!fast_parse_double(&end, &parsed_price) || *end != ',') continue;
	call	fast_parse_double	 # — Parse price double (inlined)
 # StageA+.c:74:         if (!fast_parse_double(&end, &parsed_price) || *end != ',') continue;
	testl	%eax, %eax	 # _1 — Check parse success
	je	.L39	 #, — Retry next line on failure
 # StageA+.c:74:         if (!fast_parse_double(&end, &parsed_price) || *end != ',') continue;
	movq	56(%rsp), %rax	 # end, end — Load updated end pointer
 # StageA+.c:74:         if (!fast_parse_double(&end, &parsed_price) || *end != ',') continue;
	cmpb	$44, (%rax)	 #, *end.0_2 — Verify delimiter is ','
	jne	.L39	 #, — Skip if not followed by comma
 # StageA+.c:7:     char *comma = strchr(p, ',');
	movl	$44, %edx	 #, — Search for ','
	movq	%r11, %rcx	 # _55, — From current position
	call	strchr	 # — Locate next comma
 # StageA+.c:8:     if (comma == NULL) return NULL;
	testq	%rax, %rax	 # comma — Check comma existence
	je	.L39	 #, — Skip if missing
 # StageA+.c:9:     return comma + 1;
	leaq	1(%rax), %r11	 #, _58 — Advance past comma
 # StageA+.c:80:         if (!fast_parse_double(&end, &parsed_qty) || *end != ',') continue;
	movq	%r13, %rdx	 # tmp173, — &parsed_qty
	movq	%rdi, %rcx	 # tmp172, — &end
 # StageA+.c:79:         end = p;
	movq	%r11, 56(%rsp)	 # _58, end — end = p
 # StageA+.c:80:         if (!fast_parse_double(&end, &parsed_qty) || *end != ',') continue;
	call	fast_parse_double	 # — Parse quantity double
	movl	%eax, %ebp	 # <retval>, <retval> — Save status in %ebp
 # StageA+.c:80:         if (!fast_parse_double(&end, &parsed_qty) || *end != ',') continue;
	testl	%eax, %eax	 # <retval> — Check success
	je	.L39	 #, — Skip line on failure
 # StageA+.c:80:         if (!fast_parse_double(&end, &parsed_qty) || *end != ',') continue;
	movq	56(%rsp), %rax	 # end, end — Load end pointer
 # StageA+.c:80:         if (!fast_parse_double(&end, &parsed_qty) || *end != ',') continue;
	cmpb	$44, (%rax)	 #, *end.1_5 — Check ',' delimiter
	jne	.L39	 #, — Skip if not ','
 # StageA+.c:7:     char *comma = strchr(p, ',');
	movl	$44, %edx	 #, — Search for ','
	movq	%r11, %rcx	 # _58, — Current cursor
	call	strchr	 # — Find next comma
 # StageA+.c:8:     if (comma == NULL) return NULL;
	testq	%rax, %rax	 # comma — Check comma
	je	.L39	 #, — Skip if NULL
 # StageA+.c:7:     char *comma = strchr(p, ',');
	movl	$44, %edx	 #, — Search for ','
 # StageA+.c:9:     return comma + 1;
	leaq	1(%rax), %rcx	 #, _61 — Advance past comma
 # StageA+.c:7:     char *comma = strchr(p, ',');
	call	strchr	 # — Find comma before timestamp/side field
	movq	%rax, %rdx	 #, comma — Save comma pointer
 # StageA+.c:8:     if (comma == NULL) return NULL;
	testq	%rax, %rax	 # comma — Check comma
	je	.L39	 #, — Skip if NULL
 # StageA+.c:16:     if (*p < '0' || *p > '9') return 0;
	movzbl	1(%rax), %eax	 # MEM[(const char *)comma_63 + 1B], _70 — First char of timestamp field
 # StageA+.c:16:     if (*p < '0' || *p > '9') return 0;
	leal	-48(%rax), %ecx	 #, _69 — Check digit range
 # StageA+.c:16:     if (*p < '0' || *p > '9') return 0;
	cmpb	$9, %cl	 #, _69 — Must be '0'..'9'
	ja	.L39	 #, — Skip if not a digit
 # StageA+.c:9:     return comma + 1;
	leaq	1(%rdx), %rcx	 #, _64 — Timestamp start pointer
 # StageA+.c:20:         if (value > (LLONG_MAX - digit) / 10) return 0;
	movq	%r13, %rdx	 # tmp173, tmp173 — Reload scratch pointer
	movl	%ebp, %r15d	 # <retval>, <retval> — Preserve status
	movq	%rdi, %r13	 # tmp172, tmp172 — Preserve &end
 # StageA+.c:14:     long long value = 0;
	xorl	%r8d, %r8d	 # value — value = 0
 # StageA+.c:20:         if (value > (LLONG_MAX - digit) / 10) return 0;
	movq	%rbx, %rdi	 # tmp170, tmp170 — Preserve line pointer
	movq	%rcx, %rbp	 # _64, _64 — Save timestamp cursor in %rbp
	movq	%rdx, %rbx	 # tmp173, tmp173 — Save scratch pointer
 # StageA+.c:20:         if (value > (LLONG_MAX - digit) / 10) return 0;
	movabsq	$9223372036854775807, %r11	 #, tmp148 — LLONG_MAX constant
 # StageA+.c:20:         if (value > (LLONG_MAX - digit) / 10) return 0;
	movabsq	$-3689348814741910323, %r10	 #, tmp151 — Magic reciprocal for unsigned /10
	jmp	.L41	 # — Enter timestamp parse loop
	.p2align 6 # 64-byte loop alignment
	.p2align 4,,10 # Alignment hint
	.p2align 3 # 8-byte alignment
.L69: # Accumulate verified timestamp digit
 # StageA+.c:22:         value = value * 10 + digit;
	leaq	(%r8,%r8,4), %rax	 #, _77 — value * 5
 # StageA+.c:23:         p++;
	addq	$1, %rcx	 #, p — p++
 # StageA+.c:22:         value = value * 10 + digit;
	leaq	(%r9,%rax,2), %r8	 #, value — value = value * 10 + digit
 # StageA+.c:18:     while (*p >= '0' && *p <= '9') {
	movzbl	(%rcx), %eax	 # MEM[(const char *)p_80], _70 — Next char *p
 # StageA+.c:18:     while (*p >= '0' && *p <= '9') {
	leal	-48(%rax), %edx	 #, _82 — Check digit
	cmpb	$9, %dl	 #, _82 — Unsigned check <= 9
	ja	.L68	 #, — Exit loop when non-digit encountered
.L41: # Overflow check before multiplying timestamp by 10
 # StageA+.c:20:         if (value > (LLONG_MAX - digit) / 10) return 0;
	leal	-48(%rax), %r9d	 #, _13 — digit = *p - '0'
	movq	%r11, %rdx	 # tmp148, _74 — LLONG_MAX
	movsbq	%r9b, %r9	 # _13, _73 — Sign-extend digit
	subq	%r9, %rdx	 # _73, _74 — LLONG_MAX - digit
 # StageA+.c:20:         if (value > (LLONG_MAX - digit) / 10) return 0;
	movq	%rdx, %rax	 # _74, _74 — Numerator
	mulq	%r10	 # tmp151 — 128-bit unsigned multiply by magic constant
	shrq	$3, %rdx	 #, _75 — Shift right by 3 -> (LLONG_MAX - digit) / 10
 # StageA+.c:20:         if (value > (LLONG_MAX - digit) / 10) return 0;
	cmpq	%r8, %rdx	 # value, _75 — Compare limit against current value
	jge	.L69	 #, — Safe if value <= limit -> .L69
	movq	%rbx, %rax	 # tmp173, tmp173 — Restore registers on overflow
	movq	%rdi, %rbx	 # tmp170, tmp170
	movq	%r13, %rdi	 # tmp172, tmp172
	movq	%rax, %r13	 # tmp173, tmp173
	jmp	.L39	 # — Overflow: skip line and read next
	.p2align 4,,10 # Alignment hint
	.p2align 3 # 8-byte alignment
.L67: # EOF / read failure return 0
 # StageA+.c:101:     return 0;
	xorl	%ebp, %ebp	 # <retval> — Return 0
.L38: # Epilogue and return
 # StageA+.c:102: }
	movl	%ebp, %eax	 # <retval>, — Move return value into %eax
	addq	$344, %rsp	 #, — Deallocate stack frame
	popq	%rbx	 # — Restore callee-saved registers
	popq	%rsi	 #
	popq	%rdi	 #
	popq	%rbp	 #
	popq	%r12	 #
	popq	%r13	 #
	popq	%r14	 #
	popq	%r15	 #
	ret	 # Return to caller
.L68: # Finished timestamp digits; parse side field
 # StageA+.c:88:         if (!fast_parse_ll(&end, &parsed_ts) || *end != ',') continue;
	movq	%rbx, %rdx	 # tmp173, tmp173 — Restore registers
	movq	%rbp, %rcx	 # _64, _64
	movq	%rdi, %rbx	 # tmp170, tmp170
	movl	%r15d, %ebp	 # <retval>, <retval>
	movq	%r13, %rdi	 # tmp172, tmp172
	movq	%rdx, %r13	 # tmp173, tmp173
	cmpb	$44, %al	 #, _70 — Verify timestamp ended at ','
	jne	.L39	 #, — Skip line if not ','
 # StageA+.c:7:     char *comma = strchr(p, ',');
	movl	$44, %edx	 #, — Search for ','
	movq	%r8, 40(%rsp)	 # value, %sfp — Spill parsed timestamp value
	call	strchr	 # — Locate comma before side flag
 # StageA+.c:8:     if (comma == NULL) return NULL;
	testq	%rax, %rax	 # comma — Check comma
	je	.L39	 #, — Skip if missing
 # StageA+.c:93:         *price = parsed_price;
	movsd	64(%rsp), %xmm0	 # parsed_price, parsed_price — Load parsed_price
 # StageA+.c:96:         *is_buy = (*p == 'F' || *p == 'f') ? 1 : 0;
	movzbl	1(%rax), %eax	 # MEM[(char *)comma_84 + 1B], MEM[(char *)comma_84 + 1B] — Load side character
	xorl	%edx, %edx	 # _89 — Default is_buy = 0
 # StageA+.c:94:         *qty = parsed_qty;
	movq	440(%rsp), %rsi	 # qty, tmp213 — Load qty output pointer
 # StageA+.c:93:         *price = parsed_price;
	movq	40(%rsp), %r8	 # %sfp, value — Restore parsed timestamp into %r8
	movsd	%xmm0, (%r14)	 # parsed_price, *price_36(D) — Write *price
 # StageA+.c:94:         *qty = parsed_qty;
	movsd	72(%rsp), %xmm0	 # parsed_qty, parsed_qty — Load parsed_qty
 # StageA+.c:96:         *is_buy = (*p == 'F' || *p == 'f') ? 1 : 0;
	andl	$-33, %eax	 #, _90 — Fold lowercase ASCII letter to uppercase ('a'..'z' -> 'A'..'Z')
	cmpb	$70, %al	 #, _90 — Compare against 'F' (ASCII 70)
 # StageA+.c:96:         *is_buy = (*p == 'F' || *p == 'f') ? 1 : 0;
	movq	448(%rsp), %rax	 # is_buy, is_buy — Load is_buy output pointer
 # StageA+.c:94:         *qty = parsed_qty;
	movsd	%xmm0, (%rsi)	 # parsed_qty, *qty_38(D) — Write *qty
 # StageA+.c:95:         *ts = parsed_ts;
	movq	424(%rsp), %rsi	 # ts, tmp214 — Load ts output pointer
 # StageA+.c:96:         *is_buy = (*p == 'F' || *p == 'f') ? 1 : 0;
	sete	%dl	 #, _89 — Set %dl = 1 if equal to 'F', else 0
 # StageA+.c:95:         *ts = parsed_ts;
	movq	%r8, (%rsi)	 # value, *ts_40(D) — Write *ts
 # StageA+.c:96:         *is_buy = (*p == 'F' || *p == 'f') ? 1 : 0;
	movl	%edx, (%rax)	 # _89, *is_buy_43(D) — Write *is_buy
	jmp	.L38	 # — Return 1 (success)
	.seh_endproc # End SEH metadata for read_trade
	.p2align 4 # 16-byte alignment
	.globl	read_trade_fixed # Export read_trade_fixed globally
	.def	read_trade_fixed;	.scl	2;	.type	32;	.endef # COFF function attributes
	.seh_proc	read_trade_fixed # Begin SEH metadata for read_trade_fixed
read_trade_fixed: # Args: %rcx=fp, %rdx=ts, %r8=price_fx, %r9=qty_fx, stack=is_buy
	pushq	%r15	 # — Save non-volatile registers
	.seh_pushreg	%r15 # SEH push record
	pushq	%r14	 # — Save %r14
	.seh_pushreg	%r14 # SEH push record
	pushq	%r13	 # — Save %r13
	.seh_pushreg	%r13 # SEH push record
	pushq	%r12	 # — Save %r12
	.seh_pushreg	%r12 # SEH push record
	pushq	%rbp	 # — Save %rbp
	.seh_pushreg	%rbp # SEH push record
	pushq	%rdi	 # — Save %rdi
	.seh_pushreg	%rdi # SEH push record
	pushq	%rsi	 # — Save %rsi
	.seh_pushreg	%rsi # SEH push record
	pushq	%rbx	 # — Save %rbx
	.seh_pushreg	%rbx # SEH push record
	subq	$344, %rsp	 #, — Allocate 344-byte stack frame
	.seh_stackalloc	344 # Record stack allocation
	.seh_endprologue # End prologue
 # StageA+.c:167:         if (!fast_parse_fixed(&end, QTY_DECIMALS, &parsed_qty) || *end != ',') continue;
	leaq	72(%rsp), %rax	 #, tmp173 — Address of parsed_qty at 72(%rsp)
 # StageA+.c:149:                      long long *qty_fx, int *is_buy) {
	movq	%rcx, %rsi	 # fp, fp — Save fp in %rsi
	movq	%rdx, %r15	 # ts, ts — Save ts pointer in %r15
	movq	%r8, %r14	 # price_fx, price_fx — Save price_fx pointer in %r14
	movq	%r9, 440(%rsp)	 # qty_fx, qty_fx — Spill qty_fx pointer
 # StageA+.c:167:         if (!fast_parse_fixed(&end, QTY_DECIMALS, &parsed_qty) || *end != ',') continue;
	movq	%rax, 40(%rsp)	 # tmp173, %sfp — Spill &parsed_qty
	.p2align 4 # Loop alignment
	.p2align 3 # 8-byte alignment
.L71: # Fixed-point line-reading loop
 # StageA+.c:152:     while (fgets(line, sizeof line, fp) != NULL) {
	movq	%rsi, %r8	 # fp, — Arg 3: fp
	movl	$256, %edx	 #, — Arg 2: 256
	leaq	80(%rsp), %rcx	 #, — Arg 1: line buffer
	call	fgets	 # — Read line
 # StageA+.c:152:     while (fgets(line, sizeof line, fp) != NULL) {
	testq	%rax, %rax	 # _17 — Check EOF/error
	je	.L99	 #, — Return 0 if NULL
 # StageA+.c:7:     char *comma = strchr(p, ',');
	movl	$44, %edx	 #, — Search for ','
	leaq	80(%rsp), %rcx	 #, — line buffer
	call	strchr	 # — Find first comma
 # StageA+.c:8:     if (comma == NULL) return NULL;
	testq	%rax, %rax	 # comma — Check comma
	je	.L71	 #, — Skip line if missing
 # StageA+.c:9:     return comma + 1;
	leaq	1(%rax), %rbp	 #, _55 — Advance pointer past comma
 # StageA+.c:161:         if (!fast_parse_fixed(&end, PRICE_DECIMALS, &parsed_price) || *end != ',') continue;
	leaq	64(%rsp), %r8	 #, — Arg 3: &parsed_price
	movl	$2, %edx	 #, — Arg 2: PRICE_DECIMALS = 2
	leaq	56(%rsp), %rcx	 #, — Arg 1: &end
 # StageA+.c:160:         end = p;
	movq	%rbp, 56(%rsp)	 # _55, end — end = p
 # StageA+.c:161:         if (!fast_parse_fixed(&end, PRICE_DECIMALS, &parsed_price) || *end != ',') continue;
	call	fast_parse_fixed	 # — Parse fixed-point price (2 decimals)
 # StageA+.c:161:         if (!fast_parse_fixed(&end, PRICE_DECIMALS, &parsed_price) || *end != ',') continue;
	testl	%eax, %eax	 # _1 — Check parse success
	je	.L71	 #, — Retry next line on failure
 # StageA+.c:161:         if (!fast_parse_fixed(&end, PRICE_DECIMALS, &parsed_price) || *end != ',') continue;
	movq	56(%rsp), %rax	 # end, end — Load end pointer
 # StageA+.c:161:         if (!fast_parse_fixed(&end, PRICE_DECIMALS, &parsed_price) || *end != ',') continue;
	cmpb	$44, (%rax)	 #, *end.6_2 — Verify ',' delimiter
	jne	.L71	 #, — Skip line if not ','
 # StageA+.c:7:     char *comma = strchr(p, ',');
	movl	$44, %edx	 #, — Search for ','
	movq	%rbp, %rcx	 # _55, — Current position
	call	strchr	 # — Find next comma
 # StageA+.c:8:     if (comma == NULL) return NULL;
	testq	%rax, %rax	 # comma — Check comma
	je	.L71	 #, — Skip if missing
 # StageA+.c:167:         if (!fast_parse_fixed(&end, QTY_DECIMALS, &parsed_qty) || *end != ',') continue;
	movq	40(%rsp), %r8	 # %sfp, — Arg 3: &parsed_qty
 # StageA+.c:9:     return comma + 1;
	leaq	1(%rax), %r13	 #, _58 — Advance past comma
 # StageA+.c:167:         if (!fast_parse_fixed(&end, QTY_DECIMALS, &parsed_qty) || *end != ',') continue;
	movl	$5, %edx	 #, — Arg 2: QTY_DECIMALS = 5
	leaq	56(%rsp), %rcx	 #, — Arg 1: &end
 # StageA+.c:166:         end = p;
	movq	%r13, 56(%rsp)	 # _58, end — end = p
 # StageA+.c:167:         if (!fast_parse_fixed(&end, QTY_DECIMALS, &parsed_qty) || *end != ',') continue;
	call	fast_parse_fixed	 # — Parse fixed-point quantity (5 decimals)
	movl	%eax, %ebp	 # <retval>, <retval> — Save parse status
 # StageA+.c:167:         if (!fast_parse_fixed(&end, QTY_DECIMALS, &parsed_qty) || *end != ',') continue;
	testl	%eax, %eax	 # <retval> — Check success
	je	.L71	 #, — Skip if failed
 # StageA+.c:167:         if (!fast_parse_fixed(&end, QTY_DECIMALS, &parsed_qty) || *end != ',') continue;
	movq	56(%rsp), %rax	 # end, end — Load end pointer
 # StageA+.c:167:         if (!fast_parse_fixed(&end, QTY_DECIMALS, &parsed_qty) || *end != ',') continue;
	cmpb	$44, (%rax)	 #, *end.7_5 — Verify ',' delimiter
	jne	.L71	 #, — Skip if not ','
 # StageA+.c:7:     char *comma = strchr(p, ',');
	movl	$44, %edx	 #, — Search for ','
	movq	%r13, %rcx	 # _58, — Current cursor
	call	strchr	 # — Find comma
 # StageA+.c:8:     if (comma == NULL) return NULL;
	testq	%rax, %rax	 # comma — Check comma
	je	.L71	 #, — Skip if missing
 # StageA+.c:9:     return comma + 1;
	leaq	1(%rax), %rcx	 #, _61 — Advance past comma
 # StageA+.c:7:     char *comma = strchr(p, ',');
	movl	$44, %edx	 #, — Search for ','
	call	strchr	 # — Find comma before timestamp
	movq	%rax, %rdx	 #, comma — Save comma pointer
 # StageA+.c:8:     if (comma == NULL) return NULL;
	testq	%rax, %rax	 # comma — Check comma
	je	.L71	 #, — Skip if missing
 # StageA+.c:16:     if (*p < '0' || *p > '9') return 0;
	movzbl	1(%rax), %ecx	 # MEM[(const char *)comma_63 + 1B], _70 — First char of timestamp
 # StageA+.c:16:     if (*p < '0' || *p > '9') return 0;
	leal	-48(%rcx), %edx	 #, _69 — Check digit
 # StageA+.c:16:     if (*p < '0' || *p > '9') return 0;
	cmpb	$9, %dl	 #, _69 — Must be '0'..'9'
	ja	.L71	 #, — Skip if non-digit
 # StageA+.c:9:     return comma + 1;
	leaq	1(%rax), %r11	 #, _64 — Timestamp start pointer
 # StageA+.c:14:     long long value = 0;
	xorl	%r13d, %r13d	 # value — value = 0
 # StageA+.c:20:         if (value > (LLONG_MAX - digit) / 10) return 0;
	movabsq	$9223372036854775807, %r10	 #, tmp148 — LLONG_MAX
 # StageA+.c:20:         if (value > (LLONG_MAX - digit) / 10) return 0;
	movabsq	$-3689348814741910323, %r9	 #, tmp151 — Magic /10 multiplier
 # StageA+.c:13:     const char *p = *cursor;
	movq	%r11, %r8	 # _64, p — Initialize cursor p
	.p2align 6 # 64-byte loop alignment
	.p2align 4 # 16-byte alignment
	.p2align 3 # 8-byte alignment
.L73: # Timestamp loop with LLONG_MAX overflow check
 # StageA+.c:20:         if (value > (LLONG_MAX - digit) / 10) return 0;
	subl	$48, %ecx	 #, _13 — digit = *p - '0'
	movq	%r10, %rdx	 # tmp148, _74 — LLONG_MAX
	movsbq	%cl, %rcx	 # _13, _73 — Sign-extend digit
	subq	%rcx, %rdx	 # _73, _74 — LLONG_MAX - digit
 # StageA+.c:20:         if (value > (LLONG_MAX - digit) / 10) return 0;
	movq	%rdx, %rax	 # _74, _74 — Numerator
	mulq	%r9	 # tmp151 — Unsigned multiply by magic constant
	shrq	$3, %rdx	 #, _75 — Shift right by 3 -> floor((LLONG_MAX - digit)/10)
 # StageA+.c:20:         if (value > (LLONG_MAX - digit) / 10) return 0;
	cmpq	%r13, %rdx	 # value, _75 — Compare limit against value
	jl	.L71	 #, — Overflow if limit < value -> skip line
 # StageA+.c:22:         value = value * 10 + digit;
	leaq	0(%r13,%r13,4), %rax	 #, _77 — value * 5
 # StageA+.c:23:         p++;
	addq	$1, %r8	 #, p — Advance p++
 # StageA+.c:22:         value = value * 10 + digit;
	leaq	(%rcx,%rax,2), %r13	 #, value — value = value * 10 + digit
 # StageA+.c:18:     while (*p >= '0' && *p <= '9') {
	movzbl	(%r8), %ecx	 # MEM[(const char *)p_80], _70 — Read next char
 # StageA+.c:18:     while (*p >= '0' && *p <= '9') {
	leal	-48(%rcx), %eax	 #, _82 — Check digit
	cmpb	$9, %al	 #, _82 — Loop while '0'..'9'
	jbe	.L73	 #, — Continue timestamp loop
 # StageA+.c:175:         if (!fast_parse_ll(&end, &parsed_ts) || *end != ',') continue;
	cmpb	$44, %cl	 #, _70 — Verify ',' after timestamp
	jne	.L71	 #, — Skip line if not ','
 # StageA+.c:7:     char *comma = strchr(p, ',');
	movl	$44, %edx	 #, — Search for ','
	movq	%r11, %rcx	 # _64, — Start after comma
	call	strchr	 # — Find comma before side flag
 # StageA+.c:8:     if (comma == NULL) return NULL;
	testq	%rax, %rax	 # comma — Check comma
	je	.L71	 #, — Skip if missing
 # StageA+.c:180:         *price_fx = parsed_price;
	movq	64(%rsp), %rdx	 # parsed_price, parsed_price — Load parsed fixed-point price
 # StageA+.c:183:         *is_buy = (*p == 'F' || *p == 'f') ? 1 : 0;
	movzbl	1(%rax), %eax	 # MEM[(char *)comma_84 + 1B], MEM[(char *)comma_84 + 1B] — Load side byte
 # StageA+.c:181:         *qty_fx = parsed_qty;
	movq	440(%rsp), %rsi	 # qty_fx, tmp211 — Load qty_fx pointer
 # StageA+.c:180:         *price_fx = parsed_price;
	movq	%rdx, (%r14)	 # parsed_price, *price_fx_36(D) — Store *price_fx
 # StageA+.c:181:         *qty_fx = parsed_qty;
	movq	72(%rsp), %rdx	 # parsed_qty, parsed_qty — Load parsed fixed-point qty
 # StageA+.c:183:         *is_buy = (*p == 'F' || *p == 'f') ? 1 : 0;
	andl	$-33, %eax	 #, _90 — Case-fold ASCII letter to uppercase
 # StageA+.c:181:         *qty_fx = parsed_qty;
	movq	%rdx, (%rsi)	 # parsed_qty, *qty_fx_38(D) — Store *qty_fx
 # StageA+.c:183:         *is_buy = (*p == 'F' || *p == 'f') ? 1 : 0;
	xorl	%edx, %edx	 # _89 — Default is_buy = 0
	cmpb	$70, %al	 #, _90 — Compare with 'F' (70)
 # StageA+.c:183:         *is_buy = (*p == 'F' || *p == 'f') ? 1 : 0;
	movq	448(%rsp), %rax	 # is_buy, is_buy — Load is_buy pointer
 # StageA+.c:183:         *is_buy = (*p == 'F' || *p == 'f') ? 1 : 0;
	sete	%dl	 #, _89 — Set %dl = 1 if 'F'/'f'
 # StageA+.c:182:         *ts = parsed_ts;
	movq	%r13, (%r15)	 # value, *ts_40(D) — Store *ts
 # StageA+.c:183:         *is_buy = (*p == 'F' || *p == 'f') ? 1 : 0;
	movl	%edx, (%rax)	 # _89, *is_buy_43(D) — Store *is_buy
	jmp	.L70	 # — Return 1 (success)
	.p2align 4,,10 # Alignment hint
	.p2align 3 # 8-byte alignment
.L99: # EOF / read failure return 0
 # StageA+.c:186:     return 0;
	xorl	%ebp, %ebp	 # <retval> — Return 0
.L70: # Epilogue and return
 # StageA+.c:187: }
	movl	%ebp, %eax	 # <retval>, — Return code in %eax
	addq	$344, %rsp	 #, — Pop stack frame
	popq	%rbx	 # — Restore callee-saved registers
	popq	%rsi	 #
	popq	%rdi	 #
	popq	%rbp	 #
	popq	%r12	 #
	popq	%r13	 #
	popq	%r14	 #
	popq	%r15	 #
	ret	 # Return to caller
	.seh_endproc # End SEH metadata for read_trade_fixed
	.section .rdata,"dr" # Read-only data section
	.align 8 # 8-byte alignment
.LC1: # Double literal 1.0
	.long	0 # Low 32 bits of 1.0
	.long	1072693248 # High 32 bits of 1.0 (0x3ff00000)
	.align 8 # 8-byte alignment
.LC2: # Double literal 10.0
	.long	0 # Low 32 bits of 10.0
	.long	1076101120 # High 32 bits of 10.0 (0x40240000)
	.ident	"GCC: (Rev8, Built by MSYS2 project) 15.2.0" # Compiler version string
	.def	fgets;	.scl	2;	.type	32;	.endef # External symbol declaration: fgets
	.def	strchr;	.scl	2;	.type	32;	.endef # External symbol declaration: strchr
```[cite: 2]

---

### 3. `StageC_O2.s` (Annotated)

```assembly
	.file	"StageC.c" # Primary source file name
 # GNU C23 (Rev8, Built by MSYS2 project) version 15.2.0 (x86_64-w64-mingw32) # Compiler and Windows x64 target
 #	compiled by GNU C version 15.2.0, GMP version 6.3.0, MPFR version 4.2.2, MPC version 1.3.1, isl version isl-0.27-GMP # Build info

 # GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072 # GC parameters
 # options passed: -mtune=generic -march=nocona -O2 # Optimization flags
	.text # Code section
	.p2align 4 # 16-byte alignment
	.def	now_ns;	.scl	3;	.type	32;	.endef # Static function now_ns() from timing.h
	.seh_proc	now_ns # Begin SEH metadata
now_ns: # Returns nanosecond timestamp in %rax using QueryPerformanceCounter
	subq	$56, %rsp	 #, — Allocate 56-byte stack frame (LARGE_INTEGER + shadow space)
	.seh_stackalloc	56 # Record stack allocation
	.seh_endprologue # End prologue
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	movl	ready.1(%rip), %eax	 # ready, — Load one-time init flag `ready`
	testl	%eax, %eax	 # — Test if frequency already queried
	je	.L4	 #, — Query frequency once if not ready
.L2: # Read counter and convert ticks to nanoseconds
 # timing.h:26:       QueryPerformanceCounter(&count);
	leaq	40(%rsp), %rcx	 #, tmp113 — Address of local `count` (LARGE_INTEGER)
	call	*__imp_QueryPerformanceCounter(%rip)	 # — Call Win32 QueryPerformanceCounter via IAT
 # timing.h:28:       uint64_t f = (uint64_t)freq.QuadPart, c = (uint64_t)count.QuadPart;
	movq	freq.0(%rip), %r8	 # freq.QuadPart, f — Load tick frequency f
	movq	40(%rsp), %rax	 # count.QuadPart, count.QuadPart — Load counter value c
	xorl	%edx, %edx	 # tmp116 — Clear high dividend bits for 128/64 divq
	divq	%r8	 # f — %rax = c / f, %rdx = c % f
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	imulq	$1000000000, %rax, %rcx	 #, count.QuadPart, _5 — %rcx = (c / f) * 1e9
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	imulq	$1000000000, %rdx, %rax	 #, tmp116, _7 — %rax = (c % f) * 1e9
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	xorl	%edx, %edx	 # tmp122 — Clear %rdx before dividing remainder term
	divq	%r8	 # f — %rax = ((c % f) * 1e9) / f
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	addq	%rcx, %rax	 # _5, _16 — Total nanoseconds in %rax
 # timing.h:30:   }
	addq	$56, %rsp	 #, — Deallocate stack frame
	ret	 # Return uint64_t ns in %rax
	.p2align 4,,10 # Alignment hint
	.p2align 3 # 8-byte alignment
.L4: # Lazy initialization of QPC frequency
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	leaq	freq.0(%rip), %rcx	 #, — Address of static `freq`
	call	*__imp_QueryPerformanceFrequency(%rip)	 # — Call Win32 QueryPerformanceFrequency via IAT
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	movl	$1, ready.1(%rip)	 #, ready — Mark frequency initialized
	jmp	.L2	 # — Proceed to read counter
	.seh_endproc # End SEH metadata for now_ns
	.section .rdata,"dr" # Read-only string/constant section
.LC2: # Default stress dataset path
	.ascii "../DATABASE/stress_full.csv\0"
.LC3: # Dev dataset path
	.ascii "../DATABASE/dev_1M.csv\0"
.LC4: # Test dataset path
	.ascii "../DATABASE/test20.csv\0"
.LC5: # Mode label: "naive"
	.ascii "naive\0"
.LC6: # Mode label: "running-sum"
	.ascii "running-sum\0"
.LC7: # Open position suffix
	.ascii " (still holding 1 BTC)\0"
.LC8: # Empty string
	.ascii "\0"
.LC9: # CLI arg: "test"
	.ascii "test\0"
.LC10: # CLI arg: "dev"
	.ascii "dev\0"
.LC11: # CLI arg: "stress"
	.ascii "stress\0"
	.align 8 # 8-byte alignment
.LC12: # Unknown dataset error format
	.ascii "Unknown file '%s' (use test, dev or stress)\12\0"
.LC13: # Speed validation message
	.ascii "Speed must be >= 0\0"
.LC14: # CLI flag: "-r"
	.ascii "-r\0"
.LC15: # Rival reaction time validation message
	.ascii "Rival time must be > 0\0"
	.align 8 # 8-byte alignment
.LC18: # Usage help string
	.ascii "Usage: %s [-f test|dev|stress] [-s SPEED] [-m MINUTES] [-n] [-c] [-l] [-q] [-o FILE] [-r US]\12\0"
.LC19: # fopen read-binary mode
	.ascii "rb\0"
.LC20: # File open error format
	.ascii "Could not open %s\12\0"
.LC22: # malloc failure format
	.ascii "malloc of %lld trades failed\12\0"
.LC23: # fopen read mode
	.ascii "r\0"
	.align 8 # 8-byte alignment
.LC24: # Insufficient trade count message
	.ascii "Not enough trades (%lld) for the long window (%d)\12\0"
	.align 8 # 8-byte alignment
.LC28: # Replay header format
	.ascii "Stage C replay: %s, windows %d/%d, %s SMA, speed %s\12\0"
.LC29: # Speed mode label: "paced"
	.ascii "paced\0"
	.align 8 # 8-byte alignment
.LC31: # Load summary format
	.ascii "Trades loaded: %lld (malloc %.1f MB)   load time %.3f s\12\0"
	.align 8 # 8-byte alignment
.LC32: # Replay span format
	.ascii "Replaying %lld trades covering %.1f s of market time\0"
.LC33: # Replay speed suffix format
	.ascii " at %gx (about %.1f s)\0"
.LC34: # Newline string for puts
	.ascii "\12\0"
	.align 8 # 8-byte alignment
.LC35: # Simulated LED notice
	.ascii "[led.h] No built-in LED on this computer. Printing instead.\0"
	.align 8 # 8-byte alignment
.LC36: # Signal log allocation failure message
	.ascii "Out of memory for the signal log\0"
.LC38: # LED state: "OFF"
	.ascii "OFF\0"
.LC39: # LED name: "RED"
	.ascii "RED\0"
.LC40: # Simulated LED output format
	.ascii "[LED %s %s]\12\0"
.LC41: # LED state: "ON"
	.ascii "ON\0"
.LC42: # LED name: "GREEN"
	.ascii "GREEN\0"
	.align 8 # 8-byte alignment
.LC43: # Live progress status line format
	.ascii "\15  replayed %5.1f%%  | lag %9.3f ms | BUY %lld SELL %lld | P&L %.2f   \0"
.LC44: # Progress clear format
	.ascii "\15%79s\15\0"
.LC45: # Results section header
	.ascii "\12--- Replay results ---\0"
.LC46: # Trades replayed line
	.ascii "Trades replayed      : %lld\12\0"
	.align 8 # 8-byte alignment
.LC47: # Signals count line
	.ascii "Signals              : %lld BUY, %lld SELL\12\0"
.LC48: # Final VWAP line
	.ascii "Final VWAP           : %.8f\12\0"
.LC49: # Wall time line
	.ascii "Wall time            : %.3f s\0"
.LC50: # Ideal time suffix
	.ascii "   (ideal %.3f s)\0"
	.align 8 # 8-byte alignment
.LC51: # Per-trade processing stats line
	.ascii "Processing per trade : avg %.1f ns, worst %.3f us\12\0"
	.align 8 # 8-byte alignment
.LC52: # Per-trade latency stats line
	.ascii "Latency per trade    : avg %.3f us, worst %.3f us\12\0"
	.align 8 # 8-byte alignment
.LC53: # Lag stats line
	.ascii "Lag behind replay    : worst %.3f ms, at end %.3f ms\12\0"
	.align 8 # 8-byte alignment
.LC54: # Rival bot summary line
	.ascii "Rival bot (R = %.2f us): P&L %.2f USDT, races won %lld, lost %lld%s\12\0"
.LC55: # Memory section header
	.ascii "\12--- Memory ---\0"
	.align 8 # 8-byte alignment
.LC56: # Dynamic array memory line
	.ascii "malloc array (exact fit) : %.1f MB for %lld trades\12\0"
	.align 8 # 8-byte alignment
.LC57: # Stage B fixed array comparison line
	.ascii "Stage B fixed array      : %.1f MB reserved (MAX_TRADES = %d)\12\0"
.LC58: # Log fopen write mode
	.ascii "w\0"
	.align 8 # 8-byte alignment
.LC59: # CSV log header
	.ascii "trade_index,ts_us,price_fx,side,proc_ns,latency_ns\12\0"
	.align 8 # 8-byte alignment
.LC60: # Log write completion line
	.ascii "\12Wrote %lld signals to %s\12\0"
	.align 8 # 8-byte alignment
.LC61: # CSV log row format
	.ascii "%lld,%lld,%lld,%d,%llu,%llu\12\0"
.LC62: # Speed mode label: "unpaced"
	.ascii "unpaced\0"
.LC63: # Signal label: "BUY"
	.ascii "BUY\0"
.LC64: # ANSI green escape code
	.ascii "\33[32m\0"
	.align 8 # 8-byte alignment
.LC65: # Coloured signal line format
	.ascii "%s%-4s trade %-8lld price %.2f  latency %.2f us%s\12\0"
.LC66: # ANSI reset escape code
	.ascii "\33[0m\0"
.LC67: # Signal label: "SELL"
	.ascii "SELL\0"
.LC68: # ANSI red escape code
	.ascii "\33[31m\0"
	.section	.text.startup,"x" # Executable startup section for main
	.p2align 4 # 16-byte alignment
	.globl	main # Export main globally
	.def	main;	.scl	2;	.type	32;	.endef # COFF function attributes
	.seh_proc	main # Begin SEH metadata for main
main: # Entry point of main(int argc, char **argv)
	pushq	%r15	 # — Save non-volatile registers
	.seh_pushreg	%r15 # SEH push record
	pushq	%r14	 # — Save %r14
	.seh_pushreg	%r14 # SEH push record
	pushq	%r13	 # — Save %r13
	.seh_pushreg	%r13 # SEH push record
	pushq	%r12	 # — Save %r12
	.seh_pushreg	%r12 # SEH push record
	pushq	%rbp	 # — Save %rbp
	.seh_pushreg	%rbp # SEH push record
	pushq	%rdi	 # — Save %rdi
	.seh_pushreg	%rdi # SEH push record
	pushq	%rsi	 # — Save %rsi
	.seh_pushreg	%rsi # SEH push record
	pushq	%rbx	 # — Save %rbx
	.seh_pushreg	%rbx # SEH push record
	subq	$312, %rsp	 #, — Allocate 312-byte stack frame for main
	.seh_stackalloc	312 # Record stack allocation
	movups	%xmm6, 208(%rsp)	 #, — Save non-volatile XMM6..XMM11 per Windows x64 ABI
	.seh_savexmm	%xmm6, 208 # SEH save record
	movups	%xmm7, 224(%rsp)	 #, — Save XMM7
	.seh_savexmm	%xmm7, 224 # SEH save record
	movups	%xmm8, 240(%rsp)	 #, — Save XMM8
	.seh_savexmm	%xmm8, 240 # SEH save record
	movups	%xmm9, 256(%rsp)	 #, — Save XMM9
	.seh_savexmm	%xmm9, 256 # SEH save record
	movups	%xmm10, 272(%rsp)	 #, — Save XMM10
	.seh_savexmm	%xmm10, 272 # SEH save record
	movups	%xmm11, 288(%rsp)	 #, — Save XMM11
	.seh_savexmm	%xmm11, 288 # SEH save record
	.seh_endprologue # End prologue
 # StageC.c:288: {
	movl	%ecx, %ebp	 # argc, argc — Save argc in %ebp
	movq	%rdx, %r12	 # argv, argv — Save argv in %r12
	call	__main	 # — MinGW C runtime initializer
 # StageC.c:296:     for (int a = 1; a < argc; a++) {
	cmpl	$1, %ebp	 #, argc — Check if any command-line arguments were passed
	jle	.L144	 #, — Jump to defaults if argc <= 1
 # StageC.c:290:     double speed = 1000.0;
	movsd	.LC1(%rip), %xmm8	 #, tmp1081 — Load default speed = 1000.0
 # StageC.c:292:     int use_colour = 0, use_led = 0, quiet = 0;
	movl	$0, 116(%rsp)	 #, %sfp — quiet = 0
 # StageC.c:289:     const char *path = STRESS_PATH;
	leaq	.LC2(%rip), %rbx	 #, path — Default path = stress_full.csv
 # StageC.c:296:     for (int a = 1; a < argc; a++) {
	movl	$1, %esi	 #, a — Loop index a = 1
 # StageC.c:292:     int use_colour = 0, use_led = 0, quiet = 0;
	movl	$0, 112(%rsp)	 #, %sfp — use_led = 0
 # StageC.c:293:     int is_test = 0;
	xorl	%r15d, %r15d	 # is_test — is_test = 0
 # StageC.c:291:     double max_minutes = 0.0;       /* 0 = whole file */
	pxor	%xmm7, %xmm7	 # max_minutes — max_minutes = 0.0
 # StageC.c:304:                 path = STRESS_PATH;
	movq	%rbx, %rdi	 # path, path — Keep default path in %rdi
 # StageC.c:292:     int use_colour = 0, use_led = 0, quiet = 0;
	movl	$0, 88(%rsp)	 #, %sfp — use_colour = 0
 # StageC.c:290:     double speed = 1000.0;
	movapd	%xmm8, %xmm6	 # tmp1081, speed — speed = 1000.0
 # StageC.c:304:                 path = STRESS_PATH;
	movq	%r12, 392(%rsp)	 # argv, argv — Spill argv
	movl	%ebp, %r12d	 # argc, argc — Move argc to %r12d
	movq	392(%rsp), %rbp	 # argv, argv — Restore argv to %rbp
	.p2align 4 # Loop alignment
	.p2align 3 # 8-byte alignment
.L30: # CLI argument parsing loop
 # StageC.c:297:         if (strcmp(argv[a], "-f") == 0 && a + 1 < argc) {
	movslq	%esi, %r13	 # a, _1 — Sign-extend index a
 # StageC.c:297:         if (strcmp(argv[a], "-f") == 0 && a + 1 < argc) {
	movq	0(%rbp,%r13,8), %rcx	 # *_3, _4 — Load argv[a]
	movzbl	(%rcx), %eax	 # MEM <char[1:3]> [(void *)_4], MEM <char[1:3]> [(void *)_4] — First byte of argv[a]
	cmpl	$45, %eax	 #, MEM <char[1:3]> [(void *)_4] — Compare first char with '-' (45)
	je	.L227	 #, — Jump if starts with '-'
.L24: # Check "-r" flag
 # StageC.c:324:         } else if (strcmp(argv[a], "-r") == 0 && a + 1 < argc) {
	leaq	.LC14(%rip), %rdx	 #, — "-r"
	call	strcmp	 # — Compare argv[a] with "-r"
 # StageC.c:324:         } else if (strcmp(argv[a], "-r") == 0 && a + 1 < argc) {
	testl	%eax, %eax	 # _36 — Equal if 0
	jne	.L25	 #, — Print usage & exit if unrecognized
 # StageC.c:324:         } else if (strcmp(argv[a], "-r") == 0 && a + 1 < argc) {
	addl	$1, %esi	 #, a — Advance argument index a
 # StageC.c:324:         } else if (strcmp(argv[a], "-r") == 0 && a + 1 < argc) {
	cmpl	%r12d, %esi	 # argc, a — Ensure value argument exists
	jge	.L25	 #, — Missing argument -> usage error
 # StageC.c:325:             double r_us = atof(argv[++a]);
	movq	8(%rbp,%r13,8), %rcx	 # *_40, *_40 — Load argv[a]
	call	atof	 # — Parse rival time in microseconds
 # StageC.c:326:             if (r_us <= 0.0) { printf("Rival time must be > 0\n"); return 1; }
	pxor	%xmm1, %xmm1	 # tmp555 — 0.0
	comisd	%xmm0, %xmm1	 # r_us, tmp555 — Compare 0.0 vs r_us
	jnb	.L228	 #, — Error if r_us <= 0.0
 # StageC.c:327:             rival_ns = (uint64_t)(r_us * 1000.0 + 0.5);
	mulsd	%xmm8, %xmm0	 # tmp1081, _42 — r_us * 1000.0
 # StageC.c:327:             rival_ns = (uint64_t)(r_us * 1000.0 + 0.5);
	movsd	.LC17(%rip), %xmm1	 #, tmp561 — 2^63 threshold for unsigned conversion
 # StageC.c:327:             rival_ns = (uint64_t)(r_us * 1000.0 + 0.5);
	addsd	.LC16(%rip), %xmm0	 #, _43 — Add 0.5 for rounding
 # StageC.c:327:             rival_ns = (uint64_t)(r_us * 1000.0 + 0.5);
	comisd	%xmm1, %xmm0	 # tmp561, _43 — Check if >= 2^63
	jb	.L229	 #, — Direct conversion if < 2^63
	subsd	%xmm1, %xmm0	 # tmp561, tmp563 — Subtract 2^63
	cvttsd2siq	%xmm0, %rax	 # tmp563, tmp565 — Convert to signed 64-bit
	movq	%rax, rival_ns(%rip)	 # tmp565, rival_ns — Store high-bit value
	btcq	$63, rival_ns(%rip)	 #, rival_ns — Complement bit 63 to form uint64_t
 # StageC.c:324:         } else if (strcmp(argv[a], "-r") == 0 && a + 1 < argc) {
	jmp	.L10	 # — Next argument
	.p2align 4,,10 # Alignment hint
	.p2align 3 # 8-byte alignment
.L227: # Argument starts with '-'
 # StageC.c:297:         if (strcmp(argv[a], "-f") == 0 && a + 1 < argc) {
	movzbl	1(%rcx), %edx	 # MEM <char[1:3]> [(void *)_4], MEM <char[1:3]> [(void *)_4] — Second char of argv[a]
	cmpl	$102, %edx	 #, MEM <char[1:3]> [(void *)_4] — Compare with 'f' (102)
	je	.L230	 #, — Check exact "-f"
.L8: # Check "-s"
 # StageC.c:309:         } else if (strcmp(argv[a], "-s") == 0 && a + 1 < argc) {
	cmpl	$45, %eax	 #, MEM <char[1:3]> [(void *)_4] — Check '-'
	jne	.L24	 #, — Not a short flag
	cmpb	$115, 1(%rcx)	 #, MEM <char[1:3]> [(void *)_4] — Compare second char with 's' (115)
	jne	.L13	 #, — Try next flag
 # StageC.c:309:         } else if (strcmp(argv[a], "-s") == 0 && a + 1 < argc) {
	cmpb	$0, 2(%rcx)	 #, MEM <char[1:3]> [(void *)_4] — Ensure NUL terminator at index 2
	jne	.L13	 #, — Not "-s" if extra chars exist
 # StageC.c:309:         } else if (strcmp(argv[a], "-s") == 0 && a + 1 < argc) {
	leal	1(%rsi), %r14d	 #, _15 — Candidate next index
 # StageC.c:309:         } else if (strcmp(argv[a], "-s") == 0 && a + 1 < argc) {
	cmpl	%r12d, %r14d	 # argc, _15 — Verify next arg exists
	jge	.L14	 #, — Skip if missing arg
 # StageC.c:310:             speed = atof(argv[++a]);
	movq	8(%rbp,%r13,8), %rcx	 # *_18, *_18 — Load speed string
	call	atof	 # — Convert speed to double
	movapd	%xmm0, %xmm6	 # speed, speed — Save speed in %xmm6
 # StageC.c:311:             if (speed < 0.0) { printf("Speed must be >= 0\n"); return 1; }
	pxor	%xmm0, %xmm0	 # tmp530 — 0.0
	comisd	%xmm6, %xmm0	 # speed, tmp530 — Compare 0.0 vs speed
	ja	.L231	 #, — Error if speed < 0.0
 # StageC.c:310:             speed = atof(argv[++a]);
	movl	%r14d, %esi	 # _15, a — Commit a++
 # StageC.c:296:     for (int a = 1; a < argc; a++) {
	addl	$1, %esi	 #, a — Next iteration index
 # StageC.c:296:     for (int a = 1; a < argc; a++) {
	cmpl	%esi, %r12d	 # a, argc — Continue loop while a < argc
	jg	.L30	 #, — Next argument
 # StageC.c:333:     if (is_test) {
	testl	%r15d, %r15d	 # is_test — Check if test mode selected
	je	.L6	 #, — Skip test window override if 0
.L236: # Set test short/long SMA windows
 # StageC.c:334:         short_win = TEST_SHORT;
	movl	$3, short_win(%rip)	 #, short_win — short_win = 3
 # StageC.c:335:         long_win = TEST_LONG;
	movl	$5, long_win(%rip)	 #, long_win — long_win = 5
.L6: # Configure Windows console virtual terminal sequences
 # StageC.c:244:     HANDLE h = GetStdHandle(STD_OUTPUT_HANDLE);
	movl	$-11, %ecx	 #, — STD_OUTPUT_HANDLE = -11
	call	*__imp_GetStdHandle(%rip)	 # — Get stdout handle
 # StageC.c:245:     DWORD mode = 0;
	movl	$0, 200(%rsp)	 #, MEM[(long unsigned int *)_743] — mode = 0
 # StageC.c:244:     HANDLE h = GetStdHandle(STD_OUTPUT_HANDLE);
	movq	%rax, %rdi	 #, h — Save handle in %rdi
 # StageC.c:246:     if (h != INVALID_HANDLE_VALUE && GetConsoleMode(h, &mode)) {
	cmpq	$-1, %rax	 #, h — INVALID_HANDLE_VALUE == -1
	je	.L34	 #, — Skip if invalid handle
 # StageC.c:246:     if (h != INVALID_HANDLE_VALUE && GetConsoleMode(h, &mode)) {
	leaq	200(%rsp), %rdx	 #, — &mode
	movq	%rax, %rcx	 # h, — handle
	call	*__imp_GetConsoleMode(%rip)	 # — Query current console mode
 # StageC.c:246:     if (h != INVALID_HANDLE_VALUE && GetConsoleMode(h, &mode)) {
	testl	%eax, %eax	 # _359 — Check success
	jne	.L232	 #, — Enable ANSI VT processing if console
.L34: # Start loading trades and measuring load time
 # StageC.c:340:     uint64_t load_start = now_ns();
	call	now_ns	 # — Record start timestamp in ns
 # StageC.c:112:     FILE *fp = fopen(path, "rb");
	leaq	.LC19(%rip), %rdx	 #, — "rb"
	movq	%rbx, %rcx	 # path, — File path
 # StageC.c:340:     uint64_t load_start = now_ns();
	movq	%rax, 72(%rsp)	 #, %sfp — Save load_start
 # StageC.c:112:     FILE *fp = fopen(path, "rb");
	call	fopen	 # — Open CSV file in binary mode
	movq	%rax, %rbp	 #, fp — Save FILE * in %rbp
 # StageC.c:113:     if (fp == NULL) return -1;
	testq	%rax, %rax	 # fp — Check if open failed
	je	.L233	 #, — Handle missing file
 # StageC.c:120:             if (buf[k] == '\n') lines++;
	movl	$168430090, %eax	 #, tmp1156 — 0x0A0A0A0A (four '\n' bytes)
	movapd	%xmm8, %xmm11	 # tmp1081, tmp1081 — Save 1000.0
 # StageC.c:117:     size_t n, last = '\n';
	movl	$10, %esi	 #, last — last = '\n' (10)
 # StageC.c:116:     long long lines = 0;
	xorl	%r14d, %r14d	 # lines — lines = 0
 # StageC.c:120:             if (buf[k] == '\n') lines++;
	movd	%eax, %xmm9	 # tmp1156, tmp1156 — Broadcast 32-bit pattern into %xmm9
	movapd	%xmm7, %xmm10	 # max_minutes, max_minutes — Preserve max_minutes
	movapd	%xmm6, %xmm8	 # speed, speed — Preserve speed
	leaq	buf.2(%rip), %rdi	 #, tmp1091 — Address of 1 MiB read buffer buf.2
	pshufd	$0, %xmm9, %xmm9	 # tmp1156, tmp1157 — Splat '\n' across all 16 bytes of %xmm9
	.p2align 4 # Loop alignment
	.p2align 3 # 8-byte alignment
.L36: # Chunked file read loop for line counting
 # StageC.c:118:     while ((n = fread(buf, 1, sizeof buf, fp)) > 0) {
	movq	%rdi, %rcx	 # tmp1091, — dst = buf.2
	movq	%rbp, %r9	 # fp, — stream = fp
	movl	$1048576, %r8d	 #, — count = 1 MiB
	movl	$1, %edx	 #, — elem size = 1
	call	fread	 # — Read up to 1 MiB chunk
	movq	%rax, %rcx	 #, n — Bytes read n
 # StageC.c:118:     while ((n = fread(buf, 1, sizeof buf, fp)) > 0) {
	testq	%rax, %rax	 # n — Check if n == 0 (EOF)
	je	.L234	 #, — Finish counting on EOF
	leaq	-1(%rcx), %rax	 #, _301 — n - 1
	cmpq	$14, %rax	 #, _301 — Check if at least 16 bytes available
	jbe	.L153	 #, — Scalar tail loop if < 16 bytes
	movq	%rcx, %rax	 # n, k — Byte count
	leaq	buf.2(%rip), %rdx	 #, ivtmp.225 — Buffer cursor
	pxor	%xmm0, %xmm0	 # vect_lines_652.180 — Vector newline counter
	andq	$-16, %rax	 #, k — Largest multiple of 16 <= n
	leaq	(%rdi,%rax), %r8	 #, _481 — End of vectorized region
	.p2align 4 # Loop alignment
	.p2align 3 # 8-byte alignment
.L39: # Vectorized 16-byte '\n' scan loop
 # StageC.c:120:             if (buf[k] == '\n') lines++;
	movdqa	%xmm9, %xmm1	 # tmp1157, tmp584 — Load 16x '\n'
	pxor	%xmm4, %xmm4	 # tmp587 — Zero register
	addq	$16, %rdx	 #, ivtmp.225 — Advance pointer by 16 bytes
	pcmpeqb	-16(%rdx), %xmm1	 # MEM <vector(16) char> [(char *)_752], tmp584 — 0xFF where byte == '\n', else 0x00
	pcmpgtb	%xmm1, %xmm4	 # tmp584, tmp587 — Signed byte >: 0 > -1 gives 0x01 for matches
	movdqa	%xmm1, %xmm2	 # tmp584, tmp588 — Copy comparison mask
	punpcklbw	%xmm4, %xmm2	 # tmp587, tmp588 — Unpack low 8 bytes with counts
	punpckhbw	%xmm4, %xmm1	 # tmp587, tmp592 — Unpack high 8 bytes with counts
	movdqa	%xmm2, %xmm4	 # tmp588, tmp595 — Copy low word lane
	movdqa	%xmm2, %xmm5	 # tmp588, tmp596 — Copy low word lane
	movdqa	%xmm1, %xmm6	 # tmp592, tmp603 — Copy high word lane
	psraw	$15, %xmm4	 #, tmp595 — Sign-extend words
	psraw	$15, %xmm6	 #, tmp603 — Sign-extend high words
	punpcklwd	%xmm4, %xmm5	 # tmp595, tmp596 — Widen to 32-bit lanes
	punpckhwd	%xmm4, %xmm2	 # tmp595, tmp600 — Widen high low-half to 32-bit
	movdqa	%xmm1, %xmm4	 # tmp592, tmp604 — Copy high lane
	punpcklwd	%xmm6, %xmm4	 # tmp603, tmp604 — Widen to 32-bit
	punpckhwd	%xmm6, %xmm1	 # tmp603, tmp608 — Widen to 32-bit
	movdqa	%xmm5, %xmm6	 # tmp596, tmp612 — Copy 32-bit lane
	psrad	$31, %xmm6	 #, tmp612 — Sign bit mask for 64-bit widen
	movdqa	%xmm5, %xmm7	 # tmp596, tmp613 — Copy 32-bit lane
	punpckldq	%xmm6, %xmm7	 # tmp612, tmp613 — Low 64-bit lane
	punpckhdq	%xmm6, %xmm5	 # tmp612, tmp618 — High 64-bit lane
	movdqa	%xmm2, %xmm6	 # tmp600, tmp623 — Next 32-bit lane
	psubq	%xmm7, %xmm0	 # tmp613, vect__622.181 — Accumulate into 64-bit lane
	psubq	%xmm5, %xmm0	 # tmp618, vect__622.181 — Accumulate into 64-bit lane
	movdqa	%xmm2, %xmm5	 # tmp600, tmp622 — Sign mask
	psrad	$31, %xmm5	 #, tmp622 — Sign-extend 32 -> 64
	punpckldq	%xmm5, %xmm6	 # tmp622, tmp623 — Low 64-bit lane
	punpckhdq	%xmm5, %xmm2	 # tmp622, tmp628 — High 64-bit lane
	movdqa	%xmm4, %xmm5	 # tmp604, tmp632 — Next 32-bit lane
	psubq	%xmm6, %xmm0	 # tmp623, vect__622.181 — Accumulate
	psrad	$31, %xmm5	 #, tmp632 — Sign-extend
	psubq	%xmm2, %xmm0	 # tmp628, vect__622.181 — Accumulate
	movdqa	%xmm4, %xmm2	 # tmp604, tmp633 — Copy
	punpckldq	%xmm5, %xmm2	 # tmp632, tmp633 — Low 64-bit lane
	psubq	%xmm2, %xmm0	 # tmp633, vect__622.181 — Accumulate
	movdqa	%xmm4, %xmm2	 # tmp604, tmp638 — Copy
	movdqa	%xmm1, %xmm4	 # tmp608, tmp643 — Copy
	punpckhdq	%xmm5, %xmm2	 # tmp632, tmp638 — High 64-bit lane
	psubq	%xmm2, %xmm0	 # tmp638, vect__622.181 — Accumulate
	movdqa	%xmm1, %xmm2	 # tmp608, tmp642 — Copy
	psrad	$31, %xmm2	 #, tmp642 — Sign-extend
	punpckldq	%xmm2, %xmm4	 # tmp642, tmp643 — Low 64-bit lane
	punpckhdq	%xmm2, %xmm1	 # tmp642, tmp648 — High 64-bit lane
	psubq	%xmm4, %xmm0	 # tmp643, vect__622.181 — Accumulate
	psubq	%xmm1, %xmm0	 # tmp648, vect_lines_652.180 — Accumulate final lane
	cmpq	%r8, %rdx	 # _481, ivtmp.225 — Reached end of 16-byte aligned blocks?
	jne	.L39	 #, — Loop over next 16 bytes
	movdqa	%xmm0, %xmm1	 # vect_lines_652.180, tmp652 — Copy two 64-bit sums
	psrldq	$8, %xmm1	 #, tmp652 — Shift high 64-bit lane down to low lane
	paddq	%xmm1, %xmm0	 # tmp652, tmp650 — Horizontal sum of two 64-bit lanes
	movq	%xmm0, %rdx	 # tmp650, tmp649 — Extract 64-bit line count to %rdx
	addq	%rdx, %r14	 # tmp649, lines — Add to total lines
	cmpq	%rax, %rcx	 # k, n — Any remaining trailing bytes?
	je	.L40	 #, — None left -> record last byte
	.p2align 5 # 32-byte alignment
	.p2align 4 # 16-byte alignment
	.p2align 3 # 8-byte alignment
.L42: # Scalar remainder loop for '\n'
	cmpb	$10, (%rdi,%rax)	 #, MEM[(char *)&buf + k_499 * 1] — Check buf[k] == '\n'
	jne	.L43	 #, — Skip if not '\n'
 # StageC.c:120:             if (buf[k] == '\n') lines++;
	addq	$1, %r14	 #, lines — lines++
.L43: # Advance remainder byte index
 # StageC.c:119:         for (size_t k = 0; k < n; k++) {
	addq	$1, %rax	 #, k — k++
 # StageC.c:119:         for (size_t k = 0; k < n; k++) {
	cmpq	%rcx, %rax	 # n, k — Loop while k < n
	jb	.L42	 #, — Continue remainder scan
.L40: # Save last byte of chunk
 # StageC.c:122:         last = (unsigned char)buf[n - 1];
	movzbl	-1(%rdi,%rcx), %esi	 # buf[_301], last — last = buf[n - 1]
	jmp	.L36	 # — Read next chunk
	.p2align 4,,10 # Alignment hint
	.p2align 3 # 8-byte alignment
.L230: # Verify flag is literally "-f"
 # StageC.c:297:         if (strcmp(argv[a], "-f") == 0 && a + 1 < argc) {
	cmpb	$0, 2(%rcx)	 #, MEM <char[1:3]> [(void *)_4] — Ensure argv[a][2] == '\0'
	jne	.L8	 #, — Not "-f" if longer
 # StageC.c:297:         if (strcmp(argv[a], "-f") == 0 && a + 1 < argc) {
	leal	1(%rsi), %r14d	 #, _6 — Next argument index
 # StageC.c:297:         if (strcmp(argv[a], "-f") == 0 && a + 1 < argc) {
	cmpl	%r12d, %r14d	 # argc, _6 — Verify argument exists
	jge	.L9	 #, — Missing dataset argument
 # StageC.c:299:             if (strcmp(argv[a], "test") == 0) {
	movq	8(%rbp,%r13,8), %rbx	 # *_9, _10 — Load dataset name string
	leaq	.LC9(%rip), %rdx	 #, — "test"
	movq	%rbx, %rcx	 # _10, — arg
	call	strcmp	 # — Compare with "test"
 # StageC.c:299:             if (strcmp(argv[a], "test") == 0) {
	testl	%eax, %eax	 # _11 — 0 if "test"
	je	.L145	 #, — Select test dataset
 # StageC.c:301:             } else if (strcmp(argv[a], "dev") == 0) {
	leaq	.LC10(%rip), %rdx	 #, — "dev"
	movq	%rbx, %rcx	 # _10, — arg
	call	strcmp	 # — Compare with "dev"
 # StageC.c:301:             } else if (strcmp(argv[a], "dev") == 0) {
	testl	%eax, %eax	 # _12 — 0 if "dev"
	je	.L146	 #, — Select dev dataset
 # StageC.c:303:             } else if (strcmp(argv[a], "stress") == 0) {
	leaq	.LC11(%rip), %rdx	 #, — "stress"
	movq	%rbx, %rcx	 # _10, — arg
	call	strcmp	 # — Compare with "stress"
 # StageC.c:303:             } else if (strcmp(argv[a], "stress") == 0) {
	testl	%eax, %eax	 # _13 — 0 if "stress"
	jne	.L235	 #, — Unknown dataset name -> error
 # StageC.c:298:             a++;
	movl	%r14d, %esi	 # _6, a — Commit a++
 # StageC.c:304:                 path = STRESS_PATH;
	movq	%rdi, %rbx	 # path, path — Use stress path
	.p2align 4 # Loop alignment
	.p2align 3 # 8-byte alignment
.L10: # Advance argument loop counter
 # StageC.c:296:     for (int a = 1; a < argc; a++) {
	addl	$1, %esi	 #, a — a++
 # StageC.c:296:     for (int a = 1; a < argc; a++) {
	cmpl	%esi, %r12d	 # a, argc — Continue if a < argc
	jg	.L30	 #, — Next argument
 # StageC.c:333:     if (is_test) {
	testl	%r15d, %r15d	 # is_test — Check is_test
	jne	.L236	 #, — Apply test windows if set
	jmp	.L6	 #, — Otherwise continue to console setup
	.p2align 4,,10 # Alignment hint
	.p2align 3 # 8-byte alignment
.L9: # Missing arg after "-f"
 # StageC.c:309:         } else if (strcmp(argv[a], "-s") == 0 && a + 1 < argc) {
	cmpl	$115, %edx	 #, MEM <char[1:3]> [(void *)_4] — Check if second char was 's'
	jne	.L13	 #, — Try next flag
.L14: # Check "-n" flag
 # StageC.c:314:         } else if (strcmp(argv[a], "-n") == 0) {
	cmpl	$45, %eax	 #, MEM <char[1:3]> [(void *)_4] — Check '-'
	jne	.L24	 #, — Not a flag
	cmpb	$110, 1(%rcx)	 #, MEM <char[1:3]> [(void *)_4] — Compare with 'n' (110)
	jne	.L19	 #, — Try next flag
 # StageC.c:314:         } else if (strcmp(argv[a], "-n") == 0) {
	cmpb	$0, 2(%rcx)	 #, MEM <char[1:3]> [(void *)_4] — Ensure exact "-n"
	jne	.L19	 #, — Not "-n"
 # StageC.c:315:             naive_mode = 1;
	movl	$1, naive_mode(%rip)	 #, naive_mode — Enable naive SMA mode
	jmp	.L10	 # — Next argument
	.p2align 4,,10 # Alignment hint
	.p2align 3 # 8-byte alignment
.L13: # Check "-m" flag
 # StageC.c:312:         } else if (strcmp(argv[a], "-m") == 0 && a + 1 < argc) {
	cmpl	$45, %eax	 #, MEM <char[1:3]> [(void *)_4] — Check '-'
	jne	.L24	 #, — Not a flag
	cmpb	$109, 1(%rcx)	 #, MEM <char[1:3]> [(void *)_4] — Compare with 'm' (109)
	jne	.L14	 #, — Check "-n"
 # StageC.c:312:         } else if (strcmp(argv[a], "-m") == 0 && a + 1 < argc) {
	cmpb	$0, 2(%rcx)	 #, MEM <char[1:3]> [(void *)_4] — Ensure exact "-m"
	jne	.L14	 #, — Check "-n"
 # StageC.c:312:         } else if (strcmp(argv[a], "-m") == 0 && a + 1 < argc) {
	leal	1(%rsi), %r14d	 #, _21 — Candidate index for minutes arg
 # StageC.c:312:         } else if (strcmp(argv[a], "-m") == 0 && a + 1 < argc) {
	cmpl	%r12d, %r14d	 # argc, _21 — Check arg exists
	jge	.L14	 #, — Skip if missing
 # StageC.c:313:             max_minutes = atof(argv[++a]);
	movq	8(%rbp,%r13,8), %rcx	 # *_24, *_24 — Load minutes argument
 # StageC.c:313:             max_minutes = atof(argv[++a]);
	movl	%r14d, %esi	 # _21, a — Commit a++
 # StageC.c:313:             max_minutes = atof(argv[++a]);
	call	atof	 # — Parse max_minutes as double
	movapd	%xmm0, %xmm7	 # max_minutes, max_minutes — Store in %xmm7
 # StageC.c:313:             max_minutes = atof(argv[++a]);
	jmp	.L10	 # — Next argument
	.p2align 4,,10 # Alignment hint
	.p2align 3 # 8-byte alignment
.L19: # Check "-c" flag
 # StageC.c:316:         } else if (strcmp(argv[a], "-c") == 0) {
	cmpl	$45, %eax	 #, MEM <char[1:3]> [(void *)_4] — Check '-'
	jne	.L24	 #, — Not a flag
	cmpb	$99, 1(%rcx)	 #, MEM <char[1:3]> [(void *)_4] — Compare with 'c' (99)
	jne	.L172	 #, — Check "-l"
 # StageC.c:316:         } else if (strcmp(argv[a], "-c") == 0) {
	cmpb	$0, 2(%rcx)	 #, MEM <char[1:3]> [(void *)_4] — Ensure exact "-c"
	jne	.L172	 #, — Check "-l"
 # StageC.c:317:             use_colour = 1;
	movl	$1, 88(%rsp)	 #, %sfp — use_colour = 1
	jmp	.L10	 # — Next argument
	.p2align 4,,10 # Alignment hint
	.p2align 3 # 8-byte alignment
.L145: # Selected "test" dataset
 # StageC.c:298:             a++;
	movl	%r14d, %esi	 # _6, a — Commit a++
 # StageC.c:300:                 path = TEST_PATH; is_test = 1;
	movl	$1, %r15d	 #, is_test — is_test = 1
 # StageC.c:300:                 path = TEST_PATH; is_test = 1;
	leaq	.LC4(%rip), %rbx	 #, path — path = test20.csv
	jmp	.L10	 # — Next argument
	.p2align 4,,10 # Alignment hint
	.p2align 3 # 8-byte alignment
.L146: # Selected "dev" dataset
 # StageC.c:298:             a++;
	movl	%r14d, %esi	 # _6, a — Commit a++
 # StageC.c:302:                 path = DEV_PATH;
	leaq	.LC3(%rip), %rbx	 #, path — path = dev_1M.csv
	jmp	.L10	 # — Next argument
	.p2align 4,,10 # Alignment hint
	.p2align 3 # 8-byte alignment
.L172: # Check "-l" flag
 # StageC.c:318:         } else if (strcmp(argv[a], "-l") == 0) {
	cmpl	$45, %eax	 #, MEM <char[1:3]> [(void *)_4] — Check '-'
	jne	.L24	 #, — Not a flag
	cmpb	$108, 1(%rcx)	 #, MEM <char[1:3]> [(void *)_4] — Compare with 'l' (108)
	je	.L237	 #, — Check exact "-l"
.L173: # Check "-q" flag
 # StageC.c:320:         } else if (strcmp(argv[a], "-q") == 0) {
	cmpl	$45, %eax	 #, MEM <char[1:3]> [(void *)_4] — Check '-'
	jne	.L24	 #, — Not a flag
	cmpb	$113, 1(%rcx)	 #, MEM <char[1:3]> [(void *)_4] — Compare with 'q' (113)
	je	.L238	 #, — Check exact "-q"
.L174: # Check "-o" flag
 # StageC.c:322:         } else if (strcmp(argv[a], "-o") == 0 && a + 1 < argc) {
	cmpl	$45, %eax	 #, MEM <char[1:3]> [(void *)_4] — Check '-'
	jne	.L24	 #, — Not a flag
	cmpb	$111, 1(%rcx)	 #, MEM <char[1:3]> [(void *)_4] — Compare with 'o' (111)
	jne	.L24	 #, — Check "-r"
 # StageC.c:322:         } else if (strcmp(argv[a], "-o") == 0 && a + 1 < argc) {
	cmpb	$0, 2(%rcx)	 #, MEM <char[1:3]> [(void *)_4] — Ensure exact "-o"
	jne	.L24	 #, — Check "-r"
 # StageC.c:322:         } else if (strcmp(argv[a], "-o") == 0 && a + 1 < argc) {
	addl	$1, %esi	 #, a — Advance to log filename argument
 # StageC.c:322:         } else if (strcmp(argv[a], "-o") == 0 && a + 1 < argc) {
	cmpl	%r12d, %esi	 # argc, a — Verify filename argument exists
	jl	.L239	 #, — Set log_path if present
.L25: # Print usage string and return 1
 # StageC.c:329:             printf("Usage: %s [-f test|dev|stress] [-s SPEED] [-m MINUTES] [-n] [-c] [-l] [-q] [-o FILE] [-r US]\n", argv[0]);
	movq	0(%rbp), %rdx	 # *argv_322(D), — argv[0]
	leaq	.LC18(%rip), %rcx	 #, — Usage format string
	call	printf	 # — Print usage
.L11: # Error exit returning 1
 # StageC.c:307:                 return 1;
	movl	$1, %eax	 #, <retval> — Return code = 1
.L5: # Main epilogue (restore XMM and GPRs)
 # StageC.c:482: }
	movups	208(%rsp), %xmm6	 #, — Restore XMM6
	movups	224(%rsp), %xmm7	 #, — Restore XMM7
	movups	240(%rsp), %xmm8	 #, — Restore XMM8
	movups	256(%rsp), %xmm9	 #, — Restore XMM9
	movups	272(%rsp), %xmm10	 #, — Restore XMM10
	movups	288(%rsp), %xmm11	 #, — Restore XMM11
	addq	$312, %rsp	 #, — Deallocate stack frame
	popq	%rbx	 # — Restore GPRs
	popq	%rsi	 #
	popq	%rdi	 #
	popq	%rbp	 #
	popq	%r12	 #
	popq	%r13	 #
	popq	%r14	 #
	popq	%r15	 #
	ret	 # Return from main
	.p2align 4,,10 # Alignment hint
	.p2align 3 # 8-byte alignment
.L237: # Verify "-l"
 # StageC.c:318:         } else if (strcmp(argv[a], "-l") == 0) {
	cmpb	$0, 2(%rcx)	 #, MEM <char[1:3]> [(void *)_4] — Ensure exact "-l"
	jne	.L173	 #, — Try "-q"
 # StageC.c:319:             use_led = 1;
	movl	$1, 112(%rsp)	 #, %sfp — use_led = 1
	jmp	.L10	 # — Next argument
	.p2align 4,,10 # Alignment hint
	.p2align 3 # 8-byte alignment
.L234: # Finish counting lines and allocate trades array
 # StageC.c:124:     fclose(fp);
	movq	%rbp, %rcx	 # fp, — FILE *
	movapd	%xmm8, %xmm6	 # speed, speed — Restore speed
	movapd	%xmm10, %xmm7	 # max_minutes, max_minutes — Restore max_minutes
	call	fclose	 # — Close file after pass 1
 # StageC.c:125:     if (last != '\n') lines++;      /* final line without a newline */
	xorl	%eax, %eax	 # tmp1099 — 0
	cmpq	$10, %rsi	 #, last — Check if last byte was '\n' (10)
 # StageC.c:124:     fclose(fp);
	movapd	%xmm11, %xmm8	 # tmp1081, tmp1081 — Restore 1000.0
 # StageC.c:125:     if (last != '\n') lines++;      /* final line without a newline */
	setne	%al	 #, tmp1099 — %al = 1 if last != '\n'
	addq	%rax, %r14	 # tmp1099, lines — Add 1 if final line lacked '\n'
 # StageC.c:137:     trades = malloc((size_t)lines * sizeof(Trade));
	movq	%r14, %rcx	 # lines, _343 — lines
	salq	$5, %rcx	 #, _343 — lines * 32 (sizeof(Trade) == 32)
 # StageC.c:137:     trades = malloc((size_t)lines * sizeof(Trade));
	call	malloc	 # — Allocate exact-fit trade buffer
 # StageC.c:137:     trades = malloc((size_t)lines * sizeof(Trade));
	movq	%rax, trades(%rip)	 # tmp1179, trades — Store trades pointer
 # StageC.c:138:     if (trades == NULL) {
	testq	%rax, %rax	 # tmp1179 — Check malloc success
	je	.L240	 #, — Fail if NULL
 # StageC.c:143:     FILE *fp = fopen(path, "r");
	leaq	.LC23(%rip), %rdx	 #, — "r"
	movq	%rbx, %rcx	 # path, — File path
	call	fopen	 # — Reopen file for pass 2 trade parsing
	movq	%rax, %r12	 #, fp — Save FILE * in %r12
 # StageC.c:144:     if (fp == NULL) return -1;
	testq	%rax, %rax	 # fp — Check open success
	je	.L37	 #, — Return -1 if NULL
 # StageC.c:146:     long long n = 0;
	xorl	%r15d, %r15d	 # n — Loaded trade count n = 0
	leaq	184(%rsp), %rbp	 #, tmp1082 — &ts at 184(%rsp)
	leaq	180(%rsp), %rdi	 #, tmp1080 — &is_buy at 180(%rsp)
 # StageC.c:149:     while (n < lines && read_trade_fixed(fp, &ts, &price, &qty, &is_buy)) {
	testq	%r14, %r14	 # lines — Check if lines > 0
	jne	.L48	 #, — Enter parse loop if lines > 0
	jmp	.L49	 # — Close file if 0 lines
	.p2align 4,,10 # Alignment hint
	.p2align 3 # 8-byte alignment
.L50: # Store parsed Trade into trades[n]
 # StageC.c:150:         trades[n].ts_us = ts;
	movq	184(%rsp), %xmm0	 # ts, _630 — Load ts_us into low 64 bits of %xmm0
 # StageC.c:150:         trades[n].ts_us = ts;
	movq	%r15, %rax	 # n, _456 — Current index n
 # StageC.c:150:         trades[n].ts_us = ts;
	movhps	192(%rsp), %xmm0	 # price, _630 — Load price into high 64 bits of %xmm0
 # StageC.c:154:         n++;
	addq	$1, %r15	 #, n — n++
 # StageC.c:150:         trades[n].ts_us = ts;
	salq	$5, %rax	 #, _456 — n * 32
	addq	trades(%rip), %rax	 # trades, _350 — &trades[n]
 # StageC.c:150:         trades[n].ts_us = ts;
	movups	%xmm0, (%rax)	 # _630, MEM <vector(2) long long int> [(long long int *)_350] — Store ts_us (offset +0) and price (offset +8)
 # StageC.c:152:         trades[n].qty = qty;
	movq	200(%rsp), %rdx	 # MEM[(long long int *)_743], MEM[(long long int *)_743] — Load qty
	movq	%rdx, 16(%rax)	 # MEM[(long long int *)_743], _350->qty — Store qty at offset +16
 # StageC.c:153:         trades[n].is_buy = is_buy;
	movl	180(%rsp), %edx	 # is_buy, is_buy — Load is_buy
	movl	%edx, 24(%rax)	 # is_buy, _350->is_buy — Store is_buy at offset +24
 # StageC.c:149:     while (n < lines && read_trade_fixed(fp, &ts, &price, &qty, &is_buy)) {
	cmpq	%r15, %r14	 # n, lines — Check if n == lines
	je	.L49	 #, — Done if reached line count
.L48: # Call read_trade_fixed for next trade
 # StageC.c:149:     while (n < lines && read_trade_fixed(fp, &ts, &price, &qty, &is_buy)) {
	movq	%rdi, 32(%rsp)	 # tmp1080, — Stack arg 5 (&is_buy)
	leaq	200(%rsp), %r9	 #, — Arg 4: &qty
	movq	%rbp, %rdx	 # tmp1082, — Arg 2: &ts
	movq	%r12, %rcx	 # fp, — Arg 1: fp
	leaq	192(%rsp), %r8	 #, — Arg 3: &price
	call	read_trade_fixed	 # — Parse one trade row
 # StageC.c:149:     while (n < lines && read_trade_fixed(fp, &ts, &price, &qty, &is_buy)) {
	testl	%eax, %eax	 # _356 — Non-zero if trade parsed
	jne	.L50	 #, — Store trade if valid
	movq	%r15, %r14	 # n, lines — Clamp lines to actual valid trades read
.L49: # Close file after pass 2
 # StageC.c:156:     fclose(fp);
	movq	%r12, %rcx	 # fp, — FILE *
	call	fclose	 # — Close trade CSV
.L47: # Record trade_count and compute load elapsed time
 # StageC.c:341:     trade_count = load_trades(path);
	movq	%r14, trade_count(%rip)	 # lines, trade_count — Store trade_count
 # StageC.c:342:     double load_s = (now_ns() - load_start) / 1e9;
	call	now_ns	 # — Read end timestamp in ns
 # StageC.c:343:     if (trade_count < 0) return 1;
	movq	trade_count(%rip), %rdi	 # trade_count, replay_n — Load trade_count
	movq	%rdi, 64(%rsp)	 # replay_n, %sfp — Spill replay_n
 # StageC.c:343:     if (trade_count < 0) return 1;
	testq	%rdi, %rdi	 # replay_n — Check if < 0 (load error)
	js	.L11	 #, — Exit with 1 if load failed
 # StageC.c:344:     if (trade_count < long_win) {
	movslq	long_win(%rip), %rdx	 # long_win, — Sign-extend long_win
	movq	%rdx, %r9	 #, — Copy long_win
 # StageC.c:344:     if (trade_count < long_win) {
	cmpq	%rdx, %rdi	 # _52, replay_n — Check trade_count < long_win
	jl	.L241	 #, — Abort if fewer trades than long window
 # StageC.c:342:     double load_s = (now_ns() - load_start) / 1e9;
	subq	72(%rsp), %rax	 # %sfp, _48 — Elapsed load ns
	js	.L52	 #, — Handle high-bit unsigned delta
	pxor	%xmm3, %xmm3	 # _49 — Clear %xmm3
	cvtsi2sdq	%rax, %xmm3	 # _48, _49 — Convert elapsed ns to double
.L53: # Convert load time to seconds and check max_minutes cap
 # StageC.c:351:     if (max_minutes > 0.0) {
	pxor	%xmm0, %xmm0	 # tmp679 — 0.0
 # StageC.c:354:         while (k < trade_count && trades[k].ts_us - trades[0].ts_us <= limit_us) k++;
	movq	trades(%rip), %rcx	 # trades, pretmp_780 — Base pointer of trades array
 # StageC.c:342:     double load_s = (now_ns() - load_start) / 1e9;
	divsd	.LC25(%rip), %xmm3	 #, load_s — load_s = ns / 1e9
 # StageC.c:351:     if (max_minutes > 0.0) {
	comisd	%xmm0, %xmm7	 # tmp679, max_minutes — Compare 0.0 vs max_minutes
 # StageC.c:354:         while (k < trade_count && trades[k].ts_us - trades[0].ts_us <= limit_us) k++;
	movq	(%rcx), %r8	 # pretmp_780->ts_us, pretmp_781 — First trade timestamp trades[0].ts_us
 # StageC.c:351:     if (max_minutes > 0.0) {
	jbe	.L222	 #, — Skip time window cap if max_minutes <= 0
 # StageC.c:354:         while (k < trade_count && trades[k].ts_us - trades[0].ts_us <= limit_us) k++;
	cmpq	$0, 64(%rsp)	 #, %sfp — Check if replay_n > 0
	je	.L222	 #, — Skip if empty
 # StageC.c:352:         long long limit_us = (long long)(max_minutes * 60.0 * 1e6);
	mulsd	.LC26(%rip), %xmm7	 #, _53 — max_minutes * 60.0
	movq	64(%rsp), %r11	 # %sfp, replay_n — Total available trades
 # StageC.c:353:         long long k = 0;
	xorl	%eax, %eax	 # k — k = 0
 # StageC.c:352:         long long limit_us = (long long)(max_minutes * 60.0 * 1e6);
	movsd	.LC27(%rip), %xmm9	 #, tmp1087 — 1e6
	mulsd	%xmm9, %xmm7	 # tmp1087, _54 — Seconds * 1e6 -> microseconds
 # StageC.c:352:         long long limit_us = (long long)(max_minutes * 60.0 * 1e6);
	cvttsd2siq	%xmm7, %r10	 # _54, limit_us — Truncate to int64_t limit_us
	jmp	.L56	 # — Enter time-cap scan
	.p2align 5 # 32-byte alignment
	.p2align 4,,10 # Alignment hint
	.p2align 3 # 8-byte alignment
.L57: # Advance index while within limit_us
 # StageC.c:354:         while (k < trade_count && trades[k].ts_us - trades[0].ts_us <= limit_us) k++;
	addq	$1, %rax	 #, k — k++
 # StageC.c:354:         while (k < trade_count && trades[k].ts_us - trades[0].ts_us <= limit_us) k++;
	cmpq	%rax, %r11	 # k, replay_n — Check k < replay_n
	je	.L54	 #, — Stop if reached end
.L56: # Check trades[k].ts_us - trades[0].ts_us <= limit_us
 # StageC.c:354:         while (k < trade_count && trades[k].ts_us - trades[0].ts_us <= limit_us) k++;
	movq	%rax, %rdx	 # k, _417 — Index k
	salq	$5, %rdx	 #, _417 — Byte offset k * 32
 # StageC.c:354:         while (k < trade_count && trades[k].ts_us - trades[0].ts_us <= limit_us) k++;
	movq	(%rcx,%rdx), %rdx	 # MEM[(long long int *)pretmp_780 + _417 * 1], MEM[(long long int *)pretmp_780 + _417 * 1] — trades[k].ts_us
	subq	%r8, %rdx	 # pretmp_781, _61 — Elapsed market time in us
 # StageC.c:354:         while (k < trade_count && trades[k].ts_us - trades[0].ts_us <= limit_us) k++;
	cmpq	%r10, %rdx	 # limit_us, _61 — Compare with limit_us
	jle	.L57	 #, — Continue if within limit
 # StageC.c:355:         replay_n = k;
	movq	%rax, 64(%rsp)	 # k, %sfp — Cap replay_n = k
.L54: # Compute market_span_s and print replay banner
 # StageC.c:357:     double market_span_s = (trades[replay_n - 1].ts_us - trades[0].ts_us) / 1e6;
	movq	64(%rsp), %rax	 # %sfp, tmp688 — replay_n
 # StageC.c:357:     double market_span_s = (trades[replay_n - 1].ts_us - trades[0].ts_us) / 1e6;
	pxor	%xmm0, %xmm0	 # _69 — Clear %xmm0
 # StageC.c:357:     double market_span_s = (trades[replay_n - 1].ts_us - trades[0].ts_us) / 1e6;
	salq	$5, %rax	 #, tmp688 — replay_n * 32
 # StageC.c:357:     double market_span_s = (trades[replay_n - 1].ts_us - trades[0].ts_us) / 1e6;
	movq	-32(%rax,%rcx), %rax	 # _65->ts_us, _65->ts_us — trades[replay_n - 1].ts_us
	subq	%r8, %rax	 # pretmp_781, _68 — Span in microseconds
 # StageC.c:359:     printf("Stage C replay: %s, windows %d/%d, %s SMA, speed %s\n",
	movl	short_win(%rip), %r8d	 # short_win, pretmp_777 — Arg 3: short_win
 # StageC.c:357:     double market_span_s = (trades[replay_n - 1].ts_us - trades[0].ts_us) / 1e6;
	cvtsi2sdq	%rax, %xmm0	 # _68, _69 — Convert span us to double
 # StageC.c:357:     double market_span_s = (trades[replay_n - 1].ts_us - trades[0].ts_us) / 1e6;
	divsd	%xmm9, %xmm0	 # tmp1087, _69 — market_span_s = span_us / 1e6
 # StageC.c:360:            path, short_win, long_win, naive_mode ? "naive" : "running-sum",
	movl	naive_mode(%rip), %eax	 # naive_mode, pretmp_776 — Load naive_mode flag
 # StageC.c:357:     double market_span_s = (trades[replay_n - 1].ts_us - trades[0].ts_us) / 1e6;
	movq	%xmm0, %r13	 # _69, market_span_s — Save market_span_s in %r13
 # StageC.c:359:     printf("Stage C replay: %s, windows %d/%d, %s SMA, speed %s\n",
	pxor	%xmm0, %xmm0	 # tmp694 — 0.0
	ucomisd	%xmm0, %xmm6	 # tmp694, speed — Compare speed with 0.0
	jp	.L168	 #, — Unordered (NaN) -> paced branch
	je	.L58	 #, — speed == 0.0 -> unpaced branch
.L168: # Paced replay mode banner
 # StageC.c:359:     printf("Stage C replay: %s, windows %d/%d, %s SMA, speed %s\n",
	testl	%eax, %eax	 # pretmp_776 — Check naive_mode
	jne	.L155	 #, — Jump if naive_mode != 0
 # StageC.c:359:     printf("Stage C replay: %s, windows %d/%d, %s SMA, speed %s\n",
	leaq	.LC6(%rip), %rax	 #, iftmp.13_217 — "running-sum"
.L60: # Print replay header, load stats, and span
 # StageC.c:359:     printf("Stage C replay: %s, windows %d/%d, %s SMA, speed %s\n",
	leaq	.LC29(%rip), %rdi	 #, tmp1311 — "paced"
	movq	%rax, 32(%rsp)	 # iftmp.13_217, — Stack arg 5: SMA mode string
	movq	%rbx, %rdx	 # path, — Arg 2: path
	leaq	.LC28(%rip), %rcx	 #, — Arg 1: format
	movq	%rdi, 40(%rsp)	 # tmp1311, — Stack arg 6: "paced"
	movsd	%xmm3, 72(%rsp)	 # load_s, %sfp — Spill load_s
	call	printf	 # — Print replay configuration
 # StageC.c:363:            trade_count, trade_count * sizeof(Trade) / 1048576.0, load_s);
	movq	trade_count(%rip), %rdx	 # trade_count, trade_count.17_72 — Arg 2: trade_count
 # StageC.c:362:     printf("Trades loaded: %lld (malloc %.1f MB)   load time %.3f s\n",
	movsd	72(%rsp), %xmm3	 # %sfp, load_s — Restore load_s
	movq	%rdx, %rax	 # trade_count.17_72, _74 — trade_count
	salq	$5, %rax	 #, _74 — Bytes allocated (trade_count * 32)
	js	.L61	 #, — Handle high-bit value
	pxor	%xmm2, %xmm2	 # _75 — Clear %xmm2
	cvtsi2sdq	%rax, %xmm2	 # _74, _75 — Convert bytes to double
.L62: # Format MB and print load summary
	movsd	.LC30(%rip), %xmm7	 #, tmp1088 — 1.0 / 1048576.0
	movq	%xmm3, %r9	 # load_s, — Arg 4: load_s
	leaq	.LC31(%rip), %rcx	 #, — Arg 1: format
	mulsd	%xmm7, %xmm2	 # tmp1088, _75 — Convert bytes to MB
	movapd	%xmm7, %xmm10	 # tmp1088, tmp1088 — Keep 1/MB factor in %xmm10
	movq	%xmm2, %r8	 # _75, _76 — Arg 3: MB
	call	printf	 # — Print load summary
 # StageC.c:364:     printf("Replaying %lld trades covering %.1f s of market time", replay_n, market_span_s);
	movq	64(%rsp), %rdx	 # %sfp, — Arg 2: replay_n
	movq	%r13, %r8	 # market_span_s, — Arg 3: market_span_s
	movq	%r13, %xmm2	 # market_span_s, — Pass float arg in XMM register per ABI
	leaq	.LC32(%rip), %rcx	 #, — Arg 1: format
	call	printf	 # — Print replay trade count and span
 # StageC.c:365:     if (speed > 0.0) printf(" at %gx (about %.1f s)", speed, market_span_s / speed);
	pxor	%xmm0, %xmm0	 # tmp716 — 0.0
	comisd	%xmm0, %xmm6	 # tmp716, speed — Check speed > 0.0
	jbe	.L63	 #, — Skip speed estimate if unpaced
 # StageC.c:365:     if (speed > 0.0) printf(" at %gx (about %.1f s)", speed, market_span_s / speed);
	movq	%r13, %xmm3	 # market_span_s, _77 — market_span_s
	movapd	%xmm6, %xmm1	 # speed, — speed
	movq	%xmm6, %rdx	 # speed, — Arg 2: speed
	divsd	%xmm6, %xmm3	 # speed, _77 — Expected duration = market_span_s / speed
	leaq	.LC33(%rip), %rcx	 #, — Arg 1: format
	movq	%xmm3, %r8	 # _77, _77 — Arg 3: expected seconds
	movapd	%xmm3, %xmm2	 # _77, — Pass float arg in XMM
	call	printf	 # — Print speed and expected time
	jmp	.L63	 # — Proceed to initialize replay state
.L153: # Remainder scan start index = 0
 # StageC.c:119:         for (size_t k = 0; k < n; k++) {
	xorl	%eax, %eax	 # k — k = 0
	jmp	.L42	 # — Enter byte loop
.L238: # Verify "-q"
 # StageC.c:320:         } else if (strcmp(argv[a], "-q") == 0) {
	cmpb	$0, 2(%rcx)	 #, MEM <char[1:3]> [(void *)_4] — Ensure exact "-q"
	jne	.L174	 #, — Try "-o"
 # StageC.c:321:             quiet = 1;
	movl	$1, 116(%rsp)	 #, %sfp — quiet = 1
	jmp	.L10	 # — Next argument
.L229: # Fast path for rival_ns < 2^63
 # StageC.c:327:             rival_ns = (uint64_t)(r_us * 1000.0 + 0.5);
	cvttsd2siq	%xmm0, %rax	 # _43, tmp562 — Convert rounded ns to int64_t
	movq	%rax, rival_ns(%rip)	 # tmp562, rival_ns — Store rival_ns
	jmp	.L10	 # — Next argument
.L239: # Store custom log path from "-o FILE"
 # StageC.c:323:             log_path = argv[++a];
	movq	8(%rbp,%r13,8), %rax	 # *_34, *_34 — Load log filename
	movq	%rax, log_path(%rip)	 # *_34, log_path — Update log_path global
	jmp	.L10	 # — Next argument
.L58: # Unpaced replay banner
 # StageC.c:359:     printf("Stage C replay: %s, windows %d/%d, %s SMA, speed %s\n",
	testl	%eax, %eax	 # pretmp_776 — Check naive_mode
	jne	.L139	 #, — Jump if naive mode
 # StageC.c:359:     printf("Stage C replay: %s, windows %d/%d, %s SMA, speed %s\n",
	leaq	.LC62(%rip), %rax	 #, tmp1401 — "unpaced"
	movsd	%xmm3, 72(%rsp)	 # load_s, %sfp — Spill load_s
	movq	%rax, 40(%rsp)	 # tmp1401, — Stack arg 6: "unpaced"
	leaq	.LC6(%rip), %rax	 #, tmp1402 — "running-sum"
.L226: # Print unpaced header and load info
	movq	%rax, 32(%rsp)	 # tmp1402, — Stack arg 5: SMA mode
	movq	%rbx, %rdx	 # path, — Arg 2: path
	leaq	.LC28(%rip), %rcx	 #, — Arg 1: format
	call	printf	 # — Print banner
 # StageC.c:363:            trade_count, trade_count * sizeof(Trade) / 1048576.0, load_s);
	movq	trade_count(%rip), %rdx	 # trade_count, trade_count.17_564 — Arg 2: trade_count
 # StageC.c:362:     printf("Trades loaded: %lld (malloc %.1f MB)   load time %.3f s\n",
	movsd	72(%rsp), %xmm3	 # %sfp, load_s — Restore load_s
	movq	%rdx, %rax	 # trade_count.17_564, _734 — trade_count
	salq	$5, %rax	 #, _734 — Bytes allocated
	js	.L141	 #, — Handle large unsigned
	pxor	%xmm2, %xmm2	 # _62 — Clear %xmm2
	cvtsi2sdq	%rax, %xmm2	 # _734, _62 — Convert bytes to double
.L142: # Print load summary for unpaced run
	movsd	.LC30(%rip), %xmm7	 #, tmp1088 — 1/1048576
	leaq	.LC31(%rip), %rcx	 #, — Format
	movq	%xmm3, %r9	 # load_s, — Arg 4: load_s
	mulsd	%xmm7, %xmm2	 # tmp1088, _62 — MB
	movapd	%xmm7, %xmm10	 # tmp1088, tmp1088 — Save MB factor
	movq	%xmm2, %r8	 # _62, _778 — Arg 3: MB
	call	printf	 # — Print load summary
 # StageC.c:364:     printf("Replaying %lld trades covering %.1f s of market time", replay_n, market_span_s);
	movq	64(%rsp), %rdx	 # %sfp, — Arg 2: replay_n
	movq	%r13, %r8	 # market_span_s, — Arg 3: market_span_s
	movq	%r13, %xmm2	 # market_span_s, — XMM float arg
	leaq	.LC32(%rip), %rcx	 #, — Format
	call	printf	 # — Print replay span
.L63: # Init LED, rival bot, and replay start timestamp
 # StageC.c:366:     printf("\n\n");
	leaq	.LC34(%rip), %rcx	 #, — "\n"
	call	puts	 # — Print blank line separator
 # StageC.c:368:     if (use_led) led_init();
	cmpl	$0, 112(%rsp)	 #, %sfp — Check use_led
	jne	.L242	 #, — Print LED init message if enabled
 # StageC.c:369:     rival_init(&rival);
	leaq	rival(%rip), %rax	 #, tmp1085 — &rival
	movq	%rax, %rcx	 # tmp1085, — Arg 1: &rival
	movq	%rax, 144(%rsp)	 # tmp1085, %sfp — Spill &rival
	call	rival_init	 # — Initialize rival bot state
 # StageC.c:376:     long long ts0 = trades[0].ts_us;
	movq	trades(%rip), %rax	 # trades, trades — trades array base
	movq	(%rax), %rax	 # trades.20_522->ts_us, ts0 — First trade timestamp ts0
	movq	%rax, 168(%rsp)	 # ts0, %sfp — Spill ts0
 # StageC.c:378:     uint64_t t_start = now_ns();
	call	now_ns	 # — Capture replay start time t_start
	movq	%rax, 160(%rsp)	 # t_start, %sfp — Spill t_start
 # StageC.c:381:     for (long long i = 0; i < replay_n; i++) {
	cmpq	$0, 64(%rsp)	 #, %sfp — Check replay_n > 0
	je	.L135	 #, — Jump to end if 0 trades to replay
.L223: # Initialize loop accumulators before entering replay loop
 # StageC.c:372:     unsigned long long lat_sum = 0, lat_max = 0;
	xorl	%r14d, %r14d	 # — 0
 # StageC.c:379:     uint64_t next_status = t_start + 1000000000ULL;
	addq	$1000000000, %rax	 #, next_status — Next status update in 1 second (1e9 ns)
 # timing.h:32:   static inline void sleep_ms(int ms) { Sleep((DWORD)ms); }
	movq	%r13, %xmm11	 # market_span_s, market_span_s — Preserve market_span_s
 # StageC.c:359:     printf("Stage C replay: %s, windows %d/%d, %s SMA, speed %s\n",
	xorl	%ebp, %ebp	 # ivtmp.204 — Trade index i = 0
 # StageC.c:372:     unsigned long long lat_sum = 0, lat_max = 0;
	movq	%r14, 96(%rsp)	 #, %sfp — lag_max_ns = 0
	movq	__imp_QueryPerformanceCounter(%rip), %rdi	 #, tmp1092 — Cache QPC function pointer
	leaq	200(%rsp), %rsi	 #, tmp1084 — Scratch LARGE_INTEGER pointer
 # timing.h:32:   static inline void sleep_ms(int ms) { Sleep((DWORD)ms); }
	xorl	%r13d, %r13d	 # ivtmp.206 — Byte offset i * 32 = 0
 # StageC.c:379:     uint64_t next_status = t_start + 1000000000ULL;
	movq	%rax, 136(%rsp)	 # next_status, %sfp — Spill next_status
 # StageC.c:387:             release = t_start + (uint64_t)((double)gap_us * 1000.0 / speed);
	movsd	.LC17(%rip), %xmm7	 #, tmp1149 — 2^63 constant
 # StageC.c:372:     unsigned long long lat_sum = 0, lat_max = 0;
	movq	%r14, 80(%rsp)	 #, %sfp — proc_max = 0
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	movq	__imp_QueryPerformanceFrequency(%rip), %r15	 #, tmp1150 — Cache QPF function pointer
 # StageC.c:372:     unsigned long long lat_sum = 0, lat_max = 0;
	movq	%r14, 128(%rsp)	 #, %sfp — proc_sum = 0
 # StageC.c:372:     unsigned long long lat_sum = 0, lat_max = 0;
	movq	%r14, 72(%rsp)	 #, %sfp — lat_max = 0
	movq	%r14, 120(%rsp)	 #, %sfp — lat_sum = 0
	.p2align 4 # Hot replay loop alignment
	.p2align 3 # 8-byte alignment
.L110: # Per-trade replay iteration
 # StageC.c:384:         if (speed > 0.0) {
	pxor	%xmm0, %xmm0	 # tmp729 — 0.0
	comisd	%xmm0, %xmm6	 # tmp729, speed — Check if paced (speed > 0.0)
	jbe	.L217	 #, — Unpaced release time = now_ns()
 # StageC.c:385:             long long gap_us = trades[i].ts_us - ts0;
	movq	trades(%rip), %rax	 # trades, trades — trades array base
 # StageC.c:386:             if (gap_us < 0) gap_us = 0;
	movl	$0, %edx	 #, tmp1209 — 0 clamp value
 # StageC.c:387:             release = t_start + (uint64_t)((double)gap_us * 1000.0 / speed);
	pxor	%xmm0, %xmm0	 # _84 — Clear %xmm0
 # StageC.c:385:             long long gap_us = trades[i].ts_us - ts0;
	movq	(%rax,%r13), %rax	 # _82->ts_us, _82->ts_us — trades[i].ts_us
	subq	168(%rsp), %rax	 # %sfp, gap_us_294 — gap_us = ts_us - ts0
 # StageC.c:386:             if (gap_us < 0) gap_us = 0;
	cmovs	%rdx, %rax	 # gap_us_294,, tmp1209, gap_us_294 — Clamp negative gap_us to 0
 # StageC.c:387:             release = t_start + (uint64_t)((double)gap_us * 1000.0 / speed);
	cvtsi2sdq	%rax, %xmm0	 # gap_us_294, _84 — Convert gap_us to double
 # StageC.c:387:             release = t_start + (uint64_t)((double)gap_us * 1000.0 / speed);
	mulsd	%xmm8, %xmm0	 # tmp1081, _85 — gap_us * 1000.0 -> ns at 1x
 # StageC.c:387:             release = t_start + (uint64_t)((double)gap_us * 1000.0 / speed);
	divsd	%xmm6, %xmm0	 # speed, _86 — Divide by replay speed
 # StageC.c:387:             release = t_start + (uint64_t)((double)gap_us * 1000.0 / speed);
	comisd	%xmm7, %xmm0	 # tmp1149, _86 — Check >= 2^63
	jnb	.L69	 #, — Handle unsigned conversion
	cvttsd2siq	%xmm0, %rbx	 # _86, _87 — Truncate scaled offset to int64_t
.L70: # Add t_start to obtain release nanosecond timestamp
 # StageC.c:387:             release = t_start + (uint64_t)((double)gap_us * 1000.0 / speed);
	addq	160(%rsp), %rbx	 # %sfp, release — release = t_start + offset_ns in %rbx
	jmp	.L73	 # — Enter wait_until(release)
	.p2align 4,,10 # Alignment hint
	.p2align 3 # 8-byte alignment
.L71: # Busy-poll QPC until now >= release
 # timing.h:26:       QueryPerformanceCounter(&count);
	movq	%rsi, %rcx	 # tmp1084, — &count
	call	*%rdi	 # tmp1092 — QueryPerformanceCounter
 # timing.h:28:       uint64_t f = (uint64_t)freq.QuadPart, c = (uint64_t)count.QuadPart;
	movq	freq.0(%rip), %r8	 # freq.QuadPart, f — Frequency f
	movq	200(%rsp), %rax	 # MEM[(union _LARGE_INTEGER *)_743].QuadPart, MEM[(union _LARGE_INTEGER *)_743].QuadPart — Counter c
	xorl	%edx, %edx	 # tmp747 — Clear high dividend
	divq	%r8	 # f — c / f and c % f
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	imulq	$1000000000, %rax, %rcx	 #, MEM[(union _LARGE_INTEGER *)_743].QuadPart, _389 — (c / f) * 1e9
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	imulq	$1000000000, %rdx, %rax	 #, tmp747, _391 — (c % f) * 1e9
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	xorl	%edx, %edx	 # tmp752 — Clear high dividend
	divq	%r8	 # f — ((c % f) * 1e9) / f
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	addq	%rcx, %rax	 # _389, _393 — Current time `now` in ns (%rax)
 # StageC.c:233:         if (now >= target) return;
	cmpq	%rbx, %rax	 # release, _393 — Compare now against release
	jnb	.L72	 #, — Release time reached -> process trade
 # StageC.c:234:         uint64_t remaining = target - now;
	movq	%rbx, %rdx	 # release, remaining — release
	subq	%rax, %rdx	 # _393, remaining — remaining = release - now
 # StageC.c:235:         if (remaining > SLEEP_MARGIN_NS + 1000000ULL) {
	cmpq	$21000000, %rdx	 #, remaining — Compare remaining against 21,000,000 ns (21 ms)
	ja	.L243	 #, — Coarse sleep if > 21 ms remaining
.L73: # Ensure QPF initialized before polling
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	movl	ready.1(%rip), %r12d	 # ready, — Check ready flag
	testl	%r12d, %r12d	 # — Test ready
	jne	.L71	 #, — Poll QPC if ready
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	leaq	freq.0(%rip), %rcx	 #, — &freq
	call	*%r15	 # tmp1150 — QueryPerformanceFrequency
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	movl	$1, ready.1(%rip)	 #, ready — ready = 1
	jmp	.L71	 # — Poll QPC
.L222: # No max_minutes cap; ensure 1e6 constant is loaded
	movsd	.LC27(%rip), %xmm9	 #, tmp1087 — 1e6
	jmp	.L54	 # — Compute market_span_s
.L232: # Enable ENABLE_VIRTUAL_TERMINAL_PROCESSING (0x0004)
 # StageC.c:247:         SetConsoleMode(h, mode | 0x0004);   /* ENABLE_VIRTUAL_TERMINAL_PROCESSING */
	movl	200(%rsp), %edx	 # MEM[(long unsigned int *)_743], _361 — Current console mode
 # StageC.c:247:         SetConsoleMode(h, mode | 0x0004);   /* ENABLE_VIRTUAL_TERMINAL_PROCESSING */
	movq	%rdi, %rcx	 # h, — Console handle
 # StageC.c:247:         SetConsoleMode(h, mode | 0x0004);   /* ENABLE_VIRTUAL_TERMINAL_PROCESSING */
	orl	$4, %edx	 #, _361 — Set bit 0x0004
 # StageC.c:247:         SetConsoleMode(h, mode | 0x0004);   /* ENABLE_VIRTUAL_TERMINAL_PROCESSING */
	call	*__imp_SetConsoleMode(%rip)	 # — Apply console mode
	jmp	.L34	 # — Proceed to load trades
.L139: # Unpaced + naive mode labels
 # StageC.c:359:     printf("Stage C replay: %s, windows %d/%d, %s SMA, speed %s\n",
	leaq	.LC62(%rip), %rax	 #, tmp1391 — "unpaced"
	movsd	%xmm3, 72(%rsp)	 # load_s, %sfp — Spill load_s
	movq	%rax, 40(%rsp)	 # tmp1391, — Stack arg 6
	leaq	.LC5(%rip), %rax	 #, tmp1392 — "naive"
	jmp	.L226	 # — Print banner
.L155: # Paced + naive mode label
 # StageC.c:359:     printf("Stage C replay: %s, windows %d/%d, %s SMA, speed %s\n",
	leaq	.LC5(%rip), %rax	 #, iftmp.13_217 — "naive"
	jmp	.L60	 # — Print banner
.L241: # Not enough trades for long_win
 # StageC.c:345:         printf("Not enough trades (%lld) for the long window (%d)\n", trade_count, long_win);
	movl	%edx, %r8d	 # long_win.1_51, — Arg 3: long_win
	leaq	.LC24(%rip), %rcx	 #, — Format
	movq	%rdi, %rdx	 # replay_n, — Arg 2: trade_count
	call	printf	 # — Print error
 # StageC.c:346:         return 1;
	jmp	.L11	 # — Return 1
	.p2align 4,,10 # Alignment hint
	.p2align 3 # 8-byte alignment
.L217: # Unpaced mode: release = now_ns()
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	movl	ready.1(%rip), %ebx	 # ready, — Check QPF initialized
	testl	%ebx, %ebx	 # — Test ready
	je	.L244	 #, — Query QPF if needed
.L75: # Read now_ns() as release time
 # timing.h:26:       QueryPerformanceCounter(&count);
	movq	%rsi, %rcx	 # tmp1084, — &count
	call	*%rdi	 # tmp1092 — QueryPerformanceCounter
 # timing.h:28:       uint64_t f = (uint64_t)freq.QuadPart, c = (uint64_t)count.QuadPart;
	movq	freq.0(%rip), %r8	 # freq.QuadPart, f — f
	movq	200(%rsp), %rax	 # MEM[(union _LARGE_INTEGER *)_743].QuadPart, MEM[(union _LARGE_INTEGER *)_743].QuadPart — c
	xorl	%edx, %edx	 # tmp765 — Clear high dividend
	divq	%r8	 # f — c / f and c % f
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	imulq	$1000000000, %rax, %rcx	 #, MEM[(union _LARGE_INTEGER *)_743].QuadPart, _400 — (c / f) * 1e9
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	imulq	$1000000000, %rdx, %rax	 #, tmp765, _402 — (c % f) * 1e9
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	xorl	%edx, %edx	 # tmp770 — Clear high dividend
	divq	%r8	 # f — ((c % f) * 1e9) / f
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	leaq	(%rax,%rcx), %rbx	 #, release — release = now_ns() in %rbx
.L72: # Capture `before` timestamp and process trade i
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	movl	ready.1(%rip), %r11d	 # ready, — Check QPF ready
	testl	%r11d, %r11d	 # — Test ready
	je	.L245	 #, — Query QPF if needed
.L76: # Read `before` timestamp in ns
 # timing.h:26:       QueryPerformanceCounter(&count);
	movq	%rsi, %rcx	 # tmp1084, — &count
	call	*%rdi	 # tmp1092 — QueryPerformanceCounter
 # timing.h:28:       uint64_t f = (uint64_t)freq.QuadPart, c = (uint64_t)count.QuadPart;
	movq	freq.0(%rip), %rcx	 # freq.QuadPart, f — f
	xorl	%edx, %edx	 # tmp777 — Clear high dividend
	movq	200(%rsp), %rax	 # MEM[(union _LARGE_INTEGER *)_743].QuadPart, MEM[(union _LARGE_INTEGER *)_743].QuadPart — c
 # StageC.c:187:     long long p = trades[i].price;
	movq	trades(%rip), %r8	 # trades, trades.80_416 — trades array base
 # StageC.c:193:     if (naive_mode) {
	movl	naive_mode(%rip), %r10d	 # naive_mode, — Load naive_mode flag
	divq	%rcx	 # f — c / f and c % f
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	imulq	$1000000000, %rax, %r12	 #, tmp776, _495 — High term of `before` in %r12
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	imulq	$1000000000, %rdx, %rax	 #, tmp777, _497 — Remainder term
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	xorl	%edx, %edx	 # tmp781 — Clear high dividend
	divq	%rcx	 # f — Remainder ns
	movq	%rax, %r14	 # _497, _498 — Low term of `before` in %r14 (`before` = %r12 + %r14)
 # StageC.c:187:     long long p = trades[i].price;
	leaq	(%r8,%r13), %rax	 #, ivtmp.195 — &trades[i]
 # StageC.c:187:     long long p = trades[i].price;
	movq	8(%rax), %rdx	 # _419->price, p — Load p = trades[i].price
 # StageC.c:188:     long long q = trades[i].qty;
	movq	16(%rax), %rcx	 # _419->qty, q — Load q = trades[i].qty
 # StageC.c:191:     total_q += q;
	addq	%rcx, total_q(%rip)	 # q, total_q — Accumulate total quantity
 # StageC.c:190:     total_pq += p * q;
	movq	%rdx, %r9	 # p, _422 — Copy p
	imulq	%rcx, %r9	 # q, _422 — p * q
 # StageC.c:190:     total_pq += p * q;
	addq	%r9, total_pq(%rip)	 # _422, total_pq — Accumulate price*quantity
 # StageC.c:194:         if (i >= short_win - 1) {
	movslq	short_win(%rip), %r9	 # short_win, — short_win
 # StageC.c:193:     if (naive_mode) {
	testl	%r10d, %r10d	 # — Check naive_mode
	je	.L77	 #, — Running-sum SMA path if naive_mode == 0
 # StageC.c:194:         if (i >= short_win - 1) {
	leal	-1(%r9), %edx	 #, _429 — short_win - 1
	movslq	%edx, %rdx	 # _429, _430 — Sign-extend
 # StageC.c:194:         if (i >= short_win - 1) {
	cmpq	%rbp, %rdx	 # ivtmp.204, _430 — Compare short_win - 1 with i
	jg	.L78	 #, — Skip short SMA if i < short_win - 1
 # StageC.c:196:             for (int k = 0; k < short_win; k++) s += trades[i - k].price;
	testl	%r9d, %r9d	 # pretmp_771 — Check short_win > 0
	jle	.L156	 #, — Zero sum if <= 0
	movslq	%r9d, %rcx	 # pretmp_771, _314 — short_win
	movq	%r8, %r10	 # trades.80_416, _727 — trades base
	movq	%rax, %rdx	 # ivtmp.195, ivtmp.201 — &trades[i]
	salq	$5, %rcx	 #, _302 — short_win * 32
	subq	%rcx, %r10	 # _302, _727 — Base minus window bytes
 # StageC.c:195:             long long s = 0;
	xorl	%ecx, %ecx	 # s — s = 0
	addq	%r13, %r10	 # ivtmp.206, _367 — Stop pointer &trades[i - short_win]
	.p2align 4 # Loop alignment
	.p2align 4 # 16-byte alignment
	.p2align 3 # 8-byte alignment
.L80: # Naive short-window summation loop
 # StageC.c:196:             for (int k = 0; k < short_win; k++) s += trades[i - k].price;
	addq	8(%rdx), %rcx	 # MEM[(long long int *)_636 + 8B], s — s += trades[idx].price
 # StageC.c:196:             for (int k = 0; k < short_win; k++) s += trades[i - k].price;
	subq	$32, %rdx	 #, ivtmp.201 — Step backward one Trade (32 bytes)
	cmpq	%rdx, %r10	 # ivtmp.201, _367 — Reached start of short window?
	jne	.L80	 #, — Continue summing
.L79: # Store short_sum from naive calculation
 # StageC.c:197:             short_sum = s;
	movq	%rcx, short_sum(%rip)	 # s, short_sum — short_sum = s
.L78: # Naive long-window check
 # StageC.c:199:         if (i >= long_win - 1) {
	movslq	long_win(%rip), %rdx	 # long_win, — long_win
	leal	-1(%rdx), %ecx	 #, _442 — long_win - 1
	movslq	%ecx, %rcx	 # _442, _443 — Sign-extend
 # StageC.c:199:         if (i >= long_win - 1) {
	cmpq	%rbp, %rcx	 # ivtmp.204, _443 — Compare long_win - 1 with i
	jg	.L88	 #, — No crossover signal yet if i < long_win - 1
 # StageC.c:201:             for (int k = 0; k < long_win; k++) s += trades[i - k].price;
	testl	%edx, %edx	 # long_win.90_441 — Check long_win > 0
	jle	.L157	 #, — Zero sum if <= 0
	movq	%rdx, %rcx	 # _467, _377 — long_win
	salq	$5, %rcx	 #, _377 — long_win * 32
	subq	%rcx, %r8	 # _377, _726 — Base minus window bytes
 # StageC.c:200:             long long s = 0;
	xorl	%ecx, %ecx	 # s — s = 0
	addq	%r13, %r8	 # ivtmp.206, _366 — Stop pointer &trades[i - long_win]
	.p2align 4 # Loop alignment
	.p2align 4 # 16-byte alignment
	.p2align 3 # 8-byte alignment
.L84: # Naive long-window summation loop
 # StageC.c:201:             for (int k = 0; k < long_win; k++) s += trades[i - k].price;
	addq	8(%rax), %rcx	 # MEM[(long long int *)_55 + 8B], s — s += trades[idx].price
 # StageC.c:201:             for (int k = 0; k < long_win; k++) s += trades[i - k].price;
	subq	$32, %rax	 #, ivtmp.195 — Step backward one Trade
	cmpq	%rax, %r8	 # ivtmp.195, _366 — Reached start of long window?
	jne	.L84	 #, — Continue summing
.L83: # Store long_sum and evaluate spread d
 # StageC.c:202:             long_sum = s;
	movq	%rcx, long_sum(%rip)	 # s, long_sum — long_sum = s
 # StageC.c:213:         long long d = short_sum * long_win - long_sum * short_win;
	movq	%rdx, %rax	 # _467, _467 — long_win
.L85: # Compute cross-multiplied SMA difference d (avoids division)
	imulq	short_sum(%rip), %rax	 # short_sum, _479 — short_sum * long_win
 # StageC.c:214:         if (have_prev) {
	movl	have_prev(%rip), %r11d	 # have_prev, signal — Load have_prev
 # StageC.c:213:         long long d = short_sum * long_win - long_sum * short_win;
	imulq	%rcx, %r9	 # s, _483 — long_sum * short_win
 # StageC.c:213:         long long d = short_sum * long_win - long_sum * short_win;
	subq	%r9, %rax	 # _483, d — d = short_sum * long_win - long_sum * short_win
 # StageC.c:214:         if (have_prev) {
	testl	%r11d, %r11d	 # signal — Check have_prev != 0
	je	.L89	 #, — First valid sample: no crossover yet
 # StageC.c:215:             if (prev_d <= 0 && d > 0) signal = 1;
	movq	prev_d(%rip), %rdx	 # prev_d, prev_d.109_486 — Load prev_d
 # StageC.c:215:             if (prev_d <= 0 && d > 0) signal = 1;
	testq	%rdx, %rdx	 # prev_d.109_486 — Check prev_d <= 0
	jle	.L246	 #, — Check bullish crossover
.L90: # Check bearish crossover (prev_d >= 0 && d < 0)
 # StageC.c:216:             else if (prev_d >= 0 && d < 0) signal = -1;
	movq	%rax, %rcx	 # d, tmp1336 — Copy d
	sarq	$63, %rcx	 #, tmp1336 — -1 if d < 0, 0 if d >= 0
	movq	%rcx, %r11	 # tmp1336, signal — Set signal = -1 if d < 0 and prev_d >= 0
.L89: # Update prev_d, have_prev, and capture `decided` timestamp
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	movl	ready.1(%rip), %r8d	 # ready, — Check QPF ready
 # StageC.c:218:         prev_d = d;
	movq	%rax, prev_d(%rip)	 # d, prev_d — prev_d = d
 # StageC.c:219:         have_prev = 1;
	movl	$1, have_prev(%rip)	 #, have_prev — have_prev = 1
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	testl	%r8d, %r8d	 # — Test ready
	je	.L247	 #, — Query QPF if needed
.L91: # Read `decided` timestamp in ns
	movl	%r11d, 104(%rsp)	 # signal, %sfp — Spill signal
 # timing.h:26:       QueryPerformanceCounter(&count);
	movq	%rsi, %rcx	 # tmp1084, — &count
	call	*%rdi	 # tmp1092 — QueryPerformanceCounter
 # timing.h:28:       uint64_t f = (uint64_t)freq.QuadPart, c = (uint64_t)count.QuadPart;
	movq	freq.0(%rip), %r8	 # freq.QuadPart, f — f
	xorl	%edx, %edx	 # tmp822 — Clear high dividend
 # StageC.c:409:         if (signal != 0) {
	movl	104(%rsp), %r11d	 # %sfp, signal — Restore signal
	movq	200(%rsp), %rax	 # MEM[(union _LARGE_INTEGER *)_743].QuadPart, MEM[(union _LARGE_INTEGER *)_743].QuadPart — c
	divq	%r8	 # f — c / f and c % f
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	imulq	$1000000000, %rax, %rcx	 #, MEM[(union _LARGE_INTEGER *)_743].QuadPart, _411 — (c / f) * 1e9
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	imulq	$1000000000, %rdx, %rax	 #, tmp822, _413 — (c % f) * 1e9
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	xorl	%edx, %edx	 # tmp827 — Clear high dividend
	divq	%r8	 # f — ((c % f) * 1e9) / f
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	leaq	(%rax,%rcx), %r10	 #, _415 — `decided` timestamp in ns (%r10)
 # StageC.c:398:         uint64_t proc_ns = decided - before;
	movq	%r10, %rax	 # _415, _638 — decided
	subq	%r14, %rax	 # _498, _638 — Subtract low term of `before`
	subq	%r12, %rax	 # _495, _638 — Subtract high term of `before` -> proc_ns
 # StageC.c:399:         uint64_t latency_ns = decided - release;
	movq	%r10, %r12	 # _415, latency_ns — decided
 # StageC.c:398:         uint64_t proc_ns = decided - before;
	movq	%rax, %r14	 # _638, proc_ns — proc_ns in %r14
 # StageC.c:399:         uint64_t latency_ns = decided - release;
	subq	%rbx, %r12	 # release, latency_ns — latency_ns = decided - release in %r12
 # StageC.c:409:         if (signal != 0) {
	testl	%r11d, %r11d	 # signal — Check if BUY (1) or SELL (-1)
	jne	.L92	 #, — Handle non-zero signal
	addq	$1, %rbp	 #, ivtmp.204 — i++ when signal == 0
.L93: # Update timing metrics and periodic progress line
 # StageC.c:403:         if (latency_ns > lat_max) lat_max = latency_ns;
	movq	72(%rsp), %rax	 # %sfp, lat_max — Load lat_max
 # StageC.c:402:         lat_sum += latency_ns;
	addq	%r12, 120(%rsp)	 # lag_ns, %sfp — lat_sum += latency_ns
 # StageC.c:420:         if (!quiet && decided >= next_status) {
	movl	116(%rsp), %ecx	 # %sfp, — Load quiet flag
 # StageC.c:403:         if (latency_ns > lat_max) lat_max = latency_ns;
	cmpq	%r12, %rax	 # lag_ns, lat_max — Compare lat_max vs latency_ns
	cmovb	%r12, %rax	 # lat_max,, lag_ns, lat_max — lat_max = max(lat_max, latency_ns)
 # StageC.c:404:         proc_sum += proc_ns;
	addq	%r14, 128(%rsp)	 # proc_ns, %sfp — proc_sum += proc_ns
 # StageC.c:403:         if (latency_ns > lat_max) lat_max = latency_ns;
	movq	%rax, 72(%rsp)	 # lat_max, %sfp — Spill lat_max
 # StageC.c:405:         if (proc_ns > proc_max) proc_max = proc_ns;
	movq	80(%rsp), %rax	 # %sfp, proc_max — Load proc_max
	cmpq	%r14, %rax	 # proc_ns, proc_max — Compare proc_max vs proc_ns
	cmovnb	%rax, %r14	 # proc_max,, proc_ns — Keep larger proc_ns
 # StageC.c:406:         if (lag_ns > lag_max_ns) lag_max_ns = lag_ns;
	movq	96(%rsp), %rax	 # %sfp, lag_max_ns — Load lag_max_ns
	cmpq	%r12, %rax	 # lag_ns, lag_max_ns — Compare lag_max_ns vs lag_ns
 # StageC.c:405:         if (proc_ns > proc_max) proc_max = proc_ns;
	movq	%r14, 80(%rsp)	 # proc_ns, %sfp — Spill proc_max
 # StageC.c:406:         if (lag_ns > lag_max_ns) lag_max_ns = lag_ns;
	cmovl	%r12, %rax	 # lag_max_ns,, lag_ns, lag_max_ns — Signed max for lag_max_ns
	movq	%rax, 96(%rsp)	 # lag_max_ns, %sfp — Spill lag_max_ns
 # StageC.c:420:         if (!quiet && decided >= next_status) {
	testl	%ecx, %ecx	 # — Check quiet
	jne	.L109	 #, — Skip status print if quiet
	cmpq	136(%rsp), %r10	 # %sfp, _415 — Check decided >= next_status
	jb	.L109	 #, — Not yet time for status line
 # StageC.c:421:             printf("\r  replayed %5.1f%%  | lag %9.3f ms | BUY %lld SELL %lld | P&L %.2f   ",
	movq	144(%rsp), %rcx	 # %sfp, — Arg 1: &rival
	movq	%r10, 104(%rsp)	 # _415, %sfp — Spill decided
	call	rival_pnl	 # — Compute rival P&L in %xmm0
 # StageC.c:421:             printf("\r  replayed %5.1f%%  | lag %9.3f ms | BUY %lld SELL %lld | P&L %.2f   ",
	pxor	%xmm1, %xmm1	 # _116 — Clear %xmm1
 # StageC.c:421:             printf("\r  replayed %5.1f%%  | lag %9.3f ms | BUY %lld SELL %lld | P&L %.2f   ",
	pxor	%xmm2, %xmm2	 # _121 — Clear %xmm2
	cvtsi2sdq	64(%rsp), %xmm2	 # %sfp, _121 — replay_n as double
 # StageC.c:421:             printf("\r  replayed %5.1f%%  | lag %9.3f ms | BUY %lld SELL %lld | P&L %.2f   ",
	cvtsi2sdq	%r12, %xmm1	 # lag_ns, _116 — lag_ns as double
	divsd	%xmm9, %xmm1	 # tmp1087, _116 — lag_ns / 1e6 -> ms
 # StageC.c:421:             printf("\r  replayed %5.1f%%  | lag %9.3f ms | BUY %lld SELL %lld | P&L %.2f   ",
	movq	sell_count(%rip), %rax	 # sell_count, sell_count — Load sell_count
	movq	buy_count(%rip), %r9	 # buy_count, — Arg 4: buy_count
	movsd	%xmm0, 40(%rsp)	 # _113, — Stack arg 6: P&L
	leaq	.LC43(%rip), %rcx	 #, — Format
	movq	%rax, 32(%rsp)	 # sell_count, — Stack arg 5: sell_count
 # StageC.c:421:             printf("\r  replayed %5.1f%%  | lag %9.3f ms | BUY %lld SELL %lld | P&L %.2f   ",
	movq	%xmm1, %r8	 # _116, _117 — Arg 3: lag ms
 # StageC.c:422:                    100.0 * (i + 1) / replay_n, lag_ns / 1e6, buy_count, sell_count,
	pxor	%xmm1, %xmm1	 # _119 — Clear %xmm1
	cvtsi2sdq	%rbp, %xmm1	 # ivtmp.204, _119 — (i + 1) as double
	mulsd	.LC37(%rip), %xmm1	 #, _120 — 100.0 * (i + 1)
 # StageC.c:421:             printf("\r  replayed %5.1f%%  | lag %9.3f ms | BUY %lld SELL %lld | P&L %.2f   ",
	divsd	%xmm2, %xmm1	 # _121, _122 — Percentage replayed
	movq	%r8, %xmm2	 # _117, — Pass lag ms in XMM
	movq	%xmm1, %rdx	 # _122, — Arg 2: percent
	call	printf	 # — Print live progress line
 # StageC.c:424:             fflush(stdout);
	movl	$1, %ecx	 #, — stdout fd/stream selector for __acrt_iob_func
	call	*__imp___acrt_iob_func(%rip)	 # — Obtain stdout FILE*
 # StageC.c:424:             fflush(stdout);
	movq	%rax, %rcx	 # _123, — stdout
	call	fflush	 # — Flush stdout immediately
 # StageC.c:425:             next_status = decided + 1000000000ULL;
	movq	104(%rsp), %r10	 # %sfp, _415 — Restore decided
	leaq	1000000000(%r10), %rax	 #, next_status — Schedule next update in 1s
	movq	%rax, 136(%rsp)	 # next_status, %sfp — Spill next_status
.L109: # Advance replay loop to next trade
 # StageC.c:381:     for (long long i = 0; i < replay_n; i++) {
	addq	$32, %r13	 #, ivtmp.206 — Next trade byte offset (+32)
	cmpq	%rbp, 64(%rsp)	 # ivtmp.204, %sfp — Compare replay_n with next index (i + 1)
	jg	.L110	 #, — Continue loop if more trades remain
 # StageC.c:429:     uint64_t t_end = now_ns();
	call	now_ns	 # — Capture replay end timestamp t_end
	movq	%xmm11, %r13	 # market_span_s, market_span_s — Restore market_span_s
	movq	%rax, %rbx	 # t_end, t_end — Save t_end in %rbx
 # StageC.c:430:     if (use_led) {
	cmpl	$0, 112(%rsp)	 #, %sfp — Check use_led
	jne	.L134	 #, — Turn LEDs off if enabled
.L111: # Clear status line if not quiet
 # StageC.c:435:     if (!quiet) printf("\r%79s\r", "");
	cmpl	$0, 116(%rsp)	 #, %sfp — Check quiet
	je	.L248	 #, — Clear progress line if not quiet
.L112: # Compute wall_s and final_vwap
 # StageC.c:438:     double wall_s = (t_end - t_start) / 1e9;
	subq	160(%rsp), %rbx	 # %sfp, _124 — Elapsed wall ns = t_end - t_start
	js	.L113	 #, — Handle high-bit unsigned delta
	pxor	%xmm7, %xmm7	 # _125 — Clear %xmm7
	cvtsi2sdq	%rbx, %xmm7	 # _124, _125 — Convert elapsed ns to double
.L114: # Compute final VWAP
 # StageC.c:439:     double final_vwap = total_q > 0 ? (double)total_pq / (double)total_q / SCALE_P : 0.0;
	movq	total_q(%rip), %rax	 # total_q, total_q.36_126 — Load total_q
 # StageC.c:439:     double final_vwap = total_q > 0 ? (double)total_pq / (double)total_q / SCALE_P : 0.0;
	pxor	%xmm1, %xmm1	 # final_vwap — Default final_vwap = 0.0
 # StageC.c:438:     double wall_s = (t_end - t_start) / 1e9;
	divsd	.LC25(%rip), %xmm7	 #, wall_s — wall_s = ns / 1e9
 # StageC.c:439:     double final_vwap = total_q > 0 ? (double)total_pq / (double)total_q / SCALE_P : 0.0;
	testq	%rax, %rax	 # total_q.36_126 — Check total_q > 0
	jle	.L115	 #, — Keep 0.0 if total_q <= 0
 # StageC.c:439:     double final_vwap = total_q > 0 ? (double)total_pq / (double)total_q / SCALE_P : 0.0;
	pxor	%xmm0, %xmm0	 # _129 — Clear %xmm0
 # StageC.c:439:     double final_vwap = total_q > 0 ? (double)total_pq / (double)total_q / SCALE_P : 0.0;
	pxor	%xmm1, %xmm1	 # _128 — Clear %xmm1
	cvtsi2sdq	total_pq(%rip), %xmm1	 # total_pq, _128 — (double)total_pq
 # StageC.c:439:     double final_vwap = total_q > 0 ? (double)total_pq / (double)total_q / SCALE_P : 0.0;
	cvtsi2sdq	%rax, %xmm0	 # total_q.36_126, _129 — (double)total_q
 # StageC.c:439:     double final_vwap = total_q > 0 ? (double)total_pq / (double)total_q / SCALE_P : 0.0;
	divsd	%xmm0, %xmm1	 # _129, _130 — total_pq / total_q
 # StageC.c:439:     double final_vwap = total_q > 0 ? (double)total_pq / (double)total_q / SCALE_P : 0.0;
	divsd	.LC37(%rip), %xmm1	 #, final_vwap — Divide by SCALE_P
.L115: # Print summary report
 # StageC.c:441:     printf("\n--- Replay results ---\n");
	leaq	.LC45(%rip), %rcx	 #, — Section header
	movsd	%xmm1, 88(%rsp)	 # final_vwap, %sfp — Spill final_vwap
	call	puts	 # — Print header
 # StageC.c:442:     printf("Trades replayed      : %lld\n", replay_n);
	movq	64(%rsp), %rdx	 # %sfp, — Arg 2: replay_n
	leaq	.LC46(%rip), %rcx	 #, — Format
	call	printf	 # — Print trades replayed
 # StageC.c:443:     printf("Signals              : %lld BUY, %lld SELL\n", buy_count, sell_count);
	movq	sell_count(%rip), %r8	 # sell_count, — Arg 3: sell_count
	movq	buy_count(%rip), %rdx	 # buy_count, — Arg 2: buy_count
	leaq	.LC47(%rip), %rcx	 #, — Format
	call	printf	 # — Print signal counts
 # StageC.c:444:     printf("Final VWAP           : %.8f\n", final_vwap);
	movsd	88(%rsp), %xmm1	 # %sfp, final_vwap — Restore final_vwap
	leaq	.LC48(%rip), %rcx	 #, — Format
	movq	%xmm1, %rdx	 # final_vwap, — Arg 2: final_vwap
	call	printf	 # — Print final VWAP
 # StageC.c:445:     printf("Wall time            : %.3f s", wall_s);
	movapd	%xmm7, %xmm1	 # wall_s, — wall_s
	movq	%xmm7, %rdx	 # wall_s, — Arg 2: wall_s
	leaq	.LC49(%rip), %rcx	 #, — Format
	call	printf	 # — Print wall time
 # StageC.c:446:     if (speed > 0.0) printf("   (ideal %.3f s)", market_span_s / speed);
	pxor	%xmm0, %xmm0	 # tmp913 — 0.0
	comisd	%xmm0, %xmm6	 # tmp913, speed — Check speed > 0.0
	jbe	.L116	 #, — Skip ideal time if unpaced
 # StageC.c:446:     if (speed > 0.0) printf("   (ideal %.3f s)", market_span_s / speed);
	movq	%r13, %xmm1	 # market_span_s, market_span_s — market_span_s
	leaq	.LC50(%rip), %rcx	 #, — Format
	divsd	%xmm6, %xmm1	 # speed, market_span_s — ideal_s = market_span_s / speed
	movq	%xmm1, %rdx	 # _133, — Arg 2: ideal_s
	call	printf	 # — Print ideal time
.L116: # Print trailing newline and processing stats
 # StageC.c:447:     printf("\n");
	movl	$10, %ecx	 #, — '\n'
 # StageC.c:448:     printf("Processing per trade : avg %.1f ns, worst %.3f us\n",
	pxor	%xmm6, %xmm6	 # _137 — Clear %xmm6
 # StageC.c:447:     printf("\n");
	call	putchar	 # — Print '\n'
 # StageC.c:448:     printf("Processing per trade : avg %.1f ns, worst %.3f us\n",
	movq	80(%rsp), %rax	 # %sfp, proc_max — Load proc_max (ns)
	cvtsi2sdq	64(%rsp), %xmm6	 # %sfp, _137 — replay_n as double
	testq	%rax, %rax	 # proc_max — Handle high-bit unsigned
	js	.L118	 #, — High-bit conversion helper
	pxor	%xmm2, %xmm2	 # _134 — Clear %xmm2
	cvtsi2sdq	%rax, %xmm2	 # proc_max, _134 — proc_max as double
.L119: # Convert worst processing ns to us
	divsd	%xmm8, %xmm2	 # tmp1081, _134 — proc_max / 1000.0 -> us
 # StageC.c:449:            (double)proc_sum / replay_n, proc_max / 1000.0);
	movq	128(%rsp), %rax	 # %sfp, proc_sum — Load proc_sum (ns)
 # StageC.c:448:     printf("Processing per trade : avg %.1f ns, worst %.3f us\n",
	movq	%xmm2, %r8	 # _134, _135 — Arg 3: worst us
 # StageC.c:449:            (double)proc_sum / replay_n, proc_max / 1000.0);
	testq	%rax, %rax	 # proc_sum — Handle high-bit unsigned
	js	.L120	 #, — High-bit conversion helper
	pxor	%xmm1, %xmm1	 # _136 — Clear %xmm1
	cvtsi2sdq	%rax, %xmm1	 # proc_sum, _136 — proc_sum as double
.L121: # Print average and worst processing time
 # StageC.c:448:     printf("Processing per trade : avg %.1f ns, worst %.3f us\n",
	divsd	%xmm6, %xmm1	 # _137, _138 — avg ns = proc_sum / replay_n
	movq	%r8, %xmm2	 # _135, — Pass worst us in XMM
	leaq	.LC51(%rip), %rcx	 #, — Format
	movq	%xmm1, %rdx	 # _138, — Arg 2: avg ns
	call	printf	 # — Print processing per trade
 # StageC.c:450:     printf("Latency per trade    : avg %.3f us, worst %.3f us\n",
	movq	72(%rsp), %rax	 # %sfp, lat_max — Load lat_max (ns)
	testq	%rax, %rax	 # lat_max — Handle high-bit unsigned
	js	.L122	 #, — High-bit conversion helper
	pxor	%xmm2, %xmm2	 # _139 — Clear %xmm2
	cvtsi2sdq	%rax, %xmm2	 # lat_max, _139 — lat_max as double
.L123: # Convert worst latency ns to us
	divsd	%xmm8, %xmm2	 # tmp1081, _139 — lat_max / 1000.0 -> us
 # StageC.c:451:            (double)lat_sum / replay_n / 1000.0, lat_max / 1000.0);
	movq	120(%rsp), %rax	 # %sfp, lat_sum — Load lat_sum (ns)
 # StageC.c:450:     printf("Latency per trade    : avg %.3f us, worst %.3f us\n",
	movq	%xmm2, %r8	 # _139, _140 — Arg 3: worst latency us
 # StageC.c:451:            (double)lat_sum / replay_n / 1000.0, lat_max / 1000.0);
	testq	%rax, %rax	 # lat_sum — Handle high-bit unsigned
	js	.L124	 #, — High-bit conversion helper
	pxor	%xmm1, %xmm1	 # _141 — Clear %xmm1
	cvtsi2sdq	%rax, %xmm1	 # lat_sum, _141 — lat_sum as double
.L125: # Print average and worst latency
 # StageC.c:451:            (double)lat_sum / replay_n / 1000.0, lat_max / 1000.0);
	divsd	%xmm6, %xmm1	 # _137, _143 — avg ns = lat_sum / replay_n
	movq	%r8, %xmm2	 # _140, — Pass worst latency us in XMM
	leaq	.LC52(%rip), %rcx	 #, — Format
	divsd	%xmm8, %xmm1	 # tmp1081, _144 — avg us = avg ns / 1000.0
	movq	%xmm1, %rdx	 # _144, — Arg 2: avg latency us
	call	printf	 # — Print latency per trade
 # StageC.c:452:     printf("Lag behind replay    : worst %.3f ms, at end %.3f ms\n",
	pxor	%xmm0, %xmm0	 # _145 — Clear %xmm0
	pxor	%xmm1, %xmm1	 # _147 — Clear %xmm1
	cvtsi2sdq	96(%rsp), %xmm1	 # %sfp, _147 — lag_max_ns as double
	cvtsi2sdq	%r12, %xmm0	 # lag_ns, _145 — final lag_ns as double
	divsd	%xmm9, %xmm1	 # tmp1087, _148 — worst lag ms = lag_max_ns / 1e6
	leaq	.LC53(%rip), %rcx	 #, — Format
	divsd	%xmm9, %xmm0	 # tmp1087, _145 — end lag ms = lag_ns / 1e6
	movq	%xmm1, %rdx	 # _148, — Arg 2: worst lag ms
	movq	%xmm0, %r8	 # _145, _146 — Arg 3: end lag ms
	movapd	%xmm0, %xmm2	 # _146, — Pass end lag ms in XMM
	call	printf	 # — Print lag summary
 # StageC.c:454:     printf("Rival bot (R = %.2f us): P&L %.2f USDT, races won %lld, lost %lld%s\n",
	cmpl	$0, 8+rival(%rip)	 #, rival.holding — Check if rival still holding position
	je	.L163	 #, — Empty suffix if holding == 0
 # StageC.c:454:     printf("Rival bot (R = %.2f us): P&L %.2f USDT, races won %lld, lost %lld%s\n",
	leaq	.LC7(%rip), %rdi	 #, iftmp.41_219 — " (still holding 1 BTC)"
.L126: # Print rival bot performance
 # StageC.c:454:     printf("Rival bot (R = %.2f us): P&L %.2f USDT, races won %lld, lost %lld%s\n",
	movq	144(%rsp), %rcx	 # %sfp, — Arg 1: &rival
	movq	40+rival(%rip), %rsi	 # rival.races_lost, _150 — rival.races_lost
	movq	32+rival(%rip), %rbx	 # rival.races_won, _151 — rival.races_won
	call	rival_pnl	 # — Compute rival P&L in %xmm0
 # StageC.c:454:     printf("Rival bot (R = %.2f us): P&L %.2f USDT, races won %lld, lost %lld%s\n",
	movq	rival_ns(%rip), %rax	 # rival_ns, rival_ns — rival_ns
 # StageC.c:454:     printf("Rival bot (R = %.2f us): P&L %.2f USDT, races won %lld, lost %lld%s\n",
	movq	%xmm0, %r8	 #, _152 — Arg 3: P&L
 # StageC.c:454:     printf("Rival bot (R = %.2f us): P&L %.2f USDT, races won %lld, lost %lld%s\n",
	testq	%rax, %rax	 # rival_ns — Handle high-bit unsigned
	js	.L127	 #, — High-bit conversion helper
	pxor	%xmm1, %xmm1	 # _154 — Clear %xmm1
	cvtsi2sdq	%rax, %xmm1	 # rival_ns, _154 — rival_ns as double
.L128: # Print rival bot summary line
	divsd	%xmm8, %xmm1	 # tmp1081, _155 — R in us = rival_ns / 1000.0
	movq	%rdi, 40(%rsp)	 # iftmp.41_219, — Stack arg 6: holding suffix
	movq	%r8, %xmm2	 # _152, — Pass P&L in XMM
	movq	%rbx, %r9	 # _151, — Arg 4: races_won
	movq	%rsi, 32(%rsp)	 # _150, — Stack arg 5: races_lost
	leaq	.LC54(%rip), %rcx	 #, — Format
	movq	%xmm1, %rdx	 # _155, — Arg 2: R in us
	call	printf	 # — Print rival summary
 # StageC.c:458:     printf("\n--- Memory ---\n");
	leaq	.LC55(%rip), %rcx	 #, — Memory section header
	call	puts	 # — Print header
 # StageC.c:459:     printf("malloc array (exact fit) : %.1f MB for %lld trades\n",
	movq	trade_count(%rip), %r8	 # trade_count, trade_count.43_156 — Arg 3: trade_count
	movq	%r8, %rax	 # trade_count.43_156, _159 — trade_count
	salq	$5, %rax	 #, _159 — Bytes allocated
	js	.L129	 #, — High-bit conversion helper
	pxor	%xmm1, %xmm1	 # _160 — Clear %xmm1
	cvtsi2sdq	%rax, %xmm1	 # _159, _160 — Bytes as double
.L130: # Print exact-fit and fixed-array memory lines
	mulsd	%xmm10, %xmm1	 # tmp1088, _161 — Convert bytes to MB
	leaq	.LC56(%rip), %rcx	 #, — Format
	movq	%xmm1, %rdx	 # _161, — Arg 2: MB
	call	printf	 # — Print exact-fit memory line
 # StageC.c:461:     printf("Stage B fixed array      : %.1f MB reserved (MAX_TRADES = %d)\n",
	movsd	.LC69(%rip), %xmm1	 #, — Fixed array MB constant
	movl	$10000000, %r8d	 #, — Arg 3: MAX_TRADES = 10,000,000
	movabsq	$0x407312d000000000, %rdx	 #, — Arg 2: 305.17578125 MB as raw IEEE-754 bits
	leaq	.LC57(%rip), %rcx	 #, — Format
	call	printf	 # — Print Stage B fixed array comparison
 # StageC.c:466:     FILE *log = fopen(log_path, "w");
	movq	log_path(%rip), %rcx	 # log_path, — Arg 1: log_path
	leaq	.LC58(%rip), %rdx	 #, — Arg 2: "w"
	call	fopen	 # — Open signal log CSV for writing
	movq	%rax, %rsi	 #, log — Save FILE * in %rsi
 # StageC.c:467:     if (log != NULL) {
	testq	%rax, %rax	 # log — Check if log opened
	je	.L131	 #, — Skip logging if NULL
 # StageC.c:468:         fprintf(log, "trade_index,ts_us,price_fx,side,proc_ns,latency_ns\n");
	movq	%rax, %r9	 # log, — Arg 4: stream = log
	movl	$51, %r8d	 #, — Arg 3: header length = 51 bytes
	movl	$1, %edx	 #, — Arg 2: elem size = 1
 # StageC.c:469:         for (long long s = 0; s < sig_count; s++) {
	xorl	%ebx, %ebx	 # s — Signal index s = 0
 # StageC.c:468:         fprintf(log, "trade_index,ts_us,price_fx,side,proc_ns,latency_ns\n");
	leaq	.LC59(%rip), %rcx	 #, — Arg 1: CSV header string
	call	fwrite	 # — Write CSV header to log file
 # StageC.c:469:         for (long long s = 0; s < sig_count; s++) {
	cmpq	$0, sig_count(%rip)	 #, sig_count — Check if any signals recorded
	jle	.L133	 #, — Close file if sig_count <= 0
	.p2align 4 # Loop alignment
	.p2align 3 # 8-byte alignment
.L132: # Write each SignalRecord row to CSV log
 # StageC.c:470:             long long ti = sig_log[s].trade_index;
	movq	%rbx, %rax	 # s, _535 — s
 # StageC.c:469:         for (long long s = 0; s < sig_count; s++) {
	addq	$1, %rbx	 #, s — s++
 # StageC.c:470:             long long ti = sig_log[s].trade_index;
	salq	$5, %rax	 #, _535 — s * 32 (sizeof(SignalRecord) == 32)
	addq	sig_log(%rip), %rax	 # sig_log, _166 — &sig_log[s]
 # StageC.c:470:             long long ti = sig_log[s].trade_index;
	movq	(%rax), %r8	 # _166->trade_index, ti — Arg 3: trade_index
 # StageC.c:471:             fprintf(log, "%lld,%lld,%lld,%d,%llu,%llu\n", ti, trades[ti].ts_us,
	movq	24(%rax), %rcx	 # _166->latency_ns, _166->latency_ns — Load latency_ns
 # StageC.c:472:                     trades[ti].price, sig_log[s].side, sig_log[s].proc_ns,
	movq	%r8, %rdx	 # ti, _175 — ti
	salq	$5, %rdx	 #, _175 — ti * 32
	addq	trades(%rip), %rdx	 # trades, _176 — &trades[ti]
 # StageC.c:471:             fprintf(log, "%lld,%lld,%lld,%d,%llu,%llu\n", ti, trades[ti].ts_us,
	movq	(%rdx), %r9	 # _176->ts_us, _176->ts_us — Arg 4: trades[ti].ts_us
	movq	%rcx, 56(%rsp)	 # _166->latency_ns, — Stack arg 8: latency_ns
	movq	16(%rax), %rcx	 # _166->proc_ns, _166->proc_ns — Load proc_ns
	movq	%rcx, 48(%rsp)	 # _166->proc_ns, — Stack arg 7: proc_ns
	movl	8(%rax), %eax	 # _166->side, _166->side — Load side
	movq	%rsi, %rcx	 # log, — Arg 1: log stream
	movl	%eax, 40(%rsp)	 # _166->side, — Stack arg 6: side
	movq	8(%rdx), %rax	 # _176->price, _176->price — Load trades[ti].price
	leaq	.LC61(%rip), %rdx	 #, — Arg 2: row format string
	movq	%rax, 32(%rsp)	 # _176->price, — Stack arg 5: price_fx
	call	fprintf	 # — Write formatted signal row
 # StageC.c:469:         for (long long s = 0; s < sig_count; s++) {
	cmpq	%rbx, sig_count(%rip)	 # s, sig_count — Loop while s < sig_count
	jg	.L132	 #, — Next signal record
.L133: # Close log file and print write count
 # StageC.c:475:         fclose(log);
	movq	%rsi, %rcx	 # log, — log stream
	call	fclose	 # — Close CSV log
 # StageC.c:476:         printf("\nWrote %lld signals to %s\n", sig_count, log_path);
	movq	log_path(%rip), %r8	 # log_path, — Arg 3: log_path
	movq	sig_count(%rip), %rdx	 # sig_count, — Arg 2: sig_count
	leaq	.LC60(%rip), %rcx	 #, — Format
	call	printf	 # — Print log confirmation
.L131: # Free heap allocations and return 0
 # StageC.c:479:     free(sig_log);
	movq	sig_log(%rip), %rcx	 # sig_log, — sig_log pointer
	call	free	 # — Free signal log buffer
 # StageC.c:480:     free(trades);
	movq	trades(%rip), %rcx	 # trades, — trades pointer
	call	free	 # — Free trades buffer
 # StageC.c:481:     return 0;
	xorl	%eax, %eax	 # <retval> — Return 0
	jmp	.L5	 # — Exit main
	.p2align 4,,10 # Alignment hint
	.p2align 3 # 8-byte alignment
.L243: # Coarse sleep helper when remaining > 21 ms
 # StageC.c:236:             sleep_ms((int)((remaining - SLEEP_MARGIN_NS) / 1000000ULL));
	movabsq	$4835703278458516699, %rax	 #, remaining — Magic constant for / 1,000,000
	mulq	%rdx	 # remaining — 128-bit unsigned product
	shrq	$18, %rdx	 #, _380 — Shift right by 18 -> remaining / 1,000,000 (ms)
 # timing.h:32:   static inline void sleep_ms(int ms) { Sleep((DWORD)ms); }
	leal	-20(%rdx), %ecx	 #, _381 — Subtract SLEEP_MARGIN_NS (20 ms)
	call	*__imp_Sleep(%rip)	 # — Sleep(ms - 20)
 # timing.h:32:   static inline void sleep_ms(int ms) { Sleep((DWORD)ms); }
	jmp	.L73	 # — Return to fine-grained QPC spin/poll
	.p2align 4,,10 # Alignment hint
	.p2align 3 # 8-byte alignment
.L77: # Running-sum SMA update (O(1) per trade)
 # StageC.c:205:         short_sum += p;
	movq	short_sum(%rip), %rax	 # short_sum, _455 — Load short_sum
	addq	%rdx, %rax	 # p, _455 — short_sum += p
	movq	%rax, short_sum(%rip)	 # _455, short_sum — Store updated short_sum
 # StageC.c:206:         if (i >= short_win) short_sum -= trades[i - short_win].price;
	cmpq	%rbp, %r9	 # ivtmp.204, _457 — Compare short_win with i
	jg	.L86	 #, — Skip subtraction if i < short_win
 # StageC.c:206:         if (i >= short_win) short_sum -= trades[i - short_win].price;
	movq	%rbp, %rcx	 # ivtmp.204, _458 — i
	subq	%r9, %rcx	 # _457, _458 — i - short_win
 # StageC.c:206:         if (i >= short_win) short_sum -= trades[i - short_win].price;
	salq	$5, %rcx	 #, tmp801 — Byte offset (i - short_win) * 32
 # StageC.c:206:         if (i >= short_win) short_sum -= trades[i - short_win].price;
	subq	8(%r8,%rcx), %rax	 # _461->price, _463 — short_sum -= trades[i - short_win].price
	movq	%rax, short_sum(%rip)	 # _463, short_sum — Store short_sum
.L86: # Running-sum long_sum update
 # StageC.c:208:         if (i >= long_win) long_sum -= trades[i - long_win].price;
	movslq	long_win(%rip), %rax	 # long_win, — long_win
 # StageC.c:207:         long_sum += p;
	addq	long_sum(%rip), %rdx	 # long_sum, _465 — long_sum += p
	movq	%rdx, long_sum(%rip)	 # _465, long_sum — Store updated long_sum
 # StageC.c:208:         if (i >= long_win) long_sum -= trades[i - long_win].price;
	movq	%rax, %rcx	 #, — Copy long_win
 # StageC.c:208:         if (i >= long_win) long_sum -= trades[i - long_win].price;
	cmpq	%rbp, %rax	 # ivtmp.204, _467 — Compare long_win with i
	jg	.L87	 #, — Skip subtraction if i < long_win
 # StageC.c:208:         if (i >= long_win) long_sum -= trades[i - long_win].price;
	movq	%rbp, %r10	 # ivtmp.204, _468 — i
	subq	%rax, %r10	 # _467, _468 — i - long_win
 # StageC.c:208:         if (i >= long_win) long_sum -= trades[i - long_win].price;
	salq	$5, %r10	 #, tmp807 — Byte offset (i - long_win) * 32
 # StageC.c:208:         if (i >= long_win) long_sum -= trades[i - long_win].price;
	subq	8(%r8,%r10), %rdx	 # _471->price, _473 — long_sum -= trades[i - long_win].price
	movq	%rdx, long_sum(%rip)	 # _473, long_sum — Store long_sum
.L87: # Check if enough samples for long window crossover test
 # StageC.c:212:     if (i >= long_win - 1) {
	subl	$1, %ecx	 #, _475 — long_win - 1
	movslq	%ecx, %rcx	 # _475, _476 — Sign-extend
 # StageC.c:212:     if (i >= long_win - 1) {
	cmpq	%rbp, %rcx	 # ivtmp.204, _476 — Compare long_win - 1 with i
	jg	.L88	 #, — No signal if i < long_win - 1
 # StageC.c:213:         long long d = short_sum * long_win - long_sum * short_win;
	movq	long_sum(%rip), %rcx	 # long_sum, s — Load long_sum into %rcx
	jmp	.L85	 # — Compute d and detect crossover
	.p2align 4,,10 # Alignment hint
	.p2align 3 # 8-byte alignment
.L92: # Non-zero signal handling: counts, log, rival, display
 # StageC.c:410:             if (signal == 1) buy_count++; else sell_count++;
	cmpl	$1, %r11d	 #, signal — Check if signal == 1 (BUY)
	je	.L249	 #, — Increment buy_count if BUY
 # StageC.c:410:             if (signal == 1) buy_count++; else sell_count++;
	addq	$1, sell_count(%rip)	 #, sell_count — sell_count++
.L95: # Append SignalRecord to sig_log (reallocate if full)
 # StageC.c:254:     if (sig_count == sig_cap) {
	movq	sig_count(%rip), %rbx	 # sig_count, sig_count.111_500 — Load sig_count
 # StageC.c:254:     if (sig_count == sig_cap) {
	cmpq	sig_cap(%rip), %rbx	 # sig_cap, sig_count.111_500 — Compare sig_count vs sig_cap
	je	.L250	 #, — Grow buffer if full
.L96: # Write SignalRecord fields
 # StageC.c:263:     sig_log[sig_count].trade_index = i;
	movq	%rbx, %rax	 # sig_count.111_500, _510 — Current sig_count
 # StageC.c:267:     sig_count++;
	addq	$1, %rbx	 #, tmp836 — sig_count + 1
 # StageC.c:413:             rival_on_signal(&rival, signal, trades[i].price,
	movq	rival_ns(%rip), %rdx	 # rival_ns, rival_ns.25_92 — Load rival_ns
 # StageC.c:263:     sig_log[sig_count].trade_index = i;
	salq	$5, %rax	 #, _510 — Byte offset sig_count * 32
	addq	sig_log(%rip), %rax	 # sig_log, _511 — &sig_log[sig_count]
 # StageC.c:267:     sig_count++;
	movq	%rbx, sig_count(%rip)	 # tmp836, sig_count — Update sig_count
 # StageC.c:263:     sig_log[sig_count].trade_index = i;
	movq	%rbp, (%rax)	 # ivtmp.204, _511->trade_index — Store trade_index (offset +0)
 # StageC.c:414:                             (i + 1 < trade_count) ? trades[i + 1].price : trades[i].price,
	addq	$1, %rbp	 #, ivtmp.204 — Next index i + 1
 # StageC.c:413:             rival_on_signal(&rival, signal, trades[i].price,
	cmpq	trade_count(%rip), %rbp	 # trade_count, ivtmp.204 — Check if i + 1 < trade_count
 # StageC.c:264:     sig_log[sig_count].side = side;
	movl	%r11d, 8(%rax)	 # signal, _511->side — Store side (offset +8)
 # StageC.c:265:     sig_log[sig_count].proc_ns = proc_ns;
	movq	%r14, 16(%rax)	 # proc_ns, _511->proc_ns — Store proc_ns (offset +16)
 # StageC.c:266:     sig_log[sig_count].latency_ns = latency_ns;
	movq	%r12, 24(%rax)	 # latency_ns, _511->latency_ns — Store latency_ns (offset +24)
 # StageC.c:414:                             (i + 1 < trade_count) ? trades[i + 1].price : trades[i].price,
	movq	trades(%rip), %rax	 # trades, pretmp_768 — trades base pointer
 # StageC.c:413:             rival_on_signal(&rival, signal, trades[i].price,
	movq	8(%rax,%r13), %r8	 # _769->price, pretmp_770 — Arg 3: price_now_fx = trades[i].price
	movq	%r8, %r9	 # pretmp_770, iftmp.26_218 — Default price_next_fx = trades[i].price
 # StageC.c:413:             rival_on_signal(&rival, signal, trades[i].price,
	jge	.L99	 #, — Use trades[i].price if at last trade
 # StageC.c:413:             rival_on_signal(&rival, signal, trades[i].price,
	movq	40(%rax,%r13), %r9	 # _99->price, iftmp.26_218 — Arg 4: price_next_fx = trades[i + 1].price
.L99: # Call rival_on_signal
 # StageC.c:413:             rival_on_signal(&rival, signal, trades[i].price,
	movq	%rdx, 40(%rsp)	 # rival_ns.25_92, — Stack arg 6: rival_ns
	movq	144(%rsp), %rcx	 # %sfp, — Arg 1: &rival
	movl	%r11d, %edx	 # signal, — Arg 2: side
	movq	%r14, 32(%rsp)	 # proc_ns, — Stack arg 5: reaction_ns = proc_ns
	movq	%r10, 152(%rsp)	 # _415, %sfp — Spill decided
	movl	%r11d, 104(%rsp)	 # signal, %sfp — Spill signal
	call	rival_on_signal	 # — Simulate rival race & fill
 # StageC.c:416:             if (use_colour || use_led) show_signal(signal, i, latency_ns, use_colour, use_led);
	movl	88(%rsp), %eax	 # %sfp, tmp1211 — use_colour
	orl	112(%rsp), %eax	 # %sfp, tmp1211 — use_colour | use_led
	movl	104(%rsp), %r11d	 # %sfp, signal — Restore signal
	movq	152(%rsp), %r10	 # %sfp, _415 — Restore decided
	je	.L93	 #, — Skip output if neither use_colour nor use_led
 # StageC.c:276:     if (use_colour) {
	cmpl	$0, 88(%rsp)	 #, %sfp — Check use_colour
	jne	.L101	 #, — Print ANSI coloured line if enabled
 # StageC.c:282:         if (side == 1) { led_off(LED_RED);   led_on(LED_GREEN); }
	subl	$1, %r11d	 #, signal — signal - 1 (0 -> was BUY)
	je	.L102	 #, — GREEN ON, RED OFF for BUY
.L103: # SELL LED state: GREEN OFF, RED ON
 # led.h:74:     printf("[LED %s %s]\n", led_name[led], on ? "ON" : "OFF");
	leaq	.LC38(%rip), %r8	 #, — "OFF"
	leaq	.LC42(%rip), %rdx	 #, — "GREEN"
	movq	%r10, 104(%rsp)	 # _415, %sfp — Spill decided
	leaq	.LC40(%rip), %rcx	 #, — Format
	call	printf	 # — Print [LED GREEN OFF]
	leaq	.LC41(%rip), %r8	 #, — "ON"
	leaq	.LC39(%rip), %rdx	 #, — "RED"
	leaq	.LC40(%rip), %rcx	 #, — Format
	call	printf	 # — Print [LED RED ON]
	movq	104(%rsp), %r10	 # %sfp, _415 — Restore decided
 # led.h:77: static inline void led_on(int led)  { led_set(led, 1); }
	jmp	.L93	 # — Update stats & continue loop
	.p2align 4,,10 # Alignment hint
	.p2align 3 # 8-byte alignment
.L88: # Before long_win warmup completes: signal = 0
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	movl	ready.1(%rip), %r8d	 # ready, — Check QPF ready
 # StageC.c:211:     int signal = 0;
	xorl	%r11d, %r11d	 # signal — signal = 0
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	testl	%r8d, %r8d	 # — Test ready
	jne	.L91	 #, — Read `decided` if QPF ready
.L247: # Lazy QPF init before reading `decided`
	movl	%r11d, 104(%rsp)	 # signal, %sfp — Spill signal
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	leaq	freq.0(%rip), %rcx	 #, — &freq
	call	*__imp_QueryPerformanceFrequency(%rip)	 # — QueryPerformanceFrequency
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	movl	104(%rsp), %r11d	 # %sfp, signal — Restore signal
	movl	$1, ready.1(%rip)	 #, ready — ready = 1
	jmp	.L91	 # — Read `decided`
	.p2align 4,,10 # Alignment hint
	.p2align 3 # 8-byte alignment
.L245: # Lazy QPF init before reading `before`
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	leaq	freq.0(%rip), %rcx	 #, — &freq
	call	*%r15	 # tmp1150 — QueryPerformanceFrequency
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	movl	$1, ready.1(%rip)	 #, ready — ready = 1
	jmp	.L76	 # — Read `before`
	.p2align 4,,10 # Alignment hint
	.p2align 3 # 8-byte alignment
.L69: # Unsigned >= 2^63 conversion helper for release offset
 # StageC.c:387:             release = t_start + (uint64_t)((double)gap_us * 1000.0 / speed);
	subsd	%xmm7, %xmm0	 # tmp1149, tmp739 — Subtract 2^63
	cvttsd2siq	%xmm0, %rbx	 # tmp739, _87 — Convert to int64_t
	btcq	$63, %rbx	 #, _87 — Set bit 63 for uint64_t
	jmp	.L70	 # — Add t_start
.L249: # Increment buy_count
 # StageC.c:410:             if (signal == 1) buy_count++; else sell_count++;
	addq	$1, buy_count(%rip)	 #, buy_count — buy_count++
	jmp	.L95	 # — Log signal
.L250: # Grow sig_log capacity via realloc (65536 initial, then * 2)
 # StageC.c:255:         sig_cap = sig_cap ? sig_cap * 2 : 65536;
	testq	%rbx, %rbx	 # sig_count.111_500 — Check current capacity/count
	movl	$65536, %eax	 #, tmp1107 — Initial capacity = 65536
	leaq	(%rbx,%rbx), %rdx	 #, iftmp.113_502 — Double capacity
 # StageC.c:256:         SignalRecord *bigger = realloc(sig_log, (size_t)sig_cap * sizeof(SignalRecord));
	movq	sig_log(%rip), %rcx	 # sig_log, — Current sig_log pointer
 # StageC.c:255:         sig_cap = sig_cap ? sig_cap * 2 : 65536;
	cmove	%rax, %rdx	 # iftmp.113_502,, tmp1107, iftmp.113_503 — Pick 65536 if 0, else 2*sig_cap
	movl	%r11d, 152(%rsp)	 # signal, %sfp — Spill signal
	movq	%r10, 104(%rsp)	 # _415, %sfp — Spill decided
 # StageC.c:255:         sig_cap = sig_cap ? sig_cap * 2 : 65536;
	movq	%rdx, sig_cap(%rip)	 # iftmp.113_503, sig_cap — Store new sig_cap
 # StageC.c:256:         SignalRecord *bigger = realloc(sig_log, (size_t)sig_cap * sizeof(SignalRecord));
	salq	$5, %rdx	 #, _506 — New byte size = sig_cap * 32
	call	realloc	 # — Reallocate signal log array
	movq	104(%rsp), %r10	 # %sfp, _415 — Restore decided
	movl	152(%rsp), %r11d	 # %sfp, signal — Restore signal
 # StageC.c:257:         if (!bigger) { fprintf(stderr, "Out of memory for the signal log\n"); return; }
	testq	%rax, %rax	 # bigger — Check realloc failure
	je	.L251	 #, — Print OOM error on NULL
 # StageC.c:258:         sig_log = bigger;
	movq	%rax, sig_log(%rip)	 # bigger, sig_log — Update sig_log pointer
	jmp	.L96	 # — Write signal record
.L101: # Print ANSI-coloured signal line
 # StageC.c:277:         const char *name = (side == 1) ? "BUY"  : "SELL";
	cmpl	$1, %r11d	 #, signal — Check if BUY (1)
	leaq	.LC67(%rip), %rax	 #, tmp1346 — "SELL"
	leaq	.LC63(%rip), %r8	 #, iftmp.36_220 — "BUY"
 # StageC.c:278:         const char *col  = (side == 1) ? "\033[32m" : "\033[31m";
	leaq	.LC68(%rip), %rdx	 #, tmp1347 — Red "\033[31m"
	leaq	.LC64(%rip), %rcx	 #, iftmp.37_221 — Green "\033[32m"
 # StageC.c:277:         const char *name = (side == 1) ? "BUY"  : "SELL";
	cmovne	%rax, %r8	 # iftmp.36_220,, tmp1346, iftmp.36_220 — Select "SELL" if != 1
 # StageC.c:278:         const char *col  = (side == 1) ? "\033[32m" : "\033[31m";
	cmovne	%rdx, %rcx	 # iftmp.37_221,, tmp1347, iftmp.37_221 — Select red if != 1
 # StageC.c:279:         printf("%s%-4s trade %-8lld price %.2f  latency %.2f us%s\n",
	pxor	%xmm0, %xmm0	 # _527 — Clear %xmm0
	pxor	%xmm1, %xmm1	 # _525 — Clear %xmm1
 # StageC.c:280:                col, name, idx, price_fx / (double)SCALE_P, latency_ns / 1000.0, "\033[0m");
	movq	trades(%rip), %rax	 # trades, trades — trades base
 # StageC.c:279:         printf("%s%-4s trade %-8lld price %.2f  latency %.2f us%s\n",
	cvtsi2sdq	%r12, %xmm0	 # latency_ns, _527 — latency_ns as double
 # StageC.c:280:                col, name, idx, price_fx / (double)SCALE_P, latency_ns / 1000.0, "\033[0m");
	cvtsi2sdq	-24(%rax,%r13), %xmm1	 # _524->price, _525 — price_fx as double
 # StageC.c:279:         printf("%s%-4s trade %-8lld price %.2f  latency %.2f us%s\n",
	divsd	%xmm8, %xmm0	 # tmp1081, _527 — latency_ns / 1000.0 -> us
 # StageC.c:280:                col, name, idx, price_fx / (double)SCALE_P, latency_ns / 1000.0, "\033[0m");
	divsd	.LC37(%rip), %xmm1	 #, _525 — price_fx / SCALE_P
 # StageC.c:279:         printf("%s%-4s trade %-8lld price %.2f  latency %.2f us%s\n",
	leaq	.LC66(%rip), %rax	 #, tmp1096 — Reset "\033[0m"
	movq	%xmm1, %r9	 # _525, _525 — Arg 5: price
	movq	%xmm0, 40(%rsp)	 # _527, _527 — Stack arg 6: latency us
	movq	%rax, 48(%rsp)	 # tmp1096, — Stack arg 7: reset escape
	leaq	-1(%rbp), %rax	 #, _523 — Current trade index i
	movq	%r9, %xmm2	 # _525, — Pass price in XMM
	movq	%rax, 32(%rsp)	 # _523, — Stack arg 4: trade index
	leaq	.LC65(%rip), %rax	 #, tmp1097 — Signal format string
	movq	%rax, (%rsp)	 # tmp1097, — Stack arg 1 (note: Win64 stack layout around %rsp)
	movq	%r10, 104(%rsp)	 # _415, %sfp — Spill decided
	call	printf	 # — Print signal line
	movq	104(%rsp), %r10	 # %sfp, _415 — Restore decided
 # StageC.c:281:     } else if (use_led) {
	cmpl	$0, 112(%rsp)	 #, %sfp — Check if use_led also active
	je	.L93	 #, — Done if LED not active
 # StageC.c:282:         if (side == 1) { led_off(LED_RED);   led_on(LED_GREEN); }
	cmpl	$1, %r11d	 #, signal — Check if BUY
	jne	.L103	 #, — Set SELL LEDs if not BUY
.L102: # BUY LED state: RED OFF, GREEN ON
 # led.h:74:     printf("[LED %s %s]\n", led_name[led], on ? "ON" : "OFF");
	leaq	.LC38(%rip), %r8	 #, — "OFF"
	leaq	.LC39(%rip), %rdx	 #, — "RED"
	movq	%r10, 104(%rsp)	 # _415, %sfp — Spill decided
	leaq	.LC40(%rip), %rcx	 #, — Format
	call	printf	 # — Print [LED RED OFF]
	leaq	.LC41(%rip), %r8	 #, — "ON"
	leaq	.LC42(%rip), %rdx	 #, — "GREEN"
	leaq	.LC40(%rip), %rcx	 #, — Format
	call	printf	 # — Print [LED GREEN ON]
	movq	104(%rsp), %r10	 # %sfp, _415 — Restore decided
 # led.h:77: static inline void led_on(int led)  { led_set(led, 1); }
	jmp	.L93	 # — Update stats & continue loop
.L246: # Bullish crossover check: prev_d <= 0 && d > 0
 # StageC.c:215:             if (prev_d <= 0 && d > 0) signal = 1;
	xorl	%r11d, %r11d	 # signal — Default signal = 0
	testq	%rax, %rax	 # d — Test d
	setg	%r11b	 #, signal — %r11b = 1 if d > 0, else 0
 # StageC.c:216:             else if (prev_d >= 0 && d < 0) signal = -1;
	testq	%rdx, %rdx	 # prev_d.109_486 — Check if prev_d == 0
	jne	.L89	 #, — If prev_d < 0, cannot have prev_d >= 0
	jmp	.L90	 # — If prev_d == 0, check d < 0 for SELL (-1)
.L244: # Lazy QPF init for unpaced release timestamp
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	leaq	freq.0(%rip), %rcx	 #, — &freq
	call	*%r15	 # tmp1150 — QueryPerformanceFrequency
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	movl	$1, ready.1(%rip)	 #, ready — ready = 1
	jmp	.L75	 # — Read now_ns()
.L134: # Turn both LEDs OFF at end of replay
 # led.h:74:     printf("[LED %s %s]\n", led_name[led], on ? "ON" : "OFF");
	leaq	.LC38(%rip), %r8	 #, — "OFF"
	leaq	.LC42(%rip), %rdx	 #, — "GREEN"
	leaq	.LC40(%rip), %rcx	 #, — Format
	call	printf	 # — Print [LED GREEN OFF]
	leaq	.LC38(%rip), %r8	 #, — "OFF"
	leaq	.LC39(%rip), %rdx	 #, — "RED"
	leaq	.LC40(%rip), %rcx	 #, — Format
	call	printf	 # — Print [LED RED OFF]
 # led.h:78: static inline void led_off(int led) { led_set(led, 0); }
	jmp	.L111	 # — Proceed to clear status line
.L248: # Clear progress bar line with spaces + '\r'
 # StageC.c:435:     if (!quiet) printf("\r%79s\r", "");
	leaq	.LC8(%rip), %r8	 #, — ""
	movl	$79, %edx	 #, — Field width 79
	leaq	.LC44(%rip), %rcx	 #, — Format
	call	printf	 # — Overwrite status line
	jmp	.L112	 # — Compute final metrics
.L242: # Print LED simulation notice
 # StageC.c:368:     if (use_led) led_init();
	leaq	.LC35(%rip), %rcx	 #, — Simulated LED notice string
	call	puts	 # — Print notice
 # StageC.c:369:     rival_init(&rival);
	leaq	rival(%rip), %rax	 #, tmp1085 — &rival
	movq	%rax, %rcx	 # tmp1085, — Arg 1: &rival
	movq	%rax, 144(%rsp)	 # tmp1085, %sfp — Spill &rival
	call	rival_init	 # — Initialize rival state
 # StageC.c:376:     long long ts0 = trades[0].ts_us;
	movq	trades(%rip), %rax	 # trades, trades — trades base
	movq	(%rax), %rax	 # trades.20_522->ts_us, ts0 — ts0 = trades[0].ts_us
	movq	%rax, 168(%rsp)	 # ts0, %sfp — Spill ts0
 # StageC.c:378:     uint64_t t_start = now_ns();
	call	now_ns	 # — Read t_start
	movq	%rax, 160(%rsp)	 # t_start, %sfp — Spill t_start
 # StageC.c:381:     for (long long i = 0; i < replay_n; i++) {
	cmpq	$0, 64(%rsp)	 #, %sfp — Check replay_n > 0
	jne	.L223	 #, — Enter replay loop if > 0
.L135: # Zero-trade replay fallback
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	movl	ready.1(%rip), %eax	 # ready, — Check QPF ready
 # StageC.c:372:     unsigned long long lat_sum = 0, lat_max = 0;
	xorl	%r12d, %r12d	 # lag_ns — lag_ns = 0
	movq	%r12, 96(%rsp)	 #, %sfp — lag_max_ns = 0
	movq	%r12, 80(%rsp)	 #, %sfp — proc_max = 0
	movq	%r12, 128(%rsp)	 #, %sfp — proc_sum = 0
	movq	%r12, 72(%rsp)	 #, %sfp — lat_max = 0
	movq	%r12, 120(%rsp)	 #, %sfp — lat_sum = 0
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	testl	%eax, %eax	 # — Test ready
	je	.L252	 #, — Query QPF if needed
.L136: # Read t_end when replay_n == 0
 # timing.h:26:       QueryPerformanceCounter(&count);
	leaq	200(%rsp), %rcx	 #, tmp1084 — &count
	call	*__imp_QueryPerformanceCounter(%rip)	 # — QueryPerformanceCounter
 # timing.h:28:       uint64_t f = (uint64_t)freq.QuadPart, c = (uint64_t)count.QuadPart;
	movq	freq.0(%rip), %r8	 # freq.QuadPart, f — f
	movq	200(%rsp), %rax	 # MEM[(union _LARGE_INTEGER *)_743].QuadPart, MEM[(union _LARGE_INTEGER *)_743].QuadPart — c
	xorl	%edx, %edx	 # tmp1006 — Clear high dividend
	divq	%r8	 # f — c / f and c % f
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	imulq	$1000000000, %rax, %rcx	 #, MEM[(union _LARGE_INTEGER *)_743].QuadPart, _552 — (c / f) * 1e9
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	imulq	$1000000000, %rdx, %rax	 #, tmp1006, _554 — (c % f) * 1e9
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	xorl	%edx, %edx	 # tmp1011 — Clear high dividend
	divq	%r8	 # f — ((c % f) * 1e9) / f
 # timing.h:29:       return (c / f) * 1000000000ULL + (c % f) * 1000000000ULL / f;
	leaq	(%rax,%rcx), %rbx	 #, t_end — t_end in %rbx
 # StageC.c:430:     if (use_led) {
	cmpl	$0, 112(%rsp)	 #, %sfp — Check use_led
	je	.L111	 #, — Skip LED turn-off if off
	jmp	.L134	 # — Turn LEDs off
.L156: # Naive short_win <= 0 case
	xorl	%ecx, %ecx	 # s — s = 0
	jmp	.L79	 # — Store short_sum = 0
.L157: # Naive long_win <= 0 case
	xorl	%ecx, %ecx	 # s — s = 0
	jmp	.L83	 # — Store long_sum = 0
.L163: # Rival not holding position
	leaq	.LC8(%rip), %rdi	 #, iftmp.41_219 — ""
	jmp	.L126	 # — Print rival summary
.L144: # Default options when argc <= 1
 # StageC.c:290:     double speed = 1000.0;
	movsd	.LC1(%rip), %xmm6	 #, speed — speed = 1000.0
 # StageC.c:292:     int use_colour = 0, use_led = 0, quiet = 0;
	movl	$0, 116(%rsp)	 #, %sfp — quiet = 0
 # StageC.c:289:     const char *path = STRESS_PATH;
	leaq	.LC2(%rip), %rbx	 #, path — Default stress_full.csv
 # StageC.c:292:     int use_colour = 0, use_led = 0, quiet = 0;
	movl	$0, 112(%rsp)	 #, %sfp — use_led = 0
 # StageC.c:291:     double max_minutes = 0.0;       /* 0 = whole file */
	pxor	%xmm7, %xmm7	 # max_minutes — max_minutes = 0.0
 # StageC.c:292:     int use_colour = 0, use_led = 0, quiet = 0;
	movl	$0, 88(%rsp)	 #, %sfp — use_colour = 0
	movapd	%xmm6, %xmm8	 # speed, tmp1081 — Save 1000.0 in %xmm8
	jmp	.L6	 # — Proceed to console setup
.L52: # Unsigned >= 2^63 conversion helper for load time ns
	movq	%rax, %rdx	 # _48, tmp1023 — Copy delta
	shrq	%rax	 #, tmp1024 — Shift right by 1
	andl	$1, %edx	 #, tmp1023 — Low bit
	orq	%rax, %rdx	 # tmp1024, tmp1023 — Safe magnitude
	pxor	%xmm3, %xmm3	 # _49 — Clear %xmm3
	cvtsi2sdq	%rdx, %xmm3	 # tmp1023, _49 — Convert to double
	addsd	%xmm3, %xmm3	 # _49, _49 — Double to restore scale
	jmp	.L53	 # — Divide by 1e9
.L61: # Unsigned >= 2^63 conversion helper for malloc bytes
	movq	%rax, %rdx	 # _74, tmp1026 — Copy byte size
	shrq	%rax	 #, tmp1027 — Shift right by 1
	andl	$1, %edx	 #, tmp1026 — Low bit
	orq	%rax, %rdx	 # tmp1027, tmp1026 — Safe magnitude
	pxor	%xmm2, %xmm2	 # _75 — Clear %xmm2
	cvtsi2sdq	%rdx, %xmm2	 # tmp1026, _75 — Convert to double
	addsd	%xmm2, %xmm2	 # _75, _75 — Restore scale
	jmp	.L62	 # — Convert to MB
.L113: # Unsigned >= 2^63 conversion helper for wall_s ns
	movq	%rbx, %rax	 # _124, tmp1029 — Copy delta
	shrq	%rbx	 #, tmp1030 — Shift right by 1
	andl	$1, %eax	 #, tmp1029 — Low bit
	orq	%rbx, %rax	 # tmp1030, tmp1029 — Safe magnitude
	pxor	%xmm7, %xmm7	 # _125 — Clear %xmm7
	cvtsi2sdq	%rax, %xmm7	 # tmp1029, _125 — Convert to double
	addsd	%xmm7, %xmm7	 # _125, _125 — Restore scale
	jmp	.L114	 # — Divide by 1e9
.L118: # Unsigned >= 2^63 conversion helper for proc_max
	movq	%rax, %rdx	 # proc_max, tmp1032 — Copy proc_max
	shrq	%rax	 #, tmp1033 — Shift right by 1
	andl	$1, %edx	 #, tmp1032 — Low bit
	orq	%rax, %rdx	 # tmp1033, tmp1032 — Safe magnitude
	pxor	%xmm2, %xmm2	 # _134 — Clear %xmm2
	cvtsi2sdq	%rdx, %xmm2	 # tmp1032, _134 — Convert to double
	addsd	%xmm2, %xmm2	 # _134, _134 — Restore scale
	jmp	.L119	 # — Convert to us
.L120: # Unsigned >= 2^63 conversion helper for proc_sum
	movq	%rax, %rdx	 # proc_sum, tmp1035 — Copy proc_sum
	shrq	%rax	 #, tmp1036 — Shift right by 1
	andl	$1, %edx	 #, tmp1035 — Low bit
	orq	%rax, %rdx	 # tmp1036, tmp1035 — Safe magnitude
	pxor	%xmm1, %xmm1	 # _136 — Clear %xmm1
	cvtsi2sdq	%rdx, %xmm1	 # tmp1035, _136 — Convert to double
	addsd	%xmm1, %xmm1	 # _136, _136 — Restore scale
	jmp	.L121	 # — Compute average ns
.L122: # Unsigned >= 2^63 conversion helper for lat_max
	movq	%rax, %rdx	 # lat_max, tmp1038 — Copy lat_max
	shrq	%rax	 #, tmp1039 — Shift right by 1
	andl	$1, %edx	 #, tmp1038 — Low bit
	orq	%rax, %rdx	 # tmp1039, tmp1038 — Safe magnitude
	pxor	%xmm2, %xmm2	 # _139 — Clear %xmm2
	cvtsi2sdq	%rdx, %xmm2	 # tmp1038, _139 — Convert to double
	addsd	%xmm2, %xmm2	 # _139, _139 — Restore scale
	jmp	.L123	 # — Convert to us
.L124: # Unsigned >= 2^63 conversion helper for lat_sum
	movq	%rax, %rdx	 # lat_sum, tmp1041 — Copy lat_sum
	shrq	%rax	 #, tmp1042 — Shift right by 1
	andl	$1, %edx	 #, tmp1041 — Low bit
	orq	%rax, %rdx	 # tmp1042, tmp1041 — Safe magnitude
	pxor	%xmm1, %xmm1	 # _141 — Clear %xmm1
	cvtsi2sdq	%rdx, %xmm1	 # tmp1041, _141 — Convert to double
	addsd	%xmm1, %xmm1	 # _141, _141 — Restore scale
	jmp	.L125	 # — Compute average latency
.L127: # Unsigned >= 2^63 conversion helper for rival_ns
	movq	%rax, %rdx	 # rival_ns, tmp1044 — Copy rival_ns
	shrq	%rax	 #, tmp1045 — Shift right by 1
	andl	$1, %edx	 #, tmp1044 — Low bit
	orq	%rax, %rdx	 # tmp1045, tmp1044 — Safe magnitude
	pxor	%xmm1, %xmm1	 # _154 — Clear %xmm1
	cvtsi2sdq	%rdx, %xmm1	 # tmp1044, _154 — Convert to double
	addsd	%xmm1, %xmm1	 # _154, _154 — Restore scale
	jmp	.L128	 # — Convert to us
.L129: # Unsigned >= 2^63 conversion helper for exact-fit bytes
	movq	%rax, %rdx	 # _159, tmp1047 — Copy byte size
	shrq	%rax	 #, tmp1048 — Shift right by 1
	andl	$1, %edx	 #, tmp1047 — Low bit
	orq	%rax, %rdx	 # tmp1048, tmp1047 — Safe magnitude
	pxor	%xmm1, %xmm1	 # _160 — Clear %xmm1
	cvtsi2sdq	%rdx, %xmm1	 # tmp1047, _160 — Convert to double
	addsd	%xmm1, %xmm1	 # _160, _160 — Restore scale
	jmp	.L130	 # — Convert to MB
.L141: # Unsigned >= 2^63 conversion helper for unpaced malloc bytes
	movq	%rax, %rdx	 # _734, tmp1050 — Copy byte size
	shrq	%rax	 #, tmp1051 — Shift right by 1
	andl	$1, %edx	 #, tmp1050 — Low bit
	orq	%rax, %rdx	 # tmp1051, tmp1050 — Safe magnitude
	pxor	%xmm2, %xmm2	 # _62 — Clear %xmm2
	cvtsi2sdq	%rdx, %xmm2	 # tmp1050, _62 — Convert to double
	addsd	%xmm2, %xmm2	 # _62, _62 — Restore scale
	jmp	.L142	 # — Convert to MB
.L235: # Unknown dataset argument error
 # StageC.c:306:                 printf("Unknown file '%s' (use test, dev or stress)\n", argv[a]);
	movq	%rbx, %rdx	 # _10, — Arg 2: unknown file string
	leaq	.LC12(%rip), %rcx	 #, — Format
	call	printf	 # — Print error message
 # StageC.c:307:                 return 1;
	jmp	.L11	 # — Return 1
.L231: # Invalid speed (< 0.0) error
 # StageC.c:311:             if (speed < 0.0) { printf("Speed must be >= 0\n"); return 1; }
	leaq	.LC13(%rip), %rcx	 #, — Error message
.L225: # Print message and return 1 helper
	call	puts	 # — Print string with newline
 # StageC.c:326:             if (r_us <= 0.0) { printf("Rival time must be > 0\n"); return 1; }
	jmp	.L11	 # — Return 1
.L228: # Invalid rival time (<= 0.0) error
 # StageC.c:326:             if (r_us <= 0.0) { printf("Rival time must be > 0\n"); return 1; }
	leaq	.LC15(%rip), %rcx	 #, — Error message
	jmp	.L225	 # — Print and return 1
.L233: # File open failure in count_lines
 # StageC.c:113:     if (fp == NULL) return -1;
	orq	$-1, %r14	 #, lines — lines = -1 (error sentinel)
	jmp	.L47	 # — Handle error
.L240: # malloc failure in load_trades
 # StageC.c:139:         printf("malloc of %lld trades failed\n", lines);
	movq	%r14, %rdx	 # lines, — Arg 2: lines
	leaq	.LC22(%rip), %rcx	 #, — Format
	call	printf	 # — Print malloc failure
.L37: # Return -1 from load_trades
 # StageC.c:140:         return -1;
	orq	$-1, %r14	 #, lines — lines = -1
	jmp	.L47	 # — Handle error
.L251: # sig_log realloc out-of-memory error
 # StageC.c:257:         if (!bigger) { fprintf(stderr, "Out of memory for the signal log\n"); return; }
	movl	$2, %ecx	 #, — stderr selector for __acrt_iob_func
	call	*__imp___acrt_iob_func(%rip)	 # — Get stderr FILE*
	movq	%rax, %r9	 # _508, — Arg 4: stderr
	movl	$33, %r8d	 #, — Arg 3: message byte length = 33
	movl	$1, %edx	 #, — Arg 2: elem size = 1
	leaq	.LC36(%rip), %rcx	 #, — Arg 1: OOM message
	call	fwrite	 # — Write error to stderr
	jmp	.L131	 # — Clean up and exit
.L252: # Lazy QPF init on zero-trade path
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	leaq	freq.0(%rip), %rcx	 #, — &freq
	call	*__imp_QueryPerformanceFrequency(%rip)	 # — QueryPerformanceFrequency
 # timing.h:25:       if (!ready) { QueryPerformanceFrequency(&freq); ready = 1; }
	movl	$1, ready.1(%rip)	 #, ready — ready = 1
	jmp	.L136	 # — Read t_end
	.seh_endproc # End SEH metadata for main
	.globl	short_win # Global int short_win
	.data # Initialized data section
	.align 4 # 4-byte alignment
short_win: # Default short SMA window = 50
	.long	50
	.globl	long_win # Global int long_win
	.align 4 # 4-byte alignment
long_win: # Default long SMA window = 200
	.long	200
	.globl	naive_mode # Global int naive_mode
	.align 4 # 4-byte alignment
naive_mode: # Default naive_mode = 0 (running-sum)
	.long	0
	.globl	rival_ns # Global uint64_t rival_ns
	.align 8 # 8-byte alignment
rival_ns: # Default rival reaction time = 2000 ns (2.0 us)
	.long	2000 # Low 32 bits of 2000
	.long	0 # High 32 bits of 2000
	.globl	log_path # Global const char *log_path
	.align 8 # 8-byte alignment
log_path: # Default output CSV log path
	.quad	.LC67_path_fallback # Points to default log filename string below
.LC67_path_fallback:
	.ascii "signals_stage_c.csv\0"
	.globl	trades # Global Trade *trades
	.bss # Uninitialized data section (.bss)
	.align 8 # 8-byte alignment
trades: # Pointer to dynamically allocated Trade array
	.space 8
	.globl	trade_count # Global long long trade_count
	.align 8 # 8-byte alignment
trade_count: # Total loaded trades count
	.space 8
	.globl	total_pq # Global long long total_pq
	.align 8 # 8-byte alignment
total_pq: # Cumulative price * qty accumulator
	.space 8
	.globl	total_q # Global long long total_q
	.align 8 # 8-byte alignment
total_q: # Cumulative qty accumulator
	.space 8
	.globl	short_sum # Global long long short_sum
	.align 8 # 8-byte alignment
short_sum: # Short-window price sum
	.space 8
	.globl	long_sum # Global long long long_sum
	.align 8 # 8-byte alignment
long_sum: # Long-window price sum
	.space 8
	.globl	prev_d # Global long long prev_d
	.align 8 # 8-byte alignment
prev_d: # Previous SMA spread d
	.space 8
	.globl	have_prev # Global int have_prev
	.align 4 # 4-byte alignment
have_prev: # Non-zero once prev_d is initialized
	.space 4
	.globl	buy_count # Global long long buy_count
	.align 8 # 8-byte alignment
buy_count: # Total BUY signals emitted
	.space 8
	.globl	sell_count # Global long long sell_count
	.align 8 # 8-byte alignment
sell_count: # Total SELL signals emitted
	.space 8
	.globl	sig_log # Global SignalRecord *sig_log
	.align 8 # 8-byte alignment
sig_log: # Pointer to dynamically grown signal log array
	.space 8
	.globl	sig_count # Global long long sig_count
	.align 8 # 8-byte alignment
sig_count: # Number of logged signals
	.space 8
	.globl	sig_cap # Global long long sig_cap
	.align 8 # 8-byte alignment
sig_cap: # Allocated capacity of sig_log
	.space 8
	.globl	rival # Global RivalBot rival
	.align 32 # 32-byte alignment
rival: # RivalBot struct instance (48 bytes)
	.space 48
.lcomm	freq.0,8,8 # Static LARGE_INTEGER freq in now_ns()
.lcomm	ready.1,4,4 # Static int ready flag in now_ns()
.lcomm	buf.2,1048576,32 # Static 1 MiB file-read buffer buf in count_lines()
	.section .rdata,"dr" # Read-only floating-point constants
	.align 8 # 8-byte alignment
.LC1: # Double 1000.0
	.long	0
	.long	1083129856
	.align 8 # 8-byte alignment
.LC16: # Double 0.5
	.long	0
	.long	1071644672
	.align 8 # 8-byte alignment
.LC17: # Double 2^63 (9223372036854775808.0)
	.long	0
	.long	1138753536
	.align 8 # 8-byte alignment
.LC25: # Double 1e9 (1,000,000,000.0)
	.long	0
	.long	1104006501
	.align 8 # 8-byte alignment
.LC26: # Double 60.0
	.long	0
	.long	1078853632
	.align 8 # 8-byte alignment
.LC27: # Double 1e6 (1,000,000.0)
	.long	0
	.long	1093567616
	.align 8 # 8-byte alignment
.LC30: # Double 1.0 / 1048576.0
	.long	0
	.long	1040187392
	.align 8 # 8-byte alignment
.LC37: # Double 100.0 (SCALE_P)
	.long	0
	.long	1079574528
	.align 8 # 8-byte alignment
.LC69: # Double 305.17578125 (10,000,000 * 32 / 1048576)
	.long	0
	.long	1081283280
	.ident	"GCC: (Rev8, Built by MSYS2 project) 15.2.0" # Compiler version string
	.def	strcmp;	.scl	2;	.type	32;	.endef # External declaration: strcmp
	.def	atof;	.scl	2;	.type	32;	.endef # External declaration: atof
	.def	printf;	.scl	2;	.type	32;	.endef # External declaration: printf
	.def	fopen;	.scl	2;	.type	32;	.endef # External declaration: fopen
	.def	fread;	.scl	2;	.type	32;	.endef # External declaration: fread
	.def	fclose;	.scl	2;	.type	32;	.endef # External declaration: fclose
	.def	malloc;	.scl	2;	.type	32;	.endef # External declaration: malloc
	.def	puts;	.scl	2;	.type	32;	.endef # External declaration: puts
	.def	fflush;	.scl	2;	.type	32;	.endef # External declaration: fflush
	.def	putchar;	.scl	2;	.type	32;	.endef # External declaration: putchar
	.def	fwrite;	.scl	2;	.type	32;	.endef # External declaration: fwrite
	.def	fprintf;	.scl	2;	.type	32;	.endef # External declaration: fprintf
	.def	free;	.scl	2;	.type	32;	.endef # External declaration: free
	.def	realloc;	.scl	2;	.type	32;	.endef # External declaration: realloc
```[cite: 3]