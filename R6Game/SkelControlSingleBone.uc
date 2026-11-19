class SkelControlSingleBone extends SkelControlBase
    native
    hidecategories(Object);

var(Translation) bool bApplyTranslation;
var(Translation) bool bAddTranslation;
var(Rotation) bool bApplyRotation;
var(Rotation) bool bAddRotation;
var(Translation) Vector BoneTranslation;
var(Translation) SkelControlBase.EBoneControlSpace BoneTranslationSpace;
var(Rotation) SkelControlBase.EBoneControlSpace BoneRotationSpace;
var(Translation) name TranslationSpaceBoneName;
var(Rotation) Rotator BoneRotation;
var(Rotation) name RotationSpaceBoneName;
