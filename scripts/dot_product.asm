.text
dot_product:	addu	$at, $zero, $zero	# result = 0
loop:		beq	$a3, $zero, done	# done looping?
		lw	$v0, 0($v1)		# load a element
		lw	$a0, 32($a1)		# load b element
		mul	$v0, $v0, $a0		# assume this is 1 instruction
		addu	$at, $at, $v0		# result += (*a)*(*b)
		addiu	$v1, $v1, 4
		addiu	$a1, $a1, 4
		addiu 	$a3, $a3, -1
		j	loop
done:		jr 	$ra

.data
a:	.word	0, 0, 7, 1, 5, 9, 0, 8, 7
b:	.word	2, 2, 9, 3, 7, 1, 2, 0, 9
