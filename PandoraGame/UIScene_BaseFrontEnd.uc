class UIScene_BaseFrontEnd extends UIScene_BaseMenu
    native;

const GS_USERNAME_MAXLENGTH = 15;
const GS_PASSWORD_MAXLENGTH = 30;
const GS_MESSAGE_MAXLENGTH = 255;
const GS_EMAIL_MAXLENGTH = 50;
const GS_CDKEY_PART_MAXLENGTH = 4;

enum eMenuStyle
{
    VERTICAL_MENU,                  // 0
    HORIZONTAL_MENU,                // 1
    CUSTOM_MENU,                    // 2
    eMenuStyle_MAX                  // 3
};

enum ENavigationType
{
    ENT_NAV_UP,                     // 0
    ENT_NAV_DOWN,                   // 1
    ENT_NAV_LEFT,                   // 2
    ENT_NAV_RIGHT,                  // 3
    ENT_NAV_MAX                     // 4
};

enum eMsgBoxPriorityType
{
    EMSG_PRIORITY00,                // 0
    EMSG_PRIORITY01,                // 1
    EMSG_PRIORITY02,                // 2
    EMSG_PRIORITY03,                // 3
    EMSG_PRIORITY04,                // 4
    EMSG_PRIORITY05,                // 5
    EMSG_PRIORITY06,                // 6
    EMSG_PRIORITY07,                // 7
    EMSG_PRIORITY08,                // 8
    EMSG_PRIORITY09,                // 9
    EMSG_PRIORITY10,                // 10
    EMSG_MAX                        // 11
};

struct native NavigationInfo
{
    /** UI Object names to navigate to. UP = 0, DOWN = 1, LEFT = 2, RIGHT = 3. */
    var() string UIObjNames[4];

    structdefaultproperties
    {
        UIObjNames[0]=""
        UIObjNames[1]=""
        UIObjNames[2]=""
        UIObjNames[3]=""
    }
};

struct native MenuInfo
{
    var noexport transient UIObject MenuItemUIObject;
    /** The name of the UILableButton this menu item corresponds to */
    var() string ButtonName;
    var noexport transient UILabelButton ButtonObj;
    /** The name of the UICheckbox this menu item corresponds to */
    var() string CheckboxName;
    var noexport transient UICheckbox CheckboxObj;
    /** The profile ID of the checkbox */
    var() int CheckboxProfileId;
    /** The name of the UISlider this menu item corresponds to */
    var() string SliderName;
    var noexport transient UISlider SliderObj;
    /** The profile ID of the Slider */
    var() int SliderProfileId;
    /** Optional name of the UILabel to represent the value of the slider */
    var() string SliderValueName;
    var noexport transient UILabel SliderValueObj;
    /** The Divisor to use to convert the slider's value */
    var() float SliderValueConversion;
    var int SliderValueTruncate;
    /** The name of the UIEditBox this menu item corresponds to */
    var() string EditBoxName;
    var noexport transient UIEditBox EditBoxObj;
    /** The Scene to open when this menu item is processed FOR ALL PLATFORMS!!!!!!!!!!!!!!!!!!! */
    var() UIScene SceneRef;
    /** The Scene to open when this menu item is processed on the PC Only! */
    var() notforconsole UIScene SceneRefPC;
    /** The Scene to open when this menu item is processed on the XBox360 Only! */
    var() /*0x20000000-0x00000000*/ UIScene SceneRefXBox360;
    /** The Scene to open when this menu item is processed on the PS3 Only! */
    var() /*0x40000000-0x00000000*/ UIScene SceneRefPS3;
    /** The remote event to activate when this menu item is processed */
    var() name RemoteEvent;
    /** Only call the OnClick function */
    var() bool bOnlyCallOnClick;
    /** Only call the LeftRight function */
    var() bool bCallLeftRight;
    /** Indicates whether this menu item is disabled */
    var() bool bDisabled;
    /** Used for navigating to next UI object in custom menu style. UP = 0, DOWN = 1, LEFT = 2, RIGHT = 3. */
    var() NavigationInfo NaviInfo;
    /** This menu item is a select only UI object */
    var() bool bAddSelectIcon;
    /** index into option list array */
    var() int nOptionIndex;
    var string ButtonTextBackup;

    structdefaultproperties
    {
        MenuItemUIObject=none
        ButtonName=""
        ButtonObj=none
        CheckboxName=""
        CheckboxObj=none
        CheckboxProfileId=0
        SliderName=""
        SliderObj=none
        SliderProfileId=0
        SliderValueName=""
        SliderValueObj=none
        SliderValueConversion=0.0000000
        SliderValueTruncate=0
        EditBoxName=""
        EditBoxObj=none
        SceneRef=none
        SceneRefPC=none
        SceneRefXBox360=none
        SceneRefPS3=none
        RemoteEvent="None"
        bOnlyCallOnClick=false
        bCallLeftRight=false
        bDisabled=false
        NaviInfo=(UIObjNames="",UIObjNames[1]="",UIObjNames[2]="",UIObjNames[3]="")
        bAddSelectIcon=false
        nOptionIndex=0
        ButtonTextBackup=""
    }
};

/** VARIABLE DECLARATIONS The style of the menu: VERTICAL_MENU = cyle vertically HORIZONTAL_MENU = cycle horizontally */
var(Menu) UIScene_BaseFrontEnd.eMenuStyle MenuStyle;
/** List of menu items for this scene */
var(Menu) array<MenuInfo> MenuItems;
/** The last ui scene we were in */
var(Menu) UIScene_BaseFrontEnd PreviousMenuScene;
/** The UI scene to use for the msgbox */
var(Menu) UIScene MessageBoxScene;
var(Menu) Surface bgTexture;
var(Menu) name bgImageName;
var transient UIImage bgImage;
var bool bHideMenuBG;
var(Menu) bool bChangeBG;
var(Menu) bool bEnableLogin;
var bool bInputDisabled;
/** Attract mode */
var() bool bAttractModeEnabled;
var transient bool bAttractModeRunning;
var transient bool bOnFunctionMessage;
var bool bHandleConnectionMessages;
/** default true :sends us back to the main menu if we sign out */
var(Menu) bool bQuitToMainMenuOnProfileChange;
var bool bIsNetworkScene;
var bool bSkipAddButtonIcon;
var(Menu) string lblProfileName;
var transient UILabel lblProfile;
var transient UIScene BaseScene;
var transient int CurrMenuItemIdx;
var int LastMenuItemIdx;
var transient SPUIButtonBar CurrHelperText;
var string MsgBoxHelperTextOverridePC;
var transient float ButtonDelayTime;
var transient float CurrentButtonDelayTime;
var name OnExitRemoteEventName;
var transient float AttractModeCurTime;
var() float TimeUntilAttractMode;
var transient string CurrLevelName;
var transient int nTimeout;
var transient int nStartTime;
var string NotSignedIn;
var string SignedIn;
var string LeftArrow;
var string RightArrow;
var string GenericYes;
var string GenericNo;
var string GenericLow;
var string GenericMedium;
var string GenericHigh;
var string Space;
var string DeviceName;
var UIScene_ConfirmationDialog LastConfirmationDialog;
var string NeedProfile_Title;
var string NeedProfile_Message;
var UIContainer frmBack;
var UILabelButton btnBack;
var IntPoint LastMousePos;
//var delegate<OnMessage> __OnMessage__Delegate;
//var delegate<OnResults> __OnResults__Delegate;

delegate bool OnMessage()
{
    //return ReturnValue;    
}

delegate OnResults(int PlayerIndex, PandoraGRI.eMsgBoxResult eReturnValue)
{
    return;
    //return;    
}

// Export UUIScene_BaseFrontEnd::execSetLoadingMovie(FFrame&, void* const)
native function SetLoadingMovie();

function OnClick(UIScene OpenedScene, int MenuIndex)
{
    //return;    
}

function OnLeftRight(int MenuIndex, bool bRight)
{
    //return;    
}

function bool SetOnClickedCallback(UIObject TargetObject, delegate<OnClicked> NewClickHandler)
{
    local bool bResult;

    // End:0x28
    if(TargetObject != none)
    {
        TargetObject.__OnClicked__Delegate = NewClickHandler;
        bResult = true;
    }
    return bResult;
    //return ReturnValue;    
}

function StartAttractMode()
{
    local PandoraGameViewportClient pvc;

    // End:0x26
    if(myPC != none)
    {
        pvc = PandoraGameViewportClient(myPC.GetViewportClient());
    }
    // End:0x59
    if(pvc != none)
    {
        pvc.FullScreenPlayMovie('Attract_Mode', 4);
        bAttractModeRunning = true;
    }
    //return;    
}

function RestartAttractMode()
{
    local PandoraGameViewportClient pvc;

    // End:0x26
    if(myPC != none)
    {
        pvc = PandoraGameViewportClient(myPC.GetViewportClient());
    }
    // End:0x6F
    if(pvc != none)
    {
        // End:0x67
        if(pvc.FullScreenIsMoviePlaying())
        {
            pvc.FullScreenStopMovie('Attract_Mode', false);
        }
        bAttractModeRunning = false;
    }
    AttractModeCurTime = 0.0000000;
    //return;    
}

function EnableAttractMode()
{
    bAttractModeEnabled = true;
    RestartAttractMode();
    //return;    
}

function DisableAttractMode()
{
    bAttractModeEnabled = false;
    //return;    
}

function EnableButtonDelay()
{
    bInputDisabled = true;
    CurrentButtonDelayTime = ButtonDelayTime;
    //return;    
}

function InitConnections()
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInt;

    // End:0x0D
    if(myPC == none)
    {
        return;
    }
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x30
    if(OnlineSub == none)
    {
        return;
    }
    PlayerInt = OnlineSub.PlayerInterface;
    // End:0x59
    if(NotEqual_InterfaceInterface(PlayerInt, OnlinePlayerInterface(none)))
    {
    }
    InitLoginLabel();
    //return;    
}

function ClearConnections()
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInt;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x23
    if(OnlineSub == none)
    {
        return;
    }
    PlayerInt = OnlineSub.PlayerInterface;
    // End:0x4C
    if(NotEqual_InterfaceInterface(PlayerInt, OnlinePlayerInterface(none)))
    {
    }
    //return;    
}

event ShowLoginUI()
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInt;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x66
    if(OnlineSub != none)
    {
        PlayerInt = OnlineSub.PlayerInterface;
        // End:0x66
        if(NotEqual_InterfaceInterface(PlayerInt, OnlinePlayerInterface(none)))
        {
            // End:0x66
            if(PlayerInt.ShowLoginUI() == false)
            {
            }
        }
    }
    //return;    
}

function InitLoginLabel()
{
    local OnlineSubsystem.ELoginStatus Status;
    local string PlayerName;

    Status = 0;
    // End:0x15
    if(myPC == none)
    {
        return;
    }
    Status = GetLoginStatus(LocPlayer.ControllerId);
    switch(Status)
    {
        // End:0x41
        case 1:
        // End:0x106
        case 2:
            // End:0x103
            if(bEnableLogin && lblProfile != none)
            {
                PlayerName = GetPC().OnlinePlayerData.PlayerNick;
                // End:0xED
                if(!GetWorldInfo().IsConsoleBuild(1))
                {
                    PlayerName = Repl(PlayerName, " ", "_");
                    PlayerName = Repl(PlayerName, "?", "_");
                    PlayerName = Repl(PlayerName, "=", "_");
                    PlayerName = Repl(PlayerName, "<", "\\<");
                }
                lblProfile.SetDataStoreBinding(PlayerName);
            }
            // End:0x138
            break;
        // End:0xFFFF
        default:
            // End:0x135
            if(bEnableLogin && lblProfile != none)
            {
                lblProfile.SetDataStoreBinding(NotSignedIn);
            }
            // End:0x138
            break;
            break;
    }
    //return;    
}

function OnLoginFailed(byte LocalUserNum, OnlineSubsystem.EOnlineServerConnectionStatus ErrorCode)
{
    //return;    
}

function OnLoginCancelled()
{
    //return;    
}

function Cleanup()
{
    ClearConnections();
    //return;    
}

function InitMenuItems()
{
    local int I, tmpVal;

    I = 0;
    J0x07:

    // End:0x7A7 [Loop If]
    if(I < MenuItems.Length)
    {
        MenuItems[I].MenuItemUIObject = none;
        MenuItems[I].nOptionIndex = -1;
        // End:0x15A
        if(MenuItems[I].EditBoxName != "")
        {
            MenuItems[I].EditBoxObj = UIEditBox(FindChild(name(MenuItems[I].EditBoxName), true));
            // End:0x15A
            if(MenuItems[I].EditBoxObj != none)
            {
                MenuItems[I].MenuItemUIObject = MenuItems[I].EditBoxObj;
                MenuItems[I].EditBoxObj.__OnSubmitText__Delegate = OnSubmitText;
                // End:0x157
                if(!MenuItems[I].EditBoxObj.IsEnabled())
                {
                    MenuItems[I].bDisabled = true;
                }                
            }
        }
        // End:0x23F
        if(MenuItems[I].ButtonName != "")
        {
            MenuItems[I].ButtonObj = UILabelButton(FindChild(name(MenuItems[I].ButtonName), true));
            // End:0x23F
            if(MenuItems[I].ButtonObj != none)
            {
                MenuItems[I].MenuItemUIObject = MenuItems[I].ButtonObj;
                // End:0x23C
                if(!MenuItems[I].ButtonObj.IsEnabled())
                {
                    MenuItems[I].bDisabled = true;
                }                
            }
        }
        // End:0x395
        if(MenuItems[I].CheckboxName != "")
        {
            MenuItems[I].CheckboxObj = UICheckbox(FindChild(name(MenuItems[I].CheckboxName), true));
            // End:0x395
            if(MenuItems[I].CheckboxObj != none)
            {
                // End:0x2FC
                if(MenuItems[I].MenuItemUIObject == none)
                {
                    MenuItems[I].MenuItemUIObject = MenuItems[I].CheckboxObj;
                }
                myPC.ProfileSettings.GetProfileSettingValueId(MenuItems[I].CheckboxProfileId, tmpVal);
                // End:0x36B
                if(tmpVal == 0)
                {
                    MenuItems[I].CheckboxObj.SetValue(false);                    
                }
                else
                {
                    MenuItems[I].CheckboxObj.SetValue(true);
                }                
            }
        }
        // End:0x5B2
        if(MenuItems[I].SliderName != "")
        {
            MenuItems[I].SliderObj = UISlider(FindChild(name(MenuItems[I].SliderName), true));
            // End:0x5B2
            if(MenuItems[I].SliderObj != none)
            {
                // End:0x452
                if(MenuItems[I].MenuItemUIObject == none)
                {
                    MenuItems[I].MenuItemUIObject = MenuItems[I].SliderObj;
                }
                myPC.ProfileSettings.GetProfileSettingValueInt(MenuItems[I].SliderProfileId, tmpVal);
                MenuItems[I].SliderObj.SetValue(float(tmpVal));
                // End:0x5AF
                if(MenuItems[I].SliderValueName != "")
                {
                    MenuItems[I].SliderValueObj = UILabel(FindChild(name(MenuItems[I].SliderValueName), true));
                    // End:0x5AF
                    if((MenuItems[I].SliderValueObj != none) && MenuItems[I].SliderValueConversion != 0.0000000)
                    {
                        myPC.ProfileSettings.GetProfileSettingValueInt(MenuItems[I].SliderProfileId, tmpVal);
                        MenuItems[I].SliderObj.SetValue(float(tmpVal));                        
                    }
                }                
            }
        }
        // End:0x711
        if(MenuItems[I].SliderValueName != "")
        {
            MenuItems[I].SliderValueObj = UILabel(FindChild(name(MenuItems[I].SliderValueName), true));
            // End:0x711
            if(MenuItems[I].SliderValueObj != none)
            {
                myPC.ProfileSettings.GetProfileSettingValueId(MenuItems[I].SliderProfileId, tmpVal);
                // End:0x6DD
                if(MenuItems[I].SliderValueConversion != 0.0000000)
                {
                    MenuItems[I].SliderValueObj.SetValue(Left(string(float(tmpVal) / MenuItems[I].SliderValueConversion), MenuItems[I].SliderValueTruncate));                    
                }
                else
                {
                    MenuItems[I].SliderValueObj.SetDataStoreBinding(GetYesNoString(tmpVal));
                }                
            }
        }
        // End:0x79D
        if(MenuItems[I].MenuItemUIObject != none)
        {
            // End:0x772
            if(MenuItems[I].bDisabled)
            {
                MenuItems[I].MenuItemUIObject.ActivateStateByClass(Class'Engine.UIState_Disabled', 0);                
            }
            else
            {
                MenuItems[I].MenuItemUIObject.ActivateStateByClass(Class'Engine.UIState_Enabled', 0);
            }
            // [Explicit Continue]
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    // End:0x7C9
    if(bEnableLogin)
    {
        lblProfile = UILabel(FindChild(name(lblProfileName), true));
    }
    //return;    
}

function int MenuIndexByName(string ItemName)
{
    local int I;

    // End:0x13
    if(Len(ItemName) == 0)
    {
        return -1;
    }
    I = 0;
    J0x1A:

    // End:0xDC [Loop If]
    if(I < MenuItems.Length)
    {
        // End:0x54
        if(Caps(MenuItems[I].ButtonName) == Caps(ItemName))
        {
            return I;
        }
        // End:0x7E
        if(Caps(MenuItems[I].EditBoxName) == Caps(ItemName))
        {
            return I;
        }
        // End:0xA8
        if(Caps(MenuItems[I].CheckboxName) == Caps(ItemName))
        {
            return I;
        }
        // End:0xD2
        if(Caps(MenuItems[I].SliderName) == Caps(ItemName))
        {
            return I;
        }
        I++;
        // [Loop Continue]
        goto J0x1A;
    }
    return -1;
    //return ReturnValue;    
}

function BindHelperText()
{
    CurrHelperText = SPUIButtonBar(FindChild('lblHelperText', true));
    //return;    
}

event InitScene()
{
    local UIObject BackFrame;

    super.InitScene();
    LoadBaseFrontEndChildScenes();
    bSceneReady = false;
    // End:0x2A
    if(BaseScene == none)
    {
        BaseScene = self;
    }
    BackFrame = FindChild('BackButtFrame', true);
    btnBack = UILabelButton(FindChild('backbutton', true));
    // End:0xE0
    if((IsPCBuild() && BackFrame != none) && btnBack != none)
    {
        BackFrame.SetVisibility(true);
        btnBack.SetVisibility(true);
        btnBack.SetDataStoreBinding("<Strings:PlatformPC.MenuText.Back>");        
    }
    else
    {
        BackFrame.SetVisibility(false);
    }
    InitMenuItems();
    InitConnections();
    BindHelperText();
    SetVisibility(true);
    EnableButtonDelay();
    NotSignedIn = PlatformStrings $ "MenuText.NotSignedIn>";
    NeedProfile_Title = PlatformStrings $ "ErrorMessages.NeedProfile_Title>";
    NeedProfile_Message = PlatformStrings $ "ErrorMessages.NeedProfile_Message>";
    // End:0x208
    if((myGameInfo != none) && !myGameInfo.IsInShellLevel(CurrLevelName))
    {
        // End:0x1FE
        if(int(GetWorldInfo().NetMode) == int(NM_Standalone))
        {
            bPauseGameWhileActive = true;
        }
        DisableAttractMode();
    }
    // End:0x248
    if(((myGameInfo != none) && !myGameInfo.IsInShellLevel(CurrLevelName)) && bChangeBG)
    {
        ChangeBGImage();
    }
    // End:0x25B
    if(bHideMenuBG)
    {
        HideBGImage();
    }
    bSceneReady = true;
    //return;    
}

function bool OnBackButtonClicked(UIScreenObject EventObject, int PlayerIndex)
{
    // End:0x6B
    if(PreviousMenuScene != none)
    {
        PlayUISound('SceneClosed');
        ActivateRemoteEvent(OnExitRemoteEventName);
        SceneClient.CloseScene(self);
        PreviousMenuScene.SetVisibility(true);
        PreviousMenuScene.FadeIn(fadeInTimeEd);
    }
    return true;
    //return ReturnValue;    
}

function SetBackButtonVisibility()
{
    local UIObject BackFrame;

    BackFrame = FindChild('BackButtFrame', true);
    btnBack = UILabelButton(FindChild('backbutton', true));
    // End:0x67
    if(IsPCBuild())
    {
        BackFrame.SetVisibility(true);
        btnBack.SetVisibility(true);        
    }
    else
    {
        BackFrame.SetVisibility(false);
    }
    //return;    
}

function SetBackButtonVisibilityOff()
{
    local UIObject BackFrame;

    BackFrame = FindChild('BackButtFrame', true);
    btnBack = UILabelButton(FindChild('backbutton', true));
    BackFrame.SetVisibility(false);
    btnBack.SetVisibility(false);
    //return;    
}

event UpdateScene(float DeltaTime, WorldInfo WorldInfo)
{
    local PandoraGameViewportClient pvc;

    super.UpdateScene(DeltaTime, WorldInfo);
    // End:0x3C
    if(bInputDisabled)
    {
        CurrentButtonDelayTime -= DeltaTime;
        // End:0x3C
        if(CurrentButtonDelayTime <= 0.0000000)
        {
            bInputDisabled = false;
        }
    }
    // End:0x4B
    if(LastMenuItemIdx != CurrMenuItemIdx)
    {
    }
    // End:0xF8
    if(bAttractModeEnabled)
    {
        pvc = none;
        // End:0x81
        if(myPC != none)
        {
            pvc = PandoraGameViewportClient(myPC.GetViewportClient());
        }
        // End:0xF8
        if(pvc != none)
        {
            // End:0xC8
            if(bAttractModeRunning && !pvc.FullScreenIsMoviePlaying())
            {
                RestartAttractMode();
                EnableButtonDelay();                
            }
            else
            {
                // End:0xF8
                if(!bAttractModeRunning)
                {
                    AttractModeCurTime += DeltaTime;
                    // End:0xF8
                    if(AttractModeCurTime > TimeUntilAttractMode)
                    {
                        StartAttractMode();
                    }
                }
            }
        }
    }
    //return;    
}

event SceneActivated(bool bInitialActivation)
{
    local int I;

    super.SceneActivated(bInitialActivation);
    // End:0x2E
    if(!bInitialActivation)
    {
        Restore();
        RestoreFocus();        
    }
    else
    {
        I = 0;
        J0x35:

        // End:0x9B [Loop If]
        if(I < MenuItems.Length)
        {
            // End:0x91
            if((MenuItems[I].MenuItemUIObject != none) && !MenuItems[I].bDisabled)
            {
                SetFocusToMenuItem(I);
                // [Explicit Break]
                goto J0x9B;
            }
            I++;
            // [Loop Continue]
            goto J0x35;
        }
    }
    J0x9B:

    //return;    
}

event SceneDeactivated()
{
    local OnlinePlayerInterface PlayerInt;
    local int ControllerId;

    // End:0xA0
    if((myPC != none) && myPC.OnlineSub != none)
    {
        PlayerInt = myPC.OnlineSub.PlayerInterface;
        ControllerId = LocPlayer.ControllerId;
        // End:0xA0
        if(NotEqual_InterfaceInterface(PlayerInt, OnlinePlayerInterface(none)) && ControllerId != -1)
        {
            PlayerInt.ClearReadProfileSettingsCompleteDelegate(byte(ControllerId), OnReadProfileSettingsComplete);
        }
    }
    Cleanup();
    super.SceneDeactivated();
    //return;    
}

function NotifyGameSessionEnded()
{
    Cleanup();
    super(UIScene).NotifyGameSessionEnded();
    //return;    
}

function ActivateRemoteEvent(name EventName)
{
    local int I;
    local SeqEvent_RemoteEvent theRemoveEvent;
    local array<SequenceObject> outEvents;

    // End:0x44
    if(((EventName == 'None') || myPC == none) || myPC.WorldInfo.GetGameSequence() == none)
    {
        return;
    }
    myPC.WorldInfo.GetGameSequence().FindSeqObjectsByClass(Class'Engine.SeqEvent_RemoteEvent', true, outEvents);
    I = 0;
    J0x7B:

    // End:0x101 [Loop If]
    if(I < outEvents.Length)
    {
        theRemoveEvent = SeqEvent_RemoteEvent(outEvents[I]);
        // End:0xF7
        if((theRemoveEvent != none) && theRemoveEvent.EventName == EventName)
        {
            // End:0xF7
            if(theRemoveEvent.bEnabled)
            {
                theRemoveEvent.CheckActivate(myPC, myPC, false);
            }
        }
        I++;
        // [Loop Continue]
        goto J0x7B;
    }
    //return;    
}

function Restore()
{
    super.Restore();
    GetPC().bMsgBoxDisplayed = false;
    //return;    
}

function RestoreFocus()
{
    local int I;
    local UIObject MenuItemUIObject;

    // End:0x84
    if((MenuItems.Length > 0) && CurrMenuItemIdx < MenuItems.Length)
    {
        MenuItemUIObject = MenuItems[CurrMenuItemIdx].MenuItemUIObject;
        // End:0x81
        if((MenuItemUIObject != none) && !MenuItems[CurrMenuItemIdx].bDisabled)
        {
            KillFocusToMenuItem(CurrMenuItemIdx);
            SetFocusToMenuItem(CurrMenuItemIdx);
        }        
    }
    else
    {
        I = 0;
        J0x8B:

        // End:0x116 [Loop If]
        if(I < MenuItems.Length)
        {
            MenuItemUIObject = MenuItems[I].MenuItemUIObject;
            // End:0x10C
            if((MenuItemUIObject != none) && !MenuItems[I].bDisabled)
            {
                CurrMenuItemIdx = I;
                KillFocusToMenuItem(CurrMenuItemIdx);
                SetFocusToMenuItem(CurrMenuItemIdx);
                // [Explicit Break]
                goto J0x116;
            }
            I++;
            // [Loop Continue]
            goto J0x8B;
        }
    }
    J0x116:

    //return;    
}

function UIScene_ConfirmationDialog ShowMsgBox(string msg, optional string boxTitle = "", optional PandoraGRI.eMsgBoxType Mode = 0, optional delegate<OnResults> OnResultsDelegate, optional delegate<OnMessage> OnMessageDelegate, optional int nTimeoutValue, optional UIScene_BaseFrontEnd.eMsgBoxPriorityType msgPriority = 2)
{
    local UIScene_ConfirmationDialog msgBoxScene;

    msgBoxScene = Class'SPGameUISceneClient'.static.ShowMessageBox(LocPlayer, msgPriority, msg, boxTitle, Mode, nTimeoutValue, OnResultsDelegate, OnMessageDelegate);
    // End:0xC0
    if(msgBoxScene != none)
    {
        msgBoxScene.PreviousMenuScene = self;
        msgBoxScene.__OnSceneClose__Delegate = Restore;
        GetPC().bMsgBoxDisplayed = true;
        msgBoxScene.FadeIn(fadeInTimeEd);        
    }
    return msgBoxScene;
    //return ReturnValue;    
}

function OnMessageBoxResults(int PlayerIndex, bool bReturnValue)
{
    //return;    
}

function bool OnSubmitText(UIEditBox Sender, int PlayerIndex)
{
    return false;
    //return ReturnValue;    
}

function OnSliderChange(int MenuIndex, bool Positive)
{
    local int Val, MaxVal, MinVal;

    // End:0x34A
    if(myPC != none)
    {
        // End:0x225
        if(MenuItems[MenuIndex].SliderObj != none)
        {
            Val = int(MenuItems[MenuIndex].SliderObj.GetValue());
            MaxVal = int(MenuItems[MenuIndex].SliderObj.SliderValue.MaxValue);
            MinVal = int(MenuItems[MenuIndex].SliderObj.SliderValue.MinValue);
            // End:0xE6
            if(Positive)
            {
                Val = ((Val < MaxVal) ? ++Val : Val);                
            }
            else
            {
                Val = ((Val > MinVal) ? --Val : Val);
            }
            // End:0x225
            if(MenuItems[MenuIndex].SliderObj.SetValue(float(Val)))
            {
                myPC.ProfileSettings.SetProfileSettingValueInt(MenuItems[MenuIndex].SliderProfileId, Val);
                myPC.ProfileSettings.SetProfileDirty(true);
                // End:0x225
                if((MenuItems[MenuIndex].SliderValueObj != none) && MenuItems[MenuIndex].SliderValueConversion != 0.0000000)
                {
                    MenuItems[MenuIndex].SliderValueObj.SetValue(Left(string(float(Val) / MenuItems[MenuIndex].SliderValueConversion), MenuItems[MenuIndex].SliderValueTruncate));
                }
            }
        }
        // End:0x336
        if((MenuItems[MenuIndex].SliderObj == none) && MenuItems[MenuIndex].SliderValueObj != none)
        {
            myPC.ProfileSettings.GetProfileSettingValueId(MenuItems[MenuIndex].SliderProfileId, Val);
            Val = ((Val > 0) ? 0 : 1);
            myPC.ProfileSettings.SetProfileSettingValueId(MenuItems[MenuIndex].SliderProfileId, Val);
            myPC.ProfileSettings.SetProfileDirty(true);
            MenuItems[MenuIndex].SliderValueObj.SetValue(GetYesNoString(Val));
        }
        myPC.UpdateLocalCacheOfProfileSettings();
    }
    //return;    
}

// Export UUIScene_BaseFrontEnd::execChangeSliderByMousePress(FFrame&, void* const)
native function float ChangeSliderByMousePress(UISlider TheSlider, const out InputEventParameters EventParms);

// Export UUIScene_BaseFrontEnd::execIsMouseRightOfLabelCenter(FFrame&, void* const)
native function bool IsMouseRightOfLabelCenter(UILabel TheLabel, const out InputEventParameters EventParms);

// Export UUIScene_BaseFrontEnd::execIsMouseRightOfLabelButtonCenter(FFrame&, void* const)
native function bool IsMouseRightOfLabelButtonCenter(UILabelButton TheLabelButton, const out InputEventParameters EventParms);

// Export UUIScene_BaseFrontEnd::execSetUlistHeaders(FFrame&, void* const)
native function bool SetUlistHeaders(UIList ListUiObject, name sHeadeslot, string sNewHeader, int nColumn);

function OnSliderChangeByMousePress(int MenuIndex, const out InputEventParameters EventParms)
{
    local float valPercent;
    local int newVal, MaxVal, MinVal;

    // End:0x2FD
    if(myPC != none)
    {
        // End:0x1D8
        if(MenuItems[MenuIndex].SliderObj != none)
        {
            MaxVal = int(MenuItems[MenuIndex].SliderObj.SliderValue.MaxValue);
            MinVal = int(MenuItems[MenuIndex].SliderObj.SliderValue.MinValue);
            valPercent = ChangeSliderByMousePress(MenuItems[MenuIndex].SliderObj, EventParms);
            newVal = int(float(MaxVal) * valPercent);
            // End:0xE8
            if(newVal < MinVal)
            {
                newVal = MinVal;
            }
            myPC.ProfileSettings.SetProfileSettingValueInt(MenuItems[MenuIndex].SliderProfileId, newVal);
            myPC.ProfileSettings.SetProfileDirty(true);
            // End:0x1D8
            if((MenuItems[MenuIndex].SliderValueObj != none) && MenuItems[MenuIndex].SliderValueConversion != 0.0000000)
            {
                MenuItems[MenuIndex].SliderValueObj.SetValue(Left(string(float(newVal) / MenuItems[MenuIndex].SliderValueConversion), MenuItems[MenuIndex].SliderValueTruncate));
            }
        }
        // End:0x2E9
        if((MenuItems[MenuIndex].SliderObj == none) && MenuItems[MenuIndex].SliderValueObj != none)
        {
            myPC.ProfileSettings.GetProfileSettingValueId(MenuItems[MenuIndex].SliderProfileId, newVal);
            newVal = ((newVal > 0) ? 0 : 1);
            myPC.ProfileSettings.SetProfileSettingValueId(MenuItems[MenuIndex].SliderProfileId, newVal);
            myPC.ProfileSettings.SetProfileDirty(true);
            MenuItems[MenuIndex].SliderValueObj.SetValue(GetYesNoString(newVal));
        }
        myPC.UpdateLocalCacheOfProfileSettings();
    }
    //return;    
}

function OnCheckBoxClick(int MenuIndex)
{
    local bool bChecked;

    // End:0xEB
    if(myPC != none)
    {
        bChecked = !MenuItems[MenuIndex].CheckboxObj.IsChecked();
        MenuItems[MenuIndex].CheckboxObj.SetValue(bChecked);
        // End:0xA2
        if(bChecked)
        {
            myPC.ProfileSettings.SetProfileSettingValueId(MenuItems[MenuIndex].CheckboxProfileId, 1);            
        }
        else
        {
            myPC.ProfileSettings.SetProfileSettingValueId(MenuItems[MenuIndex].CheckboxProfileId, 0);
        }
        myPC.UpdateLocalCacheOfProfileSettings();
    }
    //return;    
}

function NavigatePreviousMenuItem()
{
    KillFocusToMenuItem(CurrMenuItemIdx);
    J0x0F:

    CurrMenuItemIdx--;
    // End:0x30
    if(CurrMenuItemIdx < 0)
    {
        CurrMenuItemIdx = MenuItems.Length - 1;
    }
    // End:0x0F
    if(!(!MenuItems[CurrMenuItemIdx].bDisabled))
        goto J0x0F;
    SetFocusToMenuItem(CurrMenuItemIdx);
    EnableButtonDelay();
    //return;    
}

function NavigateNextMenuItem()
{
    KillFocusToMenuItem(CurrMenuItemIdx);
    J0x0F:

    CurrMenuItemIdx++;
    // End:0x30
    if(CurrMenuItemIdx > (MenuItems.Length - 1))
    {
        CurrMenuItemIdx = 0;
    }
    // End:0x0F
    if(!(!MenuItems[CurrMenuItemIdx].bDisabled))
        goto J0x0F;
    SetFocusToMenuItem(CurrMenuItemIdx);
    EnableButtonDelay();
    //return;    
}

function bool NavigateMenuItemByIndex(int Index)
{
    // End:0x3B
    if(((Index < 0) || Index >= MenuItems.Length) || MenuItems[Index].bDisabled)
    {
        return false;
    }
    KillFocusToMenuItem(CurrMenuItemIdx);
    CurrMenuItemIdx = Index;
    SetFocusToMenuItem(CurrMenuItemIdx);
    EnableButtonDelay();
    return true;
    //return ReturnValue;    
}

function bool DoNavigation(UIScene_BaseFrontEnd.ENavigationType navType)
{
    local int Index;
    local string NextUIObjName;

    Index = CurrMenuItemIdx;
    J0x0B:

    NextUIObjName = MenuItems[Index].NaviInfo.UIObjNames[int(navType)];
    Index = MenuIndexByName(NextUIObjName);
    // End:0x0B
    if(!((Index == -1) || NavigateMenuItemByIndex(Index)))
        goto J0x0B;
    // End:0x7F
    if(Index >= 0)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function NavigateLeft()
{
    // End:0x43
    if(int(MenuStyle) != int(2))
    {
        // End:0x40
        if(MenuItems.Length > 1)
        {
            NavigatePreviousMenuItem();
            PlayUISound('NavigateLeft');
            amBXPulseMenuItemChange();
        }        
    }
    else
    {
        // End:0x6C
        if(DoNavigation(2))
        {
            PlayUISound('NavigateLeft');
            amBXPulseMenuItemChange();
        }
    }
    //return;    
}

function NavigateRight()
{
    // End:0x43
    if(int(MenuStyle) != int(2))
    {
        // End:0x40
        if(MenuItems.Length > 1)
        {
            NavigateNextMenuItem();
            PlayUISound('NavigateRight');
            amBXPulseMenuItemChange();
        }        
    }
    else
    {
        // End:0x6C
        if(DoNavigation(3))
        {
            PlayUISound('NavigateRight');
            amBXPulseMenuItemChange();
        }
    }
    //return;    
}

function NavigateUp()
{
    // End:0x43
    if(int(MenuStyle) != int(2))
    {
        // End:0x40
        if(MenuItems.Length > 1)
        {
            PlayUISound('NavigateUp');
            amBXPulseMenuItemChange();
            NavigatePreviousMenuItem();
        }        
    }
    else
    {
        // End:0x6C
        if(DoNavigation(0))
        {
            PlayUISound('NavigateUp');
            amBXPulseMenuItemChange();
        }
    }
    //return;    
}

function NavigateDown()
{
    // End:0x43
    if(int(MenuStyle) != int(2))
    {
        // End:0x40
        if(MenuItems.Length > 1)
        {
            PlayUISound('NavigateDown');
            amBXPulseMenuItemChange();
            NavigateNextMenuItem();
        }        
    }
    else
    {
        // End:0x6C
        if(DoNavigation(1))
        {
            PlayUISound('NavigateDown');
            amBXPulseMenuItemChange();
        }
    }
    //return;    
}

function NavigateMenuItems(UIScene_BaseFrontEnd.ENavigationType navType)
{
    switch(navType)
    {
        // End:0x1A
        case 0:
            NavigateUp();
            // End:0x56
            break;
        // End:0x2C
        case 1:
            NavigateDown();
            // End:0x56
            break;
        // End:0x3E
        case 2:
            NavigateLeft();
            // End:0x56
            break;
        // End:0x50
        case 3:
            NavigateRight();
            // End:0x56
            break;
        // End:0xFFFF
        default:
            // End:0x56
            break;
            break;
    }
    //return;    
}

function NavigatePreviousMenuItemBasedOnMenuStyle()
{
    switch(MenuStyle)
    {
        // End:0x1C
        case 1:
            NavigateMenuItems(2);
            // End:0x33
            break;
        // End:0x30
        case 0:
            NavigateMenuItems(0);
            // End:0x33
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

function NavigateNextMenuItemBasedOnMenuStyle()
{
    switch(MenuStyle)
    {
        // End:0x1C
        case 1:
            NavigateMenuItems(3);
            // End:0x33
            break;
        // End:0x30
        case 0:
            NavigateMenuItems(1);
            // End:0x33
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

function bool ProcessHorizontalMenuInput(const out InputEventParameters EventParms)
{
    // End:0x20
    if(IsInputNavLeft(EventParms))
    {
        NavigateMenuItems(2);
        return true;
    }
    // End:0x54
    if((IsInputNavRight(EventParms)) || IsTabPressed(EventParms))
    {
        NavigateMenuItems(3);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool ProcessVerticalMenuInput(const out InputEventParameters EventParms)
{
    // End:0x20
    if(IsInputNavUp(EventParms))
    {
        NavigateMenuItems(0);
        return true;
    }
    // End:0x54
    if((IsInputNavDown(EventParms)) || IsTabPressed(EventParms))
    {
        NavigateMenuItems(1);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool ProcessCustomMenuInput(const out InputEventParameters EventParms)
{
    // End:0x20
    if(IsInputNavUp(EventParms))
    {
        NavigateMenuItems(0);
        return true;
    }
    // End:0x40
    if(IsInputNavDown(EventParms))
    {
        NavigateMenuItems(1);
        return true;
    }
    // End:0x60
    if(IsInputNavLeft(EventParms))
    {
        NavigateMenuItems(2);
        return true;
    }
    // End:0x80
    if(IsInputNavRight(EventParms))
    {
        NavigateMenuItems(3);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool ProcessEditBoxInput(const out InputEventParameters EventParms)
{
    // End:0x5A
    if(((EventParms.InputKeyName == 'BackSpace') && !GetWorldInfo().IsConsoleBuild()) && int(EventParms.EventType) == int(1))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool ProcessSliderInput(const out InputEventParameters EventParms)
{
    // End:0x25
    if(IsInputNavLeft(EventParms))
    {
        OnSliderChange(CurrMenuItemIdx, false);        
    }
    else
    {
        // End:0x4A
        if(IsInputNavRight(EventParms))
        {
            OnSliderChange(CurrMenuItemIdx, true);            
        }
        else
        {
            // End:0x70
            if(IsInputLeftMouseDown(EventParms))
            {
                OnSliderChangeByMousePress(CurrMenuItemIdx, EventParms);
            }
        }
    }
    return false;
    //return ReturnValue;    
}

function bool ProcessLeftRightFuncs(const out InputEventParameters EventParms)
{
    // End:0x25
    if(IsInputNavLeft(EventParms))
    {
        OnLeftRight(CurrMenuItemIdx, false);        
    }
    else
    {
        // End:0x4A
        if(IsInputNavRight(EventParms))
        {
            OnLeftRight(CurrMenuItemIdx, true);            
        }
        else
        {
            // End:0x70
            if(IsInputLeftMouseDown(EventParms))
            {
                OnSliderChangeByMousePress(CurrMenuItemIdx, EventParms);
            }
        }
    }
    return false;
    //return ReturnValue;    
}

function UIScene OpenSubScene(UIScene Scene)
{
    local UIScene newScene;
    local UIScene_BaseFrontEnd newBFEScene;

    FadeOut(fadeOutTimeEd);
    SceneClient.OpenScene(Scene, LocPlayer, newScene);
    newBFEScene = UIScene_BaseFrontEnd(newScene);
    // End:0xC5
    if(newBFEScene != none)
    {
        newBFEScene.PreviousMenuScene = self;
        newBFEScene.LocPlayer = LocPlayer;
        newBFEScene.BaseScene = BaseScene;
        newBFEScene.SetVisibility(true);
        newBFEScene.FadeIn(fadeInTimeEd, fadeOutTimeEd / float(2));
        return newScene;
    }
    return none;
    //return ReturnValue;    
}

function bool IsButtonHighlighted(UIButton btn)
{
    local UIState CurState;

    CurState = btn.GetCurrentState();
    // End:0x31
    if(CurState.IsA('UIState_Active'))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function SetCurrentlyActivatedMenuItemToCurrentIndex()
{
    local int I;
    local UIState currentMenuItemState;
    local bool bIsActive;

    I = 0;
    J0x07:

    // End:0x13C [Loop If]
    if(I < MenuItems.Length)
    {
        currentMenuItemState = MenuItems[I].MenuItemUIObject.GetCurrentState();
        bIsActive = currentMenuItemState.IsA('UIState_Active');
        // End:0x98
        if(bIsActive || currentMenuItemState.IsA('UIState_Focused'))
        {
            CurrMenuItemIdx = I;
            // End:0x95
            if(bIsActive)
            {
                // [Explicit Break]
                goto J0x13C;
            }
            // [Explicit Continue]
            goto J0x132;
        }
        // End:0x132
        if(MenuItems[I].SliderObj != none)
        {
            currentMenuItemState = MenuItems[I].SliderObj.GetCurrentState();
            bIsActive = currentMenuItemState.IsA('UIState_Active');
            // End:0x132
            if(bIsActive || currentMenuItemState.IsA('UIState_Focused'))
            {
                CurrMenuItemIdx = I;
                // End:0x132
                if(bIsActive)
                {
                    // [Explicit Break]
                    goto J0x13C;
                }
            }
        }
        J0x132:

        I++;
        // [Loop Continue]
        goto J0x07;
    }
    J0x13C:

    //return;    
}

function bool ProcessAcceptInput(const out InputEventParameters EventParms)
{
    local UIScene newScene;

    // End:0x151
    if(IsInputAccept(EventParms))
    {
        // End:0x61
        if(MenuItems[CurrMenuItemIdx].bOnlyCallOnClick)
        {
            // End:0x5E
            if(PreOnClick(CurrMenuItemIdx))
            {
                PlayUISound('Clicked');
                OnClick(none, CurrMenuItemIdx);
            }            
        }
        else
        {
            // End:0xF7
            if(DoesThisMenuItemHaveValidSceneRef(MenuItems[CurrMenuItemIdx]))
            {
                // End:0xF4
                if(PreOnClick(CurrMenuItemIdx))
                {
                    PlayUISound('Clicked');
                    ActivateRemoteEvent(MenuItems[CurrMenuItemIdx].RemoteEvent);
                    newScene = OpenSubScene(GetMenuItemsValidSceneRef(MenuItems[CurrMenuItemIdx]));
                    OnClick(newScene, CurrMenuItemIdx);
                }                
            }
            else
            {
                // End:0x144
                if(MenuItems[CurrMenuItemIdx].CheckboxObj != none)
                {
                    // End:0x144
                    if(PreOnClick(CurrMenuItemIdx))
                    {
                        PlayUISound('Clicked');
                        OnCheckBoxClick(CurrMenuItemIdx);
                    }
                }
            }
        }
        // End:0x14F
        if(IsPCBuild())
        {
            return false;
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool PreOnClick(int MenuIndex)
{
    return true;
    //return ReturnValue;    
}

function bool ProcessCancelInput(const out InputEventParameters EventParms)
{
    // End:0x7F
    if(IsInputCancel(EventParms))
    {
        // End:0x7D
        if(PreviousMenuScene != none)
        {
            PlayUISound('SceneClosed');
            ActivateRemoteEvent(OnExitRemoteEventName);
            SceneClient.CloseScene(self);
            PreviousMenuScene.SetVisibility(true);
            PreviousMenuScene.FadeIn(fadeInTimeEd);
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool ProcessEscapeInput(const out InputEventParameters EventParms)
{
    // End:0xCA
    if(IsInputEscape(EventParms))
    {
        // End:0x99
        if(((((PreviousMenuScene == none) && myGameInfo != none) && myGameInfo.IsInShellLevel(CurrLevelName)) && LocPlayer != none) && LocPlayer.Actor != none)
        {            
            LocPlayer.Actor.ConsoleCommand("exit");            
        }
        else
        {
            PlayUISound('SceneClosed');
            ActivateRemoteEvent(OnExitRemoteEventName);
            SceneClient.CloseScene(self);
        }
    }
    return false;
    //return ReturnValue;    
}

function bool ProcessLoginInput(const out InputEventParameters EventParms)
{
    // End:0x34
    if(IsConsole(1))
    {
        // End:0x34
        if((IsInputAltAccept(EventParms)) && bEnableLogin)
        {
            ShowLoginUI();
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function bool ProcessToggleInput(const out InputEventParameters EventParms)
{
    // End:0x4F
    if(IsInputAlt2Accept(EventParms))
    {
        // End:0x4D
        if(MenuItems[CurrMenuItemIdx].CheckboxObj != none)
        {
            PlayUISound('Clicked');
            OnCheckBoxClick(CurrMenuItemIdx);
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool CustomInputKey(const out InputEventParameters EventParms)
{
    UpDateUsingGamePadForPC(EventParms);
    // End:0x27
    if(IsPCBuild())
    {
        HandleBackButtonInput(EventParms);
    }
    // End:0x50
    if(int(GetWorldInfo().NetMode) == int(NM_Standalone))
    {
        RestartAttractMode();
    }
    // End:0x24C
    if(!bInputDisabled)
    {
        // End:0x1FC
        if(MenuItems.Length > 0)
        {
            switch(MenuStyle)
            {
                // End:0x8B
                case 1:
                    // End:0x88
                    if(ProcessHorizontalMenuInput(EventParms))
                    {
                        return true;
                    }
                    // End:0xC6
                    break;
                // End:0xA7
                case 0:
                    // End:0xA4
                    if(ProcessVerticalMenuInput(EventParms))
                    {
                        return true;
                    }
                    // End:0xC6
                    break;
                // End:0xC3
                case 2:
                    // End:0xC0
                    if(ProcessCustomMenuInput(EventParms))
                    {
                        return true;
                    }
                    // End:0xC6
                    break;
                // End:0xFFFF
                default:
                    break;
            }
            // End:0x169
            if(MenuItems[CurrMenuItemIdx].EditBoxObj != none)
            {
                // End:0x169
                if((!IsInputEscape(EventParms) && !GetWorldInfo().IsConsoleBuild()) && !IsInputAccept(EventParms))
                {
                    // End:0x169
                    if((EventParms.InputKeyName != 'LeftMouseButton') && EventParms.InputKeyName != 'RightMouseButton')
                    {
                        return false;
                    }
                }
            }
            // End:0x1BA
            if((MenuItems[CurrMenuItemIdx].SliderObj != none) || MenuItems[CurrMenuItemIdx].SliderValueObj != none)
            {
                // End:0x1B7
                if(ProcessSliderInput(EventParms))
                {
                    return true;
                }                
            }
            else
            {
                // End:0x1E8
                if(MenuItems[CurrMenuItemIdx].bCallLeftRight)
                {
                    // End:0x1E8
                    if(ProcessLeftRightFuncs(EventParms))
                    {
                        return true;
                    }
                }
            }
            // End:0x1FC
            if(ProcessAcceptInput(EventParms))
            {
                return true;
            }
        }
        // End:0x210
        if(ProcessLoginInput(EventParms))
        {
            return true;
        }
        // End:0x224
        if(ProcessCancelInput(EventParms))
        {
            return true;
        }
        // End:0x238
        if(ProcessEscapeInput(EventParms))
        {
            return true;
        }
        // End:0x24C
        if(ProcessToggleInput(EventParms))
        {
            return true;
        }
    }
    // End:0x255
    if(IsPCBuild())
    {
    }
    return true;
    //return ReturnValue;    
}

function ChangeBGImage()
{
    bgImage = UIImage(FindChild(bgImageName, true));
    // End:0x44
    if((bgImage != none) && bgTexture != none)
    {
        bgImage.SetValue(bgTexture);
    }
    //return;    
}

function HideBGImage()
{
    // End:0x2B
    if((bgImage != none) && bHideMenuBG)
    {
        bgImage.SetVisibility(false);
    }
    //return;    
}

function name GetUIBGImageName()
{
    return 'bg';
    //return ReturnValue;    
}

function HideBGImageIfMP()
{
    local UIImage uiImage_Background;

    // End:0x5B
    if(int(GetWorldInfo().NetMode) != int(NM_Standalone))
    {
        uiImage_Background = UIImage(FindChild(GetUIBGImageName(), true));
        // End:0x5B
        if(uiImage_Background != none)
        {
            uiImage_Background.SetVisibility(false);
        }
    }
    //return;    
}

function ShowGamercard(int PRIIdx)
{
    local OnlineSubsystem OnlineSub;
    local PandoraGRI PGRI;

    // End:0x0F
    if(IsSystemLinkMatch())
    {
        return;
    }
    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x3B
    if(PGRI == none)
    {
        return;
    }
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0xBD
    if(OnlineSub != none)
    {
        // End:0xBA
        if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
        {
            OnlineSub.PlayerInterfaceEx.ShowGamerCardUI(0, PGRI.PRIArray[PRIIdx].UniqueId);
        }        
    }
    //return;    
}

function ShowGamerCardByUID(UniqueNetId Uid)
{
    local OnlineSubsystem OnlineSub;
    local PandoraGRI PGRI;

    // End:0x0F
    if(IsSystemLinkMatch())
    {
        return;
    }
    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x3B
    if(PGRI == none)
    {
        return;
    }
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0xA3
    if(OnlineSub != none)
    {
        // End:0xA0
        if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
        {
            OnlineSub.PlayerInterfaceEx.ShowGamerCardUI(0, Uid);
        }        
    }
    //return;    
}

function ShowFeedbackUI()
{
    local OnlineSubsystem OnlineSub;
    local PandoraGRI PGRI;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x2C
    if(PGRI == none)
    {
        return;
    }
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0xA8
    if(OnlineSub != none)
    {
        // End:0xA5
        if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
        {
            OnlineSub.PlayerInterfaceEx.ShowFeedbackUI(0, myPC.PlayerReplicationInfo.UniqueId);
        }        
    }
    //return;    
}

function ShowPlayersUI()
{
    local OnlineSubsystem OnlineSub;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x72
    if(OnlineSub != none)
    {
        // End:0x6F
        if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
        {
            OnlineSub.PlayerInterfaceEx.ShowPlayersUI(byte(LocPlayer.ControllerId));
        }        
    }
    //return;    
}

function NotifyDeviceSelectComplete(bool bWasSuccessful)
{
    local OnlinePlayerInterfaceEx PlayerInterfaceEx;

    // End:0x73
    if((myPC != none) && myPC.OnlineSub != none)
    {
        PlayerInterfaceEx = myPC.OnlineSub.PlayerInterfaceEx;
        PlayerInterfaceEx.ClearDeviceSelectionDoneDelegate(byte(LocPlayer.ControllerId), NotifyDeviceSelectComplete);        
    }
    // End:0x98
    if(myPC != none)
    {
        myPC.NotifyDeviceSelectComplete(bWasSuccessful);
    }
    //return;    
}

function OnNotSignedInConfirm(int PlayerIndex, PandoraGRI.eMsgBoxResult eReturnValue)
{
    local OnlineSubsystem OnlineSub;

    // End:0x12
    if(int(eReturnValue) == int(4))
    {
        return;
    }
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x55
    if((OnlineSub == none) || EqualEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
    {
        return;
    }
    OnlineSub.PlayerInterface.ShowLoginUI(false);
    //return;    
}

function bool PromptProfileSignIn()
{
    local OnlineSubsystem.ELoginStatus Status;

    // End:0xC3
    if(GetWorldInfo().IsConsoleBuild())
    {
        Status = GetLoginStatus(LocPlayer.ControllerId);
        // End:0xC3
        if((int(Status) != int(1)) && int(Status) != int(2))
        {
            ShowMsgBox(PlatformStrings $ "ErrorMessages.NotSignedInText>", PlatformStrings $ "ErrorMessages.NotSignedInTitle>", 0, OnNotSignedInConfirm);
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function bool HasOnlinePrivledges()
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInt;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x23
    if(OnlineSub == none)
    {
        return false;
    }
    PlayerInt = OnlineSub.PlayerInterface;
    // End:0x4E
    if(EqualEqual_InterfaceInterface(PlayerInt, OnlinePlayerInterface(none)))
    {
        return true;
    }
    // End:0x84
    if(int(PlayerInt.CanPlayOnline(byte(LocPlayer.ControllerId))) != int(0))
    {
        return true;        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

function bool PromptQuitOnProfileLogout()
{
    local OnlineSubsystem.ELoginStatus Status;

    // End:0xE0
    if(GetWorldInfo().IsConsoleBuild())
    {
        Status = GetLoginStatus(LocPlayer.ControllerId);
        // End:0xE0
        if((int(Status) != int(1)) && int(Status) != int(2))
        {
            ShowMsgBox(PlatformStrings $ "UIScene_ConfirmationDialog.ProfileRequiredText>", PlatformStrings $ "UIScene_ConfirmationDialog.ProfileRequired>", 0, OnProfileChangeMessageBoxResults);
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function bool PromptQuitOnProfileChange()
{
    local PandoraPlayerController PC;
    local SPGameUISceneClient theSceneClient;

    PC = GetPC();
    // End:0x73
    if(PC != none)
    {
        theSceneClient = PC.GetSceneClient();
        // End:0x4E
        if(theSceneClient.MainMenuIsActive())
        {
            return false;
        }
        // End:0x73
        if(theSceneClient.GetActiveUIScene('UIScene_StartMenu') != none)
        {
            return false;
        }
    }
    // End:0x115
    if(GetWorldInfo().IsConsoleBuild())
    {
        ShowMsgBox(PlatformStrings $ "UIScene_ConfirmationDialog.ProfileChangedText>", PlatformStrings $ "UIScene_ConfirmationDialog.ProfileChangedTitle>", 0, OnProfileChangeMessageBoxResults);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function OnProfileChangeMessageBoxResults(int PlayerIndex, PandoraGRI.eMsgBoxResult eReturnValue)
{
    // End:0x12
    if(int(eReturnValue) == int(4))
    {
        return;
    }
    // End:0x2D
    if((myPC == none) || myGameInfo == none)
    {        
    }
    else
    {
        // End:0x63
        if(!myGameInfo.IsInShellLevel(CurrLevelName))
        {
            myPC.QuitToMainMenu();            
        }
        else
        {
            ReturnToMainMenu();
        }
    }
    //return;    
}

function LoadBaseFrontEndChildScenes()
{
    // End:0x44
    if(MessageBoxScene == none)
    {
        MessageBoxScene = UIScene_ConfirmationDialog(DynamicLoadObject("PandoraShell.Confirmation_Dialog", Class'UIScene_ConfirmationDialog'));
    }
    // End:0x4F
    if(MessageBoxScene == none)
    {
    }
    //return;    
}

function string GetDemoMapName()
{
    local ConsolePandoraPlayerController CPPC;

    // End:0x36
    if(myPC != none)
    {
        CPPC = ConsolePandoraPlayerController(myPC);
        // End:0x36
        if(CPPC != none)
        {
            return CPPC.DemoMapName;
        }
    }
    return "";
    //return ReturnValue;    
}

function OnlineGameInterface GetGameInterface()
{
    local OnlineSubsystem OnlineSub;
    local OnlineGameInterface GameInt;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x39
    if(OnlineSub != none)
    {
        GameInt = OnlineSub.GameInterface;        
    }
    return GameInt;
    //return ReturnValue;    
}

static function OnlineAccountInterface GetAccountInterface()
{
    local OnlineSubsystem OnlineSub;
    local OnlineAccountInterface AccountInt;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x39
    if(OnlineSub != none)
    {
        AccountInt = OnlineSub.AccountInterface;        
    }
    return AccountInt;
    //return ReturnValue;    
}

static function OnlinePlayerInterface GetPlayerInterface()
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInt;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x39
    if(OnlineSub != none)
    {
        PlayerInt = OnlineSub.PlayerInterface;        
    }
    return PlayerInt;
    //return ReturnValue;    
}

function bool ValidateUserName(string UserName)
{
    local bool bResult;
    local string FirstChar;

    bResult = false;
    // End:0x1A7
    if((Len(UserName) >= 3) && Len(UserName) <= 15)
    {
        FirstChar = Mid(UserName, 0, 1);
        // End:0x110
        if((((((((((((((FirstChar != " ") && FirstChar != "+") && FirstChar != "#") && FirstChar != "@") && FirstChar != "0") && FirstChar != "1") && FirstChar != "2") && FirstChar != "3") && FirstChar != "4") && FirstChar != "5") && FirstChar != "6") && FirstChar != "7") && FirstChar != "8") && FirstChar != "9")
        {
            bResult = true;            
        }
        else
        {
            ShowMsgBox("<Strings:PandoraGame.ErrorMessages.InvalidUserNameCreateProfile_Message>", "<Strings:PandoraGame.ErrorMessages.InvalidUserName_Title>");
        }        
    }
    else
    {
        ShowMsgBox("<Strings:PandoraGame.ErrorMessages.InvalidUserNameCreateProfile_Message>", "<Strings:PandoraGame.ErrorMessages.InvalidUserName_Title>");
    }
    return bResult;
    //return ReturnValue;    
}

function ReturnToMainMenu()
{
    // End:0x50
    if(PreviousMenuScene != none)
    {
        PlayUISound('SceneClosed');
        ActivateRemoteEvent(OnExitRemoteEventName);
        SceneClient.CloseScene(self);
        PreviousMenuScene.ReturnToMainMenu();
    }
    //return;    
}

function PreviousMenu()
{
    // End:0x6B
    if(PreviousMenuScene != none)
    {
        PlayUISound('SceneClosed');
        ActivateRemoteEvent(OnExitRemoteEventName);
        SceneClient.CloseScene(self);
        PreviousMenuScene.SetVisibility(true);
        PreviousMenuScene.FadeIn(fadeInTimeEd);
    }
    //return;    
}

function NextMenu()
{
    local UIScene newScene;
    local UIScene_BaseFrontEnd newBFEScene;

    // End:0x12B
    if(DoesThisMenuItemHaveValidSceneRef(MenuItems[CurrMenuItemIdx]))
    {
        PlayUISound('Clicked');
        FadeOut(fadeOutTimeEd);
        ActivateRemoteEvent(MenuItems[CurrMenuItemIdx].RemoteEvent);
        SceneClient.OpenScene(GetMenuItemsValidSceneRef(MenuItems[CurrMenuItemIdx]), LocPlayer, newScene);
        newBFEScene = UIScene_BaseFrontEnd(newScene);
        // End:0x117
        if(newBFEScene != none)
        {
            newBFEScene.PreviousMenuScene = self;
            newBFEScene.LocPlayer = LocPlayer;
            newBFEScene.BaseScene = BaseScene;
            newBFEScene.SetVisibility(true);
            newBFEScene.FadeIn(fadeInTimeEd, fadeOutTimeEd / float(2));
        }
        OnClick(newScene, CurrMenuItemIdx);
    }
    //return;    
}

function string GetYesNoString(int Value)
{
    return ((Value > 0) ? (LeftArrow $ GenericYes) $ RightArrow : (LeftArrow $ GenericNo) $ RightArrow);
    //return ReturnValue;    
}

function string GetDegreeString(int Value)
{
    switch(Value)
    {
        // End:0x20
        case 0:
            return (LeftArrow $ GenericLow) $ RightArrow;
        // End:0x38
        case 1:
            return (LeftArrow $ GenericMedium) $ RightArrow;
        // End:0x51
        case 2:
            return (LeftArrow $ GenericHigh) $ RightArrow;
        // End:0xFFFF
        default:
            return (LeftArrow $ " ") $ RightArrow;
            break;
    }
    //return ReturnValue;    
}

exec function ResetProfile()
{
    local OnlinePlayerInterface PlayerInt;
    local int ControllerId;

    // End:0xB4
    if((myPC != none) && myPC.OnlineSub != none)
    {
        PlayerInt = myPC.OnlineSub.PlayerInterface;
        ControllerId = LocPlayer.ControllerId;
        // End:0xA0
        if(NotEqual_InterfaceInterface(PlayerInt, OnlinePlayerInterface(none)) && ControllerId != -1)
        {
            PlayerInt.AddReadProfileSettingsCompleteDelegate(byte(ControllerId), OnReadProfileSettingsComplete);
        }
        myPC.ResetProfile();
    }
    //return;    
}

function OnReadProfileSettingsComplete(byte LocalUserNum, bool bWasSuccessful)
{
    return;
    //return;    
}

function ResetProfileSettings()
{
    local int I, tmpVal;

    I = 0;
    J0x07:

    // End:0x254 [Loop If]
    if(I < MenuItems.Length)
    {
        // End:0xC9
        if(MenuItems[I].CheckboxObj != none)
        {
            myPC.ProfileSettings.GetProfileSettingValueId(MenuItems[I].CheckboxProfileId, tmpVal);
            // End:0xA2
            if(tmpVal == 0)
            {
                MenuItems[I].CheckboxObj.SetValue(false);                
            }
            else
            {
                MenuItems[I].CheckboxObj.SetValue(true);
            }
        }
        // End:0x147
        if(MenuItems[I].SliderObj != none)
        {
            myPC.ProfileSettings.GetProfileSettingValueInt(MenuItems[I].SliderProfileId, tmpVal);
            MenuItems[I].SliderObj.SetValue(float(tmpVal));
        }
        // End:0x24A
        if(MenuItems[I].SliderValueObj != none)
        {
            myPC.ProfileSettings.GetProfileSettingValueId(MenuItems[I].SliderProfileId, tmpVal);
            // End:0x21A
            if(MenuItems[I].SliderValueConversion != 0.0000000)
            {
                MenuItems[I].SliderValueObj.SetValue(Left(string(float(tmpVal) / MenuItems[I].SliderValueConversion), MenuItems[I].SliderValueTruncate));
                // [Explicit Continue]
                goto J0x24A;
            }
            MenuItems[I].SliderValueObj.SetValue(GetYesNoString(tmpVal));
        }
        J0x24A:

        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function bool DoesThisMenuItemHaveValidSceneRef(MenuInfo ItemToTest)
{
    // End:0x1B
    if(ItemToTest.SceneRef != none)
    {
        return true;        
    }
    else
    {
        // End:0x3F
        if(IsPCBuild())
        {
            // End:0x3C
            if(ItemToTest.SceneRefPC != none)
            {
                return true;
            }            
        }
        else
        {
            // End:0x63
            if(IsXboxBuild())
            {
                // End:0x60
                if(ItemToTest.SceneRefXBox360 != none)
                {
                    return true;
                }                
            }
            else
            {
                // End:0x84
                if(IsPS3Build())
                {
                    // End:0x84
                    if(ItemToTest.SceneRefPS3 != none)
                    {
                        return true;
                    }
                }
            }
        }
    }
    return false;
    //return ReturnValue;    
}

function UIScene GetMenuItemsValidSceneRef(MenuInfo ItemToTest)
{
    // End:0x35
    if(IsPCBuild() && ItemToTest.SceneRefPC != none)
    {
        return ItemToTest.SceneRefPC;        
    }
    else
    {
        // End:0x6A
        if(IsXboxBuild() && ItemToTest.SceneRefXBox360 != none)
        {
            return ItemToTest.SceneRefXBox360;            
        }
        else
        {
            // End:0x9F
            if(IsPS3Build() && ItemToTest.SceneRefPS3 != none)
            {
                return ItemToTest.SceneRefPS3;                
            }
            else
            {
                // End:0xC6
                if(ItemToTest.SceneRef != none)
                {
                    return ItemToTest.SceneRef;
                }
            }
        }
    }
    return none;
    //return ReturnValue;    
}

function SetFocusToMenuItem(int Index)
{
    // End:0x1F
    if((Index < 0) || Index >= MenuItems.Length)
    {
        return;
    }
    MenuItems[Index].MenuItemUIObject.SetFocus(MenuItems[Index].MenuItemUIObject.GetOwner());
    //return;    
}

function KillFocusToMenuItem(int Index)
{
    // End:0x1F
    if((Index < 0) || Index >= MenuItems.Length)
    {
        return;
    }
    MenuItems[Index].MenuItemUIObject.KillFocus(MenuItems[Index].MenuItemUIObject.GetOwner());
    //return;    
}

function int GetMenuItemIndexFromName(string strButtonName)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x47 [Loop If]
    if(I < MenuItems.Length)
    {
        // End:0x3D
        if(MenuItems[I].ButtonName == strButtonName)
        {
            return I;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return -1;
    //return ReturnValue;    
}

function HandleMPBGOverlay()
{
    local UIObject UIObj;

    UIObj = FindChild('MP_BGoverlay', true);
    // End:0x6D
    if(UIObj != none)
    {
        // End:0x58
        if(int(GetWorldInfo().NetMode) != int(NM_Standalone))
        {
            UIObj.SetVisibility(true);            
        }
        else
        {
            UIObj.SetVisibility(false);
        }
    }
    //return;    
}

final function bool SavePlayerData()
{
    myPC.PlayerForceDelayedCheckpointSave();
    return true;
    //return ReturnValue;    
}

final function LoadSavedGameCallBack(int PlayerIndex, PandoraGRI.eMsgBoxResult eReturnValue)
{
    RealLoadSavedGame();
    //return;    
}

final function RealLoadSavedGame()
{
    // End:0x8E
    if(GetWorldInfo().IsConsoleBuild(2))
    {
        // End:0x8B
        if((LocPlayer != none) && LocPlayer.Actor != none)
        {            
            LocPlayer.Actor.ConsoleCommand("open PandoraGame_P?LoadSaveGame");
            SetLoadingMovie();
        }        
    }
    else
    {
        myPC.RealLoadLastCheckpoint();
    }
    //return;    
}

final function BaseLoadSavedGame()
{
    // End:0x13B
    if((myPC.ProfileSettings.IsProfileDirty() || myPC.SPCM.CheckpointsToSave.Length > 0) && !Class'Engine.Engine'.static.IsSPDemoBuild())
    {
        // End:0xC9
        if(GetWorldInfo().IsConsoleBuild(2))
        {
            ShowMsgBox("<Strings:PlatformPS3.Saving.SaveOnExit>", " ", 9, LoadSavedGameCallBack, SavePlayerData, int(1.5000000));            
        }
        else
        {
            ShowMsgBox("<Strings:PandoraGame.PandoraGameViewportClient.SavingMessage>" @ "...", " ", 9, LoadSavedGameCallBack, SavePlayerData, int(1.5000000));
        }        
    }
    else
    {
        RealLoadSavedGame();
    }
    //return;    
}

function bool IsPlayerUsingLocalProfile(UniqueNetId NetID)
{
    local LocalPlayer LocPlayer;
    local int I;
    local PlayerController PC;
    local OnlineSubsystem OnlineSub;
    local PandoraGRI PGRI;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x2C
    if(PGRI == none)
    {
        return false;
    }
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x4F
    if(OnlineSub == none)
    {
        return false;
    }
    I = 0;
    J0x56:

    // End:0x132 [Loop If]
    if(I < PGRI.PRIArray.Length)
    {
        // End:0x128
        if(PGRI.PRIArray[I].UniqueId == NetID)
        {
            PC = PlayerController(PGRI.PRIArray[I].Owner);
            // End:0x128
            if(PC != none)
            {
                LocPlayer = LocalPlayer(PC.Player);
                // End:0x128
                if(int(OnlineSub.PlayerInterface.GetLoginStatus(byte(LocPlayer.ControllerId))) == int(1))
                {
                    return true;
                }
            }
        }
        I++;
        // [Loop Continue]
        goto J0x56;
    }
    return false;
    //return ReturnValue;    
}

function bool IsSystemLinkMatch()
{
    local OnlineGameSettings Settings;
    local PandoraGRI PGRI;

    // End:0x41
    if(GetWorldInfo().Game != none)
    {
        Settings = GetWorldInfo().Game.GameSettings;        
    }
    else
    {
        Settings = none;
    }
    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x74
    if(PGRI == none)
    {
        return false;
    }
    // End:0x99
    if(Settings == none)
    {
        Settings = PGRI.GetPandoraGameSettings();
    }
    // End:0xB9
    if(myGameInfo != none)
    {
        // End:0xB9
        if(myGameInfo.bLanMatch)
        {
            return true;
        }
    }
    // End:0xDB
    if((Settings != none) && Settings.bIsLanMatch)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool MouseIsOverActiveMenuButton()
{
    local int I;
    local SPGameUISceneClient SPSceneClient;

    // End:0xD7
    if(IsPCBuild())
    {
        SPSceneClient = SPGameUISceneClient(Class'Engine.UIRoot'.static.GetSceneClient());
        I = 0;
        J0x2B:

        // End:0xD7 [Loop If]
        if(I < MenuItems.Length)
        {
            // End:0xCD
            if(MenuItems[I].MenuItemUIObject.GetCurrentState().IsA('UIState_Active'))
            {
                // End:0xCD
                if(PtIntersectsUIObject(MenuItems[I].MenuItemUIObject, float(SPSceneClient.MousePosition.X), float(SPSceneClient.MousePosition.Y)))
                {
                    return true;
                }
            }
            I++;
            // [Loop Continue]
            goto J0x2B;
        }
    }
    return false;
    //return ReturnValue;    
}

function bool MouseIsOverMenuButton()
{
    local SPGameUISceneClient SPSceneClient;

    // End:0x22
    if((CurrMenuItemIdx < 0) || CurrMenuItemIdx > (MenuItems.Length - 1))
    {
        return false;
    }
    // End:0xA3
    if(IsPCBuild())
    {
        SPSceneClient = SPGameUISceneClient(Class'Engine.UIRoot'.static.GetSceneClient());
        // End:0xA3
        if(PtIntersectsUIObject(MenuItems[CurrMenuItemIdx].MenuItemUIObject, float(SPSceneClient.MousePosition.X), float(SPSceneClient.MousePosition.Y)))
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function bool IsInputAcceptNoMouse(const InputEventParameters EventParms)
{
    // End:0x7A
    if(((EventParms.InputKeyName == 'XboxTypeS_A') || !GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Enter') && int(EventParms.EventType) == int(1))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool IsInputAccept(const InputEventParameters EventParms)
{
    // End:0x7A
    if(((EventParms.InputKeyName == 'XboxTypeS_A') || !GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Enter') && int(EventParms.EventType) == int(1))
    {
        return true;
    }
    // End:0xD4
    if(IsPCBuild() && bDisplayCursor)
    {
        // End:0xD4
        if((EventParms.InputKeyName == 'LeftMouseButton') && int(EventParms.EventType) == int(1))
        {
            return MouseIsOverMenuButton();
        }
    }
    return false;
    //return ReturnValue;    
}

function OnActiveMoveAccepted()
{
    SetCurrentlyActivatedMenuItemToCurrentIndex();
    //return;    
}

function bool HandleBackButtonInput(const out InputEventParameters EventParms)
{
    local SPGameUISceneClient SPSceneClient;

    // End:0x9C
    if(btnBack != none)
    {
        // End:0x9C
        if(IsPCBuild())
        {
            // End:0x9C
            if(IsInputLeftMouseUp(EventParms))
            {
                SPSceneClient = SPGameUISceneClient(Class'Engine.UIRoot'.static.GetSceneClient());
                // End:0x9C
                if(PtIntersectsUIObject(btnBack, float(SPSceneClient.MousePosition.X), float(SPSceneClient.MousePosition.Y)))
                {
                    return OnBackButtonClicked(btnBack, 0);
                }
            }
        }
    }
    return false;
    //return ReturnValue;    
}

function DeactivateMenuOptions()
{
    local int I;
    local UIObject Obj;

    I = 0;
    J0x07:

    // End:0x83 [Loop If]
    if(I < MenuItems.Length)
    {
        Obj = MenuItems[I].MenuItemUIObject;
        // End:0x79
        if(Obj != none)
        {
            // End:0x79
            if(Obj.GetCurrentState().IsA('UIState_Active'))
            {
                Obj.DeactivateStateByClass(Class'Engine.UIState_Active', 0);
            }
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}
