$CONSOLE:ONLY
_DEST _CONSOLE

CONST SE_ERR_FNF = 2 'File not found
CONST SE_ERR_PNF = 3 'Invalid path
CONST SE_ERR_ACCESSDENIED = 5 'File cannot be accessed
CONST SE_ERR_OOM = 8 'System out of memory or resources
CONST SE_ERR_NOASSOC = 31 'No associated program for the file type

DECLARE DYNAMIC LIBRARY "Shell32"
    FUNCTION FindExecutable& ALIAS FindExecutableA (BYVAL lpFile AS _OFFSET, BYVAL lpDirectory AS _OFFSET, BYVAL lpResult AS _OFFSET)
END DECLARE

PRINT FindEXE(_DIR$("desktop") + "QB64 x64\FileOps.BM")
SLEEP

FUNCTION FindEXE$ (file AS STRING)
    DIM a AS LONG
    DIM directory AS STRING
    DIM result AS STRING
    file = file + CHR$(0)
    directory = directory + CHR$(0)
    result = SPACE$(260)
    a = FindExecutable(_OFFSET(file), _OFFSET(directory), _OFFSET(result))
    FindEXE = _TRIM$(result)
END FUNCTION
