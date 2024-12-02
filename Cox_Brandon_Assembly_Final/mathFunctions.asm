.model flat

extern readBuffer: near

;PUBLIC result

.data


.code
convertString PROC near

    mov esi, offset readBuffer            ; point to the input string (readBuffer)
    mov eax, 0                            ; clear eax (will hold the result)

convert_loop:
    mov edx, 0                            ; clear edx
    mov dl, [esi]                         ; move first character of buffer into dl (lower 8 bits of edx)
    cmp edx, 0                            ; check for null terminator
    jz exit                               ; if edx is zero jump to loop exit

    ; error handling
    cmp edx, '0'                          ; check if edx is a number character
    jl skip                               ; skip if less than '0'
    cmp edx, '9'                          ; check if edx is a number character
    jg skip                               ; skip if greater than '9'

    sub edx, '0'                          ; convert ASCII '0'-'9' to numerical value
    imul eax, eax, 10                     ; multiply the current result in EAX by 10
    add eax, edx                          ; add the current digit to the result

skip:
    inc esi                               ; move to the next character in the string
    jmp convert_loop                      ; repeat for next character

exit:
    ; eax holds the converted integer value.

    ret

convertString ENDP

END