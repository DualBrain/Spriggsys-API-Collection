$SCREENHIDE
$CONSOLE
_SCREENHIDE
_TITLE "Owl Dictionary API - Image"
_CONSOLETITLE "Owl Dictionary API - Info"
OPTION BASE 1
DIM owlrequest AS STRING
DIM headers(1) AS STRING
DIM searchterm AS STRING
_DEST _CONSOLE
LINE INPUT "Input a search term: ", searchterm
CLS
_DEST 0
headers(1) = "Authorization: Token 6d6f2bbb4374d34161b0fdb0aa59f5f11716d5a6"
owlrequest = CURL("https://owlbot.info/api/v4/dictionary/" + searchterm, headers(), "owldictionary")
_ECHO GetKey(owlrequest, "definition")
SCREEN OnlineImage(GetKey(owlrequest, "image_url"), "dictionaryimage")
_SCREENSHOW
SLEEP
DECLARE DYNAMIC LIBRARY "urlmon"
    FUNCTION URLDownloadToFileA (BYVAL pCaller AS LONG, szURL AS STRING, szFileName AS STRING, BYVAL dwReserved AS LONG, BYVAL lpfnCB AS LONG)
END DECLARE
FUNCTION CURL$ (URL AS STRING, Headers() AS STRING, File AS STRING)
    DIM curlresponse AS STRING
    DIM request AS STRING
    request = "curl " + CHR$(34) + URL + CHR$(34)
    FOR x = LBOUND(Headers) TO UBOUND(Headers)
        request = request + " -H " + CHR$(34) + Headers(x) + CHR$(34)
    NEXT
    request = request + " -o " + CHR$(34) + File + CHR$(34)
    SHELL _HIDE request
    DIM U AS INTEGER
    U = FREEFILE
    OPEN File FOR BINARY AS #U
    IF LOF(U) <> 0 THEN
        curlresponse = SPACE$(LOF(U))
        GET #U, , curlresponse
        CLOSE #U
        KILL File
    ELSE
        CLOSE #U
        KILL File
        CURL = ""
        EXIT FUNCTION
    END IF
    CURL = curlresponse
END FUNCTION
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
    OnlineImage = i&
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
FUNCTION String.Replace$ (a AS STRING, b AS STRING, c AS STRING)
    DIM j
    DIM r
    DIM r$
    j = INSTR(a, b)
    IF j > 0 THEN
        r$ = LEFT$(a, j - 1) + c + String.Replace(RIGHT$(a, LEN(a) - j + 1 - LEN(b)), b, c)
    ELSE
        r$ = a
    END IF
    String.Replace = r$
END FUNCTION
FUNCTION FormatAsHTTP$ (paramater AS STRING)
    DIM Request AS STRING
    Request = paramater
    DIM start%
    DIM position%
    start% = 1
    DO
        position% = INSTR(start%, Request, " ")
        IF position% THEN
            MID$(Request, position%, 1) = "+"
            start% = position% + 1
        END IF
    LOOP UNTIL position% = 0
    Request = String.Replace(Request, "'", "%27")
    FormatAsHTTP = Request
END FUNCTION
