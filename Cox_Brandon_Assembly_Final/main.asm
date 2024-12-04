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
	player DWORD 2					; declares a 4-byte integer (32 bits) initialized to 1)
	roundCounter DWORD 1			; declares a 1-byte integer (8 bits) initialized to 1)

.code

main PROC near

	LOCAL i:DWORD					; local variable used for loop

	call seed_rng					; function used srand and time external library functions
	call initializeBoard			; function used to intializeBoard with bombs

	call startScreen				; starting screen for game

	mov i, 0						; sets ecx to 0 which will be our loop condition (how many times we loop)

	loop_start:
		cmp i, 25					; compares eax register (i) with 25
        jge end_loop				; ends loop if i >= 25

			mov eax, player			; Load current value of player
			xor eax, 3				; XOR with 3 (toggles between 1 and 2)
			mov player, eax			; Store the new value back in player		
			
			call makeMove			; function used for player to make move on the board

			call checkWin			; function used to check the board for win conditions

			call clearConsole

			inc roundCounter		; increases round per iteration of loop
			inc i					; Increment loop counter

		jmp loop_start				; decrement ecx, and jump to loop_start if ecx != 0

	end_loop:

	call clearConsole				; function to clear console
	call output						; output board

	push	0
	call	_ExitProcess@4

	ret

main ENDP

END