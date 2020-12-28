$CHECKING:OFF
OPTION _EXPLICIT

_TITLE "NASA Pic of the Day"

DIM i&
SCREEN _NEWIMAGE(_DESKTOPWIDTH, _DESKTOPHEIGHT, 32)
_SCREENSHOW
_FULLSCREEN
i& = NASApod
IF i& <> 0 THEN
    _PUTIMAGE , i&, 0
    _ICON _DISPLAY
END IF
'day = 86399
DIM start AS LONG
DO
    start = TIMER
    IF start = 18000 THEN
        i& = NASApod
        IF i& <> 0 THEN
            _PUTIMAGE , i&, 0
            _ICON _DISPLAY
        END IF
        _DELAY 1
    END IF
    _LIMIT 30
LOOP UNTIL INKEY$ <> ""
SYSTEM

FUNCTION NASApod&
    DIM URL AS STRING
    DIM URLFile AS STRING
    DIM nasapic AS STRING
    DIM picdate AS STRING
    DIM a%
    picdate = MID$(DATE$, 7) + "-" + MID$(DATE$, 1, 2) + "-" + MID$(DATE$, 4, 2)
    URLFile = "nasapod.json"
    URL = "https://api.nasa.gov/planetary/apod?date=" + picdate + "&api_key=DEMO_KEY"
    a% = API_request(URL, URLFile)
    DIM U AS INTEGER
    U = FREEFILE
    OPEN URLFile FOR BINARY AS #U
    IF LOF(U) <> 0 THEN
        nasapic = SPACE$(LOF(U))
        GET #U, , nasapic
    ELSE
        CLOSE #U
        KILL URLFile
        NASApod = 0
        EXIT FUNCTION
    END IF
    CLOSE #U
    KILL URLFile
    nasapic = GetKey("hdurl", nasapic)
    URLFile = "nasapod.jpg"
    URL = nasapic
    a% = API_request(URL, URLFile)
    OPEN URLFile FOR BINARY AS #U
    IF LOF(U) <> 0 THEN
        NASApod = _LOADIMAGE(URLFile, 32)
    ELSE
        CLOSE #U
        KILL URLFile
        NASApod = 0
    END IF
    CLOSE #U
    KILL URLFile
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
    DIM jkey AS STRING
    DIM x
    DO
        IF INSTR(JSON, CHR$(34) + keyname + CHR$(34)) THEN
            x = x + 1
            REDIM _PRESERVE ParseKey(x) AS STRING
            JSON = MID$(JSON, INSTR(JSON, CHR$(34) + keyname + CHR$(34)) + LEN(keyname))
            jkey = JSON
            jkey = MID$(jkey, INSTR(jkey, ":") + 1)
            IF MID$(jkey, 1, 1) = CHR$(34) THEN
                jkey = MID$(jkey, 2)
            END IF
            jkey = MID$(jkey, 1, INSTR(jkey, CHR$(34)) - 1)
            IF RIGHT$(jkey, 1) = "," THEN
                jkey = MID$(jkey, 1, LEN(jkey) - 1)
            END IF
            ParseKey(x) = jkey
        END IF
    LOOP UNTIL INSTR(JSON, CHR$(34) + keyname + CHR$(34)) = 0
END SUB
