class SkyParticleModuleBeamRandomTarget extends SkyParticleModuleBeamBase
    native
    editinlinenew;

struct native BeamAttachPoint
{
    var Vector Location;
    var name MaterialName;

    structdefaultproperties
    {
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        MaterialName="None"
    }
};

var(RandomTarget) float VerticalFOVRange;
var(RandomTarget) float HorizontalFOVRange;
var(RandomTarget) Vector IntersectExtents;
var(RandomTarget) bool bSpawnOnNoHit;
