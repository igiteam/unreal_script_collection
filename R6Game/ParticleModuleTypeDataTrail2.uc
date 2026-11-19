class ParticleModuleTypeDataTrail2 extends ParticleModuleTypeDataBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var(Trail) int TessellationFactor;
var float TessellationFactorDistance;
var(Trail) float TessellationStrength;
var(Trail) int TextureTile;
var int Sheets;
var(Trail) int MaxTrailCount;
var(Trail) int MaxParticleInTrailCount;
var(Rendering) bool RenderGeometry;
var(Rendering) bool RenderDirectLine;
var(Rendering) bool RenderLines;
var(Rendering) bool RenderTessellation;

defaultproperties
{
    TessellationFactor=1
    TessellationStrength=25.0000000
    TextureTile=1
    Sheets=1
    MaxTrailCount=1
    RenderGeometry=true
}