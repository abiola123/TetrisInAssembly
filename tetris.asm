;; game state memory location
.equ T_X, 0x1000                  ; falling tetrominoe position on x
.equ T_Y, 0x1004                  ; falling tetrominoe position on y
.equ T_type, 0x1008               ; falling tetrominoe type
.equ T_orientation, 0x100C        ; falling tetrominoe orientation
.equ SCORE,  0x1010               ; score
.equ GSA, 0x1014                  ; Game State Array starting address
.equ SEVEN_SEGS, 0x1198           ; 7-segment display addresses
.equ LEDS, 0x2000                 ; LED address
.equ RANDOM_NUM, 0x2010           ; Random number generator address
.equ BUTTONS, 0x2030              ; Buttons addresses

;; type enumeration
.equ C, 0x00
.equ B, 0x01
.equ T, 0x02
.equ S, 0x03
.equ L, 0x04

;; GSA type
.equ NOTHING, 0x0
.equ PLACED, 0x1
.equ FALLING, 0x2

;; orientation enumeration
.equ N, 0
.equ E, 1
.equ So, 2
.equ W, 3
.equ ORIENTATION_END, 4

;; collision boundaries
.equ COL_X, 4
.equ COL_Y, 3

;; Rotation enumeration
.equ CLOCKWISE, 0
.equ COUNTERCLOCKWISE, 1

;; Button enumeration
.equ moveL, 0x01
.equ rotL, 0x02
.equ reset, 0x04
.equ rotR, 0x08
.equ moveR, 0x10
.equ moveD, 0x20

;; Collision return ENUM
.equ W_COL, 0
.equ E_COL, 1
.equ So_COL, 2
.equ OVERLAP, 3
.equ NONE, 4

;; start location
.equ START_X, 6
.equ START_Y, 1

;; game rate of tetrominoe falling down (in terms of game loop iteration)
.equ RATE, 5

;; standard limits
.equ X_LIMIT, 12
.equ Y_LIMIT, 8


;; TODO Insert your code here
	main:
	addi sp,zero,LEDS
	call clear_leds

	addi a0,zero,1
	addi a1,zero,4
	addi a2,zero,1
	call set_gsa

	addi a0,zero,0
	addi a1,zero,1
	addi a2,zero,1
	call set_gsa	

	addi a0,zero,0
	addi a1,zero,2
	addi a2,zero,2
	call set_gsa

	addi a0,zero,0
	addi a1,zero,3
	addi a2,zero,1
	call set_gsa


	
	call draw_gsa
	
		ret


; BEGIN:draw_tetromino
	draw_tetromino:
	add a2,a0,zero
	#addi sp,sp,-4
	#stw a0, 0(sp)
	ldw t0, T_X(zero)
	ldw t1, T_Y(zero)
	ldw t2, T_type(zero)
	ldw t3, T_orientation(zero)

#find location in each array (draw_ay and draw_ax)
	add t4,t2,zero
	slli t4,t4,2
	add t4,t4,t3
#because we are making steps of 4 in coordinates we need to shift the final result by 2 to get to the correct position
	slli t4,t4,2

#load x and y offsets
	ldw t5,DRAW_Ax(t4)
	ldw t6,DRAW_Ay(t4)

#draw x and y that are given

	add a0,t0,zero
	add a1,t1,zero
	call set_gsa

#first offset
	ldw t7, 0(t5)
	ldw t8, 0(t6)

	add a0,t0,t7
	add a1,t1,t8
	call set_gsa

#second offset
	addi t5,t5,4
	addi t6,t6,4
	ldw t7, 0(t5)
	ldw t8, 0(t6)

	add a0,t0,t7
	add a1,t1,t8
	call set_gsa

#third offset
	addi t5,t5,4
	addi t6,t6,4
	ldw t7, 0(t5)
	ldw t8, 0(t6)

	add a0,t0,t7
	add a1,t1,t8
	call set_gsa

call draw_gsa

	ret

; END:draw_tetromino

; BEGIN:helper
	save_all_temporary_registers_in_stack:
addi sp,sp,-4
stw t0, 0(sp)
addi sp,sp,-4
stw t1, 0(sp)
addi sp,sp,-4
stw t2, 0(sp)
addi sp,sp,-4
stw t3, 0(sp)
addi sp,sp,-4
stw t4, 0(sp)
addi sp,sp,-4
stw t5, 0(sp)
addi sp,sp,-4
stw t6, 0(sp)
addi sp,sp,-4 
stw t7, 0(sp)
	ret
; END:helper

; BEGIN:helper
	restore_all_temporary_registers_from_stack:
ldw t7, 0(sp)
addi sp,sp,4
ldw t6, 0(sp)
addi sp,sp,4
ldw t5, 0(sp)
addi sp,sp,4
ldw t4, 0(sp)
addi sp,sp,4
ldw t3, 0(sp)
addi sp,sp,4
ldw t2, 0(sp)
addi sp,sp,4
ldw t1, 0(sp)
addi sp,sp,4
ldw t0, 0(sp)
addi sp,sp,4
	ret
; END:helper



; BEGIN:draw_gsa
draw_gsa:
add t0, zero, zero
add t1,zero,zero
addi t6,zero,12
addi t7,zero,8
addi sp,sp,-4
stw ra,0(sp)
while_outside:
beq t0,t6,exit_outside
	add t1,zero,zero
	while_inside:
	beq t1,t7,exit_inside
		add a0,t0,zero
		add a1,t1,zero
		call save_all_temporary_registers_in_stack
		call get_gsa
		add t5,v0,zero
		beq t5,zero,after_led_procedure
		call set_pixel	
		after_led_procedure:
		call restore_all_temporary_registers_from_stack
		addi t1,t1,1
	jmpi while_inside
exit_inside:
addi t0,t0,1
jmpi while_outside
exit_outside:
ldw ra, 0(sp)
addi sp,sp,4
	ret
; END:draw_gsa-






; BEGIN:in_gsa
in_gsa:
blt a0,zero,return_one
addi t0,zero,12
bge a0,t0,return_one
blt a1,zero,return_one
addi t0,zero,7
bge a1,t0,return_one

jmpi return_zero

return_one:
addi v0,zero,1
	ret

return_zero:
addi v0,zero,0
	ret
; END:in_gsa





; BEGIN:get_gsa
get_gsa:
#set correct position in gsa
slli t0,a0,3
add t0,t0,a1

#multiply by 4 because the coordinates in ram change in steps of 4
slli t0,t0,2

#load the requested value
ldw v0,0x1014(t0)
	ret
; END:get_gsa






; BEGIN:set_gsa
set_gsa:
#set correct position in gsa
slli t0,a0,3
add t0,t0,a1

#multiply by 4 because the coordinates in ram change in steps of 4
slli t0,t0,2

#store  value
stw a2,0x1014(t0)
	ret
; END:set_gsa




; BEGIN:clear_leds
clear_leds:
stw zero, LEDS(zero)
addi r9,zero,4
stw zero, LEDS(r9)
addi r9, r9,4
stw zero, LEDS(r9)
  ret
; END:clear_leds






; BEGIN:set_pixel
set_pixel:
#least significant bits
andi t0,a0,3
#most significant bit
srli t1,a0,2

#values to compare for index of led
addi t2, zero, 1
addi t3, zero, 2
addi t4, zero, 3
###
beq t0,t4,loadThirdColumn
beq t0,t3,loadSecondColumn
beq t0,t2,loadFirstColumn
beq t0,zero,loadZeroColumn

insideSetPixelAfterLoadingColumn:

slli t6,v0,3
add t6,t6,a1

beq t1,t3,loadLedArrayTwo
beq t1,t2,loadLedArrayOne
beq t1,zero,loadLedArrayZero

insideSetPixelAfterLoadingArray:

ldw t5, 0x2000(v0)

addi t7,zero,1
sll t7,t7,t6
or t7,t7,t5

stw t7,0x2000(v0)
  ret
; END:set_pixel







; BEGIN:wait
wait:
addi s0,zero,2
slli a0,s0,20
jmpi while
  ret
; END:wait



############################helper methods for wait
; BEGIN:helper
while:
beq a0,zero,exit
addi a0,a0,-1
jmpi while
exit:
 ret
; END:helper

############################






##############################methods for loading correct array of leds
; BEGIN:helper
loadLedArrayTwo:
addi v0,zero,8
jmpi insideSetPixelAfterLoadingArray
; END:helper

loadLedArrayOne:
addi v0,zero,4
jmpi insideSetPixelAfterLoadingArray
; END:helper

; BEGIN:helper
loadLedArrayZero:
addi v0,zero,0
jmpi insideSetPixelAfterLoadingArray
; END:helper

##############################


##############################methods for loading columns of each array of leds

; BEGIN:helper
loadThirdColumn:
addi v0,zero,3
jmpi insideSetPixelAfterLoadingColumn
; END:helper

; BEGIN:helper
loadSecondColumn:
addi v0,zero,2
jmpi insideSetPixelAfterLoadingColumn
; END:helper

; BEGIN:helper
loadFirstColumn:
addi v0,zero,1
jmpi insideSetPixelAfterLoadingColumn
; END:helper

; BEGIN:helper
loadZeroColumn:
addi v0,zero,0
jmpi insideSetPixelAfterLoadingColumn
; END:helper

##############################

font_data:
.word 0xFC  ; 0
.word 0x60  ; 1
.word 0xDA  ; 2
.word 0xF2  ; 3
.word 0x66  ; 4
.word 0xB6  ; 5
.word 0xBE  ; 6
.word 0xE0  ; 7
.word 0xFE  ; 8
.word 0xF6  ; 9

C_N_X:
.word 0x00
.word 0xFFFFFFFF
.word 0x00

C_N_Y:
.word 0xFFFFFFFF
.word 0x00
.word 0x01

C_E_X:
.word 0x01
.word 0x00
.word 0xFFFFFFFF

C_E_Y:
.word 0x00
.word 0xFFFFFFFF
.word 0x00

C_So_X:
.word 0x01
.word 0x00
.word 0x^^^^^^^^^^^^^^^^

C_So_Y:
.word 0x00
.word 0x01
.word 0x00

C_W_X:
.word 0xFFFFFFFF
.word 0x00
.word 0x01

C_W_Y:
.word 0x00
.word 0x01
.word 0x00

B_N_X:
.word 0xFFFFFFFF
.word 0x02
.word 0x01

B_N_Y:
.word 0x00
.word 0x00
.word 0x00

B_E_X:
.word 0x00
.word 0x00
.word 0x00

B_E_Y:
.word 0xFFFFFFFF
.word 0x02
.word 0x01

B_So_X:
.word 0x01
.word 0xFFFFFFFE
.word 0xFFFFFFFF

B_So_Y:
.word 0x00
.word 0x00
.word 0x00

B_W_X:
.word 0x00
.word 0x00
.word 0x00

B_W_Y:
.word 0x01
.word 0xFFFFFFFE
.word 0xFFFFFFFF

T_N_X:
.word 0x01
.word 0xFFFFFFFE
.word 0x01

T_N_Y:
.word 0x00
.word 0x00
.word 0xFFFFFFFF

T_E_X:
.word 0x00
.word 0x00
.word 0x01

T_E_Y:
.word 0x01
.word 0xFFFFFFFE
.word 0x01

T_So_X:
.word 0x01
.word 0xFFFFFFFE
.word 0x01

T_So_Y:
.word 0x00
.word 0x00
.word 0x01

T_W_X:
.word 0x00
.word 0x00
.word 0xFFFFFFFF

T_W_Y:
.word 0x01
.word 0xFFFFFFFE
.word 0x01

S_N_X:
.word 0xFFFFFFFF
.word 0x01
.word 0x01

S_N_Y:
.word 0x00
.word 0xFFFFFFFF
.word 0x00

S_E_X:
.word 0x00
.word 0x01
.word 0x00

S_E_Y:
.word 0xFFFFFFFF
.word 0x01
.word 0x01

S_So_X:
.word 0xFFFFFFFF
.word 0x01
.word 0x01

S_So_Y:
.word 0x01
.word 0x00
.word 0xFFFFFFFF

S_W_X:
.word 0x00
.word 0xFFFFFFFF
.word 0x00

S_W_Y:
.word 0x01
.word 0xFFFFFFFF
.word 0xFFFFFFFF
L_N_X:
.word 0x01
.word 0x00
.word 0xFFFFFFFE

L_N_Y:
.word 0x00
.word 0xFFFFFFFF
.word 0x01

L_E_X:
.word 0x00
.word 0x00
.word 0x01

L_E_Y:
.word 0xFFFFFFFF
.word 0x02
.word 0x00

L_So_X:
.word 0x01
.word 0xFFFFFFFE
.word 0x00

L_So_Y:
.word 0x00
.word 0x00
.word 0x01

L_W_X:
.word 0x00
.word 0x00
.word 0xFFFFFFFF

L_W_Y:
.word 0x01
.word 0xFFFFFFFE
.word 0x00

DRAW_Ax:  ; address of shape arrays, x axis
.word C_N_X
.word C_E_X
.word C_So_X
.word C_W_X
.word B_N_X
.word B_E_X
.word B_So_X
.word B_W_X
.word T_N_X
.word T_E_X
.word T_So_X
.word T_W_X
.word S_N_X
.word S_E_X
.word S_So_X
.word S_W_X
.word L_N_X
.word L_E_X
.word L_So_X
.word L_W_X

DRAW_Ay:  ; address of shape arrays, y_axis
.word C_N_Y
.word C_E_Y
.word C_So_Y
.word C_W_Y
.word B_N_Y
.word B_E_Y
.word B_So_Y
.word B_W_Y
.word T_N_Y
.word T_E_Y
.word T_So_Y
.word T_W_Y
.word S_N_Y
.word S_E_Y
.word S_So_Y
.word S_W_Y
.word L_N_Y
.word L_E_Y
.word L_So_Y
.word L_W_Y
