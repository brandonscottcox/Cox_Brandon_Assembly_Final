.model flat

includelib msvcrt.lib
includelib ucrt.lib
	
extern _rand: near

extern board: near
extern xCounter: DWORD
extern oCounter: DWORD

PUBLIC bombCounter

.data
	bombCounter BYTE 0					; variable used to store total bomb count
	randomIndex DWORD ?					; index to store random number

.code

initializeBoard PROC near

	loop_start:
		cmp bombCounter, 4				; checks bombCounter for loop iteration
		jg loop_end						; jump if greater to loop_end label

		call _rand						; call _rand library function to generate random number
		mov ecx, 25						; move 25 into ecx (used as divisor) ; 25 is length of array
		xor edx, edx					; zero out edx (clear edx)
		div ecx							; divide eax by ecx
		mov randomIndex, edx			; store remainder into randomIndex variable

		mov dl, '*'						; move '*' into dl register

		; check if index has a bomb
		mov esi, offset board			; load base address of board into esi
		add esi, randomIndex			; add random index to esi    
		mov al, byte ptr [esi]			; move dereferenced pointer into al
		cmp al, '*'						; check if board index holds '*'
		je loop_start					; jump if equal to loop_start label

		mov byte ptr [esi], dl			; change the value at board index to '*'

		inc bombCounter					; increment bombCounter for loop iteration
		jmp loop_start					; jump back to start of loop

	loop_end:

		ret

initializeBoard ENDP

randomize PROC near
	LOCAL xIndex:DWORD					; local variable to loop for X character
	LOCAL oIndex:DWORD					; local variable to loop for O character
	LOCAL bombIndex:BYTE				; local variable to loop for * character

	mov xIndex, 0
	mov oIndex, 0
	mov al, bombCounter					; store bombCounter into lower 8 bit register ; keeps track of total bombs
	mov bombIndex, al					; move value into bombIndex

	call clearBoard						; function that clears and resets the board array

		loop_X:
			mov eax, xIndex				; move xIndex into eax register
			cmp eax, xCounter			; compare xIndex with xCounter
			jge loop_O					; jump if greater than or equal to loop_O label

			call _rand					; call to _rand library function
			mov ecx, 25					; move 25 into ecx for total loop amount
			xor edx, edx				; zero extend edx
			div ecx						; divide eax by ecx
			mov randomIndex, edx		; move remainder into randomIndex

			; check if index has an X
			mov esi, offset board		; load base address of board into esi
			add esi, randomIndex		; add randomIndex into source index pointer
			mov al, byte ptr [esi]		; move character from dereferenced pointer into al
			cmp al, ' '					; check if index position is ' '
			jne loop_X					; jump if not equal to loop_X label

			mov dl, 'X'					; move 'X' into dl register
			mov byte ptr [esi], dl		; move character into into souce index pointer

			inc xIndex					; increment xIndex
			jmp loop_X					; jump to loop_X label

		loop_O:
			mov eax, oIndex				; move oIndex into eax register
			cmp eax, oCounter			; compare oCounter and xCounter
			jge place_bomb				; jump if greater than or equal

			call _rand					; call to _rand library function
			mov ecx, 25					; move 25 into ecx for total loop amount
			xor edx, edx				; zero extend edx
			div ecx						; divide eax by ecx
			mov randomIndex, edx		; store remainder in randomIndex

			; check if index has a bomb
			mov esi, offset board		; load base address of board into esi
			add esi, randomIndex		; add randomIndex into source index pointer
			mov al, byte ptr [esi]		; move character from dereferenced pointer into al
			cmp al, ' '					; check if index position is ' '
			jne loop_O					; jump if not equal to loop_O label
			
			mov dl, 'O'					; move 'X' into dl register
			mov byte ptr [esi], dl		; move character into into souce index pointer

			inc oIndex					; increment oIndex
			jmp loop_O					; jump to loop_O label

		place_bomb:
			mov al, bombIndex			; move bombIndex into al register
			cmp bombIndex, 1			; compares bombIndex with 1
			jl loop_end					; jump if less than to loop_end label

			call _rand					; call to _rand library function
			mov ecx, 25					; move 25 into ecx for total loop amount
			xor edx, edx				; zero extand edx
			div ecx						; divide eax by ecx
			mov randomIndex, edx		; move remainder into randomIndex

			; check if index has a bomb
			mov esi, offset board		; load base address of board into esi
			add esi, randomIndex		; add randomIndex to esi register
			mov al, byte ptr [esi]		; move character from dereferenced pointer into al
			cmp al, ' '					; check if index position is ' '
			jne place_bomb				; jump if not equal to place_bomb label
			
			mov dl, '*'					; move '*' into dl
			mov byte ptr [esi], dl		; move character into into souce index pointer

			dec bombIndex				; decrement bombIndex
			jmp place_bomb				; jump to place_bomb label

	loop_end:

		ret

randomize ENDP

clearBoard PROC near

	LOCAL i:DWORD						; local variable used for loop index
	mov i, 0							; move 0 into i

	loop_start:						
		cmp i, 25						; compare i with 25
		jge loop_end					; jump if greater than or equal to loop_end label

		mov esi, offset board			; store memory address of board into source index register
		mov eax, i						; move i into eax
		mov dl, ' '						; move ' ' into dl register
		mov byte ptr [esi + eax], dl	; move ' ' into board index plus loop index

		inc i							; increment loop index
		jmp loop_start					; jump to loop_start label

	loop_end:

		ret

clearBoard ENDP

END