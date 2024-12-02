.model flat

	includelib msvcrt.lib
	includelib ucrt.lib

	extern _time: near
	extern _srand: near

.data

.code

seed_rng PROC near

	mov eax, 0
	push eax
	call _time
	add esp, 4

	push eax
	call _srand
	add esp, 4

	ret
seed_rng ENDP

END