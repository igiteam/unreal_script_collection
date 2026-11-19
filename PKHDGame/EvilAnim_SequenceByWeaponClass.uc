class EvilAnim_SequenceByWeaponClass extends AnimNodeSequence
    native(Anim)
    hidecategories(Object,Object,Object);

struct native WeaponClassNameInfo
{
    var() class<EvilWeap_Base> WeaponClass;
    var() name AnimName;

    structdefaultproperties
    {
        WeaponClass=none
        AnimName="None"
    }
};

var const transient EvilPawn MyEvilPawn;
var const transient EvilWeap_Base MyEvilWeapon;
var const transient bool bTemporaryHolster;
var(Editor) bool bSynchronizeNodesInEditor;
var() array<WeaponClassNameInfo> WeaponList;
var() name WeaponDefaultAnimName;
var editoronly const float WeaponListSliderPosition;

defaultproperties
{
    bSynchronizeNodesInEditor=true
}