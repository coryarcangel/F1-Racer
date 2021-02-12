nbasic_stack = 256
spritemem = 768
addr = 0
f1palcounter = 2
songloadloop = 3
wx = 4
wy = 5
directionmaster = 6
f1paldowncounter = 7
f1paldowncounter2 = 8
f1palcountermaster = 9
lines_counter_counter = 10
c1 = 11
c2 = 12
c12 = 13
c22 = 14
c123 = 15
c223 = 16
loop_16_lines = 17
tempcount = 18
lines_counter = 19


	.inesprg 2
	.ineschr 1
	.inesmir 1
	.inesmap 0
	
	.org $8000

	clouds_start:
	.dw clouds_start_addr
	clouds_start_addr:
	.incbin "f2.hex"

	lines:
	.incbin "road_anim.hex"

	f1pal:
	.incbin "f1pal.hex"

start:

	sei
	cld

.vblank_clear1
	lda $2002
	bpl .vblank_clear1
	
.vblank_clear2
	lda $2002
	bpl .vblank_clear2

.vblank_clear3
	lda $2002
	bpl .vblank_clear3

	sei
	cld

.vblank_clear4
	lda $2002
	bpl .vblank_clear4
	
.vblank_clear5
	lda $2002
	bpl .vblank_clear5

.vblank_clear6
	lda $2002
	bpl .vblank_clear6

	
        lda #$00
        ldx #$00
.clear_out_ram
		sta $000,x
        sta $100,x
        sta $200,x
        sta $300,x
        sta $400,x
        sta $500,x
        sta $600,x
        sta $700,x
        inx
        bne .clear_out_ram
 
        lda #$00
        ldx #$00
.clear_out_sprites
		sta $2000,x
        sta $2100,x
        sta $2200,x
        sta $2300,x
        sta $2400,x
        sta $2500,x
        sta $2600,x
        sta $2700,x
        sta $2800,x
        sta $2900,x
        sta $2a00,x
        sta $2b00,x
        sta $2c00,x
        sta $2d00,x
        sta $2e00,x
        sta $2f00,x
        inx
        bne .clear_out_sprites
        
        ldx #$FF
        txs
 
;++++++++++++++++++++++++++++++++++++++++++++++++
;load palette
;++++++++++++++++++++++++++++++++++++++++++++++++


	 lda #63
 sta 8198
 lda #0
 sta 8198
 lda #0
 sta f1palcounter

f1palloop:
 ldx f1palcounter
 lda f1pal,x
 sta 8199
 inc f1palcounter
 lda #8
 cmp f1palcounter
 bcc nbasic_autolabel_1
 jmp f1palloop

nbasic_autolabel_1:
 lda #0
 sta songloadloop


	ldx #0
	ldy #0
	
	lda #2
	sta songloadloop
load_outcast:
	lda clouds_start,y
 	sta addr,x
  	iny
 	inx
 	dec songloadloop
	bne load_outcast

	lda #$20
	sta $2006
	lda #$00
	sta $2006

nametables:
		
	ldx #$08
	ldy #$00
	
load_clouds:
	lda [addr],y
	sta $2007
	iny
	bne load_clouds
	txs
	ldx #$01
	inc addr,x
	tsx
	dex
	bne load_clouds

   lda   #$00
   sta   $2006
   sta   $2006       ;Reset PPU
   sta   $2005
   sta   $2005       ;Reset Scroll

;++++++++++++++++++++++++++++++++++++++++++++++++
;init graphic settings
;++++++++++++++++++++++++++++++++++++++++++++++++
 
 lda   #%10010100
 sta   $2000
 lda   #%00001010     
 sta   $2001

;++++++++++++++++++++++++++++++++++++++++++++++++
;set variables
;++++++++++++++++++++++++++++++++++++++++++++++++

 lda #0
 sta wx
 lda #0
 sta wy
 lda #0
 sta directionmaster
 lda #0
 sta f1palcounter
 lda #0
 sta f1paldowncounter
 lda #1
 sta f1paldowncounter2
 lda #0
 sta f1palcountermaster
 lda #1
 sta lines_counter_counter


;++++++++++++++++++++++++++++++++++++++++++++++++
;loop forever....
;++++++++++++++++++++++++++++++++++++++++++++++++

main:
	 jmp main

;++++++++++++++++++++++++++++++++++++++++++++++++
;vblankzzzzzz
;++++++++++++++++++++++++++++++++++++++++++++++++

vwait:
	lda $2002
	bpl vwait
 rts

;++++++++++++++++++++++++++++++++++++++++++++++++
;delay
;++++++++++++++++++++++++++++++++++++++++++++++++

wait1:
 lda #1
 sta c1
 lda #177
 sta c2

	

.main_delay2

	ldx c1
	
.delayz2
	
	ldy c2	

.delayt2
	dey
	bne .delayt2

	dex
	bne .delayz2
	
	rts


wait2:
 lda #1
 sta c12
 lda #5
 sta c22

	

.main_delay3

	ldx c12
	
.delayz3
	
	ldy c22

.delayt3
	dey
	bne .delayt3

	dex
	bne .delayz3
	
	rts


wait3:
 lda #1
 sta c123
 lda #4
 sta c223

	

.main_delay33

	ldx c123
	
.delayz33
	
	ldy c223

.delayt33
	dey
	bne .delayt33

	dex
	bne .delayz33
	
	rts


wait4:

	ldx wx
	ldy wy
wait4_delay:

	dex 
	bne wait4_delay
	dey
	bne wait4_delay
	rts
	
		
;++++++++++++++++++++++++++++++++++++++++++++++++
;NMI Routine!!!!  Very important!!!!!  Basically
;draw the lines, and update the PAL counter....
;++++++++++++++++++++++++++++++++++++++++++++++++


nmi:
	
	 lda #33
 sta 8198
 lda #223
 sta 8198
 lda #0
 sta loop_16_lines
 lda #0
 sta tempcount
 ldx lines_counter
 lda lines,x
 sta 8199
 inc lines_counter
 ldx lines_counter
 lda lines,x
 sta 8199
 inc lines_counter
 ldx lines_counter
 lda lines,x
 sta 8199
 inc lines_counter
 ldx lines_counter
 lda lines,x
 sta 8199
 inc lines_counter
 ldx lines_counter
 lda lines,x
 sta 8199
 inc lines_counter
 ldx lines_counter
 lda lines,x
 sta 8199
 inc lines_counter
 ldx lines_counter
 lda lines,x
 sta 8199
 inc lines_counter
 ldx lines_counter
 lda lines,x
 sta 8199
 inc lines_counter
 ldx lines_counter
 lda lines,x
 sta 8199
 inc lines_counter
 ldx lines_counter
 lda lines,x
 sta 8199
 inc lines_counter
 ldx lines_counter
 lda lines,x
 sta 8199
 inc lines_counter
 ldx lines_counter
 lda lines,x
 sta 8199
 inc lines_counter
 ldx lines_counter
 lda lines,x
 sta 8199
 inc lines_counter
 ldx lines_counter
 lda lines,x
 sta 8199
 inc lines_counter
 ldx lines_counter
 lda lines,x
 sta 8199
 inc lines_counter
 ldx lines_counter
 lda lines,x
 sta 8199
 inc lines_counter
 lda f1palcountermaster
 sta f1palcounter
 lda #63
 sta 8198
 lda #0
 sta 8198
 ldx f1palcounter
 lda f1pal,x
 sta 8199
 inc f1palcounter
 lda #63
 sta 8198
 lda #1
 sta 8198
 ldx f1palcounter
 lda f1pal,x
 sta 8199
 inc f1palcounter
 lda #63
 sta 8198
 lda #2
 sta 8198
 ldx f1palcounter
 lda f1pal,x
 sta 8199
 inc f1palcounter
 lda #63
 sta 8198
 lda #3
 sta 8198
 ldx f1palcounter
 lda f1pal,x
 sta 8199
 inc f1palcounter
 lda #63
 sta 8198
 lda #4
 sta 8198
 ldx f1palcounter
 lda f1pal,x
 sta 8199
 inc f1palcounter
 lda #63
 sta 8198
 lda #5
 sta 8198
 ldx f1palcounter
 lda f1pal,x
 sta 8199
 inc f1palcounter
 lda #63
 sta 8198
 lda #6
 sta 8198
 ldx f1palcounter
 lda f1pal,x
 sta 8199
 inc f1palcounter
 lda #63
 sta 8198
 lda #7
 sta 8198
 ldx f1palcounter
 lda f1pal,x
 sta 8199
 inc f1palcounter
 lda #0
 sta 8198
 lda #0
 sta 8198
 lda #192
 sta 8197
 lda #0
 sta 8197
 jsr wait1
 jsr wait1
 jsr wait1
 jsr wait1
 jsr wait1
 jsr wait1
 jsr wait1
 jsr wait1
 jsr wait1
 jsr wait1
 jsr wait1
 jsr wait1
 jsr wait1
 jsr wait1
 lda #64
 sta wx
 lda #2
 sta wy
 jsr wait4
 lda #127
 sta 8197
 lda #0
 sta 8197

end:

	dec f1paldowncounter
	bne end2
	dec f1paldowncounter2
	bne end2
	lda #$ff
	sta f1paldowncounter
	lda #$06
	sta f1paldowncounter2
	;inc f1palcountermaster
	;inc f1palcountermaster
	;inc f1palcountermaster
	;inc f1palcountermaster
	;inc f1palcountermaster
	;inc f1palcountermaster
	;inc f1palcountermaster
	end2:
	 lda #40
 cmp f1palcountermaster
 bne nbasic_autolabel_2
 lda #0
 sta f1palcountermaster

nbasic_autolabel_2:

	
	dec lines_counter_counter
	bne end3
	lda #$80
	sta lines_counter_counter
	jmp end4
end3:
	dec lines_counter
	dec lines_counter
	dec lines_counter
	dec lines_counter
	dec lines_counter
	dec lines_counter
	dec lines_counter
	dec lines_counter
	dec lines_counter
	dec lines_counter
	dec lines_counter
	dec lines_counter
	dec lines_counter
	dec lines_counter
	dec lines_counter
	dec lines_counter

end4:

	 lda #192
 cmp lines_counter
 bne nbasic_autolabel_3
 lda #0
 sta lines_counter

nbasic_autolabel_3:


	rti
 
irq:
	rti

;++++++++++++++++++++++++++++++++++++++++++++++++
;Load Data Filez
;++++++++++++++++++++++++++++++++++++++++++++++++

	.bank 3
	.org $fffa
	.dw nmi		;//NMI
	.dw start	;//Reset
	.dw irq	;//BRK
	.bank 4
	.org $0000

    .incbin "f1.chr"  ;gotta be 8192 bytes long


