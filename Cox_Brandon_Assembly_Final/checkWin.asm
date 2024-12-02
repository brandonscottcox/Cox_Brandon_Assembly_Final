.model flat

extern _ExitProcess@4: near
extern board: near
extern printLine: near
extern newline: near
extern spaceType: DWORD
extern writeNumber: near
extern readline: near
extern clearConsole: near
extern output: near

extern debugWin: near

.data    
winFlag DB 0  ; Boolean variable initialized to false (0)
index DWORD 0

bar DB        "       |--------------------|", 0
player1Win DB "       | - Player 1 Wins! - |", 0
player2Win DB "       | - Player 2 Wins! - |", 0


.code
checkWin PROC near
    call checkWinLogic

    cmp winFlag, 1
    jl noWin

    cmp spaceType, 'X'
    je xWin
    cmp spaceType, 'O'
    je oWin

    xWin:
		call clearConsole

		call output
		call newline
		call newline

		push offset bar
		call printline

		call newline

        push offset player1Win
        call printLine

		call newline

		push offset bar
		call printline

		call newline
		call newline

        push	0
	    call	_ExitProcess@4

        ret
    oWin:
		call clearConsole

		call output
		call newline
		call newline

		push offset bar
		call printline

		call newline

        push offset player2Win
        call printLine

		call newline

		push offset bar
		call printline

		call newline
		call newline

        push	0
	    call	_ExitProcess@4

        ret

    noWin:

        ret
checkWin ENDP

checkWinLogic PROC near
	
    mov byte ptr winFlag, 0    ; Reset winFlag to 0

	mov esi, offset board          ; Load board base address

    ; Extract the LSB of spaceType
    mov eax, spaceType         ; Load full DWORD spaceType into EAX
    movzx ebx, al              ; Extract the LSB into EBX (zero-extended)

	call horizontalCheck
	call verticalCheck
	call rightDiagnalCheck
	call leftDiagnalCheck

	ret

checkWinLogic ENDP

horizontalCheck PROC near

	LOCAL rowStart:DWORD
	
	mov index, 0
	mov rowStart, 0

	loop_start:
		cmp index, 24           ; Last valid starting index for horizontal check
		jg loop_exit            ; Exit loop if out of bounds
		
		push ebx			; save ebx which stores data of current character

		; Calculate rowStart
		mov eax, index
		mov ecx, 5              ; NUM_COLS = 5
		xor edx, edx            ; Clear edx for division
		div ecx                 ; eax = index / NUM_COLS, edx = index % NUM_COLS
		imul eax, ecx           ; eax = (index / NUM_COLS) * NUM_COLS
		mov rowStart, eax       ; Save row start index

		; Boundary Check
		mov eax, index
		add eax, 3              ; index + 3

		mov ebx, rowStart          ; Load rowStart into ebx
		add ebx, 5                 ; Calculate rowStart + 5
		cmp eax, ebx   ; Ensure within row bounds

		pop ebx			; restore original ebx value
		jg next_index          ; Skip if out of bounds

		; ===== Horizontal Check =====
		; Check 4 consecutive cells in the row	
		mov eax, index            ; Load the value of index
		mov al, byte ptr [esi + eax] ; Access board[index]
		cmp al, bl
		jne next_index          ; If not equal, skip

		mov eax, index            ; Load the value of index
		add eax, 1
		mov al, byte ptr [esi + eax] ; Access board[index]		
		cmp al, bl
		jne next_index          ; If not equal, skip

		mov eax, index            ; Load the value of index
		add eax, 2
		mov al, byte ptr [esi + eax] ; Access board[index]		
		cmp al, bl
		jne next_index          ; If not equal, skip

		mov eax, index            ; Load the value of index
		add eax, 3
		mov al, byte ptr [esi + eax] ; Access board[index]		
		cmp al, bl
		jne next_index          ; If not equal, skip

		; Win detected
		mov byte ptr winFlag, 1 ; Set winFlag to 1
		jmp loop_exit           ; Exit early

	next_index:
		inc index               ; Increment index
		jmp loop_start          ; Continue loop

	loop_exit:
		ret                     ; Return

horizontalCheck ENDP

verticalCheck PROC near	
	mov index, 0

	loop_start:
		cmp index, 24           ; Last valid starting index for horizontal check
		jg loop_exit            ; Exit loop if out of bounds

		; ===== Vertical Check =====
		; Ensure index + 15 is within bounds (NUM_COLS * 3 = 15 for a 5x5 board)
		mov eax, index            ; Load the value of index
		mov al, byte ptr [esi + eax] ; Access board[index]
		cmp al, bl
		jne next_index          ; If not equal, skip

		mov eax, index            ; Load the value of index
		add eax, 5
		mov al, byte ptr [esi + eax] ; Access board[index]		
		cmp al, bl
		jne next_index          ; If not equal, skip

		mov eax, index            ; Load the value of index
		add eax, 10
		mov al, byte ptr [esi + eax] ; Access board[index]		
		cmp al, bl
		jne next_index          ; If not equal, skip

		mov eax, index            ; Load the value of index
		add eax, 15
		mov al, byte ptr [esi + eax] ; Access board[index]		
		cmp al, bl
		jne next_index          ; If not equal, skip

		; Win detected
		mov byte ptr winFlag, 1 ; Set winFlag to 1
		jmp loop_exit           ; Exit early

	next_index:
		inc index               ; Increment index
		jmp loop_start          ; Continue loop

	loop_exit:
		ret                     ; Return


verticalCheck ENDP

rightDiagnalCheck PROC near

	mov index, 0

	loop_start:
		cmp index, 24           ; Last valid starting index for horizontal check
		jg loop_exit            ; Exit loop if out of bounds

		; ===== Diagonal Check =====
		mov eax, index            ; Load the value of index
		mov al, byte ptr [esi + eax] ; Access board[index]
		cmp al, bl
		jne next_index          ; If not equal, skip

		mov eax, index            ; Load the value of index
		add eax, 6
		mov al, byte ptr [esi + eax] ; Access board[index]		
		cmp al, bl
		jne next_index          ; If not equal, skip

		mov eax, index            ; Load the value of index
		add eax, 12
		mov al, byte ptr [esi + eax] ; Access board[index]		
		cmp al, bl
		jne next_index          ; If not equal, skip

		mov eax, index            ; Load the value of index
		add eax, 18
		mov al, byte ptr [esi + eax] ; Access board[index]		
		cmp al, bl
		jne next_index          ; If not equal, skip

		; Win detected
		mov byte ptr winFlag, 1 ; Set winFlag to 1
		jmp loop_exit           ; Exit early

	next_index:
		inc index               ; Increment index
		jmp loop_start          ; Continue loop

	loop_exit:
		ret                     ; Return

rightDiagnalCheck ENDP

leftDiagnalCheck PROC near
	
	mov index, 0

	loop_start:
		cmp index, 24           ; Last valid starting index for horizontal check
		jg loop_exit            ; Exit loop if out of bounds

		; ===== Diagonal Check =====
		mov eax, index            ; Load the value of index
		mov al, byte ptr [esi + eax] ; Access board[index]
		cmp al, bl
		jne next_index          ; If not equal, skip

		mov eax, index            ; Load the value of index
		add eax, 4
		mov al, byte ptr [esi + eax] ; Access board[index]		
		cmp al, bl
		jne next_index          ; If not equal, skip

		mov eax, index            ; Load the value of index
		add eax, 8
		mov al, byte ptr [esi + eax] ; Access board[index]		
		cmp al, bl
		jne next_index          ; If not equal, skip

		mov eax, index            ; Load the value of index
		add eax, 12
		mov al, byte ptr [esi + eax] ; Access board[index]		
		cmp al, bl
		jne next_index          ; If not equal, skip

		; Win detected
		mov byte ptr winFlag, 1 ; Set winFlag to 1
		jmp loop_exit           ; Exit early

	next_index:
		inc index               ; Increment index
		jmp loop_start          ; Continue loop

	loop_exit:
		ret                     ; Return

leftDiagnalCheck ENDP

END