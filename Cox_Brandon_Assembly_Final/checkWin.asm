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

    call checkWinLogic					; function to check four in a row

    cmp winFlag, 1						; check if winFlag is set to true
    jl noWin							; jump if false to noWin label

    cmp spaceType, 'X'					; checks if current spaceType is 'X'
    je xWin								; jump to xWin label
    cmp spaceType, 'O'					; checks if current spaceType is 'O'
    je oWin								; jump to oWin label

    xWin:
		call clearConsole				; clear console

		call output						; print board
		call newline
		call newline

		push offset bar					
		call printline					; print bar UI

		call newline

        push offset player1Win	
        call printLine					; print player1Win prompt

		call newline

		push offset bar					
		call printline					; print bar UI

		call newline
		call newline

        push	0
	    call	_ExitProcess@4			; exit program

        ret
    oWin:
		call clearConsole				; clear console

		call output						; print board
		call newline
		call newline

		push offset bar					
		call printline					; print bar UI

		call newline

        push offset player2Win
        call printLine					; print player2Win prompt

		call newline

		push offset bar					; print bar UI
		call printline

		call newline
		call newline

        push	0	
	    call	_ExitProcess@4			; exit program

        ret

    noWin:

        ret

checkWin ENDP

checkWinLogic PROC near
	
    mov byte ptr winFlag, 0				; reset winFlag to 0

	mov esi, offset board				; load board base address

    mov eax, spaceType					; load spaceType into eax
    movzx ebx, al						; zero extend ebx and move al into ebx

	call horizontalCheck				; checks if horizontal win
	call verticalCheck					; checks if vertical win
	call rightDiagnalCheck				; checks if right diagnal win
	call leftDiagnalCheck				; checks if left diagnal win

	ret

checkWinLogic ENDP

horizontalCheck PROC near

	LOCAL rowStart:DWORD				; variable to hold start of row
	
	mov index, 0						; move 0 into loop index
	mov rowStart, 0						; move 0 into rowStart

	loop_start:
		cmp index, 24					; compare index with 24
		jg loop_exit					; jump if greater than to loop_exit label
		
		push ebx						; save ebx which stores data of current character

		; Calculate rowStart
		mov eax, index					; move loop index into eax
		mov ecx, 5						; move 5 into ecx
		xor edx, edx					; zero extend edx
		div ecx							; divide eax by ecx
		imul eax, ecx					; multiply quotient by ecx
		mov rowStart, eax				; move eax into rowStart

		; Boundary Check
		mov eax, index					; move loop index into eax
		add eax, 3						; add 3 to eax

		mov ebx, rowStart				; move rowStart into ebx
		add ebx, 5						; add 5 to ebx
		cmp eax, ebx					; compare ebx and eax

		pop ebx							; return original value to ebx
		jg next_index					; jump if greater to next_index

		; ===== Horizontal Check =====
		mov eax, index					; move index into eax
		mov al, byte ptr [esi + eax]	; move board pointer plus index into al
		cmp al, bl						; compare al with spacetype
		jne next_index					; jump if not equal to next_index

		mov eax, index					; move index into eax
		add eax, 1						; add 1 to eax for next index
		mov al, byte ptr [esi + eax]	; move board pointer plus index into al
		cmp al, bl						; compare al with spacetype
		jne next_index					; jump if not equal to next_index

		mov eax, index					; move index into eax
		add eax, 2						; add 2 to eax for next index
		mov al, byte ptr [esi + eax]	; move board pointer plus index into al	
		cmp al, bl						; compare al with spacetype
		jne next_index					; jump if not equal to next_index

		mov eax, index					; move index into eax
		add eax, 3						; add 3 to eax for next index
		mov al, byte ptr [esi + eax]	; move board pointer plus index into al
		cmp al, bl						; compare al with spacetype
		jne next_index					; jump if not equal to next_index

		; Win detected
		mov byte ptr winFlag, 1			; set winFlag to true
		jmp loop_exit					; jump to loop_exit label

	next_index:
		inc index						; increment loop index
		jmp loop_start					; jump to loop_start label

	loop_exit:
		ret                     

horizontalCheck ENDP

verticalCheck PROC near	
	mov index, 0						; move 0 to loop index

	loop_start:
		cmp index, 24					; compare loop index with 24
		jg loop_exit					; jump if greater than to loop_exit label

		; ===== Vertical Check =====
		mov eax, index					; move loop index into eax
		mov al, byte ptr [esi + eax]	; move board pointer plus index into al
		cmp al, bl						; compare al with spacetype
		jne next_index					; jump if not equal to next_index

		mov eax, index					; move loop index into eax
		add eax, 5						; add 5 to eax for next row
		mov al, byte ptr [esi + eax]	; move board pointer plus index into al
		cmp al, bl						; compare al with spacetype
		jne next_index					; jump if not equal to next_index

		mov eax, index					; move loop index into eax
		add eax, 10						; add 10 to eax for next row
		mov al, byte ptr [esi + eax]	; move board pointer plus index into al
		cmp al, bl						; compare al with spacetype
		jne next_index					; jump if not equal to next_index

		mov eax, index					; move loop index into eax
		add eax, 15						; add 15 to eax for next row
		mov al, byte ptr [esi + eax]	; move board pointer plus index into al
		cmp al, bl						; compare al with spacetype
		jne next_index					; jump if not equal to next_index

		; Win detected
		mov byte ptr winFlag, 1			; set winFlag to true
		jmp loop_exit					; jump to loop_exit label

	next_index:
		inc index						; increment loop index
		jmp loop_start					; jump to loop_start

	loop_exit:
		ret                     


verticalCheck ENDP

rightDiagnalCheck PROC near

	mov index, 0						; move 0 into loop index

	loop_start:
		cmp index, 24					; compare loop index with 24
		jg loop_exit					; jump if greater than to loop_exit label

		; ===== Diagonal Check =====
		mov eax, index					; move loop index into eax
		mov al, byte ptr [esi + eax]	; move board pointer plus index into al
		cmp al, bl						; compare al with spacetype
		jne next_index					; jump if not equal to next_index

		mov eax, index					; move loop index into eax
		add eax, 6						; add 6 to eax for correct diagnal space
		mov al, byte ptr [esi + eax]	; move board pointer plus index into al
		cmp al, bl						; compare al with spacetype
		jne next_index					; jump if not equal to next_index

		mov eax, index					; move loop index into eax
		add eax, 12						; add 12 to eax for correct diagnal space
		mov al, byte ptr [esi + eax]	; move board pointer plus index into al
		cmp al, bl						; compare al with spacetype
		jne next_index					; jump if not equal to next_index

		mov eax, index					; move loop index into eax
		add eax, 18						; add 18 to eax for correct diagnal space
		mov al, byte ptr [esi + eax]	; move board pointer plus index into al
		cmp al, bl						; compare al with spacetype
		jne next_index					; jump if not equal to next_index

		; Win detected
		mov byte ptr winFlag, 1			; set winFlag to true
		jmp loop_exit					; jump to loop_exit label

	next_index:
		inc index						; increment loop index
		jmp loop_start					; jump to loop_start

	loop_exit:
		ret                     

rightDiagnalCheck ENDP

leftDiagnalCheck PROC near
	
	mov index, 0						; move 0 into loop index
	
	loop_start:
		cmp index, 24					; compare loop index with 24
		jg loop_exit					; jump if greater than to loop_exit label

		; ===== Diagonal Check =====
		mov eax, index					; move loop index into eax
		mov al, byte ptr [esi + eax]	; move board pointer plus index into al
		cmp al, bl						; compare al with spacetype
		jne next_index					; jump if not equal to next_index

		mov eax, index					; move loop index into eax
		add eax, 4						; add 4 to eax for correct diagnal space
		mov al, byte ptr [esi + eax]	; move board pointer plus index into al
		cmp al, bl						; compare al with spacetype
		jne next_index					; jump if not equal to next_index

		mov eax, index					; move loop index into eax
		add eax, 8						; add 8 to eax for correct diagnal space
		mov al, byte ptr [esi + eax]	; move board pointer plus index into al
		cmp al, bl						; compare al with spacetype
		jne next_index					; jump if not equal to next_index

		mov eax, index					; move loop index into eax
		add eax, 12						; add 12 to eax for correct diagnal space
		mov al, byte ptr [esi + eax]	; move board pointer plus index into al
		cmp al, bl						; compare al with spacetype
		jne next_index					; jump if not equal to next_index

		; Win detected
		mov byte ptr winFlag, 1			; set winFlag to true
		jmp loop_exit					; jump to loop_exit label

	next_index:
		inc index						; increment loop index
		jmp loop_start					; jump to loop_start

	loop_exit:
		ret                    

leftDiagnalCheck ENDP

END