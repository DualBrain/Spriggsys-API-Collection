$NOPREFIX
$CONSOLE:ONLY
DEST CONSOLE
DECLARE DYNAMIC LIBRARY "kernel32"
    FUNCTION GetComputerName ALIAS GetComputerNameA (lpBuffer AS STRING, nSize AS LONG)
END DECLARE
DECLARE DYNAMIC LIBRARY "Advapi32"
    FUNCTION GetUsername ALIAS GetUserNameA (lpBuffer AS STRING, pcbBuffer AS LONG)
END DECLARE
cn$ = SPACE$(1024)
a = GetComputerName(cn$, 1024)
ComputerName$ = LTRIM$(RTRIM$(cn$))
COLOR 15
PRINT "Computer Name: ";
COLOR 10
PRINT ComputerName$
un$ = SPACE$(1024)
a = GetUsername(un$, 1024)
username$ = LTRIM$(RTRIM$(un$))
COLOR 15
PRINT "Username: ";
COLOR 10
PRINT username$
SHELL "WMIC BIOS GET SERIALNUMBER,SMBIOSBIOSVERSION"
COLOR 15
SLEEP
