.text
main:   addi x2, x0, 5  # x2 = 5
	addi x3, x0, 12  # x3 = 12
	addi x7, x3, -9  # x7 = 3
	ori x4, x7, 5    # x4 = 7
	andi x5, x3, 7   # x5 = 4
	add x5, x5, x4   # x5 = 11
	bne x5, x5, end  
	slt x4, x3, x4   # x4 = 0
	beq x4, x0, around
	addi x5, x0, 0
around: slt x4, x7, x2  # x4 = 1
	add x7, x4, x5  # x7 = 12
	sub x7, x7, x2  # x7 = 7
	lui x3, 1  # x3 = 0x1000
	sw x7, 12(x3)  # 0x100c <- 7
	addi x3, x3, 8  # x3 = 0x1008
	lw x2, 4(x3)  # x2 = 7
	j end
	addi x2, x0, 1
end:	lui x9, 8  # x9 = 0x8000
	addi x9, x9, -4  # x9 = 0x7ffc
	addi x2, x2, -6  # x2 = 1
loop:	sw x2, 0(x9)
	or x2, x2, x2
	and x2, x2, x2
	j loop
