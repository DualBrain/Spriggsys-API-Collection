' Run the code and click on any other open windows. The QB64 app will stay on top. Click "x" or press Esc to terminate demo.
CONST HWND_TOPMOST%& = -1
CONST SWP_NOSIZE%& = &H1
CONST SWP_NOMOVE%& = &H2
CONST SWP_SHOWWINDOW%& = &H40

DECLARE DYNAMIC LIBRARY "user32"
    FUNCTION SetWindowPos& (BYVAL hWnd AS LONG, BYVAL hWndInsertAfter AS _OFFSET, BYVAL X AS INTEGER, BYVAL Y AS INTEGER, BYVAL cx AS INTEGER, BYVAL cy AS INTEGER, BYVAL uFlags AS _OFFSET)
    FUNCTION GetForegroundWindow& 'find currently focused process handle
END DECLARE

' Needed for acquiring the hWnd of the window
DIM Myhwnd AS LONG ' Get hWnd value
_TITLE "Topmost Window"
Myhwnd = _WINDOWHANDLE
wdth = 300: hght = 400

' Set screen
s& = _NEWIMAGE(wdth, hght, 32)
SCREEN s&
_DEST 0

_SCREENMOVE 800, 50
' Main loop
Level = 175
_DELAY .1

DO
    _LIMIT 30
    FGwin& = GetForegroundWindow&

    IF Myhwnd <> FGwin& THEN ' QB64 no longer in focus.
        WHILE _MOUSEINPUT: WEND
        y& = SetWindowPos&(Myhwnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE + SWP_NOSIZE + SWP_SHOWWINDOW)
        PRINT y&, Myhwnd, HWND_TOPMOST%&, SWP_NOSIZE%& + SWP_NOMOVE%& + SWP_SHOWWINDOW%&
        DO: _LIMIT 30: LOOP UNTIL Myhwnd = GetForegroundWindow&
    END IF
    IF INKEY$ = CHR$(27) THEN SYSTEM
LOOP
