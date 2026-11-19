class ParticleLODLevel extends Object
    native
    editinlinenew
    collapsecategories
    hidecategories(Object);

var const int Level;
var const int LevelSetting;
var bool bEnabled;
var bool ConvertedModules;
var editinline ParticleModuleRequired RequiredModule;
var export editinline array<export editinline ParticleModule> Modules;
var export ParticleModule TypeDataModule;
var native array<ParticleModule> SpawnModules;
var native array<ParticleModule> UpdateModules;
var int PeakActiveParticles;

defaultproperties
{
    bEnabled=true
    ConvertedModules=true
}