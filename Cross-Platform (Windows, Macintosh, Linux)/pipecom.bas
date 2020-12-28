OPTION _EXPLICIT
$IF WIN THEN
    DECLARE LIBRARY ".\pipecom"
    $ELSE
    DECLRE LIBRARY "./pipecom"
    $END IF
    FUNCTION pipecom$ (cmd AS STRING)
END DECLARE

DIM comm AS STRING

comm = pipecom("dir /b *.BAS")

PRINT comm
