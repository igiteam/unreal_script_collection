class SkyProj_Grenade_Alt extends SkyProj_SecondaryItemBase
    native;

var(Grenade_Alt) float TimeDecrementPerBounce;
var(Grenade_Alt) float ExpandTime;
var(Grenade_Alt) float ExpandFinalRadius;
var(Grenade_Alt) int DamagePerSecond;
var(Grenade_Alt) float HinderedSpeed;
var(Sounds) float HinderedAudioSlowmo;
var bool bIsExpanding;
var bool bCanDecrementFuse;
var bool bPlayerTouchedLastFrame;
var float CurrentExpandTime;
var(Effects) ParticleSystem ExpandEffect;
var export editinline ParticleSystemComponent ExpandEffectComp;
var(Effects) export editinline StaticMeshComponent ExpandEffectMesh;
var(Effects) ParticleSystem DamageEffect;
var float FuseDecrementInterval;
var array<GrenadeAltHitPawns> LastTouched;

simulated event PostBeginPlay()
{
    super(SkyProjectile).PostBeginPlay();
    ExpandEffectComp.SetTemplate(ExpandEffect);
    //return;    
}

function ResetCanDecrementFuse()
{
    bCanDecrementFuse = true;
    //return;    
}
