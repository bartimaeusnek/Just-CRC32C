format PE DLL
include 'win32a.inc'

section '.text' code readable executable

HasSSE42:
   push ebx
   mov eax, 1
   cpuid
   shr ecx, 20 ; bit 20 of the ecx register
   and ecx, 1
   mov eax, ecx
   pop ebx
   ret 0

CRC32_SSE42_Native:
    ; Parameters:
    ; rcx - const unsigned char *ptr
    ; edx - int ptr_length

    ; Function prologue
    push esi

    ; Initialize crc to 0xFFFFFFFF
    mov eax, 0FFFFFFFFh

    process_blocks:
    ; Check if the remaining length is less than 16 bytes
    cmp edx, 16
    jb remaining4

    ; Process the data in blocks of 16 bytes
    crc32_loop:
        crc32 eax, dword [ecx]
        add ecx, 4
        crc32 eax, dword [ecx]
        add ecx, 4
        crc32 eax, dword [ecx]
        add ecx, 4
        crc32 eax, dword [ecx]
        add ecx, 4 ; Move to the next 16-byte block
        sub edx, 16 ; Decrease the remaining length by 16
        cmp edx, 16
        jae crc32_loop

    remaining4:
        ; Check if remaining length is at least 4 bytes
        cmp edx, 4
        jb remaining2
        crc32_remaining_4:
            crc32 eax, dword [ecx]
            add ecx, 4
            sub edx, 4
            cmp edx, 4
            jae crc32_remaining_4

    remaining2:
        ; Check if remaining length is at least 2 bytes
        cmp edx, 2
        jb remaining1
        crc32_remaining_2:
            crc32 eax, word [ecx]
            add ecx, 2
            sub edx, 2
            cmp edx, 2
            jae crc32_remaining_2

    remaining1:
        cmp edx, 1
        jb done
        ; Process the last byte if available
        crc32 eax, byte [ecx]

    done:
        ; Function epilogue
        not eax ; Negate the CRC value
        pop esi
        ret

section '.edata' export readable
export 'JustCRC32C_Native_x32.dll',\
    CRC32_SSE42_Native,'CRC32_SSE42_Native_x86',\
    HasSSE42,'HasSSE42_x86'