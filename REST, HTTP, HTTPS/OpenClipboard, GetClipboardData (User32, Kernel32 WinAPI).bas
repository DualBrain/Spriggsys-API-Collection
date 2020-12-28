OPTION _EXPLICIT
$CONSOLE:ONLY
_DEST _CONSOLE
'CONSTANTS
CONST CF_TEXT = 1
CONST CF_BITMAP = 2
CONST CF_METAFILEPICT = 3
CONST CF_SYLK = 4
CONST CF_DIF = 5
CONST CF_TIFF = 6
CONST CF_OEMTEXT = 7
CONST CF_DIB = 8
CONST CF_PALETTE = 9
CONST CF_PENDATA = 10
CONST CF_RIFF = 11
CONST CF_WAVE = 12
CONST CF_UNICODETEXT = 13
CONST CF_ENHMETAFILE = 14
CONST CF_HDROP = 15
CONST CF_LOCALE = 16
CONST CF_DIBV5 = 17
CONST CF_MAX = 18

DECLARE DYNAMIC LIBRARY "User32"
    FUNCTION OpenClipboard%% (BYVAL hWndNewOwner AS LONG)
    'FUNCTION CountClipboardFormats% ()
    FUNCTION GetClipboardData& (BYVAL uFormat AS _UNSIGNED INTEGER)
    FUNCTION CloseClipboard%% ()
END DECLARE

DECLARE DYNAMIC LIBRARY "Kernel32"
    FUNCTION GlobalLock%& (BYVAL hMem AS LONG)
    FUNCTION GlobalUnlock%% (BYVAL hMem AS LONG)
END DECLARE

DECLARE CUSTOMTYPE LIBRARY "peekpoke"
    FUNCTION peekb~%% (BYVAL p AS _UNSIGNED _OFFSET) 'Byte
END DECLARE

PRINT Clipboard$
SLEEP

FUNCTION Clipboard$
    DIM a AS LONG
    a = OpenClipboard(0)
    a = GetClipboardData(CF_TEXT)
    DIM b AS _UNSIGNED _OFFSET
    b = GlobalLock(a)
    DIM x AS _UNSIGNED INTEGER
    DIM clip AS STRING
    DO
        clip = clip + CHR$(peekb(b + x))
        x = x + 1
    LOOP UNTIL CHR$(peekb(b + x)) = CHR$(0)
    DIM closeclip AS _BYTE
    closeclip = GlobalUnlock(a)
    closeclip = CloseClipboard
    Clipboard = clip
END FUNCTION
