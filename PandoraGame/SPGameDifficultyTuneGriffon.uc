class SPGameDifficultyTuneGriffon extends SPGameDifficultyTune
    native
    editinlinenew;

enum eGriffonSwoopAttackStage
{
    eGSAS_None,                     // 0
    eGSAS_AfterDiveStart,           // 1
    eGSAS_BeforeDiveEnd,            // 2
    eGSAS_AfterAttackRunStart,      // 3
    eGSAS_BeforeReachingTarget,     // 4
    eGSAS_MAX                       // 5
};

enum eGriffonSwoopAttackUnits
{
    eGSAU_Seconds,                  // 0
    eGSAU_UnrealUnits,              // 1
    eGSAU_MAX                       // 2
};

enum eGriffonSwoopAttackAction
{
    eGSAA_ClawsOut,                 // 0
    eGSAA_Scream,                   // 1
    eGSAA_Swipe,                    // 2
    eGSAA_Anticipation,             // 3
    eGSAA_MAX                       // 4
};

struct native GriffonSwoopAction
{
    /** struct DECLARATIONS VARIABLE DECLARATIONS */
    var() SPGameDifficultyTuneGriffon.eGriffonSwoopAttackStage AStage;
    /** struct DECLARATIONS VARIABLE DECLARATIONS */
    var() SPGameDifficultyTuneGriffon.eGriffonSwoopAttackUnits Unit;
    /** struct DECLARATIONS VARIABLE DECLARATIONS */
    var() float Value;
    /** struct DECLARATIONS VARIABLE DECLARATIONS */
    var() SPGameDifficultyTuneGriffon.eGriffonSwoopAttackAction Action;

    structdefaultproperties
    {
        AStage=eGSAS_None
        Unit=eGSAU_Seconds
        Value=0.0000000
        Action=eGSAA_ClawsOut
    }
};

struct native GriffonFootstepParams
{
    /** Swipe=(Stage=eGSA_BeforeReachingTarget,Unit=eGSA_Meters,Value=10.24,eGSA_Swipe); */
    var() const ScreenShakeStruct ShakeParams;
    /** Swipe=(Stage=eGSA_BeforeReachingTarget,Unit=eGSA_Meters,Value=10.24,eGSA_Swipe); */
    var() const float ShakeRadius;
    /** Swipe=(Stage=eGSA_BeforeReachingTarget,Unit=eGSA_Meters,Value=10.24,eGSA_Swipe); */
    var() const float ImpulseAmount;
    /** Swipe=(Stage=eGSA_BeforeReachingTarget,Unit=eGSA_Meters,Value=10.24,eGSA_Swipe); */
    var() const float ImpulseRadius;
    /** Swipe=(Stage=eGSA_BeforeReachingTarget,Unit=eGSA_Meters,Value=10.24,eGSA_Swipe); */
    var() const float ImpulseZOffset;

    structdefaultproperties
    {
        ShakeParams=(TimeToGo=0.0000000,TimeDuration=1.0000000,RotAmplitude=(X=100.0000000,Y=100.0000000,Z=200.0000000),RotFrequency=(X=10.0000000,Y=10.0000000,Z=25.0000000),RotSinOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000),RotParam=(X=ESP_OffsetRandom,Y=ESP_OffsetRandom,Z=ESP_OffsetRandom,Padding=0),LocAmplitude=(X=0.0000000,Y=3.0000000,Z=5.0000000),LocFrequency=(X=1.0000000,Y=10.0000000,Z=20.0000000),LocSinOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000),LocParam=(X=ESP_OffsetRandom,Y=ESP_OffsetRandom,Z=ESP_OffsetRandom,Padding=0),FOVAmplitude=2.0000000,FOVFrequency=5.0000000,FOVSinOffset=0.0000000,FOVParam=ESP_OffsetRandom,OnStopBlendOutTime=1.0000000,Id="None")
        ShakeRadius=0.0000000
        ImpulseAmount=0.0000000
        ImpulseRadius=0.0000000
        ImpulseZOffset=0.0000000
    }
};

/** VARIABLE DECLARATIONS Footstep effects */
var(FootStep) const GriffonFootstepParams LowFootstepEffects;
var(FootStep) const GriffonFootstepParams MediumFootstepEffects;
var(FootStep) const GriffonFootstepParams HighFootstepEffects;
/** Ground Move */
var(GroundMove) const float GroundAccelRate;
var(GroundMove) const float GroundRollRate;
var(GroundMove) const float GroundPitchRate;
var(GroundMove) const float GroundYawRate;
var(GroundMove) const float GroundDesiredFacingSlack;
/** Attack */
var(Attack) const float HornAttackAngleCenter;
var(Attack) const float HornAttackDistMax;
var(Attack) const float HornAttackConnectDist2D;
var(Attack) const float HornAttackConnectHeight;
var(Attack) const FloatDifficulty HornAttackDamage;
var(Attack) const float HornAttackDelay;
var(Attack) const float HornAttackSlackSideAttackAngle;
var(Attack) const float AttackPointConnectDistance;
var(Attack) const FloatDifficulty AttackPointDamage;
var(Attack) const FloatDifficulty HornImpulse;
var(Attack) const float BackupHitValidTime;
var(cat) const float MaxCATRange;
var(HitReaction) const FloatDifficulty DamageDecayRate;
var(HitReaction) const FloatDifficulty ExplosiveDamageDecayRate;
var(HitReaction) const FloatDifficulty DamageThreshold;
var(HitReaction) const FloatDifficulty DamageNPCModifier;
var(HitReaction) const FloatDifficulty HeavyDamageThreshold;
var(HitReaction) const FloatDifficulty LightExplosiveDamageThreshold;
var(HitReaction) const FloatDifficulty ExplosiveDamageThreshold;
/** in seconds */
var(HitReaction) const FloatDifficulty TimeOutTimer;
/** in seconds */
var(HitReaction) const FloatDifficulty HeavyTimeOutTimer;
/** in seconds */
var(HitReaction) const FloatDifficulty LightExplosionTimeOutTimer;
/** in seconds */
var(HitReaction) const FloatDifficulty ExplosionTimeOutTimer;
var(Scream) const FloatDifficulty ScreamDamage;
var(Scream) const FloatDifficulty ScreamRange;
/** Swoop and claw */
var(SwoopAndClaw) float IdealDiveTime;
var(SwoopAndClaw) float IdealDiveHeight;
var(SwoopAndClaw) float IdealClimbTime;
var(SwoopAndClaw) float IdealClimbHeight;
var(SwoopAndClaw) float ConnectDistance;
var(SwoopAndClaw) float IdealFlyByDistance;
var(SwoopAndClaw) float SwoopAndClawDamage;
var(SwoopAndClaw) bool DecreaseDamageWithDistance;
var(SwoopAndClaw) editinline array<editinline GriffonSwoopAction> SwoopAndClawActions;
var(AnimationONLY) const float CGAttackDistMax;
var(AnimationONLY) const float CGFarAttackDistMax;
var(AnimationONLY) const float CGRearedAttackHeightMax;
var(AnimationONLY) const float CGRearedFarAttackHeightMax;
var(AnimationONLY) const float CGRearedFarAttackPercent;
var(AnimationONLY) const float CGRearedAttackPercent;
var(AnimationONLY) const float ScreamAttackRearedHeightMax;
var(AnimationONLY) const float ScreamAttackRearedPercent;
