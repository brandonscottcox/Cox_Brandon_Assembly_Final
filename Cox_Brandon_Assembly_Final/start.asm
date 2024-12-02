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
    call initialize_console       ; Call to set up the console for output
        
    call nameTitle

    call newline
    call newline

    push offset enterPrompt
    call printLine

    call input

    ret
startScreen ENDP

nameTitle PROC near

    push offset titleBar
    call printLine

    call newline

    push offset titlePrompt
    call printLine

    call newline

    push offset titleBar
    call printLine

    ret

nameTitle ENDP

END