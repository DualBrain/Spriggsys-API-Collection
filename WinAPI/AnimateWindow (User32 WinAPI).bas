CONST AW_ACTIVATE = &H00020000
CONST AW_BLEND = &H00080000
CONST AW_CENTER = &H00000010
CONST AW_HIDE = &H00010000
CONST AW_HOR_POSITIVE = &H00000001
CONST AW_HOR_NEGATIVE = &H00000002
CONST AW_SLIDE = &H00040000
CONST AW_VER_POSITIVE = &H00000004
CONST AW_VER_NEGATIVE = &H00000008

DECLARE DYNAMIC LIBRARY "User32"
    FUNCTION AnimateWindow%% (BYVAL hwnd AS LONG, BYVAL Time AS LONG, BYVAL Flags AS LONG)
END DECLARE

_DELAY 1
PRINT FadeOut(1000)

_DELAY 1
PRINT FadeIn(1000)

_DELAY 1
PRINT WipeLeftOut(1000)

_DELAY 1
PRINT WipeRightIn(1000)

_DELAY 1
PRINT WipeRightOut(1000)

_DELAY 1
PRINT WipeLeftIn(1000)

_DELAY 1
PRINT WipeDownOut(1000)

_DELAY 1
PRINT WipeUpIn(1000)

_DELAY 1
PRINT WipeUpOut(1000)

_DELAY 1
PRINT WipeDownIn(1000)

_DELAY 1
PRINT WipeCenterOut(1000)

_DELAY 1
PRINT WipeCenterIn(1000)

_DELAY 1
SYSTEM



FUNCTION FadeOut%% (time AS LONG) 'Doesn't stop the program. Only hides it
    FadeOut = AnimateWindow(_WINDOWHANDLE, time, AW_BLEND OR AW_HIDE)
END FUNCTION

FUNCTION FadeIn%% (time AS LONG) 'Only use after a function that hides the window
    FadeIn = AnimateWindow(_WINDOWHANDLE, time, AW_BLEND OR AW_ACTIVATE)
END FUNCTION

FUNCTION WipeLeftOut%% (time AS LONG) 'Doesn't stop the program. Only hides it
    WipeLeftOut = AnimateWindow(_WINDOWHANDLE, time, AW_SLIDE OR AW_HOR_NEGATIVE OR AW_HIDE)
END FUNCTION

FUNCTION WipeRightOut%% (time AS LONG) 'Doesn't stop the program. Only hides it
    WipeRightOut = AnimateWindow(_WINDOWHANDLE, time, AW_SLIDE OR AW_HOR_POSITIVE OR AW_HIDE)
END FUNCTION

FUNCTION WipeLeftIn%% (time AS LONG)
    WipeLeftIn = AnimateWindow(_WINDOWHANDLE, time, AW_SLIDE OR AW_HOR_NEGATIVE OR AW_ACTIVATE)
END FUNCTION

FUNCTION WipeRightIn%% (time AS LONG)
    WipeRightIn = AnimateWindow(_WINDOWHANDLE, time, AW_SLIDE OR AW_HOR_POSITIVE OR AW_ACTIVATE)
END FUNCTION

FUNCTION WipeUpOut%% (time AS LONG) 'Doesn't stop the program. Only hides it
    WipeUpOut = AnimateWindow(_WINDOWHANDLE, time, AW_SLIDE OR AW_VER_POSITIVE OR AW_HIDE)
END FUNCTION

FUNCTION WipeDownOut%% (time AS LONG) 'Doesn't stop the program. Only hides it
    WipeDownOut = AnimateWindow(_WINDOWHANDLE, time, AW_SLIDE OR AW_VER_NEGATIVE OR AW_HIDE)
END FUNCTION

FUNCTION WipeUpIn%% (time AS LONG)
    WipeUpIn = AnimateWindow(_WINDOWHANDLE, time, AW_SLIDE OR AW_VER_POSITIVE OR AW_ACTIVATE)
END FUNCTION

FUNCTION WipeDownIn%% (time AS LONG)
    WipeDownIn = AnimateWindow(_WINDOWHANDLE, time, AW_SLIDE OR AW_VER_NEGATIVE OR AW_ACTIVATE)
END FUNCTION

FUNCTION WipeCenterOut%% (time AS LONG) 'Doesn't stop the program. Only hides it
    WipeCenterOut = AnimateWindow(_WINDOWHANDLE, time, AW_SLIDE OR AW_CENTER OR AW_HIDE)
END FUNCTION

FUNCTION WipeCenterIn%% (time AS LONG) 'Doesn't stop the program. Only hides it
    WipeCenterIn = AnimateWindow(_WINDOWHANDLE, time, AW_SLIDE OR AW_CENTER OR AW_ACTIVATE)
END FUNCTION
