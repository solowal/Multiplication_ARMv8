.align 4

.globl kmul256_func
.globl _kmul256_func

.globl ksqr256_func
.globl _ksqr256_func

kmul256_func:
_kmul256_func:
    //result : x0
    //operand: x1, x2
    //x19-x30 callee-saved
    sub sp, sp, #48

    stp x19, x20, [sp,#0]
    stp x21, x22, [sp,#16]
    stp x23, x24, [sp,#32]
    //stp x25, x26, [sp,#48]
    //stp x27, x28, [sp,#64]
    //stp x29, x30, [sp,#80]

    //start
    ldp x6, x7, [x2]
    ldp x8, x9, [x2,#16]

    ldp x2, x3, [x1]
    ldp x4, x5, [x1,#16]
    mov x1, #0          //zero

    //L * L     x10-x13
    mul x10, x2, x6     //A[0] * B[0]
    mul x11, x2, x7     //A[0] * B[1]

    umulh x13, x2, x6   //A[0] * B[0]   H
    umulh x12, x2, x7   //A[0] * B[1]   H

    adds x11, x11, x13
    adcs x12, x12, x1

    mul x14, x3, x6      //A[1] * B[0]
    mul x13, x3, x7      //A[1] * B[1]

    adds x11, x11, x14
    adcs x12, x12, x13
    adcs x13, x1, x1

    umulh x14, x3, x6   //A[1] * B[0]   H
    umulh x15, x3, x7   //A[1] * B[1]   H

    adds x12, x12, x14
    adcs x13, x13, x15

    //H * H x14 - x17
    mul x14, x4, x8     //A[0] * B[0]
    mul x15, x4, x9     //A[0] * B[1]

    umulh x17, x4, x8   //A[0] * B[0]   H
    umulh x16, x4, x9   //A[0] * B[1]   H

    adds x15, x15, x17
    adcs x16, x16, x1

    mul x18, x5, x8      //A[1] * B[0]
    mul x17, x5, x9      //A[1] * B[1]

    adds x15, x15, x18
    adcs x16, x16, x17
    adcs x17, x1, x1

    umulh x18, x5, x8   //A[1] * B[0]   H
    umulh x19, x5, x9   //A[1] * B[1]   H

    adds x16, x16, x18
    adcs x17, x17, x19

    //x 10 - 13
    //x 14 - 17

    adds x18, x10, x14
    adcs x19, x11, x15
    adcs x20, x12, x16
    adcs x21, x13, x17
    adcs x24, x1, x1

    adds x12, x12, x18
    adcs x13, x13, x19
    adcs x14, x14, x20
    adcs x15, x15, x21
    adcs x24, x24, x1


    // M * M
    // 2 3 4 5
    // 6 7 8 9
    subs x4, x2, x4
    sbcs x5, x3, x5
    sbcs x2, x2, x2

    eor x4, x4, x2
    eor x5, x5, x2

    and x2, x2, #1
    adds x4, x4, x2
    adcs x5, x5, x1

    subs x8, x6, x8
    sbcs x9, x7, x9
    sbcs x6, x6, x6

    eor x8, x8, x6
    eor x9, x9, x6

    and x6, x6, #1
    adds x8, x8, x6
    adcs x9, x9, x1

    eor x2, x2, x6
    sub x2, x2, #1
    add x24, x24, x2
    //asr x3, x24, #5



//M * M x18 - x21
    mul x18, x4, x8     //A[0] * B[0]
    mul x19, x4, x9     //A[0] * B[1]

    umulh x21, x4, x8   //A[0] * B[0]   H
    umulh x20, x4, x9   //A[0] * B[1]   H

    adds x19, x19, x21
    adcs x20, x20, x1

    mul x22, x5, x8      //A[1] * B[0]
    mul x21, x5, x9      //A[1] * B[1]

    adds x19, x19, x22
    adcs x20, x20, x21
    adcs x21, x1, x1

    umulh x22, x5, x8   //A[1] * B[0]   H
    umulh x23, x5, x9   //A[1] * B[1]   H

    adds x20, x20, x22
    adcs x21, x21, x23

    eor x18, x18, x2
    eor x19, x19, x2
    eor x20, x20, x2
    eor x21, x21, x2

    //and x2, x2, #1
    adds x2, x2, x2

    adcs x12, x12, x18
    adcs x13, x13, x19
    adcs x14, x14, x20
    adcs x15, x15, x21
    adcs x24, x24, x1

    asr x3, x24, #5
    adds x16, x16, x24
    adcs x17, x17, x3


stp x10, x11 , [x0,#0]
    stp x12, x13, [x0,#16]
    stp x14, x15, [x0,#32]
    stp x16, x17, [x0,#48]

//stack
    ldp x19, x20, [sp,#0]
    ldp x21, x22, [sp,#16]
    ldp x23, x24, [sp,#32]
    //ldp x25, x26, [sp,#48]
    //ldp x27, x28, [sp,#64]
    //ldp x29, x30, [sp,#80]

    add sp, sp, #48





ret

ksqr256_func:
_ksqr256_func:
    //result : x0
    //operand: x1
    //x19-x28 callee-saved

    //start
    ldp x3, x4, [x1]
    ldp x5, x6, [x1,#16]
    mov x7, #0          //zero

    //L * L     x8-x11
    mul x9, x3, x4      //A[0] * B[1]
    umulh x10, x3, x4   //A[0] * B[1]   H

    mul x8, x3, x3      //A[0] * B[0]
    umulh x11, x4, x4   //A[1] * B[1]   H

    adds x9, x9, x9
    adcs x10, x10, x10
    adcs x11, x11, x7    //zero


    umulh x12, x3, x3   //A[0] * B[0] H
    mul x13, x4, x4     //A[1] * B[1]

    adds x9, x9, x12
    adcs x10, x10, x13
    adcs x11, x11, x7   //zero

    //H * H     x12-x15
    mul x13, x5, x6      //A[2] * B[3]
    umulh x14, x5, x6   //A[2] * B[3]   H

    mul x12, x5, x5      //A[2] * B[2]
    umulh x15, x6, x6   //A[3] * B[3]   H

    adds x13, x13, x13
    adcs x14, x14, x14
    adcs x15, x15, x7    //zero


    umulh x16, x5, x5   //A[2] * B[2] H
    mul x17, x6, x6     //A[3] * B[3]

    adds x13, x13, x16
    adcs x14, x14, x17
    adcs x15, x15, x7   //zero


    //M * M
    subs x5, x3, x5
    sbcs x6, x4, x6
    sbcs x3, x3, x3

    eor x5, x5, x3
    eor x6, x6, x3

    and x3, x3, #1
    adds x5, x5, x3
    adcs x6, x6, x7     //zero

    mul x2, x5, x6      //A[2] * B[3]
    umulh x3, x5, x6   //A[2] * B[3]   H

    mul x1, x5, x5      //A[2] * B[2]
    umulh x4, x6, x6   //A[3] * B[3]   H

    adds x2, x2, x2
    adcs x3, x3, x3
    adcs x4, x4, x7    //zero


    umulh x16, x5, x5   //A[2] * B[2] H
    mul x17, x6, x6     //A[3] * B[3]

    adds x2, x2, x16
    adcs x3, x3, x17
    adcs x4, x4, x7   //zero


    //x8-x11
    //x12-x15
    //x1-x4

    //5 6 16 17 18
    adds x5, x8, x12
    adcs x6, x9, x13
    adcs x16, x10, x14
    adcs x17, x11, x15
    adcs x18, x7, x7

    adds x10, x10, x5
    adcs x11, x11, x6
    adcs x12, x12, x16
    adcs x13, x13, x17
    adcs x18, x18, x7

    subs x10, x10, x1
    sbcs x11, x11, x2
    sbcs x12, x12, x3
    sbcs x13, x13, x4
    sbcs x18, x18, x7

    adds x14, x14, x18
    adcs x15, x15, x7

    //save the result
    stp x8, x9 , [x0,#0]
    stp x10, x11, [x0,#16]
    stp x12, x13, [x0,#32]
    stp x14, x15, [x0,#48]

ret


