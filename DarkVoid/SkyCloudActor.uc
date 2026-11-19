class SkyCloudActor extends Actor
    native
    placeable;

enum ELightingMethod
{
    LM_PerEmitter,                  // 0
    LM_PerCloud,                    // 1
    LM_PerParticle,                 // 2
    LM_MAX                          // 3
};

var() SkyCloudActor.ELightingMethod LightingMethod;
var() const editconst export editinline ParticleSystemComponent PartSysComp;
var() const SkyCloudAsset BaseCloud;
var transient bool bInitialized;
