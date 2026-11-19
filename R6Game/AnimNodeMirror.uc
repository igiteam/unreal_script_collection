class AnimNodeMirror extends AnimNodeBlendBase
    native
    hidecategories(Object,Object,Object);

var() bool bEnableMirroring;

defaultproperties
{
    bEnableMirroring=true
    Children[0]=(Name="Child",Anim=none,m_iAnimLeafIndex=-1,Weight=1.0000000,DrawY=0,m_AnimNodeName="None",m_bAlwaysTick=false,m_BaseAnimClass=Class'AnimNode')
    bFixNumChildren=true
}