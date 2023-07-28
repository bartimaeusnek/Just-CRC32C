format PE64 DLL
include 'win64a.inc'

section '.text' code readable executable

HasSSE42:
   push rbx
   mov eax, 1
   cpuid
   shr ecx, 20 ; bit 20 of the ecx register
   and ecx, 1
   mov eax, ecx
   pop rbx
   ret 0

CRC32_SSE42_Native:
    ; Parameters:
    ; rcx - const unsigned char *ptr
    ; edx - int ptr_length

    ; Function prologue
    push rsi

    ; Initialize crc to 0x00000000FFFFFFFF
    mov rax, 0FFFFFFFFh

    process_blocks:
    ; Check if the remaining length is less than 32 bytes
    cmp edx, 32
    jb crc32_remaining

    ; Process the data in blocks of 32 bytes
    crc32_loop:
        crc32 rax, qword [rcx]
        add rcx, 8
        crc32 rax, qword [rcx]
        add rcx, 8
        crc32 rax, qword [rcx]
        add rcx, 8
        crc32 rax, qword [rcx]
        add rcx, 8 ; Move to the next 32-byte block
        sub edx, 32 ; Decrease the remaining length by 32
        cmp edx, 32
        jae crc32_loop

    crc32_remaining:
        ; Process remaining bytes (less than 32 bytes)
        ; Check if remaining length is at least 8 bytes
        cmp edx, 8
        jb remaining4
        crc32_remaining_8:
            crc32 rax, qword [rcx]
            add rcx, 8
            sub edx, 8
            cmp edx, 8
            jae crc32_remaining_8

    remaining4:
        ; Check if remaining length is at least 4 bytes
        cmp edx, 4
        jb remaining2
        crc32_remaining_4:
            crc32 rax, dword [rcx]
            add rcx, 4
            sub edx, 4
            cmp edx, 4
            jae crc32_remaining_4

    remaining2:
        ; Check if remaining length is at least 2 bytes
        cmp edx, 2
        jb remaining1
        crc32_remaining_2:
            crc32 rax, word [rcx]
            add rcx, 2
            sub edx, 2
            cmp edx, 2
            jae crc32_remaining_2

    remaining1:
        cmp edx, 1
        jb done
        ; Process the last byte if available
        crc32 rax, byte [rcx]

    done:
        ; Function epilogue
        not rax ; Negate the CRC value
        pop rsi
        ret

section '.edata' export readable
export 'JustCRC32C_Native_x64.dll',\
    CRC32_SSE42_Native,'CRC32_SSE42_Native_x64',\
    HasSSE42,'HasSSE42_x64'
