class TurokVehicleSeat extends Object
    native
    implements(TurokAnimInterfaceGraphNotify);

var @NULL MyVehicle;
var int MyIndex;
var protected @NULL StoragePawn;
var protected @NULL mEnteringPawn;
var protected @NULL mEnterPosition;
var() name EntrySocket;
var() float EntryRadius;
var() array mExitSockets;
var(Camera) name CameraTag;
var(Camera) float CameraOffset;
var(Camera) float CameraEyeHeight;
var(Camera) float CameraFOV;
var(Camera) bool bCameraFreeLook;
var(ViewLimits) bool bLimitPitch;
var(ViewLimits) bool bLimitYaw;
var(Visibility) bool bSeatVisible;
var protected bool mbPawnEntering;
var protected bool mbPawnLeaving;
var private bool mbUseReactionPhysics;
var bool mbReactionPhysicsSetup;
var(SeatLock) private bool mbCanPlayerEnter;
var(SeatLock) private bool mbCanPlayerExit;
var(SeatLock) private bool mbCanAIEnter;
var(SeatLock) private bool mbCanAIExit;
var(Camera) @NULL SeatCameraOffset;
var(Camera) @NULL SeatSmoothTime;
var(Camera) float SeatCameraPitchOffset;
var(Camera) @NULL TurretCameraOffset;
var(Camera) @NULL TurretCameraOffsetMP;
var(Camera) float mCamEnterBlendTime;
var(Camera) float mCamExitBlendTime;
var(Camera) float mCamEnterDelayTime;
var(Camera) float mCamExitDelayTime;
var(ViewLimits) float ViewPitchMin;
var(ViewLimits) float ViewPitchMax;
var(ViewLimits) float ViewYawMin;
var(ViewLimits) float ViewYawMax;
var(Visibility) name SeatBone;
var(Animation) protected @NULL mGraphSet;
var(Animation) name mEntryAnimName;
var(Animation) name mExitAnimName;
var(Animation) name mSeatedAnimName;
var(Animation) name mDyingAnimName;
var() protected export editinline @NULL mReactionPhysics;
var protected @NULL mReactionDelta;
var name mReactionPhysicsAnchorBoneName;
var float mEntranceTime;
var @NULL mFailsafeLocation;

// Export UTurokVehicleSeat::execUpdate(FFrame&, void* const)
native simulated function Update(float DeltaSeconds);

// Export UTurokVehicleSeat::execIsPawnEntering(FFrame&, void* const)
native simulated function bool IsPawnEntering();

// Export UTurokVehicleSeat::execIsPawnLeaving(FFrame&, void* const)
native simulated function bool IsPawnLeaving();

// Export UTurokVehicleSeat::execIsTransitioning(FFrame&, void* const)
native simulated function bool IsTransitioning();

// Export UTurokVehicleSeat::execIsOccupied(FFrame&, void* const)
native simulated function bool IsOccupied();

// Export UTurokVehicleSeat::execIsBusy(FFrame&, void* const)
native simulated function bool IsBusy();

// Export UTurokVehicleSeat::execGetOccupant(FFrame&, void* const)
native simulated function @NULL GetOccupant();

// Export UTurokVehicleSeat::execGetEnteringPawn(FFrame&, void* const)
native simulated function @NULL GetEnteringPawn();

// Export UTurokVehicleSeat::execGetReactionPhysics(FFrame&, void* const)
native simulated function @NULL GetReactionPhysics();

// Export UTurokVehicleSeat::execIsUsingReactionPhysics(FFrame&, void* const)
native simulated function bool IsUsingReactionPhysics();

// Export UTurokVehicleSeat::execReEnablePoweredRagdoll(FFrame&, void* const)
native simulated function ReEnablePoweredRagdoll(@NULL pwn);

// Export UTurokVehicleSeat::execSetupReactionPhysics(FFrame&, void* const)
native simulated function SetupReactionPhysics();

// Export UTurokVehicleSeat::execGetReactionDelta(FFrame&, void* const)
native simulated function @NULL GetReactionDelta();

simulated event PlayDeathAnim()
{
    local @NULL tph;

    tph = TurokPawnHuman(GetSeatedPawn());
    // End:0x35
    if(tph == none)
    {
        tph = TurokPawnHuman(GetEnteringPawn());
    }
    // DebugMode: 0
    assert(tph != none);
    // End:0x8D
    if(mGraphSet.FindGraph(mDyingAnimName) != none)
    {
        tph.PlayGraphLocal(mGraphSet.FindGraph(mDyingAnimName), tph, 0);
    }
    //return;    
}

protected simulated function SetExitPhysics()
{
    local @NULL tph;

    tph = TurokPawnHuman(GetSeatedPawn());
    // DebugMode: 0
    assert(tph != none);
    tph.SetHardAttach(true);
    tph.SetPhysics(12);
    tph.SetBase(MyVehicle,, MyVehicle.Mesh, SeatBone);
    //return;    
}

simulated function EntryStart(@NULL tph)
{
    // DebugMode: 0
    assert(tph != none);
    tph.StopFiring();
    tph.ShouldCrouch(false);
    tph.mbEnableImpactAnims = false;
    tph.bIgnoreForces = true;
    tph.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
    tph.bCanTeleport = false;
    tph.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
    tph.Mesh.SetHasPhysicsAssetInstance(false);
    mFailsafeLocation = tph.Location;
    // DebugMode: 0
    assert((GetEnteringPawn()) == none);
    SetEnteringPawn(tph);
    // DebugMode: 0
    assert(!mbPawnEntering);
    mbPawnEntering = true;
    //return;    
}

simulated function EntryFinished()
{
    local @NULL tph;

    tph = TurokPawnHuman(GetEnteringPawn());
    SetEnteringPawn(none);
    // DebugMode: 0
    assert(tph != none);
    // DebugMode: 0
    assert((((((int(tph.Role) == int(ROLE_Authority)) && int(tph.mSeatInOut) == int(1)) || (int(tph.Role) != int(ROLE_Authority)) && int(tph.mSeatInOut) == int(0)) || int(tph.mSeatInOut) == int(2)) || int(tph.mSeatInOut) == int(3)) || int(tph.mSeatInOut) == int(8));
    tph.mSeatInOut = 0;
    // DebugMode: 0
    assert(((GetSeatedPawn()) == none) || GetSeatedPawn().bPendingDelete == true);
    SetSeatedPawn(tph);
    // DebugMode: 0
    assert(mbPawnEntering);
    mbPawnEntering = false;
    tph.SetPhysics(0);
    mEntranceTime = MyVehicle.WorldInfo.TimeSeconds;
    MyVehicle.TriggerEventClass(Class'TurokSeqEvent_VehicleEnter', tph);
    //return;    
}

simulated function ForceExitToAnim()
{
    local @NULL tph;

    tph = TurokPawnHuman(GetSeatedPawn());
    // DebugMode: 0
    assert(!mbPawnLeaving);
    SetSeatedPawn(none);
    tph.StopFiring();
    tph.SetHardAttach(false);
    tph.bIgnoreForces = false;
    tph.bCanTeleport = true;
    tph.SetCollision(false, false);
    tph.SetHidden(false);
    tph.SetBase(none);
    tph.mbEnableImpactAnims = true;
    ReEnablePoweredRagdoll(tph);
    mbReactionPhysicsSetup = false;
    MyVehicle.TriggerEventClass(Class'TurokSeqEvent_VehicleExit', tph);
    //return;    
}

simulated function ExitStart()
{
    local @NULL tph;

    tph = TurokPawnHuman(GetSeatedPawn());
    // DebugMode: 0
    assert(tph != none);
    // End:0x51
    if(!mbPawnLeaving)
    {
        mbPawnLeaving = true;
        tph.StopFiring();
        SetExitPhysics();
    }
    //return;    
}

simulated function ExitFinished()
{
    local @NULL tph;

    tph = TurokPawnHuman(GetSeatedPawn());
    // DebugMode: 0
    assert(tph != none);
    // DebugMode: 0
    assert((((((int(tph.Role) == int(ROLE_Authority)) && int(tph.mSeatInOut) == int(6)) || (int(tph.Role) != int(ROLE_Authority)) && int(tph.mSeatInOut) == int(5)) || int(tph.mSeatInOut) == int(7)) || int(tph.mSeatInOut) == int(3)) || int(tph.mSeatInOut) == int(8));
    tph.mSeatInOut = 5;
    // End:0x272
    if(mbPawnLeaving)
    {
        mbPawnLeaving = false;
        tph.SetHardAttach(false);
        tph.bIgnoreForces = false;
        tph.bCollideWorld = true;
        tph.bCanTeleport = true;
        // End:0x1E9
        if(tph.Health > 0)
        {
            // End:0x197
            if(!MyVehicle.PlaceExitingPassenger(tph, MyIndex))
            {
                tph.SetLocation(mFailsafeLocation);
                tph.SetPhysics(1);
            }
            // End:0x1DA
            if(tph.Mesh != none)
            {
                tph.Mesh.CullDistance = tph.default.Mesh.CullDistance;
            }
            ReEnablePoweredRagdoll(tph);
        }
        tph.LocalAnimInterruptToLoco();
        tph.mbEnableImpactAnims = true;
        tph.SetCollision(true, true);
        tph.SetHidden(false);
        tph.SetBase(none);
        SetSeatedPawn(none);
        mbReactionPhysicsSetup = false;
        MyVehicle.TriggerEventClass(Class'TurokSeqEvent_VehicleExit', tph);
    }
    //return;    
}

simulated function DyingStart()
{
    ExitStart();
    //return;    
}

simulated function DyingFinished()
{
    ExitFinished();
    //return;    
}

simulated function NotifyGraphStart(@NULL graph, byte actorType)
{
    //return;    
}

simulated function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
{
    //return;    
}

simulated function NotifyGraphEndToGraph(@NULL prevGraph, @NULL newGraph, byte actorType)
{
    //return;    
}

simulated function Initialize()
{
    mReactionPhysics.mBoneName = SeatBone;
    mReactionPhysics.mSkelComp = MyVehicle.Mesh;
    StoragePawn = none;
    mEnteringPawn = none;
    mbPawnEntering = false;
    mbPawnLeaving = false;
    mbCanPlayerEnter = true;
    mbCanPlayerExit = true;
    mbCanAIEnter = true;
    mbCanAIExit = true;
    //return;    
}

simulated function PlayEntryAnimation()
{
    local @NULL tph;

    tph = TurokPawnHuman(GetEnteringPawn());
    // DebugMode: 0
    assert(tph != none);
    // End:0x7B
    if((tph.Controller != none) && !tph.Controller.IsInState('VehicleCannedAnimation'))
    {
        tph.Controller.GotoState('VehicleCannedAnimation');
    }
    MyVehicle.AttachPawn(tph, MyIndex);
    tph.PlayGraphLocal(mGraphSet.FindGraph(mEntryAnimName), self, 0);
    //return;    
}

simulated function PlayExitAnimation()
{
    local @NULL TPC, Cam, tph;

    tph = TurokPawnHuman(GetSeatedPawn());
    // DebugMode: 0
    assert(tph != none);
    TPC = TurokPlayerController(tph.Controller);
    // End:0xF6
    if(TPC != none)
    {
        // DebugMode: 0
        assert((int(TPC.Role) == int(ROLE_Authority)) || int(TPC.Role) == int(ROLE_AutonomousProxy));
        Cam = TurokPlayerCamera(TPC.PlayerCamera);
        // DebugMode: 0
        assert(Cam != none);
        Cam.mParameters.blendTime = mCamExitBlendTime;
        Cam.mParameters.DelayTime = mCamExitDelayTime;
        Cam.mParameters.CancelAnimatedCamUpdateCtrl = true;
    }
    // End:0x150
    if((tph.Controller != none) && !tph.Controller.IsInState('VehicleCannedAnimation'))
    {
        tph.Controller.GotoState('VehicleCannedAnimation');
    }
    tph.PlayGraphLocal(mGraphSet.FindGraph(mExitAnimName), self, 0);
    //return;    
}

simulated function PlayInVehicleAnimation()
{
    //return;    
}

function bool CanPlayerEnter()
{
    return mbCanPlayerEnter;
    //return ReturnValue;    
}

function SetLockPlayerEnter(bool bCanEnter)
{
    mbCanPlayerEnter = bCanEnter;
    //return;    
}

function bool CanPlayerExit()
{
    return mbCanPlayerExit;
    //return ReturnValue;    
}

function SetLockPlayerExit(bool bCanExit)
{
    mbCanPlayerExit = bCanExit;
    //return;    
}

function bool CanAIEnter()
{
    return mbCanAIEnter;
    //return ReturnValue;    
}

function SetLockAIEnter(bool bCanEnter)
{
    mbCanAIEnter = bCanEnter;
    //return;    
}

function bool CanAIExit()
{
    return mbCanAIExit;
    //return ReturnValue;    
}

function SetLockAIExit(bool bCanExit)
{
    mbCanAIExit = bCanExit;
    //return;    
}

function bool CanPawnEnter(@NULL P)
{
    local @NULL TP;

    // End:0x0F
    if(IsBusy())
    {
        return false;
    }
    // End:0x154
    if(none != P.Controller)
    {
        TP = TurokPawnHuman(P);
        // End:0x109
        if(TP != none)
        {
            // End:0x93
            if((TP.mWeaponMediator.GetPrimaryWeapon() != none) && !TP.mWeaponMediator.GetPrimaryWeapon().IsInActiveState())
            {
                return false;
            }
            // End:0x109
            if((TP.mWeaponMediator.IsDualWielding() && TP.mWeaponMediator.GetLeftHandWeapon() != none) && !TP.mWeaponMediator.GetLeftHandWeapon().IsInActiveState())
            {
                return false;
            }
        }
        // End:0x130
        if(none != TurokPlayerController(P.Controller))
        {
            return CanPlayerEnter();            
        }
        else
        {
            // End:0x154
            if(none != TurokAIControllerHumanNpc(P.Controller))
            {
                return CanAIEnter();
            }
        }
    }
    return false;
    //return ReturnValue;    
}

function bool CanPawnExit(@NULL C)
{
    // End:0x0F
    if(IsTransitioning())
    {
        return false;
    }
    // End:0x53
    if(none != C)
    {
        // End:0x38
        if(none != TurokPlayerController(C))
        {
            return CanPlayerExit();            
        }
        else
        {
            // End:0x53
            if(none != TurokAIControllerHumanNpc(C))
            {
                return CanAIExit();
            }
        }
    }
    return false;
    //return ReturnValue;    
}

simulated function SetEnteringPawn(@NULL P)
{
    mEnteringPawn = P;
    // End:0x2A
    if(mEnteringPawn != none)
    {
        mEnterPosition = mEnteringPawn.Location;
    }
    //return;    
}

simulated function SetSeatedPawn(@NULL P)
{
    // End:0x47
    if(P != none)
    {
        // DebugMode: 0
        assert(StoragePawn == none);
        // End:0x44
        if(int(MyVehicle.Role) == int(ROLE_Authority))
        {
            P.DrivenVehicle = MyVehicle;
        }        
    }
    else
    {
        // DebugMode: 0
        assert(StoragePawn != none);
        // End:0x7C
        if(int(MyVehicle.Role) == int(ROLE_Authority))
        {
            StoragePawn.DrivenVehicle = none;
        }
    }
    StoragePawn = P;
    //return;    
}

simulated function @NULL GetSeatedPawn()
{
    return StoragePawn;
    //return ReturnValue;    
}

defaultproperties
{
    CameraFOV=65.0000000
    mbCanPlayerEnter=true
    mbCanPlayerExit=true
    mbCanAIEnter=true
    mbCanAIExit=true
    SeatSmoothTime=(X=0.2500000,Y=0.2500000,Z=0.2500000)
    mCamEnterBlendTime=0.2500000
    mCamExitBlendTime=0.2500000
    mEntryAnimName="entry"
    mExitAnimName="Exit"
    mSeatedAnimName="Steering"
    mDyingAnimName="Dying"
    // Reference: TurokBoneShakePhysics'Default__TurokVehicleSeat.ReactionPhysicsObj'
    begin object name=ReactionPhysicsObj class=Class'TurokBoneShakePhysics'
    end object
    mReactionPhysics=ReactionPhysicsObj
    mReactionPhysicsAnchorBoneName="jt_Cog_C"
}