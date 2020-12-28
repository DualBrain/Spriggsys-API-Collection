_TITLE "www.qb64.org QR Image"

DIM qb64 AS STRING
qb64 = "qb64q4.png"

SCREEN OnlineImage("https://qrtag.net/api/qr.png?url=https://www.qb64.org", qb64)
SLEEP


DECLARE DYNAMIC LIBRARY "urlmon"
    FUNCTION URLDownloadToFileA (BYVAL pCaller AS LONG, szURL AS STRING, szFileName AS STRING, BYVAL dwReserved AS LONG, BYVAL lpfnCB AS LONG)
END DECLARE

FUNCTION OnlineImage& (URL AS STRING, File AS STRING)
    DIM apireq AS STRING
    DIM a%
    DIM i&
    a% = URLDownloadToFileA(0, URL + CHR$(0), File + CHR$(0), 0, 0)
    DIM U AS INTEGER
    U = FREEFILE
    OPEN File FOR BINARY AS #U
    IF LOF(U) <> 0 THEN
        CLOSE #U
        i& = _LOADIMAGE(File, 32)
        KILL File
    ELSE
        i& = 0
        CLOSE #U
        KILL File
    END IF
    IF i& <> -1 THEN
        OnlineImage = i&
    END IF
END FUNCTION
