class EyeBallAsset extends Object
    native
    editinlinenew
    hidecategories(Object);

var() bool bMoveEyes;
var(Eyes) bool bInvertLookAtAxis;
var(Eyes) bool bInvertUpAxis;
var() float RadiusX;
var() float RadiusY;
var() int LeftEyeMaterialSlotID;
var() int RightEyeMaterialSlotID;
var(Eyes) Object.EAxis LookAtAxis;
var(Eyes) Object.EAxis UpAxis;
var private native Matrix ToCanonical;

defaultproperties
{
    bMoveEyes=true
    bInvertUpAxis=true
    RadiusX=0.2000000
    RadiusY=0.2400000
    LeftEyeMaterialSlotID=1
    LookAtAxis=4
    UpAxis=2
}