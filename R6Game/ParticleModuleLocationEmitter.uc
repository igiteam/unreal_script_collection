class ParticleModuleLocationEmitter extends ParticleModuleLocationBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

enum ELocationEmitterSelectionMethod
{
    ELESM_Random,                   // 0
    ELESM_Sequential,               // 1
    ELESM_MAX                       // 2
};

var(Location) noclear export name EmitterName;
var(Location) ParticleModuleLocationEmitter.ELocationEmitterSelectionMethod SelectionMethod;
var int iLastSelIndex;
var(Location) bool InheritSourceVelocity;
var(Location) bool bInheritSourceRotation;
var(Location) float InheritSourceVelocityScale;
var(Location) float InheritSourceRotationScale;

// Export UParticleModuleLocationEmitter::execSetLocationEmitter(FFrame&, void* const)
native function SetLocationEmitter(ParticleEmitterInstance InEmitter);

defaultproperties
{
    InheritSourceVelocityScale=1.0000000
    InheritSourceRotationScale=1.0000000
    bSpawnModule=true
}