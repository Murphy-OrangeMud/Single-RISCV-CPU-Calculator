# porta: 0x7f00 r--, stores control
#        low 4 bits: { btnL, btnC, btnR, btnU }
#        btnL: add; btnC: sub; btnR: mul, btnU: =;
# portb: 0x7f10 r--, stores sw
# portc: 0x7f20 rw-, stores 16'b->bcd->led
# portd: 0x7ffc rw-, stores 16->led
.text
init:
    add x5, x0, x0
    add x6, x0, x0
    lui x16, 8
    addi x16, x16, -0x100  # x16: 0x7f00
begin:
    lw x31, 0x10(x16)
    lw x30, 0x0(x16)
loop:
    lw x29, 0x10(x16)
    xor x27, x29, x31
    bne x27, x0, changeb
    j loop
changebfinish: # wait for porta to change
    lw x28, 0x0(x16)
    xor x27, x28, x30
    bne x27, x0, changea
    j changebfinish
changeafinish:  # porta <= 0
    beq x6, x0, waitfornext
    addi x24, x0, 0x1 # btnU: eq
    beq x6, x24, eq
    addi x24, x0, 0x2 # btnR: mul
    beq x6, x24, multiply
    addi x24, x0, 0x4 # btnC: sub
    beq x6, x24, minus
    addi x24, x0, 0x8 # btnL: add
    beq x6, x24, plus
changeb:
    add x7, x29, x0
    j changebfinish
changea:
    add x8, x28, x0
loopa:
    lw x27, 0x0(x16)
    beq x27, x0, changeafinish
    j loopa
waitfornext:
    add x6, x8, x0
    add x5, x7, x0
    sw x5, 0x20(x16)
    j begin
plus:
    add x5, x5, x7
    sw x5, 0x20(x16)
    j begin
minus:
    sub x5, x5, x7
    sw x5, 0x20(x16)
    j begin
multiply:
    addi x26, x0, 32
    addi x17, x0, 1  # shifter
    add x21, x0, x0  # counter
    add x20, x0, x0  # product
loopmul:
    addi x21, x21, 1
    beq x21, x26, Exit
    and x25, x17, x7
    beq x25, x0, Else
    add x20, x20, x5
Else:
    slli x5, x5, 1
    srli x7, x7, 1
    j loopmul
Exit:
    add x5, x20, x0
    sw x5, 0x20(x16)
    j begin
eq:
    sw x5, 0x20(x16)
    j init
