SHELL := /bin/bash
AS = nasm
CC = i386-elf-g++
LD = i386-elf-ld

ASFLAGS = -f bin
ASFLAGS_ELF = -f elf32
CFLAGS = -ffreestanding -m32 -g
LDFLAGS = -m elf_i386 -T $(LINKER_SCRIPT) --oformat binary

# Output directory and output files
OUTPUT_DIR = ../bin
BOOTLOADER = $(OUTPUT_DIR)/boot_loader.bin
KERNEL = $(OUTPUT_DIR)/kernel.bin
KERNEL_ENTRY = $(OUTPUT_DIR)/kernel_entry.o
OUTPUT_FILE = $(OUTPUT_DIR)/os.img

# Source directory and source files
SRC_DIR = ../src
BOOTLOADER_SRC = $(SRC_DIR)/boot_loader.asm
KERNEL_SRC = $(SRC_DIR)/kernel.cpp
KERNEL_ENTRY_SRC = $(SRC_DIR)/kernel_entry.asm
LINKER_SCRIPT = $(SRC_DIR)/linker.ld

all: $(OUTPUT_FILE)

# Assemble bootloader
$(BOOTLOADER): $(BOOTLOADER_SRC)
	$(AS) $(ASFLAGS) $(BOOTLOADER_SRC) -o $(BOOTLOADER)

# Assemble kernel entry
$(KERNEL_ENTRY): $(KERNEL_ENTRY_SRC)
	$(AS) $(ASFLAGS_ELF) $(KERNEL_ENTRY_SRC) -o $(KERNEL_ENTRY)

# Compile the kernel in C++
$(OUTPUT_DIR)/kernel.o: $(KERNEL_SRC)
	$(CC) $(CFLAGS) -c $(KERNEL_SRC) -o $(OUTPUT_DIR)/kernel.o

# Link the kernel entry and kernel with linker script
$(KERNEL): $(KERNEL_ENTRY) $(OUTPUT_DIR)/kernel.o $(LINKER_SCRIPT)
	$(LD) $(LDFLAGS) -o $(KERNEL) $(KERNEL_ENTRY) $(OUTPUT_DIR)/kernel.o

# Create OS image by combining bootloader and kernel
$(OUTPUT_FILE): $(BOOTLOADER) $(KERNEL)
	dd if=$(BOOTLOADER) of=$(OUTPUT_FILE) bs=512 count=1 conv=notrunc
	dd if=$(KERNEL) of=$(OUTPUT_FILE) bs=512 seek=1 conv=notrunc

clean:
	rm -f $(OUTPUT_DIR)/*.bin $(OUTPUT_DIR)/*.o $(OUTPUT_FILE)

.PHONY: clean all

