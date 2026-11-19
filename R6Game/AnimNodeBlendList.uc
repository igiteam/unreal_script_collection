class AnimNodeBlendList extends AnimNodeBlendBase
    native
    hidecategories(Object,Object,Object);

var array<float> TargetWeight;
var float BlendTimeToGo;
var int ActiveChildIndex;
var() bool m_bCannotChangeChildWhileBlending;
var() bool m_bCannotChangeChildBeforeResetWeaponAnim;
var() bool m_bUseNonLinearBlend;
var() bool bPlayActiveChild;
var float m_fBlendLength;

// Export UAnimNodeBlendList::execSetActiveChild(FFrame&, void* const)
native function SetActiveChild(int ChildIndex, float BlendTime);

defaultproperties
{
    Children[0]=(Name="Child1",Anim=none,m_iAnimLeafIndex=-1,Weight=0.0000000,DrawY=0,m_AnimNodeName="None",m_bAlwaysTick=false,m_BaseAnimClass=Class'AnimNode')
}