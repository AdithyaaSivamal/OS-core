; boot.asm (bootloader)
[org 0x7C00]                       ; Bootloader starts at address 0x7C00
[bits 16]                          ; 16-bit real mode

KERNEL_LOCATION equ 0x1000

;%include "../bin/bootsector_constants.inc"  ; Include shared constants

BOOT_DISK: db 0

start:

        mov ah, 0x0E
        mov al, 'S'                      ; Indicate Start
        int 0x10

        cli                             ; disable interrupts
        mov [BOOT_DISK], dl
        xor ax, ax
        mov es, ax
        mov ds, ax
        mov ss, ax
        ;mov bp, 0x8000                  ; Set stack pointer to top of bootloader
        mov sp, 0x7C00

        sti                             ; Enable interrupts

        ; Print "Loading Kernel..." message
        mov ah, 0x0E                    ; BIOS teletype function
        mov si, message

message:
    db "Loading Kernel...", 0       ; Null-terminated message

print_loop:
        lodsb                           ; Load byte from [SI] into AL
        cmp al, 0                       ; Check for null terminator
        je load_kernel                  ; Jump to load_kernel if end of string
        int 0x10                        ; BIOS interrupt to print character
        jmp print_loop


load_kernel:
        ; Load pmode.bin into memory at 0x0000:0x8000 (physical address 0x8000)
        mov ax, 0x0000                  ; Segment 0x0000
        mov es, ax
        mov bx, KERNEL_LOCATION         ; Offset 0x8000 in ES
        mov dh, 0x00

        ; read kernel onto disk
        mov ah, 0x02                    ; BIOS 'read sector' function
        mov al, 24
        ;mov al, dh
        mov ch, 0x00                    ; Cylinder 0
        mov cl, 0x02                    ; Sector number (start from sector 2)
        mov dl, [BOOT_DISK]             ; boot drive number
        int 0x13                        ; BIOS interrupt to read sectors
        jc disk_read_error


        ; 'Successful Debugging' Flag
        mov ah, 0x0E
        mov al, 'K'                      ; Indicate Kernel is loaded
        int 0x10


        ; clear screen
        mov ah, 0x0
        mov al, 0x3
        int 0x10                        ; Text mode

            ; Transition to protected mode
        cli                         ; Disable interrupts
        lgdt [gdt_descriptor]       ; Load Global Descriptor Table
        nop

        ; Set PE (Protection Enable) bit in CR0 to enter protected mode
        mov eax, cr0
        or eax, 1
        mov cr0, eax

        ; Far jump to clear prefetch queue and enter protected mode
        jmp 0x08:protected_mode_start


disk_read_error:
        ; Handle disk read error
        mov ah, 0x0E
        mov al, 'E'                     ; Display 'E' for error
        int 0x10


[bits 32]
protected_mode_start:
        ; Now in protected mode (32-bit)
        ; Update segment registers with data segment selector
        mov ax, 0x10                 ; Data segment selector from GDT
        mov ds, ax
        mov es, ax
        mov fs, ax
        mov gs, ax
        mov ss, ax

        ; Initialize stack pointer
        mov ebp, 0x90000             ; Stack pointer at 0x90000
        mov esp, ebp
        ; Clear Direction Flag for forward string operations
        cld

        ; Print "Protected Mode Reached" message
        mov esi, pm_msg
        mov edi, 0xB8000             ; Video memory base address
        add edi, 1600                ; Move to next line (1600 bytes)
        mov ecx, pm_msg_len          ; Length of the message

print_pm_message:
        lodsb                        ; Load byte from [ESI] into AL
        cmp al, 0                    ; Check for null terminator
        je done_pm                   ; Exit loop if end of string
        mov ah, 0x07                 ; Text attribute (white on black)
        stosw                        ; Store AX at [EDI], increment EDI
        loop print_pm_message

done_pm:
        jmp KERNEL_LOCATION

pm_msg:
    db "Protected Mode Reached", 0

pm_msg_len equ $ - pm_msg


; Global Descriptor Table (GDT)
gdt_descriptor:
    dw gdt_end - gdt_start - 1  ; Limit (Size of GDT - 1)
    dd gdt_start                ; Base address of GDT

gdt_start:
        ; Null Descriptor (Mandatory)
        dq 0x0000000000000000

        ; Code Segment Descriptor
        dw 0xFFFF          ; Limit Low
        dw 0x0000          ; Base Low
        db 0x00            ; Base Middle
        db 10011010b       ; Access Byte
        db 11001111b       ; Flags and Limit High
        db 0x00            ; Base High

        ; Data Segment Descriptor
        dw 0xFFFF          ; Limit Low
        dw 0x0000          ; Base Low
        db 0x00            ; Base Middle
        db 10010010b       ; Access Byte
        db 11001111b       ; Flags and Limit High
        db 0x00            ; Base High

gdt_end:


times 510 - ($ - $$) db 0           ; Pad up to offset 508
dw 0xAA55                           ; Boot signature at offset 510-511
