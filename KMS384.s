.align 4

.globl kmul384_func
.globl _kmul384_func

.globl ksqr384_func
.globl _ksqr384_func

kmul384_func:
_kmul384_func:
    //result : x0
    //operand: x1, x2
    //x19-x28 callee-saved
    sub sp, sp, #96

    stp x19, x20, [sp,#0]
    stp x21, x22, [sp,#16]
    stp x23, x24, [sp,#32]
    stp x25, x26, [sp,#48]
    stp x27, x28, [sp,#64]
    stp x29, x30, [sp,#80]
    
    //start
    ldp x8, x9, [x2]
    ldp x10, x11, [x2,#16]
    ldp x12, x13, [x2,#32]

    ldp x2, x3, [x1]
    ldp x4, x5, [x1,#16]
    ldp x6, x7, [x1,#32]

    mov x1, #0          //zero

    // L * L x14-x19
    mul x14, x2, x8      //A[0] * B[0]
    mul x15, x2, x9      //A[0] * B[1]
    mul x16, x2, x10     //A[0] * B[2]

    //
    umulh x18, x2, x8    //A[0] * B[0]   H
    umulh x19, x2, x9    //A[0] * B[1]   H
    umulh x17, x2, x10   //A[0] * B[2]   H

    adds x15, x15, x18
    adcs x16, x16, x19
    adcs x17, x17, x1   //zero

    //
    mul x18, x3, x8     //A[1] * B[0]
    mul x19, x3, x9     //A[1] * B[1]
    mul x20, x3, x10    //A[1] * B[2]

    adds x15, x15, x18
    adcs x16, x16, x19
    adcs x17, x17, x20
    adcs x18, x1, x1    //zero

    //
    umulh x19, x3, x8    //A[1] * B[0]   H
    umulh x20, x3, x9    //A[1] * B[1]   H
    umulh x21, x3, x10   //A[1] * B[2]   H

    adds x16, x16, x19
    adcs x17, x17, x20
    adcs x18, x18, x21

    //
    mul x19, x4, x8     //A[2] * B[0]
    mul x20, x4, x9     //A[2] * B[1]
    mul x21, x4, x10    //A[2] * B[2]

    adds x16, x16, x19
    adcs x17, x17, x20
    adcs x18, x18, x21
    adcs x19, x1, x1    //zero

    //
    umulh x20, x4, x8    //A[2] * B[0]   H
    umulh x21, x4, x9    //A[2] * B[1]   H
    umulh x22, x4, x10   //A[2] * B[2]   H

    adds x17, x17, x20
    adcs x18, x18, x21
    adcs x19, x19, x22

    //H*H x20-x25
    mul x20, x5, x11      //A[0] * B[0]
    mul x21, x5, x12     //A[0] * B[1]
    mul x22, x5, x13     //A[0] * B[2]

    //
    umulh x24, x5, x11   //A[0] * B[0]   H
    umulh x25, x5, x12   //A[0] * B[1]   H
    umulh x23, x5, x13   //A[0] * B[2]   H

    adds x21, x21, x24
    adcs x22, x22, x25
    adcs x23, x23, x1   //zero

    //
    mul x24, x6, x11     //A[1] * B[0]
    mul x25, x6, x12    //A[1] * B[1]
    mul x26, x6, x13    //A[1] * B[2]

    adds x21, x21, x24
    adcs x22, x22, x25
    adcs x23, x23, x26
    adcs x24, x1, x1    //zero

    //
    umulh x25, x6, x11    //A[1] * B[0]   H
    umulh x26, x6, x12   //A[1] * B[1]   H
    umulh x27, x6, x13   //A[1] * B[2]   H

    adds x22, x22, x25
    adcs x23, x23, x26
    adcs x24, x24, x27

    //
    mul x25, x7, x11     //A[2] * B[0]
    mul x26, x7, x12    //A[2] * B[1]
    mul x27, x7, x13    //A[2] * B[2]

    adds x22, x22, x25
    adcs x23, x23, x26
    adcs x24, x24, x27
    adcs x25, x1, x1    //zero

    //
    umulh x26, x7, x11   //A[2] * B[0]   H
    umulh x27, x7, x12   //A[2] * B[1]   H
    umulh x28, x7, x13   //A[2] * B[2]   H

    adds x23, x23, x26
    adcs x24, x24, x27
    adcs x25, x25, x28


    //
    subs x5, x2, x5
    sbcs x6, x3, x6
    sbcs x7, x4, x7
    sbcs x2, x2, x2

    eor x5, x5, x2
    eor x6, x6, x2
    eor x7, x7, x2

    and x2, x2, #1
    adds x5, x5, x2
    adcs x6, x6, x1
    adcs x7, x7, x1

    subs x11, x8, x11
    sbcs x12, x9, x12
    sbcs x13, x10, x13
    sbcs x8, x8, x8

    eor x11, x11, x8
    eor x12, x12, x8
    eor x13, x13, x8

    and x8, x8, #1
    adds x11, x11, x8
    adcs x12, x12, x1
    adcs x13, x13, x1

    eor x2, x2, x8

    //3 4 8 9 10
    // L * L x14-x19
    // H * H x20-x25

    adds x3, x14, x20
    adcs x4, x15, x21
    adcs x8, x16, x22
    adcs x9, x17, x23
    adcs x10, x18, x24
    adcs x26, x19, x25
    adcs x30, x1, x1

    adds x17, x17, x3
    adcs x18, x18, x4
    adcs x19, x19, x8
    adcs x20, x20, x9
    adcs x21, x21, x10
    adcs x22, x22, x26
    adcs x30, x30, x1

    // M * M    3 4 8 9 10 26 27 28 29

    mul x3, x5, x11      //A[0] * B[0]
    mul x4, x5, x12     //A[0] * B[1]
    mul x8, x5, x13     //A[0] * B[2]

    //
    umulh x28, x5, x11   //A[0] * B[0]   H
    umulh x29, x5, x12   //A[0] * B[1]   H
    umulh x9, x5, x13   //A[0] * B[2]   H

    adds x4, x4, x28
    adcs x8, x8, x29
    adcs x9, x9, x1   //zero

    //
    mul x27, x6, x11     //A[1] * B[0]
    mul x28, x6, x12    //A[1] * B[1]
    mul x29, x6, x13    //A[1] * B[2]

    adds x4, x4, x27
    adcs x8, x8, x28
    adcs x9, x9, x29
    adcs x10, x1, x1    //zero

    //
    umulh x27, x6, x11    //A[1] * B[0]   H
    umulh x28, x6, x12   //A[1] * B[1]   H
    umulh x29, x6, x13   //A[1] * B[2]   H

    adds x8, x8, x27
    adcs x9, x9, x28
    adcs x10, x10, x29

    //3 4 8 9 10 26 27 28 29
    //
    mul x27, x7, x11     //A[2] * B[0]
    mul x28, x7, x12    //A[2] * B[1]
    mul x29, x7, x13    //A[2] * B[2]

    adds x8, x8, x27
    adcs x9, x9, x28
    adcs x10, x10, x29
    adcs x26, x1, x1    //zero

    //
    umulh x27, x7, x11   //A[2] * B[0]   H
    umulh x28, x7, x12   //A[2] * B[1]   H
    umulh x29, x7, x13   //A[2] * B[2]   H

    adds x9, x9, x27
    adcs x10, x10, x28
    adcs x26, x26, x29


    // L * L x14-x19
    // H * H x20-x25
    
    //3 4 8 9 10 26
    sub x2, x2, #1
    add x30, x30, x2
    //asr x29, x30, #5

    eor x3, x3, x2
    eor x4, x4, x2
    eor x8, x8, x2
    eor x9, x9, x2
    eor x10, x10, x2
    eor x26, x26, x2

    //and x2, x2, #1
    //optimized
    adds x2, x2, x2
    adcs x17, x17, x3
    adcs x18, x18, x4
    adcs x19, x19, x8

    adcs x20, x20, x9
    adcs x21, x21, x10
    adcs x22, x22, x26
    adcs x30, x30, x1

asr x29, x30, #5
    adds x23, x23, x30
    adcs x24, x24, x29
    adcs x25, x25, x29


    stp x14, x15 , [x0,#0]
    stp x16, x17, [x0,#16]
    stp x18, x19, [x0,#32]
    stp x20, x21, [x0,#48]
    stp x22, x23, [x0,#64]
    stp x24, x25, [x0,#80]

    //save the result
    //stp x8, x9, [x0,#0]
    //stp x10, x11, [x0,#16]

    //stack
    ldp x19, x20, [sp,#0]
    ldp x21, x22, [sp,#16]
    ldp x23, x24, [sp,#32]
    ldp x25, x26, [sp,#48]
    ldp x27, x28, [sp,#64]
    ldp x29, x30, [sp,#80]

    add sp, sp, #96

ret

ksqr384_func:
_ksqr384_func:
    //result : x0
    //operand: x1
    //x19-x28 callee-saved
    sub sp, sp, #96

    stp x19, x20, [sp,#0]
    stp x21, x22, [sp,#16]
    stp x23, x24, [sp,#32]
    stp x25, x26, [sp,#48]
    stp x27, x28, [sp,#64]
    stp x29, x30, [sp,#80]

    //start
    ldp x2, x3, [x1]
    ldp x4, x5, [x1,#16]
    ldp x6, x7, [x1,#32]
    mov x1, #0          //zero

    //L * L     x8-x11
    mul x9, x2, x3     //A[0] * A[1]
    mul x10, x2, x4     //A[0] * A[2]
    mul x11, x3, x4     //A[1] * A[2]

    umulh x13, x2, x3   //A[0] * B[1]   H
    umulh x14, x2, x4   //A[0] * B[2]   H
    umulh x12, x3, x4   //A[1] * B[2]   H

    adds x10, x10, x13
    adcs x11, x11, x14
    adcs x12, x12, x1


    mul x8, x2, x2      //A[0] * A[0]
    umulh x13, x4, x4   //A[2] * B[2]   H

    adds x9, x9, x9
    adcs x10, x10, x10
    adcs x11, x11, x11
    adcs x12, x12, x12
    adcs x13, x13, x1

    umulh x14, x2, x2   //A[0] * B[0]   H
    mul x15, x3, x3     //A[1] * A[1]
    umulh x16, x3, x3   //A[1] * B[1]   H
    mul x17, x4, x4     //A[2] * A[2]

    adds x9, x9, x14
    adcs x10, x10, x15
    adcs x11, x11, x16
    adcs x12, x12, x17
    adcs x13, x13, x1

    //x8-x13
    //save the result
    //stp x8, x9 , [x0,#0]
    //stp x10, x11, [x0,#16]
    //stp x12, x13, [x0,#32]

    // H * H
    mul x15, x5, x6     //A[0] * A[1]
    mul x16, x5, x7     //A[0] * A[2]
    mul x17, x6, x7     //A[1] * A[2]

    umulh x19, x5, x6   //A[0] * B[1]   H
    umulh x20, x5, x7   //A[0] * B[2]   H
    umulh x18, x6, x7   //A[1] * B[2]   H

    adds x16, x16, x19
    adcs x17, x17, x20
    adcs x18, x18, x1


    mul x14, x5, x5     //A[0] * A[0]
    umulh x19, x7, x7   //A[2] * B[2]   H

    adds x15, x15, x15
    adcs x16, x16, x16
    adcs x17, x17, x17
    adcs x18, x18, x18
    adcs x19, x19, x1

    umulh x20, x5, x5   //A[0] * B[0]   H
    mul x21, x6, x6     //A[1] * A[1]
    umulh x22, x6, x6   //A[1] * B[1]   H
    mul x23, x7, x7     //A[2] * A[2]

    adds x15, x15, x20
    adcs x16, x16, x21
    adcs x17, x17, x22
    adcs x18, x18, x23
    adcs x19, x19, x1

    /*
    stp x14, x15 , [x0,#0]
    stp x16, x17, [x0,#16]
    stp x18, x19, [x0,#32]
    */

    //x8  - x13
    //x14 - x19

    adds x20, x8, x14
    adcs x21, x9, x15
    adcs x22, x10, x16
    adcs x23, x11, x17
    adcs x24, x12, x18
    adcs x25, x13, x19
    adcs x30, x1, x1    //zero

    adds x11, x11, x20
    adcs x12, x12, x21
    adcs x13, x13, x22

    adcs x14, x14, x23
    adcs x15, x15, x24
    adcs x16, x16, x25
    adcs x30, x30, x1   //zero

    // last part

    subs x5, x2, x5
    sbcs x6, x3, x6
    sbcs x7, x4, x7
    sbcs x2, x2, x2

    eor x5, x5, x2
    eor x6, x6, x2
    eor x7, x7, x2

    and x2, x2, #1
    adds x5, x5, x2
    adcs x6, x6, x1
    adcs x7, x7, x1


    // M * M
    mul x21, x5, x6     //A[0] * A[1]
    mul x22, x5, x7     //A[0] * A[2]
    mul x23, x6, x7     //A[1] * A[2]

    umulh x25, x5, x6   //A[0] * B[1]   H
    umulh x26, x5, x7   //A[0] * B[2]   H
    umulh x24, x6, x7   //A[1] * B[2]   H

    adds x22, x22, x25
    adcs x23, x23, x26
    adcs x24, x24, x1


    mul x20, x5, x5     //A[0] * A[0]
    umulh x26, x7, x7   //A[2] * B[2]   H

    adds x21, x21, x21
    adcs x22, x22, x22
    adcs x23, x23, x23
    adcs x24, x24, x24
    adcs x25, x25, x1

    umulh x26, x5, x5   //A[0] * B[0]   H
    mul x27, x6, x6     //A[1] * A[1]
    umulh x28, x6, x6   //A[1] * B[1]   H
    mul x29, x7, x7     //A[2] * A[2]

    adds x21, x21, x26
    adcs x22, x22, x27
    adcs x23, x23, x28
    adcs x24, x24, x29
    adcs x25, x25, x1


    //x8  - x13
    //x14 - x19
    //x20 - x25
    subs x11, x11, x20
    sbcs x12, x12, x21
    sbcs x13, x13, x22

    sbcs x14, x14, x23
    sbcs x15, x15, x24
    sbcs x16, x16, x25
    sbcs x30, x30, x1

    adds x17, x17, x30
    adcs x18, x18, x1
    adcs x19, x19, x1

    stp x8, x9 , [x0,#0]
    stp x10, x11, [x0,#16]
    stp x12, x13, [x0,#32]
    stp x14, x15, [x0,#48]
    stp x16, x17, [x0,#64]
    stp x18, x19, [x0,#80]

    //stack
    ldp x19, x20, [sp,#0]
    ldp x21, x22, [sp,#16]
    ldp x23, x24, [sp,#32]
    ldp x25, x26, [sp,#48]
    ldp x27, x28, [sp,#64]
    ldp x29, x30, [sp,#80]

    add sp, sp, #96



    //stp x14, x15, [x0,#48]

ret


