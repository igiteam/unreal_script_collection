class EvilCoverRadiusComponent extends EvilRadiusComponent
    hidecategories(Object,EvilRadiusComponent);

var() float CoverRadius;

event float GetPreviewCylinderRadius()
{
    return CoverRadius;
    //return ReturnValue;    
}

defaultproperties
{
    ReplacementPrimitive=none
}