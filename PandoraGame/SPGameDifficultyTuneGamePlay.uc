class SPGameDifficultyTuneGamePlay extends SPGameDifficultyTune
    native
    editinlinenew;

struct native ScreenShakeScalingTune
{
    /** INCLUDES MACROS struct DECLARATIONS */
    var() FloatDifficulty LocAmplitudeScale;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() FloatDifficulty LocFrequencyScale;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() FloatDifficulty RotAmplitudeScale;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() FloatDifficulty RotFrequencyScale;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() FloatDifficulty FOVAmplitudeScale;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() FloatDifficulty FOVFrequencyScale;

    structdefaultproperties
    {
        LocAmplitudeScale=(baseValue=1.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        LocFrequencyScale=(baseValue=1.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        RotAmplitudeScale=(baseValue=1.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        RotFrequencyScale=(baseValue=1.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        FOVAmplitudeScale=(baseValue=1.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        FOVFrequencyScale=(baseValue=1.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
    }
};

struct native MeleeImpactShakeDataTune
{
    var() FloatDifficulty YawImpactDegrees;
    var() FloatDifficulty PitchImpactDegrees;
    var() FloatDifficulty impactTime;
    var() FloatDifficulty RecoveryTime;
    var() FloatDifficulty ShakeAmpl;
    var() FloatDifficulty BiteShakeAmpl;
    var() FloatDifficulty BiteImpactTime;
    var() FloatDifficulty DamageValToOne;
    var() FloatDifficulty FromBehindImpactScale;
    var() FloatDifficulty MultiHitReductionScale;
    var() FloatDifficulty MultiHitTimeTakenToReduce;
    var() FloatDifficulty MultiHitReductionTimeOut;

    structdefaultproperties
    {
        YawImpactDegrees=(baseValue=35.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        PitchImpactDegrees=(baseValue=10.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        impactTime=(baseValue=0.1700000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        RecoveryTime=(baseValue=0.4000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        ShakeAmpl=(baseValue=300.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        BiteShakeAmpl=(baseValue=1100.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        BiteImpactTime=(baseValue=0.3500000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        DamageValToOne=(baseValue=5.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        FromBehindImpactScale=(baseValue=0.5000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        MultiHitReductionScale=(baseValue=0.5000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        MultiHitTimeTakenToReduce=(baseValue=1.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        MultiHitReductionTimeOut=(baseValue=2.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
    }
};

struct native SecsToKeepDeadTaxedType
{
    var() class<PandoraDamageType> DamageType;
    var() FloatDifficulty SecsToKeepDeadTaxed;

    structdefaultproperties
    {
        DamageType=none
        SecsToKeepDeadTaxed=(baseValue=0.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
    }
};

struct native SecsToKeepDeadNormType
{
    var() class<PandoraDamageType> DamageType;
    var() FloatDifficulty SecsToKeepDeadNorm;

    structdefaultproperties
    {
        DamageType=none
        SecsToKeepDeadNorm=(baseValue=0.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
    }
};

/** Maximum number of dead bodies to keep in the world before  forcibly removing creatures */
var(Death) const int MaxNumDeadBodies;
/** Number of seconds to keep dead bodies around before fade out */
var(Death) const FloatDifficulty SecsToKeepDeadNorm;
var(Death) export editinline array<export editinline SecsToKeepDeadNormType> SecsToKeepDeadNormByDamageType;
/** Number of seconds to keep animus object around */
var(Death) const FloatDifficulty SecsToKeepAnimusNorm;
var(Death) export editinline array<export editinline SecsToKeepDeadTaxedType> SecsToKeepDeadTaxedByDamageType;
/** Number of seconds to keep dead bodies around when the max body count is hit or exceeded */
var(Death) const FloatDifficulty SecsToKeepDeadTaxed;
/** Number of seconds to keep animus object around once max body count is hit or exceeded */
var(Death) const FloatDifficulty SecsToKeepAnimusTaxed;
/** Maximum animus clouds allowed in a level.  (If a new cloud is created, the farthest one away from the player will be destroyed. */
var(Death) const int MaxNumAnimusClouds;
/** animus cloud particle system scale minimum */
var(Death) const float AnimusCloudScaleMin;
/** animus cloud particle system scale maximum */
var(Death) const float AnimusCloudScaleMax;
/** life force amount minimum used for scaling animus clouds */
var(Death) const float LifeForceAmountMin;
/** life force amount minimum used for scaling animus clouds Player */
var(Death) const float LifeForceAmountMax;
var(Player) const FloatDifficulty SprintMaterialScalar;
var(Player) const FloatDifficulty BulletEffectFadeTime;
var(Player) const FloatDifficulty SprintFOVAmount;
var(Player) const FloatDifficulty AssaultRifleScopeScaler;
var(Player) const float ScopeViewFadeInTime;
/** triggers */
var(Trigger) const float TriggerDotRange;
/** TMG */
var(TackleMiniGame) const FloatDifficulty Stage1FailTimer;
var(TackleMiniGame) const FloatDifficulty Stage2ChoiceTimer;
var(TackleMiniGame) const FloatDifficulty Stage2FailTimer;
var(TackleMiniGame) const FloatDifficulty KillShotTimeOut;
var(TackleMiniGame) const float Stage1And2ButtonAnimationSpeed;
var(TackleMiniGame) const float Stage2ChoiceButtonAnimationSpeed;
var(TackleMiniGame) const float KillShotAnimationSpeed;
var(TackleMiniGame) const FloatDifficulty Stage1TopThreshold;
var(TackleMiniGame) const FloatDifficulty Stage1TopThresholdValue;
var(TackleMiniGame) const FloatDifficulty Stage1HighRangeThreshold;
var(TackleMiniGame) const FloatDifficulty Stage1LowRangeThreshold;
var(TackleMiniGame) const FloatDifficulty Stage1HighLowRangeThresholdValue;
var(TackleMiniGame) const FloatDifficulty Stage1BottomThreshold;
var(TackleMiniGame) const FloatDifficulty Stage1BottomThresholdValue;
var(TackleMiniGame) const FloatDifficulty Stage2TopThreshold;
var(TackleMiniGame) const FloatDifficulty Stage2TopThresholdValue;
var(TackleMiniGame) const FloatDifficulty Stage2HighRangeThreshold;
var(TackleMiniGame) const FloatDifficulty Stage2LowRangeThreshold;
var(TackleMiniGame) const FloatDifficulty Stage2HighLowRangeThresholdValue;
var(TackleMiniGame) const FloatDifficulty Stage2BottomThreshold;
var(TackleMiniGame) const FloatDifficulty Stage2BottomThresholdValue;
var(TackleMiniGame) const FloatDifficulty PlayerPushAmountStage1;
var(TackleMiniGame) const FloatDifficulty PlayerPushAmountStage2;
var(TackleMiniGame) const FloatDifficulty WerewolfPushAmountStage1;
var(TackleMiniGame) const FloatDifficulty WerewolfPushAmountStage2;
var(TackleMiniGame) const FloatDifficulty WerewolfPushTickStage1;
var(TackleMiniGame) const FloatDifficulty WerewolfPushTickStage2;
var(TackleMiniGame) const float TMGPostProcessingEffect;
var(TackleMiniGame) const float FPSBoost;
var(TackleMiniGame) const float FPSThreshold;
var(Animus) const FloatDifficulty AnimusPackHealth;
var(Animus) const float AnimusPulseDoubleClickTime;
/** Corpse */
var(Corpse) const bool CanDeleteOnscreenCorpses;
var(Corpse) const FloatDifficulty CorpseLifetime;
var(Corpse) const int MaxCorpses;
var(Corpse) const FloatDifficulty PastLifetimeCheckTime;
var(Corpse) const FloatDifficulty CorpseFadeTime;
/** raw impulse to be applied to the item */
var(CarriedItem) const FloatDifficulty ThrowItemImpulse;
/** How long they have to hold the button down before throwing instead of dropping */
var(CarriedItem) const FloatDifficulty ThrowItemTimingThreshold;
/** Adds pitch, in degrees, so 10 means it aims 10degrees more up than the camera */
var(CarriedItem) const FloatDifficulty ThrowItemRotationOffset;
/** max distance you can pick up an item from */
var(CarriedItem) const FloatDifficulty PickupItemMaxDistance;
/** Value between 1 and -1, where 1 means it must be exactly in front of you, and -1 means it can be anywhere */
var(CarriedItem) const FloatDifficulty PickupItemMinFacingAngle;
var(CarriedItem) const name CarrySocket;
var(Player) ScreenShakeScalingTune ADSScreenShakeScales;
var(Player) MeleeImpactShakeDataTune MeleeImpactShake;
var(WeaponHUD) const float SwitchWeaponFadeOutTimer;
var(WeaponHUD) const float NewAmmoPickupFadeOutTimer;
/** how long the user has to press the show radar button in order for it to register */
var(Radar) float ShowSinglePlayerRadarButtonPressDelay;
/** the 2D Texture to use as the radar image icon in single player */
var(Radar) Texture2D SinglePlayerRadarImage;
/** alpha supported color used for the radar arrow.  All values should be between 0 and 1.0 */
var(Radar) LinearColor SinglePlayerRadarColor;
/** non-alph color for the distance text on the radar.  All values should be between 0 and 1.0 */
var(Radar) LinearColor SinglePlayerRadarTextColor;
/** size of the distance text to draw under the radar. */
var(Radar) RadarTargetManagerPersistent.ERadarTargetFontSize SinglePlayerRadarFontSize;
/** the minimum alpha value for the radar in single player */
var(Radar) float SinglePlayerRadarMinimumAlphaValue;
var(MaxDroppedWeapon) int MaxDroppedShotgun;
var(MaxDroppedWeapon) int MaxDroppedSMG;
var(MaxDroppedWeapon) int MaxDroppedAssaultRifle;
var(MaxDroppedWeapon) int MaxDroppedSAW;
var(MaxDroppedWeapon) int MaxDroppedFlamethrower;

function GetScreenShakeScaling(out ScreenShakeScaling outScales)
{
    outScales.LocAmplitudeScale = GetValue(ADSScreenShakeScales.LocAmplitudeScale);
    outScales.LocFrequencyScale = GetValue(ADSScreenShakeScales.LocFrequencyScale);
    outScales.RotAmplitudeScale = GetValue(ADSScreenShakeScales.RotAmplitudeScale);
    outScales.RotFrequencyScale = GetValue(ADSScreenShakeScales.RotFrequencyScale);
    outScales.FOVAmplitudeScale = GetValue(ADSScreenShakeScales.FOVAmplitudeScale);
    outScales.FOVFrequencyScale = GetValue(ADSScreenShakeScales.FOVFrequencyScale);
    //return;    
}

function GetMeleeImpactShakeData(out MeleeImpactShakeData outData)
{
    outData.YawImpactDegrees = GetValue(MeleeImpactShake.YawImpactDegrees);
    outData.PitchImpactDegrees = GetValue(MeleeImpactShake.PitchImpactDegrees);
    outData.impactTime = GetValue(MeleeImpactShake.impactTime);
    outData.RecoveryTime = GetValue(MeleeImpactShake.RecoveryTime);
    outData.ShakeAmpl = GetValue(MeleeImpactShake.ShakeAmpl);
    outData.BiteShakeAmpl = GetValue(MeleeImpactShake.BiteShakeAmpl);
    outData.BiteImpactTime = GetValue(MeleeImpactShake.BiteImpactTime);
    outData.DamageValToOne = GetValue(MeleeImpactShake.DamageValToOne);
    outData.FromBehindImpactScale = GetValue(MeleeImpactShake.FromBehindImpactScale);
    outData.MultiHitReductionScale = GetValue(MeleeImpactShake.MultiHitReductionScale);
    outData.MultiHitTimeTakenToReduce = GetValue(MeleeImpactShake.MultiHitTimeTakenToReduce);
    outData.MultiHitReductionTimeOut = GetValue(MeleeImpactShake.MultiHitReductionTimeOut);
    //return;    
}

function float GetSecsToKeepDeadTaxedByDamageType(class<DamageType> InType)
{
    local int I;
    local float Time;

    I = 0;
    J0x07:

    // End:0x6E [Loop If]
    if(I < SecsToKeepDeadTaxedByDamageType.Length)
    {
        // End:0x64
        if(ClassIsChildOf(InType, SecsToKeepDeadTaxedByDamageType[I].DamageType))
        {
            Time = GetValue(SecsToKeepDeadTaxedByDamageType[I].SecsToKeepDeadTaxed);
            return Time;
        }
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    Time = GetValue(SecsToKeepDeadTaxed);
    return Time;
    //return ReturnValue;    
}

function float GetSecsToKeepDeadNormByDamageType(class<DamageType> InType)
{
    local int I;
    local float Time;

    I = 0;
    J0x07:

    // End:0x6E [Loop If]
    if(I < SecsToKeepDeadNormByDamageType.Length)
    {
        // End:0x64
        if(ClassIsChildOf(InType, SecsToKeepDeadNormByDamageType[I].DamageType))
        {
            Time = GetValue(SecsToKeepDeadNormByDamageType[I].SecsToKeepDeadNorm);
            return Time;
        }
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    Time = GetValue(SecsToKeepDeadNorm);
    return Time;
    //return ReturnValue;    
}
