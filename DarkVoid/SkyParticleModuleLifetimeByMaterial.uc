class SkyParticleModuleLifetimeByMaterial extends ParticleModuleLifetimeBase
    native
    editinlinenew;

struct native MaterialLifetimeEntry
{
    var() name MaterialName;
    var() RawDistributionFloat Lifetime;

    structdefaultproperties
    {
        MaterialName="None"
        Lifetime=(Distribution=none,Type=0,Op=0,LookupTableNumElements=0,LookupTableChunkSize=0,LookupTable=none,LookupTableTimeScale=0.0000000,LookupTableStartTime=0.0000000)
    }
};

var(Lifetime) array<MaterialLifetimeEntry> MaterialLifeTime;
var(Lifetime) RawDistributionFloat DefaultLifeTime;
