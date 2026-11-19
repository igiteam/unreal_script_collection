class SPGameDifficultyTune extends Object
    native
    editinlinenew;

enum SPGDOverrideType
{
    SPGDOverride_None,              // 0
    SPGDOverride_Scale,             // 1
    SPGDOverride_ByValue,           // 2
    SPGDOverride_MAX                // 3
};

struct native ScalePerPlatform
{
    var() float consolesScale;
    var() float PCScale;

    structdefaultproperties
    {
        consolesScale=1.0000000
        PCScale=1.0000000
    }
};

struct native ScaleByDifficulty
{
    var() bool bOverrideForCrossPlatform;
    var() float crossPlatformScale;
    var() ScalePerPlatform perPlatformScale;

    structdefaultproperties
    {
        bOverrideForCrossPlatform=true
        crossPlatformScale=1.0000000
        perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)
    }
};

struct native ScaleOverride
{
    var() ScaleByDifficulty Easy;
    var() ScaleByDifficulty Normal;
    var() ScaleByDifficulty Hard;

    structdefaultproperties
    {
        Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))
        Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))
        Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))
    }
};

struct native FloatValPerPlatform
{
    var() float consolesValue;
    var() float PCValue;

    structdefaultproperties
    {
        consolesValue=0.0000000
        PCValue=0.0000000
    }
};

struct native FloatValByDifficulty
{
    var() bool bOverrideForCrossPlatform;
    var() float crossPlatformValue;
    var() FloatValPerPlatform perPlatformValue;

    structdefaultproperties
    {
        bOverrideForCrossPlatform=true
        crossPlatformValue=0.0000000
        perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)
    }
};

struct native FloatValOverride
{
    var() FloatValByDifficulty Easy;
    var() FloatValByDifficulty Normal;
    var() FloatValByDifficulty Hard;

    structdefaultproperties
    {
        Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))
        Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))
        Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))
    }
};

struct native FloatDifficulty
{
    var() float baseValue;
    var() SPGameDifficultyTune.SPGDOverrideType overrideType;
    var() ScaleOverride overrideByScale;
    var() FloatValOverride overrideByValue;

    structdefaultproperties
    {
        baseValue=0.0000000
        overrideType=SPGDOverride_None
        overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)))
        overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)))
    }
};

struct native DifficultyAIPhysicsDamageGroup
{
    var() FloatDifficulty MinDamage;
    var() FloatDifficulty MaxDamage;

    structdefaultproperties
    {
        MinDamage=(baseValue=0.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
        MaxDamage=(baseValue=0.0000000,overrideType=SPGDOverride_None,overrideByScale=(Easy=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformScale=1.0000000,perPlatformScale=(consolesScale=1.0000000,PCScale=1.0000000))),overrideByValue=(Easy=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Normal=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000)),Hard=(bOverrideForCrossPlatform=true,crossPlatformValue=0.0000000,perPlatformValue=(consolesValue=0.0000000,PCValue=0.0000000))))
    }
};

/** VARIABLE DECLARATIONS */
var(Common) const FloatDifficulty HitPoints;
var(Common) const FloatDifficulty HitResetOnCheckpoint;
/** Damage Scales for various weapons Player & NPC */
var(WeaponDamageScales) FloatDifficulty DBS_Ump_Primary;
var(WeaponDamageScales) FloatDifficulty DBS_Ump_Secondary;
var(WeaponDamageScales) FloatDifficulty DBS_SPAssaultRifle_Primary;
var(WeaponDamageScales) FloatDifficulty DBS_SPAssaultRifle_Secondary;
var(WeaponDamageScales) FloatDifficulty DBS_Shotgun_Primary;
var(WeaponDamageScales) FloatDifficulty DBS_Shotgun_Secondary;
var(WeaponDamageScales) FloatDifficulty DBS_FireAxe_Primary;
var(WeaponDamageScales) FloatDifficulty DBS_FireAxe_Secondary;
var(WeaponDamageScales) FloatDifficulty DBS_Saw_Primary;
var(WeaponDamageScales) FloatDifficulty DBS_Saw_Secondary;
var(WeaponDamageScales) FloatDifficulty DBS_Flamethrower_Primary;
var(WeaponDamageScales) FloatDifficulty DBS_Flamethrower_Secondary;
var(WeaponDamageScales) FloatDifficulty DBS_Rocketlauncher_Sole;
var(WeaponDamageScales) FloatDifficulty DBS_Minigun_Sole;
var(WeaponDamageScales) FloatDifficulty DBS_NineMM_Primary;
var(WeaponDamageScales) FloatDifficulty DBS_NineMM_Secondary;
var(WeaponDamageScales) FloatDifficulty DBS_DesertEagle_Primary;
var(WeaponDamageScales) FloatDifficulty DBS_DesertEagle_Secondary;
var(FiredWeaponDamageScales) FloatDifficulty FWDS_Ump_Primary;
var(FiredWeaponDamageScales) FloatDifficulty FWDS_Ump_Secondary;
var(FiredWeaponDamageScales) FloatDifficulty FWDS_SPAssaultRifle_Primary;
var(FiredWeaponDamageScales) FloatDifficulty FWDS_SPAssaultRifle_Secondary;
var(FiredWeaponDamageScales) FloatDifficulty FWDS_Shotgun_Primary;
var(FiredWeaponDamageScales) FloatDifficulty FWDS_Shotgun_Secondary;
var(FiredWeaponDamageScales) FloatDifficulty FWDS_FireAxe_Primary;
var(FiredWeaponDamageScales) FloatDifficulty FWDS_FireAxe_Secondary;
var(FiredWeaponDamageScales) FloatDifficulty FWDS_Saw_Primary;
var(FiredWeaponDamageScales) FloatDifficulty FWDS_Saw_Secondary;
var(FiredWeaponDamageScales) FloatDifficulty FWDS_Flamethrower_Primary;
var(FiredWeaponDamageScales) FloatDifficulty FWDS_Flamethrower_Secondary;
var(FiredWeaponDamageScales) FloatDifficulty FWDS_Rocketlauncher_Sole;
var(FiredWeaponDamageScales) FloatDifficulty FWDS_Minigun_Sole;
var(FiredWeaponDamageScales) FloatDifficulty FWDS_NineMM_Primary;
var(FiredWeaponDamageScales) FloatDifficulty FWDS_NineMM_Secondary;
var(FiredWeaponDamageScales) FloatDifficulty FWDS_DesertEagle_Primary;
var(FiredWeaponDamageScales) FloatDifficulty FWDS_DesertEagle_Secondary;
/** Just change this to run the validation routine. */
var(Common) const bool changeToValidate;
/** poking may get culled out at distance factors LESS than this (distance factor is a % of screen size) */
var(LOD) const float MinDistanceFactorForPoking;
/** poking may get culled out at distance factors GREATER than this (it represents horizontal distance from the center of the screen) */
var(LOD) const float MaxHorizontalDistanceFactorForPoking;
/** poking may get culled out at distance factors GREATER than this (it represents vertical distance from the center of the screen) a structure that is used in conjuction with SPDeathDamageTypeEvaluator.  This structure matches damage types to indices used by the evaluator Damage Levels:  if you have questions about these settings ask Brad */
var(LOD) const float MaxVerticalDistanceFactorForPoking;
var(EvaluatorDamageLevel) const array<DamageTypeConditionMatch> DamageTypeToDamageLevel;
var(AIPhysicsDamage) DifficultyAIPhysicsDamageGroup ScatterDamageParams;
var(AIPhysicsDamage) DifficultyAIPhysicsDamageGroup ThrowDamageParams;
var(AIPhysicsDamage) DifficultyAIPhysicsDamageGroup SmashDamageParams;
var(AIPhysicsDamage) DifficultyAIPhysicsDamageGroup KnockawayDamageParams;
/** scales the impact force of bullet impacts for pawns */
var(Animus) const float AnimusDropped;
var(BulletImpact) const float BulletImpactScale;

// Export USPGameDifficultyTune::execGetFloatValue(FFrame&, void* const)
native function float GetFloatValue(name ParamName);

// Export USPGameDifficultyTune::execGetValue(FFrame&, void* const)
native function float GetValue(const FloatDifficulty Param);

// Export USPGameDifficultyTune::execGetFiredWeaponDamageScale(FFrame&, void* const)
native function float GetFiredWeaponDamageScale(DamageMatrix.WeaponDamageTypes Type);

function float GetHitPoints()
{
    return GetValue(HitPoints);
    //return ReturnValue;    
}
