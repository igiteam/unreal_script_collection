class TurokVehicle extends SVehicle
    abstract
    native
    nativereplication
    config(Game)
    hidecategories(Navigation);

enum VehicleStuckState
{
    VSTUCK_None,                    // 0
    VSTUCK_Reverse,                 // 1
    VSTUCK_Forward,                 // 2
    VSTUCK_MAX                      // 3
};

struct native DamageLevel
{
    var float mModifier;
    var @NULL mDamageSound;

    structdefaultproperties
    {
        mModifier=0.0000000
        mDamageSound=none
    }
};

struct native DamageTypeMultiplier
{
    var() class<Class> DamageType;
    var() float multiplier;

    structdefaultproperties
    {
        DamageType=none
        multiplier=0.0000000
    }
};

struct native VehicleEffect
{
    var() name EffectStartTag;
    var() name EffectEndTag;
    var() @NULL EffectTemplate;
    var() name EffectSocket;
    var export editinline @NULL EffectRef;

    structdefaultproperties
    {
        EffectStartTag="None"
        EffectEndTag="None"
        EffectTemplate=none
        EffectSocket="None"
        EffectRef=none
    }
};

struct native TimePosition
{
    var @NULL Position;
    var float Time;

    structdefaultproperties
    {
        Position=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Time=0.0000000
    }
};

var(Sound) export editinline @NULL mSoundController;
var bool bDriverHoldsFlag;
var bool bCanCarryFlag;
var bool bKeyVehicle;
var bool bDefensive;
var bool bEjectPassengersWhenFlipped;
var bool bMustBeUpright;
var bool bNeverReset;
var bool bEjectKilledBodies;
var bool bLightArmor;
var bool bShouldLeaveForCombat;
var bool bDrawHealthOnHUD;
var bool bHomingTarget;
var(Weapon) protected const bool bUseCurrentWeapon;
var private bool mWasPawnDualWielding;
var bool bIsScraping;
var bool bReducedFallingCollisionDamage;
var private bool mbEnabled;
var bool bUnlimitedCameraDistance;
var bool bLookDownCamera;
var bool bRotateCameraUnderVehicle;
var(Camera) bool bNoZSmoothing;
var bool mbTurretPlayingAudio;
var bool mbIsScriptedMoving;
var float LastCheckUpsideDownTime;
var float FlippedCount;
var float VehicleLostTime;
var float PlayerStartTime;
var float RespawnTime;
var float InitialSpawnDelay;
var float LinkHealMult;
var float MaxDesireability;
var float ObjectiveGetOutDist;
var array HornSounds;
var float LastHornTime;
var export editinline @NULL LightEnvironment;
var @NULL LockedOnSound;
var class<Class> RanOverDamageType;
var float MinRunOverSpeed;
var @NULL RanOverSound;
var float LastRunOverWarningTime;
var float MinRunOverWarningAim;
var @NULL NextVehicle;
var @NULL Reservation;
var float ResetTime;
var const localized string VehiclePositionString;
var const localized string VehicleNameString;
var() export editinline array Seats;
var(Weapon) protected const class<Class> GunClass;
var(Weapon) const int GunSeatIndex;
var(Weapon) protected const name AimBone;
var(Weapon) protected const name GunInActiveSocket;
var(Weapon) protected const name TurretControlName;
var repnotify @NULL mVehicleGun;
var @NULL mPendingDriver;
var protected @NULL TurretController;
var private const config string GunClassAbbrev;
var(Effects) array VehicleEffects;
var() float mWheelSlipEffectMax;
var float LastJumpOutCheck;
var(Sounds) const editconst export editinline @NULL ScrapeSound;
var float SpawnRadius;
var() array mDamageTypesMultiplier;
var() float CollisionDamageMult;
var float LastCollisionDamageTime;
var protected @NULL mSteeringController;
var protected name mSteeringControlName;
var(Seats) float SeatCameraScale;
var float CameraScaleMin;
var float CameraScaleMax;
var(Camera) float CameraSmoothingFactor;
var array OldPositions;
var(Camera) float CameraLag;
var @NULL CameraOffset;
var float LookForwardDist;
var(Sound) int mDamageLevelIndex;
var(Sound) export editinline array mDamagedEngineSndComponents;
var(Sound) array mDamageLevels;
var(Sound) float suspensionDeltaMin;
var(Sound) float suspensionDeltaLandMin;
var(Sound) float suspensionDeltaMax;
var int prevPitch;
var float prevYaw;
var int mTurretSoundChannelIndex;
var int mPitchClickThresh;
var int mPitchDirection;
var int mPitchLastPlayed;
var int mTurretRotateAudioDeltaThresh;
var @NULL mTurretPitchClickSndCue;
var @NULL mTurretStartStopSndCue;
var @NULL mTurretRotateSndCue;
var @NULL mCurrentDestination;
var @NULL mStartLocation;
var float mLastThrottle;
var float mLastForwardVel;
var float mLastPursuitDistance;
var float mLastSteering;
var byte mStuckState;
var(Multiplayer) private noclear export editinline @NULL mGameModeRestriction;

replication
{
    // Pos:0x000
    if(bNetDirty
        mVehicleGun;
}

// Export UTurokVehicle::execDrawVehicleState3D(FFrame&, void* const)
native final function DrawVehicleState3D(@NULL HUD);

// Export UTurokVehicle::execGetNumSeats(FFrame&, void* const)
native function int GetNumSeats();

// Export UTurokVehicle::execLimitRiderRotation(FFrame&, void* const)
native function @NULL LimitRiderRotation(int SeatIndex, @NULL CurRotation);

// Export UTurokVehicle::execForceWeaponRotation(FFrame&, void* const)
native function ForceWeaponRotation(int SeatIndex, @NULL NewRotation);

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    InitializeSeats();
    InitializeEffects();
    InitializeVehicleGun();
    mSteeringController = TurokSkelControlProceduralTranslation(Mesh.FindSkelControl(mSteeringControlName));
    Mesh.WakeRigidBody();
    //return;    
}

function Reset()
{
    // End:0x84
    if(((GunClass != none) && GunSeatIndex != -1) && Seats[GunSeatIndex].GetSeatedPawn() != none)
    {
        TurretController.SetSkelControlActive(false);
        mVehicleGun = __NFUN_278__(GunClass, self);
        Seats[GunSeatIndex].Initialize();
        AttachVehicleGun();
    }
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0xCC
    if(VarName == 'mVehicleGun')
    {
        // End:0xCA
        if(mVehicleGun != none)
        {
            // End:0x81
            if(!Mesh.IsComponentAttached(mVehicleGun.Mesh) && mPendingDriver == none)
            {
                TurretController.SetSkelControlActive(false);
                Seats[GunSeatIndex].Initialize();
                AttachVehicleGun();
            }
            // End:0xCA
            if((mPendingDriver != none) && Seats[mPendingDriver.mSeatIndex].GetSeatedPawn() == none)
            {
                mPendingDriver.StartDriving(self);
            }
        }
        return;
    }
    super(Vehicle).ReplicatedEvent(VarName);
    //return;    
}

function OnLockVehicleSeat(@NULL Action)
{
    local int Index;

    Index = Action.mSeatIndex;
    Seats[Index].SetLockPlayerEnter(Action.mbPlayerEnter);
    Seats[Index].SetLockPlayerExit(Action.mbPlayerExit);
    Seats[Index].SetLockAIEnter(Action.mbAIEnter);
    Seats[Index].SetLockAIExit(Action.mbAIExit);
    //return;    
}

function OnToggleEnableVehicle(@NULL Action)
{
    SetEnabled(Action.mbEnable);
    //return;    
}

function OnVehicleBrakeControl(@NULL Action)
{
    //return;    
}

function OnAIExitVehicle(@NULL Action)
{
    // End:0x25
    if(Driver != none)
    {
        PawnExit(0, Action.mbSkipAnimation);
    }
    //return;    
}

simulated function InitializeEffects()
{
    local int I;

    // End:0x1B
    if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
    {
        return;
    }
    I = 0;
    J0x22:

    // End:0x147 [Loop If]
    if(I < VehicleEffects.Length)
    {
        // End:0x13D
        if(VehicleEffects[I].EffectTemplate != none)
        {
            VehicleEffects[I].EffectRef = new (self) Class'Engine.ParticleSystemComponent';
            // End:0xB1
            if(VehicleEffects[I].EffectStartTag != 'BeginPlay')
            {
                VehicleEffects[I].EffectRef.bAutoActivate = false;
            }
            Mesh.AttachComponentToSocket(VehicleEffects[I].EffectRef, VehicleEffects[I].EffectSocket);
            VehicleEffects[I].EffectRef.SetTemplate(VehicleEffects[I].EffectTemplate);
            VehicleEffects[I].EffectRef.DeactivateSystem();
        }
        I++;
        // [Loop Continue]
        goto J0x22;
    }
    //return;    
}

simulated function PlayEffect(int EffectIndex)
{
    // End:0x62
    if(((VehicleEffects.Length > EffectIndex) && VehicleEffects[EffectIndex].EffectRef != none) && !IsEffectPlaying(EffectIndex))
    {
        VehicleEffects[EffectIndex].EffectRef.ActivateSystem();
    }
    //return;    
}

simulated function StopEffect(int EffectIndex)
{
    // End:0x4C
    if((VehicleEffects.Length > EffectIndex) && VehicleEffects[EffectIndex].EffectRef != none)
    {
        VehicleEffects[EffectIndex].EffectRef.DeactivateSystem();
    }
    //return;    
}

function bool IsEffectPlaying(int EffectIndex)
{
    // End:0x4D
    if((VehicleEffects.Length > EffectIndex) && VehicleEffects[EffectIndex].EffectRef != none)
    {
        return VehicleEffects[EffectIndex].EffectRef.bIsActive;
    }
    return false;
    //return ReturnValue;    
}

simulated function @NULL GetTurretController()
{
    return TurretController;
    //return ReturnValue;    
}

event PhysicsVolumeChange(@NULL NewVolume)
{
    //return;    
}

event RanInto(@NULL Other)
{
    local @NULL Momentum;
    local float Speed;
    local @NULL InstigatorController;
    local float Damage;
    local @NULL HitInfo;

    // End:0x50
    if((((Pawn(Other) == none) || Vehicle(Other) != none) || Other == Instigator) || int(Other.Role) != int(ROLE_Authority))
    {
        return;
    }
    Speed = VSize(Velocity);
    // End:0x19C
    if(Speed > MinRunOverSpeed)
    {
        Momentum = (Velocity * 0.2500000) * Other.Mass;
        // End:0xA8
        if(RanOverSound != none)
        {
            PlaySound(RanOverSound);
        }
        // End:0xC1
        if(Controller != none)
        {
            InstigatorController = Controller;            
        }
        else
        {
            // End:0xE0
            if(Instigator != none)
            {
                InstigatorController = Instigator.Controller;
            }
        }
        Damage = Speed * 0.0750000;
        Other.TakeDamage(int(Damage), InstigatorController, Other.Location, Momentum, RanOverDamageType);
        HitInfo.BoneName = 'jt_Cog_C';
        HitInfo.HitComponent = Pawn(Other).Mesh;
        Other.TakeImpact(RanOverDamageType, Damage, Other.Location, Momentum, HitInfo);
    }
    //return;    
}

function KillPassengers(@NULL Killer, class<Class> DamageType, @NULL HitLocation)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x8F [Loop If]
    if(I < (GetNumSeats()))
    {
        // End:0x85
        if(Seats[I].IsOccupied())
        {
            // End:0x7B
            if(I > 0)
            {
                Seats[I].GetOccupant().Died(Killer, DamageType, HitLocation);
                // [Explicit Continue]
                goto J0x85;
            }
            KillDriver();
        }
        J0x85:

        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function KillDriver()
{
    // End:0x0D
    if(Driver == none)
    {
        return;
    }
    // End:0x77
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x6B
        if(bEjectKilledBodies)
        {
            Driver.TearOffMomentum = Velocity * 0.2500000;
            Driver.Died(none, RanOverDamageType, Driver.Location);            
        }
        else
        {
            Driver.Destroy();
        }
    }
    //return;    
}

function bool IsEnabled()
{
    return mbEnabled;
    //return ReturnValue;    
}

function SetEnabled(bool bEnabled)
{
    mbEnabled = bEnabled;
    //return;    
}

simulated function SetInputs(float InForward, float InStrafe, float InUp)
{
    // End:0x2D
    if(mbEnabled)
    {
        Throttle = InForward;
        Steering = InStrafe;
        Rise = InUp;        
    }
    else
    {
        Throttle = 0.0000000;
        Steering = 0.0000000;
        Rise = 0.0000000;
    }
    //return;    
}

function bool SeatAvailable(int SeatIndex)
{
    return false == Seats[SeatIndex].IsOccupied();
    //return ReturnValue;    
}

function bool IsPawnInGunSeat(@NULL Pawn)
{
    // End:0x23
    if((GunSeatIndex < 0) || GunSeatIndex >= (GetNumSeats()))
    {
        return false;
    }
    // End:0x36
    if(Seats[GunSeatIndex] == none)
    {
        return false;
    }
    return Pawn == Seats[GunSeatIndex].GetOccupant();
    //return ReturnValue;    
}

function bool HasPriority(@NULL first, @NULL Second)
{
    // End:0x38
    if(((first != Second) && PlayerController(first) != none) && PlayerController(Second) == none)
    {
        return true;        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

function bool Died(@NULL Killer, class<Class> DamageType, @NULL HitLocation)
{
    // End:0x68
    if(super(Vehicle).Died(Killer, DamageType, HitLocation))
    {
        // End:0x37
        if(Killer != none)
        {
            Instigator = Killer.Pawn;
        }
        HitDamageType = DamageType;
        TakeHitLocation = HitLocation;
        KillPassengers(Killer, DamageType, HitLocation);
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated event Destroyed()
{
    mSoundController.StopVehicleSound();
    super.Destroyed();
    //return;    
}

function bool CanEnterVehicle(@NULL P)
{
    // End:0x85
    if(((((P.bIsCrouched || P.DrivenVehicle != none) || P.Controller == none) || !P.Controller.bIsPlayer) || P.IsA('Vehicle')) || Health <= 0)
    {
        return false;
    }
    return WorldInfo.Game.CanEnterVehicle(self, P);
    //return ReturnValue;    
}

simulated function bool SimulatedCanEnterVehicle(@NULL P)
{
    // End:0x85
    if(((((P.bIsCrouched || P.DrivenVehicle != none) || P.Controller == none) || !P.Controller.bIsPlayer) || P.IsA('Vehicle')) || Health <= 0)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function bool TryToDrive(@NULL P)
{
    local @NULL X, Y, Z, socketPos, socketRot;

    local float dist;
    local int I;

    // End:0x99
    if(((bIsInverted && bMustBeUpright) && !bVehicleOnGround) && VSize(Velocity) <= 5.0000000)
    {
        // End:0x97
        if(bCanFlip)
        {
            bIsUprighting = true;
            UprightStartTime = WorldInfo.TimeSeconds;
            GetAxes(Rotation, X, Y, Z);
            bFlipRight = ((P.Location - Location) Dot Y) > float(0);
        }
        return false;
    }
    // End:0xAF
    if(!CanEnterVehicle(P))
    {
        return false;
    }
    I = 0;
    J0xB6:

    // End:0x19A [Loop If]
    if(I < (GetNumSeats()))
    {
        // End:0x190
        if((Seats[I].EntrySocket != 'None') && Mesh.GetSocketWorldLocationAndRotation(Seats[I].EntrySocket, socketPos, socketRot))
        {
            dist = VSize(P.Location - socketPos);
            // End:0x190
            if(dist < Seats[I].EntryRadius)
            {
                // End:0x190
                if(Seats[I].CanPawnEnter(P))
                {
                    return PawnEnter(P, I);
                }
            }
        }
        ++I;
        // [Loop Continue]
        goto J0xB6;
    }
    return false;
    //return ReturnValue;    
}

simulated function bool SimulatedTestTryToDrive(@NULL P)
{
    local @NULL X, Y, Z, socketPos, socketRot;

    local float dist;
    local int I;

    // End:0x99
    if(((bIsInverted && bMustBeUpright) && !bVehicleOnGround) && VSize(Velocity) <= 5.0000000)
    {
        // End:0x97
        if(bCanFlip)
        {
            bIsUprighting = true;
            UprightStartTime = WorldInfo.TimeSeconds;
            GetAxes(Rotation, X, Y, Z);
            bFlipRight = ((P.Location - Location) Dot Y) > float(0);
        }
        return false;
    }
    // End:0xAF
    if(!SimulatedCanEnterVehicle(P))
    {
        return false;
    }
    I = 0;
    J0xB6:

    // End:0x186 [Loop If]
    if(I < (GetNumSeats()))
    {
        // End:0x17C
        if((Seats[I].EntrySocket != 'None') && Mesh.GetSocketWorldLocationAndRotation(Seats[I].EntrySocket, socketPos, socketRot))
        {
            dist = VSize(P.Location - socketPos);
            // End:0x17C
            if(dist < Seats[I].EntryRadius)
            {
                // End:0x17C
                if(Seats[I].CanPawnEnter(P))
                {
                    return true;
                }
            }
        }
        ++I;
        // [Loop Continue]
        goto J0xB6;
    }
    return false;
    //return ReturnValue;    
}

function bool Dodge(byte DoubleClickMove)
{
    //return ReturnValue;    
}

function PlayHorn(int HornIndex)
{
    // End:0x52
    if((((WorldInfo.TimeSeconds - LastHornTime) > 3.0000000) && HornIndex >= 0) && HornIndex < HornSounds.Length)
    {
        LastHornTime = WorldInfo.TimeSeconds;
    }
    //return;    
}

function UpdateControllerOnPossess(bool bVehicleTransition)
{
    //return;    
}

simulated function int NumPassengers()
{
    local int I, Num;

    I = 0;
    J0x07:

    // End:0x48 [Loop If]
    if(I < (GetNumSeats()))
    {
        // End:0x3E
        if(Seats[I].IsOccupied())
        {
            Num++;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return Num;
    //return ReturnValue;    
}

function int GetFirstAvailableSeat()
{
    local int I;

    I = 1;
    J0x07:

    // End:0x3D [Loop If]
    if(I < (GetNumSeats()))
    {
        // End:0x33
        if(SeatAvailable(I))
        {
            return I;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return -1;
    //return ReturnValue;    
}

event PawnDied(@NULL P)
{
    local @NULL tph;

    tph = TurokPawnHuman(P);
    PawnExit(tph.mSeatIndex, false);
    //return;    
}

event bool PawnEnter(@NULL P, int I, optional bool skipAnimation = false)
{
    local @NULL tph;

    // DebugMode: 0
    assert(Seats[I] != none);
    // DebugMode: 0
    assert((I >= 0) && I < (GetNumSeats()));
    tph = TurokPawnHuman(P);
    // End:0x109
    if((((I == GunSeatIndex) && tph != none) && tph.Controller != none) && Seats[I].GetSeatedPawn() == none)
    {
        // DebugMode: 0
        assert(tph.DrivenVehicle == none);
        tph.mSeatIndex = I;
        // End:0xE2
        if(skipAnimation)
        {
            tph.mSeatInOut = 1;            
        }
        else
        {
            tph.mSeatInOut = 2;
        }
        tph.StartDriving(self);
        return true;
    }
    return false;
    //return ReturnValue;    
}

event PawnExit(int I, bool forcedOut)
{
    local @NULL tph;
    local bool TPHdied, canExit;

    // DebugMode: 0
    assert(Seats[I] != none);
    // DebugMode: 0
    assert((I >= 0) && I < (GetNumSeats()));
    tph = TurokPawnHuman(Seats[I].GetSeatedPawn());
    // End:0x87
    if(tph == none)
    {
        tph = TurokPawnHuman(Seats[I].GetEnteringPawn());
    }
    // End:0x20E
    if(tph != none)
    {
        // End:0xBF
        if(tph.Mesh != none)
        {
            tph.Mesh.SetShadowParent(none);
        }
        TPHdied = tph.Health <= 0;
        canExit = Seats[I].CanPawnExit(tph.Controller);
        // End:0x20B
        if((canExit || forcedOut) || TPHdied)
        {
            // DebugMode: 0
            assert(tph.DrivenVehicle != none);
            // End:0x156
            if(forcedOut)
            {
                tph.mSeatInOut = 6;                
            }
            else
            {
                // End:0x1CE
                if(TPHdied)
                {
                    // End:0x196
                    if(tph == Seats[I].GetSeatedPawn())
                    {
                        tph.mSeatInOut = 8;                        
                    }
                    else
                    {
                        // DebugMode: 0
                        assert(tph == Seats[I].GetEnteringPawn());
                        tph.mSeatInOut = 3;
                    }                    
                }
                else
                {
                    tph.mSeatInOut = 7;
                }
            }
            // End:0x1F7
            if(IsPawnInGunSeat(self))
            {
                StopTurretSound();
            }
            tph.StopDriving(self);
        }        
    }
    //return;    
}

function bool DriverEnter(@NULL P)
{
    // DebugMode: 0
    assert(false);
    return false;
    //return ReturnValue;    
}

simulated function EquipSeatWeapon(@NULL tph)
{
    local @NULL mgr;

    DetachVehicleGun();
    mgr = TurokInventoryManager(tph.InvManager);
    // End:0x2FD
    if(mgr != none)
    {
        // DebugMode: 0
        assert((int(tph.Role) == int(ROLE_Authority)) || int(tph.Role) == int(ROLE_AutonomousProxy));
        // DebugMode: 0
        assert(tph.Health > 0);
        mgr.CancelWeaponSwapping();
        // DebugMode: 0
        assert(tph.GetPrimaryWeapon() != mVehicleGun);
        tph.ActivateWeapons(false);
        // End:0x130
        if(int(tph.Role) == int(ROLE_Authority))
        {
            // DebugMode: 0
            assert(mgr.GetWeapon(GunClass) == none);
            mgr.AddInventory(mVehicleGun, true);
            // DebugMode: 0
            assert(mgr.GetWeapon(GunClass) != none);            
        }
        else
        {
            // End:0x16B
            if(mgr.GetWeapon(GunClass) != mVehicleGun)
            {
                mgr.AddInventory(mVehicleGun, true);
            }
            // DebugMode: 0
            assert(mgr.GetWeapon(GunClass) == mVehicleGun);
            TurokNetLog((((("mVehicleGun.Owner=" $ string(mVehicleGun.Owner)) @ "mVehicleGun.Instigator=") $ string(mVehicleGun.Instigator)) @ "mVehicleGun.InvManager=") $ string(mVehicleGun.InvManager));
            // End:0x23D
            if(mVehicleGun.Owner != tph)
            {
                mVehicleGun.SetOwner(tph);
            }
            // End:0x269
            if(mVehicleGun.Instigator != tph)
            {
                mVehicleGun.Instigator = tph;
            }
            // End:0x295
            if(mVehicleGun.InvManager != mgr)
            {
                mVehicleGun.InvManager = mgr;
            }
        }
        mWasPawnDualWielding = tph.mWeaponMediator.IsDualWielding();
        tph.SetWeaponsInstantSwitch(0, true);
        tph.SetWeaponsInstantSwitch(1, true);
        mgr.TurokSimulatedSetCurrentWeapon(mVehicleGun, false);
    }
    // DebugMode: 0
    assert(TurretController != none);
    TurretController.SetSkelControlActive(true);
    //return;    
}

simulated function UnEquipSeatWeapon(@NULL tph, optional bool bDisableTurret = true)
{
    local @NULL mgr, prevGun;

    // DebugMode: 0
    assert(TurretController != none);
    // End:0x2A
    if(bDisableTurret)
    {
        TurretController.SetSkelControlActive(false);
    }
    mgr = TurokInventoryManager(tph.InvManager);
    // End:0x17A
    if(mgr != none)
    {
        // End:0x102
        if(tph.GetPrimaryWeapon() == mVehicleGun)
        {
            prevGun = TurokWeapon(mgr.GetPreviousWeapon());
            // DebugMode: 0
            assert(prevGun != mVehicleGun);
            tph.SetWeaponsInstantSwitch(0, true);
            tph.SetWeaponsInstantSwitch(1, true);
            mgr.TurokSimulatedSetCurrentWeapon(prevGun, mWasPawnDualWielding);
            // End:0x102
            if(prevGun != none)
            {
                tph.ActivateWeapons(true);
            }
        }
        // End:0x17A
        if(mgr.GetWeapon(GunClass) != none)
        {
            // DebugMode: 0
            assert(mgr.GetWeapon(GunClass) == mVehicleGun);
            mgr.RemoveWeaponFromInventory(mVehicleGun);
            // DebugMode: 0
            assert(mgr.GetWeapon(GunClass) == none);
        }
    }
    AttachVehicleGun();
    //return;    
}

// Export UTurokVehicle::execIsExitPosClear(FFrame&, void* const)
native function bool IsExitPosClear(int SeatIndex, @NULL seatPos, @NULL ExitPos);

// Export UTurokVehicle::execGetExitPosOnGround(FFrame&, void* const)
native function bool GetExitPosOnGround(int SeatIndex, @NULL seatPos, out @NULL ExitPos, optional bool checkClearToExit);

simulated function bool DetermineActualExitPos(@NULL ExitingDriver, out @NULL ExitPos, out int isFalling, optional bool checkClearToExit = true)
{
    local @NULL seatBoneLocation;
    local int SeatIndex;

    isFalling = 0;
    SeatIndex = TurokPawnHuman(ExitingDriver).mSeatIndex;
    seatBoneLocation = Mesh.GetBoneLocation(Seats[SeatIndex].SeatBone);
    // End:0x9B
    if(!GetExitPosOnGround(SeatIndex, seatBoneLocation, ExitPos, checkClearToExit))
    {
        // End:0x99
        if(IsExitPosClear(SeatIndex, seatBoneLocation, ExitPos))
        {
            isFalling = 1;            
        }
        else
        {
            return false;
        }
    }
    return true;
    //return ReturnValue;    
}

simulated function bool AttemptToExitAtPos(@NULL ExitingDriver, @NULL ExitPos, optional bool checkClearToExit = true)
{
    local int isFalling;
    local bool moveResult;

    moveResult = false;
    // End:0xC1
    if(DetermineActualExitPos(ExitingDriver, ExitPos, isFalling, checkClearToExit))
    {
        moveResult = ExitingDriver.SetLocation(ExitPos + (ExitingDriver.GetCollisionHeight() * vect(0.0000000, 0.0000000, 1.0000000)));
        // End:0x87
        if(isFalling == 1)
        {
            ExitingDriver.SetPhysics(2);            
        }
        else
        {
            // End:0xB3
            if(ExitingDriver.PhysicsVolume.bWaterVolume)
            {
                ExitingDriver.SetPhysics(3);                
            }
            else
            {
                ExitingDriver.SetPhysics(1);
            }
        }
    }
    return moveResult;
    //return ReturnValue;    
}

simulated function bool AttemptToExitAtAnyAutoPos(@NULL ExitingDriver)
{
    local @NULL FacingDir, CrossProduct;
    local float PlaceDist;

    FacingDir = Vector(Rotation);
    CrossProduct = Normal(FacingDir Cross vect(0.0000000, 0.0000000, 1.0000000));
    // End:0x46
    if(ExitRadius == float(0))
    {
        ExitRadius = GetCollisionRadius();
    }
    PlaceDist = ExitRadius + ExitingDriver.GetCollisionRadius();
    return (((AttemptToExitAtPos(ExitingDriver, ((GetTargetLocation()) + ExitOffset) + (PlaceDist * CrossProduct))) || AttemptToExitAtPos(ExitingDriver, ((GetTargetLocation()) + ExitOffset) - (PlaceDist * CrossProduct))) || AttemptToExitAtPos(ExitingDriver, ((GetTargetLocation()) + ExitOffset) - (PlaceDist * FacingDir))) || AttemptToExitAtPos(ExitingDriver, ((GetTargetLocation()) + ExitOffset) + (PlaceDist * FacingDir));
    //return ReturnValue;    
}

simulated function bool AttemptToExitAtAnySocketPos(@NULL exitingPassenger, int SeatIndex)
{
    local @NULL ExitPos;
    local int I;

    // End:0x20
    if(!Seats[SeatIndex].IsOccupied())
    {
        return false;
    }
    I = 0;
    J0x27:

    // End:0x9F [Loop If]
    if(I < Seats[SeatIndex].mExitSockets.Length)
    {
        // End:0x95
        if(Mesh.GetSocketWorldLocationAndRotation(Seats[SeatIndex].mExitSockets[I], ExitPos))
        {
            // End:0x95
            if(AttemptToExitAtPos(exitingPassenger, ExitPos))
            {
                return true;
                // [Explicit Continue]
            }
        }
        ++I;
        // [Loop Continue]
        goto J0x27;
    }
    return false;
    //return ReturnValue;    
}

simulated function bool AttemptToExitAtFailSafePos(@NULL exitingPassenger, int SeatIndex)
{
    return AttemptToExitAtPos(exitingPassenger, Seats[SeatIndex].mFailsafeLocation, false);
    //return ReturnValue;    
}

simulated function bool ShouldTryCOGForExitLocation()
{
    return true;
    //return ReturnValue;    
}

simulated function bool PlaceExitingPassenger(@NULL exitingPassenger, int SeatIndex)
{
    local @NULL cogBoneLocation;

    // End:0x6E
    if(ShouldTryCOGForExitLocation())
    {
        cogBoneLocation = exitingPassenger.Mesh.GetBoneLocation('jt_Cog_C');
        cogBoneLocation.Z = Location.Z;
        // End:0x6E
        if(AttemptToExitAtPos(exitingPassenger, cogBoneLocation))
        {
            return true;
        }
    }
    // End:0x87
    if(AttemptToExitAtAnySocketPos(exitingPassenger, SeatIndex))
    {
        return true;
    }
    // End:0x9B
    if(AttemptToExitAtAnyAutoPos(exitingPassenger))
    {
        return true;
    }
    return AttemptToExitAtFailSafePos(exitingPassenger, SeatIndex);
    //return ReturnValue;    
}

simulated function AttachDriver(@NULL P)
{
    OldPositions.Remove(0, OldPositions.Length);
    EyeHeight = BaseEyeHeight;
    AttachPawn(P, 0);
    //return;    
}

simulated function AttachPawn(@NULL P, int SeatIndex)
{
    local @NULL TP, relLoc;

    // End:0x0D
    if(!bAttachDriver)
    {
        return;
    }
    TP = TurokPawn(P);
    // End:0x1E2
    if((TP != none) && TP.Mesh != none)
    {
        TP.ResetTerrainFollowOffset();
        TP.SetCollision(TP.bCollideActors, false, TP.bIgnoreEncroachers);
        TP.bCollideWorld = false;
        TP.SetPhysics(0);
        TP.SetBase(none);
        TP.SetHardAttach(true);
        TP.SetLocation(Location);
        TP.SetBase(self,, Mesh, Seats[SeatIndex].SeatBone);
        relLoc = -TP.Mesh.Translation;
        relLoc.X += -5.0000000;
        relLoc.Z += 2.0000000;
        TP.SetRelativeLocation(relLoc);
        TP.SetRelativeRotation(rot(0, 0, 0));
        // End:0x1CE
        if(Seats[SeatIndex].bSeatVisible)
        {
            TP.Mesh.CullDistance = 5000.0000000;
            // End:0x1CB
            if(Mesh != none)
            {
                TP.Mesh.SetShadowParent(Mesh);
            }            
        }
        else
        {
            TP.SetHidden(true);
        }
    }
    //return;    
}

event CheckReset()
{
    local @NULL C;

    // End:0x31
    if(bKeyVehicle && !Occupied())
    {
        Died(none, Class'Engine.DamageType', Location);
        return;
    }
    // End:0x59
    if(Occupied())
    {
        ResetTime = WorldInfo.TimeSeconds - float(1);
        return;
    }
    // End:0x142
    foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
    {
        // End:0x141
        if(((C.Pawn != none) && VSize(Location - C.Pawn.Location) < float(2500)) && FastTrace(C.Pawn.Location + (C.Pawn.GetCollisionHeight() * vect(0.0000000, 0.0000000, 1.0000000)), Location + ((GetCollisionHeight()) * vect(0.0000000, 0.0000000, 1.0000000))))
        {
            ResetTime = WorldInfo.TimeSeconds + float(10);            
            return;
        }        
    }    
    Destroy();
    //return;    
}

function bool Occupied()
{
    local int I;

    // End:0x0D
    if(Controller != none)
    {
        return true;
    }
    I = 0;
    J0x14:

    // End:0x48 [Loop If]
    if(I < (GetNumSeats()))
    {
        // End:0x3E
        if(!SeatAvailable(I))
        {
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x14;
    }
    return false;
    //return ReturnValue;    
}

function bool OpenPositionFor(@NULL P)
{
    local int I;

    // End:0x0D
    if(Controller == none)
    {
        return true;
    }
    I = 0;
    J0x14:

    // End:0x46 [Loop If]
    if(I < (GetNumSeats()))
    {
        // End:0x3C
        if(SeatAvailable(I))
        {
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x14;
    }
    return false;
    //return ReturnValue;    
}

function AdjustDamage(out int inDamage, out @NULL Momentum, @NULL InstigatedBy, @NULL HitLocation, class<Class> DamageType, optional @NULL HitInfo)
{
    // End:0x15
    if(InGodMode())
    {
        inDamage = 0;
    }
    //return;    
}

simulated function TakeDamage(int Damage, @NULL InstigatedBy, @NULL HitLocation, @NULL Momentum, class<Class> DamageType, optional @NULL HitInfo, optional @NULL DamageCauser)
{
    local int Index;
    local @NULL currentSeat, currentPawn;

    PlayDamagedEngineSound();
    super(Vehicle).TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo);
    Index = 0;
    J0x38:

    // End:0x161 [Loop If]
    if(Index < Seats.Length)
    {
        currentSeat = Seats[Index];
        currentPawn = none;
        // End:0x97
        if(currentSeat.IsOccupied())
        {
            currentPawn = TurokPawn(currentSeat.GetOccupant());            
        }
        else
        {
            // End:0xCB
            if(currentSeat.IsPawnEntering())
            {
                currentPawn = TurokPawn(currentSeat.GetEnteringPawn());
            }
        }
        // End:0x157
        if(currentPawn != none)
        {
            // End:0x118
            if(TurokAIController(currentPawn.Controller) != none)
            {
                TurokAIController(currentPawn.Controller).NotifyVehicleTakeHit(InstigatedBy);
                // [Explicit Continue]
                goto J0x157;
            }
            // End:0x157
            if(TurokPlayerController(currentPawn.Controller) != none)
            {
                TurokPlayerController(currentPawn.Controller).NotifyVehicleTakeHit(InstigatedBy);
            }
        }
        J0x157:

        Index++;
        // [Loop Continue]
        goto J0x38;
    }
    //return;    
}

simulated function InitializeSeats()
{
    local int I;

    // End:0x12
    if((GetNumSeats()) == 0)
    {
        return;
    }
    I = 0;
    J0x19:

    // End:0x80 [Loop If]
    if(I < (GetNumSeats()))
    {
        Seats[I].MyVehicle = self;
        Seats[I].MyIndex = I;
        Seats[I].Initialize();
        I++;
        // [Loop Continue]
        goto J0x19;
    }
    //return;    
}

simulated function InitializeVehicleGun()
{
    // End:0xA3
    if(GunClass != none)
    {
        // End:0x45
        if(int(Role) == int(ROLE_Authority))
        {
            // DebugMode: 0
            assert(mVehicleGun == none);
            mVehicleGun = __NFUN_278__(GunClass, self);
            AttachVehicleGun();
        }
        // DebugMode: 0
        assert(Mesh.FindSkelControl(TurretControlName) != none);
        TurretController = TurokSkelControl_TurretConstrained(Mesh.FindSkelControl(TurretControlName));
        TurretController.SetSkelControlActive(false);
        TurretController.SetPawn(self);
    }
    //return;    
}

simulated function AttachVehicleGun()
{
    // DebugMode: 0
    assert(mVehicleGun != none);
    mVehicleGun.SetOwner(self);
    mVehicleGun.Instigator = self;
    mVehicleGun.SetWeaponVisibility(true);
    mVehicleGun.mWeaponMesh.SetTraceBlocking(true, true);
    mVehicleGun.mWeaponMesh.SetLightEnvironment(LightEnvironment);
    Mesh.AttachComponentToSocket(mVehicleGun.Mesh, GunInActiveSocket);
    //return;    
}

simulated function DetachVehicleGun()
{
    // DebugMode: 0
    assert(mVehicleGun != none);
    mVehicleGun.SetWeaponVisibility(false);
    Mesh.DetachComponent(mVehicleGun.Mesh);
    mVehicleGun.mWeaponMesh.SetLightEnvironment(none);
    mVehicleGun.mWeaponMesh.SetTraceBlocking(false, true);
    //return;    
}

simulated function bool CalcCamera(float DeltaTime, out @NULL out_CamLoc, out @NULL out_CamRot, out float out_FOV)
{
    VehicleCalcCamera(DeltaTime, 0, out_CamLoc, out_CamRot, out_FOV);
    return true;
    //return ReturnValue;    
}

simulated function @NULL GetCameraStart(int SeatIndex)
{
    local int I, Len, obsolete;
    local @NULL CamStart, NewPos, PrevPos;
    local float DeltaTime;

    Len = OldPositions.Length;
    // End:0x51
    if((Len > 0) && OldPositions[Len - 1].Time == WorldInfo.TimeSeconds)
    {
        return CameraOffset + Location;
    }
    // End:0x11E
    if(Seats[SeatIndex].CameraTag != 'None')
    {
        // End:0x11B
        if(!Mesh.GetSocketWorldLocationAndRotation(Seats[SeatIndex].CameraTag, CamStart))
        {
            CamStart = Mesh.GetBoneLocation(Seats[SeatIndex].CameraTag);
            // End:0x11B
            if(IsZero(CamStart))
            {
                Seats[SeatIndex].CameraTag = 'None';
                CamStart = (GetPawnViewLocation()) - (vect(64.0000000, 0.0000000, -64.0000000) >> Rotation);
            }
        }        
    }
    else
    {
        CamStart = (GetPawnViewLocation()) - (vect(64.0000000, 0.0000000, -64.0000000) >> Rotation);
    }
    // End:0x165
    if((CameraLag == float(0)) || !IsHumanControlled())
    {
        return CamStart;
    }
    NewPos.Time = WorldInfo.TimeSeconds;
    NewPos.Position = CamStart;
    OldPositions[Len] = NewPos;
    // End:0x1CC
    if(Len == 0)
    {
        CameraOffset = CamStart - Location;
        return CamStart;
    }
    DeltaTime = ((Len > 1) ? WorldInfo.TimeSeconds - OldPositions[Len - 2].Time : 0.0000000);
    Len = OldPositions.Length;
    obsolete = 0;
    I = 0;
    J0x227:

    // End:0x455 [Loop If]
    if(I < Len)
    {
        // End:0x280
        if(OldPositions[I].Time < (WorldInfo.TimeSeconds - CameraLag))
        {
            PrevPos = OldPositions[I];
            obsolete++;
            // [Explicit Continue]
            goto J0x44B;
        }
        // End:0x390
        if(obsolete > 0)
        {
            // End:0x2E6
            if((I == 0) || (OldPositions[I].Time - PrevPos.Time) > 0.2000000)
            {
                CamStart = OldPositions[I].Position;                
            }
            else
            {
                CamStart = PrevPos.Position + (((OldPositions[I].Position - PrevPos.Position) * ((WorldInfo.TimeSeconds - CameraLag) - PrevPos.Time)) / (OldPositions[I].Time - PrevPos.Time));
            }
            // End:0x38D
            if(obsolete > 1)
            {
                OldPositions.Remove(0, obsolete - 1);
            }            
        }
        else
        {
            CamStart = OldPositions[I].Position;
        }
        // End:0x42C
        if(DeltaTime > float(0))
        {
            DeltaTime *= CameraSmoothingFactor;
            CameraOffset = ((CamStart - Location) * DeltaTime) + (CameraOffset * (float(1) - DeltaTime));
            // End:0x429
            if(bNoZSmoothing)
            {
                CameraOffset.Z = CamStart.Z - Location.Z;
            }            
        }
        else
        {
            CameraOffset = CamStart - Location;
        }
        return CameraOffset + Location;
        J0x44B:

        I++;
        // [Loop Continue]
        goto J0x227;
    }
    return OldPositions[Len - 1].Position;
    //return ReturnValue;    
}

simulated function VehicleCalcCamera(float DeltaTime, int SeatIndex, out @NULL out_CamLoc, out @NULL out_CamRot, out float out_FOV, optional bool bPivotOnly)
{
    local @NULL CamStart, CamPos, CamDir, HitLocation, HitNormal, CamRotX,
	    CamRotY, CamRotZ, socketOrientation;

    local float ScaledBaseEyeHeight;

    CamStart = GetCameraStart(SeatIndex);
    ScaledBaseEyeHeight = FMax(1.0000000, Sqrt(SeatCameraScale)) * Seats[SeatIndex].CameraEyeHeight;
    Seats[SeatIndex].GetOccupant().EyeHeight = ScaledBaseEyeHeight;
    // End:0xE6
    if((!Seats[SeatIndex].bCameraFreeLook && Seats[SeatIndex].CameraTag != 'None') && Mesh.GetSocketWorldLocationAndRotation(Seats[SeatIndex].CameraTag, CamPos, socketOrientation))
    {
        out_CamRot = socketOrientation;        
    }
    else
    {
        out_CamRot = Seats[SeatIndex].GetOccupant().GetViewRotation();
    }
    GetAxes(out_CamRot, CamRotX, CamRotY, CamRotZ);
    // End:0x17E
    if(bLookDownCamera)
    {
        CamStart += ((Seats[SeatIndex].GetOccupant().EyeHeight + (LookForwardDist * Abs(Vector(Rotation) Dot CamRotZ))) * CamRotZ);        
    }
    else
    {
        CamStart.Z += Seats[SeatIndex].GetOccupant().EyeHeight;
    }
    // End:0x1DE
    if(Trace(HitLocation, HitNormal, CamStart, Location, false) != none)
    {
        CamStart = HitLocation;
    }
    // End:0x1F4
    if(bPivotOnly)
    {
        out_CamLoc = CamStart;
        return;
    }
    CamDir = (CamRotX * Seats[SeatIndex].CameraOffset) * SeatCameraScale;
    // End:0x27D
    if(!bRotateCameraUnderVehicle && CamDir.Z < float(0))
    {
        CamDir *= ((VSize(CamDir) - Abs(CamDir.Z)) / (VSize(CamDir) + Abs(CamDir.Z)));
    }
    CamPos = CamStart + CamDir;
    out_CamLoc = CamPos;
    //return;    
}

simulated function AdjustCameraScale(bool bIn)
{
    // End:0x3C
    if(!bUnlimitedCameraDistance)
    {
        SeatCameraScale = FClamp(SeatCameraScale + ((bIn) ? -0.1000000 : 0.1000000), CameraScaleMin, CameraScaleMax);        
    }
    else
    {
        SeatCameraScale = FMax(0.0000000, SeatCameraScale + ((bIn) ? -0.1000000 : 0.1000000));
    }
    //return;    
}

simulated function float AdjustFOVAngle(float FOVAngle)
{
    return FOVAngle;
    //return ReturnValue;    
}

function bool InGodMode()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x9C [Loop If]
    if(I < (GetNumSeats()))
    {
        // End:0x92
        if(Seats[I].IsOccupied())
        {
            // End:0x92
            if((Seats[I].GetOccupant().Controller != none) && Seats[I].GetOccupant().Controller.bGodMode)
            {
                return true;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return super(Pawn).InGodMode();
    //return ReturnValue;    
}

simulated function int GetHealth(int SeatIndex)
{
    return Health;
    //return ReturnValue;    
}

function float GetCollisionDamageModifier(const out array ContactInfos)
{
    local float Angle;
    local @NULL X, Y, Z;

    // End:0x6E
    if(bReducedFallingCollisionDamage)
    {
        GetAxes(Rotation, X, Y, Z);
        Angle = ContactInfos[0].ContactNormal Dot Z;
        return ((Angle < 0.0000000) ? Square(CollisionDamageMult * (1.0000000 + Angle)) : Square(CollisionDamageMult));        
    }
    else
    {
        return Square(CollisionDamageMult);
    }
    //return ReturnValue;    
}

simulated event RigidBodyCollision(@NULL HitComponent, @NULL OtherComponent, const out array ContactInfos, int ContactIndex)
{
    local int Damage;
    local @NULL InstigatorController, Momentum;
    local float delta0, delta1, relativeSpeed;

    // End:0x1D1
    if(LastCollisionDamageTime != WorldInfo.TimeSeconds)
    {
        super.RigidBodyCollision(HitComponent, OtherComponent, ContactInfos, ContactIndex);
        delta0 = ContactInfos[0].ContactVelocity[0] Dot ContactInfos[0].ContactNormal;
        delta1 = ContactInfos[0].ContactVelocity[1] Dot ContactInfos[0].ContactNormal;
        relativeSpeed = Abs(delta0 - delta1);
        // End:0x101
        if(((OtherComponent != none) && OtherComponent.Owner != none) && OtherComponent.Owner.Mass != float(0))
        {
            relativeSpeed *= OtherComponent.Owner.Mass;            
        }
        else
        {
            relativeSpeed *= Mass;
        }
        Damage = int(relativeSpeed * (GetCollisionDamageModifier(ContactInfos)));
        // End:0x1D1
        if(Damage > 0)
        {
            // End:0x14F
            if(Controller != none)
            {
                InstigatorController = Controller;                
            }
            else
            {
                // End:0x16E
                if(Instigator != none)
                {
                    InstigatorController = Instigator.Controller;
                }
            }
            Momentum = Location - ContactInfos[0].ContactPosition;
            TakeDamage(Damage, InstigatorController, ContactInfos[0].ContactPosition, Momentum, Class'TurokDamageTypeVehicleCollision');
            LastCollisionDamageTime = WorldInfo.TimeSeconds;
        }
    }
    //return;    
}

event PlaySuspensionSound(float deltaSuspension)
{
    // End:0x3A
    if(deltaSuspension >= suspensionDeltaMin)
    {
        mSoundController.PlaySuspensionSound(FClamp(deltaSuspension / suspensionDeltaMax, 0.0000000, 1.0000000));
    }
    //return;    
}

event PlayLandSound(float deltaSuspension)
{
    // End:0x3A
    if(deltaSuspension >= suspensionDeltaLandMin)
    {
        mSoundController.PlayLandSound(FClamp(deltaSuspension / suspensionDeltaMax, 0.0000000, 1.0000000));
    }
    //return;    
}

function PlayDamagedEngineSound()
{
    local int I, J;

    // End:0x1B
    if(!bDriving || mDamageLevels.Length <= 0)
    {
        return;
    }
    I = mDamageLevels.Length - 1;
    J0x2A:

    // End:0x71 [Loop If]
    if(I >= 0)
    {
        // End:0x67
        if(float(Health) <= (float(self.default.Health) * mDamageLevels[I].mModifier))
        {
            // [Explicit Break]
            goto J0x71;
        }
        I--;
        // [Loop Continue]
        goto J0x2A;
    }
    J0x71:

    // End:0xD2
    if(I > mDamageLevelIndex)
    {
        J = mDamageLevelIndex;
        J0x8B:

        // End:0xCF [Loop If]
        if(J <= I)
        {
            mDamagedEngineSndComponents[J] = CreateAudioComponent(mDamageLevels[J].mDamageSound, true, true);
            J++;
            // [Loop Continue]
            goto J0x8B;
        }        
    }
    else
    {
        // End:0xF9
        if(I < mDamageLevelIndex)
        {
            mDamagedEngineSndComponents[I].Stop();            
        }
        else
        {
            return;
        }
    }
    mDamageLevelIndex = I;
    //return;    
}

function StopDamagedEngineSound()
{
    local int I;

    I = 1;
    J0x07:

    // End:0x36 [Loop If]
    if(I < mDamagedEngineSndComponents.Length)
    {
        mDamagedEngineSndComponents[I].Stop();
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

simulated function StartEngineSound()
{
    mSoundController.PlayEngineIdleSound();
    PlayDamagedEngineSound();
    ClearTimer('StartEngineSound');
    ClearTimer('StopEngineSound');
    //return;    
}

simulated function StopEngineSound()
{
    mSoundController.StopEngineSound();
    StopDamagedEngineSound();
    ClearTimer('StartEngineSound');
    ClearTimer('StopEngineSound');
    //return;    
}

simulated event StopTurretSound()
{
    mSoundController.StopAudioChannel(mTurretSoundChannelIndex);
    mbTurretPlayingAudio = false;
    //return;    
}

simulated function StopVehicleSounds()
{
    StopEngineSound();
    StopTurretSound();
    super.StopVehicleSounds();
    //return;    
}

simulated function VehiclePlayEnterSound()
{
    mSoundController.PlayEnterVehicleSound();
    StartEngineSoundTimed();
    //return;    
}

simulated function VehiclePlayExitSound()
{
    mSoundController.PlayExitVehicleSound();
    StopEngineSoundTimed();
    //return;    
}

function bool HasFlareAttached()
{
    local bool bFlared;
    local @NULL Flare;

    bFlared = false;
    // End:0x24
    foreach BasedActors(Class'TurokProjFlareNative', Flare)
    {
        bFlared = true;
        // End:0x24
        break;        
    }    
    return bFlared;
    //return ReturnValue;    
}

simulated function bool VehicleHasGun()
{
    return mVehicleGun != none;
    //return ReturnValue;    
}

defaultproperties
{
    // Reference: TurokVehicleSoundController'Default__TurokVehicle.TurokVehicleSoundControllerComponent'
    begin object name=TurokVehicleSoundControllerComponent class=Class'TurokVehicleSoundController'
    end object
    mSoundController=TurokVehicleSoundControllerComponent
    bCanCarryFlag=true
    bEjectPassengersWhenFlipped=true
    bMustBeUpright=true
    bEjectKilledBodies=true
    bDrawHealthOnHUD=true
    mbEnabled=true
    RespawnTime=15.0000000
    LinkHealMult=0.3500000
    MaxDesireability=0.5000000
    ObjectiveGetOutDist=1000.0000000
    // Reference: DynamicLightEnvironmentComponent'Default__TurokVehicle.MyLightEnvironment'
    begin object name=MyLightEnvironment class=Class'Engine.DynamicLightEnvironmentComponent'
    end object
    LightEnvironment=MyLightEnvironment
    RanOverDamageType=Class'TurokDamageTypeVehicleCollision'
    MinRunOverSpeed=1.0000000
    MinRunOverWarningAim=0.8800000
    GunSeatIndex=-1
    mWheelSlipEffectMax=10.0000000
    SpawnRadius=320.0000000
    CollisionDamageMult=0.0500000
    SeatCameraScale=1.0000000
    CameraScaleMin=0.1500000
    CameraScaleMax=2.0000000
    CameraSmoothingFactor=2.0000000
    CameraLag=0.1500000
    suspensionDeltaMin=1.0000000
    suspensionDeltaLandMin=1.0000000
    suspensionDeltaMax=10.0000000
    mTurretSoundChannelIndex=-1
    mPitchClickThresh=40
    mTurretRotateAudioDeltaThresh=10
    mTurretPitchClickSndCue=SoundCue'SndWeapChainGun.ChainGunTurretPitchClickSndCue'
    mTurretRotateSndCue=SoundCue'SndWeapChainGun.ChainGunTurretLPSndCue'
    bCanFlip=false
    // Reference: RB_StayUprightSetup'Default__TurokVehicle.MyStayUprightSetup'
    begin object name=MyStayUprightSetup
    end object
    StayUprightConstraintSetup=MyStayUprightSetup
    // Reference: RB_ConstraintInstance'Default__TurokVehicle.MyStayUprightConstraintInstance'
    begin object name=MyStayUprightConstraintInstance
    end object
    StayUprightConstraintInstance=MyStayUprightConstraintInstance
    DriverDamageMult=1.0000000
    CrushedDamageType=Class'TurokDamageTypeVehicleRanOver'
    MinCrushSpeed=100.0000000
    BaseEyeHeight=30.0000000
    EyeHeight=30.0000000
    // Reference: SkeletalMeshComponent'Default__TurokVehicle.SVehicleMesh'
    begin object name=SVehicleMesh
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokVehicle.MyLightEnvironment'
    end object
    Mesh=SVehicleMesh
    // Reference: CylinderComponent'Default__TurokVehicle.CollisionCylinder'
    begin object name=CollisionCylinder
        CollideActors=false
        BlockActors=false
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    end object
    CylinderComponent=CollisionCylinder
    ViewPitchMin=-15000.0000000
    InventoryManagerClass=none
    mDefaultTraceTypeFlags=262144
    mDefaultTraceSourceFlags=1024
    bCanTeleport=false
    Components[0]=CollisionCylinder
    Components[1]=SVehicleMesh
    Components[2]=MyLightEnvironment
    Components[3]=TurokVehicleSoundControllerComponent
    CollisionComponent=SVehicleMesh
    SupportedEvents=/* Array type was not detected. */
}