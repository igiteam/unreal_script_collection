class ParticleModuleLocationPrimitiveLine extends ParticleModuleLocationPrimitiveBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object,Object);

var(Location) noclear export bool RadialVelocity;
var(Location) noclear export editinline DistributionVector Begin;
var(Location) noclear export editinline DistributionVector End;

defaultproperties
{
    RadialVelocity=true
    // Reference: DistributionVectorConstant'Default__ParticleModuleLocationPrimitiveLine.DistributionBegin'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionBegin" class=Class'DistributionVectorConstant'
    end object
    Begin=DistributionBegin
    // Reference: DistributionVectorConstant'Default__ParticleModuleLocationPrimitiveLine.DistributionEnd'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionEnd" class=Class'DistributionVectorConstant'
    end object
    End=DistributionEnd
    bSupported3DDrawMode=true
}