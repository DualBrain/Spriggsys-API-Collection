$CONSOLE:ONLY
_DEST _CONSOLE

DECLARE DYNAMIC LIBRARY "Shell32"
    FUNCTION EnvironmentVariable& ALIAS DoEnvironmentSubstA (BYVAL pszSrc AS _OFFSET, BYVAL cchSrc AS _UNSIGNED INTEGER)
END DECLARE

DECLARE DYNAMIC LIBRARY "Kernel32"
    FUNCTION ExpandEnvironmentStrings& ALIAS ExpandEnvironmentStringsA (BYVAL lpSrc AS _OFFSET, BYVAL lpDst AS _OFFSET, BYVAL nSize AS LONG)
    FUNCTION GetEnvironmentVariableA& (BYVAL lpName AS _OFFSET, BYVAL lpBuffer AS _OFFSET, BYVAL nSize AS LONG)
END DECLARE

DIM variable AS STRING

PRINT "WinAPI Shell32 DoEnvironmentSubstS Version:"
x# = TIMER(0.00001)
OPEN "environment variables.txt" FOR BINARY AS #1
DO
    LINE INPUT #1, variable
    variable = "%" + variable + "%"
    PRINT variable, Env(variable)
    PRINT
LOOP UNTIL EOF(1)
CLOSE #1
y# = TIMER(0.00001)
PRINT y# - x#
PRINT "============================================================="
PRINT
PRINT "WinAPI Kernel32 ExpandEnvironmentStringsA Version:"
x# = TIMER(0.00001)
OPEN "environment variables.txt" FOR BINARY AS #1
DO
    LINE INPUT #1, variable
    variable = "%" + variable + "%"
    PRINT variable, Env2(variable)
    PRINT
LOOP UNTIL EOF(1)
CLOSE #1
y# = TIMER(0.00001)
PRINT y# - x#
PRINT "============================================================"
PRINT
PRINT "WinAPI Kernel32 GetEnvironmentVariable Version:"
x# = TIMER(0.00001)
OPEN "environment variables.txt" FOR BINARY AS #1
DO
    LINE INPUT #1, variable
    variable = "%" + variable + "%"
    PRINT variable, Env2(variable)
    PRINT
LOOP UNTIL EOF(1)
CLOSE #1
y# = TIMER(0.00001)
PRINT y# - x#
PRINT "============================================================"
PRINT
PRINT "QB64 ENVIRON$ Version:"
x# = TIMER(0.00001)
OPEN "environment variables.txt" FOR BINARY AS #1
DO
    LINE INPUT #1, variable
    PRINT "%" + variable + "%", ENVIRON$(variable)
    PRINT
LOOP UNTIL EOF(1)
CLOSE #1
y# = TIMER(0.00001)
PRINT y# - x#

SLEEP

FUNCTION Env$ (variable AS STRING)
    DIM size AS _UNSIGNED INTEGER
    size = LEN(variable)
    variable = variable + STRING$(65535 - size, 0)
    size = LEN(variable)
    DIM a AS LONG
    a = EnvironmentVariable(_OFFSET(variable), size)
    IF INSTR(variable, CHR$(0)) THEN
        Env = LEFT$(variable, INSTR(variable, CHR$(0)))
    ELSE
        Env = variable
    END IF
END FUNCTION

FUNCTION Env2$ (variable AS STRING) '3 times slower than Env
    DIM varexpand AS STRING
    varexpand = STRING$(1024, 0)
    DIM a AS LONG
    DIM size AS LONG
    size = LEN(varexpand)
    a = ExpandEnvironmentStrings(_OFFSET(variable), _OFFSET(varexpand), size)
    IF INSTR(variable, CHR$(0)) THEN
        Env2 = LEFT$(varexpand, INSTR(varexpand, CHR$(0)))
    ELSE
        Env2 = varexpand
    END IF
END FUNCTION

FUNCTION Env3$ (variable AS STRING)
    DIM varexpand AS STRING
    varexpand = STRING$(1024, 0)
    DIM a AS LONG
    DIM size AS LONG
    size = LEN(varexpand)
    a = GetEnvironmentVariableA(_OFFSET(variable), _OFFSET(varexpand), size)
    IF INSTR(variable, CHR$(0)) THEN
        Env3 = LEFT$(varexpand, INSTR(varexpand, CHR$(0)))
    ELSE
        Env3 = varexpand
    END IF
END FUNCTION
