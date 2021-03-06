; для компиляции используется NASM
; соглашение о вызовах для win64 https://docs.microsoft.com/ru-ru/cpp/build/x64-software-conventions?view=vs-2019
bits 64
default rel

segment .text
global lvt_strcpy

lvt_strcpy:
    mov     r11, rdi            ; сохраняем регистры rdi
    mov     r10, rsi            ; и rsi

    cld                         ; задаем направление копирования в сторону увеличения адресов

    cmp     rdx, rcx            ; если адрес начала строки-источника >= адреса начала строки-приёмника
    jge     L1                  ; всё хорошо и ничего менять не нужно (даже в случае наложения адресов)

; в противном случае нужно проверить наложение
    mov     rax, rcx            ; помещаем адрес начала строки-приемника в rax
    sub     rax, rdx            ; вычитаем адрес начала строки-источника
    cmp     rax, r8             ; если разность больше длины строки
    jge     L1                  ; наложения нет

; иначе меняем начало копирования
    add     rcx, r8
    add     rdx, r8

    dec     rcx
    dec     rdx

    std                         ; задаем направление копирования в сторону уменьшения адресов

L1:
    mov     rdi, rcx            ; адрес начала строки-приемника (1-й параметр)
    mov     rsi, rdx            ; адрес начала строки-источника (2-й параметр)
    mov     rcx, r8             ; количество копируемых символов (3-й параметр)

    rep     movsb               ; выполняем копирование
    xor     rax, rax            ; возвращаем 0 как признак успешного завершения

    mov     rdi, r11            ; восстанавливаем rdi
    mov     rsi, r10            ; и rsi

    ret
