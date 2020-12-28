_CONSOLETITLE "Insult Generator 2.0"
$CONSOLE:ONLY
_DEST _CONSOLE
DIM insult AS STRING
DO
    loopcnt = loopcnt + 1
    IF loopcnt > 30 THEN SYSTEM
    insult = ""
    insult = GetInsult
    PRINT insult
    TTS insult
LOOP
SYSTEM
FUNCTION GetInsult$
    DIM URL AS STRING
    DIM URLFile AS STRING
    DIM insultresponse AS STRING
    DIM a%
    URLFile = "insultresponse"
    SHELL _HIDE "curl " + CHR$(34) + "https://evilinsult.com/generate_insult.php?lang=en" + CHR$(34) + " -o " + URLFile
    DIM U AS INTEGER
    U = FREEFILE
    OPEN URLFile FOR BINARY AS #U
    IF LOF(U) <> 0 THEN
        insultresponse = SPACE$(LOF(U))
        GET #U, , insultresponse
    ELSE
        CLOSE #U
        KILL URLFile
        GetInsult = ""
        EXIT FUNCTION
    END IF
    CLOSE #U
    KILL URLFile
    insultresponse = String.Replace(insultresponse, "&quot;", CHR$(34))
    insultresponse = String.Replace(insultresponse, "&gt;", ">")
    insultresponse = String.Replace(insultresponse, "&amp;", "&")
    insultresponse = String.Replace(insultresponse, "-->", "")
    insultresponse = String.Replace(insultresponse, "3rd", "third")
    GetInsult = insultresponse
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
SUB TTS (lines AS STRING)
    DIM x
    x = _SHELLHIDE("voice -d " + lines + CHR$(0))
END SUB
