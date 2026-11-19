class SkyParticleModuleTracerVelocity extends ParticleModuleVelocityBase
    native
    editinlinenew;

enum EWeaponUse
{
    WU_Primary,                     // 0
    WU_Secondary,                   // 1
    WU_Aux1,                        // 2
    WU_Aux2,                        // 3
    WU_Aux3,                        // 4
    WU_MAX                          // 5
};

var(Velocity) RawDistributionFloat VelocityMagnitude;
var() SkyParticleModuleTracerVelocity.EWeaponUse WeaponUse;
