_TITLE ":This is a test of the ShellAboutA function in Shell32!"


DECLARE DYNAMIC LIBRARY "Shell32"
    FUNCTION About% ALIAS ShellAboutA (BYVAL hwnd AS _INTEGER64, BYVAL szApp AS _OFFSET, BYVAL szOtherStuff AS _OFFSET, BYVAL hIcon AS LONG)
END DECLARE

DIM a AS INTEGER
a = ShowAbout(_TITLE$, "This is a test of the about page. Rock on!")

FUNCTION ShowAbout% (title AS STRING, content AS STRING)
    DIM hwnd AS _INTEGER64
    hwnd = _WINDOWHANDLE
    title = title + CHR$(0)
    content = content + CHR$(0)
    ShowAbout = About(hwnd, _OFFSET(title), _OFFSET(content), 0)
END FUNCTION
