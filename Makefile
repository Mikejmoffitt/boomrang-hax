AS=asl
P2BIN=p2bin
SRC=patch.s
BSPLIT=bsplit
MAME=mame

ASFLAGS=

.PHONY: clean boomrang

all: clean boomrang

prg.orig:
	$(BSPLIT) n data/bp13.9k bp13-swp
	$(BSPLIT) n data/bp14.11k bp14-swp
	cat bp13-swp bp14-swp > prg.orig
	rm bp13-swp bp14-swp

prg.o: prg.orig
	$(AS) $(SRC) $(ASFLAGS) -o prg.o

prg.bin: prg.o
	$(P2BIN) $< $@ -r \$$-0x10000

boomrang: prg.bin
	mkdir -p out
	split prg.bin -b 16384
	$(BSPLIT) n xaa bp13.9k
	$(BSPLIT) n xab bp14.11k
	cp bp13.9k out/
	cp bp14.11k out/
#	cat bp13.9k bp13.9k bp13.9k bp13.9k > bp13_quad.9k
#	cat bp14.11k bp14.11k bp14.11k bp14.11k > bp14_quad.11k

test: boomrang
	cp data/* ~/.mame/roms/boomrang/
	cp out/* ~/.mame/roms/boomrang
	$(MAME) -debug boomrang -r 480x512 -flipx -flipy
 
clean:
	@-rm -rf out/
	@-rm -f prg.bin
	@-rm -f prg.o
	@-rm -f prg.orig
	cp data/* ~/.mame/roms/boomrang/
