; minimal_boot_loader.asm

[org 0x7C00]
[bits 16]

start:
    ; Display "Hello Bootloader!"
    mov ah, 0x0E
    mov si, message

print_loop:
    lodsb
    cmp al, 0
    je halt
    int 0x10
    jmp print_loop

message:
    db "Hello Bootloader!", 0

halt:
    jmp $

times 510 - ($ - $$) db 0
dw 0xAA55

