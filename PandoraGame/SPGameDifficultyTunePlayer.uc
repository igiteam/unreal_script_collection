class SPGameDifficultyTunePlayer extends SPGameDifficultyTune
    native
    editinlinenew;

struct native SPPlayerFallDistToDamage
{
    /** INCLUDES MACROS struct DECLARATIONS */
    var() FloatDifficulty MinDist;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() FloatDifficulty maxDist;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() FloatDifficulty Damage;

    structdefaultproperties
    {
        MinDist=(baseValue=-1.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        maxDist=(baseValue=-1.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        Damage=(baseValue=0.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
    }
};

struct native WalkParams
{
    /** speed to move forward */
    var() float playerForwardSpeed;
    /** speed to move backward */
    var() float playerBackwardSpeed;
    /** speed to move sideways */
    var() float playerStrafeSpeed;

    structdefaultproperties
    {
        playerForwardSpeed=0.0000000
        playerBackwardSpeed=0.0000000
        playerStrafeSpeed=0.0000000
    }
};

struct native CrouchParams
{
    /** multiplier for walk speed when crouching */
    var() float CrouchSpeedMult;

    structdefaultproperties
    {
        CrouchSpeedMult=0.0000000
    }
};

struct native DownSiteParams
{
    /** multiplier for walk speed when down site */
    var() float DownSiteSpeedMult;
    /** multiplier for walk speed when crouching & down site */
    var() float CrouchDownSiteSpeedMult;

    structdefaultproperties
    {
        DownSiteSpeedMult=0.0000000
        CrouchDownSiteSpeedMult=0.0000000
    }
};

struct native SprintParams
{
    /** multiplier for walk speed when sprinting */
    var() float SprintSpeedMult;
    /** speed to move when sprint 1st starts */
    var() FloatDifficulty SprintBurstSpeed;
    /** charged for at least this time to be able sprint */
    var() FloatDifficulty SprintRampDownTime;
    /** sprint stays on/off for at least this time */
    var() float SprintDurationMin;
    /** maximum time sprint can be used */
    var() float SprintTimeMax;
    /** time to reach max charge while crouching */
    var() float SprintRegenTimeCrouching;
    /** time to reach max charge while standing */
    var() float SprintRegenTimeStanding;
    /** time to reach max charge while moving */
    var() float SprintRegenTimeMoving;

    structdefaultproperties
    {
        SprintSpeedMult=0.0000000
        SprintBurstSpeed=(baseValue=0.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        SprintRampDownTime=(baseValue=0.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        SprintDurationMin=0.0000000
        SprintTimeMax=0.0000000
        SprintRegenTimeCrouching=0.0000000
        SprintRegenTimeStanding=0.0000000
        SprintRegenTimeMoving=0.0000000
    }
};

struct native SprintJumpParams
{
    /** cost of jumping while sprinting */
    var() float SprintJumpCost;
    /** sprint jump if cutoff when meter below this */
    var() float SprintJumpCutoff;
    /** sprint jump if cutoff when meter below this */
    var() float percentOfMoveSpeedUsedForSprintJumpBoost;

    structdefaultproperties
    {
        SprintJumpCost=0.0000000
        SprintJumpCutoff=0.0000000
        percentOfMoveSpeedUsedForSprintJumpBoost=0.0000000
    }
};

struct native JumpParams
{
    /** if true impulse JumpZ is computed based off of the MaxJumpHeight */
    var() bool bCalcJumpImpulseUsingMaxJumpHeight;
    /** if true impulse JumpZ is computed based off of the MaxJumpHeight */
    var() float percentOfMoveSpeedUsedForJumpBoost;
    /** player jump height */
    var() float playerJumpHeight;
    /** maximum height of a jump allowed for PlayerPawns */
    var() float playerMaxJumpHeight;
    /** value from 0 to 100 the represents the percentage of the players maximum speed they must be travelling in order for boost to be applied */
    var() float playerJumpImpulse;
    /** value from 0 to 100 the represents the percentage of the players maximum speed they must be travelling in order for boost to be applied */
    var() int minPercentageOfMaximumSpeedToApplyBoost;

    structdefaultproperties
    {
        bCalcJumpImpulseUsingMaxJumpHeight=false
        percentOfMoveSpeedUsedForJumpBoost=0.0000000
        playerJumpHeight=0.0000000
        playerMaxJumpHeight=0.0000000
        playerJumpImpulse=0.0000000
        minPercentageOfMaximumSpeedToApplyBoost=0
    }
};

struct native TurnParams
{
    /** NOT USED YET! */
    var() float SensitivityMultiplier;
    /** NOT USED YET! */
    var() float SensitivityMultiplierLow;
    /** NOT USED YET! */
    var() float SensitivityMultiplierMed;
    /** NOT USED YET! */
    var() float SensitivityMultiplierHigh;
    /** NOT USED YET! */
    var() float TurningAccelerationMultiplier;
    /** NOT USED YET! */
    var() bool bAutoCenterPitch;
    /** NOT USED YET! */
    var() float Dodge_Threshold;
    /** NOT USED YET! */
    var() float SlowTurnScaling;
    /** NOT USED YET! */
    var() float AutoCenterDelay;
    /** NOT USED YET! */
    var() bool bViewAccelerationEnabled;
    /** NOT USED YET! */
    var() bool bDebugViewAcceleration;
    /** NOT USED YET! */
    var() bool bTargetFrictionEnabled;
    /** NOT USED YET! */
    var() bool bDebugTargetFriction;
    /** NOT USED YET! */
    var() float ViewAccel_YawThreshold;
    /** NOT USED YET! */
    var() float ViewAccel_DiagonalThreshold;
    /** NOT USED YET! */
    var() float ViewAccel_BaseMultiplier;
    /** NOT USED YET! */
    var() float ViewAccel_TimeToHoldBeforeFastAcceleration;
    /** NOT USED YET! */
    var() float ViewAccel_RampSpeed;
    /** NOT USED YET! */
    var() float ViewAccel_MaxTurnSpeed;
    /** NOT USED YET! */
    var() float ViewAccel_Twitchy;
    /** NOT USED YET! */
    var() float MagicScaleForSensitivityMiddle;
    /** NOT USED YET! */
    var() float MagicScaleForSensitivityEdge;
    /** NOT USED YET! */
    var() float ViewAccel_PitchThreshold;
    /** NOT USED YET! */
    var() float ViewAccel_LookingUpOrDownBoundary;
    /** NOT USED YET! */
    var() float ViewAccel_BackToCenterBoundary;
    /** NOT USED YET! */
    var() float ViewAccel_BackToCenterSpeed;
    /** NOT USED YET! */
    var() float AutoPitchCenterSpeed;
    /** NOT USED YET! */
    var() float AutoPitchStopAdjustingValue;
    /** NOT USED YET! */
    var() float HoverBoardPitchMultiplier;
    /** NOT USED YET! */
    var() bool bPitchAccelerationEnabled;
    /** NOT USED YET! */
    var() float PitchAccelerationMultiplier;
    /** NOT USED YET! */
    var() float PitchAccel_PitchThreshold;
    /** NOT USED YET! */
    var() float PitchAccel_BaseMultiplier;
    /** NOT USED YET! */
    var() float PitchAccel_TimeToHoldBeforeFastAcceleration;
    /** NOT USED YET! */
    var() float PitchAccel_RampSpeed;
    /** NOT USED YET! */
    var() float PitchAccel_MaxTurnSpeed;

    structdefaultproperties
    {
        SensitivityMultiplier=0.0000000
        SensitivityMultiplierLow=0.0000000
        SensitivityMultiplierMed=0.0000000
        SensitivityMultiplierHigh=0.0000000
        TurningAccelerationMultiplier=0.0000000
        bAutoCenterPitch=false
        Dodge_Threshold=0.0000000
        SlowTurnScaling=0.0000000
        AutoCenterDelay=0.0000000
        bViewAccelerationEnabled=false
        bDebugViewAcceleration=false
        bTargetFrictionEnabled=false
        bDebugTargetFriction=false
        ViewAccel_YawThreshold=0.0000000
        ViewAccel_DiagonalThreshold=0.0000000
        ViewAccel_BaseMultiplier=0.0000000
        ViewAccel_TimeToHoldBeforeFastAcceleration=0.0000000
        ViewAccel_RampSpeed=0.0000000
        ViewAccel_MaxTurnSpeed=0.0000000
        ViewAccel_Twitchy=0.0000000
        MagicScaleForSensitivityMiddle=0.0000000
        MagicScaleForSensitivityEdge=0.0000000
        ViewAccel_PitchThreshold=0.0000000
        ViewAccel_LookingUpOrDownBoundary=0.0000000
        ViewAccel_BackToCenterBoundary=0.0000000
        ViewAccel_BackToCenterSpeed=0.0000000
        AutoPitchCenterSpeed=0.0000000
        AutoPitchStopAdjustingValue=0.0000000
        HoverBoardPitchMultiplier=0.0000000
        bPitchAccelerationEnabled=false
        PitchAccelerationMultiplier=0.0000000
        PitchAccel_PitchThreshold=0.0000000
        PitchAccel_BaseMultiplier=0.0000000
        PitchAccel_TimeToHoldBeforeFastAcceleration=0.0000000
        PitchAccel_RampSpeed=0.0000000
        PitchAccel_MaxTurnSpeed=0.0000000
    }
};

/** Maximum amount of damage the player may sustain from a rigid body */
var() int MaxRigidBodyDamage;
var(AnimusPulse) FloatDifficulty m_animusUsed;
var(AnimusPulse) FloatDifficulty m_minTimeBetweenPulses;
var(AnimusPulse) FloatDifficulty m_damage;
var(AnimusPulse) FloatDifficulty m_damageRadius;
var(AnimusPulse) FloatDifficulty m_duration;
var(AnimusPulse) FloatDifficulty m_impulse;
var(AnimusPulse) Vector AnimusFireOffset;
var(FallDamage) array<SPPlayerFallDistToDamage> m_fallDamage;
var(Movement) WalkParams Walk;
var(Movement) CrouchParams Crouch;
var(Movement) DownSiteParams DownSite;
var(Movement) SprintParams Sprint;
var(Movement) SprintJumpParams SprintJump;
var(Movement) JumpParams Jump;
var(Movement) TurnParams Turn;
var(Movement) float MinFallDistanceToPlayLandingSound;
var(Multiplayer) FloatDifficulty MP_HeadShotMultiplier;
var(Common) const int MaxSimultaneousEnemies;

function float AnimusPulseDuration()
{
    return GetValue(m_duration);
    //return ReturnValue;    
}

function float AnimusPulseDamage()
{
    return GetValue(m_damage);
    //return ReturnValue;    
}

function float AnimusPulseDamageRadius()
{
    return GetValue(m_damageRadius);
    //return ReturnValue;    
}

function float AnimusPulseImplse()
{
    return GetValue(m_impulse);
    //return ReturnValue;    
}

function float animusPulseAnimusUsed()
{
    return GetValue(m_animusUsed);
    //return ReturnValue;    
}

function float AnimusPulseMinTimeBetweenPulses()
{
    return GetValue(m_minTimeBetweenPulses);
    //return ReturnValue;    
}

function float AnimusPulseExpansionRate()
{
    local float Rate, Radius, Time;

    Radius = AnimusPulseDamageRadius();
    // End:0x28
    if(Radius <= float(0))
    {
        Radius = 1.0000000;
    }
    Time = GetValue(m_duration);
    // End:0x5C
    if(Time <= float(0))
    {
        Time = Radius / 0.1000000;
    }
    Rate = Radius / Time;
    return Rate;
    //return ReturnValue;    
}

function float DamageForFallDistance(float Distance)
{
    local float Damage, MinDist, maxDist;
    local int Idx;

    Damage = 0.0000000;
    Idx = 0;
    J0x12:

    // End:0xDD [Loop If]
    if(Idx < m_fallDamage.Length)
    {
        MinDist = GetValue(m_fallDamage[Idx].MinDist);
        maxDist = GetValue(m_fallDamage[Idx].maxDist);
        // End:0xD3
        if((MinDist < float(0)) || MinDist <= Distance)
        {
            // End:0xD3
            if((maxDist < float(0)) || maxDist >= Distance)
            {
                Damage = GetValue(m_fallDamage[Idx].Damage);
                // [Explicit Break]
                goto J0xDD;
            }
        }
        ++Idx;
        // [Loop Continue]
        goto J0x12;
    }
    J0xDD:

    // End:0xF5
    if(Damage < float(0))
    {
        Damage = 0.0000000;
    }
    return Damage;
    //return ReturnValue;    
}
