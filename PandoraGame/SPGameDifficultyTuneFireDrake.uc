class SPGameDifficultyTuneFireDrake extends SPGameDifficultyTune
    native
    editinlinenew;

struct native FDDifficultyDamageReductionInfo
{
    /** INCLUDES MACROS struct DECLARATIONS */
    var() class<DamageType> DamageType;
    /** range based damage modifiers */
    var() FloatDifficulty MaxDistanceFromAttackerNearRangeDamage;
    /** range based damage modifiers */
    var() FloatDifficulty NearRangeDamageModifierPercent;
    /** range based damage modifiers */
    var() FloatDifficulty FarRangeDamageModifierPercent;

    structdefaultproperties
    {
        DamageType=none
        MaxDistanceFromAttackerNearRangeDamage=(baseValue=0.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        NearRangeDamageModifierPercent=(baseValue=0.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        FarRangeDamageModifierPercent=(baseValue=0.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
    }
};

struct native FDDifficultyAttackProbability
{
    var() FloatDifficulty Spit;
    var() FloatDifficulty Immolate;
    var() FloatDifficulty Throw;

    structdefaultproperties
    {
        Spit=(baseValue=0.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        Immolate=(baseValue=0.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        Throw=(baseValue=0.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
    }
};

struct native FDDifficultyAIProbability
{
    var() FloatDifficulty MinRage;
    var() FloatDifficulty MaxRage;
    var() FDDifficultyAttackProbability Attack;

    structdefaultproperties
    {
        MinRage=(baseValue=0.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        MaxRage=(baseValue=0.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        Attack=(Spit=(baseValue=0.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)))),Immolate=(baseValue=0.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)))),Throw=(baseValue=0.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)))))
    }
};

/** VARIABLE DECLARATIONS */
var(Rage) const array<FDDifficultyAIProbability> RageDataParams;
var(Heat) const FloatDifficulty VulnerableHeatValue;
var(Heat) const float AttackHeatUpRate;
var(Heat) const float AttackHeatUpTargetValue;
var(Heat) const float AttackCoolDownRate;
var(Heat) const float NormalHeatUpTargetValue;
var(Heat) const float NormalWaterDamageValue;
var(Heat) const float WaterCoolDownTime;
var(Heat) const LinearColor WaterHeatColor;
var(Heat) const LinearColor NormalHeatColor;
var(Heat) const LinearColor AttackHeatColor;
var(Light) const float StartingLightBrightness;
var(Light) const float EndingLightBrightness;
var(Light) const Color StartingLightColor;
var(Light) const Color EndingLightColor;
var(Light) const float StartingLightRadius;
var(Light) const float EndingLightRadius;
/** damage modifiers based on range */
var(Damage) const array<FDDifficultyDamageReductionInfo> DamageReductionInfo;
/** damage mods less than this cause bullet reflection  (visual cue only) */
var(Damage) const FloatDifficulty MaxDamageModifierAtWhichToReflectBullets;
var(Death) const float ExplodingDeathUpwardsImpulseStrength;
var(Death) const float ExplodingDeathRadialImpulseStrength;
var(Death) const float ExplodingDeathDamageRadius;
var(Death) const float ExplodingDeathDamageAmount;
/** TODO: Remove this once we have a good set of defaults until then we need a global way to allow it to be turned on / off from the editor and the console */
var(FireDrake) bool bLogTargetingEvents;
var(Roll) const bool RollingDecalNoClip;
var(Roll) const bool bUseAlternateRollDecalTemplate;
/** not really a tuneable thing, just an optimization value Roll */
var(cat) const float MaxCATRange;
var(Roll) const float MinimumDistanceToRoll;
var(Roll) const float MinimumDistanceToRollWhenImmolating;
/** Minimum distance we will chase an enemy. */
var(Roll) const float SwitchToRollBecauseEnemyTooCloseRange;
var(Roll) const float RollingDecalWidth;
var(Roll) const float RollingDecalHeight;
var(Roll) const float RollingDecalThickness;
var(Roll) const float DistanceBetweenDecals;
/** how fast the ball turns */
var(Roll) const float YawRotationRateInRadians;
/** radius used to compute rotational velocity */
var(Roll) const float RadiusOfRotation;
/** how long the decal trail lasts */
var(Roll) const float DecalTrailLifeSpan;
var(Roll) const float DistanceBetweenParticles;
/** How far an enemy must be to immolate. (discounts collision cylinders) */
var(RingImmolate) const float RingImmolateDistMin;
/** How close an enemy must be to immolate. (discounts collision cylinders) */
var(RingImmolate) const float RingImmolateDistMax;
/** How close we like to be to immolate. (discounts collision cylinders) */
var(RingImmolate) const float RingImmolateDistPreferred;
/** How much damage immolate does to enemies. */
var(RingImmolate) const FloatDifficulty RingImmolateDamage;
/** How large the immolate attack radius is.var(RingImmolate)constFloatDifficultyRingImmolateDOTDamage;How much damage is done during DOT.var(RingImmolate)constFloatDifficultyRingImmolateDOTDuration;How long dot lasts. */
var(RingImmolate) const FloatDifficulty RingImmolateRadius;
/** max time into the immolate attack at which we can still abort */
var(RingImmolate) const float RingImmolateMaxTimeIntoAnimAndStillAbort;
/** impulse strength for the immolate attack */
var(RingImmolate) const float RingImmolateImpulseStrength;
/** how fast the immolate pulse expands */
var(RingImmolate) const float RingImmolateExpansionRate;
/** scale of the fires created via the fire manager */
var(RingImmolate) const float RingImmolateFireScale;
/** duration of the fires created via the fire manager */
var(RingImmolate) const float RingImmolateFireBurnTime;
/** damage of the fires created via the fire manager */
var(RingImmolate) const FloatDifficulty RingImmolateFireDamageVsPlayer;
/** damage of the fires created via the fire manager */
var(RingImmolate) const FloatDifficulty RingImmolateFireDamageVsPawn;
/** damage of the fires created via the fire manager */
var(RingImmolate) const FloatDifficulty RingImmolateFireDamageVsDestructible;
/** maximum velocity to knock the player back from a ring immolate (scaled by distance to the firedrake) */
var(RingImmolate) const float RingImmolateMaxPlayerKnockVelocity;
var(RingImmolate) const float RingImmolateFacingToleranceCosine;
var(DirectedImmolate) const Vector DirectedImmolateParticleScale;
var(Immolate) const float ImmolateMaxTimeIntoAnimAndStillAbort;
var(Immolate) const float ImmolateMaxTimeToMove;
/** How far an enemy must be to spit fire. */
var(Spit) const float SpitDistMin;
/** How close an enemy must be to spit fire. */
var(Spit) const float SpitDistMax;
/** The max distance above the target we can be and spit (should be negative) */
var(Spit) const float SpitAttackHeightMax;
/** The max distance below the target we can be and spit (should be negative) */
var(Spit) const float SpitAttackHeightMin;
/** cosine of the max angle we can be off from facing our target and still spit */
var(Spit) const float SpitFacingToleranceCosine;
/** accuracy measured in distance values */
var(Spit) const FloatDifficulty SpitAccuracyAtMinRange;
var(Spit) const FloatDifficulty SpitAccuracyAtMaxRange;
/** Acceleration of the spit particle due to gravity. */
var(Spit) const FloatDifficulty SpitGravity;
/** weight given to places that have full LOS to the target */
var(Spit) const float SpitFullLOSWeight;
/** weight given to places that have partial to the target */
var(Spit) const float SpitPartialLOSWeight;
/** weight given to distance in evaluating a place to attack from */
var(Spit) const float SpitDistanceWeight;
/** weight given to sidedness in evaluating a place to attack from */
var(Spit) const float SpitSidednessWeight;
/** minimum preferred distance to attack from */
var(Spit) const float SpitMinPreferredDistance;
/** maximum preferred distance to attack from */
var(Spit) const float SpitMaxPreferredDistance;
/** minimum distance to keep from hostiles when doing spit attack */
var(Spit) const float SpitMinSafeDistanceToHostiles;
/** minimum passable rating value for finding a place to spit from */
var(Spit) const float SpitMinimumRatingValue;
/** minimum preferred rating value for finding a place to spit from */
var(Spit) const float SpitPreferredRatingValue;
/** maximum number of attacks before we will change locations */
var(Spit) const FloatDifficulty SpitMaxAttacksFromSameLocation;
/** will react to suppression up to this much time ago */
var(Spit) const float SpitMaxSuppressionHistoryTime;
/** weight given to distance to the firedrake in evaluating a place to attack from */
var(Spit) const float SpitDistanceToMeWeight;
/** the minimum distance we want to move when looking for a new place to spit (places closer arent excluded, just not biased) */
var(Spit) const float SpitMinMoveAmount;
/** the maximum distance we want to move when looking for a new place to spit (places farther arent excluded, just not biased) */
var(Spit) const float SpitMaxMoveAmount;
/** the preferred distance we want to move when looking for a new place to spit */
var(Spit) const float SpitPreferredMoveAmount;
/** up to this amount of time into a spit animation we can still abort it */
var(Spit) const float SpitMaxTimeIntoSpitAnimAndStillAbort;
/** while in a spit animation if the target gets this close we will try and abort */
var(Spit) const float SpitTargetTooCloseDistanceSoIShouldAbortAnimation;
/** fd will consider converting a spit to an immolate only if they are first at least this far away */
var(Spit) const float SpitToImmolateRange;
var(Spit) const FloatDifficulty SpitMinSpitsBeforeReEvaluatingSituation;
var(Spit) const FloatDifficulty SpitMaxSpitsBeforeReEvaluatingSituation;
/** How much damage the spit attack does. */
var(Spit) const float SpitDamageToDestructibles;
/** How much damage the spit attack does. */
var(Spit) const FloatDifficulty SpitDamage;
/** How much damage is done during DOT. */
var(Spit) const FloatDifficulty SpitDOTDamage;
/** How long dot lasts. */
var(Spit) const FloatDifficulty SpitDOTDuration;
var(Spit) const float SpitBelowTargetThreshold;
var(Spit) const float SpitAboveTargetThreshold;
var(Spit) const float SpitBelowTargetMinTrajectoryAdjust;
var(Spit) const float SpitBelowTargetMaxTrajectoryAdjust;
var(Spit) const float SpitAboveTargetMinTrajectoryAdjust;
var(Spit) const float SpitAboveTargetMaxTrajectoryAdjust;
var(Spit) const float SpitLevelTargetMinTrajectoryAdjust;
var(Spit) const float SpitLevelTargetMaxTrajectoryAdjust;
var(Spit) const FloatDifficulty SpitTargetVelocityConsiderationPercent;
/** the amount of time they remain dormant after being hit with the pulse */
var(AnimusPulse) const float AnimuPulseSleepTime;
/** the amount of time they stay heated (vulnerable) after being hit with the pulse */
var(AnimusPulse) const FloatDifficulty AnimuPulseVulnerableTime;
/** Roughly how fast they get launched when hit with a pulse (this value gets scaled internally by distance from the pulse */
var(AnimusPulse) const float AnimuPulseMaxLaunchSpeed;
/** The amount of Pitch to add to their launch direction in Rotator units (0 means no arc, 16384 adds 90 degrees) */
var(AnimusPulse) const int AnimuPulseExtraLaunchRotatorPitch;
/** How much vertical velocity they lose each time they bounce */
var(AnimusPulse) const int PercentVerticalEnergyLossOnBounce;
/** How much horizontal velocity they lose each time they bounce */
var(AnimusPulse) const int PercentHorizontalEnergyLossOnBounce;
