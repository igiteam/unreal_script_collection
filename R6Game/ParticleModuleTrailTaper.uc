class ParticleModuleTrailTaper extends ParticleModuleTrailBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

enum ETrailTaperMethod
{
    PETTM_None,                     // 0
    PETTM_Full,                     // 1
    PETTM_Partial,                  // 2
    PETTM_MAX                       // 3
};

var(Taper) ParticleModuleTrailTaper.ETrailTaperMethod TaperMethod;
var(Taper) noclear export editinline DistributionFloat TaperFactor;

defaultproperties
{
    // Reference: DistributionFloatConstant'Default__ParticleModuleTrailTaper.DistributionTaperFactor'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionTaperFactor" class=Class'DistributionFloatConstant'
        Constant=1.0000000
    end object
    TaperFactor=DistributionTaperFactor
}