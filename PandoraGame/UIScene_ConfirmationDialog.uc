class UIScene_ConfirmationDialog extends UIScene_BaseFrontEnd
    native;

var PandoraGRI.eMsgBoxType eSimpleMode;
var PandoraGRI.eMsgBoxResult eConfirmed;
var string Ok_Markup;
var string OkCancel_Markup;
var string On_Function_False;
var string On_Cancel_Timeout_Function;
var string On_OK_Timeout_Function;
var string On_Message_Only;
var string OkSelectStorage_Markup;
var bool bIngoreInput;
var int ControlId;
var UILabel lblTimer;
var int msgPriority;
//var delegate<OnSceneClose> __OnSceneClose__Delegate;
//var delegate<OnFadeOutCompleted> __OnFadeOutCompleted__Delegate;

delegate OnSceneClose()
{
    //return;    
}

delegate bool OnFadeOutCompleted()
{
    //return ReturnValue;    
}

event InitScene()
{
    // End:0x45
    if(GetPC().IsLobbySceneActive())
    {
        SPPlayerReplicationInfo(GetPC().PlayerReplicationInfo).RequestReadyStatusChange(false);
    }
    super.InitScene();
    DisableAttractMode();
    Ok_Markup = PlatformStrings $ Ok_Markup;
    OkCancel_Markup = PlatformStrings $ OkCancel_Markup;
    On_Cancel_Timeout_Function = PlatformStrings $ On_Cancel_Timeout_Function;
    On_OK_Timeout_Function = PlatformStrings $ On_OK_Timeout_Function;
    OkSelectStorage_Markup = PlatformStrings $ OkSelectStorage_Markup;
    lblTimer = UILabel(FindChild('lblTimer', true));
    // End:0xEA
    if(lblTimer != none)
    {
        lblTimer.SetVisibility(false);
    }
    bHandleConnectionMessages = true;
    bQuitToMainMenuOnProfileChange = true;
    //return;    
}

function SetTitleDatastoreBinding(string Markup)
{
    local UILabel Lbl;

    Lbl = UILabel(FindChild('lblTitle', true));
    // End:0x3C
    if(Lbl != none)
    {
        Lbl.SetDataStoreBinding(Markup);
    }
    //return;    
}

function SetMessageDatastoreBinding(string Markup)
{
    local UILabel Lbl;

    Lbl = UILabel(FindChild('lblMsgText', true));
    // End:0x3C
    if(Lbl != none)
    {
        Lbl.SetDataStoreBinding(Markup);
    }
    //return;    
}

function SetButtonLabelDatastoreBinding(string Markup)
{
    local UILabel Lbl;

    Lbl = UILabel(FindChild('ButtonLabel', true));
    // End:0x3C
    if(Lbl != none)
    {
        Lbl.SetDataStoreBinding(Markup);
    }
    //return;    
}

private final function InsertButton(string ButtonName, string Caption)
{
    local int Length;

    Length = MenuItems.Length;
    MenuItems.Insert(Length, 1);
    MenuItems[Length].ButtonName = ButtonName;
    MenuItems[Length].ButtonObj = UILabelButton(FindChild(name(MenuItems[Length].ButtonName), true));
    MenuItems[Length].MenuItemUIObject = MenuItems[Length].ButtonObj;
    SetOnClickedCallback(MenuItems[Length].ButtonObj, OnMenuItemClicked);
    MenuItems[Length].ButtonObj.SetCaption(Caption);
    MenuItems[Length].ButtonObj.SetVisibility(true);
    //return;    
}

private final function SetupButtons()
{
    local SPUIButtonBar Lbl;

    Lbl = SPUIButtonBar(FindChild('helperBar', true));
    Lbl.SetVisibility(false);
    MenuStyle = 0;
    switch(eSimpleMode)
    {
        // End:0x93
        case 0:
            InsertButton("btn_0", "<Strings:PlatformPC.UIScene_ConfirmationDialog.OkButtonText>");
            // End:0x32A
            break;
        // End:0x135
        case 1:
            InsertButton("btn_1", "<Strings:PlatformPC.UIScene_ConfirmationDialog.OkButtonText>");
            InsertButton("btn_0", "<Strings:PlatformPC.UIScene_ConfirmationDialog.CancelButtonText>");
            // End:0x32A
            break;
        // End:0x188
        case 3:
            InsertButton("btn_0", "<Strings:PlatformPC.UIScene_ConfirmationDialog.OkButtonText>");
            // End:0x32A
            break;
        // End:0x1DF
        case 4:
            InsertButton("btn_0", "<Strings:PlatformPC.UIScene_ConfirmationDialog.CancelButtonText>");
            // End:0x32A
            break;
        // End:0x232
        case 5:
            InsertButton("btn_0", "<Strings:PlatformPC.UIScene_ConfirmationDialog.OkButtonText>");
            // End:0x32A
            break;
        // End:0x2D4
        case 6:
            InsertButton("btn_1", "<Strings:PlatformPC.UIScene_ConfirmationDialog.OkButtonText>");
            InsertButton("btn_0", "<Strings:PlatformPC.UIScene_ConfirmationDialog.CancelButtonText>");
            // End:0x32A
            break;
        // End:0x327
        case 7:
            InsertButton("btn_0", "<Strings:PlatformPC.UIScene_ConfirmationDialog.OkButtonText>");
            // End:0x32A
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

function SimpleMode(PandoraGRI.eMsgBoxType Mode)
{
    local SPUIButtonBar Lbl;

    Lbl = SPUIButtonBar(FindChild('helperBar', true));
    eSimpleMode = Mode;
    // End:0x35
    if(IsPCBuild())
    {
        SetupButtons();
    }
    // End:0x15B
    if(Lbl != none)
    {
        switch(eSimpleMode)
        {
            // End:0x66
            case 0:
                Lbl.SetDataStoreBinding(Ok_Markup);
                // End:0x15B
                break;
            // End:0x84
            case 1:
                Lbl.SetDataStoreBinding(OkCancel_Markup);
                // End:0x15B
                break;
            // End:0x89
            case 2:
            // End:0xA7
            case 8:
                Lbl.SetDataStoreBinding(On_Message_Only);
                // End:0x15B
                break;
            // End:0xC2
            case 9:
                Lbl.SetDataStoreBinding("");
                // End:0x15B
                break;
            // End:0xE0
            case 3:
                Lbl.SetDataStoreBinding(On_Function_False);
                // End:0x15B
                break;
            // End:0xFE
            case 4:
                Lbl.SetDataStoreBinding(On_Cancel_Timeout_Function);
                // End:0x15B
                break;
            // End:0x11C
            case 5:
                Lbl.SetDataStoreBinding(On_OK_Timeout_Function);
                // End:0x15B
                break;
            // End:0x13A
            case 6:
                Lbl.SetDataStoreBinding(OkCancel_Markup);
                // End:0x15B
                break;
            // End:0x158
            case 7:
                Lbl.SetDataStoreBinding(OkSelectStorage_Markup);
                // End:0x15B
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        // End:0x1A6
        if(!GetWorldInfo().IsConsoleBuild() && !myPC.PlayerInput.bUsingGamepad)
        {
            SetButtonLabelDatastoreBinding(MsgBoxHelperTextOverridePC);
        }
        //return;        
    }
}

event FadeCompleted()
{
    super(SPUIScene).FadeCompleted();
    // End:0x36
    if(Opacity <= 0.0000000)
    {
        OnSceneClose();
        SceneClient.CloseScene(self);
    }
    //return;    
}

event UpdateScene(float DeltaTime, WorldInfo WorldInfo)
{
    local int PlayerIndex, nCountDownTime;
    local string Temp;
    local bool bDisplayTimer;

    // End:0x0E
    if(!IsSceneActive())
    {
        return;
    }
    Temp = "";
    bDisplayTimer = false;
    PlayerIndex = GetBestPlayerIndex();
    // End:0x6E
    if(GetPC().IsLobbySceneActive())
    {
        SceneClient.CloseScene(self, false);
        SceneClient.OpenScene(self);
        return;
    }
    // End:0x8A
    if(!IsFocused(PlayerIndex))
    {
        SetFocus(self);
    }
    // End:0x2BA
    if((((((int(eSimpleMode) == int(3)) || int(eSimpleMode) == int(4)) || int(eSimpleMode) == int(6)) || int(eSimpleMode) == int(5)) || int(eSimpleMode) == int(8)) || int(eSimpleMode) == int(9))
    {
        // End:0x141
        if(bOnFunctionMessage == true)
        {
            bOnFunctionMessage = OnMessage();
            // End:0x141
            if(!bOnFunctionMessage)
            {
                eConfirmed = 1;
                bIngoreInput = true;
                FadeOut(fadeOutTimeEd);
            }
        }
        // End:0x2BA
        if(((((int(eSimpleMode) == int(4)) || int(eSimpleMode) == int(6)) || int(eSimpleMode) == int(5)) || int(eSimpleMode) == int(8)) || int(eSimpleMode) == int(9))
        {
            nCountDownTime = int(float(nTimeout) - (GetWorldInfo().RealTimeSeconds - float(nStartTime)));
            // End:0x20A
            if(SPGameUISceneClient(SceneClient).IsInSystemMenu())
            {
                nStartTime = int(GetWorldInfo().RealTimeSeconds);
                nCountDownTime = nTimeout;
            }
            // End:0x257
            if(nCountDownTime < 0)
            {
                eConfirmed = 3;
                bIngoreInput = true;
                SceneClient.CloseScene(self);
                OnResults(ControlId, eConfirmed);
                nCountDownTime = 0;
            }
            // End:0x2BA
            if(int(eSimpleMode) != int(9))
            {
                Temp = string(nCountDownTime) @ "<Strings:PandoraGame.UIScene_ConfirmationDialog.Countdown>";
                bDisplayTimer = true;
            }
        }
    }
    lblTimer.SetDataStoreBinding(Temp);
    lblTimer.SetVisibility(bDisplayTimer);
    //return;    
}

function bool CustomInputKey(const out InputEventParameters EventParms)
{
    local bool bOktoAccept;

    UpDateUsingGamePadForPC(EventParms);
    // End:0x38
    if(bIngoreInput || GetPC().IsMoviePlaying())
    {
        return true;
    }
    // End:0x9B
    if(((((int(eSimpleMode) == int(0)) || int(eSimpleMode) == int(1)) || int(eSimpleMode) == int(5)) || int(eSimpleMode) == int(6)) || int(eSimpleMode) == int(7))
    {
        bOktoAccept = true;        
    }
    else
    {
        bOktoAccept = false;
    }
    // End:0xF8
    if((IsInputAccept(EventParms)) && bOktoAccept)
    {
        ControlId = EventParms.PlayerIndex;
        eConfirmed = 1;
        bIngoreInput = true;
        FadeOut(fadeOutTimeEd);
        return true;
    }
    // End:0x168
    if(((IsInputCancel(EventParms)) || IsInputEscape(EventParms)) && int(eSimpleMode) == int(1))
    {
        ControlId = EventParms.PlayerIndex;
        eConfirmed = 2;
        bIngoreInput = true;
        FadeOut(fadeOutTimeEd);
        return true;
    }
    // End:0x1EA
    if(((IsInputCancel(EventParms)) || IsInputEscape(EventParms)) && (int(eSimpleMode) == int(6)) || int(eSimpleMode) == int(7))
    {
        ControlId = EventParms.PlayerIndex;
        eConfirmed = 2;
        bIngoreInput = true;
        FadeOut(fadeOutTimeEd);
        return true;
    }
    // End:0x25A
    if(((IsInputCancel(EventParms)) || IsInputEscape(EventParms)) && int(eSimpleMode) == int(4))
    {
        ControlId = EventParms.PlayerIndex;
        eConfirmed = 2;
        bIngoreInput = true;
        FadeOut(fadeOutTimeEd);
        return true;
    }
    // End:0x268
    if(IsPCBuild())
    {
        return false;        
    }
    else
    {
        return true;
    }
    //return ReturnValue;    
}

function bool OnMenuItemClicked(UIScreenObject EventObject, int PlayerIndex)
{
    local UIObject ScreenObject;
    local int MenuIndex;
    local bool bOktoAccept;

    ScreenObject = UIObject(EventObject);
    // End:0x206
    if(ScreenObject != none)
    {
        MenuIndex = MenuIndexByName(string(ScreenObject.WidgetTag));
        // End:0x206
        if(MenuIndex != -1)
        {
            // End:0xAE
            if(((((int(eSimpleMode) == int(0)) || int(eSimpleMode) == int(1)) || int(eSimpleMode) == int(5)) || int(eSimpleMode) == int(6)) || int(eSimpleMode) == int(7))
            {
                bOktoAccept = true;                
            }
            else
            {
                bOktoAccept = false;
            }
            SetFocusToMenuItem(MenuIndex);
            CurrMenuItemIdx = MenuIndex;
            // End:0x109
            if((CurrMenuItemIdx == 0) && bOktoAccept)
            {
                eConfirmed = 1;
                bIngoreInput = true;
                FadeOut(fadeOutTimeEd);                
            }
            else
            {
                // End:0x149
                if((CurrMenuItemIdx == 0) && int(eSimpleMode) == int(1))
                {
                    eConfirmed = 1;
                    bIngoreInput = true;
                    FadeOut(fadeOutTimeEd);                    
                }
                else
                {
                    // End:0x189
                    if((CurrMenuItemIdx == 1) && int(eSimpleMode) == int(1))
                    {
                        eConfirmed = 2;
                        bIngoreInput = true;
                        FadeOut(fadeOutTimeEd);                        
                    }
                    else
                    {
                        // End:0x1C9
                        if((CurrMenuItemIdx == 1) && int(eSimpleMode) == int(6))
                        {
                            eConfirmed = 2;
                            bIngoreInput = true;
                            FadeOut(fadeOutTimeEd);                            
                        }
                        else
                        {
                            // End:0x206
                            if((CurrMenuItemIdx == 0) && int(eSimpleMode) == int(4))
                            {
                                eConfirmed = 2;
                                bIngoreInput = true;
                                FadeOut(fadeOutTimeEd);
                            }
                        }
                    }
                }
            }
        }
    }
    return true;
    //return ReturnValue;    
}

function OnProfileChangeMessageBoxResults(int PlayerIndex, PandoraGRI.eMsgBoxResult eReturnValue)
{
    local PandoraPlayerController PC;

    PC = GetPC();
    // End:0x1E
    if(PC == none)
    {        
    }
    else
    {
        PC.QuitToMainMenu();
    }
    //return;    
}

function Reset(optional delegate<OnResults> Callback)
{
    local UILabel lblMsgText, lblTitle;
    local PandoraGRI PGRI;
    local SPGameUISceneClient GameSceneClient;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x2B
    if(PGRI == none)
    {
    }
    GameSceneClient = SPGameUISceneClient(Class'Engine.UIRoot'.static.GetSceneClient());
    // End:0x51
    if(GameSceneClient == none)
    {
    }
    lblMsgText = UILabel(FindChild('lblMsgText', true));
    lblTitle = UILabel(FindChild('lblTitle', true));
    __OnResults__Delegate = None;
    GameSceneClient.CloseScenesByClass('UIScene_ConfirmationDialog');
    ShowMsgBox(lblMsgText.GetValue(), lblTitle.GetValue(),, Callback,, nTimeout, byte(msgPriority));
    //return;    
}

event SceneDeactivated()
{
    // End:0x27
    if((GetPC()) != none)
    {
        GetPC().bMsgBoxDisplayed = false;
    }
    // End:0x4B
    if(__OnResults__Delegate != none)
    {
        OnResults(ControlId, eConfirmed);
    }
    super.SceneDeactivated();
    //return;    
}

function bool MouseIsOverMenuButton()
{
    return false;
    //return ReturnValue;    
}

function bool MousePreActivate(UIObject Widget)
{
    local SPGameUISceneClient SPSceneClient;
    local PandoraGameViewportClient pvc;

    // End:0x26
    if(myPC != none)
    {
        pvc = PandoraGameViewportClient(myPC.GetViewportClient());
    }
    // End:0x4B
    if(pvc != none)
    {
        // End:0x4B
        if(pvc.FullScreenIsMoviePlaying())
        {
            return false;
        }
    }
    SPSceneClient = SPGameUISceneClient(Class'Engine.UIRoot'.static.GetSceneClient());
    LastMousePos.X = SPSceneClient.MousePosition.X;
    LastMousePos.Y = SPSceneClient.MousePosition.Y;
    OnActiveMoveAccepted();
    return true;
    //return ReturnValue;    
}
