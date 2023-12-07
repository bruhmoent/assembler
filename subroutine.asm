section .data
    num1 db 5
    num2 db 5
    symbol db '*' 
    result dw 0
    result_str db 10 dup 0
    result_end equ $       ; string end

section .text
    global _start

_start:
    mov al, byte [num1]    ; move num1 into al register, small byte size
    
    cmp byte [symbol], '+' 
    jz addition 
    
    cmp byte [symbol], '-' 
    jz substraction 
    
    cmp byte [symbol], '*' 
    jz multiplication 

addition:
    call add_operation     
    jmp display_result
    
multiplication:
    call mult     
    jmp display_result
    
substraction:
    call substr     
    jmp display_result

mult:
    movzx ax, byte [num1]   ; zero extend the value of num1 into ax
    mul byte [num2] 

    mov [result], ax       ; Store the 16 bit result in our variable
    ret

substr:
    sub al, byte [num2]    ; subtract num2 from num1 (al contains num1 value)
    mov [result], ax       ; store the result in our variable
    ret

add_operation:
    add al, byte [num2]    ; add num2 to num1 (al contains num1 value)
    mov [result], ax       
    ret

display_result:
    mov ax, [result]       ; load the 16 bit result into ax
    call int_to_str        ; convert ax to string and store it in result_str

    mov ecx, result_str   
    mov edx, result_end - result_str   
    mov ebx, 1             ; stdout (1)
    mov eax, 4             ; sys_write
    int 80h

    mov ebx, 0
    mov eax, 1             ; sys_exit
    int 80h

int_to_str:
    mov edi, result_str    ; destination index for the string
    mov ebx, 10            ; b10 for decimal conversion
    mov ecx, 0             ; clear ecx for the loop count

int_to_str_loop:
    xor edx, edx           ; clear dx for division
    div ebx                ; divide ax by 10, quotient in ax, remainder in dx
    add dl, '0'            ; convert remainder to ASCII
    push dx                ; push the ASCII character onto the stack
    inc ecx                ; increment loop count

    cmp ax, 0              ; check if quotient becomes zero
    jnz int_to_str_loop    ; jump if not zero

int_to_str_pop:
    pop dx                 ; pop the ascii character from the stack into dx
    mov [edi], dl          ; store the character in the result string
    inc edi                ; move to the next character in the string
    loop int_to_str_pop    ; continue until all characters are retrieved from the stack

    mov byte [edi], 0      ; null-terminate the string
    ret                    ; return from the function
