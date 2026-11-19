class ParticleModuleTrailSpawn extends ParticleModuleTrailBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

enum ETrail2SpawnMethod
{
    PET2SM_Emitter,                 // 0
    PET2SM_Velocity,                // 1
    PET2SM_Distance,                // 2
    PET2SM_MAX                      // 3
};

var deprecated ParticleModuleTrailSpawn.ETrail2SpawnMethod SpawnMethod;
var noclear export editinline deprecated DistributionFloat SpawnVelocity;
var deprecated float VelocityScale;
var noclear export editinline deprecated DistributionVector SpawnDistance;
var(Spawn) noclear export editinline DistributionFloatParticleParameter SpawnDistanceMap;
var(Spawn) float MinSpawnVelocity;

defaultproperties
{
    // Reference: DistributionFloatParticleParameter'Default__ParticleModuleTrailSpawn.DistributionSpawnDistanceMap'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionSpawnDistanceMap" class=Class'DistributionFloatParticleParameter'
        MinInput=10.0000000
        MaxInput=100.0000000
        MinOutput=1.0000000
        MaxOutput=5.0000000
        Constant=1.0000000
    end object
    SpawnDistanceMap=DistributionSpawnDistanceMap
}