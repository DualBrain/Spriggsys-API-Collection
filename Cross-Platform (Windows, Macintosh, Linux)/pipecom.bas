OPTION _EXPLICIT

DECLARE LIBRARY "pipecom"
    FUNCTION pipecom$ (cmd AS STRING)
END DECLARE

DIM comm AS STRING

comm = pipecom("dir /b *.BAS")

PRINT comm
