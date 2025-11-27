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
   ret

;C version decompiled and pasted, since i couldn't get the ASM version to work with x86 properly
;
;#include <stdint.h>
;#include <intrin.h>
;uint32_t CRC32_SSE42_Native_x86(const unsigned char* data, uint32_t datalength)
;{
;    uint32_t crc = 0xFFFFFFFF;
;    uint32_t i = 0;
;    uint32_t length = datalength;
;    
;    while (length >= 16)
;    {
;        uint32_t block = *(uint32_t*) (data+i);
;        crc = _mm_crc32_u32(crc, block);
;        block = *(uint32_t*) (data+i + 4);
;        crc = _mm_crc32_u32(crc, block);
;        block = *(uint32_t*) (data+i + 8);
;        crc = _mm_crc32_u32(crc, block);
;        block = *(uint32_t*) (data+i + 12);
;        crc = _mm_crc32_u32(crc, block);
;        i += 16;
;        length -= 16;
;    }
;    
;    remaining:
;    if (length >= 4) {
;        uint32_t block = *(uint32_t*) (data+i);
;        crc = _mm_crc32_u32(crc, block);
;        i += 4;
;        length -= 4;
;        goto remaining;
;    }
;    if (length >= 2) {
;        uint16_t block = *(uint16_t*) (data+i);
;        crc = _mm_crc32_u16(crc, block);
;        i += 2;
;        length -= 2;
;        goto remaining;
;    }
;    if (length >= 1) {
;        uint8_t block = *(data+i);
;        crc = _mm_crc32_u8(crc, block);
;        ++i;
;        --length;
;        goto remaining;
;    }
;    return ~crc;
;}
CRC32_SSE42_Native:
    MOV        ECX ,dword[ESP + 0x8]
    OR         EAX ,0xffffffff
    PUSH       EBX
    MOV        EBX ,dword[ESP + 0x8]
    PUSH       EDI
    XOR        EDI ,EDI
    CMP        ECX ,0x10
    JC         LABEL_2
    PUSH       ESI
    MOV        ESI ,ECX
    LEA        EDX ,[EBX + 0x8]
    SHR        ESI ,0x4
    MOV        EDI ,ESI
    SHL        EDI ,0x4
LABEL_1:
    CRC32      EAX ,dword[EDX + -0x8]
    CRC32      EAX ,dword[EDX + -0x4]
    CRC32      EAX ,dword[EDX]
    CRC32      EAX ,dword[EDX + 0x4]
    SUB        ECX ,0x10
    LEA        EDX ,[EDX + 0x10]
    SUB        ESI ,0x1
    JNZ        LABEL_1
    POP        ESI
LABEL_2:
    LEA        EDX ,[EDI + EBX *0x1]
    POP        EDI
    POP        EBX
    NOP        word[EAX + EAX *0x1]
LABEL_3:
    CMP        ECX ,0x4
    JC         LABEL_4
    CRC32      EAX ,dword[EDX]
    ADD        EDX ,0x4
    SUB        ECX ,0x4
    JMP        LABEL_3
LABEL_4:
    CMP        ECX ,0x2
    JC         LABEL_5
    CRC32      EAX ,word[EDX]
    ADD        EDX ,0x2
    SUB        ECX ,0x2
    JMP        LABEL_3
LABEL_5:
    CMP        ECX ,0x1
    JC         LABEL_6
    CRC32      EAX ,byte[EDX]
    INC        EDX
    DEC        ECX
    JMP        LABEL_3
LABEL_6:
    NOT        EAX
    RET

section '.edata' export readable
export 'JustCRC32C_Native_x32.dll',\
    CRC32_SSE42_Native,'CRC32_SSE42_Native_x86',\
    HasSSE42,'HasSSE42_x86'