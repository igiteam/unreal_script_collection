class SkyMaskedOffsetProfile extends Object
    native;

var() array<MaskedOffsetProfileElement> OffsetElements;
var() name AnimName_Ref;
var() name AnimName_Offset;
var() float RandomWeight;
var() class<SkyWeapon> Weapon;
var SkyOffsetComponentArray OffsetArray;
var array<byte> RequiredBones;
var array<int> BoneToOffset;
var() editoronly const array<name> ExcludedBoneBranches;
