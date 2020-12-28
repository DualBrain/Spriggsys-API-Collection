OPTION _EXPLICIT
$CONSOLE:ONLY
_DEST _CONSOLE

'Constants/Flags
CONST LOCALE_CUSTOM_DEFAULT = &H0C00
CONST LOCALE_CUSTOM_UI_DEFAULT = &H1400
CONST LOCALE_CUSTOM_UNSPECIFIED = &H1000
CONST LOCALE_INVARIANT = &H007F
CONST LOCALE_SYSTEM_DEFAULT = &H0800
CONST LOCALE_USER_DEFAULT = &H0400
CONST LOCALE_ILZERO = &H00000012

CONST DATE_AUTOLAYOUT = &H00000040
CONST DATE_LONGDATE = &H00000002
CONST DATE_LTRREADING = &H00000010
CONST DATE_RTLREADING = &H00000020
CONST DATE_SHORTDATE = &H00000001
CONST DATE_USE_ALT_CALENDAR = &H00000004
CONST DATE_YEARMONTH = &H00000008
CONST DATE_MONTHDAY = DATE_YEARMONTH OR DATE_SHORTDATE OR DATE_LONGDATE

DECLARE DYNAMIC LIBRARY "Kernel32"
    FUNCTION GetCurrencyFormat% ALIAS GetCurrencyFormatA (BYVAL locale AS LONG, BYVAL dwFlags AS LONG, BYVAL lpValue AS _OFFSET, BYVAL lpFormat AS _OFFSET, BYVAL lpCurrencyStr AS _OFFSET, BYVAL cchCurrency AS INTEGER)
    FUNCTION GetDateFormat% ALIAS GetDateFormatA (BYVAL locale AS LONG, BYVAL dwFlags AS LONG, BYVAL lpDate AS _OFFSET, BYVAL lpFormat AS _OFFSET, BYVAL lpDateStr AS _OFFSET, BYVAL cchDate AS INTEGER)
END DECLARE

PRINT Currency("123456789")
PRINT

PRINT FormatDate("MM*dd*yyyy")
PRINT

PRINT GetDateType(DATE_LONGDATE)
PRINT

SLEEP

FUNCTION Currency$ (money AS STRING)
    DIM moolah AS STRING
    money = money + CHR$(0)
    moolah = SPACE$(30)
    DIM a AS INTEGER
    a = GetCurrencyFormat(LOCALE_USER_DEFAULT, 0, _OFFSET(money), 0, _OFFSET(moolah), LEN(moolah))
    IF a THEN
        moolah = _TRIM$(moolah)
        Currency = moolah
    END IF
END FUNCTION

FUNCTION FormatDate$ (template AS STRING)
    DIM formatteddate AS STRING
    template = template + CHR$(0)
    formatteddate = SPACE$(60)
    DIM a AS INTEGER
    a = GetDateFormat(LOCALE_USER_DEFAULT, 0, 0, _OFFSET(template), _OFFSET(formatteddate), LEN(formatteddate))
    IF a THEN
        formatteddate = _TRIM$(formatteddate)
        FormatDate = formatteddate
    END IF
END FUNCTION

FUNCTION GetDateType$ (flag AS LONG)
    DIM formatteddate AS STRING
    formatteddate = SPACE$(60)
    DIM a AS INTEGER
    a = GetDateFormat(LOCALE_USER_DEFAULT, flag, 0, 0, _OFFSET(formatteddate), LEN(formatteddate))
    IF a THEN
        formatteddate = _TRIM$(formatteddate)
        GetDateType = formatteddate
    END IF
END FUNCTION
