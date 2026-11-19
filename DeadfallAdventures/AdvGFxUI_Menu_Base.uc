class AdvGFxUI_Menu_Base extends AdvGfxMoviePlayer
    config(UI);

var AdvFrontEnd Frontend;
var bool bCanOpenPartyMenu;
var bool bCanOpenChangePartyType;
var bool bDisplayFooter;
var bool bDisplayPartyWindow;
var bool bDisableGuestLogin;
var bool bInitialized;
var transient bool bIsPlayingCloseAnimation;
var config bool bDemoMode;
var config bool bMultiplayerBetaIMode;
var transient bool bDisplayControllerDisconnected;
var GFxObject RootMC;
var GFxObject MenuMC;
var GFxObject BgMC;
var GFxObject KursorMC;
var float MenuBasePosX;
var float MenuBasePosY;
var float MenuStartRotationY;
var string Action;
var const localized string Select;
var const localized string back;
var const localized string Exit;
var transient OnlineSubsystem OnlineSub;
var transient int ControllerDisconnectedId;

function bool Start(optional bool StartPaused = false)
{
    super(GFxMoviePlayer).Start(StartPaused);
    Advance(0.0000000);
    RootMC = GetVariableObject("_root");
    MenuMC = RootMC.GetObject("menu");
    BgMC = RootMC.GetObject("bg");
    KursorMC = RootMC.GetObject("kursor");
    // End:0x16B
    if(GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode())
    {
        KursorMC.SetVisible(false);
        bIgnoreMouseInput = true;        
    }
    else
    {
        KursorMC.SetVisible(AdvGFxHudWrapper(GetPC().myHUD).bShowCursor);
        bIgnoreMouseInput = !AdvGFxHudWrapper(GetPC().myHUD).bShowCursor;
    }
    // End:0x253
    if(!bInitialized)
    {
        MenuMC.GetPosition(MenuBasePosX, MenuBasePosY);
    }
    PlayOpenAnimation();
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    bIsPlayingCloseAnimation = false;
    bInitialized = true;
    return true;
    //return ReturnValue;    
}

function UpdateFooter()
{
    local array<name> ButtonAliases;

    ButtonAliases.Length = 0;
    Frontend.footer.FooterUpdate(ButtonAliases);
    //return;    
}

function FloatMenuAnimationX(bool Direction)
{
    // End:0x75
    if(Direction)
    {
        TweenTo(MenuMC, 5.0000000, "_xrotation", 8.0000000, 2, "FloatMenu1");
        TweenTo(MenuMC, 5.0000000, "_x", MenuBasePosX + float(4), 2);        
    }
    else
    {
        TweenTo(MenuMC, 5.0000000, "_xrotation", -8.0000000, 2, "FloatMenu2");
        TweenTo(MenuMC, 5.0000000, "_x", MenuBasePosX - float(4), 2);
    }
    //return;    
}

function FloatMenuAnimationY(bool Direction)
{
    // End:0x76
    if(Direction)
    {
        TweenTo(MenuMC, 7.0000000, "_yrotation", -20.0000000, 2, "FloatMenu3");
        TweenTo(MenuMC, 7.0000000, "_y", MenuBasePosY + 7.0000000, 2);        
    }
    else
    {
        TweenTo(MenuMC, 7.0000000, "_yrotation", -40.0000000, 2, "FloatMenu4");
        TweenTo(MenuMC, 7.0000000, "_y", MenuBasePosY - 7.0000000, 2);
    }
    //return;    
}

function ProcessTweenCallback(string Callback, GFxObject TargetMC)
{
    switch(Callback)
    {
        // End:0x30
        case "FloatMenu1":
            FloatMenuAnimationX(false);
            // End:0x8D
            break;
        // End:0x4D
        case "FloatMenu2":
            FloatMenuAnimationX(true);
            // End:0x8D
            break;
        // End:0x6A
        case "FloatMenu3":
            FloatMenuAnimationY(false);
            // End:0x8D
            break;
        // End:0x87
        case "FloatMenu4":
            FloatMenuAnimationY(true);
            // End:0x8D
            break;
        // End:0xFFFF
        default:
            // End:0x8D
            break;
            break;
    }
    //return;    
}

function PlayOpenAnimation()
{
    MenuMC.GotoAndPlay("open");
    //return;    
}

function PlayCloseAnimation()
{
    // End:0x0F
    if(bIsPlayingCloseAnimation)
    {
        return;
    }
    bIsPlayingCloseAnimation = true;
    MenuMC.GotoAndPlay("close");
    //return;    
}

function OnOpenAnimationComplete()
{
    //return;    
}

function OnCloseAnimationComplete()
{
    //return;    
}

function HandleControllerDisconnected(bool bIsConnected, int ControllerId)
{
    bDisplayControllerDisconnected = !bIsConnected;
    ControllerDisconnectedId = ControllerId;
    //return;    
}

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    // End:0x4A
    if(Frontend != none)
    {
        return Frontend.FilterButtonInput(ControllerId, ButtonName, InputEvent);
    }
    return false;
    //return ReturnValue;    
}

function AdvGameMenu GetMenuGame()
{
    local WorldInfo WInfo;

    WInfo = Class'Engine.WorldInfo'.static.GetWorldInfo();
    return ((WInfo != none) ? AdvGameMenu(WInfo.Game) : none);
    //return ReturnValue;    
}

function AdvGRI GetMenuGRI()
{
    local WorldInfo WInfo;

    WInfo = Class'Engine.WorldInfo'.static.GetWorldInfo();
    return ((WInfo != none) ? AdvGRI(WInfo.GRI) : none);
    //return ReturnValue;    
}

function AdvPlayerController GetAdvPC()
{
    local LocalPlayer LocalPlayerOwner;

    LocalPlayerOwner = GetLP();
    // End:0x25
    if(LocalPlayerOwner == none)
    {
        return none;
    }
    return AdvPlayerController(LocalPlayerOwner.Actor);
    //return ReturnValue;    
}

function Tick(float DeltaTime)
{
    super(UTGFxTweenableMoviePlayer).Tick(DeltaTime);
    //return;    
}

function bool IsPlayerLoggedIn(optional bool bOnlineRequired, optional int PlayerIndex = 0)
{
    local int ControllerId;

    ControllerId = Class'Engine.UIInteraction'.static.GetPlayerControllerId(PlayerIndex);
    return IsControllerLoggedIn(ControllerId, bOnlineRequired);
    //return ReturnValue;    
}

function bool IsControllerLoggedIn(int ControllerId, optional bool bOnlineRequired)
{
    local OnlineSubsystem.ELoginStatus LoginStatus;
    local bool Retval;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0xF4
    if(OnlineSub != none)
    {
        // End:0xF4
        if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
        {
            LoginStatus = OnlineSub.PlayerInterface.GetLoginStatus(byte(ControllerId));
            Retval = ((bOnlineRequired) ? int(LoginStatus) == int(2) : int(LoginStatus) != int(0));
        }
    }
    return Retval;
    //return ReturnValue;    
}

function DisableSaving()
{
    AdvEngine(Class'Engine.Engine'.static.GetEngine()).SetCurrentDeviceID(-1);
    AdvEngine(Class'Engine.Engine'.static.GetEngine()).bShouldWriteCheckpointToDisk = false;
    //return;    
}

function TriggerLoginMsg()
{
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0xA3
    if(OnlineSub != none)
    {
        // End:0xA3
        if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
        {
            OnlineSub.PlayerInterface.ShowLoginUI();
        }
    }
    //return;    
}

event OnClose()
{
    super(GFxMoviePlayer).OnClose();
    // End:0x4D
    if(bDisplayControllerDisconnected)
    {
        GetAdvPC().ToggleControllerDisconnectedMessage(true, ControllerDisconnectedId);
        bDisplayControllerDisconnected = false;
    }
    //return;    
}

event OnCleanup()
{
    super(GFxMoviePlayer).OnCleanup();
    Frontend = none;
    //return;    
}

function bool CanCreateLocalPlayer(int ControllerId)
{
    return false;
    //return ReturnValue;    
}

function AddNATStatus(out array<name> ButtonAliases)
{
    local OnlineSubsystem.ENATType NatType;

    NatType = 1;
    // End:0xD3
    if((Class'Engine.GameEngine'.static.GetOnlineSubsystem() != none) && NotEqual_InterfaceInterface(Class'Engine.GameEngine'.static.GetOnlineSubsystem().SystemInterface, OnlineSystemInterface(none)))
    {
        NatType = Class'Engine.GameEngine'.static.GetOnlineSubsystem().SystemInterface.GetNATType();
    }
    // End:0x19B
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        switch(NatType)
        {
            // End:0x13E
            case 0:
                ButtonAliases.AddItem('NATUnknown');                
                // End:0x19B
                break;
            // End:0x15C
            case 1:
                ButtonAliases.AddItem('NATOpen');                
                // End:0x19B
                break;
            // End:0x17A
            case 2:
                ButtonAliases.AddItem('NATModerate');                
                // End:0x19B
                break;
            // End:0x198
            case 3:
                ButtonAliases.AddItem('NATStrict');                
                // End:0x19B
                break;
            // End:0xFFFF
            default:
                break;
        }
    }
    else
    {
        //return;        
    }
}

static function AdvGRI GetGRI()
{
    return AdvGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    //return ReturnValue;    
}

defaultproperties
{
    bDisplayFooter=true
    bDisableGuestLogin=true
    MenuStartRotationY=-30.0000000
    Select="Select"
    back="Back"
    Exit="Exit"
    bCaptureInput=true
    SoundThemes=/* Array type was not detected. */
}