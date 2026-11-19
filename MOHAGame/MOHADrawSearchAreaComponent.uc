class MOHADrawSearchAreaComponent extends PrimitiveComponent
    native
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() Color innerColor;
var() Color outerColor;
var() int numVerts;
var float maxYaw;
var float minYaw;
var float minPitch;
var float maxPitch;
var float skewHeight;

defaultproperties
{
    innerColor=(R=0,G=255,B=0,A=255)
    outerColor=(R=255,G=0,B=0,A=255)
    numVerts=8
    maxYaw=270.0000000
    minYaw=45.0000000
    minPitch=45.0000000
    maxPitch=60.0000000
    skewHeight=1000.0000000
    HiddenGame=true
}