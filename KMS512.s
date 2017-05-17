.align 4

.globl kmul512_func
.globl _kmul512_func

.globl ksqr512_func
.globl _ksqr512_func


/*
.macro test_macro x2
    adds \x2, \x2, \x2
.endm
*/
                 //OP1           //OP2              //result                                //TEMP                   //zero
.macro kmul256_macro x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x1
    mul \x10, \x2, \x6     //A[0] * B[0]
    mul \x11, \x2, \x7     //A[0] * B[1]

    umulh \x13, \x2, \x6   //A[0] * B[0]   H
    umulh \x12, \x2, \x7   //A[0] * B[1]   H

    adds \x11, \x11, \x13
    adcs \x12, \x12, \x1

    mul \x14, \x3, \x6      //A[1] * B[0]
    mul \x13, \x3, \x7      //A[1] * B[1]

    adds \x11, \x11, \x14
    adcs \x12, \x12, \x13
    adcs \x13, \x1, \x1

    umulh \x14, \x3, \x6   //A[1] * B[0]   H
    umulh \x15, \x3, \x7   //A[1] * B[1]   H

    adds \x12, \x12, \x14
    adcs \x13, \x13, \x15

    //H * H x14 - x17
    mul \x14, \x4, \x8     //A[0] * B[0]
    mul \x15, \x4, \x9     //A[0] * B[1]

    umulh \x17, \x4, \x8   //A[0] * B[0]   H
    umulh \x16, \x4, \x9   //A[0] * B[1]   H

    adds \x15, \x15, \x17
    adcs \x16, \x16, \x1

    mul \x18, \x5, \x8      //A[1] * B[0]
    mul \x17, \x5, \x9      //A[1] * B[1]

    adds \x15, \x15, \x18
    adcs \x16, \x16, \x17
    adcs \x17, \x1, \x1

    umulh \x18, \x5, \x8   //A[1] * B[0]   H
    umulh \x19, \x5, \x9   //A[1] * B[1]   H

    adds \x16, \x16, \x18
    adcs \x17, \x17, \x19

    //x 10 - 13
    //x 14 - 17

    adds \x18, \x10, \x14
    adcs \x19, \x11, \x15
    adcs \x20, \x12, \x16
    adcs \x21, \x13, \x17
    adcs \x24, \x1, \x1

    adds \x12, \x12, \x18
    adcs \x13, \x13, \x19
    adcs \x14, \x14, \x20
    adcs \x15, \x15, \x21
    adcs \x24, \x24, \x1


    // M * M
    // 2 3 4 5
    // 6 7 8 9
    subs \x4, \x25, \x4
    sbcs \x5, \x3, \x5
    sbcs \x25, \x25, \x25

    eor \x4, \x4, \x25
    eor \x5, \x5, \x25

    and \x25, \x25, #1
    adds \x4, \x4, \x25
    adcs \x5, \x5, \x1

    subs \x8, \x6, \x8
    sbcs \x9, \x7, \x9
    sbcs \x26, \x26, \x26

    eor \x8, \x8, \x26
    eor \x9, \x9, \x26

    and \x26, \x26, #1
    adds \x8, \x8, \x26
    adcs \x9, \x9, \x1

    eor \x25, \x25, \x26
    sub \x25, \x25, #1
    add \x24, \x24, \x25


//M * M x18 - x21
    mul \x18, \x4, \x8     //A[0] * B[0]
    mul \x19, \x4, \x9     //A[0] * B[1]

    umulh \x21, \x4, \x8   //A[0] * B[0]   H
    umulh \x20, \x4, \x9   //A[0] * B[1]   H

    adds \x19, \x19, \x21
    adcs \x20, \x20, \x1

    mul \x22, \x5, \x8      //A[1] * B[0]
    mul \x21, \x5, \x9      //A[1] * B[1]

    adds \x19, \x19, \x22
    adcs \x20, \x20, \x21
    adcs \x21, \x1, \x1

    umulh \x22, \x5, \x8   //A[1] * B[0]   H
    umulh \x23, \x5, \x9   //A[1] * B[1]   H

    adds \x20, \x20, \x22
    adcs \x21, \x21, \x23

    eor \x18, \x18, \x25
    eor \x19, \x19, \x25
    eor \x20, \x20, \x25
    eor \x21, \x21, \x25

    //and x2, x2, #1
    adds \x25, \x25, \x25

    adcs \x12, \x12, \x18
    adcs \x13, \x13, \x19
    adcs \x14, \x14, \x20
    adcs \x15, \x15, \x21
    adcs \x24, \x24, \x1

    asr \x26, \x24, #5
    adds \x16, \x16, \x24
    adcs \x17, \x17, \x26

.endm



kmul512_func:
_kmul512_func:
    //result : x0
    //operand: x1, x2
    //x19-x28 callee-saved
    sub sp, sp, #112

    stp x19, x20, [sp,#0]
    stp x21, x22, [sp,#16]
    stp x23, x24, [sp,#32]
    stp x25, x26, [sp,#48]
    stp x27, x28, [sp,#64]
    stp x29, x30, [sp,#80]

    stp x1, x2, [sp,#96]

    //start
    ldp x10, x11, [x2]
    ldp x12, x13, [x2,#16]
    //ldp x14, x15, [x2,#32]
    //ldp x16, x17, [x2,#48]

    ldp x2, x3, [x1]
    ldp x4, x5, [x1,#16]
    ldp x6, x7, [x1,#32]
    ldp x8, x9, [x1,#48]

    mov x1, #0          //zero

    // TOP:: L * L  2 3 4 5 / 10 11 12 13


                    //OP1           //OP2              //result                                //TEMP                      //zero
//.macro kmul256_macro x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x1

    kmul256_macro x2, x3, x4, x5,      x10, x11, x12, x13,     x14, x15, x16, x17, x18, x19, x20, x21,      x22, x23, x24, x25, x26, x27, x28, x29, x30, x1

    stp x14, x15, [x0,#0]
    stp x16, x17, [x0,#16]
    stp x18, x19, [x0,#32]
    stp x20, x21, [x0,#48]

    // TOP:: H * H  6 7 8 9 / 14 15 16 17
    ldp x2, x3, [sp,#96]
//    mov x1, #0          //zero
    ldp x14, x15, [x3,#32]
    ldp x16, x17, [x3,#48]
    kmul256_macro x6, x7, x8, x9,      x14, x15, x16, x17,     x10, x11, x12, x13, x18, x19, x20, x21,      x22, x23, x24, x25, x26, x27, x28, x29, x30, x1

    stp x10, x11, [x0,#64]
    stp x12, x13, [x0,#80]
    stp x18, x19, [x0,#96]
    stp x20, x21, [x0,#112]

    // TOP:: M * M
    ldp x1, x2, [sp,#96]

    ldp x10, x11, [x2]
    ldp x12, x13, [x2,#16]
    ldp x14, x15, [x2,#32]
    ldp x16, x17, [x2,#48]

    ldp x2, x3, [x1]
    ldp x4, x5, [x1,#16]
    ldp x6, x7, [x1,#32]
    ldp x8, x9, [x1,#48]

    mov x1, #0          //zero

    subs x2, x2, x6
    sbcs x3, x3, x7
    sbcs x4, x4, x8
    sbcs x5, x5, x9
    sbcs x6, x6, x6

    eor x2, x2, x6
    eor x3, x3, x6
    eor x4, x4, x6
    eor x5, x5, x6

    and x6, x6, #1
    adds x2, x2, x6
    adcs x3, x3, x1
    adcs x4, x4, x1
    adcs x5, x5, x1

    subs x10, x10, x14
    sbcs x11, x11, x15
    sbcs x12, x12, x16
    sbcs x13, x13, x17
    sbcs x14, x14, x14

    eor x10, x10, x14
    eor x11, x11, x14
    eor x12, x12, x14
    eor x13, x13, x14

    and x14, x14, #1
    adds x10, x10, x14
    adcs x11, x11, x1
    adcs x12, x12, x1
    adcs x13, x13, x1

    eor x6, x6, x14
    sub x6, x6, #1



kmul256_macro x2, x3, x4, x5,      x10, x11, x12, x13,     x14, x15, x16, x17, x18, x19, x20, x21,      x22, x23, x24, x25, x26, x27, x28, x29, x30, x1



    //14 15 16 17   18 19 20 21
    eor x14, x14, x6
    eor x15, x15, x6
    eor x16, x16, x6
    eor x17, x17, x6

    eor x18, x18, x6
    eor x19, x19, x6
    eor x20, x20, x6
    eor x21, x21, x6

    adds x7, x6, x6
    adcs x14, x14, x1
    adcs x15, x15, x1
    adcs x16, x16, x1
    adcs x17, x17, x1

    adcs x18, x18, x1
    adcs x19, x19, x1
    adcs x20, x20, x1
    adcs x21, x21, x1
    adcs x6, x6, x1

    ldp x22, x23, [x0]
    ldp x24, x25, [x0,#16]
    ldp x26, x27, [x0,#32]
    ldp x28, x29, [x0,#48]

    adds x14, x14, x22
    adcs x15, x15, x23
    adcs x16, x16, x24
    adcs x17, x17, x25
    adcs x18, x18, x26
    adcs x19, x19, x27
    adcs x20, x20, x28
    adcs x21, x21, x29
    adcs x6, x6, x1



    ldp x2, x3, [x0,#64]
    ldp x4, x5, [x0,#80]
    ldp x10, x11, [x0,#96]
    ldp x12, x13, [x0,#112]

    adds x14, x14, x2
    adcs x15, x15, x3
    adcs x16, x16, x4
    adcs x17, x17, x5
    adcs x18, x18, x10
    adcs x19, x19, x11
    adcs x20, x20, x12
    adcs x21, x21, x13
    adcs x6, x6, x1


    adds x14, x14, x26
    adcs x15, x15, x27
    adcs x16, x16, x28
    adcs x17, x17, x29
    adcs x18, x18, x2
    adcs x19, x19, x3
    adcs x20, x20, x4
    adcs x21, x21, x5
    adcs x6, x6, x1

    asr x7, x6, #5

    adds x10, x10, x6
    adcs x11, x11, x7
    adcs x12, x12, x7
    adcs x13, x13, x7


    stp x14, x15, [x0,#32]
    stp x16, x17, [x0,#48]

    stp x18, x19, [x0,#64]
    stp x20, x21, [x0,#80]

    stp x10, x11, [x0,#96]
    stp x12, x13, [x0,#112]


    //stack
    ldp x19, x20, [sp,#0]
    ldp x21, x22, [sp,#16]
    ldp x23, x24, [sp,#32]
    ldp x25, x26, [sp,#48]
    ldp x27, x28, [sp,#64]
    ldp x29, x30, [sp,#80]



    add sp, sp, #112

ret

ksqr512_func:
_ksqr512_func:
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

    //


    ////////////////////////////////L * L
    //start
    ldp x2, x3, [x1]
    ldp x4, x5, [x1,#16]
    ldp x6, x7, [x1,#32]
    ldp x8, x9, [x1,#48]

    mov x1, #0          //zero

    //L * L
    mul x11, x2, x3     //A[0] * B[1]
    umulh x12, x2, x3   //A[0] * B[1]   H

    mul x10, x2, x2     //A[0] * B[0]
    umulh x13, x3, x3   //A[1] * B[1]   H

    adds x11, x11, x11
    adcs x12, x12, x12
    adcs x13, x13, x1    //zero


    umulh x29, x2, x2   //A[0] * B[0] H
    mul x30, x3, x3     //A[1] * B[1]

    adds x11, x11, x29
    adcs x12, x12, x30
    adcs x13, x13, x1   //zero

    //H * H
    mul x15, x4, x5     //A[2] * B[3]
    umulh x16, x4, x5   //A[2] * B[3]   H

    mul x14, x4, x4     //A[2] * B[2]
    umulh x17, x5, x5   //A[3] * B[3]   H

    adds x15, x15, x15
    adcs x16, x16, x16
    adcs x17, x17, x1    //zero


    umulh x29, x4, x4   //A[2] * B[2] H
    mul x30, x5, x5     //A[3] * B[3]

    adds x15, x15, x29
    adcs x16, x16, x30
    adcs x17, x17, x1   //zero


    //M * M
    subs x27, x2, x4
    sbcs x28, x3, x5
    sbcs x29, x29, x29

    eor x27, x27, x29
    eor x28, x28, x29

    and x29, x29, #1
    adds x27, x27, x29
    adcs x28, x28, x1     //zero

    mul x19, x27, x28      //A[2] * B[3]
    umulh x20, x27, x28   //A[2] * B[3]   H

    mul x18, x27, x27      //A[2] * B[2]
    umulh x21, x28, x28   //A[3] * B[3]   H

    adds x19, x19, x19
    adcs x20, x20, x20
    adcs x21, x21, x1    //zero


    umulh x29, x27, x27   //A[2] * B[2] H
    mul x30, x28, x28     //A[3] * B[3]

    adds x19, x19, x29
    adcs x20, x20, x30
    adcs x21, x21, x1   //zero


    //10 13
    //14 17
    //18 21


    adds x22, x10, x14
    adcs x23, x11, x15
    adcs x24, x12, x16
    adcs x25, x13, x17
    adcs x26, x1, x1    //zero

    adds x12, x12, x22
    adcs x13, x13, x23
    adcs x14, x14, x24
    adcs x15, x15, x25
    adcs x26, x26, x1

    subs x12, x12, x18
    sbcs x13, x13, x19
    sbcs x14, x14, x20
    sbcs x15, x15, x21
    sbcs x26, x26, x1

    adds x16, x16, x26
    adcs x17, x17, x1

    //result x10-17


    //2 H * H

    //1 L * L
    mul x19, x6, x7     //A[0] * B[1]
    umulh x20, x6, x7   //A[0] * B[1]   H

    mul x18, x6, x6     //A[0] * B[0]
    umulh x21, x7, x7   //A[1] * B[1]   H

    adds x19, x19, x19
    adcs x20, x20, x20
    adcs x21, x21, x1    //zero


    umulh x29, x6, x6   //A[0] * B[0] H
    mul x30, x7, x7     //A[1] * B[1]

    adds x19, x19, x29
    adcs x20, x20, x30
    adcs x21, x21, x1   //zero

    //1 H * H
    mul x23, x8, x9     //A[2] * B[3]
    umulh x24, x8, x9   //A[2] * B[3]   H

    mul x22, x8, x8     //A[2] * B[2]
    umulh x25, x9, x9   //A[3] * B[3]   H

    adds x23, x23, x23
    adcs x24, x24, x24
    adcs x25, x25, x1    //zero


    umulh x29, x8, x8   //A[2] * B[2] H
    mul x30, x9, x9     //A[3] * B[3]

    adds x23, x23, x29
    adcs x24, x24, x30
    adcs x25, x25, x1   //zero

    //op computation
    subs x2, x2, x6
    sbcs x3, x3, x7
    sbcs x4, x4, x8
    sbcs x5, x5, x9
    sbcs x29, x29, x29

    eor x2, x2, x29
    eor x3, x3, x29
    eor x4, x4, x29
    eor x5, x5, x29

    and x29, x29, #1
    adds x2, x2, x29
    adcs x3, x3, x1
    adcs x4, x4, x1
    adcs x5, x5, x1



    //1 M * M
    subs x6, x6, x8
    sbcs x7, x7, x9
    sbcs x8, x8, x8

    eor x6, x6, x8
    eor x7, x7, x8

    and x8, x8, #1
    adds x6, x6, x8
    adcs x7, x7, x1     //zero

    mul x27, x6, x7      //A[2] * B[3]
    umulh x28, x6, x7   //A[2] * B[3]   H

    mul x26, x6, x6      //A[2] * B[2]
    umulh x29, x7, x7   //A[3] * B[3]   H

    adds x27, x27, x27
    adcs x28, x28, x28
    adcs x29, x29, x1    //zero


    umulh x8, x6, x6   //A[2] * B[2] H
    mul x9, x7, x7     //A[3] * B[3]

    adds x27, x27, x8
    adcs x28, x28, x9
    adcs x29, x29, x1   //zero

    adds x6, x18, x22
    adcs x7, x19, x23
    adcs x8, x20, x24
    adcs x9, x21, x25
    adcs x30, x1, x1    //zero

    adds x20, x20, x6
    adcs x21, x21, x7
    adcs x22, x22, x8
    adcs x23, x23, x9
    adcs x30, x30, x1

    subs x20, x20, x26
    sbcs x21, x21, x27
    sbcs x22, x22, x28
    sbcs x23, x23, x29
    sbcs x30, x30, x1

    adds x24, x24, x30
    adcs x25, x25, x1

    //      x10-x17
    //result x18-x25



    adds x6, x10, x18
    adcs x7, x11, x19
    adcs x8, x12, x20
    adcs x9, x13, x21
    adcs x26, x14, x22
    adcs x27, x15, x23
    adcs x28, x16, x24
    adcs x29, x17, x25
    adcs x30, x1, x1

    adds x14, x14, x6
    adcs x15, x15, x7
    adcs x16, x16, x8
    adcs x17, x17, x9
    adcs x18, x18, x26
    adcs x19, x19, x27
    adcs x20, x20, x28
    adcs x21, x21, x29
    adcs x30, x30, x1

    stp x10, x11, [x0,#0]
    stp x12, x13, [x0,#16]

    //x30 : carry
    //x6 9
    //x10 x13
    //x26-x30

    //2 M * M
    //1 L * L
    mul x7, x2, x3     //A[0] * B[1]
    umulh x8, x2, x3   //A[0] * B[1]   H

    mul x6, x2, x2     //A[0] * B[0]
    umulh x9, x3, x3   //A[1] * B[1]   H

    adds x7, x7, x7
    adcs x8, x8, x8
    adcs x9, x9, x1    //zero


    umulh x28, x2, x2   //A[0] * B[0] H
    mul x29, x3, x3     //A[1] * B[1]

    adds x7, x7, x28
    adcs x8, x8, x29
    adcs x9, x9, x1   //zero

    //1 H * H
    mul x11, x4, x5     //A[2] * B[3]
    umulh x12, x4, x5   //A[2] * B[3]   H

    mul x10, x4, x4     //A[2] * B[2]
    umulh x13, x5, x5   //A[3] * B[3]   H

    adds x11, x11, x11
    adcs x12, x12, x12
    adcs x13, x13, x1    //zero

    umulh x28, x4, x4   //A[2] * B[2] H
    mul x29, x5, x5     //A[3] * B[3]
    adds x11, x11, x28
    adcs x12, x12, x29
    adcs x13, x13, x1   //zero


//x14
    //6 9
    //10 13
    //26 29




    //1 M * M
    subs x2, x2, x4
    sbcs x3, x3, x5
    sbcs x4, x4, x4

    eor x2, x2, x4
    eor x3, x3, x4

    and x4, x4, #1
    adds x2, x2, x4
    adcs x3, x3, x1     //zero


    ///addition
    adds x26, x6, x10
    adcs x27, x7, x11
    adcs x28, x8, x12
    adcs x29, x9, x13
    adcs x4, x1, x1

    adds x8, x8, x26
    adcs x9, x9, x27
    adcs x10, x10, x28
    adcs x11, x11, x29
    adcs x4, x4, x1
    ////


    mul x27, x2, x3      //A[2] * B[3]
    umulh x28, x2, x3   //A[2] * B[3]   H

    mul x26, x2, x2      //A[2] * B[2]
    umulh x29, x3, x3   //A[3] * B[3]   H

    adds x27, x27, x27
    adcs x28, x28, x28
    adcs x29, x29, x1    //zero

    umulh x1, x2, x2   //A[2] * B[2] H
    adds x27, x27, x1

    mul x1, x3, x3     //A[3] * B[3]
    adcs x28, x28, x1

    mov x1, #0
    adcs x29, x29, x1   //zero

    subs x8, x8, x26
    sbcs x9, x9, x27
    sbcs x10, x10, x28
    sbcs x11, x11, x29
    sbcs x4, x4, x1

    adds x12, x12, x4
    adcs x13, x13, x1
    adcs x30, x30, x1

    subs x14, x14, x6
    sbcs x15, x15, x7
    sbcs x16, x16, x8
    sbcs x17, x17, x9
    sbcs x18, x18, x10
    sbcs x19, x19, x11
    sbcs x20, x20, x12
    sbcs x21, x21, x13
    sbcs x30, x30, x1

    adds x22, x22, x30
    adcs x23, x23, x1
    adcs x24, x24, x1
    adcs x25, x25, x1


    stp x14, x15, [x0,#32]
    stp x16, x17, [x0,#48]
    stp x18, x19, [x0,#64]
    stp x20, x21, [x0,#80]
    stp x22, x23, [x0,#96]
    stp x24, x25, [x0,#112]
/**/

    //stack
    ldp x19, x20, [sp,#0]
    ldp x21, x22, [sp,#16]
    ldp x23, x24, [sp,#32]
    ldp x25, x26, [sp,#48]
    ldp x27, x28, [sp,#64]
    ldp x29, x30, [sp,#80]

    add sp, sp, #96

ret


