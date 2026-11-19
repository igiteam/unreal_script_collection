class PKGameViewportClient extends UTGameViewportClient within Engine
    transient
    native
    config(Game);

var config float XLoadingTextTitlePos;
var config float YLoadingTextTitlePos;
var config float LoadingTextTitleScale;
var config float XIntroLoadingTextTitlePos;
var config float YIntroLoadingTextTitlePos;
var config float IntroLoadingTextTitleScale;
var config float XLoadingTextDescPos;
var config float YLoadingTextDescPos;
var config float LoadingTextDescScale;
var config float LoadingTextDescWrapWidth;
var config float XLoadingTextHintPos;
var config float YLoadingTextHintPos;
var config float LoadingTextHintScale;
var config float LoadingTextHintWrapWidth;
var config int HintCount;
var bool bIsReturningToMainMenu;

event bool Init(out string OutError)
{
    ViewportConsole = new (self) Class'PKConsole';
    // End:0x87
    if((InsertInteraction(ViewportConsole)) == -1)
    {
        OutError = "Failed to add interaction to GlobalInteractions array:" @ string(ViewportConsole);
        return false;
    }
    return super(GameViewportClient).Init(OutError);
    //return ReturnValue;    
}

event bool UnregisteredControllerButtonPress(int ControllerId)
{
    local PKPartyPC PC;
    local PainGFxMenuHudWrapper HUD;

    // End:0xF0
    foreach Class'Engine.WorldInfo'.static.GetWorldInfo().LocalPlayerControllers(Class'PKPartyPC', PC)
    {
        HUD = PainGFxMenuHudWrapper(PC.myHUD);
        // End:0xEF
        if((HUD != none) && HUD.FrontEnd != none)
        {            
            return HUD.FrontEnd.UnregisteredInput(ControllerId);
        }        
    }    
    return false;
    //return ReturnValue;    
}

event LoadMapTransition()
{
    local string LoadingTextTitle, LoadingTextHint;
    local int I, Offset;

    Outer.RemoveAllOverlays();
    LoadingTextTitle = Localize("Generic", "Loading", "PKHDGame");
    // End:0xEB
    if(EvilEngine(Outer).FramesUntilIntroMayBeSkipped > 0)
    {
        Outer.AddOverlay(Outer.GetSubtitleFont(), LoadingTextTitle, XIntroLoadingTextTitlePos, YIntroLoadingTextTitlePos, IntroLoadingTextTitleScale, IntroLoadingTextTitleScale, false);        
    }
    else
    {
        Outer.AddOverlay(Outer.GetSubtitleFont(), LoadingTextTitle, XLoadingTextTitlePos, YLoadingTextTitlePos, LoadingTextTitleScale, LoadingTextTitleScale, true);
        Offset = Rand(HintCount);
        I = 0;
        J0x177:

        // End:0x265 [Loop If]
        if(I < HintCount)
        {
            LoadingTextHint = Localize("LoadingHints", "Hint" $ string(1 + ((I + Offset) % HintCount)), "Hints");
            Outer.AddOverlayWrapped(Outer.GetSubtitleFont(), LoadingTextHint, XLoadingTextHintPos, YLoadingTextHintPos, LoadingTextHintScale, LoadingTextHintScale, LoadingTextHintWrapWidth);
            ++I;
            // [Loop Continue]
            goto J0x177;
        }
    }
    //return;    
}

function UpdateActiveSplitscreenType()
{
    local bool bSplitScreenCanBeUsed;

    // End:0x22
    if(int(DesiredSplitscreenType) == int(0))
    {
        ActiveSplitscreenType = 0;
        return;
    }
    // End:0xEE
    if(((Outer.GetCurrentWorldInfo().Game != none) && PKGameCooperative(Outer.GetCurrentWorldInfo().Game) != none) && int(Outer.GetCurrentWorldInfo().NetMode) == int(NM_Standalone))
    {
        bSplitScreenCanBeUsed = true;
    }
    // End:0x11B
    if(ShouldForceFullscreenViewport() || !bSplitScreenCanBeUsed)
    {
        ActiveSplitscreenType = 0;        
    }
    else
    {
        super.UpdateActiveSplitscreenType();
    }
    //return;    
}

function bool OnJanuarySubscriptionFound(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    local PKEngine Eng;

    // End:0x77
    if(SelectedInputAlias == 'GenericOpenSteamStore')
    {
        Eng = PKEngine(Class'Engine.Engine'.static.GetEngine());
        // End:0x77
        if(Eng != none)
        {
            Eng.SteamActivateGameOverlayToBuyFullGame();
        }
    }
    return true;
    //return ReturnValue;    
}

simulated function ShowJanuarySubscriptionWindow()
{
    local array<name> ButtonAliases;
    local PKUIManager UIManager;

    UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x15C
    if(UIManager != none)
    {
        ButtonAliases.AddItem('GenericOpenSteamStore');
        ButtonAliases.AddItem('GenericCancel');
        UIManager.ShowUIMessage('JanuarySubscription', Localize("MessageBoxErrorStrings", "FullGameNeeded_Title", "PKHDGame"), Localize("MessageBoxErrorStrings", "FullGameNeeded_Message", "PKHDGame"), ButtonAliases, OnJanuarySubscriptionFound, Outer.GamePlayers[0],,,,, false);
    }
    //return;    
}

event SetProgressMessage(PlayerController.EProgressMessageType MessageType, string Message, optional string Title, optional bool bIgnoreFutureNetworkMessages)
{
    local PKPlayerController GPC;

    GPC = PKPlayerController(Outer.GamePlayers[0].Actor);
    switch(MessageType)
    {
        // End:0x102
        case 1:
            // End:0xFF
            if(Title == "JanuaryFreeWeekend")
            {
                // End:0xB7
                if(GPC != none)
                {
                    GPC.ShowLoadingMovie(false);
                }
                ShowJanuarySubscriptionWindow();
                // End:0xDD
                if(GPC == none)
                {
                    ReturnToMainMenuNoPC();                    
                }
                else
                {
                    GPC.ReturnToMainMenu(false);
                }
                return;
            }
            // End:0x105
            break;
        // End:0xFFFF
        default:
            break;
    }
    super.SetProgressMessage(MessageType, Message, Title, bIgnoreFutureNetworkMessages);
    //return;    
}

function NotifyConnectionError(PlayerController.EProgressMessageType MessageType, optional string Message = Localize("Errors", "ConnectionFailed", "Engine"), optional string Title = Localize("Errors", "ConnectionFailed_Title", "Engine"))
{
    local WorldInfo WI;
    local PKUIManager UIManager;
    local array<name> ButtonAliases;
    local PlayerController PC;
    local PKPlayerController GPC;
    local PKLocalPlayer LP;
    local OnlineSubsystem OnlineSub;
    local OnlineGameSettings GameSettings;
    local OnlineSubsystem.ELoginStatus LoginStatus;
    local bool bNoSignChange;

    WI = Class'Engine.Engine'.static.GetCurrentWorldInfo();
    LP = PKLocalPlayer(Outer.GamePlayers[0]);
    PC = Outer.GamePlayers[0].Actor;
    GPC = PKPlayerController(PC);
    // End:0x150
    if(GPC != none)
    {
        GPC.ShowLoadingMovie(false);
    }
    PC.bIgnoreNetworkMessages = true;
    WI.Pauser = none;
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x25F
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
    {
        LoginStatus = OnlineSub.PlayerInterface.GetLoginStatus(byte(LP.ControllerId));
    }
    bNoSignChange = int(LoginStatus) == int(2);
    // End:0x552
    if(bNoSignChange || GPC == none)
    {
        // End:0x552
        if(((int(MessageType) == int(4)) || int(MessageType) == int(7)) || int(MessageType) == int(6))
        {
            GameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
            // End:0x354
            if((GameSettings != none) && GameSettings.bUsesArbitration)
            {
            }
            UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
            // End:0x4B2
            if(Outer.GetCurrentWorldInfo().IsConsoleBuild())
            {
                // End:0x4AF
                if(UIManager != none)
                {
                    ButtonAliases.AddItem('GenericContinue');
                    UIManager.ShowUIMessage('ConfirmNetworkLost', Localize("Errors", "ConnectionFailed_Title", "PKHDGame"), Localize("Errors", "ConnectionFailed", "PKHDGame"), ButtonAliases, None, Outer.GamePlayers[0],,,,, false);
                }                
            }
            else
            {
                // End:0x552
                if(UIManager != none)
                {
                    ButtonAliases.AddItem('GenericContinue');
                    UIManager.ShowUIMessage('ConfirmNetworkLost', Title, Message, ButtonAliases, None, Outer.GamePlayers[0],,,,, false);
                }
            }
        }
    }
    // End:0x56E
    if(GPC == none)
    {
        ReturnToMainMenuNoPC();        
    }
    else
    {
        // End:0x59B
        if(bNoSignChange)
        {
            GPC.ReturnToMainMenu(false);
        }
    }
    //return;    
}

function ReturnToMainMenuNoPC()
{
    local PKLocalPlayer LP;

    LP = PKLocalPlayer(Outer.GamePlayers[0]);
    // End:0x87
    if(!bIsReturningToMainMenu)
    {
        bIsReturningToMainMenu = true;
        LP.DeleteSession('Game', OnDestroyGameComplete);
    }
    //return;    
}

function OnDestroyGameComplete(name SessionName, bool bWasSuccessful)
{
    local PKLocalPlayer LP;
    local OnlineSubsystem OnlineSub;

    LP = PKLocalPlayer(Outer.GamePlayers[0]);
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x13A
    if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none))) && SessionName == 'Game')
    {
        OnlineSub.GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyGameComplete);
        LP.DeleteSession('Party', OnDestroyPartyComplete);
    }
    //return;    
}

function OnDestroyPartyComplete(name SessionName, bool bWasSuccessful)
{
    local OnlineSubsystem OnlineSub;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x126
    if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none))) && SessionName == 'Party')
    {
        OnlineSub.GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyPartyComplete);
        Outer.GamePlayers[0].Actor.ClientTravel("?Closed", 0);
    }
    //return;    
}

function OnPrimaryPlayerSwitch(LocalPlayer OldPrimaryPlayer, LocalPlayer NewPrimaryPlayer)
{
    local PainGFxMenuHudWrapper OldMenuHUD, NewMenuHUD;
    local PKPartyPC OldPartyPC, NewPartyPC;

    OldPartyPC = PKPartyPC(OldPrimaryPlayer.Actor);
    NewPartyPC = PKPartyPC(NewPrimaryPlayer.Actor);
    // End:0x2A4
    if((OldPartyPC != none) && NewPartyPC != none)
    {
        OldPartyPC.bIsReturningToMainMenu = false;
        NewPartyPC.bIsReturningToMainMenu = false;
        OldPartyPC.bIsReturningFromMatch = false;
        NewPartyPC.bIsReturningFromMatch = false;
        OldMenuHUD = PainGFxMenuHudWrapper(OldPartyPC.myHUD);
        NewMenuHUD = PainGFxMenuHudWrapper(NewPartyPC.myHUD);
        // End:0x2A4
        if((OldMenuHUD != none) && NewMenuHUD != none)
        {
            PKLocalPlayer(NewPrimaryPlayer).bIsFirstFrontEndLoad = false;
            NewMenuHUD.FrontEnd = OldMenuHUD.FrontEnd;
            NewMenuHUD.FrontEnd.LocalPlayerOwnerIndex = 0;
            OldMenuHUD.FrontEnd = none;
            NewMenuHUD.bStartedMovie = OldMenuHUD.bStartedMovie;
            OldMenuHUD.bStartedMovie = false;
        }
    }
    //return;    
}

event GameSessionEnded()
{
    super(GameViewportClient).GameSessionEnded();
    //return;    
}

function DrawTransition(Canvas Canvas)
{
    switch(Outer.TransitionType)
    {
        // End:0x30
        case 2:
            // End:0xA7
            break;
        // End:0x54
        case 3:
            DrawTransitionMessage(Canvas, SavingMessage);
            // End:0xA7
            break;
        // End:0x78
        case 4:
            DrawTransitionMessage(Canvas, ConnectingMessage);
            // End:0xA7
            break;
        // End:0x9C
        case 5:
            DrawTransitionMessage(Canvas, PrecachingMessage);
            // End:0xA7
            break;
        // End:0xA4
        case 1:
            // End:0xA7
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

event GetSubtitleRegion(out Vector2D MinPos, out Vector2D MaxPos)
{
    MaxPos.X = 1.0000000;
    MaxPos.Y = 0.9000000;
    //return;    
}

defaultproperties
{
    XLoadingTextTitlePos=0.5000000
    YLoadingTextTitlePos=1.0000000
    LoadingTextTitleScale=1.0000000
    IntroLoadingTextTitleScale=1.0000000
    XLoadingTextDescPos=0.1800000
    YLoadingTextDescPos=0.2350000
    LoadingTextDescScale=1.0000000
    LoadingTextDescWrapWidth=0.7200000
    XLoadingTextHintPos=0.1800000
    LoadingTextHintScale=1.0000000
    LoadingTextHintWrapWidth=0.7200000
    HintCount=17
    UIControllerClass=Class'PKUIInteraction'
    Default2PSplitType=ESplitScreenType.eSST_2P_VERTICAL
}