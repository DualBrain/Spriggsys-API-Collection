_TITLE "Extract and Draw Icon"

DECLARE DYNAMIC LIBRARY "Shell32"
    FUNCTION ExtractIcon& ALIAS ExtractIconA (BYVAL hInst AS LONG, BYVAL pszExeFileName AS _OFFSET, BYVAL nIconIndex AS _UNSIGNED INTEGER)
END DECLARE

DECLARE DYNAMIC LIBRARY "User32"
    FUNCTION GetDC& (BYVAL hWnd AS LONG)
    FUNCTION DrawIcon& (BYVAL hDC AS LONG, BYVAL X AS INTEGER, BYVAL Y AS INTEGER, BYVAL hIcon AS LONG)
    FUNCTION DestroyIcon& (BYVAL hIcon AS LONG)
END DECLARE

DIM path AS STRING
path = _DIR$("desktop") + "QB64 x64\qb64.exe"

DIM icon AS LONG
icon = ExtractIcon(_WINDOWHANDLE, _OFFSET(path), 0)

DIM icondraw AS LONG
DIM program AS LONG

program = GetDC(_WINDOWHANDLE)
DO
    icondraw = DrawIcon(program, 0, 0, icon)
    _LIMIT 120
LOOP UNTIL INKEY$ <> ""
DIM a AS LONG

a = DestroyIcon(icon)
