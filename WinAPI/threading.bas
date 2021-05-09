Option _Explicit
$Console:Only

Type MyData
    As Long val1, val2
End Type

Const BUF_SIZE = 255
Const MAX_THREADS = 20
Const HEAP_ZERO_MEMORY = &H00000008
Const INFINITE = 4294967295
Const STD_OUTPUT_HANDLE = -11
Const INVALID_HANDLE_VALUE = -1

Const MB_OK = 0

Const FORMAT_MESSAGE_ALLOCATE_BUFFER = &H00000100
Const FORMAT_MESSAGE_FROM_SYSTEM = &H00001000
Const FORMAT_MESSAGE_IGNORE_INSERTS = &H00000200
Const LANG_NEUTRAL = &H00
Const SUBLANG_DEFAULT = &H01

Const LMEM_ZEROINIT = &H0040

Declare CustomType Library
    Function LoadLibrary%& (lpLibFileName As String)
    Function GetProcAddress%& (ByVal hModule As _Offset, lpProcName As String)
    Function FreeLibrary%% (ByVal hLibModule As _Offset)
    Sub FreeLibrary (ByVal hLibModule As _Offset)
    Function GetLastError& ()
    Function HeapAlloc%& (ByVal hHeap As _Offset, Byval dwFlags As Long, Byval dwBytes As _Offset)
    Function GetProcessHeap%& ()
    Sub ExitProcess (ByVal uExitCode As _Unsigned Long)
    Function CreateThread%& (ByVal lpThreadAttributes As _Offset, Byval dwStackSize As _Offset, Byval lpStartAddress As _Offset, Byval lpParameter As _Offset, Byval dwCreationFlags As Long, Byval lpThreadId As _Offset)
    Function WaitForMultipleObjects& (ByVal nCount As Long, Byval lpHandles As _Offset, Byval bWaitAll As _Byte, Byval dwMilliseconds As Long)
    Sub WaitForMultipleObjects (ByVal nCount As Long, Byval lpHandles As _Offset, Byval bWaitAll As _Byte, Byval dwMilliseconds As Long)
    Function CloseHandle%% (ByVal hObject As _Offset)
    Sub CloseHandle (ByVal hObject As _Offset)
    Function HeapFree%% (ByVal hHeap As _Offset, Byval dwFlags As Long, Byval lpMem As _Offset)
    Sub HeapFree (ByVal hHeap As _Offset, Byval dwFlags As Long, Byval lpMem As _Offset)
    Sub StringCchPrintf Alias "StringCchPrintfA" (ByVal pszDest As _Offset, Byval cchDest As _Offset, byvalpszFormat As String, Byval arg1 As Long, Byval arg2 As Long)
    Sub StringCchPrintf2 Alias "StringCchPrintfA" (ByVal pszDest As _Offset, Byval cchDest As _Offset, pszFormat As String, lpszFunction As String, Byval error As Long, Byval lpMsgBuf As _Offset)
    Sub StringCchLength Alias "StringCchLengthA" (ByVal psz As _Offset, Byval cchMax As _Offset, Byval pcchLength As _Offset)
    Function GetStdHandle%& (ByVal nStdHandle As Long)
    Function CreateMutex%& Alias "CreateMutexA" (ByVal lpMutexAttributes As _Offset, Byval bInitialOwner As Long, Byval lpName As _Offset)
    Sub WriteConsole (ByVal hConsoleOutput As _Offset, Byval lpBuffer As _Offset, Byval nNumberOfCharsToWrite As Long, Byval lpNumberOfCharsWritten As _Offset, Byval lpReserved As _Offset)
    Sub FormatMessage Alias FormatMessageA (ByVal dwFlags As Long, Byval lpSource As Long, Byval dwMessageId As Long, Byval dwLanguageId As Long, Byval lpBuffer As _Offset, Byval nSize As Long, Byval Arguments As _Offset)
    Sub MessageBox Alias "MessageBoxA" (ByVal hWnd As _Offset, Byval lpText As _Offset, lpCaption As String, Byval uType As _Unsigned Long)
    Sub LocalFree (ByVal hMem As _Offset)
    Function LocalAlloc%& (ByVal uFlags As _Unsigned Long, Byval uBytes As _Unsigned _Offset)
    Function lstrlen& Alias "lstrlenA" (ByVal lpString As _Offset)
    Function LocalSize%& (ByVal hMem As _Offset)
    Sub SetLastError (ByVal dwError As Long)
End Declare

Declare Library "threadwin"
    Function sizeoftchar& ()
End Declare

Declare Library
    Function MAKELANGID& (ByVal p As Long, Byval s As Long)
End Declare

Dim As _Offset libload: libload = LoadLibrary(Command$(0))
Dim As _Offset MyThreadFunc: MyThreadFunc = GetProcAddress(libload, "MyThreadFunction")

Dim As MyData pDataArray(1 To MAX_THREADS)
Dim As Long dwThreadIdArray(1 To MAX_THREADS)
Dim As _Offset hThreadArray(1 To MAX_THREADS), heap(1 To MAX_THREADS)

Dim As _Offset ghMutex: ghMutex = CreateMutex(0, 0, 0)
If ghMutex = 0 Then
    ErrorHandler "CreateMutex"
End If
Dim As Long i
For i = 1 To MAX_THREADS
    heap(i) = HeapAlloc(GetProcessHeap, HEAP_ZERO_MEMORY, Len(pDataArray(i)))
    Dim As _MEM pdata: pdata = _MemNew(8)
    _MemPut pdata, pdata.OFFSET, heap(i)
    _MemGet pdata, pdata.OFFSET, pDataArray(i)
    If heap(i) = 0 Then
        ExitProcess 2
    End If
    pDataArray(i).val1 = i
    pDataArray(i).val2 = i + 100
    hThreadArray(i) = CreateThread(0, 0, MyThreadFunc, _Offset(pDataArray(i)), 0, _Offset(dwThreadIdArray(i)))
    If hThreadArray(i) = 0 Then
        ErrorHandler "CreateThread"
        ExitProcess 3
    End If
Next
WaitForMultipleObjects MAX_THREADS, _Offset(hThreadArray()), 1, INFINITE
For i = 1 To MAX_THREADS
    CloseHandle hThreadArray(i)
    If heap(i) <> 0 Then
        HeapFree GetProcessHeap, 0, heap(i)
    End If
Next
CloseHandle ghMutex
FreeLibrary libload

Function MyThreadFunction& (lpParam As _Offset)
    Dim As String * BUF_SIZE msgBuf
    Dim As _Offset hStdout
    Dim As Long cchStringSize, dwChars
    Dim As MyData MyData
    hStdout = GetStdHandle(STD_OUTPUT_HANDLE)
    If hStdout = INVALID_HANDLE_VALUE Then
        MyThreadFunction = 1
    End If
    Dim As _MEM PMYDATA: PMYDATA = _MemNew(8)
    _MemPut PMYDATA, PMYDATA.OFFSET, lpParam
    _MemGet PMYDATA, PMYDATA.OFFSET, MyData
    StringCchPrintf _Offset(msgBuf), BUF_SIZE, "Parameters = %d, %d" + Chr$(10) + Chr$(0), MyData.val1, MyData.val2
    StringCchLength _Offset(msgBuf), BUF_SIZE, _Offset(cchStringSize)
    WriteConsole hStdout, _Offset(msgBuf), cchStringSize, _Offset(dwChars), 0
    MyThreadFunction = 0
End Function

Sub ErrorHandler (lpszFunction As String)
    Dim As _Offset lpMsgBuf, lpDisplayBuf
    Dim As Long dw: dw = GetLastError
    FormatMessage FORMAT_MESSAGE_ALLOCATE_BUFFER Or FORMAT_MESSAGE_FROM_SYSTEM Or FORMAT_MESSAGE_IGNORE_INSERTS, 0, dw, MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), _Offset(lpMsgBuf), 0, 0
    lpDisplayBuf = LocalAlloc(LMEM_ZEROINIT, (lstrlen(lpMsgBuf) + lstrlen(_Offset(lpszFunction)) + 40) * sizeoftchar)
    StringCchPrintf2 lpDisplayBuf, LocalSize(lpDisplayBuf) / sizeoftchar, "%s failed with error %d:" + Chr$(10) + " %s" + Chr$(0), lpszFunction + Chr$(0), dw, lpMsgBuf
    MessageBox 0, lpDisplayBuf, "Error" + Chr$(0), MB_OK
    LocalFree lpMsgBuf
    LocalFree lpDisplayBuf
End Sub
