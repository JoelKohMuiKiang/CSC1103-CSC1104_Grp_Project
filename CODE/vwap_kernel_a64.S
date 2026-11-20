// vwap_kernel_a64.S - hand-written AArch64 kernel for the VWAP sums (stretch goal), Group 21
//
//   void vwap_sums_a64(const Trade *t, long long n, long long *out_pq, long long *out_q);
//
// Computes   *out_pq = sum of (price * qty)   and   *out_q = sum of qty   over n trades.
// Trade is the 32-byte Stage B struct:  ts_us @0, price @8, qty @16, is_buy @24.
//
// AAPCS64 arguments:  x0 = t,  x1 = n,  x2 = out_pq,  x3 = out_q
//
// Design (why it can differ from what gcc -O3 produces):
//   * ldp loads price and qty (adjacent 8-byte fields) with ONE instruction.
//   * madd does multiply and accumulate in ONE instruction.
//   * 4 trades per loop pass, with 4 independent price*qty accumulators, so the
//     multiply-add chains do not wait for each other (hides the madd latency).
//   * NEON is not used on purpose: AArch64 NEON has no 64-bit x 64-bit -> 64-bit
//     vector multiply, so the scalar madd is the right tool for these operands.
//
// Registers: x4-x7 = pq accumulators, x8 = q accumulator, x9 = loop counter,
//            x10-x17 = loaded price/qty values (caller-saved, so nothing to save).

        .text
        .p2align 4
        .global vwap_sums_a64
        .type   vwap_sums_a64, %function
vwap_sums_a64:
        mov     x4, #0                  // pq accumulator 0
        mov     x5, #0                  // pq accumulator 1
        mov     x6, #0                  // pq accumulator 2
        mov     x7, #0                  // pq accumulator 3
        mov     x8, #0                  // q accumulator
        lsr     x9, x1, #2              // x9 = n / 4 = number of 4-trade blocks
        cbz     x9, .Ltail              // fewer than 4 trades: skip the main loop

.Lloop4:
        ldp     x10, x11, [x0, #8]      // trade 0: price, qty
        ldp     x12, x13, [x0, #40]     // trade 1: price, qty
        ldp     x14, x15, [x0, #72]     // trade 2: price, qty
        ldp     x16, x17, [x0, #104]    // trade 3: price, qty
        madd    x4, x10, x11, x4        // acc0 += price0 * qty0
        madd    x5, x12, x13, x5        // acc1 += price1 * qty1
        madd    x6, x14, x15, x6        // acc2 += price2 * qty2
        madd    x7, x16, x17, x7        // acc3 += price3 * qty3
        add     x11, x11, x13           // qty0 + qty1
        add     x15, x15, x17           // qty2 + qty3
        add     x11, x11, x15           // qty of all four trades
        add     x8, x8, x11             // q total += that
        add     x0, x0, #128            // advance 4 trades (4 * 32 bytes)
        subs    x9, x9, #1              // one block done
        b.ne    .Lloop4

.Ltail:
        and     x9, x1, #3              // 0..3 trades left over
        cbz     x9, .Ldone
.Lloop1:
        ldp     x10, x11, [x0, #8]      // price, qty
        madd    x4, x10, x11, x4        // acc0 += price * qty
        add     x8, x8, x11             // q total += qty
        add     x0, x0, #32             // next trade
        subs    x9, x9, #1
        b.ne    .Lloop1

.Ldone:
        add     x4, x4, x5              // combine the four pq accumulators
        add     x6, x6, x7
        add     x4, x4, x6
        str     x4, [x2]                // *out_pq
        str     x8, [x3]                // *out_q
        ret
        .size   vwap_sums_a64, .-vwap_sums_a64

        .section .note.GNU-stack,"",%progbits
