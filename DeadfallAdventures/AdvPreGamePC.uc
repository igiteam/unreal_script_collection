class AdvPreGamePC extends ADVPartyPC
    config(Game)
    hidecategories(Navigation);

simulated event PostBeginPlay()
{
    super(ADVMenuPC).PostBeginPlay();
    //return;    
}

function OnGameInviteAccepted(const out OnlineGameSearchResult InviteResult)
{
    super(AdvPlayerController).OnGameInviteAccepted(InviteResult);
    //return;    
}

function NotifyLobbySceneOpened()
{
    local AdvPreGameLobbyPRI PRI;
    local AdvPlayerController GPC;

    PRI = AdvPreGameLobbyPRI(PlayerReplicationInfo);
    // End:0xC3
    if(PRI != none)
    {
        // End:0xB0
        if(!PRI.bLobbySceneOpened)
        {
            // End:0xAC
            foreach LocalPlayerControllers(Class'AdvPlayerController', GPC)
            {
                AdvPreGameLobbyPRI(GPC.PlayerReplicationInfo).ServerNotifyLobbySceneOpened();                
            }                        
        }
        else
        {
            SetTimer(0.1000000, false, 'NotifyLobbySceneOpened');
        }
    }
    //return;    
}

simulated function DestroyPreGameLobbyBecauseStorageDeviceRemovalWithDLC()
{
    local AdvLocalPlayer LP;
    local OnlineGameSettings GameSettings;

    LP = AdvLocalPlayer(Player);
    GameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
    // End:0x241
    if((GameSettings != none) && int(WorldInfo.NetMode) == int(NM_Client))
    {
        // End:0x174
        if(((LP != none) && int(OnlineSub.PlayerInterface.GetLoginStatus(byte(LP.ControllerId))) == int(2)) && GameSettings.bUsesArbitration)
        {
            OnlineSub.GameInterface.DestroyOnlineGame('Game');            
        }
        else
        {
            OnlineSub.GameInterface.DestroyOnlineGame('Game');
            // End:0x23E
            if(OnlineSub.GameInterface.GetGameSettings('Party') != none)
            {
                DestroyPersistentParty();
                OnlineSub.GameInterface.DestroyOnlineGame('Party');
            }
        }        
    }
    else
    {
        AdvPreGameGRI(WorldInfo.GRI).StopCountdownTimer();
        OnlineSub.GameInterface.DestroyOnlineGame('Game');
        // End:0x348
        if(OnlineSub.GameInterface.GetGameSettings('Party') != none)
        {
            DestroyPersistentParty();
            OnlineSub.GameInterface.DestroyOnlineGame('Party');
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

    bShouldTravel = true;
    bIsReturningFromMatch = true;
    bIgnoreNetworkMessages = true;
    LP = AdvLocalPlayer(Player);
    // End:0x79
    if(LP != none)
    {
        LP.bIsFirstFrontEndLoad = bReturnToStartScreen;
    }
    // End:0x404
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        GameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
        // End:0x33A
        if((GameSettings != none) && int(WorldInfo.NetMode) == int(NM_Client))
        {
            // End:0x26D
            if(((LP != none) && int(OnlineSub.PlayerInterface.GetLoginStatus(byte(LP.ControllerId))) == int(2)) && GameSettings.bUsesArbitration)
            {
                OnlineSub.GameInterface.DestroyOnlineGame('Game');
                bShouldTravel = false;
                // End:0x257
                if(PlayerReplicationInfo != none)
                {
                    RequestingPlayerId = PlayerReplicationInfo.UniqueId;
                }
                ClientReturnToParty(RequestingPlayerId);                
            }
            else
            {
                OnlineSub.GameInterface.DestroyOnlineGame('Game');
                // End:0x337
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
            // End:0x404
            if(OnlineSub.GameInterface.GetGameSettings('Party') != none)
            {
                DestroyPersistentParty();
                OnlineSub.GameInterface.DestroyOnlineGame('Party');
            }
        }
    }
    CloseReturnToMainMenuCogSpin();
    // End:0x43C
    if(bShouldTravel)
    {
        ClientShowDefaultLoadingMovie();
        ClientTravel("?closed", 0);
    }
    //return;    
}

reliable client simulated event ClientWasKicked()
{
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;

    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x130
    if(UIManager != none)
    {
        ButtonAliases.AddItem('GenericAccept');        
        UIManager.ShowUIMessage('ConnectionError', Localize("MessageBoxErrorStrings", "LostLink_Title", "AdvGameUI"), Localize("MessageBoxStrings", "ArbitrationKicked_Desc", "AdvGameUI"), ButtonAliases, None, LocalPlayer(Player),,,, false, false);
    }
    ReturnToMainMenu(false);
    //return;    
}

event PerformGameHostMigration()
{
    local int PRIIndex, PeerIdx;
    local array<CurrentPlayerMet> Players;
    local CurrentPlayerMet CurrentPlayer;
    local AdvRecentPlayer GearCurrentPlayer;
    local AdvRecentPlayersList RecentPlayersList;
    local UniqueNetId ZeroId, u1;
    local AdvPRI PRI;

    // End:0x439
    if(OnlineSub != none)
    {
        RecentPlayersList = AdvRecentPlayersList(OnlineSub.GetNamedInterface('RecentPlayersList'));
        // End:0x439
        if(RecentPlayersList != none)
        {
            RecentPlayersList.ClearAllPKParties();
            RecentPlayersList.ClearRecentPlayers();
            PRIIndex = 0;
            J0xA2:

            // End:0x411 [Loop If]
            if(PRIIndex < WorldInfo.GRI.PRIArray.Length)
            {
                PRI = AdvPRI(WorldInfo.GRI.PRIArray[PRIIndex]);
                PeerIdx = FindConnectedPeerIndex(PRI.UniqueId);
                u1 = PRI.UniqueId;
                // End:0x403
                if(PRI.UniqueId == PlayerReplicationInfo.UniqueId || (PeerIdx != -1) && ConnectedPeers[PeerIdx].bLostConnectionToHost)
                {
                    CurrentPlayer.NetId = PRI.UniqueId;
                    CurrentPlayer.Skill = PRI.PlayerSkill;
                    CurrentPlayer.TeamNum = PRI.Team.TeamIndex;
                    Players.AddItem(CurrentPlayer);                    
                    GearCurrentPlayer = CurrentPlayer;
                    GearCurrentPlayer.Level = PRI.PlayerLevel;
                    // End:0x3BD
                    if(PRI.PartyOwnerUniqueId != ZeroId)
                    {
                        RecentPlayersList.AddLastPKPartyPlayer(PRI.PartyOwnerUniqueId, GearCurrentPlayer);                        
                    }
                    else
                    {
                        RecentPlayersList.AddLastPKPartyPlayer(PRI.UniqueId, GearCurrentPlayer);
                    }
                }
                PRIIndex++;
                // [Loop Continue]
                goto J0xA2;
            }
            RecentPlayersList.SetCurrentPlayersList(Players);
        }
    }
    //return;    
}

function OnLinkStatusChanged(bool bIsConnected)
{
    // End:0xAF
    if(((int(Role) == int(ROLE_Authority)) && AdvPreGameLobbyGame_Base(WorldInfo.Game) != none) && AdvPreGameGRI(WorldInfo.GRI) != none)
    {
        AdvPreGameGRI(WorldInfo.GRI).StopCountdownTimer();
    }
    super.OnLinkStatusChanged(bIsConnected);
    //return;    
}

function OnLoginChange(byte LocalUserNum)
{
    // End:0xAF
    if(((int(Role) == int(ROLE_Authority)) && AdvPreGameLobbyGame_Base(WorldInfo.Game) != none) && AdvPreGameGRI(WorldInfo.GRI) != none)
    {
        AdvPreGameGRI(WorldInfo.GRI).StopCountdownTimer();
    }
    super(ADVMenuPC).OnLoginChange(LocalUserNum);
    //return;    
}

function OnLoginStatusChange(OnlineSubsystem.ELoginStatus NewStatus, UniqueNetId NewId)
{
    // End:0xAF
    if(((int(Role) == int(ROLE_Authority)) && AdvPreGameLobbyGame_Base(WorldInfo.Game) != none) && AdvPreGameGRI(WorldInfo.GRI) != none)
    {
        AdvPreGameGRI(WorldInfo.GRI).StopCountdownTimer();
    }
    super.OnLoginStatusChange(NewStatus, NewId);
    //return;    
}

reliable client simulated function WriteStatusPK()
{
    //return;    
}

event PlayerTick(float DeltaTime)
{
    super(AdvPlayerController).PlayerTick(DeltaTime);
    //return;    
}

event Tick(float DeltaTime)
{
    super(Actor).Tick(DeltaTime);
    //return;    
}

reliable server function ServerStopLevelLoadingMovie()
{
    // End:0xAC
    if((AdvPreGameGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI) != none) && int(AdvPreGameGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI).PreGameLobbyState) != int(6))
    {
        ClientStopLevelLoadingMovie();
    }
    //return;    
}

defaultproperties
{
    // Reference: EvilSceneCaptureHighlightComponent'Default__AdvPreGamePC.HighlightComponent'
    begin object name=HighlightComponent
    end object
    HighlightSceneCaptureComponent=HighlightComponent
    // Reference: ForceFeedbackWaveform'Default__AdvPreGamePC.ForceFeedbackWaveform7'
    begin object name=ForceFeedbackWaveform7
    end object
    CameraShakeShortWaveForm=ForceFeedbackWaveform7
    // Reference: ForceFeedbackWaveform'Default__AdvPreGamePC.ForceFeedbackWaveform8'
    begin object name=ForceFeedbackWaveform8
    end object
    CameraShakeLongWaveForm=ForceFeedbackWaveform8
    // Reference: CylinderComponent'Default__AdvPreGamePC.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=HighlightComponent
    CollisionComponent=CollisionCylinder
}