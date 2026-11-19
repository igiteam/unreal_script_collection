class TurokPawnHuman extends TurokPawn
    abstract
    native
    nativereplication
    config(Pawn)
    hidecategories(Navigation)
    implements(TurokAnimInterfaceGraphNotify);

enum EInputDirection
{
    ID_Left,                        // 0
    ID_Right,                       // 1
    ID_Center,                      // 2
    ID_MAX                          // 3
};

enum ETurokPawnHumanType
{
    ETPHT_NotSpecified,             // 0
    ETPHT_Lil,                      // 1
    ETPHT_MgCaptain,                // 2
    ETPHT_MgElite,                  // 3
    ETPHT_MgGrimes,                 // 4
    ETPHT_MgGruntGuard,             // 5
    ETPHT_MgGruntHandgun,           // 6
    ETPHT_MgGruntSMG,               // 7
    ETPHT_MgGruntHeavyWeapons,      // 8
    ETPHT_MgKane,                   // 9
    ETPHT_MgPyro,                   // 10
    ETPHT_MgRPGTrooper,             // 11
    ETPHT_MgSniper,                 // 12
    ETPHT_MgSoldierGuard,           // 13
    ETPHT_MgVeteranShotgun,         // 14
    ETPHT_MgVeteranStickyGun,       // 15
    ETPHT_MilitaryPolice,           // 16
    ETPHT_MilitaryPoliceB,          // 17
    ETPHT_PlayerTurok,              // 18
    ETPHT_Scientist,                // 19
    ETPHT_WcCole,                   // 20
    ETPHT_WcCowboy,                 // 21
    ETPHT_WcGonzales,               // 22
    ETPHT_WcHenderson,              // 23
    ETPHT_WcJericho,                // 24
    ETPHT_WcLogan,                  // 25
    ETPHT_WcReese,                  // 26
    ETPHT_WcShepard,                // 27
    ETPHT_WcSlade,                  // 28
    ETPHT_WcTurok,                  // 29
    ETPHT_WcRedShirtB,              // 30
    ETPHT_WcRedShirtC,              // 31
    ETPHT_WcRedShirtD,              // 32
    ETPHT_WcRedShirtE,              // 33
    ETPHT_WcRedShirtF,              // 34
    ETPHT_WcCarter,                 // 35
    ETPHT_WcLewis,                  // 36
    ETPHT_WcParker,                 // 37
    ETPHT_WcFoster,                 // 38
    ETPHT_WpKane,                   // 39
    ETPHT_MAX                       // 40
};

enum ESeatInOutAnim
{
    SEAT_IN_COMPLETE,               // 0
    SEAT_IN_BYPASS_ANIM,            // 1
    SEAT_IN_NORMAL_ANIM,            // 2
    SEAT_IN_DYING_ANIM,             // 3
    SEAT_IN_ABORT_ANIM,             // 4
    SEAT_OUT_COMPLETE,              // 5
    SEAT_OUT_BYPASS_ANIM,           // 6
    SEAT_OUT_NORMAL_ANIM,           // 7
    SEAT_OUT_DYING_ANIM,            // 8
    SEAT_OUT_INTO_ANOTHER_ANIM,     // 9
    SEAT_MAX                        // 10
};

struct native KnockdownInfo
{
    var byte mKnockdownType;
    var @NULL mHitLocation;
    var float mSpeed;
    var float mVerticalAngle;
    var float mVerticalPushTime;
    var float mPlayerRotationSpeed;
    var float mStartRelAngle;
    var @NULL mStartRotation;
    var @NULL mHitActor;

    structdefaultproperties
    {
        mKnockdownType=0
        mHitLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mSpeed=500.0000000
        mVerticalAngle=30.0000000
        mVerticalPushTime=0.1000000
        mPlayerRotationSpeed=360.0000000
        mStartRelAngle=0.0000000
        mStartRotation=(Pitch=0,Yaw=0,Roll=0)
        mHitActor=none
    }
};

struct native MeshAttachmentInfo
{
    var @NULL mMeshAttachment;
    var export editinline @NULL mMeshComponent;
    var @NULL mAnimTree;
    var @NULL mTransController;

    structdefaultproperties
    {
        mMeshAttachment=none
        mMeshComponent=none
        mAnimTree=none
        mTransController=none
    }
};

struct native HealthRegenSegment
{
    var() int mRangePercentMin;
    var() int mRangePercentMax;
    var() float mRegenPercent;

    structdefaultproperties
    {
        mRangePercentMin=0
        mRangePercentMax=0
        mRegenPercent=0.0000000
    }
};

var byte mHumanType;
var private repnotify byte mDWSwitchMode;
var private repnotify byte FiringModeLH;
var private repnotify byte FlashCountLH;
var repnotify byte Flash3PRH;
var repnotify byte Flash3PLH;
var private repnotify byte mWeaponAttachmentBowTension;
var private repnotify byte mChaingunLights;
var private repnotify byte mWeaponAttachmentFirebladeMode;
var byte mSeatInOut;
var bool mbCanDropWeapons;
var private repnotify bool mbIsDualWielding;
var private repnotify bool mbWeaponsVisibleIn3rdPerson;
var private repnotify bool mbWeaponsInstantSwitchRight;
var private repnotify bool mbWeaponsInstantSwitchLeft;
var private repnotify bool mbWeaponAttachmentNotifyZoomPressed;
var private repnotify bool mbWeaponAttachmentStartAutoTurretIdle;
var private repnotify bool mChaingunSpinningUp;
var bool mbChaingunNeedsUpdating;
var bool mWeaponAlertStateForced;
var bool mIsUnderFire;
var private repnotify @NULL FlashLocationLH;
var repnotify class mWeaponAttachmentClassRightHand;
var repnotify class mWeaponAttachmentClassLeftHand;
var private repnotify int mWeaponAttachStateRH;
var private repnotify int mWeaponAttachStateLH;
var(Weapons) export editinline @NULL mWeaponAttachmentRightHand;
var(Weapons) export editinline @NULL mWeaponAttachmentLeftHand;
var(WeaponMediator) export editinline @NULL mWeaponMediator;
var array mMeshAttachments;
var private repnotify class mInventoryAttachmentClass;
var private export editinline @NULL mInventoryAttachment;
var const @NULL mKnockdownGraphSet;
var const @NULL mDiveGraphSet;
var const @NULL mFlareReactionSet;
var const @NULL mInvestigateGraphSet;
var const @NULL mPullArrowOutGraphSet;
var protected const array mMeleeAttackGraphSetNames;
var protected const array mActionGraphSetNames;
var protected const array mInstantKillGraphSetNames;
var protected const float mGrenadeTime;
var int mSeatIndex;
var(Melee) export editinline @NULL mMeleeMaulMeter;
var @NULL mMaulWatcher;
var export editinline @NULL mKnockdownController;
var repnotify @NULL mKnockdownInfo;
var const float mKnockdownTime;
var float mKnockdownTimer;
var protected repnotify @NULL mReplicatedKnockdown;
var protected repnotify @NULL mReplicatedDive;
var(HUD) const @NULL mHUDInfoOffset;
var(HUD) const int mUnderFireTimeoutTime;
var(AimAsset) const @NULL mAimAsset;
var(AimAsset) const name mAimAssetBone;
var const export editinline @NULL mHeadMesh;
var config float mDiveNoise;

replication
{
    // Pos:0x000
    if(bNetDirty && !bNetOwner
        FiringModeLH, Flash3PLH, 
        Flash3PRH, FlashCountLH, 
        FlashLocationLH, mChaingunLights, 
        mChaingunSpinningUp, mDWSwitchMode, 
        mInventoryAttachmentClass, mIsUnderFire, 
        mMaulWatcher, mReplicatedDive, 
        mReplicatedKnockdown, mSeatInOut, 
        mSeatIndex, mWeaponAttachStateLH, 
        mWeaponAttachStateRH, mWeaponAttachmentBowTension, 
        mWeaponAttachmentClassLeftHand, mWeaponAttachmentClassRightHand, 
        mWeaponAttachmentFirebladeMode, mbIsDualWielding, 
        mbWeaponAttachmentNotifyZoomPressed, mbWeaponAttachmentStartAutoTurretIdle, 
        mbWeaponsInstantSwitchLeft, mbWeaponsInstantSwitchRight, 
        mbWeaponsVisibleIn3rdPerson;
}

// Export UTurokPawnHuman::execGetLocalPlayerController(FFrame&, void* const)
native function @NULL GetLocalPlayerController();

// Export UTurokPawnHuman::execOnGraphStart(FFrame&, void* const)
native function OnGraphStart(@NULL Start);

// Export UTurokPawnHuman::execOnGraphEndToLoco(FFrame&, void* const)
native function OnGraphEndToLoco(@NULL End, @NULL locoAsset, @NULL Params, float residualTick, byte actorType);

// Export UTurokPawnHuman::execProcessViewRotation(FFrame&, void* const)
native simulated function ProcessViewRotation(float DeltaTime, out @NULL out_ViewRotation, out @NULL out_DeltaRot);

// Export UTurokPawnHuman::execGetMaxSpeedModifier(FFrame&, void* const)
native function float GetMaxSpeedModifier();

// Export UTurokPawnHuman::execAttachDefaultAnimations(FFrame&, void* const)
protected native function AttachDefaultAnimations();

// Export UTurokPawnHuman::execGetRightHandWeapon(FFrame&, void* const)
native function @NULL GetRightHandWeapon();

// Export UTurokPawnHuman::execGetLeftHandWeapon(FFrame&, void* const)
native function @NULL GetLeftHandWeapon();

// Export UTurokPawnHuman::execGetPrimaryWeapon(FFrame&, void* const)
native function @NULL GetPrimaryWeapon();

// Export UTurokPawnHuman::execWeaponFired(FFrame&, void* const)
native function WeaponFired(bool bViaReplication, @NULL HitLocation);

// Export UTurokPawnHuman::execWeaponFiredLH(FFrame&, void* const)
native function WeaponFiredLH(bool bViaReplication, @NULL HitLocation);

// Export UTurokPawnHuman::execWeaponStoppedFiring(FFrame&, void* const)
native function WeaponStoppedFiring(bool bViaReplication);

// Export UTurokPawnHuman::execWeaponStoppedFiringLH(FFrame&, void* const)
native function WeaponStoppedFiringLH(bool bViaReplication);

// Export UTurokPawnHuman::execGetFiringMode(FFrame&, void* const)
native simulated function byte GetFiringMode();

// Export UTurokPawnHuman::execGetFiringModeUnconverted(FFrame&, void* const)
native simulated function byte GetFiringModeUnconverted();

// Export UTurokPawnHuman::execGetFiringModeLH(FFrame&, void* const)
native simulated function byte GetFiringModeLH();

// Export UTurokPawnHuman::execSetMeshVisibility(FFrame&, void* const)
native function SetMeshVisibility(bool bIs3rdPerson);

// Export UTurokPawnHuman::execSetWeaponMeshVisibility(FFrame&, void* const)
native function SetWeaponMeshVisibility(bool bIs3rdPerson);

// Export UTurokPawnHuman::execSetWeaponReplicationFlag(FFrame&, void* const)
native final function SetWeaponReplicationFlag(byte flag, byte hand);

// Export UTurokPawnHuman::execIsInGrass(FFrame&, void* const)
native function bool IsInGrass();

// Export UTurokPawnHuman::execTryPlayFootStepSound(FFrame&, void* const)
native function TryPlayFootStepSound(name JointName);

// Export UTurokPawnHuman::execTryPlayGearSound(FFrame&, void* const)
native function TryPlayGearSound(name JointName);

// Export UTurokPawnHuman::execGetFootStepVolumeMultiplier(FFrame&, void* const)
native function float GetFootStepVolumeMultiplier();

// Export UTurokPawnHuman::execGetFootStepVolume(FFrame&, void* const)
native function float GetFootStepVolume(float Speed, name JointName);

// Export UTurokPawnHuman::execIsInKnockdown(FFrame&, void* const)
native simulated function bool IsInKnockdown();

// Export UTurokPawnHuman::execAllowMauling(FFrame&, void* const)
native simulated function bool AllowMauling();

simulated event ReplicatedEvent(name VarName)
{
    // End:0x2E
    if(VarName == 'mDWSwitchMode')
    {
        mWeaponMediator.SetDualWieldSwitchMode(mDWSwitchMode);        
    }
    else
    {
        // End:0x5D
        if(VarName == 'mbIsDualWielding')
        {
            mWeaponMediator.SetDualWieldingFlag(mbIsDualWielding);            
        }
        else
        {
            // End:0x9B
            if(VarName == 'FlashCountLH')
            {
                // DebugMode: 0
                assert((int(FiringModeLH) == 0) || int(FiringModeLH) == 1);
                FlashCountLHUpdated(true);                
            }
            else
            {
                // End:0xD9
                if(VarName == 'FiringModeLH')
                {
                    // DebugMode: 0
                    assert((int(FiringModeLH) == 0) || int(FiringModeLH) == 1);
                    FiringModeLHUpdated(true);                    
                }
                else
                {
                    // End:0x117
                    if(VarName == 'FlashLocationLH')
                    {
                        // DebugMode: 0
                        assert((int(FiringModeLH) == 0) || int(FiringModeLH) == 1);
                        FlashLocationLHUpdated(true);                        
                    }
                    else
                    {
                        // End:0x143
                        if(VarName == 'mbWeaponsVisibleIn3rdPerson')
                        {
                            SetWeaponMeshVisibility(!IsFirstPerson());                            
                        }
                        else
                        {
                            // End:0x16B
                            if(VarName == 'mbWeaponsInstantSwitchRight')
                            {
                                SetWeaponsInstantSwitch(0, mbWeaponsInstantSwitchRight);                                
                            }
                            else
                            {
                                // End:0x193
                                if(VarName == 'mbWeaponsInstantSwitchLeft')
                                {
                                    SetWeaponsInstantSwitch(1, mbWeaponsInstantSwitchLeft);                                    
                                }
                                else
                                {
                                    // End:0x1D6
                                    if((VarName == 'mWeaponAttachmentClassRightHand') || VarName == 'mWeaponAttachmentClassLeftHand')
                                    {
                                        WeaponAttachmentChanged(0);
                                        WeaponAttachmentChanged(1);                                        
                                    }
                                    else
                                    {
                                        // End:0x213
                                        if(VarName == 'mInventoryAttachmentClass')
                                        {
                                            // End:0x206
                                            if(mInventoryAttachmentClass != none)
                                            {
                                                AttachInventory(mInventoryAttachmentClass);                                                
                                            }
                                            else
                                            {
                                                DetachInventory();
                                            }                                            
                                        }
                                        else
                                        {
                                            // End:0x253
                                            if(VarName == 'mWeaponAttachStateRH')
                                            {
                                                // End:0x250
                                                if(mWeaponAttachmentRightHand != none)
                                                {
                                                    mWeaponAttachmentRightHand.OnReplicatedStateChanged(mWeaponAttachStateRH);
                                                    mWeaponAttachStateRH = 0;
                                                }                                                
                                            }
                                            else
                                            {
                                                // End:0x293
                                                if(VarName == 'mWeaponAttachStateLH')
                                                {
                                                    // End:0x290
                                                    if(mWeaponAttachmentLeftHand != none)
                                                    {
                                                        mWeaponAttachmentLeftHand.OnReplicatedStateChanged(mWeaponAttachStateLH);
                                                        mWeaponAttachStateLH = 0;
                                                    }                                                    
                                                }
                                                else
                                                {
                                                    // End:0x2F1
                                                    if(VarName == 'mbWeaponAttachmentNotifyZoomPressed')
                                                    {
                                                        // End:0x2D0
                                                        if(mbWeaponAttachmentNotifyZoomPressed)
                                                        {
                                                            // End:0x2CD
                                                            if(mWeaponAttachmentRightHand != none)
                                                            {
                                                                mWeaponAttachmentRightHand.NotifyZoomPressed();
                                                            }                                                            
                                                        }
                                                        else
                                                        {
                                                            // End:0x2EE
                                                            if(mWeaponAttachmentRightHand != none)
                                                            {
                                                                mWeaponAttachmentRightHand.NotifyZoomReleased();
                                                            }
                                                        }                                                        
                                                    }
                                                    else
                                                    {
                                                        // End:0x32A
                                                        if(VarName == 'mWeaponAttachmentBowTension')
                                                        {
                                                            // End:0x327
                                                            if(mWeaponAttachmentRightHand != none)
                                                            {
                                                                mWeaponAttachmentRightHand.BowAttachmentAddTension(mWeaponAttachmentBowTension);
                                                            }                                                            
                                                        }
                                                        else
                                                        {
                                                            // End:0x363
                                                            if(VarName == 'mChaingunLights')
                                                            {
                                                                // End:0x360
                                                                if(mWeaponAttachmentRightHand != none)
                                                                {
                                                                    mWeaponAttachmentRightHand.ChainGunAttachmentSetLights(mChaingunLights);
                                                                }                                                                
                                                            }
                                                            else
                                                            {
                                                                // End:0x3A5
                                                                if(VarName == 'mChaingunSpinningUp')
                                                                {
                                                                    // End:0x3A2
                                                                    if(mWeaponAttachmentRightHand != none)
                                                                    {
                                                                        mbChaingunNeedsUpdating = true;
                                                                        mWeaponAttachmentRightHand.ChainGunAttachmentSetSpinStatus(mChaingunSpinningUp);
                                                                    }                                                                    
                                                                }
                                                                else
                                                                {
                                                                    // End:0x3DE
                                                                    if(VarName == 'mWeaponAttachmentFirebladeMode')
                                                                    {
                                                                        // End:0x3DB
                                                                        if(mWeaponAttachmentRightHand != none)
                                                                        {
                                                                            mWeaponAttachmentRightHand.SetFireBladeAnimMode(mWeaponAttachmentFirebladeMode);
                                                                        }                                                                        
                                                                    }
                                                                    else
                                                                    {
                                                                        // End:0x41B
                                                                        if(VarName == 'mbWeaponAttachmentStartAutoTurretIdle')
                                                                        {
                                                                            // End:0x418
                                                                            if(mbWeaponAttachmentStartAutoTurretIdle)
                                                                            {
                                                                                // End:0x418
                                                                                if(mWeaponAttachmentRightHand != none)
                                                                                {
                                                                                    mWeaponAttachmentRightHand.ChainGunAttachmentStartTripodIdle();
                                                                                }
                                                                            }                                                                            
                                                                        }
                                                                        else
                                                                        {
                                                                            // End:0x43B
                                                                            if(VarName == 'mReplicatedKnockdown')
                                                                            {
                                                                                OnReplicatedKnockdown();                                                                                
                                                                            }
                                                                            else
                                                                            {
                                                                                // End:0x45B
                                                                                if(VarName == 'mReplicatedDive')
                                                                                {
                                                                                    OnReplicatedDive();                                                                                    
                                                                                }
                                                                                else
                                                                                {
                                                                                    super.ReplicatedEvent(VarName);
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    //return;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x35
    if((int(Role) == int(ROLE_Authority)) && mbAllowDinoMelee)
    {
        mMaulWatcher = __NFUN_278__(Class'TurokPotentialMaulWatcher', self);
    }
    //return;    
}

simulated event Destroyed()
{
    local @NULL TDV, TVS;

    // End:0x58
    if(mMaulWatcher != none)
    {
        // End:0x35
        if(int(Role) == int(ROLE_SimulatedProxy))
        {
            mMaulWatcher.GotoState('MaulNotRelevant');            
        }
        else
        {
            // End:0x51
            if(int(Role) == int(ROLE_Authority))
            {
                mMaulWatcher.Destroy();
            }
        }
        mMaulWatcher = none;
    }
    TDV = TurokVehicle(DrivenVehicle);
    // End:0xF7
    if(((TDV != none) && mSeatIndex > -1) && mSeatIndex < TDV.GetNumSeats())
    {
        TVS = TDV.Seats[mSeatIndex];
        // End:0xF7
        if((TVS != none) && TVS.GetSeatedPawn() == self)
        {
            TVS.SetSeatedPawn(none);
        }
    }
    DetachInventory();
    mWeaponMediator.ClearBothWeapons();
    super.Destroyed();
    //return;    
}

simulated function PlayDying(class<Class> DamageType, @NULL HitLoc)
{
    DetachInventory();
    RemoveWeaponAttachment(0);
    RemoveWeaponAttachment(1);
    // End:0x4A
    if((GetRightHandWeapon()) != none)
    {
        GetRightHandWeapon().DetachWeaponAttachment();
    }
    // End:0x72
    if((GetLeftHandWeapon()) != none)
    {
        GetLeftHandWeapon().DetachWeaponAttachment();
    }
    super.PlayDying(DamageType, HitLoc);
    //return;    
}

simulated function Tick(float DeltaTime)
{
    local editinline @NULL tChaingun, tChaingunTurret;

    super.Tick(DeltaTime);
    // End:0x16
    if(IsLocallyControlled())
    {
        return;
    }
    tChaingun = TurokWeapAttachChaingunNative(mWeaponAttachmentRightHand);
    tChaingunTurret = TurokWeapAttachChaingunTurretNative(mWeaponAttachmentRightHand);
    // End:0x5C
    if(tChaingun != none)
    {
        tChaingun.UpdateSpin(DeltaTime);        
    }
    else
    {
        // End:0x8C
        if((tChaingunTurret != none) && !IsLocallyControlled())
        {
            tChaingunTurret.UpdateSpin(DeltaTime);
        }
    }
    //return;    
}

// Export UTurokPawnHuman::execGetHumanReadableName(FFrame&, void* const)
native simulated function string GetHumanReadableName();

// Export UTurokPawnHuman::execGetTeamNum(FFrame&, void* const)
native simulated function byte GetTeamNum();

function OnAIEnterVehicle(@NULL Action)
{
    local array objVarsVehicle;
    local @NULL Vehicle;

    Action.GetObjectVars(objVarsVehicle, "Vehicle");
    // End:0x69
    if(objVarsVehicle.Length > 0)
    {
        Vehicle = TurokVehicle(objVarsVehicle[0]);
        // End:0x69
        if(Vehicle != none)
        {
            Vehicle.PawnEnter(self, Action.mSeat);
        }
    }
    //return;    
}

function OnAIExitVehicle(@NULL Action)
{
    local @NULL Vehicle;

    Vehicle = TurokVehicle(DrivenVehicle);
    // End:0x42
    if(Vehicle != none)
    {
        Vehicle.PawnExit(mSeatIndex, Action.mbSkipAnimation);
    }
    //return;    
}

function GenericLipSync(@NULL cue, array AnimSets, name AnimName, float blendIn, float blendOut)
{
    local float Duration;

    // End:0xB4
    if(cue != none)
    {
        Duration = cue.GetCueDuration() - blendOut;
        // End:0x77
        if(Duration < 0.0000000)
        {
            Duration = cue.GetCueDuration() / 4.0000000;
            blendIn = Duration;
            blendOut = Duration * 2.0000000;
        }
        // DebugMode: 0
        assert(mAnimController != none);
        mAnimController.PlayFacialTransient(AnimName, AnimSets, Duration, blendIn, blendOut, 'jt_Head_C');
    }
    //return;    
}

function OnPlayFacialAnim(@NULL Action)
{
    // End:0x6F
    if(Action.mCustomAnimName != 'None')
    {
        GenericLipSync(Action.PlaySound, Action.mCustomAnimSets, Action.mCustomAnimName, Action.mBlendIn, Action.mBlendOut);        
    }
    else
    {
        GenericLipSync(Action.PlaySound, Action.mGenericAnimSets, Action.mGenericAnimName, Action.mBlendIn, Action.mBlendOut);
    }
    //return;    
}

function OnPawnAlertState(@NULL Action)
{
    // End:0x29
    if(Action.InputLinks[0].bHasImpulse)
    {
        mWeaponAlertStateForced = true;        
    }
    else
    {
        // End:0x4F
        if(Action.InputLinks[1].bHasImpulse)
        {
            mWeaponAlertStateForced = false;
        }
    }
    // End:0x80
    if(mWeaponAlertStateForced)
    {
        SetAlertState(Action.mAlerted, Action.mBlendTime, true);
    }
    //return;    
}

function SetAlertState(bool alert, float blendTime, optional bool forceState = false)
{
    // End:0x65
    if(!mWeaponAlertStateForced || forceState)
    {
        // End:0x40
        if(mWeaponAttachmentRightHand != none)
        {
            mWeaponAttachmentRightHand.super(TurokPawnHuman).SetAlertState(alert, blendTime);
        }
        // End:0x65
        if(mWeaponAttachmentLeftHand != none)
        {
            mWeaponAttachmentLeftHand.super(TurokPawnHuman).SetAlertState(alert, blendTime);
        }
    }
    //return;    
}

function OnToggleCanDropWeapon(@NULL Action)
{
    // End:0x29
    if(Action.InputLinks[0].bHasImpulse)
    {
        mbCanDropWeapons = true;        
    }
    else
    {
        // End:0x52
        if(Action.InputLinks[1].bHasImpulse)
        {
            mbCanDropWeapons = false;            
        }
        else
        {
            // End:0x80
            if(Action.InputLinks[2].bHasImpulse)
            {
                mbCanDropWeapons = !mbCanDropWeapons;
            }
        }
    }
    //return;    
}

simulated event PlayFoleySound()
{
    local byte foleyType;

    // End:0x16
    if(mWeaponAttachmentLeftHand != none)
    {
        foleyType = 4;        
    }
    else
    {
        // End:0x3D
        if(mWeaponAttachmentRightHand != none)
        {
            foleyType = mWeaponAttachmentRightHand.GetFoleyType();            
        }
        else
        {
            foleyType = 0;
        }
    }
    mSoundController.TryPlayLimitedSound('Foley', mFoleySounds[int(foleyType)], Location);
    //return;    
}

simulated event HideAllWeaponsForCinema()
{
    // End:0x20
    if(mWeaponAttachmentRightHand != none)
    {
        mWeaponAttachmentRightHand.SetAttachmentMeshVisibility(true, false);
    }
    // End:0x40
    if(mWeaponAttachmentLeftHand != none)
    {
        mWeaponAttachmentLeftHand.SetAttachmentMeshVisibility(true, false);
    }
    // End:0x69
    if((GetRightHandWeapon()) != none)
    {
        GetRightHandWeapon().SetWeaponVisibility(false);
    }
    // End:0x92
    if((GetLeftHandWeapon()) != none)
    {
        GetLeftHandWeapon().SetWeaponVisibility(false);
    }
    //return;    
}

event EncroachedBy(@NULL Other)
{
    // End:0x3A
    if(!IsInState('MeleeAttackAnimation') && !Other.IsInState('MeleeAttackAnimation'))
    {
        super(Pawn).EncroachedBy(Other);
    }
    //return;    
}

function bool Died(@NULL Killer, class<Class> DamageType, @NULL HitLocation)
{
    Weapon = GetRightHandWeapon();
    return super.Died(Killer, DamageType, HitLocation);
    //return ReturnValue;    
}

simulated function bool CanBeDraggedByArrow()
{
    return true;
    //return ReturnValue;    
}

event TakeDamage(int Damage, @NULL InstigatedBy, @NULL HitLocation, @NULL Momentum, class<Class> DamageType, optional @NULL HitInfo, optional @NULL DamageCauser)
{
    local int PreviousHealth;

    PreviousHealth = Health;
    super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo);
    // End:0x6B
    if((Health > 0) && Health != PreviousHealth)
    {
        mIsUnderFire = true;
        SetTimer(float(mUnderFireTimeoutTime), false, 'UnderFireTimer');
    }
    //return;    
}

simulated event TakeImpact(class<Class> pDamageType, float Damage, @NULL HitLocation, @NULL HitMomentum, @NULL HitInfo)
{
    super.TakeImpact(pDamageType, Damage, HitLocation, HitMomentum, HitInfo);
    // End:0x45
    if((pDamageType == Class'TurokDamageTypeArrowRemovedByPawn') && DrivenVehicle == none)
    {
        PlayArrowPullOutTransitionGraph();
    }
    //return;    
}

function SpawnGrenade(class<Class> grenadeClass, optional @NULL localSpawnOffset, optional int pitchOffset = 0)
{
    local @NULL SpawnedProjectile, out_Loc, out_Rot;

    GetActorEyesViewPoint(out_Loc, out_Rot);
    out_Rot.Pitch += pitchOffset;
    SpawnedProjectile = __NFUN_278__(grenadeClass, self,, out_Loc);
    // End:0xC7
    if((SpawnedProjectile != none) && !SpawnedProjectile.bDeleteMe)
    {
        SpawnedProjectile.Init(Vector(out_Rot));
        TurokProjTimedGrenadeNpcNative(SpawnedProjectile).mTrajectory = TurokAIControllerHumanNpc(Controller).mGrenadeTrajectory;
        TurokProjTimedGrenadeNpcNative(SpawnedProjectile).BeginFlight(mGrenadeTime);
    }
    //return;    
}

private final function UnderFireTimer()
{
    mIsUnderFire = false;
    //return;    
}

simulated function bool CalcCamera(float fDeltaTime, out @NULL out_CamLoc, out @NULL out_CamRot, out float out_FOV)
{
    // End:0x3F
    if(DrivenVehicle != none)
    {
        TurokVehicle(DrivenVehicle).VehicleCalcCamera(fDeltaTime, mSeatIndex, out_CamLoc, out_CamRot, out_FOV);
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated event ReInit3PWeaponAnims(bool attachToGraph)
{
    // End:0x40
    if(mWeaponAttachmentRightHand != none)
    {
        mWeaponAttachmentRightHand.Init3PAnims(attachToGraph);
        // End:0x40
        if(mWeaponAttachmentLeftHand != none)
        {
            mWeaponAttachmentLeftHand.Init3PAnims(attachToGraph);
        }
    }
    //return;    
}

// Export UTurokPawnHuman::execSetFiringMode(FFrame&, void* const)
native function SetFiringMode(byte FiringModeNum);

// Export UTurokPawnHuman::execSetFiringModeLH(FFrame&, void* const)
native function SetFiringModeLH(byte FiringModeNumLH);

simulated function IncrementFlashCount(@NULL Who, byte FireModeNum)
{
    NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    FlashCount++;
    // End:0x38
    if(int(FlashCount) == 0)
    {
        FlashCount += byte(2);
    }
    SetFiringMode(FireModeNum);
    FlashCountUpdated(false);
    //return;    
}

simulated function IncrementFlashCountLH(@NULL Who, byte FireModeNum)
{
    NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    FlashCountLH++;
    // End:0x38
    if(int(FlashCountLH) == 0)
    {
        FlashCountLH += byte(2);
    }
    SetFiringModeLH(FireModeNum);
    FlashCountLHUpdated(false);
    //return;    
}

// Export UTurokPawnHuman::execSetFlashLocation(FFrame&, void* const)
native function SetFlashLocation(@NULL Who, byte FireModeNum, @NULL NewLoc);

// Export UTurokPawnHuman::execSetFlashLocationLH(FFrame&, void* const)
native function SetFlashLocationLH(@NULL Who, byte FireModeNum, @NULL NewLoc);

simulated function ClearFlashLocation(@NULL Who)
{
    // End:0x4F
    if(!IsZero(FlashLocation))
    {
        NetUpdateTime = WorldInfo.TimeSeconds - float(1);
        FlashLocation = vect(0.0000000, 0.0000000, 0.0000000);
        FlashLocationUpdated(false);
        Flash3PRH = 0;        
    }
    else
    {
        WeaponStoppedFiring(false);
    }
    //return;    
}

simulated function ClearFlashLocationLH(@NULL Who)
{
    // End:0x4F
    if(!IsZero(FlashLocationLH))
    {
        NetUpdateTime = WorldInfo.TimeSeconds - float(1);
        FlashLocationLH = vect(0.0000000, 0.0000000, 0.0000000);
        FlashLocationLHUpdated(false);
        Flash3PLH = 0;        
    }
    else
    {
        WeaponStoppedFiringLH(false);
    }
    //return;    
}

simulated function ClearFlashCount(@NULL Who)
{
    // End:0x39
    if(int(FlashCount) != 0)
    {
        NetUpdateTime = WorldInfo.TimeSeconds - float(1);
        FlashCount = 0;
        FlashCountUpdated(false);
    }
    //return;    
}

simulated function ClearFlashCountLH(@NULL Who)
{
    // End:0x39
    if(int(FlashCountLH) != 0)
    {
        NetUpdateTime = WorldInfo.TimeSeconds - float(1);
        FlashCountLH = 0;
        FlashCountLHUpdated(false);
    }
    //return;    
}

simulated function FlashCountUpdated(bool bViaReplication)
{
    // End:0x2D
    if(int(FlashCount) > 0)
    {
        WeaponFired(bViaReplication, vect(0.0000000, 0.0000000, 0.0000000));        
    }
    else
    {
        WeaponStoppedFiring(bViaReplication);
    }
    //return;    
}

simulated function FlashCountLHUpdated(bool bViaReplication)
{
    // End:0x2D
    if(int(FlashCountLH) > 0)
    {
        WeaponFiredLH(bViaReplication, vect(0.0000000, 0.0000000, 0.0000000));        
    }
    else
    {
        WeaponStoppedFiringLH(bViaReplication);
    }
    //return;    
}

// Export UTurokPawnHuman::execFlashLocationUpdated(FFrame&, void* const)
native function FlashLocationUpdated(bool bViaReplication);

// Export UTurokPawnHuman::execFlashLocationLHUpdated(FFrame&, void* const)
native function FlashLocationLHUpdated(bool bViaReplication);

simulated function WeaponChanged(@NULL NewWeapon)
{
    // End:0x38
    if(NewWeapon.Mesh != none)
    {
        NewWeapon.Mesh.SetHidden(!IsFirstPerson());
    }
    //return;    
}

simulated function WeaponReloading(byte ShotsToGo, byte hand)
{
    // End:0x3A
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x2D
        if(int(ShotsToGo) != 0)
        {
            SetWeaponReplicationFlag(1, hand);            
        }
        else
        {
            SetWeaponReplicationFlag(2, hand);
        }
    }
    // End:0x9E
    if(TurokPlayerController(Controller) != none)
    {
        // End:0x7C
        if(int(ShotsToGo) != 0)
        {
            TurokPlayerController(Controller).mZoomer.EnableSlideZoom(false);            
        }
        else
        {
            TurokPlayerController(Controller).mZoomer.EnableSlideZoom(true);
        }
    }
    // End:0x1D9
    if((int(Role) == int(ROLE_Authority)) || IsLocallyControlled())
    {
        // End:0x151
        if(int(ShotsToGo) != 0)
        {
            // End:0xF6
            if((int(hand) == int(0)) && mWeaponAttachmentRightHand != none)
            {
                mWeaponAttachmentRightHand.ThirdPersonDoReload();
            }
            // End:0x126
            if((int(hand) == int(1)) && mWeaponAttachmentLeftHand != none)
            {
                mWeaponAttachmentLeftHand.ThirdPersonDoReload();
            }
            // End:0x14E
            if(TurokAIControllerHumanNpc(Controller) != none)
            {
                TurokAIControllerHumanNpc(Controller).NotifyWeaponStartedReloading();
            }            
        }
        else
        {
            // End:0x181
            if((int(hand) == int(0)) && mWeaponAttachmentRightHand != none)
            {
                mWeaponAttachmentRightHand.FinishedThirdPersonReload();
            }
            // End:0x1B1
            if((int(hand) == int(1)) && mWeaponAttachmentLeftHand != none)
            {
                mWeaponAttachmentLeftHand.FinishedThirdPersonReload();
            }
            // End:0x1D9
            if(TurokAIControllerHumanNpc(Controller) != none)
            {
                TurokAIControllerHumanNpc(Controller).NotifyWeaponFinishedReloading();
            }
        }
    }
    //return;    
}

simulated function WeaponPhaseReloading(bool bBeginning, byte hand)
{
    // End:0x36
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x29
        if(bBeginning)
        {
            SetWeaponReplicationFlag(3, hand);            
        }
        else
        {
            SetWeaponReplicationFlag(4, hand);
        }
    }
    // End:0x96
    if(TurokPlayerController(Controller) != none)
    {
        // End:0x74
        if(bBeginning)
        {
            TurokPlayerController(Controller).mZoomer.EnableSlideZoom(false);            
        }
        else
        {
            TurokPlayerController(Controller).mZoomer.EnableSlideZoom(true);
        }
    }
    // End:0x189
    if((int(Role) == int(ROLE_Authority)) || IsLocallyControlled())
    {
        // End:0x123
        if(bBeginning)
        {
            // End:0xD9
            if(mWeaponAttachmentRightHand != none)
            {
                mWeaponAttachmentRightHand.ThirdPersonDoPhaseReloading(true);
            }
            // End:0xF8
            if(mWeaponAttachmentLeftHand != none)
            {
                mWeaponAttachmentLeftHand.ThirdPersonDoPhaseReloading(true);
            }
            // End:0x120
            if(TurokAIControllerHumanNpc(Controller) != none)
            {
                TurokAIControllerHumanNpc(Controller).NotifyWeaponStartedReloading();
            }            
        }
        else
        {
            // End:0x142
            if(mWeaponAttachmentRightHand != none)
            {
                mWeaponAttachmentRightHand.ThirdPersonDoPhaseReloading(false);
            }
            // End:0x161
            if(mWeaponAttachmentLeftHand != none)
            {
                mWeaponAttachmentLeftHand.ThirdPersonDoPhaseReloading(false);
            }
            // End:0x189
            if(TurokAIControllerHumanNpc(Controller) != none)
            {
                TurokAIControllerHumanNpc(Controller).NotifyWeaponFinishedReloading();
            }
        }
    }
    //return;    
}

simulated function WeaponOverheating(bool bOverheating)
{
    // End:0x30
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x26
        if(bOverheating)
        {
            SetWeaponReplicationFlag(9, 0);            
        }
        else
        {
            SetWeaponReplicationFlag(10, 0);
        }
    }
    // End:0x90
    if(TurokPlayerController(Controller) != none)
    {
        // End:0x6E
        if(bOverheating)
        {
            TurokPlayerController(Controller).mZoomer.EnableSlideZoom(false);            
        }
        else
        {
            TurokPlayerController(Controller).mZoomer.EnableSlideZoom(true);
        }
    }
    // End:0x126
    if((int(Role) == int(ROLE_Authority)) || IsLocallyControlled())
    {
        // End:0xDE
        if(!bOverheating)
        {
            // End:0xDE
            if(TurokAIControllerHumanNpc(Controller) != none)
            {
                TurokAIControllerHumanNpc(Controller).NotifyWeaponFinishedOverheating();
            }
        }
        // End:0x102
        if(mWeaponAttachmentRightHand != none)
        {
            mWeaponAttachmentRightHand.RailgunAttachmentThirdPersonDoOverheat(bOverheating);
        }
        // End:0x126
        if(mWeaponAttachmentLeftHand != none)
        {
            mWeaponAttachmentLeftHand.RailgunAttachmentThirdPersonDoOverheat(bOverheating);
        }
    }
    //return;    
}

simulated function WeaponSteaming(bool bSteaming)
{
    // End:0x30
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x26
        if(bSteaming)
        {
            SetWeaponReplicationFlag(9, 0);            
        }
        else
        {
            SetWeaponReplicationFlag(10, 0);
        }
    }
    // End:0x93
    if((int(Role) == int(ROLE_Authority)) || IsLocallyControlled())
    {
        // End:0x6F
        if(mWeaponAttachmentRightHand != none)
        {
            mWeaponAttachmentRightHand.ChaingunAttachmentThirdPersonDoSteamEffect(bSteaming);
        }
        // End:0x93
        if(mWeaponAttachmentLeftHand != none)
        {
            mWeaponAttachmentLeftHand.ChaingunAttachmentThirdPersonDoSteamEffect(bSteaming);
        }
    }
    //return;    
}

simulated function DoShowFirebladeCanister()
{
    // End:0x4D
    if(TurokWeapAttachFirebladeNative(mWeaponAttachmentRightHand) != none)
    {
        SetWeaponReplicationFlag(7, 0);
        // End:0x4D
        if((int(Role) == int(ROLE_Authority)) || IsLocallyControlled())
        {
            TurokWeapAttachFirebladeNative(mWeaponAttachmentRightHand).Show3PFuelCellCanister();
        }
    }
    //return;    
}

simulated function DoHideFirebladeCanister()
{
    // End:0x4D
    if(TurokWeapAttachFirebladeNative(mWeaponAttachmentRightHand) != none)
    {
        SetWeaponReplicationFlag(8, 0);
        // End:0x4D
        if((int(Role) == int(ROLE_Authority)) || IsLocallyControlled())
        {
            TurokWeapAttachFirebladeNative(mWeaponAttachmentRightHand).Hide3PFuelCellCanister();
        }
    }
    //return;    
}

function MakeFirebladeNoise()
{
    // End:0x27
    if(mWeaponAttachmentRightHand != none)
    {
        MakeNoise(mWeaponAttachmentRightHand.mFiredNoiseLevel[0], 'NOISE_WeaponFired');
    }
    //return;    
}

simulated function SetFireBladeAnimMode(byte mode)
{
    local float canisterVisibleTime;

    // End:0x61
    if(int(Role) == int(ROLE_Authority))
    {
        mWeaponAttachmentFirebladeMode = mode;
        // End:0x41
        if(int(mWeaponAttachmentFirebladeMode) == int(1))
        {
            SetTimer(0.1000000, true, 'MakeFirebladeNoise');            
        }
        else
        {
            // End:0x61
            if(int(mWeaponAttachmentFirebladeMode) == int(3))
            {
                ClearTimer('MakeFirebladeNoise');
            }
        }
    }
    // End:0x132
    if((int(Role) == int(ROLE_Authority)) || IsLocallyControlled())
    {
        // End:0x132
        if(mWeaponAttachmentRightHand != none)
        {
            // End:0xD2
            if(int(mWeaponAttachmentFirebladeMode) == int(4))
            {
                canisterVisibleTime = TurokWeapFirebladeNative(GetRightHandWeapon()).mReloadAttachCanisterTime;
                SetTimer(canisterVisibleTime * 0.2000000, false, 'DoShowFirebladeCanister');                
            }
            else
            {
                // End:0x11A
                if(int(mWeaponAttachmentFirebladeMode) == int(6))
                {
                    canisterVisibleTime = TurokWeapFirebladeNative(GetRightHandWeapon()).mReloadDetachCanisterTime;
                    SetTimer(canisterVisibleTime * 0.4000000, false, 'DoHideFirebladeCanister');
                }
            }
            mWeaponAttachmentRightHand.SetFireBladeAnimMode(mWeaponAttachmentFirebladeMode);
        }
    }
    //return;    
}

simulated function NotifyWeaponZoom(bool Zooming)
{
    // End:0x1D
    if(int(Role) == int(ROLE_Authority))
    {
        mbWeaponAttachmentNotifyZoomPressed = Zooming;
    }
    // End:0x10F
    if(((int(Role) == int(ROLE_Authority)) || IsLocallyControlled()) && mWeaponMediator.GetPrimaryWeapon() != none)
    {
        // End:0xB7
        if(Zooming)
        {
            mWeaponMediator.GetPrimaryWeapon().NotifyZoomPressed();
            // End:0xB4
            if(mWeaponMediator.IsDualWielding())
            {
                mWeaponMediator.GetLeftHandWeapon().NotifyZoomPressed();
            }            
        }
        else
        {
            mWeaponMediator.GetPrimaryWeapon().NotifyZoomReleased();
            // End:0x10F
            if(mWeaponMediator.IsDualWielding())
            {
                mWeaponMediator.GetLeftHandWeapon().NotifyZoomReleased();
            }
        }
    }
    //return;    
}

simulated function NotifyAltFireLH(bool Start)
{
    // End:0x51
    if((int(Role) == int(ROLE_Authority)) || IsLocallyControlled())
    {
        // End:0x3C
        if(Start)
        {
            mWeaponMediator.FireLeftHandWeapon(1);            
        }
        else
        {
            mWeaponMediator.StopFiringLeftHandWeapon(1);
        }
    }
    //return;    
}

// Export UTurokPawnHuman::execThrowGrenade(FFrame&, void* const)
native function ThrowGrenade();

reliable server event ServerThrowGrenade()
{
    ThrowGrenade();
    //return;    
}

simulated function NotifyWeaponAmmoAdded(class<Class> ammoPoolClass)
{
    local @NULL tWeap;

    // End:0xDD
    if(IsLocallyControlled())
    {
        tWeap = GetRightHandWeapon();
        // End:0x73
        if(tWeap != none)
        {
            // End:0x73
            if((tWeap.GetAmmoPoolClass() == ammoPoolClass) || tWeap.GetAltAmmoPoolClass() == ammoPoolClass)
            {
                tWeap.NotifyAmmoAdded();
            }
        }
        tWeap = GetLeftHandWeapon();
        // End:0xDD
        if(tWeap != none)
        {
            // End:0xDD
            if((tWeap.GetAmmoPoolClass() == ammoPoolClass) || tWeap.GetAltAmmoPoolClass() == ammoPoolClass)
            {
                tWeap.NotifyAmmoAdded();
            }
        }
    }
    //return;    
}

simulated function DoShowSilencerRH()
{
    // End:0x18
    if(mWeaponAttachmentRightHand != none)
    {
        WeaponSetSilencer(true, 0);
    }
    //return;    
}

simulated function DoShowSilencerLH()
{
    // End:0x18
    if(mWeaponAttachmentLeftHand != none)
    {
        WeaponSetSilencer(true, 1);
    }
    //return;    
}

simulated function DoHideSilencerRH()
{
    // End:0x18
    if(mWeaponAttachmentRightHand != none)
    {
        WeaponSetSilencer(false, 0);
    }
    //return;    
}

simulated function DoHideSilencerLH()
{
    // End:0x18
    if(mWeaponAttachmentLeftHand != none)
    {
        WeaponSetSilencer(false, 1);
    }
    //return;    
}

simulated function WeaponSetSilencer(bool bSilence, byte hand)
{
    // End:0x36
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x29
        if(bSilence)
        {
            SetWeaponReplicationFlag(7, hand);            
        }
        else
        {
            SetWeaponReplicationFlag(8, hand);
        }
    }
    // End:0xAC
    if((int(Role) == int(ROLE_Authority)) || IsLocallyControlled())
    {
        // End:0x88
        if(int(hand) == int(0))
        {
            // End:0x85
            if(mWeaponAttachmentRightHand != none)
            {
                mWeaponAttachmentRightHand.SMGAttachmentSetSilencerVisibility(bSilence);
            }            
        }
        else
        {
            // End:0xAC
            if(mWeaponAttachmentLeftHand != none)
            {
                mWeaponAttachmentLeftHand.SMGAttachmentSetSilencerVisibility(bSilence);
            }
        }
    }
    //return;    
}

simulated function WeaponChangeSilencer(bool bSilence, byte hand)
{
    local float silencerVisibilityTime;

    // End:0xAB
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x36
        if(bSilence)
        {
            SetWeaponReplicationFlag(8, hand);
            SetWeaponReplicationFlag(5, hand);            
        }
        else
        {
            SetWeaponReplicationFlag(7, hand);
            SetWeaponReplicationFlag(6, hand);
        }
        // End:0x87
        if(int(hand) == int(0))
        {
            // End:0x84
            if(mWeaponAttachmentRightHand != none)
            {
                mWeaponAttachmentRightHand.SetNoiseLevel(bSilence);
            }            
        }
        else
        {
            // End:0xAB
            if(mWeaponAttachmentLeftHand != none)
            {
                mWeaponAttachmentLeftHand.SetNoiseLevel(bSilence);
            }
        }
    }
    // End:0x20F
    if((int(Role) == int(ROLE_Authority)) || IsLocallyControlled())
    {
        // End:0x174
        if(int(hand) == int(0))
        {
            // End:0x171
            if(mWeaponAttachmentRightHand != none)
            {
                mWeaponAttachmentRightHand.SMGAttachmentThirdPersonDoEquipSilencer(bSilence);
                // End:0x13E
                if(bSilence)
                {
                    silencerVisibilityTime = TurokWeapSmgNative(GetRightHandWeapon()).mEnableSilencerTime;
                    SetTimer(silencerVisibilityTime * 0.5000000, false, 'DoShowSilencerRH');                    
                }
                else
                {
                    silencerVisibilityTime = GetRightHandWeapon().default.mDisableSilencerTime;
                    SetTimer(silencerVisibilityTime * 0.5000000, false, 'DoHideSilencerRH');
                }
            }            
        }
        else
        {
            // End:0x20F
            if(mWeaponAttachmentLeftHand != none)
            {
                mWeaponAttachmentLeftHand.SMGAttachmentThirdPersonDoEquipSilencer(bSilence);
                // End:0x1DC
                if(bSilence)
                {
                    silencerVisibilityTime = TurokWeapSmgNative(GetLeftHandWeapon()).mEnableSilencerTime;
                    SetTimer(silencerVisibilityTime * 0.5000000, false, 'DoShowSilencerLH');                    
                }
                else
                {
                    silencerVisibilityTime = GetLeftHandWeapon().default.mDisableSilencerTime;
                    SetTimer(silencerVisibilityTime * 0.5000000, false, 'DoHideSilencerLH');
                }
            }
        }
    }
    //return;    
}

simulated function WeaponRPGRocketVisible(bool bVisible)
{
    // End:0x44
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x30
        if(bVisible)
        {
            SetWeaponReplicationFlag(5, 0);
            SetWeaponReplicationFlag(7, 0);            
        }
        else
        {
            SetWeaponReplicationFlag(6, 0);
            SetWeaponReplicationFlag(8, 0);
        }
    }
    // End:0x83
    if((int(Role) == int(ROLE_Authority)) || IsLocallyControlled())
    {
        // End:0x83
        if(mWeaponAttachmentRightHand != none)
        {
            mWeaponAttachmentRightHand.RPGAttachmentThirdPersonDoRocketVisible(bVisible);
        }
    }
    //return;    
}

simulated event WeaponThrowGrenade()
{
    // End:0x1A
    if(int(Role) == int(ROLE_Authority))
    {
        SetWeaponReplicationFlag(ROLE_None, ROLE_None);
    }
    // End:0x54
    if((int(Role) == int(ROLE_Authority)) || IsLocallyControlled())
    {
        // End:0x54
        if(mWeaponAttachmentRightHand != none)
        {
            mWeaponAttachmentRightHand.DoGrenadeToss3P(true);
        }
    }
    //return;    
}

simulated function bool IsWeaponReloading()
{
    local @NULL tWeap;

    tWeap = GetRightHandWeapon();
    // End:0x55
    if((tWeap != none) && (tWeap.GetStateName() == 'Reloading') || tWeap.GetStateName() == 'EndReloading')
    {
        return true;
    }
    tWeap = GetLeftHandWeapon();
    // End:0xAA
    if((tWeap != none) && (tWeap.GetStateName() == 'Reloading') || tWeap.GetStateName() == 'EndReloading')
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function SetAttachmentBowTension(float Tension)
{
    local byte scaledTension;

    scaledTension = byte(Tension * float(255));
    // End:0x2E
    if(int(Role) == int(ROLE_Authority))
    {
        mWeaponAttachmentBowTension = scaledTension;
    }
    // End:0x6C
    if((int(Role) == int(ROLE_Authority)) || IsLocallyControlled())
    {
        // End:0x6C
        if(mWeaponAttachmentRightHand != none)
        {
            mWeaponAttachmentRightHand.BowAttachmentAddTension(scaledTension);
        }
    }
    //return;    
}

simulated function SetAttachmentChaingunSpinStatus(bool SpinningUp)
{
    // End:0x1D
    if(int(Role) == int(ROLE_Authority))
    {
        mChaingunSpinningUp = SpinningUp;
    }
    // End:0x5C
    if((int(Role) == int(ROLE_Authority)) || IsLocallyControlled())
    {
        // End:0x5C
        if(mWeaponAttachmentRightHand != none)
        {
            mWeaponAttachmentRightHand.ChainGunAttachmentSetSpinStatus(mChaingunSpinningUp);
        }
    }
    //return;    
}

simulated function SetAttachmentChaingunLights(byte Lights)
{
    // End:0x1B
    if(int(Role) == int(ROLE_Authority))
    {
        mChaingunLights = Lights;
    }
    // End:0x59
    if((int(Role) == int(ROLE_Authority)) || IsLocallyControlled())
    {
        // End:0x59
        if(mWeaponAttachmentRightHand != none)
        {
            mWeaponAttachmentRightHand.ChainGunAttachmentSetLights(Lights);
        }
    }
    //return;    
}

function StartAutoTurretIdleAnim(bool bStartAnim)
{
    mbWeaponAttachmentStartAutoTurretIdle = bStartAnim;
    // End:0x36
    if((mWeaponAttachmentRightHand != none) && bStartAnim)
    {
        mWeaponAttachmentRightHand.ChainGunAttachmentStartTripodIdle();
    }
    //return;    
}

simulated function PlayArrowPullOutTransitionGraph()
{
    local @NULL tg;
    local float animTime;

    tg = mPullArrowOutGraphSet.FindRandomGraph();
    // End:0x9F
    if(tg != none)
    {
        PlayGraphReplicated(tg, Controller, 0);
        animTime = tg.GetPreviewDuration(Mesh, 0);
        SetTimer(animTime, false, 'PullArrowOutTimer');
        mbEnableImpactAnims = false;
        // End:0x9F
        if(TurokAIController(Controller) != none)
        {
            TurokAIController(Controller).NotifyHitReaction(animTime);
        }
    }
    //return;    
}

simulated function PullArrowOutTimer()
{
    mbEnableImpactAnims = true;
    //return;    
}

simulated event bool CanAutoAimTo()
{
    return true;
    //return ReturnValue;    
}

private final simulated function WeaponAttachmentSetClass(byte AttachHand, class<Class> AttachClass, out @NULL Attachment)
{
    // End:0x28
    if(AttachClass == none)
    {
        // End:0x25
        if(Attachment != none)
        {
            RemoveWeaponAttachment(AttachHand);
        }        
    }
    else
    {
        // End:0x42
        if(Attachment != none)
        {
            RemoveWeaponAttachment(AttachHand);
        }
        Attachment = new (self) AttachClass;
        // DebugMode: 0
        assert(Attachment != none);
        Attachment.SetAttachmentMeshVisibility(!IsFirstPerson(), mbWeaponsVisibleIn3rdPerson);
        // DebugMode: 0
        assert(Mesh != none);
        Attachment.attachTo(Mesh, AttachHand, mWeaponMediator.IsDualWieldPending());
    }
    //return;    
}

simulated function RemoveWeaponAttachment(byte hand)
{
    // End:0x3D
    if(int(hand) == int(0))
    {
        // End:0x3A
        if(mWeaponAttachmentRightHand != none)
        {
            mWeaponAttachmentRightHand.DetachFrom(Mesh);
            mWeaponAttachmentRightHand = none;
        }        
    }
    else
    {
        // End:0x77
        if(int(hand) == int(1))
        {
            // End:0x77
            if(mWeaponAttachmentLeftHand != none)
            {
                mWeaponAttachmentLeftHand.DetachFrom(Mesh);
                mWeaponAttachmentLeftHand = none;
            }
        }
    }
    //return;    
}

simulated function @NULL WeaponAttachmentChanged(byte hand)
{
    // DebugMode: 0
    assert(int(hand) != int(2));
    // End:0x36
    if(int(hand) == int(0))
    {
        WeaponAttachmentSetClass(0, mWeaponAttachmentClassRightHand, mWeaponAttachmentRightHand);        
    }
    else
    {
        WeaponAttachmentSetClass(1, mWeaponAttachmentClassLeftHand, mWeaponAttachmentLeftHand);
    }
    // End:0x61
    if(int(hand) == int(0))
    {
        return mWeaponAttachmentRightHand;        
    }
    else
    {
        return mWeaponAttachmentLeftHand;
    }
    //return ReturnValue;    
}

simulated function SetWeaponsVisibleIn3rdPerson(bool bVisible)
{
    mbWeaponsVisibleIn3rdPerson = bVisible;
    SetWeaponMeshVisibility(!IsFirstPerson());
    //return;    
}

simulated function SetWeaponsInstantSwitch(byte hand, bool bInstant)
{
    // End:0x20
    if(int(hand) == int(0))
    {
        mbWeaponsInstantSwitchRight = bInstant;        
    }
    else
    {
        mbWeaponsInstantSwitchLeft = bInstant;
    }
    //return;    
}

simulated function bool GetWeaponsInstantSwitch(byte hand)
{
    // End:0x1A
    if(int(hand) == int(0))
    {
        return mbWeaponsInstantSwitchRight;        
    }
    else
    {
        return mbWeaponsInstantSwitchLeft;
    }
    //return ReturnValue;    
}

simulated event ActivateWeapons(bool Activate)
{
    local @NULL activeWeapon;

    // End:0x0B
    if(bPendingDelete)
    {
        return;
    }
    // End:0x64
    if(int(Role) == int(ROLE_SimulatedProxy))
    {
        // End:0x62
        if(!Activate)
        {
            // End:0x44
            if(mWeaponAttachmentRightHand != none)
            {
                mWeaponAttachmentRightHand.Stop3rdPersonEffectsImmediately();
            }
            // End:0x62
            if(mWeaponAttachmentLeftHand != none)
            {
                mWeaponAttachmentLeftHand.Stop3rdPersonEffectsImmediately();
            }
        }
        return;
    }
    // End:0xE6
    if(Activate)
    {
        activeWeapon = mWeaponMediator.GetRightHandWeapon();
        // End:0xA8
        if(activeWeapon != none)
        {
            activeWeapon.GotoState('ReActivated');
        }
        activeWeapon = mWeaponMediator.GetLeftHandWeapon();
        // End:0xE3
        if(activeWeapon != none)
        {
            activeWeapon.GotoState('ReActivated');
        }        
    }
    else
    {
        activeWeapon = mWeaponMediator.GetRightHandWeapon();
        // End:0x121
        if(activeWeapon != none)
        {
            activeWeapon.GotoState('Deactivated');
        }
        activeWeapon = mWeaponMediator.GetLeftHandWeapon();
        // End:0x15C
        if(activeWeapon != none)
        {
            activeWeapon.GotoState('Deactivated');
        }
    }
    //return;    
}

simulated function ForceWeaponSwitch()
{
    InvManager.SwitchToBestWeapon(true);
    //return;    
}

function bool StopFiring()
{
    local @NULL locweapon;
    local int currFireMode;

    locweapon = GetRightHandWeapon();
    // End:0x63
    if(locweapon != none)
    {
        currFireMode = int(locweapon.GetFiringMode());
        locweapon.StopFire(byte(currFireMode));
        locweapon.InterruptWeaponAction();
    }
    locweapon = GetLeftHandWeapon();
    // End:0xC6
    if(locweapon != none)
    {
        currFireMode = int(locweapon.GetFiringMode());
        locweapon.StopFire(byte(currFireMode));
        locweapon.InterruptWeaponAction();
    }
    return true;
    //return ReturnValue;    
}

// Export UTurokPawnHuman::execFiringModeUpdated(FFrame&, void* const)
native function FiringModeUpdated(bool bViaReplication);

// Export UTurokPawnHuman::execFiringModeLHUpdated(FFrame&, void* const)
native function FiringModeLHUpdated(bool bViaReplication);

simulated function SetDWSwitchMode(byte switchMode)
{
    // End:0x1B
    if(int(Role) == int(ROLE_Authority))
    {
        mDWSwitchMode = switchMode;
    }
    // End:0x4E
    if((int(Role) == int(ROLE_Authority)) || IsLocallyControlled())
    {
        mWeaponMediator.SetDualWieldSwitchMode(switchMode);
    }
    //return;    
}

simulated function SetDWFlag(bool IsDualWielding)
{
    // End:0x1D
    if(int(Role) == int(ROLE_Authority))
    {
        mbIsDualWielding = IsDualWielding;
    }
    // End:0x51
    if((int(Role) == int(ROLE_Authority)) || IsLocallyControlled())
    {
        mWeaponMediator.SetDualWieldingFlag(IsDualWielding);
    }
    //return;    
}

function bool IsChaingunSpinningUp()
{
    return mChaingunSpinningUp;
    //return ReturnValue;    
}

function SetChaingunNeedsUpdating(bool NeedsUpdating)
{
    mbChaingunNeedsUpdating = NeedsUpdating;
    //return;    
}

function bool CanAttack(@NULL Other)
{
    return mWeaponMediator.CanAttack(Other);
    //return ReturnValue;    
}

function float RefireRate()
{
    return 0.0000000;
    //return ReturnValue;    
}

function bool FireOnRelease()
{
    return false;
    //return ReturnValue;    
}

function bool HasRangedAttack()
{
    return false;
    //return ReturnValue;    
}

function bool IsFiring()
{
    return mWeaponMediator.IsFiring();
    //return ReturnValue;    
}

simulated function TurnOff()
{
    mWeaponMediator.StopFiringWeapons(0);
    mWeaponMediator.StopFiringWeapons(1);
    super(Pawn).TurnOff();
    //return;    
}

simulated function bool CanThrowWeapon()
{
    return mWeaponMediator.CanThrowWeapon();
    //return ReturnValue;    
}

function TossWeapon(@NULL TossVel)
{
    local @NULL tim;

    // End:0x1C
    if(mbCanDropWeapons)
    {
        TossSpecificWeapon(TossVel);        
    }
    else
    {
        mWeaponMediator.ClearBothWeapons();
        tim = TurokInventoryManager(InvManager);
        // End:0x5D
        if(tim != none)
        {
            tim.DestroyInventory();
        }
    }
    //return;    
}

function TossSpecificWeapon(@NULL TossVel, optional @NULL weaponToToss = none)
{
    mWeaponMediator.TossWeapon(TossVel, self, weaponToToss);
    //return;    
}

simulated function ReleaseWeapon()
{
    mWeaponMediator.ReleaseWeapon();
    //return;    
}

simulated function SetActiveWeapon(@NULL NewWeapon)
{
    // End:0x29
    if(InvManager != none)
    {
        TurokInventoryManager(InvManager).TurokSetCurrentWeapon(NewWeapon, true);
    }
    //return;    
}

simulated function @NULL WeaponBob(float BobDamping)
{
    return vect(0.0000000, 0.0000000, 0.0000000);
    //return ReturnValue;    
}

function CheckBob(float DeltaTime, @NULL Y)
{
    //return;    
}

// Export UTurokPawnHuman::execGetWeaponFireLocation(FFrame&, void* const)
native simulated function @NULL GetWeaponFireLocation(optional @NULL CurrentWeapon);

simulated event AttachInventory(class<Class> AttachedInventoryItemClass)
{
    mInventoryAttachmentClass = AttachedInventoryItemClass;
    // End:0x83
    if(mInventoryAttachment == none)
    {
        mInventoryAttachment = new (self) mInventoryAttachmentClass.static.GetAttachmentType();
        mInventoryAttachment.Attach(self.Mesh);
        mInventoryAttachment.SetAttachmentColor();
        mInventoryAttachment.SetAttachmentMeshVisibility(!IsFirstPerson());
    }
    //return;    
}

simulated event DetachInventory()
{
    // End:0x2F
    if(mInventoryAttachment != none)
    {
        mInventoryAttachment.Detach(self.Mesh);
        mInventoryAttachment = none;
    }
    mInventoryAttachmentClass = none;
    //return;    
}

simulated function class<Class> GetAttachedInventoryItemClass()
{
    return mInventoryAttachmentClass;
    //return ReturnValue;    
}

simulated function SimulatedPlayKnockdown()
{
    // End:0x34
    if(TurokPlayerController(Controller) != none)
    {
        mKnockdownTimer = Controller.WorldInfo.TimeSeconds + mKnockdownTime;
    }
    // End:0x5D
    if(mLadderController.IsClimbing())
    {
        mLadderController.FinishLadderGracefully();
    }
    mKnockdownController.InitSequence();
    //return;    
}

protected simulated function OnReplicatedKnockdown()
{
    mKnockdownInfo.mKnockdownType = 1;
    mKnockdownInfo.mStartRelAngle = 0.0000000;
    mKnockdownInfo.mHitLocation = mReplicatedKnockdown.mHitLocation;
    mKnockdownInfo.mHitActor = mReplicatedKnockdown.mHitActor;
    mKnockdownInfo.mSpeed = 0.0000000;
    mKnockdownInfo.mVerticalAngle = 0.0000000;
    mKnockdownInfo.mVerticalPushTime = 0.0000000;
    mKnockdownInfo.mPlayerRotationSpeed = 120.0000000;
    SimulatedPlayKnockdown();
    //return;    
}

protected reliable client simulated function ClientReplicatedKnockdown(@NULL KnockInfo, @NULL KnockLoc, @NULL KnockRot)
{
    // End:0x3D
    if((Controller != none) && Controller.IsInState('PlayerClimbing'))
    {
        Controller.GotoState('PlayerWalking');
    }
    SetLocation(KnockLoc);
    SetRotation(KnockRot);
    mReplicatedKnockdown = KnockInfo;
    OnReplicatedKnockdown();
    //return;    
}

protected function SetReplicatedKnockdown(@NULL HitPosition, @NULL HitActor)
{
    local @NULL CompressedLocation, CompressedRotation;

    TurokNetCompressVector(HitPosition);
    ++mReplicatedKnockdown.mNetDirty;
    mReplicatedKnockdown.mHitLocation = HitPosition;
    mReplicatedKnockdown.mHitActor = HitActor;
    bNetDirty = true;
    CompressedLocation = TurokNetCompressVector(Location);
    CompressedRotation = TurokNetCompressRotator(Rotation);
    // End:0xAD
    if((Controller != none) && Controller.IsInState('PlayerClimbing'))
    {
        Controller.GotoState('PlayerWalking');
    }
    // End:0xD1
    if(!IsLocallyControlled())
    {
        ClientReplicatedKnockdown(mReplicatedKnockdown, CompressedLocation, CompressedRotation);
    }
    SetLocation(CompressedLocation);
    SetRotation(CompressedRotation);
    //return;    
}

event PlayKnockdown(@NULL InstigatedBy, @NULL HitPosition)
{
    local @NULL HitActor;

    // End:0x0F
    if(IsInKnockdown())
    {
        return;
    }
    // End:0x1C
    if(Health <= 0)
    {
        return;
    }
    // End:0x2B
    if(IsMauling())
    {
        return;
    }
    // End:0x38
    if(DrivenVehicle != none)
    {
        return;
    }
    // End:0x60
    if((Controller != none) && Controller.IsInState('CannedAnimation'))
    {
        return;
    }
    // End:0x84
    if(IsInState('DeployMiniGunSentry') || IsInState('PickupMiniGunSentry'))
    {
        return;
    }
    // End:0xA6
    if(InstigatedBy != none)
    {
        HitActor = InstigatedBy.Pawn;        
    }
    else
    {
        HitActor = none;
    }
    SetReplicatedKnockdown(HitPosition, HitActor);
    OnReplicatedKnockdown();
    // End:0xF3
    if(TurokAIController(InstigatedBy) != none)
    {
        TurokAIController(InstigatedBy).NotifyCausedKnockdown();
    }
    //return;    
}

simulated function bool CanGrabLadder()
{
    return ((((bCanClimbLadders && !bDeleteMe) && !mLadderController.IsClimbing()) && int(Physics) != int(9)) && (int(Physics) != int(2)) || Abs(Velocity.Z) <= JumpZ) && mWeaponMediator.CanUseAction();
    //return ReturnValue;    
}

protected simulated function OnReplicatedDive()
{
    mKnockdownInfo.mKnockdownType = mReplicatedDive.mDiveType;
    mKnockdownInfo.mStartRelAngle = mReplicatedDive.mStartRelAngle;
    mKnockdownInfo.mSpeed = 0.0000000;
    mKnockdownInfo.mVerticalAngle = 0.0000000;
    mKnockdownInfo.mVerticalPushTime = 0.0000000;
    mKnockdownInfo.mPlayerRotationSpeed = 0.0000000;
    mKnockdownInfo.mHitLocation = vect(0.0000000, 0.0000000, 0.0000000);
    SimulatedPlayKnockdown();
    //return;    
}

protected reliable client simulated function ClientReplicatedDive(@NULL DiveInfo, @NULL DiveLoc, @NULL DiveRot)
{
    SetLocation(DiveLoc);
    SetRotation(DiveRot);
    mReplicatedDive = DiveInfo;
    OnReplicatedDive();
    //return;    
}

function Dive(float StartRelAngle)
{
    local @NULL CompressedLocation, CompressedRotation;

    ++mReplicatedDive.mNetDirty;
    mReplicatedDive.mDiveType = 2;
    mReplicatedDive.mStartRelAngle = StartRelAngle;
    bNetDirty = true;
    CompressedLocation = TurokNetCompressVector(Location);
    CompressedRotation = TurokNetCompressRotator(Rotation);
    // End:0x86
    if(!IsLocallyControlled())
    {
        ClientReplicatedDive(mReplicatedDive, CompressedLocation, CompressedRotation);
    }
    MakeNoise(mDiveNoise, 'NOISE_Footstep');
    SetLocation(CompressedLocation);
    SetRotation(CompressedRotation);
    OnReplicatedDive();
    //return;    
}

simulated function NotifyGraphStart(@NULL graph, byte actorType)
{
    //return;    
}

simulated function NotifyGraphEndToGraph(@NULL prevGraph, @NULL newGraph, byte actorType)
{
    //return;    
}

simulated function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
{
    //return;    
}

event PreCinematicStateCleanUp()
{
    // End:0x2E
    if(TurokVehicle(DrivenVehicle) != none)
    {
        TurokVehicle(DrivenVehicle).PawnExit(mSeatIndex, true);
    }
    super.PreCinematicStateCleanUp();
    //return;    
}

simulated event StartDriving(@NULL V)
{
    local @NULL TVH, TVS, mgr, TPC;
    local bool IsClientAndNotLocallyControlled;

    TVH = TurokVehicle(V);
    // DebugMode: 0
    assert(TVH != none);
    // DebugMode: 0
    assert(mSeatIndex > -1);
    // DebugMode: 0
    assert(mSeatIndex < TVH.GetNumSeats());
    TVS = TVH.Seats[mSeatIndex];
    // End:0x1B9
    if(int(Role) != int(ROLE_Authority))
    {
        TPC = TurokPlayerController(Controller);
        // End:0x111
        if(TPC != none)
        {
            // End:0x111
            if((((((GetPrimaryWeapon()) == none) || int(TPC.Role) != int(ROLE_AutonomousProxy)) || TurokPlayerCamera(TPC.PlayerCamera) == none) || TPC.Pawn != self) || TVH.mVehicleGun == none)
            {
                GotoState('PendingStartDriving');
                return;
            }
        }
        // End:0x154
        if(TVS.GetSeatedPawn() != none)
        {
            // DebugMode: 0
            assert(TVS.GetSeatedPawn() != self);
            GotoState('PendingStartDriving');
            return;
        }
        mgr = TurokInventoryManager(InvManager);
        // End:0x1B9
        if(((mgr != none) && mgr.PendingWeapon != none) && !mgr.PendingWeapon.IsA('TurokVehicleWeapon'))
        {
            GotoState('PendingStartDriving');
            return;
        }
    }
    IsClientAndNotLocallyControlled = (int(Role) != int(ROLE_Authority)) && !IsLocallyControlled();
    // End:0x210
    if(IsClientAndNotLocallyControlled && !TVH.VehicleHasGun())
    {
        TVH.mPendingDriver = self;        
    }
    else
    {
        NetUpdateTime = WorldInfo.TimeSeconds - float(1);
        switch(mSeatInOut)
        {
            // End:0x283
            case 1:
                // DebugMode: 0
                assert(int(Role) == int(ROLE_Authority));
                TVS.EntryStart(self);
                TVS.EntryFinished();
                TVS.PlayInVehicleAnimation();
                // End:0x317
                break;
            // End:0x2D6
            case 0:
                // DebugMode: 0
                assert(int(Role) != int(ROLE_Authority));
                TVS.EntryStart(self);
                TVS.EntryFinished();
                TVS.PlayInVehicleAnimation();
                // End:0x317
                break;
            // End:0x305
            case 2:
                TVS.EntryStart(self);
                TVS.PlayEntryAnimation();
                // End:0x317
                break;
            // End:0x30A
            case 3:
            // End:0x30F
            case 8:
            // End:0xFFFF
            default:
                // DebugMode: 0
                assert(false);
                break;
        }
    }
    // End:0x340
    if(TurokInventoryManager(InvManager) != none)
    {
        TurokInventoryManager(InvManager).SimulatedSetIsDroppingWeaponForPickup(false);
    }
    //return;    
}

simulated event StopDriving(@NULL V)
{
    local @NULL Spawn, TVH, TVS, TPC;

    NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    TVH = TurokVehicle(V);
    // DebugMode: 0
    assert(TVH != none);
    // DebugMode: 0
    assert(mSeatIndex > -1);
    // DebugMode: 0
    assert(mSeatIndex < TVH.GetNumSeats());
    TVS = TVH.Seats[mSeatIndex];
    Spawn = TVS.GetSeatedPawn();
    TPC = TurokPlayerController(Controller);
    // End:0xED
    if(Spawn == none)
    {
        // DebugMode: 0
        assert(int(Role) != int(ROLE_Authority));
        // End:0xEB
        if(TurokInventoryManager(InvManager) != none)
        {
            TurokInventoryManager(InvManager).SimulatedSetIsDroppingWeaponForPickup(false);
        }
        return;
    }
    switch(mSeatInOut)
    {
        // End:0x15A
        case 6:
            // DebugMode: 0
            assert(int(Role) == int(ROLE_Authority));
            // End:0x131
            if(TPC != none)
            {
                TPC.SimulatedSetTurokCamera('FirstPerson');
            }
            TVS.ExitStart();
            TVS.ExitFinished();
            // End:0x24B
            break;
        // End:0x199
        case 5:
            // DebugMode: 0
            assert(int(Role) != int(ROLE_Authority));
            TVS.ExitStart();
            TVS.ExitFinished();
            // End:0x24B
            break;
        // End:0x1C7
        case 7:
            TVS.ExitStart();
            TVS.PlayExitAnimation();
            // End:0x24B
            break;
        // End:0x1E7
        case 3:
            TVS.EntryFinished();
            mSeatInOut = 3;
        // End:0x228
        case 8:
            TVS.DyingStart();
            TVS.PlayDeathAnim();
            TVS.DyingFinished();
            // End:0x24B
            break;
        // End:0x243
        case 9:
            TVS.ForceExitToAnim();
            // End:0x24B
            break;
        // End:0xFFFF
        default:
            // DebugMode: 0
            assert(false);
            break;
    }
    // End:0x274
    if(TurokInventoryManager(InvManager) != none)
    {
        TurokInventoryManager(InvManager).SimulatedSetIsDroppingWeaponForPickup(false);
    }
    //return;    
}

simulated function StartCanisterFillSoundTimed()
{
    local editinline @NULL Attachment;

    Attachment = TurokWeapAttachFirebladeNative(mWeaponAttachmentRightHand);
    // End:0x2E
    if(Attachment != none)
    {
        Attachment.StartCanisterFillSound();
    }
    //return;    
}

state Dying
{
    simulated function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
    {
        SetCollision(true, false);
        OnAnimEnd(none, 0.0000000, 0.0000000);
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        //return;        
    }
    stop;    
}

state DefaultActionAnimation extends CannedAnimation
{
    simulated function BeginState(name PreviousStateName)
    {
        ActivateWeapons(false);
        SetWeaponsVisibleIn3rdPerson(false);
        super.BeginState(PreviousStateName);
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        SetWeaponsVisibleIn3rdPerson(true);
        ActivateWeapons(true);
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

state KnockdownAnimation
{
    simulated function BeginState(name PreviousStateName)
    {
        Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        SetPhysics(1);
        mbEnableImpactAnims = false;
        mKnockdownController.SetKnockdownState(3);
        mKnockdownController.mbHitWall = false;
        mKnockdownController.mElapsedVerticalVelocityTime = 0.0000000;
        ActivateWeapons(false);
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        mbEnableImpactAnims = true;
        mKnockdownController.FinishKnockdown();
        ActivateWeapons(true);
        //return;        
    }

    simulated function Tick(float DeltaTime)
    {
        global.Tick(DeltaTime);
        mKnockdownController.Tick(DeltaTime);
        //return;        
    }
    stop;    
}

state MeleeAttackAnimation extends CannedAnimation
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        mbEnableImpactAnims = false;
        DeActivateSkeletalHurt(5);
        // End:0x3D
        if(Controller != none)
        {
            Controller.GotoState('StealthKillAnimation');
        }
        ActivateWeapons(false);
        // End:0x6D
        if(int(mReplicatedGraph.mActorType) == int(0))
        {
            SetWeaponsVisibleIn3rdPerson(false);
        }
        // End:0xB0
        if(((Controller != none) && Controller.IsLocalPlayerController()) && mCurrentGrassField != none)
        {
            mCurrentGrassField.EnableOcclusionPrevention();
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        local @NULL tpActor;

        mbEnableImpactAnims = true;
        EnableSmashDamage();
        super.EndState(NextStateName);
        ActivateWeapons(true);
        // End:0x105
        if(int(mReplicatedGraph.mActorType) == int(0))
        {
            SetWeaponsVisibleIn3rdPerson(true);
            // End:0x102
            if(Health <= 0)
            {
                tpActor = TurokPawn(mReplicatedGraph.mActor);
                // End:0x102
                if(tpActor != none)
                {
                    // End:0xC6
                    if(int(Role) == int(ROLE_Authority))
                    {
                        tpActor.TakeDamage(Health, mStealthKiller, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'TurokDamageTypeStealthKill');                        
                    }
                    else
                    {
                        // End:0x102
                        if(bPlayedDeath == false)
                        {
                            TearOffMomentum = vect(0.0000000, 0.0000000, 0.0000000);
                            tpActor.PlayDying(Class'TurokDamageTypeStealthKill', Location);
                        }
                    }
                }
            }            
        }
        else
        {
            // End:0x192
            if(int(mReplicatedGraph.mActorType) == int(3))
            {
                // End:0x15F
                if(int(Role) == int(ROLE_Authority))
                {
                    TakeDamage(Health, mStealthKiller, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'TurokDamageTypeStealthKill');                    
                }
                else
                {
                    // End:0x192
                    if(bPlayedDeath == false)
                    {
                        TearOffMomentum = vect(0.0000000, 0.0000000, 0.0000000);
                        PlayDying(Class'TurokDamageTypeStealthKill', Location);
                    }
                }
            }
        }
        // End:0x1D5
        if(((Controller != none) && Controller.IsLocalPlayerController()) && mCurrentGrassField != none)
        {
            mCurrentGrassField.DisableOcclusionPrevention();
        }
        //return;        
    }
    stop;    
}

state DefenderMaulAnimation extends CannedAnimation
{
    simulated function BeginState(name prevState)
    {
        ActivateWeapons(false);
        SetWeaponsVisibleIn3rdPerson(false);
        mbIsMauling = true;
        super.BeginState(prevState);
        //return;        
    }

    simulated function EndState(name NextState)
    {
        SetWeaponsVisibleIn3rdPerson(true);
        ActivateWeapons(true);
        mbIsMauling = false;
        super.EndState(NextState);
        //return;        
    }
    stop;    
}

state climbing
{
    simulated function BeginState(name PreviousState)
    {
        ActivateWeapons(false);
        super.BeginState(PreviousState);
        //return;        
    }

    simulated function EndState(name NextState)
    {
        super.EndState(NextState);
        ActivateWeapons(true);
        //return;        
    }
    stop;    
}

state PendingStartDriving
{
    simulated function BeginState(name prevState)
    {
        SetTimer(0.2000000, false, 'PendingStartDrivingTimer');
        //return;        
    }

    simulated function PendingStartDrivingTimer()
    {
        GotoState('None');
        // End:0x38
        if((DrivenVehicle != none) && !bPendingDelete)
        {
            StartDriving(DrivenVehicle);            
        }
        else
        {
            // End:0x61
            if(TurokInventoryManager(InvManager) != none)
            {
                TurokInventoryManager(InvManager).SimulatedSetIsDroppingWeaponForPickup(false);
            }
        }
        //return;        
    }

    simulated function EndState(name NextState)
    {
        ClearTimer('PendingStartDrivingTimer');
        //return;        
    }
    stop;    
}

defaultproperties
{
    mbCanDropWeapons=true
    mbWeaponsVisibleIn3rdPerson=true
    // Reference: TurokWeaponMediator'Default__TurokPawnHuman.TurokWeaponMediatorComponent'
    begin object name=TurokWeaponMediatorComponent class=Class'TurokWeaponMediator'
    end object
    mWeaponMediator=TurokWeaponMediatorComponent
    mMeleeAttackGraphSetNames=/* Array type was not detected. */
    mActionGraphSetNames=/* Array type was not detected. */
    mInstantKillGraphSetNames=/* Array type was not detected. */
    mSeatIndex=-1
    // Reference: TurokMeleeMaulMeter'Default__TurokPawnHuman.MeterComponent'
    begin object name=MeterComponent class=Class'TurokMeleeMaulMeter'
        mTimeToFill=1.0000000
        mMinTimeBetweenAttacks=4.0000000
    end object
    mMeleeMaulMeter=MeterComponent
    // Reference: TurokAnimKnockdownController'Default__TurokPawnHuman.KnockdownComponent'
    begin object name=KnockdownComponent class=Class'TurokAnimKnockdownController'
    end object
    mKnockdownController=KnockdownComponent
    mKnockdownInfo=(mKnockdownType=0,mHitLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000),mSpeed=500.0000000,mVerticalAngle=30.0000000,mVerticalPushTime=0.1000000,mPlayerRotationSpeed=360.0000000,mStartRelAngle=0.0000000,mStartRotation=(Pitch=0,Yaw=0,Roll=0),mHitActor=none)
    mKnockdownTime=11.0000000
    mHUDInfoOffset=(X=0.0000000,Y=0.0000000,Z=50.0000000)
    mUnderFireTimeoutTime=1
    // Reference: TurokAISteer'Default__TurokPawnHuman.TurokAISteerComponent'
    begin object name=TurokAISteerComponent
    end object
    mSteer=TurokAISteerComponent
    // Reference: TurokAIPlanner'Default__TurokPawnHuman.TurokAIPlannerComponent'
    begin object name=TurokAIPlannerComponent
    end object
    mPlanner=TurokAIPlannerComponent
    // Reference: DynamicLightEnvironmentComponent'Default__TurokPawnHuman.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    mLookSphereRadius=1500.0000000
    mRandomSphereRadius=750.0000000
    mAngleThreshold=0.1000000
    mLookSphereHeight=1500.0000000
    mTerrainFollowType=1
    mHealthAsset=TurokAnimHealthAsset'TurokHealthAssets.HumanHA'
    mbAllowDinoMelee=true
    // Reference: TurokPathController'Default__TurokPawnHuman.TurokPathControllerComponent'
    begin object name=TurokPathControllerComponent
    end object
    mPathController=TurokPathControllerComponent
    // Reference: TurokTargetingSystem'Default__TurokPawnHuman.TurokTargetingSystemComponent'
    begin object name=TurokTargetingSystemComponent
    end object
    mTargetingSystem=TurokTargetingSystemComponent
    mFlamePS=ParticleSystem'FXSmokes.ParticleSystems.HumanSmokePS'
    // Reference: TurokSoundController'Default__TurokPawnHuman.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
        mLimitedSounds=/* Array type was not detected. */
        mProxySounds=/* Array type was not detected. */
    end object
    mSoundController=TurokSoundControllerComponent
    mFoleySounds=/* Array type was not detected. */
    mBodyFallSndCue=SoundCue'SndCreatureHuman.BodyFallaSndCue'
    mJumpSndCue=SoundCue'SndCreatureHuman.CreatureHumanJumpASndCue'
    mDeathSndCue=SoundCue'SndCreatureHuman.CreatureHumanDeathSndCue'
    mExertionSndCue=SoundCue'SndCreatureHuman.CreatureHumanExertionSndCue'
    mGruntSndCue=SoundCue'SndCreatureHuman.CreatureHumanGruntSndCue'
    mFootStepEffects=/* Array type was not detected. */
    mTerrainSampleRadius=22.0000000
    mTerrainSinkHeight=4.0000000
    mPartialRagdollFixedJoints=/* Array type was not detected. */
    mRecoveryPlaneJoints=/* Array type was not detected. */
    mCollisionEventJoints=/* Array type was not detected. */
    // Reference: TurokAnimLadderController'Default__TurokPawnHuman.ladderController'
    begin object name=ladderController
    end object
    mLadderController=ladderController
    bSimulateGravity=true
    // Reference: SkeletalMeshComponent'Default__TurokPawnHuman.TurokSkeletalMeshComponent'
    begin object name=TurokSkeletalMeshComponent
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokPawnHuman.MyLightEnvironment'
    end object
    Mesh=TurokSkeletalMeshComponent
    // Reference: CylinderComponent'Default__TurokPawnHuman.CollisionCylinder'
    begin object name=CollisionCylinder
    end object
    CylinderComponent=CollisionCylinder
    InventoryManagerClass=Class'TurokInventoryManager'
    mDefaultTraceTypeFlags=0
    mDefaultTraceSourceFlags=288
    Components[0]=CollisionCylinder
    // Reference: ArrowComponent'Default__TurokPawnHuman.Arrow'
    begin object name=Arrow
    end object
    Components[1]=Arrow
    Components[2]=TurokAISteerComponent
    Components[3]=TurokAIPlannerComponent
    Components[4]=TurokPathControllerComponent
    Components[5]=TurokTargetingSystemComponent
    Components[6]=MyLightEnvironment
    Components[7]=TurokSkeletalMeshComponent
    Components[8]=TurokSoundControllerComponent
    Components[9]=ladderController
    Components[10]=TurokWeaponMediatorComponent
    // Reference: SkeletalMeshComponent'Default__TurokPawnHuman.TurokHeadSkeletalMeshComponent'
    begin object name=TurokHeadSkeletalMeshComponent class=Class'Engine.SkeletalMeshComponent'
        AnimTreeTemplate=AnimTree'HumanAvgDummy.AnimTreeFace'
        ParentAnimComponent=SkeletalMeshComponent'Default__TurokPawnHuman.TurokSkeletalMeshComponent'
        bUpdateAnimWhenNotRendered=false
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokPawnHuman.MyLightEnvironment'
        AlwaysDrawShadow=true
    end object
    Components[11]=TurokHeadSkeletalMeshComponent
    Components[12]=MeterComponent
    Components[13]=KnockdownComponent
    CollisionComponent=CollisionCylinder
    Mass=0.5000000
}