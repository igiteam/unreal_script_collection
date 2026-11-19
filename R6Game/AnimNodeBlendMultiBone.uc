class AnimNodeBlendMultiBone extends AnimNodeBlendBase
    native
    hidecategories(Object,Object,Object);

struct ChildBoneBlendInfo
{
    var array<float> TargetPerBoneWeight;
    var() name InitTargetStartBone;
    var() float InitPerBoneIncrease;
    var const name OldStartBone;
    var const float OldBoneIncrease;
    var transient array<byte> TargetRequiredBones;

    structdefaultproperties
    {
        TargetPerBoneWeight=none
        InitTargetStartBone="None"
        InitPerBoneIncrease=1.0000000
        OldStartBone="None"
        OldBoneIncrease=0.0000000
        TargetRequiredBones=none
    }
};

var() array<ChildBoneBlendInfo> BlendTargetList;
var transient array<byte> SourceRequiredBones;

// Export UAnimNodeBlendMultiBone::execSetTargetStartBone(FFrame&, void* const)
native final function SetTargetStartBone(int TargetIdx, name StartBoneName, optional float PerBoneIncrease);

defaultproperties
{
    Children[0]=(Name="Source",Anim=none,m_iAnimLeafIndex=-1,Weight=1.0000000,DrawY=0,m_AnimNodeName="None",m_bAlwaysTick=false,m_BaseAnimClass=Class'AnimNode')
    Children[1]=(Name="Target",Anim=none,m_iAnimLeafIndex=-1,Weight=0.0000000,DrawY=0,m_AnimNodeName="None",m_bAlwaysTick=false,m_BaseAnimClass=Class'AnimNode')
}