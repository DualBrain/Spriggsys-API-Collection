Option _Explicit
$Console:Only
_Dest _Console

Const INTERNET_OPEN_TYPE_PRECONFIG = 0
Const INTERNET_OPEN_TYPE_DIRECT = 1
Const INTERNET_OPEN_TYPE_PROXY = 3
Const INTERNET_OPEN_TYPE_PRECONF_NO_AUTOPROXY = 4

Const INTERNET_DEFAULT_FTP_PORT = 21
Const INTERNET_DEFAULT_GOPHER_PORT = 70
Const INTERNET_DEFAULT_HTTP_PORT = 80
Const INTERNET_DEFAULT_HTTPS_PORT = 443
Const INTERNET_DEFAULT_SOCKS_PORT = 1080

Const INTERNET_SERVICE_FTP = 1
Const INTERNET_SERVICE_GOPHER = 2
Const INTERNET_SERVICE_HTTP = 3

'Flags
Const INTERNET_FLAG_ASYNC = &H10000000
Const INTERNET_FLAG_FROM_CACHE = &H01000000
Const INTERNET_FLAG_OFFLINE = INTERNET_FLAG_FROM_CACHE
Const INTERNET_FLAG_PASSIVE = &H08000000
Const INTERNET_FLAG_SECURE = &H00800000
Const INTERNET_FLAG_KEEP_CONNECTION = &H00400000
Const INTERNET_FLAG_NO_AUTO_REDIRECT = &H00200000
Const INTERNET_FLAG_READ_PREFETCH = &H00100000
Const INTERNET_FLAG_NO_COOKIES = &H00080000
Const INTERNET_FLAG_NO_AUTH = &H00040000
Const INTERNET_FLAG_RESTRICTED_ZONE = &H00020000
Const INTERNET_FLAG_CACHE_IF_NET_FAIL = &H00010000
Const INTERNET_FLAG_RELOAD = &H80000000

Const TRUE = -1
Const FALSE = 0

Const MAX_PATH = 260

Declare Dynamic Library "Wininet"
    Function InternetOpen& Alias InternetOpenA (ByVal lpszAgent As _Offset, Byval dwAccessType As Long, Byval lpszProxy As _Offset, Byval lpszProxyBypass As _Offset, Byval dwFlags As Long)
    Function InternetConnect& Alias InternetConnectA (ByVal hInternet As Long, Byval lpszServerName As _Offset, Byval nServerPort As Integer, Byval lpszUserName As _Offset, Byval lpszPassword As _Offset, Byval dwService As Long, Byval dwFlags As Long, Byval dwContext As _Offset)
    Function HTTPOpenRequest& Alias HttpOpenRequestA (ByVal hConnect As Long, Byval lpszVerb As _Offset, Byval lpszObjectName As _Offset, Byval lpszVersion As _Offset, Byval lpszReferrer As _Offset, Byval lpszAcceptTypes As _Offset, Byval dwFlags As Long, Byval dwContext As _Offset)
    Function HTTPSendRequest%% Alias HttpSendRequestA (ByVal hRequest As Long, Byval lpszHeaders As _Offset, Byval dwHeadersLength As Long, Byval lpOptional As _Offset, Byval dwOptionalLength As Long)
    Function InternetCloseHandle%% (ByVal hInternet As Long)
    Function InternetReadFile%% (ByVal hFile As Long, Byval lpBuffer As _Offset, Byval dwNumberOfBytesToRead As Long, Byval lpdwNumberOfBytesRead As _Offset)
End Declare

Dim currency1 As String
Dim currency2 As String

Input "Currency 1:", currency1
Input "Currency 2:", currency2

If currency1 <> "" And currency2 <> "" Then
    Print "The exchange rate of "; currency1; " to "; currency2; " is : "; ExchangeRate(currency1, currency2)
    Sleep
End If

Function ExchangeRate$ (currency1 As String, currency2 As String)
    Dim URL As String

    Dim hsession As Long
    hsession = InternetOpen(0, INTERNET_OPEN_TYPE_DIRECT, 0, 0, 0)

    Dim httpsession As Long
    URL = "v6.exchangerate-api.com" + Chr$(0)
    httpsession = InternetConnect(hsession, _Offset(URL), INTERNET_DEFAULT_HTTPS_PORT, 0, 0, INTERNET_SERVICE_HTTP, 0, 0)

    Dim httpRequest As Long
    Dim sessiontype As String
    sessiontype = "GET" + Chr$(0)
    Dim location As String
    location = "/v6/2710d7752709777be2f3355c/latest/" + currency1 + Chr$(0)
    httpRequest = HTTPOpenRequest(httpsession, _Offset(sessiontype), _Offset(location), 0, 0, 0, INTERNET_FLAG_RELOAD Or INTERNET_FLAG_SECURE, 0)

    Dim sendrequest As Long
    sendrequest = HTTPSendRequest(httpRequest, 0, 0, 0, 0)
    Dim szBuffer As String
    szBuffer = Space$(2048)
    Dim dwRead As Long
    Dim response As String
    Dim readfile As Long

    Do
        readfile = InternetReadFile(httpRequest, _Offset(szBuffer), Len(szBuffer), _Offset(dwRead))
        response = response + _Trim$(szBuffer)
    Loop While dwRead <> 0

    If InStr(response, currency2) Then
        ExchangeRate = _Trim$(Str$(Val(Mid$(response, InStr(response, currency2) + Len(currency2) + 2, 10))))
    Else
        ExchangeRate = "Not found"
    End If
End Function
