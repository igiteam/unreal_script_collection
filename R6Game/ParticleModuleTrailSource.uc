class ParticleModuleTrailSource extends ParticleModuleTrailBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

enum ETrail2SourceMethod
{
    PET2SRCM_Default,               // 0
    PET2SRCM_Particle,              // 1
    PET2SRCM_Actor,                 // 2
    PET2SRCM_MAX                    // 3
};

var(Source) ParticleModuleTrailSource.ETrail2SourceMethod SourceMethod;
var(Source) ParticleModule.EParticleSourceSelectionMethod SelectionMethod;
var(Source) noclear export name SourceName;
var(Source) noclear export editinline DistributionFloat SourceStrength;
var(Source) bool bLockSourceStength;
var(Source) bool bInheritRotation;
var(Source) int SourceOffsetCount;
var(Source) editconstarray array<Vector> SourceOffsetDefaults;

defaultproperties
{
    SelectionMethod=1
    // Reference: DistributionFloatConstant'Default__ParticleModuleTrailSource.DistributionSourceStrength'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionSourceStrength" class=Class'DistributionFloatConstant'
        Constant=100.0000000
    end object
    SourceStrength=DistributionSourceStrength
}