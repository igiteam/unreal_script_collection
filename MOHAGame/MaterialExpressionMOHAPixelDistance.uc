class MaterialExpressionMOHAPixelDistance extends MaterialExpression within Material
    native
    collapsecategories
    hidecategories(Object);

var(Unused) bool bEngineNormalize;
var(Distance) bool bClamp;
var(Distance) float MaxDistance;

defaultproperties
{
    bClamp=true
    MaxDistance=5000.0000000
}