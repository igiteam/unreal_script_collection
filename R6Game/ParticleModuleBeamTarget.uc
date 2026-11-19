class ParticleModuleBeamTarget extends ParticleModuleBeamBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var(Target) ParticleModuleBeamBase.Beam2SourceTargetMethod TargetMethod;
var(Target) ParticleModuleBeamBase.Beam2SourceTargetTangentMethod TargetTangentMethod;
var(Target) name TargetName;
var(Target) noclear export editinline DistributionVector Target;
var(Target) bool bTargetAbsolute;
var(Target) bool bLockTarget;
var(Target) bool bLockTargetTangent;
var(Target) bool bLockTargetStength;
var(Target) noclear export editinline DistributionVector TargetTangent;
var(Target) noclear export editinline DistributionFloat TargetStrength;
var(Target) float LockRadius;

defaultproperties
{
    // Reference: DistributionVectorConstant'Default__ParticleModuleBeamTarget.DistributionTarget'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionTarget" class=Class'DistributionVectorConstant'
        Constant=(X=50.0000000,Y=50.0000000,Z=50.0000000)
    end object
    Target=DistributionTarget
    // Reference: DistributionVectorConstant'Default__ParticleModuleBeamTarget.DistributionTargetTangent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionTargetTangent" class=Class'DistributionVectorConstant'
        Constant=(X=1.0000000,Y=0.0000000,Z=0.0000000)
    end object
    TargetTangent=DistributionTargetTangent
    // Reference: DistributionFloatConstant'Default__ParticleModuleBeamTarget.DistributionTargetStrength'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionTargetStrength" class=Class'DistributionFloatConstant'
        Constant=25.0000000
    end object
    TargetStrength=DistributionTargetStrength
    LockRadius=10.0000000
}