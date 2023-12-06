section .data
    num1 db 5
    num2 db 2
    symbol db '-' 
    result db 0
    result_str db 10
    result_end equ $ ; string end

section .text
    global _start

_start:
    mov al, byte [num1]    ; move num1 into al register, small byte size
    cmp byte [symbol], '+' 
    jz addition            ; jump to addition if symbol equals '+'
    
    cmp byte [symbol], '-' 
    jz substraction 
    

addition:
    call add_operation     
    jmp display_result
    
substraction:
    call substr     
    jmp display_result

substr:
    sub al, byte [num2]    ; subtract num2 from num1 (al contains num1 value)
    mov [result], al       ; store the result in our variable
    ret

add_operation:
    add al, byte [num2]    ; add num2 to num1 (al contains num1 value)
    mov [result], al       
    ret

display_result:
    add al, '0'            ; convert the num value into ASCII
    mov [result_str], al   ; move the character into the string

    mov ecx, result_str    ; load the address of result_str into ecx
    mov edx, result_end - result_str  ; length of the string
    mov ebx, 1             ; stdout (1)
    mov eax, 4             ; sys_write
    int 80h

    mov ebx, 0
    mov eax, 1             ; sys_exit
    int 80h
