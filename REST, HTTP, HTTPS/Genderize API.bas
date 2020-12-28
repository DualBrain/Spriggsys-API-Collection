$CONSOLE:ONLY
_DEST _CONSOLE
_CONSOLETITLE "Genderize API"

DIM nametocheck AS STRING
DIM country AS STRING

INPUT "Enter name                 : ", nametocheck
INPUT "Enter two letter country ID: ", country

PRINT
PRINT CheckGender(nametocheck, country)
SLEEP

FUNCTION CheckGender$ (checkname AS STRING, country AS STRING)
    DIM a%
    DIM genderizeapiresponse AS STRING
    DIM genderize AS STRING
    genderize = "genderizeapirequest"
    genderizeapiresponse = API_request("https://api.genderize.io/?name=" + checkname + "&country_id=" + country, genderize) 'Two letter country code. Example: US
    CheckGender = GetKey("gender", genderizeapiresponse)
END FUNCTION

DECLARE DYNAMIC LIBRARY "urlmon"
    FUNCTION URLDownloadToFileA (BYVAL pCaller AS LONG, szURL AS STRING, szFileName AS STRING, BYVAL dwReserved AS LONG, BYVAL lpfnCB AS LONG)
END DECLARE

FUNCTION API_request$ (URL AS STRING, File AS STRING)
    DIM a%
    DIM apirequest AS STRING
    a% = URLDownloadToFileA(0, URL + CHR$(0), File + CHR$(0), 0, 0)
    DIM F AS INTEGER
    F = FREEFILE
    OPEN File FOR BINARY AS #F
    IF LOF(F) <> 0 THEN
        apirequest = SPACE$(LOF(F))
        GET #F, , apirequest
    ELSE
        CLOSE #F
        KILL File
        API_request = ""
        EXIT FUNCTION
    END IF
    CLOSE #F
    KILL File
    API_request = apirequest
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
