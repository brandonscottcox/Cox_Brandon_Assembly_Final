.model flat

extern output: near
extern printLine: near
extern newline: near
extern writeNumber: near
extern input: near

extern readline: near
extern convertString: near
extern readBuffer: near
extern writeline: near
extern debugNum: near
extern debugChar: near
extern board: near
extern player: DWORD
extern cursorPosition: near
extern checkWin: near
extern randomize: near
extern bombCounter: BYTE
extern debugBomb: near
extern clearConsole: near

;PUBLIC userCol
;PUBLIC userRow
PUBLIC spaceType
PUBLIC xCounter
PUBLIC oCounter

.data
	spaceType DWORD ? 
	xCounter DWORD 0
	oCounter DWORD 0
	player1Max DWORD 0
	player2Max DWORD 0
	playableSpace DB 0 ; boolean flag set to 0 (false)
	userBoardInput DB ?
	boardIndex DB ?
	bombFlag DB 0  ; Boolean variable initialized to false (0)

	bar DB           "  |-----------------------------|", 0
	player1Prompt DB "  |         - Player X -        |", 0
	player2Prompt DB "  |         - Player O -        |", 0
	askCol DB        "  |Please enter a column to play|", 0
	askCol2 DB       "  |Column (ex. e):              |", 0
	askRow DB        "  |Please enter a row to play   |", 0
	askRow2 DB       "  |Row (ex. 3):                 |", 0
	;userCol DWORD ?
	;userRow DWORD ?
	userSum DWORD 0

	escCodeUp db 27, '[', '1', 'A', 0     ; ESC[1A moves the cursor up 1 line
    escCodeColLeft db 27, '[', '20', 'G', 0   ; ESC[0G moves the cursor to the start of the line
	escCodeRowLeft db 27, '[', '17', 'G', 0   ; ESC[0G moves the cursor to the start of the line

	bar2 DB          "      |---------------------|", 0
	bombHitPrompt DB "      | - You Hit a Bomb! - |", 0

	bar3 DB          "    |--------------------------|", 0
	pressEnter DB    "    | Press Enter to Continue: |", 0

	escCodeUp2 db 27, '[', '2', 'A', 0     ; ESC[1A moves the cursor up 1 line
    escCodeRight2 db 27, '[', '31', 'G', 0   ; ESC[0G moves the cursor to the start of the line

	bar4 DB        "|-----------------------------------|", 0
	errorPrompt DB "| You did not enter a correct space |", 0
	pressEnter2 DB "|     Press Enter to Continue:      |", 0

    escCodeRight3 db 27, '[', '31', 'G', 0   ; ESC[0G moves the cursor to the start of the line

	bar5 DB        "  |-----------------------------|", 0
	spaceTaken DB  "  | That space is already taken |", 0
	pressEnter3 DB "  |   Press Enter to Continue:  |", 0

.code

makeMove PROC near

	call checkWin						; used if win is from randomizer

	call clearConsole

	call output

	call newline
	call newline

	loop_prompt:	

		cmp player, 1					; checks if player is 1
		je player_1						; jumps to player 1 label
		cmp player, 2					; checks if player is 2
		je player_2						; jumps to player 2 label

		player_1:
			push offset bar
			call printLine				; prints UI
			call newline

			push offset player1Prompt
			call printLine				; prints prompt for player 1
			call newline

			jmp continue_player			; jumps to continue_player label

		player_2:
			push offset bar
			call printLine				; prints UI
			call newline

			push offset player2Prompt
			call printLine				; prints prompt for player 2
			call newline

			jmp continue_player			; jumps to continue_player label

		continue_player:

			push offset bar
			call printline				; prints UI

			call newline

			push offset askCol			; push address of column prompt
			call printLine				; print column prompt

			call newline				; output a newline to console

			push offset askCol2			; push address of column prompt 2
			call printLine				; print column prompt 2

			call newline

			push offset bar				; prints UI
			call printline

			; used to change curser position for correct UI
			push offset escCodeUp
			push offset escCodeColLeft
			call cursorPosition

			;------------------------------------------------------

			call readline				; read input from user

			; error handling checks if user inputs valid input
			mov esi, offset readBuffer  ; move address of readbuffer into esi register which points to the memory location of the buffer
			mov al, [esi]				; dereference the pointer and move the character in al register
			sub al, 'a'					; subtract 'a' (97) from al
			movzx eax, al               ; zero-extend AL to EAX (column index)

			cmp eax, 4					; compare eax with 4
			jg error_col				; jump if greater than 4

			cmp eax, 0					; compare eax with 0
			jl error_col				; jump if less than 0

			jmp continue_col			; jump to continue_col label

		error_col:
			call errorOutput			; function that prints error handling prompt to user
			jmp loop_prompt				; jump back to ask user for column input

		continue_col:					; continue program

			;mov userCol, eax			; move value inside eax into userCol variable
			mov userSum, eax			; move value inside eax into userSum variable

			;------------------------------------------------------

			call newline 

			push offset askRow 
			call printLine				; print row prompt UI

			call newline 

			push offset askRow2 
			call printLine				; print row prompt 2 UI

			call newline

			push offset bar				; print bar UI
			call printline

			; used to change curser position for correct UI
			push offset escCodeUp
			push offset escCodeRowLeft
			call cursorPosition

			;------------------------------------------------------

			call readline				; get input from user

			; error handling checks if user inputs valid input
			mov esi, offset readBuffer	; move address of readbuffer into esi register which points to the memory location of the buffer
			mov al, [esi]				; dereference the pointer and move the character in al register
			sub al, '1'					; subtract '1' (49) from al
			movzx eax, al               ; zero-extend AL to EAX (row index)

			cmp eax, 4					; compare eax with 4
			jg error_row				; jump if greater than 4

			cmp eax, 0					; compare eax with 0
			jl error_row				; jump if less than 0

			jmp continue_row			; continue program

		error_row:
			call errorOutput			; function that prints error handling prompt to user
			jmp loop_prompt				; jump back to ask user for column input

		continue_row:

			imul eax, 5					; multiply eax by 5 to get correct row index
			;mov userRow, eax			; move eax into userRow variable
			add userSum, eax			; add eax to userSum

			; error handling to check if board already holds a character
			mov esi, offset board		; move address of board into esi register which points to the memory location of the array
			mov eax, userSum			; move userSum into eax
			add esi, eax				; add eax to esi to point to correct memory location
			mov al, byte ptr [esi]		; dereference esi and move character into al

			cmp al, 'X'					; compare al with 'X' character
			je error_space				; jump to error_space label
			cmp al, 'O'					; compare al with 'O' character
			je error_space				; jump to error_space label

			call makeMoveLogic			; call function to make move on the board

			ret

		error_space:

			call spaceTakenOutput		; function that prints prompt for error handling UI

			jmp loop_prompt				; jump back to ask user for column input
			

makeMove ENDP

; function used to place piece on the board
makeMoveLogic PROC near

	mov eax, player						; move player into eax

	cmp eax, 1							; check if player 1
	je xPlayer							; jump to xPlayer label
	cmp eax, 2							; check if player 2
	je oPlayer							; jump to oPlayer label
	
	xPlayer:
		call bombCheck					; function to check if space holds bomb

		cmp bombFlag, 1					; checks if bomb flag is set to true
		je end_X						; jump to end_X label
		cmp bombFlag, 0					; checks of bomb glag is set to false
		je continue_X					; jump to continue_X label
			continue_X:
				inc xCounter			; increment xCounter; used to store how many characters are on board
				mov spaceType, 'X'		; move 'X' character into spaceType variable; Used for checkWin function
				mov dl, 'X'				; move 'X' into dl register
				jmp updateBoard			; jump to updateBoard label
		
			end_X:

				call bombOutput			; function that prints bomb hit UI

				call randomize			; function that randomizes the board

				ret

	oPlayer:
		call bombCheck					; function to check if space holds bomb

		cmp bombFlag, 1					; checks if bomb flag is set to true
		je end_O						; jump if equal to end_O label
		cmp bombFlag, 0					; checks if bomb flag is set to false
		je continue_O					; jump if equal to continue_O label
			continue_O:
				inc oCounter			; increment oCounter; used to store how many characters are on board
				mov spaceType, 'O'		; move 'O' character into spaceType variable; Used for checkWin function
				mov dl, 'O'				; move 'O' into dl register
				jmp updateBoard			; jump to updateBoard label

			end_O:

				call bombOutput			; function that prints bomb hit UI

				call randomize			; function that randomizes the board
				
				ret

	updateBoard:

		mov eax, userSum				; move userSum into eax

		mov esi, offset board			; load base address of board into ESI
		add esi, eax					; moves userSum (correct board index) into esi pointer
		mov byte ptr [esi], dl			; move character stored in dl into esi pointing to board index
		
		ret

makeMoveLogic ENDP

; function used to check if user has hit a bomb
bombCheck PROC near

	mov esi, offset board				; load base address of board into ESI
	mov eax, userSum					; move userSum into eax
	add esi, eax						; moves userSum (correct board index) into esi pointer
	mov al, byte ptr [esi]				; moves character at index into al register

	cmp al, '*'							; checks if character is '*' (bomb)
	jne continue						; jump if not equal to continue label

	mov byte ptr bombFlag, 1			; set bombFlag to 1

	dec bombCounter						; decrement bombCounter to load correct number of remaining bombs back onto board

	continue:
		ret

bombCheck ENDP

; function used to print if the user has hit a bomb
bombOutput PROC near

		mov byte ptr bombFlag, 0		; resets bombFlag

		call clearConsole

		call output						; print board

		call newline
		call newline

		push offset bar2
		call printLine					; prints bar UI
		call newline

		push offset bombHitPrompt
		call printLine					; prints bombHitPrompt UI
		call newline

		push offset bar2
		call printLine					; prints bar UI
		call newline
		call newline

		push offset bar3
		call printLine					; prints bar UI
		call newline

		push offset pressEnter
		call printLine					; prints UI
		call newline

		push offset bar3
		call printLine					; prints bar UI
		call newline

		; used to change curser position for correct UI
		push offset escCodeUp2
		push offset escCodeRight2
		call cursorPosition

		call readline					; used to stop program and ask user for input to continue

		ret

bombOutput ENDP

; function that prints error handling to user
errorOutput PROC near

		call clearConsole				; clear console
		call output						; print board

		call newline
		call newline

		push offset bar4
		call printLine					; print bar UI
		call newline

		push offset errorPrompt
		call printLine					; print errorPrompt UI
		call newline

		push offset pressEnter2
		call printLine					; print pressEnter UI
		call newline

		push offset bar4
		call printLine					; print bar UI
		call newline

		; used to change curser position for correct UI
		push offset escCodeUp2
		push offset escCodeRight3
		call cursorPosition

		call readline					; used to stop program and ask user for input to continue

		call clearConsole				; clear console

		call output						; print board

		call newline
		call newline

		ret

errorOutput ENDP

; function used to print prompt that space had been taken
spaceTakenOutput PROC near
		call clearConsole				; clear console
		call output						; print board

		call newline
		call newline

		push offset bar5
		call printLine					; print bar UI
		call newline

		push offset spaceTaken
		call printLine					; print spaceTaken prompt
		call newline

		push offset pressEnter3
		call printLine					; print pressEnter prompt
		call newline

		push offset bar5
		call printLine					; print bar UI
		call newline

		; used to change curser position for correct UI
		push offset escCodeUp2
		push offset escCodeRight3
		call cursorPosition

		call readline					; used to stop program and ask user for input to continue

		call clearConsole				; clear console

		call output						; print board

		call newline
		call newline

		ret

spaceTakenOutput ENDP

END