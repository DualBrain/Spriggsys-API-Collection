OPTION _EXPLICIT
'$CONSOLE:ONLY
'_DEST _CONSOLE
'Window Style Constants
CONST WS_BORDER = &H00800000
CONST WS_CAPTION = &H00C00000
CONST WS_CHILD = &H40000000
CONST WS_CHILDWINDOW = WS_CHILD
CONST WS_CLIPCHILDREN = &H02000000
CONST WS_CLIPSIBLINGS = &H04000000
CONST WS_DISABLED = &H08000000
CONST WS_DLGFRAME = &H00400000
CONST WS_GROUP = &H00020000
CONST WS_HSCROLL = &H00100000
CONST WS_ICONIC = &H20000000
CONST WS_MAXIMIZE = &H01000000
CONST WS_MAXIMIZEBOX = &H00010000
CONST WS_MINIMIZE = &H20000000
CONST WS_MINIMIZEBOX = &H00020000
CONST WS_OVERLAPPED = &H00000000
CONST WS_POPUP = &H80000000
CONST WS_SIZEBOX = &H00040000
CONST WS_SYSMENU = &H00080000
CONST WS_TABSTOP = &H00010000
CONST WS_THICKFRAME = &H00040000
CONST WS_TILED = &H00000000
CONST WS_VISIBLE = &H10000000
CONST WS_VSCROLL = &H00200000
CONST WS_TILEDWINDOW = WS_OVERLAPPED OR WS_CAPTION OR WS_SYSMENU OR WS_THICKFRAME OR WS_MINIMIZEBOX OR WS_MAXIMIZEBOX
CONST WS_POPUPWINDOW = WS_POPUP OR WS_BORDER OR WS_SYSMENU
CONST WS_OVERLAPPEDWINDOW = WS_OVERLAPPED OR WS_CAPTION OR WS_SYSMENU OR WS_THICKFRAME OR WS_MINIMIZEBOX OR WS_MAXIMIZEBOX
'------------------------------------------------------------------------------------------------------------------------------
'Capture Driver Constants
CONST WM_CAP_START = &H0400
CONST WM_CAP_DRIVER_CONNECT = WM_CAP_START + 10
CONST WM_CAP_DRIVER_DISCONNECT = WM_CAP_START + 11
CONST WM_CAP_EDIT_COPY = WM_CAP_START + 30
CONST WM_CAP_GRAB_FRAME = WM_CAP_START + 60
CONST WM_CAP_SET_SCALE = WM_CAP_START + 53
CONST WM_CAP_SET_PREVIEWRATE = WM_CAP_START + 52
CONST WM_CAP_SET_PREVIEW = WM_CAP_START + 50
CONST WM_CAP_DLG_VIDEOSOURCE = WM_CAP_START + 42
CONST WM_CAP_STOP = WM_CAP_START + 68
CONST WM_CAP_DRIVER_GET_CAPS = WM_CAP_START + 14
CONST WM_CAP_GET_STATUS = WM_CAP_START + 54
CONST WM_CAP_SET_VIDEOFORMAT = WM_CAP_START + 45
CONST WM_CAP_DLG_VIDEOFORMAT = WM_CAP_START + 41
CONST WM_CAP_GET_VIDEOFORMAT = WM_CAP_START + 44
CONST WM_CAP_DLG_VIDEOSOURCE = WM_CAP_START + 42
CONST WM_CAP_DLG_VIDEODISPLAY = WM_CAP_START + 43
CONST WM_CAP_SEQUENCE = WM_CAP_START + 62
CONST WM_CAP_FILE_SAVEAS = WM_CAP_START + 23
CONST WM_CAP_GRAB_FRAME_NOSTOP = WM_CAP_START + 61
CONST WM_CAP_FILE_SET_CAPTURE_FILE = WM_CAP_START + 20
CONST WM_CAP_SINGLE_FRAME = WM_CAP_START + 70
CONST WM_CAP_SET_AUDIOFORMAT = WM_CAP_START + 35
CONST WM_CAP_DLG_VIDEOCOMPRESSION = WM_CAP_START + 46
'------------------------------------------------------------------------------------------------------------------------------
'Window Pos Constants
CONST SWP_ASYNCWINDOWPOS = &H4000
CONST SWP_DEFERERASE = &H2000
CONST SWP_DRAWFRAME = &H0020
CONST SWP_FRAMECHANGED = &H0020
CONST SWP_HIDEWINDOW = &H0080
CONST SWP_NOACTIVATE = &H0010
CONST SWP_NOCOPYBITS = &H0100
CONST SWP_NOMOVE = &H0002
CONST SWP_NOOWNERZORDER = &H0200
CONST SWP_NOREDRAW = &H0008
CONST SWP_NOREPOSITION = &H0200
CONST SWP_NOSENDCHANGING = &H0400
CONST SWP_NOSIZE = &H0001
CONST SWP_NOZORDER = &H0004
CONST SWP_SHOWWINDOW = &H0040
'------------------------------------------------------------------------------------------------------------------------------
CONST WAVE_FORMAT_PCM = 1
TYPE CapDriverCaps
    DeviceIndex AS _UNSIGNED LONG
    HasOverlay AS _BYTE
    HasDlgVideoSource AS _BYTE
    HasDlgVideoFormat AS _BYTE
    HasDlgVideoDisplay AS _BYTE
    CaptureInitialized AS _BYTE
    DriverSuppliesPalettes AS _BYTE
    hVideoIn AS LONG
    hVideoOut AS LONG
    hVideoExtIn AS LONG
    hVideoExtOut AS LONG
END TYPE

TYPE POINTAPI
    x AS LONG
    y AS LONG
END TYPE

TYPE CapStatus
    ImageWidth AS _UNSIGNED LONG
    ImageHeight AS _UNSIGNED LONG
    LiveWindow AS _BYTE
    OverlayWindow AS _BYTE
    Scale AS _BYTE
    Scroll AS POINTAPI
    UsingDefaultPalette AS _BYTE
    AudioHardware AS _BYTE
    CapFileExists AS _BYTE
    CurrentVideoFrame AS LONG
    CurrentVideoFramesDropped AS LONG
    CurrentWaveSamples AS LONG
    CurrentTimeElapsedMS AS LONG
    PalCurrent AS LONG
    CapturingNow AS _BYTE
    RETURN AS LONG
    NumVideoAllocated AS _UNSIGNED LONG
    NumAudioAllocated AS _UNSIGNED LONG
END TYPE

TYPE WAVEFORMATEX
    FormatTag AS INTEGER
    Channels AS INTEGER
    SamplesPerSec AS LONG
    AvgBytesPerSec AS LONG
    BlockAlign AS INTEGER
    BitsPerSample AS INTEGER
    cbSize AS INTEGER
END TYPE


DECLARE DYNAMIC LIBRARY "Avicap32"
    FUNCTION CreateCaptureWindow& ALIAS capCreateCaptureWindowA (lpszWindowName AS STRING, BYVAL dwStyle AS _OFFSET, BYVAL x AS INTEGER, BYVAL y AS INTEGER, BYVAL nWidth AS INTEGER, BYVAL nHeight AS INTEGER, BYVAL hwndParent AS _INTEGER64, BYVAL nId AS INTEGER)
    FUNCTION GetDriverDescription%% ALIAS capGetDriverDescriptionA (BYVAL wDriverIndex AS _UNSIGNED LONG, BYVAL lpszName AS _OFFSET, BYVAL cbName AS INTEGER, BYVAL lpszVer AS _OFFSET, BYVAL cbVer AS INTEGER)
END DECLARE

DECLARE DYNAMIC LIBRARY "User32"
    FUNCTION SendMessage& ALIAS SendMessageA (BYVAL hWnd AS LONG, BYVAL Msg AS _UNSIGNED INTEGER, BYVAL wParam AS LONG, BYVAL lParam AS _OFFSET)
    FUNCTION SetWindowPos%% (BYVAL hWnd AS LONG, BYVAL hWndInsertAfter, BYVAL X AS INTEGER, BYVAL Y AS INTEGER, BYVAL cx AS INTEGER, BYVAL cy AS INTEGER, BYVAL uFlags AS _UNSIGNED LONG)
    FUNCTION DestroyWindow%% (BYVAL hWnd AS LONG)
END DECLARE

DECLARE DYNAMIC LIBRARY "WINMM"
    FUNCTION mciSendString% ALIAS mciSendStringA (lpstrCommand AS STRING, lpstrReturnString AS STRING, BYVAL uReturnLength AS _UNSIGNED LONG, BYVAL hwndCallback AS LONG)
    FUNCTION mciGetErrorString% ALIAS mciGetErrorStringA (BYVAL dwError AS LONG, lpstrBuffer AS STRING, BYVAL uLength AS _UNSIGNED LONG)
END DECLARE

SCREEN _NEWIMAGE(720, 480, 32)

DIM childWin AS _INTEGER64
DIM a AS LONG

DIM captureWinText AS STRING
captureWinText = "Webcam API Test" + CHR$(0)
DIM childID AS _INTEGER64
childWin = CreateCaptureWindow(captureWinText, WS_CHILD OR WS_VISIBLE, 0, 0, 720, 480, _WINDOWHANDLE, childID)
_TITLE "Webcam API Test"
PRINT childWin

a = SendMessage(childWin, WM_CAP_DRIVER_CONNECT, 0, 0)
DIM DeviceName AS STRING * 80
DIM DeviceVersion AS STRING * 80
DIM wIndex AS _UNSIGNED INTEGER

'FOR wIndex = 0 TO 10
'DeviceName = SPACE$(80)
'DeviceVersion = SPACE$(80)
a = GetDriverDescription(wIndex, _OFFSET(DeviceName), LEN(DeviceName), _OFFSET(DeviceVersion), LEN(DeviceVersion))
'PRINT DeviceName, DeviceVersion
'NEXT

DIM driverCaps AS CapDriverCaps
driverCaps.DeviceIndex = 0

a = SendMessage(childWin, WM_CAP_DRIVER_GET_CAPS, LEN(driverCaps), _OFFSET(driverCaps))

DIM capstatus AS CapStatus

DIM filename AS STRING
filename = "Video.avi" + CHR$(0)
IF _FILEEXISTS(filename) THEN
    KILL filename
END IF
DIM wave AS WAVEFORMATEX
wave.FormatTag = WAVE_FORMAT_PCM
wave.Channels = 2
wave.SamplesPerSec = 48000
wave.AvgBytesPerSec = 192000
wave.BlockAlign = 4
wave.BitsPerSample = 16
wave.cbSize = 0
a = SendMessage(childWin, WM_CAP_SET_SCALE, -1, 0)
a = SendMessage(childWin, WM_CAP_SET_PREVIEWRATE, 16.7, 0)
a = SendMessage(childWin, WM_CAP_SET_PREVIEW, -1, 0)
a = SendMessage(childWin, WM_CAP_DLG_VIDEOFORMAT, 0, 0)
a = SendMessage(childWin, WM_CAP_DLG_VIDEOSOURCE, 0, 0)
'a = SendMessage(childWin, WM_CAP_DLG_VIDEOCOMPRESSION, 0, 0)
a = SendMessage(childWin, WM_CAP_FILE_SET_CAPTURE_FILE, 0, _OFFSET(filename))
a = SendMessage(childWin, WM_CAP_SET_AUDIOFORMAT, LEN(wave), _OFFSET(wave))
a = SendMessage(childWin, WM_CAP_SEQUENCE, 0, 0)
a = SendMessage(childWin, WM_CAP_GET_STATUS, LEN(capstatus), _OFFSET(capstatus))
'a = SetWindowPos(childWin, 0, 0, 0, capstatus.ImageWidth, capstatus.ImageHeight, SWP_NOZORDER OR SWP_NOMOVE)
DO
    IF NOT SendMessage(childWin, WM_CAP_GRAB_FRAME_NOSTOP, 0, 0) THEN EXIT DO 'Press escape or make the window lose focus to stop recording
    'IF _WINDOWHASFOCUS = 0 THEN EXIT DO
    _LIMIT 60
LOOP UNTIL INKEY$ <> ""
PRINT "Disconnecting Driver:", SendMessage(childWin, WM_CAP_DRIVER_DISCONNECT, 0, 0)
a = DestroyWindow(childWin)
PRINT "Destroyed"
