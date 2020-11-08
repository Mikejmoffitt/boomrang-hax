	ORG	LAST_ROM
wait_vblank:
	pha
	lda	#$00
.wait1_top:
	byt	$67, $85
	cli
	nop
	nop
	and	#$04
	sei
	bne	.wait1_top
.wait2_top:
	byt	$67, $85
	cli
	nop
	nop
	and	#$04
	sei
	beq	.wait2_top
	pla
	rts

LAST_ROM	:=	*
