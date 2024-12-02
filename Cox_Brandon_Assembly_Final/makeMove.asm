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

PUBLIC userCol
PUBLIC userRow
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
	userCol DWORD ?
	userRow DWORD ?
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

	call checkWin ; used if win is from randomizer

	call clearConsole

	call output

	call newline
	call newline

	loop_prompt:	

		;call debugBomb

		cmp player, 1
		je player_1
		cmp player, 2
		je player_2

		player_1:
			push offset bar
			call printLine
			call newline

			push offset player1Prompt
			call printLine
			call newline

			jmp continue_player

		player_2:
			push offset bar
			call printLine
			call newline

			push offset player2Prompt
			call printLine
			call newline

			jmp continue_player

		continue_player:

			push offset bar
			call printline

			call newline

			push offset askCol ; push address of column prompt
			call printLine     ; print column prompt

			call newline ; output a newline to console

			push offset askCol2 ; push address of column prompt 2
			call printLine		; print column prompt 2

			call newline

			push offset bar
			call printline

			push offset escCodeUp
			push offset escCodeColLeft
			call cursorPosition

			;------------------------------------------------------

			call readline	; read input from user

			mov esi, offset readBuffer
			mov al, [esi]
			sub al, 'a'
			movzx eax, al                ; Zero-extend AL to EAX (column index)

			cmp eax, 4
			jg error_col         ; Jump if greater than 4

			cmp eax, 0
			jl error_col         ; Jump if less than 0

			jmp continue_col

		error_col:
			call errorOutput
			jmp loop_prompt

		continue_col:

			mov userCol, eax
			mov userSum, eax

			;------------------------------------------------------

			call newline ; output a newline to console

			push offset askRow ; push address of row prompt
			call printLine	; print row prompt

			call newline ; output a newline to console

			push offset askRow2 ; push address of row prompt 2
			call printLine	; print row prompt 2

			call newline

			push offset bar
			call printline

			push offset escCodeUp
			push offset escCodeRowLeft
			call cursorPosition

			;------------------------------------------------------


			call readline ; get input from user

			mov esi, offset readBuffer
			mov al, [esi]
			sub al, '1'
			movzx eax, al                ; Zero-extend AL to EAX (row index)

			cmp eax, 4
			jg error_row         ; Jump if greater than 4

			cmp eax, 0
			jl error_row         ; Jump if less than 0

			jmp continue_row

		error_row:
			call errorOutput
			jmp loop_prompt

		continue_row:

			imul eax, 5
			mov userRow, eax
			add userSum, eax

			mov esi, offset board
			mov eax, userSum
			add esi, eax
			mov al, byte ptr [esi]

			cmp al, 'X'
			je error_space
			cmp al, 'O'
			je error_space

			call makeMoveLogic

			ret

		error_space:

			call spaceTakenOutput

			jmp loop_prompt
			

makeMove ENDP

makeMoveLogic PROC near

	mov eax, player

	cmp eax, 1
	je xPlayer
	cmp eax, 2
	je oPlayer
	
	xPlayer:
		call bombCheck

		cmp bombFlag, 1
		je end_X
		cmp bombFlag, 0
		je continue_X
			continue_X:
				inc xCounter
				mov spaceType, 'X'
				mov dl, 'X'
				jmp updateBoard
		
			end_X:

				call bombOutput

				call randomize

				ret

	oPlayer:
		call bombCheck

		cmp bombFlag, 1
		je end_O
		cmp bombFlag, 0
		je continue_O
			continue_O:
				inc oCounter
				mov spaceType, 'O'
				mov dl, 'O'
				jmp updateBoard

			end_O:

				call bombOutput

				call randomize
				
				ret

	updateBoard:

		mov eax, userSum

		mov esi, offset board     ; Load base address of board into ESI
		add esi, eax
		mov byte ptr [esi], dl   ; Change the value at board[10] to 'Z'
		
		ret

makeMoveLogic ENDP

bombCheck PROC near

	mov esi, offset board
	mov eax, userSum
	add esi, eax
	mov al, byte ptr [esi]

	cmp al, '*'
	jne continue

	mov byte ptr bombFlag, 1 ; Set bombFlag to 1

	dec bombCounter

	continue:
		ret

bombCheck ENDP

bombOutput PROC near

		mov byte ptr bombFlag, 0

		call clearConsole

		call output

		call newline
		call newline

		push offset bar2
		call printLine
		call newline

		push offset bombHitPrompt
		call printLine
		call newline

		push offset bar2
		call printLine
		call newline
		call newline

		push offset bar3
		call printLine
		call newline

		push offset pressEnter
		call printLine
		call newline

		push offset bar3
		call printLine
		call newline

		push offset escCodeUp2
		push offset escCodeRight2
		call cursorPosition

		call readline

		ret

bombOutput ENDP

errorOutput PROC near

		call clearConsole
		call output

		call newline
		call newline

		push offset bar4
		call printLine
		call newline

		push offset errorPrompt
		call printLine
		call newline

		push offset pressEnter2
		call printLine
		call newline

		push offset bar4
		call printLine
		call newline

		push offset escCodeUp2
		push offset escCodeRight3
		call cursorPosition

		call readline

		call clearConsole

		call output

		call newline
		call newline

		ret

errorOutput ENDP

spaceTakenOutput PROC near
		call clearConsole
		call output

		call newline
		call newline

		push offset bar5
		call printLine
		call newline

		push offset spaceTaken
		call printLine
		call newline

		push offset pressEnter3
		call printLine
		call newline

		push offset bar5
		call printLine
		call newline

		push offset escCodeUp2
		push offset escCodeRight3
		call cursorPosition

		call readline

		call clearConsole

		call output

		call newline
		call newline

		ret


spaceTakenOutput ENDP

END