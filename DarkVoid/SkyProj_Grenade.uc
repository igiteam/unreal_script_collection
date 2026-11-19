class SkyProj_Grenade extends SkyProj_SecondaryItemBase
    native;

struct native GrenadeAltHitPawns
{
    var Pawn Pawn;
    var export editinline ParticleSystemComponent HitEffect;
    var Vector HitDirection;

    structdefaultproperties
    {
        Pawn=none
        HitEffect=none
        HitDirection=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct native SSavedDamage
{
    var Pawn Victim;
    var float SavedDamage;

    structdefaultproperties
    {
        Victim=none
        SavedDamage=0.0000000
    }
};

var deprecated float TimeDecrementPerBounce;
var(Grenade) int NumBouncesToDetonate;
var transient int CurrentNumBounces;
var(Grenade) float BounceAngle;
var(Grenade) float ExpandTime;
var(Grenade) float ShrinkTime;
var float CurrentShrinkTime;
var(Grenade) float ExpandFinalRadius;
var(Grenade) int DamagePerSecond;
var(Grenade) float HinderedSpeed;
var(Grenade) float HoldMaxSizeTime;
var(Sounds) float HinderedAudioSlowmo;
var bool bIsExpanding;
var bool bCanDecrementFuse;
var bool bPlayerTouchedLastFrame;
var float CurrentExpandTime;
var float CurrentHoldMaxSizeTime;
var(Effects) ParticleSystem ExpandEffect;
var export editinline ParticleSystemComponent ExpandEffectComp;
var(Effects) export editinline StaticMeshComponent ExpandEffectMesh;
var(Effects) ParticleSystem DamageEffect;
var array<Pawn> LastVictims;
var(Sounds) SoundCue ExplosionShrinkSound;
var(Sounds) float ExplosionShrinkSoundTime;
var float ExplosionShrinkSoundTimer;
var float FuseDecrementInterval;
var array<GrenadeAltHitPawns> LastTouched;
var array<SSavedDamage> SavedDamages;

simulated event PostBeginPlay()
{
    super(SkyProjectile).PostBeginPlay();
    ExpandEffectComp.SetTemplate(ExpandEffect);
    //return;    
}

// Export USkyProj_Grenade::execReset(FFrame&, void* const)
native simulated function Reset();

// Export USkyProj_Grenade::execInit(FFrame&, void* const)
native function Init(Vector Direction);

// Export USkyProj_Grenade::execExplode(FFrame&, void* const)
native simulated function Explode(Vector HitLocation, Vector HitNormal, optional Actor Other, optional bool bContinueAfterExplosion);

// Export USkyProj_Grenade::execGetDangerRange(FFrame&, void* const)
native function float GetDangerRange();

function ResetCanDecrementFuse()
{
    bCanDecrementFuse = true;
    //return;    
}

function StartDetonateTimer()
{
    TotalDelayLength = ExplodeDelay + (FRand() * ExplodeDelayVariance);
    ThrowStartTime = WorldInfo.TimeSeconds;
    SetTimer(TotalDelayLength, false, 'DetonateTimer');
    //return;    
}
