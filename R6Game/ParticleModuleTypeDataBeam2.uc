class ParticleModuleTypeDataBeam2 extends ParticleModuleTypeDataBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

enum EBeam2Method
{
    PEB2M_Distance,                 // 0
    PEB2M_Target,                   // 1
    PEB2M_Branch,                   // 2
    PEB2M_MAX                       // 3
};

enum EBeamTaperMethod
{
    PEBTM_None,                     // 0
    PEBTM_Full,                     // 1
    PEBTM_Partial,                  // 2
    PEBTM_MAX                       // 3
};

struct BeamTargetData
{
    var() name TargetName;
    var() float TargetPercentage;

    structdefaultproperties
    {
        TargetName="None"
        TargetPercentage=0.0000000
    }
};

var(Beam) ParticleModuleTypeDataBeam2.EBeam2Method BeamMethod;
var(Taper) ParticleModuleTypeDataBeam2.EBeamTaperMethod TaperMethod;
var int TessellationFactor;
var(Beam) int TextureTile;
var(Beam) float TextureTileDistance;
var(Beam) int Sheets;
var(Beam) int MaxBeamCount;
var(Beam) float Speed;
var(Beam) int InterpolationPoints;
var(Beam) bool bAlwaysOn;
var bool bSourceDirect;
var bool bTargetDirect;
var bool bNoise;
var bool bMoving;
var bool bSmooth;
var bool bNoiseLock;
var(Rendering) bool RenderGeometry;
var(Rendering) bool RenderDirectLine;
var(Rendering) bool RenderLines;
var(Rendering) bool RenderTessellation;
var(Branching) name BranchParentName;
var noclear export editinline DistributionVector Source;
var noclear export editinline DistributionFloat SourceStrength;
var noclear export name SourceName;
var(Distance) noclear export editinline DistributionFloat Distance;
var noclear export editinline DistributionVector Target;
var float LockRadius;
var noclear export editinline DistributionFloat TargetStrength;
var name TargetName;
var array<BeamTargetData> MultipleTargets;
var int Frequency;
var export editinline DistributionVector NoiseRange;
var export editinline DistributionVector NoiseSpeed;
var float NoiseLockTime;
var float NoiseTension;
var(Taper) noclear export editinline DistributionFloat TaperFactor;

defaultproperties
{
    BeamMethod=1
    TessellationFactor=1
    TextureTile=1
    Sheets=1
    Speed=10.0000000
    bTargetDirect=true
    RenderGeometry=true
    // Reference: DistributionVectorConstant'Default__ParticleModuleTypeDataBeam2.DistributionSource'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionSource" class=Class'DistributionVectorConstant'
        Constant=(X=50.0000000,Y=50.0000000,Z=50.0000000)
    end object
    Source=DistributionSource
    // Reference: DistributionFloatConstant'Default__ParticleModuleTypeDataBeam2.DistributionSourceStrength'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionSourceStrength" class=Class'DistributionFloatConstant'
        Constant=25.0000000
    end object
    SourceStrength=DistributionSourceStrength
    // Reference: DistributionFloatConstant'Default__ParticleModuleTypeDataBeam2.DistributionDistance'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionDistance" class=Class'DistributionFloatConstant'
        Constant=25.0000000
    end object
    Distance=DistributionDistance
    // Reference: DistributionVectorConstant'Default__ParticleModuleTypeDataBeam2.DistributionTarget'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionTarget" class=Class'DistributionVectorConstant'
        Constant=(X=50.0000000,Y=50.0000000,Z=50.0000000)
    end object
    Target=DistributionTarget
    LockRadius=10.0000000
    // Reference: DistributionFloatConstant'Default__ParticleModuleTypeDataBeam2.DistributionTargetStrength'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionTargetStrength" class=Class'DistributionFloatConstant'
        Constant=1000.0000000
    end object
    TargetStrength=DistributionTargetStrength
    // Reference: DistributionVectorConstant'Default__ParticleModuleTypeDataBeam2.DistributionNoiseRange'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionNoiseRange" class=Class'DistributionVectorConstant'
        Constant=(X=50.0000000,Y=50.0000000,Z=50.0000000)
    end object
    NoiseRange=DistributionNoiseRange
    // Reference: DistributionVectorConstant'Default__ParticleModuleTypeDataBeam2.DistributionNoiseSpeed'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionNoiseSpeed" class=Class'DistributionVectorConstant'
        Constant=(X=50.0000000,Y=50.0000000,Z=50.0000000)
    end object
    NoiseSpeed=DistributionNoiseSpeed
    NoiseTension=0.5000000
    // Reference: DistributionFloatConstant'Default__ParticleModuleTypeDataBeam2.DistributionTaperFactor'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionTaperFactor" class=Class'DistributionFloatConstant'
        Constant=1.0000000
    end object
    TaperFactor=DistributionTaperFactor
}