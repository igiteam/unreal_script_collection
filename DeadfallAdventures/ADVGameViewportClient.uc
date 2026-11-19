class ADVGameViewportClient extends UTGameViewportClient within Engine
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
    ViewportConsole = new (self) Class'AdvConsole';
    // End:0x87
    if((InsertInteraction(ViewportConsole)) == -1)
    {
        OutError = "Failed to add interaction to GlobalInteractions array:" @ string(ViewportConsole);
        return false;
    }
    return super(GameViewportClient).Init(OutError);
    //return ReturnValue;    
}

event bool UnregisteredControllerButtonPress(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    local ADVPartyPC PC;
    local AdvGFxMenuHudWrapper HUD;

    // End:0x102
    foreach Class'Engine.WorldInfo'.static.GetWorldInfo().LocalPlayerControllers(Class'ADVPartyPC', PC)
    {
        HUD = AdvGFxMenuHudWrapper(PC.myHUD);
        // End:0x101
        if((HUD != none) && HUD.Frontend != none)
        {            
            return HUD.Frontend.UnregisteredInput(ControllerId, ButtonName, InputEvent);
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
    LoadingTextTitle = Localize("Generic", "Loading", "ADVGame");
    // End:0xEA
    if(EvilEngine(Outer).FramesUntilIntroMayBeSkipped > 0)
    {
        Outer.AddOverlay(Outer.GetSubtitleFont(), LoadingTextTitle, XIntroLoadingTextTitlePos, YIntroLoadingTextTitlePos, IntroLoadingTextTitleScale, IntroLoadingTextTitleScale, false);        
    }
    else
    {
        // End:0x2A5
        if(AdvEngine(Class'Engine.Engine'.static.GetEngine()).bPastFirstLoad)
        {
            Outer.AddOverlay(Outer.GetSubtitleFont(), LoadingTextTitle, XLoadingTextTitlePos, YLoadingTextTitlePos, LoadingTextTitleScale, LoadingTextTitleScale, true);
            Offset = Rand(HintCount);
            I = 0;
            J0x1B7:

            // End:0x2A5 [Loop If]
            if(I < HintCount)
            {
                LoadingTextHint = Localize("LoadingHints", "Hint" $ string(1 + ((I + Offset) % HintCount)), "Hints");
                Outer.AddOverlayWrapped(Outer.GetSubtitleFont(), LoadingTextHint, XLoadingTextHintPos, YLoadingTextHintPos, LoadingTextHintScale, LoadingTextHintScale, LoadingTextHintWrapWidth);
                ++I;
                // [Loop Continue]
                goto J0x1B7;
            }
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
    // End:0xA9
    if((Outer.GetCurrentWorldInfo().Game != none) && int(Outer.GetCurrentWorldInfo().NetMode) == int(NM_Standalone))
    {
        bSplitScreenCanBeUsed = true;
    }
    // End:0xD6
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
    local AdvEngine Eng;

    // End:0x77
    if(SelectedInputAlias == 'GenericOpenSteamStore')
    {
        Eng = AdvEngine(Class'Engine.Engine'.static.GetEngine());
        // End:0x77
        if(Eng != none)
        {
            Eng.SteamActivateGameOverlayToBuyFullGame();
        }
    }
    return true;
    //return ReturnValue;    
}

simulated function ShowFreeWeekendSubscriptionWindow()
{
    local array<name> ButtonAliases;
    local AdvUIManager UIManager;

    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x15B
    if(UIManager != none)
    {
        ButtonAliases.AddItem('GenericOpenSteamStore');        
        ButtonAliases.AddItem('GenericCancel');        
        UIManager.ShowUIMessage('JanuarySubscription', Localize("MessageBoxErrorStrings", "FullGameNeeded_Title", "ADVGame"), Localize("MessageBoxErrorStrings", "FullGameNeeded_Message", "ADVGame"), ButtonAliases, OnJanuarySubscriptionFound, Outer.GamePlayers[0],,,,, false);
    }
    //return;    
}

event SetProgressMessage(PlayerController.EProgressMessageType MessageType, string Message, optional string Title, optional bool bIgnoreFutureNetworkMessages)
{
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;
    local AdvPlayerController GPC;

    GPC = AdvPlayerController(Outer.GamePlayers[0].Actor);
    // End:0xF4
    if(int(MessageType) == int(1))
    {
        // End:0xF4
        if(Title == "FreeWeekend")
        {
            // End:0xAC
            if(GPC != none)
            {
                GPC.ShowLoadingMovie(false);
            }
            ShowFreeWeekendSubscriptionWindow();
            // End:0xD2
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
    }
    super.SetProgressMessage(MessageType, Message, Title, bIgnoreFutureNetworkMessages);
    // End:0x234
    if(int(MessageType) == int(2))
    {
        UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
        // End:0x234
        if(UIManager != none)
        {
            UIManager.ClearUIMessage('HostPaused');
            ButtonAliases.AddItem('GenericContinue');            
            UIManager.ShowUIMessage('AdminMessage', Title, Message, ButtonAliases, None, Outer.GamePlayers[0],,,,, false);
        }
    }
    //return;    
}

function NotifyConnectionError(PlayerController.EProgressMessageType MessageType, optional string Message = Localize("Errors", "ConnectionFailed", "Engine"), optional string Title = Localize("Errors", "ConnectionFailed_Title", "Engine"))
{
    local WorldInfo WI;
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;
    local PlayerController PC;
    local AdvPlayerController GPC;
    local AdvLocalPlayer LP;
    local OnlineSubsystem OnlineSub;
    local OnlineGameSettings GameSettings;
    local OnlineSubsystem.ELoginStatus LoginStatus;
    local bool bNoSignChange;
    local string CustomMsgName, NewMessage, NewTitle;
    local AdvEngine PKEng;
    local bool bLoadingFromInvite;
    local int I;
    local URL PendingURL;

    WI = Class'Engine.Engine'.static.GetCurrentWorldInfo();
    LP = AdvLocalPlayer(Outer.GamePlayers[0]);
    PC = Outer.GamePlayers[0].Actor;
    GPC = AdvPlayerController(PC);
    PKEng = AdvEngine(Class'Engine.Engine'.static.GetEngine());
    // End:0x1A6
    if(GPC != none)
    {
        // End:0x182
        if(GPC.ShouldIgnoreNetworkErrors())
        {
            return;
        }
        GPC.ShowLoadingMovie(false);
    }
    PC.bIgnoreNetworkMessages = true;
    WI.Pauser = none;
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x2B5
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
    {
        LoginStatus = OnlineSub.PlayerInterface.GetLoginStatus(byte(LP.ControllerId));
    }
    GameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
    bNoSignChange = int(LoginStatus) == int(2);
    // End:0x358
    if((GameSettings != none) && GameSettings.bIsLanMatch)
    {
        bNoSignChange = true;
    }
    // End:0xAE3
    if(bNoSignChange || GPC == none)
    {
        // End:0xAE3
        if(((int(MessageType) == int(4)) || int(MessageType) == int(7)) || int(MessageType) == int(6))
        {
            UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
            // End:0xA42
            if(Outer.GetCurrentWorldInfo().IsConsoleBuild())
            {
                // End:0x559
                if(PKEng != none)
                {
                    // End:0x47F
                    if(PKEng.bLoadFromInvite)
                    {
                        bLoadingFromInvite = true;
                        PKEng.bLoadFromInvite = false;
                    }
                    // End:0x559
                    if(PKEng.GPendingLevel != none)
                    {
                        PendingURL = PKEng.GetPendinglevelURL();
                        I = 0;
                        J0x4D7:

                        // End:0x559 [Loop If]
                        if(I < PendingURL.Op.Length)
                        {
                            // End:0x54B
                            if(PendingURL.Op[I] ~= "bIsFromInvite")
                            {
                                bLoadingFromInvite = true;
                                // [Explicit Break]
                                goto J0x559;
                            }
                            ++I;
                            // [Loop Continue]
                            goto J0x4D7;
                        }
                    }
                }
                J0x559:

                CustomMsgName = Class'Engine.GameInfo'.static.ParseOption(Message, "NetMessage");
                switch(CustomMsgName)
                {
                    // End:0x646
                    case "TooManyPlayers":
                        NewTitle = Localize("Errors", "ConnectionFailed_Title", "ADVGame");
                        NewMessage = Localize("AdvGFxUI_Menu_PregameLobby", "GameFullString", "ADVGame");
                        // End:0x99E
                        break;
                    // End:0x6CE
                    case "NoDownloadableContent":
                        NewTitle = Localize("AdvGFxUI_Menu_MainMenu", "DLC", "ADVGame");
                        NewMessage = Localize("Errors", "NoDownload", "ADVGame");
                        // End:0x99E
                        break;
                    // End:0xFFFF
                    default:
                        // End:0x77D
                        if(bLoadingFromInvite)
                        {
                            NewTitle = Localize("MessageBoxErrorStrings", "InviteJoinFailed_Title", "ADVGame");
                            NewMessage = Localize("MessageBoxErrorStrings", "InviteJoinFailed_Message", "ADVGame");                            
                        }
                        else
                        {
                            NewTitle = Localize("Errors", "ConnectionFailed_Title", "ADVGame");
                            NewMessage = Localize("Errors", "ConnectionFailed", "ADVGame");
                        }
                        // End:0x899
                        if(!Class'Engine.UIInteraction'.static.HasLinkConnection())
                        {
                            NewTitle = Localize("Errors", "ConnectionFailed_Title", "ADVGame");
                            NewMessage = Localize("MessageBoxErrorStrings", "LostLink_Message", "ADVGame");
                        }
                        // End:0x99B
                        if(Class'Engine.UIInteraction'.static.HasLinkConnection() && int(Class'Engine.UIInteraction'.static.GetLoginStatus(LP.ControllerId)) != int(2))
                        {
                            NewTitle = Localize("MessageBoxErrorStrings", "XboxLive_Title", "ADVGame");
                            NewMessage = Localize("MessageBoxErrorStrings", "LostLiveConnection_Message", "ADVGame");
                        }
                        // End:0x99E
                        break;
                        break;
                }
                // End:0xA3F
                if(UIManager != none)
                {
                    ButtonAliases.AddItem('GenericContinue');                    
                    UIManager.ShowUIMessage('ConfirmNetworkLost', NewTitle, NewMessage, ButtonAliases, None, Outer.GamePlayers[0],,,,, false);
                }                
            }
            else
            {
                // End:0xAE3
                if(UIManager != none)
                {
                    ButtonAliases.AddItem('GenericContinue');                    
                    UIManager.ShowUIMessage('ConfirmNetworkLost', Title, Message, ButtonAliases, None, Outer.GamePlayers[0],,,,, false);
                }
            }
        }
    }
    ProcessReturnToMainMenu(GPC, bNoSignChange);
    //return;    
}

function ProcessReturnToMainMenu(AdvPlayerController PC, bool bNoSignChange)
{
    // End:0x1C
    if(PC == none)
    {
        ReturnToMainMenuNoPC();        
    }
    else
    {
        // End:0x49
        if(bNoSignChange)
        {
            PC.ReturnToMainMenu(false);
        }
    }
    //return;    
}

function bool DelegateReturnToMainMenu(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    local PlayerController PC;
    local AdvPlayerController PKPC;

    PC = Outer.GamePlayers[0].Actor;
    // End:0x6A
    if(PC != none)
    {
        PKPC = AdvPlayerController(PC);
    }
    ProcessReturnToMainMenu(PKPC, false);
    return true;
    //return ReturnValue;    
}

function bool DelegateReturnToMainMenuNoSignInChange(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    local PlayerController PC;
    local AdvPlayerController PKPC;

    PC = Outer.GamePlayers[0].Actor;
    // End:0x6A
    if(PC != none)
    {
        PKPC = AdvPlayerController(PC);
    }
    PKPC = AdvPlayerController(PC);
    ProcessReturnToMainMenu(PKPC, true);
    return true;
    //return ReturnValue;    
}

function ReturnToMainMenuNoPC()
{
    local AdvLocalPlayer LP;

    LP = AdvLocalPlayer(Outer.GamePlayers[0]);
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
    local AdvLocalPlayer LP;
    local OnlineSubsystem OnlineSub;

    LP = AdvLocalPlayer(Outer.GamePlayers[0]);
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
    local AdvGFxMenuHudWrapper OldMenuHUD, NewMenuHUD;
    local ADVPartyPC OldPartyPC, NewPartyPC;

    OldPartyPC = ADVPartyPC(OldPrimaryPlayer.Actor);
    NewPartyPC = ADVPartyPC(NewPrimaryPlayer.Actor);
    // End:0x2A4
    if((OldPartyPC != none) && NewPartyPC != none)
    {
        OldPartyPC.bIsReturningToMainMenu = false;
        NewPartyPC.bIsReturningToMainMenu = false;
        OldPartyPC.bIsReturningFromMatch = false;
        NewPartyPC.bIsReturningFromMatch = false;
        OldMenuHUD = AdvGFxMenuHudWrapper(OldPartyPC.myHUD);
        NewMenuHUD = AdvGFxMenuHudWrapper(NewPartyPC.myHUD);
        // End:0x2A4
        if((OldMenuHUD != none) && NewMenuHUD != none)
        {
            AdvLocalPlayer(NewPrimaryPlayer).bIsFirstFrontEndLoad = false;
            NewMenuHUD.Frontend = OldMenuHUD.Frontend;
            NewMenuHUD.Frontend.LocalPlayerOwnerIndex = 0;
            OldMenuHUD.Frontend = none;
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

exec function DebugNPC(name actorName)
{
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
    UIControllerClass=Class'AdvUIInteraction'
    Default2PSplitType=ESplitScreenType.eSST_2P_VERTICAL
}