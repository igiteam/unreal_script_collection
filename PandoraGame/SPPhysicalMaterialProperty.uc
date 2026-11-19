class SPPhysicalMaterialProperty extends PhysicalMaterialPropertyBase
    native
    editinlinenew
    collapsecategories;

enum PawnSoundType
{
    BodyFall,                       // 0
    BodyFallSoft,                   // 1
    CrouchDown,                     // 2
    CrouchStep,                     // 3
    CrouchUp,                       // 4
    FootRun,                        // 5
    FootScuff,                      // 6
    FootStep,                       // 7
    JumpInit,                       // 8
    JumpLand,                       // 9
    PawnSoundType_MAX               // 10
};

enum ParticleAlignment
{
    AlignToNormal,                  // 0
    AlignToIncidence,               // 1
    AlignToReflection,              // 2
    ParticleAlignment_MAX           // 3
};

struct native PawnSoundInfo
{
    /** All sounds that involved a pawn interacting with the material. */
    var() class<SPPawn> PawnClass;
    /** All sounds that involved a pawn interacting with the material. */
    var() SoundCue BodyFall_SoundCue;
    /** All sounds that involved a pawn interacting with the material. */
    var() SoundCue BodyFallSoft_SoundCue;
    /** All sounds that involved a pawn interacting with the material. */
    var() SoundCue CrouchDown_SoundCue;
    /** All sounds that involved a pawn interacting with the material. */
    var() SoundCue CrouchStep_SoundCue;
    /** All sounds that involved a pawn interacting with the material. */
    var() SoundCue CrouchUp_SoundCue;
    /** All sounds that involved a pawn interacting with the material. */
    var() SoundCue FootRun_SoundCue;
    /** All sounds that involved a pawn interacting with the material. */
    var() SoundCue FootScuff_SoundCue;
    /** All sounds that involved a pawn interacting with the material. */
    var() SoundCue FootStep_SoundCue;
    /** All sounds that involved a pawn interacting with the material. */
    var() SoundCue JumpInit_SoundCue;
    /** All sounds that involved a pawn interacting with the material. */
    var() SoundCue JumpLand_SoundCue;

    structdefaultproperties
    {
        PawnClass=none
        BodyFall_SoundCue=none
        BodyFallSoft_SoundCue=none
        CrouchDown_SoundCue=none
        CrouchStep_SoundCue=none
        CrouchUp_SoundCue=none
        FootRun_SoundCue=none
        FootScuff_SoundCue=none
        FootStep_SoundCue=none
        JumpInit_SoundCue=none
        JumpLand_SoundCue=none
    }
};

struct native ImpactSoundInfo
{
    /** Sounds made when something strikes this material. */
    var() class<SPDamageTypeImpactAny> ImpactClass;
    /** Sounds made when something strikes this material. */
    var() SoundCue Impact_SoundCue;

    structdefaultproperties
    {
        ImpactClass=none
        Impact_SoundCue=none
    }
};

struct native ImpactEffectLoopSoundInfo
{
    /** Sounds made when something strikes this material. */
    var() class<SPDamageTypeImpactAny> ImpactClass;
    /** Sounds made when something strikes this material. */
    var() SoundCue Impact_SoundLoopCue;
    /** Sounds made when something strikes this material. */
    var() SoundCue Impact_SoundEndCue;

    structdefaultproperties
    {
        ImpactClass=none
        Impact_SoundLoopCue=none
        Impact_SoundEndCue=none
    }
};

struct native ImpactDecalInfo
{
    /** Decals left when something damages this material. */
    var() class<SPDamageTypeImpactAny> ImpactClass;
    /** Decals left when something damages this material. */
    var() MaterialInterface ImpactDecal_Material;
    /** Decals left when something damages this material. */
    var() float ImpactDecal_Width;
    /** Decals left when something damages this material. */
    var() float ImpactDecal_Height;
    /** Decals left when something damages this material. */
    var() float ImpactDecal_Thickness;
    /** Decals left when something damages this material. */
    var() float ImpactDecal_LifeSpan;
    /** Decals left when something damages this material. */
    var() bool ImpactDecal_bNoClip;

    structdefaultproperties
    {
        ImpactClass=none
        ImpactDecal_Material=none
        ImpactDecal_Width=0.0000000
        ImpactDecal_Height=0.0000000
        ImpactDecal_Thickness=0.0000000
        ImpactDecal_LifeSpan=0.0000000
        ImpactDecal_bNoClip=false
    }
};

struct native ImpactHurtRadiusInfo
{
    /** Hurt radius left when something damages this material. */
    var() class<SPDamageTypeImpactAny> ImpactClass;
    /** Hurt radius left when something damages this material. */
    var() class<PandoraDamageType> ImpactHurtRadius_DamageType;
    /** Hurt radius left when something damages this material. */
    var() float ImpactHurtRadius_LifeSpan;
    /** Hurt radius left when something damages this material. */
    var() float ImpactHurtRadius_BaseDamage;
    /** Hurt radius left when something damages this material. */
    var() float ImpactHurtRadius_DamageRadius;

    structdefaultproperties
    {
        ImpactClass=none
        ImpactHurtRadius_DamageType=none
        ImpactHurtRadius_LifeSpan=0.0000000
        ImpactHurtRadius_BaseDamage=0.0000000
        ImpactHurtRadius_DamageRadius=0.0000000
    }
};

struct native ImpactLightInfo
{
    /** Lights left when something damages this material. */
    var() class<SPDamageTypeImpactAny> ImpactClass;
    /** Lights left when something damages this material. */
    var() float ImpactLight_LifeSpan;
    /** Lights left when something damages this material. */
    var() float ImpactLight_Brightness;
    /** Lights left when something damages this material. */
    var() float ImpactLight_Radius;
    /** Lights left when something damages this material. */
    var() byte ImpactLight_Red;
    /** Lights left when something damages this material. */
    var() byte ImpactLight_Green;
    /** Lights left when something damages this material. */
    var() byte ImpactLight_Blue;

    structdefaultproperties
    {
        ImpactClass=none
        ImpactLight_LifeSpan=0.0000000
        ImpactLight_Brightness=0.0000000
        ImpactLight_Radius=0.0000000
        ImpactLight_Red=0
        ImpactLight_Green=0
        ImpactLight_Blue=0
    }
};

struct native ImpactParticlesInfo
{
    var() class<SPDamageTypeImpactAny> ImpactClass;
    var() float ImpactParticles_LifeSpan;
    var() ParticleSystem ImpactParticles_ParticleSystem;
    var() SPPhysicalMaterialProperty.ParticleAlignment ImpactParticles_Alignment;
    var() float ImpactParticles_Scale;
    /** used to support multiple levels of creation. */
    var() int ImpactParticles_CombineLevel;

    structdefaultproperties
    {
        ImpactClass=none
        ImpactParticles_LifeSpan=0.0000000
        ImpactParticles_ParticleSystem=none
        ImpactParticles_Alignment=AlignToNormal
        ImpactParticles_Scale=0.0000000
        ImpactParticles_CombineLevel=0
    }
};

struct native FootStepParticleInfo
{
    var() class<SPPawn> PawnClass;
    var() float LifeSpan;
    var() ParticleSystem ParticleSystem_LowImpact;
    var() ParticleSystem ParticleSystem_MedImpact;
    var() ParticleSystem ParticleSystem_HighImpact;

    structdefaultproperties
    {
        PawnClass=none
        LifeSpan=0.0000000
        ParticleSystem_LowImpact=none
        ParticleSystem_MedImpact=none
        ParticleSystem_HighImpact=none
    }
};

struct native SPPhysicalMaterialParicleSystemParams
{
    var() Vector Location;
    var() AnimNotify_Footstep.eFeetDownImpactStrength Strength;

    structdefaultproperties
    {
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Strength=eFeetDownImpactStrength_Low
    }
};

var() editinline array<editinline PawnSoundInfo> PawnSounds;
var() editinline array<editinline ImpactSoundInfo> ImpactSounds;
var() editinline array<editinline ImpactSoundInfo> ReflectedImpactSounds;
var() editinline array<editinline ImpactSoundInfo> VocalHitReactionSounds;
var() editinline array<editinline ImpactEffectLoopSoundInfo> ImpactEffectLoopSounds;
var() editinline array<editinline ImpactDecalInfo> ImpactDecals;
var() editinline array<editinline ImpactDecalInfo> ReflectedImpactDecals;
var() editinline array<editinline ImpactHurtRadiusInfo> ImpactHurtRadius;
var() editinline array<editinline ImpactLightInfo> ImpactLights;
var() editinline array<editinline ImpactParticlesInfo> ImpactParticles;
var() editinline array<editinline ImpactParticlesInfo> ReflectedImpactParticles;
var() editinline array<editinline FootStepParticleInfo> FootStepParticles;
