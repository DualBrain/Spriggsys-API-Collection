OPTION _EXPLICIT
$CONSOLE:ONLY
_DEST _CONSOLE
'Constants
CONST SCS_32BIT_BINARY = 0
CONST SCS_64BIT_BINARY = 6
CONST SCS_DOS_BINARY = 1
CONST SCS_OS216_BINARY = 5
CONST SCS_PIF_BINARY = 3
CONST SCS_POSIX_BINARY = 4
CONST SCS_WOW_BINARY = 2

DECLARE DYNAMIC LIBRARY "Kernel32"
    FUNCTION GetBinaryType%% ALIAS GetBinaryTypeA (BYVAL lpApplicationName AS _OFFSET, BYVAL lpBinaryType AS _OFFSET)
END DECLARE

DIM app AS STRING
DIM bin AS LONG

app = "C:\Users\Zachary\Desktop\QB64 x64\qb64.exe" + CHR$(0)
DIM a AS _BYTE
a = GetBinaryType(_OFFSET(app), _OFFSET(bin))

IF a <> 0 THEN
    SELECT CASE bin
        CASE SCS_32BIT_BINARY
            PRINT "32-bit Windows-based application"
        CASE SCS_64BIT_BINARY
            PRINT "64-bit Windows-based application"
        CASE SCS_DOS_BINARY
            PRINT "MS-DOS-based application"
        CASE SCS_OS216_BINARY
            PRINT "16-bit OS/2-based application"
        CASE SCS_PIF_BINARY
            PRINT "PIF file that executes an MS-DOS-based application"
        CASE SCS_POSIX_BINARY
            PRINT "POSIX-based application"
        CASE SCS_WOW_BINARY
            PRINT "16-bit Windows-based application"
    END SELECT
END IF

SLEEP
