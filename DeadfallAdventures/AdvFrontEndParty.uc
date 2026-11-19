class AdvFrontEndParty extends AdvFrontEnd
    config(Game);

var AdvGFxUI_Menu_ClientPreGame ClientLobby;
var AdvGFxUI_Menu_Base PregameLobby;

function Init(LocalPlayer LocPlay)
{
    local AdvLocalPlayer PKLocPlayer;
    local ADVPartyPC PartyPC;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    LocalPlayerOwnerIndex = Class'Engine.Engine'.static.GetEngine().GamePlayers.Find(LocPlay);    
    // End:0x92
    if(LocalPlayerOwnerIndex == -1)
    {
        LocalPlayerOwnerIndex = 0;
    }
    PKLocPlayer = AdvLocalPlayer(LocPlay);
    PartyPC = ADVPartyPC(GetPC());
    TrackChat(true);
    InitializeMenuBg();
    // End:0x106
    if(AdvPreGamePC(GetPC()) != none)
    {
        OpenPregameLobbyScreen();        
    }
    else
    {
        OpenClientLobbyScreen();
    }
    // End:0x2B1
    if(OnlineSub != none)
    {
        // End:0x19A
        if(NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none)))
        {
            OnlineSub.SystemInterface.AddControllerChangeDelegate(OnControllerChange);
        }
        // End:0x215
        if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
        {
            OnlineSub.PlayerInterface.AddLoginChangeDelegate(OnLoginChange);
        }
        // End:0x2B1
        if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
        {
            OnlineSub.PlayerInterfaceEx.AddDeviceSelectionDoneDelegate(byte(GetLP().ControllerId), OnDeviceSelectionComplete);
        }
    }
    PKLocPlayer.bIsFirstFrontEndLoad = false;
    PartyPC.bIsReturningToMainMenu = false;
    PartyPC.bIsReturningFromMatch = false;
    ADVGameViewportClient(PKLocPlayer.ViewportClient).bIsReturningToMainMenu = false;
    //return;    
}

function Close()
{
    // End:0x3A
    if(ClientLobby != none)
    {
        ClientLobby.super(GFxMoviePlayer).Close();
        ClientLobby = none;
    }
    // End:0x74
    if(PregameLobby != none)
    {
        PregameLobby.super(GFxMoviePlayer).Close();
        PregameLobby = none;
    }
    super.Close();
    //return;    
}

function Tick(float DeltaTime)
{
    // End:0x37
    if(CurrentScene != none)
    {
        CurrentScene.Tick(DeltaTime);
    }
    // End:0x6E
    if(footer != none)
    {
        footer.Tick(DeltaTime);
    }
    // End:0xA5
    if(Party != none)
    {
        Party.Tick(DeltaTime);
    }
    // End:0xDC
    if(PartyMenu != none)
    {
        PartyMenu.Tick(DeltaTime);
    }
    //return;    
}

function bool OpenClientLobbyScreen()
{
    // End:0xB0
    if(ClientLobby == none)
    {
        bOnMPScreens = true;
        bPreGameLobby = true;
        ClientLobby = new (self) Class'AdvGFxUI_Menu_ClientPreGame';
        ClientLobby.Frontend = self;
        ClientLobby.Init(GetLP());
        UpdateCursorPosForNewScene(ClientLobby);
        SetCurrentActiveScene(ClientLobby);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CloseClientLobbyScreen(optional bool bStayInPreGameLobby = false)
{
    ClientLobby.Close();
    ClientLobby = none;
    // End:0x4B
    if(!bStayInPreGameLobby)
    {
        bPreGameLobby = false;
    }
    //return;    
}

function bool OpenPregameLobbyScreen()
{
    // End:0x135
    if(PregameLobby == none)
    {
        bOnMPScreens = true;
        bPreGameLobby = false;
        // End:0xAC
        if((GetGRI().PlaylistId <= -1) && int(GetPC().WorldInfo.NetMode) != int(NM_Client))
        {
            PregameLobby = new (self) Class'AdvGFxUI_Menu_PregameLobbyPrivateHost';            
        }
        else
        {
            PregameLobby = new (self) Class'AdvGFxUI_Menu_PregameLobby';
        }
        PregameLobby.Frontend = self;
        PregameLobby.Init(GetLP());
        UpdateCursorPosForNewScene(PregameLobby);
        SetCurrentActiveScene(PregameLobby);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function ClosePregameLobbyScreen()
{
    // End:0x3A
    if(PregameLobby != none)
    {
        PregameLobby.Close();
        PregameLobby = none;
    }
    bPreGameLobby = false;
    //return;    
}

function SetOnInitialPlayerDataReadCompleteDelegate(delegate<OnInitialPlayerDataReadComplete> InReadDelegate)
{
    InitialPlayerDataReadCompleteDelegate = InReadDelegate;
    //return;    
}

function OnControllerChange(int ControllerId, bool bIsConnected)
{
    UpdatePlayersAndControllers(true);
    //return;    
}

function OnLoginChange(byte LocalUserNum)
{
    // End:0xC7
    if(PressedStartControllerId != -1)
    {
        // End:0xC7
        if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
        {
            // End:0xC7
            if(int(LocalUserNum) == PressedStartControllerId)
            {
                // End:0xC7
                if(int(OnlineSub.PlayerInterface.GetLoginStatus(LocalUserNum)) == int(0))
                {
                    bRestartFrontEndAfterStartSequence = true;
                }
            }
        }
    }
    UpdatePlayersAndControllers(!bOnTitleScreen);
    //return;    
}
