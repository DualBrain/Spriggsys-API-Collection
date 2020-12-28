OPTION _EXPLICIT
$CONSOLE:ONLY
_DEST _CONSOLE
DIM Weather AS STRING
Weather = GetWeather
PRINT Weather
TTS FormatForTTS(Weather)
SLEEP
FUNCTION GetWeather$
    DIM URL AS STRING
    DIM URLFile AS STRING
    DIM weather AS STRING
    DIM county AS STRING
    DIM a%
    URLFile = "weatherrequest"
    DIM state AS STRING
    state = LCASE$(GetStateFromZipCode)
    URL = "https://tgftp.nws.noaa.gov/data/forecasts/zone/" + state + "/" + CrossRefZoneState(UCASE$(state), GetCountyFromZipCode) + ".txt"
    a% = API_request(URL, URLFile)
    DIM U AS INTEGER
    U = FREEFILE
    OPEN URLFile FOR BINARY AS #U
    IF LOF(U) <> 0 THEN
        weather = SPACE$(LOF(U))
        GET #U, , weather
    ELSE
        CLOSE #U
        KILL URLFile
        GetWeather = ""
        EXIT FUNCTION
    END IF
    CLOSE #U
    KILL URLFile
    weather = String.Replace(weather, CHR$(10) + ".", CHR$(10))
    weather = String.Remove(weather, "$$")
    GetWeather = weather
END FUNCTION
FUNCTION CrossRefZoneState$ (state AS STRING, county AS STRING)
    DIM Z AS INTEGER
    Z = FREEFILE
    DIM zone AS STRING
    DIM zones AS STRING
    IF _FILEEXISTS("zones.lst") THEN
        OPEN "zones.lst" FOR BINARY AS #Z
        zones = SPACE$(LOF(Z))
        GET #Z, , zones
        zone = MID$(zones, INSTR(zones, state + "Z"))
        zone = MID$(zone, INSTR(zone, county) - 7, 6)
        CrossRefZoneState = LCASE$(zone)
    ELSE
        CrossRefZoneState = ""
        EXIT FUNCTION
    END IF
END FUNCTION
FUNCTION GetCountyFromZipCode$
    DIM URL AS STRING
    DIM URLFile AS STRING
    DIM county AS STRING
    DIM a%
    URLFile = "county"
    URL = "https://us-zipcode.api.smartystreets.com/lookup?auth-id=97ed8c65-65e9-15b3-bb13-e7a273f89201&auth-token=II37ShOD5d2gwadEulUM&zipcode=" + GetLocationVIAip
    a% = API_request(URL, URLFile)
    DIM U AS INTEGER
    U = FREEFILE
    OPEN URLFile FOR BINARY AS #U
    IF LOF(U) <> 0 THEN
        county = SPACE$(LOF(U))
        GET #U, , county
    ELSE
        CLOSE #U
        KILL URLFile
        GetCountyFromZipCode = ""
        EXIT FUNCTION
    END IF
    CLOSE #U
    KILL URLFile
    county = MID$(county, INSTR(county, "county_name") + 14)
    county = LEFT$(county, INSTR(county, CHR$(34)) - 1)
    GetCountyFromZipCode = county
END FUNCTION
FUNCTION GetStateFromZipCode$
    DIM URL AS STRING
    DIM URLFile AS STRING
    DIM state AS STRING
    DIM a%
    URLFile = "statebyzip"
    URL = "https://us-zipcode.api.smartystreets.com/lookup?auth-id=97ed8c65-65e9-15b3-bb13-e7a273f89201&auth-token=II37ShOD5d2gwadEulUM&zipcode=" + GetLocationVIAip
    a% = API_request(URL, URLFile)
    DIM U AS INTEGER
    U = FREEFILE
    OPEN URLFile FOR BINARY AS #U
    IF LOF(U) <> 0 THEN
        state = SPACE$(LOF(U))
        GET #U, , state
    ELSE
        CLOSE #U
        KILL URLFile
        GetStateFromZipCode = ""
        EXIT FUNCTION
    END IF
    CLOSE #U
    KILL URLFile
    state = MID$(state, INSTR(state, "state_abbreviation") + 21)
    state = LEFT$(state, INSTR(state, CHR$(34)) - 1)
    GetStateFromZipCode = state
END FUNCTION
FUNCTION GetLocationVIAip$
    DIM URL AS STRING
    DIM URLFile AS STRING
    DIM location AS STRING
    DIM a%
    URLFile = "location"
    URL = "https://geo.ipify.org/api/v1?apiKey=at_mc5DTLBNZVVvhSf9DubEHBmY2c2tv&ipAddress=" + GetPublicIP
    a% = API_request(URL, URLFile)
    DIM U AS INTEGER
    U = FREEFILE
    OPEN URLFile FOR BINARY AS #U
    IF LOF(U) <> 0 THEN
        location = SPACE$(LOF(U))
        GET #U, , location
    ELSE
        CLOSE #U
        KILL URLFile
        GetLocationVIAip = ""
        EXIT FUNCTION
    END IF
    CLOSE #U
    KILL URLFile
    location = MID$(location, INSTR(location, "postalCode") + 13)
    location = LEFT$(location, INSTR(location, CHR$(34)) - 1)
    GetLocationVIAip = location
END FUNCTION
FUNCTION GetPublicIP$
    DIM URL AS STRING
    DIM URLFile AS STRING
    DIM publicip AS STRING
    DIM a%
    URLFile = "publicip"
    URL = "https://api.ipify.org/"
    a% = API_request(URL, URLFile)
    DIM U AS INTEGER
    U = FREEFILE
    OPEN URLFile FOR BINARY AS #U
    IF LOF(U) <> 0 THEN
        LINE INPUT #U, publicip
    ELSE
        CLOSE #U
        KILL URLFile
        GetPublicIP = ""
        EXIT FUNCTION
    END IF
    CLOSE #U
    KILL URLFile
    GetPublicIP = publicip
END FUNCTION
FUNCTION String.Remove$ (a AS STRING, b AS STRING)
    DIM c AS STRING
    DIM j
    DIM r
    DIM r$
    c = ""
    j = INSTR(a, b)
    IF j > 0 THEN
        r$ = LEFT$(a, j - 1) + c + String.Remove(RIGHT$(a, LEN(a) - j + 1 - LEN(b)), b)
    ELSE
        r$ = a
    END IF
    String.Remove = r$
END FUNCTION
FUNCTION String.Replace$ (a AS STRING, b AS STRING, c AS STRING)
    DIM j
    DIM r$
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
FUNCTION API_request (URL AS STRING, File AS STRING)
    API_request = URLDownloadToFileA(0, URL + CHR$(0), File + CHR$(0), 0, 0)
END FUNCTION
DECLARE LIBRARY
    FUNCTION WinExec (lpCmdLine AS STRING, BYVAL nCmdShow AS LONG)
END DECLARE
SUB eSpeak (lines AS STRING)
    DIM Filename AS STRING
    DIM x
    Filename = "espeak.exe -v en " + CHR$(34) + lines$ + CHR$(34)
    x = WinExec(Filename$ + CHR$(0), 0)
END SUB
SUB TTS (lines AS STRING)
    DIM x
    x = WinExec("voice -r 2 -d " + lines + CHR$(0), 0)
END SUB
FUNCTION FormatForTTS$ (lines AS STRING)
    IF INSTR(lines, "OVERNIGHT") THEN
        lines = MID$(lines, INSTR(lines, "OVERNIGHT"))
    ELSEIF INSTR(lines, "TODAY") THEN
        lines = MID$(lines, INSTR(lines, "TODAY"))
    ELSEIF INSTR(lines, "TONIGHT") AND INSTR(lines, "TODAY") = 0 THEN
        lines = MID$(lines, INSTR(lines, "TONIGHT"))
    END IF
    lines = String.Remove(lines, CHR$(10))
    lines = String.Replace(lines, "wind", "wend")
    lines = String.Replace(lines, "mph", "miles per hour")
    lines = String.Replace(lines, "thunderstorms", "thunnderstorms")
    FormatForTTS = lines
END FUNCTION
