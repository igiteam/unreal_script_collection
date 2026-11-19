class AnimNodeBlendDirectional extends AnimNodeBlendBase
    native
    hidecategories(Object,Object,Object);

var() float DirDegreesPerSecond;
var float DirAngle;

defaultproperties
{
    DirDegreesPerSecond=360.0000000
    Children[0]=(Name="Forward",Anim=none,m_iAnimLeafIndex=-1,Weight=1.0000000,DrawY=0,m_AnimNodeName="None",m_bAlwaysTick=false,m_BaseAnimClass=Class'AnimNode')
    Children[1]=(Name="Backward",Anim=none,m_iAnimLeafIndex=-1,Weight=0.0000000,DrawY=0,m_AnimNodeName="None",m_bAlwaysTick=false,m_BaseAnimClass=Class'AnimNode')
    Children[2]=(Name="Left",Anim=none,m_iAnimLeafIndex=-1,Weight=0.0000000,DrawY=0,m_AnimNodeName="None",m_bAlwaysTick=false,m_BaseAnimClass=Class'AnimNode')
    Children[3]=(Name="Right",Anim=none,m_iAnimLeafIndex=-1,Weight=0.0000000,DrawY=0,m_AnimNodeName="None",m_bAlwaysTick=false,m_BaseAnimClass=Class'AnimNode')
    bFixNumChildren=true
}