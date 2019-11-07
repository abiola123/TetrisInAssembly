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
	call clear_leds
	call wait
	addi a0,zero,5
	addi a1,zero,6
	call set_pixel
	call wait
	addi a0,zero,2
	addi a1,zero,0 
	call set_pixel
	addi a0,zero,11
	addi a1,zero,4
	call set_pixel
		ret


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
slli s0,a0,30
srli s0,s0,30
#most significant bit
srli s1,a0,2

#values to compare for index of led
addi s2, zero, 1
addi s3, zero, 2
addi s4, zero, 3
###
beq s0,s4,loadThirdColumn
beq s0,s3,loadSecondColumn
beq s0,s2,loadFirstColumn
beq s0,zero,loadZeroColumn

insideSetPixelAfterLoadingColumn:

slli s6,v0,3
add s6,s6,a1

beq s1,s3,loadLedArrayTwo
beq s1,s2,loadLedArrayOne
beq s1,zero,loadLedArrayZero

insideSetPixelAfterLoadingArray:

ldw s5, 0x2000(v0)

addi s7,zero,1
sll s7,s7,s6
or s7,s7,s5

stw s7,0x2000(v0)
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
.word 0xFFFFFFFF

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
