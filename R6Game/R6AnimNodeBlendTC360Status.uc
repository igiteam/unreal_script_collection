class R6AnimNodeBlendTC360Status extends AnimNodeBlendList
    native
    hidecategories(Object,Object,Object,Object);

var transient int m_iEndPoseBlendIndex;
var transient int m_iStartPoseBlendIndex;
var transient bool m_bEndBlendIndexUpdated;
var transient bool m_bBlendOutUpperBody;
var transient bool m_bBlendOutLowerBody;
var transient bool m_bBlendInUpperBody;
var transient bool m_bBlendInLowerBody;
var transient bool m_bPlayArmsWeaponAnim;
var transient bool m_bOnlyBlendUpperBodyPoses;
var transient float m_fUpperBodyBlendOut;
var transient float m_fLowerBodyBlendOut;
var transient float m_fUpperBodyBlendIn;
var transient float m_fLowerBodyBlendIn;

defaultproperties
{
    m_bCannotChangeChildWhileBlending=true
    Children=/* Array type was not detected. */
    bFixNumChildren=true
}