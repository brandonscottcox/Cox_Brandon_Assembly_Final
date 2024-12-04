.model flat

extern printLine: near
extern newline: near
extern writeNumber: near
extern nameTitle: near
extern roundCounter: DWORD
extern player: DWORD

PUBLIC board

.data
    boardIndex DWORD 0 ; holds current board index

    boardBuffer DB ?, 0 ; buffer used for user input
    space DB '  ', 0    ; variable used spaces for array and UI
    line DB '|', 0      ; variable used for lines inbetween array and UI 
    bar DB        "  |-----|-----|-----|-----|-----|", 0    ; variable used for UI
    barLetters DB "     A     B     C     D     E", 0       ; variable used for UI
    row DWORD 1 ; variable that holds row for UI

    ; array that holds game data, starts by holding empty spaces
    board DB    ' ', ' ', ' ', ' ', ' ',     
                ' ', ' ', ' ', ' ', ' ',     
                ' ', ' ', ' ', ' ', ' ',     
                ' ', ' ', ' ', ' ', ' ',     
                ' ', ' ', ' ', ' ', ' '  

    playerTitle DB "      - Player ", 0 ;UI
    roundTitle DB  "- Round ", 0        ;UI
    endDash DB "-", 0                   ;UI

.code

output PROC near

    LOCAL i:DWORD

    call newline

    call nameTitle ; function for title of game UI

    call newline
    call newline
    call newline

    call gameData ; function that holds information about game, round, and current player UI

    mov i, 0 ; sets ecx to 0 which will be our loop condition (how many times we loop)
    loop_start:
        cmp i, 25    ; compares eax register (i) with 25
        jge end_loop   ; ends loop if i >= 25

            ; if (output loop is on 5(n) iterations)
            mov eax, i
            xor edx, edx  ; Clear edx for division
            mov ebx, 5 
            div ebx     ; eax / ebx, remainder in edx
            cmp edx, 0
            jne if_skip ; jump if not equal

                call newline

  	            push offset bar
                call printLine ; prints bar for UI

                call newline

                push row
                call writeNumber  ; prints row number for UI
                inc row ; increases row per iteration to print correct row UI

                push offset line
                call printLine  ; prints line for UI

            if_skip: ; if not on 5(n) iteration

            push [boardIndex]
            call printIndex ; prints current board index

            inc i                     ; Increment loop counter
            inc boardIndex            ; Increment board index
            jmp loop_start            ; Repeat loop
    end_loop:

    call newline

    push offset bar
    call printLine ; prints bar UI

    call newline

    push offset barLetters
    call printLine ; prints column letters

    call newline

    mov row, 1 ; reset row for reprint
    mov boardIndex, 0 ; reset boardIndex for reprint


    ret

output ENDP

; function that prints array index
printIndex PROC near

    push offset space
    call printLine  ; prints space for UI

    mov eax, offset board
    add eax, [esp + 4]           ; move array index as parameter into eax
    mov al, [eax]                ; load the character into al (lower 8 bits)

    cmp al, '*'                  ; compare current index with character '*' to hide bombs from users
    jne not_bomb                 ; jump to not_bomb label if not not equal
    mov al, ' '                  ; if '*' exists replace with ' ' 

    not_bomb:
        mov boardBuffer, al
        ;mov boardBuffer + 1 , 0 ; Add null terminator to determine the end of string
        push offset boardBuffer
        call printLine  ; print index of board aray

        push offset space
        call printLine ; print space for UI

        push offset line
        call printLine ; print line for UI

        ret 4

printIndex ENDP

; function that prints game data on top of board
gameData PROC near

    push offset playerTitle
    call printLine  ; prints player title UI

    push player
    call writeNumber    ; prints current player for UI

    push offset roundTitle
    call printLine  ; prints title for round UI

    mov eax, roundCounter
    push eax
    call writeNumber    ; prints current round for UI

    push offset endDash
    call printLine      ; prints dash for UI

    call newline

    ret

gameData ENDP

END