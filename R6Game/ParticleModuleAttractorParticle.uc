class ParticleModuleAttractorParticle extends ParticleModuleAttractorBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

enum EAttractorParticleSelectionMethod
{
    EAPSM_Random,                   // 0
    EAPSM_Sequential,               // 1
    EAPSM_MAX                       // 2
};

var(Location) noclear export name EmitterName;
var(Attractor) noclear export editinline DistributionFloat Range;
var(Attractor) bool bStrengthByDistance;
var(Attractor) bool bAffectBaseVelocity;
var(Attractor) bool bRenewSource;
var(Attractor) bool bInheritSourceVel;
var(Attractor) noclear export editinline DistributionFloat Strength;
var(Location) ParticleModuleAttractorParticle.EAttractorParticleSelectionMethod SelectionMethod;
var int LastSelIndex;

defaultproperties
{
    // Reference: DistributionFloatConstant'Default__ParticleModuleAttractorParticle.DistributionRange'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionRange" class=Class'DistributionFloatConstant'
    end object
    Range=DistributionRange
    bStrengthByDistance=true
    // Reference: DistributionFloatConstant'Default__ParticleModuleAttractorParticle.DistributionStrength'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionStrength" class=Class'DistributionFloatConstant'
    end object
    Strength=DistributionStrength
    bSpawnModule=true
    bUpdateModule=true
}