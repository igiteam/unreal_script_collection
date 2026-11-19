class ParticleModuleUberRainImpacts extends ParticleModuleUberBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var(Lifetime) noclear export editinline DistributionFloat Lifetime;
var(Size) noclear export editinline DistributionVector StartSize;
var(Rotation) noclear export editinline DistributionVector StartRotation;
var(Rotation) bool bInheritParent;
var(Size) bool MultiplyX;
var(Size) bool MultiplyY;
var(Size) bool MultiplyZ;
var(Location) noclear export bool bIsUsingCylinder;
var(Location) noclear export bool bPositive_X;
var(Location) noclear export bool bPositive_Y;
var(Location) noclear export bool bPositive_Z;
var(Location) noclear export bool bNegative_X;
var(Location) noclear export bool bNegative_Y;
var(Location) noclear export bool bNegative_Z;
var(Location) noclear export bool bSurfaceOnly;
var(Location) noclear export bool bVelocity;
var(Location) noclear export bool bRadialVelocity;
var(Size) noclear export editinline DistributionVector LifeMultiplier;
var(Location) noclear export editinline DistributionFloat PC_VelocityScale;
var(Location) noclear export editinline DistributionVector PC_StartLocation;
var(Location) noclear export editinline DistributionFloat PC_StartRadius;
var(Location) noclear export editinline DistributionFloat PC_StartHeight;
var(Location) ParticleModuleLocationPrimitiveCylinder.CylinderHeightAxis PC_HeightAxis;
var(Color) noclear export editinline DistributionVector ColorOverLife;
var(Color) noclear export editinline DistributionFloat AlphaOverLife;

defaultproperties
{
    // Reference: DistributionFloatUniform'Default__ParticleModuleUberRainImpacts.DistributionLifetime'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionLifetime" class=Class'DistributionFloatUniform'
    end object
    Lifetime=DistributionLifetime
    // Reference: DistributionVectorUniform'Default__ParticleModuleUberRainImpacts.DistributionStartSize'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionStartSize" class=Class'DistributionVectorUniform'
        Max=(X=1.0000000,Y=1.0000000,Z=1.0000000)
        Min=(X=1.0000000,Y=1.0000000,Z=1.0000000)
    end object
    StartSize=DistributionStartSize
    // Reference: DistributionVectorUniform'Default__ParticleModuleUberRainImpacts.DistributionStartRotation'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionStartRotation" class=Class'DistributionVectorUniform'
        Max=(X=360.0000000,Y=360.0000000,Z=360.0000000)
    end object
    StartRotation=DistributionStartRotation
    MultiplyX=true
    MultiplyY=true
    MultiplyZ=true
    bIsUsingCylinder=true
    bPositive_X=true
    bPositive_Y=true
    bPositive_Z=true
    bNegative_X=true
    bNegative_Y=true
    bNegative_Z=true
    bRadialVelocity=true
    // Reference: DistributionVectorConstant'Default__ParticleModuleUberRainImpacts.DistributionLifeMultiplier'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionLifeMultiplier" class=Class'DistributionVectorConstant'
    end object
    LifeMultiplier=DistributionLifeMultiplier
    // Reference: DistributionFloatConstant'Default__ParticleModuleUberRainImpacts.DistributionPC_VelocityScale'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionPC_VelocityScale" class=Class'DistributionFloatConstant'
        Constant=1.0000000
    end object
    PC_VelocityScale=DistributionPC_VelocityScale
    // Reference: DistributionVectorConstant'Default__ParticleModuleUberRainImpacts.DistributionPC_StartLocation'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionPC_StartLocation" class=Class'DistributionVectorConstant'
    end object
    PC_StartLocation=DistributionPC_StartLocation
    // Reference: DistributionFloatConstant'Default__ParticleModuleUberRainImpacts.DistributionPC_StartRadius'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionPC_StartRadius" class=Class'DistributionFloatConstant'
        Constant=50.0000000
    end object
    PC_StartRadius=DistributionPC_StartRadius
    // Reference: DistributionFloatConstant'Default__ParticleModuleUberRainImpacts.DistributionPC_StartHeight'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionPC_StartHeight" class=Class'DistributionFloatConstant'
        Constant=50.0000000
    end object
    PC_StartHeight=DistributionPC_StartHeight
    PC_HeightAxis=2
    // Reference: DistributionVectorConstantCurve'Default__ParticleModuleUberRainImpacts.DistributionColorOverLife'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionColorOverLife" class=Class'DistributionVectorConstantCurve'
    end object
    ColorOverLife=DistributionColorOverLife
    // Reference: DistributionFloatConstant'Default__ParticleModuleUberRainImpacts.DistributionAlphaOverLife'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionAlphaOverLife" class=Class'DistributionFloatConstant'
        Constant=255.9000000
    end object
    AlphaOverLife=DistributionAlphaOverLife
    bSpawnModule=true
    bUpdateModule=true
    bSupported3DDrawMode=true
}