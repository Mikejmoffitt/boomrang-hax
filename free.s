
; Free play hacks =============================================================

; Extension of vblank wait to look for player input.
;	ORG	$A00D
;	jsr	start_jump_hack
;	jsr	wait_vblank
;	jmp	$A021

; Skip IRQ checking for coin switches on free play
;	ORG	$A21F
;	jmp	irq_coin_check

; Don't insert coins if in free play.
;	ORG	$A29D
;	jmp	irq_coin_add

; Go to start screen if start is pressed, in free play
;	ORG	$A4B2
;	jmp	start_transition_hack

; Credit checks on start screen removed in free play
;	ORG	$A4EF
;	jmp	start_credit_check_hack


	ORG	LAST_ROM

start_transition_hack:
	jsr	check_free
	bne	.free_en
	lda	CreditCount
	bne	.start_screen

.attract_loop:
	jmp	$A4B6

.free_en:
	; Check start buttons
	byt	$13, $AD
	byt	$8F, 01
	lda	IN3
	eor	#$FF
	byt	$8F, 00
	and	#$0C
	beq	.attract_loop
	; Start is pushed.

.start_screen:
	jmp	$A4D9

irq_coin_add:
	tax
	jsr	check_free
	bne	.free_en
	txa
	sed
	clc
	adc	CreditCount
	cld
	jmp	$A2A2

.free_en:
	lda	#$01
	jmp	$A2A8

; A = free play enabled
check_free:
	byt	$13, $AD
	byt	$8F, 01

	lda	DSWA ; Read DSWA
	eor	#$FF
	and	#$10 ; Check free play switch
	beq	.no_freeplay
	lda	#$01
.no_freeplay:
	byt	$8f, 00
	rts

start_jump_hack:
	pha
	jsr	check_free
	beq	.exit

	; Check start button
	byt	$13, $AD
	byt	$8F, 01
	lda	IN3
	eor	#$FF
	byt	$8F, 00
	and	#$0C
	beq	.exit
	brk	; If start is pushed, trigger IRQ
.exit
	pla
	rts

start_credit_check_hack:
	jsr	R_TOGGLE_INTS
	jsr	check_free
	; Stick free play bit in X.
	tax

	byt	$13, $AD
	byt	$8F, $01

	lda	IN3
	eor	#$FF

	byt	$8F, $00

	cpx	#$00
	beq	.notfree

	and	#$0C
	beq	.start_not_pressed

	and	#$08
	bne	.start_2p_pressed
	lda	#$00
	sta	$18
	lda	#$80
	sta	$19
	jmp	$A526
.start_2p_pressed:
	lda	#$80
	sta	$18
	lda	#$00
	sta	$19
	jmp	$A256

	; Use original coin check routine.
.notfree:
	jmp	$A4FD

.start_not_pressed:
	jmp	start_credit_check_hack

irq_coin_check:
	jsr	check_free
	bne	.free_en
	jsr	R_NOPLOOP
	jmp	$A222
.free_en:
	jmp	$A26C

LAST_ROM	:=	*
