Option _Explicit

Type OPENASINFO
    pcszFile As _Offset
    pcszClass As _Offset
    oaifInFlags As Long
End Type

Declare Dynamic Library "Shell32"
    Function SHOpenWithDialog%& (ByVal hwndParent As Long, poainfo As OPENASINFO)
End Declare

Declare Dynamic Library "Kernel32"
    Function WideCharToMultiByte% (ByVal CodePage As _Unsigned Long, Byval dwFlags As Long, Byval lpWideCharStr As _Offset, Byval cchWideChar As Integer, Byval lpMultiByteStr As _Offset, Byval cbMultiByte As Integer, Byval lpDefaultChar As _Offset, Byval lpUsedDefaultChar As _Offset)
    Function MultiByteToWideChar% (ByVal CodePage As _Unsigned Long, Byval dwFlags As Long, Byval lpMultiByteStr As _Offset, Byval cbMultiByte As Integer, Byval lpWideCharStr As _Offset, Byval cchWideChar As Integer)
End Declare

Dim openas As OPENASINFO
Dim file As String
file = "C:\Users\Zachary\Desktop\QB64 x64\bin2c.bas"
file = ANSIToUnicode(file)
openas.pcszFile = _Offset(file)
openas.pcszClass = 0
openas.oaifInFlags = &H00000004
Print Len(openas)
'Print file

Print SHOpenWithDialog(0, openas)

Function UnicodeToANSI$ (buffer As String)
    Dim ansibuffer As String
    ansibuffer = Space$(Len(buffer))
    Dim a As Integer
    a = WideCharToMultiByte(437, 0, _Offset(buffer), Len(buffer), _Offset(ansibuffer), Len(ansibuffer), 0, 0)
    UnicodeToANSI = Mid$(ansibuffer, 1, InStr(ansibuffer, Chr$(0)) - 1)
End Function

Function ANSIToUnicode$ (buffer As String)
    Dim unicodebuffer As String
    unicodebuffer = Space$(Len(buffer) * 2)
    Dim a As Integer
    a = MultiByteToWideChar(65001, 0, _Offset(buffer), Len(buffer), _Offset(unicodebuffer), Len(unicodebuffer))
    ANSIToUnicode = unicodebuffer
End Function
