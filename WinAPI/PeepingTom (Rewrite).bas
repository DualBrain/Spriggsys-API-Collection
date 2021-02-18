Option _Explicit
$Console:Only
_Dest _Console

$If VERSION < 1.5 Then
    $ERROR Requires QB64 v1.5 or greater
$End If

Dim As String exe
exe = Mid$(Command$(0), _InStrRev(Command$(0), "\") + 1)
Dim As Integer pokey

Dim As _Byte testbyte
testbyte = -126
Print "Value at _Offset(testbyte):", , PeekByte(exe, _Offset(testbyte))
pokey = PokeByte(exe, _Offset(testbyte), -108)
Print "Value after PokeByte:", , testbyte
Print

Dim As _Unsigned _Byte testunsignedbyte
testunsignedbyte = 243
Print "Value at _Offset(testunsignedbyte):", PeekUnsignedByte(exe, _Offset(testunsignedbyte))
pokey = PokeUnsignedByte(exe, _Offset(testunsignedbyte), 204)
Print "Value after PokeUnsignedByte:", testunsignedbyte
Print

Dim As Integer testint
testint = -5005
Print "Value at _Offset(testint):", , PeekInt(exe, _Offset(testint))
pokey = PokeInt(exe, _Offset(testint), -4080)
Print "Value after PokeInt:", , testint
Print

Dim As _Unsigned Integer testunsignedint
testunsignedint = 5234
Print "Value at _Offset(testunsignedint):", PeekUnsignedInt(exe, _Offset(testunsignedint))
pokey = PokeUnsignedInt(exe, _Offset(testunsignedint), 5500)
Print "Value after PokeUnsignedInt:", testunsignedint
Print

Dim As Long testlong
testlong = -55000
Print "Value at _Offset(testlong):", , PeekLong(exe, _Offset(testlong))
pokey = PokeLong(exe, _Offset(testlong), -32872)
Print "Value after PokeLong:", , testlong
Print

Dim As _Unsigned Long testunsignedlong
testunsignedlong = 56985
Print "Value at _Offset(testunsignedlong:", PeekUnsignedLong(exe, _Offset(testunsignedlong))
pokey = PokeUnsignedLong(exe, _Offset(testunsignedlong), 57234)
Print "Value after PokeUnsignedLong:", testunsignedlong
Print

Dim As _Integer64 testint64
testint64 = -58698560
Print "Value at _Offset(testint64):", , PeekInt64(exe, _Offset(testint64))
pokey = PokeInt64(exe, _Offset(testint64), -98758763)
Print "Value after PokeInt64:", , testint64
Print

Dim As _Unsigned _Integer64 testunsignedint64
testunsignedint64 = 5854324590
Print "Value at _Offset(testunsignedint64):", PeekUnsignedInt64(exe, _Offset(testunsignedint64))
pokey = PokeUnsignedInt64(exe, _Offset(testunsignedint64), 3248506902)
Print "Value after PokeUnsignedInt64:", testunsignedint64
Print

Dim As String teststring
teststring = "This is a test of peeking a string"
Print PeekString(exe, _Offset(teststring))
pokey = PokeString(exe, _Offset(teststring), "This is the string after poking")
Print teststring

Sleep

'Begin $INCLUDE

Type PROCESSENTRY32
    dwSize As Long
    cntUsage As Long
    th32ProcessID As Long
    $If 64BIT Then
        padding As Long
    $End If
    th32DefaultHeapID As _Unsigned _Offset
    th32ModuleID As Long
    cntThreads As Long
    th32ParentProcessID As Long
    pcPriClassBase As Long
    dwFlags As Long
    szExeFile As String * 260
End Type

Const PROCESS_VM_READ = &H0010
Const PROCESS_QUERY_INFORMATION = &H0400
Const PROCESS_VM_WRITE = &H0020
Const PROCESS_VM_OPERATION = &H0008
Const STANDARD_RIGHTS_REQUIRED = &H000F0000
Const SYNCHRONIZE = &H00100000
Const PROCESS_ALL_ACCESS = STANDARD_RIGHTS_REQUIRED Or SYNCHRONIZE Or &HFFFF

Const TH32CS_INHERIT = &H80000000
Const TH32CS_SNAPHEAPLIST = &H00000001
Const TH32CS_SNAPMODULE = &H00000008
Const TH32CS_SNAPMODULE32 = &H00000010
Const TH32CS_SNAPPROCESS = &H00000002
Const TH32CS_SNAPTHREAD = &H00000004
Const TH32CS_SNAPALL = TH32CS_SNAPHEAPLIST Or TH32CS_SNAPMODULE Or TH32CS_SNAPPROCESS Or TH32CS_SNAPTHREAD

Const TOM_TRUE = -1
Const TOM_FALSE = 0

Declare Dynamic Library "Kernel32"
    Function CreateToolhelp32Snapshot%& (ByVal dwFlags As Long, Byval th32ProcessID As Long)
    Function Process32First% (ByVal hSnapshot As _Offset, Byval lppe As _Offset)
    Function Process32Next% (ByVal hSnapshot As _Offset, Byval lppe As _Offset)
    Function OpenProcess%& (ByVal dwDesiredAccess As Long, Byval bInheritHandle As _Byte, Byval dwProcessId As Long)
    Function ReadProcessMemory% (ByVal hProcess As _Offset, Byval lpBaseAddress As _Offset, Byval lpBuffer As _Offset, Byval nSize As Long, Byval lpNumberOfBytesRead As _Offset)
    Function WriteProcessMemory% (ByVal hProcess As _Offset, Byval lpBaseAddress As _Offset, Byval lpBuffer As _Offset, Byval nSize As Long, Byval lpNumberOfBytesWritten As _Offset)
    Function CloseHandle% (ByVal hObject As _Offset)
End Declare

Declare CustomType Library
    Function strlen& (ByVal ptr As _Unsigned _Offset)
End Declare

Function PeekByte%% (process As String, address As _Unsigned _Offset)
    Dim As _Offset hProcessSnap, hProcess
    Dim As PROCESSENTRY32 pe32
    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
    pe32.dwSize = Len(pe32)
    If Process32First(hProcessSnap, _Offset(pe32)) Then
        While Process32Next(hProcessSnap, _Offset(pe32))
            If _StrCmp(Left$(pe32.szExeFile, InStr(pe32.szExeFile, ".exe" + Chr$(0)) + 3), process) = 0 Then
                hProcess = OpenProcess(PROCESS_VM_READ Or PROCESS_QUERY_INFORMATION Or PROCESS_VM_WRITE Or PROCESS_VM_OPERATION, TOM_FALSE, pe32.th32ProcessID)
                Dim As Integer memo
                Dim As _Byte result
                memo = ReadProcessMemory(hProcess, address, _Offset(result), 1, 0)
                Exit While
            End If
        Wend
    End If
    Dim As Integer closeh
    closeh = CloseHandle(hProcessSnap)
    closeh = CloseHandle(hProcess)
    PeekByte = result
End Function

Function PokeByte% (process As String, address As _Unsigned _Offset, value As _Byte)
    Dim As _Offset hProcessSnap
    Dim As _Offset hProcess
    Dim As PROCESSENTRY32 pe32
    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
    pe32.dwSize = Len(pe32)
    If Process32First(hProcessSnap, _Offset(pe32)) Then
        While Process32Next(hProcessSnap, _Offset(pe32))
            If _StrCmp(Left$(pe32.szExeFile, InStr(pe32.szExeFile, ".exe" + Chr$(0)) + 3), process) = 0 Then
                hProcess = OpenProcess(PROCESS_VM_READ Or PROCESS_QUERY_INFORMATION Or PROCESS_VM_WRITE Or PROCESS_VM_OPERATION, TOM_FALSE, pe32.th32ProcessID)
                Dim memo As Integer
                memo = WriteProcessMemory(hProcess, address, _Offset(value), 1, 0)
                Exit While
            End If
        Wend
    End If
    Dim closeh As Long
    closeh = CloseHandle(hProcessSnap)
    closeh = CloseHandle(hProcess)
    PokeByte = memo
End Function

Function PeekUnsignedByte~%% (process As String, address As _Unsigned _Offset)
    Dim As _Offset hProcessSnap, hProcess
    Dim As PROCESSENTRY32 pe32
    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
    pe32.dwSize = Len(pe32)
    If Process32First(hProcessSnap, _Offset(pe32)) Then
        While Process32Next(hProcessSnap, _Offset(pe32))
            If _StrCmp(Left$(pe32.szExeFile, InStr(pe32.szExeFile, ".exe" + Chr$(0)) + 3), process) = 0 Then
                hProcess = OpenProcess(PROCESS_VM_READ Or PROCESS_QUERY_INFORMATION Or PROCESS_VM_WRITE Or PROCESS_VM_OPERATION, TOM_FALSE, pe32.th32ProcessID)
                Dim As Integer memo
                Dim As _Unsigned _Byte result
                memo = ReadProcessMemory(hProcess, address, _Offset(result), 1, 0)
                Exit While
            End If
        Wend
    End If
    Dim As Integer closeh
    closeh = CloseHandle(hProcessSnap)
    closeh = CloseHandle(hProcess)
    PeekUnsignedByte = result
End Function

Function PokeUnsignedByte% (process As String, address As _Unsigned _Offset, value As _Unsigned _Byte)
    Dim As _Offset hProcessSnap
    Dim As _Offset hProcess
    Dim As PROCESSENTRY32 pe32
    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
    pe32.dwSize = Len(pe32)
    If Process32First(hProcessSnap, _Offset(pe32)) Then
        While Process32Next(hProcessSnap, _Offset(pe32))
            If _StrCmp(Left$(pe32.szExeFile, InStr(pe32.szExeFile, ".exe" + Chr$(0)) + 3), process) = 0 Then
                hProcess = OpenProcess(PROCESS_VM_READ Or PROCESS_QUERY_INFORMATION Or PROCESS_VM_WRITE Or PROCESS_VM_OPERATION, TOM_FALSE, pe32.th32ProcessID)
                Dim memo As Integer
                memo = WriteProcessMemory(hProcess, address, _Offset(value), 1, 0)
                Exit While
            End If
        Wend
    End If
    Dim closeh As Long
    closeh = CloseHandle(hProcessSnap)
    closeh = CloseHandle(hProcess)
    PokeUnsignedByte = memo
End Function

Function PeekInt% (process As String, address As _Unsigned _Offset)
    Dim As _Offset hProcessSnap, hProcess
    Dim As PROCESSENTRY32 pe32
    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
    pe32.dwSize = Len(pe32)
    If Process32First(hProcessSnap, _Offset(pe32)) Then
        While Process32Next(hProcessSnap, _Offset(pe32))
            If _StrCmp(Left$(pe32.szExeFile, InStr(pe32.szExeFile, ".exe" + Chr$(0)) + 3), process) = 0 Then
                hProcess = OpenProcess(PROCESS_VM_READ Or PROCESS_QUERY_INFORMATION Or PROCESS_VM_WRITE Or PROCESS_VM_OPERATION, TOM_FALSE, pe32.th32ProcessID)
                Dim As Integer memo
                Dim As Integer result
                memo = ReadProcessMemory(hProcess, address, _Offset(result), 2, 0)
                Exit While
            End If
        Wend
    End If
    Dim As Integer closeh
    closeh = CloseHandle(hProcessSnap)
    closeh = CloseHandle(hProcess)
    PeekInt = result
End Function

Function PokeInt% (process As String, address As _Unsigned _Offset, value As Integer)
    Dim As _Offset hProcessSnap, hProcess
    Dim As PROCESSENTRY32 pe32
    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
    pe32.dwSize = Len(pe32)
    If Process32First(hProcessSnap, _Offset(pe32)) Then
        While Process32Next(hProcessSnap, _Offset(pe32))
            If _StrCmp(Left$(pe32.szExeFile, InStr(pe32.szExeFile, ".exe" + Chr$(0)) + 3), process) = 0 Then
                hProcess = OpenProcess(PROCESS_VM_READ Or PROCESS_QUERY_INFORMATION Or PROCESS_VM_WRITE Or PROCESS_VM_OPERATION, TOM_FALSE, pe32.th32ProcessID)
                Dim As Integer memo
                memo = WriteProcessMemory(hProcess, address, _Offset(value), 2, 0)
                Exit While
            End If
        Wend
    End If
    Dim As Integer closeh
    closeh = CloseHandle(hProcessSnap)
    closeh = CloseHandle(hProcess)
    PokeInt = memo
End Function

Function PeekUnsignedInt~% (process As String, address As _Unsigned _Offset)
    Dim As _Offset hProcessSnap, hProcess
    Dim As PROCESSENTRY32 pe32
    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
    pe32.dwSize = Len(pe32)
    If Process32First(hProcessSnap, _Offset(pe32)) Then
        While Process32Next(hProcessSnap, _Offset(pe32))
            If _StrCmp(Left$(pe32.szExeFile, InStr(pe32.szExeFile, ".exe" + Chr$(0)) + 3), process) = 0 Then
                hProcess = OpenProcess(PROCESS_VM_READ Or PROCESS_QUERY_INFORMATION Or PROCESS_VM_WRITE Or PROCESS_VM_OPERATION, TOM_FALSE, pe32.th32ProcessID)
                Dim As Integer memo
                Dim As _Unsigned Integer result
                memo = ReadProcessMemory(hProcess, address, _Offset(result), 2, 0)
                Exit While
            End If
        Wend
    End If
    Dim As Integer closeh
    closeh = CloseHandle(hProcessSnap)
    closeh = CloseHandle(hProcess)
    PeekUnsignedInt = result
End Function

Function PokeUnsignedInt% (process As String, address As _Unsigned _Offset, value As _Unsigned Integer)
    Dim As _Offset hProcessSnap, hProcess
    Dim As PROCESSENTRY32 pe32
    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
    pe32.dwSize = Len(pe32)
    If Process32First(hProcessSnap, _Offset(pe32)) Then
        While Process32Next(hProcessSnap, _Offset(pe32))
            If _StrCmp(Left$(pe32.szExeFile, InStr(pe32.szExeFile, ".exe" + Chr$(0)) + 3), process) = 0 Then
                hProcess = OpenProcess(PROCESS_VM_READ Or PROCESS_QUERY_INFORMATION Or PROCESS_VM_WRITE Or PROCESS_VM_OPERATION, TOM_FALSE, pe32.th32ProcessID)
                Dim As Integer memo
                memo = WriteProcessMemory(hProcess, address, _Offset(value), 2, 0)
                Exit While
            End If
        Wend
    End If
    Dim As Integer closeh
    closeh = CloseHandle(hProcessSnap)
    closeh = CloseHandle(hProcess)
    PokeUnsignedInt = memo
End Function

Function PeekLong& (process As String, address As _Unsigned _Offset)
    Dim As _Offset hProcessSnap, hProcess
    Dim As PROCESSENTRY32 pe32
    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
    pe32.dwSize = Len(pe32)
    If Process32First(hProcessSnap, _Offset(pe32)) Then
        While Process32Next(hProcessSnap, _Offset(pe32))
            If _StrCmp(Left$(pe32.szExeFile, InStr(pe32.szExeFile, ".exe" + Chr$(0)) + 3), process) = 0 Then
                hProcess = OpenProcess(PROCESS_VM_READ Or PROCESS_QUERY_INFORMATION Or PROCESS_VM_WRITE Or PROCESS_VM_OPERATION, TOM_FALSE, pe32.th32ProcessID)
                Dim As Integer memo
                Dim As Long result
                memo = ReadProcessMemory(hProcess, address, _Offset(result), 4, 0)
                Exit While
            End If
        Wend
    End If
    Dim As Integer closeh
    closeh = CloseHandle(hProcessSnap)
    closeh = CloseHandle(hProcess)
    PeekLong = result
End Function

Function PokeLong% (process As String, address As _Unsigned _Offset, value As Long)
    Dim As _Offset hProcessSnap, hProcess
    Dim As PROCESSENTRY32 pe32
    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
    pe32.dwSize = Len(pe32)
    If Process32First(hProcessSnap, _Offset(pe32)) Then
        While Process32Next(hProcessSnap, _Offset(pe32))
            If _StrCmp(Left$(pe32.szExeFile, InStr(pe32.szExeFile, ".exe" + Chr$(0)) + 3), process) = 0 Then
                hProcess = OpenProcess(PROCESS_VM_READ Or PROCESS_QUERY_INFORMATION Or PROCESS_VM_WRITE Or PROCESS_VM_OPERATION, TOM_FALSE, pe32.th32ProcessID)
                Dim As Integer memo
                memo = WriteProcessMemory(hProcess, address, _Offset(value), 4, 0)
                Exit While
            End If
        Wend
    End If
    Dim As Integer closeh
    closeh = CloseHandle(hProcessSnap)
    closeh = CloseHandle(hProcess)
    PokeLong = memo
End Function

Function PeekUnsignedLong~& (process As String, address As _Unsigned _Offset)
    Dim As _Offset hProcessSnap, hProcess
    Dim As PROCESSENTRY32 pe32
    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
    pe32.dwSize = Len(pe32)
    If Process32First(hProcessSnap, _Offset(pe32)) Then
        While Process32Next(hProcessSnap, _Offset(pe32))
            If _StrCmp(Left$(pe32.szExeFile, InStr(pe32.szExeFile, ".exe" + Chr$(0)) + 3), process) = 0 Then
                hProcess = OpenProcess(PROCESS_VM_READ Or PROCESS_QUERY_INFORMATION Or PROCESS_VM_WRITE Or PROCESS_VM_OPERATION, TOM_FALSE, pe32.th32ProcessID)
                Dim As Integer memo
                Dim As _Unsigned Long result
                memo = ReadProcessMemory(hProcess, address, _Offset(result), 4, 0)
                Exit While
            End If
        Wend
    End If
    Dim As Integer closeh
    closeh = CloseHandle(hProcessSnap)
    closeh = CloseHandle(hProcess)
    PeekUnsignedLong = result
End Function

Function PokeUnsignedLong% (process As String, address As _Unsigned _Offset, value As _Unsigned Long)
    Dim As _Offset hProcessSnap, hProcess
    Dim As PROCESSENTRY32 pe32
    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
    pe32.dwSize = Len(pe32)
    If Process32First(hProcessSnap, _Offset(pe32)) Then
        While Process32Next(hProcessSnap, _Offset(pe32))
            If _StrCmp(Left$(pe32.szExeFile, InStr(pe32.szExeFile, ".exe" + Chr$(0)) + 3), process) = 0 Then
                hProcess = OpenProcess(PROCESS_VM_READ Or PROCESS_QUERY_INFORMATION Or PROCESS_VM_WRITE Or PROCESS_VM_OPERATION, TOM_FALSE, pe32.th32ProcessID)
                Dim As Integer memo
                memo = WriteProcessMemory(hProcess, address, _Offset(value), 4, 0)
                Exit While
            End If
        Wend
    End If
    Dim As Integer closeh
    closeh = CloseHandle(hProcessSnap)
    closeh = CloseHandle(hProcess)
    PokeUnsignedLong = memo
End Function

Function PeekInt64&& (process As String, address As _Unsigned _Offset)
    Dim As _Offset hProcessSnap, hProcess
    Dim As PROCESSENTRY32 pe32
    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
    pe32.dwSize = Len(pe32)
    If Process32First(hProcessSnap, _Offset(pe32)) Then
        While Process32Next(hProcessSnap, _Offset(pe32))
            If _StrCmp(Left$(pe32.szExeFile, InStr(pe32.szExeFile, ".exe" + Chr$(0)) + 3), process) = 0 Then
                hProcess = OpenProcess(PROCESS_VM_READ Or PROCESS_QUERY_INFORMATION Or PROCESS_VM_WRITE Or PROCESS_VM_OPERATION, TOM_FALSE, pe32.th32ProcessID)
                Dim As Integer memo
                Dim As _Integer64 result
                memo = ReadProcessMemory(hProcess, address, _Offset(result), 8, 0)
                Exit While
            End If
        Wend
    End If
    Dim As Integer closeh
    closeh = CloseHandle(hProcessSnap)
    closeh = CloseHandle(hProcess)
    PeekInt64 = result
End Function

Function PokeInt64% (process As String, address As _Unsigned _Offset, value As _Integer64)
    Dim As _Offset hProcessSnap, hProcess
    Dim As PROCESSENTRY32 pe32
    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
    pe32.dwSize = Len(pe32)
    If Process32First(hProcessSnap, _Offset(pe32)) Then
        While Process32Next(hProcessSnap, _Offset(pe32))
            If _StrCmp(Left$(pe32.szExeFile, InStr(pe32.szExeFile, ".exe" + Chr$(0)) + 3), process) = 0 Then
                hProcess = OpenProcess(PROCESS_VM_READ Or PROCESS_QUERY_INFORMATION Or PROCESS_VM_WRITE Or PROCESS_VM_OPERATION, TOM_FALSE, pe32.th32ProcessID)
                Dim As Integer memo
                memo = WriteProcessMemory(hProcess, address, _Offset(value), 8, 0)
                Exit While
            End If
        Wend
    End If
    Dim As Integer closeh
    closeh = CloseHandle(hProcessSnap)
    closeh = CloseHandle(hProcess)
    PokeInt64 = memo
End Function

Function PeekUnsignedInt64~&& (process As String, address As _Unsigned _Offset)
    Dim As _Offset hProcessSnap, hProcess
    Dim As PROCESSENTRY32 pe32
    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
    pe32.dwSize = Len(pe32)
    If Process32First(hProcessSnap, _Offset(pe32)) Then
        While Process32Next(hProcessSnap, _Offset(pe32))
            If _StrCmp(Left$(pe32.szExeFile, InStr(pe32.szExeFile, ".exe" + Chr$(0)) + 3), process) = 0 Then
                hProcess = OpenProcess(PROCESS_VM_READ Or PROCESS_QUERY_INFORMATION Or PROCESS_VM_WRITE Or PROCESS_VM_OPERATION, TOM_FALSE, pe32.th32ProcessID)
                Dim As Integer memo
                Dim As _Unsigned _Integer64 result
                memo = ReadProcessMemory(hProcess, address, _Offset(result), 8, 0)
                Exit While
            End If
        Wend
    End If
    Dim As Integer closeh
    closeh = CloseHandle(hProcessSnap)
    closeh = CloseHandle(hProcess)
    PeekUnsignedInt64 = result
End Function

Function PokeUnsignedInt64% (process As String, address As _Unsigned _Offset, value As _Unsigned _Integer64)
    Dim As _Offset hProcessSnap, hProcess
    Dim As PROCESSENTRY32 pe32
    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
    pe32.dwSize = Len(pe32)
    If Process32First(hProcessSnap, _Offset(pe32)) Then
        While Process32Next(hProcessSnap, _Offset(pe32))
            If _StrCmp(Left$(pe32.szExeFile, InStr(pe32.szExeFile, ".exe" + Chr$(0)) + 3), process) = 0 Then
                hProcess = OpenProcess(PROCESS_VM_READ Or PROCESS_QUERY_INFORMATION Or PROCESS_VM_WRITE Or PROCESS_VM_OPERATION, TOM_FALSE, pe32.th32ProcessID)
                Dim As Integer memo
                memo = WriteProcessMemory(hProcess, address, _Offset(value), 8, 0)
                Exit While
            End If
        Wend
    End If
    Dim As Integer closeh
    closeh = CloseHandle(hProcessSnap)
    closeh = CloseHandle(hProcess)
    PokeUnsignedInt64 = memo
End Function

Function PeekString$ (process As String, address As _Unsigned _Offset)
    Dim As _Offset hProcessSnap, hProcess
    Dim As PROCESSENTRY32 pe32
    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
    pe32.dwSize = Len(pe32)
    If Process32First(hProcessSnap, _Offset(pe32)) Then
        While Process32Next(hProcessSnap, _Offset(pe32))
            If _StrCmp(Left$(pe32.szExeFile, InStr(pe32.szExeFile, ".exe" + Chr$(0)) + 3), process) = 0 Then
                hProcess = OpenProcess(PROCESS_VM_READ Or PROCESS_QUERY_INFORMATION Or PROCESS_VM_WRITE Or PROCESS_VM_OPERATION, TOM_FALSE, pe32.th32ProcessID)
                Dim As Integer memo
                Dim As String result
                result = Space$(strlen(address))
                memo = ReadProcessMemory(hProcess, address, _Offset(result), Len(result), 0)
                Exit While
            End If
        Wend
    End If
    Dim As Integer closeh
    closeh = CloseHandle(hProcessSnap)
    closeh = CloseHandle(hProcess)
    PeekString = result
End Function

Function PokeString% (process As String, address As _Unsigned _Offset, value As String)
    Dim As _Offset hProcessSnap, hProcess
    Dim As PROCESSENTRY32 pe32
    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
    pe32.dwSize = Len(pe32)
    If Process32First(hProcessSnap, _Offset(pe32)) Then
        While Process32Next(hProcessSnap, _Offset(pe32))
            If _StrCmp(Left$(pe32.szExeFile, InStr(pe32.szExeFile, ".exe" + Chr$(0)) + 3), process) = 0 Then
                hProcess = OpenProcess(PROCESS_VM_READ Or PROCESS_QUERY_INFORMATION Or PROCESS_VM_WRITE Or PROCESS_VM_OPERATION, TOM_FALSE, pe32.th32ProcessID)
                Dim As Integer memo
                Dim As Long lenaddress
                lenaddress = strlen(address)
                If lenaddress > Len(value) Then
                    Dim As Long i
                    For i = 1 To lenaddress
                        value = value + Chr$(0)
                    Next
                End If
                memo = WriteProcessMemory(hProcess, address, _Offset(value), Len(value), 0)
                Exit While
            End If
        Wend
    End If
    Dim As Integer closeh
    closeh = CloseHandle(hProcessSnap)
    closeh = CloseHandle(hProcess)
    PokeString = memo
End Function
'End $INCLUDE
