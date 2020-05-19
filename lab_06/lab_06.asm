cpu 386                                 ; �������� ��� ���������� 80386
bits 16                                 ; ����������� ���������� ���������
org 100h                                ;

start:
    jmp init

    align   4
int1c_old:  dd 0                        ; ����� ������� ����������� ��������� 1c
timer_cnt:  db 0                        ; ������� �������
smile_st:   db 0                        ; ���������� ��������� ��������
smile0:     db ':)'
smile1:     db ';)'

; ���������� ���������� 1�
int1c_handler:
    pushf                               ; ��������� ������� ������
    call far [cs:int1c_old]             ; �������� ������ ���������� ����������

    inc     byte [cs:timer_cnt]         ; ����������� ������� �������
    cmp     byte [cs:timer_cnt], 18     ; � ��� � �������
    je      L2                          ; ������� �� �����
    iret                                ; ����� �������
L2:
    mov     byte [cs:timer_cnt], 0      ; �������� ������
    pusha                               ; ��������� ��������
    push    ds                          ;
    push    es                          ;

    inc     byte [cs:smile_st]          ; � ����������� �� �������� ����
    test    byte [cs:smile_st], 1       ; �������� ��� ��� ���� �������
    jz      L3
    mov     bx, smile1
    jmp     L4
L3: mov     bx, smile0

L4: cld
    mov     cx, 2                       ; ����� ������ ��������
    mov     ax, 0B800h
    mov     es, ax                      ; ������ � es �������� �������� �����������
    mov     di, 07D0h                   ; ��������� di �� ����� ������ ��������
    mov     ah, 1eh                     ; ������� ��������� ��������
L5: mov     al, byte [cs:bx]            ; ��� ������� ��� ������ � �����������
    stosw                               ; ������ ������� � ��������
    inc bx                              ; ��������� ������
    dec cx                              ; ��������� �������
    jnz     L5

    pop     es                          ; ��������������� ��������
    pop     ds
    popa
    iret
end_of_resident:

init:
    mov ax, 351ch                       ; ����������� ����� �������� ����������� ���������� 1c
    int 21h
    mov word [int1c_old + 2], es        ; � ��������� ��� ��� ������������ ������
    mov word [int1c_old], bx

    mov ax, 251ch                       ; ������������� ����� ����������� �� ���� ���������
    mov dx, int1c_handler
    int 21h

    mov ax, 3100h                       ; ���������� ���������� DOS, �������� ����������� ����� ��������� � ������
    mov dx, (end_of_resident - start + 256 + 15) >> 4
    int 21h

