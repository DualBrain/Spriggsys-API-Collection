'CONSTANTS
CONST FLASHW_ALL = &H00000003 'Flash both the window caption and taskbar button. Same as FLASHW_CAPTION + FLASHW_TRAY
CONST FLASHW_CAPTION = &H00000001 'Flash the window caption.
CONST FLASHW_STOP = 0 'Stop flashing. The system restores the window to its original state
CONST FLASHW_TIMER = &H00000004 'Flash continuously, until the FLASHW_STOP flag is set.
CONST FLASHW_TIMERNOFG = &H0000000C 'Flash continuously until the window comes to the foreground.
CONST FLASHW_TRY = &H00000002 'Flash the taskbar button.

TYPE FLASHWINFO
    cbSize AS _UNSIGNED INTEGER
    hwnd AS LONG
    dwFlags AS LONG
    uCount AS _UNSIGNED INTEGER
    dwTimeout AS LONG
END TYPE

DECLARE DYNAMIC LIBRARY "User32"
    FUNCTION FlashWindow%% (BYVAL hWnd AS LONG, BYVAL bInvert AS _BYTE)
    FUNCTION FlashWindowEx%% (BYVAL pfwi AS _OFFSET)
END DECLARE

_DELAY 1
PRINT FlashWindow(_WINDOWHANDLE, -1)

_DELAY 1
DIM flash AS FLASHWINFO
flash.cbSize = LEN(flash)
flash.hwnd = _WINDOWHANDLE
flash.dwFlags = FLASHW_ALL
flash.dwFlags = 10
flash.dwTimeout = 0

PRINT FlashWindowEx(_OFFSET(flash))
