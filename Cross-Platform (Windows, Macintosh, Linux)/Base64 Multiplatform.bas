OPTION _EXPLICIT
$CONSOLE:ONLY
_DEST _CONSOLE
'DIM encode AS STRING
'encode = encodeBase64("My name is Inigo Montoya")
DIM encoded AS STRING
'PRINT encode
DO
    LINE INPUT "Input Base64 String: ", encoded
LOOP UNTIL encoded <> ""
DIM decode AS STRING
decode = decodeBase64(encoded)

PRINT decode
SLEEP

$IF WIN THEN
    DECLARE DYNAMIC LIBRARY "Crypt32"
        FUNCTION CryptBinaryToString%% ALIAS CryptBinaryToStringA (BYVAL pbBinary AS _OFFSET, BYVAL cbBinary AS LONG, BYVAL dwFlags AS LONG, BYVAL pszString AS _OFFSET, BYVAL pcchString AS _OFFSET)
        FUNCTION CryptStringToBinary%% ALIAS CryptStringToBinaryA (BYVAL pszString AS _OFFSET, BYVAL cchString AS LONG, BYVAL dwFlags AS LONG, BYVAL pbBinary AS _OFFSET, BYVAL pcbBinary AS _OFFSET, BYVAL pdwSkip AS _OFFSET, BYVAL pdwFlags AS _OFFSET)
    END DECLARE

    FUNCTION encodeBase64$ (encode AS STRING)
        CONST CRYPT_STRING_NOCRLF = &H40000000
        CONST CRYPT_STRING_BASE64 = &H00000001

        DIM a AS _BYTE
        DIM lengthencode AS LONG
        DIM encoded AS STRING
        DIM lengthencoded AS LONG

        lengthencode = LEN(encode)

        a = CryptBinaryToString(_OFFSET(encode), lengthencode, CRYPT_STRING_BASE64 OR CRYPT_STRING_NOCRLF, 0, _OFFSET(lengthencoded))
        'Calculate buffer length
        IF a <> 0 THEN
            encoded = SPACE$(lengthencoded)
        ELSE
            encodeBase64 = ""
            EXIT FUNCTION
        END IF
        a = CryptBinaryToString(_OFFSET(encode), lengthencode, CRYPT_STRING_BASE64 OR CRYPT_STRING_NOCRLF, _OFFSET(encoded), _OFFSET(lengthencoded))
        'Acual conversion
        IF a <> 0 THEN
            encodeBase64 = encoded
        ELSE
            encodeBase64 = ""
        END IF
    END FUNCTION

    FUNCTION decodeBase64$ (decode AS STRING)
        CONST CRYPT_STRING_BASE64_ANY = &H00000006

        DIM a AS _BYTE
        DIM lengthdecode AS LONG
        DIM decoded AS STRING
        DIM lengthdecoded AS LONG

        lengthdecode = LEN(decode)
        a = CryptStringToBinary(_OFFSET(decode), lengthdecode, CRYPT_STRING_BASE64_ANY, 0, _OFFSET(lengthdecoded), 0, 0)
        'Calculate buffer length
        IF a <> 0 THEN
            decoded = SPACE$(lengthdecoded)
        ELSE
            decodeBase64 = ""
            EXIT FUNCTION
        END IF
        a = CryptStringToBinary(_OFFSET(decode), lengthdecode, CRYPT_STRING_BASE64_ANY, _OFFSET(decoded), _OFFSET(lengthdecoded), 0, 0)
        'Actual conversion
        IF a <> 0 THEN
            decodeBase64 = decoded
        ELSE
            decodeBase64 = ""
        END IF
    END FUNCTION
$ELSE
    Function encodeBase64$ (encode As String)
        Dim As String encoded, stdout, stderr
        Dim As Integer encodefile
        Dim As Long exit_code
        encodefile = FreeFile
        Open "3nc0deb64" For Output As #encodefile
        Print #encodefile, encode
        Close #encodefile
        exit_code = pipecom("base64 3nc0deb64", stdout, stderr)
        Kill "3nc0deb64"
        encodeBase64 = Mid$(stdout, 1, Len(stdout) - 1)
    End Function

    Function decodeBase64$ (decode As String)
        Dim As String decoded, stdout, stderr
        Dim As Integer decodefile
        Dim As Long exit_code
        decodefile = FreeFile
        Open "d3c0deb64" For Output As #decodefile
        Print #decodefile, decode
        Close #decodefile
        exit_code = pipecom("base64 -d d3c0deb64", stdout, stderr)
        Kill "d3c0deb64"
        decodeBase64 = stdout
    End Function
    '$INCLUDE:'pipecomqb64.bas'
$END IF
