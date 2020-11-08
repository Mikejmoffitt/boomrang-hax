

; Show the license screen for three seconds instead of 3 frames.
	ORG	$A378
	ldx	#180
.wait_top:
	jsr	wait_vblank
	dex
	bne	.wait_top
	jmp	$A389
