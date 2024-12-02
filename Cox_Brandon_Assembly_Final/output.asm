.model flat

extern printLine: near
extern newline: near
extern writeNumber: near
extern nameTitle: near
extern roundCounter: DWORD
extern player: DWORD

PUBLIC board

.data
    boardIndex DWORD 0

    boardBuffer DB ?, 0 ; buffer used for user input
    space DB '  ', 0
    line DB '|', 0
    bar DB        "  |-----|-----|-----|-----|-----|", 0
    barLetters DB "     A     B     C     D     E", 0
    row DWORD 1 

    board DB    ' ', ' ', ' ', ' ', ' ',     
                ' ', ' ', ' ', ' ', ' ',     
                ' ', ' ', ' ', ' ', ' ',     
                ' ', ' ', ' ', ' ', ' ',     
                ' ', ' ', ' ', ' ', ' '  


    playerTitle DB "      - Player ", 0
    roundTitle DB  "- Round ", 0
    endDash DB "-", 0

.code

output PROC near

    LOCAL i:DWORD


    call newline

    call nameTitle

    call newline
    call newline
    call newline

    call gameData

    mov i, 0 ; sets ecx to 0 which will be our loop condition (how many times we loop)
    loop_start:
        cmp i, 25    ; compares eax register (i) with 25
        jge end_loop   ; ends loop if i >= 25

        ;------------------------------------------------
                        ; if (output loop is on 5(n) iterations)
            mov eax, i
            xor edx, edx  ; Clear edx for division
            mov ebx, 5 
            div ebx     ; eax / ebx, remainder in edx
            cmp edx, 0
            jne if_skip ; jump if not equal

                call newline


  	            push offset bar
                call printLine

                call newline

                push row
                call writeNumber
                inc row

                push offset line
                call printLine

        ;------------------------------------------------

            if_skip: ; if not on 5(n) iteration

            push [boardIndex]
            call printIndex

            inc i                     ; Increment loop counter
            inc boardIndex            ; Increment board index
            jmp loop_start            ; Repeat loop
    end_loop:

    call newline

    push offset bar
    call printLine

    call newline

    push offset barLetters
    call printLine

    call newline

    mov row, 1 ; reset row for reprint
    mov boardIndex, 0 ; reset boardIndex for reprint


    ret

output ENDP

printIndex PROC near
_printIndex:

    push offset space
    call printLine

    mov eax, offset board
    add eax, [esp + 4]           ; Offset to the start of Row 2 (row index 1)
    mov al, [eax]        ; Load the character into DL (value 'g')

    cmp al, '*'
    jne not_bomb
    mov al, ' '

    not_bomb:
        mov boardBuffer, al
        mov boardBuffer + 1 , 0 ; Add null terminator
        push offset boardBuffer
        call printLine


        push offset space
        call printLine

        push offset line
        call printLine

        ret 4

printIndex ENDP

gameData PROC near

    push offset playerTitle
    call printLine

    push player
    call writeNumber

    push offset roundTitle
    call printLine

    mov eax, roundCounter
    push eax
    call writeNumber

    push offset endDash
    call printLine

    call newline

    ret

gameData ENDP

END