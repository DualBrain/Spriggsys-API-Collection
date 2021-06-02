Option _Explicit
$Asserts
$Console:Only

Const CHANGE_MODE = 1

Const DISP_CHANGE_SUCCESSFUL = 0

Const CDS_FULLSCREEN = &H00000004

Type POINTL
    As Long x, y
End Type

Type DEVMODE
    As String * 32 dmDeviceName
    As Integer dmSpecVersion, dmDriverVersion, dmSize, dmDriverExtra
    As Long dmFields
    As POINTL dmPosition
    As Long dmDisplayOrientation, dmDisplayFixedOutput
    As Integer dmColor, dmDuplex, dmYResolution, dmTTOption, dmCollate
    As String * 32 dmFormName
    As Integer dmLogPixels
    As Long dmBitsPerPel, dmPelsWidth, dmPelsHeight, dmDisplayFlags, dmDisplayFrequency, dmICMMethod, dmICMIntent, dmMediaType, dmDitherType, dmReserved1, dmReserved2, dmPanningWidth, dmPanningHeight
End Type

Type DISPLAY_DEVICE
    As Long cb
    As String * 32 DeviceName
    As String * 128 DeviceString
    As Long StateFlags
    As String * 128 DeviceID, DeviceKey
End Type

Declare CustomType Library
    Function EnumDisplayDevices%% Alias "EnumDisplayDevicesA" (ByVal lpDevice As _Offset, Byval iDevNum As Long, Byval lpDisplayDevice As _Offset, Byval dwFlags As Long)
    Function EnumDisplaySettings%% Alias "EnumDisplaySettingsA" (ByVal lpszDeviceName As _Offset, Byval iModeNum As Long, Byval lpDevMode As _Offset)
    Function ChangeDisplaySettings& Alias "ChangeDisplaySettingsExA" (ByVal lpszDeviceName As _Offset, Byval lpDevMode As _Offset, Byval hwnd As _Offset, Byval dwflags As Long, Byval lParam As _Offset)
    Function GetLastError& ()
End Declare

Dim As DISPLAY_DEVICE adapter: adapter.cb = Len(adapter)
Dim As Long adapterIndex: adapterIndex = 0
Dim As _Byte targetModeFound: targetModeFound = 0
Dim As String * 32 targetDeviceName
Dim As DEVMODE targetMode

Dim As Long index, dispwidth, dispheight

Input "Enter monitor index (zero based): ", index
Input "Enter display width and height, separated by comma: ", dispwidth, dispheight

While EnumDisplayDevices(0, adapterIndex, _Offset(adapter), 0)
    Dim As DEVMODE mode: mode.dmSize = Len(mode)
    Dim As Long modeIndex: modeIndex = 0
    While EnumDisplaySettings(_Offset(adapter.DeviceName), modeIndex, _Offset(mode))
        If Not targetModeFound And adapterIndex = index Then
            If CHANGE_MODE And mode.dmPelsWidth = dispwidth And mode.dmPelsHeight = dispheight And mode.dmDisplayFrequency >= 59 And mode.dmDisplayFrequency <= 60 Then
                targetModeFound = Not targetModeFound
                targetDeviceName = adapter.DeviceName
                targetMode = mode
            End If
        End If
        modeIndex = modeIndex + 1
    Wend
    adapterIndex = adapterIndex + 1
Wend
If targetModeFound Then
    Dim As Long r
    r = ChangeDisplaySettings(_Offset(targetDeviceName), _Offset(targetMode), 0, CDS_FULLSCREEN, 0)
    _Assert r = DISP_CHANGE_SUCCESSFUL, Str$(r)

    Sleep

    r = ChangeDisplaySettings(_Offset(targetDeviceName), 0, 0, 0, 0)
    _Assert r = DISP_CHANGE_SUCCESSFUL, Str$(r)
End If
