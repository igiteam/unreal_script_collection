class SkyAnimOffsetBase extends SkyAnimBlendBase
    native;

var() editoronly const array<name> ExcludedBoneBranches;
var array<byte> RequiredBones;
var() bool bBakeFromAnimations;
var() bool bLocalSpaceOffsets;
var array<int> BoneToOffset;
var SkyOffsetComponentArray OffsetArray;
var float OffsetWeight;
var() name AnimName_Ref;
var() name AnimName_Offset;
