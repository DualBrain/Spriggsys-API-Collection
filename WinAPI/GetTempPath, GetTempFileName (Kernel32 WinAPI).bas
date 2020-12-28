OPTION _EXPLICIT
$CONSOLE:ONLY
_DEST _CONSOLE
RANDOMIZE TIMER

CONST MAX_PATH = 260

DECLARE DYNAMIC LIBRARY "Kernel32"
    FUNCTION GetTempFileName~% ALIAS GetTempFileNameA (BYVAL lpPathName AS _OFFSET, BYVAL lpPrefixString AS _OFFSET, BYVAL uUnique AS _UNSIGNED INTEGER, BYVAL lpTempFileName AS _OFFSET)
    FUNCTION GetTempPath& ALIAS GetTempPathA (BYVAL nBufferLength AS LONG, BYVAL lpBuffer AS _OFFSET)
END DECLARE

DIM getpath AS LONG
DIM getfile AS _UNSIGNED INTEGER

DIM path AS STRING
path = SPACE$(MAX_PATH + 1)
getpath = GetTempPath(LEN(path), _OFFSET(path))
PRINT getpath
IF getpath THEN
    path = _TRIM$(path)
    PRINT path
END IF

DIM file AS STRING
DIM prefix AS STRING
DIM unique AS _UNSIGNED INTEGER
unique = INT(RND * 999) + 1
prefix = "spr" + CHR$(0)
DIM filename AS STRING
filename = SPACE$(MAX_PATH + 1)

getfile = GetTempFileName(_OFFSET(path), _OFFSET(prefix), unique, _OFFSET(filename))

PRINT getfile
IF getfile THEN
    filename = _TRIM$(filename)
    PRINT filename
END IF

SLEEP
