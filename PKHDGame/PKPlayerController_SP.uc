class PKPlayerController_SP extends PKPlayerController
    config(Game)
    hidecategories(Navigation);

var array<CameraAnim> DeathCameraAnims;
var transient bool bIsPawnDead;
var repnotify transient Pawn PreDeathPawn;

replication
{
    // Pos:0x000
    if(bNetDirty)
        PreDeathPawn;
}

simulated event ReplicatedEvent(name VarName)
{
    local Vector Loc;
    local Rotator Rot;

    switch(VarName)
    {
        // End:0xA2
        case 'PreDeathPawn':
            // End:0x93
            if(PreDeathPawn != none)
            {
                bIsPawnDead = true;
                PreDeathPawn.GetActorEyesViewPoint(Loc, Rot);
                PrepareForDeathCam(Loc, Rot, PreDeathPawn);                
            }
            else
            {
                bIsPawnDead = false;
            }
            // End:0xBB
            break;
        // End:0xFFFF
        default:
            super.ReplicatedEvent(VarName);
            // End:0xBB
            break;
            break;
    }
    //return;    
}

function GameHasEnded(optional Actor EndGameFocus, optional bool bIsWinner)
{
    //return;    
}

reliable client simulated function ClientShowEndStatisticsScreen()
{
    // End:0x53
    if(!Class'Engine.Engine'.static.IsEditor())
    {
        SetCinematicMode(true, true, true, true, true, true);
        PKHudWrapper.ToggleEndGameSPStatsScreen();
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

function PawnDied(Pawn P)
{
    local Vector Loc;
    local Rotator Rot;

    bIsPawnDead = P.Health <= 0;
    // End:0x50
    if(!bIsPawnDead)
    {
        super(EvilPlayerController).PawnDied(P);
        return;
    }
    P.GetActorEyesViewPoint(Loc, Rot);
    PreDeathPawn = P;
    GetMeleeActionsManager().StopHintMessage();
    super(UTPlayerController).PawnDied(P);
    PrepareForDeathCam(Loc, Rot, P);
    //return;    
}

simulated function PrepareForDeathCam(Vector POVLocation, Rotator POVRotation, Pawn P)
{
    local editinline PrimitiveComponent Comp;

    SetLocation(POVLocation);
    SetRotation(POVRotation);
    P.SetOwner(self);
    // End:0x86
    foreach P.ComponentList(Class'Engine.PrimitiveComponent', Comp)
    {
        Comp.SetOwnerNoSee(true);        
    }    
    Velocity = P.Velocity;
    //return;    
}

reliable client simulated function ClientPlayDeathFX(bool bPlayCameraAnim)
{
    GetPPManager().Reset();
    PKPostProcessManager(GetPPManager()).EnableDeath();
    // End:0x7C
    if(bPlayCameraAnim)
    {
        PlayCameraAnim(DeathCameraAnims[Rand(DeathCameraAnims.Length)]);
    }
    //return;    
}

simulated event ReceivedPlayer()
{
    super(EvilPlayerController).ReceivedPlayer();
    LocalPlayer(Player).ClearPostProcessSettingsOverride(0.0000000);
    //return;    
}

reliable client simulated function ClientRestart(Pawn NewPawn)
{
    super(UTConsolePlayerController).ClientRestart(NewPawn);
    // End:0x43
    if((GetPPManager()) != none)
    {
        GetPPManager().Reset();
    }
    //return;    
}

exec function PKDemon(optional float DemonTime)
{
    // End:0x81
    if(PKGame(WorldInfo.Game).IsDeamonMode())
    {
        PKGame(WorldInfo.Game).StopDaemonMode();        
    }
    else
    {
        PKGame(WorldInfo.Game).StartDaemonMode(DemonTime);
    }
    //return;    
}

exec function KillAllEnemyAIPawns()
{
    local EvilPawn P;
    local EvilPlayer_interface EPI;

    EPI = EvilPlayer_interface(Pawn);
    // End:0x3E
    if(EqualEqual_InterfaceInterface(EPI, EvilPlayer_interface(none)))
    {
        return;
    }
    // End:0x12B
    foreach DynamicActors(Class'EvilGame.EvilPawn', P)
    {
        // End:0x12A
        if(!P.IsPlayerPawn() && !EPI.GetPlayerPawn().IsSameTeam(P))
        {
            // End:0x112
            if(P.Controller != none)
            {
                P.Controller.Destroy();
            }
            P.Destroy();
        }        
    }    
    //return;    
}

auto state PlayerWaiting
{
    simulated event BeginState(name PreviousStateName)
    {
        // End:0x5E
        if(int(Role) == int(ROLE_Authority))
        {
            // End:0x5E
            if(WorldInfo.Game.MatchIsInProgress())
            {
                SetTimer(0.5000000, false, 'ServerRestartPlayer');
            }
        }
        //return;        
    }
    stop;    
}

state Dead
{
    function FindGoodView()
    {
        // End:0x1B
        if(!bIsPawnDead)
        {
            super.FindGoodView();
            return;
        }
        SetViewTarget(none);
        bUsePhysicsRotation = false;
        //return;        
    }

    event BeginState(name PreviousStateName)
    {
        local UTWeaponLocker WL;
        local EvilWeaponPickupFactory WF;
        local bool bGameOver;
        local PKPlayerController PC;

        LastAutoObjective = none;
        super.BeginState(PreviousStateName);
        // End:0xE2
        if(LocalPlayer(Player) != none)
        {
            // End:0x8B
            foreach WorldInfo.AllNavigationPoints(Class'EvilGame.UTWeaponLocker', WL)
            {
                WL.NotifyLocalPlayerDead(self);                
            }            
            // End:0xE1
            foreach WorldInfo.AllNavigationPoints(Class'EvilGame.EvilWeaponPickupFactory', WF)
            {
                WF.NotifyLocalPlayerDead(self);                
            }            
        }
        // End:0x175
        if(bIsPawnDead && int(EvilEngine(Class'Engine.Engine'.static.GetEngine()).PendingCheckpointAction) != int(1))
        {
            ClientPlayDeathFX(!bDeathLocationNotValid);
            // End:0x175
            if(!bDeathLocationNotValid)
            {
                Velocity = vect(0.0000000, 0.0000000, 0.0000000);
            }
        }
        // End:0x354
        if(!EvilGame(WorldInfo.Game).bCheckpointLoadInProgress && !WorldInfo.GRI.IsMultiplayerGame())
        {
            bGameOver = true;
            // End:0x354
            if((int(Role) == int(ROLE_Authority)) && !WorldInfo.IsPlayInEditor())
            {
                // End:0x330
                if(IsCoop())
                {
                    // End:0x32F
                    foreach WorldInfo.AllControllers(Class'PKPlayerController', PC)
                    {
                        // End:0x32E
                        if(((PC.Pawn != none) && !PC.IsGhost()) && PC.Pawn.IsAliveAndWell())
                        {
                            bRespawnInGhostMode = true;
                            SetTimer(MinRespawnDelay, false, 'RespawnDeadCoopPlayer');
                            bGameOver = false;
                            // End:0x32F
                            break;
                        }                        
                    }                    
                }
                // End:0x354
                if(bGameOver)
                {
                    SetTimer(MinRespawnDelay, false, 'ProcessGameOver');
                }
            }
        }
        //return;        
    }

    event EndState(name NextStateName)
    {
        bIsPawnDead = false;
        PreDeathPawn = none;
        super.EndState(NextStateName);
        //return;        
    }

    event PlayerTick(float DeltaTime)
    {
        local bool Actors, World;
        local Rotator Rot;

        super(PKPlayerController).PlayerTick(DeltaTime);
        // End:0x17C
        if((bIsPawnDead && bDeathLocationNotValid) && NormalizeRotAxis(Rotation.Pitch) < 15000)
        {
            Rot = Rotation;
            Rot.Pitch = 16384;
            SetRotation(RInterpTo(Rotation, Rot, DeltaTime, 4.0000000));
            Velocity += ((vect(0.0000000, 0.0000000, 1.0000000) * (GetGravityZ())) * DeltaTime);
            Actors = bCollideActors;
            World = bCollideWorld;
            bCollideWorld = true;
            SetCollision(true, bBlockActors);
            Move(Velocity * DeltaTime);
            bCollideWorld = World;
            SetCollision(Actors, bBlockActors);
        }
        //return;        
    }
    stop;    
}

defaultproperties
{
    DeathCameraAnims[0]=CameraAnim'ch_Daniel.Anim.CA_Death1'
    // Reference: EvilSceneCaptureHighlightComponent'Default__PKPlayerController_SP.HighlightComponent'
    // Archetype: EvilSceneCaptureHighlightComponent'Default__PKPlayerController.HighlightComponent'
    begin object name="HighlightComponent"
    end object
    HighlightSceneCaptureComponent=HighlightComponent
    // Reference: ForceFeedbackWaveform'Default__PKPlayerController_SP.ForceFeedbackWaveform7'
    // Archetype: ForceFeedbackWaveform'Default__PKPlayerController.ForceFeedbackWaveform7'
    begin object name="ForceFeedbackWaveform7"
    end object
    CameraShakeShortWaveForm=ForceFeedbackWaveform7
    // Reference: ForceFeedbackWaveform'Default__PKPlayerController_SP.ForceFeedbackWaveform8'
    // Archetype: ForceFeedbackWaveform'Default__PKPlayerController.ForceFeedbackWaveform8'
    begin object name="ForceFeedbackWaveform8"
    end object
    CameraShakeLongWaveForm=ForceFeedbackWaveform8
    // Reference: CylinderComponent'Default__PKPlayerController_SP.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__PKPlayerController.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    MinRespawnDelay=3.0000000
    Components[0]=CollisionCylinder
    Components[1]=HighlightComponent
    CollisionComponent=CollisionCylinder
}