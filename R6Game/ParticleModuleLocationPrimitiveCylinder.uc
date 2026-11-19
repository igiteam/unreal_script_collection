class ParticleModuleLocationPrimitiveCylinder extends ParticleModuleLocationPrimitiveBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object,Object);

enum CylinderHeightAxis
{
    PMLPC_HEIGHTAXIS_X,             // 0
    PMLPC_HEIGHTAXIS_Y,             // 1
    PMLPC_HEIGHTAXIS_Z,             // 2
    PMLPC_HEIGHTAXIS_MAX            // 3
};

var(Location) noclear export bool RadialVelocity;
var(Location) noclear export editinline DistributionFloat StartRadius;
var(Location) noclear export editinline DistributionFloat StartHeight;
var(Location) ParticleModuleLocationPrimitiveCylinder.CylinderHeightAxis HeightAxis;

defaultproperties
{
    RadialVelocity=true
    // Reference: DistributionFloatConstant'Default__ParticleModuleLocationPrimitiveCylinder.DistributionStartRadius'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionStartRadius" class=Class'DistributionFloatConstant'
        Constant=50.0000000
    end object
    StartRadius=DistributionStartRadius
    // Reference: DistributionFloatConstant'Default__ParticleModuleLocationPrimitiveCylinder.DistributionStartHeight'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionStartHeight" class=Class'DistributionFloatConstant'
        Constant=50.0000000
    end object
    StartHeight=DistributionStartHeight
    HeightAxis=2
    bSupported3DDrawMode=true
}