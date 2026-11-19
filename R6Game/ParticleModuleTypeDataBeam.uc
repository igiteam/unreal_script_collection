class ParticleModuleTypeDataBeam extends ParticleModuleTypeDataBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

enum EBeamMethod
{
    PEBM_Distance,                  // 0
    PEBM_EndPoints,                 // 1
    PEBM_EndPoints_Interpolated,    // 2
    PEBM_UserSet_EndPoints,         // 3
    PEBM_UserSet_EndPoints_Interpolated,// 4
    PEBM_MAX                        // 5
};

enum EBeamEndPointMethod
{
    PEBEPM_Calculated,              // 0
    PEBEPM_Distribution,            // 1
    PEBEPM_Distribution_Constant,   // 2
    PEBEPM_MAX                      // 3
};

var(Beam) ParticleModuleTypeDataBeam.EBeamMethod BeamMethod;
var(Beam) ParticleModuleTypeDataBeam.EBeamEndPointMethod EndPointMethod;
var(Beam) noclear export editinline DistributionFloat Distance;
var(Beam) noclear export editinline DistributionVector EndPoint;
var(Beam) int TessellationFactor;
var(Beam) noclear export editinline DistributionFloat EmitterStrength;
var(Beam) noclear export editinline DistributionFloat TargetStrength;
var(Beam) noclear export editinline DistributionVector EndPointDirection;
var(Beam) int TextureTile;
var(Beam) bool RenderGeometry;
var(Beam) bool RenderDirectLine;
var(Beam) bool RenderLines;
var(Beam) bool RenderTessellation;

defaultproperties
{
    // Reference: DistributionFloatConstant'Default__ParticleModuleTypeDataBeam.DistributionDistance'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionDistance" class=Class'DistributionFloatConstant'
    end object
    Distance=DistributionDistance
    // Reference: DistributionVectorConstant'Default__ParticleModuleTypeDataBeam.DistributionEndPoint'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionEndPoint" class=Class'DistributionVectorConstant'
    end object
    EndPoint=DistributionEndPoint
    TessellationFactor=1
    // Reference: DistributionFloatConstant'Default__ParticleModuleTypeDataBeam.DistributionEmitterStrength'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionEmitterStrength" class=Class'DistributionFloatConstant'
        Constant=1000.0000000
    end object
    EmitterStrength=DistributionEmitterStrength
    // Reference: DistributionFloatConstant'Default__ParticleModuleTypeDataBeam.DistributionTargetStrength'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionTargetStrength" class=Class'DistributionFloatConstant'
        Constant=1000.0000000
    end object
    TargetStrength=DistributionTargetStrength
    // Reference: DistributionVectorConstant'Default__ParticleModuleTypeDataBeam.DistributionEndPointDirection'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionEndPointDirection" class=Class'DistributionVectorConstant'
        Constant=(X=1.0000000,Y=0.0000000,Z=0.0000000)
    end object
    EndPointDirection=DistributionEndPointDirection
    RenderGeometry=true
    bSpawnModule=true
    bUpdateModule=true
}