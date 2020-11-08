; Boomer Rang'r uses $1B bit 0 to indicate whether or not the second player is
; playing, and acts upon this to flip the screen or not.

; Screen flip hacks ===========================================================

; Intro / credit screen text flip.
	ORG	$A0DC
	lda	#$05

; Set flip at reset for license screen. Caused a problem in early HW testing?
	ORG	$A2F9
;	ora	#$05

; Sets screen flip based on player in action, right after reading inputs.
	ORG	$A10F
;	jmp	player_action_flip_a10f

; Flip screen based on which player. Occurs at end of game.
	ORG	$A6AB
;	jmp	player_choice_a6ab

; Set flip for right before title. Useless?
	ORG	$ED02
	lda	#$15

; Flip for high score table.
	ORG	$F5C7
	ora	#$21

; Flip for title screen.
	ORG	$FB70
	lda	#$11

; Flip for something after the title. Useless?
	ORG	$FBA2
	lda	#$15

; Flip for Today's High Scores.
	ORG	$FDCE
	lda	#$05

; Flip for end of level.
	ORG	$A5E3
	jmp	post_level_flip_a5e3

; New routines ================================================================
	ORG	LAST_ROM

post_level_flip_a5e3:
	lda	$1B
	ora	#$04
	eor	#$01
	jmp	$A5E7

player_action_flip_a10f:
	lda	$1B
	eor	#$01
	sta	$8006
	jmp	$A114

player_choice_a6ab:
	lda	$1B
	and	#$FE
	eor	#$01
	sta	$8006
	jmp	$A6B2

LAST_ROM	:=	*

