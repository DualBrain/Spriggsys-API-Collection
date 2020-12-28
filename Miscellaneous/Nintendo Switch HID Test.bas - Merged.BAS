OPTION _EXPLICIT
DIM SHARED HomeBT AS LONG
DIM SHARED CaptureBT AS LONG
DIM SHARED NintendoSwitchHIDTest AS LONG
DIM SHARED UpBT AS LONG
DIM SHARED DownBT AS LONG
DIM SHARED RightBT AS LONG
DIM SHARED LeftBT AS LONG
DIM SHARED LBumperBT AS LONG
DIM SHARED RBumperBT AS LONG
DIM SHARED MinusBT AS LONG
DIM SHARED PlusBT AS LONG
DIM SHARED YBT AS LONG
DIM SHARED XBT AS LONG
DIM SHARED BBT AS LONG
DIM SHARED ABT AS LONG
DIM SHARED LeftStickX AS LONG
DIM SHARED RightStickX AS LONG
DIM SHARED LeftStickBT AS LONG
DIM SHARED RightStickBT AS LONG
DIM SHARED LeftStickY AS LONG
DIM SHARED RightStickY AS LONG
DIM SHARED LeftStickXLB AS LONG
DIM SHARED RightStickXLB AS LONG
DIM SHARED LeftStickYLB AS LONG
DIM SHARED RightStickYLB AS LONG
DIM SHARED LeftTriggerBT AS LONG
DIM SHARED RightTriggerBT AS LONG
CONST NINTENDO_PRO_VID = &H0002057E
CONST NINTENDO_PRO_PID = &H2009
CONST LEFT_BUMPER = &H10
CONST RIGHT_BUMPER = &H20
CONST LEFT_TRIGGER = &H40
CONST RIGHT_TRIGGER = &H80
CONST X_BUTTON = &H8
CONST A_BUTTON = &H2
CONST B_BUTTON = &H1
CONST Y_BUTTON = &H4
CONST PLUS_BUTTON = &H2
CONST MINUS_BUTTON = &H1
CONST L_STICK_BTN = &H4
CONST R_STICK_BTN = &H8
CONST HOME_BUTTON = &H10
CONST CAPTURE_BUTTON = &H20
CONST MAX_STR = 255
DIM SHARED init AS INTEGER
DIM SHARED handle AS _OFFSET
DECLARE DYNAMIC LIBRARY "hidapi"
    FUNCTION hid_init% ()
    FUNCTION hid_open%& (BYVAL vendor_id AS _UNSIGNED INTEGER, BYVAL product_id AS _UNSIGNED INTEGER, BYVAL serial_number AS _OFFSET)
    FUNCTION hid_get_serial_number_string% (BYVAL device AS _OFFSET, BYVAL buffer AS _OFFSET, BYVAL maxlen AS _INTEGER64)
    FUNCTION hid_write% (BYVAL device AS _OFFSET, BYVAL datas AS _OFFSET, BYVAL length AS _INTEGER64)
    FUNCTION hid_read% (BYVAL device AS _OFFSET, BYVAL datas AS _OFFSET, BYVAL length AS _INTEGER64)
    SUB hid_close (BYVAL device AS _OFFSET)
    FUNCTION hid_exit% ()
END DECLARE
DECLARE DYNAMIC LIBRARY "Kernel32"
    FUNCTION WideCharToMultiByte% (BYVAL CodePage AS _UNSIGNED INTEGER, BYVAL dwFlags AS LONG, BYVAL lpWideCharStr AS _OFFSET, BYVAL cchWideChar AS INTEGER, BYVAL lpMultiByteStr AS _OFFSET, BYVAL cbMultiByte AS INTEGER, BYVAL lpDefaultChar AS _OFFSET, BYVAL lpUsedDefaultChar AS _OFFSET)
END DECLARE
DECLARE LIBRARY
    FUNCTION __UI_GetPID ALIAS getpid ()
END DECLARE
DECLARE CUSTOMTYPE LIBRARY
    SUB __UI_MemCopy ALIAS memcpy (BYVAL dest AS _OFFSET, BYVAL source AS _OFFSET, BYVAL bytes AS LONG)
END DECLARE
DECLARE LIBRARY "falcon"
    SUB uprint_extra (BYVAL x&, BYVAL y&, BYVAL chars%&, BYVAL length%&, BYVAL kern&, BYVAL do_render&, txt_width&, BYVAL charpos%&, charcount&, BYVAL colour~&, BYVAL max_width&)
    FUNCTION uprint (BYVAL x&, BYVAL y&, chars$, BYVAL txt_len&, BYVAL colour~&, BYVAL max_width&)
    FUNCTION uprintwidth (chars$, BYVAL txt_len&, BYVAL max_width&)
    FUNCTION uheight& ()
    FUNCTION falcon_uspacing& ALIAS uspacing ()
    FUNCTION uascension& ()
END DECLARE
$IF WIN THEN
    DECLARE LIBRARY
        FUNCTION __UI_MB& ALIAS MessageBox (BYVAL ignore&, message$, title$, BYVAL type&)
        FUNCTION GetSystemMetrics& (BYVAL WhichMetric&)
    END DECLARE
    CONST __UI_SM_SWAPBUTTON = 23
$ELSE
    DECLARE LIBRARY ""
    FUNCTION __UI_MB& ALIAS MessageBox (BYVAL ignore&, message$, title$, BYVAL type&)
    END DECLARE
$END IF
$SCREENHIDE
_CONTROLCHR OFF
TYPE __UI_ControlTYPE
    ID AS LONG
    ParentID AS LONG
    PreviousParentID AS LONG
    ContextMenuID AS LONG
    Type AS INTEGER
    Name AS STRING * 40
    ParentName AS STRING * 40
    SubMenu AS _BYTE
    MenuPanelID AS LONG
    SourceControl AS LONG
    Top AS INTEGER
    Left AS INTEGER
    Width AS INTEGER
    Height AS INTEGER
    Canvas AS LONG
    HelperCanvas AS LONG
    TransparentColor AS _UNSIGNED LONG
    Stretch AS _BYTE
    PreviousStretch AS _BYTE
    Font AS INTEGER
    PreviousFont AS INTEGER
    BackColor AS _UNSIGNED LONG
    ForeColor AS _UNSIGNED LONG
    SelectedForeColor AS _UNSIGNED LONG
    SelectedBackColor AS _UNSIGNED LONG
    BackStyle AS _BYTE
    HasBorder AS _BYTE
    BorderSize AS INTEGER
    Padding AS INTEGER
    Encoding AS LONG
    Align AS _BYTE
    PrevAlign AS _BYTE
    VAlign AS _BYTE
    PrevVAlign AS _BYTE
    BorderColor AS _UNSIGNED LONG
    Value AS _FLOAT
    PreviousValue AS _FLOAT
    Min AS _FLOAT
    PrevMin AS _FLOAT
    Max AS _FLOAT
    PrevMax AS _FLOAT
    Interval AS _FLOAT
    PrevInterval AS _FLOAT
    MinInterval AS _FLOAT
    PrevMinInterval AS _FLOAT
    HotKey AS INTEGER
    HotKeyOffset AS INTEGER
    HotKeyPosition AS INTEGER
    ShowPercentage AS _BYTE
    AutoScroll AS _BYTE
    AutoSize AS _BYTE
    InputViewStart AS LONG
    PreviousInputViewStart AS LONG
    LastVisibleItem AS INTEGER
    ItemHeight AS INTEGER
    HasVScrollbar AS _BYTE
    VScrollbarButton2Top AS INTEGER
    HoveringVScrollbarButton AS _BYTE
    ThumbHeight AS INTEGER
    ThumbTop AS INTEGER
    VScrollbarRatio AS SINGLE
    Cursor AS LONG
    PasswordField AS _BYTE
    PrevCursor AS LONG
    FieldArea AS LONG
    PreviousFieldArea AS LONG
    TextIsSelected AS _BYTE
    BypassSelectOnFocus AS _BYTE
    Multiline AS _BYTE
    NumericOnly AS _BYTE
    FirstVisibleLine AS LONG
    PrevFirstVisibleLine AS LONG
    CurrentLine AS LONG
    PrevCurrentLine AS LONG
    VisibleCursor AS LONG
    PrevVisibleCursor AS LONG
    ControlIsSelected AS _BYTE
    LeftOffsetFromFirstSelected AS INTEGER
    TopOffsetFromFirstSelected AS INTEGER
    SelectionLength AS LONG
    SelectionStart AS LONG
    WordWrap AS _BYTE
    CanResize AS _BYTE
    CanHaveFocus AS _BYTE
    Disabled AS _BYTE
    Hidden AS _BYTE
    PreviouslyHidden AS _BYTE
    CenteredWindow AS _BYTE
    ControlState AS _BYTE
    ChildrenRedrawn AS _BYTE
    FocusState AS LONG
    LastChange AS SINGLE
    Redraw AS _BYTE
    BulletStyle AS _BYTE
    MenuItemGroup AS INTEGER
    KeyCombo AS LONG
    BoundTo AS LONG
    BoundProperty AS LONG
END TYPE
TYPE __UI_Types
    Name AS STRING * 16
    Count AS LONG
    TurnsInto AS INTEGER
    DefaultHeight AS INTEGER
    MinimumHeight AS INTEGER
    DefaultWidth AS INTEGER
    MinimumWidth AS INTEGER
    RestrictResize AS _BYTE
END TYPE
TYPE __UI_ThemeImagesType
    FileName AS STRING * 32
    Handle AS LONG
END TYPE
TYPE __UI_WordWrapHistoryType
    StringSlot AS LONG
    Width AS INTEGER
    LongestLine AS INTEGER
    Font AS LONG
    TotalLines AS INTEGER
END TYPE
TYPE __UI_KeyCombos
    Combo AS STRING * 14 '         "CTRL+SHIFT+F12"
    FriendlyCombo AS STRING * 14 ' "Ctrl+Shift+F12"
    ControlID AS LONG
END TYPE
REDIM SHARED Caption(0 TO 100) AS STRING
REDIM SHARED __UI_TempCaptions(0 TO 100) AS STRING
REDIM SHARED Text(0 TO 100) AS STRING
REDIM SHARED __UI_TempTexts(0 TO 100) AS STRING
REDIM SHARED Mask(0 TO 100) AS STRING
REDIM SHARED __UI_TempMask(0 TO 100) AS STRING
REDIM SHARED ToolTip(0 TO 100) AS STRING
REDIM SHARED __UI_TempTips(0 TO 100) AS STRING
REDIM SHARED Control(0 TO 100) AS __UI_ControlTYPE
REDIM SHARED ControlDrawOrder(0) AS LONG
REDIM SHARED __UI_ThemeImages(0 TO 100) AS __UI_ThemeImagesType
REDIM SHARED __UI_WordWrapHistoryTexts(0 TO 100) AS STRING
REDIM SHARED __UI_WordWrapHistoryResults(0 TO 100) AS STRING
REDIM SHARED __UI_WordWrapHistory(0 TO 100) AS __UI_WordWrapHistoryType
REDIM SHARED __UI_ThisLineChars(0) AS LONG, __UI_FocusedTextBoxChars(0) AS LONG
REDIM SHARED __UI_ActiveMenu(0 TO 100) AS LONG, __UI_ParentMenu(0 TO 100) AS LONG
REDIM SHARED __UI_KeyCombo(0 TO 100) AS __UI_KeyCombos
DIM SHARED __UI_TotalKeyCombos AS LONG, __UI_BypassKeyCombos AS _BYTE
DIM SHARED table1252$(0 TO 255), table437$(0 TO 255)
DIM SHARED __UI_MouseLeft AS INTEGER, __UI_MouseTop AS INTEGER
DIM SHARED __UI_MouseWheel AS INTEGER, __UI_MouseButtonsSwap AS _BYTE
DIM SHARED __UI_PrevMouseLeft AS INTEGER, __UI_PrevMouseTop AS INTEGER
DIM SHARED __UI_MouseButton1 AS _BYTE, __UI_MouseButton2 AS _BYTE
DIM SHARED __UI_MouseIsDown AS _BYTE, __UI_MouseDownOnID AS LONG
DIM SHARED __UI_Mouse2IsDown AS _BYTE, __UI_Mouse2DownOnID AS LONG
DIM SHARED __UI_PreviousMouseDownOnID AS LONG
DIM SHARED __UI_KeyIsDown AS _BYTE, __UI_KeyDownOnID AS LONG
DIM SHARED __UI_ShiftIsDown AS _BYTE, __UI_CtrlIsDown AS _BYTE
DIM SHARED __UI_AltIsDown AS _BYTE, __UI_ShowHotKeys AS _BYTE, __UI_AltCombo$
DIM SHARED __UI_LastMouseClick AS SINGLE, __UI_MouseDownOnScrollbar AS SINGLE
DIM SHARED __UI_DragX AS INTEGER, __UI_DragY AS INTEGER
DIM SHARED __UI_DefaultButtonID AS LONG
DIM SHARED __UI_KeyHit AS LONG, __UI_KeepFocus AS _BYTE
DIM SHARED __UI_Focus AS LONG, __UI_PreviousFocus AS LONG, __UI_KeyboardFocus AS _BYTE
DIM SHARED __UI_HoveringID AS LONG, __UI_LastHoveringID AS LONG, __UI_BelowHoveringID AS LONG
DIM SHARED __UI_IsDragging AS _BYTE, __UI_DraggingID AS LONG
DIM SHARED __UI_IsResizing AS _BYTE, __UI_ResizingID AS LONG
DIM SHARED __UI_ResizeHandleHover AS _BYTE
DIM SHARED __UI_IsSelectingText AS _BYTE, __UI_IsSelectingTextOnID AS LONG
DIM SHARED __UI_SelectedText AS STRING, __UI_SelectionLength AS LONG
DIM SHARED __UI_StateHasChanged AS _BYTE
DIM SHARED __UI_DraggingThumb AS _BYTE, __UI_ThumbDragTop AS INTEGER
DIM SHARED __UI_DraggingThumbOnID AS LONG
DIM SHARED __UI_HasInput AS _BYTE, __UI_ProcessInputTimer AS SINGLE
DIM SHARED __UI_UnloadSignal AS _BYTE, __UI_HasResized AS _BYTE
DIM SHARED __UI_ExitTriggered AS _BYTE
DIM SHARED __UI_Loaded AS _BYTE
DIM SHARED __UI_EventsTimer AS INTEGER, __UI_RefreshTimer AS INTEGER
DIM SHARED __UI_ActiveDropdownList AS LONG, __UI_ParentDropdownList AS LONG
DIM SHARED __UI_TotalActiveMenus AS LONG, __UI_ActiveMenuIsContextMenu AS _BYTE
DIM SHARED __UI_SubMenuDelay AS SINGLE, __UI_HoveringSubMenu AS _BYTE
DIM SHARED __UI_TopMenuBarItem AS LONG
DIM SHARED __UI_ActiveTipID AS LONG, __UI_TipTimer AS SINGLE, __UI_PreviousTipID AS LONG
DIM SHARED __UI_ActiveTipTop AS INTEGER, __UI_ActiveTipLeft AS INTEGER
DIM SHARED __UI_FormID AS LONG, __UI_HasMenuBar AS LONG
DIM SHARED __UI_ScrollbarWidth AS INTEGER, __UI_ScrollbarButtonHeight AS INTEGER
DIM SHARED __UI_MenuBarOffset AS INTEGER, __UI_MenuItemOffset AS INTEGER
DIM SHARED __UI_NewMenuBarTextLeft AS INTEGER, __UI_DefaultCaptionIndent AS INTEGER
DIM SHARED __UI_ForceRedraw AS _BYTE, __UI_AutoRefresh AS _BYTE
DIM SHARED __UI_CurrentTitle AS STRING
DIM SHARED __UI_DesignMode AS _BYTE, __UI_FirstSelectedID AS LONG
DIM SHARED __UI_WaitMessage AS STRING, __UI_TotalSelectedControls AS LONG
DIM SHARED __UI_WaitMessageHandle AS LONG, __UI_EditorMode AS _BYTE
DIM SHARED __UI_LastRenderedLineWidth AS LONG, __UI_LastRenderedCharCount AS LONG
DIM SHARED __UI_SelectionRectangleTop AS INTEGER, __UI_SelectionRectangleLeft AS INTEGER
DIM SHARED __UI_SelectionRectangle AS _BYTE
DIM SHARED __UI_CantShowContextMenu AS _BYTE, __UI_ShowPositionAndSize AS _BYTE
DIM SHARED __UI_ShowInvisibleControls AS _BYTE, __UI_Snapped AS _BYTE
DIM SHARED __UI_SnappedByProximityX AS _BYTE, __UI_SnappedByProximityY AS _BYTE
DIM SHARED __UI_SnappedX AS INTEGER, __UI_SnappedY AS INTEGER
DIM SHARED __UI_SnappedXID AS LONG, __UI_SnappedYID AS LONG
DIM SHARED __UI_SnapLines AS _BYTE, __UI_SnapDistance AS INTEGER, __UI_SnapDistanceFromForm AS INTEGER
DIM SHARED __UI_FrameRate AS SINGLE, __UI_Font8Offset AS INTEGER, __UI_Font16Offset AS INTEGER
DIM SHARED __UI_ClipboardCheck$, __UI_MenuBarOffsetV AS INTEGER
DIM SHARED __UI_KeepScreenHidden AS _BYTE, __UI_MaxBorderSize AS INTEGER
DIM SHARED __UI_InternalContextMenus AS LONG, __UI_DidClick AS _BYTE
DIM SHARED __UI_ContextMenuSourceID AS LONG
DIM SHARED __UI_FKey(1 TO 12) AS LONG
DIM SHARED __UI_Type(0 TO 18) AS __UI_Types
__UI_Type(__UI_Type_Form).Name = "Form"
__UI_Type(__UI_Type_Frame).Name = "Frame"
__UI_Type(__UI_Type_Frame).DefaultWidth = 230
__UI_Type(__UI_Type_Frame).DefaultHeight = 150
__UI_Type(__UI_Type_Button).Name = "Button"
__UI_Type(__UI_Type_Button).DefaultWidth = 80
__UI_Type(__UI_Type_Button).DefaultHeight = 23
__UI_Type(__UI_Type_Label).Name = "Label"
__UI_Type(__UI_Type_Label).DefaultWidth = 150
__UI_Type(__UI_Type_Label).DefaultHeight = 23
__UI_Type(__UI_Type_CheckBox).Name = "CheckBox"
__UI_Type(__UI_Type_CheckBox).DefaultWidth = 150
__UI_Type(__UI_Type_CheckBox).DefaultHeight = 23
__UI_Type(__UI_Type_CheckBox).TurnsInto = __UI_Type_ToggleSwitch
__UI_Type(__UI_Type_RadioButton).Name = "RadioButton"
__UI_Type(__UI_Type_RadioButton).DefaultWidth = 150
__UI_Type(__UI_Type_RadioButton).DefaultHeight = 23
__UI_Type(__UI_Type_TextBox).Name = "TextBox"
__UI_Type(__UI_Type_TextBox).DefaultWidth = 120
__UI_Type(__UI_Type_TextBox).DefaultHeight = 23
__UI_Type(__UI_Type_ProgressBar).Name = "ProgressBar"
__UI_Type(__UI_Type_ProgressBar).DefaultWidth = 300
__UI_Type(__UI_Type_ProgressBar).DefaultHeight = 23
__UI_Type(__UI_Type_ListBox).Name = "ListBox"
__UI_Type(__UI_Type_ListBox).DefaultWidth = 200
__UI_Type(__UI_Type_ListBox).DefaultHeight = 200
__UI_Type(__UI_Type_ListBox).TurnsInto = __UI_Type_DropdownList
__UI_Type(__UI_Type_DropdownList).Name = "DropdownList"
__UI_Type(__UI_Type_DropdownList).DefaultWidth = 200
__UI_Type(__UI_Type_DropdownList).DefaultHeight = 23
__UI_Type(__UI_Type_DropdownList).TurnsInto = __UI_Type_ListBox
__UI_Type(__UI_Type_MenuBar).Name = "MenuBar"
__UI_Type(__UI_Type_MenuBar).TurnsInto = __UI_Type_ContextMenu
__UI_Type(__UI_Type_MenuBar).RestrictResize = __UI_CantResizeV
__UI_Type(__UI_Type_MenuItem).Name = "MenuItem"
__UI_Type(__UI_Type_MenuItem).RestrictResize = __UI_CantResizeV
__UI_Type(__UI_Type_MenuPanel).Name = "MenuPanel"
__UI_Type(__UI_Type_PictureBox).Name = "PictureBox"
__UI_Type(__UI_Type_PictureBox).DefaultWidth = 230
__UI_Type(__UI_Type_PictureBox).DefaultHeight = 150
__UI_Type(__UI_Type_TrackBar).Name = "TrackBar"
__UI_Type(__UI_Type_TrackBar).DefaultWidth = 300
__UI_Type(__UI_Type_TrackBar).DefaultHeight = 40
__UI_Type(__UI_Type_TrackBar).MinimumHeight = 30
__UI_Type(__UI_Type_TrackBar).RestrictResize = __UI_CantResizeV
__UI_Type(__UI_Type_ContextMenu).Name = "ContextMenu"
__UI_Type(__UI_Type_ContextMenu).TurnsInto = __UI_Type_MenuBar
__UI_Type(__UI_Type_ContextMenu).RestrictResize = __UI_CantResize
__UI_Type(__UI_Type_ContextMenu).DefaultWidth = 22
__UI_Type(__UI_Type_ContextMenu).DefaultHeight = 22
__UI_Type(__UI_Type_Font).Name = "Font"
__UI_Type(__UI_Type_ToggleSwitch).Name = "ToggleSwitch"
__UI_Type(__UI_Type_ToggleSwitch).DefaultWidth = 40
__UI_Type(__UI_Type_ToggleSwitch).DefaultHeight = 17
__UI_Type(__UI_Type_ToggleSwitch).TurnsInto = __UI_Type_CheckBox
__UI_Type(__UI_Type_ToggleSwitch).RestrictResize = __UI_CantResize
__UI_RestoreFKeys
CONST True = -1, False = 0
__UI_SubMenuDelay = .4
__UI_SnapDistance = 5
__UI_SnapDistanceFromForm = 10
__UI_MaxBorderSize = 10
__UI_Font8Offset = 5
__UI_Font16Offset = 3
__UI_ClipboardCheck$ = "InForm" + STRING$(2, 10) + "BEGIN CONTROL DATA" + CHR$(10) + STRING$(60, 45) + CHR$(10)
__UI_ThemeSetup
__UI_InternalMenus
__UI_LoadForm
__UI_Init
DO
    _LIMIT 1
LOOP
SYSTEM
__UI_ErrorHandler:
RESUME NEXT
FUNCTION __UI_Type_Form%%:__UI_Type_Form%% = 1: END FUNCTION
FUNCTION __UI_Type_Frame%%: __UI_Type_Frame%% = 2: END FUNCTION
FUNCTION __UI_Type_Button%%: __UI_Type_Button%% = 3: END FUNCTION
FUNCTION __UI_Type_Label%%: __UI_Type_Label%% = 4: END FUNCTION
FUNCTION __UI_Type_CheckBox%%: __UI_Type_CheckBox%% = 5: END FUNCTION
FUNCTION __UI_Type_RadioButton%%: __UI_Type_RadioButton%% = 6: END FUNCTION
FUNCTION __UI_Type_TextBox%%: __UI_Type_TextBox%% = 7: END FUNCTION
FUNCTION __UI_Type_ProgressBar%%: __UI_Type_ProgressBar%% = 8: END FUNCTION
FUNCTION __UI_Type_ListBox%%: __UI_Type_ListBox%% = 9: END FUNCTION
FUNCTION __UI_Type_DropdownList%%: __UI_Type_DropdownList%% = 10: END FUNCTION
FUNCTION __UI_Type_MenuBar%%: __UI_Type_MenuBar%% = 11: END FUNCTION
FUNCTION __UI_Type_MenuItem%%: __UI_Type_MenuItem%% = 12: END FUNCTION
FUNCTION __UI_Type_MenuPanel%%: __UI_Type_MenuPanel%% = 13: END FUNCTION
FUNCTION __UI_Type_PictureBox%%: __UI_Type_PictureBox%% = 14: END FUNCTION
FUNCTION __UI_Type_TrackBar%%: __UI_Type_TrackBar%% = 15: END FUNCTION
FUNCTION __UI_Type_ContextMenu%%: __UI_Type_ContextMenu%% = 16: END FUNCTION
FUNCTION __UI_Type_Font%%: __UI_Type_Font%% = 17: END FUNCTION
FUNCTION __UI_Type_ToggleSwitch%%: __UI_Type_ToggleSwitch%% = 18: END FUNCTION
FUNCTION __UI_Opaque%%: __UI_Opaque%% = 0: END FUNCTION
FUNCTION __UI_Transparent%%: __UI_Transparent%% = -1: END FUNCTION
FUNCTION __UI_Left%%: __UI_Left%% = 0: END FUNCTION
FUNCTION __UI_Center%%: __UI_Center%% = 1: END FUNCTION
FUNCTION __UI_Right%%: __UI_Right%% = 2: END FUNCTION
FUNCTION __UI_Top%%: __UI_Top%% = 0: END FUNCTION
FUNCTION __UI_Middle%%: __UI_Middle%% = 1: END FUNCTION
FUNCTION __UI_Bottom%%: __UI_Bottom%% = 2: END FUNCTION
FUNCTION __UI_NumericWithoutBounds%%: __UI_NumericWithoutBounds%% = True: END FUNCTION
FUNCTION __UI_NumericWithBounds%%: __UI_NumericWithBounds%% = 2: END FUNCTION
FUNCTION __UI_CheckMark%%: __UI_CheckMark%% = 0: END FUNCTION
FUNCTION __UI_Bullet%%: __UI_Bullet%% = 1: END FUNCTION
FUNCTION MsgBox_OkOnly%%: MsgBox_OkOnly%% = 0: END FUNCTION
FUNCTION MsgBox_OkCancel%%: MsgBox_OkCancel%% = 1: END FUNCTION
FUNCTION MsgBox_AbortRetryIgnore%%: MsgBox_AbortRetryIgnore%% = 2: END FUNCTION
FUNCTION MsgBox_YesNoCancel%%: MsgBox_YesNoCancel%% = 3: END FUNCTION
FUNCTION MsgBox_YesNo%%: MsgBox_YesNo%% = 4: END FUNCTION
FUNCTION MsgBox_RetryCancel%%: MsgBox_RetryCancel%% = 5: END FUNCTION
FUNCTION MsgBox_CancelTryagainContinue%%: MsgBox_CancelTryagainContinue%% = 6: END FUNCTION
FUNCTION MsgBox_Critical%: MsgBox_Critical% = 16: END FUNCTION
FUNCTION MsgBox_Question%: MsgBox_Question% = 32: END FUNCTION
FUNCTION MsgBox_Exclamation%: MsgBox_Exclamation% = 48: END FUNCTION
FUNCTION MsgBox_Information%: MsgBox_Information% = 64: END FUNCTION
FUNCTION MsgBox_DefaultButton1%: MsgBox_DefaultButton1% = 0: END FUNCTION
FUNCTION MsgBox_DefaultButton2%: MsgBox_DefaultButton2% = 256: END FUNCTION
FUNCTION MsgBox_DefaultButton3%: MsgBox_DefaultButton3% = 512: END FUNCTION
FUNCTION MsgBox_Defaultbutton4%: MsgBox_Defaultbutton4% = 768: END FUNCTION
FUNCTION MsgBox_AppModal%%: MsgBox_AppModal%% = 0: END FUNCTION
FUNCTION MsgBox_SystemModal%: MsgBox_SystemModal% = 4096: END FUNCTION
FUNCTION MsgBox_SetForeground&: MsgBox_SetForeground& = 65536: END FUNCTION
FUNCTION MsgBox_Ok%%: MsgBox_Ok%% = 1: END FUNCTION
FUNCTION MsgBox_Cancel%%: MsgBox_Cancel%% = 2: END FUNCTION
FUNCTION MsgBox_Abort%%: MsgBox_Abort%% = 3: END FUNCTION
FUNCTION MsgBox_Retry%%: MsgBox_Retry%% = 4: END FUNCTION
FUNCTION MsgBox_Ignore%%: MsgBox_Ignore%% = 5: END FUNCTION
FUNCTION MsgBox_Yes%%: MsgBox_Yes%% = 6: END FUNCTION
FUNCTION MsgBox_No%%: MsgBox_No%% = 7: END FUNCTION
FUNCTION MsgBox_Tryagain%%: MsgBox_Tryagain%% = 10: END FUNCTION
FUNCTION MsgBox_Continue%%: MsgBox_Continue%% = 11: END FUNCTION
FUNCTION __UI_ToolTipTimeOut!: __UI_ToolTipTimeOut! = .8: END FUNCTION
FUNCTION __UI_CantResizeV%%: __UI_CantResizeV%% = 1: END FUNCTION
FUNCTION __UI_CantResizeH%%: __UI_CantResizeH%% = 2: END FUNCTION
FUNCTION __UI_CantResize%%: __UI_CantResize%% = 3: END FUNCTION
FUNCTION uspacing&
    uspacing& = uheight + (((_FONT = 8) * -1) * __UI_Font8Offset + ((_FONT = 16) * -1) * __UI_Font16Offset)
END FUNCTION
SUB __UI_InternalMenus
    DIM __UI_NewID AS LONG
    __UI_NewID = __UI_NewControl(__UI_Type_ContextMenu, "__UI_PreviewMenu", 0, 0, 0, 0, 0)
    Control(__UI_NewID).Font = SetFont("segoeui.ttf?arial.ttf?/Library/Fonts/Arial.ttf?InForm/resources/NotoMono-Regular.ttf?cour.ttf", 12)
    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "__UI_PreviewMenuNewMenuBar", 0, 0, 0, 0, __UI_GetID("__UI_PreviewMenu"))
    SetCaption __UI_GetID("__UI_PreviewMenuNewMenuBar"), "New &MenuBar control"
    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "__UI_PreviewMenuNewContextMenu", 0, 0, 0, 0, __UI_GetID("__UI_PreviewMenu"))
    SetCaption __UI_GetID("__UI_PreviewMenuNewContextMenu"), "New ContextMen&u control-"
    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "__UI_PreviewMenuShowInvisibleControls", 0, 0, 0, 0, __UI_GetID("__UI_PreviewMenu"))
    SetCaption __UI_GetID("__UI_PreviewMenuShowInvisibleControls"), "Sho&w invisible controls-"
    ToolTip(__UI_NewID) = "Toogles the display of invisible items (e.g. ContextMenu controls)"
    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "__UI_PreviewMenuSetDefaultButton", 0, 0, 0, 0, __UI_GetID("__UI_PreviewMenu"))
    SetCaption __UI_GetID("__UI_PreviewMenuSetDefaultButton"), "&Set as default button-"
    ToolTip(__UI_NewID) = "The default button can be triggered with Enter even if it doesn't have focus at run time."
    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "__UI_PreviewMenuBindControls", 0, 0, 0, 0, __UI_GetID("__UI_PreviewMenu"))
    SetCaption __UI_GetID("__UI_PreviewMenuBindControls"), "Bind selected controls...-"
    ToolTip(__UI_NewID) = "Binds a control's property to another control's property."
    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "__UI_PreviewMenuConvertType", 0, 0, 0, 0, __UI_GetID("__UI_PreviewMenu"))
    SetCaption __UI_GetID("__UI_PreviewMenuConvertType"), "Co&nvert to type-"
    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "__UI_PreviewMenuImageOriginalSize", 0, 0, 0, 0, __UI_GetID("__UI_PreviewMenu"))
    SetCaption __UI_GetID("__UI_PreviewMenuImageOriginalSize"), "Restore &image dimensions-"
    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "__UI_PreviewMenuNumericOnly", 0, 0, 0, 0, __UI_GetID("__UI_PreviewMenu"))
    SetCaption __UI_GetID("__UI_PreviewMenuNumericOnly"), "Validate .Min/.Ma&x bounds-"
    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "__UI_PreviewMenuAlignLeft", 0, 0, 0, 0, __UI_GetID("__UI_PreviewMenu"))
    SetCaption __UI_GetID("__UI_PreviewMenuAlignLeft"), "Align &Left"
    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "__UI_PreviewMenuAlignRight", 0, 0, 0, 0, __UI_GetID("__UI_PreviewMenu"))
    SetCaption __UI_GetID("__UI_PreviewMenuAlignRight"), "Align &Right"
    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "__UI_PreviewMenuAlignTops", 0, 0, 0, 0, __UI_GetID("__UI_PreviewMenu"))
    SetCaption __UI_GetID("__UI_PreviewMenuAlignTops"), "Align T&op"
    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "__UI_PreviewMenuAlignBottoms", 0, 0, 0, 0, __UI_GetID("__UI_PreviewMenu"))
    SetCaption __UI_GetID("__UI_PreviewMenuAlignBottoms"), "Align &Bottom-"
    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "__UI_PreviewMenuAlignCentersV", 0, 0, 0, 0, __UI_GetID("__UI_PreviewMenu"))
    SetCaption __UI_GetID("__UI_PreviewMenuAlignCentersV"), "Align cent&ers Vertically"
    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "__UI_PreviewMenuAlignCentersH", 0, 0, 0, 0, __UI_GetID("__UI_PreviewMenu"))
    SetCaption __UI_GetID("__UI_PreviewMenuAlignCentersH"), "Ali&gn centers Horizontally"
    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "__UI_PreviewMenuAlignCenterV", 0, 0, 0, 0, __UI_GetID("__UI_PreviewMenu"))
    SetCaption __UI_GetID("__UI_PreviewMenuAlignCenterV"), "Center &Vertically (group)"
    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "__UI_PreviewMenuAlignCenterH", 0, 0, 0, 0, __UI_GetID("__UI_PreviewMenu"))
    SetCaption __UI_GetID("__UI_PreviewMenuAlignCenterH"), "Center &Horizontally (group)-"
    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "__UI_PreviewMenuDistributeV", 0, 0, 0, 0, __UI_GetID("__UI_PreviewMenu"))
    SetCaption __UI_GetID("__UI_PreviewMenuDistributeV"), "Distribute Verticall&y"
    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "__UI_PreviewMenuDistributeH", 0, 0, 0, 0, __UI_GetID("__UI_PreviewMenu"))
    SetCaption __UI_GetID("__UI_PreviewMenuDistributeH"), "Distribute Hori&zontally-"
    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "__UI_PreviewMenuCut", 0, 0, 0, 0, __UI_GetID("__UI_PreviewMenu"))
    SetCaption __UI_GetID("__UI_PreviewMenuCut"), "Cu&t"
    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "__UI_PreviewMenuCopy", 0, 0, 0, 0, __UI_GetID("__UI_PreviewMenu"))
    SetCaption __UI_GetID("__UI_PreviewMenuCopy"), "&Copy"
    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "__UI_PreviewMenuPaste", 0, 0, 0, 0, __UI_GetID("__UI_PreviewMenu"))
    SetCaption __UI_GetID("__UI_PreviewMenuPaste"), "&Paste"
    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "__UI_PreviewMenuDelete", 0, 0, 0, 0, __UI_GetID("__UI_PreviewMenu"))
    SetCaption __UI_GetID("__UI_PreviewMenuDelete"), "&Delete-"
    __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "__UI_PreviewMenuSelect", 0, 0, 0, 0, __UI_GetID("__UI_PreviewMenu"))
    SetCaption __UI_GetID("__UI_PreviewMenuSelect"), "Select &All"
    DIM prevDest AS LONG
    prevDest = _DEST
    Control(__UI_GetID("__UI_PreviewMenuAlignLeft")).HelperCanvas = _NEWIMAGE(48, 16, 32)
    _DEST Control(__UI_GetID("__UI_PreviewMenuAlignLeft")).HelperCanvas
    LINE (0, 0)-(1, 16), _RGB32(105, 105, 105), BF
    LINE (3, 2)-(14, 7), _RGB32(255, 255, 255), BF
    LINE (3, 2)-(14, 7), _RGB32(105, 105, 105), B
    LINE (3, 10)-(10, 14), _RGB32(105, 105, 105), BF
    LINE (16, 0)-STEP(1, 16), _RGB32(255, 255, 255), BF
    LINE (19, 2)-STEP(11, 5), _RGB32(105, 105, 105), BF
    LINE (19, 2)-STEP(11, 5), _RGB32(255, 255, 255), B
    LINE (19, 10)-STEP(7, 4), _RGB32(255, 255, 255), BF
    LINE (32, 0)-STEP(1, 16), Darken(__UI_DefaultColor(__UI_Type_Form, 2), 80), BF
    LINE (35, 2)-STEP(11, 5), Darken(__UI_DefaultColor(__UI_Type_Form, 2), 80), BF
    LINE (35, 2)-STEP(11, 5), Darken(__UI_DefaultColor(__UI_Type_Form, 2), 80), B
    LINE (35, 10)-STEP(7, 4), Darken(__UI_DefaultColor(__UI_Type_Form, 2), 80), BF
    Control(__UI_GetID("__UI_PreviewMenuAlignRight")).HelperCanvas = _NEWIMAGE(48, 16, 32)
    _DEST Control(__UI_GetID("__UI_PreviewMenuAlignRight")).HelperCanvas
    LINE (14, 0)-STEP(1, 16), _RGB32(105, 105, 105), BF
    LINE (1, 2)-STEP(11, 5), _RGB32(255, 255, 255), BF
    LINE (1, 2)-STEP(11, 5), _RGB32(105, 105, 105), B
    LINE (5, 10)-STEP(7, 4), _RGB32(105, 105, 105), BF
    LINE (14 + 16, 0)-STEP(1, 16), _RGB32(255, 255, 255), BF
    LINE (1 + 16, 2)-STEP(11, 5), _RGB32(105, 105, 105), BF
    LINE (1 + 16, 2)-STEP(11, 5), _RGB32(255, 255, 255), B
    LINE (5 + 16, 10)-STEP(7, 4), _RGB32(255, 255, 255), BF
    LINE (14 + 32, 0)-STEP(1, 16), Darken(__UI_DefaultColor(__UI_Type_Form, 2), 80), BF
    LINE (1 + 32, 2)-STEP(11, 5), Darken(__UI_DefaultColor(__UI_Type_Form, 2), 80), BF
    LINE (1 + 32, 2)-STEP(11, 5), Darken(__UI_DefaultColor(__UI_Type_Form, 2), 80), B
    LINE (5 + 32, 10)-STEP(7, 4), Darken(__UI_DefaultColor(__UI_Type_Form, 2), 80), BF
    Control(__UI_GetID("__UI_PreviewMenuAlignTops")).HelperCanvas = _NEWIMAGE(48, 16, 32)
    _DEST Control(__UI_GetID("__UI_PreviewMenuAlignTops")).HelperCanvas
    LINE (0, 0)-STEP(16, 1), _RGB32(105, 105, 105), BF
    LINE (2, 3)-STEP(5, 11), _RGB32(255, 255, 255), BF
    LINE (2, 3)-STEP(4, 11), _RGB32(105, 105, 105), B
    LINE (9, 3)-STEP(4, 7), _RGB32(105, 105, 105), BF
    LINE (0 + 16, 0)-STEP(16, 1), _RGB32(255, 255, 255), BF
    LINE (2 + 16, 3)-STEP(5, 11), _RGB32(105, 105, 105), BF
    LINE (2 + 16, 3)-STEP(4, 11), _RGB32(255, 255, 255), B
    LINE (9 + 16, 3)-STEP(4, 7), _RGB32(255, 255, 255), BF
    LINE (0 + 32, 0)-STEP(16, 1), Darken(__UI_DefaultColor(__UI_Type_Form, 2), 80), BF
    LINE (2 + 32, 3)-STEP(5, 11), Darken(__UI_DefaultColor(__UI_Type_Form, 2), 80), BF
    LINE (2 + 32, 3)-STEP(4, 11), Darken(__UI_DefaultColor(__UI_Type_Form, 2), 80), B
    LINE (9 + 32, 3)-STEP(4, 7), Darken(__UI_DefaultColor(__UI_Type_Form, 2), 80), BF
    Control(__UI_GetID("__UI_PreviewMenuAlignBottoms")).HelperCanvas = _NEWIMAGE(48, 16, 32)
    _DEST Control(__UI_GetID("__UI_PreviewMenuAlignBottoms")).HelperCanvas
    LINE (0, 14)-STEP(16, 1), _RGB32(105, 105, 105), BF
    LINE (2, 1)-STEP(5, 11), _RGB32(255, 255, 255), BF
    LINE (2, 1)-STEP(5, 11), _RGB32(105, 105, 105), B
    LINE (9, 5)-STEP(4, 7), _RGB32(105, 105, 105), BF
    LINE (0 + 16, 14)-STEP(16, 1), _RGB32(255, 255, 255), BF
    LINE (2 + 16, 1)-STEP(5, 11), _RGB32(105, 105, 105), BF
    LINE (2 + 16, 1)-STEP(5, 11), _RGB32(255, 255, 255), B
    LINE (9 + 16, 5)-STEP(4, 7), _RGB32(255, 255, 255), BF
    LINE (0 + 32, 14)-STEP(16, 1), Darken(__UI_DefaultColor(__UI_Type_Form, 2), 80), BF
    LINE (2 + 32, 1)-STEP(5, 11), Darken(__UI_DefaultColor(__UI_Type_Form, 2), 80), BF
    LINE (2 + 32, 1)-STEP(5, 11), Darken(__UI_DefaultColor(__UI_Type_Form, 2), 80), B
    LINE (9 + 32, 5)-STEP(4, 7), Darken(__UI_DefaultColor(__UI_Type_Form, 2), 80), BF
    Control(__UI_GetID("__UI_PreviewMenuAlignCentersV")).HelperCanvas = _NEWIMAGE(48, 16, 32)
    _DEST Control(__UI_GetID("__UI_PreviewMenuAlignCentersV")).HelperCanvas
    LINE (0, 7)-STEP(16, 1), _RGB32(105, 105, 105), BF
    LINE (2, 2)-STEP(5, 11), _RGB32(255, 255, 255), BF
    LINE (2, 2)-STEP(5, 11), _RGB32(105, 105, 105), B
    LINE (9, 4)-STEP(4, 7), _RGB32(105, 105, 105), BF
    LINE (0 + 16, 7)-STEP(16, 1), _RGB32(255, 255, 255), BF
    LINE (2 + 16, 2)-STEP(5, 11), _RGB32(105, 105, 105), BF
    LINE (2 + 16, 2)-STEP(5, 11), _RGB32(255, 255, 255), B
    LINE (9 + 16, 4)-STEP(4, 7), _RGB32(255, 255, 255), BF
    LINE (0 + 32, 7)-STEP(16, 1), Darken(__UI_DefaultColor(__UI_Type_Form, 2), 80), BF
    LINE (2 + 32, 2)-STEP(5, 11), Darken(__UI_DefaultColor(__UI_Type_Form, 2), 80), BF
    LINE (2 + 32, 2)-STEP(5, 11), Darken(__UI_DefaultColor(__UI_Type_Form, 2), 80), B
    LINE (9 + 32, 4)-STEP(4, 7), Darken(__UI_DefaultColor(__UI_Type_Form, 2), 80), BF
    Control(__UI_GetID("__UI_PreviewMenuAlignCentersH")).HelperCanvas = _NEWIMAGE(48, 16, 32)
    _DEST Control(__UI_GetID("__UI_PreviewMenuAlignCentersH")).HelperCanvas
    LINE (7, 0)-STEP(1, 16), _RGB32(105, 105, 105), BF
    LINE (2, 2)-STEP(11, 5), _RGB32(255, 255, 255), BF
    LINE (2, 2)-STEP(11, 5), _RGB32(105, 105, 105), B
    LINE (4, 9)-STEP(7, 4), _RGB32(105, 105, 105), BF
    LINE (7 + 16, 0)-STEP(1, 16), _RGB32(255, 255, 255), BF
    LINE (2 + 16, 2)-STEP(11, 5), _RGB32(105, 105, 105), BF
    LINE (2 + 16, 2)-STEP(11, 5), _RGB32(255, 255, 255), B
    LINE (4 + 16, 9)-STEP(7, 4), _RGB32(255, 255, 255), BF
    LINE (7 + 32, 0)-STEP(1, 16), Darken(__UI_DefaultColor(__UI_Type_Form, 2), 80), BF
    LINE (2 + 32, 2)-STEP(11, 5), Darken(__UI_DefaultColor(__UI_Type_Form, 2), 80), BF
    LINE (2 + 32, 2)-STEP(11, 5), Darken(__UI_DefaultColor(__UI_Type_Form, 2), 80), B
    LINE (4 + 32, 9)-STEP(7, 4), Darken(__UI_DefaultColor(__UI_Type_Form, 2), 80), BF
    _DEST prevDest
END SUB
SUB SetFrameRate(FPS AS _UNSIGNED INTEGER)
    IF FPS >= 30 THEN
        __UI_FrameRate = 1 / FPS
    ELSE
        __UI_FrameRate = 1 / 30
    END IF
    IF __UI_RefreshTimer = 0 THEN
        __UI_RefreshTimer = _FREETIMER
        ON TIMER(__UI_RefreshTimer, __UI_FrameRate) __UI_UpdateDisplay
    ELSE
        TIMER(__UI_RefreshTimer) OFF
        TIMER(__UI_RefreshTimer) FREE
        __UI_RefreshTimer = _FREETIMER
        ON TIMER(__UI_RefreshTimer, __UI_FrameRate) __UI_UpdateDisplay
        TIMER(__UI_RefreshTimer) ON
    END IF
END SUB
SUB SetFocus(id AS LONG)
    IF __UI_Focus = id THEN EXIT SUB
    IF Control(id).CanHaveFocus = False OR Control(id).Hidden = True OR Control(id).Disabled = True THEN EXIT SUB
    __UI_Focus = id
    IF Control(id).Type = __UI_Type_TextBox THEN
        IF Control(id).BypassSelectOnFocus = False THEN
            Control(id).TextIsSelected = True
            Control(id).SelectionStart = 0
            Control(id).Cursor = LEN(Text(id))
        END IF
    END IF
END SUB
SUB __UI_Init
    DIM i AS LONG, b$
    SetFrameRate 30
    __UI_BeforeInit
    IF __UI_KeepScreenHidden = False THEN _SCREENSHOW
    IF __UI_FormID = 0 THEN SYSTEM
    SCREEN _NEWIMAGE(Control(__UI_FormID).Width, Control(__UI_FormID).Height, 32)
    COLOR Control(__UI_FormID).ForeColor, Control(__UI_FormID).BackColor
    IF Control(__UI_FormID).Font > 0 THEN _FONT Control(__UI_FormID).Font
    b$ = "Initializing..."
    GOSUB ShowMessage
    _ICON
    _TITLE "InForm"
    IF Control(__UI_FormID).CenteredWindow THEN _SCREENMOVE _MIDDLE
    IF Control(__UI_FormID).Font = 0 THEN Control(__UI_FormID).Font = SetFont("", 8)
    IF Caption(__UI_FormID) = "" THEN Caption(__UI_FormID) = RTRIM$(Control(__UI_FormID).Name)
    IF NOT __UI_DesignMode THEN
        DIM __UI_NewID AS LONG
        __UI_NewID = __UI_NewControl(__UI_Type_ContextMenu, "__UI_TextFieldMenu", 0, 0, 0, 0, 0)
        FOR i = 1 TO UBOUND(Control)
            IF Control(i).Type = __UI_Type_TextBox AND Control(i).ContextMenuID = 0 THEN
                Control(i).ContextMenuID = __UI_NewID
            END IF
        NEXT
        __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "__UI_TextMenuCut", 0, 0, 0, 0, __UI_GetID("__UI_TextFieldMenu"))
        SetCaption __UI_GetID("__UI_TextMenuCut"), "Cu&t"
        __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "__UI_TextMenuCopy", 0, 0, 0, 0, __UI_GetID("__UI_TextFieldMenu"))
        SetCaption __UI_GetID("__UI_TextMenuCopy"), "&Copy"
        __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "__UI_TextMenuPaste", 0, 0, 0, 0, __UI_GetID("__UI_TextFieldMenu"))
        SetCaption __UI_GetID("__UI_TextMenuPaste"), "&Paste"
        __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "__UI_TextMenuDelete", 0, 0, 0, 0, __UI_GetID("__UI_TextFieldMenu"))
        SetCaption __UI_GetID("__UI_TextMenuDelete"), "&Delete-"
        __UI_NewID = __UI_NewControl(__UI_Type_MenuItem, "__UI_TextMenuSelect", 0, 0, 0, 0, __UI_GetID("__UI_TextFieldMenu"))
        SetCaption __UI_GetID("__UI_TextMenuSelect"), "Select &all"
    END IF
    _DISPLAYORDER _SOFTWARE, _HARDWARE
    _DISPLAY
    __UI_AssignIDs
    __UI_OnLoad
    __UI_EventsTimer = _FREETIMER
    ON TIMER(__UI_EventsTimer, .008) __UI_DoEvents
    TIMER(__UI_EventsTimer) ON
    TIMER(__UI_RefreshTimer) ON
    __UI_AutoRefresh = True
    __UI_Loaded = True
    EXIT SUB
    ShowMessage:
    CLS
    __UI_PrintString _WIDTH / 2 - _PRINTWIDTH(b$) / 2, _HEIGHT / 2 - _FONTHEIGHT / 2, b$
    _DISPLAY
    RETURN
END SUB
FUNCTION __UI_GetProperMouseButton%%(Which%%)
        $IF WIN THEN
        IF GetSystemMetrics(__UI_SM_SWAPBUTTON) = 0 THEN
            __UI_GetProperMouseButton%% = _MOUSEBUTTON(Which%%)
        ELSE
            IF Which%% = 1 THEN
                __UI_GetProperMouseButton%% = _MOUSEBUTTON(2)
            ELSEIF Which%% = 2 THEN
                __UI_GetProperMouseButton%% = _MOUSEBUTTON(1)
            END IF
        END IF
        __UI_MouseButtonsSwap = False
        $ELSE
            IF __UI_MouseButtonsSwap THEN
                IF Which%% = 1 THEN
                    __UI_GetProperMouseButton%% = _MOUSEBUTTON(2)
                ELSEIF Which%% = 2 THEN
                    __UI_GetProperMouseButton%% = _MOUSEBUTTON(1)
                END IF
            ELSE
                __UI_GetProperMouseButton%% = _MOUSEBUTTON(Which%%)
            END IF
        $END IF
END FUNCTION
SUB __UI_ProcessInput
    DIM OldScreen&, i AS LONG, j AS LONG
    DIM ContainerOffsetTop AS INTEGER, ContainerOffsetLeft AS INTEGER
    STATIC __UI_CurrentResizeStatus AS _BYTE, __UI_CurrentBackColor AS _UNSIGNED LONG
    __UI_HasInput = False
    __UI_ExitTriggered = _EXIT
    IF __UI_ExitTriggered AND 1 THEN __UI_ExitTriggered = True: __UI_HasInput = True
    IF _SCREENX = -32000 AND _SCREENY = -32000 THEN
        EXIT SUB
    END IF
    __UI_MouseWheel = 0
    IF __UI_MouseIsDown THEN __UI_HasInput = True
    IF _MOUSEINPUT THEN
        __UI_HasInput = True
        __UI_MouseWheel = __UI_MouseWheel + _MOUSEWHEEL
        IF __UI_GetProperMouseButton%%(1) = __UI_MouseButton1 AND __UI_GetProperMouseButton%%(2) = __UI_MouseButton2 THEN
            DO WHILE _MOUSEINPUT
                __UI_MouseWheel = __UI_MouseWheel + _MOUSEWHEEL
                IF NOT (__UI_GetProperMouseButton%%(1) = __UI_MouseButton1 AND __UI_GetProperMouseButton%%(2) = __UI_MouseButton2) THEN EXIT DO
            LOOP
        END IF
        __UI_MouseButton1 = __UI_GetProperMouseButton%%(1)
        __UI_MouseButton2 = __UI_GetProperMouseButton%%(2)
        __UI_MouseLeft = _MOUSEX
        __UI_MouseTop = _MOUSEY
    END IF
    IF __UI_PrevMouseLeft <> __UI_MouseLeft OR __UI_PrevMouseTop <> __UI_MouseTop OR __UI_DidClick OR __UI_HoveringSubMenu THEN
        __UI_PrevMouseLeft = __UI_MouseLeft
        __UI_PrevMouseTop = __UI_MouseTop
        __UI_DidClick = False
        DIM TempHover AS LONG
        __UI_BelowHoveringID = 0
        FOR i = 1 TO UBOUND(Control)
            IF Control(i).ID > 0 AND Control(i).Type <> __UI_Type_MenuItem AND ((Control(i).Hidden = False AND __UI_DesignMode = False) OR (__UI_DesignMode = True)) THEN
                IF Control(i).Type = __UI_Type_ContextMenu AND __UI_DesignMode AND __UI_ShowInvisibleControls = False THEN _CONTINUE
                IF Control(i).Hidden = True AND __UI_ShowInvisibleControls = False THEN _CONTINUE
                Control(i).HoveringVScrollbarButton = 0
                IF Control(i).ParentID > 0 THEN
                    IF Control(Control(i).ParentID).Hidden = True THEN _CONTINUE
                    ContainerOffsetTop = Control(Control(i).ParentID).Top
                    ContainerOffsetLeft = Control(Control(i).ParentID).Left
                    IF __UI_MouseLeft >= ContainerOffsetLeft AND __UI_MouseLeft <= ContainerOffsetLeft + Control(Control(i).ParentID).Width - 1 AND __UI_MouseTop >= ContainerOffsetTop AND __UI_MouseTop <= ContainerOffsetTop + Control(Control(i).ParentID).Height - 1 THEN
                        IF __UI_MouseLeft >= ContainerOffsetLeft + Control(i).Left AND __UI_MouseLeft <= ContainerOffsetLeft + Control(i).Left + Control(i).Width - 1 AND __UI_MouseTop >= ContainerOffsetTop + Control(i).Top AND __UI_MouseTop <= ContainerOffsetTop + Control(i).Top + Control(i).Height - 1 THEN
                            __UI_BelowHoveringID = TempHover
                            TempHover = Control(i).ID
                            IF Control(i).HasVScrollbar AND __UI_IsDragging = False THEN
                                IF __UI_MouseLeft >= ContainerOffsetLeft + Control(i).Left + Control(i).Width - __UI_ScrollbarWidth THEN
                                    IF __UI_MouseTop <= Control(i).Top + ContainerOffsetTop + __UI_ScrollbarButtonHeight AND __UI_DraggingThumb = False THEN
                                        Control(i).HoveringVScrollbarButton = 1
                                        Control(i).PreviousInputViewStart = 0
                                    ELSEIF __UI_MouseTop >= Control(i).Top + ContainerOffsetTop + Control(i).Height - __UI_ScrollbarButtonHeight AND __UI_DraggingThumb = False THEN
                                        Control(i).HoveringVScrollbarButton = 2
                                        Control(i).PreviousInputViewStart = 0
                                    ELSEIF __UI_MouseTop >= ContainerOffsetTop + Control(i).ThumbTop AND __UI_MouseTop <= ContainerOffsetTop + Control(i).ThumbTop + Control(i).ThumbHeight THEN
                                        Control(i).HoveringVScrollbarButton = 3
                                        Control(i).PreviousInputViewStart = 0
                                    ELSE
                                        IF __UI_MouseTop < ContainerOffsetTop + Control(i).ThumbTop THEN
                                            Control(i).HoveringVScrollbarButton = 4
                                        ELSE
                                            Control(i).HoveringVScrollbarButton = 5
                                        END IF
                                        Control(i).PreviousInputViewStart = 0
                                    END IF
                                END IF
                            END IF
                        END IF
                    END IF
                ELSE
                    ContainerOffsetTop = 0
                    ContainerOffsetLeft = 0
                    IF __UI_MouseLeft >= Control(i).Left AND __UI_MouseLeft <= Control(i).Left + Control(i).Width - 1 AND __UI_MouseTop >= Control(i).Top AND __UI_MouseTop <= Control(i).Top + Control(i).Height - 1 THEN
                        __UI_BelowHoveringID = TempHover
                        TempHover = Control(i).ID
                        IF Control(i).Type = __UI_Type_ContextMenu AND __UI_DesignMode THEN
                            EXIT FOR
                        END IF
                        IF Control(i).HasVScrollbar AND __UI_IsDragging = False THEN
                            IF __UI_MouseLeft >= ContainerOffsetLeft + Control(i).Left + Control(i).Width - __UI_ScrollbarWidth THEN
                                IF __UI_MouseTop <= Control(i).Top + ContainerOffsetTop + __UI_ScrollbarButtonHeight AND __UI_DraggingThumb = False THEN
                                    Control(i).HoveringVScrollbarButton = 1
                                    Control(i).PreviousInputViewStart = 0
                                ELSEIF __UI_MouseTop >= Control(i).Top + ContainerOffsetTop + Control(i).Height - __UI_ScrollbarButtonHeight AND __UI_DraggingThumb = False THEN
                                    Control(i).HoveringVScrollbarButton = 2
                                    Control(i).PreviousInputViewStart = 0
                                ELSEIF __UI_MouseTop >= ContainerOffsetTop + Control(i).ThumbTop AND __UI_MouseTop <= ContainerOffsetTop + Control(i).ThumbTop + Control(i).ThumbHeight THEN
                                    Control(i).HoveringVScrollbarButton = 3
                                    Control(i).PreviousInputViewStart = 0
                                ELSE
                                    IF __UI_MouseTop < ContainerOffsetTop + Control(i).ThumbTop THEN
                                        Control(i).HoveringVScrollbarButton = 4
                                        Control(i).PreviousInputViewStart = 0
                                    ELSE
                                        Control(i).HoveringVScrollbarButton = 5
                                        Control(i).PreviousInputViewStart = 0
                                    END IF
                                END IF
                            END IF
                        END IF
                    END IF
                END IF
            END IF
        NEXT
        IF Control(TempHover).Type = __UI_Type_MenuPanel THEN
            DIM ParentMenu AS LONG
            FOR i = __UI_TotalActiveMenus TO 1 STEP -1
                IF __UI_ActiveMenu(i) = TempHover THEN
                    ParentMenu = __UI_ParentMenu(i)
                    EXIT FOR
                END IF
            NEXT
            _FONT Control(TempHover).Font
            FOR i = 1 TO UBOUND(Control)
                IF Control(i).ParentID = ParentMenu AND Control(i).Hidden = False THEN
                    IF __UI_MouseTop >= Control(TempHover).Top + Control(i).Top AND __UI_MouseTop <= Control(TempHover).Top + Control(i).Top + Control(i).Height - 1 THEN
                        Control(TempHover).Value = __UI_Focus
                        TempHover = Control(i).ID
                        __UI_Focus = Control(i).ID
                        FOR j = __UI_TotalActiveMenus TO 1 STEP -1
                            IF __UI_ParentMenu(j) = Control(i).ID OR __UI_ParentMenu(j) = ParentMenu THEN
                                EXIT FOR
                            ELSE
                                __UI_DestroyControl Control(__UI_ActiveMenu(j))
                            END IF
                        NEXT
                        EXIT FOR 'as no menu items will overlap in a panel
                    END IF
                END IF
            NEXT
        END IF
        __UI_HoveringID = TempHover
        IF Control(__UI_HoveringID).Type = __UI_Type_Frame AND Control(__UI_BelowHoveringID).ParentID = Control(__UI_HoveringID).ID THEN
            SWAP __UI_HoveringID, __UI_BelowHoveringID
        END IF
        IF __UI_DesignMode AND __UI_IsResizing = False AND __UI_IsDragging = False THEN
            __UI_ResizeHandleHover = 0
            IF Control(__UI_HoveringID).ControlIsSelected AND Control(__UI_HoveringID).Type <> __UI_Type_MenuBar AND Control(__UI_HoveringID).Type <> __UI_Type_MenuItem THEN
                IF __UI_MouseLeft >= Control(__UI_HoveringID).Left + Control(Control(__UI_HoveringID).ParentID).Left + Control(__UI_HoveringID).Width - 8 AND __UI_MouseTop >= Control(__UI_HoveringID).Top + Control(Control(__UI_HoveringID).ParentID).Top + Control(__UI_HoveringID).Height / 2 - 4 AND __UI_MouseTop <= Control(__UI_HoveringID).Top + Control(Control(__UI_HoveringID).ParentID).Top + Control(__UI_HoveringID).Height / 2 + 4 THEN
                    IF __UI_Type(Control(__UI_HoveringID).Type).RestrictResize <> __UI_CantResizeH AND __UI_Type(Control(__UI_HoveringID).Type).RestrictResize <> __UI_CantResize THEN
                        __UI_ResizeHandleHover = 1 'Right
                    END IF
                ELSEIF __UI_MouseLeft >= Control(__UI_HoveringID).Left + Control(Control(__UI_HoveringID).ParentID).Left + Control(__UI_HoveringID).Width / 2 - 4 AND __UI_MouseLeft <= Control(__UI_HoveringID).Left + Control(Control(__UI_HoveringID).ParentID).Left + Control(__UI_HoveringID).Width / 2 + 4 AND __UI_MouseTop >= Control(__UI_HoveringID).Top + Control(Control(__UI_HoveringID).ParentID).Top + Control(__UI_HoveringID).Height / 2 - 4 AND __UI_MouseTop >= Control(__UI_HoveringID).Top + Control(Control(__UI_HoveringID).ParentID).Top + Control(__UI_HoveringID).Height - 8 THEN
                    IF __UI_Type(Control(__UI_HoveringID).Type).RestrictResize <> __UI_CantResizeV AND __UI_Type(Control(__UI_HoveringID).Type).RestrictResize <> __UI_CantResize THEN
                        __UI_ResizeHandleHover = 2 'Bottom
                    END IF
                ELSEIF __UI_MouseLeft <= Control(__UI_HoveringID).Left + Control(Control(__UI_HoveringID).ParentID).Left + 8 AND __UI_MouseTop >= Control(__UI_HoveringID).Top + Control(Control(__UI_HoveringID).ParentID).Top + Control(__UI_HoveringID).Height / 2 - 4 AND __UI_MouseTop <= Control(__UI_HoveringID).Top + Control(Control(__UI_HoveringID).ParentID).Top + Control(__UI_HoveringID).Height / 2 + 4 THEN
                    IF __UI_Type(Control(__UI_HoveringID).Type).RestrictResize <> __UI_CantResizeH AND __UI_Type(Control(__UI_HoveringID).Type).RestrictResize <> __UI_CantResize THEN
                        __UI_ResizeHandleHover = 3 'Left
                    END IF
                ELSEIF __UI_MouseLeft >= Control(__UI_HoveringID).Left + Control(Control(__UI_HoveringID).ParentID).Left + Control(__UI_HoveringID).Width / 2 - 4 AND __UI_MouseLeft <= Control(__UI_HoveringID).Left + Control(Control(__UI_HoveringID).ParentID).Left + Control(__UI_HoveringID).Width / 2 + 4 AND __UI_MouseTop <= Control(__UI_HoveringID).Top + Control(Control(__UI_HoveringID).ParentID).Top + 8 THEN
                    IF __UI_Type(Control(__UI_HoveringID).Type).RestrictResize <> __UI_CantResizeV AND __UI_Type(Control(__UI_HoveringID).Type).RestrictResize <> __UI_CantResize THEN
                        __UI_ResizeHandleHover = 4 'Top
                    END IF
                ELSEIF __UI_MouseLeft >= Control(__UI_HoveringID).Left + Control(Control(__UI_HoveringID).ParentID).Left + Control(__UI_HoveringID).Width - 8 AND __UI_MouseTop <= Control(__UI_HoveringID).Top + Control(Control(__UI_HoveringID).ParentID).Top + 8 THEN
                    IF __UI_Type(Control(__UI_HoveringID).Type).RestrictResize = False THEN
                        __UI_ResizeHandleHover = 5 'Top-right
                    END IF
                ELSEIF __UI_MouseLeft <= Control(__UI_HoveringID).Left + Control(Control(__UI_HoveringID).ParentID).Left + 8 AND __UI_MouseTop <= Control(__UI_HoveringID).Top + Control(Control(__UI_HoveringID).ParentID).Top + 8 THEN
                    IF __UI_Type(Control(__UI_HoveringID).Type).RestrictResize = False THEN
                        __UI_ResizeHandleHover = 6 'Top-left
                    END IF
                ELSEIF __UI_MouseLeft >= Control(__UI_HoveringID).Left + Control(Control(__UI_HoveringID).ParentID).Left + Control(__UI_HoveringID).Width - 8 AND __UI_MouseTop >= Control(__UI_HoveringID).Top + Control(Control(__UI_HoveringID).ParentID).Top + Control(__UI_HoveringID).Height - 8 THEN
                    IF __UI_Type(Control(__UI_HoveringID).Type).RestrictResize = False THEN
                        __UI_ResizeHandleHover = 7 'Bottom-right
                    END IF
                ELSEIF __UI_MouseLeft <= Control(__UI_HoveringID).Left + Control(Control(__UI_HoveringID).ParentID).Left + 8 AND __UI_MouseTop >= Control(__UI_HoveringID).Top + Control(Control(__UI_HoveringID).ParentID).Top + Control(__UI_HoveringID).Height - 8 THEN
                    IF __UI_Type(Control(__UI_HoveringID).Type).RestrictResize = False THEN
                        __UI_ResizeHandleHover = 8 'Bottom-left
                    END IF
                END IF
            END IF
        END IF
        IF Control(__UI_Focus).Type = __UI_Type_MenuBar AND Control(__UI_HoveringID).Type = __UI_Type_MenuBar THEN
            IF __UI_TotalActiveMenus = 0 THEN
                __UI_Focus = __UI_HoveringID
            END IF
        ELSEIF __UI_TotalActiveMenus > 0 AND Control(__UI_HoveringID).Type = __UI_Type_MenuBar AND __UI_ActiveMenuIsContextMenu = False AND __UI_DesignMode = False THEN
            IF __UI_ParentMenu(__UI_TotalActiveMenus) <> __UI_HoveringID AND NOT Control(__UI_HoveringID).Disabled THEN
                __UI_CloseAllMenus
                __UI_ActivateMenu Control(__UI_HoveringID), False
                __UI_ForceRedraw = True
            ELSEIF Control(__UI_HoveringID).Disabled THEN
                __UI_CloseAllMenus
                __UI_Focus = __UI_HoveringID
            END IF
        ELSE
            IF __UI_HoveringID <> __UI_LastHoveringID AND Control(__UI_HoveringID).Type = __UI_Type_MenuItem AND Control(__UI_HoveringID).SubMenu AND __UI_DesignMode = False THEN
                Control(__UI_HoveringID).LastChange = TIMER
                __UI_HoveringSubMenu = True
            ELSEIF __UI_HoveringID = __UI_LastHoveringID AND Control(__UI_HoveringID).Type = __UI_Type_MenuItem AND Control(__UI_HoveringID).SubMenu THEN
                IF TIMER - Control(__UI_HoveringID).LastChange >= __UI_SubMenuDelay THEN
                    __UI_ActivateMenu Control(__UI_HoveringID), False
                    __UI_HoveringSubMenu = False
                END IF
            END IF
        END IF
    END IF
    IF __UI_HoveringID <> __UI_LastHoveringID OR __UI_MouseButton1 OR __UI_MouseButton2 THEN
        __UI_TipTimer = TIMER
        __UI_ActiveTipID = 0
    ELSE
        IF __UI_HoveringID <> __UI_ActiveTipID AND __UI_HoveringID > 0 AND NOT __UI_IsDragging THEN
            IF TIMER - __UI_TipTimer >= __UI_ToolTipTimeOut THEN
                IF LEN(ToolTip(__UI_HoveringID)) > 0 THEN
                    __UI_ActiveTipID = __UI_HoveringID
                    __UI_ActiveTipTop = __UI_MouseTop + 16
                    __UI_ActiveTipLeft = __UI_MouseLeft
                END IF
            END IF
        END IF
    END IF
    __UI_KeyHit = _KEYHIT
    IF __UI_KeyHit THEN __UI_HasInput = True
    IF __UI_DesignMode = False THEN
        IF Control(__UI_FormID).CanResize <> __UI_CurrentResizeStatus THEN
            __UI_CurrentResizeStatus = Control(__UI_FormID).CanResize
            IF __UI_CurrentResizeStatus THEN
                _RESIZE ON
            ELSE
                _RESIZE OFF
            END IF
        END IF
    END IF
    DIM CheckResize AS _BYTE
    CheckResize = _RESIZE
    IF (CheckResize AND Control(__UI_FormID).CanResize) OR (CheckResize AND __UI_DesignMode) OR __UI_CurrentBackColor <> Control(__UI_FormID).BackColor OR Control(__UI_FormID).Width <> _WIDTH(0) OR Control(__UI_FormID).Height <> _HEIGHT(0) THEN
        _DELAY .1
        IF CheckResize THEN
            Control(__UI_FormID).Width = _RESIZEWIDTH
            Control(__UI_FormID).Height = _RESIZEHEIGHT
        END IF
        IF Control(__UI_FormID).Width > 0 AND Control(__UI_FormID).Height > 0 THEN
            __UI_CurrentBackColor = Control(__UI_FormID).BackColor
            __UI_HasResized = 2 'Indicate this process is in the middle
            OldScreen& = _DISPLAY
            SCREEN _NEWIMAGE(Control(__UI_FormID).Width, Control(__UI_FormID).Height, 32)
            _FREEIMAGE OldScreen&
            IF Control(__UI_FormID).Canvas <> 0 THEN _FREEIMAGE Control(__UI_FormID).Canvas
            Control(__UI_FormID).Canvas = _NEWIMAGE(Control(__UI_FormID).Width, Control(__UI_FormID).Height, 32)
            _DEST Control(__UI_FormID).Canvas
            COLOR Control(__UI_FormID).ForeColor, Control(__UI_FormID).BackColor
            CLS
            IF __UI_HasMenuBar = True THEN
                _FONT Control(__UI_FormID).Font
                __UI_MenuBarOffsetV = falcon_uspacing& + (((_FONT = 8) * -1) * __UI_Font8Offset + ((_FONT = 16) * -1) * __UI_Font16Offset) + 5 + 2
                LINE (0, __UI_MenuBarOffsetV - 1)-STEP(Control(__UI_FormID).Width - 1, 0), Darken(Control(__UI_FormID).BackColor, 80)
                LINE (0, __UI_MenuBarOffsetV)-STEP(Control(__UI_FormID).Width - 1, 0), Darken(Control(__UI_FormID).BackColor, 120)
                __UI_RefreshMenuBar
            ELSE
                __UI_MenuBarOffsetV = 0
            END IF
            _DEST 0
            IF LEN(__UI_CurrentTitle) THEN _TITLE __UI_CurrentTitle
            __UI_HasResized = True
            __UI_HasInput = True
        END IF
    END IF
    IF __UI_CurrentTitle <> Caption(__UI_FormID) THEN
        __UI_CurrentTitle = Caption(__UI_FormID)
        _TITLE __UI_CurrentTitle
        __UI_HasInput = True
    END IF
    __UI_ProcessInputTimer = TIMER
END SUB
SUB __UI_UpdateDisplay
    STATIC ActiveTipPanel AS LONG
    DIM i AS LONG, TempCaption$, PrevDest AS LONG, TempParentID AS LONG
    DIM OverlayisVisible AS _BYTE, OverlayReset AS _BYTE
    DIM ContainerOffsetLeft AS INTEGER, ContainerOffsetTop AS INTEGER
    DIM ControlState AS _BYTE '1 = Normal; 2 = Hover/focus; 3 = Mouse down; 4 = Disabled;
    IF __UI_AutoRefresh = False THEN EXIT SUB
    __UI_BeforeUpdateDisplay
    IF _SCREENX = -32000 AND _SCREENY = -32000 THEN
        EXIT SUB
    END IF
    ON ERROR GOTO __UI_ErrorHandler
    FOR i = 1 TO UBOUND(Control)
        IF Control(i).Type = __UI_Type_Frame THEN
            Control(i).ParentID = 0 'Enforce no frames inside frames
            Control(i).Value = 0 'Reset children counter
            IF _WIDTH(Control(i).Canvas) <> Control(i).Width OR _HEIGHT(Control(i).Canvas) <> Control(i).Height THEN
                _FREEIMAGE Control(i).Canvas
                Control(i).Canvas = _NEWIMAGE(Control(i).Width, Control(i).Height, 32)
            END IF
            _DEST Control(i).Canvas
            COLOR , Control(i).BackColor
            CLS
        ELSE
            IF Control(i).ParentID > 0 AND Control(i).Type <> __UI_Type_MenuItem THEN
                Control(Control(i).ParentID).Value = Control(Control(i).ParentID).Value + 1
            END IF
        END IF
    NEXT
    _DEST 0
    IF __UI_ForceRedraw THEN 'Restore main window hardware bg
        _FREEIMAGE Control(__UI_FormID).Canvas
        Control(__UI_FormID).Canvas = _NEWIMAGE(Control(__UI_FormID).Width, Control(__UI_FormID).Height, 32)
        _DEST Control(__UI_FormID).Canvas
        COLOR Control(__UI_FormID).ForeColor, Control(__UI_FormID).BackColor
        CLS
        IF __UI_HasMenuBar THEN
            _FONT Control(__UI_FormID).Font
            __UI_MenuBarOffsetV = falcon_uspacing& + (((_FONT = 8) * -1) * __UI_Font8Offset + ((_FONT = 16) * -1) * __UI_Font16Offset) + 5 + 2
            LINE (0, falcon_uspacing& + (((_FONT = 8) * -1) * __UI_Font8Offset + ((_FONT = 16) * -1) * __UI_Font16Offset) + 5 + 1)-STEP(Control(__UI_FormID).Width - 1, 0), Darken(Control(__UI_FormID).BackColor, 80)
            LINE (0, falcon_uspacing& + (((_FONT = 8) * -1) * __UI_Font8Offset + ((_FONT = 16) * -1) * __UI_Font16Offset) + 5 + 2)-STEP(Control(__UI_FormID).Width - 1, 0), Darken(Control(__UI_FormID).BackColor, 120)
        ELSE
            __UI_MenuBarOffsetV = 0
        END IF
        _DEST 0
    END IF
    DIM iCount AS LONG
    FOR iCount = 1 TO UBOUND(ControlDrawOrder)
        i = ControlDrawOrder(iCount)
        IF Control(i).ID > 0 THEN
            IF Control(i).ParentID > 0 AND Control(i).Type <> __UI_Type_MenuItem THEN
                _DEST Control(Control(i).ParentID).Canvas
            ELSE
                _DEST 0
            END IF
            IF i = __UI_FirstSelectedID AND Control(i).BoundTo > 0 AND __UI_DesignMode = True AND __UI_ShowInvisibleControls = True THEN
                LINE (Control(i).Left - 5 + Control(Control(i).ParentID).Left, _
                      Control(i).Top - 5 + Control(Control(i).ParentID).Top)- _
                      STEP(Control(i).Width + 10, Control(i).Height + 10), _
                      _RGB32(127, 105, 183, 50), BF
                LINE (Control(Control(i).BoundTo).Left - 5 + Control(Control(Control(i).BoundTo).ParentID).Left, _
                      Control(Control(i).BoundTo).Top - 5 + Control(Control(Control(i).BoundTo).ParentID).Top)- _
                      STEP(Control(Control(i).BoundTo).Width + 10, Control(Control(i).BoundTo).Height + 10), _
                      _RGB32(127, 105, 183, 50), BF
            END IF
            IF Control(i).Hidden = True AND __UI_DesignMode = True AND __UI_ShowInvisibleControls = True THEN
                LINE (Control(i).Left, Control(i).Top)-STEP(Control(i).Width - 1, Control(i).Height - 1), _RGBA32(127, 127, 127, 80), BF
                _FONT 8
                _PRINTMODE _KEEPBACKGROUND
                COLOR _RGBA32(0, 0, 0, 150)
                _PRINTSTRING (Control(i).Left + 1, Control(i).Top + 1), RTRIM$(Control(i).Name)
                _PRINTSTRING (Control(i).Left + 1, Control(i).Top + 1 + falcon_uspacing&), "(hidden)"
                GOTO BypassDisplay
            ELSEIF Control(i).Hidden = True THEN
                GOTO BypassDisplay
            END IF
            IF ((__UI_MouseIsDown AND i = __UI_MouseDownOnID) OR (__UI_KeyIsDown AND i = __UI_KeyDownOnID AND __UI_KeyDownOnID = __UI_Focus)) AND NOT Control(i).Disabled THEN
                ControlState = 3
            ELSEIF (i = __UI_HoveringID AND Control(i).Type = __UI_Type_MenuBar) THEN
                ControlState = 2
            ELSEIF (i = __UI_HoveringID AND Control(i).Type <> __UI_Type_MenuBar AND NOT Control(i).Disabled) THEN
                ControlState = 2
            ELSEIF Control(i).Disabled THEN
                ControlState = 4
            ELSE
                ControlState = 1
            END IF
            SELECT CASE Control(i).Type
                CASE __UI_Type_Form
                    IF __UI_HasResized <> 2 THEN
                        IF Control(i).Canvas < -1 THEN _PUTIMAGE (0, 0), Control(i).Canvas, 0
                    ELSE
                        PAINT (0, 0), Control(i).BackColor
                    END IF
                CASE __UI_Type_Button
                    __UI_DrawButton Control(i), ControlState
                CASE __UI_Type_Label
                    AutoSizeLabel Control(i)
                    __UI_DrawLabel Control(i), ControlState
                CASE __UI_Type_RadioButton
                    __UI_DrawRadioButton Control(i), ControlState
                CASE __UI_Type_CheckBox
                    __UI_StateHasChanged = False
                    __UI_DrawCheckBox Control(i), ControlState
                    IF __UI_StateHasChanged THEN __UI_ValueChanged i
                CASE __UI_Type_ProgressBar
                    __UI_DrawProgressBar Control(i), ControlState
                CASE __UI_Type_TrackBar
                    Control(i).Value = _ROUND(Control(i).Value)
                    Control(i).Interval = _ROUND(Control(i).Interval)
                    Control(i).MinInterval = _ROUND(Control(i).MinInterval)
                    __UI_StateHasChanged = False
                    __UI_DrawTrackBar Control(i), ControlState
                    IF __UI_StateHasChanged THEN
                        __UI_ValueChanged i
                    END IF
                CASE __UI_Type_TextBox
                    IF __UI_EditorMode = False AND Control(i).NumericOnly = __UI_NumericWithBounds AND __UI_Focus <> i THEN
                        __UI_ValidateBounds i
                        IF Text(i) <> LTRIM$(STR$(Control(i).Value)) THEN
                            Text(i) = LTRIM$(STR$(Control(i).Value))
                        END IF
                    END IF
                    DIM ss1 AS LONG, ss2 AS LONG
                    __UI_FillSelectedText ss1, ss2
                    __UI_StateHasChanged = False
                    __UI_DrawTextBox Control(i), ControlState
                    IF __UI_StateHasChanged THEN
                        __UI_TextChanged i
                        IF Control(i).NumericOnly THEN
                            Control(i).Value = VAL(Text(i))
                            __UI_ValidateBounds i
                        END IF
                    END IF
                CASE __UI_Type_ListBox
                    IF Control(i).InputViewStart <= 0 THEN Control(i).InputViewStart = 1
                    __UI_StateHasChanged = False
                    __UI_DrawListBox Control(i), ControlState
                    IF __UI_StateHasChanged THEN __UI_ValueChanged i
                CASE __UI_Type_DropdownList
                    __UI_StateHasChanged = False
                    __UI_DrawDropdownList Control(i), ControlState
                    IF __UI_StateHasChanged THEN __UI_ValueChanged i
                CASE __UI_Type_MenuBar
                    __UI_DrawMenuBar Control(i), ControlState
                CASE __UI_Type_PictureBox
                    __UI_DrawPictureBox Control(i), ControlState
                CASE __UI_Type_ToggleSwitch
                    __UI_StateHasChanged = False
                    __UI_DrawToggleSwitch Control(i), ControlState
                    IF __UI_StateHasChanged THEN __UI_ValueChanged i
            END SELECT
        END IF
        BypassDisplay:
        IF __UI_Snapped THEN
            IF OverlayReset = False THEN
                OverlayReset = True
                IF Control(__UI_FormID).HelperCanvas <> 0 THEN _FREEIMAGE Control(__UI_FormID).HelperCanvas
                Control(__UI_FormID).HelperCanvas = _NEWIMAGE(Control(__UI_FormID).Width, Control(__UI_FormID).Height, 32)
                _DEST Control(__UI_FormID).HelperCanvas
                CLS , _RGBA32(0, 0, 0, 0)
            ELSE
                _DEST Control(__UI_FormID).HelperCanvas
            END IF
            OverlayisVisible = True
            IF __UI_Snapped THEN
                DIM X1 AS INTEGER, X2 AS INTEGER
                DIM Y1 AS INTEGER, Y2 AS INTEGER
                ContainerOffsetLeft = Control(Control(__UI_DraggingID).ParentID).Left
                ContainerOffsetTop = Control(Control(__UI_DraggingID).ParentID).Top
                IF __UI_SnappedY >= 0 AND __UI_SnappedByProximityY = 0 THEN
                    X1 = 0
                    X2 = _WIDTH
                    LINE (X1, __UI_SnappedY)-STEP(X2, 0), Control(__UI_FormID).SelectedBackColor
                ELSEIF __UI_SnappedY >= 0 AND __UI_SnappedByProximityY > 0 THEN
                    SELECT CASE __UI_SnappedByProximityY
                        CASE 1 'bottom of dragged control to top of snapped control
                            X1 = Control(__UI_DraggingID).Left + Control(__UI_DraggingID).Width / 2
                            IF X1 < Control(__UI_SnappedXID).Left + 1 THEN X1 = Control(__UI_SnappedXID).Left + 1
                            IF X1 > Control(__UI_SnappedXID).Left + Control(__UI_SnappedXID).Width - 1 THEN X1 = Control(__UI_SnappedXID).Left + Control(__UI_SnappedXID).Width - 1
                            Y1 = Control(__UI_DraggingID).Top + Control(__UI_DraggingID).Height
                            FOR X1 = X1 - 1 TO X1 + 1
                                LINE (X1 + ContainerOffsetLeft, Y1 + ContainerOffsetTop)-STEP(0, __UI_SnapDistance), Control(__UI_FormID).SelectedBackColor
                            NEXT
                        CASE 2 'top of dragged control to bottom of snapped control
                            X1 = Control(__UI_DraggingID).Left + Control(__UI_DraggingID).Width / 2
                            IF X1 < Control(__UI_SnappedXID).Left + 1 THEN X1 = Control(__UI_SnappedXID).Left + 1
                            IF X1 > Control(__UI_SnappedXID).Left + Control(__UI_SnappedXID).Width - 1 THEN X1 = Control(__UI_SnappedXID).Left + Control(__UI_SnappedXID).Width - 1
                            Y1 = Control(__UI_DraggingID).Top
                            FOR X1 = X1 - 1 TO X1 + 1
                                LINE (X1 + ContainerOffsetLeft, Y1 + ContainerOffsetTop)-STEP(0, -__UI_SnapDistance), Control(__UI_FormID).SelectedBackColor
                            NEXT
                        CASE 3 'snapped to top of form
                            X1 = Control(__UI_DraggingID).Left + Control(__UI_DraggingID).Width / 2
                            IF X1 < 1 THEN X1 = 1
                            IF X1 > Control(__UI_FormID).Width - 2 THEN X1 = Control(__UI_FormID).Width - 2
                            Y1 = Control(__UI_DraggingID).Top
                            FOR X1 = X1 - 1 TO X1 + 1
                                LINE (X1 + ContainerOffsetLeft, Y1 + ContainerOffsetTop)-STEP(0, -__UI_SnapDistanceFromForm), Control(__UI_FormID).SelectedBackColor
                            NEXT
                        CASE 4 'snapped to bottom of form
                            X1 = Control(__UI_DraggingID).Left + Control(__UI_DraggingID).Width / 2
                            IF X1 < 1 THEN X1 = 1
                            IF X1 > Control(__UI_FormID).Width - 2 THEN X1 = Control(__UI_FormID).Width - 2
                            Y1 = Control(__UI_DraggingID).Top + Control(__UI_DraggingID).Height
                            FOR X1 = X1 - 1 TO X1 + 1
                                LINE (X1 + ContainerOffsetLeft, Y1 + ContainerOffsetTop)-STEP(0, __UI_SnapDistanceFromForm), Control(__UI_FormID).SelectedBackColor
                            NEXT
                    END SELECT
                END IF
                IF __UI_SnappedX >= 0 AND __UI_SnappedByProximityX = 0 THEN
                    Y1 = 0
                    Y2 = _HEIGHT
                    LINE (__UI_SnappedX, Y1)-STEP(0, Y2), Control(__UI_FormID).SelectedBackColor
                ELSEIF __UI_SnappedX >= 0 AND __UI_SnappedByProximityX > 0 THEN
                    SELECT CASE __UI_SnappedByProximityX
                        CASE 1 'left of dragged control to right of snapped control
                            X1 = Control(__UI_SnappedXID).Left + Control(__UI_SnappedXID).Width
                            Y1 = Control(__UI_DraggingID).Top + Control(__UI_DraggingID).Height / 2
                            IF Y1 < Control(__UI_SnappedXID).Top + 1 THEN Y1 = Control(__UI_SnappedXID).Top + 1
                            IF Y1 > Control(__UI_SnappedXID).Top + Control(__UI_SnappedXID).Height - 1 THEN Y1 = Control(__UI_SnappedXID).Top + Control(__UI_SnappedXID).Height - 1
                            FOR Y1 = Y1 - 1 TO Y1 + 1
                                LINE (X1 + ContainerOffsetLeft, Y1 + ContainerOffsetTop)-STEP(__UI_SnapDistance, 0), Control(__UI_FormID).SelectedBackColor
                            NEXT
                        CASE 2 'right of dragged control to left of snapped control
                            X1 = Control(__UI_SnappedXID).Left
                            Y1 = Control(__UI_DraggingID).Top + Control(__UI_DraggingID).Height / 2
                            IF Y1 < Control(__UI_SnappedXID).Top + 1 THEN Y1 = Control(__UI_SnappedXID).Top + 1
                            IF Y1 > Control(__UI_SnappedXID).Top + Control(__UI_SnappedXID).Height - 1 THEN Y1 = Control(__UI_SnappedXID).Top + Control(__UI_SnappedXID).Height - 1
                            FOR Y1 = Y1 - 1 TO Y1 + 1
                                LINE (X1 + ContainerOffsetLeft, Y1 + ContainerOffsetTop)-STEP(-__UI_SnapDistance, 0), Control(__UI_FormID).SelectedBackColor
                            NEXT
                        CASE 3 'snapped to left side of form
                            X1 = Control(__UI_DraggingID).Left
                            Y1 = Control(__UI_DraggingID).Top + Control(__UI_DraggingID).Height / 2
                            IF Y1 < 1 THEN Y1 = 1
                            IF Y1 > Control(__UI_FormID).Height - 2 THEN Y1 = Control(__UI_FormID).Height - 2
                            FOR Y1 = Y1 - 1 TO Y1 + 1
                                LINE (X1 + ContainerOffsetLeft, Y1 + ContainerOffsetTop)-STEP(-__UI_SnapDistanceFromForm, 0), Control(__UI_FormID).SelectedBackColor
                            NEXT
                        CASE 4 'snapped to right side of form
                            X1 = Control(__UI_DraggingID).Left + Control(__UI_DraggingID).Width
                            Y1 = Control(__UI_DraggingID).Top + Control(__UI_DraggingID).Height / 2
                            IF Y1 < 1 THEN Y1 = 1
                            IF Y1 > Control(__UI_FormID).Height - 2 THEN Y1 = Control(__UI_FormID).Height - 2
                            FOR Y1 = Y1 - 1 TO Y1 + 1
                                LINE (X1 + ContainerOffsetLeft, Y1 + ContainerOffsetTop)-STEP(__UI_SnapDistanceFromForm, 0), Control(__UI_FormID).SelectedBackColor
                            NEXT
                    END SELECT
                END IF
            END IF
            _DEST 0
        END IF
        IF Control(i).ControlIsSelected THEN
            IF OverlayReset = False THEN
                OverlayReset = True
                IF Control(__UI_FormID).HelperCanvas <> 0 THEN _FREEIMAGE Control(__UI_FormID).HelperCanvas
                Control(__UI_FormID).HelperCanvas = _NEWIMAGE(Control(__UI_FormID).Width, Control(__UI_FormID).Height, 32)
                _DEST Control(__UI_FormID).HelperCanvas
                CLS , _RGBA32(0, 0, 0, 0)
            ELSE
                _DEST Control(__UI_FormID).HelperCanvas
            END IF
            OverlayisVisible = True
            IF Control(i).Type = __UI_Type_MenuItem THEN
                TempParentID = Control(i).ParentID
                Control(i).ParentID = Control(i).MenuPanelID
                LINE (Control(i).Left + Control(Control(i).ParentID).Left - 2, Control(i).Top + Control(Control(i).ParentID).Top - 2)-STEP(Control(Control(i).ParentID).Width + 3, Control(i).Height + 3), _RGB32(0, 0, 0), B , 21845
            ELSE
                TempParentID = 0
                LINE (Control(i).Left + Control(Control(i).ParentID).Left - 2, Control(i).Top + Control(Control(i).ParentID).Top - 2)-STEP(Control(i).Width + 3, Control(i).Height + 3), _RGB32(0, 0, 0), B , 21845
            END IF
            IF NOT __UI_IsDragging THEN
                IF __UI_Type(Control(i).Type).RestrictResize <> __UI_CantResizeH AND __UI_Type(Control(i).Type).RestrictResize <> __UI_CantResize THEN
                    IF Control(i).Type = __UI_Type_MenuItem THEN
                        LINE (Control(i).Left + Control(Control(i).ParentID).Left + Control(Control(i).ParentID).Width - 8, Control(i).Top + Control(Control(i).ParentID).Top + Control(i).Height / 2 - 4)-STEP(7, 7), _RGB32(255, 255, 255), BF
                        LINE (Control(i).Left + Control(Control(i).ParentID).Left + Control(Control(i).ParentID).Width - 8, Control(i).Top + Control(Control(i).ParentID).Top + Control(i).Height / 2 - 4)-STEP(7, 7), _RGB32(0, 0, 0), B
                    ELSE
                        LINE (Control(i).Left + Control(Control(i).ParentID).Left + Control(i).Width - 8, Control(i).Top + Control(Control(i).ParentID).Top + Control(i).Height / 2 - 4)-STEP(7, 7), _RGB32(255, 255, 255), BF
                        LINE (Control(i).Left + Control(Control(i).ParentID).Left + Control(i).Width - 8, Control(i).Top + Control(Control(i).ParentID).Top + Control(i).Height / 2 - 4)-STEP(7, 7), _RGB32(0, 0, 0), B
                    END IF
                    LINE (Control(i).Left + Control(Control(i).ParentID).Left, Control(i).Top + Control(Control(i).ParentID).Top + Control(i).Height / 2 - 4)-STEP(7, 7), _RGB32(255, 255, 255), BF
                    LINE (Control(i).Left + Control(Control(i).ParentID).Left, Control(i).Top + Control(Control(i).ParentID).Top + Control(i).Height / 2 - 4)-STEP(7, 7), _RGB32(0, 0, 0), B
                END IF
                IF __UI_Type(Control(i).Type).RestrictResize <> __UI_CantResizeV AND __UI_Type(Control(i).Type).RestrictResize <> __UI_CantResize THEN
                    LINE (Control(i).Left + Control(Control(i).ParentID).Left + Control(i).Width / 2 - 4, Control(i).Top + Control(Control(i).ParentID).Top + Control(i).Height - 8)-STEP(7, 7), _RGB32(255, 255, 255), BF
                    LINE (Control(i).Left + Control(Control(i).ParentID).Left + Control(i).Width / 2 - 4, Control(i).Top + Control(Control(i).ParentID).Top + Control(i).Height - 8)-STEP(7, 7), _RGB32(0, 0, 0), B
                    LINE (Control(i).Left + Control(Control(i).ParentID).Left + Control(i).Width / 2 - 4, Control(i).Top + Control(Control(i).ParentID).Top)-STEP(7, 7), _RGB32(255, 255, 255), BF
                    LINE (Control(i).Left + Control(Control(i).ParentID).Left + Control(i).Width / 2 - 4, Control(i).Top + Control(Control(i).ParentID).Top)-STEP(7, 7), _RGB32(0, 0, 0), B
                END IF
                IF __UI_Type(Control(i).Type).RestrictResize = False THEN
                    LINE (Control(i).Left + Control(Control(i).ParentID).Left + Control(i).Width - 8, Control(i).Top + Control(Control(i).ParentID).Top + Control(i).Height - 8)-STEP(7, 7), _RGB32(255, 255, 255), BF
                    LINE (Control(i).Left + Control(Control(i).ParentID).Left + Control(i).Width - 8, Control(i).Top + Control(Control(i).ParentID).Top + Control(i).Height - 8)-STEP(7, 7), _RGB32(0, 0, 0), B
                    LINE (Control(i).Left + Control(Control(i).ParentID).Left, Control(i).Top + Control(Control(i).ParentID).Top + Control(i).Height - 8)-STEP(7, 7), _RGB32(255, 255, 255), BF
                    LINE (Control(i).Left + Control(Control(i).ParentID).Left, Control(i).Top + Control(Control(i).ParentID).Top + Control(i).Height - 8)-STEP(7, 7), _RGB32(0, 0, 0), B
                    LINE (Control(i).Left + Control(Control(i).ParentID).Left + Control(i).Width - 8, Control(i).Top + Control(Control(i).ParentID).Top)-STEP(7, 7), _RGB32(255, 255, 255), BF
                    LINE (Control(i).Left + Control(Control(i).ParentID).Left + Control(i).Width - 8, Control(i).Top + Control(Control(i).ParentID).Top)-STEP(7, 7), _RGB32(0, 0, 0), B
                    LINE (Control(i).Left + Control(Control(i).ParentID).Left, Control(i).Top + Control(Control(i).ParentID).Top)-STEP(7, 7), _RGB32(255, 255, 255), BF
                    LINE (Control(i).Left + Control(Control(i).ParentID).Left, Control(i).Top + Control(Control(i).ParentID).Top)-STEP(7, 7), _RGB32(0, 0, 0), B
                END IF
            END IF
            IF TempParentID > 0 THEN Control(i).ParentID = TempParentID
            _DEST 0
        END IF
        IF Control(i).ParentID > 0 AND Control(i).Type <> __UI_Type_MenuItem THEN
            DIM CheckChildControls AS LONG, NoMoreChildren AS _BYTE, ThisParent AS LONG
            ThisParent = Control(i).ParentID
            NoMoreChildren = True
            FOR CheckChildControls = i + 1 TO UBOUND(Control)
                IF Control(CheckChildControls).ParentID = ThisParent THEN
                    NoMoreChildren = False
                    EXIT FOR
                END IF
            NEXT
            IF NoMoreChildren THEN
                __UI_DrawFrame Control(ThisParent)
            END IF
        END IF
        IF i = __UI_Focus THEN __UI_CheckBinding i
    NEXT
    FOR i = 1 TO UBOUND(Control)
        IF Control(i).Type = __UI_Type_Frame AND Control(i).Value = 0 THEN
            __UI_DrawFrame Control(i)
        END IF
    NEXT
    IF __UI_DesignMode AND __UI_SelectionRectangle THEN
        IF OverlayReset = False THEN
            OverlayReset = True
            IF Control(__UI_FormID).HelperCanvas <> 0 THEN _FREEIMAGE Control(__UI_FormID).HelperCanvas
            Control(__UI_FormID).HelperCanvas = _NEWIMAGE(Control(__UI_FormID).Width, Control(__UI_FormID).Height, 32)
            _DEST Control(__UI_FormID).HelperCanvas
            CLS , _RGBA32(0, 0, 0, 0)
        ELSE
            _DEST Control(__UI_FormID).HelperCanvas
        END IF
        OverlayisVisible = True
        LINE(__UI_SelectionRectangleLeft, __UI_SelectionRectangleTop)-(__UI_MouseLeft,__UI_MouseTop), _RGBA32(0, 177, 255, 150), BF
        LINE(__UI_SelectionRectangleLeft, __UI_SelectionRectangleTop)-(__UI_MouseLeft,__UI_MouseTop), _RGB32(39, 188, 244), B
        _DEST 0
    END IF
    IF __UI_TotalSelectedControls > 0 AND __UI_Snapped = False AND __UI_ShowPositionAndSize THEN
        IF Control(__UI_FormID).Width > 0 AND Control(__UI_FormID).Height > 0 THEN
            IF OverlayReset = False THEN
                OverlayReset = True
                IF Control(__UI_FormID).HelperCanvas <> 0 THEN _FREEIMAGE Control(__UI_FormID).HelperCanvas
                Control(__UI_FormID).HelperCanvas = _NEWIMAGE(Control(__UI_FormID).Width, Control(__UI_FormID).Height, 32)
                _DEST Control(__UI_FormID).HelperCanvas
                CLS , _RGBA32(0, 0, 0, 0)
            ELSE
                _DEST Control(__UI_FormID).HelperCanvas
            END IF
            i = __UI_FirstSelectedID
            IF Control(__UI_HoveringID).ControlIsSelected THEN i = __UI_HoveringID
            IF Control(i).Type <> __UI_Type_ContextMenu AND Control(i).Type <> __UI_Type_MenuBar AND Control(i).Type <> __UI_Type_MenuItem THEN
                OverlayisVisible = True
                DIM SizeAndPosition1$, SizeAndPosition2$, pw&
                DIM InfoLeft AS INTEGER, InfoTop AS INTEGER
                _FONT Control(__UI_FormID).Font
                SizeAndPosition1$ = LTRIM$(STR$(Control(i).Left)) + "," + LTRIM$(STR$(Control(i).Top))
                pw& = __UI_PrintWidth(SizeAndPosition1$)
                SizeAndPosition2$ = LTRIM$(STR$(Control(i).Width)) + "x" + LTRIM$(STR$(Control(i).Height))
                IF __UI_PrintWidth(SizeAndPosition2$) > pw& THEN pw& = __UI_PrintWidth(SizeAndPosition2$)
                InfoLeft = Control(Control(i).ParentID).Left + Control(i).Left
                IF InfoLeft < 0 THEN InfoLeft = 0
                IF InfoLeft + pw& + 4 > Control(__UI_FormID).Width THEN InfoLeft = Control(__UI_FormID).Width - (pw& + 4)
                InfoTop = Control(Control(i).ParentID).Top + Control(i).Top + Control(i).Height + 2
                IF InfoTop < 0 THEN InfoTop = 0
                IF InfoTop + uspacing& * 2 + 4 > Control(__UI_FormID).Height THEN InfoTop = Control(__UI_FormID).Height - (uspacing& * 2 + 4)
                IF InfoLeft < Control(Control(i).ParentID).Left + Control(i).Left + Control(i).Width AND _
                    Control(Control(i).ParentID).Left + Control(i).Left < InfoLeft + pw& + 4 AND _
                    InfoTop < Control(Control(i).ParentID).Top + Control(i).Top + Control(i).Height + 2 AND _
                    Control(Control(i).ParentID).Top + Control(i).Top < InfoTop + uspacing& * 2 + 4 THEN
                    InfoTop = Control(Control(i).ParentID).Top + Control(i).Top - (uspacing& * 2 + 4)
                END IF
                IF __UI_MouseLeft >= InfoLeft AND __UI_MouseLeft <= InfoLeft + pw& + 4 AND _
                    __UI_MouseTop >= InfoTop AND __UI_MouseTop <= InfoTop + uspacing& * 2 + 4 THEN
                    InfoLeft = InfoLeft + Control(i).Width
                END IF
                __UI_ShadowBox InfoLeft, InfoTop, pw& + 4, uspacing& * 2 + 4, __UI_DefaultColor(__UI_Type_Form, 6), 40, 5
                COLOR _RGB32(0, 0, 0)
                __UI_PrintString InfoLeft + 3, InfoTop + 3, SizeAndPosition1$
                __UI_PrintString InfoLeft + 3, InfoTop + 3 + uspacing&, SizeAndPosition2$
            END IF
            _DEST 0
        END IF
    END IF
    FOR i = 1 TO __UI_TotalActiveMenus
        IF LEFT$(Control(__UI_ActiveMenu(i)).Name, 5) <> "__UI_" THEN
            __UI_DrawMenuPanel Control(__UI_ActiveMenu(i)), __UI_ParentMenu(i)
        END IF
    NEXT
    IF OverlayisVisible THEN
        IF Control(__UI_FormID).HelperCanvas < -1 THEN
            __UI_MakeHardwareImage Control(__UI_FormID).HelperCanvas
            _PUTIMAGE , Control(__UI_FormID).HelperCanvas
        END IF
    END IF
    IF __UI_DesignMode = True AND __UI_ShowInvisibleControls = True THEN
        FOR i = 1 TO UBOUND(Control)
            IF Control(i).Type = __UI_Type_ContextMenu AND LEFT$(Control(i).Name, 5) <> "__UI_" THEN
                __UI_DrawContextMenuHandle Control(i), Control(i).ControlState
            END IF
        NEXT
    END IF
    FOR i = 1 TO __UI_TotalActiveMenus
        IF LEFT$(Control(__UI_ActiveMenu(i)).Name, 5) = "__UI_" THEN
            __UI_DrawMenuPanel Control(__UI_ActiveMenu(i)), __UI_ParentMenu(i)
        END IF
    NEXT
    STATIC PanelWidth AS INTEGER, PanelHeight AS INTEGER
    IF __UI_ActiveTipID > 0 THEN
        IF __UI_ActiveTipID <> __UI_PreviousTipID OR ToolTip(__UI_ActiveTipID) <> __UI_TempTips(__UI_ActiveTipID) THEN
            __UI_PreviousTipID = __UI_ActiveTipID
            ToolTip(__UI_ActiveTipID) = RestoreCHR$(ToolTip(__UI_ActiveTipID))
            __UI_TempTips(__UI_ActiveTipID) = ToolTip(__UI_ActiveTipID)
            DIM ThisLine%, TextTop%
            DIM FindLF AS LONG, TotalLines AS INTEGER, LongestLine AS INTEGER, TempLine$
            _FONT Control(__UI_FormID).Font
            TempCaption$ = __UI_WordWrap(Replace(ToolTip(__UI_ActiveTipID), "\n", CHR$(10), False, 0), Control(__UI_FormID).Width / 2, LongestLine, TotalLines)
            PanelWidth = LongestLine + 16
            IF TotalLines = 1 THEN
                PanelHeight = uspacing& + 8
            ELSE
                PanelHeight = (TotalLines * uspacing&) + 8
            END IF
            IF ActiveTipPanel <> 0 THEN _FREEIMAGE ActiveTipPanel
            ActiveTipPanel = _NEWIMAGE(PanelWidth, PanelHeight, 32)
            _DEST ActiveTipPanel
            _FONT Control(__UI_FormID).Font
            __UI_ShadowBox 0, 0, PanelWidth - 6, PanelHeight - 6, __UI_DefaultColor(__UI_Type_Form, 6), 40, 5
            COLOR __UI_DefaultColor(__UI_Type_Form, 1)
            IF TotalLines = 1 THEN
                __UI_PrintString _WIDTH \ 2 - __UI_PrintWidth(TempCaption$) \ 2 - 1.75, _HEIGHT \ 2 - uheight& \ 2 - 1.75, TempCaption$
            ELSE
                DO WHILE LEN(TempCaption$)
                    ThisLine% = ThisLine% + 1
                    TextTop% = 3 + ThisLine% * uspacing& - uspacing&
                    FindLF& = INSTR(TempCaption$, CHR$(1))
                    IF FindLF& > 0 THEN
                        TempLine$ = LEFT$(TempCaption$, FindLF& - 1)
                        TempCaption$ = MID$(TempCaption$, FindLF& + 1)
                    ELSE
                        TempLine$ = TempCaption$
                        TempCaption$ = ""
                        IF ThisLine% = 1 THEN TextTop% = ((_HEIGHT \ 2) - uspacing& \ 2)
                    END IF
                    __UI_PrintString 5, TextTop%, TempLine$
                LOOP
            END IF
            LINE (0, 0)-(_WIDTH - 6, _HEIGHT - 6), __UI_DefaultColor(__UI_Type_Form, 5), B
            __UI_MakeHardwareImage ActiveTipPanel
        END IF
        _DEST 0
        IF __UI_ActiveTipTop + PanelHeight > Control(__UI_FormID).Height THEN
            __UI_ActiveTipTop = Control(__UI_FormID).Height - PanelHeight
            IF __UI_ActiveTipTop < 0 THEN __UI_ActiveTipTop = 0
        END IF
        IF __UI_ActiveTipLeft + PanelWidth > Control(__UI_FormID).Width THEN
            __UI_ActiveTipLeft = Control(__UI_FormID).Width - PanelWidth
            IF __UI_ActiveTipLeft < 0 THEN __UI_ActiveTipLeft = 0
        END IF
        _PUTIMAGE (__UI_ActiveTipLeft, __UI_ActiveTipTop), ActiveTipPanel
    END IF
    IF __UI_IsDragging AND __UI_DraggingID > 0 AND __UI_DraggingID <> __UI_FormID AND (_KEYDOWN(100305) = 0 AND _KEYDOWN(100306) = 0) AND __UI_SnapLines THEN
        STATIC DragTip AS LONG, TipPanelWidth AS INTEGER
        IF DragTip = 0 THEN
            _FONT Control(__UI_FormID).Font
            TempCaption$ = "Hold Ctrl to bypass snapping"
            TipPanelWidth = __UI_PrintWidth(TempCaption$) + 10
            PanelHeight = uspacing& + 5 + 5
            DragTip = _NEWIMAGE(TipPanelWidth, PanelHeight, 32)
            _DEST DragTip
            _FONT Control(__UI_FormID).Font
            __UI_ShadowBox 0, 0, TipPanelWidth - 6, PanelHeight - 6, __UI_DefaultColor(__UI_Type_Form, 6), 40, 5
            COLOR __UI_DefaultColor(__UI_Type_Form, 1)
            __UI_PrintString _WIDTH \ 2 - __UI_PrintWidth(TempCaption$) \ 2 - 1.75, _HEIGHT \ 2 - uspacing& \ 2 - 1.75, TempCaption$
            LINE (0, 0)-(_WIDTH - 6, _HEIGHT - 6), __UI_DefaultColor(__UI_Type_Form, 5), B
            __UI_MakeHardwareImage DragTip
        END IF
        _DEST 0
        IF __UI_Snapped THEN
            X1 = _WIDTH \ 2 - TipPanelWidth \ 2
            Y1 = 0
            IF Control(__UI_DraggingID).Top <= _HEIGHT(DragTip) THEN
                _PUTIMAGE (X1, Control(__UI_FormID).Height - _HEIGHT(DragTip)), DragTip
            ELSE
                _PUTIMAGE (X1, 0), DragTip
            END IF
        END IF
    ELSEIF __UI_IsResizing AND Control(__UI_ResizingID).Type = __UI_Type_Label AND Control(__UI_ResizingID).AutoSize = True THEN
        STATIC ResizeTip AS LONG, ResizeTipPanelWidth AS INTEGER
        IF ResizeTip = 0 THEN
            _FONT Control(__UI_FormID).Font
            TempCaption$ = "Can't resize a label when .AutoSize = True"
            ResizeTipPanelWidth = __UI_PrintWidth(TempCaption$) + 10
            PanelHeight = uspacing& + 5 + 5
            ResizeTip = _NEWIMAGE(ResizeTipPanelWidth, PanelHeight, 32)
            _DEST ResizeTip
            _FONT Control(__UI_FormID).Font
            __UI_ShadowBox 0, 0, ResizeTipPanelWidth - 6, PanelHeight - 6, __UI_DefaultColor(__UI_Type_Form, 6), 40, 5
            COLOR __UI_DefaultColor(__UI_Type_Form, 1)
            __UI_PrintString _WIDTH \ 2 - __UI_PrintWidth(TempCaption$) \ 2 - 1.75, _HEIGHT \ 2 - uspacing& \ 2 - 1.75, TempCaption$
            LINE (0, 0)-(_WIDTH - 6, _HEIGHT - 6), __UI_DefaultColor(__UI_Type_Form, 5), B
            __UI_MakeHardwareImage ResizeTip
        END IF
        _DEST 0
        X1 = _WIDTH \ 2 - ResizeTipPanelWidth \ 2
        Y1 = 0
        IF Control(__UI_ResizingID).Top <= _HEIGHT(ResizeTip) THEN
            _PUTIMAGE (X1, Control(__UI_FormID).Height - _HEIGHT(ResizeTip)), ResizeTip
        ELSE
            _PUTIMAGE (X1, 0), ResizeTip
        END IF
    END IF
    __UI_ForceRedraw = False
    STATIC WaitMessageSetup AS _BYTE, PrevWaitMessage AS STRING
    DIM NoInputMessage$
    IF TIMER - __UI_ProcessInputTimer > 2 THEN
        IF __UI_WaitMessageHandle = 0 THEN
            __UI_WaitMessageHandle = _NEWIMAGE(_WIDTH(0), _HEIGHT(0), 32)
        ELSEIF _WIDTH(__UI_WaitMessageHandle) <> _WIDTH(0) OR _HEIGHT(__UI_WaitMessageHandle) <> _HEIGHT(0) THEN
            _FREEIMAGE __UI_WaitMessageHandle
            __UI_WaitMessageHandle = _NEWIMAGE(_WIDTH(0), _HEIGHT(0), 32)
        END IF
        IF WaitMessageSetup = False OR PrevWaitMessage <> __UI_WaitMessage THEN
            PrevWaitMessage = __UI_WaitMessage
            WaitMessageSetup = True
            PrevDest = _DEST
            _DEST __UI_WaitMessageHandle
            LINE (0, 0)-STEP(_WIDTH, _HEIGHT), _RGBA32(0, 0, 0, 170), BF
            _FONT Control(__UI_FormID).Font
            _PRINTMODE _KEEPBACKGROUND
            NoInputMessage$ = "Please wait..."
            COLOR _RGB32(0, 0, 0)
            __UI_PrintString _WIDTH / 2 - __UI_PrintWidth(NoInputMessage$) / 2 + 1, _HEIGHT \ 2 - uspacing + 1, NoInputMessage$
            COLOR _RGB32(255, 255, 255)
            __UI_PrintString _WIDTH / 2 - __UI_PrintWidth(NoInputMessage$) / 2, _HEIGHT \ 2 - uspacing, NoInputMessage$
            IF LEN(__UI_WaitMessage) > 0 THEN
                IF LEFT$(__UI_WaitMessage, 1) <> "(" THEN __UI_WaitMessage = "(" + __UI_WaitMessage + ")"
                COLOR _RGB32(0, 0, 0)
                __UI_PrintString _WIDTH / 2 - __UI_PrintWidth(__UI_WaitMessage) / 2 + 1, _HEIGHT \ 2 + uspacing + 1, __UI_WaitMessage
                COLOR _RGB32(255, 255, 255)
                __UI_PrintString _WIDTH / 2 - __UI_PrintWidth(__UI_WaitMessage) / 2, _HEIGHT \ 2 + uspacing, __UI_WaitMessage
            END IF
            _DEST PrevDest
            __UI_MakeHardwareImage __UI_WaitMessageHandle
        END IF
        IF _EXIT THEN SYSTEM 'Can't force user to wait...
        _PUTIMAGE , __UI_WaitMessageHandle
    END IF
    FOR i = 1 TO 2
        IF ControlDrawOrder(UBOUND(ControlDrawOrder)) = 0 THEN __UI_ExpandControlDrawOrder -1
    NEXT i 'run that a couple times for good measure
    _DISPLAY
END SUB
SUB __UI_EventDispatcher
    STATIC __UI_LastMouseIconSet AS _BYTE
    STATIC __UI_LastMouseDownEvent AS SINGLE
    STATIC __UI_MouseDownTop AS INTEGER, __UI_MouseDownLeft AS INTEGER
    STATIC __UI_JustOpenedMenu AS _BYTE
    STATIC OriginalDragX AS INTEGER, OriginalDragY AS INTEGER
    DIM i AS LONG, j AS LONG, ThisItem%, TempParent AS LONG
    DIM ContainerOffsetLeft AS INTEGER, ContainerOffsetTop AS INTEGER
    IF __UI_HoveringID = 0 AND __UI_Focus = 0 THEN EXIT SUB
    IF Control(__UI_HoveringID).ParentID > 0 AND Control(__UI_HoveringID).Type <> __UI_Type_MenuItem THEN
        ContainerOffsetLeft = Control(Control(__UI_HoveringID).ParentID).Left
        ContainerOffsetTop = Control(Control(__UI_HoveringID).ParentID).Top
    END IF
    IF __UI_ExitTriggered THEN
        __UI_UnloadSignal = True
        __UI_BeforeUnload
        IF __UI_UnloadSignal THEN SYSTEM
    END IF
    IF __UI_HasResized THEN __UI_FormResized: __UI_HasResized = False
    IF __UI_LastHoveringID <> __UI_HoveringID OR __UI_HoveringID = __UI_ActiveDropdownList THEN
        IF __UI_LastHoveringID THEN __UI_MouseLeave __UI_LastHoveringID
        __UI_MouseEnter __UI_HoveringID
        STATIC LastMouseLeft AS INTEGER, LastMouseTop AS INTEGER
        IF NOT __UI_DraggingThumb AND __UI_HoveringID = __UI_ActiveDropdownList AND Control(__UI_HoveringID).HoveringVScrollbarButton = 0 AND LastMouseTop <> __UI_MouseTop THEN
            LastMouseTop = __UI_MouseTop
            IF Control(__UI_HoveringID).Max > 0 THEN
                IF Control(__UI_HoveringID).Font > 0 THEN _FONT Control(__UI_HoveringID).Font
                ThisItem% = ((__UI_MouseTop - (ContainerOffsetTop + Control(__UI_HoveringID).Top) - (ABS(Control(__UI_HoveringID).HasBorder) * __UI_DefaultCaptionIndent)) \ Control(__UI_HoveringID).ItemHeight) + Control(__UI_HoveringID).InputViewStart
                IF ThisItem% >= Control(__UI_HoveringID).Min AND ThisItem% <= Control(__UI_HoveringID).Max THEN
                    Control(__UI_HoveringID).Value = ThisItem%
                    IF Control(__UI_HoveringID).PreviousValue <> Control(__UI_HoveringID).Value THEN
                        __UI_ValueChanged __UI_HoveringID
                        Control(__UI_HoveringID).PreviousValue = Control(__UI_HoveringID).Value
                        Control(__UI_HoveringID).Redraw = True
                    END IF
                END IF
            END IF
        ELSEIF Control(__UI_HoveringID).Type = __UI_Type_MenuBar AND LastMouseLeft <> __UI_MouseLeft THEN
            LastMouseLeft = __UI_MouseLeft
            IF __UI_TotalActiveMenus > 0 AND __UI_ParentMenu(__UI_TotalActiveMenus) <> __UI_HoveringID THEN
                IF __UI_ActiveMenuIsContextMenu = False AND __UI_DesignMode = False THEN
                    __UI_ActivateMenu Control(__UI_HoveringID), False
                    __UI_ForceRedraw = True
                END IF
            END IF
        END IF
        IF Control(__UI_Focus).Type = __UI_Type_MenuItem AND Control(__UI_HoveringID).Type <> __UI_Type_MenuItem THEN
            __UI_Focus = __UI_ActiveMenu(__UI_TotalActiveMenus)
        END IF
    END IF
    $IF WIN OR MAC THEN
        IF __UI_ResizeHandleHover = 1 OR __UI_ResizeHandleHover = 3 THEN
            IF __UI_LastMouseIconSet <> 3 THEN
                __UI_LastMouseIconSet = 3
                _MOUSESHOW "horizontal"
            END IF
        ELSEIF __UI_ResizeHandleHover = 2 OR __UI_ResizeHandleHover = 4 THEN
            IF __UI_LastMouseIconSet <> 4 THEN
                __UI_LastMouseIconSet = 4
                _MOUSESHOW "vertical"
            END IF
        ELSEIF __UI_ResizeHandleHover = 5 OR __UI_ResizeHandleHover = 8 THEN
            IF __UI_LastMouseIconSet <> 5 THEN
                __UI_LastMouseIconSet = 5
                _MOUSESHOW "topright_bottomleft"
            END IF
        ELSEIF __UI_ResizeHandleHover = 6 OR __UI_ResizeHandleHover = 7 THEN
            IF __UI_LastMouseIconSet <> 6 THEN
                __UI_LastMouseIconSet = 6
                _MOUSESHOW "topleft_bottomright"
            END IF
        ELSEIF Control(__UI_HoveringID).Type = __UI_Type_TextBox AND NOT __UI_DesignMode THEN
            IF Control(__UI_HoveringID).HasVScrollbar AND __UI_MouseLeft >= Control(__UI_HoveringID).Left + Control(Control(__UI_HoveringID).ParentID).Left + Control(__UI_HoveringID).Width - __UI_ScrollbarWidth - 1 THEN
                IF __UI_LastMouseIconSet <> 0 THEN
                    __UI_LastMouseIconSet = 0
                    _MOUSESHOW "default"
                END IF
            ELSE
                IF __UI_LastMouseIconSet <> 2 THEN
                    __UI_LastMouseIconSet = 2
                    _MOUSESHOW "text"
                END IF
            END IF
        ELSE
            IF __UI_LastMouseIconSet <> 0 THEN
                __UI_LastMouseIconSet = 0
                _MOUSESHOW "default"
            END IF
        END IF
    $END IF
    DIM __UI_FocusSearch AS LONG
    IF __UI_KeyHit = 9 AND __UI_IsDragging = False THEN 'TAB
        IF __UI_DesignMode THEN
            __UI_FocusSearch = __UI_FirstSelectedID
            FOR i = 1 TO UBOUND(Control)
                Control(i).ControlIsSelected = False
            NEXT
            DO
                IF _KEYDOWN(100304) OR _KEYDOWN(100303) THEN
                    __UI_FocusSearch = __UI_FocusSearch - 1
                    IF __UI_FocusSearch < 1 THEN __UI_FocusSearch = UBOUND(Control)
                ELSE
                    __UI_FocusSearch = __UI_FocusSearch + 1
                    IF __UI_FocusSearch > UBOUND(Control) THEN __UI_FocusSearch = 0
                END IF
                IF __UI_FocusSearch = __UI_FirstSelectedID THEN
                    Control(__UI_FocusSearch).ControlIsSelected = True
                    EXIT DO
                END IF
                IF Control(__UI_FocusSearch).ID > 0 AND Control(__UI_FocusSearch).Type <> __UI_Type_Form AND Control(__UI_FocusSearch).Type <> __UI_Type_MenuPanel AND Control(__UI_FocusSearch).Type <> __UI_Type_Font AND UCASE$(LEFT$(Control(__UI_FocusSearch).Name, 5)) <> "__UI_" THEN
                    IF Control(__UI_FocusSearch).Type <> __UI_Type_MenuItem THEN
                        __UI_CloseAllMenus
                        __UI_TotalSelectedControls = 1
                        __UI_FirstSelectedID = __UI_FocusSearch
                        Control(__UI_FocusSearch).ControlIsSelected = True
                        IF Control(__UI_FocusSearch).Type = __UI_Type_MenuBar OR Control(__UI_FocusSearch).Type = __UI_Type_ContextMenu THEN
                            __UI_ActivateMenu Control(__UI_FocusSearch), False
                        END IF
                        EXIT DO
                    ELSE
                        IF __UI_ParentMenu(__UI_TotalActiveMenus) = Control(__UI_FocusSearch).ParentID THEN
                            __UI_TotalSelectedControls = 1
                            __UI_FirstSelectedID = __UI_FocusSearch
                            Control(__UI_FocusSearch).ControlIsSelected = True
                            EXIT DO
                        END IF
                    END IF
                END IF
            LOOP
        ELSE
            __UI_KeyboardFocus = True
            __UI_FocusSearch = __UI_Focus
            DO
                IF _KEYDOWN(100304) OR _KEYDOWN(100303) THEN
                    __UI_FocusSearch = __UI_FocusSearch - 1
                    IF __UI_FocusSearch < 1 THEN __UI_FocusSearch = UBOUND(Control)
                ELSE
                    __UI_FocusSearch = __UI_FocusSearch + 1
                    IF __UI_FocusSearch > UBOUND(Control) THEN __UI_FocusSearch = 0
                END IF
                IF __UI_FocusSearch = __UI_Focus THEN
                    EXIT DO
                END IF
                IF Control(__UI_FocusSearch).CanHaveFocus AND Control(__UI_FocusSearch).Disabled = False AND Control(__UI_FocusSearch).Hidden = False AND Control(Control(__UI_FocusSearch).ParentID).Disabled = False AND Control(Control(__UI_FocusSearch).ParentID).Hidden = False THEN
                    IF __UI_Focus <> __UI_FocusSearch THEN __UI_KeepFocus = False: __UI_FocusOut __UI_Focus
                    IF __UI_KeepFocus = False THEN
                        __UI_Focus = __UI_FocusSearch
                        IF Control(__UI_Focus).Type = __UI_Type_TextBox AND Control(__UI_Focus).Multiline = False THEN
                            IF Control(__UI_Focus).BypassSelectOnFocus = False THEN
                                Control(__UI_Focus).Cursor = LEN(Text(__UI_Focus))
                                Control(__UI_Focus).SelectionStart = 0
                                Control(__UI_Focus).TextIsSelected = True
                            END IF
                        END IF
                        __UI_FocusIn __UI_Focus
                    END IF
                    EXIT DO
                END IF
            LOOP
        END IF
    END IF
    IF __UI_DesignMode = False THEN
        IF __UI_ActiveDropdownList > 0 AND ((__UI_Focus <> __UI_ActiveDropdownList AND __UI_Focus <> __UI_ParentDropdownList) OR __UI_KeyHit = 27) THEN
            __UI_Focus = __UI_ParentDropdownList
            __UI_DestroyControl Control(__UI_ActiveDropdownList)
            __UI_KeyHit = 0
        ELSEIF __UI_TotalActiveMenus > 0 AND (__UI_Focus <> __UI_ActiveMenu(__UI_TotalActiveMenus) AND __UI_Focus <> __UI_ParentMenu(__UI_TotalActiveMenus)) THEN
            IF Control(__UI_Focus).Type <> __UI_Type_MenuItem THEN
                __UI_CloseAllMenus
                __UI_ForceRedraw = True
            END IF
        END IF
    END IF
    IF __UI_MouseWheel AND NOT __UI_DesignMode THEN
        IF (Control(__UI_HoveringID).Type = __UI_Type_ListBox AND NOT Control(__UI_HoveringID).Disabled) THEN
            Control(__UI_HoveringID).InputViewStart = Control(__UI_HoveringID).InputViewStart + __UI_MouseWheel
            IF Control(__UI_HoveringID).InputViewStart + Control(__UI_HoveringID).LastVisibleItem > Control(__UI_HoveringID).Max THEN
                Control(__UI_HoveringID).InputViewStart = Control(__UI_HoveringID).Max - Control(__UI_HoveringID).LastVisibleItem + 1
            END IF
        ELSEIF (__UI_ActiveDropdownList > 0 AND __UI_Focus = __UI_ActiveDropdownList AND __UI_ParentDropdownList = __UI_HoveringID) THEN
            Control(__UI_ActiveDropdownList).InputViewStart = Control(__UI_ActiveDropdownList).InputViewStart + __UI_MouseWheel
            IF Control(__UI_ActiveDropdownList).InputViewStart + Control(__UI_ActiveDropdownList).LastVisibleItem > Control(__UI_ActiveDropdownList).Max THEN
                Control(__UI_ActiveDropdownList).InputViewStart = Control(__UI_ActiveDropdownList).Max - Control(__UI_ActiveDropdownList).LastVisibleItem + 1
            END IF
        ELSEIF (Control(__UI_Focus).Type = __UI_Type_DropdownList AND NOT Control(__UI_Focus).Disabled) THEN
            Control(__UI_Focus).Value = Control(__UI_Focus).Value + __UI_MouseWheel
            IF Control(__UI_Focus).Value < 1 THEN Control(__UI_Focus).Value = 1
            IF Control(__UI_Focus).Value > Control(__UI_Focus).Max THEN Control(__UI_Focus).Value = Control(__UI_Focus).Max
            IF Control(__UI_Focus).PreviousValue <> Control(__UI_Focus).Value THEN
                __UI_ValueChanged __UI_Focus
                Control(__UI_Focus).PreviousValue = Control(__UI_Focus).Value
                Control(__UI_Focus).Redraw = True
            END IF
        ELSEIF Control(__UI_Focus).Type = __UI_Type_TextBox AND Control(__UI_Focus).MultiLine THEN
            DIM TotalLines AS LONG
            TotalLines = __UI_CountLines(__UI_Focus)
            _FONT Control(__UI_Focus).Font
            IF TotalLines > Control(__UI_Focus).Height \ uspacing& THEN
                Control(__UI_Focus).FirstVisibleLine = Control(__UI_Focus).FirstVisibleLine + __UI_MouseWheel
                IF Control(__UI_Focus).FirstVisibleLine < 1 THEN Control(__UI_Focus).FirstVisibleLine = 1
                IF Control(__UI_Focus).FirstVisibleLine > TotalLines - Control(__UI_Focus).Height \ uspacing& + 1 THEN
                    Control(__UI_Focus).FirstVisibleLine = TotalLines - Control(__UI_Focus).Height \ uspacing& + 1
                END IF
            END IF
        END IF
    END IF
    IF __UI_MouseButton2 THEN
        IF __UI_Mouse2IsDown = False THEN
            __UI_Mouse2IsDown = True
            __UI_DidClick = True
            __UI_Mouse2DownOnID = __UI_HoveringID
        ELSE
        END IF
    ELSE
        IF __UI_Mouse2IsDown THEN
            __UI_Mouse2IsDown = False
            __UI_Mouse2DownOnID = 0
            IF __UI_DesignMode THEN
                DIM RightClickSelect AS _BYTE
                RightClickSelect = True
                GOSUB DesignModeClickToSelect
                RightClickSelect = False
                Control(__UI_GetID("__UI_PreviewMenuShowInvisibleControls")).Value = __UI_ShowInvisibleControls
                IF __UI_TotalSelectedControls = 0 THEN
                    Control(__UI_GetID("__UI_PreviewMenuAlignLeft")).Hidden = True
                    Control(__UI_GetID("__UI_PreviewMenuAlignRight")).Hidden = True
                    Control(__UI_GetID("__UI_PreviewMenuAlignTops")).Hidden = True
                    Control(__UI_GetID("__UI_PreviewMenuAlignBottoms")).Hidden = True
                    Control(__UI_GetID("__UI_PreviewMenuAlignCenterV")).Hidden = True
                    Control(__UI_GetID("__UI_PreviewMenuAlignCenterH")).Hidden = True
                    Control(__UI_GetID("__UI_PreviewMenuAlignCentersV")).Hidden = True
                    Control(__UI_GetID("__UI_PreviewMenuAlignCentersH")).Hidden = True
                    Control(__UI_GetID("__UI_PreviewMenuDistributeV")).Hidden = True
                    Control(__UI_GetID("__UI_PreviewMenuDistributeH")).Hidden = True
                    Control(__UI_GetID("__UI_PreviewMenuCut")).Disabled = True
                    Control(__UI_GetID("__UI_PreviewMenuCopy")).Disabled = True
                    Control(__UI_GetID("__UI_PreviewMenuDelete")).Disabled = True
                    Control(__UI_GetID("__UI_PreviewMenuImageOriginalSize")).Hidden = True
                    Control(__UI_GetID("__UI_PreviewMenuNumericOnly")).Hidden = True
                    Control(__UI_GetID("__UI_PreviewMenuSetDefaultButton")).Hidden = True
                    Control(__UI_GetID("__UI_PreviewMenuBindControls")).Hidden = True
                    Control(__UI_GetID("__UI_PreviewMenuShowInvisibleControls")).Hidden = False
                    Control(__UI_GetID("__UI_PreviewMenuConvertType")).Hidden = True
                    Control(__UI_GetID("__UI_PreviewMenuNewMenuBar")).Hidden = False
                    Control(__UI_GetID("__UI_PreviewMenuNewContextMenu")).Hidden = False
                ELSEIF __UI_TotalSelectedControls = 1 THEN
                    Control(__UI_GetID("__UI_PreviewMenuAlignLeft")).Hidden = True
                    Control(__UI_GetID("__UI_PreviewMenuAlignRight")).Hidden = True
                    Control(__UI_GetID("__UI_PreviewMenuAlignTops")).Hidden = True
                    Control(__UI_GetID("__UI_PreviewMenuAlignBottoms")).Hidden = True
                    IF Control(__UI_FirstSelectedID).Type <> __UI_Type_ContextMenu AND Control(__UI_FirstSelectedID).Type <> __UI_Type_MenuBar AND Control(__UI_FirstSelectedID).Type <> __UI_Type_MenuItem THEN
                        Control(__UI_GetID("__UI_PreviewMenuAlignCenterV")).Hidden = False
                        Control(__UI_GetID("__UI_PreviewMenuAlignCenterH")).Hidden = False
                        SetCaption __UI_GetID("__UI_PreviewMenuAlignCenterV"), "Center &Vertically"
                        SetCaption __UI_GetID("__UI_PreviewMenuAlignCenterH"), "Center &Horizontally-"
                        Control(__UI_GetID("__UI_PreviewMenuNewMenuBar")).Hidden = True
                        Control(__UI_GetID("__UI_PreviewMenuNewContextMenu")).Hidden = True
                        Control(__UI_GetID("__UI_PreviewMenuShowInvisibleControls")).Hidden = True
                    ELSE
                        Control(__UI_GetID("__UI_PreviewMenuNewMenuBar")).Hidden = False
                        Control(__UI_GetID("__UI_PreviewMenuNewContextMenu")).Hidden = False
                        Control(__UI_GetID("__UI_PreviewMenuShowInvisibleControls")).Hidden = False
                        Control(__UI_GetID("__UI_PreviewMenuAlignCenterV")).Hidden = True
                        Control(__UI_GetID("__UI_PreviewMenuAlignCenterH")).Hidden = True
                    END IF
                    IF Control(__UI_FirstSelectedID).Type = __UI_Type_PictureBox AND LEN(Text(__UI_FirstSelectedID)) > 0 THEN
                        IF Control(__UI_FirstSelectedID).Height - (Control(__UI_FirstSelectedID).BorderSize * ABS(Control(__UI_FirstSelectedID).HasBorder)) <> _HEIGHT(Control(__UI_FirstSelectedID).HelperCanvas) OR _
                           Control(__UI_FirstSelectedID).Width - (Control(__UI_FirstSelectedID).BorderSize * ABS(Control(__UI_FirstSelectedID).HasBorder)) <> _WIDTH(Control(__UI_FirstSelectedID).HelperCanvas) THEN
                            Control(__UI_GetID("__UI_PreviewMenuImageOriginalSize")).Hidden = False
                            SetCaption __UI_GetID("__UI_PreviewMenuImageOriginalSize"), "Restore &image dimensions (" + LTRIM$(STR$(_WIDTH(Control(__UI_FirstSelectedID).HelperCanvas))) + "x" + LTRIM$(STR$(_HEIGHT(Control(__UI_FirstSelectedID).HelperCanvas))) + ")-"
                        ELSE
                            Control(__UI_GetID("__UI_PreviewMenuImageOriginalSize")).Hidden = True
                        END IF
                    ELSE
                        Control(__UI_GetID("__UI_PreviewMenuImageOriginalSize")).Hidden = True
                    END IF
                    IF Control(__UI_FirstSelectedID).Type = __UI_Type_TextBox THEN
                        IF Control(__UI_FirstSelectedID).NumericOnly = True THEN
                            Control(__UI_GetID("__UI_PreviewMenuNumericOnly")).Hidden = False
                            Control(__UI_GetID("__UI_PreviewMenuNumericOnly")).Value = False
                        ELSEIF Control(__UI_FirstSelectedID).NumericOnly = __UI_NumericWithBounds THEN
                            Control(__UI_GetID("__UI_PreviewMenuNumericOnly")).Hidden = False
                            Control(__UI_GetID("__UI_PreviewMenuNumericOnly")).Value = True
                        ELSE
                            Control(__UI_GetID("__UI_PreviewMenuNumericOnly")).Hidden = True
                        END IF
                    ELSE
                        Control(__UI_GetID("__UI_PreviewMenuNumericOnly")).Hidden = True
                        Control(__UI_GetID("__UI_PreviewMenuNumericOnly")).Value = False
                    END IF
                    IF Control(__UI_FirstSelectedID).Type = __UI_Type_Button THEN
                        IF __UI_FirstSelectedID <> __UI_DefaultButtonID THEN
                            Control(__UI_GetID("__UI_PreviewMenuSetDefaultButton")).Hidden = False
                            Control(__UI_GetID("__UI_PreviewMenuSetDefaultButton")).Value = False
                        ELSE
                            Control(__UI_GetID("__UI_PreviewMenuSetDefaultButton")).Hidden = False
                            Control(__UI_GetID("__UI_PreviewMenuSetDefaultButton")).Value = True
                        END IF
                    ELSE
                        Control(__UI_GetID("__UI_PreviewMenuSetDefaultButton")).Hidden = True
                    END IF
                    Control(__UI_GetID("__UI_PreviewMenuAlignCentersV")).Hidden = True
                    Control(__UI_GetID("__UI_PreviewMenuAlignCentersH")).Hidden = True
                    Control(__UI_GetID("__UI_PreviewMenuDistributeV")).Hidden = True
                    Control(__UI_GetID("__UI_PreviewMenuDistributeH")).Hidden = True
                    Control(__UI_GetID("__UI_PreviewMenuCut")).Disabled = False
                    Control(__UI_GetID("__UI_PreviewMenuCopy")).Disabled = False
                    Control(__UI_GetID("__UI_PreviewMenuDelete")).Disabled = False
                    IF __UI_Type(Control(__UI_FirstSelectedID).Type).TurnsInto THEN
                        Control(__UI_GetID("__UI_PreviewMenuConvertType")).Hidden = False
                        SetCaption __UI_GetID("__UI_PreviewMenuConvertType"), "Co&nvert to " + RTRIM$(__UI_Type(__UI_Type(Control(__UI_FirstSelectedID).Type).TurnsInto).Name) + "-"
                    ELSEIF Control(__UI_FirstSelectedID).Type = __UI_Type_TextBox THEN
                        Control(__UI_GetID("__UI_PreviewMenuConvertType")).Hidden = False
                        IF Control(__UI_FirstSelectedID).NumericOnly = False THEN
                            SetCaption __UI_GetID("__UI_PreviewMenuConvertType"), "Co&nvert to NumericTextBox-"
                        ELSE
                            SetCaption __UI_GetID("__UI_PreviewMenuConvertType"), "Co&nvert to TextBox-"
                        END IF
                    ELSE
                        Control(__UI_GetID("__UI_PreviewMenuConvertType")).Hidden = True
                    END IF
                    IF Control(__UI_FirstSelectedID).BoundTo > 0 THEN
                        Control(__UI_GetID("__UI_PreviewMenuBindControls")).Hidden = False
                        SetCaption __UI_GetID("__UI_PreviewMenuBindControls"), "Edit binding...-"
                    END IF
                ELSEIF __UI_TotalSelectedControls = 2 THEN
                    Control(__UI_GetID("__UI_PreviewMenuBindControls")).Hidden = False
                    IF Control(__UI_FirstSelectedID).BoundTo > 0 THEN
                        SetCaption __UI_GetID("__UI_PreviewMenuBindControls"), "Edit binding...-"
                    ELSE
                        SetCaption __UI_GetID("__UI_PreviewMenuBindControls"), "Bind selected controls...-"
                    END IF
                    Control(__UI_GetID("__UI_PreviewMenuNewMenuBar")).Hidden = True
                    Control(__UI_GetID("__UI_PreviewMenuNewContextMenu")).Hidden = True
                    Control(__UI_GetID("__UI_PreviewMenuShowInvisibleControls")).Hidden = True
                    Control(__UI_GetID("__UI_PreviewMenuAlignLeft")).Hidden = False
                    Control(__UI_GetID("__UI_PreviewMenuAlignRight")).Hidden = False
                    Control(__UI_GetID("__UI_PreviewMenuAlignTops")).Hidden = False
                    Control(__UI_GetID("__UI_PreviewMenuAlignBottoms")).Hidden = False
                    Control(__UI_GetID("__UI_PreviewMenuAlignCenterV")).Hidden = False
                    Control(__UI_GetID("__UI_PreviewMenuAlignCenterH")).Hidden = False
                    SetCaption __UI_GetID("__UI_PreviewMenuAlignCenterV"), "Center &Vertically (group)"
                    SetCaption __UI_GetID("__UI_PreviewMenuAlignCenterH"), "Center &Horizontally (group)-"
                    Control(__UI_GetID("__UI_PreviewMenuAlignCentersV")).Hidden = False
                    Control(__UI_GetID("__UI_PreviewMenuAlignCentersH")).Hidden = False
                    Control(__UI_GetID("__UI_PreviewMenuDistributeV")).Hidden = True
                    Control(__UI_GetID("__UI_PreviewMenuDistributeH")).Hidden = True
                    Control(__UI_GetID("__UI_PreviewMenuCut")).Disabled = False
                    Control(__UI_GetID("__UI_PreviewMenuCopy")).Disabled = False
                    Control(__UI_GetID("__UI_PreviewMenuDelete")).Disabled = False
                    Control(__UI_GetID("__UI_PreviewMenuImageOriginalSize")).Hidden = True
                    Control(__UI_GetID("__UI_PreviewMenuSetDefaultButton")).Hidden = True
                    Control(__UI_GetID("__UI_PreviewMenuNumericOnly")).Hidden = True
                    GOTO AddConvertMenu
                ELSE
                    Control(__UI_GetID("__UI_PreviewMenuNewMenuBar")).Hidden = True
                    Control(__UI_GetID("__UI_PreviewMenuNewContextMenu")).Hidden = True
                    Control(__UI_GetID("__UI_PreviewMenuShowInvisibleControls")).Hidden = True
                    Control(__UI_GetID("__UI_PreviewMenuAlignLeft")).Hidden = False
                    Control(__UI_GetID("__UI_PreviewMenuAlignRight")).Hidden = False
                    Control(__UI_GetID("__UI_PreviewMenuAlignTops")).Hidden = False
                    Control(__UI_GetID("__UI_PreviewMenuAlignBottoms")).Hidden = False
                    Control(__UI_GetID("__UI_PreviewMenuAlignCenterV")).Hidden = False
                    Control(__UI_GetID("__UI_PreviewMenuAlignCenterH")).Hidden = False
                    SetCaption __UI_GetID("__UI_PreviewMenuAlignCenterV"), "Center &Vertically (group)"
                    SetCaption __UI_GetID("__UI_PreviewMenuAlignCenterH"), "Center &Horizontally (group)-"
                    Control(__UI_GetID("__UI_PreviewMenuAlignCentersV")).Hidden = False
                    Control(__UI_GetID("__UI_PreviewMenuAlignCentersH")).Hidden = False
                    Control(__UI_GetID("__UI_PreviewMenuDistributeV")).Hidden = False
                    Control(__UI_GetID("__UI_PreviewMenuDistributeH")).Hidden = False
                    Control(__UI_GetID("__UI_PreviewMenuCut")).Disabled = False
                    Control(__UI_GetID("__UI_PreviewMenuCopy")).Disabled = False
                    Control(__UI_GetID("__UI_PreviewMenuDelete")).Disabled = False
                    Control(__UI_GetID("__UI_PreviewMenuImageOriginalSize")).Hidden = True
                    Control(__UI_GetID("__UI_PreviewMenuSetDefaultButton")).Hidden = True
                    Control(__UI_GetID("__UI_PreviewMenuNumericOnly")).Hidden = True
                    AddConvertMenu:
                    IF __UI_Type(Control(__UI_FirstSelectedID).Type).TurnsInto OR Control(__UI_FirstSelectedID).Type = __UI_Type_TextBox THEN
                        DIM SearchType AS INTEGER, AddConvertMenuCheck AS _BYTE
                        SearchType = Control(__UI_FirstSelectedID).Type
                        AddConvertMenuCheck = True
                        FOR i = 1 TO UBOUND(Control)
                            IF Control(i).ControlIsSelected THEN
                                IF Control(i).Type <> SearchType THEN
                                    AddConvertMenuCheck = False
                                    EXIT FOR
                                END IF
                            END IF
                        NEXT
                        IF AddConvertMenuCheck THEN
                            Control(__UI_GetID("__UI_PreviewMenuConvertType")).Hidden = False
                            IF SearchType = __UI_Type_TextBox THEN
                                IF Control(__UI_FirstSelectedID).NumericOnly = False THEN
                                    SetCaption __UI_GetID("__UI_PreviewMenuConvertType"), "Co&nvert to NumericTextBox-"
                                ELSE
                                    SetCaption __UI_GetID("__UI_PreviewMenuConvertType"), "Co&nvert to TextBox-"
                                END IF
                            ELSE
                                SetCaption __UI_GetID("__UI_PreviewMenuConvertType"), "Co&nvert to " + RTRIM$(__UI_Type(__UI_Type(Control(__UI_FirstSelectedID).Type).TurnsInto).Name) + "-"
                            END IF
                        ELSE
                            Control(__UI_GetID("__UI_PreviewMenuConvertType")).Hidden = True
                        END IF
                    ELSE
                        Control(__UI_GetID("__UI_PreviewMenuConvertType")).Hidden = True
                    END IF
                END IF
                IF LEFT$(_CLIPBOARD$, LEN(__UI_ClipboardCheck$)) = __UI_ClipboardCheck$ THEN
                    Control(__UI_GetID("__UI_PreviewMenuPaste")).Disabled = False
                ELSE
                    Control(__UI_GetID("__UI_PreviewMenuPaste")).Disabled = True
                END IF
                IF Control(__UI_HoveringID).Type = __UI_Type_MenuBar THEN
                    Control(__UI_GetID("__UI_PreviewMenuCut")).Disabled = True
                    Control(__UI_GetID("__UI_PreviewMenuCopy")).Disabled = True
                END IF
                IF __UI_HoveringID > 0 AND Control(__UI_HoveringID).Type <> __UI_Type_MenuItem AND Control(__UI_HoveringID).Type <> __UI_Type_MenuPanel THEN __UI_ActivateMenu Control(__UI_GetID("__UI_PreviewMenu")), False
                __UI_CantShowContextMenu = False
                IF Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Height > Control(__UI_FormID).Height OR Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Width > Control(__UI_FormID).Width THEN
                    __UI_CantShowContextMenu = True
                END IF
            ELSEIF Control(__UI_HoveringID).ContextMenuID > 0 AND Control(__UI_HoveringID).Disabled = False THEN
                __UI_Focus = __UI_HoveringID
                __UI_PreviousFocus = __UI_Focus
                IF Control(__UI_HoveringID).ContextMenuID = __UI_GetID("__UI_TextFieldMenu") THEN
                    IF Control(__UI_HoveringID).TextIsSelected THEN
                        Control(__UI_GetID("__UI_TextMenuCut")).Disabled = False
                        Control(__UI_GetID("__UI_TextMenuCopy")).Disabled = False
                        Control(__UI_GetID("__UI_TextMenuDelete")).Disabled = False
                    ELSE
                        Control(__UI_GetID("__UI_TextMenuCut")).Disabled = True
                        Control(__UI_GetID("__UI_TextMenuCopy")).Disabled = True
                        Control(__UI_GetID("__UI_TextMenuDelete")).Disabled = True
                    END IF
                    IF LEN(_CLIPBOARD$) > 0 THEN
                        Control(__UI_GetID("__UI_TextMenuPaste")).Disabled = False
                    ELSE
                        Control(__UI_GetID("__UI_TextMenuPaste")).Disabled = True
                    END IF
                END IF
                __UI_ContextMenuSourceID = __UI_HoveringID
                __UI_ActivateMenu Control(Control(__UI_HoveringID).ContextMenuID), False
            END IF
        END IF
    END IF
    IF __UI_MouseButton1 THEN
        IF __UI_MouseIsDown = False THEN
            __UI_DidClick = True
            __UI_MouseDownTop = __UI_MouseTop
            __UI_MouseDownLeft = __UI_MouseLeft
            IF __UI_DesignMode THEN
                IF LEFT$(Control(__UI_HoveringID).Name, 5) = "__UI_" THEN GOTO ProcessClick
                DesignModeClickToSelect:
                IF RightClickSelect AND (Control(__UI_HoveringID).Type = __UI_Type_MenuPanel OR LEFT$(Control(__UI_HoveringID).Name, 5) = "__UI_") THEN RETURN
                IF __UI_TotalActiveMenus > 0 AND Control(__UI_HoveringID).Type <> __UI_Type_MenuPanel THEN
                    IF Control(__UI_Focus).Type <> __UI_Type_MenuItem THEN
                        __UI_CloseAllMenus
                        __UI_ForceRedraw = True
                    END IF
                END IF
                IF _KEYDOWN(100305) OR _KEYDOWN(100306) THEN
                    IF Control(__UI_HoveringID).Type <> __UI_Type_Frame AND Control(__UI_HoveringID).Type <> __UI_Type_Form AND Control(__UI_HoveringID).Type <> __UI_Type_Font AND Control(__UI_HoveringID).Type <> __UI_Type_MenuItem AND Control(__UI_HoveringID).Type <> __UI_Type_MenuPanel AND Control(__UI_HoveringID).Type <> __UI_Type_ContextMenu AND Control(__UI_HoveringID).Type <> __UI_Type_MenuBar THEN
                        IF Control(__UI_HoveringID).ControlIsSelected = False AND Control(__UI_HoveringID).ParentID = Control(__UI_FirstSelectedID).ParentID AND Control(__UI_FirstSelectedID).Type <> __UI_Type_Frame THEN
                            Control(__UI_HoveringID).ControlIsSelected = True
                            __UI_TotalSelectedControls = __UI_TotalSelectedControls + 1
                        ELSEIF Control(__UI_HoveringID).ControlIsSelected = True THEN
                            Control(__UI_HoveringID).ControlIsSelected = False
                            __UI_TotalSelectedControls = __UI_TotalSelectedControls - 1
                            IF __UI_TotalSelectedControls = 1 THEN
                                FOR i = 1 TO UBOUND(Control)
                                    IF Control(i).ControlIsSelected THEN __UI_FirstSelectedID = i: EXIT FOR
                                NEXT
                            ELSEIF __UI_TotalSelectedControls > 0 AND __UI_FirstSelectedID = __UI_HoveringID THEN
                                FOR i = 1 TO UBOUND(Control)
                                    IF Control(i).ControlIsSelected THEN __UI_FirstSelectedID = i: EXIT FOR
                                NEXT
                            END IF
                        END IF
                    END IF
                ELSEIF _KEYDOWN(100303) OR _KEYDOWN(100304) THEN
                    IF __UI_FirstSelectedID <> __UI_HoveringID AND Control(__UI_HoveringID).Type <> __UI_Type_Frame AND Control(__UI_HoveringID).Type <> __UI_Type_Form AND Control(__UI_HoveringID).Type <> __UI_Type_Font AND Control(__UI_HoveringID).Type <> __UI_Type_MenuItem AND Control(__UI_HoveringID).Type <> __UI_Type_MenuPanel AND Control(__UI_HoveringID).Type <> __UI_Type_ContextMenu AND Control(__UI_HoveringID).Type <> __UI_Type_MenuBar THEN
                        IF Control(__UI_FirstSelectedID).ParentID = Control(__UI_HoveringID).ParentID THEN
                            __UI_SelectionRectangleLeft = Control(__UI_FirstSelectedID).Left + Control(__UI_FirstSelectedID).Width / 2
                            __UI_SelectionRectangleTop = Control(__UI_FirstSelectedID).Top + Control(__UI_FirstSelectedID).Height / 2
                            GOTO DoSelectionRectangle
                        END IF
                    END IF
                ELSE
                    IF Control(__UI_HoveringID).Type = __UI_Type_MenuPanel AND LEFT$(Control(__UI_GetParentMenu(__UI_HoveringID)).Name, 5) <> "__UI_" THEN
                        DIM TempValue AS LONG
                        TempParent = __UI_GetParentMenu(__UI_HoveringID)
                        TempValue = __UI_NewControl(__UI_Type_MenuItem, "", 0, 0, 0, 0, TempParent)
                        SetCaption TempValue, RTRIM$(Control(TempValue).Name)
                        FOR i = __UI_TotalActiveMenus TO __UI_GetActiveMenuIndex(__UI_HoveringID) STEP -1
                            __UI_DestroyControl Control(__UI_ActiveMenu(i))
                        NEXT
                        __UI_ActivateMenu Control(TempParent), False
                        FOR i = 1 TO UBOUND(Control)
                            Control(i).ControlIsSelected = False
                        NEXT
                        Control(TempValue).ControlIsSelected = True
                        __UI_ActivateMenu Control(TempValue), False
                        __UI_ForceRedraw = True
                        __UI_TotalSelectedControls = 1
                        __UI_FirstSelectedID = TempValue
                    ELSEIF Control(__UI_HoveringID).Type = __UI_Type_Form AND __UI_MouseTop <= (uspacing& + 5) THEN
                        IF __UI_HasMenuBar THEN
                            __UI_KeyPress 224
                        END IF
                    ELSE
                        IF Control(__UI_HoveringID).ControlIsSelected = False THEN
                            FOR i = 1 TO UBOUND(Control)
                                Control(i).ControlIsSelected = False
                            NEXT
                            __UI_TotalSelectedControls = 0
                            __UI_FirstSelectedID = 0
                            IF Control(__UI_HoveringID).Type <> __UI_Type_Form AND Control(__UI_HoveringID).Type <> __UI_Type_Font AND Control(__UI_HoveringID).Type <> __UI_Type_MenuPanel THEN
                                IF Control(__UI_HoveringID).Type = __UI_Type_ContextMenu AND __UI_ShowInvisibleControls = False THEN GOTO SkipInvisibleControl
                                Control(__UI_HoveringID).ControlIsSelected = True
                                __UI_TotalSelectedControls = 1
                                __UI_FirstSelectedID = __UI_HoveringID
                                IF Control(__UI_HoveringID).Type = __UI_Type_MenuItem OR Control(__UI_HoveringID).Type = __UI_Type_MenuBar OR (Control(__UI_HoveringID).Type = __UI_Type_ContextMenu AND __UI_ShowInvisibleControls) THEN
                                    __UI_ActivateMenu Control(__UI_HoveringID), False
                                    __UI_JustOpenedMenu = True
                                END IF
                                SkipInvisibleControl:
                            END IF
                        ELSE
                            IF Control(__UI_FirstSelectedID).Type = __UI_Type_Frame AND (TIMER - __UI_LastMouseDownEvent < .5 AND (__UI_MouseTop = __UI_MouseDownTop AND __UI_MouseLeft = __UI_MouseDownLeft)) THEN
                                __UI_KeyPress 221
                            END IF
                        END IF
                    END IF
                END IF
                IF RightClickSelect THEN RETURN
            ELSEIF Control(__UI_HoveringID).CanHaveFocus AND NOT Control(__UI_HoveringID).Disabled THEN
                STATIC JustEnteredTextBox AS SINGLE
                IF __UI_Focus <> __UI_HoveringID THEN
                    __UI_KeepFocus = False: __UI_FocusOut __UI_Focus
                    IF __UI_KeepFocus = False THEN
                        __UI_Focus = __UI_HoveringID
                        IF Control(__UI_Focus).Type = __UI_Type_TextBox THEN JustEnteredTextBox = TIMER
                        __UI_FocusIn __UI_Focus
                    END IF
                END IF
            ELSE
                IF Control(__UI_HoveringID).Type = __UI_Type_MenuBar AND __UI_TotalActiveMenus > 0 AND __UI_HoveringID = __UI_ParentMenu(__UI_TotalActiveMenus) THEN
                    __UI_Focus = __UI_PreviousFocus
                ELSEIF Control(__UI_HoveringID).Type = __UI_Type_MenuBar AND (__UI_TotalActiveMenus = 0 OR __UI_ActiveMenuIsContextMenu) THEN
                    __UI_CloseAllMenus
                    __UI_ActivateMenu Control(__UI_HoveringID), False
                    __UI_JustOpenedMenu = True
                ELSEIF Control(__UI_HoveringID).Type = __UI_Type_MenuItem THEN
                ELSE
                    IF __UI_Focus > 0 THEN __UI_KeepFocus = False: __UI_FocusOut __UI_Focus
                    IF __UI_KeepFocus = False THEN __UI_Focus = 0
                END IF
            END IF
            __UI_MouseIsDown = True
            __UI_MouseDownOnID = __UI_HoveringID
            IF __UI_DesignMode AND __UI_MouseDownOnID = __UI_FormID THEN
                __UI_SelectionRectangle = True
                __UI_SelectionRectangleTop = __UI_MouseTop
                __UI_SelectionRectangleLeft = __UI_MouseLeft
            ELSE
                __UI_SelectionRectangle = False
            END IF
            IF NOT __UI_DesignMode THEN
                IF Control(__UI_Focus).Type = __UI_Type_TextBox AND NOT Control(__UI_Focus).Disabled THEN
                    _FONT Control(__UI_Focus).Font
                    IF Control(__UI_HoveringID).HoveringVScrollbarButton = 1 OR Control(__UI_HoveringID).HoveringVScrollbarButton = 2 OR Control(__UI_HoveringID).HoveringVScrollbarButton = 4 OR Control(__UI_HoveringID).HoveringVScrollbarButton = 5 THEN
                        __UI_MouseDownOnScrollbar = TIMER
                    ELSEIF Control(__UI_HoveringID).HoveringVScrollbarButton = 3 THEN
                        IF NOT __UI_DraggingThumb THEN
                            __UI_DraggingThumb = True
                            __UI_ThumbDragTop = __UI_MouseTop
                            __UI_DraggingThumbOnID = __UI_HoveringID
                        END IF
                    ELSE
                        IF TIMER - JustEnteredTextBox =< .3 THEN
                            IF Control(__UI_Focus).Multiline THEN
                                GOTO PositionCursorMultilineTB
                            ELSE
                                IF Control(__UI_Focus).BypassSelectOnFocus = False THEN
                                    Control(__UI_Focus).Cursor = LEN(Text(__UI_Focus))
                                    Control(__UI_Focus).SelectionStart = 0
                                    Control(__UI_Focus).TextIsSelected = True
                                END IF
                            END IF
                        ELSE
                            STATIC WholeWordSelection AS _BYTE, WholeWordCursor AS LONG, WholeWordSelStart AS LONG
                            Control(__UI_Focus).TextIsSelected = False
                            __UI_FillSelectedText 0, 0
                            WholeWordSelection = False
                            WholeWordCursor = 0
                            WholeWordSelStart = 0
                            IF Control(__UI_Focus).Multiline AND Control(__UI_Focus).HoveringVScrollbarButton = 0 THEN
                                PositionCursorMultilineTB:
                                DIM ThisLine$, ThisLineLen AS LONG, ThisLineStart AS LONG
                                TotalLines = __UI_CountLines(__UI_Focus)
                                Control(__UI_Focus).CurrentLine = Control(__UI_Focus).FirstVisibleLine - 1 + (__UI_MouseTop - Control(__UI_Focus).Top - Control(Control(__UI_Focus).ParentID).Top) / uspacing&
                                IF Control(__UI_Focus).CurrentLine > TotalLines THEN Control(__UI_Focus).CurrentLine = TotalLines
                                IF Control(__UI_Focus).CurrentLine = 0 THEN Control(__UI_Focus).CurrentLine = 1
                                ThisLine$ = __UI_GetTextBoxLine(__UI_Focus, Control(__UI_Focus).CurrentLine, ThisLineStart)
                                ThisLineLen = LEN(ThisLine$)
                                __UI_PrintString _WIDTH + 10, _HEIGHT + 10, ThisLine$
                                FOR i = 1 TO __UI_LastRenderedCharCount
                                    IF (__UI_MouseLeft - Control(__UI_Focus).Left - Control(Control(__UI_Focus).ParentID).Left) >= __UI_ThisLineChars(i - 1) AND (__UI_MouseLeft - Control(__UI_Focus).Left - Control(Control(__UI_Focus).ParentID).Left) <= __UI_ThisLineChars(i) THEN
                                        Control(__UI_Focus).Cursor = ThisLineStart + i - 2
                                        EXIT FOR
                                    END IF
                                NEXT
                                IF i > __UI_LastRenderedCharCount THEN Control(__UI_Focus).Cursor = ThisLineStart + ThisLineLen - 1
                                Control(__UI_Focus).SelectionStart = Control(__UI_Focus).Cursor
                            ELSE
                                STATIC LastCursorReposition#, LastCursorID AS LONG, LastCursor AS LONG
                                STATIC JustSelectedAWord#, ContinuedSelection AS _BYTE
                                IF TIMER - LastCursorReposition# < .3 AND LastCursorID = __UI_Focus AND i <= __UI_LastRenderedCharCount AND LastCursor = Control(__UI_Focus).Cursor THEN
                                    CONST SEP$ = " ,.?!;:()=+-*/"
                                    IF INSTR(SEP$, MID$(Text(__UI_Focus), Control(__UI_Focus).Cursor + 1, 1)) = 0 THEN
                                        RepositionCursorWholeWord:
                                        DO
                                            Control(__UI_Focus).Cursor = Control(__UI_Focus).Cursor - 1
                                            IF Control(__UI_Focus).Cursor = 0 THEN EXIT DO
                                        LOOP WHILE INSTR(SEP$, MID$(Text(__UI_Focus), Control(__UI_Focus).Cursor + 1, 1)) = 0
                                        Control(__UI_Focus).Cursor = Control(__UI_Focus).Cursor + 1
                                        IF ContinuedSelection THEN RETURN
                                        RepositionSelStartWholeWord:
                                        DO
                                            Control(__UI_Focus).SelectionStart = Control(__UI_Focus).SelectionStart + 1
                                            IF Control(__UI_Focus).SelectionStart = LEN(Text(__UI_Focus)) THEN EXIT DO
                                        LOOP WHILE INSTR(SEP$, MID$(Text(__UI_Focus), Control(__UI_Focus).SelectionStart + 1, 1)) = 0
                                        DO
                                            IF Control(__UI_Focus).SelectionStart = LEN(Text(__UI_Focus)) THEN EXIT DO
                                            IF MID$(Text(__UI_Focus), Control(__UI_Focus).SelectionStart + 1, 1) = " " THEN
                                                Control(__UI_Focus).SelectionStart = Control(__UI_Focus).SelectionStart + 1
                                            ELSE
                                                EXIT DO
                                            END IF
                                        LOOP
                                        IF ContinuedSelection THEN RETURN
                                        Control(__UI_Focus).TextIsSelected = True
                                        JustSelectedAWord# = TIMER
                                        WholeWordSelection = True
                                        WholeWordCursor = Control(__UI_Focus).Cursor
                                        WholeWordSelStart = Control(__UI_Focus).SelectionStart
                                    END IF
                                ELSE
                                    IF TIMER - JustSelectedAWord# > .3 THEN
                                        Control(__UI_Focus).TextIsSelected = False
                                        __UI_FillSelectedText 0, 0
                                        __UI_PrintString _WIDTH + 10, _HEIGHT + 10, Text(__UI_Focus)
                                        FOR i = 1 TO __UI_LastRenderedCharCount
                                            IF (__UI_MouseLeft - Control(__UI_Focus).Left - Control(Control(__UI_Focus).ParentID).Left + Control(__UI_Focus).InputViewStart) >= __UI_ThisLineChars(i - 1) AND (__UI_MouseLeft - Control(__UI_Focus).Left - Control(Control(__UI_Focus).ParentID).Left) + Control(__UI_Focus).InputViewStart <= __UI_ThisLineChars(i) THEN
                                                Control(__UI_Focus).Cursor = i - 1
                                                EXIT FOR
                                            END IF
                                        NEXT
                                        IF i > __UI_LastRenderedCharCount THEN Control(__UI_Focus).Cursor = LEN(Text(__UI_Focus))
                                        Control(__UI_Focus).SelectionStart = Control(__UI_Focus).Cursor
                                    END IF
                                END IF
                                LastCursorReposition# = TIMER
                                LastCursorID = __UI_Focus
                                LastCursor = Control(__UI_Focus).Cursor
                            END IF
                            __UI_IsSelectingText = True
                            __UI_IsSelectingTextOnID = __UI_Focus
                        END IF
                    END IF
                ELSEIF Control(__UI_HoveringID).Type = __UI_Type_ListBox AND NOT Control(__UI_HoveringID).Disabled THEN
                    IF Control(__UI_HoveringID).HoveringVScrollbarButton = 1 OR Control(__UI_HoveringID).HoveringVScrollbarButton = 2 OR Control(__UI_HoveringID).HoveringVScrollbarButton = 4 OR Control(__UI_HoveringID).HoveringVScrollbarButton = 5 THEN
                        __UI_MouseDownOnScrollbar = TIMER
                    ELSEIF Control(__UI_HoveringID).HoveringVScrollbarButton = 3 THEN
                        IF NOT __UI_DraggingThumb THEN
                            __UI_DraggingThumb = True
                            __UI_ThumbDragTop = __UI_MouseTop
                            __UI_DraggingThumbOnID = __UI_HoveringID
                        END IF
                    END IF
                END IF
            END IF
            __UI_MouseDown __UI_HoveringID
            __UI_LastMouseDownEvent = TIMER
        ELSE
            IF __UI_DesignMode THEN
                IF __UI_ResizeHandleHover = 0 AND (__UI_MouseTop <> __UI_MouseDownTop OR __UI_MouseLeft <> __UI_MouseDownLeft) THEN
                    IF __UI_IsDragging = False AND __UI_SelectionRectangle = False THEN
                        __UI_IsDragging = True
                        __UI_DraggingID = __UI_HoveringID
                        FOR i = 1 TO UBOUND(Control)
                            IF Control(i).ControlIsSelected AND Control(i).Type = __UI_Type_Frame THEN
                                __UI_DraggingID = i
                                FOR i = 1 TO UBOUND(Control)
                                    IF i <> __UI_DraggingID THEN
                                        IF Control(i).ControlIsSelected THEN
                                            Control(i).ControlIsSelected = False
                                            __UI_TotalSelectedControls = __UI_TotalSelectedControls - 1
                                        END IF
                                    END IF
                                NEXT
                                EXIT FOR
                            END IF
                        NEXT
                        IF Control(__UI_FirstSelectedID).Type = __UI_Type_ContextMenu OR Control(__UI_FirstSelectedID).Type = __UI_Type_MenuBar OR Control(__UI_FirstSelectedID).Type = __UI_Type_MenuItem THEN
                            __UI_DraggingID = 0
                            __UI_IsDragging = False
                            __UI_MouseDownOnID = 0
                        ELSE
                            __UI_MouseDownOnID = 0
                            __UI_DragY = __UI_MouseTop
                            __UI_DragX = __UI_MouseLeft
                            OriginalDragX = __UI_DragX - Control(__UI_DraggingID).Left - Control(Control(__UI_DraggingID).ParentID).Left
                            OriginalDragY = __UI_DragY - Control(__UI_DraggingID).Top - Control(Control(__UI_DraggingID).ParentID).Top
                            IF __UI_TotalSelectedControls > 1 THEN
                                FOR i = 1 TO UBOUND(Control)
                                    IF i <> __UI_DraggingID THEN
                                        Control(i).LeftOffsetFromFirstSelected = Control(__UI_DraggingID).Left - Control(i).Left
                                        Control(i).TopOffsetFromFirstSelected = Control(__UI_DraggingID).Top - Control(i).Top
                                    END IF
                                NEXT
                            END IF
                        END IF
                    END IF
                ELSE
                    IF __UI_IsResizing = False AND __UI_SelectionRectangle = False AND Control(__UI_FirstSelectedID).Type <> __UI_Type_MenuBar AND Control(__UI_FirstSelectedID).Type <> __UI_Type_MenuItem THEN
                        __UI_IsResizing = True
                        __UI_ResizingID = __UI_HoveringID
                        __UI_MouseDownOnID = 0
                        __UI_DragY = __UI_MouseTop
                        __UI_DragX = __UI_MouseLeft
                    END IF
                END IF
            END IF
            IF TIMER - JustEnteredTextBox < .3 THEN JustEnteredTextBox = TIMER
            IF __UI_IsSelectingText THEN
                _FONT (Control(__UI_IsSelectingTextOnID).Font)
                IF NOT Control(__UI_IsSelectingTextOnID).Multiline THEN
                    __UI_PrintString _WIDTH + 10, _HEIGHT + 10, Text(__UI_Focus)
                    IF NOT WholeWordSelection THEN
                        IF __UI_MouseLeft > Control(__UI_Focus).Left + Control(Control(__UI_Focus).ParentID).Left AND __UI_MouseLeft < Control(__UI_Focus).Left + Control(Control(__UI_Focus).ParentID).Left + Control(__UI_Focus).Width THEN
                            FOR i = 1 TO __UI_LastRenderedCharCount
                                IF (__UI_MouseLeft - Control(__UI_Focus).Left - Control(Control(__UI_Focus).ParentID).Left + Control(__UI_Focus).InputViewStart) >= __UI_ThisLineChars(i - 1) AND (__UI_MouseLeft - Control(__UI_Focus).Left - Control(Control(__UI_Focus).ParentID).Left) + Control(__UI_Focus).InputViewStart <= __UI_ThisLineChars(i) THEN
                                    Control(__UI_Focus).Cursor = i - 1
                                    EXIT FOR
                                END IF
                            NEXT
                            IF i > __UI_LastRenderedCharCount THEN Control(__UI_Focus).Cursor = LEN(Text(__UI_Focus))
                        ELSEIF __UI_MouseLeft < Control(__UI_Focus).Left + Control(Control(__UI_Focus).ParentID).Left THEN
                            Control(__UI_Focus).Cursor = 0
                        ELSEIF __UI_MouseLeft > Control(__UI_Focus).Left + Control(Control(__UI_Focus).ParentID).Left + Control(__UI_Focus).Width THEN
                            Control(__UI_Focus).Cursor = LEN(Text(__UI_Focus))
                        END IF
                        IF Control(__UI_IsSelectingTextOnID).Cursor <> Control(__UI_IsSelectingTextOnID).SelectionStart THEN
                            Control(__UI_IsSelectingTextOnID).TextIsSelected = True
                        ELSE
                            Control(__UI_IsSelectingTextOnID).TextIsSelected = False
                        END IF
                    ELSE
                        DIM TempCursor AS LONG
                        IF __UI_MouseLeft > Control(__UI_Focus).Left + Control(Control(__UI_Focus).ParentID).Left AND __UI_MouseLeft < Control(__UI_Focus).Left + Control(Control(__UI_Focus).ParentID).Left + Control(__UI_Focus).Width THEN
                            FOR i = 1 TO __UI_LastRenderedCharCount
                                IF (__UI_MouseLeft - Control(__UI_Focus).Left - Control(Control(__UI_Focus).ParentID).Left + Control(__UI_Focus).InputViewStart) >= __UI_ThisLineChars(i - 1) AND (__UI_MouseLeft - Control(__UI_Focus).Left - Control(Control(__UI_Focus).ParentID).Left) + Control(__UI_Focus).InputViewStart <= __UI_ThisLineChars(i) THEN
                                    TempCursor = i - 1
                                    EXIT FOR
                                END IF
                            NEXT
                        ELSEIF __UI_MouseLeft < Control(__UI_Focus).Left + Control(Control(__UI_Focus).ParentID).Left THEN
                            TempCursor = 0
                        ELSEIF __UI_MouseLeft > Control(__UI_Focus).Left + Control(Control(__UI_Focus).ParentID).Left + Control(__UI_Focus).Width THEN
                            TempCursor = LEN(Text(__UI_Focus))
                        END IF
                        ContinuedSelection = True
                        IF TempCursor < WholeWordCursor THEN Control(__UI_Focus).Cursor = TempCursor: GOSUB RepositionCursorWholeWord
                        IF TempCursor > WholeWordSelStart THEN Control(__UI_Focus).SelectionStart = TempCursor: GOSUB RepositionSelStartWholeWord
                        IF TempCursor > WholeWordCursor AND TempCursor < WholeWordSelStart THEN Control(__UI_Focus).Cursor = WholeWordCursor: Control(__UI_Focus).SelectionStart = WholeWordSelStart
                        ContinuedSelection = False
                    END IF
                ELSE
                    TotalLines = __UI_CountLines(__UI_IsSelectingTextOnID)
                    Control(__UI_IsSelectingTextOnID).CurrentLine = Control(__UI_IsSelectingTextOnID).FirstVisibleLine - 1 + (__UI_MouseTop - Control(__UI_IsSelectingTextOnID).Top - Control(Control(__UI_IsSelectingTextOnID).ParentID).Top) / uspacing&
                    IF Control(__UI_IsSelectingTextOnID).CurrentLine > TotalLines THEN Control(__UI_IsSelectingTextOnID).CurrentLine = TotalLines
                    IF Control(__UI_IsSelectingTextOnID).CurrentLine = 0 THEN Control(__UI_IsSelectingTextOnID).CurrentLine = 1
                    ThisLine$ = __UI_GetTextBoxLine(__UI_IsSelectingTextOnID, Control(__UI_IsSelectingTextOnID).CurrentLine, ThisLineStart)
                    ThisLineLen = LEN(ThisLine$)
                    __UI_PrintString _WIDTH + 10, _HEIGHT + 10, ThisLine$
                    FOR i = 1 TO __UI_LastRenderedCharCount
                        IF (__UI_MouseLeft - Control(__UI_IsSelectingTextOnID).Left - Control(Control(__UI_IsSelectingTextOnID).ParentID).Left) >= __UI_ThisLineChars(i - 1) AND (__UI_MouseLeft - Control(__UI_IsSelectingTextOnID).Left - Control(Control(__UI_IsSelectingTextOnID).ParentID).Left) <= __UI_ThisLineChars(i) THEN
                            Control(__UI_IsSelectingTextOnID).Cursor = ThisLineStart + i - 2
                            EXIT FOR
                        END IF
                    NEXT
                    IF i > __UI_LastRenderedCharCount THEN Control(__UI_IsSelectingTextOnID).Cursor = ThisLineStart + ThisLineLen - 1
                    IF Control(__UI_IsSelectingTextOnID).Cursor <> Control(__UI_IsSelectingTextOnID).SelectionStart THEN
                        Control(__UI_IsSelectingTextOnID).TextIsSelected = True
                    END IF
                END IF
            END IF
            IF NOT __UI_SelectionRectangle THEN
                IF __UI_MouseDownOnID <> __UI_HoveringID AND __UI_MouseDownOnID > 0 THEN
                    IF Control(__UI_HoveringID).Type = __UI_Type_MenuItem OR Control(__UI_HoveringID).Type = __UI_Type_MenuPanel THEN
                        __UI_MouseDownOnID = __UI_HoveringID
                    ELSE
                        __UI_PreviousMouseDownOnID = __UI_MouseDownOnID
                        __UI_MouseDownOnID = 0
                    END IF
                ELSEIF __UI_HoveringID = __UI_PreviousMouseDownOnID AND __UI_PreviousMouseDownOnID > 0 THEN
                    __UI_MouseDownOnID = __UI_PreviousMouseDownOnID
                    __UI_PreviousMouseDownOnID = 0
                ELSEIF __UI_MouseDownOnID = __UI_HoveringID THEN
                    IF Control(__UI_MouseDownOnID).Type = __UI_Type_ListBox THEN
                        IF NOT Control(__UI_MouseDownOnID).Disabled AND Control(__UI_MouseDownOnID).HoveringVScrollbarButton = 1 AND TIMER - __UI_MouseDownOnScrollbar > .3 THEN
                            Control(__UI_MouseDownOnID).InputViewStart = Control(__UI_MouseDownOnID).InputViewStart - 1
                            __UI_MouseDownOnScrollbar = TIMER - .25
                        ELSEIF NOT Control(__UI_MouseDownOnID).Disabled AND Control(__UI_MouseDownOnID).HoveringVScrollbarButton = 2 AND TIMER - __UI_MouseDownOnScrollbar > .3 THEN
                            IF Control(__UI_MouseDownOnID).InputViewStart + Control(__UI_MouseDownOnID).LastVisibleItem <= Control(__UI_MouseDownOnID).Max THEN
                                Control(__UI_MouseDownOnID).InputViewStart = Control(__UI_MouseDownOnID).InputViewStart + 1
                            END IF
                            __UI_MouseDownOnScrollbar = TIMER - .25
                        ELSEIF NOT Control(__UI_MouseDownOnID).Disabled AND Control(__UI_MouseDownOnID).HoveringVScrollbarButton = 4 AND TIMER - __UI_MouseDownOnScrollbar < .3 THEN
                            Control(__UI_MouseDownOnID).InputViewStart = Control(__UI_MouseDownOnID).InputViewStart - (Control(__UI_MouseDownOnID).LastVisibleItem - 1)
                            __UI_MouseDownOnScrollbar = TIMER - .25
                        ELSEIF NOT Control(__UI_MouseDownOnID).Disabled AND Control(__UI_MouseDownOnID).HoveringVScrollbarButton = 5 AND TIMER - __UI_MouseDownOnScrollbar < .3 THEN
                            Control(__UI_MouseDownOnID).InputViewStart = Control(__UI_MouseDownOnID).InputViewStart + (Control(__UI_MouseDownOnID).LastVisibleItem - 1)
                            IF Control(__UI_MouseDownOnID).InputViewStart > Control(__UI_MouseDownOnID).Max - Control(__UI_MouseDownOnID).LastVisibleItem - 1 THEN
                                Control(__UI_MouseDownOnID).InputViewStart = Control(__UI_MouseDownOnID).Max - Control(__UI_MouseDownOnID).LastVisibleItem - 1
                            END IF
                            __UI_MouseDownOnScrollbar = TIMER - .25
                        END IF
                    ELSEIF Control(__UI_MouseDownOnID).Type = __UI_Type_TextBox THEN
                        _FONT Control(__UI_MouseDownOnID).Font
                        IF NOT Control(__UI_MouseDownOnID).Disabled AND Control(__UI_MouseDownOnID).HoveringVScrollbarButton = 1 AND TIMER - __UI_MouseDownOnScrollbar > .3 THEN
                            Control(__UI_MouseDownOnID).FirstVisibleLine = Control(__UI_MouseDownOnID).FirstVisibleLine - 1
                            IF Control(__UI_MouseDownOnID).FirstVisibleLine < 0 THEN Control(__UI_MouseDownOnID).FirstVisibleLine = 1
                        ELSEIF NOT Control(__UI_MouseDownOnID).Disabled AND Control(__UI_MouseDownOnID).HoveringVScrollbarButton = 2 AND TIMER - __UI_MouseDownOnScrollbar > .3 THEN
                            IF Control(__UI_MouseDownOnID).FirstVisibleLine < __UI_CountLines(__UI_MouseDownOnID) - Control(__UI_MouseDownOnID).Height \ uspacing& + 1 THEN
                                Control(__UI_MouseDownOnID).FirstVisibleLine = Control(__UI_MouseDownOnID).FirstVisibleLine + 1
                            END IF
                        ELSEIF NOT Control(__UI_MouseDownOnID).Disabled AND Control(__UI_MouseDownOnID).HoveringVScrollbarButton = 4 AND TIMER - __UI_MouseDownOnScrollbar < .3 THEN
                            Control(__UI_MouseDownOnID).InputViewStart = Control(__UI_MouseDownOnID).InputViewStart - (Control(__UI_MouseDownOnID).LastVisibleItem - 1)
                        ELSEIF NOT Control(__UI_MouseDownOnID).Disabled AND Control(__UI_MouseDownOnID).HoveringVScrollbarButton = 5 AND TIMER - __UI_MouseDownOnScrollbar < .3 THEN
                            Control(__UI_MouseDownOnID).InputViewStart = Control(__UI_MouseDownOnID).InputViewStart + (Control(__UI_MouseDownOnID).LastVisibleItem - 1)
                            IF Control(__UI_MouseDownOnID).InputViewStart > Control(__UI_MouseDownOnID).Max - Control(__UI_MouseDownOnID).LastVisibleItem - 1 THEN
                                Control(__UI_MouseDownOnID).InputViewStart = Control(__UI_MouseDownOnID).Max - Control(__UI_MouseDownOnID).LastVisibleItem - 1
                            END IF
                        END IF
                    END IF
                    IF Control(__UI_MouseDownOnID).Type = __UI_Type_TrackBar AND NOT Control(__UI_MouseDownOnID).Disabled THEN
                        Control(__UI_HoveringID).Value = __UI_MAP((__UI_MouseLeft - (ContainerOffsetLeft + Control(__UI_HoveringID).Left)), 0, Control(__UI_HoveringID).Width, Control(__UI_HoveringID).Min, Control(__UI_HoveringID).Max)
                        IF Control(__UI_HoveringID).Value < Control(__UI_HoveringID).Min THEN
                            Control(__UI_HoveringID).Value = Control(__UI_HoveringID).Min
                        END IF
                        IF Control(__UI_HoveringID).Value > Control(__UI_HoveringID).Max THEN
                            Control(__UI_HoveringID).Value = Control(__UI_HoveringID).Max
                        END IF
                    END IF
                END IF
            END IF
            IF __UI_MouseDownOnID = 0 AND Control(__UI_PreviousMouseDownOnID).Type = __UI_Type_TrackBar AND NOT Control(__UI_PreviousMouseDownOnID).Disabled THEN
                Control(__UI_PreviousMouseDownOnID).Value = __UI_MAP((__UI_MouseLeft - (Control(Control(__UI_PreviousMouseDownOnID).ParentID).Left + Control(__UI_PreviousMouseDownOnID).Left)), 0, Control(__UI_PreviousMouseDownOnID).Width, Control(__UI_PreviousMouseDownOnID).Min, Control(__UI_PreviousMouseDownOnID).Max)
                IF Control(__UI_PreviousMouseDownOnID).Value > Control(__UI_PreviousMouseDownOnID).Max THEN Control(__UI_PreviousMouseDownOnID).Value = Control(__UI_PreviousMouseDownOnID).Max
                IF Control(__UI_PreviousMouseDownOnID).Value < Control(__UI_PreviousMouseDownOnID).Min THEN Control(__UI_PreviousMouseDownOnID).Value = Control(__UI_PreviousMouseDownOnID).Min
            END IF
        END IF
    ELSE
        IF __UI_MouseIsDown THEN
            IF __UI_IsDragging THEN
                __UI_IsDragging = False
                __UI_DraggingID = 0
                __UI_Snapped = 0
                __UI_SnappedByProximityX = False
                __UI_SnappedByProximityY = False
                __UI_ForceRedraw = True
            END IF
            IF __UI_IsResizing THEN
                __UI_IsResizing = False
                __UI_ResizingID = 0
            END IF
            IF __UI_DraggingThumb THEN
                __UI_DraggingThumb = False
                __UI_DraggingThumbOnID = 0
            END IF
            IF __UI_PreviousMouseDownOnID > 0 THEN
                __UI_MouseUp __UI_PreviousMouseDownOnID
            ELSE
                IF __UI_MouseDownOnID > 0 THEN __UI_MouseUp __UI_MouseDownOnID
            END IF
            IF NOT __UI_DesignMode AND __UI_MouseDownOnID = __UI_HoveringID AND __UI_HoveringID > 0 THEN
                IF NOT Control(__UI_HoveringID).Disabled THEN
                    SELECT CASE Control(__UI_HoveringID).Type
                        CASE __UI_Type_RadioButton
                            SetRadioButtonValue __UI_HoveringID
                        CASE __UI_Type_CheckBox, __UI_Type_ToggleSwitch
                            Control(__UI_HoveringID).Value = NOT Control(__UI_HoveringID).Value
                            __UI_ValueChanged __UI_HoveringID
                            Control(__UI_HoveringID).LastChange = TIMER
                        CASE __UI_Type_TextBox
                            IF Control(__UI_HoveringID).HasVScrollbar AND __UI_MouseLeft >= Control(__UI_HoveringID).Left + Control(__UI_HoveringID).Width - 25 + ContainerOffsetLeft THEN
                                IF __UI_MouseTop >= Control(__UI_HoveringID).Top + ContainerOffsetTop AND NOT Control(__UI_HoveringID).Disabled AND __UI_MouseTop <= Control(__UI_HoveringID).Top + ContainerOffsetTop + __UI_ScrollbarButtonHeight THEN
                                    Control(__UI_MouseDownOnID).FirstVisibleLine = Control(__UI_MouseDownOnID).FirstVisibleLine - 1
                                    IF Control(__UI_MouseDownOnID).FirstVisibleLine < 0 THEN Control(__UI_MouseDownOnID).FirstVisibleLine = 1
                                ELSEIF __UI_MouseTop >= Control(__UI_HoveringID).VScrollbarButton2Top + ContainerOffsetTop AND NOT Control(__UI_HoveringID).Disabled THEN
                                    IF Control(__UI_MouseDownOnID).FirstVisibleLine < __UI_CountLines(__UI_MouseDownOnID) - Control(__UI_MouseDownOnID).Height \ uspacing& + 1 THEN
                                        Control(__UI_MouseDownOnID).FirstVisibleLine = Control(__UI_MouseDownOnID).FirstVisibleLine + 1
                                    END IF
                                END IF
                            ELSE
                                IF TIMER - JustEnteredTextBox > .3 THEN
                                    _FONT (Control(__UI_HoveringID).Font)
                                END IF
                            END IF
                        CASE __UI_Type_ListBox
                            IF Control(__UI_HoveringID).HasVScrollbar AND __UI_MouseLeft >= Control(__UI_HoveringID).Left + Control(__UI_HoveringID).Width - 25 + ContainerOffsetLeft THEN
                                IF __UI_MouseTop >= Control(__UI_HoveringID).Top + ContainerOffsetTop AND NOT Control(__UI_HoveringID).Disabled AND __UI_MouseTop <= Control(__UI_HoveringID).Top + ContainerOffsetTop + __UI_ScrollbarButtonHeight THEN
                                    Control(__UI_HoveringID).InputViewStart = Control(__UI_HoveringID).InputViewStart - 1
                                ELSEIF __UI_MouseTop >= Control(__UI_HoveringID).VScrollbarButton2Top + ContainerOffsetTop AND NOT Control(__UI_HoveringID).Disabled THEN
                                    IF Control(__UI_HoveringID).InputViewStart + Control(__UI_HoveringID).LastVisibleItem <= Control(__UI_HoveringID).Max THEN
                                        Control(__UI_HoveringID).InputViewStart = Control(__UI_HoveringID).InputViewStart + 1
                                    END IF
                                END IF
                            ELSE
                                IF Control(__UI_HoveringID).Max > 0 THEN
                                    _FONT Control(__UI_HoveringID).Font
                                    ThisItem% = ((__UI_MouseTop - (ContainerOffsetTop + Control(__UI_HoveringID).Top) - (ABS(Control(__UI_HoveringID).HasBorder) * __UI_DefaultCaptionIndent)) \ Control(__UI_HoveringID).ItemHeight) + Control(__UI_HoveringID).InputViewStart
                                    IF ThisItem% >= Control(__UI_HoveringID).Min AND ThisItem% <= Control(__UI_HoveringID).Max THEN
                                        Control(__UI_HoveringID).Value = ThisItem%
                                    ELSE
                                        Control(__UI_HoveringID).Value = 0
                                    END IF
                                END IF
                                IF __UI_HoveringID = __UI_ActiveDropdownList THEN
                                    __UI_Focus = __UI_ParentDropdownList
                                    Control(__UI_ParentDropdownList).Value = Control(__UI_ActiveDropdownList).Value
                                    IF Control(__UI_ParentDropdownList).PreviousValue <> Control(__UI_ParentDropdownList).Value THEN
                                        __UI_ValueChanged __UI_ParentDropdownList
                                        Control(__UI_ParentDropdownList).PreviousValue = Control(__UI_ParentDropdownList).Value
                                        Control(__UI_ParentDropdownList).Redraw = True
                                    END IF
                                    __UI_DestroyControl Control(__UI_ActiveDropdownList)
                                ELSE
                                    IF Control(__UI_HoveringID).PreviousValue <> Control(__UI_HoveringID).Value THEN
                                        __UI_ValueChanged __UI_HoveringID
                                        Control(__UI_HoveringID).PreviousValue = Control(__UI_HoveringID).Value
                                        Control(__UI_HoveringID).Redraw = True
                                    END IF
                                END IF
                            END IF
                        CASE __UI_Type_DropdownList
                            IF __UI_ActiveDropdownList = 0 THEN
                                __UI_ActivateDropdownlist Control(__UI_HoveringID)
                            ELSE
                                __UI_DestroyControl Control(__UI_ActiveDropdownList)
                            END IF
                        CASE __UI_Type_MenuBar
                            IF __UI_TotalActiveMenus > 0 AND NOT __UI_JustOpenedMenu THEN
                                __UI_Focus = __UI_PreviousFocus
                            END IF
                        CASE __UI_Type_MenuItem
                            IF Control(__UI_HoveringID).SubMenu THEN
                                __UI_ActivateMenu Control(__UI_HoveringID), False
                            ELSE
                                __UI_Focus = __UI_PreviousFocus
                                __UI_DestroyControl Control(__UI_ActiveMenu(__UI_TotalActiveMenus))
                                __UI_ForceRedraw = True
                                IF Control(__UI_HoveringID).BulletStyle = __UI_Bullet THEN SetRadioButtonValue __UI_HoveringID
                            END IF
                    END SELECT
                    __UI_LastMouseClick = TIMER
                    __UI_JustOpenedMenu = False
                    __UI_MouseDownOnID = 0
                    ProcessClick:
                    IF RTRIM$(Control(Control(__UI_HoveringID).ParentID).Name) = "__UI_TextFieldMenu" OR RTRIM$(Control(Control(__UI_HoveringID).ParentID).Name) = "__UI_PreviewMenu" THEN
                        IF RTRIM$(Control(Control(__UI_HoveringID).ParentID).Name) = "__UI_TextFieldMenu" THEN
                            __UI_Focus = __UI_PreviousFocus
                        ELSEIF RTRIM$(Control(Control(__UI_HoveringID).ParentID).Name) = "__UI_PreviewMenu" THEN
                            __UI_DestroyControl Control(__UI_ActiveMenu(__UI_TotalActiveMenus))
                        END IF
                        ProcessHotkey:
                        __UI_FillSelectedText 0, 0
                        IF UCASE$(LEFT$(Control(__UI_HoveringID).Name, 16)) = "__UI_PREVIEWMENU" THEN __UI_KeyPress 216
                        SELECT CASE UCASE$(RTRIM$(Control(__UI_HoveringID).Name))
                            CASE "__UI_TEXTMENUCUT"
                                IF LEN(__UI_SelectedText) > 0 THEN
                                    _CLIPBOARD$ = __UI_SelectedText
                                    __UI_DeleteSelection
                                END IF
                            CASE "__UI_TEXTMENUCOPY"
                                IF LEN(__UI_SelectedText) > 0 THEN _CLIPBOARD$ = __UI_SelectedText
                            CASE "__UI_TEXTMENUPASTE"
                                DIM ContextMenuPaste AS _BYTE
                                ContextMenuPaste = True
                                GOSUB PasteIntoTextBox
                            CASE "__UI_TEXTMENUDELETE"
                                __UI_DeleteSelection
                            CASE "__UI_TEXTMENUSELECT"
                                IF LEN(Text(__UI_Focus)) > 0 THEN
                                    Control(__UI_Focus).Cursor = LEN(Text(__UI_Focus))
                                    Control(__UI_Focus).SelectionStart = 0
                                    Control(__UI_Focus).TextIsSelected = True
                                END IF
                            CASE "__UI_PREVIEWMENUALIGNLEFT"
                                __UI_KeyPress 201
                            CASE "__UI_PREVIEWMENUALIGNRIGHT"
                                __UI_KeyPress 202
                            CASE "__UI_PREVIEWMENUALIGNTOPS"
                                __UI_KeyPress 203
                            CASE "__UI_PREVIEWMENUALIGNBOTTOMS"
                                __UI_KeyPress 204
                            CASE "__UI_PREVIEWMENUALIGNCENTERSV"
                                __UI_KeyPress 205
                            CASE "__UI_PREVIEWMENUALIGNCENTERSH"
                                __UI_KeyPress 206
                            CASE "__UI_PREVIEWMENUALIGNCENTERV"
                                __UI_KeyPress 207
                            CASE "__UI_PREVIEWMENUALIGNCENTERH"
                                __UI_KeyPress 208
                            CASE "__UI_PREVIEWMENUDISTRIBUTEV"
                                __UI_KeyPress 209
                            CASE "__UI_PREVIEWMENUDISTRIBUTEH"
                                __UI_KeyPress 210
                            CASE "__UI_PREVIEWMENUIMAGEORIGINALSIZE"
                                IF LEN(Text(__UI_FirstSelectedID)) THEN
                                    __UI_RestoreImageOriginalSize
                                END IF
                            CASE UCASE$("__UI_PreviewMenuNumericOnly")
                                __UI_KeyPress 223
                            CASE UCASE$("__UI_PreviewMenuSetDefaultButton")
                                IF __UI_DefaultButtonID = __UI_FirstSelectedID THEN
                                    __UI_DefaultButtonID = 0
                                ELSE
                                    __UI_DefaultButtonID = __UI_FirstSelectedID
                                END IF
                            CASE UCASE$("__UI_PreviewMenuNewMenuBar")
                                __UI_KeyPress 224
                            CASE UCASE$("__UI_PreviewMenuConvertType")
                                __UI_KeyPress 225
                            CASE UCASE$("__UI_PreviewMenuNewContextMenu")
                                __UI_KeyPress 226
                            CASE UCASE$("__UI_PreviewMenuShowInvisibleControls")
                                __UI_KeyPress 227
                            CASE UCASE$("__UI_PreviewMenuBindControls")
                                __UI_KeyPress 228
                            CASE "__UI_PREVIEWMENUCUT": GOTO ControlCut
                            CASE "__UI_PREVIEWMENUCOPY": GOTO ControlCopy
                            CASE "__UI_PREVIEWMENUPASTE": GOTO ControlPaste
                            CASE "__UI_PREVIEWMENUDELETE": GOTO ControlDelete
                            CASE "__UI_PREVIEWMENUSELECT": GOTO ControlSelect
                        END SELECT
                        __UI_KeyPress __UI_Focus
                    ELSE
                        __UI_Click __UI_HoveringID
                        __UI_KeyHit = 0
                    END IF
                ELSE
                    __UI_CloseAllMenus
                    __UI_Focus = __UI_PreviousFocus
                    __UI_ForceRedraw = True
                END IF
            END IF
            __UI_IsSelectingText = False
            __UI_IsSelectingTextOnID = 0
            __UI_MouseIsDown = False
            __UI_MouseDownOnID = 0
            __UI_PreviousMouseDownOnID = 0
            __UI_SelectionRectangle = False
        END IF
    END IF
    IF __UI_IsDragging AND __UI_DraggingID = __UI_FormID THEN __UI_IsDragging = False
    __UI_Snapped = False
    __UI_SnappedByProximityX = False
    __UI_SnappedByProximityY = False
    __UI_SnappedX = -1
    __UI_SnappedY = -1
    DIM SetNewParent AS _BYTE, LeftOffset AS INTEGER, TopOffset AS INTEGER
    IF __UI_IsDragging AND __UI_DraggingID > 0 THEN
        IF Control(__UI_DraggingID).Type <> __UI_Type_Frame THEN
            IF Control(__UI_BelowHoveringID).Type = __UI_Type_Frame OR Control(__UI_HoveringID).Type = __UI_Type_Frame THEN
                IF Control(__UI_HoveringID).Type = __UI_Type_Frame THEN __UI_BelowHoveringID = __UI_HoveringID
                IF Control(__UI_FirstSelectedID).ParentID <> __UI_BelowHoveringID THEN
                    SetNewParent = True
                    LeftOffset = Control(__UI_BelowHoveringID).Left
                    TopOffset = Control(__UI_BelowHoveringID).Top
                END IF
            ELSEIF Control(__UI_BelowHoveringID).Type = __UI_Type_Form OR __UI_BelowHoveringID = 0 THEN
                IF Control(__UI_FirstSelectedID).ParentID > 0 THEN
                    LeftOffset = Control(Control(__UI_FirstSelectedID).ParentID).Left
                    TopOffset = Control(Control(__UI_FirstSelectedID).ParentID).Top
                    __UI_BelowHoveringID = 0
                    SetNewParent = True
                END IF
            END IF
        END IF
        FOR i = 1 TO UBOUND(Control)
            IF Control(i).ControlIsSelected THEN
                Control(i).Top = Control(i).Top + (__UI_MouseTop - __UI_DragY)
                Control(i).Left = Control(i).Left + (__UI_MouseLeft - __UI_DragX)
                IF SetNewParent THEN
                    Control(i).ParentID = __UI_BelowHoveringID
                    Control(i).ParentName = Control(__UI_BelowHoveringID).Name
                    IF __UI_BelowHoveringID = 0 THEN
                        Control(i).Top = Control(i).Top + TopOffset
                        Control(i).Left = Control(i).Left + LeftOffset
                    ELSE
                        Control(i).Top = Control(i).Top - TopOffset
                        Control(i).Left = Control(i).Left - LeftOffset
                    END IF
                END IF
            END IF
        NEXT
        IF (_KEYDOWN(100305) = 0 AND _KEYDOWN(100306) = 0) AND __UI_SnapLines THEN
            DIM MouseXOffset AS INTEGER, MouseYOffset AS INTEGER
            DIM XSnapOffset AS INTEGER, YSnapOffset AS INTEGER
            DIM PrevXSnapOffset AS INTEGER, PrevYSnapOffset AS INTEGER
            PrevXSnapOffset = 10
            PrevYSnapOffset = 10
            MouseYOffset = ABS(__UI_MouseTop - (Control(__UI_DraggingID).Top + Control(Control(__UI_DraggingID).ParentID).Top + OriginalDragY))
            MouseXOffset = ABS(__UI_MouseLeft - (Control(__UI_DraggingID).Left + Control(Control(__UI_DraggingID).ParentID).Left + OriginalDragX))
            IF Control(__UI_DraggingID).ParentID = 0 THEN
                XSnapOffset = Control(__UI_DraggingID).Left
                IF XSnapOffSet >= __UI_SnapDistanceFromForm / 2 AND XSnapOffset =< __UI_SnapDistanceFromForm AND MouseXOffset < 10 THEN
                    Control(__UI_DraggingID).Left = __UI_SnapDistanceFromForm
                    __UI_Snapped = True
                    __UI_SnappedX = __UI_SnapDistanceFromForm
                    __UI_SnappedByProximityX = 3
                END IF
                XSnapOffset = ABS((Control(__UI_DraggingID).Left + Control(__UI_DraggingID).Width + __UI_SnapDistanceFromForm) - Control(__UI_FormID).Width)
                IF XSnapOffSet < __UI_SnapDistanceFromForm AND MouseXOffset < 10 THEN
                    Control(__UI_DraggingID).Left = Control(__UI_FormID).Width - (Control(__UI_DraggingID).Width + __UI_SnapDistanceFromForm)
                    __UI_Snapped = True
                    __UI_SnappedX = Control(__UI_DraggingID).Left
                    __UI_SnappedByProximityX = 4
                END IF
                YSnapOffset = Control(__UI_DraggingID).Top
                IF YSnapOffSet >= __UI_SnapDistanceFromForm / 2 AND YSnapOffset =< __UI_SnapDistanceFromForm AND MouseYOffset < 10 THEN
                    Control(__UI_DraggingID).Top = __UI_SnapDistanceFromForm
                    __UI_Snapped = True
                    __UI_SnappedY = __UI_SnapDistanceFromForm
                    __UI_SnappedByProximityY = 3
                END IF
                YSnapOffset = ABS((Control(__UI_DraggingID).Top + Control(__UI_DraggingID).Height + __UI_SnapDistanceFromForm) - Control(__UI_FormID).Height)
                IF YSnapOffSet < __UI_SnapDistanceFromForm AND MouseYOffset < 10 THEN
                    Control(__UI_DraggingID).Top = Control(__UI_FormID).Height - (Control(__UI_DraggingID).Height + __UI_SnapDistanceFromForm)
                    __UI_Snapped = True
                    __UI_SnappedY = Control(__UI_DraggingID).Top
                    __UI_SnappedByProximityY = 4
                END IF
                YSnapOffset = ABS(((Control(__UI_FormID).Height - __UI_MenuBarOffsetV) / 2 + __UI_MenuBarOffsetV) - (Control(__UI_DraggingID).Top + Control(__UI_DraggingID).Height / 2))
                IF YSnapOffset < 5 AND MouseYOffset < 10 THEN
                    Control(__UI_DraggingID).Top = (Control(__UI_FormID).Height - __UI_MenuBarOffsetV) / 2 + __UI_MenuBarOffsetV - Control(__UI_DraggingID).Height / 2
                    __UI_Snapped = True
                    __UI_SnappedY = (Control(__UI_FormID).Height - __UI_MenuBarOffsetV) / 2 + __UI_MenuBarOffsetV
                END IF
                XSnapOffset = ABS((Control(__UI_FormID).Width / 2) - (Control(__UI_DraggingID).Left + Control(__UI_DraggingID).Width / 2))
                IF XSnapOffset < 5 AND MouseXOffset < 10 THEN
                    Control(__UI_DraggingID).Left = Control(__UI_FormID).Width / 2 - Control(__UI_DraggingID).Width / 2
                    __UI_Snapped = True
                    __UI_SnappedX = Control(__UI_FormID).Width / 2
                END IF
            END IF
            FOR i = 1 TO UBOUND(Control)
                IF Control(i).ParentID = Control(__UI_DraggingID).ParentID AND Control(i).Type > 0 AND _
                    i <> __UI_DraggingID AND Control(i).Type <> __UI_Type_ContextMenu AND Control(i).Type <> __UI_Type_Form AND Control(i).Type <> __UI_Type_Font AND Control(i).Type <> __UI_Type_MenuItem AND Control(i).Type <> __UI_Type_MenuBar AND Control(i).Type <> __UI_Type_MenuPanel AND _
                    Control(i).ControlIsSelected = False THEN
                    YSnapOffset = ABS((Control(i).Top + Control(Control(i).ParentID).Top) - (Control(__UI_DraggingID).Top + Control(Control(__UI_DraggingID).ParentID).Top))
                    IF YSnapOffset < 5 AND YSnapOffset < PrevYSnapOffset AND MouseYOffset < 10 THEN
                        PrevYSnapOffset = YSnapOffset
                        Control(__UI_DraggingID).Top = Control(i).Top + Control(Control(i).ParentID).Top
                        __UI_Snapped = True
                        __UI_SnappedY = Control(i).Top + Control(Control(i).ParentID).Top
                        __UI_SnappedYID = i
                    END IF
                    YSnapOffset = ABS((Control(i).Top + Control(i).Height / 2 + Control(Control(i).ParentID).Top) - (Control(__UI_DraggingID).Top + Control(__UI_DraggingID).Height / 2 + Control(Control(__UI_DraggingID).ParentID).Top))
                    IF YSnapOffset < 5 AND YSnapOffset < PrevYSnapOffset AND MouseYOffset < 10 THEN
                        PrevYSnapOffset = YSnapOffset
                        Control(__UI_DraggingID).Top = Control(i).Top + Control(i).Height / 2 - Control(__UI_DraggingID).Height / 2 + Control(Control(i).ParentID).Top
                        __UI_Snapped = True
                        __UI_SnappedY = Control(i).Top + Control(i).Height / 2 + Control(Control(i).ParentID).Top
                        __UI_SnappedYID = i
                    END IF
                    YSnapOffset = ABS((Control(i).Top + Control(i).Height + Control(Control(i).ParentID).Top) - (Control(__UI_DraggingID).Top + Control(__UI_DraggingID).Height + Control(Control(__UI_DraggingID).ParentID).Top))
                    IF YSnapOffset < 5 AND YSnapOffset < PrevYSnapOffset AND MouseYOffset < 10 THEN
                        PrevYSnapOffset = YSnapOffset
                        Control(__UI_DraggingID).Top = Control(i).Top + Control(i).Height - Control(__UI_DraggingID).Height + Control(Control(i).ParentID).Top
                        __UI_Snapped = True
                        __UI_SnappedY = Control(i).Top + Control(i).Height + Control(Control(i).ParentID).Top
                        __UI_SnappedYID = i
                    END IF
                    XSnapOffset = ABS((Control(i).Left + Control(Control(i).ParentID).Left) - (Control(__UI_DraggingID).Left + Control(Control(__UI_DraggingID).ParentID).Left))
                    IF XSnapOffset < 5 AND XSnapOffset < PrevXSnapOffset AND MouseXOffset < 10 THEN
                        PrevXSnapOffset = XSnapOffset
                        Control(__UI_DraggingID).Left = Control(i).Left + Control(Control(i).ParentID).Left
                        __UI_Snapped = True
                        __UI_SnappedX = Control(i).Left + Control(Control(i).ParentID).Left
                        __UI_SnappedXID = i
                    END IF
                    XSnapOffset = ABS((Control(i).Left + Control(i).Width / 2 + Control(Control(i).ParentID).Left) - (Control(__UI_DraggingID).Left + Control(__UI_DraggingID).Width / 2 + Control(Control(__UI_DraggingID).ParentID).Left))
                    IF XSnapOffset < 5 AND XSnapOffset < PrevXSnapOffset AND MouseXOffset < 10 THEN
                        PrevXSnapOffset = XSnapOffset
                        Control(__UI_DraggingID).Left = Control(i).Left + Control(i).Width / 2 - Control(__UI_DraggingID).Width / 2 + Control(Control(i).ParentID).Left
                        __UI_Snapped = True
                        __UI_SnappedX = Control(i).Left + Control(i).Width / 2 + Control(Control(i).ParentID).Left
                        __UI_SnappedXID = i
                    END IF
                    XSnapOffset = ABS((Control(i).Left + Control(i).Width + Control(Control(i).ParentID).Left) - (Control(__UI_DraggingID).Left + Control(__UI_DraggingID).Width + Control(Control(__UI_DraggingID).ParentID).Left))
                    IF XSnapOffset < 5 AND XSnapOffset < PrevXSnapOffset AND MouseXOffset < 10 THEN
                        PrevXSnapOffset = XSnapOffset
                        Control(__UI_DraggingID).Left = Control(i).Left + Control(i).Width - Control(__UI_DraggingID).Width + Control(Control(i).ParentID).Left
                        __UI_Snapped = True
                        __UI_SnappedX = Control(i).Left + Control(i).Width + Control(Control(i).ParentID).Left
                        __UI_SnappedXID = i
                    END IF
                    XSnapOffset = ABS((Control(i).Left + Control(i).Width + Control(Control(i).ParentID).Left + __UI_SnapDistance) - (Control(__UI_DraggingID).Left + Control(Control(__UI_DraggingID).ParentID).Left))
                    IF XSnapOffset < 5 AND XSnapOffset < PrevXSnapOffset AND MouseXOffset < 10 THEN
                        IF (Control(__UI_DraggingID).Top <= Control(i).Top + Control(i).Height AND _
                           Control(__UI_DraggingID).Top >= Control(i).Top) OR _
                           (Control(__UI_DraggingID).Top + Control(__UI_DraggingID).Height >= Control(i).Top AND _
                           Control(__UI_DraggingID).Top + Control(__UI_DraggingID).Height <= Control(i).Top + Control(i).Height) THEN
                            PrevXSnapOffset = XSnapOffset
                            Control(__UI_DraggingID).Left = Control(i).Left + Control(i).Width + Control(Control(i).ParentID).Left + __UI_SnapDistance
                            __UI_Snapped = True
                            __UI_SnappedX = Control(i).Left + Control(i).Width + Control(Control(i).ParentID).Left + __UI_SnapDistance
                            __UI_SnappedXID = i
                            __UI_SnappedByProximityX = 1
                        END IF
                    END IF
                    XSnapOffset = ABS((Control(i).Left - __UI_SnapDistance) - (Control(__UI_DraggingID).Left + Control(__UI_DraggingID).Width + Control(Control(__UI_DraggingID).ParentID).Left))
                    IF XSnapOffset < 5 AND XSnapOffset < PrevXSnapOffset AND MouseXOffset < 10 THEN
                        IF (Control(__UI_DraggingID).Top <= Control(i).Top + Control(i).Height AND _
                           Control(__UI_DraggingID).Top >= Control(i).Top) OR _
                           (Control(__UI_DraggingID).Top + Control(__UI_DraggingID).Height >= Control(i).Top AND _
                           Control(__UI_DraggingID).Top + Control(__UI_DraggingID).Height <= Control(i).Top + Control(i).Height) THEN
                            PrevXSnapOffset = XSnapOffset
                            Control(__UI_DraggingID).Left = Control(i).Left - Control(__UI_DraggingID).Width - __UI_SnapDistance
                            __UI_Snapped = True
                            __UI_SnappedX = Control(i).Left - Control(__UI_DraggingID).Width - __UI_SnapDistance
                            __UI_SnappedXID = i
                            __UI_SnappedByProximityX = 2
                        END IF
                    END IF
                    YSnapOffset = ABS((Control(i).Top + Control(Control(i).ParentID).Top - __UI_SnapDistance) - (Control(__UI_DraggingID).Top + Control(__UI_DraggingID).Height + Control(Control(__UI_DraggingID).ParentID).Top))
                    IF YSnapOffset < 5 AND YSnapOffset < PrevYSnapOffset AND MouseYOffset < 10 THEN
                        IF (Control(__UI_DraggingID).Left <= Control(i).Left + Control(i).Width AND _
                           Control(__UI_DraggingID).Left >= Control(i).Left) OR _
                           (Control(__UI_DraggingID).Left + Control(__UI_DraggingID).Width >= Control(i).Left AND _
                           Control(__UI_DraggingID).Left + Control(__UI_DraggingID).Width <= Control(i).Left + Control(i).Width) THEN
                            PrevYSnapOffset = YSnapOffset
                            Control(__UI_DraggingID).Top = Control(i).Top + Control(Control(i).ParentID).Top - Control(__UI_DraggingID).Height - __UI_SnapDistance
                            __UI_Snapped = True
                            __UI_SnappedY = Control(i).Top + Control(Control(i).ParentID).Top - Control(__UI_DraggingID).Height - __UI_SnapDistance
                            __UI_SnappedYID = i
                            __UI_SnappedByProximityY = 1
                        END IF
                    END IF
                    YSnapOffset = ABS((Control(i).Top + Control(i).Height + Control(Control(i).ParentID).Top + __UI_SnapDistance) - (Control(__UI_DraggingID).Top + Control(Control(__UI_DraggingID).ParentID).Top))
                    IF YSnapOffset < 5 AND YSnapOffset < PrevYSnapOffset AND MouseYOffset < 10 THEN
                        IF (Control(__UI_DraggingID).Left <= Control(i).Left + Control(i).Width AND _
                           Control(__UI_DraggingID).Left >= Control(i).Left) OR _
                           (Control(__UI_DraggingID).Left + Control(__UI_DraggingID).Width >= Control(i).Left AND _
                           Control(__UI_DraggingID).Left + Control(__UI_DraggingID).Width <= Control(i).Left + Control(i).Width) THEN
                            PrevYSnapOffset = YSnapOffset
                            Control(__UI_DraggingID).Top = Control(i).Top + Control(Control(i).ParentID).Top + Control(i).Height + __UI_SnapDistance
                            __UI_Snapped = True
                            __UI_SnappedY = Control(i).Top + Control(Control(i).ParentID).Top + Control(i).Height + __UI_SnapDistance
                            __UI_SnappedYID = i
                            __UI_SnappedByProximityY = 2
                        END IF
                    END IF
                END IF
            NEXT
        END IF
        IF (_KEYDOWN(100305) OR _KEYDOWN(100306)) THEN __UI_Snapped = False: __UI_SnappedX = -1: __UI_SnappedY=-1
        IF __UI_SnappedX = -1 THEN Control(__UI_DraggingID).Left = __UI_MouseLeft - OriginalDragX
        IF __UI_SnappedY = -1 THEN Control(__UI_DraggingID).Top = __UI_MouseTop - OriginalDragY
        Control(__UI_DraggingID).Left = Control(__UI_DraggingID).Left - Control(Control(__UI_DraggingID).ParentID).Left
        Control(__UI_DraggingID).Top = Control(__UI_DraggingID).Top - Control(Control(__UI_DraggingID).ParentID).Top
        IF __UI_TotalSelectedControls > 1 THEN
            FOR i = 1 TO UBOUND(Control)
                IF Control(i).ControlIsSelected AND i <> __UI_DraggingID THEN
                    Control(i).Left = Control(__UI_DraggingID).Left - Control(i).LeftOffsetFromFirstSelected
                    Control(i).Top = Control(__UI_DraggingID).Top - Control(i).TopOffsetFromFirstSelected
                END IF
            NEXT
        END IF
        __UI_DragY = __UI_MouseTop
        __UI_DragX = __UI_MouseLeft
    END IF
    IF __UI_IsResizing AND __UI_ResizingID > 0 THEN
        __UI_ForceRedraw = True
        FOR i = 1 TO UBOUND(Control)
            IF Control(i).ControlIsSelected THEN
                IF __UI_ResizeHandleHover = 1 THEN
                    IF __UI_Type(Control(i).Type).RestrictResize = __UI_CantResizeH OR __UI_Type(Control(__UI_HoveringID).Type).RestrictResize = __UI_CantResize THEN _CONTINUE
                    IF __UI_ShiftIsDown THEN
                        Control(i).Width = Control(i).Width + (2 * (__UI_MouseLeft - __UI_DragX)): IF Control(i).Width < 4 THEN Control(i).Width = 4
                        IF Control(i).Width > 4 THEN Control(i).Left = Control(i).Left - (__UI_MouseLeft - __UI_DragX)
                    ELSE
                        Control(i).Width = Control(i).Width + (__UI_MouseLeft - __UI_DragX): IF Control(i).Width < 4 THEN Control(i).Width = 4
                    END IF
                END IF
                IF __UI_ResizeHandleHover = 2 THEN
                    IF __UI_Type(Control(i).Type).RestrictResize = __UI_CantResizeV OR __UI_Type(Control(__UI_HoveringID).Type).RestrictResize = __UI_CantResize THEN _CONTINUE
                    IF __UI_ShiftIsDown THEN
                        Control(i).Height = Control(i).Height + (2 * (__UI_MouseTop - __UI_DragY)): IF Control(i).Height < 4 THEN Control(i).Height = 4
                        IF Control(i).Height > 4 THEN Control(i).Top = Control(i).Top - (__UI_MouseTop - __UI_DragY)
                    ELSE
                        Control(i).Height = Control(i).Height + (__UI_MouseTop - __UI_DragY): IF Control(i).Height < 4 THEN Control(i).Height = 4
                    END IF
                END IF
                IF __UI_ResizeHandleHover = 3 THEN
                    IF __UI_Type(Control(i).Type).RestrictResize = __UI_CantResizeH OR __UI_Type(Control(__UI_HoveringID).Type).RestrictResize = __UI_CantResize THEN _CONTINUE
                    IF __UI_ShiftIsDown THEN
                        Control(i).Width = Control(i).Width - (2 * (__UI_MouseLeft - __UI_DragX)): IF Control(i).Width < 4 THEN Control(i).Width = 4
                        IF Control(i).Width > 4 THEN Control(i).Left = Control(i).Left + (__UI_MouseLeft - __UI_DragX)
                    ELSE
                        Control(i).Width = Control(i).Width - (__UI_MouseLeft - __UI_DragX): IF Control(i).Width < 4 THEN Control(i).Width = 4 ELSE Control(i).Left = Control(i).Left + (__UI_MouseLeft - __UI_DragX)
                    END IF
                END IF
                IF __UI_ResizeHandleHover = 4 THEN
                    IF __UI_Type(Control(i).Type).RestrictResize = __UI_CantResizeV OR __UI_Type(Control(__UI_HoveringID).Type).RestrictResize = __UI_CantResize THEN _CONTINUE
                    IF __UI_ShiftIsDown THEN
                        Control(i).Height = Control(i).Height - (2 * (__UI_MouseTop - __UI_DragY)): IF Control(i).Height < 4 THEN Control(i).Height = 4
                        IF Control(i).Height > 4 THEN Control(i).Top = Control(i).Top + (__UI_MouseTop - __UI_DragY)
                    ELSE
                        Control(i).Height = Control(i).Height - (__UI_MouseTop - __UI_DragY): IF Control(i).Height < 4 THEN Control(i).Height = 4 ELSE Control(i).Top = Control(i).Top + (__UI_MouseTop - __UI_DragY)
                    END IF
                END IF
                DIM OldAlignmentY AS INTEGER
                IF __UI_ResizeHandleHover = 5 THEN
                    IF __UI_ShiftIsDown THEN
                        IF __UI_Type(Control(i).Type).RestrictResize <> __UI_CantResizeH AND __UI_Type(Control(__UI_HoveringID).Type).RestrictResize <> __UI_CantResize THEN
                            Control(i).Width = Control(i).Width + (2 * (__UI_MouseLeft - __UI_DragX)): IF Control(i).Width < 4 THEN Control(i).Width = 4
                            IF Control(i).Width > 4 THEN Control(i).Left = Control(i).Left - (__UI_MouseLeft - __UI_DragX)
                        END IF
                        IF __UI_Type(Control(i).Type).RestrictResize = __UI_CantResizeV OR __UI_Type(Control(__UI_HoveringID).Type).RestrictResize = __UI_CantResize THEN _CONTINUE
                        Control(i).Height = Control(i).Height - (2 * (__UI_MouseTop - __UI_DragY)): IF Control(i).Height < 4 THEN Control(i).Height = 4
                        IF Control(i).Height > 4 THEN Control(i).Top = Control(i).Top + (__UI_MouseTop - __UI_DragY)
                        IF Control(i).Type = __UI_Type_PictureBox AND LEN(Text(i)) > 0 THEN
                            OldAlignmentY = Control(i).Top + Control(i).Height / 2
                            Control(i).Height = (_HEIGHT(Control(i).HelperCanvas) / _WIDTH(Control(i).HelperCanvas)) * Control(i).Width
                            Control(i).Top = OldAlignmentY - Control(i).Height / 2
                        END IF
                    ELSE
                        IF __UI_Type(Control(i).Type).RestrictResize <> __UI_CantResizeV AND __UI_Type(Control(__UI_HoveringID).Type).RestrictResize <> __UI_CantResize THEN
                            Control(i).Height = Control(i).Height - (__UI_MouseTop - __UI_DragY): IF Control(i).Height < 4 THEN Control(i).Height = 4 ELSE Control(i).Top = Control(i).Top + (__UI_MouseTop - __UI_DragY)
                        END IF
                        IF __UI_Type(Control(i).Type).RestrictResize = __UI_CantResizeH OR __UI_Type(Control(__UI_HoveringID).Type).RestrictResize = __UI_CantResize THEN _CONTINUE
                        Control(i).Width = Control(i).Width + (__UI_MouseLeft - __UI_DragX): IF Control(i).Width < 4 THEN Control(i).Width = 4
                        IF Control(i).Type = __UI_Type_PictureBox AND LEN(Text(i)) > 0 THEN
                            OldAlignmentY = Control(i).Top + Control(i).Height
                            Control(i).Height = (_HEIGHT(Control(i).HelperCanvas) / _WIDTH(Control(i).HelperCanvas)) * Control(i).Width
                            Control(i).Top = OldAlignmentY - Control(i).Height
                        END IF
                    END IF
                END IF
                IF __UI_ResizeHandleHover = 6 THEN
                    IF __UI_ShiftIsDown THEN
                        IF __UI_Type(Control(i).Type).RestrictResize <> __UI_CantResizeH AND __UI_Type(Control(__UI_HoveringID).Type).RestrictResize <> __UI_CantResize THEN
                            Control(i).Width = Control(i).Width - (2 * (__UI_MouseLeft - __UI_DragX)): IF Control(i).Width < 4 THEN Control(i).Width = 4
                            IF Control(i).Width > 4 THEN Control(i).Left = Control(i).Left + (__UI_MouseLeft - __UI_DragX)
                        END IF
                        IF __UI_Type(Control(i).Type).RestrictResize = __UI_CantResizeV OR __UI_Type(Control(__UI_HoveringID).Type).RestrictResize = __UI_CantResize THEN _CONTINUE
                        Control(i).Height = Control(i).Height - (2 * (__UI_MouseTop - __UI_DragY)): IF Control(i).Height < 4 THEN Control(i).Height = 4
                        IF Control(i).Height > 4 THEN Control(i).Top = Control(i).Top + (__UI_MouseTop - __UI_DragY)
                        IF Control(i).Type = __UI_Type_PictureBox AND LEN(Text(i)) > 0 THEN
                            OldAlignmentY = Control(i).Top + Control(i).Height / 2
                            Control(i).Height = (_HEIGHT(Control(i).HelperCanvas) / _WIDTH(Control(i).HelperCanvas)) * Control(i).Width
                            Control(i).Top = OldAlignmentY - Control(i).Height / 2
                        END IF
                    ELSE
                        IF __UI_Type(Control(i).Type).RestrictResize <> __UI_CantResizeV AND __UI_Type(Control(__UI_HoveringID).Type).RestrictResize <> __UI_CantResize THEN
                            Control(i).Height = Control(i).Height - (__UI_MouseTop - __UI_DragY): IF Control(i).Height < 4 THEN Control(i).Height = 4 ELSE Control(i).Top = Control(i).Top + (__UI_MouseTop - __UI_DragY)
                        END IF
                        IF __UI_Type(Control(i).Type).RestrictResize = __UI_CantResizeH OR __UI_Type(Control(__UI_HoveringID).Type).RestrictResize = __UI_CantResize THEN _CONTINUE
                        Control(i).Width = Control(i).Width - (__UI_MouseLeft - __UI_DragX): IF Control(i).Width < 4 THEN Control(i).Width = 4 ELSE Control(i).Left = Control(i).Left + (__UI_MouseLeft - __UI_DragX)
                        IF Control(i).Type = __UI_Type_PictureBox AND LEN(Text(i)) > 0 THEN
                            OldAlignmentY = Control(i).Top + Control(i).Height
                            Control(i).Height = (_HEIGHT(Control(i).HelperCanvas) / _WIDTH(Control(i).HelperCanvas)) * Control(i).Width
                            Control(i).Top = OldAlignmentY - Control(i).Height
                        END IF
                    END IF
                END IF
                IF __UI_ResizeHandleHover = 7 THEN
                    IF __UI_ShiftIsDown THEN
                        IF __UI_Type(Control(i).Type).RestrictResize <> __UI_CantResizeH AND __UI_Type(Control(__UI_HoveringID).Type).RestrictResize <> __UI_CantResize THEN
                            Control(i).Width = Control(i).Width + (2 * (__UI_MouseLeft - __UI_DragX)): IF Control(i).Width < 4 THEN Control(i).Width = 4
                            IF Control(i).Width > 4 THEN Control(i).Left = Control(i).Left - (__UI_MouseLeft - __UI_DragX)
                        END IF
                        IF __UI_Type(Control(i).Type).RestrictResize = __UI_CantResizeV OR __UI_Type(Control(__UI_HoveringID).Type).RestrictResize = __UI_CantResize THEN _CONTINUE
                        Control(i).Height = Control(i).Height + (2 * (__UI_MouseTop - __UI_DragY)): IF Control(i).Height < 4 THEN Control(i).Height = 4
                        IF Control(i).Height > 4 THEN Control(i).Top = Control(i).Top - (__UI_MouseTop - __UI_DragY)
                        IF Control(i).Type = __UI_Type_PictureBox AND LEN(Text(i)) > 0 THEN
                            OldAlignmentY = Control(i).Top + Control(i).Height / 2
                            Control(i).Height = (_HEIGHT(Control(i).HelperCanvas) / _WIDTH(Control(i).HelperCanvas)) * Control(i).Width
                            Control(i).Top = OldAlignmentY - Control(i).Height / 2
                        END IF
                    ELSE
                        IF __UI_Type(Control(i).Type).RestrictResize <> __UI_CantResizeV AND __UI_Type(Control(__UI_HoveringID).Type).RestrictResize <> __UI_CantResize THEN
                            Control(i).Height = Control(i).Height + (__UI_MouseTop - __UI_DragY): IF Control(i).Height < 4 THEN Control(i).Height = 4
                        END IF
                        IF __UI_Type(Control(i).Type).RestrictResize = __UI_CantResizeH OR __UI_Type(Control(__UI_HoveringID).Type).RestrictResize = __UI_CantResize THEN _CONTINUE
                        Control(i).Width = Control(i).Width + (__UI_MouseLeft - __UI_DragX): IF Control(i).Width < 4 THEN Control(i).Width = 4
                        IF Control(i).Type = __UI_Type_PictureBox AND LEN(Text(i)) > 0 THEN
                            Control(i).Height = (_HEIGHT(Control(i).HelperCanvas) / _WIDTH(Control(i).HelperCanvas)) * Control(i).Width
                        END IF
                    END IF
                END IF
                IF __UI_ResizeHandleHover = 8 THEN
                    IF __UI_ShiftIsDown THEN
                        IF __UI_Type(Control(i).Type).RestrictResize <> __UI_CantResizeH AND __UI_Type(Control(__UI_HoveringID).Type).RestrictResize <> __UI_CantResize THEN
                            Control(i).Width = Control(i).Width - (2 * (__UI_MouseLeft - __UI_DragX)): IF Control(i).Width < 4 THEN Control(i).Width = 4
                            IF Control(i).Width > 4 THEN Control(i).Left = Control(i).Left + (__UI_MouseLeft - __UI_DragX)
                        END IF
                        IF __UI_Type(Control(i).Type).RestrictResize = __UI_CantResizeV OR __UI_Type(Control(__UI_HoveringID).Type).RestrictResize = __UI_CantResize THEN _CONTINUE
                        Control(i).Height = Control(i).Height + (2 * (__UI_MouseTop - __UI_DragY)): IF Control(i).Height < 4 THEN Control(i).Height = 4
                        IF Control(i).Height > 4 THEN Control(i).Top = Control(i).Top - (__UI_MouseTop - __UI_DragY)
                        IF Control(i).Type = __UI_Type_PictureBox AND LEN(Text(i)) > 0 THEN
                            OldAlignmentY = Control(i).Top + Control(i).Height / 2
                            Control(i).Height = (_HEIGHT(Control(i).HelperCanvas) / _WIDTH(Control(i).HelperCanvas)) * Control(i).Width
                            Control(i).Top = OldAlignmentY - Control(i).Height / 2
                        END IF
                    ELSE
                        IF __UI_Type(Control(i).Type).RestrictResize <> __UI_CantResizeV AND __UI_Type(Control(__UI_HoveringID).Type).RestrictResize <> __UI_CantResize THEN
                            Control(i).Height = Control(i).Height + (__UI_MouseTop - __UI_DragY): IF Control(i).Height < 4 THEN Control(i).Height = 4
                        END IF
                        IF __UI_Type(Control(i).Type).RestrictResize = __UI_CantResizeH OR __UI_Type(Control(__UI_HoveringID).Type).RestrictResize = __UI_CantResize THEN _CONTINUE
                        Control(i).Width = Control(i).Width - (__UI_MouseLeft - __UI_DragX): IF Control(i).Width < 4 THEN Control(i).Width = 4 ELSE Control(i).Left = Control(i).Left + (__UI_MouseLeft - __UI_DragX)
                        IF Control(i).Type = __UI_Type_PictureBox AND LEN(Text(i)) > 0 THEN
                            Control(i).Height = (_HEIGHT(Control(i).HelperCanvas) / _WIDTH(Control(i).HelperCanvas)) * Control(i).Width
                        END IF
                    END IF
                END IF
            END IF
        NEXT
        __UI_DragY = __UI_MouseTop
        __UI_DragX = __UI_MouseLeft
    END IF
    IF __UI_DraggingThumb = True THEN
        IF Control(__UI_DraggingThumbOnID).Type = __UI_Type_ListBox THEN
            IF __UI_MouseTop >= Control(__UI_DraggingThumbOnID).Top + Control(Control(__UI_DraggingThumbOnID).ParentID).Top + __UI_ScrollbarButtonHeight AND __UI_MouseTop <= Control(__UI_DraggingThumbOnID).Top + Control(Control(__UI_DraggingThumbOnID).ParentID).Top + Control(__UI_DraggingThumbOnID).Height - __UI_ScrollbarButtonHeight THEN
                Control(__UI_DraggingThumbOnID).InputViewStart = Control(__UI_DraggingThumbOnID).InputViewStart + ((__UI_MouseTop - __UI_ThumbDragTop) * Control(__UI_DraggingThumbOnID).VScrollbarRatio)
                IF Control(__UI_DraggingThumbOnID).InputViewStart + Control(__UI_DraggingThumbOnID).LastVisibleItem - 1 > Control(__UI_DraggingThumbOnID).Max THEN Control(__UI_DraggingThumbOnID).InputViewStart = Control(__UI_DraggingThumbOnID).Max - Control(__UI_DraggingThumbOnID).LastVisibleItem + 1
                __UI_ThumbDragTop = __UI_MouseTop
            ELSEIF __UI_MouseTop < Control(__UI_DraggingThumbOnID).Top + Control(Control(__UI_DraggingThumbOnID).ParentID).Top + __UI_ScrollbarButtonHeight THEN
                Control(__UI_DraggingThumbOnID).InputViewStart = 1
            ELSEIF __UI_MouseTop > Control(__UI_DraggingThumbOnID).Top + Control(Control(__UI_DraggingThumbOnID).ParentID).Top + Control(__UI_DraggingThumbOnID).Height - __UI_ScrollbarButtonHeight THEN
                Control(__UI_DraggingThumbOnID).InputViewStart = Control(__UI_DraggingThumbOnID).Max - Control(__UI_DraggingThumbOnID).LastVisibleItem + 1
            END IF
        ELSEIF Control(__UI_DraggingThumbOnID).Type = __UI_Type_TextBox THEN
            _FONT Control(__UI_DraggingThumbOnID).Font
            IF __UI_MouseTop >= Control(__UI_DraggingThumbOnID).Top + Control(Control(__UI_DraggingThumbOnID).ParentID).Top + __UI_ScrollbarButtonHeight AND __UI_MouseTop <= Control(__UI_DraggingThumbOnID).Top + Control(Control(__UI_DraggingThumbOnID).ParentID).Top + Control(__UI_DraggingThumbOnID).Height - __UI_ScrollbarButtonHeight THEN
                Control(__UI_DraggingThumbOnID).FirstVisibleLine = Control(__UI_DraggingThumbOnID).FirstVisibleLine + ((__UI_MouseTop - __UI_ThumbDragTop) * Control(__UI_DraggingThumbOnID).VScrollbarRatio)
                __UI_ThumbDragTop = __UI_MouseTop
            ELSEIF __UI_MouseTop < Control(__UI_DraggingThumbOnID).Top + Control(Control(__UI_DraggingThumbOnID).ParentID).Top + __UI_ScrollbarButtonHeight THEN
                Control(__UI_DraggingThumbOnID).FirstVisibleLine = 1
            ELSEIF __UI_MouseTop > Control(__UI_DraggingThumbOnID).Top + Control(Control(__UI_DraggingThumbOnID).ParentID).Top + Control(__UI_DraggingThumbOnID).Height - __UI_ScrollbarButtonHeight THEN
                Control(__UI_DraggingThumbOnID).FirstVisibleLine = __UI_CountLines(__UI_DraggingThumbOnID) - Control(__UI_DraggingThumbOnID).Height \ uspacing&
            END IF
        END IF
    END IF
    IF __UI_SelectionRectangle THEN
        DoSelectionRectangle:
        DIM tsmx AS INTEGER, tmx AS INTEGER
        DIM tsmy AS INTEGER, tmy AS INTEGER
        DIM parentOffsetX AS INTEGER, parentOffsetY AS INTEGER
        DIM selectingInFrame AS _BYTE, thisParent AS LONG
        tsmx = __UI_SelectionRectangleLeft: tmx = __UI_MouseLeft
        tsmy = __UI_SelectionRectangleTop: tmy = __UI_MouseTop
        parentOffsetX = 0: parentOffsetY = 0
        selectingInFrame = False
        IF tsmx > tmx THEN SWAP tsmx, tmx
        IF tsmy > tmy THEN SWAP tsmy, tmy
        IF (_KEYDOWN(100303) OR _KEYDOWN(100304)) AND __UI_FirstSelectedID > 0 AND __UI_SelectionRectangle = False THEN
            IF Control(__UI_FirstSelectedID).ParentID = Control(__UI_HoveringID).ParentID THEN
                thisParent = Control(__UI_FirstSelectedID).ParentID
                parentOffsetX = Control(thisParent).Left
                parentOffsetY = Control(thisParent).Top
                selectingInFrame = True
            END IF
        END IF
        __UI_TotalSelectedControls = 0
        FOR i = 1 TO UBOUND(Control)
            Control(i).ControlIsSelected = False
            IF Control(i).Type <> __UI_Type_Form AND Control(i).Type <> __UI_Type_Font AND Control(i).Type <> __UI_Type_MenuBar AND Control(i).Type <> __UI_Type_MenuItem AND Control(i).Type <> __UI_Type_MenuPanel AND Control(i).Type <> __UI_Type_ContextMenu THEN
                IF selectingInFrame THEN
                    IF Control(i).ParentID = thisParent THEN
                        IF tsmx < Control(i).Left + Control(i).Width + Control(thisParent).Left AND _
                            Control(i).Left + Control(thisParent).Left < tmx AND _
                            tsmy < Control(i).Top + Control(i).Height + Control(thisParent).Top AND _
                            Control(i).Top + Control(thisParent).Top < tmy THEN
                            Control(i).ControlIsSelected = True
                            __UI_TotalSelectedControls = __UI_TotalSelectedControls + 1
                            IF __UI_TotalSelectedControls = 1 THEN __UI_FirstSelectedID = i
                        END IF
                    END IF
                ELSE
                    IF Control(i).ParentID = 0 THEN
                        IF tsmx < Control(i).Left + Control(i).Width AND _
                            Control(i).Left < tmx AND _
                            tsmy < Control(i).Top + Control(i).Height AND _
                            Control(i).Top < tmy THEN
                            Control(i).ControlIsSelected = True
                            __UI_TotalSelectedControls = __UI_TotalSelectedControls + 1
                            IF __UI_TotalSelectedControls = 1 THEN __UI_FirstSelectedID = i
                        END IF
                    END IF
                END IF
            END IF
        NEXT
    END IF
    IF __UI_KeyHit = 100303 OR __UI_KeyHit = 100304 THEN __UI_ShiftIsDown = True
    IF __UI_KeyHit = -100303 OR __UI_KeyHit = -100304 THEN __UI_ShiftIsDown = False
    IF __UI_KeyHit = 100305 OR __UI_KeyHit = 100306 THEN __UI_CtrlIsDown = True
    IF __UI_KeyHit = -100305 OR __UI_KeyHit = -100306 THEN __UI_CtrlIsDown = False
    IF __UI_KeyHit = 100307 OR __UI_KeyHit = 100308 THEN __UI_AltIsDown = True
    IF __UI_KeyHit = -100307 OR __UI_KeyHit = -100308 THEN __UI_AltIsDown = False
    DIM DoCombo AS _BYTE
    DoCombo = False
    IF __UI_BypassKeyCombos = False AND __UI_DesignMode = False AND __UI_AltIsDown = False AND __UI_KeyHit > 0 AND __UI_TotalActiveMenus = 0 THEN
        DIM ComboKey AS STRING
        DIM tempCombo$
        FOR i = 1 TO __UI_TotalKeyCombos
            IF __UI_KeyCombo(i).ControlID <= 0 THEN _CONTINUE 'handled internally
            ComboKey = ""
            tempCombo$ = RTRIM$(UCASE$(__UI_KeyCombo(i).Combo))
            FOR j = LEN(tempCombo$) TO 1 STEP -1
                IF MID$(tempCombo$, j, 1) = "+" THEN
                    ComboKey = MID$(tempCombo$, j + 1)
                    EXIT FOR
                END IF
            NEXT
            IF ComboKey = "" THEN ComboKey = tempCombo$
            IF (INSTR(tempCombo$, "SHIFT+") > 0) <> __UI_ShiftIsDown THEN _CONTINUE
            IF (INSTR(tempCombo$, "CTRL+") > 0) <> __UI_CtrlIsDown THEN _CONTINUE
            IF LEFT$(ComboKey, 1) = "F" THEN
                IF VAL(MID$(ComboKey, 2)) >= 1 AND VAL(MID$(ComboKey, 2)) <= 12 THEN
                    IF __UI_KeyHit = __UI_FKey(VAL(MID$(ComboKey, 2))) THEN
                        DoCombo = True
                        EXIT FOR
                    END IF
                ELSE
                    IF __UI_KeyHit = ASC("F") OR __UI_KeyHit = ASC("f") THEN
                        DoCombo = True
                        EXIT FOR
                    END IF
                END IF
            ELSE
                IF __UI_KeyHit = ASC(ComboKey) OR __UI_KeyHit = ASC(LCASE$(ComboKey)) THEN
                    DoCombo = True
                    EXIT FOR
                END IF
            END IF
        NEXT
        IF DoCombo THEN
            IF Control(__UI_KeyCombo(i).ControlID).Disabled = False AND Control(__UI_KeyCombo(i).ControlID).Hidden = False THEN
                IF Control(__UI_KeyCombo(i).ControlID).Type = __UI_Type_RadioButton THEN
                    SetRadioButtonValue __UI_KeyCombo(i).ControlID
                ELSEIF Control(__UI_KeyCombo(i).ControlID).Type = __UI_Type_CheckBox OR Control(__UI_KeyCombo(i).ControlID).Type = __UI_Type_ToggleSwitch THEN
                    Control(__UI_KeyCombo(i).ControlID).Value = NOT Control(__UI_KeyCombo(i).ControlID).Value
                    __UI_ValueChanged __UI_KeyCombo(i).ControlID
                    Control(__UI_KeyCombo(i).ControlID).LastChange = TIMER
                ELSEIF Control(__UI_KeyCombo(i).ControlID).Type = __UI_Type_MenuItem THEN
                    IF Control(__UI_KeyCombo(i).ControlID).BulletStyle = __UI_Bullet THEN SetRadioButtonValue __UI_KeyCombo(i).ControlID
                END IF
                __UI_Click __UI_KeyCombo(i).ControlID
            END IF
            EXIT SUB
        END IF
    END IF
    IF NOT __UI_DesignMode THEN
        IF __UI_AltIsDown AND Control(__UI_Focus).Type = __UI_Type_MenuBar THEN
            __UI_Focus = __UI_PreviousFocus
            __UI_AltIsDown = False
            __UI_ForceRedraw = True 'Trigger a global redraw
        ELSEIF __UI_AltIsDown AND __UI_TotalActiveMenus > 0 THEN
            __UI_Focus = __UI_PreviousFocus
            __UI_CloseAllMenus
            __UI_ForceRedraw = True
            __UI_KeyHit = 0
            __UI_AltIsDown = False
        ELSEIF __UI_AltIsDown THEN
            IF NOT __UI_ShowHotKeys THEN
                __UI_ShowHotKeys = True
                __UI_ForceRedraw = True 'Trigger a global redraw
            END IF
            SELECT CASE __UI_KeyHit
                CASE 48 TO 57, 65 TO 90, 97 TO 122 'Alphanumeric
                    __UI_AltCombo$ = __UI_AltCombo$ + CHR$(__UI_KeyHit)
                    IF __UI_KeyHit >= 97 THEN __UI_KeyHit = __UI_KeyHit - 32 'Turn to capitals
                    IF __UI_KeyHit > 0 THEN
                        FOR i = 1 TO UBOUND(Control)
                            IF Control(i).HotKey = __UI_KeyHit AND NOT Control(i).Disabled AND Control(i).Type <> __UI_Type_MenuItem THEN
                                SELECT CASE Control(i).Type
                                    CASE __UI_Type_Button
                                        IF Control(i).CanHaveFocus THEN __UI_Focus = Control(i).ID
                                        __UI_Click Control(i).ID
                                    CASE __UI_Type_RadioButton
                                        IF Control(i).CanHaveFocus THEN __UI_Focus = Control(i).ID
                                        SetRadioButtonValue Control(i).ID
                                        __UI_Click Control(i).ID
                                    CASE __UI_Type_CheckBox
                                        IF Control(i).CanHaveFocus THEN __UI_Focus = Control(i).ID
                                        Control(i).Value = NOT Control(i).Value
                                        __UI_Click Control(i).ID
                                        __UI_ValueChanged Control(i).ID
                                    CASE __UI_Type_Frame
                                        FOR j = i + 1 TO UBOUND(Control)
                                            IF Control(j).ParentID = Control(i).ID AND Control(j).CanHaveFocus AND NOT Control(j).Disabled THEN
                                                __UI_Focus = Control(j).ID
                                                EXIT FOR
                                            END IF
                                        NEXT
                                    CASE __UI_Type_Label
                                        FOR j = i + 1 TO UBOUND(Control)
                                            IF Control(j).ParentID = Control(i).ParentID AND Control(j).CanHaveFocus AND NOT Control(j).Disabled THEN
                                                __UI_Focus = Control(j).ID
                                                EXIT FOR
                                            END IF
                                        NEXT
                                    CASE __UI_Type_MenuBar
                                        IF __UI_TotalActiveMenus = 0 THEN
                                            __UI_PreviousFocus = __UI_Focus
                                            __UI_ActivateMenu Control(i), True
                                            __UI_ForceRedraw = True
                                            Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Value = __UI_Focus
                                            __UI_KeyHit = 0
                                            __UI_AltIsDown = False
                                        END IF
                                END SELECT
                                EXIT FOR
                            END IF
                        NEXT
                    END IF
                    __UI_KeyHit = 0
            END SELECT
        ELSE
            IF __UI_ShowHotKeys THEN
                __UI_ShowHotKeys = False
                __UI_ForceRedraw = True 'Trigger a global redraw
                IF LEN(__UI_AltCombo$) THEN
                    IF VAL(__UI_AltCombo$) >= 32 AND VAL(__UI_AltCombo$) <= 254 THEN
                        __UI_KeyHit = VAL(__UI_AltCombo$)
                    END IF
                    __UI_AltCombo$ = ""
                ELSE
                    IF __UI_HasMenuBar AND __UI_ActiveDropdownList = 0 THEN
                        __UI_PreviousFocus = __UI_Focus
                        __UI_Focus = __UI_FirstMenuBarControl
                    END IF
                END IF
            END IF
        END IF
    END IF
    IF __UI_DesignMode THEN
        IF __UI_KeyHit = 27 THEN
            FOR i = 1 TO UBOUND(Control)
                Control(i).ControlIsSelected = False
            NEXT
            __UI_TotalSelectedControls = 0
            __UI_FirstSelectedID = 0
        END IF
    END IF
    IF __UI_Focus > 0 AND __UI_KeyHit <> 0 AND __UI_DesignMode = False THEN
        __UI_KeyPress __UI_Focus
        __UI_KeyboardFocus = True
        IF __UI_IsDragging = False AND __UI_KeyHit = -13 AND NOT Control(__UI_Focus).Disabled THEN
            IF Control(__UI_Focus).Type = __UI_Type_Button OR Control(__UI_Focus).Type = __UI_Type_MenuItem THEN
                i = __UI_Focus
                IF Control(__UI_Focus).Type = __UI_Type_MenuItem THEN
                    IF Control(__UI_Focus).SubMenu THEN
                        __UI_ActivateMenu Control(__UI_Focus), True
                    ELSE
                        __UI_Focus = __UI_PreviousFocus
                        __UI_CloseAllMenus
                        __UI_ForceRedraw = True
                        __UI_KeyHit = 0
                    END IF
                END IF
                __UI_HoveringID = i
                GOTO ProcessClick
            ELSEIF Control(__UI_Focus).Type = __UI_Type_ListBox AND __UI_Focus = __UI_ActiveDropdownList THEN
                __UI_Focus = __UI_ParentDropdownList
                Control(__UI_ParentDropdownList).Value = Control(__UI_ActiveDropdownList).Value
                __UI_DestroyControl Control(__UI_ActiveDropdownList)
                IF Control(__UI_Focus).PreviousValue <> Control(__UI_Focus).Value THEN
                    __UI_ValueChanged __UI_Focus
                    Control(__UI_Focus).PreviousValue = Control(__UI_Focus).Value
                    Control(__UI_Focus).Redraw = True
                END IF
            ELSEIF Control(__UI_Focus).Type = __UI_Type_MenuBar THEN
                __UI_ActivateMenu Control(__UI_Focus), True
            ELSEIF Control(__UI_Focus).Type = __UI_Type_TextBox AND Control(__UI_Focus).Multiline THEN
            ELSEIF __UI_Focus <> __UI_DefaultButtonID AND __UI_DefaultButtonID > 0 THEN
                __UI_Click __UI_DefaultButtonID
            END IF
        ELSE
            SELECT CASE Control(__UI_Focus).Type
                CASE __UI_Type_TrackBar
                    SELECT CASE __UI_KeyHit
                        CASE 19200 'Left
                            IF Control(__UI_Focus).Value > Control(__UI_Focus).Min THEN
                                IF __UI_CtrlIsDown THEN
                                    IF Control(__UI_Focus).MinInterval > 0 AND Control(__UI_Focus).MinInterval < Control(__UI_Focus).Interval THEN
                                        Control(__UI_Focus).Value = Control(__UI_Focus).Value - Control(__UI_Focus).MinInterval
                                    ELSE
                                        Control(__UI_Focus).Value = Control(__UI_Focus).Value - Control(__UI_Focus).Interval
                                    END IF
                                ELSE
                                    Control(__UI_Focus).Value = Control(__UI_Focus).Value - Control(__UI_Focus).Interval
                                END IF
                                IF Control(__UI_Focus).Value < Control(__UI_Focus).Min THEN _
                                    Control(__UI_Focus).Value = Control(__UI_Focus).Min
                            END IF
                        CASE 19712 'Right
                            IF Control(__UI_Focus).Value < Control(__UI_Focus).Max THEN
                                IF __UI_CtrlIsDown THEN
                                    Control(__UI_Focus).Value = Control(__UI_Focus).Value + Control(__UI_Focus).MinInterval
                                ELSE
                                    Control(__UI_Focus).Value = Control(__UI_Focus).Value + Control(__UI_Focus).Interval
                                END IF
                                IF Control(__UI_Focus).Value > Control(__UI_Focus).Max THEN _
                                    Control(__UI_Focus).Value = Control(__UI_Focus).Max
                            END IF
                        CASE 18176 'Home
                            Control(__UI_Focus).Value = Control(__UI_Focus).Min
                        CASE 20224 'End
                            Control(__UI_Focus).Value = Control(__UI_Focus).Max
                    END SELECT
                CASE __UI_Type_MenuBar
                    SELECT CASE __UI_KeyHit
                        CASE 48 TO 57, 65 TO 90, 97 TO 122 'Alphanumeric
                            IF __UI_KeyHit >= 97 THEN __UI_KeyHit = __UI_KeyHit - 32 'Turn to capitals
                            IF __UI_CtrlIsDown = False THEN
                                FOR i = 1 TO UBOUND(Control)
                                    IF Control(i).HotKey = __UI_KeyHit AND NOT Control(i).Disabled AND Control(i).Type = __UI_Type_MenuBar THEN
                                        IF __UI_TotalActiveMenus = 0 THEN
                                            __UI_ActivateMenu Control(i), True
                                            Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Value = __UI_Focus
                                            __UI_ForceRedraw = True
                                            __UI_KeyHit = 0
                                        END IF
                                        EXIT FOR
                                    END IF
                                NEXT
                            END IF
                        CASE 27 'Esc
                            __UI_Focus = __UI_PreviousFocus
                            __UI_KeyHit = 0
                        CASE 19200 'Left
                            __UI_Focus = __UI_PreviousMenuBarControl(__UI_Focus)
                        CASE 19712 'Right
                            __UI_Focus = __UI_NextMenuBarControl(__UI_Focus)
                        CASE 18432, 20480 'Up, down
                            __UI_ActivateMenu Control(__UI_Focus), True
                            __UI_KeyHit = 0
                    END SELECT
                CASE __UI_Type_MenuPanel, __UI_Type_MenuItem
                    HandleDesignMenu:
                    SELECT CASE __UI_KeyHit
                        CASE 48 TO 57, 65 TO 90, 97 TO 122 'Alphanumeric
                            IF __UI_CtrlIsDown = False THEN
                                IF __UI_KeyHit >= 97 THEN __UI_KeyHit = __UI_KeyHit - 32 'Turn to capitals
                                FOR i = 1 TO UBOUND(Control)
                                    IF Control(i).HotKey = __UI_KeyHit AND NOT Control(i).Disabled AND Control(i).Type = __UI_Type_MenuItem AND Control(i).ParentID = __UI_ParentMenu(__UI_TotalActiveMenus) THEN
                                        IF LEFT$(Control(i).Name, 5) = "__UI_" THEN
                                            __UI_HoveringID = i
                                            GOTO ProcessHotkey
                                        ELSE
                                            IF Control(i).SubMenu THEN
                                                __UI_KeyHit = 0
                                                __UI_Focus = Control(i).ID
                                                __UI_ForceRedraw = True
                                                _DELAY .1
                                                __UI_ActivateMenu Control(i), True
                                            ELSE
                                                __UI_Focus = __UI_PreviousFocus
                                                __UI_CloseAllMenus
                                                __UI_ForceRedraw = True
                                                __UI_KeyHit = 0
                                                __UI_Click i
                                            END IF
                                        END IF
                                        EXIT FOR
                                    END IF
                                NEXT
                            END IF
                        CASE 27 'Esc
                            IF __UI_TotalActiveMenus > 1 THEN
                                __UI_Focus = __UI_ParentMenu(__UI_TotalActiveMenus)
                                __UI_DestroyControl Control(__UI_ActiveMenu(__UI_TotalActiveMenus))
                            ELSEIF __UI_TotalActiveMenus = 1 THEN
                                __UI_Focus = __UI_ParentMenu(__UI_TotalActiveMenus)
                                __UI_CloseAllMenus
                            ELSEIF __UI_TotalActiveMenus > 0 AND __UI_ActiveMenuIsContextMenu THEN
                                __UI_CloseAllMenus
                                __UI_Focus = __UI_PreviousFocus
                            END IF
                            __UI_KeyHit = 0
                        CASE 19200 'Left
                            IF __UI_TotalActiveMenus > 1 THEN
                                __UI_Focus = __UI_ParentMenu(__UI_TotalActiveMenus)
                                __UI_DestroyControl Control(__UI_ActiveMenu(__UI_TotalActiveMenus))
                            ELSEIF __UI_TotalActiveMenus = 1 THEN
                                IF __UI_ActiveMenuIsContextMenu = False THEN
                                    __UI_CloseAllMenus
                                    __UI_ActivateMenu Control(__UI_PreviousMenuBarControl(__UI_TopMenuBarItem)), True
                                    __UI_ForceRedraw = True
                                END IF
                            END IF
                            __UI_KeyHit = 0
                        CASE 19712 'Right
                            IF Control(__UI_Focus).SubMenu THEN
                                __UI_ActivateMenu Control(__UI_Focus), True
                            ELSE
                                IF __UI_ActiveMenuIsContextMenu = False THEN
                                    __UI_CloseAllMenus
                                    __UI_ActivateMenu Control(__UI_NextMenuBarControl(__UI_TopMenuBarItem)), True
                                    __UI_ForceRedraw = True
                                END IF
                            END IF
                            __UI_KeyHit = 0
                        CASE 18432 'Up
                            __UI_Focus = __UI_PreviousMenuItem(__UI_Focus)
                            Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Value = Control(__UI_Focus).ID
                        CASE 20480 'Down
                            __UI_Focus = __UI_NextMenuItem(__UI_Focus)
                            Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Value = Control(__UI_Focus).ID
                    END SELECT
                CASE __UI_Type_Button, __UI_Type_RadioButton, __UI_Type_CheckBox, __UI_Type_ToggleSwitch
                    SELECT CASE __UI_KeyHit
                        CASE 32
                            IF __UI_IsDragging = False AND NOT Control(__UI_Focus).Disabled THEN
                                IF __UI_KeyIsDown = False AND __UI_KeyDownOnID = 0 THEN
                                    __UI_KeyDownOnID = __UI_Focus
                                    __UI_KeyIsDown = True
                                END IF
                            END IF
                        CASE -32
                            IF __UI_IsDragging = False AND NOT Control(__UI_Focus).Disabled THEN
                                IF __UI_KeyIsDown AND __UI_Focus = __UI_KeyDownOnID THEN
                                    IF Control(__UI_KeyDownOnID).Type = __UI_Type_RadioButton THEN
                                        SetRadioButtonValue __UI_KeyDownOnID
                                    ELSEIF Control(__UI_KeyDownOnID).Type = __UI_Type_CheckBox OR _
                                           Control(__UI_KeyDownOnID).Type = __UI_Type_ToggleSwitch THEN
                                        Control(__UI_KeyDownOnID).Value = NOT Control(__UI_KeyDownOnID).Value
                                        __UI_ValueChanged __UI_KeyDownOnID
                                        Control(__UI_KeyDownOnID).LastChange = TIMER
                                    END IF
                                    __UI_KeyDownOnID = 0
                                    __UI_KeyIsDown = False
                                    __UI_Click __UI_Focus
                                END IF
                            END IF
                        CASE 18432, 20480 'Up, down
                            IF (Control(__UI_Focus).Type = __UI_Type_RadioButton OR Control(__UI_Focus).Type = __UI_Type_CheckBox) THEN
                                __UI_FocusSearch = __UI_Focus
                                DO
                                    IF _KEYDOWN(100304) OR _KEYDOWN(100303) THEN
                                        __UI_FocusSearch = (__UI_FocusSearch + UBOUND(Control) - 2) MOD UBOUND(Control) + 1
                                    ELSE
                                        __UI_FocusSearch = __UI_FocusSearch MOD UBOUND(Control) + 1
                                    END IF
                                    IF __UI_FocusSearch = __UI_Focus THEN
                                        EXIT DO
                                    END IF
                                    IF Control(__UI_FocusSearch).CanHaveFocus AND NOT Control(__UI_FocusSearch).Disabled AND Control(__UI_Focus).Type = Control(__UI_FocusSearch).Type THEN
                                        __UI_KeepFocus = False: __UI_FocusOut __UI_Focus
                                        IF __UI_KeepFocus = False THEN
                                            __UI_Focus = __UI_FocusSearch
                                            __UI_FocusIn __UI_Focus
                                            IF Control(__UI_FocusSearch).Type = __UI_Type_RadioButton THEN SetRadioButtonValue __UI_Focus
                                        END IF
                                        EXIT DO
                                    END IF
                                LOOP
                            END IF
                    END SELECT
                CASE __UI_Type_ListBox, __UI_Type_DropdownList
                    IF NOT Control(__UI_Focus).Disabled AND Control(__UI_Focus).Max > 0 THEN
                        _FONT (Control(__UI_Focus).Font)
                        SELECT EVERYCASE __UI_KeyHit
                            CASE 32 TO 254 'Printable ASCII characters
                                DIM CurrentItem%
                                CurrentItem% = Control(__UI_Focus).Value
                                __UI_ListBoxSearchItem Control(__UI_Focus)
                                IF CurrentItem% <> Control(__UI_Focus).Value THEN
                                    IF Control(__UI_Focus).Value < Control(__UI_Focus).InputViewStart THEN
                                        Control(__UI_Focus).InputViewStart = Control(__UI_Focus).Value
                                    ELSEIF Control(__UI_Focus).Value > Control(__UI_Focus).InputViewStart + Control(__UI_Focus).LastVisibleItem - 1 THEN
                                        Control(__UI_Focus).InputViewStart = Control(__UI_Focus).Value - Control(__UI_Focus).LastVisibleItem + 1
                                    END IF
                                END IF
                            CASE 18432 'Up
                                IF Control(__UI_Focus).Value > 1 THEN
                                    Control(__UI_Focus).Value = Control(__UI_Focus).Value - 1
                                    IF Control(__UI_Focus).PreviousValue <> Control(__UI_Focus).Value THEN
                                        __UI_ValueChanged __UI_Focus
                                        Control(__UI_Focus).PreviousValue = Control(__UI_Focus).Value
                                        Control(__UI_Focus).Redraw = True
                                    END IF
                                END IF
                            CASE 20480 'Down
                                IF __UI_AltIsDown THEN
                                    IF Control(__UI_Focus).Type = __UI_Type_DropdownList THEN
                                        __UI_ActivateDropdownlist Control(__UI_Focus)
                                    END IF
                                ELSE
                                    IF Control(__UI_Focus).Value < Control(__UI_Focus).Max THEN
                                        Control(__UI_Focus).Value = Control(__UI_Focus).Value + 1
                                        IF Control(__UI_Focus).PreviousValue <> Control(__UI_Focus).Value THEN
                                            __UI_ValueChanged __UI_Focus
                                            Control(__UI_Focus).PreviousValue = Control(__UI_Focus).Value
                                            Control(__UI_Focus).Redraw = True
                                        END IF
                                    END IF
                                END IF
                            CASE 18688 'Page up
                                Control(__UI_Focus).Value = Control(__UI_Focus).Value - Control(__UI_Focus).LastVisibleItem
                                IF Control(__UI_Focus).Value < 1 THEN Control(__UI_Focus).Value = 1
                                IF Control(__UI_Focus).PreviousValue <> Control(__UI_Focus).Value THEN
                                    __UI_ValueChanged __UI_Focus
                                    Control(__UI_Focus).PreviousValue = Control(__UI_Focus).Value
                                    Control(__UI_Focus).Redraw = True
                                END IF
                            CASE 20736 'Page down
                                IF Control(__UI_Focus).Value < Control(__UI_Focus).Max - Control(__UI_Focus).LastVisibleItem THEN
                                    Control(__UI_Focus).Value = Control(__UI_Focus).Value + Control(__UI_Focus).LastVisibleItem - 1
                                ELSE
                                    Control(__UI_Focus).Value = Control(__UI_Focus).Max
                                END IF
                                IF Control(__UI_Focus).PreviousValue <> Control(__UI_Focus).Value THEN
                                    __UI_ValueChanged __UI_Focus
                                    Control(__UI_Focus).PreviousValue = Control(__UI_Focus).Value
                                    Control(__UI_Focus).Redraw = True
                                END IF
                            CASE 18176 'Home
                                Control(__UI_Focus).Value = 1
                                IF Control(__UI_Focus).PreviousValue <> Control(__UI_Focus).Value THEN
                                    __UI_ValueChanged __UI_Focus
                                    Control(__UI_Focus).PreviousValue = Control(__UI_Focus).Value
                                    Control(__UI_Focus).Redraw = True
                                END IF
                            CASE 20224 'End
                                Control(__UI_Focus).Value = Control(__UI_Focus).Max
                                IF Control(__UI_Focus).PreviousValue <> Control(__UI_Focus).Value THEN
                                    __UI_ValueChanged __UI_Focus
                                    Control(__UI_Focus).PreviousValue = Control(__UI_Focus).Value
                                    Control(__UI_Focus).Redraw = True
                                END IF
                            CASE 18432, 20480, 18688, 20736, 18176, 20224
                                IF Control(__UI_Focus).Value < Control(__UI_Focus).InputViewStart THEN
                                    Control(__UI_Focus).InputViewStart = Control(__UI_Focus).Value
                                ELSEIF Control(__UI_Focus).Value > Control(__UI_Focus).InputViewStart + Control(__UI_Focus).LastVisibleItem - 1 THEN
                                    Control(__UI_Focus).InputViewStart = Control(__UI_Focus).Value - Control(__UI_Focus).LastVisibleItem + 1
                                END IF
                        END SELECT
                    END IF
                CASE __UI_Type_TextBox
                    DIM Clip$, FindLF&
                    DIM s1 AS LONG, s2 AS LONG
                    IF NOT Control(__UI_Focus).Disabled THEN
                        SELECT EVERYCASE __UI_KeyHit
                            CASE 32 TO 254 'Printable ASCII characters
                                IF __UI_KeyHit = ASC("v") OR __UI_KeyHit = ASC("V") THEN 'Paste from clipboard (Ctrl+V)
                                    IF __UI_CtrlIsDown THEN
                                        PasteIntoTextBox:
                                        IF Control(__UI_Focus).Multiline THEN
                                            Clip$ = Replace(_CLIPBOARD$, CHR$(13) + CHR$(10), CHR$(10), False, 0)
                                            IF LEN(Clip$) > 0 THEN
                                                IF NOT Control(__UI_Focus).TextIsSelected THEN
                                                    IF Control(__UI_Focus).Cursor = LEN(Text(__UI_Focus)) THEN
                                                        Text(__UI_Focus) = Text(__UI_Focus) + Clip$
                                                        Control(__UI_Focus).Cursor = LEN(Text(__UI_Focus))
                                                    ELSE
                                                        Text(__UI_Focus) = LEFT$(Text(__UI_Focus), Control(__UI_Focus).Cursor) + Clip$ + MID$(Text(__UI_Focus), Control(__UI_Focus).Cursor + 1)
                                                        Control(__UI_Focus).Cursor = Control(__UI_Focus).Cursor + LEN(Clip$)
                                                    END IF
                                                ELSE
                                                END IF
                                                __UI_TextChanged __UI_Focus
                                                IF Control(__UI_Focus).NumericOnly THEN
                                                    Control(__UI_Focus).Value = VAL(Text(__UI_Focus))
                                                    __UI_ValidateBounds __UI_Focus
                                                END IF
                                            END IF
                                            IF ContextMenuPaste THEN
                                                ContextMenuPaste = False
                                                RETURN
                                            END IF
                                            __UI_KeyHit = 0
                                        ELSE
                                            Clip$ = _CLIPBOARD$
                                            FindLF& = INSTR(Clip$, CHR$(13))
                                            IF FindLF& > 0 THEN Clip$ = LEFT$(Clip$, FindLF& - 1)
                                            FindLF& = INSTR(Clip$, CHR$(10))
                                            IF FindLF& > 0 THEN Clip$ = LEFT$(Clip$, FindLF& - 1)
                                            IF LEN(Clip$) > 0 THEN
                                                IF LEN(Mask(__UI_Focus)) > 0 THEN
                                                    DIM NumericClip$
                                                    NumericClip$ = ""
                                                    FOR i = 1 TO LEN(Clip$)
                                                        IF ASC(Clip$, i) >= 48 AND ASC(Clip$, i) <= 57 THEN
                                                            NumericClip$ = NumericClip$ + CHR$(ASC(Clip$, i))
                                                        END IF
                                                    NEXT
                                                    IF LEN(NumericClip$) THEN
                                                        Text(__UI_Focus) = ""
                                                        FOR i = 1 TO LEN(Mask(__UI_Focus))
                                                            SELECT CASE MID$(Mask(__UI_Focus), i, 1)
                                                                CASE "0", "9", "#"
                                                                    IF LEN(NumericClip$) THEN
                                                                        Text(__UI_Focus) = Text(__UI_Focus) + LEFT$(NumericClip$, 1)
                                                                        NumericClip$ = MID$(NumericClip$, 2)
                                                                    ELSE
                                                                        Text(__UI_Focus) = Text(__UI_Focus) + "_"
                                                                    END IF
                                                                CASE ELSE
                                                                    Text(__UI_Focus) = Text(__UI_Focus) + MID$(Mask(__UI_Focus), i, 1)
                                                            END SELECT
                                                        NEXT
                                                    END IF
                                                ELSE
                                                    IF Control(__UI_Focus).NumericOnly THEN
                                                        IF NOT isNumber(Clip$) THEN Clip$ = ""
                                                    END IF
                                                    IF LEN(Clip$) THEN
                                                        IF NOT Control(__UI_Focus).TextIsSelected THEN
                                                            IF Control(__UI_Focus).Cursor = LEN(Text(__UI_Focus)) THEN
                                                                Text(__UI_Focus) = Text(__UI_Focus) + Clip$
                                                                Control(__UI_Focus).Cursor = LEN(Text(__UI_Focus))
                                                            ELSE
                                                                Text(__UI_Focus) = LEFT$(Text(__UI_Focus), Control(__UI_Focus).Cursor) + Clip$ + MID$(Text(__UI_Focus), Control(__UI_Focus).Cursor + 1)
                                                                Control(__UI_Focus).Cursor = Control(__UI_Focus).Cursor + LEN(Clip$)
                                                            END IF
                                                        ELSE
                                                            s1 = Control(__UI_Focus).SelectionStart
                                                            s2 = Control(__UI_Focus).Cursor
                                                            IF s1 > s2 THEN SWAP s1, s2
                                                            Text(__UI_Focus) = LEFT$(Text(__UI_Focus), s1) + Clip$ + MID$(Text(__UI_Focus), s2 + 1)
                                                            Control(__UI_Focus).Cursor = s1 + LEN(Clip$)
                                                            Control(__UI_Focus).TextIsSelected = False
                                                            __UI_FillSelectedText 0, 0
                                                        END IF
                                                    END IF
                                                END IF
                                                __UI_TextChanged __UI_Focus
                                                IF Control(__UI_Focus).NumericOnly THEN
                                                    Control(__UI_Focus).Value = VAL(Text(__UI_Focus))
                                                    __UI_ValidateBounds __UI_Focus
                                                END IF
                                            END IF
                                            IF ContextMenuPaste THEN
                                                ContextMenuPaste = False
                                                RETURN
                                            END IF
                                            __UI_KeyHit = 0
                                        END IF
                                    END IF
                                ELSEIF __UI_KeyHit = ASC("c") OR __UI_KeyHit = ASC("C") THEN 'Copy selection to clipboard (Ctrl+C)
                                    IF __UI_CtrlIsDown THEN
                                        __UI_FillSelectedText 0, 0
                                        IF LEN(__UI_SelectedText) > 0 THEN _CLIPBOARD$ = __UI_SelectedText
                                        __UI_KeyHit = 0
                                    END IF
                                ELSEIF __UI_KeyHit = ASC("x") OR __UI_KeyHit = ASC("X") THEN 'Cut selection to clipboard (Ctrl+X)
                                    IF __UI_CtrlIsDown THEN
                                        __UI_FillSelectedText 0, 0
                                        IF LEN(__UI_SelectedText) > 0 THEN
                                            _CLIPBOARD$ = __UI_SelectedText
                                            __UI_DeleteSelection
                                            __UI_TextChanged __UI_Focus
                                                IF Control(__UI_Focus).NumericOnly THEN
                                                    Control(__UI_Focus).Value = VAL(Text(__UI_Focus))
                                                    __UI_ValidateBounds __UI_Focus
                                                END IF
                                        END IF
                                        __UI_KeyHit = 0
                                    END IF
                                ELSEIF __UI_KeyHit = ASC("a") OR __UI_KeyHit = ASC("A") THEN 'Select all text (Ctrl+A)
                                    IF __UI_CtrlIsDown THEN
                                        Control(__UI_Focus).Cursor = LEN(Text(__UI_Focus))
                                        Control(__UI_Focus).SelectionStart = 0
                                        Control(__UI_Focus).TextIsSelected = True
                                        __UI_KeyHit = 0
                                    END IF
                                END IF
                                IF Control(__UI_Focus).NumericOnly THEN
                                    IF __UI_KeyHit = 45 THEN
                                        IF INSTR(Text(__UI_Focus), "-") > 0 THEN
                                            IF INSTR(__UI_SelectedText, "-") = 0 THEN
                                                __UI_KeyHit = 0
                                            END IF
                                        ELSE
                                            IF (Control(__UI_Focus).Cursor > 0 AND Control(__UI_Focus).TextIsSelected = False) THEN
                                                __UI_KeyHit = 0
                                            END IF
                                        END IF
                                    ELSEIF __UI_KeyHit = 46 THEN
                                        IF INSTR(Text(__UI_Focus), ".") > 0 THEN
                                            IF INSTR(__UI_SelectedText, ".") = 0 THEN
                                                __UI_KeyHit = 0
                                            END IF
                                        ELSE
                                            IF Control(__UI_Focus).Cursor = 0 AND LEFT$(Text(__UI_Focus), 1) = "-" THEN
                                                __UI_KeyHit = 0
                                            END IF
                                        END IF
                                    ELSEIF __UI_KeyHit < 48 OR __UI_KeyHit > 57 THEN
                                        __UI_KeyHit = 0
                                    END IF
                                END IF
                                IF __UI_KeyHit THEN
                                    IF __UI_KeyHit = 13 THEN __UI_KeyHit = 10
                                    IF Mask(__UI_Focus) = "" OR Control(__UI_Focus).Multiline THEN
                                        IF NOT Control(__UI_Focus).TextIsSelected THEN
                                            IF Control(__UI_Focus).Cursor = LEN(Text(__UI_Focus)) THEN
                                                IF (Control(__UI_Focus).Max > 0 AND LEN(Text(__UI_Focus)) < Control(__UI_Focus).Max) OR Control(__UI_Focus).Max = 0 THEN
                                                    Text(__UI_Focus) = Text(__UI_Focus) + CHR$(__UI_KeyHit)
                                                    Control(__UI_Focus).Cursor = Control(__UI_Focus).Cursor + LEN(CHR$(__UI_KeyHit))
                                                END IF
                                            ELSE
                                                IF (Control(__UI_Focus).Max > 0 AND LEN(Text(__UI_Focus)) < Control(__UI_Focus).Max) OR Control(__UI_Focus).Max = 0 THEN
                                                    Text(__UI_Focus) = LEFT$(Text(__UI_Focus), Control(__UI_Focus).Cursor) + CHR$(__UI_KeyHit) + MID$(Text(__UI_Focus), Control(__UI_Focus).Cursor + 1)
                                                    Control(__UI_Focus).Cursor = Control(__UI_Focus).Cursor + 1
                                                END IF
                                            END IF
                                        ELSE
                                            s1 = Control(__UI_Focus).SelectionStart
                                            s2 = Control(__UI_Focus).Cursor
                                            IF s1 > s2 THEN SWAP s1, s2
                                            Text(__UI_Focus) = LEFT$(Text(__UI_Focus), s1) + CHR$(__UI_KeyHit) + MID$(Text(__UI_Focus), s2 + 1)
                                            Control(__UI_Focus).TextIsSelected = False
                                            __UI_SelectedText = ""
                                            __UI_SelectionLength = 0
                                            Control(__UI_Focus).Cursor = s1 + 1
                                        END IF
                                    ELSE
                                        IF Control(__UI_Focus).TextIsSelected THEN
                                            __UI_DeleteSelectionMasked
                                        END IF
                                        IF __UI_KeyHit >= 48 AND __UI_KeyHit <= 57 THEN
                                            DO
                                                SELECT CASE MID$(Mask(__UI_Focus), Control(__UI_Focus).Cursor + 1, 1)
                                                    CASE "0", "9", "#"
                                                        MID$(Text(__UI_Focus), Control(__UI_Focus).Cursor + 1, 1) = CHR$(__UI_KeyHit)
                                                        Control(__UI_Focus).Cursor = Control(__UI_Focus).Cursor + 1
                                                        EXIT DO
                                                    CASE ELSE
                                                        IF Control(__UI_Focus).Cursor < LEN(Mask(__UI_Focus)) THEN
                                                            Control(__UI_Focus).Cursor = Control(__UI_Focus).Cursor + 1
                                                        ELSE
                                                            EXIT DO
                                                        END IF
                                                END SELECT
                                            LOOP
                                        END IF
                                    END IF
                                    __UI_TextChanged __UI_Focus
                                    IF Control(__UI_Focus).NumericOnly THEN
                                        Control(__UI_Focus).Value = VAL(Text(__UI_Focus))
                                        __UI_ValidateBounds __UI_Focus
                                    END IF
                                END IF
                            CASE 8 'Backspace
                                IF Mask(__UI_Focus) = "" OR Control(__UI_Focus).Multiline THEN
                                    IF LEN(Text(__UI_Focus)) > 0 THEN
                                        IF NOT Control(__UI_Focus).TextIsSelected THEN
                                            IF Control(__UI_Focus).Cursor = LEN(Text(__UI_Focus)) THEN
                                                IF Control(__UI_Focus).Multiline AND RIGHT$(Text(__UI_Focus), 1) = CHR$(10) THEN
                                                    Control(__UI_Focus).CurrentLine = Control(__UI_Focus).CurrentLine - 1
                                                END IF
                                                Text(__UI_Focus) = LEFT$(Text(__UI_Focus), LEN(Text(__UI_Focus)) - 1)
                                                Control(__UI_Focus).Cursor = Control(__UI_Focus).Cursor - 1
                                            ELSEIF Control(__UI_Focus).Cursor >= 1 THEN
                                                IF Control(__UI_Focus).Multiline AND MID$(Text(__UI_Focus), Control(__UI_Focus).Cursor, 1) = CHR$(10) THEN
                                                    Control(__UI_Focus).CurrentLine = Control(__UI_Focus).CurrentLine - 1
                                                END IF
                                                Text(__UI_Focus) = LEFT$(Text(__UI_Focus), Control(__UI_Focus).Cursor - 1) + MID$(Text(__UI_Focus), Control(__UI_Focus).Cursor + 1)
                                                Control(__UI_Focus).Cursor = Control(__UI_Focus).Cursor - 1
                                            END IF
                                        ELSE
                                            __UI_DeleteSelection
                                        END IF
                                        __UI_TextChanged __UI_Focus
                                        IF Control(__UI_Focus).NumericOnly THEN
                                            Control(__UI_Focus).Value = VAL(Text(__UI_Focus))
                                            __UI_ValidateBounds __UI_Focus
                                        END IF
                                    END IF
                                ELSE
                                    IF NOT Control(__UI_Focus).TextIsSelected THEN
                                        IF Control(__UI_Focus).Cursor = LEN(Text(__UI_Focus)) THEN
                                            Text(__UI_Focus) = LEFT$(Text(__UI_Focus), LEN(Text(__UI_Focus)) - 1)
                                            Control(__UI_Focus).Cursor = Control(__UI_Focus).Cursor - 1
                                        ELSEIF Control(__UI_Focus).Cursor >= 1 THEN
                                            IF Control(__UI_Focus).Multiline AND MID$(Text(__UI_Focus), Control(__UI_Focus).Cursor, 1) = CHR$(10) THEN
                                                Control(__UI_Focus).CurrentLine = Control(__UI_Focus).CurrentLine - 1
                                            END IF
                                            Text(__UI_Focus) = LEFT$(Text(__UI_Focus), Control(__UI_Focus).Cursor - 1) + MID$(Text(__UI_Focus), Control(__UI_Focus).Cursor + 1)
                                            Control(__UI_Focus).Cursor = Control(__UI_Focus).Cursor - 1
                                        END IF
                                        Text(__UI_Focus) = __UI_MaskToText$(__UI_Focus)
                                    ELSE
                                        __UI_DeleteSelectionMasked
                                    END IF
                                    __UI_TextChanged __UI_Focus
                                    IF Control(__UI_Focus).NumericOnly THEN
                                        Control(__UI_Focus).Value = VAL(Text(__UI_Focus))
                                        __UI_ValidateBounds __UI_Focus
                                    END IF
                                END IF
                            CASE 21248 'Delete
                                IF LEN(Mask(__UI_Focus)) = 0 THEN
                                    IF NOT Control(__UI_Focus).TextIsSelected THEN
                                        IF LEN(Text(__UI_Focus)) > 0 THEN
                                            IF Control(__UI_Focus).Cursor = 0 THEN
                                                Text(__UI_Focus) = RIGHT$(Text(__UI_Focus), LEN(Text(__UI_Focus)) - 1)
                                            ELSEIF Control(__UI_Focus).Cursor > 0 AND Control(__UI_Focus).Cursor <= LEN(Text(__UI_Focus)) - 1 THEN
                                                Text(__UI_Focus) = LEFT$(Text(__UI_Focus), Control(__UI_Focus).Cursor) + MID$(Text(__UI_Focus), Control(__UI_Focus).Cursor + 2)
                                            END IF
                                            __UI_TextChanged __UI_Focus
                                            IF Control(__UI_Focus).NumericOnly THEN
                                                Control(__UI_Focus).Value = VAL(Text(__UI_Focus))
                                                __UI_ValidateBounds __UI_Focus
                                            END IF
                                        END IF
                                    ELSE
                                        __UI_DeleteSelection
                                        __UI_TextChanged __UI_Focus
                                        IF Control(__UI_Focus).NumericOnly THEN
                                            Control(__UI_Focus).Value = VAL(Text(__UI_Focus))
                                            __UI_ValidateBounds __UI_Focus
                                        END IF
                                    END IF
                                ELSE
                                    IF NOT Control(__UI_Focus).TextIsSelected THEN
                                        IF LEN(Text(__UI_Focus)) > 0 THEN
                                            IF Control(__UI_Focus).Cursor < LEN(Text(__UI_Focus)) THEN
                                                MID$(Text(__UI_Focus), Control(__UI_Focus).Cursor + 1, 1) = MID$(__UI_EmptyMask$(__UI_Focus), Control(__UI_Focus).Cursor + 1, 1)
                                                __UI_TextChanged __UI_Focus
                                                IF Control(__UI_Focus).NumericOnly THEN
                                                    Control(__UI_Focus).Value = VAL(Text(__UI_Focus))
                                                    __UI_ValidateBounds __UI_Focus
                                                END IF
                                            END IF
                                        END IF
                                    ELSE
                                        __UI_DeleteSelectionMasked
                                        __UI_TextChanged __UI_Focus
                                        IF Control(__UI_Focus).NumericOnly THEN
                                            Control(__UI_Focus).Value = VAL(Text(__UI_Focus))
                                            __UI_ValidateBounds __UI_Focus
                                        END IF
                                    END IF
                                END IF
                            CASE 19200 'Left arrow key
                                __UI_CheckSelection __UI_Focus
                                IF __UI_CtrlIsDown THEN
                                    IF Control(__UI_Focus).Cursor > 0 THEN
                                        DO
                                            Control(__UI_Focus).Cursor = Control(__UI_Focus).Cursor - 1
                                            IF Control(__UI_Focus).Cursor = 0 THEN EXIT DO
                                        LOOP UNTIL INSTR(SEP$, MID$(Text(__UI_Focus), Control(__UI_Focus).Cursor + 1, 1)) = 0
                                        DO
                                            Control(__UI_Focus).Cursor = Control(__UI_Focus).Cursor - 1
                                            IF Control(__UI_Focus).Cursor = 0 THEN EXIT DO
                                        LOOP WHILE INSTR(SEP$, MID$(Text(__UI_Focus), Control(__UI_Focus).Cursor + 1, 1)) = 0
                                        Control(__UI_Focus).Cursor = Control(__UI_Focus).Cursor + 1
                                    END IF
                                ELSE
                                    IF Control(__UI_Focus).Cursor > 0 THEN Control(__UI_Focus).Cursor = Control(__UI_Focus).Cursor - 1
                                END IF
                                IF MID$(Text(__UI_Focus), Control(__UI_Focus).Cursor + 1, 1) = CHR$(10) THEN Control(__UI_Focus).CurrentLine = Control(__UI_Focus).CurrentLine - 1
                            CASE 19712 'Right arrow key
                                __UI_CheckSelection __UI_Focus
                                IF __UI_CtrlIsDown THEN
                                    IF Control(__UI_Focus).Cursor < LEN(Text(__UI_Focus)) THEN
                                        DO
                                            Control(__UI_Focus).Cursor = Control(__UI_Focus).Cursor + 1
                                            IF Control(__UI_Focus).Cursor > LEN(Text(__UI_Focus)) THEN EXIT DO
                                        LOOP WHILE INSTR(SEP$, MID$(Text(__UI_Focus), Control(__UI_Focus).Cursor + 1, 1)) = 0
                                        Control(__UI_Focus).Cursor = Control(__UI_Focus).Cursor + 1
                                    END IF
                                ELSE
                                    IF Control(__UI_Focus).Cursor < LEN(Text(__UI_Focus)) THEN Control(__UI_Focus).Cursor = Control(__UI_Focus).Cursor + 1
                                END IF
                                IF MID$(Text(__UI_Focus), Control(__UI_Focus).Cursor, 1) = CHR$(10) THEN Control(__UI_Focus).CurrentLine = Control(__UI_Focus).CurrentLine + 1
                            CASE 18432 'Up arrow key
                                IF Control(__UI_Focus).Multiline THEN
                                    IF Control(__UI_Focus).CurrentLine > 1 THEN
                                        Control(__UI_Focus).CurrentLine = Control(__UI_Focus).CurrentLine - 1
                                    END IF
                                END IF
                            CASE 20480 'Down arrow key
                                IF Control(__UI_Focus).Multiline THEN
                                    IF Control(__UI_Focus).CurrentLine < __UI_CountLines(__UI_Focus) THEN
                                        Control(__UI_Focus).CurrentLine = Control(__UI_Focus).CurrentLine + 1
                                    END IF
                                END IF
                            CASE 18432, 20480 'For both up and down keys
                                IF Control(__UI_Focus).Multiline THEN
                                    ThisLineLen = LEN(__UI_GetTextBoxLine(__UI_Focus, Control(__UI_Focus).CurrentLine, ThisLineStart))
                                    Control(__UI_Focus).Cursor = ThisLineStart + Control(__UI_Focus).VisibleCursor - 1
                                    IF Control(__UI_Focus).Cursor > ThisLineStart + ThisLineLen - 1 THEN
                                        Control(__UI_Focus).Cursor = ThisLineStart + ThisLineLen - 1
                                    END IF
                                END IF
                            CASE 18176 'Home
                                __UI_CheckSelection __UI_Focus
                                IF Control(__UI_Focus).Multiline THEN
                                    IF __UI_CtrlIsDown THEN
                                        Control(__UI_Focus).Cursor = 0
                                        Control(__UI_Focus).CurrentLine = 1
                                    ELSE
                                        Control(__UI_Focus).Cursor = Control(__UI_Focus).Cursor - Control(__UI_Focus).VisibleCursor
                                    END IF
                                ELSE
                                    Control(__UI_Focus).Cursor = 0
                                END IF
                            CASE 20224 'End
                                __UI_CheckSelection __UI_Focus
                                IF Control(__UI_Focus).Multiline THEN
                                    IF __UI_CtrlIsDown THEN
                                        Control(__UI_Focus).Cursor = LEN(Text(__UI_Focus))
                                        Control(__UI_Focus).CurrentLine = __UI_CountLines(__UI_Focus)
                                    ELSE
                                        ThisLineLen = LEN(__UI_GetTextBoxLine(__UI_Focus, Control(__UI_Focus).CurrentLine, ThisLineStart))
                                        Control(__UI_Focus).Cursor = ThisLineStart + ThisLineLen - 1
                                    END IF
                                ELSE
                                    Control(__UI_Focus).Cursor = LEN(Text(__UI_Focus))
                                END IF
                        END SELECT
                        IF Control(__UI_Focus).Multiline THEN
                            _FONT Control(__UI_Focus).Font
                            IF Control(__UI_Focus).CurrentLine < Control(__UI_Focus).FirstVisibleLine THEN
                                Control(__UI_Focus).FirstVisibleLine = Control(__UI_Focus).CurrentLine
                            ELSEIF Control(__UI_Focus).CurrentLine + 1 > Control(__UI_Focus).FirstVisibleLine + Control(__UI_Focus).Height \ uspacing& THEN
                                Control(__UI_Focus).FirstVisibleLine = Control(__UI_Focus).CurrentLine - Control(__UI_Focus).Height \ uspacing& + 1
                            END IF
                        END IF
                    END IF
            END SELECT
        END IF
    ELSEIF __UI_DesignMode AND __UI_KeyHit <> 0 THEN 'No buttons will respond while in design mode
        IF __UI_TotalActiveMenus > 0 AND LEFT$(Control(__UI_ParentMenu(__UI_TotalActiveMenus)).Name, 5) = "__UI_" THEN GOTO HandleDesignMenu
        SELECT CASE  __UI_Keyhit
            CASE ASC("Z"), ASC("z")
                IF __UI_CtrlIsDown THEN
                    __UI_KeyPress 214
                END IF
            CASE ASC("Y"), ASC("y")
                IF __UI_CtrlIsDown THEN
                    __UI_KeyPress 215
                END IF
            CASE ASC("A"), ASC("a")
                IF __UI_CtrlIsDown THEN
                    ControlSelect:
                    __UI_KeyPress 221
                END IF
            CASE ASC("X"), ASC("x")
                IF __UI_CtrlIsDown AND __UI_TotalSelectedControls > 0 THEN
                    ControlCut:
                    __UI_KeyPress 216
                    __UI_KeyPress 219
                END IF
            CASE ASC("C"), ASC("c")
                IF __UI_CtrlIsDown AND __UI_TotalSelectedControls > 0 THEN
                    ControlCopy:
                    __UI_KeyPress 217
                END IF
            CASE ASC("V"), ASC("v")
                IF __UI_CtrlIsDown THEN
                    ControlPaste:
                    Clip$ = _CLIPBOARD$
                    IF LEFT$(Clip$, LEN(__UI_ClipboardCheck$)) = __UI_ClipboardCheck$ THEN
                        __UI_KeyPress 218
                    END IF
                END IF
            CASE 21248 'Delete
                ControlDelete:
                __UI_KeyPress 216
                __UI_KeyPress 220
            CASE 19200 'Left arrow key
                __UI_KeyPress 216
                FOR i = 1 TO UBOUND(Control)
                    IF Control(i).ControlIsSelected AND Control(i).Type <> __UI_Type_MenuBar AND Control(i).Type <> __UI_Type_MenuItem THEN
                        IF __UI_ShiftIsDown THEN
                            Control(i).Width = Control(i).Width - 1
                            __UI_IsResizing = True
                            __UI_ResizingID = i
                        ELSE
                            Control(i).Left = Control(i).Left - 1
                        END IF
                    END IF
                NEXT
            CASE 19712 'Right arrow key
                __UI_KeyPress 216
                FOR i = 1 TO UBOUND(Control)
                    IF Control(i).ControlIsSelected AND Control(i).Type <> __UI_Type_MenuBar AND Control(i).Type <> __UI_Type_MenuItem THEN
                        IF __UI_ShiftIsDown THEN
                            Control(i).Width = Control(i).Width + 1
                            __UI_IsResizing = True
                            __UI_ResizingID = i
                        ELSE
                            Control(i).Left = Control(i).Left + 1
                        END IF
                    END IF
                NEXT
            CASE 18432 'Up arrow key
                __UI_KeyPress 216
                FOR i = 1 TO UBOUND(Control)
                    IF Control(i).ControlIsSelected AND Control(i).Type <> __UI_Type_MenuBar AND Control(i).Type <> __UI_Type_MenuItem THEN
                        IF __UI_ShiftIsDown THEN
                            __UI_IsResizing = True
                            __UI_ResizingID = i
                            Control(i).Height = Control(i).Height - 1
                        ELSE
                            Control(i).Top = Control(i).Top - 1
                        END IF
                    END IF
                NEXT
            CASE 20480 'Down arrow key
                __UI_KeyPress 216
                FOR i = 1 TO UBOUND(Control)
                    IF Control(i).ControlIsSelected AND Control(i).Type <> __UI_Type_MenuBar AND Control(i).Type <> __UI_Type_MenuItem THEN
                        IF __UI_ShiftIsDown THEN
                            Control(i).Height = Control(i).Height + 1
                            __UI_IsResizing = True
                            __UI_ResizingID = i
                        ELSE
                            Control(i).Top = Control(i).Top + 1
                        END IF
                    END IF
                NEXT
        END SELECT
        IF __UI_TotalActiveMenus > 0 THEN __UI_ActivateMenu Control(__UI_ParentMenu(__UI_TotalActiveMenus)), False
    ELSEIF __UI_KeyHit <> 0 THEN 'No control has focus
        IF __UI_IsDragging = False AND __UI_KeyHit = -13 AND __UI_DefaultButtonID > 0 THEN
            __UI_Click __UI_DefaultButtonID
            __UI_KeyHit = 0
        END IF
    END IF
    __UI_LastHoveringID = __UI_HoveringID
END SUB
SUB __UI_ValidateBounds(this AS LONG)
    IF Control(this).NumericOnly = __UI_NumericWithBounds THEN
        IF Control(this).Value < Control(this).Min THEN
            Control(this).Value = Control(this).Min
        END IF
        IF Control(this).Value > Control(this).Max THEN
            Control(this).Value = Control(this).Max
        END IF
    END IF
END SUB
SUB AutoSizeLabel (this AS __UI_ControlTYPE)
    DIM tempFont AS LONG, tempCenter AS INTEGER
    DIM autoWidth AS INTEGER, autoHeight AS INTEGER
    IF this.AutoSize = False THEN EXIT SUB
    IF this.WordWrap = False THEN
        tempFont = _FONT
        _FONT this.Font
        autoWidth = __UI_PrintWidth(Caption(this.ID))
        IF this.Padding THEN autoWidth = autoWidth + this.Padding * 2
        IF this.HasBorder THEN autoWidth = autoWidth + (__UI_DefaultCaptionIndent + this.BorderSize) * 2
        IF this.Width <> autoWidth OR this.Height <> uspacing + 6 THEN
            this.Width = autoWidth
            autoHeight = uspacing + 6
            IF this.HasBorder THEN autoHeight = autoHeight + this.BorderSize * 2
            IF this.Height <> autoHeight THEN
                tempCenter = this.Top + this.Height / 2
                this.Height = autoHeight
                this.Top = tempCenter - this.Height / 2
            END IF
            this.Redraw = True
        END IF
        _FONT tempFont
    END IF
END SUB
FUNCTION Darken~& (WhichColor~&, ByHowMuch%)
    Darken~& = _RGB32(_RED32(WhichColor~&) * (ByHowMuch% / 100), _GREEN32(WhichColor~&) * (ByHowMuch% / 100), _BLUE32(WhichColor~&) * (ByHowMuch% / 100))
END FUNCTION
FUNCTION isNumber%% (__a$)
    DIM i AS LONG, a AS INTEGER, dp AS _BYTE, a$
    a$ = LTRIM$(RTRIM$(__a$))
    IF LEN(a$) = 0 THEN EXIT FUNCTION
    FOR i = 1 TO LEN(a$)
        a = ASC(MID$(a$, i, 1))
        IF a = 45 THEN
            IF i <> 1 THEN EXIT FUNCTION
            _CONTINUE
        END IF
        IF a = 46 THEN
            IF dp = 1 THEN EXIT FUNCTION
            dp = 1
            _CONTINUE
        END IF
        IF a >= 48 AND a <= 57 THEN _CONTINUE
        EXIT FUNCTION
    NEXT
    isNumber%% = True
END FUNCTION
FUNCTION RegisterKeyCombo (__Combo$, id AS LONG)
    DIM i AS LONG, j AS LONG, Combo$
    IF Control(id).ID = 0 THEN EXIT FUNCTION
    IF LEN(LTRIM$(RTRIM$(__Combo$))) = 0 THEN
        IF id > 0 THEN
            FOR i = 1 TO __UI_TotalKeyCombos
                IF __UI_KeyCombo(i).ControlID = id THEN
                    Control(__UI_KeyCombo(i).ControlID).KeyCombo = 0
                    __UI_KeyCombo(i).ControlID = 0
                    EXIT FOR
                END IF
            NEXT
        END IF
        EXIT FUNCTION
    END IF
    Combo$ = UCASE$(LTRIM$(RTRIM$(__Combo$)))
    IF INSTR(Combo$, "CTRL+") = 0 THEN
        IF LEFT$(Combo$, 1) = "F" AND (VAL(MID$(Combo$, 2)) >= 1 AND VAL(MID$(Combo$, 2)) <= 12) THEN
        ELSEIF LEFT$(Combo$, 7) = "SHIFT+F" AND (VAL(MID$(Combo$, 8)) >= 1 AND VAL(MID$(Combo$, 8)) <= 12) THEN
        ELSE
            EXIT FUNCTION
        END IF
    END IF
    FOR i = 1 TO __UI_TotalKeyCombos
        IF RTRIM$(__UI_KeyCombo(i).Combo) = Combo$ THEN
            IF __UI_KeyCombo(i).ControlID >= 0 THEN
                FOR j = 1 TO __UI_TotalKeyCombos
                    IF __UI_KeyCombo(j).ControlID = id THEN
                        Control(__UI_KeyCombo(j).ControlID).KeyCombo = 0
                        __UI_KeyCombo(j).ControlID = 0
                    END IF
                NEXT
                Control(__UI_KeyCombo(i).ControlID).KeyCombo = 0
                __UI_KeyCombo(i).ControlID = id
                Control(id).KeyCombo = i
                RegisterKeyCombo = True
                EXIT FUNCTION
            ELSE
                EXIT FUNCTION
            END IF
        END IF
    NEXT
    IF __UI_TotalKeyCombos + 1 > UBOUND(__UI_KeyCombo) THEN
        REDIM _PRESERVE __UI_KeyCombo(0 TO UBOUND(__UI_KeyCombo) + 100) AS __UI_KeyCombos
    END IF
    __UI_TotalKeyCombos = __UI_TotalKeyCombos + 1
    __UI_KeyCombo(__UI_TotalKeyCombos).Combo = Combo$
    __UI_KeyCombo(__UI_TotalKeyCombos).FriendlyCombo = __UI_FriendlyCombo(Combo$)
    FOR i = 1 TO __UI_TotalKeyCombos
        IF __UI_KeyCombo(i).ControlID = id THEN
            __UI_KeyCombo(i).ControlID = 0
        END IF
    NEXT
    __UI_KeyCombo(__UI_TotalKeyCombos).ControlID = id
    Control(id).KeyCombo = __UI_TotalKeyCombos
    RegisterKeyCombo = True
END FUNCTION
FUNCTION __UI_FriendlyCombo$ (__Combo$)
    DIM i AS LONG, isCapital AS _BYTE
    DIM Combo$
    isCapital = True
    FOR i = 1 TO LEN(__Combo$)
        IF isCapital THEN
            Combo$ = Combo$ + UCASE$(MID$(__Combo$, i, 1))
            isCapital = False
        ELSE
            Combo$ = Combo$ + LCASE$(MID$(__Combo$, i, 1))
        END IF
        IF RIGHT$(Combo$, 1) = "+" THEN isCapital = True
    NEXT
    __UI_FriendlyCombo$ = Combo$
END FUNCTION
SUB __UI_RestoreFKeys
    RESTORE __UI_FKeysData
    DIM i AS LONG
    FOR i = 1 TO 12
        READ __UI_FKey(i)
    NEXT
    __UI_FKeysData:
    DATA 15104,15360,15616,15872,16128,16384
    DATA 16640,16896,17152,17408,34048,34304
END SUB
SUB __UI_RestoreImageOriginalSize
    DIM KeepCenterX AS INTEGER, KeepCenterY AS INTEGER
    KeepCenterY = Control(__UI_FirstSelectedID).Top + Control(__UI_FirstSelectedID).Height / 2
    KeepCenterX = Control(__UI_FirstSelectedID).Left + Control(__UI_FirstSelectedID).Width / 2
    Control(__UI_FirstSelectedID).Height = _HEIGHT(Control(__UI_FirstSelectedID).HelperCanvas) + Control(__UI_FirstSelectedID).BorderSize * ABS(Control(__UI_FirstSelectedID).HasBorder)
    Control(__UI_FirstSelectedID).Width = _WIDTH(Control(__UI_FirstSelectedID).HelperCanvas) + Control(__UI_FirstSelectedID).BorderSize * ABS(Control(__UI_FirstSelectedID).HasBorder)
    Control(__UI_FirstSelectedID).Top = KeepCenterY - Control(__UI_FirstSelectedID).Height / 2
    Control(__UI_FirstSelectedID).Left = KeepCenterX - Control(__UI_FirstSelectedID).Width / 2
    Control(__UI_FirstSelectedID).Redraw = True
END SUB
FUNCTION __UI_MaskToText$(id AS LONG)
    DIM i AS LONG
    DIM Text$
    Text$ = Text(id)
    IF LEN(Text$) < LEN(Mask(id)) THEN Text$ = Text$ + SPACE$(LEN(Mask(id)) - LEN(Text$))
    FOR i = 1 TO LEN(Mask(id))
        SELECT CASE MID$(Mask(id), i, 1)
            CASE "0", "9", "#"
                IF MID$(Text$, i, 1) <> MID$(Mask(id), i, 1) AND ASC(Text$, i) >= 48 AND ASC(Text$, i) <= 57 THEN
                ELSEIF MID$(Text$, i, 1) <> MID$(Mask(id), i, 1) THEN
                    MID$(Text$, i, 1) = "_"
                END IF
            CASE ELSE
                MID$(Text$, i, 1) = MID$(Mask(id), i, 1)
        END SELECT
    NEXT
    __UI_MaskToText$ = Text$
END FUNCTION
FUNCTION RawText$(id AS LONG)
    DIM t$, c$, i AS INTEGER
    IF Mask(id) = "" THEN
        RawText$ = Text(id)
    ELSE
        FOR i = 1 TO LEN(Mask(id))
            c$ = MID$(Text(id), i, 1)
            SELECT CASE MID$(Mask(id), i, 1)
                CASE "0", "9", "#"
                    IF c$ <> "_" THEN
                        t$ = t$ + c$
                    ELSE
                        t$ = t$ + " "
                    END IF
            END SELECT
        NEXT
        RawText$ = t$
    END IF
END FUNCTION
FUNCTION __UI_EmptyMask$(id AS LONG)
    DIM i AS LONG
    DIM Text$
    FOR i = 1 TO LEN(Mask(id))
        SELECT CASE MID$(Mask(id), i, 1)
            CASE "0", "9", "#"
                Text$ = Text$ + "_"
            CASE ELSE
                Text$ = Text$ +  MID$(Mask(id), i, 1)
        END SELECT
    NEXT
    __UI_EmptyMask$ = Text$
END FUNCTION
FUNCTION __UI_GetID (ControlName$)
    DIM i AS LONG, ControlSearch$
    ControlSearch$ = UCASE$(RTRIM$(ControlName$))
    IF LEN(ControlSearch$) = 0 THEN EXIT FUNCTION
    FOR i = 1 TO UBOUND(Control)
        IF Control(i).ID > 0 AND UCASE$(RTRIM$(Control(i).Name)) = ControlSearch$ THEN
            __UI_GetID = i
            EXIT FUNCTION
        END IF
    NEXT
END FUNCTION
FUNCTION __UI_GetFontID (FontHandle&)
    DIM i AS LONG
    FOR i = 1 TO UBOUND(Control)
        IF Control(i).Type = __UI_Type_Font AND Control(i).Value = FontHandle& THEN
            __UI_GetFontID = i
            EXIT FUNCTION
        END IF
    NEXT
END FUNCTION
FUNCTION SetFont& (__NewFontFile AS STRING, NewFontSize AS INTEGER)
    DIM NextSlot AS LONG, i AS LONG
    DIM NewFontFile AS STRING, PassedFontFile AS STRING, FindSep AS LONG
    DIM TotalPassedFonts AS LONG
    REDIM PassedFonts(0 TO 10) AS STRING
    PassedFontFile = __NewFontFile
    DO
        FindSep = INSTR(PassedFontFile, "?")
        IF FindSep > 0 THEN
            NewFontFile = LEFT$(PassedFontFile, FindSep - 1)
            PassedFontFile = RTRIM$(LTRIM$(MID$(PassedFontFile, FindSep + 1)))
        ELSE
            NewFontFile = RTRIM$(LTRIM$(PassedFontFile))
        END IF
        TotalPassedFonts = TotalPassedFonts + 1
        IF TotalPassedFonts > UBOUND(PassedFonts) THEN REDIM _PRESERVE PassedFonts(0 TO UBOUND(PassedFonts) + 9) AS STRING
        PassedFonts(TotalPassedFonts) = NewFontFile
        FOR NextSlot = 1 TO UBOUND(Control)
            IF Control(NextSlot).Type = __UI_Type_Font THEN
                IF (UCASE$(ToolTip(NextSlot)) = UCASE$(__NewFontFile)) AND Control(NextSlot).Max = NewFontSize THEN
                    SetFont& = Control(NextSlot).Value
                    EXIT FUNCTION
                END IF
            END IF
        NEXT
    LOOP WHILE FindSep > 0
    __UI_Type(__UI_Type_Font).Count = __UI_Type(__UI_Type_Font).Count + 1
    FOR NextSlot = UBOUND(Control) TO 1 STEP -1
        IF Control(NextSlot).ID <> 0 THEN
            NextSlot = NextSlot + 1
            EXIT FOR
        ELSE
            IF NextSlot = 1 THEN NextSlot = UBOUND(Control) + 1: EXIT FOR
        END IF
    NEXT
    IF NextSlot = UBOUND(Control) + 1 THEN
        REDIM _PRESERVE Control(0 TO NextSlot + 99) AS __UI_ControlTYPE
        REDIM _PRESERVE Caption(0 TO NextSlot + 99) AS STRING
        REDIM _PRESERVE __UI_TempCaptions(0 TO NextSlot + 99) AS STRING
        REDIM _PRESERVE Text(0 TO NextSlot + 99) AS STRING
        REDIM _PRESERVE __UI_TempTexts(0 TO NextSlot + 99) AS STRING
        REDIM _PRESERVE Mask(0 TO NextSlot + 99) AS STRING
        REDIM _PRESERVE __UI_TempMask(0 TO NextSlot + 99) AS STRING
        REDIM _PRESERVE ToolTip(0 TO NextSlot + 99) AS STRING
        REDIM _PRESERVE __UI_TempTips(0 TO NextSlot + 99) AS STRING
    END IF
    Control(NextSlot).ID = NextSlot
    Control(NextSlot).Type = __UI_Type_Font
    Control(NextSlot).Name = "Font" + LTRIM$(STR$(__UI_Type(__UI_Type_Font).Count))
    NewFontFile = ""
    FOR i = 1 TO TotalPassedFonts
        IF _FILEEXISTS(PassedFonts(i)) OR _FILEEXISTS("C:\Windows\Fonts\" + PassedFonts(i)) THEN
            NewFontFile = PassedFonts(i)
            EXIT FOR
        END IF
    NEXT
    IF NewFontFile = "" THEN
        IF NewFontSize <> 8 AND NewFontSize <> 16 THEN
            Control(NextSlot).Value = 16
            Control(NextSlot).Max = 16
        ELSE
            Control(NextSlot).Value = NewFontSize
            Control(NextSlot).Max = NewFontSize
        END IF
        SetFont& = Control(NextSlot).Value
    ELSE
        Control(NextSlot).Value = _LOADFONT(NewFontFile, NewFontSize)
        Control(NextSlot).Max = NewFontSize
        Text(NextSlot) = NewFontFile
        ToolTip(NextSlot) = __NewFontFile 'save the original string passed
        SetFont& = Control(NextSlot).Value
        IF Control(NextSlot).Value <= 0 THEN
            __UI_DestroyControl Control(NextSlot)
            SetFont& = 16
        END IF
    END IF
END FUNCTION
SUB __UI_AdjustNewMenuBarTopHeight (NextSlot AS LONG)
    DIM TempCanvas AS LONG, PrevDest AS LONG
    IF _PIXELSIZE = 0 THEN
        TempCanvas = _NEWIMAGE(10, 10, 32)
        PrevDest = _DEST
        _DEST TempCanvas
    END IF
    IF Control(__UI_FormID).Font THEN _FONT Control(__UI_FormID).Font
    Control(NextSlot).Height = falcon_uspacing& + (((_FONT = 8) * -1) * __UI_Font8Offset + ((_FONT = 16) * -1) * __UI_Font16Offset) + 5
    Control(NextSlot).Top = 0
    IF TempCanvas <> 0 THEN
        _DEST PrevDest
        _FREEIMAGE TempCanvas
    END IF
    IF __UI_HasMenuBar = False THEN
        __UI_HasMenuBar = True
        IF Control(__UI_FormID).Canvas <> 0 THEN _FREEIMAGE Control(__UI_FormID).Canvas
        Control(__UI_FormID).Canvas = _NEWIMAGE(Control(__UI_FormID).Width, Control(__UI_FormID).Height, 32)
        _DEST Control(__UI_FormID).Canvas
        COLOR Control(__UI_FormID).ForeColor, Control(__UI_FormID).BackColor
        CLS
        IF Control(__UI_FormID).Font THEN _FONT Control(__UI_FormID).Font
        __UI_MenuBarOffsetV = falcon_uspacing& + (((_FONT = 8) * -1) * __UI_Font8Offset + ((_FONT = 16) * -1) * __UI_Font16Offset) + 5 + 2
        LINE (0, falcon_uspacing& + (((_FONT = 8) * -1) * __UI_Font8Offset + ((_FONT = 16) * -1) * __UI_Font16Offset) + 5 + 1)-STEP(Control(__UI_FormID).Width - 1, 0), Darken(Control(__UI_FormID).BackColor, 80)
        LINE (0, falcon_uspacing& + (((_FONT = 8) * -1) * __UI_Font8Offset + ((_FONT = 16) * -1) * __UI_Font16Offset) + 5 + 2)-STEP(Control(__UI_FormID).Width - 1, 0), Darken(Control(__UI_FormID).BackColor, 120)
        _DEST 0
    END IF
END SUB
FUNCTION __UI_NewControl (ControlType AS INTEGER, ControlName AS STRING, NewWidth AS INTEGER, NewHeight AS INTEGER, NewLeft AS INTEGER, NewTop AS INTEGER, ParentID AS LONG)
    DIM NextSlot AS LONG, i AS LONG
    STATIC InternalMenus AS LONG, FirstControl AS _BYTE
    IF ControlType = 0 THEN EXIT SUB
    __UI_ExpandControlDrawOrder 1
    __UI_Type(ControlType).Count = __UI_Type(ControlType).Count + 1
    IF ControlType = __UI_Type_MenuItem AND LEFT$(ControlName, 5) = "__UI_" THEN InternalMenus = InternalMenus + 1
    IF ControlType = __UI_Type_ContextMenu AND LEFT$(ControlName, 5) = "__UI_" THEN __UI_InternalContextMenus = __UI_InternalContextMenus + 1
    IF ControlName = "" THEN
        IF ControlType = __UI_Type_MenuItem THEN
            ControlName = RTRIM$(__UI_Type(ControlType).Name) + LTRIM$(STR$(__UI_Type(ControlType).Count - InternalMenus))
        ELSEIF ControlType = __UI_Type_ContextMenu THEN
            ControlName = RTRIM$(__UI_Type(ControlType).Name) + LTRIM$(STR$(__UI_Type(ControlType).Count - __UI_InternalContextMenus))
        ELSE
            ControlName = RTRIM$(__UI_Type(ControlType).Name) + LTRIM$(STR$(__UI_Type(ControlType).Count))
        END IF
    END IF
    IF ControlType <> __UI_Type_Font THEN
        i = 1
        DO
            IF __UI_GetID(ControlName) = 0 THEN EXIT DO
            i = i + 1
            ControlName = ControlName + "_" + LTRIM$(STR$(i))
        LOOP
    END IF
    IF FirstControl = False THEN
        NextSlot = 1
        FirstControl = True
    ELSE
        FOR NextSlot = UBOUND(Control) TO 1 STEP -1
            IF Control(NextSlot).ID <> 0 THEN
                NextSlot = NextSlot + 1
                EXIT FOR
            ELSE
                IF NextSlot = 1 THEN NextSlot = UBOUND(Control) + 1: EXIT FOR
            END IF
        NEXT
    END IF
    ControlDrawOrder(UBOUND(ControlDrawOrder)) = NextSlot
    IF NextSlot = UBOUND(Control) + 1 THEN
        REDIM _PRESERVE Control(0 TO NextSlot + 99) AS __UI_ControlTYPE
        REDIM _PRESERVE Caption(0 TO NextSlot + 99) AS STRING
        REDIM _PRESERVE __UI_TempCaptions(0 TO NextSlot + 99) AS STRING
        REDIM _PRESERVE Text(0 TO NextSlot + 99) AS STRING
        REDIM _PRESERVE __UI_TempTexts(0 TO NextSlot + 99) AS STRING
        REDIM _PRESERVE Mask(0 TO NextSlot + 99) AS STRING
        REDIM _PRESERVE __UI_TempMask(0 TO NextSlot + 99) AS STRING
        REDIM _PRESERVE ToolTip(0 TO NextSlot + 99) AS STRING
        REDIM _PRESERVE __UI_TempTips(0 TO NextSlot + 99) AS STRING
    END IF
    Control(NextSlot).ID = NextSlot
    Control(NextSlot).Type = ControlType
    Control(NextSlot).Name = ControlName
    IF ControlType = __UI_Type_Form AND __UI_FormID = 0 THEN __UI_FormID = NextSlot
    Control(NextSlot).ParentID = ParentID
    Control(NextSlot).ParentName = Control(ParentID).Name
    IF ControlType = __UI_Type_MenuItem THEN
        IF Control(ParentID).Type = __UI_Type_MenuItem THEN
            Control(ParentID).SubMenu = True
        END IF
    END IF
    IF (ControlType <> __UI_Type_Form AND ParentID = 0) THEN
        Control(NextSlot).Font = Control(__UI_FormID).Font
    ELSEIF (ControlType <> __UI_Type_Frame AND ParentID > 0) THEN
        Control(NextSlot).Font = Control(ParentID).Font
    END IF
    Control(NextSlot).Width = NewWidth
    Control(NextSlot).Height = NewHeight
    Control(NextSlot).Left = NewLeft
    Control(NextSlot).Top = NewTop
    Control(NextSlot).ForeColor = __UI_DefaultColor(ControlType, 1)
    Control(NextSlot).BackColor = __UI_DefaultColor(ControlType, 2)
    Control(NextSlot).SelectedForeColor = __UI_DefaultColor(ControlType, 3)
    Control(NextSlot).SelectedBackColor = __UI_DefaultColor(ControlType, 4)
    Control(NextSlot).BorderColor = __UI_DefaultColor(ControlType, 5)
    IF ControlType = __UI_Type_MenuBar THEN
        __UI_AdjustNewMenuBarTopHeight NextSlot
    END IF
    IF ControlType = __UI_Type_ToggleSwitch OR ControlType = __UI_Type_TrackBar OR ControlType = __UI_Type_TextBox OR ControlType = __UI_Type_Button OR ControlType = __UI_Type_CheckBox OR ControlType = __UI_Type_RadioButton OR ControlType = __UI_Type_ListBox OR ControlType = __UI_Type_DropdownList THEN
        Control(NextSlot).CanHaveFocus = True
    END IF
    IF ControlType = __UI_Type_Frame THEN
        IF NewWidth = 0 THEN NewWidth = 10
        IF NewHeight = 0 THEN NewHeight = 10
        Control(NextSlot).Canvas = _NEWIMAGE(NewWidth, NewHeight, 32)
    END IF
    IF __UI_DesignMode THEN
    ELSE
        IF ControlType = __UI_Type_TextBox THEN
            Control(NextSlot).ContextMenuID = __UI_GetID("__UI_TextFieldMenu")
        END IF
    END IF
    IF ControlType = __UI_Type_ProgressBar THEN
        Control(NextSlot).Max = 100
        Caption(NextSlot) = "\#"
    END IF
    IF ControlType = __UI_Type_TrackBar THEN
        Control(NextSlot).Max = 10
        Control(NextSlot).Interval = 1
    END IF
    IF ControlType = __UI_Type_Form THEN
        Control(__UI_FormID).Canvas = _NEWIMAGE(NewWidth, NewHeight, 32)
        _DEST Control(__UI_FormID).Canvas
        COLOR Control(__UI_FormID).ForeColor, Control(__UI_FormID).BackColor
        CLS
        _DEST 0
    END IF
    IF (ControlType = __UI_Type_PictureBox AND __UI_DesignMode) OR ControlType = __UI_Type_TextBox OR ControlType = __UI_Type_Frame OR ControlType = __UI_Type_ListBox OR ControlType = __UI_Type_DropdownList THEN
        Control(NextSlot).HasBorder = True
        Control(NextSlot).BorderSize = 1
    END IF
    IF ControlType = __UI_Type_PictureBox THEN
        Control(NextSlot).HelperCanvas = _NEWIMAGE(NewWIdth, NewHeight, 32)
        IF __UI_DesignMode THEN Control(NextSlot).Stretch = True
        Control(NextSlot).Align = __UI_Center
        Control(NextSlot).VAlign = __UI_Middle
    END IF
    IF ControlType = __UI_Type_Label AND __UI_DesignMode THEN Control(NextSlot).VAlign = __UI_Middle
    __UI_NewControl = NextSlot
END FUNCTION
SUB __UI_DestroyControl (This AS __UI_ControlTYPE)
    DIM i AS LONG, uw AS LONG
    __UI_AutoRefresh = False
    IF This.ID > 0 THEN
        Caption(This.ID) = ""
        __UI_TempCaptions(This.ID) = ""
        Text(This.ID) = ""
        __UI_TempTexts(This.ID) = ""
        ToolTip(This.ID) = ""
        __UI_TempTips(This.ID) = ""
        Mask(This.ID) = ""
        IF This.Type = __UI_Type_ListBox THEN
            IF __UI_ActiveDropdownList = This.ID THEN
                __UI_ActiveDropdownList = 0
                __UI_ParentDropdownList = 0
            END IF
        ELSEIF This.Type = __UI_Type_MenuPanel THEN
            FOR i = 1 TO UBOUND(Control)
                IF Control(i).MenuPanelID = This.ID THEN
                    IF Control(i).ControlIsSelected THEN
                        Control(i).ControlIsSelected = False
                    END IF
                END IF
            NEXT
            IF Control(This.SourceControl).Type = __UI_Type_ContextMenu THEN
                __UI_ActiveMenuIsContextMenu = False
            END IF
            __UI_TotalActiveMenus = __UI_TotalActiveMenus - 1
            IF __UI_TotalActiveMenus < 0 THEN __UI_TotalActiveMenus = 0
        END IF
        __UI_Type(This.Type).Count = __UI_Type(This.Type).Count - 1
        IF This.Font > 0 AND This.Font <> 8 AND This.Font <> 16 THEN
            FOR i = 1 TO UBOUND(Control)
                IF Control(i).Type <> __UI_Type_Font THEN
                    IF This.ID <> i AND This.Font = Control(i).Font THEN EXIT FOR
                END IF
            NEXT
            IF i > UBOUND(Control) THEN
                __UI_DestroyControl Control(__UI_GetFontID(This.Font))
                This.Font = 0
            END IF
        ELSE
            This.Font = 0
        END IF
    END IF
    DIM EmptyControl AS __UI_ControlTYPE
    IF This.Canvas <> 0 THEN _FREEIMAGE This.Canvas: This.Canvas = 0
    IF This.HelperCanvas <> 0 THEN _FREEIMAGE This.HelperCanvas: This.HelperCanvas = 0
    IF This.ControlIsSelected THEN This.ControlIsSelected = False: __UI_TotalSelectedControls = __UI_TotalSelectedControls - 1
    uw& = GetControlDrawOrder(This.ID)
    ControlDrawOrder(uw&) = 0    
    This = EmptyControl
    __UI_HasMenuBar = (__UI_FirstMenuBarControl > 0)
    __UI_AutoRefresh = True
END SUB
SUB SetCaption (ThisID AS LONG, TempCaption$)
    DIM FindSep%, NewCaption$, FindEscape%
    DIM PrevFont AS LONG, TempCanvas AS LONG, PrevDest AS LONG
    IF ThisID = 0 THEN EXIT SUB
    NewCaption$ = RestoreCHR$(TempCaption$)
    StartSearchForSep:
    FindSep% = INSTR(FindSep% + 1, NewCaption$, "&")
    IF FindSep% > 0 AND FindSep% < LEN(NewCaption$) THEN
        IF FindSep% > 1 THEN
            IF ASC(NewCaption$, FindSep% - 1) = 92 THEN
                GOTO StartSearchForSep
            END IF
        END IF
        NewCaption$ = LEFT$(NewCaption$, FindSep% - 1) + MID$(NewCaption$, FindSep% + 1)
        Control(ThisID).HotKey = ASC(UCASE$(NewCaption$), FindSep%)
        Control(ThisID).HotKeyPosition = FindSep%
        FindEscape% = INSTR(NewCaption$, "\&")
        DO WHILE FindEscape% > 0
            IF FindEscape% < FindSep% THEN
                FindSep% = FindSep% - 1
            END IF
            NewCaption$ = LEFT$(NewCaption$, FindEscape% - 1) + MID$(NewCaption$, FindEscape% + 1)
            FindEscape% = INSTR(NewCaption$, "\&")
        LOOP
        PrevFont = _FONT
        IF _PIXELSIZE = 0 THEN
            TempCanvas = _NEWIMAGE(10, 10, 32)
            PrevDest = _DEST
            _DEST TempCanvas
        END IF
        _FONT (Control(ThisID).Font)
        IF Control(ThisID).HotKeyPosition = 1 THEN
            Control(ThisID).HotKeyOffset = 0
        ELSE
            Control(ThisID).HotKeyOffset = __UI_PrintWidth(LEFT$(NewCaption$, Control(ThisID).HotKeyPosition - 1))
        END IF
        IF TempCanvas <> 0 THEN
            _DEST PrevDest
            _FREEIMAGE TempCanvas
        END IF
        _FONT PrevFont
    ELSE
        Control(ThisID).HotKey = 0
    END IF
    NewCaption$ = Replace$(NewCaption$, "\n", CHR$(10), False, 0)
    Caption(ThisID) = NewCaption$
END SUB
SUB BeginDraw(ThisID AS LONG)
    IF Control(ThisID).Type <> __UI_Type_PictureBox THEN EXIT SUB
    _DEST Control(ThisID).HelperCanvas
END SUB
SUB EndDraw(ThisID AS LONG)
    IF Control(ThisID).Type <> __UI_Type_PictureBox THEN EXIT SUB
    _DEST 0
    Control(ThisID).Redraw = True
END SUB
SUB LoadImage (This AS __UI_ControlTYPE, File$)
    DIM PrevDest AS LONG, ErrorMessage$
    STATIC NotFoundImage AS LONG
    IF This.HelperCanvas <> 0 THEN _FREEIMAGE This.HelperCanvas
    IF _FILEEXISTS(File$) THEN
        This.HelperCanvas = _LOADIMAGE(File$, 32)
        IF This.HelperCanvas >= -1 THEN
            This.HelperCanvas = IconPreview(File$)
            IF This.HelperCanvas >= -1 THEN ErrorMessage$ = "Unable to load file:"
        END IF
    ELSE
        IF File$ = "" THEN
            IF This.Type = __UI_Type_PictureBox THEN
                This.HelperCanvas = _NEWIMAGE(This.Width, This.Height, 32)
            END IF
        ELSE
            ErrorMessage$ = "Missing image file:"
        END IF
    END IF
    IF LEN(ErrorMessage$) THEN
        IF NotFoundImage = 0 THEN NotFoundImage = __UI_LoadThemeImage("notfound.png")
        PrevDest = _DEST
        This.HelperCanvas = _NEWIMAGE(This.Width, This.Height, 32)
        _DEST This.HelperCanvas
        _PRINTMODE _KEEPBACKGROUND
        _FONT (This.Font)
        CLS , _RGBA32(0, 0, 0, 0)
        _PUTIMAGE (This.Width / 2 - _WIDTH(NotFoundImage) / 2, This.Height / 2 - _HEIGHT(NotFoundImage) / 2), NotFoundImage
        COLOR This.ForeColor
        __UI_PrintString 5, 5, ErrorMessage$
        __UI_PrintString 5, 5 + uspacing&, File$
        _DEST PrevDest
        Text(This.ID) = ""
    ELSE
        IF This.Type = __UI_Type_PictureBox OR This.Type = __UI_Type_Button OR This.Type = __UI_Type_MenuItem THEN
            Text(This.ID) = File$
        END IF
    END IF
    This.Redraw = True
END SUB
SUB __UI_ClearColor (Image&, Left AS _UNSIGNED LONG, Top AS INTEGER)
    DIM PrevSource AS LONG
    IF NOT Image& < -1 THEN EXIT SUB
    IF Top = -1 THEN
        _CLEARCOLOR Left, Image&
    ELSE
        PrevSource = _SOURCE
        _SOURCE Image&
        _CLEARCOLOR POINT(Left, Top), Image&
        _SOURCE PrevSource
    END IF
END SUB
SUB __UI_ClearHelperCanvasColor (This AS __UI_ControlTYPE, Left AS INTEGER, Top AS INTEGER)
    DIM PrevSource AS LONG
    IF NOT This.HelperCanvas < -1 THEN EXIT SUB
    PrevSource = _SOURCE
    _SOURCE This.HelperCanvas
    This.TransparentColor = POINT(Left, Top)
    _CLEARCOLOR This.TransparentColor, This.HelperCanvas
    _SOURCE PrevSource
END SUB
FUNCTION __UI_LoadThemeImage& (FileName$)
    DIM A$, i&, B$, C%, F$, C$, t%, B&, X$, btemp$, BASFILE$
    DIM MemoryBlock AS _MEM, TempImage AS LONG, NextSlot AS LONG
    DIM NewWidth AS INTEGER, NewHeight AS INTEGER
    FOR NextSlot = 1 TO UBOUND(__UI_ThemeImages)
        IF UCASE$(RTRIM$(__UI_ThemeImages(NextSlot).FileName)) = UCASE$(FileName$) THEN
            __UI_LoadThemeImage& = __UI_ThemeImages(NextSlot).Handle
            EXIT FUNCTION
        ELSEIF RTRIM$(__UI_ThemeImages(NextSlot).FileName) = "" THEN
        END IF
    NEXT
    A$ = __UI_ImageData$(FileName$)
    IF LEN(A$) = 0 THEN EXIT FUNCTION
    NewWidth = CVI(LEFT$(A$, 2))
    NewHeight = CVI(MID$(A$, 3, 2))
    A$ = MID$(A$, 5)
    FOR i& = 1 TO LEN(A$) STEP 4: B$ = MID$(A$, i&, 4)
        IF INSTR(1, B$, "%") THEN
            FOR C% = 1 TO LEN(B$): F$ = MID$(B$, C%, 1)
                IF F$ <> "%" THEN C$ = C$ + F$
            NEXT: B$ = C$
            END IF: FOR t% = LEN(B$) TO 1 STEP -1
            B& = B& * 64 + ASC(MID$(B$, t%)) - 48
            NEXT: X$ = "": FOR t% = 1 TO LEN(B$) - 1
            X$ = X$ + CHR$(B& AND 255): B& = B& \ 256
    NEXT: btemp$ = btemp$ + X$: NEXT
    BASFILE$ = btemp$
    TempImage = _NEWIMAGE(NewWidth, NewHeight, 32)
    MemoryBlock = _MEMIMAGE(TempImage)
    __UI_MemCopy MemoryBlock.OFFSET, _OFFSET(BASFILE$), LEN(BASFILE$)
    _MEMFREE MemoryBlock
    IF NextSlot > UBOUND(__UI_ThemeImages) THEN
        REDIM _PRESERVE __UI_ThemeImages(0 TO NextSlot + 99) AS __UI_ThemeImagesType
    END IF
    __UI_ThemeImages(NextSlot).FileName = FileName$
    __UI_ThemeImages(NextSlot).Handle = TempImage
    __UI_LoadThemeImage& = TempImage
END FUNCTION
SUB SetRadioButtonValue (id AS LONG)
    DIM i AS LONG
    IF Control(id).Type = __UI_Type_MenuItem AND Control(id).BulletStyle <> __UI_Bullet THEN
        Control(id).Value = NOT Control(id).Value
        EXIT SUB
    END IF
    IF Control(id).Type = __UI_Type_MenuItem OR Control(id).Type = __UI_Type_RadioButton THEN
        FOR i = 1 TO UBOUND(Control)
            SELECT CASE Control(id).Type
                CASE __UI_Type_RadioButton
                    IF Control(i).Type = __UI_Type_RadioButton AND Control(i).ParentID = Control(id).ParentID THEN
                        IF Control(i).Value THEN
                            Control(i).Value = False
                            __UI_ValueChanged i
                        END IF
                    END IF
                CASE __UI_Type_MenuItem
                    IF (Control(i).Type = __UI_Type_MenuItem AND Control(i).BulletStyle = __UI_Bullet) AND Control(i).ParentID = Control(id).ParentID THEN
                        IF Control(i).MenuItemGroup = Control(id).MenuItemGroup THEN
                            Control(i).Value = False
                        END IF
                    END IF
            END SELECT
        NEXT
        Control(id).Value = True
        IF Control(id).Type = __UI_Type_RadioButton THEN __UI_ValueChanged id
        Control(id).Redraw = True
    END IF
END SUB
SUB __UI_CheckSelection (id)
    IF NOT Control(id).Multiline THEN
        IF __UI_ShiftIsDown THEN
            IF NOT Control(id).TextIsSelected THEN
                Control(id).TextIsSelected = True
                Control(id).SelectionStart = Control(id).Cursor
            END IF
        ELSE
            Control(id).TextIsSelected = False
            __UI_FillSelectedText 0, 0
        END IF
    END IF
END SUB
SUB __UI_FillSelectedText(__ss1 AS LONG, __ss2 AS LONG)
    DIM i AS LONG
    i = __UI_Focus
    __UI_SelectedText = ""
    __UI_SelectionLength = 0
    IF Control(i).Type = __UI_Type_TextBox AND Control(i).TextIsSelected THEN
        DIM s1 AS LONG, s2 AS LONG
        DIM ss1 AS LONG, ss2 AS LONG
        s1 = Control(i).SelectionStart
        s2 = Control(i).Cursor
        IF s1 > s2 THEN
            SWAP s1, s2
            IF Control(i).InputViewStart > 1 THEN
                ss1 = s1 - Control(i).InputViewStart + 1
            ELSE
                ss1 = s1
            END IF
            ss2 = s2 - s1
            IF ss1 + ss2 > Control(i).FieldArea THEN ss2 = Control(i).FieldArea - ss1
        ELSE
            ss1 = s1
            ss2 = s2 - s1
            IF ss1 < Control(i).InputViewStart THEN ss1 = 0: ss2 = s2 - Control(i).InputViewStart + 1
            IF ss1 > Control(i).InputViewStart THEN ss1 = ss1 - Control(i).InputViewStart + 1: ss2 = s2 - s1
        END IF
        __UI_SelectedText = MID$(Text(i), s1 + 1, s2 - s1)
        __UI_SelectionLength = LEN(__UI_SelectedText)
        __ss1 = ss1
        __ss2 = ss2
    END IF
END SUB
SUB __UI_DeleteSelection
    DIM s1 AS LONG, s2 AS LONG
    IF NOT Control(__UI_Focus).Multiline THEN
        s1 = Control(__UI_Focus).SelectionStart
        s2 = Control(__UI_Focus).Cursor
        IF s1 > s2 THEN SWAP s1, s2
        Text(__UI_Focus) = LEFT$(Text(__UI_Focus), s1) + MID$(Text(__UI_Focus), s2 + 1)
        Control(__UI_Focus).TextIsSelected = False
        __UI_FillSelectedText 0, 0
        Control(__UI_Focus).Cursor = s1
    END IF
END SUB
SUB __UI_DeleteSelectionMasked
    DIM s1 AS LONG, s2 AS LONG
    s1 = Control(__UI_Focus).SelectionStart
    s2 = Control(__UI_Focus).Cursor
    IF s1 > s2 THEN SWAP s1, s2
    MID$(Text(__UI_Focus), s1 + 1, s2 - s1) = MID$(__UI_EmptyMask$(__UI_Focus), s1 + 1, s2 - s1)
    Control(__UI_Focus).TextIsSelected = False
    __UI_FillSelectedText 0, 0
    Control(__UI_Focus).Cursor = s1
END SUB
SUB __UI_CursorAdjustments(This AS LONG)
    IF NOT Control(This).Multiline AND Control(This).Type = __UI_Type_TextBox THEN
        IF Control(This).VisibleCursor >= (Control(This).Width - ((Control(This).BorderSize + __UI_DefaultCaptionIndent) * ABS(Control(This).HasBorder))) THEN
            Control(This).InputViewStart = __UI_FocusedTextBoxChars(Control(This).Cursor) - Control(This).Width / 2 'Control(This).InputViewStart + Control(This).Width / 4
        ELSEIF Control(This).VisibleCursor <= 0 THEN
            IF Control(This).Cursor >= LBOUND(__UI_FocusedTextBoxChars) AND Control(This).Cursor <= UBOUND(__UI_FocusedTextBoxChars) THEN
                Control(This).InputViewStart = __UI_FocusedTextBoxChars(Control(This).Cursor) - Control(This).Width / 2 'Control(This).InputViewStart - Control(This).Width / 4
            END IF
        END IF
        IF Control(This).InputViewStart < 0 THEN Control(This).InputViewStart = 0
    ELSEIF Control(This).Multiline AND Control(This).Type = __UI_Type_TextBox THEN
    END IF
END SUB
FUNCTION Replace$ (TempText$, SubString$, NewString$, CaseSensitive AS _BYTE, TotalReplacements AS LONG)
    DIM FindSubString AS LONG, Text$
    IF LEN(TempText$) = 0 THEN EXIT SUB
    Text$ = TempText$
    TotalReplacements = 0
    DO
        IF CaseSensitive THEN
            FindSubString = INSTR(FindSubString + 1, Text$, SubString$)
        ELSE
            FindSubString = INSTR(FindSubString + 1, UCASE$(Text$), UCASE$(SubString$))
        END IF
        IF FindSubString = 0 THEN EXIT DO
        IF LEFT$(SubString$, 1) = "\" THEN 'Escape sequence
            IF MID$(Text$, FindSubstring - 1, 1) <> "\" THEN
                Text$ = LEFT$(Text$, FindSubString - 1) + NewString$ + MID$(Text$, FindSubString + LEN(SubString$))
                TotalReplacements = TotalReplacements + 1
            END IF
        ELSE
            Text$ = LEFT$(Text$, FindSubString - 1) + NewString$ + MID$(Text$, FindSubString + LEN(SubString$))
            TotalReplacements = TotalReplacements + 1
        END IF
    LOOP
    Replace$ = Text$
END FUNCTION
FUNCTION __UI_CountLines&(id AS LONG)
    DIM FindLF AS LONG, TotalLines AS LONG
    IF LEN(Text(id)) = 0 THEN EXIT FUNCTION
    FindLF = INSTR(Text(id), CHR$(10))
    IF FindLF = 0 THEN
        __UI_CountLines& = 1
        EXIT FUNCTION
    END IF
    TotalLines = 2
    DO
        FindLF = INSTR(FindLF + 1, Text(id), CHR$(10))
        IF FindLF = 0 THEN
            __UI_CountLines& = TotalLines
            EXIT FUNCTION
        END IF
        TotalLines = TotalLines + 1
    LOOP
END FUNCTION
FUNCTION __UI_GetTextBoxLine$ (id AS LONG, LineNumber AS LONG, StartPosition AS LONG)
    DIM This AS __UI_ControlTYPE, ThisLine AS LONG, FindLF AS LONG, LastLF AS LONG
    This = Control(id)
    StartPosition = 1
    IF NOT This.MultiLine THEN
        __UI_GetTextBoxLine$ = Text(id)
        EXIT FUNCTION
    END IF
    FindLF = INSTR(Text(id), CHR$(10))
    IF LineNumber = 1 THEN
        IF FindLF = 0 THEN
            __UI_GetTextBoxLine$ = Text(id)
            EXIT FUNCTION
        ELSE
            __UI_GetTextBoxLine$ = LEFT$(Text(id), FindLF - 1)
            EXIT FUNCTION
        END IF
    END IF
    ThisLine = 2
    DO
        LastLF = FindLF
        FindLF = INSTR(LastLF + 1, Text(id), CHR$(10))
        IF FindLF > 0 THEN
            IF ThisLine = LineNumber THEN
                __UI_GetTextBoxLine$ = MID$(Text(id), LastLF + 1, FindLF - LastLF - 1)
                StartPosition = LastLF + 1
                EXIT FUNCTION
            END IF
        ELSE
            IF ThisLine = LineNumber THEN
                __UI_GetTextBoxLine$ = MID$(Text(id), LastLF + 1)
                StartPosition = LastLF + 1
            END IF
            EXIT FUNCTION
        END IF
        ThisLine = ThisLine + 1
    LOOP
    StartPosition = 0
END FUNCTION
SUB AddItem (WhichListBox AS LONG, TempItem$)
    DIM ThisID AS LONG, prevFont AS LONG
    DIM BorderOffset AS INTEGER, Item$
    ThisID = WhichListBox
    IF Control(ThisID).Type <> __UI_Type_ListBox AND Control(ThisID).Type <> __UI_Type_DropdownList THEN EXIT SUB
    Item$ = Replace$(RestoreCHR$(TempItem$), CHR$(10), CHR$(13), False, 0)
    IF LEN(Text(ThisID)) > 0 AND RIGHT$(Text(ThisID), 1) <> CHR$(10) THEN Text(ThisID) = Text(ThisID) + CHR$(10)
    Text(ThisID) = Text(ThisID) + Item$ + CHR$(10)
    Control(ThisID).Max = Control(ThisID).Max + 1
    IF Control(ThisID).AutoScroll THEN
        prevFont = _FONT
        BorderOffset = ABS(Control(ThisID).HasBorder) * 5
        _FONT Control(ThisID).Font
        IF Control(ThisID).Max > FIX((Control(ThisID).Height - BorderOffset) / Control(ThisID).ItemHeight) THEN
            Control(ThisID).InputViewStart = Control(ThisID).Max - FIX((Control(ThisID).Height - BorderOffset) / Control(ThisID).ItemHeight) + 1
        END IF
        _FONT prevFont
    END IF
    Control(ThisID).LastVisibleItem = 0 'Reset this var so it'll be recalculated
    Control(ThisID).Redraw = True
END SUB
SUB RemoveItem (WhichListBox AS LONG, ItemToRemove AS INTEGER)
    DIM This AS __UI_ControlTYPE, TempText$, ThisItem%, FindLF&, TempCaption$
    This = Control(WhichListBox)
    IF This.Type <> __UI_Type_ListBox AND This.Type <> __UI_Type_DropdownList THEN EXIT SUB
    IF ItemToRemove > This.Max THEN EXIT SUB
    TempText$ = Text(This.ID)
    Text(This.ID) = ""
    ThisItem% = 0
    DO WHILE LEN(TempText$)
        ThisItem% = ThisItem% + 1
        FindLF& = INSTR(TempText$, CHR$(10))
        IF FindLF& THEN
            TempCaption$ = LEFT$(TempText$, FindLF& - 1)
            TempText$ = MID$(TempText$, FindLF& + 1)
        ELSE
            TempCaption$ = TempText$
            TempText$ = ""
        END IF
        IF ThisItem% <> ItemToRemove THEN Text(This.ID) = Text(This.ID) + TempCaption$ + CHR$(13)
    LOOP
    This.Max = This.Max - 1
    This.LastVisibleItem = 0 'Reset this var so it'll be recalculated
    IF This.Value = ItemToRemove THEN
        This.Value = 0
    ELSEIF This.Value > ItemToRemove THEN
        This.Value = This.Value - 1
    END IF
    Control(This.ID) = This
    Control(This.ID).Redraw = True
END SUB
SUB ResetList (WhichListBox AS LONG)
    DIM This AS __UI_ControlTYPE
    This = Control(WhichListBox)
    IF This.Type <> __UI_Type_ListBox AND This.Type <> __UI_Type_DropdownList THEN EXIT SUB
    Text(This.ID) = ""
    This.Max = 0
    This.LastVisibleItem = 0 'Reset this var so it'll be recalculated
    This.InputViewStart = 1
    This.Value = 0
    Control(This.ID) = This
    Control(This.ID).Redraw = True
END SUB
SUB ReplaceItem (WhichListBox AS LONG, ItemToReplace AS INTEGER, NewText$)
    DIM This AS __UI_ControlTYPE, TempText$, ThisItem%, FindLF&, TempCaption$
    This = Control(WhichListBox)
    IF This.Type <> __UI_Type_ListBox AND This.Type <> __UI_Type_DropdownList THEN EXIT SUB
    IF ItemToReplace > This.Max THEN EXIT SUB
    TempText$ = Text(This.ID)
    Text(This.ID) = ""
    ThisItem% = 0
    DO WHILE LEN(TempText$)
        ThisItem% = ThisItem% + 1
        FindLF& = INSTR(TempText$, CHR$(10))
        IF FindLF& THEN
            TempCaption$ = LEFT$(TempText$, FindLF& - 1)
            TempText$ = MID$(TempText$, FindLF& + 1)
        ELSE
            TempCaption$ = TempText$
            TempText$ = ""
        END IF
        IF ThisItem% <> ItemToReplace THEN
            Text(This.ID) = Text(This.ID) + TempCaption$ + CHR$(10)
        ELSE
            Text(This.ID) = Text(This.ID) + NewText$ + CHR$(10)
        END IF
    LOOP
    Control(This.ID).Redraw = True
END SUB
FUNCTION SelectItem%% (id AS LONG, __Item$)
    DIM b$, Item$, i AS LONG
    IF Control(id).Type <> __UI_Type_ListBox AND Control(id).Type <> __UI_Type_DropdownList THEN
        EXIT FUNCTION
    END IF
    Item$ = RTRIM$(LTRIM$(__Item$))
    IF LEN(Item$) = 0 THEN EXIT FUNCTION
    FOR i = 1 TO Control(id).Max
        b$ = GetItem$(id, i)
        IF b$ = Item$ THEN
            Control(id).Value = i
            Control(id).Redraw = True
            SelectItem%% = True
            EXIT FUNCTION
        END IF
    NEXT
END FUNCTION
FUNCTION GetItem$ (id AS LONG, Item AS LONG)
    DIM This AS __UI_ControlTYPE, ThisItem AS LONG, FindLF AS LONG, LastLF AS LONG
    This = Control(id)
    FindLF = INSTR(Text(id), CHR$(10))
    IF Item = 1 THEN
        IF FindLF = 0 THEN
            GetItem$ = Text(id)
            EXIT FUNCTION
        ELSE
            GetItem$ = LEFT$(Text(id), FindLF - 1)
            EXIT FUNCTION
        END IF
    END IF
    ThisItem = 2
    DO
        LastLF = FindLF
        FindLF = INSTR(LastLF + 1, Text(id), CHR$(10))
        IF FindLF > 0 THEN
            IF ThisItem = Item THEN
                GetItem$ = MID$(Text(id), LastLF + 1, FindLF - LastLF - 1)
                EXIT FUNCTION
            END IF
        ELSE
            IF ThisItem = Item THEN
                GetItem$ = MID$(Text(id), LastLF + 1)
            END IF
            EXIT FUNCTION
        END IF
        ThisItem = ThisItem + 1
    LOOP
END FUNCTION
SUB __UI_ListBoxSearchItem (This AS __UI_ControlTYPE)
    STATIC SearchPattern$, LastListKeyHit AS SINGLE
    DIM ThisItem%, FindLF&, TempCaption$, TempText$
    DIM ListItems$(1 TO This.Max)
    TempText$ = Text(This.ID)
    DO WHILE LEN(TempText$)
        ThisItem% = ThisItem% + 1
        FindLF& = INSTR(TempText$, CHR$(10))
        IF FindLF& THEN
            TempCaption$ = LEFT$(TempText$, FindLF& - 1)
            TempText$ = MID$(TempText$, FindLF& + 1)
        ELSE
            TempCaption$ = TempText$
            TempText$ = ""
        END IF
        ListItems$(ThisItem%) = TempCaption$
    LOOP
    IF TIMER - LastListKeyHit < 1 THEN
        SearchPattern$ = SearchPattern$ + UCASE$(CHR$(__UI_KeyHit))
        ThisItem% = This.Value
    ELSE
        SearchPattern$ = UCASE$(CHR$(__UI_KeyHit))
        ThisItem% = This.Value + 1
        IF ThisItem% > This.Max THEN ThisItem% = 1
    END IF
    DO
        IF UCASE$(LEFT$(ListItems$(ThisItem%), LEN(SearchPattern$))) = SearchPattern$ THEN
            This.Value = ThisItem%
            __UI_ValueChanged This.ID
            EXIT DO
        END IF
        ThisItem% = ThisItem% + 1
        IF ThisItem% > This.Max THEN ThisItem% = 1
        IF ThisItem% = This.Value THEN EXIT DO
    LOOP
    LastListKeyHit = TIMER
END SUB
SUB __UI_PrintString(Left AS INTEGER, Top AS INTEGER, Text$)
    DIM Utf$
    IF LEFT$(Text$, 1) = CHR$(7) AND (_FONT = 8 OR _FONT = 16) THEN
        Utf$ = Text$
    ELSE
        IF Control(__UI_FormID).Encoding = 1252 THEN
            Utf$ = FromCP1252$(Text$)
        ELSE 'Default to 437
            Utf$ = FromCP437$(Text$)
        END IF
    END IF
    REDIM __UI_ThisLineChars(0 TO LEN(Utf$)) AS LONG
    uprint_extra Left, Top, _OFFSET(Utf$), LEN(Utf$), True, True, __UI_LastRenderedLineWidth, _OFFSET(__UI_ThisLineChars()), __UI_LastRenderedCharCount, _DEFAULTCOLOR, 0
    REDIM _PRESERVE __UI_ThisLineChars(__UI_LastRenderedCharCount) AS LONG
END SUB
FUNCTION __UI_PrintWidth&(Text$)
    __UI_PrintWidth& = uprintwidth(Text$, LEN(Text$), 0)
END FUNCTION
FUNCTION __UI_WordWrap$ (PassedText AS STRING, Width AS INTEGER, LongestLine AS INTEGER, Lines AS INTEGER)
    DIM Temp$, TempCaption$, FindSep AS LONG, PrevSep AS LONG
    DIM NextSlot AS LONG, TempLine$, i AS LONG, Text AS STRING
    DIM ThisLineWidth AS INTEGER
    Text = RTRIM$(PassedText)
    IF Text = "" THEN Lines = 1: EXIT FUNCTION
    FOR i = 1 TO UBOUND(__UI_WordWrapHistoryTexts)
        IF __UI_WordWrapHistoryTexts(i) = "" THEN EXIT FOR
        IF __UI_WordWrapHistoryTexts(i) = Text THEN
            IF  __UI_WordWrapHistory(i).Width = Width AND __UI_WordWrapHistory(i).Font = _FONT THEN
                __UI_WordWrap$ = __UI_WordWrapHistoryResults(i)
                Lines = __UI_WordWrapHistory(i).TotalLines
                LongestLine = __UI_WordWrapHistory(i).LongestLine
                EXIT FUNCTION
            ELSE
                EXIT FOR
            ENDIF
        END IF
    NEXT
    NextSlot = i
    IF NextSlot > UBOUND(__UI_WordWrapHistory) THEN
        REDIM _PRESERVE __UI_WordWrapHistory(1 TO NextSlot + 99) AS __UI_WordWrapHistoryType
        REDIM _PRESERVE __UI_WordWrapHistoryTexts(1 TO NextSlot + 99) AS STRING
        REDIM _PRESERVE __UI_WordWrapHistoryResults(1 TO NextSlot + 99) AS STRING
    END IF
    __UI_WordWrapHistoryTexts(NextSlot) = Text
    __UI_WordWrapHistory(NextSlot).Width = Width
    __UI_WordWrapHistory(NextSlot).Font = _FONT
    Lines = 0
    LongestLine = 0
    TempCaption$ = Text
    IF __UI_PrintWidth&(TempCaption$) > Width THEN
        DO WHILE LEN(TempCaption$)
            FindSep = INSTR(TempCaption$, CHR$(10)) 'process the passed text line by line
            IF FindSep > 0 THEN
                TempLine$ = LEFT$(TempCaption$, FindSep - 1)
                TempCaption$ = MID$(TempCaption$, FindSep + 1)
            ELSE
                TempLine$ = TempCaption$
                TempCaption$ = ""
            END IF
            DO WHILE LEN(TempLine$)
                IF __UI_PrintWidth&(TempLine$) < Width THEN
                    IF LEN(Temp$) > 0 THEN Temp$ = Temp$ + CHR$(1)
                    ThisLineWidth = __UI_PrintWidth(Templine$)
                    IF LongestLine < ThisLineWidth THEN LongestLine = ThisLineWidth
                    Temp$ = Temp$ + TempLine$
                    TempLine$ = ""
                    Lines = Lines + 1
                ELSE
                    PrevSep = 0
                    DO
                        FindSep = INSTR(PrevSep + 1, TempLine$, " ")
                        IF FindSep > 0 THEN
                            IF __UI_PrintWidth(LEFT$(TempLine$, FindSep - 1)) > Width THEN
                                IF PrevSep = 0 THEN
                                    IF LEN(Temp$) > 0 THEN Temp$ = Temp$ + CHR$(1)
                                    Temp$ = Temp$ + LEFT$(TempLine$, FindSep - 1)
                                    TempLine$ = MID$(TempLine$, FindSep + 1)
                                    Lines = Lines + 1
                                    EXIT DO
                                ELSE
                                    IF LEN(Temp$) > 0 THEN Temp$ = Temp$ + CHR$(1)
                                    Temp$ = Temp$ + LEFT$(TempLine$, PrevSep - 1)
                                    ThisLineWidth = __UI_PrintWidth(LEFT$(TempLine$, PrevSep - 1))
                                    IF LongestLine < ThisLineWidth THEN LongestLine = ThisLineWidth
                                    TempLine$ = MID$(TempLine$, PrevSep + 1)
                                    Lines = Lines + 1
                                    EXIT DO
                                END IF
                            END IF
                            PrevSep = FindSep
                        ELSE
                            IF PrevSep > 0 THEN
                                IF LEN(Temp$) > 0 THEN Temp$ = Temp$ + CHR$(1)
                                Temp$ = Temp$ + LEFT$(TempLine$, PrevSep - 1)
                                ThisLineWidth = __UI_PrintWidth(LEFT$(TempLine$, PrevSep - 1))
                                IF LongestLine < ThisLineWidth THEN LongestLine = ThisLineWidth
                                TempLine$ = MID$(TempLine$, PrevSep + 1)
                                Lines = Lines + 1
                                EXIT DO
                            ELSE
                                IF LEN(Temp$) > 0 THEN Temp$ = Temp$ + CHR$(1)
                                Temp$ = Temp$ + Templine$
                                ThisLineWidth = __UI_PrintWidth(Templine$)
                                IF LongestLine < ThisLineWidth THEN LongestLine = ThisLineWidth
                                TempLine$ = ""
                                Lines = Lines + 1
                                EXIT DO
                            END IF
                        END IF
                    LOOP
                END IF
            LOOP
        LOOP
        __UI_WordWrap$ = Temp$
        __UI_WordWrapHistoryResults(NextSlot) = Temp$
        __UI_WordWrapHistory(NextSlot).TotalLines = Lines
        __UI_WordWrapHistory(NextSlot).LongestLine = LongestLine
    ELSE
        Lines = 1
        LongestLine = 0
        Temp$ = TempCaption$
        FindSep = INSTR(TempCaption$, CHR$(10))
        IF FindSep > 0 THEN
            Temp$ = ""
            Lines = 0
            DO WHILE LEN(TempCaption$)
                FindSep = INSTR(TempCaption$, CHR$(10))
                IF FindSep > 0 THEN
                    Lines = Lines + 1
                    IF LEN(Temp$) > 0 THEN Temp$ = Temp$ + CHR$(1)
                    Temp$ = Temp$ + LEFT$(TempCaption$, FindSep - 1)
                    ThisLineWidth = __UI_PrintWidth(LEFT$(TempCaption$, FindSep - 1))
                    IF LongestLine < ThisLineWidth THEN LongestLine = ThisLineWidth
                    TempCaption$ = MID$(TempCaption$, FindSep + 1)
                ELSE
                    Lines = Lines + 1
                    Temp$ = Temp$ + CHR$(1) + TempCaption$
                    EXIT DO
                END IF
            LOOP
        ELSE
            LongestLine = __UI_PrintWidth(TempCaption$)
        END IF
        __UI_WordWrap$ = Temp$
        __UI_WordWrapHistoryResults(NextSlot) = Temp$
        __UI_WordWrapHistory(NextSlot).TotalLines = Lines
        __UI_WordWrapHistory(NextSlot).LongestLine = LongestLine
    END IF
END FUNCTION
FUNCTION MessageBox& (Message$, Title$, Setup AS LONG)
    _DELAY .1 'So the interface can redraw before the messagebox kicks in
    IF Title$ = "" THEN Title$ = __UI_CurrentTitle
    $IF WIN THEN
        MessageBox& = __UI_MB(0, Replace(Message$, "\n", CHR$(10), False, 0) + CHR$(0), Title$ + CHR$(0), Setup + MsgBox_SystemModal + MsgBox_SetForeground)
    $ELSE
        IF (Setup AND 4) THEN
        MessageBox& = __UI_MB(0, Replace(Message$, "\n", CHR$(10), False, 0) + CHR$(0), Title$ + CHR$(0), 4)
        ELSE
        MessageBox& = __UI_MB(0, Replace(Message$, "\n", CHR$(10), False, 0) + CHR$(0), Title$ + CHR$(0), 0)
        END IF
    $END IF
END FUNCTION
FUNCTION __UI_MAP! (value!, minRange!, maxRange!, newMinRange!, newMaxRange!)
    __UI_MAP! = ((value! - minRange!) / (maxRange! - minRange!)) * (newMaxRange! - newMinRange!) + newMinRange!
END FUNCTION
SUB __UI_ActivateDropdownlist (This AS __UI_ControlTYPE)
    IF NOT This.Disabled THEN
        __UI_ParentDropdownList = This.ID
        __UI_ActiveDropdownList = __UI_NewControl(__UI_Type_ListBox, RTRIM$(This.Name) + CHR$(254) + "DropdownList", 0, 0, 0, 0, 0)
        Text(__UI_ActiveDropdownList) = Text(This.ID)
        Control(__UI_ActiveDropdownList).Left = This.Left + Control(This.ParentID).Left
        Control(__UI_ActiveDropdownList).Width = This.Width
        Control(__UI_ActiveDropdownList).Top = This.Top + This.Height + Control(This.ParentID).Top
        DIM MaxVisible AS INTEGER
        IF This.Max > 14 THEN MaxVisible = 14 ELSE MaxVisible = This.Max
        _FONT This.Font
        Control(__UI_ActiveDropdownList).Height = (uspacing& + (((_FONT = 8) * -1) * __UI_Font8Offset + ((_FONT = 16) * -1) * __UI_Font16Offset) + 3) * (MaxVisible + .5)
        IF Control(__UI_ActiveDropdownList).Top + Control(__UI_ActiveDropdownList).Height > Control(__UI_FormID).Height THEN
            Control(__UI_ActiveDropdownList).Top = Control(__UI_FormID).Height - Control(__UI_ActiveDropdownList).Height
        END IF
        Control(__UI_ActiveDropdownList).Max = This.Max
        Control(__UI_ActiveDropdownList).Value = This.Value
        Control(__UI_ActiveDropdownList).ForeColor = This.ForeColor
        Control(__UI_ActiveDropdownList).BackColor = This.BackColor
        Control(__UI_ActiveDropdownList).SelectedForeColor = This.SelectedForeColor
        Control(__UI_ActiveDropdownList).SelectedBackColor = This.SelectedBackColor
        Control(__UI_ActiveDropdownList).Font = This.Font
        Control(__UI_ActiveDropdownList).HasBorder = True
        Control(__UI_ActiveDropdownList).BorderSize = 1
        Control(__UI_ActiveDropdownList).BorderColor = _RGB32(0, 0, 0)
        Control(__UI_ActiveDropdownList).CanHaveFocus = True
        Control(__UI_ActiveDropdownList).InputViewStart = 1
        Control(__UI_ActiveDropdownList).LastVisibleItem = MaxVisible
        __UI_Focus = __UI_ActiveDropdownList
        IF Control(__UI_Focus).Value < Control(__UI_Focus).InputViewStart THEN
            Control(__UI_Focus).InputViewStart = Control(__UI_Focus).Value
        ELSEIF Control(__UI_Focus).Value > Control(__UI_Focus).InputViewStart + Control(__UI_Focus).LastVisibleItem - 1 THEN
            Control(__UI_Focus).InputViewStart = Control(__UI_Focus).Value - Control(__UI_Focus).LastVisibleItem + 1
        END IF
    END IF
END SUB
SUB __UI_CloseAllMenus
    DIM i AS LONG
    FOR i = 1 TO UBOUND(Control)
        IF Control(i).Type = __UI_Type_MenuPanel THEN
            __UI_DestroyControl Control(i)
        END IF
    NEXT
END SUB
FUNCTION __UI_GetActiveMenuIndex(id AS LONG)
    DIM i AS LONG
    FOR i = 1 TO __UI_TotalActiveMenus
        IF __UI_ActiveMenu(i) = id THEN
            __UI_GetActiveMenuIndex = i
            EXIT FUNCTION
        END IF
    NEXT
END FUNCTION
FUNCTION __UI_GetParentMenu(id AS LONG)
    DIM i AS LONG
    FOR i = 1 TO __UI_TotalActiveMenus
        IF __UI_ActiveMenu(i) = id THEN
            __UI_GetParentMenu = __UI_ParentMenu(i)
            EXIT FUNCTION
        END IF
    NEXT
END FUNCTION
SUB __UI_ActivateMenu (This AS __UI_ControlTYPE, SelectFirstItem AS _BYTE)
    DIM i AS LONG, ItemHeight AS SINGLE, TotalItems AS INTEGER
    DIM CurrentGroup AS INTEGER, ComboSpacing AS INTEGER
    IF NOT This.Disabled THEN
        IF This.Type = __UI_Type_ContextMenu THEN __UI_CloseAllMenus: __UI_ForceRedraw = True
        IF __UI_GetID(RTRIM$(This.Name) + CHR$(254) + "Panel") > 0 THEN
            __UI_ActiveMenu(__UI_TotalActiveMenus) = __UI_GetID(RTRIM$(This.Name) + CHR$(254) + "Panel")
            IF NOT __UI_DesignMode THEN EXIT SUB
        ELSE
            IF __UI_TotalActiveMenus + 1 > UBOUND(__UI_ActiveMenu) THEN
                EXIT SUB
            END IF
            __UI_ActiveMenu(__UI_TotalActiveMenus + 1) = __UI_NewControl(__UI_Type_MenuPanel, RTRIM$(This.Name) + CHR$(254) + "Panel", 0, 0, 0, 0, 0)
            __UI_TotalActiveMenus = __UI_TotalActiveMenus + 1
            IF __UI_ActiveMenu(__UI_TotalActiveMenus) = 0 THEN
                __UI_TotalActiveMenus = __UI_TotalActiveMenus - 1
                EXIT SUB
            END IF
        END IF
        Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).SourceControl = This.ID
        __UI_ParentMenu(__UI_TotalActiveMenus) = This.ID
        Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Font = This.Font
        _FONT (This.Font)
        IF This.Type = __UI_Type_MenuBar THEN
            Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Left = This.Left
            Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Top = falcon_uspacing& + (((_FONT = 8) * -1) * __UI_Font8Offset + ((_FONT = 16) * -1) * __UI_Font16Offset) + 3
            __UI_TopMenuBarItem = This.ID
        ELSEIF This.Type = __UI_Type_MenuItem THEN
            Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Left = Control(This.MenuPanelID).Left + Control(This.MenuPanelID).Width - __UI_MenuItemOffset / 4
            Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Top = Control(This.MenuPanelID).Top + This.Top
        ELSEIF This.Type = __UI_Type_ContextMenu THEN
            IF __UI_DesignMode AND LEFT$(This.Name, 5) <> "__UI_" THEN
                Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Left = This.Left + This.Width
                Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Top = Control(__UI_FormID).Height
            ELSE
                Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Left = __UI_MouseLeft
                Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Top = __UI_MouseTop
            END IF
            __UI_ActiveMenuIsContextMenu = True
        END IF
        ItemHeight = falcon_uspacing& + (((_FONT = 8) * -1) * __UI_Font8Offset + ((_FONT = 16) * -1) * __UI_Font16Offset) + 3
        Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Height = (((_FONT = 8) * -1) * 3 + falcon_uspacing&) / 4
        Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Width = 0
        CurrentGroup = 1
        ComboSpacing = 0
        FOR i = 1 TO UBOUND(Control)
            IF Control(i).ParentID = This.ID AND NOT Control(i).Hidden THEN
                TotalItems = TotalItems + 1
                Control(i).Width = __UI_MenuItemOffset * 2 + __UI_PrintWidth(Caption(i))
                IF Control(i).KeyCombo > 0 THEN
                    IF __UI_MenuItemOffset + __UI_PrintWidth(RTRIM$(__UI_KeyCombo(Control(i).KeyCombo).FriendlyCombo)) > ComboSpacing THEN
                        ComboSpacing = __UI_MenuItemOffset + __UI_PrintWidth(RTRIM$(__UI_KeyCombo(Control(i).KeyCombo).FriendlyCombo))
                    END IF
                END IF
                IF Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Width < Control(i).Width THEN
                    Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Width = Control(i).Width
                END IF
                Control(i).Top = Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Height
                Control(i).Height = ItemHeight
                Control(i).MenuPanelID = Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).ID
                Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Height = Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Height + ItemHeight
                Control(i).MenuItemGroup = CurrentGroup
                IF RIGHT$(Caption(i), 1) = "-" THEN 'Separator
                    Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Height = Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Height + ItemHeight / 3
                    CurrentGroup = CurrentGroup + 1
                END IF
            END IF
        NEXT
        Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Height = Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Height + (((((_FONT = 8) * -1) * __UI_Font8Offset + ((_FONT = 16) * -1) * __UI_Font16Offset) + falcon_uspacing&) / 4)
        IF Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Width = 0 THEN Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Width = Control(__UI_FormID).Width / 4
        Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Width = Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Width + ComboSpacing
        IF __UI_DesignMode AND LEFT$(This.Name, 5) <> "__UI_" THEN Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Height = Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Height + ItemHeight
        IF Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Left + Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Width > Control(__UI_FormID).Width THEN
            Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Left = Control(__UI_FormID).Width - Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Width - 5
            IF This.Type = __UI_Type_MenuItem THEN
                Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Left = Control(This.MenuPanelID).Left - Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Width + __UI_MenuItemOffset / 4
            END IF
        END IF
        IF Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Top + Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Height > Control(__UI_FormID).Height THEN
            Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Top = Control(__UI_FormID).Height - Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Height - 5
            IF __UI_DesignMode AND LEFT$(This.Name, 5) <> "__UI_" THEN Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Top = Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Top - This.Height
        END IF
        IF SelectFirstItem AND NOT __UI_DesignMode AND TotalItems > 0 THEN
            __UI_Focus = __UI_NextMenuItem(0)
        ELSE
            IF TotalItems = 0 THEN
                Control(__UI_ActiveMenu(__UI_TotalActiveMenus)).Width = __UI_MenuItemOffset * 2 + __UI_PrintWidth("Add new")
            END IF
            __UI_Focus = __UI_ActiveMenu(__UI_TotalActiveMenus)
        END IF
    END IF
END SUB
SUB __UI_DoEvents
    __UI_ProcessInput
    IF __UI_HasInput THEN
        __UI_EventDispatcher
    END IF
END SUB
FUNCTION __UI_TrimAt0$(Text$)
    IF INSTR(Text$, CHR$(0)) > 0 THEN
        __UI_TrimAt0$ = LEFT$(Text$, INSTR(Text$, CHR$(0)) - 1)
    ELSE
        __UI_TrimAt0$ = Text$
    END IF
END FUNCTION
SUB __UI_MakeHardwareImageFromCanvas (This AS __UI_ControlTYPE)
    DIM TempCanvas AS LONG
    IF This.ID = 0 OR This.Canvas = 0 OR __UI_DesignMode = True THEN EXIT SUB
    IF This.ParentID = 0 THEN
        TempCanvas = _COPYIMAGE(This.Canvas, 33)
        IF This.Canvas <> 0 THEN _FREEIMAGE This.Canvas
        This.Canvas = TempCanvas
    END IF
END SUB
SUB __UI_MakeHardwareImage (This AS LONG)
    DIM TempCanvas AS LONG
    IF __UI_DesignMode = True THEN EXIT SUB
    TempCanvas = _COPYIMAGE(This, 33)
    _FREEIMAGE This
    This = TempCanvas
END SUB
FUNCTION __UI_FirstMenuBarControl
    DIM i AS LONG
    FOR i = 1 TO UBOUND(Control)
        IF Control(i).ID > 0 AND Control(i).Type = __UI_Type_MenuBar AND NOT Control(i).Hidden THEN
            __UI_FirstMenuBarControl = i
            EXIT FUNCTION
        END IF
    NEXT
END FUNCTION
FUNCTION __UI_NextMenuBarControl (CurrentMenuBarControl)
    DIM i AS LONG
    i = CurrentMenuBarControl
    DO
        i = i + 1
        IF i > UBOUND(Control) THEN i = 1
        IF i = CurrentMenuBarControl THEN EXIT DO
        IF Control(i).Type = __UI_Type_MenuBar AND NOT Control(i).Hidden AND NOT Control(i).Disabled THEN
            EXIT DO
        END IF
    LOOP
    __UI_NextMenuBarControl = i
END FUNCTION
FUNCTION __UI_PreviousMenuBarControl (CurrentMenuBarControl)
    DIM i AS LONG
    i = CurrentMenuBarControl
    DO
        i = i - 1
        IF i < 1 THEN i = UBOUND(Control)
        IF i = CurrentMenuBarControl THEN EXIT DO
        IF Control(i).Type = __UI_Type_MenuBar AND NOT Control(i).Hidden AND NOT Control(i).Disabled THEN
            EXIT DO
        END IF
    LOOP
    __UI_PreviousMenuBarControl = i
END FUNCTION
FUNCTION __UI_NextMenuItem (CurrentMenuItemControl)
    DIM i AS LONG
    i = CurrentMenuItemControl
    DO
        i = i + 1
        IF i > UBOUND(Control) THEN i = 1
        IF i = CurrentMenuItemControl THEN EXIT DO
        IF Control(i).Type = __UI_Type_MenuItem AND NOT Control(i).Hidden AND Control(i).ParentID = __UI_ParentMenu(__UI_TotalActiveMenus) THEN
            EXIT DO
        END IF
    LOOP
    __UI_NextMenuItem = i
END FUNCTION
FUNCTION __UI_PreviousMenuItem (CurrentMenuItemControl)
    DIM i AS LONG
    i = CurrentMenuItemControl
    DO
        i = i - 1
        IF i < 1 THEN i = UBOUND(Control)
        IF i = CurrentMenuItemControl THEN EXIT DO
        IF Control(i).Type = __UI_Type_MenuItem AND NOT Control(i).Hidden AND Control(i).ParentID = __UI_ParentMenu(__UI_TotalActiveMenus) THEN
            EXIT DO
        END IF
    LOOP
    __UI_PreviousMenuItem = i
END FUNCTION
SUB __UI_RefreshMenuBar
    DIM LeftOffset AS INTEGER, i AS LONG
    DIM TotalItems AS INTEGER, LastMenuItem AS LONG
    _FONT (Control(__UI_FormID).Font)
    FOR i = 1 TO UBOUND(Control)
        IF Control(i).ID > 0 THEN
            IF Control(i).Type = __UI_Type_MenuBar AND NOT Control(i).Hidden THEN
                TotalItems = TotalItems + 1
                IF TotalItems = 1 THEN
                    LeftOffset = __UI_MenuBarOffset
                ELSE
                    LeftOffset = LeftOffset + Control(LastMenuItem).Width
                END IF
                Control(i).Width = __UI_MenuBarOffset + __UI_PrintWidth(Caption(i)) + __UI_MenuBarOffset
                IF Control(i).Align = __UI_Left THEN
                    Control(i).Left = LeftOffset
                ELSE
                    Control(i).Left = Control(__UI_FormID).Width - 1 - __UI_MenuBarOffset - Control(i).Width
                END IF
                LastMenuItem = i
                __UI_NewMenuBarTextLeft = Control(i).Left + Control(i).Width
            END IF
        END IF
    NEXT
END SUB
FUNCTION FromCP437$ (source$)
    STATIC init&
    IF init& = 0 THEN
        DIM i&
        FOR i& = 0 TO 127
            table437$(i&) = CHR$(i&)
        NEXT i&
        table437$(7) = CHR$(226) + CHR$(151) + CHR$(143) 'UTF-8 e2978f
        table437$(128) = CHR$(&HE2) + CHR$(&H82) + CHR$(&HAC)
        table437$(128) = CHR$(&HC3) + CHR$(&H87)
        table437$(129) = CHR$(&HC3) + CHR$(&HBC)
        table437$(130) = CHR$(&HC3) + CHR$(&HA9)
        table437$(131) = CHR$(&HC3) + CHR$(&HA2)
        table437$(132) = CHR$(&HC3) + CHR$(&HA4)
        table437$(133) = CHR$(&HC3) + CHR$(&HA0)
        table437$(134) = CHR$(&HC3) + CHR$(&HA5)
        table437$(135) = CHR$(&HC3) + CHR$(&HA7)
        table437$(136) = CHR$(&HC3) + CHR$(&HAA)
        table437$(137) = CHR$(&HC3) + CHR$(&HAB)
        table437$(138) = CHR$(&HC3) + CHR$(&HA8)
        table437$(139) = CHR$(&HC3) + CHR$(&HAF)
        table437$(140) = CHR$(&HC3) + CHR$(&HAE)
        table437$(141) = CHR$(&HC3) + CHR$(&HAC)
        table437$(142) = CHR$(&HC3) + CHR$(&H84)
        table437$(143) = CHR$(&HC3) + CHR$(&H85)
        table437$(144) = CHR$(&HC3) + CHR$(&H89)
        table437$(145) = CHR$(&HC3) + CHR$(&HA6)
        table437$(146) = CHR$(&HC3) + CHR$(&H86)
        table437$(147) = CHR$(&HC3) + CHR$(&HB4)
        table437$(148) = CHR$(&HC3) + CHR$(&HB6)
        table437$(149) = CHR$(&HC3) + CHR$(&HB2)
        table437$(150) = CHR$(&HC3) + CHR$(&HBB)
        table437$(151) = CHR$(&HC3) + CHR$(&HB9)
        table437$(152) = CHR$(&HC3) + CHR$(&HBF)
        table437$(153) = CHR$(&HC3) + CHR$(&H96)
        table437$(154) = CHR$(&HC3) + CHR$(&H9C)
        table437$(155) = CHR$(&HC2) + CHR$(&HA2)
        table437$(156) = CHR$(&HC2) + CHR$(&HA3)
        table437$(157) = CHR$(&HC2) + CHR$(&HA5)
        table437$(158) = CHR$(&HE2) + CHR$(&H82) + CHR$(&HA7)
        table437$(159) = CHR$(&HC6) + CHR$(&H92)
        table437$(160) = CHR$(&HC3) + CHR$(&HA1)
        table437$(161) = CHR$(&HC3) + CHR$(&HAD)
        table437$(162) = CHR$(&HC3) + CHR$(&HB3)
        table437$(163) = CHR$(&HC3) + CHR$(&HBA)
        table437$(164) = CHR$(&HC3) + CHR$(&HB1)
        table437$(165) = CHR$(&HC3) + CHR$(&H91)
        table437$(166) = CHR$(&HC2) + CHR$(&HAA)
        table437$(167) = CHR$(&HC2) + CHR$(&HBA)
        table437$(168) = CHR$(&HC2) + CHR$(&HBF)
        table437$(169) = CHR$(&HE2) + CHR$(&H8C) + CHR$(&H90)
        table437$(170) = CHR$(&HC2) + CHR$(&HAC)
        table437$(171) = CHR$(&HC2) + CHR$(&HBD)
        table437$(172) = CHR$(&HC2) + CHR$(&HBC)
        table437$(173) = CHR$(&HC2) + CHR$(&HA1)
        table437$(174) = CHR$(&HC2) + CHR$(&HAB)
        table437$(175) = CHR$(&HC2) + CHR$(&HBB)
        table437$(176) = CHR$(&HE2) + CHR$(&H96) + CHR$(&H91)
        table437$(177) = CHR$(&HE2) + CHR$(&H96) + CHR$(&H92)
        table437$(178) = CHR$(&HE2) + CHR$(&H96) + CHR$(&H93)
        table437$(179) = CHR$(&HE2) + CHR$(&H94) + CHR$(&H82)
        table437$(180) = CHR$(&HE2) + CHR$(&H94) + CHR$(&HA4)
        table437$(181) = CHR$(&HE2) + CHR$(&H95) + CHR$(&HA1)
        table437$(182) = CHR$(&HE2) + CHR$(&H95) + CHR$(&HA2)
        table437$(183) = CHR$(&HE2) + CHR$(&H95) + CHR$(&H96)
        table437$(184) = CHR$(&HE2) + CHR$(&H95) + CHR$(&H95)
        table437$(185) = CHR$(&HE2) + CHR$(&H95) + CHR$(&HA3)
        table437$(186) = CHR$(&HE2) + CHR$(&H95) + CHR$(&H91)
        table437$(187) = CHR$(&HE2) + CHR$(&H95) + CHR$(&H97)
        table437$(188) = CHR$(&HE2) + CHR$(&H95) + CHR$(&H9D)
        table437$(189) = CHR$(&HE2) + CHR$(&H95) + CHR$(&H9C)
        table437$(190) = CHR$(&HE2) + CHR$(&H95) + CHR$(&H9B)
        table437$(191) = CHR$(&HE2) + CHR$(&H94) + CHR$(&H90)
        table437$(192) = CHR$(&HE2) + CHR$(&H94) + CHR$(&H94)
        table437$(193) = CHR$(&HE2) + CHR$(&H94) + CHR$(&HB4)
        table437$(194) = CHR$(&HE2) + CHR$(&H94) + CHR$(&HAC)
        table437$(195) = CHR$(&HE2) + CHR$(&H94) + CHR$(&H9C)
        table437$(196) = CHR$(&HE2) + CHR$(&H94) + CHR$(&H80)
        table437$(197) = CHR$(&HE2) + CHR$(&H94) + CHR$(&HBC)
        table437$(198) = CHR$(&HE2) + CHR$(&H95) + CHR$(&H9E)
        table437$(199) = CHR$(&HE2) + CHR$(&H95) + CHR$(&H9F)
        table437$(200) = CHR$(&HE2) + CHR$(&H95) + CHR$(&H9A)
        table437$(201) = CHR$(&HE2) + CHR$(&H95) + CHR$(&H94)
        table437$(202) = CHR$(&HE2) + CHR$(&H95) + CHR$(&HA9)
        table437$(203) = CHR$(&HE2) + CHR$(&H95) + CHR$(&HA6)
        table437$(204) = CHR$(&HE2) + CHR$(&H95) + CHR$(&HA0)
        table437$(205) = CHR$(&HE2) + CHR$(&H95) + CHR$(&H90)
        table437$(206) = CHR$(&HE2) + CHR$(&H95) + CHR$(&HAC)
        table437$(207) = CHR$(&HE2) + CHR$(&H95) + CHR$(&HA7)
        table437$(208) = CHR$(&HE2) + CHR$(&H95) + CHR$(&HA8)
        table437$(209) = CHR$(&HE2) + CHR$(&H95) + CHR$(&HA4)
        table437$(210) = CHR$(&HE2) + CHR$(&H95) + CHR$(&HA5)
        table437$(211) = CHR$(&HE2) + CHR$(&H95) + CHR$(&H99)
        table437$(212) = CHR$(&HE2) + CHR$(&H95) + CHR$(&H98)
        table437$(213) = CHR$(&HE2) + CHR$(&H95) + CHR$(&H92)
        table437$(214) = CHR$(&HE2) + CHR$(&H95) + CHR$(&H93)
        table437$(215) = CHR$(&HE2) + CHR$(&H95) + CHR$(&HAB)
        table437$(216) = CHR$(&HE2) + CHR$(&H95) + CHR$(&HAA)
        table437$(217) = CHR$(&HE2) + CHR$(&H94) + CHR$(&H98)
        table437$(218) = CHR$(&HE2) + CHR$(&H94) + CHR$(&H8C)
        table437$(219) = CHR$(&HE2) + CHR$(&H96) + CHR$(&H88)
        table437$(220) = CHR$(&HE2) + CHR$(&H96) + CHR$(&H84)
        table437$(221) = CHR$(&HE2) + CHR$(&H96) + CHR$(&H8C)
        table437$(222) = CHR$(&HE2) + CHR$(&H96) + CHR$(&H90)
        table437$(223) = CHR$(&HE2) + CHR$(&H96) + CHR$(&H80)
        table437$(224) = CHR$(&HCE) + CHR$(&HB1)
        table437$(225) = CHR$(&HC3) + CHR$(&H9F)
        table437$(226) = CHR$(&HCE) + CHR$(&H93)
        table437$(227) = CHR$(&HCF) + CHR$(&H80)
        table437$(228) = CHR$(&HCE) + CHR$(&HA3)
        table437$(229) = CHR$(&HCF) + CHR$(&H83)
        table437$(230) = CHR$(&HC2) + CHR$(&HB5)
        table437$(231) = CHR$(&HCF) + CHR$(&H84)
        table437$(232) = CHR$(&HCE) + CHR$(&HA6)
        table437$(233) = CHR$(&HCE) + CHR$(&H98)
        table437$(234) = CHR$(&HCE) + CHR$(&HA9)
        table437$(235) = CHR$(&HCE) + CHR$(&HB4)
        table437$(236) = CHR$(&HE2) + CHR$(&H88) + CHR$(&H9E)
        table437$(237) = CHR$(&HCF) + CHR$(&H86)
        table437$(238) = CHR$(&HCE) + CHR$(&HB5)
        table437$(239) = CHR$(&HE2) + CHR$(&H88) + CHR$(&HA9)
        table437$(240) = CHR$(&HE2) + CHR$(&H89) + CHR$(&HA1)
        table437$(241) = CHR$(&HC2) + CHR$(&HB1)
        table437$(242) = CHR$(&HE2) + CHR$(&H89) + CHR$(&HA5)
        table437$(243) = CHR$(&HE2) + CHR$(&H89) + CHR$(&HA4)
        table437$(244) = CHR$(&HE2) + CHR$(&H8C) + CHR$(&HA0)
        table437$(245) = CHR$(&HE2) + CHR$(&H8C) + CHR$(&HA1)
        table437$(246) = CHR$(&HC3) + CHR$(&HB7)
        table437$(247) = CHR$(&HE2) + CHR$(&H89) + CHR$(&H88)
        table437$(248) = CHR$(&HC2) + CHR$(&HB0)
        table437$(249) = CHR$(&HE2) + CHR$(&H88) + CHR$(&H99)
        table437$(250) = CHR$(&HC2) + CHR$(&HB7)
        table437$(251) = CHR$(&HE2) + CHR$(&H88) + CHR$(&H9A)
        table437$(252) = CHR$(&HE2) + CHR$(&H81) + CHR$(&HBF)
        table437$(253) = CHR$(&HC2) + CHR$(&HB2)
        table437$(254) = CHR$(&HE2) + CHR$(&H96) + CHR$(&HA0)
        table437$(255) = CHR$(&HC2) + CHR$(&HA0)
        init& = -1
    END IF
    FromCP437$ = UTF8$(source$, table437$())
END FUNCTION
FUNCTION FromCP1252$ (source$)
    STATIC init&
    IF init& = 0 THEN
        DIM i&
        FOR i& = 0 TO 127
            table1252$(i&) = CHR$(i&)
        NEXT i&
        table1252$(7) = CHR$(226) + CHR$(151) + CHR$(143) 'UTF-8 e2978f
        table1252$(128) = CHR$(&HE2) + CHR$(&H82) + CHR$(&HAC)
        table1252$(130) = CHR$(&HE2) + CHR$(&H80) + CHR$(&H9A)
        table1252$(131) = CHR$(&HC6) + CHR$(&H92)
        table1252$(132) = CHR$(&HE2) + CHR$(&H80) + CHR$(&H9E)
        table1252$(133) = CHR$(&HE2) + CHR$(&H80) + CHR$(&HA6)
        table1252$(134) = CHR$(&HE2) + CHR$(&H80) + CHR$(&HA0)
        table1252$(135) = CHR$(&HE2) + CHR$(&H80) + CHR$(&HA1)
        table1252$(136) = CHR$(&HCB) + CHR$(&H86)
        table1252$(137) = CHR$(&HE2) + CHR$(&H80) + CHR$(&HB0)
        table1252$(138) = CHR$(&HC5) + CHR$(&HA0)
        table1252$(139) = CHR$(&HE2) + CHR$(&H80) + CHR$(&HB9)
        table1252$(140) = CHR$(&HC5) + CHR$(&H92)
        table1252$(142) = CHR$(&HC5) + CHR$(&HBD)
        table1252$(145) = CHR$(&HE2) + CHR$(&H80) + CHR$(&H98)
        table1252$(146) = CHR$(&HE2) + CHR$(&H80) + CHR$(&H99)
        table1252$(147) = CHR$(&HE2) + CHR$(&H80) + CHR$(&H9C)
        table1252$(148) = CHR$(&HE2) + CHR$(&H80) + CHR$(&H9D)
        table1252$(149) = CHR$(&HE2) + CHR$(&H80) + CHR$(&HA2)
        table1252$(150) = CHR$(&HE2) + CHR$(&H80) + CHR$(&H93)
        table1252$(151) = CHR$(&HE2) + CHR$(&H80) + CHR$(&H94)
        table1252$(152) = CHR$(&HCB) + CHR$(&H9C)
        table1252$(153) = CHR$(&HE2) + CHR$(&H84) + CHR$(&HA2)
        table1252$(154) = CHR$(&HC5) + CHR$(&HA1)
        table1252$(155) = CHR$(&HE2) + CHR$(&H80) + CHR$(&HBA)
        table1252$(156) = CHR$(&HC5) + CHR$(&H93)
        table1252$(158) = CHR$(&HC5) + CHR$(&HBE)
        table1252$(159) = CHR$(&HC5) + CHR$(&HB8)
        table1252$(160) = CHR$(&HC2) + CHR$(&HA0)
        table1252$(161) = CHR$(&HC2) + CHR$(&HA1)
        table1252$(162) = CHR$(&HC2) + CHR$(&HA2)
        table1252$(163) = CHR$(&HC2) + CHR$(&HA3)
        table1252$(164) = CHR$(&HC2) + CHR$(&HA4)
        table1252$(165) = CHR$(&HC2) + CHR$(&HA5)
        table1252$(166) = CHR$(&HC2) + CHR$(&HA6)
        table1252$(167) = CHR$(&HC2) + CHR$(&HA7)
        table1252$(168) = CHR$(&HC2) + CHR$(&HA8)
        table1252$(169) = CHR$(&HC2) + CHR$(&HA9)
        table1252$(170) = CHR$(&HC2) + CHR$(&HAA)
        table1252$(171) = CHR$(&HC2) + CHR$(&HAB)
        table1252$(172) = CHR$(&HC2) + CHR$(&HAC)
        table1252$(173) = CHR$(&HC2) + CHR$(&HAD)
        table1252$(174) = CHR$(&HC2) + CHR$(&HAE)
        table1252$(175) = CHR$(&HC2) + CHR$(&HAF)
        table1252$(176) = CHR$(&HC2) + CHR$(&HB0)
        table1252$(177) = CHR$(&HC2) + CHR$(&HB1)
        table1252$(178) = CHR$(&HC2) + CHR$(&HB2)
        table1252$(179) = CHR$(&HC2) + CHR$(&HB3)
        table1252$(180) = CHR$(&HC2) + CHR$(&HB4)
        table1252$(181) = CHR$(&HC2) + CHR$(&HB5)
        table1252$(182) = CHR$(&HC2) + CHR$(&HB6)
        table1252$(183) = CHR$(&HC2) + CHR$(&HB7)
        table1252$(184) = CHR$(&HC2) + CHR$(&HB8)
        table1252$(185) = CHR$(&HC2) + CHR$(&HB9)
        table1252$(186) = CHR$(&HC2) + CHR$(&HBA)
        table1252$(187) = CHR$(&HC2) + CHR$(&HBB)
        table1252$(188) = CHR$(&HC2) + CHR$(&HBC)
        table1252$(189) = CHR$(&HC2) + CHR$(&HBD)
        table1252$(190) = CHR$(&HC2) + CHR$(&HBE)
        table1252$(191) = CHR$(&HC2) + CHR$(&HBF)
        table1252$(192) = CHR$(&HC3) + CHR$(&H80)
        table1252$(193) = CHR$(&HC3) + CHR$(&H81)
        table1252$(194) = CHR$(&HC3) + CHR$(&H82)
        table1252$(195) = CHR$(&HC3) + CHR$(&H83)
        table1252$(196) = CHR$(&HC3) + CHR$(&H84)
        table1252$(197) = CHR$(&HC3) + CHR$(&H85)
        table1252$(198) = CHR$(&HC3) + CHR$(&H86)
        table1252$(199) = CHR$(&HC3) + CHR$(&H87)
        table1252$(200) = CHR$(&HC3) + CHR$(&H88)
        table1252$(201) = CHR$(&HC3) + CHR$(&H89)
        table1252$(202) = CHR$(&HC3) + CHR$(&H8A)
        table1252$(203) = CHR$(&HC3) + CHR$(&H8B)
        table1252$(204) = CHR$(&HC3) + CHR$(&H8C)
        table1252$(205) = CHR$(&HC3) + CHR$(&H8D)
        table1252$(206) = CHR$(&HC3) + CHR$(&H8E)
        table1252$(207) = CHR$(&HC3) + CHR$(&H8F)
        table1252$(208) = CHR$(&HC3) + CHR$(&H90)
        table1252$(209) = CHR$(&HC3) + CHR$(&H91)
        table1252$(210) = CHR$(&HC3) + CHR$(&H92)
        table1252$(211) = CHR$(&HC3) + CHR$(&H93)
        table1252$(212) = CHR$(&HC3) + CHR$(&H94)
        table1252$(213) = CHR$(&HC3) + CHR$(&H95)
        table1252$(214) = CHR$(&HC3) + CHR$(&H96)
        table1252$(215) = CHR$(&HC3) + CHR$(&H97)
        table1252$(216) = CHR$(&HC3) + CHR$(&H98)
        table1252$(217) = CHR$(&HC3) + CHR$(&H99)
        table1252$(218) = CHR$(&HC3) + CHR$(&H9A)
        table1252$(219) = CHR$(&HC3) + CHR$(&H9B)
        table1252$(220) = CHR$(&HC3) + CHR$(&H9C)
        table1252$(221) = CHR$(&HC3) + CHR$(&H9D)
        table1252$(222) = CHR$(&HC3) + CHR$(&H9E)
        table1252$(223) = CHR$(&HC3) + CHR$(&H9F)
        table1252$(224) = CHR$(&HC3) + CHR$(&HA0)
        table1252$(225) = CHR$(&HC3) + CHR$(&HA1)
        table1252$(226) = CHR$(&HC3) + CHR$(&HA2)
        table1252$(227) = CHR$(&HC3) + CHR$(&HA3)
        table1252$(228) = CHR$(&HC3) + CHR$(&HA4)
        table1252$(229) = CHR$(&HC3) + CHR$(&HA5)
        table1252$(230) = CHR$(&HC3) + CHR$(&HA6)
        table1252$(231) = CHR$(&HC3) + CHR$(&HA7)
        table1252$(232) = CHR$(&HC3) + CHR$(&HA8)
        table1252$(233) = CHR$(&HC3) + CHR$(&HA9)
        table1252$(234) = CHR$(&HC3) + CHR$(&HAA)
        table1252$(235) = CHR$(&HC3) + CHR$(&HAB)
        table1252$(236) = CHR$(&HC3) + CHR$(&HAC)
        table1252$(237) = CHR$(&HC3) + CHR$(&HAD)
        table1252$(238) = CHR$(&HC3) + CHR$(&HAE)
        table1252$(239) = CHR$(&HC3) + CHR$(&HAF)
        table1252$(240) = CHR$(&HC3) + CHR$(&HB0)
        table1252$(241) = CHR$(&HC3) + CHR$(&HB1)
        table1252$(242) = CHR$(&HC3) + CHR$(&HB2)
        table1252$(243) = CHR$(&HC3) + CHR$(&HB3)
        table1252$(244) = CHR$(&HC3) + CHR$(&HB4)
        table1252$(245) = CHR$(&HC3) + CHR$(&HB5)
        table1252$(246) = CHR$(&HC3) + CHR$(&HB6)
        table1252$(247) = CHR$(&HC3) + CHR$(&HB7)
        table1252$(248) = CHR$(&HC3) + CHR$(&HB8)
        table1252$(249) = CHR$(&HC3) + CHR$(&HB9)
        table1252$(250) = CHR$(&HC3) + CHR$(&HBA)
        table1252$(251) = CHR$(&HC3) + CHR$(&HBB)
        table1252$(252) = CHR$(&HC3) + CHR$(&HBC)
        table1252$(253) = CHR$(&HC3) + CHR$(&HBD)
        table1252$(254) = CHR$(&HC3) + CHR$(&HBE)
        table1252$(255) = CHR$(&HC3) + CHR$(&HBF)
        init& = -1
    END IF
    FromCP1252$ = UTF8$(source$, table1252$())
END FUNCTION
FUNCTION UTF8$ (source$, table$())
    DIM i AS LONG, dest$
    FOR i = 1 TO LEN(source$)
        dest$ = dest$ + table$(ASC(source$, i))
    NEXT i
    UTF8$ = dest$
END FUNCTION
FUNCTION GetControlDrawOrder&(ctrlRef AS LONG)
    DIM i AS LONG
    FOR i& = 1 to UBOUND(ControlDrawOrder)
        IF ControlDrawOrder(i&) = ctrlRef THEN GetControlDrawOrder& = i&: EXIT FUNCTION
    NEXT i&
END FUNCTION
SUB __UI_ExpandControlDrawOrder (size&)
    REDIM _PRESERVE ControlDrawOrder(0 TO UBOUND(ControlDrawOrder) + size&) AS LONG
END SUB
FUNCTION IconPreview& (IconFile$)
    DIM IconFileNum AS INTEGER
    DIM Preferred AS INTEGER, Largest AS INTEGER
    DIM i AS LONG, a$
    TYPE ICONTYPE
        Reserved AS INTEGER: ID AS INTEGER: Count AS INTEGER
    END TYPE
    TYPE ICONENTRY
        PWidth AS _UNSIGNED _BYTE: PDepth AS _UNSIGNED _BYTE
        NumColors AS _BYTE: RES2 AS _BYTE
        NumberPlanes AS INTEGER: BitsPerPixel AS INTEGER
        DataSize AS LONG: DataOffset AS LONG
    END TYPE
    TYPE BMPENTRY
        ID AS STRING * 2: Size AS LONG: Res1 AS INTEGER: Res2 AS INTEGER: Offset AS LONG
    END TYPE
    TYPE BMPHeader
        Hsize AS LONG: PWidth AS LONG: PDepth AS LONG
        Planes AS INTEGER: BPP AS INTEGER
        Compression AS LONG: ImageBytes AS LONG
        Xres AS LONG: Yres AS LONG: NumColors AS LONG: SigColors AS LONG
    END TYPE
    DIM ICO AS ICONTYPE
    DIM BMP AS BMPENTRY
    DIM BMPHeader AS BMPHeader
    IF _FILEEXISTS(IconFile$) = 0 THEN EXIT FUNCTION
    IconFileNum = FREEFILE
    OPEN IconFile$ FOR BINARY AS #IconFileNum
    GET #IconFileNum, 1, ICO
    IF ICO.ID <> 1 THEN CLOSE #IconFileNum: EXIT FUNCTION
    DIM Entry(ICO.Count) AS ICONENTRY
    Preferred = 0
    Largest = 0
    FOR i = 1 TO ICO.Count
        GET #IconFileNum, , Entry(i)
        IF Entry(i).BitsPerPixel = 32 THEN
            IF Entry(i).PWidth = 0 THEN Entry(i).PWidth = 256
            IF Entry(i).PWidth > Largest THEN Largest = Entry(i).PWidth: Preferred = i
        END IF
    NEXT
    IF Preferred = 0 THEN EXIT FUNCTION
    a$ = SPACE$(Entry(Preferred).DataSize)
    GET #IconFileNum, Entry(Preferred).DataOffset + 1, a$
    CLOSE #IconFileNum
    IF LEFT$(a$, 4) = CHR$(137) + "PNG" THEN
        OPEN IconFile$ + ".preview.png" FOR BINARY AS #IconFileNum
        PUT #IconFileNum, 1, a$
        CLOSE #IconFileNum
        i = _LOADIMAGE(IconFile$ + ".preview.png", 32)
        IF i = -1 THEN i = 0
        IconPreview& = i
        KILL IconFile$ + ".preview.png"
        EXIT FUNCTION
    ELSE
        BMP.ID = "BM"
        BMP.Size = LEN(BMP) + LEN(BMPHeader) + LEN(a$)
        BMP.Offset = LEN(BMP) + LEN(BMPHeader)
        BMPHeader.Hsize = 40
        BMPHeader.PWidth = Entry(Preferred).PWidth
        BMPHeader.PDepth = Entry(Preferred).PDepth: IF BMPHeader.PDepth = 0 THEN BMPHeader.PDepth = 256
        BMPHeader.Planes = 1
        BMPHeader.BPP = 32
        OPEN IconFile$ + ".preview.bmp" FOR BINARY AS #IconFileNum
        PUT #IconFileNum, 1, BMP
        PUT #IconFileNum, , BMPHeader
        a$ = MID$(a$, 41)
        PUT #IconFileNum, , a$
        CLOSE #IconFileNum
        i = _LOADIMAGE(IconFile$ + ".preview.bmp", 32)
        IF i < -1 THEN 'Loaded properly
            _SOURCE i
            IF POINT(0, 0) = _RGB32(0, 0, 0) THEN _CLEARCOLOR _RGB32(0, 0, 0), i
            _SOURCE 0
        ELSE
            i = 0
        END IF
        IconPreview& = i
        KILL IconFile$ + ".preview.bmp"
        EXIT FUNCTION
    END IF
END FUNCTION
FUNCTION RestoreCHR$ (__Text$)
    DIM Text$, BackSlash AS LONG, SemiColon AS LONG
    DIM j AS LONG, tempNum$
    Text$ = __Text$
    IF INSTR(Text$, "\") = 0 THEN
        RestoreCHR$ = Text$
        EXIT FUNCTION
    END IF
    DO
        BackSlash = INSTR(BackSlash + 1, Text$, "\")
        IF BackSlash = 0 THEN EXIT DO
        SemiColon = INSTR(BackSlash + 1, Text$, ";")
        IF SemiColon = 0 THEN _CONTINUE
        IF MID$(Text$, BackSlash + 1, 1) = "\" THEN
            Text$ = LEFT$(Text$, BackSlash) + MID$(Text$, BackSlash + 2)
            _CONTINUE
        END IF
        tempNum$ = ""
        FOR j = BackSlash + 1 TO SemiColon - 1
            IF ASC(Text$, j) < 48 OR ASC(Text$, j) > 57 THEN tempNum$ = "": EXIT FOR
            tempNum$ = tempNum$ + MID$(Text$, j, 1)
        NEXT
        IF LEN(tempNum$) THEN
            Text$ = LEFT$(Text$, BackSlash - 1) + CHR$(VAL(tempNum$)) + MID$(Text$, SemiColon + 1)
        END IF
    LOOP
    RestoreCHR$ = Text$
END FUNCTION
FUNCTION __UI_StrUsing$ (format$, value##)
    DIM prevDest AS LONG, prevSource AS LONG
    DIM tempScreen AS LONG
    DIM i AS LONG, temp$
    DIM length AS LONG
    prevDest = _DEST
    prevSource = _SOURCE
    tempScreen = _NEWIMAGE(LEN(format$) * 2, 2, 0)
    _DEST tempScreen
    _SOURCE tempScreen
    PRINT USING format$; value##;
    length = POS(0) - 1
    temp$ = SPACE$(length)
    FOR i = 1 TO length
        ASC(temp$, i) = SCREEN(1, i)
    NEXT
    _DEST prevDest
    _SOURCE prevSource
    _FREEIMAGE tempScreen
    __UI_StrUsing$ = temp$
END FUNCTION
SUB __UI_Bind(id AS LONG, targetID AS LONG, __PropertyID$, __PropertyTargetID$)
    DIM PropertyID$, PropertyTargetID$
    PropertyID$ = UCASE$(__PropertyID$)
    PropertyTargetID$ = UCASE$(__PropertyTargetID$)
    IF Control(id).BoundTo > 0 THEN
        Control(Control(id).BoundTo).BoundTo = 0
    END IF
    IF Control(targetID).BoundTo > 0 THEN
        Control(Control(targetID).BoundTo).BoundTo = 0
    END IF
    Control(id).BoundTo = targetID
    Control(id).BoundProperty = __UI_PropertyEnum(PropertyID$, 0)
    IF Control(id).BoundProperty = 0 THEN Control(id).BoundTo = 0: EXIT SUB
    Control(targetID).BoundTo = id
    Control(targetID).BoundProperty = __UI_PropertyEnum(PropertyTargetID$, 0)
    IF Control(targetID).BoundProperty = 0 THEN
        Control(id).BoundTo = 0
        Control(targetID).BoundTo = 0
    END IF
    __UI_CheckBinding targetID 'acquire current value of targetID
END SUB
FUNCTION __UI_PropertyEnum& (__property$, index AS LONG)
    DIM property$, NextAt AS LONG
    STATIC EnumInitialized AS _BYTE, Enum$
    IF LEN(_TRIM$(__property$)) = 0 AND index = 0 THEN EXIT FUNCTION
    IF NOT EnumInitialized THEN
        RESTORE EnumNames
        DO
            READ property$
            IF property$ = "*" THEN EXIT DO
            Enum$ = Enum$ + "@" + property$
        LOOP
        Enum$ = Enum$ + "@"
        EnumInitialized = True
    END IF
    IF index > 0 THEN
        IF index > LEN(Enum$) THEN EXIT FUNCTION
        IF ASC(Enum$, index) <> 64 THEN EXIT FUNCTION
        NextAt = INSTR(index + 1, Enum$, "@")
        __property$ = MID$(Enum$, index + 1, NextAt - index - 1)
        __UI_PropertyEnum& = -1
    ELSE
        property$ = "@" + _TRIM$(UCASE$(__property$)) + "@"
        __UI_PropertyEnum& = INSTR(UCASE$(Enum$), property$)
    END IF
    EXIT FUNCTION
    EnumNames:
    DATA Top,Left,Width,Height,Bordersize,Padding,Value
    DATA Min,Max,Interval,MinInterval,Stretch,HasBorder,ShowPercentage
    DATA AutoScroll,AutoSize,PasswordMask,Disabled,Hidden
    DATA *
END FUNCTION
SUB __UI_UnBind(id AS LONG)
    IF Control(id).BoundTo > 0 THEN
        Control(Control(id).BoundTo).Redraw = True
        Control(Control(id).BoundTo).BoundTo = 0
        Control(id).BoundTo = 0
        Control(id).Redraw = True
    END IF
END SUB
SUB __UI_CheckBinding(id AS LONG)
    DIM BindTarget AS LONG, Temp AS _FLOAT
    BindTarget = Control(id).BoundTo
    IF BindTarget = 0 THEN EXIT SUB
    SELECT CASE Control(id).BoundProperty
        CASE __UI_PropertyEnum&("Top", 0)
            Temp = Control(id).Top
        CASE __UI_PropertyEnum&("Left", 0)
            Temp = Control(id).Left
        CASE __UI_PropertyEnum&("Width", 0)
            Temp = Control(id).Width
        CASE __UI_PropertyEnum&("Height", 0)
            Temp = Control(id).Height
        CASE __UI_PropertyEnum&("BorderSize", 0)
            Temp = Control(id).BorderSize
        CASE __UI_PropertyEnum&("Padding", 0)
            Temp = Control(id).Padding
        CASE __UI_PropertyEnum&("Value", 0)
            Temp = Control(id).Value
        CASE __UI_PropertyEnum&("Min", 0)
            Temp = Control(id).Min
        CASE __UI_PropertyEnum&("Max", 0)
            Temp = Control(id).Max
        CASE __UI_PropertyEnum&("Interval", 0)
            Temp = Control(id).Interval
        CASE __UI_PropertyEnum&("Mininterval", 0)
            Temp = Control(id).Mininterval
        CASE __UI_PropertyEnum&("Stretch", 0)
            Temp = Control(id).Stretch
        CASE __UI_PropertyEnum&("HasBorder", 0)
            Temp = Control(id).HasBorder
        CASE __UI_PropertyEnum&("ShowPercentage", 0)
            Temp = Control(id).ShowPercentage
        CASE __UI_PropertyEnum&("AutoScroll", 0)
            Temp = Control(id).AutoScroll
        CASE __UI_PropertyEnum&("AutoSize", 0)
            Temp = Control(id).AutoSize
        CASE __UI_PropertyEnum&("PasswordField", 0)
            Temp = Control(id).PasswordField
        CASE __UI_PropertyEnum&("Disabled", 0)
            Temp = Control(id).Disabled
        CASE __UI_PropertyEnum&("Hidden", 0)
            Temp = Control(id).Hidden
    END SELECT
    SELECT CASE Control(BindTarget).BoundProperty
        CASE __UI_PropertyEnum&("Top", 0)
            Control(BindTarget).Top = Temp
        CASE __UI_PropertyEnum&("Left", 0)
            Control(BindTarget).Left = Temp
        CASE __UI_PropertyEnum&("Width", 0)
            Control(BindTarget).Width = Temp
        CASE __UI_PropertyEnum&("Height", 0)
            Control(BindTarget).Height = Temp
        CASE __UI_PropertyEnum&("BorderSize", 0)
            Control(BindTarget).BorderSize = Temp
        CASE __UI_PropertyEnum&("Padding", 0)
            Control(BindTarget).Padding = Temp
        CASE __UI_PropertyEnum&("Value", 0)
            Control(BindTarget).Value = Temp
        CASE __UI_PropertyEnum&("Min", 0)
            Control(BindTarget).Min = Temp
        CASE __UI_PropertyEnum&("Max", 0)
            Control(BindTarget).Max = Temp
        CASE __UI_PropertyEnum&("Interval", 0)
            Control(BindTarget).Interval = Temp
        CASE __UI_PropertyEnum&("MinInterval", 0)
            Control(BindTarget).MinInterval = Temp
        CASE __UI_PropertyEnum&("Stretch", 0)
            Control(BindTarget).Stretch = Temp
        CASE __UI_PropertyEnum&("HasBorder", 0)
            Control(BindTarget).HasBorder = Temp
        CASE __UI_PropertyEnum&("ShowPercentage", 0)
            Control(BindTarget).ShowPercentage = Temp
        CASE __UI_PropertyEnum&("AutoScroll", 0)
            Control(BindTarget).AutoScroll = Temp
        CASE __UI_PropertyEnum&("AutoSize", 0)
            Control(BindTarget).AutoSize = Temp
        CASE __UI_PropertyEnum&("PasswordField", 0)
            Control(BindTarget).PasswordField = Temp
        CASE __UI_PropertyEnum&("Disabled", 0)
            Control(BindTarget).Disabled = Temp
        CASE __UI_PropertyEnum&("Hidden", 0)
            Control(BindTarget).Hidden = Temp
    END SELECT
    Control(id).Redraw = True
    Control(BindTarget).Redraw = True
END SUB
SUB __UI_DrawButton (This AS __UI_ControlTYPE, ControlState AS _BYTE)
    DIM TempCaption$
    DIM PrevDest AS LONG, TempControlState AS _BYTE
    STATIC ControlImage AS LONG
    CONST ButtonHeight = 21
    CONST ButtonWidth = 18
    IF ControlImage = 0 THEN ControlImage = __UI_LoadThemeImage("button.png")
    TempControlState = ControlState
    IF TempControlState = 1 THEN
        IF (This.ID = __UI_DefaultButtonID AND This.ID <> __UI_Focus AND Control(__UI_Focus).Type <> __UI_Type_Button) OR This.ID = __UI_Focus THEN
            TempControlState = 5
        END IF
    END IF
    IF This.Redraw OR This.ControlState <> TempControlState OR This.FocusState <> (__UI_Focus = This.ID) OR Caption(This.ID) <> __UI_TempCaptions(This.ID) OR This.PreviousParentID <> This.ParentID OR __UI_ForceRedraw _
       OR This.Font <> This.PreviousFont THEN
        This.Redraw = False
        This.ControlState = TempControlState
        This.PreviousFont = This.Font
        This.FocusState = __UI_Focus = This.ID
        __UI_TempCaptions(This.ID) = Caption(This.ID)
        This.PreviousParentID = This.ParentID
        IF This.ParentID THEN Control(This.ParentID).ChildrenRedrawn = True
        IF This.Canvas <> 0 THEN
            _FREEIMAGE This.Canvas
        END IF
        This.Canvas = _NEWIMAGE(This.Width, This.Height, 32)
        PrevDest = _DEST
        _DEST This.Canvas
        _FONT (This.Font)
        CLS , _RGBA32(0, 0, 0, 0)
        TempCaption$ = __UI_TrimAt0$(Caption(This.ID))
        _PUTIMAGE (0, 3)-(This.Width - 1, This.Height - 4), ControlImage, , (3, TempControlState * ButtonHeight - ButtonHeight + 3)-STEP(11, ButtonHeight - 7)
        DIM IconWidth AS INTEGER, IconHeight AS INTEGER
        IF This.HelperCanvas < -1 THEN
            IF LEN(TempCaption$) THEN
                IconHeight = This.Height - 6
                IconWidth = _WIDTH(This.HelperCanvas) * IconHeight / _HEIGHT(This.HelperCanvas)
                _PUTIMAGE ((This.Width \ 2 - __UI_PrintWidth&(TempCaption$) \ 2) - ((IconWidth / 2) + 5), This.Height / 2 - ((This.Height - 4) / 2) + 1)-STEP(IconWidth - 1, IconHeight - 1), This.HelperCanvas
            ELSE
                DIM PictureOffsetX AS INTEGER, PictureOffsetY AS INTEGER
                IF This.ControlState = 3 THEN
                    PictureOffsetX = 1
                    PictureOffsetY = 1
                END IF
                IconHeight = This.Height - 6
                IconWidth = _WIDTH(This.HelperCanvas) * (IconHeight / _HEIGHT(This.HelperCanvas))
                _PUTIMAGE (This.Width \ 2 - ((IconWidth \ 2)) + PictureOffsetX, This.Height / 2 - ((This.Height - 4) / 2) + 1 + PictureOffsetY)-STEP(IconWidth - 1, IconHeight - 1), This.HelperCanvas
            END IF
        END IF
        _PUTIMAGE (3, 0)-STEP(This.Width - 6, 3), ControlImage, , (3, TempControlState * ButtonHeight - ButtonHeight)-STEP(11, 3)
        _PUTIMAGE (3, This.Height - 3)-STEP(This.Width - 6, 3), ControlImage, , (3, TempControlState * ButtonHeight - ButtonHeight + 18)-STEP(11, 3)
        _PUTIMAGE (0, 2)-STEP(2, This.Height - 4), ControlImage, , (0, TempControlState * ButtonHeight - ButtonHeight + 2)-STEP(2, ButtonHeight - 6)
        _PUTIMAGE (0, 0), ControlImage, , (0, TempControlState * ButtonHeight - ButtonHeight)-STEP(2, 2)
        _PUTIMAGE (0, This.Height - 3), ControlImage, , (0, TempControlState * ButtonHeight - 3)-STEP(2, 2)
        _PUTIMAGE (This.Width - 3, 2)-STEP(2, This.Height - 4), ControlImage, , (ButtonWidth - 3, TempControlState * ButtonHeight - ButtonHeight + 2)-STEP(2, ButtonHeight - 6)
        _PUTIMAGE (This.Width - 2, 0), ControlImage, , (ButtonWidth - 2, TempControlState * ButtonHeight - ButtonHeight)-STEP(2, 2)
        _PUTIMAGE (This.Width - 3, This.Height - 3), ControlImage, , (ButtonWidth - 3, TempControlState * ButtonHeight - 3)-STEP(2, 2)
        IF NOT This.Disabled THEN
            COLOR This.ForeColor
        ELSE
            COLOR Darken(Control(__UI_FormID).BackColor, 80)
        END IF
        __UI_PrintString (IconWidth / 2) + (This.Width \ 2 - __UI_PrintWidth&(TempCaption$) \ 2), ((This.Height \ 2) - uheight& \ 2), TempCaption$
        IF (This.HotKey > 0 AND (__UI_ShowHotKeys AND NOT This.Disabled)) OR (This.HotKey > 0 AND __UI_DesignMode) THEN
            LINE ((This.Width \ 2 - __UI_PrintWidth&(TempCaption$) \ 2) + This.HotKeyOffset, ((This.Height \ 2) + uheight& \ 2))-STEP(__UI_PrintWidth&(CHR$(This.HotKey)) - 1, 0), This.ForeColor
        END IF
        IF __UI_Focus = This.ID AND __UI_KeyboardFocus THEN
            LINE (2, 2)-STEP(This.Width - 5, This.Height - 5), _RGB32(0, 0, 0), B , 21845
        END IF
        __UI_MakeHardwareImageFromCanvas This
        _DEST PrevDest
    END IF
    IF This.Canvas THEN _PUTIMAGE (This.Left, This.Top), This.Canvas
END SUB
SUB __UI_DrawLabel (This AS __UI_ControlTYPE, ControlState AS _BYTE)
    DIM PrevDest AS LONG, i AS LONG
    DIM CaptionIndent AS INTEGER, TempCaption$, TempLine$
    IF This.Redraw OR This.ControlState <> ControlState OR Caption(This.ID) <> __UI_TempCaptions(This.ID) OR This.PreviousParentID <> This.ParentID OR __UI_ForceRedraw _
       OR This.PreviousFont <> This.Font _
       OR Mask(This.ID) <> __UI_TempMask(This.ID) _
       OR This.Value <> This.PreviousValue _
       OR This.PrevAlign <> This.Align _
       OR This.PrevVAlign <> This.VAlign THEN
        This.Redraw = False
        This.ControlState = ControlState
        This.PreviousFont = This.Font
        __UI_TempCaptions(This.ID) = Caption(This.ID)
        __UI_TempMask(This.ID) = Mask(This.ID)
        This.PrevAlign = This.Align
        This.PrevVAlign = This.VAlign
        This.PreviousValue = This.Value
        IF This.ParentID THEN Control(This.ParentID).ChildrenRedrawn = True
        This.PreviousParentID = This.ParentID
        IF This.Canvas <> 0 THEN
            _FREEIMAGE This.Canvas
        END IF
        This.Canvas = _NEWIMAGE(This.Width, This.Height, 32)
        PrevDest = _DEST
        _DEST This.Canvas
        _FONT This.Font
        IF This.HasBorder THEN
            IF This.BorderSize > __UI_MaxBorderSize THEN
                This.BorderSize = __UI_MaxBorderSize
            ELSEIF This.BorderSize < 1 THEN
                This.BorderSize = 1
            END IF
            CaptionIndent = __UI_DefaultCaptionIndent + This.BorderSize
        END IF
        IF This.BackStyle = __UI_Opaque THEN
            CLS , This.BackColor
        ELSE
            CLS , _RGBA32(0, 0, 0, 0)
        END IF
        IF NOT This.Disabled THEN
            COLOR This.ForeColor
        ELSE
            COLOR Darken(Control(__UI_FormID).BackColor, 80)
        END IF
        DIM CaptionLeft AS INTEGER, FindLF&, FindSep&, ThisLine%
        DIM CaptionLeftFirstLine AS INTEGER, CaptionTopFirstLine AS INTEGER, TextTop%
        DIM TotalLines AS INTEGER
        IF This.WordWrap THEN
            TempCaption$ = __UI_TrimAt0$(__UI_WordWrap(Caption(This.ID), This.Width - ((CaptionIndent + This.Padding) * 2), 0, TotalLines))
            DO WHILE LEN(TempCaption$)
                ThisLine% = ThisLine% + 1
                IF This.VAlign = __UI_Top THEN
                    TextTop% = CaptionIndent + ThisLine% * uspacing& - uspacing&
                ELSEIF This.VAlign = __UI_Middle THEN
                    IF TotalLines < This.Height \ uspacing& THEN
                        TextTop% = (This.Height \ 2) - ((TotalLines * uspacing& - uspacing&) \ 2) - uspacing& \ 2 + (((ThisLine%) * uspacing& - uspacing&))
                    ELSE
                        TextTop% = CaptionIndent + ThisLine% * uspacing& - uspacing&
                    END IF
                ELSEIF This.VAlign = __UI_Bottom THEN
                    TextTop% = This.Height - CaptionIndent - (TotalLines * uspacing&) + (ThisLine% * uspacing& - uspacing&)
                END IF
                FindSep& = INSTR(TempCaption$, CHR$(1)) 'Search for soft breaks
                FindLF& = INSTR(TempCaption$, CHR$(10)) 'Search for hard breaks
                IF (FindSep& > 0 AND FindLF& > 0 AND FindSep& < FindLF&) OR (FindSep& > 0 AND FindLF& = 0) THEN
                    TempLine$ = LEFT$(TempCaption$, FindSep& - 1)
                    TempCaption$ = MID$(TempCaption$, FindSep& + 1)
                ELSEIF FindSep& = 0 THEN
                    IF FindLF& > 0 THEN
                        TempLine$ = LEFT$(TempCaption$, FindLF& - 1)
                        TempCaption$ = MID$(TempCaption$, FindLF& + 1)
                    ELSE
                        TempLine$ = TempCaption$
                        TempCaption$ = ""
                    END IF
                END IF
                SELECT CASE This.Align
                    CASE __UI_Left
                        CaptionLeft = CaptionIndent + This.Padding
                    CASE __UI_Center
                        CaptionLeft = (This.Width \ 2 - __UI_PrintWidth&(TempLine$) \ 2)
                    CASE __UI_Right
                        CaptionLeft = (This.Width - __UI_PrintWidth&(TempLine$)) - (CaptionIndent + This.Padding)
                END SELECT
                __UI_PrintString CaptionLeft, TextTop%, TempLine$
                IF ThisLine% = 1 THEN CaptionLeftFirstLine = CaptionLeft: CaptionTopFirstLine = TextTop%
            LOOP
            IF (This.HotKey > 0 AND (__UI_ShowHotKeys AND NOT This.Disabled)) OR (This.HotKey > 0 AND __UI_DesignMode) THEN
                LINE (CaptionLeftFirstLine + This.HotKeyOffset, CaptionTopFirstLine + uspacing&)-STEP(__UI_PrintWidth&(CHR$(This.HotKey)) - 1, 0), This.ForeColor
            END IF
        ELSE
            IF LEN(Mask(This.ID)) THEN
                TempCaption$ = __UI_StrUsing$(Mask(This.ID), This.Value)
            ELSE
                TempCaption$ = __UI_TrimAt0$(Caption(This.ID))
            END IF
            SELECT CASE This.Align
                CASE __UI_Left
                    CaptionLeft = CaptionIndent + This.Padding
                CASE __UI_Center
                    CaptionLeft = (This.Width \ 2 - __UI_PrintWidth&(TempCaption$) \ 2)
                CASE __UI_Right
                    CaptionLeft = This.Width - __UI_PrintWidth&(TempCaption$) - (CaptionIndent + This.Padding)
            END SELECT
            IF This.VAlign = __UI_Top THEN
                TextTop% = CaptionIndent
            ELSEIF This.VAlign = __UI_Middle THEN
                TextTop% = (This.Height \ 2) - uspacing& \ 2
            ELSEIF This.VAlign = __UI_Bottom THEN
                TextTop% = This.Height - CaptionIndent - uspacing&
            END IF
            CaptionLeftFirstLine = CaptionLeft
            __UI_PrintString CaptionLeft, TextTop%, TempCaption$
            IF (This.HotKey > 0 AND (__UI_ShowHotKeys AND NOT This.Disabled)) OR (This.HotKey > 0 AND __UI_DesignMode) THEN
                LINE (CaptionLeftFirstLine + This.HotKeyOffset, (TextTop% + uspacing&))-STEP(__UI_PrintWidth&(CHR$(This.HotKey)) - 1, 0), This.ForeColor
            END IF
        END IF
        IF This.HasBorder THEN
            FOR i = 0 TO This.BorderSize - 1
                LINE (i, i)-STEP(This.Width - 1 - i * 2, This.Height - 1 - i * 2), This.BorderColor, B
            NEXT
        END IF
        __UI_MakeHardwareImageFromCanvas This
        _DEST PrevDest
    END IF
    IF This.Canvas THEN _PUTIMAGE (This.Left, This.Top), This.Canvas
END SUB
SUB __UI_DrawToggleSwitch (This AS __UI_ControlTYPE, ControlState AS _BYTE)
    DIM PrevDest AS LONG
    DIM CaptionIndent AS INTEGER
    CONST ImageHeight = 15
    CONST ImageWidth = 30
    IF This.Redraw OR This.ControlState <> ControlState OR TIMER - This.LastChange < .5 OR This.FocusState <> (__UI_Focus = This.ID) OR Caption(This.ID) <> __UI_TempCaptions(This.ID) OR This.Value <> This.PreviousValue OR This.PreviousParentID <> This.ParentID _
       OR __UI_ForceRedraw OR This.PreviousFont <> This.Font THEN
        This.Redraw = False
        This.ControlState = ControlState
        This.PreviousFont = This.Font
        This.FocusState = __UI_Focus = This.ID
        IF This.PreviousValue <> This.Value THEN
            __UI_StateHasChanged = True
            This.PreviousValue = This.Value
        END IF
        __UI_TempCaptions(This.ID) = Caption(This.ID)
        IF This.ParentID THEN Control(This.ParentID).ChildrenRedrawn = True
        This.PreviousParentID = This.ParentID
        IF This.Canvas <> 0 THEN
            _FREEIMAGE This.Canvas
        END IF
        IF This.Height < ImageHeight THEN This.Height = ImageHeight
        IF This.Width < ImageWidth THEN This.Width = ImageWidth
        This.Canvas = _NEWIMAGE(This.Width + 1, This.Height + 1, 32)
        PrevDest = _DEST
        _DEST This.Canvas
        _FONT This.Font
        IF This.BackStyle = __UI_Opaque THEN
            CLS , This.BackColor
        ELSE
            CLS , _RGBA32(0, 0, 0, 0)
        END IF
        CaptionIndent = 0
        DIM AnimationOffset AS SINGLE
        AnimationOffset = __UI_MAP(TIMER - This.LastChange, 0, .2, This.Width / 2, 0)
        IF AnimationOffset < 0 THEN AnimationOffset = 0
        IF AnimationOffset > This.Width / 2 THEN AnimationOffset = This.Width / 2
        IF This.Value THEN
            IF NOT This.Disabled THEN
                LINE (0, 0)-(This.Width, This.Height), This.SelectedBackColor, BF
            ELSE
                LINE (0, 0)-(This.Width, This.Height), Darken(This.SelectedBackColor, 150), BF
            END IF
            LINE (This.Width / 2 + 4 - AnimationOffset, 4)-STEP(This.Width / 2 - 8, This.Height - 8), This.SelectedForeColor, BF
            LINE (0, 0)-(This.Width, This.Height), This.BorderColor, B
        ELSE
            IF NOT This.Disabled THEN
                LINE (0, 0)-(This.Width, This.Height), This.BackColor, BF
            ELSE
                LINE (0, 0)-(This.Width, This.Height), Darken(This.BackColor, 80), BF
            END IF
            LINE (4 + AnimationOffset, 4)-STEP(This.Width / 2 - 8, This.Height - 8), This.ForeColor, BF
            LINE (0, 0)-(This.Width, This.Height), This.BorderColor, B
        END IF
        IF __UI_Focus = This.ID AND __UI_KeyboardFocus THEN
            LINE (1, 1)-STEP(This.Width - 2, This.Height - 2), _RGB32(0, 0, 0), B , 21845
        END IF
        __UI_MakeHardwareImageFromCanvas This
        _DEST PrevDest
    END IF
    IF This.Canvas THEN _PUTIMAGE (This.Left, This.Top), This.Canvas
END SUB
SUB __UI_DrawRadioButton (This AS __UI_ControlTYPE, ControlState AS _BYTE)
    DIM PrevDest AS LONG
    DIM CaptionIndent AS INTEGER, TempCaption$
    STATIC ControlImage AS LONG
    CONST ImageHeight = 13
    CONST ImageWidth = 13
    IF ControlImage = 0 THEN ControlImage = __UI_LoadThemeImage("radiobutton.png")
    IF This.Redraw OR This.ControlState <> ControlState OR This.FocusState <> (__UI_Focus = This.ID) OR Caption(This.ID) <> __UI_TempCaptions(This.ID) OR This.Value <> This.PreviousValue OR This.PreviousParentID <> This.ParentID _
       OR __UI_ForceRedraw OR This.PreviousFont <> This.Font THEN
        This.Redraw = False
        This.PreviousFont = This.Font
        This.ControlState = ControlState
        This.FocusState = __UI_Focus = This.ID
        This.PreviousValue = This.Value
        __UI_TempCaptions(This.ID) = Caption(This.ID)
        IF This.ParentID THEN Control(This.ParentID).ChildrenRedrawn = True
        This.PreviousParentID = This.ParentID
        IF This.Canvas <> 0 THEN
            _FREEIMAGE This.Canvas
        END IF
        IF This.Height < ImageHeight THEN This.Height = ImageHeight
        This.Canvas = _NEWIMAGE(This.Width + 1, This.Height + 1, 32)
        PrevDest = _DEST
        _DEST This.Canvas
        _FONT This.Font
        IF This.BackStyle = __UI_Opaque THEN
            CLS , This.BackColor
        ELSE
            CLS , _RGBA32(0, 0, 0, 0)
        END IF
        CaptionIndent = 0
        IF This.HasBorder THEN
            CaptionIndent = 5
            LINE (0, 0)-STEP(This.Width - 1, This.Height - 1), This.BorderColor, B
        END IF
        IF This.Value THEN ControlState = ControlState + 4
        _PUTIMAGE (0, This.Height \ 2 - (ImageHeight \ 2))-STEP(ImageWidth - 1, ImageHeight - 1), ControlImage, , (0, ControlState * ImageHeight - ImageHeight)-STEP(12, 12)
        CaptionIndent = CaptionIndent + ImageWidth * 1.5
        TempCaption$ = __UI_TrimAt0$(Caption(This.ID))
        IF NOT This.Disabled THEN
            COLOR This.ForeColor
        ELSE
            COLOR Darken(Control(__UI_FormID).BackColor, 80)
        END IF
        __UI_PrintString CaptionIndent, ((This.Height \ 2) - uspacing& \ 2) + 1, TempCaption$
        IF (This.HotKey > 0 AND (__UI_ShowHotKeys AND NOT This.Disabled)) OR (This.HotKey > 0 AND __UI_DesignMode) THEN
            LINE (CaptionIndent + This.HotKeyOffset, ((This.Height \ 2) + uspacing& \ 2))-STEP(__UI_PrintWidth(CHR$(This.HotKey)) - 1, 0), This.ForeColor
        END IF
        IF __UI_Focus = This.ID AND __UI_KeyboardFocus THEN
            LINE (CaptionIndent - 1, 0)-STEP(This.Width - CaptionIndent - 1, This.Height - 1), _RGB32(0, 0, 0), B , 21845
        END IF
        __UI_MakeHardwareImageFromCanvas This
        _DEST PrevDest
    END IF
    IF This.Canvas THEN _PUTIMAGE (This.Left, This.Top), This.Canvas
END SUB
SUB __UI_DrawCheckBox (This AS __UI_ControlTYPE, ControlState AS _BYTE)
    DIM PrevDest AS LONG
    DIM CaptionIndent AS INTEGER, TempCaption$
    STATIC ControlImage AS LONG
    CONST ImageHeight = 13
    CONST ImageWidth = 13
    IF ControlImage = 0 THEN ControlImage = __UI_LoadThemeImage("checkbox.png")
    IF This.Redraw OR This.ControlState <> ControlState OR This.FocusState <> (__UI_Focus = This.ID) OR Caption(This.ID) <> __UI_TempCaptions(This.ID) OR This.Value <> This.PreviousValue OR This.PreviousParentID <> This.ParentID _
       OR __UI_ForceRedraw OR This.PreviousFont <> This.Font THEN
        This.Redraw = False
        This.ControlState = ControlState
        This.PreviousFont = This.Font
        This.FocusState = __UI_Focus = This.ID
        IF This.PreviousValue <> This.Value THEN
            __UI_StateHasChanged = True
            This.PreviousValue = This.Value
        END IF
        __UI_TempCaptions(This.ID) = Caption(This.ID)
        IF This.ParentID THEN Control(This.ParentID).ChildrenRedrawn = True
        This.PreviousParentID = This.ParentID
        IF This.Canvas <> 0 THEN
            _FREEIMAGE This.Canvas
        END IF
        IF This.Height < ImageHeight THEN This.Height = ImageHeight
        This.Canvas = _NEWIMAGE(This.Width + 2, This.Height + 2, 32)
        PrevDest = _DEST
        _DEST This.Canvas
        _FONT This.Font
        IF This.BackStyle = __UI_Opaque THEN
            CLS , This.BackColor
        ELSE
            CLS , _RGBA32(0, 0, 0, 0)
        END IF
        CaptionIndent = 0
        IF This.Value THEN ControlState = ControlState + 4
        _PUTIMAGE (0, This.Height \ 2 - (ImageHeight \ 2))-STEP(ImageWidth - 1, ImageHeight - 1), ControlImage, , (0, ControlState * ImageHeight - ImageHeight)-STEP(ImageWidth - 1, ImageHeight - 1)
        CaptionIndent = CaptionIndent + ImageWidth * 1.5
        TempCaption$ = __UI_TrimAt0$(Caption(This.ID))
        IF NOT This.Disabled THEN
            COLOR This.ForeColor
        ELSE
            COLOR Darken(Control(__UI_FormID).BackColor, 80)
        END IF
        __UI_PrintString CaptionIndent, ((This.Height \ 2) - uspacing& \ 2) + 1, TempCaption$
        IF (This.HotKey > 0 AND (__UI_ShowHotKeys AND NOT This.Disabled)) OR (This.HotKey > 0 AND __UI_DesignMode) THEN
            LINE (CaptionIndent + This.HotKeyOffset, ((This.Height \ 2) + uspacing& \ 2))-STEP(__UI_PrintWidth(CHR$(This.HotKey)) - 1, 0), This.ForeColor
        END IF
        IF __UI_Focus = This.ID AND __UI_KeyboardFocus THEN
            LINE (CaptionIndent - 1, 0)-STEP(This.Width - CaptionIndent - 1, This.Height - 1), _RGB32(0, 0, 0), B , 21845
        END IF
        __UI_MakeHardwareImageFromCanvas This
        _DEST PrevDest
    END IF
    IF This.Canvas THEN _PUTIMAGE (This.Left, This.Top), This.Canvas
END SUB
SUB __UI_DrawProgressBar (This AS __UI_ControlTYPE, ControlState)
    DIM PrevDest AS LONG, Temp&
    DIM TempCaption$, TempLine$
    STATIC ControlImage_Track AS LONG, ControlImage_Chunk AS LONG
    IF ControlImage_Chunk = 0 THEN ControlImage_Chunk = __UI_LoadThemeImage("progresschunk.png")
    IF ControlImage_Track = 0 THEN ControlImage_Track = __UI_LoadThemeImage("progresstrack.png")
    IF This.Redraw OR This.ControlState <> ControlState OR This.FocusState <> (__UI_Focus = This.ID) OR Caption(This.ID) <> __UI_TempCaptions(This.ID) OR This.Value <> This.PreviousValue OR This.PreviousParentID <> This.ParentID _
       OR __UI_ForceRedraw OR This.PreviousFont <> This.Font THEN
        This.Redraw = False
        This.PreviousFont = This.Font
        This.ControlState = ControlState
        This.FocusState = __UI_Focus = This.ID
        This.PreviousValue = This.Value
        __UI_TempCaptions(This.ID) = Caption(This.ID)
        IF This.ParentID THEN Control(This.ParentID).ChildrenRedrawn = True
        This.PreviousParentID = This.ParentID
        IF This.Canvas <> 0 THEN
            _FREEIMAGE This.Canvas
        END IF
        This.Canvas = _NEWIMAGE(This.Width, This.Height, 32)
        PrevDest = _DEST
        _DEST This.Canvas
        _FONT (This.Font)
        CLS , _RGBA32(0, 0, 0, 0)
        _PUTIMAGE (5, 4)-STEP(This.Width - 9, This.Height - 8), ControlImage_Track, , (5, 4)-STEP(0, 11)
        _PUTIMAGE (0, 0), ControlImage_Track, , (0, 0)-(4, 4) 'top corner
        _PUTIMAGE (0, This.Height - 3), ControlImage_Track, , (0, 16)-STEP(3, 2) 'bottom corner
        _PUTIMAGE (0, 4)-(4, This.Height - 4), ControlImage_Track, , (0, 4)-STEP(4, 11) 'vertical stretch
        _PUTIMAGE (This.Width - 4, 0), ControlImage_Track, , (6, 0)-STEP(2, 3) 'top corner
        _PUTIMAGE (This.Width - 4, This.Height - 3), ControlImage_Track, , (6, 16)-STEP(2, 3) 'bottom corner
        _PUTIMAGE (This.Width - 4, 4)-STEP(2, This.Height - 8), ControlImage_Track, , (6, 4)-STEP(2, 11) 'vertical stretch
        _PUTIMAGE (4, 0)-STEP(This.Width - 9, 3), ControlImage_Track, , (4, 0)-STEP(1, 3)
        _PUTIMAGE (4, This.Height - 3)-STEP(This.Width - 9, 2), ControlImage_Track, , (4, 16)-STEP(1, 2)
        IF This.Value THEN
            _PUTIMAGE (4, 3)-STEP(((This.Width - 9) / This.Max) * This.Value, This.Height - 7), ControlImage_Chunk
        END IF
        IF This.ShowPercentage THEN
            DIM ProgressString$
            ProgressString$ = LTRIM$(STR$(FIX((This.Value / This.Max) * 100))) + "%"
            IF LEN(Caption(This.ID)) THEN
                TempCaption$ = Replace$(Caption(This.ID), "\#", ProgressString$, 0, 0)
            ELSE
                TempCaption$ = ProgressString$
            END IF
            IF NOT This.Disabled THEN
                COLOR This.ForeColor
            ELSE
                COLOR Darken(Control(__UI_FormID).BackColor, 70)
            END IF
            DIM CaptionLeft AS INTEGER, FindLF&, FindSep&, ThisLine%
            DIM CaptionLeftFirstLine AS INTEGER, CaptionTopFirstLine AS INTEGER, TextTop%
            DIM TotalLines AS INTEGER
            IF INSTR(TempCaption$, CHR$(10)) > 0 THEN
                TempCaption$ = __UI_TrimAt0$(__UI_WordWrap(TempCaption$, This.Width - ((__UI_DefaultCaptionIndent) * 2), 0, TotalLines))
                DO WHILE LEN(TempCaption$)
                    ThisLine% = ThisLine% + 1
                    IF TotalLines < This.Height \ uspacing& THEN
                        TextTop% = (This.Height \ 2) - ((TotalLines * uspacing& - uspacing&) \ 2) - uspacing& \ 2 + (((ThisLine%) * uspacing& - uspacing&))
                    ELSE
                        TextTop% = __UI_DefaultCaptionIndent + ThisLine% * uspacing& - uspacing&
                    END IF
                    FindSep& = INSTR(TempCaption$, CHR$(1)) 'Search for soft breaks
                    FindLF& = INSTR(TempCaption$, CHR$(10)) 'Search for hard breaks
                    IF (FindSep& > 0 AND FindLF& > 0 AND FindSep& < FindLF&) OR (FindSep& > 0 AND FindLF& = 0) THEN
                        TempLine$ = LEFT$(TempCaption$, FindSep& - 1)
                        TempCaption$ = MID$(TempCaption$, FindSep& + 1)
                    ELSEIF FindSep& = 0 THEN
                        IF FindLF& > 0 THEN
                            TempLine$ = LEFT$(TempCaption$, FindLF& - 1)
                            TempCaption$ = MID$(TempCaption$, FindLF& + 1)
                        ELSE
                            TempLine$ = TempCaption$
                            TempCaption$ = ""
                        END IF
                    END IF
                    CaptionLeft = (This.Width \ 2 - __UI_PrintWidth&(TempLine$) \ 2)
                    __UI_PrintString CaptionLeft, TextTop%, TempLine$
                    IF ThisLine% = 1 THEN CaptionLeftFirstLine = CaptionLeft: CaptionTopFirstLine = TextTop%
                LOOP
            ELSE
                Temp& = __UI_PrintWidth(TempCaption$)
                __UI_PrintString This.Width \ 2 - Temp& \ 2, This.Height \ 2 - uspacing& \ 2 + 1, TempCaption$
            END IF
        END IF
        __UI_MakeHardwareImageFromCanvas This
        _DEST PrevDest
    END IF
    IF This.Canvas THEN _PUTIMAGE (This.Left, This.Top), This.Canvas
END SUB
SUB __UI_DrawTrackBar (This AS __UI_ControlTYPE, ControlState)
    DIM PrevDest AS LONG, i AS LONG, TempControlState AS _BYTE
    STATIC ControlImage_Track AS LONG, ControlImage_Slider AS LONG
    CONST SliderHeight = 21
    CONST SliderWidth = 11
    IF ControlImage_Track = 0 THEN ControlImage_Track = __UI_LoadThemeImage("slidertrack.png")
    IF ControlImage_Slider = 0 THEN
        ControlImage_Slider = __UI_LoadThemeImage("sliderdown.png")
        __UI_ClearColor ControlImage_Slider, 0, 0
    END IF
    TempControlState = ControlState
    IF This.Disabled THEN TempControlState = 5
    IF This.Redraw OR This.ControlState <> TempControlState OR This.FocusState <> (__UI_Focus = This.ID) OR This.Value <> This.PreviousValue OR This.PreviousParentID <> This.ParentID _
       OR __UI_ForceRedraw OR This.PreviousFont <> This.Font OR _
       This.PrevMin <> This.Min OR This.PrevMax <> This.Max OR _
       This.PrevInterval <> This.Interval OR This.PrevMinInterval <> This.MinInterval THEN
        This.Redraw = False
        This.ControlState = TempControlState
        This.PreviousFont = This.Font
        This.FocusState = __UI_Focus = This.ID
        IF This.PreviousValue <> This.Value THEN
            __UI_StateHasChanged = True
            This.PreviousValue = This.Value
        END IF
        This.PrevMin = This.Min
        This.PrevMax = This.Max
        This.PrevInterval = This.Interval
        This.PrevMinInterval = This.MinInterval
        IF This.ParentID THEN Control(This.ParentID).ChildrenRedrawn = True
        This.PreviousParentID = This.ParentID
        IF This.Canvas <> 0 THEN
            _FREEIMAGE This.Canvas
        END IF
        This.Canvas = _NEWIMAGE(This.Width, This.Height, 32)
        PrevDest = _DEST
        _DEST This.Canvas
        _FONT (This.Font)
        CLS , _RGBA32(0, 0, 0, 0)
        _PUTIMAGE (3, 10), ControlImage_Track, , (0, 0)-STEP(1, 4)
        _PUTIMAGE (5, 10)-STEP(This.Width - 10, 5), ControlImage_Track, , (2, 0)-STEP(0, 4)
        _PUTIMAGE (This.Width - 4, 10), ControlImage_Track, , (3, 0)-STEP(1, 4)
        DIM IntervalSize AS INTEGER, MinIntervalSize AS INTEGER
        MinIntervalSize = 2
        LINE (5, 30)-STEP(0, 3), This.BorderColor
        IF This.Interval = 0 THEN This.Interval = 1
        IF This.MinInterval > This.Interval THEN
            This.MinInterval = 0
        ELSEIF This.MinInterval < This.Interval AND This.MinInterval > 0 THEN
            FOR i = This.Min TO This.Max STEP This.MinInterval
                LINE (__UI_MAP(i, This.Min, This.Max, 5, This.Width - 6), 30)-STEP(0, MinIntervalSize), This.BorderColor
            NEXT i
        ENDIF
        IF This.MinInterval > 0 THEN IntervalSize = 5 ELSE IntervalSize = 2
        FOR i = This.Min TO This.Max STEP This.Interval
            LINE (__UI_MAP(i, This.Min, This.Max, 5, This.Width - 6), 30)-STEP(0, IntervalSize), This.BorderColor
        NEXT i
        LINE (5 + (This.Width - SliderWidth), 30)-STEP(0, 3), This.BorderColor
        _PUTIMAGE (__UI_MAP(This.Value, This.Min, This.Max, 0, This.Width - SliderWidth), 2), ControlImage_Slider, , (0, TempControlState * SliderHeight - SliderHeight)-STEP(SliderWidth - 1, SliderHeight - 1)
        IF __UI_Focus = This.ID AND __UI_KeyboardFocus THEN
            LINE (0, 0)-STEP(This.Width - 1, This.Height - 1), _RGB32(0, 0, 0), B , 21845
        END IF
        __UI_MakeHardwareImageFromCanvas This
        _DEST PrevDest
    END IF
    IF This.Canvas THEN _PUTIMAGE (This.Left, This.Top), This.Canvas
END SUB
SUB __UI_DrawTextBox (This AS __UI_ControlTYPE, ControlState)
    DIM PrevDest AS LONG
    DIM CaptionIndent AS INTEGER, i AS LONG, TempCaption$
    STATIC SetCursor#, cursorBlink%%
    IF This.FirstVisibleLine = 0 THEN This.FirstVisibleLine = 1
    IF This.CurrentLine = 0 THEN This.CurrentLine = 1
    __UI_CursorAdjustments This.ID
    IF This.Redraw OR This.ControlState <> ControlState OR _
        This.FocusState <> (__UI_Focus = This.ID) OR _
        Caption(This.ID) <> __UI_TempCaptions(This.ID) OR _
        Text(This.ID) <> __UI_TempTexts(This.ID) OR _
        (TIMER - SetCursor# > .3 AND __UI_Focus = This.ID) OR _
        (__UI_SelectionLength <> This.SelectionLength AND __UI_Focus = This.ID) OR _
        This.Cursor <> This.PrevCursor OR This.PreviousParentID <> This.ParentID OR _
        This.VisibleCursor <> This.PrevVisibleCursor OR _
        This.FirstVisibleLine <> This.PrevFirstVisibleLine OR _
        This.CurrentLine <> This.PrevCurrentLine OR _
        Mask(This.ID) <> __UI_TempMask(This.ID) OR _
        This.PreviousFont <> This.Font OR _
        __UI_ForceRedraw THEN
        This.Redraw = False
        This.ControlState = ControlState
        This.PreviousFont = This.Font
        This.FocusState = __UI_Focus = This.ID
        __UI_TempCaptions(This.ID) = Caption(This.ID)
        IF Mask(This.ID) <> __UI_TempMask(This.ID) THEN
            IF NOT __UI_EditorMode THEN Mask(This.ID) = RestoreCHR$(Mask(This.ID))
            __UI_TempMask(This.ID) = Mask(This.ID)
            Text(This.ID) = __UI_EmptyMask(This.ID)
        END IF
        IF __UI_TempTexts(This.ID) <> Text(This.ID) THEN
            __UI_StateHasChanged = True
            IF NOT __UI_EditorMode THEN Text(This.ID) = RestoreCHR$(Text(This.ID))
            __UI_TempTexts(This.ID) = Text(This.ID)
        END IF
        This.SelectionLength = __UI_SelectionLength
        This.PrevCursor = This.Cursor
        This.PrevVisibleCursor = This.VisibleCursor
        IF This.ParentID THEN Control(This.ParentID).ChildrenRedrawn = True
        This.PreviousParentID = This.ParentID
        This.PrevFirstVisibleLine = This.FirstVisibleLine
        This.PrevCurrentLine = This.CurrentLine
        IF This.Canvas <> 0 THEN
            _FREEIMAGE This.Canvas
        END IF
        This.Canvas = _NEWIMAGE(This.Width, This.Height, 32)
        PrevDest = _DEST
        _DEST This.Canvas
        _FONT (This.Font)
        _PRINTMODE _KEEPBACKGROUND
        CLS , This.BackColor
        TempCaption$ = __UI_TrimAt0$(Caption(This.ID))
        CaptionIndent = 0
        IF This.HasBorder THEN
            IF This.BorderSize > __UI_MaxBorderSize THEN
                This.BorderSize = __UI_MaxBorderSize
            ELSEIF This.BorderSize < 1 THEN
                This.BorderSize = 1
            END IF
            CaptionIndent = __UI_DefaultCaptionIndent + This.BorderSize
        END IF
        IF NOT This.Disabled AND (LEN(Text(This.ID)) OR This.Multiline) THEN
            COLOR This.ForeColor, This.BackColor
        ELSE
            COLOR Darken(Control(__UI_FormID).BackColor, 80), This.BackColor
        END IF
        STATIC c AS _UNSIGNED LONG
        IF c = 0 THEN
            c = _RGBA32(_RED32(This.SelectedBackColor), _GREEN32(This.SelectedBackColor), _BLUE32(This.SelectedBackColor), 70)
        END IF
        IF NOT This.Multiline THEN
            DIM ThisTempText$
            ThisTempText$ = __UI_TrimAt0$(Text(This.ID))
            IF LEN(ThisTempText$) > 0 AND This.PasswordField = True THEN
                ThisTempText$ = STRING$(LEN(ThisTempText$), 7)
            END IF
            IF ((__UI_Focus = This.ID) OR (This.ID = __UI_PreviousFocus AND __UI_ParentMenu(__UI_TotalActiveMenus) = This.ContextMenuID)) AND NOT This.Disabled THEN
                IF LEN(Text(This.ID)) THEN
                    __UI_PrintString CaptionIndent - This.InputViewStart, ((This.Height \ 2) - uspacing& \ 2), ThisTempText$
                ELSE
                    __UI_PrintString CaptionIndent, ((This.Height \ 2) - uspacing& \ 2), TempCaption$
                END IF
                IF This.TextIsSelected THEN
                    LINE (Captionindent - This.InputViewStart + __UI_ThisLineChars(This.SelectionStart), ((This.Height \ 2) - uspacing& \ 2))-(Captionindent - This.InputViewStart + __UI_ThisLineChars(This.Cursor), ((This.Height \ 2) - uspacing& \ 2) + uspacing&), c, BF
                END IF
                IF TIMER - SetCursor# > .3 THEN
                    SetCursor# = TIMER
                    cursorBlink%% = NOT cursorBlink%%
                END IF
                IF _WINDOWHASFOCUS = False THEN cursorBlink%% = False
                IF This.Cursor > UBOUND(__UI_ThisLineChars) THEN This.Cursor = UBOUND(__UI_ThisLineChars)
                This.VisibleCursor = CaptionIndent + __UI_ThisLineChars(This.Cursor) - This.InputViewStart
                STATIC PrevFocusedText$
                IF PrevFocusedText$ <> ThisTempText$ THEN
                    PrevFocusedText$ = ThisTempText$
                    REDIM __UI_FocusedTextBoxChars(0 TO UBOUND(__UI_ThisLineChars)) AS LONG
                    DIM M1 AS _MEM, M2 AS _MEM
                    M1 = _MEM(__UI_ThisLineChars())
                    M2 = _MEM(__UI_FocusedTextBoxChars())
                    _MEMCOPY M1, M1.OFFSET, M1.SIZE TO M2, M2.OFFSET
                    _MEMFREE M1
                    _MEMFREE M2
                END IF
                SELECT CASE MID$(Mask(This.ID), This.Cursor + 1, 1)
                    CASE "0", "9", "#" 'Digit placeholders
                        LINE (This.VisibleCursor, ((This.Height \ 2) - uspacing& \ 2))-STEP(__UI_ThisLineChars(This.Cursor + 1) - __UI_ThisLineChars(This.Cursor), uspacing&), c, BF
                    CASE ELSE
                        IF cursorBlink%% THEN
                            LINE (This.VisibleCursor, ((This.Height \ 2) - uspacing& \ 2))-STEP(0, uspacing&), _RGB32(0, 0, 0)
                        END IF
                END SELECT
            ELSE
                IF LEN(Text(This.ID)) THEN
                    __UI_PrintString CaptionIndent, ((This.Height \ 2) - uspacing& \ 2), ThisTempText$
                ELSE
                    IF LEN(Mask(This.ID)) = 0 THEN
                        __UI_PrintString CaptionIndent, ((This.Height \ 2) - uspacing& \ 2), TempCaption$
                    ELSE
                        Text(This.ID) = __UI_EmptyMask$(This.ID)
                    END IF
                END IF
            END IF
        ELSE
            DIM ThisTop AS INTEGER, TempLine AS STRING
            DIM TotalLines AS INTEGER
            DIM s1 AS LONG, s2 AS LONG
            STATIC PrevTotalLines AS LONG
            IF This.TextIsSelected THEN
                s1 = This.SelectionStart + 1
                s2 = This.Cursor + 1
                IF s1 > s2 THEN SWAP s1, s2
            END IF
            ThisTop = CaptionIndent - uspacing&
            TempCaption$ = __UI_TrimAt0$(__UI_WordWrap(Text(This.ID), This.Width - __UI_ScrollbarWidth - 5, 0, TotalLines))
            IF This.HelperCanvas = 0 OR PrevTotalLines <> TotalLines THEN
                PrevTotalLines = TotalLines
                IF This.HelperCanvas < -1 THEN _FREEIMAGE This.HelperCanvas
                This.HelperCanvas = _NEWIMAGE(This.Width - __UI_ScrollbarWidth, TotalLines * uspacing& + uspacing& / 2)
            END IF
            _DEST This.HelperCanvas
            _FONT This.Font
            CLS , This.BackColor
            IF TIMER - SetCursor# > .3 THEN
                SetCursor# = TIMER
                cursorBlink%% = NOT cursorBlink%%
            END IF
            DO WHILE LEN(TempCaption$)
                DIM ThisLine%, TextTop%, FindSep&, FindLF&, CaptionLeft AS INTEGER
                ThisLine% = ThisLine% + 1
                TextTop% = CaptionIndent + ThisLine% * uspacing& - uspacing&
                FindSep& = INSTR(TempCaption$, CHR$(1)) 'Search for soft breaks
                FindLF& = INSTR(TempCaption$, CHR$(10)) 'Search for hard breaks
                IF (FindSep& > 0 AND FindLF& > 0 AND FindSep& < FindLF&) OR (FindSep& > 0 AND FindLF& = 0) THEN
                    TempLine$ = LEFT$(TempCaption$, FindSep& - 1)
                    TempCaption$ = MID$(TempCaption$, FindSep& + 1)
                ELSEIF FindSep& = 0 THEN
                    IF FindLF& > 0 THEN
                        TempLine$ = LEFT$(TempCaption$, FindLF& - 1)
                        TempCaption$ = MID$(TempCaption$, FindLF& + 1)
                    ELSE
                        TempLine$ = TempCaption$
                        TempCaption$ = ""
                    END IF
                END IF
                CaptionLeft = CaptionIndent
                __UI_PrintString CaptionLeft, TextTop%, TempLine$
            LOOP
            IF This.ID = __UI_Focus THEN
                FOR i = Control(__UI_Focus).Cursor TO 0 STEP -1
                    IF MID$(Text(__UI_Focus), i, 1) = CHR$(10) OR i = 0 THEN
                        Control(__UI_Focus).VisibleCursor = Control(__UI_Focus).Cursor - i
                        EXIT FOR
                    END IF
                NEXT
            END IF
            _DEST This.Canvas
            _PUTIMAGE (0,0),This.HelperCanvas
            IF TotalLines > This.Height \ uspacing& THEN
                This.HasVScrollbar = True
                __UI_DrawVScrollBar This, ControlState
            ELSE
                This.HasVScrollbar = False
                __UI_DrawVScrollBar This, 4 'ControlState = 4 (Disabled)
            END IF
        END IF
        IF This.HasBorder THEN
            FOR i = 0 TO This.BorderSize - 1
                LINE (i, i)-STEP(This.Width - 1 - i * 2, This.Height - 1 - i * 2), This.BorderColor, B
            NEXT
        END IF
        __UI_MakeHardwareImageFromCanvas This
        _DEST PrevDest
    END IF
    IF This.Canvas THEN _PUTIMAGE (This.Left, This.Top), This.Canvas
END SUB
SUB __UI_DrawListBox (This AS __UI_ControlTYPE, ControlState)
    DIM PrevDest AS LONG, i AS LONG
    DIM CaptionIndent AS INTEGER, TempCaption$
    IF This.Redraw OR This.ControlState <> ControlState OR This.FocusState <> (__UI_Focus = This.ID) OR This.PreviousValue <> This.Value OR Text(This.ID) <> __UI_TempTexts(This.ID) OR This.PreviousInputViewStart <> This.InputViewStart OR This.PreviousParentID <> This.ParentID _
       OR __UI_ForceRedraw OR This.PreviousFont <> This.Font THEN
        This.Redraw = False
        This.PreviousFont = This.Font
        This.ControlState = ControlState
        This.FocusState = __UI_Focus = This.ID
        IF This.PreviousValue <> This.Value THEN
            __UI_StateHasChanged = True
            This.PreviousValue = This.Value
        END IF
        This.PreviousInputViewStart = This.InputViewStart
        IF INSTR(Text(This.ID), CHR$(13) + CHR$(10)) > 0 THEN
            Text(This.ID) = Replace(Text(This.ID), CHR$(13) + CHR$(10), CHR$(10), 0, 0)
        END IF
        __UI_TempTexts(This.ID) = Text(This.ID)
        IF This.ParentID THEN Control(This.ParentID).ChildrenRedrawn = True
        This.PreviousParentID = This.ParentID
        IF This.Canvas <> 0 THEN
            _FREEIMAGE This.Canvas
        END IF
        IF This.Width + This.Height > 0 THEN
            This.Canvas = _NEWIMAGE(This.Width, This.Height, 32)
        ELSE
            EXIT SUB
        END IF
        PrevDest = _DEST
        _DEST This.Canvas
        _FONT (This.Font)
        IF This.BackStyle = __UI_Opaque THEN
            CLS , This.BackColor
        ELSE
            CLS , _RGBA32(0, 0, 0, 0)
        END IF
        IF This.HasBorder THEN
            IF This.BorderSize > __UI_MaxBorderSize THEN
                This.BorderSize = __UI_MaxBorderSize
            ELSEIF This.BorderSize < 1 THEN
                This.BorderSize = 1
            END IF
            CaptionIndent = __UI_DefaultCaptionIndent + This.BorderSize
        END IF
        IF LEN(Text(This.ID)) THEN
            DIM TempText$, FindLF&, ThisItem%, ThisItemTop%
            DIM ItemHeight AS INTEGER, LastVisibleItem AS INTEGER
            ItemHeight = uspacing + (((_FONT = 8) * -1) * __UI_Font8Offset + ((_FONT = 16) * -1) * __UI_Font16Offset) + 3
            This.ItemHeight = ItemHeight
            TempText$ = __UI_TrimAt0$(Text(This.ID))
            ThisItem% = 0
            DO WHILE LEN(TempText$)
                ThisItem% = ThisItem% + 1
                FindLF& = INSTR(TempText$, CHR$(10))
                IF FindLF& THEN
                    TempCaption$ = LEFT$(TempText$, FindLF& - 1)
                    TempText$ = MID$(TempText$, FindLF& + 1)
                ELSE
                    TempCaption$ = TempText$
                    TempText$ = ""
                END IF
                IF ThisItem% >= This.InputViewStart THEN
                    ThisItemTop% = ((ThisItem% - This.InputViewStart + 1) * ItemHeight - ItemHeight) + CaptionIndent
                    IF ThisItemTop% + ItemHeight > This.Height THEN _CONTINUE
                    LastVisibleItem = LastVisibleItem + 1
                    IF ThisItem% = This.Value AND __UI_Focus = This.ID THEN Caption(This.ID) = TempCaption$
                    IF NOT This.Disabled THEN
                        COLOR This.ForeColor
                    ELSE
                        COLOR Darken(Control(__UI_FormID).BackColor, 80)
                    END IF
                    IF ThisItem% = This.Value THEN
                        IF __UI_Focus = This.ID THEN
                            COLOR This.SelectedForeColor, This.SelectedBackColor
                            LINE (CaptionIndent, ThisItemTop% - 1)-STEP(This.Width - CaptionIndent * 2, ItemHeight), This.SelectedBackColor, BF
                        ELSE
                            LINE (CaptionIndent, ThisItemTop% - 1)-STEP(This.Width - CaptionIndent * 2, ItemHeight), _RGBA32(0, 0, 0, 50), BF
                        END IF
                    END IF
                    SELECT CASE This.Align
                        CASE __UI_Left
                            __UI_PrintString CaptionIndent * 2, ThisItemTop% + ((ItemHeight - uspacing&) / 2), TempCaption$
                        CASE __UI_Center
                            __UI_PrintString (This.Width \ 2 - __UI_PrintWidth(TempCaption$) \ 2), ThisItemTop% + ((ItemHeight - uspacing&) / 2), TempCaption$
                        CASE __UI_Right
                            __UI_PrintString (This.Width - __UI_PrintWidth(TempCaption$)) - CaptionIndent, ThisItemTop% + ((ItemHeight - uspacing&) / 2), TempCaption$
                    END SELECT
                END IF
            LOOP
            This.Max = ThisItem%
            IF This.LastVisibleItem < LastVisibleItem THEN This.LastVisibleItem = LastVisibleItem
            IF This.InputViewStart > This.Max THEN This.InputViewStart = 0
            IF This.Value > This.Max THEN This.Value = 0
            IF This.Max > This.LastVisibleItem THEN
                This.HasVScrollbar = True
                __UI_DrawVScrollBar This, ControlState
            ELSE
                This.HasVScrollbar = False
            END IF
        END IF
        IF This.HasBorder THEN
            FOR i = 0 TO This.BorderSize - 1
                LINE (i, i)-STEP(This.Width - 1 - i * 2, This.Height - 1 - i * 2), This.BorderColor, B
            NEXT
        END IF
        __UI_MakeHardwareImageFromCanvas This
        _DEST PrevDest
    END IF
    IF This.Canvas THEN _PUTIMAGE (This.Left, This.Top), This.Canvas
END SUB
SUB __UI_DrawVScrollBar (TempThis AS __UI_ControlTYPE, ControlState AS _BYTE)
    DIM TrackHeight AS INTEGER, ThumbHeight AS INTEGER, ThumbTop AS INTEGER
    DIM Ratio AS SINGLE
    DIM This AS __UI_ControlTYPE
    STATIC ControlImage_Button AS LONG, ControlImage_Track AS LONG
    STATIC ControlImage_Thumb AS LONG
    CONST ImageHeight_Button = 17
    CONST ImageWidth_Button = 17
    CONST ImageHeight_Thumb = 22
    CONST ImageWidth_Thumb = 15
    IF ControlImage_Button = 0 THEN ControlImage_Button = __UI_LoadThemeImage("scrollbuttons.png")
    IF ControlImage_Track = 0 THEN ControlImage_Track = __UI_LoadThemeImage("scrolltrack.png")
    IF ControlImage_Thumb = 0 THEN ControlImage_Thumb = __UI_LoadThemeImage("scrollthumb.png")
    This = TempThis
    _FONT This.Font
    IF This.Type = __UI_Type_ListBox THEN
        This.Min = 0
        This.Max = This.Max - This.LastVisibleItem
        This.Value = This.InputViewStart - 1
        This.Left = This.Width - __UI_ScrollbarWidth - 1
        This.Top = 1
        This.Height = This.Height - 1
        This.Width = __UI_ScrollbarWidth
    ELSEIF This.Type = __UI_Type_TextBox THEN
        This.Min = 0
        This.Max = __UI_CountLines(This.ID) - This.Height \ uspacing&
        This.Value = This.FirstVisibleLine - 1
        This.Left = This.Width - __UI_ScrollbarWidth - 1
        This.Top = 1
        This.Height = This.Height - 1
        This.Width = __UI_ScrollbarWidth
    END IF
    TrackHeight = This.Height - __UI_ScrollbarButtonHeight * 2 - 1
    Ratio = (This.Max) / TrackHeight
    ThumbHeight = TrackHeight - This.Height * Ratio
    IF ThumbHeight < 22 THEN ThumbHeight = 22
    IF ThumbHeight > TrackHeight THEN ThumbHeight = TrackHeight
    ThumbTop = This.Top + (TrackHeight - ThumbHeight) * (This.Value / This.Max)
    TempThis.ThumbTop = TempThis.Top + ThumbTop + __UI_ScrollbarButtonHeight
    IF ControlState <> 4 THEN
        _PUTIMAGE (This.Left, This.Top)-STEP(ImageWidth_Button - 1, This.Height - 1), ControlImage_Track, , (0, 1 * ImageHeight_Button - ImageHeight_Button)-STEP(ImageWidth_Button - 1, ImageHeight_Button - 1)
    ELSE
        _PUTIMAGE (This.Left, This.Top)-STEP(ImageWidth_Button - 1, This.Height - 1), ControlImage_Track, , (0, 4 * ImageHeight_Button - ImageHeight_Button)-STEP(ImageWidth_Button - 1, ImageHeight_Button - 1)
    END IF
    IF __UI_MouseDownOnID = This.ID AND This.HoveringVScrollbarButton = 4 AND __UI_DraggingThumb = False THEN
        _PUTIMAGE (This.Left, This.Top)-STEP(ImageWidth_Button - 1, ThumbTop + ThumbHeight + __UI_ScrollbarButtonHeight - 1), ControlImage_Track, , (0, 3 * ImageHeight_Button - ImageHeight_Button)-STEP(ImageWidth_Button - 1, ImageHeight_Button - 1)
    ELSEIF __UI_MouseDownOnID = This.ID AND This.HoveringVScrollbarButton = 5 AND __UI_DraggingThumb = False THEN
        _PUTIMAGE (This.Left, This.Top + ThumbTop + __UI_ScrollbarButtonHeight)-STEP(ImageWidth_Button - 1, This.Height - (This.Top + ThumbTop + __UI_ScrollbarButtonHeight) - 1), ControlImage_Track, , (0, 3 * ImageHeight_Button - ImageHeight_Button)-STEP(ImageWidth_Button - 1, ImageHeight_Button - 1)
    END IF
    IF ControlState = 4 THEN
        _PUTIMAGE (This.Left, This.Top)-STEP(ImageWidth_Button - 1, ImageHeight_Button - 1), ControlImage_Button, , (0, 4 * ImageHeight_Button - ImageHeight_Button)-STEP(ImageWidth_Button - 1, ImageHeight_Button - 1)
    ELSEIF This.HoveringVScrollbarButton = 1 AND __UI_MouseDownOnID = This.ID THEN
        _PUTIMAGE (This.Left, This.Top)-STEP(ImageWidth_Button - 1, ImageHeight_Button - 1), ControlImage_Button, , (0, 3 * ImageHeight_Button - ImageHeight_Button)-STEP(ImageWidth_Button - 1, ImageHeight_Button - 1)
    ELSEIF This.HoveringVScrollbarButton = 1 THEN
        _PUTIMAGE (This.Left, This.Top)-STEP(ImageWidth_Button - 1, ImageHeight_Button - 1), ControlImage_Button, , (0, 2 * ImageHeight_Button - ImageHeight_Button)-STEP(ImageWidth_Button - 1, ImageHeight_Button - 1)
    ELSE
        _PUTIMAGE (This.Left, This.Top)-STEP(ImageWidth_Button - 1, ImageHeight_Button - 1), ControlImage_Button, , (0, 1 * ImageHeight_Button - ImageHeight_Button)-STEP(ImageWidth_Button - 1, ImageHeight_Button - 1)
    END IF
    IF ControlState = 4 THEN
        _PUTIMAGE (This.Left, This.Top + This.Height - ImageHeight_Button - 1)-STEP(ImageWidth_Button - 1, ImageHeight_Button - 1), ControlImage_Button, , (0, 8 * ImageHeight_Button - ImageHeight_Button)-STEP(ImageWidth_Button - 1, ImageHeight_Button - 1)
    ELSEIF This.HoveringVScrollbarButton = 2 AND __UI_MouseDownOnID = This.ID THEN
        _PUTIMAGE (This.Left, This.Top + This.Height - ImageHeight_Button - 1)-STEP(ImageWidth_Button - 1, ImageHeight_Button - 1), ControlImage_Button, , (0, 7 * ImageHeight_Button - ImageHeight_Button)-STEP(ImageWidth_Button - 1, ImageHeight_Button - 1)
    ELSEIF This.HoveringVScrollbarButton = 2 THEN
        _PUTIMAGE (This.Left, This.Top + This.Height - ImageHeight_Button - 1)-STEP(ImageWidth_Button - 1, ImageHeight_Button - 1), ControlImage_Button, , (0, 6 * ImageHeight_Button - ImageHeight_Button)-STEP(ImageWidth_Button - 1, ImageHeight_Button - 1)
    ELSE
        _PUTIMAGE (This.Left, This.Top + This.Height - ImageHeight_Button - 1)-STEP(ImageWidth_Button - 1, ImageHeight_Button - 1), ControlImage_Button, , (0, 5 * ImageHeight_Button - ImageHeight_Button)-STEP(ImageWidth_Button - 1, ImageHeight_Button - 1)
    END IF
    IF ControlState = 4 THEN
    ELSEIF __UI_DraggingThumb = True THEN
        _PUTIMAGE (This.Left + 1, ThumbTop + __UI_ScrollbarButtonHeight)-STEP(ImageWidth_Thumb - 2, ThumbHeight - 1), ControlImage_Thumb, , (0, 3 * ImageHeight_Thumb - ImageHeight_Thumb + 2)-STEP(ImageWidth_Thumb - 1, ImageHeight_Thumb - 5)
        _PUTIMAGE (This.Left + 1, ThumbTop + __UI_ScrollbarButtonHeight)-STEP(ImageWidth_Thumb - 2, 1), ControlImage_Thumb, , (0, 3 * ImageHeight_Thumb - ImageHeight_Thumb)-STEP(ImageWidth_Thumb - 1, 1)
        _PUTIMAGE (This.Left + 1, ThumbTop + __UI_ScrollbarButtonHeight + ThumbHeight - 2)-STEP(ImageWidth_Thumb - 2, 1), ControlImage_Thumb, , (0, 3 * ImageHeight_Thumb - 4)-STEP(ImageWidth_Thumb - 1, 3)
    ELSEIF This.HoveringVScrollbarButton = 3 AND __UI_DraggingThumb = False THEN
        _PUTIMAGE (This.Left + 1, ThumbTop + __UI_ScrollbarButtonHeight)-STEP(ImageWidth_Thumb - 2, ThumbHeight - 1), ControlImage_Thumb, , (0, 2 * ImageHeight_Thumb - ImageHeight_Thumb + 2)-STEP(ImageWidth_Thumb - 1, ImageHeight_Thumb - 5)
        _PUTIMAGE (This.Left + 1, ThumbTop + __UI_ScrollbarButtonHeight)-STEP(ImageWidth_Thumb - 2, 1), ControlImage_Thumb, , (0, 2 * ImageHeight_Thumb - ImageHeight_Thumb)-STEP(ImageWidth_Thumb - 1, 1)
        _PUTIMAGE (This.Left + 1, ThumbTop + __UI_ScrollbarButtonHeight + ThumbHeight - 2)-STEP(ImageWidth_Thumb - 2, 1), ControlImage_Thumb, , (0, 2 * ImageHeight_Thumb - 4)-STEP(ImageWidth_Thumb - 1, 3)
    ELSE
        _PUTIMAGE (This.Left + 1, ThumbTop + __UI_ScrollbarButtonHeight)-STEP(ImageWidth_Thumb - 2, ThumbHeight - 1), ControlImage_Thumb, , (0, 1 * ImageHeight_Thumb - ImageHeight_Thumb + 2)-STEP(ImageWidth_Thumb - 1, ImageHeight_Thumb - 5)
        _PUTIMAGE (This.Left + 1, ThumbTop + __UI_ScrollbarButtonHeight)-STEP(ImageWidth_Thumb - 2, 1), ControlImage_Thumb, , (0, 1 * ImageHeight_Thumb - ImageHeight_Thumb)-STEP(ImageWidth_Thumb - 1, 1)
        _PUTIMAGE (This.Left + 1, ThumbTop + __UI_ScrollbarButtonHeight + ThumbHeight - 2)-STEP(ImageWidth_Thumb - 2, 1), ControlImage_Thumb, , (0, 1 * ImageHeight_Thumb - 4)-STEP(ImageWidth_Thumb - 1, 3)
    END IF
    TempThis.VScrollbarButton2Top = This.Top + This.Height - ImageHeight_Button - 1
    TempThis.ThumbHeight = ThumbHeight
    TempThis.VScrollbarRatio = Ratio
END SUB
SUB __UI_DrawDropdownList (This AS __UI_ControlTYPE, ControlState)
    DIM PrevDest AS LONG, i AS LONG
    DIM CaptionIndent AS INTEGER, TempCaption$
    STATIC ControlImage AS LONG
    STATIC ControlImage_Arrow AS LONG
    CONST ButtonHeight = 21
    CONST ButtonWidth = 18
    CONST ArrowWidth = 9
    CONST ArrowHeight = 9
    IF ControlImage = 0 THEN ControlImage = __UI_LoadThemeImage("button.png")
    IF ControlImage_Arrow = 0 THEN
        ControlImage_Arrow = __UI_LoadThemeImage("arrows.png")
        __UI_ClearColor ControlImage_Arrow, 0, 0
    END IF
    IF This.Redraw OR This.ControlState <> ControlState OR _
        This.FocusState <> (__UI_Focus = This.ID) OR _
        This.PreviousValue <> This.Value OR _
        Text(This.ID) <> __UI_TempTexts(This.ID) OR _
        This.PreviousInputViewStart <> This.InputViewStart OR _
        This.PreviousParentID <> This.ParentID OR _
        This.PreviousFont <> This.Font OR _
        __UI_ForceRedraw THEN
        This.Redraw = False
        This.ControlState = ControlState
        This.PreviousFont = This.Font
        This.FocusState = __UI_Focus = This.ID
        IF This.PreviousValue <> This.Value THEN
            __UI_StateHasChanged = True
            This.PreviousValue = This.Value
        END IF
        This.PreviousInputViewStart = This.InputViewStart
        __UI_TempTexts(This.ID) = Text(This.ID)
        IF This.ParentID THEN Control(This.ParentID).ChildrenRedrawn = True
        This.PreviousParentID = This.ParentID
        IF This.Canvas <> 0 THEN
            _FREEIMAGE This.Canvas
        END IF
        This.Canvas = _NEWIMAGE(This.Width, This.Height, 32)
        PrevDest = _DEST
        _DEST This.Canvas
        _FONT This.Font
        IF This.BackStyle = __UI_Opaque THEN
            CLS , This.BackColor
        ELSE
            CLS , _RGBA32(0, 0, 0, 0)
        END IF
        IF This.HasBorder THEN
            IF This.BorderSize > __UI_MaxBorderSize THEN
                This.BorderSize = __UI_MaxBorderSize
            ELSEIF This.BorderSize < 1 THEN
                This.BorderSize = 1
            END IF
            CaptionIndent = __UI_DefaultCaptionIndent + This.BorderSize
            FOR i = 0 TO This.BorderSize - 1
                LINE (i, i)-STEP(This.Width - 1 - i * 2, This.Height - 1 - i * 2), This.BorderColor, B
            NEXT
        END IF
        DIM TempText$, ThisItem%, FindLF&, ThisItemTop%
        IF This.Value > 0 THEN
            IF LEN(Text(This.ID)) THEN
                TempText$ = Text(This.ID)
                ThisItem% = 0
                DO WHILE LEN(TempText$)
                    ThisItem% = ThisItem% + 1
                    FindLF& = INSTR(TempText$, CHR$(10))
                    IF FindLF& THEN
                        TempCaption$ = LEFT$(TempText$, FindLF& - 1)
                        TempText$ = MID$(TempText$, FindLF& + 1)
                    ELSE
                        TempCaption$ = TempText$
                        TempText$ = ""
                    END IF
                    IF ThisItem% = This.Value THEN
                        ThisItemTop% = This.Height \ 2 - uspacing& \ 2 + 1
                        IF ThisItem% = This.Value AND __UI_Focus = This.ID THEN Caption(This.ID) = TempCaption$
                        IF NOT This.Disabled THEN
                            COLOR This.ForeColor
                        ELSE
                            COLOR Darken(Control(__UI_FormID).BackColor, 80)
                        END IF
                        IF __UI_Focus = This.ID THEN
                            COLOR This.SelectedForeColor
                            LINE (CaptionIndent, 3)-STEP(This.Width - CaptionIndent * 2, This.Height - 7), This.SelectedBackColor, BF
                        END IF
                        SELECT CASE This.Align
                            CASE __UI_Left
                                __UI_PrintString CaptionIndent * 2, ThisItemTop%, TempCaption$
                            CASE __UI_Center
                                __UI_PrintString (This.Width \ 2 - __UI_PrintWidth(TempCaption$) \ 2), ThisItemTop%, TempCaption$
                            CASE __UI_Right
                                __UI_PrintString (This.Width - __UI_PrintWidth(TempCaption$)) - CaptionIndent, ThisItemTop%, TempCaption$
                        END SELECT
                        EXIT DO
                    END IF
                LOOP
            END IF
        END IF
        DIM DropdownState AS _BYTE
        IF __UI_TotalActiveMenus > 0 AND __UI_ParentDropdownList = This.ID THEN
            DropdownState = 3
        ELSEIF (This.ID = __UI_HoveringID OR This.ID = __UI_ParentDropdownList) AND NOT This.Disabled THEN
            DropdownState = 2
        ELSEIF This.Disabled = True THEN
            DropdownState = 4
        ELSE
            DropdownState = 1
        END IF
        _PUTIMAGE (This.Width - (__UI_ScrollbarWidth + 2), 3)-(This.Width - 1, This.Height - 4), ControlImage, , (3, DropdownState * ButtonHeight - ButtonHeight + 3)-STEP(11, ButtonHeight - 7)
        _PUTIMAGE (This.Width - (__UI_ScrollbarWidth + 1), 0)-STEP(__UI_ScrollbarWidth - 2, 3), ControlImage, , (3, DropdownState * ButtonHeight - ButtonHeight)-STEP(11, 3)
        _PUTIMAGE (This.Width - (__UI_ScrollbarWidth + 1), This.Height - 3)-STEP(__UI_ScrollbarWidth - 2, 3), ControlImage, , (3, DropdownState * ButtonHeight - ButtonHeight + 18)-STEP(11, 3)
        _PUTIMAGE (This.Width - (__UI_ScrollbarWidth + 2), 2)-STEP(2, This.Height - 4), ControlImage, , (0, DropdownState * ButtonHeight - ButtonHeight + 2)-STEP(2, ButtonHeight - 6)
        _PUTIMAGE (This.Width - (__UI_ScrollbarWidth + 2), 0), ControlImage, , (0, DropdownState * ButtonHeight - ButtonHeight)-STEP(2, 2)
        _PUTIMAGE (This.Width - (__UI_ScrollbarWidth + 2), This.Height - 3), ControlImage, , (0, DropdownState * ButtonHeight - 3)-STEP(2, 2)
        _PUTIMAGE (This.Width - 3, 2)-STEP(2, This.Height - 4), ControlImage, , (ButtonWidth - 3, DropdownState * ButtonHeight - ButtonHeight + 2)-STEP(2, ButtonHeight - 6)
        _PUTIMAGE (This.Width - 2, 0), ControlImage, , (ButtonWidth - 2, DropdownState * ButtonHeight - ButtonHeight)-STEP(2, 2)
        _PUTIMAGE (This.Width - 3, This.Height - 3), ControlImage, , (ButtonWidth - 3, DropdownState * ButtonHeight - 3)-STEP(2, 2)
        _PUTIMAGE (This.Width - 1 - (__UI_ScrollbarWidth / 2) - ArrowWidth / 2, This.Height / 2 - ArrowHeight / 2), ControlImage_Arrow, , (0, (DropdownState + 4) * ArrowHeight - ArrowHeight)-STEP(ArrowWidth - 1, ArrowHeight - 1)
        __UI_MakeHardwareImageFromCanvas This
        _DEST PrevDest
    END IF
    IF This.Canvas THEN _PUTIMAGE (This.Left, This.Top), This.Canvas
END SUB
SUB __UI_DrawFrame (This AS __UI_ControlTYPE)
    DIM TempCaption$, CaptionIndent AS INTEGER, Temp&
    DIM TempCanvas AS LONG
    STATIC ControlImage AS LONG
    IF ControlImage = 0 THEN
        ControlImage = __UI_LoadThemeImage("frame.png")
        __UI_ClearColor ControlImage, 0, 0
    END IF
    IF This.Redraw OR This.PreviouslyHidden <> This.Hidden OR This.ChildrenRedrawn OR Caption(This.ID) <> __UI_TempCaptions(This.ID) OR This.HelperCanvas = 0 OR (__UI_IsDragging AND Control(__UI_DraggingID).ParentID = This.ID) OR This.Value <> This.PreviousValue OR __UI_ForceRedraw _
       OR __UI_DesignMode OR This.PreviousFont <> This.Font THEN
        This.Redraw = False
        This.ChildrenRedrawn = False
        This.PreviousFont = This.Font
        This.PreviousValue = This.Value
        This.PreviouslyHidden = This.Hidden
        __UI_TempCaptions(This.ID) = Caption(This.ID)
        _FONT This.Font
        TempCanvas = _NEWIMAGE(This.Width, This.Height + uspacing& \ 2, 32)
        _DEST TempCanvas
        _FONT This.Font
        IF LEN(Caption(This.ID)) > 0 THEN TempCaption$ = " " + __UI_TrimAt0$(Caption(This.ID)) + " "
        _FONT This.Font
        IF This.Hidden = False THEN
            IF This.BackStyle = __UI_Opaque THEN
                CLS , This.BackColor
            ELSE
                CLS , _RGBA32(0, 0, 0, 0)
            END IF
            CaptionIndent = 0
            IF This.HasBorder THEN CaptionIndent = 5
            IF NOT This.Disabled THEN
                COLOR This.ForeColor
            ELSE
                COLOR Darken(Control(__UI_FormID).BackColor, 80)
            END IF
            _PUTIMAGE (CaptionIndent, CaptionIndent + uspacing& \ 2), This.Canvas, TempCanvas, (CaptionIndent, CaptionIndent)-(This.Width, This.Height)
            IF This.HasBorder THEN
                _PUTIMAGE (0, uspacing& \ 2), ControlImage, , (0, 0)-STEP(2, 2)
                _PUTIMAGE (This.Width - 3, uspacing& \ 2), ControlImage, , (19, 0)-STEP(2, 2)
                _PUTIMAGE (0, This.Height + uspacing& \ 2 - 3), ControlImage, , (0, 17)-STEP(2, 2)
                _PUTIMAGE (This.Width - 3, This.Height + uspacing& \ 2 - 3), ControlImage, , (19, 17)-STEP(2, 2)
                _PUTIMAGE (0, uspacing& \ 2 + 2)-(0, This.Height + uspacing& \ 2 - 4), ControlImage, , (0, 3)-(0, 16)
                _PUTIMAGE (This.Width - 1, uspacing& \ 2 + 2)-(This.Width - 1, This.Height + uspacing& \ 2 - 4), ControlImage, , (0, 3)-(0, 16)
                _PUTIMAGE (3, uspacing& \ 2)-STEP(This.Width - 6, 0), ControlImage, , (3, 0)-STEP(15, 0)
                _PUTIMAGE (3, This.Height + uspacing& \ 2 - 1)-STEP(This.Width - 6, 0), ControlImage, , (3, 0)-STEP(15, 0)
            END IF
            DIM CaptionLeft AS INTEGER
            IF LEN(TempCaption$) > 0 THEN
                SELECT CASE This.Align
                    CASE __UI_Left
                        CaptionLeft = CaptionIndent
                    CASE __UI_Center
                        CaptionLeft = (This.Width \ 2 - __UI_PrintWidth(TempCaption$) \ 2)
                    CASE __UI_Right
                        CaptionLeft = (This.Width - __UI_PrintWidth(TempCaption$)) - CaptionIndent
                END SELECT
                LINE (CaptionLeft, 0)-STEP(__UI_PrintWidth(TempCaption$), uspacing&), This.BackColor, BF
                __UI_PrintString CaptionLeft, 0, TempCaption$
                IF (This.HotKey > 0 AND (__UI_ShowHotKeys AND NOT This.Disabled)) OR (This.HotKey > 0 AND __UI_DesignMode) THEN
                    Temp& = __UI_PrintWidth(CHR$(This.HotKey))
                    LINE (CaptionLeft + Temp& + This.HotKeyOffset, uheight&)-STEP(Temp& - 1, 0), This.ForeColor
                END IF
            END IF
        END IF
        __UI_MakeHardwareImage TempCanvas
        IF This.HelperCanvas <> 0 THEN _FREEIMAGE This.HelperCanvas
        This.HelperCanvas = TempCanvas
        _DEST 0
    END IF
    _FONT This.Font
    IF This.HelperCanvas < -1 THEN _PUTIMAGE (This.Left, This.Top - uspacing& \ 2), This.HelperCanvas
END SUB
SUB __UI_DrawMenuBar (This AS __UI_ControlTYPE, ControlState AS _BYTE)
    DIM PrevDest AS LONG, TempCaption$
    DIM Temp&
    IF This.Redraw OR This.FocusState <> (__UI_Focus = This.ID) OR This.Value <> This.PreviousValue OR This.ControlState <> ControlState OR Caption(This.ID) <> __UI_TempCaptions(This.ID) _
       OR __UI_ForceRedraw OR This.PreviousFont <> This.Font THEN
        This.Redraw = False
        This.ControlState = ControlState
        This.PreviousFont = This.Font
        This.PreviousValue = This.Value
        IF Caption(This.ID) <> __UI_TempCaptions(This.ID) THEN
            __UI_RefreshMenuBar
        END IF
        __UI_TempCaptions(This.ID) = Caption(This.ID)
        This.FocusState = (__UI_Focus = This.ID)
        IF This.Canvas <> 0 THEN
            _FREEIMAGE This.Canvas
        END IF
        This.Canvas = _NEWIMAGE(This.Width, This.Height, 32)
        PrevDest = _DEST
        _DEST This.Canvas
        _FONT (This.Font)
        CLS , This.BackColor
        TempCaption$ = __UI_TrimAt0$(Caption(This.ID))
        IF __UI_Focus = This.ID OR _
           (__UI_ParentMenu(__UI_TotalActiveMenus) = This.ID AND (Control(__UI_Focus).Type = __UI_Type_MenuPanel OR Control(__UI_Focus).Type = __UI_Type_MenuItem)) OR _
           (__UI_HoveringID = This.ID AND (Control(__UI_Focus).Type <> __UI_Type_MenuPanel AND Control(__UI_Focus).Type <> __UI_Type_MenuBar AND Control(__UI_Focus).Type <> __UI_Type_MenuItem)) THEN
            LINE (0, 0)-STEP(This.Width - 1, This.Height - 1), This.SelectedBackColor, BF
            COLOR This.SelectedForeColor
        ELSE
            COLOR This.ForeColor
        END IF
        IF This.Disabled THEN
            COLOR Darken(Control(__UI_FormID).BackColor, 80)
        END IF
        __UI_PrintString __UI_MenuBarOffset, ((This.Height \ 2) - (falcon_uspacing& + (((_FONT = 8) * -1) * __UI_Font8Offset + ((_FONT = 16) * -1) * __UI_Font16Offset)) \ 2), TempCaption$
        IF This.HotKey > 0 AND (__UI_AltIsDown OR Control(__UI_Focus).Type = __UI_Type_MenuBar OR __UI_DesignMode) THEN
            Temp& = __UI_PrintWidth(CHR$(This.HotKey))
            LINE (__UI_MenuBarOffset + This.HotKeyOffset, ((This.Height \ 2) + (falcon_uspacing& + (((_FONT = 8) * -1) * __UI_Font8Offset + ((_FONT = 16) * -1) * __UI_Font16Offset)) \ 2) - 1)-STEP(Temp& - 1, 0), _DEFAULTCOLOR
        END IF
        IF __UI_DesignMode THEN
            IF This.Left + This.Width = __UI_NewMenuBarTextLeft THEN
                _DEST Control(__UI_FormID).Canvas
                COLOR Darken(Control(__UI_FormID).BackColor, 80)
                _FONT (This.Font)
                LINE (__UI_NewMenuBarTextLeft + __UI_MenuBarOffset, ((This.Height \ 2) - (falcon_uspacing& + (((_FONT = 8) * -1) * __UI_Font8Offset + ((_FONT = 16) * -1) * __UI_Font16Offset)) \ 2))-STEP(__UI_PrintWidth("Add new"),(falcon_uspacing& + (((_FONT = 8) * -1) * __UI_Font8Offset + ((_FONT = 16) * -1) * __UI_Font16Offset))), Control(__UI_FormID).BackColor, BF
                __UI_PrintString __UI_NewMenuBarTextLeft + __UI_MenuBarOffset, ((This.Height \ 2) - (falcon_uspacing& + (((_FONT = 8) * -1) * __UI_Font8Offset + ((_FONT = 16) * -1) * __UI_Font16Offset)) \ 2), "Add new"
            END IF
        END IF
        __UI_MakeHardwareImageFromCanvas This
        _DEST PrevDest
    END IF
    IF This.Canvas THEN _PUTIMAGE (This.Left, This.Top), This.Canvas
END SUB
SUB __UI_DrawMenuPanel (This AS __UI_ControlTYPE, Parent AS LONG)
    DIM PrevDest AS LONG, TempCaption$
    DIM Temp&
    DIM CheckMarkIndex AS _BYTE
    STATIC ControlImage AS LONG, SubMenuArrow AS LONG
    CONST CheckMarkWidth = 7
    CONST CheckMarkHeight = 7
    IF ControlImage = 0 THEN
        ControlImage = __UI_LoadThemeImage("menucheckmark.bmp")
        __UI_ClearColor ControlImage, 0, 0
    END IF
    IF SubMenuArrow = 0 THEN
        SubMenuArrow = _NEWIMAGE(4, 7, 32)
        PrevDest = _DEST
        _DEST SubMenuArrow
        LINE (0, 0)-(3, 3), _RGB32(0, 0, 0)
        LINE -(0, 6), _RGB32(0, 0, 0)
        LINE -(0, 0), _RGB32(0, 0, 0)
        PAINT (2, 3), _RGB32(0, 0, 0)
        _DEST PrevDest
    END IF
    IF This.Redraw OR This.Value <> This.PreviousValue OR This.FocusState <> (__UI_Focus = This.ID) _
       OR __UI_ForceRedraw OR This.PreviousFont <> This.Font THEN
        This.Redraw = False
        This.FocusState = (__UI_Focus = This.ID)
        This.PreviousFont = This.Font
        This.PreviousValue = This.Value
        IF This.Canvas <> 0 THEN
            _FREEIMAGE This.Canvas
        END IF
        This.Canvas = _NEWIMAGE(This.Width + 5, This.Height + 5, 32)
        PrevDest = _DEST
        _DEST This.Canvas
        _FONT (This.Font)
        COLOR , _RGBA32(0, 0, 0, 0)
        CLS
        __UI_ShadowBox 0, 0, This.Width - 1, This.Height - 1, _RGB32(255, 255, 255), 40, 5
        LINE (0, 0)-STEP(This.Width - 1, This.Height - 1), This.BorderColor, B
        DIM i AS LONG, HasSeparator as _BYTE
        FOR i = 1 TO UBOUND(Control)
            IF Control(i).Type = __UI_Type_MenuItem AND NOT Control(i).Hidden AND Control(i).ParentID = Parent THEN
                TempCaption$ = __UI_TrimAt0$(Caption(i))
                IF RIGHT$(TempCaption$, 1) = "-" THEN
                    HasSeparator = True
                    TempCaption$ = LEFT$(TempCaption$, LEN(TempCaption$) - 1)
                ELSE
                    HasSeparator = False
                END IF
                IF __UI_Focus = i OR (__UI_HoveringID = i AND __UI_Focus = i) THEN
                    LINE (3, Control(i).Top)-STEP(This.Width - 7, Control(i).Height - 1), This.SelectedBackColor, BF
                    COLOR This.SelectedForeColor
                    CheckMarkIndex = 2
                ELSE
                    COLOR This.ForeColor
                    CheckMarkIndex = 1
                END IF
                IF Control(i).Disabled THEN
                    COLOR Darken(Control(__UI_FormID).BackColor, 80)
                    CheckMarkIndex = 3
                END IF
                __UI_PrintString Control(i).Left + __UI_MenuItemOffset, Control(i).Top + Control(i).Height \ 2 - uheight& \ 2, TempCaption$
                IF Control(i).KeyCombo > 0 THEN
                    __UI_PrintString Control(i).Left + This.Width - __UI_MenuItemOffset - __UI_PrintWidth(RTRIM$(__UI_KeyCombo(Control(i).KeyCombo).FriendlyCombo)), Control(i).Top + Control(i).Height \ 2 - uheight& \ 2, RTRIM$(__UI_KeyCombo(Control(i).KeyCombo).FriendlyCombo)
                END IF
                IF Control(i).SubMenu THEN
                    _PUTIMAGE (This.Width - __UI_MenuItemOffset / 2, Control(i).Top + Control(i).Height / 2 - 3), SubMenuArrow
                END IF
                IF Control(i).HotKey > 0 THEN
                    Temp& = __UI_PrintWidth(CHR$(Control(i).HotKey))
                    LINE (Control(i).Left + __UI_MenuItemOffset + Control(i).HotKeyOffset, Control(i).Top + Control(i).Height \ 2 + uheight& \ 2 - 1)-STEP(Temp& - 1, 0), _DEFAULTCOLOR
                END IF
                IF Control(i).Value = True THEN
                    IF Control(i).BulletStyle = __UI_Bullet%% THEN
                        __UI_PrintString __UI_MenuItemOffset \ 2 - __UI_PrintWidth(CHR$(7)) \ 2, Control(i).Top + Control(i).Height \ 2 - uheight \ 2, CHR$(7)
                    ELSE
                        _PUTIMAGE (__UI_MenuItemOffset \ 2 - CheckMarkWidth \ 2, Control(i).Top + Control(i).Height \ 2 - CheckMarkHeight \ 2), ControlImage, , (0, CheckMarkIndex * CheckMarkHeight - CheckMarkHeight)-STEP(6, 6)
                    END IF
                ELSE
                    DIM IconWidth AS INTEGER, IconHeight AS INTEGER
                    IF Control(i).HelperCanvas < -1 THEN
                        IF _HEIGHT(Control(i).HelperCanvas) = 16 AND _WIDTH(Control(i).HelperCanvas) MOD 16 = 0 THEN
                            SELECT CASE CheckMarkIndex
                                CASE 1 'normal
                                    _PUTIMAGE(3, Control(i).Top + Control(i).Height / 2 - 8)-STEP(15, 15), Control(i).HelperCanvas, ,(0, 0)-STEP(15, 15)
                                CASE 2 'hovered/selected
                                    IF _WIDTH(Control(i).HelperCanvas) >= 32 THEN
                                        _PUTIMAGE(3, Control(i).Top + Control(i).Height / 2 - 8)-STEP(15, 15), Control(i).HelperCanvas, ,(16, 0)-STEP(15, 15)
                                    ELSE
                                        _PUTIMAGE(3, Control(i).Top + Control(i).Height / 2 - 8)-STEP(15, 15), Control(i).HelperCanvas, ,(0, 0)-STEP(15, 15)
                                    END IF
                                CASE 3 'disabled
                                    IF _WIDTH(Control(i).HelperCanvas) >= 48 THEN
                                        _PUTIMAGE(3, Control(i).Top + Control(i).Height / 2 - 8)-STEP(15, 15), Control(i).HelperCanvas, ,(32, 0)-STEP(15, 15)
                                    ELSE
                                        _PUTIMAGE(3, Control(i).Top + Control(i).Height / 2 - 8)-STEP(15, 15), Control(i).HelperCanvas, ,(0, 0)-STEP(15, 15)
                                    END IF
                            END SELECT
                        ELSE
                            IconHeight = 16
                            IconWidth = _WIDTH(Control(i).HelperCanvas) * IconHeight / _HEIGHT(Control(i).HelperCanvas)
                            _PUTIMAGE (3, Control(i).Top + Control(i).Height / 2 - IconHeight / 2)-STEP(IconWidth - 1, IconHeight - 1), Control(i).HelperCanvas
                        END IF
                    END IF
                END IF
                IF HasSeparator THEN
                    LINE (4, Control(i).Top + Control(i).Height + 3)-STEP(This.Width - 9, 0), This.BorderColor
                END IF
            END IF
        NEXT
        IF __UI_DesignMode AND LEFT$(This.Name, 5) <> "__UI_" THEN
            COLOR Darken(Control(__UI_FormID).BackColor, 80)
            __UI_PrintString __UI_MenuItemOffset, This.Height - (uheight& + 6), "Add new"
        END IF
        __UI_MakeHardwareImageFromCanvas This
        _DEST PrevDest
    END IF
    IF This.Canvas THEN _PUTIMAGE (This.Left, This.Top), This.Canvas
END SUB
SUB __UI_DrawContextMenuHandle (This AS __UI_ControlTYPE, ControlState AS _BYTE)
    DIM PrevDest AS LONG
    DIM i AS LONG
    IF This.Redraw OR Control(__UI_FormID).Height <> This.PreviousValue OR This.ControlState <> ControlState OR __UI_ForceRedraw THEN
        This.Redraw = False
        This.ControlState = ControlState
        This.PreviousValue = Control(__UI_FormID).Height
        IF This.Canvas <> 0 THEN
            _FREEIMAGE This.Canvas
        END IF
        This.Canvas = _NEWIMAGE(This.Width, This.Height, 32)
        This.Top = Control(__UI_FormID).Height - This.Height - __UI_SnapDistanceFromForm
        PrevDest = _DEST
        _DEST This.Canvas
        _FONT This.Font
        SELECT CASE This.ControlState
            CASE 1
                COLOR This.SelectedBackColor, This.SelectedForeColor
            CASE 2
                COLOR This.SelectedForeColor, This.SelectedBackColor
        END SELECT
        CLS
        IF This.HelperCanvas < -1 THEN
            _PUTIMAGE ((_WIDTH - _WIDTH(This.HelperCanvas)) / 2, (_HEIGHT - _HEIGHT(This.HelperCanvas)) / 2), This.HelperCanvas
        END IF
        i = 0
        LINE (i, i)-STEP(This.Width - 1 - i * 2, This.Height - 1 - i * 2), This.BorderColor, B
        __UI_MakeHardwareImageFromCanvas This
        _DEST PrevDest
    END IF
    IF This.Canvas THEN _PUTIMAGE (This.Left, This.Top), This.Canvas
END SUB
SUB __UI_DrawPictureBox (This AS __UI_ControlTYPE, ControlState AS _BYTE)
    DIM PrevDest AS LONG, TheX AS INTEGER, TheY AS INTEGER
    DIM i AS LONG
    IF This.Redraw OR This.Stretch <> This.PreviousStretch OR This.PreviousValue <> This.HelperCanvas OR This.ControlState <> ControlState OR This.PreviousParentID <> This.ParentID _
       OR __UI_ForceRedraw OR This.PreviousFont <> This.Font THEN
        This.Redraw = False
        This.ControlState = ControlState
        This.PreviousFont = This.Font
        IF This.ParentID THEN Control(This.ParentID).ChildrenRedrawn = True
        This.PreviousParentID = This.ParentID
        This.PreviousValue = This.HelperCanvas
        This.PreviousStretch = This.Stretch
        IF This.Canvas <> 0 THEN
            _FREEIMAGE This.Canvas
        END IF
        This.Canvas = _NEWIMAGE(This.Width, This.Height, 32)
        PrevDest = _DEST
        _DEST This.Canvas
        IF This.BackStyle = __UI_Opaque THEN
            CLS , This.BackColor
        ELSE
            CLS , _RGBA32(0, 0, 0, 0)
        END IF
        IF This.HasBorder THEN
            IF This.BorderSize > __UI_MaxBorderSize THEN
                This.BorderSize = __UI_MaxBorderSize
            ELSEIF This.BorderSize < 1 THEN
                This.BorderSize = 1
            END IF
        END IF
        IF This.Stretch THEN
            _PUTIMAGE (This.BorderSize * ABS(This.HasBorder), This.BorderSize * ABS(This.HasBorder))-(This.Width - (This.BorderSize * ABS(This.HasBorder) + 1), This.Height - (This.BorderSize * ABS(This.HasBorder) + 1)), This.HelperCanvas, This.Canvas
        ELSE
            TheX = This.BorderSize * ABS(This.HasBorder) 'Default = Left
            IF This.Align = __UI_Center THEN TheX = This.Width / 2 - _WIDTH(This.HelperCanvas) / 2
            IF This.Align = __UI_Right THEN TheX = This.Width - 1 - _WIDTH(This.HelperCanvas) - (This.BorderSize * ABS(This.HasBorder))
            TheY = This.BorderSize * ABS(This.HasBorder) 'Default = Top
            IF This.VAlign = __UI_Middle THEN TheY = This.Height / 2 - _HEIGHT(This.HelperCanvas) / 2
            IF This.VAlign = __UI_Bottom THEN TheY = This.Height - 1 - _HEIGHT(This.HelperCanvas) - (This.BorderSize * ABS(This.HasBorder))
            _PUTIMAGE (TheX, TheY), This.HelperCanvas, This.Canvas
        END IF
        IF This.HasBorder THEN
            FOR i = 0 TO This.BorderSize - 1
                LINE (i, i)-STEP(This.Width - 1 - i * 2, This.Height - 1 - i * 2), This.BorderColor, B
            NEXT
        END IF
        __UI_MakeHardwareImageFromCanvas This
        _DEST PrevDest
    END IF
    IF This.Canvas THEN _PUTIMAGE (This.Left, This.Top), This.Canvas
END SUB
SUB __UI_ShadowBox (bX AS INTEGER, bY AS INTEGER, bW AS INTEGER, bH AS INTEGER, C AS LONG, shadowLevel AS INTEGER, shadowSize AS INTEGER)
    DIM i AS INTEGER
    FOR i = 1 TO shadowSize
        LINE (bX + i, bY + i)-STEP(bW, bH), _RGBA32(0, 0, 0, shadowLevel - (shadowLevel / shadowSize) * i), BF
    NEXT i
    LINE (bX, bY)-STEP(bW, bH), C, BF
END SUB
SUB __UI_ThemeSetup
    __UI_ScrollbarWidth = 17
    __UI_ScrollbarButtonHeight = 17
    __UI_MenuBarOffset = 8
    __UI_MenuItemOffset = 22
    __UI_DefaultCaptionIndent = 5
END SUB
FUNCTION __UI_DefaultColor~& (ControlType AS _BYTE, Attribute AS _BYTE)
    DIM Colors(1 TO 6) AS _UNSIGNED LONG
    Colors(1) = _RGB32(0, 0, 0)
    IF ControlType <> __UI_Type_Form AND Control(__UI_FormID).ForeColor <> Colors(1) THEN _
        Colors(1) = Control(__UI_FormID).ForeColor
    Colors(2) = _RGB32(235, 233, 237)
    IF ControlType <> __UI_Type_Form AND Control(__UI_FormID).BackColor <> Colors(2) THEN _
        Colors(2) = Control(__UI_FormID).BackColor
    Colors(3) = _RGB32(255, 255, 255)
    IF ControlType <> __UI_Type_Form AND Control(__UI_FormID).SelectedForeColor <> Colors(3) THEN _
        Colors(3) = Control(__UI_FormID).SelectedForeColor
    Colors(4) = _RGB32(78, 150, 216)
    IF ControlType <> __UI_Type_Form AND Control(__UI_FormID).SelectedBackColor <> Colors(4) THEN _
        Colors(4) = Control(__UI_FormID).SelectedBackColor
    Colors(5) = _RGB32(167, 166, 170)
    IF ControlType <> __UI_Type_Form AND Control(__UI_FormID).BorderColor <> Colors(5) THEN _
        Colors(5) = Control(__UI_FormID).BorderColor
    Colors(6) = _RGB32(255, 255, 225)
    SELECT CASE ControlType
        CASE __UI_Type_TextBox, __UI_Type_ListBox, __UI_Type_DropdownList
            Colors(2) = _RGB32(255, 255, 255)
    END SELECT
    __UI_DefaultColor~& = Colors(Attribute)
END FUNCTION
FUNCTION __UI_ImageData$ (File$)
    DIM A$
    SELECT CASE LCASE$(File$)
        CASE "scrollhbuttons.bmp"
            A$ = MKI$(17) + MKI$(136) 'Width, Height
            A$ = A$ + "okNhoC?g8o?[D2hoAWKYo3=^Tn?dhBjo@S;Yo3=^Tn?dhBjo@S;Yo3=^Tn?dhBjo@S;Yo3=^Tnocg>joY6IOoC?g8ooo^7noaVIQ"
            A$ = A$ + "o;_f6ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo_lJKloaVIQoo_kQoO\IFhooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooO\IFhookNho7KV5noooooooconoo?okooo"
            A$ = A$ + "l_oooconoo?okoool_oooconoo?okoool_oooconoo?okoool_ooooooo7KV5noo^7noaVIQooooooooeknooG_kooOm^oooekno"
            A$ = A$ + "oG_kooOm^oooeknooG_kooOm^oooeknooG_kooOm^oooooooaVIQoo_kQoO\IFhooooooookRooo_;nooo^hoookRooo_;nooo^h"
            A$ = A$ + "o?7IKmoo_;nooo^hoookRooo_;nooo^hooooooO\IFhookNho7KV5noooooooOndoooiCoooW?mooOndoooiCooLT]eocAfFoooi"
            A$ = A$ + "CoooW?mooOndoooiCoooW?moooooo7KV5noo^7noaVIQoooooo_mN[lofk]boK_g:o_mN[locAfFo?7IKmoLT]eofk]boK_g:o_m"
            A$ = A$ + "N[lofk]boK_g:oooooooaVIQoo_kQoO\IFhooooook^e2o_kF;lo^K]`o?7IKmoLT]eocAfFok^e2o_kF;lo^K]`ok^e2o_kF;lo"
            A$ = A$ + "^K]`ooooooO\IFhookNho7KV5nooooooY7M_oWNdmnOjAgkoY7M_o?7IKmoLT]eocAfFoWNdmnOjAgkoY7M_oWNdmnOjAgkooooo"
            A$ = A$ + "o7KV5noo^7noaVIQoooooo?j@ckoX3=_oS>dln?j@ckoX3=_o?7IKmoLT]eoX3=_oS>dln?j@ckoX3=_oS>dlnooooooaVIQoo_k"
            A$ = A$ + "QoO\IFhooooooS>dln?j@ckoX3=_oS>dln?j@ckoX3=_o?7IKm?j@ckoX3=_oS>dln?j@ckoX3=_ooooooO\IFhookNho7KV5noo"
            A$ = A$ + "ooooX3=_oS>dln?j@ckoX3=_oS>dln?j@ckoX3=_oS>dln?j@ckoX3=_oS>dln?j@ckoooooo7KV5noo^7noaVIQoooooo?j@cko"
            A$ = A$ + "X3=_oS>dln?j@ckoX3=_oS>dln?j@ckoX3=_oS>dln?j@ckoX3=_oS>dlnooooooaVIQoo_kQoO\IFhooooooS>dln?j@ckoX3=_"
            A$ = A$ + "oS>dln?j@ckoX3=_oS>dln?j@ckoX3=_oS>dln?j@ckoX3=_ooooooO\IFhookNho7KV5nOnQglofk]boK_g:o_mN[lofk]boK_g"
            A$ = A$ + ":o_mN[lofk]boK_g:o_mN[lofk]boK_g:o_mN[loi7Nco7KV5noo^7nooo^hoS:Tlm_^Rjhoj:ZSo[[X>n_^Rjhoj:ZSo[[X>n_^"
            A$ = A$ + "Rjhoj:ZSo[[X>n_^Rjhoj:ZSo[[X>noY?^gooSneoo_kQo?mLSlonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eo"
            A$ = A$ + "nIVDokWIBm_OV9eonIVDokWIBm?mLSlookNhokWIBm_lJKlooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooob[]aokWIBmoo^7nonIVDoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooonIVDoo_kQo_OV9eooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo_O"
            A$ = A$ + "V9eookNhokWIBmoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooookWIBmoo^7no"
            A$ = A$ + "nIVDoooooooooooooooooooooooooooooooooooooo?Qk]fooooooooooooooooooooooooooooooooonIVDoo_kQo_OV9eooooo"
            A$ = A$ + "ooonioookWooo_OnooonioookWoo4^gJoChN[mookWooo_OnooonioookWooo_Onoooooo_OV9eookNhokWIBmooooooo7oiooOl"
            A$ = A$ + "WoooaOnoo7oioChN[m?Qk]fo4^gJooOlWoooaOnoo7oiooOlWoooaOnooooookWIBmoo^7nonIVDooooooooW?mooOndoooiCo?Q"
            A$ = A$ + "k]fo4^gJoChN[mooW?mooOndoooiCoooW?mooOndoooiCooooooonIVDoo_kQo_OV9eooooooGOg9oOmMWloegMboGOg9o?Qk]fo"
            A$ = A$ + "4^gJoChN[mOmMWloegMboGOg9oOmMWloegMboooooo_OV9eookNhokWIBmoooooo_Om`oone3ookG?lo_Om`oone3o?Qk]fo4^gJ"
            A$ = A$ + "oone3ookG?lo_Om`oone3ookG?looooookWIBmoo^7nonIVDooooooOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1o?Qk]fo]GM`ogNe"
            A$ = A$ + "1oOkE7lo]GM`ogNe1ooooooonIVDoo_kQo_OV9eoooooogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOk"
            A$ = A$ + "E7lo]GM`oooooo_OV9eookNhokWIBmoooooo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo"
            A$ = A$ + "oooookWIBmoo^7nonIVDooooooOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1ooooooonIVD"
            A$ = A$ + "oo_kQo_OV9eoi7NcoK_g:o_mN[lofk]boK_g:o_mN[lofk]boK_g:o_mN[lofk]boK_g:o_mN[lofk]boWOh=o_OV9eookNhoook"
            A$ = A$ + "Ro_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDoo?jGooo^7noX3=_okWIBm_O"
            A$ = A$ + "V9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eoI7L[oo_kQo_OV9eodc=booombooog;oo"
            A$ = A$ + "oO_looombooog;oooO_looombooog;oooO_looombooog;oooO_loC?g8o_OV9eookNhokWIBmooooooOOl\oomacnog7?koOOl\"
            A$ = A$ + "oomacnog7?koOOl\oomacnog7?koOOl\oomacnog7?kooooookWIBmoo^7nonIVDoooooookG?lo_Om`oone3ookG?lo_Om`oone"
            A$ = A$ + "3ookG?lo_Om`oone3ookG?lo_Om`oone3ooooooonIVDoo_kQo_OV9eooooook_iBo_nRkloj;^co[_h>o_nRkloj;^co_oh?oon"
            A$ = A$ + "Solok?ncok_iBo_oV;monK^doooooo_OV9eookNhokWIBmooooooo;Ojoo_kQooo^7nookNhoo_kQooo^7no4^gJoookRooo`Gno"
            A$ = A$ + "o;Ojoo_lYooobWnooooookWIBmoo^7nonIVDooooooooooooog?oooOolooomcooog?ooChN[m?Qk]fook_ooo_onooonkoooooo"
            A$ = A$ + "oooooooooooonIVDoo_kQo_OV9eooooooooooooooooooooooooooo?Qk]fo4^gJoChN[moooooooooooooooooooooooooooooo"
            A$ = A$ + "oo_OV9eookNhokWIBmoooooooooooooooooooooo4^gJoChN[m?Qk]fooooooooooooooooooooooooooooooooooooookWIBmoo"
            A$ = A$ + "^7nonIVDoooooooooooooooooooooooooooo4^gJoChN[m?Qk]fooooooooooooooooooooooooooooooooonIVDoo_kQo_OV9eo"
            A$ = A$ + "oooooooooooooooooooooooooooooooo4^gJoChN[moooooooooooooooooooooooooooooooo_OV9eookNhokWIBmoooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooo4^gJoooooooooooooooooooooooooooooooookWIBmoo^7nonIVDoooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooonIVDoo_kQo_OV9eooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooo_OV9eookNhokWIBm?cd2jooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooo<C;XokWIBmoo^7nonIVDokWIBm?cd2jo<C;Xoc<]Pn?cd2jo<C;Xoc<]Pn?cd2jo<C;X"
            A$ = A$ + "oc<]Pn?cd2jo<C;Xoc<]Pn_OV9eonIVDoo_kQo?f0cjonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWI"
            A$ = A$ + "Bm_OV9eonIVDokWIBm_djJjookNhoo?okooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooOkOooo^7noooooooomboooaOnooo^hooOkOooo\gmoo_>gooOjHoooYSmooSneoo?jGoooWGmonK^dooolZooooooo"
            A$ = A$ + "oOndoo_kQoooooooo7oiooombooofonoo?_joo_lYoooaOnoo7oiooOlWooo`Gnooo>ioookRooo]omooONeooooooOnQglookNh"
            A$ = A$ + "oooooooo_;nooKokooOm^ooobWnoo7oiooOlWooo`Gnooo>ioookTooo_;nookNhooOkOoooWGmoooooo7Of5ooo^7noooooooOk"
            A$ = A$ + "Ooooc[noo;OjooOlWooo`Gnoo3Oioo?lUooo^7noogngooOkOooo]omoogngoo?jGooooooo\C=`oo_kQoooooooo_>gooOlWooo"
            A$ = A$ + "aOnoo7oioo?lUooo`Gnoo3Oio;Lb9ooo]omoogngooOkOooo]omooSneoooooo?j@ckookNhoooooooo[cmoo7oiooOlWooo`Gno"
            A$ = A$ + "o3Oioo?lUo_`9Wlo2WLbooOkOooo\gmoogngoo?kMoooXOmooooooK^cjnoo^7noooooooOjHooo`Gnoo7oiooOlWoooaOno2WLb"
            A$ = A$ + "o;Lb9o_`9WloocNgoo?kMooo\gmoocNgoo?jGoooooooUgL^oo_kQooooooooSneoo?lUooo`Gnoo3Oio;Lb9o_`9Wlo2WLboo?k"
            A$ = A$ + "Mooo\gmoocNgoo?kMooo[cmooONeooooooOi=WkookNhooooooooWGmooo>ioookTooo_Cnooo>io;Lb9o_`9Wlo2WLbooOkOooo"
            A$ = A$ + "\gmoocNgooojLoooWGmooooooGNcinoo^7nooooooooiEooo_;nooo>ioookTooo_Cnooo^ho;Lb9o_`9Wloo_>gooojLooo[cmo"
            A$ = A$ + "o[^foooiEoooooooUgL^oo_kQooooooooOndoo_kQooo_;nooo^hoookRooo_;nookNho;Lb9ooo\gmoo_>goo_jJoooYSmooOnd"
            A$ = A$ + "ooooooOi=WkookNhooooooooW?moogngoo_kQooo^7nookNhoo_kQooo]omoocNgoo?kMooo[cmoo[^foo?jGo_oV;mooooooGNc"
            A$ = A$ + "inoo^7nooooooc?i@ooo[cmoocNgooOkOooo]omoocNgoo?kMooo[cmoo[^fooOjHoooXOmooONeogOiAoooooooUgL^oo_kQooo"
            A$ = A$ + "ooooo;OjoooiCoooWGmooONeoooiEoooWGmooONeoooiEoooWGmooOndoooiCoOoU7moo7oiooooooojCokookNhoc?i@ooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooodc=booOkOooo^7noo?_jo3?f4oOi=WkoR[\]"
            A$ = A$ + "ok]abnOg57koMGL\ogMaanOg57koMGL\ogMaanOg57koOOl\oWNdmnoofonoogngoo_kQo?mLSlo\B9Po7M^Un?dhBjo@S;Yo3=^"
            A$ = A$ + "Tn?dhBjo@S;Yo3=^Tn?dhBjo@S;Yo3=^Tn?dhBjo?OkXoWJTmm?mLSlookNho7KV5n_lJKlooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooob[]ao7KV5noo^7noaVIQoooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooaVIQoo_kQoO\IFhooooooo?okoool_oooconoo?okoool_oooconoo?okoool_ooocon"
            A$ = A$ + "oo?okoool_oooconooooooO\IFhookNho7KV5noooooooG_kooOm^oooeknooG_kooOm^oooeknooG_kooOm^oooeknooG_kooOm"
            A$ = A$ + "^oooeknoooooo7KV5noo^7noaVIQoooooooo_;nooo^hoookRooo_;nocAfFoookRooo_;nooo^hoookRooo_;nooo^hoookRooo"
            A$ = A$ + "ooooaVIQoo_kQoO\IFhooooooooiCoooW?mooOndoooiCooLT]eocAfFoooiCoooW?mooOndoooiCoooW?mooOndooooooO\IFho"
            A$ = A$ + "okNho7KV5noooooofk]boK_g:o_mN[lofk]bo?7IKmoLT]eocAfFoK_g:o_mN[lofk]boK_g:o_mN[loooooo7KV5noo^7noaVIQ"
            A$ = A$ + "oooooo_kF;lo^K]`ok^e2o_kF;lo^K]`o?7IKmoLT]eocAfFok^e2o_kF;lo^K]`ok^e2oooooooaVIQoo_kQoO\IFhooooooWNd"
            A$ = A$ + "mnOjAgkoY7M_oWNdmnoLT]eocAfFo?7IKmOjAgkoY7M_oWNdmnOjAgkoY7M_ooooooO\IFhookNho7KV5nooooooX3=_oS>dln?j"
            A$ = A$ + "@ckoX3=_o?7IKmoLT]eoX3=_oS>dln?j@ckoX3=_oS>dln?j@ckoooooo7KV5noo^7noaVIQoooooo?j@ckoX3=_oS>dln?j@cko"
            A$ = A$ + "cAfFoS>dln?j@ckoX3=_oS>dln?j@ckoX3=_oS>dlnooooooaVIQoo_kQoO\IFhooooooS>dln?j@ckoX3=_oS>dln?j@ckoX3=_"
            A$ = A$ + "oS>dln?j@ckoX3=_oS>dln?j@ckoX3=_ooooooO\IFhookNho7KV5nooooooX3=_oS>dln?j@ckoX3=_oS>dln?j@ckoX3=_oS>d"
            A$ = A$ + "ln?j@ckoX3=_oS>dln?j@ckoooooo7KV5noo^7noaVIQoooooo?j@ckoX3=_oS>dln?j@ckoX3=_oS>dln?j@ckoX3=_oS>dln?j"
            A$ = A$ + "@ckoX3=_oS>dlnooooooaVIQoo_kQoO\IFhoi7NcoK_g:o_mN[lofk]boK_g:o_mN[lofk]boK_g:o_mN[lofk]boK_g:o_mN[lo"
            A$ = A$ + "fk]boWOh=oO\IFhookNhoookRo?Z@bgoj:ZSo[[X>n_^Rjhoj:ZSo[[X>n_^Rjhoj:ZSo[[X>n_^Rjhoj:ZSo[[X>n_^RjhoWnhN"
            A$ = A$ + "oo?jGooo^7nodc=bokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eodc=boo_k"
            A$ = A$ + "Qo_OV9eob[]aooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo;_f6o_OV9eookNhokWIBmoo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooookWIBmoo^7nonIVDoooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooonIVDoo_kQo_OV9eooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooo_OV9eookNhokWIBmoooooooooooooooooooooooooooChN"
            A$ = A$ + "[moooooooooooooooooooooooooooooooooooooooooookWIBmoo^7nonIVDooooooookWooo_OnooonioookWoo4^gJoChN[moo"
            A$ = A$ + "kWooo_OnooonioookWooo_OnoooniooooooonIVDoo_kQo_OV9eoooooooOlWoooaOnoo7oiooOlWo?Qk]fo4^gJoChN[mooaOno"
            A$ = A$ + "o7oiooOlWoooaOnoo7oioooooo_OV9eookNhokWIBmoooooooOndoooiCoooW?mooOndoooiCo?Qk]fo4^gJoChN[mooW?mooOnd"
            A$ = A$ + "oooiCoooW?mooooookWIBmoo^7nonIVDooooooOmMWloegMboGOg9oOmMWlo4^gJoChN[m?Qk]foegMboGOg9oOmMWloegMboGOg"
            A$ = A$ + "9ooooooonIVDoo_kQo_OV9eooooooone3ookG?lo_Om`oone3o?Qk]fo4^gJoone3ookG?lo_Om`oone3ookG?lo_Om`oooooo_O"
            A$ = A$ + "V9eookNhokWIBmoooooo]GM`ogNe1oOkE7lo]GM`oChN[mOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7looooookWIBmoo^7no"
            A$ = A$ + "nIVDooooooOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1ooooooonIVDoo_kQo_OV9eooooo"
            A$ = A$ + "ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`oooooo_OV9eookNhokWIBmoooooo]GM`ogNe"
            A$ = A$ + "1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7looooookWIBmoo^7nonIVDoWOh=o_mN[lofk]boK_g:o_m"
            A$ = A$ + "N[lofk]boK_g:o_mN[lofk]boK_g:o_mN[lofk]boK_g:oOnQglonIVDoo_kQooo_;nonIVDokWIBm_OV9eonIVDokWIBm_OV9eo"
            A$ = A$ + "nIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBmooXOmookNhoS>dln_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVD"
            A$ = A$ + "okWIBm_OV9eonIVDokWIBm_OV9eonIVDoWM`]noo^7nonIVDoC?g8ooog;oooO_looombooog;oooO_looombooog;oooO_looom"
            A$ = A$ + "booog;oooO_looombo?mLSlonIVDoo_kQo_OV9eooooooomacnog7?koOOl\oomacnog7?koOOl\oomacnog7?koOOl\oomacnog"
            A$ = A$ + "7?koOOl\oooooo_OV9eookNhokWIBmoooooo_Om`oone3ookG?lo_Om`oone3ookG?lo_Om`oone3ookG?lo_Om`oone3ookG?lo"
            A$ = A$ + "oooookWIBmoo^7nonIVDoooooo_oV;moj;^co[_h>o_nRkloj;^co[_h>oonSolok?nco_oh?o_oV;monK^dok_iBooooooonIVD"
            A$ = A$ + "oo_kQo_OV9eooooooo_lYooo^7nookNhoo_kQo?Qk]fookNhoookRooo_;noo3Oioo_lYooobWnoo;Ojoooooo_OV9eookNhokWI"
            A$ = A$ + "BmooooooooooooOolooomcooog?ooChN[m?Qk]fook_ooo_onooonkoook_ooooooooooooooooookWIBmoo^7nonIVDoooooooo"
            A$ = A$ + "oooooooooooooooooooo4^gJoChN[m?Qk]fooooooooooooooooooooooooooooooooonIVDoo_kQo_OV9eooooooooooooooooo"
            A$ = A$ + "oooooooooooooooo4^gJoChN[m?Qk]fooooooooooooooooooooooooooo_OV9eookNhokWIBmoooooooooooooooooooooooooo"
            A$ = A$ + "oChN[m?Qk]fo4^gJoooooooooooooooooooooooooooooooookWIBmoo^7nonIVDoooooooooooooooooooooooooooo4^gJoChN"
            A$ = A$ + "[moooooooooooooooooooooooooooooooooooooonIVDoo_kQo_OV9eooooooooooooooooooooooooooo?Qk]fooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooo_OV9eookNhokWIBmoooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooookWIBmoo^7nonIVDoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooonIVDoo_kQo_OV9eo<C;Xoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooc<]"
            A$ = A$ + "Pn_OV9eookNhokWIBm_OV9eo<C;Xoc<]Pn?cd2jo<C;Xoc<]Pn?cd2jo<C;Xoc<]Pn?cd2jo<C;Xoc<]Pn?cd2jonIVDokWIBmoo"
            A$ = A$ + "^7noH3<[okWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eoB[[Yoo_kQoool_oo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo]omookNhoooooooog;ooo7oi"
            A$ = A$ + "oookRooo]omoocNgooojLoooYSmooW>foo?jGoooXOmooONeok_iBoooc[nooooooooiCooo^7noooooooOlWooog;oooKokoool"
            A$ = A$ + "ZooobWnoo7oiooOlWoooaOnoo3OioookTooo_;noogngoooiEoooooooi7Ncoo_kQooooooooo^hoo_m_oooeknoo;OjooOlWooo"
            A$ = A$ + "aOnoo3OioookTooo_Cnooo^hoo_kQooo]omooONeooooooOlIGlookNhoooooooo]omoo?_joo_lYoooaOnoo3Oioo?lUooo`Gno"
            A$ = A$ + "okNhooOkOooo]omoogngooOkOoooXOmooooooc>e0ooo^7noooooooojLoooaOnoo7oiooOlWooo`Gno2WLboo?lUooo]omoogng"
            A$ = A$ + "ooOkOooo]omoogngoo?jGoooooooX3=_oo_kQoooooooo_>gooOlWoooaOnoo3Oioo?lUo_`9Wlo2WLbooOkOooo]omoocNgooOk"
            A$ = A$ + "Oooo\gmooSneoooooo_i>[kookNhooooooooYSmoo3OiooOlWoooaOnoo7oio;Lb9o_`9Wlo2WLboo?kMooo\gmoocNgoo?kMooo"
            A$ = A$ + "XOmooooooGNcinoo^7nooooooo?jGooo`Gnoo3Oioo?lUooo^7nookNho;Lb9o_`9Wlo2WLboo?kMooo\gmoo_>goooiEooooooo"
            A$ = A$ + "UgL^oo_kQooooooooONeoookTooo_Cnooo>ioookTo_`9Wlo2WLbo;Lb9ooo]omoocNgoo?kMooo[cmooONeooooooOi=WkookNh"
            A$ = A$ + "ooooooooWGmooo^hoookTooo_Cnooo>io;Lb9o_`9WloogngooojLooo[cmoo_>goo_jJoooWGmooooooGNcinoo^7nooooooooi"
            A$ = A$ + "Cooo^7nooo^hoookRooo_;no2WLboo_kQooo]omoocNgooojLoooZ[mooW>foooiCoooooooUgL^oo_kQooooooooOndooOkOooo"
            A$ = A$ + "^7nookNhoo_kQooo^7noogngoo?kMooo\gmoo_>goo_jJoooXOmonK^dooooooOi=WkookNhoooooo?oT3moo_>goo?kMooo]omo"
            A$ = A$ + "ogngoo?kMooo\gmoo_>goo_jJoooYSmooSneoooiEoOoU7mooooooGNcinoo^7nooooooo_lYoooW?mooONeoooiEoooWGmooONe"
            A$ = A$ + "oooiEoooWGmooONeoooiCoooW?momGNdooOlWooooooo[?m_oo_kQo?oT3mooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooC?g8ooo]omookNhooolZo?lHCloUgL^o;^bfn_g6;koMGL\ogMaanOg57koMGL\ogMaanOg"
            A$ = A$ + "57koMGL\oomacnOjAgkooKokooOk%Oo?"
        CASE "scrollhthumb.bmp"
            A$ = MKI$(22) + MKI$(60)
            A$ = A$ + "ogngooOkOooo]omoogngooOkOooo]omoogngooOkOooo]omoogngooOkOooo]omoogngooOkOooo]omoogngooOkOooo]omoogng"
            A$ = A$ + "ooOkOooo]omoogngo7Of5oobcnioC_kYo?m^WnodkNjoC_kYo?m^WnodkNjoC_kYo?m^WnodkNjoC_kYo?m^WnodkNjoC_kYo?m^"
            A$ = A$ + "WnodkNjoC_kYo?m^WnodkNjo4c:VoWNdmnO\IFhoo[omoooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooo_ngoO\IFhoaVIQoooooooog;oooO_looombooog;oooO_looombooog;oo"
            A$ = A$ + "oO_looombooog;oooO_looombooog;oooO_looombooog;oooO_looomboooooooaVIQo7KV5noooooooo^hoookRooo_;nooo^h"
            A$ = A$ + "oookRooo_;nooo^hoookRooo_;nooo^hoookRooo_;nooo^hoookRooo_;nooo^hoookRooo_;noooooo7KV5nO\IFhooooooook"
            A$ = A$ + "Rooo_;nooo^hoookRooo_;nooo^hoookRooo_;nooo^hoookRooo_;nooo^hoookRooo_;nooo^hoookRooo_;nooo^hooooooO\"
            A$ = A$ + "IFhoaVIQoooooooo\gmoo_>gooojLooo\gmoo_>gooojLooo[cmoo_>goo?kMooo[cmoo_>goo?kMooo[cmoo_>gooojLooo[cmo"
            A$ = A$ + "o_>gooojLoooooooaVIQo7KV5noooooooOndok_iBo_oV;mooOndok_iBo_oV;monK^doooiCoooW?monK^dok_iBoooW?monK^d"
            A$ = A$ + "ok_iBo_oV;mooOndok_iBoooW?moooooo7KV5nO\IFhooooooOog;oomO_logomboS?h<o?nPcloh3>coS?h<oomO_logomboOog"
            A$ = A$ + ";oomO_loh3>coS?h<o?nPcloh3>coOog;oomO_loh3>cooooooO\IFhoaVIQooooooOlIGloaWMao7Of5oOlIGloaWMao7Of5oOl"
            A$ = A$ + "IGloaWMao7Of5oOlIGloaWMao7Of5oOlIGloaWMao7Of5oOlIGloaWMao7Of5oooooooaVIQo7KV5noooooo[?m_o_ndon?kD3lo"
            A$ = A$ + "[?m_o_ndon?kD3lo[?m_oc>e0oojCoko[?m_oc>e0oojCoko[?m_oc>e0oojCoko\C=`o_ndonojCokoooooo7KV5nO\IFhooooo"
            A$ = A$ + "oWNdmnOjAgkoY7M_oWNdmnOjAgkoY7M_oWNdmnOjAgkoY7M_oWNdmnOjAgkoY7M_oWNdmnOjAgkoY7M_oWNdmnOjAgkoY7M_oooo"
            A$ = A$ + "ooO\IFhoaVIQoooooo_jBkkoZ;]_o[^dnn_jBkkoZ;]_o[^dnn_jBkkoZ;]_o[^dnn_jBkkoZ;]_o[^dnn_jBkkoZ;]_o[^dnn_j"
            A$ = A$ + "BkkoZ;]_o[^dnnooooooaVIQo7KV5n_mN[loTc<^oC>chn?i<SkoTc<^oC>chn?i<SkoTc<^oC>chn?i<SkoTc<^oC>chn?i<Sko"
            A$ = A$ + "Tc<^oC>chn?i<SkoTc<^oC>chn?i<Skofk]bok[YBnoo^7noEgKZo[[X>n_^Rjhoj:ZSo[[X>n_^Rjhoj:ZSo[[X>n_^Rjhoj:ZS"
            A$ = A$ + "o[[X>n_^Rjhoj:ZSo[[X>n_^Rjhoj:ZSo[[X>n_^Rjhoj:ZSoS=`\noo^7noogngooOkOooo]omoogngooOkOooo]omoogngooOk"
            A$ = A$ + "Oooo]omoogngooOkOooo]omoogngooOkOooo]omoogngooOkOooo]omoogngooOkOooo]omoogngoomacn_OV9eonIVDokWIBm_O"
            A$ = A$ + "V9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDoomacn_OV9eo"
            A$ = A$ + "b[]aoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "o;_f6o_OV9eonIVDoooooooonkoook_ooo_onooonkoook_ooo_onooonkoook_ooo_onooonkoook_ooo_onooonkoook_ooo_o"
            A$ = A$ + "nooonkoook_ooo_onooooooonIVDokWIBmoooooooKokoo_m_oooeknooKokoo_m_ooofonooKokoo_m_oooeknooG_kooOm^ooo"
            A$ = A$ + "eknooG_koo_m_ooofonooKokoo_m_ooofonooooookWIBm_OV9eooooooo_lYooobWnoo;Ojoo_lYooobWnoo;Ojoo_lYooobWno"
            A$ = A$ + "o;Ojoo_lYooobWnoo;Ojoo_lYooobWnoo;Ojoo_lYooobWnoo;Ojoooooo_OV9eonIVDoooooooo_Cnooo^hoookRooo_Cnooo^h"
            A$ = A$ + "oookRooo_;nooo^hoookTooo_;nooo^hoookTooo_;nooo^hoookRooo_;nooo^hoookRooooooonIVDokWIBmoooooooSneoo?j"
            A$ = A$ + "GoooWGmooSneoooiEoooWGmooSneoo?jGoooXOmooSneoooiEoooXOmooONeoooiEoooXOmooSneoooiEoooXOmooooookWIBm_O"
            A$ = A$ + "V9eooooooS?h<o?nPcloh3>coWOh=oOnQgloi7NcoWOh=o?nPcloh3>coS?h<o?nPcloi7NcoWOh=oOnQgloi7NcoS?h<o?nPclo"
            A$ = A$ + "i7Ncoooooo_OV9eonIVDoooooo?lHClo`S=ao3?f4o?lHClo`S=ao3?f4oOlIGlo`S=ao3?f4o?lHClo`S=ao3?f4o?lHClo`S=a"
            A$ = A$ + "o7Of5o?lHClo`S=ao3?f4ooooooonIVDokWIBmooooooZ;]_oWNdmn_jBkkoY7M_oWNdmn_jBkkoZ;]_o[^dnn_jBkkoY7M_o[^d"
            A$ = A$ + "nnOjAgkoY7M_o[^dnn_jBkkoZ;]_o[^dnn_jBkkooooookWIBm_OV9eooooooOncknoi?_koWol^oOncknoi?_koWol^oOncknoi"
            A$ = A$ + "?_koWol^oOncknoi?_koWol^oOncknoi?_koWol^oOncknoi?_koWol^oooooo_OV9eonIVDooooooOjAgkoY7M_oWNdmnOjAgko"
            A$ = A$ + "Y7M_oWNdmnOjAgkoY7M_oWNdmnOjAgkoY7M_oWNdmnOjAgkoY7M_oWNdmnOjAgkoY7M_oWNdmnoooooonIVDokWIBmomO_loQWL]"
            A$ = A$ + "o7NbenOh9GkoQWL]o7NbenOh9GkoQWL]o7NbenOh9GkoQWL]o7NbenOh9GkoQWL]o7NbenOh9GkoQWL]o7NbenOh9GkogombokWI"
            A$ = A$ + "Bmog7?konIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_O"
            A$ = A$ + "V9eonIVDokWIBmog7?koogngooOkOooo]omoogngooOkOooo]omoogngooOkOooo]omoogngooOkOooo]omoogngooOkOooo]omo"
            A$ = A$ + "ogngooOkOooo]omoogngooOkOooo]omoogngoS>dln_H:IcoRYT=o;VBfl_H:IcoRYT=o;VBfl_H:IcoRYT=o;VBfl_H:IcoRYT="
            A$ = A$ + "o;VBfl_H:IcoRYT=o;VBfl_H:IcoRYT=o;VBfl_H:IcoRYT=oWM`]n_H:Icodc=booombooog;oooO_looombooog;oooO_looom"
            A$ = A$ + "booog;oooO_looombooog;oooO_looombooog;oooO_looombooog;oooO_loC?g8o_H:IcoRYT=oooooooh;OkoS_l]o?nbgnoh"
            A$ = A$ + ";OkoS_l]o?nbgnoh;OkoS_l]o?nbgnoh;OkoS_l]o?nbgnoh;OkoS_l]o?nbgnoh;OkoS_l]o?nbgnooooooRYT=o;VBfloooooo"
            A$ = A$ + "X3=_oS>dln?j@ckoX3=_oS>dln?j@ckoX3=_oS>dln?j@ckoX3=_oS>dln?j@ckoX3=_oS>dln?j@ckoX3=_oS>dln?j@ckooooo"
            A$ = A$ + "o;VBfl_H:IcooooooWNdmn?j@ckoY7M_oS>dln?j@ckoY7M_oS>dlnOjAgkoY7M_oS>dlnOjAgkoX3=_oS>dlnOjAgkoX3=_oWNd"
            A$ = A$ + "mnOjAgkoY7M_oooooo_H:IcoRYT=oooooo?lHClo`S=ao3?f4o?lHClo`S=ao7Of5oOlIGlo`S=ao3?f4o?lHClo`S=ao3?f4o?l"
            A$ = A$ + "HCloaWMao7Of5o?lHClo`S=ao3?f4oooooooRYT=o;VBfloooooolC>doc?i@oonSololC>doc?i@o?oT3molC>doc?i@o?oT3mo"
            A$ = A$ + "lC>do_oh?o?oT3molC>doc?i@o?oT3molC>do_oh?o?oT3moooooo;VBfl_H:Icooooooo_kQooo]omoogngoo_kQooo]omoogng"
            A$ = A$ + "ooOkOooo]omookNhooOkOooo]omookNhooOkOooo]omoogngooOkOooo]omoogngoooooo_H:IcoRYT=oooooooobWnoo;Ojoo_l"
            A$ = A$ + "YooobWnoo;Ojoo_lYooobWnoo;Ojoo_lYooobWnoo;Ojoo_lYooobWnoo;Ojoo_lYooobWnoo;Ojoo_lYoooooooRYT=o;VBfloo"
            A$ = A$ + "oooooOOlooomaooog7oooOOlooomaooog7oooOOlooombooog7oooOOlooomaooog7oooOOlooomaooog;oooOOlooombooog7oo"
            A$ = A$ + "ooooo;VBfl_H:IcoooooooOolooomcooog?oooOolooomcooog?oooOolooomcooog?oooOolooomcooog?oooOolooomcooog?o"
            A$ = A$ + "ooOolooomcoooconoooooo_H:IcoRYT=oc<]Pnoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooo?cd2joRYT=o;VBfl_H:Ico<C;Xoc<]Pn?cd2jo<C;Xoc<]Pn?cd2jo<C;Xoc<]Pn?c"
            A$ = A$ + "d2jo<C;Xoc<]Pn?cd2jo<C;Xoc<]Pn?cd2jo<C;Xoc<]Pn?cd2joRYT=o;VBfl?f0cjoRYT=o;VBfl_H:IcoRYT=o;VBfl_H:Ico"
            A$ = A$ + "RYT=o;VBfl_H:IcoRYT=o;VBfl_H:IcoRYT=o;VBfl_H:IcoRYT=o;VBfl_H:IcoRYT=o;VBfl_djJjoogngooOkOooo]omoogng"
            A$ = A$ + "ooOkOooo]omoogngooOkOooo]omoogngooOkOooo]omoogngooOkOooo]omoogngooOkOooo]omoogngooOkOooo]omoogngooon"
            A$ = A$ + "iooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooWol^ooolZooooooooOOlooOlWo_oV;mooONeoooiCo_oV;mooONeoooiCo_oV;mooONeoooiCo_oV;mooONeoooiEoooWGmo"
            A$ = A$ + "oW>foo_jJoooZ[moo;Ojoooooooh;OkoooooooOlWooog7oooo>ioo?lUooo`Gnooo>ioo?lUooo`Gnooo>ioo?lUooo`Gnooo>i"
            A$ = A$ + "oo?lUooo`Gnooo>ioo?lUooo`Gnooo>iogOiAoooooooK?l[oooooooo^7nooG_koo?lUoooaOnoo3Oioo?lUoooaOnoo3Oioo?l"
            A$ = A$ + "UoooaOnoo3Oioo?lUoooaOnoo3Oioo?lUoooaOnoo3Oioo?lUo_oV;moooooo[]`^nooooooocNgooolZooo`Gnoo3Oioo?lUooo"
            A$ = A$ + "`Gnoo3Oioo?lUooo`Gnoo3Oioo?lUooo`Gnoo3Oioo?lUooo`Gnoo3Oioo?lUooo`GnonK^dooooooOf1gjooooooo_jJooobWno"
            A$ = A$ + "oo>ioookTooo_Cnooo>ioookTooo_Cnooo>ioookTooo_Cnooo>ioookTooo_Cnooo>ioookTooo_Cnooo>iok_iBoooooooI7L["
            A$ = A$ + "ooooooooYSmoo7oioookTooo^7nookNhoookTooo^7nookNhoookTooo^7nookNhoookTooo^7nookNhoookTooo^7nookNhoook"
            A$ = A$ + "To_oV;mooooooWM`]noooooooONeooOlWooo^7noogngoo_kQooo^7noogngoo_kQooo^7noogngoo_kQooo^7noogngoo_kQooo"
            A$ = A$ + "^7noogngoo_kQooo^7nonK^doooooo_f2kjooooooooiEoooaOnoo_>gooojLooo[cmoo_>gooojLooo[cmoo_>gooojLooo[cmo"
            A$ = A$ + "o_>gooojLooo[cmoo_>gooojLooo[cmoo_>gok_iBoooooooJ;\[oooooo_oV;mookNhooOjHoooZ[moo[^fooOjHoooZ[moo[^f"
            A$ = A$ + "ooOjHoooZ[moo[^fooOjHoooZ[moo[^fooOjHoooZ[moo[^fooOjHoOoU7moooooo_m`_noooooolC>dooojLoooYSmoo[^fooOj"
            A$ = A$ + "HoooYSmoo[^fooOjHoooYSmoo[^fooOjHoooYSmoo[^fooOjHoooYSmoo[^fooOjHoooYSmok?ncooooooOg57koooooooolZo_o"
            A$ = A$ + "V;monK^doooiCo_oV;monK^doooiCo_oV;monK^doooiCo_oV;monK^doooiCo_oV;monK^doooiCo_oV;monK^dooOlWooooooo"
            A$ = A$ + "Vk\^oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooo`S=aooOm^ooo\gmooSneo;_f6o_h:KkoR[\]o;^bfn_h:KkoR[\]o;^bfn_h:KkoR[\]o;^bfn_h:KkoR[\]o;^b"
            A$ = A$ + "fn_h:KkoR[\]o;^bfn_h:Kko[?m_oo?kMooo\gmo%%%0"
        CASE "scrollhtrack.bmp"
            A$ = MKI$(17) + MKI$(68)
            A$ = A$ + "oW>fooOjHoooYSmooW>fooOjHoooYSmooW>fooOjHoooYSmooW>fooOjHoooYSmooW>fooOjHoooYSmooW>fooOjHooo_Cnooo>i"
            A$ = A$ + "oookTooo_Cnooo>ioookTooo_Cnooo>ioookTooo_Cnooo>ioookTooo_Cnooo>ioookTooo_Cnooo>ioo?lUooo`Gnoo3Oioo?l"
            A$ = A$ + "Uooo`Gnoo3Oioo?lUooo`Gnoo3Oioo?lUooo`Gnoo3Oioo?lUooo`Gnoo3Oioo?lUooo`Gnoo3Oioo?lUooo`Gnoo3Oioo?lUooo"
            A$ = A$ + "`Gnoo3Oioo?lUooo`Gnoo3Oioo?lUooo`Gnoo3Oioo?lUooo`Gnoo3Oioo?lUoooaOnoo7oiooOlWoooaOnoo7oiooOlWoooaOno"
            A$ = A$ + "o7oiooOlWoooaOnoo7oiooOlWoooaOnoo7oiooOlWoooaOnoo7oioo_lYooobWnoo;Ojoo_lYooobWnoo;Ojoo_lYooobWnoo;Oj"
            A$ = A$ + "oo_lYooobWnoo;Ojoo_lYooobWnoo;Ojoo_lYooobWnooC?koo?m\ooodcnooC?koo?m\ooodcnooC?koo?m\ooodcnooC?koo?m"
            A$ = A$ + "\ooodcnooC?koo?m\ooodcnooC?koo?m\ooofonooKokoo_m_ooofonooKokoo_m_ooofonooKokoo_m_ooofonooKokoo_m_ooo"
            A$ = A$ + "fonooKokoo_m_ooofonooKokooombooog;oooO_looombooog;oooO_looombooog;oooO_looombooog;oooO_looombooog;oo"
            A$ = A$ + "oO_looombooog;oooS?moo?ndooohCoooS?moo?ndooohCoooS?moo?ndooohCoooS?moo?ndooohCoooS?moo?ndooohCoooS?m"
            A$ = A$ + "oo?ndoooiKoooW_mooOnfoooiKoooW_mooOnfoooiKoooW_mooOnfoooiKoooW_mooOnfoooiKoooW_mooOnfoooiKoooW_mooOn"
            A$ = A$ + "foooiKoooW_mooOnfoooiKoooW_mooOnfoooiKoooW_mooOnfoooiKoooW_mooOnfoooiKoooW_mooOnfoooiKooo[omoo_ngooo"
            A$ = A$ + "jOooo[omoo_ngooojOooo[omoo_ngooojOooo[omoo_ngooojOooo[omoo_ngooojOooo[omoo_ngoookWooo_OnooonioookWoo"
            A$ = A$ + "o_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_On"
            A$ = A$ + "ooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_Onooon"
            A$ = A$ + "ioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioooYSmooW>fooOjHoooYSmooW>fooOjHoooYSmooW>fooOjHooo"
            A$ = A$ + "YSmooW>fooOjHoooYSmooW>fooOjHoooYSmooW>fooOjHoooYSmooW>fooOjHoooYSmooW>fooOjHoooYSmooW>fooOjHoooYSmo"
            A$ = A$ + "oW>fooOjHoooYSmooW>fooOjHoooYSmooo>ioookTooo_Cnooo>ioookTooo_Cnooo>ioookTooo_Cnooo>ioookTooo_Cnooo>i"
            A$ = A$ + "oookTooo_Cnooo>ioookTooo`Gnoo3Oioo?lUooo`Gnoo3Oioo?lUooo`Gnoo3Oioo?lUooo`Gnoo3Oioo?lUooo`Gnoo3Oioo?l"
            A$ = A$ + "Uooo`Gnoo3Oioo?lUooo`Gnoo3Oioo?lUooo`Gnoo3Oioo?lUooo`Gnoo3Oioo?lUooo`Gnoo3Oioo?lUooo`Gnoo3Oioo?lUooo"
            A$ = A$ + "`Gnoo7oiooOlWoooaOnoo7oiooOlWoooaOnoo7oiooOlWoooaOnoo7oiooOlWoooaOnoo7oiooOlWoooaOnoo7oiooOlWooobWno"
            A$ = A$ + "o;Ojoo_lYooobWnoo;Ojoo_lYooobWnoo;Ojoo_lYooobWnoo;Ojoo_lYooobWnoo;Ojoo_lYooobWnoo;Ojoo?m\ooodcnooC?k"
            A$ = A$ + "oo?m\ooodcnooC?koo?m\ooodcnooC?koo?m\ooodcnooC?koo?m\ooodcnooC?koo?m\ooodcnooKokoo_m_ooofonooKokoo_m"
            A$ = A$ + "_ooofonooKokoo_m_ooofonooKokoo_m_ooofonooKokoo_m_ooofonooKokoo_m_ooog;oooO_looombooog;oooO_looombooo"
            A$ = A$ + "g;oooO_looombooog;oooO_looombooog;oooO_looombooog;oooO_loo?ndooohCoooS?moo?ndooohCoooS?moo?ndooohCoo"
            A$ = A$ + "oS?moo?ndooohCoooS?moo?ndooohCoooS?moo?ndooohCoooW_mooOnfoooiKoooW_mooOnfoooiKoooW_mooOnfoooiKoooW_m"
            A$ = A$ + "ooOnfoooiKoooW_mooOnfoooiKoooW_mooOnfoooiKoooW_mooOnfoooiKoooW_mooOnfoooiKoooW_mooOnfoooiKoooW_mooOn"
            A$ = A$ + "foooiKoooW_mooOnfoooiKoooW_moo_ngooojOooo[omoo_ngooojOooo[omoo_ngooojOooo[omoo_ngooojOooo[omoo_ngooo"
            A$ = A$ + "jOooo[omoo_ngooojOooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWoo"
            A$ = A$ + "o_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_On"
            A$ = A$ + "ooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWoooW>fooOj"
            A$ = A$ + "HoooYSmooW>fooOjHoooYSmooW>fooOjHoooYSmooW>fooOjHoooYSmooW>fooOjHoooYSmooW>fooOjHo?h8CkoPS<]o3>bdn?h"
            A$ = A$ + "8CkoPS<]o3>bdn?h8CkoPS<]o3>bdn?h8CkoPS<]o3>bdn?h8CkoPS<]o3>bdn?h8CkoPS<]o;_f6o_lJKlob[]ao;_f6o_lJKlo"
            A$ = A$ + "b[]ao;_f6o_lJKlob[]ao;_f6o_lJKlob[]ao;_f6o_lJKlob[]ao;_f6o_lJKlodc=boC?g8o?mLSlodc=boC?g8o?mLSlodc=b"
            A$ = A$ + "oC?g8o?mLSlodc=boC?g8o?mLSlodc=boC?g8o?mLSlodc=boC?g8o?mLSlodc=boC?g8o?mLSlodc=boC?g8o?mLSlodc=boC?g"
            A$ = A$ + "8o?mLSlodc=boC?g8o?mLSlodc=boC?g8o?mLSlodc=boS?h<o?nPcloh3>coS?h<o?nPcloh3>coS?h<o?nPcloh3>coS?h<o?n"
            A$ = A$ + "Pcloh3>coS?h<o?nPcloh3>coS?h<o?nPcloi7NcoWOh=oOnQgloi7NcoWOh=oOnQgloi7NcoWOh=oOnQgloi7NcoWOh=oOnQglo"
            A$ = A$ + "i7NcoWOh=oOnQgloi7NcoWOh=oooW?mooOndoooiCoooW?mooOndoooiCoooW?mooOndoooiCoooW?mooOndoooiCoooW?mooOnd"
            A$ = A$ + "oooiCoooW?mooOndooOjHoooYSmooW>fooOjHoooYSmooW>fooOjHoooYSmooW>fooOjHoooYSmooW>fooOjHoooYSmooW>fooOj"
            A$ = A$ + "HoooYSmooo^hoookRooo_;nooo^hoookRooo_;nooo^hoookRooo_;nooo^hoookRooo_;nooo^hoookRooo_;nooo^hoookRooo"
            A$ = A$ + "aOnoo7oiooOlWoooaOnoo7oiooOlWoooaOnoo7oiooOlWoooaOnoo7oiooOlWoooaOnoo7oiooOlWoooaOnoo7oiooolZoooc[no"
            A$ = A$ + "o?_jooolZoooc[noo?_jooolZoooc[noo?_jooolZoooc[noo?_jooolZoooc[noo?_jooolZoooc[noo?_jooolZoooc[noo?_j"
            A$ = A$ + "ooolZoooc[noo?_jooolZoooc[noo?_jooolZoooc[noo?_jooolZoooc[noo?_jooolZoooeknooG_kooOm^oooeknooG_kooOm"
            A$ = A$ + "^oooeknooG_kooOm^oooeknooG_kooOm^oooeknooG_kooOm^oooeknooG_kooombooog;oooO_looombooog;oooO_looombooo"
            A$ = A$ + "g;oooO_looombooog;oooO_looombooog;oooO_looombooog;oooO_looombooog;oooO_looombooog;oooO_looombooog;oo"
            A$ = A$ + "oO_looombooog;oooO_looombooog;oooO_looombooog;oooO_looombooog;oooO_looombooog;oooO_looombooog;oooO_l"
            A$ = A$ + "ooombooog;oooO_looombooog;oooO_lo3>bdn?h8CkoPS<]o3>bdn?h8CkoPS<]o3>bdn?h8CkoPS<]o3>bdn?h8CkoPS<]o3>b"
            A$ = A$ + "dn?h8CkoPS<]o3>bdn?h8CkooW>fooOjHoooYSmooW>fooOjHoooYSmooW>fooOjHoooYSmooW>fooOjHoooYSmooW>fooOjHooo"
            A$ = A$ + "YSmooW>fooOjHooo_Cnooo>ioookTooo_Cnooo>ioookTooo_Cnooo>ioookTooo_Cnooo>ioookTooo_Cnooo>ioookTooo_Cno"
            A$ = A$ + "oo>ioo?lUooo`Gnoo3Oioo?lUooo`Gnoo3Oioo?lUooo`Gnoo3Oioo?lUooo`Gnoo3Oioo?lUooo`Gnoo3Oioo?lUooo`Gnoo3Oi"
            A$ = A$ + "oo?lUooo`Gnoo3Oioo?lUooo`Gnoo3Oioo?lUooo`Gnoo3Oioo?lUooo`Gnoo3Oioo?lUooo`Gnoo3Oioo?lUoooaOnoo7oiooOl"
            A$ = A$ + "WoooaOnoo7oiooOlWoooaOnoo7oiooOlWoooaOnoo7oiooOlWoooaOnoo7oiooOlWoooaOnoo7oioo_lYooobWnoo;Ojoo_lYooo"
            A$ = A$ + "bWnoo;Ojoo_lYooobWnoo;Ojoo_lYooobWnoo;Ojoo_lYooobWnoo;Ojoo_lYooobWnooC?koo?m\ooodcnooC?koo?m\ooodcno"
            A$ = A$ + "oC?koo?m\ooodcnooC?koo?m\ooodcnooC?koo?m\ooodcnooC?koo?m\ooofonooKokoo_m_ooofonooKokoo_m_ooofonooKok"
            A$ = A$ + "oo_m_ooofonooKokoo_m_ooofonooKokoo_m_ooofonooKokooombooog;oooO_looombooog;oooO_looombooog;oooO_looom"
            A$ = A$ + "booog;oooO_looombooog;oooO_looombooog;oooS?moo?ndooohCoooS?moo?ndooohCoooS?moo?ndooohCoooS?moo?ndooo"
            A$ = A$ + "hCoooS?moo?ndooohCoooS?moo?ndoooiKoooW_mooOnfoooiKoooW_mooOnfoooiKoooW_mooOnfoooiKoooW_mooOnfoooiKoo"
            A$ = A$ + "oW_mooOnfoooiKoooW_mooOnfoooiKoooW_mooOnfoooiKoooW_mooOnfoooiKoooW_mooOnfoooiKoooW_mooOnfoooiKoooW_m"
            A$ = A$ + "ooOnfoooiKooo[omoo_ngooojOooo[omoo_ngooojOooo[omoo_ngooojOooo[omoo_ngooojOooo[omoo_ngooojOooo[omoo_n"
            A$ = A$ + "goookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_Onoooniooo"
            A$ = A$ + "kWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWoo"
            A$ = A$ + "o_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioooYSmooW>fooOjHoooYSmooW>f"
            A$ = A$ + "ooOjHoooYSmooW>fooOjHoooYSmooW>fooOjHoooYSmooW>fooOjHoooYSmooW>f%%o3"
        CASE "menucheckmark.bmp"
            A$ = MKI$(7) + MKI$(21)
            A$ = A$ + "o3`ooo?0oooo0looo3`ooo?0oooo0loo0000oo?0oooo0looo3`ooo?0oooo0loo0000o3000l?000`oo3`ooo?0oooo0loo0000"
            A$ = A$ + "o3000l?000`o0000o3000loo0loo0000o3000l?000`oo3`oo3000l?000`o0000o3000l?000`oo3`ooo?0oooo0loo0000o300"
            A$ = A$ + "0l?000`oo3`ooo?0oooo0looo3`ooo?0oo?000`oo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooooooooo"
            A$ = A$ + "0looo3`ooo?0oooo0looo3`ooooooooooooooooooo?0oooo0looo3`oooooooooooooooooooooooooooooo3`ooooooooooooo"
            A$ = A$ + "oooooo?0oooooooooooooooooooooooooooooo?0oooo0looo3`ooooooooooooooooooo?0oooo0looo3`ooo?0oooo0loooooo"
            A$ = A$ + "oo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oo_ZVNjoo3`ooo?0oooo0looo3`ooo?0oo_ZVNjoZJjYo[ZY"
            A$ = A$ + "Wnoo0looo3`ooo?0oo_ZVNjoZJjYo[ZYWn_ZVNjoZJjYoo?0oo_ZVNjoZJjYo[ZYWnoo0looZJjYo[ZYWn_ZVNjoZJjYo[ZYWnoo"
            A$ = A$ + "0looo3`ooo?0oo_ZVNjoZJjYo[ZYWnoo0looo3`ooo?0oooo0looo3`oo[ZYWnoo0looo3`ooo?0oooo0loo%%%0"
        CASE "slidertrack.png"
            A$ = MKI$(5) + MKI$(5)
            A$ = A$ + "EcMgoc;`0oOVLfiodS?nok>meoO[a:ko7g\coWNlboOlfOoog[_noCiUHn?i[cnoY7_lo[^lco_onkooIb9WoG]eFo?h]3ooaKom"
            A$ = A$ + "oO_njoocCCmom:l`oooooo?mhSoo^COm%%o3"
        CASE "frame.png"
            A$ = MKI$(22) + MKI$(20)
            A$ = A$ + "o3`ooo?0ooOfEKmoIG]eoWMeFoOfEKmoIG]eoWMeFoOfEKmoIG]eoWMeFoOfEKmoIG]eoWMeFoOfEKmoIG]eoWMeFoOfEKmoIG]e"
            A$ = A$ + "ooKdAooo0looo3`ooo?0ooOfEKmoIG]eoo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0"
            A$ = A$ + "oooo0looo3`ooo?0oo?aC?moIG]eoo?0ooOfEKmoIG]eoo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo"
            A$ = A$ + "0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooGldCoOfEKmoIG]eoo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0loo"
            A$ = A$ + "o3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo6MdoWMeFooo0looo3`ooo?0oooo0looo3`o"
            A$ = A$ + "oo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooWMeFoOfEKmoo3`ooo?0"
            A$ = A$ + "oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0ooOf"
            A$ = A$ + "EKmoIG]eoo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0loo"
            A$ = A$ + "o3`ooo?0oooo0looIG]eoWMeFooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`o"
            A$ = A$ + "oo?0oooo0looo3`ooo?0oooo0looo3`ooWMeFoOfEKmoo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0"
            A$ = A$ + "oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0ooOfEKmoIG]eoo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo"
            A$ = A$ + "0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looIG]eoWMeFooo0looo3`ooo?0oooo0loo"
            A$ = A$ + "o3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooWMeFoOfEKmoo3`o"
            A$ = A$ + "oo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0"
            A$ = A$ + "ooOfEKmoIG]eoo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo"
            A$ = A$ + "0looo3`ooo?0oooo0looIG]eoWMeFooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0loo"
            A$ = A$ + "o3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooWMeFoOfEKmoo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`o"
            A$ = A$ + "oo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0ooOfEKmoIG]eoo?0oooo0looo3`ooo?0oooo0looo3`ooo?0"
            A$ = A$ + "oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looIG]eoWMeFooo0looo3`ooo?0oooo"
            A$ = A$ + "0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`oooKdAoOfEKmo"
            A$ = A$ + "IG]eoo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`o"
            A$ = A$ + "oGldCoOfEKmoo3`ooWMeFoOfEKmoo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0"
            A$ = A$ + "oooo0looo3`ooCldCoOfEKmoo3`ooo?0oooo0looIG]eoWMeFoOfEKmoIG]eoWMeFoOfEKmoIG]eoWMeFoOfEKmoIG]eoWMeFoOf"
            A$ = A$ + "EKmoIG]eoWMeFoOfEKmoIG]eoWMeFoo_A7moo3`ooo?0%oo?"
        CASE "arrows.png"
            A$ = MKI$(9) + MKI$(144)
            A$ = A$ + "o3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`oo?7IKmoo0looo3`ooo?0oooo0looo3`o"
            A$ = A$ + "oo?0oooo0loocAfFo?7IKmoLT]eoo3`ooo?0oooo0looo3`ooo?0oooLT]eocAfFo?7IKmoLT]eocAfFoo?0oooo0looo3`oo?7I"
            A$ = A$ + "KmoLT]eocAfFoo?0oooLT]eocAfFo?7IKmoo0loocAfFo?7IKmoLT]eoo3`ooo?0oooo0loocAfFo?7IKmoLT]eoo3`oo?7IKmoo"
            A$ = A$ + "0looo3`ooo?0oooo0looo3`oo?7IKmoo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0loo"
            A$ = A$ + "o3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`o"
            A$ = A$ + "oChN[moo0looo3`ooo?0oooo0looo3`ooo?0oooo0loo4^gJoChN[m?Qk]foo3`ooo?0oooo0looo3`ooo?0oo?Qk]fo4^gJoChN"
            A$ = A$ + "[m?Qk]fo4^gJoo?0oooo0looo3`ooChN[m?Qk]fo4^gJoo?0oo?Qk]fo4^gJoChN[moo0loo4^gJoChN[m?Qk]foo3`ooo?0oooo"
            A$ = A$ + "0loo4^gJoChN[m?Qk]foo3`ooChN[moo0looo3`ooo?0oooo0looo3`ooChN[moo0looo3`ooo?0oooo0looo3`ooo?0oooo0loo"
            A$ = A$ + "o3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`o"
            A$ = A$ + "oo?0oooo0looo3`ooo?0oooo0looo3`ooChN[moo0looo3`ooo?0oooo0looo3`ooo?0oooo0loo4^gJoChN[m?Qk]foo3`ooo?0"
            A$ = A$ + "oooo0looo3`ooo?0oo?Qk]fo4^gJoChN[m?Qk]fo4^gJoo?0oooo0looo3`ooChN[m?Qk]fo4^gJoo?0oo?Qk]fo4^gJoChN[moo"
            A$ = A$ + "0loo4^gJoChN[m?Qk]foo3`ooo?0oooo0loo4^gJoChN[m?Qk]foo3`ooChN[moo0looo3`ooo?0oooo0looo3`ooChN[moo0loo"
            A$ = A$ + "o3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`o"
            A$ = A$ + "oo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`oo?nbgnoo0looo3`ooo?0oooo0looo3`ooo?0"
            A$ = A$ + "oooo0looS_l]o?nbgnoh;Okoo3`ooo?0oooo0looo3`ooo?0oooh;OkoS_l]o?nbgnoh;OkoS_l]oo?0oooo0looo3`oo?nbgnoh"
            A$ = A$ + ";OkoS_l]oo?0oooh;OkoS_l]o?nbgnoo0looS_l]o?nbgnoh;Okoo3`ooo?0oooo0looS_l]o?nbgnoh;Okoo3`oo?nbgnoo0loo"
            A$ = A$ + "o3`ooo?0oooo0looo3`oo?nbgnoo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`o"
            A$ = A$ + "oo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0"
            A$ = A$ + "oooo0looo3`ooo?0oooo0looo3`oo?7IKmoo0looo3`ooo?0oooo0looo3`oo?7IKmoo0loocAfFo?7IKmoLT]eoo3`ooo?0oooo"
            A$ = A$ + "0loocAfFo?7IKmoLT]eoo3`oo?7IKmoLT]eocAfFoo?0oooLT]eocAfFo?7IKmoo0looo3`ooo?0oooLT]eocAfFo?7IKmoLT]eo"
            A$ = A$ + "cAfFoo?0oooo0looo3`ooo?0oooo0loocAfFo?7IKmoLT]eoo3`ooo?0oooo0looo3`ooo?0oooo0looo3`oo?7IKmoo0looo3`o"
            A$ = A$ + "oo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0"
            A$ = A$ + "oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooChN[moo0looo3`ooo?0oooo0looo3`ooChN[moo"
            A$ = A$ + "0loo4^gJoChN[m?Qk]foo3`ooo?0oooo0loo4^gJoChN[m?Qk]foo3`ooChN[m?Qk]fo4^gJoo?0oo?Qk]fo4^gJoChN[moo0loo"
            A$ = A$ + "o3`ooo?0oo?Qk]fo4^gJoChN[m?Qk]fo4^gJoo?0oooo0looo3`ooo?0oooo0loo4^gJoChN[m?Qk]foo3`ooo?0oooo0looo3`o"
            A$ = A$ + "oo?0oooo0looo3`ooChN[moo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0"
            A$ = A$ + "oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooChN[moo"
            A$ = A$ + "0looo3`ooo?0oooo0looo3`ooChN[moo0loo4^gJoChN[m?Qk]foo3`ooo?0oooo0loo4^gJoChN[m?Qk]foo3`ooChN[m?Qk]fo"
            A$ = A$ + "4^gJoo?0oo?Qk]fo4^gJoChN[moo0looo3`ooo?0oo?Qk]fo4^gJoChN[m?Qk]fo4^gJoo?0oooo0looo3`ooo?0oooo0loo4^gJ"
            A$ = A$ + "oChN[m?Qk]foo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooChN[moo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0"
            A$ = A$ + "oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo"
            A$ = A$ + "0looo3`ooo?0oooo0looo3`oo?nbgnoo0looo3`ooo?0oooo0looo3`oo?nbgnoo0looS_l]o?nbgnoh;Okoo3`ooo?0oooo0loo"
            A$ = A$ + "S_l]o?nbgnoh;Okoo3`oo?nbgnoh;OkoS_l]oo?0oooh;OkoS_l]o?nbgnoo0looo3`ooo?0oooh;OkoS_l]o?nbgnoh;OkoS_l]"
            A$ = A$ + "oo?0oooo0looo3`ooo?0oooo0looS_l]o?nbgnoh;Okoo3`ooo?0oooo0looo3`ooo?0oooo0looo3`oo?nbgnoo0looo3`ooo?0"
            A$ = A$ + "oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`oo?7IKmoo0looo3`ooo?0oooo"
            A$ = A$ + "0looo3`ooo?0oooo0loocAfFo?7IKmoLT]eoo3`ooo?0oooo0looo3`ooo?0oooLT]eocAfFo?7IKmoo0looo3`ooo?0oooo0loo"
            A$ = A$ + "o3`oo?7IKmoLT]eocAfFoo?0oooo0looo3`ooo?0oooo0loocAfFo?7IKmoLT]eoo3`ooo?0oooo0looo3`ooo?0oooo0looo3`o"
            A$ = A$ + "o?7IKmoLT]eocAfFoo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooLT]eocAfFo?7IKmoo0looo3`ooo?0oooo0looo3`ooo?0"
            A$ = A$ + "oooo0loocAfFo?7IKmoLT]eoo3`ooo?0oooo0looo3`ooo?0oooo0looo3`oo?7IKmoo0looo3`ooo?0oooo0looo3`ooo?0oooo"
            A$ = A$ + "0looo3`ooChN[moo0looo3`ooo?0oooo0looo3`ooo?0oooo0loo4^gJoChN[m?Qk]foo3`ooo?0oooo0looo3`ooo?0oo?Qk]fo"
            A$ = A$ + "4^gJoChN[moo0looo3`ooo?0oooo0looo3`ooChN[m?Qk]fo4^gJoo?0oooo0looo3`ooo?0oooo0loo4^gJoChN[m?Qk]foo3`o"
            A$ = A$ + "oo?0oooo0looo3`ooo?0oooo0looo3`ooChN[m?Qk]fo4^gJoo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oo?Qk]fo4^gJoChN"
            A$ = A$ + "[moo0looo3`ooo?0oooo0looo3`ooo?0oooo0loo4^gJoChN[m?Qk]foo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooChN[moo"
            A$ = A$ + "0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooChN[moo0looo3`ooo?0oooo0looo3`ooo?0oooo0loo4^gJoChN[m?Qk]fo"
            A$ = A$ + "o3`ooo?0oooo0looo3`ooo?0oo?Qk]fo4^gJoChN[moo0looo3`ooo?0oooo0looo3`ooChN[m?Qk]fo4^gJoo?0oooo0looo3`o"
            A$ = A$ + "oo?0oooo0loo4^gJoChN[m?Qk]foo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooChN[m?Qk]fo4^gJoo?0oooo0looo3`ooo?0"
            A$ = A$ + "oooo0looo3`ooo?0oo?Qk]fo4^gJoChN[moo0looo3`ooo?0oooo0looo3`ooo?0oooo0loo4^gJoChN[m?Qk]foo3`ooo?0oooo"
            A$ = A$ + "0looo3`ooo?0oooo0looo3`ooChN[moo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`oo?nbgnoo0looo3`ooo?0oooo0loo"
            A$ = A$ + "o3`ooo?0oooo0looS_l]o?nbgnoh;Okoo3`ooo?0oooo0looo3`ooo?0oooh;OkoS_l]o?nbgnoo0looo3`ooo?0oooo0looo3`o"
            A$ = A$ + "o?nbgnoh;OkoS_l]oo?0oooo0looo3`ooo?0oooo0looS_l]o?nbgnoh;Okoo3`ooo?0oooo0looo3`ooo?0oooo0looo3`oo?nb"
            A$ = A$ + "gnoh;OkoS_l]oo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooh;OkoS_l]o?nbgnoo0looo3`ooo?0oooo0looo3`ooo?0oooo"
            A$ = A$ + "0looS_l]o?nbgnoh;Okoo3`ooo?0oooo0looo3`ooo?0oooo0looo3`oo?nbgnoo0looo3`ooo?0oooo0looo3`ooo?0oooo0loo"
            A$ = A$ + "cAfFoo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooLT]eocAfFo?7IKmoo0looo3`ooo?0oooo0looo3`ooo?0oooo0loocAfF"
            A$ = A$ + "o?7IKmoLT]eoo3`ooo?0oooo0looo3`ooo?0oooo0looo3`oo?7IKmoLT]eocAfFoo?0oooo0looo3`ooo?0oooo0looo3`ooo?0"
            A$ = A$ + "oooLT]eocAfFo?7IKmoo0looo3`ooo?0oooo0looo3`oo?7IKmoLT]eocAfFoo?0oooo0looo3`ooo?0oooo0loocAfFo?7IKmoL"
            A$ = A$ + "T]eoo3`ooo?0oooo0looo3`ooo?0oooLT]eocAfFo?7IKmoo0looo3`ooo?0oooo0looo3`ooo?0oooo0loocAfFoo?0oooo0loo"
            A$ = A$ + "o3`ooo?0oooo0looo3`ooo?0oooo0loo4^gJoo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oo?Qk]fo4^gJoChN[moo0looo3`o"
            A$ = A$ + "oo?0oooo0looo3`ooo?0oooo0loo4^gJoChN[m?Qk]foo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooChN[m?Qk]fo4^gJoo?0"
            A$ = A$ + "oooo0looo3`ooo?0oooo0looo3`ooo?0oo?Qk]fo4^gJoChN[moo0looo3`ooo?0oooo0looo3`ooChN[m?Qk]fo4^gJoo?0oooo"
            A$ = A$ + "0looo3`ooo?0oooo0loo4^gJoChN[m?Qk]foo3`ooo?0oooo0looo3`ooo?0oo?Qk]fo4^gJoChN[moo0looo3`ooo?0oooo0loo"
            A$ = A$ + "o3`ooo?0oooo0loo4^gJoo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0loo4^gJoo?0oooo0looo3`ooo?0oooo0looo3`o"
            A$ = A$ + "oo?0oo?Qk]fo4^gJoChN[moo0looo3`ooo?0oooo0looo3`ooo?0oooo0loo4^gJoChN[m?Qk]foo3`ooo?0oooo0looo3`ooo?0"
            A$ = A$ + "oooo0looo3`ooChN[m?Qk]fo4^gJoo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oo?Qk]fo4^gJoChN[moo0looo3`ooo?0oooo"
            A$ = A$ + "0looo3`ooChN[m?Qk]fo4^gJoo?0oooo0looo3`ooo?0oooo0loo4^gJoChN[m?Qk]foo3`ooo?0oooo0looo3`ooo?0oo?Qk]fo"
            A$ = A$ + "4^gJoChN[moo0looo3`ooo?0oooo0looo3`ooo?0oooo0loo4^gJoo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looS_l]"
            A$ = A$ + "oo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooh;OkoS_l]o?nbgnoo0looo3`ooo?0oooo0looo3`ooo?0oooo0looS_l]o?nb"
            A$ = A$ + "gnoh;Okoo3`ooo?0oooo0looo3`ooo?0oooo0looo3`oo?nbgnoh;OkoS_l]oo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooh"
            A$ = A$ + ";OkoS_l]o?nbgnoo0looo3`ooo?0oooo0looo3`oo?nbgnoh;OkoS_l]oo?0oooo0looo3`ooo?0oooo0looS_l]o?nbgnoh;Oko"
            A$ = A$ + "o3`ooo?0oooo0looo3`ooo?0oooh;OkoS_l]o?nbgnoo0looo3`ooo?0oooo0looo3`ooo?0oooo0looS_l]oo?0oooo0looo3`o"
            A$ = A$ + "oo?0oooo0loo%%%0"
        CASE "scrolltrack.png"
            A$ = MKI$(17) + MKI$(68)
            A$ = A$ + "oW>foookTooo`Gnoo3OiooOlWooobWnooC?koo_m_ooog;oooS?mooOnfoooiKooo[omooonioookWooo_OnooOjHoooYSmooo>i"
            A$ = A$ + "oo?lUooo`Gnoo7oioo_lYooodcnooKokooombooohCoooW_mooOnfooojOooo_OnooonioookWoooW>fooOjHooo_Cnoo3Oioo?l"
            A$ = A$ + "UoooaOnoo;Ojoo?m\ooofonooO_loo?ndoooiKoooW_moo_ngoookWooo_OnooonioooYSmooW>foookTooo`Gnoo3OiooOlWooo"
            A$ = A$ + "bWnooC?koo_m_ooog;oooS?mooOnfoooiKooo[omooonioookWooo_OnooOjHoooYSmooo>ioo?lUooo`Gnoo7oioo_lYooodcno"
            A$ = A$ + "oKokooombooohCoooW_mooOnfooojOooo_OnooonioookWoooW>fooOjHooo_Cnoo3Oioo?lUoooaOnoo;Ojoo?m\ooofonooO_l"
            A$ = A$ + "oo?ndoooiKoooW_moo_ngoookWooo_OnooonioooYSmooW>foookTooo`Gnoo3OiooOlWooobWnooC?koo_m_ooog;oooS?mooOn"
            A$ = A$ + "foooiKooo[omooonioookWooo_OnooOjHoooYSmooo>ioo?lUooo`Gnoo7oioo_lYooodcnooKokooombooohCoooW_mooOnfooo"
            A$ = A$ + "jOooo_OnooonioookWoooW>fooOjHooo_Cnoo3Oioo?lUoooaOnoo;Ojoo?m\ooofonooO_loo?ndoooiKoooW_moo_ngoookWoo"
            A$ = A$ + "o_OnooonioooYSmooW>foookTooo`Gnoo3OiooOlWooobWnooC?koo_m_ooog;oooS?mooOnfoooiKooo[omooonioookWooo_On"
            A$ = A$ + "ooOjHoooYSmooo>ioo?lUooo`Gnoo7oioo_lYooodcnooKokooombooohCoooW_mooOnfooojOooo_OnooonioookWoooW>fooOj"
            A$ = A$ + "Hooo_Cnoo3Oioo?lUoooaOnoo;Ojoo?m\ooofonooO_loo?ndoooiKoooW_moo_ngoookWooo_OnooonioooYSmooW>foookTooo"
            A$ = A$ + "`Gnoo3OiooOlWooobWnooC?koo_m_ooog;oooS?mooOnfoooiKooo[omooonioookWooo_OnooOjHoooYSmooo>ioo?lUooo`Gno"
            A$ = A$ + "o7oioo_lYooodcnooKokooombooohCoooW_mooOnfooojOooo_OnooonioookWoooW>fooOjHooo_Cnoo3Oioo?lUoooaOnoo;Oj"
            A$ = A$ + "oo?m\ooofonooO_loo?ndoooiKoooW_moo_ngoookWooo_OnooonioooYSmooW>foookTooo`Gnoo3OiooOlWooobWnooC?koo_m"
            A$ = A$ + "_ooog;oooS?mooOnfoooiKooo[omooonioookWooo_OnooOjHoooYSmooo>ioo?lUooo`Gnoo7oioo_lYooodcnooKokooombooo"
            A$ = A$ + "hCoooW_mooOnfooojOooo_OnooonioookWoooW>fooOjHooo_Cnoo3Oioo?lUoooaOnoo;Ojoo?m\ooofonooO_loo?ndoooiKoo"
            A$ = A$ + "oW_moo_ngoookWooo_OnooonioooYSmooW>foookTooo`Gnoo3OiooOlWooobWnooC?koo_m_ooog;oooS?mooOnfoooiKooo[om"
            A$ = A$ + "ooonioookWooo_OnooOjHoooYSmooo>ioo?lUooo`Gnoo7oioo_lYooodcnooKokooombooohCoooW_mooOnfooojOooo_Onooon"
            A$ = A$ + "ioookWoooW>fooOjHooo_Cnoo3Oioo?lUoooaOnoo;Ojoo?m\ooofonooO_loo?ndoooiKoooW_moo_ngoookWooo_Onoooniooo"
            A$ = A$ + "YSmooW>foookTooo`Gnoo3OiooOlWooobWnooC?koo_m_ooog;oooS?mooOnfoooiKooo[omooonioookWooo_OnooOjHoooYSmo"
            A$ = A$ + "oo>ioo?lUooo`Gnoo7oioo_lYooodcnooKokooombooohCoooW_mooOnfooojOooo_OnooonioookWoooW>fooOjHooo_Cnoo3Oi"
            A$ = A$ + "oo?lUoooaOnoo;Ojoo?m\ooofonooO_loo?ndoooiKoooW_moo_ngoookWooo_OnooonioooYSmooW>foookTooo`Gnoo3OiooOl"
            A$ = A$ + "WooobWnooC?koo_m_ooog;oooS?mooOnfoooiKooo[omooonioookWooo_OnooOjHoooYSmooo>ioo?lUooo`Gnoo7oioo_lYooo"
            A$ = A$ + "dcnooKokooombooohCoooW_mooOnfooojOooo_OnooonioookWoooW>fooOjHooo_Cnoo3Oioo?lUoooaOnoo;Ojoo?m\ooofono"
            A$ = A$ + "oO_loo?ndoooiKoooW_moo_ngoookWooo_OnooonioooYSmooW>foookTooo`Gnoo3OiooOlWooobWnooC?koo_m_ooog;oooS?m"
            A$ = A$ + "ooOnfoooiKooo[omooonioookWooo_OnooOjHoooYSmooo>ioo?lUooo`Gnoo7oioo_lYooodcnooKokooombooohCoooW_mooOn"
            A$ = A$ + "fooojOooo_OnooonioookWoooW>fooOjHooo_Cnoo3Oioo?lUoooaOnoo;Ojoo?m\ooofonooO_loo?ndoooiKoooW_moo_ngooo"
            A$ = A$ + "kWooo_OnooonioooYSmooW>foookTooo`Gnoo3OiooOlWooobWnooC?koo_m_ooog;oooS?mooOnfoooiKooo[omooonioookWoo"
            A$ = A$ + "o_OnooOjHoooYSmooo>ioo?lUooo`Gnoo7oioo_lYooodcnooKokooombooohCoooW_mooOnfooojOooo_OnooonioookWoooW>f"
            A$ = A$ + "ooOjHooo_Cnoo3Oioo?lUoooaOnoo;Ojoo?m\ooofonooO_loo?ndoooiKoooW_moo_ngoookWooo_OnooonioooYSmooW>foook"
            A$ = A$ + "Tooo`Gnoo3OiooOlWooobWnooC?koo_m_ooog;oooS?mooOnfoooiKooo[omooonioookWooo_OnooOjHo?h8Ckob[]aoC?g8o?m"
            A$ = A$ + "LSloh3>coWOh=oooW?mooW>foookRoooaOnoo?_jooolZoooeknooO_looombooog;ooPS<]o3>bdn_lJKlodc=boC?g8o?nPclo"
            A$ = A$ + "i7NcoooiCoooYSmooo^hooOlWoooc[noo?_jooOm^ooog;oooO_looombo?h8CkoPS<]o;_f6o?mLSlodc=boS?h<oOnQglooOnd"
            A$ = A$ + "ooOjHooo_;noo7oiooolZoooc[nooG_kooombooog;oooO_lo3>bdn?h8Ckob[]aoC?g8o?mLSloh3>coWOh=oooW?mooW>foook"
            A$ = A$ + "RoooaOnoo?_jooolZoooeknooO_looombooog;ooPS<]o3>bdn_lJKlodc=boC?g8o?nPcloi7NcoooiCoooYSmooo^hooOlWooo"
            A$ = A$ + "c[noo?_jooOm^ooog;oooO_looombo?h8CkoPS<]o;_f6o?mLSlodc=boS?h<oOnQglooOndooOjHooo_;noo7oiooolZoooc[no"
            A$ = A$ + "oG_kooombooog;oooO_lo3>bdn?h8Ckob[]aoC?g8o?mLSloh3>coWOh=oooW?mooW>foookRoooaOnoo?_jooolZoooeknooO_l"
            A$ = A$ + "ooombooog;ooPS<]o3>bdn_lJKlodc=boC?g8o?nPcloi7NcoooiCoooYSmooo^hooOlWoooc[noo?_jooOm^ooog;oooO_looom"
            A$ = A$ + "bo?h8CkoPS<]o;_f6o?mLSlodc=boS?h<oOnQglooOndooOjHooo_;noo7oiooolZoooc[nooG_kooombooog;oooO_lo3>bdn?h"
            A$ = A$ + "8Ckob[]aoC?g8o?mLSloh3>coWOh=oooW?mooW>foookRoooaOnoo?_jooolZoooeknooO_looombooog;ooPS<]o3>bdn_lJKlo"
            A$ = A$ + "dc=boC?g8o?nPcloi7NcoooiCoooYSmooo^hooOlWoooc[noo?_jooOm^ooog;oooO_looombo?h8CkoPS<]o;_f6o?mLSlodc=b"
            A$ = A$ + "oS?h<oOnQglooOndooOjHooo_;noo7oiooolZoooc[nooG_kooombooog;oooO_lo3>bdn?h8Ckob[]aoC?g8o?mLSloh3>coWOh"
            A$ = A$ + "=oooW?mooW>foookRoooaOnoo?_jooolZoooeknooO_looombooog;ooPS<]o3>bdn_lJKlodc=boC?g8o?nPcloi7NcoooiCooo"
            A$ = A$ + "YSmooo^hooOlWoooc[noo?_jooOm^ooog;oooO_looombo?h8CkoPS<]o;_f6o?mLSlodc=boS?h<oOnQglooOndooOjHooo_;no"
            A$ = A$ + "o7oiooolZoooc[nooG_kooombooog;oooO_lo3>bdn?h8Ckob[]aoC?g8o?mLSloh3>coWOh=oooW?mooW>foookRoooaOnoo?_j"
            A$ = A$ + "ooolZoooeknooO_looombooog;ooPS<]o3>bdn_lJKlodc=boC?g8o?nPcloi7NcoooiCoooYSmooo^hooOlWoooc[noo?_jooOm"
            A$ = A$ + "^ooog;oooO_looombo?h8CkookNhooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_Onoooniooo"
            A$ = A$ + "kWooo_Onoo_kQooo^7noo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWoo"
            A$ = A$ + "okNhoo_kQoookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_Onoooniooo^7nookNh"
            A$ = A$ + "ooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_Onoo_kQooo^7noo_Onooon"
            A$ = A$ + "ioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWoookNhoo_kQoookWooo_Onoooniooo"
            A$ = A$ + "kWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_Onoooniooo^7nookNhooonioookWooo_OnooonioookWoo"
            A$ = A$ + "o_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_Onoo_kQooo^7noo_OnooonioookWooo_OnooonioookWooo_On"
            A$ = A$ + "ooonioookWooo_OnooonioookWooo_OnooonioookWoookNhoo_kQoookWooo_OnooonioookWooo_OnooonioookWooo_Onooon"
            A$ = A$ + "ioookWooo_OnooonioookWooo_Onoooniooo^7nookNhooonioookWooo_OnooonioookWooo_OnooonioookWooo_Onoooniooo"
            A$ = A$ + "kWooo_OnooonioookWooo_Onoo_kQooo^7noo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWoo"
            A$ = A$ + "o_OnooonioookWoookNhoo_kQoookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_On"
            A$ = A$ + "oooniooo^7nookNhooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_Onoo_k"
            A$ = A$ + "Qooo^7noo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWoookNhoo_kQooo"
            A$ = A$ + "kWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_Onoooniooo^7nookNhooonioookWoo"
            A$ = A$ + "o_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWooo_Onoo_kQooo^7noo_OnooonioookWooo_On"
            A$ = A$ + "ooonioookWooo_OnooonioookWooo_OnooonioookWooo_OnooonioookWoookNh%%o3"
        CASE "scrollthumb.png"
            A$ = MKI$(15) + MKI$(88)
            A$ = A$ + "okNhooOoloO[E6hoC_kYo?m^WnodkNjoC_kYo3=^TnodkNjoC_kYo?m^WnodkNjoC_kYogJU1noo^7nookNho7KV5n_lJKlooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooooooooo;_f6oO\IFhookNho7KV5noooooooO_loookRooo_;noocNgoooi"
            A$ = A$ + "CoomO_loaWMao_ndonOjAgkoZ;]_ooooooO\IFhookNho7KV5noooooooO_loookRooo_;noo_>gok_iBoomO_loaWMao_ndonOj"
            A$ = A$ + "AgkoZ;]_ooooooO\IFhookNho7KV5noooooooO_loookRooo_;noo_>gok_iBoomO_loaWMaoc>e0oOjAgkoZ;]_ooooooO\IFho"
            A$ = A$ + "okNho7KV5noooooooO_loookRooo_;noocNgoooiCo?nPcloaWMao_ndonOjAgkoZ;]_ooooooO\IFhookNho7KV5noooooooO_l"
            A$ = A$ + "oookRooo_;noo_>gok_iBo?nPcloaWMao_ndonOjAgkoZ;]_ooooooO\IFhookNho7KV5noooooooO_loookRooo_;noo_>gok_i"
            A$ = A$ + "Bo?nPcloaWMaoc>e0oOjAgkoZ;]_ooooooO\IFhookNho7KV5noooooooO_loookRooo_;noo_>gok_iBo?nPcloaWMao_ndonOj"
            A$ = A$ + "AgkoZ;]_ooooooO\IFhookNho7KV5noooooooO_loookRooo_;noo_>goooiCoomO_loaWMaoc>e0oOjAgkoZ;]_ooooooO\IFho"
            A$ = A$ + "okNho7KV5noooooooO_loookRooo_;noocNgoooiCoomO_loaWMao_ndonOjAgkoZ;]_ooooooO\IFhookNho7KV5noooooooO_l"
            A$ = A$ + "oookRooo_;noo_>gok_iBoomO_loaWMao_ndonOjAgkoZ;]_ooooooO\IFhookNho7KV5noooooooO_loookRooo_;noo_>gok_i"
            A$ = A$ + "BoomO_loaWMaoc>e0oOjAgkoZ;]_ooooooO\IFhookNho7KV5noooooooO_loookRooo_;noocNgoooiCo?nPcloaWMao_ndonOj"
            A$ = A$ + "AgkoZ;]_ooooooO\IFhookNho7KV5noooooooO_loookRooo_;noo_>gok_iBo?nPcloaWMao_ndonOjAgkoZ;]_ooooooO\IFho"
            A$ = A$ + "okNho7KV5noooooooO_loookRooo_;noo_>gok_iBo?nPcloaWMaoc>e0oOjAgkoZ;]_ooooooO\IFhookNho7KV5noooooooO_l"
            A$ = A$ + "oookRooo_;noo_>gok_iBo?nPcloaWMao_ndonOjAgkoZ;]_ooooooO\IFhookNho7KV5noooooooO_loookRooo_;noo_>goooi"
            A$ = A$ + "CoomO_loaWMaoc>e0oOjAgkoZ;]_ooooooO\IFhookNho7KV5noooooooO_loookRooo_;noo_>gok_iBoomO_loaWMao_ndonOj"
            A$ = A$ + "AgkoZ;]_ooooooO\IFhookNho7KV5noooooooO_loookRooo_;noo_>goooiCo?nPcloaWMao_ndonOjAgkoZ;]_ooooooO\IFho"
            A$ = A$ + "okNho7KV5nOnQglo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`oWOh=oO\IFhookNhoo?lUo?Z@bgoj:ZS"
            A$ = A$ + "o[[X>n_^Rjhoj:ZSo[[X>n_^Rjhoj:ZSo[[X>n_^Rjhok>jSo_jTomoo^7nooo>ioomacn_OV9eonIVDokWIBm_OV9eonIVDokWI"
            A$ = A$ + "Bm_OV9eonIVDokWIBm_OV9eonIVDokWIBmog7?kooo>iokWIBm_lJKlooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooo;_f6o_OV9eooo>iokWIBmoooooook_ooo_m_ooobWnooo^hoo?jGoOnQglo`S=ao[^dnnoi?_koY7M_oooooo_OV9eo"
            A$ = A$ + "oo>iokWIBmoooooook_ooo_m_ooobWnooo^hoooiEo?nPclo`S=ao[^dnnoi?_koY7M_oooooo_OV9eooo>iokWIBmoooooook_o"
            A$ = A$ + "oo_m_ooobWnooo^hoo?jGo?nPclo`S=ao[^dnnoi?_koY7M_oooooo_OV9eooo>iokWIBmoooooook_ooo_m_ooobWnooo^hoo?j"
            A$ = A$ + "GoOnQgloaWMao[^dnnoi?_koY7M_oooooo_OV9eooo>iokWIBmoooooook_ooo_m_ooobWnooo^hoooiEoOnQglo`S=ao[^dnnoi"
            A$ = A$ + "?_koY7M_oooooo_OV9eooo>iokWIBmoooooook_oooOm^ooobWnooo^hoooiEoOnQglo`S=aoWNdmnoi?_koY7M_oooooo_OV9eo"
            A$ = A$ + "oo>iokWIBmoooooook_oooOm^ooobWnooo>ioo?jGoOnQglo`S=aoWNdmnoi?_koY7M_oooooo_OV9eooo>iokWIBmoooooook_o"
            A$ = A$ + "ooOm^ooobWnooo^hoooiEo?nPclo`S=ao[^dnnoi?_koY7M_oooooo_OV9eooo>iokWIBmoooooook_oooOm^ooobWnooo^hoo?j"
            A$ = A$ + "Go?nPclo`S=aoWNdmnoi?_koY7M_oooooo_OV9eooo>iokWIBmoooooook_oooOm^ooobWnooo>ioo?jGo?nPclo`S=ao[^dnnoi"
            A$ = A$ + "?_koY7M_oooooo_OV9eooo>iokWIBmoooooook_ooo_m_ooobWnooo^hoo?jGo?nPclo`S=ao[^dnnoi?_koY7M_oooooo_OV9eo"
            A$ = A$ + "oo>iokWIBmoooooook_ooo_m_ooobWnooo^hoo?jGoOnQgloaWMao[^dnnoi?_koY7M_oooooo_OV9eooo>iokWIBmoooooook_o"
            A$ = A$ + "oo_m_ooobWnooo^hoooiEoOnQglo`S=ao[^dnnoi?_koY7M_oooooo_OV9eooo>iokWIBmoooooook_ooo_m_ooobWnooo^hoooi"
            A$ = A$ + "EoOnQglo`S=aoWNdmnoi?_koY7M_oooooo_OV9eooo>iokWIBmoooooook_ooo_m_ooobWnooo>ioo?jGoOnQglo`S=aoWNdmnoi"
            A$ = A$ + "?_koY7M_oooooo_OV9eooo>iokWIBmoooooook_oooOm^ooobWnooo^hoooiEo?nPclo`S=ao[^dnnoi?_koY7M_oooooo_OV9eo"
            A$ = A$ + "oo>iokWIBmoooooook_ooo_m_ooobWnooo^hoo?jGo?nPclo`S=aoWNdmnoi?_koY7M_oooooo_OV9eooo>iokWIBmoooooook_o"
            A$ = A$ + "oo_m_ooobWnooo>ioo?jGo?nPclo`S=ao[^dnnoi?_koY7M_oooooo_OV9eooo>iokWIBmomO_lo`S=ao3?f4o?lHClo`S=ao3?f"
            A$ = A$ + "4o?lHClo`S=ao3?f4o?lHClo`S=aoOog;o_OV9eooo>ioomacn_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_O"
            A$ = A$ + "V9eonIVDokWIBmog7?kookNhooOolo_H:IcoRYT=o;VBfl_H:IcoRYT=o;VBfl_H:IcoRYT=o;VBfl_H:IcoRYT=o;VBfloo^7no"
            A$ = A$ + "okNho;VBfl?mLSlooooooooooooooooooooooooooooooooooooooooooooooooooooooC?g8o_H:IcookNho;VBflooooooS_l]"
            A$ = A$ + "oS>dlnOjAgko`S=aoc?i@ooo]omoo;Ojooomaoool_oooooooooooo_H:IcookNho;VBflooooooS_l]oS>dlnOjAgko`S=ao_oh"
            A$ = A$ + "?ooo]omoo;Ojooombooomcoooooooooooo_H:IcookNho;VBflooooooS_l]oS>dlnOjAgko`S=aoc?i@ooo]omoo;Ojooomaooo"
            A$ = A$ + "mcoooooooooooo_H:IcookNho;VBflooooooS_l]oS>dln?j@ckoaWMaoc?i@ooo]omoo;Ojooombooomcoooooooooooo_H:Ico"
            A$ = A$ + "okNho;VBflooooooS_l]oS>dlnOjAgkoaWMaoc?i@ooo]omoo;Ojooomaooomcoooooooooooo_H:IcookNho;VBflooooooS_l]"
            A$ = A$ + "oS>dln?j@cko`S=aoc?i@ooo]omoo;Ojooomaooomcoooooooooooo_H:IcookNho;VBflooooooS_l]oS>dln?j@cko`S=aoc?i"
            A$ = A$ + "@ooo^7noo;Ojooomaooomcoooooooooooo_H:IcookNho;VBflooooooS_l]oS>dlnOjAgko`S=ao_oh?ooo]omoo;Ojooomaooo"
            A$ = A$ + "mcoooooooooooo_H:IcookNho;VBflooooooS_l]oS>dln?j@cko`S=aoc?i@ooo]omoo;Ojooomaooomcoooooooooooo_H:Ico"
            A$ = A$ + "okNho;VBflooooooS_l]oS>dlnOjAgko`S=aoc?i@ooo^7noo;Ojooomaooomcoooooooooooo_H:IcookNho;VBflooooooS_l]"
            A$ = A$ + "oS>dlnOjAgko`S=aoc?i@ooo]omoo;Ojooombooomcoooooooooooo_H:IcookNho;VBflooooooS_l]oS>dln?j@ckoaWMaoc?i"
            A$ = A$ + "@ooo]omoo;Ojooomaooomcoooooooooooo_H:IcookNho;VBflooooooS_l]oS>dlnOjAgkoaWMaoc?i@ooo]omoo;Ojooomaooo"
            A$ = A$ + "mcoooooooooooo_H:IcookNho;VBflooooooS_l]oS>dln?j@cko`S=aoc?i@ooo]omoo;Ojooomaooomcoooooooooooo_H:Ico"
            A$ = A$ + "okNho;VBflooooooS_l]oS>dln?j@cko`S=aoc?i@ooo^7noo;Ojooomaooomcoooooooooooo_H:IcookNho;VBflooooooS_l]"
            A$ = A$ + "oS>dlnOjAgko`S=ao_oh?ooo]omoo;Ojooomaooomcoooooooooooo_H:IcookNho;VBflooooooS_l]oS>dln?j@cko`S=aoc?i"
            A$ = A$ + "@ooo]omoo;Ojooomaooomcoooooooooooo_H:IcookNho;VBfl?cd2joS_l]oS>dlnOjAgko`S=aoc?i@ooo^7noo;Ojooomaooo"
            A$ = A$ + "mcoooooooc<]Pn_H:IcookNho;VBfl_H:Ico<C;Xoc<]Pn?cd2jo<C;Xoc<]Pn?cd2jo<C;Xoc<]Pn?cd2jo<C;Xo;VBfl_H:Ico"
            A$ = A$ + "okNhoo_jJo_H:IcoRYT=o;VBfl_H:IcoRYT=o;VBfl_H:IcoRYT=o;VBfl_H:IcoRYT=o;VBflooZ[moogngoooniooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooo\gmoogngoooooooog7ooo7oioo_kQooo\gmoo[^fooOj"
            A$ = A$ + "HoooWGmooONeok_iBo?oT3moo?_jooooooooXOmoogngooooooooaOnooOOlooOm^oooc[noo;OjooOlWoooaOnoo7oioo_kQooo"
            A$ = A$ + "[cmonK^doooooo_lJKloogngoooooo_oV;mooo>ioo?lUooo`Gnooo>ioookTooo^7noo_>gooOjHoooYSmonK^doooooo_h:Kko"
            A$ = A$ + "ogngooooooooWGmoo3OiooOlWooo`Gnooo>ioo_kQooo]omoo_>goo_jJoooZ[mooOndoooooo_h:KkoogngooooooooW?moo3Oi"
            A$ = A$ + "oo?lUooo`Gnooo>ioo_kQooo^7noo_>goo_jJoooYSmonK^doooooo_h:Kkoogngoooooo_oV;mooo>ioo?lUooo`Gnooo>ioook"
            A$ = A$ + "Tooo^7noo_>gooOjHoooYSmonK^doooooo_h:KkoogngooooooooWGmoo3OiooOlWooo`Gnooo>ioo_kQooo]omoo_>goo_jJooo"
            A$ = A$ + "Z[mooOndoooooo_h:KkoogngooooooooW?moo3Oioo?lUooo`Gnooo>ioo_kQooo^7noo_>goo_jJoooYSmonK^doooooo_h:Kko"
            A$ = A$ + "ogngoooooo_oV;mooo>ioo?lUooo`Gnooo>ioookTooo^7noo_>gooOjHoooYSmonK^doooooo_h:KkoogngooooooooWGmoo3Oi"
            A$ = A$ + "ooOlWooo`Gnooo>ioo_kQooo]omoo_>goo_jJoooZ[mooOndoooooo_h:KkoogngooooooooW?moo3Oioo?lUooo`Gnooo>ioo_k"
            A$ = A$ + "Qooo^7noo_>goo_jJoooYSmonK^doooooo_h:Kkoogngoooooo_oV;mooo>ioo?lUooo`Gnooo>ioookTooo^7noo_>gooOjHooo"
            A$ = A$ + "YSmonK^doooooo_h:KkoogngooooooooWGmoo3OiooOlWooo`Gnooo>ioo_kQooo]omoo_>goo_jJoooZ[mooOndoooooo_h:Kko"
            A$ = A$ + "ogngooooooooWGmoo3Oioo?lUooo`Gnooo>ioo_kQooo^7noo_>goo_jJoooYSmonK^doooooo_h:KkoogngooooooooWGmooo>i"
            A$ = A$ + "oo?lUooo`Gnooo>ioookTooo^7noo_>gooOjHoooYSmonK^doooooo_h:KkoogngooooooooYSmoo3OiooOlWooo`Gnooo>ioo_k"
            A$ = A$ + "Qooo]omoo_>goo_jJoooZ[mooOndoooooo_h:KkoogngooooooooZ[moo3Oioo?lUooo`Gnooo>ioo_kQooo^7noo_>goo_jJooo"
            A$ = A$ + "YSmonK^doooooo_h:KkoogngooooooooZ[mooo>ioo?lUooo`Gnooo>ioookTooo^7noo_>gooOjHoooYSmonK^doooooo_h:Kko"
            A$ = A$ + "ogngoooooooobWnomGNdok_iBo_oV;monK^dok_iBo_oV;monK^dogOiAoonSoloo7oiooooooojCokoogngoOncknoooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooooooooo3?f4ooo\gmoogngooolZooh;OkoK?l[o[]`^nOf1gjoI7L[oWM`"
            A$ = A$ + "]n_f2kjoJ;\[o_m`_nOg57koVk\^ooOm^ooo\gmo%%%0"
        CASE "scrollbuttons.png"
            A$ = MKI$(17) + MKI$(136)
            A$ = A$ + "okNhoC?g8o?[D2hoAWKYo3=^Tn?dhBjo@S;Yo3=^Tn?dhBjo@S;Yo3=^Tn?dhBjo@S;Yo3=^Tnocg>joY6IOoC?g8ooo^7noaVIQ"
            A$ = A$ + "o;_f6ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo_lJKloaVIQoo_kQoO\IFhooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooO\IFhookNho7KV5noooooooconoo?okooo"
            A$ = A$ + "l_oooconoo?okoool_oooconoo?okoool_oooconoo?okoool_ooooooo7KV5noo^7noaVIQooooooooeknooG_kooOm^oooekno"
            A$ = A$ + "oG_kooOm^oooeknooG_kooOm^oooeknooG_kooOm^oooooooaVIQoo_kQoO\IFhooooooookRooo_;nooo^hoookRooo_;nocAfF"
            A$ = A$ + "oookRooo_;nooo^hoookRooo_;nooo^hooooooO\IFhookNho7KV5noooooooOndoooiCoooW?mooOndo?7IKmoLT]eocAfFoooi"
            A$ = A$ + "CoooW?mooOndoooiCoooW?moooooo7KV5noo^7noaVIQoooooo_mN[lofk]boK_g:ooLT]eocAfFo?7IKmoLT]eocAfFoK_g:o_m"
            A$ = A$ + "N[lofk]boK_g:oooooooaVIQoo_kQoO\IFhooooook^e2o_kF;locAfFo?7IKmoLT]eo^K]`o?7IKmoLT]eocAfFok^e2o_kF;lo"
            A$ = A$ + "^K]`ooooooO\IFhookNho7KV5nooooooY7M_o?7IKmoLT]eocAfFoWNdmnOjAgkoY7M_o?7IKmoLT]eocAfFoWNdmnOjAgkooooo"
            A$ = A$ + "o7KV5noo^7noaVIQoooooo?j@ckoX3=_o?7IKm?j@ckoX3=_oS>dln?j@ckoX3=_o?7IKm?j@ckoX3=_oS>dlnooooooaVIQoo_k"
            A$ = A$ + "QoO\IFhooooooS>dln?j@ckoX3=_oS>dln?j@ckoX3=_oS>dln?j@ckoX3=_oS>dln?j@ckoX3=_ooooooO\IFhookNho7KV5noo"
            A$ = A$ + "ooooX3=_oS>dln?j@ckoX3=_oS>dln?j@ckoX3=_oS>dln?j@ckoX3=_oS>dln?j@ckoooooo7KV5noo^7noaVIQoooooo?j@cko"
            A$ = A$ + "X3=_oS>dln?j@ckoX3=_oS>dln?j@ckoX3=_oS>dln?j@ckoX3=_oS>dlnooooooaVIQoo_kQoO\IFhooooooS>dln?j@ckoX3=_"
            A$ = A$ + "oS>dln?j@ckoX3=_oS>dln?j@ckoX3=_oS>dln?j@ckoX3=_ooooooO\IFhookNho7KV5nOnQglofk]boK_g:o_mN[lofk]boK_g"
            A$ = A$ + ":o_mN[lofk]boK_g:o_mN[lofk]boK_g:o_mN[loi7Nco7KV5noo^7nooo^hoS:Tlm_^Rjhoj:ZSo[[X>n_^Rjhoj:ZSo[[X>n_^"
            A$ = A$ + "Rjhoj:ZSo[[X>n_^Rjhoj:ZSo[[X>noY?^gooSneoo_kQo?mLSlonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eo"
            A$ = A$ + "nIVDokWIBm_OV9eonIVDokWIBm?mLSlookNhokWIBm_lJKlooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooob[]aokWIBmoo^7nonIVDoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooonIVDoo_kQo_OV9eooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo_O"
            A$ = A$ + "V9eookNhokWIBmoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooookWIBmoo^7no"
            A$ = A$ + "nIVDoooooooooooooooooooooooooooooooooChN[moooooooooooooooooooooooooooooooooooooonIVDoo_kQo_OV9eooooo"
            A$ = A$ + "ooonioookWooo_Onooonio?Qk]fo4^gJoChN[mookWooo_OnooonioookWooo_Onoooooo_OV9eookNhokWIBmooooooo7oiooOl"
            A$ = A$ + "WoooaOno4^gJoChN[m?Qk]fo4^gJoChN[mooaOnoo7oiooOlWoooaOnooooookWIBmoo^7nonIVDooooooooW?mooOndoChN[m?Q"
            A$ = A$ + "k]fo4^gJoooiCo?Qk]fo4^gJoChN[mooW?mooOndoooiCooooooonIVDoo_kQo_OV9eooooooGOg9o?Qk]fo4^gJoChN[mOmMWlo"
            A$ = A$ + "egMboGOg9o?Qk]fo4^gJoChN[mOmMWloegMboooooo_OV9eookNhokWIBmoooooo_Om`oone3o?Qk]fo_Om`oone3ookG?lo_Om`"
            A$ = A$ + "oone3o?Qk]fo_Om`oone3ookG?looooookWIBmoo^7nonIVDooooooOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe"
            A$ = A$ + "1oOkE7lo]GM`ogNe1ooooooonIVDoo_kQo_OV9eoooooogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOk"
            A$ = A$ + "E7lo]GM`oooooo_OV9eookNhokWIBmoooooo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo"
            A$ = A$ + "oooookWIBmoo^7nonIVDooooooOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1ooooooonIVD"
            A$ = A$ + "oo_kQo_OV9eoi7NcoK_g:o_mN[lofk]boK_g:o_mN[lofk]boK_g:o_mN[lofk]boK_g:o_mN[lofk]boWOh=o_OV9eookNhoook"
            A$ = A$ + "Ro_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDoo?jGooo^7noX3=_okWIBm_O"
            A$ = A$ + "V9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eoI7L[oo_kQo_OV9eodc=booombooog;oo"
            A$ = A$ + "oO_looombooog;oooO_looombooog;oooO_looombooog;oooO_loC?g8o_OV9eookNhokWIBmooooooOOl\oomacnog7?koOOl\"
            A$ = A$ + "oomacnog7?koOOl\oomacnog7?koOOl\oomacnog7?kooooookWIBmoo^7nonIVDoooooookG?lo_Om`oone3ookG?lo_Om`oone"
            A$ = A$ + "3ookG?lo_Om`oone3ookG?lo_Om`oone3ooooooonIVDoo_kQo_OV9eooooook_iBo_nRkloj;^co[_h>o_nRkloj;^co_oh?oon"
            A$ = A$ + "Solok?ncok_iBo_oV;monK^doooooo_OV9eookNhokWIBmooooooo;Ojoo_kQooo^7nookNhoo_kQo?Qk]fooo^hoookRooo`Gno"
            A$ = A$ + "o;Ojoo_lYooobWnooooookWIBmoo^7nonIVDooooooooooooog?oooOolooomcoo4^gJoChN[m?Qk]fook_ooo_onooonkoooooo"
            A$ = A$ + "oooooooooooonIVDoo_kQo_OV9eooooooooooooooooooooooChN[m?Qk]fo4^gJoChN[m?Qk]fooooooooooooooooooooooooo"
            A$ = A$ + "oo_OV9eookNhokWIBmoooooooooooooooo?Qk]fo4^gJoChN[moooooo4^gJoChN[m?Qk]fooooooooooooooooooooookWIBmoo"
            A$ = A$ + "^7nonIVDoooooooooooo4^gJoChN[m?Qk]fooooooooooooooooo4^gJoChN[m?Qk]fooooooooooooooooonIVDoo_kQo_OV9eo"
            A$ = A$ + "oooooooooooooooo4^gJoooooooooooooooooooooooooooo4^gJoooooooooooooooooooooo_OV9eookNhokWIBmoooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooookWIBmoo^7nonIVDoooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooonIVDoo_kQo_OV9eooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooo_OV9eookNhokWIBm?cd2jooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooo<C;XokWIBmoo^7nonIVDokWIBm?cd2jo<C;Xoc<]Pn?cd2jo<C;Xoc<]Pn?cd2jo<C;X"
            A$ = A$ + "oc<]Pn?cd2jo<C;Xoc<]Pn_OV9eonIVDoo_kQo?f0cjonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWI"
            A$ = A$ + "Bm_OV9eonIVDokWIBm_djJjookNhoo?okooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooOkOooo^7noooooooomboooaOnooo^hooOkOooo\gmoo_>gooOjHoooYSmooSneoo?jGoooWGmonK^dooolZooooooo"
            A$ = A$ + "oOndoo_kQoooooooo7oiooombooofonoo?_joo_lYoooaOnoo7oiooOlWooo`Gnooo>ioookRooo]omooONeooooooOnQglookNh"
            A$ = A$ + "oooooooo_;nooKokooOm^ooobWnoo7oiooOlWooo`Gnooo>ioookTooo_;nookNhooOkOoooWGmoooooo7Of5ooo^7noooooooOk"
            A$ = A$ + "Ooooc[noo;OjooOlWooo`Gnoo3Oioo?lUooo^7noogngooOkOooo]omoogngoo?jGooooooo\C=`oo_kQoooooooo_>gooOlWooo"
            A$ = A$ + "aOnoo7oioo?lUooo`GnoS_l]ooOkOooo]omoogngooOkOooo]omooSneoooooo?j@ckookNhoooooooo[cmoo7oiooOlWooo`Gno"
            A$ = A$ + "o3Oio?nbgnoh;OkoS_l]ooOkOooo\gmoogngoo?kMoooXOmooooooK^cjnoo^7noooooooOjHooo`Gnoo7oiooOlWooh;OkoS_l]"
            A$ = A$ + "o?nbgnoh;OkoS_l]oo?kMooo\gmoocNgoo?jGoooooooUgL^oo_kQooooooooSneoo?lUooo`GnoS_l]o?nbgnoh;OkookNho?nb"
            A$ = A$ + "gnoh;OkoS_l]oo?kMooo[cmooONeooooooOi=WkookNhooooooooWGmooo>io?nbgnoh;OkoS_l]oookTooo_;noogngo?nbgnoh"
            A$ = A$ + ";OkoS_l]ooojLoooWGmooooooGNcinoo^7nooooooooiEooo_;nooo>io?nbgnoo_Cnooo^hoookRooo]omoo_>go?nbgnoo[cmo"
            A$ = A$ + "o[^foooiEoooooooUgL^oo_kQooooooooOndoo_kQooo_;nooo^hoookRooo_;nookNhooOkOooo\gmoo_>goo_jJoooYSmooOnd"
            A$ = A$ + "ooooooOi=WkookNhooooooooW?moogngoo_kQooo^7nookNhoo_kQooo]omoocNgoo?kMooo[cmoo[^foo?jGo_oV;mooooooGNc"
            A$ = A$ + "inoo^7nooooooc?i@ooo[cmoocNgooOkOooo]omoocNgoo?kMooo[cmoo[^fooOjHoooXOmooONeogOiAoooooooUgL^oo_kQooo"
            A$ = A$ + "ooooo;OjoooiCoooWGmooONeoooiEoooWGmooONeoooiEoooWGmooOndoooiCoOoU7moo7oiooooooojCokookNhoc?i@ooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooodc=booOkOooo^7noo?_jo3?f4oOi=WkoR[\]"
            A$ = A$ + "ok]abnOg57koMGL\ogMaanOg57koMGL\ogMaanOg57koOOl\oWNdmnoofonoogngoo_kQo?mLSlo\B9Po7M^Un?dhBjo@S;Yo3=^"
            A$ = A$ + "Tn?dhBjo@S;Yo3=^Tn?dhBjo@S;Yo3=^Tn?dhBjo?OkXoWJTmm?mLSlookNho7KV5n_lJKlooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooob[]ao7KV5noo^7noaVIQoooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooaVIQoo_kQoO\IFhooooooo?okoool_oooconoo?okoool_oooconoo?okoool_ooocon"
            A$ = A$ + "oo?okoool_oooconooooooO\IFhookNho7KV5noooooooG_kooOm^oooeknooG_kooOm^oooeknooG_kooOm^oooeknooG_kooOm"
            A$ = A$ + "^oooeknoooooo7KV5noo^7noaVIQoooooooo_;nooo^hoookRooo_;nooo^hoookRooo_;nooo^hoookRooo_;nooo^hoookRooo"
            A$ = A$ + "ooooaVIQoo_kQoO\IFhooooooooiCoooW?mocAfFoooiCoooW?mooOndoooiCoooW?mocAfFoooiCoooW?mooOndooooooO\IFho"
            A$ = A$ + "okNho7KV5noooooofk]bo?7IKmoLT]eocAfFoK_g:o_mN[lofk]bo?7IKmoLT]eocAfFoK_g:o_mN[loooooo7KV5noo^7noaVIQ"
            A$ = A$ + "oooooo_kF;lo^K]`o?7IKmoLT]eocAfFok^e2ooLT]eocAfFo?7IKm_kF;lo^K]`ok^e2oooooooaVIQoo_kQoO\IFhooooooWNd"
            A$ = A$ + "mnOjAgkoY7M_o?7IKmoLT]eocAfFo?7IKmoLT]eoY7M_oWNdmnOjAgkoY7M_ooooooO\IFhookNho7KV5nooooooX3=_oS>dln?j"
            A$ = A$ + "@ckoX3=_o?7IKmoLT]eocAfFoS>dln?j@ckoX3=_oS>dln?j@ckoooooo7KV5noo^7noaVIQoooooo?j@ckoX3=_oS>dln?j@cko"
            A$ = A$ + "X3=_o?7IKm?j@ckoX3=_oS>dln?j@ckoX3=_oS>dlnooooooaVIQoo_kQoO\IFhooooooS>dln?j@ckoX3=_oS>dln?j@ckoX3=_"
            A$ = A$ + "oS>dln?j@ckoX3=_oS>dln?j@ckoX3=_ooooooO\IFhookNho7KV5nooooooX3=_oS>dln?j@ckoX3=_oS>dln?j@ckoX3=_oS>d"
            A$ = A$ + "ln?j@ckoX3=_oS>dln?j@ckoooooo7KV5noo^7noaVIQoooooo?j@ckoX3=_oS>dln?j@ckoX3=_oS>dln?j@ckoX3=_oS>dln?j"
            A$ = A$ + "@ckoX3=_oS>dlnooooooaVIQoo_kQoO\IFhoi7NcoK_g:o_mN[lofk]boK_g:o_mN[lofk]boK_g:o_mN[lofk]boK_g:o_mN[lo"
            A$ = A$ + "fk]boWOh=oO\IFhookNhoookRo?Z@bgoj:ZSo[[X>n_^Rjhoj:ZSo[[X>n_^Rjhoj:ZSo[[X>n_^Rjhoj:ZSo[[X>n_^RjhoWnhN"
            A$ = A$ + "oo?jGooo^7nodc=bokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eodc=boo_k"
            A$ = A$ + "Qo_OV9eob[]aooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo;_f6o_OV9eookNhokWIBmoo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooookWIBmoo^7nonIVDoooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooonIVDoo_kQo_OV9eooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooo_OV9eookNhokWIBmoooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooookWIBmoo^7nonIVDooooooookWooo_OnoChN[mookWooo_Onoooniooo"
            A$ = A$ + "kWooo_OnoChN[mookWooo_OnoooniooooooonIVDoo_kQo_OV9eoooooooOlWo?Qk]fo4^gJoChN[mooaOnoo7oiooOlWo?Qk]fo"
            A$ = A$ + "4^gJoChN[mooaOnoo7oioooooo_OV9eookNhokWIBmoooooooOndoooiCo?Qk]fo4^gJoChN[mooW?mo4^gJoChN[m?Qk]fooOnd"
            A$ = A$ + "oooiCoooW?mooooookWIBmoo^7nonIVDooooooOmMWloegMboGOg9o?Qk]fo4^gJoChN[m?Qk]fo4^gJoGOg9oOmMWloegMboGOg"
            A$ = A$ + "9ooooooonIVDoo_kQo_OV9eooooooone3ookG?lo_Om`oone3o?Qk]fo4^gJoChN[mokG?lo_Om`oone3ookG?lo_Om`oooooo_O"
            A$ = A$ + "V9eookNhokWIBmoooooo]GM`ogNe1oOkE7lo]GM`ogNe1o?Qk]fo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7looooookWIBmoo^7no"
            A$ = A$ + "nIVDooooooOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1ooooooonIVDoo_kQo_OV9eooooo"
            A$ = A$ + "ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`oooooo_OV9eookNhokWIBmoooooo]GM`ogNe"
            A$ = A$ + "1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7lo]GM`ogNe1oOkE7looooookWIBmoo^7nonIVDoWOh=o_mN[lofk]boK_g:o_m"
            A$ = A$ + "N[lofk]boK_g:o_mN[lofk]boK_g:o_mN[lofk]boK_g:oOnQglonIVDoo_kQooo_;nonIVDokWIBm_OV9eonIVDokWIBm_OV9eo"
            A$ = A$ + "nIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBmooXOmookNhoS>dln_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVD"
            A$ = A$ + "okWIBm_OV9eonIVDokWIBm_OV9eonIVDoWM`]noo^7nonIVDoC?g8ooog;oooO_looombooog;oooO_looombooog;oooO_looom"
            A$ = A$ + "booog;oooO_looombo?mLSlonIVDoo_kQo_OV9eooooooomacnog7?koOOl\oomacnog7?koOOl\oomacnog7?koOOl\oomacnog"
            A$ = A$ + "7?koOOl\oooooo_OV9eookNhokWIBmoooooo_Om`oone3ookG?lo_Om`oone3ookG?lo_Om`oone3ookG?lo_Om`oone3ookG?lo"
            A$ = A$ + "oooookWIBmoo^7nonIVDoooooo_oV;moj;^co[_h>o_nRkloj;^co[_h>oonSolok?nco_oh?o_oV;monK^dok_iBooooooonIVD"
            A$ = A$ + "oo_kQo_OV9eooooooo_lYooo^7nookNhoo_kQooo^7nookNhoookRooo_;noo3Oioo_lYooobWnoo;Ojoooooo_OV9eookNhokWI"
            A$ = A$ + "BmooooooooooooOolo?Qk]foog?oooOolooomcoook_ooo_ono?Qk]fook_ooooooooooooooooookWIBmoo^7nonIVDoooooooo"
            A$ = A$ + "oooo4^gJoChN[m?Qk]fooooooooooooooooo4^gJoChN[m?Qk]fooooooooooooooooonIVDoo_kQo_OV9eooooooooooooooooo"
            A$ = A$ + "4^gJoChN[m?Qk]fooooooChN[m?Qk]fo4^gJoooooooooooooooooooooo_OV9eookNhokWIBmoooooooooooooooooooooo4^gJ"
            A$ = A$ + "oChN[m?Qk]fo4^gJoChN[moooooooooooooooooooooooooookWIBmoo^7nonIVDoooooooooooooooooooooooooooo4^gJoChN"
            A$ = A$ + "[m?Qk]fooooooooooooooooooooooooooooooooonIVDoo_kQo_OV9eooooooooooooooooooooooooooooooooo4^gJoooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooo_OV9eookNhokWIBmoooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooookWIBmoo^7nonIVDoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooonIVDoo_kQo_OV9eo<C;Xoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooc<]"
            A$ = A$ + "Pn_OV9eookNhokWIBm_OV9eo<C;Xoc<]Pn?cd2jo<C;Xoc<]Pn?cd2jo<C;Xoc<]Pn?cd2jo<C;Xoc<]Pn?cd2jonIVDokWIBmoo"
            A$ = A$ + "^7noH3<[okWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eonIVDokWIBm_OV9eoB[[Yoo_kQoool_oo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo]omookNhoooooooog;ooo7oi"
            A$ = A$ + "oookRooo]omoocNgooojLoooYSmooW>foo?jGoooXOmooONeok_iBoooc[nooooooooiCooo^7noooooooOlWooog;oooKokoool"
            A$ = A$ + "ZooobWnoo7oiooOlWoooaOnoo3OioookTooo_;noogngoooiEoooooooi7Ncoo_kQooooooooo^hoo_m_oooeknoo;OjooOlWooo"
            A$ = A$ + "aOnoo3OioookTooo_Cnooo^hoo_kQooo]omooONeooooooOlIGlookNhoooooooo]omoo?_joo_lYoooaOnoo3Oioo?lUooo`Gno"
            A$ = A$ + "okNhooOkOooo]omoogngooOkOoooXOmooooooc>e0ooo^7noooooooojLoooaOnoo7oiooOlWooo`Gnoo3Oioo?lUooo]omoogng"
            A$ = A$ + "ooOkOooo]omoogngoo?jGoooooooX3=_oo_kQoooooooo_>gooOlWoooaOnoS_l]oo?lUooo`GnoogngooOkOooo]omoS_l]ooOk"
            A$ = A$ + "Oooo\gmooSneoooooo_i>[kookNhooooooooYSmoo3Oio?nbgnoh;OkoS_l]oo_kQooo^7noocNgo?nbgnoh;OkoS_l]oo?kMooo"
            A$ = A$ + "XOmooooooGNcinoo^7nooooooo?jGooo`Gnoo3Oio?nbgnoh;OkoS_l]oo_kQooh;OkoS_l]o?nbgnoo\gmoo_>goooiEooooooo"
            A$ = A$ + "UgL^oo_kQooooooooONeoookTooo_Cnooo>io?nbgnoh;OkoS_l]o?nbgnoh;OkoocNgoo?kMooo[cmooONeooooooOi=WkookNh"
            A$ = A$ + "ooooooooWGmooo^hoookTooo_Cnooo>io?nbgnoh;OkoS_l]ooojLooo[cmoo_>goo_jJoooWGmooooooGNcinoo^7nooooooooi"
            A$ = A$ + "Cooo^7nooo^hoookRooo_;nooo^ho?nbgnoo]omoocNgooojLoooZ[mooW>foooiCoooooooUgL^oo_kQooooooooOndooOkOooo"
            A$ = A$ + "^7nookNhoo_kQooo^7noogngoo?kMooo\gmoo_>goo_jJoooXOmonK^dooooooOi=WkookNhoooooo?oT3moo_>goo?kMooo]omo"
            A$ = A$ + "ogngoo?kMooo\gmoo_>goo_jJoooYSmooSneoooiEoOoU7mooooooGNcinoo^7nooooooo_lYoooW?mooONeoooiEoooWGmooONe"
            A$ = A$ + "oooiEoooWGmooONeoooiCoooW?momGNdooOlWooooooo[?m_oo_kQo?oT3mooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooC?g8ooo]omookNhooolZo?lHCloUgL^o;^bfn_g6;koMGL\ogMaanOg57koMGL\ogMaanOg"
            A$ = A$ + "57koMGL\oomacnOjAgkooKokooOk%Oo?"
        CASE "radiobutton.png"
            A$ = MKI$(13) + MKI$(104)
            A$ = A$ + "oooo0looo3`ooo?00657J0HDLl5PAaA]0657e3HDLD;PAaaG0657Jlooo3`ooo?0oooo0looo30PAaQ00657<1HDLTOX6Bfo1OkY"
            A$ = A$ + "o[=gJo_aj^joVV8Jo3HDLT?PAa1C06572looo3`ooo?00657<YYNEmo_eJjoK3>hok]hRo_hUGnoUS>joW>k\oOc1;koQ6hFo3HD"
            A$ = A$ + "L`dooo?00657J0HDLTo_eJjoK3>hok]hRo_hUGnoUS>joW>k\o?k_ono_7Olo3=aen?PAaAn0657J0HDLlEX6BfoK3>hok]hRo_h"
            A$ = A$ + "UGnoUS>joW>k\o?k_ono_7Olo7olco?meGoo\nXKo3HDLl5PAaA]1OkYok]hRo_hUGnoUS>joW>k\o?k_ono_7Olo7olco?meGoo"
            A$ = A$ + "fOomoG=bin?PAaA]0657e[=gJo_hUGnoUS>joW>k\o?k_ono_7Olo7olco?meGoofOomoSOnioOmd;oo0657e3HDLD[aj^joUS>j"
            A$ = A$ + "oW>k\o?k_ono_7Olo7olco?meGoofOomoSOnio_nk_ooH_<_o3HDLD;PAaaGVV8JoW>k\o?k_ono_7Olo7olco?meGoofOomoSOn"
            A$ = A$ + "io_nk_oolgOoooJT`m?PAaaG0657J0HDLTOc1;ko_7Olo7olco?meGoofOomoSOnio_nk_oolgOooW=cln?PAaAn0657Jlooo30P"
            A$ = A$ + "Aa1CQ6hFo3=aen?meGoofOomoSOnio_nk_oolgOooW=cln_Y52fo0657<mooo3`ooo?0065720HDL`4PAaAn\nXKoG=binOmd;oo"
            A$ = A$ + "H_<_ooJT`m?PAaAn0657<1HDL8`ooo?0oooo0looo3`ooo?00657J0HDLl5PAaA]0657e3HDLD;PAaaG0657Jlooo3`ooo?0oooo"
            A$ = A$ + "0looo3`ooo?0oooo00HDLX1PAaaG0657e2HDLD?PAaA]0657O1HDLXaooo?0oooo0looo3`ooo?0065720HDL`4PAaAn@R8LoCY]"
            A$ = A$ + "ln?SDCoo3n:_ooGP_m?PAaAn0657<1HDL8`ooo?0oooo00HDL`DTn1foOV;_ocigno?SIgoo4JMoocgdlo?M@cooaQZ^oO7MNm?P"
            A$ = A$ + "Aa1Coooo00HDLX1PAaAnOV;_ocigno?VL_ooc>nmoOMkbo?[PKook5]no?6bkoOISZko0657i3HDLX1PAaaG@R8Locigno?VL_oo"
            A$ = A$ + "Jk^loomkaoog_7ooOoNloSMkboOK;WooD9\nogVN_m?PAaaG0657eBY]ln?SIgooc>nmoomkaoog_7ooOoNloomkaoog_7ooLVMm"
            A$ = A$ + "ok4`jo?FNVko0657e2HDLD?SDCoo4JMooOMkboog_7ooOoNloomkaoog_7ooOoNloCmjbo?BmVoo5M;lo3HDLD?PAaA]3n:_ocgd"
            A$ = A$ + "lo?[PKooOoNloomkaoog_7ooOoNloomkaooUGGoo3]Kno7eVin?PAaA]0657OmGP_m?M@cook5]noSMkboog_7ooOoNloomkaooe"
            A$ = A$ + "\7ooI9<nokC^io_Igifo0657O1HDLX1PAaAnaQZ^o?6bkoOK;WooLVMmoCmjbooUGGooI9<nokC^io_CIVko0657i3HDLXaooo?0"
            A$ = A$ + "0657<M7MNmOISZkoD9\nok4`jo?BmVoo3]KnokC^io_CIVkoZmVGo3HDL`dooo?0oooo00HDL80PAa1C0657igVN_m?FNVko5M;l"
            A$ = A$ + "o7eVin_Igifo0657i3HDL`4PAaQ0oooo0looo3`ooo?0oooo00HDLX1PAaaG0657e2HDLD?PAaA]0657O1HDLXaooo?0oooo0loo"
            A$ = A$ + "o3`ooo?0oooo0looo30PAaQ60657O1HDLD;PAaAm0657e2HDLl5PAaQ6oooo0looo3`ooo?0oooo00HDL80PAa1C0657i3YMDm?X"
            A$ = A$ + "IZho_N[]oK:XAn_Umaeo0657i3HDL`4PAaQ0oooo0looo30PAa1C<f6BokiU7nO[gNkoa^;_oKK`1oo^6Olo0cLco7;[MnOUhAeo"
            A$ = A$ + "0657<mooo30PAaQ60657ikiU7nO[gNkoa^;_oKK`1oo^6Olo0cLcoGLdBo?bEOmof:;Yo3HDLT?PAaQ60657O1YMDmO[gNkoa^;_"
            A$ = A$ + "oKK`1oo^6Olo0cLcoGLdBo?bEOmo<[mfooLgOooW7Jfo0657O1HDLD;XIZhoa^;_oKK`1oo^6Olo0cLcoGLdBo?bEOmo<[mfooLg"
            A$ = A$ + "OoodQ?nomZkZo3HDLD;PAaAm_N[]oKK`1oo^6Olo0cLcoGLdBo?bEOmo<[mfooLgOoodQ?noFG^ioK]hRo?PAaAm0657eJ:XAno^"
            A$ = A$ + "6Olo0cLcoGLdBo?bEOmo<[mfooLgOoodQ?noFG^ioW=jZoO`n2ko0657e2HDLlUUmaeo0cLcoGLdBo?bEOmo<[mfooLgOoodQ?no"
            A$ = A$ + "FG^ioW=jZoof[gnoS^hJo3HDLl5PAaQ60657i7;[Mn?bEOmo<[mfooLgOoodQ?noFG^ioW=jZoof[gno23\\o3HDLT?PAaQ6oooo"
            A$ = A$ + "00HDL`DUhAeof:;YooLgOoodQ?noFG^ioW=jZoof[gno23\\oc9PKm?PAa1Coooo0looo30PAaQ00657<1HDLToW7JfomZkZoK]h"
            A$ = A$ + "RoO`n2koS^hJo3HDLT?PAa1C06572looo3`ooo?0oooo0looo30PAaQ60657O1HDLD;PAaAm0657e2HDLl5PAaQ6oooo0looo3`o"
            A$ = A$ + "oo?0oooo0looo3`ooo?09G\aJTLa6oEb5KL]9G\aeWLa6GKb5KlG9G\aJlooo3`ooo?0oooo0looo3@b5K\09G\a<ULa6_Jb5KlH"
            A$ = A$ + "9G\aXTLa6G@b5K<:9G\aSULa6_Jb5K<C9G\a2looo3`ooo?09G\a<ULa6CGb5Kl0oooo0looo3`ooo?0oooo0looo3@b5Kl09G\a"
            A$ = A$ + "dULa6cdooo?09G\aJTLa6_Jb5Kl0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0TLa6?@b5KlZ9G\aJTLa6oEb5KlHoooo0loo"
            A$ = A$ + "o3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?09G\aSULa6oEb5KL]9G\aXlooo3`ooo?0oooo0looo3`ooo?0oooo0looo3`o"
            A$ = A$ + "oo?0oooo0TLa6SBb5KL]9G\aeWLa6G`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3@b5KL19G\aeWLa6GKb5K<:"
            A$ = A$ + "oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?09G\aXTLa6GKb5KlG9G\aSmooo3`ooo?0oooo0looo3`ooo?0oooo"
            A$ = A$ + "0looo3`ooo?0oooo0TLa6?Fb5KlG9G\aJTLa6_Jb5Kl0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0TLa6?@b5KlZ9G\aJloo"
            A$ = A$ + "o3@b5K<C9G\adULa6?`ooo?0oooo0looo3`ooo?0oooo0TLa6?@b5K<M9G\a<mooo3`ooo?09G\a2TLa6cDb5KlZ9G\aSULa6SBb"
            A$ = A$ + "5KL19G\aXTLa6?Fb5KlZ9G\a<ULa6;`ooo?0oooo0looo3`ooo?09G\aJTLa6oEb5KL]9G\aeWLa6GKb5KlG9G\aJlooo3`ooo?0"
            A$ = A$ + "oooo0looo3`ooo?0oooo00HDLX1PAaaG0657e2HDLD?PAaA]0657O1HDLXaooo?0oooo0looo3`ooo?0065720HDL`4PAaAnSNXI"
            A$ = A$ + "oG\^[nogQomo8k[[oOjRYm?PAaAn0657<1HDL8`ooo?0oooo00HDL`4WlMeo3WKZo7NiUoohWOnoV[^joW>k\o?k_ono??l\o;JP"
            A$ = A$ + "Lm?PAa1Coooo00HDLX1PAaAn3WKZo7NiUoohWOnoV[^joW>k\o?k_ono_7Olo7olco_d5Kko0657i3HDLX1PAaaGSNXIo7NiUooh"
            A$ = A$ + "WOnoNS^hoK:gYn_BofdoN:=XoK^kXooleGoofOomog:T^m?PAaaG0657eF\^[nohWOnoV[^joK:gYnODEGeoo<l@oK2ZYl?V<[io"
            A$ = A$ + "fOomoSOnio_e9[ko0657e2HDLDogQomoV[^joW>k\o_Bofdoo<\@oGC^hlO8Q6boSHY9oSOnioOnj[oofGolo3HDLD?PAaA]8k[["
            A$ = A$ + "oW>k\o?k_onoN:=XoO2ZZl?8R:bo@8i4oO9bHnOnj[ookc?ooWmbln?PAaA]0657OMjRYm?k_ono_7OloK^kXo?V<[ioTH99oOIb"
            A$ = A$ + "HnOkcknokc?oogOomoo[A2go0657O1HDLX1PAaAn??l\o7olcooleGoofOomoSOnioOnj[ookc?oogOomoOf<cko0657i3HDLXao"
            A$ = A$ + "oo?00657<9JPLm_d5KkofOomoSOnioOnj[ookc?oogOomoOf<ckoVF8Ho3HDL`dooo?0oooo00HDL80PAa1C0657ig:T^m_e9[ko"
            A$ = A$ + "fGoloWmblno[A2go0657i3HDL`4PAaQ0oooo0looo3`ooo?0oooo00HDLX1PAaaG0657e2HDLD?PAaA]0657O1HDLXaooo?0oooo"
            A$ = A$ + "0looo3`ooo?0oooo0looo30PAaQ60657O1HDLD;PAaAm0657e2HDLl5PAaQ6oooo0looo3`ooo?0oooo00HDL80PAa1C0657i39R"
            A$ = A$ + "`m?Ufbko<B=mo?h[lnoO1nfo0657i3HDL`4PAaQ0oooo0looo30PAa1CAj7HooI^ln?WOkoo<VMooCXemo?OCcood1=oo77ZjnoM"
            A$ = A$ + "dieo0657<mooo30PAaQ60657ioI^ln?WOkooHbmno?khgooe];oo\2^mo_GdjooH8_ooU=Z^o3HDLT?PAaQ60657O19R`m?WOkoo"
            A$ = A$ + "Hbmno;=kYo?XNcjo8mKCoCIdPn_cXOno]]LnoCU`joOKjmfo0657O1HDLD;Ufbko<VMoo?khgo?XNcjoAEMEooc`3m_9XVbo<R<V"
            A$ = A$ + "ocIfeo_C0[ooHiI^o3HDLD;PAaAm<B=moCXemooe];oo8mKCooc`2mO=iRcoQ4J8o3BUUl?e[;oo8eKnoGd]`o?PAaAm0657e>h["
            A$ = A$ + "ln?OCcoo\2^moCIdPno9XZboP8Z8o3QTCl?R2?ioGNMmo?d^ioODKVko0657e2HDLleO1nfod1=oo_Gdjo_cXOno<V<Vo7BUSl?R"
            A$ = A$ + "3?io=K^ioWU`ho_?iVooVMWKo3HDLl5PAaQ60657i77ZjnoH8_oo]]LnocIfeo?e[;ooGNMmoWU`ho_?iVoo>UI^o3HDLT?PAaQ6"
            A$ = A$ + "oooo00HDL`dMdieoU=Z^oCU`jo_C0[oo8eKno?d^io_?iVoo>UI^o[fKNm?PAa1Coooo0looo30PAaQ00657<1HDLTOKjmfoHiI^"
            A$ = A$ + "oGd]`oODKVkoVMWKo3HDLT?PAa1C06572looo3`ooo?0oooo0looo30PAaQ60657O1HDLD;PAaAm0657e2HDLl5PAaQ6oooo0loo"
            A$ = A$ + "o3`ooo?0oooo0looo3`ooo?00657J0HDLl5PAaA]0657e3HDLD;PAaaG0657Jlooo3`ooo?0oooo0looo30PAaQ00657<1HDLT?T"
            A$ = A$ + "fAeoPVYRooj]fn_YP6ioFf7Go3HDLT?PAa1C06572looo3`ooo?00657<aHK8m_WGNho]Nk]o7k^ln_]17lokJlao3<c=oO\\fio"
            A$ = A$ + "ER7Eo3HDL`dooo?00657J0HDLT_WGNho]Nk]o7k^ln_]17lokJlao3<c=oOaA;mo8GmeoK[\Tn?PAaAn0657J0HDLl5TfAeo]Nk]"
            A$ = A$ + "o7k^ln?\1_ko:FlToGd^9m?Qofhoo6Mcoc\fKoocMomoONXIo3HDLl5PAaA]PVYRo7k^ln_]17lo:FlTo7EeEmo?3?doVPJ:o3h^"
            A$ = A$ + ";nocMomoC7nhog[^[n?PAaA]0657eoj]fn_]17lokJlaoGd^9mo?3;doeT;>o7BXQlo7C>boC7nhoKMiVo_eR;no0657e3HDLD[Y"
            A$ = A$ + "P6iokJlao3<c=oOQofhoWPZ:o3RXRl?4B>ao0Z[RoKMiVoOfX[no1k;\o3HDLD;PAaaGFf7Go3<c=oOaA;moo6Mco38_;n?8C6bo"
            A$ = A$ + "0Z[RoclgKoOfX[noK_Nko?jR[m?PAaaG0657J0HDLTO\\fio8Gmeoc\fKoocMomoC7nhoKMiVoOfX[noK_Nko;<`bn?PAaAn0657"
            A$ = A$ + "Jlooo30PAa1CER7EoK[\TnocMomoC7nhoKMiVoOfX[noK_Nko;<`bn?W0^eo0657<mooo3`ooo?0065720HDL`4PAaAnONXIog[^"
            A$ = A$ + "[n_eR;no1k;\o?jR[m?PAaAn0657<1HDL8`ooo?0oooo0looo3`ooo?00657J0HDLl5PAaA]0657e3HDLD;PAaaG0657Jlooo3`o"
            A$ = A$ + "oo?0oooo0looo3`ooo?0oooo0TLa6[Ab5KlG9G\aeVLa6GOb5KL]9G\aOULa6[aooo?0oooo0looo3`ooo?09G\a2TLa6cDb5KlZ"
            A$ = A$ + "9G\aSULa6SBb5KL19G\aXTLa6?Fb5KlZ9G\a<ULa6;`ooo?0oooo0TLa6cDb5K<M9G\a3looo3`ooo?0oooo0looo3`ooo?09G\a"
            A$ = A$ + "3TLa6CGb5K<Coooo0TLa6[Ab5KlZ9G\a3looo3`ooo?0oooo0looo3`ooo?0oooo0looo3@b5Kl09G\a[VLa6[Ab5KlG9G\aSmoo"
            A$ = A$ + "o3`ooo?09G\ahTLa63Jb5K<l9G\aPVLa6Scooo?0oooo0TLa6?Fb5KlG9G\aeVLa6Sbooo?0oooo0TLa63Jb5Klo9G\aoWLa6oOb"
            A$ = A$ + "5K<Xoooo0looo3@b5K<:9G\aeVLa6GOb5KL1oooo0looo3@b5K<l9G\aoWLa6oOb5Klo9G\a`oooo3`ooo?09G\a5TLa6GOb5KL]"
            A$ = A$ + "9G\aXlooo3`ooo?09G\aPVLa6oOb5Klo9G\aoWLa63jooo?0oooo0TLa6SBb5KL]9G\aOULa6?fooo?0oooo0TLa6SCb5K<X9G\a"
            A$ = A$ + "`WLa63Jb5K<>oooo0looo3@b5KlH9G\aOULa6[Ab5KlZ9G\a3looo3`ooo?0oooo0looo3`ooo?0oooo0looo3@b5Kl09G\a[VLa"
            A$ = A$ + "6[aooo?09G\a<ULa6CGb5Kl0oooo0looo3`ooo?0oooo0looo3@b5Kl09G\adULa6cdooo?0oooo0TLa6;@b5K<C9G\a[VLa6?Fb"
            A$ = A$ + "5K<:9G\a5TLa6SBb5KlH9G\a[VLa6cDb5K\0oooo0looo3`ooo?0oooo0TLa6[Ab5KlG9G\aeVLa6GOb5KL]9G\aOULa6[aooo?0"
            A$ = A$ + "oooo0loo%o30"
        CASE "progresstrack.png"
            A$ = MKI$(9) + MKI$(19)
            A$ = A$ + "oooooOjZ\nOOnmgoXQ6JoS6JXm?JXQfoXQ6JoS6JXmok_onoV^:[oOgMgm__njkonj[_ok[_nn__njkonj[_oS6JXmo\c>komigO"
            A$ = A$ + "ok[_nn__njko_onkoonk_ook_ono_onkok[_nnOP16hoXQ6Jok[_nnok_ono_onkoooooooooooo_onkoonk_o?JXQfoXQ6Jok[_"
            A$ = A$ + "nnok_onoooooooooooonk_oooooooonk_o?JXQfoXQ6Jok[_nnok_onoooooooooooonk_oooooooonk_o?JXQfoXQ6Jok[_nnok"
            A$ = A$ + "_onooooooooooo?nhSoooooooonk_o?JXQfoXQ6Jok[_nnok_onoooooooooooOmeGoooooooonk_o?JXQfoXQ6Jok[_nnok_ono"
            A$ = A$ + "ooooooooooolc?oooooooonk_o?JXQfoXQ6Jok[_nnok_onooooooooooo?l`3oooooooonk_o?JXQfoXQ6Jok[_nnok_onooooo"
            A$ = A$ + "oooooook_onooooooonk_o?JXQfoXQ6Jok[_nnok_onooooooooooo_lb;oooooooonk_o?JXQfoXQ6Jok[_nnok_onooooooooo"
            A$ = A$ + "ooOmeGoooooooonk_o?JXQfoXQ6Jok[_nnok_onooooooooooo?nhSoooooooonk_o?JXQfoXQ6Jok[_nnok_onooooooooooo_n"
            A$ = A$ + "j[oooooooonk_o?JXQfoXQ6Jok[_nnok_onoooooooooooonk_oooooooonk_o?JXQfomigOok[_nnok_ono_onkoooooooooooo"
            A$ = A$ + "_onkoonk_oOOnmgoW^:[oOgMgmok_ono_onkoonk_ook_ono_onkoOgMgm_Y[bjooooooKjZ\nOOnmgoXQ6JoS6JXm?JXQfomigO"
            A$ = A$ + "oOjZ\noooooo%%%0"
        CASE "progresschunk.png"
            A$ = MKI$(10) + MKI$(12)
            A$ = A$ + ">=X5okdPFl_C3Jao>=X5okdPFl_C3Jao>=X5okdPFl_C3Jao>=X5ok:eVn_[DOjo^BmYok:eWn_[DOjo^BmYok:eWn_[DOjo^BmY"
            A$ = A$ + "ok:eWnoP3cgo3><Oo?h`lmoP3cgo3><Oo?h`lmoP3cgo4>LOoCh`mmoP3cgoZmkIo[f_Wm_JoNfoZmkIo[f_Wm_JoNfo[m;Jo[f_"
            A$ = A$ + "Xm_JoRfo[m;Jo;V_MmoHnjeoSm[Go?f_NmoHojeoTm[GoCf_Om?IoneoTmkGoCf_Om_HnfeoRiKGo;V_Mm_HnfeoRiKGo;V_Mm_H"
            A$ = A$ + "nfeoRiKGo;V_Mm_Hnfeo7ml>oOdckloA@_co71m>oODdkloAA_co75=?oSDdll?BAcco85=?oOBfHlo9ISaoWT=6oOBfHlo9JOao"
            A$ = A$ + "WXm5oORfGlo9JOaoWXm5oORfGl_=V3bofH>8oKSiPl_=V3bofD>8oKCiPlo=V3bogH>8oOSiPlo=V3bo\\N7ocbjMl?;[gao\\N7"
            A$ = A$ + "ocbjMl?;[gao\\N7ocRjMl?;[kao\\^7ok1jEl_7XGaoNPN5ok1jEl_7XGaoNPN5okAjEl_7YGaoNTN5okAjEl_C3Jao>=X5okdP"
            A$ = A$ + "Fl_C3Jao>=X5okdPFl_C3Jao>=X5okdPFl_C3Jao%%%0"
        CASE "button.png"
            A$ = MKI$(18) + MKI$(105)
            A$ = A$ + ":O;ZoKiLDmoPAibo2nd:o;hC[l_P?]bo2nd:o;hC[l_P?]bo2nd:o;hC[l_P?]bo2nd:o;hC[l_P?]bo36E;o;9K;m_bgRjoCfVC"
            A$ = A$ + "oCKTkm?kPKmo\k=eoc^gEo?kNGmo\kMeoc^gEo?kNGmo\kMeoc^gEo?kNGmo\kMeoc^gEo?kNCmo\3^eoCKTkmoT]ido36e;oG?j"
            A$ = A$ + "OoookSooogOnooOoiooomWooogOnooOoiooomWooogOnooOoiooomWooogOnooOoiooomWooo_?noG?jOooPAmbo22E;o7?hGooo"
            A$ = A$ + "m_oooSoloo?ncoooh?oooSoloo?ncoooh?oooSoloo?ncoooh?oooSoloo?ncoooh?ooogono7?hGo_P@ebo22E;o3OgBooolWoo"
            A$ = A$ + "nkOook_omo_ongoonkOook_omo_ongoonkOook_omo_ongoonkOook_omo_ongooocOno3OgBo_P@ebo22E;ognf?o_ojSoomgon"
            A$ = A$ + "ogOokoOom_oomgonogOokoOom_oomgonogOokoOom_oomgonogOokoOom_oon[?nognf?o_P@ebo22E;o_ne;oOoiKoolc?noc?o"
            A$ = A$ + "ho?olSoolc?noc?oho?olSoolc?noc?oho?olSoolc?noc?oho?olSoomW_mo_ne;o_P@ebo22E;oS>e7o?ohGooj[?mo[_ndo_n"
            A$ = A$ + "jCooj[?mo[_ndo_njCooj[?mo[_ndo_njCooj[?mo[_ndo_njCoolSOmoS>e7o_P@ebo22E;oONd4oonf?ooiSOloW?naoOnh7oo"
            A$ = A$ + "iSOloW?naoOnh7ooiSOloW?naoOnh7ooiSOloW?naoOnh7ookKoloONd4o_P@ebo22E;oC^c1o_ne;oogCOkoO?m]oomdgnogCOk"
            A$ = A$ + "oO?m]oomdgnogCOkoO?m]oomdgnogCOkoO?m]oomdgnojG_loC^c1o_P@ebo22E;o7>bhnom`gnoe7OjoGOlYoOmaWnoe7OjoGOl"
            A$ = A$ + "YoOmaWnoe7OjoGOlYoOmaWnoe7OjoGOlYoOmaWnog3Oko7>bhn_P@ebo22E;oc=``nol\Onoc_nho?ojSool[?noc_nho?ojSool"
            A$ = A$ + "[?noc_nho?ojSool[?noc_nho?ojSool[?noccnioc=``n_P@ebo22E;o[M_\nOlZCno[c=do_>g@oojL3mo[c=do_>g@oojL3mo"
            A$ = A$ + "[c=do_>g@oojL3mo[c=do_>g@oojL3moa[>io[M_\n_P@ebo22E;oO]^Xn?lX;noWGmaoONe7ooiEOloWGmaoONe7ooiEOloWGma"
            A$ = A$ + "oONe7ooiEOloWGmaoONe7ooiEOlo`S^hoO]^Xn_P@ebo22E;oGM]Sn_kUkmoRoL`o;nc1o_h?7loRoL`o;nc1o_h?7loRoL`o;nc"
            A$ = A$ + "1o_h?7loRoL`o;nc1o_h?7lo^G^goGM]Sn_P@ebo22E;o?m\PnOkScmoN[l^ok]bkn_g:_koN[l^ok]bkn_g:_koN[l^ok]bkn_g"
            A$ = A$ + ":_koN[l^ok]bkn_g:_ko]?>go?m\Pn_P@ebo22E;o;M\LnojQWmoH;L\oS]`an?f27koH;L\oS]`an?f27koH;L\oS]`an?f27ko"
            A$ = A$ + "H;L\oS]`an?f27ko[7Nfo;M\Ln_P@ebo22E;o7][Hn_jQWmoCgkZo?M_[nodm^joCgkZo?M_[nodm^joCgkZo?M_[nodm^joCgkZ"
            A$ = A$ + "o?M_[nodm^joZ7Nfo7][Hn_P@ebo36e;o7M[Hn?iGglo?S[Yoo<^VnochJjo?S[Yoo<^VnochJjo?S[Yoo<^VnochJjo?S[Yoo<^"
            A$ = A$ + "VnochJjoTOMco7M[HnoPAmbo?JFAoS:OOm?cW2io=S:Tog<Z@nOcX2io=S:Tog<Z@nOcX2io=S:Tog<Z@nOcX2io=S:Tog<Z@nOc"
            A$ = A$ + "X2io<O:ToS:OOm?TXMdo:O;ZoKILBmoPAmbo22E;o;8D]l_P@ebo22E;o;8D]l_P@ebo22E;o;8D]l_P@ebo22E;o;8D]l_P@ebo"
            A$ = A$ + "36U;o?9K;m_bgRjo:O;ZoKiLDmoPAibo2nd:o;hC[l_P?]bo2nd:o;hC[l_P?]bo2nd:o;hC[l_P?]bo2nd:o;hC[l_P?]bo36E;"
            A$ = A$ + "o;9K;m_bgRjoCfVCoCKTkmOXXGooQRNmo7:jeoOXXGooQRNmo7:jeoOXXGooQRNmo7:jeoOXXGooQRNmo7:jeoOXXGooQRNmoCKT"
            A$ = A$ + "kmoT]ido36e;o7:jeoOXXGoo6nlkoKhc_o_Q?ono6nlkoKhc_o_Q?ono6nlkoKhc_o_Q?ono6nlkoKhc_o_Q?onoQRNmo7:jeooP"
            A$ = A$ + "Ambo22E;o7:jeoOXXGoonkOook_omo_ongoonkOook_omo_ongoonkOook_omo_ongoonkOook_omo_ongooQRNmo7:jeo_P@ebo"
            A$ = A$ + "22E;oc9idoOXXGoonkOook_omo_ongoonkOook_omo_ongoonkOook_omo_ongoonkOook_omo_ongooQRNmoc9ido_P@ebo22E;"
            A$ = A$ + "oKYgco_WVCoomgonogOokoOom_oomgonogOokoOom_oomgonogOokoOom_oomgonogOokoOom_ooNJ>moKYgco_P@ebo22E;okhe"
            A$ = A$ + "aooVSCoolc?noc?oho?olSoolc?noc?oho?olSoolc?noc?oho?olSoolc?noc?oho?olSooK>>mokheao_P@ebo22E;oKhc_ooU"
            A$ = A$ + "O?ooj[?mo[_ndo_njCooj[?mo[_ndo_njCooj[?mo[_ndo_njCooj[?mo[_ndo_njCooGnmloKhc_o_P@ebo22E;ogga]ooTK;oo"
            A$ = A$ + "iSOloW?naoOnh7ooiSOloW?naoOnh7ooiSOloW?naoOnh7ooiSOloW?naoOnh7ooC^]locga]o_P@ebo22E;o?W_[ooSG7oogCOk"
            A$ = A$ + "oO?m]oomdgnogCOkoO?m]oomdgnogCOkoO?m]oomdgnogCOkoO?m]oomdgno?NMlo?g_[o_P@ebo22E;oSF]Yo_RC3ooe7OjoGOl"
            A$ = A$ + "YoOmaWnoe7OjoGOlYoOmaWnoe7OjoGOlYoOmaWnoe7OjoGOlYoOmaWno:>=loWF]Xo_P@ebo22E;okeZWo?Q>onoc_nho?ojSool"
            A$ = A$ + "[?noc_nho?ojSool[?noc_nho?ojSool[?noc_nho?ojSool[?no4jlkok5[Wo_P@ebo22E;oCUXUooQ:kno[c=do_>g@oojL3mo"
            A$ = A$ + "[c=do_>g@oojL3mo[c=do_>g@oojL3mo[c=do_>g@oojL3mo6Z\koCeXTo_P@ebo22E;o[TVRoON5gnoWGmaoONe7ooiEOloWGma"
            A$ = A$ + "oONe7ooiEOloWGmaoONe7ooiEOloWGmaoONe7ooiEOlojELko[TVRo_P@ebo22E;o7DTPoOKo^noRoL`o;nc1o_h?7loRoL`o;nc"
            A$ = A$ + "1o_h?7loRoL`o;nc1o_h?7loRoL`o;nc1o_h?7lo]mkjo;TTPo_P@ebo22E;oWSRNo_HjVnoN[l^ok]bkn_g:_koN[l^ok]bkn_g"
            A$ = A$ + ":_koN[l^ok]bkn_g:_koN[l^ok]bkn_g:_koQYKjoSSRNo_P@ebo22E;o7cPMooEeRnoH;L\oS]`an?f27koH;L\oS]`an?f27ko"
            A$ = A$ + "H;L\oS]`an?f27koH;L\oS]`an?f27koGEkio7cPLo_P@ebo22E;o_ROKoOCbNnoCgkZo?M_[nodm^joCgkZo?M_[nodm^joCgkZ"
            A$ = A$ + "o?M_[nodm^joCgkZo?M_[nodm^jo=9kio_BOKo_P@ebo36e;oKBNJoOAZJnoPQKlok5^ao?Hh6ooPQKlo36^ao?Hh6ooPQKlo36^"
            A$ = A$ + "ao?Hh6ooPQKlo36^ao?Hh6oo5YZioKBNJooPAmbo?JFAoS:OOm_9iYmoVTWfoKBNJo_9iYmoVTWfoKBNJo_9iYmoVTWfoKBNJo_9"
            A$ = A$ + "iYmoVTWfoKBNJo_9iYmoVTWfoS:OOm?TXMdo:O;ZoKILBmoPAmbo22E;o;8D]l_P@ebo22E;o;8D]l_P@ebo22E;o;8D]l_P@ebo"
            A$ = A$ + "22E;o;8D]l_P@ebo36U;o?9K;m_bgRjo:O;ZoKiLDmoPAibo2nd:o;hC[l_P?]bo2nd:o;hC[l_P?]bo2nd:o;hC[l_P?]bo2nd:"
            A$ = A$ + "o;hC[l_P?]bo36E;o;9K;m_bgRjoCfVCoCKTkm?kPKmo\k=eoc^gEo?kNGmo\kMeoc^gEo?kNGmo\kMeoc^gEo?kNGmo\kMeoc^g"
            A$ = A$ + "Eo?kNCmo\3^eoCKTkmoT]ido36e;o[[TgmO^ANgoj:iMo[[Tgm_^BNgoj:iMo[[Tgm_^BNgoj:iMo[[Tgm_^BNgoj:iMo[[Tgm_^"
            A$ = A$ + "BNgoi6iMoc[W8noPAmbo22E;o[[TgmochJjo?S[Yoo<^VnochJjo?S[Yoo<^VnochJjo?S[Yoo<^VnochJjo?S[Yoo<^VnochJjo"
            A$ = A$ + "?S[Yoc;W5n_P@ebo22E;o[[Tgmodm^joCgkZo?M_[nodm^joCgkZo?M_[nodm^joCgkZo?M_[nodm^joCgkZo?M_[nodm^joCgkZ"
            A$ = A$ + "o_[V3n_P@ebo22E;o[[Tgm?f27koH;L\oS]`an?f27koH;L\oS]`an?f27koH;L\oS]`an?f27koH;L\oS]`an?f27koH;L\o[kU"
            A$ = A$ + "om_P@ebo22E;o[[Tgm_g:_koN[l^ok]bkn_g:_koN[l^ok]bkn_g:_koN[l^ok]bkn_g:_koN[l^ok]bkn_g:_koN[l^o[KUlm_P"
            A$ = A$ + "@ebo22E;o[[Tgm_h?7loRoL`o;nc1o_h?7loRoL`o;nc1o_h?7loRoL`o;nc1o_h?7loRoL`o;nc1o_h?7loRoL`o[kTim_P@ebo"
            A$ = A$ + "22E;o[[TgmoiEOloWGmaoONe7ooiEOloWGmaoONe7ooiEOloWGmaoONe7ooiEOloWGmaoONe7ooiEOloWGmaoWKTgm_P@ebo22E;"
            A$ = A$ + "o[[TgmojL3mo[c=do_>g@oojL3mo[c=do_>g@oojL3mo[c=do_>g@oojL3mo[c=do_>g@oojL3mo[c=doWKTgm_P@ebo22E;o[[T"
            A$ = A$ + "gmol[?noc_nho?ojSool[?noc_nho?ojSool[?noc_nho?ojSool[?noc_nho?ojSool[?noc_nhoWKTgm_P@ebo22E;o[[TgmOm"
            A$ = A$ + "aWnoe7OjoGOlYoOmaWnoe7OjoGOlYoOmaWnoe7OjoGOlYoOmaWnoe7OjoGOlYoOmaWnoe7OjoWKTgm_P@ebo22E;o[[Tgmomdgno"
            A$ = A$ + "gCOkoO?m]oomdgnogCOkoO?m]oomdgnogCOkoO?m]oomdgnogCOkoO?m]oomdgnogCOkoWKTgm_P@ebo22E;o[[TgmOnh7ooiSOl"
            A$ = A$ + "oW?naoOnh7ooiSOloW?naoOnh7ooiSOloW?naoOnh7ooiSOloW?naoOnh7ooiSOloWKTgm_P@ebo22E;o[[Tgm_njCooj[?mo[_n"
            A$ = A$ + "do_njCooj[?mo[_ndo_njCooj[?mo[_ndo_njCooj[?mo[_ndo_njCooj[?moWKTgm_P@ebo22E;o[[Tgm?olSoolc?noc?oho?o"
            A$ = A$ + "lSoolc?noc?oho?olSoolc?noc?oho?olSoolc?noc?oho?olSoolc?noWKTgm_P@ebo22E;o[[TgmOom_oomgonogOokoOom_oo"
            A$ = A$ + "mgonogOokoOom_oomgonogOokoOom_oomgonogOokoOom_oomgonoWKTgm_P@ebo22E;o[[Tgm_ongoonkOook_omo_ongoonkOo"
            A$ = A$ + "ok_omo_ongoonkOook_omo_ongoonkOook_omo_ongoonkOooWKTgm_P@ebo36e;o[[Tgmooh?oooSoloo?ncoooh?oooSoloo?n"
            A$ = A$ + "coooh?oooSoloo?ncoooh?oooSoloo?ncoooh?oooSoloWKTgmoPAmbo?JFAoS:OOmoomWooogOnooOoiooomWooogOnooOoiooo"
            A$ = A$ + "mWooogOnooOoiooomWooogOnooOoiooomWooogOnokILBm?TXMdo:O;ZoKILBmoPAmbo22E;o;8D]l_P@ebo22E;o;8D]l_P@ebo"
            A$ = A$ + "22E;o;8D]l_P@ebo22E;o;8D]l_P@ebo36U;oG9L@m_bgRjo^W>ioWLa6oOb5Klo9G\aoWLa6oOb5Klo9G\aoWLa6oOb5Klo9G\a"
            A$ = A$ + "oWLa6oOb5Klo9G\aoWLa6oOb5Klo9G\aoWLa6o_kYCno9G\aoooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooOb5Klo9G\aoooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooOb5Klo9G\aoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooOb5Klo9G\aoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooOb5Klo9G\aoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooOb5Klo9G\aoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooOb5Klo9G\aoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooOb5Klo9G\aoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooOb5Klo9G\aoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooOb5Klo9G\aooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooOb"
            A$ = A$ + "5Klo9G\aooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooOb5Klo"
            A$ = A$ + "9G\aooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooOb5Klo9G\a"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooOb5Klo9G\aoooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooOb5Klo9G\aoooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooOb5Klo9G\aoooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooOb5Klo9G\aoooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooOb5Klo9G\aoooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooOb5Klo9G\aoooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooOb5Klo^W>ioWLa6oOb5Klo9G\aoWLa6oOb5Klo"
            A$ = A$ + "9G\aoWLa6oOb5Klo9G\aoWLa6oOb5Klo9G\aoWLa6oOb5Klo9G\aoWLa6o_kYCno:O;Zo3[E]l?\Febo`JE;o3[E]l?\Febo`JE;"
            A$ = A$ + "o3[E]l?\Febo`JE;o3[E]l?\Febo`JE;o3[E]l?\Febo`JE;o3[E]l_bgRjo`JE;o?[ORm_jkjgoZ3lRo[>`;n_j0_hoZ3lRo[>`"
            A$ = A$ + ";n_j0_hoZ3lRo[>`;n_j0_hoZ3lRo[>`;n_j0_hoZ_[Oo?[ORmoT]ido`JE;oWMXam?hi>joPWkXo3N^Sn?hi>joPWkXo3N^Sn?h"
            A$ = A$ + "i>joPWkXo3N^Sn?hi>joPWkXo3N^Sn?hi>joPWkXoWMXam?\Febo`JE;o[mXdm?hkNjooSoloo?ncoooh?oooSoloo?ncoooh?oo"
            A$ = A$ + "oSoloo?ncoooh?oooSoloo?ncoooh?ooP_kYo[mXdm?\Febo`JE;oWMXbm?hh6jonkOook_omo_ongoonkOook_omo_ongoonkOo"
            A$ = A$ + "ok_omo_ongoonkOook_omo_ongooPSKXoWMXbm?\Febo`JE;oS=X`m?gefiomgonogOokoOom_oomgonogOokoOom_oomgonogOo"
            A$ = A$ + "koOom_oomgonogOokoOom_ooLG[WoS=X`m?\Febo`JE;oO]W^mOfaViolc?noc?oho?olSoolc?noc?oho?olSoolc?noc?oho?o"
            A$ = A$ + "lSoolc?noc?oho?olSooI7KVoO]W^m?\Febo`JE;oKMW\m_e]Fioj[?mo[_ndo_njCooj[?mo[_ndo_njCooj[?mo[_ndo_njCoo"
            A$ = A$ + "j[?mo[_ndo_njCooFg:UoKMW\m?\Febo`JE;oGmV[mOeZ:ioiSOloW?naoOnh7ooiSOloW?naoOnh7ooiSOloW?naoOnh7ooiSOl"
            A$ = A$ + "oW?naoOnh7ooE[JToGmV[m?\Febo`JE;oC]VYmOdVjhogCOkoO?m]oomdgnogCOkoO?m]oomdgnogCOkoO?m]oomdgnogCOkoO?m"
            A$ = A$ + "]oomdgnoAOZSoC]VYm?\Febo`JE;o;mUUm_cP>hoe7OjoGOlYoOmaWnoe7OjoGOlYoOmaWnoe7OjoGOlYoOmaWnoe7OjoGOlYoOm"
            A$ = A$ + "aWno>3jPo;mUUm?\Febo`JE;o3mTQm?bGZgoc_nho?ojSool[?noc_nho?ojSool[?noc_nho?ojSool[?noc_nho?ojSool[?no"
            A$ = A$ + "8OYNo3mTQm?\Febo`JE;oo\TOm_aCFgo[c=do_>g@oojL3mo[c=do_>g@oojL3mo[c=do_>g@oojL3mo[c=do_>g@oojL3mo6?YM"
            A$ = A$ + "oo\TOm?\Febo`JE;og<TMmo`?6goWGmaoONe7ooiEOloWGmaoONe7ooiEOloWGmaoONe7ooiEOloWGmaoONe7ooiEOlo3oHLog<T"
            A$ = A$ + "Mm?\Febo`JE;oc\SKm?`9^foRoL`o;nc1o_h?7loRoL`o;nc1o_h?7loRoL`o;nc1o_h?7loRoL`o;nc1o_h?7lo0[hJoc\SKm?\"
            A$ = A$ + "Febo`JE;o_LSIm__7NfoN[l^ok]bkn_g:_koN[l^ok]bkn_g:_koN[l^ok]bkn_g:_koN[l^ok]bkn_g:_konNhIo_LSIm?\Febo"
            A$ = A$ + "`JE;o_<SGmO_6>foH;L\oS]`an?f27koH;L\oS]`an?f27koH;L\oS]`an?f27koH;L\oS]`an?f27komJhHo_<SGm?\Febo`JE;"
            A$ = A$ + "o[\REm?_2jeoCgkZo?M_[nodm^joCgkZo?M_[nodm^joCgkZo?M_[nodm^joCgkZo?M_[nodm^jol:XGo[\REm?\Febo`JE;o3kH"
            A$ = A$ + "glO\]mcomJ8IocKPNm?_1jeol6XGocKPNm?_1jeol6XGocKPNm?_1jeol6XGocKPNmO_6BfogFGAo3kHgl?\Febo`JE;o;;IilO\"
            A$ = A$ + "]mcoaff?o7KKolO\]mcoaff?o7KKolO\]mcoaff?o7KKolO\]mcoaff?o7KKolO\]mcoaff?o;KIkl?\Febo:O;Zo3[E]l?\Febo"
            A$ = A$ + "`JE;o3[E]l?\Febo`JE;o3[E]l?\Febo`JE;o3[E]l?\Febo`JE;o3[E]l?\Febo`JE;o3[E]l_bgRjo%%%0"
        CASE "checkbox.png"
            A$ = MKI$(13) + MKI$(104)
            A$ = A$ + "0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLloeLcmoGc=goO=gLoOfNkmoK3>h"
            A$ = A$ + "ok]hRo_hUGnoUS>joW>k\o?k_ono_7Olo3HDLl?PAaaoGc=goO=gLoOfNkmoK3>hok]hRo_hUGnoUS>joW>k\o?k_ono_7Olo7ol"
            A$ = A$ + "co?PAaao0657oO=gLoOfNkmoK3>hok]hRo_hUGnoUS>joW>k\o?k_ono_7Olo7olco?meGoo0657o3HDLlOfNkmoK3>hok]hRo_h"
            A$ = A$ + "UGnoUS>joW>k\o?k_ono_7Olo7olco?meGoofOomo3HDLl?PAaaoK3>hok]hRo_hUGnoUS>joW>k\o?k_ono_7Olo7olco?meGoo"
            A$ = A$ + "fOomoSOnio?PAaao0657ok]hRo_hUGnoUS>joW>k\o?k_ono_7Olo7olco?meGoofOomoSOnio_nk_oo0657o3HDLl_hUGnoUS>j"
            A$ = A$ + "oW>k\o?k_ono_7Olo7olco?meGoofOomoSOnio_nk_oolgOoo3HDLl?PAaaoUS>joW>k\o?k_ono_7Olo7olco?meGoofOomoSOn"
            A$ = A$ + "io_nk_oolgOook_ono?PAaao0657oW>k\o?k_ono_7Olo7olco?meGoofOomoSOnio_nk_oolgOook_onooooooo0657o3HDLl?k"
            A$ = A$ + "_ono_7Olo7olco?meGoofOomoSOnio_nk_oolgOook_onoooooooooooo3HDLl?PAaao_7Olo7olco?meGoofOomoSOnio_nk_oo"
            A$ = A$ + "lgOook_onooooooooooooooooo?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657"
            A$ = A$ + "o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao?3oooKLkoo_^Yooo\B^oocig"
            A$ = A$ + "no?SIgoo4JMoocgdlo?M@coo[alno?6bko?PAaao0657oKLkoo_^Yooo\B^oocigno?SIgoo4JMoocgdlo?M@coo[alno?6bko_F"
            A$ = A$ + "5[oo0657o3HDLl_^Yooo\B^oo?niWoohWOnoSOnio?niWoohWOnoSOnio?niWo_F5[ooD9\no3HDLl?PAaao\B^oocignoohWOno"
            A$ = A$ + "SOnio?niWoohWOnoSOnio?niWoohWOnoD9\nok4`jo?PAaao0657ocigno?SIgooSOnio?niWoohWOnoSOnio?niWoohWOnoSOni"
            A$ = A$ + "ok4`jo?BmVoo0657o3HDLl?SIgoo4JMoo?niWoohWOnoSOnio?niWoohWOnoSOnio?niWo?BmVoo3]Kno3HDLl?PAaao4JMoocgd"
            A$ = A$ + "loohWOnoSOnio?niWoohWOnoSOnio?niWoohWOno3]KnokC^io?PAaao0657ocgdlo?M@cooSOnio?niWoohWOnoSOnio?niWooh"
            A$ = A$ + "WOnoSOniokC^io_>gVoo0657o3HDLl?M@coo[alno?niWoohWOnoSOnio?niWoohWOnoSOnio?niWo_>gVoofH;no3HDLl?PAaao"
            A$ = A$ + "[alno?6bko_F5[ooD9\nok4`jo?BmVoo3]KnokC^io_>gVoofH;no?3]ho?PAaao0657o?6bko_F5[ooD9\nok4`jo?BmVoo3]Kn"
            A$ = A$ + "okC^io_>gVoofH;no?3]ho?<cRoo0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HD"
            A$ = A$ + "Ll?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657oO:\`noY`2koW2;\o[j\cnO["
            A$ = A$ + "gNkoa^;_oKK`1oo^6Olo0cLcoGLdBo?bEOmo0657o3HDLloY`2koW2;\o[j\cnO[gNkoa^;_oKK`1oo^6Olo0cLcoGLdBo?bEOmo"
            A$ = A$ + "<[mfo3HDLl?PAaaoW2;\o[j\cnO[gNkoa^;_oKK`1oo^6Olo0cLcoGLdBo?bEOmo<[mfooLgOo?PAaao0657o[j\cnO[gNkoa^;_"
            A$ = A$ + "oKK`1oo^6Olo0cLcoGLdBo?bEOmo<[mfooLgOoodQ?no0657o3HDLlO[gNkoa^;_oKK`1oo^6Olo0cLcoGLdBo?bEOmo<[mfooLg"
            A$ = A$ + "OoodQ?noFG^io3HDLl?PAaaoa^;_oKK`1oo^6Olo0cLcoGLdBo?bEOmo<[mfooLgOoodQ?noFG^ioW=jZo?PAaao0657oKK`1oo^"
            A$ = A$ + "6Olo0cLcoGLdBo?bEOmo<[mfooLgOoodQ?noFG^ioW=jZoof[gno0657o3HDLlo^6Olo0cLcoGLdBo?bEOmo<[mfooLgOoodQ?no"
            A$ = A$ + "FG^ioW=jZoof[gnoMgnko3HDLl?PAaao0cLcoGLdBo?bEOmo<[mfooLgOoodQ?noFG^ioW=jZoof[gnoMgnkoomkao?PAaao0657"
            A$ = A$ + "oGLdBo?bEOmo<[mfooLgOoodQ?noFG^ioW=jZoof[gnoMgnkoomkaoog_7oo0657o3HDLl?bEOmo<[mfooLgOoodQ?noFG^ioW=j"
            A$ = A$ + "Zoof[gnoMgnkoomkaoog_7ooOoNlo3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?P"
            A$ = A$ + "Aaao9G\aoWLa6oOb5Klo9G\aoWLa6oOb5Klo9G\aoWLa6oOb5Klo9G\aoWLa6oOb5Klo9G\aoWLa6ooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooWLa6oOb5Klooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooOb5Klo9G\aoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo9G\aoWLa6ooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooWLa6oOb5Klooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooOb5Klo9G\aoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo9G\aoWLa6ooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooWLa6oOb5Klooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooOb5Klo9G\aoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo9G\aoWLa"
            A$ = A$ + "6ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooWLa6oOb5Klooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooOb5Klo9G\aoWLa6oOb5Klo9G\aoWLa6oOb5Klo9G\aoWLa6oOb5Klo9G\aoWLa6oOb5Klo"
            A$ = A$ + "9G\ao3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaaoM;^hog]hRoOgR;noO?nh"
            A$ = A$ + "o7NiUoohWOnoV[^joW>k\o?k_ono_7Olo7olco?PAaao0657og]hRoOgR;noO?nho7NiUoohWOnoV[^joW>k\o?k_ono_7Olo7ol"
            A$ = A$ + "cooleGoo0657o3HDLlOgR;noO?nho7NiUoohWOnoV[^joW>k\o?k_ono_7Olo7BXQloleGoofOomo3HDLl?PAaaoO?nho7NiUooh"
            A$ = A$ + "WOnoV[^joW>k\o?k_ono_7Olo7BXQlO8Q6bofOomoSOnio?PAaao0657o7NiUoohWOnoQ4J8oW>k\o?k_ono_7Olo7BXQlO8Q6bo"
            A$ = A$ + "Q4J8oSOnioOnj[oo0657o3HDLlohWOnoV[^jo7BXQlO8Q6bo_7Olo7BXQlO8Q6boQ4J8oSOnioOnj[ookc?oo3HDLl?PAaaoV[^j"
            A$ = A$ + "oW>k\oO8Q6boQ4J8o7BXQlO8Q6boQ4J8oSOnioOnj[ookc?oogOomo?PAaao0657oW>k\o?k_ono_7Olo7BXQlO8Q6boQ4J8oSOn"
            A$ = A$ + "ioOnj[ookc?oogOomo_onkoo0657o3HDLl?k_ono_7Olo7olcooleGooQ4J8oSOnioOnj[ookc?oogOomo_onkooooooo3HDLl?P"
            A$ = A$ + "Aaao_7Olo7olcooleGoofOomoSOnioOnj[ookc?oogOomo_onkoooooooooooo?PAaao0657o7olcooleGoofOomoSOnioOnj[oo"
            A$ = A$ + "kc?oogOomo_onkoooooooooooooooooo0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657"
            A$ = A$ + "o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657oo<loo_a]ooojVnooc:i"
            A$ = A$ + "no?WOkoo<VMooW8fmoOUKgooGbMooOXelo_J:_oo0657o3HDLl_a]ooojVnooc:ino?WOkoo<VMooW8fmoOUKgoo\>NooK[imo_X"
            A$ = A$ + "Ngooj1mno3HDLl?PAaaomZnoocKjnoOmgOoodK_mo??mdo?mfKoogS?noW_njoO8Q6bo^>Noo3Xdko?PAaao0657ocKjno?a\koo"
            A$ = A$ + "i[_noO?nho?mfKoogS?noW_njoO8Q6boQ4J8o_JhmooN@_oo0657o3HDLlO]Wkoo7c^oo7BXQlOnj[oogS?noW_njoO8Q6boQ4J8"
            A$ = A$ + "o7BXQl?ZPgoogilno3HDLl?PAaaoY>^oo?ljnoO8Q6boQ4J8oW_njoO8Q6boQ4J8o7BXQlOnj[ooBRmnoO6bjo?PAaao0657o?:h"
            A$ = A$ + "noo_YkooQ4J8o7BXQlO8Q6boQ4J8o7BXQlOnj[oogS?noO6bjo_AlVoo0657o3HDLlOUKgoo\>NooW_njoO8Q6boQ4J8o7BXQlOn"
            A$ = A$ + "j[oogS?noC_mfo_AlVoojLKno3HDLl?PAaaoj9=ooOXeloomhSooi[_no7BXQlOnj[oogS?noC_mfooldCoojLKnoKS]ho?PAaao"
            A$ = A$ + "0657o_6cko_J:_ooj1mnoWiflo?ZPgooBRmnoO6bjo_AlVoojLKnoKS]hoo<dRoo0657o3HDLloH8_ooJE\no_Eajo?L<_oogiln"
            A$ = A$ + "oO6bjo_AlVoojLKnoKS]hoo<dRoo`<;no3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HD"
            A$ = A$ + "Ll?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLloY`2koW2;\oO:\`n_Z"
            A$ = A$ + "c>ko]Nk]o7k^ln_]17lokJlao3<c=oOaA;mo8Gmeo3HDLl?PAaaoW2;\oO:\`n_Zc>ko]Nk]o7k^ln_]17lokJlao3<c=oOaA;mo"
            A$ = A$ + "8Gmeoc\fKo?PAaao0657oO:\`n_Zc>ko]Nk]o7k^ln_]17lokJlao3<c=oOaA;moJH87oc\fKoocMomo0657o3HDLl_Zc>ko]Nk]"
            A$ = A$ + "o7k^ln_]17lokJlao3<c=oOaA;moJH87o[QRLlocMomoC7nho3HDLl?PAaao]Nk]o7k^ln?6jUaokJlao3<c=oOaA;moJH87o[QR"
            A$ = A$ + "Llo6<faoC7nhoKMiVo?PAaao0657o7k^ln_]17loHdW6oWAPKlOaA;moJH87o[QRLlo6<faoC7nhoKMiVoOfX[no0657o3HDLl_]"
            A$ = A$ + "17lokJlaoWAPKlO64^aoJH87o[QRLlo6<faoC7nhoKMiVoOfX[noK_Nko3HDLl?PAaaokJlao3<c=oOaA;moJH87o[QRLlo6<fao"
            A$ = A$ + "C7nhoKMiVoOfX[noK_NkogMk_o?PAaao0657o3<c=oOaA;mo8Gmeoc\fKoo6<faoC7nhoKMiVoOfX[noK_NkogMk_oog_7oo0657"
            A$ = A$ + "o3HDLlOaA;mo8Gmeoc\fKoocMomoC7nhoKMiVoOfX[noK_NkogMk_oog_7ooOoNlo3HDLl?PAaao8Gmeoc\fKoocMomoC7nhoKMi"
            A$ = A$ + "VoOfX[noK_NkogMk_oog_7ooOoNloomkao?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?PAaao0657o3HDLl?P"
            A$ = A$ + "Aaao0657oWLa6oOb5Klo9G\aoWLa6oOb5Klo9G\aoWLa6oOb5Klo9G\aoWLa6oOb5Klo9G\aoWLa6oOb5Klooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooOb5Klo9G\aoooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooo9G\aoWLa6ooooooooooooooooooooooooooooooooooooooooooooWLa6ooooooooooooWLa6oOb5Klooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooWLa6oOb5KloooooooooooOb5Klo9G\aoooooooooooo9G\aoooooooooooooooooWLa6oOb"
            A$ = A$ + "5Klo9G\aoooooooooooo9G\aoWLa6ooooooooooooWLa6oOb5KlooooooWLa6oOb5Klo9G\aoooooooooooooooooWLa6oOb5Klo"
            A$ = A$ + "ooooooooooOb5Klo9G\aoWLa6oOb5Klo9G\aooooooooooooooooooooooOb5Klo9G\aoooooooooooooooooWLa6oOb5Klo9G\a"
            A$ = A$ + "oooooooooooooooooooooooooooo9G\aoWLa6ooooooooooooooooooooooo9G\aoooooooooooooooooooooooooooooooooWLa"
            A$ = A$ + "6oOb5KloooooooooooooooooooooooooooooooooooooooooooooooooooooooooooOb5Klo9G\aoooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooo9G\aoWLa6oOb5Klo9G\aoWLa6oOb5Klo9G\aoWLa6oOb5Klo9G\aoWLa6oOb5Klo"
            A$ = A$ + "9G\aoWLa%6o?"
        CASE "notfound.png"
            A$ = MKI$(40) + MKI$(48)
            A$ = A$ + "S=fHnS6JXM?JXQfmXQ6JgS6JXM?JXQfmXQ6JgS6JXM?JXQfmXQ6JgS6JXM?JXQfmXQ6JgS6JXM?JXQfmXQ6JgS6JXM?JXQfmXQ6J"
            A$ = A$ + "gS6JXM?JXQfmXQ6JgS6JXM?JXQfmXQ6JgS6JXM?JXQfmVIVIkWFJYi4000000000000000000000000000000000000000000000"
            A$ = A$ + "0000000000000XVJZIoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooooooooooooooooo7GLam?L`1glUEFI>100000000000000000000000000"
            A$ = A$ + "00000000000000000000000000PJZYVmoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo?MdAgoTC>io37L`9oIWMFC00000000"
            A$ = A$ + "0000000000000000000000000000000000000000ZYVJfooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooodA7Mo[_njo?jXSno"
            A$ = A$ + "`17LbGFIUa4000000000000000000000000000000000000000000XVJZIoooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooC7M"
            A$ = A$ + "dm_nj[oooooooOniWo?L`1WlUEFI<1000000000000000000000000000000000000PJZYVmoooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooo?MdAgoj[_nooooooooooooWOnio37L`5?ITAFA00000000000000000000000000000000ZYVJfooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooodA7Mo[_njooooooooooooooooooiWOno`17LaGFIUA400000000000000000000000000XVJZIoo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooC7Mdm_nj[oooooooooooooooooooooooOniWo?L`17lS=fH3100000000000000"
            A$ = A$ + "000000PJZYVmoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooo?MdAgoj[_nooooooooooooooooooooooooooooWOnioofK_5?I"
            A$ = A$ + "TAV@0000000000000000ZYVJfooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooodA7Mo[_njooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooohS?no^iVKb;VHR540000000000XVJZIoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooC7Mdm_nj[oooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooo;^hRo_K^iVlR9VH110000PJZYVmoooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo?MdAgoj[_n"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooooR;^hokVK^9?ITA6@ZYVJfooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooomgOogFK]mOK]efo]eFKogFK]mOK]efo]eFKogFK]mOK]efo]eFKogFK]moJ[]foVIVIj[VJZIoooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo[VJZI_JZYVmoooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooo_mfKooQ7Nho7NhQoOhQ7noQ7Nho7NhQoOhQ7noQ7Nho7NhQoOhQ7noQ7Nho7NhQoOh"
            A$ = A$ + "Q7noQ7Nho7NhQoOhQ7noQ7Nho7NhQoOhQ7noQ7Nho7NhQo_mfKoooooooooooooooooooooooooooooooooooooooooooo_JZYVm"
            A$ = A$ + "ZYVJfoooooooooooooooooooooooooooooooooooooooooooFK]eoWK^in_b:[lo:[\bo[\b:o_b:[lo:[\bo[\b:o_b:[lo:[\b"
            A$ = A$ + "o[\b:o_b:[lo:[\bo[\b:o_b:[lo:[\bo[\b:o_b:[lo:[\bo[\b:oO^iVkoFK]eoooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooZYVJf[VJZIoooooooooooooooooooooooooooooooooooooooooooK]eFo_eFKmooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooFK]eoK]eFooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooo[VJZI_JZYVmoooooooooooooooooooooooooooooooooooooooooo_eFKmoFK]eoooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooK]eFo_eFKmooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooo_JZYVmZYVJfoooooooooooooooooooooooooooooooooooooooooooFK]eoK]eFooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo_eFKmo"
            A$ = A$ + "FK]eooooooooooooooooooooooooooooooooooooooooooooZYVJf[VJZIoooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oK]eFo_eFKmooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooFK]eoK]eFoooooooooooooooooooooooooooooooooooooooooooo[VJZI_JZYVmoooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooo_eFKmoFK]eoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooK]eFo_eFKmooooooooooooooooooooooooooooooooooooooooooo_JZYVmZYVJfooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooFK]eoK]eFooooooooooooooooo_lbgooc=WkoC=ejooooooooooooooooooooooooooooooo"
            A$ = A$ + "oo?eD[ooc=Wko;_lmooooooooooooooooo_eFKmoFK]eooooooooooooooooooooooooooooooooooooooooooooZYVJf[VJZIoo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooK]eFo_eFKmooooooooooooooooo5G<no300PoO5E<noB;]noooooooooooo"
            A$ = A$ + "oooooooooo_dB[ooEDaho300PoOa5SooooooooooooooooooFK]eoK]eFooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "o[VJZI_JZYVmoooooooooooooooooooooooooooooooooooooooooo_eFKmoFK]eoooooooooooooooooooooooNkmno000hoGA5"
            A$ = A$ + "SoodC[ooooooooooooodC[ooEDaho300PooNkmnooooooooooooooooooooooK]eFo_eFKmooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooo_JZYVmZYVJfoooooooooooooooooooooooooooooooooooooooooooFK]eoK]eFooooooooooooooooooooooo"
            A$ = A$ + "oooooc7O_o?000noEDaho?mdjooeG[ooHPaho300Po?Mdinooooooooooooooooooooooooooo_eFKmoFK]eoooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooZYVJf[VJZIoooooooooooooooooooooooooooooooooooooooooooK]eFo_eFKmooooooooo"
            A$ = A$ + "ooooooooooooooooooooooook]gko300Poo4C8noEDaho300PooLcinoooooooooooooooooooooooooooooooooFK]eoK]eFooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooo[VJZI_JZYVmoooooooooooooooooooooooooooooooooooooooooo_eFKmo"
            A$ = A$ + "FK]eoooooooooooooooooooooooooooooooooooooooIWano000ho300PooGOanooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oK]eFo_eFKmooooooooooooooooooooooooooooooooooooooooooo_JZYVmZYVJfooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooFK]eoK]eFoooooooooooooooooooooooooooooooooOfI[ooJXaho300Po?000noFHahoC=ejooooooooooooooooooo"
            A$ = A$ + "oooooooooooooo_eFKmoFK]eooooooooooooooooooooooooooooooooooooooooooooZYVJf[VJZIoooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooK]eFo_eFKmoooooooooooooooooooooooooooOfI[ooJXaho300Po?L`inoiUgko300Poo5G<noEG]n"
            A$ = A$ + "ooooooooooooooooooooooooooooFK]eoK]eFoooooooooooooooooooooooooooooooooooooooooooo[VJZI_JZYVmoooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooo_eFKmoFK]eoooooooooooooooooooooo_fJ[ooJXaho300Po?L`inooooooooooo?N"
            A$ = A$ + "hmno000hoOa5SoOeE[oooooooooooooooooooooooK]eFo_eFKmooooooooooooooooooooooooooooooooooooooooooo_JZYVm"
            A$ = A$ + "ZYVJfoooooooooooooooooooooooooooooooooooooooooooFK]eoK]eFooooooooooooooooo?jXcooJXaho300PooK_enooooo"
            A$ = A$ + "ooooooooooooooooo37L^o?000noJXahoOnilooooooooooooooooo_eFKmoFK]eoooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooZYVJf[VJZIoooooooooooooooooooooooooooooooooooooooooooK]eFo_eFKmoooooooooooooooooA7MnoG@1Qo?L"
            A$ = A$ + "`inonkoooooooooooooooooooooooo_onoooa5WkoG@1Qo?d@WooooooooooooooooooFK]eoK]eFooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooo[VJZI_JZYVmoooooooooooooooooooooooooooooooooooooooooo_eFKmoFK]eoooooooooooooooo"
            A$ = A$ + "oooooo_mfkoooooooooooooooooooooooooooooooooooooooooooo_mfkoooooooooooooooooooooooK]eFo_eFKmooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooo_JZYVmZYVJfoooooooooooooooooooooooooooooooooooooooooooFK]eoK]eFooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo_eFKmo"
            A$ = A$ + "FK]eooooooooooooooooooooooooooooooooooooooooooooZYVJf[VJZIoooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oK]eFo_eFKmooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooFK]eoK]eFoooooooooooooooooooooooooooooooooooooooooooo[VJZI_JZYVmoooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooo_eFKmoFK]eoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooK]eFo_eFKmooooooooooooooooooooooooooooooooooooooooooo_JZYVmZYVJfooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooFK]eoK]eFooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooo_eFKmoFK]eooooooooooooooooooooooooooooooooooooooooooooZYVJf[VJZIoo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooK]eFo?d@3moc?olo?olcoolc?ooc?olo?olcoolc?ooc?olo?olcoolc?oo"
            A$ = A$ + "c?olo?olcoolc?ooc?olo?olcoolc?ooc?olo?olcoolc?oo@3=doK]eFooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "o[VJZI_JZYVmoooooooooooooooooooooooooooooooooooooooooo_hR;nohR;^oS;^hn?^hRkohR;^oS;^hn?^hRkohR;^oS;^"
            A$ = A$ + "hn?^hRkohR;^oS;^hn?^hRkohR;^oS;^hn?^hRkohR;^oS;^hn?^hRkohR;^oS;^hn_hR;nooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooo_JZYVmZYVJfooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooZYVJf[VJZIoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooo[VJZI_JZYVmoooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooo_JZYVmZYVJfooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooZYVJf[VJZIoooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo[VJZI_JZYVmoooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo_JZYVm"
            A$ = A$ + "ZYVJfooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooZYVJf[VJZIoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
            A$ = A$ + "ooooooooooooooooooooo[VJZIoHS=VoXQ6JgS6JXM?JXQfmXQ6JgS6JXM?JXQfmXQ6JgS6JXM?JXQfmXQ6JgS6JXM?JXQfmXQ6J"
            A$ = A$ + "gS6JXM?JXQfmXQ6JgS6JXM?JXQfmXQ6JgS6JXM?JXQfmXQ6JgS6JXM?JXQfmXQ6JgS6JXM?JXQfmXQ6JgS6JXM?JXQfmXQ6JgS6J"
            A$ = A$ + "XM?JXQfmXQ6JgS6JXM?JXQfmXQ6JgS6JXMoHS=Vo%%%0"
        CASE "sliderdown.png"
            A$ = MKI$(11) + MKI$(105)
            A$ = A$ + "o3`oo?mbnnOc5Kko=CL]og<aenOc4Gko=CL]og<aen?bonjon:kWoo?0oood;kkoa6]YokFd_mOI>OfoTi\IoCVcVm?I>KfoQe\H"
            A$ = A$ + "o?d`5m_M\>foVZiQogLafn_KAofoRelHoODa9m_A4Odo6AlAoK4a7mo@3GdoOLK8oc1YMlOV>fgo=CL]oGVcWmoA5WdoSTK9oo1^"
            A$ = A$ + "Qlo7h6boOPK8oo1^Ql?7WjaoIHi6o;9RgmOc4GkoQ?=eooooooOla7ooPC=eo7ndDo?hDCmoBK\ao;]a6o?afNkoBRhMog<aenOh"
            A$ = A$ + "CCmoooooo7Olao?hDCmoQ?=eo3>eDo_d6KloBK\aoC\]gn_T8Ngo=CL]o7ndDoooooooa7Olo3>eDoOhCCmoPC=eo;]a6o_d6Klo"
            A$ = A$ + "4Kk]o;9RgmOc4GkoQ?=eooooooOla7ooPC=eo7ndDo?hDCmoBK\ao;]a6o?afNkoBRhMog<aenOhCCmoooooo7Olao?hDCmoQ?=e"
            A$ = A$ + "o3>eDo_d6KloBK\aoC\]gn_T8Ngo=CL]o7ndDoooooooa7Olo3>eDoOhCCmoPC=eo;]a6o_d6Klo4Kk]o;9RgmOc4GkoQ?=eoooo"
            A$ = A$ + "ooOla7ooPC=eo7ndDo?hDCmoBK\ao;]a6o?afNkoBRhMog<aenOhCCmoooooo7Olao?hDCmoQ?=eo3>eDo_d6KloBK\aoC\]gn_T"
            A$ = A$ + "8Ngo=CL]o7ndDoooooooa7Olo3>eDoOhCCmoPC=eo;]a6o_d6Klo4Kk]o;9RgmOc4GkoQ?=eo7ndDoooooooPC=eo3>eDo?hDCmo"
            A$ = A$ + "]ONio7ndDo?afNkoBRhMoSl__nOB5_doQ?=eo7ndDoooooooPC=eogniUoOhCCmo4Kk]oWaTJloT9Rgon:kWo_G\Ymo7h6boQ?=e"
            A$ = A$ + "o7ndDoooooooQ?=eoC\]gn?6AZaoJA8CoghPbmoo0loobJJToK7[Smo7f6boQ?=eo7ndDo?afNkoH4Y6oWUP;m?Rnifoo3`ooo?0"
            A$ = A$ + "oooo0loobJJToK7[Smo7f6boQ?=eoSATJlOF2^do8jWKoo?0oooo0looo3`ooo?0oooo0loobJJToK7[Smo6RfaoI9hBoSXO^moo"
            A$ = A$ + "0looo3`ooo?0oooo0looo3`ooo?0oooo0loobJJToS6VHm?Rnifoo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0loo"
            A$ = A$ + "N:9Poo?0oooo0looo3`ooo?0oooo0looo3`oo?mbnnOc5Kko=CL]og<aenOc4Gko=CL]og<aen?bonjon:kWoo?0oood;kkof2Mf"
            A$ = A$ + "ocWcko?M<_ood]lnoCgbko?M;_oo`YlnoG5`jooO[^koVZiQogLafn?O>_ooaYlnoWU`jo?F1[ooH5\noSE`joOE0[ooe<kmoo2X"
            A$ = A$ + "NoOV>fgo=CL]oC7ckoOF2[ooiDKnoG3]ioO=dVooe@KnoG3]io?<T>no[<ibo;9RgmOc4GkoQ?=eooooooOla7ooPC=eo7ndDo?h"
            A$ = A$ + "DCmoBK\ao;]a6o?afNkoBRhMog<aenOhCCmoooooo7Olao?hDCmoQ?=eo3>eDo_d6KloBK\aoC\]gn_T8Ngo=CL]o7ndDooooooo"
            A$ = A$ + "a7Olo3>eDoOhCCmoPC=eo;]a6o_d6Klo4Kk]o;9RgmOc4GkoQ?=eooooooOla7ooPC=eo7ndDo?hDCmoBK\ao;]a6o?afNkoBRhM"
            A$ = A$ + "og<aenOhCCmoooooo7Olao?hDCmoQ?=eo3>eDo_d6KloBK\aoC\]gn_T8Ngo=CL]o7ndDoooooooa7Olo3>eDoOhCCmoPC=eo;]a"
            A$ = A$ + "6o_d6Klo4Kk]o;9RgmOc4GkoQ?=eooooooOla7ooPC=eo7ndDo?hDCmoBK\ao;]a6o?afNkoBRhMog<aenOhCCmoooooo7Olao?h"
            A$ = A$ + "DCmoQ?=eo3>eDo_d6KloBK\aoC\]gn_T8Ngo=CL]o7ndDoooooooa7Olo3>eDoOhCCmoPC=eo;]a6o_d6Klo4Kk]o;9RgmOc4Gko"
            A$ = A$ + "Q?=eo7ndDoooooooPC=eo3>eDo?hDCmo]ONio7ndDo?afNkoBRhMoSl__noF2[ooQ?=eo7ndDoooooooPC=eogniUoOhCCmo4Kk]"
            A$ = A$ + "o[2T7ooT9Rgon:kWoC8\0oO=dVooQ?=eo7ndDoooooooQ?=eoC\]gn_:>BloQ=hSoghPbmoo0loobJJTokgZjn?=bJooQ?=eo7nd"
            A$ = A$ + "Do?afNkoZh8ao3VP>n?Rnifoo3`ooo?0oooo0loobJJTokgZjn?=bJooQ?=eo[RS4o?H2jho8jWKoo?0oooo0looo3`ooo?0oooo"
            A$ = A$ + "0loobJJTokgZjno;N^moP9XSoSXO^moo0looo3`ooo?0oooo0looo3`ooo?0oooo0loobJJTo3gUUn?Rnifoo3`ooo?0oooo0loo"
            A$ = A$ + "o3`ooo?0oooo0looo3`ooo?0oooo0looN:9Poo?0oooo0looo3`ooo?0oooo0looo3`oo?mbnnOc5Kko=CL]og<aenOc4Gko=CL]"
            A$ = A$ + "og<aen?bonjon:kWoo?0oood;kko]R\YoKV^`m?GfNfoKI[Io_U]VmoFfJfoHAkHoSSY6m?LN>foVZiQogLafn_Ij2goIE;Iog3Z"
            A$ = A$ + ":mo>WRdokL:Bo_cY8m?>VJdoB@Y8o3AQNlOV>fgo=CL]ocU]WmO?XZdoGLY9o;AURl_4E:boBDY8o;AURl?48nao?X77o;9RgmOc"
            A$ = A$ + "4GkoQ?=eooooooOla7ooPC=eo7ndDo?hDCmoBK\ao;]a6o?afNkoBRhMog<aenOhCCmoooooo7Olao?hDCmoQ?=eo3>eDo_d6Klo"
            A$ = A$ + "BK\aoC\]gn_T8Ngo=CL]o7ndDoooooooa7Olo3>eDoOhCCmoPC=eo;]a6o_d6Klo4Kk]o;9RgmOc4GkoQ?=eooooooOla7ooPC=e"
            A$ = A$ + "o7ndDo?hDCmoBK\ao;]a6o?afNkoBRhMog<aenOhCCmoooooo7Olao?hDCmoQ?=eo3>eDo_d6KloBK\aoC\]gn_T8Ngo=CL]o7nd"
            A$ = A$ + "Doooooooa7Olo3>eDoOhCCmoPC=eo;]a6o_d6Klo4Kk]o;9RgmOc4GkoQ?=eooooooOla7ooPC=eo7ndDo?hDCmoBK\ao;]a6o?a"
            A$ = A$ + "fNkoBRhMog<aenOhCCmoooooo7Olao?hDCmoQ?=eo3>eDo_d6KloBK\aoC\]gn_T8Ngo=CL]o7ndDoooooooa7Olo3>eDoOhCCmo"
            A$ = A$ + "PC=eo;]a6o_d6Klo4Kk]o;9RgmOc4GkoQ?=eo7ndDoooooooPC=eo3>eDo?hDCmo]ONio7ndDo?afNkoBRhMoSl__no?YbdoQ?=e"
            A$ = A$ + "o7ndDoooooooPC=eogniUoOhCCmo4Kk]ok`MKloT9Rgon:kWoGgXYm_4E:boQ?=eo7ndDoooooooQ?=eoC\]gn_3e]aoFU7CoghP"
            A$ = A$ + "bmoo0loobJJTo3WWSm_4C:boQ?=eo7ndDo?afNko>Dg6oG5N;m?Rnifoo3`ooo?0oooo0loobJJTo3WWSm_4C:boQ?=eok@MKlOE"
            A$ = A$ + "h]do8jWKoo?0oooo0looo3`ooo?0oooo0loobJJTo3WWSm?43jaoEQgBoSXO^moo0looo3`ooo?0oooo0looo3`ooo?0oooo0loo"
            A$ = A$ + "bJJTo?6SHm?Rnifoo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looN:9Poo?0oooo0looo3`ooo?0oooo0looo3`o"
            A$ = A$ + "o?mbnnOc5Kko=CL]og<aenOc4Gko=CL]og<aen?bonjon:kWoo?0oood;kkof2MfocWcko?M<_ood]lnoCgbko?M;_oo`YlnoG5`"
            A$ = A$ + "jooO[^koVZiQogLafn?O>_ooaYlnoWU`jo?F1[ooH5\noSE`joOE0[ooe<kmoo2XNoOV>fgo=CL]oC7ckoOF2[ooiDKnoG3]ioO="
            A$ = A$ + "dVooe@KnoG3]io?<T>no[<ibo;9RgmOc4GkoQ?=eooooooOla7ooPC=eo7ndDo?hDCmoBK\ao;]a6o?afNkoBRhMog<aenOhCCmo"
            A$ = A$ + "ooooo7Olao?hDCmoQ?=eo3>eDo_d6KloBK\aoC\]gn_T8Ngo=CL]o7ndDoooooooa7Olo3>eDoOhCCmoPC=eo;]a6o_d6Klo4Kk]"
            A$ = A$ + "o;9RgmOc4GkoQ?=eooooooOla7ooPC=eo7ndDo?hDCmoBK\ao;]a6o?afNkoBRhMog<aenOhCCmoooooo7Olao?hDCmoQ?=eo3>e"
            A$ = A$ + "Do_d6KloBK\aoC\]gn_T8Ngo=CL]o7ndDoooooooa7Olo3>eDoOhCCmoPC=eo;]a6o_d6Klo4Kk]o;9RgmOc4GkoQ?=eooooooOl"
            A$ = A$ + "a7ooPC=eo7ndDo?hDCmoBK\ao;]a6o?afNkoBRhMog<aenOhCCmoooooo7Olao?hDCmoQ?=eo3>eDo_d6KloBK\aoC\]gn_T8Ngo"
            A$ = A$ + "=CL]o7ndDoooooooa7Olo3>eDoOhCCmoPC=eo;]a6o_d6Klo4Kk]o;9RgmOc4GkoQ?=eo7ndDoooooooPC=eo3>eDo?hDCmo]ONi"
            A$ = A$ + "o7ndDo?afNkoBRhMoSl__noF2[ooQ?=eo7ndDoooooooPC=eogniUoOhCCmo4Kk]o[2T7ooT9Rgon:kWoC8\0oO=dVooQ?=eo7nd"
            A$ = A$ + "DoooooooQ?=eoC\]gn_:>BloQ=hSoghPbmoo0loobJJTokgZjn?=bJooQ?=eo7ndDo?afNkoZh8ao3VP>n?Rnifoo3`ooo?0oooo"
            A$ = A$ + "0loobJJTokgZjn?=bJooQ?=eo[RS4o?H2jho8jWKoo?0oooo0looo3`ooo?0oooo0loobJJTokgZjno;N^moP9XSoSXO^moo0loo"
            A$ = A$ + "o3`ooo?0oooo0looo3`ooo?0oooo0loobJJTo3gUUn?Rnifoo3`ooo?0oooo0looo3`ooo?0oooo0looo3`ooo?0oooo0looN:9P"
            A$ = A$ + "oo?0oooo0looo3`ooo?0oooo0looo3`oo[\eIooaDOmo6C]eoK<eFo_aDKmo6C]eoK<eFo?aBGmoojLdoo?0oo_bFWmo;G=foO\d"
            A$ = A$ + "Co_aA;mo63]doK<dBo_a@;mo53]do3<c>o_^7[loeF<boO<eGooaB?mo53]do7<c>o?`<klo0c\co3<c>o?`<kloiJ<bo;[_0o?\"
            A$ = A$ + "o:lo6C]eok^mgo?keKooZCOmo[>meo_jdGooZCOmo[>meo_h[cnoI?>iog:_on_aDKmo^KomocNmfo_jdGooZCOmo[>meo_jdGoo"
            A$ = A$ + "ZCOmo;nj\oOfR?no]bk_oK<eFo_kfOoo\G_mo[>meo_jdGooZCOmo[>meo_jdGooR_>koW]hSoO[lnko6C]eok^mgo?keKooZCOm"
            A$ = A$ + "o[>meo_jdGooZCOmo[>meo_h[cnoI;nhog:_on_aDKmo^KomocNmfo_jdGooZCOmo[>meo_jdGooZCOmo;nj\oOfR?no]bk_oK<e"
            A$ = A$ + "Fo_kfOoo\G_mo[>meo_jdGooZCOmo[>meo_jdGooR_>koW]hSoO[lnko6C]eok^mgo?keKooZCOmo[>meo_jdGooZCOmo[>meo_h"
            A$ = A$ + "[cnoI;nhog:_on_aDKmo^KomocNmfo_jdGooZCOmo[>meo_jdGooZCOmo;nj\oOfR?no]bk_oK<eFo_kfOoo\G_mo[>meo_jdGoo"
            A$ = A$ + "ZCOmo[>meo_jdGooR_>koW]hSoO[lnko6C]eok^mgo?keKooZCOmo[>meo_jdGooZCOmo[>meo_h[cnoI;nhog:_on_aDKmo]Kom"
            A$ = A$ + "ocNmfo_jdGooZCOmo[>meo_jdGooY??mo7^j[oOfR?no]bk_oC\dEo?keKoo[G_mo[>meo_jdGooZCOmoWnldoOi_3ooLKnioSMh"
            A$ = A$ + "RoO[lnkoojLdoc[b=o_jdGooY??mo[>meoOjcCooUo>logmiXooeP7noYJK^o_J^lnoo0loojV<co[ka:oOjcCooY??moGnk`oOg"
            A$ = A$ + "WSnoG3NhoWZ]inOZh^koo3`ooo?0oooo0loojV<co[ka:oOjcCooPW^joO=hQoOZfVkoYRk^oo?0oooo0looo3`ooo?0oooo0loo"
            A$ = A$ + "jV<co[ka:oogYWnoYJK^oW:^knoo0looo3`ooo?0oooo0looo3`ooo?0oooo0loojV<co;;`2oOZh^koo3`ooo?0oooo0looo3`o"
            A$ = A$ + "oo?0oooo0looo3`ooo?0oooo0looa6l`oo?0oooo0looo3`ooo?0oooo0loo%%%0"
    END SELECT
    __UI_ImageData$ = A$
END FUNCTION
SUB __UI_LoadForm
    DIM __UI_NewID AS LONG, __UI_RegisterResult AS LONG
    __UI_NewID = __UI_NewControl(__UI_Type_Form, "NintendoSwitchHIDTest", 537, 337, 0, 0, 0)
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Nintendo Switch HID Test"
    Control(__UI_NewID).Font = SetFont("segoeui.ttf", 12)
    __UI_NewID = __UI_NewControl(__UI_Type_Button, "UpBT", 33, 42, 66, 135, 0)
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "^"
    Control(__UI_NewID).CanHaveFocus = True
    __UI_NewID = __UI_NewControl(__UI_Type_Button, "DownBT", 33, 42, 66, 217, 0)
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "v"
    Control(__UI_NewID).CanHaveFocus = True
    __UI_NewID = __UI_NewControl(__UI_Type_Button, "RightBT", 42, 33, 104, 180, 0)
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, ">"
    Control(__UI_NewID).CanHaveFocus = True
    __UI_NewID = __UI_NewControl(__UI_Type_Button, "LeftBT", 42, 33, 19, 180, 0)
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "<"
    Control(__UI_NewID).CanHaveFocus = True
    __UI_NewID = __UI_NewControl(__UI_Type_Button, "LBumperBT", 80, 23, 7, 56, 0)
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "L Bumper"
    Control(__UI_NewID).CanHaveFocus = True
    __UI_NewID = __UI_NewControl(__UI_Type_Button, "RBumperBT", 80, 23, 447, 56, 0)
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "R Bumper"
    Control(__UI_NewID).CanHaveFocus = True
    __UI_NewID = __UI_NewControl(__UI_Type_Button, "MinusBT", 54, 23, 181, 117, 0)
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "-"
    Control(__UI_NewID).CanHaveFocus = True
    __UI_NewID = __UI_NewControl(__UI_Type_Button, "PlusBT", 54, 23, 340, 117, 0)
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "+"
    Control(__UI_NewID).CanHaveFocus = True
    __UI_NewID = __UI_NewControl(__UI_Type_Button, "YBT", 33, 23, 417, 180, 0)
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Y"
    Control(__UI_NewID).CanHaveFocus = True
    __UI_NewID = __UI_NewControl(__UI_Type_Button, "XBT", 33, 23, 447, 154, 0)
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "X"
    Control(__UI_NewID).CanHaveFocus = True
    __UI_NewID = __UI_NewControl(__UI_Type_Button, "BBT", 33, 23, 447, 208, 0)
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "B"
    Control(__UI_NewID).CanHaveFocus = True
    __UI_NewID = __UI_NewControl(__UI_Type_Button, "ABT", 33, 23, 478, 180, 0)
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "A"
    Control(__UI_NewID).CanHaveFocus = True
    __UI_NewID = __UI_NewControl(__UI_Type_TrackBar, "LeftStickX", 93, 30, 181, 208, 0)
    __UI_RegisterResult = 0
    Control(__UI_NewID).Max = 255
    Control(__UI_NewID).CanHaveFocus = True
    Control(__UI_NewID).Disabled = True
    Control(__UI_NewID).Interval = 1
    __UI_NewID = __UI_NewControl(__UI_Type_TrackBar, "RightStickX", 93, 30, 301, 208, 0)
    __UI_RegisterResult = 0
    Control(__UI_NewID).Max = 255
    Control(__UI_NewID).CanHaveFocus = True
    Control(__UI_NewID).Disabled = True
    Control(__UI_NewID).Interval = 1
    __UI_NewID = __UI_NewControl(__UI_Type_Button, "LeftStickBT", 93, 23, 181, 180, 0)
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Left Stick"
    Control(__UI_NewID).CanHaveFocus = True
    __UI_NewID = __UI_NewControl(__UI_Type_Button, "RightStickBT", 93, 23, 301, 180, 0)
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Right Stick"
    Control(__UI_NewID).CanHaveFocus = True
    __UI_NewID = __UI_NewControl(__UI_Type_TrackBar, "LeftStickY", 93, 30, 181, 264, 0)
    __UI_RegisterResult = 0
    Control(__UI_NewID).Max = 255
    Control(__UI_NewID).CanHaveFocus = True
    Control(__UI_NewID).Disabled = True
    Control(__UI_NewID).Interval = 1
    __UI_NewID = __UI_NewControl(__UI_Type_TrackBar, "RightStickY", 93, 30, 301, 264, 0)
    __UI_RegisterResult = 0
    Control(__UI_NewID).Max = 255
    Control(__UI_NewID).CanHaveFocus = True
    Control(__UI_NewID).Disabled = True
    Control(__UI_NewID).Interval = 1
    __UI_NewID = __UI_NewControl(__UI_Type_Label, "LeftStickXLB", 10, 21, 181, 238, 0)
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "X:"
    Control(__UI_NewID).VAlign = __UI_Middle
    Control(__UI_NewID).AutoSize = True
    __UI_NewID = __UI_NewControl(__UI_Type_Label, "RightStickXLB", 10, 21, 301, 238, 0)
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "X:"
    Control(__UI_NewID).VAlign = __UI_Middle
    Control(__UI_NewID).AutoSize = True
    __UI_NewID = __UI_NewControl(__UI_Type_Label, "LeftStickYLB", 10, 21, 181, 299, 0)
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Y:"
    Control(__UI_NewID).VAlign = __UI_Middle
    Control(__UI_NewID).AutoSize = True
    __UI_NewID = __UI_NewControl(__UI_Type_Label, "RightStickYLB", 10, 21, 301, 299, 0)
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Y:"
    Control(__UI_NewID).VAlign = __UI_Middle
    Control(__UI_NewID).AutoSize = True
    __UI_NewID = __UI_NewControl(__UI_Type_Button, "LeftTriggerBT", 80, 41, 7, 10, 0)
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Left Trigger"
    Control(__UI_NewID).CanHaveFocus = True
    __UI_NewID = __UI_NewControl(__UI_Type_Button, "RightTriggerBT", 80, 41, 447, 10, 0)
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Right Trigger"
    Control(__UI_NewID).CanHaveFocus = True
    __UI_NewID = __UI_NewControl(__UI_Type_Button, "HomeBT", 54, 23, 301, 144, 0)
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Home"
    Control(__UI_NewID).CanHaveFocus = True
    __UI_NewID = __UI_NewControl(__UI_Type_Button, "CaptureBT", 54, 23, 220, 144, 0)
    __UI_RegisterResult = 0
    SetCaption __UI_NewID, "Capture"
    Control(__UI_NewID).CanHaveFocus = True
END SUB
SUB __UI_AssignIDs
    NintendoSwitchHIDTest = __UI_GetID("NintendoSwitchHIDTest")
    UpBT = __UI_GetID("UpBT")
    DownBT = __UI_GetID("DownBT")
    RightBT = __UI_GetID("RightBT")
    LeftBT = __UI_GetID("LeftBT")
    LBumperBT = __UI_GetID("LBumperBT")
    RBumperBT = __UI_GetID("RBumperBT")
    MinusBT = __UI_GetID("MinusBT")
    PlusBT = __UI_GetID("PlusBT")
    YBT = __UI_GetID("YBT")
    XBT = __UI_GetID("XBT")
    BBT = __UI_GetID("BBT")
    ABT = __UI_GetID("ABT")
    LeftStickX = __UI_GetID("LeftStickX")
    RightStickX = __UI_GetID("RightStickX")
    LeftStickBT = __UI_GetID("LeftStickBT")
    RightStickBT = __UI_GetID("RightStickBT")
    LeftStickY = __UI_GetID("LeftStickY")
    RightStickY = __UI_GetID("RightStickY")
    LeftStickXLB = __UI_GetID("LeftStickXLB")
    RightStickXLB = __UI_GetID("RightStickXLB")
    LeftStickYLB = __UI_GetID("LeftStickYLB")
    RightStickYLB = __UI_GetID("RightStickYLB")
    LeftTriggerBT = __UI_GetID("LeftTriggerBT")
    RightTriggerBT = __UI_GetID("RightTriggerBT")
    HomeBT = __UI_GetID("HomeBT")
    CaptureBT = __UI_GetID("CaptureBT")
END SUB
SUB __UI_BeforeInit
END SUB
SUB __UI_OnLoad
    SetFrameRate 120
    init = hid_init
END SUB
SUB __UI_BeforeUpdateDisplay
    Control(UpBT).Disabled = True
    Control(LeftBT).Disabled = True
    Control(RightBT).Disabled = True
    Control(DownBT).Disabled = True
    Control(LBumperBT).Disabled = True
    Control(RBumperBT).Disabled = True
    Control(YBT).Disabled = True
    Control(XBT).Disabled = True
    Control(BBT).Disabled = True
    Control(ABT).Disabled = True
    Control(LeftStickBT).Disabled = True
    Control(RightStickBT).Disabled = True
    Control(HomeBT).Disabled = True
    Control(CaptureBT).Disabled = True
    Control(MinusBT).Disabled = True
    Control(PlusBT).Disabled = True
    Control(LeftTriggerBT).Disabled = True
    Control(RightTriggerBT).Disabled = True
    DIM res AS INTEGER
    handle = hid_open(NINTENDO_PRO_VID, NINTENDO_PRO_PID, 0)
    IF handle THEN
        DIM buf(0 TO 11) AS _UNSIGNED _BYTE
        buf(0) = &H3F
        res = hid_write(handle, _OFFSET(buf()), 12)
        res = hid_read(handle, _OFFSET(buf()), 12)
        IF res THEN
            DIM buffer AS STRING * MAX_STR
            res = hid_get_serial_number_string(handle, _OFFSET(buffer), MAX_STR)
            _TITLE "Nintendo Switch Pro Controller - " + UnicodeToANSI(buffer)
            Control(LeftStickX).Value = buf(5)
            Control(LeftStickY).Value = map(buf(7), 255, 0, 0, 255)
            Caption(LeftStickXLB) = "X:" + STR$(buf(5))
            Caption(LeftStickYLB) = "Y:" + STR$(map(buf(7), 255, 0, 0, 255))
            Control(RightStickX).Value = buf(9)
            Control(RightStickY).Value = map(buf(11), 255, 0, 0, 255)
            Caption(RightStickXLB) = "X:" + STR$(buf(9))
            Caption(RightStickYLB) = "Y:" + STR$(map(buf(11), 255, 0, 0, 255))
            IF buf(3) = 0 THEN Control(UpBT).Disabled = False
            IF buf(3) = 1 THEN
                Control(UpBT).Disabled = False
                Control(RightBT).Disabled = False
            END IF
            IF buf(3) = 2 THEN Control(RightBT).Disabled = False
            IF buf(3) = 3 THEN
                Control(RightBT).Disabled = False
                Control(DownBT).Disabled = False
            END IF
            IF buf(3) = 4 THEN Control(DownBT).Disabled = False
            IF buf(3) = 5 THEN
                Control(DownBT).Disabled = False
                Control(LeftBT).Disabled = False
            END IF
            IF buf(3) = 6 THEN Control(LeftBT).Disabled = False
            IF buf(3) = 7 THEN
                Control(LeftBT).Disabled = False
                Control(UpBT).Disabled = False
            END IF
            IF buf(1) AND X_BUTTON THEN Control(XBT).Disabled = False
            IF buf(1) AND Y_BUTTON THEN Control(YBT).Disabled = False
            IF buf(1) AND B_BUTTON THEN Control(BBT).Disabled = False
            IF buf(1) AND A_BUTTON THEN Control(ABT).Disabled = False
            IF buf(1) AND LEFT_BUMPER THEN Control(LBumperBT).Disabled = False
            IF buf(1) AND RIGHT_BUMPER THEN Control(RBumperBT).Disabled = False
            IF buf(1) AND LEFT_TRIGGER THEN Control(LeftTriggerBT).Disabled = False
            IF buf(1) AND RIGHT_TRIGGER THEN Control(RightTriggerBT).Disabled = False
            IF buf(2) AND PLUS_BUTTON THEN Control(PlusBT).Disabled = False
            IF buf(2) AND MINUS_BUTTON THEN Control(MinusBT).Disabled = False
            IF buf(2) AND HOME_BUTTON THEN Control(HomeBT).Disabled = False
            IF buf(2) AND CAPTURE_BUTTON THEN Control(CaptureBT).Disabled = False
            IF buf(2) AND L_STICK_BTN THEN Control(LeftStickBT).Disabled = False
            IF buf(2) AND R_STICK_BTN THEN Control(RightStickBT).Disabled = False
        END IF
    END IF
END SUB
FUNCTION UnicodeToANSI$ (buffer AS STRING)
    DIM ansibuffer AS STRING
    ansibuffer = SPACE$(LEN(buffer) / 2)
    DIM a AS INTEGER
    a = WideCharToMultiByte(437, 0, _OFFSET(buffer), LEN(buffer), _OFFSET(ansibuffer), LEN(ansibuffer), 0, 0)
    UnicodeToANSI = MID$(ansibuffer, 1, INSTR(ansibuffer, CHR$(0)) - 1)
END FUNCTION
FUNCTION map! (value!, minRange!, maxRange!, newMinRange!, newMaxRange!)
    map! = ((value! - minRange!) / (maxRange! - minRange!)) * (newMaxRange! - newMinRange!) + newMinRange!
END FUNCTION
SUB __UI_BeforeUnload
    hid_close handle
    DIM res AS INTEGER
    res = hid_exit
END SUB
SUB __UI_Click (id AS LONG)
    SELECT CASE id
        CASE HomeBT
        CASE CaptureBT
        CASE NintendoSwitchHIDTest
        CASE UpBT
        CASE DownBT
        CASE RightBT
        CASE LeftBT
        CASE LBumperBT
        CASE RBumperBT
        CASE MinusBT
        CASE PlusBT
        CASE YBT
        CASE XBT
        CASE BBT
        CASE ABT
        CASE LeftStickX
        CASE RightStickX
        CASE LeftStickBT
        CASE RightStickBT
        CASE LeftStickY
        CASE RightStickY
        CASE LeftStickXLB
        CASE RightStickXLB
        CASE LeftStickYLB
        CASE RightStickYLB
        CASE LeftTriggerBT
        CASE RightTriggerBT
    END SELECT
END SUB
SUB __UI_MouseEnter (id AS LONG)
    SELECT CASE id
        CASE HomeBT
        CASE CaptureBT
        CASE NintendoSwitchHIDTest
        CASE UpBT
        CASE DownBT
        CASE RightBT
        CASE LeftBT
        CASE LBumperBT
        CASE RBumperBT
        CASE MinusBT
        CASE PlusBT
        CASE YBT
        CASE XBT
        CASE BBT
        CASE ABT
        CASE LeftStickX
        CASE RightStickX
        CASE LeftStickBT
        CASE RightStickBT
        CASE LeftStickY
        CASE RightStickY
        CASE LeftStickXLB
        CASE RightStickXLB
        CASE LeftStickYLB
        CASE RightStickYLB
        CASE LeftTriggerBT
        CASE RightTriggerBT
    END SELECT
END SUB
SUB __UI_MouseLeave (id AS LONG)
    SELECT CASE id
        CASE HomeBT
        CASE CaptureBT
        CASE NintendoSwitchHIDTest
        CASE UpBT
        CASE DownBT
        CASE RightBT
        CASE LeftBT
        CASE LBumperBT
        CASE RBumperBT
        CASE MinusBT
        CASE PlusBT
        CASE YBT
        CASE XBT
        CASE BBT
        CASE ABT
        CASE LeftStickX
        CASE RightStickX
        CASE LeftStickBT
        CASE RightStickBT
        CASE LeftStickY
        CASE RightStickY
        CASE LeftStickXLB
        CASE RightStickXLB
        CASE LeftStickYLB
        CASE RightStickYLB
        CASE LeftTriggerBT
        CASE RightTriggerBT
    END SELECT
END SUB
SUB __UI_FocusIn (id AS LONG)
    SELECT CASE id
        CASE HomeBT
        CASE CaptureBT
        CASE UpBT
        CASE DownBT
        CASE RightBT
        CASE LeftBT
        CASE LBumperBT
        CASE RBumperBT
        CASE MinusBT
        CASE PlusBT
        CASE YBT
        CASE XBT
        CASE BBT
        CASE ABT
        CASE LeftStickX
        CASE RightStickX
        CASE LeftStickBT
        CASE RightStickBT
        CASE LeftStickY
        CASE RightStickY
        CASE LeftTriggerBT
        CASE RightTriggerBT
    END SELECT
END SUB
SUB __UI_FocusOut (id AS LONG)
    SELECT CASE id
        CASE HomeBT
        CASE CaptureBT
        CASE UpBT
        CASE DownBT
        CASE RightBT
        CASE LeftBT
        CASE LBumperBT
        CASE RBumperBT
        CASE MinusBT
        CASE PlusBT
        CASE YBT
        CASE XBT
        CASE BBT
        CASE ABT
        CASE LeftStickX
        CASE RightStickX
        CASE LeftStickBT
        CASE RightStickBT
        CASE LeftStickY
        CASE RightStickY
        CASE LeftTriggerBT
        CASE RightTriggerBT
    END SELECT
END SUB
SUB __UI_MouseDown (id AS LONG)
    SELECT CASE id
        CASE HomeBT
        CASE CaptureBT
        CASE NintendoSwitchHIDTest
        CASE UpBT
        CASE DownBT
        CASE RightBT
        CASE LeftBT
        CASE LBumperBT
        CASE RBumperBT
        CASE MinusBT
        CASE PlusBT
        CASE YBT
        CASE XBT
        CASE BBT
        CASE ABT
        CASE LeftStickX
        CASE RightStickX
        CASE LeftStickBT
        CASE RightStickBT
        CASE LeftStickY
        CASE RightStickY
        CASE LeftStickXLB
        CASE RightStickXLB
        CASE LeftStickYLB
        CASE RightStickYLB
        CASE LeftTriggerBT
        CASE RightTriggerBT
    END SELECT
END SUB
SUB __UI_MouseUp (id AS LONG)
    SELECT CASE id
        CASE HomeBT
        CASE CaptureBT
        CASE NintendoSwitchHIDTest
        CASE UpBT
        CASE DownBT
        CASE RightBT
        CASE LeftBT
        CASE LBumperBT
        CASE RBumperBT
        CASE MinusBT
        CASE PlusBT
        CASE YBT
        CASE XBT
        CASE BBT
        CASE ABT
        CASE LeftStickX
        CASE RightStickX
        CASE LeftStickBT
        CASE RightStickBT
        CASE LeftStickY
        CASE RightStickY
        CASE LeftStickXLB
        CASE RightStickXLB
        CASE LeftStickYLB
        CASE RightStickYLB
        CASE LeftTriggerBT
        CASE RightTriggerBT
    END SELECT
END SUB
SUB __UI_KeyPress (id AS LONG)
    SELECT CASE id
        CASE HomeBT
        CASE CaptureBT
        CASE UpBT
        CASE DownBT
        CASE RightBT
        CASE LeftBT
        CASE LBumperBT
        CASE RBumperBT
        CASE MinusBT
        CASE PlusBT
        CASE YBT
        CASE XBT
        CASE BBT
        CASE ABT
        CASE LeftStickX
        CASE RightStickX
        CASE LeftStickBT
        CASE RightStickBT
        CASE LeftStickY
        CASE RightStickY
        CASE LeftTriggerBT
        CASE RightTriggerBT
    END SELECT
END SUB
SUB __UI_TextChanged (id AS LONG)
    SELECT CASE id
    END SELECT
END SUB
SUB __UI_ValueChanged (id AS LONG)
    SELECT CASE id
        CASE LeftStickX
        CASE RightStickX
        CASE LeftStickY
        CASE RightStickY
    END SELECT
END SUB
SUB __UI_FormResized
END SUB
