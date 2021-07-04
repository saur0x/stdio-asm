%ifndef PRINTINT_ASM
%define PRINTINT_ASM


printint:
	push rbx
	mov rbx, rdi
	xor rdi, rdi

	jmp printint_body

printint_body:
	; separated out n into two registers
	mov eax, ebx
	shr rbx, 32
	mov edx, ebx

	; divide by 10
	mov ecx, 10
	div ecx

	; set n to the quotient
	mov ebx, eax

	; increment character counter
	inc rdi

	; get memory address of next character on stack
	mov rax, rsp
	sub rax, rdi

	; add '0' to convert digit into a character
	add dl, '0'
	mov BYTE[rax], dl

	; continue if n != 0
	cmp ebx, 0x00
	jne printint_body

	; write size_t count
	mov rdx, rdi

	; write char *buf
	mov rsi, rax

	; write int fd
	mov rdi, 1

	mov rax, 0x01
	syscall

	pop rbx
	ret

%endif ; PRINTINT_ASM
