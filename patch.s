	CPU		6502

	ORG		$8000
	BINCLUDE	"prg.orig"

ROM_FREE = $FFC7
	ORG ROM_FREE
LAST_ROM	:=	*

	INCLUDE		"vars.s"
	INCLUDE		"mmio.s"
	INCLUDE		"util.s"
	INCLUDE		"fixes.s"
	INCLUDE		"flip.s"
;#	INCLUDE		"free.s"  ; Out of ROM space for this.
