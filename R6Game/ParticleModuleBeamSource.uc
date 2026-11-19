class ParticleModuleBeamSource extends ParticleModuleBeamBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var(Source) ParticleModuleBeamBase.Beam2SourceTargetMethod SourceMethod;
var(Source) ParticleModuleBeamBase.Beam2SourceTargetTangentMethod SourceTangentMethod;
var(Source) noclear export name SourceName;
var(Source) bool bSourceAbsolute;
var(Source) bool bLockSource;
var(Source) bool bLockSourceTangent;
var(Source) bool bLockSourceStength;
var(Source) noclear export editinline DistributionVector Source;
var(Source) noclear export editinline DistributionVector SourceTangent;
var(Source) noclear export editinline DistributionFloat SourceStrength;

defaultproperties
{
    // Reference: DistributionVectorConstant'Default__ParticleModuleBeamSource.DistributionSource'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionSource" class=Class'DistributionVectorConstant'
        Constant=(X=50.0000000,Y=50.0000000,Z=50.0000000)
    end object
    Source=DistributionSource
    // Reference: DistributionVectorConstant'Default__ParticleModuleBeamSource.DistributionSourceTangent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionSourceTangent" class=Class'DistributionVectorConstant'
        Constant=(X=1.0000000,Y=0.0000000,Z=0.0000000)
    end object
    SourceTangent=DistributionSourceTangent
    // Reference: DistributionFloatConstant'Default__ParticleModuleBeamSource.DistributionSourceStrength'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionSourceStrength" class=Class'DistributionFloatConstant'
        Constant=25.0000000
    end object
    SourceStrength=DistributionSourceStrength
}