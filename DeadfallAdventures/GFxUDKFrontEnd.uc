class GFxUDKFrontEnd extends GFxMoviePlayer
    config(UI);

struct ViewInfo
{
    var name ViewName;
    var string SWFName;
    var array<name> DependantViews;

    structdefaultproperties
    {
        ViewName="None"
        SWFName=""
        DependantViews=none
    }
};

var GFxObject RootMC;
var GFxObject ManagerMC;
var bool bInitialized;
var GFxUDKFrontEnd_MainMenu MainMenuView;
var GFxUDKFrontEnd_InstantAction InstantActionView;
var GFxUDKFrontEnd_Multiplayer MultiplayerView;
var GFxUDKFrontEnd_HostGame HostGameView;
var GFxUDKFrontEnd_MapSelect MapSelectView;
var GFxUDKFrontEnd_GameMode GameModeView;
var GFxUDKFrontEnd_Mutators MutatorsView;
var GFxUDKFrontEnd_Settings SettingsView;
var GFxUDKFrontEnd_ServerSettings ServerSettingsView;
var GFxUDKFrontEnd_JoinGame JoinGameView;
var GFxUDKFrontEnd_InfoDialog InfoDialog;
var GFxUDKFrontEnd_FilterDialog FilterDialog;
var GFxUDKFrontEnd_JoinDialog JoinDialog;
var GFxUDKFrontEnd_ErrorDialog ErrorDialog;
var GFxUDKFrontEnd_PasswordDialog PasswordDialog;
var config array<config ViewInfo> ViewData;
var array<GFxUDKFrontEnd_View> ViewStack;
var array<name> LoadedViews;
//var delegate<EscapeDelegate> __EscapeDelegate__Delegate;

delegate EscapeDelegate()
{
    //return;    
}

function bool Start(optional bool StartPaused = false)
{
    super.Start();
    Advance(0.0000000);
    // End:0x38
    if(!bInitialized)
    {
        ConfigFrontEnd();
    }
    ConsoleCommand("pause");
    // End:0x9E
    if(Class'Engine.WorldInfo'.static.IsConsoleBuild(1) || Class'Engine.WorldInfo'.static.IsConsoleBuild(2))
    {
        ASShowCursor(false);
    }
    LoadViews();
    return true;
    //return ReturnValue;    
}

final function ConfigFrontEnd()
{
    RootMC = GetVariableObject("_root");
    ManagerMC = RootMC.GetObject("manager");
    bInitialized = true;
    //return;    
}

final function LoadViews()
{
    local byte I;

    I = 0;
    J0x0C:

    // End:0x53 [Loop If]
    if(int(I) < ViewData.Length)
    {
        LoadView(ViewData[int(I)]);
        I++;
        // [Loop Continue]
        goto J0x0C;
    }
    //return;    
}

final function LoadView(ViewInfo InViewInfo)
{
    local ASValue asval;
    local array<ASValue> args;
    local GFxObject ViewContainer, ViewLoader;

    ViewContainer = ManagerMC.CreateEmptyMovieClip(string(InViewInfo.ViewName) $ "Container");
    ViewLoader = ViewContainer.CreateEmptyMovieClip(string(InViewInfo.ViewName));
    asval.Type = 4;
    asval.S = InViewInfo.SWFName;
    args[0] = asval;
    ViewContainer.SetVisible(false);    
    ViewLoader.Invoke("loadMovie", args);
    LoadedViews.AddItem(InViewInfo.ViewName);    
    //return;    
}

final function LoadViewByName(name InViewName)
{
    local byte I;

    I = 0;
    J0x0C:

    // End:0xA3 [Loop If]
    if(int(I) < ViewData.Length)
    {
        // End:0x95
        if((ViewData[int(I)].ViewName == InViewName) && !IsViewLoaded(InViewName))
        {
            LoadView(ViewData[int(I)]);
        }
        I++;
        // [Loop Continue]
        goto J0x0C;
    }
    //return;    
}

final function bool IsViewLoaded(name InViewName)
{
    local byte I;

    I = 0;
    J0x0C:

    // End:0x59 [Loop If]
    if(int(I) < ViewData.Length)
    {
        // End:0x4B
        if(LoadedViews[int(I)] == InViewName)
        {
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x0C;
    }
    return false;
    //return ReturnValue;    
}

final function SetEscapeDelegate(delegate<EscapeDelegate> InDelegate)
{
    local GFxObject _global;

    _global = GetVariableObject("_global");
    ActionScriptSetFunction(_global, "OnEscapeKeyPress");
    //return;    
}

final function PushViewByName(name TargetViewName, optional GFxUDKFrontEnd_Screen ParentView)
{
    switch(TargetViewName)
    {
        // End:0x36
        case 'InstantAction':
            ConfigureTargetView(InstantActionView);
            // End:0x14C
            break;
        // End:0x58
        case 'Multiplayer':
            ConfigureTargetView(MultiplayerView);
            // End:0x14C
            break;
        // End:0x7A
        case 'GameMode':
            ConfigureTargetView(GameModeView);
            // End:0x14C
            break;
        // End:0x9C
        case 'MapSelect':
            ConfigureTargetView(MapSelectView);
            // End:0x14C
            break;
        // End:0xBE
        case 'Settings':
            ConfigureTargetView(SettingsView);
            // End:0x14C
            break;
        // End:0xE0
        case 'Mutators':
            ConfigureTargetView(MutatorsView);
            // End:0x14C
            break;
        // End:0x102
        case 'HostGame':
            ConfigureTargetView(HostGameView);
            // End:0x14C
            break;
        // End:0x124
        case 'ServerSettings':
            ConfigureTargetView(ServerSettingsView);
            // End:0x14C
            break;
        // End:0x146
        case 'JoinGame':
            ConfigureTargetView(JoinGameView);
            // End:0x14C
            break;
        // End:0xFFFF
        default:
            // End:0x14C
            break;
            break;
    }
    //return;    
}

function GFxUDKFrontEnd_Dialog SpawnDialog(name TargetDialogName, optional GFxUDKFrontEnd_Screen ParentView)
{
    switch(TargetDialogName)
    {
        // End:0x3D
        case 'InfoDialog':
            ConfigureTargetDialog(InfoDialog);
            return InfoDialog;
        // End:0x66
        case 'JoinDialog':
            ConfigureTargetDialog(JoinDialog);
            return JoinDialog;
        // End:0x8F
        case 'FilterDialog':
            ConfigureTargetDialog(FilterDialog);
            return FilterDialog;
        // End:0xB8
        case 'ErrorDialog':
            ConfigureTargetDialog(ErrorDialog);
            return ErrorDialog;
        // End:0xE1
        case 'PasswordDialog':
            ConfigureTargetDialog(PasswordDialog);
            return PasswordDialog;
        // End:0xFFFF
        default:
            return none;
            break;
    }
    //return ReturnValue;    
}

function ConfigureTargetDialog(coerce GFxUDKFrontEnd_View TargetDialog)
{
    // End:0xB8
    if(TargetDialog != none)
    {
        // End:0x4D
        if(ViewStack.Length > 0)
        {
            ViewStack[ViewStack.Length - 1].DisableSubComponents(true);
        }
        TargetDialog.OnViewActivated();
        TargetDialog.OnTopMostView(true);
        ViewStack.AddItem(TargetDialog);        
        PushDialogView(TargetDialog);        
    }
    //return;    
}

function ConfigureTargetView(GFxUDKFrontEnd_View TargetView)
{
    // End:0xBC
    if(IsViewAllowed(TargetView))
    {
        // End:0x54
        if(ViewStack.Length > 0)
        {
            ViewStack[ViewStack.Length - 1].DisableSubComponents(true);
        }
        TargetView.OnViewActivated();
        TargetView.OnTopMostView(true);
        ViewStack.AddItem(TargetView);        
        PushView(TargetView);
    }
    //return;    
}

function bool IsViewAllowed(GFxUDKFrontEnd_View TargetView)
{
    local byte I;
    local name TargetViewName;

    // End:0x11
    if(TargetView == none)
    {
        return false;
    }
    TargetViewName = TargetView.ViewName;
    I = 0;
    J0x45:

    // End:0xA7 [Loop If]
    if(int(I) < ViewStack.Length)
    {
        // End:0x99
        if(ViewStack[int(I)].ViewName == TargetViewName)
        {
            return false;
        }
        I++;
        // [Loop Continue]
        goto J0x45;
    }
    return true;
    //return ReturnValue;    
}

function PushView(coerce GFxUDKFrontEnd_View TargetView)
{
    ActionScriptVoid("pushStandardView");
    //return;    
}

function PushDialogView(coerce GFxUDKFrontEnd_View dialogView)
{
    ActionScriptVoid("pushDialogView");
    //return;    
}

function SetSelectionFocus(coerce GFxObject MovieClip)
{
    // End:0x22
    if(MovieClip != none)
    {
        ASSetSelectionFocus(MovieClip);
    }
    //return;    
}

function ASSetSelectionFocus(GFxObject MovieClip)
{
    ActionScriptVoid("setSelectionFocus");
    //return;    
}

function GFxObject PopView()
{
    // End:0x12
    if(ViewStack.Length <= 1)
    {
        return none;
    }
    ViewStack[ViewStack.Length - 1].OnViewClosed();
    ViewStack.Remove(ViewStack.Length - 1, 1);    
    ViewStack[ViewStack.Length - 1].OnTopMostView(false);
    return PopViewStub();
    //return ReturnValue;    
}

final function GFxObject PopViewStub()
{
    return ActionScriptObject("popView");
    //return ReturnValue;    
}

final function UpdateViewLayout()
{
    ActionScriptVoid("updateViewLayout");
    //return;    
}

final function ConfigureView(GFxUDKFrontEnd_View InView, name WidgetName, name WidgetPath)
{
    SetWidgetPathBinding(InView, WidgetPath);
    InView.MenuManager = self;
    InView.ViewName = WidgetName;
    InView.OnViewLoaded();
    //return;    
}

final function ASShowCursor(bool bShowCursor)
{
    ActionScriptVoid("showCursor");
    //return;    
}

function PostWidgetInit()
{
    //return;    
}

function bool CheckLinkConnectionAndError(optional string AlternateTitle, optional string AlternateMessage)
{
    local GFxUDKFrontEnd_ErrorDialog Dialog;
    local bool bResult;

    // End:0x33
    if(Class'GFxUIView'.static.HasLinkConnection())
    {
        bResult = true;        
    }
    else
    {
        // End:0x74
        if(AlternateTitle == "")
        {
            AlternateTitle = "<Strings:UTGameUI.Errors.Error_Title>";
        }
        // End:0xC2
        if(AlternateMessage == "")
        {
            AlternateMessage = "<Strings:UTGameUI.Errors.LinkDisconnected_Message>";
        }
        Dialog = GFxUDKFrontEnd_ErrorDialog(SpawnDialog('ErrorDialog'));
        Dialog.SetTitle(AlternateTitle);
        Dialog.SetInfo(AlternateMessage);
        bResult = false;
    }
    return bResult;
    //return ReturnValue;    
}

event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
    local bool bResult;

    bResult = false;
    switch(WidgetName)
    {
        // End:0x9D
        case 'MainMenu':
            // End:0x9A
            if(MainMenuView == none)
            {
                MainMenuView = GFxUDKFrontEnd_MainMenu(Widget);
                ConfigureView(MainMenuView, WidgetName, WidgetPath);
                ConfigureTargetView(MainMenuView);
                bResult = true;
            }
            // End:0x6A5
            break;
        // End:0x108
        case 'InstantAction':
            // End:0x105
            if(InstantActionView == none)
            {
                InstantActionView = GFxUDKFrontEnd_InstantAction(Widget);
                ConfigureView(InstantActionView, WidgetName, WidgetPath);
                bResult = true;
            }
            // End:0x6A5
            break;
        // End:0x173
        case 'MapSelect':
            // End:0x170
            if(MapSelectView == none)
            {
                MapSelectView = GFxUDKFrontEnd_MapSelect(Widget);
                ConfigureView(MapSelectView, WidgetName, WidgetPath);
                bResult = true;
            }
            // End:0x6A5
            break;
        // End:0x1DE
        case 'GameMode':
            // End:0x1DB
            if(GameModeView == none)
            {
                GameModeView = GFxUDKFrontEnd_GameMode(Widget);
                ConfigureView(GameModeView, WidgetName, WidgetPath);
                bResult = true;
            }
            // End:0x6A5
            break;
        // End:0x249
        case 'Mutators':
            // End:0x246
            if(MutatorsView == none)
            {
                MutatorsView = GFxUDKFrontEnd_Mutators(Widget);
                ConfigureView(MutatorsView, WidgetName, WidgetPath);
                bResult = true;
            }
            // End:0x6A5
            break;
        // End:0x2B4
        case 'Settings':
            // End:0x2B1
            if(SettingsView == none)
            {
                SettingsView = GFxUDKFrontEnd_Settings(Widget);
                ConfigureView(SettingsView, WidgetName, WidgetPath);
                bResult = true;
            }
            // End:0x6A5
            break;
        // End:0x31F
        case 'ServerSettings':
            // End:0x31C
            if(ServerSettingsView == none)
            {
                ServerSettingsView = GFxUDKFrontEnd_ServerSettings(Widget);
                ConfigureView(ServerSettingsView, WidgetName, WidgetPath);
                bResult = true;
            }
            // End:0x6A5
            break;
        // End:0x38A
        case 'HostGame':
            // End:0x387
            if(HostGameView == none)
            {
                HostGameView = GFxUDKFrontEnd_HostGame(Widget);
                ConfigureView(HostGameView, WidgetName, WidgetPath);
                bResult = true;
            }
            // End:0x6A5
            break;
        // End:0x3F5
        case 'Multiplayer':
            // End:0x3F2
            if(MultiplayerView == none)
            {
                MultiplayerView = GFxUDKFrontEnd_Multiplayer(Widget);
                ConfigureView(MultiplayerView, WidgetName, WidgetPath);
                bResult = true;
            }
            // End:0x6A5
            break;
        // End:0x460
        case 'JoinGame':
            // End:0x45D
            if(JoinGameView == none)
            {
                JoinGameView = GFxUDKFrontEnd_JoinGame(Widget);
                ConfigureView(JoinGameView, WidgetName, WidgetPath);
                bResult = true;
            }
            // End:0x6A5
            break;
        // End:0x4CB
        case 'InfoDialog':
            // End:0x4C8
            if(InfoDialog == none)
            {
                InfoDialog = GFxUDKFrontEnd_InfoDialog(Widget);
                ConfigureView(InfoDialog, WidgetName, WidgetPath);
                bResult = true;
            }
            // End:0x6A5
            break;
        // End:0x536
        case 'JoinDialog':
            // End:0x533
            if(JoinDialog == none)
            {
                JoinDialog = GFxUDKFrontEnd_JoinDialog(Widget);
                ConfigureView(JoinDialog, WidgetName, WidgetPath);
                bResult = true;
            }
            // End:0x6A5
            break;
        // End:0x5A1
        case 'FilterDialog':
            // End:0x59E
            if(FilterDialog == none)
            {
                FilterDialog = GFxUDKFrontEnd_FilterDialog(Widget);
                ConfigureView(FilterDialog, WidgetName, WidgetPath);
                bResult = true;
            }
            // End:0x6A5
            break;
        // End:0x60C
        case 'PasswordDialog':
            // End:0x609
            if(PasswordDialog == none)
            {
                PasswordDialog = GFxUDKFrontEnd_PasswordDialog(Widget);
                ConfigureView(PasswordDialog, WidgetName, WidgetPath);
                bResult = true;
            }
            // End:0x6A5
            break;
        // End:0x69F
        case 'ErrorDialog':
            // End:0x69C
            if(ErrorDialog == none)
            {
                ErrorDialog = GFxUDKFrontEnd_ErrorDialog(Widget);
                ConfigureView(ErrorDialog, WidgetName, WidgetPath);
                SetSelectionFocus(MainMenuView.ListMC);
                bResult = true;
            }
            // End:0x6A5
            break;
        // End:0xFFFF
        default:
            // End:0x6A5
            break;
            break;
    }
    return bResult;
    //return ReturnValue;    
}

final function LoadDependantViews(name InViewName)
{
    //return;    
}

final function DestroyDependantViews(name InViewName)
{
    //return;    
}

function bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    // End:0x78
    if(GFxUDKFrontEnd_JoinGame(ViewStack[ViewStack.Length - 1]) != none)
    {
        return GFxUDKFrontEnd_JoinGame(ViewStack[ViewStack.Length - 1]).OnFilterButtonInput(ControllerId, ButtonName, InputEvent);
    }
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    bPauseGameWhileActive=true
    bCaptureInput=true
    TimingMode=GFxTimingMode.TM_Real
    WidgetBindings=/* Array type was not detected. */
}