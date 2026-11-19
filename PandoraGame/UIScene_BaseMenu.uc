class UIScene_BaseMenu extends SPUIScene
    native;

var bool bTickWhenHidden;
var transient bool bSceneReady;
var bool bSceneUsesAmBxEffects;
var transient float FadeDestination;
var transient UIScene AdminMenuScene;
var transient UIScene ConfirmationScene;
var transient UIScene StatsScene;
var transient UIScene OpenedStatScene;
var transient UIScene OpenedHostOptionsScene;
var PandoraPlayerController myPC;
var PandoraGameInfo myGameInfo;
var LocalPlayer LocPlayer;
var string PlatformStrings;
var IntPoint LastMousePos;
var UIObject LastActiveWidget;

// Export UUIScene_BaseMenu::execUnsubscribeInputEventNative(FFrame&, void* const)
native function bool UnsubscribeInputEventNative(name InputKey, UIScreenObject Handler, int PlayerIndex);

function PandoraPlayerController GetPC()
{
    local PandoraPlayerController PC;
    local LocalPlayer LP;

    LP = GetPlayerOwner();
    // End:0x49
    if((LP != none) && LP.Actor != none)
    {
        PC = PandoraPlayerController(LP.Actor);
    }
    return PC;
    //return ReturnValue;    
}

final function bool IsPCBuild()
{
    return !GetWorldInfo().IsConsoleBuild();
    //return ReturnValue;    
}

final function bool IsPS3Build()
{
    return GetWorldInfo().IsConsoleBuild(2);
    //return ReturnValue;    
}

final function bool IsXboxBuild()
{
    return GetWorldInfo().IsConsoleBuild(1);
    //return ReturnValue;    
}

final function bool WithXboxLive()
{
    return IsXboxBuild();
    //return ReturnValue;    
}

final function bool WithGameSpy()
{
    return IsPS3Build() || IsPCBuild();
    //return ReturnValue;    
}

event InitScene()
{
    myPC = GetPC();
    LocPlayer = GetPlayerOwner();
    myGameInfo = PandoraGameInfo(GetWorldInfo().Game);
    __OnRawInputKey__Delegate = CustomInputKey;
    bSceneReady = true;
    // End:0x7D
    if(WithXboxLive())
    {
        PlatformStrings = "<Strings:PlatformXbox.";        
    }
    else
    {
        // End:0xA5
        if(IsPCBuild())
        {
            PlatformStrings = "<Strings:PlatformPc.";            
        }
        else
        {
            PlatformStrings = "<Strings:platformPS3.";
        }
    }
    // End:0xD3
    if(IsPCBuild())
    {
        bDisplayCursor = true;
    }
    //return;    
}

event SceneDeactivated()
{
    myGameInfo = none;
    super(UIScene).SceneDeactivated();
    //return;    
}

event SceneActivated(bool bInitialActivation)
{
    local SPGameUISceneClient SPSceneClient;

    super(UIScene).SceneActivated(bInitialActivation);
    // End:0x62
    if(IsPCBuild())
    {
        SPSceneClient = SPGameUISceneClient(Class'Engine.UIRoot'.static.GetSceneClient());
        SPSceneClient.__CBPreActivateControlByMouse__Delegate = MousePreActivate;
        SPSceneClient.__CBPostActivateControlByMouse__Delegate = MousePostActivate;
    }
    //return;    
}

function OnActiveMoveAccepted()
{
    //return;    
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
    // End:0x122
    if((SPSceneClient.MousePosition.X == LastMousePos.X) && SPSceneClient.MousePosition.Y == LastMousePos.Y)
    {
        // End:0x11D
        if(Widget.GetCurrentState().IsA('UIState_Active') && !Widget.IsA('UIList'))
        {
            Widget.DeactivateStateByClass(Class'Engine.UIState_Active', 0);
        }
        return false;        
    }
    else
    {
        LastMousePos.X = SPSceneClient.MousePosition.X;
        LastMousePos.Y = SPSceneClient.MousePosition.Y;
        OnActiveMoveAccepted();
        return true;
    }
    //return ReturnValue;    
}

function MousePostActivate(UIObject Widget)
{
    // End:0x81
    if((Widget != none) && LastActiveWidget != Widget)
    {
        // End:0x81
        if(Widget.GetCurrentState().IsA('UIState_Active') && !Widget.IsA('UIList'))
        {
            PlayUISound('NavigateDown');
            amBXPulseMenuItemChange();
            LastActiveWidget = Widget;
        }
    }
    //return;    
}

function amBXPulseMenuItemChange()
{
    // End:0x44
    if(bSceneUsesAmBxEffects)
    {
        // End:0x44
        if(!myPC.IsMoviePlaying())
        {
            myPC.PlayAmBxScript("menu_pulse", 70);
        }
    }
    //return;    
}

function bool IsInputNavLeft(const InputEventParameters EventParms)
{
    // End:0xB7
    if((((EventParms.InputKeyName == 'XboxTypeS_DPad_Left') || EventParms.InputKeyName == 'Gamepad_LeftStick_Left') || !GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Left') && (int(EventParms.EventType) == int(0)) || int(EventParms.EventType) == int(2))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool IsInputNavRight(const InputEventParameters EventParms)
{
    // End:0xB7
    if((((EventParms.InputKeyName == 'XboxTypeS_DPad_Right') || EventParms.InputKeyName == 'Gamepad_LeftStick_Right') || !GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Right') && (int(EventParms.EventType) == int(0)) || int(EventParms.EventType) == int(2))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool IsInputNavUp(const InputEventParameters EventParms)
{
    // End:0xB7
    if((((EventParms.InputKeyName == 'XboxTypeS_DPad_Up') || EventParms.InputKeyName == 'Gamepad_LeftStick_Up') || !GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Up') && (int(EventParms.EventType) == int(0)) || int(EventParms.EventType) == int(2))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool IsInputNavTriggerL(const InputEventParameters EventParms)
{
    // End:0x97
    if(((EventParms.InputKeyName == 'XboxTypeS_LeftTrigger') || !GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'PageUp') && (int(EventParms.EventType) == int(0)) || int(EventParms.EventType) == int(2))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool IsInputNavTriggerR(const InputEventParameters EventParms)
{
    // End:0x97
    if(((EventParms.InputKeyName == 'XboxTypeS_RightTrigger') || !GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'PageDown') && (int(EventParms.EventType) == int(0)) || int(EventParms.EventType) == int(2))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool IsInputNavShoulderL(const InputEventParameters EventParms)
{
    // End:0x97
    if(((EventParms.InputKeyName == 'XboxTypeS_LeftShoulder') || !GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Comma') && (int(EventParms.EventType) == int(0)) || int(EventParms.EventType) == int(2))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool IsInputNavShoulderR(const InputEventParameters EventParms)
{
    // End:0x97
    if(((EventParms.InputKeyName == 'XboxTypeS_RightShoulder') || !GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Period') && (int(EventParms.EventType) == int(0)) || int(EventParms.EventType) == int(2))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool IsInputNavDown(const InputEventParameters EventParms)
{
    // End:0xB7
    if((((EventParms.InputKeyName == 'XboxTypeS_DPad_Down') || EventParms.InputKeyName == 'Gamepad_LeftStick_Down') || !GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Down') && (int(EventParms.EventType) == int(0)) || int(EventParms.EventType) == int(2))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool IsTabPressed(const InputEventParameters EventParms)
{
    // End:0x77
    if((!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Tab') && (int(EventParms.EventType) == int(0)) || int(EventParms.EventType) == int(2))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool IsInputAltAccept(const InputEventParameters EventParms)
{
    // End:0x7A
    if(((EventParms.InputKeyName == 'XboxTypeS_Y') || !GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'SpaceBar') && int(EventParms.EventType) == int(1))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool IsInputAlt2Accept(const InputEventParameters EventParms)
{
    // End:0x7A
    if(((EventParms.InputKeyName == 'XboxTypeS_X') || !GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Z') && int(EventParms.EventType) == int(1))
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
    // End:0xCB
    if(IsPCBuild() && bDisplayCursor)
    {
        // End:0xCB
        if((EventParms.InputKeyName == 'LeftMouseButton') && int(EventParms.EventType) == int(1))
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function bool IsInputCancel(const InputEventParameters EventParms)
{
    // End:0x5D
    if(((EventParms.InputKeyName == 'XboxTypeS_B') || EventParms.InputKeyName == 'B') && int(EventParms.EventType) == int(1))
    {
        return true;
    }
    // End:0x71
    if(IsPCBuild() && bDisplayCursor)
    {
    }
    return false;
    //return ReturnValue;    
}

function bool IsInputEscape(const InputEventParameters EventParms)
{
    // End:0x5A
    if(((EventParms.InputKeyName == 'Escape') && !GetWorldInfo().IsConsoleBuild()) && int(EventParms.EventType) == int(1))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool IsInputStart(const InputEventParameters EventParms)
{
    // End:0x3D
    if((EventParms.InputKeyName == 'XboxTypeS_Start') && int(EventParms.EventType) == int(1))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool IsInputLeftMouseUp(const InputEventParameters EventParms)
{
    // End:0x48
    if((IsPCBuild() && EventParms.InputKeyName == 'LeftMouseButton') && int(EventParms.EventType) == int(1))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool IsMouseEvent(const InputEventParameters EventParms)
{
    // End:0x49
    if(IsPCBuild())
    {
        // End:0x49
        if((EventParms.InputKeyName == 'LeftMouseButton') || EventParms.InputKeyName == 'RightMouseButton')
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function bool IsInputLeftMouseDown(const InputEventParameters EventParms)
{
    // End:0x48
    if((IsPCBuild() && EventParms.InputKeyName == 'LeftMouseButton') && int(EventParms.EventType) == int(0))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool IsInputRightMouseUp(const InputEventParameters EventParms)
{
    // End:0x48
    if((IsPCBuild() && EventParms.InputKeyName == 'RightMouseButton') && int(EventParms.EventType) == int(1))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool IsInputRightMouseDown(const InputEventParameters EventParms)
{
    // End:0x48
    if((IsPCBuild() && EventParms.InputKeyName == 'RightMouseButton') && int(EventParms.EventType) == int(0))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function DisplayGamerCard(int ControllerId, PlayerReplicationInfo PRI)
{
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterfaceEx LivePI;

    // End:0x80
    if(PRI != none)
    {
        OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
        // End:0x80
        if(OnlineSub != none)
        {
            LivePI = OnlineSub.PlayerInterfaceEx;
            // End:0x80
            if(NotEqual_InterfaceInterface(LivePI, OnlinePlayerInterfaceEx(none)))
            {
                LivePI.ShowGamerCardUI(byte(ControllerId), PRI.UniqueId);
            }
        }
    }
    //return;    
}

event FadeScene(float TargetOpacity, float TargetTime)
{
    FadeOut(TargetTime);
    //return;    
}

event UpdateScene(float DeltaTime, WorldInfo WorldInfo)
{
    //return;    
}

function UpDateUsingGamePadForPC(const out InputEventParameters EventParms)
{
    // End:0x67
    if(IsPCBuild())
    {
        // End:0x4B
        if(myPC.IsAXBoxButton(EventParms.InputKeyName))
        {
            myPC.PlayerInput.bUsingGamepad = true;            
        }
        else
        {
            myPC.PlayerInput.bUsingGamepad = false;
        }
    }
    //return;    
}

function bool CustomInputKey(const out InputEventParameters EventParms)
{
    UpDateUsingGamePadForPC(EventParms);
    // End:0x2E
    if(IsInputNavRight(EventParms))
    {
        amBXPulseMenuItemChange();        
    }
    else
    {
        // End:0x4D
        if(IsInputNavLeft(EventParms))
        {
            amBXPulseMenuItemChange();            
        }
        else
        {
            // End:0x6C
            if(IsInputNavDown(EventParms))
            {
                amBXPulseMenuItemChange();                
            }
            else
            {
                // End:0x8B
                if(IsInputNavUp(EventParms))
                {
                    amBXPulseMenuItemChange();                    
                }
            }
        }
    }
    return false;
    //return ReturnValue;    
}

function Restore()
{
    FadeIn(fadeInTimeEd);
    //return;    
}

function PostSceneActived(UIScene ActivatedScene, bool bInitialActivation)
{
    SceneInputMode = 1;
    bRenderParentScenes = false;
    //return;    
}

function ShowAchievementsUI()
{
    local OnlineSubsystem OnlineSub;
    local int PlayerIndex, ControllerId;

    // End:0x10
    if(myPC == none)
    {
        return;        
    }
    else
    {
        PlayerIndex = myPC.GetUIPlayerIndex();
        ControllerId = Class'Engine.UIInteraction'.static.GetPlayerControllerId(PlayerIndex);
    }
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0xB0
    if(OnlineSub != none)
    {
        // End:0xB0
        if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
        {
            // End:0xAD
            if(OnlineSub.PlayerInterfaceEx.ShowAchievementsUI(byte(ControllerId)))
            {
            }            
        }
    }
    //return;    
}

function PandoraGRI.EGameStatus SetOnlineStatusMode(PandoraGRI.EGameStatus Status)
{
    local PandoraPlayerController PC;
    local PandoraGRI PGRI;
    local PandoraGRI.EGameStatus LastGameStatus;

    PGRI = PandoraGRI(GetWorldInfo().GRI);
    // End:0x2A
    if(PGRI == none)
    {
    }
    PC = GetPC();
    // End:0x86
    if(PC != none)
    {
        LastGameStatus = PGRI.GameStatus;
        PGRI.GameStatus = Status;
        PC.UpdateGameOnlineStatus();        
    }
    return LastGameStatus;
    //return ReturnValue;    
}
