'Option _Explicit
'$Console:Only
'_Dest _Console

'Print pipecom("dir /b")
'If _Dest = _Console Then
'    Sleep
'End If

Function pipecom$ (cmd As String)
    $If WIN Then
        Type SECURITY_ATTRIBUTES
            nLength As Long
            $If 64BIT Then
                padding As Long
            $End If
            lpSecurityDescriptor As _Offset
            bInheritHandle As Long
            $If 64BIT Then
                padding2 As Long
            $End If
        End Type

        Type STARTUPINFO
            cb As Long
            $If 64BIT Then
                padding As Long
            $End If
            lpReserved As _Offset
            lpDesktop As _Offset
            lpTitle As _Offset
            dwX As Long
            dwY As Long
            dwXSize As Long
            dwYSize As Long
            dwXCountChars As Long
            dwYCountChars As Long
            dwFillAttribute As Long
            dwFlags As Long
            wShowWindow As Integer
            cbReserved2 As Integer
            $If 64BIT Then
                padding2 As Long
            $End If
            lpReserved2 As _Offset
            hStdInput As _Offset
            hStdOutput As _Offset
            hStdError As _Offset
        End Type

        Type PROCESS_INFORMATION
            hProcess As _Offset
            hThread As _Offset
            dwProcessId As Long
            $If 64BIT Then
                padding2 As Long
            $End If
        End Type

        Const STARTF_USESTDHANDLES = &H00000100
        Const CREATE_NO_WINDOW = &H8000000

        Declare Dynamic Library "Kernel32"
            Function CreatePipe% (ByVal hReadPipe As _Offset, Byval hWritePipe As _Offset, Byval lpPipeAttributes As _Offset, Byval nSize As Long)
            Function CreateProcess% Alias CreateProcessA (ByVal lpApplicationName As _Offset, Byval lpCommandLine As _Offset, Byval lpProcessAttributes As _Offset, Byval lpThreadAttributes As _Offset, Byval bInheritHandles As Integer, Byval dwCreationFlags As Long, Byval lpEnvironment As _Offset, Byval lpCurrentDirectory As _Offset, Byval lpStartupInfor As _Offset, Byval lpProcessInformation As _Offset)
            Function CloseHandle% (ByVal hObject As Long)
            Function ReadFile% (ByVal hFile As Long, Byval lpBuffer As _Offset, Byval nNumberOfBytesToRead As Long, Byval lpNumberOfBytesRead As _Offset, Byval lpOverlapped As _Offset)
        End Declare

        Dim As String pipecom_buffer
        Dim As Integer ok: ok = 1
        Dim As Long hStdOutPipeRead
        Dim As Long hStdOutPipeWrite
        Dim As SECURITY_ATTRIBUTES sa: sa.nLength = Len(sa): sa.lpSecurityDescriptor = 0: sa.bInheritHandle = 1

        If CreatePipe(_Offset(hStdOutPipeRead), _Offset(hStdOutPipeWrite), _Offset(sa), 0) = 0 Then
            pipecom = ""
            Exit Function
        End If

        Dim As STARTUPINFO si
        si.cb = Len(si)
        si.dwFlags = STARTF_USESTDHANDLES
        si.hStdError = 0
        si.hStdOutput = hStdOutPipeWrite
        si.hStdInput = 0
        Dim As PROCESS_INFORMATION pi
        Dim As _Offset lpApplicationName
        Dim As String fullcmd: fullcmd = "cmd /c " + cmd + " 2>&1" + Chr$(0)
        Dim As String lpCommandLine: lpCommandLine = fullcmd
        Dim As Long lpProcessAttributes
        Dim As Long lpThreadAttributes
        Dim As Integer bInheritHandles: bInheritHandles = 1
        Dim As Long dwCreationFlags: dwCreationFlags = CREATE_NO_WINDOW
        Dim As _Offset lpEnvironment
        Dim As _Offset lpCurrentDirectory
        ok = CreateProcess(lpApplicationName,_
                           _Offset(lpCommandLine),_
                           lpProcessAttributes,_
                           lpThreadAttributes,_
                           bInheritHandles,_
                           dwCreationFlags,_
                           lpEnvironment,_
                           lpCurrentDirectory,_
                           _Offset(si),_
                           _Offset(pi))
        If ok = 0 Then
            pipecom = ""
            Exit Function
        End If

        ok = CloseHandle(hStdOutPipeWrite)

        Dim As String buf: buf = Space$(4096 + 1)
        Dim As Long dwRead
        While ReadFile(hStdOutPipeRead, _Offset(buf), 4096, _Offset(dwRead), 0) <> 0 And dwRead > 0
            buf = Mid$(buf, 1, dwRead)
            buf = String.Remove(buf, Chr$(13))
            pipecom_buffer = pipecom_buffer + buf
            buf = Space$(4096 + 1)
        Wend
        ok = CloseHandle(hStdOutPipeRead)
        pipecom = pipecom_buffer
    $Else
        Declare CustomType Library
        Function popen%& (cmd As String, readtype As String)
        Function feof& (ByVal stream As _Offset)
        Function fgets$ (str As String, Byval n As Long, Byval stream As _Offset)
        Function pclose& (ByVal stream As _Offset)
        End Declare

        Dim As String pipecom_buffer
        Dim As _Offset stream

        Dim buffer As String * 4096
        stream = popen(cmd+ " 2>&1", "r")
        If stream Then
        While feof(stream) = 0
        If fgets(buffer, 4096, stream) <> "" And feof(stream) = 0 Then
        pipecom_buffer = pipecom_buffer + Mid$(buffer, 1, InStr(buffer, Chr$(0)) - 1)
        End If
        Wend
        Dim As Long a
        a = pclose(stream)
        End If
        pipecom = pipecom_buffer
    $End If
End Function

$If WIN Then
    Function String.Remove$ (a As String, b As String)
        Dim c As String
        Dim j
        Dim r$
        c = ""
        j = InStr(a, b)
        If j > 0 Then
            r$ = Left$(a, j - 1) + c + String.Remove(Right$(a, Len(a) - j + 1 - Len(b)), b)
        Else
            r$ = a
        End If
        String.Remove = r$
    End Function
$End If
