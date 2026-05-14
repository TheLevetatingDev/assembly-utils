.intel_syntax noprefix
.global _start

# simple echo clone - prints all argv args separated by spaces,
# followed by a newline. no libc, just raw syscalls.
#
# linux x86_64 calling convention for syscalls:
#   rax = syscall number
#   rdi, rsi, rdx, r10, r8, r9 = args
#
# register usage throughout:
#   rbx = argc
#   r12 = base of argv (i.e. rsp+8 at entry)
#   r13 = current index into argv
#   r14 = whether we've printed anything yet (for spacing)

.text

_start:
    # the kernel puts argc at the top of the stack, then the argv
    # pointers right after. no stack frame needed, we just read directly.
    mov  rbx, [rsp]
    lea  r12, [rsp + 8]

    mov  r13, 1      # start at argv[1], we don't want to print argv[0]
    xor  r14, r14    # haven't printed anything yet

next_arg:
    cmp  r13, rbx
    jge  done        # ran out of arguments

    # put a space between arguments, but not before the first one
    test r14, r14
    jz   skip_space

    mov  rax, 1
    mov  rdi, 1
    lea  rsi, [rip + space]
    mov  rdx, 1
    syscall

skip_space:
    mov  r14, 1

    # figure out how long this argument string is.
    # argv[i] is a normal null-terminated C string, so we just
    # walk it until we hit the zero byte.
    mov  rdi, [r12 + r13*8]   # grab the pointer for argv[r13]
    mov  rsi, rdi             # keep a copy of the start for write()
    xor  rcx, rcx

count:
    cmp  byte ptr [rdi + rcx], 0
    je   print_it
    inc  rcx
    jmp  count

print_it:
    # write(stdout, ptr, len)
    mov  rax, 1
    mov  rdi, 1
    # rsi is still pointing at the start of the string
    mov  rdx, rcx
    syscall

    inc  r13
    jmp  next_arg

done:
    # always end with a newline, even if no args were given
    mov  rax, 1
    mov  rdi, 1
    lea  rsi, [rip + newline]
    mov  rdx, 1
    syscall

    # exit(0)
    mov  rax, 60
    xor  rdi, rdi
    syscall


.section .rodata
space:   .byte ' '
newline: .byte '\n'
