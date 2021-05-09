Option _Explicit
$Console:Only
_Title "Parent Process"

Type SECURITY_ATTRIBUTES
    As Long nLength
    $If 64BIT Then
        As Long padding
    $End If
    As _Offset lpSecurityDescriptor
    As Long bInheritHandle
    $If 64BIT Then
        As Long padding2
    $End If
End Type

Type STARTUPINFO
    As Long cb
    $If 64BIT Then
        As Long padding
    $End If
    As _Offset lpReserved, lpDesktop, lpTitle
    As Long dwX, dwY, dwXSize, dwYSize, dwXCountChars, dwYCountChars, dwFillAttribute, dwFlags
    As Integer wShowWindow, cbReserved2
    $If 64BIT Then
        As Long padding2
    $End If
    As _Offset lpReserved2, hStdInput, hStdOutput, hStdError
End Type

Type PROCESS_INFORMATION
    As _Offset hProcess, hThread
    As Long dwProcessId
    $If 64BIT Then
        As Long padding
    $End If
End Type

Const STARTF_USESTDHANDLES = &H00000100
Const CREATE_NO_WINDOW = &H8000000
Const HANDLE_FLAG_INHERIT = &H00000001
Const BUFSIZE = 4096
Const STD_OUTPUT_HANDLE = -11
Const GENERIC_READ = &H80000000
Const OPEN_EXISTING = 3
Const FILE_ATTRIBUTE_READONLY = 1
Const INVALID_HANDLE_VALUE = -1

Declare CustomType Library
    Function CreatePipe%% (ByVal hReadPipe As _Offset, Byval hWritePipe As _Offset, Byval lpPipeAttributes As _Offset, Byval nSize As Long)
    Function CreateProcess%% Alias CreateProcessA (ByVal lpApplicationName As _Offset, Byval lpCommandLine As _Offset, Byval lpProcessAttributes As _Offset, Byval lpThreadAttributes As _Offset, Byval bInheritHandles As Integer, Byval dwCreationFlags As Long, Byval lpEnvironment As _Offset, Byval lpCurrentDirectory As _Offset, Byval lpStartupInfor As _Offset, Byval lpProcessInformation As _Offset)
    Function HandleClose%% Alias "CloseHandle" (ByVal hObject As _Offset)
    Function ReadFile%% (ByVal hFile As _Offset, Byval lpBuffer As _Offset, Byval nNumberOfBytesToRead As Long, Byval lpNumberOfBytesRead As _Offset, Byval lpOverlapped As _Offset)
    Function WriteFile%% (ByVal hFile As _Offset, Byval lpBuffer As _Offset, Byval nNumberOfBytesToWrite As Long, Byval lpNumberOfBytesWritten As _Offset, Byval lpOverlapped As _Offset)
    Function GetStdHandle%& (ByVal nStdHandle As Long)
    Function SetHandleInformation%% (ByVal hObject As _Offset, Byval dwMask As Long, Byval dwFlags As Long)
    Function CreateFile%& Alias "CreateFileA" (lpFileName As String, Byval dwDesiredAccess As Long, Byval dwSharedMode As Long, Byval lpSecurityAttributes As _Offset, Byval dwCreationDisposition As Long, Byval dwFlagsAndAttributes As Long, Byval hTemplateFile As _Offset)
    Function GetLastError& ()
End Declare

Dim Shared As _Offset hChildStd_IN_Rd, hChildStd_IN_Wr, hChildStd_OUT_Rd, hChildStd_OUT_Wr, hInputFile

Dim As SECURITY_ATTRIBUTES saAttr

Print "->Start of parent execution."

saAttr.nLength = Len(saAttr)
saAttr.bInheritHandle = 1
saAttr.lpSecurityDescriptor = 0

If CreatePipe(_Offset(hChildStd_OUT_Rd), _Offset(hChildStd_OUT_Wr), _Offset(saAttr), 0) = 0 Then
    ErrorExit "StdoutRd CreatePipe"
End If

If SetHandleInformation(hChildStd_OUT_Rd, HANDLE_FLAG_INHERIT, 0) = 0 Then
    ErrorExit "Stdout SetHandleInformation"
End If

If CreatePipe(_Offset(hChildStd_IN_Rd), _Offset(hChildStd_IN_Wr), _Offset(saAttr), 0) = 0 Then
    ErrorExit "Stdin CreatePipe"
End If

If SetHandleInformation(hChildStd_IN_Wr, HANDLE_FLAG_INHERIT, 0) = 0 Then
    ErrorExit "Stdin SetHandleInformation"
End If

CreateChildProcess

WriteToPipe
Print "Contents of loremipsum.txt written to child STDIN pipe"
Print "Contents of child process STDOUT:"
ReadFromPipe
Print "->End of parent execution"

Sleep

Sub CreateChildProcess ()
    Dim As String szCmdline: szCmdline = "Child Process" + Chr$(0)
    Dim As PROCESS_INFORMATION piProcInfo
    Dim As STARTUPINFO siStartInfo
    Dim As _Byte bSuccess

    siStartInfo.cb = Len(siStartInfo)
    siStartInfo.hStdError = hChildStd_OUT_Wr
    siStartInfo.hStdOutput = hChildStd_OUT_Wr
    siStartInfo.hStdInput = hChildStd_IN_Rd
    siStartInfo.dwFlags = STARTF_USESTDHANDLES

    bSuccess = CreateProcess(0, _Offset(szCmdline), 0, 0, 1, CREATE_NO_WINDOW, 0, 0, _Offset(siStartInfo), _Offset(piProcInfo))
    If bSuccess = 0 Then
        ErrorExit "CreateProcess"
    Else
        Dim As _Byte closeh
        closeh = HandleClose(piProcInfo.hProcess)
        closeh = HandleClose(piProcInfo.hThread)
        closeh = HandleClose(hChildStd_OUT_Wr)
        closeh = HandleClose(hChildStd_IN_Rd)
    End If
End Sub

Sub WriteToPipe ()
    Dim As Long dwRead, dwWritten
    Dim As String * BUFSIZE chBuf
    Dim As _Byte bSuccess

    Dim As _Offset hInputFile: hInputFile = CreateFile("loremipsum.txt" + Chr$(0), GENERIC_READ, 0, 0, OPEN_EXISTING, FILE_ATTRIBUTE_READONLY, 0)
    Do
        bSuccess = ReadFile(hInputFile, _Offset(chBuf), BUFSIZE, _Offset(dwRead), 0)
        If bSuccess = 0 Or dwRead = 0 Then Exit Do
        bSuccess = WriteFile(hChildStd_IN_Wr, _Offset(chBuf), dwRead, _Offset(dwWritten), 0)
        If bSuccess = 0 Then Exit Do
    Loop
    If hInputFile = INVALID_HANDLE_VALUE Then
        ErrorExit "CreateFile"
    End If

    If HandleClose(hChildStd_IN_Wr) = 0 Then
        ErrorExit "StdInWr CloseHandle"
    End If
    Dim As _Byte closeh: closeh = HandleClose(hInputFile)
End Sub

Sub ReadFromPipe ()
    Dim As Long dwRead, dwWritten
    Dim As String * BUFSIZE chBuf
    Dim As _Byte bSuccess
    Dim As _Offset hParentStdOut: hParentStdOut = GetStdHandle(STD_OUTPUT_HANDLE)
    Do
        bSuccess = ReadFile(hChildStd_OUT_Rd, _Offset(chBuf), BUFSIZE, _Offset(dwRead), 0)
        If bSuccess = 0 Or dwRead = 0 Then Exit Do
        Print Mid$(chBuf, 1, dwRead)
    Loop
End Sub

Sub ErrorExit (Reason As String)
    Print Reason, GetLastError
    End
End Sub
