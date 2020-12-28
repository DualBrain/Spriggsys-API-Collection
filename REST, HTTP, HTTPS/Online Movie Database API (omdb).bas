OPTION _EXPLICIT
$SCREENHIDE
$CONSOLE

CONST INTERNET_OPEN_TYPE_PRECONFIG = 0
CONST INTERNET_OPEN_TYPE_DIRECT = 1
CONST INTERNET_OPEN_TYPE_PROXY = 3
CONST INTERNET_OPEN_TYPE_PRECONF_NO_AUTOPROXY = 4

CONST INTERNET_DEFAULT_FTP_PORT = 21
CONST INTERNET_DEFAULT_GOPHER_PORT = 70
CONST INTERNET_DEFAULT_HTTP_PORT = 80
CONST INTERNET_DEFAULT_HTTPS_PORT = 443
CONST INTERNET_DEFAULT_SOCKS_PORT = 1080

CONST INTERNET_SERVICE_FTP = 1
CONST INTERNET_SERVICE_GOPHER = 2
CONST INTERNET_SERVICE_HTTP = 3

'Flags
CONST INTERNET_FLAG_ASYNC = &H10000000
CONST INTERNET_FLAG_FROM_CACHE = &H01000000
CONST INTERNET_FLAG_OFFLINE = INTERNET_FLAG_FROM_CACHE
CONST INTERNET_FLAG_PASSIVE = &H08000000
CONST INTERNET_FLAG_SECURE = &H00800000
CONST INTERNET_FLAG_KEEP_CONNECTION = &H00400000
CONST INTERNET_FLAG_NO_AUTO_REDIRECT = &H00200000
CONST INTERNET_FLAG_READ_PREFETCH = &H00100000
CONST INTERNET_FLAG_NO_COOKIES = &H00080000
CONST INTERNET_FLAG_NO_AUTH = &H00040000
CONST INTERNET_FLAG_RESTRICTED_ZONE = &H00020000
CONST INTERNET_FLAG_CACHE_IF_NET_FAIL = &H00010000
CONST INTERNET_FLAG_RELOAD = &H80000000

CONST TRUE = -1
CONST FALSE = 0

CONST MAX_PATH = 260

DECLARE DYNAMIC LIBRARY "Wininet"
    FUNCTION InternetOpen& ALIAS InternetOpenA (BYVAL lpszAgent AS _OFFSET, BYVAL dwAccessType AS LONG, BYVAL lpszProxy AS _OFFSET, BYVAL lpszProxyBypass AS _OFFSET, BYVAL dwFlags AS LONG)
    FUNCTION InternetConnect& ALIAS InternetConnectA (BYVAL hInternet AS LONG, BYVAL lpszServerName AS _OFFSET, BYVAL nServerPort AS INTEGER, BYVAL lpszUserName AS _OFFSET, BYVAL lpszPassword AS _OFFSET, BYVAL dwService AS LONG, BYVAL dwFlags AS LONG, BYVAL dwContext AS _OFFSET)
    FUNCTION HTTPOpenRequest& ALIAS HttpOpenRequestA (BYVAL hConnect AS LONG, BYVAL lpszVerb AS _OFFSET, BYVAL lpszObjectName AS _OFFSET, BYVAL lpszVersion AS _OFFSET, BYVAL lpszReferrer AS _OFFSET, BYVAL lpszAcceptTypes AS _OFFSET, BYVAL dwFlags AS LONG, BYVAL dwContext AS _OFFSET)
    FUNCTION HTTPSendRequest%% ALIAS HttpSendRequestA (BYVAL hRequest AS LONG, BYVAL lpszHeaders AS _OFFSET, BYVAL dwHeadersLength AS LONG, BYVAL lpOptional AS _OFFSET, BYVAL dwOptionalLength AS LONG)
    FUNCTION InternetCloseHandle%% (BYVAL hInternet AS LONG)
    FUNCTION InternetReadFile%% (BYVAL hFile AS LONG, BYVAL lpBuffer AS _OFFSET, BYVAL dwNumberOfBytesToRead AS LONG, BYVAL lpdwNumberOfBytesRead AS _OFFSET)
END DECLARE

DECLARE DYNAMIC LIBRARY "Kernel32"
    FUNCTION GetTempFileName~% ALIAS GetTempFileNameA (BYVAL lpPathName AS _OFFSET, BYVAL lpPrefixString AS _OFFSET, BYVAL uUnique AS _UNSIGNED INTEGER, BYVAL lpTempFileName AS _OFFSET)
    FUNCTION GetTempPath& ALIAS GetTempPathA (BYVAL nBufferLength AS LONG, BYVAL lpBuffer AS _OFFSET)
END DECLARE

_SCREENHIDE
_TITLE "OMDB API - Poster"
_CONSOLETITLE "OMDB API - Movie Info"

DIM title AS STRING

_DEST _CONSOLE
LINE INPUT "Movie Title: ", title

DIM hsession AS LONG
hsession = InternetOpen(0, INTERNET_OPEN_TYPE_DIRECT, 0, 0, 0)

DIM httpsession AS LONG
DIM URL AS STRING
URL = "omdbapi.com" + CHR$(0)
httpsession = InternetConnect(hsession, _OFFSET(URL), INTERNET_DEFAULT_HTTP_PORT, 0, 0, INTERNET_SERVICE_HTTP, 0, 0)

DIM httpRequest AS LONG
DIM sessiontype AS STRING
sessiontype = "GET" + CHR$(0)
DIM location AS STRING
location = "/?apikey=a6984482&t=" + FormatAsHTTP(title) + CHR$(0)
httpRequest = HTTPOpenRequest(httpsession, _OFFSET(sessiontype), _OFFSET(location), 0, 0, 0, INTERNET_FLAG_RELOAD, 0)

DIM sendrequest AS LONG
sendrequest = HTTPSendRequest(httpRequest, 0, 0, 0, 0)
DIM szBuffer AS STRING
szBuffer = SPACE$(2048)
DIM dwRead AS LONG
DIM readfile AS LONG

readfile = InternetReadFile(httpRequest, _OFFSET(szBuffer), LEN(szBuffer), _OFFSET(dwRead))

DIM response AS STRING
response = _TRIM$(szBuffer)

_ECHO "Movie       : " + GetKey(response, "Title")
_ECHO "Release Date: " + GetKey(response, "Released")
_ECHO GetKey(response, "Plot")
DIM poster AS STRING
poster = GetKey(response, "Poster")

DIM i&
i& = OnlineImage(poster)
IF i& <> -1 AND i& <> 0 THEN
    SCREEN i&
    _SCREENSHOW
END IF
SLEEP

FUNCTION OnlineImage& (URL AS STRING)
    DIM getpath AS LONG
    DIM getfile AS _UNSIGNED INTEGER

    DIM path AS STRING
    path = SPACE$(MAX_PATH + 1)
    getpath = GetTempPath(LEN(path), _OFFSET(path))

    path = _TRIM$(path)

    DIM file AS STRING
    DIM prefix AS STRING
    DIM unique AS _UNSIGNED INTEGER
    RANDOMIZE TIMER
    unique = INT(RND * 999) + 1
    prefix = "spr" + CHR$(0)
    DIM tempfile AS STRING
    tempfile = SPACE$(MAX_PATH + 1)

    getfile = GetTempFileName(_OFFSET(path), _OFFSET(prefix), unique, _OFFSET(tempfile))

    tempfile = _TRIM$(tempfile)

    URL = MID$(URL, INSTR(URL, "https://") + 8)
    DIM location AS STRING
    location = MID$(URL, INSTR(URL, "/")) + CHR$(0)
    URL = MID$(URL, 1, INSTR(URL, "/") - 1) + CHR$(0)
    DIM hsession AS LONG
    hsession = InternetOpen(0, INTERNET_OPEN_TYPE_DIRECT, 0, 0, 0)

    DIM httpsession AS LONG
    httpsession = InternetConnect(hsession, _OFFSET(URL), INTERNET_DEFAULT_HTTPS_PORT, 0, 0, INTERNET_SERVICE_HTTP, 0, 0)

    DIM httpRequest AS LONG
    DIM sessiontype AS STRING
    sessiontype = "GET" + CHR$(0)
    httpRequest = HTTPOpenRequest(httpsession, _OFFSET(sessiontype), _OFFSET(location), 0, 0, 0, INTERNET_FLAG_RELOAD OR INTERNET_FLAG_SECURE, 0)

    DIM sendrequest AS LONG
    sendrequest = HTTPSendRequest(httpRequest, 0, 0, 0, 0)
    DIM szBuffer AS STRING
    szBuffer = SPACE$(1024)
    DIM dwRead AS LONG
    DIM picfile AS STRING
    OPEN tempfile FOR BINARY AS #1
    WHILE InternetReadFile(httpRequest, _OFFSET(szBuffer), LEN(szBuffer), _OFFSET(dwRead)) AND dwRead <> 0
        picfile = picfile + MID$(szBuffer, 1, dwRead)
    WEND
    PUT #1, , picfile
    CLOSE #1

    DIM closeh AS LONG
    closeh = InternetCloseHandle(hsession)
    OnlineImage = _LOADIMAGE(tempfile, 32)
    KILL tempfile
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
