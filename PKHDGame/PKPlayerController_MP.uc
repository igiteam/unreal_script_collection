class PKPlayerController_MP extends PKPlayerController
    config(Game)
    hidecategories(Navigation);

var export editinline AudioComponent QuadAudioLoop;
var transient bool bDisplayingTutorialMessage;

function OnLoginStatusChange(OnlineSubsystem.ELoginStatus NewStatus, UniqueNetId NewId)
{
    super.OnLoginStatusChange(NewStatus, NewId);
    // End:0x45
    if(int(NewStatus) < int(2))
    {
        ShowOSSConnectionLostMessage();
        ReturnToMainMenu(true);
    }
    //return;    
}

function OnLoginChange(byte LocalUserNum)
{
    local UniqueNetId NetId;

    NetId = PlayerReplicationInfo.UniqueId;
    super.OnLoginChange(LocalUserNum);
    // End:0xAB
    if(NetId != PlayerReplicationInfo.UniqueId && !WorldInfo.IsMenuLevel())
    {
        ProfileSettings = none;
        PersistentData = none;
    }
    ShowLoginChangeError();
    ReturnToMainMenu(true);
    //return;    
}

simulated function NotifyHostMigrationStarted()
{
    local PKUIManager UIManager;
    local array<name> ButtonAliases;

    UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    ButtonAliases.AddItem('GenericContinue');
    UIManager.ShowUIMessage('NotifyHostMigrationStart', Localize("MessageBoxStrings", "HostMigration_Title", "GearGameUI"), Localize("MessageBoxStrings", "HostMigration_Message", "GearGameUI"), ButtonAliases, None, LocalPlayer(Player),,,, false, false);
    //return;    
}

reliable client simulated function ClientShowEndStatisticsScreen()
{
    // End:0x53
    if(!Class'Engine.Engine'.static.IsEditor())
    {
        SetCinematicMode(true, true, true, true, true, true);
        PKHudWrapper.ShowMPStatsScreen();
    }
    //return;    
}

reliable client simulated function PlayStartupMessage(byte StartupStage)
{
    // End:0x37
    if(int(StartupStage) == int(7))
    {
        ReceiveLocalizedMessage(Class'PKTimerMessage', 17, PlayerReplicationInfo);        
    }
    else
    {
        ReceiveLocalizedMessage(Class'PKStartupMessage', int(StartupStage), PlayerReplicationInfo);
    }
    //return;    
}

function Possess(Pawn inPawn, bool bVehicleTransition)
{
    ShowTopMC(false);
    super.Possess(inPawn, bVehicleTransition);
    //return;    
}

simulated function ShowTopMC(bool bShow)
{
    // End:0x7D
    if(PainGFxHudWrapper(myHUD) != none)
    {
        PainGFxHud(PainGFxHudWrapper(myHUD).HudMovie).TopMC.SetVisible(bShow);
    }
    //return;    
}

protected simulated function SoundCue GetSoundCueForPowerup(name PowerupID)
{
    // End:0x36
    if(PowerupID == 'QuadDamage')
    {
        return Class'PKQuadDamage'.default.ActiveSound;
    }
    return super.GetSoundCueForPowerup(PowerupID);
    //return ReturnValue;    
}

simulated function EnableQuadDamage()
{
    // End:0xED
    if(WorldInfo.GRI.IsMultiplayerGame() && !IsTimerActive('DisableQuadDamage'))
    {
        PainPRI(PlayerReplicationInfo).bQuadDamage = true;
        EnableQuadDamageFX(true);
        BroadcastPowerupLoopSound('QuadDamage', true);
        SetTimer(Class'PKGameMP_Base'.default.QuadDamageDuration, false, 'DisableQuadDamage');
        // End:0xED
        if(!IsInState('QuadDamage'))
        {
            PushState('QuadDamage');
        }
    }
    //return;    
}

simulated function DisableQuadDamage()
{
    PainPRI(PlayerReplicationInfo).bQuadDamage = false;
    EnableQuadDamageFX(false);
    BroadcastPowerupLoopSound('QuadDamage', false);
    ClearTimer('DisableQuadDamage');
    // End:0x78
    if(IsInState('QuadDamage'))
    {
        PopState();
    }
    //return;    
}

private reliable client final simulated function EnableQuadDamageFX(bool bEnable)
{
    EnableDemonFX(bEnable, false, false);
    // End:0xF3
    if(bEnable)
    {
        QuadAudioLoop = CreateAudioComponent(Class'PKQuadDamage'.default.ActiveSound1p, false, true,,, true);
        // End:0xCA
        if(QuadAudioLoop != none)
        {
            QuadAudioLoop.bAllowSpatialization = false;
            QuadAudioLoop.bAutoDestroy = true;
            QuadAudioLoop.Play();
        }
        // End:0xF0
        if(!IsInState('QuadDamage'))
        {
            PushState('QuadDamage');
        }        
    }
    else
    {
        // End:0x121
        if(QuadAudioLoop != none)
        {
            QuadAudioLoop.Stop();
        }
        PlaySound(Class'PKQuadDamage'.default.TimeoutSound);
        // End:0x169
        if(IsInState('QuadDamage'))
        {
            PopState();
        }
    }
    SetQuadDamageVisionMaterialOnPawns(bEnable);
    //return;    
}

function UpdatePowerUpEffectsFor(PKPawn P)
{
    //return;    
}

private final simulated function SetQuadDamageVisionMaterialOnPawns(bool bEnable)
{
    local PKPawn P;

    // End:0xBE
    foreach DynamicActors(Class'PKPawn', P)
    {
        // End:0x6C
        if(bEnable && PKPlayerPawn(P) != none)
        {
            PKPlayerPawn(P).UpdateQuadDamageVisionMaterial(self);
            // End:0xBD
            continue;
        }
        P.SetDemonMaterial(bEnable, P.IsSameTeam(Pawn));        
    }    
    //return;    
}

simulated function EnablePentagram()
{
    // End:0xD9
    if(WorldInfo.GRI.IsMultiplayerGame() && !IsTimerActive('DisablePentagram'))
    {
        PainPRI(PlayerReplicationInfo).bPentagram = true;
        EnablePentagramFX(true);
        SetTimer(Class'PKGameMP_Base'.default.PentagramDuration, false, 'DisablePentagram');
        // End:0xD9
        if(!IsInState('Pentagram'))
        {
            PushState('Pentagram');
        }
    }
    //return;    
}

reliable client simulated function EnablePentagramFX(bool bEnable)
{
    PKPostProcessManager(GetPPManager()).EnablePentagramPP(bEnable);
    // End:0x6A
    if(bEnable)
    {
        // End:0x67
        if(!IsInState('Pentagram'))
        {
            PushState('Pentagram');
        }        
    }
    else
    {
        // End:0x85
        if(IsInState('Pentagram'))
        {
            PopState();
        }
    }
    //return;    
}

simulated function DisablePentagram()
{
    EnablePentagramFX(false);
    PainPRI(PlayerReplicationInfo).bPentagram = false;
    ClearTimer('DisablePentagram');
    // End:0x64
    if(IsInState('Pentagram'))
    {
        PopState();
    }
    //return;    
}

reliable client simulated function ShowTeamPanel(bool bShow)
{
    // End:0x2F
    if(bShow)
    {
        PKHudWrapper.ShowScoreboardAndHud();        
    }
    else
    {
        PKHudWrapper.HideAndCloseScoreboard();
    }
    //return;    
}

reliable server function ClientSwitchTeam()
{
    SwitchTeam();
    //return;    
}

reliable server function SwitchReadyStatus()
{
    // End:0x67
    if(int(Role) == int(ROLE_Authority))
    {
        PainPRI(PlayerReplicationInfo).bReadyToPlay = !PainPRI(PlayerReplicationInfo).bReadyToPlay;
    }
    //return;    
}

reliable client simulated function WritePlayerStatus()
{
    local bool bReady;
    local string playerStatus;

    bReady = PainPRI(PlayerReplicationInfo).bReadyToPlay;
    // End:0x5E
    if(int(Role) != int(ROLE_Authority))
    {
        bReady = !bReady;
    }
    // End:0xC4
    if(bReady)
    {
        playerStatus = Repl(Class'PKGameMP_Base'.default.PlayerIsReady, "`p", PainPRI(PlayerReplicationInfo).PlayerName);        
    }
    else
    {
        playerStatus = Repl(Class'PKGameMP_Base'.default.PlayerIsUnready, "`p", PainPRI(PlayerReplicationInfo).PlayerName);
    }
    PainGFxHud(PainGFxHudWrapper(myHUD).HudMovie).AddMessage("htmlText", playerStatus);
    //return;    
}

function bool CleanupOnlineSubsystemSession(bool bWasFromMenu)
{
    return super(UTPlayerController).CleanupOnlineSubsystemSession(bWasFromMenu);
    //return ReturnValue;    
}

function OnLinkStatusChange(bool bIsConnected)
{
    local PKUIManager UIManager;
    local array<name> ButtonAliases;

    // End:0x189
    if(!bIsConnected)
    {
        // End:0x6E
        if(int(WorldInfo.NetMode) == int(NM_ListenServer))
        {
            WorldInfo.Game.bHasNetworkError = true;
        }
        UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
        // End:0x189
        if(UIManager != none)
        {
            ButtonAliases.AddItem('GenericAccept');
            UIManager.ShowUIMessage('ConnectionError', Localize("MessageBoxErrorStrings", "LostLink_Title", "PKHDGame"), Localize("MessageBoxErrorStrings", "LostLink_Message", "PKHDGame"), ButtonAliases, None,,,,, false, false);
        }
    }
    //return;    
}

exec function ToggleFlashlight()
{
    //return;    
}

state QuadDamage extends PlayerWalking
{
    function UpdatePowerUpEffectsFor(PKPawn P)
    {
        // End:0x60
        if(PKPlayerPawn(P) == none)
        {
            P.SetDemonMaterial(true, P.IsSameTeam(Pawn));
        }
        //return;        
    }

    function PawnDied(Pawn inPawn)
    {
        global.PawnDied(inPawn);
        DisableQuadDamage();
        //return;        
    }
    stop;    
}

state Pentagram extends PlayerWalking
{
    function PawnDied(Pawn inPawn)
    {
        global.PawnDied(inPawn);
        DisablePentagram();
        //return;        
    }
    stop;    
}

auto state PlayerWaiting
{
    ignores SwitchWeapon;

    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        bDisplayingTutorialMessage = false;
        //return;        
    }

    simulated event FellOutOfWorld(class<DamageType> dmgType)
    {
        bCameraOutOfWorld = true;
        //return;        
    }

    function ProcessMove(float DeltaTime, Vector newAccel, Actor.EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        local Vector OldLocation;

        OldLocation = Location;
        super(BaseSpectating).ProcessMove(DeltaTime, newAccel, DoubleClickMove, DeltaRot);
        // End:0x66
        if(bCameraOutOfWorld)
        {
            bCameraOutOfWorld = false;
            SetLocation(OldLocation);
        }
        //return;        
    }

    exec function StartFire(optional byte FireModeNum)
    {
        // End:0x12
        if(!CheckDLCInSpectator())
        {
            return;
        }
        // End:0x124
        if(PainGRI(WorldInfo.GRI) != none)
        {
            // End:0xDA
            if(!PainGRI(WorldInfo.GRI).bMatchHasBegun && PainGRI(WorldInfo.GRI).IsTeamMultiPlayerGame())
            {
                SwitchReadyStatus();
                WritePlayerStatus();                
            }
            else
            {
                // End:0x124
                if(PainGRI(WorldInfo.GRI).bMatchHasBegun)
                {
                    ServerRestartPlayer();
                }
            }
        }
        //return;        
    }

    exec function StartAltFire(optional byte FireModeNum)
    {
        // End:0x7A
        if((PainGRI(WorldInfo.GRI) != none) && PainGRI(WorldInfo.GRI).IsTeamMultiPlayerGame())
        {
            ClientSwitchTeam();
        }
        //return;        
    }

    reliable server function ServerRestartPlayer()
    {
        super.ServerRestartPlayer();
        // End:0x102
        if((WorldInfo.Game.bWaitingToStartMatch && EvilGame(WorldInfo.Game).bWarmupRound) && float(EvilGame(WorldInfo.Game).WarmupTime) > 1.0000000)
        {
            WorldInfo.Game.RestartPlayer(self);
        }
        //return;        
    }

    event PlayerTick(float DeltaTime)
    {
        local string LocKeyString;

        super(PlayerController).PlayerTick(DeltaTime);
        // End:0x1E1
        if(((((PainGRI(WorldInfo.GRI) != none) && PainGRI(WorldInfo.GRI).bMatchHasBegun) && !bDisplayingTutorialMessage) && PKHudWrapper != none) && PKHudWrapper.HudMovie != none)
        {
            LocKeyString = "JoinBattleString";
            // End:0x128
            if(WorldInfo.IsConsoleBuild(1))
            {
                LocKeyString = LocKeyString $ "XBOX";                
            }
            else
            {
                // End:0x166
                if(WorldInfo.IsConsoleBuild(2))
                {
                    LocKeyString = LocKeyString $ "PS3";
                }
            }
            PainGFxHud(PKHudWrapper.HudMovie).ShowTutorialMessage(Localize("PKPlayerController", LocKeyString, "PKHDGame"), true);
            bDisplayingTutorialMessage = true;
        }
        //return;        
    }

    simulated event EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        // End:0x85
        if((PKHudWrapper != none) && PKHudWrapper.HudMovie != none)
        {
            PainGFxHud(PKHudWrapper.HudMovie).HideTutorialMessage();
        }
        //return;        
    }
    stop;    
}

state RoundEnded
{
    ignores SeePlayer, HearNoise, KilledBy, NotifyBump, HitWall, NotifyHeadVolumeChange, 
	    NotifyPhysicsVolumeChange, Falling, TakeDamage, Suicide, DrawHUD, 
	    PrevWeapon, NextWeapon, SwitchWeapon, QuickCustom1Fire, QuickCustom2Fire, 
	    ChoseCustom1, ChoseCustom2, ToggleMelee;

    function AutoContinueToNextRound()
    {
        // End:0x88
        if(((int(Role) == int(ROLE_Authority)) && WorldInfo.Game.ShouldAutoContinueToNextRound()) && PKGameSurvival(WorldInfo.Game) == none)
        {
            StartFire(0);
        }
        //return;        
    }

    event Rotator LimitViewRotation(Rotator ViewRotation, float ViewPitchMin, float ViewPitchMax)
    {
        ViewRotation.Pitch = ViewRotation.Pitch & 65535;
        // End:0x119
        if((ViewRotation.Pitch > 8192) && float(ViewRotation.Pitch) < (float(65535) + ViewPitchMin))
        {
            // End:0xE8
            if(ViewRotation.Pitch < 32768)
            {
                ViewRotation.Pitch = 8192;                
            }
            else
            {
                ViewRotation.Pitch = int(float(65535) + ViewPitchMin);
            }
        }
        return ViewRotation;
        //return ReturnValue;        
    }

    unreliable client simulated function LongClientAdjustPosition(float TimeStamp, name NewState, Actor.EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, Actor NewBase, float NewFloorX, float NewFloorY, float NewFloorZ)
    {
        // End:0x25
        if(NewState == 'PlayerWaiting')
        {
            GotoState(NewState);
        }
        //return;        
    }

    function PlayerMove(float DeltaTime)
    {
        local Vector X, Y, Z;
        local Rotator DeltaRot, ViewRotation;

        GetAxes(Rotation, X, Y, Z);
        ViewRotation = Rotation;
        DeltaRot.Yaw = int(PlayerInput.aTurn);
        DeltaRot.Pitch = int(PlayerInput.aLookUp);
        ProcessViewRotation(DeltaTime, ViewRotation, DeltaRot);
        SetRotation(ViewRotation);
        ViewShake(DeltaTime);
        // End:0x13A
        if(int(Role) < int(ROLE_Authority))
        {
            ReplicateMove(DeltaTime, vect(0.0000000, 0.0000000, 0.0000000), 0, rot(0, 0, 0));
        }
        bPressedJump = false;
        //return;        
    }

    function ShowScoreboard()
    {
        local UTGameReplicationInfo GRI;

        GRI = UTGameReplicationInfo(WorldInfo.GRI);
        // End:0xA1
        if(((GRI != none) && GRI.bMatchIsOver) && !GRI.bStoryMode)
        {
            ShowMidGameMenu('ScoreTab', true);            
        }
        else
        {
            // End:0xD0
            if(myHUD != none)
            {
                myHUD.SetShowScores(true);
            }
        }
        AutoContinueToNextRound();
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        // End:0x42
        if(PainGFxHudWrapper(myHUD) != none)
        {
            PainGFxHudWrapper(myHUD).bShowContinueMsgOnStats = true;
        }
        super.BeginState(PreviousStateName);
        SetOnlyUseControllerTiltInput(false);
        SetUseTiltForwardAndBack(true);
        SetControllerTiltActive(false);
        // End:0xF5
        if(EvilGame(WorldInfo.Game) != none)
        {
            SetTimer(FMax(GetTimerRate(), float(EvilGame(WorldInfo.Game).ResetTimeDelay)), false);
        }
        bAlreadyReset = false;
        // End:0x143
        if(PainGFxHudWrapper(myHUD) != none)
        {
            PainGFxHudWrapper(myHUD).bBlockScoreboard = true;
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        SetBehindView(false);
        StopViewShaking();
        StopCameraAnim(true);
        // End:0x95
        if(PainGFxHudWrapper(myHUD) != none)
        {
            PainGFxHudWrapper(myHUD).bBlockScoreboard = false;
            myHUD.SetShowScores(false);
        }
        //return;        
    }
    stop;    
}

state Dead
{
    function BeginState(name PreviousStateName)
    {
        local UTWeaponLocker WL;
        local EvilWeaponPickupFactory WF;

        bDisplayingTutorialMessage = false;
        LastAutoObjective = none;
        // End:0x3A
        if(Pawn(ViewTarget) != none)
        {
            SetBehindView(true);
        }
        super.BeginState(PreviousStateName);
        // End:0x111
        if(LocalPlayer(Player) != none)
        {
            // End:0xBA
            foreach WorldInfo.AllNavigationPoints(Class'EvilGame.UTWeaponLocker', WL)
            {
                WL.NotifyLocalPlayerDead(self);                
            }            
            // End:0x110
            foreach WorldInfo.AllNavigationPoints(Class'EvilGame.EvilWeaponPickupFactory', WF)
            {
                WF.NotifyLocalPlayerDead(self);                
            }            
        }
        // End:0x1AD
        if(((int(Role) == int(ROLE_Authority)) && EvilGame(WorldInfo.Game) != none) && EvilGame(WorldInfo.Game).ForceRespawn())
        {
            SetTimer(MinRespawnDelay, true, 'DoForcedRespawn');
        }
        //return;        
    }

    function FindGoodView()
    {
        local Vector CameraLoc;
        local Rotator CameraRot, ViewRotation, RealRotation;
        local int tries, besttry;
        local float bestDist, newdist, RealCameraScale;
        local int startYaw;
        local EvilPawn P;

        // End:0x61
        if(EvilVehicle_Base(ViewTarget) != none)
        {
            // End:0x53
            if(Pawn != none)
            {
                Pawn.SetDesiredRotation(Rotation);
            }
            bUsePhysicsRotation = true;
            return;
        }
        ViewRotation = Rotation;
        RealRotation = ViewRotation;
        ViewRotation.Pitch = 56000;
        SetRotation(ViewRotation);
        P = EvilPawn(ViewTarget);
        // End:0x145
        if(P != none)
        {
            RealCameraScale = P.CurrentCameraScale;
            P.CurrentCameraScale = P.CameraScale;
        }
        CalcViewActor = none;
        CameraLoc = ViewTarget.Location;
        GetPlayerViewPoint(CameraLoc, CameraRot);
        // End:0x412
        if(P != none)
        {
            newdist = VSize(CameraLoc - ViewTarget.Location);
            // End:0x3EA
            if(newdist < (P.CylinderComponent.CollisionRadius + P.CylinderComponent.CollisionHeight))
            {
                tries = 0;
                besttry = 0;
                bestDist = 0.0000000;
                startYaw = ViewRotation.Yaw;
                tries = 1;
                J0x2A4:

                // End:0x3B2 [Loop If]
                if(tries < 16)
                {
                    CalcViewActor = none;
                    CameraLoc = ViewTarget.Location;
                    ViewRotation.Yaw += 4096;
                    SetRotation(ViewRotation);
                    GetPlayerViewPoint(CameraLoc, CameraRot);
                    newdist = VSize(CameraLoc - ViewTarget.Location);
                    // End:0x3A4
                    if(newdist > bestDist)
                    {
                        bestDist = newdist;
                        besttry = tries;
                    }
                    tries++;
                    // [Loop Continue]
                    goto J0x2A4;
                }
                ViewRotation.Yaw = startYaw + (besttry * 4096);
            }
            P.CurrentCameraScale = RealCameraScale;
        }
        SetRotation(RealRotation);
        // End:0x493
        if(Pawn != none)
        {
            Pawn.SetDesiredRotation(MakeRotator(ViewRotation.Pitch, ViewRotation.Yaw, 0));
        }
        bUsePhysicsRotation = true;
        //return;        
    }

    exec function StartFire(optional byte FireModeNum)
    {
        // End:0x49
        if(bFrozen)
        {
            // End:0x47
            if(!IsTimerActive() || GetTimerCount() > MinRespawnDelay)
            {
                bFrozen = false;
            }
            return;
        }
        ServerRestartPlayer();
        //return;        
    }

    event PlayerTick(float DeltaTime)
    {
        local string LocKeyString;

        super(PKPlayerController).PlayerTick(DeltaTime);
        // End:0x16D
        if((!bDisplayingTutorialMessage && PKHudWrapper != none) && PKHudWrapper.HudMovie != none)
        {
            LocKeyString = "RespawnString";
            // End:0xB4
            if(WorldInfo.IsConsoleBuild(1))
            {
                LocKeyString = LocKeyString $ "XBOX";                
            }
            else
            {
                // End:0xF2
                if(WorldInfo.IsConsoleBuild(2))
                {
                    LocKeyString = LocKeyString $ "PS3";
                }
            }
            PainGFxHud(PKHudWrapper.HudMovie).ShowTutorialMessage(Localize("PKPlayerController", LocKeyString, "PKHDGame"), true);
            bDisplayingTutorialMessage = true;
        }
        //return;        
    }

    simulated event EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        // End:0x85
        if((PKHudWrapper != none) && PKHudWrapper.HudMovie != none)
        {
            PainGFxHud(PKHudWrapper.HudMovie).HideTutorialMessage();
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: EvilSceneCaptureHighlightComponent'Default__PKPlayerController_MP.HighlightComponent'
    // Archetype: EvilSceneCaptureHighlightComponent'Default__PKPlayerController.HighlightComponent'
    begin object name="HighlightComponent"
    end object
    HighlightSceneCaptureComponent=HighlightComponent
    // Reference: ForceFeedbackWaveform'Default__PKPlayerController_MP.ForceFeedbackWaveform7'
    // Archetype: ForceFeedbackWaveform'Default__PKPlayerController.ForceFeedbackWaveform7'
    begin object name="ForceFeedbackWaveform7"
    end object
    CameraShakeShortWaveForm=ForceFeedbackWaveform7
    // Reference: ForceFeedbackWaveform'Default__PKPlayerController_MP.ForceFeedbackWaveform8'
    // Archetype: ForceFeedbackWaveform'Default__PKPlayerController.ForceFeedbackWaveform8'
    begin object name="ForceFeedbackWaveform8"
    end object
    CameraShakeLongWaveForm=ForceFeedbackWaveform8
    // Reference: CylinderComponent'Default__PKPlayerController_MP.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PKPlayerController.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    Components[0]=CollisionCylinder
    Components[1]=HighlightComponent
    CollisionComponent=CollisionCylinder
}