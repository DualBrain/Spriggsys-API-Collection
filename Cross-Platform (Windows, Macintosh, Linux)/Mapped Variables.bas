OPTION _EXPLICIT
$CONSOLE:ONLY
_DEST _CONSOLE

$IF WIN THEN
    DECLARE LIBRARY ".\mappedvar"
    $ELSE
    DECLARE LIBRARY "./mappedvar"
    $END IF
    FUNCTION mapvar% (name AS STRING, value AS STRING)
    FUNCTION getmappedvalue$ (name AS STRING)
END DECLARE

PRINT mapvar("test1", "this is a test")
PRINT mapvar("test2", "this is also a test")
PRINT mapvar("", "this is another test")
PRINT getmappedvalue("test1")
SLEEP
