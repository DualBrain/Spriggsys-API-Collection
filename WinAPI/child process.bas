Option _Explicit
$Console:Only

Const BUFSIZE = 4096
Const STD_OUTPUT_HANDLE = -11
Const STD_INPUT_HANDLE = -10
Const STD_ERROR_HANDLE = -12
Const INVALID_HANDLE_VALUE = -1

Declare CustomType Library
    Function ReadFile%% (ByVal hFile As _Offset, Byval lpBuffer As _Offset, Byval nNumberOfBytesToRead As Long, Byval lpNumberOfBytesRead As _Offset, Byval lpOverlapped As _Offset)
    Function GetStdHandle%& (ByVal nStdHandle As Long)
    Sub ExitProcess (ByVal uExitCode As _Unsigned Long)
End Declare

Dim As String * BUFSIZE chBuf
Dim As Long dwRead, dwWritten
Dim As _Offset hStdin, hStdout
Dim As _Byte bSuccess

hStdin = GetStdHandle(STD_INPUT_HANDLE)

If hStdout = INVALID_HANDLE_VALUE Then
    ExitProcess 1
End If

Print " ** This is a message from the child process. **"

Do
    bSuccess = ReadFile(hStdin, _Offset(chBuf), BUFSIZE, _Offset(dwRead), 0)
    Print Mid$(chBuf, 1, dwRead);
    If bSuccess = 0 Or dwRead = 0 Then
        Exit Do
    End If
Loop
System 0
