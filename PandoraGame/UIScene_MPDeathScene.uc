class UIScene_MPDeathScene extends UIScene_NetworkScene;

enum ELookTargetType
{
    LT_TEAM,                        // 0
    LT_WEREWOLF,                    // 1
    LT_MAX                          // 2
};

var UILabel wRepawnTimerLabel;
var UILabel wCameraModeLabel;
var bool bAcceptingInput;
var bool bTalking;
var PandoraPlayerController PPC;
var UIScene_MPDeathScene.ELookTargetType LookTargetType;
var Actor LockViewTarget;
var GameUISceneClient GameSceneClient;
var float TalkingTimer;
var float LastCheckForHeadsetTime;

event InitScene()
{
    local LocalPlayer LP;

    wRepawnTimerLabel = UILabel(FindChild('RespawnTimerLabel', true));
    wCameraModeLabel = UILabel(FindChild('CameraModeLabel', true));
    LP = GetPlayerOwner();
    // End:0x7F
    if((LP != none) && LP.Actor != none)
    {
        PPC = PandoraPlayerController(LP.Actor);
    }
    __OnRawInputKey__Delegate = CustomInputKey;
    GameSceneClient = GameUISceneClient(SceneClient);
    super(UIScene_BaseFrontEnd).InitScene();
    SetLookTargetMode(0);
    SetVisibility(false);
    bDisplayCursor = false;
    TrackChat();
    //return;    
}

function EnableButtonDelay()
{
    bInputDisabled = false;
    CurrentButtonDelayTime = 0.0000000;
    //return;    
}

function SetLookTargetMode(UIScene_MPDeathScene.ELookTargetType LTT)
{
    LookTargetType = LTT;
    switch(LookTargetType)
    {
        // End:0x2E4
        case 0:
            // End:0x128
            if(GetWorldInfo().IsConsoleBuild(1) || GetPC().PlayerInput.bUsingGamepad)
            {
                wCameraModeLabel.SetDataStoreBinding(((("<Strings:PandoraGame.UIScene_MPDeathScene.strCameraMode360>" $ ":") @ "<Strings:PandoraGame.UIScene_MPDeathScene.strTeam>") $ "\n") $ "<Strings:PandoraGame.UIScene_MPDeathScene.strSwitchTarget360>");                
            }
            else
            {
                // End:0x214
                if(GetWorldInfo().IsConsoleBuild(2))
                {
                    wCameraModeLabel.SetDataStoreBinding(((("<Strings:PandoraGame.UIScene_MPDeathScene.strCameraModePS3>" $ ":") @ "<Strings:PandoraGame.UIScene_MPDeathScene.strTeam>") $ "\n") $ "<Strings:PandoraGame.UIScene_MPDeathScene.strSwitchTargetPS3>");                    
                }
                else
                {
                    wCameraModeLabel.SetDataStoreBinding(((("<Strings:PandoraGame.UIScene_MPDeathScene.strCameraModePC>" $ ":") @ "<Strings:PandoraGame.UIScene_MPDeathScene.strTeam>") $ "\n") $ "<Strings:PandoraGame.UIScene_MPDeathScene.strSwitchTargetPC>");
                }
            }
            // End:0x5D3
            break;
        // End:0x5D0
        case 1:
            // End:0x402
            if(GetWorldInfo().IsConsoleBuild(1) || GetPC().PlayerInput.bUsingGamepad)
            {
                wCameraModeLabel.SetDataStoreBinding(((("<Strings:PandoraGame.UIScene_MPDeathScene.strCameraMode360>" $ ":") @ "<Strings:PandoraGame.SPBaseWerewolfAIController.PlayerName>") $ "\n") $ "<Strings:PandoraGame.UIScene_MPDeathScene.strSwitchTarget360>");                
            }
            else
            {
                // End:0x4F7
                if(GetWorldInfo().IsConsoleBuild(2))
                {
                    wCameraModeLabel.SetDataStoreBinding(((("<Strings:PandoraGame.UIScene_MPDeathScene.strCameraModePS3>" $ ":") @ "<Strings:PandoraGame.SPBaseWerewolfAIController.PlayerName>") $ "\n") $ "<Strings:PandoraGame.UIScene_MPDeathScene.strSwitchTargetPS3>");                    
                }
                else
                {
                    wCameraModeLabel.SetDataStoreBinding(((("<Strings:PandoraGame.UIScene_MPDeathScene.strCameraModePC>" $ ":") @ "<Strings:PandoraGame.SPBaseWerewolfAIController.PlayerName>") $ "\n") $ "<Strings:PandoraGame.UIScene_MPDeathScene.strSwitchTargetPC>");
                }
            }
            // End:0x5D3
            break;
        // End:0xFFFF
        default:
            break;
    }
    //return;    
}

function bool CustomInputKey(const out InputEventParameters EventParms)
{
    UpDateUsingGamePadForPC(EventParms);
    // End:0x52
    if((IsInputNavShoulderL(EventParms)) || IsInputLeftMouseUp(EventParms))
    {
        PPC.ServerCyclePrevTarget(int(LookTargetType));
        return true;
    }
    // End:0x95
    if((IsInputNavShoulderR(EventParms)) || IsInputRightMouseUp(EventParms))
    {
        PPC.ServerCycleNextTarget(int(LookTargetType));
        return true;
    }
    // End:0xEF
    if(IsInputAltAccept(EventParms))
    {
        // End:0xC6
        if(int(LookTargetType) == int(0))
        {
            SetLookTargetMode(1);            
        }
        else
        {
            SetLookTargetMode(0);
        }
        PPC.ServerCycleNextTarget(int(LookTargetType));
        return true;
    }
    // End:0x103
    if(IsInputNavTriggerR(EventParms))
    {
        return true;
    }
    // End:0x117
    if(IsInputCancel(EventParms))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

event UpdateScene(float DeltaTime, WorldInfo WorldInfo)
{
    local PandoraGRI GRI;
    local SPPlayerReplicationInfo SPPRI;

    // End:0x17
    if(WorldInfo.GRI == none)
    {
        return;
    }
    GRI = PandoraGRI(WorldInfo.GRI);
    // End:0x2D9
    if((PPC != none) && int(GRI.GameStatus) == int(2))
    {
        GameSceneClient.bOverrideEmulateButtonPress = IsVisible() && !IsPauseSceneOpen();
        SPPRI = SPPlayerReplicationInfo(PPC.PlayerReplicationInfo);
        // End:0x2A4
        if(PPC.IsInState('Dead') || (((SPPRI != none) && SPPRI.DeadLocation.X != float(0)) && SPPRI.DeadLocation.Y != float(0)) && SPPRI.DeadLocation.Z != float(0))
        {
            PPC.bFrozen = true;
            // End:0x15E
            if(!bAcceptingInput)
            {
                bAcceptingInput = true;
                SetVisibility(true);
            }
            // End:0x1B9
            if((Pawn(PPC.ViewTarget) != none) && Pawn(PPC.ViewTarget).Health <= 0)
            {
                PPC.ServerCyclePrevTarget(int(LookTargetType));
            }
            // End:0x21B
            if(WorldInfo.TimeSeconds < PPC.WaitDelay)
            {
                wRepawnTimerLabel.SetValue(FormatTime(int(PPC.WaitDelay - WorldInfo.TimeSeconds)));                
            }
            else
            {
                // End:0x28D
                if(PPC.Pawn != none)
                {
                    SPPRI.DeadLocation = vect(0.0000000, 0.0000000, 0.0000000);
                    SPPRI.SetDeadLocation(vect(0.0000000, 0.0000000, 0.0000000));
                    PPC.Pawn.DetachFromController();
                }
                PPC.ServerRestartPlayer();
            }            
        }
        else
        {
            // End:0x2D9
            if(bAcceptingInput)
            {
                PPC.bFrozen = false;
                bAcceptingInput = false;
                SetVisibility(false);
                LockViewTarget = none;
            }
        }
    }
    LastCheckForHeadsetTime += DeltaTime;
    // End:0x309
    if(LastCheckForHeadsetTime >= 1.5000000)
    {
        UpdateHeadsetState();
        LastCheckForHeadsetTime = 0.0000000;
    }
    UpdateTalking(DeltaTime);
    super(UIScene_BaseFrontEnd).UpdateScene(DeltaTime, WorldInfo);
    //return;    
}

function UpdateTalking(float DeltaTime)
{
    local SPPlayerReplicationInfo SPPRI;

    SPPRI = SPPlayerReplicationInfo(GetPC().PlayerReplicationInfo);
    // End:0xB0
    if(SPPRI != none)
    {
        // End:0x66
        if(!SPPRI.bHeadsetPresent && GetWorldInfo().IsConsoleBuild(1))
        {
            TalkingTimer = 0.0000000;
        }
        // End:0xB0
        if(bTalking)
        {
            TalkingTimer -= DeltaTime;
            // End:0xB0
            if(TalkingTimer <= float(0))
            {
                SPPRI.SetPlayerTalking(false);
                bTalking = false;
                TalkingTimer = 0.0000000;
            }
        }
    }
    //return;    
}

function OnPlayerTalking(UniqueNetId TalkingPlayer)
{
    local SPPlayerReplicationInfo TalkerPRI;

    TalkerPRI = ResolveUniqueNetID(TalkingPlayer);
    // End:0x90
    if(TalkerPRI != none)
    {
        // End:0x90
        if((CanCommunicate(TalkingPlayer)) && TalkerPRI.PlayerName == GetPC().PlayerReplicationInfo.PlayerName)
        {
            TalkerPRI.SetPlayerTalking(true);
            bTalking = true;
            TalkingTimer = 1.0000000;
            return;
        }
    }
    //return;    
}

function string FormatTime(int Seconds)
{
    local int Minutes, Hours;
    local string Result;

    Seconds = int(Abs(float(Seconds)));
    // End:0x57
    if(Seconds > 3600)
    {
        Hours = Seconds / 3600;
        Seconds -= (Hours * 3600);
        Result = string(Hours) $ ":";
    }
    Minutes = Seconds / 60;
    Seconds -= (Minutes * 60);
    // End:0x8B
    if(Minutes < 10)
    {
        Result = "0";
    }
    Result = (Result $ string(Minutes)) $ ":";
    // End:0xC0
    if(Seconds < 10)
    {
        Result = Result $ "0";
    }
    Result = Result $ string(Seconds);
    return Result;
    //return ReturnValue;    
}

event SetVisibility(bool bIsVisible)
{
    super(UIScene).SetVisibility(bIsVisible);
    SetLookTargetMode(LookTargetType);
    // End:0x4C
    if(bIsVisible)
    {
        ShowHUD(false);
        SetSceneInputMode(2);
        GameSceneClient.bOverrideEmulateButtonPress = true;        
    }
    else
    {
        ShowHUD(true);
        SetSceneInputMode(0);
        GameSceneClient.bOverrideEmulateButtonPress = false;
    }
    //return;    
}

function ShowHUD(bool bShow)
{
    local PandoraPlayerController PPC;
    local SPHud mySPHud;
    local SPHudScene HudScene;

    PPC = GetPC();
    // End:0x9F
    if(PPC.myHUD != none)
    {
        mySPHud = SPHud(PPC.myHUD);
        HudScene = mySPHud.HudScene;
        // End:0x9F
        if(HudScene != none)
        {
            // End:0x85
            if(bShow)
            {
                HudScene.FadeIn(0.1000000);                
            }
            else
            {
                HudScene.FadeOut(0.1000000);
            }
        }
    }
    //return;    
}

function NotifyGameSessionEnded()
{
    GameSceneClient.bOverrideEmulateButtonPress = false;
    super.NotifyGameSessionEnded();
    //return;    
}

function ChildSceneOpened(UIScene NewTopScene)
{
    GameSceneClient.bOverrideEmulateButtonPress = false;
    //return;    
}

event SceneActivated(bool bInitialActivation)
{
    super(UIScene_BaseMenu).SceneActivated(bInitialActivation);
    SetLookTargetMode(0);
    GameSceneClient.bOverrideEmulateButtonPress = (PPC != none) && PPC.IsInState('Dead');
    //return;    
}

function bool IsPauseSceneOpen()
{
    local UIScene PauseScene;

    PauseScene = GameSceneClient.FindSceneByTag('Pause_Menu');
    return PauseScene != none;
    //return ReturnValue;    
}
