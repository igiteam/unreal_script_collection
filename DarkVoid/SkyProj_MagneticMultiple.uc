class SkyProj_MagneticMultiple extends SkyProj_MagneticAirProj
    native;

var(MultiProj) int SplitCount;
var(MultiProj) float SplitDelay;
var Rotator LaunchDir;
var float SplitTime;
var(MultiProj) float MaxSplitTime;
var int SplitIndex;
var(Effects) ParticleSystem SplitEffect;
var(Effects) ParticleSystem SplitFlightEffect;
var(Effects) ParticleSystem LaunchEffect;
var export editinline ParticleSystemComponent SplitEffectComp;
var export editinline ParticleSystemComponent SplitFlightComp;
var export editinline ParticleSystemComponent LaunchEffectComp;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    SetTimer(SplitDelay, false, 'SplitProj');
    //return;    
}

simulated event InitSplitProj(Vector Dir)
{
    Init(Dir);
    //return;    
}

// Export USkyProj_MagneticMultiple::execSplitProj(FFrame&, void* const)
native function SplitProj();

simulated function SpawnFlightEffects()
{
    super(SkyProjectile).SpawnFlightEffects();
    // End:0x56
    if(SplitTime < float(0))
    {
        AttachComponent(LaunchEffectComp);
        LaunchEffectComp.SetTemplate(LaunchEffect);
        LaunchEffectComp.bUpdateComponentInTick = true;
        LaunchEffectComp.ActivateSystem();
    }
    //return;    
}
