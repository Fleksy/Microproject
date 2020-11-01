format PE console
entry start

include 'win32a.inc'

section '.data' data readable writable

        str1 db 'Enter number ',10,0
        str2 db 'Number of repetitions ',10,0
        strScanInt db '%d',0          ;строка дл€ ввода с помощью scanf
        number dd ?                   ;переменна€ дл€ введенного числа
        count dd ?                    ;переменна€ дл€ ответа

section 'text' code executable readable
start:
        push str1                     ;ѕросим пользовател€ ввести число
        call [printf]

        push number                   ;ввод
        push strScanInt
        call [scanf]

        mov eax,[number]              ;загружаем  в eax
        mov edx,31                    ;индекс провер€емого бита (с 31-го до 0-го)
        xor ebx,ebx                   ;показывает, на совпадение с каким битом из тройки мы его провер€ем
        xor esi,esi                   ;кол-во найденых троек
        .m1:
        cmp ebx,0
        jne .m2
        bt eax,edx
        jc .skip
        inc ebx
        jmp .skip
        .m2:
        cmp ebx,1
        jne .m3
        bt eax,edx
        jnc .skip
        inc ebx
        jmp .skip
        .m3:
        bt eax,edx
        jc .m31
        mov ebx,1
        jmp .skip
        .m31:
        inc esi
        xor ebx,ebx
        .skip:
        dec edx
        cmp edx,-1
        jne .m1
        mov [count],esi
        push str2
        call [printf]
        push [count]                  ;вывод
        push strScanInt
        call [printf]

        call [getch]                  ; чтобы пользователь успел увидеть ответ, ожидаем нажати€ клавиши
        push 0
        call [ExitProcess]            ;завершаем работу программы

section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll',\
            user32,'USER32.DLL'

include 'api\user32.inc'
include 'api\kernel32.inc'
    import kernel,\
           ExitProcess, 'ExitProcess',\
           HeapCreate,'HeapCreate',\
           HeapAlloc,'HeapAlloc'
  include 'api\kernel32.inc'
    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'


