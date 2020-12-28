OPTION _EXPLICIT

_TITLE "mciSendString Record Test"

StartRecording
DIM x
DIM y

x = TIMER(0.01)
DO
    y = TIMER(0.01)
    CLS
    PRINT "Recording...Press any key to stop"
    PRINT y - x
    _DISPLAY
LOOP UNTIL INKEY$ <> ""

StopRecording
SaveRecording ("test.wav")
PlayRecording ("test.wav")

_TITLE "Waveform Display"
SCREEN GetWaveform("test.wav", "640x480")


DECLARE DYNAMIC LIBRARY "WINMM"
    FUNCTION mciSendStringA% (lpstrCommand AS STRING, lpstrReturnString AS STRING, BYVAL uReturnLength AS _UNSIGNED LONG, BYVAL hwndCallback AS LONG)
    FUNCTION mciGetErrorStringA% (BYVAL dwError AS LONG, lpstrBuffer AS STRING, BYVAL uLength AS _UNSIGNED LONG)
END DECLARE

SUB StartRecording
    DIM a AS LONG
    a = mciSendStringA("open new type waveaudio alias capture" + CHR$(0), "", 0, 0)
    IF a THEN
        DIM x AS INTEGER
        DIM MCIError AS STRING
        MCIError = SPACE$(255)
        x = mciGetErrorStringA(a, MCIError, LEN(MCIError))
        PRINT MCIError
        END
    ELSE
        a = mciSendStringA("set capture time format ms bitspersample 16 channels 2 samplespersec 48000 bytespersec 192000 alignment 4" + CHR$(0), "", 0, 0)
        a = mciSendStringA("record capture" + CHR$(0), "", 0, 0)
    END IF
END SUB

SUB StopRecording
    DIM a AS LONG
    a = mciSendStringA("stop capture" + CHR$(0), "", 0, 0)
END SUB

SUB SaveRecording (file AS STRING)
    DIM a AS LONG
    a = mciSendStringA("save capture " + CHR$(34) + file + CHR$(34) + CHR$(0), "", 0, 0)
    a = mciSendStringA("close capture" + CHR$(0), "", 0, 0)
END SUB

SUB PlayRecording (file AS STRING)
    DIM a AS LONG
    a = mciSendStringA("play " + CHR$(34) + file + CHR$(34) + CHR$(0), "", 0, 0)
END SUB

FUNCTION GetWaveform& (file AS STRING, size AS STRING)
    IF _FILEEXISTS("output.png") THEN
        KILL "output.png"
    END IF
    SHELL _HIDE "ffmpeg -i " + CHR$(34) + file + CHR$(34) + " -filter_complex " + CHR$(34) + "showwavespic=s=" + size + CHR$(34) + " -frames:v 1 output.png"
    GetWaveform = _LOADIMAGE("output.png", 32)
END FUNCTION
