.model flat

extern   _ExitProcess@4: near
extern writeline: near
extern charCount: near
extern readline: near

.data    
	newlineVar db 0Dh, 0Ah, 0  ; CR + LF + null terminator
	stringAddress DWORD ? ; used to store address for strings
	inputBuffer DWORD ? ; buffer used for user input
	numCharsToRead DWORD 1024

.code
newline PROC near
_newline:
    push offset newlineVar
    call charCount			; gets number of characters
    push eax				; push charCount to eax
    push offset newlineVar
    call writeline

	ret
newline ENDP

printLine PROC near
_printLine:
    mov eax, [esp + 4]       ; Load the string address from the stack into EAX
	mov stringAddress, eax

	push stringAddress
	call charCount

	push eax
    push [esp + 8]           ; Push the string address again (still on stack)
	call writeline

	ret 4 ; pops return address and cleans up 4 bytes from the stack
printLine ENDP

input PROC near
_input:

    call readline

    mov  inputBuffer, eax
    push numCharsToRead
    push inputBuffer
    call writeline

	ret
input ENDP

cursorPosition PROC near
	push [esp + 4]
	call charCount

	push eax
	push [esp + 8]
	call writeline


	push [esp + 8]
	call charCount

	push eax
	push [esp + 12]
	call writeline

	ret 8
cursorPosition ENDP

END