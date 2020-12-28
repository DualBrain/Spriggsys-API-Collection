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
    'DECLARE LIBRARY ".\pipecom"
    '    FUNCTION pipecom$ (cmd AS STRING)
    'END DECLARE
    'FUNCTION encodeBase64$ (encode AS STRING)
    '    DIM encoded AS STRING
    '    DIM encodefile AS INTEGER
    '    encodefile = FREEFILE
    '    OPEN "3nc0deb64" FOR OUTPUT AS #encodefile
    '    PRINT #encodefile, encode
    '    CLOSE #encodefile
    '    encoded = pipecom("certutil -encode 3nc0deb64 3nc0dedb64 && type 3nc0dedb64 && del 3nc0dedb64 && del 3nc0deb64")
    '    encoded = MID$(encoded, INSTR(encoded, "-----BEGIN CERTIFICATE-----") + LEN("-----BEGIN CERTIFICATE-----") + 1)
    '    encoded = MID$(encoded, 1, INSTR(encoded, "-----END CERTIFICATE-----") - 2)
    '    encodeBase64 = encoded
    'END FUNCTION

    'FUNCTION decodeBase64$ (decode AS STRING)
    '    DIM decoded AS STRING
    '    DIM decodefile AS INTEGER
    '    decodefile = FREEFILE
    '    OPEN "d3c0deb64" FOR OUTPUT AS #decodefile
    '    PRINT #decodefile, decode
    '    CLOSE #decodefile
    '    decoded = pipecom("certutil -decode d3c0deb64 d3c0dedb64 && type d3c0dedb64 && del d3c0deb64 && del d3c0dedb64")
    '    decoded = MID$(decoded, _INSTRREV(decoded, "successfully.") + 1 + LEN("successfully."))
    '    decoded = MID$(decoded, 1, LEN(decoded) - 1)
    '    decodeBase64 = decoded
    'END FUNCTION

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
    DECLARE LIBRARY "./pipecom"
    FUNCTION pipecom$ (cmd AS STRING)
    END DECLARE

    FUNCTION encodeBase64$ (encode AS STRING)
    DIM encoded AS STRING
    DIM encodefile AS INTEGER
    encodefile = FREEFILE
    OPEN "3nc0deb64" FOR OUTPUT AS #encodefile
    PRINT #encodefile, encode
    CLOSE #encodefile
    encoded = pipecom("base64 3nc0deb64")
    KILL "3nc0deb64"
    encodeBase64 = MID$(encoded, 1, LEN(encoded) - 1)
    END FUNCTION

    FUNCTION decodeBase64$ (decode AS STRING)
    DIM decoded AS STRING
    DIM decodefile AS INTEGER
    decodefile = FREEFILE
    OPEN "d3c0deb64" FOR OUTPUT AS #decodefile
    PRINT #decodefile, decode
    CLOSE #decodefile
    decoded = pipecom("base64 -d d3c0deb64")
    KILL "d3c0deb64"
    decodeBase64 = decoded
    END FUNCTION
$END IF
