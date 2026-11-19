class ADVMenuPC extends AdvPlayerController
    config(Game)
    hidecategories(Navigation);

var bool bSignedIn;
var transient bool bWantsDeferredInvite;
var transient int AchievementReadCount;
var transient OnlineGameSearchResult CachedInviteResult;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    //return;    
}

function NotifyDisbandedPartyClients(UniqueNetId PartyOwnerId)
{
    local ADVMenuPC MenuPC;

    // End:0xFA
    foreach WorldInfo.AllControllers(Class'ADVMenuPC', MenuPC)
    {
        // End:0xF9
        if((!MenuPC.IsLocalPlayerController() && AdvPRI(MenuPC.PlayerReplicationInfo) != none) && AdvPRI(MenuPC.PlayerReplicationInfo).PartyOwnerUniqueId == PartyOwnerId)
        {
            MenuPC.ClientPartyLobbyClosed();
        }        
    }    
    //return;    
}

reliable client simulated function ClientPartyLobbyClosed()
{
    //return;    
}

reliable client simulated function ClientSetOnlineStatus()
{
    super(PlayerController).ClientSetOnlineStatus();
    //return;    
}

function bool WantsSpectatorUI()
{
    return false;
    //return ReturnValue;    
}

function RestartFrontEnd()
{
    local AdvGFxMenuHudWrapper GMH;
    local OnlineGameSettings PartySettings;
    local AdvLocalPlayer LP;
    local AdvUIManager UIManager;

    GMH = AdvGFxMenuHudWrapper(myHUD);
    LP = AdvLocalPlayer(Player);
    // End:0x273
    if(IsPrimaryPlayer())
    {
        UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
        // End:0xC1
        if(UIManager != none)
        {
            UIManager.ClearUIMessage('SavesCorrupted', LocalPlayer(Player));
        }
        // End:0x100
        if(bIsReturningToMainMenu)
        {
            // End:0x100
            if(LP != none)
            {
                LP.bIsFirstFrontEndLoad = true;
                return;
            }
        }
        // End:0x273
        if(GMH != none)
        {
            // End:0x234
            if(((GMH.Frontend != none) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
            {
                PartySettings = OnlineSub.GameInterface.GetGameSettings('Party');
                // End:0x234
                if(PartySettings != none)
                {
                    // End:0x234
                    if(WorldInfo.Game != none)
                    {
                        AdvPartyGame_Base(WorldInfo.Game).DestroyParty();
                    }
                }
            }
            Class'AdvEngine'.static.ClearInputBlockingScenes();
            GMH.RestartFrontEnd();
        }
    }
    //return;    
}

function OnLoginChange(byte LocalUserNum)
{
    local AdvGFxMenuHudWrapper GMH;
    local AdvLocalPlayer LP;
    local AdvFrontEnd Frontend;
    local UniqueNetId NetId;

    Frontend = Class'AdvFrontEnd'.static.GetFrontEnd();
    // End:0x104
    if(Frontend.bPreGameLobby)
    {
        NetId = PlayerReplicationInfo.UniqueId;
        super.OnLoginChange(LocalUserNum);
        // End:0xF6
        if(NetId != PlayerReplicationInfo.UniqueId && !WorldInfo.IsMenuLevel())
        {
            ProfileSettings = none;
            PersistentData = none;
        }
        ReturnToMainMenu(true);        
    }
    else
    {
        // End:0x271
        if(int(WorldInfo.NetMode) != int(NM_Client))
        {
            super.OnLoginChange(LocalUserNum);
            // End:0x26E
            if(IsPrimaryPlayer())
            {
                GMH = AdvGFxMenuHudWrapper(myHUD);
                // End:0x26E
                if((GMH != none) && GMH.Frontend != none)
                {
                    // End:0x211
                    if(!IsOnTitleScreen())
                    {
                        LP = AdvLocalPlayer(Player);
                        // End:0x1F9
                        if(LP != none)
                        {
                            LP.bIsFirstFrontEndLoad = true;
                        }
                        ShowLoginChangeError();
                        ReturnToMainMenu(true);                        
                    }
                    else
                    {
                        // End:0x26E
                        if(int(OnlineSub.PlayerInterface.GetLoginStatus(LocalUserNum)) == int(0))
                        {
                            ShowLoginChangeError();
                            RestartFrontEnd();
                        }
                    }
                }
            }            
        }
        else
        {
            ShowLoginChangeError();
            ReturnToMainMenu(true);
            super.OnLoginChange(LocalUserNum);
        }
    }
    //return;    
}

function OnNewLogin()
{
    // End:0x33
    if(int(WorldInfo.NetMode) == int(NM_Client))
    {
        super.OnNewLogin();
    }
    //return;    
}

function OnLoginStatusChange(OnlineSubsystem.ELoginStatus NewStatus, UniqueNetId NewId)
{
    super.OnLoginStatusChange(NewStatus, NewId);
    bSignedIn = int(NewStatus) != int(0);
    // End:0x79
    if(int(WorldInfo.NetMode) == int(NM_Client))
    {
        ShowLoginChangeError();
        ReturnToMainMenu(true);        
    }
    else
    {
        // End:0xB5
        if((int(NewStatus) == int(2)) && !IsOnTitleScreen())
        {
            // End:0xB5
            if(IsOnMPScreens())
            {
                RestartFrontEnd();
            }
        }
    }
    //return;    
}

reliable client simulated function ClientOpenPreGameLobby()
{
    local AdvGFxMenuHudWrapper MenuHUD;

    MenuHUD = AdvGFxMenuHudWrapper(myHUD);
    // End:0x6E
    if(MenuHUD != none)
    {
        // End:0x6E
        if(MenuHUD.Frontend == none)
        {
            MenuHUD.InitializePartyFrontEnd();
        }
    }
    //return;    
}

reliable client simulated function NewHostOpenPreGameLobby()
{
    local AdvGFxMenuHudWrapper MenuHUD;

    MenuHUD = AdvGFxMenuHudWrapper(myHUD);
    // End:0x6E
    if(MenuHUD != none)
    {
        // End:0x6E
        if(MenuHUD.Frontend == none)
        {
            MenuHUD.InitializeMigratedHostFrontEnd();
        }
    }
    //return;    
}

simulated function NotifyHostMigrationStarted()
{
    ClientShowHostMigrationMovie();
    //return;    
}

simulated event Destroyed()
{
    local UniqueNetId UserId;

    // End:0xC9
    if(bWantsDeferredInvite && OnlineSub.PlayerInterface.GetUniquePlayerId(byte(AdvLocalPlayer(Player).ControllerId), UserId))
    {
        AdvEngine(Class'AdvEngine'.static.GetEngine()).SetInviteCache(UserId, CachedInviteResult);
    }
    super.Destroyed();
    //return;    
}

exec function UpdateLocalCacheOfProfileSettings()
{
    // End:0x42
    if((int(WorldInfo.NetMode) == int(NM_Client)) && IsPrimaryPlayer())
    {
        UpdateHostMigrationScore();
    }
    //return;    
}

reliable client simulated function ClientSaveAllPlayerData(optional bool bShouldForce, optional bool bSkipCacheUpdate)
{
    local EvilLocalPlayer LP;

    LP = EvilLocalPlayer(Player);
    // End:0xCE
    if(((LP != none) && (WorldInfo.RealTimeSeconds - LP.LastSaveTime) >= TimeBetweenSaves) || bShouldForce)
    {
        Class'AdvUIManager'.static.OpenUpdatingScene("SavingContent_ShortMessage",,, 1.0000000);
    }
    super(EvilPlayerController).ClientSaveAllPlayerData(bShouldForce, bSkipCacheUpdate);
    //return;    
}

function OnProfileWriteComplete(byte LocalUserNum, bool bWasSuccessful)
{
    Class'AdvUIManager'.static.CloseUpdatingScene();
    //return;    
}

function OnGameInviteAccepted(const out OnlineGameSearchResult InviteResult)
{
    local AdvLocalPlayer LP;
    local ADVMenuPC PC;
    local AdvGFxMenuHudWrapper HUD;
    local AdvFrontEnd Frontend;
    local AdvUIManager UIManager;

    // End:0x8B
    foreach LocalPlayerControllers(Class'ADVMenuPC', PC)
    {
        HUD = AdvGFxMenuHudWrapper(PC.myHUD);
        // End:0x8A
        if(HUD != none)
        {
            Frontend = HUD.Frontend;
            // End:0x8B
            break;
        }        
    }    
    LP = AdvLocalPlayer(Player);
    // End:0xE0
    if(Frontend.bPreGameLobby)
    {
        super.OnGameInviteAccepted(InviteResult);        
    }
    else
    {
        // End:0x172
        if(((LP != none) && Frontend != none) && !LP.bHasSeenStartScreen || Frontend.PressedStartControllerId != -1)
        {
            bWantsDeferredInvite = true;
            CachedInviteResult = InviteResult;            
        }
        else
        {
            UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
            // End:0x214
            if((UIManager != none) && !UIManager.IsUIMessageActive('InviteJoinFailed_Title', LP))
            {
                UIManager.CloseAllUIMessageBoxes(LP);
            }
            // End:0x29E
            if((HUD != none) && HUD.CreditsMovie != none)
            {
                HUD.CreditsMovie.Close();
                HUD.CreditsMovie = none;
            }
            super.OnGameInviteAccepted(InviteResult);
        }
    }
    //return;    
}

function AcceptDeferredInvite()
{
    local ADVMenuPC PC;
    local OnlineGameSearchResult ZeroResult;

    // End:0x51
    if(IsPrimaryPlayer() && bWantsDeferredInvite)
    {
        OnGameInviteAccepted(CachedInviteResult);
        bWantsDeferredInvite = false;
        CachedInviteResult = ZeroResult;        
    }
    else
    {
        // End:0x140
        foreach LocalPlayerControllers(Class'ADVMenuPC', PC)
        {
            // End:0x13F
            if(PC.IsPrimaryPlayer() && PC.bWantsDeferredInvite)
            {
                PC.OnGameInviteAccepted(PC.CachedInviteResult);
                PC.bWantsDeferredInvite = false;
                PC.CachedInviteResult = ZeroResult;
                // End:0x140
                break;
            }            
        }        
    }
    //return;    
}

function PGSReadOnlineStatsCompleteCallback(bool bWasSuccessful)
{
    OnlineSub.StatsInterface.ClearReadOnlineStatsCompleteDelegate(PGSReadOnlineStatsCompleteCallback);
    //return;    
}

function DelayedReturnToMainMenu()
{
    ReturnToMainMenu(true);
    //return;    
}

simulated function ReturnToMainMenu(bool bReturnToStartScreen)
{
    local AdvEngine Engine;

    Engine = AdvEngine(Class'Engine.Engine'.static.GetEngine());
    // End:0x6D
    if(Engine.InputBlockDataList.Length > 0)
    {
        SetTimer(0.1000000, false, 'DelayedReturnToMainMenu');        
    }
    else
    {
        super.ReturnToMainMenu(bReturnToStartScreen);
    }
    //return;    
}

reliable client simulated function ClientValidateStorageDeviceAfterTravelToLobby()
{
    //return;    
}

defaultproperties
{
    // Reference: EvilSceneCaptureHighlightComponent'Default__ADVMenuPC.HighlightComponent'
    begin object name=HighlightComponent
    end object
    HighlightSceneCaptureComponent=HighlightComponent
    // Reference: ForceFeedbackWaveform'Default__ADVMenuPC.ForceFeedbackWaveform7'
    begin object name=ForceFeedbackWaveform7
    end object
    CameraShakeShortWaveForm=ForceFeedbackWaveform7
    // Reference: ForceFeedbackWaveform'Default__ADVMenuPC.ForceFeedbackWaveform8'
    begin object name=ForceFeedbackWaveform8
    end object
    CameraShakeLongWaveForm=ForceFeedbackWaveform8
    // Reference: CylinderComponent'Default__ADVMenuPC.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=HighlightComponent
    CollisionComponent=CollisionCylinder
}