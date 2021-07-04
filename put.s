%ifndef PUT_ASM
%define PUT_ASM


%include "fd.s"
%include "syscalls.s"

%define	CHAR_NUL	0x00
%define	CHAR_LF		0x0A

%define	EOF			0xFF

%define	IO_BUFFER	0xFF


strlen:
	xor rax, rax
	jmp _strlen_loop

_strlen_loop:
	cmp BYTE [rdi], CHAR_NUL
	je _strlen_return

	add	rax, 1
	add	rdi, 1

	jmp _strlen_loop

_strlen_return:
	ret


fputc:
	push rsi

	mov	rsi, rsp
	sub	rsi, 1

	; casting to unsigned char
	mov	rax, rdi
	mov BYTE [rsi], al

	mov	rdx, 1
	; rsi retained
	pop	rdi
	mov	rax, SYS_WRITE
	syscall

	mov	al, BYTE [rsi]
	; can return EOF
	ret

putchar:
	mov	rsi, FD_STDOUT
	call	fputc
	ret


fputs:
	push	rdi
	push	rsi

	call	strlen

	mov	rcx, rax
	mov	rax, SYS_WRITE

	pop	rdi
	pop	rsi

	mov	rdx, IO_BUFFER

	jmp	_fputs_loop

_fputs_loop:
	cmp	rcx, IO_BUFFER

	jle	_fputs_end

	syscall

	add	rsi, IO_BUFFER
	sub	rcx, IO_BUFFER
	jmp	_fputs_loop

_fputs_end:
	mov	rdx, rcx
	syscall

	jmp _fputs_return

_fputs_return:
	mov	rax, 0
	ret


puts:
	mov	rsi, FD_STDOUT
	call fputs

	push	rax

	mov	rdi, CHAR_LF
	call putchar

	pop	rax
	ret


%endif ; PUT_ASM