class Pawn extends Actor
    abstract
    native
    nativereplication
    config(Game)
    placeable
    hidecategories(lighting);

const RAYSID_COUNT = 3;

enum EPathSearchType
{
    PST_Default,                    // 0
    PST_Breadth,                    // 1
    PST_AStar,                      // 2
    PST_MAX                         // 3
};

enum EHelmetAnimStatus
{
    HELMETSTATUS_NONE,              // 0
    HELMETSTATUS_ACTIVATE,          // 1
    HELMETSTATUS_MOVE_DOWN,         // 2
    HELMETSTATUS_MOVE_UP,           // 3
    HELMETSTATUS_REACH_UP,          // 4
    HELMETSTATUS_REACH_DOWN,        // 5
    HELMETSTATUS_UNREACH_UP,        // 6
    HELMETSTATUS_UNREACH_DOWN,      // 7
    HELMETSTATUS_WAITING_UP,        // 8
    HELMETSTATUS_WAITING_DOWN,      // 9
    HELMETSTATUS_WEAR_GASMASK,      // 10
    HELMETSTATUS_UNWEAR_GASMASK,    // 11
    HELMETSTATUS_GOGGLES_ON,        // 12
    HELMETSTATUS_GASMASK_ON,        // 13
    HELMETSTATUS_MAX                // 14
};

var const float MaxStepHeight;
var const float MaxJumpHeight;
var const float WalkableFloorZ;
var repnotify Controller Controller;
var private const Pawn NextPawn;
var float NetRelevancyTime;
var PlayerController LastRealViewer;
var Actor LastViewer;
var bool bJustLanded;
var bool bLandRecovery;
var bool bUpAndOut;
var bool bIsWalking;
var bool m_bDontResetAccelOnLand;
var bool bWantsToCrouch;
var const bool bIsCrouched;
var const bool bTryToUncrouch;
var() bool bCanCrouch;
var bool bCrawler;
var const bool bReducedSpeed;
var bool bJumpCapable;
var bool bCanJump;
var bool bCanWalk;
var bool bCanSwim;
var bool bCanFly;
var bool bCanClimbLadders;
var bool bCanClimb;
var bool bCanStrafe;
var bool bAvoidLedges;
var bool bStopAtLedges;
var bool bCountJumps;
var const bool bSimulateGravity;
var bool bUpdateEyeheight;
var bool bIgnoreForces;
var const bool bNoVelocityUpdate;
var bool bCanWalkOffLedges;
var bool bCanBeBaseForPawns;
var bool bClientCollision;
var const bool bSimGravityDisabled;
var bool bDirectHitWall;
var const bool bPushesRigidBodies;
var bool bIsFemale;
var bool bCanPickupInventory;
var bool bAmbientCreature;
var(AI) bool bLOSHearing;
var(AI) bool bSameZoneHearing;
var(AI) bool bAdjacentZoneHearing;
var(AI) bool bMuffledHearing;
var(AI) bool bAroundCornerHearing;
var(AI) bool bDontPossess;
var bool bAutoFire;
var bool bRollToDesired;
var bool bStationary;
var bool bCachedRelevant;
var globalconfig bool bWeaponBob;
var bool bSpecialHUD;
var bool bNoWeaponFiring;
var bool bCanUse;
var bool bUseDesiredPrePivot;
var bool bForceMaxAccel;
var bool m_bAnimationDrivenMovement;
var bool bPlayedDeath;
var bool bDisableAI;
var bool m_bStealth;
var const float UncrouchTime;
var float CrouchHeight;
var float CrouchRadius;
var const int FullHeight;
var float m_fPostureTransitionTime;
var float m_fStairCrouchWeight;
var float m_fStayCrouchedDist;
var Actor m_pPhysColliding;
var Pawn.EPathSearchType PathSearchType;
var byte Visibility;
var Pawn.EHelmetAnimStatus m_eHelmetStatus;
var repnotify byte FlashCount;
var repnotify byte FiringMode;
var float DesiredSpeed;
var float MaxDesiredSpeed;
var(AI) float HearingThreshold;
var(AI) float Alertness;
var(AI) float SightRadius;
var(AI) float PeripheralVision;
var const float AvgPhysicsTime;
var float MeleeRange;
var NavigationPoint Anchor;
var const NavigationPoint LastAnchor;
var float FindAnchorFailedTime;
var float LastValidAnchorTime;
var float DestinationOffset;
var float NextPathRadius;
var Vector SerpentineDir;
var float SerpentineDist;
var float SerpentineTime;
var float SpawnTime;
var int MaxLeanRoll;
var float GroundSpeed;
var float WaterSpeed;
var float AirSpeed;
var float LadderSpeed;
var float AccelRate;
var float JumpZ;
var float AirControl;
var float WalkingPct;
var float CrouchedPct;
var float MaxFallSpeed;
var(Eyes) float BaseEyeHeight;
var(Eyes) float EyeHeight;
var Vector Floor;
var float SplashTime;
var float OldZ;
var PhysicsVolume HeadVolume;
var travel int Health;
var float BreathTime;
var float UnderWaterTime;
var float LastPainTime;
var Vector DesiredPrePivot;
var const Vector noise1spot;
var const float noise1time;
var const Pawn noise1other;
var const float noise1loudness;
var const Vector noise2spot;
var const float noise2time;
var const Pawn noise2other;
var const float noise2loudness;
var globalconfig float Bob;
var float LandBob;
var float AppliedBob;
var float bobtime;
var Vector WalkBob;
var float SoundDampening;
var float DamageScaling;
var const localized string MenuName;
var class<AIController> ControllerClass;
var repnotify PlayerReplicationInfo PlayerReplicationInfo;
var LadderVolume OnLadder;
var name LandMovementState;
var name WaterMovementState;
var PlayerStart LastStartSpot;
var float LastStartTime;
var Vector TakeHitLocation;
var class<DamageType> HitDamageType;
var Vector TearOffMomentum;
var() export editinline SkeletalMeshComponent Mesh;
var export editinline CylinderComponent CylinderComponent;
var() float RBPushRadius;
var() float RBPushStrength;
var Vehicle DrivenVehicle;
var float AlwaysRelevantDistanceSquared;
var() config float VehicleCheckRadius;
var Controller LastHitBy;
var() float ViewPitchMin;
var() float ViewPitchMax;
var class<InventoryManager> InventoryManagerClass;
var InventoryManager InvManager;
var() Weapon Weapon;
var int m_iResetWeaponAnimation;
var float StandHeight;
var(RAYS) Vector m_TraceHitLocation[3];
var(RAYS) Vector m_TraceHitNormal[3];
var(RAYS) Material m_TraceHitMaterial[3];
var(RAYS) Actor m_TraceHitActor[3];
var(RAYS) float m_TraceLastTick[3];
var repnotify Vector FlashLocation;
var int ShotCount;
var const export editinline PrimitiveComponent PreRagdollCollisionComponent;
var Actor m_pDroppedWeapon;

replication
{
    // Pos:0x000
    if(bNetDirty && int(Role) == int(ROLE_Authority))
        DrivenVehicle, Health, 
        HitDamageType, PlayerReplicationInfo, 
        TakeHitLocation, bIsWalking, 
        bSimulateGravity, bUseDesiredPrePivot;

    // Pos:0x018
    if(((bNetInitial || bNetDirty) && !bNetOwner) && int(Role) == int(ROLE_Authority))
        Weapon;

    // Pos:0x048
    if((bNetDirty && bNetOwner) && int(Role) == int(ROLE_Authority))
        AccelRate, AirControl, 
        AirSpeed, Controller, 
        GroundSpeed, InvManager, 
        JumpZ, LadderSpeed, 
        WaterSpeed;

    // Pos:0x06B
    if((bNetDirty && !bNetOwner) && int(Role) == int(ROLE_Authority))
        FiringMode, FlashCount, 
        FlashLocation, bIsCrouched;

    // Pos:0x090
    if((bTearOff && bNetDirty) && int(Role) == int(ROLE_Authority))
        TearOffMomentum;
}

// Export UPawn::execIsInTakeCover(FFrame&, void* const)
native function bool IsInTakeCover();

// Export UPawn::execHasGasMaskOn(FFrame&, void* const)
native function bool HasGasMaskOn();

// Export UPawn::execIsCombatant(FFrame&, void* const)
native function bool IsCombatant();

// Export UPawn::execGetCameraMesh(FFrame&, void* const)
native function SkeletalMeshComponent GetCameraMesh();

// Export UPawn::execPreventFellOutOfWorld(FFrame&, void* const)
native function bool PreventFellOutOfWorld();

// Export UPawn::execGetPostureChangeDuration(FFrame&, void* const)
native simulated function float GetPostureChangeDuration();

// Export UPawn::execGetPostureBlendWeights(FFrame&, void* const)
native simulated function GetPostureBlendWeights(out float fStandWeight, out float fCrouchWeight, bool bUseStairWeight);

// Export UPawn::execIsScoping(FFrame&, void* const)
native function bool IsScoping();

// Export UPawn::execReachedWaypoint(FFrame&, void* const)
native function ReachedWaypoint(R6Waypoint pWaypoint);

// Export UPawn::execAttachActorToSocket(FFrame&, void* const)
native final function AttachActorToSocket(Actor pAttachee, bool bAttach, name SocketName);

simulated function DrawAnimDebug(Canvas Canvas, name StartingPoint, int iOffsetX, int iOffsetY, bool bAnimDebugRelevantOnly)
{
    // End:0x34
    if(Mesh != none)
    {
        Mesh.super(Pawn).DrawAnimDebug(Canvas, StartingPoint, iOffsetX, iOffsetY, bAnimDebugRelevantOnly);
    }
    return;
}

simulated event ReplicatedEvent(name VarName)
{
    ReplicatedEvent(VarName);
    // End:0x25
    if(VarName == 'PlayerReplicationInfo')
    {
        NotifyTeamChanged();        
    }
    else
    {
        // End:0xAF
        if(VarName == 'Controller')
        {
            // End:0xAC
            if((Controller != none) && Controller.Pawn == none)
            {
                Controller.Pawn = self;
                // End:0xAC
                if((PlayerController(Controller) != none) && PlayerController(Controller).ViewTarget == Controller)
                {
                    PlayerController(Controller).SetViewTarget(self);
                }
            }            
        }
        else
        {
            // End:0xC8
            if(VarName == 'FiringMode')
            {
                FiringModeUpdated(true);                
            }
            else
            {
                // End:0xE2
                if(VarName == 'FlashCount')
                {
                    FlashCountUpdated(true);                    
                }
                else
                {
                    // End:0xF9
                    if(VarName == 'FlashLocation')
                    {
                        FlashLocationUpdated(true);
                    }
                }
            }
        }
    }
    return;
}

// Export UPawn::execSuggestJumpVelocity(FFrame&, void* const)
native function bool SuggestJumpVelocity(out Vector JumpVelocity, Vector Destination, Vector Start);

// Export UPawn::execSetAnchor(FFrame&, void* const)
native function SetAnchor(NavigationPoint NewAnchor);

// Export UPawn::execReachedDestination(FFrame&, void* const)
native function bool ReachedDestination(Actor Goal);

// Export UPawn::execReachedPoint(FFrame&, void* const)
native function bool ReachedPoint(Vector Point, Actor NewAnchor);

// Export UPawn::execForceCrouch(FFrame&, void* const)
native function ForceCrouch();

// Export UPawn::execSetPushesRigidBodies(FFrame&, void* const)
native function SetPushesRigidBodies(bool NewPush);

function int SpecialCostForPath(ReachSpec Path)
{
    return;
}

simulated function bool IsValidEnemy()
{
    return true;
    return;
}

// Export UPawn::execInitRagdoll(FFrame&, void* const)
native function bool InitRagdoll();

// Export UPawn::execTermRagdoll(FFrame&, void* const)
native function bool TermRagdoll();

simulated function SetBaseEyeheight()
{
    // End:0x19
    if(!bIsCrouched)
    {
        BaseEyeHeight = default.BaseEyeHeight;        
    }
    else
    {
        BaseEyeHeight = FMin(0.8000000 * CrouchHeight, CrouchHeight - float(10));
    }
    return;
}

function PlayerChangedTeam()
{
    Died(none, Class'DamageType', Location);
    return;
}

// Export UPawn::execStopFiring(FFrame&, void* const)
native simulated function bool StopFiring();

// Export UPawn::execStartFire(FFrame&, void* const)
native simulated function StartFire(byte FireModeNum);

// Export UPawn::execStopFire(FFrame&, void* const)
native simulated function StopFire(byte FireModeNum);

// Export UPawn::execSetFiringMode(FFrame&, void* const)
native final simulated function SetFiringMode(byte FiringModeNum);

// Export UPawn::execFiringModeUpdated(FFrame&, void* const)
native final simulated function FiringModeUpdated(bool bViaReplication);

// Export UPawn::execIncrementFlashCount(FFrame&, void* const)
native simulated function IncrementFlashCount(Weapon Who, byte FireModeNum);

// Export UPawn::execClearFlashCount(FFrame&, void* const)
native simulated function ClearFlashCount(Weapon Who);

simulated function SetFlashLocation(Weapon Who, byte FireModeNum, Vector NewLoc)
{
    // End:0x23
    if(NewLoc == FlashLocation)
    {
        NewLoc += vect(0.0000000, 0.0000000, 1.0000000);
    }
    // End:0x4D
    if(NewLoc == vect(0.0000000, 0.0000000, 0.0000000))
    {
        NewLoc = vect(0.0000000, 0.0000000, 1.0000000);
    }
    NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    FlashLocation = NewLoc;
    SetFiringMode(FireModeNum);
    FlashLocationUpdated(false);
    return;
}

// Export UPawn::execClearFlashLocation(FFrame&, void* const)
native simulated function ClearFlashLocation(Weapon Who);

// Export UPawn::execFlashCountUpdated(FFrame&, void* const)
native simulated function FlashCountUpdated(bool bViaReplication);

// Export UPawn::execFlashLocationUpdated(FFrame&, void* const)
native simulated function FlashLocationUpdated(bool bViaReplication);

// Export UPawn::execWeaponFired(FFrame&, void* const)
native simulated function WeaponFired(bool bViaReplication, optional Vector HitLocation);

// Export UPawn::execWeaponStoppedFiring(FFrame&, void* const)
native simulated function WeaponStoppedFiring(bool bViaReplication);

// Export UPawn::execIsAlive(FFrame&, void* const)
native function bool IsAlive();

// Export UPawn::execIsLowHealth(FFrame&, void* const)
native function bool IsLowHealth();

// Export UPawn::execIsACivilian(FFrame&, void* const)
native function bool IsACivilian();

// Export UPawn::execIsAHostage(FFrame&, void* const)
native function bool IsAHostage();

// Export UPawn::execIsAFemale(FFrame&, void* const)
native function bool IsAFemale();

// Export UPawn::execIsARainbow(FFrame&, void* const)
native function bool IsARainbow();

// Export UPawn::execIsASpecialRainbow(FFrame&, void* const)
native function bool IsASpecialRainbow();

// Export UPawn::execIsAEliteTerro(FFrame&, void* const)
native function bool IsAEliteTerro();

// Export UPawn::execIsATerro(FFrame&, void* const)
native function bool IsATerro();

// Export UPawn::execIsAScriptedNPC(FFrame&, void* const)
native function bool IsAScriptedNPC();

// Export UPawn::execIsFirstPerson(FFrame&, void* const)
native function bool IsFirstPerson();

// Export UPawn::execIsIrena(FFrame&, void* const)
native function bool IsIrena();

// Export UPawn::execAIStartFire(FFrame&, void* const)
native final function AIStartFire(byte u8FireModeIndex);

// Export UPawn::execAIStopFire(FFrame&, void* const)
native final function AIStopFire(byte u8FireModeIndex);

function Pawn GetAimTarget()
{
    return self;
    return;
}

function bool BotFire(bool bFinished)
{
    StartFire(ChooseFireMode());
    return true;
    return;
}

function byte ChooseFireMode()
{
    return 0;
    return;
}

function bool CanAttack(Actor other)
{
    // End:0x0D
    if(Weapon == none)
    {
        return false;
    }
    return Weapon.CanAttack(other);
    return;
}

function bool TooCloseToAttack(Actor other)
{
    return false;
    return;
}

function float RefireRate()
{
    // End:0x1C
    if(Weapon != none)
    {
        return Weapon.RefireRate();
    }
    return 0.0000000;
    return;
}

function bool FireOnRelease()
{
    // End:0x1C
    if(Weapon != none)
    {
        return Weapon.FireOnRelease();
    }
    return false;
    return;
}

function bool HasRangedAttack()
{
    return Weapon != none;
    return;
}

// Export UPawn::execIsFiring(FFrame&, void* const)
native function bool IsFiring();

function bool NeedToTurn(Vector targ)
{
    local Vector LookDir, AimDir;

    LookDir = Vector(Rotation);
    LookDir.Z = 0.0000000;
    LookDir = Normal(LookDir);
    AimDir = targ - Location;
    AimDir.Z = 0.0000000;
    AimDir = Normal(AimDir);
    return (LookDir Dot AimDir) < 0.9300000;
    return;
}

simulated function string GetHumanReadableName()
{
    // End:0x1A
    if(PlayerReplicationInfo != none)
    {
        return PlayerReplicationInfo.PlayerName;
    }
    return MenuName;
    return;
}

function PlayTeleportEffect(bool bOut, bool bSound)
{
    return;
}

simulated function NotifyTeamChanged()
{
    return;
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
    Controller = C;
    NetPriority = 3.0000000;
    NetUpdateFrequency = 30.0000000;
    NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    // End:0x62
    if(C.PlayerReplicationInfo != none)
    {
        PlayerReplicationInfo = C.PlayerReplicationInfo;
    }
    UpdateControllerOnPossess(bVehicleTransition);
    // End:0xA6
    if(C.IsA('PlayerController'))
    {
        // End:0xA3
        if(int(WorldInfo.NetMode) != int(NM_Standalone))
        {
            RemoteRole = ROLE_AutonomousProxy;
        }        
    }
    else
    {
        RemoteRole = default.RemoteRole;
    }
    SetOwner(Controller);
    EyeHeight = BaseEyeHeight;
    // End:0xE0
    if(InvManager != none)
    {
        InvManager.SetupFor(self);
    }
    return;
}

function UpdateControllerOnPossess(bool bVehicleTransition)
{
    // End:0x1D
    if(!bVehicleTransition)
    {
        Controller.SetRotation(Rotation);
    }
    return;
}

function UnPossessed()
{
    NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    // End:0x2F
    if(DrivenVehicle != none)
    {
        NetUpdateFrequency = 5.0000000;
    }
    PlayerReplicationInfo = none;
    SetOwner(none);
    Controller = none;
    return;
}

simulated function name GetDefaultCameraMode(PlayerController RequestedBy)
{
    // End:0x4A
    if(((RequestedBy != none) && RequestedBy.PlayerCamera != none) && RequestedBy.PlayerCamera.CameraStyle == 'Fixed')
    {
        return 'Fixed';
    }
    return 'FirstPerson';
    return;
}

simulated event BecomeViewTarget(PlayerController PC)
{
    bUpdateEyeheight = true;
    return;
}

function DropToGround()
{
    bCollideWorld = true;
    // End:0x39
    if(Health > 0)
    {
        SetCollision(true, true);
        SetPhysics(2);
        // End:0x39
        if(IsHumanControlled())
        {
            Controller.GotoState(LandMovementState);
        }
    }
    return;
}

function bool CanGrabLadder()
{
    return ((bCanClimbLadders && Controller != none) && int(Physics) != int(9)) && (int(Physics) != int(2)) || Abs(Velocity.Z) <= JumpZ;
    return;
}

function bool RecommendLongRangedAttack()
{
    return false;
    return;
}

function float RangedAttackTime()
{
    return 0.0000000;
    return;
}

simulated function bool CanSplash()
{
    // End:0x70
    if((((WorldInfo.TimeSeconds - SplashTime) > 0.1500000) && (int(Physics) == int(2)) || int(Physics) == int(4)) && Abs(Velocity.Z) > float(100))
    {
        SplashTime = WorldInfo.TimeSeconds;
        return true;
    }
    return false;
    return;
}

function EndClimbLadder(LadderVolume OldLadder)
{
    // End:0x1B
    if(Controller != none)
    {
        Controller.EndClimbLadder();
    }
    // End:0x30
    if(int(Physics) == int(9))
    {
        SetPhysics(2);
    }
    return;
}

function ClimbLadder(LadderVolume L)
{
    OnLadder = L;
    SetRotation(OnLadder.WallDir);
    SetPhysics(9);
    // End:0x3E
    if(IsHumanControlled())
    {
        Controller.GotoState('PlayerClimbing');
    }
    return;
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local string T;
    local Canvas Canvas;

    Canvas = HUD.Canvas;
    // End:0x6E
    if(PlayerReplicationInfo == none)
    {
        Canvas.__NFUN_465__("NO PLAYERREPLICATIONINFO", false);
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);        
    }
    else
    {
        PlayerReplicationInfo.DisplayDebug(HUD, out_YL, out_YPos);
    }
    DisplayDebug(HUD, out_YL, out_YPos);
    Canvas.SetDrawColor(byte(255), byte(255), byte(255));
    Canvas.__NFUN_465__("Health " $ string(Health));
    out_YPos += out_YL;
    Canvas.SetPos(4.0000000, out_YPos);
    // End:0x18F
    if(HUD.ShouldDisplayDebug("AI"))
    {
        Canvas.__NFUN_465__((((("Anchor " $ string(Anchor)) $ " Serpentine Dist ") $ string(SerpentineDist)) $ " Time ") $ string(SerpentineTime));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
    }
    // End:0x26C
    if(HUD.ShouldDisplayDebug("physics"))
    {
        T = (((("Floor " $ string(Floor)) $ " DesiredSpeed ") $ string(DesiredSpeed)) $ " Crouched ") $ string(bIsCrouched);
        // End:0x235
        if((OnLadder != none) || int(Physics) == int(9))
        {
            T = (T $ " on ladder ") $ string(OnLadder);
        }
        Canvas.__NFUN_465__(T);
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
    }
    // End:0x2EA
    if(HUD.ShouldDisplayDebug("camera"))
    {
        Canvas.__NFUN_465__((("EyeHeight " $ string(EyeHeight)) $ " BaseEyeHeight ") $ string(BaseEyeHeight));
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
    }
    // End:0x379
    if(Controller == none)
    {
        Canvas.SetDrawColor(byte(255), 0, 0);
        Canvas.__NFUN_465__("NO CONTROLLER");
        out_YPos += out_YL;
        Canvas.SetPos(4.0000000, out_YPos);
        HUD.PlayerOwner.DisplayDebug(HUD, out_YL, out_YPos);        
    }
    else
    {
        Controller.DisplayDebug(HUD, out_YL, out_YPos);
    }
    // End:0x435
    if(HUD.ShouldDisplayDebug("weapon"))
    {
        // End:0x416
        if(Weapon == none)
        {
            Canvas.SetDrawColor(0, byte(255), 0);
            Canvas.__NFUN_465__("NO WEAPON");
            out_YPos += out_YL;
            Canvas.SetPos(4.0000000, out_YPos);            
        }
        else
        {
            Weapon.DisplayDebug(HUD, out_YL, out_YPos);
        }
    }
    return;
}

simulated function Vector WeaponBob(float BobDamping)
{
    local Vector WBob;

    WBob = BobDamping * WalkBob;
    WBob.Z = (0.4500000 + (0.5500000 * BobDamping)) * WalkBob.Z;
    WBob.Z += LandBob;
    return WBob;
    return;
}

function CheckBob(float DeltaTime, Vector Y)
{
    local float Speed2D;

    // End:0x36
    if(!bWeaponBob || bJustLanded)
    {
        bobtime = 0.0000000;
        WalkBob = vect(0.0000000, 0.0000000, 0.0000000);
        return;
    }
    Bob = FClamp(Bob, -0.0500000, 0.0500000);
    // End:0x15F
    if(int(Physics) == int(1))
    {
        Speed2D = VSize(Velocity);
        // End:0x8E
        if(Speed2D < float(10))
        {
            bobtime += (0.2000000 * DeltaTime);            
        }
        else
        {
            bobtime += (DeltaTime * (0.3000000 + ((0.7000000 * Speed2D) / GroundSpeed)));
        }
        WalkBob = ((Y * Bob) * Speed2D) * Sin(8.0000000 * bobtime);
        AppliedBob = AppliedBob * (float(1) - FMin(1.0000000, 16.0000000 * DeltaTime));
        WalkBob.Z = AppliedBob;
        // End:0x15C
        if(Speed2D > float(10))
        {
            WalkBob.Z = WalkBob.Z + (((0.7500000 * Bob) * Speed2D) * Sin(16.0000000 * bobtime));
        }        
    }
    else
    {
        // End:0x212
        if(int(Physics) == int(3))
        {
            bobtime += DeltaTime;
            Speed2D = Sqrt((Velocity.X * Velocity.X) + (Velocity.Y * Velocity.Y));
            WalkBob = (((Y * Bob) * 0.5000000) * Speed2D) * Sin(4.0000000 * bobtime);
            WalkBob.Z = ((Bob * 1.5000000) * Speed2D) * Sin(8.0000000 * bobtime);            
        }
        else
        {
            bobtime = 0.0000000;
            WalkBob = WalkBob * (float(1) - FMin(1.0000000, 8.0000000 * DeltaTime));
        }
    }
    return;
}

simulated function bool IsPlayerPawn()
{
    return (Controller != none) && Controller.bIsPlayer;
    return;
}

simulated function bool WasPlayerPawn()
{
    return false;
    return;
}

// Export UPawn::execIsHumanControlled(FFrame&, void* const)
native final simulated function bool IsHumanControlled();

// Export UPawn::execIsLocallyControlled(FFrame&, void* const)
native final simulated function bool IsLocallyControlled();

event UpdateEyeHeight(float DeltaTime)
{
    local float smooth, MaxEyeHeight, OldEyeHeight;
    local Actor HitActor;
    local Vector HitLocation, HitNormal;

    // End:0x1E
    if(bTearOff)
    {
        EyeHeight = default.BaseEyeHeight;
        bUpdateEyeheight = false;
        return;
    }
    // End:0x4A
    if(Abs(Location.Z - OldZ) > float(15))
    {
        bJustLanded = false;
        bLandRecovery = false;
    }
    // End:0x127
    if(!bJustLanded)
    {
        smooth = FMin(0.9000000, (10.0000000 * DeltaTime) / WorldInfo.TimeDilation);
        LandBob *= (float(1) - smooth);
        // End:0xFF
        if(Controller.WantsSmoothedView())
        {
            OldEyeHeight = EyeHeight;
            EyeHeight = FMax((((EyeHeight - Location.Z) + OldZ) * (float(1) - smooth)) + (BaseEyeHeight * smooth), -0.5000000 * CylinderComponent.CollisionHeight);            
        }
        else
        {
            EyeHeight = (EyeHeight * (float(1) - smooth)) + (BaseEyeHeight * smooth);
        }        
    }
    else
    {
        // End:0x1D1
        if(bLandRecovery)
        {
            smooth = FMin(0.9000000, 10.0000000 * DeltaTime);
            OldEyeHeight = EyeHeight;
            EyeHeight = FMin((EyeHeight * (float(1) - (0.6000000 * smooth))) + ((BaseEyeHeight * 0.6000000) * smooth), BaseEyeHeight);
            LandBob *= (float(1) - smooth);
            // End:0x1CE
            if(EyeHeight >= (BaseEyeHeight - float(1)))
            {
                bJustLanded = false;
                bLandRecovery = false;
                EyeHeight = BaseEyeHeight;
            }            
        }
        else
        {
            smooth = FMin(0.6500000, 10.0000000 * DeltaTime);
            OldEyeHeight = EyeHeight;
            EyeHeight = EyeHeight * (float(1) - (1.5000000 * smooth));
            LandBob += (0.0300000 * (OldEyeHeight - EyeHeight));
            // End:0x277
            if((EyeHeight < ((0.2500000 * BaseEyeHeight) + float(1))) || LandBob > float(3))
            {
                bLandRecovery = true;
                EyeHeight = (0.2500000 * BaseEyeHeight) + float(1);
            }
        }
    }
    // End:0x358
    if(EyeHeight > CylinderComponent.CollisionHeight)
    {
        HitActor = Trace(HitLocation, HitNormal, Location + (((CylinderComponent.CollisionHeight + MaxStepHeight) + float(14)) * vect(0.0000000, 0.0000000, 1.0000000)), Location + (CylinderComponent.CollisionHeight * vect(0.0000000, 0.0000000, 1.0000000)), true);
        // End:0x324
        if(HitActor == none)
        {
            MaxEyeHeight = CylinderComponent.CollisionHeight + MaxStepHeight;            
        }
        else
        {
            MaxEyeHeight = (HitLocation.Z - Location.Z) - float(14);
        }
        EyeHeight = FMin(EyeHeight, MaxEyeHeight);
    }
    Controller.AdjustView(DeltaTime);
    return;
}

// Export UPawn::execProcessViewRotation(FFrame&, void* const)
native simulated function ProcessViewRotation(float DeltaTime, out Rotator rViewRotation, out Rotator rDeltaRot);

simulated event GetActorEyesViewPoint(out Vector out_Location, out Rotator out_Rotation)
{
    out_Location = GetPawnViewLocation();
    out_Rotation = GetViewRotation();
    return;
}

simulated function Rotator GetViewRotation()
{
    // End:0x1D
    if(Controller != none)
    {
        return Controller.Rotation;        
    }
    else
    {
        return Rotation;
    }
    return;
}

simulated event Vector GetPawnViewLocation()
{
    return Location + (vect(0.0000000, 0.0000000, 1.0000000) * BaseEyeHeight);
    return;
}

simulated event Vector GetWeaponStartTraceLocation(optional Weapon CurrentWeapon)
{
    local Vector POVLoc;
    local Rotator POVRot;

    // End:0x2C
    if(Controller != none)
    {
        Controller.GetPlayerViewPoint(POVLoc, POVRot);
        return POVLoc;
    }
    return GetPawnViewLocation();
    return;
}

singular simulated function Rotator GetBaseAimRotation()
{
    local Vector POVLoc;
    local Rotator POVRot;

    // End:0x39
    if((Controller != none) && !InFreeCam())
    {
        Controller.GetPlayerViewPoint(POVLoc, POVRot);
        return POVRot;
    }
    POVRot = Rotation;
    return POVRot;
    return;
}

// Export UPawn::execInFreeCam(FFrame&, void* const)
native simulated function bool InFreeCam();

simulated function Rotator GetAdjustedAimFor(Inventory W, Vector StartFireLoc)
{
    // End:0x25
    if((Controller == none) || int(Role) < int(ROLE_Authority))
    {
        return GetBaseAimRotation();
    }
    return Controller.GetAdjustedAimFor(W, StartFireLoc);
    return;
}

simulated function SetViewRotation(Rotator NewRotation)
{
    // End:0x20
    if(Controller != none)
    {
        Controller.SetRotation(NewRotation);        
    }
    else
    {
        SetRotation(NewRotation);
    }
    return;
}

simulated function bool PawnCalcCamera(float fDeltaTime, out Vector out_CamLoc, out Rotator out_CamRot, out float out_FOV)
{
    return CalcCamera(fDeltaTime, out_CamLoc, out_CamRot, out_FOV);
    return;
}

// Export UPawn::execInGodMode(FFrame&, void* const)
native final function bool InGodMode();

function bool NearMoveTarget()
{
    // End:0x23
    if((Controller == none) || Controller.MoveTarget == none)
    {
        return false;
    }
    return ReachedDestination(Controller.MoveTarget);
    return;
}

function Actor GetMoveTarget()
{
    // End:0x0D
    if(Controller == none)
    {
        return none;
    }
    return Controller.MoveTarget;
    return;
}

function SetMoveTarget(Actor NewTarget)
{
    // End:0x1F
    if(Controller != none)
    {
        Controller.MoveTarget = NewTarget;
    }
    return;
}

function bool LineOfSightTo(Actor other)
{
    return (Controller != none) && Controller.LineOfSightTo(other);
    return;
}

function float AdjustedStrength()
{
    return 0.0000000;
    return;
}

function HandlePickup(Inventory Inv)
{
    // End:0x20
    if(Controller != none)
    {
        Controller.HandlePickup(Inv);
    }
    return;
}

function ReceiveLocalizedMessage(class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    // End:0x42
    if(PlayerController(Controller) != none)
    {
        PlayerController(Controller).ReceiveLocalizedMessage(Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    }
    return;
}

event ClientMessage(coerce string S, optional name Type)
{
    // End:0x31
    if(PlayerController(Controller) != none)
    {
        PlayerController(Controller).ClientMessage(S, Type);
    }
    return;
}

function FinishedInterpolation()
{
    DropToGround();
    return;
}

function JumpOutOfWater(Vector jumpDir)
{
    Falling();
    Velocity = jumpDir * WaterSpeed;
    Acceleration = jumpDir * AccelRate;
    Velocity.Z = 1.2000000 * default.JumpZ;
    bUpAndOut = true;
    return;
}

simulated event ModifyVelocity(float DeltaTime, Vector OldVelocity)
{
    return;
}

event FellOutOfWorld(class<DamageType> dmgType)
{
    local bool bIsSafe;

    bIsSafe = false;
    // End:0xBE
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x45
        if((Controller != none) && Controller.m_bIsNoFellOutOfWorld)
        {
            bIsSafe = PreventFellOutOfWorld();
        }
        // End:0xBE
        if(!bIsSafe)
        {
            Health = -1;
            // End:0x8C
            if(dmgType == Class'DmgType_Suicided')
            {
                // End:0x77
                if(Controller == none)
                {
                    return;
                }
                // End:0x8C
                if(int(Physics) != int(10))
                {
                    SetPhysics(0);
                }
            }
            Died(none, dmgType, Location);
            LifeSpan = FMin(LifeSpan, 2.0000000);
            // End:0xBE
            if(dmgType == none)
            {
                Destroy();
            }
        }
    }
    return;
}

simulated function UnCrouch()
{
    // End:0x1C
    if(bIsCrouched || bWantsToCrouch)
    {
        ShouldCrouch(false);
    }
    return;
}

function ShouldCrouch(bool bCrouch)
{
    // End:0x1E
    if(bWantsToCrouch != bCrouch)
    {
        bWantsToCrouch = bCrouch;
    }
    return;
}

simulated event EndCrouch(float HeightAdjust)
{
    EyeHeight -= HeightAdjust;
    OldZ += HeightAdjust;
    SetBaseEyeheight();
    return;
}

simulated event StartCrouch(float HeightAdjust)
{
    EyeHeight += HeightAdjust;
    OldZ -= HeightAdjust;
    SetBaseEyeheight();
    return;
}

function RestartPlayer()
{
    return;
}

// Export UPawn::execAddVelocity(FFrame&, void* const)
native function AddVelocity(Vector NewVelocity, Vector HitLocation, class<DamageType> DamageType, optional TraceHitInfo HitInfo);

function KilledBy(Pawn EventInstigator)
{
    local Controller Killer;

    Health = 0;
    // End:0x26
    if(EventInstigator != none)
    {
        Killer = EventInstigator.Controller;
    }
    Died(Killer, Class'DmgType_Suicided', Location);
    return;
}

function TakeFallingDamage()
{
    local float EffectiveSpeed, fActualDamage;

    // End:0xD8
    if(Velocity.Z < (-0.5000000 * MaxFallSpeed))
    {
        // End:0xD8
        if(int(Role) == int(ROLE_Authority))
        {
            // End:0xD8
            if(Velocity.Z < (float(-1) * MaxFallSpeed))
            {
                EffectiveSpeed = Velocity.Z;
                // End:0x6D
                if(TouchingWaterVolume())
                {
                    EffectiveSpeed += float(100);
                }
                // End:0xD8
                if(EffectiveSpeed < (float(-1) * MaxFallSpeed))
                {
                    fActualDamage = (-100.0000000 * (EffectiveSpeed + MaxFallSpeed)) / MaxFallSpeed;
                    TakeDamage(int(fActualDamage), int(fActualDamage), none, Location, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'DmgType_Fell');
                }
            }
        }
    }
    return;
}

function Restart()
{
    return;
}

function ClientRestart()
{
    Velocity = vect(0.0000000, 0.0000000, 0.0000000);
    Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
    SetBaseEyeheight();
    return;
}

function ClientSetLocation(Vector NewLocation, Rotator NewRotation)
{
    // End:0x25
    if(Controller != none)
    {
        Controller.ClientSetLocation(NewLocation, NewRotation);
    }
    return;
}

function ClientSetRotation(Rotator NewRotation)
{
    // End:0x20
    if(Controller != none)
    {
        Controller.ClientSetRotation(NewRotation);
    }
    return;
}

// Export UPawn::execFaceRotation(FFrame&, void* const)
native simulated function FaceRotation(Rotator NewRotation, float DeltaTime);

event bool EncroachingOn(Actor other)
{
    // End:0x28
    if(other.bWorldGeometry || other.bBlocksTeleport)
    {
        return true;
    }
    // End:0x5D
    if(((Controller == none) || !Controller.bIsPlayer) && Pawn(other) != none)
    {
        return true;
    }
    return false;
    return;
}

event EncroachedBy(Actor other)
{
    // End:0x2E
    if((Pawn(other) != none) && Vehicle(other) == none)
    {
        gibbedBy(other);
    }
    return;
}

function gibbedBy(Actor other)
{
    // End:0x12
    if(int(Role) < int(ROLE_Authority))
    {
        return;
    }
    // End:0x49
    if(Pawn(other) != none)
    {
        Died(Pawn(other).Controller, Class'DmgType_Telefragged', Location);        
    }
    else
    {
        Died(none, Class'DmgType_Telefragged', Location);
    }
    return;
}

function JumpOffPawn()
{
    Velocity += ((float(100) + CylinderComponent.CollisionRadius) * VRand());
    Velocity.Z = 200.0000000 + CylinderComponent.CollisionHeight;
    SetPhysics(2);
    return;
}

singular event BaseChange()
{
    local float fActualDamage;

    // End:0x25
    if((Base == none) && int(Physics) == int(0))
    {
        SetPhysics(2);        
    }
    else
    {
        // End:0xF3
        if((Pawn(Base) != none) && (DrivenVehicle == none) || !DrivenVehicle.IsBasedOn(Base))
        {
            // End:0xF3
            if(!Pawn(Base).bCanBeBaseForPawns)
            {
                fActualDamage = ((1.0000000 - (Velocity.Z / float(400))) * Mass) / Base.Mass;
                Base.TakeDamage(int(fActualDamage), int(fActualDamage), Controller, Location, Location, 0.5000000 * Velocity, Class'DmgType_Crushed');
                JumpOffPawn();
            }
        }
    }
    return;
}

function DetachFromController(optional bool bDestroyController)
{
    local Controller OldController;

    // End:0xAE
    if((Controller != none) && Controller.Pawn == self)
    {
        OldController = Controller;
        Controller.PawnDied(self);
        // End:0x59
        if(Controller != none)
        {
            Controller.UnPossess();
        }
        // End:0xA7
        if(((bDestroyController && OldController != none) && !OldController.bDeleteMe) && !OldController.bIsPlayer)
        {
            OldController.Destroy();
        }
        Controller = none;
    }
    return;
}

simulated event Destroyed()
{
    DetachFromController();
    // End:0x23
    if(int(WorldInfo.NetMode) == int(NM_Client))
    {
        return;
    }
    // End:0x42
    if(InvManager != none)
    {
        SetWeapon(none);
        InvManager.Destroy();
    }
    Destroyed();
    return;
}

simulated event PreBeginPlay()
{
    PreBeginPlay();
    Instigator = self;
    DesiredRotation = Rotation;
    EyeHeight = BaseEyeHeight;
    return;
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
    SplashTime = 0.0000000;
    SpawnTime = WorldInfo.TimeSeconds;
    EyeHeight = BaseEyeHeight;
    // End:0x64
    if((WorldInfo.bStartup && Health > 0) && !bDontPossess)
    {
        SpawnDefaultController();
    }
    // End:0xB8
    if((int(Role) == int(ROLE_Authority)) && InvManager == none)
    {
        InvManager = __NFUN_278__(InventoryManagerClass, self);
        // End:0xB1
        if(InvManager != none)
        {
            InvManager.SetupFor(self);
        }
        InvManagerCreated();
    }
    // End:0xD9
    if(int(Role) == int(ROLE_AutonomousProxy))
    {
        BecomeViewTarget(PlayerController(Controller));
    }
    DesiredPrePivot = default.PrePivot;
    return;
}

simulated function InvManagerCreated()
{
    return;
}

event SpawnDefaultController()
{
    // End:0x0D
    if(Controller != none)
    {
        return;
    }
    // End:0x2C
    if(ControllerClass != none)
    {
        Controller = __NFUN_278__(ControllerClass);
    }
    // End:0x49
    if(Controller != none)
    {
        Controller.Possess(self, false);
    }
    return;
}

function OnAssignController(SeqAct_AssignController inAction)
{
    // End:0x85
    if(inAction.ControllerClass != none)
    {
        // End:0x27
        if(Controller != none)
        {
            DetachFromController(true);
        }
        Controller = __NFUN_278__(inAction.ControllerClass);
        Controller.Possess(self, false);
        // End:0x82
        if(Controller.IsA('AIController'))
        {
            ControllerClass = class<AIController>(Controller.Class);
        }        
    }
    else
    {
        WarnInternal("Assign controller w/o a class specified!");
    }
    return;
}

function Gasp()
{
    return;
}

function SetMovementPhysics()
{
    // End:0x1A
    if(PhysicsVolume.bWaterVolume)
    {
        SetPhysics(3);        
    }
    else
    {
        // End:0x2F
        if(int(Physics) != int(2))
        {
            SetPhysics(2);
        }
    }
    return;
}

// Export UPawn::execAdjustDamage(FFrame&, void* const)
native function AdjustDamage(out int inDamage, out Vector Momentum, Controller InstigatedBy, Vector HitLocation, class<DamageType> DamageType, optional TraceHitInfo HitInfo);

simulated function byte GetTeamNum()
{
    // End:0x1C
    if(Controller != none)
    {
        return Controller.GetTeamNum();
    }
    // End:0x57
    if((DrivenVehicle != none) && DrivenVehicle.Controller != none)
    {
        return DrivenVehicle.Controller.GetTeamNum();
    }
    // End:0x7D
    if((PlayerReplicationInfo == none) || PlayerReplicationInfo.Team == none)
    {
        return byte(255);
    }
    return byte(PlayerReplicationInfo.Team.TeamIndex);
    return;
}

simulated function TeamInfo GetTeam()
{
    // End:0x1A
    if(PlayerReplicationInfo != none)
    {
        return PlayerReplicationInfo.Team;
    }
    // End:0x53
    if((DrivenVehicle != none) && DrivenVehicle.PlayerReplicationInfo != none)
    {
        return DrivenVehicle.PlayerReplicationInfo.Team;
    }
    return none;
    return;
}

simulated event bool IsSameTeam(Pawn other)
{
    // End:0x43
    if(((other != none) && other.GetTeam() != none) && other.GetTeam() == (GetTeam()))
    {
        return true;
    }
    return false;
    return;
}

// Export UPawn::execDied(FFrame&, void* const)
native function bool Died(Controller Killer, class<DamageType> DamageType, Vector HitLocation);

event Falling()
{
    return;
}

event Landed(Vector HitNormal, Actor FloorActor, Vector vLocation)
{
    TakeFallingDamage();
    // End:0x23
    if(Health > 0)
    {
        PlayLanded(Velocity.Z);
    }
    // End:0x76
    if((Velocity.Z < float(-200)) && PlayerController(Controller) != none)
    {
        OldZ = Location.Z;
        bJustLanded = PlayerController(Controller).bLandingShake;
    }
    LastHitBy = none;
    return;
}

event HeadVolumeChange(PhysicsVolume newHeadVolume)
{
    // End:0x28
    if((int(WorldInfo.NetMode) == int(NM_Client)) || Controller == none)
    {
        return;
    }
    // End:0x94
    if(HeadVolume.bWaterVolume)
    {
        // End:0x91
        if(!newHeadVolume.bWaterVolume)
        {
            // End:0x86
            if((Controller.bIsPlayer && BreathTime > float(0)) && BreathTime < float(8))
            {
                Gasp();
            }
            BreathTime = -1.0000000;
        }        
    }
    else
    {
        // End:0xB1
        if(newHeadVolume.bWaterVolume)
        {
            BreathTime = UnderWaterTime;
        }
    }
    return;
}

function bool TouchingWaterVolume()
{
    local PhysicsVolume V;

    // End:0x26
    foreach TouchingActors(Class'PhysicsVolume', V)
    {
        // End:0x25
        if(V.bWaterVolume)
        {            
            return true;
        }        
    }    
    return false;
    return;
}

function bool IsInPain()
{
    local PhysicsVolume V;

    // End:0x3E
    foreach TouchingActors(Class'PhysicsVolume', V)
    {
        // End:0x3D
        if(V.bPainCausing && V.DamagePerSec > float(0))
        {            
            return true;
        }        
    }    
    return false;
    return;
}

event BreathTimer()
{
    // End:0x35
    if(((Health < 0) || int(WorldInfo.NetMode) == int(NM_Client)) || DrivenVehicle != none)
    {
        return;
    }
    TakeDrowningDamage();
    // End:0x52
    if(Health > 0)
    {
        BreathTime = 2.0000000;
    }
    return;
}

function TakeDrowningDamage()
{
    return;
}

function bool CheckWaterJump(out Vector WallNormal)
{
    local Actor HitActor;
    local Vector HitLocation, HitNormal, checkpoint, Start, checkNorm, Extent;

    // End:0x2B
    if(AIController(Controller) != none)
    {
        checkpoint = Acceleration;
        checkpoint.Z = 0.0000000;
    }
    // End:0x4F
    if(checkpoint == vect(0.0000000, 0.0000000, 0.0000000))
    {
        checkpoint = Vector(Rotation);
    }
    checkpoint.Z = 0.0000000;
    checkNorm = Normal(checkpoint);
    checkpoint = Location + ((1.2000000 * CylinderComponent.CollisionRadius) * checkNorm);
    Extent = CylinderComponent.CollisionRadius * vect(1.0000000, 1.0000000, 0.0000000);
    Extent.Z = CylinderComponent.CollisionHeight;
    HitActor = Trace(HitLocation, HitNormal, checkpoint, Location, true, Extent);
    // End:0x1C7
    if((HitActor != none) && Pawn(HitActor) == none)
    {
        WallNormal = float(-1) * HitNormal;
        Start = Location;
        Start.Z += FMin(CylinderComponent.CollisionHeight, 1.1000000 * MaxStepHeight);
        checkpoint = Start + ((3.2000000 * CylinderComponent.CollisionRadius) * WallNormal);
        HitActor = Trace(HitLocation, HitNormal, checkpoint, Start, true);
        // End:0x1C7
        if((HitActor == none) || HitNormal.Z > 0.7000000)
        {
            return true;
        }
    }
    return false;
    return;
}

function bool DoJump(bool bUpdating)
{
    // End:0x163
    if((!bIsCrouched && !bWantsToCrouch) && ((int(Physics) == int(1)) || int(Physics) == int(9)) || int(Physics) == int(8))
    {
        // End:0x89
        if(int(Role) == int(ROLE_Authority))
        {
            // End:0x89
            if(bCountJumps && InvManager != none)
            {
                InvManager.OwnerEvent('Jumped');
            }
        }
        // End:0xAE
        if(int(Physics) == int(8))
        {
            Velocity = JumpZ * Floor;            
        }
        else
        {
            // End:0xD1
            if(int(Physics) == int(9))
            {
                Velocity.Z = 0.0000000;                
            }
            else
            {
                // End:0xED
                if(bIsWalking)
                {
                    Velocity.Z = default.JumpZ;                    
                }
                else
                {
                    Velocity.Z = JumpZ;
                }
            }
        }
        // End:0x15C
        if(((Base != none) && !Base.bWorldGeometry) && Base.Velocity.Z > 0.0000000)
        {
            Velocity.Z += Base.Velocity.Z;
        }
        SetPhysics(2);
        return true;
    }
    return false;
    return;
}

function PlayDyingSound()
{
    return;
}

// Export UPawn::execPlayHit(FFrame&, void* const)
native final function PlayHit(float Damage, Controller InstigatedBy, Vector HitLocation, class<DamageType> DamageType, Vector Momentum, TraceHitInfo HitInfo);

simulated function TurnOff()
{
    SetCollision(true, false);
    bNoWeaponFiring = true;
    Velocity = vect(0.0000000, 0.0000000, 0.0000000);
    SetPhysics(0);
    bIgnoreForces = true;
    // End:0x4A
    if(Weapon != none)
    {
        Weapon.StopFire(0);
    }
    return;
}

// Export UPawn::execPlayDying(FFrame&, void* const)
native simulated function PlayDying(class<DamageType> DamageType, Vector HitLoc);

simulated event TornOff()
{
    // End:0x1C
    if(!bPlayedDeath)
    {
        PlayDying(HitDamageType, TakeHitLocation);
    }
    return;
}

simulated function PlayFiring(float Rate, name FiringModeName)
{
    return;
}

function PlayTakeHit(Vector HitLoc, int Damage, class<DamageType> DamageType)
{
    return;
}

event PlayFootStepSound(int FootDown)
{
    return;
}

function bool CannotJumpNow()
{
    return false;
    return;
}

function PlayLanded(float impactVel)
{
    return;
}

// Export UPawn::execGetVehicleBase(FFrame&, void* const)
native function Vehicle GetVehicleBase();

function Suicide()
{
    KilledBy(self);
    return;
}

simulated function bool CanThrowWeapon()
{
    return true;
    return;
}

simulated event StartDriving(Vehicle V)
{
    DrivenVehicle = V;
    NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    StopFiring();
    ShouldCrouch(false);
    bIgnoreForces = true;
    Velocity = vect(0.0000000, 0.0000000, 0.0000000);
    Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
    bCanTeleport = false;
    V.AttachDriver(self);
    return;
}

simulated event StopDriving(Vehicle V)
{
    // End:0x28
    if(Mesh != none)
    {
        Mesh.CullDistance = default.Mesh.CullDistance;
    }
    NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    // End:0x5C
    if(V != none)
    {
        V.StopFiring();
    }
    // End:0x6E
    if(int(Physics) == int(10))
    {
        return;
    }
    DrivenVehicle = none;
    bIgnoreForces = false;
    bHardAttach = false;
    bCanTeleport = true;
    bCollideWorld = true;
    // End:0xB1
    if(V != none)
    {
        V.DetachDriver(self);
    }
    SetCollision(true, true);
    // End:0x101
    if((int(Role) == int(ROLE_Authority)) && Health > 0)
    {
        // End:0xED
        if(PhysicsVolume.bWaterVolume)
        {
            SetPhysics(3);            
        }
        else
        {
            SetPhysics(2);
        }
        SetBase(none);
        bHidden = false;
    }
    return;
}

// Export UPawn::execAddDefaultInventory(FFrame&, void* const)
native function AddDefaultInventory();

final event Inventory CreateInventory(class<Inventory> NewInvClass, optional bool bDoNotActivate)
{
    // End:0x28
    if(InvManager != none)
    {
        return InvManager.CreateInventory(NewInvClass, bDoNotActivate);
    }
    return none;
    return;
}

final simulated function Inventory FindInventoryType(class<Inventory> DesiredClass)
{
    // End:0x21
    if(InvManager != none)
    {
        return InvManager.FindInventoryType(DesiredClass);
    }
    return none;
    return;
}

simulated function DrawHUD(HUD H)
{
    // End:0x20
    if(InvManager != none)
    {
        InvManager.DrawHUD(H);
    }
    return;
}

function ThrowActiveWeapon()
{
    return;
}

function TossWeapon(Vector TossVel)
{
    return;
}

simulated event SetActiveWeapon(Weapon NewWeapon, optional bool bInstantSwitch)
{
    // End:0x29
    if(InvManager != none)
    {
        InvManager.SetCurrentWeapon(NewWeapon, false, bInstantSwitch);
    }
    return;
}

simulated function SetWeapon(Weapon NewWeapon)
{
    Weapon = NewWeapon;
    return;
}

simulated function PlayWeaponSwitch(Weapon OldWeapon, Weapon NewWeapon)
{
    return;
}

function bool CheatWalk()
{
    UnderWaterTime = default.UnderWaterTime;
    SetCollision(true, true);
    SetPhysics(1);
    bCollideWorld = true;
    SetPushesRigidBodies(default.bPushesRigidBodies);
    return true;
    return;
}

function bool CheatGhost()
{
    UnderWaterTime = -1.0000000;
    SetCollision(false, false);
    bCollideWorld = false;
    SetPushesRigidBodies(false);
    return true;
    return;
}

function bool CheatFly()
{
    UnderWaterTime = default.UnderWaterTime;
    SetCollision(true, true);
    bCollideWorld = true;
    return true;
    return;
}

simulated function float GetCollisionRadius()
{
    return ((CylinderComponent != none) ? CylinderComponent.CollisionRadius : 0.0000000);
    return;
}

simulated function float GetCollisionHeight()
{
    return ((CylinderComponent != none) ? CylinderComponent.CollisionHeight : 0.0000000);
    return;
}

final simulated function Vector GetCollisionExtent()
{
    local Vector Extent;

    Extent = (GetCollisionRadius()) * vect(1.0000000, 1.0000000, 0.0000000);
    Extent.Z = GetCollisionHeight();
    return Extent;
    return;
}

function bool IsStationary()
{
    return false;
    return;
}

event SpawnedByKismet()
{
    // End:0x1B
    if(Controller != none)
    {
        Controller.SpawnedByKismet();
    }
    return;
}

function DoKismetAttachment(Actor Attachment, SeqAct_AttachToActor Action)
{
    Attachment.SetBase(self,, Mesh, Action.BoneName);
    return;
}

function float GetDamageScaling()
{
    return DamageScaling;
    return;
}

event OnSetMaterial(SeqAct_SetMaterial Action)
{
    // End:0x37
    if(Mesh != none)
    {
        Mesh.SetMaterial(Action.MaterialIndex, Action.NewMaterial);
    }
    return;
}

// Export UPawn::execIsIncapacitated(FFrame&, void* const)
native function bool IsIncapacitated();

// Export UPawn::execIncapacitate(FFrame&, void* const)
native function Incapacitate(Controller Killer, class<DamageType> DamageType, Vector vHitLoc);

state Dying
{
    ignores BreathTimer, PlayFiring, PlayWeaponSwitch, PlayTakeHit, PlayNextAnimation, BaseChange, 
	    Landed;

    event Timer()
    {
        // End:0x0E
        if(!PlayerCanSeeMe())
        {
            Destroy();            
        }
        else
        {
            SetTimer(2.0000000, false);
        }
        return;
    }

    function BeginState(name PreviousStateName)
    {
        local int I;

        // End:0x32
        if(bTearOff && int(WorldInfo.NetMode) == int(NM_DedicatedServer))
        {
            LifeSpan = 2.0000000;            
        }
        else
        {
            SetTimer(5.0000000, false);
        }
        // End:0x51
        if(int(Physics) != int(10))
        {
            SetPhysics(2);
        }
        SetCollision(true, false);
        // End:0x8A
        if(Controller != none)
        {
            // End:0x7E
            if(Controller.bIsPlayer)
            {
                DetachFromController();                
            }
            else
            {
                Controller.Destroy();
            }
        }
        I = 0;
        J0x91:

        // End:0xD2 [Loop If]
        if(I < Attached.Length)
        {
            // End:0xC8
            if(Attached[I] != none)
            {
                Attached[I].PawnBaseDied();
            }
            I++;
            // [Loop Continue]
            goto J0x91;
        }
        return;
    }
Begin:

    Sleep(0.2000000);
    PlayDyingSound();
    stop;                
}

defaultproperties
{
    MaxStepHeight=35.0000000
    MaxJumpHeight=96.0000000
    WalkableFloorZ=0.7000000
    bJumpCapable=true
    bCanJump=true
    bCanWalk=true
    bSimulateGravity=true
    bPushesRigidBodies=true
    bLOSHearing=true
    bWeaponBob=true
    bCanUse=true
    CrouchHeight=40.0000000
    CrouchRadius=34.0000000
    Visibility=128
    DesiredSpeed=1.0000000
    MaxDesiredSpeed=1.0000000
    HearingThreshold=2800.0000000
    SightRadius=5000.0000000
    AvgPhysicsTime=0.1000000
    GroundSpeed=600.0000000
    WaterSpeed=300.0000000
    AirSpeed=600.0000000
    LadderSpeed=200.0000000
    AccelRate=2048.0000000
    JumpZ=420.0000000
    AirControl=0.0500000
    WalkingPct=0.5000000
    CrouchedPct=0.5000000
    MaxFallSpeed=1200.0000000
    BaseEyeHeight=64.0000000
    EyeHeight=54.0000000
    Health=100
    noise1time=-10.0000000
    noise2time=-10.0000000
    Bob=0.0060000
    SoundDampening=1.0000000
    DamageScaling=1.0000000
    ControllerClass=Class'AIController'
    LandMovementState="PlayerWalking"
    WaterMovementState="PlayerSwimming"
    // Reference: CylinderComponent'Default__Pawn.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="CollisionCylinder" class=Class'CylinderComponent'
        CollisionHeight=78.0000000
        CollisionRadius=34.0000000
        CollideActors=true
        BlockActors=true
    end object
    CylinderComponent=CollisionCylinder
    RBPushRadius=10.0000000
    RBPushStrength=50.0000000
    VehicleCheckRadius=150.0000000
    ViewPitchMin=-16384.0000000
    ViewPitchMax=16383.0000000
    InventoryManagerClass=Class'InventoryManager'
    bUpdateSimulatedPosition=true
    bReplicatePredictedVelocity=true
    UseCharacterLights=true
    UsePawnLights=true
    bCanBeDamaged=true
    bShouldBaseAtStartup=true
    bCanTeleport=true
    bCollideActors=true
    bCollideWorld=true
    bBlockActors=true
    bProjTarget=true
    // Reference: SpriteComponent'Default__Pawn.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__Actor.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    // Reference: ArrowComponent'Default__Pawn.Arrow'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="Arrow" class=Class'ArrowComponent'
        ArrowColor=(R=150,G=200,B=255,A=255)
    end object
    Components[2]=Arrow
    RemoteRole=1
    NetPriority=2.0000000
    CollisionComponent=CollisionCylinder
    RotationRate=(Pitch=4096,Yaw=20000,Roll=3072)
}