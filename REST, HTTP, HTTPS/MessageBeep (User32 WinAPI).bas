'CONSTANTS
CONST SIMPLE_BEEP = &HFFFFFFFF
CONST MB_ICONASTERISK = &H00000040
CONST MB_ICONEXCLAMATION = &H00000030
CONST MB_ICONERROR = &H00000010
CONST MB_ICONHAND = &H00000010
CONST MB_ICONINFORMATION = &H00000040
CONST MB_ICONQUESTINO = &H00000020
CONST MB_ICONSTOP = &H00000010
CONST MB_ICONWARNING = &H00000030
CONST MB_OK = &H00000000

DECLARE DYNAMIC LIBRARY "User32"
    FUNCTION MessageBeep%% (BYVAL uType AS _UNSIGNED INTEGER)
END DECLARE

DIM a AS _BYTE
a = MessageBeep(MB_ICONEXCLAMATION)
