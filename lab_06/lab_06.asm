cpu 386                                 ; ñîáèğàåì äëÿ ïğîöåññîğà 80386
bits 16                                 ; ğàçğÿäíîñòü ñîáèğàåìîé ïğîãğàììû
org 100h                                ;

start:
    jmp init

    align   4
int1c_old:  dd 0                        ; àäğåñ ñòàğîãî îáğàáîò÷èêà ïğåğûâíèÿ 1c
timer_cnt:  db 0                        ; ñ÷åò÷èê òàéìåğà
smile_st:   db 0                        ; ïåğåìåííàÿ ñîñòîÿíèÿ ñìàéëèêà
smile0:     db ':)'
smile1:     db ';)'

; îáğàáîò÷èê ïğåğûâàíèÿ 1ñ
int1c_handler:
    pushf                               ; ñîõğàíÿåì ğåãèñòğ ôëàãîâ
    call far [cs:int1c_old]             ; âûçûâàåì ñòàğûé îáğàáîò÷èê ïğåğûâàíèÿ

    inc     byte [cs:timer_cnt]         ; óâåëè÷èâàåì ñ÷åò÷èê òàéìåğà
    cmp     byte [cs:timer_cnt], 18     ; è ğàç â ñåêóíäó
    je      L2                          ; âûâîäèì íà ıêğàí
    iret                                ; èíà÷å âûõîäèì
L2:
    mov     byte [cs:timer_cnt], 0      ; îáíóëÿåì òàéìåğ
    pusha                               ; ñîõğàíÿåì ğåãèñòğû
    push    ds                          ;
    push    es                          ;

    inc     byte [cs:smile_st]          ; â çàâèñèìîñòè îò ìëàäøåãî áèòà
    test    byte [cs:smile_st], 1       ; âûáèğàåì òîò èëè èíîé ñìàéëèê
    jz      L3
    mov     bx, smile1
    jmp     L4
L3: mov     bx, smile0

L4: cld
    mov     cx, 2                       ; äëèíà ñòğîêè ñìàéëèêà
    mov     ax, 0B800h
    mov     es, ax                      ; çàïèñü â es çíà÷åíèÿ ñåãìåíòà âèäåîïàìÿòè
    mov     di, 07D0h                   ; íàñòğîéêà di íà ìåñòî âûâîäà ñìàéëèêà
    mov     ah, 1eh                     ; àòğèáóò âûâîäèìûõ ñèìâîëîâ
L5: mov     al, byte [cs:bx]            ; êîä ñèìâîëà äëÿ çàïèñè â âèäåîïàìÿòü
    stosw                               ; çàïèñü ñèìâîëà è àòğèáóòà
    inc bx                              ; ñëåäóşùèé ñèìâîë
    dec cx                              ; óìåíüøàåì ñ÷åò÷èê
    jnz     L5

    pop     es                          ; âîññòàíàâëèâàåì ğåãèñòğû
    pop     ds
    popa
    iret
end_of_resident:

init:
    mov ax, 351ch                       ; çàïğàøèâàåì àäğåñ òåêóùåãî îáğàáîò÷èêà ïğåğûâàíèÿ 1c
    int 21h
    mov word [int1c_old + 2], es        ; è ñîõğàíÿåì åãî äëÿ ïîñëåäóşùåãî âûçîâà
    mov word [int1c_old], bx

    mov ax, 251ch                       ; óñòàíàâëèâàåì àäğåñ îáğàáîò÷èêà íà íàøó ïğîãğàììó
    mov dx, int1c_handler
    int 21h

    mov ax, 3100h                       ; âîçâğàùàåì óïğàâëåíèå DOS, îñòàâëÿÿ ğåçèäåíòíóş ÷àñòü ïğîãğàììû â ïàìÿòè
    mov dx, (end_of_resident - start + 256 + 15) >> 4
    int 21h

