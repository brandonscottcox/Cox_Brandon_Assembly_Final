.model flat

extern initialize_console: near
extern writeNumber: near
extern writeline: near
extern charCount: near
extern readline: near
extern newline: near
extern printLine: near
extern input: near

PUBLIC titlePrompt

.data
    titleBar db    "        |-----------------|", 0
    titlePrompt db "        | Tick Tack Boom! |", 0
    enterPrompt db "        Press Enter to Play:", 0

.code

startScreen PROC near
    call initialize_console         ; Call to set up the console for output
        
    call nameTitle                  ; function that prints game title

    call newline
    call newline

    push offset enterPrompt
    call printLine                  ; prints enter prompt

    ; may be redundant
    call input                      ; used to stop program and ask user for input to continue

    ret
startScreen ENDP

nameTitle PROC near

    push offset titleBar
    call printLine                  ; print bar UI

    call newline

    push offset titlePrompt         ; print game title
    call printLine

    call newline

    push offset titleBar            ; print bar UI
    call printLine

    ret

nameTitle ENDP

END