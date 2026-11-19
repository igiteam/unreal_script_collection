class AnimNodeBlend extends AnimNodeBlendBase
    native
    hidecategories(Object,Object,Object);

var float Child2Weight;
var float Child2WeightTarget;
var float BlendTimeToGo;

// Export UAnimNodeBlend::execSetBlendTarget(FFrame&, void* const)
native final function SetBlendTarget(float BlendTarget, float BlendTime);

defaultproperties
{
    Children[0]=(Name="Child1",Anim=none,m_iAnimLeafIndex=-1,Weight=1.0000000,DrawY=0,m_AnimNodeName="None",m_bAlwaysTick=false,m_BaseAnimClass=Class'AnimNode')
    Children[1]=(Name="Child2",Anim=none,m_iAnimLeafIndex=-1,Weight=0.0000000,DrawY=0,m_AnimNodeName="None",m_bAlwaysTick=false,m_BaseAnimClass=Class'AnimNode')
    bFixNumChildren=true
}