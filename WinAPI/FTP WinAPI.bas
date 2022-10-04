OPTION _EXPLICIT
$CONSOLE
_CONSOLE OFF
$COLOR:0

'Constants
CONST INTERNET_OPEN_TYPE_DIRECT = 1

CONST INTERNET_DEFAULT_FTP_PORT = 21

CONST INTERNET_SERVICE_FTP = 1

CONST FILE_ATTRIBUTE_ARCHIVE = &H20
CONST FILE_ATTRIBUTE_COMPRESSED = &H800
CONST FILE_ATTRIBUTE_DEVICE = &H40
CONST FILE_ATTRIBUTE_DIRECTORY = &H10
CONST FILE_ATTRIBUTE_ENCRYPTED = &H4000
CONST FILE_ATTRIBUTE_HIDDEN = &H2
CONST FILE_ATTRIBUTE_INTEGRITY_STREAM = &H8000
CONST FILE_ATTRIBUTE_NORMAL = &H80
CONST FILE_ATTRIBUTE_NOT_CONTENT_INDEXED = &H2000
CONST FILE_ATTRIBUTE_NO_SCRUB_DATA = &H20000
CONST FILE_ATTRIBUTE_OFFLINE = &H1000
CONST FILE_ATTRIBUTE_READONLY = &H1
CONST FILE_ATTRIBUTE_RECALL_ON_DATA_ACCESS = &H400000
CONST FILE_ATTRIBUTE_RECALL_ON_OPEN = &H40000
CONST FILE_ATTRIBUTE_REPARSE_POINT = &H400
CONST FILE_ATTRIBUTE_SPARSE_FILE = &H200
CONST FILE_ATTRIBUTE_SYSTEM = &H4
CONST FILE_ATTRIBUTE_TEMPORARY = &H100
CONST FILE_ATTRIBUTE_VIRTUAL = &H10000

'Flags
CONST INTERNET_FLAG_RELOAD = &H80000000
CONST INTERNET_FLAG_PASSIVE = &H08000000

CONST FTP_TRANSFER_TYPE_ASCII = &H00000001
CONST FTP_TRANSFER_TYPE_BINARY = &H00000002
CONST FTP_TRANSFER_TYPE_UNKNOWN = &H00000000

CONST MAX_PATH = 260

CONST MAXDWORD = &HFFFFFFFF

CONST GENERIC_READ = &H80000000
CONST GENERIC_WRITE = &H40000000

CONST TRUE = 1
CONST FALSE = 0

DIM SHARED hInternet AS LONG
DIM SHARED hFtpSession AS LONG

TYPE SYSTEMTIME
    wYear AS INTEGER
    wMonth AS INTEGER
    wDayOfWeek AS INTEGER
    wDay AS INTEGER
    wHour AS INTEGER
    wMinute AS INTEGER
    wSecond AS INTEGER
    wMilliseconds AS INTEGER
END TYPE

TYPE FILETIME
    dwLowDateTime AS LONG
    dwHighDateTime AS LONG
END TYPE

TYPE WIN32_FIND_DATA
    dwFileAttributes AS LONG
    ftCreationTime AS FILETIME
    ftLastAccessTime AS FILETIME
    ftLastWriteTime AS FILETIME
    nFileSizeHigh AS _UNSIGNED LONG
    nFileSizeLow AS _UNSIGNED LONG
    dwReserved0 AS LONG
    dwReserved1 AS LONG
    cFileName AS STRING * MAX_PATH
    cAlternateFileName AS STRING * 14
    dwFileType AS LONG
    dwCreatorType AS LONG
    wFinderFlags AS INTEGER
END TYPE

TYPE TIME_DYNAMIC_ZONE_INFORMATION
    Bias AS LONG
    StandardName AS STRING * 64
    StandardDate AS SYSTEMTIME
    StandardBias AS LONG
    DaylightName AS STRING * 64
    DaylightDate AS SYSTEMTIME
    DaylightBias AS LONG
    TimeZoneKeyName AS STRING * 256
    DynamicDaylightTimeDisabled AS _BYTE
END TYPE

DECLARE DYNAMIC LIBRARY "Wininet"
    FUNCTION InternetOpen& ALIAS InternetOpenA (BYVAL lpszAgent AS _OFFSET, BYVAL dwAccessType AS LONG, BYVAL lpszProxy AS _OFFSET, BYVAL lpszProxyBypass AS _OFFSET, BYVAL dwFlags AS LONG)
    FUNCTION InternetConnect& ALIAS InternetConnectA (BYVAL hInternet AS LONG, BYVAL lpszServerName AS _OFFSET, BYVAL nServerPort AS INTEGER, BYVAL lpszUserName AS _OFFSET, BYVAL lpszPassword AS _OFFSET, BYVAL dwService AS LONG, BYVAL dwFlags AS LONG, BYVAL dwContext AS _OFFSET)
    FUNCTION InternetGetlastResponseInfo%% ALIAS InternetGetLastResponseInfoA (BYVAL lpdwError AS _OFFSET, BYVAL lpszBuffer AS _OFFSET, BYVAL lpdwBufferLength AS _OFFSET)
    FUNCTION FTPGetCurrentDirectory%% ALIAS FtpGetCurrentDirectoryA (BYVAL hConnect AS LONG, BYVAL lpszCurrentDirectory AS _OFFSET, BYVAL lpdwCurrentDirectory AS _OFFSET)
    FUNCTION FTPSetCurrentDirectory%% ALIAS FtpSetCurrentDirectoryA (BYVAL hConnect AS LONG, BYVAL lpszDirectory AS _OFFSET)
    FUNCTION FTPFindFirstFile& ALIAS FtpFindFirstFileA (BYVAL hConnect AS LONG, BYVAL lpszSearchFile AS _OFFSET, BYVAL lpFindFileData AS _OFFSET, BYVAL dwFlags AS LONG, BYVAL dwContext AS _OFFSET)
    FUNCTION FTPFindNextFile%% ALIAS InternetFindNextFileA (BYVAL hFind AS LONG, BYVAL lpvFindData AS _OFFSET)
    FUNCTION FTPOpenFile& ALIAS FtpOpenFileA (BYVAL hConnect AS LONG, BYVAL lpszFileName AS _OFFSET, BYVAL dwAccess AS LONG, BYVAL dwFlags AS LONG, BYVAL dwContext AS _OFFSET)
    'FUNCTION FTPGetFile%% ALIAS FtpGetFileA (BYVAL hConnect AS LONG, BYVAL lpszRemoteFile AS _OFFSET, BYVAL lpszNewFile AS _OFFSET, BYVAL fFailIfExists AS _BYTE, BYVAL dwFlagsAndAttributes AS LONG, BYVAL dwFlags AS LONG, BYVAL dwContext AS _OFFSET)
    'FUNCTION FTPPutFile%% ALIAS FtpPutFileA (BYVAL hConnect AS LONG, BYVAL lpszLocalFile AS _OFFSET, BYVAL lpszNewRemoteFile AS _OFFSET, BYVAL dwFlags AS LONG, BYVAL dwContext AS _OFFSET)
    FUNCTION FTPGetFileSize~& ALIAS FtpGetFileSize (BYVAL hFile AS LONG, BYVAL lpdwFileSizeHigh AS _OFFSET)
    FUNCTION FTPRenameFile%% ALIAS FtpRenameFileA (BYVAL hConnect AS LONG, BYVAL lpszExisting AS _OFFSET, BYVAL lpszNew AS _OFFSET)
    FUNCTION FTPDeleteFile%% ALIAS FtpDeleteFileA (BYVAL hConnect AS LONG, BYVAL lpszFileName AS _OFFSET)
    FUNCTION FTPCreateDirectory%% ALIAS FtpCreateDirectoryA (BYVAL hConnect AS LONG, BYVAL lpszDirectory AS _OFFSET)
    FUNCTION FTPRemoveDirectory%% ALIAS FtpRemoveDirectoryA (BYVAL hConnect AS LONG, BYVAL lpszDirectory AS _OFFSET)
    FUNCTION InternetReadFile%% (BYVAL hFile AS LONG, BYVAL lpBuffer AS _OFFSET, BYVAL dwNumberOfBytesToRead AS LONG, BYVAL lpdwNumberOfBytesRead AS _OFFSET)
    FUNCTION InternetWriteFile%% (BYVAL hFile AS LONG, BYVAL lpBuffer AS _OFFSET, BYVAL dwNumberOfBytesToWrite AS LONG, BYVAL lpdwNumberOfBytesWritten AS _OFFSET)
    FUNCTION InternetLockRequestFile%% (BYVAL hInternet AS LONG, BYVAL lphLockRequestInfo AS _OFFSET)
    FUNCTION InternetUnlockRequestFile%% (BYVAL hLockRequestInfo AS LONG)
    FUNCTION InternetCloseHandle%% (BYVAL hInternet AS LONG)
END DECLARE

DECLARE DYNAMIC LIBRARY "Kernel32"
    FUNCTION GetLastError& ()
    FUNCTION FileTimeToSystemTime%% (BYVAL lpFileTime AS _OFFSET, BYVAL lpSystemTime AS _OFFSET)
    FUNCTION SystemTimeToLocalTime%% ALIAS SystemTimeToTzSpecificLocalTimeEx (BYVAL lpTimeZoneInformation AS _UNSIGNED _OFFSET, BYVAL lpUniversalTime AS _UNSIGNED _OFFSET, BYVAL lpLocalTime AS _UNSIGNED _OFFSET)
    FUNCTION GetDynamicTimeZoneInformation~& (BYVAL lpTimeZoneInformation AS _UNSIGNED _OFFSET)
END DECLARE


CALL FTPConnect("yourserver", "yourusername", "yourpassword", INTERNET_DEFAULT_FTP_PORT)

DIM a AS _BYTE
'a = FTPchdir("Server/Server1/Movies/Bob Hope and Bing Crosby")

a = FTPchdir("Server/Server1/Music")

a = FTPDownload("2Yoon/Harvest Moon/01 24_7.mp3", "C:\Users\Zachary\Music\24_7.mp3")
IF a = TRUE THEN PRINT "Downloaded" ELSE PRINT "Download failed"


'a = FTPUpload("C:\Users\Zachary\Music\The Seventh Power\The Power\10 The Power.mp3", "The Seventh Power - The Power.mp3")
'IF a = TRUE THEN PRINT "Uploaded" ELSE PRINT "Upload failed"
'a = FTPmkdir("Test Directory")
'a = FTPdel("The Seventh Power - The Power.mp3")
'CALL FTPdir(".srt")
'CALL FTPdir("")
'PRINT FTPfilelist(".mkv")

CALL CloseFTP
SLEEP

_CONSOLE OFF

SUB FTPConnect (hostname AS STRING, username AS STRING, password AS STRING, port AS INTEGER)
    IF port = 0 THEN port = INTERNET_DEFAULT_FTP_PORT
    hInternet = InternetOpen(0, INTERNET_OPEN_TYPE_DIRECT, 0, 0, 0)
    IF hInternet = FALSE THEN
        PRINT "InternetOpen", GetLastError
    ELSE
        hostname = hostname + CHR$(0)
        username = username + CHR$(0)
        password = password + CHR$(0)
        hFtpSession = InternetConnect(hInternet, _OFFSET(hostname), port, _OFFSET(username), _OFFSET(password), INTERNET_SERVICE_FTP, INTERNET_FLAG_PASSIVE, 0)
        IF hFtpSession = FALSE THEN
            DIM a AS _BYTE
            PRINT "InternetConnet", GetLastError
            DIM dwError AS LONG
            DIM errorbuffer AS STRING
            DIM errorlen AS LONG
            errorbuffer = SPACE$(1024)
            errorlen = LEN(errorbuffer)
            a = InternetGetlastResponseInfo(_OFFSET(dwError), _OFFSET(errorbuffer), _OFFSET(errorlen))
            PRINT "Error Info:"; dwError, MID$(errorbuffer, 1, errorlen)
        END IF
    END IF
END SUB

SUB CloseFTP
    DIM a AS _BYTE
    a = InternetCloseHandle(hFtpSession)
    a = InternetCloseHandle(hInternet)
END SUB

FUNCTION FTPren%% (oldname AS STRING, newname AS STRING)
    IF oldname <> "" AND newname <> "" AND hFtpSession <> 0 THEN
        oldname = oldname + CHR$(0)
        newname = newname + CHR$(0)
        DIM a AS _BYTE
        a = FTPRenameFile(hFtpSession, _OFFSET(oldname), _OFFSET(newname))
        FTPren = a
    END IF
END FUNCTION

FUNCTION FTPrmdir%% (directory AS STRING)
    IF directory <> "" AND hFtpSession <> 0 THEN
        directory = directory + CHR$(0)
        DIM a AS _BYTE
        a = FTPRemoveDirectory(hFtpSession, _OFFSET(directory))
        FTPrmdir = a
    END IF
END FUNCTION

FUNCTION FTPdel%% (filename AS STRING)
    IF filename <> "" AND hFtpSession <> 0 THEN
        filename = filename + CHR$(0)
        DIM a AS _BYTE
        a = FTPDeleteFile(hFtpSession, _OFFSET(filename))
        FTPdel = a
    END IF
END FUNCTION

FUNCTION FTPmkdir%% (directory AS STRING)
    IF directory <> "" AND hFtpSession <> 0 THEN
        directory = directory + CHR$(0)
        DIM a AS _BYTE
        a = FTPCreateDirectory(hFtpSession, _OFFSET(directory))
        FTPmkdir = a
    END IF
END FUNCTION

FUNCTION FTPchdir%% (directory AS STRING)
    IF hFtpSession = FALSE OR directory = "" THEN
        FTPchdir = FALSE
    ELSE
        DIM a AS _BYTE
        directory = directory + CHR$(0)
        a = FTPSetCurrentDirectory(hFtpSession, _OFFSET(directory))
        IF a = FALSE THEN
            FTPchdir = FALSE
            PRINT "FTPSetCurrentDirectory", GetLastError
            DIM dwError AS LONG
            DIM errorbuffer AS STRING
            DIM errorlen AS LONG
            errorbuffer = SPACE$(1024)
            errorlen = LEN(errorbuffer)
            a = InternetGetlastResponseInfo(_OFFSET(dwError), _OFFSET(errorbuffer), _OFFSET(errorlen))
            PRINT "Error Info:"; dwError, MID$(errorbuffer, 1, errorlen)
        ELSE
            FTPchdir = a
        END IF
    END IF
END FUNCTION

FUNCTION FTPfilelist$ (filter AS STRING)
    DIM find AS WIN32_FIND_DATA
    DIM ftpfind AS LONG
    DIM filelist AS STRING
    DIM tempfile AS STRING
    DIM a AS _BYTE
    ftpfind = FTPFindFirstFile(hFtpSession, 0, _OFFSET(find), INTERNET_FLAG_RELOAD, 0)
    IF ftpfind <> FALSE THEN
        tempfile = MID$(find.cFileName, 1, INSTR(find.cFileName, CHR$(0)) - 1)
        PRINT RIGHT$(tempfile, LEN(filter))
        IF RIGHT$(tempfile, LEN(filter)) = filter THEN
            filelist = filelist + CHR$(10) + tempfile
        END IF
        a = TRUE
        WHILE a = TRUE
            a = FTPFindNextFile(ftpfind, _OFFSET(find))
            IF a = TRUE THEN
                tempfile = MID$(find.cFileName, 1, INSTR(find.cFileName, CHR$(0)) - 1)
                IF RIGHT$(tempfile, LEN(filter)) = filter THEN
                    filelist = filelist + CHR$(10) + tempfile
                END IF
            END IF
        WEND
        FTPfilelist = filelist
    END IF
END FUNCTION

SUB FTPdir (filter AS STRING)
    _CONSOLE ON
    _DEST _CONSOLE
    _SCREENICON
    IF hFtpSession = FALSE THEN
        PRINT "No session"
    ELSE
        DIM a AS _BYTE
        DIM currentdirectory AS STRING
        DIM lendir AS LONG
        currentdirectory = SPACE$(MAX_PATH)
        lendir = LEN(currentdirectory) + 1
        DIM ftpfind AS LONG
        DIM fileSize AS _UNSIGNED _INTEGER64
        DIM datasize AS _UNSIGNED _INTEGER64
        DIM filename AS STRING
        DIM year AS INTEGER
        DIM month AS INTEGER
        DIM day AS INTEGER
        DIM hour AS INTEGER
        DIM minute AS INTEGER
        DIM systemTime AS SYSTEMTIME
        DIM convertTime AS _BYTE
        DIM timestamp AS STRING
        DIM filecount AS INTEGER
        DIM dircount AS INTEGER
        DIM totalbytes AS _UNSIGNED _OFFSET
        DIM changecolor AS _BYTE
        DIM tempfile AS STRING
        a = FTPGetCurrentDirectory(hFtpSession, _OFFSET(currentdirectory), _OFFSET(lendir))
        DIM find AS WIN32_FIND_DATA
        ftpfind = FTPFindFirstFile(hFtpSession, 0, _OFFSET(find), INTERNET_FLAG_RELOAD, 0)
        IF ftpfind <> FALSE THEN
            COLOR LightCyan
            PRINT STRING$(23 + lendir, "=")
            PRINT "|Directory Listing of "; MID$(currentdirectory, 1, lendir); "|"
            _CONSOLETITLE "Directory Listing of " + MID$(currentdirectory, 1, lendir)
            PRINT STRING$(23 + lendir, "=")
            COLOR LightMagenta
            PRINT STRING$(80, "=")
            PRINT "Last Modified", "    Size", , "Name"
            PRINT STRING$(80, "=")
            COLOR BrightWhite
            convertTime = FileTimeToSystemTime(_OFFSET(find.ftLastWriteTime), _OFFSET(systemTime))
            DIM zoneInfo AS TIME_DYNAMIC_ZONE_INFORMATION
            DIM localtime AS SYSTEMTIME
            DIM zone AS _OFFSET
            zone = GetDynamicTimeZoneInformation(_OFFSET(zoneInfo))
            convertTime = SystemTimeToLocalTime(_OFFSET(zoneInfo), _OFFSET(systemTime), _OFFSET(localtime))
            year = localtime.wYear
            month = localtime.wMonth
            day = localtime.wDay
            hour = localtime.wHour
            minute = localtime.wMinute
            SELECT CASE month
                CASE IS >= 10
                    timestamp = LTRIM$(STR$(month))
                CASE ELSE
                    timestamp = "0" + LTRIM$(STR$(month))
            END SELECT
            SELECT CASE day
                CASE IS >= 10
                    timestamp = timestamp + "/" + LTRIM$(STR$(day))
                CASE ELSE
                    timestamp = timestamp + "/0" + LTRIM$(STR$(day))
            END SELECT
            timestamp = timestamp + "/" + LTRIM$(STR$(year))
            SELECT CASE hour
                CASE IS >= 10
                    timestamp = timestamp + " " + LTRIM$(STR$(hour))
                CASE ELSE
                    timestamp = timestamp + " 0" + LTRIM$(STR$(hour))
            END SELECT
            SELECT CASE minute
                CASE IS >= 10
                    timestamp = timestamp + ":" + LTRIM$(STR$(minute))
                CASE ELSE
                    timestamp = timestamp + ":0" + LTRIM$(STR$(minute))
            END SELECT
            changecolor = 1
            IF find.dwFileAttributes AND FILE_ATTRIBUTE_DIRECTORY AND filter = "" THEN
                PRINT timestamp, ;
                COLOR LightGreen
                PRINT , , "<DIR> "; MID$(find.cFileName, 1, INSTR(find.cFileName, CHR$(0)))
                dircount = dircount + 1
            ELSE
                tempfile = MID$(find.cFileName, 1, INSTR(find.cFileName, CHR$(0)) - 1)
                IF RIGHT$(tempfile, LEN(filter)) = filter THEN
                    PRINT timestamp, ;
                    filecount = filecount + 1
                    datasize = (find.nFileSizeLow)
                    IF datasize < 0 AND (find.nFileSizeHigh) > 0 THEN
                        fileSize = datasize + MAXDWORD + (find.nFileSizeHigh * MAXDWORD)
                    ELSE
                        IF (find.nFileSizeHigh) > 0 THEN
                            fileSize = datasize + (find.nFileSizeHigh * MAXDWORD)
                        ELSEIF datasize < 0 THEN
                            fileSize = datasize + MAXDWORD
                        ELSE
                            fileSize = datasize
                        END IF
                    END IF
                    filename = MID$(find.cFileName, 1, INSTR(find.cFileName, CHR$(0)))
                    SELECT CASE fileSize
                        CASE IS < 1024
                            PRINT USING "   ####  B"; fileSize,
                        CASE IS < (1024 ^ 2) AND fileSize >= 1024
                            PRINT USING "####.## KB"; (fileSize / 1024),
                        CASE IS < (1024 ^ 3) AND fileSize >= (1024 ^ 2)
                            PRINT USING "####.## MB"; (fileSize / (1024 ^ 2)),
                        CASE IS < (1024 ^ 4) AND fileSize >= (1024 ^ 3)
                            PRINT USING "####.## GB"; (fileSize / (1024 ^ 3)),
                    END SELECT
                    PRINT , filename
                    totalbytes = totalbytes + fileSize
                END IF
            END IF
            WHILE a = TRUE
                a = FTPFindNextFile(ftpfind, _OFFSET(find))
                IF a THEN
                    convertTime = FileTimeToSystemTime(_OFFSET(find.ftLastWriteTime), _OFFSET(systemTime))
                    zone = GetDynamicTimeZoneInformation(_OFFSET(zoneInfo))
                    convertTime = SystemTimeToLocalTime(_OFFSET(zoneInfo), _OFFSET(systemTime), _OFFSET(localtime))
                    year = localtime.wYear
                    month = localtime.wMonth
                    day = localtime.wDay
                    hour = localtime.wHour
                    minute = localtime.wMinute
                    SELECT CASE month
                        CASE IS >= 10
                            timestamp = LTRIM$(STR$(month))
                        CASE ELSE
                            timestamp = "0" + LTRIM$(STR$(month))
                    END SELECT
                    SELECT CASE day
                        CASE IS >= 10
                            timestamp = timestamp + "/" + LTRIM$(STR$(day))
                        CASE ELSE
                            timestamp = timestamp + "/0" + LTRIM$(STR$(day))
                    END SELECT
                    timestamp = timestamp + "/" + LTRIM$(STR$(year))
                    SELECT CASE hour
                        CASE IS >= 10
                            timestamp = timestamp + " " + LTRIM$(STR$(hour))
                        CASE ELSE
                            timestamp = timestamp + " 0" + LTRIM$(STR$(hour))
                    END SELECT
                    SELECT CASE minute
                        CASE IS >= 10
                            timestamp = timestamp + ":" + LTRIM$(STR$(minute))
                        CASE ELSE
                            timestamp = timestamp + ":0" + LTRIM$(STR$(minute))
                    END SELECT

                    IF find.dwFileAttributes AND FILE_ATTRIBUTE_DIRECTORY THEN
                        IF changecolor THEN
                            COLOR Brown
                            changecolor = 0
                        ELSE
                            COLOR BrightWhite
                            changecolor = 1
                        END IF
                        PRINT timestamp, ;
                        COLOR LightGreen
                        PRINT , , "<DIR> "; MID$(find.cFileName, 1, INSTR(find.cFileName, CHR$(0)))
                        dircount = dircount + 1
                    ELSE
                        tempfile = MID$(find.cFileName, 1, INSTR(find.cFileName, CHR$(0)) - 1)
                        IF RIGHT$(tempfile, LEN(filter)) = filter THEN
                            IF changecolor THEN
                                COLOR Brown
                                changecolor = 0
                            ELSE
                                COLOR BrightWhite
                                changecolor = 1
                            END IF
                            PRINT timestamp, ;
                            filecount = filecount + 1
                            datasize = (find.nFileSizeLow)
                            IF datasize < 0 AND (find.nFileSizeHigh) > 0 THEN
                                fileSize = datasize + MAXDWORD + (find.nFileSizeHigh * MAXDWORD)
                            ELSE
                                IF (find.nFileSizeHigh) > 0 THEN
                                    fileSize = datasize + (find.nFileSizeHigh * MAXDWORD) + 1
                                ELSEIF datasize < 0 THEN
                                    fileSize = datasize + MAXDWORD
                                ELSE
                                    fileSize = datasize
                                END IF
                            END IF
                            filename = MID$(find.cFileName, 1, INSTR(find.cFileName, CHR$(0)))
                            SELECT CASE fileSize
                                CASE IS < 1024
                                    PRINT USING "   ####  B"; fileSize,
                                CASE IS < (1024 ^ 2) AND fileSize >= 1024
                                    PRINT USING "####.## KB"; (fileSize / 1024),
                                CASE IS < (1024 ^ 3) AND fileSize >= (1024 ^ 2)
                                    PRINT USING "####.## MB"; (fileSize / (1024 ^ 2)),
                                CASE IS < (1024 ^ 4) AND fileSize >= (1024 ^ 3)
                                    PRINT USING "####.## GB"; (fileSize / (1024 ^ 3)),
                            END SELECT
                            PRINT , filename
                            totalbytes = totalbytes + fileSize
                        END IF
                    END IF
                END IF
            WEND
            COLOR LightCyan
            PRINT
            PRINT filecount, " file(s)", , ;
            SELECT CASE totalbytes
                CASE IS < 1024
                    PRINT USING "Approx_.   #### bytes"; totalbytes
                CASE IS < (1024 ^ 2) AND totalbytes >= 1024
                    PRINT USING "Approx_. ####.## kilobytes"; (totalbytes / 1024)
                CASE IS < (1024 ^ 3) AND totalbytes >= (1024 ^ 2)
                    PRINT USING "Approx_. ####.## megabytes"; (totalbytes / (1024 ^ 2))
                CASE IS < (1024 ^ 4) AND totalbytes >= (1024 ^ 3)
                    PRINT USING "Approx_. ####.## gigabytes"; (totalbytes / (1024 ^ 3))
                CASE IS < (1024 ^ 5) AND totalbytes >= (1024 ^ 4)
                    PRINT USING "Approx_. ####.## terabytes"; (totalbytes / (1024 ^ 4))
            END SELECT
            PRINT dircount, " folder(s)"
            IF filecount = 0 AND filter <> "" THEN
                COLOR LightRed
                PRINT "No files could be found matching filter " + CHR$(34) + filter + CHR$(34)
            END IF
        ELSE
            PRINT "FTPFindFirstFile", GetLastError
            DIM dwError AS LONG
            DIM errorbuffer AS STRING
            DIM errorlen AS LONG
            errorbuffer = SPACE$(1024)
            errorlen = LEN(errorbuffer)
            a = InternetGetlastResponseInfo(_OFFSET(dwError), _OFFSET(errorbuffer), _OFFSET(errorlen))
            PRINT "Error Info:"; dwError, MID$(errorbuffer, 1, errorlen)
        END IF
    END IF
    _DEST 0
END SUB

FUNCTION FTPUpload%% (sourcefile AS STRING, destfile AS STRING)
    IF sourcefile <> "" AND destfile <> "" AND hFtpSession <> 0 THEN
        'sourcefile = sourcefile + CHR$(0)
        destfile = destfile + CHR$(0)
        DIM a AS _BYTE
        'a = FTPPutFile(hFtpSession, _OFFSET(sourcefile), _OFFSET(destfile), FTP_TRANSFER_TYPE_BINARY OR INTERNET_FLAG_RELOAD, 0)
        DIM hTransfer AS LONG
        hTransfer = FTPOpenFile(hFtpSession, _OFFSET(destfile), GENERIC_WRITE, FTP_TRANSFER_TYPE_BINARY, 0)
        IF hTransfer THEN
            DIM buffer AS STRING
            buffer = SPACE$(1024)
            DIM filesize AS _UNSIGNED _INTEGER64
            OPEN sourcefile FOR BINARY AS #1
            LOCK #1
            filesize = LOF(1)
            DIM bytesWritten AS _UNSIGNED _INTEGER64
            DIM dwWrite AS LONG
            DO
                GET #1, , buffer
                a = InternetWriteFile(hTransfer, _OFFSET(buffer), LEN(buffer), _OFFSET(dwWrite))
                bytesWritten = bytesWritten + dwWrite
                CLS
                PRINT bytesWritten; "bytes uploaded of"; filesize
                PRINT USING "###.##%"; (bytesWritten / filesize) * 100
                _DISPLAY
            LOOP UNTIL bytesWritten >= filesize OR GetLastError <> 0 OR EOF(1)
            IF bytesWritten >= filesize AND GetLastError = 0 AND EOF(1) THEN
                FTPUpload = TRUE
                bytesWritten = filesize
                CLS
                PRINT bytesWritten; "bytes uploaded of"; filesize
                PRINT USING "###.##%"; (bytesWritten / filesize) * 100
                _DISPLAY
            ELSE FTPUpload = FALSE
            END IF
            UNLOCK #1
            CLOSE #1
            _AUTODISPLAY
            a = InternetCloseHandle(hTransfer)
        ELSE
            FTPUpload = FALSE
            PRINT "FTPOpenFile", GetLastError
        END IF
    ELSE
        FTPUpload = FALSE
    END IF
END FUNCTION

FUNCTION FTPDownload%% (sourcefile AS STRING, destfile AS STRING)
    IF sourcefile <> "" AND destfile <> "" AND hFtpSession <> 0 THEN
        sourcefile = sourcefile + CHR$(0)
        'destfile = destfile + CHR$(0)
        DIM a AS _BYTE
        'a = FTPGetFile(hFtpSession, _OFFSET(sourcefile), _OFFSET(destfile), TRUE, FILE_ATTRIBUTE_NORMAL, FTP_TRANSFER_TYPE_BINARY, 0)
        'FTPDownload = a
        DIM hTransfer AS LONG
        hTransfer = FTPOpenFile(hFtpSession, _OFFSET(sourcefile), GENERIC_READ, FTP_TRANSFER_TYPE_BINARY, 0)
        DIM lockhandle AS LONG
        a = InternetLockRequestFile(hTransfer, _OFFSET(lockhandle))
        IF hTransfer AND a = TRUE AND lockhandle <> 0 THEN
            DIM buffer AS STRING
            buffer = SPACE$(1024)
            DIM datasize AS _UNSIGNED _INTEGER64
            DIM filesize AS _UNSIGNED _INTEGER64
            DIM FileSizeHigh AS _UNSIGNED LONG
            DIM FileSizeLow AS _UNSIGNED LONG
            DIM bytesRead AS _UNSIGNED _INTEGER64
            DIM dwRead AS LONG
            OPEN destfile FOR BINARY AS #1
            DIM outputfile AS STRING

            FileSizeLow = FTPGetFileSize(hTransfer, _OFFSET(FileSizeHigh))
            datasize = (FileSizeLow)
            IF datasize < 0 AND (FileSizeHigh) > 0 THEN
                filesize = datasize + MAXDWORD + (FileSizeHigh * MAXDWORD)
            ELSE
                IF (FileSizeHigh) > 0 THEN
                    filesize = datasize + (FileSizeHigh * MAXDWORD)
                ELSEIF datasize < 0 THEN
                    filesize = datasize + MAXDWORD
                ELSE
                    filesize = datasize
                END IF
            END IF
            datasize = 0
            DO
                a = InternetReadFile(hTransfer, _OFFSET(buffer), LEN(buffer) - 1, _OFFSET(dwRead))
                IF dwRead > 0 THEN
                    outputfile = MID$(buffer, 1, dwRead)
                    PUT #1, , outputfile
                    bytesRead = bytesRead + dwRead
                    CLS
                    PRINT bytesRead; "bytes downloaded of"; filesize
                    PRINT USING "###.##%"; (bytesRead / filesize) * 100
                    _DISPLAY
                END IF
            LOOP UNTIL bytesRead = filesize OR GetLastError <> 0
            _AUTODISPLAY
            CLOSE #1
            IF bytesRead = filesize THEN FTPDownload = TRUE ELSE FTPDownload = FALSE
            a = InternetUnlockRequestFile(lockhandle)
            a = InternetCloseHandle(hTransfer)
        ELSE
            FTPDownload = FALSE
            PRINT "FTPOpenFile", GetLastError
        END IF
    END IF
END FUNCTION
