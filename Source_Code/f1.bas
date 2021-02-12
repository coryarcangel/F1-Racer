array absolute $300 spritemem 256

asm

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


	endasm

	set $2006 $3f
	set $2006 $00

	set f1palcounter $00

f1palloop:	
	set $2007 [f1pal f1palcounter]
	inc f1palcounter
	if f1palcounter < $08 goto f1palloop
	
	
;++++++++++++++++++++++++++++++++++++++++++++++++
;load name tables 
;++++++++++++++++++++++++++++++++++++++++++++++++


array addr 2
set songloadloop 0
asm

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

endasm

	set wx 0
	set wy 0
	
	set directionmaster 0
	
	set f1palcounter 0
	set f1paldowncounter 0
	set f1paldowncounter2 1
	set f1palcountermaster 0	
	
	set lines_counter_counter 1

asm

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
endasm
wait1:
	
	set c1 $01
	set c2 $b1
		
asm
	

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

endasm



wait2:
	
	set c12 $01
	set c22 $05
		
asm
	

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

endasm

wait3:
	
	set c123 $01
	set c223 $04
		
asm
	

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
	
	endasm

	set $2006 $21	
	set $2006 $df
	set loop_16_lines 0
	set tempcount 0

;draw road

	set $2007 [lines lines_counter]
	inc lines_counter

	set $2007 [lines lines_counter]
	inc lines_counter
	
	set $2007 [lines lines_counter]
	inc lines_counter
	
	set $2007 [lines lines_counter]
	inc lines_counter
	
	set $2007 [lines lines_counter]
	inc lines_counter
	
	set $2007 [lines lines_counter]
	inc lines_counter
	
	set $2007 [lines lines_counter]
	inc lines_counter
	
	set $2007 [lines lines_counter]
	inc lines_counter
	
	set $2007 [lines lines_counter]
	inc lines_counter
	
	set $2007 [lines lines_counter]
	inc lines_counter
	
	set $2007 [lines lines_counter]
	inc lines_counter
	
	set $2007 [lines lines_counter]
	inc lines_counter
	
	set $2007 [lines lines_counter]
	inc lines_counter
	
	set $2007 [lines lines_counter]
	inc lines_counter
	
	set $2007 [lines lines_counter]
	inc lines_counter
	
	set $2007 [lines lines_counter]
	inc lines_counter	
	
;palette update

	set f1palcounter f1palcountermaster
	
	set $2006 $3f
	set $2006 $00
	set $2007 [f1pal f1palcounter]
	inc f1palcounter
	
	set $2006 $3f
	set $2006 $01
	set $2007 [f1pal f1palcounter]
	inc f1palcounter
	
	set $2006 $3f
	set $2006 $02
	set $2007 [f1pal f1palcounter]
	inc f1palcounter	
	
	set $2006 $3f
	set $2006 $03
	set $2007 [f1pal f1palcounter]
	inc f1palcounter

	set $2006 $3f
	set $2006 $04
	set $2007 [f1pal f1palcounter]
	inc f1palcounter
	
	set $2006 $3f
	set $2006 $05
	set $2007 [f1pal f1palcounter]
	inc f1palcounter
	
	set $2006 $3f
	set $2006 $06
	set $2007 [f1pal f1palcounter]
	inc f1palcounter	
	
	set $2006 $3f
	set $2006 $07
	set $2007 [f1pal f1palcounter]
	inc f1palcounter
	
			
	set $2006 0
	set $2006 0
	set $2005 $c0
	set $2005 0
	
	gosub wait1
	gosub wait1
	gosub wait1
	gosub wait1
	gosub wait1
	gosub wait1
	gosub wait1
	gosub wait1
	gosub wait1
	gosub wait1
	gosub wait1
	gosub wait1
	gosub wait1
	gosub wait1	
	
	set wx $40
	set wy $02
	
	gosub wait4
	
	set $2005 $7f
	set $2005 00
	
end:	
	asm
	dec f1paldowncounter
	bne end2
	dec f1paldowncounter2
	bne end2
	lda #$ff
	sta f1paldowncounter
	lda #$06
	sta f1paldowncounter2
	inc f1palcountermaster
	inc f1palcountermaster
	inc f1palcountermaster
	inc f1palcountermaster
	inc f1palcountermaster
	inc f1palcountermaster
	inc f1palcountermaster
	inc f1palcountermaster	
end2:
	endasm
	if f1palcountermaster = $28 set f1palcountermaster 0
	asm
	
	dec lines_counter_counter
	bne end3
	lda #$02
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

	endasm
	if lines_counter = $c0 set lines_counter 0	
	asm

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

endasm