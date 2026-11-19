class AnimNodeBlendPerBone extends AnimNodeBlend
    native
    hidecategories(Object,Object,Object,Object);

enum EAnimBlendMode
{
    ABM_NoBlend,                    // 0
    ABM_ParentBoneSpace,            // 1
    ABM_ComponentSpace,             // 2
    ABM_MAX                         // 3
};

var() array<float> Child2PerBoneWeight;
var() name InitChild2StartBone;
var() float InitPerBoneIncrease;
var const name OldStartBone;
var const float OldBoneIncrease;
var const array<int> ParentBoneHierarchy;
var transient array<byte> Child1RequiredBones;
var transient array<byte> Child2RequiredBones;
var() AnimNodeBlendPerBone.EAnimBlendMode RotationBlendMode;

// Export UAnimNodeBlendPerBone::execSetChild2StartBone(FFrame&, void* const)
native final function SetChild2StartBone(name StartBoneName, optional float PerBoneIncrease);

defaultproperties
{
    InitPerBoneIncrease=1.0000000
    RotationBlendMode=1
    Children[0]=(Name="Source",Anim=none,m_iAnimLeafIndex=-1,Weight=1.0000000,DrawY=0,m_AnimNodeName="None",m_bAlwaysTick=false,m_BaseAnimClass=Class'AnimNode')
    Children[1]=(Name="Target",Anim=none,m_iAnimLeafIndex=-1,Weight=0.0000000,DrawY=0,m_AnimNodeName="None",m_bAlwaysTick=false,m_BaseAnimClass=Class'AnimNode')
}