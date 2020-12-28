OPTION _EXPLICIT

$IF 64BIT THEN
    TYPE PROCESSENTRY32
        dwSize AS LONG
        cntUsage AS LONG
        th32ProcessID AS _INTEGER64
        th32DefaultHeapID AS _UNSIGNED _INTEGER64
        th32ModuleID AS LONG
        cntThreads AS LONG
        th32ParentProcessID AS LONG
        pcPriClassBase AS LONG
        dwFlags AS LONG
        szExeFile AS STRING * 260
    END TYPE
$ELSE
    TYPE PROCESSENTRY32
    dwSize AS LONG
    cntUsage AS LONG
    th32ProcessID AS LONG
    th32DefaultHeapID AS _UNSIGNED LONG
    th32ModuleID AS LONG
    cntThreads AS LONG
    th32ParentProcessID AS LONG
    pcPriClassBase AS LONG
    dwFlags AS LONG
    szExeFile AS STRING * 260
    END TYPE
$END IF

CONST PROCESS_VM_READ = &H0010
CONST PROCESS_QUERY_INFORMATION = &H0400
CONST PROCESS_VM_WRITE = &H0020
CONST PROCESS_VM_OPERATION = &H0008
CONST STANDARD_RIGHTS_REQUIRED = &H000F0000
CONST SYNCHRONIZE = &H00100000
CONST PROCESS_ALL_ACCESS = STANDARD_RIGHTS_REQUIRED OR SYNCHRONIZE OR &HFFFF

CONST TH32CS_INHERIT = &H80000000
CONST TH32CS_SNAPHEAPLIST = &H00000001
CONST TH32CS_SNAPMODULE = &H00000008
CONST TH32CS_SNAPMODULE32 = &H00000010
CONST TH32CS_SNAPPROCESS = &H00000002
CONST TH32CS_SNAPTHREAD = &H00000004
CONST TH32CS_SNAPALL = TH32CS_SNAPHEAPLIST OR TH32CS_SNAPMODULE OR TH32CS_SNAPPROCESS OR TH32CS_SNAPTHREAD

CONST TRUE = -1
CONST FALSE = 0

DECLARE DYNAMIC LIBRARY "Kernel32"
    FUNCTION CreateToolhelp32Snapshot& (BYVAL dwFlags AS LONG, BYVAL th32ProcessID AS LONG)
    FUNCTION Process32First%% (BYVAL hSnapshot AS LONG, BYVAL lppe AS _OFFSET)
    FUNCTION Process32Next%% (BYVAL hSnapshot AS LONG, BYVAL lppe AS _OFFSET)
    FUNCTION OpenProcess& (BYVAL dwDesiredAccess AS LONG, BYVAL bInheritHandle AS _BYTE, BYVAL dwProcessId AS LONG)
    FUNCTION ReadProcessMemory%% (BYVAL hProcess AS LONG, BYVAL lpBaseAddress AS _OFFSET, BYVAL lpBuffer AS _OFFSET, BYVAL nSize AS LONG, BYVAL lpNumberOfBytesRead AS _OFFSET)
    FUNCTION WriteProcessMemory%% (BYVAL hProcess AS LONG, BYVAL lpBaseAddress AS _OFFSET, BYVAL lpBuffer AS _OFFSET, BYVAL nSize AS LONG, BYVAL lpNumberOfBytesWritten AS _OFFSET)
    FUNCTION CloseHandle%% (BYVAL hObject AS LONG)
END DECLARE

DECLARE CUSTOMTYPE LIBRARY
    FUNCTION strlen& (BYVAL ptr AS _UNSIGNED _OFFSET)
END DECLARE

_TITLE "Peeping Tom: A Powerful PEEK/POKE"

DIM test AS STRING
test = "This is a test" + CHR$(0)
DIM exe AS STRING
exe = MID$(COMMAND$(0), _INSTRREV(COMMAND$(0), "\") + 1)
PRINT CHR$(peekbyte(exe, _OFFSET(test)))
PRINT peekstring(exe, _OFFSET(test))

DIM testint AS INTEGER
testint = 320
PRINT peekint(exe, _OFFSET(testint))

DIM testlong AS LONG
testlong = &HFF
PRINT peeklong(exe, _OFFSET(testlong))

DIM testint64 AS _INTEGER64
testint64 = 922337
PRINT peekint64(exe, _OFFSET(testint64))

DIM a AS _BYTE
a = pokebyte(exe, _OFFSET(test), ASC("S"))
PRINT peekstring(exe, _OFFSET(test))

a = pokeint(exe, _OFFSET(testint), 312)
PRINT peekint(exe, _OFFSET(testint))

a = pokelong(exe, _OFFSET(testlong), &HFE)
PRINT peeklong(exe, _OFFSET(testlong))

a = pokeint64(exe, _OFFSET(testint64), 922345)
PRINT peekint64(exe, _OFFSET(testint64))

a = pokestring(exe, _OFFSET(test), "This is NOT a test" + CHR$(0))
PRINT peekstring(exe, _OFFSET(test))

FUNCTION peekbyte%% (process AS STRING, address AS _UNSIGNED _OFFSET)
    DIM hProcessSnap AS LONG
    DIM hProcess AS LONG
    DIM pe32 AS PROCESSENTRY32
    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
    pe32.dwSize = LEN(pe32)
    IF Process32First(hProcessSnap, _OFFSET(pe32)) THEN
        WHILE Process32Next(hProcessSnap, _OFFSET(pe32))
            IF _STRCMP(LEFT$(pe32.szExeFile, INSTR(pe32.szExeFile, ".exe" + CHR$(0)) + 3), process) = 0 THEN
                hProcess = OpenProcess(PROCESS_VM_READ OR PROCESS_QUERY_INFORMATION OR PROCESS_VM_WRITE OR PROCESS_VM_OPERATION, FALSE, pe32.th32ProcessID)
                DIM memo AS _BYTE
                DIM result AS _BYTE
                memo = ReadProcessMemory(hProcess, address, _OFFSET(result), 1, 0)
                EXIT WHILE
            END IF
        WEND
    END IF
    DIM closeh AS LONG
    closeh = CloseHandle(hProcessSnap)
    closeh = CloseHandle(hProcess)
    peekbyte = result
END FUNCTION

FUNCTION peekint% (process AS STRING, address AS _UNSIGNED _OFFSET)
    DIM hProcessSnap AS LONG
    DIM hProcess AS LONG
    DIM pe32 AS PROCESSENTRY32
    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
    pe32.dwSize = LEN(pe32)
    IF Process32First(hProcessSnap, _OFFSET(pe32)) THEN
        WHILE Process32Next(hProcessSnap, _OFFSET(pe32))
            IF _STRCMP(LEFT$(pe32.szExeFile, INSTR(pe32.szExeFile, ".exe" + CHR$(0)) + 3), process) = 0 THEN
                hProcess = OpenProcess(PROCESS_VM_READ OR PROCESS_QUERY_INFORMATION OR PROCESS_VM_WRITE OR PROCESS_VM_OPERATION, FALSE, pe32.th32ProcessID)
                DIM memo AS _BYTE
                DIM result AS INTEGER
                memo = ReadProcessMemory(hProcess, address, _OFFSET(result), 2, 0)
                EXIT WHILE
            END IF
        WEND
    END IF
    DIM closeh AS LONG
    closeh = CloseHandle(hProcessSnap)
    closeh = CloseHandle(hProcess)
    peekint = result
END FUNCTION

FUNCTION peeklong& (process AS STRING, address AS _UNSIGNED _OFFSET)
    DIM hProcessSnap AS LONG
    DIM hProcess AS LONG
    DIM pe32 AS PROCESSENTRY32
    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
    pe32.dwSize = LEN(pe32)
    IF Process32First(hProcessSnap, _OFFSET(pe32)) THEN
        WHILE Process32Next(hProcessSnap, _OFFSET(pe32))
            IF _STRCMP(LEFT$(pe32.szExeFile, INSTR(pe32.szExeFile, ".exe" + CHR$(0)) + 3), process) = 0 THEN
                hProcess = OpenProcess(PROCESS_VM_READ OR PROCESS_QUERY_INFORMATION OR PROCESS_VM_WRITE OR PROCESS_VM_OPERATION, FALSE, pe32.th32ProcessID)
                DIM memo AS _BYTE
                DIM result AS LONG
                memo = ReadProcessMemory(hProcess, address, _OFFSET(result), 4, 0)
                EXIT WHILE
            END IF
        WEND
    END IF
    DIM closeh AS LONG
    closeh = CloseHandle(hProcessSnap)
    closeh = CloseHandle(hProcess)
    peeklong = result
END FUNCTION

FUNCTION peekint64&& (process AS STRING, address AS _UNSIGNED _OFFSET)
    DIM hProcessSnap AS LONG
    DIM hProcess AS LONG
    DIM pe32 AS PROCESSENTRY32
    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
    pe32.dwSize = LEN(pe32)
    IF Process32First(hProcessSnap, _OFFSET(pe32)) THEN
        WHILE Process32Next(hProcessSnap, _OFFSET(pe32))
            IF _STRCMP(LEFT$(pe32.szExeFile, INSTR(pe32.szExeFile, ".exe" + CHR$(0)) + 3), process) = 0 THEN
                hProcess = OpenProcess(PROCESS_VM_READ OR PROCESS_QUERY_INFORMATION OR PROCESS_VM_WRITE OR PROCESS_VM_OPERATION, FALSE, pe32.th32ProcessID)
                DIM memo AS _BYTE
                DIM result AS _INTEGER64
                memo = ReadProcessMemory(hProcess, address, _OFFSET(result), 8, 0)
                EXIT WHILE
            END IF
        WEND
    END IF
    DIM closeh AS LONG
    closeh = CloseHandle(hProcessSnap)
    closeh = CloseHandle(hProcess)
    peekint64 = result
END FUNCTION

FUNCTION peekstring$ (process AS STRING, address AS _UNSIGNED _OFFSET)
    DIM hProcessSnap AS LONG
    DIM hProcess AS LONG
    DIM pe32 AS PROCESSENTRY32
    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
    pe32.dwSize = LEN(pe32)
    IF Process32First(hProcessSnap, _OFFSET(pe32)) THEN
        WHILE Process32Next(hProcessSnap, _OFFSET(pe32))
            IF _STRCMP(LEFT$(pe32.szExeFile, INSTR(pe32.szExeFile, ".exe" + CHR$(0)) + 3), process) = 0 THEN
                hProcess = OpenProcess(PROCESS_VM_READ OR PROCESS_QUERY_INFORMATION OR PROCESS_VM_WRITE OR PROCESS_VM_OPERATION, FALSE, pe32.th32ProcessID)
                DIM memo AS _BYTE
                DIM result AS STRING
                result = SPACE$(PointerLen(address))
                memo = ReadProcessMemory(hProcess, address, _OFFSET(result), LEN(result), 0)
                EXIT WHILE
            END IF
        WEND
    END IF
    DIM closeh AS LONG
    closeh = CloseHandle(hProcessSnap)
    closeh = CloseHandle(hProcess)
    peekstring = result
END FUNCTION

FUNCTION pokebyte%% (process AS STRING, address AS _UNSIGNED _OFFSET, value AS _BYTE)
    DIM hProcessSnap AS LONG
    DIM hProcess AS LONG
    DIM pe32 AS PROCESSENTRY32
    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
    pe32.dwSize = LEN(pe32)
    IF Process32First(hProcessSnap, _OFFSET(pe32)) THEN
        WHILE Process32Next(hProcessSnap, _OFFSET(pe32))
            IF _STRCMP(LEFT$(pe32.szExeFile, INSTR(pe32.szExeFile, ".exe" + CHR$(0)) + 3), process) = 0 THEN
                hProcess = OpenProcess(PROCESS_VM_READ OR PROCESS_QUERY_INFORMATION OR PROCESS_VM_WRITE OR PROCESS_VM_OPERATION, FALSE, pe32.th32ProcessID)
                DIM memo AS _BYTE
                memo = WriteProcessMemory(hProcess, address, _OFFSET(value), 1, 0)
                EXIT WHILE
            END IF
        WEND
    END IF
    DIM closeh AS LONG
    closeh = CloseHandle(hProcessSnap)
    closeh = CloseHandle(hProcess)
    pokebyte = memo
END FUNCTION

FUNCTION pokeint%% (process AS STRING, address AS _UNSIGNED _OFFSET, value AS INTEGER)
    DIM hProcessSnap AS LONG
    DIM hProcess AS LONG
    DIM pe32 AS PROCESSENTRY32
    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
    pe32.dwSize = LEN(pe32)
    IF Process32First(hProcessSnap, _OFFSET(pe32)) THEN
        WHILE Process32Next(hProcessSnap, _OFFSET(pe32))
            IF _STRCMP(LEFT$(pe32.szExeFile, INSTR(pe32.szExeFile, ".exe" + CHR$(0)) + 3), process) = 0 THEN
                hProcess = OpenProcess(PROCESS_VM_READ OR PROCESS_QUERY_INFORMATION OR PROCESS_VM_WRITE OR PROCESS_VM_OPERATION, FALSE, pe32.th32ProcessID)
                DIM memo AS _BYTE
                memo = WriteProcessMemory(hProcess, address, _OFFSET(value), 2, 0)
                EXIT WHILE
            END IF
        WEND
    END IF
    DIM closeh AS LONG
    closeh = CloseHandle(hProcessSnap)
    closeh = CloseHandle(hProcess)
    pokeint = memo
END FUNCTION

FUNCTION pokelong%% (process AS STRING, address AS _UNSIGNED _OFFSET, value AS LONG)
    DIM hProcessSnap AS LONG
    DIM hProcess AS LONG
    DIM pe32 AS PROCESSENTRY32
    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
    pe32.dwSize = LEN(pe32)
    IF Process32First(hProcessSnap, _OFFSET(pe32)) THEN
        WHILE Process32Next(hProcessSnap, _OFFSET(pe32))
            IF _STRCMP(LEFT$(pe32.szExeFile, INSTR(pe32.szExeFile, ".exe" + CHR$(0)) + 3), process) = 0 THEN
                hProcess = OpenProcess(PROCESS_VM_READ OR PROCESS_QUERY_INFORMATION OR PROCESS_VM_WRITE OR PROCESS_VM_OPERATION, FALSE, pe32.th32ProcessID)
                DIM memo AS _BYTE
                memo = WriteProcessMemory(hProcess, address, _OFFSET(value), 4, 0)
                EXIT WHILE
            END IF
        WEND
    END IF
    DIM closeh AS LONG
    closeh = CloseHandle(hProcessSnap)
    closeh = CloseHandle(hProcess)
    pokelong = memo
END FUNCTION

FUNCTION pokeint64%% (process AS STRING, address AS _UNSIGNED _OFFSET, value AS _INTEGER64)
    DIM hProcessSnap AS LONG
    DIM hProcess AS LONG
    DIM pe32 AS PROCESSENTRY32
    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
    pe32.dwSize = LEN(pe32)
    IF Process32First(hProcessSnap, _OFFSET(pe32)) THEN
        WHILE Process32Next(hProcessSnap, _OFFSET(pe32))
            IF _STRCMP(LEFT$(pe32.szExeFile, INSTR(pe32.szExeFile, ".exe" + CHR$(0)) + 3), process) = 0 THEN
                hProcess = OpenProcess(PROCESS_VM_READ OR PROCESS_QUERY_INFORMATION OR PROCESS_VM_WRITE OR PROCESS_VM_OPERATION, FALSE, pe32.th32ProcessID)
                DIM memo AS _BYTE
                memo = WriteProcessMemory(hProcess, address, _OFFSET(value), 8, 0)
                EXIT WHILE
            END IF
        WEND
    END IF
    DIM closeh AS LONG
    closeh = CloseHandle(hProcessSnap)
    closeh = CloseHandle(hProcess)
    pokeint64 = memo
END FUNCTION

FUNCTION pokestring%% (process AS STRING, address AS _UNSIGNED _OFFSET, value AS STRING)
    DIM hProcessSnap AS LONG
    DIM hProcess AS LONG
    DIM pe32 AS PROCESSENTRY32
    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
    pe32.dwSize = LEN(pe32)
    IF Process32First(hProcessSnap, _OFFSET(pe32)) THEN
        WHILE Process32Next(hProcessSnap, _OFFSET(pe32))
            IF _STRCMP(LEFT$(pe32.szExeFile, INSTR(pe32.szExeFile, ".exe" + CHR$(0)) + 3), process) = 0 THEN
                hProcess = OpenProcess(PROCESS_VM_READ OR PROCESS_QUERY_INFORMATION OR PROCESS_VM_WRITE OR PROCESS_VM_OPERATION, FALSE, pe32.th32ProcessID)
                DIM memo AS _BYTE
                memo = WriteProcessMemory(hProcess, address, _OFFSET(value), LEN(value), 0)
                EXIT WHILE
            END IF
        WEND
    END IF
    DIM closeh AS LONG
    closeh = CloseHandle(hProcessSnap)
    closeh = CloseHandle(hProcess)
    pokestring = memo
END FUNCTION

FUNCTION PointerLen& (value AS _OFFSET)
    PointerLen = strlen(value)
END FUNCTION
