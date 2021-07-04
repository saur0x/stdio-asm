SYS_WRITE	equ	1		; the linux WRITE syscall
SYS_EXIT	equ	60		; the linux EXIT syscall

FD_STDIN	equ	0
FD_STDOUT	equ	1		; the file descriptor for standard output (to print/write to)
FD_STDERR	equ	2

CHAR_NUL	equ	0x00
CHAR_LF		equ	0x0A

;EOF			equ 0xFF
%define	EOF 0xFF

;IO_BUFFER	equ	0xFF
%define IO_BUFFER	0xFF

;length		equ	5		; the length of the string we wish to print (fixed string length of the arguments)

;--------

section .text
	global _start

;--------

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

;--------

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

;--------

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

;--------

puts:
	mov	rsi, FD_STDOUT
	call fputs

	push	rax

	mov	rdi, CHAR_LF
	call putchar

	pop	rax
	ret

;--------

_start:
	mov	rdi, message
	mov	rsi, FD_STDERR

	call	fputs

	jmp EXIT_SUCCESS

EXIT_FAILURE:
	mov rdi, 1
	jmp exit

EXIT_SUCCESS:
	mov rdi, 0
	jmp exit

exit:
	mov rax, SYS_EXIT
	syscall


section .data
	message db '123', 0x00
;	string_length equ $ - message - 1