class EdLayer extends Object
    native
    editinlinenew
    hidecategories(Object);

var() string Desc;
var() bool bVisible;
var() bool bLocked;
var() bool bUseColor;
var() Color DrawColor;
var EdCoordSystem CoordSystem;

defaultproperties
{
    Desc="Layer"
    bVisible=true
    DrawColor=(R=255,G=255,B=255,A=0)
}