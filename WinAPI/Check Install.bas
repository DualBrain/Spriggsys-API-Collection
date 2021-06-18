Option _Explicit

If IsInstalled("EaseUS Partition Master 15.0") Then
    Print "Installed"
End If

If IsInstalled("PowerShell") Then
    Print "Installed"
End If

Declare CustomType Library
    Function RegOpenKey& Alias "RegOpenKeyExA" (ByVal hKey As _Offset, Byval lpSubKey As _Offset, Byval ulOptions As _Unsigned Long, Byval samDesired As _Unsigned Long, Byval phkResult As _Offset)
    Function RegEnumKey& Alias "RegEnumKeyExA" (ByVal hKey As _Offset, Byval dwIndex As _Unsigned Long, Byval lpName As _Offset, Byval lpcchName As _Offset, Byval lpReserved As _Offset, Byval lpClass As _Offset, Byval lpcchClass As _Offset, Byval lpftLastWriteTime As _Offset)
    Function RegQueryValue& Alias "RegQueryValueExA" (ByVal hKey As _Offset, lpValueName As String, Byval lpReserved As _Offset, Byval lpType As _Offset, Byval lpData As _Offset, Byval lpcbData As _Offset)
    Sub RegCloseKey (ByVal hKey As _Offset)
End Declare

Function IsInstalled%% (software As String)
    Const HKEY_LOCAL_MACHINE = &H80000002~&
    Const KEY_ALL_ACCESS = &HF003F&
    Const KEY_READ = &H20019&
    Const ERROR_SUCCESS = 0

    Dim As _Offset hUninstKey, hAppKey
    Dim As String sAppKeyName, sSubKey, sDisplayName
    sAppKeyName = Space$(1024): sSubKey = Space$(1024): sDisplayName = Space$(1024)
    Dim As String sRoot
    sRoot = "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" + Chr$(0)
    Dim As Long lResult: lResult = ERROR_SUCCESS
    Dim As Long dwType: dwType = KEY_ALL_ACCESS
    Dim As Long dwBufferSize

    If RegOpenKey(HKEY_LOCAL_MACHINE, _Offset(sRoot), 0, KEY_READ, _Offset(hUninstKey)) <> ERROR_SUCCESS Then
        IsInstalled = 0
        Exit Function
    End If
    Dim As Long dwindex
    Do
        sAppKeyName = Space$(1024)
        dwBufferSize = Len(sAppKeyName)
        lResult = RegEnumKey(hUninstKey, dwindex, _Offset(sAppKeyName), _Offset(dwBufferSize), 0, 0, 0, 0)
        If lResult = ERROR_SUCCESS Then
            sSubKey = Mid$(sRoot, 1, InStr(sRoot, Chr$(0)) - 1) + "\" + Mid$(sAppKeyName, 1, InStr(sAppKeyName, Chr$(0)) - 1) + Chr$(0)
            If RegOpenKey(HKEY_LOCAL_MACHINE, _Offset(sSubKey), 0, KEY_READ, _Offset(hAppKey)) <> ERROR_SUCCESS Then
                RegCloseKey hAppKey
                RegCloseKey hUninstKey
                IsInstalled = 0
                Exit Function
            End If
            dwBufferSize = Len(sDisplayName)
            If RegQueryValue(hAppKey, "DisplayName" + Chr$(0), 0, _Offset(dwType), _Offset(sDisplayName), _Offset(dwBufferSize)) = ERROR_SUCCESS Then
                'Print Mid$(sDisplayName, 1, dwBufferSize)
                If InStr(Mid$(sDisplayName, 1, dwBufferSize), software) Then
                    RegCloseKey hAppKey
                    RegCloseKey hUninstKey
                    IsInstalled = -1
                    Exit Function
                End If
            End If
            RegCloseKey hAppKey
        End If
        dwindex = dwindex + 1
    Loop While lResult = ERROR_SUCCESS
    RegCloseKey hUninstKey
    IsInstalled = IsInstalled64(software)
End Function

Function IsInstalled64%% (software As String)
    Const HKEY_LOCAL_MACHINE = &H80000002~&
    Const KEY_ALL_ACCESS = &HF003F&
    Const KEY_READ = &H20019&
    Const ERROR_SUCCESS = 0

    Dim As _Offset hUninstKey, hAppKey
    Dim As String sAppKeyName, sSubKey, sDisplayName
    sAppKeyName = Space$(1024): sSubKey = Space$(1024): sDisplayName = Space$(1024)
    Dim As String sRoot
    sRoot = "SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" + Chr$(0)
    Dim As Long lResult: lResult = ERROR_SUCCESS
    Dim As Long dwType: dwType = KEY_ALL_ACCESS
    Dim As Long dwBufferSize

    If RegOpenKey(HKEY_LOCAL_MACHINE, _Offset(sRoot), 0, KEY_READ, _Offset(hUninstKey)) <> ERROR_SUCCESS Then
        IsInstalled64 = 0
        Exit Function
    End If
    Dim As Long dwindex
    Do
        sAppKeyName = Space$(1024)
        dwBufferSize = Len(sAppKeyName)
        lResult = RegEnumKey(hUninstKey, dwindex, _Offset(sAppKeyName), _Offset(dwBufferSize), 0, 0, 0, 0)
        If lResult = ERROR_SUCCESS Then
            sSubKey = Mid$(sRoot, 1, InStr(sRoot, Chr$(0)) - 1) + "\" + Mid$(sAppKeyName, 1, InStr(sAppKeyName, Chr$(0)) - 1) + Chr$(0)
            If RegOpenKey(HKEY_LOCAL_MACHINE, _Offset(sSubKey), 0, KEY_READ, _Offset(hAppKey)) <> ERROR_SUCCESS Then
                RegCloseKey hAppKey
                RegCloseKey hUninstKey
                IsInstalled64 = 0
                Exit Function
            End If
            dwBufferSize = Len(sDisplayName)
            If RegQueryValue(hAppKey, "DisplayName" + Chr$(0), 0, _Offset(dwType), _Offset(sDisplayName), _Offset(dwBufferSize)) = ERROR_SUCCESS Then
                'Print Mid$(sDisplayName, 1, dwBufferSize)
                If InStr(Mid$(sDisplayName, 1, dwBufferSize), software) Then
                    RegCloseKey hAppKey
                    RegCloseKey hUninstKey
                    IsInstalled64 = -1
                    Exit Function
                End If
            End If
            RegCloseKey hAppKey
        End If
        dwindex = dwindex + 1
    Loop While lResult = ERROR_SUCCESS
    RegCloseKey hUninstKey
    IsInstalled64 = 0
End Function
