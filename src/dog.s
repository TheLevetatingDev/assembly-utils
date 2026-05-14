.intel_syntax noprefix

.section .data

buffer:
    .skip 4096

msg_not_found:
    .asciz "Dog: No such file or directory (Beavers)\n"
msg_not_found_len = . - msg_not_found

msg_permission:
    .asciz "Error: permission denied (Beavers)\n"
msg_permission_len = . - msg_permission

msg_isdir:
    .asciz "Error: is a directory (Beavers)\n"
msg_isdir_len = . - msg_isdir

msg_unknown:
    .asciz "Error: unknown error (Beavers)\n"
msg_unknown_len = . - msg_unknown


.section .text
.global _start

_start:

    # -------------------------
    # check argc
    # -------------------------
    mov rax, [rsp]
    cmp rax, 2
    jl .exit_fail


    # -------------------------
    # open(argv[1])
    # -------------------------
    mov rax, 2
    mov rdi, [rsp + 16]
    mov rsi, 0
    syscall

    test rax, rax
    js .handle_error

    mov r12, rax


.read_loop:

    # -------------------------
    # read(fd, buffer, 4096)
    # -------------------------
    mov rax, 0
    mov rdi, r12
    lea rsi, [rip + buffer]
    mov rdx, 4096
    syscall

    test rax, rax
    jz .done

    js .handle_error

    mov r13, rax


    # -------------------------
    # write(1, buffer, bytes_read)
    # -------------------------
    mov rax, 1
    mov rdi, 1
    lea rsi, [rip + buffer]
    mov rdx, r13
    syscall

    jmp .read_loop


.done:
    # close(fd)
    mov rax, 3
    mov rdi, r12
    syscall

    jmp .exit_ok


# -------------------------
# error handling
# -------------------------
.handle_error:

    neg rax            # convert -errno → errno

    cmp rax, 2
    je .err_not_found

    cmp rax, 13
    je .err_permission

    cmp rax, 21
    je .err_isdir

    jmp .err_unknown


.err_not_found:
    mov rax, 1
    mov rdi, 2
    lea rsi, [rip + msg_not_found]
    mov rdx, msg_not_found_len
    syscall
    jmp .exit_fail


.err_permission:
    mov rax, 1
    mov rdi, 2
    lea rsi, [rip + msg_permission]
    mov rdx, msg_permission_len
    syscall
    jmp .exit_fail


.err_isdir:
    mov rax, 1
    mov rdi, 2
    lea rsi, [rip + msg_isdir]
    mov rdx, msg_isdir_len
    syscall
    jmp .exit_fail


.err_unknown:
    mov rax, 1
    mov rdi, 2
    lea rsi, [rip + msg_unknown]
    mov rdx, msg_unknown_len
    syscall
    jmp .exit_fail


# -------------------------
# exit paths
# -------------------------
.exit_ok:
    mov rax, 60
    xor rdi, rdi
    syscall

.exit_fail:
    mov rax, 60
    mov rdi, 1
    syscall
