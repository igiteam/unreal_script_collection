class AdvAnim_SprintRotator extends AnimNodeBlendBase
    native(Anim)
    hidecategories(Object,Object,Object);

var const transient AdvPawn AdvPawnOwner;
var() float SpeedThreshold;
var transient int LastYaw;

defaultproperties
{
    SpeedThreshold=10.0000000
    Children=/* Array type was not detected. */
    bFixNumChildren=true
}