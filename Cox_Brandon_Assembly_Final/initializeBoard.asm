.model flat

includelib msvcrt.lib
includelib ucrt.lib
	
extern _rand: near

extern board: near
extern xCounter: DWORD
extern oCounter: DWORD

PUBLIC bombCounter

.data
	bombCounter BYTE 0
	randomIndex DWORD ?


.code

initializeBoard PROC near

	loop_start:
		cmp bombCounter, 4
		jg loop_end

		call _rand
		mov ecx, 25
		xor edx, edx
		div ecx
		mov randomIndex, edx

		mov dl, '*'

		; check if index has a bomb
		mov esi, offset board     ; Load base address of board into ESI
		add esi, randomIndex            
		mov al, byte ptr [esi]
		cmp al, '*'
		je loop_start

		mov byte ptr [esi], dl   ; Change the value at board[10] to '*'

		inc bombCounter
		jmp loop_start

	loop_end:

		ret

initializeBoard ENDP

randomize PROC near
	LOCAL xIndex:DWORD
	LOCAL oIndex:DWORD
	LOCAL bombIndex:BYTE

	mov xIndex, 0
	mov oIndex, 0
	mov al, bombCounter
	mov bombIndex, al

	call clearBoard

		loop_X:
			mov eax, xIndex
			cmp eax, xCounter
			jge loop_O

			call _rand
			mov ecx, 25
			xor edx, edx
			div ecx
			mov randomIndex, edx

			; check if index has an X
			mov esi, offset board     ; Load base address of board into ESI
			add esi, randomIndex            
			mov al, byte ptr [esi]
			cmp al, ' '
			jne loop_X

			mov dl, 'X'
			mov byte ptr [esi], dl   ; Change the value at board[10] to '*'

			inc xIndex
			jmp loop_X

		loop_O:
			mov eax, oIndex
			cmp eax, oCounter
			jge place_bomb

			call _rand
			mov ecx, 25
			xor edx, edx
			div ecx
			mov randomIndex, edx

			; check if index has a bomb
			mov esi, offset board     ; Load base address of board into ESI
			add esi, randomIndex            
			mov al, byte ptr [esi]
			cmp al, ' '
			jne loop_O  
			
			mov dl, 'O'
			mov byte ptr [esi], dl   ; Change the value at board[10] to '*'

			inc oIndex
			jmp loop_O

		place_bomb:
			mov al, bombIndex
			cmp bombIndex, 1
			jl loop_end

			call _rand
			mov ecx, 25
			xor edx, edx
			div ecx
			mov randomIndex, edx

			; check if index has a bomb
			mov esi, offset board     ; Load base address of board into ESI
			add esi, randomIndex            
			mov al, byte ptr [esi]
			cmp al, ' '
			jne place_bomb 
			
			mov dl, '*'
			mov byte ptr [esi], dl   ; Change the value at board[10] to '*'

			dec bombIndex
			jmp place_bomb

	loop_end:

		ret

	ret
randomize ENDP

clearBoard PROC near
	LOCAL i:DWORD
	mov i, 0

	loop_start:
		cmp i, 25
		jge loop_end

		mov esi, offset board
		mov eax, i
		mov dl, ' '
		mov byte ptr [esi + eax], dl

		inc i
		jmp loop_start
	loop_end:
		ret

clearBoard ENDP


END