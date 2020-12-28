$CONSOLE:ONLY
_DEST _CONSOLE
DIM text AS STRING
DIM result AS STRING
LINE INPUT "Please input what text you would like the API to check: ", text
result = CheckConnotation(text)
IF result = "negative" THEN
    PRINT "That's not a nice thing to say."
ELSEIF result = "positive" THEN
    PRINT "Positivity is key."
ELSEIF result = "neutral" THEN
    PRINT "Meh."
ELSE
    PRINT "Well, that seems to not work. Check your connection or print the string that is being SHELLed to make sure the syntax isn't awry."
END IF
SLEEP
FUNCTION CheckConnotation$ (Text AS STRING)
    DIM sentim AS STRING
    SHELL _HIDE "curl -XPOST -H " + CHR$(34) + "Accept: application/json" + CHR$(34) + " -H " + CHR$(34) + "Content-type: application/json" + CHR$(34) + " -d " + CHR$(34) + "{\" + CHR$(34) + "text\" + CHR$(34) + ": \" + CHR$(34) + Text$ + "\" + CHR$(34) + "}" + CHR$(34) + " " + CHR$(34) + "https://sentim-api.herokuapp.com/api/v1/" + CHR$(34) + " -o sentimapirequest"
    IF _FILEEXISTS("sentimapirequest") THEN
        C = FREEFILE
        OPEN "sentimapirequest" FOR BINARY AS #C
        IF LOF(C) <> 0 THEN
            sentim = SPACE$(LOF(C))
            GET #C, , sentim
            CLOSE #C
            sentim = MID$(sentim, INSTR(sentim, "type" + CHR$(34) + ":") + 7)
            sentim = LEFT$(sentim, INSTR(sentim, CHR$(34)) - 1)
            CheckConnotation = sentim
            EXIT FUNCTION
        ELSE
            CLOSE #C
            CheckConnotation = ""
            EXIT FUNCTION
        END IF
    ELSE
        CheckConnotation = ""
        EXIT FUNCTION
    END IF
END FUNCTION
