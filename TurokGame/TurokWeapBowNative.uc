class TurokWeapBowNative extends TurokWeapon
    native
    config(WeapBow)
    hidecategories(Navigation);

enum ETurokBowShotType
{
    ETBST_NoShot,                   // 0
    ETBST_RegularTension,           // 1
    ETBST_PowerShot,                // 2
    ETBST_MAX                       // 3
};

enum ETurokBowAnimType
{
    ETBAT_NoArrows,                 // 0
    ETBAT_RegularArrows,            // 1
    ETBAT_ExplosiveArrows,          // 2
    ETBAT_MAX                       // 3
};

var float mTension;
var float mTensionAtRelease;
var int mTicksAtMaxTension;
var int mTensionTicks;
var float mVirtualAnalogTrigger;
var float mPrevVirtualAnalogTrigger;
var byte mShootArrow;
var bool mbAutoTension;
var bool mbAutoDetension;
var bool mbPreventTensionRelease;
var bool mbPreventTensionAdding;
var bool mbPlayingMaxTensionAnim;
var bool mbTooTense;
var bool mbSwitchingArrowType;
var bool mbOkToAutoTension;
var bool mbForceSwitchArrowType;
var bool mbOkToShake;
var bool mbFinishDetensioning;
var bool mbReleasedWithinFireWindow;
var bool mbPlayingOutOfAmmoIdle;
var(Bowdamage) bool mbAlwaysHitAimAssistTarget;
var bool mbTensionAnimInited;
var float mAutoTensionDirection;
var float mVibrationAmount;
var int mMinTensionTicksToFire;
var float mMaxTensionShakePct;
var float mDetensionTime;
var const float FORCEFIRETENSION;
var const float MINTENSIONTOFIRE;
var const float MINALLOWABLETENSION;
var(Animations) @NULL mLowTensionFireAnim;
var(Animations) @NULL mHighTensionFireAnim;
var(Animations) @NULL mTensioningAnim;
var(Animations) @NULL mIdleTensionedAnim;
var(Animations) @NULL mNoAmmoIdle;
var(Animations) @NULL mLowTensionFireLastShotAnim;
var(Animations) @NULL mHighTensionFireLastShotAnim;
var(Animations) @NULL mLowTensionFireLastShotAnimAlt;
var(Animations) @NULL mHighTensionFireLastShotAnimAlt;
var(Animations) @NULL mLowTensionFireAnimAlt;
var(Animations) @NULL mHighTensionFireAnimAlt;
var(Animations) @NULL mTensioningAnimAlt;
var(Animations) @NULL mIdleTensionedAnimAlt;
var(Animations) @NULL mPutDownAnimAlt;
var(Animations) @NULL mEquipAnimAlt;
var(Animatiosn) @NULL mGrenadeAnimAlt;
var(Animations) @NULL mAmbientIdleAnimAlt;
var(Animations) @NULL mEquipWithNoArrows;
var(Animations) @NULL mPutDownWithNoArrows;
var(Animations) @NULL mGrenadeWithNoArrows;
var(BowTension) config float mTensionSwayMinVertTrans;
var(BowTension) config float mTensionSwayMaxVertTrans;
var(BowTension) config float mTensionSwayMinHorizTrans;
var(BowTension) config float mTensionSwayMaxHorizTrans;
var(BowTension) config float mTensionSwayVertFrequency;
var(BowTension) config float mTensionSwayVertOffset;
var(BowTension) config float mTensionSwayHorizFrequency;
var(BowTension) config float mTensionSwayHorizOffset;
var(BowTension) config float mTimeWindowForShot;
var(BowTension) config float mAutoTensionInc;
var(BowTension) config float mAutoDetensionInc;
var(BowTension) config float mLoweringBowSensitivity;
var(BowTension) config int mMaxTensionTicksForceShot;
var(BowTension) config float mDelayTimeBeforeMaxTensionShaking;
var(ArrowRange) config float mMaxDistance;
var(ArrowRange) config float mFullTensionMaxDistance;
var(ArrowRange) config float mMinDistance;
var config float mTensionedIdleTime;
var config int mMinArrowSpeed;
var(Bowdamage) config int mMinDamage;
var(Bowdamage) config int mMaxTensionDamage;
var(Bowdamage) config int mMaxTensionDamageMP;
var(Bowdamage) config float mArmourPenaltyForArrowStickGRUNT;
var(Bowdamage) config float mArmourPenaltyForArrowStickVETERAN;
var(Bowdamage) config float mArmourPenaltyForArrowStickSNIPER;
var(Bowdamage) config float mArmourPenaltyForArrowStickHEAVYWEAPONS;
var(Bowdamage) config float mArmourPenaltyForArrowStickELITE;
var(Bowdamage) config float mArmourPenaltyForArrowStickRPGTROOPER;
var(Bowdamage) config float mChestStickPctMod;
var(Bowdamage) config float mPctChanceChestStick;
var(Bowdamage) config float mMinHealthPct;
var(Bowdamage) config float mOkToTeleportArrowDistance;
var config float mMinArrowImpactMomentum;
var(BowTension) config float mFullTensionSpeedBonus;
var(BowTension) config float mFullTensionSpeedBonusMP;
var(Sound) @NULL mBowIncreaseTensionSndCue;
var(Sound) @NULL mBowDecreaseTensionSndCue;
var(Sound) @NULL mBowMaxTensionSndCue;
var(Sound) float mTensionSndThreshold;
var(Sound) float mLastTensionPlayed;
var(Sound) float mLastTensionDirection;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    WeaponRange = mMinDistance;
    // End:0x3B
    if(Class'TurokUtil'.static.IsMultiplayerGame())
    {
        mInventoryType = 1;
        bCanThrow = true;
        bDropOnDeath = true;
    }
    //return;    
}

simulated function Tick(float DeltaTime)
{
    super(Actor).Tick(DeltaTime);
    // End:0x26
    if(mDetensionTime >= 0.0000000)
    {
        mDetensionTime += DeltaTime;
    }
    //return;    
}

simulated function DetachWeapon()
{
    super.DetachWeapon();
    //return;    
}

simulated function RemoveExplodingArrows()
{
    mAltAmmoPoolCount = 0;
    //return;    
}

// Export UTurokWeapBowNative::execGetCurrentClipAmmo(FFrame&, void* const)
native function int GetCurrentClipAmmo();

// Export UTurokWeapBowNative::execGetCurrentClipAltAmmo(FFrame&, void* const)
native function int GetCurrentClipAltAmmo();

simulated function NotifyAmmoAdded()
{
    // End:0x4C
    if(mbPlayingOutOfAmmoIdle)
    {
        PlayPOVAnimation(mPutDownWithNoArrows, PutDownTime, 0.1000000, 0.1000000, false, false);
        mbPlayingOutOfAmmoIdle = false;
        SetTimer(PutDownTime, false, 'WaitForPutDownAnimTimer');
        mbSwitchingArrowType = true;
    }
    //return;    
}

// Export UTurokWeapBowNative::execHasAmmo(FFrame&, void* const)
native function bool HasAmmo(byte FireModeNum, optional int Amount);

simulated function ReloadWeapon()
{
    // End:0x5B
    if(mTensionTicks > 0)
    {
        mbFinishDetensioning = false;
        mTensionAtRelease = 0.0000000;
        mTension = 0.0000000;
        UpdateBowTensionTimer();
        EndFire(0);
        // End:0x5B
        if(int(Role) < int(ROLE_Authority))
        {
            ServerStopFire(ROLE_None);
        }
    }
    //return;    
}

simulated function TensionTimer()
{
    local @NULL tpp, pInput;
    local float physicalAnalogTrigger;
    local byte FireMode;
    local bool bStartMaxIdle;

    FireMode = GetFiringMode();
    bStartMaxIdle = false;
    tpp = TurokPawnPlayer(Instigator);
    // End:0x73
    if((tpp != none) && tpp.Controller != none)
    {
        pInput = TurokPlayerInput(TurokPlayerController(tpp.Controller).PlayerInput);        
    }
    else
    {
        pInput = none;
    }
    // End:0xF5
    if((pInput != none) && mbTensionAnimInited)
    {
        physicalAnalogTrigger = pInput.mAnalogInputData.rightShoulderButton * 255.0000000;
        physicalAnalogTrigger += (pInput.mAnalogInputData.rightShoulderButtonAsMouse * 255.0000000);
        // End:0xF5
        if(physicalAnalogTrigger > 255.0000000)
        {
            physicalAnalogTrigger = 255.0000000;
        }
    }
    // End:0x170
    if((mbFinishDetensioning && physicalAnalogTrigger == 0.0000000) && mVirtualAnalogTrigger == 0.0000000)
    {
        mbFinishDetensioning = false;
        mTensionAtRelease = 0.0000000;
        mTension = 0.0000000;
        UpdateBowTensionTimer();
        EndFire(0);
        // End:0x170
        if(int(Role) < int(ROLE_Authority))
        {
            ServerStopFire(ROLE_None);
        }
    }
    // End:0x2A5
    if((physicalAnalogTrigger > 0.0000000) && mbOkToAutoTension)
    {
        mTensionTicks++;
        // End:0x1B2
        if((mVirtualAnalogTrigger == 255.0000000) && mbOkToShake)
        {
            mTicksAtMaxTension++;
        }
        // End:0x2A5
        if(mbPlayingMaxTensionAnim)
        {
            mMaxTensionShakePct = float(mTicksAtMaxTension) / float(mMaxTensionTicksForceShot);
            // End:0x1EB
            if(mMaxTensionShakePct > 1.0000000)
            {
                mMaxTensionShakePct = 1.0000000;
            }
            // End:0x213
            if(!IsTimerActive('PreShakingTimer'))
            {
                SetTimer(mDelayTimeBeforeMaxTensionShaking, false, 'PreShakingTimer');
            }
            // End:0x2A5
            if(mTicksAtMaxTension > mMaxTensionTicksForceShot)
            {
                mShootArrow = 1;
                mTensionAtRelease = FORCEFIRETENSION;
                mTensionTicks = 0;
                mTicksAtMaxTension = 0;
                mbReleasedWithinFireWindow = true;
                StopFire(0);
                mbAutoTension = false;
                // End:0x282
                if(IsTimerActive('AutoTensionTimer'))
                {
                    ClearTimer('AutoTensionTimer');
                }
                // End:0x2A5
                if(IsTimerActive('PreShakingTimer'))
                {
                    ClearTimer('PreShakingTimer');
                }
            }
        }
    }
    // End:0x72C
    if(int(mShootArrow) == int(0))
    {
        // End:0x6C4
        if(!mbAutoDetension)
        {
            // End:0x345
            if(!mbAutoTension)
            {
                // End:0x342
                if(((mbOkToAutoTension && physicalAnalogTrigger > 0.0000000) && physicalAnalogTrigger > mVirtualAnalogTrigger) && mVirtualAnalogTrigger >= mPrevVirtualAnalogTrigger)
                {
                    mbAutoTension = true;
                    mAutoTensionDirection = 1.0000000;
                    // End:0x342
                    if(!IsTimerActive('AutoTensionTimer'))
                    {
                        SetTimer(0.0100000, true, 'AutoTensionTimer');
                    }
                }                
            }
            else
            {
                // End:0x37F
                if(physicalAnalogTrigger < mVirtualAnalogTrigger)
                {
                    mbAutoTension = false;
                    // End:0x37F
                    if(IsTimerActive('AutoTensionTimer'))
                    {
                        ClearTimer('AutoTensionTimer');
                    }
                }
                // End:0x3BC
                if(((mVirtualAnalogTrigger == 255.0000000) && physicalAnalogTrigger == 255.0000000) && !mbPlayingMaxTensionAnim)
                {
                    bStartMaxIdle = true;
                    mbPlayingMaxTensionAnim = true;
                }
            }
            // End:0x4B1
            if(mbReleasedWithinFireWindow)
            {
                mShootArrow = 1;
                // End:0x3E7
                if(mTensionAtRelease < MINALLOWABLETENSION)
                {
                    mTensionAtRelease = MINALLOWABLETENSION;
                }
                // End:0x3FE
                if(mTensionAtRelease == 1.0000000)
                {
                    mShootArrow = 2;
                }
                mTension = mTensionAtRelease;
                UpdateBowTensionTimer();
                mTensionTicks = 0;
                mTicksAtMaxTension = 0;
                mbOkToShake = false;
                mbAutoDetension = false;
                // End:0x454
                if(IsTimerActive('AutoTensionTimer'))
                {
                    ClearTimer('AutoTensionTimer');
                }
                // End:0x477
                if(IsTimerActive('PreShakingTimer'))
                {
                    ClearTimer('PreShakingTimer');
                }
                // End:0x49A
                if(IsTimerActive('UpdateBowTensionTimer'))
                {
                    ClearTimer('UpdateBowTensionTimer');
                }
                StopFire(0);
                mDetensionTime = -1.0000000;
            }
            // End:0x670
            if((((int(mShootArrow) == int(0)) && !mbAutoDetension) && physicalAnalogTrigger < (mVirtualAnalogTrigger - 25.0000000)) && mTension > 0.0000000)
            {
                // End:0x52B
                if(mbAutoTension)
                {
                    mbAutoTension = false;
                    // End:0x52B
                    if(IsTimerActive('AutoTensionTimer'))
                    {
                        ClearTimer('AutoTensionTimer');
                    }
                }
                // End:0x56A
                if(mDetensionTime < 0.0000000)
                {
                    mDetensionTime = 0.0000000;
                    mTensionAtRelease = mTension;
                    // End:0x56A
                    if(mTensionAtRelease < MINALLOWABLETENSION)
                    {
                        mTensionAtRelease = MINALLOWABLETENSION;
                    }
                }
                // End:0x670
                if(int(mShootArrow) == int(0))
                {
                    // End:0x670
                    if(mDetensionTime >= mTimeWindowForShot)
                    {
                        mDetensionTime = -1.0000000;
                        // End:0x5FB
                        if(mbPlayingMaxTensionAnim)
                        {
                            InitPOVAnimForScrubbing(((int(FireMode) == 0) ? mTensioningAnim : mTensioningAnimAlt), 0.1000000, 0.0000000);
                            ScrubPOVAnim(((int(FireMode) == 0) ? mTensioningAnim : mTensioningAnimAlt), mTension, false);
                            mbPlayingMaxTensionAnim = false;
                        }
                        mbAutoDetension = true;
                        mTicksAtMaxTension = 0;
                        mbOkToAutoTension = false;
                        mAutoTensionDirection = -1.0000000;
                        // End:0x645
                        if(!IsTimerActive('AutoTensionTimer'))
                        {
                            SetTimer(0.0100000, true, 'AutoTensionTimer');
                        }
                        // End:0x668
                        if(IsTimerActive('PreShakingTimer'))
                        {
                            ClearTimer('PreShakingTimer');
                        }
                        mbOkToShake = false;
                    }
                }
            }
            // End:0x6C1
            if((int(mShootArrow) == int(0)) && bStartMaxIdle)
            {
                PlayPOVCannedAnimation(((int(FireMode) == 0) ? mIdleTensionedAnim : mIdleTensionedAnimAlt), mTensionedIdleTime, 0.1000000, true);
                mbPlayingOutOfAmmoIdle = false;
            }            
        }
        else
        {
            // End:0x715
            if(mVirtualAnalogTrigger == 0.0000000)
            {
                mbAutoDetension = false;
                mTensionTicks = 0;
                mDetensionTime = -1.0000000;
                mbReleasedWithinFireWindow = false;
                mTensionAtRelease = 0.0000000;
                mTension = 0.0000000;
                UpdateBowTensionTimer();
            }
        }
        // End:0x72C
        if(mVirtualAnalogTrigger == 0.0000000)
        {
            mbOkToAutoTension = true;
        }
    }
    // End:0x782
    if((PendingFire(0)) && int(mShootArrow) == int(0))
    {
        mTension = (1.0000000 / 255.0000000) * mVirtualAnalogTrigger;
        // End:0x77F
        if(mTension > 1.0000000)
        {
            mTension = 1.0000000;
        }        
    }
    else
    {
        // End:0x7B8
        if((int(mShootArrow) != int(0)) && mTensionAtRelease != 0.0000000)
        {
            mTension = mTensionAtRelease;
            UpdateBowTensionTimer();
        }
    }
    // End:0x7CE
    if(physicalAnalogTrigger == 0.0000000)
    {
        mTensionTicks = 0;
    }
    mPrevVirtualAnalogTrigger = mVirtualAnalogTrigger;
    //return;    
}

simulated function PreShakingTimer()
{
    mbOkToShake = true;
    //return;    
}

simulated function UpdateBowTensionTimer()
{
    // End:0x28
    if(int(Role) < int(ROLE_Authority))
    {
        ServerSetBowTension(byte(mTension * 255.0000000));
    }
    // End:0x64
    if((Instigator != none) && Instigator.IsLocallyControlled())
    {
        TurokPawnHuman(Instigator).SetAttachmentBowTension(mTension);
    }
    //return;    
}

reliable server function ServerSetBowTension(byte Tension)
{
    TurokPawnHuman(Instigator).SetAttachmentBowTension(float(Tension) / 255.0000000);
    //return;    
}

simulated function AutoTensionTimer()
{
    local float tensionInc;

    tensionInc = (256.0000000 - mVirtualAnalogTrigger) / 60.0000000;
    // End:0x43
    if(mAutoTensionDirection > float(0))
    {
        // End:0x40
        if(tensionInc < mAutoTensionInc)
        {
            tensionInc = mAutoTensionInc;
        }        
    }
    else
    {
        // End:0x5D
        if(tensionInc < mAutoDetensionInc)
        {
            tensionInc = mAutoDetensionInc;
        }
    }
    tensionInc *= mAutoTensionDirection;
    mVirtualAnalogTrigger += tensionInc;
    // End:0x92
    if(mVirtualAnalogTrigger > 255.0000000)
    {
        mVirtualAnalogTrigger = 255.0000000;        
    }
    else
    {
        // End:0xBC
        if(mVirtualAnalogTrigger <= 0.0000000)
        {
            mVirtualAnalogTrigger = 0.0000000;
            ClearTimer('AutoTensionTimer');
        }
    }
    //return;    
}

// Export UTurokWeapBowNative::execPlayFireEffects(FFrame&, void* const)
native function PlayFireEffects(byte FireModeNum, optional @NULL HitLocation);

// Export UTurokWeapBowNative::execSetPendingFire(FFrame&, void* const)
native function SetPendingFire(int FireMode);

simulated event CalcWeaponSwayOffset(out @NULL drawOffset, @NULL Y, @NULL Z)
{
    local @NULL newViewOffset;
    local float swayPct, normalizedSpeed, horizSin, vertSin, wtime;

    local @NULL ownerPawn;

    ownerPawn = Pawn(Owner);
    newViewOffset = vect(0.0000000, 0.0000000, 0.0000000);
    // End:0x210
    if((ownerPawn != none) && int(ownerPawn.Physics) != int(2))
    {
        normalizedSpeed = VSize2D(ownerPawn.Velocity) / FMax(ownerPawn.default.GroundSpeed, 0.0010000);
        // End:0xD3
        if(((mTensionTicks == 0) || mbAutoDetension) || ((mTensionTicks > 0) && !mbPlayingMaxTensionAnim) && normalizedSpeed > 0.0000000)
        {
            super.CalcWeaponSwayOffset(drawOffset, Y, Z);            
        }
        else
        {
            swayPct = 0.0500000;
            // End:0x104
            if((mTensionTicks > 0) && !mbPlayingMaxTensionAnim)
            {
                swayPct = 0.0500000;                
            }
            else
            {
                // End:0x118
                if(mbPlayingMaxTensionAnim)
                {
                    swayPct = mMaxTensionShakePct;
                }
            }
            wtime = GetWeaponActivationTimeStamp();
            horizSin = Sin(((mTensionSwayHorizOffset * 360.0000000) + (wtime / (mTensionSwayHorizFrequency / 3.6000000))) + 1.0000000);
            vertSin = Sin(((mTensionSwayVertOffset * 360.0000000) + (wtime / (mTensionSwayVertFrequency / 3.6000000))) + 1.0000000);
            newViewOffset += ((Y * swayPct) * (mTensionSwayMinHorizTrans + (horizSin * (mTensionSwayMaxHorizTrans - mTensionSwayMinHorizTrans))));
            newViewOffset += ((Z * swayPct) * (mTensionSwayMinVertTrans + (vertSin * (mTensionSwayMaxVertTrans - mTensionSwayMinVertTrans))));
            mLastSwayViewOffset = VLerp(mLastSwayViewOffset, newViewOffset, 0.5000000);
            drawOffset += mLastSwayViewOffset;
        }        
    }
    else
    {
        super.CalcWeaponSwayOffset(drawOffset, Y, Z);
    }
    //return;    
}

simulated function float GetTraceRange()
{
    return WeaponRange;
    //return ReturnValue;    
}

simulated function CalcArrowHitReaction(out @NULL tArrow, @NULL HitActor, @NULL HitInfo, float BowTension, @NULL AimDir)
{
    local @NULL targetedHuman, targetedBug, targetedDino, tPawn;
    local bool bHeadShot, bKillingShot;
    local float humanArmourPenalty, healthPct, reactionChance;
    local byte bodyPart;
    local float scaleDamage;

    // End:0x0D
    if(tArrow == none)
    {
        return;
    }
    targetedHuman = none;
    targetedDino = none;
    targetedBug = none;
    tPawn = none;
    bodyPart = 9;
    // End:0x51
    if(TurokPawn(HitActor) != none)
    {
        tPawn = TurokPawn(HitActor);
    }
    // End:0x74
    if(TurokPawnHuman(HitActor) != none)
    {
        targetedHuman = TurokPawnHuman(HitActor);        
    }
    else
    {
        // End:0x97
        if(TurokPawnDino(HitActor) != none)
        {
            targetedDino = TurokPawnDino(HitActor);            
        }
        else
        {
            // End:0xB7
            if(TurokPawnBug(HitActor) != none)
            {
                targetedBug = TurokPawnBug(HitActor);
            }
        }
    }
    // End:0xE3
    if(targetedHuman != none)
    {
        bodyPart = targetedHuman.GetHitBodyPart(HitInfo);        
    }
    else
    {
        // End:0x10C
        if(targetedBug != none)
        {
            bodyPart = targetedBug.GetHitBodyPart(HitInfo);
        }
    }
    bHeadShot = false;
    // End:0x12C
    if(int(bodyPart) == int(1))
    {
        bHeadShot = true;
    }
    bKillingShot = false;
    scaleDamage = tPawn.GetDamageScale(HitInfo, tArrow.MyDamageType);
    // End:0x197
    if((float(tPawn.Health) - (tArrow.Damage * scaleDamage)) <= float(0))
    {
        bKillingShot = true;
    }
    humanArmourPenalty = 1.0000000;
    healthPct = float(tPawn.Health) / float(tPawn.mDefaultHealth);
    // End:0x57B
    if(targetedHuman != none)
    {
        // End:0x53E
        if((healthPct <= mMinHealthPct) || BowTension == 1.0000000)
        {
            // End:0x223
            if(bKillingShot && bHeadShot)
            {
                tArrow.SetArrowDamageType(3);
                return;                
            }
            else
            {
                // End:0x264
                if(((BowTension == 1.0000000) && !bKillingShot) && bHeadShot)
                {
                    tArrow.SetArrowDamageType(0);
                    return;                    
                }
                else
                {
                    // End:0x2A5
                    if((!bKillingShot && bHeadShot) && BowTension < 1.0000000)
                    {
                        tArrow.SetArrowDamageType(0);
                        return;                        
                    }
                    else
                    {
                        // End:0x51B
                        if(!bKillingShot && !bHeadShot)
                        {
                            // End:0x501
                            if(VSize(Instigator.Location - tPawn.Location) > mOkToTeleportArrowDistance)
                            {
                                // End:0x329
                                if((int(targetedHuman.mHumanType) == int(5)) || int(targetedHuman.mHumanType) == int(6))
                                {
                                    humanArmourPenalty = mArmourPenaltyForArrowStickGRUNT;                                    
                                }
                                else
                                {
                                    // End:0x36B
                                    if((int(targetedHuman.mHumanType) == int(14)) || int(targetedHuman.mHumanType) == int(15))
                                    {
                                        humanArmourPenalty = mArmourPenaltyForArrowStickVETERAN;                                        
                                    }
                                    else
                                    {
                                        // End:0x392
                                        if(int(targetedHuman.mHumanType) == int(12))
                                        {
                                            humanArmourPenalty = mArmourPenaltyForArrowStickSNIPER;                                            
                                        }
                                        else
                                        {
                                            // End:0x3B9
                                            if(int(targetedHuman.mHumanType) == int(8))
                                            {
                                                humanArmourPenalty = mArmourPenaltyForArrowStickHEAVYWEAPONS;                                                
                                            }
                                            else
                                            {
                                                // End:0x3E0
                                                if(int(targetedHuman.mHumanType) == int(3))
                                                {
                                                    humanArmourPenalty = mArmourPenaltyForArrowStickELITE;                                                    
                                                }
                                                else
                                                {
                                                    // End:0x404
                                                    if(int(targetedHuman.mHumanType) == int(11))
                                                    {
                                                        humanArmourPenalty = mArmourPenaltyForArrowStickRPGTROOPER;
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                reactionChance = ((BowTension * 0.3300000) + (humanArmourPenalty * 0.3300000)) + (healthPct * 0.3300000);
                                // End:0x4E7
                                if((reactionChance * mChestStickPctMod) > mPctChanceChestStick)
                                {
                                    switch(bodyPart)
                                    {
                                        // End:0x454
                                        case 2:
                                        // End:0x471
                                        case 3:
                                            tArrow.SetArrowDamageType(2);
                                            // End:0x4E2
                                            break;
                                        // End:0x4C7
                                        case 0:
                                            // End:0x4AF
                                            if((AimDir Dot Vector(targetedHuman.Rotation)) < 0.0000000)
                                            {
                                                tArrow.SetArrowDamageType(1);                                                
                                            }
                                            else
                                            {
                                                tArrow.SetArrowDamageType(0);
                                            }
                                            // End:0x4E2
                                            break;
                                        // End:0xFFFF
                                        default:
                                            tArrow.SetArrowDamageType(0);
                                            // End:0x4E2
                                            break;
                                            break;
                                    }
                                    return;                                    
                                }
                                else
                                {
                                    tArrow.SetArrowDamageType(0);
                                    return;
                                }                                
                            }
                            else
                            {
                                tArrow.SetArrowDamageType(0);
                                return;
                            }                            
                        }
                        else
                        {
                            // End:0x53B
                            if(bKillingShot)
                            {
                                tArrow.SetArrowDamageType(3);
                                return;
                            }
                        }
                    }
                }
            }            
        }
        else
        {
            // End:0x561
            if(bKillingShot)
            {
                tArrow.SetArrowDamageType(3);
                return;                
            }
            else
            {
                tArrow.SetArrowDamageType(0);
                return;
            }
        }        
    }
    else
    {
        // End:0x5A0
        if(targetedDino != none)
        {
            tArrow.SetArrowDamageType(3);
            return;            
        }
        else
        {
            // End:0x5E5
            if(targetedBug != none)
            {
                // End:0x5CE
                if(bHeadShot)
                {
                    tArrow.SetArrowDamageType(3);
                    return;                    
                }
                else
                {
                    tArrow.SetArrowDamageType(0);
                    return;
                }
            }
        }
    }
    //return;    
}

simulated event @NULL ProjectileFire()
{
    local @NULL StartTrace, EndTrace, RealStartLoc, AimDir, HitLocation, HitNormal,
	    TestImpact, SpawnedProjectile, tArrow, HitActor, aimAssistTarget,
	    tpp, TPC, HitInfo, Attachment;

    local byte FireMode;
    local bool bForceShot, bSpawnFailed;
    local @NULL invMan;

    bForceShot = false;
    bSpawnFailed = false;
    FireMode = GetFiringMode();
    aimAssistTarget = none;
    mTension = float(mAttachment.BowAttachmentGetTension()) / 255.0000000;
    // End:0x5A
    if(mTension == 0.0000000)
    {
        return none;
    }
    // End:0x99D
    if(int(Role) == int(ROLE_Authority))
    {
        invMan = TurokInventoryManager(Instigator.InvManager);
        // End:0xEA
        if((mTension <= FORCEFIRETENSION) && mTension > MINTENSIONTOFIRE)
        {
            mTension = FRand();
            // End:0xC8
            if(mTension < MINALLOWABLETENSION)
            {
                mTension = MINALLOWABLETENSION;                
            }
            else
            {
                // End:0xE2
                if(mTension > 0.8000000)
                {
                    mTension = 0.8000000;
                }
            }
            bForceShot = true;
        }
        // End:0x107
        if(mTension == 1.0000000)
        {
            WeaponRange = mFullTensionMaxDistance;            
        }
        else
        {
            WeaponRange = mTension * mMaxDistance;
            // End:0x133
            if(WeaponRange < mMinDistance)
            {
                WeaponRange = mMinDistance;
            }
        }
        StartTrace = Instigator.GetWeaponStartTraceLocation();
        RealStartLoc = GetWeaponMuzzleLocation(0);
        // End:0x1D3
        if(StartTrace != RealStartLoc)
        {
            EndTrace = StartTrace + (Vector(GetAdjustedAim(StartTrace)) * (GetTraceRange()));
            TestImpact = CalcWeaponFire(StartTrace, EndTrace);
            AimDir = Normal(TestImpact.HitLocation - RealStartLoc);            
        }
        else
        {
            AimDir = Vector(GetAdjustedAim(RealStartLoc));
        }
        // End:0x364
        if(!mbIsMultiPlayer)
        {
            StartTrace = RealStartLoc;
            EndTrace = StartTrace + (AimDir * (GetTraceRange()));
            tpp = TurokPawnPlayer(Owner);
            // End:0x364
            if(tpp != none)
            {
                TPC = TurokPlayerController(tpp.Controller);
                // End:0x364
                if(TPC != none)
                {
                    aimAssistTarget = TPC.mAimAssistTarget;
                    // End:0x364
                    if(aimAssistTarget != none)
                    {
                        HitActor = Trace(HitLocation, HitNormal, EndTrace, StartTrace, true,, HitInfo);
                        // End:0x364
                        if((HitActor != none) && mbAlwaysHitAimAssistTarget)
                        {
                            // End:0x364
                            if(TurokPawn(HitActor) == none)
                            {
                                AimDir = Normal(aimAssistTarget.Location - StartTrace);
                                EndTrace = StartTrace + (AimDir * (GetTraceRange()));
                                HitActor = none;
                                HitActor = Trace(HitLocation, HitNormal, EndTrace, StartTrace, true,, HitInfo);
                                // End:0x364
                                if((HitActor == none) || TurokPawn(HitActor) == none)
                                {
                                    AimDir = Vector(GetAdjustedAim(RealStartLoc));
                                }
                            }
                        }
                    }
                }
            }
        }
        // End:0x403
        if(bForceShot)
        {
            AimDir.X += (AimDir.X * (FRand() + (0.5000000 * 0.2000000)));
            AimDir.Y += (AimDir.Y * (FRand() + (0.5000000 * 0.2000000)));
            AimDir.Z += (AimDir.Z * (FRand() + (0.5000000 * 0.2000000)));
        }
        SpawnedProjectile = __NFUN_278__(GetProjectileClass(), self,, RealStartLoc);
        // End:0x46A
        if(SpawnedProjectile == none)
        {
            StartTrace = Instigator.GetWeaponStartTraceLocation();
            SpawnedProjectile = __NFUN_278__(GetProjectileClass(), self,, StartTrace,,, true);
            bSpawnFailed = true;
        }
        // End:0x925
        if((SpawnedProjectile != none) && !SpawnedProjectile.bDeleteMe)
        {
            // End:0x89C
            if(int(FireMode) == 0)
            {
                tArrow = TurokProjArrowNative(SpawnedProjectile);
                // End:0x4C2
                if(mTension == 1.0000000)
                {
                    WeaponRange = mFullTensionMaxDistance;
                }
                tArrow.mMaxDistance = WeaponRange;
                // End:0x505
                if(mTension == 1.0000000)
                {
                    tArrow.mMaxStickWallDist = tArrow.mMaxTensionStickWallDist;                    
                }
                else
                {
                    tArrow.mMaxStickWallDist = tArrow.mMaxStickWallDist * mTension;
                    // End:0x567
                    if(tArrow.mMaxStickWallDist < tArrow.mMinStickWallDist)
                    {
                        tArrow.mMaxStickWallDist = tArrow.mMinStickWallDist;
                    }
                }
                // End:0x60A
                if(mTension < 1.0000000)
                {
                    // End:0x5B3
                    if(mbIsMultiPlayer && !mbIsCoOpGame)
                    {
                        tArrow.Damage = tArrow.mMultiplayerDamage * mTension;                        
                    }
                    else
                    {
                        tArrow.Damage = tArrow.Damage * mTension;
                    }
                    // End:0x607
                    if(tArrow.Damage < float(mMinDamage))
                    {
                        tArrow.Damage = float(mMinDamage);
                    }                    
                }
                else
                {
                    // End:0x639
                    if(mbIsMultiPlayer && !mbIsCoOpGame)
                    {
                        tArrow.Damage = float(mMaxTensionDamageMP);                        
                    }
                    else
                    {
                        tArrow.Damage = float(mMaxTensionDamage);
                    }
                }
                tArrow.mBowTensionMomentumTransfer = tArrow.mBowTensionMomentumTransfer * mTension;
                // End:0x69F
                if(tArrow.mBowTensionMomentumTransfer < mMinArrowImpactMomentum)
                {
                    tArrow.mBowTensionMomentumTransfer = mMinArrowImpactMomentum;
                }
                // End:0x6EB
                if(((TurokVehicle(HitActor) != none) || TurokPawnCinematic(HitActor) != none) || SkeletalMeshActor(HitActor) != none)
                {
                    tArrow.SetArrowDamageType(0);                    
                }
                else
                {
                    // End:0x734
                    if(mbIsMultiPlayer)
                    {
                        // End:0x71C
                        if(TurokPawnHuman(HitActor) == none)
                        {
                            tArrow.SetArrowDamageType(3);                            
                        }
                        else
                        {
                            tArrow.SetArrowDamageType(0);
                        }                        
                    }
                    else
                    {
                        tArrow.SetArrowDamageType(3);
                    }
                }
                // End:0x7E4
                if(((!mbIsMultiPlayer && TurokPawn(HitActor) != none) && TurokPawn(HitActor).DrivenVehicle == none) && tpp != none)
                {
                    // End:0x7CF
                    if(TurokPawn(HitActor).ArrowCanStickInto())
                    {
                        CalcArrowHitReaction(tArrow, HitActor, HitInfo, mTension, AimDir);                        
                    }
                    else
                    {
                        tArrow.SetArrowDamageType(0);
                    }
                }
                tArrow.Speed = tArrow.MaxSpeed * mTension;
                // End:0x838
                if(tArrow.Speed < float(mMinArrowSpeed))
                {
                    tArrow.Speed = float(mMinArrowSpeed);
                }
                // End:0x864
                if(mTension == 1.0000000)
                {
                    tArrow.Speed = tArrow.mMaxSpeedFullTensionShot;
                }
                tArrow.Init(AimDir);
                invMan.AdjustAmmoPool(mAmmoPoolClass, -1);                
            }
            else
            {
                SpawnedProjectile.Speed = SpawnedProjectile.MaxSpeed * mTension;
                // End:0x8F0
                if(SpawnedProjectile.Speed < float(mMinArrowSpeed))
                {
                    SpawnedProjectile.Speed = float(mMinArrowSpeed);
                }
                SpawnedProjectile.Init(AimDir);
                invMan.AdjustAmmoPool(mAltAmmoClass, -1);
            }
        }
        IncrementFlashCount();
        mShootArrow = 0;
        // End:0x997
        if((TestImpact.HitActor != none) && bSpawnFailed)
        {
            SpawnedProjectile.Touch(TestImpact.HitActor, TestImpact.HitLocation, TestImpact.HitNormal);
        }
        return SpawnedProjectile;
    }
    Attachment = TurokWeapAttachBowNative(mAttachment);
    // End:0x9D5
    if(Attachment != none)
    {
        Attachment.mLastTensionPlayed = Attachment.default.mLastTensionPlayed;
    }
    IncrementFlashCount();
    mShootArrow = 0;
    return none;
    //return ReturnValue;    
}

simulated function bool WaitToRefire()
{
    return false;
    //return ReturnValue;    
}

simulated function PlayPutDownAnimAndWait()
{
    // End:0x3B
    if(Instigator.IsFirstPerson())
    {
        PlayPOVAnimation(GetPutDownAnim(), PutDownTime, 0.1000000, 0.1000000, false, false);
    }
    //return;    
}

simulated function TimeWeaponLower()
{
    // End:0x3B
    if(Instigator.IsFirstPerson())
    {
        PlayPOVAnimation(GetPutDownAnim(), PutDownTime, 0.1000000, 0.1000000, false, false);
    }
    SetTimer(((PutDownTime > float(0)) ? PutDownTime : 0.0100000), false, 'WeaponIsLowered');
    //return;    
}

simulated function TimeWeaponRaise()
{
    // End:0x3B
    if(Instigator.IsFirstPerson())
    {
        PlayPOVAnimation(GetEquipAnim(), EquipTime, 0.1000000, 0.1000000, false, false);
    }
    SetTimer(((EquipTime > float(0)) ? EquipTime : 0.0100000), false, 'WeaponIsRaised');
    //return;    
}

simulated function DoGrenadeTossPOV()
{
    // End:0x49
    if(Instigator.IsFirstPerson())
    {
        PlayPOVAnimation(GetGrenadeThrowAnim(), mGrenadeAnimTime, mGrenadeAnimTime * 0.1000000, mGrenadeAnimTime * 0.1000000, true, false);
    }
    //return;    
}

simulated function ClearBowSystemVariables()
{
    mShootArrow = 0;
    mTension = 0.0000000;
    mTensionTicks = 0;
    mTensionAtRelease = 0.0000000;
    mbTensionAnimInited = false;
    mPrevVirtualAnalogTrigger = 0.0000000;
    mVirtualAnalogTrigger = 0.0000000;
    mTicksAtMaxTension = 0;
    mbAutoTension = false;
    mbAutoDetension = false;
    mAutoTensionDirection = 1.0000000;
    mbPreventTensionRelease = false;
    mbPreventTensionAdding = false;
    mbPlayingMaxTensionAnim = false;
    mbTooTense = false;
    mbOkToAutoTension = true;
    WeaponRange = mMinDistance;
    mMaxTensionShakePct = 0.0000000;
    mbOkToShake = false;
    mbFinishDetensioning = false;
    mDetensionTime = -1.0000000;
    mbReleasedWithinFireWindow = false;
    //return;    
}

simulated event bool GetIsStealthWeapon()
{
    return true;
    //return ReturnValue;    
}

simulated event StartFire(byte FireModeNum)
{
    // End:0x0E
    if(mbSwitchingArrowType)
    {
        return;        
    }
    else
    {
        super.StartFire(FireModeNum);
    }
    //return;    
}

simulated function StopFire(byte FireModeNum)
{
    // End:0x11D
    if(int(FireModeNum) == 0)
    {
        // End:0x112
        if(!mbAutoDetension)
        {
            // End:0xA5
            if(!mbReleasedWithinFireWindow)
            {
                // End:0x3D
                if(mDetensionTime < 0.0000000)
                {
                    mTensionAtRelease = mTension;
                }
                // End:0x9B
                if(((mDetensionTime > 0.0000000) || mTensionTicks > mMinTensionTicksToFire) && mDetensionTime < mTimeWindowForShot)
                {
                    mbReleasedWithinFireWindow = true;
                    // End:0x9B
                    if(mTensionAtRelease <= MINTENSIONTOFIRE)
                    {
                        mTensionAtRelease = MINALLOWABLETENSION;
                        mTension = MINALLOWABLETENSION;
                    }
                }
                UpdateBowTensionTimer();
            }
            // End:0xCC
            if(mbReleasedWithinFireWindow)
            {
                super.StopFire(0);
                mbReleasedWithinFireWindow = false;
                mDetensionTime = -1.0000000;                
            }
            else
            {
                // End:0xF8
                if(mTension == 0.0000000)
                {
                    mTensionAtRelease = 0.0000000;
                    UpdateBowTensionTimer();
                    super.StopFire(0);
                }
            }
            // End:0x10F
            if(mTension == 0.0000000)
            {
                mbTensionAnimInited = false;
            }            
        }
        else
        {
            mbFinishDetensioning = true;
        }        
    }
    else
    {
        super.StopFire(1);
    }
    //return;    
}

// Export UTurokWeapBowNative::execSendToFiringState(FFrame&, void* const)
native function SendToFiringState(byte FireModeNum);

// Export UTurokWeapBowNative::execFireAmmunition(FFrame&, void* const)
native function FireAmmunition();

// Export UTurokWeapBowNative::execCauseFireEffects(FFrame&, void* const)
native function CauseFireEffects(byte FireModeNum);

// Export UTurokWeapBowNative::execCalcBowAnimType(FFrame&, void* const)
native function CalcBowAnimType(out byte animType, byte FireMode);

simulated event @NULL GetEquipAnim()
{
    local byte animType;
    local @NULL locAnim;
    local byte FireMode;

    FireMode = GetFiringMode();
    CalcBowAnimType(animType, FireMode);
    switch(animType)
    {
        // End:0x3E
        case 0:
            locAnim = mEquipWithNoArrows;
            // End:0x67
            break;
        // End:0x51
        case 1:
            locAnim = mEquipAnim;
            // End:0x67
            break;
        // End:0x64
        case 2:
            locAnim = mEquipAnimAlt;
            // End:0x67
            break;
        // End:0xFFFF
        default:
            break;
    }
    return locAnim;
    //return ReturnValue;    
}

// Export UTurokWeapBowNative::execGetPutDownAnim(FFrame&, void* const)
native function @NULL GetPutDownAnim();

simulated event @NULL GetGrenadeThrowAnim()
{
    local byte animType;
    local @NULL locAnim;
    local byte FireMode;

    FireMode = GetFiringMode();
    CalcBowAnimType(animType, FireMode);
    switch(animType)
    {
        // End:0x3E
        case 0:
            locAnim = mGrenadeWithNoArrows;
            // End:0x67
            break;
        // End:0x51
        case 1:
            locAnim = mGrenadeAnim;
            // End:0x67
            break;
        // End:0x64
        case 2:
            locAnim = mGrenadeAnimAlt;
            // End:0x67
            break;
        // End:0xFFFF
        default:
            break;
    }
    return locAnim;
    //return ReturnValue;    
}

simulated function @NULL GetWeaponAmbientIdleAnim(optional byte FireMode = 0)
{
    local byte animType;
    local @NULL locAnim;

    CalcBowAnimType(animType, FireMode);
    switch(animType)
    {
        // End:0x34
        case 0:
            locAnim = mNoAmmoIdle;
            // End:0x5D
            break;
        // End:0x47
        case 1:
            locAnim = mAmbientIdleAnim;
            // End:0x5D
            break;
        // End:0x5A
        case 2:
            locAnim = mAmbientIdleAnimAlt;
            // End:0x5D
            break;
        // End:0xFFFF
        default:
            break;
    }
    return locAnim;
    //return ReturnValue;    
}

simulated function PlayAmbientIdleAnim()
{
    StartPOVIdleAnim(GetFiringMode());
    //return;    
}

simulated function StartPOVIdleAnim(byte FireMode)
{
    local @NULL ambIdleAnim;

    // End:0x6A
    if(Instigator.IsFirstPerson())
    {
        ambIdleAnim = GetWeaponAmbientIdleAnim(FireMode);
        PlayPOVCannedAnimation(ambIdleAnim, mAmbientIdleTime, 0.0000000, true);
        // End:0x62
        if(ambIdleAnim == mNoAmmoIdle)
        {
            mbPlayingOutOfAmmoIdle = true;            
        }
        else
        {
            mbPlayingOutOfAmmoIdle = false;
        }
    }
    //return;    
}

simulated function WaitForPutDownAnimTimer()
{
    // End:0x4E
    if(Instigator.IsFirstPerson())
    {
        PlayPOVAnimation(GetEquipAnim(), EquipTime, 0.1000000, 0.1000000, false, false);
        SetTimer(EquipTime, false, 'WaitForEquipAnimTimer');
    }
    //return;    
}

simulated event float GetSpeedBonus()
{
    // End:0x2A
    if(mVirtualAnalogTrigger >= 255.0000000)
    {
        // End:0x21
        if(mbIsMultiPlayer)
        {
            return mFullTensionSpeedBonusMP;            
        }
        else
        {
            return mFullTensionSpeedBonus;
        }        
    }
    else
    {
        return super.GetSpeedBonus();
    }
    //return ReturnValue;    
}

simulated state WeaponEquipping
{
    simulated function WeaponEquipped()
    {
        local @NULL InstigatorController;
        local byte FireMode;

        FireMode = GetFiringMode();
        // End:0x25
        if(bWeaponPutDown)
        {
            PutDownWeapon();
            return;
        }
        // End:0x4A
        if(Instigator.IsFirstPerson())
        {
            StartPOVIdleAnim(FireMode);
        }
        GotoState('Active');
        InstigatorController = TurokPlayerController(Instigator.Controller);
        // End:0x93
        if(InstigatorController != none)
        {
            InstigatorController.NotifyWeaponEquipped(self);            
        }
        else
        {
            // End:0xCD
            if(TurokAIControllerHumanNpc(Instigator.Controller) != none)
            {
                TurokAIControllerHumanNpc(Instigator.Controller).NotifyWeaponEquipped();
            }
        }
        //return;        
    }
    stop;    
}

simulated state BowTensioning
{
    simulated event bool IsFiring()
    {
        return true;
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        local @NULL player_hud;
        local byte FireMode;

        FireMode = GetFiringMode();
        InitPOVAnimForScrubbing(((int(FireMode) == 0) ? mTensioningAnim : mTensioningAnimAlt), 0.0000000, 0.0000000);
        mbTensionAnimInited = true;
        // End:0x6D
        if(!IsTimerActive('UpdateBowTensionTimer'))
        {
            SetTimer(0.1000000, true, 'UpdateBowTensionTimer');
        }
        // End:0xFD
        if((TurokPawnHuman(Instigator) != none) && TurokPlayerController(Instigator.Controller) != none)
        {
            player_hud = TurokHud(TurokPlayerController(Instigator.Controller).myHUD);
            // End:0xFD
            if((player_hud != none) && player_hud.mReticle != none)
            {
                player_hud.mReticle.mRotPcnt = mTension;
            }
        }
        // End:0x12C
        if(!IsTimerActive('RefireCheckTimer'))
        {
            SetTimer(GetFireInterval(0), true, 'RefireCheckTimer');
        }
        //return;        
    }

    simulated function RefireCheckTimer()
    {
        local @NULL player_hud, TPC;
        local byte FireMode;
        local float locTensionAtRelease, pctShake;

        FireMode = GetFiringMode();
        // End:0x25
        if(bWeaponPutDown)
        {
            PutDownWeapon();
            return;
        }
        // End:0x3A6
        if(PendingFire(0))
        {
            // End:0x7D
            if(!mbPlayingMaxTensionAnim && mbAutoTension || mbAutoDetension)
            {
                ScrubPOVAnim(((int(FireMode) == 0) ? mTensioningAnim : mTensioningAnimAlt), mTension, false);
            }
            // End:0xA7
            if(mTension >= 0.7000000)
            {
                mAttachment.PlayAmbience(mBowMaxTensionSndCue);                
            }
            else
            {
                // End:0x190
                if(mbAutoTension || mbAutoDetension)
                {
                    // End:0x18D
                    if(((mLastTensionDirection != mAutoTensionDirection) || mTension == float(0)) || Abs(mTension - mLastTensionPlayed) >= mTensionSndThreshold)
                    {
                        // End:0x14E
                        if(mAutoTensionDirection == float(1))
                        {
                            // End:0x128
                            if(mTension == float(0))
                            {
                                mAttachment.PlayAmbience(SoundCue'SndWeapBowArrow.BowPullSndCue');                                
                            }
                            else
                            {
                                mAttachment.PlayAmbience(mBowIncreaseTensionSndCue);
                            }
                            mLastTensionPlayed = mTension;                            
                        }
                        else
                        {
                            // End:0x182
                            if(mAutoTensionDirection == float(-1))
                            {
                                mAttachment.PlayAmbience(mBowDecreaseTensionSndCue);
                                mLastTensionPlayed = mTension;
                            }
                        }
                        mLastTensionDirection = mAutoTensionDirection;
                    }                    
                }
                else
                {
                    mLastTensionPlayed = 0.0000000;
                    mAttachment.StopAmbience();
                }
            }
            // End:0x1CC
            if(mTension == 1.0000000)
            {
                WeaponRange = mFullTensionMaxDistance;                
            }
            else
            {
                WeaponRange = mTension * mMaxDistance;
                // End:0x1F8
                if(WeaponRange < mMinDistance)
                {
                    WeaponRange = mMinDistance;
                }
            }
            pctShake = ((float(mTicksAtMaxTension) * 1.0000000) / (float(mMaxTensionTicksForceShot) * 1.0000000)) * 0.6800000;
            // End:0x2CC
            if(((mVirtualAnalogTrigger == 255.0000000) && mbOkToShake) && float(Rand(100)) < (pctShake * 100.0000000))
            {
                mPrimaryFireFF.Samples[0].LeftAmplitude = 15;
                mPrimaryFireFF.Samples[0].RightAmplitude = 15;
                TPC = TurokPlayerController(Instigator.Controller);
                // End:0x2CC
                if(TPC != none)
                {
                    TPC.TurokPlayForceFeedbackWaveform(mPrimaryFireFF);
                }
            }
            // End:0x3A4
            if((Instigator != none) && TurokPlayerController(Instigator.Controller) != none)
            {
                player_hud = TurokHud(TurokPlayerController(Instigator.Controller).myHUD);
                // End:0x3A4
                if((player_hud != none) && player_hud.mReticle != none)
                {
                    player_hud = TurokHud(TurokPlayerController(Pawn(Owner).Controller).myHUD);
                    // End:0x3A4
                    if((player_hud != none) && player_hud.mReticle != none)
                    {
                        player_hud.mReticle.mRotPcnt = mTension;
                    }
                }
            }
            return;
        }
        // End:0x67A
        if(mbTensionAnimInited)
        {
            ClearTimer('RefireCheckTimer');
            ClearTimer('AutoTensionTimer');
            ClearTimer('UpdateBowTensionTimer');
            // End:0x421
            if((int(Role) == int(ROLE_Authority)) && mAttachment != none)
            {
                locTensionAtRelease = float(mAttachment.BowAttachmentGetTension()) / 255.0000000;                
            }
            else
            {
                locTensionAtRelease = mTensionAtRelease;
            }
            // End:0x5E2
            if(locTensionAtRelease >= MINTENSIONTOFIRE)
            {
                // End:0x502
                if(int(FireMode) == 0)
                {
                    // End:0x4CC
                    if((GetCurrentClipAmmo()) == 1)
                    {
                        // End:0x48E
                        if((GetCurrentClipAltAmmo()) == 0)
                        {
                            mFireAnims[0] = ((locTensionAtRelease > 0.7500000) ? mHighTensionFireLastShotAnim : mLowTensionFireLastShotAnim);                            
                        }
                        else
                        {
                            // End:0x4C9
                            if((GetCurrentClipAltAmmo()) > 0)
                            {
                                mbForceSwitchArrowType = true;
                                mFireAnims[0] = ((locTensionAtRelease > 0.7500000) ? mHighTensionFireAnimAlt : mLowTensionFireAnimAlt);
                            }
                        }                        
                    }
                    else
                    {
                        // End:0x4FF
                        if((GetCurrentClipAmmo()) > 1)
                        {
                            mFireAnims[0] = ((locTensionAtRelease > 0.7500000) ? mHighTensionFireAnim : mLowTensionFireAnim);
                        }
                    }                    
                }
                else
                {
                    // End:0x586
                    if((GetCurrentClipAltAmmo()) == 1)
                    {
                        // End:0x548
                        if((GetCurrentClipAmmo()) == 0)
                        {
                            mFireAnims[0] = ((locTensionAtRelease > 0.7500000) ? mHighTensionFireLastShotAnimAlt : mLowTensionFireLastShotAnimAlt);                            
                        }
                        else
                        {
                            // End:0x583
                            if((GetCurrentClipAmmo()) > 0)
                            {
                                mbForceSwitchArrowType = true;
                                mFireAnims[0] = ((locTensionAtRelease > 0.7500000) ? mHighTensionFireAnim : mLowTensionFireAnim);
                            }
                        }                        
                    }
                    else
                    {
                        // End:0x5B9
                        if((GetCurrentClipAltAmmo()) > 1)
                        {
                            mFireAnims[0] = ((locTensionAtRelease > 0.7500000) ? mHighTensionFireAnimAlt : mLowTensionFireAnimAlt);
                        }
                    }
                }
                FireAmmunition();
                SetTimer(mFireAnimTimes[0] - 0.1000000, false, 'WaitForFireAnimTimer');                
            }
            else
            {
                WaitForFireAnimTimer();
            }
            // End:0x677
            if((Instigator != none) && TurokPlayerController(Instigator.Controller) != none)
            {
                player_hud = TurokHud(TurokPlayerController(Instigator.Controller).myHUD);
                // End:0x677
                if((player_hud != none) && player_hud.mReticle != none)
                {
                    player_hud.mReticle.mRotPcnt = 0.0000000;
                }
            }            
        }
        else
        {
            WaitForFireAnimTimer();
        }
        ClearBowSystemVariables();
        return;
        //return;        
    }

    simulated function WaitForFireAnimTimer()
    {
        local byte FireMode;

        FireMode = GetFiringMode();
        // End:0x4E
        if(mbForceSwitchArrowType)
        {
            mbForceSwitchArrowType = false;
            SetCurrentFireMode(byte(((int(FireMode) == 0) ? 1 : 0)));
            FireMode = GetFiringMode();
        }
        StartPOVIdleAnim(FireMode);
        ClearTimer('WaitForFireAnimTimer');
        GotoState('Active');
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0xD8
        if(mTensionTicks > 0)
        {
            mShootArrow = 1;
            mTensionAtRelease = 0.1000000;
            mTensionTicks = 0;
            mTicksAtMaxTension = 0;
            StopFire(0);
            mbAutoTension = false;
            // End:0x63
            if(IsTimerActive('AutoTensionTimer'))
            {
                ClearTimer('AutoTensionTimer');
            }
            // End:0x86
            if(IsTimerActive('PreShakingTimer'))
            {
                ClearTimer('PreShakingTimer');
            }
            mTension = mTensionAtRelease;
            UpdateBowTensionTimer();
            RefireCheckTimer();
            // End:0xD8
            if(mbForceSwitchArrowType)
            {
                mbForceSwitchArrowType = false;
                SetCurrentFireMode(byte(((int(GetFiringMode()) == 0) ? 1 : 0)));
            }
        }
        mLastTensionPlayed = 0.0000000;
        mAttachment.StopAmbience();
        ClearFlashCount();
        ClearFlashLocation();
        ClearTimer('RefireCheckTimer');
        ClearTimer('WaitForFireAnimTimer');
        ClearTimer('UpdateBowTensionTimer');
        ClearTimer('PreShakingTimer');
        ClearBowSystemVariables();
        // End:0x192
        if(AIController(Instigator.Controller) != none)
        {
            AIController(Instigator.Controller).NotifyWeaponFinishedFiring(self, 0);
        }
        //return;        
    }
    stop;    
}

simulated state Active
{
    simulated function BeginState(name PreviousStateName)
    {
        local byte FireMode;

        FireMode = GetFiringMode();
        // End:0x42
        if(!IsTimerActive('TensionTimer'))
        {
            ClearBowSystemVariables();
            SetTimer(0.0100000, true, 'TensionTimer');
        }
        // End:0x58
        if(bWeaponPutDown)
        {
            PutDownWeapon();            
        }
        else
        {
            // End:0x9A
            if((PreviousStateName == 'ReActivated') || PreviousStateName == 'ThrowGrenadeState')
            {
                StartPOVIdleAnim(FireMode);
                mbSwitchingArrowType = false;                
            }
            else
            {
                // End:0xB4
                if(PendingFire(0))
                {
                    BeginFire(0);
                }
            }
        }
        //return;        
    }

    simulated function BeginFire(byte FireModeNum)
    {
        local @NULL player_hud, tph;

        // End:0x12A
        if(!bDeleteMe && Instigator != none)
        {
            // End:0x113
            if(int(FireModeNum) == 0)
            {
                // End:0x52
                if(HasAmmo(CurrentFireMode))
                {
                    SetPendingFire(0);
                    SendToFiringState(0);                    
                }
                else
                {
                    // End:0x110
                    if(mAttachment != none)
                    {
                        tph = TurokPawnHuman(Instigator);
                        // End:0x110
                        if((tph != none) && TurokPlayerController(tph.Controller) != none)
                        {
                            player_hud = TurokHud(TurokPlayerController(tph.Controller).myHUD);
                            // End:0x110
                            if((player_hud != none) && player_hud.mAmmoDisplay != none)
                            {
                                player_hud.mAmmoDisplay.SetDryFire(self, FireModeNum);
                                player_hud.ResetFadeTimer();
                            }
                        }
                    }
                }                
            }
            else
            {
                SetPendingFire(1);
                SendToFiringState(1);
            }
        }
        //return;        
    }

    simulated function WaitForEquipAnimTimer()
    {
        mbSwitchingArrowType = false;
        StartPOVIdleAnim(GetFiringMode());
        //return;        
    }
    stop;    
}

state ReActivated
{
    simulated function BeginState(name PreviousStateName)
    {
        local @NULL humanPawn, InstigatorController;

        mbSwitchingArrowType = false;
        humanPawn = TurokPawnHuman(Instigator);
        // End:0x6A
        if(((humanPawn != none) && humanPawn.mWeaponMediator != none) && humanPawn.mWeaponMediator.mbWeaponsLowered == true)
        {
            GotoState('Inactive');            
        }
        else
        {
            GotoState('Active');
        }
        InstigatorController = TurokPlayerController(Instigator.Controller);
        // End:0xB0
        if(InstigatorController != none)
        {
            InstigatorController.NotifyWeaponEquipped(self);
        }
        //return;        
    }
    stop;    
}

state Deactivated
{
    simulated function BeginState(name PreviousStateName)
    {
        ClearFlashCount();
        ClearFlashLocation();
        ClearTimer('RefireCheckTimer');
        ClearTimer('WaitForFireAnimTimer');
        ClearTimer('UpdateBowTensionTimer');
        ClearTimer('PreShakingTimer');
        ClearTimer('TensionTimer');
        ClearTimer('AutoTensionTimer');
        ClearBowSystemVariables();
        super.BeginState(PreviousStateName);
        //return;        
    }
    stop;    
}

auto state Inactive
{
    simulated function BeginState(name PreviousStateName)
    {
        ClearBowSystemVariables();
        ClearPendingFire(0);
        mbSwitchingArrowType = false;
        ClearFlashCount();
        ClearFlashLocation();
        ClearTimer('RefireCheckTimer');
        ClearTimer('WaitForFireAnimTimer');
        ClearTimer('UpdateBowTensionTimer');
        ClearTimer('PreShakingTimer');
        ClearTimer('TensionTimer');
        ClearTimer('AutoTensionTimer');
        super.BeginState(PreviousStateName);
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: TurokZoomComponent'Default__TurokWeapBowNative.Zoom'
    begin object name=Zoom
    end object
    mZoomValues=Zoom
}