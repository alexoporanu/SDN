.data
	a: .space 1200
	   .align 4
	
 	v: .space 400
	   .align 4
	neizolate: .space 400
	problema: .space 100
	str:.space 100
	queue3: .space 40
	visited3: .space 400
	host1:.space 100
	host2:.space 100
	queue: .space 40
	visited: .space 400
	strNL:   .byte '\n'
	strSpace:.byte ' '
	sm: .asciiz "switch malitios index "
	Yes: .asciiz "Yes"
	No: .asciiz "No"
	p2: .byte ':'
	pva: .byte ';'
	
	s0: .asciiz "ignora"
		
	s1: .asciiz "host index "

	s2: .asciiz "switch index "

	s3: .asciiz "switch malitios index "
		
	s4: .asciiz "controller index "



	as:
	.word s0
	.word s1
	.word s2	
	.word s3
	.word s4
.text

main:
	li $v0, 5
	syscall
	move $t0, $v0		#numar noduri
	
	li $v0, 5
	syscall
	move $t1, $v0		#numar muchii 
	 
	li $t2, 0
	li $t6,0		#pe post de line index

cadi:
	bge $t2 ,$t1, ett
	
	li $v0, 5 
	syscall
	move $t3, $v0
	

	li $v0, 5
	syscall
	move $t4, $v0
				
	mul $t5,$t3,$t0
	add $t5,$t4,$t5
	mul $t5,$t5,4		
	
	li $t6,1
	sw $t6,a($t5)

	
	mul $t5,$t4,$t0
	add $t5,$t3,$t5
	mul $t5,$t5,4
	
	sw $t6,a($t5)		
	
	addi $t2, 1
	j cadi

ett:
	li $t5,0
	li $t2,0
	li $t3,0
	li $t4,0
	li $t5,0
	li $t6,0
	li $t7,0

		
etvector:
	bge $t5, $t0, numarproblema
	
	li $v0, 5
	syscall

	sw $v0, v($t6)				# mut din reg. $v0 la locatia de memorie v($t2)

	addi $t5, $t5, 1
	addi $t6, $t6, 4
	j etvector
	
numarproblema:	
	
	li $t2,0
	
	li $v0,5
	syscall

	sw $v0,problema($t2)
	
	lw $t4,problema($t2) 
	
	beq $t4,1,ini
	beq $t4,2,ini2
	beq $t4,3,citirehost
		
ini:

	li $t2,0	
	li $t3,0
	li $t4,0
	li $t5,0
	li $t6,0
	li $t7,0
	
	j etvector2 

	
etvector2:
	bge $t5, $t0, etexit
	
	lw $t4, v($t7)
	beq $t4, 3, afj
	bne $t4, 3, etcont
	

etcont:
	beq $t2,1, NL
	addi $t5, $t5, 1
	addi $t7, $t7, 4
	
	j etvector2 


NL:
	lb $a0, strNL
	li $v0, 11		# PRINT BYTE
	syscall
	li $t2,0
	j etcont

afj:
	li $t2,1

	la $a0, sm
	li $v0, 4				# PRINT STRING
	syscall
			
	move $a0,$t5
	li $v0, 1	
	syscall
	
	lb $a0, p2
	li $v0, 11		# PRINT BYTE
	syscall

	lb $a0, strSpace
	li $v0, 11		# PRINT BYTE
	syscall	
	
	


	j init
	
init:
	li $t3,0
	j for_columns
	
	
	

for_columns:
	bge $t3,$t0,etcont
	# afisarea elementului curent
	# matrix (4 * (lineIndex * columns + columnIndex))
	mul $t4, $t5, $t0
	add $t4, $t4, $t3
	mul $t4, $t4, 4

		
	
	lw $t6, a($t4)
	beq $t6,1, afisare
	

	addi $t3, 1
	
		
	j for_columns


afisare:
	mul $t6,$t3,4	
	lw $t6,v($t6)	
	mul $t6,$t6,4
	
	lw $a0, as($t6)
	li $v0, 4				# PRINT INT (WORD)
	syscall
	
	move $a0,$t3
	li $v0, 1	
	syscall
	
	lb $a0, pva
	li $v0, 11		# PRINT BYTE
	syscall	
	
	lb $a0, strSpace
	li $v0, 11		# PRINT BYTE
	syscall	
	
	 
			
	addi $t3, 1
	j for_columns	

ini2:	
	
	li $t2,0 	#queueLEN
	li $t3,0        #queueIdx
	li $t4,0	#aici va fi salvat ccolumn index
	li $t5,0 	#aici va fi salvat CURRENTnode
	li $t6,0
	li $t7,0
	
	j BFS
BFS:
	sw $t2, queue($t2) 	#queue(queueLEN=0)=$t2=0
	addi $t2,1		#queueLEN=queueLEN+1
	li $t6,1		
	sw $t6, visited($t3)	#visited($t3=0)=1
	
	
	j while1		#sarim la  primul while

while1:
	beq $t3,$t2,niz	#while queueIdx!=queueLEN SAU CAND AJUNG EgaLE iesi


	mul $t4,$t3,4				# 
	lw $t5,queue($t4)			#currentNode=queue(queueIdx)
	addi $t3,1				#queueIdx++
	
	mul $t4,$t5,4		#SALVAM IN $t4 locatia lui currentnode	
	
	lw $t6,v($t4)		
	beq $t6,1,print		#verific daca v=roles($t5)=1 si il afisez daca da, apoi ma intorc la cio
	bne $t6,1,cio		# daca nu, sar la cio


cio:
	li $t4, 0		#$t4 este COLUMNINDEX, il initializez cu 0 
	j while2		# sarim la al 2 lea while
while2:
	
	bge $t4,$t0, while1	#while columnIndex<N, cand nu mai e sarim la primul while de sus


	
	mul $t6,$t5,$t0				#if graph[currentnode][columnindex]==a[$t5][$t4]==1 adica a[$t0*$t5+$t4]
	add $t6,$t6,$t4
	mul $t6,$t6,4
	lw $t6,a($t6)				#salvez in $t6 a[$t5][$t4]
	
	beq $t6,1,etif2				# daca e unu sari la al doilea if
	bne $t6,1,c2				# daca nu, columnindex++ si sari inapoi la while2		
etif2:
	mul $t6,$t4,4
	lw $t6,visited($t6)		#bag in $t6 visited(columnindex=$t4)

	beq $t6,1,c2	# daca e egal cu 1
		
	mul $t6,$t2,4
	
	sw $t4, queue($t6)
		
	addi $t2,1
	
	mul $t6, $t4, 4

	li $t7,1
	
	sw $t7,visited($t6)
		
	addi $t4,1
	
	j while2 
c2:
	addi $t4,1
	j while2
	

	
print:
	li $v0, 4
	la $a0, s1
	syscall	
	
	move $a0, $t5
	li $v0,1 
	syscall
	
	lb $a0, pva
	li $v0, 11		# PRINT BYTE
	syscall	
	
		
	lb $a0, strSpace
	li $v0, 11		# PRINT BYTE
	syscall
	
	j cio

niz:
	li $t2,0
	li $t3,0
	li $t4,0
	li $t5,1
	li $t6,0
	li $t7,0
	
	j endL

endL:
	lb $a0, strNL
	li $v0, 11		# PRINT BYTE
	syscall
	
	j afniz
	
afniz:	
	beq $t2,$t0,et1
		
	mul $t3,$t2,4

	lw $t4,visited($t3)
	
	mul $t5,$t5,$t4
		
	addi $t2,1
	j afniz
	

et1:

	bne $t5,0, YES
	
	la $a0, No
	li $v0, 4				# PRINT STRING
	syscall	
	
	
	li $v0,10
	syscall

YES:	
	la $a0, Yes
	li $v0, 4				# PRINT STRING
	syscall
	
	li $v0,10
	syscall

citirehost:
	
	li $t2,0
	li $t3,0
	
	li $v0,5
	syscall
	
	sw $v0,host1($t2)
	
	li $v0,5
	syscall
	
	sw $v0,host2($t2)
	
	j hello
	
hello:
	li $v0, 8
	la $a0, str
	li $a1, 20
	syscall

	j ini3

ini3:
	li $t2,0 	#queueLen3	
	li $t3,0        #queueIdx3
	li $t4,0	#aici va fi salvat column index
	li $t5,0 	#aici va fi salvat currentnode
	li $t6,0
	li $t7,0
		
	j ultima
	
ultima:
	lw $t5, host1($t5) 	#am in $t5 pe host1[0] (adica host1)
	
	sw $t5,queue3($t3)       #queue3[$t3=0]=host1[0] (adica host1)
	
	addi $t2,1		#queueLen3+1
	
	li $t6,1		

	mul $t4,$t5,4
	
	sw $t6,visited3($t4)	#visited3[host]=1	

	li $t3,0
	li $t4,0
	li $t6,0	
	
	j while13                 #sarim la primul while

while13:
	beq $t3,$t2,cezar
	
	mul $t4,$t3,4		  #salvam in $t4 pozitia lui qIdx3 in queue3
	lw $t5, queue3($t4) 	  # currentNode3=queue3[queueIdx3]
	addi $t3,1		  #queueIdx3+=1
	
	lw $t4,host2($t7)  	  #bag in $t4 pe host2
	
	beq $t4,$t5, printmesaj   #if currentnode3==host2
	
	li $t4,0

	j while23

while23:
	beq $t4,$t0,while13
	
	mul $t6,$t5,$t0				#if graph[currentnode3][columnindex3]==a[$t5][$t4]==1 adica a[$t0*$t5+$t4]
	add $t6,$t6,$t4
	mul $t6,$t6,4
	lw $t6,a($t6)				#salvez in $t6 a[$t5][$t4], adica graph[currentnode3][columnindex3]
	
	beq $t6,1,etif23			# daca e unu sari la al doilea if
	bne $t6,1,c23				# daca nu, columnindex#++ si sari inapoi la while2		
etif23:
	mul $t6,$t4,4
	lw $t6,visited3($t6)		#bag in $t6 visited3(columnindex3=$t4)

	beq $t6,1,c23		# daca e egal cu 1 sar inapoi in while

	mul $t6,$t4,4
	
	lw $t6,v($t6)		#bag in $t6 v(columnindex3=$t4)

	beq $t6,3,c23		#daca e egal cu 3 sar inapoi in while
	
	mul $t6,$t2,4		#bag in $t6 pozitia in queue3 a lui $t2=queueLen3
	
	sw $t4, queue3($t6)	#queue3[queueLen3] = columnIndex3
		
	addi $t2,1 		#queueLen3 = queueLen3 + 1
	
	mul $t6, $t4, 4  	#in $t6 salvez pozitia in vectorul visited a lui $t4, care este columnindex

	li $t7,1
	
	sw $t7,visited3($t6)	# visited3[columnIndex3] = 1
		
	li $t7,0
	
	addi $t4,1
	
	j while23
	
c23:
	addi $t4,1
	j while23



printmesaj:
	la $a0, str
	li $v0, 4
	syscall

	j etexit
cez:
	
	li $t7,0
	j cezar


cezar:
	lb $t1, str($t7)
	beqz $t1, etexit

	addi $t1,-81
	li $t2,26
	rem $t1,$t1,$t2
	addi $t1,97
	
	sb $t1, str($t7)	

	addi $t7, 1
	j cezar


etexit:
	la $a0, str
	li $v0,4
	syscall
	
	li $v0,10
	syscall
		


	