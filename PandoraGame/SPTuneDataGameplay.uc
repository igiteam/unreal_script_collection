class SPTuneDataGameplay extends Object
    native
    editinlinenew;

struct native PlayerDamagedByData
{
    /** INCLUDES MACROS struct DECLARATIONS */
    var() const float DBS_Ump_Primary;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() const float DBS_Ump_Secondary;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() const float DBS_SPAssaultRifle_Primary;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() const float DBS_SPAssaultRifle_Secondary;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() const float DBS_Shotgun_Primary;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() const float DBS_Shotgun_Secondary;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() const float DBS_FireAxe_Primary;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() const float DBS_FireAxe_Secondary;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() const float DBS_Saw_Primary;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() const float DBS_Saw_Secondary;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() const float DBS_Flamethrower_Primary;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() const float DBS_Flamethrower_Secondary;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() const float DBS_Rocketlauncher_Sole;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() const float DBS_Minigun_Sole;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() const float DBS_NineMM_Primary;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() const float DBS_NineMM_Secondary;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() const float DBS_DesertEagle_Primary;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() const float DBS_DesertEagle_Secondary;

    structdefaultproperties
    {
        DBS_Ump_Primary=1.0000000
        DBS_Ump_Secondary=1.0000000
        DBS_SPAssaultRifle_Primary=0.7000000
        DBS_SPAssaultRifle_Secondary=1.0000000
        DBS_Shotgun_Primary=1.0000000
        DBS_Shotgun_Secondary=1.0000000
        DBS_FireAxe_Primary=1.0000000
        DBS_FireAxe_Secondary=1.0000000
        DBS_Saw_Primary=1.0000000
        DBS_Saw_Secondary=1.0000000
        DBS_Flamethrower_Primary=1.0000000
        DBS_Flamethrower_Secondary=1.0000000
        DBS_Rocketlauncher_Sole=1.0000000
        DBS_Minigun_Sole=1.0000000
        DBS_NineMM_Primary=1.0000000
        DBS_NineMM_Secondary=1.0000000
        DBS_DesertEagle_Primary=1.0000000
        DBS_DesertEagle_Secondary=1.0000000
    }
};

struct native DamageRegionConditionMatch
{
    /** Any damage that occurs on the pawn where the distance between the pawn and the point of damage impact is less than this value will be matched to this condition value for the DeathDamageLevelEvaluator */
    var() const float Distance;
    /** Any damage that occurs on the pawn where the distance between the pawn and the point of damage impact is less than this value will be matched to this condition value for the DeathDamageLevelEvaluator */
    var() const int Condition;

    structdefaultproperties
    {
        Distance=0.0000000
        Condition=0
    }
};

struct native DamageTypeConditionMatch
{
    /** This condition is used when no damage region is defined */
    var() int Condition;
    /** This condition is used when no damage region is defined */
    var() class<DamageType> DamageTypeClass;
    /** If the pawn to damage impact distance is greater than the distance values in all the defined damage regions then the above Condition (used for no damage region) is used. */
    var() array<DamageRegionConditionMatch> DamageRegions;

    structdefaultproperties
    {
        Condition=0
        DamageTypeClass=none
        DamageRegions=none
    }
};

/** How long food lasts for after being eaten. */
var(Food) const float FoodLifetime;
/** Just change this to run the validation routine./ Death */
var(Common) const bool changeToValidate;
/** Corpse */
var(Corpse) const bool CanDeleteOnscreenCorpses;
/** Maximum number of dead bodies to keep in the world before  forcibly removing creatures */
var(Death) const int MaxNumDeadBodies;
/** Number of seconds to keep dead bodies around before fade out */
var(Death) const float SecsToKeepDeadNorm;
/** Number of seconds to keep animus object around */
var(Death) const float SecsToKeepAnimusNorm;
/** Number of seconds to keep dead bodies around when the max body count is hit or exceeded */
var(Death) const float SecsToKeepDeadTaxed;
/** Number of seconds to keep animus object around once max body count is hit or exceeded */
var(Death) const float SecsToKeepAnimusTaxed;
/** Maximum animus clouds allowed in a level.  (If a new cloud is created, the farthest one away from the player will be destroyed. Player */
var(Death) const int MaxNumAnimusClouds;
var(Player) const float SprintRampDownTime;
var(Player) const float SprintMaterialScalar;
var(Player) const float SprintBurstSpeed;
var(Player) const float BulletEffectFadeTime;
var(Player) const float SprintFOVAmount;
var(Player) const float AssaultRifleScopeScaler;
/** TMG */
var(TackleMiniGame) const float Stage1FailTimer;
var(TackleMiniGame) const float Stage2ChoiceTimer;
var(TackleMiniGame) const float Stage2FailTimer;
var(TackleMiniGame) const float KillShotTimeOut;
var(TackleMiniGame) const float Stage1And2ButtonAnimationSpeed;
var(TackleMiniGame) const float Stage2ChoiceButtonAnimationSpeed;
var(TackleMiniGame) const float KillShotAnimationSpeed;
var(TackleMiniGame) const float Stage1TopThreshold;
var(TackleMiniGame) const float Stage1TopThresholdValue;
var(TackleMiniGame) const float Stage1HighRangeThreshold;
var(TackleMiniGame) const float Stage1LowRangeThreshold;
var(TackleMiniGame) const float Stage1HighLowRangeThresholdValue;
var(TackleMiniGame) const float Stage1BottomThreshold;
var(TackleMiniGame) const float Stage1BottomThresholdValue;
var(TackleMiniGame) const float Stage2TopThreshold;
var(TackleMiniGame) const float Stage2TopThresholdValue;
var(TackleMiniGame) const float Stage2HighRangeThreshold;
var(TackleMiniGame) const float Stage2LowRangeThreshold;
var(TackleMiniGame) const float Stage2HighLowRangeThresholdValue;
var(TackleMiniGame) const float Stage2BottomThreshold;
var(TackleMiniGame) const float Stage2BottomThresholdValue;
var(TackleMiniGame) const float PlayerPushAmountStage1;
var(TackleMiniGame) const float PlayerPushAmountStage2;
var(TackleMiniGame) const float WerewolfPushAmountStage1;
var(TackleMiniGame) const float WerewolfPushAmountStage2;
var(TackleMiniGame) const float WerewolfPushTickStage1;
var(TackleMiniGame) const float WerewolfPushTickStage2;
var(TackleMiniGame) const float TMGPostProcessingEffect;
var(Animus) const float AnimusPackHealth;
var(Corpse) const float CorpseLifetime;
var(Corpse) const int MaxCorpses;
var(Corpse) const float PastLifetimeCheckTime;
var(Corpse) const float CorpseFadeTime;
/** raw impulse to be applied to the item */
var(CarriedItem) const float ThrowItemImpulse;
/** How long they have to hold the button down before throwing instead of dropping */
var(CarriedItem) const float ThrowItemTimingThreshold;
/** Adds pitch, in degrees, so 10 means it aims 10degrees more up than the camera */
var(CarriedItem) const float ThrowItemRotationOffset;
/** max distance you can pick up an item from */
var(CarriedItem) const float PickupItemMaxDistance;
/** Value between 1 and -1, where 1 means it must be exactly in front of you, and -1 means it can be anywhere */
var(CarriedItem) const float PickupItemMinFacingAngle;
var(CarriedItem) const name CarrySocket;
