$CONSOLE:ONLY
_DEST _CONSOLE
PRINT GetLyrics("Demon Hunter", "I Am A Stone")
SLEEP
FUNCTION GetLyrics$ (artist AS STRING, title AS STRING)
    DIM URL AS STRING
    DIM URLFile AS STRING
    DIM a%
    DIM Request AS STRING
    URLFile = "lyricsapirequest"
    URL = "https://api.lyrics.ovh/v1/" + FormatAsHTTP(artist) + "/" + FormatAsHTTP(title)
    a% = API_Request(URL, URLFile)
    DIM U AS INTEGER
    U = FREEFILE
    OPEN URLFile FOR BINARY AS #U
    IF LOF(U) <> 0 THEN
        Request = SPACE$(LOF(U))
        GET #U, , Request
    ELSE
        CLOSE #U
        KILL URLFile
        GetLyrics = ""
        EXIT FUNCTION
    END IF
    CLOSE #U
    KILL URLFile
    Request = GetKey(Request, "lyrics")
    Request = MID$(String.Replace(Request, "\r", CHR$(10)), 12)
    Request = String.Replace(Request, "\n\n", CHR$(10))
    Request = String.Replace(Request, "\n", "")
    Request = String.Replace(Request, "\" + CHR$(34), CHR$(34))
    GetLyrics = Request
END FUNCTION
FUNCTION GetKey$ (JSON AS STRING, keyname AS STRING)
    DIM jkey AS STRING
    jkey = JSON
    IF INSTR(jkey, CHR$(34) + keyname + CHR$(34)) THEN
        jkey = MID$(jkey, INSTR(jkey, CHR$(34) + keyname + CHR$(34)) + LEN(keyname))
        jkey = MID$(jkey, INSTR(jkey, ":") + 1)
        jkey = String.Replace(jkey, "\" + CHR$(34), "'")
        IF MID$(jkey, 1, 1) = CHR$(34) THEN
            jkey = MID$(jkey, 2)
        END IF
        jkey = MID$(jkey, 1, INSTR(jkey, CHR$(34)) - 1)
        IF RIGHT$(jkey, 1) = "," THEN
            jkey = MID$(jkey, 1, LEN(jkey) - 1)
        END IF
    ELSE
        GetKey = ""
    END IF
    GetKey = jkey
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
FUNCTION String.Replace$ (a AS STRING, b AS STRING, c AS STRING)
    j = INSTR(a, b)
    IF j > 0 THEN
        r$ = LEFT$(a, j - 1) + c + String.Replace(RIGHT$(a, LEN(a) - j + 1 - LEN(b)), b, c)
    ELSE
        r$ = a
    END IF
    String.Replace = r$
END FUNCTION
DECLARE DYNAMIC LIBRARY "urlmon"
    FUNCTION URLDownloadToFileA (BYVAL pCaller AS LONG, szURL AS STRING, szFileName AS STRING, BYVAL dwReserved AS LONG, BYVAL lpfnCB AS LONG)
END DECLARE
FUNCTION API_Request (URL AS STRING, File AS STRING)
    API_Request = URLDownloadToFileA(0, URL + CHR$(0), File + CHR$(0), 0, 0)
END FUNCTION
