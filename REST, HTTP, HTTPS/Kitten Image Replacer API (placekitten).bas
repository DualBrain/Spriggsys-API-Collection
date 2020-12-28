OPTION _EXPLICIT
DIM a AS LONG
IF _FILEEXISTS("neededimage.jpg") = 0 THEN
    a = LoadKitten("720", "480")
    SCREEN a
END IF
FUNCTION LoadKitten (imagewidth AS STRING, imageheight AS STRING)
    DIM URL AS STRING
    DIM URLFile AS STRING
    DIM kitten AS STRING
    DIM a%
    URLFile = "kitten.jpg"
    URL = "http://placekitten.com/g/" + imagewidth + "/" + imageheight
    a% = API_request(URL, URLFile)
    OPEN URLFile FOR BINARY AS #1
    IF LOF(1) <> 0 THEN
        LoadKitten = _LOADIMAGE(URLFile, 32)
        CLOSE #1
        KILL URLFile
    ELSE
        CLOSE #1
        KILL URLFile
    END IF
END FUNCTION
DECLARE DYNAMIC LIBRARY "urlmon"
    FUNCTION URLDownloadToFileA (BYVAL pCaller AS LONG, szURL AS STRING, szFileName AS STRING, BYVAL dwReserved AS LONG, BYVAL lpfnCB AS LONG)
END DECLARE
FUNCTION API_request (URL AS STRING, File AS STRING)
    API_request = URLDownloadToFileA(0, URL + CHR$(0), File + CHR$(0), 0, 0)
END FUNCTION
