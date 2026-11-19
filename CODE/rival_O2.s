	.file	"rival.c"
 # GNU C23 (Rev8, Built by MSYS2 project) version 15.2.0 (x86_64-w64-mingw32)
 #	compiled by GNU C version 15.2.0, GMP version 6.3.0, MPFR version 4.2.2, MPC version 1.3.1, isl version isl-0.27-GMP

 # GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
 # options passed: -mtune=generic -march=nocona -O2
	.text
	.p2align 4
	.globl	rival_init
	.def	rival_init;	.scl	2;	.type	32;	.endef
	.seh_proc	rival_init
rival_init:
	.seh_endprologue
 # rival.c:8:     r->buys = r->sells = 0;
	pxor	%xmm0, %xmm0	 # tmp99
 # rival.c:6:     r->pnl_fx = 0;
	movq	$0, (%rcx)	 #, r_2(D)->pnl_fx
 # rival.c:7:     r->holding = 0;
	movl	$0, 8(%rcx)	 #, r_2(D)->holding
 # rival.c:8:     r->buys = r->sells = 0;
	movups	%xmm0, 16(%rcx)	 # tmp99, MEM <vector(2) long long int> [(long long int *)r_2(D) + 16B]
	movups	%xmm0, 32(%rcx)	 # tmp99, MEM <vector(2) long long int> [(long long int *)r_2(D) + 32B]
 # rival.c:10: }
	ret	
	.seh_endproc
	.p2align 4
	.globl	rival_on_signal
	.def	rival_on_signal;	.scl	2;	.type	32;	.endef
	.seh_proc	rival_on_signal
rival_on_signal:
	.seh_endprologue
 # rival.c:18:     if (side == 1 && r->holding) return;
	cmpl	$1, %edx	 #, side
	je	.L15	 #,
 # rival.c:19:     if (side == -1 && !r->holding) return;
	cmpl	$-1, %edx	 #, side
	je	.L7	 #,
 # rival.c:23:     long long fill = we_win ? price_now_fx : price_next_fx;
	movq	48(%rsp), %rax	 # rival_ns, tmp127
	cmpq	%rax, 40(%rsp)	 # tmp127, reaction_ns
	jb	.L16	 #,
.L8:
 # rival.c:25:     if (we_win) r->races_won++; else r->races_lost++;
	addq	$1, 40(%rcx)	 #, r_20(D)->races_lost
 # rival.c:23:     long long fill = we_win ? price_now_fx : price_next_fx;
	movq	%r9, %r8	 # price_next_fx, price_now_fx
.L9:
 # rival.c:32:         r->pnl_fx += fill;
	addq	%r8, (%rcx)	 # price_now_fx, r_20(D)->pnl_fx
 # rival.c:34:         r->sells++;
	addq	$1, 24(%rcx)	 #, r_20(D)->sells
 # rival.c:33:         r->holding = 0;
	movl	$0, 8(%rcx)	 #, r_20(D)->holding
.L3:
 # rival.c:36: }
	ret	
	.p2align 4,,10
	.p2align 3
.L7:
 # rival.c:19:     if (side == -1 && !r->holding) return;
	movl	8(%rcx), %eax	 # r_20(D)->holding,
	testl	%eax, %eax	 #
	je	.L3	 #,
 # rival.c:23:     long long fill = we_win ? price_now_fx : price_next_fx;
	movq	48(%rsp), %rax	 # rival_ns, tmp127
	cmpq	%rax, 40(%rsp)	 # tmp127, reaction_ns
	jnb	.L8	 #,
.L16:
 # rival.c:25:     if (we_win) r->races_won++; else r->races_lost++;
	addq	$1, 32(%rcx)	 #, r_20(D)->races_won
	jmp	.L9	 #
	.p2align 4,,10
	.p2align 3
.L15:
 # rival.c:18:     if (side == 1 && r->holding) return;
	movl	8(%rcx), %edx	 # r_20(D)->holding,
	testl	%edx, %edx	 #
	jne	.L3	 #,
 # rival.c:23:     long long fill = we_win ? price_now_fx : price_next_fx;
	movq	48(%rsp), %rax	 # rival_ns, tmp128
	cmpq	%rax, 40(%rsp)	 # tmp128, reaction_ns
	jb	.L17	 #,
 # rival.c:25:     if (we_win) r->races_won++; else r->races_lost++;
	addq	$1, 40(%rcx)	 #, r_20(D)->races_lost
 # rival.c:23:     long long fill = we_win ? price_now_fx : price_next_fx;
	movq	%r9, %r8	 # price_next_fx, price_now_fx
.L12:
 # rival.c:28:         r->pnl_fx -= fill;
	subq	%r8, (%rcx)	 # price_now_fx, r_20(D)->pnl_fx
 # rival.c:30:         r->buys++;
	addq	$1, 16(%rcx)	 #, r_20(D)->buys
 # rival.c:29:         r->holding = 1;
	movl	$1, 8(%rcx)	 #, r_20(D)->holding
 # rival.c:36: }
	ret	
	.p2align 4,,10
	.p2align 3
.L17:
 # rival.c:25:     if (we_win) r->races_won++; else r->races_lost++;
	addq	$1, 32(%rcx)	 #, r_20(D)->races_won
	jmp	.L12	 #
	.seh_endproc
	.p2align 4
	.globl	rival_pnl
	.def	rival_pnl;	.scl	2;	.type	32;	.endef
	.seh_proc	rival_pnl
rival_pnl:
	.seh_endprologue
 # rival.c:40:     return (double)r->pnl_fx / (double)RIVAL_PRICE_SCALE;
	pxor	%xmm0, %xmm0	 # _2
	cvtsi2sdq	(%rcx), %xmm0	 # r_4(D)->pnl_fx, _2
 # rival.c:40:     return (double)r->pnl_fx / (double)RIVAL_PRICE_SCALE;
	divsd	.LC0(%rip), %xmm0	 #, _5
 # rival.c:41: }
	ret	
	.seh_endproc
	.section .rdata,"dr"
	.align 8
.LC0:
	.long	0
	.long	1079574528
	.ident	"GCC: (Rev8, Built by MSYS2 project) 15.2.0"
