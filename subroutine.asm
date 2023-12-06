section .data
    num1 db 5
    num2 db 2
    result db 0
    result_str db 10     
    result_end equ $ ; string end

section .text
    global _start

_start:
    mov al, byte [num1]    ; move num1 into al register, small byte size

    call substr

    add al, '0'            ; convert the num value into ASCII
    mov [result_str], al   ; move the char into the string

    mov ecx, result_str    ; load the address of result_str into ecx
    mov edx, result_end - result_str  ; length of string
    mov ebx, 1             ; stdout (1)
    mov eax, 4             ; for sys_write
    int 80h

    mov ebx, 0
    mov eax, 1             ; sys_exit
    int 80h

substr:
    sub al, byte [num2]   ; substract num1 - num2 (al contains num1 value)
    mov [result], al      ; store result in our variable

    ret
