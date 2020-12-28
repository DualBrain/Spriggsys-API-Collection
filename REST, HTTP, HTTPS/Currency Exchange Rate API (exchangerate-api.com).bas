$CONSOLE:ONLY
_DEST _CONSOLE
PRINT "The exchange rate of USD to KRW is : "; ExchangeRate("USD", "KRW")
SLEEP
FUNCTION ExchangeRate$ (currency1 AS STRING, currency2 AS STRING)
    DIM URL AS STRING
    DIM URLFile AS STRING
    DIM a%
    DIM Request AS STRING
    URLFile = "exchangerate"
    URL = " https://v6.exchangerate-api.com/v6/2710d7752709777be2f3355c/latest/" + currency1
    a% = API_Request(URL, URLFile)
    DIM U AS INTEGER
    U = FREEFILE
    OPEN URLFile FOR BINARY AS #U
    IF LOF(U) <> 0 THEN
        LINE INPUT #U, Request
    ELSE
        CLOSE #U
        KILL URLFile
        ExchangeRate = ""
        EXIT FUNCTION
    END IF
    CLOSE #U
    KILL URLFile
    IF INSTR(Request, currency2) THEN
        ExchangeRate = _TRIM$(STR$(VAL(MID$(Request, INSTR(Request, currency2) + LEN(currency2) + 2, 10))))
    ELSE
        ExchangeRate = "Not found"
    END IF
END FUNCTION
DECLARE DYNAMIC LIBRARY "urlmon"
    FUNCTION URLDownloadToFileA (BYVAL pCaller AS LONG, szURL AS STRING, szFileName AS STRING, BYVAL dwReserved AS LONG, BYVAL lpfnCB AS LONG)
END DECLARE
FUNCTION API_Request (URL AS STRING, File AS STRING)
    API_Request = URLDownloadToFileA(0, URL + CHR$(0), File + CHR$(0), 0, 0)
END FUNCTION
