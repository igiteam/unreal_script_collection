class ParticleModuleTypeDataTrail extends ParticleModuleTypeDataBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var(Trail) bool RenderGeometry;
var(Trail) bool RenderLines;
var(Trail) bool RenderTessellation;
var(Trail) bool Tapered;
var(Trail) bool SpawnByDistance;
var(Trail) int TessellationFactor;
var(Trail) noclear export editinline DistributionFloat Tension;
var(Trail) Vector SpawnDistance;

defaultproperties
{
    RenderGeometry=true
    TessellationFactor=1
    // Reference: DistributionFloatConstant'Default__ParticleModuleTypeDataTrail.DistributionTension'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionTension" class=Class'DistributionFloatConstant'
    end object
    Tension=DistributionTension
    SpawnDistance=(X=5.0000000,Y=5.0000000,Z=5.0000000)
}