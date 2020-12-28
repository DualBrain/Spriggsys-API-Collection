PRINT VerifyPhoneNumber("+1 812 282 2444")
SLEEP
FUNCTION VerifyPhoneNumber$ (phone AS STRING)
    DIM URL AS STRING
    DIM URLFile AS STRING
    DIM a%
    DIM Request AS STRING
    URLFile = "validatephone"
    URL = "http://apilayer.net/api/validate?access_key=cbb8c931f063675f26fa538e7c35ff04&number=" + FormatAsHTTP(phone) + "&countrycode=&format=1"
    a% = API_Request(URL, URLFile)
    DIM U AS INTEGER
    U = FREEFILE
    OPEN URLFile FOR BINARY AS #U
    IF LOF(U) <> 0 THEN
        DO
            LINE INPUT #U, Request
        LOOP UNTIL INSTR(Request, "valid")
    ELSE
        CLOSE #U
        KILL URLFile
        VerifyPhoneNumber = ""
        EXIT FUNCTION
    END IF
    CLOSE #U
    KILL URLFile
    IF INSTR(Request, "true") THEN
        VerifyPhoneNumber = MID$(Request, 11, 4)
    ELSE
        VerifyPhoneNumber = MID$(Request, 11, 5)
    END IF
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
