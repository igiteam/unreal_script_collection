class SPTuneDataFireDrake extends SPTuneDataAI
    native
    editinlinenew;

struct native FDDamageReductionInfo
{
    /** INCLUDES MACROS struct DECLARATIONS */
    var() class<DamageType> DamageType;
    /** range based damage modifiers */
    var() float MaxDistanceFromAttackerNearRangeDamage;
    /** range based damage modifiers */
    var() int NearRangeDamageModifierPercent;
    /** range based damage modifiers */
    var() int FarRangeDamageModifierPercent;

    structdefaultproperties
    {
        DamageType=none
        MaxDistanceFromAttackerNearRangeDamage=0.0000000
        NearRangeDamageModifierPercent=0
        FarRangeDamageModifierPercent=0
    }
};

struct native FDAttackProbability
{
    var() int Spit;
    var() int Immolate;
    var() int Throw;

    structdefaultproperties
    {
        Spit=0
        Immolate=0
        Throw=0
    }
};

struct native FDAIProbability
{
    var() int MinRage;
    var() int MaxRage;
    var() FDAttackProbability Attack;

    structdefaultproperties
    {
        MinRage=0
        MaxRage=0
        Attack=(Spit=0,Immolate=0,Throw=0)
    }
};

/** VARIABLE DECLARATIONS */
var(Rage) const array<FDAIProbability> RageDataParams;
var(Heat) const float VulnerableHeatValue;
var(Heat) const float AttackHeatUpRate;
var(Heat) const float AttackHeatUpTargetValue;
var(Heat) const float AttackCoolDownRate;
var(Heat) const float NormalHeatUpTargetValue;
var(Heat) const float NormalWaterDamageValue;
var(Heat) const float WaterCoolDownTime;
var(Heat) const LinearColor WaterHeatColor;
var(Heat) const LinearColor NormalHeatColor;
var(Heat) const LinearColor AttackHeatColor;
/** damage modifiers based on range */
var(Damage) const array<FDDamageReductionInfo> DamageReductionInfo;
/** damage mods less than this cause bullet reflection  (visual cue only) */
var(Damage) const int MaxDamageModifierAtWhichToReflectBullets;
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
/** Minimum distance we will chase an enemy. */
var(Chase) const float ChaseDistMin;
/** Maximum distance we will chase an enemy. Fear */
var(Chase) const float ChaseDistMax;
/** The fear level at which the FD runs away and hides */
var(Fear) const float RunAwayFearLevel;
/** Ratio of fear incured per unit of damage */
var(Fear) const float FearPerDamageUnit;
/** Amount that FD fear should reduce per second */
var(Fear) const float FearReducePerSec;
/** Maximum amount of fear allowed */
var(Fear) const float FearMaximum;
/** Once a run away decision is made this gets added to */
var(Fear) const float RunAwayFearBase;
/** Amount of time necessary to get a boost of fear once the RunAwayFearLevel threshold has been reached Immolate */
var(Fear) const float FearBoostResetTime;
/** How far an enemy must be to immolate. (discounts collision cylinders) */
var(RingImmolate) const float RingImmolateDistMin;
/** How close an enemy must be to immolate. (discounts collision cylinders) */
var(RingImmolate) const float RingImmolateDistMax;
/** How close we like to be to immolate. (discounts collision cylinders) */
var(RingImmolate) const float RingImmolateDistPreferred;
/** How much damage immolate does to enemies. */
var(RingImmolate) const float RingImmolateDamage;
/** How large the immolate attack radius is. */
var(RingImmolate) const float RingImmolateRadius;
/** How much damage is done during DOT. */
var(RingImmolate) const float RingImmolateDOTDamage;
/** How long dot lasts. */
var(RingImmolate) const float RingImmolateDOTDuration;
/** max time into the immolate attack at which we can still abort */
var(RingImmolate) const float RingImmolateMaxTimeIntoAnimAndStillAbort;
/** impulse strength for the immolate attack */
var(RingImmolate) const float RingImmolateImpulseStrength;
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
var(Spit) const float SpitAccuracyAtMinRange;
var(Spit) const float SpitAccuracyAtMaxRange;
/** Acceleration of the spit particle due to gravity. */
var(Spit) const float SpitGravity;
/** Speed the spit particle travels (along X axis). */
var(Spit) const float SpitSpeed;
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
var(Spit) const int SpitMaxAttacksFromSameLocation;
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
var(Spit) const int SpitMinSpitsBeforeReEvaluatingSituation;
var(Spit) const int SpitMaxSpitsBeforeReEvaluatingSituation;
/** How much damage the spit attack does. */
var(Spit) const float SpitDamageToDestructibles;
/** How much damage the spit attack does. */
var(Spit) const float SpitDamage;
/** How much damage is done during DOT. */
var(Spit) const float SpitDOTDamage;
/** How long dot lasts. */
var(Spit) const float SpitDOTDuration;
var(Spit) const float SpitBelowTargetThreshold;
var(Spit) const float SpitAboveTargetThreshold;
var(Spit) const float SpitBelowTargetMinTrajectoryAdjust;
var(Spit) const float SpitBelowTargetMaxTrajectoryAdjust;
var(Spit) const float SpitAboveTargetMinTrajectoryAdjust;
var(Spit) const float SpitAboveTargetMaxTrajectoryAdjust;
var(Spit) const float SpitLevelTargetMinTrajectoryAdjust;
var(Spit) const float SpitLevelTargetMaxTrajectoryAdjust;
var(Spit) const float SpitTargetVelocityConsiderationPercent;
/** Amount of time that must pass (in secs.) before spitting is allowed againvar(OLDSpit)constfloatSpitAimRange;  The greater the value, the larger the aim offsetvar(OLDSpit)constfloatSpitAimAccuracy;  Value specifies spit accuracy */
var(OLDSpit) const float SpitDelay;
var(Grab) const float GrabObjectPreferredSpaceBetweenObjects;
