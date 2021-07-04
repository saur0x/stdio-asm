AS := nasm
ASFLAGS := -f elf64

LD := ld
LDFLAGS :=

.PHONY: clean

all: main

main: main.o
	@echo '[+] Linking'
	$(LD) $(LDFLAGS) -o $@ $^

%.o: %.s
	@echo '[+] Assembling'
	$(AS) $(ASFLAGS) -o $@ $^

clean:
	@echo '[+] Cleaning'
	rm -f -- ./main ./*.o
