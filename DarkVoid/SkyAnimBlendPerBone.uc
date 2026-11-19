class SkyAnimBlendPerBone extends SkyAnimBlendBase
    native;

var() const bool bForceLocalSpaceBlend;
var() array<name> BranchStartBoneName;
var array<float> Child2PerBoneWeight;
var array<byte> LocalToCompReqBones;
var float SliderValue;
