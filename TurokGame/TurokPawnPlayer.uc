class TurokPawnPlayer extends TurokPawnHuman
    abstract
    native
    nativereplication
    config(Pawn)
    hidecategories(Navigation);

const mHealthRegenDefnArraySize = 5;

struct native CompanionFollowNode
{
    var @NULL mPathNode;
    var float mTimeOfLastUpdate;
    var float mCurrentUserWeighting;
    var @NULL mCurrentUser;

    structdefaultproperties
    {
        mPathNode=none
        mTimeOfLastUpdate=0.0000000
        mCurrentUserWeighting=0.0000000
        mCurrentUser=none
    }
};

var(POV) export editinline @NULL mPovLegsMesh;
var(POV) export editinline @NULL mPovArms;
var(Quiver) export editinline @NULL mQuiverMesh;
var(Quiver) export editinline @NULL mEmptyQuiverMesh;
var(POV) private const float mWeapPOVRate;
var private float mCurWeapPOVOffset;
var(Crouch) private const float mCrouchEyeHeight;
var(Crouch) private const float mCrouchDuration;
var private float mCrouchWeight;
var private float mCrouchRate;
var private float mCrouchHeightAdjust;
var(Eyes) private const float mEyeForwardAtLookingForward;
var(Eyes) private const float mEyeForwardAtLookingDown;
var(Stealth) private const float mStealthSoundDampen;
var(Stealth) private const float mBaseSoundDampen;
var(Health) protected const config @NULL mHealthRegenDefn[5];
var(Health) protected const float mHealthRegenTime;
var(Health) protected bool mbEnableHealthRegen;
var bool mbInDeathMoment;
var bool mbGroggySoundIsPlaying;
var bool mbForcedKnockdown;
var bool mIsInKnockDownSafeZone;
var bool mDisableResetAttachmentsCamera;
var bool mbIsStealthKilling;
var bool mbPlayerImmortal;
var bool mCheatSloMo;
var bool mbPlayerCanOneShotKill;
var bool mIsFriendlyMode;
var(Camera) const float mCam_TimeTriggerManual;
var(Camera) const float mCam_TimeTriggerAuto;
var(Camera) const int mDeathCam_DebugFlag;
var(Camera) const float mDeathCam_FOV;
var(Camera) const float mDeathCam_ManualOrbitRadius;
var(Camera) const float mDeathCam_ManualGroundOffsetZ;
var(Camera) const float mDeathCam_MaxKillerDistance;
var(Camera) const float mDeathCam_PullBackDistance;
var(Camera) const float mDeathCam_TimeBlend;
var(Camera) const float mDriverCam_TimeBlend;
var(Camera) const float m1pCam_InterpSpeed;
var(Diving) const config float mMinDiveXDeflection;
var(Diving) const config float mMinDiveSpeed;
var(Diving) const config float mMinDiveAngle;
var(Diving) const config float mMaxDiveAngle;
var(Sound) protected const @NULL mSelfImpactSndCue;
var(Sound) protected const @NULL mGroggySndCue;
var(Sound) protected const @NULL mDeathMomentSndCue;
var(Sound) protected const @NULL mDeafToneSndCue;
var(Sound) protected const float mDeafToneDuckerVolume;
var(Sound) protected const float mDeafToneFadeTime;
var(Sound) protected const float mToneDeafDelay;
var(Sound) protected const float mToneDeafFullTime;
var(Sound) @NULL mDyingMomentSndCue;
var const config float mPawnDamageBreathingEnable;
var private native transient @NULL mCompanionFollowNodes;
var protected @NULL mpPathActor;
var protected float mElapsedTime;
var protected int mWeaponState;
var private @NULL mForcedKnockdownInstigator;
var private float mForcedKnockdownDistance;
var array mJumpTime;
var config float mJumpPenaltyValidTime;
var config float mJumpPenalty;
var config float mMaxJumpPenalty;
var private byte mRemoteViewPitch;
var private byte mRemoteViewYaw;
var config float mDinoRearKnockdownAngleCos;
var config float mDinoRearKnockdownMinPlayerSpeed;
var repnotify transient @NULL mMiniGunSentryGraph;
var private transient @NULL mMiniGunSentrySpawnRot;
var private transient @NULL mMiniGunSentrySpawnPos;
var private transient @NULL mDeployerBasePos;
var private transient @NULL mDeployerBase;

replication
{
    // Pos:0x000
    if(bNetDirty && !bNetOwner
        mMiniGunSentryGraph, mRemoteViewPitch, 
        mRemoteViewYaw;
}

// Export UTurokPawnPlayer::execGetEyeForwardValue(FFrame&, void* const)
native simulated function float GetEyeForwardValue(int CurrentPitch);

// Export UTurokPawnPlayer::execGetPawnViewLocation(FFrame&, void* const)
native simulated function @NULL GetPawnViewLocation();

// Export UTurokPawnPlayer::execGetActorEyesViewPoint(FFrame&, void* const)
native simulated function GetActorEyesViewPoint(out @NULL out_Location, out @NULL out_Rotation);

// Export UTurokPawnPlayer::execIsInGrass(FFrame&, void* const)
native function bool IsInGrass();

// Export UTurokPawnPlayer::execGetIsStealth(FFrame&, void* const)
native function bool GetIsStealth();

// Export UTurokPawnPlayer::execAttachToPath(FFrame&, void* const)
native function AttachToPath(string PathName);

// Export UTurokPawnPlayer::execFollowPath(FFrame&, void* const)
native function FollowPath(float Delta);

// Export UTurokPawnPlayer::execIsSpecificFollowNodeStale(FFrame&, void* const)
native function bool IsSpecificFollowNodeStale(@NULL Node, @NULL User);

// Export UTurokPawnPlayer::execIsFollowNodeStale(FFrame&, void* const)
native function bool IsFollowNodeStale(@NULL Node, @NULL User);

// Export UTurokPawnPlayer::execCanUseSpecificFollowNode(FFrame&, void* const)
native function bool CanUseSpecificFollowNode(@NULL Node, float weighting, @NULL User);

// Export UTurokPawnPlayer::execCanUseFollowNode(FFrame&, void* const)
native function bool CanUseFollowNode(@NULL Node, float weighting, @NULL User);

// Export UTurokPawnPlayer::execIsUsingFollowNode(FFrame&, void* const)
native function bool IsUsingFollowNode(@NULL Node, @NULL User);

// Export UTurokPawnPlayer::execStartUsingFollowNode(FFrame&, void* const)
native function bool StartUsingFollowNode(@NULL Node, float currentUserWeighting, @NULL CurrentUser);

// Export UTurokPawnPlayer::execUpdateFollowNodeUse(FFrame&, void* const)
native function bool UpdateFollowNodeUse(@NULL Node, float currentUserWeighting, @NULL CurrentUser);

// Export UTurokPawnPlayer::execStopUsingFollowNode(FFrame&, void* const)
native function StopUsingFollowNode(@NULL Node, @NULL CurrentUser);

// Export UTurokPawnPlayer::execOnAnimStateChanged(FFrame&, void* const)
native function OnAnimStateChanged(byte NewState);

// Export UTurokPawnPlayer::execAttachDefaultAnimations(FFrame&, void* const)
protected native function AttachDefaultAnimations();

// Export UTurokPawnPlayer::execPlayDeathSound(FFrame&, void* const)
native simulated function PlayDeathSound(byte DamageType, optional @NULL deathSound);

// Export UTurokPawnPlayer::execAllowMauling(FFrame&, void* const)
native simulated function bool AllowMauling();

// Export UTurokPawnPlayer::execSetMeshVisibility(FFrame&, void* const)
native function SetMeshVisibility(bool bIs3rdPerson);

// Export UTurokPawnPlayer::execSetWeaponMeshVisibility(FFrame&, void* const)
native function SetWeaponMeshVisibility(bool bIs3rdPerson);

// Export UTurokPawnPlayer::execSetQuiverVisibility(FFrame&, void* const)
native function SetQuiverVisibility(bool bHideMesh, optional bool bCheckIfEmpty);

simulated event ReplicatedEvent(name N)
{
    // End:0x21
    if(N != 'mMiniGunSentryGraph')
    {
        super.ReplicatedEvent(N);        
    }
    else
    {
        // End:0xB4
        if(mMiniGunSentryGraph != none)
        {
            TurokNetLog("mMiniGunSentryGraph.mName=" $ string(mMiniGunSentryGraph.mName));
            // End:0x8A
            if(mMiniGunSentryGraph.mName == 'unequip')
            {
                GotoState('PickupMiniGunSentry');
            }
            // End:0xB4
            if(mMiniGunSentryGraph.mName == 'equip')
            {
                GotoState('DeployMiniGunSentry');
            }
        }
    }
    //return;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x29
    if(int(Role) == int(ROLE_Authority))
    {
        SetTimer(mHealthRegenTime, true, 'HealthRegen2');
    }
    //return;    
}

simulated event Destroyed()
{
    // End:0x10
    if(int(Role) == int(ROLE_Authority))
    {
    }
    super.Destroyed();
    //return;    
}

simulated event UnPossessed()
{
    // End:0x2C
    if(Controller.IsLocalPlayerController())
    {
        DetachComponent(mPovArms);
        DetachComponent(mPovLegsMesh);
    }
    super(TurokPawn).UnPossessed();
    //return;    
}

simulated function SimulatedPossessedBy(@NULL NewController)
{
    // DebugMode: 0
    assert(NewController != none);
    // DebugMode: 0
    assert((Controller == NewController) || Controller == none);
    // End:0x9D
    if(NewController.IsLocalPlayerController())
    {
        // End:0x6A
        if(Controller == none)
        {
            Controller = NewController;
            // DebugMode: 0
            assert(NewController.Pawn == self);
        }
        AttachComponent(mPovArms);
        mPovArms.mPovArmsMesh.SetLightEnvironment(LightEnvironment);
        AttachComponent(mPovLegsMesh);
    }
    //return;    
}

simulated event AttachWeaponAnimations(float blendTime)
{
    local @NULL Weap, TCam;

    // End:0x10B
    if(none != TurokPlayerController(Controller))
    {
        TCam = TurokPlayerCamera(TurokPlayerController(Controller).PlayerCamera);
        // End:0x10B
        if(none != TCam)
        {
            // End:0x10B
            if(((TCam.CameraStyle != 'FirstPerson') && TCam.CameraStyle != 'CameraAnimatedPov') && TCam.CameraStyle != 'Cinematic')
            {
                Weap = GetRightHandWeapon();
                // End:0xCD
                if(Weap != none)
                {
                    Weap.GetAttachment().ThirdPersonDoEquip();
                }
                Weap = GetLeftHandWeapon();
                // End:0x109
                if(Weap != none)
                {
                    Weap.GetAttachment().ThirdPersonDoEquip();
                }
                return;
            }
        }
    }
    //return;    
}

function SetMovementPhysics()
{
    local @NULL Turret;

    // End:0x68
    if(TurokPlayerController(Controller).mVehicleToDrive != none)
    {
        Turret = TurokVehicle(TurokPlayerController(Controller).mVehicleToDrive);
        // End:0x68
        if(Turret != none)
        {
            // End:0x68
            if(Turret.Seats[1].GetEnteringPawn() != none)
            {
                return;
            }
        }
    }
    super(Pawn).SetMovementPhysics();
    //return;    
}

protected simulated function UpdateGroggy(float Delta)
{
    // End:0x36
    if(TurokPlayerController(Controller) != none)
    {
        TurokPlayerController(Controller).mHitReactionManager.UpdateGroggy(Delta);
    }
    //return;    
}

simulated function Tick(float Delta)
{
    super.Tick(Delta);
    mCrouchWeight += (Delta * mCrouchRate);
    mCrouchWeight = FClamp(mCrouchWeight, 0.0000000, 1.0000000);
    UpdateGroggy(Delta);
    // End:0x5E
    if(none != mpPathActor)
    {
        FollowPath(Delta);
    }
    // End:0x74
    if(mbIsStealthKilling)
    {
        StartStealthKillSoundMode();        
    }
    else
    {
        EndStealthKillSoundMode();
    }
    //return;    
}

simulated event bool IsQuiverVisible()
{
    // End:0x0D
    if(mQuiverMesh == none)
    {
        return false;
    }
    // End:0x39
    if(!mQuiverMesh.HiddenGame || !mEmptyQuiverMesh.HiddenGame)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated event SetPOVMeshVisibility(bool bHideMesh)
{
    // End:0x97
    if(IsLocallyControlled())
    {
        // End:0x39
        if((GetRightHandWeapon()) != none)
        {
            GetRightHandWeapon().SetWeaponVisibility(!bHideMesh);
        }
        // End:0x69
        if((GetLeftHandWeapon()) != none)
        {
            GetLeftHandWeapon().SetWeaponVisibility(!bHideMesh);
        }
        mPovLegsMesh.SetHidden(bHideMesh);
        mPovArms.SetMeshHidden(bHideMesh);
    }
    //return;    
}

simulated function SetBaseEyeheight()
{
    // End:0x19
    if(!bIsCrouched)
    {
        BaseEyeHeight = default.BaseEyeHeight;        
    }
    else
    {
        BaseEyeHeight = mCrouchEyeHeight;
    }
    //return;    
}

simulated event StartCrouch(float HeightAdjust)
{
    super(TurokPawn).StartCrouch(HeightAdjust);
    mCrouchHeightAdjust = HeightAdjust;
    mCrouchRate = 1.0000000 / mCrouchDuration;
    //return;    
}

simulated event EndCrouch(float HeightAdjust)
{
    super(Pawn).EndCrouch(HeightAdjust);
    mCrouchHeightAdjust = HeightAdjust;
    mCrouchRate = -1.0000000 / mCrouchDuration;
    //return;    
}

function SetForcedKnockdownValues(@NULL attacker, float Distance)
{
    mbForcedKnockdown = true;
    mForcedKnockdownInstigator = attacker;
    mForcedKnockdownDistance = Distance;
    //return;    
}

// Export UTurokPawnPlayer::execGetMaxSpeedModifier(FFrame&, void* const)
native simulated function float GetMaxSpeedModifier();

simulated function bool WillEncroachGeometryIfUncrouched()
{
    local @NULL collisionExtents, HitLocation, HitNormal, StartTrace, EndTrace;

    local float HeightAdjust;

    collisionExtents.X = default.CylinderComponent.CollisionRadius;
    collisionExtents.Y = default.CylinderComponent.CollisionRadius;
    collisionExtents.Z = default.CylinderComponent.CollisionHeight;
    HeightAdjust = default.CylinderComponent.CollisionHeight - CylinderComponent.CollisionHeight;
    StartTrace = Location;
    StartTrace.Z += HeightAdjust;
    EndTrace = StartTrace;
    EndTrace.Z += 4.0000000;
    // End:0xE8
    if(Trace(HitLocation, HitNormal, EndTrace, StartTrace, false, collisionExtents) != none)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function bool CannotJumpNow()
{
    // End:0x18
    if(mLadderController.IsClimbing())
    {
        return true;
    }
    // End:0x32
    if(bIsCrouched && WillEncroachGeometryIfUncrouched())
    {
        return true;
    }
    return super(Pawn).CannotJumpNow();
    //return ReturnValue;    
}

simulated function bool DoJump(bool bUpdating)
{
    local float velMag, horzJumpBonus, vertJumpBonus;
    local int Index;
    local float jumpPenalty;

    // End:0x11
    if(bWantsToCrouch)
    {
        bWantsToCrouch = false;
    }
    // End:0x4F
    if(bIsCrouched)
    {
        // End:0x45
        if(TurokPlayerController(Controller) != none)
        {
            TurokPlayerController(Controller).ToggleCrouch();            
        }
        else
        {
            UnCrouch();
        }
    }
    // End:0x36A
    if(((int(Physics) == int(1)) || int(Physics) == int(9)) || int(Physics) == int(8))
    {
        // End:0xC5
        if(int(Role) == int(ROLE_Authority))
        {
            // End:0xC5
            if(bCountJumps && InvManager != none)
            {
                InvManager.OwnerEvent('Jumped');
            }
        }
        // End:0xEA
        if(int(Physics) == int(8))
        {
            Velocity = JumpZ * Floor;            
        }
        else
        {
            // End:0x112
            if(int(Physics) == int(9))
            {
                Velocity.Z = 0.0000000;                
            }
            else
            {
                // End:0x133
                if(bIsWalking)
                {
                    Velocity.Z = default.JumpZ;                    
                }
                else
                {
                    velMag = Sqrt(Velocity Dot Velocity);
                    // End:0x161
                    if(velMag > GroundSpeed)
                    {
                        velMag = GroundSpeed;
                    }
                    jumpPenalty = 1.0000000;
                    // End:0x240
                    if(Class'TurokUtil'.static.IsMultiplayerGame())
                    {
                        Index = mJumpTime.Length - 1;
                        J0x18D:

                        // End:0x1CC [Loop If]
                        if(Index >= 0)
                        {
                            // End:0x1C2
                            if(mJumpTime[Index] < WorldInfo.TimeSeconds)
                            {
                                mJumpTime.Remove(Index, 1);
                            }
                            Index--;
                            // [Loop Continue]
                            goto J0x18D;
                        }
                        // End:0x20E
                        if(mJumpTime.Length > 0)
                        {
                            jumpPenalty = 1.0000000 - (float(mJumpTime.Length) * mJumpPenalty);
                            // End:0x20E
                            if(jumpPenalty < mMaxJumpPenalty)
                            {
                                jumpPenalty = mMaxJumpPenalty;
                            }
                        }
                        mJumpTime.Insert(mJumpTime.Length, 1);
                        mJumpTime[mJumpTime.Length - 1] = WorldInfo.TimeSeconds + mJumpPenaltyValidTime;
                    }
                    horzJumpBonus = mHorizontalJumpModifier * (1.0000000 + ((mHorizontalSpeedJumpModifier * velMag) / GroundSpeed));
                    vertJumpBonus = mVerticalJumpModifier * (1.0000000 + ((mVerticalSpeedJumpModifier * velMag) / GroundSpeed));
                    Velocity.Z = (vertJumpBonus * JumpZ) * jumpPenalty;
                    Velocity.X *= (horzJumpBonus * jumpPenalty);
                    Velocity.Y *= (horzJumpBonus * jumpPenalty);
                }
            }
        }
        // End:0x359
        if(((Base != none) && !Base.bWorldGeometry) && Base.Velocity.Z > 0.0000000)
        {
            Velocity.Z += Base.Velocity.Z;
        }
        PlayJumpSound();
        SetPhysics(2);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function ApplyStun(float Damage, @NULL InstigatedBy)
{
    local float Stun;

    Stun = 1.0000000 - ((mStunMultiplier * Damage) / float(mDefaultHealth));
    Stun = FMax(Stun, mMaxStunMovementFactor);
    // End:0x96
    if((((Stun < mStunMovementFactor) && (GetRightHandWeapon()) != none) && int(GetRightHandWeapon().mWeaponType) == int(7)) && TurokAIControllerHelicopter(InstigatedBy) == none)
    {
        SetStunMovementFactor(Stun);
    }
    //return;    
}

event TakeDamage(int Damage, @NULL InstigatedBy, @NULL HitLocation, @NULL Momentum, class<Class> DamageType, optional @NULL HitInfo, optional @NULL DamageCauser)
{
    // End:0x31
    if(IsImmortal(DamageType))
    {
        // End:0x31
        if(Damage >= Health)
        {
            Damage = Health - 1;
        }
    }
    super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo);
    // End:0xA0
    if(mbForcedKnockdown)
    {
        // End:0xA0
        if((mForcedKnockdownInstigator == InstigatedBy.Pawn) || mForcedKnockdownInstigator == none)
        {
            mbForcedKnockdown = false;
            PlayKnockdown(InstigatedBy, HitLocation);
        }
    }
    //return;    
}

event PlayKnockdown(@NULL InstigatedBy, @NULL HitPosition)
{
    // End:0x47
    if(!mbForcedKnockdown)
    {
        // End:0x33
        if((Controller != none) && Controller.IsInState('ConstrainPlayerState'))
        {
            return;
        }
        // End:0x47
        if(mWeaponMediator.mbWeaponsLowered)
        {
            return;
        }
    }
    super.PlayKnockdown(InstigatedBy, HitPosition);
    //return;    
}

function AdjustDamage(out int inDamage, out @NULL Momentum, @NULL InstigatedBy, @NULL HitLocation, class<Class> DamageType, optional @NULL HitInfo)
{
    super(TurokPawn).AdjustDamage(inDamage, Momentum, InstigatedBy, HitLocation, DamageType, HitInfo);
    // End:0x54
    if(IsImmortal(DamageType))
    {
        // End:0x54
        if(inDamage >= Health)
        {
            inDamage = Health - 1;
        }
    }
    //return;    
}

function EnableRegenHealth(bool bEnable)
{
    mbEnableHealthRegen = bEnable;
    //return;    
}

function HealthRegen2()
{
    local int I;
    local float healthPercent, RegenHealth;

    // End:0x0D
    if(!mbEnableHealthRegen)
    {
        return;
    }
    // End:0xD9
    if(mDefaultHealth > Health)
    {
        healthPercent = (100.0000000 * float(Health)) / float(mDefaultHealth);
        I = 0;
        J0x40:

        // End:0xD9 [Loop If]
        if(I < 5)
        {
            // End:0xCF
            if((healthPercent >= float(mHealthRegenDefn[I].mRangePercentMin)) && healthPercent < float(mHealthRegenDefn[I].mRangePercentMax))
            {
                RegenHealth = (mHealthRegenDefn[I].mRegenPercent * float(mDefaultHealth)) / 100.0000000;
                HealAmount(int(RegenHealth));
                // [Explicit Break]
                goto J0xD9;
            }
            I++;
            // [Loop Continue]
            goto J0x40;
        }
    }
    J0xD9:

    //return;    
}

simulated function StartStealthKillSoundMode()
{
    local @NULL TPC;

    TPC = TurokPlayerController(Controller);
    // End:0x110
    if(TPC != none)
    {
        // End:0x37
        if(int(TPC.GetSoundMode()) == int(3))
        {
            return;
        }
        TPC.SetSoundGroupVoiceMode('SpeechGrunt', 0);
        TPC.SetSoundGroupVoiceMode('SpeechMG', 0);
        TPC.SetSoundGroupVoiceMode('SpeechWC', 0);
        TPC.SetSoundGroupVoiceMode('HumanFoley', 0);
        TPC.SetSoundGroupVoiceMode('impactshuman', 0);
        TPC.SetSoundGroupVoiceMode('impactsdino', 0);
        TPC.SetSoundGroupVoiceMode('WeaponHandling', 0);
        TPC.SetSoundGroupVoiceMode('WeaponFiringStereo', 0);
        TPC.SetSoundMode(3);
    }
    //return;    
}

simulated function EndStealthKillSoundMode()
{
    local @NULL TPC;

    TPC = TurokPlayerController(Controller);
    // End:0x10F
    if(TPC != none)
    {
        // End:0x37
        if(int(TPC.GetSoundMode()) != int(3))
        {
            return;
        }
        TPC.SetSoundGroupVoiceMode('SpeechGrunt', 1);
        TPC.SetSoundGroupVoiceMode('SpeechMG', 1);
        TPC.SetSoundGroupVoiceMode('SpeechWC', 1);
        TPC.SetSoundGroupVoiceMode('HumanFoley', 1);
        TPC.SetSoundGroupVoiceMode('impactshuman', 1);
        TPC.SetSoundGroupVoiceMode('impactsdino', 1);
        TPC.SetSoundGroupVoiceMode('WeaponHandling', 1);
        TPC.SetSoundGroupVoiceMode('WeaponFiringStereo', 1);
        TPC.SetSoundMode(0);
    }
    //return;    
}

simulated function PlayGrenadeAudioEffects()
{
    PlayAmbientSound(mDeafToneSndCue);
    SetTimer(mToneDeafDelay, false, 'PlayGrenadeAudioEffectsTimed');
    //return;    
}

simulated function PlayGrenadeAudioEffectsTimed()
{
    local @NULL ducker;

    ducker = TurokPlayerController(Controller).GetAudioDucker();
    // End:0x106
    if(ducker != none)
    {
        ducker.SetAudioDuckerItem('grenade', false, 0.0000000);
        ducker.AddDuckerCommand('grenade', 'SFX', 0.0000000);
        ducker.AddDuckerCommand('grenade', 'Ambient', 0.0000000);
        ducker.AddDuckerCommand('grenade', 'Music', 0.0000000);
        ducker.AddDuckerCommand('grenade', 'Speech', 0.0000000);
        ducker.ActivateAudioDuckerItem('grenade');
        SetTimer(mToneDeafFullTime, false, 'StopGrenadeAudioEffectsTimed');
    }
    //return;    
}

simulated function StopGrenadeAudioEffectsTimed()
{
    local @NULL ducker;

    ducker = TurokPlayerController(Controller).GetAudioDucker();
    // End:0x52
    if(ducker != none)
    {
        ducker.SetAudioDuckerItem('grenade', true, mDeafToneFadeTime);
        StopAmbientSound(mDeafToneFadeTime);
    }
    //return;    
}

event PlayDeathMomentSound()
{
    local @NULL ducker;

    StopAllPawnAmbientSounds(0.5000000);
    mSoundController.TryPlayLocalSound(mDeathMomentSndCue);
    ducker = TurokPlayerController(Controller).GetAudioDucker();
    // End:0x128
    if(ducker != none)
    {
        mbInDeathMoment = true;
        ducker.SetAudioDuckerItem('Death', false, 0.1000000);
        ducker.AddDuckerCommand('Death', 'SFX', 0.0000000);
        ducker.AddDuckerCommand('Death', 'Ambient', 0.0000000);
        ducker.AddDuckerCommand('Death', 'Music', 0.0000000);
        ducker.AddDuckerCommand('Death', 'Speech', 0.0000000);
        ducker.ActivateAudioDuckerItem('Death');        
    }
    //return;    
}

simulated function StopDeathMomentSound()
{
    local @NULL ducker;

    ducker = TurokPlayerController(Controller).GetAudioDucker();
    // End:0x43
    if(ducker != none)
    {
        ducker.SetAudioDuckerItem('Death', true, 0.1000000);
    }
    //return;    
}

simulated function PlayTakeDamageSound(float Damage, @NULL HitLocation, class<Class> DamageType)
{
    // End:0x34
    if(int(DamageType.default.mReactionType) == int(1))
    {
        mSoundController.TryPlayLocalSound(mSelfImpactSndCue);
    }
    super(TurokPawn).PlayTakeDamageSound(Damage, HitLocation, DamageType);
    //return;    
}

simulated function TakeRadiusDamage(@NULL InstigatedBy, float BaseDamage, float DamageRadius, class<Class> DamageType, float Momentum, @NULL HurtOrigin, bool bFullDamage, @NULL DamageCauser)
{
    super(TurokPawn).TakeRadiusDamage(InstigatedBy, BaseDamage, DamageRadius, DamageType, Momentum, HurtOrigin, bFullDamage, DamageCauser);
    // End:0x6D
    if(((DamageType == Class'TurokDamageTypeFragGrenade') && Controller != none) && Controller.IsLocalPlayerController())
    {
        PlayGrenadeAudioEffects();
    }
    //return;    
}

simulated event float GetFootStepNoiseMultiplier()
{
    // End:0x1F
    if(mWeaponAttachmentRightHand != none)
    {
        return mWeaponAttachmentRightHand.GetFootStepNoiseMultiplier();
    }
    return 1.0000000;
    //return ReturnValue;    
}

simulated function PlayGroggySound()
{
    // End:0x5C
    if(mGroggySndCue != none)
    {
        // End:0x3D
        if(mPawnIdleSndChannel == -1)
        {
            mPawnIdleSndChannel = mSoundController.CreateAudioChannel(mGroggySndCue, true, true);            
        }
        else
        {
            mSoundController.ChangeAudioChannel(mPawnIdleSndChannel, mGroggySndCue, true, true);
        }
    }
    mbGroggySoundIsPlaying = true;
    //return;    
}

simulated function StopGroggySound()
{
    // End:0x28
    if(mPawnIdleSndChannel != -1)
    {
        mSoundController.StopAudioChannel(mPawnIdleSndChannel);
    }
    mbGroggySoundIsPlaying = false;
    //return;    
}

function SpawnGrenade(class<Class> grenadeClass, optional @NULL localSpawnOffset, optional int pitchOffset = 0)
{
    local @NULL SpawnedProjectile, out_PlayerLoc, out_PlayerRot;

    GetActorEyesViewPoint(out_PlayerLoc, out_PlayerRot);
    // End:0x67
    if(((32768 - out_PlayerRot.Pitch) > 0) || out_PlayerRot.Pitch > 64000)
    {
        out_PlayerRot.Pitch += pitchOffset;
    }
    out_PlayerLoc += (localSpawnOffset >> out_PlayerRot);
    SpawnedProjectile = __NFUN_278__(grenadeClass, self,, out_PlayerLoc);
    // End:0xCE
    if((SpawnedProjectile != none) && !SpawnedProjectile.bDeleteMe)
    {
        SpawnedProjectile.Init(Vector(out_PlayerRot));
    }
    //return;    
}

function SetTurokAbilities()
{
    // End:0x1B
    if(GetIsStealth())
    {
        SoundDampening = mStealthSoundDampen;        
    }
    else
    {
        SoundDampening = mBaseSoundDampen;
    }
    //return;    
}

function OnCameraShake(@NULL ShakeWidget)
{
    local @NULL Shaker;

    Shaker = new (ShakeWidget.Outer) Class'TurokParametricShake';
    ShakeWidget.FillOutParametricShake(Shaker);
    Shaker.Init();
    Shaker.AddCameraModifier(PlayerController(Controller).PlayerCamera);
    //return;    
}

function OnShootPlayer(@NULL Widget)
{
    Widget.mShooter.ComputeAndSendDamage(self);
    //return;    
}

function OnPlayerImmortal(@NULL Action)
{
    // End:0x29
    if(Action.InputLinks[0].bHasImpulse)
    {
        mbPlayerImmortal = true;        
    }
    else
    {
        // End:0x4F
        if(Action.InputLinks[1].bHasImpulse)
        {
            mbPlayerImmortal = false;
        }
    }
    //return;    
}

function bool IsImmortal(class<Class> DamageType)
{
    local bool bImmortal;

    bImmortal = mbPlayerImmortal || DamageType == Class'TurokDamageTypeWaterBossBite';
    return bImmortal;
    //return ReturnValue;    
}

simulated function UpdatePlayerColor()
{
    //return;    
}

function ToggleFriendlyCheat()
{
    local @NULL P;

    // End:0x36
    if(mIsFriendlyMode == true)
    {
        ClientMessage("Friendly Cheat OFF");
        mIsFriendlyMode = false;        
    }
    else
    {
        ClientMessage("Friendly Cheat ON");
        mIsFriendlyMode = true;
        // End:0xA7
        foreach AllActors(Class'TurokPawn', P)
        {
            // End:0xA6
            if(P.mTargetingSystem.mCurrentTarget == self)
            {
                P.mTargetingSystem.ClearTarget();
            }            
        }        
    }
    //return;    
}

simulated function PreRender(@NULL Canvas)
{
    // End:0x16
    if(!mPovArms.bAttached)
    {
        return;
    }
    // End:0x7B
    if(mPovArms.mAttachedWeapon != none)
    {
        mPovArms.mAttachedWeapon.SetPosition(self);
        // End:0x78
        if(mPovArms.mAttachedWeaponLeft != none)
        {
            mPovArms.mAttachedWeaponLeft.SetPosition(self);
        }        
    }
    else
    {
        // End:0xA4
        if((GetRightHandWeapon()) != none)
        {
            GetRightHandWeapon().SetPosition(self);
        }
        // End:0xCD
        if((GetLeftHandWeapon()) != none)
        {
            GetLeftHandWeapon().SetPosition(self);
        }
    }
    mPovArms.UpdatePovTransform();
    // End:0x1A3
    if(mPovArms.mAttachedWeapon != none)
    {
        // End:0x140
        if(mPovArms.mAttachedWeapon.GetAttachment() != none)
        {
            mPovArms.mAttachedWeapon.GetAttachment().SpawnFirstPersonTracer();
        }
        // End:0x1A0
        if(mPovArms.mAttachedWeaponLeft != none)
        {
            // End:0x1A0
            if(mPovArms.mAttachedWeaponLeft.GetAttachment() != none)
            {
                mPovArms.mAttachedWeaponLeft.GetAttachment().SpawnFirstPersonTracer();
            }
        }        
    }
    else
    {
        // End:0x1F9
        if(((GetRightHandWeapon()) != none) && GetRightHandWeapon().GetAttachment() != none)
        {
            GetRightHandWeapon().GetAttachment().SpawnFirstPersonTracer();
        }
        // End:0x24F
        if(((GetLeftHandWeapon()) != none) && GetLeftHandWeapon().GetAttachment() != none)
        {
            GetLeftHandWeapon().GetAttachment().SpawnFirstPersonTracer();
        }
    }
    //return;    
}

// Export UTurokPawnPlayer::execCanHurt(FFrame&, void* const)
native function bool CanHurt(@NULL Other, optional class<Class> DamageType);

reliable server function ServerDeployMiniGunSentry(@NULL minigun, @NULL P, @NULL R)
{
    local float CylinderHeight;
    local @NULL mgr;

    mgr = TurokInventoryManager(InvManager);
    // End:0x1C5
    if(((((((Health > 0) && Base != none) && mgr != none) && mgr.PendingWeapon == none) && minigun != none) && (GetPrimaryWeapon()) == minigun) && !IsInState('PickupMiniGunSentry'))
    {
        StopFiring();
        // End:0xAF
        if(!Base.IsA('DynamicSMActor'))
        {
            mDeployerBase = none;            
        }
        else
        {
            TurokNetLog((("mDeployerBase=" $ string(Base)) @ "mDeployerBasePos=") $ string(Base.Location));
            mDeployerBasePos = Base.Location;
            mDeployerBase = Base;
        }
        CylinderHeight = Class'TurokPawnMiniGunAutoTurretNative'.default.CylinderComponent.default.CollisionHeight;
        mMiniGunSentrySpawnPos = P;
        mMiniGunSentrySpawnPos.Z += (CylinderHeight / float(2));
        mMiniGunSentrySpawnRot = R;
        minigun.mTurretLightState = 1;
        // DebugMode: 0
        assert(mMiniGunSentryGraph == none);
        mMiniGunSentryGraph = minigun.mChaingunTripodGraphSet.FindGraph('equip');
        // DebugMode: 0
        assert(mMiniGunSentryGraph != none);
        GotoState('DeployMiniGunSentry');
    }
    //return;    
}

state CinematicState
{    stop;    
}

state DefenderMaulAnimation
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        EnableRegenHealth(false);
        //return;        
    }

    simulated function EndState(name NextState)
    {
        super.EndState(NextState);
        EnableRegenHealth(true);
        //return;        
    }
    stop;    
}

state Dying
{
    simulated function BeginState(name PreviousStateName)
    {
        // End:0x20
        if(int(Role) == int(ROLE_Authority))
        {
            ClearTimer('HealthRegen2');
        }
        super.BeginState(PreviousStateName);
        //return;        
    }
    stop;    
}

state DeployMiniGunSentry extends CannedAnimation
{
    simulated function NotifyGraphEndToLoco(@NULL graph, @NULL asset, byte actorType)
    {
        // End:0x2A
        if(graph.mName == 'equip')
        {
            GotoState('None');
        }
        //return;        
    }

    simulated function BeginState(name prevState)
    {
        local @NULL lastWeapon, BestWeapon, mgr;

        mgr = TurokInventoryManager(InvManager);
        super.BeginState(prevState);
        mbEnableImpactAnims = false;
        SetWeaponsVisibleIn3rdPerson(false);
        // DebugMode: 0
        assert(mMiniGunSentryGraph != none);
        // End:0x11D
        if(mgr != none)
        {
            lastWeapon = Weapon(mgr.FindInventoryType(Class'TurokWeapChaingunNative', true));
            BestWeapon = mgr.TurokGetBestWeapon(lastWeapon);
            // End:0xF5
            if(((BestWeapon != none) && mgr.PendingWeapon != BestWeapon) && (GetPrimaryWeapon()) != BestWeapon)
            {
                SetWeaponsInstantSwitch(1, true);
                SetWeaponsInstantSwitch(0, true);
                mgr.TurokSimulatedSetCurrentWeapon(BestWeapon, false);
            }
            // DebugMode: 0
            assert(TurokPlayerController(Controller) != none);
            Controller.GotoState('CannedAnimation');
        }
        PlayGraphLocal(mMiniGunSentryGraph, self, 0);
        //return;        
    }

    simulated function EndState(name NextState)
    {
        local @NULL ctrl, sentry, mgr, gun;

        super.EndState(NextState);
        // End:0x23
        if(Health <= 0)
        {
            LocalAnimInterruptToLoco();            
        }
        else
        {
            // End:0x2BC
            if(int(Role) == int(ROLE_Authority))
            {
                mgr = TurokInventoryManager(InvManager);
                // DebugMode: 0
                assert(mgr != none);
                gun = TurokWeapChaingunNative(mgr.FindInventoryType(Class'TurokWeapChaingunNative', true));
                // End:0x2BC
                if(gun != none)
                {
                    // End:0xC8
                    if((mDeployerBase == none) || mDeployerBasePos == mDeployerBase.Location)
                    {
                        sentry = __NFUN_278__(gun.mMiniGunAutoTurretClass, none,, mMiniGunSentrySpawnPos, mMiniGunSentrySpawnRot,, true);
                    }
                    // End:0x264
                    if((sentry != none) && !sentry.IsInState('Dying'))
                    {
                        ctrl = __NFUN_278__(Class'TurokAIControllerMinigunAutoTurret', none,, mMiniGunSentrySpawnPos, mMiniGunSentrySpawnRot);
                        ctrl.Possess(sentry, false);
                        ctrl.SetTeamNum(int(GetTeamNum()));
                        sentry.mDeployCtrl = Controller;
                        sentry.mDeployedBy = self.PlayerReplicationInfo.PlayerID;
                        TurokInventoryManager(sentry.InvManager).CreateAmmoPool(gun.mAmmoPoolClass, -1, 0);
                        gun.mAmmoPoolPickupCount = mgr.GetAmmoPoolCount(gun.mAmmoPoolClass);
                        mgr.AdjustAmmoPool(gun.mAmmoPoolClass, -gun.mAmmoPoolCount);
                        mgr.DropFromInventoryForMinigunDeployment(gun);
                        sentry.InvManager.AddInventory(gun);
                        sentry.GotoState('Pickup');                        
                    }
                    else
                    {
                        // End:0x297
                        if(sentry != none)
                        {
                            gun.DropFrom(mMiniGunSentrySpawnPos, vect(0.0000000, 0.0000000, 9.0000000));                            
                        }
                        else
                        {
                            gun.DropFrom(Location, vect(0.0000000, 0.0000000, 9.0000000));
                        }
                    }
                }
            }
        }
        // End:0x2FA
        if((Controller != none) && Controller.IsInState('CannedAnimation'))
        {
            TurokPlayerController(Controller).EnterStartState();
        }
        SetWeaponsVisibleIn3rdPerson(true);
        // End:0x31C
        if(int(Role) == int(ROLE_Authority))
        {
            mMiniGunSentryGraph = none;
        }
        mbEnableImpactAnims = true;
        //return;        
    }
    stop;    
}

state PickupMiniGunSentry extends CannedAnimation
{
    simulated function NotifyGraphEndToLoco(@NULL graph, @NULL asset, byte actorType)
    {
        // End:0x2A
        if(graph.mName == 'unequip')
        {
            GotoState('None');
        }
        //return;        
    }

    simulated function BeginState(name prevState)
    {
        super.BeginState(prevState);
        // End:0x37
        if(TurokPlayerController(Controller) != none)
        {
            TurokPlayerController(Controller).GotoState('CannedAnimation');
        }
        mbEnableImpactAnims = false;
        SetWeaponsVisibleIn3rdPerson(false);
        // DebugMode: 0
        assert(mMiniGunSentryGraph != none);
        PlayGraphLocal(mMiniGunSentryGraph, self, 0);
        //return;        
    }

    simulated function EndState(name NextState)
    {
        super.EndState(NextState);
        // End:0x20
        if(Health <= 0)
        {
            LocalAnimInterruptToLoco();
        }
        // End:0x5E
        if((Controller != none) && Controller.IsInState('CannedAnimation'))
        {
            TurokPlayerController(Controller).EnterStartState();
        }
        SetWeaponsVisibleIn3rdPerson(true);
        // End:0x80
        if(int(Role) == int(ROLE_Authority))
        {
            mMiniGunSentryGraph = none;
        }
        mbEnableImpactAnims = true;
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: SkeletalMeshComponent'Default__TurokPawnPlayer.TurokLegsSkeletalMeshComponent'
    begin object name=TurokLegsSkeletalMeshComponent class=Class'Engine.SkeletalMeshComponent'
        bTransformFromAnimParent=0
        bUpdateAnimWhenNotRendered=false
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokPawnPlayer.MyLightEnvironment'
        Translation=(X=0.0000000,Y=0.0000000,Z=-48.0000000)
    end object
    mPovLegsMesh=TurokLegsSkeletalMeshComponent
    // Reference: TurokPovArms'Default__TurokPawnPlayer.PovArms'
    begin object name=PovArms class=Class'TurokPovArms'
    end object
    mPovArms=PovArms
    mWeapPOVRate=2.0000000
    mCrouchEyeHeight=8.0000000
    mCrouchDuration=0.1500000
    mEyeForwardAtLookingDown=22.0000000
    mStealthSoundDampen=1.0000000
    mBaseSoundDampen=1.0000000
    mHealthRegenTime=1.0000000
    mbEnableHealthRegen=true
    mCam_TimeTriggerManual=0.5000000
    mCam_TimeTriggerAuto=1.0000000
    mDeathCam_FOV=65.0000000
    mDeathCam_ManualOrbitRadius=100.0000000
    mDeathCam_ManualGroundOffsetZ=50.0000000
    mDeathCam_MaxKillerDistance=1500.0000000
    mDeathCam_PullBackDistance=50.0000000
    mDeathCam_TimeBlend=3.0000000
    mDriverCam_TimeBlend=1.0000000
    m1pCam_InterpSpeed=7.5000000
    mSelfImpactSndCue=SoundCue'SndWeapImpactHumanTurok.WeaponImpactTurok'
    mGroggySndCue=SoundCue'SndCreatureHuman.HumanGroggyBreathSndCue'
    mDeathMomentSndCue=SoundCue'SndDeath.DeathMomentASndCue'
    mDeafToneSndCue=SoundCue'SndGroggyState.DeafToneLoopCue'
    mDeafToneDuckerVolume=0.1000000
    mDeafToneFadeTime=5.0000000
    mToneDeafDelay=0.5000000
    mToneDeafFullTime=0.5000000
    mDyingMomentSndCue=SoundCue'SndCreatureHuman.CreatureHumanDeathMomentSFXSndCue'
    // Reference: TurokWeaponMediator'Default__TurokPawnPlayer.TurokWeaponMediatorComponent'
    begin object name=TurokWeaponMediatorComponent
    end object
    mWeaponMediator=TurokWeaponMediatorComponent
    // Reference: TurokMeleeMaulMeter'Default__TurokPawnPlayer.MeterComponent'
    begin object name=MeterComponent
    end object
    mMeleeMaulMeter=MeterComponent
    // Reference: TurokAnimKnockdownController'Default__TurokPawnPlayer.KnockdownComponent'
    begin object name=KnockdownComponent
    end object
    mKnockdownController=KnockdownComponent
    // Reference: SkeletalMeshComponent'Default__TurokPawnPlayer.TurokHeadSkeletalMeshComponent'
    begin object name=TurokHeadSkeletalMeshComponent
        ParentAnimComponent=SkeletalMeshComponent'Default__TurokPawnPlayer.TurokSkeletalMeshComponent'
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokPawnPlayer.MyLightEnvironment'
    end object
    mHeadMesh=TurokHeadSkeletalMeshComponent
    // Reference: TurokAISteer'Default__TurokPawnPlayer.TurokAISteerComponent'
    begin object name=TurokAISteerComponent
    end object
    mSteer=TurokAISteerComponent
    // Reference: TurokAIPlanner'Default__TurokPawnPlayer.TurokAIPlannerComponent'
    begin object name=TurokAIPlannerComponent
    end object
    mPlanner=TurokAIPlannerComponent
    // Reference: DynamicLightEnvironmentComponent'Default__TurokPawnPlayer.MyLightEnvironment'
    begin object name=MyLightEnvironment
    end object
    LightEnvironment=MyLightEnvironment
    mDesiredMoveMode=2
    // Reference: TurokPathController'Default__TurokPawnPlayer.TurokPathControllerComponent'
    begin object name=TurokPathControllerComponent
    end object
    mPathController=TurokPathControllerComponent
    // Reference: TurokTargetingSystem'Default__TurokPawnPlayer.TurokTargetingSystemComponent'
    begin object name=TurokTargetingSystemComponent
        mbConsiderHumans=false
        mbConsiderMendelGruman=true
        mbConsiderPlants=true
        mbConsiderSame=true
        mbConsiderVehicles=false
        mbConsiderMGVehicles=true
        mbConsiderPlayer=true
        mTargetType=2
        mTargetGroup=2
    end object
    mTargetingSystem=TurokTargetingSystemComponent
    mBaseAirSpeed=600.0000000
    mBaseAccelRate=512.0000000
    // Reference: TurokSoundController'Default__TurokPawnPlayer.TurokSoundControllerComponent'
    begin object name=TurokSoundControllerComponent
    end object
    mSoundController=TurokSoundControllerComponent
    mFoleySounds=/* Array type was not detected. */
    mTakeDamageSndCue=SoundCue'SndCreatureHuman.CreatureHumanTakeDamageSndCue'
    mGearSndCue=SoundCue'SndCreatureHumanFeetGear.SndCreatureHumanFeetGear'
    mSpawnSoundEnableDelay=0.5000000
    mFootStepEffects=/* Array type was not detected. */
    mVerticalJumpModifier=1.2000000
    // Reference: TurokAnimLadderController'Default__TurokPawnPlayer.ladderController'
    begin object name=ladderController
    end object
    mLadderController=ladderController
    mExtentBones=/* Array type was not detected. */
    bCanCrouch=true
    bJumpCapable=true
    bCanPickupInventory=true
    CrouchHeight=30.0000000
    CrouchRadius=22.0000000
    PeripheralVision=0.6500000
    GroundSpeed=300.0000000
    AirSpeed=600.0000000
    AccelRate=512.0000000
    AirControl=1.0000000
    BaseEyeHeight=36.0000000
    EyeHeight=36.0000000
    SoundDampening=0.0000000
    // Reference: SkeletalMeshComponent'Default__TurokPawnPlayer.TurokSkeletalMeshComponent'
    begin object name=TurokSkeletalMeshComponent
        LightEnvironment=DynamicLightEnvironmentComponent'Default__TurokPawnPlayer.MyLightEnvironment'
    end object
    Mesh=TurokSkeletalMeshComponent
    // Reference: CylinderComponent'Default__TurokPawnPlayer.CollisionCylinder'
    begin object name=CollisionCylinder
        CollisionHeight=48.0000000
        CollisionRadius=22.0000000
    end object
    CylinderComponent=CollisionCylinder
    AlwaysRelevantDistanceSquared=2560000.0000000
    ViewPitchMin=-13654.0000000
    ViewPitchMax=13654.0000000
    Components[0]=CollisionCylinder
    // Reference: ArrowComponent'Default__TurokPawnPlayer.Arrow'
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
    Components[11]=TurokHeadSkeletalMeshComponent
    Components[12]=MeterComponent
    Components[13]=KnockdownComponent
    CollisionComponent=CollisionCylinder
}