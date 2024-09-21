section .text
        global _start        ; Entry point called by bootloader
        extern main          ; Declare the 'main' function from C++

    [bits 32]
_start:
        ; Set up segment registers
        mov ax, 0x10         ; Data segment selector from GDT (set up in bootloader)
        mov ds, ax
        mov es, ax
        mov fs, ax
        mov gs, ax
        mov ss, ax

        ; Initialize the stack pointer
        mov esp, stack_top   ; Set ESP to the top of the stack

        ; Call setup_paging to establish page tables and enable paging
        call setup_paging

        ; Enable paging by setting the PG (Paging Enable) bit in CR0
        mov eax, cr0
        or eax, 0x80000000   ; Set the PG bit (bit 31) in CR0
        mov cr0, eax         ; Write CR0 back

        ; Call the C++ kernel's main function
        call main            ; Call 'main' defined in kernel.cpp

        ; Infinite loop if the kernel's main function returns
.halt:
        hlt
        jmp .halt            ; Prevent further execution

setup_paging:
        ; Set up identity-mapped page directory and page table

        ; Load the address of the page directory into CR3
        mov eax, page_directory
        mov cr3, eax         ; Load CR3 with the page directory address

        ; Fill the page table with identity-mapped entries
        mov edi, page_table
        mov ecx, 1024        ; 1024 entries in the page table
        mov ebx, 0x00000000  ; Start from physical address 0x00000000

fill_page_table:
        mov eax, ebx         ; Identity mapping: Virtual address = Physical address
        or eax, 0x3          ; Set present (bit 0) and read/write (bit 1) flags
        stosd                ; Store the entry in the page table
        add ebx, 0x1000      ; Increment by 4KB for the next page
        loop fill_page_table ; Repeat for all entries

        ; Set the first entry in the page directory to point to the page table
        mov eax, page_table
        or eax, 0x3          ; Set present and read/write flags
        mov [page_directory], eax

        ret                  ; Return to _start

section .bss
        align 16             ; Align stack to 16 bytes
stack_bottom:
        resb 16384           ; Reserve 16KB for the stack
stack_top:

section .data
align 4096
page_directory:
        dd 0x00000000        ; First entry for the page table, initialized in code
        times 1023 dd 0x00000000 ; Remaining entries in the page directory

align 4096
page_table:
        times 1024 dd 0x00000000 ; Page table entries
