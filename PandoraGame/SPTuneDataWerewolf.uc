class SPTuneDataWerewolf extends SPTuneDataAI
    native
    editinlinenew;

struct native WWAttackProbability
{
    /** INCLUDES MACROS struct DECLARATIONS VARIABLE DECLARATIONS What health levels bring us to next rage level. */
    var() int ThrowObject;
    /** INCLUDES MACROS struct DECLARATIONS VARIABLE DECLARATIONS What health levels bring us to next rage level. */
    var() int HitAndRun;
    /** INCLUDES MACROS struct DECLARATIONS VARIABLE DECLARATIONS What health levels bring us to next rage level. */
    var() int Melee;

    structdefaultproperties
    {
        ThrowObject=0
        HitAndRun=0
        Melee=0
    }
};

struct native WWMeleeAttackProbability
{
    var() int BiteAttack;
    var() int SwipeAttack;
    var() int BullCharge;

    structdefaultproperties
    {
        BiteAttack=20
        SwipeAttack=80
        BullCharge=100
    }
};

struct native WWAIProbability
{
    var() int MinRage;
    var() int MaxRage;
    /** Defines the PNode rage association value for this rage state */
    var() int PNodeRageID;
    /** Defines the PNode rage association value for this rage state */
    var() WWAttackProbability Attack;
    /** Defines the PNode rage association value for this rage state */
    var() WWMeleeAttackProbability MeleeAttack;

    structdefaultproperties
    {
        MinRage=0
        MaxRage=0
        PNodeRageID=0
        Attack=(ThrowObject=0,HitAndRun=0,Melee=0)
        MeleeAttack=(BiteAttack=20,SwipeAttack=80,BullCharge=100)
    }
};

struct native WWMovementEntry
{
    var() name MovementName;
    var() float MovementSpeed;

    structdefaultproperties
    {
        MovementName="None"
        MovementSpeed=0.0000000
    }
};

struct native WWImpactParams
{
    var() const ScreenShakeStruct ShakeParams;
    var() const float ShakeRadius;
    var() const float ImpulseAmount;
    var() const float ImpulseRadius;
    var() const float ImpulseZOffset;

    structdefaultproperties
    {
        ShakeParams=(TimeToGo=0.0000000,TimeDuration=1.0000000,RotAmplitude=(X=100.0000000,Y=100.0000000,Z=250.0000000),RotFrequency=(X=10.0000000,Y=10.0000000,Z=25.0000000),RotSinOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000),RotParam=(X=ESP_OffsetRandom,Y=ESP_OffsetRandom,Z=ESP_OffsetRandom,Padding=0),LocAmplitude=(X=0.0000000,Y=30.0000000,Z=50.0000000),LocFrequency=(X=1.0000000,Y=10.0000000,Z=20.0000000),LocSinOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000),LocParam=(X=ESP_OffsetRandom,Y=ESP_OffsetRandom,Z=ESP_OffsetRandom,Padding=0),FOVAmplitude=0.0000000,FOVFrequency=0.0000000,FOVSinOffset=0.0000000,FOVParam=ESP_OffsetRandom,OnStopBlendOutTime=1.0000000,Id="None")
        ShakeRadius=5000.0000000
        ImpulseAmount=0.0000000
        ImpulseRadius=0.0000000
        ImpulseZOffset=0.0000000
    }
};

/** VARIABLE DECLARATIONS Footstep effects */
var(FootStep) const WWImpactParams LowFootstepEffects;
var(FootStep) const WWImpactParams MediumFootstepEffects;
var(FootStep) const WWImpactParams HighFootstepEffects;
var(Rage) const array<WWAIProbability> RageDataParams;
var(Rage) int dropClubAtRageIndex;
var(Rage) int goQuadrapedRageIndex;
var(KnockBack) const array<DamageTypeConditionMatch> KnockBackPerformanceParams;
/** TODO: Remove this once we have a good set of defaults until then we need a global way to allow it to be turned on / off from the editor and the console */
var(Werewolf) bool bLogTargetingEvents;
/** Radius at which we automatically know a target is there (smell them) */
var(Targeting) float ScentScanRadius;
/** Weight value applied to actual path distance */
var(Targeting) float PathWeight;
/** Weight added to closest pawn's targeting score */
var(Targeting) float PathClosestBaseWeight;
/** Weight value applied to each hitpoint of damage sustained */
var(Targeting) float DamageWeight;
/** Player's are on a different scale when it comes to damage weight */
var(Targeting) float DamageWeightPlayer;
/** Anything below this many hit points is considered wounded */
var(Targeting) float HealthLevelWounded;
/** Anything below this many hit points is considered almost dead */
var(Targeting) float HealthLevelAlmostDead;
/** Weight value associated with full health */
var(Targeting) float FullHealthWeight;
/** Weight value associated with wounded health */
var(Targeting) float WoundedHealthWeight;
/** Weight value associated with almost dead health */
var(Targeting) float AlmostDeadHealthWeight;
/** Additional weighting applied to hostile targets (should be high, like 999999) */
var(Targeting) float HostileTargetWeight;
/** Number of seconds to wait prior to repopulating the target list */
var(Targeting) float TargetListRepopulateTime;
/** Number of seconds to wait before removing an entry for the targeting list */
var(Targeting) float TargetTableRecordTimeout;
/** Distance at which target sound weight should be clamped */
var(Targeting) float SoundClampDist;
/** Weight value applied to the loudness of a sound heard from a pawn */
var(Targeting) float SoundVolWeight;
/** Amount by which damage sustained decays per second */
var(Targeting) float DamageDecayAmt;
/** Number of seconds to wait prior to evaluating a single target (to save CPU) */
var(Targeting) float TargetEvalDelay;
/** Number of seconds to wait prior to evaluating the path distance to each target (to save CPU) */
var(Targeting) float TargetPathDistanceEvalDelay;
/** Weighting applied to enemy (usually negative) if a path could not be made to the enemy */
var(Targeting) float PathFailedWeight;
/** X^Exp power is used to determine the appropriate added weight to apply to a player's score */
var(Targeting) float PlayerDistRampExponent;
/** Radius that the player must be within in order to apply the ramp coefficient added weight */
var(Targeting) float PlayerDistForRamp;
/** Override distance at which any players outside of are ignored for a given timeframe */
var(Targeting) float fIgnoreDist;
/** Number of seconds to wait after a player is known to have gone out of range before again considering him as a target */
var(Targeting) float fIgnoreTimeout;
/** Number of seconds to wait after a player has regained ignoreable status before he can be ignored by the system again */
var(Targeting) float fIgnoreReturnTimeout;
/** Weight added to pawns inside of our defend arae */
var(Targeting) float TargetInDefendAreaWeight;
/** If our current target was inside the defend area, but leaves, he is considered to still be in our defend area for this period of time END Targeting Defaults */
var(Targeting) float CurrentTargetWasInDefendAreaTimeOut;
var(Attack) const float MinHitAndRunStartDist;
var(Attack) const float AttackTooCloseDistance;
var(Attack) const float AttackNearDistance;
var(Attack) const float AttackMediumDistance;
var(Attack) const float MinSquadMembersForHitAndRun;
var(Attack) const float PreventCloseTheGapPercentage;
var(Attack) const float CATAnimationChancePercentage;
var(Resurrection) const float DisabledTime;
var(Resurrection) const float HeadHealthPercent;
var(Resurrection) const float RecoveryRate;
var(Regeneration) const float ArmDisabledTime;
var(Regeneration) const int GroundHeadHealth;
/** Player must shoot from within this distance for head health */
var(Regeneration) const float GroundHeadDist;
/** We look at the enemy if within this distance. */
var(Food) const float LookAtDist;
/** Extra distance required to turn look at on and off. */
var(Food) const float LookAtHysteresis;
/** How far food can be and have us consider it. */
var(Food) const float MaxFoodDist;
/** What is the total path cost we will use when going for food. Damage defaults */
var(Food) const float MaxFoodPathDist;
var(Damage) const float BiteDamage;
var(Damage) const float CloseGapDamage;
var(Damage) const float HitAndRunDamage;
var(Damage) const float MaulDamage;
var(Damage) const float MiniGameDamage;
var(Damage) const float PlayerMaulDamage;
var(Damage) const float SlamDamage;
var(Damage) const float SmashDamage;
var(Damage) const float SuperDamage;
var(Damage) const float SwipeDamage;
/** Multiplier indicating how much to scale damage versus non-player pawns END Damage Defaults */
var(Damage) const float NonPlayerDamageMultiplier;
/** max time that can elapse between shots before damage counter gets reset */
var(WallMovement) const float MaxDamageIntervalForWallFallOff;
/** amount of damage needed to knock werewolf off of wall Concentrated Hit Reactions Defaults */
var(WallMovement) const float MaxDamageThresholdForWallFallOff;
/** damage needed to induce a concentrated arm damage reaction */
var(ConcentratedHitReaction) float RequiredConcentratedArmDamage;
/** elapsed time at which the concentrated damage counter resets */
var(ConcentratedHitReaction) float ArmDamageTimeOutInterval;
/** damage needed to induce a concentrated head damage reaction */
var(ConcentratedHitReaction) float RequiredConcentratedHeadDamage;
/** elapsed time at which the concentrated damage counter resets */
var(ConcentratedHitReaction) float HeadDamageTimeOutInterval;
/** damage needed to induce a concentrated torso damage reaction */
var(ConcentratedHitReaction) float RequiredConcentratedTorsoDamage;
/** elapsed time at which the concentrated damage counter resets */
var(ConcentratedHitReaction) float TorsoDamageTimeOutInterval;
/** elapsed time at which the concentrated damage counter resets when induced by machine gun fire */
var(ConcentratedHitReaction) float TorsoDamageMMGTimeOutInterval;
/** minimum amount of time that has to elapse between concentrated hit reactions of the same type */
var(ConcentratedHitReaction) float ArmDamageMinTimeToReset;
/** maximum amount of time that has to elapse between concentrated hit reactions of the same type */
var(ConcentratedHitReaction) float ArmDamageMaxTimeToReset;
/** minimum amount of time that has to elapse between concentrated hit reactions of the same type */
var(ConcentratedHitReaction) float HeadDamageMinTimeToReset;
/** maximum amount of time that has to elapse between concentrated hit reactions of the same type */
var(ConcentratedHitReaction) float HeadDamageMaxTimeToReset;
/** minimum amount of time that has to elapse between concentrated hit reactions of the same type */
var(ConcentratedHitReaction) float TorsoDamageMinTimeToReset;
/** maximum amount of time that has to elapse between concentrated hit reactions of the same type */
var(ConcentratedHitReaction) float TorsoDamageMaxTimeToReset;
/** minimum amount of time that has to elapse between concentrated hit reactions of the same type when induced by machine gun fire */
var(ConcentratedHitReaction) float TorsoDamageMaxMMGMinTimeToReset;
/** maximum amount of time that has to elapse between concentrated hit reactions of the same type when induced by machine gun fire */
var(ConcentratedHitReaction) float TorsoDamageMaxMMGMaxTimeToReset;
/** amount of time to cause the werewolf to stagger due to machine fun fire to the chest */
var(ConcentratedHitReaction) float TorsoDamageMMGStaggerTimePerShot;
/** maximum amount of time that mmg fire to the chest will cause the werewolf to stagger */
var(ConcentratedHitReaction) float TorsoDamageMaxMMGLoopTime;
/** maximum amount of time that mmg fire to the chest will cause the werewolf to stagger */
var(ConcentratedHitReaction) float RequiredConcentratedBackDamage;
var(ConcentratedHitReaction) float BackDamageTimeOutInterval;
var(ConcentratedHitReaction) float BackDamageMinTimeToReset;
var(ConcentratedHitReaction) float BackDamageMaxTimeToReset;
var(PhysAnimArmDamage) array<name> RightArmBreakBoneNames;
var(PhysAnimArmDamage) array<name> RightArmBreakMotorNames;
var(PhysAnimArmDamage) array<name> RightArmBreakLinearBoneSprings;
var(PhysAnimArmDamage) array<name> RightArmBreakAngularBoneSprings;
var(PhysAnimArmDamage) array<name> LeftArmBreakBoneNames;
var(PhysAnimArmDamage) array<name> LeftArmBreakMotorNames;
var(PhysAnimArmDamage) array<name> LeftArmBreakLinearBoneSprings;
var(PhysAnimArmDamage) array<name> LeftArmBreakAngularBoneSprings;
var(PhysAnimArmDamage) SPTwoStageBlendTarget ArmBreakSpringScaleBlendValues;
var(PhysAnimArmDamage) SPTwoStageBlendTarget ArmBreakDampingScaleBlendValues;
var(PhysAnimArmDamage) SPTwoStageBlendTarget ArmBreakLinearBoneSpringBlendValues;
var(PhysAnimArmDamage) SPTwoStageBlendTarget ArmBreakAngularBoneSpringBlendValues;
var(PhysAnimArmDamage) SPTwoStageBlendTarget ArmBreakPhysicsWeightBlendValues;
var(PhysAnimArmDamage) SPTwoStageBlendTarget ArmHealPhysicsWeightBlendValues;
/** End Concentrated Hit Reactions Defaults */
var(MinotaurTakeDamageMultiplier) float minotaurFrontDamageMultiplier;
var(MinotaurTakeDamageMultiplier) float minotaurBackDamageMultiplier;
var(MinotaurCharge) float minotaurChargeMinDist;
var(MinotaurCharge) float minotaurChargeMaxDist;
var(MinotaurCharge) float minotaurChargeMinDodgeTime;
var(MinotaurCharge) float minotaurChargeMaxDodgeTime;
var(MinotaurCharge) float minotaurChargeDamageDone;
var(MinotaurCharge) float minotaurChargePlayerPushBackSpeed;
var(MinotaurCharge) float minotaurChargeDistanceToMoveAfterMiss;
var(MinotaurCharge) WWImpactParams minotaurChargeHitEffect;
var(Movement) array<WWMovementEntry> MovementStyles;
