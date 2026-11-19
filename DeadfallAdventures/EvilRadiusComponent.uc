class EvilRadiusComponent extends PrimitiveComponent
    native
    hidecategories(Object);

var() float PreviewCylinderRadius;
var export editinline DrawCylinderComponent PreviewCylinder;

event float GetPreviewCylinderRadius()
{
    return PreviewCylinderRadius;
    //return ReturnValue;    
}

defaultproperties
{
    ReplacementPrimitive=none
}