class ParticleModuleLocationPrimitiveCone extends ParticleModuleLocationPrimitiveBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object,Object);

var(Location) noclear export bool RadialVelocity;
var(Location) noclear export editinline DistributionFloat TopRadius;
var(Location) noclear export editinline DistributionFloat BottomRadius;
var(Location) noclear export editinline DistributionFloat StartHeight;

defaultproperties
{
    RadialVelocity=true
    // Reference: DistributionFloatConstant'Default__ParticleModuleLocationPrimitiveCone.DistributionTopRadius'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionTopRadius" class=Class'DistributionFloatConstant'
        Constant=50.0000000
    end object
    TopRadius=DistributionTopRadius
    // Reference: DistributionFloatConstant'Default__ParticleModuleLocationPrimitiveCone.DistributionBottomRadius'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionBottomRadius" class=Class'DistributionFloatConstant'
        Constant=50.0000000
    end object
    BottomRadius=DistributionBottomRadius
    // Reference: DistributionFloatConstant'Default__ParticleModuleLocationPrimitiveCone.DistributionStartHeight'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionStartHeight" class=Class'DistributionFloatConstant'
        Constant=50.0000000
    end object
    StartHeight=DistributionStartHeight
    bSupported3DDrawMode=true
}