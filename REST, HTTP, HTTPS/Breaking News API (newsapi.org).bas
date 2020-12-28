SCREEN _NEWIMAGE(_DESKTOPWIDTH, _DESKTOPHEIGHT, 32)
_FULLSCREEN
txt$ = GetNews("2020-07-28", "2020-07-30", "coronavirus")
txtlen = LEN(txt$)
chars = 44
DIM i&
i& = _LOADFONT(ENVIRON$("SYSTEMROOT") + "\fonts\cour.ttf", 72, "MONOSPACE")
_FONT i&
starttime = TIMER 'start a timer...
DO
    IF TIMER - starttime > .10 THEN GOSUB TitleScroll
    _LIMIT 60
LOOP UNTIL INKEY$ <> ""
SYSTEM
TitleScroll: 'Ahhh! A GOSUB routine!!  RUN!!!
c = c + 1: IF c >= txtlen THEN c = 1
t2$ = RIGHT$(txt$, txtlen - 1) + LEFT$(txt$, 1)
LOCATE 8
txt$ = t2$: PRINT LEFT$(txt$, chars);
_DISPLAY
CLS
starttime = TIMER
RETURN
FUNCTION GetNews$ (startdate AS STRING, enddate AS STRING, topic AS STRING)
    DIM URL AS STRING
    DIM URLFile AS STRING
    DIM newsrequest AS STRING
    DIM a%
    URLFile = "newsrequest"
    URL = "http://newsapi.org/v2/everything?q=" + FormatAsHTTP(topic) + "&from=" + startdate + "&to=" + enddate + "&sortBy=popularity&apiKey=8509ac8ea3b14cadbb1cafc08cacf1cd"
    a% = API_request(URL, URLFile)
    DIM U AS INTEGER
    U = FREEFILE
    OPEN URLFile FOR BINARY AS #U
    IF LOF(U) <> 0 THEN
        newsrequest = SPACE$(LOF(U))
        GET #U, , newsrequest
        CLOSE #U
        KILL URLFile
    ELSE
        CLOSE #U
        KILL URLFile
        GetNews = ""
        EXIT FUNCTION
    END IF
    REDIM headlines(0) AS STRING
    REDIM journals(0) AS STRING
    DIM x AS INTEGER
    GetAllKey "name", newsrequest, journals()
    GetAllKey "title", newsrequest, headlines()
    newsrequest = ""
    FOR x = 1 TO UBOUND(journals)
        newsrequest = newsrequest + "....From " + journals(x) + ": " + headlines(x) + "  "
    NEXT
    GetNews = newsrequest
END FUNCTION
FUNCTION FormatAsHTTP$ (Request AS STRING)
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
    FormatAsHTTP = Request
END FUNCTION
DECLARE DYNAMIC LIBRARY "urlmon"
    FUNCTION URLDownloadToFileA (BYVAL pCaller AS LONG, szURL AS STRING, szFileName AS STRING, BYVAL dwReserved AS LONG, BYVAL lpfnCB AS LONG)
END DECLARE
FUNCTION API_request (URL AS STRING, File AS STRING)
    API_request = URLDownloadToFileA(0, URL + CHR$(0), File + CHR$(0), 0, 0)
END FUNCTION
FUNCTION GetKey$ (keyname AS STRING, JSON AS STRING)
    DIM jkey AS STRING
    IF INSTR(JSON, CHR$(34) + keyname + CHR$(34)) THEN
        jkey = MID$(JSON, INSTR(JSON, CHR$(34) + keyname + CHR$(34)) + LEN(keyname))
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
SUB GetAllKey (keyname AS STRING, JSON AS STRING, ParseKey() AS STRING)
    DIM unchangejson AS STRING
    DIM jkey AS STRING
    DIM x
    unchangejson = JSON
    DO
        IF INSTR(unchangejson, CHR$(34) + keyname + CHR$(34)) THEN
            x = x + 1
            REDIM _PRESERVE ParseKey(x) AS STRING
            unchangejson = MID$(unchangejson, INSTR(unchangejson, CHR$(34) + keyname + CHR$(34)) + LEN(keyname))
            jkey = unchangejson
            jkey = MID$(jkey, INSTR(jkey, ":") + 1)
            jkey = String.Replace(jkey, "\" + CHR$(34), "'")
            IF MID$(jkey, 1, 1) = CHR$(34) THEN
                jkey = MID$(jkey, 2)
            END IF
            jkey = MID$(jkey, 1, INSTR(jkey, CHR$(34)) - 1)
            IF RIGHT$(jkey, 1) = "," THEN
                jkey = MID$(jkey, 1, LEN(jkey) - 1)
            END IF
            ParseKey(x) = jkey
        END IF
    LOOP UNTIL INSTR(unchangejson, CHR$(34) + keyname + CHR$(34)) = 0
END SUB
FUNCTION String.Replace$ (a AS STRING, b AS STRING, c AS STRING)
    j = INSTR(a, b)
    IF j > 0 THEN
        r$ = LEFT$(a, j - 1) + c + String.Replace(RIGHT$(a, LEN(a) - j + 1 - LEN(b)), b, c)
    ELSE
        r$ = a
    END IF
    String.Replace = r$
END FUNCTION
