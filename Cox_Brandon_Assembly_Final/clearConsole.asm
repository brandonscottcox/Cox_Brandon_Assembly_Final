.model flat

includelib kernel32.lib

EXTERNDEF _GetStdHandle@4: PROC
EXTERNDEF _GetConsoleScreenBufferInfo@8: PROC
EXTERNDEF _FillConsoleOutputCharacterA@20: PROC
EXTERNDEF _SetConsoleCursorPosition@8: PROC

extern newline: near
extern cursorPosition: near

.data
	escCodeUp db 27, '[', '10', 'A', 0     ; ESC[1A moves the cursor up 1 line
	escCodeLeft db 27, '[', '0', 'A', 0     ; ESC[1A moves the cursor up 1 line


    consoleHandle DWORD ?          ; To store the console output handle
    charsWritten DWORD ?           ; Number of characters written
    consoleSize DWORD ?            ; Total size of the console

    ; Define COORD structure using WORD
    coord STRUCT
        X WORD 0                  ; X-coordinate of cursor
        Y WORD 0                  ; Y-coordinate of cursor
    coord ENDS

    cursor coord <>                ; Cursor position (0,0)

    ; Define CONSOLE_SCREEN_BUFFER_INFO structure
    CONSOLE_SCREEN_BUFFER_INFO STRUCT
        dwSize coord <>            ; Buffer size (width and height)
        dwCursorPosition coord <>  ; Cursor position
        wAttributes WORD ?         ; Text attributes
        srWindowTop WORD ?         ; Window top coordinate
        srWindowLeft WORD ?        ; Window left coordinate
        srWindowBottom WORD ?      ; Window bottom coordinate
        srWindowRight WORD ?       ; Window right coordinate
        dwMaximumWindowSize coord <> ; Maximum window size
    CONSOLE_SCREEN_BUFFER_INFO ENDS

    consoleBufferInfo CONSOLE_SCREEN_BUFFER_INFO <>  ; Buffer info structure



    sequence db 27, '[', '2', 'J', 0
    originalMode dq 0

.code

clearConsole PROC near


    call newline
    call newline
    call newline
    call newline
    call newline
    call newline
    call newline
    call newline
    call newline
    call newline
    call newline
    call newline
    call newline
    call newline
    call newline
    call newline
    call newline
    call newline
    call newline
    call newline
    call newline
    call newline
    call newline

    ret

clearConsole ENDP


testClearConsole PROC near

    ; Get the console output handle
    push -11                       ; STD_OUTPUT_HANDLE
    call _GetStdHandle@4
    mov consoleHandle, eax         ; Store the handle in consoleHandle

    ; Retrieve the console screen buffer info
    lea eax, consoleBufferInfo     ; Address of the buffer info structure
    push eax
    push consoleHandle             ; Console handle
    call _GetConsoleScreenBufferInfo@8

    ; Debug: Check if we successfully retrieved buffer info
    test eax, eax
    jz failed                            ; If failed, skip further execution

    ; Calculate the total size of the console
    movzx eax, consoleBufferInfo.dwSize.X ; Buffer width
    movzx ecx, consoleBufferInfo.dwSize.Y ; Buffer height
    mul ecx                          ; Width * Height
    mov consoleSize, eax             ; Store total size in consoleSize

    ; Fill the console with spaces to clear it
    push offset charsWritten         ; Address to store number of chars written
    push consoleSize                 ; Total console size
    push ' '                         ; Space character
    lea eax, cursor                  ; Start clearing from top-left corner (0,0)
    push eax
    push consoleHandle               ; Console handle
    call _FillConsoleOutputCharacterA@20

    ; Reset the cursor to the top-left corner
    lea eax, cursor                  ; Top-left corner (0,0)
    push eax
    push consoleHandle
    call _SetConsoleCursorPosition@8

    ret

    failed:
    ; Debugging: Add a breakpoint or some indicator if clearing fails
    ret

testClearConsole ENDP

xx PROC near

    call newline
    call newline
    call newline
    call newline
    call newline
    call newline
    call newline
    call newline
    call newline
    call newline
    call newline
    call newline
    call newline
    call newline
    call newline
    call newline
    call newline
    call newline
    call newline
    call newline
    call newline
    call newline
    call newline

    ret
xx ENDP

END