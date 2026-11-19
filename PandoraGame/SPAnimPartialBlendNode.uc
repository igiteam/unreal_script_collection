class SPAnimPartialBlendNode extends SPAnimBaseNode
    native;

/** Weight scaling for each bone of the skeleton. Must be same size as RefSkeleton of SkeletalMesh. If all 0.0, no animation can ever be drawn from Child2. */
var() array<float> m_blendPerBoneWeight;
/** Used in InitAnim, so you can set up partial blending in the defaultproperties. See SetPartialBlendStartBone. */
var() name m_partialBlendStartBone;
/** Used in InitAnim, so you can set up partial blending in the defaultproperties.  See SetPartialBlendStartBone. */
var() float m_perBoneIncrease;
/** This is a hack to get it so we can have the hip part of the upper body, but the legs (which are children) a part of the lower body */
var(Advanced) array<name> m_singletonBones;
var(Advanced) bool m_bTreatPerBoneIncreaseAsConstantValue;
/** variable only used by the editor for previewing animations */
var() transient bool m_bUsePartialAnims;
var name m_oldStartBone;
var float m_oldBoneIncrease;
var float m_partialChildWeight;
var float m_partialChildWeightTarget;
var array<byte> m_partialChildRequiredBones;
var float m_globalWeightModifier;
