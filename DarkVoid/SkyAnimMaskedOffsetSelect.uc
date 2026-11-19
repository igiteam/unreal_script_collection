class SkyAnimMaskedOffsetSelect extends SkyAnimBlendBase
    native;

struct native WeightedBranch
{
    var() const name BranchStartBoneName;
    var() const float BranchWeight;

    structdefaultproperties
    {
        BranchStartBoneName="None"
        BranchWeight=0.0000000
    }
};

struct native MaskedOffsetProfileElement
{
    var() const name AnimSequenceName;
    var() const float ActivatePercent;
    var() const float BlendInTime;
    var() const bool bForceLocalSpaceBlend;
    var() const array<WeightedBranch> BoneBranch;

    structdefaultproperties
    {
        AnimSequenceName="None"
        ActivatePercent=0.0000000
        BlendInTime=0.0000000
        bForceLocalSpaceBlend=false
        BoneBranch=none
    }
};

var transient AnimNodeBlend AimBlendNode;
var transient AnimNodeBlend BlendNode;
var transient SkyAnimMaskedOffsetBase MaskedOffsetNode1;
var transient SkyAnimMaskedOffsetBase MaskedOffsetNode2;
var() name AnimName_Ref;
var() bool bBakeFromAnimations;
var() bool bLocalSpaceOffsets;
var() editconst editinline array<editconst editinline SkyMaskedOffsetProfile> Profiles;
var transient int CurrentProfile;
var transient float CurrentPercent;
var() float OffsetStartPercent;
var() float OffsetEndPercent;
var transient int LastProfile;
var transient float LastPercent;
var transient int LastElement;
var editoronly transient float ChildSelectValue;
