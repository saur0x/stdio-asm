%include "stdio.s"


section .text
	global _start

_start:
	mov rdi, message
	call puts

	jmp EXIT_SUCCESS

EXIT_FAILURE:
	mov rdi, 1
	jmp exit

EXIT_SUCCESS:
	mov rdi, 0
	jmp exit

exit:
	mov rax, 0xe7
	syscall

section .data
	message db 'hello there13', 0x00
	string_length equ $ - message - 1
