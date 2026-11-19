class ParticleModuleOrientationAxisLock extends ParticleModuleOrientationBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

enum EParticleAxisLock
{
    EPAL_NONE,                      // 0
    EPAL_X,                         // 1
    EPAL_Y,                         // 2
    EPAL_Z,                         // 3
    EPAL_NEGATIVE_X,                // 4
    EPAL_NEGATIVE_Y,                // 5
    EPAL_NEGATIVE_Z,                // 6
    EPAL_MAX                        // 7
};

var(Orientation) ParticleModuleOrientationAxisLock.EParticleAxisLock LockAxisFlags;

defaultproperties
{
    bSpawnModule=true
    bUpdateModule=true
}