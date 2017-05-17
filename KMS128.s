.align 4

.globl kmul128_func
.globl _kmul128_func

.globl ksqr128_func
.globl _ksqr128_func

kmul128_func:
_kmul128_func:
    //result : x0
    //operand: x1, x2
    //x19-x30 callee-saved

    //start
    ldp x4, x5, [x2]
    ldp x2, x3, [x1]
    mov x1, #0          //zero


    mul x6, x2, x4      //A[0] * B[0]
    umulh x7, x2, x4    //A[0] * B[0]   H

    mul x8, x3, x5      //A[1] * B[1]
    umulh x9, x3, x5    //A[1] * B[1]   H

    adds x10, x6, x8
    adcs x11, x7, x9
    adcs x12, x1, x1

    adds x7, x7, x10
    adcs x8, x8, x11
    adcs x9, x9, x12


    subs x2, x2, x3
    sbcs x3, x3, x3

    eor x2, x2, x3
    and x3, x3, #1
    add x2, x2, x3


    subs x4, x4, x5
    sbcs x5, x5, x5

    eor x4, x4, x5
    and x5, x5, #1
    add x4, x4, x5



    eor x3, x3, x5
    sub x3, x3, #1
    //add x9, x9, x3
    //asr

    mul x10, x2, x4      //A[1] * B[1]
    umulh x11, x2, x4    //A[1] * B[1]   H

    eor x10, x10, x3
    eor x11, x11, x3

    and x4, x3, #1
    adds x10, x10, x4
    adcs x11, x11, x1//zero
    adcs x3,  x3, x1    //carry important for sign

    adds x7, x7, x10
    adcs x8, x8, x11
    adcs x9, x9, x3

    //save the result
    stp x6, x7, [x0,#0]
    stp x8, x9, [x0,#16]

    //stp x10, x11, [x0,#32]

ret

ksqr128_func:
_ksqr128_func:
    //result : x0
    //operand: x1
    //x19-x30 callee-saved

    //start
    ldp x3, x4, [x1]
    mov x5, #0          //zero

    mul x6, x3, x3      //A[0] * B[0]
    umulh x7, x3, x3    //A[0] * B[0]   H

    mul x8, x4, x4      //A[1] * B[1]
    umulh x9, x4, x4    //A[1] * B[1]   H

    subs x3, x3, x4
    sbcs x4, x4, x4

    eor x3, x3, x4
    and x4, x4, #1

    adds x3, x3, x4

    mul x10, x3, x3      //A[1] * B[1]
    umulh x11, x3, x3    //A[1] * B[1]   H

    adds x12, x6, x8
    adcs x13, x7, x9
    adcs x9, x9, x5

    adds x7, x7, x12
    adcs x8, x8, x13
    adcs x9, x9, x5

    subs x7, x7, x10
    sbcs x8, x8, x11
    sbcs x9, x9, x5

    //save the result
    stp x6, x7 , [x0,#0]
    stp x8, x9, [x0,#16]

ret


