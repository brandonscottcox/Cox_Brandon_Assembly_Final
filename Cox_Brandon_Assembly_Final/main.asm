; MASM Template
; Brandon Cox
; 2024.09.19
; Create a template for assembler files.
.model flat

extern _ExitProcess@4: near

extern startScreen: near
extern output: near
extern makeMove: near
extern writeNumber: near
extern newline: near
extern clearConsole: near
extern checkWin: near
extern seed_rng: near
extern initializeBoard: near

PUBLIC player
PUBLIC roundCounter

.data
	player DWORD 2          ; Declares a 4-byte integer (32 bits) initialized to 1)
	roundCounter DWORD 1          ; Declares a 1-byte integer (8 bits) initialized to 1 (BYTE range signed (-128 - 127))

.code



main PROC near

	LOCAL i:DWORD

	call seed_rng
	call initializeBoard

	call startScreen

	mov i, 0 ; sets ecx to 0 which will be our loop condition (how many times we loop)

	loop_start:
		cmp i, 25    ; compares eax register (i) with 25
        jge end_loop   ; ends loop if i >= 25

			mov eax, player     ; Load current value of player
			xor eax, 3          ; XOR with 3 (toggles between 1 and 2)
			mov player, eax     ; Store the new value back in player		
			
			call makeMove

			call checkWin

			call clearConsole

			inc roundCounter
			inc i              ; Increment loop counter


		jmp loop_start     ; Decrement ecx, and jump to loop_start if ecx != 0

	end_loop:

	call clearConsole
	call output


	push	0
	call	_ExitProcess@4

	ret

main ENDP

END