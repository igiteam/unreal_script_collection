class AdvPlayerControllerSP extends AdvPlayerController
    config(Game)
    hidecategories(Navigation);

var array<CameraAnim> DeathCameraAnims;
var array<CameraAnim> DeathCrouchedCameraAnims;
var array<CameraAnim> DeathFallCameraAnims;
var array<CameraAnim> DeathWaterCameraAnims;
var transient bool bIsPawnDead;
var repnotify transient Pawn PreDeathPawn;

replication
{
    // Pos:0x000
    if(bNetDirty
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

reliable client simulated function ClientShowEndStatisticsScreen()
{
    // End:0x60
    if(!Class'Engine.Engine'.static.IsEditor())
    {
        SetCinematicMode(true, true, true, true, true, true);
        // End:0x60
        if(IsPrimaryPlayer())
        {
            AdvHudWrapper.ToggleEndGameSPStatsScreen();
        }
    }
    //return;    
}

function OnLoginChange(byte LocalUserNum)
{
    local UniqueNetId NetId;
    local Engine Eng;

    Eng = Class'Engine.Engine'.static.GetEngine();
    NetId = PlayerReplicationInfo.UniqueId;
    // End:0x13D
    if(Eng.ForceReturnToISAfterDLCRemoval && CheckIfSomeoneIsLogged())
    {
        super.OnLoginChange(LocalUserNum);
        ShowDLCRemovalError();
        // End:0x10F
        if(NetId != PlayerReplicationInfo.UniqueId && !WorldInfo.IsMenuLevel())
        {
            ProfileSettings = none;
            PersistentData = none;
        }
        Eng.ForceReturnToISAfterDLCRemoval = false;
        ReturnToMainMenu(true);
        return;
    }
    // End:0x190
    if((LocalPlayer(Player) != none) && LocalPlayer(Player).ControllerId != int(LocalUserNum))
    {
        return;
    }
    super.OnLoginChange(LocalUserNum);
    // End:0x213
    if(NetId != PlayerReplicationInfo.UniqueId && !WorldInfo.IsMenuLevel())
    {
        ProfileSettings = none;
        PersistentData = none;
    }
    ShowLoginChangeError();
    ReturnToMainMenu(true);
    //return;    
}

function OnLinkStatusChanged(bool bIsConnected)
{
    //return;    
}

function OnLoginStatusChange(OnlineSubsystem.ELoginStatus NewStatus, UniqueNetId NewId)
{
    super.OnLoginStatusChange(NewStatus, NewId);
    // End:0x89
    if((int(NewStatus) == int(0)) || (int(WorldInfo.NetMode) == int(NM_Client)) && int(NewStatus) < int(2))
    {
        ShowOSSConnectionLostMessage();
        ReturnToMainMenu(true);        
    }
    else
    {
        // End:0x9D
        if(int(NewStatus) < int(2))
        {
        }
    }
    //return;    
}

simulated function ReplaceNoPrimaryStorageDeviceMessage()
{
    local AdvUIManager UIMan;
    local AdvLocalPlayer LP;

    UIMan = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    LP = AdvLocalPlayer(Player);
    // End:0x1DA
    if((UIMan.IsUIMessageActive('StorageError', LP) && int(OnlineSub.PlayerInterface.GetLoginStatus(byte(LP.ControllerId))) > int(0)) && !OnlineSub.PlayerInterface.IsGuestLogin(byte(LP.ControllerId)))
    {
        UIMan.ClearUIMessage('StorageError', LP, true);
        LP.bHasSeenStartScreen = true;
        AdvDataProvider_PlayerStorage(OnlinePlayerData.StorageProvider).ShowNoPrimaryStorageMessageWithReselectOptions(LP, true);
    }
    //return;    
}

simulated function ReturnToMainMenu(bool bReturnToStartScreen)
{
    local AdvPlayerController PC;

    super.ReturnToMainMenu(bReturnToStartScreen);
    // End:0x1DF
    if((int(WorldInfo.NetMode) == int(NM_ListenServer)) && int(Role) == int(ROLE_Authority))
    {
        // End:0x14E
        foreach WorldInfo.AllControllers(Class'AdvPlayerController', PC)
        {
            // End:0x14D
            if(!PC.IsLocalController())
            {
                PC.ClientSetProgressMessage(2, Localize("Errors", "ConnectionFailed", "ADVGame"), Localize("Errors", "ConnectionFailed_Title", "ADVGame"), true);
                PC.ClientReturnToMainMenu(true);
            }            
        }        
        // End:0x1DF
        if(WorldInfo.Game != none)
        {
            WorldInfo.Game.bPauseable = true;
            WorldInfo.Game.SetPause(self);
        }
    }
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
        super.PawnDied(P);
        return;
    }
    P.GetActorEyesViewPoint(Loc, Rot);
    PreDeathPawn = P;
    super.PawnDied(P);
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
    AdvPostProcessManager(GetPPManager()).EnableDeath();
    // End:0x1FE
    if(bPlayCameraAnim)
    {
        // End:0x1D8
        if(EvilPawn(PreDeathPawn) != none)
        {
            // End:0x105
            if(ClassIsChildOf(EvilPawn(PreDeathPawn).CurrentDamageType, Class'Engine.DmgType_Fell') || ClassIsChildOf(EvilPawn(PreDeathPawn).CurrentDamageType, Class'EvilGame.EvilDmgType_Fell'))
            {
                PlayCameraAnim(DeathFallCameraAnims[Rand(DeathFallCameraAnims.Length)]);                
            }
            else
            {
                // End:0x164
                if(ClassIsChildOf(EvilPawn(PreDeathPawn).CurrentDamageType, Class'EvilGame.EvilDmgType_Water'))
                {
                    PlayCameraAnim(DeathWaterCameraAnims[Rand(DeathWaterCameraAnims.Length)]);                    
                }
                else
                {
                    // End:0x1AF
                    if(PreDeathPawn.bIsCrouched)
                    {
                        PlayCameraAnim(DeathCrouchedCameraAnims[Rand(DeathCrouchedCameraAnims.Length)]);                        
                    }
                    else
                    {
                        PlayCameraAnim(DeathCameraAnims[Rand(DeathCameraAnims.Length)]);
                    }
                }
            }            
        }
        else
        {
            PlayCameraAnim(DeathCameraAnims[Rand(DeathCameraAnims.Length)]);
        }
    }
    //return;    
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

    function BeginState(name PreviousStateName)
    {
        local bool bGameOver;

        super.BeginState(PreviousStateName);
        // End:0x2B
        if(bLastSprintState)
        {
            StopCameraAnim();
        }
        // End:0xBE
        if(bIsPawnDead && int(EvilEngine(Class'Engine.Engine'.static.GetEngine()).PendingCheckpointAction) != int(1))
        {
            ClientPlayDeathFX(!bDeathLocationNotValid);
            // End:0xBE
            if(!bDeathLocationNotValid)
            {
                Velocity = vect(0.0000000, 0.0000000, 0.0000000);
            }
        }
        // End:0x1A5
        if(!EvilGame(WorldInfo.Game).bCheckpointLoadInProgress && !WorldInfo.GRI.IsMultiplayerGame())
        {
            bGameOver = true;
            // End:0x1A5
            if((int(Role) == int(ROLE_Authority)) && !WorldInfo.IsPlayInEditor())
            {
                // End:0x1A5
                if(bGameOver)
                {
                    SetTimer(MinRespawnDelay, false, 'ProcessGameOver');
                }
            }
        }
        //return;        
    }

    function EndState(name NextStateName)
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

        global.PlayerTick(DeltaTime);
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
    DeathCameraAnims[0]=CameraAnim'ca_Death.Anim.CA_Death1'
    DeathCrouchedCameraAnims[0]=CameraAnim'ca_Death.Anim.CA_Death_Crouch'
    DeathFallCameraAnims[0]=CameraAnim'ca_Death.Anim.CA_Death_Fall'
    DeathWaterCameraAnims[0]=CameraAnim'ca_Death.Anim.CA_Death_Water'
    // Reference: EvilSceneCaptureHighlightComponent'Default__AdvPlayerControllerSP.HighlightComponent'
    begin object name=HighlightComponent
    end object
    HighlightSceneCaptureComponent=HighlightComponent
    // Reference: ForceFeedbackWaveform'Default__AdvPlayerControllerSP.ForceFeedbackWaveform7'
    begin object name=ForceFeedbackWaveform7
    end object
    CameraShakeShortWaveForm=ForceFeedbackWaveform7
    // Reference: ForceFeedbackWaveform'Default__AdvPlayerControllerSP.ForceFeedbackWaveform8'
    begin object name=ForceFeedbackWaveform8
    end object
    CameraShakeLongWaveForm=ForceFeedbackWaveform8
    // Reference: CylinderComponent'Default__AdvPlayerControllerSP.CollisionCylinder'
    begin object name=CollisionCylinder
        ReplacementPrimitive=none
    end object
    CylinderComponent=CollisionCylinder
    MinRespawnDelay=3.0000000
    Components[0]=CollisionCylinder
    Components[1]=HighlightComponent
    CollisionComponent=CollisionCylinder
}