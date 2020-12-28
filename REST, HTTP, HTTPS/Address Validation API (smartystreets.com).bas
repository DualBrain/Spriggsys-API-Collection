$CONSOLE:ONLY
_DEST _CONSOLE
TYPE USaddress
    Street AS STRING
    City AS STRING
    State AS STRING
END TYPE
DIM Address AS USaddress
Address.Street = "1600 Pennsylvania Avenue NW"
Address.City = "Washington"
Address.State = "DC"
PRINT ValidateAddress(Address)
SLEEP
FUNCTION ValidateAddress$ (Address AS USaddress)
    DIM URL AS STRING
    DIM URLFile AS STRING
    URL = "https://us-street.api.smartystreets.com/street-address?auth-id=97ed8c65-65e9-15b3-bb13-e7a273f89201&auth-token=II37ShOD5d2gwadEulUM&"
    URL = URL + "street=" + FormatAsHTTP(Address.Street) + "&"
    URL = URL + "city=" + FormatAsHTTP(Address.City) + "&"
    URL = URL + "state=" + Address.State + "&"
    URL = URL + "candidates=1"
    URLFile = "addressvalidation.json"
    a% = FileDownload(URL, URLFile)
    DIM U AS INTEGER
    U = FREEFILE
    OPEN URLFile FOR BINARY AS #U
    IF LOF(U) <> 0 THEN
        LINE INPUT #U, result$
    ELSE
        CLOSE #U
        KILL URLFile
        ValidateAddress = "Could not validate"
        EXIT FUNCTION
    END IF
    CLOSE #U
    KILL URLFile
    validation$ = MID$(result$, INSTR(result$, "dpv_match_code") + 17, 1)
    IF validation$ = "Y" THEN
        ValidateAddress = "Address exists and is correct"
    ELSE
        ValidateAddress = "Address either doesn't exist or is invalid"
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
    FormatAsHTTP = LCASE$(Request)
END FUNCTION
DECLARE DYNAMIC LIBRARY "urlmon"
    FUNCTION URLDownloadToFileA (BYVAL pCaller AS LONG, szURL AS STRING, szFileName AS STRING, BYVAL dwReserved AS LONG, BYVAL lpfnCB AS LONG)
END DECLARE
FUNCTION FileDownload (URL AS STRING, File AS STRING)
    FileDownload = URLDownloadToFileA(0, URL + CHR$(0), File + CHR$(0), 0, 0)
END FUNCTION
