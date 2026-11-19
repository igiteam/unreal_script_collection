class SPGameDifficultyTuneWerewolf extends SPGameDifficultyTune
    native
    editinlinenew;

struct native WWDifficultyAttackProbability
{
    /** INCLUDES MACROS struct DECLARATIONS */
    var() FloatDifficulty ThrowObject;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() FloatDifficulty HitAndRun;
    /** INCLUDES MACROS struct DECLARATIONS */
    var() FloatDifficulty Melee;

    structdefaultproperties
    {
        ThrowObject=(baseValue=0.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        HitAndRun=(baseValue=0.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        Melee=(baseValue=0.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
    }
};

struct native WWDifficultyMeleeAttackProbability
{
    var() FloatDifficulty BiteAttack;
    var() FloatDifficulty SwipeAttack;
    var() FloatDifficulty BullCharge;

    structdefaultproperties
    {
        BiteAttack=(baseValue=0.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        SwipeAttack=(baseValue=0.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        BullCharge=(baseValue=0.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
    }
};

struct native WWDifficultyAIProbability
{
    var() FloatDifficulty MinRage;
    var() FloatDifficulty MaxRage;
    /** //var () int PNodeRageID;		// Defines the PNode rage association value for this rage state */
    var() WWDifficultyAttackProbability Attack;
    /** //var () int PNodeRageID;		// Defines the PNode rage association value for this rage state */
    var() WWDifficultyMeleeAttackProbability MeleeAttack;

    structdefaultproperties
    {
        MinRage=(baseValue=0.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        MaxRage=(baseValue=0.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        Attack=(ThrowObject=(baseValue=0.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)))),HitAndRun=(baseValue=0.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)))),Melee=(baseValue=0.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)))))
        MeleeAttack=(BiteAttack=(baseValue=0.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)))),SwipeAttack=(baseValue=0.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)))),BullCharge=(baseValue=0.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)))))
    }
};

struct native WWDifficultyMovementEntry
{
    var() name MovementName;
    var() FloatDifficulty MovementSpeed;

    structdefaultproperties
    {
        MovementName="None"
        MovementSpeed=(baseValue=0.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
    }
};

struct native ArmBreakEntry
{
    /** damage type that will induce this reaction */
    var() class<PandoraDamageType> DamageTypeClass;
    /** amount of damage needed by this weapon type to induce the reaction */
    var() FloatDifficulty DamageThreshold;
    /** elapsed time at which the concentrated damage counter resets */
    var() FloatDifficulty MaxContinuedDamageInterval;

    structdefaultproperties
    {
        DamageTypeClass=none
        DamageThreshold=(baseValue=40.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        MaxContinuedDamageInterval=(baseValue=2.5000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
    }
};

struct native StaggerBackEntry
{
    /** damage type that will induce this reaction */
    var() class<PandoraDamageType> DamageTypeClass;
    /** amount of damage needed by this weapon type to induce the reaction */
    var() FloatDifficulty DamageThreshold;
    /** amount of time to stagger when inflicted by this damage */
    var() FloatDifficulty StaggerTimePerShot;
    /** max amount of time this weapon can continually stagger us */
    var() FloatDifficulty MaxStaggerTime;
    /** elapsed time at which the concentrated damage counter resets */
    var() FloatDifficulty MaxContinuedDamageInterval;
    /** the condition index to use on the KnockBackEvaluator */
    var() int EvaluatorCondition;
    /** allows head damage to induce staggering provided there is no head damage entry */
    var() bool bCanBeInducedByHeadDamage;
    /** allows upper leg damage to induce staggering provided there is no head damage entry */
    var() bool bCanBeInducedByUpperLegDamage;
    /** allows upper arm damage to induce staggering EVEN IF THERE IS AN ARM DAMAGE ENTRY */
    var() bool bForceInduceByUpperArmDamage;

    structdefaultproperties
    {
        DamageTypeClass=none
        DamageThreshold=(baseValue=40.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        StaggerTimePerShot=(baseValue=0.7500000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        MaxStaggerTime=(baseValue=1.5000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        MaxContinuedDamageInterval=(baseValue=2.5000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        EvaluatorCondition=-1
        bCanBeInducedByHeadDamage=true
        bCanBeInducedByUpperLegDamage=false
        bForceInduceByUpperArmDamage=true
    }
};

struct native KnockBackEntry
{
    /** damage type that will induce this reaction */
    var() class<PandoraDamageType> DamageTypeClass;
    /** amount of damage needed by this weapon type to induce the reaction */
    var() FloatDifficulty DamageThreshold;
    /** elapsed time at which the concentrated damage counter resets */
    var() FloatDifficulty MaxContinuedDamageInterval;
    /** the condition index to use on the KnockBackEvaluator */
    var() int EvaluatorCondition;
    /** allows head damage to induce knockback provided there is no head damage entry */
    var() bool bCanBeInducedByHeadDamage;
    /** allows upper leg damage to induce knockback provided there is no head damage entry */
    var() bool bCanBeInducedByUpperLegDamage;
    /** allows upper arm damage to induce knockback EVEN IF THERE IS AN ARM DAMAGE ENTRY */
    var() bool bForceInduceByUpperArmDamage;

    structdefaultproperties
    {
        DamageTypeClass=none
        DamageThreshold=(baseValue=40.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        MaxContinuedDamageInterval=(baseValue=2.5000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        EvaluatorCondition=-1
        bCanBeInducedByHeadDamage=true
        bCanBeInducedByUpperLegDamage=false
        bForceInduceByUpperArmDamage=true
    }
};

struct native HeadDamageEntry
{
    /** damage type that will induce this reaction */
    var() class<PandoraDamageType> DamageTypeClass;
    /** amount of damage needed by this weapon type to induce the reaction */
    var() FloatDifficulty DamageThreshold;
    /** elapsed time at which the concentrated damage counter resets */
    var() FloatDifficulty MaxContinuedDamageInterval;
    /** allows upper arm damage to induce staggering EVEN IF THERE IS AN ARM DAMAGE ENTRY */
    var() bool bForceInduceByUpperArmDamage;
    /** allows lower arm damage to induce staggering EVEN IF THERE IS AN ARM DAMAGE ENTRY */
    var() bool bForceInduceByLowerArmDamage;

    structdefaultproperties
    {
        DamageTypeClass=none
        DamageThreshold=(baseValue=20.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        MaxContinuedDamageInterval=(baseValue=2.5000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        bForceInduceByUpperArmDamage=false
        bForceInduceByLowerArmDamage=false
    }
};

/** VARIABLE DECLARATIONS Footstep effects */
var(FootStep) const WWImpactParams LowFootstepEffects;
var(FootStep) const WWImpactParams MediumFootstepEffects;
var(FootStep) const WWImpactParams HighFootstepEffects;
var(Rage) const array<WWDifficultyAIProbability> RageDataParams;
var(Rage) FloatDifficulty dropClubAtRageIndex;
var(Rage) FloatDifficulty goQuadrapedRageIndex;
/** TODO: Remove this once we have a good set of defaults until then we need a global way to allow it to be turned on / off from the editor and the console */
var(Werewolf) bool bLogTargetingEvents;
var(Roaming) bool bAllowRoamingWhenNoValidTargets;
/** Radius at which we automatically know a target is there (smell them) */
var(Targeting) FloatDifficulty ScentScanRadius;
/** Weight value applied to actual path distance */
var(Targeting) float PathWeight;
/** Weight added to closest pawn's targeting score */
var(Targeting) float PathClosestBaseWeight;
/** Weight value applied to each hitpoint of damage sustained */
var(Targeting) float DamageWeight;
/** Player's are on a different scale when it comes to damage weight */
var(Targeting) FloatDifficulty DamageWeightPlayer;
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
/** Weighting applied to enemy (usually negative) if a path could not be made to the enemyvar(Targeting) float PlayerDistRampExponent; X^Exp power is used to determine the appropriate added weight to apply to a player's scorevar(Targeting) float PlayerDistForRamp; Radius that the player must be within in order to apply the ramp coefficient added weight */
var(Targeting) float PathFailedWeight;
/** Override distance at which any players outside of are ignored for a given timeframe */
var(Targeting) float fIgnoreDist;
/** Number of seconds to wait after a player is known to have gone out of range before again considering him as a target */
var(Targeting) float fIgnoreTimeout;
/** Number of seconds to wait after a player has regained ignoreable status before he can be ignored by the system again */
var(Targeting) float fIgnoreReturnTimeout;
/** Weight added to pawns inside of our defend arae */
var(Targeting) float TargetInDefendAreaWeight;
/** If our current target was inside the defend area, but leaves, he is considered to still be in our defend area for this period of time Misc Attack */
var(Targeting) float CurrentTargetWasInDefendAreaTimeOut;
var(Attack) const float MinHitAndRunStartDist;
var(Attack) const float AttackTooCloseDistance;
var(Attack) const float AttackNearDistance;
var(Attack) const float AttackMediumDistance;
var(Attack) const float MinSquadMembersForHitAndRun;
var(Attack) const float PreventCloseTheGapPercentage;
var(Attack) const FloatDifficulty CATAnimationChancePercentage;
var(Attack) const float MaxDistanceBetweenCylinderEdgesForHitConnectionWithPlayer;
var(Attack) const float MaxDistanceBetweenCylinderEdgesForHitConnectionWithOther;
var(Resurrection) const FloatDifficulty DisabledTime;
var(Resurrection) const FloatDifficulty HeadHealthPercent;
var(Resurrection) const FloatDifficulty RecoveryRate;
var(Regeneration) const FloatDifficulty ArmDisabledTime;
var(Regeneration) const FloatDifficulty GroundHeadHealth;
/** Player must shoot from within this distance for head health Damage defaults */
var(Regeneration) const FloatDifficulty GroundHeadDist;
var(Damage) const FloatDifficulty BiteDamage;
var(Damage) const FloatDifficulty CloseGapDamage;
var(Damage) const FloatDifficulty HitAndRunDamage;
/** var(Damage)constFloatDifficultyMaulDamage; */
var(Damage) const FloatDifficulty MiniGameDamage;
/** var(Damage)constFloatDifficultyPlayerMaulDamage;var(Damage)constFloatDifficultySlamDamage; */
var(Damage) const FloatDifficulty SmashDamage;
var(Damage) const FloatDifficulty SuperDamage;
var(Damage) const FloatDifficulty SwipeDamage;
/** Multiplier indicating how much to scale damage versus non-player pawns END Damage Defaults Concentrated Hit Reactions Defaults */
var(Damage) const FloatDifficulty NonPlayerDamageMultiplier;
/** maximum amount of time that mmg fire to the chest will cause the werewolf to stagger */
var(BackDamage) FloatDifficulty RequiredConcentratedBackDamage;
var(BackDamage) FloatDifficulty BackDamageTimeOutInterval;
var(BackDamage) FloatDifficulty BackDamageMinTimeToReset;
var(BackDamage) FloatDifficulty BackDamageMaxTimeToReset;
/** elapsed time at which the concentrated damage counter resets */
var(AnimusDamage) FloatDifficulty AnimusPulseDamageMaxContinuedDamageInterval;
/** minimum amount of time that has to elapse between concentrated hit reactions of the same type */
var(AnimusDamage) FloatDifficulty AnimusPulseDamageMinTimeToReset;
/** maximum amount of time that has to elapse between concentrated hit reactions of the same type */
var(AnimusDamage) FloatDifficulty AnimusPulseDamageMaxTimeToReset;
/** minimum amount of time that has to elapse between concentrated hit reactions of the same type */
var(ArmDamage) FloatDifficulty ArmDamageMinTimeToReset;
/** maximum amount of time that has to elapse between concentrated hit reactions of the same type */
var(ArmDamage) FloatDifficulty ArmDamageMaxTimeToReset;
var(ArmDamage) array<ArmBreakEntry> ArmBreakInfo;
/** minimum amount of time that has to elapse between concentrated hit reactions of the same type */
var(TorsoDamage) FloatDifficulty KnockBackMinTimeToReset;
/** maximum amount of time that has to elapse between concentrated hit reactions of the same type */
var(TorsoDamage) FloatDifficulty KnockBackMaxTimeToReset;
var(TorsoDamage) array<KnockBackEntry> KnockBackInfo;
/** minimum amount of time that has to elapse between concentrated hit reactions of the same type when induced by machine gun fire */
var(TorsoDamage) FloatDifficulty StaggerMinTimeToReset;
/** maximum amount of time that has to elapse between concentrated hit reactions of the same type when induced by machine gun fire */
var(TorsoDamage) FloatDifficulty StaggerMaxTimeToReset;
var(TorsoDamage) array<StaggerBackEntry> StaggerInfo;
/** minimum amount of time that has to elapse between concentrated hit reactions of the same type */
var(HeadDamage) FloatDifficulty HeadDamageMinTimeToReset;
/** maximum amount of time that has to elapse between concentrated hit reactions of the same type */
var(HeadDamage) FloatDifficulty HeadDamageMaxTimeToReset;
var(HeadDamage) array<HeadDamageEntry> HeadDamageInfo;
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
/** Internal use. */
var(Throw) float ThrowSkeletalMeshMinStrengthAdjustment;
/** Internal use. */
var(Throw) float ThrowSkeletalMeshMaxStrengthAdjustment;
/** Internal use. */
var(Throw) float ThrowSkeletalPercentBonesDontAdjust;
var(MinotaurTakeDamageMultiplier) FloatDifficulty minotaurFrontDamageMultiplier;
var(MinotaurTakeDamageMultiplier) FloatDifficulty minotaurBackDamageMultiplier;
var(MinotaurCharge) float minotaurChargeMinDist;
var(MinotaurCharge) float minotaurChargeMaxDist;
var(MinotaurCharge) FloatDifficulty minotaurChargeMinDodgeTime;
var(MinotaurCharge) FloatDifficulty minotaurChargeMaxDodgeTime;
var(MinotaurCharge) FloatDifficulty minotaurChargeDamageDone;
var(MinotaurCharge) float minotaurChargePlayerPushBackSpeed;
var(MinotaurCharge) FloatDifficulty minotaurChargeDistanceToMoveAfterMiss;
var(MinotaurCharge) WWImpactParams minotaurChargeHitEffect;
var(Movement) array<WWDifficultyMovementEntry> MovementStyles;
/** minigame */
var(TMG) float AllignmentFailSafeDot;
var(Roaming) float MinimumDistanceToRoam;
