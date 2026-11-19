class SkyPlayerControllerBase extends GamePlayerController
    native
    config(Game);

enum ESkyPawnShadowMode
{
    SKY_SHADOW_None,                // 0
    SKY_SHADOW_Self,                // 1
    SKY_SHADOW_All,                 // 2
    SKY_SHADOW_MAX                  // 3
};

enum ESkyAutoObjectivePreference
{
    SKY_AOP_Disabled,               // 0
    SKY_AOP_Attack,                 // 1
    SKY_AOP_Defend,                 // 2
    SKY_AOP_MAX                     // 3
};

struct native SkyObjectiveAnnouncementInfo
{
    var() name AnnouncementName;
    var() const localized string AnnouncementText;

    structdefaultproperties
    {
        AnnouncementName="None"
        AnnouncementText=""
    }
};

var bool bLateComer;
var bool bDontUpdate;
var bool bIsTyping;
var bool bAcuteHearing;
var globalconfig bool bNoVoiceMessages;
var deprecated globalconfig bool bNoTextToSpeechVoiceMessages;
var globalconfig bool bNoVoiceTaunts;
var globalconfig bool bNoAutoTaunts;
var globalconfig bool bAutoTaunt;
var globalconfig bool bNoMatureLanguage;
var globalconfig bool bEnableDodging;
var globalconfig bool bLookUpStairs;
var globalconfig bool bSnapToLevel;
var globalconfig bool bAlwaysMouseLook;
var globalconfig bool bKeyboardLook;
var bool bCenterView;
var globalconfig bool bAlwaysLevel;
var bool bBehindView;
var bool bForceBehindView;
var bool bUsePhysicsRotation;
var bool bFreeCamera;
var globalconfig bool bLandingShake;
var config bool bCenteredWeaponFire;
var transient bool bNonlinearZoomInterpolation;
var transient bool bDebugFreeCam;
var globalconfig bool bAlwaysBeNiceToMe;
var bool bUsingXpacWeaponUpgrades;
var globalconfig SkyPlayerControllerBase.ESkyPawnShadowMode PawnShadowMode;
var globalconfig SkyPawnBase.ESkyWeaponHand WeaponHandPreference;
var SkyPawnBase.ESkyWeaponHand WeaponHand;
var globalconfig SkyPlayerControllerBase.ESkyAutoObjectivePreference AutoObjectivePreference;
var Vector DesiredLocation;
var float LastTauntAnimTime;
var float LastKickWarningTime;
var const localized string MsgPlayerNotFound;
var ViewShakeInfo CurrentViewShake;
var ViewShakeInfo BaseDamageShake;
var Vector ShakeOffset;
var Rotator ShakeRot;
var float LastCameraTimeStamp;
var class<Camera> MatineeCameraClass;
var SkyGameObjective StartObjective;
var Actor CalcViewActor;
var Vector CalcViewActorLocation;
var Vector CalcViewLocation;
var Rotator CalcViewRotation;
var float LastWarningTime;
var Pawn ShadowPawn;
var float FOVLinearZoomRate;
var transient float FOVNonlinearZoomInterpSpeed;
var float ZoomRotationModifier;
var transient Rotator DebugFreeCamRot;
var float LastShowPathTime;
var Actor LastAutoObjective;
var SkyWeaponUpgrades WeaponUpgrades;
var UIScene JournalUI;

// Export USkyPlayerControllerBase::execClientHearSound(FFrame&, void* const)
unreliable client native simulated function ClientHearSound(SoundCue ASound, Actor SourceActor, Vector SourceLocation, bool bStopWhenOwnerDestroyed, optional bool bIsOccluded);

function bool FindVehicleToDrive()
{
    local SkyGameVehicle V;

    // End:0x0B
    if(super(PlayerController).FindVehicleToDrive())
    {
        return true;
    }
    // End:0xBD
    if(SkyGame(WorldInfo.Game) != none)
    {
        V = SkyGame(WorldInfo.Game).VehicleList;
        J0x49:

        // End:0xBD [Loop If]
        if(V != none)
        {
            // End:0xA5
            if((V.bHasCustomEntryRadius && V.InCustomEntryRadius(Pawn)) && V.TryToDrive(Pawn))
            {
                return true;
            }
            V = V.NextVehicle;
            // [Loop Continue]
            goto J0x49;
        }
    }
    return false;
    //return ReturnValue;    
}

simulated function bool LandingShake()
{
    return bLandingShake;
    //return ReturnValue;    
}

unreliable client simulated function ClientPlaySound(SoundCue ASound)
{
    PlaySound(ASound);
    //return;    
}

event ReceiveWarning(Pawn shooter, float projSpeed, Vector FireDir)
{
    // End:0x22
    if((WorldInfo.TimeSeconds - LastWarningTime) < 1.0000000)
    {
        return;
    }
    LastWarningTime = WorldInfo.TimeSeconds;
    //return;    
}

function ProjectileWarningTimer()
{
    //return;    
}

function PlayWinMessage(bool bWinner)
{
    //return;    
}

simulated function bool TriggerInteracted()
{
    local SkyGameObjective O, Best;
    local Vector ViewDir, PawnLoc2D, VLoc2D;
    local float NewDot, BestDot;

    // End:0x44
    if((SkyGameObjective(Pawn.Base) != none) && Pawn.Base.UsedBy(Pawn))
    {
        return true;
    }
    // End:0x7E
    foreach Pawn.TouchingActors(Class'SkyGameObjective', O)
    {
        // End:0x7D
        if(O.UsedBy(Pawn))
        {            
            return true;
        }        
    }    
    ViewDir = Vector(Rotation);
    PawnLoc2D = Pawn.Location;
    PawnLoc2D.Z = 0.0000000;
    // End:0x18A
    foreach Pawn.OverlappingActors(Class'SkyGameObjective', O, Pawn.VehicleCheckRadius)
    {
        // End:0x189
        if(O.bAllowRemoteUse)
        {
            VLoc2D = O.Location;
            VLoc2D.Z = 0.0000000;
            NewDot = Normal(VLoc2D - PawnLoc2D) Dot ViewDir;
            // End:0x189
            if(NewDot > BestDot)
            {
                // End:0x189
                if(FastTrace(O.Location, Pawn.Location))
                {
                    Best = O;
                    BestDot = NewDot;
                }
            }
        }        
    }    
    // End:0x1B6
    if((Best != none) && Best.UsedBy(Pawn))
    {
        return true;
    }
    return super(PlayerController).TriggerInteracted();
    //return ReturnValue;    
}

exec function PlayVehicleHorn(int HornIndex)
{
    local SkyGameVehicle V;

    V = SkyGameVehicle(Pawn);
    // End:0x78
    if(((V != none) && V.Health > 0) && (WorldInfo.TimeSeconds - LastTauntAnimTime) > 0.3000000)
    {
        ServerPlayVehicleHorn(HornIndex);
        LastTauntAnimTime = WorldInfo.TimeSeconds;
    }
    //return;    
}

unreliable server function ServerPlayVehicleHorn(int HornIndex)
{
    local SkyGameVehicle V;

    V = SkyGameVehicle(Pawn);
    // End:0x4B
    if((V != none) && V.Health > 0)
    {
        V.PlayHorn(HornIndex);
    }
    //return;    
}

function Typing(bool bTyping)
{
    bIsTyping = bTyping;
    // End:0x4B
    if((Pawn != none) && !Pawn.bTearOff)
    {
        SkyPawnBase(Pawn).bIsTyping = bTyping;
    }
    //return;    
}

simulated event Destroyed()
{
    super(PlayerController).Destroyed();
    //return;    
}

function SoakPause(Pawn P)
{
    SetViewTarget(P);
    SetPause(true);
    bBehindView = true;
    myHUD.bShowDebugInfo = true;
    //return;    
}

event KickWarning()
{
    // End:0x35
    if((WorldInfo.TimeSeconds - LastKickWarningTime) > 0.5000000)
    {
        LastKickWarningTime = WorldInfo.TimeSeconds;
    }
    //return;    
}

function CheckJumpOrDuck()
{
    // End:0x23
    if(bPressedJump)
    {
        Pawn.DoJump(bUpdating);
    }
    // End:0x73
    if((int(Pawn.Physics) != int(2)) && Pawn.bCanCrouch)
    {
        Pawn.ShouldCrouch(int(bDuck) != int(0));
    }
    //return;    
}

function Restart(bool bVehicleTransition)
{
    super(PlayerController).Restart(bVehicleTransition);
    // End:0x4F
    if(!bVehicleTransition)
    {
        CheckAutoObjective(false);
        SettingsLoadedCallback();
        SkyGame(WorldInfo.Game).CheckForUltraPack();
    }
    //return;    
}

reliable server function ServerBeNiceToMe()
{
    //return;    
}

reliable client simulated function ClientRestart(Pawn NewPawn)
{
    super(PlayerController).ClientRestart(NewPawn);
    ServerPlayerPreferences(WeaponHandPreference, bAutoTaunt, bCenteredWeaponFire, AutoObjectivePreference);
    // End:0x3E
    if(bAlwaysBeNiceToMe)
    {
        ServerBeNiceToMe();
    }
    // End:0x7E
    if(SkyGameVehicle(NewPawn) != none)
    {
        DefaultFOV = SkyGameVehicle(NewPawn).DefaultFOV;
        DesiredFOV = DefaultFOV;
        FOVAngle = DesiredFOV;
    }
    //return;    
}

function CheckAutoObjective(bool bOnlyNotifyDifferent)
{
    local SkyGameObjective DesiredObjective;
    local Actor ObjectiveActor;

    // End:0xB3
    if((Pawn != none) && PlayerReplicationInfo != none)
    {
        // End:0x5C
        if(SkyGame(WorldInfo.Game) != none)
        {
            DesiredObjective = SkyGame(WorldInfo.Game).GetAutoObjectiveFor(self);
        }
        // End:0xAC
        if(DesiredObjective != none)
        {
            ObjectiveActor = DesiredObjective.GetAutoObjectiveActor(self);
            // End:0xA9
            if((ObjectiveActor != LastAutoObjective) || !bOnlyNotifyDifferent)
            {
                LastAutoObjective = ObjectiveActor;
            }            
        }
        else
        {
            LastAutoObjective = none;
        }
    }
    //return;    
}

event Possess(Pawn inPawn, bool bVehicleTransition)
{
    super(PlayerController).Possess(inPawn, bVehicleTransition);
    ClientEndZoom();
    //return;    
}

event UnPossess()
{
    super(PlayerController).UnPossess();
    DefaultFOV = default.DefaultFOV;
    DesiredFOV = DefaultFOV;
    FOVAngle = DefaultFOV;
    //return;    
}

function AcknowledgePossession(Pawn P)
{
    super(PlayerController).AcknowledgePossession(P);
    // End:0x3B
    if(LocalPlayer(Player) != none)
    {
        ServerPlayerPreferences(WeaponHandPreference, bAutoTaunt, bCenteredWeaponFire, AutoObjectivePreference);
    }
    //return;    
}

function SetPawnFemale()
{
    PlayerReplicationInfo.bIsFemale = true;
    //return;    
}

simulated event ReceivedPlayer()
{
    super(PlayerController).ReceivedPlayer();
    // End:0x39
    if(LocalPlayer(Player) != none)
    {
        ServerPlayerPreferences(WeaponHandPreference, bAutoTaunt, bCenteredWeaponFire, AutoObjectivePreference);        
    }
    else
    {
        AutoObjectivePreference = 0;
    }
    //return;    
}

reliable server function ServerPlayerPreferences(SkyPawnBase.ESkyWeaponHand NewWeaponHand, bool bNewAutoTaunt, bool bNewCenteredWeaponFire, SkyPlayerControllerBase.ESkyAutoObjectivePreference NewAutoObjectivePreference)
{
    ServerSetHand(NewWeaponHand);
    ServerSetAutoTaunt(bNewAutoTaunt);
    bCenteredWeaponFire = bNewCenteredWeaponFire;
    // End:0x55
    if(int(AutoObjectivePreference) != int(NewAutoObjectivePreference))
    {
        AutoObjectivePreference = NewAutoObjectivePreference;
        CheckAutoObjective(false);
    }
    //return;    
}

reliable server function ServerSetHand(SkyPawnBase.ESkyWeaponHand NewWeaponHand)
{
    WeaponHand = NewWeaponHand;
    // End:0x39
    if(SkyPawnBase(Pawn) != none)
    {
        SkyPawnBase(Pawn).SetHand(WeaponHand);
    }
    //return;    
}

function SetHand(SkyPawnBase.ESkyWeaponHand NewWeaponHand)
{
    WeaponHandPreference = NewWeaponHand;
    SaveConfig();
    // End:0x3C
    if(SkyPawnBase(Pawn) != none)
    {
        SkyPawnBase(Pawn).SetHand(WeaponHand);
    }
    ServerSetHand(NewWeaponHand);
    //return;    
}

event ResetCameraMode()
{
    //return;    
}

function bool UsingFirstPersonCamera()
{
    return !bBehindView;
    //return ReturnValue;    
}

reliable server function ServerSetAutoTaunt(bool Value)
{
    bAutoTaunt = Value;
    //return;    
}

exec function SetAutoTaunt(bool Value)
{
    default.bAutoTaunt = Value;
    StaticSaveConfig();
    bAutoTaunt = Value;
    ServerSetAutoTaunt(Value);
    //return;    
}

exec function ToggleScreenShotMode()
{
    //return;    
}

function CheckSwappedFire(out byte FireModeNum)
{
    //return;    
}

exec function StartFire(optional byte FireModeNum)
{
    CheckSwappedFire(FireModeNum);
    super(PlayerController).StartFire(FireModeNum);
    //return;    
}

exec event StopFire(optional byte FireModeNum)
{
    CheckSwappedFire(FireModeNum);
    super(PlayerController).StopFire(FireModeNum);
    //return;    
}

unreliable client simulated function PlayStartupMessage(byte StartupStage)
{
    //return;    
}

function NotifyTakeHit(Controller InstigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum)
{
    local int iDam;

    super(PlayerController).NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
    iDam = Clamp(Damage, 0, 250);
    // End:0x75
    if((iDam > 0) || InGodMode())
    {
        ClientPlayTakeHit(HitLocation - Pawn.Location, byte(iDam), DamageType);
    }
    //return;    
}

unreliable client simulated function ClientPlayTakeHit(Vector HitLoc, byte Damage, class<DamageType> DamageType)
{
    DamageShake(int(Damage));
    HitLoc += Pawn.Location;
    //return;    
}

simulated function bool PerformedUseAction()
{
    // End:0x2C
    if((Pawn != none) && Pawn.IsInState('FeigningDeath'))
    {
        return true;        
    }
    else
    {
        return super(PlayerController).PerformedUseAction();
    }
    //return ReturnValue;    
}

function ServerSpectate()
{
    GotoState('Spectating');
    //return;    
}

function ShowScoreboard()
{
    //return;    
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local Canvas Canvas;

    Canvas = HUD.Canvas;
    Canvas.SetDrawColor(255, 255, 255, 255);
    Canvas.DrawText((((((("CONTROLLER " $ (GetItemName(string(self)))) $ " Physics ") $ (GetPhysicsName())) $ " Pawn ") $ (GetItemName(string(Pawn)))) $ " Rotation ") $ string(Rotation));
    out_YPos += out_YL;
    Canvas.SetPos(4.0000000, out_YPos);
    // End:0x178
    if(Pawn == none)
    {
        // End:0x117
        if(PlayerReplicationInfo == none)
        {
            Canvas.DrawText("NO PLAYERREPLICATIONINFO", false);            
        }
        else
        {
            PlayerReplicationInfo.DisplayDebug(HUD, out_YL, out_YPos);
        }
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        super(Actor).DisplayDebug(HUD, out_YL, out_YPos);        
    }
    else
    {
        // End:0x275
        if(HUD.ShouldDisplayDebug('AI'))
        {
            // End:0x204
            if(Enemy != none)
            {
                Canvas.DrawText(((((" STATE: " $ string(GetStateName())) $ " Timer: ") $ string(GetTimerCount())) $ " Enemy ") $ Enemy.GetHumanReadableName(), false);                
            }
            else
            {
                Canvas.DrawText((((" STATE: " $ string(GetStateName())) $ " Timer: ") $ string(GetTimerCount())) $ " NO Enemy ", false);
            }
            out_YPos += out_YL;
            Canvas.SetPos(4.0000000, out_YPos);
        }
    }
    // End:0x2C5
    if((PlayerCamera != none) && HUD.ShouldDisplayDebug('Camera'))
    {
        PlayerCamera.DisplayDebug(HUD, out_YL, out_YPos);
    }
    //return;    
}

exec function PrintUIStack()
{
    local GameUISceneClient GSC;
    local UIScene S;
    local int I;

    GSC = Class'Engine.UIRoot'.static.GetSceneClient();
    // End:0x7A
    if(GSC != none)
    {
        I = 0;
        // End:0x79
        foreach GSC.AllActiveScenes(Class'Engine.UIScene', S)
        {
            ClientMessage((("UI STACK " $ string(I)) $ ":  ") $ string(S));            
        }        
    }
    //return;    
}

function Reset()
{
    super(PlayerController).Reset();
    //return;    
}

reliable client simulated function ClientReset()
{
    local SkyGameObjective O;

    super(PlayerController).ClientReset();
    // End:0x38
    foreach WorldInfo.AllNavigationPoints(Class'SkyGameObjective', O)
    {
        O.ClientReset();        
    }    
    //return;    
}

exec function SetRadius(float NewRadius)
{
    Pawn.SetCollisionSize(NewRadius, Pawn.GetCollisionHeight());
    //return;    
}

exec function BehindView()
{
    // End:0x2C
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        SetBehindView(!bBehindView);
    }
    //return;    
}

function SetBehindView(bool bNewBehindView)
{
    bBehindView = bNewBehindView;
    // End:0x20
    if(!bBehindView)
    {
        bFreeCamera = false;
    }
    // End:0x43
    if(LocalPlayer(Player) == none)
    {
        ClientSetBehindView(bNewBehindView);        
    }
    else
    {
        // End:0x53
        if(SkyPawnBase(ViewTarget) != none)
        {
        }
    }
    LastCameraTimeStamp = WorldInfo.TimeSeconds - 1.0000000;
    //return;    
}

reliable client simulated function ClientSetBehindView(bool bNewBehindView)
{
    // End:0x20
    if(LocalPlayer(Player) != none)
    {
        SetBehindView(bNewBehindView);
    }
    LastCameraTimeStamp = WorldInfo.TimeSeconds - 1.0000000;
    //return;    
}

function SetCameraMode(name NewCamMode)
{
    bDebugFreeCam = false;
    // End:0x21
    if(PlayerCamera != none)
    {
        super(PlayerController).SetCameraMode(NewCamMode);        
    }
    else
    {
        // End:0x4D
        if(NewCamMode == 'ThirdPerson')
        {
            // End:0x4A
            if(!bBehindView)
            {
                SetBehindView(true);
            }            
        }
        else
        {
            // End:0x8C
            if(NewCamMode == 'FreeCam')
            {
                // End:0x76
                if(!bBehindView)
                {
                    SetBehindView(true);
                }
                bDebugFreeCam = true;
                DebugFreeCamRot = Rotation;                
            }
            else
            {
                // End:0xA0
                if(bBehindView)
                {
                    SetBehindView(false);
                }
            }
        }
    }
    //return;    
}

function SpawnCamera()
{
    local Actor OldViewTarget;

    PlayerCamera = Spawn(MatineeCameraClass, self);
    // End:0x5F
    if(PlayerCamera != none)
    {
        OldViewTarget = ViewTarget;
        PlayerCamera.InitializeFor(self);
        PlayerCamera.SetViewTarget(OldViewTarget);        
    }
    //return;    
}

function bool AllowVoiceMessage(name MessageType)
{
    return true;
    //return ReturnValue;    
}

function DamageShake(int Damage)
{
    local ViewShakeInfo NewViewShake;

    Damage = Min(Damage, 200);
    NewViewShake = BaseDamageShake;
    NewViewShake.RotMag *= float(Damage);
    NewViewShake.RotTime += (0.0050000 * float(Damage));
    NewViewShake.OffsetMag *= float(Damage);
    ShakeView(NewViewShake);
    //return;    
}

function ShakeView(ViewShakeInfo NewViewShake)
{
    local bool bLargerRot, bLargerOffset;

    bLargerRot = VSizeSq(NewViewShake.RotMag) > VSizeSq(CurrentViewShake.RotMag);
    bLargerOffset = VSizeSq(NewViewShake.OffsetMag) > VSizeSq(CurrentViewShake.OffsetMag);
    // End:0xB9
    if(bLargerRot || bLargerOffset)
    {
        // End:0xB6
        if((WorldInfo.TimeSeconds - CurrentViewShake.StartTime) < CurrentViewShake.minTime)
        {
            return;
        }        
    }
    else
    {
        return;
    }
    CurrentViewShake.StartTime = WorldInfo.TimeSeconds;
    CurrentViewShake.minTime = NewViewShake.minTime;
    // End:0x168
    if(bLargerRot)
    {
        CurrentViewShake.RotMag = NewViewShake.RotMag;
        CurrentViewShake.RotRate = NewViewShake.RotRate;
        CurrentViewShake.RotTime = NewViewShake.RotTime;
    }
    // End:0x1D4
    if(bLargerOffset)
    {
        CurrentViewShake.OffsetMag = NewViewShake.OffsetMag;
        CurrentViewShake.OffsetRate = NewViewShake.OffsetRate;
        CurrentViewShake.OffsetTime = NewViewShake.OffsetTime;
    }
    //return;    
}

function OnCameraShake(SkySeqAct_CameraShake ShakeAction)
{
    ShakeView(ShakeAction.CameraShake);
    //return;    
}

function StopViewShaking()
{
    local ViewShakeInfo EmptyViewShake;

    EmptyViewShake.OffsetTime = 0.0000000;
    CurrentViewShake = EmptyViewShake;
    //return;    
}

// Export USkyPlayerControllerBase::execCheckShake(FFrame&, void* const)
native final function CheckShake(out float MaxOffset, out float Offset, out float Rate, float Time);

// Export USkyPlayerControllerBase::execUpdateShakeRotComponent(FFrame&, void* const)
native final function UpdateShakeRotComponent(out float Max, out int Current, out float Rate, float Time, float DeltaTime);

event ViewShake(float DeltaTime)
{
    // End:0x1DF
    if(!IsZero(CurrentViewShake.OffsetRate))
    {
        ShakeOffset.X += (DeltaTime * CurrentViewShake.OffsetRate.X);
        CheckShake(CurrentViewShake.OffsetMag.X, ShakeOffset.X, CurrentViewShake.OffsetRate.X, CurrentViewShake.OffsetTime);
        ShakeOffset.Y += (DeltaTime * CurrentViewShake.OffsetRate.Y);
        CheckShake(CurrentViewShake.OffsetMag.Y, ShakeOffset.Y, CurrentViewShake.OffsetRate.Y, CurrentViewShake.OffsetTime);
        ShakeOffset.Z += (DeltaTime * CurrentViewShake.OffsetRate.Z);
        CheckShake(CurrentViewShake.OffsetMag.Z, ShakeOffset.Z, CurrentViewShake.OffsetRate.Z, CurrentViewShake.OffsetTime);
        CurrentViewShake.OffsetTime -= DeltaTime;
    }
    // End:0x331
    if(!IsZero(CurrentViewShake.RotRate))
    {
        UpdateShakeRotComponent(CurrentViewShake.RotMag.X, ShakeRot.Pitch, CurrentViewShake.RotRate.X, CurrentViewShake.RotTime, DeltaTime);
        UpdateShakeRotComponent(CurrentViewShake.RotMag.Y, ShakeRot.Yaw, CurrentViewShake.RotRate.Y, CurrentViewShake.RotTime, DeltaTime);
        UpdateShakeRotComponent(CurrentViewShake.RotMag.Z, ShakeRot.Roll, CurrentViewShake.RotRate.Z, CurrentViewShake.RotTime, DeltaTime);
        CurrentViewShake.RotTime -= DeltaTime;
    }
    //return;    
}

function CallServerMove(SavedMove NewMove, Vector ClientLoc, byte ClientRoll, int View, SavedMove OldMove)
{
    local Vector BuildAccel;
    local byte OldAccelX, OldAccelY, OldAccelZ;

    // End:0xDE
    if(OldMove != none)
    {
        BuildAccel = (0.0500000 * OldMove.Acceleration) + vect(0.5000000, 0.5000000, 0.5000000);
        OldAccelX = byte(CompressAccel(int(BuildAccel.X)));
        OldAccelY = byte(CompressAccel(int(BuildAccel.Y)));
        OldAccelZ = byte(CompressAccel(int(BuildAccel.Z)));
        OldServerMove(OldMove.TimeStamp, OldAccelX, OldAccelY, OldAccelZ, OldMove.CompressedFlags());
    }
    // End:0x1BD
    if(PendingMove != none)
    {
        DualServerMove(PendingMove.TimeStamp, PendingMove.Acceleration * float(10), PendingMove.CompressedFlags(), ((PendingMove.Rotation.Yaw & 65535) << 16) + (PendingMove.Rotation.Pitch & 65535), NewMove.TimeStamp, NewMove.Acceleration * float(10), ClientLoc, NewMove.CompressedFlags(), ClientRoll, View);        
    }
    else
    {
        // End:0x256
        if((((NewMove.Acceleration * float(10)) == vect(0.0000000, 0.0000000, 0.0000000)) && int(NewMove.DoubleClickMove) == int(0)) && !NewMove.bDoubleJump)
        {
            ShortServerMove(NewMove.TimeStamp, ClientLoc, NewMove.CompressedFlags(), ClientRoll, View);            
        }
        else
        {
            ServerMove(NewMove.TimeStamp, NewMove.Acceleration * float(10), ClientLoc, NewMove.CompressedFlags(), ClientRoll, View);
        }
    }
    //return;    
}

unreliable server function ShortServerMove(float TimeStamp, Vector ClientLoc, byte NewFlags, byte ClientRoll, int View)
{
    ServerMove(TimeStamp, vect(0.0000000, 0.0000000, 0.0000000), ClientLoc, NewFlags, ClientRoll, View);
    //return;    
}

unreliable client simulated function LongClientAdjustPosition(float TimeStamp, name NewState, Actor.EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, Actor NewBase, float NewFloorX, float NewFloorY, float NewFloorZ)
{
    local SkyPawnBase P;

    super(PlayerController).LongClientAdjustPosition(TimeStamp, NewState, newPhysics, NewLocX, NewLocY, NewLocZ, NewVelX, NewVelY, NewVelZ, NewBase, NewFloorX, NewFloorY, NewFloorZ);
    P = SkyPawnBase(Pawn);
    // End:0xC8
    if(((P != none) && P.bFeigningDeath) && int(P.Physics) == int(10))
    {
        P.Mesh.SetRBPosition(P.Mesh.GetPosition());
    }
    //return;    
}

function ViewNextBot()
{
    // End:0x1F
    if(CheatManager != none)
    {
        CheatManager.ViewBot();
    }
    //return;    
}

exec function SwitchWeapon(byte T)
{
    // End:0x2E
    if(SkyPawnBase(Pawn) != none)
    {
        SkyPawnBase(Pawn).SwitchWeapon(T);
    }
    //return;    
}

unreliable server function ServerViewSelf(optional ViewTargetTransitionParams TransitionParam)
{
    local Rotator POVRotation;
    local Vector POVLocation;

    GetPlayerViewPoint(POVLocation, POVRotation);
    SetLocation(POVLocation);
    SetRotation(POVRotation);
    SetBehindView(false);
    SetViewTarget(self);
    //return;    
}

exec function ViewPlayerByName(string PlayerName)
{
    //return;    
}

unreliable server function ServerViewPlayerByName(string PlayerName)
{
    local int I;

    I = 0;
    J0x07:

    // End:0xD5 [Loop If]
    if(I < WorldInfo.GRI.PRIArray.Length)
    {
        // End:0xCB
        if(WorldInfo.GRI.PRIArray[I].PlayerName ~= PlayerName)
        {
            // End:0xC9
            if(WorldInfo.Game.CanSpectate(self, WorldInfo.GRI.PRIArray[I]))
            {
                SetViewTarget(WorldInfo.GRI.PRIArray[I]);
            }
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    ClientMessage(MsgPlayerNotFound);
    //return;    
}

exec function ViewObjective()
{
    ServerViewObjective();
    //return;    
}

unreliable server function ServerViewObjective()
{
    // End:0x3E
    if(SkyGame(WorldInfo.Game) != none)
    {
        SkyGame(WorldInfo.Game).ViewObjective(self);
    }
    //return;    
}

exec function PrevWeapon()
{
    // End:0x3F
    if((Pawn != none) && Vehicle(Pawn) == none)
    {
        // End:0x3F
        if(!Pawn.IsInState('FeigningDeath'))
        {
            super(PlayerController).PrevWeapon();
        }
    }
    //return;    
}

exec function NextWeapon()
{
    // End:0x3F
    if((Pawn != none) && Vehicle(Pawn) == none)
    {
        // End:0x3F
        if(!Pawn.IsInState('FeigningDeath'))
        {
            super(PlayerController).NextWeapon();
        }
    }
    //return;    
}

// Export USkyPlayerControllerBase::execTryExit(FFrame&, void* const)
native exec function TryExit();

exec function CheckController()
{
    //return;    
}

exec event CheckPause(optional bool bFromControllerDisconnect = false)
{
    local DataStoreClient dsc;
    local GameUISceneClient GSC;
    local SkyUIDataStore_FrontEnd ds;
    local Sequence GameSeq;
    local array<SequenceObject> AllInterpActions;
    local SeqAct_Interp It;
    local int CinematicIndex;
    local bool CanPauseYet;
    local SkyHUD mySkyHud;

    // End:0x36
    if(!bFromControllerDisconnect && (Pawn == none) || Pawn.Health <= 0)
    {
        return;
    }
    GSC = Class'Engine.UIRoot'.static.GetSceneClient();
    // End:0x79
    if(GSC != none)
    {
        // End:0x79
        if(GSC.FindSceneByTag('UI_Tech_Credits') != none)
        {
            return;
        }
    }
    dsc = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    // End:0x2F2
    if(dsc != none)
    {
        ds = SkyUIDataStore_FrontEnd(dsc.FindDataStore('SkyFrontEnd'));
        // End:0x2F2
        if(ds != none)
        {
            // End:0x20C
            if(!bFromControllerDisconnect && CinematicModeRefCount > 0)
            {
                // End:0x209
                if(ds.CinePauseMenuScene != none)
                {
                    CanPauseYet = false;
                    GameSeq = WorldInfo.GetGameSequence();
                    // End:0x1CA
                    if(GameSeq != none)
                    {
                        GameSeq.FindSeqObjectsByClass(Class'Engine.SeqAct_Interp', true, AllInterpActions);
                        CinematicIndex = 0;
                        J0x142:

                        // End:0x1CA [Loop If]
                        if(CinematicIndex < AllInterpActions.Length)
                        {
                            It = SeqAct_Interp(AllInterpActions[CinematicIndex]);
                            // End:0x1C0
                            if((It.bIsPlaying && It.bIsSkippable) && It.Position > It.SkipCinematicDelay)
                            {
                                CanPauseYet = true;
                                // [Explicit Break]
                                goto J0x1CA;
                            }
                            ++CinematicIndex;
                            // [Loop Continue]
                            goto J0x142;
                        }
                    }
                    J0x1CA:

                    // End:0x209
                    if(CanPauseYet)
                    {
                        // End:0x209
                        if(GSC != none)
                        {
                            GSC.OpenScene(ds.CinePauseMenuScene, LocalPlayer(Player));
                        }
                    }
                }                
            }
            else
            {
                // End:0x2F2
                if(ds.PauseMenuScene != none)
                {
                    // End:0x2F2
                    if((GSC != none) && GetURLMap() != "mainmenu")
                    {
                        GSC.OpenScene(ds.PauseMenuScene, LocalPlayer(Player));
                        mySkyHud = SkyHUD(myHUD);
                        // End:0x2F2
                        if(mySkyHud != none)
                        {
                            // End:0x2DC
                            if(mySkyHud.LastHelpText == "<Strings:SkyHUD.Labels.JournalFound>")
                            {
                                mySkyHud.SetHelpText(" ", 0.1000000);
                            }
                            mySkyHud.DisplayHudObjective();
                        }
                    }
                }
            }
        }
    }
    //return;    
}

exec function OpenMenu(string Which)
{
    // End:0x10
    if(LocalPlayer(Player) != none)
    {
    }
    //return;    
}

exec function Talk()
{
    local Console Console;

    // End:0x4E
    if(LocalPlayer(Player) != none)
    {
        Console = LocalPlayer(Player).ViewportClient.ViewportConsole;
        Console.StartTyping("Say ");
    }
    //return;    
}

exec function TeamTalk()
{
    local Console Console;

    // End:0x78
    if((LocalPlayer(Player) != none) && LocalPlayer(Player).ViewportClient.ViewportConsole != none)
    {
        Console = LocalPlayer(Player).ViewportClient.ViewportConsole;
        Console.StartTyping("TeamSay ");
    }
    //return;    
}

reliable client simulated function ShowHudMap()
{
    //return;    
}

reliable client simulated function ClientGameEnded(Actor EndGameFocus, bool bIsWinner)
{
    // End:0x18
    if(EndGameFocus == none)
    {
        ServerVerifyViewTarget();        
    }
    else
    {
        SetViewTarget(EndGameFocus);
    }
    SetBehindView(true);
    // End:0x58
    if(!PlayerReplicationInfo.bOnlySpectator)
    {
        PlayWinMessage(bIsWinner);
    }
    ClientEndZoom();
    GotoState('RoundEnded');
    //return;    
}

function RoundHasEnded(optional Actor EndRoundFocus)
{
    ClientRoundEnded(EndRoundFocus);
    SetViewTarget(EndRoundFocus);
    GotoState('RoundEnded');
    //return;    
}

reliable client simulated function ClientRoundEnded(Actor EndRoundFocus)
{
    // End:0x18
    if(EndRoundFocus == none)
    {
        ServerVerifyViewTarget();        
    }
    else
    {
        SetViewTarget(EndRoundFocus);
    }
    SetBehindView(true);
    ClientEndZoom();
    GotoState('RoundEnded');
    //return;    
}

// Export USkyPlayerControllerBase::execCheckBulletWhip(FFrame&, void* const)
native function CheckBulletWhip(SoundCue BulletWhip, Vector FireLocation, Vector FireDir, Vector HitLocation);

function PawnDied(Pawn P)
{
    SkyHUD(myHUD).SetInteraction('None');
    super(PlayerController).PawnDied(P);
    ClientPawnDied();
    //return;    
}

reliable client simulated function ClientPawnDied()
{
    // End:0x31
    if(SkyPlayerInput(PlayerInput) != none)
    {
        SkyPlayerInput(PlayerInput).Outer.bDuck = 0;
    }
    EndZoom();
    //return;    
}

exec function BasePath(byte num)
{
    // End:0x24
    if(PlayerReplicationInfo.Team != none)
    {
        ServerShowPathToBase(num);
    }
    //return;    
}

reliable server function ServerShowPathToBase(byte TeamNum)
{
    // End:0x6D
    if((Pawn != none) && (WorldInfo.TimeSeconds - LastShowPathTime) > 0.5000000)
    {
        LastShowPathTime = WorldInfo.TimeSeconds;
        SkyGame(WorldInfo.Game).ShowPathTo(self, int(TeamNum));
    }
    //return;    
}

exec function WeaponTest()
{
    WeaponInfo(Pawn.Weapon);
    // End:0x33
    if(int(Role) < int(ROLE_Authority))
    {
        ServerWeaponTest();
    }
    //return;    
}

reliable server function ServerWeaponTest()
{
    WorldInfo.Game.KillBots();
    WeaponInfo(Pawn.Weapon);
    //return;    
}

simulated function WeaponInfo(Weapon Weap)
{
    local array<string> DebugInfo;
    local int I;

    // End:0x82
    if(Weap != none)
    {
        Weap.GetWeaponDebug(DebugInfo);
        I = 0;
        J0x2B:

        // End:0x45 [Loop If]
        if(I < DebugInfo.Length)
        {
            I++;
            // [Loop Continue]
            goto J0x2B;
        }
        // End:0x82
        if(SkyWeaponBase(Weap) != none)
        {
            SkyWeaponBase(Weap).bDebugWeapon = !SkyWeaponBase(Weap).bDebugWeapon;
        }
    }
    //return;    
}

exec function FlushDebug()
{
    FlushPersistentDebugLines();
    //return;    
}

exec function VehicleEvent(name EventName)
{
    local SkyGameVehicle V;
    local Vector hl, hn, S, E;
    local Rotator R;
    local Actor ha;
    local int I, J, H;
    local string Str;
    local array<string> EventList;

    GetPlayerViewPoint(S, R);
    E = S + (Vector(R) * float(8096));
    ha = Trace(hl, hn, E, S, true, vect(0.0000000, 0.0000000, 0.0000000));
    // End:0x4C4
    if((ha != none) && SkyGameVehicle(ha) != none)
    {
        V = SkyGameVehicle(ha);
        // End:0x4AB
        if(EventName == 'None')
        {
            I = 0;
            J0xA5:

            // End:0x221 [Loop If]
            if(I < V.VehicleEffects.Length)
            {
                H = 0;
                J0xC6:

                // End:0x16B [Loop If]
                if(H < V.VehicleEffects[I].EffectStartTags.Length)
                {
                    Str = "Effect Start Trigger:" @ string(V.VehicleEffects[I].EffectStartTags[H]);
                    // End:0x161
                    if(EventList.Find(Str) == -1)
                    {
                        EventList[EventList.Length] = Str;
                    }
                    H++;
                    // [Loop Continue]
                    goto J0xC6;
                }
                H = 0;
                J0x172:

                // End:0x217 [Loop If]
                if(H < V.VehicleEffects[I].EffectEndTags.Length)
                {
                    Str = "Effect end Trigger  :" @ string(V.VehicleEffects[I].EffectEndTags[H]);
                    // End:0x20D
                    if(EventList.Find(Str) == -1)
                    {
                        EventList[EventList.Length] = Str;
                    }
                    H++;
                    // [Loop Continue]
                    goto J0x172;
                }
                I++;
                // [Loop Continue]
                goto J0xA5;
            }
            I = 0;
            J0x228:

            // End:0x2B6 [Loop If]
            if(I < V.VehicleAnims.Length)
            {
                Str = "Anim Start Trigger:  " @ string(V.VehicleAnims[I].AnimTag);
                // End:0x2AC
                if(EventList.Find(Str) == -1)
                {
                    EventList[EventList.Length] = Str;
                }
                I++;
                // [Loop Continue]
                goto J0x228;
            }
            I = 0;
            J0x2BD:

            // End:0x487 [Loop If]
            if(I < V.Seats.Length)
            {
                // End:0x47D
                if(V.Seats[I].Gun != none)
                {
                    J = 0;
                    J0x304:

                    // End:0x3BD [Loop If]
                    if(J < V.Seats[I].Gun.FireTriggerTags.Length)
                    {
                        Str = "Fire Tag            :" @ string(V.Seats[I].Gun.FireTriggerTags[J]);
                        // End:0x3B3
                        if(EventList.Find(Str) == -1)
                        {
                            EventList[EventList.Length] = Str;
                        }
                        J++;
                        // [Loop Continue]
                        goto J0x304;
                    }
                    J = 0;
                    J0x3C4:

                    // End:0x47D [Loop If]
                    if(J < V.Seats[I].Gun.AltFireTriggerTags.Length)
                    {
                        Str = "Alt Fire Tag        :" @ string(V.Seats[I].Gun.AltFireTriggerTags[J]);
                        // End:0x473
                        if(EventList.Find(Str) == -1)
                        {
                            EventList[EventList.Length] = Str;
                        }
                        J++;
                        // [Loop Continue]
                        goto J0x3C4;
                    }
                }
                I++;
                // [Loop Continue]
                goto J0x2BD;
            }
            I = 0;
            J0x48E:

            // End:0x4A8 [Loop If]
            if(I < EventList.Length)
            {
                I++;
                // [Loop Continue]
                goto J0x48E;
            }            
        }
        else
        {
            V.VehicleEvent(EventName);
        }
    }
    //return;    
}

function AdjustFOV(float DeltaTime)
{
    local float DeltaFOV;

    // End:0xAE
    if(FOVAngle != DesiredFOV)
    {
        // End:0x3B
        if(bNonlinearZoomInterpolation)
        {
            FOVAngle = FInterpTo(FOVAngle, DesiredFOV, DeltaTime, FOVNonlinearZoomInterpSpeed);            
        }
        else
        {
            // End:0xA3
            if(FOVLinearZoomRate > 0.0000000)
            {
                DeltaFOV = FOVLinearZoomRate * DeltaTime;
                // End:0x87
                if(FOVAngle > DesiredFOV)
                {
                    FOVAngle = FMax(DesiredFOV, FOVAngle - DeltaFOV);                    
                }
                else
                {
                    FOVAngle = FMin(DesiredFOV, FOVAngle + DeltaFOV);
                }                
            }
            else
            {
                FOVAngle = DesiredFOV;
            }
        }
    }
    //return;    
}

simulated function StartZoom(float NewDesiredFOV, float NewZoomRate)
{
    FOVLinearZoomRate = NewZoomRate;
    DesiredFOV = NewDesiredFOV;
    bNonlinearZoomInterpolation = false;
    FOVNonlinearZoomInterpSpeed = 0.0000000;
    //return;    
}

simulated function StartZoomNonlinear(float NewDesiredFOV, float NewZoomInterpSpeed)
{
    DesiredFOV = NewDesiredFOV;
    FOVNonlinearZoomInterpSpeed = NewZoomInterpSpeed;
    bNonlinearZoomInterpolation = true;
    FOVLinearZoomRate = 0.0000000;
    //return;    
}

reliable client simulated function ClientStopZoom()
{
    DesiredFOV = FOVAngle;
    FOVLinearZoomRate = 0.0000000;
    //return;    
}

simulated function EndZoom()
{
    DesiredFOV = DefaultFOV;
    FOVAngle = DefaultFOV;
    FOVLinearZoomRate = 0.0000000;
    FOVNonlinearZoomInterpSpeed = 0.0000000;
    //return;    
}

simulated function EndZoomNonlinear(float ZoomInterpSpeed)
{
    DesiredFOV = DefaultFOV;
    FOVNonlinearZoomInterpSpeed = ZoomInterpSpeed;
    bNonlinearZoomInterpolation = true;
    FOVLinearZoomRate = 0.0000000;
    //return;    
}

reliable client simulated function ClientEndZoom()
{
    EndZoom();
    //return;    
}

event OnlineProfileSettings GetProfileSettings()
{
    local LocalPlayer LP;
    local DataStoreClient DataStoreManager;
    local UIDataStore PlayerDataStore;
    local OnlineProfileSettings Settings;

    Settings = none;
    LP = LocalPlayer(Player);
    // End:0xA1
    if(LP != none)
    {
        DataStoreManager = Class'Engine.UIInteraction'.static.GetDataStoreClient();
        // End:0xA1
        if(DataStoreManager != none)
        {
            PlayerDataStore = DataStoreManager.FindDataStore(Class'Engine.UIDataStore_OnlinePlayerData'.default.Tag, LP);
            // End:0xA1
            if(UIDataStore_OnlinePlayerData(PlayerDataStore) != none)
            {
                Settings = UIDataStore_OnlinePlayerData(PlayerDataStore).ProfileProvider.Profile;
            }
        }
    }
    return Settings;
    //return ReturnValue;    
}

exec event SaveProfileSettings(optional bool forcenow)
{
    local LocalPlayer LP;
    local DataStoreClient DataStoreManager;
    local UIDataStore_OnlinePlayerData PlayerDataStore;

    LP = LocalPlayer(Player);
    // End:0x10A
    if(LP != none)
    {
        DataStoreManager = Class'Engine.UIInteraction'.static.GetDataStoreClient();
        // End:0x10A
        if(DataStoreManager != none)
        {
            PlayerDataStore = UIDataStore_OnlinePlayerData(DataStoreManager.FindDataStore(Class'Engine.UIDataStore_OnlinePlayerData'.default.Tag, LP));
            // End:0x10A
            if(((PlayerDataStore != none) && PlayerDataStore.ProfileProvider != none) && SkyProfileSettings(PlayerDataStore.ProfileProvider.Profile) != none)
            {
                // End:0x10A
                if(SkyProfileSettings(PlayerDataStore.ProfileProvider.Profile).bDirty)
                {
                    // End:0xF7
                    if(forcenow)
                    {
                        CheckForSave(true);                        
                    }
                    else
                    {
                        SetTimer(5.0000000, false, 'CheckForSave');
                    }
                }
            }
        }
    }
    //return;    
}

event CheckForSave(optional bool forcenow)
{
    // End:0x48
    if(forcenow)
    {
        ClearTimer('ProfileSaveCooldown');
        ClearTimer('DoSaveProfile');
        ClearTimer('CheckForSave');
        DoSaveProfile(true);        
    }
    else
    {
        // End:0x8C
        if(IsTimerActive('ProfileSaveCooldown'))
        {
            SetTimer(GetTimerCount('ProfileSaveCooldown'), false, 'DoSaveProfile');
            ClearTimer('ProfileSaveCooldown');            
        }
        else
        {
            // End:0xAC
            if(!IsTimerActive('DoSaveProfile'))
            {
                DoSaveProfile();
            }
        }
    }
    //return;    
}

// Export USkyPlayerControllerBase::execCheckDevice(FFrame&, void* const)
native function bool CheckDevice();

// Export USkyPlayerControllerBase::execCanSaveProfile(FFrame&, void* const)
native final function bool CanSaveProfile();

event DoSaveProfile(optional bool forcenow = false)
{
    local LocalPlayer LP;
    local DataStoreClient DataStoreManager;
    local UIDataStore_OnlinePlayerData PlayerDataStore;
    local SkyUIDataStore_FrontEnd FrontEndStore;
    local GameUISceneClient GSC;

    // End:0x12
    if(!CanSaveProfile())
    {
        return;
    }
    // End:0x60
    if(!forcenow)
    {
        GSC = Class'Engine.UIRoot'.static.GetSceneClient();
        // End:0x60
        if(GSC != none)
        {
            // End:0x60
            if(GSC.FindSceneByTag('UI_Tech_Options') != none)
            {
                return;
            }
        }
    }
    // End:0xA4
    if((SkyHUD(myHUD) != none) && SkyHUD(myHUD).IsAutosaveIconVisible())
    {
        SetTimer(0.5000000, false, 'DoSaveProfile');        
    }
    else
    {
        LP = LocalPlayer(Player);
        // End:0x2BD
        if(LP != none)
        {
            DataStoreManager = Class'Engine.UIInteraction'.static.GetDataStoreClient();
            // End:0x2BD
            if(DataStoreManager != none)
            {
                PlayerDataStore = UIDataStore_OnlinePlayerData(DataStoreManager.FindDataStore(Class'Engine.UIDataStore_OnlinePlayerData'.default.Tag, LP));
                // End:0x2BD
                if((PlayerDataStore != none) && PlayerDataStore.ProfileProvider != none)
                {
                    // End:0x20F
                    if(forcenow)
                    {
                        FrontEndStore = SkyUIDataStore_FrontEnd(DataStoreManager.FindDataStore('SkyFrontEnd'));
                        GSC = Class'Engine.UIRoot'.static.GetSceneClient();
                        // End:0x20F
                        if(((FrontEndStore != none) && FrontEndStore.SavingProfileScene != none) && GSC != none)
                        {
                            // End:0x20F
                            if(GSC.FindSceneIndexByTag('UI_Tech_Pause') == (GSC.GetActiveSceneCount() - 1))
                            {
                                // End:0x20F
                                if(GSC.OpenScene(FrontEndStore.SavingProfileScene, LP, FrontEndStore.OpenSavingProfileScene))
                                {
                                }
                            }
                        }
                    }
                    // End:0x23D
                    if(SkyHUD(myHUD) != none)
                    {
                        SkyHUD(myHUD).ShowProfileSaveIcon(1.0000000);
                    }
                    PlayerDataStore.ProfileProvider.SaveProfileData();
                    // End:0x2AA
                    if(SkyProfileSettings(PlayerDataStore.ProfileProvider.Profile) != none)
                    {
                        SkyProfileSettings(PlayerDataStore.ProfileProvider.Profile).bDirty = false;
                    }
                    SetTimer(300.0000000, false, 'ProfileSaveCooldown');
                }
            }
        }
    }
    //return;    
}

exec function HideProfileSaveScene()
{
    local OnlineProfileSettings Settings;
    local DataStoreClient DataStoreManager;
    local SkyUIDataStore_FrontEnd FrontEndStore;
    local GameUISceneClient GSC;

    Settings = GetProfileSettings();
    // End:0x39
    if((Settings != none) && int(Settings.AsyncState) != int(0))
    {
        return;
    }
    DataStoreManager = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    // End:0xF6
    if(DataStoreManager != none)
    {
        FrontEndStore = SkyUIDataStore_FrontEnd(DataStoreManager.FindDataStore('SkyFrontEnd'));
        GSC = Class'Engine.UIRoot'.static.GetSceneClient();
        // End:0xF6
        if(((FrontEndStore != none) && FrontEndStore.OpenSavingProfileScene != none) && GSC != none)
        {
            GSC.CloseScene(FrontEndStore.OpenSavingProfileScene);
            FrontEndStore.OpenSavingProfileScene = none;
        }
    }
    //return;    
}

event ProfileSaveCooldown()
{
    //return;    
}

exec function UnlockLevel(string levelCode)
{
    local OnlineProfileSettings ops;

    ops = GetProfileSettings();
    // End:0x36
    if(ops != none)
    {
        ops.SetProfileSettingValue(53, levelCode);
    }
    //return;    
}

exec function UnlockAllCheat()
{
    //return;    
}

exec function AddTechPoints(int Points, optional int cacheID = -1)
{
    local int TechPoints;
    local OnlineProfileSettings Settings;
    local int cacheSet, cacheIndex;

    // End:0x2D
    if(Points > 0)
    {
        Class'Engine.SkySeqAct_TrophyBookkeeping'.static.TechPointAcquired(Points);
    }
    Settings = GetProfileSettings();
    // End:0x175
    if(Settings != none)
    {
        TechPoints = 0;
        Settings.GetProfileSettingValueInt(28, TechPoints);
        // End:0xAA
        if((SkyHUD(myHUD) != none) && Points != 0)
        {
            SkyHUD(myHUD).AddTechPoints(Points, TechPoints);
        }
        TechPoints += Points;
        Settings.SetProfileSettingValueInt(28, TechPoints);
        // End:0x16A
        if(cacheID > -1)
        {
            cacheSet = cacheID / 32;
            cacheIndex = cacheID % 32;
            // End:0x16A
            if(cacheSet < 15)
            {
                TechPoints = 0;
                Settings.GetProfileSettingValueInt(29 + cacheSet, TechPoints);
                TechPoints = TechPoints | (1 << cacheIndex);
                Settings.SetProfileSettingValueInt(29 + cacheSet, TechPoints);
            }
        }
        SaveProfileSettings();
    }
    //return;    
}

function int GetTechPointTotal()
{
    local int TechPoints;
    local OnlineProfileSettings Settings;

    TechPoints = 0;
    Settings = GetProfileSettings();
    // End:0x3D
    if(Settings != none)
    {
        Settings.GetProfileSettingValueInt(28, TechPoints);
    }
    return TechPoints;
    //return ReturnValue;    
}

event bool HasTechPointCache(int cacheID)
{
    local OnlineProfileSettings Settings;
    local int cacheSet, cacheIndex;

    Settings = GetProfileSettings();
    // End:0x89
    if(Settings != none)
    {
        // End:0x89
        if(cacheID > -1)
        {
            cacheSet = cacheID / 32;
            cacheIndex = cacheID % 32;
            // End:0x89
            if(cacheSet < 15)
            {
                Settings.GetProfileSettingValueInt(29 + cacheSet, cacheSet);
                return (cacheSet & (1 << cacheIndex)) != 0;
            }
        }
    }
    return false;
    //return ReturnValue;    
}

function string GetOneLetterCode(name WeaponType)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x76 [Loop If]
    if(I < WeaponUpgrades.Upgrades.Length)
    {
        // End:0x6C
        if(WeaponUpgrades.Upgrades[I].WeaponName == WeaponType)
        {
            return WeaponUpgrades.Upgrades[I].WeaponIdentifier;
        }
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    return "";
    //return ReturnValue;    
}

function UpgradeInventory()
{
    local Weapon BackWeapon, FrontWeapon;

    // End:0x14E
    if((SkyPawn(Pawn) != none) && Pawn.InvManager != none)
    {
        BackWeapon = SkyPawn(Pawn).BackWeapon;
        FrontWeapon = SkyPawn(Pawn).Weapon;
        Pawn.InvManager.RemoveFromInventory(BackWeapon);
        Pawn.InvManager.AddInventory(BackWeapon);
        Pawn.InvManager.RemoveFromInventory(FrontWeapon);
        Pawn.InvManager.AddInventory(FrontWeapon);
        Pawn.InvManager.RemoveFromInventory(SkyPawn(Pawn).RocketPack);
        Pawn.InvManager.AddInventory(SkyPawn(Pawn).RocketPack);
    }
    //return;    
}

exec function SetUpgradeLevel(name WeaponType, int Level)
{
    local OnlineProfileSettings Settings;
    local string encodedUpgrades;
    local int Idx;
    local string oneLetterCode;

    Settings = GetProfileSettings();
    // End:0x186
    if(Settings != none)
    {
        // End:0x56
        if(WeaponType == 'Radar')
        {
            Settings.SetProfileSettingValueInt(67, Level);
            SaveProfileSettings();
            return;
        }
        oneLetterCode = GetOneLetterCode(WeaponType);
        // End:0x79
        if(oneLetterCode == "")
        {
            return;
        }
        Settings.GetProfileSettingValueByName('Upgrades Purchased', encodedUpgrades);
        Idx = InStr(encodedUpgrades, oneLetterCode);
        // End:0xE7
        if(Idx == -1)
        {
            Idx = Len(encodedUpgrades) + 1;            
            encodedUpgrades $= (oneLetterCode $ "0");            
        }
        else
        {
            ++Idx;
        }
        // End:0x12B
        if(Level < 0)
        {
            encodedUpgrades = Left(encodedUpgrades, Idx - 1) $ Right(encodedUpgrades, (Len(encodedUpgrades) - Idx) - 1);            
        }
        else
        {
            encodedUpgrades = (Left(encodedUpgrades, Idx) $ Chr(Level + 48)) $ Right(encodedUpgrades, (Len(encodedUpgrades) - Idx) - 1);
        }
        Settings.SetProfileSettingValueByName('Upgrades Purchased', encodedUpgrades);
    }
    SaveProfileSettings();
    UpgradeInventory();
    //return;    
}

exec event bool BuyUpgrade(optional name WeaponType = 'Current')
{
    local OnlineProfileSettings Settings;
    local string encodedUpgrades;
    local int Idx;
    local string oneLetterCode;
    local int upgradeValue, oldLevel;
    local SkyPawn_MaxValenti SkyPlayer;

    // End:0x60
    if(WeaponType == 'Current')
    {
        WeaponType = WeaponUpgrades.Upgrades[WeaponUpgrades.UpgradeIndices[WeaponUpgrades.CurIndex]].WeaponName;
    }
    upgradeValue = NextUpgradeCost(WeaponType);
    oldLevel = -1;
    // End:0x8D
    if(upgradeValue < 0)
    {
        return false;
    }
    // End:0xA3
    if((GetTechPointTotal()) < upgradeValue)
    {
        return false;
    }
    AddTechPoints(-upgradeValue);
    oneLetterCode = GetOneLetterCode(WeaponType);
    // End:0xD8
    if(oneLetterCode == "")
    {
        return false;
    }
    Settings = GetProfileSettings();
    // End:0x1F9
    if(Settings != none)
    {
        Settings.GetProfileSettingValueByName('Upgrades Purchased', encodedUpgrades);
        Idx = InStr(encodedUpgrades, oneLetterCode);
        // End:0x16C
        if(Idx == -1)
        {
            upgradeValue = -1;
            Idx = Len(encodedUpgrades) + 1;            
            encodedUpgrades $= (oneLetterCode $ "0");            
        }
        else
        {
            ++Idx;
            upgradeValue = Asc(Mid(encodedUpgrades, Idx, 1)) - 48;
        }
        oldLevel = upgradeValue;
        ++upgradeValue;
        encodedUpgrades = (Left(encodedUpgrades, Idx) $ Chr(upgradeValue + 48)) $ Right(encodedUpgrades, (Len(encodedUpgrades) - Idx) - 1);
        Settings.SetProfileSettingValueByName('Upgrades Purchased', encodedUpgrades);
    }
    SaveProfileSettings();
    // End:0x23F
    if(oldLevel >= 0)
    {
        UpgradeInventory();
        Class'Engine.SkySeqAct_TrophyBookkeeping'.static.WeaponUpgraded(string(WeaponType), upgradeValue, bUsingXpacWeaponUpgrades);
    }
    UpdateWeaponSystem();
    SkyPlayer = SkyPawn_MaxValenti(Pawn);
    // End:0x275
    if(SkyPlayer != none)
    {
        SkyPlayer.TechPointsSinceLastCheckpoint = 0;
    }
    return true;
    //return ReturnValue;    
}

function int NextUpgradeCost(name WeaponType)
{
    local int Level;

    Level = GetUpgradeLevel(WeaponType);
    // End:0x42
    if(WeaponUpgrades != none)
    {
        return WeaponUpgrades.GetUpgradeCost(WeaponType, Level + 1);
    }
    return -1;
    //return ReturnValue;    
}

event int GetUpgradeLevel(name WeaponType)
{
    local OnlineProfileSettings Settings;
    local string encodedUpgrades;
    local int Idx;
    local string oneLetterCode;

    oneLetterCode = GetOneLetterCode(WeaponType);
    // End:0x27
    if(oneLetterCode == "")
    {
        return -1;
    }
    Settings = GetProfileSettings();
    // End:0xAA
    if(Settings != none)
    {
        Settings.GetProfileSettingValueByName('Upgrades Purchased', encodedUpgrades);
        Idx = InStr(encodedUpgrades, oneLetterCode);
        // End:0x8F
        if(Idx == -1)
        {
            return -1;            
        }
        else
        {
            ++Idx;
            return Asc(Mid(encodedUpgrades, Idx, 1)) - 48;
        }
    }
    return -1;
    //return ReturnValue;    
}

event int GetAvailableWeaponCount()
{
    local OnlineProfileSettings Settings;
    local string encodedUpgrades;

    Settings = GetProfileSettings();
    // End:0x49
    if(Settings != none)
    {
        Settings.GetProfileSettingValueByName('Upgrades Purchased', encodedUpgrades);
        return Len(encodedUpgrades) / 2;
    }
    return 0;
    //return ReturnValue;    
}

function bool FoundBlueprint(int printId, name WeaponType)
{
    local OnlineProfileSettings Settings;
    local string encodedBlueprints;
    local int Idx;
    local string oneLetterCode;
    local int foundBitField;

    // End:0x0E
    if(printId > 7)
    {
        return false;
    }
    oneLetterCode = GetOneLetterCode(WeaponType);
    // End:0x31
    if(oneLetterCode == "")
    {
        return false;
    }
    Settings = GetProfileSettings();
    // End:0x165
    if(Settings != none)
    {
        Settings.GetProfileSettingValueByName('Blueprints Found', encodedBlueprints);
        Idx = InStr(encodedBlueprints, oneLetterCode);
        // End:0xC8
        if(Idx == -1)
        {
            foundBitField = 1 << printId;
            Idx = Len(encodedBlueprints) + 1;            
            encodedBlueprints $= (oneLetterCode $ "A");            
        }
        else
        {
            ++Idx;
            foundBitField = Asc(Mid(encodedBlueprints, Idx, 1)) - 65;
        }
        foundBitField = foundBitField | (1 << printId);
        encodedBlueprints = (Left(encodedBlueprints, Idx) $ Chr(foundBitField + 48)) $ Right(encodedBlueprints, (Len(encodedBlueprints) - Idx) - 1);
        Settings.SetProfileSettingValueByName('Blueprints Found', encodedBlueprints);
        SaveProfileSettings();
        return true;
    }
    return false;
    //return ReturnValue;    
}

event bool HasBlueprint(int printId, name WeaponType)
{
    local OnlineProfileSettings Settings;
    local string encodedBlueprints;
    local int Idx;
    local string oneLetterCode;
    local int foundBitField;

    // End:0x0E
    if(printId > 7)
    {
        return false;
    }
    oneLetterCode = GetOneLetterCode(WeaponType);
    // End:0x31
    if(oneLetterCode == "")
    {
        return false;
    }
    Settings = GetProfileSettings();
    // End:0xC8
    if(Settings != none)
    {
        Settings.GetProfileSettingValueByName('Blueprints Found', encodedBlueprints);
        Idx = InStr(encodedBlueprints, oneLetterCode);
        // End:0x95
        if(Idx == -1)
        {
            return false;            
        }
        else
        {
            ++Idx;
            foundBitField = Asc(Mid(encodedBlueprints, Idx, 1)) - 65;
        }
        return (foundBitField & (1 << printId)) != 0;
    }
    return false;
    //return ReturnValue;    
}

event bool HasJournalEntry(int journalId)
{
    local OnlineProfileSettings Settings;
    local int journalSet, journalIdx;

    // End:0x1B
    if((journalId < 0) || journalId > 127)
    {
        return false;
    }
    journalSet = journalId / 32;
    journalIdx = journalId % 32;
    Settings = GetProfileSettings();
    // End:0x89
    if(Settings != none)
    {
        Settings.GetProfileSettingValueInt(45 + journalSet, journalSet);
        return (journalSet & (1 << journalIdx)) != 0;
    }
    return false;
    //return ReturnValue;    
}

exec function TestJournals()
{
    FoundJournalEntry(0);
    FoundJournalEntry(1);
    FoundJournalEntry(2);
    FoundJournalEntry(3);
    FoundJournalEntry(4);
    FoundJournalEntry(5);
    FoundJournalEntry(6);
    FoundJournalEntry(10);
    FoundJournalEntry(11);
    FoundJournalEntry(12);
    FoundJournalEntry(20);
    FoundJournalEntry(21);
    FoundJournalEntry(22);
    FoundJournalEntry(23);
    FoundJournalEntry(24);
    FoundJournalEntry(25);
    FoundJournalEntry(26);
    FoundJournalEntry(30);
    FoundJournalEntry(31);
    FoundJournalEntry(32);
    FoundJournalEntry(33);
    FoundJournalEntry(34);
    FoundJournalEntry(35);
    FoundJournalEntry(36);
    FoundJournalEntry(40);
    FoundJournalEntry(41);
    FoundJournalEntry(42);
    FoundJournalEntry(43);
    FoundJournalEntry(44);
    FoundJournalEntry(45);
    FoundJournalEntry(50);
    FoundJournalEntry(51);
    FoundJournalEntry(52);
    FoundJournalEntry(53);
    FoundJournalEntry(54);
    FoundJournalEntry(55);
    FoundJournalEntry(56);
    FoundJournalEntry(60);
    FoundJournalEntry(61);
    FoundJournalEntry(62);
    FoundJournalEntry(63);
    FoundJournalEntry(64);
    FoundJournalEntry(65);
    FoundJournalEntry(66);
    FoundJournalEntry(70);
    FoundJournalEntry(71);
    FoundJournalEntry(72);
    FoundJournalEntry(80);
    FoundJournalEntry(81);
    FoundJournalEntry(82);
    FoundJournalEntry(83);
    FoundJournalEntry(90);
    FoundJournalEntry(91);
    FoundJournalEntry(100);
    FoundJournalEntry(110);
    FoundJournalEntry(111);
    FoundJournalEntry(112);
    //return;    
}

exec function FoundJournalEntry(int journalId)
{
    local OnlineProfileSettings Settings;
    local int journalSet, journalIdx, bitMap;

    // End:0x1B
    if((journalId < 0) || journalId > 127)
    {
        return;
    }
    Class'SkyHUD'.static.OpenPickupTutorial('Journal', SkyPlayerController(self));
    journalSet = journalId / 32;
    journalIdx = journalId % 32;
    Settings = GetProfileSettings();
    // End:0x13B
    if(Settings != none)
    {
        Settings.GetProfileSettingValueInt(45 + journalSet, bitMap);
        // End:0xB0
        if((bitMap & (1 << journalIdx)) != 0)
        {
            return;
        }
        bitMap = bitMap | (1 << journalIdx);
        Settings.SetProfileSettingValueInt(45 + journalSet, bitMap);
        // End:0x13B
        if(SkyHUD(myHUD) != none)
        {
            SkyHUD(myHUD).SetHelpText("<Strings:SkyHUD.Labels.JournalFound>", 5.0000000);
        }
    }
    SaveProfileSettings();
    Class'Engine.SkySeqAct_TrophyBookkeeping'.static.FoundDiary(GetJournalEntryCount());
    // End:0x1D1
    if((SkyPawn(Pawn) != none) && SkyPawnSoundGroup(SkyPawn(Pawn).SoundGroup) != none)
    {
        SkyPawn(Pawn).PlayVoiceOver(SkyPawnSoundGroup(SkyPawn(Pawn).SoundGroup).VO_FoundJournalEntry);
    }
    // End:0x21C
    if((SkyHUD(myHUD) != none) && SkyHUD(myHUD).JournalPickupSoundEffect != none)
    {
        PlaySound(SkyHUD(myHUD).JournalPickupSoundEffect, true);
    }
    //return;    
}

event int GetJournalEntryCount()
{
    local OnlineProfileSettings Settings;
    local int journalSet, journalIdx, bitField, Count;

    Count = 0;
    Settings = GetProfileSettings();
    // End:0x9A
    if(Settings != none)
    {
        journalSet = 0;
        J0x29:

        // End:0x9A [Loop If]
        if(journalSet < 4)
        {
            Settings.GetProfileSettingValueInt(45 + journalSet, bitField);
            journalIdx = 0;
            J0x5E:

            // End:0x90 [Loop If]
            if(journalIdx < 32)
            {
                // End:0x86
                if((bitField & (1 << journalIdx)) != 0)
                {
                    ++Count;
                }
                ++journalIdx;
                // [Loop Continue]
                goto J0x5E;
            }
            ++journalSet;
            // [Loop Continue]
            goto J0x29;
        }
    }
    return Count;
    //return ReturnValue;    
}

event GetFoundJournalIndices(out array<int> Indices)
{
    local OnlineProfileSettings Settings;
    local int journalSet, journalIdx, bitField;

    Settings = GetProfileSettings();
    // End:0xA4
    if(Settings != none)
    {
        journalSet = 0;
        J0x22:

        // End:0xA4 [Loop If]
        if(journalSet < 4)
        {
            Settings.GetProfileSettingValueInt(45 + journalSet, bitField);
            journalIdx = 0;
            J0x57:

            // End:0x9A [Loop If]
            if(journalIdx < 32)
            {
                // End:0x90
                if((bitField & (1 << journalIdx)) != 0)
                {
                    Indices.AddItem(journalIdx + (journalSet * 32));
                }
                ++journalIdx;
                // [Loop Continue]
                goto J0x57;
            }
            ++journalSet;
            // [Loop Continue]
            goto J0x22;
        }
    }
    //return;    
}

event bool HasSecret(int secretId)
{
    local OnlineProfileSettings Settings;
    local int secretSet, secretIdx;

    // End:0x1B
    if((secretId < 0) || secretId > 31)
    {
        return false;
    }
    secretSet = secretId / 32;
    secretIdx = secretId % 32;
    Settings = GetProfileSettings();
    // End:0x8D
    if(Settings != none)
    {
        // End:0x8D
        if(secretSet == 0)
        {
            Settings.GetProfileSettingValueInt(44, secretSet);
            return (secretSet & (1 << secretIdx)) != 0;
        }
    }
    return false;
    //return ReturnValue;    
}

exec function ToggleSecret(int secretId)
{
    local OnlineProfileSettings Settings;
    local int secretSet, secretIdx;

    // End:0x1B
    if((secretId < 0) || secretId > 31)
    {
        return;
    }
    secretSet = secretId / 32;
    secretIdx = secretId % 32;
    Settings = GetProfileSettings();
    // End:0xAA
    if(Settings != none)
    {
        // End:0xAA
        if(secretSet == 0)
        {
            Settings.GetProfileSettingValueInt(44, secretSet);
            secretSet = secretSet ^ (1 << secretIdx);
            Settings.SetProfileSettingValueInt(44, secretSet);
        }
    }
    SaveProfileSettings();
    //return;    
}

exec function UIWeaponUpgradeNext()
{
    WeaponUpgrades.SetCurrentIndex(WeaponUpgrades.GetCurrentIndex() + 1);
    UpdateWeaponSystem();
    //return;    
}

exec function UIWeaponUpgradePrev()
{
    WeaponUpgrades.SetCurrentIndex(WeaponUpgrades.GetCurrentIndex() - 1);
    UpdateWeaponSystem();
    //return;    
}

exec function UIWeaponUpgradeCurrent()
{
    WeaponUpgrades.SetCurrentIndex(WeaponUpgrades.GetIndexOfCurrentWeapon(SkyPawn(Pawn)));
    UpdateWeaponSystem();
    //return;    
}

exec event UIWeaponUpgradeSelect(int Idx)
{
    WeaponUpgrades.SetCurrentIndex(Idx);
    UpdateWeaponSystem();
    //return;    
}

function UpdateWeaponSystem()
{
    local DataStoreClient dsc;
    local SkyWeaponUpgradeDataStore ds;

    dsc = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    // End:0x65
    if(dsc != none)
    {
        ds = SkyWeaponUpgradeDataStore(dsc.FindDataStore('SkyWeaponUpgrade'));
        // End:0x65
        if(ds != none)
        {
            ds.UpdateWeaponSystem();
        }
    }
    //return;    
}

exec event UnlockAchievement(int AchievementId)
{
    local LocalPlayer LP;

    LP = LocalPlayer(Player);
    // End:0x1D
    if(LP == none)
    {
        return;
    }
    // End:0x42
    if(!UnlockAchievementPlatform(LP.ControllerId, AchievementId))
    {
        return;
    }
    SaveProfileSettings(true);
    //return;    
}

// Export USkyPlayerControllerBase::execUnlockAchievementPlatform(FFrame&, void* const)
native function bool UnlockAchievementPlatform(int ControllerId, int AchievementId);

// Export USkyPlayerControllerBase::execReadCustomControllerProfile(FFrame&, void* const)
native function ReadCustomControllerProfile();

// Export USkyPlayerControllerBase::execSettingsLoadedCallback(FFrame&, void* const)
native function SettingsLoadedCallback();

// Export USkyPlayerControllerBase::execInstallUltraPack(FFrame&, void* const)
native function InstallUltraPack();

event bool UsingUltraPack()
{
    return ((SkyGame(WorldInfo.Game) != none) && SkyGame(WorldInfo.Game).bUltraPackInstalled) && HasSecret(0);
    //return ReturnValue;    
}

exec function ToggleUltraPack()
{
    InstallUltraPack();
    ToggleSecret(0);
    //return;    
}

function OnReadContentComplete(bool bWasSuccessful)
{
    local OnlineSubsystem os;
    local array<OnlineContent> List;
    local int I;
    local GameUISceneClient GSC;
    local array<UIPopUpChildParameter> Params;
    local UIPopUpChildParameter Param;

    os = GetOnlineSubsystem();
    // End:0x295
    if((os != none) && NotEqual_InterfaceInterface(os.ContentInterface, OnlineContentInterface(none)))
    {
        GSC = Class'Engine.UIRoot'.static.GetSceneClient();
        // End:0x295
        if(GSC != none)
        {
            os.ContentInterface.GetContentList(byte(LocalPlayer(Player).ControllerId), List);
            I = 0;
            J0x99:

            // End:0x295 [Loop If]
            if(I < List.Length)
            {
                // End:0x28B
                if((List[I].ContentPackages.Length == 0) && List[I].ContentFiles.Length == 0)
                {
                    Param.childName = 'lblTitle';
                    Param.childString = "<Strings:SkyUI.Labels.CorruptDownloadTitle>";
                    Params.AddItem(Param);
                    Param.childName = 'lblMessage';
                    Param.childString = ("<Strings:SkyUI.Labels.CorruptDownloadMessage1>" $ List[I].FriendlyName) $ "<Strings:SkyUI.Labels.CorruptDownloadMessage2>";
                    Params.AddItem(Param);
                    Param.childName = 'btnOk';
                    Param.childString = "<Strings:SkyUI.Buttons.Ok>";
                    Params.AddItem(Param);
                    GSC.MessageBoxOpenByPathAndParameters("UI.DefaultNotifyScene_single", Params);
                }
                ++I;
                // [Loop Continue]
                goto J0x99;
            }
        }
    }
    // End:0x2BE
    if(SkyPlayerInput(PlayerInput) != none)
    {
        SkyPlayerInput(PlayerInput).ConstructLayouts();
    }
    SettingsLoadedCallback();
    SkyGame(WorldInfo.Game).CheckForUltraPack();
    //return;    
}

function OnIsSaving(SkySeqAct_IsSaving Action)
{
    local SkyHUD H;
    local DataStoreClient dsc;
    local SkyUIDataStore_FrontEnd FrontEndStore;

    H = SkyHUD(myHUD);
    dsc = Class'Engine.UIInteraction'.static.GetDataStoreClient();
    // End:0x56
    if(dsc != none)
    {
        FrontEndStore = SkyUIDataStore_FrontEnd(dsc.FindDataStore('SkyFrontEnd'));
    }
    // End:0x11C
    if(H != none)
    {
        // End:0x10B
        if((((H.AutosaveIcon == none) || H.AutosaveIcon.IsVisible(true) == false) && (H.ProfileSaveIcon == none) || H.ProfileSaveIcon.IsVisible(true) == false) && (FrontEndStore == none) || FrontEndStore.OpenSavingProfileScene == none)
        {
            Action.ActivateOutputLink(1);            
        }
        else
        {
            Action.ActivateOutputLink(0);
        }
    }
    //return;    
}

protected simulated function RegisterCustomPlayerDataStores()
{
    local SkyProfileSettings Settings;
    local GameUISceneClient GSC;
    local array<UIPopUpChildParameter> Params;
    local UIPopUpChildParameter Param;
    local OnlineSubsystem Online;

    // End:0x76
    if(WorldInfo.IsConsoleBuild(1))
    {
        Online = GetOnlineSubsystem();
        // End:0x73
        if(NotEqual_InterfaceInterface(OnlineContentInterface(Online), OnlineContentInterface(none)))
        {
            OnlineContentInterface(Online).AddReadContentComplete(byte(LocalPlayer(Player).ControllerId), OnReadContentComplete);
        }        
    }
    else
    {
        SkyGame(WorldInfo.Game).CheckForUltraPack();
    }
    super(PlayerController).RegisterCustomPlayerDataStores();
    // End:0x26F
    if(WorldInfo.IsConsoleBuild(2))
    {
        Settings = SkyProfileSettings(GetProfileSettings());
        // End:0x26F
        if((Settings != none) && Settings.bReadFailed)
        {
            Settings.bReadFailed = false;
            GSC = Class'Engine.UIRoot'.static.GetSceneClient();
            // End:0x26F
            if(GSC != none)
            {
                Param.childName = 'lblTitle';
                Param.childString = "<Strings:SkyUI.Labels.ProfileFailTitle>";
                Params.AddItem(Param);
                Param.childName = 'lblMessage';
                Param.childString = "<Strings:SkyUI.Labels.LoadFailMessagePS3>";
                Params.AddItem(Param);
                Param.childName = 'btnOk';
                Param.childString = "<Strings:SkyUI.Buttons.Ok>";
                Params.AddItem(Param);
                GSC.MessageBoxOpenByPathAndParameters("UI.DefaultNotifyScene_single", Params);
            }
        }
    }
    // End:0x290
    if(!WorldInfo.IsConsoleBuild(1))
    {
        SettingsLoadedCallback();
    }
    // End:0x2DA
    if(SkyPlayerInput(PlayerInput) != none)
    {
        SkyPlayerInput(PlayerInput).ConstructLayouts();
        SkyPlayerInput(PlayerInput).SetLayout("OnFoot");
    }
    ReadCustomControllerProfile();
    //return;    
}

// Export USkyPlayerControllerBase::execControllerDisconnected(FFrame&, void* const)
native function ControllerDisconnected(int ControllerId);

// Export USkyPlayerControllerBase::execControllerReconnected(FFrame&, void* const)
native function ControllerReconnected(int ControllerId);

// Export USkyPlayerControllerBase::execClientSetOnlineStatus(FFrame&, void* const)
reliable client native simulated function ClientSetOnlineStatus();

// Export USkyPlayerControllerBase::execXeSetRichPresence(FFrame&, void* const)
native exec function XeSetRichPresence(int Id);

exec function ToggleTrophyLog()
{
    Class'Engine.SkySeqAct_TrophyBookkeeping'.static.ToggleLog();
    //return;    
}

exec function TrophyCompleteLevel(optional int iLevel = -1)
{
    Class'Engine.SkySeqAct_TrophyBookkeeping'.static.ForceLevelCompleted(iLevel);
    //return;    
}

exec function ToggleCheckpointLog()
{
    Class'Engine.CheckpointManager'.static.ToggleCheckpointLog();
    //return;    
}

exec function CheckTrophyBookkeeper()
{
    //return;    
}

function OnSetHelpText(SkySeqAct_SetHelpText Action)
{
    // End:0x47
    if(SkyHUD(myHUD) != none)
    {
        SkyHUD(myHUD).SetHelpText(Action.HelpText, Action.Timer);
    }
    //return;    
}

reliable client simulated event ClientCommitMapChange()
{
    super(PlayerController).ClientCommitMapChange();
    ClientSetOnlineStatus();
    //return;    
}

// Export USkyPlayerControllerBase::execCheckForStreamedBaseLevel(FFrame&, void* const)
native function string CheckForStreamedBaseLevel();

// Export USkyPlayerControllerBase::execRestartLevelNative(FFrame&, void* const)
native function RestartLevelNative();

exec function RestartLevel()
{
    RestartLevelNative();
    //return;    
}

exec function DisablePendingInventory()
{
    // End:0x1D
    if(WeaponUpgrades != none)
    {
        WeaponUpgrades.bDoNotGiveLoadout = true;
    }
    //return;    
}

exec function EnablePendingInventory()
{
    // End:0x1D
    if(WeaponUpgrades != none)
    {
        WeaponUpgrades.bDoNotGiveLoadout = false;
    }
    //return;    
}

exec function DisableSaving()
{
    local OnlineSubsystem os;

    os = GetOnlineSubsystem();
    // End:0x29
    if(os != none)
    {
        os.bSavingDisabled = true;
    }
    //return;    
}

exec function EnableSaving()
{
    local OnlineSubsystem os;

    os = GetOnlineSubsystem();
    // End:0x29
    if(os != none)
    {
        os.bSavingDisabled = false;
    }
    //return;    
}

exec function PauseFramerate()
{
    Pause();
    //return;    
}

state PlayerWalking
{
    event bool NotifyLanded(Vector HitNormal, Actor FloorActor)
    {
        // End:0x25
        if(int(DoubleClickDir) == int(5))
        {
            DoubleClickDir = 6;
            ClearDoubleClick();            
        }
        else
        {
            DoubleClickDir = 0;
        }
        // End:0x46
        if(global.NotifyLanded(HitNormal, FloorActor))
        {
            return true;
        }
        return false;
        //return ReturnValue;        
    }

    function ProcessMove(float DeltaTime, Vector newAccel, Actor.EDoubleClickDir DoubleClickMove, Rotator DeltaRot)
    {
        // End:0x13
        if(!bEnableDodging)
        {
            DoubleClickMove = 0;
        }
        // End:0x47
        if((int(DoubleClickMove) == int(5)) && int(Pawn.Physics) == int(2))
        {
            DoubleClickDir = 5;
        }
        super.ProcessMove(DeltaTime, newAccel, DoubleClickMove, DeltaRot);
        //return;        
    }

    function PlayerMove(float DeltaTime)
    {
        GroundPitch = 0;
        super.PlayerMove(DeltaTime);
        //return;        
    }
    stop;    
}

state RoundEnded
{
    ignores KilledBy, TakeDamage, Suicide, PrevWeapon, NextWeapon, SwitchWeapon;

    function FindGoodView()
    {
        local Vector cameraLoc;
        local Rotator cameraRot, ViewRotation;
        local int tries, besttry;
        local float bestDist, newdist;
        local int startYaw;

        ViewRotation = Rotation;
        ViewRotation.Pitch = 56000;
        tries = 0;
        besttry = 0;
        bestDist = 0.0000000;
        startYaw = ViewRotation.Yaw;
        tries = 0;
        J0x57:

        // End:0xFF [Loop If]
        if(tries < 16)
        {
            CalcViewActor = none;
            cameraLoc = ViewTarget.Location;
            SetRotation(ViewRotation);
            GetPlayerViewPoint(cameraLoc, cameraRot);
            newdist = VSize(cameraLoc - ViewTarget.Location);
            // End:0xDE
            if(newdist > bestDist)
            {
                bestDist = newdist;
                besttry = tries;
            }
            ViewRotation.Yaw += 4096;
            tries++;
            // [Loop Continue]
            goto J0x57;
        }
        ViewRotation.Yaw = startYaw + (besttry * 4096);
        SetRotation(ViewRotation);
        //return;        
    }

    unreliable client simulated function LongClientAdjustPosition(float TimeStamp, name NewState, Actor.EPhysics newPhysics, float NewLocX, float NewLocY, float NewLocZ, float NewVelX, float NewVelY, float NewVelZ, Actor NewBase, float NewFloorX, float NewFloorY, float NewFloorZ)
    {
        // End:0x1D
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
        // End:0xD0
        if(int(Role) < int(ROLE_Authority))
        {
            ReplicateMove(DeltaTime, vect(0.0000000, 0.0000000, 0.0000000), 0, rot(0, 0, 0));
        }
        bPressedJump = false;
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        // End:0x28
        if(myHUD != none)
        {
            myHUD.bShowScores = true;
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        // End:0x1D
        if(myHUD != none)
        {
            myHUD.bShowScores = false;
        }
        super.EndState(NextStateName);
        SetBehindView(false);
        StopViewShaking();
        //return;        
    }
    stop;    
}

state Dead
{
    ignores KilledBy, NextWeapon, PrevWeapon, SwitchWeapon, FindGoodView;

    exec function StartFire(optional byte FireModeNum)
    {
        // End:0x35
        if(bFrozen)
        {
            // End:0x33
            if(!IsTimerActive() || GetTimerCount() > 1.0000000)
            {
                bFrozen = false;
            }
            return;
        }
        // End:0x55
        if(PlayerReplicationInfo.bOutOfLives)
        {
            ServerSpectate();            
        }
        else
        {
            super.StartFire(FireModeNum);
        }
        //return;        
    }

    function Timer()
    {
        // End:0x0D
        if(!bFrozen)
        {
            return;
        }
        // End:0x54
        if((int(WorldInfo.NetMode) == int(NM_Client)) || int(WorldInfo.NetMode) == int(NM_Standalone))
        {
            WorldInfo.ForceGarbageCollection();
        }
        bFrozen = false;
        bUsePhysicsRotation = false;
        bPressedJump = false;
        //return;        
    }

    reliable client simulated event ClientSetViewTarget(Actor A, optional ViewTargetTransitionParams TransitionParams)
    {
        // End:0x18
        if(A == none)
        {
            ServerVerifyViewTarget();
            return;
        }
        // End:0x25
        if(A == self)
        {
            return;
        }
        SetViewTarget(A, TransitionParams);
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        // End:0x1B
        if(Pawn(ViewTarget) != none)
        {
            SetBehindView(true);
        }
        super.BeginState(PreviousStateName);
        //return;        
    }

    function EndState(name NextStateName)
    {
        bUsePhysicsRotation = false;
        super.EndState(NextStateName);
        SetBehindView(false);
        StopViewShaking();
        //return;        
    }
Begin:

    Sleep(3.0000000);
    // End:0x65
    if(((ViewTarget == none) || ViewTarget == self) || VSize(ViewTarget.Velocity) < 1.0000000)
    {
        Sleep(1.0000000);
        // End:0x62
        if(myHUD != none)
        {
            myHUD.bShowScores = true;
        }        
    }
    else
    {
        goto 'Begin';
    }
    stop;                    
}

auto state PlayerWaiting
{
    exec function StartFire(optional byte FireModeNum)
    {
        ServerRestartPlayer();
        //return;        
    }

    reliable server function ServerRestartPlayer()
    {
        super.ServerRestartPlayer();
        // End:0x92
        if((WorldInfo.Game.bWaitingToStartMatch && SkyGame(WorldInfo.Game).bWarmupRound) && float(SkyGame(WorldInfo.Game).WarmupTime) > 1.0000000)
        {
            WorldInfo.Game.RestartPlayer(self);
        }
        //return;        
    }
    stop;    
}

state BaseSpectating
{
    simulated event GetPlayerViewPoint(out Vector out_Location, out Rotator out_Rotation)
    {
        // End:0x24
        if(PlayerCamera == none)
        {
            out_Location = Location;
            out_Rotation = BlendedTargetViewRotation;            
        }
        else
        {
            super(PlayerController).GetPlayerViewPoint(out_Location, out_Rotation);
        }
        //return;        
    }
    stop;    
}

state Spectating
{
    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        // End:0x5C
        if((SkyGame(WorldInfo.Game) != none) && SkyGame(WorldInfo.Game).bAutomatedPerfTesting)
        {
            SetTimer(3.0000000, true, 'ServerViewNextPlayer');
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        ClearTimer('ServerViewNextPlayer');
        //return;        
    }

    exec function ViewPlayerByName(string PlayerName)
    {
        ServerViewPlayerByName(PlayerName);
        //return;        
    }

    exec function BehindView()
    {
        bForceBehindView = !bForceBehindView;
        //return;        
    }

    exec function PrevWeapon()
    {
        ServerViewPrevPlayer();
        //return;        
    }

    exec function NextWeapon()
    {
        ServerViewNextPlayer();
        //return;        
    }

    exec function StartFire(optional byte FireModeNum)
    {
        ServerViewObjective();
        //return;        
    }

    exec function StartAltFire(optional byte FireModeNum)
    {
        ServerViewSelf();
        //return;        
    }

    simulated event GetPlayerViewPoint(out Vector out_Location, out Rotator out_Rotation)
    {
        // End:0x4C
        if((SkyGame(WorldInfo.Game) != none) && SkyGame(WorldInfo.Game).bAutomatedPerfTesting)
        {
            SetBehindView(false);            
        }
        else
        {
            // End:0x7F
            if((bBehindView != bForceBehindView) && SkyPawnBase(ViewTarget) != none)
            {
                SetBehindView(bForceBehindView);
            }
        }
        global.GetPlayerViewPoint(out_Location, out_Rotation);
        //return;        
    }
    stop;    
}

state InQueue extends Spectating
{
    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        PlayerReplicationInfo.bIsSpectator = true;
        //return;        
    }

    function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        ServerViewSelf();
        //return;        
    }
    stop;    
}
