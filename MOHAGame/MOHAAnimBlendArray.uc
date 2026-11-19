class MOHAAnimBlendArray extends AnimNodeBlendBase
    native
    hidecategories(Object,Object);

var private native float BlendValue;
var native int foundLeftIdx;
var native int foundRightIdx;
var() bool bSphericalRootMotion;
var private native transient float SharedRootFrameTime;
var private native transient float UnSharedRootFrameTime;
var private transient array<Quat> BlendAnimsRootQuatCS;
var() editinline array<editinline float> AnimInfo;

defaultproperties
{
    AnimInfo[0]=0.0000000
    AnimInfo[1]=0.5000000
    Children=/* Array type was not detected. */
}