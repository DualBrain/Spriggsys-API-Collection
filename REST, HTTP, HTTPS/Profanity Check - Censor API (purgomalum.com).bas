$CONSOLE:ONLY
_DEST _CONSOLE
PRINT CheckProfanity("This is bullcrap, you know", "*")
SLEEP
FUNCTION CheckProfanity$ (text AS STRING, fillchar AS STRING)
    DIM URL AS STRING
    DIM URLFile AS STRING
    DIM a%
    DIM Request AS STRING
    URLFile = "profanitycheck"
    URL = "https://www.purgomalum.com/service/plain?text=" + FormatAsHTTP(text) + "&add=input&fill_char=" + fillchar
    a% = API_Request(URL, URLFile)
    DIM U AS INTEGER
    U = FREEFILE
    OPEN URLFile FOR BINARY AS #U
    IF LOF(U) <> 0 THEN
        LINE INPUT #U, Request
    ELSE
        CLOSE #U
        KILL URLFile
        CheckProfanity = ""
        EXIT FUNCTION
    END IF
    CLOSE #U
    KILL URLFile
    CheckProfanity = Request
END FUNCTION
FUNCTION FormatAsHTTP$ (Request AS STRING)
    start% = 1
    DO
        position% = INSTR(start%, Request, " ")
        IF position% THEN
            MID$(Request, position%, 1) = "+"
            start% = position% + 1
        END IF
    LOOP UNTIL position% = 0
    FormatAsHTTP = Request
END FUNCTION
DECLARE DYNAMIC LIBRARY "urlmon"
    FUNCTION URLDownloadToFileA (BYVAL pCaller AS LONG, szURL AS STRING, szFileName AS STRING, BYVAL dwReserved AS LONG, BYVAL lpfnCB AS LONG)
END DECLARE
FUNCTION API_Request (URL AS STRING, File AS STRING)
    API_Request = URLDownloadToFileA(0, URL + CHR$(0), File + CHR$(0), 0, 0)
END FUNCTION
