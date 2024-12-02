.model flat

extern printLine: near
extern readBuffer: near
extern writeNumber: near
extern convertString: near
extern readBuffer: near
extern newline: near
extern bombCounter: BYTE

.data
indexPrompt DB "Index: ", 0
rowStartPrompt DB "rowStart: ", 0
addIndexPrompt DB "Index + 3: ", 0
addRowPrompt DB "rowStart + 3: ", 0
bombPrompt DB "Bomb Counter: ", 0

.code

debugWin PROC near

			push offset rowStartPrompt
			call printLine
			push [esp + 4]
			call writeNumber

			call newline

			push offset indexPrompt
			call printLine
			push [esp + 8]
			call writeNumber

			call newline

			; Debug: Print index + 3
			push offset addIndexPrompt
			call printLine
			mov eax, [esp + 8]
			add eax, 3
			push eax
			call writeNumber

			call newline

			; Debug: Print rowStart + 5
			push offset addRowPrompt
			call printLine
			mov eax, [esp + 4]
			add eax, 5
			push eax
			call writeNumber

			call newline
			call newline


			ret 8

debugWin ENDP

debugChar PROC near
	;--------------
	;prints character to console
	push eax
	call printLine
	;--------------
	;prints ascii value to console for error handling
	mov esi, offset readBuffer
	mov al, [esi]
	movzx eax, al               ; Zero-extend AL into EAX

	push eax
	call writeNumber
	;--------------

	ret
debugChar ENDP

;-----------------------------

debugNum PROC near
	;--------------
	;prints number to console
	call convertString
	push eax
	call writeNumber
	;--------------
	;prints ascii value to console for error handling
	mov esi, offset readBuffer
	mov al, [esi]
	movzx eax, al               ; Zero-extend AL into EAX

	push eax
	call writeNumber
	;--------------

	ret
debugNum ENDP

debugBomb PROC near

	push offset bombPrompt
	call printLine

	mov al, bombCounter
	push eax			;debugging
	call writeNumber	;debugging

	call newline			;debugging
	call newline			;debugging

	ret

debugBomb ENDP

END