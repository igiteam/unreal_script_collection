class R6AnimNodeBlendBodyAndLeftHand extends AnimNodeBlendBase
    native
    hidecategories(Object,Object,Object);

var R6GameEnums.EHandPoseType m_u8BlendTargetHandPose;
var R6GameEnums.EHandPoseType m_u8BlendedHandPose;
var float m_fCurrentBlendTime;

defaultproperties
{
    Children=/* Array type was not detected. */
    bFixNumChildren=true
}