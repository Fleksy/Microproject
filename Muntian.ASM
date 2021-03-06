format PE console
entry start

include 'win32a.inc'

section '.data' data readable writable

        str1 db 'Enter number ',10,0
        str2 db 'Number of repetitions ',10,0
        strScanInt db '%d',0          ;������ ��� ����� � ������� scanf
        number dd ?                   ;���������� ��� ���������� �����
        count dd ?                    ;���������� ��� ������

section 'text' code executable readable
start:
        push str1                     ;������ ������������ ������ �����
        call [printf]

        push number                   ;����
        push strScanInt
        call [scanf]

        mov eax,[number]              ;���������  � eax
        mov edx,31                    ;������ ������������ ���� (� 31-�� �� 0-��)
        xor ebx,ebx                   ;����������, �� ���������� � ����� ����� �� ������ �� ��� ���������
        xor esi,esi                   ;���-�� �������� �����
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
        push [count]                  ;�����
        push strScanInt
        call [printf]

        call [getch]                  ; ����� ������������ ����� ������� �����, ������� ������� �������
        push 0
        call [ExitProcess]            ;��������� ������ ���������

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


