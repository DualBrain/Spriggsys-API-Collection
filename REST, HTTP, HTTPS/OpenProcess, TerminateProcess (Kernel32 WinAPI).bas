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

'Flags
CONST TH32CS_INHERIT = &H80000000
CONST TH32CS_SNAPHEAPLIST = &H00000001
CONST TH32CS_SNAPMODULE = &H00000008
CONST TH32CS_SNAPMODULE32 = &H00000010
CONST TH32CS_SNAPPROCESS = &H00000002
CONST TH32CS_SNAPTHREAD = &H00000004
CONST TH32CS_SNAPALL = TH32CS_SNAPHEAPLIST OR TH32CS_SNAPMODULE OR TH32CS_SNAPPROCESS OR TH32CS_SNAPTHREAD

CONST PROCESS_TERMINATE = &H0001

DECLARE DYNAMIC LIBRARY "Kernel32"
    FUNCTION CreateToolhelp32Snapshot& (BYVAL dwFlags AS LONG, BYVAL th32ProcessID AS LONG)
    FUNCTION Process32First%% (BYVAL hSnapshot AS LONG, BYVAL lppe AS _OFFSET)
    FUNCTION Process32Next%% (BYVAL hSnapshot AS LONG, BYVAL lppe AS _OFFSET)
    FUNCTION OpenProcess& (BYVAL dwDesiredAccess AS LONG, BYVAL bInheritHandle AS _BYTE, BYVAL dwProcessId AS LONG)
    FUNCTION TerminateProcess%% (BYVAL hProcess AS LONG, BYVAL uExitCode AS _UNSIGNED INTEGER)
    FUNCTION CloseHandle%% (BYVAL hObject AS LONG)
END DECLARE
'NOTE: Processes do NOT close gracefully with this option. It's just to kill something immediately.
'DIM processname AS STRING
'processname = "ffmpeg.exe"
'DIM a AS _BYTE
'a = KillProcessByName(processname) 'Doesn't kill gracefully. Think twice before using.
'a = KillProcessByPID(18892) 'Doesn't kill gracefully. Think twice before using.
'SoftKill processname 'Kills gracefully. Use this if you have concerns about file corruption.

FUNCTION KillProcessByName%% (processname AS STRING)
    DIM snap AS LONG
    snap = CreateToolhelp32Snapshot(TH32CS_SNAPALL, 0)
    DIM pEntry AS PROCESSENTRY32
    pEntry.dwSize = LEN(pEntry)
    DIM hRes AS _BYTE
    hRes = Process32First(snap, _OFFSET(pEntry))
    WHILE hRes
        IF _STRCMP(LEFT$(pEntry.szExeFile, INSTR(pEntry.szExeFile, ".exe" + CHR$(0)) + 3), processname) = 0 THEN
            DIM hProcess AS LONG
            hProcess = OpenProcess(PROCESS_TERMINATE, 0, pEntry.th32ProcessID)
            IF hProcess <> 0 THEN
                DIM terminate AS LONG
                DIM closeh AS LONG
                terminate = TerminateProcess(hProcess, 0)
                closeh = CloseHandle(hProcess)
                IF terminate THEN KillProcessByName = terminate
            END IF
        END IF
        hRes = Process32Next(snap, _OFFSET(pEntry))
    WEND
    closeh = CloseHandle(snap)
END FUNCTION

FUNCTION KillProcessByPID%% (PID AS _UNSIGNED INTEGER)
    DIM hProcess AS LONG
    hProcess = OpenProcess(PROCESS_TERMINATE, 0, PID)
    IF hProcess <> 0 THEN
        DIM terminate AS LONG
        DIM closeh AS LONG
        terminate = TerminateProcess(hProcess, 0)
        closeh = CloseHandle(hProcess)
        IF terminate THEN KillProcessByPID = terminate
    END IF
END FUNCTION

SUB SoftKill (processname AS STRING)
    SHELL _HIDE "SendSignal " + CHR$(34) + processname + CHR$(34)
END SUB
