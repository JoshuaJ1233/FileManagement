
; CISC 211 - File Management Lab


section .data
    filename db "quotes.txt", 0

    first_quotes db "To be, or not to be, that is the question.", 10, 10
                 db "A fool thinks himself to be wise, but a wise man knows himself to be a fool.", 10, 10
    first_len equ $ - first_quotes

    added_quotes db "Better three hours too soon than a minute too late.", 10, 10
                 db "No legacy is so rich as honesty.", 10
    added_len equ $ - added_quotes

section .text
    global _start

_start:
    ; Create quotes.txt
    mov eax, 8              ; sys_creat
    mov ebx, filename
    mov ecx, 0644o          ; file permissions
    int 0x80

    cmp eax, 0
    jl exit_error

    mov esi, eax            ; save file descriptor

    ; Write first two quotes
    mov eax, 4              ; sys_write
    mov ebx, esi
    mov ecx, first_quotes
    mov edx, first_len
    int 0x80

    cmp eax, 0
    jl close_error

    ; Move to the end of the file
    mov eax, 19             ; sys_lseek
    mov ebx, esi            ; file descriptor
    mov ecx, 0              ; offset
    mov edx, 2              ; seek from end of file
    int 0x80

    cmp eax, 0
    jl close_error

    ; Append final two quotes
    mov eax, 4              ; sys_write
    mov ebx, esi
    mov ecx, added_quotes
    mov edx, added_len
    int 0x80

    cmp eax, 0
    jl close_error

    ; Close file
    mov eax, 6              ; sys_close
    mov ebx, esi
    int 0x80

    ; Exit successfully
    mov eax, 1              ; sys_exit
    xor ebx, ebx
    int 0x80

close_error:
    mov eax, 6
    mov ebx, esi
    int 0x80

exit_error:
    mov eax, 1
    mov ebx, 1
    int 0x80
