class ADVPartyPC extends ADVMenuPC
    config(Game)
    hidecategories(Navigation);

function OnLoginStatusChange(OnlineSubsystem.ELoginStatus NewStatus, UniqueNetId NewId)
{
    local AdvFrontEnd Frontend;
    local AdvGRI GRI;

    Frontend = Class'AdvFrontEnd'.static.GetFrontEnd();
    // End:0xEA
    if((Frontend != none) && Frontend.bPreGameLobby)
    {
        super(AdvPlayerController).OnLoginStatusChange(NewStatus, NewId);
        // End:0xE7
        if((int(NewStatus) == int(0)) || OnlineSub.GameInterface.GetGameSettings('Party') != none)
        {
            ShowLoginChangeError();
            ReturnToMainMenu(true);
        }        
    }
    else
    {
        super.OnLoginStatusChange(NewStatus, NewId);
        // End:0x2E9
        if(int(NewStatus) < int(2))
        {
            // End:0x2DF
            if(Frontend != none)
            {
                GRI = Frontend.GetMenuGRI();
                // End:0x23C
                if((GRI != none) && int(GRI.GetCurrentPartyType()) < int(2))
                {
                    Frontend.LocalPartyCreated();
                    // End:0x23C
                    if(Frontend.Party != none)
                    {
                        Frontend.Party.bForceUpdateTitle = true;
                        Frontend.Party.bForceUpdatePlayerPanel = true;
                    }
                }
                // End:0x2DC
                if(Frontend.bOnMPScreens || (Frontend.LeaderboardMenu != none) && Frontend.CurrentScene == Frontend.LeaderboardMenu)
                {
                    ShowOSSConnectionLostMessage();
                    ReturnToMainMenu(true);
                }                
            }
            else
            {
                ShowOSSConnectionLostMessage();
            }
        }
    }
    //return;    
}

function RestartFrontEnd()
{
    super.RestartFrontEnd();
    //return;    
}

function bool ShouldShowStartupNotifiesBeforeInvite()
{
    return false;
    //return ReturnValue;    
}

reliable client simulated function ClientSetOnlineStatus()
{
    SetRichPresenceString(4);
    super.ClientSetOnlineStatus();
    //return;    
}

reliable server function ServerCancelMatchmaking()
{
    //return;    
}

function OnLinkStatusChanged(bool bIsConnected)
{
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;
    local AdvFrontEnd Frontend;
    local AdvEngine Engine;

    Frontend = Class'AdvFrontEnd'.static.GetFrontEnd();
    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x1C8
    if(Frontend.bPreGameLobby)
    {
        // End:0x1C5
        if(!bIsConnected && OnlineSub.GameInterface.GetGameSettings('Party') != none)
        {
            // End:0x1BA
            if(UIManager != none)
            {
                ButtonAliases.AddItem('GenericAccept');                
                UIManager.ShowUIMessage('ConnectionError', Localize("MessageBoxErrorStrings", "LostLink_Title", "ADVGame"), Localize("MessageBoxErrorStrings", "LostLink_Message", "ADVGame"), ButtonAliases, None,,,,, false, false);
            }
            ReturnToMainMenu(true);
        }        
    }
    else
    {
        // End:0x529
        if((!bIsConnected && int(WorldInfo.NetMode) != int(NM_Standalone)) && (OnlineSub.GameInterface.GetGameSettings('Party') != none) || OnlineSub.GameInterface.GetGameSettings('Game') != none)
        {
            // End:0x529
            if(UIManager != none)
            {
                Engine = AdvEngine(Class'AdvEngine'.static.GetEngine());
                ButtonAliases.AddItem('GenericAccept');                
                UIManager.ShowUIMessage('ConnectionError', Localize("MessageBoxErrorStrings", "LostLink_Title", "ADVGame"), Localize("MessageBoxErrorStrings", "LostLink_Message", "ADVGame"), ButtonAliases, None,,,,, false, false);
                // End:0x529
                if(((((((Frontend == none) || Engine.GPendingLevel != none) || WorldInfo.NextSwitchCountdown > float(0)) || Frontend.bOnMPScreens) || (Frontend.LeaderboardMenu != none) && Frontend.CurrentScene == Frontend.LeaderboardMenu) || OnlineSub.GameInterface.GetGameSettings('Party') != none) || OnlineSub.GameInterface.GetGameSettings('Game') != none)
                {
                    ReturnToMainMenu(true);
                }
            }
        }
    }
    //return;    
}

simulated function ReturnToMainMenu(bool bReturnToStartScreen)
{
    local OnlineGameSettings GameSettings;
    local bool bShouldTravel;
    local AdvLocalPlayer LP;
    local UniqueNetId RequestingPlayerId;
    local AdvFrontEnd Frontend;

    Frontend = Class'AdvFrontEnd'.static.GetFrontEnd();
    // End:0x64
    if(!Frontend.bPreGameLobby)
    {
        super.ReturnToMainMenu(bReturnToStartScreen);        
    }
    else
    {
        bShouldTravel = true;
        bIsReturningFromMatch = true;
        bIgnoreNetworkMessages = true;
        LP = AdvLocalPlayer(Player);
        // End:0xDD
        if(LP != none)
        {
            LP.bIsFirstFrontEndLoad = bReturnToStartScreen;
        }
        // End:0x468
        if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
        {
            GameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
            // End:0x39E
            if((GameSettings != none) && int(WorldInfo.NetMode) == int(NM_Client))
            {
                // End:0x2D1
                if(((LP != none) && int(OnlineSub.PlayerInterface.GetLoginStatus(byte(LP.ControllerId))) == int(2)) && GameSettings.bUsesArbitration)
                {
                    OnlineSub.GameInterface.DestroyOnlineGame('Game');
                    bShouldTravel = false;
                    // End:0x2BB
                    if(PlayerReplicationInfo != none)
                    {
                        RequestingPlayerId = PlayerReplicationInfo.UniqueId;
                    }
                    ClientReturnToParty(RequestingPlayerId);                    
                }
                else
                {
                    OnlineSub.GameInterface.DestroyOnlineGame('Game');
                    // End:0x39B
                    if(OnlineSub.GameInterface.GetGameSettings('Party') != none)
                    {
                        DestroyPersistentParty();
                        OnlineSub.GameInterface.DestroyOnlineGame('Party');
                    }
                }                
            }
            else
            {
                OnlineSub.GameInterface.DestroyOnlineGame('Game');
                // End:0x468
                if(OnlineSub.GameInterface.GetGameSettings('Party') != none)
                {
                    DestroyPersistentParty();
                    OnlineSub.GameInterface.DestroyOnlineGame('Party');
                }
            }
        }
        // End:0x496
        if(bShouldTravel)
        {
            ClientShowDefaultLoadingMovie();
            ClientTravel("?closed", 0);
        }
    }
    //return;    
}

reliable client simulated event ClientShowDefaultLoadingMovie()
{
    ClientShowReturnToMenuMovie();
    //return;    
}

function OnDeviceSelectionComplete(bool bUserSelectedDevice)
{
    //return;    
}

state RoundEnded
{
    ignores BeginState;
    stop;    
}

defaultproperties
{
    // Reference: EvilSceneCaptureHighlightComponent'Default__ADVPartyPC.HighlightComponent'
    begin object name=HighlightComponent
    end object
    HighlightSceneCaptureComponent=HighlightComponent
    // Reference: ForceFeedbackWaveform'Default__ADVPartyPC.ForceFeedbackWaveform7'
    begin object name=ForceFeedbackWaveform7
    end object
    CameraShakeShortWaveForm=ForceFeedbackWaveform7
    // Reference: ForceFeedbackWaveform'Default__ADVPartyPC.ForceFeedbackWaveform8'
    begin object name=ForceFeedbackWaveform8
    end object
    CameraShakeLongWaveForm=ForceFeedbackWaveform8
    // Reference: CylinderComponent'Default__ADVPartyPC.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=HighlightComponent
    CollisionComponent=CollisionCylinder
}